// ═══════════════════════════════════════════════════════════════════════════════════════════════
// MACRO WORLD ENGINE — Living Simulation World
// law → state → gradients → world-generation → faction behavior → conflict/history → updated world
//
// You do not hand-build final world objects.
// You build: laws, state variables, thresholds, gradients, grammar rules, rendering rules.
// Then the world keeps building itself.
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com

// ─── Vec2 math ────────────────────────────────────────────────────────────────

export interface Vec2 {
  x: number;
  y: number;
}

function add(a: Vec2, b: Vec2): Vec2 {
  return { x: a.x + b.x, y: a.y + b.y };
}
function sub(a: Vec2, b: Vec2): Vec2 {
  return { x: a.x - b.x, y: a.y - b.y };
}
function scale(v: Vec2, s: number): Vec2 {
  return { x: v.x * s, y: v.y * s };
}
function mag(v: Vec2): number {
  return Math.sqrt(v.x * v.x + v.y * v.y);
}
function norm(v: Vec2): Vec2 {
  const m = mag(v);
  return m > 0 ? scale(v, 1 / m) : { x: 0, y: 0 };
}
function dist(a: Vec2, b: Vec2): number {
  return mag(sub(a, b));
}
function clamp(v: number, lo: number, hi: number): number {
  return Math.max(lo, Math.min(hi, v));
}

// ─── World substrate types ─────────────────────────────────────────────────────

// How "real" each grid cell is — material state transitions over time
export type MaterialState =
  | "fluid"
  | "semi-stable"
  | "hardened"
  | "ruined"
  | "anomalous";

// Biome is the visible atmospheric character of a region — emergent from state
export type BiomeType =
  | "neutral"
  | "crystalline"
  | "storm"
  | "fog"
  | "radiant"
  | "fractured"
  | "dead"
  | "void";

export interface CellState {
  influence: number[]; // faction influence per faction [NUM_FACTIONS]
  dominant: number; // dominant faction id (-1 = neutral/contested)
  dominanceStrength: number; // 0-1, how strongly dominated
  stability: number; // 0-1 (decreases with conflict)
  damage: number; // 0-1, accumulated damage (decays slowly)
  traffic: number; // accumulated movement through cell
  lawDensity: number; // law activity density (drives infrastructure)
  memoryDensity: number; // historical battle weight (drives fog/ruin biomes)
  conflictPressure: number; // active combat pressure (0-1)
  material: MaterialState;
  biome: BiomeType;
  dominanceAge: number; // ticks of continuous dominance (drives hardening)
  battleCount: number; // total battles fought here
}

// World scar — persistent battle history sediment
export interface WorldScar {
  col: number;
  row: number;
  worldX: number;
  worldY: number;
  intensity: number; // 0-1, fades over time
  radius: number; // canvas pixels
  age: number; // ticks since deposition
  type: "battle" | "ruin" | "anomaly";
  factionId: number;
}

// Infrastructure object — emerged from repeated activity
export interface InfraObject {
  type: "hub" | "route" | "fortress";
  col: number;
  row: number;
  worldX: number;
  worldY: number;
  toCol?: number;
  toRow?: number; // for routes
  toWorldX?: number;
  toWorldY?: number;
  faction: number;
  maturity: number; // 0-1, grows over time
  lawCount: number;
}

// ─── Faction DNA — each faction has a unique behavioral fingerprint ────────────

export interface FactionDNA {
  hue: number; // HSL hue for territory color
  biomeAffinity: BiomeType; // what biome stable territory becomes
  expansionRate: number; // 0-1, how fast influence spreads
  infraDensity: number; // 0-1, how much infrastructure they generate
}

// ─── Faction + Drone types ─────────────────────────────────────────────────────

export interface Faction {
  id: number;
  name: string;
  basePos: Vec2;
  coherence: number;
  territory: number;
  driveMode: "Execution" | "Exploration" | "Learning" | "Rest";
  lawsFired: number;
  actionAttack: number;
  actionEvade: number;
  actionRetreat: number;
  dna: FactionDNA;
}

export interface Drone {
  id: number;
  factionId: number;
  pos: Vec2;
  vel: Vec2;
  activation: number;
}

export interface Spark {
  fromPos: Vec2;
  toPos: Vec2;
  intensity: number;
  opacity: number;
  factionId: number;
}

export interface Explosion {
  pos: Vec2;
  radius: number;
  maxRadius: number;
  opacity: number;
  pHit: number;
  factionId: number;
}

// ─── Full World State ──────────────────────────────────────────────────────────

export interface WorldState {
  beat: number;
  time: number;
  worldAge: number;
  era: "early" | "mid" | "late";

