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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DEEP FREE ENERGY ENGINE — COMPLETE ACTIVE INFERENCE IMPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The Free Energy Principle (Friston, 2010):
// Every self-organizing system minimizes variational free energy to maintain its existence.
//
// F = D_KL[q(s) || p(s|o)] = E_q[ln q(s) - ln p(o,s)]
//   = Complexity - Accuracy
//   = D_KL[q(s) || p(s)] - E_q[ln p(o|s)]
//
// Where:
//   q(s) = variational posterior (what the organism believes)
//   p(s|o) = true posterior (what's actually true given observations)
//   p(s) = prior beliefs
//   p(o|s) = likelihood (generative model)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// HIERARCHICAL PREDICTIVE CODING:
// ════════════════════════════════
//
// The brain implements Free Energy minimization through predictive coding:
//
//   Level L+1 (higher, slower, abstract)
//       ↓ predictions μ_(L+1)
//       ↓
//   Level L ──────── prediction error: ε_L = o_L - g(μ_(L+1))
//       ↓            weighted by precision: π_L × ε_L
//       ↓ predictions μ_L
//   Level L-1 (lower, faster, concrete)
//
// Each level:
// 1. Receives predictions from above
// 2. Computes prediction errors
// 3. Sends errors upward (weighted by precision)
// 4. Updates beliefs to minimize errors
//
// Dynamics:
//   dμ_L/dt = D·μ_L - π_ε × ε_L + π_μ × ε_(L+1)
//   where D is the generalized derivative operator
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ACTIVE INFERENCE:
// ═════════════════
//
// Organisms don't just perceive — they ACT to fulfill their predictions.
// Action selection minimizes Expected Free Energy:
//
//   G(π) = E_q(o,s|π)[ln q(s|π) - ln p(o,s)]
//        = Risk + Ambiguity - Information_Gain
//
// Where:
//   Risk = D_KL[q(o|π) || p(o)] — divergence from preferred outcomes
//   Ambiguity = E_q(s|π)[H[p(o|s)]] — uncertainty about outcomes
//   Info_Gain = -E_q(o|π)[D_KL[q(s|o,π) || q(s|π)]] — epistemic value
//
// Policy selection (softmax over G):
//   π(a) = σ(-γ × G(a)) = exp(-γ × G(a)) / Σ_a' exp(-γ × G(a'))
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// INTERTWINING WITH OTHER SYSTEMS:
// ════════════════════════════════
//
// 1. KURAMOTO → FREE ENERGY:
//    - Kuramoto order parameter r(t) is a direct observation
//    - Coherence feeds into the accuracy term
//    - Phase patterns encode temporal predictions
//
// 2. FREE ENERGY → KURAMOTO:
//    - Precision weighting modulates Kuramoto coupling
//    - Prediction errors can desynchronize (surprise)
//    - Expected coherence sets coupling strength
//
// 3. HEBBIAN → FREE ENERGY:
//    - Hebbian weights encode the generative model p(o|s)
//    - Weight matrix IS the organism's model of reality
//    - Learned associations are prior beliefs
//
// 4. FREE ENERGY → HEBBIAN:
//    - Prediction errors drive weight updates
//    - Precision modulates learning rate
//    - Active inference selects training patterns
//
// 5. Q-LEARNING → FREE ENERGY:
//    - Q-values encode expected value (pragmatic term)
//    - TD errors are prediction errors for value
//    - Policy = active inference policy
//
// 6. FREE ENERGY → Q-LEARNING:
//    - Expected Free Energy = Q-value generalization
//    - Epistemic value drives exploration
//    - Precision = confidence in Q-estimates
//
// 7. MEMORY → FREE ENERGY:
//    - Memory provides prior distributions
//    - Recalled patterns constrain predictions
//    - Salience = prediction error magnitude
//
// 8. FREE ENERGY → MEMORY:
//    - Surprising events get encoded (high F)
//    - Consolidation minimizes F over memories
//    - Active inference guides memory retrieval
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module DeepFreeEnergyEngine {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846264338327950288419716939937510;
  public let E : Float = 2.71828182845904523536028747135266249775724709369996;
  public let LN_2 : Float = 0.69314718055994530941723212145817656807550013436026;
  public let LN_2PI : Float = 1.83787706640934548356065947281;  // ln(2π)
  
  // Organism constants
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  public let NUM_NODES : Nat = 12;
  public let NUM_HIERARCHY_LEVELS : Nat = 4;
  public let NUM_ACTIONS : Nat = 12;
  public let NUM_OUTCOMES : Nat = 12;
  
  // Free Energy parameters
  public let DEFAULT_PRECISION : Float = 1.0;        // Default inverse variance
  public let PRECISION_MIN : Float = 0.1;            // Minimum precision
  public let PRECISION_MAX : Float = 100.0;          // Maximum precision
  public let LEARNING_RATE_MU : Float = 0.1;         // Belief update rate
  public let LEARNING_RATE_PI : Float = 0.01;        // Precision update rate
  public let ACTION_PRECISION : Float = 4.0;         // γ in policy softmax
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: GENERALIZED COORDINATES OF MOTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Friston's formulation uses generalized coordinates: x̃ = [x, x', x'', x''', ...]
  // This captures not just the current state but its trajectory through time.
  //
  // The generalized state is embedded in a local polynomial expansion:
  //   x(t + τ) ≈ x(t) + τ·x'(t) + (τ²/2)·x''(t) + ...
  //
  // This allows the model to predict future states and detect trajectory deviations.
  //
  
  public type GeneralizedCoordinate = {
    var position : Float;        // x — current value
    var velocity : Float;        // x' — first derivative
    var acceleration : Float;    // x'' — second derivative
    var jerk : Float;            // x''' — third derivative
  };
  
  public type GeneralizedState = {
    var coordinates : [var GeneralizedCoordinate];
    var embeddingOrder : Nat;    // How many derivatives to track
    var localTime : Float;       // Time within embedding window
  };
  
  // Initialize generalized coordinate
  public func initGeneralizedCoordinate(x0 : Float) : GeneralizedCoordinate {
    {
      var position = x0;
      var velocity = 0.0;
      var acceleration = 0.0;
      var jerk = 0.0;
    }
  };
  
  // Initialize generalized state for N nodes
  public func initGeneralizedState(n : Nat, initialValues : [Float]) : GeneralizedState {
    let coords = Array.init<GeneralizedCoordinate>(n, func(i : Nat) : GeneralizedCoordinate {
      let x0 = if (i < Array.size(initialValues)) { initialValues[i] } else { S_ZERO_FLOOR };
      initGeneralizedCoordinate(x0)
    });
    {
      var coordinates = coords;
      var embeddingOrder = 4;  // Track up to jerk
      var localTime = 0.0;
    }
  };
  
  // Update generalized coordinates given new observation
  public func updateGeneralizedCoordinates(
    state : GeneralizedState,
    newObservations : [Float],
    dt : Float
  ) {
    let n = Array.size(state.coordinates);
    
    for (i in Iter.range(0, n - 1)) {
      let coord = state.coordinates[i];
      let obs = if (i < Array.size(newObservations)) { newObservations[i] } else { coord.position };
      
      // Estimate derivatives from observation change
      let newVel = (obs - coord.position) / dt;
      let newAcc = (newVel - coord.velocity) / dt;
      let newJerk = (newAcc - coord.acceleration) / dt;
      
      // Smooth updates
      coord.jerk := 0.9 * coord.jerk + 0.1 * newJerk;
      coord.acceleration := 0.9 * coord.acceleration + 0.1 * newAcc;
      coord.velocity := 0.9 * coord.velocity + 0.1 * newVel;
      coord.position := obs;
    };
    
    state.localTime += dt;
  };
  
  // Predict future state using generalized coordinates
  public func predictFromGeneralized(coord : GeneralizedCoordinate, tau : Float) : Float {
    // Taylor expansion: x(t + τ) ≈ x + τ·x' + (τ²/2)·x'' + (τ³/6)·x'''
    coord.position + 
    tau * coord.velocity + 
    (tau * tau / 2.0) * coord.acceleration + 
    (tau * tau * tau / 6.0) * coord.jerk
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: GAUSSIAN BELIEFS — VARIATIONAL DISTRIBUTION q(s)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // We approximate the posterior with a Gaussian (mean-field approximation):
  //   q(s) = N(s; μ, Σ) where Σ = Π⁻¹ (precision = inverse covariance)
  //
  // For computational tractability, we often use diagonal covariance:
  //   q(s) = Π_i N(s_i; μ_i, π_i⁻¹)
  //
  
  public type GaussianBelief = {
    var mean : Float;            // μ — expected value
    var precision : Float;       // π = 1/σ² — inverse variance
    var variance : Float;        // σ² = 1/π — for convenience
    var logPartition : Float;    // Z = (2π/π)^(1/2)
  };
  
  public type BeliefState = {
    var beliefs : [var GaussianBelief];
    var jointPrecision : [[var Float]];  // Full precision matrix (if needed)
    var useDiagonal : Bool;              // Use diagonal approximation?
    var totalUncertainty : Float;        // Sum of variances
    var entropy : Float;                 // H[q] = 0.5 × ln(2πe/π)
  };
  
  // Initialize Gaussian belief
  public func initGaussianBelief(mean : Float, precision : Float) : GaussianBelief {
    let prec = clamp(precision, PRECISION_MIN, PRECISION_MAX);
    {
      var mean = mean;
      var precision = prec;
      var variance = 1.0 / prec;
      var logPartition = 0.5 * ln(2.0 * PI / prec);
    }
  };
  
  // Initialize belief state
  public func initBeliefState(n : Nat, initialMeans : [Float]) : BeliefState {
    let beliefs = Array.init<GaussianBelief>(n, func(i : Nat) : GaussianBelief {
      let mu = if (i < Array.size(initialMeans)) { initialMeans[i] } else { S_ZERO_FLOOR };
      initGaussianBelief(mu, DEFAULT_PRECISION)
    });
    
    let jointPrec = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) { DEFAULT_PRECISION } else { 0.0 }
      })
    });
    
    {
      var beliefs = beliefs;
      var jointPrecision = jointPrec;
      var useDiagonal = true;
      var totalUncertainty = Float.fromInt(n) / DEFAULT_PRECISION;
      var entropy = Float.fromInt(n) * 0.5 * (1.0 + LN_2PI - ln(DEFAULT_PRECISION));
    }
  };
  
  // Update belief given prediction error and precision
  public func updateBelief(
    belief : GaussianBelief,
    predictionError : Float,
    errorPrecision : Float,
    learningRate : Float
  ) {
    // Gradient descent on Free Energy: dμ/dt ∝ π_ε × ε
    let gradient = errorPrecision * predictionError;
    belief.mean := belief.mean + learningRate * gradient;
    
    // Update precision based on squared error
    let expectedError = predictionError * predictionError;
    let newVariance = 0.9 * belief.variance + 0.1 * expectedError;
    belief.precision := clamp(1.0 / (newVariance + 0.001), PRECISION_MIN, PRECISION_MAX);
    belief.variance := 1.0 / belief.precision;
    belief.logPartition := 0.5 * ln(2.0 * PI * belief.variance);
  };
  
  // Compute entropy of belief state
  public func computeBeliefEntropy(state : BeliefState) : Float {
    // H[q] = 0.5 × Σ_i (1 + ln(2π) - ln(π_i))
    var entropy : Float = 0.0;
    let n = Array.size(state.beliefs);
    for (i in Iter.range(0, n - 1)) {
      let belief = state.beliefs[i];
      entropy += 0.5 * (1.0 + LN_2PI - ln(belief.precision));
    };
    state.entropy := entropy;
    entropy
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: GENERATIVE MODEL — p(o, s) = p(o|s) × p(s)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The generative model encodes the organism's beliefs about how the world works:
  //   p(s) — prior beliefs about hidden states
  //   p(o|s) — likelihood (how states generate observations)
  //
  // We use a linear-Gaussian model:
  //   p(s) = N(s; μ_prior, Π_prior⁻¹)
  //   p(o|s) = N(o; A·s + b, Π_likelihood⁻¹)
  //
  // Where A is the observation matrix (learned via Hebbian!)
  //
  
  public type GenerativeModel = {
    // Prior p(s)
    var priorMean : [var Float];
    var priorPrecision : [var Float];
    
    // Likelihood p(o|s)
    var observationMatrix : [[var Float]];  // A: states → observations
    var observationBias : [var Float];      // b: bias term
    var likelihoodPrecision : [var Float];  // Precision of observation noise
    
    // Transition model p(s'|s) for dynamics
    var transitionMatrix : [[var Float]];   // B: state transition
    var transitionPrecision : Float;
    
    // Model parameters
    var numStates : Nat;
    var numObservations : Nat;
  };
  
  // Initialize generative model
  public func initGenerativeModel(numStates : Nat, numObs : Nat) : GenerativeModel {
    // Initialize observation matrix A (start near identity)
    let obsMatrix = Array.init<[var Float]>(numObs, func(i : Nat) : [var Float] {
      Array.init<Float>(numStates, func(j : Nat) : Float {
        if (i == j) { 0.8 } else { 0.1 / Float.fromInt(numStates) }
      })
    });
    
    // Initialize transition matrix B (start near identity with some diffusion)
    let transMatrix = Array.init<[var Float]>(numStates, func(i : Nat) : [var Float] {
      Array.init<Float>(numStates, func(j : Nat) : Float {
        if (i == j) { 0.9 } else { 0.1 / Float.fromInt(numStates - 1) }
      })
    });
    
    {
      var priorMean = Array.init<Float>(numStates, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var priorPrecision = Array.init<Float>(numStates, func(_ : Nat) : Float { DEFAULT_PRECISION });
      var observationMatrix = obsMatrix;
      var observationBias = Array.init<Float>(numObs, func(_ : Nat) : Float { 0.0 });
      var likelihoodPrecision = Array.init<Float>(numObs, func(_ : Nat) : Float { DEFAULT_PRECISION });
      var transitionMatrix = transMatrix;
      var transitionPrecision = 10.0;
      var numStates = numStates;
      var numObservations = numObs;
    }
  };
  
  // Generate predicted observation: ô = A·s + b
  public func generatePrediction(model : GenerativeModel, states : [Float]) : [Float] {
    let numObs = model.numObservations;
    let numStates = model.numStates;
    
    Array.tabulate<Float>(numObs, func(i : Nat) : Float {
      var prediction : Float = model.observationBias[i];
      for (j in Iter.range(0, numStates - 1)) {
        if (j < Array.size(states)) {
          prediction += model.observationMatrix[i][j] * states[j];
        };
      };
      prediction
    })
  };
  
  // Predict next state: s' = B·s
  public func predictNextState(model : GenerativeModel, states : [Float]) : [Float] {
    let numStates = model.numStates;
    
    Array.tabulate<Float>(numStates, func(i : Nat) : Float {
      var nextState : Float = 0.0;
      for (j in Iter.range(0, numStates - 1)) {
        if (j < Array.size(states)) {
          nextState += model.transitionMatrix[i][j] * states[j];
        };
      };
      nextState
    })
  };
  
  // Update generative model from prediction errors (like Hebbian learning!)
  // INTERTWINING: This is where Hebbian and Free Energy meet!
  public func updateGenerativeModel(
    model : GenerativeModel,
    observations : [Float],
    stateEstimates : [Float],
    predictionErrors : [Float],
    learningRate : Float
  ) {
    let numObs = model.numObservations;
    let numStates = model.numStates;
    
    // Update observation matrix A: ΔA ∝ ε × s^T (outer product)
    // This IS Hebbian learning: correlation between error and state
    for (i in Iter.range(0, numObs - 1)) {
      let error = if (i < Array.size(predictionErrors)) { predictionErrors[i] } else { 0.0 };
      for (j in Iter.range(0, numStates - 1)) {
        let state = if (j < Array.size(stateEstimates)) { stateEstimates[j] } else { 0.0 };
        // ΔA_ij = η × ε_i × s_j
        model.observationMatrix[i][j] := model.observationMatrix[i][j] + 
          learningRate * error * state;
      };
    };
    
    // Update bias: Δb ∝ ε
    for (i in Iter.range(0, numObs - 1)) {
      let error = if (i < Array.size(predictionErrors)) { predictionErrors[i] } else { 0.0 };
      model.observationBias[i] := model.observationBias[i] + learningRate * 0.1 * error;
    };
    
    // Update likelihood precision based on prediction error variance
    for (i in Iter.range(0, numObs - 1)) {
      let error = if (i < Array.size(predictionErrors)) { predictionErrors[i] } else { 0.0 };
      let errorSq = error * error;
      let newVar = 0.99 / model.likelihoodPrecision[i] + 0.01 * errorSq;
      model.likelihoodPrecision[i] := clamp(1.0 / (newVar + 0.001), PRECISION_MIN, PRECISION_MAX);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: FREE ENERGY COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // F = D_KL[q(s) || p(s)] - E_q[ln p(o|s)]
  //   = Complexity - Accuracy
  //
  // For Gaussians:
  //   D_KL[q || p] = 0.5 × (tr(Σ_p⁻¹Σ_q) + (μ_p - μ_q)^T Σ_p⁻¹ (μ_p - μ_q) - n + ln(|Σ_p|/|Σ_q|))
  //
  //   -E_q[ln p(o|s)] = 0.5 × (ln|2πΣ_likelihood| + (o - ô)^T Σ_likelihood⁻¹ (o - ô))
  //                   = 0.5 × Σ_i (ln(2π/π_i) + π_i × ε_i²)
  //
  
  public type FreeEnergyComponents = {
    var complexity : Float;      // D_KL[q || p]
    var accuracy : Float;        // E_q[ln p(o|s)]
    var freeEnergy : Float;      // F = complexity - accuracy
    var surprisal : Float;       // -ln p(o) ≈ prediction error magnitude
    var predictionErrors : [var Float];
    var precisionWeightedErrors : [var Float];
  };
  
  // Compute variational Free Energy
  public func computeFreeEnergy(
    beliefs : BeliefState,
    model : GenerativeModel,
    observations : [Float]
  ) : FreeEnergyComponents {
    let n = Array.size(beliefs.beliefs);
    let numObs = model.numObservations;
    
    // Get belief means for prediction
    let stateMeans = Array.tabulate<Float>(n, func(i : Nat) : Float {
      beliefs.beliefs[i].mean
    });
    
    // Generate predictions
    let predictions = generatePrediction(model, stateMeans);
    
    // Compute prediction errors
    let predErrors = Array.init<Float>(numObs, func(i : Nat) : Float {
      let obs = if (i < Array.size(observations)) { observations[i] } else { 0.0 };
      let pred = if (i < Array.size(predictions)) { predictions[i] } else { 0.0 };
      obs - pred
    });
    
    // Compute precision-weighted errors
    let precWeightedErrors = Array.init<Float>(numObs, func(i : Nat) : Float {
      predErrors[i] * model.likelihoodPrecision[i]
    });
    
    // Accuracy term: -0.5 × Σ_i (ln(2π/π_i) + π_i × ε_i²)
    var accuracy : Float = 0.0;
    for (i in Iter.range(0, numObs - 1)) {
      let pi = model.likelihoodPrecision[i];
      let error = predErrors[i];
      accuracy -= 0.5 * (LN_2PI - ln(pi) + pi * error * error);
    };
    
    // Complexity term: D_KL[q(s) || p(s)]
    // For diagonal Gaussians: 0.5 × Σ_i (π_p/π_q + π_p(μ_q - μ_p)² - 1 + ln(π_q/π_p))
    var complexity : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let qMean = beliefs.beliefs[i].mean;
      let qPrec = beliefs.beliefs[i].precision;
      let pMean = if (i < Array.size(model.priorMean)) { model.priorMean[i] } else { S_ZERO_FLOOR };
      let pPrec = if (i < Array.size(model.priorPrecision)) { model.priorPrecision[i] } else { DEFAULT_PRECISION };
      
      let meanDiff = qMean - pMean;
      complexity += 0.5 * (pPrec / qPrec + pPrec * meanDiff * meanDiff - 1.0 + ln(qPrec / pPrec));
    };
    
    // Free Energy
    let fe = complexity - accuracy;
    
    // Surprisal (total prediction error magnitude)
    var surprisal : Float = 0.0;
    for (i in Iter.range(0, numObs - 1)) {
      surprisal += Float.abs(predErrors[i]);
    };
    
    {
      var complexity = complexity;
      var accuracy = accuracy;
      var freeEnergy = fe;
      var surprisal = surprisal;
      var predictionErrors = predErrors;
      var precisionWeightedErrors = precWeightedErrors;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: PREDICTIVE CODING HIERARCHY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The brain implements FE minimization through a hierarchy of prediction/error nodes.
  // Each level receives predictions from above and sends errors upward.
  //
  
  public type PredictiveCodingLevel = {
    levelIndex : Nat;
    var stateSize : Nat;
    
    // State estimates (μ)
    var stateMeans : [var Float];
    var statePrecisions : [var Float];
    
    // Predictions from above
    var topDownPredictions : [var Float];
    var topDownPrecision : Float;
    
    // Errors to send upward
    var predictionErrors : [var Float];
    var errorPrecision : Float;
    
    // Lateral connections (within level)
    var lateralWeights : [[var Float]];
    
    // Temporal dynamics
    var previousStates : [var Float];
    var stateVelocities : [var Float];
  };
  
  public type PredictiveCodingHierarchy = {
    var levels : [var PredictiveCodingLevel];
    var numLevels : Nat;
    var globalFreeEnergy : Float;
    var totalPredictionError : Float;
  };
  
  // Initialize a single level
  public func initPCLevel(levelIdx : Nat, stateSize : Nat) : PredictiveCodingLevel {
    let lateralW = Array.init<[var Float]>(stateSize, func(i : Nat) : [var Float] {
      Array.init<Float>(stateSize, func(j : Nat) : Float {
        if (i == j) { 0.0 } else { 0.1 / Float.fromInt(stateSize) }
      })
    });
    
    {
      levelIndex = levelIdx;
      var stateSize = stateSize;
      var stateMeans = Array.init<Float>(stateSize, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var statePrecisions = Array.init<Float>(stateSize, func(_ : Nat) : Float { DEFAULT_PRECISION });
      var topDownPredictions = Array.init<Float>(stateSize, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var topDownPrecision = DEFAULT_PRECISION;
      var predictionErrors = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
      var errorPrecision = DEFAULT_PRECISION;
      var lateralWeights = lateralW;
      var previousStates = Array.init<Float>(stateSize, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var stateVelocities = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Initialize complete hierarchy
  public func initPCHierarchy(levelSizes : [Nat]) : PredictiveCodingHierarchy {
    let numLevels = Array.size(levelSizes);
    let levels = Array.init<PredictiveCodingLevel>(numLevels, func(l : Nat) : PredictiveCodingLevel {
      initPCLevel(l, levelSizes[l])
    });
    
    {
      var levels = levels;
      var numLevels = numLevels;
      var globalFreeEnergy = 0.0;
      var totalPredictionError = 0.0;
    }
  };
  
  // Run one pass of predictive coding
  // INTERTWINING: Uses Kuramoto coherence to modulate precision
  public func runPredictiveCodingPass(
    hierarchy : PredictiveCodingHierarchy,
    sensoryInput : [Float],              // Bottom-level input
    kuramotoCoherence : Float,           // ← INTERTWINING: From Kuramoto
    dt : Float
  ) {
    let numLevels = hierarchy.numLevels;
    
    // 1. Bottom-up pass: compute prediction errors
    for (l in Iter.range(0, numLevels - 1)) {
      let level = hierarchy.levels[l];
      
      // Get input (sensory for level 0, states from below for higher)
      let input : [Float] = if (l == 0) {
        sensoryInput
      } else {
        Array.freeze(hierarchy.levels[l - 1].stateMeans)
      };
      
      // Compute prediction errors: ε = input - prediction
      for (i in Iter.range(0, level.stateSize - 1)) {
        let obs = if (i < Array.size(input)) { input[i] } else { S_ZERO_FLOOR };
        let pred = level.topDownPredictions[i];
        level.predictionErrors[i] := obs - pred;
      };
      
      // Modulate error precision by coherence
      // High coherence → trust errors more → higher precision
      level.errorPrecision := DEFAULT_PRECISION * (0.5 + kuramotoCoherence);
    };
    
    // 2. Top-down pass: generate predictions
    for (lRev in Iter.range(0, numLevels - 1)) {
      let l = numLevels - 1 - lRev;  // Reverse order
      let level = hierarchy.levels[l];
      
      if (l < numLevels - 1) {
        // Get predictions from level above
        let above = hierarchy.levels[l + 1];
        
        // Simple linear prediction: pred = W × state_above
        for (i in Iter.range(0, level.stateSize - 1)) {
          var pred : Float = 0.0;
          for (j in Iter.range(0, above.stateSize - 1)) {
            // Use lateral weights as cross-level connections
            pred += 0.5 * above.stateMeans[j] / Float.fromInt(above.stateSize);
          };
          level.topDownPredictions[i] := pred;
        };
      };
    };
    
    // 3. Update state estimates (belief update)
    var totalError : Float = 0.0;
    for (l in Iter.range(0, numLevels - 1)) {
      let level = hierarchy.levels[l];
      
      for (i in Iter.range(0, level.stateSize - 1)) {
        // Save previous state
        level.previousStates[i] := level.stateMeans[i];
        
        // Gradient descent: dμ/dt = π_ε × ε
        let errorGrad = level.errorPrecision * level.predictionErrors[i];
        
        // Add lateral contribution
        var lateralContrib : Float = 0.0;
        for (j in Iter.range(0, level.stateSize - 1)) {
          if (j != i) {
            lateralContrib += level.lateralWeights[i][j] * level.stateMeans[j];
          };
        };
        
        // Update state
        level.stateMeans[i] := level.stateMeans[i] + 
          dt * (LEARNING_RATE_MU * errorGrad + 0.1 * lateralContrib);
        level.stateMeans[i] := clamp(level.stateMeans[i], 0.0, 2.0);
        
        // Update velocity
        level.stateVelocities[i] := (level.stateMeans[i] - level.previousStates[i]) / dt;
        
        totalError += Float.abs(level.predictionErrors[i]);
      };
    };
    
    hierarchy.totalPredictionError := totalError;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: EXPECTED FREE ENERGY — ACTION SELECTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // For action selection, we compute Expected Free Energy for each possible action:
  //
  //   G(π) = E_q(o,s|π)[ln q(s|π) - ln p(o,s)]
  //        = Risk + Ambiguity - Information_Gain
  //
  // Risk: How much do predicted outcomes diverge from preferred outcomes?
  // Ambiguity: How uncertain are we about outcomes?
  // Info Gain: How much will we learn from this action?
  //
  
  public type ExpectedFreeEnergyState = {
    var actionSpace : Nat;
    var expectedFE : [var Float];        // G(a) for each action
    var risk : [var Float];              // Risk component per action
    var ambiguity : [var Float];         // Ambiguity per action
    var infoGain : [var Float];          // Information gain per action
    var pragmaticValue : [var Float];    // Value/reward component
    var epistemicValue : [var Float];    // Exploration component
    var policy : [var Float];            // π(a) = softmax(-γG(a))
    var selectedAction : Nat;
    var actionPrecision : Float;         // γ — how deterministic
  };
  
  // Initialize EFE state
  public func initEFEState(numActions : Nat) : ExpectedFreeEnergyState {
    {
      var actionSpace = numActions;
      var expectedFE = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var risk = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var ambiguity = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var infoGain = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var pragmaticValue = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var epistemicValue = Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 });
      var policy = Array.init<Float>(numActions, func(_ : Nat) : Float { 1.0 / Float.fromInt(numActions) });
      var selectedAction = 0;
      var actionPrecision = ACTION_PRECISION;
    }
  };
  
  // Compute Expected Free Energy for all actions
  // INTERTWINING: Uses Q-values for pragmatic value, Hebbian for ambiguity
  public func computeExpectedFreeEnergy(
    efe : ExpectedFreeEnergyState,
    beliefs : BeliefState,
    model : GenerativeModel,
    preferredOutcomes : [Float],         // What the organism wants
    qValues : [Float],                   // ← INTERTWINING: From Q-learning
    hebbianUncertainty : [Float]         // ← INTERTWINING: From Hebbian (inverse weights)
  ) {
    let numActions = efe.actionSpace;
    
    for (a in Iter.range(0, numActions - 1)) {
      // Predicted state after action a (simplified: action shifts state)
      let predictedStates = Array.tabulate<Float>(Array.size(beliefs.beliefs), func(i : Nat) : Float {
        beliefs.beliefs[i].mean + 0.1 * Float.fromInt(a) * (Float.fromInt(i) - 6.0) / 12.0
      });
      
      // Predicted observations
      let predictedObs = generatePrediction(model, predictedStates);
      
      // Risk: D_KL[q(o|a) || p(o)] ≈ Σ(predicted - preferred)²
      var risk : Float = 0.0;
      for (i in Iter.range(0, Array.size(predictedObs) - 1)) {
        let pred = predictedObs[i];
        let pref = if (i < Array.size(preferredOutcomes)) { preferredOutcomes[i] } else { S_ZERO };
        let diff = pred - pref;
        risk += diff * diff;
      };
      efe.risk[a] := risk;
      
      // Ambiguity: uncertainty about outcomes
      var ambiguity : Float = 0.0;
      for (i in Iter.range(0, Array.size(beliefs.beliefs) - 1)) {
        ambiguity += 1.0 / (beliefs.beliefs[i].precision + 0.01);
        if (i < Array.size(hebbianUncertainty)) {
          ambiguity += hebbianUncertainty[i];
        };
      };
      efe.ambiguity[a] := ambiguity;
      
      // Information gain: expected reduction in uncertainty
      // Approximate: novelty of predicted state
      var infoGain : Float = 0.0;
      for (i in Iter.range(0, Array.size(predictedStates) - 1)) {
        let novelty = Float.abs(predictedStates[i] - beliefs.beliefs[i].mean);
        infoGain += novelty / (beliefs.beliefs[i].variance + 0.01);
      };
      efe.infoGain[a] := infoGain;
      
      // Pragmatic value: from Q-learning
      let qVal = if (a < Array.size(qValues)) { qValues[a] } else { 0.0 };
      efe.pragmaticValue[a] := -qVal;  // Negative because G should be minimized
      
      // Epistemic value: information gain
      efe.epistemicValue[a] := -infoGain;  // Negative because we want high info gain
      
      // Total Expected Free Energy
      efe.expectedFE[a] := risk + ambiguity - infoGain + efe.pragmaticValue[a];
    };
    
    // Compute policy: π(a) = softmax(-γ × G(a))
    var maxG : Float = efe.expectedFE[0];
    for (a in Iter.range(1, numActions - 1)) {
      if (efe.expectedFE[a] > maxG) { maxG := efe.expectedFE[a] };
    };
    
    var sumExp : Float = 0.0;
    for (a in Iter.range(0, numActions - 1)) {
      let expVal = exp(-efe.actionPrecision * (efe.expectedFE[a] - maxG));
      efe.policy[a] := expVal;
      sumExp += expVal;
    };
    
    // Normalize
    for (a in Iter.range(0, numActions - 1)) {
      efe.policy[a] := efe.policy[a] / (sumExp + 0.0001);
    };
    
    // Select action (argmax of policy)
    var bestAction : Nat = 0;
    var bestProb : Float = efe.policy[0];
    for (a in Iter.range(1, numActions - 1)) {
      if (efe.policy[a] > bestProb) {
        bestProb := efe.policy[a];
        bestAction := a;
      };
    };
    efe.selectedAction := bestAction;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: PRECISION DYNAMICS — ATTENTION AND CONFIDENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Precision (inverse variance) determines how much we trust different signals.
  // Attention = precision optimization.
  //
  // Precision dynamics:
  //   dπ/dt = -∂F/∂π = 0.5 × (1/π - ε²)
  //
  // High precision → trust this signal more
  // Low precision → ignore this signal
  //
  
  public type PrecisionState = {
    var sensoryPrecision : [var Float];      // How much to trust senses
    var priorPrecision : [var Float];        // How much to trust priors
    var actionPrecision : Float;             // How deterministic to be
    var hierarchicalPrecisions : [[var Float]];  // Precision at each level
    var attentionWeights : [var Float];      // Where attention is focused
    var volatility : Float;                  // Environmental change rate
    var learningFromVolatility : Float;      // Adapt precision to volatility
  };
  
  // Initialize precision state
  public func initPrecisionState(numSensory : Nat, numHierarchyLevels : Nat) : PrecisionState {
    let hierPrec = Array.init<[var Float]>(numHierarchyLevels, func(l : Nat) : [var Float] {
      let levelSize = numSensory / pow2(l);
      Array.init<Float>(levelSize, func(_ : Nat) : Float { DEFAULT_PRECISION })
    });
    
    {
      var sensoryPrecision = Array.init<Float>(numSensory, func(_ : Nat) : Float { DEFAULT_PRECISION });
      var priorPrecision = Array.init<Float>(numSensory, func(_ : Nat) : Float { DEFAULT_PRECISION });
      var actionPrecision = ACTION_PRECISION;
      var hierarchicalPrecisions = hierPrec;
      var attentionWeights = Array.init<Float>(numSensory, func(_ : Nat) : Float { 1.0 / Float.fromInt(numSensory) });
      var volatility = 0.1;
      var learningFromVolatility = 0.01;
    }
  };
  
  // Update precision based on prediction errors
  // INTERTWINING: Receives coherence from Kuramoto
  public func updatePrecision(
    state : PrecisionState,
    predictionErrors : [Float],
    previousErrors : [Float],
    kuramotoCoherence : Float            // ← INTERTWINING: From Kuramoto
  ) {
    let n = Array.size(state.sensoryPrecision);
    
    // Estimate volatility from error changes
    var errorChange : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let curr = if (i < Array.size(predictionErrors)) { predictionErrors[i] } else { 0.0 };
      let prev = if (i < Array.size(previousErrors)) { previousErrors[i] } else { 0.0 };
      errorChange += Float.abs(curr - prev);
    };
    state.volatility := 0.95 * state.volatility + 0.05 * errorChange / Float.fromInt(n);
    
    // Update sensory precision
    for (i in Iter.range(0, n - 1)) {
      let error = if (i < Array.size(predictionErrors)) { predictionErrors[i] } else { 0.0 };
      let errorSq = error * error;
      
      // Precision gradient: dπ/dt ∝ (1/π - ε²)
      let gradient = 1.0 / (state.sensoryPrecision[i] + 0.001) - errorSq;
      state.sensoryPrecision[i] := state.sensoryPrecision[i] + 
        LEARNING_RATE_PI * gradient;
      
      // Modulate by volatility (high volatility → lower precision)
      state.sensoryPrecision[i] := state.sensoryPrecision[i] / (1.0 + state.volatility);
      
      // Modulate by coherence (high coherence → higher precision)
      state.sensoryPrecision[i] := state.sensoryPrecision[i] * (0.5 + kuramotoCoherence);
      
      // Clamp
      state.sensoryPrecision[i] := clamp(state.sensoryPrecision[i], PRECISION_MIN, PRECISION_MAX);
    };
    
    // Update attention weights (softmax over precision)
    var sumPrec : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      sumPrec += state.sensoryPrecision[i];
    };
    for (i in Iter.range(0, n - 1)) {
      state.attentionWeights[i] := state.sensoryPrecision[i] / (sumPrec + 0.0001);
    };
    
    // Action precision adapts to average sensory precision
    let avgPrec = sumPrec / Float.fromInt(n);
    state.actionPrecision := clamp(avgPrec * 2.0, 0.5, 10.0);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: MARKOV BLANKET DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // A Markov blanket separates internal states from external states.
  // The blanket consists of:
  //   - Sensory states: influenced by external, influence internal
  //   - Active states: influenced by internal, influence external
  //
  // This defines the boundary of the organism.
  //
  
  public type MarkovBlanket = {
    // State partitions
    var internalStates : [var Float];    // μ — internal (hidden from world)
    var externalStates : [var Float];    // η — external (hidden from organism)
    var sensoryStates : [var Float];     // s — sensory part of blanket
    var activeStates : [var Float];      // a — active part of blanket
    
    // Coupling matrices
    var sensoryToInternal : [[var Float]];   // How sensory affects internal
    var internalToActive : [[var Float]];    // How internal affects active
    var activeToExternal : [[var Float]];    // How active affects external
    var externalToSensory : [[var Float]];   // How external affects sensory
    
    // Blanket statistics
    var blanketEntropy : Float;
    var internalEntropy : Float;
    var mutualInformation : Float;       // I(internal; external | blanket)
  };
  
  // Initialize Markov blanket
  public func initMarkovBlanket(
    numInternal : Nat,
    numExternal : Nat,
    numSensory : Nat,
    numActive : Nat
  ) : MarkovBlanket {
    let s2i = Array.init<[var Float]>(numInternal, func(_ : Nat) : [var Float] {
      Array.init<Float>(numSensory, func(_ : Nat) : Float { 0.1 })
    });
    let i2a = Array.init<[var Float]>(numActive, func(_ : Nat) : [var Float] {
      Array.init<Float>(numInternal, func(_ : Nat) : Float { 0.1 })
    });
    let a2e = Array.init<[var Float]>(numExternal, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActive, func(_ : Nat) : Float { 0.1 })
    });
    let e2s = Array.init<[var Float]>(numSensory, func(_ : Nat) : [var Float] {
      Array.init<Float>(numExternal, func(_ : Nat) : Float { 0.1 })
    });
    
    {
      var internalStates = Array.init<Float>(numInternal, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var externalStates = Array.init<Float>(numExternal, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var sensoryStates = Array.init<Float>(numSensory, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var activeStates = Array.init<Float>(numActive, func(_ : Nat) : Float { 0.0 });
      var sensoryToInternal = s2i;
      var internalToActive = i2a;
      var activeToExternal = a2e;
      var externalToSensory = e2s;
      var blanketEntropy = 0.0;
      var internalEntropy = 0.0;
      var mutualInformation = 0.0;
    }
  };
  
  // Update Markov blanket dynamics
  // INTERTWINING: Actions come from EFE, sensory comes from environment
  public func updateMarkovBlanket(
    blanket : MarkovBlanket,
    environmentalState : [Float],        // External state estimate
    actionPolicy : [Float],              // ← INTERTWINING: From EFE
    dt : Float
  ) {
    let numInternal = Array.size(blanket.internalStates);
    let numExternal = Array.size(blanket.externalStates);
    let numSensory = Array.size(blanket.sensoryStates);
    let numActive = Array.size(blanket.activeStates);
    
    // 1. External → Sensory
    for (i in Iter.range(0, numSensory - 1)) {
      var sensoryInput : Float = 0.0;
      for (j in Iter.range(0, numExternal - 1)) {
        let ext = if (j < Array.size(environmentalState)) { environmentalState[j] } else { blanket.externalStates[j] };
        sensoryInput += blanket.externalToSensory[i][j] * ext;
      };
      blanket.sensoryStates[i] := 0.9 * blanket.sensoryStates[i] + 0.1 * sensoryInput;
    };
    
    // 2. Sensory → Internal (perception)
    for (i in Iter.range(0, numInternal - 1)) {
      var internalInput : Float = 0.0;
      for (j in Iter.range(0, numSensory - 1)) {
        internalInput += blanket.sensoryToInternal[i][j] * blanket.sensoryStates[j];
      };
      blanket.internalStates[i] := 0.9 * blanket.internalStates[i] + 0.1 * internalInput;
    };
    
    // 3. Internal → Active (action selection)
    for (i in Iter.range(0, numActive - 1)) {
      var activeOutput : Float = 0.0;
      for (j in Iter.range(0, numInternal - 1)) {
        activeOutput += blanket.internalToActive[i][j] * blanket.internalStates[j];
      };
      // Modulate by policy
      let policyMod = if (i < Array.size(actionPolicy)) { actionPolicy[i] } else { 0.0 };
      blanket.activeStates[i] := activeOutput * policyMod;
    };
    
    // 4. Active → External (action effects)
    for (i in Iter.range(0, numExternal - 1)) {
      var externalChange : Float = 0.0;
      for (j in Iter.range(0, numActive - 1)) {
        externalChange += blanket.activeToExternal[i][j] * blanket.activeStates[j];
      };
      blanket.externalStates[i] := blanket.externalStates[i] + dt * externalChange;
    };
    
    // Compute blanket statistics
    var blanketSum : Float = 0.0;
    var blanketSqSum : Float = 0.0;
    for (i in Iter.range(0, numSensory - 1)) {
      blanketSum += blanket.sensoryStates[i];
      blanketSqSum += blanket.sensoryStates[i] * blanket.sensoryStates[i];
    };
    for (i in Iter.range(0, numActive - 1)) {
      blanketSum += blanket.activeStates[i];
      blanketSqSum += blanket.activeStates[i] * blanket.activeStates[i];
    };
    
    let n = Float.fromInt(numSensory + numActive);
    let variance = blanketSqSum / n - (blanketSum / n) * (blanketSum / n);
    blanket.blanketEntropy := 0.5 * ln(2.0 * PI * E * (variance + 0.001));
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: COMPLETE DEEP FREE ENERGY STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type DeepFreeEnergyState = {
    // Core components
    generalizedState : GeneralizedState;
    beliefs : BeliefState;
    generativeModel : GenerativeModel;
    freeEnergy : FreeEnergyComponents;
    
    // Hierarchical processing
    hierarchy : PredictiveCodingHierarchy;
    
    // Action selection
    efe : ExpectedFreeEnergyState;
    
    // Precision/attention
    precision : PrecisionState;
    
    // Markov blanket
    blanket : MarkovBlanket;
    
    // History
    var freeEnergyHistory : [Float];
    var historyIndex : Nat;
    var currentBeat : Nat;
    
    // Summary statistics
    var avgFreeEnergy : Float;
    var avgSurprisal : Float;
    var avgPrecision : Float;
  };
  
  // Initialize complete state
  public func initDeepFreeEnergyState() : DeepFreeEnergyState {
    let initialMeans = Array.tabulate<Float>(NUM_NODES, func(_ : Nat) : Float { S_ZERO_FLOOR });
    
    {
      generalizedState = initGeneralizedState(NUM_NODES, initialMeans);
      beliefs = initBeliefState(NUM_NODES, initialMeans);
      generativeModel = initGenerativeModel(NUM_NODES, NUM_OUTCOMES);
      freeEnergy = {
        var complexity = 0.0;
        var accuracy = 0.0;
        var freeEnergy = 0.0;
        var surprisal = 0.0;
        var predictionErrors = Array.init<Float>(NUM_OUTCOMES, func(_ : Nat) : Float { 0.0 });
        var precisionWeightedErrors = Array.init<Float>(NUM_OUTCOMES, func(_ : Nat) : Float { 0.0 });
      };
      hierarchy = initPCHierarchy([NUM_NODES, NUM_NODES / 2, NUM_NODES / 4, 3]);
      efe = initEFEState(NUM_ACTIONS);
      precision = initPrecisionState(NUM_NODES, NUM_HIERARCHY_LEVELS);
      blanket = initMarkovBlanket(NUM_NODES, NUM_NODES, NUM_NODES, NUM_ACTIONS);
      var freeEnergyHistory = Array.freeze(Array.init<Float>(1000, func(_ : Nat) : Float { 0.0 }));
      var historyIndex = 0;
      var currentBeat = 0;
      var avgFreeEnergy = 0.0;
      var avgSurprisal = 0.0;
      var avgPrecision = DEFAULT_PRECISION;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 10: THE COMPLETE INTERTWINED HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type FreeEnergyHeartbeatResult = {
    freeEnergy : Float;
    surprisal : Float;
    selectedAction : Nat;
    meanPrecision : Float;
    complexityTerm : Float;
    accuracyTerm : Float;
    epistemicValue : Float;
    pragmaticValue : Float;
  };
  
  // The complete intertwined Free Energy heartbeat
  public func runFreeEnergyHeartbeat(
    state : DeepFreeEnergyState,
    observations : [Float],              // Current sensory observations
    
    // INTERTWINED INPUTS
    kuramotoCoherence : Float,           // ← INTERTWINING: From Kuramoto
    kuramotoPhases : [Float],            // ← INTERTWINING: From Kuramoto
    hebbianWeights : [[Float]],          // ← INTERTWINING: From Hebbian
    qValues : [Float],                   // ← INTERTWINING: From Q-learning
    memoryPattern : ?[Float],            // ← INTERTWINING: From Memory
    
    dt : Float
  ) : FreeEnergyHeartbeatResult {
    state.currentBeat += 1;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Update generalized coordinates from observations
    // ───────────────────────────────────────────────────────────────────────────
    updateGeneralizedCoordinates(state.generalizedState, observations, dt);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Update generative model from Hebbian weights
    // INTERTWINING: Hebbian → Generative Model
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, state.generativeModel.numObservations - 1)) {
      for (j in Iter.range(0, state.generativeModel.numStates - 1)) {
        if (i < Array.size(hebbianWeights) and j < Array.size(hebbianWeights[i])) {
          // Blend Hebbian weights into observation matrix
          state.generativeModel.observationMatrix[i][j] := 
            0.9 * state.generativeModel.observationMatrix[i][j] + 
            0.1 * hebbianWeights[i][j];
        };
      };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Run predictive coding pass
    // INTERTWINING: Kuramoto coherence modulates precision
    // ───────────────────────────────────────────────────────────────────────────
    runPredictiveCodingPass(state.hierarchy, observations, kuramotoCoherence, dt);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Compute Free Energy
    // ───────────────────────────────────────────────────────────────────────────
    let feComponents = computeFreeEnergy(state.beliefs, state.generativeModel, observations);
    state.freeEnergy := feComponents;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Update beliefs from prediction errors
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, Array.size(state.beliefs.beliefs) - 1)) {
      let error = if (i < Array.size(feComponents.predictionErrors)) {
        feComponents.predictionErrors[i]
      } else { 0.0 };
      let errorPrec = if (i < Array.size(state.precision.sensoryPrecision)) {
        state.precision.sensoryPrecision[i]
      } else { DEFAULT_PRECISION };
      
      updateBelief(state.beliefs.beliefs[i], error, errorPrec, LEARNING_RATE_MU);
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Update precision
    // INTERTWINING: Kuramoto coherence affects precision
    // ───────────────────────────────────────────────────────────────────────────
    let prevErrors = Array.freeze(state.freeEnergy.predictionErrors);
    updatePrecision(state.precision, Array.freeze(feComponents.predictionErrors), prevErrors, kuramotoCoherence);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Update generative model from prediction errors (learning)
    // ───────────────────────────────────────────────────────────────────────────
    let stateMeans = Array.tabulate<Float>(Array.size(state.beliefs.beliefs), func(i : Nat) : Float {
      state.beliefs.beliefs[i].mean
    });
    updateGenerativeModel(
      state.generativeModel,
      observations,
      stateMeans,
      Array.freeze(feComponents.predictionErrors),
      0.01  // Slow learning rate for model
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 8. Compute Expected Free Energy for action selection
    // INTERTWINING: Q-values provide pragmatic value
    // ───────────────────────────────────────────────────────────────────────────
    let preferredOutcomes = Array.tabulate<Float>(NUM_OUTCOMES, func(_ : Nat) : Float { S_ZERO });
    
    // Hebbian uncertainty = inverse of weight sum
    let hebbianUncertainty = Array.tabulate<Float>(NUM_NODES, func(i : Nat) : Float {
      if (i < Array.size(hebbianWeights)) {
        var sum : Float = 0.0;
        for (j in Iter.range(0, Array.size(hebbianWeights[i]) - 1)) {
          sum += hebbianWeights[i][j];
        };
        1.0 / (sum + 0.1)
      } else { 1.0 }
    });
    
    computeExpectedFreeEnergy(
      state.efe,
      state.beliefs,
      state.generativeModel,
      preferredOutcomes,
      qValues,                            // ← INTERTWINING: Q-learning
      hebbianUncertainty                  // ← INTERTWINING: Hebbian
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 9. Update Markov blanket
    // ───────────────────────────────────────────────────────────────────────────
    updateMarkovBlanket(
      state.blanket,
      observations,
      Array.freeze(state.efe.policy),
      dt
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 10. Memory integration
    // INTERTWINING: Memory pattern constrains beliefs
    // ───────────────────────────────────────────────────────────────────────────
    switch (memoryPattern) {
      case (?pattern) {
        // Blend memory into beliefs (pattern completion)
        for (i in Iter.range(0, Array.size(state.beliefs.beliefs) - 1)) {
          if (i < Array.size(pattern)) {
            state.beliefs.beliefs[i].mean := 
              0.9 * state.beliefs.beliefs[i].mean + 0.1 * pattern[i];
          };
        };
      };
      case (null) { };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // Update statistics
    // ───────────────────────────────────────────────────────────────────────────
    let n = Float.fromInt(state.currentBeat);
    state.avgFreeEnergy := ((n - 1.0) * state.avgFreeEnergy + feComponents.freeEnergy) / n;
    state.avgSurprisal := ((n - 1.0) * state.avgSurprisal + feComponents.surprisal) / n;
    
    var precSum : Float = 0.0;
    for (i in Iter.range(0, Array.size(state.precision.sensoryPrecision) - 1)) {
      precSum += state.precision.sensoryPrecision[i];
    };
    state.avgPrecision := precSum / Float.fromInt(Array.size(state.precision.sensoryPrecision));
    
    // Return result
    {
      freeEnergy = feComponents.freeEnergy;
      surprisal = feComponents.surprisal;
      selectedAction = state.efe.selectedAction;
      meanPrecision = state.avgPrecision;
      complexityTerm = feComponents.complexity;
      accuracyTerm = feComponents.accuracy;
      epistemicValue = state.efe.epistemicValue[state.efe.selectedAction];
      pragmaticValue = state.efe.pragmaticValue[state.efe.selectedAction];
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    if (x > 20.0) { return 485165195.0 };
    if (x < -20.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 30)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    let z : Float = (x - 1.0) / (x + 1.0);
    let zSquared : Float = z * z;
    var result : Float = 0.0;
    var term : Float = z;
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSquared;
    };
    2.0 * result
  };
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  func pow2(n : Nat) : Nat {
    var result : Nat = 1;
    for (_ in Iter.range(0, n - 1)) {
      result *= 2;
    };
    result
  };

};
