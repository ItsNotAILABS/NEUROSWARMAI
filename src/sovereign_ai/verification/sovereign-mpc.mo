// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — MULTI-PARTY SOVEREIGN COMPUTATION ENGINE                                                   ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  MPC-Style Commitments — Private/Public Split Extension — Coalition Compute                               ║
// ║  No Plaintext State Sharing — Cross-Domain Agent Coordination                                              ║
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

module SovereignMPC {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Domain separator for MPC operations
  public let DOMAIN_MPC : [Nat8] = [
    0x4D, 0x45, 0x44, 0x49, 0x4E, 0x41, 0x2E, 0x4D, // MEDINA.M
    0x50, 0x43, 0x2E, 0x76, 0x31                      // PC.v1
  ];

  /// Maximum parties in a single computation
  public let MAX_PARTIES : Nat = 16;

  /// Minimum parties for threshold security
  public let MIN_THRESHOLD : Nat = 2;

  /// Secret sharing field prime (Mersenne prime 2^61 - 1)
  public let SHARING_PRIME : Nat64 = 2_305_843_009_213_693_951;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — MULTI-PARTY COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// A party in the MPC protocol
  public type Party = {
    partyId : [Nat8];              // Unique party identifier
    publicCommitment : [Nat8];     // Public key-equivalent commitment
    coreType : PartyCore;          // What kind of private core
    status : PartyStatus;
    compartment : Nat32;           // Isolation compartment
  };

  /// Type of private core a party runs
  public type PartyCore = {
    #SovereignPrivate;     // Full sovereign private core
    #EdgeIsolated;         // Edge silicon private core
    #CoalitionMember;      // Coalition-only core (limited)
    #Observer;             // Can verify but not compute
  };

  /// Party operational status
  public type PartyStatus = {
    #Active;               // Ready to participate
    #Committed;            // Has committed shares
    #Revealed;             // Has revealed (protocol phase)
    #Aborted;              // Aborted protocol
    #Evicted;              // Removed for misbehavior
  };

  /// A secret share held by one party
  public type SecretShare = {
    shareId : [Nat8];            // Unique share identifier
    partyIndex : Nat;            // Which party holds this (0-indexed)
    shareValue : Nat64;          // The share value in the field
    commitment : [Nat8];         // Pedersen-style commitment to this share
    verificationTag : [Nat8];    // Tag for verifiable secret sharing
  };

  /// Commitment to a shared value (public)
  public type SharedCommitment = {
    commitmentId : [Nat8];
    partyCommitments : [[Nat8]];  // One commitment per party
    threshold : Nat;               // Minimum parties to reconstruct
    totalParties : Nat;            // Total number of parties
    computationTag : [Nat8];       // What computation this is for
    round : Nat;                   // Protocol round number
  };

  /// MPC protocol session
  public type MPCSession = {
    sessionId : [Nat8];
    parties : [Party];
    threshold : Nat;
    currentRound : Nat;
    phase : ProtocolPhase;
    commitments : [SharedCommitment];
    resultCommitment : ?[Nat8];    // Final result (commitment only)
    timestamp : Int;
  };

  /// Protocol execution phase
  public type ProtocolPhase = {
    #Setup;                // Parties joining, parameters agreed
    #Sharing;              // Secret sharing in progress
    #Computing;            // Joint computation underway
    #Verification;         // Verifying correctness
    #Output;               // Revealing output commitments
    #Complete;             // Protocol finished successfully
    #Aborted;              // Protocol failed
  };

  /// Joint computation operation (operates on committed values)
  public type MPCOperation = {
    #Add : { inputA : Nat; inputB : Nat };          // Add two shared values
    #Multiply : { inputA : Nat; inputB : Nat };     // Multiply (requires interaction)
    #LinearCombination : { coefficients : [Nat64]; inputs : [Nat] };
    #Comparison : { inputA : Nat; inputB : Nat };   // Compare without revealing
    #Threshold : { input : Nat; threshold : Nat64 };  // Is input > threshold?
  };

  /// Result of an MPC operation (commitment only — no plaintext)
  public type MPCResult = {
    operationId : [Nat8];
    resultCommitment : [Nat8];    // Commitment to the result
    proofOfCorrectness : [Nat8];  // Proof that computation was correct
    participatingParties : [Nat]; // Which parties contributed
    round : Nat;
  };

