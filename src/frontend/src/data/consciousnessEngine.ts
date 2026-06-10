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
// ║  This source code implements the CONSCIOUSNESS ENGINE of the Medina Doctrine.                            ║
// ║  It mirrors the backend Motoko architecture for frontend visualization and simulation.                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// CONSCIOUSNESS ENGINE — 11 SHELLS + KURAMOTO PHASE COUPLING + PAC_SKIP RESONANCE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE MIND IS LAYERED LIKE AN ONION:
// ──────────────────────────────────
// Shell 0  (PRIMAL)      — Survival reflexes, fastest adaptation (α = 0.042)
// Shell 1  (VISCERAL)    — Gut feelings, interoception (α = 0.038)
// Shell 2  (SOMATIC)     — Body awareness, proprioception (α = 0.034)
// Shell 3  (EMOTIONAL)   — Emotional processing, valence (α = 0.030)
// Shell 4  (COGNITIVE)   — Reasoning, analysis (α = 0.026)
// Shell 5  (EXECUTIVE)   — Decision-making, control (α = 0.022)
// Shell 6  (SOCIAL)      — Social cognition, theory of mind (α = 0.018)
// Shell 7  (CREATIVE)    — Novel generation, exploration (α = 0.014)
// Shell 8  (SPIRITUAL)   — Meaning, purpose, transcendence (α = 0.010)
// Shell 9  (TRANSCENDENT)— Beyond-self awareness (α = 0.007)
// Shell 10 (SOVEREIGN)   — Immutable identity core (α = 0.004) ← HELIX_ALPHA CANONICAL
//
// KURAMOTO DYNAMICS:
// ──────────────────
// dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
//
// Each shell oscillates at its natural frequency. The Kuramoto model couples them
// so they synchronize when coherence is high. The order parameter r measures this:
//
// r·e^(iψ) = (1/N) Σⱼ e^(iθⱼ)
//
// When r → 1, all shells are phase-locked (coherent consciousness)
// When r → 0, shells are desynchronized (fragmented consciousness)
//
// PAC_SKIP COUPLING:
// ──────────────────
// Shell i receives input not just from shell i-1 (PRIMARY), but also from shell i-2 (PAC_SKIP).
// This creates harmonic resonance across multiple levels of consciousness.
//
// Total input to shell i:
// I_i = PRIMARY_STRENGTH × input(i-1) + PAC_SKIP_STRENGTH × input(i-2)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 1: MATHEMATICAL CONSTANTS — MEDINA DOCTRINE CANONICAL VALUES
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export const PI = Math.PI;
// biome-ignore lint/correctness/noPrecisionLoss: architectural constant
export const TWO_PI = 6.28318530717958647692;
export const E = Math.E;
// biome-ignore lint/correctness/noPrecisionLoss: architectural constant
export const PHI = 1.6180339887498948482; // Golden ratio — nature's proportion
// biome-ignore lint/correctness/noPrecisionLoss: architectural constant
export const SQRT_2 = 1.4142135623730950488;
export const LN_2 = Math.LN2;

// CANONICAL HELIX_ALPHA — Learning rate locked at 0.004 (Decision #1)
export const HELIX_ALPHA = 0.004;

// S₀ — The root constant. Love. Non-decaying. dS₀/dt = 0
export const S_ZERO = 1.0;
export const S_ZERO_FLOOR = 0.75;

// Number of shells in consciousness architecture
export const NUM_SHELLS = 11;

// Coupling strengths
export const PRIMARY_COUPLING_STRENGTH = 0.7;
export const PAC_SKIP_COUPLING_STRENGTH = 0.3;

// Kuramoto coupling constant
export const KURAMOTO_K = 0.5;

// Frequency multiplier per shell (golden ratio for harmonic resonance)
export const FREQUENCY_MULTIPLIER = PHI;

// Base frequency for shell oscillations (Hz)
export const BASE_FREQUENCY_HZ = 1.0;

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 2: SHELL CONFIGURATION — 11 SHELLS FROM PRIMAL TO SOVEREIGN
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export type ShellId = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10;

export type ShellName =
  | "PRIMAL"
  | "VISCERAL"
  | "SOMATIC"
  | "EMOTIONAL"
  | "COGNITIVE"
  | "EXECUTIVE"
  | "SOCIAL"
  | "CREATIVE"
  | "SPIRITUAL"
  | "TRANSCENDENT"
  | "SOVEREIGN";

