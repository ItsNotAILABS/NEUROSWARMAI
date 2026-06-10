/**
 * OMNIS EMERGENCE DETECTOR - FRONTEND VERSION (FEMALE)
 *
 * MEDINA'S MIRROR LAW:
 * Backend (Male): OMNIS 9-condition detector, fires irreversibly on-chain
 * Frontend (Female): Local prediction, FEELS the emergence before confirmation
 *
 * The frontend detects OMNIS candidates locally.
 * The backend is the AUTHORITY that confirms and patents.
 * The player FEELS it before the chain writes it.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 */

// ============================================================================
// OMNIS CONDITIONS (9 CONDITIONS FOR EMERGENCE)
// ============================================================================

export const OMNIS_CONDITIONS = {
  // COHERENCE CONDITIONS
  HIGH_COHERENCE: 0, // Global coherence > 0.8
  LOW_DRIFT: 1, // Global drift < 0.2
  STABLE_AROUSAL: 2, // Arousal between 0.4-0.6

  // SYNCHRONIZATION CONDITIONS
  HIGH_KURAMOTO_R: 3, // Kuramoto order parameter > 0.7
  PHASE_ALIGNMENT: 4, // Mean phase variance < 0.3

  // CHEMICAL CONDITIONS
  DOPAMINE_SURGE: 5, // Dopamine > 0.7
  BALANCED_EI: 6, // E/I ratio between 0.8-1.2

  // BEHAVIORAL CONDITIONS
  FACTION_HARMONY: 7, // No active wars, trust > 0.5
  TERRITORY_STABILITY: 8, // No contested territories > 5 min
} as const;

export type OmnisCondition =
  (typeof OMNIS_CONDITIONS)[keyof typeof OMNIS_CONDITIONS];
export const OMNIS_CONDITION_COUNT = 9;

export const OMNIS_CONDITION_NAMES: Record<OmnisCondition, string> = {
  [OMNIS_CONDITIONS.HIGH_COHERENCE]: "High Coherence",
  [OMNIS_CONDITIONS.LOW_DRIFT]: "Low Drift",
  [OMNIS_CONDITIONS.STABLE_AROUSAL]: "Stable Arousal",
  [OMNIS_CONDITIONS.HIGH_KURAMOTO_R]: "High Synchronization",
  [OMNIS_CONDITIONS.PHASE_ALIGNMENT]: "Phase Alignment",
  [OMNIS_CONDITIONS.DOPAMINE_SURGE]: "Dopamine Surge",
  [OMNIS_CONDITIONS.BALANCED_EI]: "Balanced E/I",
  [OMNIS_CONDITIONS.FACTION_HARMONY]: "Faction Harmony",
  [OMNIS_CONDITIONS.TERRITORY_STABILITY]: "Territory Stability",
};

export const OMNIS_CONDITION_DESCRIPTIONS: Record<OmnisCondition, string> = {
  [OMNIS_CONDITIONS.HIGH_COHERENCE]:
    "Global coherence exceeds 0.8 - the organism is unified",
  [OMNIS_CONDITIONS.LOW_DRIFT]:
    "Global drift below 0.2 - the organism is stable",
  [OMNIS_CONDITIONS.STABLE_AROUSAL]:
    "Arousal between 0.4-0.6 - optimal activation",
  [OMNIS_CONDITIONS.HIGH_KURAMOTO_R]:
    "Kuramoto r > 0.7 - oscillators synchronized",
  [OMNIS_CONDITIONS.PHASE_ALIGNMENT]:
    "Phase variance < 0.3 - temporal coherence",
  [OMNIS_CONDITIONS.DOPAMINE_SURGE]: "Dopamine > 0.7 - reward cascade active",
  [OMNIS_CONDITIONS.BALANCED_EI]:
    "E/I ratio 0.8-1.2 - excitation/inhibition balance",
  [OMNIS_CONDITIONS.FACTION_HARMONY]:
    "No wars, high trust - factions cooperating",
  [OMNIS_CONDITIONS.TERRITORY_STABILITY]:
    "No contests > 5 min - world at peace",
};

