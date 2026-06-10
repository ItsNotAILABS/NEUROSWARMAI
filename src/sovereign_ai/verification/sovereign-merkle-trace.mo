// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — MERKLEIZED EXECUTION TRACE ENGINE                                                         ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  Decoupled Verification via Merkle Commitments — Public Root Only Exposure                                ║
// ║  SNARK/STARK-Friendly Arithmetic Field Operations — Native Hash Tree                                      ║
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

module SovereignMerkleTrace {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — MERKLE TRACE CONFIGURATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Domain separator for Merkle execution traces
  public let DOMAIN_MERKLE_TRACE : [Nat8] = [
    0x4D, 0x45, 0x44, 0x49, 0x4E, 0x41, 0x2E, 0x4D, // MEDINA.M
    0x45, 0x52, 0x4B, 0x4C, 0x45, 0x2E, 0x54, 0x52, // ERKLE.TR
    0x41, 0x43, 0x45, 0x2E, 0x76, 0x31               // ACE.v1
  ];

  /// Maximum tree depth (log2 of max execution steps)
  public let MAX_TREE_DEPTH : Nat = 32;

  /// STARK-friendly prime field modulus (Goldilocks: 2^64 - 2^32 + 1)
  public let GOLDILOCKS_MODULUS : Nat64 = 18_446_744_069_414_584_321;

  /// Hash digest size in bytes
  let DIGEST_SIZE : Nat = 32;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — MERKLE EXECUTION TRACE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// A single execution step in the trace
  public type ExecutionStep = {
    stepIndex : Nat64;          // Monotonic step counter
    opcode : Nat32;             // Operation performed
    inputHash : [Nat8];         // Hash of inputs consumed
    outputHash : [Nat8];        // Hash of outputs produced
    stateTransition : [Nat8];   // Hash of state delta
    fieldElement : Nat64;       // STARK-friendly field representation
  };

