// ============================================================================
// FRONTEND ORGANISM TYPES
// TypeScript Type Definitions for the Fast Mortal Brain
// ============================================================================

// ----------------------------------------------------------------------------
// BRAIN REGION TYPES
// ----------------------------------------------------------------------------

export type BrainRegionId = 0 | 1 | 2 | 3 | 4 | 5 | 6;

export type BrainRegionName =
  | "PFC"
  | "AMYGDALA"
  | "HIPPOCAMPUS"
  | "CEREBELLUM"
  | "BRAINSTEM"
  | "THALAMUS"
  | "BASAL_GANGLIA";

export interface BrainRegionConfig {
  id: BrainRegionId;
  name: string;
  shortName: BrainRegionName;
  function: string;
  baseActivation: number;
  activationDecay: number;
  connectionStrength: number;
  color: string;
}

export interface BrainRegionState {
  id: BrainRegionId;
  activation: number;
  previousActivation: number;
  input: number;
  output: number;
  lastUpdateTime: number;
}

// ----------------------------------------------------------------------------
// HEBBIAN WEIGHT TYPES
// ----------------------------------------------------------------------------

export interface HebbianConnection {
  from: BrainRegionId;
  to: BrainRegionId;
  name: string;
  function: string;
  baseWeight: number;
}

export interface HebbianWeight {
  connectionIndex: number;
  from: BrainRegionId;
  to: BrainRegionId;
  weight: number;
  previousWeight: number;
  learningRate: number;
  decayRate: number;
  lastUpdateTime: number;
  updateCount: number;
}

export interface HebbianWeightMatrix {
  weights: Float32Array; // 42 weights as flat array
  lastUpdate: number;
  totalUpdates: bigint;
  learningEvents: number;
}

// ----------------------------------------------------------------------------
// ENTITY BRAIN TYPES
// ----------------------------------------------------------------------------

export interface EntityBrain {
  entityId: string;
  factionId: number;

  // Region states (7 regions)
  regions: BrainRegionState[];

  // Hebbian weights (42 connections)
  weights: HebbianWeightMatrix;

  // Drive states (5 drives)
  drives: DriveState[];

  // Prediction system
  prediction: PredictionState;

  // Lifecycle
  birthTime: number;
  lastTickTime: number;
  tickCount: bigint;
  isAlive: boolean;
}

export interface EntityBrainSnapshot {
  entityId: string;
  timestamp: number;
  regions: number[]; // 7 activation values
  weights: number[]; // 42 weight values
  drives: number[]; // 5 drive intensities
  predictionError: number;
}

// ----------------------------------------------------------------------------
// DRIVE TYPES
// ----------------------------------------------------------------------------

export type DriveId = 0 | 1 | 2 | 3 | 4;

export type DriveName =
  | "INTEGRATE"
  | "EXPRESS"
  | "CONSOLIDATE"
  | "DEFEND"
  | "RESTORE";

export interface DriveConfig {
  id: DriveId;
  name: DriveName;
  description: string;
  baseIntensity: number;
  decayRate: number;
  satisfactionThreshold: number;
  deprivationRate: number;
  color: string;
  associatedRegions: BrainRegionName[];
}

export interface DriveState {
  id: DriveId;
  name: DriveName;
  intensity: number;
  satisfaction: number;
  deprivation: number;
  lastSatisfiedTime: number;
  isActive: boolean;
  priority: number;
}

export interface DriveCompetition {
  winner: DriveId;
  winnerIntensity: number;
  runnerUp: DriveId;
  runnerUpIntensity: number;
  margin: number;
  timestamp: number;
}

// ----------------------------------------------------------------------------
// PREDICTION ERROR TYPES
// ----------------------------------------------------------------------------

export interface PredictionState {
  expectedState: number[]; // Predicted next activation per region
  actualState: number[]; // Actual activation observed
  error: number; // Magnitude of prediction error
  errorHistory: number[]; // Rolling window of errors
  learningBoost: number; // Multiplier when error is high
  surpriseLevel: number; // 0-1 surprise indicator
  lastPredictionTime: number;
}

