/**
 * BRIDGE SYNCHRONIZATION SYSTEM
 *
 * MEDINA'S MIRROR LAW IMPLEMENTATION:
 *
 * Backend (Male) → sync every 10s → Frontend (Female) seeds
 * Frontend (Female) → on session end → Backend (Male) learns
 *
 * The bridge connects the two organisms.
 * Neither is complete without the other.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// SYNC TYPES
// ============================================================================

export const SYNC_TYPES = {
  /** Backend → Frontend: Seed the frontend with backend state */
  BACKEND_TO_FRONTEND: "backend_to_frontend",

  /** Frontend → Backend: Teach the backend from session */
  FRONTEND_TO_BACKEND: "frontend_to_backend",

  /** Bidirectional: Full sync in both directions */
  BIDIRECTIONAL: "bidirectional",

  /** Heartbeat: Minimal sync to confirm connection */
  HEARTBEAT: "heartbeat",

  /** Emergency: Force sync on critical state change */
  EMERGENCY: "emergency",
} as const;

export type SyncType = (typeof SYNC_TYPES)[keyof typeof SYNC_TYPES];

// ============================================================================
// SYNC INTERVALS (milliseconds)
// ============================================================================

export const SYNC_INTERVALS = {
  /** State sync interval */
  STATE_SYNC: 10000, // 10 seconds

  /** Coherence sync interval */
  COHERENCE_SYNC: 5000, // 5 seconds

  /** Chemical sync interval */
  CHEMICAL_SYNC: 10000, // 10 seconds

  /** Clock sync interval */
  CLOCK_SYNC: 60000, // 60 seconds

  /** Market sync interval */
  MARKET_SYNC: 60000, // 60 seconds

  /** Heartbeat interval */
  HEARTBEAT: 30000, // 30 seconds

  /** Emergency sync (immediate) */
  EMERGENCY: 0,
} as const;

// ============================================================================
// SYNC PAYLOADS
// ============================================================================

/** Brain state sync from backend */
export interface BrainSyncPayload {
  type: "brain";
  timestamp: number;
  beat: number;

  /** Kuramoto oscillator phases (64) */
  phases: number[];

  /** Order parameter */
  orderParameter: number;

  /** Mean phase */
  meanPhase: number;

  /** Hebbian weight matrix (64×64 flattened) */
  hebbianWeights: number[];

  /** Genesis lock values */
  genesisLock: {
    rGenesis: number;
    thetaGenesis: number[];
    isLocked: boolean;
  };

  /** Jasmine Law state */
  jasmineLaw: {
    lyapunovV: number;
    dVdt: number;
    isStable: boolean;
  };
}

/** World state sync from backend */
export interface WorldSyncPayload {
  type: "world";
  timestamp: number;
  beat: number;

  /** Biome states (36) */
  biomes: Array<{
    biome: number;
    owner: number;
    coherence: number;
    status: string;
  }>;

  /** Faction territory percentages */
  territoryControl: Record<number, number>;

  /** Active world drive */
  dominantDrive: number;

  /** Drive strengths */
  driveStrengths: Record<number, number>;

  /** Global coherence */
  globalCoherence: number;

  /** Day/night phase */
  dayNightPhase: number;
}

/** Chemistry state sync from backend */
export interface ChemistrySyncPayload {
  type: "chemistry";
  timestamp: number;
  beat: number;

  /** Chemical concentrations (21) */
  concentrations: number[];

  /** Chemical velocities (rate of change) */
  velocities: number[];

  /** Dominant chemical */
  dominantChemical: number;

  /** Overall arousal */
  arousal: number;

  /** Circadian phase */
  circadianPhase: number;
}

/** Clock sync from CHRONOS */
export interface ClockSyncPayload {
  type: "clock";
  timestamp: number;

  /** Current beat (sovereign truth) */
  currentBeat: number;

  /** Day/night cycle phase */
  cyclePhase: number;

  /** Day/night cycle progress (0-1) */
  cycleProgress: number;

  /** Beats per second (backend rate) */
  beatsPerSecond: number;

  /** Is heartbeat active? */
  heartbeatActive: boolean;
}

/** Market sync from ORACLE */
export interface MarketSyncPayload {
  type: "market";
  timestamp: number;

  /** Asset prices */
  prices: Record<string, number>;

  /** 24h changes */
  changes: Record<string, number>;

  /** Market regime */
  regime: "bullish" | "neutral" | "bearish";

  /** Quantum threat index */
  quantumThreatIndex: number;
}

/** Memory sync to backend (session end) */
export interface MemorySyncPayload {
  type: "memory";
  timestamp: number;
  sessionId: string;

