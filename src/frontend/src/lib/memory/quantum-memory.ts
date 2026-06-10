/**
 * QUANTUM MEMORY ARCHITECTURE
 *
 * MEDINA'S FRACTAL ARCHITECTURE - SPHERICAL MEMORY
 *
 * Three memory layers that form a SPHERE:
 * - GAMMA (30-100Hz): Working memory - real-time, center of sphere
 * - DELTA (0.5-4Hz): Deep memory - permanent, outer shell
 * - THETA (4-8Hz): Resonance memory - cross-system, connecting fibers
 *
 * Memory consolidation through Sharp-Wave Ripples (80-120Hz bursts)
 * Knowledge compounds: K(t+1) = K(t) × (1 + r_learn)^Δt
 *
 * FRACTAL: Not linear, not parallel - SPHERICAL
 * Information flows in ALL directions simultaneously
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// MEMORY LAYER DEFINITIONS
// ============================================================================

export const MEMORY_LAYERS = {
  GAMMA: 0, // 30-100Hz - Working memory, real-time
  DELTA: 1, // 0.5-4Hz - Deep memory, permanent
  THETA: 2, // 4-8Hz - Resonance memory, cross-system
} as const;

export type MemoryLayer = (typeof MEMORY_LAYERS)[keyof typeof MEMORY_LAYERS];

export const MEMORY_LAYER_PROPERTIES = {
  [MEMORY_LAYERS.GAMMA]: {
    name: "Gamma Working Memory",
    frequencyRange: { min: 30, max: 100 },
    persistence: "session", // Dies with tab
    capacity: "limited", // 7±2 items
    accessSpeed: "instant", // < 1ms
    consolidationTarget: MEMORY_LAYERS.THETA,
    color: "#FF0000",
    description: "Real-time inference, live state, center of sphere",
  },
  [MEMORY_LAYERS.DELTA]: {
    name: "Delta Deep Memory",
    frequencyRange: { min: 0.5, max: 4 },
    persistence: "permanent", // Survives upgrades FOREVER
    capacity: "unlimited", // Grows without bound
    accessSpeed: "slow", // Requires consolidation
    consolidationTarget: null, // Final destination
    color: "#4B0082",
    description: "Permanent storage, outer shell of sphere",
  },
  [MEMORY_LAYERS.THETA]: {
    name: "Theta Resonance Memory",
    frequencyRange: { min: 4, max: 8 },
    persistence: "cross-session", // Shared state
    capacity: "moderate", // Binding capacity
    accessSpeed: "moderate", // 10-100ms
    consolidationTarget: MEMORY_LAYERS.DELTA,
    color: "#0000FF",
    description: "Cross-canister shared state, connecting fibers",
  },
};

// ============================================================================
// SHARP-WAVE RIPPLE CONSOLIDATION
// 80-120Hz bursts during rest
// ============================================================================

export const SHARP_WAVE_RIPPLE_CONSTANTS = {
  /** Frequency range (Hz) */
  FREQUENCY_MIN: 80,
  FREQUENCY_MAX: 120,

  /** Duration of each ripple (ms) */
  RIPPLE_DURATION: 50,

  /** Interval between ripples during rest (ms) */
  RIPPLE_INTERVAL: 200,

  /** Bilateral probability during calm */
  BILATERAL_CALM_PROBABILITY: 0.5,

  /** Unilateral probability during active */
  UNILATERAL_ACTIVE_PROBABILITY: 0.9,

  /** Consolidation strength per ripple */
  CONSOLIDATION_STRENGTH: 0.1,

  /** Memory trace decay without consolidation */
  TRACE_DECAY_RATE: 0.01,

  /** Replay speedup factor */
  REPLAY_SPEEDUP: 20, // 20x faster than real-time
} as const;

// ============================================================================
// MEMORY ITEM STRUCTURE
// ============================================================================

export interface MemoryTrace {
  id: string;
  layer: MemoryLayer;

  /** Content encoding */
  content: {
    type: "pattern" | "schema" | "episode" | "weight" | "event";
    data: unknown;
    encoding: "sparse" | "dense" | "distributed";
  };

  /** Temporal properties */
  createdAt: number;
  lastAccessedAt: number;
  lastConsolidatedAt: number;
  accessCount: number;

  /** Strength and stability */
  strength: number; // 0-1, decays without rehearsal
  stability: number; // 0-1, increases with consolidation
  salience: number; // 0-1, emotional/attention weight

