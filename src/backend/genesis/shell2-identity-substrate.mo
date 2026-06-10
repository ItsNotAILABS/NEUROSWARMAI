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
// SHELL 2 — IDENTITY SUBSTRATE WITH GENESIS LOCK & DRIFT VERIFICATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Shell 2 is the Identity Substrate — the fundamental layer that defines WHO the organism IS.
// It uses a 12-node leaky integrator circuit to maintain persistent identity traces.
//
// THE BIG REVEAL: LAW AS UNIVERSAL DRIFT VERIFIER
// ────────────────────────────────────────────────
// Every law is already a mathematical constraint function over system state.
// A constraint function is, by definition, a verification function.
// If you compute the law's output at genesis and lock that value — any future deviation
// from that output in ANY system is, by definition, drift.
//
// The law doesn't just govern behavior. It becomes a continuous cryptographic integrity hash
// over the entire organism. The law system becomes the immune system.
//
// GENESIS LOCK MECHANISM:
// At formation, compute: L_genesis(shell2) = lawFunction(state_at_formation)
// Store in CHRONO: {formation_hash, L_genesis[12], timestamp}
// Every heartbeat: δ_drift = |L_live - L_genesis|
// If δ_drift > ε → law cascade fires automatic re-entrainment
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
import Hash "mo:core/Hash";

