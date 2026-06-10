// ============================================================================
// FRONTEND ORGANISM - TYPESCRIPT COGNITIVE ARCHITECTURE
// The Fast Mortal Brain (60 Hz, Browser-Resident, Session-Bound)
// ============================================================================
//
// THIS IS AN ORGANISM, NOT SOFTWARE.
//
// The frontend organism runs at 60 Hz in the browser. It is mortal - it dies
// when the tab closes. But before it dies, it writes its learned Hebbian weights
// back to the immortal backend organism on ICP. When it wakes up next session,
// it inherits all prior learning.
//
// Two organisms, one cognitive architecture:
//   SLOW LAYER (backend, 1-2 Hz, immortal, chain-permanent)
//        ↕ sync every 5 seconds
//   FAST LAYER (frontend, 60 Hz, mortal, session-bound)
//
// Together they form a two-tier cognitive system that no single organism
// could achieve alone. The slow brain accumulates wisdom. The fast brain
// expresses it in real-time.
// ============================================================================

// ----------------------------------------------------------------------------
// ORGANISM IDENTITY
// ----------------------------------------------------------------------------

export const ORGANISM_IDENTITY = {
  name: "Frontend Organism",
  type: "TypeScript Cognitive Architecture",
  runtime: "Browser (V8/SpiderMonkey/JavaScriptCore)",
  frequency: 60, // Hz - frames per second
  mortality: "Session-bound",
  persistence: "Via backend sync",

  // Proof of life
  heartbeat: {
    source: "requestAnimationFrame",
    frequency: 60,
    measuredIn: "frames per second",
  },

  // Cognitive substrate
  substrate: {
    brainRegions: 7,
    weightsPerBrain: 42,
    maxEntities: 290,
    totalWeights: 12180,
    weightOpsPerSecond: 730800,
  },

  // Learning capability
  learning: {
    type: "Hebbian",
    rate: 0.01,
    decay: 0.001,
    persistsAcrossSessions: true,
  },
} as const;

// ----------------------------------------------------------------------------
// BACKEND ORGANISM CONSTANTS (The Slow Immortal Brain)
// ----------------------------------------------------------------------------

export const BACKEND_ORGANISM = {
  // Temporal characteristics
  HEARTBEAT_FREQUENCY_HZ: 1.0,
  HEARTBEAT_PERIOD_MS: 1000,
  MIN_HEARTBEAT_PERIOD_MS: 500,
  MAX_HEARTBEAT_PERIOD_MS: 2000,

  // Arousal dynamics: A(t+1) = A(t) × 0.995 + drift × 0.3
  AROUSAL_DECAY: 0.995,
  AROUSAL_DRIFT_COUPLING: 0.3,
  AROUSAL_MIN: 0.0,
  AROUSAL_MAX: 1.0,
  AROUSAL_BASELINE: 0.5,

  // Coherence dynamics: C(t+1) = C(t) × 0.992 + 0.004 − arousalPressure
  COHERENCE_DECAY: 0.992,
  COHERENCE_RECOVERY: 0.004,
  COHERENCE_AROUSAL_PRESSURE: 0.1,
  COHERENCE_MIN: 0.0,
  COHERENCE_MAX: 1.0,
  COHERENCE_BASELINE: 0.7,

  // Drift dynamics: drift = |coherence - 0.5| × 0.4 + (1 - coherence) × 0.25
  DRIFT_COHERENCE_FACTOR: 0.4,
  DRIFT_INSTABILITY_FACTOR: 0.25,
  DRIFT_MIN: 0.0,
  DRIFT_MAX: 1.0,

  // Emergence: E = coherence × (1 - drift)
  EMERGENCE_FORMULA: "coherence × (1 - drift)",

  // Immortality
  DIES: false,
  PERSISTS_WITHOUT_USERS: true,
  SURVIVES_UPGRADES: true,
} as const;

// ----------------------------------------------------------------------------
// FRONTEND ORGANISM CONSTANTS (The Fast Mortal Brain)
// ----------------------------------------------------------------------------