  /** Associations */
  associatedTraces: string[]; // IDs of connected memories
  associationStrengths: Record<string, number>;

  /** Consolidation state */
  consolidationProgress: number; // 0-1
  isConsolidated: boolean;
  consolidationBeat: number | null;

  /** Origin */
  sourceLayer: MemoryLayer;
  sourceSession: string | null;
  sourceEntity: string | null;
}

// ============================================================================
// HIPPOCAMPAL REPLAY
// Memory consolidation during rest
// ============================================================================

export interface HippocampalReplayState {
  /** Is replay currently active? */
  isReplaying: boolean;

  /** Current replay sequence */
  currentSequence: MemoryTrace[];

  /** Replay position in sequence */
  replayPosition: number;

  /** Replay direction */
  direction: "forward" | "reverse";

  /** Replay speed multiplier */
  speedMultiplier: number;

  /** Bilateral vs unilateral mode */
  mode: "bilateral" | "unilateral";

  /** Target region for consolidation */
  targetRegion: number | null;

  /** Replay statistics */
  stats: {
    totalReplays: number;
    successfulConsolidations: number;
    tracesReplayed: number;
    averageStrengthGain: number;
  };
}

// ============================================================================
// KNOWLEDGE COMPOUNDING
// K(t+1) = K(t) × (1 + r_learn)^Δt
// ============================================================================

export interface KnowledgeCompounding {
  /** Current knowledge level */
  currentLevel: number;

  /** Learning rate r_learn */
  learningRate: number;

  /** Time since last update (beats) */
  deltaT: number;

  /** Compound history */
  history: Array<{
    beat: number;
    level: number;
    rate: number;
    delta: number;
  }>;

  /** Projection */
  projectedLevel: number;
  projectionHorizon: number;
}

/**
 * Calculate knowledge compounding
 * K(t+1) = K(t) × (1 + r_learn)^Δt
 */
export function compoundKnowledge(
  currentK: number,
  learningRate: number,
  deltaT: number,
): number {
  return currentK * (1 + learningRate) ** deltaT;
}

// ============================================================================
// MEMORY GATE
// σ(α × Λ × A × |δ| − θ)
// Determines if memory should be consolidated
// ============================================================================

export interface MemoryGateState {
  /** Gate output (0-1) */
  gateOutput: number;

  /** Parameters */
  alpha: number; // Scaling factor
  lambda: number; // Coherence (Λ)
  arousal: number; // Arousal (A)
  predictionError: number; // |δ|
  theta: number; // Threshold

  /** Gate is open if output > 0.5 */
  isOpen: boolean;

  /** History of gate decisions */
  decisionHistory: Array<{
    tick: number;
    output: number;
    decision: boolean;
    traceId: string | null;
  }>;
}

/**
 * Memory gate function
 * σ(α × Λ × A × |δ| − θ)
 */
export function memoryGate(
  alpha: number,
  coherence: number,
  arousal: number,
  predictionError: number,
  theta: number,
): number {
  const x = alpha * coherence * arousal * Math.abs(predictionError) - theta;
  return 1 / (1 + Math.exp(-x)); // Sigmoid
}

// ============================================================================
// PATTERN LIBRARY
// Schemas from OMNIS events, growing every 50 beats
// ============================================================================

export interface PatternSchema {
  id: string;

  /** Pattern representation */
  signature: number[]; // Weight vector at discovery
  centroid: number[]; // Cluster centroid
  variance: number; // Within-pattern variance

  /** Discovery context */
  discoveryBeat: number;
  discoverySession: string;
  discoveryConditions: {
    coherence: number;
    arousal: number;
    dominantDrive: number;
    activeChemicals: number[];
  };

  /** Pattern statistics */
  occurrenceCount: number;
  lastOccurrenceBeat: number;
  averageStrength: number;
  peakStrength: number;

  /** Relationships */
  parentPatterns: string[]; // Patterns this derived from
  childPatterns: string[]; // Patterns derived from this
  relatedSchemas: string[];

  /** Is this from an OMNIS event? */
  isOmnisPattern: boolean;
  omnisEventId: string | null;
}

export interface PatternLibrary {
  /** All patterns */
  patterns: Map<string, PatternSchema>;

  /** Pattern count */
  totalPatterns: number;

