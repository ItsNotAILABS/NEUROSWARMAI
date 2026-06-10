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
// ║  This source code implements the HEBBIAN PLASTICITY ENGINE of the Medina Doctrine.                       ║
// ║  It mirrors the backend Motoko architecture for frontend visualization and simulation.                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// HEBBIAN PLASTICITY ENGINE — LEARNING THROUGH SYNCHRONY
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// "NEURONS THAT FIRE TOGETHER, WIRE TOGETHER"
// ────────────────────────────────────────────
//
// This is the fundamental law of learning. When two neurons activate at the same time,
// the connection between them strengthens. When they activate out of sync, it weakens.
//
// MATHEMATICAL FORMULATION:
// ─────────────────────────
// Basic Hebbian Rule:
//   Δw_ij = η × pre_i × post_j
//
// With decay to prevent saturation:
//   Δw_ij = η × pre_i × post_j - λ × w_ij
//
// STDP (Spike-Timing Dependent Plasticity):
//   Δw = A+ × exp(-Δt/τ+)  if Δt > 0 (pre before post → LTP)
//   Δw = -A- × exp(Δt/τ-)  if Δt < 0 (post before pre → LTD)
//
// BCM (Bienenstock-Cooper-Munro) Rule:
//   Δw = η × pre × post × (post - θ_M)
//   dθ_M/dt = (post² - θ_M) / τ_BCM
//
// Where θ_M is the sliding threshold that adapts to activity history.
//
// ARCHITECTURE:
// ─────────────
// - 12×12 = 144 weights per shell (inner Hebbian ring)
// - 11 shells with decreasing plasticity (HELIX_ALPHA: 0.042 → 0.004)
// - Eligibility traces for reward-modulated learning
// - Metaplasticity for stability/plasticity balance
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import {
  HELIX_ALPHA,
  NUM_SHELLS,
  PI,
  SHELL_CONFIGS,
  S_ZERO_FLOOR,
  type ShellId,
  type ShellName,
  TWO_PI,
} from "./consciousnessEngine";

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 1: PLASTICITY CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

// Learning rate base (η)
export const ETA_BASE = 0.005;

// Weight decay constant (prevents saturation)
export const WEIGHT_DECAY = 0.001;

// Minimum and maximum weight bounds
export const W_MIN = 0.0;
export const W_MAX = 1.0;

// STDP time constants (milliseconds)
export const TAU_PLUS = 20.0; // LTP time constant
export const TAU_MINUS = 20.0; // LTD time constant
export const A_PLUS = 0.01; // LTP amplitude
export const A_MINUS = 0.012; // LTD amplitude (slightly larger for balance)

// BCM parameters
export const BCM_TAU = 1000.0; // Time constant for threshold sliding
export const BCM_TARGET = 0.5; // Target activity level

// Inner ring size (12 Hz nodes)
export const RING_SIZE = 12;
export const WEIGHTS_PER_SHELL = RING_SIZE * RING_SIZE; // 144

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 2: SYNAPSE TYPE — Individual connection between two Hz nodes
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface Synapse {
  preId: number; // Pre-synaptic node index (0-11)
  postId: number; // Post-synaptic node index (0-11)
  weight: number; // Synaptic strength [0, 1]
  eligibilityTrace: number; // For reward-modulated learning
  lastPreSpike: number; // Beat of last pre-synaptic activation
  lastPostSpike: number; // Beat of last post-synaptic activation
  stdpAccumulator: number; // Accumulated STDP changes
  ltpHistory: number; // Running average of LTP events
  ltdHistory: number; // Running average of LTD events
}