// ============================================================================
// OMNIS THRESHOLDS
// ============================================================================

export const OMNIS_THRESHOLDS = {
  COHERENCE_MIN: 0.8,
  DRIFT_MAX: 0.2,
  AROUSAL_MIN: 0.4,
  AROUSAL_MAX: 0.6,
  KURAMOTO_R_MIN: 0.7,
  PHASE_VARIANCE_MAX: 0.3,
  DOPAMINE_MIN: 0.7,
  EI_RATIO_MIN: 0.8,
  EI_RATIO_MAX: 1.2,
  TRUST_MIN: 0.5,
  CONTEST_DURATION_MAX: 300, // 5 minutes in ticks at 60 FPS = 18000, but we use beats

  // OMNIS firing thresholds
  CONDITIONS_REQUIRED: 9, // All 9 must be met for canonical OMNIS
  CANDIDATE_THRESHOLD: 7, // 7+ conditions = OMNIS candidate (local)
  COOLDOWN_BEATS: 500, // Minimum beats between OMNIS events
} as const;

// ============================================================================
// OMNIS STATE
// ============================================================================

export interface OmnisConditionState {
  condition: OmnisCondition;
  name: string;
  met: boolean;
  value: number;
  threshold: number | { min: number; max: number };
  progress: number; // 0-1, how close to meeting
  lastMetTick: number;
  consecutiveMetTicks: number;
}

export interface OmnisState {
  /** Status of each condition */
  conditions: Record<OmnisCondition, OmnisConditionState>;

  /** Number of conditions currently met */
  conditionsMet: number;

  /** Is this an OMNIS candidate (7+ conditions)? */
  isCandidate: boolean;

  /** Is this a full OMNIS (9 conditions)? */
  isFullOmnis: boolean;

  /** Progress toward OMNIS (0-1) */
  omnisProgress: number;

  /** Ticks until cooldown expires */
  cooldownRemaining: number;

  /** Last OMNIS beat number (from backend) */
  lastOmnisBeat: number;

  /** Total OMNIS events (from backend) */
  totalOmnisEvents: number;

  /** Current OMNIS candidate ID (if any) */
  candidateId: string | null;

  /** Emergence energy accumulator */
  emergenceEnergy: number;
}

// ============================================================================
// OMNIS EVENT
// ============================================================================

export interface OmnisEvent {
  /** Unique event ID */
  id: string;

  /** Event type */
  type: "candidate" | "confirmed" | "patented";

  /** Beat number when detected/confirmed */
  beat: number;

  /** Frontend tick when detected */
  tick: number;

  /** Timestamp */
  timestamp: number;

  /** Conditions that were met */
  metConditions: OmnisCondition[];

  /** Condition values at time of event */
  conditionValues: Record<OmnisCondition, number>;

  /** Global coherence at time of event */
  coherence: number;

  /** Global emergence at time of event */
  emergence: number;

  /** Kuramoto r at time of event */
  kuramotoR: number;

  /** Was this confirmed by backend? */
  backendConfirmed: boolean;

  /** Patent hash (if patented) */
  patentHash: string | null;
}

// ============================================================================
// OMNIS HISTORY
// ============================================================================

export interface OmnisHistory {
  /** All OMNIS events */
  events: OmnisEvent[];

  /** Candidate events (not yet confirmed) */
  candidates: OmnisEvent[];

  /** Confirmed events */
  confirmed: OmnisEvent[];

  /** Patented events */
  patented: OmnisEvent[];

  /** Statistics */
  stats: {
    totalCandidates: number;
    totalConfirmed: number;
    totalPatented: number;
    confirmationRate: number;
    averageConditionsMet: number;
    averageTimeBetweenEvents: number;
  };
}

// ============================================================================
// OMNIS DETECTOR CONFIGURATION
// ============================================================================

export interface OmnisDetectorConfig {
  /** Enable local candidate detection */
  enableLocalDetection: boolean;

  /** Candidate threshold (conditions needed) */
  candidateThreshold: number;

  /** Enable visual effects on candidate */
  enableVisualEffects: boolean;

  /** Enable audio effects on candidate */
  enableAudioEffects: boolean;

