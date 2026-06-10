// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SUBSTRATE CONSTANTS — MATCHING BACKEND GENESIS ARCHITECTURE                                              ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
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

// ═══════════════════════════════════════════════════════════════════════════════
// SUPER-SCALE DIMENSIONS (Matching backend super-organism-architecture.mo)
// ═══════════════════════════════════════════════════════════════════════════════

export const SUPER_NODE_COUNT = 512;
export const SUPER_WEIGHT_COUNT = 262144; // 512 × 512
export const SHELL_3_NODE_COUNT = 256;
export const SHELL_3_WEIGHT_COUNT = 65536; // 256 × 256
export const SHELL_12_NODE_COUNT = 512;
export const SHELL_12_WEIGHT_COUNT = 262144;
export const TOTAL_SHELLS = 12;

// ═══════════════════════════════════════════════════════════════════════════════
// COLONY ARCHITECTURE CONSTANTS (Matching backend colony-coordinator.mo)
// ═══════════════════════════════════════════════════════════════════════════════

export const ATLAS_GRID_SIZE = 4096; // 4,096 stigmergic cells
export const HZ_NODE_COUNT = 12; // 12 Hz nodes per organism
export const CASTE_COUNT = 9; // 9 animal castes

// ═══════════════════════════════════════════════════════════════════════════════
// QUORUM THRESHOLDS
// ═══════════════════════════════════════════════════════════════════════════════

export const QUORUM_EXPLORATION = 0.3; // r_colony < 0.3 → exploration mode
export const QUORUM_NEGOTIATION = 0.7; // 0.3 ≤ r_colony < 0.7 → negotiation mode
export const QUORUM_COMMITMENT = 0.7; // r_colony ≥ 0.7 → commitment mode
export const QUORUM_BRITTLE = 0.95; // r_colony > 0.95 → Pride Before Fall Law fires

// ═══════════════════════════════════════════════════════════════════════════════
// PHEROMONE DYNAMICS
// ═══════════════════════════════════════════════════════════════════════════════

export const PHEROMONE_EVAPORATION = 0.02; // ρ = evaporation constant (Talent Decay Law)
export const PHEROMONE_DEPOSIT_BASE = 100.0; // Q = base deposit constant
export const FORMA_AMPLIFICATION = 0.5; // FORMA amplifies pheromone deposit

// ═══════════════════════════════════════════════════════════════════════════════
// ACO OPTIMIZATION CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const ACO_ALPHA = 1.0; // Pheromone importance
export const ACO_BETA = 2.0; // Heuristic importance
export const ACO_RHO = 0.1; // Pheromone decay rate

// ═══════════════════════════════════════════════════════════════════════════════
// FREQUENCY BANDS FOR ATLAS GRID PARTITIONING
// ═══════════════════════════════════════════════════════════════════════════════

export const DELTA_BAND_END = 341; // Positions 0-341: slow, deep structural memory
export const THETA_BAND_END = 682; // Positions 342-682
export const ALPHA_BAND_END = 1023; // Positions 683-1023
export const BETA_BAND_END = 2047; // Positions 1024-2047
export const GAMMA_BAND_START = 3755; // Positions 3755-4095: fast tactical signals

// ═══════════════════════════════════════════════════════════════════════════════
// HEBBIAN CONSTANTS FOR SUPER-SCALE
// ═══════════════════════════════════════════════════════════════════════════════

export const SUPER_ETA = 0.001; // Lower learning rate for stability
export const SUPER_DECAY = 0.0001; // Slower decay
export const SUPER_LTP_THRESHOLD = 0.6;
export const SUPER_LTD_THRESHOLD = 0.4;

// ═══════════════════════════════════════════════════════════════════════════════
// PHASE COUPLING CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const KURAMOTO_K_SUPER = 0.05; // Global coupling (weaker for stability)
export const PAC_MODULATION_DEPTH = 0.4; // Phase-amplitude coupling depth

// ═══════════════════════════════════════════════════════════════════════════════
// WORKFLOW LIMITS
// ═══════════════════════════════════════════════════════════════════════════════

export const MAX_TASKS = 10000;
export const MAX_WORKFLOWS = 1000;
export const MAX_STEPS_PER_WORKFLOW = 100;
export const MAX_RETRIES = 3;

// ═══════════════════════════════════════════════════════════════════════════════
// REWARD PARAMETERS
// ═══════════════════════════════════════════════════════════════════════════════

export const BASE_COMPLETION_REWARD = 1.0;
export const QUALITY_MULTIPLIER = 2.0;
export const SPEED_BONUS_FACTOR = 0.5;
export const FAILURE_PENALTY = -0.2;

