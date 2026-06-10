// ═══════════════════════════════════════════════════════════════════════════════
// FACTION ENGINE — Autonomous Faction AI, Diplomacy & Territory Control
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════

import type { CellState, Vec2 } from "./macroWorld";

// ─── Faction Identity ────────────────────────────────────────────────────────

export type FactionArchetype =
  | "expansionist"
  | "fortifier"
  | "diplomat"
  | "exploiter"
  | "phantom"
  | "zealot"
  | "merchant"
  | "scavenger";

export type FactionStatus =
  | "active"
  | "dormant"
  | "eliminated"
  | "ascending"
  | "fracturing";

export type DiplomaticStance =
  | "allied"
  | "friendly"
  | "neutral"
  | "hostile"
  | "war"
  | "ceasefire"
  | "vassalage";

export type TerritoryPolicy =
  | "aggressive_expansion"
  | "defensive_consolidation"
  | "economic_extraction"
  | "phantom_infiltration"
  | "diplomatic_absorption";

export interface FactionDNA {
  id: number;
  name: string;
  hue: number;
  archetype: FactionArchetype;
  aggression: number; // 0-1: how likely to start conflicts
  cohesion: number; // 0-1: internal unity, high = stable borders
  adaptability: number; // 0-1: how quickly doctrine shifts
  greed: number; // 0-1: FORMA extraction desire
  loyalty: number; // 0-1: treaty respect tendency
  mysticism: number; // 0-1: anomaly attunement
  sigil: string; // faction glyph / symbol string
  foundingTick: number;
  doctrine: FactionDoctrine;
  status: FactionStatus;
}

export interface FactionDoctrine {
  primaryGoal: TerritoryPolicy;
  economicModel: "tribute" | "trade" | "raid" | "self-sufficient";
  militaryStance: "offensive" | "defensive" | "guerrilla" | "proxy";
  expansionVector: Vec2; // preferred direction of expansion
  retreatThreshold: number; // coherence below which retreat triggers
  rallyThreshold: number; // coherence above which surge triggers
  formaReserveTarget: number;
}

export interface FactionResources {
  formaBalance: number;
  formaPerTick: number;
  cellsControlled: number;
  infrastructureCount: number;
  droneCount: number;
  maxDrones: number;
  lawEnforcementPower: number;
  researchPoints: number;
  infectionTokens: number;
}

export interface FactionMemory {
  attackedBy: Record<number, number>; // factionId → attack count
  betrayedBy: Record<number, number>; // factionId → betrayal count
  tradedWith: Record<number, number>; // factionId → trade volume
  territoriesLost: number;
  territoriesGained: number;
  peakCells: number;
  peakTick: number;
  nearDeathEvents: number;
  anomaliesHarvested: number;
  conflictWinRate: number;
}

export interface FactionRelation {
  sourceId: number;
  targetId: number;
  stance: DiplomaticStance;
  trustScore: number; // 0-1
  tradeVolume: number;
  lastInteractionTick: number;
  treatyExpiry: number | null;
  sharedBorderCells: number;
  cumulativeAggression: number;
}

export interface FactionEvent {
  tick: number;
  type: FactionEventType;
  factionId: number;
  targetFactionId?: number;
  cellCol?: number;
  cellRow?: number;
  value?: number;
  description: string;
}

export type FactionEventType =
  | "founded"
  | "doctrine_shift"
  | "alliance_formed"
  | "alliance_broken"
  | "war_declared"
  | "ceasefire_signed"
  | "vassalage_accepted"
  | "territory_seized"
  | "territory_lost"
  | "capital_moved"
  | "faction_split"
  | "faction_eliminated"
  | "surge"
  | "collapse"
  | "anomaly_claim"
  | "forma_heist"
  | "forma_crash"
  | "doctrine_evolved";

export interface Faction {
  dna: FactionDNA;
  resources: FactionResources;
  memory: FactionMemory;
  relations: Map<number, FactionRelation>;
  eventLog: FactionEvent[];
  coherence: number; // 0-1, core health metric
  influence: number[]; // per-cell influence flat array
  capitalCell: { col: number; row: number } | null;
  frontlineCells: Array<{ col: number; row: number }>;
  recentLosses: number;
  recentGains: number;
  ticksExisting: number;
  lastDoctrineShiftTick: number;
}

// ─── Faction AI Constants ────────────────────────────────────────────────────

