// Sovereign Native Kernel — Zig SIMD Implementation
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0
//
// Production native kernel with explicit SIMD vectorization.
// C ABI compatible for Python CFFI binding.
// Zero runtime dependencies — dry-compile to attestable binary.
//
// Build: zig build -Doptimize=ReleaseFast
// Produces deterministic binary for QSHA manifest signing.

const std = @import("std");

// ─────────────────────────────────────────────────────────────────────────────
// SovereignTensor — Native SIMD tensor structure
// ─────────────────────────────────────────────────────────────────────────────

pub const SovereignTensor = struct {
    data: []f32,
    shape: []const usize,
    resonance: f32,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, shape: []const usize, resonance: f32) !SovereignTensor {
        var total: usize = 1;
        for (shape) |dim| {
            total *= dim;
        }
        const data = try allocator.alloc(f32, total);
        @memset(data, 0.0);
        return SovereignTensor{
            .data = data,
            .shape = shape,
            .resonance = resonance,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *SovereignTensor) void {
        self.allocator.free(self.data);
    }

    pub fn size(self: SovereignTensor) usize {
        return self.data.len;
    }
};

// ─────────────────────────────────────────────────────────────────────────────
// SIMD Vector Operations — 8-wide f32 (256-bit AVX equivalent)
// ─────────────────────────────────────────────────────────────────────────────

const Vec8f32 = @Vector(8, f32);

/// SIMD 8-wide vector addition with scalar tail handling.
/// Maps directly to AVX vaddps / NEON fadd instructions.
pub export fn sovereign_vector_add(
    a_ptr: [*]const f32,
    b_ptr: [*]const f32,
    result_ptr: [*]f32,
    n: usize,
) void {
    var i: usize = 0;

    // 8-wide SIMD loop
    while (i + 8 <= n) : (i += 8) {
        const va: Vec8f32 = a_ptr[i..][0..8].*;
        const vb: Vec8f32 = b_ptr[i..][0..8].*;
        const vr = va + vb;
        result_ptr[i..][0..8].* = vr;
    }

    // Scalar tail
    while (i < n) : (i += 1) {
        result_ptr[i] = a_ptr[i] + b_ptr[i];
    }
}

/// SIMD 8-wide vector multiplication.
pub export fn sovereign_vector_mul(
    a_ptr: [*]const f32,
    b_ptr: [*]const f32,
    result_ptr: [*]f32,
    n: usize,
) void {
    var i: usize = 0;

    while (i + 8 <= n) : (i += 8) {
        const va: Vec8f32 = a_ptr[i..][0..8].*;
        const vb: Vec8f32 = b_ptr[i..][0..8].*;
        const vr = va * vb;
        result_ptr[i..][0..8].* = vr;
    }

    while (i < n) : (i += 1) {
        result_ptr[i] = a_ptr[i] * b_ptr[i];
    }
}

/// SIMD scalar multiplication (broadcast scalar across vector lanes).
pub export fn sovereign_vector_scale(
    a_ptr: [*]const f32,
    scalar: f32,
    result_ptr: [*]f32,
    n: usize,
) void {
    var i: usize = 0;
    const vs: Vec8f32 = @splat(scalar);

    while (i + 8 <= n) : (i += 8) {
        const va: Vec8f32 = a_ptr[i..][0..8].*;
        const vr = va * vs;
        result_ptr[i..][0..8].* = vr;
    }

    while (i < n) : (i += 1) {
        result_ptr[i] = a_ptr[i] * scalar;
    }
}

/// Fused multiply-add: result[i] = a[i] * b[i] + c[i]
/// Uses @mulAdd for hardware FMA when available.
pub export fn sovereign_vector_fma(
    a_ptr: [*]const f32,
    b_ptr: [*]const f32,
    c_ptr: [*]const f32,
    result_ptr: [*]f32,
    n: usize,
) void {
    var i: usize = 0;

    while (i + 8 <= n) : (i += 8) {
        const va: Vec8f32 = a_ptr[i..][0..8].*;
        const vb: Vec8f32 = b_ptr[i..][0..8].*;
        const vc: Vec8f32 = c_ptr[i..][0..8].*;
        const vr = @mulAdd(Vec8f32, va, vb, vc);
        result_ptr[i..][0..8].* = vr;
    }

    while (i < n) : (i += 1) {
        result_ptr[i] = @mulAdd(f32, a_ptr[i], b_ptr[i], c_ptr[i]);
    }
}

/// SIMD dot product with 8-wide accumulation.
pub export fn sovereign_vector_dot(
    a_ptr: [*]const f32,
    b_ptr: [*]const f32,
    n: usize,
) f32 {
    var i: usize = 0;
    var acc: Vec8f32 = @splat(0.0);

    while (i + 8 <= n) : (i += 8) {
        const va: Vec8f32 = a_ptr[i..][0..8].*;
        const vb: Vec8f32 = b_ptr[i..][0..8].*;
        acc = @mulAdd(Vec8f32, va, vb, acc);
    }

    // Horizontal sum of accumulator
    var total: f32 = @reduce(.Add, acc);

    // Scalar tail
    while (i < n) : (i += 1) {
        total += a_ptr[i] * b_ptr[i];
    }

    return total;
}

// ─────────────────────────────────────────────────────────────────────────────
// Resonance Matmul — SIMD inner loop with resonance weighting
// ─────────────────────────────────────────────────────────────────────────────