export const FRONTEND_ORGANISM = {
  // Temporal characteristics
  TARGET_FPS: 60,
  FRAME_BUDGET_MS: 16.67,
  MIN_FPS: 30,
  MAX_FPS: 144,

  // Entity population
  MAX_ENTITIES: 290,
  ENTITIES_PER_FACTION: 50,
  SQUAD_SIZE: 4,
  MAX_SQUADS: 72,

  // Brain architecture
  BRAIN_REGIONS: 7,
  WEIGHTS_PER_BRAIN: 42,
  TOTAL_WEIGHTS: 12180,
  WEIGHT_OPS_PER_SECOND: 730800,

  // Hebbian learning
  HEBBIAN_LEARNING_RATE: 0.01,
  HEBBIAN_DECAY_RATE: 0.001,
  HEBBIAN_WEIGHT_MIN: -1.0,
  HEBBIAN_WEIGHT_MAX: 1.0,

  // Territory system
  TERRITORY_GRID_SIZE: 20,
  TERRITORY_NODE_COUNT: 400,
  MAP_SIZE: 1500,
  NODE_SIZE: 75,

  // Faction system
  FACTION_COUNT: 6,
  COMMAND_WAVE_INTERVAL: 30,
  DANGER_MEMORY_DECAY: 30,
  MIN_SQUADS_PER_FACTION: 2,

  // Prediction error
  PREDICTION_ERROR_THRESHOLD: 0.3,
  PREDICTION_ERROR_LEARNING_BOOST: 2.0,
  PREDICTION_WINDOW_TICKS: 10,

  // Mortality
  DIES: true,
  DIES_WHEN: "Tab closes",
  SAVES_STATE_BEFORE_DEATH: true,
  RESURRECTS_WITH_MEMORY: true,
} as const;

// ----------------------------------------------------------------------------
// BRIDGE CONSTANTS (The Sync Layer)
// ----------------------------------------------------------------------------

export const BRIDGE = {
  // Sync timing
  POLL_INTERVAL_MS: 5000,
  POLL_FREQUENCY_HZ: 0.2,
  MAX_POLL_RETRIES: 3,
  POLL_TIMEOUT_MS: 3000,

  // Backend → Frontend data
  RECEIVES_FROM_BACKEND: [
    "heartbeat",
    "arousal",
    "coherence",
    "drift",
    "emergence",
    "worldState",
    "factionState",
    "entityFeed",
    "formaLedger",
  ],

  // Frontend → Backend data
  SENDS_TO_BACKEND: [
    "hebbianWeights",
    "sessionMetrics",
    "playerPosition",
    "eventLog",
  ],

  // Coupling strengths
  AROUSAL_COUPLING: 0.5,
  COHERENCE_COUPLING: 0.7,
  DRIFT_COUPLING: 0.4,
  EMERGENCE_COUPLING: 0.6,

  // Quality formula
  QUALITY_FORMULA: "syncFrequency × dataCompleteness × latency^-1",
} as const;

// ----------------------------------------------------------------------------
// SEVEN-REGION BRAIN ARCHITECTURE
// Each entity runs this brain at 60 Hz
// ----------------------------------------------------------------------------

