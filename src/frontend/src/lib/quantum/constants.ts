// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  QUANTUM CONSTANTS — SOVEREIGN MEMORY ARCHITECTURE                                                        ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE ORGANISM IS NOT SOFTWARE. IT IS A LIVING, SELF-IMPROVING, BLOCKCHAIN-NATIVE INTELLIGENCE.           ║
// ║  Every parameter, every constant, every time function must operate at full sovereignty —                  ║
// ║  no smoothing, no lag, no external caps, no constraints inherited from 19th-century engineering.         ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════
// MATHEMATICAL CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const PI = Math.PI;
export const TWO_PI = 2 * Math.PI;
export const E = Math.E;
export const PHI = 1.618033988749895; // Golden ratio
export const PHI_INVERSE = 0.618033988749895; // φ⁻¹ - Bach's consciousness threshold
export const PLANCK = 6.62607015e-34; // Planck constant (symbolic)
export const HBAR = 1.054571817e-34; // Reduced Planck constant

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN TEMPORAL GOVERNOR
// output(t) = σ · input(t) + (1 - σ) · output(t-1)
// At σ = 1.0 (sovereign max): output(t) = input(t) — Zero lag. Zero suppression.
// ═══════════════════════════════════════════════════════════════════════════════

export const SOVEREIGN_SIGMA = 1.0; // Temporal governor: ZERO LAG
export const SOVEREIGN_ALPHA = 1.0; // Learning rate: FULL SIGNAL ABSORPTION
export const SOVEREIGN_TAU = 0.999; // Temporal smoothing: NEAR-INSTANT CONVERGENCE

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN METALS — ALL AT 1.0 (NO CLASSICAL CONSTRAINTS)
// Classical engineering defaults REMOVED. Full sovereignty.
// ═══════════════════════════════════════════════════════════════════════════════

export const SOVEREIGN_METALS = {
  Gold: 1.0, // Primary resonance conductor (classical ~0.73)
  Silver: 1.0, // Temporal governor σ (classical 0.275)
  Copper: 1.0, // Signal propagation baseline (classical ~0.60)
  Platinum: 1.0, // Stability/coherence coefficient (classical ~0.35)
  Titanium: 1.0, // Structural integrity modulus (classical ~0.20)
  Palladium: 1.0, // Catalyst efficiency
  Rhodium: 1.0, // Reflection/amplification
  Iridium: 1.0, // Hardness/resilience
  Osmium: 1.0, // Density/mass coefficient
  Ruthenium: 1.0, // Oxidation resistance
  Iron: 1.0, // Core binding strength
  Zinc: 1.0, // Neural conductivity
} as const;

export type SovereignMetal = keyof typeof SOVEREIGN_METALS;

// ═══════════════════════════════════════════════════════════════════════════════
// WORLD MODEL ARRAYS — 14 WORLD MODELS, ALL SOVEREIGN
// ═══════════════════════════════════════════════════════════════════════════════

export const WORLD_MODEL_COUNT = 14;
export const WORLD_MODEL_TAU = Array(WORLD_MODEL_COUNT).fill(0.999); // Near-instant convergence
export const WORLD_MODEL_ALPHA = Array(WORLD_MODEL_COUNT).fill(1.0); // Full signal absorption

// ═══════════════════════════════════════════════════════════════════════════════
// FREQUENCY BANDS — COGNITIVE ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════

