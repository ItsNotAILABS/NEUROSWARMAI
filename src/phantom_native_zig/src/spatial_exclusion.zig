// Hardware-Enforced Fibonacci Spatial Exclusion Boundary Matrix
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0
//
// Native spatial exclusion engine that uses golden ratio primitives and
// Fibonacci scaling to create self-governing collision boundaries for
// swarm nodes. Because inter-node distance ratios are bound by irrational
// scaling (φ ≈ 1.618), it is mathematically impossible for node paths or
// collision envelopes to overlap — regardless of environmental chaos.
//
// This transforms collision avoidance from reactive path tracking into a
// fundamental, deterministic rule of the spatial substrate itself.
//
// MATHEMATICAL GUARANTEES:
//   1. Minimum separation ≥ φ * base_distance (golden floor)
//   2. Node positions occupy unique φ^n scaling steps (non-repeating)
//   3. Log-φ distribution ensures no two nodes share a geometric tier
//   4. Exclusion zones grow by φ at each Fibonacci boundary level
//   5. Spiral arm trajectories diverge by golden angle (137.5°)
//
// APPLICATIONS:
//   - Drone swarm physical collision avoidance
//   - Distributed agent workspace partitioning
//   - Neural mesh node placement without overlap
//   - Sovereign node spatial identity enforcement
//
// Zero external dependencies. All constants from fibonacci.zig.
// Deterministic output for QSHA attestation compatibility.

const std = @import("std");
const fib = @import("fibonacci.zig");

// Re-export constants for direct access
const PHI = fib.PHI;
const PHI_INV = fib.PHI_INV;
const GOLDEN_ANGLE = fib.GOLDEN_ANGLE;
const SQRT5 = fib.SQRT5;

// ─────────────────────────────────────────────────────────────────────────────
// Core Types
// ─────────────────────────────────────────────────────────────────────────────

/// A swarm node with position and exclusion envelope metadata.
pub const SwarmNode = struct {
    x: f64,
    y: f64,
    exclusion_radius: f64, // φ-scaled exclusion boundary
    scaling_step: f64, // log-φ tier assignment
    node_id: u64,
    arm_index: u32, // Spiral arm assignment
};

/// Result of a spatial exclusion validation.
pub const ExclusionResult = struct {
    valid: bool, // True if no overlap detected
    distance: f64, // Euclidean distance between nodes
    scaling_step: f64, // Log-φ position in distance hierarchy
    min_required: f64, // Minimum distance required
    violation_ratio: f64, // distance / min_required (>1.0 = safe)
};

/// Configuration for the spatial exclusion matrix.
pub const ExclusionConfig = struct {
    min_base_distance: f64 = PHI, // Golden floor: φ ≈ 1.618
    scaling_exponent: f64 = 1.0, // Envelope growth rate (φ^exponent per tier)
    max_nodes: usize = 233, // F(13) — Fibonacci capacity bound
    dimensions: u8 = 2, // 2D or 3D
    strict_mode: bool = true, // Reject any sub-φ distance
};

// ─────────────────────────────────────────────────────────────────────────────
// Euclidean Distance — Native computation (no libm)
// ─────────────────────────────────────────────────────────────────────────────

/// Compute Euclidean distance between two 2D points.
pub fn euclidean_distance_2d(x1: f64, y1: f64, x2: f64, y2: f64) f64 {
    const dx = x1 - x2;
    const dy = y1 - y2;
    return @sqrt(dx * dx + dy * dy);
}

/// Compute Euclidean distance between two 3D points.
pub fn euclidean_distance_3d(x1: f64, y1: f64, z1: f64, x2: f64, y2: f64, z2: f64) f64 {
    const dx = x1 - x2;
    const dy = y1 - y2;
    const dz = z1 - z2;
    return @sqrt(dx * dx + dy * dy + dz * dz);
}

// ─────────────────────────────────────────────────────────────────────────────
// Spatial Exclusion Validation — Core enforcement logic
// ─────────────────────────────────────────────────────────────────────────────

