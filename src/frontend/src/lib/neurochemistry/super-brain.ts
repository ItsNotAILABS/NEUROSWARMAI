/**
 * SUPER ORGANISM KURAMOTO BRAIN
 *
 * MEDINA'S ARCHITECTURE - FULL 64 NODE SYSTEM
 *
 * Shell 3: 64 nodes, 4,096 Hebbian weights
 * Kuramoto r computed every beat
 * Jasmine Law drift correction every beat
 *
 * FRACTAL ARCHITECTURE: Spherical, not linear.
 * Every node couples to every other node.
 * Phase synchronization creates coherence.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// SUPER BRAIN CONSTANTS
// 64 nodes for the super organism
// ============================================================================

export const SUPER_BRAIN_CONSTANTS = {
  /** Total brain nodes */
  NODE_COUNT: 64,

  /** Hebbian weight count (64 × 64) */
  HEBBIAN_WEIGHT_COUNT: 4096,

  /** Primary cortical nodes */
  PRIMARY_NODE_COUNT: 16,

  /** Secondary cortical nodes */
  SECONDARY_NODE_COUNT: 24,

  /** Subcortical nodes */
  SUBCORTICAL_NODE_COUNT: 16,

  /** Modulatory nodes */
  MODULATORY_NODE_COUNT: 8,

  /** Kuramoto coupling constant K */
  KURAMOTO_K: 0.5,

  /** Drift epsilon for violation detection */
  DRIFT_EPSILON: 0.05,

  /** Critical drift threshold */
  DRIFT_CRITICAL: 0.15,

  /** Catastrophic drift threshold */
  DRIFT_CATASTROPHIC: 0.3,

  /** Re-entrainment strength */
  REENTRAINMENT_STRENGTH: 0.3,

  /** Learning rate η */
  LEARNING_RATE: 0.005,

  /** Decay rate λ */
  DECAY_RATE: 0.001,

  /** Baseline weight (sovereign floor) */
  BASELINE_WEIGHT: 0.75,

  /** Maximum weight */
  MAX_WEIGHT: 1.0,

  /** Two Pi for phase calculations */
  // biome-ignore lint/correctness/noPrecisionLoss: architectural constant
  TWO_PI: 6.28318530717958647692,

  /** Pi */
  PI: Math.PI,

  /** Euler's number */
  E: Math.E,

  /** Golden ratio φ */
  PHI: 1.618033988749895,
} as const;

// ============================================================================
// BRAIN REGION ENUMERATION (64 NODES)
// ============================================================================

