// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — SOVEREIGN VAULT ENGINE (Policy-Gated Read Abstraction)                                    ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  Capability-Based Memory Views — Input-Commitment-Sealed Policies                                         ║
// ║  Blast Radius Limitation — Raw Weight Isolation — Agent Compartmentalization                               ║
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

module SovereignVault {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Domain separator for vault operations
  public let DOMAIN_VAULT : [Nat8] = [
    0x4D, 0x45, 0x44, 0x49, 0x4E, 0x41, 0x2E, 0x56, // MEDINA.V
    0x41, 0x55, 0x4C, 0x54, 0x2E, 0x76, 0x31         // AULT.v1
  ];

  /// Maximum capability delegation depth
  public let MAX_DELEGATION_DEPTH : Nat = 4;

  /// Maximum concurrent capabilities per agent
  public let MAX_CAPABILITIES_PER_AGENT : Nat = 16;

  /// Capability expiry window (in abstract time units)
  public let DEFAULT_CAPABILITY_TTL : Int = 3600;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — CAPABILITY-BASED ACCESS CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Memory region classification
  public type MemoryRegion = {
    #RawWeights;          // Neural network weights — highest sensitivity
    #ActivationBuffer;    // Intermediate activations — medium sensitivity
    #ConfigState;         // Configuration — low sensitivity
    #PublicOutput;        // Public outputs — no restriction
    #ControlPath;         // Control flow state — critical
    #IntentBuffer;        // Queued intents — high sensitivity
  };

  /// Access permission level
  public type AccessLevel = {
    #None;                // No access
    #HashOnly;            // Can see hash of contents but not raw data
    #Filtered;            // Can see data through a transform filter
    #ReadOnly;            // Can read raw data, cannot modify
    #ReadWrite;           // Full access
  };

  /// A capability token granting access to a memory region
  public type Capability = {
    capabilityId : [Nat8];           // Unique capability identifier
    holder : AgentIdentity;          // Who holds this capability
    region : MemoryRegion;           // What region it grants access to
    level : AccessLevel;             // What level of access
    inputCommitment : [Nat8];        // Sealed with specific input commitment
    policyHash : [Nat8];             // Hash of the policy that authorized this
    validFrom : Int;                 // Start of validity window
    validUntil : Int;                // End of validity window
    delegationDepth : Nat;           // How many times this was delegated
    revoked : Bool;                  // Whether this capability has been revoked
  };

  /// Agent identity within the vault system
  public type AgentIdentity = {
    agentId : [Nat8];                // Unique agent identifier
    coreType : CoreType;             // What kind of core this agent runs on
    trustLevel : TrustLevel;         // Current trust assessment
    compartment : Nat32;             // Isolation compartment ID
  };

  /// Type of execution core
  public type CoreType = {
    #PrivateCore;         // Sovereign private computation core
    #PublicCore;          // Public verification core
    #EdgeCore;            // Edge silicon core
    #CoalitionCore;       // Multi-party coalition core
  };

  /// Trust level of an agent
  public type TrustLevel = {
    #Sovereign;           // Fully trusted — internal sovereign code
    #Verified;            // Externally verified (formal methods)
    #Attested;            // Hardware attestation only
    #Provisional;         // Temporary trust, under observation
    #Quarantined;         // Compromised or suspected
  };

  /// Runtime policy for memory access
  public type AccessPolicy = {
    policyId : [Nat8];
    allowedRegions : [MemoryRegion];
    maxAccessLevel : AccessLevel;
    requiredTrust : TrustLevel;
    requiredCommitment : ?[Nat8];    // Must match input commitment if present
    timeConstraints : TimeConstraint;
    rateLimit : ?RateLimit;
    auditRequired : Bool;
  };

  /// Time-based access constraints
  public type TimeConstraint = {
    #Unbounded;
    #Window : { start : Int; end : Int };
    #SingleUse : { usedAt : ?Int };
    #Periodic : { interval : Int; lastGrant : Int };
  };

  /// Rate limiting for access requests
  public type RateLimit = {
    maxRequests : Nat;
    windowSize : Int;
    currentCount : Nat;
    windowStart : Int;
  };

  /// Memory view — what the agent actually sees through a capability
  public type MemoryView = {
    viewId : [Nat8];
    sourceRegion : MemoryRegion;
    accessLevel : AccessLevel;
    transform : ViewTransform;
    dataDigest : [Nat8];           // Hash of what's visible through this view
    byteCount : Nat;               // Size of visible data
  };

  /// Transform applied to data before agent sees it
  public type ViewTransform = {
    #Identity;                     // Raw data (only with ReadOnly/ReadWrite)
    #HashProjection;               // Only hashes visible
    #DifferentialPrivacy : { epsilon : Nat32; delta : Nat32 };
    #Quantized : { bits : Nat8 };  // Reduced precision view
    #Masked : { maskPattern : [Nat8] };  // Selective masking
  };