export function initSynapse(preId: number, postId: number): Synapse {
  // Initial weight: small random-ish value based on indices
  const base = 0.3;
  const variation = ((preId * 7 + postId * 13) % 100) / 500.0;

  return {
    preId,
    postId,
    weight: base + variation,
    eligibilityTrace: 0.0,
    lastPreSpike: -1000, // Long ago
    lastPostSpike: -1000,
    stdpAccumulator: 0.0,
    ltpHistory: 0.0,
    ltdHistory: 0.0,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 3: WEIGHT MATRIX — 12×12 = 144 connections per shell
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface WeightMatrix {
  weights: number[][]; // 12×12 matrix
  eligibility: number[][]; // Eligibility traces
  lastPreSpikes: number[]; // Last spike time per pre-node
  lastPostSpikes: number[]; // Last spike time per post-node
  ltpCount: number; // Total LTP events
  ltdCount: number; // Total LTD events
  lastUpdate: number; // Timestamp
}

export function initWeightMatrix(): WeightMatrix {
  const weights: number[][] = [];
  const eligibility: number[][] = [];

  for (let i = 0; i < RING_SIZE; i++) {
    const row: number[] = [];
    const eligRow: number[] = [];

    for (let j = 0; j < RING_SIZE; j++) {
      // Initial weights: 0.3 + small variation based on indices
      const base = 0.3;
      const variation = ((i * 7 + j * 13) % 100) / 500.0;
      row.push(base + variation);
      eligRow.push(0.0);
    }

    weights.push(row);
    eligibility.push(eligRow);
  }

  return {
    weights,
    eligibility,
    lastPreSpikes: new Array(RING_SIZE).fill(-1000),
    lastPostSpikes: new Array(RING_SIZE).fill(-1000),
    ltpCount: 0,
    ltdCount: 0,
    lastUpdate: Date.now(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 4: SHELL PLASTICITY STATE — Per-shell learning state
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface ShellPlasticityState {
  shellId: ShellId;
  shellName: ShellName;
  helixAlpha: number; // Shell-specific learning rate

  // Weight matrix
  weightMatrix: WeightMatrix;

  // Node activations
  nodeActivations: number[]; // Current activation of each Hz node [0, 1]
  nodeThresholds: number[]; // Firing thresholds

  // BCM state
  bcmThreshold: number; // Sliding threshold
  bcmHistory: number[]; // History of threshold values

  // Metaplasticity
  metaplasticState: number; // Modulates learning rate
  plasticityHistory: number[]; // History of plasticity changes

  // Statistics
  totalLTP: number; // Total LTP events
  totalLTD: number; // Total LTD events
  avgWeight: number; // Average weight
  weightVariance: number; // Weight variance
}

export function initShellPlasticity(shellId: ShellId): ShellPlasticityState {
  const config = SHELL_CONFIGS[shellId];

  return {
    shellId,
    shellName: config.name,
    helixAlpha: config.helixAlpha,

    weightMatrix: initWeightMatrix(),

    nodeActivations: new Array(RING_SIZE).fill(0.0),
    nodeThresholds: new Array(RING_SIZE).fill(0.5),

    bcmThreshold: BCM_TARGET,
    bcmHistory: [],

    metaplasticState: 1.0,
    plasticityHistory: [],

    totalLTP: 0,
    totalLTD: 0,
    avgWeight: 0.3,
    weightVariance: 0.01,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 5: STDP — Spike-Timing Dependent Plasticity
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// STDP captures the temporal causality of neural firing:
//
// If pre fires before post (Δt > 0):
//   The pre neuron might have CAUSED the post to fire → STRENGTHEN connection (LTP)
//   Δw = A+ × exp(-Δt/τ+)
//
// If post fires before pre (Δt < 0):
//   The pre neuron did NOT cause the post to fire → WEAKEN connection (LTD)
//   Δw = -A- × exp(Δt/τ-)
//
// This creates a learning window of ~50ms where timing matters.

/**
 * Compute STDP weight change based on spike timing
 */
export function computeSTDP(
  deltaT: number, // post_spike_time - pre_spike_time
  aPlus: number = A_PLUS,
  aMinus: number = A_MINUS,
  tauPlus: number = TAU_PLUS,
  tauMinus: number = TAU_MINUS,
): { deltaW: number; isLTP: boolean } {
  if (deltaT > 0) {
    // Pre before post → LTP (potentiation)
    const deltaW = aPlus * Math.exp(-deltaT / tauPlus);
    return { deltaW, isLTP: true };
  }
  if (deltaT < 0) {
    // Post before pre → LTD (depression)
    const deltaW = -aMinus * Math.exp(deltaT / tauMinus);
    return { deltaW, isLTP: false };
  }
  // Simultaneous (Δt = 0) → No change
  return { deltaW: 0, isLTP: false };
}

/**
 * Apply STDP to a single synapse
 */
export function applySTDP(
  synapse: Synapse,
  preActivation: number,
  postActivation: number,
  currentBeat: number,
  helixAlpha: number,
): Synapse {
  const updated = { ...synapse };

  // Check if pre and post are active (above threshold)
  const preActive = preActivation > 0.5;
  const postActive = postActivation > 0.5;

  // Update spike times
  if (preActive && synapse.lastPreSpike < currentBeat) {
    updated.lastPreSpike = currentBeat;
  }
  if (postActive && synapse.lastPostSpike < currentBeat) {
    updated.lastPostSpike = currentBeat;
  }

  // Compute STDP if both have recent spikes
  const deltaT = updated.lastPostSpike - updated.lastPreSpike;
  const { deltaW, isLTP } = computeSTDP(deltaT);

  // Accumulate STDP change
  updated.stdpAccumulator += deltaW * helixAlpha;

  // Update running averages
  const decay = 0.99;
  if (isLTP) {
    updated.ltpHistory =
      decay * synapse.ltpHistory + (1 - decay) * Math.abs(deltaW);
  } else {
    updated.ltdHistory =
      decay * synapse.ltdHistory + (1 - decay) * Math.abs(deltaW);
  }

  // Apply accumulated changes to weight
  updated.weight = clamp(
    synapse.weight + updated.stdpAccumulator,
    W_MIN,
    W_MAX,
  );

  // Decay the accumulator
  updated.stdpAccumulator *= 0.9;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 6: BCM RULE — Bienenstock-Cooper-Munro Theory
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// BCM provides a sliding threshold that stabilizes learning:
//
// Δw = η × pre × post × (post - θ_M)
//
// - If post > θ_M: Connection strengthens (LTP)
// - If post < θ_M: Connection weakens (LTD)
//
// The threshold θ_M slides based on recent activity:
// dθ_M/dt = (post² - θ_M) / τ_BCM
//
// This prevents runaway excitation: high activity → high threshold → harder to potentiate

/**
 * Update BCM sliding threshold
 */
export function updateBCMThreshold(
  currentThreshold: number,
  postActivity: number,
  tau: number = BCM_TAU,
): number {
  // dθ_M/dt = (post² - θ_M) / τ_BCM
  const targetThreshold = postActivity * postActivity;
  const delta = (targetThreshold - currentThreshold) / tau;
  return currentThreshold + delta;
}

/**
 * Compute BCM weight change
 */
export function computeBCM(
  preActivity: number,
  postActivity: number,
  threshold: number,
  eta: number = ETA_BASE,
): number {
  // Δw = η × pre × post × (post - θ_M)
  return eta * preActivity * postActivity * (postActivity - threshold);
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 7: ELIGIBILITY TRACES — For reward-modulated learning
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Eligibility traces solve the temporal credit assignment problem:
// How does a reward arriving seconds later know which synapses to strengthen?
//
// When pre and post fire together, the synapse becomes "eligible" for modification.
// This eligibility decays over time. When reward arrives, all eligible synapses
// are strengthened proportionally.
//
// e_ij(t+1) = γ × e_ij(t) + pre_i × post_j
// Δw_ij = η × e_ij × reward

export const ELIGIBILITY_DECAY = 0.95;

/**
 * Update eligibility trace for a synapse
 */
export function updateEligibility(
  currentEligibility: number,
  preActivity: number,
  postActivity: number,
  decay: number = ELIGIBILITY_DECAY,
): number {
  // e(t+1) = γ × e(t) + pre × post
  return decay * currentEligibility + preActivity * postActivity;
}

/**
 * Apply reward-modulated learning
 */
export function applyRewardModulation(
  weight: number,
  eligibility: number,
  reward: number,
  eta: number = ETA_BASE,
): number {
  // Δw = η × e × reward
  const deltaW = eta * eligibility * reward;
  return clamp(weight + deltaW, W_MIN, W_MAX);
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 8: METAPLASTICITY — Plasticity of plasticity
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Metaplasticity modulates the learning rate itself based on history:
//
// - After lots of LTP: Learning rate decreases (harder to potentiate more)
// - After lots of LTD: Learning rate increases (easier to potentiate)
//
// This maintains the stability/plasticity balance.

export interface MetaplasticityState {
  currentModulator: number; // Current multiplier for learning rate [0.5, 2.0]
  ltpAccumulator: number; // Running total of LTP
  ltdAccumulator: number; // Running total of LTD
  history: number[]; // History of modulator values
}

export function initMetaplasticity(): MetaplasticityState {
  return {
    currentModulator: 1.0,
    ltpAccumulator: 0.0,
    ltdAccumulator: 0.0,
    history: [],
  };
}

/**
 * Update metaplasticity state
 */
export function updateMetaplasticity(
  state: MetaplasticityState,
  recentLTP: number,
  recentLTD: number,
): MetaplasticityState {
  const updated = { ...state };

  // Accumulate with decay
  const decay = 0.999;
  updated.ltpAccumulator = decay * state.ltpAccumulator + recentLTP;
  updated.ltdAccumulator = decay * state.ltdAccumulator + recentLTD;

  // Compute modulator based on LTP/LTD balance
  const balance = updated.ltpAccumulator - updated.ltdAccumulator;

  // If more LTP than LTD: decrease learning rate (harder to potentiate)
  // If more LTD than LTP: increase learning rate (easier to potentiate)
  updated.currentModulator = 1.0 / (1.0 + 0.1 * balance);
  updated.currentModulator = clamp(updated.currentModulator, 0.5, 2.0);

  // Record history
  updated.history = [...state.history.slice(-99), updated.currentModulator];

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 9: HEBBIAN UPDATE — Full weight matrix update
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface HebbianUpdateResult {
  weightMatrix: WeightMatrix;
  ltpEvents: number;
  ltdEvents: number;
  avgChange: number;
  maxChange: number;
}

/**
 * Perform full Hebbian update on weight matrix
 */
export function hebbianUpdate(
  matrix: WeightMatrix,
  activations: number[],
  helixAlpha: number,
  bcmThreshold: number,
  metaplasticModulator: number,
  currentBeat: number,
  reward = 0,
): HebbianUpdateResult {
  const newWeights: number[][] = [];
  const newEligibility: number[][] = [];
  let ltpEvents = 0;
  let ltdEvents = 0;
  let totalChange = 0;
  let maxChange = 0;
  let changeCount = 0;

  const effectiveEta = helixAlpha * metaplasticModulator;

  for (let i = 0; i < RING_SIZE; i++) {
    const weightRow: number[] = [];
    const eligRow: number[] = [];

    for (let j = 0; j < RING_SIZE; j++) {
      const pre = activations[i];
      const post = activations[j];
      const oldWeight = matrix.weights[i][j];
      const oldElig = matrix.eligibility[i][j];

      // 1. Basic Hebbian term with decay
      const hebbianTerm = effectiveEta * pre * post - WEIGHT_DECAY * oldWeight;

      // 2. BCM term
      const bcmTerm = computeBCM(pre, post, bcmThreshold, effectiveEta * 0.5);

      // 3. STDP term (simplified - using activation levels as proxy)
      const preSpikeTime = matrix.lastPreSpikes[i];
      const postSpikeTime = matrix.lastPostSpikes[j];
      const deltaT = postSpikeTime - preSpikeTime;
      const { deltaW: stdpTerm, isLTP: _isLTP } = computeSTDP(deltaT);

      // 4. Update eligibility trace
      const newElig = updateEligibility(oldElig, pre, post);

      // 5. Reward-modulated term
      const rewardTerm = reward * newElig * effectiveEta;

      // 6. Combine all terms
      const totalDelta =
        hebbianTerm + bcmTerm + stdpTerm * effectiveEta + rewardTerm;

      // 7. Apply with bounds
      const newWeight = clamp(oldWeight + totalDelta, W_MIN, W_MAX);

      // Track statistics
      const change = Math.abs(newWeight - oldWeight);
      totalChange += change;
      maxChange = Math.max(maxChange, change);
      changeCount++;

      if (newWeight > oldWeight) {
        ltpEvents++;
      } else if (newWeight < oldWeight) {
        ltdEvents++;
      }

      weightRow.push(newWeight);
      eligRow.push(newElig);
    }

    newWeights.push(weightRow);
    newEligibility.push(eligRow);
  }

  // Update spike times based on activations
  const newPreSpikes = [...matrix.lastPreSpikes];
  const newPostSpikes = [...matrix.lastPostSpikes];
  for (let i = 0; i < RING_SIZE; i++) {
    if (activations[i] > 0.5) {
      newPreSpikes[i] = currentBeat;
      newPostSpikes[i] = currentBeat;
    }
  }

  return {
    weightMatrix: {
      weights: newWeights,
      eligibility: newEligibility,
      lastPreSpikes: newPreSpikes,
      lastPostSpikes: newPostSpikes,
      ltpCount: matrix.ltpCount + ltpEvents,
      ltdCount: matrix.ltdCount + ltdEvents,
      lastUpdate: Date.now(),
    },
    ltpEvents,
    ltdEvents,
    avgChange: changeCount > 0 ? totalChange / changeCount : 0,
    maxChange,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 10: SHELL PLASTICITY UPDATE — Update single shell
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function updateShellPlasticity(
  shell: ShellPlasticityState,
  activations: number[],
  currentBeat: number,
  reward = 0,
): ShellPlasticityState {
  const updated = { ...shell };

  // Update node activations
  updated.nodeActivations = [...activations];

  // Update BCM threshold
  const avgActivity =
    activations.reduce((a, b) => a + b, 0) / activations.length;
  updated.bcmThreshold = updateBCMThreshold(shell.bcmThreshold, avgActivity);
  updated.bcmHistory = [...shell.bcmHistory.slice(-99), updated.bcmThreshold];

  // Perform Hebbian update
  const hebbianResult = hebbianUpdate(
    shell.weightMatrix,
    activations,
    shell.helixAlpha,
    updated.bcmThreshold,
    shell.metaplasticState,
    currentBeat,
    reward,
  );

  updated.weightMatrix = hebbianResult.weightMatrix;
  updated.totalLTP += hebbianResult.ltpEvents;
  updated.totalLTD += hebbianResult.ltdEvents;

  // Update metaplasticity
  const ltpRate = hebbianResult.ltpEvents / WEIGHTS_PER_SHELL;
  const ltdRate = hebbianResult.ltdEvents / WEIGHTS_PER_SHELL;

  // Simple metaplasticity update
  const balance = ltpRate - ltdRate;
  updated.metaplasticState = clamp(
    shell.metaplasticState * (1.0 - 0.01 * balance),
    0.5,
    2.0,
  );
  updated.plasticityHistory = [
    ...shell.plasticityHistory.slice(-99),
    hebbianResult.avgChange,
  ];

  // Compute weight statistics
  let sum = 0;
  let sumSq = 0;
  for (let i = 0; i < RING_SIZE; i++) {
    for (let j = 0; j < RING_SIZE; j++) {
      const w = updated.weightMatrix.weights[i][j];
      sum += w;
      sumSq += w * w;
    }
  }
  updated.avgWeight = sum / WEIGHTS_PER_SHELL;
  updated.weightVariance =
    sumSq / WEIGHTS_PER_SHELL - updated.avgWeight * updated.avgWeight;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 11: GLOBAL PLASTICITY STATE — All shells
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface GlobalPlasticityState {
  shells: ShellPlasticityState[];
  totalLTP: number;
  totalLTD: number;
  globalAvgWeight: number;
  lastUpdate: number;
}

export function initGlobalPlasticity(): GlobalPlasticityState {
  const shells: ShellPlasticityState[] = [];
  for (let i = 0; i < NUM_SHELLS; i++) {
    shells.push(initShellPlasticity(i as ShellId));
  }

  return {
    shells,
    totalLTP: 0,
    totalLTD: 0,
    globalAvgWeight: 0.3,
    lastUpdate: Date.now(),
  };
}

/**
 * Update all shells' plasticity
 */
export function updateGlobalPlasticity(
  state: GlobalPlasticityState,
  shellActivations: number[][], // 11 arrays of 12 activations each
  currentBeat: number,
  reward = 0,
): GlobalPlasticityState {
  const updated = { ...state };

  let totalLTP = 0;
  let totalLTD = 0;
  let totalAvgWeight = 0;

  updated.shells = state.shells.map((shell, i) => {
    const activations = shellActivations[i] || new Array(RING_SIZE).fill(0);
    const updatedShell = updateShellPlasticity(
      shell,
      activations,
      currentBeat,
      reward,
    );

    totalLTP += updatedShell.totalLTP;
    totalLTD += updatedShell.totalLTD;
    totalAvgWeight += updatedShell.avgWeight;

    return updatedShell;
  });

  updated.totalLTP = totalLTP;
  updated.totalLTD = totalLTD;
  updated.globalAvgWeight = totalAvgWeight / NUM_SHELLS;
  updated.lastUpdate = Date.now();

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 12: WEIGHT VISUALIZATION
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface WeightVisualization {
  shellId: ShellId;
  shellName: ShellName;
  matrix: number[][]; // 12×12 weights
  minWeight: number;
  maxWeight: number;
  avgWeight: number;
  strongConnections: Array<{ from: number; to: number; weight: number }>;
  weakConnections: Array<{ from: number; to: number; weight: number }>;
}

export function getWeightVisualization(
  shell: ShellPlasticityState,
): WeightVisualization {
  const matrix = shell.weightMatrix.weights;

  let minWeight = 1.0;
  let maxWeight = 0.0;
  let sum = 0;
  const connections: Array<{ from: number; to: number; weight: number }> = [];

  for (let i = 0; i < RING_SIZE; i++) {
    for (let j = 0; j < RING_SIZE; j++) {
      const w = matrix[i][j];
      minWeight = Math.min(minWeight, w);
      maxWeight = Math.max(maxWeight, w);
      sum += w;
      connections.push({ from: i, to: j, weight: w });
    }
  }

  connections.sort((a, b) => b.weight - a.weight);

  return {
    shellId: shell.shellId,
    shellName: shell.shellName,
    matrix,
    minWeight,
    maxWeight,
    avgWeight: sum / WEIGHTS_PER_SHELL,
    strongConnections: connections.slice(0, 10),
    weakConnections: connections.slice(-10).reverse(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 13: DIAGNOSTICS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function getPlasticityDiagnostics(state: GlobalPlasticityState): string {
  const lines: string[] = [
    "═══════════════════════════════════════════════════════════════════════════════",
    "                    HEBBIAN PLASTICITY ENGINE DIAGNOSTICS                      ",
    "                              MEDINA DOCTRINE                                  ",
    "═══════════════════════════════════════════════════════════════════════════════",
    "",
    `Total LTP Events: ${state.totalLTP.toLocaleString()}`,
    `Total LTD Events: ${state.totalLTD.toLocaleString()}`,
    `LTP/LTD Ratio: ${state.totalLTD > 0 ? (state.totalLTP / state.totalLTD).toFixed(2) : "∞"}`,
    `Global Avg Weight: ${state.globalAvgWeight.toFixed(4)}`,
    "",
    "─── PER-SHELL PLASTICITY ─────────────────────────────────────────────────────",
  ];

  for (const shell of state.shells) {
    lines.push(
      `  ${shell.shellName.padEnd(12)} | ` +
        `α: ${shell.helixAlpha.toFixed(3)} | ` +
        `BCM θ: ${shell.bcmThreshold.toFixed(3)} | ` +
        `Meta: ${shell.metaplasticState.toFixed(2)} | ` +
        `Avg W: ${shell.avgWeight.toFixed(3)}`,
    );
  }

  lines.push("");
  lines.push(
    "─── CANONICAL VALUES ─────────────────────────────────────────────────────────",
  );
  lines.push(`  HELIX_ALPHA (canonical): ${HELIX_ALPHA}`);
  lines.push(`  ETA_BASE: ${ETA_BASE}`);
  lines.push(`  STDP τ+: ${TAU_PLUS}ms`);
  lines.push(`  STDP τ-: ${TAU_MINUS}ms`);
  lines.push(`  BCM τ: ${BCM_TAU}`);
  lines.push(`  Weight bounds: [${W_MIN}, ${W_MAX}]`);
  lines.push("");
  lines.push(
    "═══════════════════════════════════════════════════════════════════════════════",
  );

  return lines.join("\n");
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 14: UTILITY FUNCTIONS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}