export const SUPER_BRAIN_REGIONS = {
  // PRIMARY CORTICAL (16 nodes) - Executive and Sensory
  PREFRONTAL_DORSOLATERAL: 0,
  PREFRONTAL_VENTROMEDIAL: 1,
  PREFRONTAL_ORBITOFRONTAL: 2,
  PREFRONTAL_ANTERIOR_CINGULATE: 3,
  PARIETAL_SUPERIOR: 4,
  PARIETAL_INFERIOR: 5,
  PARIETAL_PRECUNEUS: 6,
  PARIETAL_ANGULAR: 7,
  TEMPORAL_SUPERIOR: 8,
  TEMPORAL_MIDDLE: 9,
  TEMPORAL_INFERIOR: 10,
  TEMPORAL_MEDIAL: 11,
  OCCIPITAL_PRIMARY: 12,
  OCCIPITAL_SECONDARY: 13,
  OCCIPITAL_ASSOCIATIVE: 14,
  OCCIPITAL_VENTRAL: 15,

  // SECONDARY CORTICAL (24 nodes) - Association and Integration
  MOTOR_PRIMARY: 16,
  MOTOR_SUPPLEMENTARY: 17,
  MOTOR_PREMOTOR: 18,
  MOTOR_PRESUPPLEMENTARY: 19,
  SOMATOSENSORY_PRIMARY: 20,
  SOMATOSENSORY_SECONDARY: 21,
  SOMATOSENSORY_ASSOCIATION: 22,
  SOMATOSENSORY_POSTERIOR: 23,
  AUDITORY_PRIMARY: 24,
  AUDITORY_SECONDARY: 25,
  AUDITORY_ASSOCIATION: 26,
  AUDITORY_WERNICKE: 27,
  LANGUAGE_BROCA: 28,
  LANGUAGE_WERNICKE: 29,
  LANGUAGE_ARCUATE: 30,
  LANGUAGE_ANGULAR: 31,
  INSULA_ANTERIOR: 32,
  INSULA_POSTERIOR: 33,
  INSULA_DORSAL: 34,
  INSULA_VENTRAL: 35,
  CINGULATE_ANTERIOR: 36,
  CINGULATE_MIDDLE: 37,
  CINGULATE_POSTERIOR: 38,
  CINGULATE_SUBGENUAL: 39,

  // SUBCORTICAL (16 nodes) - Emotion, Memory, Reward
  HIPPOCAMPUS_CA1: 40,
  HIPPOCAMPUS_CA3: 41,
  HIPPOCAMPUS_DENTATE: 42,
  HIPPOCAMPUS_SUBICULUM: 43,
  AMYGDALA_BASOLATERAL: 44,
  AMYGDALA_CENTRAL: 45,
  AMYGDALA_MEDIAL: 46,
  AMYGDALA_CORTICAL: 47,
  THALAMUS_ANTERIOR: 48,
  THALAMUS_MEDIAL: 49,
  THALAMUS_LATERAL: 50,
  THALAMUS_PULVINAR: 51,
  BASAL_GANGLIA_STRIATUM: 52,
  BASAL_GANGLIA_PALLIDUM: 53,
  BASAL_GANGLIA_SUBSTANTIA: 54,
  BASAL_GANGLIA_SUBTHALAMIC: 55,

  // MODULATORY (8 nodes) - Neuromodulation
  BRAINSTEM_RAPHE: 56,
  BRAINSTEM_LC: 57,
  BRAINSTEM_VTA: 58,
  BRAINSTEM_PAG: 59,
  HYPOTHALAMUS_ANTERIOR: 60,
  HYPOTHALAMUS_POSTERIOR: 61,
  CEREBELLUM_VERMIS: 62,
  CEREBELLUM_HEMISPHERES: 63,
} as const;

export type SuperBrainRegion =
  (typeof SUPER_BRAIN_REGIONS)[keyof typeof SUPER_BRAIN_REGIONS];

// ============================================================================
// NATURAL FREQUENCIES (Hz) FOR EACH NODE
// Spread across Delta, Theta, Alpha, Beta, Gamma bands
// ============================================================================