  // Grid substrate — the hidden simulation body
  grid: CellState[]; // flat [row * GRID_COLS + col]
  gridCols: number;
  gridRows: number;
  cellW: number; // canvas pixels per cell
  cellH: number;

  // Entities
  factions: Faction[];
  drones: Drone[];
  sparks: Spark[];
  explosions: Explosion[];

  // Emerged world objects
  scars: WorldScar[];
  infraObjects: InfraObject[];

  // Global macro state
  escalation: number;
  globalMemory: number;
  globalDamage: number;

  domainFlags: { cyber: boolean; space: boolean; deep: boolean; void: boolean };
  pulsePhase: number;
}

// ─── Constants ─────────────────────────────────────────────────────────────────

const GRID_COLS = 36;
const GRID_ROWS = 24;
const NUM_FACTIONS = 10;
const BEAT_MS = 2000;
const DRONES_PER_FACTION = 5;
const BASE_TERRITORY = 55;
const MAX_TERRITORY = 110;
const K1_SEP = 1.4;
const K2_ALN = 0.8;
const K3_COH = 0.6;
const K4_ATK = 0.5;
const SEP_RADIUS = 28;
const ALN_RADIUS = 60;
const COH_RADIUS = 90;
const ENGAGE_RADIUS = 55;
const HEBBIAN_RADIUS = 45;
const HEBBIAN_LR = 0.005;
const SPARK_THRESHOLD = 0.003;
const MAX_SPEED = 2.4;

// ─── Faction DNA table — 10 distinct behavioral fingerprints ──────────────────
// Each faction's territory looks, feels, and behaves differently

const FACTION_DNA: FactionDNA[] = [
  // ORO — Orchestrator, radiant golden territories
  { hue: 45, biomeAffinity: "radiant", expansionRate: 0.8, infraDensity: 0.9 },
  // NEXUS — Strategist, crystalline ordered territories
  {
    hue: 20,
    biomeAffinity: "crystalline",
    expansionRate: 0.9,
    infraDensity: 0.85,
  },
  // NOVA — Campaign, stormy dynamic territories
  { hue: 280, biomeAffinity: "storm", expansionRate: 0.75, infraDensity: 0.65 },
  // AXIOM — Legal, crystalline precise territories
  {
    hue: 120,
    biomeAffinity: "crystalline",
    expansionRate: 0.55,
    infraDensity: 0.75,
  },
  // FORGE-X — Engineering, neutral high-infrastructure
  { hue: 160, biomeAffinity: "neutral", expansionRate: 0.7, infraDensity: 1.0 },
  // STRATUM — Finance, foggy conservative territories
  { hue: 195, biomeAffinity: "fog", expansionRate: 0.6, infraDensity: 0.7 },
  // TORI — Marketing, radiant visible territories
  { hue: 330, biomeAffinity: "radiant", expansionRate: 0.8, infraDensity: 0.6 },
  // ORACLE — Analysis, fog deep knowledge territories
  { hue: 240, biomeAffinity: "fog", expansionRate: 0.6, infraDensity: 0.8 },
  // CIPHER — Cyber, void dark secure territories
  { hue: 265, biomeAffinity: "void", expansionRate: 0.55, infraDensity: 0.9 },
  // SERAPH — HR, neutral balanced territories
  { hue: 10, biomeAffinity: "neutral", expansionRate: 0.65, infraDensity: 0.6 },
];

const FACTION_NAMES = [
  "ORO",
  "NEXUS",
  "NOVA",
  "AXIOM",
  "FORGE-X",
  "STRATUM",
  "TORI",
  "ORACLE",
  "CIPHER",
  "SERAPH",
];

// ─── Grid helpers ──────────────────────────────────────────────────────────────

function makeEmptyCell(): CellState {
  return {
    influence: new Array(NUM_FACTIONS).fill(0),
    dominant: -1,
    dominanceStrength: 0,
    stability: 0.5,
    damage: 0,
    traffic: 0,
    lawDensity: 0,
    memoryDensity: 0,
    conflictPressure: 0,
    material: "fluid",
    biome: "neutral",
    dominanceAge: 0,
    battleCount: 0,
  };
}

function computeCellDominant(cell: CellState): void {
  let maxInf = 0;
  let maxFaction = -1;
  let secondMax = 0;
  for (let f = 0; f < NUM_FACTIONS; f++) {
    if (cell.influence[f] > maxInf) {
      secondMax = maxInf;
      maxInf = cell.influence[f];
      maxFaction = f;
    } else if (cell.influence[f] > secondMax) {
      secondMax = cell.influence[f];
    }
  }
  if (maxInf < 0.04) {
    cell.dominant = -1;
    cell.dominanceStrength = 0;
  } else if (maxInf - secondMax < 0.08 && secondMax > 0.02) {
    cell.dominant = -1;
    cell.dominanceStrength = 0; // contested
  } else {
    cell.dominant = maxFaction;
    cell.dominanceStrength = maxInf;
  }
}

