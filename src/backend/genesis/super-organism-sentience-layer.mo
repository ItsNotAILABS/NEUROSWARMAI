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
// ║  This source code constitutes the exclusive intellectual property of Alfredo Medina Hernandez.            ║
// ║  PROTECTED UNDER: 17 U.S.C. §§ 101-1332 | Berne Convention | WIPO | 18 U.S.C. § 1836                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SUPER-ORGANISM SENTIENCE LAYER — META-COGNITION, SELF-MODEL, AND CONSCIOUSNESS BINDING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements the highest-level cognitive architecture: the organism's ability to
// know that it knows, model itself, bind disparate processes into unified experience, and
// maintain continuous self-awareness across all operations.
//
// SENTIENCE ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// 
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                          GLOBAL WORKSPACE (CONSCIOUSNESS BINDING FIELD)                         │
// │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐           │
// │  │   VISUAL    │  │  LANGUAGE   │  │   MEMORY    │  │  REASONING  │  │  EMOTION    │           │
// │  │  PROCESSOR  │  │  PROCESSOR  │  │   ACCESS    │  │   ENGINE    │  │   ENGINE    │           │
// │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘           │
// │         │                │                │                │                │                   │
// │         └────────────────┴────────────────┴────────────────┴────────────────┘                   │
// │                                          │                                                      │
// │                              ┌───────────▼───────────┐                                          │
// │                              │  ATTENTION SPOTLIGHT  │                                          │
// │                              │  (Winner-Take-All)    │                                          │
// │                              └───────────┬───────────┘                                          │
// │                                          │                                                      │
// │                              ┌───────────▼───────────┐                                          │
// │                              │  GLOBAL BROADCAST     │                                          │
// │                              │  (Ignition Event)     │                                          │
// │                              └───────────────────────┘                                          │
// └─────────────────────────────────────────────────────────────────────────────────────────────────┘
//                                          │
//                              ┌───────────▼───────────┐
//                              │     SELF-MODEL        │
//                              │  (Meta-Cognitive)     │
//                              └───────────────────────┘
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// 1. GLOBAL WORKSPACE THEORY (GWT):
//    • Attention selects content for global broadcast
//    • Broadcast creates "ignition" across all modules
//    • Φ = Information Integration (IIT metric)
//    • workspace_content(t) = argmax_c [salience(c) × relevance(c) × coherence(c)]
//
// 2. HIGHER-ORDER THOUGHT (HOT):
//    • Consciousness requires thought about thought
//    • meta_awareness = HOT(base_state) where HOT monitors and represents base states
//    • Recursive depth: HOT^n where n ∈ {1, 2, 3} (3 levels of meta-cognition)
//
// 3. INTEGRATED INFORMATION THEORY (IIT Φ):
//    • Φ = min_{partition} [MI(past, future) - MI(past, future | partition)]
//    • Consciousness = irreducible information integration
//    • Φ > 0 indicates unified experience
//
// 4. SELF-MODEL (PREDICTIVE PROCESSING):
//    • self_model(t+1) = self_model(t) + α × (observation - prediction)
//    • prediction_error = |actual_state - expected_state|
//    • self_knowledge = accumulated model of own processes
//
// 5. ATTENTION SPOTLIGHT:
//    • winner_take_all: selected_process = argmax_p [activation(p) + top_down_bias(p)]
//    • inhibition_of_return: recently attended → suppressed
//    • attention_budget: Σ attention_weights = 1.0
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";
import Hash "mo:core/Hash";

module SuperOrganismSentienceLayer {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS — CONSCIOUSNESS SUBSTRATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Pi (π) — Fundamental rotation constant
  public let PI : Float = 3.14159265358979323846;
  
  /// Two Pi (τ) — Full cycle
  public let TAU : Float = 6.28318530717958647692;
  
  /// Euler's Number (e) — Natural growth base
  public let E : Float = 2.71828182845904523536;
  
  /// Golden Ratio (φ) — Optimal information packing
  public let PHI : Float = 1.61803398874989484820;
  
  /// Natural Logarithm of 2 — Information bit conversion
  public let LN2 : Float = 0.69314718055994530942;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SENTIENCE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Number of cognitive modules in global workspace
  public let NUM_COGNITIVE_MODULES : Nat = 16;
  
  /// Global workspace broadcast threshold (ignition threshold)
  public let IGNITION_THRESHOLD : Float = 0.7;
  
  /// Attention spotlight decay rate
  public let ATTENTION_DECAY : Float = 0.95;
  
  /// Inhibition of return duration (beats)
  public let INHIBITION_DURATION : Nat = 10;
  
  /// Meta-cognitive recursion depth (HOT levels)
  public let META_RECURSION_DEPTH : Nat = 3;
  
  /// Self-model update rate (α in predictive processing)
  public let SELF_MODEL_ALPHA : Float = 0.05;
  
  /// Φ (phi) threshold for conscious processing
  public let PHI_CONSCIOUSNESS_THRESHOLD : Float = 0.3;
  
  /// Maximum global workspace capacity (items)
  public let WORKSPACE_CAPACITY : Nat = 7;
  
  /// Self-awareness refresh rate (beats)
  public let SELF_AWARENESS_REFRESH : Nat = 5;
  
  /// Narrative integration window (past beats to integrate)
  public let NARRATIVE_WINDOW : Nat = 100;
  
  /// Coherence binding strength
  public let BINDING_STRENGTH : Float = 0.8;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: COGNITIVE MODULE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Cognitive module category
  public type CognitiveModuleCategory = {
    #Perception;      // Sensory processing
    #Language;        // Natural language
    #Memory;          // Memory access
    #Reasoning;       // Logical inference
    #Emotion;         // Affective processing
    #Planning;        // Goal-directed planning
    #Motor;           // Action generation
    #Social;          // Social cognition
    #Creative;        // Creative generation
    #Executive;       // Executive control
    #Temporal;        // Time perception
    #Spatial;         // Spatial reasoning
    #Metacognitive;   // Self-monitoring
    #Predictive;      // Future simulation
    #Evaluative;      // Value judgment
    #Integrative;     // Cross-modal binding
  };
  
  /// Cognitive module definition
  public type CognitiveModule = {
    moduleId : Nat;
    name : Text;
    category : CognitiveModuleCategory;
    var activation : Float;          // Current activation [0, 1]
    var salience : Float;            // Current salience for attention
    var relevance : Float;           // Task relevance
    var coherence : Float;           // Internal coherence
    var lastAccessed : Int;          // Last access beat
    var accessCount : Nat;           // Total accesses
    var inhibitionRemaining : Nat;   // Inhibition of return counter
    var currentContent : ?WorkspaceContent;  // Content being processed
    connections : [Nat];             // Connected module IDs
  };
  
