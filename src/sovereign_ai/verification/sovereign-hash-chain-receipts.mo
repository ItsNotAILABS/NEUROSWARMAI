// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — HASH-CHAINED STATE RECEIPT ENGINE                                                         ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  Lightweight Deployment Verification — Sequential State Commitments                                       ║
// ║  Tamper-Evident Receipt Chain — Bounded Memory — Edge-Deployable                                          ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module may be subject to ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)           ║
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

module SovereignHashChainReceipts {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Domain separator for hash chain receipts
  public let DOMAIN_RECEIPT_CHAIN : [Nat8] = [
    0x4D, 0x45, 0x44, 0x49, 0x4E, 0x41, 0x2E, 0x52, // MEDINA.R
    0x45, 0x43, 0x45, 0x49, 0x50, 0x54, 0x2E, 0x76, // ECEIPT.v
    0x31                                               // 1
  ];

  /// Genesis receipt hash (all zeros — chain anchor)
  public let GENESIS_HASH : [Nat8] = [
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  ];

  /// Maximum chain length before mandatory checkpoint
  public let MAX_CHAIN_LENGTH : Nat64 = 1_000_000;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — RECEIPT CHAIN
  // ═══════════════════════════════════════════════════════════════════════════════

  /// A single state receipt in the chain
  public type StateReceipt = {
    sequenceNumber : Nat64;       // Monotonic counter (gap = tamper)
    previousHash : [Nat8];        // Hash of previous receipt (chain link)
    stateHash : [Nat8];           // Hash of current state snapshot
    actionDigest : [Nat8];        // Hash of action that caused transition
    receiptHash : [Nat8];         // H(seq || prevHash || stateHash || actionDigest)
    timestamp : Int;              // When this receipt was issued
    issuer : Text;                // Which component issued this receipt
  };

  /// Receipt chain metadata
  public type ReceiptChain = {
    chainId : [Nat8];             // Unique chain identifier
    genesisTimestamp : Int;       // When chain was created
    headHash : [Nat8];            // Current chain head
    headSequence : Nat64;         // Current sequence number
    totalReceipts : Nat64;        // Total receipts issued
    checkpoints : [ChainCheckpoint];  // Periodic integrity checkpoints
  };

  /// Periodic checkpoint for long chains
  public type ChainCheckpoint = {
    sequenceNumber : Nat64;
    receiptHash : [Nat8];
    accumulatorHash : [Nat8];     // Running hash of all receipts up to this point
    timestamp : Int;
  };

  /// Chain verification result
  public type ChainVerification = {
    valid : Bool;
    lastValidSequence : Nat64;
    brokenAt : ?Nat64;            // Where chain breaks (if invalid)
    reason : VerificationFailure;
  };

  /// Why verification failed
  public type VerificationFailure = {
    #None;                        // No failure
    #SequenceGap;                 // Non-monotonic sequence numbers
    #HashMismatch;                // Receipt hash doesn't match recomputation
    #ChainBreak;                  // Previous hash doesn't link to prior receipt
    #TimestampRegression;         // Time went backwards
    #GenesisViolation;            // First receipt doesn't link to genesis
  };