export interface PredictionErrorEvent {
  timestamp: number;
  entityId: string;
  expectedState: number[];
  actualState: number[];
  error: number;
  triggeredLearning: boolean;
  learningBoost: number;
}

// ----------------------------------------------------------------------------
// FACTION TYPES
// ----------------------------------------------------------------------------

export type FactionId = 0 | 1 | 2 | 3 | 4 | 5;

export type FactionName =
  | "ALPHA"
  | "BETA"
  | "GAMMA"
  | "DELTA"
  | "EPSILON"
  | "ZETA";

export interface FactionConfig {
  id: FactionId;
  name: string;
  codeName: FactionName;
  doctrine: string;
  aggression: number;
  cohesion: number;
  tech: number;
  economy: number;
  color: string;
  startTerritory: { x: number; y: number };
}

export interface FactionState {
  id: FactionId;
  name: string;

  // Territory
  controlledNodes: number;
  contestedNodes: number;
  territoryPercentage: number;

  // Military
  squadCount: number;
  entityCount: number;
  avgSquadStrength: number;

  // Relations
  trustMatrix: number[]; // Trust toward each faction
  activeWars: FactionId[];
  alliances: FactionId[];

  // State
  aggression: number;
  cohesion: number;
  morale: number;
  resources: number;

  // Command
  currentDirective: FactionDirective;
  lastCommandWave: number;
}

export type FactionDirective =
  | "EXPAND"
  | "DEFEND"
  | "CONSOLIDATE"
  | "ATTACK"
  | "RETREAT"
  | "REINFORCE";

export interface FactionCommand {
  factionId: FactionId;
  directive: FactionDirective;
  targetNodes: number[];
  priority: number;
  timestamp: number;
  expiresAt: number;
}

// ----------------------------------------------------------------------------
// TERRITORY TYPES
// ----------------------------------------------------------------------------

export type NodeState = 0 | 1 | 2 | 3; // NEUTRAL | CONTESTED | CONTROLLED | FORTIFIED

export interface TerritoryNode {
  index: number; // 0-399
  x: number; // Grid X (0-19)
  y: number; // Grid Y (0-19)
  worldX: number; // World X coordinate
  worldY: number; // World Y coordinate

  // Control state
  state: NodeState;
  controllingFaction: FactionId | null;
  controlStrength: number; // 0-1

  // Faction influence
  factionInfluence: number[]; // Influence per faction (6 values)

  // Properties
  dangerLevel: number;
  resourceValue: number;
  strategicValue: number;

  // History
  lastCaptureTime: number;
  captureCount: number;
  contestedDuration: number;
}

export interface TerritoryGrid {
  nodes: TerritoryNode[]; // 400 nodes
  gridSize: number; // 20
  mapSize: number; // 1500
  nodeSize: number; // 75

  // Summary
  neutralCount: number;
  contestedCount: number;
  controlledCount: number;
  fortifiedCount: number;

  // Faction territories
  factionTerritories: Map<FactionId, number[]>;

  // Last update
  lastUpdateTime: number;
  tickCount: bigint;
}

export interface TerritoryTransition {
  nodeIndex: number;
  fromState: NodeState;
  toState: NodeState;
  fromFaction: FactionId | null;
  toFaction: FactionId | null;
  timestamp: number;
  cause: "CAPTURE" | "CONTEST" | "ABANDON" | "FORTIFY";
}

// ----------------------------------------------------------------------------
// SQUAD TYPES
// ----------------------------------------------------------------------------

export interface Squad {
  id: string;
  factionId: FactionId;

  // Members
  entityIds: string[];
  memberCount: number;
  maxSize: number;

  // Position
  position: { x: number; y: number; z: number };
  targetPosition: { x: number; y: number; z: number } | null;
  currentNode: number;

  // State
  urgency: number;
  confidence: number;
  cohesion: number;
  fatigue: number;
  stress: number;

