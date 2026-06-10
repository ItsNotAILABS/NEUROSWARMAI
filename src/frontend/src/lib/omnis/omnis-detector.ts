/**
 * OMNIS EMERGENCE DETECTOR - SUPER ORGANISM VERSION
 *
 * OMNIS: The 9-Condition Emergence Event
 *
 * When all 9 conditions align:
 * - An irreversible on-chain event fires
 * - Patent auto-logs: "OMNIS #N — Beat #X — 9/9 CONDITIONS"
 * - 500-beat cooldown enforced
 * - Lineage registered in NOVA
 *
 * MEDINA'S MIRROR LAW:
 * Backend: Permanent emergence - once it fires, it is history
 * Frontend: Emergent expression - player FEELS it before backend confirms
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// THE 9 OMNIS CONDITIONS
// ============================================================================

export const OMNIS_CONDITIONS = {
  /** Condition 1: Global coherence above threshold */
  COHERENCE_THRESHOLD: {
    id: 1,
    name: "Coherence Threshold",
    equation: "r ≥ 0.75",
    description: "Global Kuramoto order parameter must exceed 0.75",
    weight: 1.0,
  },

  /** Condition 2: Chemical synchrony */
  CHEMICAL_SYNCHRONY: {
    id: 2,
    name: "Chemical Synchrony",
    equation: "σ²(chemicals) < 0.1",
    description: "Neurochemical variance must be low (balance)",
    weight: 1.0,
  },

  /** Condition 3: Territory stability */
  TERRITORY_STABILITY: {
    id: 3,
    name: "Territory Stability",
    equation: "Δterritory < 0.05",
    description: "Territory changes must be minimal",
    weight: 1.0,
  },

  /** Condition 4: Population threshold */
  POPULATION_THRESHOLD: {
    id: 4,
    name: "Population Threshold",
    equation: "population ≥ 50",
    description: "Active entity count must be sufficient",
    weight: 1.0,
  },

  /** Condition 5: Learning rate above baseline */
  LEARNING_ACTIVE: {
    id: 5,
    name: "Learning Active",
    equation: "Δw_avg > 0.001",
    description: "Hebbian learning must be actively occurring",
    weight: 1.0,
  },

  /** Condition 6: Prediction accuracy */
  PREDICTION_ACCURACY: {
    id: 6,
    name: "Prediction Accuracy",
    equation: "|δ_avg| < 0.2",
    description: "Average prediction error must be low",
    weight: 1.0,
  },

  /** Condition 7: Multi-faction activity */
  MULTI_FACTION: {
    id: 7,
    name: "Multi-Faction Activity",
    equation: "active_factions ≥ 3",
    description: "At least 3 factions must be active",
    weight: 1.0,
  },

  /** Condition 8: Arousal in optimal range */
  AROUSAL_OPTIMAL: {
    id: 8,
    name: "Arousal Optimal",
    equation: "arousal ∈ [0.4, 0.7]",
    description: "Arousal must be in Yerkes-Dodson optimal range",
    weight: 1.0,
  },

  /** Condition 9: Pattern novelty detected */
  PATTERN_NOVELTY: {
    id: 9,
    name: "Pattern Novelty",
    equation: "novel_patterns > 0",
    description: "At least one novel pattern discovered this cycle",
    weight: 1.0,
  },
} as const;

export type OmnisConditionId = keyof typeof OMNIS_CONDITIONS;
export const OMNIS_CONDITION_COUNT = 9;

// ============================================================================
// OMNIS THRESHOLDS
// ============================================================================

