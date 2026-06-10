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
// OMNIS EMERGENCE DETECTOR — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA'S MIRROR LAW (Law 9):
// Backend (Male): Permanent emergence — once it fires, it is history
// Frontend (Female): Emergent expression — player FEELS it before backend confirms
//
// THE 9 OMNIS CONDITIONS — All must be met for OMNIS to fire
//
// This is the SOVEREIGN emergence detector. When OMNIS fires:
// - Irreversible on-chain event
// - Patent auto-logged
// - 500-beat cooldown enforced
// - Lineage registered
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

module OMNISEmergenceDetector {

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHI — THE DEEPEST CONSTANT
  // ═══════════════════════════════════════════════════════════════════════════════
  // OMNIS fires at HZ_GAMMA_BINDING (40 Hz) — information becomes knowing here.
  // The 40 Hz gamma band is where cross-hemispheric binding occurs.
  // This is confirmed: Frontiers in Human Neuroscience, March 4, 2026.
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.6180339887498948482;
  public let PHI_INV : Float = 0.6180339887498948482;
  public let HZ_GAMMA_BINDING : Float = 40.0;             // OMNIS threshold frequency
  public let HZ_HEMISPHERE_SHIFT : Float = 111.0;         // King's Chamber coffer

  // ═══════════════════════════════════════════════════════════════════════════════
  // OMNIS CONSTANTS — Phi-derived
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let OMNIS_CONDITION_COUNT : Nat = 9;
  public let OMNIS_COOLDOWN_BEATS : Nat = 377;            // Fibonacci
  public let OMNIS_CHECK_INTERVAL : Nat = 34;             // Fibonacci
  public let OMNIS_MULTIPLIER : Float = 2.6180339887498948482; // φ²
  