/// Resonance-weighted matrix multiplication.
/// C[i,j] = sum_p(A[i,p] * B[p,j]) * resonance_a * resonance_b
///
/// Inner loop uses 8-wide SIMD accumulation for the dot product.
pub export fn sovereign_resonance_matmul(
    a_ptr: [*]const f32,
    b_ptr: [*]const f32,
    result_ptr: [*]f32,
    m: usize,
    k: usize,
    n: usize,
    resonance_a: f32,
    resonance_b: f32,
) void {
    const resonance = resonance_a * resonance_b;

    for (0..m) |i| {
        for (0..n) |j| {
            var acc: f32 = 0.0;
            var p: usize = 0;

            // 8-wide inner loop
            while (p + 8 <= k) : (p += 8) {
                // Gather B column values (strided access)
                const b_vals = Vec8f32{
                    b_ptr[p * n + j],
                    b_ptr[(p + 1) * n + j],
                    b_ptr[(p + 2) * n + j],
                    b_ptr[(p + 3) * n + j],
                    b_ptr[(p + 4) * n + j],
                    b_ptr[(p + 5) * n + j],
                    b_ptr[(p + 6) * n + j],
                    b_ptr[(p + 7) * n + j],
                };
                const a_vals: Vec8f32 = a_ptr[i * k + p ..][0..8].*;
                const prod = a_vals * b_vals;
                acc += @reduce(.Add, prod);
            }

            // Scalar tail
            while (p < k) : (p += 1) {
                acc += a_ptr[i * k + p] * b_ptr[p * n + j];
            }

            result_ptr[i * n + j] = acc * resonance;
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Resonance Attention Kernel — Native spectral matching
// ─────────────────────────────────────────────────────────────────────────────

/// Resonance attention: computes scores with exponential decay coupling.
/// scores[i] = q[i] * k[i] * scale * exp(-|q[i]*k[i]*scale| * 0.5)
/// Then applies softmax and weighted sum over values.
pub export fn sovereign_resonance_attention(
    q_ptr: [*]const f32,
    k_ptr: [*]const f32,
    v_ptr: [*]const f32,
    output_ptr: [*]f32,
    dim: usize,
) void {
    if (dim == 0) return;

    const scale: f32 = 1.0 / @sqrt(@as(f32, @floatFromInt(dim)));

    // Compute attention scores with resonance decay
    // Use stack buffer for small dims, heap for large
    var scores_buf: [1024]f32 = undefined;
    const scores = if (dim <= 1024) scores_buf[0..dim] else return; // cap at 1024

    var max_score: f32 = -std.math.inf(f32);
    for (0..dim) |i| {
        const dot = q_ptr[i] * k_ptr[i] * scale;
        const resonance = @exp(-@abs(dot) * 0.5);
        scores[i] = dot * resonance;
        if (scores[i] > max_score) max_score = scores[i];
    }

    // Softmax
    var total: f32 = 0.0;
    for (0..dim) |i| {
        scores[i] = @exp(scores[i] - max_score);
        total += scores[i];
    }
    if (total > 0) {
        for (0..dim) |i| {
            scores[i] /= total;
        }
    }

    // Weighted sum over values
    for (0..dim) |i| {
        var sum: f32 = 0.0;
        for (0..dim) |j| {
            sum += scores[j] * v_ptr[j];
        }
        output_ptr[i] = sum;
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Quantization Kernels — INT8 for edge deployment
// ─────────────────────────────────────────────────────────────────────────────

/// Quantize f32 to int8 (symmetric, scale = max_abs / 127).
pub export fn sovereign_quantize_int8(
    input_ptr: [*]const f32,
    output_ptr: [*]i8,
    n: usize,
    scale_out: *f32,
) void {
    // Find max absolute value
    var max_abs: f32 = 0.0;
    for (0..n) |i| {
        const abs_val = @abs(input_ptr[i]);
        if (abs_val > max_abs) max_abs = abs_val;
    }
    if (max_abs == 0.0) max_abs = 1.0;
    scale_out.* = max_abs;

    const inv_scale = 127.0 / max_abs;
    for (0..n) |i| {
        const scaled = input_ptr[i] * inv_scale;
        output_ptr[i] = @intFromFloat(std.math.clamp(scaled, -127.0, 127.0));
    }
}

/// Dequantize int8 back to f32.
pub export fn sovereign_dequantize_int8(
    input_ptr: [*]const i8,
    output_ptr: [*]f32,
    n: usize,
    scale: f32,
) void {
    const factor = scale / 127.0;
    for (0..n) |i| {
        output_ptr[i] = @as(f32, @floatFromInt(input_ptr[i])) * factor;
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helix Weight Initialization
// ─────────────────────────────────────────────────────────────────────────────

/// Generate helix-encoded weights (deterministic, spectral).
pub export fn sovereign_helix_init(
    output_ptr: [*]f32,
    n: usize,
    frequency: f32,
    phase: f32,
    mode: u8, // 0=sin, 1=cos, 2=sin*0.5+0.5
) void {
    for (0..n) |i| {
        const fi: f32 = @floatFromInt(i);
        const angle = fi * frequency + phase;
        output_ptr[i] = switch (mode) {
            0 => @sin(angle),
            1 => @cos(angle),
            2 => @sin(angle * 0.5) * 0.5 + 0.5,
            else => 0.0,
        };
    }
}
