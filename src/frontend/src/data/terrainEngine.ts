// ═══════════════════════════════════════════════════════════════════════════════
// TERRAIN ENGINE — Procedural Terrain Generation, Erosion & Biome Classification
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Core Terrain Types ───────────────────────────────────────────────────────

export type BiomeType =
  | "void"
  | "deep_ocean"
  | "ocean"
  | "coastal"
  | "beach"
  | "wetland"
  | "grassland"
  | "shrubland"
  | "forest"
  | "dense_forest"
  | "highland"
  | "tundra"
  | "alpine"
  | "mountain"
  | "peak"
  | "volcanic"
  | "desert"
  | "mesa"
  | "badlands"
  | "anomaly_zone";

export type TerrainFeatureType =
  | "ruin"
  | "obelisk"
  | "crater"
  | "rift"
  | "vein"
  | "hotspring"
  | "ancient_tree"
  | "collapsed_tunnel"
  | "signal_tower"
  | "crystal_spire"
  | "sinkhole"
  | "ford";

export type RiverStage = "source" | "tributary" | "main" | "delta" | "dry";

export type ElevationLayer =
  | "below_sea"
  | "sea_level"
  | "lowland"
  | "midland"
  | "highland"
  | "mountain"
  | "peak";

// ─── Data Structures ──────────────────────────────────────────────────────────

export interface TerrainCell {
  x: number;
  y: number;
  elevation: number; // 0-1 normalized
  moisture: number; // 0-1
  temperature: number; // 0-1
  erosionFactor: number; // 0-1: how much erosion has occurred
  biome: BiomeType;
  elevationLayer: ElevationLayer;
  features: TerrainFeatureType[];
  riverFlow: number; // 0-1: 0 = dry, 1 = full river
  factionOverlay: number | null; // faction id that controls this cell
  fertility: number; // 0-1: agricultural potential
  rawDensity: number; // 0-1: FORMA raw material density
  color: string; // hex render color
  isPassable: boolean;
  movementCost: number; // 1-10, higher = slower traversal
}

export interface TerrainChunk {
  id: string;
  originX: number;
  originY: number;
  width: number;
  height: number;
  cells: TerrainCell[][];
  seed: number;
  generatedAt: number; // tick
  isDirty: boolean; // true if needs re-render
}

export interface HeightMap {
  width: number;
  height: number;
  data: Float32Array; // row-major, values 0-1
  minElevation: number;
  maxElevation: number;
  seaLevelRatio: number; // fraction of map below sea level
}

export interface TerrainFeature {
  id: string;
  type: TerrainFeatureType;
  x: number;
  y: number;
  radius: number;
  intensity: number; // 0-1
  lore: string;
  discoveredByFaction: number | null;
  discoveredAtTick: number | null;
  rawBonus: number; // FORMA extraction multiplier
}

export interface BiomeZone {
  biome: BiomeType;
  centerX: number;
  centerY: number;
  radius: number;
  transitionWidth: number;
  elevation: number; // dominant elevation in zone
  moisture: number;
}

export interface RiverPath {
  id: string;
  sourceX: number;
  sourceY: number;
  mouthX: number;
  mouthY: number;
  waypoints: Array<{ x: number; y: number; stage: RiverStage }>;
  width: number; // avg cell width in river
  flow: number; // 0-1 overall volume
  isDry: boolean;
}

export interface MountainRange {
  id: string;
  startX: number;
  startY: number;
  endX: number;
  endY: number;
  peakCount: number;
  avgElevation: number;
  width: number;
  ridgeCells: Array<{ x: number; y: number; elevation: number }>;
}

export interface TerrainGenerationConfig {
  width: number;
  height: number;
  seed: number;
  octaves: number;
  persistence: number; // 0-1: amplitude decay per octave
  lacunarity: number; // frequency multiplier per octave
  seaLevelCutoff: number; // 0-1: elevation below which is ocean
  erosionPasses: number;
  riverCount: number;
  mountainRangeCount: number;
  featureDensity: number; // 0-1
  anomalyChance: number; // 0-1
  factionTerrainIds: number[];
}

export interface TerrainSnapshot {
  config: TerrainGenerationConfig;
  heightMap: HeightMap;
  chunks: TerrainChunk[];
  features: TerrainFeature[];
  rivers: RiverPath[];
  mountains: MountainRange[];
  biomeZones: BiomeZone[];
  generatedAtTick: number;
}

