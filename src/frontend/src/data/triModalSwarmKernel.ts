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
// ║  TRI-MODAL SWARM KERNEL — SCALE-INVARIANT RUNTIME ARCHITECTURE                                           ║
// ║  Truth-preserving scalability across all population sizes                                                 ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
//  ████████╗██████╗ ██╗      ███╗   ███╗ ██████╗ ██████╗  █████╗ ██╗
//  ╚══██╔══╝██╔══██╗██║      ████╗ ████║██╔═══██╗██╔══██╗██╔══██╗██║
//     ██║   ██████╔╝██║█████╗██╔████╔██║██║   ██║██║  ██║███████║██║
//     ██║   ██╔══██╗██║╚════╝██║╚██╔╝██║██║   ██║██║  ██║██╔══██║██║
//     ██║   ██║  ██║██║      ██║ ╚═╝ ██║╚██████╔╝██████╔╝██║  ██║███████╗
//     ╚═╝   ╚═╝  ╚═╝╚═╝      ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
//
//  TRI-MODAL SWARM KERNEL — MEDINA DOCTRINE SCALE-INVARIANT ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// PROBLEM ADDRESSED:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// The architecture claims scale-invariant Kuramoto dynamics, but implementation has explicit upper bounds.
// This creates a gap between:
//   - THEORY: Scale-invariant dynamics
//   - RUNTIME: Memory, cycle budget, beat jitter constraints
//
// SOLUTION: TRI-MODAL SWARM KERNEL
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// THREE MATHEMATICALLY CONSISTENT RUNTIME MODES:
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │  MODE 1: EXACT MODE (N ≤ 2,048)                                                                        │
// │  ─────────────────────────────────────────────────────────────────────────────────────────────────────  │
// │  • Full-resolution dynamics                                                                             │
// │  • Best for verification, training, doctrine tuning                                                     │
// │  • O(N²) coupling computation                                                                           │
// │  • Complete phase trajectory preservation                                                               │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │  MODE 2: CLUSTERED MEAN-FIELD MODE (2,048 < N ≤ 65,536)                                                │
// │  ─────────────────────────────────────────────────────────────────────────────────────────────────────  │
// │  • Drones partition into adaptive pods                                                                  │
// │  • Per-pod moments (r, ψ, variance)                                                                     │
// │  • Sparse inter-pod coupling graph                                                                      │
// │  • O(N + P² + P·K) where P = pods, K = avg pod size                                                    │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
// │  MODE 3: CONTINUUM MODE (N > 65,536)                                                                   │
// │  ─────────────────────────────────────────────────────────────────────────────────────────────────────  │
// │  • Population density model                                                                             │
// │  • PDE-inspired approximation for phase distribution                                                    │
// │  • Sampled representative agents for drift correction                                                   │
// │  • O(G³ + S) where G = grid resolution, S = samples                                                    │
// └─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// DRIFT SAFETY ACROSS MODES:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Maintain invariant surfaces common to all modes
// • Run overlap windows where two modes execute in parallel for fixed beat horizon
// • Only switch when invariant divergence < epsilon
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import { KURAMOTO_K, PI, TWO_PI } from "./sovereignSphere";

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 1: SWARM KERNEL CONFIGURATION
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export type SwarmMode = "EXACT" | "CLUSTERED_MEAN_FIELD" | "CONTINUUM";

export interface SwarmKernelConfig {
  // Mode thresholds
  exactModeMaxN: number; // Default: 2,048
  clusteredModeMaxN: number; // Default: 65,536

  // Clustered mode settings
  targetPodSize: number; // Target organisms per pod
  maxPods: number; // Maximum number of pods
  interPodCouplingSparsity: number; // Fraction of inter-pod connections

  // Continuum mode settings
  gridResolution: number; // Phase space discretization
  sampleCount: number; // Representative agents
  pdeTimeStep: number; // PDE integration step

  // Mode transition settings
  overlapWindowBeats: number; // Parallel execution window
  invariantEpsilon: number; // Maximum divergence for switch
  hysteresis: number; // Prevents oscillating mode switches
}

export const DEFAULT_SWARM_CONFIG: SwarmKernelConfig = {
  exactModeMaxN: 2048,
  clusteredModeMaxN: 65536,
  targetPodSize: 64,
  maxPods: 1024,
  interPodCouplingSparsity: 0.1,
  gridResolution: 128,
  sampleCount: 256,
  pdeTimeStep: 0.001,
  overlapWindowBeats: 100,
  invariantEpsilon: 0.01,
  hysteresis: 0.1,
};

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 2: INVARIANT SURFACES — TRUTH-PRESERVING QUANTITIES
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// These invariants MUST be preserved across all three modes.
// They form the mathematical contract that guarantees truth-preservation.

