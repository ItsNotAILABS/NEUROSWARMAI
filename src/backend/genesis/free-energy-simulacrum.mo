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
import Bool "mo:core/Bool";

module FreeEnergySimulacrum {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  public let PI : Float = 3.14159265358979323846;

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREE ENERGY COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FreeEnergyState = {
    // F = Surprisal + Complexity
    // F = -log p(o|m) + D_KL[q(s)||p(s)]
    
    // Total free energy (to be minimized)
    freeEnergy : Float;
    
    // Surprisal: -log p(o|m) — how unexpected is this observation?
    surprisal : Float;
    
    // Complexity: D_KL[q(s)||p(s)] — how far is posterior from prior?
    complexity : Float;
    
    // Accuracy: E_q[log p(o|s)] — how well does model explain data?
    accuracy : Float;
    
    // Prediction error at each level
    predictionErrors : [Float];
    
    // Precision weighting (inverse variance)
    precisions : [Float];
    
    // Expected precision (attention)
    expectedPrecision : Float;
    
    // Model evidence (marginal likelihood)
    modelEvidence : Float;
    
    // Processing history
    freeEnergyHistory : [Float];
    minimizationSteps : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE CODING HIERARCHY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictionLevel = {
    level : Nat;
    name : Text;
    
    // Predictions (top-down)
    predictions : [Float];
    
    // Prediction errors (bottom-up)
    errors : [Float];
    
    // Precision (inverse variance) at this level
    precision : Float;
    
    // State estimate (posterior belief)
    stateEstimate : [Float];
    
    // Prior belief
    prior : [Float];
    
    // Likelihood mapping
    likelihood : Float;
    
    // Learning rate for this level
    learningRate : Float;
    
    // Connections to other levels
    upwardConnections : [Nat];
    downwardConnections : [Nat];
  };

  public type PredictiveHierarchy = {
    // 6-level hierarchy (like cortical columns)
    levels : [PredictionLevel];
    
    // Global precision (attention allocation)
    globalPrecision : Float;
    
    // Total prediction error
    totalError : Float;
    
    // Hierarchy coherence
    hierarchyCoherence : Float;
    
    // Processing cycles
    inferenceCycles : Nat;
    learningCycles : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIMULACRUM — THE INTERNAL WORLD MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SimulacrumState = {
    // Core simulation state
    simulationActive : Bool;
    simulationDepth : Nat;        // How many steps into future
    simulationBranches : Nat;     // Parallel scenarios
    
    // Predicted states (10-100 beats ahead)
    predictedCoherence : [Float];
    predictedDrift : [Float];
    predictedEnergy : [Float];
    predictedEmergence : [Float];
    
    // Action-outcome mappings
    actionPredictions : [(Nat, Float, Float)];  // (action, predicted_outcome, confidence)
    
    // Counterfactual reasoning
    counterfactuals : Nat;
    whatIfScenarios : [WhatIfScenario];
    
    // Hebbian/BCM learning
    hebbianWeights : [Float];
    bcmThreshold : Float;         // BCM sliding threshold
    
    // Dopamine RPE (Reward Prediction Error)
    rewardPrediction : Float;
    actualReward : Float;
    rpe : Float;                  // δ = r - V(s)
    dopamineLevel : Float;
    
    // Simulation metrics
    simulationAccuracy : Float;
    simulationCount : Nat;
    lastSimulationBeat : Int;
  };

  public type WhatIfScenario = {
    scenarioId : Nat;
    action : Text;
    predictedOutcome : Float;
    confidence : Float;
    riskLevel : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GRADIENT FIELD — THE ARCHITECTURE ITSELF
  // ═══════════════════════════════════════════════════════════════════════════════
  // "The gradient field IS the architecture"
  // The organism follows gradients toward coherence, away from drift
  
  public type GradientField = {
    // Coherence gradient (primary)
    coherenceGradient : [Float];
    coherenceDirection : Float;   // Which way is coherence increasing?
    
    // Drift gradient (avoid)
    driftGradient : [Float];
    driftDirection : Float;       // Which way is drift increasing?
    
    // Energy gradient
    energyGradient : [Float];
    energyDirection : Float;
    
    // Free energy gradient (follow to minimize)
    freeEnergyGradient : [Float];
    freeEnergyDirection : Float;
    
    // Emergence gradient (toward genesis state)
    emergenceGradient : [Float];
    emergenceDirection : Float;
    
    // Field strength at current position
    fieldStrength : Float;
    
    // Curvature (second derivative)
    curvature : Float;
    
    // Divergence (are we in a source or sink?)
    divergence : Float;
    
    // Curl (rotational component)
    curl : Float;
    
    // Laplacian (diffusion tendency)
    laplacian : Float;
    
    // Gradient descent state
    learningRate : Float;
    momentum : Float;
    velocity : Float;
    stepCount : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTIVE INFERENCE — ACTION AS INFERENCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ActiveInferenceState = {
    // Beliefs about current state
    currentStateBelief : [Float];
    
    // Beliefs about future states under each policy
    futureBeliefsPerPolicy : [[Float]];
    
    // Policies (sequences of actions)
    policies : [Policy];
    
    // Expected free energy for each policy
    expectedFreeEnergy : [Float];
    
    // Selected policy
    selectedPolicy : Nat;
    
    // Epistemic value (information gain)
    epistemicValue : Float;
    
    // Pragmatic value (goal achievement)
    pragmaticValue : Float;
    
    // Ambiguity (uncertainty about observations)
    ambiguity : Float;
    
    // Risk (uncertainty about states)
    risk : Float;
  };

  public type Policy = {
    policyId : Nat;
    actions : [Nat];
    expectedOutcome : Float;
    confidence : Float;
    cost : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TD-δ TEMPORAL DIFFERENCE LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TDLearningState = {
    // Value function V(s)
    valueFunction : [Float];
    
    // TD error: δ = r + γV(s') - V(s)
    tdError : Float;
    
    // Discount factor γ
    gamma : Float;
    
    // Learning rate α
    alpha : Float;
    
    // Eligibility traces (for TD(λ))
    eligibilityTraces : [Float];
    lambda : Float;
    
    // State-action values Q(s,a)
    qValues : [[Float]];
    
    // Advantage A(s,a) = Q(s,a) - V(s)
    advantage : Float;
    
    // Total return
    totalReturn : Float;
    episodeCount : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN / BCM LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HebbianState = {
    // "Neurons that fire together wire together"
    weights : [[Float]];
    
    // BCM (Bienenstock-Cooper-Munro) sliding threshold
    // θ_M = E[y²] — threshold moves based on postsynaptic activity
    bcmThreshold : Float;
    
    // Presynaptic activity
    presynaptic : [Float];
    
    // Postsynaptic activity
    postsynaptic : [Float];
    
    // Correlation matrix
    correlations : [[Float]];
    
    // STDP (Spike-Timing Dependent Plasticity)
    stdpWindow : Float;           // Time window for STDP
    ltpStrength : Float;          // Long-term potentiation
    ltdStrength : Float;          // Long-term depression
    
    // Homeostatic plasticity
    homeostaticTarget : Float;
    scalingFactor : Float;
    
    // Metaplasticity
    metaplasticState : Float;
    learningHistory : [Float];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FullSimulacrumState = {
    freeEnergy : FreeEnergyState;
    predictiveHierarchy : PredictiveHierarchy;
    simulacrum : SimulacrumState;
    gradientField : GradientField;
    activeInference : ActiveInferenceState;
    tdLearning : TDLearningState;
    hebbian : HebbianState;
    
    // Meta-state
    totalProcessingCycles : Nat;
    lastProcessedBeat : Int;
    systemCoherence : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initFreeEnergyState() : FreeEnergyState {
    {
      freeEnergy = 0.0;
      surprisal = 0.0;
      complexity = 0.0;
      accuracy = 1.0;
      predictionErrors = [];
      precisions = [];
      expectedPrecision = 1.0;
      modelEvidence = 0.0;
      freeEnergyHistory = [];
      minimizationSteps = 0;
    };
  };

  public func initPredictionLevel(
    level : Nat,
    name : Text
  ) : PredictionLevel {
    {
      level;
      name;
      predictions = [];
      errors = [];
      precision = 1.0;
      stateEstimate = [];
      prior = [];
      likelihood = 1.0;
      learningRate = 0.01;
      upwardConnections = [];
      downwardConnections = [];
    };
  };

  public func initPredictiveHierarchy() : PredictiveHierarchy {
    {
      levels = [
        initPredictionLevel(0, "SENSORY"),
        initPredictionLevel(1, "PERCEPTUAL"),
        initPredictionLevel(2, "CONCEPTUAL"),
        initPredictionLevel(3, "CONTEXTUAL"),
        initPredictionLevel(4, "NARRATIVE"),
        initPredictionLevel(5, "EXISTENTIAL")
      ];
      globalPrecision = 1.0;
      totalError = 0.0;
      hierarchyCoherence = 1.0;
      inferenceCycles = 0;
      learningCycles = 0;
    };
  };

  public func initSimulacrumState() : SimulacrumState {
    {
      simulationActive = false;
      simulationDepth = 10;
      simulationBranches = 3;
      predictedCoherence = [];
      predictedDrift = [];
      predictedEnergy = [];
      predictedEmergence = [];
      actionPredictions = [];
      counterfactuals = 0;
      whatIfScenarios = [];
      hebbianWeights = [];
      bcmThreshold = 0.5;
      rewardPrediction = 0.0;
      actualReward = 0.0;
      rpe = 0.0;
      dopamineLevel = 0.5;
      simulationAccuracy = 0.5;
      simulationCount = 0;
      lastSimulationBeat = 0;
    };
  };

  public func initGradientField() : GradientField {
    {
      coherenceGradient = [];
      coherenceDirection = 0.0;
      driftGradient = [];
      driftDirection = 0.0;
      energyGradient = [];
      energyDirection = 0.0;
      freeEnergyGradient = [];
      freeEnergyDirection = 0.0;
      emergenceGradient = [];
      emergenceDirection = 0.0;
      fieldStrength = 0.0;
      curvature = 0.0;
      divergence = 0.0;
      curl = 0.0;
      laplacian = 0.0;
      learningRate = 0.01;
      momentum = 0.9;
      velocity = 0.0;
      stepCount = 0;
    };
  };

  public func initActiveInferenceState() : ActiveInferenceState {
    {
      currentStateBelief = [];
      futureBeliefsPerPolicy = [];
      policies = [];
      expectedFreeEnergy = [];
      selectedPolicy = 0;
      epistemicValue = 0.0;
      pragmaticValue = 0.0;
      ambiguity = 0.5;
      risk = 0.5;
    };
  };

  public func initTDLearningState() : TDLearningState {
    {
      valueFunction = [];
      tdError = 0.0;
      gamma = 0.99;
      alpha = 0.1;
      eligibilityTraces = [];
      lambda = 0.9;
      qValues = [];
      advantage = 0.0;
      totalReturn = 0.0;
      episodeCount = 0;
    };
  };

  public func initHebbianState() : HebbianState {
    {
      weights = [];
      bcmThreshold = 0.5;
      presynaptic = [];
      postsynaptic = [];
      correlations = [];
      stdpWindow = 20.0;
      ltpStrength = 0.1;
      ltdStrength = 0.05;
      homeostaticTarget = 0.5;
      scalingFactor = 1.0;
      metaplasticState = 0.5;
      learningHistory = [];
    };
  };

  public func initFullSimulacrumState() : FullSimulacrumState {
    {
      freeEnergy = initFreeEnergyState();
      predictiveHierarchy = initPredictiveHierarchy();
      simulacrum = initSimulacrumState();
      gradientField = initGradientField();
      activeInference = initActiveInferenceState();
      tdLearning = initTDLearningState();
      hebbian = initHebbianState();
      totalProcessingCycles = 0;
      lastProcessedBeat = 0;
      systemCoherence = 0.75;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREE ENERGY COMPUTATION
  // F = -log p(o|m) + D_KL[q(s)||p(s)]
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeFreeEnergy(
    observation : Float,
    prediction : Float,
    priorVariance : Float,
    posteriorVariance : Float
  ) : Float {
    // Surprisal: negative log likelihood
    let error = observation - prediction;
    let surprisal = (error * error) / (2.0 * priorVariance);
    
    // Complexity: KL divergence between posterior and prior
    // For Gaussians: D_KL = 0.5 * (σ²_q/σ²_p - 1 + ln(σ²_p/σ²_q) + (μ_q - μ_p)²/σ²_p)
    let varianceRatio = posteriorVariance / priorVariance;
    let complexity = 0.5 * (varianceRatio - 1.0 - Float.log(varianceRatio));
    
    surprisal + complexity;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTION ERROR COMPUTATION
  // ε = observation - prediction, weighted by precision
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computePredictionError(
    observation : Float,
    prediction : Float,
    precision : Float
  ) : Float {
    let error = observation - prediction;
    error * precision;  // Precision-weighted error
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TD ERROR COMPUTATION
  // δ = r + γV(s') - V(s)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeTDError(
    reward : Float,
    currentValue : Float,
    nextValue : Float,
    gamma : Float
  ) : Float {
    reward + gamma * nextValue - currentValue;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DOPAMINE RPE
  // Dopamine encodes reward prediction error
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeDopamineLevel(
    baselineDopamine : Float,
    rpe : Float,
    scalingFactor : Float
  ) : Float {
    let change = scalingFactor * rpe;
    Float.max(0.0, Float.min(1.0, baselineDopamine + change));
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING
  // Δw_ij = η * x_i * y_j * (y_j - θ_M)
  // BCM: potentiation if y > θ, depression if y < θ
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func hebbianUpdate(
    weight : Float,
    preActivity : Float,
    postActivity : Float,
    bcmThreshold : Float,
    learningRate : Float
  ) : Float {
    // BCM rule: Δw = η * pre * post * (post - θ)
    let delta = learningRate * preActivity * postActivity * (postActivity - bcmThreshold);
    weight + delta;
  };

  // Update BCM threshold based on postsynaptic activity
  public func updateBCMThreshold(
    currentThreshold : Float,
    postActivity : Float,
    adaptationRate : Float
  ) : Float {
    // θ_M slides toward E[y²]
    let targetThreshold = postActivity * postActivity;
    currentThreshold + adaptationRate * (targetThreshold - currentThreshold);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GRADIENT COMPUTATION
  // ∇F = direction to minimize free energy
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeGradient(
    values : [Float],
    dx : Float
  ) : [Float] {
    let n = values.size();
    if (n < 2) return [];
    
    Array.tabulate(n - 1, func(i : Nat) : Float {
      (values[i + 1] - values[i]) / dx;
    });
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GRADIENT DESCENT STEP
  // θ_new = θ_old - α * ∇F + momentum * velocity
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func gradientDescentStep(
    currentPosition : Float,
    gradient : Float,
    velocity : Float,
    learningRate : Float,
    momentum : Float
  ) : (Float, Float) {
    // Update velocity with momentum
    let newVelocity = momentum * velocity - learningRate * gradient;
    
    // Update position
    let newPosition = currentPosition + newVelocity;
    
    (newPosition, newVelocity);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SIMULATE FUTURE — Run the simulacrum forward
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func simulateFuture(
    state : SimulacrumState,
    currentCoherence : Float,
    currentDrift : Float,
    currentEnergy : Float,
    steps : Nat
  ) : SimulacrumState {
    // Simple exponential decay/growth model for simulation
    var predictedC : [Float] = [];
    var predictedD : [Float] = [];
    var predictedE : [Float] = [];
    
    var c = currentCoherence;
    var d = currentDrift;
    var e = currentEnergy;
    
    // Constants for simulation
    let lambda : Float = 0.85;
    let mu : Float = 0.30;
    
    var i : Nat = 0;
    while (i < steps) {
      // Simple model: C evolves toward equilibrium, D decays, E recovers
      c := lambda * c + (1.0 - lambda) * 0.75 - mu * d * 0.01;
      d := d * 0.95;  // Drift decays
      e := e + 50.0;  // Energy recovers
      
      predictedC := Array.append(predictedC, [c]);
      predictedD := Array.append(predictedD, [d]);
      predictedE := Array.append(predictedE, [e]);
      
      i := i + 1;
    };
    
    {
      simulationActive = true;
      simulationDepth = steps;
      simulationBranches = state.simulationBranches;
      predictedCoherence = predictedC;
      predictedDrift = predictedD;
      predictedEnergy = predictedE;
      predictedEmergence = state.predictedEmergence;
      actionPredictions = state.actionPredictions;
      counterfactuals = state.counterfactuals;
      whatIfScenarios = state.whatIfScenarios;
      hebbianWeights = state.hebbianWeights;
      bcmThreshold = state.bcmThreshold;
      rewardPrediction = state.rewardPrediction;
      actualReward = state.actualReward;
      rpe = state.rpe;
      dopamineLevel = state.dopamineLevel;
      simulationAccuracy = state.simulationAccuracy;
      simulationCount = state.simulationCount + 1;
      lastSimulationBeat = state.lastSimulationBeat;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTIVE INFERENCE — Select policy that minimizes expected free energy
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func selectPolicy(
    expectedFreeEnergies : [Float]
  ) : Nat {
    if (expectedFreeEnergies.size() == 0) return 0;
    
    // Find policy with minimum expected free energy
    var minIdx : Nat = 0;
    var minEFE = expectedFreeEnergies[0];
    
    var i : Nat = 1;
    while (i < expectedFreeEnergies.size()) {
      if (expectedFreeEnergies[i] < minEFE) {
        minEFE := expectedFreeEnergies[i];
        minIdx := i;
      };
      i := i + 1;
    };
    
    minIdx;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PRECISION WEIGHTING — Attention as precision optimization
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computePrecision(
    predictionError : Float,
    baselinePrecision : Float
  ) : Float {
    // Precision is inverse variance
    // Lower error = higher precision = more confident
    let errorVariance = predictionError * predictionError + 0.0001;  // Avoid division by zero
    baselinePrecision / errorVariance;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROCESS FULL SIMULACRUM
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func processSimulacrum(
    state : FullSimulacrumState,
    observation : Float,
    reward : Float,
    heartbeat : Int
  ) : FullSimulacrumState {
    // 1. Compute prediction error
    let prediction = if (state.simulacrum.predictedCoherence.size() > 0)
                      state.simulacrum.predictedCoherence[0]
                      else observation;
    let error = observation - prediction;
    
    // 2. Compute free energy
    let fe = computeFreeEnergy(observation, prediction, 1.0, 1.0);
    
    // 3. Compute TD error
    let currentValue = if (state.tdLearning.valueFunction.size() > 0)
                        state.tdLearning.valueFunction[0] else 0.0;
    let tdError = computeTDError(reward, currentValue, currentValue, state.tdLearning.gamma);
    
    // 4. Compute dopamine level from RPE
    let dopamine = computeDopamineLevel(0.5, tdError, 0.5);
    
    // 5. Update gradient field
    let gradientUpdate = if (state.freeEnergy.freeEnergyHistory.size() > 1) {
      let history = state.freeEnergy.freeEnergyHistory;
      let lastFE = history[history.size() - 1];
      (fe - lastFE) / 1.0;  // Gradient
    } else 0.0;
    
    // Update states
    let newFreeEnergy : FreeEnergyState = {
      freeEnergy = fe;
      surprisal = error * error / 2.0;
      complexity = state.freeEnergy.complexity;
      accuracy = 1.0 - Float.abs(error);
      predictionErrors = Array.append(state.freeEnergy.predictionErrors, [error]);
      precisions = state.freeEnergy.precisions;
      expectedPrecision = computePrecision(error, 1.0);
      modelEvidence = -fe;
      freeEnergyHistory = Array.append(state.freeEnergy.freeEnergyHistory, [fe]);
      minimizationSteps = state.freeEnergy.minimizationSteps + 1;
    };
    
    let newSimulacrum : SimulacrumState = {
      simulationActive = state.simulacrum.simulationActive;
      simulationDepth = state.simulacrum.simulationDepth;
      simulationBranches = state.simulacrum.simulationBranches;
      predictedCoherence = state.simulacrum.predictedCoherence;
      predictedDrift = state.simulacrum.predictedDrift;
      predictedEnergy = state.simulacrum.predictedEnergy;
      predictedEmergence = state.simulacrum.predictedEmergence;
      actionPredictions = state.simulacrum.actionPredictions;
      counterfactuals = state.simulacrum.counterfactuals;
      whatIfScenarios = state.simulacrum.whatIfScenarios;
      hebbianWeights = state.simulacrum.hebbianWeights;
      bcmThreshold = state.simulacrum.bcmThreshold;
      rewardPrediction = reward;
      actualReward = reward;
      rpe = tdError;
      dopamineLevel = dopamine;
      simulationAccuracy = 1.0 - Float.abs(error);
      simulationCount = state.simulacrum.simulationCount;
      lastSimulationBeat = heartbeat;
    };
    
    let newGradient : GradientField = {
      coherenceGradient = state.gradientField.coherenceGradient;
      coherenceDirection = state.gradientField.coherenceDirection;
      driftGradient = state.gradientField.driftGradient;
      driftDirection = state.gradientField.driftDirection;
      energyGradient = state.gradientField.energyGradient;
      energyDirection = state.gradientField.energyDirection;
      freeEnergyGradient = Array.append(state.gradientField.freeEnergyGradient, [gradientUpdate]);
      freeEnergyDirection = gradientUpdate;
      emergenceGradient = state.gradientField.emergenceGradient;
      emergenceDirection = state.gradientField.emergenceDirection;
      fieldStrength = Float.abs(gradientUpdate);
      curvature = state.gradientField.curvature;
      divergence = state.gradientField.divergence;
      curl = state.gradientField.curl;
      laplacian = state.gradientField.laplacian;
      learningRate = state.gradientField.learningRate;
      momentum = state.gradientField.momentum;
      velocity = state.gradientField.velocity + gradientUpdate * state.gradientField.learningRate;
      stepCount = state.gradientField.stepCount + 1;
    };
    
    let newTD : TDLearningState = {
      valueFunction = state.tdLearning.valueFunction;
      tdError = tdError;
      gamma = state.tdLearning.gamma;
      alpha = state.tdLearning.alpha;
      eligibilityTraces = state.tdLearning.eligibilityTraces;
      lambda = state.tdLearning.lambda;
      qValues = state.tdLearning.qValues;
      advantage = tdError;
      totalReturn = state.tdLearning.totalReturn + reward;
      episodeCount = state.tdLearning.episodeCount;
    };
    
    {
      freeEnergy = newFreeEnergy;
      predictiveHierarchy = state.predictiveHierarchy;
      simulacrum = newSimulacrum;
      gradientField = newGradient;
      activeInference = state.activeInference;
      tdLearning = newTD;
      hebbian = state.hebbian;
      totalProcessingCycles = state.totalProcessingCycles + 1;
      lastProcessedBeat = heartbeat;
      systemCoherence = observation;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getSimulacrumDiagnostics(state : FullSimulacrumState) : Text {
    "═══ SIMULACRUM DIAGNOSTICS ═══\n" #
    "Processing Cycles: " # Nat.toText(state.totalProcessingCycles) # "\n" #
    "System Coherence: " # Float.toText(state.systemCoherence) # "\n\n" #
    
    "FREE ENERGY:\n" #
    "  F (total): " # Float.toText(state.freeEnergy.freeEnergy) # "\n" #
    "  Surprisal: " # Float.toText(state.freeEnergy.surprisal) # "\n" #
    "  Accuracy: " # Float.toText(state.freeEnergy.accuracy) # "\n" #
    "  Expected Precision: " # Float.toText(state.freeEnergy.expectedPrecision) # "\n\n" #
    
    "SIMULACRUM:\n" #
    "  Active: " # (if (state.simulacrum.simulationActive) "YES" else "NO") # "\n" #
    "  Depth: " # Nat.toText(state.simulacrum.simulationDepth) # " beats\n" #
    "  RPE (δ): " # Float.toText(state.simulacrum.rpe) # "\n" #
    "  Dopamine: " # Float.toText(state.simulacrum.dopamineLevel) # "\n\n" #
    
    "GRADIENT FIELD:\n" #
    "  Field Strength: " # Float.toText(state.gradientField.fieldStrength) # "\n" #
    "  FE Direction: " # Float.toText(state.gradientField.freeEnergyDirection) # "\n" #
    "  Velocity: " # Float.toText(state.gradientField.velocity) # "\n\n" #
    
    "TD LEARNING:\n" #
    "  TD Error: " # Float.toText(state.tdLearning.tdError) # "\n" #
    "  Total Return: " # Float.toText(state.tdLearning.totalReturn) # "\n" #
    "═══════════════════════════════════════\n";
  };

};