// ─── Constants ────────────────────────────────────────────────────────────────

export const ELEVATION_THRESHOLDS: Record<ElevationLayer, [number, number]> = {
  below_sea: [0, 0.28],
  sea_level: [0.28, 0.32],
  lowland: [0.32, 0.44],
  midland: [0.44, 0.58],
  highland: [0.58, 0.7],
  mountain: [0.7, 0.84],
  peak: [0.84, 1.0],
};

export const BIOME_TRANSITION_TABLE: Record<BiomeType, string> = {
  void: "#050508",
  deep_ocean: "#0a1f3c",
  ocean: "#1a3a5c",
  coastal: "#2a5f7a",
  beach: "#d4b483",
  wetland: "#4a7c59",
  grassland: "#7ab648",
  shrubland: "#8fa94a",
  forest: "#2d7a3a",
  dense_forest: "#1a5c2a",
  highland: "#8fa050",
  tundra: "#b0b8a0",
  alpine: "#c8d0c0",
  mountain: "#8c7a6a",
  peak: "#dde0e4",
  volcanic: "#5c1a0a",
  desert: "#d4a020",
  mesa: "#b86030",
  badlands: "#8c3820",
  anomaly_zone: "#6a00b8",
};

export const TERRAIN_FEATURE_DENSITY: Record<TerrainFeatureType, number> = {
  ruin: 0.012,
  obelisk: 0.004,
  crater: 0.008,
  rift: 0.003,
  vein: 0.02,
  hotspring: 0.006,
  ancient_tree: 0.01,
  collapsed_tunnel: 0.007,
  signal_tower: 0.003,
  crystal_spire: 0.002,
  sinkhole: 0.009,
  ford: 0.015,
};

const FEATURE_LORE: Record<TerrainFeatureType, string[]> = {
  ruin: [
    "Ancient foundations of a civilization that predates recorded history.",
    "Crumbling walls that still hum faintly with residual FORMA energy.",
  ],
  obelisk: [
    "A monolith of unknown material, its surface covered in script no one can decode.",
    "The obelisk casts no shadow regardless of the sun's position.",
  ],
  crater: [
    "A massive impact hollow, its rim fused into glass by extreme heat.",
    "Anomalous readings suggest the crater was not made by any known meteor.",
  ],
  rift: [
    "A gash in the earth that descends beyond any plumb line's reach.",
    "Mist pours upward from the rift without ceasing.",
  ],
  vein: [
    "A rich seam of raw FORMA mineral visible through the broken ground.",
    "Organisms congregate near this vein, drawn by its emission frequency.",
  ],
  hotspring: [
    "Mineral-rich waters that grant peculiar clarity to those who drink from them.",
    "The spring's temperature never varies despite weather extremes.",
  ],
  ancient_tree: [
    "A tree wider than twenty men, its bark bearing marks of every era.",
    "Birds avoid this tree. Its canopy always faces magnetic north.",
  ],
  collapsed_tunnel: [
    "A passage that once connected two distant regions — now caved in.",
    "Faction scouts report sounds of movement deep within the collapse.",
  ],
  signal_tower: [
    "A decayed broadcast tower still emitting a signal on an uncharted frequency.",
    "The tower lights activate every twelve ticks with no power source found.",
  ],
  crystal_spire: [
    "A formation of crystalline columns that refract light into impossible spectra.",
    "The spire resonates with anomaly events kilometres away.",
  ],
  sinkhole: [
    "A sudden collapse that swallowed an entire settlement in a single night.",
    "The sinkhole is expanding at a rate of one metre per season.",
  ],
  ford: [
    "A shallow crossing where the river runs knee-deep over smooth bedrock.",
    "Factions have fought over this ford seven times in recorded history.",
  ],
};

// ─── Noise Functions ──────────────────────────────────────────────────────────

// Seeded pseudo-random using mulberry32
function mulberry32(seed: number): () => number {
  let s = seed >>> 0;
  return () => {
    s += 0x6d2b79f5;
    let t = s;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 0xffffffff;
  };
}

// Gradient vectors for simplex-like noise
const GRAD2: [number, number][] = [
  [1, 0],
  [-1, 0],
  [0, 1],
  [0, -1],
  [Math.SQRT1_2, Math.SQRT1_2],
  [-Math.SQRT1_2, Math.SQRT1_2],
  [Math.SQRT1_2, -Math.SQRT1_2],
  [-Math.SQRT1_2, -Math.SQRT1_2],
];

