/**
 * ENTITY BRAIN SYSTEM - SUPER ORGANISM VERSION
 *
 * 290 ENTITIES × 42 WEIGHTS × 60 HZ = 733,000 UPDATES/SEC
 *
 * Each entity has:
 * - 7 brain regions (matching super brain architecture)
 * - 42 Hebbian weights (7×6 connections)
 * - 6 drives competing via noisy argmax
 * - Memory systems (danger zones, prediction error)
 * - Learning at 60 Hz
 *
 * MEDINA'S MIRROR LAW:
 * Backend: Deep memory - the organism's long-term identity
 * Frontend: Working memory - real-time expression
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// ENTITY BRAIN CONSTANTS
// ============================================================================

export const ENTITY_BRAIN_CONSTANTS = {
  /** Maximum entities in simulation */
  MAX_ENTITIES: 500,

  /** Default entity count */
  DEFAULT_ENTITIES: 290,

  /** Brain regions per entity */
  REGIONS_PER_ENTITY: 7,

  /** Hebbian weights per entity (7×6 connections) */
  WEIGHTS_PER_ENTITY: 42,

  /** Drives per entity */
  DRIVES_PER_ENTITY: 6,

  /** Update rate (Hz) */
  UPDATE_RATE: 60,

  /** Updates per second (290 × 42 × 60) */
  UPDATES_PER_SECOND: 733200,

  /** Learning rate η */
  LEARNING_RATE: 0.01,

  /** Decay rate λ */
  DECAY_RATE: 0.001,

  /** Sovereign floor - weights never decay below this */
  SOVEREIGN_FLOOR: 0.75,

  /** Maximum weight */
  MAX_WEIGHT: 1.0,

  /** Softmax temperature for drive selection */
  SOFTMAX_TEMPERATURE: 1.0,

  /** Exploration epsilon */
  EXPLORATION_EPSILON: 0.1,

  /** Drive history length */
  DRIVE_HISTORY_LENGTH: 100,

  /** Danger zone memory decay rate */
  DANGER_ZONE_DECAY: 0.033,

  /** Danger zone decay ticks */
  DANGER_ZONE_DECAY_TICKS: 30,

  /** Prediction error window */
  PREDICTION_ERROR_WINDOW: 20,
} as const;

// ============================================================================
// ENTITY BRAIN REGIONS (7 REGIONS)
// Simplified version of 64-node super brain
// ============================================================================

export const ENTITY_BRAIN_REGIONS = {
  PFC: 0, // Prefrontal Cortex - planning, decision making
  AMYGDALA: 1, // Amygdala - fear, emotion
  HIPPOCAMPUS: 2, // Hippocampus - memory, navigation
  CEREBELLUM: 3, // Cerebellum - coordination, timing
  BRAINSTEM: 4, // Brainstem - basic survival
  THALAMUS: 5, // Thalamus - sensory relay
  BASAL_GANGLIA: 6, // Basal Ganglia - reward, action selection
} as const;

export type EntityBrainRegion =
  (typeof ENTITY_BRAIN_REGIONS)[keyof typeof ENTITY_BRAIN_REGIONS];
export const ENTITY_BRAIN_REGION_COUNT = 7;

export const ENTITY_BRAIN_REGION_NAMES: Record<EntityBrainRegion, string> = {
  [ENTITY_BRAIN_REGIONS.PFC]: "Prefrontal Cortex",
  [ENTITY_BRAIN_REGIONS.AMYGDALA]: "Amygdala",
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS]: "Hippocampus",
  [ENTITY_BRAIN_REGIONS.CEREBELLUM]: "Cerebellum",
  [ENTITY_BRAIN_REGIONS.BRAINSTEM]: "Brainstem",
  [ENTITY_BRAIN_REGIONS.THALAMUS]: "Thalamus",
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA]: "Basal Ganglia",
};

// ============================================================================
// ENTITY DRIVES (6 DRIVES)
// ============================================================================

