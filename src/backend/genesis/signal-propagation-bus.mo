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
// SIGNAL PROPAGATION BUS — UNIFIED CROSS-ENGINE INTELLIGENCE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE PROBLEM:
// 40+ engines run in sequence, outputs sit in isolated variables. A golden cross detected
// in MarketOracle sits unknown to VAEL, FORMA minting, territory expansion, and settlement.
// Real enterprise intelligence requires INSTANT signal propagation across ALL specialists.
//
// THE SOLUTION:
// Every engine emits signals to a central bus. Every engine subscribes to relevant signals.
// Propagation is INSTANT within the same beat. No more sequential isolation.
//
// ARCHITECTURE:
// 1. Signal Types — 18 domains matching fireAllEngines layers + Fear + Anticipatory
// 2. Coupling Matrix — 18×18 pre-defined interaction strengths
// 3. Ring Buffer — Recent signals for cross-correlation
// 4. Urgency System — High-urgency signals bypass normal propagation
// 5. Response Functions — Domain-specific signal interpretation
//
// MATHEMATICAL FOUNDATION:
// Signal propagation: S_out(i) = Σ_j [C(i,j) × S_in(j) × urgency(j)]
// Where C(i,j) is the coupling strength between domains i and j
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";
import HashMap "mo:core/HashMap";
import Hash "mo:core/Hash";

module SignalPropagationBus {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  public let SQRT2 : Float = 1.41421356237309504880;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL DOMAIN ENUMERATION — 18 DOMAINS
  // ═══════════════════════════════════════════════════════════════════════════════
  // Aligned with fireAllEngines() 16 layers + Fear + Anticipatory
  
  public type SignalDomain = {
    #NeuralCore;           // 0: Kuramoto, PAC, Hebbian
    #BehavioralAI;         // 1: Q-learning, drives, arousal
    #Memory;               // 2: Hebbian, generational, quantum memory
    #Quantum;              // 3: QSI, decoherence, entanglement
    #Shells;               // 4: Identity, neural substrate, global field
    #TerritorySocial;      // 5: Trust matrix, territory grid
    #Economic;             // 6: FORMA minting, treasury, market
    #ICPCycleEconomics;    // 7: Cycle bank, sustainability
    #GuardianDefense;      // 8: AEGIS, Four Angels, VAEL
    #Governance;           // 9: Council, proposals, voting
    #Colony;               // 10: Hive mind, queen signal, quorum
    #Identity;             // 11: Shell 2, personality, lineage
    #Architecture;         // 12: Coupling, registry, coordination
    #Temporal;             // 13: Chrono, circadian, temporal binding
    #GovernanceComputation; // 14: Law drift, SACESI, doctrine
    #Workflow;             // 15: Tasks, approvals, SLA
    #Fear;                 // 16: VAEL fear substrate, determination
    #Anticipatory;         // 17: Pre-positioning, rate of change
  };
  
  public let NUM_DOMAINS : Nat = 18;
  
