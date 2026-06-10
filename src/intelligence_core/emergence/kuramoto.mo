// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE CORE — EMERGENCE PILLAR                                                                ║
// ║  Kuramoto Synchronization, Phase Transitions, Self-Organization                                          ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import NovaComputing "../computing/core";

module NovaEmergence {

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO MODEL — UNIVERSAL SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Kuramoto order parameter: R·e^(iΨ) = (1/N) Σⱼ e^(iθⱼ)
  /// Returns (R, Ψ) where R ∈ [0,1] is coherence, Ψ is mean phase
  public func kuramotoOrderParameter(phases : [Float]) : (Float, Float) {
    let n = phases.size();
    if (n == 0) return (0.0, 0.0);

    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;

    for (theta in phases.vals()) {
      sumCos += Float.cos(theta);
      sumSin += Float.sin(theta);
    };

    let meanCos = sumCos / Float.fromInt(n);
    let meanSin = sumSin / Float.fromInt(n);

    let r = Float.sqrt(meanCos * meanCos + meanSin * meanSin);
    let psi = Float.arctan2(meanSin, meanCos);

    (r, psi)
  };

  /// Kuramoto phase update: dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  public func kuramotoStep(
    phases : [var Float],
    frequencies : [Float],
    coupling : Float,
    dt : Float
  ) : () {
    let n = phases.size();
    if (n == 0 or frequencies.size() != n) return;

    let deltas = Array.init<Float>(n, 0.0);

    for (i in Iter.range(0, n - 1)) {
      var sumSin : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        sumSin += Float.sin(phases[j] - phases[i]);
      };
      let couplingTerm = (coupling / Float.fromInt(n)) * sumSin;
      deltas[i] := frequencies[i] + couplingTerm;
    };

    for (i in Iter.range(0, n - 1)) {
      phases[i] := NovaComputing.wrapAngle(phases[i] + deltas[i] * dt);
    };
  };

  /// Check if system has reached synchronization threshold
  public func isSynchronized(phases : [Float], threshold : Float) : Bool {
    let (r, _) = kuramotoOrderParameter(phases);
    r >= threshold
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHASE TRANSITIONS — LANDAU THEORY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Landau free energy: F(m) = a(T-T_c)m² + bm⁴
  /// Order parameter m, temperature T, critical temp T_c
  public func landauFreeEnergy(m : Float, t : Float, tc : Float, a : Float, b : Float) : Float {
    a * (t - tc) * m * m + b * Float.pow(m, 4.0)
  };

  /// Ising model magnetization (mean-field approximation)
  /// m = tanh(βJzm + βh) where β=1/T, J=coupling, z=neighbors, h=field
  public func isingMagnetization(
    prevM : Float,
    temperature : Float,
    coupling : Float,
    neighbors : Nat,
    field : Float
  ) : Float {
    let beta = 1.0 / Float.max(NovaComputing.EPSILON, temperature);
    let z = Float.fromInt(neighbors);
    let arg = beta * coupling * z * prevM + beta * field;
    NovaComputing.tanh(arg)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SWARM COHERENCE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Swarm alignment: average direction vector
  public func swarmAlignment(velocities : [(Float, Float)]) : (Float, Float) {
    if (velocities.size() == 0) return (0.0, 0.0);

    var sumVx : Float = 0.0;
    var sumVy : Float = 0.0;

    for ((vx, vy) in velocities.vals()) {
      sumVx += vx;
      sumVy += vy;
    };

    let n = Float.fromInt(velocities.size());
    (sumVx / n, sumVy / n)
  };

  /// Swarm cohesion: center of mass
  public func swarmCohesion(positions : [(Float, Float)]) : (Float, Float) {
    if (positions.size() == 0) return (0.0, 0.0);

    var sumX : Float = 0.0;
    var sumY : Float = 0.0;

    for ((x, y) in positions.vals()) {
      sumX += x;
      sumY += y;
    };

    let n = Float.fromInt(positions.size());
    (sumX / n, sumY / n)
  };

  /// Swarm separation: average distance from neighbors
  public func swarmSeparation(positions : [(Float, Float)], index : Nat, radius : Float) : (Float, Float) {
    if (index >= positions.size()) return (0.0, 0.0);

    let (x0, y0) = positions[index];
    var sumDx : Float = 0.0;
    var sumDy : Float = 0.0;
    var count : Nat = 0;

    for (i in Iter.range(0, positions.size() - 1)) {
      if (i != index) {
        let (xi, yi) = positions[i];
        let dx = x0 - xi;
        let dy = y0 - yi;
        let dist = Float.sqrt(dx * dx + dy * dy);

        if (dist < radius and dist > NovaComputing.EPSILON) {
          sumDx += dx / dist;
          sumDy += dy / dist;
          count += 1;
        };
      };
    };

    if (count == 0) return (0.0, 0.0);
    let n = Float.fromInt(count);
    (sumDx / n, sumDy / n)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SELF-ORGANIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quorum sensing: collective decision threshold
  public func quorumSensing(signals : [Float], threshold : Float) : Bool {
    if (signals.size() == 0) return false;

    var sum : Float = 0.0;
    for (s in signals.vals()) { sum += s };

    (sum / Float.fromInt(signals.size())) >= threshold
  };

  /// Pattern formation: Turing instability wavelength
  /// λ = 2π√(D_u/D_v) where D_u, D_v are diffusion coefficients
  public func turingWavelength(diffusionU : Float, diffusionV : Float) : Float {
    NovaComputing.TWO_PI * Float.sqrt(diffusionU / Float.max(NovaComputing.EPSILON, diffusionV))
  };

  /// Lorenz attractor step (chaotic dynamics)
  /// dx/dt = σ(y - x)
  /// dy/dt = x(ρ - z) - y
  /// dz/dt = xy - βz
  public func lorenzStep(
    x : Float,
    y : Float,
    z : Float,
    sigma : Float,
    rho : Float,
    beta : Float,
    dt : Float
  ) : (Float, Float, Float) {
    let dx = sigma * (y - x) * dt;
    let dy = (x * (rho - z) - y) * dt;
    let dz = (x * y - beta * z) * dt;

    (x + dx, y + dy, z + dz)
  };

}
