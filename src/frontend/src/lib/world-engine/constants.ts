/**
 * WORLD ENGINE - FRONTEND VERSION (FEMALE)
 *
 * MEDINA'S MIRROR LAW:
 * Backend (Male): 36 biome states, 4 faction territories - THE AUTHORITY
 * Frontend (Female): 20×20 territory grid, smooth real-time expression
 *
 * The frontend doesn't compute the canonical world.
 * It DISPLAYS what the backend decides.
 * Between syncs, it interpolates smoothly.
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 */

// ============================================================================
// BIOME SYSTEM (36 BIOMES)
// ============================================================================

export const BIOME_IDS = {
  // TERRESTRIAL (12)
  ANCIENT_FOREST: 0,
  VOLCANIC_PLAINS: 1,
  CRYSTAL_CAVERNS: 2,
  FROZEN_TUNDRA: 3,
  SCORCHED_DESERT: 4,
  TWILIGHT_MARSH: 5,
  MOUNTAIN_PEAKS: 6,
  VERDANT_VALLEY: 7,
  SHADOW_JUNGLE: 8,
  GOLDEN_SAVANNA: 9,
  OBSIDIAN_WASTES: 10,
  EDEN_GARDEN: 11,

  // AQUATIC (8)
  DEEP_OCEAN: 12,
  CORAL_REEF: 13,
  ABYSSAL_TRENCH: 14,
  THERMAL_VENTS: 15,
  KELP_FOREST: 16,
  FROZEN_SEA: 17,
  BIOLUMINESCENT_DEPTHS: 18,
  TIDAL_FLATS: 19,

  // ATMOSPHERIC (8)
  STORM_LAYER: 20,
  CLOUD_KINGDOM: 21,
  AURORA_ZONE: 22,
  LIGHTNING_FIELD: 23,
  WIND_CURRENTS: 24,
  SOLAR_HEIGHTS: 25,
  VOID_BOUNDARY: 26,
  ETHER_REALM: 27,

  // SYNTHETIC (8)
  MACHINE_CORE: 28,
  DATA_STREAMS: 29,
  QUANTUM_LATTICE: 30,
  NEURAL_NETWORK: 31,
  MEMORY_PALACE: 32,
  LOGIC_GATES: 33,
  RESONANCE_CHAMBER: 34,
  GENESIS_POINT: 35,
} as const;

export type BiomeId = (typeof BIOME_IDS)[keyof typeof BIOME_IDS];
export const BIOME_COUNT = 36;

export const BIOME_NAMES: Record<BiomeId, string> = {
  [BIOME_IDS.ANCIENT_FOREST]: "Ancient Forest",
  [BIOME_IDS.VOLCANIC_PLAINS]: "Volcanic Plains",
  [BIOME_IDS.CRYSTAL_CAVERNS]: "Crystal Caverns",
  [BIOME_IDS.FROZEN_TUNDRA]: "Frozen Tundra",
  [BIOME_IDS.SCORCHED_DESERT]: "Scorched Desert",
  [BIOME_IDS.TWILIGHT_MARSH]: "Twilight Marsh",
  [BIOME_IDS.MOUNTAIN_PEAKS]: "Mountain Peaks",
  [BIOME_IDS.VERDANT_VALLEY]: "Verdant Valley",
  [BIOME_IDS.SHADOW_JUNGLE]: "Shadow Jungle",
  [BIOME_IDS.GOLDEN_SAVANNA]: "Golden Savanna",
  [BIOME_IDS.OBSIDIAN_WASTES]: "Obsidian Wastes",
  [BIOME_IDS.EDEN_GARDEN]: "Eden Garden",
  [BIOME_IDS.DEEP_OCEAN]: "Deep Ocean",
  [BIOME_IDS.CORAL_REEF]: "Coral Reef",
  [BIOME_IDS.ABYSSAL_TRENCH]: "Abyssal Trench",
  [BIOME_IDS.THERMAL_VENTS]: "Thermal Vents",
  [BIOME_IDS.KELP_FOREST]: "Kelp Forest",
  [BIOME_IDS.FROZEN_SEA]: "Frozen Sea",
  [BIOME_IDS.BIOLUMINESCENT_DEPTHS]: "Bioluminescent Depths",
  [BIOME_IDS.TIDAL_FLATS]: "Tidal Flats",
  [BIOME_IDS.STORM_LAYER]: "Storm Layer",
  [BIOME_IDS.CLOUD_KINGDOM]: "Cloud Kingdom",
  [BIOME_IDS.AURORA_ZONE]: "Aurora Zone",
  [BIOME_IDS.LIGHTNING_FIELD]: "Lightning Field",
  [BIOME_IDS.WIND_CURRENTS]: "Wind Currents",
  [BIOME_IDS.SOLAR_HEIGHTS]: "Solar Heights",
  [BIOME_IDS.VOID_BOUNDARY]: "Void Boundary",
  [BIOME_IDS.ETHER_REALM]: "Ether Realm",
  [BIOME_IDS.MACHINE_CORE]: "Machine Core",
  [BIOME_IDS.DATA_STREAMS]: "Data Streams",
  [BIOME_IDS.QUANTUM_LATTICE]: "Quantum Lattice",
  [BIOME_IDS.NEURAL_NETWORK]: "Neural Network",
  [BIOME_IDS.MEMORY_PALACE]: "Memory Palace",
  [BIOME_IDS.LOGIC_GATES]: "Logic Gates",
  [BIOME_IDS.RESONANCE_CHAMBER]: "Resonance Chamber",
  [BIOME_IDS.GENESIS_POINT]: "Genesis Point",
};