export const MAX_FACTIONS = 10;
export const FACTION_COHERENCE_DECAY = 0.0002;
export const FACTION_COHERENCE_GAIN_PER_CELL = 0.00008;
export const FORMA_PER_CELL_PER_TICK = 0.04;
export const FORMA_UPKEEP_PER_DRONE = 0.015;
export const FORMA_UPKEEP_PER_INFRA = 0.008;
export const AGGRESSION_ESCALATION_RATE = 0.12;
export const TRUST_DECAY_PER_TICK = 0.0003;
export const TRUST_GAIN_PER_TRADE = 0.002;
export const TRUST_LOSS_PER_ATTACK = 0.08;
export const DOCTRINE_SHIFT_COOLDOWN = 500;
export const SURGE_COHERENCE_THRESHOLD = 0.82;
export const COLLAPSE_COHERENCE_THRESHOLD = 0.22;
export const CAPITAL_FORTIFY_RADIUS = 3;
export const PHANTOM_INFILTRATION_RANGE = 8;
export const CEASEFIRE_MIN_DURATION = 200;
export const WAR_ESCALATION_TICKS = 50;

// ─── Faction Archetypes ──────────────────────────────────────────────────────

export const ARCHETYPE_DEFAULTS: Record<
  FactionArchetype,
  Partial<FactionDNA>
> = {
  expansionist: {
    aggression: 0.78,
    cohesion: 0.55,
    adaptability: 0.62,
    greed: 0.7,
    loyalty: 0.45,
    mysticism: 0.2,
  },
  fortifier: {
    aggression: 0.35,
    cohesion: 0.9,
    adaptability: 0.4,
    greed: 0.5,
    loyalty: 0.75,
    mysticism: 0.3,
  },
  diplomat: {
    aggression: 0.22,
    cohesion: 0.72,
    adaptability: 0.8,
    greed: 0.45,
    loyalty: 0.92,
    mysticism: 0.35,
  },
  exploiter: {
    aggression: 0.65,
    cohesion: 0.48,
    adaptability: 0.7,
    greed: 0.95,
    loyalty: 0.3,
    mysticism: 0.15,
  },
  phantom: {
    aggression: 0.55,
    cohesion: 0.6,
    adaptability: 0.88,
    greed: 0.62,
    loyalty: 0.38,
    mysticism: 0.85,
  },
  zealot: {
    aggression: 0.88,
    cohesion: 0.82,
    adaptability: 0.28,
    greed: 0.4,
    loyalty: 0.85,
    mysticism: 0.72,
  },
  merchant: {
    aggression: 0.3,
    cohesion: 0.65,
    adaptability: 0.75,
    greed: 0.88,
    loyalty: 0.7,
    mysticism: 0.25,
  },
  scavenger: {
    aggression: 0.6,
    cohesion: 0.38,
    adaptability: 0.92,
    greed: 0.78,
    loyalty: 0.28,
    mysticism: 0.5,
  },
};

// ─── Predefined Faction Templates ───────────────────────────────────────────

