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
// BRAIN AGGREGATION LAYER — ORGANISM-WIDE DRIFT INDEX
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The BRAIN Aggregation Layer is the central nervous system of the drift verification architecture.
// It aggregates all compliance scores from all systems and computes the organism-wide drift index.
//
// CORE FUNCTIONS:
// ───────────────
// 1. Receive compliance scores from all 13 drift-gated systems
// 2. Compute organism-wide drift index (weighted sum)
// 3. Check global threshold → trigger full re-entrainment if exceeded
// 4. Provide drift telemetry (owner-gated, numeric only)
//
// ARCHITECTURE:
// ─────────────
// Every canister heartbeat:
//   ├── Each system computes L_live(system_i)
//   ├── Each system computes δ_drift = |L_live - L_genesis|
//   ├── If δ_drift > ε_i → law violation → cascade fires
//   └── Compliance score reported to BRAIN (numeric only)
//
// BRAIN aggregates all compliance scores:
//   ├── organism-wide drift index = weighted sum of all δ_drift values
//   ├── if organism-wide drift > global threshold → full re-entrainment
//   └── drift telemetry available as numeric query (owner-gated)
//
// THE DEEPEST INSIGHT:
// ───────────────────
// IRONCLAD's law system IS the verification layer. There is no separation.
// The law is not enforced from outside. It is the organism's own mathematics
// turning back on itself to verify its own fidelity to its genesis.
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

module BrainAggregationLayer {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let S_ZERO : Float = 1.0;
  
  // Number of drift-gated systems
  public let NUM_SYSTEMS : Nat = 13;
  
  // Global drift thresholds
  public let GLOBAL_DRIFT_WARNING : Float = 0.05;
  public let GLOBAL_DRIFT_VIOLATION : Float = 0.10;
  public let GLOBAL_DRIFT_CRITICAL : Float = 0.20;
  public let GLOBAL_DRIFT_CATASTROPHIC : Float = 0.30;
  
  // Re-entrainment thresholds
  public let FULL_REENTRAINMENT_THRESHOLD : Float = 0.15;
  public let PARTIAL_REENTRAINMENT_THRESHOLD : Float = 0.08;
  
  // Telemetry history size
  public let TELEMETRY_HISTORY_SIZE : Nat = 1000;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYSTEM IDENTIFIERS — All 13 drift-gated systems
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// SystemId identifies which system
  public type SystemId = {
    #BRAIN;
    #QUANTUM;
    #MEMORIA;
    #NEUROCHEM;
    #SUBSTRATE;
    #SIMULACRUM;
    #CORTEX;
    #GENOME;
    #SOCIO;
    #VERITAS;
    #AEGIS;
    #WALLET;
    #BEHAVIORAL;
  };
  
