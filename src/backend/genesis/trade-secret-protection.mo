// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TRADE SECRET PROTECTION MODULE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements comprehensive trade secret protection for the organism's intellectual property.
//
// LEGAL FRAMEWORK:
// ────────────────
// 1. Defend Trade Secrets Act (18 U.S.C. § 1836) — Federal protection
// 2. Economic Espionage Act (18 U.S.C. §§ 1831-1839) — Criminal penalties
// 3. Texas Uniform Trade Secrets Act (TUTSA) — State-level protection
// 4. WIPO Copyright Treaty — International protection
//
// PROTECTED ELEMENTS:
// ───────────────────
// • Medina Doctrine mathematical formulations
// • Koine Force (kf) compounding algorithms
// • SACESI tier classification system
// • 43-core governance architecture
// • 7 Heritage node configurations
// • Jasmine's Law spherical helix
// • Genesis lock mechanisms
// • Quantum operator implementations
// • All naming conventions and data structures
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";
import Blob "mo:core/Blob";
import Principal "mo:core/Principal";
import Hash "mo:core/Hash";

module TradeSecretProtection {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: CLASSIFICATION LEVELS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Trade secret classification hierarchy
  public type ClassificationLevel = {
    #Level0_Public;           // Non-confidential, can be shared
    #Level1_Internal;         // Internal use only
    #Level2_Confidential;     // Confidential business information
    #Level3_TradeSecret;      // Full trade secret protection
    #Level4_HighlyRestricted; // Maximum protection, minimal access
    #Level5_Sovereign;        // Owner-only access
  };
  
  /// Classification metadata
  public type ClassificationMeta = {
    level : ClassificationLevel;
    label : Text;
    description : Text;
    encryptionRequired : Bool;
    auditRequired : Bool;
    retentionPeriod : Int;      // In nanoseconds, -1 for permanent
    maxAccessors : Nat;         // Maximum concurrent accessors
    crossBorderRestricted : Bool;
  };
  