export const FACTION_TEMPLATES: Omit<FactionDNA, "status" | "foundingTick">[] =
  [
    {
      id: 0,
      name: "Auric Dominion",
      hue: 42,
      archetype: "expansionist",
      aggression: 0.75,
      cohesion: 0.6,
      adaptability: 0.65,
      greed: 0.72,
      loyalty: 0.48,
      mysticism: 0.22,
      sigil: "◈",
      doctrine: {
        primaryGoal: "aggressive_expansion",
        economicModel: "tribute",
        militaryStance: "offensive",
        expansionVector: { x: 1, y: 0.3 },
        retreatThreshold: 0.3,
        rallyThreshold: 0.78,
        formaReserveTarget: 500,
      },
    },
    {
      id: 1,
      name: "Cerulean Compact",
      hue: 210,
      archetype: "diplomat",
      aggression: 0.25,
      cohesion: 0.78,
      adaptability: 0.82,
      greed: 0.42,
      loyalty: 0.9,
      mysticism: 0.38,
      sigil: "⬡",
      doctrine: {
        primaryGoal: "diplomatic_absorption",
        economicModel: "trade",
        militaryStance: "defensive",
        expansionVector: { x: -0.5, y: 0.8 },
        retreatThreshold: 0.45,
        rallyThreshold: 0.7,
        formaReserveTarget: 400,
      },
    },
    {
      id: 2,
      name: "Crimson Veil",
      hue: 355,
      archetype: "phantom",
      aggression: 0.58,
      cohesion: 0.62,
      adaptability: 0.9,
      greed: 0.65,
      loyalty: 0.35,
      mysticism: 0.88,
      sigil: "⧖",
      doctrine: {
        primaryGoal: "phantom_infiltration",
        economicModel: "raid",
        militaryStance: "guerrilla",
        expansionVector: { x: 0, y: -1 },
        retreatThreshold: 0.25,
        rallyThreshold: 0.75,
        formaReserveTarget: 350,
      },
    },
    {
      id: 3,
      name: "Verdant Covenant",
      hue: 140,
      archetype: "fortifier",
      aggression: 0.32,
      cohesion: 0.92,
      adaptability: 0.42,
      greed: 0.52,
      loyalty: 0.8,
      mysticism: 0.35,
      sigil: "❂",
      doctrine: {
        primaryGoal: "defensive_consolidation",
        economicModel: "self-sufficient",
        militaryStance: "defensive",
        expansionVector: { x: 0.2, y: 0.5 },
        retreatThreshold: 0.38,
        rallyThreshold: 0.82,
        formaReserveTarget: 600,
      },
    },
    {
      id: 4,
      name: "Iron Syndicate",
      hue: 25,
      archetype: "exploiter",
      aggression: 0.68,
      cohesion: 0.5,
      adaptability: 0.72,
      greed: 0.95,
      loyalty: 0.28,
      mysticism: 0.12,
      sigil: "⚙",
      doctrine: {
        primaryGoal: "economic_extraction",
        economicModel: "raid",
        militaryStance: "offensive",
        expansionVector: { x: 0.8, y: -0.4 },
        retreatThreshold: 0.28,
        rallyThreshold: 0.76,
        formaReserveTarget: 800,
      },
    },
    {
      id: 5,
      name: "Pale Seraph",
      hue: 290,
      archetype: "zealot",
      aggression: 0.85,
      cohesion: 0.85,
      adaptability: 0.3,
      greed: 0.38,
      loyalty: 0.88,
      mysticism: 0.78,
      sigil: "✦",
      doctrine: {
        primaryGoal: "aggressive_expansion",
        economicModel: "tribute",
        militaryStance: "offensive",
        expansionVector: { x: -0.6, y: -0.8 },
        retreatThreshold: 0.22,
        rallyThreshold: 0.72,
        formaReserveTarget: 300,
      },
    },
    {
      id: 6,
      name: "Azure Nexus",
      hue: 185,
      archetype: "merchant",
      aggression: 0.28,
      cohesion: 0.68,
      adaptability: 0.78,
      greed: 0.9,
      loyalty: 0.72,
      mysticism: 0.28,
      sigil: "◎",
      doctrine: {
        primaryGoal: "economic_extraction",
        economicModel: "trade",
        militaryStance: "defensive",
        expansionVector: { x: 0.4, y: 0.9 },
        retreatThreshold: 0.4,
        rallyThreshold: 0.74,
        formaReserveTarget: 900,
      },
    },
    {
      id: 7,
      name: "Ashbound Rift",
      hue: 15,
      archetype: "scavenger",
      aggression: 0.62,
      cohesion: 0.35,
      adaptability: 0.95,
      greed: 0.8,
      loyalty: 0.25,
      mysticism: 0.55,
      sigil: "⚿",
      doctrine: {
        primaryGoal: "phantom_infiltration",
        economicModel: "raid",
        militaryStance: "guerrilla",
        expansionVector: { x: -0.9, y: 0.4 },
        retreatThreshold: 0.2,
        rallyThreshold: 0.68,
        formaReserveTarget: 250,
      },
    },
  ];

// ─── Diplomacy Matrix ────────────────────────────────────────────────────────

export function createRelationMatrix(numFactions: number): FactionRelation[][] {
  const matrix: FactionRelation[][] = [];
  for (let i = 0; i < numFactions; i++) {
    matrix[i] = [];
    for (let j = 0; j < numFactions; j++) {
      if (i === j) continue;
      matrix[i][j] = {
        sourceId: i,
        targetId: j,
        stance: "neutral",
        trustScore: 0.5 + (Math.random() - 0.5) * 0.3,
        tradeVolume: 0,
        lastInteractionTick: 0,
        treatyExpiry: null,
        sharedBorderCells: 0,
        cumulativeAggression: 0,
      };
    }
  }
  return matrix;
}

export function getStanceColor(stance: DiplomaticStance): string {
  switch (stance) {
    case "allied":
      return "#00e5ff";
    case "friendly":
      return "#76ff03";
    case "neutral":
      return "#bdbdbd";
    case "hostile":
      return "#ff6d00";
    case "war":
      return "#d50000";
    case "ceasefire":
      return "#ffd600";
    case "vassalage":
      return "#aa00ff";
    default:
      return "#ffffff";
  }
}

// ─── Faction AI Tick ─────────────────────────────────────────────────────────

export interface FactionTickContext {
  faction: Faction;
  allFactions: Faction[];
  cellGrid: CellState[][];
  tick: number;
  gridCols: number;
  gridRows: number;
}