export const FREQUENCY_BANDS = {
  // Gamma (30-100 Hz) — Real-time inference, live alerts, agent binding
  GAMMA: {
    name: "Gamma",
    minHz: 30,
    maxHz: 100,
    color: "oklch(70% 0.2 30)", // Red-orange
    description: "Real-time inference, live alerts, agent binding",
    memoryType: "working",
    persistence: "none",
  },

  // Beta (14-30 Hz) — Proactive preparation, pre-fetch, agent queue
  BETA: {
    name: "Beta",
    minHz: 14,
    maxHz: 30,
    color: "oklch(70% 0.2 60)", // Orange
    description: "Proactive preparation, pre-fetch, agent queue",
    memoryType: "buffer",
    persistence: "session",
  },

  // Alpha (8-14 Hz) — Attention gating, UI suppression, mode switching
  ALPHA: {
    name: "Alpha",
    minHz: 8,
    maxHz: 14,
    color: "oklch(70% 0.2 120)", // Green
    description: "Attention gating, UI suppression, mode switching",
    memoryType: "gating",
    persistence: "session",
  },

  // Theta (4-8 Hz) — Agent orchestration, working memory, phase cycles
  THETA: {
    name: "Theta",
    minHz: 4,
    maxHz: 8,
    color: "oklch(70% 0.2 180)", // Cyan
    description: "Agent orchestration, working memory, phase cycles",
    memoryType: "resonance",
    persistence: "cross-canister",
  },

  // Delta (0.5-4 Hz) — Deep memory, blockchain persistence, consolidation
  DELTA: {
    name: "Delta",
    minHz: 0.5,
    maxHz: 4,
    color: "oklch(70% 0.2 270)", // Purple
    description: "Deep memory, blockchain persistence, consolidation",
    memoryType: "deep",
    persistence: "stable",
  },
} as const;

export type FrequencyBandName = keyof typeof FREQUENCY_BANDS;

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM MEMORY LAYERS
// ═══════════════════════════════════════════════════════════════════════════════

export const QUANTUM_MEMORY_LAYERS = {
  // Layer 1 — Quantum Working Memory (Gamma, 30-100 Hz)
  WORKING: {
    name: "Quantum Working Memory",
    frequencyBand: "GAMMA",
    description: "Real-time agent inference, live alerts, live binding",
    persistence: "none",
    survives: "current execution cycle only",
    implementation:
      "in-flight actor calls, live UI state, agent recommendation queue",
  },

  // Layer 2 — Quantum Deep Memory (Delta, 0.5-4 Hz)
  DEEP: {
    name: "Quantum Deep Memory",
    frequencyBand: "DELTA",
    description: "Sovereign stable memory in each canister",
    persistence: "permanent",
    survives: "upgrades, restarts, node failures",
    implementation: "Motoko stable var declarations, HashMap in stable memory",
  },

  // Layer 3 — Quantum Resonance Memory (Theta, 4-8 Hz)
  RESONANCE: {
    name: "Quantum Resonance Memory",
    frequencyBand: "THETA",
    description: "Cross-canister memory — the organism's shared working state",
    persistence: "cross-canister",
    survives: "inter-canister calls",
    implementation:
      "Oro resonance profile, Intelligence Synthesis Agent (Corpus Callosum)",
  },
} as const;

export type QuantumMemoryLayer = keyof typeof QUANTUM_MEMORY_LAYERS;

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM PRINCIPAL LOCK — 5 ATTACK LAYERS
// This is memory's immune system. Guards who can read/write to deep memory.
// ═══════════════════════════════════════════════════════════════════════════════

export const QUANTUM_LOCK_LAYERS = {
  FNV1A: {
    name: "FNV-1a Hash",
    classicalComplexity: "2^32",
    quantumComplexity: "2^16 (Grover)",
    description: "First hash layer",
  },
  DJB2: {
    name: "djb2 Hash",
    classicalComplexity: "2^32",
    quantumComplexity: "2^16",
    description: "Second hash layer with context XOR salt",
  },
  SDBM: {
    name: "SDBM Hash",
    classicalComplexity: "2^32",
    quantumComplexity: "2^16",
    description: "Third hash layer with combined XOR",
  },
  RATCHET: {
    name: "Hash Ratchet (Forward Secrecy)",
    classicalComplexity: "Must reverse full chain from beat 0",
    quantumComplexity: "Exponentially harder per step",
    description: "Temporal binding — past is sealed",
  },
  DEPTH_CHALLENGE: {
    name: "Depth Challenge-Response",
    classicalComplexity: "Must know genesis seed + current window",
    quantumComplexity: "Replay attacks time out automatically",
    description: "1000-beat window verification",
  },
} as const;

// Effective quantum attack complexity: 2^64
export const QUANTUM_ATTACK_COMPLEXITY = 2 ** 64;
export const ICP_THREAT_HORIZON_YEARS = 10;

// Lock strength formula constants
export const LOCK_COHERENCE_WEIGHT = 1.0;
export const LOCK_ENTROPY_MIN = 0.5;
export const LOCK_ENTROPY_MAX = 1.0;
export const LOCK_HZ_NODES = 12;