export const ENTITY_DRIVES = {
  SURVIVE: 0, // Basic survival - avoid danger, maintain health
  EXPLORE: 1, // Exploration - discover new areas, satisfy curiosity
  SOCIALIZE: 2, // Social - group with others, maintain cohesion
  AGGRESS: 3, // Aggression - attack enemies, defend territory
  ACQUIRE: 4, // Acquisition - gather resources, accumulate
  REST: 5, // Rest - conserve energy, recover
} as const;

export type EntityDrive = (typeof ENTITY_DRIVES)[keyof typeof ENTITY_DRIVES];
export const ENTITY_DRIVE_COUNT = 6;

export const ENTITY_DRIVE_NAMES: Record<EntityDrive, string> = {
  [ENTITY_DRIVES.SURVIVE]: "Survive",
  [ENTITY_DRIVES.EXPLORE]: "Explore",
  [ENTITY_DRIVES.SOCIALIZE]: "Socialize",
  [ENTITY_DRIVES.AGGRESS]: "Aggress",
  [ENTITY_DRIVES.ACQUIRE]: "Acquire",
  [ENTITY_DRIVES.REST]: "Rest",
};

export const ENTITY_DRIVE_COLORS: Record<EntityDrive, string> = {
  [ENTITY_DRIVES.SURVIVE]: "#FF0000", // Red
  [ENTITY_DRIVES.EXPLORE]: "#00FF00", // Green
  [ENTITY_DRIVES.SOCIALIZE]: "#0000FF", // Blue
  [ENTITY_DRIVES.AGGRESS]: "#FF8C00", // Orange
  [ENTITY_DRIVES.ACQUIRE]: "#FFD700", // Gold
  [ENTITY_DRIVES.REST]: "#9370DB", // Purple
};

// ============================================================================
// HEBBIAN WEIGHT CONNECTIONS
// 7 regions × 6 connections per region = 42 weights
// ============================================================================

export const HEBBIAN_CONNECTIONS: Array<
  [EntityBrainRegion, EntityBrainRegion]