export function tickFactionAI(ctx: FactionTickContext): FactionEvent[] {
  const events: FactionEvent[] = [];
  const f = ctx.faction;
  if (f.dna.status === "eliminated" || f.dna.status === "dormant")
    return events;

  // --- Resource accrual ---
  f.resources.formaBalance +=
    f.resources.cellsControlled * FORMA_PER_CELL_PER_TICK -
    f.resources.droneCount * FORMA_UPKEEP_PER_DRONE -
    f.resources.infrastructureCount * FORMA_UPKEEP_PER_INFRA;
  f.resources.formaBalance = Math.max(0, f.resources.formaBalance);

  // --- Coherence drift ---
  const cellBonus =
    f.resources.cellsControlled * FACTION_COHERENCE_GAIN_PER_CELL;
  f.coherence = Math.min(
    1,
    Math.max(0, f.coherence - FACTION_COHERENCE_DECAY + cellBonus),
  );

  // --- Collapse check ---
  if (f.coherence < COLLAPSE_COHERENCE_THRESHOLD) {
    f.dna.status = "fracturing";
    events.push({
      tick: ctx.tick,
      type: "collapse",
      factionId: f.dna.id,
      description: `${f.dna.name} is fracturing — coherence at ${(f.coherence * 100).toFixed(1)}%`,
    });
  }

  // --- Surge check ---
  if (
    f.coherence > SURGE_COHERENCE_THRESHOLD &&
    f.resources.formaBalance > f.dna.doctrine.formaReserveTarget
  ) {
    f.dna.status = "ascending";
    events.push({
      tick: ctx.tick,
      type: "surge",
      factionId: f.dna.id,
      description: `${f.dna.name} surges — coherence ${(f.coherence * 100).toFixed(1)}%`,
    });
  }

  // --- Doctrine shift ---
  if (
    ctx.tick - f.lastDoctrineShiftTick > DOCTRINE_SHIFT_COOLDOWN &&
    f.dna.adaptability > 0.5
  ) {
    const shouldShift = Math.random() < f.dna.adaptability * 0.01;
    if (shouldShift) {
      const newDocEvent = tryDoctrineShift(f, ctx.allFactions, ctx.tick);
      if (newDocEvent) events.push(newDocEvent);
    }
  }

  // --- Diplomatic AI ---
  for (const other of ctx.allFactions) {
    if (other.dna.id === f.dna.id) continue;
    if (other.dna.status === "eliminated") continue;
    const relEvent = tickDiplomacy(f, other, ctx.tick);
    if (relEvent) events.push(relEvent);
  }

  // --- Expansion AI ---
  if (f.dna.archetype !== "fortifier" || f.coherence > 0.7) {
    const expansionEvent = tickExpansion(
      f,
      ctx.cellGrid,
      ctx.gridCols,
      ctx.gridRows,
      ctx.tick,
    );
    if (expansionEvent) events.push(expansionEvent);
  }

  f.ticksExisting++;
  return events;
}

function tryDoctrineShift(
  faction: Faction,
  allFactions: Faction[],
  tick: number,
): FactionEvent | null {
  const oldGoal = faction.dna.doctrine.primaryGoal;
  const threats = allFactions.filter(
    (f) =>
      f.dna.id !== faction.dna.id &&
      f.resources.cellsControlled > faction.resources.cellsControlled * 1.5,
  );

  let newGoal: TerritoryPolicy = oldGoal;
  if (
    threats.length > 2 &&
    faction.dna.doctrine.primaryGoal !== "defensive_consolidation"
  ) {
    newGoal = "defensive_consolidation";
  } else if (
    faction.resources.formaBalance < 100 &&
    faction.dna.doctrine.primaryGoal !== "economic_extraction"
  ) {
    newGoal = "economic_extraction";
  } else if (
    faction.coherence > 0.85 &&
    faction.dna.doctrine.primaryGoal === "defensive_consolidation"
  ) {
    newGoal = "aggressive_expansion";
  }

  if (newGoal === oldGoal) return null;

  faction.dna.doctrine.primaryGoal = newGoal;
  faction.lastDoctrineShiftTick = tick;

  return {
    tick,
    type: "doctrine_shift",
    factionId: faction.dna.id,
    description: `${faction.dna.name} doctrine shifts: ${oldGoal} → ${newGoal}`,
  };
}