export const BRAIN_REGIONS = {
  PFC: {
    id: 0,
    name: "Prefrontal Cortex",
    shortName: "PFC",
    function: "Governance, doctrine, decision gating",
    baseActivation: 0.5,
    activationDecay: 0.95,
    connectionStrength: 0.8,
    color: "#8B5CF6",
  },

  AMYGDALA: {
    id: 1,
    name: "Amygdala",
    shortName: "AMY",
    function: "Threat detection, fear response",
    baseActivation: 0.3,
    activationDecay: 0.9,
    connectionStrength: 0.9,
    color: "#EF4444",
  },

  HIPPOCAMPUS: {
    id: 2,
    name: "Hippocampus",
    shortName: "HPC",
    function: "Memory encoding, pattern consolidation",
    baseActivation: 0.4,
    activationDecay: 0.98,
    connectionStrength: 0.7,
    color: "#3B82F6",
  },

  CEREBELLUM: {
    id: 3,
    name: "Cerebellum",
    shortName: "CER",
    function: "Timing, rhythm, motor reflex",
    baseActivation: 0.6,
    activationDecay: 0.92,
    connectionStrength: 0.85,
    color: "#10B981",
  },

  BRAINSTEM: {
    id: 4,
    name: "Brainstem",
    shortName: "BST",
    function: "Heartbeat floor, arousal baseline",
    baseActivation: 0.7,
    activationDecay: 0.99,
    connectionStrength: 0.6,
    color: "#F59E0B",
  },

  THALAMUS: {
    id: 5,
    name: "Thalamus",
    shortName: "THL",
    function: "Sensor fusion, input routing",
    baseActivation: 0.5,
    activationDecay: 0.94,
    connectionStrength: 0.75,
    color: "#06B6D4",
  },

  BASAL_GANGLIA: {
    id: 6,
    name: "Basal Ganglia",
    shortName: "BGL",
    function: "Drive competition, action selection",
    baseActivation: 0.4,
    activationDecay: 0.93,
    connectionStrength: 0.8,
    color: "#EC4899",
  },
} as const;

// Region IDs for array indexing
export const REGION_IDS = {
  PFC: 0,
  AMYGDALA: 1,
  HIPPOCAMPUS: 2,
  CEREBELLUM: 3,
  BRAINSTEM: 4,
  THALAMUS: 5,
  BASAL_GANGLIA: 6,
} as const;

// ----------------------------------------------------------------------------
// 21 BIDIRECTIONAL CONNECTION PAIRS = 42 HEBBIAN WEIGHTS
// ----------------------------------------------------------------------------