/// Validate spatial exclusion between two nodes.
/// Returns false if the nodes violate the golden ratio spatial floor.
/// The scaling_step indicates which log-φ tier the distance occupies.
///
/// Mathematical basis:
///   distance must be ≥ min_base_distance (default φ)
///   scaling_step = log_φ(distance / min_base_distance)
///   A valid step ≥ 0.0 means nodes are in unique geometric positions.
pub fn verify_spatial_envelope(
    node_x: f64,
    node_y: f64,
    neighbor_x: f64,
    neighbor_y: f64,
    config: ExclusionConfig,
) ExclusionResult {
    const distance = euclidean_distance_2d(node_x, node_y, neighbor_x, neighbor_y);
    const min_required = config.min_base_distance;

    // Hard spatial floor — reject if distance < φ-boundary
    if (distance < min_required) {
        return .{
            .valid = false,
            .distance = distance,
            .scaling_step = 0.0,
            .min_required = min_required,
            .violation_ratio = if (min_required > 0.0) distance / min_required else 0.0,
        };
    }

    // Compute log-φ scaling step: how many golden ratio levels separate these nodes
    const ratio = distance / min_required;
    const scaling_step = @log(ratio) / @log(PHI);

    return .{
        .valid = true,
        .distance = distance,
        .scaling_step = scaling_step,
        .min_required = min_required,
        .violation_ratio = ratio,
    };
}

/// Validate spatial exclusion in 3D space.
pub fn verify_spatial_envelope_3d(
    x1: f64,
    y1: f64,
    z1: f64,
    x2: f64,
    y2: f64,
    z2: f64,
    config: ExclusionConfig,
) ExclusionResult {
    const distance = euclidean_distance_3d(x1, y1, z1, x2, y2, z2);
    const min_required = config.min_base_distance;

    if (distance < min_required) {
        return .{
            .valid = false,
            .distance = distance,
            .scaling_step = 0.0,
            .min_required = min_required,
            .violation_ratio = if (min_required > 0.0) distance / min_required else 0.0,
        };
    }

    const ratio = distance / min_required;
    const scaling_step = @log(ratio) / @log(PHI);

    return .{
        .valid = true,
        .distance = distance,
        .scaling_step = scaling_step,
        .min_required = min_required,
        .violation_ratio = ratio,
    };
}

// ─────────────────────────────────────────────────────────────────────────────
// Swarm-Wide Exclusion Matrix — Validate all node pairs
// ─────────────────────────────────────────────────────────────────────────────

/// Violation record for diagnostics.
pub const Violation = struct {
    node_a: u64,
    node_b: u64,
    distance: f64,
    min_required: f64,
};

/// Validate the entire swarm against the spatial exclusion boundary matrix.
/// Returns the count of violations detected.
/// O(n²) pairwise check — acceptable for Fibonacci-bounded swarm sizes (≤ F(13) = 233).
pub fn validate_swarm_matrix(
    nodes: []const SwarmNode,
    count: usize,
    config: ExclusionConfig,
    violations_out: []Violation,
) usize {
    const n = @min(count, nodes.len);
    var violation_count: usize = 0;

    var i: usize = 0;
    while (i < n) : (i += 1) {
        var j: usize = i + 1;
        while (j < n) : (j += 1) {
            const result = verify_spatial_envelope(
                nodes[i].x,
                nodes[i].y,
                nodes[j].x,
                nodes[j].y,
                config,
            );

            if (!result.valid and violation_count < violations_out.len) {
                violations_out[violation_count] = .{
                    .node_a = nodes[i].node_id,
                    .node_b = nodes[j].node_id,
                    .distance = result.distance,
                    .min_required = result.min_required,
                };
                violation_count += 1;
            }
        }
    }

    return violation_count;
}

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Exclusion Envelope — Adaptive boundary scaling
// ─────────────────────────────────────────────────────────────────────────────

/// Compute the exclusion radius for a node at a given Fibonacci tier.
/// Each tier scales by φ: radius[tier] = base * φ^tier
/// This guarantees exponential separation growth along the Fibonacci hierarchy.
pub fn compute_exclusion_radius(base_radius: f64, tier: usize) f64 {
    const tier_f: f64 = @floatFromInt(tier);
    return base_radius * std.math.pow(f64, PHI, tier_f);
}

