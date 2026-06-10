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
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";

module PredictiveField {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  
  // Predictive field dimensions
  public let PREDICTION_HORIZON : Nat = 60;       // 60 steps ahead
  public let SHELL3_DIM : Nat = 256;              // 256 Shell 3 nodes
  public let TOTAL_FLOATS : Nat = 15360;          // 60 × 256
  
  // Kalman filter parameters
  public let PROCESS_NOISE : Float = 0.01;        // Q
  public let MEASUREMENT_NOISE : Float = 0.1;     // R
  public let INITIAL_COVARIANCE : Float = 1.0;    // P₀
  
  // Bee neuron parameters
  public let BEE_ANCHOR_HZ : Float = 20.0;        // 20 Hz anchor frequency
  public let GABA_THRESHOLD : Float = 0.3;        // Sparse activation threshold
  public let WAGGLE_COMPRESSION : Float = 0.1;    // Waggle dance compression factor

  // ═══════════════════════════════════════════════════════════════════════════════
  // KALMAN FILTER STATE — Per node
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type KalmanState = {
    x : Float;                    // State estimate
    P : Float;                    // Error covariance
    Q : Float;                    // Process noise covariance
    R : Float;                    // Measurement noise covariance
    K : Float;                    // Kalman gain
    innovation : Float;           // Measurement residual
    lastMeasurement : Float;
    lastPrediction : Float;
  };
  
  public func initKalmanState(initialEstimate : Float) : KalmanState {
    {
      x = initialEstimate;
      P = INITIAL_COVARIANCE;
      Q = PROCESS_NOISE;
      R = MEASUREMENT_NOISE;
      K = 0.0;
      innovation = 0.0;
      lastMeasurement = initialEstimate;
      lastPrediction = initialEstimate;
    }
  };
  
  // Kalman predict step
  // x̂⁻ = F × x̂
  // P⁻ = F × P × F' + Q
  public func kalmanPredict(state : KalmanState, F : Float) : KalmanState {
    let xPred = F * state.x;
    let PPred = F * state.P * F + state.Q;
    
    {
      x = xPred;
      P = PPred;
      Q = state.Q;
      R = state.R;
      K = state.K;
      innovation = state.innovation;
      lastMeasurement = state.lastMeasurement;
      lastPrediction = xPred;
    }
  };
  