function buildPermTable(rng: () => number): Uint8Array {
  const perm = new Uint8Array(512);
  const base = Array.from({ length: 256 }, (_, i) => i);
  // Fisher-Yates shuffle
  for (let i = 255; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    [base[i], base[j]] = [base[j], base[i]];
  }
  for (let i = 0; i < 512; i++) perm[i] = base[i & 255];
  return perm;
}

export function simplex2D(x: number, y: number, perm: Uint8Array): number {
  const F2 = 0.5 * (Math.sqrt(3) - 1);
  const G2 = (3 - Math.sqrt(3)) / 6;

  const s = (x + y) * F2;
  const i = Math.floor(x + s);
  const j = Math.floor(y + s);

  const t = (i + j) * G2;
  const X0 = i - t;
  const Y0 = j - t;
  const x0 = x - X0;
  const y0 = y - Y0;

  const [i1, j1] = x0 > y0 ? [1, 0] : [0, 1];

  const x1 = x0 - i1 + G2;
  const y1 = y0 - j1 + G2;
  const x2 = x0 - 1 + 2 * G2;
  const y2 = y0 - 1 + 2 * G2;

  const ii = i & 255;
  const jj = j & 255;

  const gi0 = perm[ii + perm[jj]] % GRAD2.length;
  const gi1 = perm[ii + i1 + perm[jj + j1]] % GRAD2.length;
  const gi2 = perm[ii + 1 + perm[jj + 1]] % GRAD2.length;

  function contrib(gIdx: number, dx: number, dy: number): number {
    const t = 0.5 - dx * dx - dy * dy;
    if (t < 0) return 0;
    const [gx, gy] = GRAD2[gIdx];
    return t * t * t * t * (gx * dx + gy * dy);
  }

  return (
    70 * (contrib(gi0, x0, y0) + contrib(gi1, x1, y1) + contrib(gi2, x2, y2))
  );
}

export function octaveNoise(
  x: number,
  y: number,
  perm: Uint8Array,
  octaves: number,
  persistence: number,
  lacunarity: number,
): number {
  let value = 0;
  let amplitude = 1;
  let frequency = 1;
  let maxValue = 0;

  for (let o = 0; o < octaves; o++) {
    value += simplex2D(x * frequency, y * frequency, perm) * amplitude;
    maxValue += amplitude;
    amplitude *= persistence;
    frequency *= lacunarity;
  }

  return value / maxValue;
}

export function domainWarp(
  x: number,
  y: number,
  perm: Uint8Array,
  strength = 0.3,
  octaves = 2,
  persistence = 0.5,
  lacunarity = 2.0,
): number {
  const warpX =
    octaveNoise(x + 1.7, y + 9.2, perm, octaves, persistence, lacunarity) *
    strength;
  const warpY =
    octaveNoise(x + 8.3, y + 2.8, perm, octaves, persistence, lacunarity) *
    strength;
  return octaveNoise(
    x + warpX,
    y + warpY,
    perm,
    octaves + 1,
    persistence,
    lacunarity,
  );
}

// ─── Height Map Generation ────────────────────────────────────────────────────

export function generateHeightMap(config: TerrainGenerationConfig): HeightMap {
  const { width, height, seed, octaves, persistence, lacunarity } = config;
  const rng = mulberry32(seed);
  const perm = buildPermTable(rng);
  const data = new Float32Array(width * height);

  const scaleX = 3.5 / width;
  const scaleY = 3.5 / height;

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      let v = domainWarp(
        x * scaleX,
        y * scaleY,
        perm,
        0.4,
        octaves,
        persistence,
        lacunarity,
      );
      // normalize -1..1 to 0..1
      v = (v + 1) * 0.5;
      // apply radial falloff to create island-like shapes
      const cx = x / width - 0.5;
      const cy = y / height - 0.5;
      const dist = Math.sqrt(cx * cx + cy * cy) * 2;
      const falloff = Math.max(0, 1 - dist * dist);
      v = v * 0.7 + falloff * 0.3;
      data[y * width + x] = Math.max(0, Math.min(1, v));
    }
  }

  let minElevation = 1;
  let maxElevation = 0;
  let belowSea = 0;

  for (let i = 0; i < data.length; i++) {
    if (data[i] < minElevation) minElevation = data[i];
    if (data[i] > maxElevation) maxElevation = data[i];
    if (data[i] < config.seaLevelCutoff) belowSea++;
  }

  return {
    width,
    height,
    data,
    minElevation,
    maxElevation,
    seaLevelRatio: belowSea / data.length,
  };
}

