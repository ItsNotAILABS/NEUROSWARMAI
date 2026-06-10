// build.zig — Sovereign Native Stack Build Configuration
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0
//
// Produces:
//   - libphantom_native.a  (static library, C ABI, for Python CFFI binding)
//   - phantom_swarm         (standalone attestable binary)
//
// Build commands:
//   zig build                          → debug build
//   zig build -Doptimize=ReleaseFast   → production deterministic binary
//   zig build -Doptimize=ReleaseFast -Dtarget=aarch64-linux → cross-compile ARM
//
// The ReleaseFast binary is suitable for:
//   - QSHA manifest signing (deterministic output)
//   - TPM/Pluton attestation binding
//   - Edge deployment (minimal binary, no runtime)

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ─────────────────────────────────────────────────────────────────────────
    // Static Library — C ABI for Python CFFI / direct linking
    // ─────────────────────────────────────────────────────────────────────────
    const lib = b.addStaticLibrary(.{
        .name = "phantom_native",
        .root_source_file = b.path("src/neurocore.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Enable SIMD for target architecture
    lib.root_module.addOptions();

    b.installArtifact(lib);

    // ─────────────────────────────────────────────────────────────────────────
    // Standalone Executable — Attestable swarm runtime binary
    // ─────────────────────────────────────────────────────────────────────────
    const exe = b.addExecutable(.{
        .name = "phantom_swarm",
        .root_source_file = b.path("src/runtime.zig"),
        .target = target,
        .optimize = optimize,
        .single_threaded = true, // deterministic, no thread runtime
    });

    // Strip for minimal binary (attestation-ready)
    exe.root_module.strip = (optimize != .Debug);

    b.installArtifact(exe);

    // ─────────────────────────────────────────────────────────────────────────
    // Run step — for development testing
    // ─────────────────────────────────────────────────────────────────────────
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the sovereign swarm runtime");
    run_step.dependOn(&run_cmd.step);

    // ─────────────────────────────────────────────────────────────────────────
    // Tests
    // ─────────────────────────────────────────────────────────────────────────
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/neurocore.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run sovereign kernel unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