  /// Lightweight receipt for constrained devices
  public type CompactReceipt = {
    seq : Nat64;
    hash : [Nat8];               // Full receipt hash (verifiable)
    prevTrunc : [Nat8];          // Truncated previous hash (8 bytes, fast check)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — SOVEREIGN HASH FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sovereign hash for receipt chain (domain-separated FNV-1a cascade)
  public func receiptHash(data : [Nat8]) : [Nat8] {
    var h0 : Nat32 = 0x811c9dc5;
    var h1 : Nat32 = 0x01000193;
    var h2 : Nat32 = 0x6c62272e;
    var h3 : Nat32 = 0x61c88647;
    var h4 : Nat32 = 0x27d4eb2f;
    var h5 : Nat32 = 0x165667b1;
    var h6 : Nat32 = 0xd3a2646c;
    var h7 : Nat32 = 0xfd7046c5;

    // Domain injection
    for (b in DOMAIN_RECEIPT_CHAIN.vals()) {
      h0 := (h0 ^ natToNat32(Nat8.toNat(b))) *% 0x01000193;
    };

    // Absorb data
    for (b in data.vals()) {
      let byte = natToNat32(Nat8.toNat(b));
      h0 := (h0 ^ byte) *% 0x01000193;
      h1 := (h1 ^ (byte +% 0x9e3779b9)) *% 0x01000193;
      h2 := (h2 ^ (byte ^ 0x6a09e667)) *% 0x01000193;
      h3 := (h3 ^ (byte +% 0xbb67ae85)) *% 0x01000193;
      h4 := (h4 ^ (byte ^ 0x3c6ef372)) *% 0x01000193;
      h5 := (h5 ^ (byte +% 0xa54ff53a)) *% 0x01000193;
      h6 := (h6 ^ (byte ^ 0x510e527f)) *% 0x01000193;
      h7 := (h7 ^ (byte +% 0x1f83d9ab)) *% 0x01000193;
    };

    // Avalanche mixing
    h0 := h0 ^ (h0 >> 16); h0 := h0 *% 0x85ebca6b;
    h1 := h1 ^ (h1 >> 13); h1 := h1 *% 0xc2b2ae35;
    h2 := h2 ^ (h2 >> 16); h2 := h2 *% 0x85ebca6b;
    h3 := h3 ^ (h3 >> 13); h3 := h3 *% 0xc2b2ae35;
    h4 := h4 ^ (h4 >> 16); h4 := h4 *% 0x85ebca6b;
    h5 := h5 ^ (h5 >> 13); h5 := h5 *% 0xc2b2ae35;
    h6 := h6 ^ (h6 >> 16); h6 := h6 *% 0x85ebca6b;
    h7 := h7 ^ (h7 >> 13); h7 := h7 *% 0xc2b2ae35;

    serializeState(h0, h1, h2, h3, h4, h5, h6, h7)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — RECEIPT CHAIN OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Create genesis receipt (chain anchor)
  public func createGenesis(issuer : Text, timestamp : Int) : StateReceipt {
    let stateHash = receiptHash([0x47, 0x45, 0x4E, 0x45, 0x53, 0x49, 0x53]); // "GENESIS"
    let actionDigest = receiptHash([0x49, 0x4E, 0x49, 0x54]); // "INIT"

    let fullHash = computeReceiptHash(0, GENESIS_HASH, stateHash, actionDigest);

    {
      sequenceNumber = 0;
      previousHash = GENESIS_HASH;
      stateHash = stateHash;
      actionDigest = actionDigest;
      receiptHash = fullHash;
      timestamp = timestamp;
      issuer = issuer;
    }
  };

  /// Issue a new receipt extending the chain
  public func issueReceipt(
    previous : StateReceipt,
    newStateHash : [Nat8],
    actionDigest : [Nat8],
    issuer : Text,
    timestamp : Int
  ) : StateReceipt {
    let seq = previous.sequenceNumber + 1;
    let fullHash = computeReceiptHash(seq, previous.receiptHash, newStateHash, actionDigest);

    {
      sequenceNumber = seq;
      previousHash = previous.receiptHash;
      stateHash = newStateHash;
      actionDigest = actionDigest;
      receiptHash = fullHash;
      timestamp = timestamp;
      issuer = issuer;
    }
  };

  /// Verify a single receipt's integrity
  public func verifyReceipt(receipt : StateReceipt) : Bool {
    let expected = computeReceiptHash(
      receipt.sequenceNumber,
      receipt.previousHash,
      receipt.stateHash,
      receipt.actionDigest
    );
    arrayEqual(expected, receipt.receiptHash)
  };

  /// Verify chain continuity between two consecutive receipts
  public func verifyLink(prev : StateReceipt, next : StateReceipt) : ChainVerification {
    // Check sequence monotonicity
    if (next.sequenceNumber != prev.sequenceNumber + 1) {
      return { valid = false; lastValidSequence = prev.sequenceNumber; brokenAt = ?next.sequenceNumber; reason = #SequenceGap };
    };

    // Check chain linkage
    if (not arrayEqual(next.previousHash, prev.receiptHash)) {
      return { valid = false; lastValidSequence = prev.sequenceNumber; brokenAt = ?next.sequenceNumber; reason = #ChainBreak };
    };

    // Check receipt hash integrity
    if (not verifyReceipt(next)) {
      return { valid = false; lastValidSequence = prev.sequenceNumber; brokenAt = ?next.sequenceNumber; reason = #HashMismatch };
    };

    // Check time doesn't regress
    if (next.timestamp < prev.timestamp) {
      return { valid = false; lastValidSequence = prev.sequenceNumber; brokenAt = ?next.sequenceNumber; reason = #TimestampRegression };
    };

    { valid = true; lastValidSequence = next.sequenceNumber; brokenAt = null; reason = #None }
  };

  /// Verify an entire chain from genesis
  public func verifyFullChain(receipts : [StateReceipt]) : ChainVerification {
    if (receipts.size() == 0) {
      return { valid = true; lastValidSequence = 0; brokenAt = null; reason = #None };
    };

    // Verify genesis links to zero hash
    if (not arrayEqual(receipts[0].previousHash, GENESIS_HASH)) {
      return { valid = false; lastValidSequence = 0; brokenAt = ?0; reason = #GenesisViolation };
    };

    if (not verifyReceipt(receipts[0])) {
      return { valid = false; lastValidSequence = 0; brokenAt = ?0; reason = #HashMismatch };
    };

    // Verify each link
    for (i in Iter.range(1, receipts.size() - 1)) {
      let result = verifyLink(receipts[i - 1], receipts[i]);
      if (not result.valid) { return result };
    };

    { valid = true; lastValidSequence = receipts[receipts.size() - 1].sequenceNumber; brokenAt = null; reason = #None }
  };

  /// Create a compact receipt for constrained devices
  public func compactify(receipt : StateReceipt) : CompactReceipt {
    let truncated = Array.tabulate<Nat8>(8, func(i : Nat) : Nat8 {
      receipt.previousHash[i]
    });
    {
      seq = receipt.sequenceNumber;
      hash = receipt.receiptHash;
      prevTrunc = truncated;
    }
  };

  /// Create checkpoint for long-running chains
  public func createCheckpoint(
    receipts : [StateReceipt],
    upToSequence : Nat64
  ) : ?ChainCheckpoint {
    // Compute accumulator hash over all receipts up to sequence
    var accumulator : [Nat8] = GENESIS_HASH;
    var lastReceipt : ?StateReceipt = null;

    for (r in receipts.vals()) {
      if (r.sequenceNumber <= upToSequence) {
        accumulator := receiptHash(Array.append(accumulator, r.receiptHash));
        lastReceipt := ?r;
      };
    };

    switch (lastReceipt) {
      case null { null };
      case (?lr) {
        ?{
          sequenceNumber = lr.sequenceNumber;
          receiptHash = lr.receiptHash;
          accumulatorHash = accumulator;
          timestamp = lr.timestamp;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════════

  func computeReceiptHash(
    seq : Nat64,
    prevHash : [Nat8],
    stateHash : [Nat8],
    actionDigest : [Nat8]
  ) : [Nat8] {
    let seqBytes = nat64ToBytes(seq);
    let combined = Array.append(seqBytes,
      Array.append(prevHash,
        Array.append(stateHash, actionDigest)
      )
    );
    receiptHash(combined)
  };

  func natToNat32(n : Nat) : Nat32 {
    Nat32.fromNat(n % 4294967296)
  };

  func nat64ToBytes(value : Nat64) : [Nat8] {
    [
      Nat8.fromNat(Nat64.toNat((value >> 56) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((value >> 48) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((value >> 40) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((value >> 32) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((value >> 24) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((value >> 16) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((value >> 8) & 0xFF)),
      Nat8.fromNat(Nat64.toNat(value & 0xFF))
    ]
  };

  func serializeState(h0 : Nat32, h1 : Nat32, h2 : Nat32, h3 : Nat32, h4 : Nat32, h5 : Nat32, h6 : Nat32, h7 : Nat32) : [Nat8] {
    [
      Nat8.fromNat(Nat32.toNat((h0 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h0 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h0 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h0 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h1 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h1 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h1 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h1 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h2 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h2 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h2 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h2 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h3 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h3 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h3 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h3 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h4 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h4 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h4 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h4 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h5 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h5 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h5 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h5 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h6 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h6 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h6 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h6 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h7 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h7 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h7 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h7 & 0xFF))
    ]
  };

  func arrayEqual(a : [Nat8], b : [Nat8]) : Bool {
    if (a.size() != b.size()) { return false };
    for (i in Iter.range(0, a.size() - 1)) {
      if (a[i] != b[i]) { return false };
    };
    true
  };
}