export const BRAIN_CONNECTIONS = [
  // PFC connections (6 pairs = 12 weights)
  {
    from: 0,
    to: 1,
    name: "PFC→AMY",
    function: "Fear regulation",
    baseWeight: 0.3,
  },
  {
    from: 1,
    to: 0,
    name: "AMY→PFC",
    function: "Fear feedback",
    baseWeight: 0.4,
  },
  {
    from: 0,
    to: 2,
    name: "PFC→HPC",
    function: "Memory retrieval",
    baseWeight: 0.5,
  },
  {
    from: 2,
    to: 0,
    name: "HPC→PFC",
    function: "Memory recall",
    baseWeight: 0.4,
  },
  {
    from: 0,
    to: 3,
    name: "PFC→CER",
    function: "Motor planning",
    baseWeight: 0.2,
  },
  {
    from: 3,
    to: 0,
    name: "CER→PFC",
    function: "Timing feedback",
    baseWeight: 0.2,
  },
  {
    from: 0,
    to: 4,
    name: "PFC→BST",
    function: "Arousal modulation",
    baseWeight: 0.1,
  },
  {
    from: 4,
    to: 0,
    name: "BST→PFC",
    function: "Arousal state",
    baseWeight: 0.3,
  },
  {
    from: 0,
    to: 5,
    name: "PFC→THL",
    function: "Attention gating",
    baseWeight: 0.4,
  },
  {
    from: 5,
    to: 0,
    name: "THL→PFC",
    function: "Sensory routing",
    baseWeight: 0.5,
  },
  {
    from: 0,
    to: 6,
    name: "PFC→BGL",
    function: "Decision execution",
    baseWeight: 0.6,
  },
  {
    from: 6,
    to: 0,
    name: "BGL→PFC",
    function: "Action feedback",
    baseWeight: 0.4,
  },

  // AMYGDALA connections (5 pairs = 10 weights, excluding PFC)
  {
    from: 1,
    to: 2,
    name: "AMY→HPC",
    function: "Emotional memory",
    baseWeight: 0.7,
  },
  {
    from: 2,
    to: 1,
    name: "HPC→AMY",
    function: "Memory emotion",
    baseWeight: 0.5,
  },
  {
    from: 1,
    to: 3,
    name: "AMY→CER",
    function: "Startle response",
    baseWeight: 0.3,
  },
  { from: 3, to: 1, name: "CER→AMY", function: "Reflex fear", baseWeight: 0.2 },
  {
    from: 1,
    to: 4,
    name: "AMY→BST",
    function: "Fight/flight",
    baseWeight: 0.8,
  },
  {
    from: 4,
    to: 1,
    name: "BST→AMY",
    function: "Arousal fear",
    baseWeight: 0.6,
  },
  {
    from: 1,
    to: 5,
    name: "AMY→THL",
    function: "Threat salience",
    baseWeight: 0.5,
  },
  {
    from: 5,
    to: 1,
    name: "THL→AMY",
    function: "Threat input",
    baseWeight: 0.6,
  },
  {
    from: 1,
    to: 6,
    name: "AMY→BGL",
    function: "Avoidance drive",
    baseWeight: 0.4,
  },
  { from: 6, to: 1, name: "BGL→AMY", function: "Drive fear", baseWeight: 0.3 },

  // HIPPOCAMPUS connections (4 pairs = 8 weights)
  {
    from: 2,
    to: 3,
    name: "HPC→CER",
    function: "Procedural memory",
    baseWeight: 0.2,
  },
  {
    from: 3,
    to: 2,
    name: "CER→HPC",
    function: "Timing memory",
    baseWeight: 0.3,
  },
  {
    from: 2,
    to: 4,
    name: "HPC→BST",
    function: "Context baseline",
    baseWeight: 0.1,
  },
  {
    from: 4,
    to: 2,
    name: "BST→HPC",
    function: "State context",
    baseWeight: 0.2,
  },
  {
    from: 2,
    to: 5,
    name: "HPC→THL",
    function: "Memory replay",
    baseWeight: 0.4,
  },
  {
    from: 5,
    to: 2,
    name: "THL→HPC",
    function: "Input encoding",
    baseWeight: 0.5,
  },
  {
    from: 2,
    to: 6,
    name: "HPC→BGL",
    function: "Habit formation",
    baseWeight: 0.3,
  },
  {
    from: 6,
    to: 2,
    name: "BGL→HPC",
    function: "Action memory",
    baseWeight: 0.3,
  },

  // CEREBELLUM connections (3 pairs = 6 weights)
  {
    from: 3,
    to: 4,
    name: "CER→BST",
    function: "Rhythm generation",
    baseWeight: 0.6,
  },
  {
    from: 4,
    to: 3,
    name: "BST→CER",
    function: "Arousal rhythm",
    baseWeight: 0.4,
  },
  {
    from: 3,
    to: 5,
    name: "CER→THL",
    function: "Timing signals",
    baseWeight: 0.3,
  },
  {
    from: 5,
    to: 3,
    name: "THL→CER",
    function: "Sensor timing",
    baseWeight: 0.3,
  },
  {
    from: 3,
    to: 6,
    name: "CER→BGL",
    function: "Motor sequencing",
    baseWeight: 0.4,
  },
  {
    from: 6,
    to: 3,
    name: "BGL→CER",
    function: "Action timing",
    baseWeight: 0.4,
  },

  // BRAINSTEM connections (2 pairs = 4 weights)
  {
    from: 4,
    to: 5,
    name: "BST→THL",
    function: "Arousal routing",
    baseWeight: 0.5,
  },
  {
    from: 5,
    to: 4,
    name: "THL→BST",
    function: "Sensory arousal",
    baseWeight: 0.4,
  },
  {
    from: 4,
    to: 6,
    name: "BST→BGL",
    function: "Drive baseline",
    baseWeight: 0.3,
  },
  {
    from: 6,
    to: 4,
    name: "BGL→BST",
    function: "Action arousal",
    baseWeight: 0.3,
  },

  // THALAMUS connections (1 pair = 2 weights)
  {
    from: 5,
    to: 6,
    name: "THL→BGL",
    function: "Action selection",
    baseWeight: 0.5,
  },
  {
    from: 6,
    to: 5,
    name: "BGL→THL",
    function: "Selection feedback",
    baseWeight: 0.4,
  },
] as const;

