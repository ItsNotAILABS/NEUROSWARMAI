// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — COMPUTING PILLAR                                                                ║
// ║  Core Mathematical Foundations — φ, π, e, and Sacred Geometry                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";

module NovaComputing {

  // ═══════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS — 19 DECIMAL PLACES PRECISION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// φ (Golden Ratio) — The universal coupling constant
  /// Used in ALL inter-layer ratios, node placement, frequency ladders
  public let PHI : Float = 1.6180339887498948482;

  /// π (Pi) — Circle constant
  public let PI : Float = 3.1415926535897932385;
  public let TWO_PI : Float = 6.2831853071795864769;
  public let HALF_PI : Float = 1.5707963267948966192;

  /// e (Euler's Number) — Natural exponential base
  public let E : Float = 2.7182818284590452354;

  /// Feigenbaum δ — Bifurcation constant (chaos theory)
  public let FEIGENBAUM_DELTA : Float = 4.6692016091029906719;

  /// Ising 2D critical exponent β
  public let ISING_BETA : Float = 0.125;

  /// Percolation threshold p_c
  public let PERCOLATION_PC : Float = 0.5927;

  /// Golden Angle — 360°/φ² = 137.5077640500378° (used in brain node placement)
  public let GOLDEN_ANGLE_DEG : Float = 137.5077640500378;
  public let GOLDEN_ANGLE_RAD : Float = 2.3999632297286533;

  /// Schumann Resonance — Earth's fundamental EM frequency
  public let SCHUMANN_HZ : Float = 7.83;
  public let SCHUMANN_PERIOD_MS : Float = 127.71;

  /// Organism Heartbeat — φ⁴ × Schumann Period = 874.74ms = 68.6 bpm
  public let HEARTBEAT_MS : Float = 874.74;
  public let HEARTBEAT_BPM : Float = 68.6;

  /// Exclusion Law Threshold — Minimum coherence for signal propagation
  public let EXCLUSION_THRESHOLD : Float = 0.618033988749895; // φ⁻¹

  /// OMNIS Condition Threshold — Global R for King's Chamber state
  public let OMNIS_R_THRESHOLD : Float = 0.95;
  public let OMNIS_FREQUENCY_HZ : Float = 111.0; // PARALLAX ring

  /// Machine Epsilon
  public let EPSILON : Float = 0.0001;

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHI POWERS (for inter-layer coupling)
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI_0 : Float = 1.0;
  public let PHI_1 : Float = 1.618033988749895;
  public let PHI_2 : Float = 2.618033988749895;
  public let PHI_3 : Float = 4.236067977499790;
  public let PHI_4 : Float = 6.854101966249685;
  public let PHI_5 : Float = 11.09016994374948;
  public let PHI_6 : Float = 17.94427190999916;
  public let PHI_7 : Float = 29.03444185374863;
  public let PHI_8 : Float = 46.97871376374779;

  /// Inverse PHI powers (coupling decay)
  public let PHI_INV_1 : Float = 0.618033988749895;
  public let PHI_INV_2 : Float = 0.381966011250105;
  public let PHI_INV_3 : Float = 0.236067977499790;
  public let PHI_INV_4 : Float = 0.145898033750316;
  public let PHI_INV_5 : Float = 0.090169943749474;
  public let PHI_INV_6 : Float = 0.055728090000841;
  public let PHI_INV_7 : Float = 0.034441853748633;
  public let PHI_INV_8 : Float = 0.021286236252209;

  // ═══════════════════════════════════════════════════════════════════════════════
  // FIBONACCI SEQUENCE
  // ═══════════════════════════════════════════════════════════════════════════════

  public let FIBONACCI : [Nat] = [
    1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765
  ];