export const SUPER_BRAIN_FREQUENCIES: Record<SuperBrainRegion, number> = {
  // PRIMARY CORTICAL - Beta/Gamma dominant
  [SUPER_BRAIN_REGIONS.PREFRONTAL_DORSOLATERAL]: 25.0,
  [SUPER_BRAIN_REGIONS.PREFRONTAL_VENTROMEDIAL]: 22.0,
  [SUPER_BRAIN_REGIONS.PREFRONTAL_ORBITOFRONTAL]: 20.0,
  [SUPER_BRAIN_REGIONS.PREFRONTAL_ANTERIOR_CINGULATE]: 18.0,
  [SUPER_BRAIN_REGIONS.PARIETAL_SUPERIOR]: 15.0,
  [SUPER_BRAIN_REGIONS.PARIETAL_INFERIOR]: 14.0,
  [SUPER_BRAIN_REGIONS.PARIETAL_PRECUNEUS]: 12.0,
  [SUPER_BRAIN_REGIONS.PARIETAL_ANGULAR]: 13.0,
  [SUPER_BRAIN_REGIONS.TEMPORAL_SUPERIOR]: 16.0,
  [SUPER_BRAIN_REGIONS.TEMPORAL_MIDDLE]: 14.0,
  [SUPER_BRAIN_REGIONS.TEMPORAL_INFERIOR]: 12.0,
  [SUPER_BRAIN_REGIONS.TEMPORAL_MEDIAL]: 8.0,
  [SUPER_BRAIN_REGIONS.OCCIPITAL_PRIMARY]: 10.0,
  [SUPER_BRAIN_REGIONS.OCCIPITAL_SECONDARY]: 11.0,
  [SUPER_BRAIN_REGIONS.OCCIPITAL_ASSOCIATIVE]: 12.0,
  [SUPER_BRAIN_REGIONS.OCCIPITAL_VENTRAL]: 11.5,

  // SECONDARY CORTICAL - Mixed frequencies
  [SUPER_BRAIN_REGIONS.MOTOR_PRIMARY]: 20.0,
  [SUPER_BRAIN_REGIONS.MOTOR_SUPPLEMENTARY]: 18.0,
  [SUPER_BRAIN_REGIONS.MOTOR_PREMOTOR]: 16.0,
  [SUPER_BRAIN_REGIONS.MOTOR_PRESUPPLEMENTARY]: 17.0,
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_PRIMARY]: 15.0,
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_SECONDARY]: 14.0,
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_ASSOCIATION]: 13.0,
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_POSTERIOR]: 12.0,
  [SUPER_BRAIN_REGIONS.AUDITORY_PRIMARY]: 40.0,
  [SUPER_BRAIN_REGIONS.AUDITORY_SECONDARY]: 35.0,
  [SUPER_BRAIN_REGIONS.AUDITORY_ASSOCIATION]: 30.0,
  [SUPER_BRAIN_REGIONS.AUDITORY_WERNICKE]: 25.0,
  [SUPER_BRAIN_REGIONS.LANGUAGE_BROCA]: 22.0,
  [SUPER_BRAIN_REGIONS.LANGUAGE_WERNICKE]: 20.0,
  [SUPER_BRAIN_REGIONS.LANGUAGE_ARCUATE]: 18.0,
  [SUPER_BRAIN_REGIONS.LANGUAGE_ANGULAR]: 16.0,
  [SUPER_BRAIN_REGIONS.INSULA_ANTERIOR]: 35.0,
  [SUPER_BRAIN_REGIONS.INSULA_POSTERIOR]: 30.0,
  [SUPER_BRAIN_REGIONS.INSULA_DORSAL]: 28.0,
  [SUPER_BRAIN_REGIONS.INSULA_VENTRAL]: 25.0,
  [SUPER_BRAIN_REGIONS.CINGULATE_ANTERIOR]: 15.0,
  [SUPER_BRAIN_REGIONS.CINGULATE_MIDDLE]: 12.0,
  [SUPER_BRAIN_REGIONS.CINGULATE_POSTERIOR]: 10.0,
  [SUPER_BRAIN_REGIONS.CINGULATE_SUBGENUAL]: 8.0,

  // SUBCORTICAL - Theta/Alpha dominant
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_CA1]: 6.0,
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_CA3]: 7.0,
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_DENTATE]: 8.0,
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_SUBICULUM]: 5.0,
  [SUPER_BRAIN_REGIONS.AMYGDALA_BASOLATERAL]: 40.0,
  [SUPER_BRAIN_REGIONS.AMYGDALA_CENTRAL]: 35.0,
  [SUPER_BRAIN_REGIONS.AMYGDALA_MEDIAL]: 30.0,
  [SUPER_BRAIN_REGIONS.AMYGDALA_CORTICAL]: 25.0,
  [SUPER_BRAIN_REGIONS.THALAMUS_ANTERIOR]: 10.0,
  [SUPER_BRAIN_REGIONS.THALAMUS_MEDIAL]: 9.0,
  [SUPER_BRAIN_REGIONS.THALAMUS_LATERAL]: 11.0,
  [SUPER_BRAIN_REGIONS.THALAMUS_PULVINAR]: 12.0,
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_STRIATUM]: 22.0,
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_PALLIDUM]: 18.0,
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_SUBSTANTIA]: 15.0,
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_SUBTHALAMIC]: 20.0,

  // MODULATORY - Delta/Theta dominant
  [SUPER_BRAIN_REGIONS.BRAINSTEM_RAPHE]: 2.0,
  [SUPER_BRAIN_REGIONS.BRAINSTEM_LC]: 3.0,
  [SUPER_BRAIN_REGIONS.BRAINSTEM_VTA]: 4.0,
  [SUPER_BRAIN_REGIONS.BRAINSTEM_PAG]: 2.5,
  [SUPER_BRAIN_REGIONS.HYPOTHALAMUS_ANTERIOR]: 3.0,
  [SUPER_BRAIN_REGIONS.HYPOTHALAMUS_POSTERIOR]: 3.5,
  [SUPER_BRAIN_REGIONS.CEREBELLUM_VERMIS]: 25.0,
  [SUPER_BRAIN_REGIONS.CEREBELLUM_HEMISPHERES]: 30.0,
};