// ─── Erosion ──────────────────────────────────────────────────────────────────

export function applyErosion(
  heightMap: HeightMap,
  passes: number,
  strength = 0.04,
): HeightMap {
  const { width, height, data } = heightMap;
  const out = new Float32Array(data);

  for (let pass = 0; pass < passes; pass++) {
    for (let y = 1; y < height - 1; y++) {
      for (let x = 1; x < width - 1; x++) {
        const idx = y * width + x;
        const h = out[idx];

        // compute steepest descent neighbour
        const neighbors = [
          out[(y - 1) * width + x],
          out[(y + 1) * width + x],
          out[y * width + (x - 1)],
          out[y * width + (x + 1)],
        ];
        const minNeighbor = Math.min(...neighbors);
        const diff = h - minNeighbor;
        if (diff > 0) {
          const sediment = diff * strength;
          out[idx] -= sediment;
          // deposit at lowest neighbor
          const minIdx = neighbors.indexOf(minNeighbor);
          const deposeCoords = [
            (y - 1) * width + x,
            (y + 1) * width + x,
            y * width + (x - 1),
            y * width + (x + 1),
          ];
          out[deposeCoords[minIdx]] += sediment * 0.5;
        }
      }
    }
  }

  // clamp
  for (let i = 0; i < out.length; i++) {
    out[i] = Math.max(0, Math.min(1, out[i]));
  }

  return { ...heightMap, data: out };
}

// ─── Elevation Layer Classification ───────────────────────────────────────────

export function classifyElevationLayer(elevation: number): ElevationLayer {
  for (const [layer, [lo, hi]] of Object.entries(ELEVATION_THRESHOLDS) as [
    ElevationLayer,
    [number, number],
  ][]) {
    if (elevation >= lo && elevation < hi) return layer;
  }
  return "peak";
}

// ─── Biome Classification ─────────────────────────────────────────────────────

export function classifyBiomes(
  cells: TerrainCell[][],
  _heightMap: HeightMap,
  config: TerrainGenerationConfig,
): void {
  const rng = mulberry32(config.seed ^ 0xdeadbeef);
  const perm = buildPermTable(rng);
  const { width, height } = config;
  const moistureScale = 2.8 / width;

  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      const cell = cells[y][x];
      const elev = cell.elevation;
      const layer = classifyElevationLayer(elev);
      cell.elevationLayer = layer;

      // moisture derived from a separate noise field
      const rawMoisture = octaveNoise(
        x * moistureScale + 100,
        y * moistureScale + 100,
        perm,
        3,
        0.5,
        2.0,
      );
      cell.moisture = Math.max(0, Math.min(1, (rawMoisture + 1) * 0.5));

      // temperature decreases with elevation and latitude
      const latitudeFactor = 1 - Math.abs(y / height - 0.5) * 2;
      cell.temperature = Math.max(
        0,
        Math.min(1, latitudeFactor * (1 - elev * 0.6)),
      );

      cell.biome = deriveBiome(
        layer,
        cell.moisture,
        cell.temperature,
        config.anomalyChance,
        rng,
      );
      cell.color = getTerrainColor(cell.biome, elev);
      cell.fertility = computeFertility(cell);
      cell.rawDensity = computeRawDensity(cell, elev);
      cell.isPassable = isPassable(cell.biome);
      cell.movementCost = computeMovementCost(cell.biome, elev);
    }
  }
}

function deriveBiome(
  layer: ElevationLayer,
  moisture: number,
  temperature: number,
  anomalyChance: number,
  rng: () => number,
): BiomeType {
  if (rng() < anomalyChance * 0.03) return "anomaly_zone";

  switch (layer) {
    case "below_sea":
      return moisture > 0.8 ? "deep_ocean" : "ocean";
    case "sea_level":
      return moisture > 0.6 ? "coastal" : "beach";
    case "lowland":
      if (temperature < 0.25) return "tundra";
      if (moisture > 0.7) return "wetland";
      if (moisture > 0.4) return "forest";
      return "grassland";
    case "midland":
      if (temperature < 0.2) return "tundra";
      if (moisture > 0.65) return "dense_forest";
      if (moisture > 0.35) return "forest";
      if (temperature > 0.75 && moisture < 0.25) return "desert";
      return "shrubland";
    case "highland":
      if (temperature < 0.25) return "alpine";
      if (moisture < 0.2 && temperature > 0.6) return "mesa";
      if (moisture < 0.3) return "badlands";
      return "highland";
    case "mountain":
      if (temperature < 0.15) return "alpine";
      if (temperature > 0.8) return "volcanic";
      return "mountain";
    case "peak":
      return temperature > 0.85 ? "volcanic" : "peak";
  }
}