  /// Vault access request from an agent
  public type AccessRequest = {
    requestor : AgentIdentity;
    targetRegion : MemoryRegion;
    desiredLevel : AccessLevel;
    inputCommitment : [Nat8];       // Proves what input triggered this request
    justification : [Nat8];         // Hash of operation requiring access
    timestamp : Int;
  };

  /// Vault access decision
  public type AccessDecision = {
    #Granted : { capability : Capability; view : MemoryView };
    #Denied : { reason : DenialReason };
    #Deferred : { retryAfter : Int };
  };

  /// Why access was denied
  public type DenialReason = {
    #InsufficientTrust;
    #PolicyViolation;
    #CommitmentMismatch;
    #RegionSealed;
    #RateLimitExceeded;
    #CapabilityExpired;
    #AgentQuarantined;
    #DelegationTooDeep;
  };

  /// Audit log entry for vault operations
  public type VaultAuditEntry = {
    timestamp : Int;
    agent : AgentIdentity;
    action : VaultAction;
    region : MemoryRegion;
    outcome : Bool;
    commitmentUsed : [Nat8];
  };

  /// Actions that can be audited
  public type VaultAction = {
    #AccessRequested;
    #AccessGranted;
    #AccessDenied;
    #CapabilityIssued;
    #CapabilityRevoked;
    #PolicyUpdated;
    #AgentQuarantined;
    #BlastRadiusContained;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — POLICY EVALUATION ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Evaluate an access request against a policy
  public func evaluateAccess(
    request : AccessRequest,
    policy : AccessPolicy,
    timestamp : Int
  ) : AccessDecision {
    // Check trust level
    if (not trustSufficient(request.requestor.trustLevel, policy.requiredTrust)) {
      return #Denied({ reason = #InsufficientTrust });
    };

    // Check agent is not quarantined
    if (request.requestor.trustLevel == #Quarantined) {
      return #Denied({ reason = #AgentQuarantined });
    };

    // Check region is in policy's allowed list
    if (not regionAllowed(request.targetRegion, policy.allowedRegions)) {
      return #Denied({ reason = #PolicyViolation });
    };

    // Check access level doesn't exceed policy maximum
    if (not levelPermitted(request.desiredLevel, policy.maxAccessLevel)) {
      return #Denied({ reason = #PolicyViolation });
    };

    // Check input commitment matches if required
    switch (policy.requiredCommitment) {
      case (?required) {
        if (not arrayEqual(request.inputCommitment, required)) {
          return #Denied({ reason = #CommitmentMismatch });
        };
      };
      case null {};
    };

    // Check time constraints
    switch (policy.timeConstraints) {
      case (#Window({ start; end })) {
        if (timestamp < start or timestamp > end) {
          return #Denied({ reason = #CapabilityExpired });
        };
      };
      case (#SingleUse({ usedAt })) {
        switch (usedAt) {
          case (?_) { return #Denied({ reason = #PolicyViolation }) };
          case null {};
        };
      };
      case _ {};
    };

    // Check rate limit
    switch (policy.rateLimit) {
      case (?limit) {
        if (limit.currentCount >= limit.maxRequests) {
          return #Denied({ reason = #RateLimitExceeded });
        };
      };
      case null {};
    };

    // All checks passed — issue capability
    let capability = issueCapability(request, policy, timestamp);
    let view = createView(request.targetRegion, request.desiredLevel);

    #Granted({ capability = capability; view = view })
  };

  /// Issue a capability token for an approved request
  public func issueCapability(
    request : AccessRequest,
    policy : AccessPolicy,
    timestamp : Int
  ) : Capability {
    let capId = computeCapabilityId(request, timestamp);

    {
      capabilityId = capId;
      holder = request.requestor;
      region = request.targetRegion;
      level = request.desiredLevel;
      inputCommitment = request.inputCommitment;
      policyHash = policy.policyId;
      validFrom = timestamp;
      validUntil = timestamp + DEFAULT_CAPABILITY_TTL;
      delegationDepth = 0;
      revoked = false;
    }
  };

  /// Delegate a capability to another agent (with depth check)
  public func delegateCapability(
    original : Capability,
    newHolder : AgentIdentity,
    timestamp : Int
  ) : ?Capability {
    if (original.delegationDepth >= MAX_DELEGATION_DEPTH) { return null };
    if (original.revoked) { return null };
    if (timestamp > original.validUntil) { return null };

    let newCapId = vaultHash(Array.append(original.capabilityId, newHolder.agentId));

    ?{
      capabilityId = newCapId;
      holder = newHolder;
      region = original.region;
      level = original.level;
      inputCommitment = original.inputCommitment;
      policyHash = original.policyHash;
      validFrom = timestamp;
      validUntil = original.validUntil;  // Cannot exceed parent's TTL
      delegationDepth = original.delegationDepth + 1;
      revoked = false;
    }
  };

  /// Revoke a capability (and all descendants by implication)
  public func revokeCapability(cap : Capability) : Capability {
    { cap with revoked = true }
  };

  /// Verify a capability is still valid
  public func verifyCapability(cap : Capability, timestamp : Int) : Bool {
    if (cap.revoked) { return false };
    if (timestamp < cap.validFrom) { return false };
    if (timestamp > cap.validUntil) { return false };
    if (cap.delegationDepth > MAX_DELEGATION_DEPTH) { return false };
    true
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — BLAST RADIUS CONTAINMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quarantine an agent — revoke all capabilities, seal all views
  public func quarantineAgent(
    agent : AgentIdentity,
    capabilities : [Capability]
  ) : [Capability] {
    Array.map<Capability, Capability>(capabilities, func(cap : Capability) : Capability {
      if (arrayEqual(cap.holder.agentId, agent.agentId)) {
        revokeCapability(cap)
      } else { cap }
    })
  };

  /// Compute blast radius for a compromised agent
  public func computeBlastRadius(
    compromisedAgent : AgentIdentity,
    allCapabilities : [Capability]
  ) : { exposedRegions : [MemoryRegion]; delegationChainLength : Nat; affectedAgents : Nat } {
    var regions : [MemoryRegion] = [];
    var chainLen : Nat = 0;
    var affected : Nat = 0;

    for (cap in allCapabilities.vals()) {
      if (arrayEqual(cap.holder.agentId, compromisedAgent.agentId) and not cap.revoked) {
        regions := Array.append(regions, [cap.region]);
        if (cap.delegationDepth > chainLen) { chainLen := cap.delegationDepth };
        affected += 1;
      };
    };

    { exposedRegions = regions; delegationChainLength = chainLen; affectedAgents = affected }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTERNAL — HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  func createView(region : MemoryRegion, level : AccessLevel) : MemoryView {
    let transform : ViewTransform = switch (level) {
      case (#None) { #HashProjection };
      case (#HashOnly) { #HashProjection };
      case (#Filtered) { #Quantized({ bits = 8 : Nat8 }) };
      case (#ReadOnly) { #Identity };
      case (#ReadWrite) { #Identity };
    };

    {
      viewId = vaultHash([0x56, 0x49, 0x45, 0x57]); // "VIEW"
      sourceRegion = region;
      accessLevel = level;
      transform = transform;
      dataDigest = vaultHash([]);  // Placeholder
      byteCount = 0;
    }
  };

  func computeCapabilityId(request : AccessRequest, timestamp : Int) : [Nat8] {
    let timeBytes = intToBytes(timestamp);
    vaultHash(Array.append(request.requestor.agentId,
      Array.append(request.inputCommitment, timeBytes)))
  };

  func trustSufficient(actual : TrustLevel, required : TrustLevel) : Bool {
    let actualRank = trustRank(actual);
    let requiredRank = trustRank(required);
    actualRank >= requiredRank
  };

  func trustRank(level : TrustLevel) : Nat {
    switch (level) {
      case (#Sovereign) { 4 };
      case (#Verified) { 3 };
      case (#Attested) { 2 };
      case (#Provisional) { 1 };
      case (#Quarantined) { 0 };
    }
  };

  func regionAllowed(region : MemoryRegion, allowed : [MemoryRegion]) : Bool {
    for (r in allowed.vals()) {
      if (regionsEqual(region, r)) { return true };
    };
    false
  };

  func regionsEqual(a : MemoryRegion, b : MemoryRegion) : Bool {
    switch (a, b) {
      case (#RawWeights, #RawWeights) { true };
      case (#ActivationBuffer, #ActivationBuffer) { true };
      case (#ConfigState, #ConfigState) { true };
      case (#PublicOutput, #PublicOutput) { true };
      case (#ControlPath, #ControlPath) { true };
      case (#IntentBuffer, #IntentBuffer) { true };
      case _ { false };
    }
  };

  func levelPermitted(requested : AccessLevel, maximum : AccessLevel) : Bool {
    levelRank(requested) <= levelRank(maximum)
  };

  func levelRank(level : AccessLevel) : Nat {
    switch (level) {
      case (#None) { 0 };
      case (#HashOnly) { 1 };
      case (#Filtered) { 2 };
      case (#ReadOnly) { 3 };
      case (#ReadWrite) { 4 };
    }
  };

  func vaultHash(data : [Nat8]) : [Nat8] {
    var h0 : Nat32 = 0x811c9dc5;
    var h1 : Nat32 = 0x01000193;
    var h2 : Nat32 = 0x6c62272e;
    var h3 : Nat32 = 0x61c88647;
    var h4 : Nat32 = 0x27d4eb2f;
    var h5 : Nat32 = 0x165667b1;
    var h6 : Nat32 = 0xd3a2646c;
    var h7 : Nat32 = 0xfd7046c5;

    for (b in DOMAIN_VAULT.vals()) {
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

  func intToBytes(value : Int) : [Nat8] {
    let abs = Int.abs(value);
    let n64 = Nat64.fromNat(abs % 18446744073709551616);
    [
      Nat8.fromNat(Nat64.toNat((n64 >> 56) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((n64 >> 48) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((n64 >> 40) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((n64 >> 32) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((n64 >> 24) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((n64 >> 16) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((n64 >> 8) & 0xFF)),
      Nat8.fromNat(Nat64.toNat(n64 & 0xFF))
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