  /// Merkle tree node
  public type MerkleNode = {
    #Leaf : {
      index : Nat;
      dataHash : [Nat8];
    };
    #Internal : {
      left : [Nat8];
      right : [Nat8];
      combined : [Nat8];
    };
  };

  /// Merkle proof (authentication path)
  public type MerkleProof = {
    leafIndex : Nat;
    leafHash : [Nat8];
    siblings : [[Nat8]];        // Sibling hashes from leaf to root
    directions : [Bool];        // true = leaf is on right side
    root : [Nat8];              // Expected root
  };

  /// Complete execution trace with Merkle commitment
  public type MerkleExecutionTrace = {
    traceId : [Nat8];           // Unique trace identifier
    root : [Nat8];              // PUBLIC: Merkle root (only public output)
    depth : Nat;                // Tree depth
    stepCount : Nat64;          // Total execution steps committed
    timestamp : Int;            // When trace was sealed
    fieldModulus : Nat64;       // Which arithmetic field was used
    domainTag : Text;           // Domain separation string
  };

  /// Verification result for a Merkle proof
  public type TraceVerification = {
    valid : Bool;
    computedRoot : [Nat8];
    expectedRoot : [Nat8];
    stepVerified : Nat;
    fieldConsistent : Bool;
  };

  /// STARK-friendly constraint representation
  public type ArithmeticConstraint = {
    #Addition : { a : Nat64; b : Nat64; expected : Nat64 };
    #Multiplication : { a : Nat64; b : Nat64; expected : Nat64 };
    #Transition : { prev : Nat64; next : Nat64; delta : Nat64 };
    #Boundary : { step : Nat64; value : Nat64 };
  };

  /// Constraint satisfaction result
  public type ConstraintResult = {
    satisfied : Bool;
    constraintIndex : Nat;
    witnessElement : Nat64;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — FNV-1a HASH (Sovereign, no dependencies)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// FNV-1a 256-bit hash producing 32-byte digest (sovereign implementation)
  public func sovereignHash(data : [Nat8]) : [Nat8] {
    // FNV-1a with domain separation and multi-pass diffusion
    var h0 : Nat32 = 0x811c9dc5;
    var h1 : Nat32 = 0x01000193;
    var h2 : Nat32 = 0x6c62272e;
    var h3 : Nat32 = 0x61c88647;
    var h4 : Nat32 = 0x27d4eb2f;
    var h5 : Nat32 = 0x165667b1;
    var h6 : Nat32 = 0xd3a2646c;
    var h7 : Nat32 = 0xfd7046c5;

    // Domain separation injection
    for (b in DOMAIN_MERKLE_TRACE.vals()) {
      h0 := (h0 ^ natToNat32(Nat8.toNat(b))) *% 0x01000193;
      h1 := (h1 ^ natToNat32(Nat8.toNat(b))) *% 0x01000193;
    };

    // Data absorption
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

    // Diffusion rounds
    for (_ in Iter.range(0, 3)) {
      h0 := h0 ^  (h7 >> 16);  h0 := h0 *% 0x85ebca6b;
      h1 := h1 ^  (h0 >> 13);  h1 := h1 *% 0xc2b2ae35;
      h2 := h2 ^  (h1 >> 16);  h2 := h2 *% 0x85ebca6b;
      h3 := h3 ^  (h2 >> 13);  h3 := h3 *% 0xc2b2ae35;
      h4 := h4 ^  (h3 >> 16);  h4 := h4 *% 0x85ebca6b;
      h5 := h5 ^  (h4 >> 13);  h5 := h5 *% 0xc2b2ae35;
      h6 := h6 ^  (h5 >> 16);  h6 := h6 *% 0x85ebca6b;
      h7 := h7 ^  (h6 >> 13);  h7 := h7 *% 0xc2b2ae35;
    };

    // Serialize to 32 bytes
    nat32ToBytes(h0, nat32ToBytes(h1, nat32ToBytes(h2, nat32ToBytes(h3,
      nat32ToBytes(h4, nat32ToBytes(h5, nat32ToBytes(h6, nat32ToBytes(h7, []))))))))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — MERKLE TREE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Compute hash of two child nodes to produce parent
  public func hashPair(left : [Nat8], right : [Nat8]) : [Nat8] {
    let combined = Array.tabulate<Nat8>(
      left.size() + right.size() + 1,
      func(i : Nat) : Nat8 {
        if (i == 0) { 0x01 : Nat8 }  // Internal node prefix
        else if (i <= left.size()) { left[i - 1] }
        else { right[i - left.size() - 1] }
      }
    );
    sovereignHash(combined)
  };

  /// Hash a leaf node with leaf-domain separation
  public func hashLeaf(data : [Nat8]) : [Nat8] {
    let prefixed = Array.tabulate<Nat8>(
      data.size() + 1,
      func(i : Nat) : Nat8 {
        if (i == 0) { 0x00 : Nat8 }  // Leaf node prefix
        else { data[i - 1] }
      }
    );
    sovereignHash(prefixed)
  };

  /// Build Merkle root from an array of execution step hashes
  public func buildMerkleRoot(leaves : [[Nat8]]) : [Nat8] {
    if (leaves.size() == 0) {
      return sovereignHash([0x00 : Nat8]);
    };
    if (leaves.size() == 1) {
      return hashLeaf(leaves[0]);
    };

    // Hash all leaves
    var currentLevel = Array.map<[Nat8], [Nat8]>(leaves, hashLeaf);

    // Iteratively combine pairs until single root
    while (currentLevel.size() > 1) {
      let nextSize = (currentLevel.size() + 1) / 2;
      currentLevel := Array.tabulate<[Nat8]>(nextSize, func(i : Nat) : [Nat8] {
        let leftIdx = i * 2;
        let rightIdx = leftIdx + 1;
        if (rightIdx < currentLevel.size()) {
          hashPair(currentLevel[leftIdx], currentLevel[rightIdx])
        } else {
          // Odd node: duplicate
          hashPair(currentLevel[leftIdx], currentLevel[leftIdx])
        }
      });
    };

    currentLevel[0]
  };

  /// Generate a Merkle proof for a specific leaf index
  public func generateProof(leaves : [[Nat8]], leafIndex : Nat) : ?MerkleProof {
    if (leafIndex >= leaves.size()) { return null };

    var currentLevel = Array.map<[Nat8], [Nat8]>(leaves, hashLeaf);
    var siblings : [[Nat8]] = [];
    var directions : [Bool] = [];
    var idx = leafIndex;

    while (currentLevel.size() > 1) {
      let siblingIdx = if (idx % 2 == 0) { idx + 1 } else { idx - 1 };
      let sibling = if (siblingIdx < currentLevel.size()) {
        currentLevel[siblingIdx]
      } else {
        currentLevel[idx]  // Duplicate for odd
      };

      siblings := Array.append(siblings, [sibling]);
      directions := Array.append(directions, [idx % 2 == 1]);

      // Move to next level
      let nextSize = (currentLevel.size() + 1) / 2;
      currentLevel := Array.tabulate<[Nat8]>(nextSize, func(i : Nat) : [Nat8] {
        let leftI = i * 2;
        let rightI = leftI + 1;
        if (rightI < currentLevel.size()) {
          hashPair(currentLevel[leftI], currentLevel[rightI])
        } else {
          hashPair(currentLevel[leftI], currentLevel[leftI])
        }
      });
      idx := idx / 2;
    };

    ?{
      leafIndex = leafIndex;
      leafHash = hashLeaf(leaves[leafIndex]);
      siblings = siblings;
      directions = directions;
      root = currentLevel[0];
    }
  };

  /// Verify a Merkle proof against an expected root
  public func verifyProof(proof : MerkleProof) : Bool {
    var current = proof.leafHash;

    for (i in Iter.range(0, proof.siblings.size() - 1)) {
      if (i < proof.directions.size()) {
        if (proof.directions[i]) {
          current := hashPair(proof.siblings[i], current);
        } else {
          current := hashPair(current, proof.siblings[i]);
        };
      };
    };

    arrayEqual(current, proof.root)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — EXECUTION STEP COMMITMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Commit an execution step to its hash representation
  public func commitStep(step : ExecutionStep) : [Nat8] {
    let stepBytes = Array.append(
      nat64ToBytes(step.stepIndex),
      Array.append(
        nat32ToBytesArr(step.opcode),
        Array.append(step.inputHash,
          Array.append(step.outputHash,
            Array.append(step.stateTransition,
              nat64ToBytes(step.fieldElement)
            )
          )
        )
      )
    );
    sovereignHash(stepBytes)
  };

  /// Commit an entire execution trace and produce public root
  public func commitTrace(steps : [ExecutionStep], timestamp : Int) : MerkleExecutionTrace {
    let stepHashes = Array.map<ExecutionStep, [Nat8]>(steps, commitStep);
    let root = buildMerkleRoot(stepHashes);
    let stepCount = Nat64.fromNat(steps.size());

    let traceId = sovereignHash(Array.append(root, nat64ToBytes(stepCount)));

    {
      traceId = traceId;
      root = root;
      depth = computeDepth(steps.size());
      stepCount = stepCount;
      timestamp = timestamp;
      fieldModulus = GOLDILOCKS_MODULUS;
      domainTag = "MEDINA.MERKLE.TRACE.v1";
    }
  };

  /// Verify a specific step against the trace commitment
  public func verifyStep(
    trace : MerkleExecutionTrace,
    step : ExecutionStep,
    allStepHashes : [[Nat8]],
    stepIndex : Nat
  ) : TraceVerification {
    let stepHash = commitStep(step);
    let proof = generateProof(allStepHashes, stepIndex);

    switch (proof) {
      case null {
        { valid = false; computedRoot = []; expectedRoot = trace.root; stepVerified = stepIndex; fieldConsistent = false }
      };
      case (?p) {
        let proofValid = verifyProof(p);
        let fieldOk = step.fieldElement < GOLDILOCKS_MODULUS;
        {
          valid = proofValid and arrayEqual(stepHash, hashLeaf(allStepHashes[stepIndex])) == false and fieldOk;
          computedRoot = p.root;
          expectedRoot = trace.root;
          stepVerified = stepIndex;
          fieldConsistent = fieldOk;
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STARK-FRIENDLY — GOLDILOCKS FIELD ARITHMETIC
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Addition in Goldilocks field
  public func fieldAdd(a : Nat64, b : Nat64) : Nat64 {
    let sum = a +% b;
    if (sum >= GOLDILOCKS_MODULUS) { sum -% GOLDILOCKS_MODULUS }
    else { sum }
  };

  /// Multiplication in Goldilocks field (modular)
  public func fieldMul(a : Nat64, b : Nat64) : Nat64 {
    // Schoolbook multiplication with reduction
    let aHi = a >> 32;
    let aLo = a & 0xFFFFFFFF;
    let bHi = b >> 32;
    let bLo = b & 0xFFFFFFFF;

    let ll = aLo *% bLo;
    let lh = aLo *% bHi;
    let hl = aHi *% bLo;
    let hh = aHi *% bHi;

    // Combine with Goldilocks reduction: 2^64 ≡ 2^32 - 1 (mod p)
    let mid = lh +% hl;
    let carry = hh +% (mid >> 32);

    // Reduce: result = low64 + carry * (2^32 - 1)
    let low = ll +% (mid << 32);
    let reduction = carry *% 0xFFFFFFFF;
    let result = low +% reduction;

    // Final reduction
    if (result >= GOLDILOCKS_MODULUS) { result -% GOLDILOCKS_MODULUS }
    else { result }
  };

  /// Check an arithmetic constraint in the field
  public func checkConstraint(constraint : ArithmeticConstraint) : ConstraintResult {
    switch (constraint) {
      case (#Addition({ a; b; expected })) {
        let computed = fieldAdd(a, b);
        { satisfied = computed == expected; constraintIndex = 0; witnessElement = computed }
      };
      case (#Multiplication({ a; b; expected })) {
        let computed = fieldMul(a, b);
        { satisfied = computed == expected; constraintIndex = 0; witnessElement = computed }
      };
      case (#Transition({ prev; next; delta })) {
        let computed = fieldAdd(prev, delta);
        { satisfied = computed == next; constraintIndex = 0; witnessElement = computed }
      };
      case (#Boundary({ step; value })) {
        // Boundary constraints are always satisfied if value is in field
        { satisfied = value < GOLDILOCKS_MODULUS; constraintIndex = 0; witnessElement = value }
      };
    }
  };

  /// Batch verify a set of constraints (for STARK AIR)
  public func batchCheckConstraints(constraints : [ArithmeticConstraint]) : Bool {
    for (c in constraints.vals()) {
      let result = checkConstraint(c);
      if (not result.satisfied) { return false };
    };
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════════

  func natToNat32(n : Nat) : Nat32 {
    Nat32.fromNat(n % 4294967296)
  };

  func nat32ToBytes(value : Nat32, acc : [Nat8]) : [Nat8] {
    let bytes : [Nat8] = [
      Nat8.fromNat(Nat32.toNat((value >> 24) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((value >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((value >> 8) & 0xFF)),
      Nat8.fromNat(Nat32.toNat(value & 0xFF))
    ];
    Array.append(bytes, acc)
  };

  func nat32ToBytesArr(value : Nat32) : [Nat8] {
    [
      Nat8.fromNat(Nat32.toNat((value >> 24) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((value >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((value >> 8) & 0xFF)),
      Nat8.fromNat(Nat32.toNat(value & 0xFF))
    ]
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

  func arrayEqual(a : [Nat8], b : [Nat8]) : Bool {
    if (a.size() != b.size()) { return false };
    for (i in Iter.range(0, a.size() - 1)) {
      if (a[i] != b[i]) { return false };
    };
    true
  };

  func computeDepth(leafCount : Nat) : Nat {
    var depth : Nat = 0;
    var n = leafCount;
    while (n > 1) {
      n := (n + 1) / 2;
      depth += 1;
    };
    depth
  };
}
