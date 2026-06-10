// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  CONFIDENTIAL AND PROPRIETARY. Framework: Medina Doctrine                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DEEP MIND ENGINE — Phase A Orchestrator
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Wires all Phase A memory architecture components as causal per-beat functions:
//
//   1. QMEM 2048-episode Ring Buffer — records every beat episode into quantum memory
//   2. Memory Membrane Gate — coherence-gated filter before deep-layer writes
//      G = σ(α × Λ × A × |δ| − θ)  — only high-coherence patterns sink to long-term memory
//   3. HTM Prediction Buffer — per-shell predicted-next-state; Hebbian updates ONLY on surprise
//      Surprise threshold: |δ| > HTM_SURPRISE_THRESHOLD
//   4. AXIS Eagle EMA — long-horizon exponential moving average (α = 0.002)
//   5. AXIS Elephant — deep memory accumulator (rolling sum of significant episodes)
//
// Result: The organism stops reacting and starts predicting.
//         Learning only happens on genuine surprise.
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Option "mo:core/Option";

module DeepMindEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  // Memory Membrane gate constants
  public let MEMBRANE_ALPHA : Float = 0.8;          // Attention weight α
  public let MEMBRANE_THETA : Float = 0.5;          // Gate threshold θ
  public let MEMBRANE_GATE_MIN : Float = 0.0;
  public let MEMBRANE_GATE_MAX : Float = 1.0;

  // HTM / Surprise-only Hebbian
  public let HTM_SURPRISE_THRESHOLD : Float = 0.15; // |δ| must exceed this for Hebbian update
  public let HTM_PREDICTION_DECAY : Float = 0.95;   // How fast predictions decay per beat
  public let HTM_LEARNING_RATE : Float = 0.01;      // Hebbian η when surprised
  public let WEIGHT_DECAY : Float = 0.001;          // Weight decay λ

  // AXIS Eagle EMA (long-horizon)
  public let EAGLE_ALPHA : Float = 0.002;           // Very slow EMA for long-horizon trend
  // AXIS Elephant (deep memory accumulator)
  public let ELEPHANT_SIGNIFICANCE_THRESHOLD : Float = 0.85;  // Minimum coherence to store
  public let ELEPHANT_RING_SIZE : Nat = 2048;       // Elephant holds 2048 episodes

  // QMEM ring buffer
  public let QMEM_RING_SIZE : Nat = 2048;           // Episodes stored

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// One episode stored in the QMEM ring buffer
  public type QMEMEpisode = {
    beat : Nat;
    coherence : Float;
    formaBalance : Float;
    gateValue : Float;       // Memory Membrane gate value at time of write
    wasDeepStored : Bool;    // True if passed the membrane
    hz0 : Float;             // Representative Hz node 0
    hz1 : Float;             // Representative Hz node 1
    predictionError : Float; // |δ| at this beat
  };

  /// Per-shell HTM prediction buffer
  public type ShellHTMState = {
    var predictedCoherence : Float;   // Shell's predicted next-beat coherence
    var lastPredictionError : Float;  // |predicted - actual|
    var totalSurprises : Nat;
    var totalConfirmations : Nat;
    var weights : [var Float];        // 12 Hebbian weights for inner Hz ring
  };

  /// AXIS Eagle long-horizon EMA state
  public type EagleState = {
    var ema : Float;           // Current long-horizon EMA value
    var trend : Float;         // EMA(t) - EMA(t-1): positive = rising
    var beatsSinceUpdate : Nat;
  };

  /// AXIS Elephant deep memory ring
  public type ElephantState = {
    var ring : [var QMEMEpisode]; // Fixed-size ring buffer
    var head : Nat;               // Next write index
    var count : Nat;              // Episodes stored
    var totalSignificant : Nat;
  };

  /// Full Deep Mind state
  public type DeepMindState = {
    // QMEM ring buffer
    var qmemRing : [var QMEMEpisode];
    var qmemHead : Nat;
    var qmemCount : Nat;

    // Per-shell HTM states (12 shells)
    var shellHTM : [ShellHTMState];

    // AXIS Eagle
    var eagle : EagleState;

    // AXIS Elephant
    var elephant : ElephantState;

    // Aggregate stats
    var totalBeats : Nat;
    var deepWritesThisBeat : Nat;
    var surprisesThisBeat : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  func makeDefaultEpisode() : QMEMEpisode {
    {
      beat = 0; coherence = 0.75; formaBalance = 0.0;
      gateValue = 0.0; wasDeepStored = false;
      hz0 = 0.75; hz1 = 0.75; predictionError = 0.0;
    }
  };

  func makeShellHTM() : ShellHTMState {
    {
      var predictedCoherence = 0.75;
      var lastPredictionError = 0.0;
      var totalSurprises = 0;
      var totalConfirmations = 0;
      var weights = Array.init<Float>(12, func(_ : Nat) : Float { 0.1 });
    }
  };

  public func initDeepMindState() : DeepMindState {
    let defaultEpisode = makeDefaultEpisode();
    {
      var qmemRing = Array.init<QMEMEpisode>(QMEM_RING_SIZE, func(_ : Nat) : QMEMEpisode { defaultEpisode });
      var qmemHead = 0;
      var qmemCount = 0;

      var shellHTM = Array.tabulate<ShellHTMState>(12, func(_ : Nat) : ShellHTMState { makeShellHTM() });

      var eagle = {
        var ema = 0.75;
        var trend = 0.0;
        var beatsSinceUpdate = 0;
      };

      var elephant = {
        var ring = Array.init<QMEMEpisode>(ELEPHANT_RING_SIZE, func(_ : Nat) : QMEMEpisode { defaultEpisode });
        var head = 0;
        var count = 0;
        var totalSignificant = 0;
      };

      var totalBeats = 0;
      var deepWritesThisBeat = 0;
      var surprisesThisBeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY MEMBRANE GATE
  // G = σ(α × Λ × A × |δ| − θ)
  // ═══════════════════════════════════════════════════════════════════════════════

  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };

  /// Compute Memory Membrane gate value
  /// Returns value in [0,1]: > 0.5 means pattern sinks to long-term memory
  public func computeMembraneGate(
    coherence : Float,    // Λ — Kuramoto order parameter
    arousal : Float,      // A — arousal level (approximated by coherence deviation)
    predictionError : Float  // |δ| — absolute prediction error
  ) : Float {
    let activation = MEMBRANE_ALPHA * coherence * arousal * predictionError - MEMBRANE_THETA;
    sigmoid(activation)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QMEM RING BUFFER — per-beat episode write
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Write an episode to the QMEM ring buffer
  /// Applies Memory Membrane gate to decide if deep storage occurs
  public func qmemWrite(
    state : DeepMindState,
    beat : Nat,
    coherence : Float,
    formaBalance : Float,
    hz : [Float],
    predictionError : Float,
    arousal : Float
  ) : Float {
    let gateValue = computeMembraneGate(coherence, arousal, predictionError);
    let wasDeepStored = gateValue > 0.5;

    let hz0 = if (hz.size() > 0) hz[0] else 0.75;
    let hz1 = if (hz.size() > 1) hz[1] else 0.75;

    let episode : QMEMEpisode = {
      beat;
      coherence;
      formaBalance;
      gateValue;
      wasDeepStored;
      hz0;
      hz1;
      predictionError;
    };

    // Write to ring (overwrites oldest)
    state.qmemRing[state.qmemHead] := episode;
    state.qmemHead := (state.qmemHead + 1) % QMEM_RING_SIZE;
    if (state.qmemCount < QMEM_RING_SIZE) {
      state.qmemCount += 1;
    };

    // If gate passed, also write to Elephant deep memory
    if (wasDeepStored) {
      state.deepWritesThisBeat += 1;
      elephantWrite(state.elephant, episode);
    };

    gateValue
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // AXIS ELEPHANT — deep memory ring
  // ═══════════════════════════════════════════════════════════════════════════════

  func elephantWrite(elephant : ElephantState, episode : QMEMEpisode) : () {
    if (episode.coherence >= ELEPHANT_SIGNIFICANCE_THRESHOLD) {
      elephant.ring[elephant.head] := episode;
      elephant.head := (elephant.head + 1) % ELEPHANT_RING_SIZE;
      if (elephant.count < ELEPHANT_RING_SIZE) {
        elephant.count += 1;
      };
      elephant.totalSignificant += 1;
    };
  };

  /// Elephant integration: weighted mean coherence of all deep memories
  public func elephantIntegrate(state : DeepMindState) : Float {
    let elephant = state.elephant;
    if (elephant.count == 0) { return 0.75 };
    var sum = 0.0;
    var i = 0;
    while (i < elephant.count) {
      sum += elephant.ring[i].coherence;
      i += 1;
    };
    sum / Float.fromInt(elephant.count)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // AXIS EAGLE — long-horizon EMA
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Update the Eagle EMA with current coherence
  public func eagleUpdate(state : DeepMindState, coherence : Float) : () {
    let prevEMA = state.eagle.ema;
    let newEMA = prevEMA + EAGLE_ALPHA * (coherence - prevEMA);
    state.eagle.trend := newEMA - prevEMA;
    state.eagle.ema := newEMA;
    state.eagle.beatsSinceUpdate += 1;
  };

  /// Get Eagle trend signal: positive = organism improving long-term
  public func eagleTrend(state : DeepMindState) : Float {
    state.eagle.trend
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HTM PREDICTION BUFFER — per-shell surprise-only Hebbian
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Update one shell's HTM state: predict, measure surprise, conditionally learn
  public func htmUpdateShell(
    shellHTM : ShellHTMState,
    actualCoherence : Float,
    hz : [Float]
  ) : { surprised : Bool; predictionError : Float } {
    // Compute prediction error
    let delta = actualCoherence - shellHTM.predictedCoherence;
    let absDelta = if (delta < 0.0) -delta else delta;
    shellHTM.lastPredictionError := absDelta;

    let surprised = absDelta > HTM_SURPRISE_THRESHOLD;

    if (surprised) {
      shellHTM.totalSurprises += 1;

      // Surprise-only Hebbian update on weight vector
      // Only update weights when organism learns (genuine surprise)
      let limit = if (hz.size() < 12) hz.size() else 12;
      var i = 0;
      while (i < limit) {
        let pre = hz[i];
        let post = actualCoherence;
        // Δw = η × pre × post - λ × w
        let oldW = shellHTM.weights[i];
        let newW = oldW + HTM_LEARNING_RATE * pre * post - WEIGHT_DECAY * oldW;
        shellHTM.weights[i] := Float.min(1.0, Float.max(0.0, newW));
        i += 1;
      };
    } else {
      shellHTM.totalConfirmations += 1;
      // Confirmation is FREE — no weight update
    };

    // Update prediction for next beat: weighted Hz mean
    var weightedSum = 0.0;
    var totalW = 0.0;
    let lim = if (hz.size() < 12) hz.size() else 12;
    var j = 0;
    while (j < lim) {
      weightedSum += shellHTM.weights[j] * hz[j];
      totalW += shellHTM.weights[j];
      j += 1;
    };
    let nextPrediction = if (totalW > 0.0) weightedSum / totalW else actualCoherence;
    shellHTM.predictedCoherence := nextPrediction * HTM_PREDICTION_DECAY + actualCoherence * (1.0 - HTM_PREDICTION_DECAY);

    { surprised; predictionError = absDelta }
  };

  /// Update all shells HTM states
  public func htmUpdateAllShells(
    state : DeepMindState,
    shellCoherences : [Float],
    shellHz : [[Float]]
  ) : Nat {
    var totalSurprises = 0;
    let limit = if (shellCoherences.size() < 12) shellCoherences.size() else 12;
    var i = 0;
    while (i < limit) {
      let coherence = shellCoherences[i];
      let hz = if (i < shellHz.size()) shellHz[i] else [];
      let result = htmUpdateShell(state.shellHTM[i], coherence, hz);
      if (result.surprised) { totalSurprises += 1 };
      i += 1;
    };
    totalSurprises
  };

  /// Get mean prediction error across all shells
  public func getMeanPredictionError(state : DeepMindState) : Float {
    var sum = 0.0;
    for (shell in state.shellHTM.vals()) {
      sum += shell.lastPredictionError;
    };
    sum / 12.0
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN PER-BEAT TICK
  // ═══════════════════════════════════════════════════════════════════════════════

  public type DeepMindTickResult = {
    gateValue : Float;
    wasDeepStored : Bool;
    surprises : Nat;
    eagleTrend : Float;
    elephantMemory : Float;
    meanPredictionError : Float;
  };

  /// Full Deep Mind tick — called every beat from colonyHeartbeat()
  public func tick(
    state : DeepMindState,
    beat : Nat,
    coherence : Float,
    formaBalance : Float,
    hz : [Float],
    shellCoherences : [Float],
    shellHz : [[Float]]
  ) : DeepMindTickResult {
    state.totalBeats += 1;
    state.deepWritesThisBeat := 0;
    state.surprisesThisBeat := 0;

    // 1. QMEM write with Memory Membrane gate
    let meanPE = getMeanPredictionError(state);
    let arousal = Float.min(1.0, coherence * 1.05);  // Arousal ≈ coherence + slight boost
    let gateValue = qmemWrite(state, beat, coherence, formaBalance, hz, meanPE, arousal);

    // 2. AXIS Eagle EMA update
    eagleUpdate(state, coherence);

    // 3. HTM per-shell update (surprise-only Hebbian)
    let surprises = htmUpdateAllShells(state, shellCoherences, shellHz);
    state.surprisesThisBeat := surprises;

    // 4. AXIS Elephant integration (deep memory mean)
    let elephantMem = elephantIntegrate(state);

    {
      gateValue;
      wasDeepStored = gateValue > 0.5;
      surprises;
      eagleTrend = eagleTrend(state);
      elephantMemory = elephantMem;
      meanPredictionError = getMeanPredictionError(state);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════

  public func getStats(state : DeepMindState) : {
    qmemCount : Nat;
    elephantCount : Nat;
    totalBeats : Nat;
    eagleEMA : Float;
    eagleTrend : Float;
    meanPredictionError : Float;
  } {
    {
      qmemCount = state.qmemCount;
      elephantCount = state.elephant.count;
      totalBeats = state.totalBeats;
      eagleEMA = state.eagle.ema;
      eagleTrend = state.eagle.trend;
      meanPredictionError = getMeanPredictionError(state);
    }
  };
}