  /** Novel patterns discovered */
  patterns: Array<{
    id: string;
    signature: number[];
    strength: number;
    context: Record<string, number>;
  }>;

  /** Average weights across entities */
  averageWeights: number[];

  /** Total Hebbian updates */
  hebbianUpdates: number;

  /** Prediction error history */
  predictionErrors: number[];

  /** Session duration (ticks) */
  sessionDuration: number;

  /** Entity count */
  entityCount: number;
}

/** Economy sync from STEWARD */
export interface EconomySyncPayload {
  type: "economy";
  timestamp: number;
  beat: number;

  /** FORMA balance */
  formaBalance: number;

  /** Session earnings */
  sessionEarnings: number;

  /** Current mint rate */
  mintRate: number;

  /** OMNIS multiplier active */
  omnisMultiplierActive: boolean;

  /** Architect reserve balance */
  architectReserve: number;
}

// ============================================================================
// SYNC STATE
// ============================================================================

export interface BridgeSyncState {
  /** Is bridge connected? */
  isConnected: boolean;

  /** Last sync timestamps per type */
  lastSyncTimestamps: {
    brain: number;
    world: number;
    chemistry: number;
    clock: number;
    market: number;
    economy: number;
  };

  /** Pending payloads to send to backend */
  pendingPayloads: Array<{
    type: string;
    payload: unknown;
    priority: number;
    timestamp: number;
  }>;

  /** Sync statistics */
  stats: {
    totalSyncs: number;
    successfulSyncs: number;
    failedSyncs: number;
    averageLatency: number;
    lastError: string | null;
  };

  /** Connection quality (0-1) */
  connectionQuality: number;

  /** Is session active? */
  sessionActive: boolean;

  /** Session start timestamp */
  sessionStartTimestamp: number;

  /** Backend canister IDs */
  canisterIds: {
    main: string;
    chronos: string;
    oracle: string;
    steward: string;
    herald: string;
  };
}

// ============================================================================
// SYNC QUEUE
// ============================================================================

export interface SyncQueueItem {
  id: string;
  type: SyncType;
  payload: unknown;
  priority: number;
  timestamp: number;
  retryCount: number;
  maxRetries: number;
  timeout: number;
}

export interface SyncQueue {
  items: SyncQueueItem[];
  isProcessing: boolean;
  lastProcessTimestamp: number;

  /** Add item to queue */
  add: (item: Omit<SyncQueueItem, "id" | "timestamp" | "retryCount">) => void;

  /** Process next item */
  processNext: () => Promise<boolean>;

  /** Clear queue */
  clear: () => void;
}

// ============================================================================
// BRIDGE EVENTS
// ============================================================================

export const BRIDGE_EVENTS = {
  CONNECTED: "bridge:connected",
  DISCONNECTED: "bridge:disconnected",
  SYNC_START: "bridge:sync_start",
  SYNC_COMPLETE: "bridge:sync_complete",
  SYNC_ERROR: "bridge:sync_error",
  SESSION_START: "bridge:session_start",
  SESSION_END: "bridge:session_end",
  HEARTBEAT: "bridge:heartbeat",
  STATE_UPDATED: "bridge:state_updated",
} as const;

export type BridgeEvent = (typeof BRIDGE_EVENTS)[keyof typeof BRIDGE_EVENTS];

// ============================================================================
// BRIDGE CONFIGURATION
// ============================================================================

export interface BridgeConfig {
  /** Enable automatic syncing */
  autoSync: boolean;

  /** Sync intervals (can override defaults) */
  intervals: Partial<typeof SYNC_INTERVALS>;

  /** Maximum retry count */
  maxRetries: number;

  /** Retry delay (ms) */
  retryDelay: number;

  /** Timeout for sync operations (ms) */
  timeout: number;

  /** Enable compression */
  compression: boolean;

  /** Enable delta sync (only changed values) */
  deltaSync: boolean;

  /** Debug logging */
  debug: boolean;
}

export const DEFAULT_BRIDGE_CONFIG: BridgeConfig = {
  autoSync: true,
  intervals: {},
  maxRetries: 3,
  retryDelay: 1000,
  timeout: 30000,
  compression: true,
  deltaSync: true,
  debug: false,
};

// ============================================================================
// BRIDGE METRICS
// ============================================================================

export const BRIDGE_METRICS = {
  SYNC_TYPES: 5,
  SYNC_INTERVALS: 7,
  PAYLOAD_TYPES: 7,
  STATE_FIELDS: 12,
  QUEUE_ITEM_FIELDS: 7,
  CONFIG_FIELDS: 9,
  EVENTS: 9,
} as const;
