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
// SHELL 3 — KURAMOTO NEURAL SUBSTRATE WITH COHERENCE DRIFT GATE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Shell 3 is the Brain Field — a 26-node Kuramoto phase coupling network that creates
// the organism's primary consciousness substrate.
//
// BRAIN DRIFT GATE:
// ─────────────────
// The Hz substrate nodes (delta through gamma) drift as Hebbian weights compound.
// The law compliance score is computed over the Kuramoto coherence index r(t) and
// the 12-node phase vector.
//
// Genesis locks r_genesis and θ_genesis[12].
//
// Every heartbeat where r(t) < r_genesis × (1 - ε) — that is drift, that is a violation,
// and the law cascade fires a re-entrainment pulse.
//
// The organism pulls itself back to its own genesis attractor automatically.
//
// KURAMOTO MODEL:
// ───────────────
// dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
//
// where:
// - θᵢ is the phase of oscillator i
// - ωᵢ is the natural frequency of oscillator i
// - K is the coupling strength
// - N is the number of oscillators
//
// ORDER PARAMETER (Coherence):
// r(t) = |1/N Σⱼ exp(i·θⱼ)|
//
// r = 1 means perfect synchronization (all oscillators in phase)
// r = 0 means complete desynchronization
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
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module Shell3KuramotoSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  
  // Shell 3 constants
  public let NUM_KURAMOTO_NODES : Nat = 26;
  public let NUM_PRIMARY_NODES : Nat = 12;  // Primary brain regions
  public let NUM_SECONDARY_NODES : Nat = 14; // Secondary modulation
  
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

  // ═══════════════════════════════════════════════════════════════════════════════
  // BRAIN REGION IDENTIFIERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// BrainRegion identifies the 26 Kuramoto nodes
  public type BrainRegion = {
    // Primary regions (12)
    #PREFRONTAL;   // Executive function
    #PARIETAL;     // Spatial processing
    #TEMPORAL;     // Memory, language
    #OCCIPITAL;    // Visual processing
    #LIMBIC;       // Emotion
    #HIPPOCAMPUS;  // Memory formation
    #AMYGDALA;     // Fear, emotion
    #THALAMUS;     // Relay station
    #HYPOTHALAMUS; // Homeostasis
    #CEREBELLUM;   // Motor coordination
    #BRAINSTEM;    // Vital functions
    #BASAL;        // Movement, reward
    
    // Secondary regions (14)
    #INSULA;       // Interoception
    #CINGULATE;    // Error detection
    #PRECUNEUS;    // Self-awareness
    #CUNEUS;       // Visual
    #FUSIFORM;     // Face recognition
    #ANGULAR;      // Language, math
    #SUPRAMARGINAL; // Language
    #WERNICKE;     // Language comprehension
    #BROCA;        // Language production
    #MOTOR;        // Motor cortex
    #SOMATOSENSORY; // Touch
    #AUDITORY;     // Sound processing
    #ORBITAL;      // Decision making
    #ENTORHINAL;   // Memory gateway
  };
  
  /// Get region name
  public func getRegionName(region : BrainRegion) : Text {
    switch (region) {
      case (#PREFRONTAL) { "PREFRONTAL" };
      case (#PARIETAL) { "PARIETAL" };
      case (#TEMPORAL) { "TEMPORAL" };
      case (#OCCIPITAL) { "OCCIPITAL" };
      case (#LIMBIC) { "LIMBIC" };
      case (#HIPPOCAMPUS) { "HIPPOCAMPUS" };
      case (#AMYGDALA) { "AMYGDALA" };
      case (#THALAMUS) { "THALAMUS" };
      case (#HYPOTHALAMUS) { "HYPOTHALAMUS" };
      case (#CEREBELLUM) { "CEREBELLUM" };
      case (#BRAINSTEM) { "BRAINSTEM" };
      case (#BASAL) { "BASAL" };
      case (#INSULA) { "INSULA" };
      case (#CINGULATE) { "CINGULATE" };
      case (#PRECUNEUS) { "PRECUNEUS" };
      case (#CUNEUS) { "CUNEUS" };
      case (#FUSIFORM) { "FUSIFORM" };
      case (#ANGULAR) { "ANGULAR" };
      case (#SUPRAMARGINAL) { "SUPRAMARGINAL" };
      case (#WERNICKE) { "WERNICKE" };
      case (#BROCA) { "BROCA" };
      case (#MOTOR) { "MOTOR" };
      case (#SOMATOSENSORY) { "SOMATOSENSORY" };
      case (#AUDITORY) { "AUDITORY" };
      case (#ORBITAL) { "ORBITAL" };
      case (#ENTORHINAL) { "ENTORHINAL" };
    }
  };
  
  /// Get natural frequency for region (Hz bands)
  public func getNaturalFrequency(region : BrainRegion) : Float {
    switch (region) {
      // Delta band (1-4 Hz)
      case (#BRAINSTEM) { 2.0 };
      case (#HYPOTHALAMUS) { 3.0 };
      
      // Theta band (4-8 Hz)
      case (#HIPPOCAMPUS) { 6.0 };
      case (#LIMBIC) { 5.5 };
      case (#ENTORHINAL) { 6.5 };
      
      // Alpha band (8-13 Hz)
      case (#OCCIPITAL) { 10.0 };
      case (#THALAMUS) { 9.0 };
      case (#PARIETAL) { 10.5 };
      case (#PRECUNEUS) { 11.0 };
      
      // Beta band (13-30 Hz)
      case (#PREFRONTAL) { 20.0 };
      case (#MOTOR) { 18.0 };
      case (#CINGULATE) { 15.0 };
      case (#TEMPORAL) { 16.0 };
      case (#BROCA) { 17.0 };
      case (#WERNICKE) { 16.5 };
      
      // Gamma band (30-100 Hz)
      case (#AMYGDALA) { 40.0 };
      case (#INSULA) { 35.0 };
      case (#FUSIFORM) { 38.0 };
      case (#ANGULAR) { 32.0 };
      case (#SUPRAMARGINAL) { 33.0 };
      case (#CUNEUS) { 36.0 };
      case (#CEREBELLUM) { 25.0 };
      case (#BASAL) { 22.0 };
      case (#SOMATOSENSORY) { 28.0 };
      case (#AUDITORY) { 30.0 };
      case (#ORBITAL) { 24.0 };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO OSCILLATOR — Single node
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// KuramotoOscillator represents one node in the 26-node network
  public type KuramotoOscillator = {
    /// Node index (0-25)
    nodeIndex : Nat8;
    
    /// Brain region
    region : BrainRegion;
    
    /// Region name
    regionName : Text;
    
    /// Current phase θ [0, 2π]
    phase : Float;
    
    /// Natural frequency ω (Hz)
    naturalFrequency : Float;
    
    /// Instantaneous frequency (Hz)
    instantFrequency : Float;
    
    /// Phase velocity dθ/dt
    phaseVelocity : Float;
    
    /// Coupling strength to other nodes
    couplingStrength : Float;
    
    /// Is this a primary node?
    isPrimary : Bool;
    
    /// Activation level [0, 1]
    activation : Float;
    
    /// Energy level
    energy : Float;
    
    /// Last update heartbeat
    lastUpdate : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COUPLING MATRIX — K_ij between nodes
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// CouplingMatrix stores K_ij for all pairs
  public type CouplingMatrix = {
    /// Matrix values (26 x 26 = 676 values, stored as flat array)
    values : [Float];
    
    /// Matrix dimension
    dimension : Nat;
    
    /// Spectral radius ρ(K)
    spectralRadius : Float;
    
    /// Matrix trace
    trace : Float;
    
    /// Is matrix symmetric?
    isSymmetric : Bool;
    
    /// Last update heartbeat
    lastUpdate : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO COHERENCE — Order parameter r(t)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// KuramotoCoherence stores the order parameter state
  public type KuramotoCoherence = {
    /// Order parameter r(t) ∈ [0, 1]
    orderParameter : Float;
    
    /// Mean phase ψ
    meanPhase : Float;
    
    /// Primary nodes coherence (12 nodes)
    primaryCoherence : Float;
    
    /// Secondary nodes coherence (14 nodes)
    secondaryCoherence : Float;
    
    /// Cross-coherence (primary-secondary coupling)
    crossCoherence : Float;
    
    /// Phase dispersion (variance)
    phaseDispersion : Float;
    
    /// Synchronization index
    synchronizationIndex : Float;
    
    /// Is the network synchronized?
    isSynchronized : Bool;
    
    /// Heartbeat
    heartbeat : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK — r_genesis and θ_genesis[12]
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Shell3GenesisLock stores the immutable genesis state
  public type Shell3GenesisLock = {
    /// Genesis order parameter r_genesis
    rGenesis : Float;
    
    /// Genesis phase vector θ_genesis (primary 12 nodes)
    thetaGenesis : [Float];
    
    /// Genesis mean phase
    meanPhaseGenesis : Float;
    
    /// Genesis coupling matrix signature
    couplingSignatureGenesis : Nat32;
    
    /// Genesis spectral radius
    spectralRadiusGenesis : Float;
    
    /// Formation timestamp
    formationTime : Int;
    
    /// Formation heartbeat
    formationHeartbeat : Nat;
    
    /// Is lock finalized?
    isFinalized : Bool;
    
    /// Principal who created lock
    principalId : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE DRIFT GATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// CoherenceDriftGate monitors and corrects coherence drift
  public type CoherenceDriftGate = {
    /// Genesis coherence (locked)
    rGenesis : Float;
    
    /// Live coherence
    rLive : Float;
    
    /// Coherence drift: δ = |r_live - r_genesis|
    coherenceDrift : Float;
    
    /// Drift threshold ε
    epsilon : Float;
    
    /// Allowed minimum: r_genesis × (1 - ε)
    allowedMinimum : Float;
    
    /// Is this a violation?
    isViolation : Bool;
    
    /// Is this critical?
    isCritical : Bool;
    
    /// Is this catastrophic?
    isCatastrophic : Bool;
    
    /// Phase vector drift (Euclidean distance from genesis)
    phaseVectorDrift : Float;
    
    /// Spectral radius drift
    spectralRadiusDrift : Float;
    
    /// Needs re-entrainment?
    needsReentrainment : Bool;
    
    /// Heartbeat
    heartbeat : Nat;
    
    /// Timestamp
    timestamp : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RE-ENTRAINMENT PULSE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ReentrainmentPulse corrects drift by pulling toward genesis
  public type ReentrainmentPulse = {
    /// Pulse ID
    pulseId : Nat;
    
    /// Pulse strength
    strength : Float;
    
    /// Pulse duration (heartbeats)
    duration : Nat;
    
    /// Remaining beats
    remainingBeats : Nat;
    
    /// Pulse phase
    pulsePhase : Float;
    
    /// Target nodes (all 26)
    targetPhases : [Float];
    
    /// Is pulse active?
    isActive : Bool;
    
    /// Start heartbeat
    startHeartbeat : Nat;
    
    /// Trigger drift value
    triggerDrift : Float;
    
    /// Correction progress
    progress : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE SHELL 3 STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Shell3State is the complete brain field state
  public type Shell3State = {
    /// All 26 oscillators
    oscillators : [KuramotoOscillator];
    
    /// Coupling matrix
    couplingMatrix : CouplingMatrix;
    
    /// Current coherence
    coherence : KuramotoCoherence;
    
    /// Genesis lock
    genesisLock : ?Shell3GenesisLock;
    
    /// Drift gate
    driftGate : CoherenceDriftGate;
    
    /// Re-entrainment state
    reentrainmentPulse : ?ReentrainmentPulse;
    
    /// Is genesis locked?
    isGenesisLocked : Bool;
    
    /// Current heartbeat
    currentHeartbeat : Nat;
    
    /// Last update timestamp
    lastUpdate : Int;
    
    /// Organism ID
    organismId : Text;
    
    /// Statistics
    totalHeartbeats : Nat;
    totalDriftEvents : Nat;
    totalReentrainments : Nat;
    averageCoherence : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get all brain regions
  func getAllRegions() : [BrainRegion] {
    [
      #PREFRONTAL, #PARIETAL, #TEMPORAL, #OCCIPITAL, #LIMBIC, #HIPPOCAMPUS,
      #AMYGDALA, #THALAMUS, #HYPOTHALAMUS, #CEREBELLUM, #BRAINSTEM, #BASAL,
      #INSULA, #CINGULATE, #PRECUNEUS, #CUNEUS, #FUSIFORM, #ANGULAR,
      #SUPRAMARGINAL, #WERNICKE, #BROCA, #MOTOR, #SOMATOSENSORY, #AUDITORY,
      #ORBITAL, #ENTORHINAL
    ]
  };
  
  /// Create oscillator for region
  func createOscillator(index : Nat8, region : BrainRegion) : KuramotoOscillator {
    let freq = getNaturalFrequency(region);
    {
      nodeIndex = index;
      region = region;
      regionName = getRegionName(region);
      phase = Float.fromInt(Nat8.toNat(index)) * TWO_PI / Float.fromInt(NUM_KURAMOTO_NODES);
      naturalFrequency = freq;
      instantFrequency = freq;
      phaseVelocity = freq * TWO_PI;
      couplingStrength = DEFAULT_COUPLING_K;
      isPrimary = Nat8.toNat(index) < NUM_PRIMARY_NODES;
      activation = 0.5;
      energy = 1.0;
      lastUpdate = 0;
    }
  };
  
  /// Create all oscillators
  public func createAllOscillators() : [KuramotoOscillator] {
    let regions = getAllRegions();
    Array.tabulate<KuramotoOscillator>(NUM_KURAMOTO_NODES, func(i : Nat) : KuramotoOscillator {
      createOscillator(Nat8.fromNat(i), regions[i])
    })
  };
  
  /// Create default coupling matrix
  public func createDefaultCouplingMatrix() : CouplingMatrix {
    let n = NUM_KURAMOTO_NODES;
    let values = Array.tabulate<Float>(n * n, func(idx : Nat) : Float {
      let i = idx / n;
      let j = idx % n;
      if (i == j) { 0.0 }  // No self-coupling
      else { DEFAULT_COUPLING_K }
    });
    
    {
      values = values;
      dimension = n;
      spectralRadius = DEFAULT_COUPLING_K * Float.fromInt(n - 1);  // Approximate
      trace = 0.0;  // Diagonal is zero
      isSymmetric = true;
      lastUpdate = 0;
    }
  };
  
  /// Create default coherence
  public func createDefaultCoherence() : KuramotoCoherence {
    {
      orderParameter = 1.0;
      meanPhase = 0.0;
      primaryCoherence = 1.0;
      secondaryCoherence = 1.0;
      crossCoherence = 1.0;
      phaseDispersion = 0.0;
      synchronizationIndex = 1.0;
      isSynchronized = true;
      heartbeat = 0;
    }
  };
  
  /// Create default drift gate
  public func createDefaultDriftGate() : CoherenceDriftGate {
    {
      rGenesis = 1.0;
      rLive = 1.0;
      coherenceDrift = 0.0;
      epsilon = DRIFT_EPSILON;
      allowedMinimum = 1.0 * (1.0 - DRIFT_EPSILON);
      isViolation = false;
      isCritical = false;
      isCatastrophic = false;
      phaseVectorDrift = 0.0;
      spectralRadiusDrift = 0.0;
      needsReentrainment = false;
      heartbeat = 0;
      timestamp = Time.now();
    }
  };
  
  /// Create default Shell 3 state
  public func createDefaultShell3State(organismId : Text) : Shell3State {
    {
      oscillators = createAllOscillators();
      couplingMatrix = createDefaultCouplingMatrix();
      coherence = createDefaultCoherence();
      genesisLock = null;
      driftGate = createDefaultDriftGate();
      reentrainmentPulse = null;
      isGenesisLocked = false;
      currentHeartbeat = 0;
      lastUpdate = Time.now();
      organismId = organismId;
      totalHeartbeats = 0;
      totalDriftEvents = 0;
      totalReentrainments = 0;
      averageCoherence = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Kuramoto order parameter r and mean phase ψ
  /// r·exp(i·ψ) = (1/N) Σⱼ exp(i·θⱼ)
  public func computeOrderParameter(oscillators : [KuramotoOscillator]) : (Float, Float) {
    let n = Array.size(oscillators);
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      sumCos += Float.cos(oscillators[i].phase);
      sumSin += Float.sin(oscillators[i].phase);
    };
    
    let avgCos = sumCos / Float.fromInt(n);
    let avgSin = sumSin / Float.fromInt(n);
    
    let r = Float.sqrt(avgCos * avgCos + avgSin * avgSin);
    let psi = Float.arctan2(avgSin, avgCos);
    
    (r, psi)
  };
  
  /// Compute coherence for subset of nodes
  func computeSubsetCoherence(oscillators : [KuramotoOscillator], startIdx : Nat, endIdx : Nat) : Float {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    let count = endIdx - startIdx;
    
    for (i in Iter.range(startIdx, endIdx - 1)) {
      sumCos += Float.cos(oscillators[i].phase);
      sumSin += Float.sin(oscillators[i].phase);
    };
    
    let avgCos = sumCos / Float.fromInt(count);
    let avgSin = sumSin / Float.fromInt(count);
    
    Float.sqrt(avgCos * avgCos + avgSin * avgSin)
  };
  
  /// Update single oscillator using Kuramoto dynamics
  /// dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  public func updateOscillator(
    osc : KuramotoOscillator,
    allOscillators : [KuramotoOscillator],
    couplingMatrix : CouplingMatrix,
    dt : Float
  ) : KuramotoOscillator {
    let n = Array.size(allOscillators);
    let i = Nat8.toNat(osc.nodeIndex);
    
    // Compute coupling term
    var couplingSum : Float = 0.0;
    for (j in Iter.range(0, n - 1)) {
      if (i != j) {
        let k_ij = couplingMatrix.values[i * n + j];
        let phaseDiff = allOscillators[j].phase - osc.phase;
        couplingSum += k_ij * Float.sin(phaseDiff);
      };
    };
    
    // Phase velocity: dθ/dt = ω + coupling/N
    let phaseVelocity = osc.naturalFrequency * TWO_PI + couplingSum / Float.fromInt(n);
    
    // Update phase
    var newPhase = osc.phase + phaseVelocity * dt;
    
    // Normalize to [0, 2π]
    while (newPhase < 0.0) { newPhase += TWO_PI; };
    while (newPhase >= TWO_PI) { newPhase -= TWO_PI; };
    
    // Compute instantaneous frequency
    let instantFreq = phaseVelocity / TWO_PI;
    
    {
      nodeIndex = osc.nodeIndex;
      region = osc.region;
      regionName = osc.regionName;
      phase = newPhase;
      naturalFrequency = osc.naturalFrequency;
      instantFrequency = instantFreq;
      phaseVelocity = phaseVelocity;
      couplingStrength = osc.couplingStrength;
      isPrimary = osc.isPrimary;
      activation = osc.activation;
      energy = osc.energy;
      lastUpdate = osc.lastUpdate + 1;
    }
  };
  
  /// Update all oscillators
  public func updateAllOscillators(
    oscillators : [KuramotoOscillator],
    couplingMatrix : CouplingMatrix,
    dt : Float
  ) : [KuramotoOscillator] {
    Array.tabulate<KuramotoOscillator>(NUM_KURAMOTO_NODES, func(i : Nat) : KuramotoOscillator {
      updateOscillator(oscillators[i], oscillators, couplingMatrix, dt)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute full coherence state
  public func computeCoherence(
    oscillators : [KuramotoOscillator],
    heartbeat : Nat
  ) : KuramotoCoherence {
    // Overall order parameter
    let (r, psi) = computeOrderParameter(oscillators);
    
    // Primary coherence (nodes 0-11)
    let primaryR = computeSubsetCoherence(oscillators, 0, NUM_PRIMARY_NODES);
    
    // Secondary coherence (nodes 12-25)
    let secondaryR = computeSubsetCoherence(oscillators, NUM_PRIMARY_NODES, NUM_KURAMOTO_NODES);
    
    // Cross coherence (simplified: product of primary and secondary)
    let crossR = primaryR * secondaryR;
    
    // Phase dispersion (variance of phases)
    var sumPhase : Float = 0.0;
    var sumPhaseSq : Float = 0.0;
    for (i in Iter.range(0, NUM_KURAMOTO_NODES - 1)) {
      sumPhase += oscillators[i].phase;
      sumPhaseSq += oscillators[i].phase * oscillators[i].phase;
    };
    let meanPhase = sumPhase / Float.fromInt(NUM_KURAMOTO_NODES);
    let variance = sumPhaseSq / Float.fromInt(NUM_KURAMOTO_NODES) - meanPhase * meanPhase;
    let dispersion = Float.sqrt(Float.abs(variance));
    
    // Synchronization index (1 if r > 0.8, 0 otherwise)
    let syncIndex = if (r > 0.8) { 1.0 } else { r / 0.8 };
    
    {
      orderParameter = r;
      meanPhase = psi;
      primaryCoherence = primaryR;
      secondaryCoherence = secondaryR;
      crossCoherence = crossR;
      phaseDispersion = dispersion;
      synchronizationIndex = syncIndex;
      isSynchronized = r > 0.8;
      heartbeat = heartbeat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock genesis state
  public func createGenesisLock(
    state : Shell3State,
    principalId : Text
  ) : Shell3GenesisLock {
    // Extract primary node phases
    let thetaGenesis = Array.tabulate<Float>(NUM_PRIMARY_NODES, func(i : Nat) : Float {
      state.oscillators[i].phase
    });
    
    // Compute coupling signature
    var sig : Nat32 = 0;
    for (i in Iter.range(0, Array.size(state.couplingMatrix.values) - 1)) {
      let v = Float.toInt(state.couplingMatrix.values[i] * 10000.0);
      sig := sig +% Nat32.fromIntWrap(v * (i + 1));
    };
    
    {
      rGenesis = state.coherence.orderParameter;
      thetaGenesis = thetaGenesis;
      meanPhaseGenesis = state.coherence.meanPhase;
      couplingSignatureGenesis = sig;
      spectralRadiusGenesis = state.couplingMatrix.spectralRadius;
      formationTime = Time.now();
      formationHeartbeat = state.currentHeartbeat;
      isFinalized = true;
      principalId = principalId;
    }
  };
  
  /// Lock genesis in state
  public func lockGenesis(state : Shell3State, principalId : Text) : Shell3State {
    if (state.isGenesisLocked) {
      return state;
    };
    
    let lock = createGenesisLock(state, principalId);
    
    let newDriftGate = {
      rGenesis = lock.rGenesis;
      rLive = state.coherence.orderParameter;
      coherenceDrift = 0.0;
      epsilon = DRIFT_EPSILON;
      allowedMinimum = lock.rGenesis * (1.0 - DRIFT_EPSILON);
      isViolation = false;
      isCritical = false;
      isCatastrophic = false;
      phaseVectorDrift = 0.0;
      spectralRadiusDrift = 0.0;
      needsReentrainment = false;
      heartbeat = state.currentHeartbeat;
      timestamp = Time.now();
    };
    
    {
      oscillators = state.oscillators;
      couplingMatrix = state.couplingMatrix;
      coherence = state.coherence;
      genesisLock = ?lock;
      driftGate = newDriftGate;
      reentrainmentPulse = state.reentrainmentPulse;
      isGenesisLocked = true;
      currentHeartbeat = state.currentHeartbeat;
      lastUpdate = Time.now();
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats;
      totalDriftEvents = state.totalDriftEvents;
      totalReentrainments = state.totalReentrainments;
      averageCoherence = state.averageCoherence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIFT GATE COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute drift gate
  public func computeDriftGate(
    coherence : KuramotoCoherence,
    genesis : Shell3GenesisLock,
    oscillators : [KuramotoOscillator],
    couplingMatrix : CouplingMatrix,
    heartbeat : Nat
  ) : CoherenceDriftGate {
    let rLive = coherence.orderParameter;
    let rGenesis = genesis.rGenesis;
    let allowedMin = rGenesis * (1.0 - DRIFT_EPSILON);
    
    // Coherence drift
    let coherenceDrift = if (rLive < allowedMin) {
      (allowedMin - rLive) / rGenesis
    } else { 0.0 };
    
    // Phase vector drift (Euclidean distance)
    var phaseVectorDrift : Float = 0.0;
    for (i in Iter.range(0, NUM_PRIMARY_NODES - 1)) {
      let diff = oscillators[i].phase - genesis.thetaGenesis[i];
      phaseVectorDrift += diff * diff;
    };
    phaseVectorDrift := Float.sqrt(phaseVectorDrift / Float.fromInt(NUM_PRIMARY_NODES));
    
    // Spectral radius drift
    let spectralRadiusDrift = Float.abs(couplingMatrix.spectralRadius - genesis.spectralRadiusGenesis);
    
    // Determine violation status
    let isViolation = rLive < allowedMin;
    let isCritical = rLive < rGenesis * (1.0 - DRIFT_CRITICAL);
    let isCatastrophic = rLive < rGenesis * (1.0 - DRIFT_CATASTROPHIC);
    
    {
      rGenesis = rGenesis;
      rLive = rLive;
      coherenceDrift = coherenceDrift;
      epsilon = DRIFT_EPSILON;
      allowedMinimum = allowedMin;
      isViolation = isViolation;
      isCritical = isCritical;
      isCatastrophic = isCatastrophic;
      phaseVectorDrift = phaseVectorDrift;
      spectralRadiusDrift = spectralRadiusDrift;
      needsReentrainment = isViolation;
      heartbeat = heartbeat;
      timestamp = Time.now();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RE-ENTRAINMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create re-entrainment pulse
  public func createReentrainmentPulse(
    genesis : Shell3GenesisLock,
    driftGate : CoherenceDriftGate,
    pulseId : Nat
  ) : ReentrainmentPulse {
    // Target phases are genesis phases extended to all nodes
    let targetPhases = Array.tabulate<Float>(NUM_KURAMOTO_NODES, func(i : Nat) : Float {
      if (i < NUM_PRIMARY_NODES) {
        genesis.thetaGenesis[i]
      } else {
        // Secondary nodes target mean phase
        genesis.meanPhaseGenesis
      }
    });
    
    {
      pulseId = pulseId;
      strength = REENTRAINMENT_STRENGTH;
      duration = REENTRAINMENT_DURATION;
      remainingBeats = REENTRAINMENT_DURATION;
      pulsePhase = 0.0;
      targetPhases = targetPhases;
      isActive = true;
      startHeartbeat = driftGate.heartbeat;
      triggerDrift = driftGate.coherenceDrift;
      progress = 0.0;
    }
  };
  
  /// Apply re-entrainment pulse to oscillators
  public func applyReentrainmentPulse(
    oscillators : [KuramotoOscillator],
    pulse : ReentrainmentPulse
  ) : ([KuramotoOscillator], ReentrainmentPulse) {
    if (not pulse.isActive or pulse.remainingBeats == 0) {
      return (oscillators, pulse);
    };
    
    // Apply smooth correction
    let smoothFactor = 0.5 * (1.0 - Float.cos(pulse.pulsePhase));
    let correctionStrength = pulse.strength * smoothFactor / Float.fromInt(pulse.duration);
    
    let updatedOscillators = Array.tabulate<KuramotoOscillator>(NUM_KURAMOTO_NODES, func(i : Nat) : KuramotoOscillator {
      let osc = oscillators[i];
      let targetPhase = pulse.targetPhases[i];
      
      // Compute phase correction
      var phaseDiff = targetPhase - osc.phase;
      // Normalize to [-π, π]
      while (phaseDiff > PI) { phaseDiff -= TWO_PI; };
      while (phaseDiff < -PI) { phaseDiff += TWO_PI; };
      
      var newPhase = osc.phase + phaseDiff * correctionStrength;
      // Normalize to [0, 2π]
      while (newPhase < 0.0) { newPhase += TWO_PI; };
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI; };
      
      {
        nodeIndex = osc.nodeIndex;
        region = osc.region;
        regionName = osc.regionName;
        phase = newPhase;
        naturalFrequency = osc.naturalFrequency;
        instantFrequency = osc.instantFrequency;
        phaseVelocity = osc.phaseVelocity;
        couplingStrength = osc.couplingStrength;
        isPrimary = osc.isPrimary;
        activation = osc.activation;
        energy = osc.energy;
        lastUpdate = osc.lastUpdate;
      }
    });
    
    // Update pulse state
    let newPhase = pulse.pulsePhase + PI / Float.fromInt(pulse.duration);
    let newRemaining = if (pulse.remainingBeats > 0) { pulse.remainingBeats - 1 } else { 0 };
    let newProgress = 1.0 - Float.fromInt(newRemaining) / Float.fromInt(pulse.duration);
    
    let updatedPulse = {
      pulseId = pulse.pulseId;
      strength = pulse.strength;
      duration = pulse.duration;
      remainingBeats = newRemaining;
      pulsePhase = newPhase;
      targetPhases = pulse.targetPhases;
      isActive = newRemaining > 0;
      startHeartbeat = pulse.startHeartbeat;
      triggerDrift = pulse.triggerDrift;
      progress = newProgress;
    };
    
    (updatedOscillators, updatedPulse)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process one heartbeat
  public func processHeartbeat(
    state : Shell3State,
    dt : Float
  ) : Shell3State {
    let heartbeat = state.currentHeartbeat + 1;
    
    // Update oscillators
    var oscillators = updateAllOscillators(state.oscillators, state.couplingMatrix, dt);
    
    // Compute coherence
    let coherence = computeCoherence(oscillators, heartbeat);
    
    // Compute drift gate if genesis is locked
    let (driftGate, shouldReentrain) = switch (state.genesisLock) {
      case (?genesis) {
        let gate = computeDriftGate(coherence, genesis, oscillators, state.couplingMatrix, heartbeat);
        (gate, gate.needsReentrainment)
      };
      case (null) {
        (state.driftGate, false)
      };
    };
    
    // Handle re-entrainment
    var reentrainmentPulse = state.reentrainmentPulse;
    var totalReentrainments = state.totalReentrainments;
    var totalDriftEvents = state.totalDriftEvents;
    
    // If should reentrain and no active pulse, create one
    if (shouldReentrain) {
      totalDriftEvents += 1;
      switch (reentrainmentPulse) {
        case (?pulse) {
          if (not pulse.isActive) {
            // Create new pulse
            switch (state.genesisLock) {
              case (?genesis) {
                reentrainmentPulse := ?createReentrainmentPulse(genesis, driftGate, totalReentrainments);
                totalReentrainments += 1;
              };
              case (null) {};
            };
          };
        };
        case (null) {
          switch (state.genesisLock) {
            case (?genesis) {
              reentrainmentPulse := ?createReentrainmentPulse(genesis, driftGate, totalReentrainments);
              totalReentrainments += 1;
            };
            case (null) {};
          };
        };
      };
    };
    
    // Apply active pulse
    switch (reentrainmentPulse) {
      case (?pulse) {
        if (pulse.isActive) {
          let (newOsc, newPulse) = applyReentrainmentPulse(oscillators, pulse);
          oscillators := newOsc;
          reentrainmentPulse := ?newPulse;
        };
      };
      case (null) {};
    };
    
    // Update average coherence
    let n = Float.fromInt(state.totalHeartbeats);
    let newAvgCoherence = (state.averageCoherence * n + coherence.orderParameter) / (n + 1.0);
    
    {
      oscillators = oscillators;
      couplingMatrix = state.couplingMatrix;
      coherence = coherence;
      genesisLock = state.genesisLock;
      driftGate = driftGate;
      reentrainmentPulse = reentrainmentPulse;
      isGenesisLocked = state.isGenesisLocked;
      currentHeartbeat = heartbeat;
      lastUpdate = Time.now();
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats + 1;
      totalDriftEvents = totalDriftEvents;
      totalReentrainments = totalReentrainments;
      averageCoherence = newAvgCoherence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get order parameter
  public func getOrderParameter(state : Shell3State) : Float {
    state.coherence.orderParameter
  };
  
  /// Get coherence drift
  public func getCoherenceDrift(state : Shell3State) : Float {
    state.driftGate.coherenceDrift
  };
  
  /// Is drift a violation?
  public func isDriftViolation(state : Shell3State) : Bool {
    state.driftGate.isViolation
  };
  
  /// Get primary coherence
  public func getPrimaryCoherence(state : Shell3State) : Float {
    state.coherence.primaryCoherence
  };
  
  /// Get phase vector (primary nodes)
  public func getPhaseVector(state : Shell3State) : [Float] {
    Array.tabulate<Float>(NUM_PRIMARY_NODES, func(i : Nat) : Float {
      state.oscillators[i].phase
    })
  };
  
  /// Is genesis locked?
  public func isGenesisLocked(state : Shell3State) : Bool {
    state.isGenesisLocked
  };
  
  /// Get total re-entrainments
  public func getTotalReentrainments(state : Shell3State) : Nat {
    state.totalReentrainments
  };
  
  /// Is synchronized?
  public func isSynchronized(state : Shell3State) : Bool {
    state.coherence.isSynchronized
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL 2 COUPLING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get contribution to Shell 2
  public func getShell2Contribution(state : Shell3State) : [Float] {
    // Shell 3 provides phase-based modulation to Shell 2
    Array.tabulate<Float>(NUM_PRIMARY_NODES, func(i : Nat) : Float {
      Float.cos(state.oscillators[i].phase) * state.coherence.orderParameter
    })
  };
  
  /// Receive Shell 2 influence
  public func receiveShell2Influence(state : Shell3State, shell2Signal : [Float]) : Shell3State {
    if (Array.size(shell2Signal) != NUM_PRIMARY_NODES) {
      return state;
    };
    
    // Shell 2 identity modulates natural frequencies
    let modulatedOscillators = Array.tabulate<KuramotoOscillator>(NUM_KURAMOTO_NODES, func(i : Nat) : KuramotoOscillator {
      let osc = state.oscillators[i];
      if (i < NUM_PRIMARY_NODES) {
        let modulation = shell2Signal[i] * 0.1;  // Small modulation
        {
          nodeIndex = osc.nodeIndex;
          region = osc.region;
          regionName = osc.regionName;
          phase = osc.phase;
          naturalFrequency = osc.naturalFrequency * (1.0 + modulation);
          instantFrequency = osc.instantFrequency;
          phaseVelocity = osc.phaseVelocity;
          couplingStrength = osc.couplingStrength;
          isPrimary = osc.isPrimary;
          activation = osc.activation;
          energy = osc.energy;
          lastUpdate = osc.lastUpdate;
        }
      } else {
        osc
      }
    });
    
    {
      oscillators = modulatedOscillators;
      couplingMatrix = state.couplingMatrix;
      coherence = state.coherence;
      genesisLock = state.genesisLock;
      driftGate = state.driftGate;
      reentrainmentPulse = state.reentrainmentPulse;
      isGenesisLocked = state.isGenesisLocked;
      currentHeartbeat = state.currentHeartbeat;
      lastUpdate = Time.now();
      organismId = state.organismId;
      totalHeartbeats = state.totalHeartbeats;
      totalDriftEvents = state.totalDriftEvents;
      totalReentrainments = state.totalReentrainments;
      averageCoherence = state.averageCoherence;
    }
  };

}