function tickDiplomacy(
  self: Faction,
  other: Faction,
  tick: number,
): FactionEvent | null {
  const rel = self.relations.get(other.dna.id);
  if (!rel) return null;

  // Trust decay
  rel.trustScore = Math.max(0, rel.trustScore - TRUST_DECAY_PER_TICK);
  rel.cumulativeAggression = Math.max(0, rel.cumulativeAggression - 0.0001);

  // Trade benefit
  if (rel.stance === "allied" || rel.stance === "friendly") {
    rel.trustScore = Math.min(1, rel.trustScore + TRUST_GAIN_PER_TRADE);
    rel.tradeVolume += self.dna.doctrine.economicModel === "trade" ? 2 : 0.5;
    self.resources.formaBalance +=
      self.dna.doctrine.economicModel === "trade" ? 0.5 : 0;
  }

  // Auto-escalate from hostile to war
  if (
    rel.stance === "hostile" &&
    rel.cumulativeAggression > 0.7 &&
    Math.random() < 0.005
  ) {
    rel.stance = "war";
    return {
      tick,
      type: "war_declared",
      factionId: self.dna.id,
      targetFactionId: other.dna.id,
      description: `${self.dna.name} declares WAR on ${other.dna.name}`,
    };
  }

  // Ceasefire offer from exhausted war
  if (
    rel.stance === "war" &&
    self.coherence < 0.45 &&
    other.coherence < 0.45 &&
    Math.random() < 0.01
  ) {
    rel.stance = "ceasefire";
    rel.treatyExpiry =
      tick + CEASEFIRE_MIN_DURATION + Math.floor(Math.random() * 300);
    return {
      tick,
      type: "ceasefire_signed",
      factionId: self.dna.id,
      targetFactionId: other.dna.id,
      description: `${self.dna.name} and ${other.dna.name} sign ceasefire`,
    };
  }

  // Alliance offer
  if (
    rel.stance === "friendly" &&
    rel.trustScore > 0.8 &&
    self.dna.loyalty > 0.65 &&
    Math.random() < 0.002
  ) {
    rel.stance = "allied";
    return {
      tick,
      type: "alliance_formed",
      factionId: self.dna.id,
      targetFactionId: other.dna.id,
      description: `${self.dna.name} and ${other.dna.name} form an alliance`,
    };
  }

  // Betrayal
  if (
    rel.stance === "allied" &&
    self.dna.loyalty < 0.4 &&
    rel.trustScore < 0.35 &&
    Math.random() < 0.003
  ) {
    rel.stance = "war";
    rel.cumulativeAggression += 0.5;
    return {
      tick,
      type: "alliance_broken",
      factionId: self.dna.id,
      targetFactionId: other.dna.id,
      description: `${self.dna.name} BETRAYS ${other.dna.name}`,
    };
  }

  return null;
}

function tickExpansion(
  faction: Faction,
  cellGrid: CellState[][],
  cols: number,
  rows: number,
  _tick: number,
): FactionEvent | null {
  if (!faction.capitalCell) return null;
  if (faction.resources.formaBalance < 50) return null;
  if (
    faction.dna.doctrine.primaryGoal === "defensive_consolidation" &&
    faction.recentGains > 5
  )
    return null;

  // Find best adjacent neutral/weak cell
  const { col, row } = faction.capitalCell;
  const radius = Math.min(8, 2 + Math.floor(faction.ticksExisting / 200));
  let bestCol = -1;
  let bestRow = -1;
  let bestScore = Number.NEGATIVE_INFINITY;

  for (let dc = -radius; dc <= radius; dc++) {
    for (let dr = -radius; dr <= radius; dr++) {
      const nc = col + dc;
      const nr = row + dr;
      if (nc < 0 || nc >= cols || nr < 0 || nr >= rows) continue;
      const cell = cellGrid[nr]?.[nc];
      if (!cell) continue;
      if (cell.dominant === faction.dna.id) continue;

      const dist = Math.sqrt(dc * dc + dr * dr);
      if (dist > radius) continue;

      let score = 0;
      if (cell.dominant === -1) score += 20;
      else score += (1 - cell.dominanceStrength) * 15;
      score += cell.lawDensity * 10;
      score -= cell.stability * 5;
      score -= dist;

      // Expansion vector preference
      const dotX =
        (dc / (dist + 0.01)) * faction.dna.doctrine.expansionVector.x;
      const dotY =
        (dr / (dist + 0.01)) * faction.dna.doctrine.expansionVector.y;
      score += (dotX + dotY) * 8;

      if (score > bestScore) {
        bestScore = score;
        bestCol = nc;
        bestRow = nr;
      }
    }
  }

  if (bestCol === -1) return null;

  // Apply influence push
  const cell = cellGrid[bestRow][bestCol];
  const pushStrength = 0.05 + faction.dna.aggression * 0.08;
  if (!cell.influence[faction.dna.id]) cell.influence[faction.dna.id] = 0;
  cell.influence[faction.dna.id] = Math.min(
    1,
    cell.influence[faction.dna.id] + pushStrength,
  );

  faction.resources.formaBalance -= 5;
  faction.recentGains++;

  return null; // Expansion is silent unless capital moves
}

// ─── Faction Initialization ──────────────────────────────────────────────────