  /// Get classification metadata
  public func getClassificationMeta(level : ClassificationLevel) : ClassificationMeta {
    switch (level) {
      case (#Level0_Public) {
        {
          level = level;
          label = "PUBLIC";
          description = "Non-confidential information that can be freely shared";
          encryptionRequired = false;
          auditRequired = false;
          retentionPeriod = -1;
          maxAccessors = 0;  // Unlimited
          crossBorderRestricted = false;
        }
      };
      case (#Level1_Internal) {
        {
          level = level;
          label = "INTERNAL";
          description = "Internal use only, not for external distribution";
          encryptionRequired = false;
          auditRequired = true;
          retentionPeriod = 31536000000000000;  // 1 year
          maxAccessors = 100;
          crossBorderRestricted = false;
        }
      };
      case (#Level2_Confidential) {
        {
          level = level;
          label = "CONFIDENTIAL";
          description = "Confidential business information requiring protection";
          encryptionRequired = true;
          auditRequired = true;
          retentionPeriod = 157680000000000000;  // 5 years
          maxAccessors = 25;
          crossBorderRestricted = true;
        }
      };
      case (#Level3_TradeSecret) {
        {
          level = level;
          label = "TRADE SECRET";
          description = "Full trade secret protection under DTSA/TUTSA";
          encryptionRequired = true;
          auditRequired = true;
          retentionPeriod = -1;  // Permanent
          maxAccessors = 10;
          crossBorderRestricted = true;
        }
      };
      case (#Level4_HighlyRestricted) {
        {
          level = level;
          label = "HIGHLY RESTRICTED";
          description = "Maximum protection, minimal access, critical IP";
          encryptionRequired = true;
          auditRequired = true;
          retentionPeriod = -1;
          maxAccessors = 5;
          crossBorderRestricted = true;
        }
      };
      case (#Level5_Sovereign) {
        {
          level = level;
          label = "SOVEREIGN";
          description = "Owner-only access, genesis-level protection";
          encryptionRequired = true;
          auditRequired = true;
          retentionPeriod = -1;
          maxAccessors = 1;
          crossBorderRestricted = true;
        }
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: PROTECTED ASSET REGISTRY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Protected asset type
  public type AssetType = {
    #Algorithm;       // Mathematical algorithms and formulations
    #Architecture;    // System architecture designs
    #DataStructure;   // Proprietary data structures
    #NamingConvention;// Naming conventions and terminology
    #ProcessMethod;   // Business processes and methods
    #Documentation;   // Technical documentation
    #SourceCode;      // Source code implementations
    #Configuration;   // System configurations
    #Genesis;         // Genesis-level parameters
    #Doctrine;        // Medina Doctrine components
  };
  
  /// Protected asset record
  public type ProtectedAsset = {
    id : Nat;
    name : Text;
    assetType : AssetType;
    classification : ClassificationLevel;
    owner : Principal;
    createdAt : Int;
    lastModified : Int;
    version : Nat;
    contentHash : Blob;           // SHA-256 hash of content
    merkleRoot : Blob;            // Merkle root for integrity
    authorizedPrincipals : [Principal];
    accessHistory : [AccessRecord];
    isActive : Bool;
    expirationDate : ?Int;
    dependencies : [Nat];         // Other assets this depends on
    derivedFrom : ?Nat;           // Parent asset if derivative
    legalNotes : Text;
  };
  
  /// Access record
  public type AccessRecord = {
    principal : Principal;
    timestamp : Int;
    accessType : AccessType;
    granted : Bool;
    reason : Text;
    sessionId : ?Blob;
  };
  
  /// Access type
  public type AccessType = {
    #Read;
    #Write;
    #Execute;
    #Derive;
    #Export;
    #Audit;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: TRADE SECRET STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Trade secret protection state
  public type TradeSecretState = {
    var assets : [ProtectedAsset];
    var accessLog : [AccessRecord];
    var violationLog : [ViolationRecord];
    var encryptionKeys : [(Nat, Blob)];  // assetId -> encrypted key
    var merkleRoots : [(Nat, Blob)];     // assetId -> merkle root
    var auditTrail : [AuditEntry];
    var violationCount : Nat;
    var lastAudit : Int;
    var lastIntegrityCheck : Int;
    var owner : Principal;
    var isLocked : Bool;
  };
  
  /// Violation record
  public type ViolationRecord = {
    id : Nat;
    assetId : Nat;
    principal : Principal;
    timestamp : Int;
    violationType : ViolationType;
    severity : ViolationSeverity;
    description : Text;
    ipHash : ?Blob;
    resolved : Bool;
    resolution : ?Text;
  };
  
  /// Violation type
  public type ViolationType = {
    #UnauthorizedAccess;
    #IntegrityViolation;
    #ExportAttempt;
    #ModificationAttempt;
    #DerivativeWithoutPermission;
    #ClassificationBreach;
    #AuditFailure;
    #EncryptionBypass;
  };
  
  /// Violation severity
  public type ViolationSeverity = {
    #Low;
    #Medium;
    #High;
    #Critical;
    #Sovereign;  // Immediate lockdown
  };
  
  /// Audit entry
  public type AuditEntry = {
    timestamp : Int;
    auditor : Principal;
    assetId : ?Nat;
    auditType : AuditType;
    findings : [Text];
    passed : Bool;
    recommendations : [Text];
  };
  
  /// Audit type
  public type AuditType = {
    #AccessReview;
    #IntegrityCheck;
    #ClassificationReview;
    #ComplianceAudit;
    #SecurityAudit;
    #FullAudit;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize trade secret state
  public func initTradeSecretState(owner : Principal) : TradeSecretState {
    {
      var assets = [];
      var accessLog = [];
      var violationLog = [];
      var encryptionKeys = [];
      var merkleRoots = [];
      var auditTrail = [];
      var violationCount = 0;
      var lastAudit = Time.now();
      var lastIntegrityCheck = Time.now();
      var owner = owner;
      var isLocked = false;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: ASSET REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Register a new protected asset
  public func registerAsset(
    state : TradeSecretState,
    name : Text,
    assetType : AssetType,
    classification : ClassificationLevel,
    authorizedPrincipals : [Principal],
    contentHash : Blob,
    merkleRoot : Blob,
    legalNotes : Text
  ) : Nat {
    let now = Time.now();
    let id = Array.size(state.assets);
    
    let asset : ProtectedAsset = {
      id = id;
      name = name;
      assetType = assetType;
      classification = classification;
      owner = state.owner;
      createdAt = now;
      lastModified = now;
      version = 1;
      contentHash = contentHash;
      merkleRoot = merkleRoot;
      authorizedPrincipals = authorizedPrincipals;
      accessHistory = [];
      isActive = true;
      expirationDate = null;
      dependencies = [];
      derivedFrom = null;
      legalNotes = legalNotes;
    };
    
    state.assets := Array.append(state.assets, [asset]);
    state.merkleRoots := Array.append(state.merkleRoots, [(id, merkleRoot)]);
    
    id;
  };
  
  /// Register Medina Doctrine assets
  public func registerMedinaDoctrine(state : TradeSecretState) {
    let emptyHash : Blob = "\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00";
    
    // Koine Force Algorithm
    let _ = registerAsset(
      state,
      "Koine Force (kf) Compounding Algorithm",
      #Algorithm,
      #Level5_Sovereign,
      [],
      emptyHash,
      emptyHash,
      "Core power constant driving all governance compounding. Protected under DTSA § 1836."
    );
    
    // SACESI Classification System
    let _ = registerAsset(
      state,
      "SACESI Tier Classification System",
      #Algorithm,
      #Level4_HighlyRestricted,
      [],
      emptyHash,
      emptyHash,
      "Sovereign Autonomous Compounding Engine for Sovereignty Intelligence. Protected under TUTSA."
    );
    
    // 43-Core Governance Architecture
    let _ = registerAsset(
      state,
      "43-Core Governance Architecture",
      #Architecture,
      #Level4_HighlyRestricted,
      [],
      emptyHash,
      emptyHash,
      "9-tier, 43-core governance body with differential compounding rates."
    );
    
    // Heritage Nodes
    let _ = registerAsset(
      state,
      "7 Heritage Governance Nodes",
      #Architecture,
      #Level3_TradeSecret,
      [],
      emptyHash,
      emptyHash,
      "REVOLUCIONARIO, ZAPATA, VILLA, INDEPENDENCIA, HIDALGO, ADELITA, MORELOS heritage nodes."
    );
    
    // Jasmine's Law
    let _ = registerAsset(
      state,
      "Jasmine's Spherical Helix Law (L-051)",
      #Algorithm,
      #Level5_Sovereign,
      [],
      emptyHash,
      emptyHash,
      "Governance field geometry equation. jasmine = sin(θ) × cos(φ) × kf + 1.0"
    );
    
    // Genesis Lock Mechanism
    let _ = registerAsset(
      state,
      "Genesis Lock Mechanism",
      #ProcessMethod,
      #Level5_Sovereign,
      [],
      emptyHash,
      emptyHash,
      "L_genesis computation and CHRONO immutable storage. Foundation of drift verification."
    );
    
    // Quantum Operators
    let _ = registerAsset(
      state,
      "Quantum Operator Suite",
      #Algorithm,
      #Level3_TradeSecret,
      [],
      emptyHash,
      emptyHash,
      "PARALLAX, ENTANGLA, CHRONO, VERITAS, BYPASS, QMEM, RESONEX operators."
    );
    
    // Resonance Lock Law
    let _ = registerAsset(
      state,
      "Resonance Lock Law (L-013)",
      #Algorithm,
      #Level4_HighlyRestricted,
      [],
      emptyHash,
      emptyHash,
      "forge += 0.002 × kf × coherence when kf > 1.8 AND coherence > 1.7"
    );
    
    // ARES Homeostatic Regulation
    let _ = registerAsset(
      state,
      "ARES Homeostatic Regulation",
      #Algorithm,
      #Level3_TradeSecret,
      [],
      emptyHash,
      emptyHash,
      "ΔV = -α(V - V_target) with Lyapunov stability verification."
    );
    
    // Law Engine Score
    let _ = registerAsset(
      state,
      "Law Engine Scoring System",
      #ProcessMethod,
      #Level4_HighlyRestricted,
      [],
      emptyHash,
      emptyHash,
      "Multi-law compliance scoring with weighted aggregation."
    );
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: ACCESS CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check if principal can access asset
  public func checkAccess(
    state : TradeSecretState,
    assetId : Nat,
    principal : Principal,
    accessType : AccessType
  ) : Bool {
    if (state.isLocked) {
      logViolation(state, assetId, principal, #UnauthorizedAccess, #Critical, "System is locked");
      return false;
    };
    
    if (assetId >= Array.size(state.assets)) {
      return false;
    };
    
    let asset = state.assets[assetId];
    let now = Time.now();
    
    // Owner always has access
    if (principal == state.owner) {
      logAccess(state, assetId, principal, accessType, true, "Owner access");
      return true;
    };
    
    // Check if asset is active
    if (not asset.isActive) {
      logAccess(state, assetId, principal, accessType, false, "Asset inactive");
      return false;
    };
    
    // Check expiration
    switch (asset.expirationDate) {
      case (?expDate) {
        if (now > expDate) {
          logAccess(state, assetId, principal, accessType, false, "Asset expired");
          return false;
        };
      };
      case (null) {};
    };
    
    // Check classification level restrictions
    let meta = getClassificationMeta(asset.classification);
    
    // Sovereign level is owner-only
    if (asset.classification == #Level5_Sovereign) {
      logViolation(state, assetId, principal, #UnauthorizedAccess, #Sovereign, "Sovereign access attempted");
      return false;
    };
    
    // Check authorized list
    let isAuthorized = Array.find<Principal>(asset.authorizedPrincipals, func(p) { p == principal }) != null;
    
    if (not isAuthorized) {
      logViolation(state, assetId, principal, #UnauthorizedAccess, #High, "Not in authorized list");
      return false;
    };
    
    // Check max accessors
    let currentAccessors = countRecentAccessors(state, assetId, 3600000000000);  // 1 hour window
    if (meta.maxAccessors > 0 and currentAccessors >= meta.maxAccessors) {
      logAccess(state, assetId, principal, accessType, false, "Max accessors reached");
      return false;
    };
    
    // Export requires special permission
    if (accessType == #Export) {
      if (meta.crossBorderRestricted) {
        logViolation(state, assetId, principal, #ExportAttempt, #High, "Export attempted on cross-border restricted asset");
        return false;
      };
    };
    
    logAccess(state, assetId, principal, accessType, true, "Authorized");
    true;
  };
  
  /// Log access attempt
  private func logAccess(
    state : TradeSecretState,
    assetId : Nat,
    principal : Principal,
    accessType : AccessType,
    granted : Bool,
    reason : Text
  ) {
    let record : AccessRecord = {
      principal = principal;
      timestamp = Time.now();
      accessType = accessType;
      granted = granted;
      reason = reason;
      sessionId = null;
    };
    
    state.accessLog := Array.append(state.accessLog, [record]);
    
    // Also add to asset history
    if (assetId < Array.size(state.assets)) {
      let asset = state.assets[assetId];
      let updatedAsset = {
        asset with
        accessHistory = Array.append(asset.accessHistory, [record]);
      };
      state.assets := Array.tabulate<ProtectedAsset>(
        Array.size(state.assets),
        func(i) {
          if (i == assetId) { updatedAsset }
          else { state.assets[i] }
        }
      );
    };
  };
  
  /// Count recent unique accessors
  private func countRecentAccessors(
    state : TradeSecretState,
    assetId : Nat,
    timeWindow : Int
  ) : Nat {
    let now = Time.now();
    let cutoff = now - timeWindow;
    
    var principals = Buffer.Buffer<Principal>(10);
    
    for (record in state.accessLog.vals()) {
      if (record.timestamp >= cutoff and record.granted) {
        var found = false;
        for (p in principals.vals()) {
          if (p == record.principal) { found := true };
        };
        if (not found) {
          principals.add(record.principal);
        };
      };
    };
    
    Buffer.size(principals);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: VIOLATION HANDLING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Log a violation
  public func logViolation(
    state : TradeSecretState,
    assetId : Nat,
    principal : Principal,
    violationType : ViolationType,
    severity : ViolationSeverity,
    description : Text
  ) {
    let id = Array.size(state.violationLog);
    
    let violation : ViolationRecord = {
      id = id;
      assetId = assetId;
      principal = principal;
      timestamp = Time.now();
      violationType = violationType;
      severity = severity;
      description = description;
      ipHash = null;
      resolved = false;
      resolution = null;
    };
    
    state.violationLog := Array.append(state.violationLog, [violation]);
    state.violationCount += 1;
    
    // Sovereign violations trigger immediate lockdown
    if (severity == #Sovereign) {
      state.isLocked := true;
    };
  };
  
  /// Resolve a violation
  public func resolveViolation(
    state : TradeSecretState,
    violationId : Nat,
    resolution : Text,
    caller : Principal
  ) : Bool {
    if (caller != state.owner) {
      return false;
    };
    
    if (violationId >= Array.size(state.violationLog)) {
      return false;
    };
    
    let violation = state.violationLog[violationId];
    let resolved : ViolationRecord = {
      violation with
      resolved = true;
      resolution = ?resolution;
    };
    
    state.violationLog := Array.tabulate<ViolationRecord>(
      Array.size(state.violationLog),
      func(i) {
        if (i == violationId) { resolved }
        else { state.violationLog[i] }
      }
    );
    
    true;
  };
  
  /// Get unresolved violations
  public func getUnresolvedViolations(state : TradeSecretState) : [ViolationRecord] {
    Array.filter<ViolationRecord>(state.violationLog, func(v) { not v.resolved });
  };
  
  /// Get violation count by severity
  public func getViolationsBySeverity(state : TradeSecretState, severity : ViolationSeverity) : [ViolationRecord] {
    Array.filter<ViolationRecord>(state.violationLog, func(v) { v.severity == severity });
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: INTEGRITY VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Verify asset integrity
  public func verifyIntegrity(
    state : TradeSecretState,
    assetId : Nat,
    currentHash : Blob
  ) : Bool {
    if (assetId >= Array.size(state.assets)) {
      return false;
    };
    
    let asset = state.assets[assetId];
    let hashMatches = blobEqual(asset.contentHash, currentHash);
    
    if (not hashMatches) {
      logViolation(state, assetId, state.owner, #IntegrityViolation, #Critical, "Content hash mismatch");
    };
    
    hashMatches;
  };
  
  /// Compare two blobs for equality
  private func blobEqual(a : Blob, b : Blob) : Bool {
    let aBytes = Blob.toArray(a);
    let bBytes = Blob.toArray(b);
    
    if (Array.size(aBytes) != Array.size(bBytes)) {
      return false;
    };
    
    for (i in Iter.range(0, Array.size(aBytes) - 1)) {
      if (aBytes[i] != bBytes[i]) {
        return false;
      };
    };
    
    true;
  };
  
  /// Run full integrity check on all assets
  public func runIntegrityAudit(
    state : TradeSecretState,
    hashes : [(Nat, Blob)]
  ) : AuditEntry {
    let now = Time.now();
    var findings = Buffer.Buffer<Text>(10);
    var passed = true;
    
    for ((assetId, hash) in hashes.vals()) {
      if (not verifyIntegrity(state, assetId, hash)) {
        findings.add("Asset " # Nat.toText(assetId) # " failed integrity check");
        passed := false;
      };
    };
    
    state.lastIntegrityCheck := now;
    
    let entry : AuditEntry = {
      timestamp = now;
      auditor = state.owner;
      assetId = null;
      auditType = #IntegrityCheck;
      findings = Buffer.toArray(findings);
      passed = passed;
      recommendations = if (passed) { [] } else { ["Investigate integrity violations immediately"] };
    };
    
    state.auditTrail := Array.append(state.auditTrail, [entry]);
    
    entry;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: LOCKDOWN CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock the system (emergency)
  public func lockSystem(state : TradeSecretState, caller : Principal) : Bool {
    if (caller != state.owner) {
      return false;
    };
    
    state.isLocked := true;
    true;
  };
  
  /// Unlock the system (requires owner)
  public func unlockSystem(state : TradeSecretState, caller : Principal) : Bool {
    if (caller != state.owner) {
      return false;
    };
    
    // Can only unlock if no unresolved sovereign violations
    let sovereignViolations = getViolationsBySeverity(state, #Sovereign);
    let unresolvedSovereign = Array.filter<ViolationRecord>(sovereignViolations, func(v) { not v.resolved });
    
    if (Array.size(unresolvedSovereign) > 0) {
      return false;
    };
    
    state.isLocked := false;
    true;
  };
  
  /// Check if system is locked
  public func isSystemLocked(state : TradeSecretState) : Bool {
    state.isLocked;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: COMPLIANCE REPORTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compliance status
  public type ComplianceStatus = {
    totalAssets : Nat;
    activeAssets : Nat;
    violationCount : Nat;
    unresolvedViolations : Nat;
    lastAudit : Int;
    lastIntegrityCheck : Int;
    isLocked : Bool;
    complianceScore : Float;  // 0.0-1.0
  };
  
  /// Get compliance status
  public func getComplianceStatus(state : TradeSecretState) : ComplianceStatus {
    let totalAssets = Array.size(state.assets);
    let activeAssets = Array.size(Array.filter<ProtectedAsset>(state.assets, func(a) { a.isActive }));
    let unresolvedViolations = Array.size(getUnresolvedViolations(state));
    
    // Calculate compliance score
    // Penalize for violations and unresolved issues
    var score : Float = 1.0;
    if (state.violationCount > 0) {
      score -= 0.1 * Float.fromInt(state.violationCount) / Float.fromInt(totalAssets + 1);
    };
    if (unresolvedViolations > 0) {
      score -= 0.2 * Float.fromInt(unresolvedViolations);
    };
    if (state.isLocked) {
      score -= 0.5;
    };
    if (score < 0.0) { score := 0.0 };
    
    {
      totalAssets = totalAssets;
      activeAssets = activeAssets;
      violationCount = state.violationCount;
      unresolvedViolations = unresolvedViolations;
      lastAudit = state.lastAudit;
      lastIntegrityCheck = state.lastIntegrityCheck;
      isLocked = state.isLocked;
      complianceScore = score;
    };
  };
  
  /// Generate compliance report
  public func generateComplianceReport(state : TradeSecretState) : Text {
    let status = getComplianceStatus(state);
    
    "═══════════════════════════════════════════════════════════════════════════════\n" #
    "TRADE SECRET PROTECTION COMPLIANCE REPORT\n" #
    "═══════════════════════════════════════════════════════════════════════════════\n" #
    "\n" #
    "Total Assets: " # Nat.toText(status.totalAssets) # "\n" #
    "Active Assets: " # Nat.toText(status.activeAssets) # "\n" #
    "Violation Count: " # Nat.toText(status.violationCount) # "\n" #
    "Unresolved Violations: " # Nat.toText(status.unresolvedViolations) # "\n" #
    "System Locked: " # Bool.toText(status.isLocked) # "\n" #
    "Compliance Score: " # Float.toText(status.complianceScore) # "\n" #
    "\n" #
    "LEGAL FRAMEWORK:\n" #
    "• Defend Trade Secrets Act (18 U.S.C. § 1836)\n" #
    "• Economic Espionage Act (18 U.S.C. §§ 1831-1839)\n" #
    "• Texas Uniform Trade Secrets Act (TUTSA)\n" #
    "• WIPO Copyright Treaty\n" #
    "\n" #
    "═══════════════════════════════════════════════════════════════════════════════\n";
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: HEARTBEAT INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Heartbeat check result
  public type HeartbeatResult = {
    complianceScore : Float;
    violationsDetected : Nat;
    integrityPassed : Bool;
    lockdownTriggered : Bool;
  };
  
  /// Run heartbeat check
  public func heartbeatCheck(state : TradeSecretState) : HeartbeatResult {
    let status = getComplianceStatus(state);
    
    // Check for critical conditions
    let criticalViolations = getViolationsBySeverity(state, #Critical);
    let unresolvedCritical = Array.filter<ViolationRecord>(criticalViolations, func(v) { not v.resolved });
    
    // Auto-lockdown if too many critical violations
    var lockdownTriggered = false;
    if (Array.size(unresolvedCritical) >= 3) {
      state.isLocked := true;
      lockdownTriggered := true;
    };
    
    {
      complianceScore = status.complianceScore;
      violationsDetected = status.unresolvedViolations;
      integrityPassed = status.complianceScore > 0.5;
      lockdownTriggered = lockdownTriggered;
    };
  };

};