> = [
  // PFC connections (to all others)
  [ENTITY_BRAIN_REGIONS.PFC, ENTITY_BRAIN_REGIONS.AMYGDALA],
  [ENTITY_BRAIN_REGIONS.PFC, ENTITY_BRAIN_REGIONS.HIPPOCAMPUS],
  [ENTITY_BRAIN_REGIONS.PFC, ENTITY_BRAIN_REGIONS.CEREBELLUM],
  [ENTITY_BRAIN_REGIONS.PFC, ENTITY_BRAIN_REGIONS.BRAINSTEM],
  [ENTITY_BRAIN_REGIONS.PFC, ENTITY_BRAIN_REGIONS.THALAMUS],
  [ENTITY_BRAIN_REGIONS.PFC, ENTITY_BRAIN_REGIONS.BASAL_GANGLIA],

  // AMYGDALA connections
  [ENTITY_BRAIN_REGIONS.AMYGDALA, ENTITY_BRAIN_REGIONS.PFC],
  [ENTITY_BRAIN_REGIONS.AMYGDALA, ENTITY_BRAIN_REGIONS.HIPPOCAMPUS],
  [ENTITY_BRAIN_REGIONS.AMYGDALA, ENTITY_BRAIN_REGIONS.CEREBELLUM],
  [ENTITY_BRAIN_REGIONS.AMYGDALA, ENTITY_BRAIN_REGIONS.BRAINSTEM],
  [ENTITY_BRAIN_REGIONS.AMYGDALA, ENTITY_BRAIN_REGIONS.THALAMUS],
  [ENTITY_BRAIN_REGIONS.AMYGDALA, ENTITY_BRAIN_REGIONS.BASAL_GANGLIA],

  // HIPPOCAMPUS connections
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS, ENTITY_BRAIN_REGIONS.PFC],
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS, ENTITY_BRAIN_REGIONS.AMYGDALA],
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS, ENTITY_BRAIN_REGIONS.CEREBELLUM],
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS, ENTITY_BRAIN_REGIONS.BRAINSTEM],
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS, ENTITY_BRAIN_REGIONS.THALAMUS],
  [ENTITY_BRAIN_REGIONS.HIPPOCAMPUS, ENTITY_BRAIN_REGIONS.BASAL_GANGLIA],

  // CEREBELLUM connections
  [ENTITY_BRAIN_REGIONS.CEREBELLUM, ENTITY_BRAIN_REGIONS.PFC],
  [ENTITY_BRAIN_REGIONS.CEREBELLUM, ENTITY_BRAIN_REGIONS.AMYGDALA],
  [ENTITY_BRAIN_REGIONS.CEREBELLUM, ENTITY_BRAIN_REGIONS.HIPPOCAMPUS],
  [ENTITY_BRAIN_REGIONS.CEREBELLUM, ENTITY_BRAIN_REGIONS.BRAINSTEM],
  [ENTITY_BRAIN_REGIONS.CEREBELLUM, ENTITY_BRAIN_REGIONS.THALAMUS],
  [ENTITY_BRAIN_REGIONS.CEREBELLUM, ENTITY_BRAIN_REGIONS.BASAL_GANGLIA],

  // BRAINSTEM connections
  [ENTITY_BRAIN_REGIONS.BRAINSTEM, ENTITY_BRAIN_REGIONS.PFC],
  [ENTITY_BRAIN_REGIONS.BRAINSTEM, ENTITY_BRAIN_REGIONS.AMYGDALA],
  [ENTITY_BRAIN_REGIONS.BRAINSTEM, ENTITY_BRAIN_REGIONS.HIPPOCAMPUS],
  [ENTITY_BRAIN_REGIONS.BRAINSTEM, ENTITY_BRAIN_REGIONS.CEREBELLUM],
  [ENTITY_BRAIN_REGIONS.BRAINSTEM, ENTITY_BRAIN_REGIONS.THALAMUS],
  [ENTITY_BRAIN_REGIONS.BRAINSTEM, ENTITY_BRAIN_REGIONS.BASAL_GANGLIA],

  // THALAMUS connections
  [ENTITY_BRAIN_REGIONS.THALAMUS, ENTITY_BRAIN_REGIONS.PFC],
  [ENTITY_BRAIN_REGIONS.THALAMUS, ENTITY_BRAIN_REGIONS.AMYGDALA],
  [ENTITY_BRAIN_REGIONS.THALAMUS, ENTITY_BRAIN_REGIONS.HIPPOCAMPUS],
  [ENTITY_BRAIN_REGIONS.THALAMUS, ENTITY_BRAIN_REGIONS.CEREBELLUM],
  [ENTITY_BRAIN_REGIONS.THALAMUS, ENTITY_BRAIN_REGIONS.BRAINSTEM],
  [ENTITY_BRAIN_REGIONS.THALAMUS, ENTITY_BRAIN_REGIONS.BASAL_GANGLIA],

  // BASAL_GANGLIA connections
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA, ENTITY_BRAIN_REGIONS.PFC],
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA, ENTITY_BRAIN_REGIONS.AMYGDALA],
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA, ENTITY_BRAIN_REGIONS.HIPPOCAMPUS],
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA, ENTITY_BRAIN_REGIONS.CEREBELLUM],
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA, ENTITY_BRAIN_REGIONS.BRAINSTEM],
  [ENTITY_BRAIN_REGIONS.BASAL_GANGLIA, ENTITY_BRAIN_REGIONS.THALAMUS],
];

// ============================================================================
// ENTITY BRAIN STATE
// ============================================================================

export interface EntityBrainState {
  /** Entity ID */
  entityId: string;

  /** Entity faction */
  faction: number;

  /** Region activations (7) */
  regionActivations: number[];

  /** Hebbian weights (42) */
  hebbianWeights: number[];

  /** Drive strengths (6) */
  driveStrengths: number[];

  /** Current dominant drive */
  dominantDrive: EntityDrive;

  /** Drive history (last 100 selections) */
  driveHistory: EntityDrive[];

  /** Arousal level (0-1) */
  arousal: number;

  /** Valence (-1 to 1) */
  valence: number;

  /** Coherence with global brain (0-1) */
  coherence: number;

