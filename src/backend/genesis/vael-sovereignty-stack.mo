// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  CONFIDENTIAL AND PROPRIETARY. Framework: Medina Doctrine                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// VAEL SOVEREIGNTY STACK — Phase C Exterior Attack + Defense Infrastructure
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Implements the full exterior sovereignty chain:
//
//   1. DURA Outward Projection — 6-axis helix projects outward from the organism's boundary,
//      creating a spherical coverage field that scans for threats in all directions.
//      Coverage = (1 - cos(axis_angle))^2 product across all 6 axes.
//
//   2. RIFT Source Attribution + Permanent Penalty — when a threat is detected, RIFT attributes
//      the source and applies a compounding permanent penalty to that source's trust score.
//      penalty(t+1) = penalty(t) × RIFT_COMPOUND_RATE
//
//   3. PARALLAX Phase Sovereignty — rotating phase field φ = beat × ω_parallax makes
//      the organism's output non-replicable. Each output is phase-shifted by φ,
//      so captured outputs are immediately stale.
//
//   4. VERITAS Adversary Scoring — tracks adversary behavior patterns and computes
//      a threat score per adversary: score = frequency × recency × severity.
//      Adversaries above VERITAS_THREAT_FLOOR are flagged for active defense.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Option "mo:core/Option";

module VAELSovereigntyStack {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;

  // DURA 6-axis outward rates (radians per beat)
  public let DURA_AXIS1_RATE : Float = 0.031415;
  public let DURA_AXIS2_RATE : Float = 0.017453;
  public let DURA_AXIS3_RATE : Float = 0.024544;
  public let DURA_AXIS4_RATE : Float = 0.012271;
  public let DURA_AXIS5_RATE : Float = 0.043633;
  public let DURA_AXIS6_RATE : Float = 0.008727;
  public let DURA_OUTWARD_PROJECTION_STRENGTH : Float = 0.85;  // 0-1 outward reach

  // RIFT source attribution
  public let RIFT_COMPOUND_RATE : Float = 1.15;       // Penalty compounds at 15% per incident
  public let RIFT_INITIAL_PENALTY : Float = 0.1;      // First attribution penalty
  public let RIFT_MAX_PENALTY : Float = 10.0;         // Penalty floor (trust → 0)
  public let MAX_RIFT_SOURCES : Nat = 128;            // Max tracked threat sources

  // PARALLAX rotating field
  public let PARALLAX_OMEGA : Float = 0.19635;        // Phase rotation rate (radians/beat ≈ π/16)
  public let PARALLAX_AMPLITUDE : Float = 1.0;        // Phase amplitude

  // VERITAS adversary scoring
  public let VERITAS_RECENCY_DECAY : Float = 0.97;    // Per-beat decay on threat recency
  public let VERITAS_THREAT_FLOOR : Float = 0.5;      // Score above this = actively dangerous
  public let VERITAS_HIGH_THREAT : Float = 0.85;      // Score above this = immediate action
  public let MAX_ADVERSARIES : Nat = 64;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// DURA 6-axis helix state
  public type DURAState = {
    var axis1 : Float; var axis2 : Float; var axis3 : Float;
    var axis4 : Float; var axis5 : Float; var axis6 : Float;
    var coverageField : Float;     // Combined outward coverage [0,1]
    var outwardProjection : Float; // Strength of outward reach
  };

  /// RIFT source attribution entry
  public type RIFTSource = {
    var sourceId : Text;
    var attributions : Nat;          // How many times attributed
    var cumulativePenalty : Float;   // Compounding penalty score
    var firstSeen : Nat;
    var lastSeen : Nat;
    var isPermanentlyPenalized : Bool;
  };

  /// PARALLAX rotating field state
  public type PARALLAXState = {
    var phase : Float;               // Current phase φ
    var rotationsCompleted : Nat;
    var outputSignature : Float;     // Current phase-shifted output marker
  };

  /// VERITAS adversary entry
  public type VERITASAdversary = {
    var adversaryId : Text;
    var frequency : Nat;
    var recency : Float;
    var severity : Float;
    var threatScore : Float;
    var isHighThreat : Bool;
    var firstIncident : Nat;
    var lastIncident : Nat;
  };

