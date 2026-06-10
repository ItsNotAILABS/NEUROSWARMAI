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
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Text "mo:core/Text";
import Bool "mo:core/Bool";

module CorticalEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let GOLDEN_RATIO : Float = 1.61803398874989484820;

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORTICAL LAYER TYPES (6 Layers like neocortex)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CorticalLayerId = {
    #L1_Molecular;        // Layer 1: Sparse, mostly dendrites and axons
    #L2_ExternalGranular; // Layer 2: Small pyramidal, stellate cells
    #L3_ExternalPyramidal;// Layer 3: Medium pyramidal, cortico-cortical
    #L4_InternalGranular; // Layer 4: Receives thalamic input
    #L5_InternalPyramidal;// Layer 5: Large pyramidal, motor output
    #L6_Multiform;        // Layer 6: Corticothalamic feedback
  };

  public type CorticalLayer = {
    id : CorticalLayerId;
    name : Text;
    thickness : Float;        // Relative thickness
    cellDensity : Float;      // Cells per unit
    excitatory : Float;       // Proportion excitatory
    inhibitory : Float;       // Proportion inhibitory
    
    // Layer-specific activity
    meanActivity : Float;
    peakActivity : Float;
    oscillationPhase : Float;
    
    // Connections
    feedforwardStrength : Float;
    feedbackStrength : Float;
    lateralStrength : Float;
    
    // Plasticity state
    ltpThreshold : Float;
    ltdThreshold : Float;
    plasticityRate : Float;
    
    // Processing state
    lastUpdateBeat : Int;
    activationCount : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORTICAL COLUMN — Fundamental processing unit
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CorticalColumn = {
    columnId : Nat;
    position : (Nat, Nat);      // Grid position
    
    // 6 layers
    layers : [CorticalLayer];
    
    // Column state
    columnActivity : Float;
    columnCoherence : Float;
    preferredStimulus : Float;  // What this column "represents"
    tuningWidth : Float;        // Selectivity
    
    // Lateral connections
    neighborWeights : [Float];
    inhibitionReceived : Float;
    inhibitionSent : Float;
    
    // Thalamic input
    thalamicInputStrength : Float;
    thalamicDrivePhase : Float;
    
    // Minicolumns within
    minicolumnCount : Nat;
    activeMinicolumns : Nat;
    
    // History
    activityHistory : [Float];
    lastSpikeBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORTICAL MAP — Topographic organization
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CorticalMap = {
    mapId : Nat;
    name : Text;
    mapType : CorticalMapType;
    
    // Grid dimensions
    width : Nat;
    height : Nat;
    totalColumns : Nat;
    
    // Columns in this map
    columns : [CorticalColumn];
    
    // Map-level properties
    mapCoherence : Float;
    dominantOscillation : OscillationBand;
    globalInhibition : Float;
    
    // Topographic properties
    magnificationFactor : Float;
    receptiveFieldSize : Float;
    corticalPointImage : Float;
    
    // Inter-map connections
    connectedMaps : [Nat];
    feedforwardTargets : [Nat];
    feedbackSources : [Nat];
    
    // Plasticity
    mapPlasticityRate : Float;
    reorganizationActive : Bool;
  };

  public type CorticalMapType = {
    #Primary;         // Primary sensory (V1, A1, S1)
    #Secondary;       // Secondary processing
    #Association;     // Multi-modal integration
    #Motor;           // Motor output
    #Prefrontal;      // Executive, planning
    #Temporal;        // Memory, recognition
    #Parietal;        // Spatial, attention
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OSCILLATION BANDS — Brain rhythms
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OscillationBand = {
    #Delta;           // 0.5-4 Hz: Deep sleep
    #Theta;           // 4-8 Hz: Memory, navigation
    #Alpha;           // 8-13 Hz: Relaxed, attention
    #Beta;            // 13-30 Hz: Active thinking
    #Gamma;           // 30-100 Hz: Binding, consciousness
    #HighGamma;       // 100-200 Hz: Local processing
  };

  public type OscillationState = {
    band : OscillationBand;
    frequency : Float;        // Actual Hz
    amplitude : Float;        // Power
    phase : Float;            // Current phase
    coherence : Float;        // Cross-regional coherence
    peakFrequency : Float;    // Dominant frequency within band
    bandwidth : Float;        // Frequency spread
  };

  public type OscillationComplex = {
    delta : OscillationState;
    theta : OscillationState;
    alpha : OscillationState;
    beta : OscillationState;
    gamma : OscillationState;
    highGamma : OscillationState;
    
    // Cross-frequency coupling
    thetaGammaCoupling : Float;    // PAC: phase-amplitude coupling
    alphaBetaCoupling : Float;
    deltaAlphaCoupling : Float;
    
    // Global oscillation state
    dominantBand : OscillationBand;
    totalPower : Float;
    arousalLevel : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // THALAMOCORTICAL LOOP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ThalamicNucleus = {
    nucleusId : Nat;
    name : Text;
    nucleusType : ThalamicNucleusType;
    
    // Activity
    firingRate : Float;
    burstMode : Bool;           // Burst vs tonic mode
    relayEfficiency : Float;
    
    // Connections
    corticalTargets : [Nat];    // Which cortical maps it projects to
    reticularInput : Float;     // From reticular nucleus (inhibition)
    corticalFeedback : Float;   // Feedback from cortex
    
    // State
    gatingState : Float;        // 0=closed, 1=fully open
    attentionalModulation : Float;
  };

  public type ThalamicNucleusType = {
    #Relay;           // Sensory relay (LGN, MGN, VPL)
    #Association;     // Higher-order (Pulvinar, MD)
    #Intralaminar;    // Arousal, consciousness
    #Reticular;       // Inhibitory gating
    #Midline;         // Memory, emotion
  };

  public type ThalamocorticalLoop = {
    thalamus : [ThalamicNucleus];
    corticalMaps : [Nat];
    loopDelay : Float;          // Round-trip time
    loopGain : Float;           // Amplification factor
    resonanceFrequency : Float; // Natural oscillation
    stabilityMargin : Float;    // Distance from instability
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LATERAL INHIBITION — Winner-take-all dynamics
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LateralInhibitionState = {
    inhibitionRadius : Float;   // Spatial extent
    inhibitionStrength : Float; // Peak strength
    inhibitionProfile : Text;   // "gaussian", "mexican_hat", "surround"
    
    // Winner-take-all
    wtaActive : Bool;
    winnerThreshold : Float;
    competitionStrength : Float;
    
    // Normalization
    divisiveNormalization : Bool;
    normalizationPool : Float;
    
    // Current state
    activeWinners : Nat;
    suppressedLosers : Nat;
    competitionCycles : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PLASTICITY MECHANISMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PlasticityState = {
    // LTP/LTD
    ltpActive : Bool;
    ltdActive : Bool;
    ltpThreshold : Float;
    ltdThreshold : Float;
    ltpMagnitude : Float;
    ltdMagnitude : Float;
    
    // STDP (Spike-Timing Dependent Plasticity)
    stdpWindow : Float;         // ms
    stdpAsymmetry : Float;      // Pre-before-post vs post-before-pre ratio
    stdpLearningRate : Float;
    
    // BCM (Bienenstock-Cooper-Munro)
    bcmThreshold : Float;       // Sliding threshold
    bcmTimeConstant : Float;
    bcmTargetRate : Float;
    
    // Homeostatic plasticity
    homeostaticActive : Bool;
    targetActivity : Float;
    scalingRate : Float;
    intrinsicPlasticityRate : Float;
    
    // Metaplasticity
    metaplasticState : Float;
    plasticityHistory : [Float];
    slidingThresholdRate : Float;
    
    // Structural plasticity
    spineGrowthRate : Float;
    spineRetractionRate : Float;
    synapseFormationRate : Float;
    synapsePruningRate : Float;
    
    // Statistics
    totalLtpEvents : Nat;
    totalLtdEvents : Nat;
    netPlasticityChange : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ATTENTION MECHANISMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AttentionState = {
    // Spatial attention
    attentionFocus : (Float, Float);  // x, y coordinates
    attentionRadius : Float;
    attentionIntensity : Float;
    
    // Feature attention
    attendedFeatures : [Float];
    featureGains : [Float];
    
    // Object attention
    attendedObjectId : ?Nat;
    objectBasedModulation : Float;
    
    // Biased competition
    competitionBias : Float;
    selectedRepresentation : Nat;
    suppressedRepresentations : [Nat];
    
    // Top-down control
    topDownSignalStrength : Float;
    attentionalPriority : Float;
    voluntaryControl : Float;
    
    // Bottom-up salience
    salienceMap : [Float];
    bottomUpCapture : Float;
    surpriseSignal : Float;
    
    // Attention dynamics
    engagementTime : Float;
    disengagementThreshold : Float;
    switchingCost : Float;
    
    // Global state
    alertness : Float;
    vigilance : Float;
    sustainedAttention : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKING MEMORY — Prefrontal sustained activity
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkingMemoryState = {
    // Capacity
    capacity : Nat;             // ~4 items
    currentLoad : Nat;
    utilizationRatio : Float;
    
    // Items in working memory
    items : [WorkingMemoryItem];
    
    // Maintenance
    maintenanceStrength : Float;
    refreshRate : Float;
    decayRate : Float;
    
    // Interference
    proactiveInterference : Float;
    retroactiveInterference : Float;
    similarityInterference : Float;
    
    // Updating
    updateGate : Float;         // 0=maintain, 1=update
    gatingSignal : Float;
    lastUpdateBeat : Int;
    
    // Binding
    bindingStrength : Float;
    featureConjunction : Float;
    
    // Prefrontal state
    persistentActivity : Float;
    distractorResistance : Float;
  };

  public type WorkingMemoryItem = {
    itemId : Nat;
    content : [Float];          // Feature vector
    priority : Float;
    freshness : Float;          // Decays over time
    boundTo : [Nat];            // Bound with other items
    source : Text;              // Origin of item
    encodedAt : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE PROCESSING IN CORTEX
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictiveCortexState = {
    // Hierarchical predictions
    predictions : [[Float]];    // One per layer
    predictionErrors : [[Float]];
    precisionWeights : [[Float]];
    
    // Layer-wise processing
    bottomUpErrors : [Float];
    topDownPredictions : [Float];
    
    // Error minimization
    totalPredictionError : Float;
    errorHistory : [Float];
    learningFromError : Float;
    
    // Precision
    expectedPrecision : Float;
    precisionEstimate : Float;
    uncertaintySignal : Float;
    
    // Model confidence
    modelConfidence : Float;
    surprisalAccumulated : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORTICAL DYNAMICS — Full state
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CorticalDynamicsState = {
    // Stability measures
    lyapunovExponent : Float;   // Chaos measure
    correlationDimension : Float;
    entropyRate : Float;
    
    // Criticality
    criticalityIndex : Float;   // Near edge of chaos
    branchingParameter : Float; // σ ≈ 1 at criticality
    avalancheSizeDistribution : [Float];
    
    // Information flow
    transferEntropy : Float;
    effectiveConnectivity : [[Float]];
    causalDensity : Float;
    
    // Synchronization
    globalSync : Float;
    localSync : Float;
    syncClusters : Nat;
    
    // Metastability
    metastabilityIndex : Float;
    dwellTimes : [Float];
    transitionRates : [[Float]];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED CORTICAL ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FullCorticalState = {
    // Cortical maps (each map has columns)
    maps : [CorticalMap];
    totalColumns : Nat;
    totalMaps : Nat;
    
    // Oscillations
    oscillations : OscillationComplex;
    
    // Thalamocortical
    thalamocortical : ThalamocorticalLoop;
    
    // Lateral inhibition
    lateralInhibition : LateralInhibitionState;
    
    // Plasticity
    plasticity : PlasticityState;
    
    // Attention
    attention : AttentionState;
    
    // Working memory
    workingMemory : WorkingMemoryState;
    
    // Predictive processing
    predictive : PredictiveCortexState;
    
    // Dynamics
    dynamics : CorticalDynamicsState;
    
    // Global state
    globalCoherence : Float;
    consciousnessLevel : Float;
    processingCycles : Nat;
    lastProcessedBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initCorticalLayer(id : CorticalLayerId, name : Text) : CorticalLayer {
    let (thickness, excitatory, inhibitory) = switch (id) {
      case (#L1_Molecular) (0.05, 0.0, 0.1);
      case (#L2_ExternalGranular) (0.15, 0.7, 0.3);
      case (#L3_ExternalPyramidal) (0.25, 0.75, 0.25);
      case (#L4_InternalGranular) (0.20, 0.65, 0.35);
      case (#L5_InternalPyramidal) (0.20, 0.8, 0.2);
      case (#L6_Multiform) (0.15, 0.7, 0.3);
    };
    {
      id;
      name;
      thickness;
      cellDensity = 0.5;
      excitatory;
      inhibitory;
      meanActivity = 0.1;
      peakActivity = 0.0;
      oscillationPhase = 0.0;
      feedforwardStrength = 0.5;
      feedbackStrength = 0.3;
      lateralStrength = 0.2;
      ltpThreshold = 0.6;
      ltdThreshold = 0.4;
      plasticityRate = 0.01;
      lastUpdateBeat = 0;
      activationCount = 0;
    };
  };

  public func initOscillationState(band : OscillationBand) : OscillationState {
    let (freq, amp) = switch (band) {
      case (#Delta) (2.0, 0.3);
      case (#Theta) (6.0, 0.25);
      case (#Alpha) (10.0, 0.35);
      case (#Beta) (20.0, 0.2);
      case (#Gamma) (40.0, 0.15);
      case (#HighGamma) (120.0, 0.05);
    };
    {
      band;
      frequency = freq;
      amplitude = amp;
      phase = 0.0;
      coherence = 0.5;
      peakFrequency = freq;
      bandwidth = freq * 0.2;
    };
  };

  public func initOscillationComplex() : OscillationComplex {
    {
      delta = initOscillationState(#Delta);
      theta = initOscillationState(#Theta);
      alpha = initOscillationState(#Alpha);
      beta = initOscillationState(#Beta);
      gamma = initOscillationState(#Gamma);
      highGamma = initOscillationState(#HighGamma);
      thetaGammaCoupling = 0.3;
      alphaBetaCoupling = 0.2;
      deltaAlphaCoupling = 0.25;
      dominantBand = #Alpha;
      totalPower = 1.0;
      arousalLevel = 0.5;
    };
  };

  public func initLateralInhibition() : LateralInhibitionState {
    {
      inhibitionRadius = 3.0;
      inhibitionStrength = 0.5;
      inhibitionProfile = "mexican_hat";
      wtaActive = true;
      winnerThreshold = 0.7;
      competitionStrength = 0.6;
      divisiveNormalization = true;
      normalizationPool = 1.0;
      activeWinners = 0;
      suppressedLosers = 0;
      competitionCycles = 0;
    };
  };

  public func initPlasticity() : PlasticityState {
    {
      ltpActive = true;
      ltdActive = true;
      ltpThreshold = 0.6;
      ltdThreshold = 0.4;
      ltpMagnitude = 0.1;
      ltdMagnitude = 0.05;
      stdpWindow = 20.0;
      stdpAsymmetry = 1.5;
      stdpLearningRate = 0.01;
      bcmThreshold = 0.5;
      bcmTimeConstant = 100.0;
      bcmTargetRate = 0.1;
      homeostaticActive = true;
      targetActivity = 0.1;
      scalingRate = 0.001;
      intrinsicPlasticityRate = 0.0005;
      metaplasticState = 0.5;
      plasticityHistory = [];
      slidingThresholdRate = 0.001;
      spineGrowthRate = 0.01;
      spineRetractionRate = 0.005;
      synapseFormationRate = 0.01;
      synapsePruningRate = 0.008;
      totalLtpEvents = 0;
      totalLtdEvents = 0;
      netPlasticityChange = 0.0;
    };
  };

  public func initAttention() : AttentionState {
    {
      attentionFocus = (0.5, 0.5);
      attentionRadius = 0.2;
      attentionIntensity = 0.5;
      attendedFeatures = [];
      featureGains = [];
      attendedObjectId = null;
      objectBasedModulation = 0.0;
      competitionBias = 0.0;
      selectedRepresentation = 0;
      suppressedRepresentations = [];
      topDownSignalStrength = 0.5;
      attentionalPriority = 0.5;
      voluntaryControl = 0.5;
      salienceMap = [];
      bottomUpCapture = 0.0;
      surpriseSignal = 0.0;
      engagementTime = 0.0;
      disengagementThreshold = 0.3;
      switchingCost = 0.1;
      alertness = 0.7;
      vigilance = 0.5;
      sustainedAttention = 0.5;
    };
  };

  public func initWorkingMemory() : WorkingMemoryState {
    {
      capacity = 4;
      currentLoad = 0;
      utilizationRatio = 0.0;
      items = [];
      maintenanceStrength = 0.5;
      refreshRate = 0.1;
      decayRate = 0.01;
      proactiveInterference = 0.0;
      retroactiveInterference = 0.0;
      similarityInterference = 0.0;
      updateGate = 0.0;
      gatingSignal = 0.0;
      lastUpdateBeat = 0;
      bindingStrength = 0.5;
      featureConjunction = 0.5;
      persistentActivity = 0.3;
      distractorResistance = 0.5;
    };
  };

  public func initPredictiveCortex() : PredictiveCortexState {
    {
      predictions = [];
      predictionErrors = [];
      precisionWeights = [];
      bottomUpErrors = [];
      topDownPredictions = [];
      totalPredictionError = 0.0;
      errorHistory = [];
      learningFromError = 0.01;
      expectedPrecision = 1.0;
      precisionEstimate = 1.0;
      uncertaintySignal = 0.0;
      modelConfidence = 0.5;
      surprisalAccumulated = 0.0;
    };
  };

  public func initCorticalDynamics() : CorticalDynamicsState {
    {
      lyapunovExponent = 0.0;
      correlationDimension = 2.0;
      entropyRate = 0.5;
      criticalityIndex = 0.5;
      branchingParameter = 1.0;
      avalancheSizeDistribution = [];
      transferEntropy = 0.0;
      effectiveConnectivity = [];
      causalDensity = 0.5;
      globalSync = 0.3;
      localSync = 0.5;
      syncClusters = 1;
      metastabilityIndex = 0.5;
      dwellTimes = [];
      transitionRates = [];
    };
  };

  public func initFullCorticalState() : FullCorticalState {
    {
      maps = [];
      totalColumns = 0;
      totalMaps = 0;
      oscillations = initOscillationComplex();
      thalamocortical = {
        thalamus = [];
        corticalMaps = [];
        loopDelay = 10.0;
        loopGain = 1.2;
        resonanceFrequency = 10.0;
        stabilityMargin = 0.5;
      };
      lateralInhibition = initLateralInhibition();
      plasticity = initPlasticity();
      attention = initAttention();
      workingMemory = initWorkingMemory();
      predictive = initPredictiveCortex();
      dynamics = initCorticalDynamics();
      globalCoherence = 0.75;
      consciousnessLevel = 0.5;
      processingCycles = 0;
      lastProcessedBeat = 0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OSCILLATION PHASE ADVANCE
  // φ(t+1) = φ(t) + 2π·f·dt (mod 2π)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func advanceOscillationPhase(
    state : OscillationState,
    dt : Float
  ) : OscillationState {
    var newPhase = state.phase + TWO_PI * state.frequency * dt;
    while (newPhase >= TWO_PI) { newPhase := newPhase - TWO_PI };
    while (newPhase < 0.0) { newPhase := newPhase + TWO_PI };
    
    {
      band = state.band;
      frequency = state.frequency;
      amplitude = state.amplitude;
      phase = newPhase;
      coherence = state.coherence;
      peakFrequency = state.peakFrequency;
      bandwidth = state.bandwidth;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CROSS-FREQUENCY COUPLING
  // PAC = Phase-Amplitude Coupling
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computePhasAmplitudeCoupling(
    lowPhase : Float,
    highAmplitude : Float
  ) : Float {
    // High amplitude modulated by low frequency phase
    // PAC = correlation between low phase and high amplitude envelope
    highAmplitude * Float.cos(lowPhase);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STDP — Spike-Timing Dependent Plasticity
  // Δw = A+ · exp(-Δt/τ+) if pre before post (LTP)
  // Δw = -A- · exp(Δt/τ-) if post before pre (LTD)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeSTDP(
    preTime : Float,
    postTime : Float,
    aPlus : Float,
    aMinus : Float,
    tauPlus : Float,
    tauMinus : Float
  ) : Float {
    let dt = postTime - preTime;
    
    if (dt > 0.0) {
      // Pre before post → LTP
      aPlus * Float.exp(-dt / tauPlus);
    } else if (dt < 0.0) {
      // Post before pre → LTD
      -aMinus * Float.exp(dt / tauMinus);
    } else {
      0.0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WINNER-TAKE-ALL DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeWTA(
    activities : [Float],
    inhibitionStrength : Float,
    threshold : Float
  ) : [Float] {
    // Find maximum
    var maxVal : Float = 0.0;
    var maxIdx : Nat = 0;
    var i : Nat = 0;
    while (i < activities.size()) {
      if (activities[i] > maxVal) {
        maxVal := activities[i];
        maxIdx := i;
      };
      i := i + 1;
    };
    
    // Apply WTA
    Array.tabulate(activities.size(), func(j : Nat) : Float {
      if (j == maxIdx and activities[j] > threshold) {
        activities[j];  // Winner maintains activity
      } else {
        Float.max(0.0, activities[j] - inhibitionStrength * maxVal);
      };
    });
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIVISIVE NORMALIZATION
  // r_i = c_i^n / (σ^n + Σ_j w_j · c_j^n)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func divisiveNormalization(
    activities : [Float],
    weights : [Float],
    sigma : Float,
    exponent : Float
  ) : [Float] {
    // Compute normalization pool
    var pool : Float = Float.pow(sigma, exponent);
    var i : Nat = 0;
    while (i < activities.size()) {
      let weight = if (i < weights.size()) weights[i] else 1.0;
      pool := pool + weight * Float.pow(activities[i], exponent);
      i := i + 1;
    };
    
    // Normalize
    Array.tabulate(activities.size(), func(j : Nat) : Float {
      let powered = Float.pow(activities[j], exponent);
      powered / pool;
    });
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORTICAL DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getCorticalDiagnostics(state : FullCorticalState) : Text {
    "═══ CORTICAL ENGINE DIAGNOSTICS ═══\n" #
    "Processing Cycles: " # Nat.toText(state.processingCycles) # "\n" #
    "Global Coherence: " # Float.toText(state.globalCoherence) # "\n" #
    "Consciousness Level: " # Float.toText(state.consciousnessLevel) # "\n\n" #
    
    "OSCILLATIONS:\n" #
    "  Delta: " # Float.toText(state.oscillations.delta.amplitude) # " @ " # Float.toText(state.oscillations.delta.frequency) # "Hz\n" #
    "  Theta: " # Float.toText(state.oscillations.theta.amplitude) # " @ " # Float.toText(state.oscillations.theta.frequency) # "Hz\n" #
    "  Alpha: " # Float.toText(state.oscillations.alpha.amplitude) # " @ " # Float.toText(state.oscillations.alpha.frequency) # "Hz\n" #
    "  Beta: " # Float.toText(state.oscillations.beta.amplitude) # " @ " # Float.toText(state.oscillations.beta.frequency) # "Hz\n" #
    "  Gamma: " # Float.toText(state.oscillations.gamma.amplitude) # " @ " # Float.toText(state.oscillations.gamma.frequency) # "Hz\n" #
    "  Theta-Gamma Coupling: " # Float.toText(state.oscillations.thetaGammaCoupling) # "\n\n" #
    
    "PLASTICITY:\n" #
    "  LTP Events: " # Nat.toText(state.plasticity.totalLtpEvents) # "\n" #
    "  LTD Events: " # Nat.toText(state.plasticity.totalLtdEvents) # "\n" #
    "  BCM Threshold: " # Float.toText(state.plasticity.bcmThreshold) # "\n\n" #
    
    "ATTENTION:\n" #
    "  Alertness: " # Float.toText(state.attention.alertness) # "\n" #
    "  Vigilance: " # Float.toText(state.attention.vigilance) # "\n" #
    "  Intensity: " # Float.toText(state.attention.attentionIntensity) # "\n\n" #
    
    "WORKING MEMORY:\n" #
    "  Capacity: " # Nat.toText(state.workingMemory.capacity) # "\n" #
    "  Current Load: " # Nat.toText(state.workingMemory.currentLoad) # "\n" #
    "  Maintenance: " # Float.toText(state.workingMemory.maintenanceStrength) # "\n\n" #
    
    "DYNAMICS:\n" #
    "  Criticality: " # Float.toText(state.dynamics.criticalityIndex) # "\n" #
    "  Metastability: " # Float.toText(state.dynamics.metastabilityIndex) # "\n" #
    "═══════════════════════════════════════\n";
  };

};