  /// Get system name
  public func getSystemName(id : SystemId) : Text {
    switch (id) {
      case (#BRAIN) { "BRAIN" };
      case (#QUANTUM) { "QUANTUM" };
      case (#MEMORIA) { "MEMORIA" };
      case (#NEUROCHEM) { "NEUROCHEM" };
      case (#SUBSTRATE) { "SUBSTRATE" };
      case (#SIMULACRUM) { "SIMULACRUM" };
      case (#CORTEX) { "CORTEX" };
      case (#GENOME) { "GENOME" };
      case (#SOCIO) { "SOCIO" };
      case (#VERITAS) { "VERITAS" };
      case (#AEGIS) { "AEGIS" };
      case (#WALLET) { "WALLET" };
      case (#BEHAVIORAL) { "BEHAVIORAL" };
    }
  };
  
  /// Get system weight for aggregation
  public func getSystemWeight(id : SystemId) : Float {
    switch (id) {
      case (#VERITAS) { 2.0 };    // Most critical
      case (#AEGIS) { 1.8 };
      case (#BRAIN) { 1.5 };
      case (#QUANTUM) { 1.4 };
      case (#GENOME) { 1.3 };
      case (#CORTEX) { 1.2 };
      case (#MEMORIA) { 1.1 };
      case (#NEUROCHEM) { 1.0 };
      case (#SUBSTRATE) { 1.0 };
      case (#SIMULACRUM) { 0.9 };
      case (#SOCIO) { 0.9 };
      case (#WALLET) { 0.8 };
      case (#BEHAVIORAL) { 0.8 };
    }
  };
  
  /// Get all system IDs
  public func getAllSystemIds() : [SystemId] {
    [#BRAIN, #QUANTUM, #MEMORIA, #NEUROCHEM, #SUBSTRATE, #SIMULACRUM, 
     #CORTEX, #GENOME, #SOCIO, #VERITAS, #AEGIS, #WALLET, #BEHAVIORAL]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLIANCE SCORE — Input from each system
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ComplianceScore from a single system
  public type ComplianceScore = {
    /// System ID
    systemId : SystemId;
    
    /// System name
    systemName : Text;
    
    /// L_genesis value (locked at formation)
    lawGenesis : Float;
    
    /// L_live value (current)
    lawLive : Float;
    
    /// δ_drift = |L_live - L_genesis|
    drift : Float;
    
    /// Compliance score [0, 1] where 1 = perfect compliance
    compliance : Float;
    
    /// Is this a violation?
    isViolation : Bool;
    
    /// Epsilon threshold for this system
    epsilon : Float;
    
    /// Timestamp of measurement
    timestamp : Int;
    
    /// Heartbeat of measurement
    heartbeat : Nat;
    
    /// Was correction applied?
    correctionApplied : Bool;
    
    /// Correction type if applied
    correctionType : ?Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ORGANISM-WIDE DRIFT INDEX
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// DriftStatus classification
  public type DriftStatus = {
    #Nominal;       // All systems healthy
    #Warning;       // Approaching threshold
    #Violation;     // One or more violations
    #Critical;      // Multiple violations or critical system breach
    #Catastrophic;  // Severe drift, emergency measures needed
    #Halted;        // Organism halted (VERITAS/AEGIS breach)
  };
  
  /// OrganismDriftIndex is the aggregated drift state
  public type OrganismDriftIndex = {
    /// All system compliance scores
    systemScores : [ComplianceScore];
    
    /// Weighted aggregate drift
    aggregateDrift : Float;
    
    /// Maximum single-system drift
    maxSystemDrift : Float;
    
    /// System with maximum drift
    maxDriftSystem : SystemId;
    
    /// Minimum compliance score
    minCompliance : Float;
    
    /// System with minimum compliance
    minComplianceSystem : SystemId;
    
    /// Number of violations
    violationCount : Nat;
    
    /// Systems in violation
    violatingSystems : [SystemId];
    
    /// Overall status
    status : DriftStatus;
    
    /// Is full re-entrainment needed?
    fullReentrainmentNeeded : Bool;
    
    /// Is partial re-entrainment needed?
    partialReentrainmentNeeded : Bool;
    
    /// Heartbeat
    heartbeat : Nat;
    
    /// Timestamp
    timestamp : Int;
    
    /// Organism health score [0, 1]
    healthScore : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RE-ENTRAINMENT STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ReentrainmentType classification
  public type ReentrainmentType = {
    #None;          // No re-entrainment
    #Partial;       // Partial re-entrainment (specific systems)
    #Full;          // Full organism re-entrainment
    #Emergency;     // Emergency re-entrainment
  };
  
  /// ReentrainmentState tracks active re-entrainment
  public type ReentrainmentState = {
    /// Type of re-entrainment
    reentrainmentType : ReentrainmentType;
    
    /// Is re-entrainment active?
    isActive : Bool;
    
    /// Target systems (for partial)
    targetSystems : [SystemId];
    
    /// Strength of re-entrainment pulse
    strength : Float;
    
    /// Duration in heartbeats
    duration : Nat;
    
    /// Remaining heartbeats
    remainingBeats : Nat;
    
    /// Progress [0, 1]
    progress : Float;
    
    /// Trigger drift value
    triggerDrift : Float;
    
    /// Start heartbeat
    startHeartbeat : Nat;
    
    /// Total re-entrainments
    totalReentrainments : Nat;
    
    /// Successful re-entrainments
    successfulReentrainments : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT TELEMETRY — Owner-gated numeric data
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// TelemetrySnapshot is a single telemetry record
  public type TelemetrySnapshot = {
    /// Heartbeat number
    heartbeat : Nat;
    
    /// Timestamp
    timestamp : Int;
    
    /// Aggregate drift
    aggregateDrift : Float;
    
    /// Health score
    healthScore : Float;
    
    /// Status code (0=Nominal, 1=Warning, 2=Violation, 3=Critical, 4=Catastrophic, 5=Halted)
    statusCode : Nat8;
    
    /// Violation count
    violationCount : Nat;
    
    /// Was re-entrainment active?
    reentrainmentActive : Bool;
    
    /// Per-system drift values (13 values)
    systemDrifts : [Float];
    
    /// Per-system compliance values (13 values)
    systemCompliances : [Float];
  };
  
  /// DriftTelemetry stores historical data
  public type DriftTelemetry = {
    /// Rolling history of snapshots
    history : [TelemetrySnapshot];
    
    /// Maximum history size
    maxSize : Nat;
    
    /// Current index (circular buffer)
    currentIndex : Nat;
    
    /// Total snapshots recorded
    totalSnapshots : Nat;
    
    /// Average drift over history
    averageDrift : Float;
    
    /// Peak drift in history
    peakDrift : Float;
    
    /// Peak drift heartbeat
    peakDriftHeartbeat : Nat;
    
    /// Total violations in history
    totalViolations : Nat;
    
    /// Total re-entrainments in history
    totalReentrainments : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE BRAIN AGGREGATION STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// BrainAggregationState is the complete state of the aggregation layer
  public type BrainAggregationState = {
    /// Current drift index
    driftIndex : OrganismDriftIndex;
    
    /// Re-entrainment state
    reentrainment : ReentrainmentState;
    
    /// Drift telemetry
    telemetry : DriftTelemetry;
    
    /// Genesis values locked?
    isGenesisLocked : Bool;
    
    /// Genesis lock heartbeat
    genesisLockHeartbeat : Nat;
    
    /// Genesis aggregate drift (should be ~0)
    genesisAggregateDrift : Float;
    
    /// Current heartbeat
    currentHeartbeat : Nat;
    
    /// Last update timestamp
    lastUpdate : Int;
    
    /// Owner principal (for telemetry access)
    ownerPrincipal : Text;
    
    /// Is system initialized?
    isInitialized : Bool;
    
    /// Organism ID
    organismId : Text;
    
    /// Total heartbeats processed
    totalHeartbeats : Nat;
    
    /// Is organism halted?
    isHalted : Bool;
    
    /// Halt reason
    haltReason : ?Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create default compliance score
  public func createDefaultComplianceScore(id : SystemId) : ComplianceScore {
    {
      systemId = id;
      systemName = getSystemName(id);
      lawGenesis = 0.0;
      lawLive = 0.0;
      drift = 0.0;
      compliance = 1.0;
      isViolation = false;
      epsilon = 0.05;
      timestamp = Time.now();
      heartbeat = 0;
      correctionApplied = false;
      correctionType = null;
    }
  };
  
  /// Create default drift index
  public func createDefaultDriftIndex() : OrganismDriftIndex {
    let systems = getAllSystemIds();
    {
      systemScores = Array.tabulate<ComplianceScore>(NUM_SYSTEMS, func(i : Nat) : ComplianceScore {
        createDefaultComplianceScore(systems[i])
      });
      aggregateDrift = 0.0;
      maxSystemDrift = 0.0;
      maxDriftSystem = #BRAIN;
      minCompliance = 1.0;
      minComplianceSystem = #BRAIN;
      violationCount = 0;
      violatingSystems = [];
      status = #Nominal;
      fullReentrainmentNeeded = false;
      partialReentrainmentNeeded = false;
      heartbeat = 0;
      timestamp = Time.now();
      healthScore = 1.0;
    }
  };
  
  /// Create default re-entrainment state
  public func createDefaultReentrainmentState() : ReentrainmentState {
    {
      reentrainmentType = #None;
      isActive = false;
      targetSystems = [];
      strength = 0.0;
      duration = 0;
      remainingBeats = 0;
      progress = 0.0;
      triggerDrift = 0.0;
      startHeartbeat = 0;
      totalReentrainments = 0;
      successfulReentrainments = 0;
    }
  };
  
  /// Create default telemetry
  public func createDefaultTelemetry() : DriftTelemetry {
    {
      history = [];
      maxSize = TELEMETRY_HISTORY_SIZE;
      currentIndex = 0;
      totalSnapshots = 0;
      averageDrift = 0.0;
      peakDrift = 0.0;
      peakDriftHeartbeat = 0;
      totalViolations = 0;
      totalReentrainments = 0;
    }
  };
  
  /// Create default brain aggregation state
  public func createDefaultBrainAggregationState(organismId : Text, ownerPrincipal : Text) : BrainAggregationState {
    {
      driftIndex = createDefaultDriftIndex();
      reentrainment = createDefaultReentrainmentState();
      telemetry = createDefaultTelemetry();
      isGenesisLocked = false;
      genesisLockHeartbeat = 0;
      genesisAggregateDrift = 0.0;
      currentHeartbeat = 0;
      lastUpdate = Time.now();
      ownerPrincipal = ownerPrincipal;
      isInitialized = true;
      organismId = organismId;
      totalHeartbeats = 0;
      isHalted = false;
      haltReason = null;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT INDEX COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute organism drift index from all system scores
  public func computeDriftIndex(
    scores : [ComplianceScore],
    heartbeat : Nat
  ) : OrganismDriftIndex {
    // Compute weighted aggregate drift
    var weightedSum : Float = 0.0;
    var totalWeight : Float = 0.0;
    var maxDrift : Float = 0.0;
    var maxDriftSystem : SystemId = #BRAIN;
    var minCompliance : Float = 1.0;
    var minComplianceSystem : SystemId = #BRAIN;
    var violationCount : Nat = 0;
    let violatingSystems = Buffer.Buffer<SystemId>(0);
    var hasVeritasViolation = false;
    var hasAegisViolation = false;
    
    for (i in Iter.range(0, Array.size(scores) - 1)) {
      let score = scores[i];
      let weight = getSystemWeight(score.systemId);
      
      weightedSum += score.drift * weight;
      totalWeight += weight;
      
      if (score.drift > maxDrift) {
        maxDrift := score.drift;
        maxDriftSystem := score.systemId;
      };
      
      if (score.compliance < minCompliance) {
        minCompliance := score.compliance;
        minComplianceSystem := score.systemId;
      };
      
      if (score.isViolation) {
        violationCount += 1;
        violatingSystems.add(score.systemId);
        
        switch (score.systemId) {
          case (#VERITAS) { hasVeritasViolation := true; };
          case (#AEGIS) { hasAegisViolation := true; };
          case _ {};
        };
      };
    };
    
    let aggregateDrift = if (totalWeight > 0.0) { weightedSum / totalWeight } else { 0.0 };
    
    // Determine status
    let status = if (hasVeritasViolation or hasAegisViolation) { #Halted }
                 else if (violationCount >= 5 or aggregateDrift >= GLOBAL_DRIFT_CATASTROPHIC) { #Catastrophic }
                 else if (violationCount >= 3 or aggregateDrift >= GLOBAL_DRIFT_CRITICAL) { #Critical }
                 else if (violationCount >= 1 or aggregateDrift >= GLOBAL_DRIFT_VIOLATION) { #Violation }
                 else if (aggregateDrift >= GLOBAL_DRIFT_WARNING) { #Warning }
                 else { #Nominal };
    
    // Determine re-entrainment needs
    let fullReentrainment = aggregateDrift >= FULL_REENTRAINMENT_THRESHOLD or violationCount >= 3;
    let partialReentrainment = not fullReentrainment and aggregateDrift >= PARTIAL_REENTRAINMENT_THRESHOLD;
    
    // Compute health score
    let healthScore = Float.max(0.0, 1.0 - aggregateDrift * 2.0);
    
    {
      systemScores = scores;
      aggregateDrift = aggregateDrift;
      maxSystemDrift = maxDrift;
      maxDriftSystem = maxDriftSystem;
      minCompliance = minCompliance;
      minComplianceSystem = minComplianceSystem;
      violationCount = violationCount;
      violatingSystems = Buffer.toArray(violatingSystems);
      status = status;
      fullReentrainmentNeeded = fullReentrainment;
      partialReentrainmentNeeded = partialReentrainment;
      heartbeat = heartbeat;
      timestamp = Time.now();
      healthScore = healthScore;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RE-ENTRAINMENT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Trigger re-entrainment based on drift index
  public func triggerReentrainment(
    driftIndex : OrganismDriftIndex,
    currentState : ReentrainmentState
  ) : ReentrainmentState {
    // Don't trigger if already active
    if (currentState.isActive) {
      return currentState;
    };
    
    // Determine re-entrainment type
    let reentrainmentType = if (driftIndex.fullReentrainmentNeeded) { #Full }
                            else if (driftIndex.partialReentrainmentNeeded) { #Partial }
                            else { #None };
    
    switch (reentrainmentType) {
      case (#None) { currentState };
      case (#Full) {
        {
          reentrainmentType = #Full;
          isActive = true;
          targetSystems = getAllSystemIds();
          strength = 0.3 + driftIndex.aggregateDrift;
          duration = 20;  // 20 heartbeats
          remainingBeats = 20;
          progress = 0.0;
          triggerDrift = driftIndex.aggregateDrift;
          startHeartbeat = driftIndex.heartbeat;
          totalReentrainments = currentState.totalReentrainments + 1;
          successfulReentrainments = currentState.successfulReentrainments;
        }
      };
      case (#Partial) {
        {
          reentrainmentType = #Partial;
          isActive = true;
          targetSystems = driftIndex.violatingSystems;
          strength = 0.2 + driftIndex.aggregateDrift;
          duration = 10;  // 10 heartbeats
          remainingBeats = 10;
          progress = 0.0;
          triggerDrift = driftIndex.aggregateDrift;
          startHeartbeat = driftIndex.heartbeat;
          totalReentrainments = currentState.totalReentrainments + 1;
          successfulReentrainments = currentState.successfulReentrainments;
        }
      };
      case (#Emergency) {
        {
          reentrainmentType = #Emergency;
          isActive = true;
          targetSystems = getAllSystemIds();
          strength = 0.5;
          duration = 30;  // 30 heartbeats
          remainingBeats = 30;
          progress = 0.0;
          triggerDrift = driftIndex.aggregateDrift;
          startHeartbeat = driftIndex.heartbeat;
          totalReentrainments = currentState.totalReentrainments + 1;
          successfulReentrainments = currentState.successfulReentrainments;
        }
      };
    }
  };
  
  /// Update re-entrainment state for one heartbeat
  public func updateReentrainmentState(
    state : ReentrainmentState,
    currentDrift : Float
  ) : ReentrainmentState {
    if (not state.isActive) {
      return state;
    };
    
    let newRemaining = if (state.remainingBeats > 0) { state.remainingBeats - 1 } else { 0 };
    let newProgress = 1.0 - Float.fromInt(newRemaining) / Float.fromInt(state.duration);
    
    // Check if complete
    let isComplete = newRemaining == 0;
    let wasSuccessful = isComplete and currentDrift < state.triggerDrift * 0.5;
    
    {
      reentrainmentType = if (isComplete) { #None } else { state.reentrainmentType };
      isActive = not isComplete;
      targetSystems = if (isComplete) { [] } else { state.targetSystems };
      strength = if (isComplete) { 0.0 } else { state.strength * (1.0 - newProgress * 0.5) };
      duration = state.duration;
      remainingBeats = newRemaining;
      progress = newProgress;
      triggerDrift = state.triggerDrift;
      startHeartbeat = state.startHeartbeat;
      totalReentrainments = state.totalReentrainments;
      successfulReentrainments = if (wasSuccessful) { 
        state.successfulReentrainments + 1 
      } else { state.successfulReentrainments };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TELEMETRY MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get status code from status
  func statusToCode(status : DriftStatus) : Nat8 {
    switch (status) {
      case (#Nominal) { 0 };
      case (#Warning) { 1 };
      case (#Violation) { 2 };
      case (#Critical) { 3 };
      case (#Catastrophic) { 4 };
      case (#Halted) { 5 };
    }
  };
  
  /// Create telemetry snapshot
  public func createTelemetrySnapshot(
    driftIndex : OrganismDriftIndex,
    reentrainmentActive : Bool
  ) : TelemetrySnapshot {
    let systemDrifts = Array.tabulate<Float>(NUM_SYSTEMS, func(i : Nat) : Float {
      if (i < Array.size(driftIndex.systemScores)) {
        driftIndex.systemScores[i].drift
      } else { 0.0 }
    });
    
    let systemCompliances = Array.tabulate<Float>(NUM_SYSTEMS, func(i : Nat) : Float {
      if (i < Array.size(driftIndex.systemScores)) {
        driftIndex.systemScores[i].compliance
      } else { 1.0 }
    });
    
    {
      heartbeat = driftIndex.heartbeat;
      timestamp = driftIndex.timestamp;
      aggregateDrift = driftIndex.aggregateDrift;
      healthScore = driftIndex.healthScore;
      statusCode = statusToCode(driftIndex.status);
      violationCount = driftIndex.violationCount;
      reentrainmentActive = reentrainmentActive;
      systemDrifts = systemDrifts;
      systemCompliances = systemCompliances;
    }
  };
  
  /// Update telemetry with new snapshot
  public func updateTelemetry(
    telemetry : DriftTelemetry,
    snapshot : TelemetrySnapshot
  ) : DriftTelemetry {
    // Add snapshot to history (circular buffer)
    let newHistory = if (Array.size(telemetry.history) < telemetry.maxSize) {
      // Not full yet, append
      let buf = Buffer.fromArray<TelemetrySnapshot>(telemetry.history);
      buf.add(snapshot);
      Buffer.toArray(buf)
    } else {
      // Full, overwrite oldest
      let arr = Array.thaw<TelemetrySnapshot>(telemetry.history);
      arr[telemetry.currentIndex] := snapshot;
      Array.freeze(arr)
    };
    
    let newIndex = (telemetry.currentIndex + 1) % telemetry.maxSize;
    
    // Update statistics
    let newTotal = telemetry.totalSnapshots + 1;
    
    // Running average
    let n = Float.fromInt(telemetry.totalSnapshots);
    let newAvg = (telemetry.averageDrift * n + snapshot.aggregateDrift) / (n + 1.0);
    
    // Peak tracking
    let (newPeak, newPeakBeat) = if (snapshot.aggregateDrift > telemetry.peakDrift) {
      (snapshot.aggregateDrift, snapshot.heartbeat)
    } else {
      (telemetry.peakDrift, telemetry.peakDriftHeartbeat)
    };
    
    // Violation tracking
    let newViolations = telemetry.totalViolations + snapshot.violationCount;
    let newReentrainments = if (snapshot.reentrainmentActive and 
                                (telemetry.totalSnapshots == 0 or 
                                 not telemetry.history[if (telemetry.currentIndex > 0) { telemetry.currentIndex - 1 } else { 0 }].reentrainmentActive)) {
      telemetry.totalReentrainments + 1
    } else { telemetry.totalReentrainments };
    
    {
      history = newHistory;
      maxSize = telemetry.maxSize;
      currentIndex = newIndex;
      totalSnapshots = newTotal;
      averageDrift = newAvg;
      peakDrift = newPeak;
      peakDriftHeartbeat = newPeakBeat;
      totalViolations = newViolations;
      totalReentrainments = newReentrainments;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process all compliance scores for one heartbeat
  public func processHeartbeat(
    state : BrainAggregationState,
    scores : [ComplianceScore]
  ) : BrainAggregationState {
    let heartbeat = state.currentHeartbeat + 1;
    
    // Check for halt conditions
    if (state.isHalted) {
      // Organism is halted, don't process further
      return {
        driftIndex = state.driftIndex;
        reentrainment = state.reentrainment;
        telemetry = state.telemetry;
        isGenesisLocked = state.isGenesisLocked;
        genesisLockHeartbeat = state.genesisLockHeartbeat;
        genesisAggregateDrift = state.genesisAggregateDrift;
        currentHeartbeat = heartbeat;
        lastUpdate = Time.now();
        ownerPrincipal = state.ownerPrincipal;
        isInitialized = state.isInitialized;
        organismId = state.organismId;
        totalHeartbeats = state.totalHeartbeats + 1;
        isHalted = state.isHalted;
        haltReason = state.haltReason;
      };
    };
    
    // Compute new drift index
    let driftIndex = computeDriftIndex(scores, heartbeat);
    
    // Check for halt
    let (shouldHalt, haltReason) = switch (driftIndex.status) {
      case (#Halted) { (true, ?"VERITAS or AEGIS integrity breach") };
      case _ { (false, null) };
    };
    
    // Update re-entrainment
    var reentrainment = updateReentrainmentState(state.reentrainment, driftIndex.aggregateDrift);
    
    // Trigger new re-entrainment if needed
    if (not reentrainment.isActive and (driftIndex.fullReentrainmentNeeded or driftIndex.partialReentrainmentNeeded)) {
      reentrainment := triggerReentrainment(driftIndex, reentrainment);
    };
    
    // Create and add telemetry snapshot
    let snapshot = createTelemetrySnapshot(driftIndex, reentrainment.isActive);
    let telemetry = updateTelemetry(state.telemetry, snapshot);
    
    {
      driftIndex = driftIndex;
      reentrainment = reentrainment;
      telemetry = telemetry;
      isGenesisLocked = state.isGenesisLocked;
      genesisLockHeartbeat = state.genesisLockHeartbeat;
      genesisAggregateDrift = state.genesisAggregateDrift;
      currentHeartbeat = heartbeat;
      lastUpdate = Time.now();
      ownerPrincipal = state.ownerPrincipal;
      isInitialized = state.isInitialized;
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats + 1;
      isHalted = shouldHalt;
      haltReason = haltReason;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock genesis state
  public func lockGenesis(state : BrainAggregationState) : BrainAggregationState {
    {
      driftIndex = state.driftIndex;
      reentrainment = state.reentrainment;
      telemetry = state.telemetry;
      isGenesisLocked = true;
      genesisLockHeartbeat = state.currentHeartbeat;
      genesisAggregateDrift = state.driftIndex.aggregateDrift;  // Should be ~0
      currentHeartbeat = state.currentHeartbeat;
      lastUpdate = Time.now();
      ownerPrincipal = state.ownerPrincipal;
      isInitialized = state.isInitialized;
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats;
      isHalted = state.isHalted;
      haltReason = state.haltReason;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS — Safe numeric outputs (owner-gated)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get aggregate drift (numeric only)
  public func getAggregateDrift(state : BrainAggregationState) : Float {
    state.driftIndex.aggregateDrift
  };
  
  /// Get health score (numeric only)
  public func getHealthScore(state : BrainAggregationState) : Float {
    state.driftIndex.healthScore
  };
  
  /// Get violation count
  public func getViolationCount(state : BrainAggregationState) : Nat {
    state.driftIndex.violationCount
  };
  
  /// Get drift status
  public func getDriftStatus(state : BrainAggregationState) : DriftStatus {
    state.driftIndex.status
  };
  
  /// Is re-entrainment active?
  public func isReentrainmentActive(state : BrainAggregationState) : Bool {
    state.reentrainment.isActive
  };
  
  /// Get re-entrainment progress
  public func getReentrainmentProgress(state : BrainAggregationState) : Float {
    state.reentrainment.progress
  };
  
  /// Is organism halted?
  public func isOrganismHalted(state : BrainAggregationState) : Bool {
    state.isHalted
  };
  
  /// Get average drift (from telemetry)
  public func getAverageDrift(state : BrainAggregationState) : Float {
    state.telemetry.averageDrift
  };
  
  /// Get peak drift (from telemetry)
  public func getPeakDrift(state : BrainAggregationState) : Float {
    state.telemetry.peakDrift
  };
  
  /// Get total re-entrainments
  public func getTotalReentrainments(state : BrainAggregationState) : Nat {
    state.reentrainment.totalReentrainments
  };
  
  /// Get successful re-entrainments
  public func getSuccessfulReentrainments(state : BrainAggregationState) : Nat {
    state.reentrainment.successfulReentrainments
  };
  
  /// Is genesis locked?
  public func isGenesisLocked(state : BrainAggregationState) : Bool {
    state.isGenesisLocked
  };
  
  /// Get system compliance by ID
  public func getSystemCompliance(state : BrainAggregationState, systemId : SystemId) : Float {
    for (i in Iter.range(0, Array.size(state.driftIndex.systemScores) - 1)) {
      let score = state.driftIndex.systemScores[i];
      if (score.systemId == systemId) {
        return score.compliance;
      };
    };
    1.0  // Default if not found
  };
  
  /// Get system drift by ID
  public func getSystemDrift(state : BrainAggregationState, systemId : SystemId) : Float {
    for (i in Iter.range(0, Array.size(state.driftIndex.systemScores) - 1)) {
      let score = state.driftIndex.systemScores[i];
      if (score.systemId == systemId) {
        return score.drift;
      };
    };
    0.0  // Default if not found
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OWNER-GATED TELEMETRY ACCESS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get recent telemetry (owner-gated)
  public func getRecentTelemetry(state : BrainAggregationState, count : Nat) : [TelemetrySnapshot] {
    let actualCount = if (count > Array.size(state.telemetry.history)) {
      Array.size(state.telemetry.history)
    } else { count };
    
    if (actualCount == 0) { return []; };
    
    // Get most recent snapshots
    let startIdx = if (state.telemetry.currentIndex >= actualCount) {
      state.telemetry.currentIndex - actualCount
    } else {
      // Wrap around
      state.telemetry.maxSize - (actualCount - state.telemetry.currentIndex)
    };
    
    Array.tabulate<TelemetrySnapshot>(actualCount, func(i : Nat) : TelemetrySnapshot {
      let idx = (startIdx + i) % Array.size(state.telemetry.history);
      state.telemetry.history[idx]
    })
  };
  
  /// Get telemetry summary
  public type TelemetrySummary = {
    totalSnapshots : Nat;
    averageDrift : Float;
    peakDrift : Float;
    peakDriftHeartbeat : Nat;
    totalViolations : Nat;
    totalReentrainments : Nat;
    currentStatus : DriftStatus;
    currentHealthScore : Float;
    isHalted : Bool;
  };
  
  /// Get telemetry summary
  public func getTelemetrySummary(state : BrainAggregationState) : TelemetrySummary {
    {
      totalSnapshots = state.telemetry.totalSnapshots;
      averageDrift = state.telemetry.averageDrift;
      peakDrift = state.telemetry.peakDrift;
      peakDriftHeartbeat = state.telemetry.peakDriftHeartbeat;
      totalViolations = state.telemetry.totalViolations;
      totalReentrainments = state.telemetry.totalReentrainments;
      currentStatus = state.driftIndex.status;
      currentHealthScore = state.driftIndex.healthScore;
      isHalted = state.isHalted;
    }
  };

}
