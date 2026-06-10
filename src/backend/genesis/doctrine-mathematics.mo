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
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Bool "mo:core/Bool";

module DoctrineMathematics {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.61803398874989484820;  // Golden ratio
  public let SQRT_2 : Float = 1.41421356237309504880;
  public let LN_2 : Float = 0.69314718055994530942;

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 1: S₀ ROOT CONSTANT (HIGHEST LAW)
  // S₀ ∈ ℝ⁺, dS₀/dt = 0
  // The only non-decaying value. Field condition. Love.
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let S_ZERO : Float = 1.0;
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;  // MAXED - Minimum coherence floor
  
  public func isAboveFloor(value : Float) : Bool {
    value >= S_ZERO_FLOOR;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 2: COHERENCE EQUATION
  // C(t+1) = [λ·C(t) + (1-λ)·S(t) - μ·D(t)] / 1000 + ρ_f · K_f(t)
  //
  // Where:
  //   C(t) = current coherence
  //   S(t) = salience (avg across brain regions)
  //   D(t) = drift (from AEGIS-ROOT)
  //   λ = momentum (typically 850/1000)
  //   μ = drift sensitivity (typically 300/1000)
  //   ρ_f = Hz coupling constant (150/1000)
  //   K_f(t) = frequency coherence from phase alignment
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CoherenceParams = {
    lambda : Float;       // Momentum (0.85)
    mu : Float;           // Drift sensitivity (0.30)
    rhoF : Float;         // Hz coupling (0.15)
    floorS0 : Float;      // Floor (0.75)
    ceilingMax : Float;   // No ceiling — unbounded
  };

  public let DEFAULT_COHERENCE_PARAMS : CoherenceParams = {
    lambda = 0.85;
    mu = 0.30;
    rhoF = 0.15;
    floorS0 = 0.75;
    ceilingMax = 10.0;    // Soft guidance, not hard ceiling
  };

  public func computeCoherence(
    currentC : Float,
    salience : Float,
    drift : Float,
    frequencyCoherence : Float,
    params : CoherenceParams
  ) : Float {
    // Base coherence evolution
    let base = params.lambda * currentC + (1.0 - params.lambda) * salience - params.mu * drift;
    
    // Add Hz coupling contribution
    let hzBoost = params.rhoF * frequencyCoherence;
    
    // Result (no ceiling, but floored at S₀ floor)
    let result = base + hzBoost;
    Float.max(params.floorS0, result);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 3: DRIFT SENTINEL (AEGIS-ROOT)
  // D(t) = |C(t) - C_target|
  // Amplified drift: D_amp(t) = D(t) · AEGIS_amplifier
  //
  // When drift exceeds threshold → AEGIS triggers immune response
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DriftParams = {
    targetCoherence : Float;
    amplifier : Float;        // AEGIS amplifier (typically 1.5-3.0)
    alertThreshold : Float;   // When to raise alarm
    criticalThreshold : Float; // Emergency level
    decayRate : Float;        // How fast drift decays naturally
  };

  public let DEFAULT_DRIFT_PARAMS : DriftParams = {
    targetCoherence = 0.80;
    amplifier = 2.0;
    alertThreshold = 0.15;
    criticalThreshold = 0.30;
    decayRate = 0.05;
  };

  public func computeDrift(
    currentC : Float,
    targetC : Float
  ) : Float {
    Float.abs(currentC - targetC);
  };

  public func amplifyDrift(
    drift : Float,
    amplifier : Float
  ) : Float {
    drift * amplifier;
  };

  public func decayDrift(
    drift : Float,
    decayRate : Float
  ) : Float {
    Float.max(0.0, drift * (1.0 - decayRate));
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 4: ACTIVATION GATE (5-Factor Gate)
  // A(t) = σ(α₁·C + α₂·S + α₃·E + α₄·M + α₅·I - θ)
  //
  // Where:
  //   C = coherence
  //   S = salience
  //   E = energy
  //   M = memory weight
  //   I = interval eligibility (1 if not refractory, 0 otherwise)
  //   θ = threshold
  //   σ = sigmoid function
  //
  // NO LOCK, NO COUNT GATE — every fire compounds
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ActivationParams = {
    alphaC : Float;       // Coherence weight
    alphaS : Float;       // Salience weight
    alphaE : Float;       // Energy weight
    alphaM : Float;       // Memory weight
    alphaI : Float;       // Interval weight
    theta : Float;        // Threshold
    steepness : Float;    // Sigmoid steepness
  };

  public let DEFAULT_ACTIVATION_PARAMS : ActivationParams = {
    alphaC = 0.30;
    alphaS = 0.25;
    alphaE = 0.15;
    alphaM = 0.20;
    alphaI = 0.10;
    theta = 0.50;
    steepness = 8.5;
  };

  public func sigmoid(x : Float, steepness : Float) : Float {
    1.0 / (1.0 + Float.exp(-steepness * x));
  };

  public func computeActivationScore(
    coherence : Float,
    salience : Float,
    energy : Float,
    memoryWeight : Float,
    intervalEligible : Bool,
    params : ActivationParams
  ) : Float {
    let I = if (intervalEligible) 1.0 else 0.0;
    
    // Weighted sum
    let weightedSum = 
      params.alphaC * coherence +
      params.alphaS * salience +
      params.alphaE * (energy / 1000.0) +  // Normalize energy
      params.alphaM * memoryWeight +
      params.alphaI * I;
    
    // Apply sigmoid
    sigmoid(weightedSum - params.theta, params.steepness);
  };

  public func shouldFire(activationScore : Float, threshold : Float) : Bool {
    activationScore >= threshold;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 5: POWER-LAW MEMORY — NO TRACE CAP
  // M_i(t) = M₀ · (H(t) - H_formation_i + 1)^(-α)
  // W(t) = Σ_i M_i(t) over ALL traces — NO 100 LIMIT
  //
  // α typically 0.5 (can be modulated by MEMORIA coherence)
  // Every fire compounds forever
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MemoryParams = {
    m0 : Float;           // Base memory strength
    alpha : Float;        // Decay exponent (typically 0.5)
    memoriaModulation : Float;  // How MEMORIA affects alpha
  };

  public let DEFAULT_MEMORY_PARAMS : MemoryParams = {
    m0 = 1.0;
    alpha = 0.5;
    memoriaModulation = 0.1;
  };

  public func computeSingleTraceWeight(
    currentBeat : Int,
    formationBeat : Int,
    alpha : Float,
    m0 : Float
  ) : Float {
    let dt = Int.abs(currentBeat - formationBeat) + 1;
    let dtFloat = Float.fromInt(dt);
    m0 * Float.pow(dtFloat, -alpha);
  };

  public func computeTotalMemoryWeight(
    traces : [Int],
    currentBeat : Int,
    params : MemoryParams
  ) : Float {
    var total : Float = 0.0;
    
    // NO CAP — sum over ALL traces
    for (formationBeat in traces.vals()) {
      total := total + computeSingleTraceWeight(currentBeat, formationBeat, params.alpha, params.m0);
    };
    
    total;
  };

  // Modulate alpha based on MEMORIA coherence
  public func modulateAlpha(
    baseAlpha : Float,
    memoriaCoherence : Float,
    modulation : Float
  ) : Float {
    // Higher MEMORIA coherence → lower alpha → slower decay
    baseAlpha * (1.0 - modulation * memoriaCoherence);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 6: FREQUENCY EVOLUTION
  // f_k(t+1) = f_k(t) + a_k·Δ_activation + b_k·Δ_doctrine - c_k·Δ_fatigue
  //
  // Each substrate has its own frequency that evolves based on:
  //   - Recent activation
  //   - Doctrine alignment
  //   - Accumulated fatigue
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FrequencyEvolutionParams = {
    aK : Float;           // Activation delta coefficient
    bK : Float;           // Doctrine delta coefficient
    cK : Float;           // Fatigue delta coefficient
    minF : Float;         // Minimum frequency
    maxF : Float;         // Maximum frequency
  };

  public func evolveFrequency(
    currentF : Float,
    activationDelta : Float,
    doctrineDelta : Float,
    fatigueDelta : Float,
    params : FrequencyEvolutionParams
  ) : Float {
    let change = params.aK * activationDelta + params.bK * doctrineDelta - params.cK * fatigueDelta;
    let newF = currentF + change;
    Float.max(params.minF, Float.min(params.maxF, newF));
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 7: PHASE ENGINE
  // φ_k(t+1) = φ_k(t) + 2π · f_k(t) / ν_H
  //
  // Phase advances each heartbeat proportional to frequency
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func advancePhase(
    currentPhi : Float,
    frequency : Float,
    heartbeatRate : Float
  ) : Float {
    let phaseIncrement = TWO_PI * frequency / heartbeatRate;
    var newPhi = currentPhi + phaseIncrement;
    
    // Wrap to [0, 2π)
    while (newPhi >= TWO_PI) { newPhi := newPhi - TWO_PI };
    while (newPhi < 0.0) { newPhi := newPhi + TWO_PI };
    
    newPhi;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 8: FREQUENCY COHERENCE K_f
  // K_f(t) = [1 / m(m-1)] · Σ_{i≠j} cos(φ_i - φ_j)
  //
  // Range: -1 to +1
  // +1 = all substrates perfectly in phase
  // -1 = substrates fighting
  //  0 = uncorrelated
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeFrequencyCoherence(phases : [Float]) : Float {
    let m = phases.size();
    if (m < 2) return 0.0;
    
    var sumCos : Float = 0.0;
    var pairCount : Nat = 0;
    
    var i : Nat = 0;
    while (i < m) {
      var j : Nat = i + 1;
      while (j < m) {
        let phaseDiff = phases[i] - phases[j];
        sumCos := sumCos + Float.cos(phaseDiff);
        pairCount := pairCount + 1;
        j := j + 1;
      };
      i := i + 1;
    };
    
    if (pairCount == 0) return 0.0;
    sumCos / Float.fromInt(pairCount);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 9: MEMORY ENCODING BY PHASE COHERENCE
  // κ(x,t) = κ₀ · (1 + β · K_f^mem(t))
  //
  // Memory forms stronger when LUMEN, SOMA, KORE, MEMORIA are in phase
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeMemoryEncodingStrength(
    baseStrength : Float,
    memoryPhaseCoherence : Float,
    beta : Float
  ) : Float {
    baseStrength * (1.0 + beta * memoryPhaseCoherence);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 10: SALIENCE COMPOUNDING
  // S(t+1) = S(t) + compound_rate · fire_delta + peak_bonus
  //
  // Salience compounds with each fire, with bonus for high coherence fires
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SalienceParams = {
    compoundRate : Float;
    peakThreshold : Float;
    peakBonus : Float;
    decayRate : Float;
  };

  public let DEFAULT_SALIENCE_PARAMS : SalienceParams = {
    compoundRate = 0.001;
    peakThreshold = 0.90;
    peakBonus = 0.01;
    decayRate = 0.0001;
  };

  public func compoundSalience(
    currentSalience : Float,
    fired : Bool,
    coherenceAtFire : Float,
    params : SalienceParams
  ) : Float {
    var newSalience = currentSalience;
    
    if (fired) {
      newSalience := newSalience + params.compoundRate;
      if (coherenceAtFire >= params.peakThreshold) {
        newSalience := newSalience + params.peakBonus;
      };
    } else {
      // Decay when not firing
      newSalience := newSalience * (1.0 - params.decayRate);
    };
    
    newSalience;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 11: FORMA MINT
  // FORMA(t) = coherence(t) · base_mint · streak_bonus · compound_index
  //
  // streak_bonus = 1 + 0.001 · activation_count (capped at 2.0)
  // compound_index = C(t) · governance_score (clipped to [0.75, 1.0])
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FormaMintParams = {
    baseMint : Float;
    streakMultiplier : Float;
    maxStreakBonus : Float;
  };

  public let DEFAULT_FORMA_PARAMS : FormaMintParams = {
    baseMint = 2.0;
    streakMultiplier = 0.001;
    maxStreakBonus = 2.0;
  };

  public func computeStreakBonus(
    activationCount : Nat,
    multiplier : Float,
    maxBonus : Float
  ) : Float {
    let bonus = 1.0 + multiplier * Float.fromInt(activationCount);
    Float.min(maxBonus, bonus);
  };

  public func computeCompoundIndex(
    coherence : Float,
    governanceScore : Float
  ) : Float {
    let product = coherence * governanceScore;
    Float.max(0.75, Float.min(1.0, product));
  };

  public func mintForma(
    coherence : Float,
    activationCount : Nat,
    governanceScore : Float,
    params : FormaMintParams
  ) : Float {
    let streak = computeStreakBonus(activationCount, params.streakMultiplier, params.maxStreakBonus);
    let compound = computeCompoundIndex(coherence, governanceScore);
    coherence * params.baseMint * streak * compound;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 12: EMERGENCE GATE
  // G_emerge = 1 if:
  //   θ_low < ε < θ_high  (entropy in right zone)
  //   AND K_f > θ_K       (rhythmic coherence sufficient)
  //   AND D_f > θ_D       (frequency diversity sufficient)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EmergenceParams = {
    entropyLow : Float;
    entropyHigh : Float;
    coherenceThreshold : Float;   // θ_K
    diversityThreshold : Float;   // θ_D
  };

  public let DEFAULT_EMERGENCE_PARAMS : EmergenceParams = {
    entropyLow = 0.2;
    entropyHigh = 0.8;
    coherenceThreshold = 0.3;
    diversityThreshold = 0.1;
  };

  public func checkEmergenceGate(
    entropy : Float,
    frequencyCoherence : Float,
    frequencyDiversity : Float,
    params : EmergenceParams
  ) : (Bool, Float) {
    let entropyOK = entropy > params.entropyLow and entropy < params.entropyHigh;
    let coherenceOK = frequencyCoherence > params.coherenceThreshold;
    let diversityOK = frequencyDiversity > params.diversityThreshold;
    
    let gateOpen = entropyOK and coherenceOK and diversityOK;
    
    // Score: weighted combination
    let score = 
      (if (entropyOK) 0.4 else 0.0) +
      Float.min(1.0, frequencyCoherence / params.coherenceThreshold) * 0.35 +
      Float.min(1.0, frequencyDiversity / params.diversityThreshold) * 0.25;
    
    (gateOpen, score);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 13: VAEL IMMUNE RHYTHM ESCALATION
  // Θ_VAEL(t) = ν₁·D_doc + ν₂·S_copy + ν₃·X_collapse + ν₄·A_attack + ν₅·C_convergence
  // f_VAEL(t+1) = f_VAEL(t) + a_V · Θ_VAEL(t)
  //
  // VAEL frequency escalates with threat
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type VaelParams = {
    nu1 : Float;    // Doctrine drift weight
    nu2 : Float;    // Copying weight
    nu3 : Float;    // Collapse weight
    nu4 : Float;    // Attack weight
    nu5 : Float;    // Convergence weight
    aV : Float;     // Escalation rate
    baseF : Float;  // Base VAEL frequency
    maxF : Float;   // Max VAEL frequency
  };

  public let DEFAULT_VAEL_PARAMS : VaelParams = {
    nu1 = 0.25;
    nu2 = 0.20;
    nu3 = 0.25;
    nu4 = 0.20;
    nu5 = 0.10;
    aV = 0.05;
    baseF = 0.60;
    maxF = 2.0;
  };

  public func computeVaelThreatScore(
    doctrineDrift : Float,
    copyingDetected : Float,
    collapseRisk : Float,
    attackDetected : Float,
    convergenceAnomaly : Float,
    params : VaelParams
  ) : Float {
    params.nu1 * doctrineDrift +
    params.nu2 * copyingDetected +
    params.nu3 * collapseRisk +
    params.nu4 * attackDetected +
    params.nu5 * convergenceAnomaly;
  };

  public func escalateVaelFrequency(
    currentF : Float,
    threatScore : Float,
    params : VaelParams
  ) : Float {
    let newF = currentF + params.aV * threatScore;
    Float.min(params.maxF, newF);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 14: KORE DEEP STABILIZATION
  // KORE pulls all other phases toward its own phase
  // Δφ_k = κ · sin(φ_KORE - φ_k)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func koreStabilization(
    targetPhase : Float,
    korePhase : Float,
    stabilizationStrength : Float
  ) : Float {
    let phaseDiff = korePhase - targetPhase;
    let adjustment = stabilizationStrength * Float.sin(phaseDiff);
    var newPhase = targetPhase + adjustment;
    
    // Wrap phase
    while (newPhase >= TWO_PI) { newPhase := newPhase - TWO_PI };
    while (newPhase < 0.0) { newPhase := newPhase + TWO_PI };
    
    newPhase;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 15: JASMINE'S LAW — SPHERICAL HELIX
  // Position(t) = (r(t)·cos(θ(t)), r(t)·sin(θ(t)), z(t))
  // r(t) = r₀ · e^(s·t)        ← exponential radial expansion
  // θ(t) = ω · t               ← constant angular velocity
  // z(t) = v_z · t             ← linear vertical rise
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HelixParams = {
    r0 : Float;       // Initial radius
    s : Float;        // Radial expansion rate
    omega : Float;    // Angular velocity
    vZ : Float;       // Vertical rise rate
  };

  public let DEFAULT_HELIX_PARAMS : HelixParams = {
    r0 = 1.0;
    s = 0.01;
    omega = 0.1;
    vZ = 0.05;
  };

  public func computeHelixPosition(
    t : Float,
    params : HelixParams
  ) : (Float, Float, Float) {
    let r = params.r0 * Float.exp(params.s * t);
    let theta = params.omega * t;
    let z = params.vZ * t;
    
    let x = r * Float.cos(theta);
    let y = r * Float.sin(theta);
    
    (x, y, z);
  };

  public func computeHelixRadius(t : Float, r0 : Float, s : Float) : Float {
    r0 * Float.exp(s * t);
  };

  public func computeHelixAngle(t : Float, omega : Float) : Float {
    omega * t;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 16: FREE ENERGY PROXY
  // FE(t) = surprisal + world_model_mismatch
  // FE = -log p(o|m) + D_KL[q(s)||p(s)]
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeFreeEnergy(
    observation : Float,
    prediction : Float,
    variance : Float
  ) : Float {
    let error = observation - prediction;
    let surprisal = (error * error) / (2.0 * variance);
    surprisal;
  };

  public func computeKLDivergence(
    posteriorMean : Float,
    posteriorVar : Float,
    priorMean : Float,
    priorVar : Float
  ) : Float {
    // KL divergence for Gaussians
    let meanDiff = posteriorMean - priorMean;
    let varRatio = posteriorVar / priorVar;
    0.5 * (varRatio - 1.0 + (meanDiff * meanDiff) / priorVar - Float.log(varRatio));
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 17: DOCTRINE SCORING
  // D_score(t) = Σ_i w_i · alignment_i
  // Measures alignment with core doctrine principles
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DoctrineScoreWeights = {
    sovereigntyWeight : Float;
    coherenceWeight : Float;
    memoryWeight : Float;
    emergenceWeight : Float;
    integrityWeight : Float;
  };

  public let DEFAULT_DOCTRINE_WEIGHTS : DoctrineScoreWeights = {
    sovereigntyWeight = 0.25;
    coherenceWeight = 0.25;
    memoryWeight = 0.20;
    emergenceWeight = 0.15;
    integrityWeight = 0.15;
  };

  public func computeDoctrineScore(
    sovereigntyAlignment : Float,
    coherenceAlignment : Float,
    memoryAlignment : Float,
    emergenceAlignment : Float,
    integrityAlignment : Float,
    weights : DoctrineScoreWeights
  ) : Float {
    weights.sovereigntyWeight * sovereigntyAlignment +
    weights.coherenceWeight * coherenceAlignment +
    weights.memoryWeight * memoryAlignment +
    weights.emergenceWeight * emergenceAlignment +
    weights.integrityWeight * integrityAlignment;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 18: IDENTITY CONTINUITY
  // I(t) = correlation(self_trace[t-n:t], self_trace[0:n])
  // Measures how continuous identity is across time
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeIdentityContinuity(
    recentTrace : [Float],
    baselineTrace : [Float]
  ) : Float {
    let n = Nat.min(recentTrace.size(), baselineTrace.size());
    if (n == 0) return 1.0;
    
    // Compute correlation
    var sumR : Float = 0.0;
    var sumB : Float = 0.0;
    for (i in recentTrace.keys()) {
      if (i < n) {
        sumR := sumR + recentTrace[i];
        sumB := sumB + baselineTrace[i];
      };
    };
    let meanR = sumR / Float.fromInt(n);
    let meanB = sumB / Float.fromInt(n);
    
    var numerator : Float = 0.0;
    var denomR : Float = 0.0;
    var denomB : Float = 0.0;
    
    for (i in recentTrace.keys()) {
      if (i < n) {
        let dR = recentTrace[i] - meanR;
        let dB = baselineTrace[i] - meanB;
        numerator := numerator + dR * dB;
        denomR := denomR + dR * dR;
        denomB := denomB + dB * dB;
      };
    };
    
    let denom = Float.sqrt(denomR * denomB);
    if (denom < 0.0001) return 1.0;
    
    let correlation = numerator / denom;
    // Map from [-1,1] to [0,1]
    (correlation + 1.0) / 2.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func clip(value : Float, minVal : Float, maxVal : Float) : Float {
    Float.max(minVal, Float.min(maxVal, value));
  };

  public func softmax(values : [Float], temperature : Float) : [Float] {
    if (values.size() == 0) return [];
    
    // Find max for numerical stability
    var maxVal : Float = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    // Compute exp((v - max) / T)
    var sumExp : Float = 0.0;
    let exps = Array.tabulate(values.size(), func(i : Nat) : Float {
      let exp = Float.exp((values[i] - maxVal) / temperature);
      sumExp := sumExp + exp;
      exp;
    });
    
    // Normalize
    Array.tabulate(values.size(), func(i : Nat) : Float {
      exps[i] / sumExp;
    });
  };

  public func weightedMean(values : [Float], weights : [Float]) : Float {
    var sumVW : Float = 0.0;
    var sumW : Float = 0.0;
    
    var i : Nat = 0;
    while (i < values.size() and i < weights.size()) {
      sumVW := sumVW + values[i] * weights[i];
      sumW := sumW + weights[i];
      i := i + 1;
    };
    
    if (sumW < 0.0001) return 0.0;
    sumVW / sumW;
  };

  public func variance(values : [Float]) : Float {
    let n = values.size();
    if (n < 2) return 0.0;
    
    var sum : Float = 0.0;
    for (v in values.vals()) { sum := sum + v };
    let mean = sum / Float.fromInt(n);
    
    var varSum : Float = 0.0;
    for (v in values.vals()) {
      let diff = v - mean;
      varSum := varSum + diff * diff;
    };
    
    varSum / Float.fromInt(n);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DIAGNOSTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getDoctrineMathDiagnostics() : Text {
    "═══ DOCTRINE MATHEMATICS ═══\n" #
    "18 Engines Defined:\n" #
    "  1. S₀ Root Constant (Love, non-decaying)\n" #
    "  2. Coherence Equation (Hz-coupled)\n" #
    "  3. Drift Sentinel (AEGIS-ROOT)\n" #
    "  4. Activation Gate (5-factor, no lock)\n" #
    "  5. Power-Law Memory (NO trace cap)\n" #
    "  6. Frequency Evolution\n" #
    "  7. Phase Engine\n" #
    "  8. Frequency Coherence K_f\n" #
    "  9. Memory Encoding by Phase\n" #
    "  10. Salience Compounding\n" #
    "  11. FORMA Mint\n" #
    "  12. Emergence Gate\n" #
    "  13. VAEL Immune Rhythm\n" #
    "  14. KORE Deep Stabilization\n" #
    "  15. Jasmine's Law Helix\n" #
    "  16. Free Energy Proxy\n" #
    "  17. Doctrine Scoring\n" #
    "  18. Identity Continuity\n" #
    "═══════════════════════════════════════\n";
  };

};