// ═══════════════════════════════════════════════════════════════════════════════
// QUANTUM CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const QUANTUM_COHERENCE_THRESHOLD = 0.7;
export const QUANTUM_DECOHERENCE_RATE = 0.01;
export const QUANTUM_ENTANGLEMENT_STRENGTH = 0.85;
export const QUANTUM_SUPERPOSITION_LEVELS = 8;
export const QUANTUM_MEASUREMENT_PRECISION = 0.001;

// ═══════════════════════════════════════════════════════════════════════════════
// GOVERNANCE CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const MIN_PROPOSAL_STAKE = 100;
export const VOTING_PERIOD_BEATS = 1000;
export const QUORUM_PERCENTAGE = 0.33;
export const SUPERMAJORITY_THRESHOLD = 0.67;
export const PROPOSAL_EXECUTION_DELAY = 100;

// ═══════════════════════════════════════════════════════════════════════════════
// FORMA TOKEN CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const FORMA_DECIMALS = 8;
export const FORMA_INITIAL_SUPPLY = 1_000_000_000;
export const FORMA_INFLATION_RATE = 0.02;
export const FORMA_BURN_RATE = 0.001;
export const FORMA_STAKING_APY = 0.05;

// ═══════════════════════════════════════════════════════════════════════════════
// SPECIALIZED ORGANISM CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANISM_SPECIALIZATIONS = [
  "Communication",
  "Legal",
  "Compliance",
  "SoftwareEngineering",
  "DevOps",
  "Finance",
  "Marketing",
  "Brand",
  "Healthcare",
  "Architecture",
  "DataAnalysis",
  "Operations",
  "Sales",
  "Media",
  "Cybersecurity",
  "HumanResources",
  "Campaign",
  "Documentation",
  "Strategy",
  "Orchestration",
] as const;