// ============================================================================
// BRAIN REGION NAMES
// ============================================================================

export const SUPER_BRAIN_REGION_NAMES: Record<SuperBrainRegion, string> = {
  [SUPER_BRAIN_REGIONS.PREFRONTAL_DORSOLATERAL]: "Dorsolateral PFC",
  [SUPER_BRAIN_REGIONS.PREFRONTAL_VENTROMEDIAL]: "Ventromedial PFC",
  [SUPER_BRAIN_REGIONS.PREFRONTAL_ORBITOFRONTAL]: "Orbitofrontal Cortex",
  [SUPER_BRAIN_REGIONS.PREFRONTAL_ANTERIOR_CINGULATE]: "Anterior Cingulate",
  [SUPER_BRAIN_REGIONS.PARIETAL_SUPERIOR]: "Superior Parietal",
  [SUPER_BRAIN_REGIONS.PARIETAL_INFERIOR]: "Inferior Parietal",
  [SUPER_BRAIN_REGIONS.PARIETAL_PRECUNEUS]: "Precuneus",
  [SUPER_BRAIN_REGIONS.PARIETAL_ANGULAR]: "Angular Gyrus",
  [SUPER_BRAIN_REGIONS.TEMPORAL_SUPERIOR]: "Superior Temporal",
  [SUPER_BRAIN_REGIONS.TEMPORAL_MIDDLE]: "Middle Temporal",
  [SUPER_BRAIN_REGIONS.TEMPORAL_INFERIOR]: "Inferior Temporal",
  [SUPER_BRAIN_REGIONS.TEMPORAL_MEDIAL]: "Medial Temporal",
  [SUPER_BRAIN_REGIONS.OCCIPITAL_PRIMARY]: "Primary Visual",
  [SUPER_BRAIN_REGIONS.OCCIPITAL_SECONDARY]: "Secondary Visual",
  [SUPER_BRAIN_REGIONS.OCCIPITAL_ASSOCIATIVE]: "Visual Association",
  [SUPER_BRAIN_REGIONS.OCCIPITAL_VENTRAL]: "Ventral Visual",
  [SUPER_BRAIN_REGIONS.MOTOR_PRIMARY]: "Primary Motor",
  [SUPER_BRAIN_REGIONS.MOTOR_SUPPLEMENTARY]: "Supplementary Motor",
  [SUPER_BRAIN_REGIONS.MOTOR_PREMOTOR]: "Premotor Cortex",
  [SUPER_BRAIN_REGIONS.MOTOR_PRESUPPLEMENTARY]: "Pre-SMA",
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_PRIMARY]: "Primary Somatosensory",
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_SECONDARY]: "Secondary Somatosensory",
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_ASSOCIATION]: "Somatosensory Association",
  [SUPER_BRAIN_REGIONS.SOMATOSENSORY_POSTERIOR]: "Posterior Parietal",
  [SUPER_BRAIN_REGIONS.AUDITORY_PRIMARY]: "Primary Auditory",
  [SUPER_BRAIN_REGIONS.AUDITORY_SECONDARY]: "Secondary Auditory",
  [SUPER_BRAIN_REGIONS.AUDITORY_ASSOCIATION]: "Auditory Association",
  [SUPER_BRAIN_REGIONS.AUDITORY_WERNICKE]: "Wernicke's Area",
  [SUPER_BRAIN_REGIONS.LANGUAGE_BROCA]: "Broca's Area",
  [SUPER_BRAIN_REGIONS.LANGUAGE_WERNICKE]: "Wernicke's (Language)",
  [SUPER_BRAIN_REGIONS.LANGUAGE_ARCUATE]: "Arcuate Fasciculus",
  [SUPER_BRAIN_REGIONS.LANGUAGE_ANGULAR]: "Angular (Language)",
  [SUPER_BRAIN_REGIONS.INSULA_ANTERIOR]: "Anterior Insula",
  [SUPER_BRAIN_REGIONS.INSULA_POSTERIOR]: "Posterior Insula",
  [SUPER_BRAIN_REGIONS.INSULA_DORSAL]: "Dorsal Insula",
  [SUPER_BRAIN_REGIONS.INSULA_VENTRAL]: "Ventral Insula",
  [SUPER_BRAIN_REGIONS.CINGULATE_ANTERIOR]: "ACC",
  [SUPER_BRAIN_REGIONS.CINGULATE_MIDDLE]: "MCC",
  [SUPER_BRAIN_REGIONS.CINGULATE_POSTERIOR]: "PCC",
  [SUPER_BRAIN_REGIONS.CINGULATE_SUBGENUAL]: "Subgenual ACC",
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_CA1]: "Hippocampus CA1",
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_CA3]: "Hippocampus CA3",
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_DENTATE]: "Dentate Gyrus",
  [SUPER_BRAIN_REGIONS.HIPPOCAMPUS_SUBICULUM]: "Subiculum",
  [SUPER_BRAIN_REGIONS.AMYGDALA_BASOLATERAL]: "Basolateral Amygdala",
  [SUPER_BRAIN_REGIONS.AMYGDALA_CENTRAL]: "Central Amygdala",
  [SUPER_BRAIN_REGIONS.AMYGDALA_MEDIAL]: "Medial Amygdala",
  [SUPER_BRAIN_REGIONS.AMYGDALA_CORTICAL]: "Cortical Amygdala",
  [SUPER_BRAIN_REGIONS.THALAMUS_ANTERIOR]: "Anterior Thalamus",
  [SUPER_BRAIN_REGIONS.THALAMUS_MEDIAL]: "Medial Thalamus",
  [SUPER_BRAIN_REGIONS.THALAMUS_LATERAL]: "Lateral Thalamus",
  [SUPER_BRAIN_REGIONS.THALAMUS_PULVINAR]: "Pulvinar",
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_STRIATUM]: "Striatum",
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_PALLIDUM]: "Globus Pallidus",
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_SUBSTANTIA]: "Substantia Nigra",
  [SUPER_BRAIN_REGIONS.BASAL_GANGLIA_SUBTHALAMIC]: "Subthalamic Nucleus",
  [SUPER_BRAIN_REGIONS.BRAINSTEM_RAPHE]: "Raphe Nuclei",
  [SUPER_BRAIN_REGIONS.BRAINSTEM_LC]: "Locus Coeruleus",
  [SUPER_BRAIN_REGIONS.BRAINSTEM_VTA]: "VTA",
  [SUPER_BRAIN_REGIONS.BRAINSTEM_PAG]: "PAG",
  [SUPER_BRAIN_REGIONS.HYPOTHALAMUS_ANTERIOR]: "Anterior Hypothalamus",
  [SUPER_BRAIN_REGIONS.HYPOTHALAMUS_POSTERIOR]: "Posterior Hypothalamus",
  [SUPER_BRAIN_REGIONS.CEREBELLUM_VERMIS]: "Cerebellar Vermis",
  [SUPER_BRAIN_REGIONS.CEREBELLUM_HEMISPHERES]: "Cerebellar Hemispheres",
};