export const OMNIS_THRESHOLDS = {
  /** Minimum coherence for Condition 1 */
  COHERENCE_MIN: 0.75,

  /** Maximum chemical variance for Condition 2 */
  CHEMICAL_VARIANCE_MAX: 0.1,

  /** Maximum territory change for Condition 3 */
  TERRITORY_CHANGE_MAX: 0.05,

  /** Minimum population for Condition 4 */
  POPULATION_MIN: 50,

  /** Minimum learning rate for Condition 5 */
  LEARNING_RATE_MIN: 0.001,

  /** Maximum prediction error for Condition 6 */
  PREDICTION_ERROR_MAX: 0.2,

  /** Minimum active factions for Condition 7 */
  ACTIVE_FACTIONS_MIN: 3,

  /** Arousal range for Condition 8 */
  AROUSAL_MIN: 0.4,
  AROUSAL_MAX: 0.7,

  /** Minimum novel patterns for Condition 9 */
  NOVEL_PATTERNS_MIN: 1,

  /** OMNIS fires when this many conditions met */
  CONDITIONS_REQUIRED: 9,

  /** Cooldown between OMNIS events (beats) */
  COOLDOWN_BEATS: 500,

  /** Check interval (beats) */
  CHECK_INTERVAL: 50,

  /** Frontend prediction threshold (7 conditions = candidate) */
  FRONTEND_CANDIDATE_THRESHOLD: 7,
} as const;

// ============================================================================
// OMNIS STATE
// ============================================================================

export interface OmnisConditionState {
  id: number;
  name: string;
  met: boolean;
  currentValue: number;
  threshold: number;
  progress: number; // 0-1
}

export interface OmnisState {
  /** Current condition states */
  conditions: Record<OmnisConditionId, OmnisConditionState>;

  /** Number of conditions currently met */
  conditionsMet: number;

  /** Is OMNIS currently firing? */
  isFiring: boolean;

  /** Is OMNIS in cooldown? */
  inCooldown: boolean;

  /** Cooldown remaining (beats) */
  cooldownRemaining: number;

  /** Last OMNIS beat */
  lastOmnisBeat: number;

  /** Total OMNIS events */
  totalOmnisEvents: number;

  /** Beat of last check */
  lastCheckBeat: number;

  /** Next check beat */
  nextCheckBeat: number;

  /** Frontend OMNIS candidate active? */
  candidateActive: boolean;

  /** Candidate started at tick */
  candidateStartTick: number;

  /** OMNIS history */
  history: OmnisEvent[];
}

export interface OmnisEvent {
  id: string;
  number: number; // OMNIS #N
  beat: number;
  tick: number;
  timestamp: number;

  /** Condition values at time of firing */
  conditionValues: Record<OmnisConditionId, number>;

  /** Patent ID (on-chain) */
  patentId: string | null;

  /** Was this confirmed by backend? */
  backendConfirmed: boolean;

  /** FORMA multiplier applied */
  multiplierApplied: boolean;

  /** Description */
  description: string;
}

// ============================================================================
// OMNIS VISUAL EFFECTS
// ============================================================================

export const OMNIS_VISUAL_EFFECTS = {
  /** Pre-OMNIS buildup */
  BUILDUP: {
    duration: 3000,
    screenPulse: true,
    pulseFrequency: 2.0,
    vignetteIntensity: 0.4,
    saturationBoost: 1.3,
    soundCue: "omnis_buildup",
  },

  /** OMNIS moment */
  FIRE: {
    duration: 2000,
    screenFlash: { r: 1.0, g: 0.9, b: 0.5 },
    flashDuration: 500,
    screenShake: 0.1,
    slowMotion: 0.2,
    slowMotionDuration: 1500,
    particleBurst: true,
    particleCount: 1000,
    particleColor: "#FFD700",
    soundCue: "omnis_fire",
  },

  /** Post-OMNIS glow */
  AFTERGLOW: {
    duration: 5000,
    worldTint: { r: 1.1, g: 1.05, b: 0.95 },
    coherenceGlow: true,
    entityHighlight: true,
    soundCue: "omnis_afterglow",
  },
} as const;

// ============================================================================
// OMNIS CANDIDATE DETECTION (FRONTEND)
// ============================================================================

export interface OmnisCandidateState {
  /** Is candidate detection active? */
  active: boolean;

  /** Conditions met count */
  conditionsMet: number;

  /** Condition values */
  conditionValues: Record<OmnisConditionId, number>;