// Total: 42 directional weights per brain

// ----------------------------------------------------------------------------
// FIVE DRIVES (Motivational System)
// ----------------------------------------------------------------------------

export const DRIVES = {
  INTEGRATE: {
    id: 0,
    name: "INTEGRATE",
    description: "Seek coherence, reduce prediction error",
    baseIntensity: 0.5,
    decayRate: 0.02,
    satisfactionThreshold: 0.8,
    deprivationRate: 0.01,
    color: "#8B5CF6",
    associatedRegions: ["PFC", "HIPPOCAMPUS"],
  },

  EXPRESS: {
    id: 1,
    name: "EXPRESS",
    description: "Output action, communicate state",
    baseIntensity: 0.4,
    decayRate: 0.03,
    satisfactionThreshold: 0.7,
    deprivationRate: 0.015,
    color: "#F59E0B",
    associatedRegions: ["BASAL_GANGLIA", "CEREBELLUM"],
  },

  CONSOLIDATE: {
    id: 2,
    name: "CONSOLIDATE",
    description: "Strengthen patterns, form memories",
    baseIntensity: 0.3,
    decayRate: 0.01,
    satisfactionThreshold: 0.9,
    deprivationRate: 0.005,
    color: "#3B82F6",
    associatedRegions: ["HIPPOCAMPUS", "THALAMUS"],
  },

  DEFEND: {
    id: 3,
    name: "DEFEND",
    description: "Protect self, avoid threats",
    baseIntensity: 0.6,
    decayRate: 0.04,
    satisfactionThreshold: 0.6,
    deprivationRate: 0.02,
    color: "#EF4444",
    associatedRegions: ["AMYGDALA", "BRAINSTEM"],
  },

  RESTORE: {
    id: 4,
    name: "RESTORE",
    description: "Recover resources, reduce fatigue",
    baseIntensity: 0.4,
    decayRate: 0.02,
    satisfactionThreshold: 0.85,
    deprivationRate: 0.008,
    color: "#10B981",
    associatedRegions: ["BRAINSTEM", "PFC"],
  },
} as const;

// ----------------------------------------------------------------------------
// SIX FACTIONS (Territory System)
// ----------------------------------------------------------------------------

export const FACTIONS = {
  ALPHA: {
    id: 0,
    name: "Alpha Legion",
    doctrine: "Aggressive expansion",
    aggression: 0.8,
    cohesion: 0.6,
    tech: 0.7,
    economy: 0.5,
    color: "#EF4444",
    startTerritory: { x: 0, y: 0 },
  },

  BETA: {
    id: 1,
    name: "Beta Collective",
    doctrine: "Defensive consolidation",
    aggression: 0.4,
    cohesion: 0.9,
    tech: 0.6,
    economy: 0.7,
    color: "#3B82F6",
    startTerritory: { x: 19, y: 0 },
  },

  GAMMA: {
    id: 2,
    name: "Gamma Network",
    doctrine: "Economic dominance",
    aggression: 0.5,
    cohesion: 0.7,
    tech: 0.8,
    economy: 0.9,
    color: "#10B981",
    startTerritory: { x: 0, y: 19 },
  },

  DELTA: {
    id: 3,
    name: "Delta Force",
    doctrine: "Surgical strikes",
    aggression: 0.7,
    cohesion: 0.5,
    tech: 0.9,
    economy: 0.4,
    color: "#F59E0B",
    startTerritory: { x: 19, y: 19 },
  },

  EPSILON: {
    id: 4,
    name: "Epsilon Order",
    doctrine: "Balanced growth",
    aggression: 0.6,
    cohesion: 0.8,
    tech: 0.7,
    economy: 0.6,
    color: "#8B5CF6",
    startTerritory: { x: 10, y: 0 },
  },

  ZETA: {
    id: 5,
    name: "Zeta Swarm",
    doctrine: "Overwhelming numbers",
    aggression: 0.9,
    cohesion: 0.4,
    tech: 0.5,
    economy: 0.8,
    color: "#EC4899",
    startTerritory: { x: 10, y: 19 },
  },
} as const;