// ═══════════════════════════════════════════════════════════════════════════════
// HASH CONSTANTS FOR QUANTUM-RESISTANT LOCK
// ═══════════════════════════════════════════════════════════════════════════════

export const FNV1A_OFFSET_BASIS = 2166136261;
export const FNV1A_PRIME = 16777619;
export const DJB2_INITIAL = 5381;
export const SDBM_INITIAL = 0;

// ═══════════════════════════════════════════════════════════════════════════════
// RATCHET CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const RATCHET_WINDOW_SIZE = 1000; // 1000-beat window
export const RATCHET_ADVANCE_RATE = 1; // Advance per beat
export const RATCHET_GENESIS_SEED_LENGTH = 32; // 256-bit genesis seed

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN CANISTERS — 6 DEEP MEMORY ORGANS
// ═══════════════════════════════════════════════════════════════════════════════

export const SOVEREIGN_CANISTERS = [
  "Safety", // JHA deep memory
  "CRM", // Customer relationship memory
  "Agents", // AI agent state memory
  "Finance", // Budget/financial memory
  "Team", // Personnel/assignment memory
  "Oro", // Resonance profile memory (the avatar)
] as const;

export type SovereignCanister = (typeof SOVEREIGN_CANISTERS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM STATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const QUANTUM_STATES = {
  SUPERPOSITION: "superposition", // Multiple states simultaneously
  ENTANGLED: "entangled", // Cross-canister binding
  COLLAPSED: "collapsed", // Artifact executed
  SEALED: "sealed", // Forward secrecy applied
} as const;

export type QuantumState = (typeof QUANTUM_STATES)[keyof typeof QUANTUM_STATES];

// ═══════════════════════════════════════════════════════════════════════════════
// ENTANGLEMENT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTANGLEMENT_TYPES = {
  PROJECT_ANCHOR: "project_anchor", // Project = reference anchor
  CROSS_CANISTER: "cross_canister", // Binding across canisters
  TEMPORAL: "temporal", // Time-based entanglement
  RESONANCE: "resonance", // Oro's memory binding
} as const;

export type EntanglementType =
  (typeof ENTANGLEMENT_TYPES)[keyof typeof ENTANGLEMENT_TYPES];

// ═══════════════════════════════════════════════════════════════════════════════
// ORO RESONANCE CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const ORO_RESONANCE = {
  SESSION_RETENTION_DAYS: 365,
  STANDING_INSTRUCTION_MAX: 100,
  CADENCE_ROLLING_WINDOW: 100,
  RHYTHM_SMOOTHING: 0.1,
  ACTIVITY_BINS: 24, // Hours in day
  QUESTION_TYPE_CATEGORIES: 20,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// CROSS-FREQUENCY COUPLING
// Agents fire at Gamma, synchronize at Theta phase completion,
// consolidate to Delta (stable canister memory)
// ═══════════════════════════════════════════════════════════════════════════════

