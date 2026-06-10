/**
 * WORLD ENGINE - SUPER ORGANISM VERSION
 *
 * 36 BIOMES × 4 FACTIONS × 5 WORLD DRIVES
 *
 * MEDINA'S MIRROR LAW:
 * Backend: Canonical world state - what actually happened
 * Frontend: Rendered world state - what player sees
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 * Alfredo Medina Hernandez | Dallas TX | 2026
 */

// ============================================================================
// BIOME DEFINITIONS (36 BIOMES)
// ============================================================================

export const BIOMES = {
  // TEMPERATE ZONE (12 biomes)
  TEMPERATE_FOREST: 0,
  TEMPERATE_GRASSLAND: 1,
  TEMPERATE_HILLS: 2,
  TEMPERATE_RIVER: 3,
  TEMPERATE_LAKE: 4,
  TEMPERATE_MARSH: 5,
  TEMPERATE_FARMLAND: 6,
  TEMPERATE_VILLAGE: 7,
  TEMPERATE_RUINS: 8,
  TEMPERATE_CROSSROADS: 9,
  TEMPERATE_OUTPOST: 10,
  TEMPERATE_FORTRESS: 11,

  // ARID ZONE (12 biomes)
  DESERT_DUNES: 12,
  DESERT_MESA: 13,
  DESERT_CANYON: 14,
  DESERT_OASIS: 15,
  DESERT_SALT_FLAT: 16,
  DESERT_BADLANDS: 17,
  DESERT_RUINS: 18,
  DESERT_CARAVAN_ROUTE: 19,
  DESERT_TOMB: 20,
  DESERT_SHRINE: 21,
  DESERT_QUARRY: 22,
  DESERT_CITADEL: 23,

  // FRIGID ZONE (12 biomes)
  TUNDRA_PLAINS: 24,
  TUNDRA_MOUNTAINS: 25,
  TUNDRA_GLACIER: 26,
  TUNDRA_FROZEN_LAKE: 27,
  TUNDRA_ICE_CAVES: 28,
  TUNDRA_HOT_SPRINGS: 29,
  TUNDRA_AURORA_FIELD: 30,
  TUNDRA_SHIPWRECK: 31,
  TUNDRA_RESEARCH_STATION: 32,
  TUNDRA_ANCIENT_TEMPLE: 33,
  TUNDRA_MINING_CAMP: 34,
  TUNDRA_STRONGHOLD: 35,
} as const;

export type Biome = (typeof BIOMES)[keyof typeof BIOMES];
export const BIOME_COUNT = 36;

export const BIOME_NAMES: Record<Biome, string> = {
  [BIOMES.TEMPERATE_FOREST]: "Temperate Forest",
  [BIOMES.TEMPERATE_GRASSLAND]: "Grassland",
  [BIOMES.TEMPERATE_HILLS]: "Rolling Hills",
  [BIOMES.TEMPERATE_RIVER]: "River Valley",
  [BIOMES.TEMPERATE_LAKE]: "Lake Region",
  [BIOMES.TEMPERATE_MARSH]: "Marshlands",
  [BIOMES.TEMPERATE_FARMLAND]: "Farmland",
  [BIOMES.TEMPERATE_VILLAGE]: "Village",
  [BIOMES.TEMPERATE_RUINS]: "Ancient Ruins",
  [BIOMES.TEMPERATE_CROSSROADS]: "Crossroads",
  [BIOMES.TEMPERATE_OUTPOST]: "Outpost",
  [BIOMES.TEMPERATE_FORTRESS]: "Fortress",
  [BIOMES.DESERT_DUNES]: "Sand Dunes",
  [BIOMES.DESERT_MESA]: "Mesa",
  [BIOMES.DESERT_CANYON]: "Canyon",
  [BIOMES.DESERT_OASIS]: "Oasis",
  [BIOMES.DESERT_SALT_FLAT]: "Salt Flats",
  [BIOMES.DESERT_BADLANDS]: "Badlands",
  [BIOMES.DESERT_RUINS]: "Desert Ruins",
  [BIOMES.DESERT_CARAVAN_ROUTE]: "Caravan Route",
  [BIOMES.DESERT_TOMB]: "Ancient Tomb",
  [BIOMES.DESERT_SHRINE]: "Desert Shrine",
  [BIOMES.DESERT_QUARRY]: "Quarry",
  [BIOMES.DESERT_CITADEL]: "Citadel",
  [BIOMES.TUNDRA_PLAINS]: "Frozen Plains",
  [BIOMES.TUNDRA_MOUNTAINS]: "Frozen Mountains",
  [BIOMES.TUNDRA_GLACIER]: "Glacier",
  [BIOMES.TUNDRA_FROZEN_LAKE]: "Frozen Lake",
  [BIOMES.TUNDRA_ICE_CAVES]: "Ice Caves",
  [BIOMES.TUNDRA_HOT_SPRINGS]: "Hot Springs",
  [BIOMES.TUNDRA_AURORA_FIELD]: "Aurora Field",
  [BIOMES.TUNDRA_SHIPWRECK]: "Shipwreck",
  [BIOMES.TUNDRA_RESEARCH_STATION]: "Research Station",
  [BIOMES.TUNDRA_ANCIENT_TEMPLE]: "Frozen Temple",
  [BIOMES.TUNDRA_MINING_CAMP]: "Mining Camp",
  [BIOMES.TUNDRA_STRONGHOLD]: "Stronghold",
};