export function initFaction(
  template: Omit<FactionDNA, "status" | "foundingTick">,
  tick: number,
  capitalCol: number,
  capitalRow: number,
  cols: number,
  rows: number,
): Faction {
  const relations = new Map<number, FactionRelation>();

  return {
    dna: {
      ...template,
      status: "active",
      foundingTick: tick,
    },
    resources: {
      formaBalance: 200 + Math.random() * 300,
      formaPerTick: 0,
      cellsControlled: 1,
      infrastructureCount: 0,
      droneCount: Math.floor(3 + Math.random() * 5),
      maxDrones: 15,
      lawEnforcementPower: 1.0,
      researchPoints: 0,
      infectionTokens: 0,
    },
    memory: {
      attackedBy: {},
      betrayedBy: {},
      tradedWith: {},
      territoriesLost: 0,
      territoriesGained: 0,
      peakCells: 1,
      peakTick: tick,
      nearDeathEvents: 0,
      anomaliesHarvested: 0,
      conflictWinRate: 0.5,
    },
    relations,
    eventLog: [
      {
        tick,
        type: "founded",
        factionId: template.id,
        cellCol: capitalCol,
        cellRow: capitalRow,
        description: `${template.name} founded at (${capitalCol},${capitalRow})`,
      },
    ],
    coherence: 0.75 + Math.random() * 0.2,
    influence: new Array(cols * rows).fill(0),
    capitalCell: { col: capitalCol, row: capitalRow },
    frontlineCells: [],
    recentLosses: 0,
    recentGains: 0,
    ticksExisting: 0,
    lastDoctrineShiftTick: 0,
  };
}

// ─── Border Detection ────────────────────────────────────────────────────────

export function detectFrontlines(
  faction: Faction,
  cellGrid: CellState[][],
  cols: number,
  rows: number,
): Array<{ col: number; row: number }> {
  const frontline: Array<{ col: number; row: number }> = [];

  for (let row = 0; row < rows; row++) {
    for (let col = 0; col < cols; col++) {
      const cell = cellGrid[row][col];
      if (cell.dominant !== faction.dna.id) continue;

      const neighbors = [
        [col - 1, row],
        [col + 1, row],
        [col, row - 1],
        [col, row + 1],
      ];

      for (const [nc, nr] of neighbors) {
        if (nc < 0 || nc >= cols || nr < 0 || nr >= rows) continue;
        const neighbor = cellGrid[nr][nc];
        if (neighbor.dominant !== faction.dna.id) {
          frontline.push({ col, row });
          break;
        }
      }
    }
  }

  return frontline;
}

// ─── Territory Transfer ──────────────────────────────────────────────────────

export function transferTerritory(
  fromFaction: Faction | null,
  toFaction: Faction,
  col: number,
  row: number,
  tick: number,
): FactionEvent[] {
  const events: FactionEvent[] = [];

  if (fromFaction) {
    fromFaction.resources.cellsControlled = Math.max(
      0,
      fromFaction.resources.cellsControlled - 1,
    );
    fromFaction.recentLosses++;
    fromFaction.memory.territoriesLost++;
    events.push({
      tick,
      type: "territory_lost",
      factionId: fromFaction.dna.id,
      targetFactionId: toFaction.dna.id,
      cellCol: col,
      cellRow: row,
      description: `${fromFaction.dna.name} loses (${col},${row}) to ${toFaction.dna.name}`,
    });
  }

  toFaction.resources.cellsControlled++;
  toFaction.recentGains++;
  toFaction.memory.territoriesGained++;
  if (toFaction.resources.cellsControlled > toFaction.memory.peakCells) {
    toFaction.memory.peakCells = toFaction.resources.cellsControlled;
    toFaction.memory.peakTick = tick;
  }

  events.push({
    tick,
    type: "territory_seized",
    factionId: toFaction.dna.id,
    cellCol: col,
    cellRow: row,
    description: `${toFaction.dna.name} seizes (${col},${row})`,
  });

  return events;
}

// ─── Power Ranking ───────────────────────────────────────────────────────────

export interface FactionRank {
  factionId: number;
  name: string;
  score: number;
  rank: number;
  tier: "hegemon" | "major" | "minor" | "remnant";
  trendUp: boolean;
}

export function rankFactions(factions: Faction[]): FactionRank[] {
  const scored = factions
    .filter((f) => f.dna.status !== "eliminated")
    .map((f) => ({
      factionId: f.dna.id,
      name: f.dna.name,
      score:
        f.resources.cellsControlled * 10 +
        f.resources.formaBalance * 0.5 +
        f.coherence * 200 +
        f.resources.droneCount * 3 +
        f.resources.infrastructureCount * 8,
      rank: 0,
      tier: "minor" as const,
      trendUp: f.recentGains > f.recentLosses,
    }))
    .sort((a, b) => b.score - a.score);

  return scored.map((r, i) => ({
    ...r,
    rank: i + 1,
    tier:
      i === 0
        ? "hegemon"
        : i < 3
          ? "major"
          : r.score > 500
            ? "minor"
            : "remnant",
  }));
}

// ─── Faction Merger ──────────────────────────────────────────────────────────

export function mergeFactions(
  dominant: Faction,
  absorbed: Faction,
  tick: number,
): FactionEvent {
  dominant.resources.cellsControlled += absorbed.resources.cellsControlled;
  dominant.resources.formaBalance += absorbed.resources.formaBalance * 0.7;
  dominant.resources.droneCount += Math.floor(
    absorbed.resources.droneCount * 0.5,
  );
  dominant.coherence = Math.min(
    1,
    dominant.coherence * 0.9 + absorbed.coherence * 0.1,
  );

  absorbed.dna.status = "eliminated";
  absorbed.resources.cellsControlled = 0;

  return {
    tick,
    type: "faction_eliminated",
    factionId: absorbed.dna.id,
    targetFactionId: dominant.dna.id,
    description: `${absorbed.dna.name} absorbed into ${dominant.dna.name}`,
  };
}