function computeStability(cell: CellState): number {
  let s = 1.0;
  s -= cell.conflictPressure * 0.45;
  s -= cell.damage * 0.25;
  s += (cell.dominant >= 0 ? cell.dominanceStrength : 0) * 0.2;
  s += Math.min(cell.dominanceAge / 300, 1) * 0.1;
  return clamp(s, 0, 1);
}

function computeMaterial(cell: CellState): MaterialState {
  if (cell.damage > 0.8) return "anomalous";
  if (cell.damage > 0.5) return "ruined";
  if (cell.dominant < 0) return "fluid";
  if (cell.dominanceAge > 150 && cell.stability > 0.7) return "hardened";
  if (cell.dominanceAge > 50 && cell.stability > 0.5) return "semi-stable";
  return "fluid";
}

function deriveBiome(cell: CellState, faction: Faction | null): BiomeType {
  if (cell.damage > 0.85) return "void";
  if (cell.damage > 0.55 && cell.stability < 0.25) return "dead";
  if (cell.conflictPressure > 0.65) return "storm";
  if (cell.dominant < 0 && cell.memoryDensity > 0.25) return "fog";
  if (
    faction &&
    faction.coherence > 0.88 &&
    cell.stability > 0.8 &&
    cell.dominanceAge > 80
  )
    return "radiant";
  if (cell.dominanceAge > 120 && cell.stability > 0.7) {
    return faction ? faction.dna.biomeAffinity : "crystalline";
  }
  if (cell.dominant < 0 || cell.stability < 0.35) return "fractured";
  return "neutral";
}

// ─── Seeded pseudo-random ──────────────────────────────────────────────────────

function seededRng(seed: number) {
  let s = seed;
  return () => {
    s = (s * 1664525 + 1013904223) & 0xffffffff;
    return (s >>> 0) / 0xffffffff;
  };
}

// ─── World initialization ──────────────────────────────────────────────────────

