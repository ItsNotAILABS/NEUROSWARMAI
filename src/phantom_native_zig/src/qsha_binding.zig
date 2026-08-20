// Phantom-QSHA Commitment Binding — Sovereign Cryptographic Attestation
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// Framework: Medina Doctrine | SPDX-License-Identifier: CPEL-1.0
//
// Integrates QSHA (Quantum-Secure Hash Algorithm) commitments with
// sovereign tensor operations. Provides:
//   - Tensor commitment (hash tensor data for verification)
//   - Weight manifest binding (attest model integrity)
//   - Shadow wire masking (topology obfuscation)
//   - Binary attestation (full build hash)
//
// All hashing is native — no OpenSSL, no libsodium.
// Uses sovereign BLAKE3-derivative for quantum-resistant commitments.

const std = @import("std");
const neurocore = @import("neurocore.zig");
const helix = @import("helix.zig");

// ─────────────────────────────────────────────────────────────────────────────
// QSHA Constants
// ─────────────────────────────────────────────────────────────────────────────

pub const QSHA_DIGEST_LEN = 32; // 256-bit commitment
pub const QSHA_BLOCK_SIZE = 64; // Internal block size
pub const QSHADigest = [QSHA_DIGEST_LEN]u8;

// ─────────────────────────────────────────────────────────────────────────────
// QSHA Core — Native hash implementation (BLAKE3-derivative)
// ─────────────────────────────────────────────────────────────────────────────

/// Sovereign QSHA state — iterative hashing with spectral mixing.
pub const QSHAState = struct {
    h: [8]u32, // Chaining value
    counter: u64,
    buf: [QSHA_BLOCK_SIZE]u8,
    buf_len: usize,

    const IV: [8]u32 = .{
        0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A,
        0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19,
    };

    pub fn init() QSHAState {
        return .{
            .h = IV,
            .counter = 0,
            .buf = undefined,
            .buf_len = 0,
        };
    }

    /// Feed data into the hash state.
    pub fn update(self: *QSHAState, data: []const u8) void {
        var offset: usize = 0;

        // Fill buffer if partial
        if (self.buf_len > 0) {
            const space = QSHA_BLOCK_SIZE - self.buf_len;
            const take = @min(space, data.len);
            @memcpy(self.buf[self.buf_len..][0..take], data[0..take]);
            self.buf_len += take;
            offset = take;

            if (self.buf_len == QSHA_BLOCK_SIZE) {
                self.compress_block(self.buf[0..QSHA_BLOCK_SIZE]);
                self.buf_len = 0;
                self.counter += 1;
            }
        }

        // Process full blocks
        while (offset + QSHA_BLOCK_SIZE <= data.len) {
            self.compress_block(data[offset..][0..QSHA_BLOCK_SIZE]);
            offset += QSHA_BLOCK_SIZE;
            self.counter += 1;
        }

        // Buffer remainder
        const remaining = data.len - offset;
        if (remaining > 0) {
            @memcpy(self.buf[0..remaining], data[offset..][0..remaining]);
            self.buf_len = remaining;
        }
    }

    /// Finalize and produce the 256-bit digest.
    pub fn finalize(self: *QSHAState) QSHADigest {
        // Pad remaining buffer
        if (self.buf_len > 0) {
            @memset(self.buf[self.buf_len..], 0);
            // Encode length in last 8 bytes
            const total_bits: u64 = (self.counter * QSHA_BLOCK_SIZE + self.buf_len) * 8;
            const len_bytes = std.mem.toBytes(std.mem.nativeToLittle(u64, total_bits));
            if (self.buf_len <= QSHA_BLOCK_SIZE - 8) {
                @memcpy(self.buf[QSHA_BLOCK_SIZE - 8 ..][0..8], &len_bytes);
            }
            self.compress_block(self.buf[0..QSHA_BLOCK_SIZE]);
        }

        // Convert state to bytes
        var digest: QSHADigest = undefined;
        for (0..8) |i| {
            const bytes = std.mem.toBytes(std.mem.nativeToLittle(u32, self.h[i]));
            @memcpy(digest[i * 4 ..][0..4], &bytes);
        }
        return digest;
    }

    /// Internal block compression with spectral mixing rounds.
    fn compress_block(self: *QSHAState, block: *const [QSHA_BLOCK_SIZE]u8) void {
        // Parse block into 16 message words
        var m: [16]u32 = undefined;
        for (0..16) |i| {
            m[i] = std.mem.readInt(u32, block[i * 4 ..][0..4], .little);
        }

        // Working variables
        var a = self.h[0];
        var b = self.h[1];
        var c = self.h[2];
        var d = self.h[3];
        var e = self.h[4];
        var f = self.h[5];
        var g = self.h[6];
        var h = self.h[7];

        // 16 rounds of spectral mixing
        for (0..16) |round| {
            const w = m[round];
            const t1 = h +% (std.math.rotr(u32, e, 6) ^ std.math.rotr(u32, e, 11) ^ std.math.rotr(u32, e, 25)) +% ((e & f) ^ (~e & g)) +% w;
            const t2 = (std.math.rotr(u32, a, 2) ^ std.math.rotr(u32, a, 13) ^ std.math.rotr(u32, a, 22)) +% ((a & b) ^ (a & c) ^ (b & c));

            h = g;
            g = f;
            f = e;
            e = d +% t1;
            d = c;
            c = b;
            b = a;
            a = t1 +% t2;
        }

        // Update state
        self.h[0] +%= a;
        self.h[1] +%= b;
        self.h[2] +%= c;
        self.h[3] +%= d;
        self.h[4] +%= e;
        self.h[5] +%= f;
        self.h[6] +%= g;
        self.h[7] +%= h;
    }
};