  /// Get Fibonacci number at index n
  public func fibonacci(n : Nat) : Nat {
    if (n < FIBONACCI.size()) {
      return FIBONACCI[n];
    };
    // Generate for larger n
    var a : Nat = FIBONACCI[FIBONACCI.size() - 2];
    var b : Nat = FIBONACCI[FIBONACCI.size() - 1];
    var i : Nat = FIBONACCI.size();
    while (i <= n) {
      let next = a + b;
      a := b;
      b := next;
      i += 1;
    };
    b
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRED FREQUENCIES (Hz)
  // ═══════════════════════════════════════════════════════════════════════════════

  public let FREQ_CHRONO : Float = 0.001;      // Earth free oscillation
  public let FREQ_VERITAS : Float = 0.1;       // HRV coherence
  public let FREQ_SCHUMANN : Float = 7.83;     // Planetary field lock
  public let FREQ_FLUX : Float = 12.67;        // φ¹ × 7.83
  public let FREQ_RESONEX : Float = 20.5;      // φ² × 7.83
  public let FREQ_QMEM : Float = 33.1;         // φ³ × 7.83
  public let FREQ_GAMMA : Float = 40.0;        // Conscious binding
  public let FREQ_AEGIS : Float = 53.6;        // φ⁴ × 7.83 (threat detection)
  public let FREQ_ENTANGLA : Float = 86.7;     // φ⁵ × 7.83
  public let FREQ_PARALLAX : Float = 111.0;    // Hemisphere shift (OMNIS)
  public let FREQ_MERIDIAN : Float = 179.6;    // φ¹ × 111
  public let FREQ_NOVA : Float = 432.0;        // Acoustic anchor
  public let FREQ_GENOME : Float = 528.0;      // DNA repair

  // ═══════════════════════════════════════════════════════════════════════════════
  // ADVANCED MATH FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sigmoid activation: σ(x) = 1 / (1 + e^(-x))
  public func sigmoid(x : Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  /// Hyperbolic tangent: tanh(x) = (e^x - e^(-x)) / (e^x + e^(-x))
  public func tanh(x : Float) : Float {
    let ex = Float.exp(x);
    let enx = Float.exp(-x);
    (ex - enx) / (ex + enx)
  };

  /// ReLU activation: max(0, x)
  public func relu(x : Float) : Float {
    Float.max(0.0, x)
  };

  /// Leaky ReLU: max(αx, x) where α = 0.01
  public func leakyRelu(x : Float) : Float {
    if (x > 0.0) x else 0.01 * x
  };

  /// Gaussian: exp(-x²/2)
  public func gaussian(x : Float) : Float {
    Float.exp(-(x * x) / 2.0)
  };

  /// Normal distribution PDF
  public func normalPDF(x : Float, mu : Float, sigma : Float) : Float {
    let z = (x - mu) / sigma;
    (1.0 / (sigma * Float.sqrt(TWO_PI))) * Float.exp(-(z * z) / 2.0)
  };

  /// Softmax for probability distribution
  public func softmax(values : [Float]) : [Float] {
    if (values.size() == 0) return [];

    // Find max for numerical stability
    var max_val : Float = values[0];
    for (v in values.vals()) {
      if (v > max_val) max_val := v;
    };

    // Compute exp(x - max)
    let exps = Array.init<Float>(values.size(), 0.0);
    var sum : Float = 0.0;
    for (i in Iter.range(0, values.size() - 1)) {
      let e = Float.exp(values[i] - max_val);
      exps[i] := e;
      sum += e;
    };

    // Normalize
    Array.tabulate<Float>(values.size(), func(i) {
      exps[i] / sum
    })
  };

  /// Clamp value to range [min, max]
  public func clamp(value : Float, min : Float, max : Float) : Float {
    Float.max(min, Float.min(max, value))
  };

  /// Linear interpolation: lerp(a, b, t) = a + t(b - a)
  public func lerp(a : Float, b : Float, t : Float) : Float {
    a + t * (b - a)
  };

  /// Map value from one range to another
  public func mapRange(value : Float, inMin : Float, inMax : Float, outMin : Float, outMax : Float) : Float {
    let t = (value - inMin) / (inMax - inMin);
    lerp(outMin, outMax, t)
  };

  /// Wrap angle to [0, 2π)
  public func wrapAngle(angle : Float) : Float {
    var a = angle;
    while (a < 0.0) { a += TWO_PI };
    while (a >= TWO_PI) { a -= TWO_PI };
    a
  };

  /// Angle difference (shortest path)
  public func angleDiff(a : Float, b : Float) : Float {
    let diff = wrapAngle(b - a);
    if (diff > PI) { diff - TWO_PI } else { diff }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LYAPUNOV STABILITY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Compute Lyapunov exponent estimate
  /// λ = (1/N) Σ log(|f'(x_i)|)
  public func lyapunovExponent(trajectory : [Float], epsilon : Float) : Float {
    if (trajectory.size() < 2) return 0.0;

    var sum : Float = 0.0;
    for (i in Iter.range(0, trajectory.size() - 2)) {
      let derivative = Float.abs((trajectory[i + 1] - trajectory[i]) / epsilon);
      if (derivative > EPSILON) {
        sum += Float.log(derivative);
      };
    };

    sum / Float.fromInt(trajectory.size() - 1)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRED GEOMETRY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Golden spiral point at angle θ
  public func goldenSpiralPoint(theta : Float) : (Float, Float) {
    let r = Float.pow(PHI, theta / (PI / 2.0));
    (r * Float.cos(theta), r * Float.sin(theta))
  };

  /// Fibonacci spiral lattice point (sunflower seed pattern)
  public func fibonacciLatticePoint(index : Nat, total : Nat) : (Float, Float) {
    let n = Float.fromInt(index);
    let theta = n * GOLDEN_ANGLE_RAD;
    let r = Float.sqrt(n / Float.fromInt(total));
    (r * Float.cos(theta), r * Float.sin(theta))
  };

  /// Platonic solid vertices count
  public func platonicVertices(solid : Text) : Nat {
    switch (solid) {
      case "tetrahedron" { 4 };
      case "cube" { 8 };
      case "octahedron" { 6 };
      case "dodecahedron" { 20 };
      case "icosahedron" { 12 };
      case _ { 0 };
    }
  };

}