export function initWorld(
  canvasWidth: number,
  canvasHeight: number,
): WorldState {
  const rng = seededRng(42);
  const cx = canvasWidth / 2;
  const cy = canvasHeight / 2;
  const R = Math.min(canvasWidth, canvasHeight) * 0.32;

  const cellW = canvasWidth / GRID_COLS;
  const cellH = canvasHeight / GRID_ROWS;

  // Build factions with DNA
  const factions: Faction[] = FACTION_NAMES.map((name, i) => {
    const angle = (2 * Math.PI * i) / NUM_FACTIONS - Math.PI / 2;
    const basePos: Vec2 = {
      x: cx + R * Math.cos(angle),
      y: cy + R * Math.sin(angle),
    };
    const coherence = 0.78 + rng() * 0.22;
    const driveMode =
      coherence >= 0.92
        ? "Execution"
        : coherence >= 0.84
          ? "Exploration"
          : coherence >= 0.78
            ? "Learning"
            : "Rest";
    return {
      id: i,
      name,
      basePos,
      coherence,
      territory: BASE_TERRITORY + coherence * (MAX_TERRITORY - BASE_TERRITORY),
      driveMode: driveMode as Faction["driveMode"],
      lawsFired: Math.floor(rng() * 20),
      actionAttack: rng() * 0.6,
      actionEvade: rng() * 0.4,
      actionRetreat: rng() * 0.3,
      dna: FACTION_DNA[i],
    };
  });

  // Initialize grid with Gaussian influence seeding around faction bases
  const grid: CellState[] = Array.from({ length: GRID_COLS * GRID_ROWS }, () =>
    makeEmptyCell(),
  );

  for (const faction of factions) {
    const baseCol = clamp(
      Math.floor(faction.basePos.x / cellW),
      0,
      GRID_COLS - 1,
    );
    const baseRow = clamp(
      Math.floor(faction.basePos.y / cellH),
      0,
      GRID_ROWS - 1,
    );
    for (let row = 0; row < GRID_ROWS; row++) {
      for (let col = 0; col < GRID_COLS; col++) {
        const dc = col - baseCol;
        const dr = row - baseRow;
        const d = Math.sqrt(dc * dc + dr * dr);
        const sigma = 3.0;
        const inf = 0.65 * Math.exp(-(d * d) / (2 * sigma * sigma));
        grid[row * GRID_COLS + col].influence[faction.id] += inf;
      }
    }
  }

  // Initialize dominant faction per cell and set initial material/biome
  for (let i = 0; i < GRID_ROWS * GRID_COLS; i++) {
    const cell = grid[i];
    computeCellDominant(cell);
    cell.dominanceAge = 60;
    if (cell.dominant >= 0) {
      cell.stability = 0.5 + 0.3 * cell.dominanceStrength;
      cell.material = "semi-stable";
      cell.biome = deriveBiome(cell, factions[cell.dominant]);
    }
  }

  // Spawn initial drones around faction bases
  const drones: Drone[] = [];
  for (const faction of factions) {
    for (let j = 0; j < DRONES_PER_FACTION; j++) {
      const angle = (2 * Math.PI * j) / DRONES_PER_FACTION + rng() * 0.8;
      const r = faction.territory * 0.4 + rng() * faction.territory * 0.3;
      drones.push({
        id: drones.length,
        factionId: faction.id,
        pos: {
          x: faction.basePos.x + r * Math.cos(angle),
          y: faction.basePos.y + r * Math.sin(angle),
        },
        vel: { x: (rng() - 0.5) * 2, y: (rng() - 0.5) * 1.5 },
        activation: 0.55 + rng() * 0.45,
      });
    }
  }

  // Seed initial infrastructure hubs at faction bases
  const infraObjects: InfraObject[] = factions.map((f) => ({
    type: "hub" as const,
    col: clamp(Math.floor(f.basePos.x / cellW), 0, GRID_COLS - 1),
    row: clamp(Math.floor(f.basePos.y / cellH), 0, GRID_ROWS - 1),
    worldX: f.basePos.x,
    worldY: f.basePos.y,
    faction: f.id,
    maturity: 0.3,
    lawCount: f.lawsFired,
  }));

  return {
    beat: 0,
    time: 0,
    worldAge: 0,
    era: "early",
    grid,
    gridCols: GRID_COLS,
    gridRows: GRID_ROWS,
    cellW,
    cellH,
    factions,
    drones,
    sparks: [],
    explosions: [],
    scars: [],
    infraObjects,
    escalation: 0,
    globalMemory: 0,
    globalDamage: 0,
    domainFlags: { cyber: false, space: false, deep: false, void: false },
    pulsePhase: 0,
  };
}

// ─── Grid tick — update substrate from simulation events ──────────────────────