  /// Full VAEL stack state
  public type VAELState = {
    var dura : DURAState;
    var riftSources : Buffer.Buffer<RIFTSource>;
    var parallax : PARALLAXState;
    var adversaries : Buffer.Buffer<VERITASAdversary>;
    var totalThreatsDetected : Nat;
    var totalAttributions : Nat;
    var totalBeats : Nat;
    var isDefenseActive : Bool;
    var overallThreatLevel : Float;    // 0-1, synthesized from all sources
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initVAELState() : VAELState {
    {
      var dura = {
        var axis1 = 0.0; var axis2 = 0.0; var axis3 = 0.0;
        var axis4 = 0.0; var axis5 = 0.0; var axis6 = 0.0;
        var coverageField = 0.0;
        var outwardProjection = DURA_OUTWARD_PROJECTION_STRENGTH;
      };
      var riftSources = Buffer.Buffer<RIFTSource>(MAX_RIFT_SOURCES);
      var parallax = {
        var phase = 0.0;
        var rotationsCompleted = 0;
        var outputSignature = 1.0;
      };
      var adversaries = Buffer.Buffer<VERITASAdversary>(MAX_ADVERSARIES);
      var totalThreatsDetected = 0;
      var totalAttributions = 0;
      var totalBeats = 0;
      var isDefenseActive = false;
      var overallThreatLevel = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DURA — 6-AXIS HELIX OUTWARD PROJECTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Advance all 6 DURA axes by one beat
  public func duraAdvance(state : VAELState) : Float {
    let d = state.dura;
    d.axis1 := Float.rem(d.axis1 + DURA_AXIS1_RATE, TWO_PI);
    d.axis2 := Float.rem(d.axis2 + DURA_AXIS2_RATE, TWO_PI);
    d.axis3 := Float.rem(d.axis3 + DURA_AXIS3_RATE, TWO_PI);
    d.axis4 := Float.rem(d.axis4 + DURA_AXIS4_RATE, TWO_PI);
    d.axis5 := Float.rem(d.axis5 + DURA_AXIS5_RATE, TWO_PI);
    d.axis6 := Float.rem(d.axis6 + DURA_AXIS6_RATE, TWO_PI);

    // Coverage = product of (1 - cos(axis_i))/2 terms — full coverage = 1.0
    let c1 = (1.0 - Float.cos(d.axis1)) / 2.0;
    let c2 = (1.0 - Float.cos(d.axis2)) / 2.0;
    let c3 = (1.0 - Float.cos(d.axis3)) / 2.0;
    let c4 = (1.0 - Float.cos(d.axis4)) / 2.0;
    let c5 = (1.0 - Float.cos(d.axis5)) / 2.0;
    let c6 = (1.0 - Float.cos(d.axis6)) / 2.0;
    let combined = (c1 + c2 + c3 + c4 + c5 + c6) / 6.0;

    // Outward projection modulates the combined field
    d.coverageField := combined * d.outwardProjection;
    d.coverageField
  };

  /// DURA threat scan: returns threat score [0,1] based on coverage gap
  public func duraScanForThreats(state : VAELState, externalSignal : Float) : Float {
    // Threat detected when external signal exceeds coverage field
    let gap = externalSignal - state.dura.coverageField;
    if (gap > 0.0) { Float.min(1.0, gap) } else { 0.0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RIFT — SOURCE ATTRIBUTION + COMPOUNDING PERMANENT PENALTY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Find an existing RIFT source by ID
  func findRIFTSource(state : VAELState, sourceId : Text) : ?Nat {
    var idx = 0;
    for (s in state.riftSources.vals()) {
      if (s.sourceId == sourceId) { return ?idx };
      idx += 1;
    };
    null
  };

  /// Attribute a threat to a source and apply compounding penalty
  public func riftAttributeSource(
    state : VAELState,
    sourceId : Text,
    beat : Nat
  ) : Float {
    state.totalAttributions += 1;

    switch (findRIFTSource(state, sourceId)) {
      case (?idx) {
        let s = state.riftSources.get(idx);
        let newPenalty = Float.min(RIFT_MAX_PENALTY, s.cumulativePenalty * RIFT_COMPOUND_RATE);
        state.riftSources.put(idx, {
          var sourceId = s.sourceId;
          var attributions = s.attributions + 1;
          var cumulativePenalty = newPenalty;
          var firstSeen = s.firstSeen;
          var lastSeen = beat;
          var isPermanentlyPenalized = newPenalty >= RIFT_MAX_PENALTY * 0.9;
        });
        newPenalty
      };
      case (null) {
        // New source — trim if at capacity (remove lowest penalty source)
        if (state.riftSources.size() >= MAX_RIFT_SOURCES) {
          var minPenalty = 999.0;
          var minIdx = 0;
          var i = 0;
          for (s in state.riftSources.vals()) {
            if (s.cumulativePenalty < minPenalty) {
              minPenalty := s.cumulativePenalty;
              minIdx := i;
            };
            i += 1;
          };
          ignore state.riftSources.remove(minIdx);
        };

        state.riftSources.add({
          var sourceId = sourceId;
          var attributions = 1;
          var cumulativePenalty = RIFT_INITIAL_PENALTY;
          var firstSeen = beat;
          var lastSeen = beat;
          var isPermanentlyPenalized = false;
        });
        RIFT_INITIAL_PENALTY
      };
    }
  };

  /// Get the effective trust score for a source (1.0 = fully trusted, 0 = fully penalized)
  public func riftGetTrustScore(state : VAELState, sourceId : Text) : Float {
    switch (findRIFTSource(state, sourceId)) {
      case (?idx) {
        let s = state.riftSources.get(idx);
        Float.max(0.0, 1.0 - s.cumulativePenalty / RIFT_MAX_PENALTY)
      };
      case (null) { 1.0 };  // Unknown sources start trusted
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PARALLAX — ROTATING PHASE SOVEREIGNTY
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Advance PARALLAX phase by one beat
  public func parallaxAdvance(state : VAELState) : Float {
    let p = state.parallax;
    p.phase := Float.rem(p.phase + PARALLAX_OMEGA, TWO_PI);
    if (p.phase < PARALLAX_OMEGA) {
      p.rotationsCompleted += 1;
    };

    // Output signature: amplitude × cos(phase) — unique each beat
    p.outputSignature := PARALLAX_AMPLITUDE * Float.cos(p.phase);
    p.outputSignature
  };

  /// Apply PARALLAX phase rotation to an output vector
  /// Makes output unreplicable by rotating it through current phase
  public func parallaxRotateOutput(state : VAELState, output : [Float]) : [Float] {
    let phase = state.parallax.phase;
    let cosP = Float.cos(phase);
    let sinP = Float.sin(phase);
    Array.tabulate<Float>(output.size(), func(i : Nat) : Float {
      if (i + 1 < output.size()) {
        output[i] * cosP - output[i + 1] * sinP
      } else {
        output[i] * cosP
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // VERITAS — ADVERSARY SCORING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Find adversary by ID
  func findAdversary(state : VAELState, adversaryId : Text) : ?Nat {
    var idx = 0;
    for (a in state.adversaries.vals()) {
      if (a.adversaryId == adversaryId) { return ?idx };
      idx += 1;
    };
    null
  };

  /// Record an adversary incident and update their threat score
  /// score = frequency × recency × severity (normalized)
  public func veritasRecordIncident(
    state : VAELState,
    adversaryId : Text,
    severity : Float,
    beat : Nat
  ) : Float {
    state.totalThreatsDetected += 1;

    switch (findAdversary(state, adversaryId)) {
      case (?idx) {
        let a = state.adversaries.get(idx);
        let newFreq = a.frequency + 1;
        let newRecency = 1.0;  // Reset recency on new incident
        let newSeverity = (a.severity * Float.fromInt(a.frequency) + severity) / Float.fromInt(newFreq);
        let score = Float.min(1.0,
          Float.fromInt(newFreq) * 0.01 * newRecency * newSeverity
        );
        state.adversaries.put(idx, {
          var adversaryId = a.adversaryId;
          var frequency = newFreq;
          var recency = newRecency;
          var severity = newSeverity;
          var threatScore = score;
          var isHighThreat = score >= VERITAS_HIGH_THREAT;
          var firstIncident = a.firstIncident;
          var lastIncident = beat;
        });
        score
      };
      case (null) {
        if (state.adversaries.size() >= MAX_ADVERSARIES) {
          // Remove lowest-threat adversary
          var minScore = 999.0;
          var minIdx = 0;
          var i = 0;
          for (a in state.adversaries.vals()) {
            if (not a.isHighThreat and a.threatScore < minScore) {
              minScore := a.threatScore;
              minIdx := i;
            };
            i += 1;
          };
          ignore state.adversaries.remove(minIdx);
        };

        let score = Float.min(1.0, 0.01 * 1.0 * severity);
        state.adversaries.add({
          var adversaryId = adversaryId;
          var frequency = 1;
          var recency = 1.0;
          var severity = severity;
          var threatScore = score;
          var isHighThreat = score >= VERITAS_HIGH_THREAT;
          var firstIncident = beat;
          var lastIncident = beat;
        });
        score
      };
    }
  };

  /// Decay all adversary recency scores per beat
  func veritasDecayAll(state : VAELState) : () {
    var idx = 0;
    while (idx < state.adversaries.size()) {
      let a = state.adversaries.get(idx);
      let newRecency = Float.max(0.01, a.recency * VERITAS_RECENCY_DECAY);
      let newScore = Float.min(1.0,
        Float.fromInt(a.frequency) * 0.01 * newRecency * a.severity
      );
      state.adversaries.put(idx, {
        var adversaryId = a.adversaryId;
        var frequency = a.frequency;
        var recency = newRecency;
        var severity = a.severity;
        var threatScore = newScore;
        var isHighThreat = newScore >= VERITAS_HIGH_THREAT;
        var firstIncident = a.firstIncident;
        var lastIncident = a.lastIncident;
      });
      idx += 1;
    };
  };

  /// Get overall threat level: max adversary score weighted by count
  func computeOverallThreat(state : VAELState) : Float {
    var maxScore = 0.0;
    var highCount = 0;
    for (a in state.adversaries.vals()) {
      if (a.threatScore > maxScore) { maxScore := a.threatScore };
      if (a.isHighThreat) { highCount += 1 };
    };
    let countFactor = Float.min(1.0, Float.fromInt(highCount) * 0.1);
    Float.min(1.0, maxScore * 0.7 + countFactor * 0.3)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN PER-BEAT TICK
  // ═══════════════════════════════════════════════════════════════════════════════

  public type VAELTickResult = {
    duraFieldCoverage : Float;
    parallaxSignature : Float;
    overallThreatLevel : Float;
    isDefenseActive : Bool;
    highThreatCount : Nat;
  };

  /// Full VAEL tick — called every beat from colonyHeartbeat()
  public func tick(
    state : VAELState,
    beat : Nat,
    externalSignal : Float   // 0.0 = no threat, 1.0 = maximum threat
  ) : VAELTickResult {
    state.totalBeats += 1;

    // 1. DURA outward helix advance
    let coverage = duraAdvance(state);

    // 2. PARALLAX phase advance
    let signature = parallaxAdvance(state);

    // 3. VERITAS: decay all adversary scores
    veritasDecayAll(state);

    // 4. Check if external threat exceeds DURA coverage
    let threatGap = duraScanForThreats(state, externalSignal);
    if (threatGap > 0.1) {
      state.totalThreatsDetected += 1;
    };

    // 5. Compute overall threat
    let threat = computeOverallThreat(state);
    state.overallThreatLevel := threat;
    state.isDefenseActive := threat >= VERITAS_THREAT_FLOOR;

    // Count high-threat adversaries
    var highCount = 0;
    for (a in state.adversaries.vals()) {
      if (a.isHighThreat) { highCount += 1 };
    };

    {
      duraFieldCoverage = coverage;
      parallaxSignature = signature;
      overallThreatLevel = threat;
      isDefenseActive = state.isDefenseActive;
      highThreatCount = highCount;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getStats(state : VAELState) : {
    duraFieldCoverage : Float;
    parallaxPhase : Float;
    parallaxRotations : Nat;
    riftSourceCount : Nat;
    adversaryCount : Nat;
    totalThreatsDetected : Nat;
    totalAttributions : Nat;
    overallThreatLevel : Float;
    isDefenseActive : Bool;
  } {
    {
      duraFieldCoverage = state.dura.coverageField;
      parallaxPhase = state.parallax.phase;
      parallaxRotations = state.parallax.rotationsCompleted;
      riftSourceCount = state.riftSources.size();
      adversaryCount = state.adversaries.size();
      totalThreatsDetected = state.totalThreatsDetected;
      totalAttributions = state.totalAttributions;
      overallThreatLevel = state.overallThreatLevel;
      isDefenseActive = state.isDefenseActive;
    }
  };
}