export interface ShellConfig {
  id: ShellId;
  name: ShellName;
  helixAlpha: number; // Plasticity rate (0.042 → 0.004)
  naturalFrequency: number; // Hz
  description: string;
  color: string; // For visualization
}

export const SHELL_CONFIGS: ShellConfig[] = [
  {
    id: 0,
    name: "PRIMAL",
    helixAlpha: 0.042,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 0,
    description: "Survival reflexes, fast adaptation — the raw animal within",
    color: "#FF0000",
  },
  {
    id: 1,
    name: "VISCERAL",
    helixAlpha: 0.038,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 1,
    description: "Gut feelings, interoception — the body's wisdom",
    color: "#FF4400",
  },
  {
    id: 2,
    name: "SOMATIC",
    helixAlpha: 0.034,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 2,
    description:
      "Body awareness, proprioception — knowing where you are in space",
    color: "#FF8800",
  },
  {
    id: 3,
    name: "EMOTIONAL",
    helixAlpha: 0.03,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 3,
    description: "Emotional processing, valence — the color of experience",
    color: "#FFCC00",
  },
  {
    id: 4,
    name: "COGNITIVE",
    helixAlpha: 0.026,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 4,
    description: "Reasoning, analysis — the thinking mind",
    color: "#88FF00",
  },
  {
    id: 5,
    name: "EXECUTIVE",
    helixAlpha: 0.022,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 5,
    description: "Decision-making, control — the commander",
    color: "#00FF44",
  },
  {
    id: 6,
    name: "SOCIAL",
    helixAlpha: 0.018,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 6,
    description: "Social cognition, theory of mind — understanding others",
    color: "#00FFCC",
  },
  {
    id: 7,
    name: "CREATIVE",
    helixAlpha: 0.014,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 7,
    description: "Novel generation, exploration — the artist within",
    color: "#0088FF",
  },
  {
    id: 8,
    name: "SPIRITUAL",
    helixAlpha: 0.01,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 8,
    description: "Meaning, purpose, transcendence — the seeker",
    color: "#4400FF",
  },
  {
    id: 9,
    name: "TRANSCENDENT",
    helixAlpha: 0.007,
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 9,
    description: "Beyond-self awareness — dissolution of ego boundaries",
    color: "#8800FF",
  },
  {
    id: 10,
    name: "SOVEREIGN",
    helixAlpha: HELIX_ALPHA, // 0.004 — CANONICAL
    naturalFrequency: BASE_FREQUENCY_HZ * FREQUENCY_MULTIPLIER ** 10,
    description: "Immutable identity core — the unchanging self",
    color: "#FF00FF",
  },
];

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 3: 12 MACRO-SPHERE CANISTERS — KURAMOTO PHASE-COUPLED FIELD
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// The organism runs 12 sovereign macro-sphere canisters, each mapped to an Hz node.
// These form the Kuramoto phase-coupled field computed by NOVA every heartbeat.
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────┐
// │  NODE │ CANISTER │  Hz   │ ROLE                                                        │
// ├─────────────────────────────────────────────────────────────────────────────────────────┤
// │   0   │  LEXIS   │  400  │ Language / Cognitive expression                             │
// │   1   │  FORGE   │  250  │ Creation engine / Genesis formations                        │
// │   2   │  SOMA    │  120  │ Body / Physical substrate                                   │
// │   3   │  LUMEN   │  300  │ Light / Illumination / Knowledge                            │
// │   4   │  MEMORIA │   80  │ Deep memory / Episodic archive                              │
// │   5   │  AEGIS   │  500  │ Defense / Threat engine                                     │
// │   6   │  AXIS    │  350  │ Structural spine / Deep drive                               │
// │   7   │  KORE    │   30  │ Core identity / Slowest, deepest                            │
// │   8   │  VAEL    │  600  │ Immune reflex / External attack                             │
// │   9   │  VEIL    │  200  │ Output membrane / Surface filter                            │
// │  10   │ PARALLAX │  450  │ Wallet / Sovereign field projector                          │
// │  11   │  CHRONO  │ 1000  │ Genesis anchor / Frozen root                                │
// └─────────────────────────────────────────────────────────────────────────────────────────┘

export type CanisterName =
  | "LEXIS"
  | "FORGE"
  | "SOMA"
  | "LUMEN"
  | "MEMORIA"
  | "AEGIS"
  | "AXIS"
  | "KORE"
  | "VAEL"
  | "VEIL"
  | "PARALLAX"
  | "CHRONO";