// ─── Faction Schism ──────────────────────────────────────────────────────────

export function schismFaction(
  parent: Faction,
  newId: number,
  tick: number,
  cols: number,
  rows: number,
): { splinter: Faction; events: FactionEvent[] } {
  const events: FactionEvent[] = [];

  const splinterId = newId;
  const splinterCells = Math.floor(parent.resources.cellsControlled * 0.4);
  const splinterForma = parent.resources.formaBalance * 0.35;

  parent.resources.cellsControlled -= splinterCells;
  parent.resources.formaBalance -= splinterForma;
  parent.coherence *= 0.75;

  const splinterTemplate: Omit<FactionDNA, "status" | "foundingTick"> = {
    id: splinterId,
    name: `${parent.dna.name} Splinter`,
    hue: (parent.dna.hue + 180) % 360,
    archetype: "scavenger",
    aggression: parent.dna.aggression * 1.2,
    cohesion: parent.dna.cohesion * 0.5,
    adaptability: 0.9,
    greed: 0.8,
    loyalty: 0.2,
    mysticism: parent.dna.mysticism,
    sigil: "⚡",
    doctrine: {
      primaryGoal: "phantom_infiltration",
      economicModel: "raid",
      militaryStance: "guerrilla",
      expansionVector: { x: Math.random() * 2 - 1, y: Math.random() * 2 - 1 },
      retreatThreshold: 0.18,
      rallyThreshold: 0.65,
      formaReserveTarget: 200,
    },
  };

  const splinter = initFaction(splinterTemplate, tick, 0, 0, cols, rows);
  splinter.resources.cellsControlled = splinterCells;
  splinter.resources.formaBalance = splinterForma;

  events.push({
    tick,
    type: "faction_split",
    factionId: parent.dna.id,
    targetFactionId: splinterId,
    description: `${parent.dna.name} splinters — new faction ${splinterTemplate.name} emerges`,
  });

  return { splinter, events };
}

// ─── Faction Renderer Helpers ────────────────────────────────────────────────

export function factionStatusBadge(status: FactionStatus): string {
  switch (status) {
    case "active":
      return "🟢";
    case "dormant":
      return "🔵";
    case "eliminated":
      return "💀";
    case "ascending":
      return "⬆";
    case "fracturing":
      return "⚠";
    default:
      return "⬜";
  }
}

export function stanceIcon(stance: DiplomaticStance): string {
  switch (stance) {
    case "allied":
      return "🤝";
    case "friendly":
      return "✅";
    case "neutral":
      return "➖";
    case "hostile":
      return "⚠";
    case "war":
      return "⚔";
    case "ceasefire":
      return "🕊";
    case "vassalage":
      return "👑";
    default:
      return "❓";
  }
}

export function formatFormaBalance(balance: number): string {
  if (balance >= 1_000_000) return `${(balance / 1_000_000).toFixed(2)}M FORMA`;
  if (balance >= 1_000) return `${(balance / 1_000).toFixed(1)}K FORMA`;
  return `${balance.toFixed(0)} FORMA`;
}

// ─── Faction History Log ─────────────────────────────────────────────────────

export function summarizeFactionHistory(faction: Faction): string[] {
  const lines: string[] = [];
  lines.push(`▸ Founded at tick ${faction.dna.foundingTick}`);
  lines.push(`▸ Archetype: ${faction.dna.archetype}`);
  lines.push(
    `▸ Peak territory: ${faction.memory.peakCells} cells (tick ${faction.memory.peakTick})`,
  );
  lines.push(`▸ Territories gained: ${faction.memory.territoriesGained}`);
  lines.push(`▸ Territories lost: ${faction.memory.territoriesLost}`);
  lines.push(`▸ Near-death events: ${faction.memory.nearDeathEvents}`);
  lines.push(`▸ Anomalies harvested: ${faction.memory.anomaliesHarvested}`);
  lines.push(
    `▸ Conflict win rate: ${(faction.memory.conflictWinRate * 100).toFixed(1)}%`,
  );

  const allies = [...faction.relations.values()].filter(
    (r) => r.stance === "allied",
  );
  const enemies = [...faction.relations.values()].filter(
    (r) => r.stance === "war",
  );
  if (allies.length) lines.push(`▸ Current allies: ${allies.length}`);
  if (enemies.length) lines.push(`▸ Active wars: ${enemies.length}`);

  return lines;
}

// ─── UI Adapter Types ────────────────────────────────────────────────────────
// These types match the FactionPanel component's expected format for rendering