// ============================================================================
// FACTION SYSTEM (4 PRIMARY FACTIONS)
// ============================================================================

export const FACTION_IDS = {
  GAIA: 0, // Nature, growth, life
  ARES: 1, // War, destruction, chaos
  VULCAN: 2, // Industry, building, creation
  SENTINEL: 3, // Protection, order, stability
} as const;

export type FactionId = (typeof FACTION_IDS)[keyof typeof FACTION_IDS];
export const FACTION_COUNT = 4;

export const FACTION_NAMES: Record<FactionId, string> = {
  [FACTION_IDS.GAIA]: "Gaia",
  [FACTION_IDS.ARES]: "Ares",
  [FACTION_IDS.VULCAN]: "Vulcan",
  [FACTION_IDS.SENTINEL]: "Sentinel",
};

export const FACTION_COLORS: Record<FactionId, string> = {
  [FACTION_IDS.GAIA]: "#4CAF50", // Green - nature
  [FACTION_IDS.ARES]: "#F44336", // Red - war
  [FACTION_IDS.VULCAN]: "#FF9800", // Orange - industry
  [FACTION_IDS.SENTINEL]: "#2196F3", // Blue - protection
};

export const FACTION_DESCRIPTIONS: Record<FactionId, string> = {
  [FACTION_IDS.GAIA]:
    "The force of nature, growth, and regeneration. Seeks to expand life and restore balance.",
  [FACTION_IDS.ARES]:
    "The force of war, destruction, and chaos. Seeks to dominate through conflict.",
  [FACTION_IDS.VULCAN]:
    "The force of industry, creation, and progress. Seeks to build and transform.",
  [FACTION_IDS.SENTINEL]:
    "The force of protection, order, and stability. Seeks to defend and maintain.",
};

// ============================================================================
// WORLD DRIVES (5 PRIMARY DRIVES)
// ============================================================================

export const WORLD_DRIVES = {
  GAIA_DRIVE: 0, // Growth, expansion, life
  ARES_DRIVE: 1, // Destruction, conflict, entropy
  VULCAN_DRIVE: 2, // Building, creation, progress
  SENTINEL_DRIVE: 3, // Protection, stability, defense
  RESONANCE_DRIVE: 4, // Synchronization, harmony, coherence
} as const;

export type WorldDrive = (typeof WORLD_DRIVES)[keyof typeof WORLD_DRIVES];
export const WORLD_DRIVE_COUNT = 5;