module Shell2IdentitySubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS — CANONICAL VALUES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;  // Golden ratio
  
  // Shell 2 identity circuit parameters
  public let NUM_IDENTITY_NODES : Nat = 12;
  public let IDENTITY_TAU : Float = 5.0;           // Leaky integrator time constant
  public let IDENTITY_DECAY_RATE : Float = 0.02;   // Baseline decay
  public let IDENTITY_COUPLING : Float = 0.15;     // Inter-node coupling
  
  // Drift verification thresholds
  public let DRIFT_EPSILON : Float = 0.05;         // 5% drift tolerance
  public let DRIFT_CRITICAL : Float = 0.15;        // 15% triggers emergency
  public let DRIFT_CATASTROPHIC : Float = 0.30;    // 30% halts organism
  
  // Genesis lock constants
  public let GENESIS_LOCK_VERSION : Nat = 1;
  public let GENESIS_SIGNATURE_LENGTH : Nat = 32;
  
  // Re-entrainment parameters
  public let REENTRAINMENT_STRENGTH : Float = 0.3;
  public let REENTRAINMENT_PULSE_DURATION : Nat = 10; // heartbeats
  public let MAX_REENTRAINMENT_ATTEMPTS : Nat = 5;

  // ═══════════════════════════════════════════════════════════════════════════════
  // IDENTITY NODE — Single element of the 12-node circuit
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// IdentityNode represents one node in the 12-node leaky integrator circuit
  /// Each node maintains a persistent activation trace that defines identity
  public type IdentityNode = {
    /// Node index (0-11)
    nodeIndex : Nat8;
    
    /// Node identifier name
    nodeName : Text;
    
    /// Current activation level [0, 1]
    activation : Float;
    
    /// Activation velocity (rate of change)
    activationVelocity : Float;
    
    /// Time constant for this specific node
    tau : Float;
    
    /// Decay rate for this node
    decayRate : Float;
    
    /// Input weights from other nodes (12 values)
    inputWeights : [Float];
    
    /// Bias term
    bias : Float;
    
    /// Last update timestamp
    lastUpdate : Int;
    
    /// Total accumulated input
    totalInput : Float;
    
    /// Node-specific identity signature
    identitySignature : Float;
    
    /// Is this node in critical state?
    isCritical : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // IDENTITY CIRCUIT — Complete 12-node architecture
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// IdentityCircuit is the complete 12-node leaky integrator network
  /// This is the core substrate that maintains organism identity
  public type IdentityCircuit = {
    /// All 12 identity nodes
    nodes : [IdentityNode];
    
    /// Global circuit parameters
    globalTau : Float;
    globalDecayRate : Float;
    couplingStrength : Float;
    
    /// Circuit state
    circuitPhase : Float;
    circuitCoherence : Float;
    circuitEnergy : Float;
    
    /// Timestamp
    createdAt : Int;
    lastUpdate : Int;
    heartbeatCount : Nat;
    
    /// Circuit health metrics
    healthScore : Float;
    stabilityIndex : Float;
    entropyMeasure : Float;
    
    /// Is circuit locked (genesis complete)?
    isGenesisLocked : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK — Immutable identity anchor
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// GenesisLock stores the immutable identity state at formation
  /// This is the cryptographic integrity hash that all future states are verified against
  public type GenesisLock = {
    /// Lock version
    version : Nat;
    
    /// Formation timestamp
    formationTime : Int;
    
    /// Formation hash (unique identifier)
    formationHash : Nat32;
    
    /// Genesis activation values for all 12 nodes [L_genesis]
    genesisActivations : [Float];
    
    /// Genesis coherence value
    genesisCoherence : Float;
    
    /// Genesis energy value
    genesisEnergy : Float;
    
    /// Genesis phase vector (12 values)
    genesisPhaseVector : [Float];
    
    /// Genesis weight matrix signature
    genesisWeightSignature : Nat32;
    
    /// Genesis law compliance score
    genesisLawScore : Float;
    
    /// Genesis entropy
    genesisEntropy : Float;
    
    /// Principal who created the genesis lock
    principalId : Text;
    
    /// Is this lock finalized (immutable)?
    isFinalized : Bool;
    
    /// Lock signature
    lockSignature : [Nat8];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT METRICS — Continuous verification state
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// DriftMetrics captures the current drift state from genesis
  /// This is computed every heartbeat to verify organism integrity
  public type DriftMetrics = {
    /// Per-node drift values (12 values)
    nodeDrifts : [Float];
    
    /// Aggregate drift (weighted sum)
    aggregateDrift : Float;
    
    /// Maximum single-node drift
    maxNodeDrift : Float;
    
    /// Node with maximum drift
    maxDriftNodeIndex : Nat8;
    
    /// Coherence drift from genesis
    coherenceDrift : Float;
    
    /// Energy drift from genesis
    energyDrift : Float;
    
    /// Phase vector drift (Euclidean distance)
    phaseVectorDrift : Float;
    
    /// Entropy drift
    entropyDrift : Float;
    
    /// Weight signature drift
    weightDrift : Float;
    
    /// Law compliance drift
    lawScoreDrift : Float;
    
    /// Timestamp of measurement
    measurementTime : Int;
    
    /// Heartbeat at measurement
    heartbeatNumber : Nat;
    
    /// Drift status classification
    driftStatus : DriftStatus;
    
    /// Number of nodes exceeding threshold
    nodesExceedingThreshold : Nat;
  };
  
  /// DriftStatus classification
  public type DriftStatus = {
    #Nominal;      // Within acceptable bounds
    #Warning;      // Approaching threshold
    #Violation;    // Exceeded threshold, needs correction
    #Critical;     // Severe drift, emergency response
    #Catastrophic; // System integrity compromised
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RE-ENTRAINMENT — Automatic drift correction
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ReentrainmentPulse defines a correction signal
  /// This is the law cascade firing to pull the organism back to genesis
  public type ReentrainmentPulse = {
    /// Pulse identifier
    pulseId : Nat;
    
    /// Target nodes (which nodes to correct)
    targetNodes : [Nat8];
    
    /// Correction vectors (how much to correct each node)
    correctionVectors : [Float];
    
    /// Pulse strength
    strength : Float;
    
    /// Pulse duration in heartbeats
    duration : Nat;
    
    /// Remaining heartbeats
    remainingBeats : Nat;
    
    /// Pulse phase (for smooth application)
    pulsePhase : Float;
    
    /// Is pulse active?
    isActive : Bool;
    
    /// Pulse start time
    startTime : Int;
    
    /// Triggered by which drift metric?
    triggeredBy : Text;
    
    /// Pre-correction drift value
    preCorrectionDrift : Float;
    
    /// Current correction progress
    correctionProgress : Float;
  };
  
  /// ReentrainmentState tracks all active corrections
  public type ReentrainmentState = {
    /// Active pulses
    activePulses : [ReentrainmentPulse];
    
    /// Total pulses fired
    totalPulsesFired : Nat;
    
    /// Successful corrections
    successfulCorrections : Nat;
    
    /// Failed corrections
    failedCorrections : Nat;
    
    /// Current attempt count (resets on success)
    currentAttemptCount : Nat;
    
    /// Last correction time
    lastCorrectionTime : Int;
    
    /// Is re-entrainment in progress?
    isActive : Bool;
    
    /// Cumulative correction energy used
    totalEnergyUsed : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAW COMPLIANCE — Identity-specific law functions
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// LawComplianceScore captures the identity law evaluation
  /// This is the constraint function output that becomes the verification hash
  public type LawComplianceScore = {
    /// Overall compliance score [0, 1]
    overallScore : Float;
    
    /// Per-law scores
    activationLaw : Float;      // Activation bounds compliance
    coherenceLaw : Float;       // Coherence maintenance
    stabilityLaw : Float;       // Stability requirement
    entropyLaw : Float;         // Entropy bounds
    couplingLaw : Float;        // Coupling strength limits
    energyLaw : Float;          // Energy conservation
    phaseAlignmentLaw : Float;  // Phase vector alignment
    
    /// Composite scores
    structuralCompliance : Float;
    dynamicCompliance : Float;
    integrityCompliance : Float;
    
    /// Violations detected
    violations : [LawViolation];
    violationCount : Nat;
    
    /// Timestamp
    evaluationTime : Int;
  };
  
  /// LawViolation record
  public type LawViolation = {
    lawName : Text;
    violationType : ViolationType;
    severity : Float;
    nodeIndex : ?Nat8;
    currentValue : Float;
    requiredValue : Float;
    delta : Float;
    timestamp : Int;
  };
  
  /// Violation types
  public type ViolationType = {
    #BoundExceeded;
    #ThresholdViolation;
    #ConstraintFailure;
    #IntegrityBreach;
    #StabilityLoss;
    #CoherenceDecay;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // IDENTITY TRACE — Historical record
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// IdentityTrace captures a snapshot of identity state
  public type IdentityTrace = {
    traceId : Nat;
    heartbeat : Nat;
    timestamp : Int;
    activations : [Float];
    coherence : Float;
    energy : Float;
    driftFromGenesis : Float;
    lawCompliance : Float;
    wasReentrained : Bool;
  };
  
  /// IdentityHistory maintains rolling buffer of traces
  public type IdentityHistory = {
    traces : [IdentityTrace];
    maxTraces : Nat;
    oldestTraceIndex : Nat;
    newestTraceIndex : Nat;
    totalTraces : Nat;
    averageDrift : Float;
    maxHistoricalDrift : Float;
    reentrainmentEvents : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE SHELL 2 STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Shell2State is the complete identity substrate state
  public type Shell2State = {
    /// The identity circuit
    circuit : IdentityCircuit;
    
    /// Genesis lock (immutable after formation)
    genesisLock : ?GenesisLock;
    
    /// Current drift metrics
    currentDrift : DriftMetrics;
    
    /// Re-entrainment state
    reentrainment : ReentrainmentState;
    
    /// Law compliance
    lawCompliance : LawComplianceScore;
    
    /// Identity history
    history : IdentityHistory;
    
    /// Shell 2 metadata
    shellVersion : Nat;
    isInitialized : Bool;
    isGenesisComplete : Bool;
    organismId : Text;
    
    /// Aggregate statistics
    totalHeartbeats : Nat;
    totalDriftEvents : Nat;
    totalReentrainments : Nat;
    averageCompliance : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION — Create default identity node
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a default identity node with given index
  public func createDefaultNode(index : Nat8, name : Text) : IdentityNode {
    {
      nodeIndex = index;
      nodeName = name;
      activation = 0.5;  // Start at midpoint
      activationVelocity = 0.0;
      tau = IDENTITY_TAU;
      decayRate = IDENTITY_DECAY_RATE;
      inputWeights = Array.tabulate<Float>(NUM_IDENTITY_NODES, func(i : Nat) : Float {
        if (i == Nat8.toNat(index)) { 0.0 }  // No self-connection
        else { IDENTITY_COUPLING }
      });
      bias = 0.0;
      lastUpdate = Time.now();
      totalInput = 0.0;
      identitySignature = Float.fromInt(Nat8.toNat(index) + 1) * 0.08333333;  // 1/12 spacing
      isCritical = false;
    }
  };

  /// Create all 12 identity nodes with canonical names
  public func createIdentityNodes() : [IdentityNode] {
    let names = [
      "CORE",       // Node 0: Core identity
      "PURPOSE",    // Node 1: Purpose anchor
      "MEMORY",     // Node 2: Memory signature
      "VALUES",     // Node 3: Value alignment
      "BEHAVIOR",   // Node 4: Behavioral envelope
      "COGNITION",  // Node 5: Cognitive pattern
      "EMOTION",    // Node 6: Emotional baseline
      "SOCIAL",     // Node 7: Social identity
      "TEMPORAL",   // Node 8: Temporal continuity
      "SPATIAL",    // Node 9: Spatial awareness
      "AUTONOMY",   // Node 10: Autonomy bounds
      "INTEGRITY"   // Node 11: Integrity anchor
    ];
    
    Array.tabulate<IdentityNode>(NUM_IDENTITY_NODES, func(i : Nat) : IdentityNode {
      createDefaultNode(Nat8.fromNat(i), names[i])
    })
  };

  /// Create default identity circuit
  public func createDefaultCircuit() : IdentityCircuit {
    {
      nodes = createIdentityNodes();
      globalTau = IDENTITY_TAU;
      globalDecayRate = IDENTITY_DECAY_RATE;
      couplingStrength = IDENTITY_COUPLING;
      circuitPhase = 0.0;
      circuitCoherence = 1.0;
      circuitEnergy = 1.0;
      createdAt = Time.now();
      lastUpdate = Time.now();
      heartbeatCount = 0;
      healthScore = 1.0;
      stabilityIndex = 1.0;
      entropyMeasure = 0.5;  // Medium entropy is healthy
      isGenesisLocked = false;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK — Create immutable identity anchor
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create genesis lock from current circuit state
  /// This locks L_genesis and stores it for all future drift verification
  public func createGenesisLock(
    circuit : IdentityCircuit,
    principalId : Text
  ) : GenesisLock {
    // Extract genesis activations
    let activations = Array.map<IdentityNode, Float>(circuit.nodes, func(n : IdentityNode) : Float {
      n.activation
    });
    
    // Extract genesis phase vector
    let phaseVector = Array.tabulate<Float>(NUM_IDENTITY_NODES, func(i : Nat) : Float {
      circuit.nodes[i].identitySignature * TWO_PI
    });
    
    // Compute formation hash
    let formationHash = computeFormationHash(circuit);
    
    // Compute weight signature
    let weightSignature = computeWeightSignature(circuit);
    
    // Compute genesis law score
    let lawScore = computeLawComplianceScore(circuit);
    
    // Compute genesis entropy
    let entropy = computeCircuitEntropy(circuit);
    
    {
      version = GENESIS_LOCK_VERSION;
      formationTime = Time.now();
      formationHash = formationHash;
      genesisActivations = activations;
      genesisCoherence = circuit.circuitCoherence;
      genesisEnergy = circuit.circuitEnergy;
      genesisPhaseVector = phaseVector;
      genesisWeightSignature = weightSignature;
      genesisLawScore = lawScore.overallScore;
      genesisEntropy = entropy;
      principalId = principalId;
      isFinalized = true;
      lockSignature = computeLockSignature(formationHash);
    }
  };
  
  /// Compute formation hash from circuit state
  func computeFormationHash(circuit : IdentityCircuit) : Nat32 {
    var hash : Nat32 = 0;
    
    // Mix in all activation values
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      let activation = circuit.nodes[i].activation;
      let activationBits = Float.toInt(activation * 1000000.0);
      hash := hash +% Nat32.fromIntWrap(activationBits * (i + 1));
    };
    
    // Mix in coherence
    let coherenceBits = Float.toInt(circuit.circuitCoherence * 1000000.0);
    hash := hash +% Nat32.fromIntWrap(coherenceBits * 13);
    
    // Mix in energy
    let energyBits = Float.toInt(circuit.circuitEnergy * 1000000.0);
    hash := hash +% Nat32.fromIntWrap(energyBits * 17);
    
    hash
  };
  
  /// Compute weight signature from circuit
  func computeWeightSignature(circuit : IdentityCircuit) : Nat32 {
    var sig : Nat32 = 0;
    
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      let weights = circuit.nodes[i].inputWeights;
      for (j in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
        let w = weights[j];
        let wBits = Float.toInt(w * 10000.0);
        sig := sig +% Nat32.fromIntWrap(wBits * (i * NUM_IDENTITY_NODES + j + 1));
      };
    };
    
    sig
  };
  
  /// Compute lock signature
  func computeLockSignature(formationHash : Nat32) : [Nat8] {
    // Simple signature from hash (in production would use cryptographic signing)
    let h = formationHash;
    [
      Nat8.fromNat(Nat32.toNat(h % 256)),
      Nat8.fromNat(Nat32.toNat((h / 256) % 256)),
      Nat8.fromNat(Nat32.toNat((h / 65536) % 256)),
      Nat8.fromNat(Nat32.toNat((h / 16777216) % 256)),
      // Add more bytes for full signature
      Nat8.fromNat(Nat32.toNat((h +% 12345) % 256)),
      Nat8.fromNat(Nat32.toNat((h +% 67890) % 256)),
      Nat8.fromNat(Nat32.toNat((h *% 7) % 256)),
      Nat8.fromNat(Nat32.toNat((h *% 13) % 256))
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LEAKY INTEGRATOR DYNAMICS — Core update function
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update a single node using leaky integrator dynamics
  /// dx/dt = -x/τ + I(t)
  /// Discretized: x(t+1) = x(t) * (1 - dt/τ) + I(t) * dt
  public func updateNode(
    node : IdentityNode,
    allNodes : [IdentityNode],
    externalInput : Float,
    dt : Float
  ) : IdentityNode {
    // Compute weighted input from other nodes
    var totalInput : Float = 0.0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      totalInput += node.inputWeights[i] * allNodes[i].activation;
    };
    
    // Add external input and bias
    totalInput += externalInput + node.bias;
    
    // Apply leaky integrator dynamics
    let decayFactor = 1.0 - dt / node.tau;
    let inputFactor = dt / node.tau;
    
    let newActivation = node.activation * decayFactor + totalInput * inputFactor;
    
    // Clamp to [0, 1]
    let clampedActivation = Float.max(0.0, Float.min(1.0, newActivation));
    
    // Compute velocity
    let newVelocity = (clampedActivation - node.activation) / dt;
    
    {
      nodeIndex = node.nodeIndex;
      nodeName = node.nodeName;
      activation = clampedActivation;
      activationVelocity = newVelocity;
      tau = node.tau;
      decayRate = node.decayRate;
      inputWeights = node.inputWeights;
      bias = node.bias;
      lastUpdate = Time.now();
      totalInput = totalInput;
      identitySignature = node.identitySignature;
      isCritical = Float.abs(clampedActivation - 0.5) > 0.45;
    }
  };
  
  /// Update entire circuit for one heartbeat
  public func updateCircuit(
    circuit : IdentityCircuit,
    externalInputs : [Float],
    dt : Float
  ) : IdentityCircuit {
    // Update all nodes
    let updatedNodes = Array.tabulate<IdentityNode>(NUM_IDENTITY_NODES, func(i : Nat) : IdentityNode {
      let input = if (i < Array.size(externalInputs)) { externalInputs[i] } else { 0.0 };
      updateNode(circuit.nodes[i], circuit.nodes, input, dt)
    });
    
    // Compute new coherence
    let newCoherence = computeCircuitCoherence(updatedNodes);
    
    // Compute new energy
    let newEnergy = computeCircuitEnergy(updatedNodes);
    
    // Compute health score
    let newHealth = computeHealthScore(updatedNodes, newCoherence, newEnergy);
    
    // Compute stability
    let newStability = computeStabilityIndex(updatedNodes, circuit.nodes);
    
    // Compute entropy
    let newEntropy = computeCircuitEntropyFromNodes(updatedNodes);
    
    {
      nodes = updatedNodes;
      globalTau = circuit.globalTau;
      globalDecayRate = circuit.globalDecayRate;
      couplingStrength = circuit.couplingStrength;
      circuitPhase = circuit.circuitPhase + TWO_PI * dt;
      circuitCoherence = newCoherence;
      circuitEnergy = newEnergy;
      createdAt = circuit.createdAt;
      lastUpdate = Time.now();
      heartbeatCount = circuit.heartbeatCount + 1;
      healthScore = newHealth;
      stabilityIndex = newStability;
      entropyMeasure = newEntropy;
      isGenesisLocked = circuit.isGenesisLocked;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE COMPUTATION — Circuit-wide synchronization
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute circuit coherence using Kuramoto order parameter
  /// r = |1/N Σ exp(i*θ_j)| where θ_j is the phase of node j
  func computeCircuitCoherence(nodes : [IdentityNode]) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      // Use activation as proxy for phase
      let phase = nodes[i].activation * TWO_PI;
      sumCos += Float.cos(phase);
      sumSin += Float.sin(phase);
    };
    
    let avgCos = sumCos / Float.fromInt(NUM_IDENTITY_NODES);
    let avgSin = sumSin / Float.fromInt(NUM_IDENTITY_NODES);
    
    Float.sqrt(avgCos * avgCos + avgSin * avgSin)
  };
  
  /// Compute circuit energy (sum of squared activations)
  func computeCircuitEnergy(nodes : [IdentityNode]) : Float {
    var energy : Float = 0.0;
    
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      energy += nodes[i].activation * nodes[i].activation;
    };
    
    energy / Float.fromInt(NUM_IDENTITY_NODES)
  };
  
  /// Compute health score
  func computeHealthScore(nodes : [IdentityNode], coherence : Float, energy : Float) : Float {
    // Count critical nodes
    var criticalCount : Nat = 0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      if (nodes[i].isCritical) { criticalCount += 1; };
    };
    
    let criticalPenalty = Float.fromInt(criticalCount) / Float.fromInt(NUM_IDENTITY_NODES);
    
    // Health is combination of coherence, energy, and lack of critical nodes
    let rawHealth = 0.4 * coherence + 0.3 * energy + 0.3 * (1.0 - criticalPenalty);
    
    Float.max(0.0, Float.min(1.0, rawHealth))
  };
  
  /// Compute stability index (inverse of variance in changes)
  func computeStabilityIndex(newNodes : [IdentityNode], oldNodes : [IdentityNode]) : Float {
    var sumSquaredDiff : Float = 0.0;
    
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      let diff = newNodes[i].activation - oldNodes[i].activation;
      sumSquaredDiff += diff * diff;
    };
    
    let variance = sumSquaredDiff / Float.fromInt(NUM_IDENTITY_NODES);
    
    // Stability is inverse of variance
    1.0 / (1.0 + 10.0 * variance)
  };
  
  /// Compute circuit entropy
  public func computeCircuitEntropy(circuit : IdentityCircuit) : Float {
    computeCircuitEntropyFromNodes(circuit.nodes)
  };
  
  /// Compute entropy from nodes array
  func computeCircuitEntropyFromNodes(nodes : [IdentityNode]) : Float {
    // Use activation distribution as probability
    var totalAct : Float = 0.0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      totalAct += nodes[i].activation;
    };
    
    if (totalAct < 0.001) { return 0.0; };
    
    var entropy : Float = 0.0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      let p = nodes[i].activation / totalAct;
      if (p > 0.001) {
        entropy -= p * Float.log(p);
      };
    };
    
    // Normalize by max entropy (uniform distribution)
    let maxEntropy = Float.log(Float.fromInt(NUM_IDENTITY_NODES));
    entropy / maxEntropy
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT COMPUTATION — Measure deviation from genesis
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute drift metrics comparing current state to genesis lock
  /// This is the core verification function
  public func computeDriftMetrics(
    circuit : IdentityCircuit,
    genesis : GenesisLock,
    heartbeatNumber : Nat
  ) : DriftMetrics {
    // Compute per-node drifts
    let nodeDrifts = Array.tabulate<Float>(NUM_IDENTITY_NODES, func(i : Nat) : Float {
      Float.abs(circuit.nodes[i].activation - genesis.genesisActivations[i])
    });
    
    // Find max drift and its node
    var maxDrift : Float = 0.0;
    var maxDriftNode : Nat8 = 0;
    var nodesExceeding : Nat = 0;
    
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      if (nodeDrifts[i] > maxDrift) {
        maxDrift := nodeDrifts[i];
        maxDriftNode := Nat8.fromNat(i);
      };
      if (nodeDrifts[i] > DRIFT_EPSILON) {
        nodesExceeding += 1;
      };
    };
    
    // Compute aggregate drift (weighted sum)
    var aggregate : Float = 0.0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      // Weight by node importance (CORE and INTEGRITY have higher weights)
      let weight = if (i == 0 or i == 11) { 1.5 } else { 1.0 };
      aggregate += nodeDrifts[i] * weight;
    };
    aggregate := aggregate / (Float.fromInt(NUM_IDENTITY_NODES) + 1.0);  // +1 for extra weights
    
    // Compute coherence drift
    let coherenceDrift = Float.abs(circuit.circuitCoherence - genesis.genesisCoherence);
    
    // Compute energy drift
    let energyDrift = Float.abs(circuit.circuitEnergy - genesis.genesisEnergy);
    
    // Compute phase vector drift (Euclidean distance)
    let phaseVector = Array.tabulate<Float>(NUM_IDENTITY_NODES, func(i : Nat) : Float {
      circuit.nodes[i].identitySignature * TWO_PI
    });
    var phaseVectorDrift : Float = 0.0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      let diff = phaseVector[i] - genesis.genesisPhaseVector[i];
      phaseVectorDrift += diff * diff;
    };
    phaseVectorDrift := Float.sqrt(phaseVectorDrift / Float.fromInt(NUM_IDENTITY_NODES));
    
    // Compute entropy drift
    let currentEntropy = computeCircuitEntropyFromNodes(circuit.nodes);
    let entropyDrift = Float.abs(currentEntropy - genesis.genesisEntropy);
    
    // Compute weight drift
    let currentWeightSig = computeWeightSignature(circuit);
    let weightDrift = if (currentWeightSig != genesis.genesisWeightSignature) { 1.0 } else { 0.0 };
    
    // Compute law score drift
    let lawScore = computeLawComplianceScore(circuit);
    let lawScoreDrift = Float.abs(lawScore.overallScore - genesis.genesisLawScore);
    
    // Determine drift status
    let status = classifyDriftStatus(aggregate, maxDrift, coherenceDrift);
    
    {
      nodeDrifts = nodeDrifts;
      aggregateDrift = aggregate;
      maxNodeDrift = maxDrift;
      maxDriftNodeIndex = maxDriftNode;
      coherenceDrift = coherenceDrift;
      energyDrift = energyDrift;
      phaseVectorDrift = phaseVectorDrift;
      entropyDrift = entropyDrift;
      weightDrift = weightDrift;
      lawScoreDrift = lawScoreDrift;
      measurementTime = Time.now();
      heartbeatNumber = heartbeatNumber;
      driftStatus = status;
      nodesExceedingThreshold = nodesExceeding;
    }
  };
  
  /// Classify drift status based on metrics
  func classifyDriftStatus(aggregate : Float, maxNode : Float, coherence : Float) : DriftStatus {
    let combinedMetric = 0.5 * aggregate + 0.3 * maxNode + 0.2 * coherence;
    
    if (combinedMetric >= DRIFT_CATASTROPHIC) { #Catastrophic }
    else if (combinedMetric >= DRIFT_CRITICAL) { #Critical }
    else if (combinedMetric >= DRIFT_EPSILON) { #Violation }
    else if (combinedMetric >= DRIFT_EPSILON * 0.7) { #Warning }
    else { #Nominal }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAW COMPLIANCE — Constraint function evaluation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute law compliance score for the circuit
  /// This is the L(state) function that becomes the verification hash
  public func computeLawComplianceScore(circuit : IdentityCircuit) : LawComplianceScore {
    let violations = Buffer.Buffer<LawViolation>(0);
    
    // Activation Law: All activations must be in [0, 1]
    var activationScore : Float = 1.0;
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      let a = circuit.nodes[i].activation;
      if (a < 0.0 or a > 1.0) {
        activationScore -= 0.1;
        violations.add({
          lawName = "ActivationBounds";
          violationType = #BoundExceeded;
          severity = Float.abs(a - Float.max(0.0, Float.min(1.0, a)));
          nodeIndex = ?Nat8.fromNat(i);
          currentValue = a;
          requiredValue = Float.max(0.0, Float.min(1.0, a));
          delta = Float.abs(a - Float.max(0.0, Float.min(1.0, a)));
          timestamp = Time.now();
        });
      };
    };
    
    // Coherence Law: Coherence must exceed floor
    let coherenceFloor : Float = 0.3;
    let coherenceScore = if (circuit.circuitCoherence >= coherenceFloor) { 1.0 }
                         else { circuit.circuitCoherence / coherenceFloor };
    if (circuit.circuitCoherence < coherenceFloor) {
      violations.add({
        lawName = "CoherenceFloor";
        violationType = #ThresholdViolation;
        severity = coherenceFloor - circuit.circuitCoherence;
        nodeIndex = null;
        currentValue = circuit.circuitCoherence;
        requiredValue = coherenceFloor;
        delta = coherenceFloor - circuit.circuitCoherence;
        timestamp = Time.now();
      });
    };
    
    // Stability Law: Stability index must exceed threshold
    let stabilityThreshold : Float = 0.5;
    let stabilityScore = if (circuit.stabilityIndex >= stabilityThreshold) { 1.0 }
                         else { circuit.stabilityIndex / stabilityThreshold };
    if (circuit.stabilityIndex < stabilityThreshold) {
      violations.add({
        lawName = "StabilityMinimum";
        violationType = #StabilityLoss;
        severity = stabilityThreshold - circuit.stabilityIndex;
        nodeIndex = null;
        currentValue = circuit.stabilityIndex;
        requiredValue = stabilityThreshold;
        delta = stabilityThreshold - circuit.stabilityIndex;
        timestamp = Time.now();
      });
    };
    
    // Entropy Law: Entropy must be in healthy range [0.2, 0.8]
    let entropyLow : Float = 0.2;
    let entropyHigh : Float = 0.8;
    let entropyScore = if (circuit.entropyMeasure >= entropyLow and circuit.entropyMeasure <= entropyHigh) { 1.0 }
                       else if (circuit.entropyMeasure < entropyLow) { circuit.entropyMeasure / entropyLow }
                       else { entropyHigh / circuit.entropyMeasure };
    
    // Coupling Law: Coupling strength must be positive and bounded
    let couplingMax : Float = 1.0;
    let couplingScore = if (circuit.couplingStrength >= 0.0 and circuit.couplingStrength <= couplingMax) { 1.0 }
                        else { 0.5 };
    
    // Energy Law: Energy must be positive
    let energyScore = if (circuit.circuitEnergy > 0.0) { 1.0 } else { 0.0 };
    
    // Phase Alignment Law: Phases should be distributed
    let phaseScore = circuit.circuitCoherence;  // Reuse coherence as phase alignment proxy
    
    // Compute composite scores
    let structuralCompliance = (activationScore + couplingScore) / 2.0;
    let dynamicCompliance = (coherenceScore + stabilityScore + energyScore) / 3.0;
    let integrityCompliance = (entropyScore + phaseScore) / 2.0;
    
    // Overall score
    let overallScore = 0.35 * structuralCompliance + 0.4 * dynamicCompliance + 0.25 * integrityCompliance;
    
    {
      overallScore = overallScore;
      activationLaw = activationScore;
      coherenceLaw = coherenceScore;
      stabilityLaw = stabilityScore;
      entropyLaw = entropyScore;
      couplingLaw = couplingScore;
      energyLaw = energyScore;
      phaseAlignmentLaw = phaseScore;
      structuralCompliance = structuralCompliance;
      dynamicCompliance = dynamicCompliance;
      integrityCompliance = integrityCompliance;
      violations = Buffer.toArray(violations);
      violationCount = violations.size();
      evaluationTime = Time.now();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RE-ENTRAINMENT — Automatic drift correction
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a re-entrainment pulse to correct drift
  public func createReentrainmentPulse(
    drift : DriftMetrics,
    genesis : GenesisLock,
    pulseId : Nat
  ) : ReentrainmentPulse {
    // Determine which nodes need correction
    let targetNodes = Buffer.Buffer<Nat8>(0);
    let corrections = Buffer.Buffer<Float>(0);
    
    for (i in Iter.range(0, NUM_IDENTITY_NODES - 1)) {
      if (drift.nodeDrifts[i] > DRIFT_EPSILON * 0.5) {
        targetNodes.add(Nat8.fromNat(i));
        // Correction = direction toward genesis * strength
        let current = drift.nodeDrifts[i];
        let target = genesis.genesisActivations[i];
        corrections.add((target - current) * REENTRAINMENT_STRENGTH);
      };
    };
    
    {
      pulseId = pulseId;
      targetNodes = Buffer.toArray(targetNodes);
      correctionVectors = Buffer.toArray(corrections);
      strength = REENTRAINMENT_STRENGTH;
      duration = REENTRAINMENT_PULSE_DURATION;
      remainingBeats = REENTRAINMENT_PULSE_DURATION;
      pulsePhase = 0.0;
      isActive = true;
      startTime = Time.now();
      triggeredBy = switch (drift.driftStatus) {
        case (#Violation) { "DriftViolation" };
        case (#Critical) { "CriticalDrift" };
        case (#Catastrophic) { "CatastrophicDrift" };
        case _ { "PreventiveMaintenance" };
      };
      preCorrectionDrift = drift.aggregateDrift;
      correctionProgress = 0.0;
    }
  };
  
  /// Apply re-entrainment pulse to circuit
  public func applyReentrainmentPulse(
    circuit : IdentityCircuit,
    pulse : ReentrainmentPulse
  ) : (IdentityCircuit, ReentrainmentPulse) {
    if (not pulse.isActive or pulse.remainingBeats == 0) {
      return (circuit, pulse);
    };
    
    // Apply corrections to target nodes
    let updatedNodes = Array.thaw<IdentityNode>(circuit.nodes);
    
    for (i in Iter.range(0, Array.size(pulse.targetNodes) - 1)) {
      let nodeIdx = Nat8.toNat(pulse.targetNodes[i]);
      let correction = pulse.correctionVectors[i];
      
      // Apply smooth correction using pulse phase
      let smoothFactor = 0.5 * (1.0 - Float.cos(pulse.pulsePhase));
      let effectiveCorrection = correction * smoothFactor / Float.fromInt(pulse.duration);
      
      let oldNode = updatedNodes[nodeIdx];
      let newActivation = Float.max(0.0, Float.min(1.0, oldNode.activation + effectiveCorrection));
      
      updatedNodes[nodeIdx] := {
        nodeIndex = oldNode.nodeIndex;
        nodeName = oldNode.nodeName;
        activation = newActivation;
        activationVelocity = (newActivation - oldNode.activation);
        tau = oldNode.tau;
        decayRate = oldNode.decayRate;
        inputWeights = oldNode.inputWeights;
        bias = oldNode.bias;
        lastUpdate = Time.now();
        totalInput = oldNode.totalInput;
        identitySignature = oldNode.identitySignature;
        isCritical = oldNode.isCritical;
      };
    };
    
    // Update pulse state
    let newPhase = pulse.pulsePhase + PI / Float.fromInt(pulse.duration);
    let newRemaining = if (pulse.remainingBeats > 0) { pulse.remainingBeats - 1 } else { 0 };
    let newProgress = 1.0 - Float.fromInt(newRemaining) / Float.fromInt(pulse.duration);
    
    let updatedCircuit = {
      nodes = Array.freeze(updatedNodes);
      globalTau = circuit.globalTau;
      globalDecayRate = circuit.globalDecayRate;
      couplingStrength = circuit.couplingStrength;
      circuitPhase = circuit.circuitPhase;
      circuitCoherence = computeCircuitCoherence(Array.freeze(updatedNodes));
      circuitEnergy = computeCircuitEnergy(Array.freeze(updatedNodes));
      createdAt = circuit.createdAt;
      lastUpdate = Time.now();
      heartbeatCount = circuit.heartbeatCount;
      healthScore = circuit.healthScore;
      stabilityIndex = circuit.stabilityIndex;
      entropyMeasure = circuit.entropyMeasure;
      isGenesisLocked = circuit.isGenesisLocked;
    };
    
    let updatedPulse = {
      pulseId = pulse.pulseId;
      targetNodes = pulse.targetNodes;
      correctionVectors = pulse.correctionVectors;
      strength = pulse.strength;
      duration = pulse.duration;
      remainingBeats = newRemaining;
      pulsePhase = newPhase;
      isActive = newRemaining > 0;
      startTime = pulse.startTime;
      triggeredBy = pulse.triggeredBy;
      preCorrectionDrift = pulse.preCorrectionDrift;
      correctionProgress = newProgress;
    };
    
    (updatedCircuit, updatedPulse)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEFAULT STATE CREATORS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create default drift metrics (no drift)
  public func createDefaultDriftMetrics() : DriftMetrics {
    {
      nodeDrifts = Array.tabulate<Float>(NUM_IDENTITY_NODES, func(_ : Nat) : Float { 0.0 });
      aggregateDrift = 0.0;
      maxNodeDrift = 0.0;
      maxDriftNodeIndex = 0;
      coherenceDrift = 0.0;
      energyDrift = 0.0;
      phaseVectorDrift = 0.0;
      entropyDrift = 0.0;
      weightDrift = 0.0;
      lawScoreDrift = 0.0;
      measurementTime = Time.now();
      heartbeatNumber = 0;
      driftStatus = #Nominal;
      nodesExceedingThreshold = 0;
    }
  };
  
  /// Create default re-entrainment state
  public func createDefaultReentrainmentState() : ReentrainmentState {
    {
      activePulses = [];
      totalPulsesFired = 0;
      successfulCorrections = 0;
      failedCorrections = 0;
      currentAttemptCount = 0;
      lastCorrectionTime = 0;
      isActive = false;
      totalEnergyUsed = 0.0;
    }
  };
  
  /// Create default law compliance score
  public func createDefaultLawComplianceScore() : LawComplianceScore {
    {
      overallScore = 1.0;
      activationLaw = 1.0;
      coherenceLaw = 1.0;
      stabilityLaw = 1.0;
      entropyLaw = 1.0;
      couplingLaw = 1.0;
      energyLaw = 1.0;
      phaseAlignmentLaw = 1.0;
      structuralCompliance = 1.0;
      dynamicCompliance = 1.0;
      integrityCompliance = 1.0;
      violations = [];
      violationCount = 0;
      evaluationTime = Time.now();
    }
  };
  
  /// Create default identity history
  public func createDefaultIdentityHistory() : IdentityHistory {
    {
      traces = [];
      maxTraces = 1000;
      oldestTraceIndex = 0;
      newestTraceIndex = 0;
      totalTraces = 0;
      averageDrift = 0.0;
      maxHistoricalDrift = 0.0;
      reentrainmentEvents = 0;
    }
  };

  /// Create complete default Shell 2 state
  public func createDefaultShell2State(organismId : Text) : Shell2State {
    let circuit = createDefaultCircuit();
    {
      circuit = circuit;
      genesisLock = null;
      currentDrift = createDefaultDriftMetrics();
      reentrainment = createDefaultReentrainmentState();
      lawCompliance = computeLawComplianceScore(circuit);
      history = createDefaultIdentityHistory();
      shellVersion = 1;
      isInitialized = true;
      isGenesisComplete = false;
      organismId = organismId;
      totalHeartbeats = 0;
      totalDriftEvents = 0;
      totalReentrainments = 0;
      averageCompliance = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT PROCESSING — Main update cycle
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process one heartbeat for Shell 2
  /// This is the main function called every heartbeat
  public func processHeartbeat(
    state : Shell2State,
    externalInputs : [Float],
    dt : Float
  ) : Shell2State {
    // Update circuit dynamics
    let updatedCircuit = updateCircuit(state.circuit, externalInputs, dt);
    
    // Compute drift if genesis is locked
    let (newDrift, shouldReentrain) = switch (state.genesisLock) {
      case (?genesis) {
        let drift = computeDriftMetrics(updatedCircuit, genesis, state.totalHeartbeats + 1);
        let needsCorrection = switch (drift.driftStatus) {
          case (#Violation or #Critical or #Catastrophic) { true };
          case _ { false };
        };
        (drift, needsCorrection)
      };
      case (null) {
        (state.currentDrift, false)
      };
    };
    
    // Apply re-entrainment if needed
    let (finalCircuit, updatedReentrainment, reentrainmentCount) = if (shouldReentrain and state.genesisLock != null) {
      switch (state.genesisLock) {
        case (?genesis) {
          let pulse = createReentrainmentPulse(newDrift, genesis, state.reentrainment.totalPulsesFired);
          let (correctedCircuit, appliedPulse) = applyReentrainmentPulse(updatedCircuit, pulse);
          
          let newReentrainment = {
            activePulses = [appliedPulse];
            totalPulsesFired = state.reentrainment.totalPulsesFired + 1;
            successfulCorrections = state.reentrainment.successfulCorrections;
            failedCorrections = state.reentrainment.failedCorrections;
            currentAttemptCount = state.reentrainment.currentAttemptCount + 1;
            lastCorrectionTime = Time.now();
            isActive = true;
            totalEnergyUsed = state.reentrainment.totalEnergyUsed + REENTRAINMENT_STRENGTH;
          };
          
          (correctedCircuit, newReentrainment, state.totalReentrainments + 1)
        };
        case (null) { (updatedCircuit, state.reentrainment, state.totalReentrainments) };
      }
    } else {
      // Process any ongoing pulses
      if (state.reentrainment.isActive and Array.size(state.reentrainment.activePulses) > 0) {
        let pulse = state.reentrainment.activePulses[0];
        let (correctedCircuit, appliedPulse) = applyReentrainmentPulse(updatedCircuit, pulse);
        
        let newReentrainment = {
          activePulses = if (appliedPulse.isActive) { [appliedPulse] } else { [] };
          totalPulsesFired = state.reentrainment.totalPulsesFired;
          successfulCorrections = if (not appliedPulse.isActive) {
            state.reentrainment.successfulCorrections + 1
          } else { state.reentrainment.successfulCorrections };
          failedCorrections = state.reentrainment.failedCorrections;
          currentAttemptCount = if (not appliedPulse.isActive) { 0 } else { state.reentrainment.currentAttemptCount };
          lastCorrectionTime = state.reentrainment.lastCorrectionTime;
          isActive = appliedPulse.isActive;
          totalEnergyUsed = state.reentrainment.totalEnergyUsed;
        };
        
        (correctedCircuit, newReentrainment, state.totalReentrainments)
      } else {
        (updatedCircuit, state.reentrainment, state.totalReentrainments)
      }
    };
    
    // Compute new law compliance
    let newLawCompliance = computeLawComplianceScore(finalCircuit);
    
    // Update statistics
    let newTotalHeartbeats = state.totalHeartbeats + 1;
    let newDriftEvents = if (shouldReentrain) { state.totalDriftEvents + 1 } else { state.totalDriftEvents };
    let newAverageCompliance = (state.averageCompliance * Float.fromInt(state.totalHeartbeats) + newLawCompliance.overallScore) 
                               / Float.fromInt(newTotalHeartbeats);
    
    // Record this heartbeat as an identity trace in the rolling buffer
    let newTrace : IdentityTrace = {
      traceId = state.history.totalTraces + 1;
      heartbeat = newTotalHeartbeats;
      timestamp = Time.now();
      activations = Array.map<IdentityNode, Float>(finalCircuit.nodes, func(n : IdentityNode) : Float { n.activation });
      coherence = finalCircuit.circuitCoherence;
      energy = finalCircuit.circuitEnergy;
      driftFromGenesis = newDrift.driftMagnitude;
      lawCompliance = newLawCompliance.overallScore;
      wasReentrained = reentrainmentCount > state.totalReentrainments;
    };
    let prevTraces = state.history.traces;
    let maxT = state.history.maxTraces;
    let newTraces = if (Array.size(prevTraces) >= maxT) {
      // Drop oldest (first) entry to maintain rolling window of exactly maxT entries
      // When size == maxT: start=1 drops exactly one; when size > maxT (shouldn't happen): drops extras
      let start = if (Array.size(prevTraces) == maxT) { 1 } else { Array.size(prevTraces) - maxT + 1 };
      let buf = Buffer.Buffer<IdentityTrace>(maxT);
      for (i in Iter.range(start, Array.size(prevTraces) - 1)) {
        buf.add(prevTraces[i]);
      };
      buf.add(newTrace);
      Buffer.toArray(buf)
    } else {
      Array.append(prevTraces, [newTrace])
    };
    let newMaxDrift = Float.max(state.history.maxHistoricalDrift, newDrift.driftMagnitude);
    let newHistory : IdentityHistory = {
      traces = newTraces;
      maxTraces = maxT;
      oldestTraceIndex = if (Array.size(newTraces) >= maxT) { state.history.oldestTraceIndex + 1 } else { state.history.oldestTraceIndex };
      newestTraceIndex = state.history.totalTraces;
      totalTraces = state.history.totalTraces + 1;
      averageDrift = (state.history.averageDrift * Float.fromInt(state.history.totalTraces) + newDrift.driftMagnitude) / Float.fromInt(state.history.totalTraces + 1);
      maxHistoricalDrift = newMaxDrift;
      reentrainmentEvents = state.history.reentrainmentEvents + (if (reentrainmentCount > state.totalReentrainments) { 1 } else { 0 });
    };

    {
      circuit = finalCircuit;
      genesisLock = state.genesisLock;
      currentDrift = newDrift;
      reentrainment = updatedReentrainment;
      lawCompliance = newLawCompliance;
      history = newHistory;
      shellVersion = state.shellVersion;
      isInitialized = state.isInitialized;
      isGenesisComplete = state.isGenesisComplete;
      organismId = state.organismId;
      totalHeartbeats = newTotalHeartbeats;
      totalDriftEvents = newDriftEvents;
      totalReentrainments = reentrainmentCount;
      averageCompliance = newAverageCompliance;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK FUNCTION — Lock identity at formation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock the current state as genesis
  /// After this, all future states are verified against this lock
  public func lockGenesis(state : Shell2State, principalId : Text) : Shell2State {
    if (state.isGenesisComplete) {
      return state;  // Already locked
    };
    
    let lock = createGenesisLock(state.circuit, principalId);
    
    let lockedCircuit = {
      nodes = state.circuit.nodes;
      globalTau = state.circuit.globalTau;
      globalDecayRate = state.circuit.globalDecayRate;
      couplingStrength = state.circuit.couplingStrength;
      circuitPhase = state.circuit.circuitPhase;
      circuitCoherence = state.circuit.circuitCoherence;
      circuitEnergy = state.circuit.circuitEnergy;
      createdAt = state.circuit.createdAt;
      lastUpdate = state.circuit.lastUpdate;
      heartbeatCount = state.circuit.heartbeatCount;
      healthScore = state.circuit.healthScore;
      stabilityIndex = state.circuit.stabilityIndex;
      entropyMeasure = state.circuit.entropyMeasure;
      isGenesisLocked = true;
    };
    
    {
      circuit = lockedCircuit;
      genesisLock = ?lock;
      currentDrift = createDefaultDriftMetrics();
      reentrainment = state.reentrainment;
      lawCompliance = state.lawCompliance;
      history = state.history;
      shellVersion = state.shellVersion;
      isInitialized = state.isInitialized;
      isGenesisComplete = true;
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats;
      totalDriftEvents = state.totalDriftEvents;
      totalReentrainments = state.totalReentrainments;
      averageCompliance = state.averageCompliance;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS — Safe numeric outputs only
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get drift compliance score (numeric only)
  public func getDriftComplianceScore(state : Shell2State) : Float {
    switch (state.genesisLock) {
      case (?_) { 1.0 - state.currentDrift.aggregateDrift };
      case (null) { 1.0 };  // No drift possible without genesis
    }
  };
  
  /// Get law compliance score (numeric only)
  public func getLawComplianceScore(state : Shell2State) : Float {
    state.lawCompliance.overallScore
  };
  
  /// Get health score (numeric only)
  public func getHealthScore(state : Shell2State) : Float {
    state.circuit.healthScore
  };
  
  /// Get stability index (numeric only)
  public func getStabilityIndex(state : Shell2State) : Float {
    state.circuit.stabilityIndex
  };
  
  /// Get coherence (numeric only)
  public func getCoherence(state : Shell2State) : Float {
    state.circuit.circuitCoherence
  };
  
  /// Is genesis locked?
  public func isGenesisLocked(state : Shell2State) : Bool {
    state.isGenesisComplete
  };
  
  /// Get re-entrainment count
  public func getReentrainmentCount(state : Shell2State) : Nat {
    state.totalReentrainments
  };
  
  /// Get drift status
  public func getDriftStatus(state : Shell2State) : DriftStatus {
    state.currentDrift.driftStatus
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTER-SHELL INTERFACE — Connection to other shells
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get Shell 2 contribution to Shell 3 (upward projection)
  public func getShell3Contribution(state : Shell2State) : [Float] {
    // Shell 2 projects identity traces to Shell 3 brain field
    Array.map<IdentityNode, Float>(state.circuit.nodes, func(n : IdentityNode) : Float {
      n.activation * state.circuit.circuitCoherence
    })
  };
  
  /// Receive Shell 1 influence (downward modulation from instinct layer)
  public func receiveShell1Influence(state : Shell2State, shell1Signal : [Float]) : Shell2State {
    // Shell 1 instinct layer modulates identity through bias adjustment
    if (Array.size(shell1Signal) != NUM_IDENTITY_NODES) {
      return state;
    };
    
    let modulatedNodes = Array.tabulate<IdentityNode>(NUM_IDENTITY_NODES, func(i : Nat) : IdentityNode {
      let node = state.circuit.nodes[i];
      {
        nodeIndex = node.nodeIndex;
        nodeName = node.nodeName;
        activation = node.activation;
        activationVelocity = node.activationVelocity;
        tau = node.tau;
        decayRate = node.decayRate;
        inputWeights = node.inputWeights;
        bias = node.bias + shell1Signal[i] * 0.1;  // Small modulation
        lastUpdate = node.lastUpdate;
        totalInput = node.totalInput;
        identitySignature = node.identitySignature;
        isCritical = node.isCritical;
      }
    });
    
    let modulatedCircuit = {
      nodes = modulatedNodes;
      globalTau = state.circuit.globalTau;
      globalDecayRate = state.circuit.globalDecayRate;
      couplingStrength = state.circuit.couplingStrength;
      circuitPhase = state.circuit.circuitPhase;
      circuitCoherence = state.circuit.circuitCoherence;
      circuitEnergy = state.circuit.circuitEnergy;
      createdAt = state.circuit.createdAt;
      lastUpdate = Time.now();
      heartbeatCount = state.circuit.heartbeatCount;
      healthScore = state.circuit.healthScore;
      stabilityIndex = state.circuit.stabilityIndex;
      entropyMeasure = state.circuit.entropyMeasure;
      isGenesisLocked = state.circuit.isGenesisLocked;
    };
    
    {
      circuit = modulatedCircuit;
      genesisLock = state.genesisLock;
      currentDrift = state.currentDrift;
      reentrainment = state.reentrainment;
      lawCompliance = state.lawCompliance;
      history = state.history;
      shellVersion = state.shellVersion;
      isInitialized = state.isInitialized;
      isGenesisComplete = state.isGenesisComplete;
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats;
      totalDriftEvents = state.totalDriftEvents;
      totalReentrainments = state.totalReentrainments;
      averageCompliance = state.averageCompliance;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CHRONO INTEGRATION — Interface for temporal storage
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ChronoRecord for storing in CHRONO temporal field
  public type ChronoRecord = {
    recordType : Text;
    timestamp : Int;
    heartbeat : Nat;
    formationHash : Nat32;
    genesisActivations : [Float];
    genesisCoherence : Float;
    genesisLawScore : Float;
    currentDrift : Float;
    currentCompliance : Float;
    isGenesisLocked : Bool;
  };
  
  /// Create CHRONO record from state
  public func createChronoRecord(state : Shell2State) : ChronoRecord {
    {
      recordType = "SHELL2_IDENTITY";
      timestamp = Time.now();
      heartbeat = state.totalHeartbeats;
      formationHash = switch (state.genesisLock) {
        case (?lock) { lock.formationHash };
        case (null) { 0 : Nat32 };
      };
      genesisActivations = switch (state.genesisLock) {
        case (?lock) { lock.genesisActivations };
        case (null) { [] };
      };
      genesisCoherence = switch (state.genesisLock) {
        case (?lock) { lock.genesisCoherence };
        case (null) { 0.0 };
      };
      genesisLawScore = switch (state.genesisLock) {
        case (?lock) { lock.genesisLawScore };
        case (null) { 0.0 };
      };
      currentDrift = state.currentDrift.aggregateDrift;
      currentCompliance = state.lawCompliance.overallScore;
      isGenesisLocked = state.isGenesisComplete;
    }
  };

}