  /** Prediction errors (rolling window) */
  predictionErrors: number[];

  /** Average prediction error */
  avgPredictionError: number;

  /** Danger zones remembered */
  dangerZones: Map<
    string,
    { position: { x: number; y: number }; decay: number }
  >;

  /** Current position */
  position: { x: number; y: number; z: number };

  /** Current velocity */
  velocity: { x: number; y: number; z: number };

  /** Health (0-1) */
  health: number;

  /** Energy (0-1) */
  energy: number;

  /** Experience points */
  xp: number;

  /** Is entity alive? */
  isAlive: boolean;

  /** Last update tick */
  lastUpdateTick: number;

  /** Total learning updates */
  totalUpdates: number;
}

// ============================================================================
// SQUAD STATE
// ============================================================================

export interface SquadState {
  /** Squad ID */
  squadId: string;

  /** Squad faction */
  faction: number;

  /** Member entity IDs */
  members: string[];

  /** Squad leader ID */
  leaderId: string;

  /** Squad cohesion (0-1) */
  cohesion: number;

  /** Squad urgency (0-1) */
  urgency: number;

  /** Squad confidence (0-1) */
  confidence: number;

  /** Squad fatigue (0-1) */
  fatigue: number;

  /** Current objective */
  objective: {
    type: "patrol" | "attack" | "defend" | "gather" | "retreat" | "idle";
    target: { x: number; y: number } | null;
    priority: number;
  };

  /** Squad centroid position */
  centroid: { x: number; y: number };

  /** Formation type */
  formation: "line" | "wedge" | "circle" | "spread" | "cluster";

  /** Average member health */
  avgHealth: number;

  /** Average member energy */
  avgEnergy: number;
}

// ============================================================================
// NEURO EMERGENCE CORE STATE
// ============================================================================

export interface NeuroEmergenceCoreState {
  /** All entity brain states */
  entities: Map<string, EntityBrainState>;

  /** All squad states */
  squads: Map<string, SquadState>;

  /** Global brain state (aggregated) */
  globalBrain: {
    avgActivations: number[];
    avgWeights: number[];
    avgDriveStrengths: number[];
    dominantDrive: EntityDrive;
    globalCoherence: number;
    globalArousal: number;
  };

  /** Population statistics */
  population: {
    total: number;
    byFaction: Record<number, number>;
    byDrive: Record<EntityDrive, number>;
    alive: number;
    dead: number;
  };

  /** Learning statistics */
  learning: {
    totalUpdates: number;
    avgPredictionError: number;
    novelPatternsThisSession: number;
    hebbianUpdateRate: number;
  };

  /** Current tick */
  currentTick: number;

  /** Session start tick */
  sessionStartTick: number;

  /** Is core active? */
  isActive: boolean;
}

// ============================================================================
// ENTITY BRAIN FORMULAS
// ============================================================================

/**
 * Hebbian learning update
 * Δw = η × xᵢ × xⱼ - λ × w
 */
export function hebbianUpdate(
  preActivity: number,
  postActivity: number,
  currentWeight: number,
  eta: number = ENTITY_BRAIN_CONSTANTS.LEARNING_RATE,
  lambda: number = ENTITY_BRAIN_CONSTANTS.DECAY_RATE,
): number {
  const delta = eta * preActivity * postActivity - lambda * currentWeight;
  const newWeight = currentWeight + delta;

  // Clip to valid range with sovereign floor
  return Math.max(
    ENTITY_BRAIN_CONSTANTS.SOVEREIGN_FLOOR,
    Math.min(ENTITY_BRAIN_CONSTANTS.MAX_WEIGHT, newWeight),
  );
}

/**
 * Softmax drive selection (noisy argmax)
 */
export function softmaxDriveSelection(
  driveStrengths: number[],
  temperature: number = ENTITY_BRAIN_CONSTANTS.SOFTMAX_TEMPERATURE,
): number[] {
  const maxStrength = Math.max(...driveStrengths);
  const expValues = driveStrengths.map((s) =>
    Math.exp((s - maxStrength) / temperature),
  );
  const sumExp = expValues.reduce((a, b) => a + b, 0);
  return expValues.map((e) => e / sumExp);
}