export const WORLD_DRIVE_NAMES: Record<WorldDrive, string> = {
  [WORLD_DRIVES.GAIA_DRIVE]: "Gaia Drive",
  [WORLD_DRIVES.ARES_DRIVE]: "Ares Drive",
  [WORLD_DRIVES.VULCAN_DRIVE]: "Vulcan Drive",
  [WORLD_DRIVES.SENTINEL_DRIVE]: "Sentinel Drive",
  [WORLD_DRIVES.RESONANCE_DRIVE]: "Resonance Drive",
};

// ============================================================================
// BIOME STATUS
// ============================================================================

export const BIOME_STATUS = {
  ACTIVE: 0, // Fully functional
  CONTESTED: 1, // Under faction conflict
  COLLAPSED: 2, // Temporarily non-functional
  DORMANT: 3, // Inactive but recoverable
  AWAKENING: 4, // Transitioning to active
  CORRUPTED: 5, // Damaged, needs healing
} as const;

export type BiomeStatus = (typeof BIOME_STATUS)[keyof typeof BIOME_STATUS];

// ============================================================================
// BIOME STATE
// ============================================================================

export interface BiomeState {
  id: BiomeId;
  name: string;
  status: BiomeStatus;

  /** Owning faction (null if contested or neutral) */
  owner: FactionId | null;

  /** Control percentage by each faction */
  factionControl: Record<FactionId, number>;

  /** Biome coherence (0-1) */
  coherence: number;

  /** Biome arousal (0-1) */
  arousal: number;

  /** Active world drive */
  activeDrive: WorldDrive;

  /** Drive intensity (0-1) */
  driveIntensity: number;

  /** Resources available */
  resources: number;

  /** Entity count in biome */
  entityCount: number;

  /** Last update beat (from backend) */
  lastBackendBeat: number;

  /** Last frontend tick */
  lastFrontendTick: number;
}

// ============================================================================
// FACTION STATE
// ============================================================================

export interface FactionState {
  id: FactionId;
  name: string;

  /** Territory percentage (0-1) */
  territoryPercentage: number;

  /** Number of biomes controlled */
  biomesControlled: number;

  /** Trust matrix toward other factions (-1 to 1) */
  trustMatrix: Record<FactionId, number>;

  /** Doctrine state */
  doctrine: FactionDoctrine;

  /** Active drive intensity */
  driveIntensity: number;

  /** Total entity count */
  entityCount: number;

  /** Resource stockpile */
  resources: number;

  /** War state with other factions */
  warState: Record<FactionId, WarState>;
}

export interface FactionDoctrine {
  aggression: number; // 0-1, tendency to attack
  expansion: number; // 0-1, tendency to expand
  defense: number; // 0-1, tendency to defend
  cooperation: number; // 0-1, tendency to cooperate
  sacrifice: number; // 0-1, willingness to sacrifice
}

export type WarState = "peace" | "tension" | "skirmish" | "war" | "total_war";

// ============================================================================
// TERRITORY GRID (20×20 = 400 NODES)
// ============================================================================

export const TERRITORY_GRID_SIZE = 20;
export const TERRITORY_NODE_COUNT = TERRITORY_GRID_SIZE * TERRITORY_GRID_SIZE; // 400

export interface TerritoryNode {
  x: number;
  y: number;
  index: number;

  /** Owning faction */
  owner: FactionId | null;

  /** Control strength (0-1) */
  controlStrength: number;

  /** Biome this node belongs to */
  biomeId: BiomeId;

  /** Danger level (0-1) */
  dangerLevel: number;

  /** Resource value (0-1) */
  resourceValue: number;

  /** Strategic importance (0-1) */
  strategicValue: number;

  /** Entity density */
  entityDensity: number;

  /** Coherence (local) */
  coherence: number;

  /** Last contested tick */
  lastContestedTick: number;
}

export interface TerritoryGrid {
  nodes: TerritoryNode[][];
  size: number;

  /** Total nodes per faction */
  factionCounts: Record<FactionId, number>;

  /** Contested node count */
  contestedCount: number;

  /** Neutral node count */
  neutralCount: number;

  /** Global coherence */
  globalCoherence: number;

  /** Global danger */
  globalDanger: number;
}

// ============================================================================
// WORLD STATE (COMPLETE)
// ============================================================================

export interface WorldState {
  /** All 36 biome states */
  biomes: Record<BiomeId, BiomeState>;