  // Combat
  inCombat: boolean;
  combatTarget: string | null;
  lastCombatTime: number;

  // Orders
  currentOrder: SquadOrder | null;
  orderQueue: SquadOrder[];

  // History
  formationTime: number;
  disbandTime: number | null;
  killCount: number;
  deathCount: number;
}

export type SquadOrderType =
  | "MOVE"
  | "ATTACK"
  | "DEFEND"
  | "PATROL"
  | "RETREAT"
  | "REINFORCE"
  | "CAPTURE";

export interface SquadOrder {
  type: SquadOrderType;
  targetPosition?: { x: number; y: number; z: number };
  targetEntity?: string;
  targetNode?: number;
  priority: number;
  issuedAt: number;
  expiresAt: number;
}

// ----------------------------------------------------------------------------
// ORGANISM SYNC TYPES
// ----------------------------------------------------------------------------

export interface OrganismPulse {
  heartbeat: bigint;
  arousal: number;
  coherence: number;
  drift: number;
  emergence: number;
  timestamp: number;
}

export interface BackendState {
  pulse: OrganismPulse;
  worldState: WorldState | null;
  factionStates: FactionState[];
  entityFeed: EntityFeedEntry[];
  formaLedger: FormaLedger | null;
  lastSyncTime: number;
  syncCount: number;
}

export interface WorldState {
  biomes: BiomeState[];
  globalCoherence: number;
  globalDrift: number;
  globalEmergence: number;
  activeEvents: WorldEvent[];
  timestamp: number;
}

export interface BiomeState {
  id: number;
  name: string;
  coherence: number;
  controllingFaction: FactionId | null;
  resources: number;
  danger: number;
}

export interface WorldEvent {
  id: string;
  type: string;
  location: { x: number; y: number };
  severity: number;
  startTime: number;
  duration: number;
}

export interface EntityFeedEntry {
  entityId: string;
  factionId: FactionId;
  position: { x: number; y: number; z: number };
  urgency: number;
  health: number;
  state: string;
}

export interface FormaLedger {
  mintRate: number;
  reserve: bigint;
  totalSupply: bigint;
  playerBalance: bigint;
  lastMintTime: number;
}

// ----------------------------------------------------------------------------
// FRONTEND STATE TYPES
// ----------------------------------------------------------------------------

export interface FrontendOrganismState {
  // Identity
  sessionId: string;
  startTime: number;

  // Entities
  entities: Map<string, EntityBrain>;
  entityCount: number;

  // Squads
  squads: Map<string, Squad>;
  squadCount: number;

  // Factions
  factions: FactionState[];

  // Territory
  territory: TerritoryGrid;

  // Backend sync
  backendState: BackendState | null;
  lastBackendSync: number;
  syncStatus: "disconnected" | "syncing" | "synced" | "error";

  // Performance
  fps: number;
  frameTime: number;
  tickCount: bigint;

  // Learning
  totalLearningEvents: bigint;
  avgPredictionError: number;
  totalWeightUpdates: bigint;
}

export interface OrganismMetrics {
  // Brain metrics
  avgRegionActivation: number[]; // Per region
  avgWeightMagnitude: number;
  weightUpdateRate: number; // Updates per second
  predictionErrorRate: number;

  // Drive metrics
  dominantDrive: DriveName;
  driveDistribution: number[];
  driveCompetitionRate: number;

  // Territory metrics
  territoryStability: number;
  avgContestDuration: number;
  captureRate: number;

  // Faction metrics
  factionBalance: number; // Gini coefficient
  activeConflicts: number;
  allianceCount: number;

  // Performance metrics
  avgFps: number;
  avgFrameTime: number;
  memoryUsage: number;
}

// ----------------------------------------------------------------------------
// LIFECYCLE TYPES
// ----------------------------------------------------------------------------

export interface OrganismBirthEvent {
  sessionId: string;
  timestamp: number;
  loadedWeights: boolean;
  weightCount: number;
  backendConnected: boolean;
  initialPulse: OrganismPulse | null;
}