export type OrganismSpecialization = (typeof ORGANISM_SPECIALIZATIONS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// CASTE TYPES (9 Animal Engines)
// ═══════════════════════════════════════════════════════════════════════════════

export const CASTES = [
  "Crow", // Tool use, problem solving
  "Dolphin", // Social bonding, knowledge sharing
  "Hive", // Colony coordination (default worker)
  "Elephant", // Memory consolidation, construction
  "Shark", // Predatory counterstrike
  "Wolf", // Pack defense
  "Orca", // Strategic hunting
  "Eagle", // High-altitude reconnaissance
  "Octopus", // Adaptability, camouflage
] as const;

export type Caste = (typeof CASTES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// COLONY MODES
// ═══════════════════════════════════════════════════════════════════════════════

export const COLONY_MODES = [
  "Exploration", // r_colony < 0.3 — independent counterfactual branches
  "Negotiation", // 0.3 ≤ r_colony < 0.7 — consensus building
  "Commitment", // r_colony ≥ 0.7 — coordinated action
] as const;

export type ColonyMode = (typeof COLONY_MODES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// SIGNAL TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const SIGNAL_TYPES = [
  "Discovery", // FORAGER organisms — external data
  "Threat", // SOLDIER organisms — perimeter defense
  "Repair", // NURSE organisms — drifted organism recovery
  "Construction", // BUILDER organisms — long-horizon planning
  "Neutral", // No active signal
] as const;

export type SignalType = (typeof SIGNAL_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TASK TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_TYPES = [
  "Information", // Information gathering
  "Processing", // Data processing
  "Communication", // Sending/receiving messages
  "Analysis", // Analysis and reasoning
  "Decision", // Decision making
  "Action", // Taking action
  "Verification", // Verifying results
  "Reporting", // Generating reports
  "Learning", // Learning new information
  "Maintenance", // System maintenance
] as const;

export type TaskType = (typeof TASK_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TASK PRIORITIES
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_PRIORITIES = [
  "Critical", // Must complete immediately
  "High", // Complete as soon as possible
  "Normal", // Standard priority
  "Low", // Can wait
  "Background", // Process when idle
] as const;

export type TaskPriority = (typeof TASK_PRIORITIES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TASK STATUSES
// ═══════════════════════════════════════════════════════════════════════════════

export const TASK_STATUSES = [
  "Pending", // Waiting to start
  "Ready", // Ready to execute
  "Running", // Currently executing
  "Paused", // Temporarily paused
  "Completed", // Successfully completed
  "Failed", // Failed to complete
  "Cancelled", // Cancelled by user
  "Blocked", // Blocked by dependency
  "Retrying", // Retrying after failure
] as const;

export type TaskStatus = (typeof TASK_STATUSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// WORKFLOW TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const WORKFLOW_TYPES = [
  "Sequential", // Steps execute in order
  "Parallel", // Steps can execute concurrently
  "Conditional", // Steps depend on conditions
  "Iterative", // Steps repeat until condition
  "EventDriven", // Steps triggered by events
  "Hybrid", // Combination of above
] as const;

export type WorkflowType = (typeof WORKFLOW_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// DRIVE MODES
// ═══════════════════════════════════════════════════════════════════════════════

export const DRIVE_MODES = [
  "Exploration",
  "Execution",
  "Rest",
  "Learning",
] as const;

export type DriveMode = (typeof DRIVE_MODES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// HZ NODE NAMES (12-node binary hierarchy)
// ═══════════════════════════════════════════════════════════════════════════════

export const HZ_NODE_NAMES = [
  "BREATH", // k=1: Autonomic breathing rhythm
  "HEART", // k=2: Cardiac oscillation
  "VISCERA", // k=3: Gut-brain axis
  "SOMA", // k=4: Bodily awareness
  "AFFECT", // k=5: Emotional valence
  "ATTENTION", // k=6: Selective focus
  "COGNITION", // k=7: Reasoning processes
  "BINDING", // k=8: Feature binding
  "INTEGRATION", // k=9: Cross-modal integration
  "EXECUTIVE", // k=10: Executive control
  "META", // k=11: Metacognition
  "SOVEREIGN", // k=12: Sovereign identity
] as const;

export type HzNodeName = (typeof HZ_NODE_NAMES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// NEUROCHEMICALS (21 chemicals with receptor saturation dynamics)
// ═══════════════════════════════════════════════════════════════════════════════

export const NEUROCHEMICALS = [
  "Dopamine",
  "Serotonin",
  "Norepinephrine",
  "Acetylcholine",
  "GABA",
  "Glutamate",
  "Endorphin",
  "Oxytocin",
  "Cortisol",
  "Melatonin",
  "Histamine",
  "Anandamide",
  "Substance_P",
  "Adenosine",
  "Nitric_Oxide",
  "Vasopressin",
  "Orexin",
  "Neuropeptide_Y",
  "Cholecystokinin",
  "Dynorphin",
  "Enkephalin",
] as const;

export type Neurochemical = (typeof NEUROCHEMICALS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANS (18 organs with homeostatic delta equations)
// ═══════════════════════════════════════════════════════════════════════════════

export const ORGANS = [
  "CORTEX",
  "HIPPOCAMPUS",
  "AMYGDALA",
  "THALAMUS",
  "CEREBELLUM",
  "BRAINSTEM",
  "BASAL_GANGLIA",
  "HYPOTHALAMUS",
  "PITUITARY",
  "PINEAL",
  "INSULA",
  "CINGULATE",
  "PREFRONTAL",
  "PARIETAL",
  "TEMPORAL",
  "OCCIPITAL",
  "STRIATUM",
  "NUCLEUS_ACCUMBENS",
] as const;

export type Organ = (typeof ORGANS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// METALS (12 metals with sovereign alloy conductivity)
// ═══════════════════════════════════════════════════════════════════════════════

export const METALS = [
  "Gold",
  "Silver",
  "Copper",
  "Iron",
  "Zinc",
  "Magnesium",
  "Calcium",
  "Potassium",
  "Sodium",
  "Manganese",
  "Selenium",
  "Chromium",
] as const;

export type Metal = (typeof METALS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// COLOR SCHEMES
// ═══════════════════════════════════════════════════════════════════════════════

export const CASTE_COLORS: Record<Caste, string> = {
  Crow: "#6B7280",
  Dolphin: "#3B82F6",
  Hive: "#F59E0B",
  Elephant: "#8B5CF6",
  Shark: "#EF4444",
  Wolf: "#6366F1",
  Orca: "#0EA5E9",
  Eagle: "#D97706",
  Octopus: "#EC4899",
};

export const SIGNAL_COLORS: Record<SignalType, string> = {
  Discovery: "#10B981",
  Threat: "#EF4444",
  Repair: "#F59E0B",
  Construction: "#3B82F6",
  Neutral: "#6B7280",
};

export const COLONY_MODE_COLORS: Record<ColonyMode, string> = {
  Exploration: "#10B981",
  Negotiation: "#F59E0B",
  Commitment: "#3B82F6",
};

export const TASK_STATUS_COLORS: Record<TaskStatus, string> = {
  Pending: "#6B7280",
  Ready: "#10B981",
  Running: "#3B82F6",
  Paused: "#F59E0B",
  Completed: "#10B981",
  Failed: "#EF4444",
  Cancelled: "#6B7280",
  Blocked: "#EF4444",
  Retrying: "#F59E0B",
};

export const PRIORITY_COLORS: Record<TaskPriority, string> = {
  Critical: "#EF4444",
  High: "#F59E0B",
  Normal: "#3B82F6",
  Low: "#10B981",
  Background: "#6B7280",
};

// ═══════════════════════════════════════════════════════════════════════════════
// FREQUENCY CALCULATION
// fd(k) = 2.5 × 2^(k-4) for k = 1..12
// ═══════════════════════════════════════════════════════════════════════════════

export function calculateHzFrequency(k: number): number {
  return 2.5 * 2 ** (k - 4);
}

export const HZ_FREQUENCIES = Array.from({ length: 12 }, (_, i) =>
  calculateHzFrequency(i + 1),
);

// ═══════════════════════════════════════════════════════════════════════════════
// SUPER NODE FREQUENCY CALCULATION
// ═══════════════════════════════════════════════════════════════════════════════

export function computeSuperFrequency(
  nodeIdx: number,
  shellId: number,
): number {
  const normalized = nodeIdx / SUPER_NODE_COUNT;
  const shellFactor = shellId / 12.0;
  return 0.5 * 200.0 ** (normalized * (0.5 + shellFactor * 0.5));
}

// ═══════════════════════════════════════════════════════════════════════════════
// ATLAS POSITION TO FREQUENCY BAND
// ═══════════════════════════════════════════════════════════════════════════════

export function getFrequencyBand(position: number): string {
  if (position <= DELTA_BAND_END) return "Delta";
  if (position <= THETA_BAND_END) return "Theta";
  if (position <= ALPHA_BAND_END) return "Alpha";
  if (position <= BETA_BAND_END) return "Beta";
  if (position >= GAMMA_BAND_START) return "Gamma";
  return "High-Beta";
}

// ═══════════════════════════════════════════════════════════════════════════════
// KURAMOTO ORDER PARAMETER
// r(t) · e^(iΨ) = (1/N) Σₙ e^(iθₙ)
// ═══════════════════════════════════════════════════════════════════════════════

export function calculateKuramotoOrderParameter(phases: number[]): {
  r: number;
  psi: number;
} {
  const N = phases.length;
  if (N === 0) return { r: 0, psi: 0 };

  let sumCos = 0;
  let sumSin = 0;

  for (const theta of phases) {
    sumCos += Math.cos(theta);
    sumSin += Math.sin(theta);
  }

  const r = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / N;
  const psi = Math.atan2(sumSin, sumCos);

  return { r, psi };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COLONY COHERENCE (Double mean across nodes and organisms)
// r_colony(t) · e^(iΨ) = (1/N) Σₙ (1/12) Σₖ e^(iθₖ(n,t))
// ═══════════════════════════════════════════════════════════════════════════════

export function calculateColonyCoherence(
  organismPhases: number[][], // Array of organism phase arrays
): { rColony: number; psiGlobal: number } {
  const N = organismPhases.length;
  if (N === 0) return { rColony: 0, psiGlobal: 0 };

  let sumCos = 0;
  let sumSin = 0;

  for (const phases of organismPhases) {
    const { r, psi } = calculateKuramotoOrderParameter(phases);
    sumCos += r * Math.cos(psi);
    sumSin += r * Math.sin(psi);
  }

  const rColony = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / N;
  const psiGlobal = Math.atan2(sumSin, sumCos);

  return { rColony, psiGlobal };
}

// ═══════════════════════════════════════════════════════════════════════════════
// DETERMINE COLONY MODE FROM COHERENCE
// ═══════════════════════════════════════════════════════════════════════════════

export function determineColonyMode(rColony: number): ColonyMode {
  if (rColony < QUORUM_EXPLORATION) return "Exploration";
  if (rColony < QUORUM_COMMITMENT) return "Negotiation";
  return "Commitment";
}

// ═══════════════════════════════════════════════════════════════════════════════
// HEBBIAN LEARNING RULE
// Δw[i,j] = η × x[i] × x[j] - λ × w[i,j]
// ═══════════════════════════════════════════════════════════════════════════════

export function hebbianUpdate(
  weight: number,
  preActivation: number,
  postActivation: number,
  eta: number = SUPER_ETA,
  decay: number = SUPER_DECAY,
): { newWeight: number; isLTP: boolean; isLTD: boolean } {
  const correlation = preActivation * postActivation;
  const deltaWeight = eta * correlation - decay * weight;
  const newWeight = weight + deltaWeight;

  return {
    newWeight: Math.max(-1, Math.min(1, newWeight)),
    isLTP: correlation > SUPER_LTP_THRESHOLD,
    isLTD: correlation < SUPER_LTD_THRESHOLD,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHEROMONE UPDATE
// τ[i,j](t+1) = (1 - ρ) × τ[i,j](t) + Δτ[i,j]
// ═══════════════════════════════════════════════════════════════════════════════

export function updatePheromone(
  currentLevel: number,
  deposit: number,
  evaporationRate: number = PHEROMONE_EVAPORATION,
): number {
  return (1 - evaporationRate) * currentLevel + deposit;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ACO TRANSITION PROBABILITY
// p[i,j] = (τ[i,j]^α × η[i,j]^β) / Σ(τ[i,k]^α × η[i,k]^β)
// ═══════════════════════════════════════════════════════════════════════════════

export function calculateTransitionProbability(
  pheromone: number,
  heuristic: number,
  sumPheromoneHeuristic: number,
  alpha: number = ACO_ALPHA,
  beta: number = ACO_BETA,
): number {
  if (sumPheromoneHeuristic === 0) return 0;
  const numerator = pheromone ** alpha * heuristic ** beta;
  return numerator / sumPheromoneHeuristic;
}

// ═══════════════════════════════════════════════════════════════════════════════
// FREE ENERGY CALCULATION
// F = E - TS (simplified for digital systems)
// ═══════════════════════════════════════════════════════════════════════════════

export function calculateFreeEnergy(
  energy: number,
  entropy: number,
  temperature = 1.0,
): number {
  return energy - temperature * entropy;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SIGMOID ACTIVATION
// ═══════════════════════════════════════════════════════════════════════════════

export function sigmoid(x: number): number {
  return 1 / (1 + Math.exp(-x));
}

// ═══════════════════════════════════════════════════════════════════════════════
// TANH ACTIVATION
// ═══════════════════════════════════════════════════════════════════════════════

export function tanh(x: number): number {
  return Math.tanh(x);
}

// ═══════════════════════════════════════════════════════════════════════════════
// RELU ACTIVATION
// ═══════════════════════════════════════════════════════════════════════════════

export function relu(x: number): number {
  return Math.max(0, x);
}

// ═══════════════════════════════════════════════════════════════════════════════
// SOFTMAX
// ═══════════════════════════════════════════════════════════════════════════════

export function softmax(values: number[]): number[] {
  const maxVal = Math.max(...values);
  const expValues = values.map((v) => Math.exp(v - maxVal));
  const sumExp = expValues.reduce((a, b) => a + b, 0);
  return expValues.map((v) => v / sumExp);
}

// ═══════════════════════════════════════════════════════════════════════════════
// NORMALIZE TO RANGE
// ═══════════════════════════════════════════════════════════════════════════════

export function normalizeToRange(
  value: number,
  min: number,
  max: number,
  newMin = 0,
  newMax = 1,
): number {
  if (max === min) return newMin;
  return ((value - min) / (max - min)) * (newMax - newMin) + newMin;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CLAMP
// ═══════════════════════════════════════════════════════════════════════════════

export function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

// ═══════════════════════════════════════════════════════════════════════════════
// LERP (Linear Interpolation)
// ═══════════════════════════════════════════════════════════════════════════════

export function lerp(a: number, b: number, t: number): number {
  return a + (b - a) * t;
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPONENTIAL MOVING AVERAGE
// ═══════════════════════════════════════════════════════════════════════════════

export function ema(current: number, previous: number, alpha: number): number {
  return alpha * current + (1 - alpha) * previous;
}

// ═══════════════════════════════════════════════════════════════════════════════
// GAUSSIAN
// ═══════════════════════════════════════════════════════════════════════════════

export function gaussian(x: number, mean: number, stdDev: number): number {
  const coefficient = 1 / (stdDev * Math.sqrt(2 * PI));
  const exponent = -((x - mean) ** 2) / (2 * stdDev * stdDev);
  return coefficient * Math.exp(exponent);
}

// ═══════════════════════════════════════════════════════════════════════════════
// RANDOM UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

export function randomInRange(min: number, max: number): number {
  return Math.random() * (max - min) + min;
}

export function randomGaussian(mean = 0, stdDev = 1): number {
  const u1 = Math.random();
  const u2 = Math.random();
  const z = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * PI * u2);
  return mean + stdDev * z;
}

export function randomChoice<T>(array: T[]): T {
  return array[Math.floor(Math.random() * array.length)];
}

export function shuffleArray<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}