  /** All 4 faction states */
  factions: Record<FactionId, FactionState>;

  /** 20×20 territory grid */
  territoryGrid: TerritoryGrid;

  /** Global world drives */
  worldDrives: Record<WorldDrive, number>;

  /** Global coherence */
  globalCoherence: number;

  /** Global arousal */
  globalArousal: number;

  /** Global drift */
  globalDrift: number;

  /** Global emergence */
  globalEmergence: number;

  /** Current dominant faction */
  dominantFaction: FactionId | null;

  /** Current dominant drive */
  dominantDrive: WorldDrive;

  /** Backend heartbeat number */
  backendHeartbeat: number;

  /** Frontend tick number */
  frontendTick: number;

  /** Last sync timestamp */
  lastSyncTimestamp: number;

  /** Sync quality (0-1) */
  syncQuality: number;
}

// ============================================================================
// FIBONACCI BUILD ENGINE
// ============================================================================

export const FIBONACCI_SEQUENCE = [
  1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987,
];

export interface FibonacciBuildState {
  /** Current Fibonacci index */
  currentIndex: number;

  /** Accumulated build points */
  buildPoints: number;

  /** Build rate per beat */
  buildRate: number;

  /** Active build projects */
  activeProjects: BuildProject[];

  /** Completed projects */
  completedProjects: number;
}

export interface BuildProject {
  id: string;
  biomeId: BiomeId;
  factionId: FactionId;
  requiredPoints: number;
  currentPoints: number;
  progress: number; // 0-1
  startBeat: number;
  estimatedCompletionBeat: number;
}

// ============================================================================
// WORLD ENGINE EVENTS
// ============================================================================

export type WorldEventType =
  | "biome_captured"
  | "biome_collapsed"
  | "biome_awakened"
  | "faction_war_declared"
  | "faction_peace_achieved"
  | "territory_contested"
  | "territory_secured"
  | "drive_shift"
  | "emergence_spike"
  | "coherence_threshold"
  | "sacrifice_occurred"
  | "omnis_candidate"
  | "sync_completed";

export interface WorldEvent {
  type: WorldEventType;
  timestamp: number;
  backendBeat: number;
  frontendTick: number;

  /** Event-specific data */
  data: Record<string, unknown>;

  /** Affected biome(s) */
  biomes?: BiomeId[];

  /** Affected faction(s) */
  factions?: FactionId[];

  /** Event magnitude (0-1) */
  magnitude: number;

  /** Is this from backend (canonical) or frontend (local)? */
  source: "backend" | "frontend";
}

// ============================================================================
// WORLD ENGINE CONFIGURATION
// ============================================================================

export interface WorldEngineConfig {
  /** Enable biome simulation */
  enableBiomes: boolean;

  /** Enable faction simulation */
  enableFactions: boolean;

  /** Enable territory grid */
  enableTerritoryGrid: boolean;

  /** Enable Fibonacci build engine */
  enableBuildEngine: boolean;

  /** Backend sync interval (frontend ticks) */
  backendSyncInterval: number;

  /** Local interpolation enabled */
  enableInterpolation: boolean;

  /** Interpolation smoothness (0-1) */
  interpolationSmoothness: number;

  /** Event history size */
  eventHistorySize: number;

  /** Danger decay rate per tick */
  dangerDecayRate: number;

  /** Coherence recovery rate per tick */
  coherenceRecoveryRate: number;
}

export const DEFAULT_WORLD_ENGINE_CONFIG: WorldEngineConfig = {
  enableBiomes: true,
  enableFactions: true,
  enableTerritoryGrid: true,
  enableBuildEngine: true,
  backendSyncInterval: 300, // Every 5 seconds at 60 FPS
  enableInterpolation: true,
  interpolationSmoothness: 0.1,
  eventHistorySize: 1000,
  dangerDecayRate: 0.001,
  coherenceRecoveryRate: 0.0005,
};

// ============================================================================
// BIOME-FACTION AFFINITY MATRIX
// How well each faction operates in each biome type
// ============================================================================

export const BIOME_FACTION_AFFINITY: Record<
  BiomeId,
  Record<FactionId, number>
