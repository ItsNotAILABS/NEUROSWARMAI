// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — ADAPTATION PILLAR                                                               ║
// ║  Antifragility, Learning, Attractor Dynamics, Lyapunov Stability                                         ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import NovaComputing "../computing/core";

module NovaAdaptation {

  // ═══════════════════════════════════════════════════════════════════════════════
  // ANTIFRAGILITY — STRESS RESPONSE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Hormesis function: benefit from moderate stress
  /// Response = 1 + gain × stress × exp(-stress/threshold)
  public func hormesisResponse(stress : Float, gain : Float, threshold : Float) : Float {
    1.0 + gain * stress * Float.exp(-stress / threshold)
  };

  /// Adaptive capacity increase from challenge
  /// New capacity = old × (1 + α × (challenge - capacity))
  public func adaptiveGrowth(currentCapacity : Float, challenge : Float, learningRate : Float) : Float {
    currentCapacity * (1.0 + learningRate * (challenge - currentCapacity))
  };

  /// Immune system memory formation
  /// Antibody level increases with pathogen exposure
  public func immuneMemory(
    currentLevel : Float,
    pathogenLoad : Float,
    responseRate : Float,
    decayRate : Float,
    dt : Float
  ) : Float {
    let production = responseRate * pathogenLoad;
    let decay = decayRate * currentLevel;
    currentLevel + (production - decay) * dt
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LEARNING DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Hebbian learning: Δw = η × x × y
  /// "Neurons that fire together wire together"
  public func hebbianUpdate(weight : Float, presynaptic : Float, postsynaptic : Float, learningRate : Float) : Float {
    weight + learningRate * presynaptic * postsynaptic
  };

  /// Spike-timing-dependent plasticity (STDP)
  /// Δw ∝ exp(-Δt/τ) where Δt is spike time difference
  public func stdpUpdate(weight : Float, timeDiff : Float, tau : Float, maxChange : Float) : Float {
    let change = maxChange * Float.exp(-Float.abs(timeDiff) / tau);
    if (timeDiff > 0.0) {
      weight + change // Potentiation (pre before post)
    } else {
      weight - change // Depression (post before pre)
    }
  };

  /// Error-driven learning (delta rule)
  /// Δw = η × error × input
  public func deltaRuleUpdate(weight : Float, error : Float, input : Float, learningRate : Float) : Float {
    weight + learningRate * error * input
  };

  /// Reinforcement learning: Q-learning update
  /// Q(s,a) ← Q(s,a) + α[r + γ max Q(s',a') - Q(s,a)]
  public func qLearningUpdate(
    currentQ : Float,
    reward : Float,
    maxNextQ : Float,
    learningRate : Float,
    discount : Float
  ) : Float {
    currentQ + learningRate * (reward + discount * maxNextQ - currentQ)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ATTRACTOR DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Energy landscape: E = -Σᵢⱼ wᵢⱼsᵢsⱼ (Hopfield network)
  public func hopfieldEnergy(states : [Float], weights : [[Float]]) : Float {
    let n = states.size();
    var energy : Float = 0.0;

    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j and i < weights.size() and j < weights[i].size()) {
          energy -= weights[i][j] * states[i] * states[j];
        };
      };
    };

    energy / 2.0
  };

  /// Basin of attraction: distance to attractor
  public func attractorDistance(state : [Float], attractor : [Float]) : Float {
    if (state.size() != attractor.size()) return 0.0;

    var sumSquares : Float = 0.0;
    for (i in Iter.range(0, state.size() - 1)) {
      let diff = state[i] - attractor[i];
      sumSquares += diff * diff;
    };

    Float.sqrt(sumSquares)
  };

  /// Gradient descent toward attractor
  public func gradientDescent(
    state : [Float],
    gradient : [Float],
    stepSize : Float
  ) : [Float] {
    if (state.size() != gradient.size()) return state;

    Array.tabulate<Float>(state.size(), func(i) {
      state[i] - stepSize * gradient[i]
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LYAPUNOV STABILITY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Lyapunov function: V(x) = x^T P x (quadratic form)
  public func lyapunovFunction(state : [Float], matrix : [[Float]]) : Float {
    let n = state.size();
    var result : Float = 0.0;

    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      if (i < matrix.size()) {
        for (j in Iter.range(0, n - 1)) {
          if (j < matrix[i].size()) {
            sum += matrix[i][j] * state[j];
          };
        };
      };
      result += state[i] * sum;
    };

    result
  };

  /// Lyapunov exponent: λ = lim (1/t) log(||δx(t)||/||δx(0)||)
  public func lyapunovExponent(trajectory : [Float], dt : Float) : Float {
    if (trajectory.size() < 2) return 0.0;

    var sum : Float = 0.0;
    for (i in Iter.range(0, trajectory.size() - 2)) {
      let derivative = Float.abs((trajectory[i + 1] - trajectory[i]) / dt);
      if (derivative > NovaComputing.EPSILON) {
        sum += Float.log(derivative);
      };
    };

    sum / (Float.fromInt(trajectory.size() - 1) * dt)
  };

  /// Stability check: negative Lyapunov exponent = stable
  public func isStable(exponent : Float) : Bool {
    exponent < 0.0
  };

  /// Chaos detection: positive Lyapunov exponent = chaotic
  public func isChaotic(exponent : Float) : Bool {
    exponent > 0.0
  };

}
