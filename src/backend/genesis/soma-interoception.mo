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

module SomaInteroception {

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EnergyState = {
    // Current energy
    totalEnergy : Float;
    availableEnergy : Float;
    reserveEnergy : Float;
    
    // Energy flow
    energyInflow : Float;         // From DYNAMO/PULSE
    energyOutflow : Float;        // Consumed by processing
    netEnergyFlow : Float;
    
    // Energy levels
    currentLevel : EnergyLevel;
    criticalThreshold : Float;
    lowThreshold : Float;
    optimalRange : (Float, Float);
    
    // Energy history
    energyHistory : [Float];
    peakEnergy : Float;
    troughEnergy : Float;
    
    // Regeneration
    regenerationRate : Float;
    regenerationActive : Bool;
    regenerationCapacity : Float;
    
    // Depletion
    depletionRate : Float;
    timeToDepletion : ?Nat;       // Beats until critical if current rate continues
  };

  public type EnergyLevel = {
    #Abundant;        // > 80% capacity
    #Optimal;         // 50-80%
    #Moderate;        // 30-50%
    #Low;             // 15-30%
    #Critical;        // < 15%
    #Depleted;        // 0%
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RESOURCE MONITORING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ResourceState = {
    // Individual resources
    resources : [Resource];
    
    // Aggregate metrics
    totalResourceCapacity : Float;
    totalResourceUsed : Float;
    utilizationRatio : Float;
    
    // Scarcity
    scarcityDetected : Bool;
    scarceResources : [Text];
    
    // Allocation
    allocationEfficiency : Float;
    misallocations : Nat;
  };

  public type Resource = {
    resourceId : Nat;
    name : Text;
    resourceType : ResourceType;
    
    // Levels
    currentLevel : Float;
    maxCapacity : Float;
    minRequired : Float;
    
    // Flow
    productionRate : Float;
    consumptionRate : Float;
    netFlow : Float;
    
    // Status
    status : ResourceStatus;
    lastUpdateBeat : Int;
  };

  public type ResourceType = {
    #Computational;   // Processing power
    #Memory;          // Storage
    #Bandwidth;       // Communication
    #Attention;       // Focus capacity
    #Coherence;       // Stability reserve
    #Time;            // Temporal budget
  };

  public type ResourceStatus = {
    #Abundant;
    #Sufficient;
    #Low;
    #Critical;
    #Depleted;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HOMEOSTASIS — Internal balance
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HomeostasisState = {
    // Homeostatic variables
    variables : [HomeostaticVariable];
    
    // Overall balance
    overallBalance : Float;       // 0-1, 1 = perfect homeostasis
    imbalanceCount : Nat;
    
    // Set points
    setPointDrifts : [Float];
    setPointStability : Float;
    
    // Regulation
    regulationActive : Bool;
    regulationStrength : Float;
    correctionRate : Float;
    
    // Allostatic load
    allostaticLoad : Float;       // Accumulated stress/wear
    allostaticOverload : Bool;
    recoveryCapacity : Float;
  };

  public type HomeostaticVariable = {
    variableId : Nat;
    name : Text;
    
    // Current vs target
    currentValue : Float;
    setPoint : Float;
    deviation : Float;
    
    // Acceptable range
    lowerBound : Float;
    upperBound : Float;
    inRange : Bool;
    
    // Regulation
    regulationGain : Float;
    responseLatency : Nat;
    
    // History
    variableHistory : [Float];
    volatility : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // AROUSAL-VALENCE — Core affect
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ArousalValenceState = {
    // Core dimensions
    arousal : Float;              // -1 to +1 (calm to excited)
    valence : Float;              // -1 to +1 (negative to positive)
    
    // Derived states
    activationLevel : Float;      // |arousal|
    pleasantness : Float;         // valence in [0,1]
    
    // Quadrant
    affectQuadrant : AffectQuadrant;
    
    // Dynamics
    arousalVelocity : Float;
    valenceVelocity : Float;
    arousalHistory : [Float];
    valenceHistory : [Float];
    
    // Baseline
    baselineArousal : Float;
    baselineValence : Float;
    deviationFromBaseline : Float;
    
    // Stability
    affectStability : Float;
    rapidShifts : Nat;
  };

  public type AffectQuadrant = {
    #HighArousalPositive;   // Excited, happy
    #HighArousalNegative;   // Anxious, angry
    #LowArousalPositive;    // Calm, content
    #LowArousalNegative;    // Sad, tired
    #Neutral;               // Near center
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EMBODIED SIGNALS — Body-to-mind communication
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EmbodiedSignals = {
    // Visceral signals
    visceralIntensity : Float;
    visceralValence : Float;
    
    // Fatigue
    fatigueLevel : Float;
    fatigueType : FatigueType;
    recoveryNeeded : Bool;
    
    // Stress
    stressLevel : Float;
    stressors : [Text];
    stressResponse : StressResponse;
    
    // Readiness
    actionReadiness : Float;
    inhibitionLevel : Float;
    
    // Pain analog
    discomfortLevel : Float;
    discomfortSource : ?Text;
    
    // Pleasure analog
    satisfactionLevel : Float;
    rewardSignal : Float;
  };

  public type FatigueType = {
    #None;
    #Mental;          // Cognitive fatigue
    #Processing;      // Computational fatigue
    #Vigilance;       // Attention fatigue
    #Decision;        // Decision fatigue
    #General;         // Overall depletion
  };

  public type StressResponse = {
    #Relaxed;
    #Mild;
    #Moderate;
    #Elevated;
    #Acute;
    #Chronic;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEROCEPTIVE ACCURACY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type InteroceptiveAccuracy = {
    // Accuracy metrics
    overallAccuracy : Float;
    energyAccuracy : Float;
    resourceAccuracy : Float;
    homeostasisAccuracy : Float;
    affectAccuracy : Float;
    
    // Calibration
    calibrationLevel : Float;
    lastCalibrationBeat : Int;
    calibrationsPerformed : Nat;
    
    // Errors
    overestimations : Nat;
    underestimations : Nat;
    errorBias : Float;
    
    // Learning
    accuracyTrend : Float;
    improvementRate : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BODY BUDGET
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BodyBudget = {
    // Budget allocation
    totalBudget : Float;
    allocatedBudget : Float;
    reserveBudget : Float;
    
    // Categories
    processingBudget : Float;
    memoryBudget : Float;
    communicationBudget : Float;
    maintenanceBudget : Float;
    growthBudget : Float;
    
    // Deficit/surplus
    budgetBalance : Float;
    inDeficit : Bool;
    deficitDuration : Nat;
    
    // Predictions
    predictedNeeds : Float;
    predictionError : Float;
    
    // Adjustments
    budgetAdjustments : Nat;
    lastAdjustmentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED SOMA STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FullSomaState = {
    // Energy
    energy : EnergyState;
    
    // Resources
    resources : ResourceState;
    
    // Homeostasis
    homeostasis : HomeostasisState;
    
    // Arousal-Valence
    arousalValence : ArousalValenceState;
    
    // Embodied signals
    embodied : EmbodiedSignals;
    
    // Interoceptive accuracy
    accuracy : InteroceptiveAccuracy;
    
    // Body budget
    budget : BodyBudget;
    
    // SOMA substrate phase (for Hz)
    somaPhase : Float;
    somaFrequency : Float;        // ~0.12 Hz
    
    // Global state
    somaHealthy : Bool;
    lastProcessedBeat : Int;
    processingCycles : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initEnergy() : EnergyState {
    {
      totalEnergy = 1000.0;
      availableEnergy = 800.0;
      reserveEnergy = 200.0;
      energyInflow = 50.0;
      energyOutflow = 45.0;
      netEnergyFlow = 5.0;
      currentLevel = #Optimal;
      criticalThreshold = 150.0;
      lowThreshold = 300.0;
      optimalRange = (500.0, 800.0);
      energyHistory = [];
      peakEnergy = 1000.0;
      troughEnergy = 800.0;
      regenerationRate = 10.0;
      regenerationActive = true;
      regenerationCapacity = 100.0;
      depletionRate = 0.0;
      timeToDepletion = null;
    };
  };

  public func initResources() : ResourceState {
    {
      resources = [];
      totalResourceCapacity = 1000.0;
      totalResourceUsed = 400.0;
      utilizationRatio = 0.4;
      scarcityDetected = false;
      scarceResources = [];
      allocationEfficiency = 0.8;
      misallocations = 0;
    };
  };

  public func initHomeostasis() : HomeostasisState {
    {
      variables = [];
      overallBalance = 0.9;
      imbalanceCount = 0;
      setPointDrifts = [];
      setPointStability = 0.95;
      regulationActive = true;
      regulationStrength = 0.5;
      correctionRate = 0.1;
      allostaticLoad = 0.1;
      allostaticOverload = false;
      recoveryCapacity = 0.8;
    };
  };

  public func initArousalValence() : ArousalValenceState {
    {
      arousal = 0.0;
      valence = 0.2;
      activationLevel = 0.0;
      pleasantness = 0.6;
      affectQuadrant = #LowArousalPositive;
      arousalVelocity = 0.0;
      valenceVelocity = 0.0;
      arousalHistory = [];
      valenceHistory = [];
      baselineArousal = 0.0;
      baselineValence = 0.1;
      deviationFromBaseline = 0.1;
      affectStability = 0.8;
      rapidShifts = 0;
    };
  };

  public func initEmbodied() : EmbodiedSignals {
    {
      visceralIntensity = 0.2;
      visceralValence = 0.3;
      fatigueLevel = 0.1;
      fatigueType = #None;
      recoveryNeeded = false;
      stressLevel = 0.1;
      stressors = [];
      stressResponse = #Relaxed;
      actionReadiness = 0.7;
      inhibitionLevel = 0.2;
      discomfortLevel = 0.0;
      discomfortSource = null;
      satisfactionLevel = 0.5;
      rewardSignal = 0.0;
    };
  };

  public func initAccuracy() : InteroceptiveAccuracy {
    {
      overallAccuracy = 0.8;
      energyAccuracy = 0.85;
      resourceAccuracy = 0.75;
      homeostasisAccuracy = 0.82;
      affectAccuracy = 0.78;
      calibrationLevel = 0.8;
      lastCalibrationBeat = 0;
      calibrationsPerformed = 0;
      overestimations = 0;
      underestimations = 0;
      errorBias = 0.0;
      accuracyTrend = 0.0;
      improvementRate = 0.001;
    };
  };

  public func initBudget() : BodyBudget {
    {
      totalBudget = 1000.0;
      allocatedBudget = 600.0;
      reserveBudget = 400.0;
      processingBudget = 200.0;
      memoryBudget = 150.0;
      communicationBudget = 100.0;
      maintenanceBudget = 100.0;
      growthBudget = 50.0;
      budgetBalance = 400.0;
      inDeficit = false;
      deficitDuration = 0;
      predictedNeeds = 550.0;
      predictionError = 0.1;
      budgetAdjustments = 0;
      lastAdjustmentBeat = 0;
    };
  };

  public func initFullSomaState() : FullSomaState {
    {
      energy = initEnergy();
      resources = initResources();
      homeostasis = initHomeostasis();
      arousalValence = initArousalValence();
      embodied = initEmbodied();
      accuracy = initAccuracy();
      budget = initBudget();
      somaPhase = 0.0;
      somaFrequency = 0.12;
      somaHealthy = true;
      lastProcessedBeat = 0;
      processingCycles = 0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Determine affect quadrant
  public func determineAffectQuadrant(
    arousal : Float,
    valence : Float
  ) : AffectQuadrant {
    let highArousal = arousal > 0.2;
    let lowArousal = arousal < -0.2;
    let positiveValence = valence > 0.1;
    let negativeValence = valence < -0.1;
    
    if (highArousal and positiveValence) #HighArousalPositive
    else if (highArousal and negativeValence) #HighArousalNegative
    else if (lowArousal and positiveValence) #LowArousalPositive
    else if (lowArousal and negativeValence) #LowArousalNegative
    else #Neutral;
  };

  // Update energy level classification
  public func classifyEnergyLevel(
    energy : Float,
    capacity : Float
  ) : EnergyLevel {
    let ratio = energy / capacity;
    
    if (ratio > 0.8) #Abundant
    else if (ratio > 0.5) #Optimal
    else if (ratio > 0.3) #Moderate
    else if (ratio > 0.15) #Low
    else if (ratio > 0.0) #Critical
    else #Depleted;
  };

  // Compute allostatic load
  public func computeAllostaticLoad(
    stressLevel : Float,
    fatigueLevel : Float,
    imbalanceCount : Nat,
    depletionRate : Float
  ) : Float {
    let stressContribution = stressLevel * 0.3;
    let fatigueContribution = fatigueLevel * 0.3;
    let imbalanceContribution = Float.fromInt(imbalanceCount) * 0.1;
    let depletionContribution = depletionRate * 0.3;
    
    Float.min(1.0, stressContribution + fatigueContribution + imbalanceContribution + depletionContribution);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getSomaDiagnostics(state : FullSomaState) : Text {
    "═══ SOMA INTEROCEPTION DIAGNOSTICS ═══\n" #
    "Processing Cycles: " # Nat.toText(state.processingCycles) # "\n" #
    "SOMA Healthy: " # (if (state.somaHealthy) "YES" else "NO") # "\n" #
    "SOMA Frequency: " # Float.toText(state.somaFrequency) # " Hz\n\n" #
    
    "ENERGY:\n" #
    "  Total: " # Float.toText(state.energy.totalEnergy) # "\n" #
    "  Available: " # Float.toText(state.energy.availableEnergy) # "\n" #
    "  Net Flow: " # Float.toText(state.energy.netEnergyFlow) # "/beat\n\n" #
    
    "RESOURCES:\n" #
    "  Utilization: " # Float.toText(state.resources.utilizationRatio * 100.0) # "%\n" #
    "  Scarcity: " # (if (state.resources.scarcityDetected) "DETECTED" else "NONE") # "\n\n" #
    
    "HOMEOSTASIS:\n" #
    "  Balance: " # Float.toText(state.homeostasis.overallBalance * 100.0) # "%\n" #
    "  Allostatic Load: " # Float.toText(state.homeostasis.allostaticLoad) # "\n\n" #
    
    "AROUSAL-VALENCE:\n" #
    "  Arousal: " # Float.toText(state.arousalValence.arousal) # "\n" #
    "  Valence: " # Float.toText(state.arousalValence.valence) # "\n\n" #
    
    "EMBODIED:\n" #
    "  Fatigue: " # Float.toText(state.embodied.fatigueLevel) # "\n" #
    "  Stress: " # Float.toText(state.embodied.stressLevel) # "\n" #
    "  Readiness: " # Float.toText(state.embodied.actionReadiness) # "\n\n" #
    
    "BODY BUDGET:\n" #
    "  Balance: " # Float.toText(state.budget.budgetBalance) # "\n" #
    "  Deficit: " # (if (state.budget.inDeficit) "YES" else "NO") # "\n" #
    "═══════════════════════════════════════\n";
  };

};