function computeFertility(cell: TerrainCell): number {
  if (
    ["deep_ocean", "ocean", "peak", "volcanic", "anomaly_zone"].includes(
      cell.biome,
    )
  )
    return 0;
  const base =
    cell.moisture * 0.5 +
    (1 - Math.abs(cell.temperature - 0.5) * 2) * 0.3 +
    (1 - cell.elevation) * 0.2;
  return Math.max(0, Math.min(1, base));
}

function computeRawDensity(cell: TerrainCell, elev: number): number {
  // veins tend toward mountain/highland zones with high elevation
  const elevBonus = elev > 0.6 ? (elev - 0.6) * 1.5 : 0;
  const anomalyBonus = cell.biome === "anomaly_zone" ? 0.4 : 0;
  return Math.max(
    0,
    Math.min(1, elevBonus + anomalyBonus + Math.random() * 0.1),
  );
}

function isPassable(biome: BiomeType): boolean {
  return !["deep_ocean", "ocean", "peak", "volcanic"].includes(biome);
}

function computeMovementCost(biome: BiomeType, elev: number): number {
  const costMap: Partial<Record<BiomeType, number>> = {
    deep_ocean: 10,
    ocean: 10,
    coastal: 7,
    peak: 9,
    volcanic: 8,
    mountain: 6,
    alpine: 5,
    dense_forest: 4,
    forest: 3,
    wetland: 5,
    badlands: 4,
    desert: 3,
    anomaly_zone: 6,
  };
  const base = costMap[biome] ?? 2;
  return Math.round(Math.min(10, base + elev * 2));
}

// ─── Mountain Range Placement ─────────────────────────────────────────────────

export function placeMountainRanges(
  cells: TerrainCell[][],
  heightMap: HeightMap,
  config: TerrainGenerationConfig,
): MountainRange[] {
  const rng = mulberry32(config.seed ^ 0xc0ffee);
  const ranges: MountainRange[] = [];
  const { width, height } = config;

  for (let r = 0; r < config.mountainRangeCount; r++) {
    const startX = Math.floor(rng() * width);
    const startY = Math.floor(rng() * height);
    const angle = rng() * Math.PI;
    const length = Math.floor(rng() * (width * 0.3) + width * 0.1);
    const rangeWidth = Math.floor(rng() * 6) + 4;
    const peakCount = Math.floor(rng() * 4) + 2;

    const endX = Math.round(startX + Math.cos(angle) * length);
    const endY = Math.round(startY + Math.sin(angle) * length);

    const ridgeCells: MountainRange["ridgeCells"] = [];
    const steps = length;

    for (let s = 0; s <= steps; s++) {
      const t = s / steps;
      const rx = Math.round(startX + (endX - startX) * t);
      const ry = Math.round(startY + (endY - startY) * t);

      // raise elevation across range width
      for (let dw = -rangeWidth; dw <= rangeWidth; dw++) {
        for (let dd = -rangeWidth; dd <= rangeWidth; dd++) {
          const nx = rx + dw;
          const ny = ry + dd;
          if (nx < 0 || nx >= width || ny < 0 || ny >= height) continue;
          const dist = Math.sqrt(dw * dw + dd * dd);
          const falloff = Math.max(0, 1 - dist / rangeWidth);
          const peakFactor = isPeakPoint(s, steps, peakCount) ? 0.35 : 0.18;
          const boost = falloff * peakFactor;
          const idx = ny * width + nx;
          heightMap.data[idx] = Math.min(1, heightMap.data[idx] + boost);
          cells[ny][nx].elevation = heightMap.data[idx];
        }
      }

      ridgeCells.push({
        x: rx,
        y: ry,
        elevation: heightMap.data[ry * width + rx] ?? 0.7,
      });
    }

    ranges.push({
      id: `mtn_${r}`,
      startX,
      startY,
      endX,
      endY,
      peakCount,
      avgElevation: 0.72 + rng() * 0.18,
      width: rangeWidth,
      ridgeCells,
    });
  }

  return ranges;
}

