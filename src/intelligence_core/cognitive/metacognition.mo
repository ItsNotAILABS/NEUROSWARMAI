// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — COGNITIVE PILLAR                                                                ║
// ║  Attention, Working Memory, Meta-Cognition, World Models                                                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import NovaComputing "../computing/core";

module NovaCognitive {

  // ═══════════════════════════════════════════════════════════════════════════════
  // ATTENTION MECHANISMS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Scaled dot-product attention score: softmax(QK^T / √d)
  /// Returns attention weights for a single query against all keys
  public func attentionScores(query : [Float], keys : [[Float]]) : [Float] {
    let d = query.size();
    if (d == 0 or keys.size() == 0) return [];

    let scale = Float.sqrt(Float.fromInt(d));
    let scores = Array.tabulate<Float>(keys.size(), func(i) {
      var dot : Float = 0.0;
      let k = keys[i];
      for (j in Iter.range(0, d - 1)) {
        if (j < k.size()) {
          dot += query[j] * k[j];
        };
      };
      dot / scale
    });

    NovaComputing.softmax(scores)
  };

  /// Apply attention weights to values: Σ αᵢ × vᵢ
  public func attentionApply(weights : [Float], values : [[Float]]) : [Float] {
    if (weights.size() == 0 or values.size() == 0) return [];

    let dim = values[0].size();
    Array.tabulate<Float>(dim, func(d) {
      var sum : Float = 0.0;
      for (i in Iter.range(0, weights.size() - 1)) {
        if (i < values.size() and d < values[i].size()) {
          sum += weights[i] * values[i][d];
        };
      };
      sum
    })
  };

  /// Competitive attention: winner-take-all with soft inhibition
  public func competitiveAttention(salience : [Float], inhibitionStrength : Float) : [Float] {
    if (salience.size() == 0) return [];

    // Find maximum
    var maxVal : Float = salience[0];
    for (s in salience.vals()) { if (s > maxVal) maxVal := s };

    // Soft WTA: suppress non-winners
    let enhanced = Array.tabulate<Float>(salience.size(), func(i) {
      let diff = salience[i] - maxVal;
      Float.exp(inhibitionStrength * diff)
    });

    // Normalize
    var sum : Float = 0.0;
    for (e in enhanced.vals()) { sum += e };
    if (sum < NovaComputing.EPSILON) return salience;

    Array.tabulate<Float>(enhanced.size(), func(i) { enhanced[i] / sum })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKING MEMORY — CAPACITY-LIMITED BUFFER
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Working memory slot decay: items decay without rehearsal
  /// Strength(t+dt) = strength × exp(-dt/τ)
  public func memoryDecay(strength : Float, tau : Float, dt : Float) : Float {
    strength * Float.exp(-dt / tau)
  };

  /// Rehearsal: refresh item strength back toward 1.0
  public func rehearse(strength : Float, rehearsalGain : Float) : Float {
    NovaComputing.clamp(strength + rehearsalGain * (1.0 - strength), 0.0, 1.0)
  };

  /// Interference: new items reduce strength of similar items
  /// Reduction ∝ similarity between new and existing items
  public func interferenceReduction(existingStrength : Float, similarity : Float, interferenceRate : Float) : Float {
    Float.max(0.0, existingStrength - interferenceRate * similarity)
  };

  /// Miller's Law capacity: 7 ± 2 chunks
  /// Returns whether buffer is at capacity
  public func atCapacity(itemCount : Nat, capacity : Nat) : Bool {
    itemCount >= capacity
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // META-COGNITION — THINKING ABOUT THINKING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Confidence estimation: how certain is the system?
  /// Based on evidence accumulation (drift-diffusion model)
  public func confidenceFromEvidence(evidence : Float, threshold : Float) : Float {
    NovaComputing.clamp(Float.abs(evidence) / threshold, 0.0, 1.0)
  };

  /// Uncertainty quantification: entropy of belief distribution
  /// H = -Σ p_i log(p_i)
  public func beliefEntropy(beliefs : [Float]) : Float {
    var entropy : Float = 0.0;
    for (p in beliefs.vals()) {
      if (p > NovaComputing.EPSILON) {
        entropy -= p * Float.log(p);
      };
    };
    entropy
  };

  /// Error monitoring: detect prediction errors
  /// Surprise = -log(P(observed))
  public func surprise(observedProbability : Float) : Float {
    -Float.log(Float.max(NovaComputing.EPSILON, observedProbability))
  };

  /// Cognitive load estimation: processing demand vs capacity
  public func cognitiveLoad(demandVector : [Float], capacityVector : [Float]) : Float {
    if (demandVector.size() == 0 or capacityVector.size() != demandVector.size()) return 0.0;

    var totalDemand : Float = 0.0;
    var totalCapacity : Float = 0.0;

    for (i in Iter.range(0, demandVector.size() - 1)) {
      totalDemand += demandVector[i];
      totalCapacity += capacityVector[i];
    };

    NovaComputing.clamp(totalDemand / Float.max(NovaComputing.EPSILON, totalCapacity), 0.0, 1.0)
  };

  /// Strategy selection: choose approach based on difficulty
  /// Returns index of best strategy given current load
  public func selectStrategy(strategyEfficiencies : [Float], currentLoad : Float) : Nat {
    if (strategyEfficiencies.size() == 0) return 0;

    var bestIdx : Nat = 0;
    var bestScore : Float = -1.0;

    for (i in Iter.range(0, strategyEfficiencies.size() - 1)) {
      // Under high load, prefer efficient strategies
      let score = strategyEfficiencies[i] * (1.0 - currentLoad * 0.5);
      if (score > bestScore) {
        bestScore := score;
        bestIdx := i;
      };
    };

    bestIdx
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORLD MODEL — PREDICTIVE PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Prediction error: difference between expected and observed
  public func predictionError(predicted : [Float], observed : [Float]) : [Float] {
    let n = Nat.min(predicted.size(), observed.size());
    Array.tabulate<Float>(n, func(i) { observed[i] - predicted[i] })
  };

  /// Model update: adjust beliefs based on prediction error
  /// Precision-weighted update: Δbelief = precision × error
  public func bayesianUpdate(belief : [Float], error : [Float], precision : [Float]) : [Float] {
    let n = Nat.min(Nat.min(belief.size(), error.size()), precision.size());
    Array.tabulate<Float>(n, func(i) {
      belief[i] + precision[i] * error[i]
    })
  };

  /// Free energy: F = complexity - accuracy
  /// Lower is better (minimize free energy ≈ maximize model fit)
  public func freeEnergy(predictionErrors : [Float], modelComplexity : Float) : Float {
    var accuracy : Float = 0.0;
    for (e in predictionErrors.vals()) {
      accuracy += e * e;
    };
    accuracy / 2.0 + modelComplexity
  };

  /// Evidence accumulation (drift-diffusion)
  /// dx = drift × dt + noise
  public func evidenceAccumulation(
    current : Float,
    drift : Float,
    noise : Float,
    dt : Float
  ) : Float {
    current + drift * dt + noise * Float.sqrt(dt)
  };

  /// Decision threshold reached?
  public func decisionReached(evidence : Float, upperBound : Float, lowerBound : Float) : ?Bool {
    if (evidence >= upperBound) { ?true }
    else if (evidence <= lowerBound) { ?false }
    else { null }
  };

}
