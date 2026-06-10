// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// GEOMETRY LOCK SOVEREIGN CANISTER — src/geometry_lock/main.mo
// Clavis Geometrica — On-Chain Lock Division with Stable Persistence
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This is the immortal core of the Geometry Lock — PROTO-226 on-chain.
// While the JS entity lives in a browser session (mortal), this canister
// persists every validation outcome, bond, brain weight, and audit entry
// across upgrades and heartbeats.  It is the organism's long-term immune memory.
//
// KEY FEATURES:
//   • Stable vars — caller registry, brain weights, audit log, threshold survive upgrades
//   • Phase vector derivation — Motoko FNV-1a HMAC matching the JS fallback path;
//     upgrade to mo:sha2 package for cryptographic-grade HMAC-SHA-256
//   • Adaptive threshold — stored as stable var, updated by the guardian organism
//   • Brain weights — 6 Hebbian connection weights persisted across heartbeats
//   • Immune memory — every GRANTED/DENIED outcome updates the weight store
//   • Cross-canister calls — any ICP canister can call validateKey / registerCaller
//
// MOTOKO SHA-256 NOTE:
//   Cryptographic-grade HMAC-SHA-256 requires the external `mo:sha2` package.
//   Until it is added to dfx.json/mops.toml, we use a hardened FNV-1a HMAC
//   that is consistent with the JS fallback path.  The upgrade path is:
//     1. Add `mops add sha2` to the project
//     2. import SHA256 "mo:sha2/Sha256";
//     3. Replace hmacFnv with hmacSha256 using SHA256.fromBlob
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Time   "mo:core/Time";
import Array  "mo:core/Array";
import Float  "mo:core/Float";
import Int    "mo:core/Int";
import Nat    "mo:core/Nat";
import Nat32  "mo:core/Nat32";
import Nat64  "mo:core/Nat64";
import Text   "mo:core/Text";
import Buffer "mo:core/Buffer";
import Iter   "mo:core/Iter";
import Bool   "mo:core/Bool";

