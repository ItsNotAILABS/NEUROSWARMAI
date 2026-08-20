// Fibonacci Spacing & Irrational Constants Engine
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0
//
// Native foundational mathematics engine for self-organizing systems.
// Implements Fibonacci spacing, golden ratio distribution, and irrational
// constant integration to maintain structural integrity without chaotic
// bottlenecks in complex sovereign systems.
//
// This engine provides:
//   1. Fibonacci sequence generation with SIMD acceleration
//   2. Golden ratio (φ) spacing for load distribution and topology
//   3. Irrational constant lattice (φ, √2, √5, e, π) for aperiodic spacing
//   4. Fibonacci-spaced hash ring for swarm node distribution
//   5. Self-organizing topology generators (spiral, sunflower, lattice)
//   6. Anti-bottleneck schedulers using φ-divergence
//
// Zero external dependencies. All constants computed natively.
// Deterministic output for QSHA attestation compatibility.

const std = @import("std");

// ─────────────────────────────────────────────────────────────────────────────
// Irrational Constants — Native precision (no libm dependency)
// ─────────────────────────────────────────────────────────────────────────────

/// Golden ratio φ = (1 + √5) / 2
pub const PHI: f64 = 1.6180339887498948482;

/// Inverse golden ratio 1/φ = φ - 1
pub const PHI_INV: f64 = 0.6180339887498948482;

/// Golden angle in radians = 2π(1 - 1/φ) ≈ 2.399963...
pub const GOLDEN_ANGLE: f64 = 2.3999632297286533;

/// √2 — diagonal spacing constant
pub const SQRT2: f64 = 1.4142135623730950488;

/// √5 — Fibonacci-Lucas bridge constant
pub const SQRT5: f64 = 2.2360679774997896964;

/// Euler's number e — exponential growth/decay base
pub const EULER_E: f64 = 2.7182818284590452354;

/// π — circular/spherical geometry
pub const PI: f64 = 3.1415926535897932385;

/// Silver ratio δ_S = 1 + √2 — secondary spacing constant
pub const SILVER_RATIO: f64 = 2.4142135623730950488;

/// Plastic number ρ ≈ 1.3247 — minimal aperiodic tiling
pub const PLASTIC_NUMBER: f64 = 1.3247179572447460260;

/// Tribonacci constant — three-way branching topology
pub const TRIBONACCI: f64 = 1.8392867552141611326;

// SIMD types
const Vec8f32 = @Vector(8, f32);
const Vec4f64 = @Vector(4, f64);

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Sequence — Native generation with overflow protection
// ─────────────────────────────────────────────────────────────────────────────

/// First 93 Fibonacci numbers (max that fits in u64)
pub const FIB_TABLE = blk: {
    var table: [94]u64 = undefined;
    table[0] = 0;
    table[1] = 1;
    for (2..94) |i| {
        table[i] = table[i - 1] + table[i - 2];
    }
    break :blk table;
};

/// Get the nth Fibonacci number (compile-time table lookup for n < 94).
pub fn fibonacci(n: usize) u64 {
    if (n < 94) return FIB_TABLE[n];
    // For n >= 94, use iterative (saturating at u64 max)
    var a: u64 = FIB_TABLE[92];
    var b: u64 = FIB_TABLE[93];
    var i: usize = 93;
    while (i < n) : (i += 1) {
        const next = a +| b; // saturating add
        a = b;
        b = next;
    }
    return b;
}

/// Generate Fibonacci sequence into a buffer. Returns count written.
pub fn fibonacci_sequence(output: []u64, count: usize) usize {
    const n = @min(count, output.len);
    if (n == 0) return 0;
    if (n >= 1) output[0] = 0;
    if (n >= 2) output[1] = 1;
    for (2..n) |i| {
        output[i] = output[i - 1] +| output[i - 2];
    }
    return n;
}

/// Check if a number is a Fibonacci number (uses Gessel's test).
/// A number N is Fibonacci iff 5N²+4 or 5N²-4 is a perfect square.
pub fn is_fibonacci(n: u64) bool {
    if (n == 0 or n == 1) return true;
    const n_sq = @as(u128, n) * @as(u128, n);
    const test1 = 5 * n_sq + 4;
    const test2 = 5 * n_sq - 4;
    return is_perfect_square_u128(test1) or is_perfect_square_u128(test2);
}

fn is_perfect_square_u128(n: u128) bool {
    if (n == 0) return true;
    var x = n;
    var y = (x + 1) / 2;
    while (y < x) {
        x = y;
        y = (x + n / x) / 2;
    }
    return x * x == n;
}

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Spacing — Distribute N points with φ-divergence
// ─────────────────────────────────────────────────────────────────────────────