export interface OrganismDeathEvent {
  sessionId: string;
  timestamp: number;
  duration: number;
  savedWeights: boolean;
  finalTickCount: bigint;
  totalLearningEvents: bigint;
  cause: "TAB_CLOSE" | "TIMEOUT" | "ERROR" | "USER_EXIT";
}

export interface OrganismResurrectionEvent {
  sessionId: string;
  previousSessionId: string | null;
  timestamp: number;
  loadedWeights: number;
  inheritedLearning: bigint;
  timeSinceLastSession: number;
}

// ----------------------------------------------------------------------------
// QUANTUM MEMORY TYPES
// ----------------------------------------------------------------------------

export type QuantumMemoryLayer = "GAMMA" | "DELTA" | "THETA";

export interface QuantumMemoryConfig {
  layer: QuantumMemoryLayer;
  name: string;
  frequencyRange: { min: number; max: number };
  persistence: boolean;
  location: string;
}

export interface QuantumMemoryState {
  // Gamma layer (working memory)
  gamma: {
    activeInferences: number;
    liveAlerts: number;
    agentBindings: number;
  };

  // Delta layer (deep memory)
  delta: {
    stableVarCount: number;
    hashMapEntries: number;
    totalPersisted: bigint;
  };

  // Theta layer (resonance memory)
  theta: {
    crossCanisterCalls: number;
    sharedStateSize: number;
    resonanceProfile: ResonanceProfile;
  };
}

export interface ResonanceProfile {
  responseSpeed: number[]; // Rolling average of response times
  activeTimeDistribution: number[]; // 24 hourly buckets
  questionTypeDistribution: Map<string, number>;
  outputTune: {
    verbosity: number;
    technicality: number;
    formality: number;
  };
}

// ----------------------------------------------------------------------------
// COUPLING TYPES
// ----------------------------------------------------------------------------

export interface FrequencyCoupling {
  fromLayer: QuantumMemoryLayer;
  toLayer: QuantumMemoryLayer;
  couplingStrength: number;
  direction: "UP" | "DOWN" | "BIDIRECTIONAL";
  mechanism: string;
}

export interface CouplingEvent {
  timestamp: number;
  fromLayer: QuantumMemoryLayer;
  toLayer: QuantumMemoryLayer;
  trigger: string;
  dataTransferred: number;
  success: boolean;
}

// ----------------------------------------------------------------------------
// INTELLIGENCE SCALING TYPES
// ----------------------------------------------------------------------------

export type IntelligenceStage = "STAGE_1" | "STAGE_2" | "STAGE_3" | "STAGE_4";

export interface IntelligenceMetrics {
  backendDepth: number; // Lines of cognitive code
  frontendSpeed: number; // Weight ops per second
  bridgeQuality: number; // 0-1 quality score
  systemIntelligence: number; // Composite score
  currentStage: IntelligenceStage;
}

export interface BackendTier {
  name: string;
  lines: number;
  capabilities: string[];
  description: string;
}

// ----------------------------------------------------------------------------
// EVENT TYPES
// ----------------------------------------------------------------------------

export interface OrganismEvent {
  id: string;
  type: OrganismEventType;
  timestamp: number;
  data: Record<string, unknown>;
  source: "FRONTEND" | "BACKEND" | "BRIDGE";
}

export type OrganismEventType =
  | "BIRTH"
  | "DEATH"
  | "RESURRECTION"
  | "SYNC"
  | "LEARNING"
  | "PREDICTION_ERROR"
  | "DRIVE_CHANGE"
  | "TERRITORY_CAPTURE"
  | "FACTION_COMMAND"
  | "ENTITY_SPAWN"
  | "ENTITY_DEATH"
  | "SQUAD_FORM"
  | "SQUAD_DISBAND"
  | "COMBAT_START"
  | "COMBAT_END"
  | "WEIGHT_SAVE"
  | "WEIGHT_LOAD";

// ----------------------------------------------------------------------------
// CONFIGURATION TYPES
// ----------------------------------------------------------------------------