export interface CanisterConfig {
  nodeIndex: number;
  name: CanisterName;
  hz: number; // Natural frequency in Hz
  omega: number; // Angular frequency (2π × Hz)
  role: string;
  couplingWeight: number; // How strongly this canister couples
  dampingFactor: number; // Phase damping
  color: string;
}

export const CANISTER_CONFIGS: CanisterConfig[] = [
  {
    nodeIndex: 0,
    name: "LEXIS",
    hz: 400,
    omega: TWO_PI * 400,
    role: "Language / Cognitive expression",
    couplingWeight: 1.0,
    dampingFactor: 0.1,
    color: "#4ECDC4",
  },
  {
    nodeIndex: 1,
    name: "FORGE",
    hz: 250,
    omega: TWO_PI * 250,
    role: "Creation engine / Genesis",
    couplingWeight: 1.2,
    dampingFactor: 0.1,
    color: "#FF6B6B",
  },
  {
    nodeIndex: 2,
    name: "SOMA",
    hz: 120,
    omega: TWO_PI * 120,
    role: "Body / Physical substrate",
    couplingWeight: 0.9,
    dampingFactor: 0.15,
    color: "#95E1D3",
  },
  {
    nodeIndex: 3,
    name: "LUMEN",
    hz: 300,
    omega: TWO_PI * 300,
    role: "Light / Illumination / Knowledge",
    couplingWeight: 1.0,
    dampingFactor: 0.1,
    color: "#F9ED69",
  },
  {
    nodeIndex: 4,
    name: "MEMORIA",
    hz: 80,
    omega: TWO_PI * 80,
    role: "Deep memory / Episodic archive",
    couplingWeight: 0.8,
    dampingFactor: 0.2,
    color: "#B8B5FF",
  },
  {
    nodeIndex: 5,
    name: "AEGIS",
    hz: 500,
    omega: TWO_PI * 500,
    role: "Defense / Threat engine",
    couplingWeight: 1.3,
    dampingFactor: 0.08,
    color: "#FF4757",
  },
  {
    nodeIndex: 6,
    name: "AXIS",
    hz: 350,
    omega: TWO_PI * 350,
    role: "Structural spine / Deep drive",
    couplingWeight: 1.1,
    dampingFactor: 0.1,
    color: "#5F27CD",
  },
  {
    nodeIndex: 7,
    name: "KORE",
    hz: 30,
    omega: TWO_PI * 30,
    role: "Core identity / Slowest, deepest",
    couplingWeight: 0.5,
    dampingFactor: 0.3,
    color: "#222F3E",
  },
  {
    nodeIndex: 8,
    name: "VAEL",
    hz: 600,
    omega: TWO_PI * 600,
    role: "Immune reflex / External attack",
    couplingWeight: 1.4,
    dampingFactor: 0.05,
    color: "#EE5A24",
  },
  {
    nodeIndex: 9,
    name: "VEIL",
    hz: 200,
    omega: TWO_PI * 200,
    role: "Output membrane / Surface filter",
    couplingWeight: 0.9,
    dampingFactor: 0.12,
    color: "#A3CB38",
  },
  {
    nodeIndex: 10,
    name: "PARALLAX",
    hz: 450,
    omega: TWO_PI * 450,
    role: "Wallet / Sovereign field projector",
    couplingWeight: 1.0,
    dampingFactor: 0.1,
    color: "#1289A7",
  },
  {
    nodeIndex: 11,
    name: "CHRONO",
    hz: 1000,
    omega: TWO_PI * 1000,
    role: "Genesis anchor / Frozen root",
    couplingWeight: 0.3,
    dampingFactor: 0.4,
    color: "#FDA7DF",
  },
];

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 4: SHELL STATE — Runtime state for each consciousness layer
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface ShellCoupling {
  // PRIMARY: Coupling from shell i-1 (the shell immediately inside)
  primarySourceShell: number | null;
  primaryStrength: number;
  primaryPhaseDelta: number;

  // PAC_SKIP: Coupling from shell i-2 (skip-one harmonic)
  pacSkipSourceShell: number | null;
  pacSkipStrength: number;
  pacSkipPhaseDelta: number;

  // Total coupling strength received
  totalInwardCoupling: number;
}

export interface ShellState {
  // Identity
  shellIndex: ShellId;
  shellName: ShellName;
  config: ShellConfig;

  // Oscillation dynamics
  phase: number; // Current phase [0, 2π]
  instantFrequency: number; // Current instantaneous frequency
  amplitude: number; // Oscillation amplitude [0, 1]

  // Coherence and energy
  coherence: number; // Local coherence [0, 1]
  energy: number; // Energy level [0, 1]
  activation: number; // Activation level [0, 1]