// ============================================================================
// KURAMOTO OSCILLATOR STATE
// ============================================================================

export interface KuramotoOscillator {
  nodeIndex: number;
  region: SuperBrainRegion;
  phase: number; // θ ∈ [0, 2π]
  naturalFrequency: number; // ω (Hz)
  instantFrequency: number; // Current frequency
  phaseVelocity: number; // dθ/dt
  couplingStrength: number; // K_i
  activation: number; // [0, 1]
  energy: number;
  isPrimary: boolean;
  isSubcortical: boolean;
  isModulatory: boolean;
}

// ============================================================================
// KURAMOTO COHERENCE (Order Parameter)
// r(t) = |1/N Σⱼ exp(i·θⱼ)|
// ============================================================================

export interface KuramotoCoherence {
  orderParameter: number; // r ∈ [0, 1]
  meanPhase: number; // ψ
  primaryCoherence: number; // Cortical r
  subcorticalCoherence: number; // Subcortical r
  modulatoryCoherence: number; // Modulatory r
  crossRegionCoherence: number; // Between-region coupling
  phaseDispersion: number; // Variance
  synchronizationIndex: number; // Normalized sync
  isSynchronized: boolean;
  heartbeat: number;
}

// ============================================================================
// GENESIS LOCK
// Immutable initial state - organism's identity
// ============================================================================