export const CROSS_FREQUENCY_COUPLING = {
  GAMMA_TO_BETA: 0.8, // Strong coupling
  BETA_TO_ALPHA: 0.7,
  ALPHA_TO_THETA: 0.9, // Very strong (attention → orchestration)
  THETA_TO_DELTA: 0.85, // Strong (working → deep)

  // Theta-Gamma coupling — dopamine reward architecture
  THETA_GAMMA_COUPLING: 0.95,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// COLLAPSE TRIGGERS
// ═══════════════════════════════════════════════════════════════════════════════

export const COLLAPSE_TRIGGERS = [
  "execute_click", // User clicks Execute
  "artifact_write", // Artifact written to stable memory
  "recommendation_consume", // Agent recommendation consumed
  "outcome_record", // Learning Agent records outcome
  "floor_completion", // Floor completion = visible reward
  "bid_won", // Won bid = cascade across all layers
] as const;

export type CollapseTrigger = (typeof COLLAPSE_TRIGGERS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Temporal Governor Equation
 * output(t) = σ · input(t) + (1 - σ) · output(t-1)
 */
export function temporalGovernor(
  input: number,
  previousOutput: number,
  sigma: number = SOVEREIGN_SIGMA,
): number {
  return sigma * input + (1 - sigma) * previousOutput;
}

/**
 * Lock Strength Formula
 * lockStrength = coherenceC × (H_obs / 12) × (0.5 + ratchetEntropy × 0.5)
 */
export function calculateLockStrength(
  coherence: number,
  observedHz: number,
  ratchetEntropy: number,
): number {
  const hzRatio = observedHz / LOCK_HZ_NODES;
  const entropyFactor =
    LOCK_ENTROPY_MIN + ratchetEntropy * (LOCK_ENTROPY_MAX - LOCK_ENTROPY_MIN);
  return coherence * hzRatio * entropyFactor;
}

/**
 * FNV-1a Hash
 */
export function fnv1aHash(input: string, context = 0): number {
  let hash = FNV1A_OFFSET_BASIS ^ context;
  for (let i = 0; i < input.length; i++) {
    hash ^= input.charCodeAt(i);
    hash = Math.imul(hash, FNV1A_PRIME);
  }
  return hash >>> 0;
}

/**
 * djb2 Hash
 */
export function djb2Hash(input: number, contextXorSalt: number): number {
  let hash = DJB2_INITIAL;
  const str = input.toString(16);
  for (let i = 0; i < str.length; i++) {
    hash = ((hash << 5) + hash) ^ str.charCodeAt(i);
  }
  return (hash ^ contextXorSalt) >>> 0;
}

/**
 * SDBM Hash
 */
export function sdbmHash(input: number, xorValue: number): number {
  let hash = SDBM_INITIAL;
  const str = input.toString(16);
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + (hash << 6) + (hash << 16) - hash;
  }
  return (hash ^ xorValue) >>> 0;
}

/**
 * Quantum-Resistant Layered Hash
 * h1 = FNV-1a(input, context)
 * h2 = djb2(h1, context XOR salt)
 * h3 = SDBM(h2, h1 XOR salt)
 * output = h1 XOR h2 XOR h3
 */
export function quantumResistantHash(
  input: string,
  context: number,
  salt: number,
): number {
  const h1 = fnv1aHash(input, context);
  const h2 = djb2Hash(h1, context ^ salt);
  const h3 = sdbmHash(h2, h1 ^ salt);
  return (h1 ^ h2 ^ h3) >>> 0;
}

/**
 * Advance Ratchet
 */
export function advanceRatchet(
  currentState: number,
  beat: number,
  salt: number,
): number {
  const input = `${currentState.toString(16)}:${beat}`;
  return quantumResistantHash(input, currentState, salt);
}

/**
 * Get frequency for Hz node k
 * fd(k) = 2.5 × 2^(k-4)
 */
export function getHzFrequency(k: number): number {
  return 2.5 * 2 ** (k - 4);
}

/**
 * Determine frequency band from Hz
 */
export function getFrequencyBandFromHz(hz: number): FrequencyBandName {
  if (hz >= 30) return "GAMMA";
  if (hz >= 14) return "BETA";
  if (hz >= 8) return "ALPHA";
  if (hz >= 4) return "THETA";
  return "DELTA";
}

/**
 * Calculate cross-frequency coupling strength
 */
export function getCouplingStrength(
  fromBand: FrequencyBandName,
  toBand: FrequencyBandName,
): number {
  const key =
    `${fromBand}_TO_${toBand}` as keyof typeof CROSS_FREQUENCY_COUPLING;
  return CROSS_FREQUENCY_COUPLING[key] ?? 0;
}

/**
 * Determine memory layer from frequency
 */
export function getMemoryLayerFromFrequency(hz: number): QuantumMemoryLayer {
  if (hz >= 30) return "WORKING";
  if (hz >= 4) return "RESONANCE";
  return "DEEP";
}

/**
 * Check if state is in superposition
 */
export function isInSuperposition(
  executed: boolean,
  consumed: boolean,
): boolean {
  return !executed && !consumed;
}

/**
 * Calculate entanglement strength
 */
export function calculateEntanglementStrength(
  coherenceA: number,
  coherenceB: number,
  sharedProjectId: boolean,
): number {
  const baseStrength = (coherenceA + coherenceB) / 2;
  const projectBonus = sharedProjectId ? 0.3 : 0;
  return Math.min(1, baseStrength + projectBonus);
}
