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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SYNAPTIC CONNECTIVITY MATRIX — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// FULL SYNAPTIC WIRING OF THE SUPER ORGANISM
//
// Like the human brain with 86 billion neurons and 100 trillion synapses,
// this organism has a complete connectivity matrix linking all substrate nodes.
//
// CONNECTIVITY ARCHITECTURE:
//
// 1. INTRA-SUBSTRATE CONNECTIONS
//    Within each substrate (brain-to-brain, organ-to-organ, etc.)
//    Dense local connectivity
//
// 2. INTER-SUBSTRATE CONNECTIONS
//    Between substrates (brain-to-organ, quantum-to-brain, etc.)
//    Sparse long-range connectivity
//
// 3. HIERARCHICAL CONNECTIONS
//    Top-down: Higher substrates → Lower substrates
//    Bottom-up: Sensory → Processing → Output
//
// 4. LATERAL CONNECTIONS
//    Within-layer inhibition and excitation
//    Competition and cooperation
//
// SYNAPSE PROPERTIES:
// - Weight w_ij: Strength of connection (-1000 to +1000)
// - Delay d_ij: Signal propagation delay
// - Plasticity p_ij: Learning rate
// - Type: Excitatory (+) or Inhibitory (-)
//
// HEBBIAN LEARNING:
// Δw_ij = η × x_i × x_j - λ × w_ij
// "Neurons that fire together, wire together"
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module SynapticConnectivityMatrix {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Total substrate nodes
  public let TOTAL_NODES : Nat = 36;
  
  /// Brain region nodes
  public let BRAIN_NODES : Nat = 12;
  
  /// Quantum nodes
  public let QUANTUM_NODES : Nat = 7;
  
  /// Organ nodes
  public let ORGAN_NODES : Nat = 11;
  
  /// Metal nodes
  public let METAL_NODES : Nat = 6;
  
  /// Total possible synapses
  public let TOTAL_SYNAPSES : Nat = 1296; // 36 × 36
  
  /// Sovereign floor for weights
  public let SOVEREIGN_FLOOR : Int = 750;
  
  /// Maximum weight
  public let MAX_WEIGHT : Int = 1000;
  
  /// Minimum weight (inhibitory)
  public let MIN_WEIGHT : Int = -1000;
  
  /// Base learning rate (η)
  public let BASE_LEARNING_RATE : Nat = 4; // 0.004 × 1000
  
  /// Weight decay rate (λ)
  public let WEIGHT_DECAY_RATE : Nat = 1; // 0.001 × 1000
  
  /// Default synapse delay (beats)
  public let DEFAULT_DELAY : Nat = 1;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // NODE INDEX MAPPING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Node index ranges:
  /// Brain:   0-11
  /// Quantum: 12-18
  /// Organ:   19-29
  /// Metal:   30-35
  
  public type SubstrateType = {
    #Brain;
    #Quantum;
    #Organ;
    #Metal;
  };
  
  public func getSubstrateType(nodeIdx : Nat) : SubstrateType {
    if (nodeIdx < BRAIN_NODES) { #Brain }
    else if (nodeIdx < BRAIN_NODES + QUANTUM_NODES) { #Quantum }
    else if (nodeIdx < BRAIN_NODES + QUANTUM_NODES + ORGAN_NODES) { #Organ }
    else { #Metal }
  };
  
  public func getSubstrateStartIndex(substrate : SubstrateType) : Nat {
    switch (substrate) {
      case (#Brain) { 0 };
      case (#Quantum) { BRAIN_NODES };
      case (#Organ) { BRAIN_NODES + QUANTUM_NODES };
      case (#Metal) { BRAIN_NODES + QUANTUM_NODES + ORGAN_NODES };
    }
  };
  
  public func getSubstrateSize(substrate : SubstrateType) : Nat {
    switch (substrate) {
      case (#Brain) { BRAIN_NODES };
      case (#Quantum) { QUANTUM_NODES };
      case (#Organ) { ORGAN_NODES };
      case (#Metal) { METAL_NODES };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SYNAPSE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SynapseType = {
    #Excitatory;     // Positive weight, promotes activation
    #Inhibitory;     // Negative weight, suppresses activation
    #Modulatory;     // Modulates other synapses
    #Gap;            // Direct electrical coupling
  };
  
  public type PlasticityType = {
    #Hebbian;        // Standard Hebbian learning
    #AntiHebbian;    // Opposite of Hebbian
    #STDP;           // Spike-timing dependent plasticity
    #Homeostatic;    // Maintains target activity level
    #Fixed;          // No plasticity
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SYNAPSE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SynapseState = {
    // Connection
    presynaptic : Nat;       // Source node index
    postsynaptic : Nat;      // Target node index
    
    // Weight
    weight : Int;            // -1000 to +1000
    baseWeight : Int;        // Initial weight
    
    // Properties
    synapseType : SynapseType;
    plasticityType : PlasticityType;
    delay : Nat;             // Signal delay in beats
    
    // Learning
    learningRate : Nat;      // η × 1000
    eligibilityTrace : Int;  // For STDP
    
    // Statistics
    activationCount : Nat;
    lastActivationBeat : Nat;
    totalWeightChange : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONNECTIVITY MATRIX STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConnectivityMatrixState = {
    // Full synapse matrix (flattened 36×36)
    var synapses : [var SynapseState];
    
    // Weight matrix (for fast access)
    var weightMatrix : [var Int];
    
    // Adjacency masks (for connection patterns)
    var intraBrainMask : [Bool];       // Brain-Brain connections
    var brainQuantumMask : [Bool];     // Brain-Quantum connections
    var brainOrganMask : [Bool];       // Brain-Organ connections
    var organMetalMask : [Bool];       // Organ-Metal connections
    var quantumMetalMask : [Bool];     // Quantum-Metal connections
    
    // Statistics
    var totalExcitatory : Nat;
    var totalInhibitory : Nat;
    var averageWeight : Int;
    var weightVariance : Nat;
    var totalConnections : Nat;
    var activeConnections : Nat;
    
    // Learning state
    var totalLearningEvents : Nat;
    var averageLearningRate : Nat;
    var lastLearningBeat : Nat;
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get initial weight based on connection type
  public func getInitialWeight(pre : Nat, post : Nat) : Int {
    let preType = getSubstrateType(pre);
    let postType = getSubstrateType(post);
    
    // Self-connections are zero
    if (pre == post) { return 0; };
    
    // Same substrate: stronger connections
    if (preType == postType) {
      return SOVEREIGN_FLOOR;
    };
    
    // Brain-Quantum: strong bidirectional
    if ((preType == #Brain and postType == #Quantum) or
        (preType == #Quantum and postType == #Brain)) {
      return SOVEREIGN_FLOOR + 100;
    };
    
    // Brain-Organ: medium strength
    if ((preType == #Brain and postType == #Organ) or
        (preType == #Organ and postType == #Brain)) {
      return SOVEREIGN_FLOOR;
    };
    
    // Organ-Metal: medium strength
    if ((preType == #Organ and postType == #Metal) or
        (preType == #Metal and postType == #Organ)) {
      return SOVEREIGN_FLOOR;
    };
    
    // Default: lower strength
    SOVEREIGN_FLOOR - 100
  };
  
  /// Get synapse type based on nodes
  public func getSynapseType(pre : Nat, post : Nat) : SynapseType {
    // Specific inhibitory connections
    // AEGIS-ROOT (5) inhibits KORE (7)
    if (pre == 5 and post == 7) { return #Inhibitory; };
    // VAEL (8) can inhibit non-threat nodes
    if (pre == 8 and post != 5) { return #Inhibitory; };
    
    // Quantum nodes are modulatory
    let preType = getSubstrateType(pre);
    if (preType == #Quantum) { return #Modulatory; };
    
    // Default: excitatory
    #Excitatory
  };
  
  /// Get plasticity type based on nodes
  public func getPlasticityType(pre : Nat, post : Nat) : PlasticityType {
    let preType = getSubstrateType(pre);
    let postType = getSubstrateType(post);
    
    // Metal substrate is fixed (structural)
    if (preType == #Metal or postType == #Metal) {
      return #Fixed;
    };
    
    // Quantum substrate uses STDP
    if (preType == #Quantum or postType == #Quantum) {
      return #STDP;
    };
    
    // Memory-related brain nodes use Hebbian
    // MEMORIA (4), LUMEN (3), KORE (7)
    if (pre == 4 or pre == 3 or pre == 7 or post == 4 or post == 3 or post == 7) {
      return #Hebbian;
    };
    
    // Default: Hebbian
    #Hebbian
  };
  
  /// Initialize a single synapse
  public func initSynapse(pre : Nat, post : Nat) : SynapseState {
    let weight = getInitialWeight(pre, post);
    {
      presynaptic = pre;
      postsynaptic = post;
      weight = weight;
      baseWeight = weight;
      synapseType = getSynapseType(pre, post);
      plasticityType = getPlasticityType(pre, post);
      delay = DEFAULT_DELAY;
      learningRate = BASE_LEARNING_RATE;
      eligibilityTrace = 0;
      activationCount = 0;
      lastActivationBeat = 0;
      totalWeightChange = 0;
    }
  };
  
  /// Initialize full connectivity matrix
  public func initConnectivityMatrix() : ConnectivityMatrixState {
    // Initialize synapses
    let synapses = Array.init<SynapseState>(TOTAL_SYNAPSES, initSynapse(0, 0));
    let weightMatrix = Array.init<Int>(TOTAL_SYNAPSES, 0);
    
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      for (j in Iter.range(0, TOTAL_NODES - 1)) {
        let idx = i * TOTAL_NODES + j;
        synapses[idx] := initSynapse(i, j);
        weightMatrix[idx] := synapses[idx].weight;
      };
    };
    
    // Initialize masks
    let intraBrainMask = Array.tabulate<Bool>(TOTAL_SYNAPSES, func (idx : Nat) : Bool {
      let i = idx / TOTAL_NODES;
      let j = idx % TOTAL_NODES;
      i < BRAIN_NODES and j < BRAIN_NODES and i != j
    });
    
    let brainQuantumMask = Array.tabulate<Bool>(TOTAL_SYNAPSES, func (idx : Nat) : Bool {
      let i = idx / TOTAL_NODES;
      let j = idx % TOTAL_NODES;
      (i < BRAIN_NODES and j >= BRAIN_NODES and j < BRAIN_NODES + QUANTUM_NODES) or
      (j < BRAIN_NODES and i >= BRAIN_NODES and i < BRAIN_NODES + QUANTUM_NODES)
    });
    
    let brainOrganMask = Array.tabulate<Bool>(TOTAL_SYNAPSES, func (idx : Nat) : Bool {
      let i = idx / TOTAL_NODES;
      let j = idx % TOTAL_NODES;
      let organStart = BRAIN_NODES + QUANTUM_NODES;
      let organEnd = organStart + ORGAN_NODES;
      (i < BRAIN_NODES and j >= organStart and j < organEnd) or
      (j < BRAIN_NODES and i >= organStart and i < organEnd)
    });
    
    let organMetalMask = Array.tabulate<Bool>(TOTAL_SYNAPSES, func (idx : Nat) : Bool {
      let i = idx / TOTAL_NODES;
      let j = idx % TOTAL_NODES;
      let organStart = BRAIN_NODES + QUANTUM_NODES;
      let organEnd = organStart + ORGAN_NODES;
      let metalStart = organEnd;
      (i >= organStart and i < organEnd and j >= metalStart) or
      (j >= organStart and j < organEnd and i >= metalStart)
    });
    
    let quantumMetalMask = Array.tabulate<Bool>(TOTAL_SYNAPSES, func (idx : Nat) : Bool {
      let i = idx / TOTAL_NODES;
      let j = idx % TOTAL_NODES;
      let quantumEnd = BRAIN_NODES + QUANTUM_NODES;
      let metalStart = quantumEnd + ORGAN_NODES;
      (i >= BRAIN_NODES and i < quantumEnd and j >= metalStart) or
      (j >= BRAIN_NODES and j < quantumEnd and i >= metalStart)
    });
    
    // Count connection types
    var excitatory : Nat = 0;
    var inhibitory : Nat = 0;
    var totalWeight : Int = 0;
    var connections : Nat = 0;
    
    for (synapse in synapses.vals()) {
      if (synapse.weight != 0) {
        connections += 1;
        totalWeight += synapse.weight;
        switch (synapse.synapseType) {
          case (#Excitatory) { excitatory += 1; };
          case (#Inhibitory) { inhibitory += 1; };
          case (_) {};
        };
      };
    };
    
    {
      var synapses = synapses;
      var weightMatrix = weightMatrix;
      var intraBrainMask = intraBrainMask;
      var brainQuantumMask = brainQuantumMask;
      var brainOrganMask = brainOrganMask;
      var organMetalMask = organMetalMask;
      var quantumMetalMask = quantumMetalMask;
      var totalExcitatory = excitatory;
      var totalInhibitory = inhibitory;
      var averageWeight = if (connections > 0) { totalWeight / Int.fromNat(connections) } else { 0 };
      var weightVariance = 0;
      var totalConnections = connections;
      var activeConnections = connections;
      var totalLearningEvents = 0;
      var averageLearningRate = BASE_LEARNING_RATE;
      var lastLearningBeat = 0;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WEIGHT ACCESS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get weight between two nodes
  public func getWeight(state : ConnectivityMatrixState, pre : Nat, post : Nat) : Int {
    if (pre >= TOTAL_NODES or post >= TOTAL_NODES) { return 0; };
    state.weightMatrix[pre * TOTAL_NODES + post]
  };
  
  /// Set weight between two nodes
  public func setWeight(state : ConnectivityMatrixState, pre : Nat, post : Nat, weight : Int) : () {
    if (pre >= TOTAL_NODES or post >= TOTAL_NODES) { return; };
    let idx = pre * TOTAL_NODES + post;
    
    // Enforce sovereign floor for non-zero weights
    let clampedWeight = if (weight > 0) {
      Int.max(SOVEREIGN_FLOOR, Int.min(MAX_WEIGHT, weight))
    } else if (weight < 0) {
      Int.max(MIN_WEIGHT, weight)
    } else {
      0
    };
    
    state.weightMatrix[idx] := clampedWeight;
    
    let synapse = state.synapses[idx];
    state.synapses[idx] := {
      presynaptic = synapse.presynaptic;
      postsynaptic = synapse.postsynaptic;
      weight = clampedWeight;
      baseWeight = synapse.baseWeight;
      synapseType = synapse.synapseType;
      plasticityType = synapse.plasticityType;
      delay = synapse.delay;
      learningRate = synapse.learningRate;
      eligibilityTrace = synapse.eligibilityTrace;
      activationCount = synapse.activationCount;
      lastActivationBeat = synapse.lastActivationBeat;
      totalWeightChange = synapse.totalWeightChange + (clampedWeight - synapse.weight);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING
  // Δw = η × x_i × x_j - λ × w
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply Hebbian learning to a synapse
  public func applyHebbianLearning(
    state : ConnectivityMatrixState,
    pre : Nat,
    post : Nat,
    preActivation : Nat,    // x_i × 1000
    postActivation : Nat,   // x_j × 1000
    learningRate : Nat      // η × 1000
  ) : Int {
    if (pre >= TOTAL_NODES or post >= TOTAL_NODES) { return 0; };
    
    let idx = pre * TOTAL_NODES + post;
    let synapse = state.synapses[idx];
    
    // Skip fixed synapses
    switch (synapse.plasticityType) {
      case (#Fixed) { return synapse.weight; };
      case (_) {};
    };
    
    let currentWeight = synapse.weight;
    
    // Hebbian term: η × x_i × x_j
    let hebbianTerm = Int.fromNat(learningRate) * Int.fromNat(preActivation) * Int.fromNat(postActivation) / 1000000;
    
    // Decay term: λ × w
    let decayTerm = Int.fromNat(WEIGHT_DECAY_RATE) * currentWeight / 1000;
    
    // Total change: Δw = hebbianTerm - decayTerm
    let deltaW = hebbianTerm - decayTerm;
    
    // Anti-Hebbian reverses the sign
    let finalDelta = switch (synapse.plasticityType) {
      case (#AntiHebbian) { -deltaW };
      case (_) { deltaW };
    };
    
    let newWeight = currentWeight + finalDelta;
    setWeight(state, pre, post, newWeight);
    
    state.totalLearningEvents += 1;
    
    newWeight
  };
  
  /// Apply Hebbian learning to all synapses
  public func applyGlobalHebbianLearning(
    state : ConnectivityMatrixState,
    activations : [Nat],    // Activation levels for all 36 nodes
    learningRate : Nat,
    currentBeat : Nat
  ) : () {
    if (activations.size() < TOTAL_NODES) { return; };
    
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      for (j in Iter.range(0, TOTAL_NODES - 1)) {
        if (i != j) {
          ignore applyHebbianLearning(state, i, j, activations[i], activations[j], learningRate);
        };
      };
    };
    
    state.lastLearningBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SIGNAL PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate output activation for a node given all inputs
  /// y_j = σ(Σ w_ij × x_i)
  public func calculateNodeActivation(
    state : ConnectivityMatrixState,
    nodeIdx : Nat,
    inputActivations : [Nat]
  ) : Nat {
    if (nodeIdx >= TOTAL_NODES or inputActivations.size() < TOTAL_NODES) {
      return 0;
    };
    
    var weightedSum : Int = 0;
    
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      let weight = getWeight(state, i, nodeIdx);
      weightedSum += weight * Int.fromNat(inputActivations[i]) / 1000;
    };
    
    // Apply sigmoid-like activation function
    // σ(x) ≈ 500 + x / (2 + |x|/500) for x in [-1000, 1000]
    let activation = 500 + weightedSum * 1000 / (2000 + Int.abs(weightedSum));
    
    // Clamp to [0, 1000]
    if (activation < 0) { 0 }
    else if (activation > 1000) { 1000 }
    else { Int.abs(activation) }
  };
  
  /// Propagate signals through entire network
  public func propagateSignals(
    state : ConnectivityMatrixState,
    inputActivations : [Nat]
  ) : [Nat] {
    Array.tabulate<Nat>(TOTAL_NODES, func (j : Nat) : Nat {
      calculateNodeActivation(state, j, inputActivations)
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONNECTIVITY ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate connectivity density for a substrate region
  public func calculateConnectivityDensity(
    state : ConnectivityMatrixState,
    mask : [Bool]
  ) : Nat {
    var connected : Nat = 0;
    var total : Nat = 0;
    
    for (i in Iter.range(0, mask.size() - 1)) {
      if (mask[i]) {
        total += 1;
        if (state.weightMatrix[i] != 0) {
          connected += 1;
        };
      };
    };
    
    if (total == 0) { return 0; };
    connected * 1000 / total
  };
  
  /// Get substrate-to-substrate connectivity matrix
  public func getSubstrateConnectivity(state : ConnectivityMatrixState) : [[Nat]] {
    let substrates = [#Brain, #Quantum, #Organ, #Metal];
    
    Array.tabulate<[Nat]>(4, func (i : Nat) : [Nat] {
      Array.tabulate<Nat>(4, func (j : Nat) : Nat {
        var totalWeight : Int = 0;
        var count : Nat = 0;
        
        let startI = getSubstrateStartIndex(substrates[i]);
        let sizeI = getSubstrateSize(substrates[i]);
        let startJ = getSubstrateStartIndex(substrates[j]);
        let sizeJ = getSubstrateSize(substrates[j]);
        
        for (si in Iter.range(0, sizeI - 1)) {
          for (sj in Iter.range(0, sizeJ - 1)) {
            let weight = getWeight(state, startI + si, startJ + sj);
            if (weight != 0) {
              totalWeight += weight;
              count += 1;
            };
          };
        };
        
        if (count == 0) { 0 } else { Int.abs(totalWeight / Int.fromNat(count)) }
      })
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateStatistics(state : ConnectivityMatrixState) : () {
    var totalWeight : Int = 0;
    var totalWeightSq : Int = 0;
    var excitatory : Nat = 0;
    var inhibitory : Nat = 0;
    var active : Nat = 0;
    
    for (synapse in state.synapses.vals()) {
      if (synapse.weight != 0) {
        active += 1;
        totalWeight += synapse.weight;
        totalWeightSq += synapse.weight * synapse.weight / 1000;
        
        switch (synapse.synapseType) {
          case (#Excitatory) { excitatory += 1; };
          case (#Inhibitory) { inhibitory += 1; };
          case (_) {};
        };
      };
    };
    
    state.totalExcitatory := excitatory;
    state.totalInhibitory := inhibitory;
    state.activeConnections := active;
    
    if (active > 0) {
      state.averageWeight := totalWeight / Int.fromNat(active);
      let avgSq = totalWeightSq / Int.fromNat(active);
      let avg = state.averageWeight;
      state.weightVariance := Int.abs(avgSq - avg * avg / 1000);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(
    state : ConnectivityMatrixState,
    activations : [Nat],
    learningRate : Nat,
    currentBeat : Nat
  ) : () {
    // Apply global Hebbian learning
    applyGlobalHebbianLearning(state, activations, learningRate, currentBeat);
    
    // Update statistics periodically
    if (currentBeat % 10 == 0) {
      updateStatistics(state);
    };
    
    state.lastUpdateBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getConnectivitySummary(state : ConnectivityMatrixState) : {
    totalConnections : Nat;
    activeConnections : Nat;
    excitatory : Nat;
    inhibitory : Nat;
    averageWeight : Int;
    weightVariance : Nat;
    learningEvents : Nat;
    intraBrainDensity : Nat;
    brainQuantumDensity : Nat;
    brainOrganDensity : Nat;
  } {
    {
      totalConnections = state.totalConnections;
      activeConnections = state.activeConnections;
      excitatory = state.totalExcitatory;
      inhibitory = state.totalInhibitory;
      averageWeight = state.averageWeight;
      weightVariance = state.weightVariance;
      learningEvents = state.totalLearningEvents;
      intraBrainDensity = calculateConnectivityDensity(state, state.intraBrainMask);
      brainQuantumDensity = calculateConnectivityDensity(state, state.brainQuantumMask);
      brainOrganDensity = calculateConnectivityDensity(state, state.brainOrganMask);
    }
  };

}