/**
 * Select drive using probabilities
 */
export function selectDrive(probabilities: number[]): EntityDrive {
  const r = Math.random();
  let cumulative = 0;

  for (let i = 0; i < probabilities.length; i++) {
    cumulative += probabilities[i];
    if (r <= cumulative) {
      return i as EntityDrive;
    }
  }

  return (probabilities.length - 1) as EntityDrive;
}

/**
 * Calculate prediction error
 * δ = observed - predicted
 */
export function calculatePredictionError(
  observed: number,
  predicted: number,
): number {
  return observed - predicted;
}

/**
 * Update danger zones (decay over time)
 */
export function updateDangerZones(
  dangerZones: Map<
    string,
    { position: { x: number; y: number }; decay: number }
  >,
  decayRate: number = ENTITY_BRAIN_CONSTANTS.DANGER_ZONE_DECAY,
): Map<string, { position: { x: number; y: number }; decay: number }> {
  const updated = new Map<
    string,
    { position: { x: number; y: number }; decay: number }
  >();

  for (const [key, zone] of dangerZones) {
    const newDecay = zone.decay - decayRate;
    if (newDecay > 0) {
      updated.set(key, { ...zone, decay: newDecay });
    }
  }

  return updated;
}

/**
 * Calculate squad cohesion from member positions
 */
export function calculateSquadCohesion(
  memberPositions: Array<{ x: number; y: number }>,
  maxDistance = 50,
): number {
  if (memberPositions.length < 2) return 1;

  const centroid = {
    x:
      memberPositions.reduce((sum, p) => sum + p.x, 0) / memberPositions.length,
    y:
      memberPositions.reduce((sum, p) => sum + p.y, 0) / memberPositions.length,
  };

  const avgDistance =
    memberPositions.reduce((sum, p) => {
      const dx = p.x - centroid.x;
      const dy = p.y - centroid.y;
      return sum + Math.sqrt(dx * dx + dy * dy);
    }, 0) / memberPositions.length;

  return Math.max(0, 1 - avgDistance / maxDistance);
}

// ============================================================================
// ENTITY BRAIN CONFIGURATION
// ============================================================================

export interface EntityBrainConfig {
  /** Maximum entities */
  maxEntities: number;

  /** Learning rate override */
  learningRateOverride: number | null;

  /** Enable Hebbian learning */
  enableHebbian: boolean;

  /** Enable drive competition */
  enableDriveCompetition: boolean;

  /** Enable danger zone memory */
  enableDangerMemory: boolean;

  /** Enable squad dynamics */
  enableSquads: boolean;

  /** Softmax temperature */
  softmaxTemperature: number;

  /** Exploration epsilon */
  explorationEpsilon: number;
}

export const DEFAULT_ENTITY_BRAIN_CONFIG: EntityBrainConfig = {
  maxEntities: ENTITY_BRAIN_CONSTANTS.MAX_ENTITIES,
  learningRateOverride: null,
  enableHebbian: true,
  enableDriveCompetition: true,
  enableDangerMemory: true,
  enableSquads: true,
  softmaxTemperature: ENTITY_BRAIN_CONSTANTS.SOFTMAX_TEMPERATURE,
  explorationEpsilon: ENTITY_BRAIN_CONSTANTS.EXPLORATION_EPSILON,
};

// ============================================================================
// ENTITY BRAIN METRICS
// ============================================================================

export const ENTITY_BRAIN_METRICS = {
  MAX_ENTITIES: 500,
  DEFAULT_ENTITIES: 290,
  REGIONS_PER_ENTITY: 7,
  WEIGHTS_PER_ENTITY: 42,
  DRIVES_PER_ENTITY: 6,
  UPDATE_RATE: 60,
  UPDATES_PER_SECOND: 733200,
  HEBBIAN_CONNECTIONS: 42,
  TOTAL_WEIGHTS_DEFAULT: 12180, // 290 × 42
  TOTAL_REGIONS_DEFAULT: 2030, // 290 × 7
} as const;