export interface SuperBrainGenesisLock {
  rGenesis: number; // Order parameter at genesis
  thetaGenesis: number[]; // Phase vector at genesis (64)
  meanPhaseGenesis: number;
  couplingMatrixSignature: number; // Hash of coupling matrix
  spectralRadiusGenesis: number;
  formationTimestamp: number;
  genesisHash: string;
  isLocked: boolean;
}

// ============================================================================
// HEBBIAN WEIGHT MATRIX (4,096 weights)
// ============================================================================

export interface HebbianWeightMatrix {
  weights: number[][]; // 64 × 64 = 4,096
  dimension: number;
  trace: number;
  spectralRadius: number;
  meanWeight: number;
  maxWeight: number;
  minWeight: number;
  lastUpdate: number;
}

// ============================================================================
// JASMINE LAW - Lyapunov Drift Correction
// V(x) = Σ (x_i - x_target)²
// When dV/dt > 0 (drift), fire correction
// ============================================================================

export interface JasmineLawState {
  lyapunovV: number; // Current V(x)
  previousV: number; // V(x) at t-1
  dVdt: number; // Rate of change
  isStable: boolean; // dV/dt < 0
  driftMagnitude: number;
  driftDirection: number[]; // Which nodes drifting
  correctionVector: number[]; // Correction to apply
  violationCount: number;
  lastCorrectionBeat: number;
}

// ============================================================================
// SUPER BRAIN STATE (Complete)
// ============================================================================

export interface SuperBrainState {
  oscillators: KuramotoOscillator[];
  coherence: KuramotoCoherence;
  hebbianWeights: HebbianWeightMatrix;
  genesisLock: SuperBrainGenesisLock;
  jasmineLaw: JasmineLawState;

  // Aggregate metrics
  globalActivation: number;
  globalEnergy: number;
  dominantFrequencyBand: "delta" | "theta" | "alpha" | "beta" | "gamma";

  // Timing
  currentBeat: number;
  lastUpdateTick: number;
  ticksPerBeat: number;
}

// ============================================================================
// FREQUENCY BANDS
// ============================================================================

export const FREQUENCY_BANDS = {
  DELTA: { min: 0.5, max: 4, name: "Delta", color: "#4B0082" },
  THETA: { min: 4, max: 8, name: "Theta", color: "#0000FF" },
  ALPHA: { min: 8, max: 13, name: "Alpha", color: "#00FF00" },
  BETA: { min: 13, max: 30, name: "Beta", color: "#FFFF00" },
  GAMMA: { min: 30, max: 100, name: "Gamma", color: "#FF0000" },
} as const;

// ============================================================================
// SUPER BRAIN METRICS
// ============================================================================

export const SUPER_BRAIN_METRICS = {
  NODE_COUNT: 64,
  HEBBIAN_WEIGHTS: 4096,
  PRIMARY_NODES: 16,
  SECONDARY_NODES: 24,
  SUBCORTICAL_NODES: 16,
  MODULATORY_NODES: 8,
  FREQUENCY_RANGE: { min: 0.5, max: 100 },
  KURAMOTO_PARAMETERS: 4, // K, ε, δ_critical, δ_catastrophic
  JASMINE_LAW_COMPONENTS: 5, // V, dV/dt, correction, violation, timestamp
} as const;