function tickGrid(
  grid: CellState[],
  drones: Drone[],
  factions: Faction[],
  explosions: Explosion[],
  cellW: number,
  cellH: number,
): WorldScar[] {
  const newScars: WorldScar[] = [];

  // 1. Drone influence deposit + traffic
  for (const drone of drones) {
    const col = clamp(Math.floor(drone.pos.x / cellW), 0, GRID_COLS - 1);
    const row = clamp(Math.floor(drone.pos.y / cellH), 0, GRID_ROWS - 1);
    const idx = row * GRID_COLS + col;
    const faction = factions[drone.factionId];
    grid[idx].influence[drone.factionId] = Math.min(
      1,
      grid[idx].influence[drone.factionId] +
        drone.activation * 0.03 * faction.coherence,
    );
    grid[idx].traffic = Math.min(1, grid[idx].traffic + 0.01);
    grid[idx].lawDensity = Math.min(
      1,
      grid[idx].lawDensity + faction.lawsFired * 0.0002,
    );
  }

  // 2. Influence spreading (diffusion with faction expansion rate)
  const tempInf: number[][] = grid.map((c) => [...c.influence]);
  for (let row = 0; row < GRID_ROWS; row++) {
    for (let col = 0; col < GRID_COLS; col++) {
      const idx = row * GRID_COLS + col;
      const neighbors: number[] = [];
      if (row > 0) neighbors.push((row - 1) * GRID_COLS + col);
      if (row < GRID_ROWS - 1) neighbors.push((row + 1) * GRID_COLS + col);
      if (col > 0) neighbors.push(row * GRID_COLS + (col - 1));
      if (col < GRID_COLS - 1) neighbors.push(row * GRID_COLS + (col + 1));

      for (let f = 0; f < NUM_FACTIONS; f++) {
        const spread =
          factions[f].coherence * factions[f].dna.expansionRate * 0.01;
        const self = grid[idx].influence[f];
        for (const nIdx of neighbors) {
          const diff = self - grid[nIdx].influence[f];
          if (diff > 0)
            tempInf[nIdx][f] = Math.min(1, tempInf[nIdx][f] + diff * spread);
        }
      }
    }
  }

  // 3. Apply spread + decay + derive biome/material
  for (let row = 0; row < GRID_ROWS; row++) {
    for (let col = 0; col < GRID_COLS; col++) {
      const idx = row * GRID_COLS + col;
      const cell = grid[idx];
      const prevDominant = cell.dominant;

      for (let f = 0; f < NUM_FACTIONS; f++) {
        cell.influence[f] = Math.min(1, tempInf[idx][f] * 0.9978);
      }
      cell.traffic *= 0.997;
      cell.lawDensity *= 0.999;
      cell.memoryDensity *= 0.9995;
      cell.conflictPressure *= 0.94;
      cell.damage = Math.max(0, cell.damage - 0.0002);

      computeCellDominant(cell);

      if (cell.dominant === prevDominant && cell.dominant >= 0) {
        cell.dominanceAge = Math.min(300, cell.dominanceAge + 1);
      } else if (cell.dominant !== prevDominant) {
        cell.dominanceAge = 0;
        cell.material = "fluid";
      }

      cell.stability = computeStability(cell);
      cell.material = computeMaterial(cell);
      cell.biome = deriveBiome(
        cell,
        cell.dominant >= 0 ? factions[cell.dominant] : null,
      );
    }
  }

  // 4. Scar deposition from explosions
  for (const explosion of explosions) {
    if (explosion.pHit > 0.25 && Math.random() < 0.12) {
      const col = clamp(Math.floor(explosion.pos.x / cellW), 0, GRID_COLS - 1);
      const row = clamp(Math.floor(explosion.pos.y / cellH), 0, GRID_ROWS - 1);
      const idx = row * GRID_COLS + col;
      grid[idx].damage = Math.min(1, grid[idx].damage + explosion.pHit * 0.12);
      grid[idx].memoryDensity = Math.min(1, grid[idx].memoryDensity + 0.07);
      grid[idx].conflictPressure = Math.min(
        1,
        grid[idx].conflictPressure + 0.18,
      );
      grid[idx].battleCount++;
      newScars.push({
        col,
        row,
        worldX: explosion.pos.x,
        worldY: explosion.pos.y,
        intensity: explosion.pHit * 0.85,
        radius: explosion.maxRadius * 0.9,
        age: 0,
        type: explosion.pHit > 0.65 ? "battle" : "ruin",
        factionId: explosion.factionId,
      });
    }
  }

  return newScars;
}

// ─── Infrastructure generation — emerges from repeated activity ───────────────

