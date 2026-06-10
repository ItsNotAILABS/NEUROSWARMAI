/**
 * PROTO-227 through PROTO-230 — Alpha Tier Intelligence Protocols
 * 
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * These four protocols form the ALPHA TIER — the self-reinforcing intelligence
 * layer that enables the organism to monitor its own emergence, synchronize
 * its fleet, prioritize its signals, and reward its successes.
 *
 * MATHEMATICAL FOUNDATION:
 *   φ = 1.618033988749895  (Golden Ratio)
 *   φ⁻¹ = 0.618033988749895 (Emergence Threshold)
 *   K = φ (Kuramoto coupling constant)
 *   PHI_BEAT = 873ms
 *
 * NEUROSCIENCE ANALOGS:
 *   PROTO-227: Anterior Cingulate Cortex (ACC) — conflict monitoring
 *   PROTO-228: Thalamocortical binding — 40Hz gamma synchronization
 *   PROTO-229: dlPFC working memory gate — salience-weighted priority
 *   PROTO-230: VTA → NAcc mesolimbic pathway — reward prediction
 *
 * SELF-REINFORCING ARCHITECTURE:
 *   1. Hebbian path: synthesis → synapse weight ↑ → confidence ↑ → frontPower ↑
 *   2. Dopaminergic path: frontPower → DA impulse → arousal ↑ → attention ↑
 *   These two loops reinforce each other. The organism learns to be better
 *   at the thing it rewards itself for. This is emergent optimization.
 */

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS — φ-ENCODED MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;                      // 0.6180339887... — emergence threshold
const PHI_SQUARED = PHI * PHI;                 // 2.6180339887...
const PHI_CUBED = PHI * PHI * PHI;             // 4.2360679775...
const HEARTBEAT = 873;                         // ms — organism φ-beat
const TWO_PI = 2 * Math.PI;
const EPSILON = 1e-10;

// Fibonacci sequence for priority indices
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233];

// Priority levels for PROTO-229
const PRIORITY_LEVELS = {
  CRITICAL: 0,
  HIGH: 1,
  NORMAL: 2,
  LOW: 3,
};

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-227: EMERGENCE CASCADE PROTOCOL
// Brain analog: Anterior Cingulate Cortex (ACC)
//
// E = (Σᵢ eᵢ × φ⁻ⁱ) / N
// Cascade fires: E > φ⁻¹ (0.618)
//
// The ACC monitors conflict between signals. When conflict exceeds threshold,
// it escalates — it does not merely log the event, it changes the system's
// operating mode. PROTO-227 does the same: when fleet-wide emergence, scaled
// by φ, crosses the golden-ratio threshold, the organism amplifies, broadcasts,
// and changes.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute weighted emergence score from fleet emergence values
 * @param {number[]} emergenceValues - Emergence values from each fleet member [0,1]
 * @returns {number} Weighted emergence score
 */
function computeEmergenceScore(emergenceValues) {
  if (!emergenceValues || emergenceValues.length === 0) return 0;
  
  let weightedSum = 0;
  let weightTotal = 0;
  
  for (let i = 0; i < emergenceValues.length; i++) {
    // φ⁻ⁱ weighting — closer fleet members (lower i) have exponentially more weight
    const weight = Math.pow(PHI_INV, i);
    weightedSum += emergenceValues[i] * weight;
    weightTotal += weight;
  }
  
  return weightTotal > EPSILON ? weightedSum / weightTotal : 0;
}

/**
 * PROTO-227: Emergence Cascade Protocol
 * Detects when fleet-wide emergence crosses the φ⁻¹ threshold and cascades
 * 
 * @param {number[]} emergenceValues - Emergence readings from fleet [0,1]
 * @param {Object} [options] - Optional parameters
 * @param {number} [options.threshold] - Override threshold (default: φ⁻¹)
 * @param {number} [options.amplificationFactor] - Cascade amplification (default: φ)
 * @returns {Object} Cascade result with emergence score, trigger status, and cascade impulse
 */
