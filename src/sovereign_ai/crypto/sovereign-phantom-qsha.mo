// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — PHANTOM QSHA CRYPTOGRAPHIC COMMITMENT ENGINE                                              ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  12-Round SHA-256 ⊕ SHA3-256 Commitment Profile                                                           ║
// ║  Domain: MEDINA.PHANTOM.QSHA.v1                                                                           ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module may be subject to ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)           ║
// ║  ECCN 5D002 — Information Security Software                                                               ║
// ║  DO NOT EXPORT without proper BIS/DDTC authorization.                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Array "mo:core/Array";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Blob "mo:core/Blob";
import Char "mo:core/Char";

module SovereignPhantomQSHA {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — QSHA COMMITMENT PROFILE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Domain separator for QSHA commitments
  public let DOMAIN_SEPARATOR : [Nat8] = [
    0x4D, 0x45, 0x44, 0x49, 0x4E, 0x41, 0x2E, 0x50, // MEDINA.P
    0x48, 0x41, 0x4E, 0x54, 0x4F, 0x4D, 0x2E, 0x51, // HANTOM.Q
    0x53, 0x48, 0x41, 0x2E, 0x76, 0x31                // SHA.v1
  ];

  /// Minimum rounds for security guarantee
  public let MIN_ROUNDS : Nat = 8;

  /// Default round count per specification
  public let DEFAULT_ROUNDS : Nat = 12;

  /// SHA-256 block size in bytes
  let SHA256_BLOCK_SIZE : Nat = 64;

  /// SHA-256 digest size in bytes
  let SHA256_DIGEST_SIZE : Nat = 32;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — QSHA COMMITMENT TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// QSHA commitment result
  public type QSHACommitment = {
    hash : [Nat8];        // 32-byte commitment hash
    hex : Text;           // Hex-encoded commitment string
    rounds : Nat;         // Number of rounds applied
    domain : Text;        // Domain separator used
    timestamp : Int;      // When commitment was created
  };

  /// Canonical JSON value for deterministic serialization
  public type CanonicalValue = {
    #null_;
    #bool_ : Bool;
    #int_ : Int;
    #float_ : Float;
    #text_ : Text;
    #array_ : [CanonicalValue];
    #object_ : [(Text, CanonicalValue)];
  };

