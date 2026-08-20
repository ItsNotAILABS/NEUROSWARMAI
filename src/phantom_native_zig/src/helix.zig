// Helix Encoding Primitives — Sovereign Spectral Transform Engine
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0
//
// Native helix encoding for weight initialization, positional encoding,
// and spectral data compression. Uses SIMD vectorization for throughput.
// Zero dependencies — all trigonometric operations use Zig builtins.

const std = @import("std");

// ─────────────────────────────────────────────────────────────────────────────
// Helix Parameters
// ─────────────────────────────────────────────────────────────────────────────

pub const HelixParams = struct {
    turns: usize,
    phase: f32,
    dimensions: usize,
};

pub const HelixMode = enum(u8) {
    sin = 0,
    cos = 1,
    sin_half = 2,
    cos_half = 3,
    spiral = 4,
};

// ─────────────────────────────────────────────────────────────────────────────
// SIMD Constants
// ─────────────────────────────────────────────────────────────────────────────

const Vec8f32 = @Vector(8, f32);
const pi: f32 = std.math.pi;

// ─────────────────────────────────────────────────────────────────────────────
// Helix Encode — Spectral encoding with phase rotation
// ─────────────────────────────────────────────────────────────────────────────

/// Helix-encode a data vector with rotational phase coupling.
/// Produces a spectral embedding where adjacent values are phase-linked
/// through the helix winding number (turns).
///
/// Output[i] = data[i] * cos(angle) + data[i+1] * sin(angle)
/// where angle = (2π / turns) * (i % turns) + phase
pub fn helix_encode(data: []const f32, params: HelixParams, allocator: std.mem.Allocator) ![]f32 {
    const n = data.len;
    if (n == 0) return &[_]f32{};

    const encoded = try allocator.alloc(f32, n);
    errdefer allocator.free(encoded);

    const turns_f: f32 = @floatFromInt(params.turns);
    const angle_step = 2.0 * pi / turns_f;

    var i: usize = 0;
    while (i < n) : (i += 1) {
        const turn_index: f32 = @floatFromInt(i % params.turns);
        const angle = angle_step * turn_index + params.phase;
        const cos_val = @cos(angle);
        const sin_val = @sin(angle);
        const next_val: f32 = if (i + 1 < n) data[i + 1] else 0.0;
        encoded[i] = data[i] * cos_val + next_val * sin_val;
    }
    return encoded;
}