// ============================================================================
// BIOME PROPERTIES
// ============================================================================

export interface BiomeProperties {
  zone: "temperate" | "arid" | "frigid";
  baseCoherence: number;
  resourceYield: number;
  defensibility: number;
  traversability: number;
  visibility: number;
  ambushPotential: number;
  buildable: boolean;
  strategicValue: number;
}

export const BIOME_PROPERTIES: Record<Biome, BiomeProperties> = {
  // TEMPERATE
  [BIOMES.TEMPERATE_FOREST]: {
    zone: "temperate",
    baseCoherence: 0.6,
    resourceYield: 0.7,
    defensibility: 0.6,
    traversability: 0.6,
    visibility: 0.4,
    ambushPotential: 0.8,
    buildable: true,
    strategicValue: 0.6,
  },
  [BIOMES.TEMPERATE_GRASSLAND]: {
    zone: "temperate",
    baseCoherence: 0.7,
    resourceYield: 0.5,
    defensibility: 0.3,
    traversability: 0.9,
    visibility: 0.9,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 0.5,
  },
  [BIOMES.TEMPERATE_HILLS]: {
    zone: "temperate",
    baseCoherence: 0.6,
    resourceYield: 0.4,
    defensibility: 0.7,
    traversability: 0.5,
    visibility: 0.8,
    ambushPotential: 0.5,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.TEMPERATE_RIVER]: {
    zone: "temperate",
    baseCoherence: 0.7,
    resourceYield: 0.8,
    defensibility: 0.5,
    traversability: 0.4,
    visibility: 0.7,
    ambushPotential: 0.4,
    buildable: false,
    strategicValue: 0.8,
  },
  [BIOMES.TEMPERATE_LAKE]: {
    zone: "temperate",
    baseCoherence: 0.8,
    resourceYield: 0.7,
    defensibility: 0.4,
    traversability: 0.2,
    visibility: 0.9,
    ambushPotential: 0.2,
    buildable: false,
    strategicValue: 0.6,
  },
  [BIOMES.TEMPERATE_MARSH]: {
    zone: "temperate",
    baseCoherence: 0.5,
    resourceYield: 0.4,
    defensibility: 0.4,
    traversability: 0.3,
    visibility: 0.5,
    ambushPotential: 0.7,
    buildable: false,
    strategicValue: 0.4,
  },
  [BIOMES.TEMPERATE_FARMLAND]: {
    zone: "temperate",
    baseCoherence: 0.8,
    resourceYield: 0.9,
    defensibility: 0.2,
    traversability: 0.8,
    visibility: 0.8,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.TEMPERATE_VILLAGE]: {
    zone: "temperate",
    baseCoherence: 0.9,
    resourceYield: 0.6,
    defensibility: 0.5,
    traversability: 0.7,
    visibility: 0.6,
    ambushPotential: 0.4,
    buildable: true,
    strategicValue: 0.8,
  },
  [BIOMES.TEMPERATE_RUINS]: {
    zone: "temperate",
    baseCoherence: 0.4,
    resourceYield: 0.3,
    defensibility: 0.6,
    traversability: 0.5,
    visibility: 0.5,
    ambushPotential: 0.7,
    buildable: true,
    strategicValue: 0.5,
  },
  [BIOMES.TEMPERATE_CROSSROADS]: {
    zone: "temperate",
    baseCoherence: 0.7,
    resourceYield: 0.4,
    defensibility: 0.3,
    traversability: 0.95,
    visibility: 0.8,
    ambushPotential: 0.3,
    buildable: true,
    strategicValue: 0.9,
  },
  [BIOMES.TEMPERATE_OUTPOST]: {
    zone: "temperate",
    baseCoherence: 0.8,
    resourceYield: 0.3,
    defensibility: 0.7,
    traversability: 0.6,
    visibility: 0.8,
    ambushPotential: 0.3,
    buildable: true,
    strategicValue: 0.8,
  },
  [BIOMES.TEMPERATE_FORTRESS]: {
    zone: "temperate",
    baseCoherence: 0.9,
    resourceYield: 0.2,
    defensibility: 0.95,
    traversability: 0.4,
    visibility: 0.9,
    ambushPotential: 0.1,
    buildable: true,
    strategicValue: 1.0,
  },

  // ARID
  [BIOMES.DESERT_DUNES]: {
    zone: "arid",
    baseCoherence: 0.4,
    resourceYield: 0.2,
    defensibility: 0.3,
    traversability: 0.4,
    visibility: 0.9,
    ambushPotential: 0.4,
    buildable: false,
    strategicValue: 0.3,
  },
  [BIOMES.DESERT_MESA]: {
    zone: "arid",
    baseCoherence: 0.5,
    resourceYield: 0.3,
    defensibility: 0.8,
    traversability: 0.3,
    visibility: 0.95,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.DESERT_CANYON]: {
    zone: "arid",
    baseCoherence: 0.5,
    resourceYield: 0.4,
    defensibility: 0.6,
    traversability: 0.4,
    visibility: 0.4,
    ambushPotential: 0.9,
    buildable: false,
    strategicValue: 0.6,
  },
  [BIOMES.DESERT_OASIS]: {
    zone: "arid",
    baseCoherence: 0.9,
    resourceYield: 0.9,
    defensibility: 0.4,
    traversability: 0.7,
    visibility: 0.7,
    ambushPotential: 0.3,
    buildable: true,
    strategicValue: 0.95,
  },
  [BIOMES.DESERT_SALT_FLAT]: {
    zone: "arid",
    baseCoherence: 0.3,
    resourceYield: 0.3,
    defensibility: 0.1,
    traversability: 0.9,
    visibility: 1.0,
    ambushPotential: 0.0,
    buildable: false,
    strategicValue: 0.2,
  },
  [BIOMES.DESERT_BADLANDS]: {
    zone: "arid",
    baseCoherence: 0.3,
    resourceYield: 0.2,
    defensibility: 0.5,
    traversability: 0.4,
    visibility: 0.6,
    ambushPotential: 0.6,
    buildable: false,
    strategicValue: 0.3,
  },
  [BIOMES.DESERT_RUINS]: {
    zone: "arid",
    baseCoherence: 0.4,
    resourceYield: 0.4,
    defensibility: 0.6,
    traversability: 0.5,
    visibility: 0.5,
    ambushPotential: 0.7,
    buildable: true,
    strategicValue: 0.6,
  },
  [BIOMES.DESERT_CARAVAN_ROUTE]: {
    zone: "arid",
    baseCoherence: 0.6,
    resourceYield: 0.5,
    defensibility: 0.2,
    traversability: 0.9,
    visibility: 0.8,
    ambushPotential: 0.4,
    buildable: false,
    strategicValue: 0.8,
  },
  [BIOMES.DESERT_TOMB]: {
    zone: "arid",
    baseCoherence: 0.3,
    resourceYield: 0.3,
    defensibility: 0.7,
    traversability: 0.3,
    visibility: 0.3,
    ambushPotential: 0.8,
    buildable: false,
    strategicValue: 0.5,
  },
  [BIOMES.DESERT_SHRINE]: {
    zone: "arid",
    baseCoherence: 0.7,
    resourceYield: 0.2,
    defensibility: 0.5,
    traversability: 0.6,
    visibility: 0.7,
    ambushPotential: 0.4,
    buildable: true,
    strategicValue: 0.6,
  },
  [BIOMES.DESERT_QUARRY]: {
    zone: "arid",
    baseCoherence: 0.5,
    resourceYield: 0.8,
    defensibility: 0.4,
    traversability: 0.5,
    visibility: 0.7,
    ambushPotential: 0.5,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.DESERT_CITADEL]: {
    zone: "arid",
    baseCoherence: 0.9,
    resourceYield: 0.3,
    defensibility: 0.9,
    traversability: 0.4,
    visibility: 0.9,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 0.95,
  },

  // FRIGID
  [BIOMES.TUNDRA_PLAINS]: {
    zone: "frigid",
    baseCoherence: 0.5,
    resourceYield: 0.3,
    defensibility: 0.2,
    traversability: 0.7,
    visibility: 0.9,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 0.4,
  },
  [BIOMES.TUNDRA_MOUNTAINS]: {
    zone: "frigid",
    baseCoherence: 0.5,
    resourceYield: 0.4,
    defensibility: 0.9,
    traversability: 0.2,
    visibility: 0.8,
    ambushPotential: 0.4,
    buildable: true,
    strategicValue: 0.8,
  },
  [BIOMES.TUNDRA_GLACIER]: {
    zone: "frigid",
    baseCoherence: 0.4,
    resourceYield: 0.1,
    defensibility: 0.6,
    traversability: 0.3,
    visibility: 0.9,
    ambushPotential: 0.2,
    buildable: false,
    strategicValue: 0.3,
  },
  [BIOMES.TUNDRA_FROZEN_LAKE]: {
    zone: "frigid",
    baseCoherence: 0.5,
    resourceYield: 0.4,
    defensibility: 0.3,
    traversability: 0.5,
    visibility: 0.9,
    ambushPotential: 0.2,
    buildable: false,
    strategicValue: 0.5,
  },
  [BIOMES.TUNDRA_ICE_CAVES]: {
    zone: "frigid",
    baseCoherence: 0.4,
    resourceYield: 0.5,
    defensibility: 0.8,
    traversability: 0.3,
    visibility: 0.2,
    ambushPotential: 0.9,
    buildable: false,
    strategicValue: 0.6,
  },
  [BIOMES.TUNDRA_HOT_SPRINGS]: {
    zone: "frigid",
    baseCoherence: 0.8,
    resourceYield: 0.6,
    defensibility: 0.3,
    traversability: 0.6,
    visibility: 0.5,
    ambushPotential: 0.4,
    buildable: true,
    strategicValue: 0.8,
  },
  [BIOMES.TUNDRA_AURORA_FIELD]: {
    zone: "frigid",
    baseCoherence: 0.9,
    resourceYield: 0.2,
    defensibility: 0.2,
    traversability: 0.7,
    visibility: 0.8,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.TUNDRA_SHIPWRECK]: {
    zone: "frigid",
    baseCoherence: 0.3,
    resourceYield: 0.5,
    defensibility: 0.5,
    traversability: 0.4,
    visibility: 0.6,
    ambushPotential: 0.6,
    buildable: false,
    strategicValue: 0.5,
  },
  [BIOMES.TUNDRA_RESEARCH_STATION]: {
    zone: "frigid",
    baseCoherence: 0.8,
    resourceYield: 0.4,
    defensibility: 0.6,
    traversability: 0.5,
    visibility: 0.7,
    ambushPotential: 0.3,
    buildable: true,
    strategicValue: 0.8,
  },
  [BIOMES.TUNDRA_ANCIENT_TEMPLE]: {
    zone: "frigid",
    baseCoherence: 0.6,
    resourceYield: 0.3,
    defensibility: 0.7,
    traversability: 0.4,
    visibility: 0.5,
    ambushPotential: 0.6,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.TUNDRA_MINING_CAMP]: {
    zone: "frigid",
    baseCoherence: 0.6,
    resourceYield: 0.8,
    defensibility: 0.4,
    traversability: 0.5,
    visibility: 0.6,
    ambushPotential: 0.4,
    buildable: true,
    strategicValue: 0.7,
  },
  [BIOMES.TUNDRA_STRONGHOLD]: {
    zone: "frigid",
    baseCoherence: 0.9,
    resourceYield: 0.2,
    defensibility: 0.95,
    traversability: 0.4,
    visibility: 0.8,
    ambushPotential: 0.2,
    buildable: true,
    strategicValue: 1.0,
  },
};

