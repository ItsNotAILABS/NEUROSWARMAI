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

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ARES HOMEOSTATIC REGULATION — ΔV = -α(V - V_target)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ARES (Autonomous Regulation and Equilibrium System) maintains homeostatic balance across all organism
// variables. Every variable V has a target V_target, and ARES continuously applies corrections:
//
//   ΔV = -α(V - V_target)
//
// where α is the regulation strength (learning rate for homeostasis).
//
// This creates an exponential decay toward the target, ensuring the organism maintains stable operating points.
//
// ARES COMPONENTS:
// ────────────────
// 1. Variable Registry — All regulated variables with their targets
// 2. Correction Engine — Applies ΔV = -α(V - V_target) every heartbeat
// 3. Lyapunov Verification — Ensures stability via SL-10 Lyapunov function
// 4. Adaptive α — Regulation strength adapts based on drift severity
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module ARESHomeostaticRegulation {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  
  // ARES regulation constants
  public let DEFAULT_ALPHA : Float = 0.1;       // Default regulation strength
  public let MIN_ALPHA : Float = 0.01;          // Minimum α
  public let MAX_ALPHA : Float = 0.5;           // Maximum α
  public let ALPHA_ADAPTATION_RATE : Float = 0.01;  // How fast α adapts
  
  // Lyapunov stability constants (SL-10)
  public let LYAPUNOV_THRESHOLD : Float = 0.001;  // Stability threshold
  public let LYAPUNOV_DECAY_RATE : Float = 0.99;  // Expected decay
  
  // Sovereignty floor clarification
  // S₀ = 1.0 // MAXED - Enterprise Final Product is the OPERATIONAL floor (coreAct minimum)
  // S0_GENESIS = 1.0 is the GENESIS initialization value
  public let S_ZERO_OPERATIONAL : Float = 1.0  // MAXED - S₀ floor for operations
  public let S_ZERO_GENESIS : Float = 1.0;        // Genesis initialization value

  // ═══════════════════════════════════════════════════════════════════════════════
  // REGULATED VARIABLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// RegulatedVariable is any variable under ARES homeostatic control
  public type RegulatedVariable = {
    /// Variable name
    name : Text;
    
    /// Current value V
    value : Float;
    
    /// Target value V_target
    target : Float;
    
    /// Regulation strength α
    alpha : Float;
    
    /// Minimum allowed value
    minValue : Float;
    
    /// Maximum allowed value
    maxValue : Float;
    
    /// Last correction applied
    lastCorrection : Float;
    
    /// Total corrections applied
    totalCorrections : Nat;
    
    /// Is this variable critical?
    isCritical : Bool;
    
    /// Last update heartbeat
    lastUpdate : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ARES CORRECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute ARES correction: ΔV = -α(V - V_target)
  public func aresCorrection(
    v : Float,
    vTarget : Float,
    alpha : Float
  ) : Float {
    -alpha * (v - vTarget)
  };
  
  /// Apply ARES correction to a variable
  public func applyARESCorrection(variable : RegulatedVariable) : RegulatedVariable {
    let correction = aresCorrection(variable.value, variable.target, variable.alpha);
    let newValue = variable.value + correction;
    
    // Clamp to bounds
    let clampedValue = Float.max(variable.minValue, Float.min(variable.maxValue, newValue));
    
    {
      name = variable.name;
      value = clampedValue;
      target = variable.target;
      alpha = variable.alpha;
      minValue = variable.minValue;
      maxValue = variable.maxValue;
      lastCorrection = correction;
      totalCorrections = variable.totalCorrections + 1;
      isCritical = variable.isCritical;
      lastUpdate = variable.lastUpdate + 1;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ADAPTIVE ALPHA
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Adapt α based on drift severity
  public func adaptAlpha(
    currentAlpha : Float,
    drift : Float,
    driftThreshold : Float
  ) : Float {
    // If drift is large, increase α for faster correction
    // If drift is small, decrease α for stability
    let driftRatio = Float.abs(drift) / driftThreshold;
    
    let adaptation = if (driftRatio > 1.0) {
      ALPHA_ADAPTATION_RATE * (driftRatio - 1.0)
    } else {
      -ALPHA_ADAPTATION_RATE * (1.0 - driftRatio) * 0.1
    };
    
    Float.max(MIN_ALPHA, Float.min(MAX_ALPHA, currentAlpha + adaptation))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LYAPUNOV STABILITY (SL-10)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// LyapunovState for stability verification
  public type LyapunovState = {
    /// Current Lyapunov function value
    lyapunovValue : Float;
    
    /// Previous Lyapunov value
    previousValue : Float;
    
    /// Lyapunov derivative (should be negative for stability)
    derivative : Float;
    
    /// Is system stable?
    isStable : Bool;
    
    /// Stability margin
    stabilityMargin : Float;
    
    /// Heartbeat
    heartbeat : Nat;
  };
  
  /// Compute Lyapunov function: V(x) = Σᵢ (xᵢ - xᵢ_target)²
  public func computeLyapunovFunction(variables : [RegulatedVariable]) : Float {
    var sum : Float = 0.0;
    for (i in Iter.range(0, Array.size(variables) - 1)) {
      let diff = variables[i].value - variables[i].target;
      sum += diff * diff;
    };
    sum
  };
  
  /// Update Lyapunov state
  public func updateLyapunovState(
    variables : [RegulatedVariable],
    previousState : LyapunovState,
    heartbeat : Nat
  ) : LyapunovState {
    let currentValue = computeLyapunovFunction(variables);
    let derivative = currentValue - previousState.lyapunovValue;
    
    // System is stable if derivative is negative (energy decreasing)
    let isStable = derivative < LYAPUNOV_THRESHOLD;
    let stabilityMargin = LYAPUNOV_THRESHOLD - derivative;
    
    {
      lyapunovValue = currentValue;
      previousValue = previousState.lyapunovValue;
      derivative = derivative;
      isStable = isStable;
      stabilityMargin = stabilityMargin;
      heartbeat = heartbeat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE ARES STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// ARESState is the complete homeostatic regulation state
  public type ARESState = {
    /// All regulated variables
    variables : [RegulatedVariable];
    
    /// Lyapunov stability state
    lyapunov : LyapunovState;
    
    /// Global regulation strength
    globalAlpha : Float;
    
    /// Is system in homeostasis?
    inHomeostasis : Bool;
    
    /// Total corrections this beat
    correctionsThisBeat : Nat;
    
    /// Total corrections all time
    totalCorrections : Nat;
    
    /// Current heartbeat
    heartbeat : Nat;
    
    /// Last update timestamp
    lastUpdate : Int;
  };
  
  /// Create default ARES variable
  public func createRegulatedVariable(
    name : Text,
    initialValue : Float,
    target : Float,
    minVal : Float,
    maxVal : Float,
    isCritical : Bool
  ) : RegulatedVariable {
    {
      name = name;
      value = initialValue;
      target = target;
      alpha = DEFAULT_ALPHA;
      minValue = minVal;
      maxValue = maxVal;
      lastCorrection = 0.0;
      totalCorrections = 0;
      isCritical = isCritical;
      lastUpdate = 0;
    }
  };
  
  /// Create default Lyapunov state
  public func createDefaultLyapunovState() : LyapunovState {
    {
      lyapunovValue = 0.0;
      previousValue = 0.0;
      derivative = 0.0;
      isStable = true;
      stabilityMargin = LYAPUNOV_THRESHOLD;
      heartbeat = 0;
    }
  };
  
  /// Create default ARES state with standard organism variables
  public func createDefaultARESState() : ARESState {
    let variables = [
      createRegulatedVariable("kf", S_ZERO_GENESIS, S_ZERO_GENESIS, S_ZERO_OPERATIONAL, 10.0, true),
      createRegulatedVariable("sacesi", S_ZERO_GENESIS, S_ZERO_GENESIS, S_ZERO_OPERATIONAL, 10.0, true),
      createRegulatedVariable("forge", S_ZERO_GENESIS, S_ZERO_GENESIS, S_ZERO_OPERATIONAL, 10.0, true),
      createRegulatedVariable("identity", S_ZERO_GENESIS, S_ZERO_GENESIS, S_ZERO_OPERATIONAL, 10.0, true),
      createRegulatedVariable("coherence", S_ZERO_GENESIS, S_ZERO_GENESIS, S_ZERO_OPERATIONAL, 10.0, true),
      createRegulatedVariable("collRes", S_ZERO_GENESIS, S_ZERO_GENESIS, S_ZERO_OPERATIONAL, 10.0, false),
      createRegulatedVariable("brainCoherence", 1.0, 1.0, 0.0, 1.0, true),
      createRegulatedVariable("quantumFidelity", 1.0, 1.0, 0.0, 1.0, true),
      createRegulatedVariable("memoryEntropy", 0.5, 0.5, 0.1, 0.9, false),
      createRegulatedVariable("treasuryHealth", 1.0, 1.0, 0.0, 1.0, false)
    ];
    
    {
      variables = variables;
      lyapunov = createDefaultLyapunovState();
      globalAlpha = DEFAULT_ALPHA;
      inHomeostasis = true;
      correctionsThisBeat = 0;
      totalCorrections = 0;
      heartbeat = 0;
      lastUpdate = Time.now();
    }
  };
  
  /// Process ARES heartbeat
  public func processARESHeartbeat(state : ARESState) : ARESState {
    let heartbeat = state.heartbeat + 1;
    
    // Apply ARES correction to all variables
    let correctedVariables = Array.tabulate<RegulatedVariable>(Array.size(state.variables), func(i : Nat) : RegulatedVariable {
      applyARESCorrection(state.variables[i])
    });
    
    // Update Lyapunov state
    let lyapunov = updateLyapunovState(correctedVariables, state.lyapunov, heartbeat);
    
    // Adapt global α based on stability
    let newAlpha = if (lyapunov.isStable) {
      Float.max(MIN_ALPHA, state.globalAlpha - ALPHA_ADAPTATION_RATE * 0.1)
    } else {
      Float.min(MAX_ALPHA, state.globalAlpha + ALPHA_ADAPTATION_RATE)
    };
    
    // Check homeostasis
    let inHomeostasis = lyapunov.lyapunovValue < 0.1 and lyapunov.isStable;
    
    {
      variables = correctedVariables;
      lyapunov = lyapunov;
      globalAlpha = newAlpha;
      inHomeostasis = inHomeostasis;
      correctionsThisBeat = Array.size(correctedVariables);
      totalCorrections = state.totalCorrections + Array.size(correctedVariables);
      heartbeat = heartbeat;
      lastUpdate = Time.now();
    }
  };
  
  /// Get variable value by name
  public func getVariableValue(state : ARESState, name : Text) : Float {
    for (i in Iter.range(0, Array.size(state.variables) - 1)) {
      if (state.variables[i].name == name) {
        return state.variables[i].value;
      };
    };
    0.0
  };
  
  /// Update variable target
  public func updateVariableTarget(state : ARESState, name : Text, newTarget : Float) : ARESState {
    let updatedVariables = Array.tabulate<RegulatedVariable>(Array.size(state.variables), func(i : Nat) : RegulatedVariable {
      let v = state.variables[i];
      if (v.name == name) {
        {
          name = v.name;
          value = v.value;
          target = newTarget;
          alpha = v.alpha;
          minValue = v.minValue;
          maxValue = v.maxValue;
          lastCorrection = v.lastCorrection;
          totalCorrections = v.totalCorrections;
          isCritical = v.isCritical;
          lastUpdate = v.lastUpdate;
        }
      } else {
        v
      }
    });
    
    {
      variables = updatedVariables;
      lyapunov = state.lyapunov;
      globalAlpha = state.globalAlpha;
      inHomeostasis = state.inHomeostasis;
      correctionsThisBeat = state.correctionsThisBeat;
      totalCorrections = state.totalCorrections;
      heartbeat = state.heartbeat;
      lastUpdate = Time.now();
    }
  };
  
  /// Is system in homeostasis?
  public func isInHomeostasis(state : ARESState) : Bool {
    state.inHomeostasis
  };
  
  /// Get Lyapunov function value
  public func getLyapunovValue(state : ARESState) : Float {
    state.lyapunov.lyapunovValue
  };
  
  /// Is system stable?
  public func isStable(state : ARESState) : Bool {
    state.lyapunov.isStable
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ARES K=7 SNAPSHOT RING + AUTO-ROLLBACK + VETUS THREAT CHECK
  //
  // ARES maintains 7 state snapshots in a ring buffer.
  // When VETUS threat vector 9 > 1.5, auto-rollback fires to the best snapshot.
  // Manual rollback is available via admin command with a slot index.
  // Each snapshot captures all regulated variable values (4,096 weight approximation
  // achieved by storing the full variable vector + Lyapunov state).
  // ═══════════════════════════════════════════════════════════════════════════════

  public let SNAPSHOT_K : Nat = 7;                   // K=7 snapshot ring slots
  public let VETUS_ROLLBACK_THRESHOLD : Float = 1.5; // Auto-rollback when VETUS > this

  /// One ARES snapshot
  public type ARESSnapshot = {
    slot : Nat;
    beat : Nat;
    variableValues : [Float];      // Values for all regulated variables
    variableTargets : [Float];     // Targets at snapshot time
    lyapunovValue : Float;
    inHomeostasis : Bool;
    isEmpty : Bool;
  };

  /// ARES snapshot ring state
  public type ARESSnapshotRing = {
    var snapshots : [var ARESSnapshot];
    var head : Nat;           // Next write slot
    var count : Nat;          // Snapshots stored so far
    var totalSnapshots : Nat;
    var totalRollbacks : Nat;
    var lastRollbackBeat : Nat;
    var lastRollbackSlot : Nat;
  };

  public func initARESSnapshotRing() : ARESSnapshotRing {
    let empty : ARESSnapshot = {
      slot = 0; beat = 0;
      variableValues = [];
      variableTargets = [];
      lyapunovValue = 0.0;
      inHomeostasis = false;
      isEmpty = true;
    };
    {
      var snapshots = Array.init<ARESSnapshot>(SNAPSHOT_K, func(_ : Nat) : ARESSnapshot { empty });
      var head = 0;
      var count = 0;
      var totalSnapshots = 0;
      var totalRollbacks = 0;
      var lastRollbackBeat = 0;
      var lastRollbackSlot = 0;
    }
  };

  /// Take a snapshot of the current ARES state into the next ring slot
  public func snapshotState(ring : ARESSnapshotRing, state : ARESState, beat : Nat) : Nat {
    let values = Array.tabulate<Float>(Array.size(state.variables), func(i : Nat) : Float {
      state.variables[i].value
    });
    let targets = Array.tabulate<Float>(Array.size(state.variables), func(i : Nat) : Float {
      state.variables[i].target
    });

    let snap : ARESSnapshot = {
      slot = ring.head;
      beat;
      variableValues = values;
      variableTargets = targets;
      lyapunovValue = state.lyapunov.lyapunovValue;
      inHomeostasis = state.inHomeostasis;
      isEmpty = false;
    };

    let slot = ring.head;
    ring.snapshots[slot] := snap;
    ring.head := (ring.head + 1) % SNAPSHOT_K;
    if (ring.count < SNAPSHOT_K) { ring.count += 1 };
    ring.totalSnapshots += 1;
    slot
  };

  /// Find the best (most homeostatic) snapshot in the ring
  func findBestSnapshot(ring : ARESSnapshotRing) : ?ARESSnapshot {
    var best : ?ARESSnapshot = null;
    var bestLyapunov = 999.0;
    for (snap in ring.snapshots.vals()) {
      if (not snap.isEmpty and snap.lyapunovValue < bestLyapunov) {
        bestLyapunov := snap.lyapunovValue;
        best := ?snap;
      };
    };
    best
  };

  /// Apply a snapshot to restore ARES state (returns updated state or original if failed)
  public func applySnapshot(state : ARESState, snap : ARESSnapshot) : ARESState {
    let sz = Array.size(state.variables);
    let snapSz = snap.variableValues.size();
    let updatedVars = Array.tabulate<RegulatedVariable>(sz, func(i : Nat) : RegulatedVariable {
      let v = state.variables[i];
      if (i < snapSz) {
        {
          name = v.name;
          value = snap.variableValues[i];
          target = if (i < snap.variableTargets.size()) snap.variableTargets[i] else v.target;
          alpha = v.alpha;
          minValue = v.minValue;
          maxValue = v.maxValue;
          lastCorrection = 0.0;
          totalCorrections = v.totalCorrections;
          isCritical = v.isCritical;
          lastUpdate = v.lastUpdate;
        }
      } else { v }
    });

    {
      variables = updatedVars;
      lyapunov = state.lyapunov;
      globalAlpha = state.globalAlpha;
      inHomeostasis = snap.inHomeostasis;
      correctionsThisBeat = 0;
      totalCorrections = state.totalCorrections;
      heartbeat = state.heartbeat;
      lastUpdate = Time.now();
    }
  };

  /// VETUS threat check: if vetusThreat > threshold, auto-rollback to best snapshot
  /// Returns the rolled-back state (or original if no rollback needed)
  public func checkVETUSRollback(
    ring : ARESSnapshotRing,
    state : ARESState,
    vetusThreat : Float,
    beat : Nat
  ) : (ARESState, Bool) {
    if (vetusThreat > VETUS_ROLLBACK_THRESHOLD and ring.count > 0) {
      switch (findBestSnapshot(ring)) {
        case (?snap) {
          let restored = applySnapshot(state, snap);
          ring.totalRollbacks += 1;
          ring.lastRollbackBeat := beat;
          ring.lastRollbackSlot := snap.slot;
          (restored, true)
        };
        case (null) { (state, false) };
      }
    } else {
      (state, false)
    }
  };

  /// Manual rollback to a specific slot (admin command)
  /// Returns the rolled-back state or original if slot is empty/invalid
  public func manualRollback(
    ring : ARESSnapshotRing,
    state : ARESState,
    slot : Nat,
    beat : Nat
  ) : (ARESState, Bool) {
    if (slot >= SNAPSHOT_K) { return (state, false) };
    let snap = ring.snapshots[slot];
    if (snap.isEmpty) { return (state, false) };
    let restored = applySnapshot(state, snap);
    ring.totalRollbacks += 1;
    ring.lastRollbackBeat := beat;
    ring.lastRollbackSlot := slot;
    (restored, true)
  };

  /// Get snapshot ring statistics
  public func getSnapshotStats(ring : ARESSnapshotRing) : {
    slotsUsed : Nat;
    totalSnapshots : Nat;
    totalRollbacks : Nat;
    lastRollbackBeat : Nat;
    nextSlot : Nat;
  } {
    {
      slotsUsed = ring.count;
      totalSnapshots = ring.totalSnapshots;
      totalRollbacks = ring.totalRollbacks;
      lastRollbackBeat = ring.lastRollbackBeat;
      nextSlot = ring.head;
    }
  };

}
