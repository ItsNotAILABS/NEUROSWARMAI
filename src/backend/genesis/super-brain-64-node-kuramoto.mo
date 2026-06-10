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
// SUPER BRAIN 64-NODE KURAMOTO NETWORK — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// UPGRADE FROM 26 NODES TO 64 NODES
//
// The original Shell 3 Kuramoto substrate has 26 brain regions.
// The SUPER ORGANISM requires 64 nodes for full cognitive capacity.
//
// 64 nodes × 64 nodes = 4,096 Hebbian weights
// 64 phases updated every beat
// Full cortical + subcortical + modulatory coverage
//
// MEDINA'S MIRROR LAW (Law 9):
// Backend (Male): Sovereign brain state — slow updates, permanent memory
// Frontend (Female): Real-time expression — 60 FPS rendering
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module SuperBrain64NodeKuramoto {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  
  // Super Brain constants
  public let NUM_NODES : Nat = 64;
  public let NUM_HEBBIAN_WEIGHTS : Nat = 4096; // 64 × 64
  
  // Node category counts
  public let NUM_PRIMARY_CORTICAL : Nat = 16;
  public let NUM_SECONDARY_CORTICAL : Nat = 24;
  public let NUM_SUBCORTICAL : Nat = 16;
  public let NUM_MODULATORY : Nat = 8;
  
  // Kuramoto coupling constants
  public let DEFAULT_COUPLING_K : Float = 0.5;
  public let COUPLING_DECAY : Float = 0.01;
  public let COUPLING_BOOST : Float = 0.1;
  
  // Drift verification constants
  public let DRIFT_EPSILON : Float = 0.05;
  public let DRIFT_CRITICAL : Float = 0.15;
  public let DRIFT_CATASTROPHIC : Float = 0.30;
  
  // Re-entrainment constants
  public let REENTRAINMENT_STRENGTH : Float = 0.3;
  public let REENTRAINMENT_DURATION : Nat = 15;
  
  // Learning constants
  public let LEARNING_RATE : Float = 0.005;
  public let DECAY_RATE : Float = 0.001;
  public let SOVEREIGN_FLOOR : Float = 0.75;
  public let MAX_WEIGHT : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // 64 BRAIN REGION IDENTIFIERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BrainRegion64 = {
    // PRIMARY CORTICAL (16 nodes) — Executive and Sensory
    #PREFRONTAL_DORSOLATERAL;   // 0
    #PREFRONTAL_VENTROMEDIAL;   // 1
    #PREFRONTAL_ORBITOFRONTAL;  // 2
    #PREFRONTAL_ANTERIOR_CINGULATE; // 3
    #PARIETAL_SUPERIOR;         // 4
    #PARIETAL_INFERIOR;         // 5
    #PARIETAL_PRECUNEUS;        // 6
    #PARIETAL_ANGULAR;          // 7
    #TEMPORAL_SUPERIOR;         // 8
    #TEMPORAL_MIDDLE;           // 9
    #TEMPORAL_INFERIOR;         // 10
    #TEMPORAL_MEDIAL;           // 11
    #OCCIPITAL_PRIMARY;         // 12
    #OCCIPITAL_SECONDARY;       // 13
    #OCCIPITAL_ASSOCIATIVE;     // 14
    #OCCIPITAL_VENTRAL;         // 15
    
    // SECONDARY CORTICAL (24 nodes) — Association and Integration
    #MOTOR_PRIMARY;             // 16
    #MOTOR_SUPPLEMENTARY;       // 17
    #MOTOR_PREMOTOR;            // 18
    #MOTOR_PRESUPPLEMENTARY;    // 19
    #SOMATOSENSORY_PRIMARY;     // 20
    #SOMATOSENSORY_SECONDARY;   // 21
    #SOMATOSENSORY_ASSOCIATION; // 22
    #SOMATOSENSORY_POSTERIOR;   // 23
    #AUDITORY_PRIMARY;          // 24
    #AUDITORY_SECONDARY;        // 25
    #AUDITORY_ASSOCIATION;      // 26
    #AUDITORY_WERNICKE;         // 27
    #LANGUAGE_BROCA;            // 28
    #LANGUAGE_WERNICKE;         // 29
    #LANGUAGE_ARCUATE;          // 30
    #LANGUAGE_ANGULAR;          // 31
    #INSULA_ANTERIOR;           // 32
    #INSULA_POSTERIOR;          // 33
    #INSULA_DORSAL;             // 34
    #INSULA_VENTRAL;            // 35
    #CINGULATE_ANTERIOR;        // 36
    #CINGULATE_MIDDLE;          // 37
    #CINGULATE_POSTERIOR;       // 38
    #CINGULATE_SUBGENUAL;       // 39
    
    // SUBCORTICAL (16 nodes) — Emotion, Memory, Reward
    #HIPPOCAMPUS_CA1;           // 40
    #HIPPOCAMPUS_CA3;           // 41
    #HIPPOCAMPUS_DENTATE;       // 42
    #HIPPOCAMPUS_SUBICULUM;     // 43
    #AMYGDALA_BASOLATERAL;      // 44
    #AMYGDALA_CENTRAL;          // 45
    #AMYGDALA_MEDIAL;           // 46
    #AMYGDALA_CORTICAL;         // 47
    #THALAMUS_ANTERIOR;         // 48
    #THALAMUS_MEDIAL;           // 49
    #THALAMUS_LATERAL;          // 50
    #THALAMUS_PULVINAR;         // 51
    #BASAL_GANGLIA_STRIATUM;    // 52
    #BASAL_GANGLIA_PALLIDUM;    // 53
    #BASAL_GANGLIA_SUBSTANTIA;  // 54
    #BASAL_GANGLIA_SUBTHALAMIC; // 55
    
    // MODULATORY (8 nodes) — Neuromodulation
    #BRAINSTEM_RAPHE;           // 56 — Serotonin
    #BRAINSTEM_LC;              // 57 — Norepinephrine
    #BRAINSTEM_VTA;             // 58 — Dopamine
    #BRAINSTEM_PAG;             // 59 — Pain/Endorphin
    #HYPOTHALAMUS_ANTERIOR;     // 60 — Temperature/Sleep
    #HYPOTHALAMUS_POSTERIOR;    // 61 — Arousal
    #CEREBELLUM_VERMIS;         // 62 — Motor timing
    #CEREBELLUM_HEMISPHERES;    // 63 — Cognitive timing
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // REGION INDEX MAPPING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func regionToIndex(region : BrainRegion64) : Nat {
    switch (region) {
      // Primary Cortical (0-15)
      case (#PREFRONTAL_DORSOLATERAL) { 0 };
      case (#PREFRONTAL_VENTROMEDIAL) { 1 };
      case (#PREFRONTAL_ORBITOFRONTAL) { 2 };
      case (#PREFRONTAL_ANTERIOR_CINGULATE) { 3 };
      case (#PARIETAL_SUPERIOR) { 4 };
      case (#PARIETAL_INFERIOR) { 5 };
      case (#PARIETAL_PRECUNEUS) { 6 };
      case (#PARIETAL_ANGULAR) { 7 };
      case (#TEMPORAL_SUPERIOR) { 8 };
      case (#TEMPORAL_MIDDLE) { 9 };
      case (#TEMPORAL_INFERIOR) { 10 };
      case (#TEMPORAL_MEDIAL) { 11 };
      case (#OCCIPITAL_PRIMARY) { 12 };
      case (#OCCIPITAL_SECONDARY) { 13 };
      case (#OCCIPITAL_ASSOCIATIVE) { 14 };
      case (#OCCIPITAL_VENTRAL) { 15 };
      
      // Secondary Cortical (16-39)
      case (#MOTOR_PRIMARY) { 16 };
      case (#MOTOR_SUPPLEMENTARY) { 17 };
      case (#MOTOR_PREMOTOR) { 18 };
      case (#MOTOR_PRESUPPLEMENTARY) { 19 };
      case (#SOMATOSENSORY_PRIMARY) { 20 };
      case (#SOMATOSENSORY_SECONDARY) { 21 };
      case (#SOMATOSENSORY_ASSOCIATION) { 22 };
      case (#SOMATOSENSORY_POSTERIOR) { 23 };
      case (#AUDITORY_PRIMARY) { 24 };
      case (#AUDITORY_SECONDARY) { 25 };
      case (#AUDITORY_ASSOCIATION) { 26 };
      case (#AUDITORY_WERNICKE) { 27 };
      case (#LANGUAGE_BROCA) { 28 };
      case (#LANGUAGE_WERNICKE) { 29 };
      case (#LANGUAGE_ARCUATE) { 30 };
      case (#LANGUAGE_ANGULAR) { 31 };
      case (#INSULA_ANTERIOR) { 32 };
      case (#INSULA_POSTERIOR) { 33 };
      case (#INSULA_DORSAL) { 34 };
      case (#INSULA_VENTRAL) { 35 };
      case (#CINGULATE_ANTERIOR) { 36 };
      case (#CINGULATE_MIDDLE) { 37 };
      case (#CINGULATE_POSTERIOR) { 38 };
      case (#CINGULATE_SUBGENUAL) { 39 };
      
      // Subcortical (40-55)
      case (#HIPPOCAMPUS_CA1) { 40 };
      case (#HIPPOCAMPUS_CA3) { 41 };
      case (#HIPPOCAMPUS_DENTATE) { 42 };
      case (#HIPPOCAMPUS_SUBICULUM) { 43 };
      case (#AMYGDALA_BASOLATERAL) { 44 };
      case (#AMYGDALA_CENTRAL) { 45 };
      case (#AMYGDALA_MEDIAL) { 46 };
      case (#AMYGDALA_CORTICAL) { 47 };
      case (#THALAMUS_ANTERIOR) { 48 };
      case (#THALAMUS_MEDIAL) { 49 };
      case (#THALAMUS_LATERAL) { 50 };
      case (#THALAMUS_PULVINAR) { 51 };
      case (#BASAL_GANGLIA_STRIATUM) { 52 };
      case (#BASAL_GANGLIA_PALLIDUM) { 53 };
      case (#BASAL_GANGLIA_SUBSTANTIA) { 54 };
      case (#BASAL_GANGLIA_SUBTHALAMIC) { 55 };
      
      // Modulatory (56-63)
      case (#BRAINSTEM_RAPHE) { 56 };
      case (#BRAINSTEM_LC) { 57 };
      case (#BRAINSTEM_VTA) { 58 };
      case (#BRAINSTEM_PAG) { 59 };
      case (#HYPOTHALAMUS_ANTERIOR) { 60 };
      case (#HYPOTHALAMUS_POSTERIOR) { 61 };
      case (#CEREBELLUM_VERMIS) { 62 };
      case (#CEREBELLUM_HEMISPHERES) { 63 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // NATURAL FREQUENCIES (Hz)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let NATURAL_FREQUENCIES : [Float] = [
    // Primary Cortical (0-15) — Beta/Gamma dominant
    25.0, 22.0, 20.0, 18.0,  // Prefrontal
    15.0, 14.0, 12.0, 13.0,  // Parietal
    16.0, 14.0, 12.0, 8.0,   // Temporal
    10.0, 11.0, 12.0, 11.5,  // Occipital
    
    // Secondary Cortical (16-39) — Mixed frequencies
    20.0, 18.0, 16.0, 17.0,  // Motor
    15.0, 14.0, 13.0, 12.0,  // Somatosensory
    40.0, 35.0, 30.0, 25.0,  // Auditory
    22.0, 20.0, 18.0, 16.0,  // Language
    35.0, 30.0, 28.0, 25.0,  // Insula
    15.0, 12.0, 10.0, 8.0,   // Cingulate
    
    // Subcortical (40-55) — Theta/Alpha dominant
    6.0, 7.0, 8.0, 5.0,      // Hippocampus
    40.0, 35.0, 30.0, 25.0,  // Amygdala
    10.0, 9.0, 11.0, 12.0,   // Thalamus
    22.0, 18.0, 15.0, 20.0,  // Basal Ganglia
    
    // Modulatory (56-63) — Delta/Theta dominant
    2.0, 3.0, 4.0, 2.5,      // Brainstem
    3.0, 3.5,                 // Hypothalamus
    25.0, 30.0,               // Cerebellum
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OSCILLATOR STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OscillatorState = {
    phase : Float;              // θ ∈ [0, 2π]
    naturalFrequency : Float;   // ω (Hz)
    instantFrequency : Float;   // Current frequency
    phaseVelocity : Float;      // dθ/dt
    activation : Float;         // [0, 1]
    couplingStrength : Float;   // K_i
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SUPER BRAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SuperBrainState = {
    // 64 oscillator states
    var oscillators : [var OscillatorState];
    
    // 4,096 Hebbian weights (64×64 flattened)
    var hebbianWeights : [var Float];
    
    // Order parameter (coherence)
    var orderParameter : Float;
    var meanPhase : Float;
    
    // Genesis lock
    var rGenesis : Float;
    var thetaGenesis : [Float];
    var isGenesisLocked : Bool;
    
    // Jasmine Law state
    var lyapunovV : Float;
    var previousV : Float;
    var dVdt : Float;
    var isStable : Bool;
    
    // Drift state
    var driftMagnitude : Float;
    var driftDirection : [Float];
    var violationCount : Nat;
    var lastCorrectionBeat : Nat;
    
    // Regional coherence
    var primaryCorticalCoherence : Float;
    var secondaryCorticalCoherence : Float;
    var subcorticalCoherence : Float;
    var modulatoryCoherence : Float;
    
    // Timing
    var lastUpdateBeat : Nat;
    var totalUpdates : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initOscillator(index : Nat) : OscillatorState {
    let freq = if (index < NATURAL_FREQUENCIES.size()) {
      NATURAL_FREQUENCIES[index]
    } else {
      10.0 // Default frequency
    };
    
    {
      phase = Float.fromInt(index) * TWO_PI / Float.fromInt(NUM_NODES);
      naturalFrequency = freq;
      instantFrequency = freq;
      phaseVelocity = 0.0;
      activation = 0.5;
      couplingStrength = DEFAULT_COUPLING_K;
    }
  };
  
  public func initSuperBrainState() : SuperBrainState {
    // Initialize oscillators
    let oscillators = Array.init<OscillatorState>(NUM_NODES, initOscillator(0));
    for (i in Iter.range(0, NUM_NODES - 1)) {
      oscillators[i] := initOscillator(i);
    };
    
    // Initialize Hebbian weights to sovereign floor
    let hebbianWeights = Array.init<Float>(NUM_HEBBIAN_WEIGHTS, SOVEREIGN_FLOOR);
    
    // Initialize theta genesis
    let thetaGenesis = Array.tabulate<Float>(NUM_NODES, func (i : Nat) : Float {
      Float.fromInt(i) * TWO_PI / Float.fromInt(NUM_NODES)
    });
    
    {
      var oscillators = oscillators;
      var hebbianWeights = hebbianWeights;
      var orderParameter = 1.0;
      var meanPhase = 0.0;
      var rGenesis = 1.0;
      var thetaGenesis = thetaGenesis;
      var isGenesisLocked = false;
      var lyapunovV = 0.0;
      var previousV = 0.0;
      var dVdt = 0.0;
      var isStable = true;
      var driftMagnitude = 0.0;
      var driftDirection = Array.tabulate<Float>(NUM_NODES, func (_) : Float { 0.0 });
      var violationCount = 0;
      var lastCorrectionBeat = 0;
      var primaryCorticalCoherence = 1.0;
      var secondaryCorticalCoherence = 1.0;
      var subcorticalCoherence = 1.0;
      var modulatoryCoherence = 1.0;
      var lastUpdateBeat = 0;
      var totalUpdates = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO ORDER PARAMETER
  // r(t) = |1/N Σⱼ exp(i·θⱼ)|
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func calculateOrderParameter(oscillators : [var OscillatorState]) : (Float, Float) {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (osc in oscillators.vals()) {
      sumCos += Float.cos(osc.phase);
      sumSin += Float.sin(osc.phase);
    };
    
    let n = Float.fromInt(oscillators.size());
    let avgCos = sumCos / n;
    let avgSin = sumSin / n;
    
    let r = Float.sqrt(avgCos * avgCos + avgSin * avgSin);
    let meanPhase = Float.arctan2(avgSin, avgCos);
    
    (r, meanPhase)
  };
  
  /// Calculate coherence for a subset of nodes
  public func calculateRegionalCoherence(
    oscillators : [var OscillatorState],
    startIndex : Nat,
    endIndex : Nat
  ) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(startIndex, endIndex)) {
      sumCos += Float.cos(oscillators[i].phase);
      sumSin += Float.sin(oscillators[i].phase);
      count += 1;
    };
    
    if (count == 0) { return 1.0; };
    
    let n = Float.fromInt(count);
    let avgCos = sumCos / n;
    let avgSin = sumSin / n;
    
    Float.sqrt(avgCos * avgCos + avgSin * avgSin)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO DYNAMICS
  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ w_ij × sin(θⱼ - θᵢ)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func kuramotoStep(
    state : SuperBrainState,
    dt : Float
  ) : () {
    let n = Float.fromInt(NUM_NODES);
    
    // Calculate phase velocities
    for (i in Iter.range(0, NUM_NODES - 1)) {
      var coupling : Float = 0.0;
      
      for (j in Iter.range(0, NUM_NODES - 1)) {
        if (i != j) {
          let weightIndex = i * NUM_NODES + j;
          let weight = state.hebbianWeights[weightIndex];
          let phaseDiff = state.oscillators[j].phase - state.oscillators[i].phase;
          coupling += weight * Float.sin(phaseDiff);
        };
      };
      
      let Ki = state.oscillators[i].couplingStrength;
      let omega = state.oscillators[i].naturalFrequency;
      let velocity = omega + (Ki / n) * coupling;
      
      state.oscillators[i] := {
        phase = state.oscillators[i].phase;
        naturalFrequency = state.oscillators[i].naturalFrequency;
        instantFrequency = velocity / TWO_PI; // Convert to Hz
        phaseVelocity = velocity;
        activation = state.oscillators[i].activation;
        couplingStrength = state.oscillators[i].couplingStrength;
      };
    };
    
    // Update phases
    for (i in Iter.range(0, NUM_NODES - 1)) {
      var newPhase = state.oscillators[i].phase + state.oscillators[i].phaseVelocity * dt;
      
      // Wrap to [0, 2π]
      while (newPhase < 0.0) { newPhase += TWO_PI; };
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI; };
      
      state.oscillators[i] := {
        phase = newPhase;
        naturalFrequency = state.oscillators[i].naturalFrequency;
        instantFrequency = state.oscillators[i].instantFrequency;
        phaseVelocity = state.oscillators[i].phaseVelocity;
        activation = state.oscillators[i].activation;
        couplingStrength = state.oscillators[i].couplingStrength;
      };
    };
    
    // Update order parameter
    let (r, meanPhase) = calculateOrderParameter(state.oscillators);
    state.orderParameter := r;
    state.meanPhase := meanPhase;
    
    // Update regional coherences
    state.primaryCorticalCoherence := calculateRegionalCoherence(state.oscillators, 0, 15);
    state.secondaryCorticalCoherence := calculateRegionalCoherence(state.oscillators, 16, 39);
    state.subcorticalCoherence := calculateRegionalCoherence(state.oscillators, 40, 55);
    state.modulatoryCoherence := calculateRegionalCoherence(state.oscillators, 56, 63);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING
  // Δw = η × xᵢ × xⱼ - λ × w
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func hebbianUpdate(
    state : SuperBrainState
  ) : () {
    for (i in Iter.range(0, NUM_NODES - 1)) {
      for (j in Iter.range(0, NUM_NODES - 1)) {
        if (i != j) {
          let weightIndex = i * NUM_NODES + j;
          let currentWeight = state.hebbianWeights[weightIndex];
          
          // Activity based on phase alignment
          let phaseDiff = Float.abs(state.oscillators[i].phase - state.oscillators[j].phase);
          let alignment = Float.cos(phaseDiff); // +1 when aligned, -1 when anti-aligned
          
          let preActivity = state.oscillators[i].activation;
          let postActivity = state.oscillators[j].activation;
          
          // Hebbian update with alignment modulation
          let delta = LEARNING_RATE * preActivity * postActivity * alignment - DECAY_RATE * currentWeight;
          var newWeight = currentWeight + delta;
          
          // Apply sovereign floor and ceiling
          if (newWeight < SOVEREIGN_FLOOR) { newWeight := SOVEREIGN_FLOOR; };
          if (newWeight > MAX_WEIGHT) { newWeight := MAX_WEIGHT; };
          
          state.hebbianWeights[weightIndex] := newWeight;
        };
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JASMINE LAW — Lyapunov Stability
  // V(x) = Σ (θ_i - θ_target)²
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func calculateLyapunovV(state : SuperBrainState) : Float {
    var V : Float = 0.0;
    
    for (i in Iter.range(0, NUM_NODES - 1)) {
      let diff = state.oscillators[i].phase - state.thetaGenesis[i];
      V += diff * diff;
    };
    
    V
  };
  
  public func jasmineLawCheck(state : SuperBrainState) : Bool {
    state.previousV := state.lyapunovV;
    state.lyapunovV := calculateLyapunovV(state);
    state.dVdt := state.lyapunovV - state.previousV;
    
    // Stable if V is decreasing or at minimum
    state.isStable := state.dVdt <= 0.0 or state.lyapunovV < 0.1;
    state.isStable
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT DETECTION AND CORRECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func checkDrift(state : SuperBrainState) : Float {
    if (not state.isGenesisLocked) { return 0.0; };
    
    let rDiff = state.rGenesis - state.orderParameter;
    state.driftMagnitude := Float.abs(rDiff);
    
    state.driftMagnitude
  };
  
  public func applyReentrainment(
    state : SuperBrainState,
    strength : Float
  ) : () {
    for (i in Iter.range(0, NUM_NODES - 1)) {
      let targetPhase = state.thetaGenesis[i];
      let currentPhase = state.oscillators[i].phase;
      let correction = strength * Float.sin(targetPhase - currentPhase);
      
      var newPhase = currentPhase + correction;
      
      // Wrap to [0, 2π]
      while (newPhase < 0.0) { newPhase += TWO_PI; };
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI; };
      
      state.oscillators[i] := {
        phase = newPhase;
        naturalFrequency = state.oscillators[i].naturalFrequency;
        instantFrequency = state.oscillators[i].instantFrequency;
        phaseVelocity = state.oscillators[i].phaseVelocity;
        activation = state.oscillators[i].activation;
        couplingStrength = state.oscillators[i].couplingStrength;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func lockGenesis(state : SuperBrainState) : () {
    if (state.isGenesisLocked) { return; };
    
    state.rGenesis := state.orderParameter;
    
    let thetaGenesis = Array.tabulate<Float>(NUM_NODES, func (i : Nat) : Float {
      state.oscillators[i].phase
    });
    state.thetaGenesis := thetaGenesis;
    
    state.isGenesisLocked := true;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(state : SuperBrainState, currentBeat : Nat, dt : Float) : () {
    // Lock genesis on first tick
    if (not state.isGenesisLocked) {
      lockGenesis(state);
    };
    
    // Kuramoto phase update
    kuramotoStep(state, dt);
    
    // Hebbian weight update
    hebbianUpdate(state);
    
    // Jasmine Law stability check
    let isStable = jasmineLawCheck(state);
    
    // Drift detection
    let drift = checkDrift(state);
    
    // Apply correction if drifting
    if (drift > DRIFT_EPSILON) {
      let correctionStrength = if (drift > DRIFT_CRITICAL) {
        REENTRAINMENT_STRENGTH * 2.0
      } else {
        REENTRAINMENT_STRENGTH
      };
      applyReentrainment(state, correctionStrength);
      state.violationCount += 1;
      state.lastCorrectionBeat := currentBeat;
    };
    
    state.lastUpdateBeat := currentBeat;
    state.totalUpdates += 1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getOrderParameter(state : SuperBrainState) : Float {
    state.orderParameter
  };
  
  public func getMeanPhase(state : SuperBrainState) : Float {
    state.meanPhase
  };
  
  public func getRegionalCoherences(state : SuperBrainState) : {
    primary : Float;
    secondary : Float;
    subcortical : Float;
    modulatory : Float;
  } {
    {
      primary = state.primaryCorticalCoherence;
      secondary = state.secondaryCorticalCoherence;
      subcortical = state.subcorticalCoherence;
      modulatory = state.modulatoryCoherence;
    }
  };
  
  public func getDriftStatus(state : SuperBrainState) : {
    magnitude : Float;
    isStable : Bool;
    violationCount : Nat;
  } {
    {
      magnitude = state.driftMagnitude;
      isStable = state.isStable;
      violationCount = state.violationCount;
    }
  };

}