/// Helix decode — inverse spectral unwinding.
/// Approximate inverse of helix_encode for reconstruction.
pub fn helix_decode(encoded: []const f32, params: HelixParams, allocator: std.mem.Allocator) ![]f32 {
    const n = encoded.len;
    if (n == 0) return &[_]f32{};

    const decoded = try allocator.alloc(f32, n);
    errdefer allocator.free(decoded);

    const turns_f: f32 = @floatFromInt(params.turns);
    const angle_step = 2.0 * pi / turns_f;

    var i: usize = 0;
    while (i < n) : (i += 1) {
        const turn_index: f32 = @floatFromInt(i % params.turns);
        const angle = angle_step * turn_index + params.phase;
        const cos_val = @cos(angle);
        // Approximate inverse: divide by cos (avoid division by zero)
        const safe_cos = if (@abs(cos_val) > 1e-7) cos_val else 1e-7;
        decoded[i] = encoded[i] / safe_cos;
    }
    return decoded;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helix Rotate — SIMD 8-wide rotational transform
// ─────────────────────────────────────────────────────────────────────────────

/// Apply helix rotation in-place using SIMD vectorization.
/// Performs phase-coupled rotation across vector lanes.
/// Each 8-element block is rotated by the helix winding angle.
pub fn helix_rotate(vec: []f32, turns: usize) void {
    if (vec.len == 0 or turns == 0) return;

    const turns_f: f32 = @floatFromInt(turns);
    const angle_step = 2.0 * pi / turns_f;

    var i: usize = 0;
    // 8-wide SIMD rotation
    while (i + 8 <= vec.len) : (i += 8) {
        const v: Vec8f32 = vec[i..][0..8].*;

        // Compute rotation angles for each lane
        const angles = Vec8f32{
            angle_step * @as(f32, @floatFromInt((i + 0) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 1) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 2) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 3) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 4) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 5) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 6) % turns)),
            angle_step * @as(f32, @floatFromInt((i + 7) % turns)),
        };

        // Element-wise cos rotation
        const cos_vals = Vec8f32{
            @cos(angles[0]),
            @cos(angles[1]),
            @cos(angles[2]),
            @cos(angles[3]),
            @cos(angles[4]),
            @cos(angles[5]),
            @cos(angles[6]),
            @cos(angles[7]),
        };

        vec[i..][0..8].* = v * cos_vals;
    }

    // Scalar tail
    while (i < vec.len) : (i += 1) {
        const angle = angle_step * @as(f32, @floatFromInt(i % turns));
        vec[i] *= @cos(angle);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helix Positional Encoding — For transformer-style architectures
// ─────────────────────────────────────────────────────────────────────────────

/// Generate helix positional encodings for a sequence.
/// Produces interleaved sin/cos patterns with helical winding.
/// More spectrally rich than standard sinusoidal PE.
pub fn helix_positional_encode(
    seq_len: usize,
    d_model: usize,
    allocator: std.mem.Allocator,
) ![]f32 {
    const total = seq_len * d_model;
    const pe = try allocator.alloc(f32, total);
    errdefer allocator.free(pe);

    for (0..seq_len) |pos| {
        const pos_f: f32 = @floatFromInt(pos);
        for (0..d_model) |dim| {
            const dim_f: f32 = @floatFromInt(dim);
            const d_model_f: f32 = @floatFromInt(d_model);
            const freq = 1.0 / std.math.pow(f32, 10000.0, 2.0 * dim_f / d_model_f);
            const angle = pos_f * freq;

            // Helix winding adds spectral richness
            const helix_offset = 2.0 * pi * dim_f / d_model_f;

            if (dim % 2 == 0) {
                pe[pos * d_model + dim] = @sin(angle + helix_offset);
            } else {
                pe[pos * d_model + dim] = @cos(angle + helix_offset);
            }
        }
    }
    return pe;
}

// ─────────────────────────────────────────────────────────────────────────────
// Helix Weight Init — C ABI export for external binding
// ─────────────────────────────────────────────────────────────────────────────

/// Generate helix-encoded weight vector (C ABI export).
/// Deterministic initialization for QSHA manifest signing.
pub export fn helix_init_weights(
    output_ptr: [*]f32,
    n: usize,
    turns: usize,
    phase: f32,
    mode: u8,
) void {
    const turns_f: f32 = @floatFromInt(turns);
    const angle_step = 2.0 * pi / turns_f;

    for (0..n) |i| {
        const turn_index: f32 = @floatFromInt(i % turns);
        const angle = angle_step * turn_index + phase;

        output_ptr[i] = switch (@as(HelixMode, @enumFromInt(mode))) {
            .sin => @sin(angle),
            .cos => @cos(angle),
            .sin_half => @sin(angle) * 0.5 + 0.5,
            .cos_half => @cos(angle) * 0.5 + 0.5,
            .spiral => @sin(angle) * @as(f32, @floatFromInt(i)) / @as(f32, @floatFromInt(n)),
        };
    }
}

/// Compute helix spectral energy (norm of encoded vector).
pub fn helix_energy(data: []const f32) f32 {
    var energy: f32 = 0.0;
    var i: usize = 0;

    // SIMD accumulation
    var acc: Vec8f32 = @splat(0.0);
    while (i + 8 <= data.len) : (i += 8) {
        const v: Vec8f32 = data[i..][0..8].*;
        acc = @mulAdd(Vec8f32, v, v, acc);
    }
    energy = @reduce(.Add, acc);

    // Scalar tail
    while (i < data.len) : (i += 1) {
        energy += data[i] * data[i];
    }

    return @sqrt(energy);
}