> = {
  // TERRESTRIAL
  [BIOME_IDS.ANCIENT_FOREST]: {
    [FACTION_IDS.GAIA]: 0.9,
    [FACTION_IDS.ARES]: 0.3,
    [FACTION_IDS.VULCAN]: 0.4,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.VOLCANIC_PLAINS]: {
    [FACTION_IDS.GAIA]: 0.3,
    [FACTION_IDS.ARES]: 0.8,
    [FACTION_IDS.VULCAN]: 0.9,
    [FACTION_IDS.SENTINEL]: 0.4,
  },
  [BIOME_IDS.CRYSTAL_CAVERNS]: {
    [FACTION_IDS.GAIA]: 0.5,
    [FACTION_IDS.ARES]: 0.4,
    [FACTION_IDS.VULCAN]: 0.8,
    [FACTION_IDS.SENTINEL]: 0.7,
  },
  [BIOME_IDS.FROZEN_TUNDRA]: {
    [FACTION_IDS.GAIA]: 0.4,
    [FACTION_IDS.ARES]: 0.6,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.8,
  },
  [BIOME_IDS.SCORCHED_DESERT]: {
    [FACTION_IDS.GAIA]: 0.2,
    [FACTION_IDS.ARES]: 0.9,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.5,
  },
  [BIOME_IDS.TWILIGHT_MARSH]: {
    [FACTION_IDS.GAIA]: 0.7,
    [FACTION_IDS.ARES]: 0.5,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.MOUNTAIN_PEAKS]: {
    [FACTION_IDS.GAIA]: 0.5,
    [FACTION_IDS.ARES]: 0.7,
    [FACTION_IDS.VULCAN]: 0.6,
    [FACTION_IDS.SENTINEL]: 0.9,
  },
  [BIOME_IDS.VERDANT_VALLEY]: {
    [FACTION_IDS.GAIA]: 0.95,
    [FACTION_IDS.ARES]: 0.2,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.7,
  },
  [BIOME_IDS.SHADOW_JUNGLE]: {
    [FACTION_IDS.GAIA]: 0.8,
    [FACTION_IDS.ARES]: 0.6,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.4,
  },
  [BIOME_IDS.GOLDEN_SAVANNA]: {
    [FACTION_IDS.GAIA]: 0.7,
    [FACTION_IDS.ARES]: 0.5,
    [FACTION_IDS.VULCAN]: 0.4,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.OBSIDIAN_WASTES]: {
    [FACTION_IDS.GAIA]: 0.1,
    [FACTION_IDS.ARES]: 0.95,
    [FACTION_IDS.VULCAN]: 0.7,
    [FACTION_IDS.SENTINEL]: 0.3,
  },
  [BIOME_IDS.EDEN_GARDEN]: {
    [FACTION_IDS.GAIA]: 1.0,
    [FACTION_IDS.ARES]: 0.1,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.8,
  },

  // AQUATIC
  [BIOME_IDS.DEEP_OCEAN]: {
    [FACTION_IDS.GAIA]: 0.6,
    [FACTION_IDS.ARES]: 0.4,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.5,
  },
  [BIOME_IDS.CORAL_REEF]: {
    [FACTION_IDS.GAIA]: 0.9,
    [FACTION_IDS.ARES]: 0.2,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.ABYSSAL_TRENCH]: {
    [FACTION_IDS.GAIA]: 0.3,
    [FACTION_IDS.ARES]: 0.7,
    [FACTION_IDS.VULCAN]: 0.4,
    [FACTION_IDS.SENTINEL]: 0.4,
  },
  [BIOME_IDS.THERMAL_VENTS]: {
    [FACTION_IDS.GAIA]: 0.5,
    [FACTION_IDS.ARES]: 0.6,
    [FACTION_IDS.VULCAN]: 0.8,
    [FACTION_IDS.SENTINEL]: 0.3,
  },
  [BIOME_IDS.KELP_FOREST]: {
    [FACTION_IDS.GAIA]: 0.85,
    [FACTION_IDS.ARES]: 0.2,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.5,
  },
  [BIOME_IDS.FROZEN_SEA]: {
    [FACTION_IDS.GAIA]: 0.4,
    [FACTION_IDS.ARES]: 0.5,
    [FACTION_IDS.VULCAN]: 0.3,
    [FACTION_IDS.SENTINEL]: 0.7,
  },
  [BIOME_IDS.BIOLUMINESCENT_DEPTHS]: {
    [FACTION_IDS.GAIA]: 0.7,
    [FACTION_IDS.ARES]: 0.3,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.4,
  },
  [BIOME_IDS.TIDAL_FLATS]: {
    [FACTION_IDS.GAIA]: 0.6,
    [FACTION_IDS.ARES]: 0.4,
    [FACTION_IDS.VULCAN]: 0.4,
    [FACTION_IDS.SENTINEL]: 0.6,
  },

  // ATMOSPHERIC
  [BIOME_IDS.STORM_LAYER]: {
    [FACTION_IDS.GAIA]: 0.4,
    [FACTION_IDS.ARES]: 0.8,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.4,
  },
  [BIOME_IDS.CLOUD_KINGDOM]: {
    [FACTION_IDS.GAIA]: 0.6,
    [FACTION_IDS.ARES]: 0.3,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.8,
  },
  [BIOME_IDS.AURORA_ZONE]: {
    [FACTION_IDS.GAIA]: 0.5,
    [FACTION_IDS.ARES]: 0.2,
    [FACTION_IDS.VULCAN]: 0.4,
    [FACTION_IDS.SENTINEL]: 0.7,
  },
  [BIOME_IDS.LIGHTNING_FIELD]: {
    [FACTION_IDS.GAIA]: 0.3,
    [FACTION_IDS.ARES]: 0.9,
    [FACTION_IDS.VULCAN]: 0.7,
    [FACTION_IDS.SENTINEL]: 0.3,
  },
  [BIOME_IDS.WIND_CURRENTS]: {
    [FACTION_IDS.GAIA]: 0.6,
    [FACTION_IDS.ARES]: 0.4,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.5,
  },
  [BIOME_IDS.SOLAR_HEIGHTS]: {
    [FACTION_IDS.GAIA]: 0.7,
    [FACTION_IDS.ARES]: 0.5,
    [FACTION_IDS.VULCAN]: 0.6,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.VOID_BOUNDARY]: {
    [FACTION_IDS.GAIA]: 0.2,
    [FACTION_IDS.ARES]: 0.6,
    [FACTION_IDS.VULCAN]: 0.4,
    [FACTION_IDS.SENTINEL]: 0.5,
  },
  [BIOME_IDS.ETHER_REALM]: {
    [FACTION_IDS.GAIA]: 0.5,
    [FACTION_IDS.ARES]: 0.3,
    [FACTION_IDS.VULCAN]: 0.5,
    [FACTION_IDS.SENTINEL]: 0.6,
  },

  // SYNTHETIC
  [BIOME_IDS.MACHINE_CORE]: {
    [FACTION_IDS.GAIA]: 0.1,
    [FACTION_IDS.ARES]: 0.6,
    [FACTION_IDS.VULCAN]: 0.95,
    [FACTION_IDS.SENTINEL]: 0.7,
  },
  [BIOME_IDS.DATA_STREAMS]: {
    [FACTION_IDS.GAIA]: 0.2,
    [FACTION_IDS.ARES]: 0.4,
    [FACTION_IDS.VULCAN]: 0.85,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.QUANTUM_LATTICE]: {
    [FACTION_IDS.GAIA]: 0.3,
    [FACTION_IDS.ARES]: 0.3,
    [FACTION_IDS.VULCAN]: 0.8,
    [FACTION_IDS.SENTINEL]: 0.7,
  },
  [BIOME_IDS.NEURAL_NETWORK]: {
    [FACTION_IDS.GAIA]: 0.4,
    [FACTION_IDS.ARES]: 0.3,
    [FACTION_IDS.VULCAN]: 0.9,
    [FACTION_IDS.SENTINEL]: 0.5,
  },
  [BIOME_IDS.MEMORY_PALACE]: {
    [FACTION_IDS.GAIA]: 0.5,
    [FACTION_IDS.ARES]: 0.2,
    [FACTION_IDS.VULCAN]: 0.7,
    [FACTION_IDS.SENTINEL]: 0.8,
  },
  [BIOME_IDS.LOGIC_GATES]: {
    [FACTION_IDS.GAIA]: 0.2,
    [FACTION_IDS.ARES]: 0.4,
    [FACTION_IDS.VULCAN]: 0.9,
    [FACTION_IDS.SENTINEL]: 0.6,
  },
  [BIOME_IDS.RESONANCE_CHAMBER]: {
    [FACTION_IDS.GAIA]: 0.6,
    [FACTION_IDS.ARES]: 0.2,
    [FACTION_IDS.VULCAN]: 0.6,
    [FACTION_IDS.SENTINEL]: 0.9,
  },
  [BIOME_IDS.GENESIS_POINT]: {
    [FACTION_IDS.GAIA]: 0.8,
    [FACTION_IDS.ARES]: 0.1,
    [FACTION_IDS.VULCAN]: 0.8,
    [FACTION_IDS.SENTINEL]: 0.8,
  },
};

