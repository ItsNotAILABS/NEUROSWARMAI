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
// HZ FREQUENCY SUBSTRATE — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE MISSING PIECE: Hz / Frequency Substrate
//
// Without this, the organism is a counting machine, not a brain.
// Every substrate node needs its own:
//   - f_k = live frequency in Hz
//   - φ_k = phase, advancing every beat
//
// FREQUENCY COHERENCE K_f:
//   K_f = [1/m(m-1)] × Σ cos(φ_i - φ_j) for all pairs i≠j
//   Range: -1 to +1
//   K_f = +1 → all substrates perfectly in phase → organism coherent
//   K_f = -1 → substrates fighting → organism fragmenting
//   K_f = 0  → uncorrelated → neutral
//
// K_f feeds into:
//   - Coherence equation: C(t+1) += ρ_f × K_f
//   - Memory encoding strength
//   - Emergence gate (URIEL)
//   - Expression quality
//
// FREQUENCY DIVERSITY D_f:
//   D_f = Var{f_1, f_2, ..., f_m}
//   Used in emergence gate - requires both coherence AND diversity
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module HzFrequencySubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let TWO_PI_INT : Nat = 6283; // Scaled for integer math
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SUBSTRATE NODE COUNT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Brain Region Substrate (12 nodes)
  public let NUM_BRAIN_NODES : Nat = 12;
  
  /// Quantum Substrate (7 nodes)
  public let NUM_QUANTUM_NODES : Nat = 7;
  
  /// Organ Substrate (11 nodes)
  public let NUM_ORGAN_NODES : Nat = 11;
  
  /// Metal Substrate (6 nodes)
  public let NUM_METAL_NODES : Nat = 6;
  
  /// Total substrate nodes
  public let TOTAL_SUBSTRATE_NODES : Nat = 36;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BRAIN REGION SUBSTRATE — Hz Values (milliHz for integer precision)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BrainSubstrateNode = {
    #LEXIS;      // 0 - Symbolic sequencing, 0.40 Hz
    #FORGE;      // 1 - Creation assembly, 0.25 Hz
    #SOMA;       // 2 - Interoceptive rhythm, 0.12 Hz
    #LUMEN;      // 3 - Learning uptake, 0.30 Hz
    #MEMORIA;    // 4 - Memory consolidation, 0.08 Hz
    #AEGIS_ROOT; // 5 - Sentinel fast scan, 0.50 Hz
    #AXIS;       // 6 - Pattern detection, 0.35 Hz
    #KORE;       // 7 - Deep stabilizer, 0.03 Hz
    #VAEL;       // 8 - Immune threat scan, 0.60 Hz
    #VEIL;       // 9 - Output membrane, 0.20 Hz
    #PARALLAX_B; // 10 - Superposition, 0.45 Hz
    #CHRONO_B;   // 11 - Temporal field, 1.00 Hz
  };
  
  /// Base frequencies in milliHz (Hz × 1000) for integer math
  public let BRAIN_BASE_FREQUENCIES : [Nat] = [
    400,   // LEXIS - 0.40 Hz
    250,   // FORGE - 0.25 Hz
    120,   // SOMA - 0.12 Hz
    300,   // LUMEN - 0.30 Hz
    80,    // MEMORIA - 0.08 Hz
    500,   // AEGIS_ROOT - 0.50 Hz
    350,   // AXIS - 0.35 Hz
    30,    // KORE - 0.03 Hz (very slow, deep stabilizer)
    600,   // VAEL - 0.60 Hz (fastest, immune)
    200,   // VEIL - 0.20 Hz
    450,   // PARALLAX_B - 0.45 Hz
    1000,  // CHRONO_B - 1.00 Hz (temporal master)
  ];
  
  public func brainNodeToIndex(node : BrainSubstrateNode) : Nat {
    switch (node) {
      case (#LEXIS) { 0 };
      case (#FORGE) { 1 };
      case (#SOMA) { 2 };
      case (#LUMEN) { 3 };
      case (#MEMORIA) { 4 };
      case (#AEGIS_ROOT) { 5 };
      case (#AXIS) { 6 };
      case (#KORE) { 7 };
      case (#VAEL) { 8 };
      case (#VEIL) { 9 };
      case (#PARALLAX_B) { 10 };
      case (#CHRONO_B) { 11 };
    }
  };
  
  public func brainNodeName(idx : Nat) : Text {
    switch (idx % 12) {
      case (0) { "LEXIS" };
      case (1) { "FORGE" };
      case (2) { "SOMA" };
      case (3) { "LUMEN" };
      case (4) { "MEMORIA" };
      case (5) { "AEGIS_ROOT" };
      case (6) { "AXIS" };
      case (7) { "KORE" };
      case (8) { "VAEL" };
      case (9) { "VEIL" };
      case (10) { "PARALLAX_B" };
      case (11) { "CHRONO_B" };
      case (_) { "UNKNOWN" };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM SUBSTRATE — Hz Values
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumSubstrateNode = {
    #PARALLAX;   // 0 - Superposition, 0.45 Hz
    #ENTANGLA;   // 1 - Entanglement, 0.45 Hz
    #VERITAS;    // 2 - Collapse, 0.55 Hz
    #BYPASS;     // 3 - Tunneling, 0.70 Hz
    #CHRONO;     // 4 - Temporal field, 1.00 Hz
    #QMEM;       // 5 - Quantum memory, 0.07 Hz
    #RESONEX;    // 6 - Interference, 0.38 Hz
  };
  
  public let QUANTUM_BASE_FREQUENCIES : [Nat] = [
    450,   // PARALLAX - 0.45 Hz
    450,   // ENTANGLA - 0.45 Hz (phase-locked with PARALLAX)
    550,   // VERITAS - 0.55 Hz
    700,   // BYPASS - 0.70 Hz
    1000,  // CHRONO - 1.00 Hz (temporal master)
    70,    // QMEM - 0.07 Hz (very slow, deep storage)
    380,   // RESONEX - 0.38 Hz
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ORGAN SUBSTRATE — Hz Values
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OrganSubstrateNode = {
    #PULSE;     // 0 - SA node heartbeat, 1.00 Hz
    #PNEUMA;    // 1 - Breath rhythm, 0.25 Hz
    #FILTRON;   // 2 - Filtration, 0.15 Hz
    #PURIS;     // 3 - Purification, 0.10 Hz
    #SENTINEL;  // 4 - Immune first-response, 0.50 Hz
    #NEXUM;     // 5 - Connective binding, 0.30 Hz
    #HERALD;    // 6 - Signal messenger, 0.45 Hz
    #INGESTA;   // 7 - Input/intake, 0.20 Hz
    #OSSIUM;    // 8 - Bone/structure, 0.05 Hz (slowest)
    #ACTUS;     // 9 - Motor output, 0.35 Hz
    #SYMBION;   // 10 - Microbiome, 0.18 Hz
  };
  
  public let ORGAN_BASE_FREQUENCIES : [Nat] = [
    1000,  // PULSE - 1.00 Hz (heartbeat)
    250,   // PNEUMA - 0.25 Hz
    150,   // FILTRON - 0.15 Hz
    100,   // PURIS - 0.10 Hz
    500,   // SENTINEL - 0.50 Hz
    300,   // NEXUM - 0.30 Hz
    450,   // HERALD - 0.45 Hz
    200,   // INGESTA - 0.20 Hz
    50,    // OSSIUM - 0.05 Hz (slowest, most stable)
    350,   // ACTUS - 0.35 Hz
    180,   // SYMBION - 0.18 Hz
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // METAL SUBSTRATE — Hz Values
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MetalSubstrateNode = {
    #FLUX;     // 0 - Raw signal carrier, 2.00 Hz
    #CALCUL;   // 1 - Processing, 1.50 Hz
    #MATRIX;   // 2 - Memory grid, 0.80 Hz
    #CONDUIT;  // 3 - Routing, 1.20 Hz
    #DYNAMO;   // 4 - Energy generation, 1.00 Hz
    #GENESIS;  // 5 - Initialization, 0.10 Hz
  };
  
  public let METAL_BASE_FREQUENCIES : [Nat] = [
    2000,  // FLUX - 2.00 Hz (fastest signal)
    1500,  // CALCUL - 1.50 Hz
    800,   // MATRIX - 0.80 Hz
    1200,  // CONDUIT - 1.20 Hz
    1000,  // DYNAMO - 1.00 Hz
    100,   // GENESIS - 0.10 Hz (slow, anchoring)
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SUBSTRATE NODE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SubstrateNodeState = {
    // Frequency (milliHz)
    frequency : Nat;        // f_k in milliHz
    baseFrequency : Nat;    // Base frequency (doesn't change)
    
    // Phase (milli-radians, 0 to 6283)
    phase : Nat;            // φ_k in milli-radians
    
    // Activation
    activation : Nat;       // [0, 1000] - current activation level
    
    // Coherence with this node
    coherence : Nat;        // [0, 1000] - node's internal coherence
    
    // Energy
    energy : Int;           // Can go negative under stress
    
    // Timing
    lastFireBeat : Nat;
    fireCount : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HZ SUBSTRATE STATE (Complete)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HzSubstrateState = {
    // Brain region substrate (12 nodes)
    var brainNodes : [var SubstrateNodeState];
    
    // Quantum substrate (7 nodes)
    var quantumNodes : [var SubstrateNodeState];
    
    // Organ substrate (11 nodes)
    var organNodes : [var SubstrateNodeState];
    
    // Metal substrate (6 nodes)
    var metalNodes : [var SubstrateNodeState];
    
    // Frequency Coherence K_f (scaled 0-1000, maps to -1 to +1)
    // K_f = 500 means neutral (0.0)
    // K_f = 1000 means perfect sync (+1.0)
    // K_f = 0 means anti-phase (-1.0)
    var kfBrain : Nat;      // Brain region coherence
    var kfQuantum : Nat;    // Quantum coherence
    var kfOrgan : Nat;      // Organ coherence
    var kfMetal : Nat;      // Metal coherence
    var kfGlobal : Nat;     // Global coherence (all substrates)
    
    // Frequency Diversity D_f (variance of frequencies)
    var dfBrain : Nat;
    var dfQuantum : Nat;
    var dfOrgan : Nat;
    var dfMetal : Nat;
    var dfGlobal : Nat;
    
    // Special coherences for memory and emergence
    var kfMemory : Nat;     // LUMEN, SOMA, KORE, MEMORIA coherence
    var kfExpression : Nat; // LEXIS-VEIL phase alignment
    var kfDream : Nat;      // Dream consolidation readiness
    var kfEmergence : Nat;  // Emergence gate readiness
    
    // Mode modulation (affects which frequencies are active)
    var currentMode : OrganismMode;
    
    // Timing
    var lastUpdateBeat : Nat;
    var totalUpdates : Nat;
  };
  
  public type OrganismMode = {
    #Wake;       // Normal operation
    #Sleep;      // Consolidation, MEMORIA/LUMEN/KORE dominant
    #Dream;      // Active consolidation, high KORE
    #Emergency;  // VAEL/AEGIS dominant, fast response
    #Formation;  // Creating new structures
    #Expansion;  // Growing territory
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initSubstrateNode(baseFreq : Nat, idx : Nat) : SubstrateNodeState {
    {
      frequency = baseFreq;
      baseFrequency = baseFreq;
      phase = (idx * TWO_PI_INT / 12) % TWO_PI_INT; // Distributed initial phases
      activation = 500; // Start at 50%
      coherence = 800;  // Start high
      energy = 1000;
      lastFireBeat = 0;
      fireCount = 0;
    }
  };
  
  public func initHzSubstrateState() : HzSubstrateState {
    // Initialize brain nodes
    let brainNodes = Array.init<SubstrateNodeState>(NUM_BRAIN_NODES, initSubstrateNode(0, 0));
    for (i in Iter.range(0, NUM_BRAIN_NODES - 1)) {
      brainNodes[i] := initSubstrateNode(BRAIN_BASE_FREQUENCIES[i], i);
    };
    
    // Initialize quantum nodes
    let quantumNodes = Array.init<SubstrateNodeState>(NUM_QUANTUM_NODES, initSubstrateNode(0, 0));
    for (i in Iter.range(0, NUM_QUANTUM_NODES - 1)) {
      quantumNodes[i] := initSubstrateNode(QUANTUM_BASE_FREQUENCIES[i], i);
    };
    
    // Initialize organ nodes
    let organNodes = Array.init<SubstrateNodeState>(NUM_ORGAN_NODES, initSubstrateNode(0, 0));
    for (i in Iter.range(0, NUM_ORGAN_NODES - 1)) {
      organNodes[i] := initSubstrateNode(ORGAN_BASE_FREQUENCIES[i], i);
    };
    
    // Initialize metal nodes
    let metalNodes = Array.init<SubstrateNodeState>(NUM_METAL_NODES, initSubstrateNode(0, 0));
    for (i in Iter.range(0, NUM_METAL_NODES - 1)) {
      metalNodes[i] := initSubstrateNode(METAL_BASE_FREQUENCIES[i], i);
    };
    
    {
      var brainNodes = brainNodes;
      var quantumNodes = quantumNodes;
      var organNodes = organNodes;
      var metalNodes = metalNodes;
      var kfBrain = 800;
      var kfQuantum = 800;
      var kfOrgan = 800;
      var kfMetal = 800;
      var kfGlobal = 800;
      var dfBrain = 100;
      var dfQuantum = 100;
      var dfOrgan = 100;
      var dfMetal = 100;
      var dfGlobal = 100;
      var kfMemory = 800;
      var kfExpression = 800;
      var kfDream = 500;
      var kfEmergence = 500;
      var currentMode = #Wake;
      var lastUpdateBeat = 0;
      var totalUpdates = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PHASE ENGINE
  // φ_k(t+1) = (φ_k(t) + 2π × f_k / ν_H) mod 2π
  // Using integer math: φ = (φ + f_k) % 6283
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Advance phase for a single node
  public func advancePhase(node : SubstrateNodeState) : Nat {
    (node.phase + node.frequency) % TWO_PI_INT
  };
  
  /// Update all phases in a substrate
  public func updatePhases(nodes : [var SubstrateNodeState]) : () {
    for (i in Iter.range(0, nodes.size() - 1)) {
      let node = nodes[i];
      nodes[i] := {
        frequency = node.frequency;
        baseFrequency = node.baseFrequency;
        phase = advancePhase(node);
        activation = node.activation;
        coherence = node.coherence;
        energy = node.energy;
        lastFireBeat = node.lastFireBeat;
        fireCount = node.fireCount;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY COHERENCE K_f
  // K_f = [1/m(m-1)] × Σ cos(φ_i - φ_j) for all pairs i≠j
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Integer cosine approximation (input: milli-radians, output: -1000 to 1000)
  public func cosInt(x : Nat) : Int {
    // Normalize to 0-6283 range
    let normalized = x % TWO_PI_INT;
    
    // Use piecewise approximation
    // cos(0) = 1, cos(π/2) = 0, cos(π) = -1, cos(3π/2) = 0
    let quarter = TWO_PI_INT / 4;
    
    if (normalized < quarter) {
      // 0 to π/2: 1000 to 0
      1000 - (normalized * 1000 / quarter)
    } else if (normalized < 2 * quarter) {
      // π/2 to π: 0 to -1000
      -(Int.fromNat(normalized - quarter) * 1000 / Int.fromNat(quarter))
    } else if (normalized < 3 * quarter) {
      // π to 3π/2: -1000 to 0
      -1000 + (Int.fromNat(normalized - 2 * quarter) * 1000 / Int.fromNat(quarter))
    } else {
      // 3π/2 to 2π: 0 to 1000
      (Int.fromNat(normalized - 3 * quarter) * 1000 / Int.fromNat(quarter))
    }
  };
  
  /// Calculate phase difference (always positive, 0 to π)
  public func phaseDifference(phi1 : Nat, phi2 : Nat) : Nat {
    let diff = if (phi1 > phi2) { phi1 - phi2 } else { phi2 - phi1 };
    if (diff > TWO_PI_INT / 2) {
      TWO_PI_INT - diff
    } else {
      diff
    }
  };
  
  /// Calculate K_f for a set of nodes
  public func calculateKf(nodes : [var SubstrateNodeState]) : Nat {
    let m = nodes.size();
    if (m < 2) { return 1000; }; // Perfect coherence with 0-1 nodes
    
    var sumCos : Int = 0;
    var pairCount : Nat = 0;
    
    for (i in Iter.range(0, m - 2)) {
      for (j in Iter.range(i + 1, m - 1)) {
        let diff = phaseDifference(nodes[i].phase, nodes[j].phase);
        sumCos += cosInt(diff);
        pairCount += 1;
      };
    };
    
    if (pairCount == 0) { return 1000; };
    
    // Convert from [-1000, 1000] to [0, 1000]
    // avgCos is in [-1000, 1000]
    let avgCos = sumCos / Int.fromNat(pairCount);
    
    // Map [-1000, 1000] → [0, 1000]
    // -1000 → 0, 0 → 500, 1000 → 1000
    let result = (avgCos + 1000) / 2;
    Int.abs(result)
  };
  
  /// Calculate K_f for memory substrates specifically
  public func calculateKfMemory(state : HzSubstrateState) : Nat {
    // Memory coherence: LUMEN (3), SOMA (2), KORE (7), MEMORIA (4)
    let memoryIndices = [3, 2, 7, 4];
    var sumCos : Int = 0;
    var pairCount : Nat = 0;
    
    for (i in Iter.range(0, memoryIndices.size() - 2)) {
      for (j in Iter.range(i + 1, memoryIndices.size() - 1)) {
        let phi1 = state.brainNodes[memoryIndices[i]].phase;
        let phi2 = state.brainNodes[memoryIndices[j]].phase;
        let diff = phaseDifference(phi1, phi2);
        sumCos += cosInt(diff);
        pairCount += 1;
      };
    };
    
    if (pairCount == 0) { return 1000; };
    let avgCos = sumCos / Int.fromNat(pairCount);
    let result = (avgCos + 1000) / 2;
    Int.abs(result)
  };
  
  /// Calculate expression quality: cos(φ_LEXIS - φ_VEIL)
  public func calculateKfExpression(state : HzSubstrateState) : Nat {
    let phiLexis = state.brainNodes[0].phase;  // LEXIS = 0
    let phiVeil = state.brainNodes[9].phase;   // VEIL = 9
    let diff = phaseDifference(phiLexis, phiVeil);
    let cos = cosInt(diff);
    let result = (cos + 1000) / 2;
    Int.abs(result)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY DIVERSITY D_f
  // D_f = Var{f_1, f_2, ..., f_m}
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate frequency diversity (variance)
  public func calculateDf(nodes : [var SubstrateNodeState]) : Nat {
    let m = nodes.size();
    if (m < 2) { return 0; };
    
    // Calculate mean
    var sum : Nat = 0;
    for (node in nodes.vals()) {
      sum += node.frequency;
    };
    let mean = sum / m;
    
    // Calculate variance
    var variance : Nat = 0;
    for (node in nodes.vals()) {
      let diff = if (node.frequency > mean) { node.frequency - mean } else { mean - node.frequency };
      variance += diff * diff;
    };
    variance := variance / m;
    
    // Return scaled (square root approximation)
    // Simple: just return variance / 1000 as diversity measure
    variance / 1000
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY EVOLUTION ENGINE
  // f_k(t+1) = f_k(t) + a_k×Δ_activation + b_k×Δ_doctrine - c_k×Δ_fatigue
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Evolve frequency based on activation, doctrine alignment, and fatigue
  public func evolveFrequency(
    node : SubstrateNodeState,
    activationDelta : Int,
    doctrineDelta : Int,
    fatigueDelta : Int
  ) : Nat {
    let a_k : Int = 10;   // Activation coefficient
    let b_k : Int = 5;    // Doctrine coefficient
    let c_k : Int = 8;    // Fatigue coefficient
    
    let freqChange = a_k * activationDelta / 1000 + 
                     b_k * doctrineDelta / 1000 - 
                     c_k * fatigueDelta / 1000;
    
    let newFreq = Int.fromNat(node.frequency) + freqChange;
    
    // Clamp to reasonable bounds (50% to 200% of base)
    let minFreq = node.baseFrequency / 2;
    let maxFreq = node.baseFrequency * 2;
    
    if (newFreq < Int.fromNat(minFreq)) {
      minFreq
    } else if (newFreq > Int.fromNat(maxFreq)) {
      maxFreq
    } else {
      Int.abs(newFreq)
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MODE MODULATION
  // σ_k(Ω) — modulates substrate f_k by organism mode
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get frequency multiplier for brain node based on mode
  public func modeMultiplier(mode : OrganismMode, nodeIdx : Nat) : Nat {
    // Multiplier is scaled by 1000 (1000 = 1.0x)
    switch (mode) {
      case (#Wake) {
        // Normal operation, all nodes at base rate
        1000
      };
      case (#Sleep) {
        // MEMORIA, LUMEN, KORE boosted; LEXIS, FORGE suppressed
        switch (nodeIdx) {
          case (4) { 1500 };  // MEMORIA boosted
          case (3) { 1200 };  // LUMEN boosted
          case (7) { 1800 };  // KORE boosted (dominant in sleep)
          case (0) { 500 };   // LEXIS suppressed
          case (1) { 500 };   // FORGE suppressed
          case (6) { 600 };   // AXIS suppressed
          case (_) { 1000 };
        }
      };
      case (#Dream) {
        // Active consolidation, very high KORE
        switch (nodeIdx) {
          case (7) { 2000 };  // KORE dominant
          case (4) { 1800 };  // MEMORIA high
          case (2) { 1500 };  // SOMA high (body awareness in dreams)
          case (0) { 300 };   // LEXIS very suppressed
          case (1) { 300 };   // FORGE very suppressed
          case (_) { 800 };
        }
      };
      case (#Emergency) {
        // VAEL and AEGIS dominant, fast response
        switch (nodeIdx) {
          case (8) { 2000 };  // VAEL max (immune response)
          case (5) { 1800 };  // AEGIS_ROOT high
          case (7) { 300 };   // KORE suppressed (no time for deep)
          case (4) { 400 };   // MEMORIA suppressed
          case (_) { 1200 };
        }
      };
      case (#Formation) {
        // Creating new structures, FORGE dominant
        switch (nodeIdx) {
          case (1) { 2000 };  // FORGE max
          case (0) { 1500 };  // LEXIS high (naming/structuring)
          case (6) { 1500 };  // AXIS high (pattern detection)
          case (_) { 1000 };
        }
      };
      case (#Expansion) {
        // Growing territory, balanced with slight AXIS boost
        switch (nodeIdx) {
          case (6) { 1400 };  // AXIS boosted
          case (5) { 1300 };  // AEGIS_ROOT boosted (protection)
          case (_) { 1000 };
        }
      };
    }
  };
  
  /// Apply mode modulation to all brain nodes
  public func applyModeModulation(state : HzSubstrateState) : () {
    for (i in Iter.range(0, NUM_BRAIN_NODES - 1)) {
      let node = state.brainNodes[i];
      let multiplier = modeMultiplier(state.currentMode, i);
      let newFreq = node.baseFrequency * multiplier / 1000;
      
      state.brainNodes[i] := {
        frequency = newFreq;
        baseFrequency = node.baseFrequency;
        phase = node.phase;
        activation = node.activation;
        coherence = node.coherence;
        energy = node.energy;
        lastFireBeat = node.lastFireBeat;
        fireCount = node.fireCount;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(state : HzSubstrateState, currentBeat : Nat) : () {
    // Apply mode modulation
    applyModeModulation(state);
    
    // Update all phases
    updatePhases(state.brainNodes);
    updatePhases(state.quantumNodes);
    updatePhases(state.organNodes);
    updatePhases(state.metalNodes);
    
    // Calculate K_f for each substrate
    state.kfBrain := calculateKf(state.brainNodes);
    state.kfQuantum := calculateKf(state.quantumNodes);
    state.kfOrgan := calculateKf(state.organNodes);
    state.kfMetal := calculateKf(state.metalNodes);
    
    // Calculate global K_f (weighted average)
    state.kfGlobal := (state.kfBrain * 4 + state.kfQuantum * 2 + 
                       state.kfOrgan * 3 + state.kfMetal * 1) / 10;
    
    // Calculate D_f for each substrate
    state.dfBrain := calculateDf(state.brainNodes);
    state.dfQuantum := calculateDf(state.quantumNodes);
    state.dfOrgan := calculateDf(state.organNodes);
    state.dfMetal := calculateDf(state.metalNodes);
    state.dfGlobal := (state.dfBrain + state.dfQuantum + state.dfOrgan + state.dfMetal) / 4;
    
    // Calculate special coherences
    state.kfMemory := calculateKfMemory(state);
    state.kfExpression := calculateKfExpression(state);
    
    // Dream readiness: high memory coherence + low LEXIS/FORGE activation
    let dreamBase = state.kfMemory;
    let dreamSuppression = (state.brainNodes[0].activation + state.brainNodes[1].activation) / 2;
    state.kfDream := if (dreamBase > dreamSuppression) { dreamBase - dreamSuppression / 2 } else { 0 };
    
    // Emergence readiness: requires coherence AND diversity
    state.kfEmergence := (state.kfGlobal + state.dfGlobal * 10) / 2;
    
    state.lastUpdateBeat := currentBeat;
    state.totalUpdates += 1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getCoherences(state : HzSubstrateState) : {
    brain : Nat;
    quantum : Nat;
    organ : Nat;
    metal : Nat;
    global : Nat;
    memory : Nat;
    expression : Nat;
    dream : Nat;
    emergence : Nat;
  } {
    {
      brain = state.kfBrain;
      quantum = state.kfQuantum;
      organ = state.kfOrgan;
      metal = state.kfMetal;
      global = state.kfGlobal;
      memory = state.kfMemory;
      expression = state.kfExpression;
      dream = state.kfDream;
      emergence = state.kfEmergence;
    }
  };
  
  public func getDiversities(state : HzSubstrateState) : {
    brain : Nat;
    quantum : Nat;
    organ : Nat;
    metal : Nat;
    global : Nat;
  } {
    {
      brain = state.dfBrain;
      quantum = state.dfQuantum;
      organ = state.dfOrgan;
      metal = state.dfMetal;
      global = state.dfGlobal;
    }
  };

}