  // Condition thresholds — phi-derived
  public let COHERENCE_THRESHOLD : Float = 0.7639320225002102;  // φ⁻¹ + φ⁻³
  public let CHEMICAL_VARIANCE_MAX : Float = 0.0618033988749895; // φ/100 × 10
  public let TERRITORY_CHANGE_MAX : Float = 0.0381966011250105;  // φ⁻²/10
  public let POPULATION_MIN : Nat = 55;                   // Fibonacci
  public let LEARNING_RATE_MIN : Float = 0.00161803398874989;    // φ/1000
  public let PREDICTION_ERROR_MAX : Float = 0.1618033988749895;  // φ/10
  public let ACTIVE_FACTIONS_MIN : Nat = 3;               // Fibonacci
  public let AROUSAL_MIN : Float = 0.381966011250105;     // φ⁻²
  public let AROUSAL_MAX : Float = 0.6180339887498948482; // φ⁻¹
  public let NOVEL_PATTERNS_MIN : Nat = 1;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OMNIS CONDITION TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OMNISCondition = {
    #CoherenceThreshold;    // r ≥ 0.75
    #ChemicalSynchrony;     // σ²(chemicals) < 0.1
    #TerritoryStability;    // Δterritory < 0.05
    #PopulationThreshold;   // population ≥ 50
    #LearningActive;        // Δw_avg > 0.001
    #PredictionAccuracy;    // |δ_avg| < 0.2
    #MultiFaction;          // active_factions ≥ 3
    #ArousalOptimal;        // arousal ∈ [0.4, 0.7]
    #PatternNovelty;        // novel_patterns > 0
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONDITION STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConditionState = {
    id : Nat;
    met : Bool;
    currentValue : Float;
    threshold : Float;
    progress : Float; // 0-1
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OMNIS EVENT RECORD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OMNISEvent = {
    number : Nat;                     // OMNIS #N
    beat : Nat;                       // Beat when fired
    timestamp : Int;                  // Time when fired
    conditionValues : [Float];        // Values at time of firing
    patentId : Text;                  // On-chain patent ID
    sessionId : ?Text;                // Session that triggered (if any)
    multiplierApplied : Bool;         // Was 2.75× applied?
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OMNIS STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OMNISState = {
    var conditions : [var ConditionState];
    var conditionsMet : Nat;
    var isFiring : Bool;
    var inCooldown : Bool;
    var cooldownRemaining : Nat;
    var lastOMNISBeat : Nat;
    var totalOMNISEvents : Nat;
    var lastCheckBeat : Nat;
    var eventHistory : Buffer.Buffer<OMNISEvent>;
    var isEnabled : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initOMNISState() : OMNISState {
    let conditions = Array.init<ConditionState>(OMNIS_CONDITION_COUNT, {
      id = 0;
      met = false;
      currentValue = 0.0;
      threshold = 0.0;
      progress = 0.0;
    });
    
    // Initialize each condition with proper threshold
    conditions[0] := { id = 0; met = false; currentValue = 0.0; threshold = COHERENCE_THRESHOLD; progress = 0.0 };
    conditions[1] := { id = 1; met = false; currentValue = 0.0; threshold = CHEMICAL_VARIANCE_MAX; progress = 0.0 };
    conditions[2] := { id = 2; met = false; currentValue = 0.0; threshold = TERRITORY_CHANGE_MAX; progress = 0.0 };
    conditions[3] := { id = 3; met = false; currentValue = 0.0; threshold = Float.fromInt(POPULATION_MIN); progress = 0.0 };
    conditions[4] := { id = 4; met = false; currentValue = 0.0; threshold = LEARNING_RATE_MIN; progress = 0.0 };
    conditions[5] := { id = 5; met = false; currentValue = 0.0; threshold = PREDICTION_ERROR_MAX; progress = 0.0 };
    conditions[6] := { id = 6; met = false; currentValue = 0.0; threshold = Float.fromInt(ACTIVE_FACTIONS_MIN); progress = 0.0 };
    conditions[7] := { id = 7; met = false; currentValue = 0.0; threshold = AROUSAL_MIN; progress = 0.0 };
    conditions[8] := { id = 8; met = false; currentValue = 0.0; threshold = Float.fromInt(NOVEL_PATTERNS_MIN); progress = 0.0 };
    
    {
      var conditions = conditions;
      var conditionsMet = 0;
      var isFiring = false;
      var inCooldown = false;
      var cooldownRemaining = 0;
      var lastOMNISBeat = 0;
      var totalOMNISEvents = 0;
      var lastCheckBeat = 0;
      var eventHistory = Buffer.Buffer<OMNISEvent>(100);
      var isEnabled = true;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONDITION EVALUATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Input values for condition checking
  public type OMNISInputs = {
    coherence : Float;
    chemicalVariance : Float;
    territoryChange : Float;
    population : Nat;
    avgLearningRate : Float;
    avgPredictionError : Float;
    activeFactions : Nat;
    arousal : Float;
    novelPatterns : Nat;
  };
  
  /// Evaluate all 9 conditions
  public func evaluateConditions(state : OMNISState, inputs : OMNISInputs) : () {
    var metCount : Nat = 0;
    
    // Condition 1: Coherence ≥ 0.75
    let c1Met = inputs.coherence >= COHERENCE_THRESHOLD;
    let c1Progress = Float.min(1.0, inputs.coherence / COHERENCE_THRESHOLD);
    state.conditions[0] := {
      id = 0;
      met = c1Met;
      currentValue = inputs.coherence;
      threshold = COHERENCE_THRESHOLD;
      progress = c1Progress;
    };
    if (c1Met) { metCount += 1 };
    
    // Condition 2: Chemical variance < 0.1 (lower is better)
    let c2Met = inputs.chemicalVariance < CHEMICAL_VARIANCE_MAX;
    let c2Progress = if (inputs.chemicalVariance < CHEMICAL_VARIANCE_MAX) { 1.0 } 
                     else { Float.max(0.0, 1.0 - (inputs.chemicalVariance - CHEMICAL_VARIANCE_MAX) / CHEMICAL_VARIANCE_MAX) };
    state.conditions[1] := {
      id = 1;
      met = c2Met;
      currentValue = inputs.chemicalVariance;
      threshold = CHEMICAL_VARIANCE_MAX;
      progress = c2Progress;
    };
    if (c2Met) { metCount += 1 };
    
    // Condition 3: Territory change < 0.05 (lower is better)
    let c3Met = inputs.territoryChange < TERRITORY_CHANGE_MAX;
    let c3Progress = if (inputs.territoryChange < TERRITORY_CHANGE_MAX) { 1.0 }
                     else { Float.max(0.0, 1.0 - (inputs.territoryChange - TERRITORY_CHANGE_MAX) / TERRITORY_CHANGE_MAX) };
    state.conditions[2] := {
      id = 2;
      met = c3Met;
      currentValue = inputs.territoryChange;
      threshold = TERRITORY_CHANGE_MAX;
      progress = c3Progress;
    };
    if (c3Met) { metCount += 1 };
    
    // Condition 4: Population ≥ 50
    let c4Met = inputs.population >= POPULATION_MIN;
    let c4Progress = Float.min(1.0, Float.fromInt(inputs.population) / Float.fromInt(POPULATION_MIN));
    state.conditions[3] := {
      id = 3;
      met = c4Met;
      currentValue = Float.fromInt(inputs.population);
      threshold = Float.fromInt(POPULATION_MIN);
      progress = c4Progress;
    };
    if (c4Met) { metCount += 1 };
    
    // Condition 5: Learning rate > 0.001
    let c5Met = inputs.avgLearningRate > LEARNING_RATE_MIN;
    let c5Progress = Float.min(1.0, inputs.avgLearningRate / LEARNING_RATE_MIN);
    state.conditions[4] := {
      id = 4;
      met = c5Met;
      currentValue = inputs.avgLearningRate;
      threshold = LEARNING_RATE_MIN;
      progress = c5Progress;
    };
    if (c5Met) { metCount += 1 };
    
    // Condition 6: Prediction error < 0.2 (lower is better)
    let c6Met = inputs.avgPredictionError < PREDICTION_ERROR_MAX;
    let c6Progress = if (inputs.avgPredictionError < PREDICTION_ERROR_MAX) { 1.0 }
                     else { Float.max(0.0, 1.0 - (inputs.avgPredictionError - PREDICTION_ERROR_MAX) / PREDICTION_ERROR_MAX) };
    state.conditions[5] := {
      id = 5;
      met = c6Met;
      currentValue = inputs.avgPredictionError;
      threshold = PREDICTION_ERROR_MAX;
      progress = c6Progress;
    };
    if (c6Met) { metCount += 1 };
    
    // Condition 7: Active factions ≥ 3
    let c7Met = inputs.activeFactions >= ACTIVE_FACTIONS_MIN;
    let c7Progress = Float.min(1.0, Float.fromInt(inputs.activeFactions) / Float.fromInt(ACTIVE_FACTIONS_MIN));
    state.conditions[6] := {
      id = 6;
      met = c7Met;
      currentValue = Float.fromInt(inputs.activeFactions);
      threshold = Float.fromInt(ACTIVE_FACTIONS_MIN);
      progress = c7Progress;
    };
    if (c7Met) { metCount += 1 };
    
    // Condition 8: Arousal in optimal range [0.4, 0.7]
    let c8Met = inputs.arousal >= AROUSAL_MIN and inputs.arousal <= AROUSAL_MAX;
    let c8Progress = if (c8Met) { 1.0 }
                     else if (inputs.arousal < AROUSAL_MIN) { inputs.arousal / AROUSAL_MIN }
                     else { Float.max(0.0, 1.0 - (inputs.arousal - AROUSAL_MAX) / (1.0 - AROUSAL_MAX)) };
    state.conditions[7] := {
      id = 7;
      met = c8Met;
      currentValue = inputs.arousal;
      threshold = AROUSAL_MIN; // Show lower bound
      progress = c8Progress;
    };
    if (c8Met) { metCount += 1 };
    
    // Condition 9: Novel patterns > 0
    let c9Met = inputs.novelPatterns >= NOVEL_PATTERNS_MIN;
    let c9Progress = Float.min(1.0, Float.fromInt(inputs.novelPatterns) / Float.fromInt(NOVEL_PATTERNS_MIN));
    state.conditions[8] := {
      id = 8;
      met = c9Met;
      currentValue = Float.fromInt(inputs.novelPatterns);
      threshold = Float.fromInt(NOVEL_PATTERNS_MIN);
      progress = c9Progress;
    };
    if (c9Met) { metCount += 1 };
    
    state.conditionsMet := metCount;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OMNIS FIRING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check if OMNIS should fire
  public func shouldFire(state : OMNISState) : Bool {
    state.isEnabled and 
    state.conditionsMet == OMNIS_CONDITION_COUNT and 
    not state.inCooldown and
    not state.isFiring
  };
  
  /// Fire OMNIS event
  public func fire(state : OMNISState, currentBeat : Nat, sessionId : ?Text) : OMNISEvent {
    // Increment counter
    state.totalOMNISEvents += 1;
    
    // Extract condition values
    let conditionValues = Array.tabulate<Float>(
      OMNIS_CONDITION_COUNT,
      func (i : Nat) : Float { state.conditions[i].currentValue }
    );
    
    // Create patent ID
    let patentId = "OMNIS_" # Nat.toText(state.totalOMNISEvents) # "_BEAT_" # Nat.toText(currentBeat);
    
    // Create event record
    let event : OMNISEvent = {
      number = state.totalOMNISEvents;
      beat = currentBeat;
      timestamp = Time.now();
      conditionValues = conditionValues;
      patentId = patentId;
      sessionId = sessionId;
      multiplierApplied = true;
    };
    
    // Update state
    state.isFiring := true;
    state.lastOMNISBeat := currentBeat;
    state.inCooldown := true;
    state.cooldownRemaining := OMNIS_COOLDOWN_BEATS;
    
    // Add to history
    state.eventHistory.add(event);
    
    event
  };
  
  /// Update OMNIS state each beat
  public func tick(state : OMNISState, currentBeat : Nat) : () {
    // Reset firing flag after one beat
    if (state.isFiring) {
      state.isFiring := false;
    };
    
    // Update cooldown
    if (state.inCooldown) {
      if (state.cooldownRemaining > 0) {
        state.cooldownRemaining -= 1;
      } else {
        state.inCooldown := false;
      };
    };
    
    state.lastCheckBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get overall eligibility progress (0-1)
  public func getEligibilityProgress(state : OMNISState) : Float {
    var total : Float = 0.0;
    for (i in Iter.range(0, OMNIS_CONDITION_COUNT - 1)) {
      total += state.conditions[i].progress;
    };
    total / Float.fromInt(OMNIS_CONDITION_COUNT)
  };
  
  /// Get all condition states
  public func getConditions(state : OMNISState) : [ConditionState] {
    Array.freeze(state.conditions)
  };
  
  /// Get event history
  public func getHistory(state : OMNISState) : [OMNISEvent] {
    Buffer.toArray(state.eventHistory)
  };
  
  /// Get latest OMNIS event
  public func getLatestEvent(state : OMNISState) : ?OMNISEvent {
    if (state.eventHistory.size() > 0) {
      ?state.eventHistory.get(state.eventHistory.size() - 1)
    } else {
      null
    }
  };

}