actor GeometryLock {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — φ-ALIGNED
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI         : Float = 1.618033988749895;
  let PHI_INV     : Float = 0.618033988749895;   // constitutional emergence threshold
  let HEARTBEAT   : Nat   = 873;                 // ms — organism φ-beat
  let KEY_DIMS    : Nat   = 8;                   // phase vector dimensions
  let MAX_CALLERS : Nat   = 233;                 // F13
  let MAX_AUDIT   : Nat   = 2584;               // F18
  let WEIGHT_COUNT: Nat   = 6;                  // Hebbian connection weights

  // FNV-1a constants
  let FNV_OFFSET  : Nat32 = 2166136261;
  let FNV_PRIME   : Nat32 = 16777619;

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type CallerRecord = {
    sharedSecret : Text;
    tier         : Text;
    description  : Text;
    registeredAt : Int;
    lastAccess   : Int;
    accessCount  : Nat;
    revoked      : Bool;
    revokedAt    : Int;
    maxAccess    : Int;  // -1 = unlimited
  };

  public type AuditEntry = {
    timestamp : Int;
    event     : Text;
    callerId  : Text;
    r         : Float;
    granted   : Bool;
    details   : Text;
  };

  public type ValidationResult = {
    granted   : Bool;
    r         : Float;
    psi       : Float;
    threshold : Float;
    callerId  : Text;
    tier      : Text;
    reason    : Text;
  };

  public type MetricsResult = {
    proto              : Text;
    totalCallers       : Nat;
    activeCallers      : Nat;
    totalValidations   : Nat;
    totalGranted       : Nat;
    totalDenied        : Nat;
    emergenceThreshold : Float;
    thresholdTightened : Bool;
    grantRate          : Float;
    phi                : Float;
    auditLogSize       : Nat;
    brainWeights       : [Float];
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STABLE VARS — survive canister upgrades and heartbeat cycles
  // ═══════════════════════════════════════════════════════════════════════════

  // Caller registry — serialised as parallel arrays for stable storage
  stable var _callerIds     : [Text]  = [];
  stable var _callerSecrets : [Text]  = [];
  stable var _callerTiers   : [Text]  = [];
  stable var _callerDescs   : [Text]  = [];
  stable var _callerRegAt   : [Int]   = [];
  stable var _callerLastAcc : [Int]   = [];
  stable var _callerAccCnt  : [Nat]   = [];
  stable var _callerRevoked : [Bool]  = [];
  stable var _callerRevAt   : [Int]   = [];
  stable var _callerMaxAcc  : [Int]   = [];

  // Global counters
  stable var _totalValidations : Nat = 0;
  stable var _totalGranted     : Nat = 0;
  stable var _totalDenied      : Nat = 0;
  stable var _totalRevocations : Nat = 0;

  // Adaptive Kuramoto threshold — tightens under attack, resets on recovery
  stable var _emergenceThreshold : Float = PHI_INV;

  // Brain weights — 6 Hebbian connection weights (immune memory persisted)
  // [0] PFC→AMY [1] AMY→PFC [2] PFC→HPC [3] HPC→PFC [4] AMY→HPC [5] HPC→AMY
  stable var _brainWeights : [var Float] = Array.init<Float>(WEIGHT_COUNT, 0.0);

  // Audit log — ring buffer (newest entries at end, oldest shifted off)
  stable var _auditLog : [AuditEntry] = [];

  // ═══════════════════════════════════════════════════════════════════════════
  // PRE / POST UPGRADE HOOKS
  // ═══════════════════════════════════════════════════════════════════════════

  // Nothing extra needed — stable vars are automatically preserved.
  // Hooks kept for future migration work.
  system func preupgrade() {};
  system func postupgrade() {};

  // ═══════════════════════════════════════════════════════════════════════════
  // FNV-1a HMAC — matching the JS fallback path
  // Upgrade path: replace with mo:sha2 HMAC-SHA-256 for cryptographic security
  // ═══════════════════════════════════════════════════════════════════════════

  func fnv1a(input : Text) : Nat32 {
    var hash : Nat32 = FNV_OFFSET;
    for (c in Text.toIter(input)) {
      let cp : Nat32 = Nat32.fromNat(Nat32.toNat(Text.hash(Text.fromChar(c))));
      hash := hash ^ cp;
      hash := hash *% FNV_PRIME;
    };
    hash
  };

  func hmacFnv(key : Text, message : Text) : Nat32 {
    let keyHash = fnv1a(key);
    let inner   = fnv1a(Nat32.toText(keyHash) # ":" # message);
    let outer   = fnv1a(Nat32.toText(inner) # ":" # Nat32.toText(keyHash));
    outer
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PHASE VECTOR DERIVATION
  // ═══════════════════════════════════════════════════════════════════════════

  func currentTimeWindow() : Nat {
    let nowMs = Int.abs(Time.now()) / 1_000_000;  // ns → ms
    nowMs / Int.abs(Float.toInt(Float.fromInt(HEARTBEAT) * PHI))
  };

  func derivePhaseAngle(secret : Text, callerId : Text, window : Nat, j : Nat) : Float {
    let material = hmacFnv(secret, callerId # ":" # Nat.toText(window) # ":" # Nat.toText(j));
    // Normalise Nat32 → [0, 2π)
    let u32AsFloat : Float = Float.fromInt(Nat32.toNat(material));
    let maxU32     : Float = 4_294_967_295.0;
    (u32AsFloat / maxU32) * 2.0 * 3.14159265358979323846
  };

  func buildPhaseVector(secret : Text, callerId : Text, window : Nat) : [Float] {
    Array.tabulate<Float>(KEY_DIMS, func(j) {
      derivePhaseAngle(secret, callerId, window, j)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // KURAMOTO ORDER PARAMETER
  // ═══════════════════════════════════════════════════════════════════════════

  func kuramotoR(deltas : [Float]) : (Float, Float) {
    let n = deltas.size();
    if (n == 0) return (0.0, 0.0);
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (d in deltas.vals()) {
      sumCos += Float.cos(d);
      sumSin += Float.sin(d);
    };
    let fn = Float.fromInt(n);
    let meanCos = sumCos / fn;
    let meanSin = sumSin / fn;
    let r   = Float.sqrt(meanCos * meanCos + meanSin * meanSin);
    let psi = Float.arctan(meanSin / (meanCos + 0.0001)); // atan approximation
    (r, psi)
  };

  func phaseDeltas(presented : [Float], envelope : [Float]) : [Float] {
    let pi = 3.14159265358979323846;
    Array.tabulate<Float>(KEY_DIMS, func(j) {
      var d = presented[j] - envelope[j];
      // Wrap to (-π, π]
      while (d >  pi) { d := d - 2.0 * pi };
      while (d < -pi) { d := d + 2.0 * pi };
      d
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // CALLER REGISTRY HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func callerCount() : Nat { _callerIds.size() };

  func findCaller(callerId : Text) : ?Nat {
    var i = 0;
    for (id in _callerIds.vals()) {
      if (id == callerId) return ?i;
      i += 1;
    };
    null
  };

  func getRecord(idx : Nat) : CallerRecord {
    {
      sharedSecret = _callerSecrets[idx];
      tier         = _callerTiers[idx];
      description  = _callerDescs[idx];
      registeredAt = _callerRegAt[idx];
      lastAccess   = _callerLastAcc[idx];
      accessCount  = _callerAccCnt[idx];
      revoked      = _callerRevoked[idx];
      revokedAt    = _callerRevAt[idx];
      maxAccess    = _callerMaxAcc[idx];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // AUDIT LOG HELPER
  // ═══════════════════════════════════════════════════════════════════════════

  func logAudit(event : Text, callerId : Text, r : Float, granted : Bool, details : Text) {
    let entry : AuditEntry = {
      timestamp = Time.now();
      event;
      callerId;
      r;
      granted;
      details;
    };
    let buf = Buffer.fromArray<AuditEntry>(_auditLog);
    buf.add(entry);
    if (buf.size() > MAX_AUDIT) {
      let _ = buf.remove(0);
    };
    _auditLog := Buffer.toArray(buf);
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // HEBBIAN IMMUNE MEMORY — updates stored brain weights
  // ═══════════════════════════════════════════════════════════════════════════

  func recordValidation(granted : Bool, r : Float) {
    if (granted) {
      // Reinforce PFC↔HIPPOCAMPUS bond pathways
      _brainWeights[2] := Float.min(1.0, _brainWeights[2] + 0.005 * r);  // PFC→HPC
      _brainWeights[3] := Float.min(1.0, _brainWeights[3] + 0.005 * r);  // HPC→PFC
    } else {
      let threat = 1.0 - r;
      // Reinforce AMYGDALA↔HIPPOCAMPUS threat pathways
      _brainWeights[4] := Float.min(1.0, _brainWeights[4] + 0.008 * threat); // AMY→HPC
      _brainWeights[5] := Float.min(1.0, _brainWeights[5] + 0.004 * threat); // HPC→AMY
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════════════════════════

  /**
   * Register a caller's shared secret with the lock.
   * Persisted in stable vars — survives upgrades and heartbeat cycles.
   */
  public func registerCaller(callerId : Text, sharedSecret : Text, tier : Text, description : Text, maxAccess : Int) : async { #ok; #err : Text } {
    if (Text.size(callerId) == 0)     return #err("invalid-caller-id");
    if (Text.size(sharedSecret) == 0) return #err("invalid-shared-secret");
    if (callerCount() >= MAX_CALLERS) return #err("registry-full");

    switch (findCaller(callerId)) {
      case (?_idx) { return #err("caller-already-registered") };
      case null {};
    };

    let now = Time.now();
    _callerIds     := Array.append(_callerIds,     [callerId]);
    _callerSecrets := Array.append(_callerSecrets, [sharedSecret]);
    _callerTiers   := Array.append(_callerTiers,   [if (Text.size(tier) > 0) tier else "standard"]);
    _callerDescs   := Array.append(_callerDescs,   [description]);
    _callerRegAt   := Array.append(_callerRegAt,   [now]);
    _callerLastAcc := Array.append(_callerLastAcc, [0]);
    _callerAccCnt  := Array.append(_callerAccCnt,  [0]);
    _callerRevoked := Array.append(_callerRevoked, [false]);
    _callerRevAt   := Array.append(_callerRevAt,   [0]);
    _callerMaxAcc  := Array.append(_callerMaxAcc,  [maxAccess]);

    logAudit("caller-registered", callerId, 0.0, true, "tier=" # tier);
    #ok
  };

  /**
   * Revoke a caller's resonance bond — permanently.
   * The revocation is stable — survives upgrades.
   */
  public func revokeKey(callerId : Text) : async { #ok; #err : Text } {
    switch (findCaller(callerId)) {
      case null { #err("caller-not-found") };
      case (?idx) {
        if (_callerRevoked[idx]) return #err("already-revoked");
        // Build new mutable arrays with the revocation applied
        let n = _callerIds.size();
        let newRevoked = Array.thaw<Bool>(_callerRevoked);
        let newRevAt   = Array.thaw<Int>(_callerRevAt);
        newRevoked[idx] := true;
        newRevAt[idx]   := Time.now();
        _callerRevoked := Array.freeze(newRevoked);
        _callerRevAt   := Array.freeze(newRevAt);
        _totalRevocations += 1;
        logAudit("key-revoked", callerId, 0.0, false, "");
        #ok
      };
    }
  };

  /**
   * Validate a geometric key token presented by a caller.
   *
   * Phase vector derivation uses FNV-1a HMAC (matching JS fallback).
   * The Kuramoto R is computed on-chain and the adaptive threshold applied.
   * Hebbian immune memory is updated regardless of outcome.
   */
  public func validateKey(callerId : Text, window : Nat, presentedPhases : [Float], signature : Nat32) : async ValidationResult {
    _totalValidations += 1;

    let denied : ValidationResult = {
      granted   = false;
      r         = 0.0;
      psi       = 0.0;
      threshold = _emergenceThreshold;
      callerId;
      tier      = "";
      reason    = "denied";
    };

    // Caller lookup
    switch (findCaller(callerId)) {
      case null {
        _totalDenied += 1;
        logAudit("key-denied", callerId, 0.0, false, "caller-not-registered");
        return { denied with reason = "caller-not-registered" };
      };
      case (?idx) {
        if (_callerRevoked[idx]) {
          _totalDenied += 1;
          logAudit("key-denied", callerId, 0.0, false, "caller-revoked");
          return { denied with reason = "caller-revoked" };
        };

        let rec = getRecord(idx);

        // Access limit check
        if (rec.maxAccess >= 0 and rec.accessCount >= Int.abs(rec.maxAccess)) {
          _totalDenied += 1;
          logAudit("key-denied", callerId, 0.0, false, "access-limit-reached");
          return { denied with reason = "access-limit-reached" };
        };

        // Phase vector size check
        if (presentedPhases.size() != KEY_DIMS) {
          _totalDenied += 1;
          logAudit("key-denied", callerId, 0.0, false, "invalid-phase-vector");
          return { denied with reason = "invalid-phase-vector" };
        };

        // Time window check (±1 window tolerance)
        let nowWindow = currentTimeWindow();
        let diff = if (window > nowWindow) window - nowWindow else nowWindow - window;
        if (diff > 1) {
          _totalDenied += 1;
          logAudit("key-denied", callerId, 0.0, false, "window-expired");
          return { denied with reason = "window-expired" };
        };

        // Reconstruct resonance envelope and compute Kuramoto R
        let envelope = buildPhaseVector(rec.sharedSecret, callerId, window);
        let deltas   = phaseDeltas(presentedPhases, envelope);
        let (r, psi) = kuramotoR(deltas);

        // Hebbian immune memory — update brain weights for every outcome
        recordValidation(r > _emergenceThreshold, r);

        if (r > _emergenceThreshold) {
          // Update mutable arrays for access tracking
          let newLastAcc = Array.thaw<Int>(_callerLastAcc);
          let newAccCnt  = Array.thaw<Nat>(_callerAccCnt);
          newLastAcc[idx] := Time.now();
          newAccCnt[idx]  := _callerAccCnt[idx] + 1;
          _callerLastAcc  := Array.freeze(newLastAcc);
          _callerAccCnt   := Array.freeze(newAccCnt);
          _totalGranted   += 1;
          logAudit("key-granted", callerId, r, true, "tier=" # rec.tier);
          return {
            granted   = true;
            r;
            psi;
            threshold = _emergenceThreshold;
            callerId;
            tier      = rec.tier;
            reason    = "";
          };
        } else {
          _totalDenied += 1;
          logAudit("key-denied", callerId, r, false, "resonance-below-threshold");
          return { denied with r; psi; reason = "resonance-below-threshold" };
        };
      };
    };
  };

  // ── Adaptive threshold — tightens under attack ─────────────────────────

  /**
   * Set the Kuramoto emergence threshold.
   * Called by guardian organism when posture changes:
   *   GREEN  → φ⁻¹         (0.618)
   *   YELLOW → φ⁻¹ + 0.05  (0.668)
   *   ORANGE → φ⁻¹ + 0.10  (0.718)
   *   RED    → φ⁻¹ + 0.15  (0.768)
   */
  public func setEmergenceThreshold(t : Float) : async () {
    if (t >= PHI_INV and t < 1.0) {
      _emergenceThreshold := t;
    };
  };

  public query func getEmergenceThreshold() : async Float {
    _emergenceThreshold
  };

  public func resetEmergenceThreshold() : async () {
    _emergenceThreshold := PHI_INV;
  };

  // ── Brain weight management ────────────────────────────────────────────

  /**
   * Sync Hebbian brain weights from the JS entity.
   * Called after each heartbeat to persist the session's learned weights.
   *
   * @param weights  Array of 6 Float values [w0…w5]
   */
  public func setBrainWeights(weights : [Float]) : async () {
    if (weights.size() == WEIGHT_COUNT) {
      for (i in Iter.range(0, WEIGHT_COUNT - 1)) {
        _brainWeights[i] := weights[i];
      };
    };
  };

  public query func getBrainWeights() : async [Float] {
    Array.freeze(_brainWeights)
  };

  // ── Queries ────────────────────────────────────────────────────────────

  public query func getCallerStatus(callerId : Text) : async { found : Bool; tier : Text; revoked : Bool; accessCount : Nat } {
    switch (findCaller(callerId)) {
      case null { { found = false; tier = ""; revoked = false; accessCount = 0 } };
      case (?idx) {
        {
          found       = true;
          tier        = _callerTiers[idx];
          revoked     = _callerRevoked[idx];
          accessCount = _callerAccCnt[idx];
        }
      };
    }
  };

  public query func getMetrics() : async MetricsResult {
    let active = Array.tabulate<Bool>(_callerIds.size(), func(i) { not _callerRevoked[i] });
    var activeCount = 0;
    for (a in active.vals()) { if (a) activeCount += 1 };

    let grantRate : Float = if (_totalValidations > 0) {
      Float.fromInt(_totalGranted) / Float.fromInt(_totalValidations)
    } else { 0.0 };

    {
      proto              = "PROTO-226";
      totalCallers       = _callerIds.size();
      activeCallers      = activeCount;
      totalValidations   = _totalValidations;
      totalGranted       = _totalGranted;
      totalDenied        = _totalDenied;
      emergenceThreshold = _emergenceThreshold;
      thresholdTightened = _emergenceThreshold > PHI_INV;
      grantRate;
      phi                = PHI;
      auditLogSize       = _auditLog.size();
      brainWeights       = Array.freeze(_brainWeights);
    }
  };

  public query func getAuditLog(count : Nat) : async [AuditEntry] {
    let n = _auditLog.size();
    let start = if (n > count) n - count else 0;
    Array.tabulate<AuditEntry>(n - start, func(i) { _auditLog[start + i] })
  };

}
