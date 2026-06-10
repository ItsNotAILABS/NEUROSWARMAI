/**
 * NEUROCHEMISTRY ENGINE - MATHEMATICAL TYPES
 *
 * FREDDY'S ARCHITECTURAL DOCTRINE:
 * These types define the mathematical structures for the organism's
 * neurochemical system - the chemical substrate of intelligence.
 *
 * The same type system applies to both organisms:
 * - Backend (male, 1-2 Hz, sovereign, accumulates)
 * - Frontend (female, 60 Hz, expressive, displays)
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 */

import type { BrainRegion, NeurochemicalAnalog } from "./constants";

// ============================================================================
// NEUROCHEMICAL STATE
// The current concentration of all 21 neurochemicals
// ============================================================================

/**
 * Complete neurochemical state - the organism's chemical profile
 */
export interface NeurochemicalState {
  /** Concentration of each neurochemical (0-1 normalized) */
  concentrations: Record<NeurochemicalAnalog, number>;

  /** Rate of change for each neurochemical */
  derivatives: Record<NeurochemicalAnalog, number>;

  /** Integral accumulator for PID control */
  integrals: Record<NeurochemicalAnalog, number>;

  /** Previous error for derivative calculation */
  previousErrors: Record<NeurochemicalAnalog, number>;

  /** Timestamp of last update */
  lastUpdateTick: number;

  /** Current circadian phase (0-1, 0=midnight) */
  circadianPhase: number;
}

/**
 * Neurochemical delta - changes to apply
 */
export interface NeurochemicalDelta {
  analog: NeurochemicalAnalog;
  delta: number;
  source: NeurochemicalSource;
  timestamp: number;
}

/**
 * Source of neurochemical change
 */
export type NeurochemicalSource =
  | "crosstalk" // From another neurochemical
  | "stimulus" // External stimulus
  | "decay" // Natural decay to baseline
  | "homeostatic" // PID controller correction
  | "circadian" // Circadian rhythm modulation
  | "backend_sync" // Synced from backend organism
  | "user_action" // Direct user input
  | "entity_event" // Entity behavior event
  | "territory_event" // Territory state change
  | "faction_event"; // Faction interaction

// ============================================================================
// CROSSTALK COMPUTATION
// The 441 interaction pairs
// ============================================================================

/**
 * Single crosstalk interaction
 */
export interface CrosstalkInteraction {
  sourceAnalog: NeurochemicalAnalog;
  targetAnalog: NeurochemicalAnalog;
  coefficient: number;
  computedEffect: number;
}

/**
 * Complete crosstalk computation result
 */
export interface CrosstalkResult {
  /** All 441 individual interactions */
  interactions: CrosstalkInteraction[];

  /** Net effect on each neurochemical */
  netEffects: Record<NeurochemicalAnalog, number>;

  /** Total crosstalk magnitude (sum of absolute effects) */
  totalMagnitude: number;

  /** Dominant interaction (largest effect) */
  dominantInteraction: CrosstalkInteraction | null;

  /** Computation timestamp */
  timestamp: number;
}

/**
 * Crosstalk matrix snapshot for visualization
 */
export interface CrosstalkMatrixSnapshot {
  /** The 21x21 matrix of current effective coefficients */
  matrix: number[][];

  /** Row sums (how much each chemical affects others) */
  outgoingInfluence: number[];

  /** Column sums (how much each chemical is affected) */
  incomingInfluence: number[];

  /** Most influential chemical (highest outgoing) */
  mostInfluential: NeurochemicalAnalog;

  /** Most sensitive chemical (highest incoming) */
  mostSensitive: NeurochemicalAnalog;
}

// ============================================================================
// RECEPTOR BINDING
// 147 receptor mappings (7 regions × 21 chemicals)
// ============================================================================

/**
 * Receptor binding state for a single region
 */
export interface RegionReceptorState {
  region: BrainRegion;

  /** Binding level for each neurochemical (0-1) */
  bindingLevels: Record<NeurochemicalAnalog, number>;

  /** Effective activation (binding × receptor density) */
  effectiveActivation: Record<NeurochemicalAnalog, number>;

  /** Total regional activation */
  totalActivation: number;

  /** Dominant neurochemical in this region */
  dominantChemical: NeurochemicalAnalog;
}

/**
 * Complete receptor state across all 7 regions
 */
export interface FullReceptorState {
  regions: Record<BrainRegion, RegionReceptorState>;

  /** Cross-region activation patterns */
  activationPattern: number[];

  /** Global neural tone (average activation) */
  globalTone: number;

  /** E/I ratio (excitation / inhibition balance) */
  eiRatio: number;
}

// ============================================================================
// DOSE-RESPONSE COMPUTATION
// ============================================================================

/**
 * Dose-response curve evaluation
 */
export interface DoseResponseResult {
  analog: NeurochemicalAnalog;
  concentration: number;
  effect: number;