export type UIPowerTier = "Hegemon" | "Major" | "Minor" | "Remnant";
export type UIDiplomaticStance =
  | "war"
  | "hostile"
  | "neutral"
  | "friendly"
  | "allied"
  | "vassal"
  | "suzerain";

export interface UIFactionDiplomacy {
  targetFactionId: string;
  stance: UIDiplomaticStance;
  trustLevel: number; // 0-100
  lastChanged: number;
}

export interface UIFactionResource {
  forma: number;
  food: number;
  industry: number;
  influence: number;
}

export interface UIFactionEvent {
  id: string;
  tick: number;
  factionId: string;
  type:
    | "battle"
    | "treaty"
    | "expansion"
    | "collapse"
    | "election"
    | "trade"
    | "schism"
    | "miracle";
  description: string;
  severity: "low" | "medium" | "high" | "critical";
}

export interface UIFaction {
  id: string;
  name: string;
  sigil: string;
  archetype: string;
  color: string;
  coherence: number; // 0-100
  resources: UIFactionResource;
  cellsControlled: number;
  population: number;
  powerTier: UIPowerTier;
  diplomacy: UIFactionDiplomacy[];
  recentEvents: UIFactionEvent[];
  isPlayer?: boolean;
}

/**
 * Convert internal Faction engine type to UI-compatible format for FactionPanel
 */
export function toUIFaction(
  faction: Faction,
  allFactions: Faction[],
): UIFaction {
  const rank = rankFactions(allFactions).find(
    (r) => r.factionId === faction.dna.id,
  );
  const powerTier: UIPowerTier =
    rank?.tier === "hegemon"
      ? "Hegemon"
      : rank?.tier === "major"
        ? "Major"
        : rank?.tier === "minor"
          ? "Minor"
          : "Remnant";

  const diplomacy: UIFactionDiplomacy[] = [];
  faction.relations.forEach((rel, targetId) => {
    const stanceMap: Record<DiplomaticStance, UIDiplomaticStance> = {
      allied: "allied",
      friendly: "friendly",
      neutral: "neutral",
      hostile: "hostile",
      war: "war",
      ceasefire: "neutral",
      vassalage: "vassal",
    };
    diplomacy.push({
      targetFactionId: String(targetId),
      stance: stanceMap[rel.stance] ?? "neutral",
      trustLevel: Math.round(rel.trustScore * 100),
      lastChanged: rel.lastInteractionTick,
    });
  });

  const eventTypeMap: Record<FactionEventType, UIFactionEvent["type"]> = {
    founded: "expansion",
    doctrine_shift: "trade",
    alliance_formed: "treaty",
    alliance_broken: "schism",
    war_declared: "battle",
    ceasefire_signed: "treaty",
    vassalage_accepted: "treaty",
    territory_seized: "expansion",
    territory_lost: "collapse",
    capital_moved: "expansion",
    faction_split: "schism",
    faction_eliminated: "collapse",
    surge: "miracle",
    collapse: "collapse",
    anomaly_claim: "miracle",
    forma_heist: "trade",
    forma_crash: "collapse",
    doctrine_evolved: "trade",
  };

  const recentEvents: UIFactionEvent[] = faction.eventLog
    .slice(-10)
    .map((ev, idx) => ({
      id: `${faction.dna.id}-${ev.tick}-${idx}`,
      tick: ev.tick,
      factionId: String(ev.factionId),
      type: eventTypeMap[ev.type] ?? "trade",
      description: ev.description,
      severity:
        ev.type.includes("war") ||
        ev.type === "collapse" ||
        ev.type === "faction_eliminated"
          ? "critical"
          : ev.type.includes("alliance") || ev.type === "surge"
            ? "high"
            : ev.type.includes("territory")
              ? "medium"
              : "low",
    }));

  return {
    id: String(faction.dna.id),
    name: faction.dna.name,
    sigil: faction.dna.sigil,
    archetype: faction.dna.archetype,
    color: `hsl(${faction.dna.hue}, 70%, 55%)`,
    coherence: faction.coherence * 100,
    resources: {
      forma: faction.resources.formaBalance,
      food: faction.resources.cellsControlled * 10, // Approximation
      industry: faction.resources.infrastructureCount * 100,
      influence: faction.resources.lawEnforcementPower * 1000,
    },
    cellsControlled: faction.resources.cellsControlled,
    population: faction.resources.droneCount * 1000, // Approximation
    powerTier,
    diplomacy,
    recentEvents,
    isPlayer: false,
  };
}

/**
 * Convert an array of internal Factions to UI-compatible format
 */
export function toUIFactions(factions: Faction[]): UIFaction[] {
  return factions.map((f) => toUIFaction(f, factions));
}

// ─── Export all ──────────────────────────────────────────────────────────────

export type { Vec2, CellState };