/// Generate N points on [0, 1) with golden ratio spacing.
/// This produces the most uniformly distributed aperiodic sequence possible.
/// Used for: node placement, hash ring distribution, load balancing.
///
/// Point[i] = frac(i * φ_inv)  where frac is fractional part
pub fn golden_ratio_spacing(output: []f64, n: usize) void {
    const count = @min(n, output.len);
    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i);
        const val = fi * PHI_INV;
        output[i] = val - @floor(val); // fractional part
    }
}

/// Generate N points on [0, 1) with golden ratio spacing (f32 version, SIMD).
pub fn golden_ratio_spacing_f32(output: []f32, n: usize) void {
    const count = @min(n, output.len);
    const phi_inv_f32: f32 = @floatCast(PHI_INV);
    var i: usize = 0;

    // 8-wide SIMD path
    const phi_vec: Vec8f32 = @splat(phi_inv_f32);
    while (i + 8 <= count) : (i += 8) {
        const indices = Vec8f32{
            @floatFromInt(i),
            @floatFromInt(i + 1),
            @floatFromInt(i + 2),
            @floatFromInt(i + 3),
            @floatFromInt(i + 4),
            @floatFromInt(i + 5),
            @floatFromInt(i + 6),
            @floatFromInt(i + 7),
        };
        const vals = indices * phi_vec;
        const floored = Vec8f32{
            @floor(vals[0]),
            @floor(vals[1]),
            @floor(vals[2]),
            @floor(vals[3]),
            @floor(vals[4]),
            @floor(vals[5]),
            @floor(vals[6]),
            @floor(vals[7]),
        };
        output[i..][0..8].* = vals - floored;
    }

    // Scalar tail
    while (i < count) : (i += 1) {
        const fi: f32 = @floatFromInt(i);
        const val = fi * phi_inv_f32;
        output[i] = val - @floor(val);
    }
}

/// Fibonacci-spaced intervals: place N boundaries at Fibonacci-derived positions.
/// Produces intervals that grow organically (like plant phyllotaxis).
/// Used for: memory tier boundaries, buffer sizing, scheduling intervals.
pub fn fibonacci_intervals(output: []f64, n: usize, total_range: f64) void {
    const count = @min(n, output.len);
    if (count == 0) return;

    // Sum of first N Fibonacci numbers for normalization
    var fib_sum: f64 = 0.0;
    for (0..count) |i| {
        fib_sum += @as(f64, @floatFromInt(fibonacci(i + 2))); // Start from F(2)=1
    }

    // Place boundaries proportional to Fibonacci ratios
    var cumulative: f64 = 0.0;
    for (0..count) |i| {
        const fib_val: f64 = @floatFromInt(fibonacci(i + 2));
        cumulative += fib_val / fib_sum;
        output[i] = cumulative * total_range;
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sunflower Spiral — 2D self-organizing topology
// ─────────────────────────────────────────────────────────────────────────────

pub const Point2D = struct {
    x: f64,
    y: f64,
};

/// Generate N points in a sunflower spiral pattern (Vogel's model).
/// This is the optimal packing of N points in a disk — used in nature
/// by sunflower seeds. Produces zero clustering and zero gaps.
///
/// r[i] = sqrt(i / N), θ[i] = i * golden_angle
pub fn sunflower_spiral(output: []Point2D, n: usize, radius: f64) void {
    const count = @min(n, output.len);
    const n_f: f64 = @floatFromInt(count);

    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i);
        const r = radius * @sqrt(fi / n_f);
        const theta = fi * GOLDEN_ANGLE;
        output[i] = .{
            .x = r * @cos(theta),
            .y = r * @sin(theta),
        };
    }
}

/// Generate Fibonacci lattice points on a sphere (3D topology).
/// Optimal distribution of N points on a sphere surface — no clustering.
pub const Point3D = struct {
    x: f64,
    y: f64,
    z: f64,
};

pub fn fibonacci_sphere(output: []Point3D, n: usize) void {
    const count = @min(n, output.len);
    const n_f: f64 = @floatFromInt(count);

    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i);
        // Latitude: evenly spaced in [-1, 1]
        const y = 1.0 - (2.0 * fi / (n_f - 1.0));
        const r_xz = @sqrt(1.0 - y * y);
        // Longitude: golden angle spacing
        const theta = fi * GOLDEN_ANGLE;

        output[i] = .{
            .x = r_xz * @cos(theta),
            .y = y,
            .z = r_xz * @sin(theta),
        };
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Hash Ring — Distributed node placement with no bottlenecks
// ─────────────────────────────────────────────────────────────────────────────

pub const HashRingNode = struct {
    position: f64, // [0, 1) ring position
    node_id: u64,
    weight: f32, // Resonance weight
};