function updateInfrastructure(
  grid: CellState[],
  _factions: Faction[],
  infraObjects: InfraObject[],
  cellW: number,
  cellH: number,
  worldAge: number,
): InfraObject[] {
  const result = [...infraObjects];

  // Only check every 25 ticks
  if (worldAge % 25 !== 0) {
    // Just mature existing objects
    for (const obj of result) {
      if (obj.type === "hub") obj.maturity = Math.min(1, obj.maturity + 0.015);
      if (obj.type === "route")
        obj.maturity = Math.min(1, obj.maturity + 0.008);
      if (obj.type === "fortress")
        obj.maturity = Math.min(1, obj.maturity + 0.005);
    }
    return result;
  }

  // Spawn new outpost hubs where law density × dominance age is high
  for (let row = 1; row < GRID_ROWS - 1; row++) {
    for (let col = 1; col < GRID_COLS - 1; col++) {
      const cell = grid[row * GRID_COLS + col];
      if (cell.dominant < 0) continue;
      if (cell.lawDensity * cell.dominanceAge < 18) continue;

      const worldX = (col + 0.5) * cellW;
      const worldY = (row + 0.5) * cellH;
      const tooClose = result.some(
        (o) =>
          o.type === "hub" &&
          o.faction === cell.dominant &&
          Math.hypot(o.worldX - worldX, o.worldY - worldY) < cellW * 4.5,
      );
      if (tooClose) continue;

      const factionHubCount = result.filter(
        (o) => o.type === "hub" && o.faction === cell.dominant,
      ).length;
      if (factionHubCount >= 4) continue;

      result.push({
        type: "hub",
        col,
        row,
        worldX,
        worldY,
        faction: cell.dominant,
        maturity: 0.1,
        lawCount: Math.round(cell.lawDensity * cell.dominanceAge),
      });
    }
  }

  // Spawn fortresses at contested cells with high conflict pressure
  for (let row = 1; row < GRID_ROWS - 1; row++) {
    for (let col = 1; col < GRID_COLS - 1; col++) {
      const cell = grid[row * GRID_COLS + col];
      if (cell.dominant >= 0) continue;
      if (cell.conflictPressure < 0.35 || cell.battleCount < 3) continue;

      const worldX = (col + 0.5) * cellW;
      const worldY = (row + 0.5) * cellH;
      const exists = result.some(
        (o) =>
          o.type === "fortress" &&
          Math.hypot(o.worldX - worldX, o.worldY - worldY) < cellW * 3,
      );
      if (!exists && result.filter((o) => o.type === "fortress").length < 8) {
        const dominantNearby = grid
          .slice(
            Math.max(0, (row - 1) * GRID_COLS + col - 1),
            Math.min(grid.length, (row + 2) * GRID_COLS + col + 2),
          )
          .reduce(
            (best, c) =>
              c.dominanceStrength > best.str
                ? { id: c.dominant, str: c.dominanceStrength }
                : best,
            { id: -1, str: 0 },
          );
        result.push({
          type: "fortress",
          col,
          row,
          worldX,
          worldY,
          faction: dominantNearby.id,
          maturity: 0.0,
          lawCount: cell.battleCount,
        });
      }
    }
  }

  // Connect hubs of same faction with routes (if not too far apart)
  const hubs = result.filter((o) => o.type === "hub" && o.maturity > 0.35);
  for (let i = 0; i < hubs.length; i++) {
    for (let j = i + 1; j < hubs.length; j++) {
      if (hubs[i].faction !== hubs[j].faction) continue;
      const d = Math.hypot(
        hubs[i].worldX - hubs[j].worldX,
        hubs[i].worldY - hubs[j].worldY,
      );
      if (d > cellW * 14) continue;
      const routeExists = result.some(
        (o) =>
          o.type === "route" &&
          ((o.col === hubs[i].col &&
            o.row === hubs[i].row &&
            o.toCol === hubs[j].col) ||
            (o.col === hubs[j].col &&
              o.row === hubs[j].row &&
              o.toCol === hubs[i].col)),
      );
      if (
        !routeExists &&
        result.filter((o) => o.type === "route").length < 40
      ) {
        result.push({
          type: "route",
          col: hubs[i].col,
          row: hubs[i].row,
          worldX: hubs[i].worldX,
          worldY: hubs[i].worldY,
          toCol: hubs[j].col,
          toRow: hubs[j].row,
          toWorldX: hubs[j].worldX,
          toWorldY: hubs[j].worldY,
          faction: hubs[i].faction,
          maturity: 0,
          lawCount: 0,
        });
      }
    }
  }

  // Mature all existing objects
  for (const obj of result) {
    if (obj.type === "hub") obj.maturity = Math.min(1, obj.maturity + 0.015);
    if (obj.type === "route") obj.maturity = Math.min(1, obj.maturity + 0.008);
    if (obj.type === "fortress")
      obj.maturity = Math.min(1, obj.maturity + 0.005);
  }

  return result.slice(0, 120); // cap total objects
}

// ─── Main world tick ───────────────────────────────────────────────────────────