  // Kalman update step
  // K = P⁻ × H' × (H × P⁻ × H' + R)⁻¹
  // x̂ = x̂⁻ + K × (z - H × x̂⁻)
  // P = (I - K × H) × P⁻
  public func kalmanUpdate(state : KalmanState, measurement : Float, H : Float) : KalmanState {
    // Innovation (residual)
    let innovation = measurement - H * state.x;
    
    // Innovation covariance
    let S = H * state.P * H + state.R;
    
    // Kalman gain
    let K = if (S > 0.0001) { state.P * H / S } else { 0.0 };
    
    // State update
    let xNew = state.x + K * innovation;
    
    // Covariance update
    let PNew = (1.0 - K * H) * state.P;
    
    {
      x = xNew;
      P = PNew;
      Q = state.Q;
      R = state.R;
      K = K;
      innovation = innovation;
      lastMeasurement = measurement;
      lastPrediction = state.lastPrediction;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE FIELD — 60 × 256 = 15,360 predictions
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictiveFieldState = {
    // 60-step predictions for each of 256 Shell 3 nodes
    predictions : [[var Float]];  // [60][256]
    
    // Kalman state per node
    kalmanStates : [var KalmanState];
    
    // Confidence per prediction step
    confidenceCurve : [var Float]; // 60 values
    
    // Error tracking
    kalmanErrors : [var Float];    // Per step
    cumulativeError : Float;
    
    // State transition matrix (simplified: diagonal)
    transitionF : [var Float];     // 256 values
    
    // Observation matrix
    observationH : Float;
    
    // Statistics
    meanPrediction : Float;
    variancePrediction : Float;
    predictionAccuracy : Float;
    lastUpdate : Int;
  };
  
  public func initPredictiveField() : PredictiveFieldState {
    // Initialize 60 × 256 prediction matrix
    let predictions = Array.init<[var Float]>(PREDICTION_HORIZON, func(_ : Nat) : [var Float] {
      Array.init<Float>(SHELL3_DIM, func(_ : Nat) : Float { 0.5 })
    });
    
    // Initialize Kalman states for 256 nodes
    let kalmanStates = Array.init<KalmanState>(SHELL3_DIM, func(_ : Nat) : KalmanState {
      initKalmanState(0.5)
    });
    
    // Confidence curve (decays with prediction horizon)
    let confidenceCurve = Array.init<Float>(PREDICTION_HORIZON, func(t : Nat) : Float {
      exp(-Float.fromInt(t) * 0.05)  // Exponential decay
    });
    
    // Kalman errors per step
    let kalmanErrors = Array.init<Float>(PREDICTION_HORIZON, func(_ : Nat) : Float { 0.0 });
    
    // Transition matrix (identity scaled by 0.99 for stability)
    let transitionF = Array.init<Float>(SHELL3_DIM, func(_ : Nat) : Float { 0.99 });
    
    {
      predictions = predictions;
      kalmanStates = kalmanStates;
      confidenceCurve = confidenceCurve;
      kalmanErrors = kalmanErrors;
      cumulativeError = 0.0;
      transitionF = transitionF;
      observationH = 1.0;
      meanPrediction = 0.5;
      variancePrediction = 0.0;
      predictionAccuracy = 1.0;
      lastUpdate = 0;
    }
  };
  
  // Run 60-step prediction
  public func runPrediction(
    field : PredictiveFieldState,
    currentState : [Float],       // 256 current Shell 3 values
    currentBeat : Int
  ) : () {
    // For each node
    for (nodeIdx in Iter.range(0, SHELL3_DIM - 1)) {
      // Get current measurement
      let measurement = if (nodeIdx < currentState.size()) { 
        currentState[nodeIdx] 
      } else { 
        0.5 
      };
      
      // Update Kalman filter with measurement
      let updated = kalmanUpdate(field.kalmanStates[nodeIdx], measurement, field.observationH);
      field.kalmanStates[nodeIdx] := updated;
      
      // Predict forward 60 steps
      var predictState = updated;
      let F = field.transitionF[nodeIdx];
      
      for (step in Iter.range(0, PREDICTION_HORIZON - 1)) {
        predictState := kalmanPredict(predictState, F);
        field.predictions[step][nodeIdx] := predictState.x;
        
        // Update confidence based on covariance
        if (nodeIdx == 0) {
          let conf = 1.0 / (1.0 + predictState.P);
          field.confidenceCurve[step] := conf;
        };
      };
    };
  };
  
  // Get prediction at specific step
  public func getPredictionAtStep(
    field : PredictiveFieldState,
    step : Nat
  ) : [Float] {
    if (step >= PREDICTION_HORIZON) {
      return Array.freeze(Array.init<Float>(SHELL3_DIM, func(_ : Nat) : Float { 0.0 }));
    };
    
    Array.freeze(field.predictions[step])
  };
  
  // Compute prediction error
  public func computePredictionError(
    field : PredictiveFieldState,
    actualState : [Float],
    predictionStep : Nat
  ) : Float {
    if (predictionStep >= PREDICTION_HORIZON) {
      return 1.0;
    };
    
    var errorSum : Float = 0.0;
    var count : Nat = 0;
    
    for (nodeIdx in Iter.range(0, SHELL3_DIM - 1)) {
      let predicted = field.predictions[predictionStep][nodeIdx];
      let actual = if (nodeIdx < actualState.size()) { actualState[nodeIdx] } else { 0.5 };
      let error = (predicted - actual) * (predicted - actual);
      errorSum += error;
      count += 1;
    };
    
    if (count > 0) { sqrt(errorSum / Float.fromInt(count)) } else { 0.0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BEE NEURON MODEL — Sparse GABA gate, 20Hz anchor
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BeeNeuron = {
    id : Nat8;
    wagglePhase : Float;          // Current waggle dance phase
    waggleAmplitude : Float;      // Dance intensity
    anchorFrequency : Float;      // 20 Hz anchor
    currentFrequency : Float;     // Actual frequency
    gabaGate : Float;             // GABA inhibition [0, 1]
    isActive : Bool;              // Sparse activation
    recruitmentStrength : Float;  // How strongly it recruits others
    directionEncoding : Float;    // Encoded direction (0-2π)
    distanceEncoding : Float;     // Encoded distance
    quality : Float;              // Source quality signal
  };
  
  public type BeeSwarm = {
    neurons : [var BeeNeuron];
    numActive : Nat;              // Count of active neurons
    collectivePhase : Float;      // Mean phase
    collectiveAmplitude : Float;  // Mean amplitude
    consensusDirection : Float;   // Consensus direction
    consensusDistance : Float;    // Consensus distance
    swarmCoherence : Float;       // Swarm synchronization
    waggleCompressionActive : Bool;
  };
  
  public func initBeeSwarm(numNeurons : Nat) : BeeSwarm {
    let neurons = Array.init<BeeNeuron>(numNeurons, func(i : Nat) : BeeNeuron {
      let id = Nat8.fromNat(i % 256);
      {
        id = id;
        wagglePhase = Float.fromInt(i) * TWO_PI / Float.fromInt(numNeurons);
        waggleAmplitude = 0.5;
        anchorFrequency = BEE_ANCHOR_HZ;
        currentFrequency = BEE_ANCHOR_HZ;
        gabaGate = 0.5;
        isActive = false;
        recruitmentStrength = 0.1;
        directionEncoding = 0.0;
        distanceEncoding = 0.0;
        quality = 0.5;
      }
    });
    
    {
      neurons = neurons;
      numActive = 0;
      collectivePhase = 0.0;
      collectiveAmplitude = 0.0;
      consensusDirection = 0.0;
      consensusDistance = 0.0;
      swarmCoherence = 0.0;
      waggleCompressionActive = false;
    }
  };
  
  // Sparse GABA gating
  // Only neurons with gabaGate > threshold activate
  public func sparseGABAGating(
    swarm : BeeSwarm,
    inputs : [Float],             // External inputs
    threshold : Float
  ) : Nat {
    var numActive : Nat = 0;
    
    for (i in Iter.range(0, swarm.neurons.size() - 1)) {
      let neuron = swarm.neurons[i];
      
      // Compute input to this neuron
      let input = if (i < inputs.size()) { inputs[i] } else { 0.0 };
      
      // GABA gate dynamics
      // gabaGate increases with inhibitory input, decreases with excitation
      let gabaUpdate = -input * 0.1 + (0.5 - neuron.gabaGate) * 0.01;
      let newGaba = clamp(neuron.gabaGate + gabaUpdate, 0.0, 1.0);
      
      // Sparse activation: only if GABA gate is above threshold
      let isActive = newGaba > threshold and input > 0.2;
      
      if (isActive) { numActive += 1 };
      
      swarm.neurons[i] := {
        id = neuron.id;
        wagglePhase = neuron.wagglePhase;
        waggleAmplitude = neuron.waggleAmplitude;
        anchorFrequency = neuron.anchorFrequency;
        currentFrequency = neuron.currentFrequency;
        gabaGate = newGaba;
        isActive = isActive;
        recruitmentStrength = neuron.recruitmentStrength;
        directionEncoding = neuron.directionEncoding;
        distanceEncoding = neuron.distanceEncoding;
        quality = neuron.quality;
      };
    };
    
    numActive
  };
  
  // Waggle dance compression
  // Compresses information about direction/distance into phase/amplitude
  public func waggleCompression(
    neuron : BeeNeuron,
    targetDirection : Float,
    targetDistance : Float,
    compressionFactor : Float,
    dt : Float
  ) : BeeNeuron {
    // Encode direction in phase
    let phaseTarget = targetDirection;  // 0-2π maps to direction
    let phaseDiff = phaseTarget - neuron.wagglePhase;
    let newPhase = neuron.wagglePhase + phaseDiff * compressionFactor * dt;
    
    // Encode distance in amplitude
    let ampTarget = clamp(targetDistance / 100.0, 0.0, 1.0);  // Normalize distance
    let ampDiff = ampTarget - neuron.waggleAmplitude;
    let newAmp = neuron.waggleAmplitude + ampDiff * compressionFactor * dt;
    
    // Frequency locked to 20Hz anchor
    let freqDrift = BEE_ANCHOR_HZ - neuron.currentFrequency;
    let newFreq = neuron.currentFrequency + freqDrift * 0.1;
    
    {
      id = neuron.id;
      wagglePhase = wrapPhase(newPhase);
      waggleAmplitude = clamp(newAmp, 0.0, 1.0);
      anchorFrequency = neuron.anchorFrequency;
      currentFrequency = newFreq;
      gabaGate = neuron.gabaGate;
      isActive = neuron.isActive;
      recruitmentStrength = neuron.recruitmentStrength;
      directionEncoding = targetDirection;
      distanceEncoding = targetDistance;
      quality = neuron.quality;
    }
  };
  
  // Swarm consensus computation
  public func computeSwarmConsensus(swarm : BeeSwarm) : BeeSwarm {
    var sumPhase : Float = 0.0;
    var sumAmp : Float = 0.0;
    var sumDir : Float = 0.0;
    var sumDist : Float = 0.0;
    var activeCount : Nat = 0;
    
    // Vector sum for phase coherence
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (neuron in swarm.neurons.vals()) {
      if (neuron.isActive) {
        sumCos += cos(neuron.wagglePhase) * neuron.recruitmentStrength;
        sumSin += sin(neuron.wagglePhase) * neuron.recruitmentStrength;
        sumAmp += neuron.waggleAmplitude;
        sumDir += neuron.directionEncoding;
        sumDist += neuron.distanceEncoding;
        activeCount += 1;
      };
    };
    
    let n = Float.fromInt(activeCount);
    let collectivePhase = if (activeCount > 0) { atan2(sumSin, sumCos) } else { 0.0 };
    let collectiveAmp = if (activeCount > 0) { sumAmp / n } else { 0.0 };
    let consensusDir = if (activeCount > 0) { sumDir / n } else { 0.0 };
    let consensusDist = if (activeCount > 0) { sumDist / n } else { 0.0 };
    let coherence = if (activeCount > 0) { 
      sqrt(sumCos * sumCos + sumSin * sumSin) / n 
    } else { 0.0 };
    
    {
      neurons = swarm.neurons;
      numActive = activeCount;
      collectivePhase = collectivePhase;
      collectiveAmplitude = collectiveAmp;
      consensusDirection = consensusDir;
      consensusDistance = consensusDist;
      swarmCoherence = coherence;
      waggleCompressionActive = activeCount > swarm.neurons.size() / 4;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED PREDICTIVE + BEE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PredictiveBeeSystem = {
    predictiveField : PredictiveFieldState;
    beeSwarm : BeeSwarm;
    predictionInfluence : Float;  // How much predictions affect bees
    beeInfluence : Float;         // How much bees affect predictions
    systemCoherence : Float;
    lastBeat : Int;
  };
  
  public func initPredictiveBeeSystem() : PredictiveBeeSystem {
    {
      predictiveField = initPredictiveField();
      beeSwarm = initBeeSwarm(256);  // 256 bee neurons for Shell 3
      predictionInfluence = 0.3;
      beeInfluence = 0.2;
      systemCoherence = 0.5;
      lastBeat = 0;
    }
  };
  
  // Full tick of predictive + bee system
  public type PredictiveBeeTickResult = {
    predictions : [Float];         // Next step prediction (256)
    confidence : Float;            // Prediction confidence
    kalmanError : Float;           // Current Kalman error
    numActiveBees : Nat;           // Active bee neurons
    swarmCoherence : Float;        // Bee swarm coherence
    consensusDirection : Float;    // Swarm consensus direction
    systemCoherence : Float;       // Overall system coherence
  };
  
  public func predictiveBeeTick(
    system : PredictiveBeeSystem,
    shell3State : [Float],        // Current Shell 3 state (256)
    dt : Float,
    currentBeat : Int
  ) : PredictiveBeeTickResult {
    // 1. Run Kalman predictions
    runPrediction(system.predictiveField, shell3State, currentBeat);
    
    // 2. Get next-step prediction
    let nextPrediction = getPredictionAtStep(system.predictiveField, 1);
    let confidence = system.predictiveField.confidenceCurve[1];
    
    // 3. Compute prediction error
    let error = computePredictionError(system.predictiveField, shell3State, 0);
    
    // 4. Run sparse GABA gating on bee swarm
    // Input to bees = prediction * influence + shell3 state
    let beeInputs = Array.tabulate<Float>(256, func(i : Nat) : Float {
      let pred = if (i < nextPrediction.size()) { nextPrediction[i] } else { 0.0 };
      let state = if (i < shell3State.size()) { shell3State[i] } else { 0.0 };
      pred * system.predictionInfluence + state * (1.0 - system.predictionInfluence)
    });
    
    let numActive = sparseGABAGating(system.beeSwarm, beeInputs, GABA_THRESHOLD);
    
    // 5. Compute swarm consensus
    let updatedSwarm = computeSwarmConsensus(system.beeSwarm);
    
    // 6. Apply waggle compression to active bees
    for (i in Iter.range(0, system.beeSwarm.neurons.size() - 1)) {
      if (system.beeSwarm.neurons[i].isActive) {
        system.beeSwarm.neurons[i] := waggleCompression(
          system.beeSwarm.neurons[i],
          updatedSwarm.consensusDirection,
          updatedSwarm.consensusDistance,
          WAGGLE_COMPRESSION,
          dt
        );
      };
    };
    
    // 7. System coherence = f(prediction confidence, swarm coherence)
    let sysCoherence = confidence * 0.5 + updatedSwarm.swarmCoherence * 0.5;
    
    {
      predictions = nextPrediction;
      confidence = confidence;
      kalmanError = error;
      numActiveBees = numActive;
      swarmCoherence = updatedSwarm.swarmCoherence;
      consensusDirection = updatedSwarm.consensusDirection;
      systemCoherence = sysCoherence;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 25)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 15)) {
      guess := (guess + x / guess) / 2.0;
    };
    guess
  };
  
  func sin(x : Float) : Float {
    var result = x;
    var term = x;
    for (n in Iter.range(1, 12)) {
      term := -term * x * x / Float.fromInt((2 * n) * (2 * n + 1));
      result += term;
    };
    result
  };
  
  func cos(x : Float) : Float {
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 12)) {
      term := -term * x * x / Float.fromInt((2 * n - 1) * (2 * n));
      result += term;
    };
    result
  };
  
  func atan2(y : Float, x : Float) : Float {
    if (x > 0.0) {
      atan(y / x)
    } else if (x < 0.0 and y >= 0.0) {
      atan(y / x) + PI
    } else if (x < 0.0 and y < 0.0) {
      atan(y / x) - PI
    } else if (x == 0.0 and y > 0.0) {
      PI / 2.0
    } else if (x == 0.0 and y < 0.0) {
      -PI / 2.0
    } else {
      0.0
    }
  };
  
  func atan(x : Float) : Float {
    var result : Float = 0.0;
    var term = x;
    for (n in Iter.range(0, 20)) {
      let sign : Float = if (n % 2 == 0) { 1.0 } else { -1.0 };
      result += sign * term / Float.fromInt(2 * n + 1);
      term *= x * x;
    };
    result
  };
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };
  
  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p >= TWO_PI) { p -= TWO_PI };
    while (p < 0.0) { p += TWO_PI };
    p
  };

}
