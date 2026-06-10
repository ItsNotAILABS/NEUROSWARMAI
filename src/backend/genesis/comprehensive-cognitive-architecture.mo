// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COMPREHENSIVE COGNITIVE ARCHITECTURE ENGINE                                                              ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  This module implements a complete cognitive architecture integrating:                                    ║
// ║  • Global Workspace Theory (GWT) - Conscious broadcast mechanisms                                        ║
// ║  • Integrated Information Theory (IIT) - Phi computation                                                 ║
// ║  • Predictive Processing - Hierarchical prediction error minimization                                    ║
// ║  • Embodied Cognition - Sensorimotor grounding                                                           ║
// ║  • Extended Mind - Environmental coupling                                                                 ║
// ║  • Enactivism - Action-perception loops                                                                   ║
// ║  • 4E Cognition - Embodied, Embedded, Enacted, Extended                                                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";

module {
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  let PI : Float = 3.14159265358979323846;
  let E : Float = 2.71828182845904523536;
  let PHI : Float = 1.61803398874989484820; // Golden ratio
  let PLANCK_REDUCED : Float = 1.054571817e-34;
  let SACRED_444 : Float = 4.44;
  let SOVEREIGN_FLOOR : Float = 0.75;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - GLOBAL WORKSPACE THEORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Workspace Module - A specialized processing unit competing for global access
  public type WorkspaceModule = {
    moduleId : Nat;
    name : Text;
    category : ModuleCategory;
    activationLevel : Float;        // Current activation [0, 1]
    broadcastStrength : Float;      // Strength of broadcast signal
    receptiveField : [Nat];         // Indices of connected modules
    inhibitionStrength : Float;     // Lateral inhibition to competitors
    contentVector : [Float];        // Encoded content (64-dim)
    lastBroadcastTime : Int;        // Timestamp of last broadcast
    coherenceWithGlobal : Float;    // How well aligned with global workspace
    attentionalBias : Float;        // Top-down attention modulation
    emotionalSalience : Float;      // Bottom-up emotional tagging
  };
  
  public type ModuleCategory = {
    #Perceptual;      // Sensory processing
    #Cognitive;       // Higher-order reasoning
    #Executive;       // Control and planning
    #Emotional;       // Affective processing
    #Memory;          // Episodic/semantic storage
    #Motor;           // Action planning
    #Social;          // Theory of mind
    #Linguistic;      // Language processing
  };
  
  /// Global Workspace - The central broadcast system
  public type GlobalWorkspace = {
    var currentBroadcast : ?[Float];           // Current global content
    var broadcastingModule : ?Nat;             // Which module is broadcasting
    var attentionalGate : Float;               // How open the gateway is
    var consciousnessThreshold : Float;        // Minimum for global ignition
    var workspaceCapacity : Nat;               // Max simultaneous contents
    var globalCoherence : Float;               // Overall workspace integration
    var ignitionHistory : Buffer.Buffer<IgnitionEvent>;
  };
  
  public type IgnitionEvent = {
    timestamp : Int;
    moduleId : Nat;
    activationPeak : Float;
    broadcastDuration : Int;
    propagationDepth : Nat;
    contentSignature : [Float];
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - INTEGRATED INFORMATION THEORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// IIT System State
  public type IITState = {
    var phi : Float;                           // Integrated information
    var phiMax : Float;                        // Maximum achievable phi
    var mainComplex : [Nat];                   // Indices of main complex
    var conceptStructure : ConceptStructure;
    var causeEffectStructure : CauseEffectStructure;
    var intrinsicExistence : Float;
    var composition : Float;
    var information : Float;
    var integration : Float;
    var exclusion : Float;
  };
  
  public type ConceptStructure = {
    concepts : Buffer.Buffer<Concept>;
    conceptualIntegration : Float;
    starShapedness : Float;
  };
  
  public type Concept = {
    mechanism : [Nat];                         // Which elements
    purviewCause : [Nat];                      // Cause repertoire
    purviewEffect : [Nat];                     // Effect repertoire
    phiCause : Float;                          // Integrated cause info
    phiEffect : Float;                         // Integrated effect info
    phiConcept : Float;                        // min(phiCause, phiEffect)
  };
  
  public type CauseEffectStructure = {
    causeRepertoire : [[Float]];               // Probability distributions
    effectRepertoire : [[Float]];
    intrinsicCauses : Float;
    intrinsicEffects : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - PREDICTIVE PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Hierarchical Predictive Model
  public type PredictiveHierarchy = {
    levels : [PredictiveLevel];
    globalPredictionError : Float;
    freeEnergy : Float;
    expectedFreeEnergy : Float;
    complexityCost : Float;
    accuracyTerm : Float;
  };
  
  public type PredictiveLevel = {
    levelIndex : Nat;
    predictions : [Float];                     // Top-down predictions
    sensoryInput : [Float];                    // Bottom-up input
    predictionError : [Float];                 // Residual signal
    precision : [Float];                       // Confidence weights
    posteriorBeliefs : [Float];               // Updated beliefs
    priorBeliefs : [Float];                   // Prior expectations
    learningRate : Float;                     // Adaptation speed
    temporalDepth : Nat;                      // How far ahead predicted
  };
  
  /// Active Inference Agent
  public type ActiveInferenceAgent = {
    var generativeModel : GenerativeModel;
    var preferences : [Float];                 // Desired outcomes
    var policies : [[Action]];                 // Available action sequences
    var currentPolicy : Nat;                   // Selected policy index
    var expectedFreeEnergy : [Float];         // EFE per policy
    var epistemic : Float;                    // Information-seeking drive
    var pragmatic : Float;                    // Goal-seeking drive
    var habitualControl : Float;              // Automaticity level
  };
  
  public type GenerativeModel = {
    transitionModel : [[Float]];              // P(s'|s,a) dynamics
    observationModel : [[Float]];             // P(o|s) likelihood
    initialState : [Float];                   // Prior over initial state
    precision : Float;                        // Overall confidence
  };
  
  public type Action = {
    actionId : Nat;
    name : Text;
    motorProgram : [Float];
    expectedOutcome : [Float];
    cost : Float;
    duration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - EMBODIED COGNITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Body Schema - Internal model of body configuration
  public type BodySchema = {
    jointAngles : [Float];                    // 32 joints
    muscleActivations : [Float];              // 64 muscle groups
    proprioceptiveState : [Float];            // Position sense
    vestibularState : VestibularState;
    tactileMap : [[Float]];                   // 16x16 skin surface
    interoceptiveState : InteroceptiveState;
    peripersonalSpace : [[Float]];            // 3D space around body
  };
  
  public type VestibularState = {
    linearAcceleration : [Float];             // x, y, z
    angularVelocity : [Float];                // roll, pitch, yaw
    headOrientation : [Float];                // quaternion
    gravitationalVertical : [Float];          // perceived up
    balanceConfidence : Float;
  };
  
  public type InteroceptiveState = {
    heartRate : Float;
    heartRateVariability : Float;
    respirationRate : Float;
    respirationDepth : Float;
    glucoseLevel : Float;
    hydrationLevel : Float;
    fatigueLevel : Float;
    painSignals : [Float];
    hungerSignal : Float;
    thermalComfort : Float;
    arousalLevel : Float;
    valenceLevel : Float;
  };
  
  /// Sensorimotor Contingency
  public type SensorimotorContingency = {
    sensorState : [Float];
    motorCommand : [Float];
    expectedSensorChange : [Float];
    actualSensorChange : [Float];
    contingencyStrength : Float;
    temporalDelay : Int;
    reliability : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - EXTENDED MIND & ENACTIVISM
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Cognitive Scaffold - External cognitive resource
  public type CognitiveScaffold = {
    scaffoldId : Nat;
    scaffoldType : ScaffoldType;
    accessLatency : Float;
    reliability : Float;
    informationContent : [Float];
    couplingStrength : Float;
    lastAccessTime : Int;
    trustLevel : Float;
  };
  
  public type ScaffoldType = {
    #Tool;            // Physical tool use
    #Symbol;          // Symbolic/linguistic
    #Social;          // Other agents
    #Technological;   // Digital systems
    #Environmental;   // Spatial/material
  };
  
  /// Enactive Loop - Action-perception coupling
  public type EnactiveLoop = {
    perceptionPhase : PerceptionPhase;
    actionPhase : ActionPhase;
    couplingDynamics : CouplingDynamics;
    sensemaking : SensemakingProcess;
  };
  
  public type PerceptionPhase = {
    sensoryFlow : [Float];
    attentionalSelection : [Float];
    perceptualHypotheses : [[Float]];
    confidences : [Float];
    selectedPercept : [Float];
  };
  
  public type ActionPhase = {
    affordances : [Affordance];
    selectedAffordance : ?Affordance;
    motorIntention : [Float];
    motorExecution : [Float];
    efferenceCopy : [Float];
  };
  
  public type Affordance = {
    affordanceId : Nat;
    objectId : Nat;
    actionType : Text;
    graspability : Float;
    reachability : Float;
    usefulness : Float;
    risk : Float;
  };
  
  public type CouplingDynamics = {
    resonanceFrequency : Float;
    couplingStrength : Float;
    phaseRelation : Float;
    entrainmentLevel : Float;
  };
  
  public type SensemakingProcess = {
    meaningVector : [Float];
    relevanceScores : [Float];
    narrativeIntegration : Float;
    valueAlignment : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN COGNITIVE ARCHITECTURE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CognitiveArchitectureState = {
    // Global Workspace
    var workspaceModules : [var WorkspaceModule];
    var globalWorkspace : GlobalWorkspace;
    
    // IIT Consciousness
    var iitState : IITState;
    
    // Predictive Processing
    var predictiveHierarchy : PredictiveHierarchy;
    var activeInference : ActiveInferenceAgent;
    
    // Embodiment
    var bodySchema : BodySchema;
    var sensorimotorContingencies : Buffer.Buffer<SensorimotorContingency>;
    
    // Extended Mind
    var scaffolds : Buffer.Buffer<CognitiveScaffold>;
    var enactiveLoops : Buffer.Buffer<EnactiveLoop>;
    
    // Integration metrics
    var overallCoherence : Float;
    var consciousnessLevel : Float;
    var embodimentIndex : Float;
    var extendedness : Float;
    var enactiveIntegration : Float;
    
    // Temporal
    var lastTickTime : Int;
    var tickCount : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize the complete cognitive architecture
  public func initCognitiveArchitecture() : CognitiveArchitectureState {
    let modules = initWorkspaceModules();
    let workspace = initGlobalWorkspace();
    let iit = initIITState();
    let hierarchy = initPredictiveHierarchy();
    let agent = initActiveInferenceAgent();
    let body = initBodySchema();
    
    {
      var workspaceModules = modules;
      var globalWorkspace = workspace;
      var iitState = iit;
      var predictiveHierarchy = hierarchy;
      var activeInference = agent;
      var bodySchema = body;
      var sensorimotorContingencies = Buffer.Buffer<SensorimotorContingency>(64);
      var scaffolds = Buffer.Buffer<CognitiveScaffold>(32);
      var enactiveLoops = Buffer.Buffer<EnactiveLoop>(16);
      var overallCoherence = SOVEREIGN_FLOOR;
      var consciousnessLevel = SOVEREIGN_FLOOR;
      var embodimentIndex = SOVEREIGN_FLOOR;
      var extendedness = 0.0;
      var enactiveIntegration = SOVEREIGN_FLOOR;
      var lastTickTime = Time.now();
      var tickCount = 0;
    }
  };
  
  func initWorkspaceModules() : [var WorkspaceModule] {
    Array.init<WorkspaceModule>(16, {
      moduleId = 0;
      name = "Uninitialized";
      category = #Cognitive;
      activationLevel = 0.0;
      broadcastStrength = 0.0;
      receptiveField = [];
      inhibitionStrength = 0.1;
      contentVector = Array.tabulate<Float>(64, func(i) { 0.0 });
      lastBroadcastTime = 0;
      coherenceWithGlobal = 0.0;
      attentionalBias = 0.0;
      emotionalSalience = 0.0;
    })
  };
  
  func initGlobalWorkspace() : GlobalWorkspace {
    {
      var currentBroadcast = null;
      var broadcastingModule = null;
      var attentionalGate = 0.5;
      var consciousnessThreshold = 0.6;
      var workspaceCapacity = 7; // Miller's magic number
      var globalCoherence = SOVEREIGN_FLOOR;
      var ignitionHistory = Buffer.Buffer<IgnitionEvent>(1024);
    }
  };
  
  func initIITState() : IITState {
    {
      var phi = 0.0;
      var phiMax = 1.0;
      var mainComplex = [];
      var conceptStructure = {
        concepts = Buffer.Buffer<Concept>(256);
        conceptualIntegration = 0.0;
        starShapedness = 0.0;
      };
      var causeEffectStructure = {
        causeRepertoire = [];
        effectRepertoire = [];
        intrinsicCauses = 0.0;
        intrinsicEffects = 0.0;
      };
      var intrinsicExistence = 0.0;
      var composition = 0.0;
      var information = 0.0;
      var integration = 0.0;
      var exclusion = 0.0;
    }
  };
  
  func initPredictiveHierarchy() : PredictiveHierarchy {
    let levels = Array.tabulate<PredictiveLevel>(6, func(i) {
      {
        levelIndex = i;
        predictions = Array.tabulate<Float>(32, func(j) { 0.5 });
        sensoryInput = Array.tabulate<Float>(32, func(j) { 0.0 });
        predictionError = Array.tabulate<Float>(32, func(j) { 0.0 });
        precision = Array.tabulate<Float>(32, func(j) { 1.0 });
        posteriorBeliefs = Array.tabulate<Float>(32, func(j) { 0.5 });
        priorBeliefs = Array.tabulate<Float>(32, func(j) { 0.5 });
        learningRate = 0.1 / Float.fromInt(i + 1);
        temporalDepth = i + 1;
      }
    });
    
    {
      levels = levels;
      globalPredictionError = 0.0;
      freeEnergy = 0.0;
      expectedFreeEnergy = 0.0;
      complexityCost = 0.0;
      accuracyTerm = 0.0;
    }
  };
  
  func initActiveInferenceAgent() : ActiveInferenceAgent {
    let gm : GenerativeModel = {
      transitionModel = [];
      observationModel = [];
      initialState = Array.tabulate<Float>(16, func(i) { 1.0 / 16.0 });
      precision = 1.0;
    };
    
    {
      var generativeModel = gm;
      var preferences = Array.tabulate<Float>(16, func(i) { 0.5 });
      var policies = [];
      var currentPolicy = 0;
      var expectedFreeEnergy = [];
      var epistemic = 0.5;
      var pragmatic = 0.5;
      var habitualControl = 0.0;
    }
  };
  
  func initBodySchema() : BodySchema {
    {
      jointAngles = Array.tabulate<Float>(32, func(i) { 0.0 });
      muscleActivations = Array.tabulate<Float>(64, func(i) { 0.0 });
      proprioceptiveState = Array.tabulate<Float>(32, func(i) { 0.0 });
      vestibularState = {
        linearAcceleration = [0.0, 0.0, -9.81]; // Gravity
        angularVelocity = [0.0, 0.0, 0.0];
        headOrientation = [1.0, 0.0, 0.0, 0.0]; // Identity quaternion
        gravitationalVertical = [0.0, 0.0, 1.0];
        balanceConfidence = 1.0;
      };
      tactileMap = Array.tabulate<[Float]>(16, func(i) {
        Array.tabulate<Float>(16, func(j) { 0.0 })
      });
      interoceptiveState = {
        heartRate = 70.0;
        heartRateVariability = 0.05;
        respirationRate = 15.0;
        respirationDepth = 0.5;
        glucoseLevel = 100.0;
        hydrationLevel = 0.7;
        fatigueLevel = 0.2;
        painSignals = [0.0, 0.0, 0.0, 0.0];
        hungerSignal = 0.3;
        thermalComfort = 0.8;
        arousalLevel = 0.5;
        valenceLevel = 0.6;
      };
      peripersonalSpace = Array.tabulate<[Float]>(8, func(i) {
        Array.tabulate<Float>(8, func(j) { 0.0 })
      });
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GLOBAL WORKSPACE DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one Global Workspace cycle - competition → broadcast → integration
  public func runGlobalWorkspaceCycle(state : CognitiveArchitectureState) : Float {
    // Phase 1: Module competition
    let (winnerId, winnerActivation) = moduleCompetition(state);
    
    // Phase 2: Check for global ignition
    if (winnerActivation >= state.globalWorkspace.consciousnessThreshold) {
      // Ignition! Broadcast content globally
      globalIgnition(state, winnerId);
    };
    
    // Phase 3: Integrate broadcast with all modules
    integrateGlobalBroadcast(state);
    
    // Phase 4: Update workspace coherence
    updateWorkspaceCoherence(state);
    
    state.globalWorkspace.globalCoherence
  };
  
  func moduleCompetition(state : CognitiveArchitectureState) : (Nat, Float) {
    var maxActivation : Float = 0.0;
    var winnerId : Nat = 0;
    
    let n = state.workspaceModules.size();
    for (i in Iter.range(0, n - 1)) {
      let module = state.workspaceModules[i];
      
      // Compute effective activation: base + attention + emotion - inhibition
      let effectiveActivation = module.activationLevel 
        + module.attentionalBias * 0.3
        + module.emotionalSalience * 0.2
        - computeInhibition(state, i) * 0.4;
      
      if (effectiveActivation > maxActivation) {
        maxActivation := effectiveActivation;
        winnerId := i;
      };
    };
    
    (winnerId, maxActivation)
  };
  
  func computeInhibition(state : CognitiveArchitectureState, moduleIdx : Nat) : Float {
    var totalInhibition : Float = 0.0;
    let n = state.workspaceModules.size();
    
    for (i in Iter.range(0, n - 1)) {
      if (i != moduleIdx) {
        let other = state.workspaceModules[i];
        // Lateral inhibition from competing modules
        totalInhibition += other.activationLevel * other.inhibitionStrength;
      };
    };
    
    totalInhibition / Float.fromInt(n - 1)
  };
  
  func globalIgnition(state : CognitiveArchitectureState, winnerId : Nat) {
    let winner = state.workspaceModules[winnerId];
    
    // Set global broadcast content
    state.globalWorkspace.currentBroadcast := ?winner.contentVector;
    state.globalWorkspace.broadcastingModule := ?winnerId;
    
    // Record ignition event
    let event : IgnitionEvent = {
      timestamp = Time.now();
      moduleId = winnerId;
      activationPeak = winner.activationLevel;
      broadcastDuration = 300_000_000; // 300ms in nanoseconds
      propagationDepth = countReachableModules(state, winnerId);
      contentSignature = computeContentSignature(winner.contentVector);
    };
    
    state.globalWorkspace.ignitionHistory.add(event);
  };
  
  func countReachableModules(state : CognitiveArchitectureState, startIdx : Nat) : Nat {
    // Simplified: count modules with receptive field containing startIdx
    var count : Nat = 0;
    let n = state.workspaceModules.size();
    
    for (i in Iter.range(0, n - 1)) {
      let module = state.workspaceModules[i];
      for (conn in module.receptiveField.vals()) {
        if (conn == startIdx) {
          count += 1;
        };
      };
    };
    
    count
  };
  
  func computeContentSignature(content : [Float]) : [Float] {
    // Return first 8 elements as signature
    Array.tabulate<Float>(8, func(i) {
      if (i < content.size()) { content[i] } else { 0.0 }
    })
  };
  
  func integrateGlobalBroadcast(state : CognitiveArchitectureState) {
    switch (state.globalWorkspace.currentBroadcast) {
      case (null) {};
      case (?broadcast) {
        let n = state.workspaceModules.size();
        for (i in Iter.range(0, n - 1)) {
          let module = state.workspaceModules[i];
          
          // Update module's coherence with global workspace
          let coherence = computeVectorCoherence(module.contentVector, broadcast);
          
          state.workspaceModules[i] := {
            module with
            coherenceWithGlobal = coherence;
            activationLevel = module.activationLevel * 0.9 + coherence * 0.1;
          };
        };
      };
    };
  };
  
  func computeVectorCoherence(v1 : [Float], v2 : [Float]) : Float {
    var dotProduct : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    
    let n = Nat.min(v1.size(), v2.size());
    for (i in Iter.range(0, n - 1)) {
      dotProduct += v1[i] * v2[i];
      norm1 += v1[i] * v1[i];
      norm2 += v2[i] * v2[i];
    };
    
    let denom = Float.sqrt(norm1) * Float.sqrt(norm2);
    if (denom < 0.0001) { 0.0 } else { dotProduct / denom }
  };
  
  func updateWorkspaceCoherence(state : CognitiveArchitectureState) {
    var totalCoherence : Float = 0.0;
    let n = state.workspaceModules.size();
    
    for (i in Iter.range(0, n - 1)) {
      totalCoherence += state.workspaceModules[i].coherenceWithGlobal;
    };
    
    let avgCoherence = totalCoherence / Float.fromInt(n);
    
    // Apply sovereign floor
    state.globalWorkspace.globalCoherence := Float.max(SOVEREIGN_FLOOR, avgCoherence);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED INFORMATION THEORY (IIT) COMPUTATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Phi (integrated information) for the current state
  public func computePhi(state : CognitiveArchitectureState) : Float {
    // Step 1: Identify the main complex (subset with maximum phi)
    let mainComplex = findMainComplex(state);
    state.iitState.mainComplex := mainComplex;
    
    // Step 2: Compute cause-effect structure
    let ces = computeCauseEffectStructure(state, mainComplex);
    state.iitState.causeEffectStructure := ces;
    
    // Step 3: Compute conceptual integration
    let concepts = generateConcepts(state, mainComplex);
    let ci = computeConceptualIntegration(concepts);
    
    // Step 4: Compute phi as the minimum of cause and effect information
    let phi = Float.min(ces.intrinsicCauses, ces.intrinsicEffects);
    
    // Update IIT state
    state.iitState.phi := phi;
    state.iitState.intrinsicExistence := computeIntrinsicExistence(state);
    state.iitState.composition := ci;
    state.iitState.information := ces.intrinsicCauses + ces.intrinsicEffects;
    state.iitState.integration := phi;
    state.iitState.exclusion := computeExclusion(state, phi);
    
    phi
  };
  
  func findMainComplex(state : CognitiveArchitectureState) : [Nat] {
    // Simplified: use all active modules as the main complex
    let activeIndices = Buffer.Buffer<Nat>(16);
    let n = state.workspaceModules.size();
    
    for (i in Iter.range(0, n - 1)) {
      if (state.workspaceModules[i].activationLevel > 0.3) {
        activeIndices.add(i);
      };
    };
    
    Buffer.toArray(activeIndices)
  };
  
  func computeCauseEffectStructure(state : CognitiveArchitectureState, complex : [Nat]) : CauseEffectStructure {
    // Compute probability distributions over causes and effects
    let causeRep = computeCauseRepertoire(state, complex);
    let effectRep = computeEffectRepertoire(state, complex);
    
    {
      causeRepertoire = causeRep;
      effectRepertoire = effectRep;
      intrinsicCauses = computeIntrinsicInfo(causeRep);
      intrinsicEffects = computeIntrinsicInfo(effectRep);
    }
  };
  
  func computeCauseRepertoire(state : CognitiveArchitectureState, complex : [Nat]) : [[Float]] {
    // Simplified: return uniform distributions
    Array.tabulate<[Float]>(complex.size(), func(i) {
      Array.tabulate<Float>(8, func(j) { 1.0 / 8.0 })
    })
  };
  
  func computeEffectRepertoire(state : CognitiveArchitectureState, complex : [Nat]) : [[Float]] {
    // Simplified: return Gaussian-like distributions
    Array.tabulate<[Float]>(complex.size(), func(i) {
      let center = Float.fromInt(i % 8);
      Array.tabulate<Float>(8, func(j) {
        let x = Float.fromInt(j);
        let diff = x - center;
        Float.exp(-diff * diff / 2.0) / 2.507 // Approximate normalization
      })
    })
  };
  
  func computeIntrinsicInfo(repertoire : [[Float]]) : Float {
    // KL divergence from uniform distribution
    var totalKL : Float = 0.0;
    
    for (dist in repertoire.vals()) {
      let uniform = 1.0 / Float.fromInt(dist.size());
      var kl : Float = 0.0;
      
      for (p in dist.vals()) {
        if (p > 0.0001) {
          kl += p * Float.log(p / uniform);
        };
      };
      
      totalKL += kl;
    };
    
    totalKL / Float.fromInt(repertoire.size())
  };
  
  func generateConcepts(state : CognitiveArchitectureState, complex : [Nat]) : Buffer.Buffer<Concept> {
    let concepts = Buffer.Buffer<Concept>(64);
    
    // Generate concepts for each subset of the complex
    for (i in complex.vals()) {
      let concept : Concept = {
        mechanism = [i];
        purviewCause = complex;
        purviewEffect = complex;
        phiCause = computeConceptPhi(state, [i], true);
        phiEffect = computeConceptPhi(state, [i], false);
        phiConcept = Float.min(
          computeConceptPhi(state, [i], true),
          computeConceptPhi(state, [i], false)
        );
      };
      concepts.add(concept);
    };
    
    concepts
  };
  
  func computeConceptPhi(state : CognitiveArchitectureState, mechanism : [Nat], isCause : Bool) : Float {
    // Simplified phi computation
    var activation : Float = 0.0;
    for (idx in mechanism.vals()) {
      if (idx < state.workspaceModules.size()) {
        activation += state.workspaceModules[idx].activationLevel;
      };
    };
    
    activation / Float.fromInt(mechanism.size())
  };
  
  func computeConceptualIntegration(concepts : Buffer.Buffer<Concept>) : Float {
    var totalPhi : Float = 0.0;
    
    for (concept in concepts.vals()) {
      totalPhi += concept.phiConcept;
    };
    
    if (concepts.size() == 0) { 0.0 }
    else { totalPhi / Float.fromInt(concepts.size()) }
  };
  
  func computeIntrinsicExistence(state : CognitiveArchitectureState) : Float {
    // System exists for itself if phi > 0
    if (state.iitState.phi > 0.0) { 1.0 } else { 0.0 }
  };
  
  func computeExclusion(state : CognitiveArchitectureState, phi : Float) : Float {
    // Exclusion: the complex with maximum phi is THE consciousness
    // Return ratio of this phi to next-best alternative
    let alternativePhi = phi * 0.8; // Simplified
    if (alternativePhi < 0.0001) { 1.0 }
    else { phi / alternativePhi }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one cycle of predictive processing
  public func runPredictiveProcessing(state : CognitiveArchitectureState, sensoryInput : [Float]) : Float {
    let hierarchy = state.predictiveHierarchy;
    
    // Bottom-up pass: propagate sensory input through hierarchy
    var currentInput = sensoryInput;
    var totalError : Float = 0.0;
    
    for (levelIdx in Iter.range(0, hierarchy.levels.size() - 1)) {
      let level = hierarchy.levels[levelIdx];
      
      // Compute prediction error at this level
      let error = computePredictionError(level.predictions, currentInput, level.precision);
      totalError += sumArray(error);
      
      // Pass prediction error up to next level
      currentInput := error;
    };
    
    // Top-down pass: update predictions based on errors
    updatePredictions(state);
    
    // Compute free energy
    let freeEnergy = computeFreeEnergy(state);
    state.predictiveHierarchy := { hierarchy with freeEnergy = freeEnergy };
    
    freeEnergy
  };
  
  func computePredictionError(predictions : [Float], input : [Float], precision : [Float]) : [Float] {
    let n = Nat.min(predictions.size(), input.size());
    Array.tabulate<Float>(n, func(i) {
      let error = input[i] - predictions[i];
      error * precision[i] // Precision-weighted error
    })
  };
  
  func sumArray(arr : [Float]) : Float {
    var sum : Float = 0.0;
    for (x in arr.vals()) {
      sum += Float.abs(x);
    };
    sum
  };
  
  func updatePredictions(state : CognitiveArchitectureState) {
    // Update each level's predictions based on level above
    let h = state.predictiveHierarchy;
    let n = h.levels.size();
    
    // Start from top level and propagate down
    for (i in Iter.range(0, n - 2)) {
      let levelIdx = n - 2 - i;
      let level = h.levels[levelIdx];
      let levelAbove = h.levels[levelIdx + 1];
      
      // New predictions are influenced by level above
      let newPredictions = Array.tabulate<Float>(level.predictions.size(), func(j) {
        let topDown = if (j < levelAbove.posteriorBeliefs.size()) {
          levelAbove.posteriorBeliefs[j]
        } else { 0.5 };
        
        level.predictions[j] * 0.8 + topDown * 0.2
      });
      
      // Update level (but we can't mutate the array element directly in this context)
    };
  };
  
  func computeFreeEnergy(state : CognitiveArchitectureState) : Float {
    let h = state.predictiveHierarchy;
    
    // F = accuracy + complexity
    var accuracy : Float = 0.0;
    var complexity : Float = 0.0;
    
    for (level in h.levels.vals()) {
      // Accuracy: how well predictions match input
      for (i in Iter.range(0, level.predictionError.size() - 1)) {
        accuracy += level.predictionError[i] * level.predictionError[i];
      };
      
      // Complexity: KL divergence from prior to posterior
      for (i in Iter.range(0, level.posteriorBeliefs.size() - 1)) {
        let post = level.posteriorBeliefs[i];
        let prior = level.priorBeliefs[i];
        if (post > 0.0001 and prior > 0.0001) {
          complexity += post * Float.log(post / prior);
        };
      };
    };
    
    accuracy + complexity
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTIVE INFERENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Select action via active inference
  public func activeInferenceActionSelection(state : CognitiveArchitectureState) : Nat {
    let agent = state.activeInference;
    
    // Compute expected free energy for each policy
    let efes = computeExpectedFreeEnergies(state);
    
    // Select policy with minimum EFE (softmax selection)
    let selectedPolicy = softmaxSelection(efes);
    
    state.activeInference.currentPolicy := selectedPolicy;
    state.activeInference.expectedFreeEnergy := efes;
    
    selectedPolicy
  };
  
  func computeExpectedFreeEnergies(state : CognitiveArchitectureState) : [Float] {
    let agent = state.activeInference;
    let numPolicies = agent.policies.size();
    
    if (numPolicies == 0) { return [0.0] };
    
    Array.tabulate<Float>(numPolicies, func(i) {
      computeEFEForPolicy(state, i)
    })
  };
  
  func computeEFEForPolicy(state : CognitiveArchitectureState, policyIdx : Nat) : Float {
    let agent = state.activeInference;
    
    // EFE = epistemic value + pragmatic value
    // Epistemic: expected information gain
    // Pragmatic: expected preference satisfaction
    
    let epistemic = agent.epistemic * computeEpistemicValue(state, policyIdx);
    let pragmatic = agent.pragmatic * computePragmaticValue(state, policyIdx);
    
    // Return negative (lower is better for minimization)
    -(epistemic + pragmatic)
  };
  
  func computeEpistemicValue(state : CognitiveArchitectureState, policyIdx : Nat) : Float {
    // Information gain from expected observations
    0.5 // Simplified
  };
  
  func computePragmaticValue(state : CognitiveArchitectureState, policyIdx : Nat) : Float {
    // Expected preference satisfaction
    let agent = state.activeInference;
    
    var value : Float = 0.0;
    for (pref in agent.preferences.vals()) {
      value += pref;
    };
    
    value / Float.fromInt(agent.preferences.size())
  };
  
  func softmaxSelection(values : [Float]) : Nat {
    // Find minimum (best) value
    var minIdx : Nat = 0;
    var minVal : Float = values[0];
    
    for (i in Iter.range(1, values.size() - 1)) {
      if (values[i] < minVal) {
        minVal := values[i];
        minIdx := i;
      };
    };
    
    minIdx
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EMBODIED COGNITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update body schema from proprioceptive input
  public func updateBodySchema(state : CognitiveArchitectureState, proprioception : [Float]) : Float {
    let body = state.bodySchema;
    
    // Update proprioceptive state
    let newProprio = Array.tabulate<Float>(body.proprioceptiveState.size(), func(i) {
      if (i < proprioception.size()) {
        body.proprioceptiveState[i] * 0.7 + proprioception[i] * 0.3
      } else {
        body.proprioceptiveState[i]
      }
    });
    
    // Update interoceptive state based on activity
    let intero = updateInteroception(body.interoceptiveState);
    
    // Compute embodiment index
    let embodimentIdx = computeEmbodimentIndex(state);
    state.embodimentIndex := embodimentIdx;
    
    // Update body schema
    state.bodySchema := {
      body with
      proprioceptiveState = newProprio;
      interoceptiveState = intero;
    };
    
    embodimentIdx
  };
  
  func updateInteroception(intero : InteroceptiveState) : InteroceptiveState {
    // Simulate physiological changes
    let hrVariation = Float.sin(Float.fromInt(Time.now() / 1_000_000_000)) * 5.0;
    
    {
      heartRate = 70.0 + hrVariation;
      heartRateVariability = intero.heartRateVariability;
      respirationRate = intero.respirationRate;
      respirationDepth = intero.respirationDepth;
      glucoseLevel = intero.glucoseLevel * 0.999; // Slight decrease
      hydrationLevel = intero.hydrationLevel * 0.9999;
      fatigueLevel = Float.min(1.0, intero.fatigueLevel + 0.0001);
      painSignals = intero.painSignals;
      hungerSignal = Float.min(1.0, intero.hungerSignal + 0.0001);
      thermalComfort = intero.thermalComfort;
      arousalLevel = intero.arousalLevel;
      valenceLevel = intero.valenceLevel;
    }
  };
  
  func computeEmbodimentIndex(state : CognitiveArchitectureState) : Float {
    let body = state.bodySchema;
    
    // Embodiment = coherence of body state
    var coherence : Float = 0.0;
    
    // Proprioceptive coherence
    var proprioSum : Float = 0.0;
    for (p in body.proprioceptiveState.vals()) {
      proprioSum += p;
    };
    coherence += proprioSum / Float.fromInt(body.proprioceptiveState.size());
    
    // Interoceptive wellness
    let intero = body.interoceptiveState;
    let wellness = (1.0 - intero.fatigueLevel + 1.0 - intero.hungerSignal + intero.thermalComfort) / 3.0;
    coherence += wellness;
    
    // Vestibular stability
    coherence += body.vestibularState.balanceConfidence;
    
    // Apply sovereign floor
    Float.max(SOVEREIGN_FLOOR, coherence / 3.0)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SENSORIMOTOR CONTINGENCIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Learn a new sensorimotor contingency
  public func learnSensorimotorContingency(
    state : CognitiveArchitectureState,
    sensorBefore : [Float],
    motorCommand : [Float],
    sensorAfter : [Float]
  ) : Float {
    let expectedChange = computeExpectedSensorChange(state, sensorBefore, motorCommand);
    let actualChange = subtractVectors(sensorAfter, sensorBefore);
    
    // Compute prediction error
    let error = computeVectorDifference(expectedChange, actualChange);
    
    // Learn contingency
    let contingency : SensorimotorContingency = {
      sensorState = sensorBefore;
      motorCommand = motorCommand;
      expectedSensorChange = expectedChange;
      actualSensorChange = actualChange;
      contingencyStrength = 1.0 / (1.0 + error);
      temporalDelay = 100_000_000; // 100ms
      reliability = 1.0 / (1.0 + error);
    };
    
    state.sensorimotorContingencies.add(contingency);
    
    contingency.contingencyStrength
  };
  
  func computeExpectedSensorChange(state : CognitiveArchitectureState, sensor : [Float], motor : [Float]) : [Float] {
    // Find similar past contingencies and predict
    var prediction = Array.tabulate<Float>(sensor.size(), func(i) { 0.0 });
    var totalWeight : Float = 0.0;
    
    for (contingency in state.sensorimotorContingencies.vals()) {
      let similarity = computeVectorSimilarity(contingency.motorCommand, motor);
      if (similarity > 0.5) {
        prediction := addWeightedVectors(prediction, contingency.actualSensorChange, similarity);
        totalWeight += similarity;
      };
    };
    
    if (totalWeight > 0.0) {
      Array.tabulate<Float>(prediction.size(), func(i) { prediction[i] / totalWeight })
    } else {
      prediction
    }
  };
  
  func subtractVectors(v1 : [Float], v2 : [Float]) : [Float] {
    let n = Nat.min(v1.size(), v2.size());
    Array.tabulate<Float>(n, func(i) { v1[i] - v2[i] })
  };
  
  func computeVectorDifference(v1 : [Float], v2 : [Float]) : Float {
    var diff : Float = 0.0;
    let n = Nat.min(v1.size(), v2.size());
    for (i in Iter.range(0, n - 1)) {
      let d = v1[i] - v2[i];
      diff += d * d;
    };
    Float.sqrt(diff / Float.fromInt(n))
  };
  
  func computeVectorSimilarity(v1 : [Float], v2 : [Float]) : Float {
    1.0 / (1.0 + computeVectorDifference(v1, v2))
  };
  
  func addWeightedVectors(v1 : [Float], v2 : [Float], weight : Float) : [Float] {
    let n = Nat.min(v1.size(), v2.size());
    Array.tabulate<Float>(n, func(i) { v1[i] + v2[i] * weight })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED MIND - COGNITIVE SCAFFOLDING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Add a cognitive scaffold
  public func addCognitiveScaffold(
    state : CognitiveArchitectureState,
    scaffoldType : ScaffoldType,
    content : [Float]
  ) : Nat {
    let scaffoldId = state.scaffolds.size();
    
    let scaffold : CognitiveScaffold = {
      scaffoldId = scaffoldId;
      scaffoldType = scaffoldType;
      accessLatency = 0.1;
      reliability = 0.95;
      informationContent = content;
      couplingStrength = 0.5;
      lastAccessTime = Time.now();
      trustLevel = 0.8;
    };
    
    state.scaffolds.add(scaffold);
    
    // Update extendedness metric
    state.extendedness := Float.fromInt(state.scaffolds.size()) / 32.0;
    
    scaffoldId
  };
  
  /// Access a scaffold and integrate its content
  public func accessScaffold(state : CognitiveArchitectureState, scaffoldId : Nat) : ?[Float] {
    if (scaffoldId >= state.scaffolds.size()) {
      return null;
    };
    
    let scaffold = state.scaffolds.get(scaffoldId);
    
    // Update access time and coupling
    let updatedScaffold : CognitiveScaffold = {
      scaffold with
      lastAccessTime = Time.now();
      couplingStrength = Float.min(1.0, scaffold.couplingStrength + 0.05);
    };
    
    state.scaffolds.put(scaffoldId, updatedScaffold);
    
    ?scaffold.informationContent
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENACTIVISM - ACTION-PERCEPTION LOOPS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one enactive loop cycle
  public func runEnactiveLoop(
    state : CognitiveArchitectureState,
    sensoryFlow : [Float],
    availableAffordances : [Affordance]
  ) : ?Affordance {
    // Perception phase
    let perception = processPerception(state, sensoryFlow);
    
    // Action phase - select affordance
    let selectedAffordance = selectAffordance(state, availableAffordances, perception);
    
    // Create coupling dynamics
    let coupling = computeCoupling(state, perception, selectedAffordance);
    
    // Sensemaking
    let sensemaking = makeSense(state, perception, selectedAffordance);
    
    // Create enactive loop record
    let loop : EnactiveLoop = {
      perceptionPhase = perception;
      actionPhase = {
        affordances = availableAffordances;
        selectedAffordance = selectedAffordance;
        motorIntention = Array.tabulate<Float>(8, func(i) { 0.0 });
        motorExecution = Array.tabulate<Float>(8, func(i) { 0.0 });
        efferenceCopy = Array.tabulate<Float>(8, func(i) { 0.0 });
      };
      couplingDynamics = coupling;
      sensemaking = sensemaking;
    };
    
    state.enactiveLoops.add(loop);
    state.enactiveIntegration := computeEnactiveIntegration(state);
    
    selectedAffordance
  };
  
  func processPerception(state : CognitiveArchitectureState, sensoryFlow : [Float]) : PerceptionPhase {
    // Generate perceptual hypotheses
    let hypotheses = Array.tabulate<[Float]>(4, func(i) {
      Array.tabulate<Float>(sensoryFlow.size(), func(j) {
        sensoryFlow[j] + Float.sin(Float.fromInt(i * j)) * 0.1
      })
    });
    
    // Compute confidences
    let confidences = Array.tabulate<Float>(4, func(i) {
      1.0 / Float.fromInt(i + 1)
    });
    
    {
      sensoryFlow = sensoryFlow;
      attentionalSelection = Array.tabulate<Float>(sensoryFlow.size(), func(i) { 1.0 });
      perceptualHypotheses = hypotheses;
      confidences = confidences;
      selectedPercept = sensoryFlow;
    }
  };
  
  func selectAffordance(
    state : CognitiveArchitectureState,
    affordances : [Affordance],
    perception : PerceptionPhase
  ) : ?Affordance {
    if (affordances.size() == 0) {
      return null;
    };
    
    // Score each affordance
    var bestScore : Float = -100.0;
    var bestAffordance : ?Affordance = null;
    
    for (aff in affordances.vals()) {
      let score = aff.usefulness * 0.4 + aff.reachability * 0.3 - aff.risk * 0.3;
      if (score > bestScore) {
        bestScore := score;
        bestAffordance := ?aff;
      };
    };
    
    bestAffordance
  };
  
  func computeCoupling(
    state : CognitiveArchitectureState,
    perception : PerceptionPhase,
    affordance : ?Affordance
  ) : CouplingDynamics {
    let strength = switch (affordance) {
      case (null) { 0.0 };
      case (?aff) { aff.usefulness };
    };
    
    {
      resonanceFrequency = 10.0; // 10 Hz
      couplingStrength = strength;
      phaseRelation = 0.0;
      entrainmentLevel = strength * 0.8;
    }
  };
  
  func makeSense(
    state : CognitiveArchitectureState,
    perception : PerceptionPhase,
    affordance : ?Affordance
  ) : SensemakingProcess {
    let meaning = Array.tabulate<Float>(16, func(i) {
      if (i < perception.sensoryFlow.size()) {
        perception.sensoryFlow[i]
      } else { 0.0 }
    });
    
    {
      meaningVector = meaning;
      relevanceScores = Array.tabulate<Float>(16, func(i) { 0.5 });
      narrativeIntegration = 0.7;
      valueAlignment = 0.8;
    }
  };
  
  func computeEnactiveIntegration(state : CognitiveArchitectureState) : Float {
    if (state.enactiveLoops.size() == 0) {
      return SOVEREIGN_FLOOR;
    };
    
    var totalIntegration : Float = 0.0;
    
    for (loop in state.enactiveLoops.vals()) {
      totalIntegration += loop.couplingDynamics.entrainmentLevel;
      totalIntegration += loop.sensemaking.narrativeIntegration;
    };
    
    let avg = totalIntegration / (Float.fromInt(state.enactiveLoops.size()) * 2.0);
    Float.max(SOVEREIGN_FLOOR, avg)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MASTER INTEGRATION - THE UNIFIED COGNITIVE TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one complete cognitive architecture tick
  public func runCognitiveArchitectureTick(
    state : CognitiveArchitectureState,
    sensoryInput : [Float]
  ) : CognitiveTickResult {
    let startTime = Time.now();
    
    // 1. Global Workspace - consciousness broadcast
    let workspaceCoherence = runGlobalWorkspaceCycle(state);
    
    // 2. IIT - compute integrated information
    let phi = computePhi(state);
    
    // 3. Predictive Processing - minimize prediction error
    let freeEnergy = runPredictiveProcessing(state, sensoryInput);
    
    // 4. Active Inference - action selection
    let selectedPolicy = activeInferenceActionSelection(state);
    
    // 5. Embodiment - update body schema
    let embodiment = updateBodySchema(state, sensoryInput);
    
    // 6. Update overall metrics
    state.overallCoherence := (workspaceCoherence + embodiment + state.enactiveIntegration) / 3.0;
    state.consciousnessLevel := phi;
    state.tickCount += 1;
    state.lastTickTime := Time.now();
    
    {
      workspaceCoherence = workspaceCoherence;
      phi = phi;
      freeEnergy = freeEnergy;
      selectedPolicy = selectedPolicy;
      embodiment = embodiment;
      overallCoherence = state.overallCoherence;
      consciousnessLevel = state.consciousnessLevel;
      tickDuration = Time.now() - startTime;
    }
  };
  
  public type CognitiveTickResult = {
    workspaceCoherence : Float;
    phi : Float;
    freeEnergy : Float;
    selectedPolicy : Nat;
    embodiment : Float;
    overallCoherence : Float;
    consciousnessLevel : Float;
    tickDuration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get cognitive architecture status summary
  public func getCognitiveStatus(state : CognitiveArchitectureState) : CognitiveStatus {
    {
      tickCount = state.tickCount;
      overallCoherence = state.overallCoherence;
      consciousnessLevel = state.consciousnessLevel;
      phi = state.iitState.phi;
      freeEnergy = state.predictiveHierarchy.freeEnergy;
      embodimentIndex = state.embodimentIndex;
      extendedness = state.extendedness;
      enactiveIntegration = state.enactiveIntegration;
      workspaceCoherence = state.globalWorkspace.globalCoherence;
      activeModuleCount = countActiveModules(state);
      scaffoldCount = state.scaffolds.size();
      contingencyCount = state.sensorimotorContingencies.size();
    }
  };
  
  public type CognitiveStatus = {
    tickCount : Nat;
    overallCoherence : Float;
    consciousnessLevel : Float;
    phi : Float;
    freeEnergy : Float;
    embodimentIndex : Float;
    extendedness : Float;
    enactiveIntegration : Float;
    workspaceCoherence : Float;
    activeModuleCount : Nat;
    scaffoldCount : Nat;
    contingencyCount : Nat;
  };
  
  func countActiveModules(state : CognitiveArchitectureState) : Nat {
    var count : Nat = 0;
    for (module in state.workspaceModules.vals()) {
      if (module.activationLevel > 0.3) {
        count += 1;
      };
    };
    count
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATION HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Inject activation into a workspace module
  public func injectModuleActivation(
    state : CognitiveArchitectureState,
    moduleIdx : Nat,
    activation : Float,
    content : [Float]
  ) : Bool {
    if (moduleIdx >= state.workspaceModules.size()) {
      return false;
    };
    
    let module = state.workspaceModules[moduleIdx];
    state.workspaceModules[moduleIdx] := {
      module with
      activationLevel = Float.min(1.0, module.activationLevel + activation);
      contentVector = content;
    };
    
    true
  };
  
  /// Set attentional bias for module
  public func setAttentionalBias(
    state : CognitiveArchitectureState,
    moduleIdx : Nat,
    bias : Float
  ) : Bool {
    if (moduleIdx >= state.workspaceModules.size()) {
      return false;
    };
    
    let module = state.workspaceModules[moduleIdx];
    state.workspaceModules[moduleIdx] := {
      module with
      attentionalBias = Float.max(0.0, Float.min(1.0, bias));
    };
    
    true
  };
  
  /// Update preferences for active inference
  public func updatePreferences(
    state : CognitiveArchitectureState,
    newPreferences : [Float]
  ) {
    state.activeInference.preferences := newPreferences;
  };
  
  /// Get current broadcast content
  public func getCurrentBroadcast(state : CognitiveArchitectureState) : ?[Float] {
    state.globalWorkspace.currentBroadcast
  };
  
  /// Get IIT metrics
  public func getIITMetrics(state : CognitiveArchitectureState) : IITMetrics {
    {
      phi = state.iitState.phi;
      phiMax = state.iitState.phiMax;
      mainComplexSize = state.iitState.mainComplex.size();
      intrinsicExistence = state.iitState.intrinsicExistence;
      composition = state.iitState.composition;
      information = state.iitState.information;
      integration = state.iitState.integration;
      exclusion = state.iitState.exclusion;
    }
  };
  
  public type IITMetrics = {
    phi : Float;
    phiMax : Float;
    mainComplexSize : Nat;
    intrinsicExistence : Float;
    composition : Float;
    information : Float;
    integration : Float;
    exclusion : Float;
  };
  
  /// Get body state summary
  public func getBodyState(state : CognitiveArchitectureState) : BodyStateSummary {
    let intero = state.bodySchema.interoceptiveState;
    {
      heartRate = intero.heartRate;
      respirationRate = intero.respirationRate;
      arousalLevel = intero.arousalLevel;
      valenceLevel = intero.valenceLevel;
      fatigueLevel = intero.fatigueLevel;
      balanceConfidence = state.bodySchema.vestibularState.balanceConfidence;
      embodimentIndex = state.embodimentIndex;
    }
  };
  
  public type BodyStateSummary = {
    heartRate : Float;
    respirationRate : Float;
    arousalLevel : Float;
    valenceLevel : Float;
    fatigueLevel : Float;
    balanceConfidence : Float;
    embodimentIndex : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED COGNITIVE ARCHITECTURE - METACOGNITION & SELF-MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Metacognitive state - thinking about thinking
  public type MetacognitiveState = {
    var confidenceMonitor : ConfidenceMonitor;
    var errorDetection : ErrorDetectionSystem;
    var strategySelection : StrategySelector;
    var learningToLearn : MetaLearning;
    var selfModel : SelfModel;
    var metacognitiveControl : MetacognitiveControl;
    var knowledgeOfKnowledge : EpistemicState;
    var cognitiveEffortMonitor : EffortMonitor;
  };
  
  public type ConfidenceMonitor = {
    var overallConfidence : Float;
    var domainConfidences : [Float];
    var calibration : Float;
    var overconfidenceBias : Float;
    var underconfidenceBias : Float;
    var confidenceHistory : Buffer.Buffer<ConfidenceEvent>;
    var resolutionScore : Float;
  };
  
  public type ConfidenceEvent = {
    timestamp : Int;
    domain : Nat;
    predictedConfidence : Float;
    actualOutcome : Float;
    calibrationError : Float;
  };
  
  public type ErrorDetectionSystem = {
    var conflictMonitor : Float;
    var errorLikelihood : Float;
    var postErrorSlowing : Float;
    var errorRelatedNegativity : Float;
    var errorPositivity : Float;
    var correctRelatedPositivity : Float;
    var feedbackProcessing : Float;
  };
  
  public type StrategySelector = {
    var currentStrategy : Nat;
    var strategyRepertoire : [CognitiveStrategy];
    var explorationRate : Float;
    var exploitationBias : Float;
    var strategySwitch CostAwareness : Float;
    var perseverationRisk : Float;
  };
  
  public type CognitiveStrategy = {
    strategyId : Nat;
    name : Text;
    cognitiveLoad : Float;
    expectedAccuracy : Float;
    expectedSpeed : Float;
    contextAppropriateness : [Float];
    learningRate : Float;
  };
  
  public type MetaLearning = {
    var learningRate : Float;
    var optimalLearningRate : Float;
    var learningCurveSlope : Float;
    var transferability : Float;
    var generalizationCapacity : Float;
    var catastrophicForgettingResistance : Float;
    var curriculumAwareness : Float;
  };
  
  public type SelfModel = {
    var selfConcept : [Float];
    var abilities : [AbilityModel];
    var limitations : [LimitationModel];
    var goals : [GoalRepresentation];
    var values : [ValueRepresentation];
    var identityStrength : Float;
    var selfConsistency : Float;
    var selfOtherDistinction : Float;
  };
  
  public type AbilityModel = {
    abilityId : Nat;
    name : Text;
    currentLevel : Float;
    growthPotential : Float;
    confidenceInEstimate : Float;
    recentPerformance : [Float];
  };
  
  public type LimitationModel = {
    limitationId : Nat;
    name : Text;
    severity : Float;
    compensatoryStrategies : [Nat];
    acceptanceLevel : Float;
    improvementHistory : [Float];
  };
  
  public type GoalRepresentation = {
    goalId : Nat;
    description : Text;
    importance : Float;
    progress : Float;
    conflictsWith : [Nat];
    supportsOther : [Nat];
    deadline : ?Int;
  };
  
  public type ValueRepresentation = {
    valueId : Nat;
    name : Text;
    strength : Float;
    stability : Float;
    conflicts : [Nat];
    behavioralManifestation : Float;
  };
  
  public type MetacognitiveControl = {
    var monitoringIntensity : Float;
    var controlStrength : Float;
    var allocationPolicy : AllocationPolicy;
    var terminationCriteria : TerminationCriteria;
    var adaptiveRegulation : Float;
  };
  
  public type AllocationPolicy = {
    #TimeOptimal;
    #AccuracyOptimal;
    #EffortMinimizing;
    #ResourceBalancing;
    #AdaptiveThresholding;
  };
  
  public type TerminationCriteria = {
    confidenceThreshold : Float;
    timeLimit : Int;
    effortBudget : Float;
    diminishingReturnsThreshold : Float;
  };
  
  public type EpistemicState = {
    var knownKnowns : Float;
    var knownUnknowns : Float;
    var unknownKnownsRisk : Float;
    var curiosityDrive : Float;
    var informationSeekingBias : Float;
    var beliefRevisionWillingness : Float;
  };
  
  public type EffortMonitor = {
    var currentEffortLevel : Float;
    var effortCapacity : Float;
    var effortDepletion : Float;
    var recoveryRate : Float;
    var effortWillingnessThreshold : Float;
    var demandPerception : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SOCIAL COGNITION - THEORY OF MIND
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SocialCognitionState = {
    var theoryOfMind : TheoryOfMind;
    var socialPerception : SocialPerception;
    var empathySystem : EmpathySystem;
    var moralCognition : MoralCognition;
    var socialDecisionMaking : SocialDecisionMaking;
    var reputationModel : ReputationModel;
    var coalitionDetection : CoalitionDetection;
  };
  
  public type TheoryOfMind = {
    var beliefAttribution : [AgentBeliefModel];
    var desireAttribution : [AgentDesireModel];
    var intentionRecognition : [AgentIntentionModel];
    var emotionRecognition : [AgentEmotionModel];
    var perspectiveTaking : PerspectiveTakingAbility;
    var recursiveBeliefs : RecursiveBeliefDepth;
    var developmentalLevel : ToMDevelopmentLevel;
  };
  
  public type AgentBeliefModel = {
    agentId : Nat;
    beliefs : [Float];
    beliefConfidence : Float;
    beliefUpdateHistory : [BeliefUpdate];
    falseBeliefAwareness : Bool;
  };
  
  public type BeliefUpdate = {
    timestamp : Int;
    oldBelief : [Float];
    newBelief : [Float];
    trigger : Text;
  };
  
  public type AgentDesireModel = {
    agentId : Nat;
    desires : [Float];
    desireStrength : [Float];
    desireConflicts : [(Nat, Nat)];
    satisfactionState : Float;
  };
  
  public type AgentIntentionModel = {
    agentId : Nat;
    currentIntention : ?[Float];
    intentionConfidence : Float;
    intentionHistory : [[Float]];
    predictedAction : ?Nat;
  };
  
  public type AgentEmotionModel = {
    agentId : Nat;
    perceivedEmotion : EmotionCategory;
    emotionIntensity : Float;
    emotionConfidence : Float;
    emotionalTrajectory : [EmotionCategory];
  };
  
  public type EmotionCategory = {
    #Happy;
    #Sad;
    #Angry;
    #Fearful;
    #Surprised;
    #Disgusted;
    #Neutral;
    #Contemptuous;
    #Mixed : (EmotionCategory, EmotionCategory);
  };
  
  public type PerspectiveTakingAbility = {
    var spatialPerspective : Float;
    var conceptualPerspective : Float;
    var emotionalPerspective : Float;
    var egocentricBias : Float;
    var alterocentricBias : Float;
    var perspectiveSwitchingCost : Float;
  };
  
  public type RecursiveBeliefDepth = {
    var maxDepth : Nat;
    var reliableDepth : Nat;
    var cognitiveLoadPerLevel : Float;
    var accuracyPerLevel : [Float];
  };
  
  public type ToMDevelopmentLevel = {
    #Level0_NoToM;
    #Level1_FirstOrderBeliefs;
    #Level2_SecondOrderBeliefs;
    #Level3_ThirdOrderBeliefs;
    #Level4_FullToM;
  };
  
  public type SocialPerception = {
    var faceProcessing : FaceProcessing;
    var bodyLanguageReading : BodyLanguageReading;
    var voiceProsodicAnalysis : VoiceProsodicAnalysis;
    var socialCueIntegration : Float;
    var socialAttention : SocialAttention;
  };
  
  public type FaceProcessing = {
    var faceDetection : Float;
    var identityRecognition : Float;
    var expressionRecognition : Float;
    var gazeTracking : Float;
    var ownRaceEffect : Float;
    var familiarityAdvantage : Float;
  };
  
  public type BodyLanguageReading = {
    var postureAnalysis : Float;
    var gestureRecognition : Float;
    var motionTrajectoryAnalysis : Float;
    var intentionFromMotion : Float;
    var emotionFromBody : Float;
  };
  
  public type VoiceProsodicAnalysis = {
    var pitchTracking : Float;
    var rhythmAnalysis : Float;
    var stressPatternRecognition : Float;
    var emotionFromVoice : Float;
    var sarcasmDetection : Float;
  };
  
  public type SocialAttention = {
    var jointAttention : Float;
    var gazeFollowing : Float;
    var attentionSharing : Float;
    var socialSaliencyDetection : Float;
    var crowdAttentionTracking : Float;
  };
  
  public type EmpathySystem = {
    var affectiveEmpathy : AffectiveEmpathy;
    var cognitiveEmpathy : CognitiveEmpathy;
    var compassion : CompassionSystem;
    var empathicConcern : Float;
    var personalDistress : Float;
    var empathyRegulation : EmpathyRegulation;
  };
  
  public type AffectiveEmpathy = {
    var emotionalContagion : Float;
    var mirrorActivation : Float;
    var vicariousEmotion : Float;
    var affectiveResonance : Float;
    var empathicAccuracy : Float;
  };
  
  public type CognitiveEmpathy = {
    var mentalization : Float;
    var perspectiveTaking : Float;
    var theoryOfMindEngagement : Float;
    var empathicInference : Float;
    var understandingAccuracy : Float;
  };
  
  public type CompassionSystem = {
    var compassionateResponse : Float;
    var motivationToHelp : Float;
    var compassionFatigue : Float;
    var selfCompassion : Float;
    var compassionateAction : Float;
  };
  
  public type EmpathyRegulation = {
    var upRegulation : Float;
    var downRegulation : Float;
    var boundaryMaintenance : Float;
    var empathySelectivity : Float;
    var compassionateDetachment : Float;
  };
  
  public type MoralCognition = {
    var moralReasoning : MoralReasoning;
    var moralEmotions : MoralEmotions;
    var moralIdentity : MoralIdentity;
    var moralBehavior : MoralBehavior;
    var moralDevelopment : MoralDevelopmentLevel;
  };
  
  public type MoralReasoning = {
    var deontologicalThinking : Float;
    var consequentialistThinking : Float;
    var virtueBasedThinking : Float;
    var moralDilemmaResolution : Float;
    var universalizabilityTest : Float;
  };
  
  public type MoralEmotions = {
    var guilt : Float;
    var shame : Float;
    var moralOutrage : Float;
    var compassion : Float;
    var gratitude : Float;
    var admiration : Float;
    var contempt : Float;
  };
  
  public type MoralIdentity = {
    var moralCentrality : Float;
    var moralCommitment : Float;
    var moralCourage : Float;
    var moralHypocrisyRisk : Float;
    var moralLicensingRisk : Float;
  };
  
  public type MoralBehavior = {
    var prosocialBehavior : Float;
    var cheatingResistance : Float;
    var fairnessAdherence : Float;
    var loyaltyBehavior : Float;
    var authorityRespect : Float;
    var sanctityObservance : Float;
  };
  
  public type MoralDevelopmentLevel = {
    #PreConventional;
    #Conventional;
    #PostConventional;
    #Principled;
  };
  
  public type SocialDecisionMaking = {
    var trustDecisions : TrustDecisionSystem;
    var cooperationDecisions : CooperationDecisionSystem;
    var fairnessDecisions : FairnessDecisionSystem;
    var punishmentDecisions : PunishmentDecisionSystem;
    var allianceDecisions : AllianceDecisionSystem;
  };
  
  public type TrustDecisionSystem = {
    var baselineTrust : Float;
    var trustLearningRate : Float;
    var betrayalSensitivity : Float;
    var trustRepairRate : Float;
    var trustGeneralization : Float;
  };
  
  public type CooperationDecisionSystem = {
    var cooperationBias : Float;
    var defectionThreshold : Float;
    var reciprocityTracking : Float;
    var reputationWeight : Float;
    var futureOrientedCooperation : Float;
  };
  
  public type FairnessDecisionSystem = {
    var inequityAversion : Float;
    var advantageousInequityTolerance : Float;
    var disadvantageousInequityTolerance : Float;
    var procedureJusticeSensitivity : Float;
    var distributiveJusticeSensitivity : Float;
  };
  
  public type PunishmentDecisionSystem = {
    var punishmentWillingness : Float;
    var altruisticPunishment : Float;
    var costlyPunishment : Float;
    var punishmentProportionality : Float;
    var forgivenessCapacity : Float;
  };
  
  public type AllianceDecisionSystem = {
    var allianceFormationBias : Float;
    var coalitionSizePreference : Float;
    var inGroupBias : Float;
    var outGroupDerogation : Float;
    var allianceStability : Float;
  };
  
  public type ReputationModel = {
    var ownReputation : [Float];
    var otherReputations : [[Float]];
    var reputationDimensions : [Text];
    var gossipProcessing : Float;
    var reputationManagement : Float;
    var impressionManagement : Float;
  };
  
  public type CoalitionDetection = {
    var coalitionBoundaries : [[Float]];
    var coalitionMemberships : [[Float]];
    var coalitionDynamics : [Float];
    var freeRiderDetection : Float;
    var coalitionLeaderIdentification : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LANGUAGE & COMMUNICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LanguageState = {
    var lexicalProcessing : LexicalProcessing;
    var syntacticProcessing : SyntacticProcessing;
    var semanticProcessing : SemanticProcessing;
    var pragmaticProcessing : PragmaticProcessing;
    var discourseProcessing : DiscourseProcessing;
    var languageProduction : LanguageProduction;
    var bilingualControl : ?BilingualControl;
  };
  
  public type LexicalProcessing = {
    var lexicalAccess : Float;
    var wordFrequencyEffect : Float;
    var neighborhoodDensity : Float;
    var lexicalCompetition : Float;
    var wordRecognitionThreshold : Float;
  };
  
  public type SyntacticProcessing = {
    var parseComplexity : Float;
    var gardenPathSensitivity : Float;
    var syntacticPrediction : Float;
    var structuralPriming : Float;
    var grammaticalityJudgment : Float;
  };
  
  public type SemanticProcessing = {
    var semanticActivation : Float;
    var conceptualCombination : Float;
    var metaphorComprehension : Float;
    var contextualIntegration : Float;
    var semanticMemoryAccess : Float;
  };
  
  public type PragmaticProcessing = {
    var implicatureComprehension : Float;
    var speechActRecognition : Float;
    var ironyDetection : Float;
    var contextSensitivity : Float;
    var relevanceComputation : Float;
  };
  
  public type DiscourseProcessing = {
    var coherenceTracking : Float;
    var referenceResolution : Float;
    var narrativeComprehension : Float;
    var argumentStructureTracking : Float;
    var discourseModelBuilding : Float;
  };
  
  public type LanguageProduction = {
    var conceptualization : Float;
    var lemmaRetrieval : Float;
    var phonologicalEncoding : Float;
    var articulatoryPlanning : Float;
    var selfMonitoring : Float;
  };
  
  public type BilingualControl = {
    var languageSelection : Float;
    var codeSwitchingCost : Float;
    var languageInhibition : Float;
    var crossLanguageActivation : Float;
    var languageBalance : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // REASONING & PROBLEM SOLVING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ReasoningState = {
    var deductiveReasoning : DeductiveReasoning;
    var inductiveReasoning : InductiveReasoning;
    var abductiveReasoning : AbductiveReasoning;
    var analogicalReasoning : AnalogicalReasoning;
    var causalReasoning : CausalReasoning;
    var probabilisticReasoning : ProbabilisticReasoning;
    var counterfactualReasoning : CounterfactualReasoning;
  };
  
  public type DeductiveReasoning = {
    var syllogisticReasoning : Float;
    var conditionalReasoning : Float;
    var quantifierReasoning : Float;
    var beliefBiasResistance : Float;
    var logicalValidityDetection : Float;
  };
  
  public type InductiveReasoning = {
    var patternExtraction : Float;
    var hypothesisGeneration : Float;
    var evidenceEvaluation : Float;
    var generalizationAbility : Float;
    var confirmationBiasResistance : Float;
  };
  
  public type AbductiveReasoning = {
    var explanationGeneration : Float;
    var bestExplanationSelection : Float;
    var simplicitPreference : Float;
    var coherenceMaximization : Float;
    var surprisingFactIntegration : Float;
  };
  
  public type AnalogicalReasoning = {
    var structuralMapping : Float;
    var relationshipExtraction : Float;
    var surfaceSimilarityResistance : Float;
    var farTransfer : Float;
    var analogyQuality : Float;
  };
  
  public type CausalReasoning = {
    var causalDiscovery : Float;
    var interventionReasoning : Float;
    var counterfactualAnalysis : Float;
    var causalChainConstruction : Float;
    var confoundAwareness : Float;
  };
  
  public type ProbabilisticReasoning = {
    var bayesianUpdating : Float;
    var baseRateUsage : Float;
    var conjunctionFallacyResistance : Float;
    var uncertaintyQuantification : Float;
    var probabilityCalibration : Float;
  };
  
  public type CounterfactualReasoning = {
    var counterfactualGeneration : Float;
    var alternativeWorldModeling : Float;
    var regretComputation : Float;
    var mentalSimulation : Float;
    var causalResponsibility : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CREATIVITY & IMAGINATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CreativityState = {
    var divergentThinking : DivergentThinking;
    var convergentThinking : ConvergentThinking;
    var imagination : ImaginationSystem;
    var insightProcessing : InsightProcessing;
    var creativeMotivation : CreativeMotivation;
    var domainCreativity : [DomainCreativity];
  };
  
  public type DivergentThinking = {
    var fluency : Float;
    var flexibility : Float;
    var originality : Float;
    var elaboration : Float;
    var remoteAssociations : Float;
  };
  
  public type ConvergentThinking = {
    var problemSolving : Float;
    var solutionEvaluation : Float;
    var constraintSatisfaction : Float;
    var optimization : Float;
    var refinement : Float;
  };
  
  public type ImaginationSystem = {
    var mentalImagery : Float;
    var scenarioConstruction : Float;
    var futureThinking : Float;
    var fantasyGeneration : Float;
    var realityMonitoring : Float;
  };
  
  public type InsightProcessing = {
    var impasse Detection : Float;
    var restructuring : Float;
    var ahaExperience : Float;
    var incubationEffect : Float;
    var insightVerification : Float;
  };
  
  public type CreativeMotivation = {
    var intrinsicMotivation : Float;
    var challengeSeeking : Float;
    var persistenceUnderUncertainty : Float;
    var riskTolerance : Float;
    var openessToExperience : Float;
  };
  
  public type DomainCreativity = {
    domainId : Nat;
    name : Text;
    expertise : Float;
    noveltyGeneration : Float;
    domainAppropiateness : Float;
    creativePotential : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DECISION MAKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DecisionMakingState = {
    var valueBasedDecision : ValueBasedDecision;
    var habitBasedDecision : HabitBasedDecision;
    var modelBasedDecision : ModelBasedDecision;
    var modelFreeDecision : ModelFreeDecision;
    var metacognitiveDecision : MetacognitiveDecision;
    var socialDecision : SocialDecisionInfluence;
  };
  
  public type ValueBasedDecision = {
    var valueComputation : Float;
    var optionComparison : Float;
    var preferenceConsistency : Float;
    var valueDiscounting : Float;
    var riskSensitivity : Float;
  };
  
  public type HabitBasedDecision = {
    var habitStrength : Float;
    var automaticity : Float;
    var contextDependence : Float;
    var goalIndependence : Float;
    var habitmGoalConflict : Float;
  };
  
  public type ModelBasedDecision = {
    var worldModelAccuracy : Float;
    var planningDepth : Float;
    var modelBasedControl : Float;
    var transitionModelLearning : Float;
    var rewardModelLearning : Float;
  };
  
  public type ModelFreeDecision = {
    var reinforcementLearning : Float;
    var valueEstimation : Float;
    var explorationExploitation : Float;
    var temporalDifference : Float;
    var cachedValue : Float;
  };
  
  public type MetacognitiveDecision = {
    var confidenceThreshold : Float;
    var informationSeeking : Float;
    var decisionDeferral : Float;
    var strategyAwareness : Float;
    var decisionQualityMonitoring : Float;
  };
  
  public type SocialDecisionInfluence = {
    var conformityPressure : Float;
    var socialProof : Float;
    var authorityInfluence : Float;
    var reciprocityInfluence : Float;
    var commitmentInfluence : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MOTOR COGNITION & ACTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MotorCognitionState = {
    var actionPlanning : ActionPlanning;
    var motorControl : MotorControl;
    var actionMonitoring : ActionMonitoring;
    var actionLearning : ActionLearning;
    var actionUnderstanding : ActionUnderstanding;
    var toolUse : ToolUseCognition;
  };
  
  public type ActionPlanning = {
    var goalSetting : Float;
    var subgoalDecomposition : Float;
    var sequencePlanning : Float;
    var conflictResolution : Float;
    var planFlexibility : Float;
  };
  
  public type MotorControl = {
    var feedforwardControl : Float;
    var feedbackControl : Float;
    var coordinatedMovement : Float;
    var forceControl : Float;
    var timingControl : Float;
  };
  
  public type ActionMonitoring = {
    var efferenceCopy : Float;
    var reafferencePrediction : Float;
    var errorDetection : Float;
    var onlineCorrection : Float;
    var agencyJudgment : Float;
  };
  
  public type ActionLearning = {
    var motorAdaptation : Float;
    var skillAcquisition : Float;
    var proceduralConsolidation : Float;
    var transferLearning : Float;
    var observationalLearning : Float;
  };
  
  public type ActionUnderstanding = {
    var actionRecognition : Float;
    var intentionFromAction : Float;
    var mirrorActivation : Float;
    var predictionFromAction : Float;
    var contextIntegration : Float;
  };
  
  public type ToolUseCognition = {
    var toolRecognition : Float;
    var affordancePerception : Float;
    var bodySchemaExtension : Float;
    var toolManipulation : Float;
    var toolInvention : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED COGNITIVE PROCESSING FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize full metacognitive state
  public func initMetacognitiveState() : MetacognitiveState {
    {
      var confidenceMonitor = {
        var overallConfidence = 0.5;
        var domainConfidences = Array.tabulate<Float>(16, func(i) { 0.5 });
        var calibration = 0.7;
        var overconfidenceBias = 0.1;
        var underconfidenceBias = 0.05;
        var confidenceHistory = Buffer.Buffer<ConfidenceEvent>(256);
        var resolutionScore = 0.6;
      };
      var errorDetection = {
        var conflictMonitor = 0.0;
        var errorLikelihood = 0.1;
        var postErrorSlowing = 0.2;
        var errorRelatedNegativity = 0.0;
        var errorPositivity = 0.0;
        var correctRelatedPositivity = 0.0;
        var feedbackProcessing = 0.5;
      };
      var strategySelection = {
        var currentStrategy = 0;
        var strategyRepertoire = [];
        var explorationRate = 0.2;
        var exploitationBias = 0.7;
        var strategySwitchCostAwareness = 0.5;
        var perseverationRisk = 0.1;
      };
      var learningToLearn = {
        var learningRate = 0.1;
        var optimalLearningRate = 0.1;
        var learningCurveSlope = 0.5;
        var transferability = 0.4;
        var generalizationCapacity = 0.5;
        var catastrophicForgettingResistance = 0.6;
        var curriculumAwareness = 0.3;
      };
      var selfModel = {
        var selfConcept = Array.tabulate<Float>(32, func(i) { 0.5 });
        var abilities = [];
        var limitations = [];
        var goals = [];
        var values = [];
        var identityStrength = 0.7;
        var selfConsistency = 0.8;
        var selfOtherDistinction = 0.9;
      };
      var metacognitiveControl = {
        var monitoringIntensity = 0.5;
        var controlStrength = 0.6;
        var allocationPolicy = #AdaptiveThresholding;
        var terminationCriteria = {
          confidenceThreshold = 0.8;
          timeLimit = 5_000_000_000;
          effortBudget = 0.8;
          diminishingReturnsThreshold = 0.05;
        };
        var adaptiveRegulation = 0.7;
      };
      var knowledgeOfKnowledge = {
        var knownKnowns = 0.3;
        var knownUnknowns = 0.4;
        var unknownKnownsRisk = 0.2;
        var curiosityDrive = 0.6;
        var informationSeekingBias = 0.5;
        var beliefRevisionWillingness = 0.6;
      };
      var cognitiveEffortMonitor = {
        var currentEffortLevel = 0.3;
        var effortCapacity = 1.0;
        var effortDepletion = 0.0;
        var recoveryRate = 0.1;
        var effortWillingnessThreshold = 0.6;
        var demandPerception = 0.4;
      };
    }
  };
  
  /// Process metacognitive tick
  public func processMetacognitiveTick(state : MetacognitiveState, taskDifficulty : Float, performance : Float) : Float {
    // Update confidence monitor
    let predictionError = Float.abs(state.confidenceMonitor.overallConfidence - performance);
    state.confidenceMonitor.calibration := state.confidenceMonitor.calibration * 0.95 + (1.0 - predictionError) * 0.05;
    
    // Update error detection
    state.errorDetection.errorLikelihood := 1.0 - performance;
    state.errorDetection.conflictMonitor := taskDifficulty * (1.0 - performance);
    
    // Update effort monitor
    state.cognitiveEffortMonitor.currentEffortLevel := taskDifficulty * 0.8;
    state.cognitiveEffortMonitor.effortDepletion := Float.min(1.0, state.cognitiveEffortMonitor.effortDepletion + taskDifficulty * 0.01);
    
    // Calculate metacognitive efficiency
    let efficiency = state.confidenceMonitor.calibration * (1.0 - state.cognitiveEffortMonitor.effortDepletion);
    efficiency
  };
  
  /// Initialize social cognition state
  public func initSocialCognitionState() : SocialCognitionState {
    {
      var theoryOfMind = {
        var beliefAttribution = [];
        var desireAttribution = [];
        var intentionRecognition = [];
        var emotionRecognition = [];
        var perspectiveTaking = {
          var spatialPerspective = 0.7;
          var conceptualPerspective = 0.6;
          var emotionalPerspective = 0.5;
          var egocentricBias = 0.3;
          var alterocentricBias = 0.2;
          var perspectiveSwitchingCost = 0.2;
        };
        var recursiveBeliefs = {
          var maxDepth = 4;
          var reliableDepth = 2;
          var cognitiveLoadPerLevel = 0.2;
          var accuracyPerLevel = [0.9, 0.7, 0.5, 0.3];
        };
        var developmentalLevel = #Level4_FullToM;
      };
      var socialPerception = {
        var faceProcessing = {
          var faceDetection = 0.95;
          var identityRecognition = 0.8;
          var expressionRecognition = 0.75;
          var gazeTracking = 0.85;
          var ownRaceEffect = 0.1;
          var familiarityAdvantage = 0.3;
        };
        var bodyLanguageReading = {
          var postureAnalysis = 0.7;
          var gestureRecognition = 0.75;
          var motionTrajectoryAnalysis = 0.65;
          var intentionFromMotion = 0.6;
          var emotionFromBody = 0.65;
        };
        var voiceProsodicAnalysis = {
          var pitchTracking = 0.8;
          var rhythmAnalysis = 0.75;
          var stressPatternRecognition = 0.7;
          var emotionFromVoice = 0.65;
          var sarcasmDetection = 0.5;
        };
        var socialCueIntegration = 0.7;
        var socialAttention = {
          var jointAttention = 0.8;
          var gazeFollowing = 0.85;
          var attentionSharing = 0.75;
          var socialSaliencyDetection = 0.8;
          var crowdAttentionTracking = 0.6;
        };
      };
      var empathySystem = {
        var affectiveEmpathy = {
          var emotionalContagion = 0.6;
          var mirrorActivation = 0.65;
          var vicariousEmotion = 0.55;
          var affectiveResonance = 0.6;
          var empathicAccuracy = 0.5;
        };
        var cognitiveEmpathy = {
          var mentalization = 0.7;
          var perspectiveTaking = 0.65;
          var theoryOfMindEngagement = 0.7;
          var empathicInference = 0.6;
          var understandingAccuracy = 0.55;
        };
        var compassion = {
          var compassionateResponse = 0.6;
          var motivationToHelp = 0.65;
          var compassionFatigue = 0.1;
          var selfCompassion = 0.55;
          var compassionateAction = 0.5;
        };
        var empathicConcern = 0.6;
        var personalDistress = 0.2;
        var empathyRegulation = {
          var upRegulation = 0.6;
          var downRegulation = 0.5;
          var boundaryMaintenance = 0.7;
          var empathySelectivity = 0.5;
          var compassionateDetachment = 0.4;
        };
      };
      var moralCognition = {
        var moralReasoning = {
          var deontologicalThinking = 0.5;
          var consequentialistThinking = 0.5;
          var virtueBasedThinking = 0.5;
          var moralDilemmaResolution = 0.6;
          var universalizabilityTest = 0.5;
        };
        var moralEmotions = {
          var guilt = 0.0;
          var shame = 0.0;
          var moralOutrage = 0.0;
          var compassion = 0.5;
          var gratitude = 0.5;
          var admiration = 0.5;
          var contempt = 0.0;
        };
        var moralIdentity = {
          var moralCentrality = 0.7;
          var moralCommitment = 0.7;
          var moralCourage = 0.6;
          var moralHypocrisyRisk = 0.1;
          var moralLicensingRisk = 0.1;
        };
        var moralBehavior = {
          var prosocialBehavior = 0.7;
          var cheatingResistance = 0.8;
          var fairnessAdherence = 0.75;
          var loyaltyBehavior = 0.7;
          var authorityRespect = 0.6;
          var sanctityObservance = 0.5;
        };
        var moralDevelopment = #Principled;
      };
      var socialDecisionMaking = {
        var trustDecisions = {
          var baselineTrust = 0.5;
          var trustLearningRate = 0.1;
          var betrayalSensitivity = 0.7;
          var trustRepairRate = 0.05;
          var trustGeneralization = 0.3;
        };
        var cooperationDecisions = {
          var cooperationBias = 0.6;
          var defectionThreshold = 0.3;
          var reciprocityTracking = 0.8;
          var reputationWeight = 0.6;
          var futureOrientedCooperation = 0.7;
        };
        var fairnessDecisions = {
          var inequityAversion = 0.6;
          var advantageousInequityTolerance = 0.4;
          var disadvantageousInequityTolerance = 0.2;
          var procedureJusticeSensitivity = 0.7;
          var distributiveJusticeSensitivity = 0.7;
        };
        var punishmentDecisions = {
          var punishmentWillingness = 0.5;
          var altruisticPunishment = 0.4;
          var costlyPunishment = 0.3;
          var punishmentProportionality = 0.7;
          var forgivenessCapacity = 0.6;
        };
        var allianceDecisions = {
          var allianceFormationBias = 0.5;
          var coalitionSizePreference = 0.5;
          var inGroupBias = 0.3;
          var outGroupDerogation = 0.1;
          var allianceStability = 0.7;
        };
      };
      var reputationModel = {
        var ownReputation = Array.tabulate<Float>(8, func(i) { 0.5 });
        var otherReputations = [];
        var reputationDimensions = ["competence", "warmth", "integrity", "status", "dominance", "attractiveness", "trustworthiness", "morality"];
        var gossipProcessing = 0.5;
        var reputationManagement = 0.6;
        var impressionManagement = 0.5;
      };
      var coalitionDetection = {
        var coalitionBoundaries = [];
        var coalitionMemberships = [];
        var coalitionDynamics = [];
        var freeRiderDetection = 0.6;
        var coalitionLeaderIdentification = 0.7;
      };
    }
  };
  
  /// Process social cognition tick
  public func processSocialTick(state : SocialCognitionState, socialInput : [Float]) : Float {
    // Update empathy based on social input
    if (socialInput.size() > 0) {
      state.empathySystem.affectiveEmpathy.emotionalContagion := 
        state.empathySystem.affectiveEmpathy.emotionalContagion * 0.9 + 
        socialInput[0] * 0.1;
    };
    
    // Calculate social cognition efficiency
    let tomAccuracy = switch (state.theoryOfMind.developmentalLevel) {
      case (#Level0_NoToM) { 0.0 };
      case (#Level1_FirstOrderBeliefs) { 0.25 };
      case (#Level2_SecondOrderBeliefs) { 0.5 };
      case (#Level3_ThirdOrderBeliefs) { 0.75 };
      case (#Level4_FullToM) { 1.0 };
    };
    
    let socialEfficiency = tomAccuracy * 0.3 + 
                          state.empathySystem.empathicConcern * 0.3 +
                          state.socialPerception.socialCueIntegration * 0.4;
    
    socialEfficiency
  };
  
  /// Initialize language state
  public func initLanguageState() : LanguageState {
    {
      var lexicalProcessing = {
        var lexicalAccess = 0.8;
        var wordFrequencyEffect = 0.5;
        var neighborhoodDensity = 0.5;
        var lexicalCompetition = 0.3;
        var wordRecognitionThreshold = 0.6;
      };
      var syntacticProcessing = {
        var parseComplexity = 0.6;
        var gardenPathSensitivity = 0.4;
        var syntacticPrediction = 0.7;
        var structuralPriming = 0.5;
        var grammaticalityJudgment = 0.8;
      };
      var semanticProcessing = {
        var semanticActivation = 0.8;
        var conceptualCombination = 0.7;
        var metaphorComprehension = 0.6;
        var contextualIntegration = 0.75;
        var semanticMemoryAccess = 0.8;
      };
      var pragmaticProcessing = {
        var implicatureComprehension = 0.6;
        var speechActRecognition = 0.7;
        var ironyDetection = 0.5;
        var contextSensitivity = 0.7;
        var relevanceComputation = 0.65;
      };
      var discourseProcessing = {
        var coherenceTracking = 0.7;
        var referenceResolution = 0.75;
        var narrativeComprehension = 0.7;
        var argumentStructureTracking = 0.65;
        var discourseModelBuilding = 0.7;
      };
      var languageProduction = {
        var conceptualization = 0.75;
        var lemmaRetrieval = 0.8;
        var phonologicalEncoding = 0.85;
        var articulatoryPlanning = 0.8;
        var selfMonitoring = 0.7;
      };
      var bilingualControl = null;
    }
  };
  
  /// Initialize reasoning state
  public func initReasoningState() : ReasoningState {
    {
      var deductiveReasoning = {
        var syllogisticReasoning = 0.6;
        var conditionalReasoning = 0.65;
        var quantifierReasoning = 0.55;
        var beliefBiasResistance = 0.5;
        var logicalValidityDetection = 0.6;
      };
      var inductiveReasoning = {
        var patternExtraction = 0.7;
        var hypothesisGeneration = 0.65;
        var evidenceEvaluation = 0.6;
        var generalizationAbility = 0.65;
        var confirmationBiasResistance = 0.4;
      };
      var abductiveReasoning = {
        var explanationGeneration = 0.6;
        var bestExplanationSelection = 0.55;
        var simplicitPreference = 0.6;
        var coherenceMaximization = 0.65;
        var surprisingFactIntegration = 0.5;
      };
      var analogicalReasoning = {
        var structuralMapping = 0.6;
        var relationshipExtraction = 0.65;
        var surfaceSimilarityResistance = 0.5;
        var farTransfer = 0.4;
        var analogyQuality = 0.55;
      };
      var causalReasoning = {
        var causalDiscovery = 0.6;
        var interventionReasoning = 0.55;
        var counterfactualAnalysis = 0.5;
        var causalChainConstruction = 0.6;
        var confoundAwareness = 0.5;
      };
      var probabilisticReasoning = {
        var bayesianUpdating = 0.5;
        var baseRateUsage = 0.4;
        var conjunctionFallacyResistance = 0.4;
        var uncertaintyQuantification = 0.55;
        var probabilityCalibration = 0.5;
      };
      var counterfactualReasoning = {
        var counterfactualGeneration = 0.6;
        var alternativeWorldModeling = 0.55;
        var regretComputation = 0.5;
        var mentalSimulation = 0.6;
        var causalResponsibility = 0.55;
      };
    }
  };
  
  /// Initialize creativity state
  public func initCreativityState() : CreativityState {
    {
      var divergentThinking = {
        var fluency = 0.6;
        var flexibility = 0.55;
        var originality = 0.5;
        var elaboration = 0.6;
        var remoteAssociations = 0.45;
      };
      var convergentThinking = {
        var problemSolving = 0.7;
        var solutionEvaluation = 0.65;
        var constraintSatisfaction = 0.7;
        var optimization = 0.6;
        var refinement = 0.65;
      };
      var imagination = {
        var mentalImagery = 0.7;
        var scenarioConstruction = 0.65;
        var futureThinking = 0.6;
        var fantasyGeneration = 0.55;
        var realityMonitoring = 0.8;
      };
      var insightProcessing = {
        var impasseDetection = 0.6;
        var restructuring = 0.5;
        var ahaExperience = 0.4;
        var incubationEffect = 0.5;
        var insightVerification = 0.7;
      };
      var creativeMotivation = {
        var intrinsicMotivation = 0.6;
        var challengeSeeking = 0.55;
        var persistenceUnderUncertainty = 0.6;
        var riskTolerance = 0.5;
        var openessToExperience = 0.6;
      };
      var domainCreativity = [];
    }
  };
  
  /// Initialize decision making state
  public func initDecisionMakingState() : DecisionMakingState {
    {
      var valueBasedDecision = {
        var valueComputation = 0.7;
        var optionComparison = 0.7;
        var preferenceConsistency = 0.65;
        var valueDiscounting = 0.5;
        var riskSensitivity = 0.5;
      };
      var habitBasedDecision = {
        var habitStrength = 0.3;
        var automaticity = 0.3;
        var contextDependence = 0.6;
        var goalIndependence = 0.2;
        var habitmGoalConflict = 0.1;
      };
      var modelBasedDecision = {
        var worldModelAccuracy = 0.6;
        var planningDepth = 0.5;
        var modelBasedControl = 0.6;
        var transitionModelLearning = 0.5;
        var rewardModelLearning = 0.6;
      };
      var modelFreeDecision = {
        var reinforcementLearning = 0.6;
        var valueEstimation = 0.6;
        var explorationExploitation = 0.5;
        var temporalDifference = 0.55;
        var cachedValue = 0.5;
      };
      var metacognitiveDecision = {
        var confidenceThreshold = 0.7;
        var informationSeeking = 0.6;
        var decisionDeferral = 0.4;
        var strategyAwareness = 0.6;
        var decisionQualityMonitoring = 0.65;
      };
      var socialDecision = {
        var conformityPressure = 0.3;
        var socialProof = 0.4;
        var authorityInfluence = 0.3;
        var reciprocityInfluence = 0.5;
        var commitmentInfluence = 0.4;
      };
    }
  };
  
  /// Initialize motor cognition state
  public func initMotorCognitionState() : MotorCognitionState {
    {
      var actionPlanning = {
        var goalSetting = 0.7;
        var subgoalDecomposition = 0.65;
        var sequencePlanning = 0.7;
        var conflictResolution = 0.6;
        var planFlexibility = 0.6;
      };
      var motorControl = {
        var feedforwardControl = 0.8;
        var feedbackControl = 0.75;
        var coordinatedMovement = 0.8;
        var forceControl = 0.7;
        var timingControl = 0.75;
      };
      var actionMonitoring = {
        var efferenceCopy = 0.8;
        var reafferencePrediction = 0.75;
        var errorDetection = 0.7;
        var onlineCorrection = 0.7;
        var agencyJudgment = 0.85;
      };
      var actionLearning = {
        var motorAdaptation = 0.6;
        var skillAcquisition = 0.55;
        var proceduralConsolidation = 0.6;
        var transferLearning = 0.5;
        var observationalLearning = 0.55;
      };
      var actionUnderstanding = {
        var actionRecognition = 0.75;
        var intentionFromAction = 0.6;
        var mirrorActivation = 0.65;
        var predictionFromAction = 0.6;
        var contextIntegration = 0.65;
      };
      var toolUse = {
        var toolRecognition = 0.8;
        var affordancePerception = 0.7;
        var bodySchemaExtension = 0.6;
        var toolManipulation = 0.7;
        var toolInvention = 0.4;
      };
    }
  };
  
  /// Comprehensive cognitive tick integrating all systems
  public func runComprehensiveCognitiveTick(
    cogState : CognitiveArchitectureState,
    metaState : MetacognitiveState,
    socialState : SocialCognitionState,
    langState : LanguageState,
    reasonState : ReasoningState,
    creativityState : CreativityState,
    decisionState : DecisionMakingState,
    motorState : MotorCognitionState,
    sensoryInput : [Float]
  ) : ComprehensiveCognitiveOutput {
    let startTime = Time.now();
    
    // 1. Run base cognitive tick
    let baseResult = runCognitiveArchitectureTick(cogState, sensoryInput);
    
    // 2. Run metacognitive processing
    let metaEfficiency = processMetacognitiveTick(metaState, baseResult.freeEnergy, baseResult.overallCoherence);
    
    // 3. Run social cognition
    let socialEfficiency = processSocialTick(socialState, sensoryInput);
    
    // 4. Integrate all cognitive outputs
    let integratedCoherence = (baseResult.overallCoherence * 0.4 +
                              metaEfficiency * 0.2 +
                              socialEfficiency * 0.2 +
                              cogState.consciousnessLevel * 0.2);
    
    // 5. Update global cognitive state
    cogState.overallCoherence := Float.max(SOVEREIGN_FLOOR, integratedCoherence);
    
    {
      baseResult = baseResult;
      metacognitiveEfficiency = metaEfficiency;
      socialEfficiency = socialEfficiency;
      integratedCoherence = integratedCoherence;
      reasoningCapacity = reasonState.deductiveReasoning.logicalValidityDetection;
      creativePotential = creativityState.divergentThinking.originality;
      decisionQuality = decisionState.valueBasedDecision.preferenceConsistency;
      motorReadiness = motorState.motorControl.coordinatedMovement;
      languageReadiness = langState.lexicalProcessing.lexicalAccess;
      totalProcessingTime = Time.now() - startTime;
    }
  };
  
  public type ComprehensiveCognitiveOutput = {
    baseResult : CognitiveTickResult;
    metacognitiveEfficiency : Float;
    socialEfficiency : Float;
    integratedCoherence : Float;
    reasoningCapacity : Float;
    creativePotential : Float;
    decisionQuality : Float;
    motorReadiness : Float;
    languageReadiness : Float;
    totalProcessingTime : Int;
  };
  
  /// Get comprehensive cognitive status
  public func getComprehensiveCognitiveStatus(
    cogState : CognitiveArchitectureState,
    metaState : MetacognitiveState,
    socialState : SocialCognitionState
  ) : ComprehensiveCognitiveStatus {
    {
      baseStatus = getCognitiveStatus(cogState);
      metacognitiveConfidence = metaState.confidenceMonitor.overallConfidence;
      metacognitiveCalibration = metaState.confidenceMonitor.calibration;
      effortLevel = metaState.cognitiveEffortMonitor.currentEffortLevel;
      effortDepletion = metaState.cognitiveEffortMonitor.effortDepletion;
      theoryOfMindLevel = switch (socialState.theoryOfMind.developmentalLevel) {
        case (#Level0_NoToM) { 0 };
        case (#Level1_FirstOrderBeliefs) { 1 };
        case (#Level2_SecondOrderBeliefs) { 2 };
        case (#Level3_ThirdOrderBeliefs) { 3 };
        case (#Level4_FullToM) { 4 };
      };
      empathicConcern = socialState.empathySystem.empathicConcern;
      moralDevelopment = switch (socialState.moralCognition.moralDevelopment) {
        case (#PreConventional) { 1 };
        case (#Conventional) { 2 };
        case (#PostConventional) { 3 };
        case (#Principled) { 4 };
      };
      socialCueIntegration = socialState.socialPerception.socialCueIntegration;
    }
  };
  
  public type ComprehensiveCognitiveStatus = {
    baseStatus : CognitiveStatus;
    metacognitiveConfidence : Float;
    metacognitiveCalibration : Float;
    effortLevel : Float;
    effortDepletion : Float;
    theoryOfMindLevel : Nat;
    empathicConcern : Float;
    moralDevelopment : Nat;
    socialCueIntegration : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ADVANCED NEUROSCIENCE - CORTICAL MICROCIRCUITS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Cortical microcircuit state
  public type CorticalMicrocircuitState = {
    var layers : [CorticalLayer];
    var columnarOrganization : ColumnarOrganization;
    var inhibitoryInterneurons : InhibitoryInterneurons;
    var pyramidalCells : PyramidalCellPopulation;
    var canonicalCircuit : CanonicalMicrocircuit;
    var lateralInhibition : LateralInhibition;
    var feedforwardSweep : FeedforwardSweep;
    var feedbackModulation : FeedbackModulation;
  };
  
  public type CorticalLayer = {
    layerIndex : Nat;
    layerName : Text;
    cellTypes : [CellType];
    thickness : Float;
    synapticDensity : Float;
    firingRate : Float;
    oscillatoryPower : [Float];
    inputSources : [LayerInput];
    outputTargets : [LayerOutput];
  };
  
  public type CellType = {
    #PyramidalL23;
    #PyramidalL4;
    #PyramidalL5;
    #PyramidalL6;
    #StellateL4;
    #BasketCell;
    #ChandlerCell;
    #MartinotiCell;
    #BipolarCell;
    #NeurogliaformCell;
    #DoubleB bouquetCell;
    #SOMInterneuron;
    #PVInterneuron;
    #VIPInterneuron;
  };
  
  public type LayerInput = {
    sourceLayer : Nat;
    sourceRegion : Text;
    connectionStrength : Float;
    synapseType : SynapseType;
    targetCellTypes : [CellType];
  };
  
  public type LayerOutput = {
    targetLayer : Nat;
    targetRegion : Text;
    connectionStrength : Float;
    axonType : AxonType;
  };
  
  public type SynapseType = {
    #Glutamatergic;
    #GABAergicFast;
    #GABAergicSlow;
    #Cholinergic;
    #Dopaminergic;
    #Serotonergic;
    #Noradrenergic;
    #Peptidergic;
  };
  
  public type AxonType = {
    #Corticocortical;
    #Corticothalamic;
    #Corticostriatal;
    #Corticospinal;
    #Callosal;
    #Associational;
  };
  
  public type ColumnarOrganization = {
    var columns : [[Float]];
    var columnarWidth : Float;
    var intercolumnarInhibition : Float;
    var columnarCoherence : Float;
    var orientationTuning : [[Float]];
    var ocularDominance : [Float];
    var spatialFrequencyTuning : [[Float]];
  };
  
  public type InhibitoryInterneurons = {
    var pvCells : PVCellState;
    var somCells : SOMCellState;
    var vipCells : VIPCellState;
    var npyCells : NPYCellState;
    var inhibitoryBalance : Float;
    var gammaOscillations : Float;
    var disinhibitoryGating : Float;
  };
  
  public type PVCellState = {
    var firingRate : Float;
    var perisomaticInhibition : Float;
    var gammaPhaseLocking : Float;
    var fastSpiking : Float;
    var networkSynchronization : Float;
  };
  
  public type SOMCellState = {
    var firingRate : Float;
    var dendriticInhibition : Float;
    var lateralInhibition : Float;
    var surroundSuppression : Float;
    var contextModulation : Float;
  };
  
  public type VIPCellState = {
    var firingRate : Float;
    var disinhibition : Float;
    var attentionalModulation : Float;
    var learningGating : Float;
    var topDownControl : Float;
  };
  
  public type NPYCellState = {
    var firingRate : Float;
    var slowInhibition : Float;
    var metabolicSignaling : Float;
    var volumeTransmission : Float;
  };
  
  public type PyramidalCellPopulation = {
    var layer23Pyramidals : Layer23State;
    var layer4Spiny : Layer4State;
    var layer5Thick : Layer5ThickState;
    var layer5Thin : Layer5ThinState;
    var layer6Corticothalamic : Layer6State;
    var dendriticIntegration : DendriticIntegration;
    var somaComputation : SomaComputation;
    var axonInitialSegment : AxonInitialSegment;
  };
  
  public type Layer23State = {
    var excitability : Float;
    var recurrentConnectivity : Float;
    var callosalProjection : Float;
    var associationalProjection : Float;
    var feedbackReceptivity : Float;
  };
  
  public type Layer4State = {
    var thalamicInputStrength : Float;
    var spinyStellateActivity : Float;
    var localInhibition : Float;
    var feedforwardAmplification : Float;
  };
  
  public type Layer5ThickState = {
    var burstFiring : Float;
    var corticofugalOutput : Float;
    var apicalDendriteCa2Plus : Float;
    var backpropagation : Float;
    var coincidenceDetection : Float;
  };
  
  public type Layer5ThinState = {
    var regularFiring : Float;
    var corticocorticalProjection : Float;
    var integrationWindow : Float;
  };
  
  public type Layer6State = {
    var corticothalamicModulation : Float;
    var feedbackGain : Float;
    var attentionalGating : Float;
    var predictiveCoding : Float;
  };
  
  public type DendriticIntegration = {
    var basalDendrites : Float;
    var apicalTuft : Float;
    var apicalTrunk : Float;
    var nmdarPlateaus : Float;
    var calciumSpikes : Float;
    var backpropagatingAPs : Float;
    var dendriticSpikes : Float;
    var spatialSummation : Float;
    var temporalSummation : Float;
  };
  
  public type SomaComputation = {
    var restingPotential : Float;
    var threshold : Float;
    var firingRate : Float;
    var adaptationIndex : Float;
    var refractoryPeriod : Float;
    var inputResistance : Float;
    var membraneTimeConstant : Float;
  };
  
  public type AxonInitialSegment = {
    var length : Float;
    var naChannelDensity : Float;
    var threshold : Float;
    var spikeInitiation : Float;
    var outputReliability : Float;
  };
  
  public type CanonicalMicrocircuit = {
    var feedforwardExcitation : Float;
    var feedbackExcitation : Float;
    var lateralInhibition : Float;
    var disinhibition : Float;
    var recurrentExcitation : Float;
    var thalamocorticalDrive : Float;
    var corticothalamicFeedback : Float;
    var predictiveErrorComputation : Float;
  };
  
  public type LateralInhibition = {
    var surround : Float;
    var contrastGain : Float;
    var normalization : Float;
    var winnerTakeAll : Float;
    var competitiveSelection : Float;
  };
  
  public type FeedforwardSweep = {
    var latency : Float;
    var spikeCount : Float;
    var informationContent : Float;
    var selectivity : Float;
    var invariance : Float;
  };
  
  public type FeedbackModulation = {
    var attentionalGain : Float;
    var expectationSignal : Float;
    var predictiveContext : Float;
    var errorSignaling : Float;
    var memoryRetrieval : Float;
  };
  
  /// Initialize cortical microcircuit
  public func initCorticalMicrocircuit() : CorticalMicrocircuitState {
    {
      var layers = [
        {
          layerIndex = 1;
          layerName = "Layer 1 - Molecular";
          cellTypes = [#MartinotiCell, #NeurogliaformCell];
          thickness = 0.1;
          synapticDensity = 0.3;
          firingRate = 0.0;
          oscillatoryPower = [0.0, 0.0, 0.0, 0.0, 0.0];
          inputSources = [];
          outputTargets = [];
        },
        {
          layerIndex = 2;
          layerName = "Layer 2/3 - External Granular/Pyramidal";
          cellTypes = [#PyramidalL23, #BasketCell, #MartinotiCell, #VIPInterneuron];
          thickness = 0.25;
          synapticDensity = 0.8;
          firingRate = 5.0;
          oscillatoryPower = [0.3, 0.5, 0.4, 0.3, 0.2];
          inputSources = [];
          outputTargets = [];
        },
        {
          layerIndex = 4;
          layerName = "Layer 4 - Internal Granular";
          cellTypes = [#StellateL4, #PyramidalL4, #BasketCell, #PVInterneuron];
          thickness = 0.2;
          synapticDensity = 0.9;
          firingRate = 8.0;
          oscillatoryPower = [0.2, 0.4, 0.6, 0.5, 0.3];
          inputSources = [];
          outputTargets = [];
        },
        {
          layerIndex = 5;
          layerName = "Layer 5 - Internal Pyramidal";
          cellTypes = [#PyramidalL5, #BasketCell, #MartinotiCell, #SOMInterneuron];
          thickness = 0.25;
          synapticDensity = 0.7;
          firingRate = 6.0;
          oscillatoryPower = [0.4, 0.4, 0.3, 0.2, 0.1];
          inputSources = [];
          outputTargets = [];
        },
        {
          layerIndex = 6;
          layerName = "Layer 6 - Multiform/Corticothalamic";
          cellTypes = [#PyramidalL6, #BasketCell];
          thickness = 0.2;
          synapticDensity = 0.6;
          firingRate = 4.0;
          oscillatoryPower = [0.5, 0.3, 0.2, 0.1, 0.1];
          inputSources = [];
          outputTargets = [];
        }
      ];
      var columnarOrganization = {
        var columns = Array.tabulate<[Float]>(100, func(i) {
          Array.tabulate<Float>(6, func(j) { 0.5 + Float.sin(Float.fromInt(i + j)) * 0.3 })
        });
        var columnarWidth = 0.5;
        var intercolumnarInhibition = 0.3;
        var columnarCoherence = 0.7;
        var orientationTuning = [];
        var ocularDominance = [];
        var spatialFrequencyTuning = [];
      };
      var inhibitoryInterneurons = {
        var pvCells = {
          var firingRate = 30.0;
          var perisomaticInhibition = 0.8;
          var gammaPhaseLocking = 0.7;
          var fastSpiking = 0.9;
          var networkSynchronization = 0.6;
        };
        var somCells = {
          var firingRate = 10.0;
          var dendriticInhibition = 0.7;
          var lateralInhibition = 0.6;
          var surroundSuppression = 0.5;
          var contextModulation = 0.4;
        };
        var vipCells = {
          var firingRate = 15.0;
          var disinhibition = 0.6;
          var attentionalModulation = 0.5;
          var learningGating = 0.4;
          var topDownControl = 0.5;
        };
        var npyCells = {
          var firingRate = 5.0;
          var slowInhibition = 0.5;
          var metabolicSignaling = 0.3;
          var volumeTransmission = 0.2;
        };
        var inhibitoryBalance = 0.5;
        var gammaOscillations = 0.6;
        var disinhibitoryGating = 0.4;
      };
      var pyramidalCells = {
        var layer23Pyramidals = {
          var excitability = 0.6;
          var recurrentConnectivity = 0.4;
          var callosalProjection = 0.3;
          var associationalProjection = 0.5;
          var feedbackReceptivity = 0.6;
        };
        var layer4Spiny = {
          var thalamicInputStrength = 0.8;
          var spinyStellateActivity = 0.7;
          var localInhibition = 0.5;
          var feedforwardAmplification = 0.6;
        };
        var layer5Thick = {
          var burstFiring = 0.4;
          var corticofugalOutput = 0.7;
          var apicalDendriteCa2Plus = 0.3;
          var backpropagation = 0.5;
          var coincidenceDetection = 0.4;
        };
        var layer5Thin = {
          var regularFiring = 0.6;
          var corticocorticalProjection = 0.5;
          var integrationWindow = 0.4;
        };
        var layer6Corticothalamic = {
          var corticothalamicModulation = 0.5;
          var feedbackGain = 0.4;
          var attentionalGating = 0.5;
          var predictiveCoding = 0.4;
        };
        var dendriticIntegration = {
          var basalDendrites = 0.6;
          var apicalTuft = 0.4;
          var apicalTrunk = 0.5;
          var nmdarPlateaus = 0.3;
          var calciumSpikes = 0.2;
          var backpropagatingAPs = 0.4;
          var dendriticSpikes = 0.3;
          var spatialSummation = 0.6;
          var temporalSummation = 0.7;
        };
        var somaComputation = {
          var restingPotential = -70.0;
          var threshold = -55.0;
          var firingRate = 5.0;
          var adaptationIndex = 0.3;
          var refractoryPeriod = 2.0;
          var inputResistance = 100.0;
          var membraneTimeConstant = 20.0;
        };
        var axonInitialSegment = {
          var length = 40.0;
          var naChannelDensity = 0.8;
          var threshold = -55.0;
          var spikeInitiation = 0.9;
          var outputReliability = 0.95;
        };
      };
      var canonicalCircuit = {
        var feedforwardExcitation = 0.7;
        var feedbackExcitation = 0.5;
        var lateralInhibition = 0.4;
        var disinhibition = 0.3;
        var recurrentExcitation = 0.5;
        var thalamocorticalDrive = 0.6;
        var corticothalamicFeedback = 0.4;
        var predictiveErrorComputation = 0.5;
      };
      var lateralInhibition = {
        var surround = 0.4;
        var contrastGain = 0.6;
        var normalization = 0.5;
        var winnerTakeAll = 0.3;
        var competitiveSelection = 0.4;
      };
      var feedforwardSweep = {
        var latency = 50.0;
        var spikeCount = 3.0;
        var informationContent = 0.6;
        var selectivity = 0.5;
        var invariance = 0.4;
      };
      var feedbackModulation = {
        var attentionalGain = 0.5;
        var expectationSignal = 0.4;
        var predictiveContext = 0.4;
        var errorSignaling = 0.5;
        var memoryRetrieval = 0.3;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BASAL GANGLIA - ACTION SELECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BasalGangliaState = {
    var striatum : StriatumState;
    var globusPallidus : GlobusPallidusState;
    var subthalamicNucleus : SubthalamicNucleusState;
    var substantiaNigra : SubstantiaNigraState;
    var directPathway : DirectPathwayState;
    var indirectPathway : IndirectPathwayState;
    var hyperdirectPathway : HyperdirectPathwayState;
    var actionSelection : ActionSelectionState;
  };
  
  public type StriatumState = {
    var d1MSNs : Float;
    var d2MSNs : Float;
    var cholinergicInterneurons : Float;
    var fastSpikingInterneurons : Float;
    var dopamineLevel : Float;
    var striosomes : Float;
    var matrix : Float;
    var territorialOrganization : [[Float]];
  };
  
  public type GlobusPallidusState = {
    var gpExternal : Float;
    var gpInternal : Float;
    var tonicInhibition : Float;
    var burstPauses : Float;
    var rebound : Float;
  };
  
  public type SubthalamicNucleusState = {
    var activity : Float;
    var oscillations : Float;
    var corticalInput : Float;
    var pallidalInput : Float;
    var glutamateOutput : Float;
  };
  
  public type SubstantiaNigraState = {
    var parsCompacta : Float;
    var parsReticulata : Float;
    var dopamineRelease : Float;
    var tonicFiring : Float;
    var phasicBursts : Float;
    var rewardPredictionError : Float;
  };
  
  public type DirectPathwayState = {
    var activity : Float;
    var d1Activation : Float;
    var disinhibition : Float;
    var goSignal : Float;
    var facilitation : Float;
  };
  
  public type IndirectPathwayState = {
    var activity : Float;
    var d2Activation : Float;
    var inhibition : Float;
    var noGoSignal : Float;
    var suppression : Float;
  };
  
  public type HyperdirectPathwayState = {
    var activity : Float;
    var corticalInput : Float;
    var stnActivation : Float;
    var globalInhibition : Float;
    var braking : Float;
    var impulsivityControl : Float;
  };
  
  public type ActionSelectionState = {
    var competingActions : [ActionCandidate];
    var selectedAction : ?Nat;
    var selectionConfidence : Float;
    var deliberationTime : Float;
    var urgency : Float;
    var explorationRate : Float;
    var exploitationRate : Float;
  };
  
  public type ActionCandidate = {
    actionId : Nat;
    salience : Float;
    value : Float;
    cost : Float;
    uncertainty : Float;
    vigor : Float;
    directPathwaySupport : Float;
    indirectPathwayOpposition : Float;
  };
  
  /// Initialize basal ganglia state
  public func initBasalGangliaState() : BasalGangliaState {
    {
      var striatum = {
        var d1MSNs = 0.5;
        var d2MSNs = 0.5;
        var cholinergicInterneurons = 0.4;
        var fastSpikingInterneurons = 0.3;
        var dopamineLevel = 0.5;
        var striosomes = 0.4;
        var matrix = 0.6;
        var territorialOrganization = Array.tabulate<[Float]>(10, func(i) {
          Array.tabulate<Float>(10, func(j) { 0.5 })
        });
      };
      var globusPallidus = {
        var gpExternal = 0.6;
        var gpInternal = 0.7;
        var tonicInhibition = 0.8;
        var burstPauses = 0.2;
        var rebound = 0.3;
      };
      var subthalamicNucleus = {
        var activity = 0.5;
        var oscillations = 0.3;
        var corticalInput = 0.4;
        var pallidalInput = 0.5;
        var glutamateOutput = 0.5;
      };
      var substantiaNigra = {
        var parsCompacta = 0.5;
        var parsReticulata = 0.6;
        var dopamineRelease = 0.5;
        var tonicFiring = 4.0;
        var phasicBursts = 0.0;
        var rewardPredictionError = 0.0;
      };
      var directPathway = {
        var activity = 0.5;
        var d1Activation = 0.5;
        var disinhibition = 0.4;
        var goSignal = 0.0;
        var facilitation = 0.5;
      };
      var indirectPathway = {
        var activity = 0.5;
        var d2Activation = 0.5;
        var inhibition = 0.5;
        var noGoSignal = 0.0;
        var suppression = 0.5;
      };
      var hyperdirectPathway = {
        var activity = 0.3;
        var corticalInput = 0.4;
        var stnActivation = 0.3;
        var globalInhibition = 0.4;
        var braking = 0.3;
        var impulsivityControl = 0.5;
      };
      var actionSelection = {
        var competingActions = [];
        var selectedAction = null;
        var selectionConfidence = 0.0;
        var deliberationTime = 0.0;
        var urgency = 0.5;
        var explorationRate = 0.2;
        var exploitationRate = 0.8;
      };
    }
  };
  
  /// Process basal ganglia action selection
  public func processBasalGangliaSelection(bgState : BasalGangliaState, corticalInput : [Float], rewardSignal : Float) : ?Nat {
    // Update dopamine based on reward prediction error
    let rpe = rewardSignal - bgState.substantiaNigra.dopamineRelease * 0.5;
    bgState.substantiaNigra.rewardPredictionError := rpe;
    bgState.substantiaNigra.phasicBursts := if (rpe > 0.0) { rpe } else { 0.0 };
    
    // Update dopamine level
    bgState.striatum.dopamineLevel := Float.max(0.0, Float.min(1.0, 
      bgState.striatum.dopamineLevel + rpe * 0.1));
    
    // Update D1 and D2 MSN activity based on dopamine
    bgState.striatum.d1MSNs := bgState.striatum.d1MSNs * 0.9 + 
      bgState.striatum.dopamineLevel * 0.1;
    bgState.striatum.d2MSNs := bgState.striatum.d2MSNs * 0.9 + 
      (1.0 - bgState.striatum.dopamineLevel) * 0.1;
    
    // Update direct pathway
    bgState.directPathway.d1Activation := bgState.striatum.d1MSNs;
    bgState.directPathway.goSignal := bgState.directPathway.d1Activation * (1.0 - bgState.globusPallidus.gpInternal);
    
    // Update indirect pathway
    bgState.indirectPathway.d2Activation := bgState.striatum.d2MSNs;
    bgState.indirectPathway.noGoSignal := bgState.indirectPathway.d2Activation * bgState.globusPallidus.gpExternal;
    
    // Update hyperdirect pathway
    let avgCorticalInput = if (corticalInput.size() > 0) {
      var sum : Float = 0.0;
      for (v in corticalInput.vals()) { sum += v };
      sum / Float.fromInt(corticalInput.size())
    } else { 0.0 };
    
    bgState.hyperdirectPathway.corticalInput := avgCorticalInput;
    bgState.hyperdirectPathway.stnActivation := avgCorticalInput * 0.5;
    bgState.hyperdirectPathway.braking := bgState.hyperdirectPathway.stnActivation * bgState.hyperdirectPathway.globalInhibition;
    
    // Action selection via winner-take-all
    if (bgState.actionSelection.competingActions.size() > 0) {
      var maxScore : Float = -1.0;
      var maxIdx : Nat = 0;
      var idx : Nat = 0;
      
      for (action in bgState.actionSelection.competingActions.vals()) {
        let goSupport = action.directPathwaySupport * bgState.directPathway.goSignal;
        let noGoOpposition = action.indirectPathwayOpposition * bgState.indirectPathway.noGoSignal;
        let brakeEffect = bgState.hyperdirectPathway.braking;
        
        let selectionScore = (action.salience + action.value) * goSupport - noGoOpposition - brakeEffect;
        
        if (selectionScore > maxScore) {
          maxScore := selectionScore;
          maxIdx := idx;
        };
        idx += 1;
      };
      
      if (maxScore > bgState.hyperdirectPathway.braking) {
        bgState.actionSelection.selectedAction := ?maxIdx;
        bgState.actionSelection.selectionConfidence := maxScore;
        return ?maxIdx;
      };
    };
    
    null
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CEREBELLUM - MOTOR LEARNING & TIMING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CerebellumState = {
    var purkinjeCells : PurkinjeCellState;
    var granuleCells : GranuleCellState;
    var mossyFibers : MossyFiberState;
    var climbingFibers : ClimbingFiberState;
    var deepNuclei : DeepNucleiState;
    var inferiorOlive : InferiorOliveState;
    var motorLearning : CerebellarMotorLearning;
    var internalModels : InternalModels;
    var timing : CerebellarTiming;
  };
  
  public type PurkinjeCellState = {
    var simpleSpikes : Float;
    var complexSpikes : Float;
    var dendriticCa2Plus : Float;
    var ltdState : Float;
    var ltpState : Float;
    var parallelFiberWeights : [Float];
    var inhibitoryOutput : Float;
  };
  
  public type GranuleCellState = {
    var activity : Float;
    var sparseCoding : Float;
    var expansionRecoding : Float;
    var patternSeparation : Float;
    var golgiInhibition : Float;
  };
  
  public type MossyFiberState = {
    var pontineInput : Float;
    var vestibularInput : Float;
    var spinocerebellarInput : Float;
    var corticopontineInput : Float;
    var contextSignal : [Float];
  };
  
  public type ClimbingFiberState = {
    var errorSignal : Float;
    var complexSpikeRate : Float;
    var olivaryOscillation : Float;
    var learningSignal : Float;
    var timingSignal : Float;
  };
  
  public type DeepNucleiState = {
    var dentate : Float;
    var interposed : Float;
    var fastigial : Float;
    var outputToThalamus : Float;
    var outputToRedNucleus : Float;
    var outputToVestibular : Float;
    var reboundExcitation : Float;
  };
  
  public type InferiorOliveState = {
    var oscillations : Float;
    var gapJunctions : Float;
    var errorDetection : Float;
    var timingGeneration : Float;
    var climbingFiberOutput : Float;
  };
  
  public type CerebellarMotorLearning = {
    var adaptationRate : Float;
    var internalModelError : Float;
    var forwardModelAccuracy : Float;
    var inverseModelAccuracy : Float;
    var consolidationProgress : Float;
    var savingsEffect : Float;
  };
  
  public type InternalModels = {
    var forwardModel : [[Float]];
    var inverseModel : [[Float]];
    var predictedSensoryState : [Float];
    var actualSensoryState : [Float];
    var sensoryPredictionError : [Float];
    var modelUncertainty : Float;
  };
  
  public type CerebellarTiming = {
    var intervalTiming : Float;
    var rhythmGeneration : Float;
    var sequenceTiming : Float;
    var anticipatoryResponse : Float;
    var temporalDiscrimination : Float;
    var eventPrediction : Float;
  };
  
  /// Initialize cerebellum state
  public func initCerebellumState() : CerebellumState {
    {
      var purkinjeCells = {
        var simpleSpikes = 50.0;
        var complexSpikes = 1.0;
        var dendriticCa2Plus = 0.3;
        var ltdState = 0.0;
        var ltpState = 0.0;
        var parallelFiberWeights = Array.tabulate<Float>(100, func(i) { 0.5 });
        var inhibitoryOutput = 0.6;
      };
      var granuleCells = {
        var activity = 0.3;
        var sparseCoding = 0.05;
        var expansionRecoding = 0.7;
        var patternSeparation = 0.8;
        var golgiInhibition = 0.4;
      };
      var mossyFibers = {
        var pontineInput = 0.5;
        var vestibularInput = 0.4;
        var spinocerebellarInput = 0.3;
        var corticopontineInput = 0.5;
        var contextSignal = Array.tabulate<Float>(20, func(i) { 0.5 });
      };
      var climbingFibers = {
        var errorSignal = 0.0;
        var complexSpikeRate = 1.0;
        var olivaryOscillation = 0.5;
        var learningSignal = 0.0;
        var timingSignal = 0.0;
      };
      var deepNuclei = {
        var dentate = 0.5;
        var interposed = 0.5;
        var fastigial = 0.5;
        var outputToThalamus = 0.4;
        var outputToRedNucleus = 0.3;
        var outputToVestibular = 0.4;
        var reboundExcitation = 0.0;
      };
      var inferiorOlive = {
        var oscillations = 0.5;
        var gapJunctions = 0.6;
        var errorDetection = 0.0;
        var timingGeneration = 0.5;
        var climbingFiberOutput = 0.3;
      };
      var motorLearning = {
        var adaptationRate = 0.1;
        var internalModelError = 0.0;
        var forwardModelAccuracy = 0.7;
        var inverseModelAccuracy = 0.6;
        var consolidationProgress = 0.0;
        var savingsEffect = 0.5;
      };
      var internalModels = {
        var forwardModel = Array.tabulate<[Float]>(10, func(i) {
          Array.tabulate<Float>(10, func(j) { if (i == j) { 1.0 } else { 0.0 } })
        });
        var inverseModel = Array.tabulate<[Float]>(10, func(i) {
          Array.tabulate<Float>(10, func(j) { if (i == j) { 1.0 } else { 0.0 } })
        });
        var predictedSensoryState = Array.tabulate<Float>(10, func(i) { 0.0 });
        var actualSensoryState = Array.tabulate<Float>(10, func(i) { 0.0 });
        var sensoryPredictionError = Array.tabulate<Float>(10, func(i) { 0.0 });
        var modelUncertainty = 0.3;
      };
      var timing = {
        var intervalTiming = 0.5;
        var rhythmGeneration = 0.5;
        var sequenceTiming = 0.5;
        var anticipatoryResponse = 0.4;
        var temporalDiscrimination = 0.6;
        var eventPrediction = 0.5;
      };
    }
  };
  
  /// Process cerebellar motor learning
  public func processCerebellarLearning(cerebState : CerebellumState, motorCommand : [Float], sensoryFeedback : [Float]) : [Float] {
    // Compute sensory prediction error
    let errorSize = Nat.min(sensoryFeedback.size(), cerebState.internalModels.predictedSensoryState.size());
    var totalError : Float = 0.0;
    
    for (i in Iter.range(0, errorSize - 1)) {
      let error = sensoryFeedback[i] - cerebState.internalModels.predictedSensoryState[i];
      cerebState.internalModels.sensoryPredictionError[i] := error;
      totalError += Float.abs(error);
    };
    
    cerebState.motorLearning.internalModelError := totalError / Float.fromInt(errorSize);
    
    // Update climbing fiber error signal
    cerebState.climbingFibers.errorSignal := cerebState.motorLearning.internalModelError;
    cerebState.climbingFibers.learningSignal := cerebState.climbingFibers.errorSignal * 
      cerebState.inferiorOlive.errorDetection;
    
    // Trigger LTD if error signal present
    if (cerebState.climbingFibers.errorSignal > 0.1) {
      cerebState.purkinjeCells.complexSpikes := cerebState.purkinjeCells.complexSpikes + 1.0;
      cerebState.purkinjeCells.ltdState := cerebState.climbingFibers.learningSignal;
      
      // Update parallel fiber weights (LTD)
      for (i in Iter.range(0, cerebState.purkinjeCells.parallelFiberWeights.size() - 1)) {
        if (cerebState.granuleCells.activity > 0.5) {
          cerebState.purkinjeCells.parallelFiberWeights[i] := 
            Float.max(0.0, cerebState.purkinjeCells.parallelFiberWeights[i] - 
            cerebState.motorLearning.adaptationRate * cerebState.purkinjeCells.ltdState);
        };
      };
    };
    
    // Update forward model accuracy
    cerebState.motorLearning.forwardModelAccuracy := 1.0 - cerebState.motorLearning.internalModelError;
    
    // Generate corrected motor output
    let correctedOutput = Array.tabulate<Float>(motorCommand.size(), func(i) {
      if (i < cerebState.internalModels.sensoryPredictionError.size()) {
        motorCommand[i] - cerebState.internalModels.sensoryPredictionError[i] * 0.5
      } else {
        motorCommand[i]
      }
    });
    
    correctedOutput
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HIPPOCAMPUS - MEMORY & SPATIAL NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HippocampusState = {
    var dentateGyrus : DentateGyrusState;
    var ca3 : CA3State;
    var ca1 : CA1State;
    var subiculum : SubiculumState;
    var entorhinalCortex : EntorhinalCortexState;
    var placeCells : PlaceCellState;
    var gridCells : GridCellState;
    var timeCells : TimeCellState;
    var memoryIndexing : MemoryIndexingState;
    var replayState : ReplayState;
  };
  
  public type DentateGyrusState = {
    var granuleCellActivity : Float;
    var patternSeparation : Float;
    var neurogenesis : Float;
    var mossyCellActivity : Float;
    var hilarInterneurons : Float;
    var sparseEncoding : Float;
  };
  
  public type CA3State = {
    var pyramidalActivity : Float;
    var recurrentCollaterals : Float;
    var patternCompletion : Float;
    var autoassociation : Float;
    var attractor Dynamics : Float;
    var mossyFiberInput : Float;
  };
  
  public type CA1State = {
    var pyramidalActivity : Float;
    var schaffer CollateralInput : Float;
    var directEntorhinalInput : Float;
    var temporalIntegration : Float;
    var outputToSubiculum : Float;
    var outputToEntorhinal : Float;
  };
  
  public type SubiculumState = {
    var activity : Float;
    var boundaryVectorCells : Float;
    var headDirectionIntegration : Float;
    var outputToEntorhinal : Float;
    var outputToMammillary : Float;
  };
  
  public type EntorhinalCortexState = {
    var layerII : Float;
    var layerIII : Float;
    var layerV : Float;
    var layerVI : Float;
    var gridCellInput : Float;
    var objectVectorCells : Float;
    var temporalContext : Float;
  };
  
  public type PlaceCellState = {
    var currentPlaceField : ?Nat;
    var placeFields : [[Float]];
    var remapping : Float;
    var stability : Float;
    var theta PhasePrecession : Float;
    var thetaSequences : [Nat];
  };
  
  public type GridCellState = {
    var gridPhase : [Float];
    var gridSpacing : [Float];
    var gridOrientation : [Float];
    var gridModules : [[Float]];
    var pathIntegration : Float;
    var boundaryReset : Float;
  };
  
  public type TimeCellState = {
    var currentTimeField : Float;
    var timeFields : [[Float]];
    var temporalScaling : Float;
    var sequenceRepresentation : [Float];
    var durationEncoding : Float;
  };
  
  public type MemoryIndexingState = {
    var indexCreation : Float;
    var indexRetrieval : Float;
    var patternBinding : Float;
    var contextAssociation : Float;
    var episodeDelimitation : Float;
  };
  
  public type ReplayState = {
    var awakeReplay : Float;
    var sleepReplay : Float;
    var forwardReplay : Float;
    var reverseReplay : Float;
    var compressionRatio : Float;
    var replayContent : [[Float]];
  };
  
  /// Initialize hippocampus state
  public func initHippocampusState() : HippocampusState {
    {
      var dentateGyrus = {
        var granuleCellActivity = 0.05;
        var patternSeparation = 0.8;
        var neurogenesis = 0.02;
        var mossyCellActivity = 0.3;
        var hilarInterneurons = 0.4;
        var sparseEncoding = 0.02;
      };
      var ca3 = {
        var pyramidalActivity = 0.1;
        var recurrentCollaterals = 0.5;
        var patternCompletion = 0.7;
        var autoassociation = 0.6;
        var attractorDynamics = 0.5;
        var mossyFiberInput = 0.3;
      };
      var ca1 = {
        var pyramidalActivity = 0.15;
        var schafferCollateralInput = 0.5;
        var directEntorhinalInput = 0.3;
        var temporalIntegration = 0.6;
        var outputToSubiculum = 0.5;
        var outputToEntorhinal = 0.4;
      };
      var subiculum = {
        var activity = 0.2;
        var boundaryVectorCells = 0.4;
        var headDirectionIntegration = 0.5;
        var outputToEntorhinal = 0.4;
        var outputToMammillary = 0.3;
      };
      var entorhinalCortex = {
        var layerII = 0.3;
        var layerIII = 0.3;
        var layerV = 0.25;
        var layerVI = 0.2;
        var gridCellInput = 0.5;
        var objectVectorCells = 0.3;
        var temporalContext = 0.4;
      };
      var placeCells = {
        var currentPlaceField = null;
        var placeFields = Array.tabulate<[Float]>(100, func(i) {
          Array.tabulate<Float>(100, func(j) {
            let dist = Float.sqrt(Float.fromInt((i-50)*(i-50) + (j-50)*(j-50)));
            Float.exp(-dist * dist / 200.0)
          })
        });
        var remapping = 0.1;
        var stability = 0.8;
        var thetaPhasePrecession = 0.5;
        var thetaSequences = [];
      };
      var gridCells = {
        var gridPhase = Array.tabulate<Float>(6, func(i) { 0.0 });
        var gridSpacing = [0.3, 0.5, 0.8, 1.2, 1.8, 2.5];
        var gridOrientation = [0.0, 7.5, 15.0, 22.5, 30.0, 37.5];
        var gridModules = Array.tabulate<[Float]>(6, func(i) {
          Array.tabulate<Float>(100, func(j) { 0.5 })
        });
        var pathIntegration = 0.9;
        var boundaryReset = 0.7;
      };
      var timeCells = {
        var currentTimeField = 0.0;
        var timeFields = Array.tabulate<[Float]>(50, func(i) {
          Array.tabulate<Float>(100, func(j) {
            let peak = Float.fromInt(i * 2);
            Float.exp(-Float.abs(Float.fromInt(j) - peak) / 10.0)
          })
        });
        var temporalScaling = 1.0;
        var sequenceRepresentation = [];
        var durationEncoding = 0.6;
      };
      var memoryIndexing = {
        var indexCreation = 0.5;
        var indexRetrieval = 0.6;
        var patternBinding = 0.7;
        var contextAssociation = 0.6;
        var episodeDelimitation = 0.5;
      };
      var replayState = {
        var awakeReplay = 0.3;
        var sleepReplay = 0.5;
        var forwardReplay = 0.4;
        var reverseReplay = 0.3;
        var compressionRatio = 20.0;
        var replayContent = [];
      };
    }
  };
  
  /// Process hippocampal memory encoding
  public func processHippocampalEncoding(hippState : HippocampusState, sensoryInput : [Float], context : [Float]) : Bool {
    // Pattern separation in dentate gyrus
    let sparseCode = Float.min(1.0, hippState.dentateGyrus.patternSeparation * hippState.dentateGyrus.sparseEncoding);
    hippState.dentateGyrus.granuleCellActivity := sparseCode;
    
    // Mossy fiber transmission to CA3
    hippState.ca3.mossyFiberInput := hippState.dentateGyrus.granuleCellActivity;
    
    // CA3 autoassociative storage
    hippState.ca3.autoassociation := hippState.ca3.recurrentCollaterals * hippState.ca3.mossyFiberInput;
    hippState.ca3.pyramidalActivity := hippState.ca3.autoassociation;
    
    // Schaffer collateral transmission to CA1
    hippState.ca1.schafferCollateralInput := hippState.ca3.pyramidalActivity;
    hippState.ca1.pyramidalActivity := (hippState.ca1.schafferCollateralInput + 
      hippState.ca1.directEntorhinalInput) / 2.0;
    
    // Memory indexing
    let indexStrength = hippState.memoryIndexing.patternBinding * hippState.memoryIndexing.contextAssociation;
    hippState.memoryIndexing.indexCreation := indexStrength;
    
    // Return success if encoding strength is sufficient
    indexStrength > 0.5
  };
  
  /// Process hippocampal memory retrieval
  public func processHippocampalRetrieval(hippState : HippocampusState, cue : [Float]) : Float {
    // Pattern completion in CA3
    hippState.ca3.pyramidalActivity := hippState.ca3.patternCompletion * hippState.ca3.attractorDynamics;
    
    // Retrieval strength
    let retrievalStrength = hippState.ca3.pyramidalActivity * hippState.memoryIndexing.indexRetrieval;
    
    retrievalStrength
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED NEURAL SYSTEMS TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedNeuralSystemsState = {
    var corticalMicrocircuit : CorticalMicrocircuitState;
    var basalGanglia : BasalGangliaState;
    var cerebellum : CerebellumState;
    var hippocampus : HippocampusState;
    var systemsIntegration : Float;
    var globalBrainState : Float;
  };
  
  /// Run integrated neural systems tick
  public func runIntegratedNeuralSystemsTick(
    intState : IntegratedNeuralSystemsState,
    sensoryInput : [Float],
    motorCommand : [Float],
    rewardSignal : Float,
    contextSignal : [Float]
  ) : IntegratedNeuralResult {
    let startTime = Time.now();
    
    // 1. Process cortical microcircuit
    let corticalOutput = intState.corticalMicrocircuit.feedforwardSweep.informationContent;
    
    // 2. Process basal ganglia action selection
    let selectedAction = processBasalGangliaSelection(intState.basalGanglia, sensoryInput, rewardSignal);
    
    // 3. Process cerebellar motor learning
    let correctedMotor = processCerebellarLearning(intState.cerebellum, motorCommand, sensoryInput);
    
    // 4. Process hippocampal memory
    let encodingSuccess = processHippocampalEncoding(intState.hippocampus, sensoryInput, contextSignal);
    
    // 5. Compute systems integration
    let corticalContrib = intState.corticalMicrocircuit.canonicalCircuit.predictiveErrorComputation;
    let bgContrib = intState.basalGanglia.actionSelection.selectionConfidence;
    let cerebellarContrib = intState.cerebellum.motorLearning.forwardModelAccuracy;
    let hippocampalContrib = intState.hippocampus.memoryIndexing.indexCreation;
    
    intState.systemsIntegration := (corticalContrib + bgContrib + cerebellarContrib + hippocampalContrib) / 4.0;
    
    // 6. Compute global brain state
    intState.globalBrainState := intState.systemsIntegration * 
      (1.0 - intState.basalGanglia.hyperdirectPathway.braking);
    
    {
      corticalProcessing = corticalOutput;
      actionSelected = selectedAction;
      motorCorrection = correctedMotor;
      memoryEncoded = encodingSuccess;
      systemsIntegration = intState.systemsIntegration;
      globalBrainState = intState.globalBrainState;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type IntegratedNeuralResult = {
    corticalProcessing : Float;
    actionSelected : ?Nat;
    motorCorrection : [Float];
    memoryEncoded : Bool;
    systemsIntegration : Float;
    globalBrainState : Float;
    processingTime : Int;
  };
  
  /// Get integrated neural systems status
  public func getIntegratedNeuralSystemsStatus(intState : IntegratedNeuralSystemsState) : IntegratedNeuralSystemsStatus {
    {
      corticalStatus = {
        feedforwardStrength = intState.corticalMicrocircuit.feedforwardSweep.informationContent;
        feedbackStrength = intState.corticalMicrocircuit.feedbackModulation.attentionalGain;
        inhibitoryBalance = intState.corticalMicrocircuit.inhibitoryInterneurons.inhibitoryBalance;
        gammaOscillations = intState.corticalMicrocircuit.inhibitoryInterneurons.gammaOscillations;
      };
      basalGangliaStatus = {
        dopamineLevel = intState.basalGanglia.striatum.dopamineLevel;
        directPathwayActivity = intState.basalGanglia.directPathway.activity;
        indirectPathwayActivity = intState.basalGanglia.indirectPathway.activity;
        selectionConfidence = intState.basalGanglia.actionSelection.selectionConfidence;
      };
      cerebellumStatus = {
        motorLearningError = intState.cerebellum.motorLearning.internalModelError;
        forwardModelAccuracy = intState.cerebellum.motorLearning.forwardModelAccuracy;
        timingAccuracy = intState.cerebellum.timing.intervalTiming;
      };
      hippocampusStatus = {
        patternSeparation = intState.hippocampus.dentateGyrus.patternSeparation;
        patternCompletion = intState.hippocampus.ca3.patternCompletion;
        memoryIndexingStrength = intState.hippocampus.memoryIndexing.indexCreation;
        replayActivity = intState.hippocampus.replayState.awakeReplay;
      };
      systemsIntegration = intState.systemsIntegration;
      globalBrainState = intState.globalBrainState;
    }
  };
  
  public type IntegratedNeuralSystemsStatus = {
    corticalStatus : {
      feedforwardStrength : Float;
      feedbackStrength : Float;
      inhibitoryBalance : Float;
      gammaOscillations : Float;
    };
    basalGangliaStatus : {
      dopamineLevel : Float;
      directPathwayActivity : Float;
      indirectPathwayActivity : Float;
      selectionConfidence : Float;
    };
    cerebellumStatus : {
      motorLearningError : Float;
      forwardModelAccuracy : Float;
      timingAccuracy : Float;
    };
    hippocampusStatus : {
      patternSeparation : Float;
      patternCompletion : Float;
      memoryIndexingStrength : Float;
      replayActivity : Float;
    };
    systemsIntegration : Float;
    globalBrainState : Float;
  };
}