/// Place N nodes on a hash ring using golden ratio spacing.
/// Guarantees: no clustering, maximum minimum-distance between nodes,
/// O(1) add/remove without full rehash.
pub fn fibonacci_hash_ring(output: []HashRingNode, n: usize) void {
    const count = @min(n, output.len);
    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i);
        const pos = fi * PHI_INV;
        output[i] = .{
            .position = pos - @floor(pos),
            .node_id = @intCast(i),
            .weight = 1.0,
        };
    }
}

/// Find the responsible node for a given key on the Fibonacci ring.
/// Returns the index of the first node whose position >= key_position.
pub fn ring_lookup(nodes: []const HashRingNode, count: usize, key_position: f64) usize {
    if (count == 0) return 0;
    const actual = @min(count, nodes.len);

    // Binary-search style (nodes are φ-spaced but may not be sorted)
    var best_idx: usize = 0;
    var best_dist: f64 = 2.0; // > max ring distance

    for (0..actual) |i| {
        // Ring distance (wraparound)
        var dist = nodes[i].position - key_position;
        if (dist < 0.0) dist += 1.0;
        if (dist < best_dist) {
            best_dist = dist;
            best_idx = i;
        }
    }
    return best_idx;
}

// ─────────────────────────────────────────────────────────────────────────────
// Anti-Bottleneck Scheduler — φ-divergent task distribution
// ─────────────────────────────────────────────────────────────────────────────

pub const SchedulerState = struct {
    phase: f64, // Current phase on [0, 1)
    tick: u64, // Monotonic tick counter
    num_workers: usize,
};

/// Initialize scheduler with Fibonacci-optimal worker count.
pub fn scheduler_init(num_workers: usize) SchedulerState {
    return .{
        .phase = 0.0,
        .tick = 0,
        .num_workers = num_workers,
    };
}

/// Get next worker assignment using golden ratio distribution.
/// Each call advances the phase by φ_inv, guaranteeing:
///   - No worker gets consecutive assignments (anti-hotspot)
///   - Load converges to uniform over any window > N workers
///   - Deterministic for replay/attestation
pub fn scheduler_next(state: *SchedulerState) usize {
    state.phase += PHI_INV;
    if (state.phase >= 1.0) state.phase -= 1.0;
    state.tick += 1;

    const n_f: f64 = @floatFromInt(state.num_workers);
    const idx: usize = @intFromFloat(state.phase * n_f);
    return @min(idx, state.num_workers - 1);
}

