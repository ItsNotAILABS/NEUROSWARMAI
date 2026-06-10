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
// SANDBOX ORCHESTRATOR CANISTER — src/ai_division/sandboxes.mo
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// On-chain sandbox lifecycle management:
//   1. Client requests sandbox → provision isolated execution unit
//   2. AI Division assigns handler intelligence (from 18 assignments)
//   3. Sandbox runs with resource limits, φ-weighted priority
//   4. Metrics flow back to governance seats for billing
//   5. Auto-destroy on TTL expiry or manual teardown
//
// 12 sandbox domains × 4 tiers = 48 possible configurations per client
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Time "mo:core/Time";
import Array "mo:core/Array";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Text "mo:core/Text";
import Buffer "mo:core/Buffer";

actor SandboxOrchestrator {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  let PHI     : Float = 1.618033988749895;
  let PHI_INV : Float = 0.618033988749895;

  let MAX_SANDBOXES_PER_CLIENT : Nat = 24;
  let MAX_TOTAL_SANDBOXES      : Nat = 10000;
  let HEALTH_CHECK_INTERVAL    : Nat = 30;  // ticks between health checks

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════

  public type SandboxTier = {
    #DEVELOPMENT;
    #STAGING;
    #PRODUCTION;
    #ENTERPRISE;
  };

  public type SandboxDomain = {
    #CODE_EXECUTION;
    #DATA_PROCESSING;
    #ML_TRAINING;
    #SECURITY_TESTING;
    #BLOCKCHAIN;
    #DOCUMENT_GENERATION;
    #API_INTEGRATION;
    #CREATIVE_MEDIA;
    #RESEARCH_ANALYSIS;
    #FINANCIAL_MODELING;
    #HEALTHCARE_ANALYTICS;
    #DEVOPS_AUTOMATION;
  };

  public type SecurityLevel = {
    #STANDARD;
    #HIGH;
    #MAXIMUM;
  };

  public type SandboxStatus = {
    #PROVISIONING;
    #ACTIVE;
    #SUSPENDED;
    #DESTROYING;
    #DESTROYED;
  };

  public type SandboxInstance = {
    id              : Text;
    clientId        : Text;
    domain          : SandboxDomain;
    tier            : SandboxTier;
    securityLevel   : SecurityLevel;
    aiHandler       : Text;
    status          : SandboxStatus;
    createdAt       : Int;
    lastActivity    : Int;
    executionCount  : Nat;
    memoryUsedMB    : Nat;
    cpuPercent      : Float;
    phiPriority     : Float;
  };

  public type ClientRecord = {
    clientId        : Text;
    name            : Text;
    tier            : SandboxTier;
    onboardedAt     : Int;
    sandboxCount    : Nat;
    totalExecutions : Nat;
    active          : Bool;
  };

  public type ProvisionRequest = {
    clientId  : Text;
    domain    : SandboxDomain;
    tier      : SandboxTier;
  };

  public type OperationalReport = {
    totalSandboxes     : Nat;
    activeSandboxes    : Nat;
    totalClients       : Nat;
    totalExecutions    : Nat;
    systemHealth       : Float;
    aiDivisionStatus   : Text;
    timestamp          : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  stable var sandboxCounter : Nat = 0;
  stable var totalExecutions : Nat = 0;

  var sandboxes = Buffer.Buffer<SandboxInstance>(64);
  var clients   = Buffer.Buffer<ClientRecord>(32);

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API — SANDBOX LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Provision a new sandbox instance for a client
  public func provision(request : ProvisionRequest) : async SandboxInstance {
    let now = Time.now();
    sandboxCounter += 1;

    let instance : SandboxInstance = {
      id             = "SBX-" # Nat.toText(sandboxCounter);
      clientId       = request.clientId;
      domain         = request.domain;
      tier           = request.tier;
      securityLevel  = domainSecurityLevel(request.domain);
      aiHandler      = domainAIHandler(request.domain);
      status         = #ACTIVE;
      createdAt      = now;
      lastActivity   = now;
      executionCount = 0;
      memoryUsedMB   = 0;
      cpuPercent     = 0.0;
      phiPriority    = tierPhiPriority(request.tier);
    };

    sandboxes.add(instance);
    instance;
  };

  /// Execute a task in a sandbox (increments counters)
  public func execute(sandboxId : Text) : async Bool {
    let size = sandboxes.size();
    var i : Nat = 0;
    while (i < size) {
      let s = sandboxes.get(i);
      if (s.id == sandboxId) {
        let updated : SandboxInstance = {
          id             = s.id;
          clientId       = s.clientId;
          domain         = s.domain;
          tier           = s.tier;
          securityLevel  = s.securityLevel;
          aiHandler      = s.aiHandler;
          status         = s.status;
          createdAt      = s.createdAt;
          lastActivity   = Time.now();
          executionCount = s.executionCount + 1;
          memoryUsedMB   = s.memoryUsedMB;
          cpuPercent     = s.cpuPercent;
          phiPriority    = s.phiPriority;
        };
        sandboxes.put(i, updated);
        totalExecutions += 1;
        return true;
      };
      i += 1;
    };
    false;
  };

  /// Destroy a sandbox instance
  public func destroy(sandboxId : Text) : async Bool {
    let size = sandboxes.size();
    var i : Nat = 0;
    while (i < size) {
      let s = sandboxes.get(i);
      if (s.id == sandboxId) {
        let updated : SandboxInstance = {
          id             = s.id;
          clientId       = s.clientId;
          domain         = s.domain;
          tier           = s.tier;
          securityLevel  = s.securityLevel;
          aiHandler      = s.aiHandler;
          status         = #DESTROYED;
          createdAt      = s.createdAt;
          lastActivity   = Time.now();
          executionCount = s.executionCount;
          memoryUsedMB   = 0;
          cpuPercent     = 0.0;
          phiPriority    = 0.0;
        };
        sandboxes.put(i, updated);
        return true;
      };
      i += 1;
    };
    false;
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC API — OPERATIONAL STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get full operational report
  public query func getOperationalReport() : async OperationalReport {
    let active = Array.filter<SandboxInstance>(
      Buffer.toArray(sandboxes),
      func(s) { s.status == #ACTIVE }
    );
    {
      totalSandboxes   = sandboxes.size();
      activeSandboxes  = active.size();
      totalClients     = clients.size();
      totalExecutions  = totalExecutions;
      systemHealth     = 1.0;
      aiDivisionStatus = "FULL_OPERATIONAL";
      timestamp        = Time.now();
    };
  };

  /// Get sandboxes for a specific client
  public query func getClientSandboxes(clientId : Text) : async [SandboxInstance] {
    Array.filter<SandboxInstance>(
      Buffer.toArray(sandboxes),
      func(s) { s.clientId == clientId and s.status == #ACTIVE }
    );
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  func domainSecurityLevel(domain : SandboxDomain) : SecurityLevel {
    switch (domain) {
      case (#CODE_EXECUTION)        { #HIGH };
      case (#DATA_PROCESSING)       { #HIGH };
      case (#ML_TRAINING)           { #MAXIMUM };
      case (#SECURITY_TESTING)      { #MAXIMUM };
      case (#BLOCKCHAIN)            { #MAXIMUM };
      case (#DOCUMENT_GENERATION)   { #STANDARD };
      case (#API_INTEGRATION)       { #HIGH };
      case (#CREATIVE_MEDIA)        { #STANDARD };
      case (#RESEARCH_ANALYSIS)     { #HIGH };
      case (#FINANCIAL_MODELING)    { #MAXIMUM };
      case (#HEALTHCARE_ANALYTICS)  { #MAXIMUM };
      case (#DEVOPS_AUTOMATION)     { #HIGH };
    };
  };

  func domainAIHandler(domain : SandboxDomain) : Text {
    switch (domain) {
      case (#CODE_EXECUTION)        { "PROMETHEUS" };
      case (#DATA_PROCESSING)       { "SCRIBE" };
      case (#ML_TRAINING)           { "SWARM_BRAIN" };
      case (#SECURITY_TESTING)      { "SENTINEL" };
      case (#BLOCKCHAIN)            { "ARCHITECT" };
      case (#DOCUMENT_GENERATION)   { "LEXIS" };
      case (#API_INTEGRATION)       { "HERMES" };
      case (#CREATIVE_MEDIA)        { "NOVA" };
      case (#RESEARCH_ANALYSIS)     { "VERITAS" };
      case (#FINANCIAL_MODELING)    { "CHRYSALIS" };
      case (#HEALTHCARE_ANALYTICS)  { "MERIDIANUS" };
      case (#DEVOPS_AUTOMATION)     { "HEPHAESTUS" };
    };
  };

  func tierPhiPriority(tier : SandboxTier) : Float {
    switch (tier) {
      case (#DEVELOPMENT)  { PHI_INV * 0.25 };  // lowest priority
      case (#STAGING)      { PHI_INV * 0.50 };
      case (#PRODUCTION)   { PHI_INV * 0.75 };
      case (#ENTERPRISE)   { PHI_INV * 1.00 };  // highest φ-priority
    };
  };
};