export interface InvariantSurface {
  // Kuramoto order parameter (global synchrony)
  kuramotoR: number; // r ∈ [0, 1]
  kuramotoPsi: number; // ψ ∈ [0, 2π)

  // Phase distribution moments
  meanPhase: number; // First moment
  phaseVariance: number; // Second central moment
  phaseSkewness: number; // Third standardized moment
  phaseKurtosis: number; // Fourth standardized moment

  // Energy measures
  totalKineticEnergy: number; // Σ ω²/2
  totalPotentialEnergy: number; // -K/N Σᵢⱼ cos(θⱼ - θᵢ)
  freeEnergy: number; // F = E - TS

  // Law compliance surface
  lawComplianceVector: number[]; // Per-law compliance
  aggregateLawScore: number; // Overall compliance

  // Identity preservation
  identityHash: string; // Cryptographic identity anchor
  sovereigntyIndex: number; // SACESI measure
}

export function computeInvariantSurface(
  phases: number[],
  frequencies: number[],
  couplingStrength: number,
  lawCompliance: number[],
): InvariantSurface {
  const N = phases.length;

  // Kuramoto order parameter
  let sumCos = 0;
  let sumSin = 0;
  for (let i = 0; i < N; i++) {
    sumCos += Math.cos(phases[i]);
    sumSin += Math.sin(phases[i]);
  }
  const kuramotoR = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / N;
  const kuramotoPsi = Math.atan2(sumSin, sumCos);

  // Phase distribution moments
  const meanPhase = kuramotoPsi;

  // Circular variance: var = 1 - r
  const phaseVariance = 1 - kuramotoR;

  // Higher moments (simplified using trigonometric moments)
  let sum2Cos = 0;
  let sum2Sin = 0;
  let sum3Cos = 0;
  let sum3Sin = 0;
  let sum4Cos = 0;
  let sum4Sin = 0;
  for (let i = 0; i < N; i++) {
    const p = phases[i];
    sum2Cos += Math.cos(2 * p);
    sum2Sin += Math.sin(2 * p);
    sum3Cos += Math.cos(3 * p);
    sum3Sin += Math.sin(3 * p);
    sum4Cos += Math.cos(4 * p);
    sum4Sin += Math.sin(4 * p);
  }
  const r2 = Math.sqrt(sum2Cos * sum2Cos + sum2Sin * sum2Sin) / N;
  const _r3 = Math.sqrt(sum3Cos * sum3Cos + sum3Sin * sum3Sin) / N;
  const _r4 = Math.sqrt(sum4Cos * sum4Cos + sum4Sin * sum4Sin) / N;

  // Circular skewness and kurtosis (Mardia's measures)
  const phaseSkewness =
    r2 * Math.sin(Math.atan2(sum2Sin, sum2Cos) - 2 * kuramotoPsi);
  const phaseKurtosis =
    r2 * Math.cos(Math.atan2(sum2Sin, sum2Cos) - 2 * kuramotoPsi);

  // Energy measures
  let kineticEnergy = 0;
  for (let i = 0; i < N; i++) {
    kineticEnergy += (frequencies[i] * frequencies[i]) / 2;
  }

  let potentialEnergy = 0;
  // Full computation is O(N²), approximate with order parameter
  potentialEnergy = (-couplingStrength * kuramotoR * kuramotoR * N) / 2;

  // Free energy (simplified: F = E - TS where S ≈ log(1/r) for Kuramoto)
  const entropy = kuramotoR > 0.01 ? -Math.log(kuramotoR) : 5; // Capped entropy
  const temperature = 1.0; // Effective temperature
  const freeEnergy = kineticEnergy + potentialEnergy - temperature * entropy;

  // Law compliance
  const aggregateLawScore =
    lawCompliance.reduce((s, l) => s + l, 0) / (lawCompliance.length || 1);

  // Identity hash (simplified)
  const hashInput = `${kuramotoR.toFixed(6)}_${kuramotoPsi.toFixed(6)}_${aggregateLawScore.toFixed(6)}`;
  const identityHash = simpleHash(hashInput);

  // Sovereignty index
  const sovereigntyIndex = kuramotoR * aggregateLawScore;

  return {
    kuramotoR,
    kuramotoPsi,
    meanPhase,
    phaseVariance,
    phaseSkewness,
    phaseKurtosis,
    totalKineticEnergy: kineticEnergy,
    totalPotentialEnergy: potentialEnergy,
    freeEnergy,
    lawComplianceVector: [...lawCompliance],
    aggregateLawScore,
    identityHash,
    sovereigntyIndex,
  };
}