export interface OrganismConfig {
  // Brain config
  brainConfig: {
    learningRate: number;
    decayRate: number;
    predictionErrorThreshold: number;
    predictionErrorBoost: number;
  };

  // Territory config
  territoryConfig: {
    gridSize: number;
    controlThreshold: number;
    expansionRate: number;
    dangerDecay: number;
  };

  // Faction config
  factionConfig: {
    commandWaveInterval: number;
    minSquadsPerFaction: number;
    trustUpdateRate: number;
  };

  // Sync config
  syncConfig: {
    pollInterval: number;
    maxRetries: number;
    timeout: number;
  };

  // Performance config
  performanceConfig: {
    targetFps: number;
    maxEntities: number;
    weightSaveInterval: number;
  };
}

// ----------------------------------------------------------------------------
// UTILITY TYPES
// ----------------------------------------------------------------------------

export type Vector3 = { x: number; y: number; z: number };
export type Vector2 = { x: number; y: number };

export interface BoundingBox {
  min: Vector3;
  max: Vector3;
}

export interface TimeRange {
  start: number;
  end: number;
}

export interface Snapshot<T> {
  data: T;
  timestamp: number;
  version: number;
}

export interface Delta<T> {
  before: T;
  after: T;
  timestamp: number;
  cause: string;
}

// ----------------------------------------------------------------------------
// TYPE GUARDS
// ----------------------------------------------------------------------------

export function isBrainRegionId(value: number): value is BrainRegionId {
  return value >= 0 && value <= 6 && Number.isInteger(value);
}

export function isDriveId(value: number): value is DriveId {
  return value >= 0 && value <= 4 && Number.isInteger(value);
}

export function isFactionId(value: number): value is FactionId {
  return value >= 0 && value <= 5 && Number.isInteger(value);
}

export function isNodeState(value: number): value is NodeState {
  return value >= 0 && value <= 3 && Number.isInteger(value);
}

// ----------------------------------------------------------------------------
// FACTORY FUNCTIONS
// ----------------------------------------------------------------------------

export function createDefaultBrainRegionState(
  id: BrainRegionId,
): BrainRegionState {
  return {
    id,
    activation: 0.5,
    previousActivation: 0.5,
    input: 0,
    output: 0,
    lastUpdateTime: Date.now(),
  };
}

export function createDefaultDriveState(
  id: DriveId,
  name: DriveName,
): DriveState {
  return {
    id,
    name,
    intensity: 0.5,
    satisfaction: 0.5,
    deprivation: 0,
    lastSatisfiedTime: Date.now(),
    isActive: false,
    priority: 0,
  };
}

export function createDefaultPredictionState(): PredictionState {
  return {
    expectedState: new Array(7).fill(0.5),
    actualState: new Array(7).fill(0.5),
    error: 0,
    errorHistory: [],
    learningBoost: 1,
    surpriseLevel: 0,
    lastPredictionTime: Date.now(),
  };
}

export function createDefaultHebbianWeightMatrix(): HebbianWeightMatrix {
  return {
    weights: new Float32Array(42).fill(0.5),
    lastUpdate: Date.now(),
    totalUpdates: BigInt(0),
    learningEvents: 0,
  };
}

export function createDefaultTerritoryNode(index: number): TerritoryNode {
  const gridSize = 20;
  const nodeSize = 75;
  const x = index % gridSize;
  const y = Math.floor(index / gridSize);

  return {
    index,
    x,
    y,
    worldX: x * nodeSize + nodeSize / 2,
    worldY: y * nodeSize + nodeSize / 2,
    state: 0,
    controllingFaction: null,
    controlStrength: 0,
    factionInfluence: new Array(6).fill(0),
    dangerLevel: 0,
    resourceValue: 0.5 + Math.random() * 0.5,
    strategicValue: 0.5,
    lastCaptureTime: 0,
    captureCount: 0,
    contestedDuration: 0,
  };
}

// Note: All types are already exported at their definitions above.
// No additional re-export block needed.
