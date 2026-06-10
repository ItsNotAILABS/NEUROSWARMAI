// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  NOVA INTELLIGENCE ENGINE — COMPLETE BRAIN SUBSTRATE                                                      ║
// ║  Integrates All 7 Pillars into Unified Intelligence System                                               ║
// ║  Build №47 — Production-Ready Intelligence Core                                                           ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";

// Import Intelligence Pillars
import NovaComputing "../../intelligence_core/computing/core";
import NovaEmergence "../../intelligence_core/emergence/kuramoto";
import NovaAdaptation "../../intelligence_core/adaptation/antifragility";

module NovaIntelligenceEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // NOVA BRAIN STATE — 98-NODE FIBONACCI SPIRAL
  // ═══════════════════════════════════════════════════════════════════════════════

  public type NovaBrainNode = {
    id : Nat;
    ring : Nat;           // 0-7 (8 rings) + CORE (96) + APEX (97)
    frequency : Float;    // Hz (from sacred frequencies)
    phase : Float;        // [0, 2π) current phase
    activation : Float;   // [0, 1] firing rate
    theta : Float;        // Fibonacci spiral angle (Golden Angle × id)
    phi : Float;          // Elevation angle
    x : Float;            // 3D position
    y : Float;
    z : Float;
  };

  public type NovaBrainState = {
    nodes : [var NovaBrainNode];
    kuramotoR : Float;          // Global coherence [0, 1]
    meanPhase : Float;          // Mean phase angle
    arousalLevel : Float;       // [0, 1000] organism arousal
    driveMode : Text;           // "Execution" | "Exploration" | "Rest" | "Learning"
    qsov : Float;               // Quantum Sovereignty metric [0.75, 1.5]
    omnisActive : Bool;         // PARALLAX ring (111 Hz) + R ≥ 0.95
    beat : Nat;                 // Heartbeat counter (φ⁴ × 127.71ms = 873ms)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BRAIN INITIALIZATION — 98 NODES WITH GOLDEN ANGLE PLACEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialize 98-node brain with Fibonacci spiral geometry
  /// 8 rings × 12 nodes + CORE (96) + APEX (97)
  public func initNovaBrain() : NovaBrainState {
    let nodes = Array.init<NovaBrainNode>(98, {
      id = 0;
      ring = 0;
      frequency = 0.0;
      phase = 0.0;
      activation = 0.5;
      theta = 0.0;
      phi = 0.0;
      x = 0.0;
      y = 0.0;
      z = 0.0;
    });

    // Ring frequencies (sacred frequencies)
    let ringFreqs : [Float] = [
      NovaComputing.FREQ_CHRONO,    // Ring 0: 0.001 Hz
      NovaComputing.FREQ_VERITAS,   // Ring 1: 0.1 Hz
      NovaComputing.FREQ_SCHUMANN,  // Ring 2: 7.83 Hz
      NovaComputing.FREQ_FLUX,      // Ring 3: 12.67 Hz
      NovaComputing.FREQ_GAMMA,     // Ring 4: 40 Hz
      NovaComputing.FREQ_AEGIS,     // Ring 5: 53.6 Hz
      NovaComputing.FREQ_PARALLAX,  // Ring 6: 111 Hz (OMNIS)
      NovaComputing.FREQ_NOVA,      // Ring 7: 432 Hz
    ];

    // Place 96 nodes in 8 rings (12 nodes each)
    var nodeId = 0;
    for (ring in Iter.range(0, 7)) {
      let radius = Float.fromInt(ring + 1) * 10.0; // Radial distance
      let freq = ringFreqs[ring];

      for (n in Iter.range(0, 11)) {
        let theta = Float.fromInt(nodeId) * NovaComputing.GOLDEN_ANGLE_RAD;
        let phi = Float.fromInt(ring) * (NovaComputing.PI / 8.0);

        // Spherical to Cartesian
        let x = radius * Float.sin(phi) * Float.cos(theta);
        let y = radius * Float.sin(phi) * Float.sin(theta);
        let z = radius * Float.cos(phi);

        nodes[nodeId] := {
          id = nodeId;
          ring = ring;
          frequency = freq;
          phase = Float.fromInt(nodeId) * NovaComputing.TWO_PI / 98.0;
          activation = 0.5 + 0.2 * Float.sin(theta);
          theta = theta;
          phi = phi;
          x = x;
          y = y;
          z = z;
        };

        nodeId += 1;
      };
    };

    // CORE node (96) — Central singularity
    nodes[96] := {
      id = 96;
      ring = 8;
      frequency = NovaComputing.FREQ_CHRONO;
      phase = 0.0;
      activation = 0.8;
      theta = 0.0;
      phi = 0.0;
      x = 0.0;
      y = 0.0;
      z = 0.0;
    };

    // APEX node (97) — 528 Hz DNA repair
    nodes[97] := {
      id = 97;
      ring = 9;
      frequency = NovaComputing.FREQ_GENOME;
      phase = 0.0;
      activation = 0.7;
      theta = 0.0;
      phi = NovaComputing.PI;
      x = 0.0;
      y = 0.0;
      z = 100.0;
    };

    {
      nodes = nodes;
      kuramotoR = 0.0;
      meanPhase = 0.0;
      arousalLevel = 500.0;
      driveMode = "Execution";
      qsov = 0.85;
      omnisActive = false;
      beat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BRAIN TICK — ONE HEARTBEAT (873ms)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Run one intelligence heartbeat — updates all nodes via Kuramoto
  public func tickNovaBrain(state : NovaBrainState, dt : Float) : NovaBrainState {
    // Extract phases and frequencies
    let n = state.nodes.size();
    let phases = Array.init<Float>(n, 0.0);
    let frequencies = Array.init<Float>(n, 0.0);

    for (i in Iter.range(0, n - 1)) {
      phases[i] := state.nodes[i].phase;
      frequencies[i] := state.nodes[i].frequency * 0.001; // Convert Hz to rad/ms
    };

    // Kuramoto coupling strength (φ-modulated by coherence)
    let coupling = 0.3 + state.qsov * 0.4;

    // Run Kuramoto step
    NovaEmergence.kuramotoStep(phases, Array.freeze(frequencies), coupling, dt);

    // Update node states
    for (i in Iter.range(0, n - 1)) {
      let node = state.nodes[i];
      let newActivation = 0.5 + 0.5 * Float.sin(phases[i]);

      state.nodes[i] := {
        node with
        phase = phases[i];
        activation = newActivation;
      };
    };

    // Compute global coherence (Kuramoto order parameter)
    let (r, psi) = NovaEmergence.kuramotoOrderParameter(Array.freeze(phases));

    // Check OMNIS condition: R ≥ 0.95 AND 111 Hz ring firing
    let parallaxRing = Array.tabulate<Float>(12, func(i : Nat) : Float {
      state.nodes[60 + i].activation // Ring 6 = nodes 60-71
    });
    var parallaxFiring = false;
    for (act in parallaxRing.vals()) {
      if (act > 0.9) { parallaxFiring := true };
    };
    let omnisActive = r >= NovaComputing.OMNIS_R_THRESHOLD and parallaxFiring;

    // Update QSOV (Quantum Sovereignty) based on coherence
    let newQSOV = NovaComputing.clamp(
      0.75 + r * 0.75, // Maps R=0→0.75, R=1→1.5
      0.75,
      1.5
    );

    {
      state with
      kuramotoR = r;
      meanPhase = psi;
      qsov = newQSOV;
      omnisActive = omnisActive;
      beat = state.beat + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTELLIGENCE QUERIES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Get coherence level [0, 1]
  public func getCoherence(state : NovaBrainState) : Float {
    state.kuramotoR
  };

  /// Get sovereignty metric [0.75, 1.5]
  public func getQSOV(state : NovaBrainState) : Float {
    state.qsov
  };

  /// Check if organism has achieved OMNIS state
  public func isOmnisActive(state : NovaBrainState) : Bool {
    state.omnisActive
  };

  /// Get ring activation (average of 12 nodes in ring)
  public func getRingActivation(state : NovaBrainState, ring : Nat) : Float {
    if (ring >= 8) return 0.0;

    var sum : Float = 0.0;
    let start = ring * 12;
    for (i in Iter.range(start, start + 11)) {
      if (i < state.nodes.size()) {
        sum += state.nodes[i].activation;
      };
    };

    sum / 12.0
  };

  /// Get brain status summary
  public func getBrainStatus(state : NovaBrainState) : Text {
    let coherence = Float.toText(state.kuramotoR);
    let qsov = Float.toText(state.qsov);
    let omnis = if (state.omnisActive) "ACTIVE" else "INACTIVE";
    let beat = Nat.toText(state.beat);

    "NOVA Brain | Beat: " # beat # " | R: " # coherence # " | QSOV: " # qsov # " | OMNIS: " # omnis
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PATTERN GRADUATION — MEDINA ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type Pattern = {
    id : Text;
    signal : [Float];
    repeatCount : Nat;
    coherence : Float;
    graduated : Bool;
  };

  /// Check if pattern should graduate to schema
  /// Requires: repeats ≥ 5 AND coherence ≥ φ⁻¹ (0.618)
  public func shouldGraduate(pattern : Pattern) : Bool {
    pattern.repeatCount >= 5 and pattern.coherence >= NovaComputing.EXCLUSION_THRESHOLD
  };

  /// Compute pattern coherence via autocorrelation
  public func computePatternCoherence(signal : [Float]) : Float {
    if (signal.size() < 2) return 0.0;

    // Simple coherence: variance stability
    var mean : Float = 0.0;
    for (v in signal.vals()) { mean += v };
    mean := mean / Float.fromInt(signal.size());

    var variance : Float = 0.0;
    for (v in signal.vals()) {
      let diff = v - mean;
      variance += diff * diff;
    };
    variance := variance / Float.fromInt(signal.size());

    // Map variance to coherence [0, 1]
    1.0 / (1.0 + variance)
  };

}