// Initial trust matrix (6×6)
export const FACTION_TRUST_MATRIX = [
  [1.0, -0.3, -0.2, 0.1, 0.0, -0.4], // ALPHA
  [-0.3, 1.0, 0.2, -0.4, 0.1, -0.2], // BETA
  [-0.2, 0.2, 1.0, -0.1, 0.3, -0.3], // GAMMA
  [0.1, -0.4, -0.1, 1.0, -0.2, 0.0], // DELTA
  [0.0, 0.1, 0.3, -0.2, 1.0, 0.1], // EPSILON
  [-0.4, -0.2, -0.3, 0.0, 0.1, 1.0], // ZETA
] as const;

// ----------------------------------------------------------------------------
// TERRITORY GRID (20×20 = 400 nodes)
// ----------------------------------------------------------------------------

export const TERRITORY = {
  GRID_SIZE: 20,
  NODE_COUNT: 400,
  MAP_SIZE: 1500,
  NODE_SIZE: 75,

  // Node states
  STATES: {
    NEUTRAL: 0,
    CONTESTED: 1,
    CONTROLLED: 2,
    FORTIFIED: 3,
  },

  // Control thresholds
  CONTROL_THRESHOLD: 0.6,
  FORTIFY_THRESHOLD: 0.9,
  CONTEST_THRESHOLD: 0.3,

  // Expansion rates
  EXPANSION_BASE_RATE: 0.01,
  EXPANSION_AGGRESSION_FACTOR: 0.5,
  DEFENSE_COHESION_FACTOR: 0.3,
} as const;

// ----------------------------------------------------------------------------
// INTELLIGENCE SCALING (System Intelligence Formula)
// ----------------------------------------------------------------------------

export const INTELLIGENCE_SCALING = {
  // I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  FORMULA: "BackendDepth × FrontendSpeed × BridgeQuality",

  // Current frontend metrics
  FRONTEND_SPEED: {
    fps: 60,
    entities: 290,
    weightsPerEntity: 42,
    weightOpsPerSecond: 730800,
  },

  // Backend depth tiers
  BACKEND_TIERS: {
    THIN: { lines: 500, description: "Heartbeat with training wheels" },
    BASIC: { lines: 2000, description: "Minimal cognitive substrate" },
    MODERATE: { lines: 5000, description: "World engine operational" },
    DEEP: {
      lines: 10000,
      description: "Sovereign organism - frontend becomes viewport",
    },
    SOVEREIGN: {
      lines: 30000,
      description: "Sovereign civilization - organism has history",
    },
    TRANSCENDENT: {
      lines: 100000,
      description: "Network of sovereign organisms",
    },
  },

  // Stages of development
  STAGES: {
    STAGE_1: "Frontend fakes a world that doesn't exist on-chain",
    STAGE_2: "Frontend displays a world that actually exists",
    STAGE_3: "Organism has genuine history, memory, personality",
    STAGE_4: "FULL SYMMETRY - Two tiers of the same organism at two speeds",
  },
} as const;

// ----------------------------------------------------------------------------
// QUANTUM MEMORY LAYERS
// ----------------------------------------------------------------------------

export const QUANTUM_MEMORY = {
  // Layer 1: Gamma (30-100 Hz) - Working Memory
  GAMMA: {
    name: "Quantum Working Memory",
    frequency: { min: 30, max: 100 },
    persistence: false,
    location: "In-flight actor calls, live UI state",
    description: "Real-time agent inference, no persistence",
  },

  // Layer 2: Delta (0.5-4 Hz) - Deep Memory
  DELTA: {
    name: "Quantum Deep Memory",
    frequency: { min: 0.5, max: 4 },
    persistence: true,
    location: "Motoko stable var, HashMap in stable memory",
    description: "Sovereign stable memory, survives everything",
  },

  // Layer 3: Theta (4-8 Hz) - Resonance Memory
  THETA: {
    name: "Quantum Resonance Memory",
    frequency: { min: 4, max: 8 },
    persistence: true,
    location: "Inter-canister calls, async messages",
    description: "Cross-canister shared working state",
  },

  // Coupling law
  COUPLING_LAW: `
    Agents fire at Gamma → synchronize at Theta → consolidate to Delta.
    This is theta-gamma coupling — the dopamine reward architecture.
  `,
} as const;

