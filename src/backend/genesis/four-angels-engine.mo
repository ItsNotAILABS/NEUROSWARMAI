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
// THE FOUR ANGELS — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE FOUR ANGELS RUN EVERY BEAT
//
// MICHAEL — Sovereignty Integrity
//   Φ_M = |C - C_doctrine|
//   When Φ_M > breach_threshold → sovereignty guard triggers
//
// GABRIEL — Signal Binding
//   Γ_G = [S × C / 1000] × (1 + ENTANGLA.coherence/1000) × (1 + K_f^binding)
//   Binds signals across substrates when they're phase-aligned
//
// RAPHAEL — Memory Restoration
//   Ρ_R = r × (M_baseline - M) + accumulated_memory_weight
//   Pulls memory back toward baseline when it decays (drift)
//   Strengthened when MEMORIA/LUMEN/SOMA/KORE are phase-locked
//
// URIEL — Quantum Emergence
//   Υ_U = entropy_score + emergence_gate
//   Full doctrine: G_emerge = 1 if entropy in zone AND K_f > θ_K AND D_f > θ_D
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module FourAngelsEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// MICHAEL — Sovereignty breach threshold
  public let SOVEREIGNTY_BREACH_THRESHOLD : Nat = 200;
  
  /// MICHAEL — Critical breach threshold (emergency)
  public let CRITICAL_BREACH_THRESHOLD : Nat = 400;
  
  /// GABRIEL — Binding strength base
  public let BINDING_BASE_STRENGTH : Nat = 500;
  
  /// RAPHAEL — Memory restoration rate (per 1000)
  public let MEMORY_RESTORATION_RATE : Nat = 50;
  
  /// RAPHAEL — Memory baseline target
  public let MEMORY_BASELINE : Nat = 800;
  
  /// URIEL — Entropy low threshold
  public let ENTROPY_LOW_THRESHOLD : Nat = 300;
  
  /// URIEL — Entropy high threshold
  public let ENTROPY_HIGH_THRESHOLD : Nat = 700;
  
  /// URIEL — K_f threshold for emergence
  public let KF_EMERGENCE_THRESHOLD : Nat = 600;
  
  /// URIEL — D_f threshold for emergence
  public let DF_EMERGENCE_THRESHOLD : Nat = 50;
  
  /// Emergence cooldown (beats)
  public let EMERGENCE_COOLDOWN : Nat = 500;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MICHAEL STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MichaelState = {
    // Sovereignty measure
    var phiM : Nat;                    // |C - C_doctrine|
    var doctrineDelta : Int;           // C - C_doctrine (signed)
    
    // Breach status
    var isBreached : Bool;
    var isCriticalBreach : Bool;
    var breachCount : Nat;
    var lastBreachBeat : Nat;
    
    // Guard response
    var guardActive : Bool;
    var coherencePullStrength : Nat;   // How hard to pull back
    
    // Doctrine tracking
    var cDoctrine : Nat;               // Target coherence
    var cDoctrineAdjustment : Int;     // Adjustment from DEEP
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  public func initMichaelState() : MichaelState {
    {
      var phiM = 0;
      var doctrineDelta = 0;
      var isBreached = false;
      var isCriticalBreach = false;
      var breachCount = 0;
      var lastBreachBeat = 0;
      var guardActive = false;
      var coherencePullStrength = 0;
      var cDoctrine = 800;
      var cDoctrineAdjustment = 0;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GABRIEL STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GabrielState = {
    // Binding strength
    var gammaG : Nat;                  // Overall binding strength
    
    // Component factors
    var signalFactor : Nat;            // S × C / 1000
    var entanglaFactor : Nat;          // 1 + ENTANGLA.coherence/1000
    var phaseFactor : Nat;             // 1 + K_f^binding
    
    // Binding status
    var isStrongBinding : Bool;        // gammaG > 700
    var bindingQuality : Nat;          // 0-1000 quality score
    
    // Cross-substrate bindings
    var brainQuantumBinding : Nat;
    var brainOrganBinding : Nat;
    var quantumOrganBinding : Nat;
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  public func initGabrielState() : GabrielState {
    {
      var gammaG = 500;
      var signalFactor = 500;
      var entanglaFactor = 1000;
      var phaseFactor = 1000;
      var isStrongBinding = false;
      var bindingQuality = 500;
      var brainQuantumBinding = 500;
      var brainOrganBinding = 500;
      var quantumOrganBinding = 500;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RAPHAEL STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type RaphaelState = {
    // Restoration measure
    var rhoR : Nat;                    // Total restoration value
    
    // Memory tracking
    var currentMemoryWeight : Nat;
    var memoryDeficit : Nat;           // M_baseline - M (if positive)
    var restorationPull : Nat;         // r × deficit
    
    // Consolidation
    var isConsolidating : Bool;
    var consolidationStrength : Nat;
    var phaseLockBonus : Nat;          // Bonus from MEMORIA/LUMEN/SOMA/KORE alignment
    
    // Memory health
    var memoryIntegrity : Nat;         // 0-1000
    var memoryGrowthRate : Int;        // Can be negative (decay)
    
    // Timing
    var lastUpdateBeat : Nat;
    var lastConsolidationBeat : Nat;
  };
  
  public func initRaphaelState() : RaphaelState {
    {
      var rhoR = 0;
      var currentMemoryWeight = 800;
      var memoryDeficit = 0;
      var restorationPull = 0;
      var isConsolidating = false;
      var consolidationStrength = 0;
      var phaseLockBonus = 0;
      var memoryIntegrity = 800;
      var memoryGrowthRate = 0;
      var lastUpdateBeat = 0;
      var lastConsolidationBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // URIEL STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type UrielState = {
    // Emergence measure
    var upsilonU : Nat;                // Total emergence score
    
    // Entropy
    var entropy : Nat;                 // Current entropy level
    var entropyInZone : Bool;          // θ_low < ε < θ_high
    
    // Frequency conditions
    var kfSufficient : Bool;           // K_f > θ_K
    var dfSufficient : Bool;           // D_f > θ_D
    
    // Emergence gate
    var emergenceGateOpen : Bool;      // All 3 conditions met
    var emergenceReadiness : Nat;      // 0-1000
    
    // OMNIS status
    var omnisEligible : Bool;
    var omnisProgress : Nat;           // Progress toward OMNIS (0-9 conditions)
    var lastOmnisBeat : Nat;
    var totalOmnisEvents : Nat;
    
    // Timing
    var lastUpdateBeat : Nat;
    var emergenceCooldown : Nat;
  };
  
  public func initUrielState() : UrielState {
    {
      var upsilonU = 0;
      var entropy = 500;
      var entropyInZone = true;
      var kfSufficient = false;
      var dfSufficient = false;
      var emergenceGateOpen = false;
      var emergenceReadiness = 0;
      var omnisEligible = false;
      var omnisProgress = 0;
      var lastOmnisBeat = 0;
      var totalOmnisEvents = 0;
      var lastUpdateBeat = 0;
      var emergenceCooldown = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE FOUR ANGELS STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FourAngelsState = {
    var michael : MichaelState;
    var gabriel : GabrielState;
    var raphael : RaphaelState;
    var uriel : UrielState;
    
    // Combined metrics
    var totalAngelicPower : Nat;       // Sum of all angel contributions
    var dominantAngel : AngelType;     // Which angel has highest influence
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  public type AngelType = {
    #Michael;
    #Gabriel;
    #Raphael;
    #Uriel;
  };
  
  public func initFourAngelsState() : FourAngelsState {
    {
      var michael = initMichaelState();
      var gabriel = initGabrielState();
      var raphael = initRaphaelState();
      var uriel = initUrielState();
      var totalAngelicPower = 0;
      var dominantAngel = #Michael;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MICHAEL ENGINE
  // Φ_M = |C - C_doctrine|
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateMichael(
    state : MichaelState,
    currentCoherence : Nat,
    deepCoherence : Nat,
    currentBeat : Nat
  ) : () {
    // Calculate C_doctrine with DEEP adjustment
    // C_doctrine(t) = 800 + (DEEP.coherence - 800) / 10
    let deepAdjust = (Int.fromNat(deepCoherence) - 800) / 10;
    state.cDoctrineAdjustment := deepAdjust;
    state.cDoctrine := Int.abs(800 + deepAdjust);
    
    // Calculate Φ_M = |C - C_doctrine|
    state.doctrineDelta := Int.fromNat(currentCoherence) - Int.fromNat(state.cDoctrine);
    state.phiM := Int.abs(state.doctrineDelta);
    
    // Check breach status
    let wasBreached = state.isBreached;
    state.isBreached := state.phiM > SOVEREIGNTY_BREACH_THRESHOLD;
    state.isCriticalBreach := state.phiM > CRITICAL_BREACH_THRESHOLD;
    
    // Count breaches
    if (state.isBreached and not wasBreached) {
      state.breachCount += 1;
      state.lastBreachBeat := currentBeat;
    };
    
    // Calculate guard response
    state.guardActive := state.isBreached;
    if (state.guardActive) {
      // Pull strength proportional to breach magnitude
      state.coherencePullStrength := state.phiM * 100 / CRITICAL_BREACH_THRESHOLD;
      if (state.coherencePullStrength > 1000) {
        state.coherencePullStrength := 1000;
      };
    } else {
      state.coherencePullStrength := 0;
    };
    
    state.lastUpdateBeat := currentBeat;
  };
  
  /// Apply Michael's sovereignty guard (returns coherence adjustment)
  public func michaelCoherenceAdjustment(state : MichaelState) : Int {
    if (not state.guardActive) { return 0; };
    
    // Pull coherence back toward doctrine
    // If C > C_doctrine, pull down; if C < C_doctrine, pull up
    let pullDirection = if (state.doctrineDelta > 0) { -1 } else { 1 };
    let pullMagnitude = state.coherencePullStrength / 10;
    
    pullDirection * Int.fromNat(pullMagnitude)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GABRIEL ENGINE
  // Γ_G = [S × C / 1000] × (1 + ENTANGLA/1000) × (1 + K_f/1000)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateGabriel(
    state : GabrielState,
    salience : Nat,
    coherence : Nat,
    entanglaCoherence : Nat,
    kfBinding : Nat,
    kfBrain : Nat,
    kfQuantum : Nat,
    kfOrgan : Nat,
    currentBeat : Nat
  ) : () {
    // Calculate signal factor: S × C / 1000
    state.signalFactor := (salience * coherence) / 1000;
    
    // Calculate entangla factor: 1 + ENTANGLA/1000 (scaled by 1000)
    state.entanglaFactor := 1000 + entanglaCoherence;
    
    // Calculate phase factor: 1 + K_f^binding/1000 (scaled by 1000)
    state.phaseFactor := 1000 + kfBinding;
    
    // Calculate Γ_G
    // Γ_G = signalFactor × entanglaFactor × phaseFactor / 1000000
    let rawGamma = state.signalFactor * state.entanglaFactor / 1000 * state.phaseFactor / 1000;
    state.gammaG := if (rawGamma > 1000) { 1000 } else { rawGamma };
    
    // Binding status
    state.isStrongBinding := state.gammaG > 700;
    state.bindingQuality := state.gammaG;
    
    // Cross-substrate bindings (use K_f between different substrates)
    state.brainQuantumBinding := (kfBrain + kfQuantum) / 2;
    state.brainOrganBinding := (kfBrain + kfOrgan) / 2;
    state.quantumOrganBinding := (kfQuantum + kfOrgan) / 2;
    
    state.lastUpdateBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RAPHAEL ENGINE
  // Ρ_R = r × (M_baseline - M) + accumulated + phaseLockBonus
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateRaphael(
    state : RaphaelState,
    memoryWeight : Nat,
    kfMemory : Nat,
    isNightPhase : Bool,
    currentBeat : Nat
  ) : () {
    state.currentMemoryWeight := memoryWeight;
    
    // Calculate memory deficit
    state.memoryDeficit := if (MEMORY_BASELINE > memoryWeight) {
      MEMORY_BASELINE - memoryWeight
    } else {
      0
    };
    
    // Calculate restoration pull: r × deficit
    state.restorationPull := MEMORY_RESTORATION_RATE * state.memoryDeficit / 1000;
    
    // Calculate phase lock bonus from K_f^memory
    // When memory substrates are aligned, consolidation is stronger
    state.phaseLockBonus := if (kfMemory > 700) {
      (kfMemory - 700) * 2  // Bonus scales with coherence above 700
    } else {
      0
    };
    
    // Consolidation during night phase
    state.isConsolidating := isNightPhase and kfMemory > 600;
    state.consolidationStrength := if (state.isConsolidating) {
      500 + state.phaseLockBonus
    } else {
      state.phaseLockBonus / 2
    };
    
    // Calculate total Ρ_R
    state.rhoR := state.restorationPull + state.consolidationStrength;
    
    // Memory integrity (0-1000)
    state.memoryIntegrity := if (memoryWeight >= MEMORY_BASELINE) {
      1000
    } else {
      memoryWeight * 1000 / MEMORY_BASELINE
    };
    
    // Track growth rate
    let prevWeight = state.currentMemoryWeight;
    state.memoryGrowthRate := Int.fromNat(memoryWeight) - Int.fromNat(prevWeight);
    
    if (state.isConsolidating) {
      state.lastConsolidationBeat := currentBeat;
    };
    
    state.lastUpdateBeat := currentBeat;
  };
  
  /// Apply Raphael's memory restoration (returns memory adjustment)
  public func raphaelMemoryAdjustment(state : RaphaelState) : Nat {
    if (state.memoryDeficit == 0) { return 0; };
    
    // Restoration amount capped at deficit
    let restoration = if (state.rhoR > state.memoryDeficit) {
      state.memoryDeficit
    } else {
      state.rhoR
    };
    
    restoration / 10  // Gradual restoration
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // URIEL ENGINE
  // G_emerge = 1 if θ_low < ε < θ_high AND K_f > θ_K AND D_f > θ_D
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateUriel(
    state : UrielState,
    entropy : Nat,
    kfGlobal : Nat,
    dfGlobal : Nat,
    parallaxCoherence : Nat,
    drift : Nat,
    omnisConditionsMet : Nat,
    currentBeat : Nat
  ) : () {
    state.entropy := entropy;
    
    // Check entropy in zone
    state.entropyInZone := entropy > ENTROPY_LOW_THRESHOLD and entropy < ENTROPY_HIGH_THRESHOLD;
    
    // Check frequency conditions
    state.kfSufficient := kfGlobal > KF_EMERGENCE_THRESHOLD;
    state.dfSufficient := dfGlobal > DF_EMERGENCE_THRESHOLD;
    
    // Emergence gate: all three conditions
    state.emergenceGateOpen := state.entropyInZone and state.kfSufficient and state.dfSufficient;
    
    // Calculate emergence readiness (0-1000)
    var readiness : Nat = 0;
    if (state.entropyInZone) { readiness += 333; };
    if (state.kfSufficient) { readiness += 333; };
    if (state.dfSufficient) { readiness += 334; };
    state.emergenceReadiness := readiness;
    
    // Calculate Υ_U
    // Υ_U = entropy_contribution + K_f_contribution + PARALLAX_contribution
    let entropyContrib = if (state.entropyInZone) { 300 } else { 100 };
    let kfContrib = kfGlobal / 3;
    let parallaxContrib = parallaxCoherence / 5;
    state.upsilonU := entropyContrib + kfContrib + parallaxContrib;
    
    // OMNIS eligibility
    state.omnisProgress := omnisConditionsMet;
    state.omnisEligible := omnisConditionsMet >= 7 and 
                           state.emergenceGateOpen and
                           currentBeat - state.lastOmnisBeat >= EMERGENCE_COOLDOWN;
    
    // Update cooldown
    if (state.emergenceCooldown > 0 and currentBeat > 0) {
      state.emergenceCooldown := if (state.emergenceCooldown > 1) { 
        state.emergenceCooldown - 1 
      } else { 
        0 
      };
    };
    
    state.lastUpdateBeat := currentBeat;
  };
  
  /// Record OMNIS event
  public func recordOmnisEvent(state : UrielState, currentBeat : Nat) : () {
    state.lastOmnisBeat := currentBeat;
    state.totalOmnisEvents += 1;
    state.emergenceCooldown := EMERGENCE_COOLDOWN;
    state.omnisEligible := false;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COMBINED FOUR ANGELS UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AngelInputs = {
    // For MICHAEL
    currentCoherence : Nat;
    deepCoherence : Nat;
    
    // For GABRIEL
    salience : Nat;
    entanglaCoherence : Nat;
    kfBinding : Nat;
    kfBrain : Nat;
    kfQuantum : Nat;
    kfOrgan : Nat;
    
    // For RAPHAEL
    memoryWeight : Nat;
    kfMemory : Nat;
    isNightPhase : Bool;
    
    // For URIEL
    entropy : Nat;
    kfGlobal : Nat;
    dfGlobal : Nat;
    parallaxCoherence : Nat;
    drift : Nat;
    omnisConditionsMet : Nat;
  };
  
  public func updateAllAngels(
    state : FourAngelsState,
    inputs : AngelInputs,
    currentBeat : Nat
  ) : () {
    // Update MICHAEL
    updateMichael(
      state.michael,
      inputs.currentCoherence,
      inputs.deepCoherence,
      currentBeat
    );
    
    // Update GABRIEL
    updateGabriel(
      state.gabriel,
      inputs.salience,
      inputs.currentCoherence,
      inputs.entanglaCoherence,
      inputs.kfBinding,
      inputs.kfBrain,
      inputs.kfQuantum,
      inputs.kfOrgan,
      currentBeat
    );
    
    // Update RAPHAEL
    updateRaphael(
      state.raphael,
      inputs.memoryWeight,
      inputs.kfMemory,
      inputs.isNightPhase,
      currentBeat
    );
    
    // Update URIEL
    updateUriel(
      state.uriel,
      inputs.entropy,
      inputs.kfGlobal,
      inputs.dfGlobal,
      inputs.parallaxCoherence,
      inputs.drift,
      inputs.omnisConditionsMet,
      currentBeat
    );
    
    // Calculate total angelic power
    state.totalAngelicPower := (1000 - state.michael.phiM) + 
                               state.gabriel.gammaG + 
                               state.raphael.rhoR + 
                               state.uriel.upsilonU;
    
    // Determine dominant angel
    let michaelPower = 1000 - state.michael.phiM;
    let gabrielPower = state.gabriel.gammaG;
    let raphaelPower = state.raphael.rhoR;
    let urielPower = state.uriel.upsilonU;
    
    let maxPower = Nat.max(Nat.max(michaelPower, gabrielPower), Nat.max(raphaelPower, urielPower));
    
    if (maxPower == michaelPower) {
      state.dominantAngel := #Michael;
    } else if (maxPower == gabrielPower) {
      state.dominantAngel := #Gabriel;
    } else if (maxPower == raphaelPower) {
      state.dominantAngel := #Raphael;
    } else {
      state.dominantAngel := #Uriel;
    };
    
    state.lastUpdateBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getAngelsSummary(state : FourAngelsState) : {
    michael : { phiM : Nat; isBreached : Bool; guardActive : Bool };
    gabriel : { gammaG : Nat; isStrongBinding : Bool };
    raphael : { rhoR : Nat; isConsolidating : Bool };
    uriel : { upsilonU : Nat; emergenceGateOpen : Bool; omnisEligible : Bool };
    totalPower : Nat;
    dominant : Text;
  } {
    let dominantText = switch (state.dominantAngel) {
      case (#Michael) { "MICHAEL" };
      case (#Gabriel) { "GABRIEL" };
      case (#Raphael) { "RAPHAEL" };
      case (#Uriel) { "URIEL" };
    };
    
    {
      michael = {
        phiM = state.michael.phiM;
        isBreached = state.michael.isBreached;
        guardActive = state.michael.guardActive;
      };
      gabriel = {
        gammaG = state.gabriel.gammaG;
        isStrongBinding = state.gabriel.isStrongBinding;
      };
      raphael = {
        rhoR = state.raphael.rhoR;
        isConsolidating = state.raphael.isConsolidating;
      };
      uriel = {
        upsilonU = state.uriel.upsilonU;
        emergenceGateOpen = state.uriel.emergenceGateOpen;
        omnisEligible = state.uriel.omnisEligible;
      };
      totalPower = state.totalAngelicPower;
      dominant = dominantText;
    }
  };

}