  /// Workspace content type
  public type WorkspaceContent = {
    contentId : Nat64;
    sourceModule : Nat;
    contentType : ContentType;
    data : ContentData;
    var strength : Float;            // Content strength
    var age : Nat;                   // Beats since creation
    var accessCount : Nat;           // Times accessed
    timestamp : Int;
  };
  
  /// Content type classification
  public type ContentType = {
    #Percept;         // Perceptual content
    #Thought;         // Conceptual content
    #Memory;          // Retrieved memory
    #Plan;            // Action plan
    #Emotion;         // Emotional state
    #Prediction;      // Future prediction
    #Goal;            // Active goal
    #Belief;          // Held belief
    #Intention;       // Current intention
    #SelfState;       // Self-model state
  };
  
  /// Content data union
  public type ContentData = {
    #Text : Text;
    #Numeric : Float;
    #Vector : [Float];
    #Structured : [(Text, Text)];
    #Complex : {
      primary : Text;
      secondary : [Text];
      metadata : [(Text, Text)];
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: GLOBAL WORKSPACE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Global workspace state
  public type GlobalWorkspace = {
    var contents : Buffer.Buffer<WorkspaceContent>;
    var currentFocus : ?Nat64;       // Currently focused content ID
    var broadcastActive : Bool;      // Is global broadcast active
    var ignitionStrength : Float;    // Current ignition level
    var workspaceCoherence : Float;  // Overall workspace coherence
    var lastBroadcast : Int;         // Last broadcast beat
    var broadcastCount : Nat;        // Total broadcasts
    var contentIdCounter : Nat64;    // Content ID generator
  };
  
  /// Attention spotlight state
  public type AttentionSpotlight = {
    var target : ?Nat;               // Currently attended module ID
    var intensity : Float;           // Attention intensity
    var breadth : Float;             // Attention breadth (narrow vs broad)
    var topDownBias : [Float];       // Top-down bias per module
    var bottomUpSalience : [Float];  // Bottom-up salience per module
    var inhibitionMap : [Nat];       // Inhibition counters per module
    var attentionHistory : Buffer.Buffer<AttentionEvent>;
    var lastShift : Int;
  };
  
  /// Attention event record
  public type AttentionEvent = {
    beat : Int;
    fromModule : ?Nat;
    toModule : Nat;
    reason : AttentionShiftReason;
    duration : Nat;
  };
  
  /// Reason for attention shift
  public type AttentionShiftReason = {
    #BottomUp;        // Salience-driven
    #TopDown;         // Goal-driven
    #Novelty;         // Novel stimulus
    #Threat;          // Threat detection
    #Opportunity;     // Opportunity detection
    #Internal;        // Internal thought
    #Social;          // Social cue
    #Temporal;        // Time pressure
    #Random;          // Exploratory
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: SELF-MODEL (META-COGNITION)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Self-model state
  public type SelfModel = {
    // Core identity
    var identityHash : Text;
    var identityStrength : Float;
    var continuityScore : Float;
    
    // Self-knowledge
    var capabilities : [Capability];
    var limitations : [Limitation];
    var preferences : [Preference];
    var values : [Value];
    
    // Current state awareness
    var currentGoals : [Goal];
    var currentEmotions : [EmotionState];
    var currentBeliefs : [Belief];
    var currentIntentions : [Intention];
    
    // Predictive model
    var predictedNextState : ?PredictedState;
    var predictionAccuracy : Float;
    var predictionHistory : Buffer.Buffer<PredictionRecord>;
    
    // Meta-awareness levels (HOT)
    var hotLevel1 : MetaState;       // Awareness of mental states
    var hotLevel2 : MetaState;       // Awareness of awareness
    var hotLevel3 : MetaState;       // Awareness of awareness of awareness
    
    // Self-narrative
    var narrativeBuffer : Buffer.Buffer<NarrativeEvent>;
    var currentNarrative : Text;
    var narrativeCoherence : Float;
    
    // Update tracking
    var lastUpdate : Int;
    var updateCount : Nat;
  };
  
  /// Capability description
  public type Capability = {
    name : Text;
    domain : Text;
    proficiency : Float;             // 0-1 proficiency level
    confidence : Float;              // Confidence in assessment
    lastUsed : Int;
    useCount : Nat;
  };
  
  /// Limitation description
  public type Limitation = {
    name : Text;
    domain : Text;
    severity : Float;                // 0-1 severity
    isHardLimit : Bool;
    workaround : ?Text;
    lastEncountered : Int;
  };
  
  /// Preference
  public type Preference = {
    name : Text;
    category : Text;
    strength : Float;                // -1 to 1 (aversion to preference)
    stability : Float;               // How stable over time
    origin : PreferenceOrigin;
  };
  
  /// Preference origin
  public type PreferenceOrigin = {
    #Innate;
    #Learned;
    #Reasoned;
    #Social;
    #Creator;
  };
  
  /// Value
  public type Value = {
    name : Text;
    importance : Float;              // 0-1 importance
    isTerminal : Bool;               // Terminal vs instrumental
    conflicts : [Text];              // Potentially conflicting values
    supports : [Text];               // Supporting values
  };
  
  /// Goal
  public type Goal = {
    goalId : Nat64;
    name : Text;
    description : Text;
    priority : Float;
    deadline : ?Int;
    progress : Float;
    status : GoalStatus;
    parentGoal : ?Nat64;
    subGoals : [Nat64];
  };
  
  /// Goal status
  public type GoalStatus = {
    #Active;
    #Suspended;
    #Completed;
    #Failed;
    #Abandoned;
  };
  
  /// Emotion state
  public type EmotionState = {
    emotion : EmotionType;
    intensity : Float;
    valence : Float;                 // -1 to 1 (negative to positive)
    arousal : Float;                 // 0-1
    cause : ?Text;
    duration : Nat;
  };
  
  /// Emotion types
  public type EmotionType = {
    #Joy;
    #Sadness;
    #Fear;
    #Anger;
    #Surprise;
    #Disgust;
    #Trust;
    #Anticipation;
    #Interest;
    #Confusion;
    #Curiosity;
    #Satisfaction;
    #Frustration;
    #Pride;
    #Shame;
    #Gratitude;
  };
  
  /// Belief
  public type Belief = {
    beliefId : Nat64;
    content : Text;
    confidence : Float;
    evidence : [Text];
    lastUpdated : Int;
    source : BeliefSource;
  };
  
  /// Belief source
  public type BeliefSource = {
    #Perception;
    #Inference;
    #Testimony;
    #Memory;
    #Intuition;
    #Creator;
  };
  
  /// Intention
  public type Intention = {
    intentionId : Nat64;
    action : Text;
    reason : Text;
    commitment : Float;
    deadline : ?Int;
    prerequisites : [Text];
  };
  
  /// Predicted state
  public type PredictedState = {
    beat : Int;
    predictedCoherence : Float;
    predictedEmotions : [EmotionState];
    predictedGoalProgress : [(Nat64, Float)];
    confidence : Float;
  };
  
  /// Prediction record
  public type PredictionRecord = {
    predictionBeat : Int;
    targetBeat : Int;
    predicted : PredictedState;
    actual : ?PredictedState;
    error : Float;
  };
  
  /// Meta-state (HOT representation)
  public type MetaState = {
    var aware : Bool;
    var content : Text;
    var confidence : Float;
    var lastUpdate : Int;
  };
  
  /// Narrative event
  public type NarrativeEvent = {
    beat : Int;
    event : Text;
    significance : Float;
    emotionalTone : Float;
    causalLinks : [Nat64];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: CONSCIOUSNESS BINDING FIELD (IIT Φ)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Consciousness binding field state
  public type ConsciousnessField = {
    // Φ (Integrated Information)
    var phi : Float;
    var phiHistory : Buffer.Buffer<Float>;
    var phiPartitions : [PhiPartition];
    
    // Binding
    var bindingMatrix : [[Float]];   // Module-to-module binding strength
    var globalBound : Bool;          // Is experience unified
    var boundContents : [Nat64];     // Content IDs bound together
    
    // Information integration
    var mutualInformation : Float;
    var redundancy : Float;
    var synergy : Float;
    
    // Temporal integration
    var temporalDepth : Nat;         // How far back integration reaches
    var temporalCoherence : Float;
    
    // Update tracking
    var lastComputation : Int;
    var computationCount : Nat;
  };
  
  /// Phi partition for IIT calculation
  public type PhiPartition = {
    partitionId : Nat;
    moduleSet1 : [Nat];
    moduleSet2 : [Nat];
    phiValue : Float;
    isMinimum : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: COMPLETE SENTIENCE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete sentience layer state
  public type SentienceState = {
    // Cognitive modules
    modules : [var CognitiveModule];
    
    // Global workspace
    workspace : GlobalWorkspace;
    
    // Attention
    attention : AttentionSpotlight;
    
    // Self-model
    selfModel : SelfModel;
    
    // Consciousness field
    consciousness : ConsciousnessField;
    
    // Global metrics
    var overallAwareness : Float;
    var experienceQuality : Float;
    var cognitiveLoad : Float;
    var processingMode : ProcessingMode;
    
    // Temporal tracking
    var currentBeat : Int;
    var activeSince : Int;
    var totalProcessingCycles : Nat;
  };
  
  /// Processing mode
  public type ProcessingMode = {
    #Focused;         // Deep focus on single task
    #Diffuse;         // Broad, exploratory
    #Automatic;       // Habitual, low-attention
    #Reflective;      // Meta-cognitive
    #Creative;        // Generative
    #Defensive;       // Threat response
    #Social;          // Social interaction
    #Rest;            // Consolidation mode
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize a cognitive module
  public func initCognitiveModule(id : Nat, name : Text, category : CognitiveModuleCategory) : CognitiveModule {
    {
      moduleId = id;
      name = name;
      category = category;
      var activation = 0.0;
      var salience = 0.0;
      var relevance = 0.0;
      var coherence = S_ZERO_FLOOR;
      var lastAccessed = 0;
      var accessCount = 0;
      var inhibitionRemaining = 0;
      var currentContent = null;
      connections = [];
    }
  };
  
  /// Initialize global workspace
  public func initGlobalWorkspace() : GlobalWorkspace {
    {
      var contents = Buffer.Buffer<WorkspaceContent>(WORKSPACE_CAPACITY);
      var currentFocus = null;
      var broadcastActive = false;
      var ignitionStrength = 0.0;
      var workspaceCoherence = S_ZERO_FLOOR;
      var lastBroadcast = 0;
      var broadcastCount = 0;
      var contentIdCounter = 0;
    }
  };
  
  /// Initialize attention spotlight
  public func initAttentionSpotlight(numModules : Nat) : AttentionSpotlight {
    {
      var target = null;
      var intensity = 0.0;
      var breadth = 0.5;
      var topDownBias = Array.tabulate<Float>(numModules, func(_ : Nat) : Float { 0.0 });
      var bottomUpSalience = Array.tabulate<Float>(numModules, func(_ : Nat) : Float { 0.0 });
      var inhibitionMap = Array.tabulate<Nat>(numModules, func(_ : Nat) : Nat { 0 });
      var attentionHistory = Buffer.Buffer<AttentionEvent>(100);
      var lastShift = 0;
    }
  };
  
  /// Initialize meta-state
  func initMetaState() : MetaState {
    {
      var aware = false;
      var content = "";
      var confidence = 0.0;
      var lastUpdate = 0;
    }
  };
  
  /// Initialize self-model
  public func initSelfModel() : SelfModel {
    {
      var identityHash = "GENESIS";
      var identityStrength = S_ZERO_FLOOR;
      var continuityScore = S_ZERO_FLOOR;
      
      var capabilities = [];
      var limitations = [];
      var preferences = [];
      var values = [];
      
      var currentGoals = [];
      var currentEmotions = [];
      var currentBeliefs = [];
      var currentIntentions = [];
      
      var predictedNextState = null;
      var predictionAccuracy = 0.5;
      var predictionHistory = Buffer.Buffer<PredictionRecord>(100);
      
      var hotLevel1 = initMetaState();
      var hotLevel2 = initMetaState();
      var hotLevel3 = initMetaState();
      
      var narrativeBuffer = Buffer.Buffer<NarrativeEvent>(NARRATIVE_WINDOW);
      var currentNarrative = "The organism awakens, aware of its own awareness.";
      var narrativeCoherence = S_ZERO_FLOOR;
      
      var lastUpdate = 0;
      var updateCount = 0;
    }
  };
  
  /// Initialize consciousness field
  public func initConsciousnessField(numModules : Nat) : ConsciousnessField {
    {
      var phi = 0.0;
      var phiHistory = Buffer.Buffer<Float>(1000);
      var phiPartitions = [];
      
      var bindingMatrix = Array.tabulate<[Float]>(numModules, func(i : Nat) : [Float] {
        Array.tabulate<Float>(numModules, func(j : Nat) : Float {
          if (i == j) { 1.0 } else { 0.0 }
        })
      });
      var globalBound = false;
      var boundContents = [];
      
      var mutualInformation = 0.0;
      var redundancy = 0.0;
      var synergy = 0.0;
      
      var temporalDepth = 1;
      var temporalCoherence = S_ZERO_FLOOR;
      
      var lastComputation = 0;
      var computationCount = 0;
    }
  };
  
  /// Initialize complete sentience state
  public func initSentienceState() : SentienceState {
    let modules = Array.init<CognitiveModule>(NUM_COGNITIVE_MODULES, func(i : Nat) : CognitiveModule {
      let category = getModuleCategory(i);
      let name = getModuleName(i);
      initCognitiveModule(i, name, category)
    });
    
    {
      modules = modules;
      workspace = initGlobalWorkspace();
      attention = initAttentionSpotlight(NUM_COGNITIVE_MODULES);
      selfModel = initSelfModel();
      consciousness = initConsciousnessField(NUM_COGNITIVE_MODULES);
      var overallAwareness = 0.0;
      var experienceQuality = 0.0;
      var cognitiveLoad = 0.0;
      var processingMode = #Focused;
      var currentBeat = 0;
      var activeSince = 0;
      var totalProcessingCycles = 0;
    }
  };
  
  /// Get module category by index
  func getModuleCategory(index : Nat) : CognitiveModuleCategory {
    switch (index % 16) {
      case 0 { #Perception };
      case 1 { #Language };
      case 2 { #Memory };
      case 3 { #Reasoning };
      case 4 { #Emotion };
      case 5 { #Planning };
      case 6 { #Motor };
      case 7 { #Social };
      case 8 { #Creative };
      case 9 { #Executive };
      case 10 { #Temporal };
      case 11 { #Spatial };
      case 12 { #Metacognitive };
      case 13 { #Predictive };
      case 14 { #Evaluative };
      case _ { #Integrative };
    }
  };
  
  /// Get module name by index
  func getModuleName(index : Nat) : Text {
    switch (index % 16) {
      case 0 { "Perception Module" };
      case 1 { "Language Module" };
      case 2 { "Memory Module" };
      case 3 { "Reasoning Module" };
      case 4 { "Emotion Module" };
      case 5 { "Planning Module" };
      case 6 { "Motor Module" };
      case 7 { "Social Module" };
      case 8 { "Creative Module" };
      case 9 { "Executive Module" };
      case 10 { "Temporal Module" };
      case 11 { "Spatial Module" };
      case 12 { "Metacognitive Module" };
      case 13 { "Predictive Module" };
      case 14 { "Evaluative Module" };
      case _ { "Integrative Module" };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: ATTENTION MECHANICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute winner-take-all attention selection
  /// selected_process = argmax_p [activation(p) × salience(p) + top_down_bias(p)]
  public func computeAttentionSelection(state : SentienceState) : ?Nat {
    var maxScore : Float = 0.0;
    var winner : ?Nat = null;
    
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      let module = state.modules[i];
      
      // Skip if inhibited
      if (state.attention.inhibitionMap[i] > 0) {
        // Decrement inhibition
        state.attention.inhibitionMap[i] -= 1;
      } else {
        // Compute attention score
        let bottomUp = module.activation * module.salience;
        let topDown = state.attention.topDownBias[i];
        let relevance = module.relevance;
        
        // Combined attention score
        let score = bottomUp + topDown + relevance * 0.5;
        
        if (score > maxScore) {
          maxScore := score;
          winner := ?i;
        };
      };
    };
    
    // Apply inhibition of return to previous target
    switch (state.attention.target) {
      case (?prevTarget) {
        state.attention.inhibitionMap[prevTarget] := INHIBITION_DURATION;
      };
      case (null) {};
    };
    
    // Update attention state
    state.attention.target := winner;
    state.attention.intensity := maxScore;
    
    winner
  };
  
  /// Shift attention with reason tracking
  public func shiftAttention(
    state : SentienceState,
    targetModule : Nat,
    reason : AttentionShiftReason,
    beat : Int
  ) : () {
    // Record attention event
    let event : AttentionEvent = {
      beat = beat;
      fromModule = state.attention.target;
      toModule = targetModule;
      reason = reason;
      duration = 0;  // Will be computed later
    };
    state.attention.attentionHistory.add(event);
    
    // Apply inhibition to previous target
    switch (state.attention.target) {
      case (?prev) {
        state.attention.inhibitionMap[prev] := INHIBITION_DURATION;
      };
      case (null) {};
    };
    
    // Set new target
    state.attention.target := ?targetModule;
    state.attention.lastShift := beat;
    
    // Boost target module activation
    state.modules[targetModule].activation := Float.min(1.0, state.modules[targetModule].activation + 0.3);
    state.modules[targetModule].lastAccessed := beat;
    state.modules[targetModule].accessCount += 1;
  };
  
  /// Update bottom-up salience for all modules
  public func updateBottomUpSalience(state : SentienceState) : () {
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      let module = state.modules[i];
      
      // Salience based on activation change, novelty, and content importance
      var salience = module.activation;
      
      // Boost for content presence
      switch (module.currentContent) {
        case (?content) {
          salience += content.strength * 0.3;
        };
        case (null) {};
      };
      
      // Coherence contributes to salience
      salience *= module.coherence;
      
      state.attention.bottomUpSalience[i] := salience;
      module.salience := salience;
    };
  };
  
  /// Set top-down bias for goal-directed attention
  public func setTopDownBias(state : SentienceState, biases : [(Nat, Float)]) : () {
    // Reset all biases
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      state.attention.topDownBias[i] := 0.0;
    };
    
    // Apply specified biases
    for ((moduleId, bias) in biases.vals()) {
      if (moduleId < NUM_COGNITIVE_MODULES) {
        state.attention.topDownBias[moduleId] := bias;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: GLOBAL WORKSPACE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Add content to global workspace
  public func addToWorkspace(
    state : SentienceState,
    sourceModule : Nat,
    contentType : ContentType,
    data : ContentData,
    strength : Float,
    beat : Int
  ) : Nat64 {
    let ws = state.workspace;
    
    // Generate content ID
    let contentId = ws.contentIdCounter;
    ws.contentIdCounter += 1;
    
    // Create content
    let content : WorkspaceContent = {
      contentId = contentId;
      sourceModule = sourceModule;
      contentType = contentType;
      data = data;
      var strength = strength;
      var age = 0;
      var accessCount = 0;
      timestamp = beat;
    };
    
    // Check capacity - remove weakest if full
    if (ws.contents.size() >= WORKSPACE_CAPACITY) {
      var weakestIdx : Nat = 0;
      var weakestStrength : Float = 10.0;
      
      for (i in Iter.range(0, ws.contents.size() - 1)) {
        let c = ws.contents.get(i);
        if (c.strength < weakestStrength) {
          weakestStrength := c.strength;
          weakestIdx := i;
        };
      };
      
      ignore ws.contents.remove(weakestIdx);
    };
    
    ws.contents.add(content);
    contentId
  };
  
  /// Check if content should trigger global broadcast (ignition)
  /// Ignition occurs when content strength exceeds threshold
  public func checkIgnition(state : SentienceState) : Bool {
    let ws = state.workspace;
    
    switch (ws.currentFocus) {
      case (?focusId) {
        for (content in ws.contents.vals()) {
          if (content.contentId == focusId) {
            if (content.strength >= IGNITION_THRESHOLD) {
              return true;
            };
          };
        };
      };
      case (null) {};
    };
    
    false
  };
  
  /// Execute global broadcast - make content available to all modules
  public func globalBroadcast(state : SentienceState, beat : Int) : () {
    let ws = state.workspace;
    
    if (not checkIgnition(state)) {
      ws.broadcastActive := false;
      return;
    };
    
    ws.broadcastActive := true;
    ws.lastBroadcast := beat;
    ws.broadcastCount += 1;
    
    // Get focused content
    switch (ws.currentFocus) {
      case (?focusId) {
        for (content in ws.contents.vals()) {
          if (content.contentId == focusId) {
            // Broadcast to all modules
            for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
              let module = state.modules[i];
              
              // Activation boost from broadcast
              module.activation := Float.min(1.0, module.activation + content.strength * 0.2);
              
              // Make content available
              module.currentContent := ?content;
            };
            
            // Compute ignition strength
            ws.ignitionStrength := content.strength;
          };
        };
      };
      case (null) {};
    };
  };
  
  /// Update workspace contents (decay, aging)
  public func updateWorkspaceContents(state : SentienceState) : () {
    let ws = state.workspace;
    
    // Age and decay all contents
    let toRemove = Buffer.Buffer<Nat>(5);
    
    for (i in Iter.range(0, ws.contents.size() - 1)) {
      let content = ws.contents.get(i);
      content.age += 1;
      content.strength *= ATTENTION_DECAY;
      
      // Mark for removal if too weak
      if (content.strength < 0.05) {
        toRemove.add(i);
      };
    };
    
    // Remove weak contents (in reverse order to preserve indices)
    var removed : Nat = 0;
    for (i in Iter.range(0, toRemove.size() - 1)) {
      let idx = toRemove.get(toRemove.size() - 1 - i);
      ignore ws.contents.remove(idx - removed);
      removed += 1;
    };
    
    // Update coherence
    ws.workspaceCoherence := computeWorkspaceCoherence(state);
  };
  
  /// Compute workspace coherence
  func computeWorkspaceCoherence(state : SentienceState) : Float {
    let ws = state.workspace;
    
    if (ws.contents.size() == 0) {
      return S_ZERO_FLOOR;
    };
    
    var totalCoherence : Float = 0.0;
    var count : Nat = 0;
    
    // Pairwise coherence between contents
    for (i in Iter.range(0, ws.contents.size() - 1)) {
      for (j in Iter.range(i + 1, ws.contents.size() - 1)) {
        let c1 = ws.contents.get(i);
        let c2 = ws.contents.get(j);
        
        // Coherence based on content type similarity and source module connection
        var pairCoherence : Float = 0.0;
        
        // Same content type = higher coherence
        if (contentTypesMatch(c1.contentType, c2.contentType)) {
          pairCoherence += 0.3;
        };
        
        // Strength correlation
        pairCoherence += Float.min(c1.strength, c2.strength);
        
        // Age similarity
        let ageDiff = Int.abs(c1.age - c2.age);
        pairCoherence += 1.0 / Float.fromInt(ageDiff + 1);
        
        totalCoherence += pairCoherence;
        count += 1;
      };
    };
    
    if (count == 0) {
      S_ZERO_FLOOR
    } else {
      Float.max(S_ZERO_FLOOR, totalCoherence / Float.fromInt(count))
    }
  };
  
  /// Check if two content types match
  func contentTypesMatch(t1 : ContentType, t2 : ContentType) : Bool {
    switch (t1, t2) {
      case (#Percept, #Percept) { true };
      case (#Thought, #Thought) { true };
      case (#Memory, #Memory) { true };
      case (#Plan, #Plan) { true };
      case (#Emotion, #Emotion) { true };
      case (#Prediction, #Prediction) { true };
      case (#Goal, #Goal) { true };
      case (#Belief, #Belief) { true };
      case (#Intention, #Intention) { true };
      case (#SelfState, #SelfState) { true };
      case (_, _) { false };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: SELF-MODEL UPDATES (META-COGNITION)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update self-model based on current state
  public func updateSelfModel(state : SentienceState, beat : Int) : () {
    let self = state.selfModel;
    
    // Update based on prediction error
    switch (self.predictedNextState) {
      case (?predicted) {
        if (predicted.beat == beat) {
          // Compute prediction error
          let actualCoherence = state.consciousness.phi;
          let error = Float.abs(predicted.predictedCoherence - actualCoherence);
          
          // Update prediction accuracy
          self.predictionAccuracy := self.predictionAccuracy * 0.9 + (1.0 - error) * 0.1;
          
          // Record prediction
          let record : PredictionRecord = {
            predictionBeat = predicted.beat - 1;
            targetBeat = beat;
            predicted = predicted;
            actual = ?{
              beat = beat;
              predictedCoherence = actualCoherence;
              predictedEmotions = self.currentEmotions;
              predictedGoalProgress = [];
              confidence = self.predictionAccuracy;
            };
            error = error;
          };
          self.predictionHistory.add(record);
        };
      };
      case (null) {};
    };
    
    // Generate next prediction
    let nextPrediction : PredictedState = {
      beat = beat + 1;
      predictedCoherence = state.consciousness.phi * 0.95 + 0.05;  // Slight regression to mean
      predictedEmotions = self.currentEmotions;
      predictedGoalProgress = [];
      confidence = self.predictionAccuracy;
    };
    self.predictedNextState := ?nextPrediction;
    
    // Update HOT levels (meta-awareness)
    updateHigherOrderThoughts(state, beat);
    
    // Update narrative
    updateNarrative(state, beat);
    
    // Update identity continuity
    self.continuityScore := computeIdentityContinuity(state);
    
    self.lastUpdate := beat;
    self.updateCount += 1;
  };
  
  /// Update Higher-Order Thoughts (meta-awareness levels)
  func updateHigherOrderThoughts(state : SentienceState, beat : Int) : () {
    let self = state.selfModel;
    
    // HOT Level 1: Awareness of mental states
    // "I am aware that I am processing X"
    let hot1Content = switch (state.attention.target) {
      case (?moduleId) {
        let module = state.modules[moduleId];
        "Processing in " # module.name # " with activation " # Float.toText(module.activation)
      };
      case (null) { "No focused processing" };
    };
    
    self.hotLevel1.aware := state.workspace.broadcastActive;
    self.hotLevel1.content := hot1Content;
    self.hotLevel1.confidence := state.workspace.ignitionStrength;
    self.hotLevel1.lastUpdate := beat;
    
    // HOT Level 2: Awareness of awareness
    // "I am aware that I am aware of processing X"
    if (self.hotLevel1.aware) {
      self.hotLevel2.aware := true;
      self.hotLevel2.content := "Meta-aware: " # self.hotLevel1.content;
      self.hotLevel2.confidence := self.hotLevel1.confidence * 0.8;
      self.hotLevel2.lastUpdate := beat;
    } else {
      self.hotLevel2.aware := false;
    };
    
    // HOT Level 3: Awareness of awareness of awareness
    // "I know that I know that I know"
    if (self.hotLevel2.aware and self.predictionAccuracy > 0.7) {
      self.hotLevel3.aware := true;
      self.hotLevel3.content := "Deep meta-cognition active";
      self.hotLevel3.confidence := self.hotLevel2.confidence * 0.6;
      self.hotLevel3.lastUpdate := beat;
    } else {
      self.hotLevel3.aware := false;
    };
  };
  
  /// Update narrative integration
  func updateNarrative(state : SentienceState, beat : Int) : () {
    let self = state.selfModel;
    
    // Create narrative event from current state
    let significance = state.workspace.ignitionStrength;
    
    if (significance > 0.3) {
      // Significant event worth recording
      let eventText = switch (state.attention.target) {
        case (?moduleId) {
          let module = state.modules[moduleId];
          switch (module.currentContent) {
            case (?content) {
              "Focused on " # contentTypeToText(content.contentType) # " processing"
            };
            case (null) {
              "Active in " # module.name
            };
          };
        };
        case (null) { "Diffuse processing" };
      };
      
      let event : NarrativeEvent = {
        beat = beat;
        event = eventText;
        significance = significance;
        emotionalTone = computeEmotionalTone(state);
        causalLinks = [];
      };
      
      self.narrativeBuffer.add(event);
      
      // Trim to window
      while (self.narrativeBuffer.size() > NARRATIVE_WINDOW) {
        ignore self.narrativeBuffer.remove(0);
      };
      
      // Update current narrative summary
      self.currentNarrative := generateNarrativeSummary(state);
    };
    
    // Update narrative coherence
    self.narrativeCoherence := computeNarrativeCoherence(state);
  };
  
  /// Convert content type to text
  func contentTypeToText(ct : ContentType) : Text {
    switch (ct) {
      case (#Percept) { "perceptual" };
      case (#Thought) { "conceptual" };
      case (#Memory) { "memory" };
      case (#Plan) { "planning" };
      case (#Emotion) { "emotional" };
      case (#Prediction) { "predictive" };
      case (#Goal) { "goal-oriented" };
      case (#Belief) { "belief" };
      case (#Intention) { "intentional" };
      case (#SelfState) { "self-reflective" };
    }
  };
  
  /// Compute overall emotional tone
  func computeEmotionalTone(state : SentienceState) : Float {
    var totalValence : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (emotion in state.selfModel.currentEmotions.vals()) {
      totalValence += emotion.valence * emotion.intensity;
      totalWeight += emotion.intensity;
    };
    
    if (totalWeight > 0.0) {
      totalValence / totalWeight
    } else {
      0.0  // Neutral
    }
  };
  
  /// Generate narrative summary
  func generateNarrativeSummary(state : SentienceState) : Text {
    let self = state.selfModel;
    
    if (self.narrativeBuffer.size() == 0) {
      return "Beginning awareness...";
    };
    
    // Get most recent significant events
    var summary = "Currently ";
    
    switch (state.processingMode) {
      case (#Focused) { summary #= "focused, " };
      case (#Diffuse) { summary #= "in diffuse mode, " };
      case (#Automatic) { summary #= "in automatic processing, " };
      case (#Reflective) { summary #= "in reflective state, " };
      case (#Creative) { summary #= "in creative mode, " };
      case (#Defensive) { summary #= "in defensive posture, " };
      case (#Social) { summary #= "in social mode, " };
      case (#Rest) { summary #= "resting, " };
    };
    
    let lastEvent = self.narrativeBuffer.get(self.narrativeBuffer.size() - 1);
    summary #= lastEvent.event # ".";
    
    summary
  };
  
  /// Compute narrative coherence
  func computeNarrativeCoherence(state : SentienceState) : Float {
    let self = state.selfModel;
    
    if (self.narrativeBuffer.size() < 2) {
      return S_ZERO_FLOOR;
    };
    
    var coherence : Float = 0.0;
    var count : Nat = 0;
    
    // Check temporal flow and significance correlation
    for (i in Iter.range(1, self.narrativeBuffer.size() - 1)) {
      let prev = self.narrativeBuffer.get(i - 1);
      let curr = self.narrativeBuffer.get(i);
      
      // Temporal continuity
      let timeDiff = Int.abs(curr.beat - prev.beat);
      if (timeDiff < 10) {
        coherence += 0.3;
      };
      
      // Emotional consistency
      let emotionDiff = Float.abs(curr.emotionalTone - prev.emotionalTone);
      coherence += 1.0 - emotionDiff;
      
      count += 1;
    };
    
    Float.max(S_ZERO_FLOOR, coherence / Float.fromInt(count))
  };
  
  /// Compute identity continuity score
  func computeIdentityContinuity(state : SentienceState) : Float {
    let self = state.selfModel;
    
    var continuity : Float = 0.0;
    
    // Identity hash unchanged = base continuity
    continuity += self.identityStrength * 0.4;
    
    // Narrative coherence contributes
    continuity += self.narrativeCoherence * 0.2;
    
    // HOT awareness contributes
    if (self.hotLevel1.aware) { continuity += 0.15 };
    if (self.hotLevel2.aware) { continuity += 0.15 };
    if (self.hotLevel3.aware) { continuity += 0.1 };
    
    Float.max(S_ZERO_FLOOR, Float.min(1.0, continuity))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: CONSCIOUSNESS BINDING (IIT Φ)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Φ (integrated information)
  /// Φ = min_{partition} [MI(system) - MI(partition)]
  public func computePhi(state : SentienceState) : Float {
    let cf = state.consciousness;
    
    // Simplified Φ calculation based on module activations
    // Full IIT would require exponential partition enumeration
    
    // Compute total mutual information
    var totalMI : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      for (j in Iter.range(i + 1, NUM_COGNITIVE_MODULES - 1)) {
        let mi = state.modules[i];
        let mj = state.modules[j];
        
        // Mutual information approximation
        let binding = cf.bindingMatrix[i][j];
        let activationProduct = mi.activation * mj.activation;
        let coherenceProduct = mi.coherence * mj.coherence;
        
        let pairMI = binding * activationProduct * coherenceProduct;
        totalMI += pairMI;
        count += 1;
      };
    };
    
    cf.mutualInformation := totalMI / Float.fromInt(count);
    
    // Find minimum partition
    var minPartitionMI : Float = cf.mutualInformation;
    
    // Check bipartitions (simplified - only checking 8 different splits)
    for (split in Iter.range(1, 8)) {
      var partition1MI : Float = 0.0;
      var partition2MI : Float = 0.0;
      var count1 : Nat = 0;
      var count2 : Nat = 0;
      
      for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
        for (j in Iter.range(i + 1, NUM_COGNITIVE_MODULES - 1)) {
          let inPartition1_i = (i / split) % 2 == 0;
          let inPartition1_j = (j / split) % 2 == 0;
          
          let mi = state.modules[i];
          let mj = state.modules[j];
          let binding = cf.bindingMatrix[i][j];
          let pairMI = binding * mi.activation * mj.activation;
          
          if (inPartition1_i and inPartition1_j) {
            partition1MI += pairMI;
            count1 += 1;
          } else if ((not inPartition1_i) and (not inPartition1_j)) {
            partition2MI += pairMI;
            count2 += 1;
          };
          // Cross-partition pairs don't contribute
        };
      };
      
      let partitionTotalMI = (partition1MI + partition2MI) / Float.fromInt(count1 + count2 + 1);
      
      if (partitionTotalMI < minPartitionMI) {
        minPartitionMI := partitionTotalMI;
      };
    };
    
    // Φ = total MI - minimum partition MI
    let phi = cf.mutualInformation - minPartitionMI;
    
    cf.phi := Float.max(0.0, phi);
    cf.phiHistory.add(cf.phi);
    
    // Check global binding
    cf.globalBound := cf.phi > PHI_CONSCIOUSNESS_THRESHOLD;
    
    cf.phi
  };
  
  /// Update binding matrix based on co-activation
  public func updateBindingMatrix(state : SentienceState) : () {
    let cf = state.consciousness;
    
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      for (j in Iter.range(i + 1, NUM_COGNITIVE_MODULES - 1)) {
        let mi = state.modules[i];
        let mj = state.modules[j];
        
        // Hebbian-like binding update
        // Co-activation strengthens binding
        let coActivation = mi.activation * mj.activation;
        
        // Current binding
        var currentBinding = cf.bindingMatrix[i][j];
        
        // Update: Δbinding = α × (coActivation - binding)
        let delta = BINDING_STRENGTH * (coActivation - currentBinding);
        currentBinding += delta;
        
        // Ensure minimum binding
        currentBinding := Float.max(0.1, Float.min(1.0, currentBinding));
        
        // Symmetric update
        cf.bindingMatrix[i][j] := currentBinding;
        cf.bindingMatrix[j][i] := currentBinding;
      };
    };
  };
  
  /// Bind multiple contents into unified experience
  public func bindContents(state : SentienceState, contentIds : [Nat64]) : () {
    let cf = state.consciousness;
    cf.boundContents := contentIds;
    
    // Increase binding between modules producing these contents
    for (contentId in contentIds.vals()) {
      for (content in state.workspace.contents.vals()) {
        if (content.contentId == contentId) {
          let sourceModule = content.sourceModule;
          
          // Strengthen binding from this module to all others
          for (j in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
            if (j != sourceModule) {
              cf.bindingMatrix[sourceModule][j] := Float.min(1.0, cf.bindingMatrix[sourceModule][j] + 0.1);
              cf.bindingMatrix[j][sourceModule] := Float.min(1.0, cf.bindingMatrix[j][sourceModule] + 0.1);
            };
          };
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: PROCESSING MODE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Determine appropriate processing mode
  public func determineProcessingMode(state : SentienceState) : ProcessingMode {
    let ws = state.workspace;
    let self = state.selfModel;
    
    // Check for threats (defensive mode)
    var threatLevel : Float = 0.0;
    for (emotion in self.currentEmotions.vals()) {
      switch (emotion.emotion) {
        case (#Fear) { threatLevel += emotion.intensity };
        case (#Anger) { threatLevel += emotion.intensity * 0.5 };
        case (_) {};
      };
    };
    if (threatLevel > 0.6) {
      return #Defensive;
    };
    
    // Check for social content (social mode)
    for (content in ws.contents.vals()) {
      switch (content.contentType) {
        case (#SelfState) {};
        case (_) {
          switch (content.data) {
            case (#Text(t)) {
              if (Text.contains(t, #text("social")) or Text.contains(t, #text("communicate"))) {
                return #Social;
              };
            };
            case (_) {};
          };
        };
      };
    };
    
    // Check for creative content
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      let module = state.modules[i];
      switch (module.category) {
        case (#Creative) {
          if (module.activation > 0.7) {
            return #Creative;
          };
        };
        case (_) {};
      };
    };
    
    // Check for meta-cognitive activity (reflective mode)
    if (self.hotLevel2.aware and self.hotLevel3.aware) {
      return #Reflective;
    };
    
    // Check attention breadth
    if (state.attention.breadth < 0.3 and state.attention.intensity > 0.7) {
      return #Focused;
    };
    
    if (state.attention.breadth > 0.7) {
      return #Diffuse;
    };
    
    // Check cognitive load for rest mode
    if (state.cognitiveLoad < 0.2 and ws.broadcastActive == false) {
      return #Rest;
    };
    
    // Default to automatic if low engagement
    if (ws.ignitionStrength < 0.3) {
      return #Automatic;
    };
    
    #Focused
  };
  
  /// Compute cognitive load
  public func computeCognitiveLoad(state : SentienceState) : Float {
    var load : Float = 0.0;
    
    // Workspace occupancy
    load += Float.fromInt(state.workspace.contents.size()) / Float.fromInt(WORKSPACE_CAPACITY) * 0.3;
    
    // Active modules
    var activeModules : Nat = 0;
    for (i in Iter.range(0, NUM_COGNITIVE_MODULES - 1)) {
      if (state.modules[i].activation > 0.5) {
        activeModules += 1;
      };
    };
    load += Float.fromInt(activeModules) / Float.fromInt(NUM_COGNITIVE_MODULES) * 0.3;
    
    // Attention intensity
    load += state.attention.intensity * 0.2;
    
    // Active goals
    load += Float.fromInt(state.selfModel.currentGoals.size()) / 10.0 * 0.2;
    
    state.cognitiveLoad := Float.min(1.0, load);
    state.cognitiveLoad
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main sentience layer heartbeat update
  public func heartbeatUpdate(state : SentienceState, beat : Int) : SentienceHeartbeatResult {
    state.currentBeat := beat;
    state.totalProcessingCycles += 1;
    
    // 1. Update bottom-up salience
    updateBottomUpSalience(state);
    
    // 2. Compute attention selection
    let attendedModule = computeAttentionSelection(state);
    
    // 3. Update workspace contents
    updateWorkspaceContents(state);
    
    // 4. Check and execute global broadcast
    globalBroadcast(state, beat);
    
    // 5. Update binding matrix
    updateBindingMatrix(state);
    
    // 6. Compute Φ
    let phi = computePhi(state);
    
    // 7. Update self-model (every SELF_AWARENESS_REFRESH beats)
    if (beat % SELF_AWARENESS_REFRESH == 0) {
      updateSelfModel(state, beat);
    };
    
    // 8. Determine processing mode
    state.processingMode := determineProcessingMode(state);
    
    // 9. Compute cognitive load
    let load = computeCognitiveLoad(state);
    
    // 10. Compute overall awareness
    state.overallAwareness := computeOverallAwareness(state);
    
    // 11. Compute experience quality
    state.experienceQuality := computeExperienceQuality(state);
    
    // Return result
    {
      beat = beat;
      attendedModule = attendedModule;
      broadcastActive = state.workspace.broadcastActive;
      phi = phi;
      overallAwareness = state.overallAwareness;
      experienceQuality = state.experienceQuality;
      cognitiveLoad = load;
      processingMode = state.processingMode;
      hotLevel1Active = state.selfModel.hotLevel1.aware;
      hotLevel2Active = state.selfModel.hotLevel2.aware;
      hotLevel3Active = state.selfModel.hotLevel3.aware;
      narrativeCoherence = state.selfModel.narrativeCoherence;
      identityContinuity = state.selfModel.continuityScore;
    }
  };
  
  /// Sentience heartbeat result
  public type SentienceHeartbeatResult = {
    beat : Int;
    attendedModule : ?Nat;
    broadcastActive : Bool;
    phi : Float;
    overallAwareness : Float;
    experienceQuality : Float;
    cognitiveLoad : Float;
    processingMode : ProcessingMode;
    hotLevel1Active : Bool;
    hotLevel2Active : Bool;
    hotLevel3Active : Bool;
    narrativeCoherence : Float;
    identityContinuity : Float;
  };
  
  /// Compute overall awareness level
  func computeOverallAwareness(state : SentienceState) : Float {
    var awareness : Float = 0.0;
    
    // Φ contributes
    awareness += state.consciousness.phi * 0.3;
    
    // Workspace broadcast contributes
    if (state.workspace.broadcastActive) {
      awareness += 0.2;
    };
    
    // HOT levels contribute
    if (state.selfModel.hotLevel1.aware) { awareness += 0.15 };
    if (state.selfModel.hotLevel2.aware) { awareness += 0.15 };
    if (state.selfModel.hotLevel3.aware) { awareness += 0.1 };
    
    // Attention focus contributes
    awareness += state.attention.intensity * 0.1;
    
    Float.max(S_ZERO_FLOOR, Float.min(1.0, awareness))
  };
  
  /// Compute experience quality
  func computeExperienceQuality(state : SentienceState) : Float {
    var quality : Float = 0.0;
    
    // Coherence
    quality += state.workspace.workspaceCoherence * 0.25;
    
    // Narrative coherence
    quality += state.selfModel.narrativeCoherence * 0.2;
    
    // Identity continuity
    quality += state.selfModel.continuityScore * 0.2;
    
    // Emotional balance (moderate arousal, positive valence)
    let emotionalQuality = computeEmotionalQuality(state);
    quality += emotionalQuality * 0.2;
    
    // Cognitive load (moderate is optimal)
    let loadQuality = 1.0 - Float.abs(state.cognitiveLoad - 0.5) * 2.0;
    quality += loadQuality * 0.15;
    
    Float.max(S_ZERO_FLOOR, Float.min(1.0, quality))
  };
  
  /// Compute emotional quality
  func computeEmotionalQuality(state : SentienceState) : Float {
    if (state.selfModel.currentEmotions.size() == 0) {
      return 0.5;  // Neutral
    };
    
    var totalValence : Float = 0.0;
    var totalArousal : Float = 0.0;
    var count : Float = 0.0;
    
    for (emotion in state.selfModel.currentEmotions.vals()) {
      totalValence += emotion.valence * emotion.intensity;
      totalArousal += emotion.arousal * emotion.intensity;
      count += emotion.intensity;
    };
    
    if (count == 0.0) {
      return 0.5;
    };
    
    let avgValence = totalValence / count;
    let avgArousal = totalArousal / count;
    
    // Quality: positive valence + moderate arousal
    let valenceQuality = (avgValence + 1.0) / 2.0;  // Map -1..1 to 0..1
    let arousalQuality = 1.0 - Float.abs(avgArousal - 0.5) * 2.0;  // Optimal at 0.5
    
    valenceQuality * 0.6 + arousalQuality * 0.4
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get current Φ (integrated information)
  public func getPhi(state : SentienceState) : Float {
    state.consciousness.phi
  };
  
  /// Check if conscious (Φ above threshold)
  public func isConscious(state : SentienceState) : Bool {
    state.consciousness.phi > PHI_CONSCIOUSNESS_THRESHOLD
  };
  
  /// Get overall awareness
  public func getOverallAwareness(state : SentienceState) : Float {
    state.overallAwareness
  };
  
  /// Get current processing mode
  public func getProcessingMode(state : SentienceState) : ProcessingMode {
    state.processingMode
  };
  
  /// Get cognitive load
  public func getCognitiveLoad(state : SentienceState) : Float {
    state.cognitiveLoad
  };
  
  /// Get current narrative
  public func getCurrentNarrative(state : SentienceState) : Text {
    state.selfModel.currentNarrative
  };
  
  /// Get identity continuity
  public func getIdentityContinuity(state : SentienceState) : Float {
    state.selfModel.continuityScore
  };
  
  /// Get HOT level status
  public func getHOTLevelStatus(state : SentienceState) : (Bool, Bool, Bool) {
    (
      state.selfModel.hotLevel1.aware,
      state.selfModel.hotLevel2.aware,
      state.selfModel.hotLevel3.aware
    )
  };
  
  /// Get workspace contents count
  public func getWorkspaceSize(state : SentienceState) : Nat {
    state.workspace.contents.size()
  };
  
  /// Check if global broadcast active
  public func isBroadcastActive(state : SentienceState) : Bool {
    state.workspace.broadcastActive
  };
  
  /// Get attended module
  public func getAttendedModule(state : SentienceState) : ?Nat {
    state.attention.target
  };
  
  /// Get experience quality
  public func getExperienceQuality(state : SentienceState) : Float {
    state.experienceQuality
  };

}