  /// Commitment verification result
  public type VerificationResult = {
    valid : Bool;
    expectedHash : [Nat8];
    actualHash : [Nat8];
    roundsUsed : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHA-256 — SOVEREIGN IMPLEMENTATION (FIPS 180-4)
  // No external library. Every round constant, every sigma function, built here.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// SHA-256 initial hash values (first 32 bits of fractional parts of sqrt of first 8 primes)
  let SHA256_H : [Nat32] = [
    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
  ];

  /// SHA-256 round constants (first 32 bits of fractional parts of cube roots of first 64 primes)
  let SHA256_K : [Nat32] = [
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
  ];

  /// Right-rotate 32-bit value
  func rotr32(x : Nat32, n : Nat32) : Nat32 {
    (x >> n) | (x << (32 - n))
  };

  /// SHA-256 Σ0 function
  func sigma0_256(x : Nat32) : Nat32 {
    rotr32(x, 2) ^ rotr32(x, 13) ^ rotr32(x, 22)
  };

  /// SHA-256 Σ1 function
  func sigma1_256(x : Nat32) : Nat32 {
    rotr32(x, 6) ^ rotr32(x, 11) ^ rotr32(x, 25)
  };

  /// SHA-256 σ0 function (message schedule)
  func gamma0_256(x : Nat32) : Nat32 {
    rotr32(x, 7) ^ rotr32(x, 18) ^ (x >> 3)
  };

  /// SHA-256 σ1 function (message schedule)
  func gamma1_256(x : Nat32) : Nat32 {
    rotr32(x, 17) ^ rotr32(x, 19) ^ (x >> 10)
  };

  /// SHA-256 Ch function
  func ch(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
    (x & y) ^ ((^x) & z)
  };

  /// SHA-256 Maj function
  func maj(x : Nat32, y : Nat32, z : Nat32) : Nat32 {
    (x & y) ^ (x & z) ^ (y & z)
  };

  /// Pad message per SHA-256 specification (FIPS 180-4 §5.1.1)
  func sha256Pad(message : [Nat8]) : [Nat8] {
    let msgLen = message.size();
    let bitLen : Nat64 = Nat64.fromNat(msgLen * 8);

    // Message + 0x80 + zeros + 8 bytes length
    let padLen = SHA256_BLOCK_SIZE - ((msgLen + 9) % SHA256_BLOCK_SIZE);
    let totalLen = msgLen + 1 + (if (padLen == SHA256_BLOCK_SIZE) 0 else padLen) + 8;

    let padded = Array.init<Nat8>(totalLen, 0 : Nat8);

    // Copy message
    for (i in Iter.range(0, msgLen - 1)) {
      padded[i] := message[i];
    };

    // Append bit '1'
    padded[msgLen] := 0x80;

    // Append length as big-endian 64-bit
    let lenOffset = totalLen - 8;
    padded[lenOffset + 0] := Nat8.fromNat(Nat64.toNat((bitLen >> 56) & 0xFF));
    padded[lenOffset + 1] := Nat8.fromNat(Nat64.toNat((bitLen >> 48) & 0xFF));
    padded[lenOffset + 2] := Nat8.fromNat(Nat64.toNat((bitLen >> 40) & 0xFF));
    padded[lenOffset + 3] := Nat8.fromNat(Nat64.toNat((bitLen >> 32) & 0xFF));
    padded[lenOffset + 4] := Nat8.fromNat(Nat64.toNat((bitLen >> 24) & 0xFF));
    padded[lenOffset + 5] := Nat8.fromNat(Nat64.toNat((bitLen >> 16) & 0xFF));
    padded[lenOffset + 6] := Nat8.fromNat(Nat64.toNat((bitLen >> 8) & 0xFF));
    padded[lenOffset + 7] := Nat8.fromNat(Nat64.toNat(bitLen & 0xFF));

    Array.freeze(padded)
  };

  /// Process one 512-bit block of SHA-256
  func sha256Block(block : [Nat8], offset : Nat, h : [var Nat32]) : () {
    // Prepare message schedule W[0..63]
    let w = Array.init<Nat32>(64, 0 : Nat32);

    // First 16 words from block
    for (i in Iter.range(0, 15)) {
      let base = offset + i * 4;
      w[i] := (Nat32.fromNat(Nat8.toNat(block[base])) << 24)
            | (Nat32.fromNat(Nat8.toNat(block[base + 1])) << 16)
            | (Nat32.fromNat(Nat8.toNat(block[base + 2])) << 8)
            | Nat32.fromNat(Nat8.toNat(block[base + 3]));
    };

    // Extend to 64 words
    for (i in Iter.range(16, 63)) {
      w[i] := gamma1_256(w[i - 2]) +% w[i - 7] +% gamma0_256(w[i - 15]) +% w[i - 16];
    };

    // Initialize working variables
    var a = h[0]; var b = h[1]; var c = h[2]; var d = h[3];
    var e = h[4]; var f = h[5]; var g = h[6]; var hh = h[7];

    // 64 rounds of compression
    for (i in Iter.range(0, 63)) {
      let t1 = hh +% sigma1_256(e) +% ch(e, f, g) +% SHA256_K[i] +% w[i];
      let t2 = sigma0_256(a) +% maj(a, b, c);
      hh := g; g := f; f := e;
      e := d +% t1;
      d := c; c := b; b := a;
      a := t1 +% t2;
    };

    // Add compressed chunk to hash
    h[0] +%= a; h[1] +%= b; h[2] +%= c; h[3] +%= d;
    h[4] +%= e; h[5] +%= f; h[6] +%= g; h[7] +%= hh;
  };

  /// Complete SHA-256 hash — sovereign implementation
  public func sha256(message : [Nat8]) : [Nat8] {
    let padded = sha256Pad(message);

    // Initialize hash state
    let h = Array.init<Nat32>(8, 0 : Nat32);
    for (i in Iter.range(0, 7)) {
      h[i] := SHA256_H[i];
    };

    // Process each 512-bit block
    let numBlocks = padded.size() / SHA256_BLOCK_SIZE;
    for (block in Iter.range(0, numBlocks - 1)) {
      sha256Block(padded, block * SHA256_BLOCK_SIZE, h);
    };

    // Produce 32-byte digest
    let digest = Array.init<Nat8>(32, 0 : Nat8);
    for (i in Iter.range(0, 7)) {
      digest[i * 4 + 0] := Nat8.fromNat(Nat32.toNat((h[i] >> 24) & 0xFF));
      digest[i * 4 + 1] := Nat8.fromNat(Nat32.toNat((h[i] >> 16) & 0xFF));
      digest[i * 4 + 2] := Nat8.fromNat(Nat32.toNat((h[i] >> 8) & 0xFF));
      digest[i * 4 + 3] := Nat8.fromNat(Nat32.toNat(h[i] & 0xFF));
    };
    Array.freeze(digest)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHA3-256 — SOVEREIGN IMPLEMENTATION (FIPS 202 KECCAK-f[1600])
  // Full Keccak permutation. Zero borrowed code.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Keccak-f[1600] round constants
  let KECCAK_RC : [Nat64] = [
    0x0000000000000001, 0x0000000000008082, 0x800000000000808A, 0x8000000080008000,
    0x000000000000808B, 0x0000000080000001, 0x8000000080008081, 0x8000000000008009,
    0x000000000000008A, 0x0000000000000088, 0x0000000080008009, 0x000000008000000A,
    0x000000008000808B, 0x800000000000008B, 0x8000000000008089, 0x8000000000008003,
    0x8000000000008002, 0x8000000000000080, 0x000000000000800A, 0x800000008000000A,
    0x8000000080008081, 0x8000000000008080, 0x0000000080000001, 0x8000000080008008
  ];

  /// Keccak rotation offsets
  let KECCAK_ROT : [Nat64] = [
     0,  1, 62, 28, 27,
    36, 44,  6, 55, 20,
     3, 10, 43, 25, 39,
    41, 45, 15, 21,  8,
    18,  2, 61, 56, 14
  ];

  /// Keccak pi permutation indices
  let KECCAK_PI : [Nat] = [
     0, 10, 20,  5, 15,
    16,  1, 11, 21,  6,
     7, 17,  2, 12, 22,
    23,  8, 18,  3, 13,
    14, 24,  9, 19,  4
  ];

  /// Rotate left 64-bit
  func rotl64(x : Nat64, n : Nat64) : Nat64 {
    (x << n) | (x >> (64 - n))
  };

  /// Keccak-f[1600] permutation — 24 rounds
  func keccakF1600(state : [var Nat64]) : () {
    let c = Array.init<Nat64>(5, 0 : Nat64);
    let d = Array.init<Nat64>(5, 0 : Nat64);
    let b = Array.init<Nat64>(25, 0 : Nat64);

    for (round in Iter.range(0, 23)) {
      // θ (theta) step
      for (x in Iter.range(0, 4)) {
        c[x] := state[x] ^ state[x + 5] ^ state[x + 10] ^ state[x + 15] ^ state[x + 20];
      };
      for (x in Iter.range(0, 4)) {
        d[x] := c[(x + 4) % 5] ^ rotl64(c[(x + 1) % 5], 1);
      };
      for (x in Iter.range(0, 4)) {
        for (y in Iter.range(0, 4)) {
          state[x + 5 * y] ^= d[x];
        };
      };

      // ρ (rho) and π (pi) steps combined
      for (i in Iter.range(0, 24)) {
        b[KECCAK_PI[i]] := rotl64(state[i], KECCAK_ROT[i]);
      };

      // χ (chi) step
      for (y in Iter.range(0, 4)) {
        for (x in Iter.range(0, 4)) {
          state[x + 5 * y] := b[x + 5 * y] ^ ((^b[((x + 1) % 5) + 5 * y]) & b[((x + 2) % 5) + 5 * y]);
        };
      };

      // ι (iota) step
      state[0] ^= KECCAK_RC[round];
    };
  };

  /// SHA3-256 hash — sovereign Keccak sponge implementation
  public func sha3_256(message : [Nat8]) : [Nat8] {
    let rate = 136; // SHA3-256 rate = 1088 bits = 136 bytes
    let capacity = 64; // 512 bits

    // Initialize state (25 × 64-bit lanes)
    let state = Array.init<Nat64>(25, 0 : Nat64);

    // Absorb phase
    let msgLen = message.size();
    var offset = 0;

    // Process full blocks
    while (offset + rate <= msgLen) {
      for (i in Iter.range(0, rate / 8 - 1)) {
        let base = offset + i * 8;
        var lane : Nat64 = 0;
        for (j in Iter.range(0, 7)) {
          lane |= Nat64.fromNat(Nat8.toNat(message[base + j])) << Nat64.fromNat(j * 8);
        };
        state[i] ^= lane;
      };
      keccakF1600(state);
      offset += rate;
    };

    // Pad and absorb final block (SHA3 padding: 0x06...0x80)
    let remaining = msgLen - offset;
    let lastBlock = Array.init<Nat8>(rate, 0 : Nat8);

    for (i in Iter.range(0, remaining - 1)) {
      lastBlock[i] := message[offset + i];
    };
    lastBlock[remaining] := 0x06; // SHA3 domain separation
    lastBlock[rate - 1] |= 0x80; // Final padding bit

    // XOR last block into state
    for (i in Iter.range(0, rate / 8 - 1)) {
      let base = i * 8;
      var lane : Nat64 = 0;
      for (j in Iter.range(0, 7)) {
        lane |= Nat64.fromNat(Nat8.toNat(lastBlock[base + j])) << Nat64.fromNat(j * 8);
      };
      state[i] ^= lane;
    };
    keccakF1600(state);

    // Squeeze phase — extract 32 bytes
    let digest = Array.init<Nat8>(32, 0 : Nat8);
    for (i in Iter.range(0, 3)) {
      let lane = state[i];
      for (j in Iter.range(0, 7)) {
        digest[i * 8 + j] := Nat8.fromNat(Nat64.toNat((lane >> Nat64.fromNat(j * 8)) & 0xFF));
      };
    };
    Array.freeze(digest)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CANONICAL JSON — DETERMINISTIC SERIALIZATION
  // Foundation for all QSHA commitments. Sorted keys, no whitespace.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Serialize a CanonicalValue to deterministic JSON bytes
  public func canonicalJson(value : CanonicalValue) : [Nat8] {
    let text = canonicalJsonText(value);
    textToUtf8(text)
  };

  /// Serialize to canonical JSON text
  public func canonicalJsonText(value : CanonicalValue) : Text {
    switch (value) {
      case (#null_) { "null" };
      case (#bool_(b)) { if (b) "true" else "false" };
      case (#int_(n)) { Int.toText(n) };
      case (#float_(f)) { floatToText(f) };
      case (#text_(t)) { jsonEscapeText(t) };
      case (#array_(arr)) {
        var result = "[";
        for (i in Iter.range(0, arr.size() - 1)) {
          if (i > 0) result #= ",";
          result #= canonicalJsonText(arr[i]);
        };
        result # "]"
      };
      case (#object_(fields)) {
        // Sort fields by key for determinism
        let sorted = sortFields(fields);
        var result = "{";
        for (i in Iter.range(0, sorted.size() - 1)) {
          if (i > 0) result #= ",";
          result #= jsonEscapeText(sorted[i].0) # ":" # canonicalJsonText(sorted[i].1);
        };
        result # "}"
      };
    }
  };

  /// Sort object fields by key (insertion sort — deterministic)
  func sortFields(fields : [(Text, CanonicalValue)]) : [(Text, CanonicalValue)] {
    let arr = Array.thaw<(Text, CanonicalValue)>(fields);
    let n = arr.size();
    for (i in Iter.range(1, n - 1)) {
      let key = arr[i];
      var j = i;
      while (j > 0 and textLessThan(key.0, arr[j - 1].0)) {
        arr[j] := arr[j - 1];
        j -= 1;
      };
      arr[j] := key;
    };
    Array.freeze(arr)
  };

  /// Lexicographic text comparison
  func textLessThan(a : Text, b : Text) : Bool {
    let aIter = a.chars();
    let bIter = b.chars();
    loop {
      switch (aIter.next(), bIter.next()) {
        case (null, null) { return false };
        case (null, _) { return true };
        case (_, null) { return false };
        case (?ca, ?cb) {
          if (Char.toNat32(ca) < Char.toNat32(cb)) return true;
          if (Char.toNat32(ca) > Char.toNat32(cb)) return false;
        };
      };
    };
  };

  /// JSON-escape a text string
  func jsonEscapeText(t : Text) : Text {
    var result = "\"";
    for (c in t.chars()) {
      switch (c) {
        case ('"') { result #= "\\\"" };
        case ('\\') { result #= "\\\\" };
        case ('\n') { result #= "\\n" };
        case ('\r') { result #= "\\r" };
        case ('\t') { result #= "\\t" };
        case (_) { result #= Text.fromChar(c) };
      };
    };
    result # "\""
  };

  /// Float to text (basic conversion)
  func floatToText(f : Float) : Text {
    // Integer representation for determinism
    Int.toText(Float.toInt(f * 1000000.0)) // 6 decimal places as integer
  };

  /// Convert text to UTF-8 byte array
  func textToUtf8(t : Text) : [Nat8] {
    Blob.toArray(Text.encodeUtf8(t))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QSHA-256 COMMITMENT ENGINE — 12-ROUND SHA-256 ⊕ SHA3-256
  // The core cryptographic commitment profile.
  // ═══════════════════════════════════════════════════════════════════════════════

  /// XOR two byte arrays of equal length
  public func xorBytes(a : [Nat8], b : [Nat8]) : [Nat8] {
    assert(a.size() == b.size());
    Array.tabulate<Nat8>(a.size(), func(i : Nat) : Nat8 {
      a[i] ^ b[i]
    })
  };

  /// Bitwise left-rotate a byte array by shift bits
  public func rotateBytes(data : [Nat8], shift : Nat) : [Nat8] {
    let n = data.size();
    if (n == 0) return data;
    let totalBits = n * 8;
    let s = shift % totalBits;
    if (s == 0) return data;

    let byteShift = s / 8;
    let bitShift = s % 8;

    Array.tabulate<Nat8>(n, func(i : Nat) : Nat8 {
      let srcIdx = (i + n - byteShift) % n;
      let prevIdx = (srcIdx + n - 1) % n;
      if (bitShift == 0) {
        data[srcIdx]
      } else {
        let hi = Nat8.toNat(data[srcIdx]) << bitShift;
        let lo = Nat8.toNat(data[prevIdx]) >> (8 - bitShift);
        Nat8.fromNat((hi | lo) & 0xFF)
      }
    })
  };

  /// Concatenate two byte arrays
  func concat(a : [Nat8], b : [Nat8]) : [Nat8] {
    Array.tabulate<Nat8>(a.size() + b.size(), func(i : Nat) : Nat8 {
      if (i < a.size()) a[i] else b[i - a.size()]
    })
  };

  /// Encode Nat to 4-byte big-endian
  func nat32ToBytes(n : Nat) : [Nat8] {
    [
      Nat8.fromNat((n >> 24) & 0xFF),
      Nat8.fromNat((n >> 16) & 0xFF),
      Nat8.fromNat((n >> 8) & 0xFF),
      Nat8.fromNat(n & 0xFF)
    ]
  };

  /// QSHA-256 from raw bytes — the core commitment function
  /// 12-round alternating SHA-256 and SHA3-256 with XOR state mixing and rotations
  public func qsha256Bytes(data : [Nat8], rounds : Nat) : [Nat8] {
    let actualRounds = if (rounds < MIN_ROUNDS) MIN_ROUNDS else rounds;

    // Initialize left/right state with domain separation
    let leftInit = concat(concat(DOMAIN_SEPARATOR, [0x00 : Nat8]), data);
    let rightInit = concat(concat(DOMAIN_SEPARATOR, [0x01 : Nat8]), data);

    var left = sha256(leftInit);
    var right = sha3_256(rightInit);

    // Multi-round mixing
    for (i in Iter.range(0, actualRounds - 1)) {
      let roundTag = nat32ToBytes(i);

      if (i % 2 == 0) {
        // Even rounds: SHA-256 on left mixed with rotated right
        let rotated = rotateBytes(right, (i + 1) * 3);
        let mixed = xorBytes(left, rotated);
        left := sha256(concat(concat(roundTag, mixed), right));
      } else {
        // Odd rounds: SHA3-256 on right mixed with rotated left
        let rotated = rotateBytes(left, (i + 1) * 5);
        let mixed = xorBytes(right, rotated);
        right := sha3_256(concat(concat(roundTag, mixed), left));
      };
    };

    // Final commitment: XOR of left and right states
    xorBytes(left, right)
  };

  /// QSHA-256 commitment from a CanonicalValue (JSON-serialized deterministically)
  public func qsha256Commit(value : CanonicalValue, rounds : Nat) : QSHACommitment {
    let jsonBytes = canonicalJson(value);
    let hash = qsha256Bytes(jsonBytes, rounds);
    {
      hash;
      hex = bytesToHex(hash);
      rounds = if (rounds < MIN_ROUNDS) MIN_ROUNDS else rounds;
      domain = "MEDINA.PHANTOM.QSHA.v1";
      timestamp = 0; // Caller should set actual timestamp
    }
  };

  /// QSHA-256 commitment with default 12 rounds
  public func qsha256(data : [Nat8]) : [Nat8] {
    qsha256Bytes(data, DEFAULT_ROUNDS)
  };

  /// Verify a QSHA commitment against expected data
  public func verify(data : [Nat8], expectedHash : [Nat8], rounds : Nat) : VerificationResult {
    let computed = qsha256Bytes(data, rounds);
    let valid = arrayEqual(computed, expectedHash);
    {
      valid;
      expectedHash;
      actualHash = computed;
      roundsUsed = if (rounds < MIN_ROUNDS) MIN_ROUNDS else rounds;
    }
  };

  /// Verify a canonical value commitment
  public func verifyCommitment(value : CanonicalValue, commitment : QSHACommitment) : Bool {
    let jsonBytes = canonicalJson(value);
    let computed = qsha256Bytes(jsonBytes, commitment.rounds);
    arrayEqual(computed, commitment.hash)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HMAC-QSHA — KEYED COMMITMENT FOR AUTHENTICATED INTEGRITY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// HMAC using QSHA-256 as the underlying hash
  public func hmacQsha256(key : [Nat8], message : [Nat8]) : [Nat8] {
    // If key > block size, hash it first
    let actualKey = if (key.size() > SHA256_BLOCK_SIZE) {
      sha256(key)
    } else { key };

    // Pad key to block size
    let paddedKey = Array.init<Nat8>(SHA256_BLOCK_SIZE, 0 : Nat8);
    for (i in Iter.range(0, actualKey.size() - 1)) {
      paddedKey[i] := actualKey[i];
    };

    // Inner and outer padding
    let ipad = Array.tabulate<Nat8>(SHA256_BLOCK_SIZE, func(i : Nat) : Nat8 {
      paddedKey[i] ^ 0x36
    });
    let opad = Array.tabulate<Nat8>(SHA256_BLOCK_SIZE, func(i : Nat) : Nat8 {
      paddedKey[i] ^ 0x5C
    });

    // HMAC = QSHA(opad || QSHA(ipad || message))
    let inner = qsha256Bytes(concat(ipad, message), DEFAULT_ROUNDS);
    qsha256Bytes(concat(opad, inner), DEFAULT_ROUNDS)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMMITMENT CHAIN — TAMPER-EVIDENT LINKED COMMITMENTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Chain entry — links commitments in a tamper-evident sequence
  public type ChainEntry = {
    index : Nat;
    data : [Nat8];
    prevHash : [Nat8];
    hash : [Nat8];
    timestamp : Int;
  };

  /// Genesis entry (first in chain)
  public func genesisEntry(data : [Nat8], timestamp : Int) : ChainEntry {
    let prevHash = Array.tabulate<Nat8>(32, func(_ : Nat) : Nat8 { 0 });
    let toHash = concat(nat32ToBytes(0), concat(data, prevHash));
    let hash = qsha256Bytes(toHash, DEFAULT_ROUNDS);
    { index = 0; data; prevHash; hash; timestamp }
  };

  /// Append entry to chain
  public func appendEntry(prev : ChainEntry, data : [Nat8], timestamp : Int) : ChainEntry {
    let index = prev.index + 1;
    let toHash = concat(nat32ToBytes(index), concat(data, prev.hash));
    let hash = qsha256Bytes(toHash, DEFAULT_ROUNDS);
    { index; data; prevHash = prev.hash; hash; timestamp }
  };

  /// Verify chain integrity
  public func verifyChain(chain : [ChainEntry]) : Bool {
    if (chain.size() == 0) return true;

    // Verify genesis
    let genesis = chain[0];
    let expectedGenesis = genesisEntry(genesis.data, genesis.timestamp);
    if (not arrayEqual(genesis.hash, expectedGenesis.hash)) return false;

    // Verify each subsequent link
    for (i in Iter.range(1, chain.size() - 1)) {
      let entry = chain[i];
      // Previous hash must match
      if (not arrayEqual(entry.prevHash, chain[i - 1].hash)) return false;
      // Recompute and verify
      let toHash = concat(nat32ToBytes(entry.index), concat(entry.data, entry.prevHash));
      let expected = qsha256Bytes(toHash, DEFAULT_ROUNDS);
      if (not arrayEqual(entry.hash, expected)) return false;
    };
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Convert byte array to hex string
  public func bytesToHex(bytes : [Nat8]) : Text {
    let hexChars = "0123456789abcdef";
    var result = "";
    for (byte in bytes.vals()) {
      let hi = Nat8.toNat(byte) / 16;
      let lo = Nat8.toNat(byte) % 16;
      result #= Text.fromChar(charAtIndex(hexChars, hi));
      result #= Text.fromChar(charAtIndex(hexChars, lo));
    };
    result
  };

  /// Get character at index in text
  func charAtIndex(t : Text, idx : Nat) : Char {
    var i = 0;
    for (c in t.chars()) {
      if (i == idx) return c;
      i += 1;
    };
    '0' // Should never reach here with valid input
  };

  /// Compare two byte arrays for equality (constant-time)
  public func arrayEqual(a : [Nat8], b : [Nat8]) : Bool {
    if (a.size() != b.size()) return false;
    var diff : Nat8 = 0;
    for (i in Iter.range(0, a.size() - 1)) {
      diff |= a[i] ^ b[i];
    };
    diff == 0
  };

  /// Convert hex string to bytes
  public func hexToBytes(hex : Text) : [Nat8] {
    let chars = Iter.toArray(hex.chars());
    let len = chars.size() / 2;
    Array.tabulate<Nat8>(len, func(i : Nat) : Nat8 {
      let hi = hexCharToNat(chars[i * 2]);
      let lo = hexCharToNat(chars[i * 2 + 1]);
      Nat8.fromNat(hi * 16 + lo)
    })
  };

  /// Convert hex char to nat
  func hexCharToNat(c : Char) : Nat {
    let n = Char.toNat32(c);
    if (n >= 0x30 and n <= 0x39) { Nat32.toNat(n - 0x30) }
    else if (n >= 0x61 and n <= 0x66) { Nat32.toNat(n - 0x61 + 10) }
    else if (n >= 0x41 and n <= 0x46) { Nat32.toNat(n - 0x41 + 10) }
    else { 0 }
  };
};