export function tickWorld(
  state: WorldState,
  dt: number,
  canvasWidth: number,
  canvasHeight: number,
): WorldState {
  const Δt = dt / 1000;
  const newTime = state.time + dt;
  const beat = Math.floor(newTime / BEAT_MS);
  const pulsePhase = (2 * Math.PI * (newTime % BEAT_MS)) / BEAT_MS;
  const worldAge = state.worldAge + 1;
  const era: WorldState["era"] =
    worldAge < 300 ? "early" : worldAge < 900 ? "mid" : "late";

  // ── Faction coherence evolution ─────────────────────────────────────────────
  const factions = state.factions.map((f) => {
    const drift = (Math.random() - 0.49) * 0.004;
    const lawBonus = f.lawsFired * 0.0001;
    const newCoherence = clamp(f.coherence + drift + lawBonus, 0.45, 1.0);
    const territory =
      BASE_TERRITORY + newCoherence * (MAX_TERRITORY - BASE_TERRITORY);
    const driveMode: Faction["driveMode"] =
      newCoherence >= 0.92
        ? "Execution"
        : newCoherence >= 0.84
          ? "Exploration"
          : newCoherence >= 0.78
            ? "Learning"
            : "Rest";
    return {
      ...f,
      coherence: newCoherence,
      territory,
      driveMode,
      actionAttack: clamp(f.actionAttack + (Math.random() - 0.5) * 0.02, 0, 1),
      actionEvade: clamp(f.actionEvade + (Math.random() - 0.5) * 0.015, 0, 1),
      actionRetreat: clamp(
        f.actionRetreat + (Math.random() - 0.5) * 0.01,
        0,
        1,
      ),
    };
  });

  // ── Boid simulation ────────────────────────────────────────────────────────
  const newSparks: Spark[] = [];
  const newExplosions: Explosion[] = [];

  const drones = state.drones.map((drone) => {
    const faction = factions[drone.factionId];
    const allies = state.drones.filter(
      (d) => d.id !== drone.id && d.factionId === drone.factionId,
    );
    const enemies = state.drones.filter((d) => d.factionId !== drone.factionId);

    const k1 = K1_SEP * (1 + faction.actionEvade * 1.2);
    const k3 = K3_COH * (1 + faction.actionAttack * 1.4);
    const k4 = K4_ATK * (faction.actionAttack > 0.7 ? 1.8 : 0.5);

    // Separation
    let fs: Vec2 = { x: 0, y: 0 };
    for (const other of state.drones) {
      if (other.id === drone.id) continue;
      const d = dist(drone.pos, other.pos);
      if (d < SEP_RADIUS && d > 0)
        fs = add(fs, scale(norm(sub(drone.pos, other.pos)), 1 / (d + 0.1)));
    }

    // Alignment
    let fa: Vec2 = { x: 0, y: 0 };
    let alnCount = 0;
    for (const ally of allies) {
      if (dist(drone.pos, ally.pos) < ALN_RADIUS) {
        fa = add(fa, ally.vel);
        alnCount++;
      }
    }
    if (alnCount > 0) fa = scale(fa, 1 / alnCount);

    // Cohesion
    let fc: Vec2 = { x: 0, y: 0 };
    let centroid: Vec2 = { x: 0, y: 0 };
    let cohCount = 0;
    for (const ally of allies) {
      if (dist(drone.pos, ally.pos) < COH_RADIUS) {
        centroid = add(centroid, ally.pos);
        cohCount++;
      }
    }
    if (cohCount > 0) {
      centroid = scale(centroid, 1 / cohCount);
      fc = norm(sub(centroid, drone.pos));
    }
    if (faction.actionRetreat > 0.5) {
      const homeDir = norm(sub(faction.basePos, drone.pos));
      fc = add(scale(fc, 0.4), scale(homeDir, 0.6 * faction.actionRetreat));
    }

    // Attack
    let fattack: Vec2 = { x: 0, y: 0 };
    let nearestEnemy: Drone | null = null;
    let nearestDist = Number.POSITIVE_INFINITY;
    for (const e of enemies) {
      const d = dist(drone.pos, e.pos);
      if (d < nearestDist) {
        nearestDist = d;
        nearestEnemy = e;
      }
    }
    if (nearestEnemy && nearestDist < COH_RADIUS * 1.8)
      fattack = norm(sub(nearestEnemy.pos, drone.pos));

    // Integrate
    const force = add(
      add(scale(fs, k1), scale(fa, K2_ALN)),
      add(scale(fc, k3), scale(fattack, k4)),
    );
    let vel = add(drone.vel, scale(force, Δt));
    const speed = mag(vel);
    if (speed > MAX_SPEED) vel = scale(vel, MAX_SPEED / speed);

    const margin = 20;
    let pos = add(drone.pos, vel);
    if (pos.x < margin) {
      pos.x = margin;
      vel.x = Math.abs(vel.x);
    }
    if (pos.x > canvasWidth - margin) {
      pos.x = canvasWidth - margin;
      vel.x = -Math.abs(vel.x);
    }
    if (pos.y < margin) {
      pos.y = margin;
      vel.y = Math.abs(vel.y);
    }
    if (pos.y > canvasHeight - margin) {
      pos.y = canvasHeight - margin;
      vel.y = -Math.abs(vel.y);
    }

    // Hebbian sparks
    for (const ally of allies) {
      if (ally.id <= drone.id) continue;
      const d = dist(pos, ally.pos);
      if (d < HEBBIAN_RADIUS) {
        const deltaW = HEBBIAN_LR * drone.activation * ally.activation;
        if (deltaW > SPARK_THRESHOLD) {
          newSparks.push({
            fromPos: { ...pos },
            toPos: { ...ally.pos },
            intensity: deltaW * 200,
            opacity: Math.min(1, deltaW * 300),
            factionId: drone.factionId,
          });
        }
      }
    }

    // Engagement
    if (nearestEnemy && nearestDist < ENGAGE_RADIUS) {
      const pHit = clamp(
        drone.activation * (1 - nearestDist / ENGAGE_RADIUS),
        0,
        1,
      );
      if (Math.random() < pHit * 0.08) {
        const damage = Math.random() * pHit * drone.activation;
        newExplosions.push({
          pos: { ...nearestEnemy.pos },
          radius: 0,
          maxRadius: damage * 40 + 8,
          opacity: pHit,
          pHit,
          factionId: nearestEnemy.factionId,
        });
        factions[drone.factionId].lawsFired += 1;
      }
    }

    return {
      ...drone,
      pos,
      vel,
      activation: clamp(
        drone.activation + (Math.random() - 0.49) * 0.02,
        0.3,
        1.0,
      ),
    };
  });

  // ── Evolve sparks / explosions ─────────────────────────────────────────────
  const survivingSparks = state.sparks
    .map((s) => ({ ...s, opacity: s.opacity - 0.08 }))
    .filter((s) => s.opacity > 0);
  const allSparks = [...survivingSparks, ...newSparks].slice(-120);

  const survivingExplosions = state.explosions
    .map((e) => {
      const progress = e.radius / e.maxRadius;
      return {
        ...e,
        radius: e.radius + e.maxRadius * 0.08,
        opacity: e.opacity * (1 - progress) * 0.85,
      };
    })
    .filter((e) => e.opacity > 0.01 && e.radius < e.maxRadius * 1.1);
  const allExplosions = [...survivingExplosions, ...newExplosions].slice(-60);

  // ── Update grid substrate ───────────────────────────────────────────────────
  // Grid is mutated in place for performance
  const newScarDeposits = tickGrid(
    state.grid,
    drones,
    factions,
    allExplosions,
    state.cellW,
    state.cellH,
  );

  // ── Update scars (fade over time, never fully disappear) ───────────────────
  const agedScars = state.scars
    .map((s) => ({ ...s, age: s.age + 1, intensity: s.intensity * 0.9997 }))
    .filter((s) => s.intensity > 0.01);
  const allScars = [...agedScars, ...newScarDeposits].slice(-200);

  // ── Update infrastructure ──────────────────────────────────────────────────
  const infraObjects = updateInfrastructure(
    state.grid,
    factions,
    state.infraObjects,
    state.cellW,
    state.cellH,
    worldAge,
  );

  // ── Global state ────────────────────────────────────────────────────────────
  const newEscalation = clamp(
    state.escalation + newExplosions.length * 0.004,
    0,
    1,
  );
  const avgDamage =
    state.grid.reduce((s, c) => s + c.damage, 0) / state.grid.length;
  const avgMemory =
    state.grid.reduce((s, c) => s + c.memoryDensity, 0) / state.grid.length;

  return {
    ...state,
    beat,
    time: newTime,
    worldAge,
    era,
    pulsePhase,
    factions,
    drones,
    sparks: allSparks,
    explosions: allExplosions,
    scars: allScars,
    infraObjects,
    escalation: newEscalation,
    globalMemory: avgMemory,
    globalDamage: avgDamage,
    domainFlags: {
      cyber: newEscalation > 0.4,
      space: newEscalation > 0.7,
      deep: avgMemory > 0.15,
      void: avgDamage > 0.15,
    },
  };
}

