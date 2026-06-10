// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN TERMINAL — Motoko Implementation                                                               ║
// ║                                                                                                           ║
// ║  The supreme governance canister that oversees all intelligent beings within MERIDIANUS.                 ║
// ║  Enforces CPL (Cognitive Processing Law, Contract, Processing) specifications.                           ║
// ║  Manages versions, upgrades, and constitutional compliance.                                               ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Principal "mo:base/Principal";

actor SovereignTerminal {

  // ═══════════════════════════════════════════════════════════════════════════════
  // VERSION INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public let VERSION : Text = "1.0.0";
  public let VERSION_MAJOR : Nat = 1;
  public let VERSION_MINOR : Nat = 0;
  public let VERSION_PATCH : Nat = 0;
  public let COMPONENT_ID : Text = "FREDDY_SOVEREIGN_TERMINAL";
  public let COMPONENT_TYPE : Text = "GOVERNANCE_ENGINE";

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let S_ZERO : Float = 0.0036313133;
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let PHI_BEAT : Nat = 873;  // milliseconds
  public let F11 : Nat = 89;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  public type ComponentId = Text;
  public type Version = Text;

  public type ComponentType = {
    #EMBEDDING_ENGINE;
    #COGNITIVE_ARCHITECTURE;
    #TOKEN_ALLOCATOR;
    #TERMINAL_ARRAY;
    #SOVEREIGN_BEING;
    #INTEGRATION_ORCHESTRATOR;
    #LANGUAGE_SPEC;
    #GOVERNANCE_ENGINE;
  };

  public type ComponentStatus = {
    #ACTIVE;
    #DEPRECATED;
    #UPGRADING;
    #SAFE_MODE;
    #OFFLINE;
  };

  public type ComponentMetadata = {
    componentId: ComponentId;
    version: Version;
    componentType: ComponentType;
    status: ComponentStatus;
    location: Text;
    registered: Time.Time;
    lastUpdated: Time.Time;
    dependencies: [Text];
    capabilities: [Text];
    contractId: Text;
  };

  public type UpgradeApproval = {
    #AUTOMATIC;
    #SOVEREIGN_REVIEW;
    #CONSENSUS_REQUIRED;
    #DENIED;
  };

  public type ConstitutionalViolation = {
    componentId: ComponentId;
    ruleId: Text;
    severity: { #MINOR; #MODERATE; #CRITICAL };
    description: Text;
    timestamp: Time.Time;
  };

  public type GovernanceCycle = {
    cycleId: Nat;
    timestamp: Time.Time;
    componentsChecked: Nat;
    violationsFound: Nat;
    upgradesApproved: Nat;
    coherenceAvg: Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  // Component registry
  private stable var componentEntries : [(ComponentId, ComponentMetadata)] = [];
  private var components = HashMap.HashMap<ComponentId, ComponentMetadata>(10, Text.equal, Text.hash);

  // Violation log
  private stable var violationEntries : [(Nat, ConstitutionalViolation)] = [];
  private var violations = Buffer.Buffer<ConstitutionalViolation>(10);

  // Governance cycle history
  private stable var cycleEntries : [(Nat, GovernanceCycle)] = [];
  private var governanceCycles = Buffer.Buffer<GovernanceCycle>(10);

  // Counters
  private stable var cycleCounter : Nat = 0;
  private stable var violationCounter : Nat = 0;
  private stable var lastConstitutionalCheck : Time.Time = 0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPONENT REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Register a new component in the sovereign registry
  public shared func registerComponent(metadata: ComponentMetadata) : async Result.Result<Text, Text> {
    switch (components.get(metadata.componentId)) {
      case (?existing) {
        // Component exists, check if version changed
        if (existing.version != metadata.version) {
          // Version upgrade detected
          components.put(metadata.componentId, metadata);
          return #ok("Component upgraded: " # metadata.componentId # " " # existing.version # " → " # metadata.version);
        } else {
          return #err("Component already registered with same version");
        };
      };
      case null {
        // New component
        components.put(metadata.componentId, metadata);
        return #ok("Component registered: " # metadata.componentId # " v" # metadata.version);
      };
    };
  };

  /// Get component metadata
  public query func getComponent(componentId: ComponentId) : async ?ComponentMetadata {
    components.get(componentId)
  };

  /// List all registered components
  public query func listComponents() : async [ComponentMetadata] {
    Iter.toArray(components.vals())
  };

  /// Get component count
  public query func getComponentCount() : async Nat {
    components.size()
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VERSION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Parse semantic version (returns major, minor, patch)
  private func parseVersion(version: Version) : ?(Nat, Nat, Nat) {
    // Simplified version parsing (would use proper parser in production)
    // Expected format: "1.0.0"
    ?{1, 0, 0}  // Placeholder
  };

  /// Compare two versions (returns -1, 0, 1)
  private func compareVersions(v1: Version, v2: Version) : Int {
    // Simplified comparison
    if (v1 == v2) { 0 } else if (v1 < v2) { -1 } else { 1 }
  };

  /// Check if upgrade requires approval
  public func checkUpgradeApproval(
    componentId: ComponentId,
    currentVersion: Version,
    targetVersion: Version
  ) : async UpgradeApproval {
    // Determine version increment type
    switch (parseVersion(currentVersion), parseVersion(targetVersion)) {
      case (?current, ?target) {
        let (curMajor, curMinor, curPatch) = current;
        let (tgtMajor, tgtMinor, tgtPatch) = target;

        if (tgtMajor > curMajor) {
          // MAJOR version increment
          return #CONSENSUS_REQUIRED;
        } else if (tgtMinor > curMinor) {
          // MINOR version increment
          return #SOVEREIGN_REVIEW;
        } else if (tgtPatch > curPatch) {
          // PATCH version increment
          return #AUTOMATIC;
        } else {
          return #DENIED;
        };
      };
      case _ {
        return #DENIED;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTITUTIONAL GOVERNANCE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Perform constitutional check on all components
  public func constitutionalCheck() : async GovernanceCycle {
    cycleCounter += 1;
    let now = Time.now();
    lastConstitutionalCheck := now;

    var violationsFound : Nat = 0;
    var totalCoherence : Float = 0.0;
    var componentCount : Nat = 0;

    // Check each component
    for ((componentId, metadata) in components.entries()) {
      componentCount += 1;

      // IR-001: Identity Preservation
      if (metadata.componentId == "") {
        violations.add({
          componentId = componentId;
          ruleId = "IR-001";
          severity = #CRITICAL;
          description = "Missing component identity";
          timestamp = now;
        });
        violationsFound += 1;
      };

      // IR-002: Version format validation
      if (not isValidVersion(metadata.version)) {
        violations.add({
          componentId = componentId;
          ruleId = "IR-002";
          severity = #MODERATE;
          description = "Invalid version format";
          timestamp = now;
        });
        violationsFound += 1;
      };

      // IR-005: Audit trail (check if registered)
      if (metadata.registered == 0) {
        violations.add({
          componentId = componentId;
          ruleId = "IR-005";
          severity = #MINOR;
          description = "Missing registration timestamp";
          timestamp = now;
        });
        violationsFound += 1;
      };

      // Accumulate coherence (would be real metrics in production)
      totalCoherence += 0.85;
    };

    let cycle : GovernanceCycle = {
      cycleId = cycleCounter;
      timestamp = now;
      componentsChecked = componentCount;
      violationsFound = violationsFound;
      upgradesApproved = 0;
      coherenceAvg = if (componentCount > 0) { totalCoherence / Float.fromInt(componentCount) } else { 0.0 };
    };

    governanceCycles.add(cycle);
    return cycle;
  };

  /// Validate semantic version format
  private func isValidVersion(version: Version) : Bool {
    // Simple validation: should match X.Y.Z pattern
    let chars = Text.toIter(version);
    var dotCount = 0;
    for (c in chars) {
      if (c == '.') { dotCount += 1; };
    };
    dotCount == 2
  };

  /// Get recent violations
  public query func getViolations(limit: Nat) : async [ConstitutionalViolation] {
    let size = violations.size();
    let start = if (size > limit) { size - limit } else { 0 };
    let result = Buffer.Buffer<ConstitutionalViolation>(limit);

    var i = start;
    while (i < size) {
      result.add(violations.get(i));
      i += 1;
    };

    Buffer.toArray(result)
  };

  /// Get recent governance cycles
  public query func getGovernanceCycles(limit: Nat) : async [GovernanceCycle] {
    let size = governanceCycles.size();
    let start = if (size > limit) { size - limit } else { 0 };
    let result = Buffer.Buffer<GovernanceCycle>(limit);

    var i = start;
    while (i < size) {
      result.add(governanceCycles.get(i));
      i += 1;
    };

    Buffer.toArray(result)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════

  public type Stats = {
    totalComponents: Nat;
    activeComponents: Nat;
    totalViolations: Nat;
    totalCycles: Nat;
    lastCheckTime: Time.Time;
    version: Text;
  };

  public query func getStats() : async Stats {
    var activeCount = 0;
    for ((_, metadata) in components.entries()) {
      switch (metadata.status) {
        case (#ACTIVE) { activeCount += 1; };
        case _ {};
      };
    };

    {
      totalComponents = components.size();
      activeComponents = activeCount;
      totalViolations = violations.size();
      totalCycles = governanceCycles.size();
      lastCheckTime = lastConstitutionalCheck;
      version = VERSION;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UPGRADE HOOKS (STABLE MEMORY PERSISTENCE)
  // ═══════════════════════════════════════════════════════════════════════════════

  system func preupgrade() {
    componentEntries := Iter.toArray(components.entries());
    violationEntries := Iter.toArray(Iter.fromArray(Buffer.toArray(violations)).enumerate());
    cycleEntries := Iter.toArray(Iter.fromArray(Buffer.toArray(governanceCycles)).enumerate());
  };

  system func postupgrade() {
    components := HashMap.fromIter<ComponentId, ComponentMetadata>(
      componentEntries.vals(),
      10,
      Text.equal,
      Text.hash
    );

    violations := Buffer.Buffer<ConstitutionalViolation>(10);
    for ((_, violation) in violationEntries.vals()) {
      violations.add(violation);
    };

    governanceCycles := Buffer.Buffer<GovernanceCycle>(10);
    for ((_, cycle) in cycleEntries.vals()) {
      governanceCycles.add(cycle);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYSTEM INFO
  // ═══════════════════════════════════════════════════════════════════════════════

  public query func getSystemInfo() : async {
    componentId: Text;
    version: Text;
    componentType: Text;
    phiBeat: Nat;
    f11: Nat;
  } {
    {
      componentId = COMPONENT_ID;
      version = VERSION;
      componentType = COMPONENT_TYPE;
      phiBeat = PHI_BEAT;
      f11 = F11;
    }
  };
}
