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
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";

module KalmanPredictiveField {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Kalman dimensions
  public let STATE_DIM : Nat = 256;               // Neural nodes
  public let PREDICTION_HORIZON : Nat = 60;       // Steps to predict
  public let TOTAL_PREDICTIONS : Nat = 15360;     // 256 × 60
  
  // Kalman parameters
  public let PROCESS_NOISE : Float = 0.01;        // Q - process noise
  public let MEASUREMENT_NOISE : Float = 0.1;     // R - measurement noise
  public let INITIAL_COVARIANCE : Float = 1.0;    // P₀
  
  // Stability parameters
  public let MIN_COVARIANCE : Float = 0.0001;     // Prevent singularity
  public let MAX_COVARIANCE : Float = 100.0;      // Prevent explosion
  public let MAX_GAIN : Float = 0.99;             // Maximum Kalman gain

  // ═══════════════════════════════════════════════════════════════════════════════
  // KALMAN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type KalmanState = {
    // State estimate x̂
    stateEstimate : [var Float];
    // Error covariance P (diagonal approximation for efficiency)
    errorCovariance : [var Float];
    // Process noise covariance Q (diagonal)
    processNoise : Float;
    // Measurement noise covariance R (diagonal)
    measurementNoise : Float;
    // Kalman gain K (diagonal approximation)
    kalmanGain : [var Float];
    // Innovation (measurement residual)
    innovation : [var Float];
    // State transition model A (simplified as scalar)
    transitionFactor : Float;
    // Statistics
    totalUpdates : Nat;
    avgError : Float;
    maxError : Float;
  };
  
  public func initKalmanState() : KalmanState {
    {
      stateEstimate = Array.tabulateVar<Float>(STATE_DIM, func(_ : Nat) : Float { 0.0 });
      errorCovariance = Array.tabulateVar<Float>(STATE_DIM, func(_ : Nat) : Float { INITIAL_COVARIANCE });
      processNoise = PROCESS_NOISE;
      measurementNoise = MEASUREMENT_NOISE;
      kalmanGain = Array.tabulateVar<Float>(STATE_DIM, func(_ : Nat) : Float { 0.5 });
      innovation = Array.tabulateVar<Float>(STATE_DIM, func(_ : Nat) : Float { 0.0 });
      transitionFactor = 0.99;
      totalUpdates = 0;
      avgError = 0.0;
      maxError = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KALMAN PREDICT STEP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Predict state one step ahead
  public func predict(state : KalmanState) : KalmanState {
    // x̂ₖ|ₖ₋₁ = A × x̂ₖ₋₁|ₖ₋₁
    for (i in Iter.range(0, STATE_DIM - 1)) {
      state.stateEstimate[i] := state.stateEstimate[i] * state.transitionFactor;
    };
    
    // Pₖ|ₖ₋₁ = A × Pₖ₋₁|ₖ₋₁ × A' + Q
    for (i in Iter.range(0, STATE_DIM - 1)) {
      let predicted = state.errorCovariance[i] * state.transitionFactor * state.transitionFactor + state.processNoise;
      state.errorCovariance[i] := clamp(predicted, MIN_COVARIANCE, MAX_COVARIANCE);
    };
    
    state
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KALMAN UPDATE STEP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // Update state with measurement
  public func update(
    state : KalmanState,
    measurement : [Float]
  ) : KalmanState {
    var totalError : Float = 0.0;
    var maxError : Float = 0.0;
    
    let measSize = measurement.size();
    
    for (i in Iter.range(0, STATE_DIM - 1)) {
      // Get measurement (or use prediction if no measurement)
      let z = if (i < measSize) { measurement[i] } else { state.stateEstimate[i] };
      
      // Innovation yₖ = zₖ - H × x̂ₖ|ₖ₋₁
      let innovation = z - state.stateEstimate[i];
      state.innovation[i] := innovation;
      
      // Innovation covariance S = H × P × H' + R
      let S = state.errorCovariance[i] + state.measurementNoise;
      
      // Kalman gain K = P × H' × S⁻¹
      let K = if (S > MIN_COVARIANCE) {
        clamp(state.errorCovariance[i] / S, 0.0, MAX_GAIN)
      } else { 0.5 };
      state.kalmanGain[i] := K;
      
      // Update state x̂ₖ|ₖ = x̂ₖ|ₖ₋₁ + K × yₖ
      state.stateEstimate[i] := state.stateEstimate[i] + K * innovation;
      
      // Update covariance P = (I - K × H) × P
      state.errorCovariance[i] := clamp((1.0 - K) * state.errorCovariance[i], MIN_COVARIANCE, MAX_COVARIANCE);
      
      // Track error
      let absError = Float.abs(innovation);
      totalError += absError;
      if (absError > maxError) { maxError := absError };
    };
    
    {
      stateEstimate = state.stateEstimate;
      errorCovariance = state.errorCovariance;
      processNoise = state.processNoise;
      measurementNoise = state.measurementNoise;
      kalmanGain = state.kalmanGain;
      innovation = state.innovation;
      transitionFactor = state.transitionFactor;
      totalUpdates = state.totalUpdates + 1;
      avgError = totalError / Float.fromInt(STATE_DIM);
      maxError = maxError;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 60-STEP PREDICTIVE FIELD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictiveField = {
    // 60 × 256 prediction matrix (row = time step, col = node)
    predictions : [[var Float]];
    // Confidence for each prediction (decays with horizon)
    confidence : [[var Float]];
    // Aggregate statistics
    horizonConfidence : [Float];  // Confidence per time step
    avgPrediction : [Float];      // Average prediction per node
    predictionVariance : [Float]; // Variance per node
    // Field-wide metrics
    totalFieldError : Float;
    fieldCoherence : Float;
    lastUpdate : Int;
  };
  
  public func initPredictiveField() : PredictiveField {
    let predictions = Array.tabulate<[var Float]>(PREDICTION_HORIZON, func(_ : Nat) : [var Float] {
      Array.tabulateVar<Float>(STATE_DIM, func(_ : Nat) : Float { 0.0 })
    });
    
    let confidence = Array.tabulate<[var Float]>(PREDICTION_HORIZON, func(t : Nat) : [var Float] {
      // Confidence decays with prediction horizon
      let baseConf = Float.exp(-Float.fromInt(t) * 0.1);
      Array.tabulateVar<Float>(STATE_DIM, func(_ : Nat) : Float { baseConf })
    });
    
    {
      predictions = predictions;
      confidence = confidence;
      horizonConfidence = Array.tabulate<Float>(PREDICTION_HORIZON, func(t : Nat) : Float {
        Float.exp(-Float.fromInt(t) * 0.1)
      });
      avgPrediction = Array.tabulate<Float>(STATE_DIM, func(_ : Nat) : Float { 0.0 });
      predictionVariance = Array.tabulate<Float>(STATE_DIM, func(_ : Nat) : Float { 1.0 });
      totalFieldError = 0.0;
      fieldCoherence = 1.0;
      lastUpdate = 0;
    }
  };
  
  // Generate 60-step predictions from current state
  public func generatePredictions(
    kalman : KalmanState,
    field : PredictiveField,
    currentTime : Int
  ) : PredictiveField {
    // Copy current state for iterated prediction
    let tempState = Array.tabulateVar<Float>(STATE_DIM, func(i : Nat) : Float {
      kalman.stateEstimate[i]
    });
    let tempCov = Array.tabulateVar<Float>(STATE_DIM, func(i : Nat) : Float {
      kalman.errorCovariance[i]
    });
    
    // Generate predictions for each horizon step
    for (t in Iter.range(0, PREDICTION_HORIZON - 1)) {
      // Apply state transition
      for (i in Iter.range(0, STATE_DIM - 1)) {
        tempState[i] := tempState[i] * kalman.transitionFactor;
        tempCov[i] := tempCov[i] * kalman.transitionFactor * kalman.transitionFactor + kalman.processNoise;
        
        // Store prediction
        field.predictions[t][i] := tempState[i];
        
        // Confidence based on covariance
        field.confidence[t][i] := clamp(1.0 / (1.0 + tempCov[i]), 0.0, 1.0);
      };
    };
    
    // Compute aggregate statistics
    let avgPred = Array.tabulateVar<Float>(STATE_DIM, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (t in Iter.range(0, PREDICTION_HORIZON - 1)) {
        sum += field.predictions[t][i];
      };
      sum / Float.fromInt(PREDICTION_HORIZON)
    });
    
    let variance = Array.tabulateVar<Float>(STATE_DIM, func(i : Nat) : Float {
      var sumSq : Float = 0.0;
      for (t in Iter.range(0, PREDICTION_HORIZON - 1)) {
        let diff = field.predictions[t][i] - avgPred[i];
        sumSq += diff * diff;
      };
      sumSq / Float.fromInt(PREDICTION_HORIZON)
    });
    
    // Compute field coherence
    var totalCoherence : Float = 0.0;
    for (t in Iter.range(0, PREDICTION_HORIZON - 1)) {
      for (i in Iter.range(0, STATE_DIM - 1)) {
        totalCoherence += field.confidence[t][i];
      };
    };
    let fieldCoherence = totalCoherence / Float.fromInt(TOTAL_PREDICTIONS);
    
    {
      predictions = field.predictions;
      confidence = field.confidence;
      horizonConfidence = Array.tabulate<Float>(PREDICTION_HORIZON, func(t : Nat) : Float {
        var sum : Float = 0.0;
        for (i in Iter.range(0, STATE_DIM - 1)) {
          sum += field.confidence[t][i];
        };
        sum / Float.fromInt(STATE_DIM)
      });
      avgPrediction = Array.freeze(avgPred);
      predictionVariance = Array.freeze(variance);
      totalFieldError = field.totalFieldError;
      fieldCoherence = fieldCoherence;
      lastUpdate = currentTime;
    }
  };
  
  // Evaluate prediction accuracy against actual observation
  public func evaluatePredictions(
    field : PredictiveField,
    actual : [Float],
    horizonStep : Nat
  ) : Float {
    if (horizonStep >= PREDICTION_HORIZON) {
      return 0.0;
    };
    
    var totalError : Float = 0.0;
    let actualSize = actual.size();
    
    for (i in Iter.range(0, STATE_DIM - 1)) {
      let predicted = field.predictions[horizonStep][i];
      let observed = if (i < actualSize) { actual[i] } else { 0.0 };
      totalError += Float.abs(predicted - observed);
    };
    
    totalError / Float.fromInt(STATE_DIM)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREE ENERGY INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FreeEnergyState = {
    // F = -log P(o|m) + KL[Q(s)||P(s)]
    // ≈ prediction error + complexity
    predictionError : Float;      // Sensory prediction error
    complexity : Float;           // Model complexity cost
    freeEnergy : Float;           // Total free energy
    // Tracking
    errorHistory : [Float];       // Recent errors
    energyHistory : [Float];      // Recent F values
    avgError : Float;
    avgEnergy : Float;
  };
  
  public func initFreeEnergyState() : FreeEnergyState {
    {
      predictionError = 0.0;
      complexity = 0.0;
      freeEnergy = 0.0;
      errorHistory = [];
      energyHistory = [];
      avgError = 0.0;
      avgEnergy = 0.0;
    }
  };
  
  // Compute variational free energy
  public func computeFreeEnergy(
    kalman : KalmanState,
    observation : [Float]
  ) : FreeEnergyState {
    // Prediction error (negative log likelihood)
    var predError : Float = 0.0;
    let obsSize = observation.size();
    
    for (i in Iter.range(0, STATE_DIM - 1)) {
      let obs = if (i < obsSize) { observation[i] } else { 0.0 };
      let pred = kalman.stateEstimate[i];
      let variance = kalman.errorCovariance[i] + kalman.measurementNoise;
      
      // Gaussian negative log likelihood
      let diff = obs - pred;
      predError += diff * diff / (2.0 * variance) + 0.5 * Float.log(2.0 * PI * variance);
    };
    predError /= Float.fromInt(STATE_DIM);
    
    // Complexity (KL divergence from prior)
    var complexity : Float = 0.0;
    for (i in Iter.range(0, STATE_DIM - 1)) {
      let variance = kalman.errorCovariance[i];
      // KL divergence for Gaussian with unit prior
      complexity += 0.5 * (variance + kalman.stateEstimate[i] * kalman.stateEstimate[i] - 1.0 - Float.log(Float.max(variance, MIN_COVARIANCE)));
    };
    complexity /= Float.fromInt(STATE_DIM);
    
    // Total free energy
    let F = predError + 0.1 * complexity;
    
    {
      predictionError = predError;
      complexity = complexity;
      freeEnergy = F;
      errorHistory = [];
      energyHistory = [];
      avgError = predError;
      avgEnergy = F;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE PREDICTIVE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictiveState = {
    kalman : KalmanState;
    field : PredictiveField;
    freeEnergy : FreeEnergyState;
    // Global metrics
    overallAccuracy : Float;
    predictionConfidence : Float;
    energyMinimized : Bool;
    lastTick : Int;
  };
  
  public func initPredictiveState() : PredictiveState {
    {
      kalman = initKalmanState();
      field = initPredictiveField();
      freeEnergy = initFreeEnergyState();
      overallAccuracy = 0.0;
      predictionConfidence = 0.5;
      energyMinimized = false;
      lastTick = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictiveTickResult = {
    kalmanError : Float;
    freeEnergy : Float;
    fieldCoherence : Float;
    bestPrediction : [Float];     // Single-step-ahead prediction
    confidence : Float;
  };
  
  public func predictiveTick(
    state : PredictiveState,
    observation : [Float],
    currentTime : Int
  ) : PredictiveTickResult {
    // 1. Kalman predict
    let predictedKalman = predict(state.kalman);
    
    // 2. Kalman update with observation
    let updatedKalman = update(predictedKalman, observation);
    
    // 3. Generate 60-step predictions
    let updatedField = generatePredictions(updatedKalman, state.field, currentTime);
    
    // 4. Compute free energy
    let fe = computeFreeEnergy(updatedKalman, observation);
    
    // 5. Extract single-step prediction (t+1)
    let bestPred = Array.tabulate<Float>(STATE_DIM, func(i : Nat) : Float {
      updatedField.predictions[0][i]
    });
    
    {
      kalmanError = updatedKalman.avgError;
      freeEnergy = fe.freeEnergy;
      fieldCoherence = updatedField.fieldCoherence;
      bestPrediction = bestPred;
      confidence = updatedField.horizonConfidence[0];
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}