// ============================================================================
// FACTIONS (4 PRIMARY)
// ============================================================================

export const FACTIONS = {
  GAIA: 0, // Builders, growers, healers
  ARES: 1, // Warriors, destroyers, conquerors
  VULCAN: 2, // Craftsmen, engineers, industrialists
  SENTINEL: 3, // Guardians, protectors, watchers
} as const;

export type Faction = (typeof FACTIONS)[keyof typeof FACTIONS];
export const FACTION_COUNT = 4;

export const FACTION_NAMES: Record<Faction, string> = {
  [FACTIONS.GAIA]: "GAIA",
  [FACTIONS.ARES]: "ARES",
  [FACTIONS.VULCAN]: "VULCAN",
  [FACTIONS.SENTINEL]: "SENTINEL",
};

export const FACTION_COLORS: Record<Faction, string> = {
  [FACTIONS.GAIA]: "#00FF00", // Green
  [FACTIONS.ARES]: "#FF0000", // Red
  [FACTIONS.VULCAN]: "#FF8C00", // Orange
  [FACTIONS.SENTINEL]: "#FFD700", // Gold
};

export const FACTION_DESCRIPTIONS: Record<Faction, string> = {
  [FACTIONS.GAIA]:
    "The builders and healers. GAIA faction focuses on growth, restoration, and harmony with the world.",
  [FACTIONS.ARES]:
    "The warriors and conquerors. ARES faction embraces conflict, destruction, and territorial expansion.",
  [FACTIONS.VULCAN]:
    "The craftsmen and engineers. VULCAN faction excels at construction, industry, and resource extraction.",
  [FACTIONS.SENTINEL]:
    "The guardians and watchers. SENTINEL faction defends, patrols, and maintains order.",
};