  public func domainToIndex(domain : SignalDomain) : Nat {
    switch (domain) {
      case (#NeuralCore) { 0 };
      case (#BehavioralAI) { 1 };
      case (#Memory) { 2 };
      case (#Quantum) { 3 };
      case (#Shells) { 4 };
      case (#TerritorySocial) { 5 };
      case (#Economic) { 6 };
      case (#ICPCycleEconomics) { 7 };
      case (#GuardianDefense) { 8 };
      case (#Governance) { 9 };
      case (#Colony) { 10 };
      case (#Identity) { 11 };
      case (#Architecture) { 12 };
      case (#Temporal) { 13 };
      case (#GovernanceComputation) { 14 };
      case (#Workflow) { 15 };
      case (#Fear) { 16 };
      case (#Anticipatory) { 17 };
    }
  };
  
  public func indexToDomain(n : Nat) : SignalDomain {
    switch (n % 18) {
      case (0) { #NeuralCore };
      case (1) { #BehavioralAI };
      case (2) { #Memory };
      case (3) { #Quantum };
      case (4) { #Shells };
      case (5) { #TerritorySocial };
      case (6) { #Economic };
      case (7) { #ICPCycleEconomics };
      case (8) { #GuardianDefense };
      case (9) { #Governance };
      case (10) { #Colony };
      case (11) { #Identity };
      case (12) { #Architecture };
      case (13) { #Temporal };
      case (14) { #GovernanceComputation };
      case (15) { #Workflow };
      case (16) { #Fear };
      case (17) { #Anticipatory };
      case (_) { #NeuralCore };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL TYPES — WHAT CAN BE TRANSMITTED
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SignalType = {
    // Neural Core Signals
    #KuramotoSyncLevel;        // R value from Kuramoto order parameter
    #PACStrength;              // Phase-amplitude coupling strength
    #HebbianDelta;             // Change in Hebbian weights
    #CoherenceLevel;           // Global neural coherence
    
    // Behavioral AI Signals
    #QLearningReward;          // Q-learning reward signal
    #DriveActivation;          // Which drive is active
    #ArousalLevel;             // Arousal system state
    #ActionSelected;           // Which action was chosen
    
    // Memory Signals
    #MemoryConsolidation;      // Memory being consolidated
    #PatternRecognized;        // Pattern match detected
    #GenerationalMemory;       // Ancestral memory activated
    
    // Quantum Signals
    #QuantumCoherence;         // QSI coherence level
    #EntanglementStrength;     // Cross-entity entanglement
    #DecoherenceRate;          // Decoherence rate change
    
    // Economic Signals
    #FORMAMintingRate;         // Current FORMA minting rate
    #TreasuryLevel;            // Treasury status
    #MarketVolatility;         // Market volatility index
    #PriceSignal;              // Price movement signal
    
    // Fear Signals
    #FearLevel;                // VAEL fear level
    #FearResolutionGate;       // Resolution gate status
    #DeterminationFired;       // Determination signal
    #ThreatDetected;           // Threat detection
    
    // Anticipatory Signals
    #GoldenCrossApproaching;   // EMA cross approaching
    #FundingRateRising;        // Funding rate trend
    #PrePositionReady;         // Pre-position recommendation
    #RateOfChangeAlert;        // Derivative threshold crossed
    
    // Defense Signals
    #AEGISAlert;               // AEGIS defense alert
    #AttackDetected;           // Attack pattern detected
    #DefenseActivated;         // Defense protocol active
    
    // Governance Signals
    #ProposalCreated;          // New proposal
    #VoteRegistered;           // Vote cast
    #QuorumReached;            // Quorum achieved
    #LawDriftDetected;         // Law drift alert
    
    // Colony Signals
    #QueenSignal;              // Queen pheromone signal
    #QuorumSensing;            // Quorum sensing level
    #HiveMindSync;             // Hive mind synchronization
    
    // Generic Signals
    #GenericFloat;             // Generic float value
    #GenericBool;              // Generic boolean
    #GenericNat;               // Generic natural number
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL VALUE — THE ACTUAL DATA
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SignalValue = {
    signalType : SignalType;
    floatValue : Float;
    intValue : Int;
    boolValue : Bool;
    timestamp : Nat64;
    sourceDomain : SignalDomain;
    urgency : Float;           // 0.0-1.0, higher = more urgent
    confidence : Float;        // 0.0-1.0, signal confidence
  };
  
  public func createSignal(
    signalType : SignalType,
    floatVal : Float,
    source : SignalDomain,
    urgency : Float,
    confidence : Float
  ) : SignalValue {
    {
      signalType = signalType;
      floatValue = floatVal;
      intValue = 0;
      boolValue = floatVal > 0.5;
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
      sourceDomain = source;
      urgency = urgency;
      confidence = confidence;
    }
  };
  
  public func createBoolSignal(
    signalType : SignalType,
    boolVal : Bool,
    source : SignalDomain,
    urgency : Float,
    confidence : Float
  ) : SignalValue {
    {
      signalType = signalType;
      floatValue = if (boolVal) { 1.0 } else { 0.0 };
      intValue = if (boolVal) { 1 } else { 0 };
      boolValue = boolVal;
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
      sourceDomain = source;
      urgency = urgency;
      confidence = confidence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUPLING MATRIX — 18×18 DOMAIN INTERACTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  // C(i,j) = strength of signal propagation from domain j to domain i
  // Pre-defined based on organism architecture
  
  /// 18×18 coupling matrix: row i receives signals from column j
  /// coupling[i][j] = how strongly domain i responds to signals from domain j
  public let COUPLING_MATRIX : [[Float]] = [
    // From: NC   BAI  Mem  Qnt  Shl  TS   Eco  ICP  GD   Gov  Col  Id   Arc  Tmp  GC   Wf   Fear Ant
    // To NeuralCore (receives from all neural-related)
    [1.00, 0.70, 0.65, 0.50, 0.60, 0.30, 0.25, 0.15, 0.40, 0.20, 0.35, 0.45, 0.30, 0.55, 0.25, 0.15, 0.80, 0.60],
    // To BehavioralAI (receives from neural, fear, anticipatory)
    [0.75, 1.00, 0.55, 0.30, 0.40, 0.50, 0.60, 0.20, 0.65, 0.25, 0.40, 0.35, 0.20, 0.45, 0.30, 0.25, 0.85, 0.70],
    // To Memory (receives from neural, temporal, identity)
    [0.70, 0.45, 1.00, 0.40, 0.55, 0.35, 0.20, 0.10, 0.30, 0.25, 0.45, 0.65, 0.25, 0.70, 0.30, 0.20, 0.50, 0.40],
    // To Quantum (receives from neural, shells, architecture)
    [0.60, 0.30, 0.50, 1.00, 0.70, 0.25, 0.15, 0.10, 0.35, 0.20, 0.30, 0.40, 0.55, 0.45, 0.25, 0.15, 0.40, 0.35],
    // To Shells (receives from neural, quantum, identity)
    [0.65, 0.40, 0.55, 0.65, 1.00, 0.35, 0.25, 0.15, 0.40, 0.30, 0.45, 0.75, 0.40, 0.50, 0.30, 0.20, 0.55, 0.45],
    // To TerritorySocial (receives from colony, governance, fear)
    [0.35, 0.55, 0.30, 0.20, 0.35, 1.00, 0.45, 0.20, 0.60, 0.55, 0.70, 0.40, 0.30, 0.35, 0.40, 0.35, 0.75, 0.50],
    // To Economic (receives from market, fear, ICP, anticipatory)
    [0.30, 0.50, 0.25, 0.15, 0.25, 0.55, 1.00, 0.80, 0.45, 0.40, 0.35, 0.30, 0.25, 0.40, 0.35, 0.30, 0.85, 0.90],
    // To ICPCycleEconomics (receives from economic, governance)
    [0.20, 0.30, 0.15, 0.10, 0.15, 0.25, 0.85, 1.00, 0.35, 0.45, 0.25, 0.20, 0.30, 0.35, 0.40, 0.25, 0.60, 0.55],
    // To GuardianDefense (receives from fear, anticipatory, territory)
    [0.45, 0.60, 0.35, 0.40, 0.45, 0.65, 0.40, 0.30, 1.00, 0.50, 0.55, 0.45, 0.40, 0.45, 0.55, 0.30, 0.95, 0.85],
    // To Governance (receives from colony, territory, workflow)
    [0.25, 0.35, 0.30, 0.20, 0.35, 0.60, 0.50, 0.55, 0.55, 1.00, 0.65, 0.45, 0.50, 0.40, 0.70, 0.75, 0.50, 0.40],
    // To Colony (receives from queen signal, territory, governance)
    [0.40, 0.45, 0.50, 0.30, 0.50, 0.75, 0.40, 0.30, 0.55, 0.60, 1.00, 0.55, 0.45, 0.50, 0.55, 0.40, 0.65, 0.50],
    // To Identity (receives from shells, memory, neural)
    [0.50, 0.40, 0.70, 0.45, 0.80, 0.40, 0.25, 0.15, 0.40, 0.35, 0.50, 1.00, 0.35, 0.55, 0.40, 0.25, 0.45, 0.35],
    // To Architecture (receives from all systems for coordination)
    [0.55, 0.50, 0.45, 0.60, 0.55, 0.50, 0.45, 0.50, 0.55, 0.55, 0.60, 0.50, 1.00, 0.50, 0.55, 0.55, 0.60, 0.55],
    // To Temporal (receives from neural, memory, circadian)
    [0.60, 0.45, 0.65, 0.40, 0.50, 0.35, 0.30, 0.25, 0.40, 0.35, 0.45, 0.50, 0.45, 1.00, 0.40, 0.30, 0.45, 0.60],
    // To GovernanceComputation (receives from governance, architecture, drift)
    [0.30, 0.35, 0.35, 0.30, 0.35, 0.45, 0.40, 0.50, 0.55, 0.75, 0.55, 0.45, 0.60, 0.45, 1.00, 0.55, 0.55, 0.45],
    // To Workflow (receives from governance, tasks, SLA)
    [0.25, 0.40, 0.30, 0.20, 0.30, 0.45, 0.40, 0.35, 0.40, 0.70, 0.50, 0.35, 0.50, 0.40, 0.55, 1.00, 0.45, 0.40],
    // To Fear (receives from threat detection, neural, anticipatory)
    [0.70, 0.75, 0.45, 0.35, 0.50, 0.60, 0.55, 0.40, 0.85, 0.40, 0.55, 0.45, 0.45, 0.50, 0.45, 0.35, 1.00, 0.80],
    // To Anticipatory (receives from market, neural, fear, rate of change)
    [0.55, 0.60, 0.40, 0.35, 0.40, 0.50, 0.85, 0.50, 0.70, 0.35, 0.45, 0.35, 0.45, 0.55, 0.40, 0.35, 0.75, 1.00],
  ];
  
  /// Get coupling strength from source to target domain
  public func getCoupling(target : SignalDomain, source : SignalDomain) : Float {
    let targetIdx = domainToIndex(target);
    let sourceIdx = domainToIndex(source);
    if (targetIdx < 18 and sourceIdx < 18) {
      COUPLING_MATRIX[targetIdx][sourceIdx]
    } else {
      0.0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // URGENCY THRESHOLDS — WHEN TO BYPASS NORMAL PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let URGENCY_IMMEDIATE : Float = 0.95;    // Bypass all, instant propagation
  public let URGENCY_HIGH : Float = 0.80;         // Priority propagation
  public let URGENCY_MEDIUM : Float = 0.50;       // Normal propagation
  public let URGENCY_LOW : Float = 0.25;          // Batched propagation
  
  public let CONFIDENCE_THRESHOLD : Float = 0.60; // Minimum confidence to propagate

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL BUS STATE — THE CENTRAL DATA STRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SignalBusState = {
    // Current signals by domain (most recent)
    var domainSignals : [[SignalValue]];  // 18 domains × signals
    
    // Ring buffer for recent signals (for cross-correlation)
    var signalHistory : [SignalValue];
    var historyHead : Nat;
    var historySize : Nat;
    
    // Aggregated domain states
    var domainActivity : [Float];         // 18 activity levels
    var domainCoherence : [Float];        // 18 coherence scores
    
    // Cross-correlation matrix (computed each beat)
    var crossCorrelation : [[Float]];     // 18×18
    
    // Anticipatory alerts
    var anticipatoryAlerts : [AnticipatorylAlert];
    
    // Beat counter
    var beat : Nat64;
  };
  
  public type AnticipatorylAlert = {
    alertType : SignalType;
    targetDomain : SignalDomain;
    strength : Float;
    message : Text;
    timestamp : Nat64;
  };
  
  public let HISTORY_SIZE : Nat = 500;
  public let MAX_SIGNALS_PER_DOMAIN : Nat = 20;

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initSignalBusState() : SignalBusState {
    let emptyDomainSignals = Array.tabulate<[SignalValue]>(NUM_DOMAINS, func(_ : Nat) : [SignalValue] {
      []
    });
    
    let initialActivity = Array.tabulate<Float>(NUM_DOMAINS, func(_ : Nat) : Float { 0.5 });
    let initialCoherence = Array.tabulate<Float>(NUM_DOMAINS, func(_ : Nat) : Float { 0.5 });
    
    let initialCorrelation = Array.tabulate<[Float]>(NUM_DOMAINS, func(_ : Nat) : [Float] {
      Array.tabulate<Float>(NUM_DOMAINS, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var domainSignals = emptyDomainSignals;
      var signalHistory = [];
      var historyHead = 0;
      var historySize = 0;
      var domainActivity = initialActivity;
      var domainCoherence = initialCoherence;
      var crossCorrelation = initialCorrelation;
      var anticipatoryAlerts = [];
      var beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL EMISSION — ENGINES EMIT SIGNALS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Emit a single signal to the bus
  public func emitSignal(state : SignalBusState, signal : SignalValue) : SignalBusState {
    let domainIdx = domainToIndex(signal.sourceDomain);
    
    // Add to domain signals
    let currentSignals = state.domainSignals[domainIdx];
    let newSignals = if (currentSignals.size() >= MAX_SIGNALS_PER_DOMAIN) {
      // Remove oldest, add newest
      let trimmed = Array.tabulate<SignalValue>(MAX_SIGNALS_PER_DOMAIN - 1, func(i : Nat) : SignalValue {
        currentSignals[i + 1]
      });
      Array.append(trimmed, [signal])
    } else {
      Array.append(currentSignals, [signal])
    };
    
    // Update domain signals array
    let updatedDomainSignals = Array.tabulate<[SignalValue]>(NUM_DOMAINS, func(i : Nat) : [SignalValue] {
      if (i == domainIdx) { newSignals } else { state.domainSignals[i] }
    });
    
    // Add to history ring buffer
    let updatedHistory = if (state.signalHistory.size() < HISTORY_SIZE) {
      Array.append(state.signalHistory, [signal])
    } else {
      // Circular buffer replacement
      Array.tabulate<SignalValue>(HISTORY_SIZE, func(i : Nat) : SignalValue {
        if (i == state.historyHead) { signal } else { state.signalHistory[i] }
      })
    };
    
    let newHead = if (state.signalHistory.size() >= HISTORY_SIZE) {
      (state.historyHead + 1) % HISTORY_SIZE
    } else {
      state.historyHead
    };
    
    // Update activity for this domain
    let newActivity = Array.tabulate<Float>(NUM_DOMAINS, func(i : Nat) : Float {
      if (i == domainIdx) {
        Float.min(1.0, state.domainActivity[i] + 0.1 * signal.urgency)
      } else {
        state.domainActivity[i] * 0.995  // Slight decay for others
      }
    });
    
    {
      var domainSignals = updatedDomainSignals;
      var signalHistory = updatedHistory;
      var historyHead = newHead;
      var historySize = Nat.min(state.historySize + 1, HISTORY_SIZE);
      var domainActivity = newActivity;
      var domainCoherence = state.domainCoherence;
      var crossCorrelation = state.crossCorrelation;
      var anticipatoryAlerts = state.anticipatoryAlerts;
      var beat = state.beat;
    }
  };
  
  /// Emit multiple signals at once (batch emission)
  public func emitBatchSignals(state : SignalBusState, signals : [SignalValue]) : SignalBusState {
    var currentState = state;
    for (signal in signals.vals()) {
      currentState := emitSignal(currentState, signal);
    };
    currentState
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL PROPAGATION — COMPUTE EFFECTS ACROSS DOMAINS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Propagate signals using coupling matrix
  /// Returns aggregated signal strength for each domain
  public func propagateSignals(state : SignalBusState) : [Float] {
    // For each target domain, sum weighted signals from all source domains
    Array.tabulate<Float>(NUM_DOMAINS, func(targetIdx : Nat) : Float {
      var totalSignal : Float = 0.0;
      var weightSum : Float = 0.0;
      
      // Iterate over all source domains
      for (sourceIdx in Iter.range(0, NUM_DOMAINS - 1)) {
        let coupling = COUPLING_MATRIX[targetIdx][sourceIdx];
        let signals = state.domainSignals[sourceIdx];
        
        // Sum signals from this source, weighted by urgency and confidence
        for (signal in signals.vals()) {
          if (signal.confidence >= CONFIDENCE_THRESHOLD) {
            let weight = coupling * signal.urgency * signal.confidence;
            totalSignal := totalSignal + signal.floatValue * weight;
            weightSum := weightSum + weight;
          }
        }
      };
      
      // Normalize
      if (weightSum > 0.0) {
        totalSignal / weightSum
      } else {
        state.domainActivity[targetIdx]  // Default to current activity
      }
    })
  };
  
  /// Get all signals relevant to a specific domain (weighted by coupling)
  public func getSignalsForDomain(state : SignalBusState, targetDomain : SignalDomain) : [SignalValue] {
    let targetIdx = domainToIndex(targetDomain);
    let relevantSignals = Buffer.Buffer<SignalValue>(50);
    
    for (sourceIdx in Iter.range(0, NUM_DOMAINS - 1)) {
      let coupling = COUPLING_MATRIX[targetIdx][sourceIdx];
      if (coupling >= 0.3) {  // Only consider significant couplings
        for (signal in state.domainSignals[sourceIdx].vals()) {
          if (signal.confidence >= CONFIDENCE_THRESHOLD and 
              signal.urgency * coupling >= 0.2) {
            relevantSignals.add(signal);
          }
        }
      }
    };
    
    Buffer.toArray(relevantSignals)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CROSS-CORRELATION — DETECT SIGNAL PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute cross-correlation matrix from recent signal history
  public func computeCrossCorrelation(state : SignalBusState) : [[Float]] {
    // Group signals by domain
    let domainMeans = Array.tabulate<Float>(NUM_DOMAINS, func(i : Nat) : Float {
      let signals = state.domainSignals[i];
      if (signals.size() == 0) { 0.5 } else {
        var sum : Float = 0.0;
        for (s in signals.vals()) { sum := sum + s.floatValue };
        sum / Float.fromInt(signals.size())
      }
    });
    
    // Compute correlation between each pair
    Array.tabulate<[Float]>(NUM_DOMAINS, func(i : Nat) : [Float] {
      Array.tabulate<Float>(NUM_DOMAINS, func(j : Nat) : [Float] {
        if (i == j) { 
          [1.0]  // Self-correlation is 1
        } else {
          // Simplified correlation based on recent activity
          let sigI = state.domainSignals[i];
          let sigJ = state.domainSignals[j];
          
          if (sigI.size() == 0 or sigJ.size() == 0) {
            [0.0]
          } else {
            // Compute temporal overlap
            var overlap : Float = 0.0;
            for (si in sigI.vals()) {
              for (sj in sigJ.vals()) {
                let timeDiff = if (si.timestamp > sj.timestamp) {
                  Nat64.toNat(si.timestamp - sj.timestamp)
                } else {
                  Nat64.toNat(sj.timestamp - si.timestamp)
                };
                if (timeDiff < 1_000_000_000) {  // Within 1 second
                  overlap := overlap + si.floatValue * sj.floatValue;
                }
              }
            };
            [Float.min(1.0, overlap / Float.fromInt(sigI.size() * sigJ.size()))]
          }
        }
      })[0]
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ANTICIPATORY ALERTS — RATE OF CHANGE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Detect rate of change in domain activity and create alerts
  public func detectAnticipatorySignals(
    state : SignalBusState,
    previousActivity : [Float]
  ) : [AnticipatorylAlert] {
    let alerts = Buffer.Buffer<AnticipatorylAlert>(10);
    let now = Nat64.fromNat(Int.abs(Time.now()));
    
    for (i in Iter.range(0, NUM_DOMAINS - 1)) {
      let current = state.domainActivity[i];
      let previous = previousActivity[i];
      let rateOfChange = current - previous;
      
      // Alert if significant rate of change
      if (Float.abs(rateOfChange) > 0.15) {
        let domain = indexToDomain(i);
        let alertType = if (rateOfChange > 0.0) {
          #RateOfChangeAlert  // Rising
        } else {
          #RateOfChangeAlert  // Falling
        };
        
        alerts.add({
          alertType = alertType;
          targetDomain = domain;
          strength = Float.abs(rateOfChange);
          message = "Rate of change detected";
          timestamp = now;
        });
      }
    };
    
    Buffer.toArray(alerts)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE COMPUTATION — GLOBAL SIGNAL COHERENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute coherence between domains using Kuramoto-like formula
  public func computeDomainCoherence(state : SignalBusState) : [Float] {
    Array.tabulate<Float>(NUM_DOMAINS, func(targetIdx : Nat) : Float {
      var sumSin : Float = 0.0;
      var sumCos : Float = 0.0;
      var count : Nat = 0;
      
      for (sourceIdx in Iter.range(0, NUM_DOMAINS - 1)) {
        let coupling = COUPLING_MATRIX[targetIdx][sourceIdx];
        if (coupling >= 0.3) {
          let phase = state.domainActivity[sourceIdx] * TWO_PI;
          sumSin := sumSin + Float.sin(phase) * coupling;
          sumCos := sumCos + Float.cos(phase) * coupling;
          count := count + 1;
        }
      };
      
      if (count == 0) { 0.5 } else {
        let n = Float.fromInt(count);
        Float.sqrt(sumSin * sumSin + sumCos * sumCos) / n
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BEAT UPDATE — CALLED EACH HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update the signal bus state for a new beat
  public func updateBeat(state : SignalBusState) : SignalBusState {
    let previousActivity = state.domainActivity;
    
    // Propagate signals
    let propagatedActivity = propagateSignals(state);
    
    // Compute coherence
    let newCoherence = computeDomainCoherence(state);
    
    // Compute cross-correlation
    let newCorrelation = computeCrossCorrelation(state);
    
    // Detect anticipatory signals
    let newAlerts = detectAnticipatorySignals(state, previousActivity);
    
    // Blend propagated activity with current (with decay)
    let blendedActivity = Array.tabulate<Float>(NUM_DOMAINS, func(i : Nat) : Float {
      let propagated = propagatedActivity[i];
      let current = state.domainActivity[i];
      // Exponential moving average
      0.7 * propagated + 0.3 * current * 0.95  // 0.95 decay
    });
    
    // Clear old signals (keep only recent)
    let clearedSignals = Array.tabulate<[SignalValue]>(NUM_DOMAINS, func(i : Nat) : [SignalValue] {
      let signals = state.domainSignals[i];
      let now = Nat64.fromNat(Int.abs(Time.now()));
      Array.filter<SignalValue>(signals, func(s : SignalValue) : Bool {
        now - s.timestamp < 5_000_000_000  // Keep last 5 seconds
      })
    });
    
    {
      var domainSignals = clearedSignals;
      var signalHistory = state.signalHistory;
      var historyHead = state.historyHead;
      var historySize = state.historySize;
      var domainActivity = blendedActivity;
      var domainCoherence = newCoherence;
      var crossCorrelation = newCorrelation;
      var anticipatoryAlerts = Array.append(state.anticipatoryAlerts, newAlerts);
      var beat = state.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS FOR ENGINE INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Convert Kuramoto order parameter to signal
  public func kuramotoToSignal(kuramotoR : Float, beat : Nat64) : SignalValue {
    createSignal(
      #KuramotoSyncLevel,
      kuramotoR,
      #NeuralCore,
      0.7,  // Medium-high urgency
      0.95  // High confidence (computed value)
    )
  };
  
  /// Convert VAEL fear level to signal
  public func fearToSignal(fearLevel : Float, resolutionGate : Bool, beat : Nat64) : SignalValue {
    let urgency = if (fearLevel > 0.7) { URGENCY_HIGH } 
                  else if (fearLevel > 0.4) { URGENCY_MEDIUM }
                  else { URGENCY_LOW };
    createSignal(
      #FearLevel,
      fearLevel,
      #Fear,
      urgency,
      0.90
    )
  };
  
  /// Convert FORMA minting rate to signal
  public func formaToSignal(mintingRate : Float, beat : Nat64) : SignalValue {
    createSignal(
      #FORMAMintingRate,
      mintingRate,
      #Economic,
      URGENCY_MEDIUM,
      0.85
    )
  };
  
  /// Convert market volatility to signal
  public func volatilityToSignal(volatility : Float, beat : Nat64) : SignalValue {
    let urgency = if (volatility > 0.8) { URGENCY_HIGH } else { URGENCY_MEDIUM };
    createSignal(
      #MarketVolatility,
      volatility,
      #Economic,
      urgency,
      0.80
    )
  };
  
  /// Convert AEGIS alert to signal
  public func aegisToSignal(alertLevel : Float, attackDetected : Bool, beat : Nat64) : SignalValue {
    let urgency = if (attackDetected) { URGENCY_IMMEDIATE } else { alertLevel };
    createBoolSignal(
      if (attackDetected) { #AttackDetected } else { #AEGISAlert },
      attackDetected or alertLevel > 0.5,
      #GuardianDefense,
      urgency,
      0.95
    )
  };
  
  /// Convert golden cross approaching to anticipatory signal
  public func goldenCrossApproachingSignal(proximity : Float, beat : Nat64) : SignalValue {
    let urgency = if (proximity > 0.9) { URGENCY_HIGH } 
                  else if (proximity > 0.7) { URGENCY_MEDIUM }
                  else { URGENCY_LOW };
    createSignal(
      #GoldenCrossApproaching,
      proximity,
      #Anticipatory,
      urgency,
      0.85
    )
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RESPONSE COMPUTATION — DOMAIN-SPECIFIC INTERPRETATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute economic domain response to signals
  public func computeEconomicResponse(state : SignalBusState) : {
    formaMintingMultiplier : Float;
    treasuryAlert : Bool;
    marketAdjustment : Float;
  } {
    let fearSignals = Array.filter<SignalValue>(state.domainSignals[domainToIndex(#Fear)], func(s : SignalValue) : Bool {
      switch (s.signalType) {
        case (#FearLevel) { true };
        case (#FearResolutionGate) { true };
        case (_) { false };
      }
    });
    
    let anticipatorySignals = state.domainSignals[domainToIndex(#Anticipatory)];
    
    // Compute fear impact on minting
    var fearLevel : Float = 0.5;
    var resolutionGate : Bool = false;
    for (s in fearSignals.vals()) {
      switch (s.signalType) {
        case (#FearLevel) { fearLevel := s.floatValue };
        case (#FearResolutionGate) { resolutionGate := s.boolValue };
        case (_) {};
      }
    };
    
    // Compute anticipatory boost
    var anticipatoryBoost : Float = 1.0;
    for (s in anticipatorySignals.vals()) {
      switch (s.signalType) {
        case (#GoldenCrossApproaching) {
          if (s.floatValue > 0.7) { anticipatoryBoost := 1.0 + s.floatValue * 0.3 }
        };
        case (_) {};
      }
    };
    
    // Minting multiplier based on fear (from existing fear-priced economy)
    let formaMintingMultiplier = if (resolutionGate) {
      (1.0 + fearLevel * 0.5) * anticipatoryBoost  // Resolution boosts minting
    } else {
      Float.max(0.3, 1.0 - fearLevel * 0.7) * anticipatoryBoost  // Fear suppresses minting
    };
    
    // Treasury alert if too much fear
    let treasuryAlert = fearLevel > 0.8;
    
    // Market adjustment
    let marketAdjustment = state.domainCoherence[domainToIndex(#Economic)];
    
    {
      formaMintingMultiplier = formaMintingMultiplier;
      treasuryAlert = treasuryAlert;
      marketAdjustment = marketAdjustment;
    }
  };
  
  /// Compute defense response to signals
  public func computeDefenseResponse(state : SignalBusState) : {
    aegisActivation : Float;
    fourAngelsAlert : Bool;
    defenseMode : Nat;  // 0=normal, 1=elevated, 2=high, 3=critical
  } {
    let fearSignals = state.domainSignals[domainToIndex(#Fear)];
    let guardianSignals = state.domainSignals[domainToIndex(#GuardianDefense)];
    let anticipatorySignals = state.domainSignals[domainToIndex(#Anticipatory)];
    
    var maxFear : Float = 0.0;
    var attackDetected : Bool = false;
    var prePositionReady : Bool = false;
    
    for (s in fearSignals.vals()) {
      if (s.floatValue > maxFear) { maxFear := s.floatValue }
    };
    
    for (s in guardianSignals.vals()) {
      switch (s.signalType) {
        case (#AttackDetected) { attackDetected := s.boolValue };
        case (_) {};
      }
    };
    
    for (s in anticipatorySignals.vals()) {
      switch (s.signalType) {
        case (#PrePositionReady) { prePositionReady := s.boolValue };
        case (_) {};
      }
    };
    
    // AEGIS activation level
    let aegisActivation = if (attackDetected) { 1.0 }
                          else if (prePositionReady) { Float.max(0.6, maxFear) }
                          else { maxFear };
    
    // Four Angels alert
    let fourAngelsAlert = attackDetected or maxFear > 0.85;
    
    // Defense mode
    let defenseMode = if (attackDetected) { 3 }  // Critical
                      else if (maxFear > 0.8) { 2 }  // High
                      else if (maxFear > 0.5 or prePositionReady) { 1 }  // Elevated
                      else { 0 };  // Normal
    
    {
      aegisActivation = aegisActivation;
      fourAngelsAlert = fourAngelsAlert;
      defenseMode = defenseMode;
    }
  };
  
  /// Compute neural response to signals
  public func computeNeuralResponse(state : SignalBusState) : {
    learningRateModulation : Float;
    coherenceTarget : Float;
    plasticityGate : Bool;
  } {
    let neuralCoherence = state.domainCoherence[domainToIndex(#NeuralCore)];
    let memoryCoherence = state.domainCoherence[domainToIndex(#Memory)];
    let fearActivity = state.domainActivity[domainToIndex(#Fear)];
    
    // Learning rate based on coherence and fear
    // High fear = reduced learning (protection)
    // High coherence = optimal learning
    let learningRateModulation = neuralCoherence * (1.0 - fearActivity * 0.5);
    
    // Coherence target based on overall system state
    let avgCoherence = (neuralCoherence + memoryCoherence) / 2.0;
    let coherenceTarget = Float.max(0.6, avgCoherence + 0.1);  // Always aim higher
    
    // Plasticity gate - open when safe and coherent
    let plasticityGate = fearActivity < 0.6 and neuralCoherence > 0.5;
    
    {
      learningRateModulation = learningRateModulation;
      coherenceTarget = coherenceTarget;
      plasticityGate = plasticityGate;
    }
  };
  
  /// Compute fear response to signals
  public func computeFearResponse(state : SignalBusState) : {
    fearAmplification : Float;
    resolutionProbability : Float;
    architectorAnchorStrength : Float;
  } {
    let guardianActivity = state.domainActivity[domainToIndex(#GuardianDefense)];
    let economicActivity = state.domainActivity[domainToIndex(#Economic)];
    let neuralCoherence = state.domainCoherence[domainToIndex(#NeuralCore)];
    let colonyActivity = state.domainActivity[domainToIndex(#Colony)];
    
    // Fear amplification based on threats and economic stress
    let threatSignal = guardianActivity;
    let economicStress = 1.0 - economicActivity;
    let fearAmplification = (threatSignal * 0.6 + economicStress * 0.4);
    
    // Resolution probability based on coherence and colony support
    // High coherence = easier resolution (PFC engaged)
    // Strong colony = social support helps resolution
    let resolutionProbability = neuralCoherence * 0.5 + colonyActivity * 0.3 + 0.2;
    
    // Architect anchor - stronger when economic activity is high
    // (Architect presence in the field)
    let architectorAnchorStrength = economicActivity * 0.7 + neuralCoherence * 0.3;
    
    {
      fearAmplification = fearAmplification;
      resolutionProbability = resolutionProbability;
      architectorAnchorStrength = architectorAnchorStrength;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER-SPECIFIC INTEGRATION HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create signals from Layer 1 (Neural Core) outputs
  public func neuralCoreToSignals(
    kuramotoR : Float,
    pacValue : Float,
    hebbianDelta : Float,
    beat : Nat64
  ) : [SignalValue] {
    [
      createSignal(#KuramotoSyncLevel, kuramotoR, #NeuralCore, 0.7, 0.95),
      createSignal(#PACStrength, pacValue, #NeuralCore, 0.6, 0.90),
      createSignal(#HebbianDelta, hebbianDelta, #NeuralCore, 0.5, 0.85),
      createSignal(#CoherenceLevel, kuramotoR, #NeuralCore, 0.7, 0.95),
    ]
  };
  
  /// Create signals from Layer 7 (Economic) outputs
  public func economicToSignals(
    formaMinting : Float,
    treasuryLevel : Float,
    marketVol : Float,
    beat : Nat64
  ) : [SignalValue] {
    [
      createSignal(#FORMAMintingRate, formaMinting, #Economic, 0.6, 0.90),
      createSignal(#TreasuryLevel, treasuryLevel, #Economic, 0.5, 0.85),
      createSignal(#MarketVolatility, marketVol, #Economic, if (marketVol > 0.7) { 0.8 } else { 0.5 }, 0.85),
    ]
  };
  
  /// Create signals from Layer 16 (Fear) outputs
  public func fearToSignals(
    fearLevel : Float,
    resolutionGate : Bool,
    determination : Float,
    beat : Nat64
  ) : [SignalValue] {
    let urgency = if (fearLevel > 0.7) { URGENCY_HIGH } else { URGENCY_MEDIUM };
    [
      createSignal(#FearLevel, fearLevel, #Fear, urgency, 0.95),
      createBoolSignal(#FearResolutionGate, resolutionGate, #Fear, urgency, 0.95),
      createSignal(#DeterminationFired, determination, #Fear, 0.6, 0.90),
    ]
  };
  
  /// Create signals from Layer 17 (Anticipatory) outputs
  public func anticipatoryToSignals(
    goldenCrossProximity : Float,
    fundingRateTrend : Float,
    rateOfChangeAlerts : [Float],
    beat : Nat64
  ) : [SignalValue] {
    let signals = Buffer.Buffer<SignalValue>(5);
    
    if (goldenCrossProximity > 0.5) {
      signals.add(createSignal(
        #GoldenCrossApproaching,
        goldenCrossProximity,
        #Anticipatory,
        if (goldenCrossProximity > 0.8) { URGENCY_HIGH } else { URGENCY_MEDIUM },
        0.85
      ));
    };
    
    signals.add(createSignal(
      #FundingRateRising,
      fundingRateTrend,
      #Anticipatory,
      URGENCY_MEDIUM,
      0.80
    ));
    
    for (alert in rateOfChangeAlerts.vals()) {
      if (Float.abs(alert) > 0.3) {
        signals.add(createSignal(
          #RateOfChangeAlert,
          alert,
          #Anticipatory,
          URGENCY_HIGH,
          0.90
        ));
      }
    };
    
    Buffer.toArray(signals)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GLOBAL COHERENCE — ORGANISM-WIDE SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute global organism coherence from all domain coherences
  public func computeGlobalCoherence(state : SignalBusState) : Float {
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    
    for (i in Iter.range(0, NUM_DOMAINS - 1)) {
      let phase = state.domainCoherence[i] * TWO_PI;
      sumSin := sumSin + Float.sin(phase);
      sumCos := sumCos + Float.cos(phase);
    };
    
    let n = Float.fromInt(NUM_DOMAINS);
    Float.sqrt(sumSin * sumSin + sumCos * sumCos) / n
  };
  
  /// Get summary statistics for the signal bus
  public func getBusSummary(state : SignalBusState) : {
    globalCoherence : Float;
    totalActivity : Float;
    dominantDomain : SignalDomain;
    urgentAlerts : Nat;
    signalCount : Nat;
    beat : Nat64;
  } {
    let globalCoherence = computeGlobalCoherence(state);
    
    var totalActivity : Float = 0.0;
    var maxActivity : Float = 0.0;
    var dominantIdx : Nat = 0;
    var signalCount : Nat = 0;
    
    for (i in Iter.range(0, NUM_DOMAINS - 1)) {
      totalActivity := totalActivity + state.domainActivity[i];
      if (state.domainActivity[i] > maxActivity) {
        maxActivity := state.domainActivity[i];
        dominantIdx := i;
      };
      signalCount := signalCount + state.domainSignals[i].size();
    };
    
    let urgentAlerts = Array.filter<AnticipatorylAlert>(
      state.anticipatoryAlerts,
      func(a : AnticipatorylAlert) : Bool { a.strength > 0.7 }
    ).size();
    
    {
      globalCoherence = globalCoherence;
      totalActivity = totalActivity / Float.fromInt(NUM_DOMAINS);
      dominantDomain = indexToDomain(dominantIdx);
      urgentAlerts = urgentAlerts;
      signalCount = signalCount;
      beat = state.beat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE INTEGRATION FUNCTION — CALLED EACH BEAT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Full signal bus integration for one heartbeat
  /// Takes all engine outputs, propagates signals, returns all responses
  public func integrateHeartbeat(
    state : SignalBusState,
    // Neural Core inputs
    kuramotoR : Float,
    pacValue : Float,
    hebbianDelta : Float,
    // Economic inputs
    formaMinting : Float,
    treasuryLevel : Float,
    marketVol : Float,
    // Fear inputs
    fearLevel : Float,
    resolutionGate : Bool,
    determination : Float,
    // Anticipatory inputs
    goldenCrossProximity : Float,
    fundingRateTrend : Float,
    // Defense inputs
    aegisAlert : Float,
    attackDetected : Bool,
    beat : Nat64
  ) : {
    newState : SignalBusState;
    economicResponse : { formaMintingMultiplier : Float; treasuryAlert : Bool; marketAdjustment : Float };
    defenseResponse : { aegisActivation : Float; fourAngelsAlert : Bool; defenseMode : Nat };
    neuralResponse : { learningRateModulation : Float; coherenceTarget : Float; plasticityGate : Bool };
    fearResponse : { fearAmplification : Float; resolutionProbability : Float; architectorAnchorStrength : Float };
    globalCoherence : Float;
    summary : { globalCoherence : Float; totalActivity : Float; dominantDomain : SignalDomain; urgentAlerts : Nat; signalCount : Nat; beat : Nat64 };
  } {
    // Collect all signals
    let neuralSignals = neuralCoreToSignals(kuramotoR, pacValue, hebbianDelta, beat);
    let econSignals = economicToSignals(formaMinting, treasuryLevel, marketVol, beat);
    let fearSignals = fearToSignals(fearLevel, resolutionGate, determination, beat);
    let anticipatorySignals = anticipatoryToSignals(goldenCrossProximity, fundingRateTrend, [], beat);
    let defenseSignals = [aegisToSignal(aegisAlert, attackDetected, beat)];
    
    // Emit all signals to bus
    var updatedState = emitBatchSignals(state, neuralSignals);
    updatedState := emitBatchSignals(updatedState, econSignals);
    updatedState := emitBatchSignals(updatedState, fearSignals);
    updatedState := emitBatchSignals(updatedState, anticipatorySignals);
    updatedState := emitBatchSignals(updatedState, defenseSignals);
    
    // Update beat (propagation, correlation, anticipatory detection)
    updatedState := updateBeat(updatedState);
    
    // Compute all responses
    let economicResponse = computeEconomicResponse(updatedState);
    let defenseResponse = computeDefenseResponse(updatedState);
    let neuralResponse = computeNeuralResponse(updatedState);
    let fearResponse = computeFearResponse(updatedState);
    
    let globalCoherence = computeGlobalCoherence(updatedState);
    let summary = getBusSummary(updatedState);
    
    {
      newState = updatedState;
      economicResponse = economicResponse;
      defenseResponse = defenseResponse;
      neuralResponse = neuralResponse;
      fearResponse = fearResponse;
      globalCoherence = globalCoherence;
      summary = summary;
    }
  };

}