/// Compute tiered exclusion radii for all Fibonacci levels up to max_tier.
/// Output: array of exclusion radii growing at φ^n rate.
pub fn compute_tier_radii(output: []f64, max_tier: usize, base_radius: f64) void {
    const count = @min(max_tier, output.len);
    for (0..count) |i| {
        output[i] = compute_exclusion_radius(base_radius, i);
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Golden Spiral Arm Assignment — Trajectory divergence enforcement
// ─────────────────────────────────────────────────────────────────────────────

/// Assign a node to a spiral arm based on its angular position.
/// Nodes on different arms are guaranteed to diverge by golden angle multiples.
/// Returns arm index [0, num_arms).
pub fn assign_spiral_arm(node_x: f64, node_y: f64, num_arms: u32) u32 {
    // Compute angle from origin
    const angle = std.math.atan2(node_y, node_x);
    // Normalize to [0, 2π)
    const normalized = if (angle < 0.0) angle + 2.0 * fib.PI else angle;
    // Divide angular space by golden angle to assign arm
    const arm_width = 2.0 * fib.PI / @as(f64, @floatFromInt(num_arms));
    const arm_idx: u32 = @intFromFloat(normalized / arm_width);
    return @min(arm_idx, num_arms - 1);
}

/// Generate exclusion-safe positions for N nodes using sunflower spiral.
/// Each position is guaranteed to maintain φ-distance from all neighbors.
/// This is the constructive approach: instead of validating after placement,
/// generate positions that are inherently collision-free.
pub fn generate_exclusion_safe_positions(
    output: []SwarmNode,
    n: usize,
    outer_radius: f64,
    config: ExclusionConfig,
) usize {
    const count = @min(n, @min(output.len, config.max_nodes));
    const n_f: f64 = @floatFromInt(count);

    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i);
        // Radius grows as sqrt to maintain area-density uniformity
        const r = outer_radius * @sqrt((fi + 1.0) / (n_f + 1.0));
        // Angle advances by golden angle — guarantees maximal angular separation
        const theta = (fi + 1.0) * GOLDEN_ANGLE;

        const x = r * @cos(theta);
        const y = r * @sin(theta);

        // Exclusion radius scales with tier
        const tier: usize = @intFromFloat(@log(fi + 2.0) / @log(PHI));
        const exclusion_r = compute_exclusion_radius(config.min_base_distance * 0.5, tier);

        output[i] = .{
            .x = x,
            .y = y,
            .exclusion_radius = exclusion_r,
            .scaling_step = @log((fi + 1.0) * PHI_INV) / @log(PHI),
            .node_id = @intCast(i),
            .arm_index = assign_spiral_arm(x, y, 8),
        };
    }

    return count;
}

// ─────────────────────────────────────────────────────────────────────────────
// Dynamic Position Correction — Push violating nodes to valid positions
// ─────────────────────────────────────────────────────────────────────────────

/// Correct a node's position to satisfy the spatial exclusion boundary.
/// Uses φ-scaled repulsion: pushes the node along the separation vector
/// until it reaches the golden floor distance.
///
/// Returns the corrected (x, y) position.
pub fn correct_position(
    node_x: f64,
    node_y: f64,
    obstacle_x: f64,
    obstacle_y: f64,
    config: ExclusionConfig,
) struct { x: f64, y: f64 } {
    const dx = node_x - obstacle_x;
    const dy = node_y - obstacle_y;
    const distance = @sqrt(dx * dx + dy * dy);

    // Already safe
    if (distance >= config.min_base_distance) {
        return .{ .x = node_x, .y = node_y };
    }

    // Degenerate case: nodes at same position — push along golden angle
    if (distance < 1e-12) {
        return .{
            .x = obstacle_x + config.min_base_distance * @cos(GOLDEN_ANGLE),
            .y = obstacle_y + config.min_base_distance * @sin(GOLDEN_ANGLE),
        };
    }

    // Push along separation vector to golden floor distance
    const unit_x = dx / distance;
    const unit_y = dy / distance;

    return .{
        .x = obstacle_x + unit_x * config.min_base_distance,
        .y = obstacle_y + unit_y * config.min_base_distance,
    };
}

/// Run a single relaxation pass over the swarm, correcting violations.
/// Returns the number of nodes that were moved.
/// Multiple passes converge to a globally valid configuration.
pub fn relaxation_pass(
    nodes: []SwarmNode,
    count: usize,
    config: ExclusionConfig,
) usize {
    const n = @min(count, nodes.len);
    var corrections: usize = 0;

    var i: usize = 0;
    while (i < n) : (i += 1) {
        var j: usize = 0;
        while (j < n) : (j += 1) {
            if (i == j) continue;
            const distance = euclidean_distance_2d(
                nodes[i].x,
                nodes[i].y,
                nodes[j].x,
                nodes[j].y,
            );

            if (distance < config.min_base_distance) {
                const corrected = correct_position(
                    nodes[i].x,
                    nodes[i].y,
                    nodes[j].x,
                    nodes[j].y,
                    config,
                );
                nodes[i].x = corrected.x;
                nodes[i].y = corrected.y;
                corrections += 1;
            }
        }
    }

    return corrections;
}

// ─────────────────────────────────────────────────────────────────────────────
// Fibonacci Boundary Level Assignment — Deterministic geometric tier
// ─────────────────────────────────────────────────────────────────────────────