// ============================================================================
// WORLD DRIVES (5 DRIVES)
// ============================================================================

export const WORLD_DRIVES = {
  GAIA: 0, // Growth, building, healing
  ARES: 1, // Conflict, destruction, conquest
  VULCAN: 2, // Production, crafting, industry
  SENTINEL: 3, // Defense, patrol, protection
  RESONANCE: 4, // Synchronization, emergence, transcendence
} as const;

export type WorldDrive = (typeof WORLD_DRIVES)[keyof typeof WORLD_DRIVES];
export const WORLD_DRIVE_COUNT = 5;

export const WORLD_DRIVE_NAMES: Record<WorldDrive, string> = {
  [WORLD_DRIVES.GAIA]: "GAIA",
  [WORLD_DRIVES.ARES]: "ARES",
  [WORLD_DRIVES.VULCAN]: "VULCAN",
  [WORLD_DRIVES.SENTINEL]: "SENTINEL",
  [WORLD_DRIVES.RESONANCE]: "RESONANCE",
};

// ============================================================================
// BIOME STATE
// ============================================================================

export interface BiomeState {
  biome: Biome;
  name: string;
  zone: "temperate" | "arid" | "frigid";

  /** Current owner faction (-1 = neutral) */
  owner: Faction | -1;

  /** Coherence level (0-1) */
  coherence: number;