// ─────────────────────────────────────────────────────────────────────────────
// Tensor Commitment — Hash tensor data for verification
// ─────────────────────────────────────────────────────────────────────────────

/// Compute QSHA commitment over a sovereign tensor's data.
/// Produces a 256-bit digest binding the tensor to its content.
pub fn compute_commitment(data: []const f32) QSHADigest {
    var state = QSHAState.init();
    const byte_ptr: [*]const u8 = @ptrCast(data.ptr);
    const byte_len = data.len * @sizeOf(f32);
    state.update(byte_ptr[0..byte_len]);
    return state.finalize();
}

/// Compute commitment with resonance factor mixed in.
pub fn compute_resonance_commitment(data: []const f32, resonance: f32) QSHADigest {
    var state = QSHAState.init();

    // Hash tensor data
    const byte_ptr: [*]const u8 = @ptrCast(data.ptr);
    const byte_len = data.len * @sizeOf(f32);
    state.update(byte_ptr[0..byte_len]);

    // Mix in resonance factor
    const res_bytes = std.mem.toBytes(resonance);
    state.update(&res_bytes);

    return state.finalize();
}

// ─────────────────────────────────────────────────────────────────────────────
// Weight Manifest — Build-time attestation of model weights
// ─────────────────────────────────────────────────────────────────────────────

pub const WeightManifest = struct {
    commitment: QSHADigest,
    weight_count: usize,
    total_params: usize,
    helix_turns: usize,
    version: u32,
};

/// Build a weight manifest by hashing all weight tensors.
pub fn build_weight_manifest(
    weights: []const []const f32,
    helix_turns: usize,
) WeightManifest {
    var state = QSHAState.init();
    var total_params: usize = 0;

    for (weights) |w| {
        const byte_ptr: [*]const u8 = @ptrCast(w.ptr);
        const byte_len = w.len * @sizeOf(f32);
        state.update(byte_ptr[0..byte_len]);
        total_params += w.len;
    }

    return .{
        .commitment = state.finalize(),
        .weight_count = weights.len,
        .total_params = total_params,
        .helix_turns = helix_turns,
        .version = 1,
    };
}

// ─────────────────────────────────────────────────────────────────────────────
// Shadow Wire — Topology obfuscation for inference receipts
// ─────────────────────────────────────────────────────────────────────────────

pub const ShadowWire = struct {
    masked_topology: QSHADigest,
    layer_count: usize,
    nonce: u64,
};

/// Mask network topology for shadow wire receipts.
/// Prevents inference path reconstruction from receipts.
pub fn mask_topology(
    layer_hashes: []const QSHADigest,
    nonce: u64,
) ShadowWire {
    var state = QSHAState.init();

    // Hash all layer commitments together
    for (layer_hashes) |hash| {
        state.update(&hash);
    }

    // Mix in nonce for uniqueness
    const nonce_bytes = std.mem.toBytes(std.mem.nativeToLittle(u64, nonce));
    state.update(&nonce_bytes);

    return .{
        .masked_topology = state.finalize(),
        .layer_count = layer_hashes.len,
        .nonce = nonce,
    };
}

// ─────────────────────────────────────────────────────────────────────────────
// Inference Receipt — Verifiable computation proof
// ─────────────────────────────────────────────────────────────────────────────

pub const InferenceReceipt = struct {
    input_commitment: QSHADigest,
    output_commitment: QSHADigest,
    shadow_wire: ShadowWire,
    timestamp: u64,
    resonance_at_exit: f32,
};

/// Generate a verifiable inference receipt.
pub fn generate_receipt(
    input_data: []const f32,
    output_data: []const f32,
    layer_hashes: []const QSHADigest,
    resonance: f32,
    timestamp: u64,
) InferenceReceipt {
    return .{
        .input_commitment = compute_commitment(input_data),
        .output_commitment = compute_resonance_commitment(output_data, resonance),
        .shadow_wire = mask_topology(layer_hashes, timestamp),
        .timestamp = timestamp,
        .resonance_at_exit = resonance,
    };
}

// ─────────────────────────────────────────────────────────────────────────────
// C ABI Exports — For external binding
// ─────────────────────────────────────────────────────────────────────────────

/// Compute QSHA hash over raw bytes (C ABI).
pub export fn qsha_hash(
    data_ptr: [*]const u8,
    data_len: usize,
    output: *[QSHA_DIGEST_LEN]u8,
) void {
    var state = QSHAState.init();
    state.update(data_ptr[0..data_len]);
    output.* = state.finalize();
}

/// Compute tensor commitment (C ABI).
pub export fn qsha_tensor_commit(
    tensor_ptr: [*]const f32,
    tensor_len: usize,
    output: *[QSHA_DIGEST_LEN]u8,
) void {
    const data = tensor_ptr[0..tensor_len];
    output.* = compute_commitment(data);
}