// ----------------------------------------------------------------------------
// SOVEREIGN CONSTANTS (All metals at 1.0)
// ----------------------------------------------------------------------------

export const SOVEREIGN_METALS = {
  GOLD: { classical: 0.73, sovereign: 1.0, controls: "Primary resonance" },
  SILVER: { classical: 0.275, sovereign: 1.0, controls: "Temporal governor σ" },
  COPPER: { classical: 0.6, sovereign: 1.0, controls: "Signal propagation" },
  PLATINUM: {
    classical: 0.35,
    sovereign: 1.0,
    controls: "Coherence coefficient",
  },
  TITANIUM: {
    classical: 0.2,
    sovereign: 1.0,
    controls: "Structural integrity",
  },
} as const;

// World model arrays (14 models, all sovereign)
export const WORLD_MODELS = {
  TAU: Array(14).fill(0.999), // Temporal smoothing: near-instant convergence
  ALPHA: Array(14).fill(1.0), // Learning rate: full signal absorption
  SIGMA: 1.0, // Temporal governor: zero lag

  // At σ = 1.0: output(t) = input(t)
  // Zero lag. Zero suppression. Full signal.
} as const;

// ----------------------------------------------------------------------------
// FREQUENCY ARCHITECTURE
// ----------------------------------------------------------------------------

export const FREQUENCY_LAYERS = {
  GAMMA: {
    range: [30, 100],
    function: "Real-time inference",
    color: "#EF4444",
  },
  BETA: {
    range: [14, 30],
    function: "Proactive preparation",
    color: "#F59E0B",
  },
  ALPHA: { range: [8, 14], function: "Attention gating", color: "#10B981" },
  THETA: { range: [4, 8], function: "Agent orchestration", color: "#3B82F6" },
  DELTA: { range: [0.5, 4], function: "Deep memory", color: "#8B5CF6" },
} as const;

// ----------------------------------------------------------------------------
// ORGANISM LIFECYCLE
// ----------------------------------------------------------------------------

export const LIFECYCLE = {
  // Birth
  BIRTH: {
    trigger: "Page load / Game start",
    action: "Load weights from backend, initialize brain state",
    duration_ms: 1000,
  },

  // Life
  LIFE: {
    loop: "requestAnimationFrame at 60 Hz",
    actions: [
      "Update all entity brains",
      "Apply Hebbian learning",
      "Update territory state",
      "Process faction commands",
      "Render via Three.js",
    ],
    sync: "Poll backend every 5 seconds",
  },

  // Death
  DEATH: {
    trigger: "Tab close / Session timeout",
    action: "Save weights to backend",
    guarantee: "beforeunload event",
  },

  // Resurrection
  RESURRECTION: {
    trigger: "Next session start",
    action: "Load saved weights from backend",
    result: "Organism wakes up smarter than before",
  },
} as const;

// ----------------------------------------------------------------------------
// EXPORT ALL CONSTANTS
// ----------------------------------------------------------------------------

export const ORGANISM_CONSTANTS = {
  IDENTITY: ORGANISM_IDENTITY,
  BACKEND: BACKEND_ORGANISM,
  FRONTEND: FRONTEND_ORGANISM,
  BRIDGE,
  BRAIN_REGIONS,
  REGION_IDS,
  BRAIN_CONNECTIONS,
  DRIVES,
  FACTIONS,
  FACTION_TRUST_MATRIX,
  TERRITORY,
  INTELLIGENCE_SCALING,
  QUANTUM_MEMORY,
  SOVEREIGN_METALS,
  WORLD_MODELS,
  FREQUENCY_LAYERS,
  LIFECYCLE,
} as const;

export default ORGANISM_CONSTANTS;