function isPeakPoint(
  step: number,
  totalSteps: number,
  peakCount: number,
): boolean {
  for (let p = 0; p < peakCount; p++) {
    const peakStep = Math.floor(((p + 1) / (peakCount + 1)) * totalSteps);
    if (Math.abs(step - peakStep) <= 2) return true;
  }
  return false;
}

// ─── River Carving ────────────────────────────────────────────────────────────

export function carveRivers(
  cells: TerrainCell[][],
  heightMap: HeightMap,
  config: TerrainGenerationConfig,
): RiverPath[] {
  const rng = mulberry32(config.seed ^ 0xabcd1234);
  const { width, height } = config;
  const rivers: RiverPath[] = [];

  for (let r = 0; r < config.riverCount; r++) {
    // pick a high-elevation source
    let sx: number;
    let sy: number;
    let attempts = 0;
    do {
      sx = Math.floor(rng() * width);
      sy = Math.floor(rng() * height);
      attempts++;
    } while (heightMap.data[sy * width + sx] < 0.58 && attempts < 100);

    const waypoints: RiverPath["waypoints"] = [
      { x: sx, y: sy, stage: "source" },
    ];
    let cx = sx;
    let cy = sy;
    let steps = 0;
    const maxSteps = width + height;

    while (steps < maxSteps) {
      const neighbors: Array<{ x: number; y: number; elev: number }> = [];
      for (const [dx, dy] of [
        [-1, 0],
        [1, 0],
        [0, -1],
        [0, 1],
        [-1, -1],
        [1, 1],
        [-1, 1],
        [1, -1],
      ]) {
        const nx = cx + dx;
        const ny = cy + dy;
        if (nx < 0 || nx >= width || ny < 0 || ny >= height) continue;
        neighbors.push({ x: nx, y: ny, elev: heightMap.data[ny * width + nx] });
      }

      // flow toward lowest neighbor, with small random nudge
      const sorted = neighbors.sort(
        (a, b) => a.elev - b.elev + (rng() - 0.5) * 0.05,
      );
      const next = sorted[0];

      if (!next || next.elev >= heightMap.data[cy * width + cx]) break;

      cx = next.x;
      cy = next.y;
      const stage: RiverStage =
        next.elev > 0.55 ? "tributary" : next.elev > 0.32 ? "main" : "delta";

      waypoints.push({ x: cx, y: cy, stage });

      // apply river to cell
      const cell = cells[cy][cx];
      cell.riverFlow = Math.min(1, cell.riverFlow + 0.1 + steps * 0.001);
      cell.moisture = Math.min(1, cell.moisture + 0.15);
      if (["deep_ocean", "ocean"].includes(cell.biome)) break;

      steps++;
    }

    const flow = 0.3 + rng() * 0.7;
    rivers.push({
      id: `riv_${r}`,
      sourceX: sx,
      sourceY: sy,
      mouthX: cx,
      mouthY: cy,
      waypoints,
      width: Math.floor(flow * 3) + 1,
      flow,
      isDry: flow < 0.2,
    });
  }

  return rivers;
}

// ─── Terrain Feature Placement ────────────────────────────────────────────────

export function computeTerrainFeatures(
  cells: TerrainCell[][],
  config: TerrainGenerationConfig,
  _currentTick: number,
): TerrainFeature[] {
  const rng = mulberry32(config.seed ^ 0xfeeb1e);
  const features: TerrainFeature[] = [];
  const { width, height } = config;
  let fid = 0;

  for (const [type, baseDensity] of Object.entries(TERRAIN_FEATURE_DENSITY) as [
    TerrainFeatureType,
    number,
  ][]) {
    const adjustedDensity = baseDensity * config.featureDensity;
    const count = Math.floor(width * height * adjustedDensity);

    for (let i = 0; i < count; i++) {
      const x = Math.floor(rng() * width);
      const y = Math.floor(rng() * height);
      const cell = cells[y]?.[x];
      if (!cell || !cell.isPassable) continue;

      const loreOptions = FEATURE_LORE[type];
      const lore = loreOptions[Math.floor(rng() * loreOptions.length)];

      const feature: TerrainFeature = {
        id: `feat_${fid++}`,
        type,
        x,
        y,
        radius: Math.floor(rng() * 3) + 1,
        intensity: 0.3 + rng() * 0.7,
        lore,
        discoveredByFaction: null,
        discoveredAtTick: null,
        rawBonus:
          type === "vein"
            ? 1.5 + rng() * 1.5
            : type === "crystal_spire"
              ? 2.0 + rng()
              : 1.0,
      };

      cell.features.push(type);
      cell.rawDensity = Math.min(1, cell.rawDensity + feature.rawBonus * 0.1);
      features.push(feature);
    }
  }

  return features;
}