  /** Position on the curve (0=floor, 0.5=EC50, 1=ceiling) */
  curvePosition: number;

  /** Slope at current concentration */
  localSlope: number;

  /** Distance from EC50 */
  distanceFromEC50: number;
}

/**
 * Aggregate dose-response for a chemical group
 */
export interface GroupDoseResponse {
  groupName: string;
  chemicals: NeurochemicalAnalog[];
  averageEffect: number;
  minEffect: number;
  maxEffect: number;
  spread: number;
}

// ============================================================================
// BEHAVIORAL STATE DETECTION
// ============================================================================

/**
 * Match result for a behavioral state profile
 */
export interface BehavioralStateMatch {
  stateName: string;
  matchScore: number; // 0-1, how well current state matches profile
  matchingChemicals: NeurochemicalAnalog[];
  mismatchingChemicals: NeurochemicalAnalog[];
  confidence: number; // Statistical confidence
}

/**
 * Complete behavioral state analysis
 */
export interface BehavioralStateAnalysis {
  /** Best matching state */
  primaryState: BehavioralStateMatch;

  /** All states with match > 0.5 */
  activeStates: BehavioralStateMatch[];

  /** State transition probability */
  transitionProbabilities: Record<string, number>;

  /** Stability score (how stable current state is) */
  stateStability: number;

  /** Time in current state (ticks) */
  stateDuration: number;
}

// ============================================================================
// CIRCADIAN MODULATION
// ============================================================================

/**
 * Circadian state
 */
export interface CircadianState {
  /** Current phase (0-1, 0=midnight) */
  phase: number;

  /** Phase in radians (0-2π) */
  phaseRadians: number;

  /** Time of day label */
  timeOfDay:
    | "night"
    | "dawn"
    | "morning"
    | "noon"
    | "afternoon"
    | "evening"
    | "dusk";

  /** Modulation factor for each neurochemical */
  modulation: Record<NeurochemicalAnalog, number>;

  /** Overall circadian arousal level */
  circadianArousal: number;

  /** Sleep pressure (adenosine-driven) */
  sleepPressure: number;
}

/**
 * Circadian prediction
 */
export interface CircadianPrediction {
  /** Hours until peak for each chemical */
  hoursUntilPeak: Record<NeurochemicalAnalog, number>;

  /** Hours until trough for each chemical */
  hoursUntilTrough: Record<NeurochemicalAnalog, number>;

  /** Predicted behavioral state at future time */
  predictedStates: Array<{
    hoursAhead: number;
    likelyState: string;
    confidence: number;
  }>;
}

// ============================================================================
// HOMEOSTATIC CONTROL
// ============================================================================

/**
 * PID controller state for a single neurochemical
 */
export interface HomeostaticControllerState {
  analog: NeurochemicalAnalog;

  /** Current error (setpoint - actual) */
  error: number;

  /** Integral of error over time */
  integralError: number;

  /** Rate of change of error */
  derivativeError: number;

  /** Controller output (correction signal) */
  output: number;

  /** Is controller saturated? */
  saturated: boolean;

  /** Proportional contribution */
  pTerm: number;

  /** Integral contribution */
  iTerm: number;

  /** Derivative contribution */
  dTerm: number;
}

/**
 * Complete homeostatic system state
 */
export interface HomeostaticSystemState {
  controllers: Record<NeurochemicalAnalog, HomeostaticControllerState>;

  /** Overall system error (RMS of all errors) */
  systemError: number;

  /** Number of controllers currently active */
  activeControllers: number;

  /** Chemicals most out of balance */
  mostUnbalanced: NeurochemicalAnalog[];

  /** Overall homeostatic stability (0=unstable, 1=perfect balance) */
  stability: number;
}

// ============================================================================
// TEMPORAL DYNAMICS
// ============================================================================

/**
 * Neurochemical time series point
 */
export interface NeurochemicalTimePoint {
  tick: number;
  timestamp: number;
  concentrations: Record<NeurochemicalAnalog, number>;
  behavioralState: string;
}

/**
 * Neurochemical history for analysis
 */
export interface NeurochemicalHistory {
  /** Time series data */
  points: NeurochemicalTimePoint[];

  /** Window size in ticks */
  windowSize: number;

  /** Statistics per chemical */
  statistics: Record<
    NeurochemicalAnalog,
    {
      mean: number;
      std: number;
      min: number;
      max: number;
      trend: number; // positive = increasing, negative = decreasing
      volatility: number;
    }
  >;

  /** State transition history */
  stateTransitions: Array<{
    fromState: string;
    toState: string;
    tick: number;
  }>;
}

// ============================================================================
// ORGANISM BRIDGE TYPES
// For syncing between backend (male) and frontend (female)
// ============================================================================

/**
 * Neurochemical state package from backend
 */
export interface BackendNeurochemicalPulse {
  /** Backend heartbeat number */
  heartbeat: number;