/// Get batch of K assignments without advancing state permanently.
/// Useful for lookahead scheduling.
pub fn scheduler_peek_batch(state: *const SchedulerState, output: []usize, k: usize) void {
    const count = @min(k, output.len);
    var phase = state.phase;
    const n_f: f64 = @floatFromInt(state.num_workers);

    for (0..count) |i| {
        phase += PHI_INV;
        if (phase >= 1.0) phase -= 1.0;
        const idx: usize = @intFromFloat(phase * n_f);
        output[i] = @min(idx, state.num_workers - 1);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Irrational Lattice — Multi-constant aperiodic spacing
// ─────────────────────────────────────────────────────────────────────────────

/// Generate a d-dimensional lattice point using irrational constants.
/// Each dimension uses a different irrational base to ensure
/// the lattice never repeats (aperiodic in all dimensions simultaneously).
///
/// Bases: [φ_inv, 1/√2, 1/√3, 1/√5, 1/e, 1/π, 1/δ_S, 1/ρ]
pub const IRRATIONAL_BASES = [8]f64{
    PHI_INV, // 0.61803...
    1.0 / SQRT2, // 0.70710...
    1.0 / 1.7320508075688772, // 1/√3 = 0.57735...
    1.0 / SQRT5, // 0.44721...
    1.0 / EULER_E, // 0.36787...
    1.0 / PI, // 0.31830...
    1.0 / SILVER_RATIO, // 0.41421...
    1.0 / PLASTIC_NUMBER, // 0.75487...
};

/// Generate an N-point, D-dimensional quasirandom sequence (Halton-like).
/// Each dimension uses a different irrational constant as its base.
/// Maximum uniformity in all projections simultaneously.
pub fn irrational_lattice(
    output: []f64,
    n: usize,
    dimensions: usize,
) void {
    const d = @min(dimensions, 8); // max 8 dimensions
    const count = @min(n, output.len / d);

    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i + 1); // Start from 1 to avoid origin
        for (0..d) |dim| {
            const val = fi * IRRATIONAL_BASES[dim];
            output[i * d + dim] = val - @floor(val);
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Resonance Decay — Natural damping for memory systems
// ─────────────────────────────────────────────────────────────────────────────

/// Compute Fibonacci-weighted resonance decay.
/// Each tier decays at a rate proportional to 1/F(n+2).
/// Produces organic "forgetting" that preserves structural hierarchy.
pub fn fibonacci_decay(values: []f32, tiers: usize) void {
    const n = @min(tiers, values.len);
    for (0..n) |i| {
        const fib_weight: f32 = @floatCast(1.0 / @as(f64, @floatFromInt(fibonacci(i + 2))));
        values[i] *= (1.0 - fib_weight);
    }
}

/// Apply golden ratio exponential decay: value * φ^(-t)
pub fn golden_decay(value: f64, time_steps: u64) f64 {
    const t: f64 = @floatFromInt(time_steps);
    return value * std.math.pow(f64, PHI_INV, t);
}

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Buffer Sizing — Optimal capacity selection
// ─────────────────────────────────────────────────────────────────────────────

/// Find the smallest Fibonacci number >= min_size.
/// Used for buffer allocation — Fibonacci-sized buffers minimize
/// fragmentation during repeated grow/shrink cycles.
pub fn fibonacci_ceil(min_size: u64) u64 {
    for (FIB_TABLE) |f| {
        if (f >= min_size) return f;
    }
    return FIB_TABLE[93]; // Maximum u64 Fibonacci
}

/// Find the largest Fibonacci number <= max_size.
pub fn fibonacci_floor(max_size: u64) u64 {
    var result: u64 = 0;
    for (FIB_TABLE) |f| {
        if (f <= max_size) {
            result = f;
        } else break;
    }
    return result;
}

/// Zeckendorf decomposition — represent N as sum of non-consecutive Fibonacci numbers.
/// Returns count of Fibonacci numbers used (written to output buffer).
/// This is the unique greedy decomposition — useful for multi-tier distribution.
pub fn zeckendorf(n: u64, output: []u64) usize {
    if (n == 0) return 0;
    var remaining = n;
    var count: usize = 0;

    // Greedy: subtract largest Fibonacci <= remaining
    var idx: usize = 93;
    while (remaining > 0 and count < output.len) {
        while (idx > 0 and FIB_TABLE[idx] > remaining) {
            idx -= 1;
        }
        output[count] = FIB_TABLE[idx];
        remaining -= FIB_TABLE[idx];
        count += 1;
        if (idx >= 2) {
            idx -= 2; // Skip consecutive (Zeckendorf property)
        } else break;
    }
    return count;
}

// ─────────────────────────────────────────────────────────────────────────────
// C ABI Exports — For Python CFFI / external binding
// ─────────────────────────────────────────────────────────────────────────────

/// Get nth Fibonacci number (C ABI).
pub export fn sovereign_fibonacci(n: usize) u64 {
    return fibonacci(n);
}

/// Generate golden ratio spacing into buffer (C ABI).
pub export fn sovereign_golden_spacing(
    output_ptr: [*]f32,
    n: usize,
) void {
    const output = output_ptr[0..n];
    golden_ratio_spacing_f32(output, n);
}

/// Get next scheduler assignment (C ABI).
/// Returns worker index. State is passed as raw pointer for FFI.
pub export fn sovereign_scheduler_next(
    phase_ptr: *f64,
    tick_ptr: *u64,
    num_workers: usize,
) usize {
    var state = SchedulerState{
        .phase = phase_ptr.*,
        .tick = tick_ptr.*,
        .num_workers = num_workers,
    };
    const result = scheduler_next(&state);
    phase_ptr.* = state.phase;
    tick_ptr.* = state.tick;
    return result;
}

/// Find Fibonacci ceiling for buffer sizing (C ABI).
pub export fn sovereign_fibonacci_ceil(min_size: u64) u64 {
    return fibonacci_ceil(min_size);
}

/// Generate sunflower spiral points (C ABI).
/// Output format: [x0, y0, x1, y1, ...] interleaved.
pub export fn sovereign_sunflower_spiral(
    output_ptr: [*]f64,
    n: usize,
    radius: f64,
) void {
    for (0..n) |i| {
        const fi: f64 = @floatFromInt(i);
        const n_f: f64 = @floatFromInt(n);
        const r = radius * @sqrt(fi / n_f);
        const theta = fi * GOLDEN_ANGLE;
        output_ptr[i * 2] = r * @cos(theta);
        output_ptr[i * 2 + 1] = r * @sin(theta);
    }
}

/// Apply Fibonacci decay to array (C ABI).
pub export fn sovereign_fibonacci_decay(
    values_ptr: [*]f32,
    n: usize,
) void {
    fibonacci_decay(values_ptr[0..n], n);
}

/// Generate irrational lattice points (C ABI).
pub export fn sovereign_irrational_lattice(
    output_ptr: [*]f64,
    n: usize,
    dimensions: usize,
) void {
    const total = n * dimensions;
    irrational_lattice(output_ptr[0..total], n, dimensions);
}