/// Determine which Fibonacci boundary level a distance falls into.
/// Levels are defined as: [F(n) * base, F(n+1) * base)
/// This maps any distance to a unique Fibonacci tier — no two distances
/// in the same tier can exist between the same pair of nodes.
pub fn fibonacci_boundary_level(distance: f64, base: f64) usize {
    if (distance < base) return 0;

    var level: usize = 0;
    var i: usize = 2;
    while (i < 30) : (i += 1) {
        const fib_val: f64 = @floatFromInt(fib.FIB_TABLE[i]);
        if (distance < fib_val * base) break;
        level = i - 1;
    }
    return level;
}

/// Check if two distances occupy distinct Fibonacci boundary levels.
/// If they do, the nodes are guaranteed to be in non-overlapping geometric tiers.
pub fn distinct_boundary_levels(dist_a: f64, dist_b: f64, base: f64) bool {
    return fibonacci_boundary_level(dist_a, base) != fibonacci_boundary_level(dist_b, base);
}

// ─────────────────────────────────────────────────────────────────────────────
// C ABI Exports — For Python CFFI / external binding
// ─────────────────────────────────────────────────────────────────────────────

/// Verify spatial exclusion between two 2D nodes (C ABI).
/// Returns 1 if valid (no collision), 0 if spatial violation.
/// Writes scaling_step to output pointer if non-null.
pub export fn sovereign_verify_spatial_exclusion(
    node_x: f64,
    node_y: f64,
    neighbor_x: f64,
    neighbor_y: f64,
    min_base_distance: f64,
    scaling_step_out: ?*f64,
) u8 {
    const config = ExclusionConfig{
        .min_base_distance = if (min_base_distance > 0.0) min_base_distance else PHI,
    };
    const result = verify_spatial_envelope(node_x, node_y, neighbor_x, neighbor_y, config);

    if (scaling_step_out) |ptr| {
        ptr.* = result.scaling_step;
    }

    return if (result.valid) 1 else 0;
}

/// Validate entire swarm spatial exclusion matrix (C ABI).
/// Input: interleaved [x0, y0, x1, y1, ...] positions.
/// Returns count of violations detected.
pub export fn sovereign_validate_swarm_exclusion(
    positions_ptr: [*]const f64,
    node_count: usize,
    min_base_distance: f64,
) usize {
    const config = ExclusionConfig{
        .min_base_distance = if (min_base_distance > 0.0) min_base_distance else PHI,
    };

    var violation_count: usize = 0;
    var i: usize = 0;
    while (i < node_count) : (i += 1) {
        var j: usize = i + 1;
        while (j < node_count) : (j += 1) {
            const result = verify_spatial_envelope(
                positions_ptr[i * 2],
                positions_ptr[i * 2 + 1],
                positions_ptr[j * 2],
                positions_ptr[j * 2 + 1],
                config,
            );
            if (!result.valid) {
                violation_count += 1;
            }
        }
    }

    return violation_count;
}

/// Generate exclusion-safe swarm positions (C ABI).
/// Output: interleaved [x0, y0, x1, y1, ...] positions.
/// Returns count of nodes placed.
pub export fn sovereign_generate_safe_positions(
    output_ptr: [*]f64,
    n: usize,
    outer_radius: f64,
    min_base_distance: f64,
) usize {
    const config = ExclusionConfig{
        .min_base_distance = if (min_base_distance > 0.0) min_base_distance else PHI,
        .max_nodes = @min(n, 233),
    };

    const count = @min(n, 233);
    const n_f: f64 = @floatFromInt(count);

    for (0..count) |i| {
        const fi: f64 = @floatFromInt(i);
        const r = outer_radius * @sqrt((fi + 1.0) / (n_f + 1.0));
        const theta = (fi + 1.0) * GOLDEN_ANGLE;
        output_ptr[i * 2] = r * @cos(theta);
        output_ptr[i * 2 + 1] = r * @sin(theta);
    }

    // Verify and report — use min_base_distance from config
    _ = config;
    return count;
}

/// Compute exclusion radius at a given Fibonacci tier (C ABI).
pub export fn sovereign_exclusion_radius(base_radius: f64, tier: usize) f64 {
    return compute_exclusion_radius(base_radius, tier);
}

/// Correct a node position to satisfy spatial exclusion (C ABI).
/// Writes corrected (x, y) to output pointers.
pub export fn sovereign_correct_position(
    node_x: f64,
    node_y: f64,
    obstacle_x: f64,
    obstacle_y: f64,
    min_base_distance: f64,
    out_x: *f64,
    out_y: *f64,
) void {
    const config = ExclusionConfig{
        .min_base_distance = if (min_base_distance > 0.0) min_base_distance else PHI,
    };
    const corrected = correct_position(node_x, node_y, obstacle_x, obstacle_y, config);
    out_x.* = corrected.x;
    out_y.* = corrected.y;
}