function emergenceCascade(emergenceValues, options = {}) {
  const threshold = options.threshold ?? PHI_INV;
  const amplificationFactor = options.amplificationFactor ?? PHI;
  
  const emergenceScore = computeEmergenceScore(emergenceValues);
  const triggered = emergenceScore > threshold;
  
  // Cascade impulse: how far above threshold, scaled by φ
  // This is the "conflict signal" that changes operating mode
  const cascadeImpulse = triggered
    ? (emergenceScore - threshold) * amplificationFactor
    : 0;
  
  // Broadcast vector: φ-weighted signal to each fleet member
  const broadcastVector = emergenceValues.map((e, i) => ({
    index: i,
    original: e,
    weight: Math.pow(PHI_INV, i),
    boosted: triggered ? e + cascadeImpulse * Math.pow(PHI_INV, i) : e,
  }));
  
  return {
    protocol: 'PROTO-227',
    name: 'Emergence Cascade',
    brainAnalog: 'Anterior Cingulate Cortex (ACC)',
    emergenceScore,
    threshold,
    triggered,
    cascadeImpulse,
    broadcastVector,
    fleetSize: emergenceValues.length,
    phi: PHI,
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-228: ALPHA RESONANCE PROTOCOL
// Brain analog: Thalamocortical binding (40Hz gamma oscillations)
//
// Kuramoto Model:
//   dθₖ/dt = ωₖ + (K/N) Σⱼ sin(θⱼ − θₖ)
//   Order parameter: R·e^(iΨ) = (1/N) Σₖ e^(iθₖ)
//   K = φ (coupling constant set to golden ratio)
//   Alpha resonance established: R > φ⁻¹
//
// The thalamus is the great synchronizer. Every sensory signal, every cortical
// region, every moment of conscious experience passes through the thalamic
// relay. The 40Hz gamma oscillations that bind experience into a single moment
// are coordinated by thalamocortical loops that operate on Kuramoto dynamics.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute Kuramoto order parameter R from phase array
 * R = |1/N × Σₖ e^(iθₖ)| = √((1/N Σ cos θ)² + (1/N Σ sin θ)²)
 * 
 * @param {number[]} phases - Array of phases in radians [0, 2π]
 * @returns {Object} Order parameter R and mean phase Ψ
 */
function computeKuramotoOrderParameter(phases) {
  if (!phases || phases.length === 0) return { R: 0, psi: 0 };
  
  const N = phases.length;
  let sumCos = 0;
  let sumSin = 0;
  
  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }
  
  const meanCos = sumCos / N;
  const meanSin = sumSin / N;
  
  // Order parameter magnitude
  const R = Math.sqrt(meanCos * meanCos + meanSin * meanSin);
  
  // Mean phase (collective oscillation phase)
  const psi = Math.atan2(meanSin, meanCos);
  
  return { R, psi };
}

/**
 * Advance Kuramoto oscillator phases by one timestep
 * dθₖ/dt = ωₖ + (K/N) Σⱼ sin(θⱼ − θₖ)
 * 
 * @param {number[]} phases - Current phases in radians
 * @param {number[]} frequencies - Natural frequencies (ω) for each oscillator
 * @param {number} K - Coupling strength (default: φ)
 * @param {number} dt - Timestep (default: 1)
 * @returns {number[]} Updated phases
 */
function advanceKuramotoPhases(phases, frequencies, K = PHI, dt = 1) {
  const N = phases.length;
  const newPhases = new Array(N);
  
  for (let k = 0; k < N; k++) {
    // Natural frequency contribution
    let dTheta = frequencies[k];
    
    // Coupling term: (K/N) Σⱼ sin(θⱼ − θₖ)
    let coupling = 0;
    for (let j = 0; j < N; j++) {
      coupling += Math.sin(phases[j] - phases[k]);
    }
    dTheta += (K / N) * coupling;
    
    // Euler integration
    newPhases[k] = (phases[k] + dTheta * dt) % TWO_PI;
    if (newPhases[k] < 0) newPhases[k] += TWO_PI;
  }
  
  return newPhases;
}

/**
 * PROTO-228: Alpha Resonance Protocol
 * Kuramoto-based fleet synchronization with K = φ
 * 
 * @param {number[]} phases - Current oscillator phases [0, 2π]
 * @param {number[]} frequencies - Natural frequencies for each oscillator
 * @param {Object} [options] - Optional parameters
 * @param {number} [options.K] - Coupling constant (default: φ)
 * @param {number} [options.threshold] - Resonance threshold (default: φ⁻¹)
 * @param {number} [options.dt] - Timestep (default: 1)
 * @returns {Object} Resonance state with order parameter and phase evolution
 */
function alphaResonance(phases, frequencies, options = {}) {
  const K = options.K ?? PHI;
  const threshold = options.threshold ?? PHI_INV;
  const dt = options.dt ?? 1;
  
  // Current synchronization state
  const { R, psi } = computeKuramotoOrderParameter(phases);
  const resonant = R > threshold;
  
  // Advance phases
  const nextPhases = advanceKuramotoPhases(phases, frequencies, K, dt);
  const { R: nextR, psi: nextPsi } = computeKuramotoOrderParameter(nextPhases);
  
  // Synchronization trend
  const synchronizing = nextR > R;
  const dR = nextR - R;
  
  // Phase coherence map (how close each oscillator is to mean phase)
  const coherenceMap = phases.map((theta, i) => ({
    index: i,
    phase: theta,
    deviation: Math.abs(((theta - psi + Math.PI) % TWO_PI) - Math.PI),
    coherent: Math.abs(((theta - psi + Math.PI) % TWO_PI) - Math.PI) < (Math.PI / PHI),
  }));
  
  return {
    protocol: 'PROTO-228',
    name: 'Alpha Resonance',
    brainAnalog: 'Thalamocortical binding',
    orderParameter: R,
    meanPhase: psi,
    nextOrderParameter: nextR,
    nextMeanPhase: nextPsi,
    resonant,
    threshold,
    synchronizing,
    dR,
    couplingConstant: K,
    oscillatorCount: phases.length,
    coherenceMap,
    nextPhases,
    phi: PHI,
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-229: ALPHA SIGNAL PROTOCOL
// Brain analog: Dorsolateral Prefrontal Cortex (dlPFC) working memory gate
//
// priority_score(p) = p / φ
//   CRITICAL (p=0): score = 0
//   HIGH     (p=1): score = 0.618
//   NORMAL   (p=2): score = 1.236
//   LOW      (p=3): score = 1.854
//
// The dlPFC does not process everything. It gates. It decides which signals
// deserve to enter working memory and which are suppressed. This gating is
// weighted by salience, urgency, and context.
//
// Each priority level is exactly φ times less urgent than the one above it —
// so the ratio between any two adjacent priority levels is the golden ratio.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute phi-weighted priority score
 * @param {number} priority - Priority level (0=CRITICAL, 1=HIGH, 2=NORMAL, 3=LOW)
 * @returns {number} Priority score (lower = more urgent)
 */
function computePriorityScore(priority) {
  return priority / PHI;
}

/**
 * Create a prioritized signal
 * @param {*} payload - Signal payload
 * @param {number} priority - Priority level (0-3)
 * @param {Object} [metadata] - Optional metadata
 * @returns {Object} Prioritized signal
 */
function createSignal(payload, priority, metadata = {}) {
  const clampedPriority = Math.max(0, Math.min(3, Math.floor(priority)));
  const score = computePriorityScore(clampedPriority);
  const priorityName = ['CRITICAL', 'HIGH', 'NORMAL', 'LOW'][clampedPriority];
  
  return {
    payload,
    priority: clampedPriority,
    priorityName,
    score,
    salience: Math.max(0, Math.min(1, 1 - (score / (3 / PHI)))), // Clamped salience [0,1]
    timestamp: Date.now(),
    id: `signal-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
    metadata,
  };
}

/**
 * PROTO-229: Alpha Signal Protocol
 * Phi-weighted priority queue with dlPFC-style gating
 * 
 * @param {Array} signals - Array of {payload, priority} objects
 * @param {Object} [options] - Optional parameters
 * @param {number} [options.gateThreshold] - Salience threshold for admission (default: φ⁻²)
 * @param {number} [options.maxCapacity] - Working memory capacity (default: F8 = 21)
 * @returns {Object} Prioritized queue with gating results
 */
function alphaSignal(signals, options = {}) {
  const gateThreshold = options.gateThreshold ?? (PHI_INV * PHI_INV); // φ⁻² ≈ 0.382
  const maxCapacity = options.maxCapacity ?? FIB[7]; // F8 = 21
  
  // Process all signals
  const processed = signals.map((s, i) => ({
    ...createSignal(s.payload, s.priority, s.metadata),
    originalIndex: i,
  }));
  
  // Gate: only signals above salience threshold enter working memory
  const admitted = processed.filter(s => s.salience >= gateThreshold);
  const suppressed = processed.filter(s => s.salience < gateThreshold);
  
  // Sort admitted by score (ascending = more urgent first)
  admitted.sort((a, b) => a.score - b.score);
  
  // Capacity limit (working memory constraint)
  const inWorkingMemory = admitted.slice(0, maxCapacity);
  const overflow = admitted.slice(maxCapacity);
  
  // Priority distribution
  const distribution = {
    CRITICAL: inWorkingMemory.filter(s => s.priority === 0).length,
    HIGH: inWorkingMemory.filter(s => s.priority === 1).length,
    NORMAL: inWorkingMemory.filter(s => s.priority === 2).length,
    LOW: inWorkingMemory.filter(s => s.priority === 3).length,
  };
  
  return {
    protocol: 'PROTO-229',
    name: 'Alpha Signal',
    brainAnalog: 'dlPFC working memory gate',
    inWorkingMemory,
    overflow,
    suppressed,
    gateThreshold,
    maxCapacity,
    distribution,
    totalSignals: signals.length,
    admittedCount: admitted.length,
    suppressedCount: suppressed.length,
    loadFactor: inWorkingMemory.length / maxCapacity,
    phi: PHI,
    priorityScores: {
      CRITICAL: computePriorityScore(0),
      HIGH: computePriorityScore(1),
      NORMAL: computePriorityScore(2),
      LOW: computePriorityScore(3),
    },
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-230: ALPHA REWARD PROTOCOL
// Brain analog: VTA → NAcc mesolimbic dopamine pathway
//
// P = frontPower  (compressed synthesis output, P ∈ [0, φ))
// C = thoughtConfidence  (MiniBrain confidence, C ∈ [0, 1])
// Gate: fires only if P > φ⁻¹
// DA impulse = (P − φ⁻¹) × φ × 0.12
// OX impulse = C × φ⁻¹ × 0.08
//
// This is the brain's reward prediction circuit. The VTA fires dopamine not
// when a reward is received, but when a reward is *predicted with high
// confidence and confirmed*. The dopamine burst is proportional to the
// prediction error — how much better the outcome was than expected.
//
// THE CRITICAL CONSEQUENCE:
// The system is self-reinforcing in two independent, complementary ways:
// 1. Hebbian path: synthesis → synapse weight ↑ → confidence ↑ → frontPower ↑
// 2. Dopaminergic path: frontPower → DA impulse → arousal ↑ → attention ↑
// These loops reinforce each other. This is emergent optimization.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute dopamine impulse from synthesis output
 * DA impulse = (P − φ⁻¹) × φ × 0.12
 * 
 * @param {number} frontPower - Synthesis output power P ∈ [0, φ)
 * @returns {number} Dopamine impulse (0 if gate not triggered)
 */
function computeDopamineImpulse(frontPower) {
  const gateThreshold = PHI_INV;
  if (frontPower <= gateThreshold) return 0;
  
  // DA impulse = (P − φ⁻¹) × φ × 0.12
  return (frontPower - gateThreshold) * PHI * 0.12;
}

/**
 * Compute oxytocin impulse from confidence
 * OX impulse = C × φ⁻¹ × 0.08
 * 
 * @param {number} confidence - Thought confidence C ∈ [0, 1]
 * @returns {number} Oxytocin impulse
 */
function computeOxytocinImpulse(confidence) {
  // OX impulse = C × φ⁻¹ × 0.08
  return confidence * PHI_INV * 0.08;
}

/**
 * PROTO-230: Alpha Reward Protocol
 * Dopamine/oxytocin reward gating with φ⁻¹ threshold
 * 
 * @param {number} frontPower - Synthesis output power P ∈ [0, φ)
 * @param {number} thoughtConfidence - MiniBrain confidence C ∈ [0, 1]
 * @param {Object} [options] - Optional parameters
 * @param {number} [options.gateThreshold] - Reward gate threshold (default: φ⁻¹)
 * @param {number} [options.daMultiplier] - DA scaling factor (default: 0.12)
 * @param {number} [options.oxMultiplier] - OX scaling factor (default: 0.08)
 * @returns {Object} Reward impulses and neurochemical state
 */
function alphaReward(frontPower, thoughtConfidence, options = {}) {
  const gateThreshold = options.gateThreshold ?? PHI_INV;
  const daMultiplier = options.daMultiplier ?? 0.12;
  const oxMultiplier = options.oxMultiplier ?? 0.08;
  
  // Clamp inputs
  const P = Math.max(0, Math.min(PHI, frontPower));
  const C = Math.max(0, Math.min(1, thoughtConfidence));
  
  // Gate evaluation
  const gateTriggered = P > gateThreshold;
  
  // Dopamine impulse (reward prediction error)
  const daImpulse = gateTriggered
    ? (P - gateThreshold) * PHI * daMultiplier
    : 0;
  
  // Oxytocin impulse (social bonding signal)
  const oxImpulse = C * PHI_INV * oxMultiplier;
  
  // Combined affective arousal
  const affectiveArousal = daImpulse + oxImpulse;
  
  // Hebbian weight update suggestion (for MiniBrain integration)
  // Higher reward → stronger synapse reinforcement
  const hebbianBoost = gateTriggered ? daImpulse * PHI_INV : 0;
  
  // Attentional amplification (for next synthesis cycle)
  const attentionalGain = 1 + affectiveArousal * PHI;
  
  return {
    protocol: 'PROTO-230',
    name: 'Alpha Reward',
    brainAnalog: 'VTA → NAcc mesolimbic pathway',
    frontPower: P,
    thoughtConfidence: C,
    gateThreshold,
    gateTriggered,
    dopamineImpulse: daImpulse,
    oxytocinImpulse: oxImpulse,
    affectiveArousal,
    hebbianBoost,
    attentionalGain,
    neurochemistry: {
      DA: daImpulse,
      OX: oxImpulse,
      total: affectiveArousal,
    },
    reinforcementPaths: {
      hebbian: hebbianBoost > 0 ? 'active' : 'dormant',
      dopaminergic: gateTriggered ? 'firing' : 'subthreshold',
    },
    phi: PHI,
    phiInv: PHI_INV,
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// MINIBRAIN INTEGRATION — Synapse and Hebbian Learning
// These utilities connect PROTO-230 to the organism's MiniBrain architecture
// ═══════════════════════════════════════════════════════════════════════════

/**
 * MiniBrain synapse state
 */
class MiniBrainSynapse {
  constructor(initialWeight = 0.5) {
    this.weight = Math.max(0, Math.min(1, initialWeight));
    this.callCount = 0;
    this.cumulativeReward = 0;
    this.lastConfidence = 0;
    this.learningRate = 0.01; // η
  }
  
  /**
   * Hebbian weight update: Δw = η × stimulus × response
   * @param {number} stimulus - Input activation
   * @param {number} response - Output activation
   * @param {number} [boost] - Additional boost from PROTO-230
   */
  hebbianUpdate(stimulus, response, boost = 0) {
    const deltaW = this.learningRate * stimulus * response + boost;
    this.weight = Math.max(0, Math.min(1, this.weight + deltaW));
    this.callCount++;
    return this.weight;
  }
  
  /**
   * Apply decay (forgetting)
   * @param {number} decayRate - Decay factor (default: 0.001)
   */
  decay(decayRate = 0.001) {
    this.weight *= (1 - decayRate);
  }
  
  /**
   * Compute confidence based on weight and call count
   * Higher weight + more calls = higher confidence
   */
  getConfidence() {
    const callFactor = Math.tanh(this.callCount / 100); // Saturates ~1 after 300+ calls
    this.lastConfidence = this.weight * (0.5 + 0.5 * callFactor);
    return this.lastConfidence;
  }
}

/**
 * Synthesize middle layer output with full protocol integration
 * This is the central function that ties PROTO-227–230 together
 * 
 * @param {number} stimulus - Input stimulus
 * @param {MiniBrainSynapse} synapse - Synapse state
 * @param {Object} [context] - Fleet context for emergence
 * @returns {Object} Synthesis result with reward feedback
 */
function synthesizeMathMiddle(stimulus, synapse, context = {}) {
  // Stimulus-response computation
  const response = Math.tanh(stimulus * synapse.weight * PHI);
  
  // Confidence from synapse state
  const confidence = synapse.getConfidence();
  
  // Front power: compressed synthesis output
  // frontPower ∈ [0, φ) — tanh maps to (-1,1), we scale to (0, φ)
  const frontPower = (response + 1) * (PHI / 2);
  
  // PROTO-230: Get reward impulses
  const reward = alphaReward(frontPower, confidence);
  
  // Hebbian update with reward boost
  synapse.hebbianUpdate(stimulus, response, reward.hebbianBoost);
  synapse.cumulativeReward += reward.dopamineImpulse;
  
  // Emergence contribution (for PROTO-227 fleet aggregation)
  const emergence = (response + 1) / 2; // Normalized [0,1]
  
  return {
    stimulus,
    response,
    frontPower,
    confidence,
    emergence,
    synapseWeight: synapse.weight,
    callCount: synapse.callCount,
    cumulativeReward: synapse.cumulativeReward,
    reward,
    phi: PHI,
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// NEUROCHEMISTRY ENGINE INTEGRATION
// Inject impulses into the NeurochemistryEngine
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Create neurochemical delta from PROTO-230 reward
 * @param {Object} reward - Result from alphaReward()
 * @returns {Array} Array of neurochemical deltas
 */
function rewardToNeurochemistryDeltas(reward) {
  const deltas = [];
  const timestamp = Date.now();
  
  if (reward.dopamineImpulse > 0) {
    deltas.push({
      analog: 'DOPAMINE',
      delta: reward.dopamineImpulse,
      source: 'PROTO-230',
      timestamp,
    });
  }
  
  if (reward.oxytocinImpulse > 0) {
    deltas.push({
      analog: 'OXYTOCIN',
      delta: reward.oxytocinImpulse,
      source: 'PROTO-230',
      timestamp,
    });
  }
  
  // Arousal affects norepinephrine
  if (reward.affectiveArousal > 0.01) {
    deltas.push({
      analog: 'NOREPINEPHRINE',
      delta: reward.affectiveArousal * 0.5,
      source: 'PROTO-230',
      timestamp,
    });
  }
  
  return deltas;
}

// ═══════════════════════════════════════════════════════════════════════════
// MODULE EXPORTS (ES Module syntax)
// ═══════════════════════════════════════════════════════════════════════════

export {
  // Constants
  PHI,
  PHI_INV,
  PHI_SQUARED,
  PHI_CUBED,
  HEARTBEAT,
  PRIORITY_LEVELS,
  FIB,
  
  // PROTO-227: Emergence Cascade
  computeEmergenceScore,
  emergenceCascade,
  
  // PROTO-228: Alpha Resonance
  computeKuramotoOrderParameter,
  advanceKuramotoPhases,
  alphaResonance,
  
  // PROTO-229: Alpha Signal
  computePriorityScore,
  createSignal,
  alphaSignal,
  
  // PROTO-230: Alpha Reward
  computeDopamineImpulse,
  computeOxytocinImpulse,
  alphaReward,
  
  // MiniBrain Integration
  MiniBrainSynapse,
  synthesizeMathMiddle,
  
  // Neurochemistry Integration
  rewardToNeurochemistryDeltas,
};

// Default export for convenience
export default {
  PHI,
  PHI_INV,
  PHI_SQUARED,
  PHI_CUBED,
  HEARTBEAT,
  PRIORITY_LEVELS,
  FIB,
  computeEmergenceScore,
  emergenceCascade,
  computeKuramotoOrderParameter,
  advanceKuramotoPhases,
  alphaResonance,
  computePriorityScore,
  createSignal,
  alphaSignal,
  computeDopamineImpulse,
  computeOxytocinImpulse,
  alphaReward,
  MiniBrainSynapse,
  synthesizeMathMiddle,
  rewardToNeurochemistryDeltas,
};