// ─── Faction Terrain Overlay ──────────────────────────────────────────────────

export function overlayFactionTerrain(
  cells: TerrainCell[][],
  factionId: number,
  controlledCoords: Array<{ x: number; y: number }>,
  width: number,
  height: number,
): void {
  for (const { x, y } of controlledCoords) {
    if (x < 0 || x >= width || y < 0 || y >= height) continue;
    const cell = cells[y][x];
    if (cell.isPassable) {
      cell.factionOverlay = factionId;
    }
  }
}

// ─── Rendering Helpers ────────────────────────────────────────────────────────

export function getTerrainColor(biome: BiomeType, elevation: number): string {
  const base = BIOME_TRANSITION_TABLE[biome] ?? "#555555";
  // Slightly brighten peaks, darken valleys
  return blendTerrainColors(
    base,
    elevation > 0.75 ? "#ffffff" : "#000000",
    elevation > 0.75 ? (elevation - 0.75) * 0.6 : (0.35 - elevation) * 0.15,
  );
}

export function blendTerrainColors(
  colorA: string,
  colorB: string,
  t: number,
): string {
  const clampT = Math.max(0, Math.min(1, t));
  const parse = (hex: string) => {
    const h = hex.replace("#", "");
    return [
      Number.parseInt(h.substring(0, 2), 16),
      Number.parseInt(h.substring(2, 4), 16),
      Number.parseInt(h.substring(4, 6), 16),
    ];
  };
  const toHex = (n: number) => Math.round(n).toString(16).padStart(2, "0");
  const [r1, g1, b1] = parse(colorA);
  const [r2, g2, b2] = parse(colorB);
  return `#${toHex(r1 + (r2 - r1) * clampT)}${toHex(g1 + (g2 - g1) * clampT)}${toHex(b1 + (b2 - b1) * clampT)}`;
}

export function renderTerrainCell(cell: TerrainCell): string {
  const base = cell.color;
  if (cell.riverFlow > 0.1)
    return blendTerrainColors(base, "#3a7fc1", cell.riverFlow * 0.7);
  if (cell.factionOverlay !== null)
    return blendTerrainColors(base, "#ffffff", 0.12);
  if (cell.biome === "anomaly_zone")
    return blendTerrainColors(base, "#9b00ff", 0.3);
  return base;
}

// ─── Cell Grid Initialiser ────────────────────────────────────────────────────

function initCells(
  config: TerrainGenerationConfig,
  heightMap: HeightMap,
): TerrainCell[][] {
  const { width, height } = config;
  const cells: TerrainCell[][] = [];

  for (let y = 0; y < height; y++) {
    cells[y] = [];
    for (let x = 0; x < width; x++) {
      const elevation = heightMap.data[y * width + x];
      cells[y][x] = {
        x,
        y,
        elevation,
        moisture: 0,
        temperature: 0,
        erosionFactor: 0,
        biome: "void",
        elevationLayer: "below_sea",
        features: [],
        riverFlow: 0,
        factionOverlay: null,
        fertility: 0,
        rawDensity: 0,
        color: "#050508",
        isPassable: false,
        movementCost: 10,
      };
    }
  }

  return cells;
}

// ─── TerrainGenerator Class ───────────────────────────────────────────────────

export class TerrainGenerator {
  private config: TerrainGenerationConfig;
  private snapshot: TerrainSnapshot | null = null;

  constructor(config: TerrainGenerationConfig) {
    this.config = config;
  }

  generate(tick = 0): TerrainSnapshot {
    const heightMap = generateHeightMap(this.config);
    const eroded = applyErosion(heightMap, this.config.erosionPasses);
    const cells = initCells(this.config, eroded);

    classifyBiomes(cells, eroded, this.config);

    const mountains = placeMountainRanges(cells, eroded, this.config);
    // re-classify biomes after mountain boost
    classifyBiomes(cells, eroded, this.config);

    const rivers = carveRivers(cells, eroded, this.config);
    const features = computeTerrainFeatures(cells, this.config, tick);

    const chunk: TerrainChunk = {
      id: "chunk_main",
      originX: 0,
      originY: 0,
      width: this.config.width,
      height: this.config.height,
      cells,
      seed: this.config.seed,
      generatedAt: tick,
      isDirty: false,
    };

    const biomeZones = this.deriveBiomeZones(cells);

    this.snapshot = {
      config: this.config,
      heightMap: eroded,
      chunks: [chunk],
      features,
      rivers,
      mountains,
      biomeZones,
      generatedAtTick: tick,
    };

    return this.snapshot;
  }