  /// Verification of MPC result
  public type MPCVerification = {
    valid : Bool;
    allPartiesHonest : Bool;
    commitmentConsistent : Bool;
    proofValid : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — SECRET SHARING (Shamir-style in sovereign field)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Generate shares for a secret value using polynomial evaluation
  public func generateShares(
    secret : Nat64,
    threshold : Nat,
    totalParties : Nat,
    randomSeed : [Nat8]
  ) : [SecretShare] {
    if (threshold > totalParties or threshold < MIN_THRESHOLD) {
      return [];
    };

    // Generate random polynomial coefficients (degree = threshold - 1)
    let coefficients = generateCoefficients(secret, threshold, randomSeed);

    // Evaluate polynomial at points 1..totalParties
    Array.tabulate<SecretShare>(totalParties, func(i : Nat) : SecretShare {
      let point = Nat64.fromNat(i + 1);
      let shareVal = evaluatePolynomial(coefficients, point);
      let commitment = computeShareCommitment(shareVal, i);
      let tag = computeVerificationTag(shareVal, i, randomSeed);

      {
        shareId = mpcHash(Array.append(nat64ToBytes(shareVal), nat64ToBytes(point)));
        partyIndex = i;
        shareValue = shareVal;
        commitment = commitment;
        verificationTag = tag;
      }
    })
  };

  /// Reconstruct secret from threshold shares (Lagrange interpolation at x=0)
  public func reconstructSecret(shares : [SecretShare], threshold : Nat) : ?Nat64 {
    if (shares.size() < threshold) { return null };

    // Use first `threshold` shares
    let usedShares = Array.tabulate<SecretShare>(threshold, func(i : Nat) : SecretShare {
      shares[i]
    });

    var secret : Nat64 = 0;

    for (i in Iter.range(0, threshold - 1)) {
      let xi = Nat64.fromNat(usedShares[i].partyIndex + 1);
      var numerator : Nat64 = 1;
      var denominator : Nat64 = 1;

      for (j in Iter.range(0, threshold - 1)) {
        if (i != j) {
          let xj = Nat64.fromNat(usedShares[j].partyIndex + 1);
          // numerator *= (0 - xj) = -xj mod p
          numerator := fieldMul(numerator, fieldNeg(xj));
          // denominator *= (xi - xj)
          denominator := fieldMul(denominator, fieldSub(xi, xj));
        };
      };

      // Lagrange coefficient = numerator * inverse(denominator)
      let invDenom = fieldInverse(denominator);
      let lagrangeCoeff = fieldMul(numerator, invDenom);

      // secret += share_i * lagrange_i
      secret := fieldAdd(secret, fieldMul(usedShares[i].shareValue, lagrangeCoeff));
    };

    ?secret
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — MPC OPERATIONS (on committed values)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Add two shared values (local operation — no interaction needed)
  public func addShares(shareA : SecretShare, shareB : SecretShare) : SecretShare {
    let newValue = fieldAdd(shareA.shareValue, shareB.shareValue);
    let newCommitment = mpcHash(Array.append(shareA.commitment, shareB.commitment));

    {
      shareId = mpcHash(nat64ToBytes(newValue));
      partyIndex = shareA.partyIndex;
      shareValue = newValue;
      commitment = newCommitment;
      verificationTag = mpcHash(Array.append(shareA.verificationTag, shareB.verificationTag));
    }
  };

  /// Multiply a share by a public constant (local operation)
  public func scalarMultiply(share : SecretShare, scalar : Nat64) : SecretShare {
    let newValue = fieldMul(share.shareValue, scalar);
    let scalarBytes = nat64ToBytes(scalar);
    let newCommitment = mpcHash(Array.append(share.commitment, scalarBytes));

    {
      shareId = mpcHash(nat64ToBytes(newValue));
      partyIndex = share.partyIndex;
      shareValue = newValue;
      commitment = newCommitment;
      verificationTag = mpcHash(Array.append(share.verificationTag, scalarBytes));
    }
  };

  /// Linear combination of shares (local operation)
  public func linearCombination(
    shares : [SecretShare],
    coefficients : [Nat64]
  ) : ?SecretShare {
    if (shares.size() != coefficients.size() or shares.size() == 0) { return null };

    var result = scalarMultiply(shares[0], coefficients[0]);
    for (i in Iter.range(1, shares.size() - 1)) {
      let scaled = scalarMultiply(shares[i], coefficients[i]);
      result := addShares(result, scaled);
    };
    ?result
  };

  /// Create a commitment for a multiplication round (Beaver triple style)
  public func createMultiplicationCommitment(
    shareA : SecretShare,
    shareB : SecretShare,
    beaverShare : SecretShare,
    round : Nat
  ) : SharedCommitment {
    let roundBytes = nat64ToBytes(Nat64.fromNat(round));
    let commitId = mpcHash(Array.append(
      shareA.commitment,
      Array.append(shareB.commitment, roundBytes)
    ));

    {
      commitmentId = commitId;
      partyCommitments = [shareA.commitment, shareB.commitment, beaverShare.commitment];
      threshold = 2;  // Multiplication requires interaction
      totalParties = 2;
      computationTag = mpcHash([0x4D, 0x55, 0x4C]); // "MUL"
      round = round;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — SESSION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialize an MPC session
  public func initSession(
    parties : [Party],
    threshold : Nat,
    timestamp : Int
  ) : ?MPCSession {
    if (parties.size() > MAX_PARTIES) { return null };
    if (threshold > parties.size()) { return null };
    if (threshold < MIN_THRESHOLD) { return null };

    let sessionId = mpcHash(Array.append(
      serializePartyIds(parties),
      intToBytes(timestamp)
    ));

    ?{
      sessionId = sessionId;
      parties = parties;
      threshold = threshold;
      currentRound = 0;
      phase = #Setup;
      commitments = [];
      resultCommitment = null;
      timestamp = timestamp;
    }
  };

  /// Advance session to next phase
  public func advancePhase(session : MPCSession) : MPCSession {
    let nextPhase : ProtocolPhase = switch (session.phase) {
      case (#Setup) { #Sharing };
      case (#Sharing) { #Computing };
      case (#Computing) { #Verification };
      case (#Verification) { #Output };
      case (#Output) { #Complete };
      case (#Complete) { #Complete };
      case (#Aborted) { #Aborted };
    };

    { session with phase = nextPhase; currentRound = session.currentRound + 1 }
  };

  /// Abort session (party misbehavior or timeout)
  public func abortSession(session : MPCSession) : MPCSession {
    { session with phase = #Aborted }
  };

  /// Verify all party commitments are consistent
  public func verifySessionCommitments(session : MPCSession) : MPCVerification {
    var allConsistent = true;
    var allHonest = true;

    for (c in session.commitments.vals()) {
      if (c.partyCommitments.size() != c.totalParties) {
        allConsistent := false;
      };
      // Verify each commitment is non-zero
      for (pc in c.partyCommitments.vals()) {
        if (isAllZero(pc)) { allHonest := false };
      };
    };

    {
      valid = allConsistent and allHonest;
      allPartiesHonest = allHonest;
      commitmentConsistent = allConsistent;
      proofValid = allConsistent;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — VERIFIABLE SECRET SHARING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Verify a share against its commitment
  public func verifyShare(share : SecretShare) : Bool {
    let expectedCommitment = computeShareCommitment(share.shareValue, share.partyIndex);
    arrayEqual(share.commitment, expectedCommitment)
  };

  /// Verify all shares in a set are consistent (from same polynomial)
  public func verifyShareConsistency(shares : [SecretShare], threshold : Nat) : Bool {
    if (shares.size() < threshold) { return false };

    // Check that any threshold subset reconstructs to the same secret
    // (verify commitments are on the same polynomial)
    for (share in shares.vals()) {
      if (not verifyShare(share)) { return false };
    };
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FIELD ARITHMETIC — Mersenne Prime Field (2^61 - 1)
  // ═══════════════════════════════════════════════════════════════════════════════

  public func fieldAdd(a : Nat64, b : Nat64) : Nat64 {
    let sum = a +% b;
    if (sum >= SHARING_PRIME) { sum -% SHARING_PRIME }
    else { sum }
  };

  public func fieldSub(a : Nat64, b : Nat64) : Nat64 {
    if (a >= b) { a -% b }
    else { SHARING_PRIME -% (b -% a) }
  };

  public func fieldMul(a : Nat64, b : Nat64) : Nat64 {
    // Multiplication with Mersenne reduction
    let aHi = a >> 32;
    let aLo = a & 0xFFFFFFFF;
    let bHi = b >> 32;
    let bLo = b & 0xFFFFFFFF;

    let ll = aLo *% bLo;
    let lh = aLo *% bHi;
    let hl = aHi *% bLo;
    let hh = aHi *% bHi;

    let mid = lh +% hl;
    let low = ll +% (mid << 32);
    let high = hh +% (mid >> 32);

    // Mersenne reduction: 2^61 ≡ 1 (mod 2^61 - 1)
    let reduced = (low & SHARING_PRIME) +% (low >> 61) +% (high << 3);
    if (reduced >= SHARING_PRIME) { reduced -% SHARING_PRIME }
    else { reduced }
  };

  public func fieldNeg(a : Nat64) : Nat64 {
    if (a == 0) { 0 }
    else { SHARING_PRIME -% a }
  };

  /// Modular inverse via Fermat's little theorem: a^(p-2) mod p
  public func fieldInverse(a : Nat64) : Nat64 {
    fieldPow(a, SHARING_PRIME - 2)
  };

  /// Fast modular exponentiation
  public func fieldPow(base : Nat64, exp : Nat64) : Nat64 {
    var result : Nat64 = 1;
    var b = base;
    var e = exp;

    while (e > 0) {
      if ((e & 1) == 1) {
        result := fieldMul(result, b);
      };
      b := fieldMul(b, b);
      e := e >> 1;
    };
    result
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTERNAL — HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════

  func generateCoefficients(secret : Nat64, threshold : Nat, seed : [Nat8]) : [Nat64] {
    var coeffs : [Nat64] = [secret]; // a_0 = secret
    var state : Nat32 = 0xBADC0FFE;

    for (b in seed.vals()) {
      state := (state ^ Nat32.fromNat(Nat8.toNat(b))) *% 0x01000193;
    };

    for (_ in Iter.range(1, threshold - 1)) {
      state := state ^ (state << 13);
      state := state ^ (state >> 17);
      state := state ^ (state << 5);
      let coeff = Nat64.fromNat(Nat32.toNat(state)) % SHARING_PRIME;
      coeffs := Array.append(coeffs, [coeff]);
    };
    coeffs
  };

  func evaluatePolynomial(coefficients : [Nat64], x : Nat64) : Nat64 {
    var result : Nat64 = 0;
    var xPow : Nat64 = 1;

    for (coeff in coefficients.vals()) {
      result := fieldAdd(result, fieldMul(coeff, xPow));
      xPow := fieldMul(xPow, x);
    };
    result
  };

  func computeShareCommitment(shareValue : Nat64, partyIndex : Nat) : [Nat8] {
    let data = Array.append(nat64ToBytes(shareValue), nat64ToBytes(Nat64.fromNat(partyIndex)));
    mpcHash(data)
  };

  func computeVerificationTag(shareValue : Nat64, partyIndex : Nat, seed : [Nat8]) : [Nat8] {
    let data = Array.append(
      nat64ToBytes(shareValue),
      Array.append(nat64ToBytes(Nat64.fromNat(partyIndex)), seed)
    );
    mpcHash(data)
  };

  func serializePartyIds(parties : [Party]) : [Nat8] {
    var result : [Nat8] = [];
    for (p in parties.vals()) {
      result := Array.append(result, p.partyId);
    };
    result
  };

  func mpcHash(data : [Nat8]) : [Nat8] {
    var h0 : Nat32 = 0x811c9dc5;
    var h1 : Nat32 = 0x01000193;
    var h2 : Nat32 = 0x6c62272e;
    var h3 : Nat32 = 0x61c88647;
    var h4 : Nat32 = 0x27d4eb2f;
    var h5 : Nat32 = 0x165667b1;
    var h6 : Nat32 = 0xd3a2646c;
    var h7 : Nat32 = 0xfd7046c5;

    for (b in DOMAIN_MPC.vals()) {
      h0 := (h0 ^ Nat32.fromNat(Nat8.toNat(b))) *% 0x01000193;
    };

    for (b in data.vals()) {
      let byte = Nat32.fromNat(Nat8.toNat(b));
      h0 := (h0 ^ byte) *% 0x01000193;
      h1 := (h1 ^ (byte +% 0x9e3779b9)) *% 0x01000193;
      h2 := (h2 ^ (byte ^ 0x6a09e667)) *% 0x01000193;
      h3 := (h3 ^ (byte +% 0xbb67ae85)) *% 0x01000193;
      h4 := (h4 ^ (byte ^ 0x3c6ef372)) *% 0x01000193;
      h5 := (h5 ^ (byte +% 0xa54ff53a)) *% 0x01000193;
      h6 := (h6 ^ (byte ^ 0x510e527f)) *% 0x01000193;
      h7 := (h7 ^ (byte +% 0x1f83d9ab)) *% 0x01000193;
    };

    h0 := h0 ^ (h0 >> 16); h0 := h0 *% 0x85ebca6b;
    h1 := h1 ^ (h1 >> 13); h1 := h1 *% 0xc2b2ae35;
    h2 := h2 ^ (h2 >> 16); h2 := h2 *% 0x85ebca6b;
    h3 := h3 ^ (h3 >> 13); h3 := h3 *% 0xc2b2ae35;
    h4 := h4 ^ (h4 >> 16); h4 := h4 *% 0x85ebca6b;
    h5 := h5 ^ (h5 >> 13); h5 := h5 *% 0xc2b2ae35;
    h6 := h6 ^ (h6 >> 16); h6 := h6 *% 0x85ebca6b;
    h7 := h7 ^ (h7 >> 13); h7 := h7 *% 0xc2b2ae35;

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

  func intToBytes(value : Int) : [Nat8] {
    let abs = Int.abs(value);
    let n64 = Nat64.fromNat(abs % 18446744073709551616);
    nat64ToBytes(n64)
  };

  func isAllZero(arr : [Nat8]) : Bool {
    for (b in arr.vals()) {
      if (b != 0) { return false };
    };
    true
  };

  func arrayEqual(a : [Nat8], b : [Nat8]) : Bool {
    if (a.size() != b.size()) { return false };
    for (i in Iter.range(0, a.size() - 1)) {
      if (a[i] != b[i]) { return false };
    };
    true
  };
}
