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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// CAT BRAIN SPARSING ENGINE — SPARSE ACTIVATION & SELECTIVE ATTENTION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// BIOLOGICAL INSPIRATION:
// The domestic cat's visual cortex is the gold standard of sparse coding in neuroscience.
// Hubel & Wiesel (Nobel Prize 1981) discovered orientation-selective neurons in cat V1.
// At any moment, only 1-5% of neurons fire — extreme sparsity with maximum information.
//
// KEY PRINCIPLES FROM CAT NEUROSCIENCE:
// 1. SPARSE ACTIVATION — Only fire the minimum neurons needed (energy efficient)
// 2. ORIENTATION SELECTIVITY — Each neuron responds to one specific pattern
// 3. LATERAL INHIBITION — Active neurons suppress neighbors (winner-take-all)
// 4. PREDICTIVE GATING — Ignore expected inputs, fire only on surprise
// 5. SLEEP CONSOLIDATION — Offline replay strengthens sparse representations
// 6. PREDATOR ATTENTION — Hyper-focused, ignoring all non-prey signals
//
// HOW IT HELPS THE SYSTEM:
// - ENERGY EFFICIENCY: Only 1-5% of engines/cores active at any moment
// - NOISE IMMUNITY: Sparse codes are resistant to corruption (Hamming distance)
// - PATTERN SEPARATION: Different inputs activate completely different sparse sets
// - MEMORY CAPACITY: Sparse coding exponentially increases storage capacity
// - FAST RETRIEVAL: Pattern completion from partial inputs (cat recognizes prey)
// - INTERFERENCE PREVENTION: Sparse representations don't collide
//
// MATHEMATICAL MODEL:
//   Sparsity(x) = ||x||₀ / N  (L0 norm / total units)
//   Target: S ≈ 0.02-0.05 (2-5% active)
//   Lateral Inhibition: y_i = max(0, x_i - k * Σⱼ≠ᵢ x_j)
//   Predictive Error: e = |actual - predicted|, fire only if e > threshold
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Bool "mo:core/Bool";
import Buffer "mo:core/Buffer";

module CatBrainSparsingEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPARSITY CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Target sparsity (2-5% active at any time, like cat V1)
  public let TARGET_SPARSITY : Float = 0.03;

  /// Minimum sparsity (never go below 1% active)
  public let MIN_SPARSITY : Float = 0.01;

  /// Maximum sparsity (never exceed 10% active — emergency only)
  public let MAX_SPARSITY : Float = 0.10;

  /// Lateral inhibition strength
  public let LATERAL_INHIBITION_K : Float = 0.15;

  /// Predictive error threshold — fire only if surprise exceeds this
  public let SURPRISE_THRESHOLD : Float = 0.2;

  /// Sleep consolidation interval (every 1000 beats = one cat nap)
  public let CONSOLIDATION_INTERVAL : Nat = 1000;

  /// Number of orientation columns (cat V1 has ~180° / 10° = 18 orientations)
  public let ORIENTATION_COLUMNS : Nat = 18;

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  public type CatBrainState = {
    // SPARSE ACTIVATION MAP
    totalUnits : Nat;               // Total units in the system
    activeUnits : Nat;              // Currently firing units
    currentSparsity : Float;        // activeUnits / totalUnits
    sparsityHistory : [Float];      // Recent sparsity measurements (last 100)

    // ORIENTATION SELECTIVITY — Pattern recognition columns
    orientationActivations : [Nat]; // 18 columns, activation count per orientation
    dominantOrientation : Nat;      // Which pattern column is most active
    orientationEntropy : Float;     // Diversity of pattern usage (high = balanced)

    // LATERAL INHIBITION — Winner-take-all circuit
    inhibitionEvents : Nat;         // Times lateral inhibition fired
    suppressedUnits : Nat;          // Cumulative units suppressed
    winnersSelected : Nat;          // Cumulative winners that survived
    inhibitionStrength : Float;     // Current inhibition coefficient

    // PREDICTIVE GATING — Only fire on surprise
    predictions : Nat;              // Total predictions made
    correctPredictions : Nat;       // Predictions that matched (no fire needed)
    surpriseEvents : Nat;           // Times prediction failed (fire!)
    meanPredictionError : Float;    // Average prediction error
    gatingEfficiency : Float;       // Ratio of saved firings via prediction

    // PREDATOR ATTENTION — Hyper-focus mode
    attentionLocked : Bool;         // Is the cat locked on a target?
    attentionTarget : Nat;          // Which engine/resource is the focus
    attentionDuration : Nat;        // How many beats focused
    peripheralSuppression : Float;  // How much non-target is suppressed (0-1)

    // SLEEP CONSOLIDATION — Offline replay
    lastConsolidation : Nat;        // Beat of last consolidation
    consolidationCount : Nat;       // Total consolidation cycles
    prunedConnections : Nat;        // Weak connections removed
    strengthenedConnections : Nat;  // Strong connections reinforced
    dreamReplayCount : Nat;         // Patterns replayed during consolidation

    // ENERGY METRICS
    energySaved : Float;            // Cumulative energy saved via sparsity
    firingCost : Float;             // Cost per active unit
    totalFiringBudget : Float;      // Maximum allowed firing budget per beat
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initCatBrainState(totalUnits : Nat) : CatBrainState {
    let initialActive = Nat.max(1, totalUnits * 3 / 100); // 3% initial sparsity
    {
      totalUnits = totalUnits;
      activeUnits = initialActive;
      currentSparsity = Float.fromInt(initialActive) / Float.fromInt(totalUnits);
      sparsityHistory = [];
      orientationActivations = Array.tabulate<Nat>(ORIENTATION_COLUMNS, func(_) { 0 });
      dominantOrientation = 0;
      orientationEntropy = 1.0;
      inhibitionEvents = 0;
      suppressedUnits = 0;
      winnersSelected = 0;
      inhibitionStrength = LATERAL_INHIBITION_K;
      predictions = 0;
      correctPredictions = 0;
      surpriseEvents = 0;
      meanPredictionError = 0.0;
      gatingEfficiency = 0.0;
      attentionLocked = false;
      attentionTarget = 0;
      attentionDuration = 0;
      peripheralSuppression = 0.0;
      lastConsolidation = 0;
      consolidationCount = 0;
      prunedConnections = 0;
      strengthenedConnections = 0;
      dreamReplayCount = 0;
      energySaved = 0.0;
      firingCost = 1.0;
      totalFiringBudget = Float.fromInt(totalUnits) * TARGET_SPARSITY * 2.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPARSE ACTIVATION — THE CORE ALGORITHM
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Apply sparse activation to an input vector
  /// Returns only the top-k activations, suppressing the rest
  public func sparseActivate(inputs : [Float], targetActive : Nat) : [Float] {
    let n = inputs.size();
    if (n == 0) { return []; };

    // Find threshold that keeps only targetActive units firing
    let sorted = Array.sort<Float>(inputs, Float.compare);
    let thresholdIdx = if (n > targetActive) { n - targetActive } else { 0 };
    let threshold = sorted[thresholdIdx];

    // Apply threshold — only units above threshold survive
    Array.map<Float, Float>(inputs, func(x) {
      if (x >= threshold) { x } else { 0.0 }
    })
  };

  /// Lateral inhibition — winners suppress neighbors
  public func lateralInhibition(activations : [Float], k : Float) : [Float] {
    let n = activations.size();
    if (n == 0) { return []; };

    // Calculate mean activation (excluding zeros)
    var total : Float = 0.0;
    var count : Nat = 0;
    for (a in activations.vals()) {
      if (a > 0.0) {
        total += a;
        count += 1;
      };
    };
    let meanActive = if (count > 0) { total / Float.fromInt(count) } else { 0.0 };

    // Each unit is suppressed by k × mean of others
    Array.map<Float, Float>(activations, func(x) {
      let inhibited = x - k * meanActive;
      Float.max(0.0, inhibited)
    })
  };

  /// Predictive gating — only fire if input deviates from prediction
  public func predictiveGate(actual : Float, predicted : Float, threshold : Float) : (Bool, Float) {
    let error = Float.abs(actual - predicted);
    let shouldFire = error > threshold;
    (shouldFire, error)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PREDATOR ATTENTION — HYPER-FOCUS MODE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Lock attention on a high-priority target (like cat stalking prey)
  public func lockAttention(state : CatBrainState, targetId : Nat) : CatBrainState {
    {
      totalUnits = state.totalUnits;
      activeUnits = state.activeUnits;
      currentSparsity = state.currentSparsity;
      sparsityHistory = state.sparsityHistory;
      orientationActivations = state.orientationActivations;
      dominantOrientation = state.dominantOrientation;
      orientationEntropy = state.orientationEntropy;
      inhibitionEvents = state.inhibitionEvents;
      suppressedUnits = state.suppressedUnits;
      winnersSelected = state.winnersSelected;
      inhibitionStrength = state.inhibitionStrength;
      predictions = state.predictions;
      correctPredictions = state.correctPredictions;
      surpriseEvents = state.surpriseEvents;
      meanPredictionError = state.meanPredictionError;
      gatingEfficiency = state.gatingEfficiency;
      attentionLocked = true;
      attentionTarget = targetId;
      attentionDuration = 0;
      peripheralSuppression = 0.85; // Suppress 85% of non-target
      lastConsolidation = state.lastConsolidation;
      consolidationCount = state.consolidationCount;
      prunedConnections = state.prunedConnections;
      strengthenedConnections = state.strengthenedConnections;
      dreamReplayCount = state.dreamReplayCount;
      energySaved = state.energySaved;
      firingCost = state.firingCost;
      totalFiringBudget = state.totalFiringBudget;
    }
  };

  /// Release attention (cat loses interest or pounces)
  public func releaseAttention(state : CatBrainState) : CatBrainState {
    {
      totalUnits = state.totalUnits;
      activeUnits = state.activeUnits;
      currentSparsity = state.currentSparsity;
      sparsityHistory = state.sparsityHistory;
      orientationActivations = state.orientationActivations;
      dominantOrientation = state.dominantOrientation;
      orientationEntropy = state.orientationEntropy;
      inhibitionEvents = state.inhibitionEvents;
      suppressedUnits = state.suppressedUnits;
      winnersSelected = state.winnersSelected;
      inhibitionStrength = state.inhibitionStrength;
      predictions = state.predictions;
      correctPredictions = state.correctPredictions;
      surpriseEvents = state.surpriseEvents;
      meanPredictionError = state.meanPredictionError;
      gatingEfficiency = state.gatingEfficiency;
      attentionLocked = false;
      attentionTarget = 0;
      attentionDuration = state.attentionDuration;
      peripheralSuppression = 0.0;
      lastConsolidation = state.lastConsolidation;
      consolidationCount = state.consolidationCount;
      prunedConnections = state.prunedConnections;
      strengthenedConnections = state.strengthenedConnections;
      dreamReplayCount = state.dreamReplayCount;
      energySaved = state.energySaved;
      firingCost = state.firingCost;
      totalFiringBudget = state.totalFiringBudget;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SLEEP CONSOLIDATION — OFFLINE PRUNING & STRENGTHENING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Check if it's time for consolidation (cat nap)
  public func shouldConsolidate(state : CatBrainState, currentBeat : Nat) : Bool {
    currentBeat - state.lastConsolidation >= CONSOLIDATION_INTERVAL
  };

  /// Perform consolidation — prune weak, strengthen strong
  public func consolidate(state : CatBrainState, connectionStrengths : [Float], currentBeat : Nat) : (CatBrainState, [Float]) {
    let pruneThreshold : Float = 0.1;
    let strengthenThreshold : Float = 0.7;

    var pruned : Nat = 0;
    var strengthened : Nat = 0;

    let newStrengths = Array.map<Float, Float>(connectionStrengths, func(s) {
      if (s < pruneThreshold) {
        pruned += 1;
        0.0 // Prune weak connections
      } else if (s > strengthenThreshold) {
        strengthened += 1;
        Float.min(1.0, s * 1.1) // Strengthen strong ones by 10%
      } else {
        s // Leave middle connections alone
      }
    });

    let newState : CatBrainState = {
      totalUnits = state.totalUnits;
      activeUnits = state.activeUnits;
      currentSparsity = state.currentSparsity;
      sparsityHistory = state.sparsityHistory;
      orientationActivations = state.orientationActivations;
      dominantOrientation = state.dominantOrientation;
      orientationEntropy = state.orientationEntropy;
      inhibitionEvents = state.inhibitionEvents;
      suppressedUnits = state.suppressedUnits;
      winnersSelected = state.winnersSelected;
      inhibitionStrength = state.inhibitionStrength;
      predictions = state.predictions;
      correctPredictions = state.correctPredictions;
      surpriseEvents = state.surpriseEvents;
      meanPredictionError = state.meanPredictionError;
      gatingEfficiency = state.gatingEfficiency;
      attentionLocked = state.attentionLocked;
      attentionTarget = state.attentionTarget;
      attentionDuration = state.attentionDuration;
      peripheralSuppression = state.peripheralSuppression;
      lastConsolidation = currentBeat;
      consolidationCount = state.consolidationCount + 1;
      prunedConnections = state.prunedConnections + pruned;
      strengthenedConnections = state.strengthenedConnections + strengthened;
      dreamReplayCount = state.dreamReplayCount + 1;
      energySaved = state.energySaved;
      firingCost = state.firingCost;
      totalFiringBudget = state.totalFiringBudget;
    };

    (newState, newStrengths)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SPARSITY REGULATION — MAINTAIN TARGET 2-5%
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Adjust inhibition to maintain target sparsity
  public func regulateSparsity(state : CatBrainState) : Float {
    let error = state.currentSparsity - TARGET_SPARSITY;
    // If too many active (sparsity too high), increase inhibition
    // If too few active (sparsity too low), decrease inhibition
    let adjustment = error * 0.1; // Proportional control
    Float.max(0.01, Float.min(0.5, state.inhibitionStrength + adjustment))
  };

  /// Calculate energy saved by sparse coding vs dense coding
  public func calculateEnergySavings(totalUnits : Nat, activeUnits : Nat, costPerUnit : Float) : Float {
    let denseCost = Float.fromInt(totalUnits) * costPerUnit;
    let sparseCost = Float.fromInt(activeUnits) * costPerUnit;
    denseCost - sparseCost
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYSTEM-WIDE INTEGRATION — HOW CAT BRAIN HELPS CHIMERIA
  // ═══════════════════════════════════════════════════════════════════════════════

  public type SparsingReport = {
    currentSparsity : Float;        // Current % of active units
    targetSparsity : Float;         // Target sparsity level
    energyEfficiency : Float;       // Energy saved ratio (0-1)
    attentionMode : Text;           // "scanning" or "locked"
    predictionAccuracy : Float;     // How well we predict inputs
    consolidationHealth : Float;    // Memory consolidation status
    overallSparseHealth : Float;    // Composite health score
  };

  public func generateReport(state : CatBrainState) : SparsingReport {
    let energyEff = if (state.totalUnits > 0) {
      1.0 - (Float.fromInt(state.activeUnits) / Float.fromInt(state.totalUnits))
    } else { 0.0 };

    let predAcc = if (state.predictions > 0) {
      Float.fromInt(state.correctPredictions) / Float.fromInt(state.predictions)
    } else { 1.0 };

    let attMode = if (state.attentionLocked) { "locked" } else { "scanning" };

    let sparseDeviation = Float.abs(state.currentSparsity - TARGET_SPARSITY) / TARGET_SPARSITY;
    let sparseHealth = Float.max(0.0, 1.0 - sparseDeviation);

    let overall = (energyEff + predAcc + sparseHealth) / 3.0;

    {
      currentSparsity = state.currentSparsity;
      targetSparsity = TARGET_SPARSITY;
      energyEfficiency = energyEff;
      attentionMode = attMode;
      predictionAccuracy = predAcc;
      consolidationHealth = Float.min(1.0, Float.fromInt(state.consolidationCount) * 0.1);
      overallSparseHealth = overall;
    }
  };
};