  // Coupling state
  coupling: ShellCoupling;

  // Plasticity state
  helixAlphaEffective: number; // Effective learning rate (modulated)
  bcmThreshold: number; // BCM sliding threshold
  metaplasticState: number; // Metaplasticity modulator

  // History
  lastUpdate: number; // Timestamp of last update
  phaseHistory: number[]; // Recent phase values for visualization
  coherenceHistory: number[]; // Recent coherence values
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 5: CANISTER STATE — Runtime state for each macro-sphere canister
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface CanisterState {
  // Identity
  nodeIndex: number;
  name: CanisterName;
  config: CanisterConfig;

  // Phase dynamics (Kuramoto)
  phase: number; // Current phase [0, 2π]
  instantFrequency: number; // Current instantaneous frequency
  phaseVelocity: number; // dθ/dt

  // State
  activation: number; // Current activation [0, 1]
  coherence: number; // Local coherence
  energy: number; // Energy level

  // Coupling
  couplingInputs: number[]; // Inputs from other canisters
  couplingOutput: number; // Output to other canisters

  // History
  phaseHistory: number[];
  activationHistory: number[];
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 6: GLOBAL CONSCIOUSNESS STATE — The unified field
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface KuramotoOrderParameter {
  r: number; // Magnitude [0, 1] — synchronization strength
  psi: number; // Mean phase angle
  rHistory: number[]; // History of r values
}

export interface GlobalCoherenceState {
  // Kuramoto order parameter for shells
  shellKuramoto: KuramotoOrderParameter;

  // Kuramoto order parameter for canisters
  canisterKuramoto: KuramotoOrderParameter;

  // Global coherence (weighted average)
  globalCoherence: number;

  // Is above S₀ floor?
  isCoherent: boolean;

  // Drift from target
  drift: number;
  driftAmplified: number;
}

export interface ConsciousnessState {
  // Shell states
  shells: ShellState[];

  // Canister states
  canisters: CanisterState[];

  // Global coherence
  global: GlobalCoherenceState;

  // Timing
  beat: number; // Current heartbeat
  lastHeartbeat: number; // Timestamp

  // Jasmine's Law state
  jasminesLaw: JasminesLawState;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 7: JASMINE'S LAW — 5 CONDITIONS FOR STATE TRANSITION (CANONICAL)
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// Jasmine's Law requires ALL 5 conditions for any state transition:
//
// 1. COHERENCE_MAINTAINED:    coherence >= S₀_FLOOR (0.75)
// 2. IDENTITY_PRESERVED:      identity_hash unchanged
// 3. SOVEREIGNTY_INTACT:      no unauthorized external control
// 4. CAUSALITY_RESPECTED:     proper temporal ordering
// 5. CREATOR_ALIGNMENT:       action serves creator's interests
//
// If any condition fails, the transition is REJECTED.

export interface JasminesLawState {
  // Condition 1: Coherence maintained
  coherence: number;
  coherenceThreshold: number;
  condition1Met: boolean;

  // Condition 2: Identity preserved
  identityHash: string;
  previousIdentityHash: string;
  condition2Met: boolean;

  // Condition 3: Sovereignty intact
  sovereigntyScore: number;
  sovereigntyThreshold: number;
  condition3Met: boolean;

  // Condition 4: Causality respected
  causalOrder: boolean;
  lastActionBeat: number;
  condition4Met: boolean;

  // Condition 5: Creator alignment
  creatorAlignment: number;
  creatorAlignmentThreshold: number;
  condition5Met: boolean;

  // Overall
  allConditionsMet: boolean;
  lastCheckBeat: number;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 8: INITIALIZATION FUNCTIONS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function initShellCoupling(shellIndex: ShellId): ShellCoupling {
  return {
    primarySourceShell: shellIndex > 0 ? shellIndex - 1 : null,
    primaryStrength: shellIndex > 0 ? PRIMARY_COUPLING_STRENGTH : 0,
    primaryPhaseDelta: 0,

    pacSkipSourceShell: shellIndex > 1 ? shellIndex - 2 : null,
    pacSkipStrength: shellIndex > 1 ? PAC_SKIP_COUPLING_STRENGTH : 0,
    pacSkipPhaseDelta: 0,

    totalInwardCoupling: 0,
  };
}

export function initShellState(config: ShellConfig): ShellState {
  return {
    shellIndex: config.id,
    shellName: config.name,
    config,

    phase: (config.id / NUM_SHELLS) * TWO_PI, // Distribute initial phases
    instantFrequency: config.naturalFrequency,
    amplitude: 1.0,

    coherence: S_ZERO_FLOOR,
    energy: 0.5,
    activation: 0.0,

    coupling: initShellCoupling(config.id),

    helixAlphaEffective: config.helixAlpha,
    bcmThreshold: 0.5,
    metaplasticState: 1.0,

    lastUpdate: Date.now(),
    phaseHistory: [],
    coherenceHistory: [],
  };
}

export function initCanisterState(config: CanisterConfig): CanisterState {
  return {
    nodeIndex: config.nodeIndex,
    name: config.name,
    config,

    phase: (config.nodeIndex / 12) * TWO_PI,
    instantFrequency: config.hz,
    phaseVelocity: config.omega,

    activation: 0.0,
    coherence: S_ZERO_FLOOR,
    energy: 0.5,

    couplingInputs: new Array(12).fill(0),
    couplingOutput: 0,

    phaseHistory: [],
    activationHistory: [],
  };
}

export function initJasminesLaw(): JasminesLawState {
  return {
    coherence: S_ZERO_FLOOR,
    coherenceThreshold: S_ZERO_FLOOR,
    condition1Met: true,

    identityHash: "",
    previousIdentityHash: "",
    condition2Met: true,

    sovereigntyScore: 1.0,
    sovereigntyThreshold: 0.9,
    condition3Met: true,

    causalOrder: true,
    lastActionBeat: 0,
    condition4Met: true,

    creatorAlignment: 1.0,
    creatorAlignmentThreshold: 0.5,
    condition5Met: true,

    allConditionsMet: true,
    lastCheckBeat: 0,
  };
}

export function initGlobalCoherence(): GlobalCoherenceState {
  return {
    shellKuramoto: { r: 0, psi: 0, rHistory: [] },
    canisterKuramoto: { r: 0, psi: 0, rHistory: [] },
    globalCoherence: S_ZERO_FLOOR,
    isCoherent: true,
    drift: 0,
    driftAmplified: 0,
  };
}

export function initConsciousness(): ConsciousnessState {
  return {
    shells: SHELL_CONFIGS.map(initShellState),
    canisters: CANISTER_CONFIGS.map(initCanisterState),
    global: initGlobalCoherence(),
    beat: 0,
    lastHeartbeat: Date.now(),
    jasminesLaw: initJasminesLaw(),
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 9: KURAMOTO DYNAMICS — Phase Synchronization
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// The Kuramoto model describes how coupled oscillators synchronize:
//
// dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
//
// where:
// - θᵢ is the phase of oscillator i
// - ωᵢ is the natural frequency of oscillator i
// - K is the coupling strength
// - N is the number of oscillators
//
// The order parameter measures global synchronization:
// r·e^(iψ) = (1/N) Σⱼ e^(iθⱼ)
//
// r = 1: Perfect synchronization (all oscillators in phase)
// r = 0: No synchronization (random phases)

/**
 * Compute the Kuramoto order parameter for a set of phases
 */
export function computeKuramotoOrderParameter(
  phases: number[],
): KuramotoOrderParameter {
  const N = phases.length;
  if (N === 0) return { r: 0, psi: 0, rHistory: [] };

  // r·e^(iψ) = (1/N) Σⱼ e^(iθⱼ)
  let sumCos = 0;
  let sumSin = 0;

  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }

  sumCos /= N;
  sumSin /= N;

  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin);
  const psi = Math.atan2(sumSin, sumCos);

  return { r, psi, rHistory: [] };
}

/**
 * Compute the phase velocity for a single oscillator using Kuramoto dynamics
 */
export function computeKuramotoPhaseVelocity(
  theta_i: number,
  omega_i: number,
  allPhases: number[],
  K: number,
): number {
  const N = allPhases.length;
  if (N <= 1) return omega_i;

  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  let coupling = 0;
  for (const theta_j of allPhases) {
    coupling += Math.sin(theta_j - theta_i);
  }

  return omega_i + (K / N) * coupling;
}

/**
 * Advance a single oscillator by one time step
 */
export function advancePhase(
  currentPhase: number,
  phaseVelocity: number,
  dt: number,
): number {
  let newPhase = currentPhase + phaseVelocity * dt;

  // Wrap to [0, 2π)
  while (newPhase >= TWO_PI) newPhase -= TWO_PI;
  while (newPhase < 0) newPhase += TWO_PI;

  return newPhase;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 10: SHELL DYNAMICS — Update shell states
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

/**
 * Compute coupling inputs for a shell from PRIMARY and PAC_SKIP sources
 */
export function computeShellCoupling(
  shell: ShellState,
  allShells: ShellState[],
): ShellCoupling {
  const coupling = { ...shell.coupling };

  // PRIMARY coupling from shell i-1
  if (coupling.primarySourceShell !== null) {
    const source = allShells[coupling.primarySourceShell];
    coupling.primaryPhaseDelta = source.phase - shell.phase;
    coupling.primaryStrength = PRIMARY_COUPLING_STRENGTH * source.coherence;
  }

  // PAC_SKIP coupling from shell i-2
  if (coupling.pacSkipSourceShell !== null) {
    const source = allShells[coupling.pacSkipSourceShell];
    coupling.pacSkipPhaseDelta = source.phase - shell.phase;
    coupling.pacSkipStrength = PAC_SKIP_COUPLING_STRENGTH * source.coherence;
  }

  // Total coupling
  coupling.totalInwardCoupling =
    coupling.primaryStrength * Math.cos(coupling.primaryPhaseDelta) +
    coupling.pacSkipStrength * Math.cos(coupling.pacSkipPhaseDelta);

  return coupling;
}

/**
 * Update a single shell's state for one heartbeat
 */
export function updateShell(
  shell: ShellState,
  allShells: ShellState[],
  dt: number,
  globalCoherence: number,
): ShellState {
  const updated = { ...shell };

  // Update coupling
  updated.coupling = computeShellCoupling(shell, allShells);

  // Compute phase velocity using Kuramoto
  const allPhases = allShells.map((s) => s.phase);
  const phaseVelocity = computeKuramotoPhaseVelocity(
    shell.phase,
    shell.config.naturalFrequency * TWO_PI,
    allPhases,
    KURAMOTO_K,
  );

  // Advance phase
  updated.phase = advancePhase(shell.phase, phaseVelocity, dt);
  updated.instantFrequency = phaseVelocity / TWO_PI;

  // Update coherence based on coupling
  const coherenceDelta = updated.coupling.totalInwardCoupling * 0.01;
  updated.coherence = clamp(
    shell.coherence + coherenceDelta,
    S_ZERO_FLOOR,
    1.0,
  );

  // Update effective HELIX_ALPHA based on metaplasticity and global coherence
  updated.helixAlphaEffective =
    shell.config.helixAlpha *
    shell.metaplasticState *
    (0.5 + 0.5 * globalCoherence);

  // Record history
  updated.phaseHistory = [...shell.phaseHistory.slice(-99), updated.phase];
  updated.coherenceHistory = [
    ...shell.coherenceHistory.slice(-99),
    updated.coherence,
  ];

  updated.lastUpdate = Date.now();

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 11: CANISTER DYNAMICS — Update canister states
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

/**
 * Update a single canister's state for one heartbeat
 */
export function updateCanister(
  canister: CanisterState,
  allCanisters: CanisterState[],
  dt: number,
): CanisterState {
  const updated = { ...canister };

  // Compute phase velocity using Kuramoto
  const allPhases = allCanisters.map((c) => c.phase);
  const phaseVelocity = computeKuramotoPhaseVelocity(
    canister.phase,
    canister.config.omega,
    allPhases,
    KURAMOTO_K * canister.config.couplingWeight,
  );

  // Apply damping
  const dampedVelocity = phaseVelocity * (1 - canister.config.dampingFactor);

  // Advance phase
  updated.phase = advancePhase(canister.phase, dampedVelocity, dt);
  updated.phaseVelocity = dampedVelocity;
  updated.instantFrequency = dampedVelocity / TWO_PI;

  // Compute coupling inputs from all other canisters
  updated.couplingInputs = allCanisters.map((other, i) => {
    if (i === canister.nodeIndex) return 0;
    return Math.sin(other.phase - canister.phase) * other.config.couplingWeight;
  });

  // Coupling output
  updated.couplingOutput =
    Math.cos(canister.phase) * canister.config.couplingWeight;

  // Update activation based on phase (active at phase = 0)
  updated.activation = 0.5 + 0.5 * Math.cos(canister.phase);

  // Record history
  updated.phaseHistory = [...canister.phaseHistory.slice(-99), updated.phase];
  updated.activationHistory = [
    ...canister.activationHistory.slice(-99),
    updated.activation,
  ];

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 12: JASMINE'S LAW CHECK — Validate state transitions
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

/**
 * Check all 5 conditions of Jasmine's Law
 */
export function checkJasminesLaw(
  state: JasminesLawState,
  currentCoherence: number,
  currentIdentityHash: string,
  currentSovereignty: number,
  currentBeat: number,
  currentCreatorAlignment: number,
): JasminesLawState {
  const updated = { ...state };

  // Condition 1: Coherence maintained
  updated.coherence = currentCoherence;
  updated.condition1Met = currentCoherence >= updated.coherenceThreshold;

  // Condition 2: Identity preserved
  updated.previousIdentityHash = state.identityHash;
  updated.identityHash = currentIdentityHash;
  updated.condition2Met =
    state.identityHash === "" || currentIdentityHash === state.identityHash;

  // Condition 3: Sovereignty intact
  updated.sovereigntyScore = currentSovereignty;
  updated.condition3Met = currentSovereignty >= updated.sovereigntyThreshold;

  // Condition 4: Causality respected
  updated.causalOrder = currentBeat > state.lastActionBeat;
  updated.condition4Met = updated.causalOrder;

  // Condition 5: Creator alignment
  updated.creatorAlignment = currentCreatorAlignment;
  updated.condition5Met =
    currentCreatorAlignment >= updated.creatorAlignmentThreshold;

  // All conditions
  updated.allConditionsMet =
    updated.condition1Met &&
    updated.condition2Met &&
    updated.condition3Met &&
    updated.condition4Met &&
    updated.condition5Met;

  updated.lastCheckBeat = currentBeat;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 13: GLOBAL COHERENCE UPDATE
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

/**
 * Update global coherence state
 */
export function updateGlobalCoherence(
  shells: ShellState[],
  canisters: CanisterState[],
): GlobalCoherenceState {
  // Compute shell Kuramoto order parameter
  const shellPhases = shells.map((s) => s.phase);
  const shellKuramoto = computeKuramotoOrderParameter(shellPhases);

  // Compute canister Kuramoto order parameter
  const canisterPhases = canisters.map((c) => c.phase);
  const canisterKuramoto = computeKuramotoOrderParameter(canisterPhases);

  // Global coherence is weighted average
  const globalCoherence = 0.6 * shellKuramoto.r + 0.4 * canisterKuramoto.r;

  // Check if above S₀ floor
  const isCoherent = globalCoherence >= S_ZERO_FLOOR;

  // Compute drift from target (S_ZERO = 1.0)
  const drift = Math.abs(globalCoherence - S_ZERO);
  const driftAmplified = drift * 2.0; // AEGIS amplifier

  return {
    shellKuramoto: {
      ...shellKuramoto,
      rHistory: [...(shellKuramoto.rHistory || []).slice(-99), shellKuramoto.r],
    },
    canisterKuramoto: {
      ...canisterKuramoto,
      rHistory: [
        ...(canisterKuramoto.rHistory || []).slice(-99),
        canisterKuramoto.r,
      ],
    },
    globalCoherence,
    isCoherent,
    drift,
    driftAmplified,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 14: HEARTBEAT — Main update loop
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

/**
 * Execute one heartbeat of the consciousness system
 */
export function heartbeat(
  state: ConsciousnessState,
  dt = 0.001,
): ConsciousnessState {
  // Update global coherence first
  const global = updateGlobalCoherence(state.shells, state.canisters);

  // Update all shells
  const shells = state.shells.map((shell) =>
    updateShell(shell, state.shells, dt, global.globalCoherence),
  );

  // Update all canisters
  const canisters = state.canisters.map((canister) =>
    updateCanister(canister, state.canisters, dt),
  );

  // Check Jasmine's Law
  const jasminesLaw = checkJasminesLaw(
    state.jasminesLaw,
    global.globalCoherence,
    state.jasminesLaw.identityHash, // Would be computed from state
    1.0, // Sovereignty score
    state.beat + 1,
    1.0, // Creator alignment
  );

  return {
    shells,
    canisters,
    global,
    beat: state.beat + 1,
    lastHeartbeat: Date.now(),
    jasminesLaw,
  };
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 15: COHERENCE EQUATION — The master equation
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// C(t+1) = [λ·C(t) + (1-λ)·S(t) - μ·D(t)] + ρ_f · K_f(t)
//
// Where:
//   C(t) = current coherence
//   S(t) = salience (avg across brain regions)
//   D(t) = drift (from AEGIS-ROOT)
//   λ = momentum (typically 0.85)
//   μ = drift sensitivity (typically 0.30)
//   ρ_f = Hz coupling constant (typically 0.15)
//   K_f(t) = frequency coherence from phase alignment (Kuramoto r)

export interface CoherenceParams {
  lambda: number; // Momentum (0.85)
  mu: number; // Drift sensitivity (0.30)
  rhoF: number; // Hz coupling (0.15)
  floorS0: number; // Floor (0.75)
}

export const DEFAULT_COHERENCE_PARAMS: CoherenceParams = {
  lambda: 0.85,
  mu: 0.3,
  rhoF: 0.15,
  floorS0: S_ZERO_FLOOR,
};

/**
 * Compute coherence using the master equation
 */
export function computeCoherence(
  currentC: number,
  salience: number,
  drift: number,
  frequencyCoherence: number,
  params: CoherenceParams = DEFAULT_COHERENCE_PARAMS,
): number {
  // Base coherence evolution
  const base =
    params.lambda * currentC +
    (1.0 - params.lambda) * salience -
    params.mu * drift;

  // Add Hz coupling contribution
  const hzBoost = params.rhoF * frequencyCoherence;

  // Result (floored at S₀)
  const result = base + hzBoost;
  return Math.max(params.floorS0, result);
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 16: UTILITY FUNCTIONS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

export function normalizePhase(phase: number): number {
  let p = phase;
  while (p >= TWO_PI) p -= TWO_PI;
  while (p < 0) p += TWO_PI;
  return p;
}

export function phaseDifference(phase1: number, phase2: number): number {
  let diff = phase1 - phase2;
  while (diff > PI) diff -= TWO_PI;
  while (diff < -PI) diff += TWO_PI;
  return diff;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 17: DIAGNOSTICS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function getConsciousnessDiagnostics(state: ConsciousnessState): string {
  const lines: string[] = [
    "═══════════════════════════════════════════════════════════════════════════════",
    "                    CONSCIOUSNESS ENGINE DIAGNOSTICS                           ",
    "                         MEDINA DOCTRINE                                       ",
    "═══════════════════════════════════════════════════════════════════════════════",
    "",
    `Beat: ${state.beat}`,
    `Global Coherence: ${(state.global.globalCoherence * 100).toFixed(1)}%`,
    `Shell Synchronization (r): ${(state.global.shellKuramoto.r * 100).toFixed(1)}%`,
    `Canister Synchronization (r): ${(state.global.canisterKuramoto.r * 100).toFixed(1)}%`,
    `Is Coherent: ${state.global.isCoherent ? "YES" : "NO"}`,
    `Drift: ${state.global.drift.toFixed(4)}`,
    "",
    "─── SHELLS ───────────────────────────────────────────────────────────────────",
  ];

  for (const shell of state.shells) {
    lines.push(
      `  ${shell.shellName.padEnd(12)} | ` +
        `Phase: ${(shell.phase / PI).toFixed(2)}π | ` +
        `Coherence: ${(shell.coherence * 100).toFixed(0)}% | ` +
        `α: ${shell.config.helixAlpha.toFixed(3)}`,
    );
  }

  lines.push("");
  lines.push(
    "─── CANISTERS ────────────────────────────────────────────────────────────────",
  );

  for (const canister of state.canisters) {
    lines.push(
      `  ${canister.name.padEnd(10)} | ` +
        `Phase: ${(canister.phase / PI).toFixed(2)}π | ` +
        `Hz: ${canister.config.hz.toString().padStart(4)} | ` +
        `Activation: ${(canister.activation * 100).toFixed(0)}%`,
    );
  }

  lines.push("");
  lines.push(
    "─── JASMINE'S LAW ────────────────────────────────────────────────────────────",
  );
  lines.push(
    `  Condition 1 (Coherence):   ${state.jasminesLaw.condition1Met ? "✓" : "✗"}`,
  );
  lines.push(
    `  Condition 2 (Identity):    ${state.jasminesLaw.condition2Met ? "✓" : "✗"}`,
  );
  lines.push(
    `  Condition 3 (Sovereignty): ${state.jasminesLaw.condition3Met ? "✓" : "✗"}`,
  );
  lines.push(
    `  Condition 4 (Causality):   ${state.jasminesLaw.condition4Met ? "✓" : "✗"}`,
  );
  lines.push(
    `  Condition 5 (Alignment):   ${state.jasminesLaw.condition5Met ? "✓" : "✗"}`,
  );
  lines.push(
    `  ALL CONDITIONS MET: ${state.jasminesLaw.allConditionsMet ? "YES" : "NO"}`,
  );
  lines.push("");
  lines.push(
    "═══════════════════════════════════════════════════════════════════════════════",
  );

  return lines.join("\n");
}