  /** Status */
  status: "active" | "contested" | "collapsed" | "rebuilding";

  /** Resource levels */
  resources: {
    food: number;
    materials: number;
    energy: number;
    knowledge: number;
  };

  /** Military presence per faction */
  militaryPresence: Record<Faction, number>;

  /** Infrastructure level */
  infrastructure: number;

  /** Population */
  population: number;

  /** Danger level (0-1) */
  dangerLevel: number;

  /** Active modifiers */
  modifiers: string[];

  /** Last update beat */
  lastUpdateBeat: number;
}

// ============================================================================
// WORLD STATE
// ============================================================================

export interface WorldState {
  /** All biome states */
  biomes: BiomeState[];

  /** Faction territory percentages */
  territoryControl: Record<Faction, number>;

  /** Active world drive */
  dominantDrive: WorldDrive;

  /** Drive strengths */
  driveStrengths: Record<WorldDrive, number>;

  /** Global coherence */
  globalCoherence: number;

  /** Total population */
  totalPopulation: number;

  /** Current beat */
  currentBeat: number;

  /** Day/night phase (0-1) */
  dayNightPhase: number;

  /** Weather system */
  weather: {
    type: "clear" | "rain" | "storm" | "snow" | "fog";
    intensity: number;
    duration: number;
  };

  /** Fibonacci build engine progress */
  fibonacciBuildProgress: number;

  /** Active events */
  activeEvents: WorldEvent[];
}

export interface WorldEvent {
  id: string;
  type:
    | "invasion"
    | "plague"
    | "prosperity"
    | "emergence"
    | "sacrifice"
    | "migration";
  affectedBiomes: Biome[];
  startBeat: number;
  duration: number;
  intensity: number;
  description: string;
}

// ============================================================================
// TERRITORY GRID (20×20)
// ============================================================================

export const TERRITORY_GRID_SIZE = 20;
export const TERRITORY_NODE_COUNT = TERRITORY_GRID_SIZE * TERRITORY_GRID_SIZE; // 400

export interface TerritoryNode {
  x: number;
  y: number;
  index: number;
  biome: Biome;
  owner: Faction | -1;
  coherence: number;
  dangerLevel: number;
  adjacentNodes: number[];
}

// ============================================================================
// WORLD ENGINE METRICS
// ============================================================================

export const WORLD_ENGINE_METRICS = {
  BIOME_COUNT: 36,
  FACTION_COUNT: 4,
  WORLD_DRIVE_COUNT: 5,
  TERRITORY_NODES: 400,
  BIOME_PROPERTIES: 9,
  BIOME_STATE_FIELDS: 14,
  WORLD_STATE_FIELDS: 12,
  RESOURCE_TYPES: 4,
} as const;