  /** History size */
  historySize: number;

  /** Prediction lookahead (ticks) */
  predictionLookahead: number;
}

export const DEFAULT_OMNIS_DETECTOR_CONFIG: OmnisDetectorConfig = {
  enableLocalDetection: true,
  candidateThreshold: 7,
  enableVisualEffects: true,
  enableAudioEffects: true,
  historySize: 100,
  predictionLookahead: 300, // 5 seconds at 60 FPS
};

// ============================================================================
// OMNIS VISUAL EFFECTS
// ============================================================================

export const OMNIS_VISUAL_EFFECTS = {
  CANDIDATE: {
    fogDensity: 0.3,
    fogColor: "#FFD700",
    bloomIntensity: 1.5,
    screenGrain: 0.1,
    colorShift: { r: 1.1, g: 1.05, b: 0.9 },
    pulseFrequency: 2.0,
  },
  CONFIRMED: {
    fogDensity: 0.1,
    fogColor: "#FFFFFF",
    bloomIntensity: 3.0,
    screenGrain: 0.3,
    colorShift: { r: 1.2, g: 1.2, b: 1.2 },
    pulseFrequency: 5.0,
    flashDuration: 500,
  },
  PATENTED: {
    fogDensity: 0.0,
    fogColor: "#00FF00",
    bloomIntensity: 2.0,
    screenGrain: 0.0,
    colorShift: { r: 1.0, g: 1.2, b: 1.0 },
    pulseFrequency: 1.0,
    celebrationDuration: 3000,
  },
} as const;

// ============================================================================
// EMERGENCE ENERGY ACCUMULATOR
// ============================================================================

export interface EmergenceAccumulator {
  /** Current energy level (0-1) */
  energy: number;

  /** Energy gain rate per tick when conditions favorable */
  gainRate: number;

  /** Energy decay rate per tick when conditions unfavorable */
  decayRate: number;

  /** Threshold for candidate triggering */
  candidateThreshold: number;

  /** Threshold for full emergence */
  fullThreshold: number;

  /** Energy history for trend analysis */
  history: number[];

  /** Trend direction (-1 = falling, 0 = stable, 1 = rising) */
  trend: number;

  /** Estimated ticks until threshold */
  estimatedTicksToThreshold: number;
}

export const DEFAULT_EMERGENCE_ACCUMULATOR: EmergenceAccumulator = {
  energy: 0,
  gainRate: 0.001,
  decayRate: 0.0005,
  candidateThreshold: 0.7,
  fullThreshold: 0.95,
  history: [],
  trend: 0,
  estimatedTicksToThreshold: Number.POSITIVE_INFINITY,
};

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Generate unique OMNIS event ID
 */
export function generateOmnisEventId(beat: number, tick: number): string {
  return `OMNIS-${beat}-${tick}-${Date.now().toString(36)}`;
}

/**
 * Calculate OMNIS progress from condition states
 */
export function calculateOmnisProgress(
  conditions: Record<OmnisCondition, OmnisConditionState>,
): number {
  let totalProgress = 0;
  for (let i = 0; i < OMNIS_CONDITION_COUNT; i++) {
    totalProgress += conditions[i as OmnisCondition].progress;
  }
  return totalProgress / OMNIS_CONDITION_COUNT;
}

/**
 * Check if enough conditions are met for candidate status
 */
export function checkCandidateStatus(
  conditions: Record<OmnisCondition, OmnisConditionState>,
): boolean {
  let metCount = 0;
  for (let i = 0; i < OMNIS_CONDITION_COUNT; i++) {
    if (conditions[i as OmnisCondition].met) {
      metCount++;
    }
  }
  return metCount >= OMNIS_THRESHOLDS.CANDIDATE_THRESHOLD;
}

/**
 * Check if all conditions are met for full OMNIS
 */
export function checkFullOmnis(
  conditions: Record<OmnisCondition, OmnisConditionState>,
): boolean {
  for (let i = 0; i < OMNIS_CONDITION_COUNT; i++) {
    if (!conditions[i as OmnisCondition].met) {
      return false;
    }
  }
  return true;
}