  /** OMNIS patterns count */
  omnisPatterns: number;

  /** Session patterns (not yet consolidated) */
  sessionPatterns: PatternSchema[];

  /** Pattern formation interval (beats) */
  formationInterval: number;

  /** Last pattern formation beat */
  lastFormationBeat: number;

  /** Pattern mining statistics */
  stats: {
    totalFormed: number;
    totalMerged: number;
    totalPruned: number;
    averageLifespan: number;
  };
}

// ============================================================================
// QUANTUM MEMORY STATE
// Complete memory system state
// ============================================================================

export interface QuantumMemoryState {
  /** Memory layers */
  gammaLayer: {
    traces: Map<string, MemoryTrace>;
    capacity: number;
    utilization: number;
  };

  deltaLayer: {
    traces: Map<string, MemoryTrace>;
    totalSize: number;
    oldestTrace: number;
  };

  thetaLayer: {
    traces: Map<string, MemoryTrace>;
    crossSystemBindings: number;
    resonanceStrength: number;
  };

  /** Consolidation system */
  hippocampalReplay: HippocampalReplayState;
  memoryGate: MemoryGateState;

  /** Knowledge compounding */
  knowledgeState: KnowledgeCompounding;

  /** Pattern library */
  patternLibrary: PatternLibrary;

  /** Global metrics */
  totalMemoryTraces: number;
  consolidationRate: number;
  averageTraceStrength: number;
  memoryEntropy: number;

  /** Timing */
  currentBeat: number;
  lastConsolidationBeat: number;
  nextConsolidationBeat: number;
}

// ============================================================================
// MEMORY CONSTANTS
// ============================================================================

export const QUANTUM_MEMORY_CONSTANTS = {
  /** Gamma layer capacity (items) */
  GAMMA_CAPACITY: 7,

  /** Theta binding capacity */
  THETA_CAPACITY: 100,

  /** Delta has unlimited capacity */
  DELTA_CAPACITY: Number.POSITIVE_INFINITY,

  /** Consolidation interval (beats) */
  CONSOLIDATION_INTERVAL: 50,

  /** Pattern formation interval (beats) */
  PATTERN_FORMATION_INTERVAL: 50,

  /** Minimum trace strength to survive */
  MIN_TRACE_STRENGTH: 0.1,

  /** Strength gain per consolidation */
  CONSOLIDATION_STRENGTH_GAIN: 0.15,

  /** Stability gain per consolidation */
  CONSOLIDATION_STABILITY_GAIN: 0.1,

  /** Base learning rate for compounding */
  BASE_LEARNING_RATE: 0.01,

  /** Memory gate alpha */
  GATE_ALPHA: 1.0,

  /** Memory gate theta */
  GATE_THETA: 0.5,

  /** Sovereign floor - memories never decay below this */
  SOVEREIGN_FLOOR: 0.75,
} as const;

// ============================================================================
// FRACTAL MEMORY FLOW
// Spherical architecture - all directions simultaneously
// ============================================================================

export const FRACTAL_MEMORY_FLOW = {
  /** Inward flow: External → Gamma → Theta → Delta */
  INWARD: {
    direction: "inward",
    stages: ["external", "gamma", "theta", "delta"],
    description: "Perception to permanent storage",
  },

  /** Outward flow: Delta → Theta → Gamma → External */
  OUTWARD: {
    direction: "outward",
    stages: ["delta", "theta", "gamma", "external"],
    description: "Memory retrieval to action",
  },

  /** Lateral flow: Within layer, between regions */
  LATERAL: {
    direction: "lateral",
    stages: ["region_a", "region_b"],
    description: "Cross-regional binding",
  },

  /** Resonant flow: Theta oscillations binding all layers */
  RESONANT: {
    direction: "resonant",
    stages: ["all_layers_simultaneously"],
    description: "Theta-gamma coupling for integration",
  },
} as const;

// ============================================================================
// METRICS
// ============================================================================

export const QUANTUM_MEMORY_METRICS = {
  MEMORY_LAYERS: 3,
  TRACE_PROPERTIES: 12,
  CONSOLIDATION_PARAMETERS: 8,
  PATTERN_SCHEMA_FIELDS: 14,
  GATE_PARAMETERS: 5,
  COMPOUNDING_VARIABLES: 4,
  FLOW_DIRECTIONS: 4,
} as const;
