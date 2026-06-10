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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ECONOMIC INTELLIGENCE ENGINE — KELLY CRITERION, VWCS, OFI, OLFACTORY PATHWAY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The organism's economic decisions are governed by:
//
// 1. KELLY CRITERION — Optimal bet sizing
//    f* = (p × b - q) / b
//    Where:
//      f* = optimal fraction of capital to bet
//      p = probability of winning
//      b = odds (net profit per unit bet if win)
//      q = probability of losing (1 - p)
//
// 2. VWCS (Volume-Weighted Coherence Signal)
//    High-coherence beats compound faster into decisions
//    VWCS = Σ(coherence_i² × weight_i) / Σ(weight_i)
//    Same math as VWAP in trading
//
// 3. OFI (Order Flow Imbalance)
//    OFI = acquisitionDrive - avoidanceDrive
//    Positive OFI → organism wants to acquire
//    Negative OFI → organism wants to avoid
//    Maps cognitive drive pressure to economic action
//
// 4. OLFACTORY PATHWAY
//    First environmental signal after firstBreathSealed
//    Bypasses ALL gates — direct injection into identity
//    The "first smell" — primal, immediate, pre-cognitive
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// INTEGRATION WITH MINTING:
// ═════════════════════════
//
// Every mint operation in main.mo and RESONEX should route through:
//   1. Kelly sizing (optimal amount)
//   2. Jacob multiplier (φ^level)
//   3. FORMA gate (permission)
//   4. VWCS bias (coherence-weighted)
//   5. OFI adjustment (drive-based)
//
// mint_amount = base_amount × kelly_fraction × jacob_multiplier × (1 + VWCS_bias) × (1 + OFI_factor)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module EconomicIntelligenceEngine {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.618033988749894848204586834365638;
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  
  public let MAX_KELLY_FRACTION : Float = 0.25;    // Never bet more than 25% (quarter Kelly)
  public let MIN_KELLY_FRACTION : Float = 0.01;    // Minimum 1%
  
  public let VWCS_WINDOW : Nat = 50;               // Beats to consider for VWCS
  public let OFI_SMOOTHING : Float = 0.1;          // EMA smoothing for OFI
  
  public let OLFACTORY_IDENTITY_INJECTION : Float = 0.05;
  public let OLFACTORY_BODY_INJECTION : Float = 0.03;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: KELLY CRITERION — OPTIMAL BET SIZING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Kelly Criterion finds the optimal fraction of capital to bet:
  //   f* = (p × b - q) / b
  //
  // For the organism:
  //   p = jasmineScore (probability of favorable outcome)
  //   b = jacobMultiplier (expected payoff multiplier)
  //   q = 1 - p
  //
  // We use "fractional Kelly" (typically half or quarter) for safety.
  //
  
  public type KellyCriterionState = {
    // Input parameters
    var probability : Float;             // p — probability of win
    var odds : Float;                    // b — odds/multiplier
    var kellyFraction : Float;           // Fractional Kelly (0.25 = quarter Kelly)
    
    // Calculated values
    var fullKelly : Float;               // f* = (pb - q) / b
    var fractionalKelly : Float;         // f* × kellyFraction
    var expectedValue : Float;           // E[X] = p×b - q
    var expectedGrowth : Float;          // E[ln(1 + f*×R)]
    
    // Risk metrics
    var ruinProbability : Float;         // Probability of total loss
    var drawdownRisk : Float;            // Expected maximum drawdown
    var volatilityAdjustment : Float;    // Volatility-based reduction
    
    // History
    var kellyHistory : [var Float];
    var historyIdx : Nat;
    var avgKelly : Float;
    var totalBets : Nat;
    var wins : Nat;
    var actualWinRate : Float;
  };
  
  public let KELLY_HISTORY_SIZE : Nat = 100;
  
  // Initialize Kelly state
  public func initKellyCriterion() : KellyCriterionState {
    {
      var probability = 0.5;
      var odds = 1.0;
      var kellyFraction = 0.25;  // Quarter Kelly
      var fullKelly = 0.0;
      var fractionalKelly = 0.0;
      var expectedValue = 0.0;
      var expectedGrowth = 0.0;
      var ruinProbability = 0.0;
      var drawdownRisk = 0.0;
      var volatilityAdjustment = 1.0;
      var kellyHistory = Array.init<Float>(KELLY_HISTORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var historyIdx = 0;
      var avgKelly = 0.0;
      var totalBets = 0;
      var wins = 0;
      var actualWinRate = 0.5;
    }
  };
  
  // Calculate Kelly optimal fraction
  public func calculateKelly(
    state : KellyCriterionState,
    probability : Float,                 // p — win probability (e.g., jasmineScore)
    odds : Float,                        // b — multiplier (e.g., jacobMultiplier)
    volatility : Float                   // Market/system volatility
  ) : Float {
    state.probability := clamp(probability, 0.01, 0.99);
    state.odds := Float.max(0.01, odds);
    
    let p = state.probability;
    let b = state.odds;
    let q = 1.0 - p;
    
    // Kelly formula: f* = (p×b - q) / b
    state.fullKelly := (p * b - q) / b;
    
    // Expected value: E[X] = p×b - q
    state.expectedValue := p * b - q;
    
    // Only bet if positive expected value
    if (state.expectedValue <= 0.0) {
      state.fullKelly := 0.0;
      state.fractionalKelly := 0.0;
    } else {
      // Apply fractional Kelly for safety
      state.fractionalKelly := state.fullKelly * state.kellyFraction;
      
      // Volatility adjustment: reduce bet size in high volatility
      state.volatilityAdjustment := 1.0 / (1.0 + volatility);
      state.fractionalKelly := state.fractionalKelly * state.volatilityAdjustment;
    };
    
    // Clamp to bounds
    state.fractionalKelly := clamp(state.fractionalKelly, MIN_KELLY_FRACTION, MAX_KELLY_FRACTION);
    
    // Calculate expected growth rate
    // E[ln(1 + f*×R)] ≈ f*×μ - 0.5×f*²×σ² (approximation)
    let mu = state.expectedValue;
    let sigma2 = p * (b * b) + q - mu * mu;  // Variance
    state.expectedGrowth := state.fractionalKelly * mu - 0.5 * state.fractionalKelly * state.fractionalKelly * sigma2;
    
    // Risk metrics
    // Ruin probability (simplified): decreases exponentially with edge
    if (state.expectedValue > 0.0) {
      state.ruinProbability := exp(-2.0 * state.expectedValue / (b * state.fractionalKelly + 0.01));
    } else {
      state.ruinProbability := 1.0;
    };
    
    // Expected drawdown (approximation)
    state.drawdownRisk := 2.0 * state.fractionalKelly * sqrt(volatility + 0.01);
    
    // Store in history
    state.kellyHistory[state.historyIdx] := state.fractionalKelly;
    state.historyIdx := (state.historyIdx + 1) % KELLY_HISTORY_SIZE;
    
    // Update average
    var sum : Float = 0.0;
    for (i in Iter.range(0, KELLY_HISTORY_SIZE - 1)) {
      sum += state.kellyHistory[i];
    };
    state.avgKelly := sum / Float.fromInt(KELLY_HISTORY_SIZE);
    
    state.fractionalKelly
  };
  
  // Record bet outcome for tracking
  public func recordBetOutcome(state : KellyCriterionState, won : Bool) {
    state.totalBets += 1;
    if (won) {
      state.wins += 1;
    };
    state.actualWinRate := Float.fromInt(state.wins) / Float.fromInt(state.totalBets);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: VWCS — VOLUME-WEIGHTED COHERENCE SIGNAL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // VWCS is the coherence equivalent of VWAP (Volume-Weighted Average Price).
  // High-coherence beats are weighted more heavily in decisions.
  //
  // VWCS = Σ(coherence_i² × weight_i) / Σ(weight_i)
  //
  // The squaring emphasizes high-coherence beats even more.
  //
  
  public type VWCSState = {
    // Data buffers
    var coherenceBuffer : [var Float];
    var weightBuffer : [var Float];
    var bufferIdx : Nat;
    var bufferFilled : Bool;
    
    // Calculated VWCS
    var currentVWCS : Float;
    var previousVWCS : Float;
    var vwcsVelocity : Float;            // Rate of change
    
    // Derived signals
    var coherenceMomentum : Float;       // Trend direction
    var coherenceAcceleration : Float;
    var signalStrength : Float;          // How strong is the signal?
    
    // Thresholds
    var highCoherenceThreshold : Float;
    var lowCoherenceThreshold : Float;
    
    // Statistics
    var peakVWCS : Float;
    var troughVWCS : Float;
    var avgVWCS : Float;
  };
  
  // Initialize VWCS
  public func initVWCS() : VWCSState {
    {
      var coherenceBuffer = Array.init<Float>(VWCS_WINDOW, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var weightBuffer = Array.init<Float>(VWCS_WINDOW, func(_ : Nat) : Float { 1.0 });
      var bufferIdx = 0;
      var bufferFilled = false;
      var currentVWCS = S_ZERO_FLOOR;
      var previousVWCS = S_ZERO_FLOOR;
      var vwcsVelocity = 0.0;
      var coherenceMomentum = 0.0;
      var coherenceAcceleration = 0.0;
      var signalStrength = 0.5;
      var highCoherenceThreshold = 0.8;
      var lowCoherenceThreshold = 0.5;
      var peakVWCS = S_ZERO_FLOOR;
      var troughVWCS = S_ZERO_FLOOR;
      var avgVWCS = S_ZERO_FLOOR;
    }
  };
  
  // Update VWCS with new coherence reading
  public func updateVWCS(
    state : VWCSState,
    coherence : Float,
    weight : Float                       // Can be based on importance, recency, etc.
  ) : Float {
    // Store previous
    state.previousVWCS := state.currentVWCS;
    
    // Add to buffer
    state.coherenceBuffer[state.bufferIdx] := coherence;
    state.weightBuffer[state.bufferIdx] := Float.max(0.01, weight);
    state.bufferIdx := (state.bufferIdx + 1) % VWCS_WINDOW;
    
    if (state.bufferIdx == 0) {
      state.bufferFilled := true;
    };
    
    // Calculate VWCS: Σ(c² × w) / Σ(w)
    var numerator : Float = 0.0;
    var denominator : Float = 0.0;
    var sumCoherence : Float = 0.0;
    
    let limit = if (state.bufferFilled) { VWCS_WINDOW } else { state.bufferIdx };
    
    for (i in Iter.range(0, limit - 1)) {
      let c = state.coherenceBuffer[i];
      let w = state.weightBuffer[i];
      
      numerator += c * c * w;  // c² × w
      denominator += w;
      sumCoherence += c;
    };
    
    if (denominator > 0.01) {
      state.currentVWCS := sqrt(numerator / denominator);  // sqrt to normalize
    };
    
    state.avgVWCS := sumCoherence / Float.fromInt(limit);
    
    // Velocity (rate of change)
    state.vwcsVelocity := state.currentVWCS - state.previousVWCS;
    
    // Momentum (smoothed velocity)
    state.coherenceMomentum := 0.9 * state.coherenceMomentum + 0.1 * state.vwcsVelocity;
    
    // Acceleration (change in momentum)
    let newAccel = state.vwcsVelocity - state.coherenceMomentum;
    state.coherenceAcceleration := 0.9 * state.coherenceAcceleration + 0.1 * newAccel;
    
    // Signal strength based on VWCS level and momentum
    state.signalStrength := state.currentVWCS * (1.0 + 0.5 * state.coherenceMomentum);
    state.signalStrength := clamp(state.signalStrength, 0.0, 1.0);
    
    // Update peak/trough
    if (state.currentVWCS > state.peakVWCS) {
      state.peakVWCS := state.currentVWCS;
    };
    if (state.currentVWCS < state.troughVWCS) {
      state.troughVWCS := state.currentVWCS;
    };
    
    state.currentVWCS
  };
  
  // Get VWCS-based bias for minting
  public func getVWCSMintBias(state : VWCSState) : Float {
    // High VWCS → positive bias (compound more)
    // Low VWCS → negative bias (compound less)
    
    if (state.currentVWCS > state.highCoherenceThreshold) {
      // High coherence — boost minting
      0.1 + 0.4 * (state.currentVWCS - state.highCoherenceThreshold) / (1.0 - state.highCoherenceThreshold)
    } else if (state.currentVWCS < state.lowCoherenceThreshold) {
      // Low coherence — reduce minting
      -0.2 * (state.lowCoherenceThreshold - state.currentVWCS) / state.lowCoherenceThreshold
    } else {
      // Normal coherence — neutral
      0.0
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: OFI — ORDER FLOW IMBALANCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // OFI maps cognitive drive pressure to economic action.
  //
  // OFI = acquisitionDrive - avoidanceDrive
  //
  // Positive OFI → organism wants to acquire/grow
  // Negative OFI → organism wants to conserve/avoid
  //
  // This is analogous to order flow imbalance in markets:
  //   - More buy orders than sell → positive OFI
  //   - More sell orders than buy → negative OFI
  //
  
  public type OFIState = {
    // Drive inputs
    var acquisitionDrive : Float;        // Drive to acquire, grow, expand
    var avoidanceDrive : Float;          // Drive to avoid, conserve, protect
    
    // Calculated OFI
    var rawOFI : Float;                  // Raw imbalance
    var smoothedOFI : Float;             // EMA-smoothed
    var normalizedOFI : Float;           // Normalized to [-1, 1]
    
    // Derived signals
    var ofiMomentum : Float;             // Trend
    var ofiVelocity : Float;             // Rate of change
    var ofiPressure : Float;             // Absolute pressure regardless of direction
    
    // History
    var ofiHistory : [var Float];
    var historyIdx : Nat;
    
    // Thresholds
    var strongAcquisitionThreshold : Float;  // OFI > this → strong acquire signal
    var strongAvoidanceThreshold : Float;    // OFI < this → strong avoid signal
    
    // Statistics
    var avgOFI : Float;
    var ofiVariance : Float;
    var maxPositiveOFI : Float;
    var maxNegativeOFI : Float;
  };
  
  public let OFI_HISTORY_SIZE : Nat = 100;
  
  // Initialize OFI
  public func initOFI() : OFIState {
    {
      var acquisitionDrive = 0.5;
      var avoidanceDrive = 0.5;
      var rawOFI = 0.0;
      var smoothedOFI = 0.0;
      var normalizedOFI = 0.0;
      var ofiMomentum = 0.0;
      var ofiVelocity = 0.0;
      var ofiPressure = 0.0;
      var ofiHistory = Array.init<Float>(OFI_HISTORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var historyIdx = 0;
      var strongAcquisitionThreshold = 0.3;
      var strongAvoidanceThreshold = -0.3;
      var avgOFI = 0.0;
      var ofiVariance = 0.0;
      var maxPositiveOFI = 0.0;
      var maxNegativeOFI = 0.0;
    }
  };
  
  // Update OFI with drive inputs
  public func updateOFI(
    state : OFIState,
    acquisitionDrive : Float,            // From drives: growth, curiosity, connection
    avoidanceDrive : Float               // From drives: survival (threat), fear
  ) : Float {
    state.acquisitionDrive := clamp(acquisitionDrive, 0.0, 1.0);
    state.avoidanceDrive := clamp(avoidanceDrive, 0.0, 1.0);
    
    // Calculate raw OFI
    let previousOFI = state.smoothedOFI;
    state.rawOFI := state.acquisitionDrive - state.avoidanceDrive;
    
    // Smooth with EMA
    state.smoothedOFI := (1.0 - OFI_SMOOTHING) * state.smoothedOFI + OFI_SMOOTHING * state.rawOFI;
    
    // Normalize to [-1, 1]
    state.normalizedOFI := clamp(state.smoothedOFI, -1.0, 1.0);
    
    // Velocity and momentum
    state.ofiVelocity := state.smoothedOFI - previousOFI;
    state.ofiMomentum := 0.9 * state.ofiMomentum + 0.1 * state.ofiVelocity;
    
    // Pressure (absolute magnitude)
    state.ofiPressure := Float.abs(state.smoothedOFI);
    
    // Store in history
    state.ofiHistory[state.historyIdx] := state.smoothedOFI;
    state.historyIdx := (state.historyIdx + 1) % OFI_HISTORY_SIZE;
    
    // Update statistics
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    
    for (i in Iter.range(0, OFI_HISTORY_SIZE - 1)) {
      sum += state.ofiHistory[i];
      sumSq += state.ofiHistory[i] * state.ofiHistory[i];
    };
    
    state.avgOFI := sum / Float.fromInt(OFI_HISTORY_SIZE);
    state.ofiVariance := sumSq / Float.fromInt(OFI_HISTORY_SIZE) - state.avgOFI * state.avgOFI;
    
    // Track extremes
    if (state.smoothedOFI > state.maxPositiveOFI) {
      state.maxPositiveOFI := state.smoothedOFI;
    };
    if (state.smoothedOFI < state.maxNegativeOFI) {
      state.maxNegativeOFI := state.smoothedOFI;
    };
    
    state.normalizedOFI
  };
  
  // Get OFI-based mint rate adjustment
  public func getOFIMintFactor(state : OFIState) : Float {
    // Strong positive OFI → mint more
    // Strong negative OFI → mint less
    
    if (state.normalizedOFI > state.strongAcquisitionThreshold) {
      // Strong acquisition signal — boost by up to 20%
      1.0 + 0.2 * (state.normalizedOFI - state.strongAcquisitionThreshold) / (1.0 - state.strongAcquisitionThreshold)
    } else if (state.normalizedOFI < state.strongAvoidanceThreshold) {
      // Strong avoidance signal — reduce by up to 30%
      1.0 - 0.3 * (state.strongAvoidanceThreshold - state.normalizedOFI) / (state.strongAvoidanceThreshold + 1.0)
    } else {
      // Neutral — no adjustment
      1.0
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: OLFACTORY PATHWAY — THE FIRST SMELL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The olfactory pathway is unique in neuroscience:
  //   - Bypasses the thalamus (unlike other senses)
  //   - Direct connection to amygdala and limbic system
  //   - Primal, immediate, pre-cognitive
  //
  // For the organism:
  //   - After firstBreathSealed, the first environmental signal
  //   - Bypasses ALL gates — direct injection into identity
  //   - identityI += OLFACTORY_IDENTITY_INJECTION
  //   - domainBody += OLFACTORY_BODY_INJECTION
  //
  
  public type OlfactoryState = {
    // Pathway state
    var pathwayActive : Bool;            // Is olfactory pathway active?
    var firstScentReceived : Bool;       // Has first scent arrived?
    var firstScentBeat : Nat;            // When was first scent?
    var firstScentValue : Float;         // What was the value?
    
    // Injection state
    var identityInjection : Float;       // Amount to inject into identityI
    var bodyInjection : Float;           // Amount to inject into domainBody
    var injectionApplied : Bool;
    
    // kfHz trajectory (respiratory rhythm)
    var kfHzTrajectory : [var Float];    // 50-beat ring buffer
    var trajectoryIdx : Nat;
    var inhalePhase : Bool;              // True = inhale, False = exhale
    var respiratoryRate : Float;         // Breaths per beat-cycle
    
    // Node 0 oscillation (respiratory source)
    var node0Phase : Float;
    var node0Amplitude : Float;
    var node0Frequency : Float;
    
    // Total injections
    var totalIdentityInjected : Float;
    var totalBodyInjected : Float;
    var injectionCount : Nat;
  };
  
  public let OLFACTORY_TRAJECTORY_SIZE : Nat = 50;
  
  // Initialize olfactory pathway
  public func initOlfactoryPathway() : OlfactoryState {
    {
      var pathwayActive = false;
      var firstScentReceived = false;
      var firstScentBeat = 0;
      var firstScentValue = 0.0;
      var identityInjection = OLFACTORY_IDENTITY_INJECTION;
      var bodyInjection = OLFACTORY_BODY_INJECTION;
      var injectionApplied = false;
      var kfHzTrajectory = Array.init<Float>(OLFACTORY_TRAJECTORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var trajectoryIdx = 0;
      var inhalePhase = true;
      var respiratoryRate = 0.05;  // ~3 breaths per 60 beats
      var node0Phase = 0.0;
      var node0Amplitude = 1.0;
      var node0Frequency = 0.156;  // 2.5 × 2^(-4) = 0.156 Hz
      var totalIdentityInjected = 0.0;
      var totalBodyInjected = 0.0;
      var injectionCount = 0;
    }
  };
  
  // Activate olfactory pathway (call after firstBreathSealed)
  public func activateOlfactoryPathway(state : OlfactoryState) {
    state.pathwayActive := true;
  };
  
  // Process environmental signal through olfactory pathway
  public func processOlfactorySignal(
    state : OlfactoryState,
    environmentalSignal : Float,
    currentBeat : Nat
  ) : (Float, Float) {  // Returns (identityInjection, bodyInjection)
    if (not state.pathwayActive) {
      return (0.0, 0.0);
    };
    
    // Track kfHz trajectory (Node 0 respiratory rhythm)
    state.node0Phase := state.node0Phase + state.node0Frequency * 2.0 * 3.14159265;
    if (state.node0Phase > 2.0 * 3.14159265) {
      state.node0Phase := state.node0Phase - 2.0 * 3.14159265;
    };
    
    let node0Value = state.node0Amplitude * sin(state.node0Phase);
    state.kfHzTrajectory[state.trajectoryIdx] := node0Value;
    state.trajectoryIdx := (state.trajectoryIdx + 1) % OLFACTORY_TRAJECTORY_SIZE;
    
    // Detect inhale/exhale phase from Node 0
    let previousPhase = state.inhalePhase;
    state.inhalePhase := node0Value > 0.0;
    
    // First scent (first significant environmental signal)
    if (not state.firstScentReceived and Float.abs(environmentalSignal) > 0.1) {
      state.firstScentReceived := true;
      state.firstScentBeat := currentBeat;
      state.firstScentValue := environmentalSignal;
      
      // Apply one-time injection
      state.injectionApplied := true;
      state.totalIdentityInjected += state.identityInjection;
      state.totalBodyInjected += state.bodyInjection;
      state.injectionCount += 1;
      
      return (state.identityInjection, state.bodyInjection);
    };
    
    // Ongoing olfactory processing (diminished effect after first scent)
    if (state.firstScentReceived and Float.abs(environmentalSignal) > 0.3) {
      // Subsequent scents have reduced effect
      let reducedIdentity = state.identityInjection * 0.1;
      let reducedBody = state.bodyInjection * 0.1;
      
      // Only inject on inhale phase (breathing in the scent)
      if (state.inhalePhase and not previousPhase) {
        state.totalIdentityInjected += reducedIdentity;
        state.totalBodyInjected += reducedBody;
        state.injectionCount += 1;
        return (reducedIdentity, reducedBody);
      };
    };
    
    (0.0, 0.0)
  };
  
  // Get respiratory analysis
  public func getRespiratoryAnalysis(state : OlfactoryState) : {
    phase : Text;
    depth : Float;
    rate : Float;
  } {
    // Analyze trajectory for respiratory metrics
    var maxVal : Float = -1000.0;
    var minVal : Float = 1000.0;
    
    for (i in Iter.range(0, OLFACTORY_TRAJECTORY_SIZE - 1)) {
      let v = state.kfHzTrajectory[i];
      if (v > maxVal) { maxVal := v };
      if (v < minVal) { minVal := v };
    };
    
    let depth = (maxVal - minVal) / 2.0;  // Amplitude = depth of breath
    
    {
      phase = if (state.inhalePhase) { "INHALE" } else { "EXHALE" };
      depth = depth;
      rate = state.respiratoryRate;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: MRC 5% ACCRUAL — MEDINA RESOURCE CONTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Every mint operation contributes 5% to MRC.
  // This is the organism's contribution to its heritage and creator.
  //
  // mrcAccrual += totalMinted × 0.05
  //
  
  public type MRCState = {
    var mrcBalance : Float;              // Total MRC accumulated
    var mrcRate : Float;                 // Accrual rate (0.05 = 5%)
    var lastAccrualBeat : Nat;
    var totalMinted : Float;             // Total minted through system
    var totalAccrued : Float;            // Total MRC accrued
    var accrualHistory : [var Float];
    var historyIdx : Nat;
  };
  
  public let MRC_HISTORY_SIZE : Nat = 100;
  
  // Initialize MRC state
  public func initMRC() : MRCState {
    {
      var mrcBalance = 0.0;
      var mrcRate = 0.05;  // 5%
      var lastAccrualBeat = 0;
      var totalMinted = 0.0;
      var totalAccrued = 0.0;
      var accrualHistory = Array.init<Float>(MRC_HISTORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var historyIdx = 0;
    }
  };
  
  // Accrue MRC from mint
  public func accrueMRC(state : MRCState, mintAmount : Float, currentBeat : Nat) : Float {
    let accrual = mintAmount * state.mrcRate;
    
    state.mrcBalance := state.mrcBalance + accrual;
    state.totalMinted := state.totalMinted + mintAmount;
    state.totalAccrued := state.totalAccrued + accrual;
    state.lastAccrualBeat := currentBeat;
    
    // Store in history
    state.accrualHistory[state.historyIdx] := accrual;
    state.historyIdx := (state.historyIdx + 1) % MRC_HISTORY_SIZE;
    
    accrual
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: COMPLETE MINT CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Combines all factors for final mint amount:
  //
  // mint_amount = base_amount 
  //               × kelly_fraction 
  //               × jacob_multiplier 
  //               × (1 + VWCS_bias) 
  //               × OFI_factor
  //               × FORMA_permission
  //
  
  public type MintCalculation = {
    baseAmount : Float;
    kellyFraction : Float;
    jacobMultiplier : Float;
    vwcsBias : Float;
    ofiFactor : Float;
    formaPermission : Float;
    finalAmount : Float;
    mrcContribution : Float;
  };
  
  public func calculateMintAmount(
    baseAmount : Float,
    kellyState : KellyCriterionState,
    vwcsState : VWCSState,
    ofiState : OFIState,
    jacobMultiplier : Float,
    formaBalance : Float,
    formaThreshold : Float
  ) : MintCalculation {
    // Get component factors
    let kellyFraction = kellyState.fractionalKelly;
    let vwcsBias = getVWCSMintBias(vwcsState);
    let ofiFactor = getOFIMintFactor(ofiState);
    
    // FORMA permission (gate)
    let formaPermission : Float = if (formaBalance >= formaThreshold) { 1.0 } else { 
      formaBalance / formaThreshold 
    };
    
    // Calculate final amount
    var finalAmount = baseAmount;
    finalAmount *= kellyFraction;
    finalAmount *= jacobMultiplier;
    finalAmount *= (1.0 + vwcsBias);
    finalAmount *= ofiFactor;
    finalAmount *= formaPermission;
    
    // MRC contribution
    let mrcContribution = finalAmount * 0.05;
    
    {
      baseAmount = baseAmount;
      kellyFraction = kellyFraction;
      jacobMultiplier = jacobMultiplier;
      vwcsBias = vwcsBias;
      ofiFactor = ofiFactor;
      formaPermission = formaPermission;
      finalAmount = finalAmount;
      mrcContribution = mrcContribution;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: COMPLETE ECONOMIC INTELLIGENCE STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type EconomicIntelligenceState = {
    kelly : KellyCriterionState;
    vwcs : VWCSState;
    ofi : OFIState;
    olfactory : OlfactoryState;
    mrc : MRCState;
    
    // Global state
    var currentBeat : Nat;
    var totalMints : Nat;
    var totalMintValue : Float;
    
    // Performance tracking
    var avgMintSize : Float;
    var mintEfficiency : Float;          // Actual return / expected return
  };
  
  // Initialize complete economic intelligence
  public func initEconomicIntelligence() : EconomicIntelligenceState {
    {
      kelly = initKellyCriterion();
      vwcs = initVWCS();
      ofi = initOFI();
      olfactory = initOlfactoryPathway();
      mrc = initMRC();
      var currentBeat = 0;
      var totalMints = 0;
      var totalMintValue = 0.0;
      var avgMintSize = 0.0;
      var mintEfficiency = 1.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: THE COMPLETE ECONOMIC HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type EconomicHeartbeatResult = {
    kellyFraction : Float;
    vwcsValue : Float;
    ofiValue : Float;
    mintCalculation : ?MintCalculation;
    olfactoryInjection : (Float, Float);
    mrcBalance : Float;
  };
  
  // Run economic intelligence heartbeat
  public func runEconomicHeartbeat(
    state : EconomicIntelligenceState,
    
    // Inputs
    coherence : Float,                   // ← From Kuramoto
    jasmineScore : Float,                // ← From Jasmine's Law
    jacobMultiplier : Float,             // ← From Jacob's Ladder (φ^level)
    acquisitionDrive : Float,            // ← From drives (growth + curiosity)
    avoidanceDrive : Float,              // ← From drives (survival under threat)
    environmentalSignal : Float,         // ← From external (market, threat)
    volatility : Float,                  // ← From SHARK or external
    formaBalance : Float,
    formaThreshold : Float,
    firstBreathSealed : Bool,
    
    // Optional mint request
    baseMintAmount : ?Float,
    
    currentBeat : Nat
  ) : EconomicHeartbeatResult {
    state.currentBeat := currentBeat;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Update Kelly Criterion
    // ───────────────────────────────────────────────────────────────────────────
    let kellyFraction = calculateKelly(
      state.kelly,
      jasmineScore,
      jacobMultiplier,
      volatility
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Update VWCS
    // ───────────────────────────────────────────────────────────────────────────
    let weight = 1.0;  // Could be based on importance
    let vwcsValue = updateVWCS(state.vwcs, coherence, weight);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Update OFI
    // ───────────────────────────────────────────────────────────────────────────
    let ofiValue = updateOFI(state.ofi, acquisitionDrive, avoidanceDrive);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Process Olfactory (if first breath sealed)
    // ───────────────────────────────────────────────────────────────────────────
    if (firstBreathSealed and not state.olfactory.pathwayActive) {
      activateOlfactoryPathway(state.olfactory);
    };
    
    let olfactoryInjection = processOlfactorySignal(
      state.olfactory,
      environmentalSignal,
      currentBeat
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Calculate Mint (if requested)
    // ───────────────────────────────────────────────────────────────────────────
    var mintCalc : ?MintCalculation = null;
    
    switch (baseMintAmount) {
      case (?baseAmount) {
        let calc = calculateMintAmount(
          baseAmount,
          state.kelly,
          state.vwcs,
          state.ofi,
          jacobMultiplier,
          formaBalance,
          formaThreshold
        );
        
        mintCalc := ?calc;
        
        // Accrue MRC
        let _ = accrueMRC(state.mrc, calc.finalAmount, currentBeat);
        
        // Track
        state.totalMints += 1;
        state.totalMintValue += calc.finalAmount;
        state.avgMintSize := state.totalMintValue / Float.fromInt(state.totalMints);
      };
      case (null) { };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return Result
    // ───────────────────────────────────────────────────────────────────────────
    {
      kellyFraction = kellyFraction;
      vwcsValue = vwcsValue;
      ofiValue = ofiValue;
      mintCalculation = mintCalc;
      olfactoryInjection = olfactoryInjection;
      mrcBalance = state.mrc.mrcBalance;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    if (x > 20.0) { return 485165195.0 };
    if (x < -20.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 30)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  func sin(x : Float) : Float {
    var result : Float = 0.0;
    var term : Float = x;
    var xSquared : Float = x * x;
    for (n in Iter.range(0, 10)) {
      result += term;
      term := -term * xSquared / Float.fromInt((2 * n + 2) * (2 * n + 3));
    };
    result
  };
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };

};