// ============================================================================
// VISUALIZATION COLORS
// ============================================================================

export const BIOME_COLORS: Record<BiomeId, string> = {
  [BIOME_IDS.ANCIENT_FOREST]: "#228B22",
  [BIOME_IDS.VOLCANIC_PLAINS]: "#8B0000",
  [BIOME_IDS.CRYSTAL_CAVERNS]: "#9400D3",
  [BIOME_IDS.FROZEN_TUNDRA]: "#E0FFFF",
  [BIOME_IDS.SCORCHED_DESERT]: "#DAA520",
  [BIOME_IDS.TWILIGHT_MARSH]: "#2F4F4F",
  [BIOME_IDS.MOUNTAIN_PEAKS]: "#808080",
  [BIOME_IDS.VERDANT_VALLEY]: "#32CD32",
  [BIOME_IDS.SHADOW_JUNGLE]: "#006400",
  [BIOME_IDS.GOLDEN_SAVANNA]: "#F0E68C",
  [BIOME_IDS.OBSIDIAN_WASTES]: "#1C1C1C",
  [BIOME_IDS.EDEN_GARDEN]: "#00FF7F",
  [BIOME_IDS.DEEP_OCEAN]: "#00008B",
  [BIOME_IDS.CORAL_REEF]: "#FF6347",
  [BIOME_IDS.ABYSSAL_TRENCH]: "#191970",
  [BIOME_IDS.THERMAL_VENTS]: "#FF4500",
  [BIOME_IDS.KELP_FOREST]: "#3CB371",
  [BIOME_IDS.FROZEN_SEA]: "#B0E0E6",
  [BIOME_IDS.BIOLUMINESCENT_DEPTHS]: "#00FFFF",
  [BIOME_IDS.TIDAL_FLATS]: "#D2B48C",
  [BIOME_IDS.STORM_LAYER]: "#696969",
  [BIOME_IDS.CLOUD_KINGDOM]: "#F5F5F5",
  [BIOME_IDS.AURORA_ZONE]: "#9ACD32",
  [BIOME_IDS.LIGHTNING_FIELD]: "#FFFF00",
  [BIOME_IDS.WIND_CURRENTS]: "#ADD8E6",
  [BIOME_IDS.SOLAR_HEIGHTS]: "#FFD700",
  [BIOME_IDS.VOID_BOUNDARY]: "#4B0082",
  [BIOME_IDS.ETHER_REALM]: "#E6E6FA",
  [BIOME_IDS.MACHINE_CORE]: "#708090",
  [BIOME_IDS.DATA_STREAMS]: "#00CED1",
  [BIOME_IDS.QUANTUM_LATTICE]: "#BA55D3",
  [BIOME_IDS.NEURAL_NETWORK]: "#FF69B4",
  [BIOME_IDS.MEMORY_PALACE]: "#DDA0DD",
  [BIOME_IDS.LOGIC_GATES]: "#20B2AA",
  [BIOME_IDS.RESONANCE_CHAMBER]: "#FFB6C1",
  [BIOME_IDS.GENESIS_POINT]: "#FFFFFF",
};