  /** Timestamp on backend */
  backendTimestamp: number;

  /** Core neurochemical concentrations */
  concentrations: Record<NeurochemicalAnalog, number>;

  /** Backend behavioral state */
  behavioralState: string;

  /** Backend stability metrics */
  stability: number;

  /** Accumulated learning (Hebbian weights summary) */
  learningAccumulated: number;
}

/**
 * Neurochemical state to send to backend
 */
export interface FrontendNeurochemicalReport {
  /** Frontend session ID */
  sessionId: string;

  /** Ticks elapsed in frontend */
  ticksElapsed: number;

  /** Average concentrations during session */
  averageConcentrations: Record<NeurochemicalAnalog, number>;

  /** Peak concentrations */
  peakConcentrations: Record<NeurochemicalAnalog, number>;

  /** State time distribution */
  stateTimeDistribution: Record<string, number>;

  /** Significant events */
  significantEvents: NeurochemicalEvent[];
}

/**
 * Neurochemical event (significant change)
 */
export interface NeurochemicalEvent {
  tick: number;
  eventType: "spike" | "crash" | "transition" | "threshold";
  analog: NeurochemicalAnalog;
  previousValue: number;
  newValue: number;
  trigger: string;
}

// ============================================================================
// VISUALIZATION TYPES
// ============================================================================

/**
 * Neurochemical visualization data
 */
export interface NeurochemicalVisualization {
  /** For bar chart display */
  barData: Array<{
    name: string;
    value: number;
    baseline: number;
    color: string;
    deviation: number;
  }>;

  /** For radar chart display */
  radarData: Array<{
    axis: string;
    value: number;
  }>;

  /** For heat map display */
  heatMapData: number[][];

  /** For time series display */
  timeSeriesData: Record<NeurochemicalAnalog, number[]>;

  /** For network graph display */
  networkData: {
    nodes: Array<{
      id: string;
      label: string;
      value: number;
      color: string;
    }>;
    edges: Array<{
      from: string;
      to: string;
      weight: number;
    }>;
  };
}

/**
 * Brain region visualization
 */
export interface BrainRegionVisualization {
  regions: Array<{
    id: BrainRegion;
    name: string;
    activation: number;
    dominantChemical: string;
    color: string;
    position: { x: number; y: number; z: number };
  }>;

  connections: Array<{
    from: BrainRegion;
    to: BrainRegion;
    strength: number;
  }>;
}

// ============================================================================
// ENGINE CONFIGURATION
// ============================================================================

/**
 * Neurochemistry engine configuration
 */
export interface NeurochemistryEngineConfig {
  /** Enable crosstalk computation */
  enableCrosstalk: boolean;

  /** Enable homeostatic control */
  enableHomeostasis: boolean;

  /** Enable circadian modulation */
  enableCircadian: boolean;

  /** Update rate (ticks per second) */
  tickRate: number;

  /** History window size */
  historyWindowTicks: number;

  /** Backend sync interval (ticks) */
  backendSyncInterval: number;

  /** Visualization update interval (ticks) */
  visualizationUpdateInterval: number;

  /** Sensitivity multiplier (1.0 = normal) */
  sensitivityMultiplier: number;

  /** Temporal governor σ (1.0 = sovereign, no lag) */
  temporalGovernorSigma: number;
}

/**
 * Default engine configuration (sovereign operation)
 */
export const DEFAULT_NEUROCHEMISTRY_CONFIG: NeurochemistryEngineConfig = {
  enableCrosstalk: true,
  enableHomeostasis: true,
  enableCircadian: true,
  tickRate: 60,
  historyWindowTicks: 3600, // 1 minute at 60 Hz
  backendSyncInterval: 300, // Every 5 seconds
  visualizationUpdateInterval: 6, // 10 times per second
  sensitivityMultiplier: 1.0,
  temporalGovernorSigma: 1.0, // Sovereign - no lag
};

// ============================================================================
// MATHEMATICAL CONSTANTS
// ============================================================================

/**
 * Mathematical constants for neurochemistry computations
 */
export const NEUROCHEMISTRY_MATH_CONSTANTS = {
  /** Euler's number for exponential decay */
  E: Math.E,

  /** Pi for phase calculations */
  PI: Math.PI,

  /** Two Pi for full cycle */
  TWO_PI: 2 * Math.PI,

  /** Sigmoid midpoint */
  SIGMOID_MIDPOINT: 0.5,

  /** Small epsilon for numerical stability */
  EPSILON: 1e-10,

  /** Maximum concentration (normalized ceiling) */
  MAX_CONCENTRATION: 1.0,

  /** Minimum concentration (floor) */
  MIN_CONCENTRATION: 0.0,

  /** Default learning rate η */
  DEFAULT_ETA: 0.01,

  /** Default decay rate λ */
  DEFAULT_LAMBDA: 0.001,
} as const;
