// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — MACHINE LEARNING PILLAR                                                        ║
// ║  Pattern Mining, Kalman Filters, Prediction, Inference                                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Nat "mo:core/Nat";
import Iter "mo:core/Iter";
import NovaComputing "../computing/core";

module NovaML {

  // ═══════════════════════════════════════════════════════════════════════════════
  // KALMAN FILTER — STATE ESTIMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Kalman state: estimate and uncertainty
  public type KalmanState = {
    estimate : Float;
    uncertainty : Float;
  };

  /// Kalman predict step: propagate state forward
  /// x̂⁻ = A × x̂, P⁻ = A × P × A^T + Q
  public func kalmanPredict(state : KalmanState, processNoise : Float) : KalmanState {
    {
      estimate = state.estimate;
      uncertainty = state.uncertainty + processNoise;
    }
  };

  /// Kalman update step: incorporate measurement
  /// K = P⁻/(P⁻ + R), x̂ = x̂⁻ + K(z - x̂⁻), P = (1-K)P⁻
  public func kalmanUpdate(state : KalmanState, measurement : Float, measurementNoise : Float) : KalmanState {
    let totalUncertainty = state.uncertainty + measurementNoise;
    if (totalUncertainty < NovaComputing.EPSILON) return state;

    let gain = state.uncertainty / totalUncertainty;
    let innovation = measurement - state.estimate;

    {
      estimate = state.estimate + gain * innovation;
      uncertainty = (1.0 - gain) * state.uncertainty;
    }
  };

  /// Full Kalman cycle: predict then update
  public func kalmanStep(
    state : KalmanState,
    measurement : Float,
    processNoise : Float,
    measurementNoise : Float
  ) : KalmanState {
    let predicted = kalmanPredict(state, processNoise);
    kalmanUpdate(predicted, measurement, measurementNoise)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXPONENTIAL MOVING AVERAGE — REAL-TIME TRENDS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// EMA update: S_t = α × x_t + (1-α) × S_{t-1}
  public func emaUpdate(previous : Float, newValue : Float, alpha : Float) : Float {
    alpha * newValue + (1.0 - alpha) * previous
  };

  /// EMA alpha from window size: α = 2/(N+1)
  public func emaAlpha(windowSize : Nat) : Float {
    2.0 / (Float.fromInt(windowSize) + 1.0)
  };

  /// Double EMA (trend detection)
  public func doubleEma(ema1 : Float, ema2 : Float) : Float {
    2.0 * ema1 - ema2
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PATTERN MINING — ANOMALY & SEQUENCE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Z-score anomaly detection: |x - μ| / σ
  public func zScore(value : Float, mean : Float, stddev : Float) : Float {
    Float.abs(value - mean) / Float.max(NovaComputing.EPSILON, stddev)
  };

  /// Is anomaly? Z-score exceeds threshold (default: 3σ)
  public func isAnomaly(value : Float, mean : Float, stddev : Float, threshold : Float) : Bool {
    zScore(value, mean, stddev) > threshold
  };

  /// Running mean update (Welford's algorithm)
  public func runningMeanUpdate(currentMean : Float, newValue : Float, count : Nat) : Float {
    currentMean + (newValue - currentMean) / Float.fromInt(count + 1)
  };

  /// Running variance update (Welford's)
  public func runningVarianceUpdate(
    currentM2 : Float,
    currentMean : Float,
    newValue : Float,
    newMean : Float
  ) : Float {
    currentM2 + (newValue - currentMean) * (newValue - newMean)
  };

  /// Cosine similarity between two vectors
  public func cosineSimilarity(a : [Float], b : [Float]) : Float {
    if (a.size() == 0 or b.size() == 0) return 0.0;

    let n = Nat.min(a.size(), b.size());
    var dotProduct : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;

    for (i in Iter.range(0, n - 1)) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };

    let denominator = Float.sqrt(normA) * Float.sqrt(normB);
    if (denominator < NovaComputing.EPSILON) return 0.0;
    dotProduct / denominator
  };

  /// Euclidean distance
  public func euclideanDistance(a : [Float], b : [Float]) : Float {
    if (a.size() == 0 or b.size() == 0) return 0.0;

    let n = Nat.min(a.size(), b.size());
    var sumSq : Float = 0.0;

    for (i in Iter.range(0, n - 1)) {
      let diff = a[i] - b[i];
      sumSq += diff * diff;
    };

    Float.sqrt(sumSq)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDICTION — AUTOREGRESSIVE & DECAY MODELS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Linear prediction: next = slope × t + intercept
  public func linearPredict(slope : Float, intercept : Float, t : Float) : Float {
    slope * t + intercept
  };

  /// Estimate slope from recent values (simple linear regression on last N points)
  public func estimateSlope(values : [Float]) : Float {
    let n = values.size();
    if (n < 2) return 0.0;

    let nf = Float.fromInt(n);
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;

    for (i in Iter.range(0, n - 1)) {
      let x = Float.fromInt(i);
      let y = values[i];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    };

    let denom = nf * sumX2 - sumX * sumX;
    if (Float.abs(denom) < NovaComputing.EPSILON) return 0.0;
    (nf * sumXY - sumX * sumY) / denom
  };

  /// Exponential decay prediction: value × exp(-λ × Δt)
  public func decayPredict(currentValue : Float, decayRate : Float, deltaT : Float) : Float {
    currentValue * Float.exp(-decayRate * deltaT)
  };

  /// Mean reversion prediction: E[x_{t+1}] = μ + θ(x_t - μ)
  /// θ < 1 means reversion, θ > 1 means divergence
  public func meanReversionPredict(current : Float, mean : Float, theta : Float) : Float {
    mean + theta * (current - mean)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REINFORCEMENT LEARNING — POLICY GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Advantage estimation: A = R - V(s)
  public func advantage(reward : Float, valueEstimate : Float) : Float {
    reward - valueEstimate
  };

  /// TD(0) value update: V(s) ← V(s) + α[r + γV(s') - V(s)]
  public func tdUpdate(
    value : Float,
    reward : Float,
    nextValue : Float,
    learningRate : Float,
    discount : Float
  ) : Float {
    value + learningRate * (reward + discount * nextValue - value)
  };

  /// Epsilon-greedy action selection probability
  /// Returns probability of selecting the greedy action
  public func epsilonGreedyProb(epsilon : Float, numActions : Nat, isGreedy : Bool) : Float {
    if (isGreedy) {
      1.0 - epsilon + epsilon / Float.fromInt(numActions)
    } else {
      epsilon / Float.fromInt(numActions)
    }
  };

  /// Softmax policy: P(a) = exp(Q(a)/τ) / Σ exp(Q(a')/τ)
  public func softmaxPolicy(qValues : [Float], temperature : Float) : [Float] {
    if (qValues.size() == 0) return [];

    let scaled = Array.tabulate<Float>(qValues.size(), func(i) {
      qValues[i] / Float.max(NovaComputing.EPSILON, temperature)
    });

    NovaComputing.softmax(scaled)
  };

  /// Reward shaping: φ-scaled temporal discount
  /// Reward at step t is discounted by φ⁻ᵗ (golden decay)
  public func phiDiscountedReward(reward : Float, stepsFromNow : Nat) : Float {
    reward * Float.pow(NovaComputing.PHI_INV_1, Float.fromInt(stepsFromNow))
  };

}