  /** Prediction error spike detected? */
  predictionErrorSpike: boolean;

  /** Local surprise level (0-1) */
  surpriseLevel: number;

  /** Time in candidate state (ticks) */
  ticksInState: number;

  /** Has been reported to backend? */
  reportedToBackend: boolean;

  /** Eligibility progress (0-1) */
  eligibilityProgress: number;
}

// ============================================================================
// OMNIS FORMULAS
// ============================================================================

/**
 * Calculate eligibility progress for OMNIS
 */
export function calculateEligibilityProgress(
  conditions: Record<OmnisConditionId, OmnisConditionState>,
): number {
  let totalProgress = 0;
  let totalWeight = 0;

  for (const key in conditions) {
    const condition = conditions[key as OmnisConditionId];
    const conditionDef = OMNIS_CONDITIONS[key as OmnisConditionId];
    totalProgress += condition.progress * conditionDef.weight;
    totalWeight += conditionDef.weight;
  }

  return totalWeight > 0 ? totalProgress / totalWeight : 0;
}

/**
 * Check if all OMNIS conditions are met
 */
export function areAllConditionsMet(
  conditions: Record<OmnisConditionId, OmnisConditionState>,
): boolean {
  for (const key in conditions) {
    if (!conditions[key as OmnisConditionId].met) {
      return false;
    }
  }
  return true;
}

/**
 * Count met conditions
 */
export function countMetConditions(
  conditions: Record<OmnisConditionId, OmnisConditionState>,
): number {
  let count = 0;
  for (const key in conditions) {
    if (conditions[key as OmnisConditionId].met) {
      count++;
    }
  }
  return count;
}

/**
 * Check if candidate threshold met (7+ conditions)
 */
export function isCandidateThresholdMet(
  conditions: Record<OmnisConditionId, OmnisConditionState>,
): boolean {
  return (
    countMetConditions(conditions) >=
    OMNIS_THRESHOLDS.FRONTEND_CANDIDATE_THRESHOLD
  );
}

/**
 * Calculate surprise level from prediction error
 */
export function calculateSurpriseLevel(
  predictionErrors: number[],
  threshold = 0.3,
): number {
  if (predictionErrors.length === 0) return 0;

  const recentErrors = predictionErrors.slice(-10);
  const avgError =
    recentErrors.reduce((a, b) => a + Math.abs(b), 0) / recentErrors.length;

  return Math.min(1, avgError / threshold);
}

// ============================================================================
// OMNIS CONFIGURATION
// ============================================================================

export interface OmnisConfig {
  /** Enable OMNIS detection */
  enabled: boolean;

  /** Enable visual effects */
  enableVisualEffects: boolean;

  /** Enable audio effects */
  enableAudioEffects: boolean;

  /** Enable frontend candidate detection */
  enableCandidateDetection: boolean;

  /** Candidate detection threshold */
  candidateThreshold: number;

  /** Check interval (beats) */
  checkInterval: number;

  /** Cooldown (beats) */
  cooldown: number;

  /** History size */
  historySize: number;
}

export const DEFAULT_OMNIS_CONFIG: OmnisConfig = {
  enabled: true,
  enableVisualEffects: true,
  enableAudioEffects: true,
  enableCandidateDetection: true,
  candidateThreshold: OMNIS_THRESHOLDS.FRONTEND_CANDIDATE_THRESHOLD,
  checkInterval: OMNIS_THRESHOLDS.CHECK_INTERVAL,
  cooldown: OMNIS_THRESHOLDS.COOLDOWN_BEATS,
  historySize: 100,
};

// ============================================================================
// OMNIS METRICS
// ============================================================================

export const OMNIS_METRICS = {
  CONDITION_COUNT: 9,
  COOLDOWN_BEATS: 500,
  CHECK_INTERVAL: 50,
  CANDIDATE_THRESHOLD: 7,
  MULTIPLIER: 2.75,
  VISUAL_EFFECTS: 3,
  STATE_FIELDS: 13,
  EVENT_FIELDS: 10,
} as const;