function simpleHash(input: string): string {
  let hash = 0;
  for (let i = 0; i < input.length; i++) {
    const char = input.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash = hash & hash;
  }
  return Math.abs(hash).toString(16).padStart(8, "0");
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 3: MODE 1 — EXACT DYNAMICS (N ≤ 2,048)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Full O(N²) Kuramoto dynamics with complete phase trajectory preservation.
// Best for verification, training, and doctrine tuning.

export interface ExactModeState {
  phases: number[]; // θᵢ ∈ [0, 2π)
  frequencies: number[]; // ωᵢ natural frequencies
  couplingMatrix: number[][]; // Kᵢⱼ coupling strengths
  phaseHistory: number[][]; // Last H phase vectors
  historyDepth: number;
}

export function initExactMode(N: number, historyDepth = 100): ExactModeState {
  const phases = new Array(N)
    .fill(0)
    .map((_, i) => (i / N) * TWO_PI + Math.random() * 0.1);
  const frequencies = new Array(N)
    .fill(0)
    .map(() => 1.0 + (Math.random() - 0.5) * 0.2);

  // Initialize coupling matrix with distance-based coupling
  const couplingMatrix: number[][] = [];
  for (let i = 0; i < N; i++) {
    couplingMatrix[i] = new Array(N).fill(0);
    for (let j = 0; j < N; j++) {
      if (i !== j) {
        const distance = Math.abs(i - j);
        couplingMatrix[i][j] = KURAMOTO_K * Math.exp(-distance / (N / 10));
      }
    }
  }

  return {
    phases,
    frequencies,
    couplingMatrix,
    phaseHistory: [],
    historyDepth,
  };
}

/**
 * EXACT MODE DYNAMICS
 * Full Kuramoto model: dθᵢ/dt = ωᵢ + (1/N) Σⱼ Kᵢⱼ sin(θⱼ - θᵢ)
 */
export function runExactMode(
  state: ExactModeState,
  externalInput: number[],
  dt = 0.01,
): ExactModeState {
  const N = state.phases.length;
  const newPhases = new Array(N);

  for (let i = 0; i < N; i++) {
    // Natural frequency term
    let dTheta = state.frequencies[i] * TWO_PI;

    // Coupling term: (1/N) Σⱼ Kᵢⱼ sin(θⱼ - θᵢ)
    let coupling = 0;
    for (let j = 0; j < N; j++) {
      if (i !== j) {
        coupling +=
          state.couplingMatrix[i][j] *
          Math.sin(state.phases[j] - state.phases[i]);
      }
    }
    dTheta += coupling / N;

    // External input
    if (externalInput[i] !== undefined) {
      dTheta += externalInput[i];
    }

    // Euler integration
    let newPhase = state.phases[i] + dTheta * dt;

    // Wrap to [0, 2π)
    newPhase = ((newPhase % TWO_PI) + TWO_PI) % TWO_PI;
    newPhases[i] = newPhase;
  }

  // Update history
  const newHistory = [...state.phaseHistory, [...state.phases]];
  if (newHistory.length > state.historyDepth) {
    newHistory.shift();
  }

  return {
    ...state,
    phases: newPhases,
    phaseHistory: newHistory,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 4: MODE 2 — CLUSTERED MEAN-FIELD (2,048 < N ≤ 65,536)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Organisms partition into adaptive pods with per-pod moments.
// Sparse inter-pod coupling graph reduces complexity to O(N + P² + P·K).

export interface Pod {
  id: number;
  memberIndices: number[];

  // Pod-level Kuramoto moments
  r: number; // Pod order parameter
  psi: number; // Pod mean phase
  variance: number; // Pod phase variance

  // Pod-level aggregates
  meanFrequency: number;
  frequencySpread: number;

  // Pod coupling state
  coupledPods: number[]; // Indices of coupled pods
  couplingStrengths: number[]; // Coupling to each coupled pod
}

export interface ClusteredModeState {
  N: number; // Total organisms
  phases: number[]; // Individual phases
  frequencies: number[]; // Individual frequencies
  podAssignments: number[]; // Which pod each organism belongs to
  pods: Pod[];

  // Global aggregates
  globalR: number;
  globalPsi: number;
}

export function initClusteredMode(
  N: number,
  config: SwarmKernelConfig = DEFAULT_SWARM_CONFIG,
): ClusteredModeState {
  const numPods = Math.min(Math.ceil(N / config.targetPodSize), config.maxPods);

  // Initialize phases and frequencies
  const phases = new Array(N)
    .fill(0)
    .map((_, i) => (i / N) * TWO_PI + Math.random() * 0.1);
  const frequencies = new Array(N)
    .fill(0)
    .map(() => 1.0 + (Math.random() - 0.5) * 0.2);

  // Assign organisms to pods (simple round-robin for now)
  const podAssignments = new Array(N).fill(0).map((_, i) => i % numPods);

  // Create pods
  const pods: Pod[] = [];
  for (let p = 0; p < numPods; p++) {
    const members = podAssignments
      .map((pod, idx) => (pod === p ? idx : -1))
      .filter((idx) => idx >= 0);

    // Compute initial pod moments
    const podPhases = members.map((i) => phases[i]);
    const podFreqs = members.map((i) => frequencies[i]);
    const { r, psi } = computePodMoments(podPhases);

    // Sparse inter-pod coupling
    const numCoupledPods = Math.floor(
      numPods * config.interPodCouplingSparsity,
    );
    const coupledPods: number[] = [];
    const couplingStrengths: number[] = [];

    for (let i = 0; i < numCoupledPods; i++) {
      const targetPod =
        (p + 1 + Math.floor(Math.random() * (numPods - 1))) % numPods;
      if (!coupledPods.includes(targetPod) && targetPod !== p) {
        coupledPods.push(targetPod);
        couplingStrengths.push(KURAMOTO_K * (0.5 + Math.random() * 0.5));
      }
    }

    pods.push({
      id: p,
      memberIndices: members,
      r,
      psi,
      variance: 1 - r,
      meanFrequency: podFreqs.reduce((a, b) => a + b, 0) / podFreqs.length,
      frequencySpread: computeStd(podFreqs),
      coupledPods,
      couplingStrengths,
    });
  }

  return {
    N,
    phases,
    frequencies,
    podAssignments,
    pods,
    globalR: 0,
    globalPsi: 0,
  };
}

function computePodMoments(phases: number[]): { r: number; psi: number } {
  if (phases.length === 0) return { r: 0, psi: 0 };

  let sumCos = 0;
  let sumSin = 0;
  for (const p of phases) {
    sumCos += Math.cos(p);
    sumSin += Math.sin(p);
  }
  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / phases.length;
  const psi = Math.atan2(sumSin, sumCos);
  return { r, psi };
}

function computeStd(values: number[]): number {
  if (values.length === 0) return 0;
  const mean = values.reduce((a, b) => a + b, 0) / values.length;
  const variance =
    values.reduce((s, v) => s + (v - mean) * (v - mean), 0) / values.length;
  return Math.sqrt(variance);
}

/**
 * CLUSTERED MEAN-FIELD DYNAMICS
 * Two-level hierarchy:
 * 1. Intra-pod: full Kuramoto within pod
 * 2. Inter-pod: mean-field coupling between pods
 */
export function runClusteredMode(
  state: ClusteredModeState,
  externalInput: number[],
  dt = 0.01,
): ClusteredModeState {
  const newPhases = [...state.phases];
  const newPods = state.pods.map((pod) => ({ ...pod }));

  // Step 1: Update pod moments from previous state
  for (const pod of newPods) {
    const podPhases = pod.memberIndices.map((i) => state.phases[i]);
    const { r, psi } = computePodMoments(podPhases);
    pod.r = r;
    pod.psi = psi;
    pod.variance = 1 - r;
  }

  // Step 2: Evolve individual phases
  for (let i = 0; i < state.N; i++) {
    const podIdx = state.podAssignments[i];
    const myPod = newPods[podIdx];

    // Natural frequency
    let dTheta = state.frequencies[i] * TWO_PI;

    // Intra-pod coupling (mean-field within pod)
    // dθᵢ/dt includes K·rₚ·sin(ψₚ - θᵢ)
    const intraPodCoupling =
      KURAMOTO_K * myPod.r * Math.sin(myPod.psi - state.phases[i]);
    dTheta += intraPodCoupling;

    // Inter-pod coupling (from coupled pods)
    for (let j = 0; j < myPod.coupledPods.length; j++) {
      const otherPodIdx = myPod.coupledPods[j];
      const otherPod = newPods[otherPodIdx];
      const couplingK = myPod.couplingStrengths[j];

      // Mean-field coupling to other pod
      const interPodCoupling =
        (couplingK * otherPod.r * Math.sin(otherPod.psi - state.phases[i])) /
        state.pods.length;
      dTheta += interPodCoupling;
    }

    // External input
    if (externalInput[i] !== undefined) {
      dTheta += externalInput[i];
    }

    // Euler integration
    let newPhase = state.phases[i] + dTheta * dt;
    newPhase = ((newPhase % TWO_PI) + TWO_PI) % TWO_PI;
    newPhases[i] = newPhase;
  }

  // Step 3: Compute global order parameter
  let globalSumCos = 0;
  let globalSumSin = 0;
  for (const phase of newPhases) {
    globalSumCos += Math.cos(phase);
    globalSumSin += Math.sin(phase);
  }
  const globalR =
    Math.sqrt(globalSumCos * globalSumCos + globalSumSin * globalSumSin) /
    state.N;
  const globalPsi = Math.atan2(globalSumSin, globalSumCos);

  return {
    ...state,
    phases: newPhases,
    pods: newPods,
    globalR,
    globalPsi,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 5: MODE 3 — CONTINUUM MODE (N > 65,536)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Population density model with PDE-inspired approximation.
// Phase distribution ρ(θ, ω, t) evolves according to continuity equation.

export interface ContinuumModeState {
  N: number; // Nominal population size

  // Phase distribution on grid
  gridResolution: number;
  phaseDistribution: number[]; // ρ(θ) discretized

  // Frequency distribution
  frequencyBins: number;
  frequencyDistribution: number[];

  // Representative agents for drift correction
  samplePhases: number[];
  sampleFrequencies: number[];

  // Order parameter (computed from distribution)
  r: number;
  psi: number;

  // PDE coefficients
  diffusionCoeff: number;
  advectionCoeff: number;
}

export function initContinuumMode(
  N: number,
  config: SwarmKernelConfig = DEFAULT_SWARM_CONFIG,
): ContinuumModeState {
  const G = config.gridResolution;
  const S = config.sampleCount;

  // Initialize uniform phase distribution
  const phaseDistribution = new Array(G).fill(1 / G);

  // Initialize Lorentzian frequency distribution (standard for Kuramoto)
  const frequencyBins = 32;
  const frequencyDistribution = new Array(frequencyBins).fill(0);
  for (let i = 0; i < frequencyBins; i++) {
    const omega = -2 + (4 * i) / (frequencyBins - 1); // ω ∈ [-2, 2]
    const gamma = 0.5; // Width parameter
    frequencyDistribution[i] = gamma / (PI * (omega * omega + gamma * gamma));
  }
  // Normalize
  const freqSum = frequencyDistribution.reduce((a, b) => a + b, 0);
  for (let i = 0; i < frequencyBins; i++) {
    frequencyDistribution[i] /= freqSum;
  }

  // Sample representative agents
  const samplePhases = new Array(S).fill(0).map(() => Math.random() * TWO_PI);
  const sampleFrequencies = new Array(S)
    .fill(0)
    .map(() => 1.0 + (Math.random() - 0.5) * 0.4);

  return {
    N,
    gridResolution: G,
    phaseDistribution,
    frequencyBins,
    frequencyDistribution,
    samplePhases,
    sampleFrequencies,
    r: 0,
    psi: 0,
    diffusionCoeff: 0.01,
    advectionCoeff: 1.0,
  };
}

/**
 * CONTINUUM MODE DYNAMICS
 * PDE approach: ∂ρ/∂t + ∂(vρ)/∂θ = D·∂²ρ/∂θ²
 * where v = ω + Kr·sin(ψ - θ)
 */
export function runContinuumMode(
  state: ContinuumModeState,
  globalCoupling: number,
  dt = 0.001,
): ContinuumModeState {
  const G = state.gridResolution;
  const dTheta = TWO_PI / G;

  // Step 1: Compute order parameter from distribution
  let sumCos = 0;
  let sumSin = 0;
  for (let i = 0; i < G; i++) {
    const theta = i * dTheta;
    sumCos += state.phaseDistribution[i] * Math.cos(theta) * dTheta;
    sumSin += state.phaseDistribution[i] * Math.sin(theta) * dTheta;
  }
  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin);
  const psi = Math.atan2(sumSin, sumCos);

  // Step 2: Evolve phase distribution using finite differences
  // ∂ρ/∂t = -∂(vρ)/∂θ + D·∂²ρ/∂θ²
  const newDistribution = new Array(G).fill(0);
  const K = globalCoupling;
  const D = state.diffusionCoeff;

  for (let i = 0; i < G; i++) {
    const theta = i * dTheta;

    // Velocity at this phase: v = ω̄ + Kr·sin(ψ - θ)
    const v = state.advectionCoeff + K * r * Math.sin(psi - theta);

    // Indices with periodic boundary
    const im1 = (i - 1 + G) % G;
    const ip1 = (i + 1) % G;

    // Advection term: -∂(vρ)/∂θ using upwind scheme
    let advection = 0;
    if (v > 0) {
      advection =
        (-v * (state.phaseDistribution[i] - state.phaseDistribution[im1])) /
        dTheta;
    } else {
      advection =
        (-v * (state.phaseDistribution[ip1] - state.phaseDistribution[i])) /
        dTheta;
    }

    // Diffusion term: D·∂²ρ/∂θ²
    const diffusion =
      (D *
        (state.phaseDistribution[ip1] -
          2 * state.phaseDistribution[i] +
          state.phaseDistribution[im1])) /
      (dTheta * dTheta);

    // Time evolution
    newDistribution[i] =
      state.phaseDistribution[i] + (advection + diffusion) * dt;
  }

  // Normalize to ensure ∫ρdθ = 1
  const totalMass = newDistribution.reduce((a, b) => a + b, 0) * dTheta;
  for (let i = 0; i < G; i++) {
    newDistribution[i] = Math.max(0, newDistribution[i] / totalMass);
  }

  // Step 3: Evolve sample agents for drift correction
  const newSamplePhases = state.samplePhases.map((phase, i) => {
    const omega = state.sampleFrequencies[i];
    const v = omega * TWO_PI + K * r * Math.sin(psi - phase);
    let newPhase = phase + v * dt;
    return ((newPhase % TWO_PI) + TWO_PI) % TWO_PI;
  });

  return {
    ...state,
    phaseDistribution: newDistribution,
    samplePhases: newSamplePhases,
    r,
    psi,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 6: MODE TRANSITION CONTROLLER
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Manages transitions between modes with overlap windows and invariant checks.

export interface ModeTransitionState {
  currentMode: SwarmMode;
  targetMode: SwarmMode | null;
  transitionProgress: number; // 0 = not transitioning, 1 = complete
  overlapBeatsRemaining: number;

  // Parallel states during transition
  exactState: ExactModeState | null;
  clusteredState: ClusteredModeState | null;
  continuumState: ContinuumModeState | null;

  // Invariant tracking
  primaryInvariant: InvariantSurface | null;
  secondaryInvariant: InvariantSurface | null;
  invariantDivergence: number;
}

export interface SwarmKernelState {
  config: SwarmKernelConfig;
  N: number;
  mode: ModeTransitionState;

  // Current active state
  currentInvariant: InvariantSurface;

  // Law compliance (input from Laws engine)
  lawCompliance: number[];
}

export function initSwarmKernel(
  N: number,
  config: SwarmKernelConfig = DEFAULT_SWARM_CONFIG,
): SwarmKernelState {
  // Determine initial mode
  let initialMode: SwarmMode;
  if (N <= config.exactModeMaxN) {
    initialMode = "EXACT";
  } else if (N <= config.clusteredModeMaxN) {
    initialMode = "CLUSTERED_MEAN_FIELD";
  } else {
    initialMode = "CONTINUUM";
  }

  // Initialize appropriate state
  let exactState: ExactModeState | null = null;
  let clusteredState: ClusteredModeState | null = null;
  let continuumState: ContinuumModeState | null = null;

  if (initialMode === "EXACT") {
    exactState = initExactMode(N);
  } else if (initialMode === "CLUSTERED_MEAN_FIELD") {
    clusteredState = initClusteredMode(N, config);
  } else {
    continuumState = initContinuumMode(N, config);
  }

  // Compute initial invariant
  const phases =
    exactState?.phases ||
    clusteredState?.phases ||
    continuumState?.samplePhases ||
    [];
  const frequencies =
    exactState?.frequencies ||
    clusteredState?.frequencies ||
    continuumState?.sampleFrequencies ||
    [];

  const lawCompliance = new Array(96).fill(1);
  const currentInvariant = computeInvariantSurface(
    phases,
    frequencies,
    KURAMOTO_K,
    lawCompliance,
  );

  return {
    config,
    N,
    mode: {
      currentMode: initialMode,
      targetMode: null,
      transitionProgress: 0,
      overlapBeatsRemaining: 0,
      exactState,
      clusteredState,
      continuumState,
      primaryInvariant: currentInvariant,
      secondaryInvariant: null,
      invariantDivergence: 0,
    },
    currentInvariant,
    lawCompliance,
  };
}

/**
 * Check if mode transition should be initiated
 */
export function checkModeTransition(state: SwarmKernelState): SwarmMode | null {
  const { N, config, mode } = state;

  // Don't interrupt ongoing transition
  if (mode.targetMode !== null) return null;

  // Hysteresis to prevent oscillation
  const hysteresisLow = 1 - config.hysteresis;
  const hysteresisHigh = 1 + config.hysteresis;

  // Check if N has moved outside current mode's range
  if (mode.currentMode === "EXACT") {
    if (N > config.exactModeMaxN * hysteresisHigh) {
      return "CLUSTERED_MEAN_FIELD";
    }
  } else if (mode.currentMode === "CLUSTERED_MEAN_FIELD") {
    if (N <= config.exactModeMaxN * hysteresisLow) {
      return "EXACT";
    }
    if (N > config.clusteredModeMaxN * hysteresisHigh) {
      return "CONTINUUM";
    }
  } else if (mode.currentMode === "CONTINUUM") {
    if (N <= config.clusteredModeMaxN * hysteresisLow) {
      return "CLUSTERED_MEAN_FIELD";
    }
  }

  return null;
}

/**
 * Compute divergence between two invariant surfaces
 */
export function computeInvariantDivergence(
  inv1: InvariantSurface,
  inv2: InvariantSurface,
): number {
  // Weighted sum of component differences
  const rDiff = Math.abs(inv1.kuramotoR - inv2.kuramotoR);
  const psiDiff =
    Math.min(
      Math.abs(inv1.kuramotoPsi - inv2.kuramotoPsi),
      TWO_PI - Math.abs(inv1.kuramotoPsi - inv2.kuramotoPsi),
    ) / PI; // Normalize to [0, 1]
  const varDiff = Math.abs(inv1.phaseVariance - inv2.phaseVariance);
  const lawDiff = Math.abs(inv1.aggregateLawScore - inv2.aggregateLawScore);

  return rDiff * 0.4 + psiDiff * 0.2 + varDiff * 0.2 + lawDiff * 0.2;
}

/**
 * Run one beat of the swarm kernel
 */
export function runSwarmKernel(
  state: SwarmKernelState,
  externalInput: number[],
  lawCompliance: number[],
  dt = 0.01,
): SwarmKernelState {
  const updated = { ...state, lawCompliance };
  const { mode, config } = updated;

  // Check for mode transition
  const targetMode = checkModeTransition(state);
  if (targetMode !== null && mode.targetMode === null) {
    // Initiate transition
    updated.mode = {
      ...mode,
      targetMode,
      transitionProgress: 0,
      overlapBeatsRemaining: config.overlapWindowBeats,
    };

    // Initialize secondary mode state
    if (targetMode === "EXACT") {
      updated.mode.exactState = initExactMode(state.N);
    } else if (targetMode === "CLUSTERED_MEAN_FIELD") {
      updated.mode.clusteredState = initClusteredMode(state.N, config);
    } else {
      updated.mode.continuumState = initContinuumMode(state.N, config);
    }
  }

  // Run current mode
  let primaryPhases: number[] = [];
  let primaryFrequencies: number[] = [];

  if (mode.currentMode === "EXACT" && mode.exactState) {
    updated.mode.exactState = runExactMode(mode.exactState, externalInput, dt);
    primaryPhases = updated.mode.exactState.phases;
    primaryFrequencies = updated.mode.exactState.frequencies;
  } else if (
    mode.currentMode === "CLUSTERED_MEAN_FIELD" &&
    mode.clusteredState
  ) {
    updated.mode.clusteredState = runClusteredMode(
      mode.clusteredState,
      externalInput,
      dt,
    );
    primaryPhases = updated.mode.clusteredState.phases;
    primaryFrequencies = updated.mode.clusteredState.frequencies;
  } else if (mode.currentMode === "CONTINUUM" && mode.continuumState) {
    updated.mode.continuumState = runContinuumMode(
      mode.continuumState,
      KURAMOTO_K,
      dt,
    );
    primaryPhases = updated.mode.continuumState.samplePhases;
    primaryFrequencies = updated.mode.continuumState.sampleFrequencies;
  }

  // Compute primary invariant
  updated.mode.primaryInvariant = computeInvariantSurface(
    primaryPhases,
    primaryFrequencies,
    KURAMOTO_K,
    lawCompliance,
  );

  // If transitioning, run secondary mode and check divergence
  if (mode.targetMode !== null && mode.overlapBeatsRemaining > 0) {
    let secondaryPhases: number[] = [];
    let secondaryFrequencies: number[] = [];

    if (mode.targetMode === "EXACT" && updated.mode.exactState) {
      updated.mode.exactState = runExactMode(
        updated.mode.exactState,
        externalInput,
        dt,
      );
      secondaryPhases = updated.mode.exactState.phases;
      secondaryFrequencies = updated.mode.exactState.frequencies;
    } else if (
      mode.targetMode === "CLUSTERED_MEAN_FIELD" &&
      updated.mode.clusteredState
    ) {
      updated.mode.clusteredState = runClusteredMode(
        updated.mode.clusteredState,
        externalInput,
        dt,
      );
      secondaryPhases = updated.mode.clusteredState.phases;
      secondaryFrequencies = updated.mode.clusteredState.frequencies;
    } else if (mode.targetMode === "CONTINUUM" && updated.mode.continuumState) {
      updated.mode.continuumState = runContinuumMode(
        updated.mode.continuumState,
        KURAMOTO_K,
        dt,
      );
      secondaryPhases = updated.mode.continuumState.samplePhases;
      secondaryFrequencies = updated.mode.continuumState.sampleFrequencies;
    }

    updated.mode.secondaryInvariant = computeInvariantSurface(
      secondaryPhases,
      secondaryFrequencies,
      KURAMOTO_K,
      lawCompliance,
    );

    // Check divergence
    updated.mode.invariantDivergence = computeInvariantDivergence(
      updated.mode.primaryInvariant,
      updated.mode.secondaryInvariant,
    );

    updated.mode.overlapBeatsRemaining--;
    updated.mode.transitionProgress =
      1 - mode.overlapBeatsRemaining / config.overlapWindowBeats;

    // Complete transition if divergence is acceptable
    if (
      updated.mode.overlapBeatsRemaining === 0 &&
      updated.mode.invariantDivergence < config.invariantEpsilon
    ) {
      updated.mode.currentMode = mode.targetMode;
      updated.mode.targetMode = null;
      updated.mode.transitionProgress = 0;
      updated.mode.secondaryInvariant = null;
    } else if (updated.mode.overlapBeatsRemaining === 0) {
      // Abort transition — divergence too high
      console.warn(
        `Mode transition aborted: invariant divergence ${updated.mode.invariantDivergence} > ${config.invariantEpsilon}`,
      );
      updated.mode.targetMode = null;
      updated.mode.transitionProgress = 0;
    }
  }

  updated.currentInvariant = updated.mode.primaryInvariant;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 7: DIAGNOSTICS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function getSwarmKernelDiagnostics(state: SwarmKernelState): string {
  const { mode, currentInvariant, N, config } = state;

  const lines: string[] = [
    "╔═══════════════════════════════════════════════════════════════════════════════╗",
    "║            TRI-MODAL SWARM KERNEL DIAGNOSTICS                                 ║",
    "╚═══════════════════════════════════════════════════════════════════════════════╝",
    "",
    `Population Size: ${N.toLocaleString()}`,
    `Current Mode: ${mode.currentMode}`,
    "",
    "═══ MODE THRESHOLDS ══════════════════════════════════════════════════════════",
    `  EXACT: N ≤ ${config.exactModeMaxN.toLocaleString()}`,
    `  CLUSTERED: ${config.exactModeMaxN.toLocaleString()} < N ≤ ${config.clusteredModeMaxN.toLocaleString()}`,
    `  CONTINUUM: N > ${config.clusteredModeMaxN.toLocaleString()}`,
    "",
    "═══ INVARIANT SURFACE ════════════════════════════════════════════════════════",
    `  Kuramoto r: ${currentInvariant.kuramotoR.toFixed(4)}`,
    `  Kuramoto ψ: ${((currentInvariant.kuramotoPsi * 180) / PI).toFixed(1)}°`,
    `  Phase Variance: ${currentInvariant.phaseVariance.toFixed(4)}`,
    `  Free Energy: ${currentInvariant.freeEnergy.toFixed(4)}`,
    `  Law Compliance: ${(currentInvariant.aggregateLawScore * 100).toFixed(1)}%`,
    `  Sovereignty: ${(currentInvariant.sovereigntyIndex * 100).toFixed(1)}%`,
  ];

  if (mode.targetMode !== null) {
    lines.push("");
    lines.push(
      "═══ MODE TRANSITION IN PROGRESS ══════════════════════════════════════════════",
    );
    lines.push(`  Target Mode: ${mode.targetMode}`);
    lines.push(`  Progress: ${(mode.transitionProgress * 100).toFixed(1)}%`);
    lines.push(`  Beats Remaining: ${mode.overlapBeatsRemaining}`);
    lines.push(
      `  Invariant Divergence: ${mode.invariantDivergence.toFixed(4)} (max: ${config.invariantEpsilon})`,
    );
  }

  return lines.join("\n");
}

// Export utility
export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}