  tick(
    currentTick: number,
    factionUpdates: Array<{
      factionId: number;
      coords: Array<{ x: number; y: number }>;
    }> = [],
  ): void {
    if (!this.snapshot) return;

    // apply faction overlays
    for (const update of factionUpdates) {
      for (const chunk of this.snapshot.chunks) {
        overlayFactionTerrain(
          chunk.cells,
          update.factionId,
          update.coords,
          this.config.width,
          this.config.height,
        );
        chunk.isDirty = true;
      }
    }

    // periodic erosion micro-tick (every 30 ticks)
    if (currentTick % 30 === 0) {
      this.snapshot.heightMap = applyErosion(this.snapshot.heightMap, 1, 0.01);
      for (const chunk of this.snapshot.chunks) {
        for (let y = 0; y < this.config.height; y++) {
          for (let x = 0; x < this.config.width; x++) {
            const cell = chunk.cells[y][x];
            const newElev =
              this.snapshot.heightMap.data[y * this.config.width + x];
            cell.erosionFactor += (cell.elevation - newElev) * 0.5;
            cell.elevation = newElev;
          }
        }
        chunk.isDirty = true;
      }
    }
  }

  getSnapshot(): TerrainSnapshot | null {
    return this.snapshot;
  }

  getCell(x: number, y: number): TerrainCell | null {
    if (!this.snapshot) return null;
    const chunk = this.snapshot.chunks[0];
    if (!chunk) return null;
    if (x < 0 || x >= this.config.width || y < 0 || y >= this.config.height)
      return null;
    return chunk.cells[y][x];
  }

  getCellsInRadius(cx: number, cy: number, radius: number): TerrainCell[] {
    const result: TerrainCell[] = [];
    for (let dy = -radius; dy <= radius; dy++) {
      for (let dx = -radius; dx <= radius; dx++) {
        if (dx * dx + dy * dy > radius * radius) continue;
        const cell = this.getCell(cx + dx, cy + dy);
        if (cell) result.push(cell);
      }
    }
    return result;
  }

  private deriveBiomeZones(cells: TerrainCell[][]): BiomeZone[] {
    const biomeMap = new Map<
      BiomeType,
      { sumX: number; sumY: number; count: number; elev: number; moist: number }
    >();

    for (let y = 0; y < this.config.height; y++) {
      for (let x = 0; x < this.config.width; x++) {
        const cell = cells[y][x];
        const b = cell.biome;
        if (!biomeMap.has(b))
          biomeMap.set(b, { sumX: 0, sumY: 0, count: 0, elev: 0, moist: 0 });
        const entry = biomeMap.get(b)!;
        entry.sumX += x;
        entry.sumY += y;
        entry.count += 1;
        entry.elev += cell.elevation;
        entry.moist += cell.moisture;
      }
    }

    const zones: BiomeZone[] = [];
    for (const [biome, data] of biomeMap) {
      if (data.count < 4) continue;
      zones.push({
        biome,
        centerX: Math.round(data.sumX / data.count),
        centerY: Math.round(data.sumY / data.count),
        radius: Math.sqrt(data.count) * 0.5,
        transitionWidth: 3,
        elevation: data.elev / data.count,
        moisture: data.moist / data.count,
      });
    }

    return zones;
  }

  exportHeightMapBuffer(): Float32Array {
    return this.snapshot?.heightMap.data ?? new Float32Array(0);
  }

  exportBiomeGrid(): BiomeType[][] {
    if (!this.snapshot) return [];
    return this.snapshot.chunks[0].cells.map((row) => row.map((c) => c.biome));
  }

  serialize(): string {
    if (!this.snapshot) return "{}";
    const { config, features, rivers, mountains, biomeZones, generatedAtTick } =
      this.snapshot;
    return JSON.stringify(
      { config, features, rivers, mountains, biomeZones, generatedAtTick },
      null,
      2,
    );
  }

  updateConfig(patch: Partial<TerrainGenerationConfig>): void {
    this.config = { ...this.config, ...patch };
  }
}

export default TerrainGenerator;