// ─── Color helpers ─────────────────────────────────────────────────────────────

export function factionHue(factionId: number): number {
  return FACTION_DNA[factionId % NUM_FACTIONS]?.hue ?? (factionId * 36) % 360;
}

export function factionColor(coherence: number, alpha = 1): string {
  const r = 255;
  const g = Math.round(30 + coherence * 180);
  const b = Math.round(30 * (1 - coherence));
  return `rgba(${r},${g},${b},${alpha})`;
}

export function factionDroneColor(factionId: number, alpha = 1): string {
  return `hsla(${factionHue(factionId)},80%,65%,${alpha})`;
}

export function factionTerritoryColor(
  factionId: number,
  strength: number,
): string {
  const hue = factionHue(factionId);
  const opacity = 0.08 + strength * 0.38;
  return `hsla(${hue},65%,58%,${opacity})`;
}

export function biomeOverlayColor(biome: BiomeType, pulse: number): string {
  switch (biome) {
    case "crystalline":
      return `rgba(160,220,255,${0.12 + pulse * 0.04})`;
    case "storm":
      return `rgba(35,8,65,${0.38 + pulse * 0.1})`;
    case "fog":
      return `rgba(175,175,200,${0.2 + pulse * 0.05})`;
    case "radiant":
      return `rgba(255,220,50,${0.18 + pulse * 0.08})`;
    case "fractured":
      return `rgba(140,18,28,${0.22 + pulse * 0.08})`;
    case "dead":
      return "rgba(4,4,8,0.58)";
    case "void":
      return `rgba(55,0,100,${0.48 + pulse * 0.12})`;
    default:
      return "transparent";
  }
}
