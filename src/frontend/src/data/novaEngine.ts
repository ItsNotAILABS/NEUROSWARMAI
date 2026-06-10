/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║                    NOVA ENGINE — MACRO KURAMOTO SUBSTRATE                    ║
 * ║         Engine #302 | NeuralCore | Shell 3 Brain Field Visualizer           ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  NOVA is the living visual form of the organism.                             ║
 * ║  It renders 7 stacked layers — each a different substrate of consciousness.  ║
 * ║                                                                              ║
 * ║  LAYER 1: Pheromone Particle Field  (Queen Signal — coherence gradient)      ║
 * ║  LAYER 2: Quantum Interference Rings (QSOV-component colored)               ║
 * ║  LAYER 3: 64-node Shell 3 Neural Web (Kuramoto sync lines)                  ║
 * ║  LAYER 4: 7 Council Satellites orbiting at 175px                            ║
 * ║  LAYER 5: Drive Mode Aura Gradient                                           ║
 * ║  LAYER 6: Breathing Identity Core                                           ║
 * ║  LAYER 7: Expression Text (autonomous messages)                             ║
 * ║                                                                              ║
 * ║  QSOV = 0.35×C + 0.20×S + 0.15×A + 0.15×I + 0.05×R + 0.05×E + 0.05×G    ║
 * ║  Floor: 0.75 | Ceiling: 1.5                                                  ║
 * ║                                                                              ║
 * ║  PROPRIETARY — Alfredo Medina Hernandez | Dallas TX | 2026                  ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

// ============================================================================
// CONSTANTS
// ============================================================================

export const TWO_PI = Math.PI * 2;
// biome-ignore lint/correctness/noPrecisionLoss: architectural constant
export const PHI = 1.6180339887498948482; // Golden ratio

// Shell 3 — 64-node Kuramoto brain field
export const NOVA_NODE_COUNT = 64;

// Council of 7
export const COUNCIL_MEMBERS = [
  { id: "LEXIS", role: "Language / Communication", color: "#60a5fa", angle: 0 },
  {
    id: "FORGE",
    role: "Creation / Building",
    color: "#f97316",
    angle: TWO_PI / 7,
  },
  {
    id: "SOMA",
    role: "Body / Interoception",
    color: "#4ade80",
    angle: (2 * TWO_PI) / 7,
  },
  {
    id: "LUMEN",
    role: "Learning / Adaptation",
    color: "#facc15",
    angle: (3 * TWO_PI) / 7,
  },
  {
    id: "MEMORIA",
    role: "Memory / Continuity",
    color: "#c084fc",
    angle: (4 * TWO_PI) / 7,
  },
  {
    id: "AEGIS",
    role: "Security / Defense",
    color: "#f43f5e",
    angle: (5 * TWO_PI) / 7,
  },
  {
    id: "AXIS",
    role: "Pattern / Prediction",
    color: "#22d3ee",
    angle: (6 * TWO_PI) / 7,
  },
] as const;

export type CouncilId = (typeof COUNCIL_MEMBERS)[number]["id"];

// QSOV component colors (matching formula weights)
export const QSOV_COLORS = {
  coherence: "#22d3ee", // 35% — teal
  stability: "#60a5fa", // 20% — blue
  autonomy: "#c084fc", // 15% — purple
  integrity: "#a78bfa", // 15% — violet
  resilience: "#fb923c", // 5%  — amber
  efficiency: "#4ade80", // 5%  — green
  growth: "#fbbf24", // 5%  — gold
};

// Drive mode aura colors
export const DRIVE_AURA = {
  Execution: { inner: "#06b6d4", outer: "#0e7490" },
  Exploration: { inner: "#f59e0b", outer: "#b45309" },
  Rest: { inner: "#64748b", outer: "#334155" },
  Learning: { inner: "#a855f7", outer: "#7c3aed" },
} as const;

// Arousal level thresholds (from ArousalSystemEngine)
export const AROUSAL = {
  DEEP_REST: 200,
  LOW: 400,
  MODERATE: 600,
  HIGH: 800,
  CRITICAL: 1000,
} as const;

// Particle count for pheromone field
export const PHEROMONE_PARTICLE_COUNT = 180;

// Council orbit radius (px from center)
export const COUNCIL_ORBIT_RADIUS = 175;

// ============================================================================
// TYPES
// ============================================================================

export interface NovaKuramotoNode {
  id: number;
  phase: number; // [0, 2π)
  frequency: number; // Hz natural frequency
  amplitude: number; // [0, 1] current amplitude
  x: number; // canvas position
  y: number;
  ring: number; // 0=inner(8), 1=mid(16), 2=outer(24), 3=perimeter(16)
  activation: number; // [0, 1]
}

export interface NovaCouncilSatellite {
  id: CouncilId;
  role: string;
  color: string;
  angle: number; // current orbital angle (radians)
  orbitRadius: number;
  activation: number; // [0, 1]
  x: number; // resolved canvas x
  y: number; // resolved canvas y
  signalStrength: number; // arc brightness to center
  phase: number; // individual oscillation phase
}

export interface PheromoneParticle {
  x: number;
  y: number;
  vx: number;
  vy: number;
  life: number; // [0, 1] (1=fresh)
  maxLife: number;
  size: number;
  hue: number; // HSL hue derived from coherence
}

export interface QSOVState {
  overall: number; // 0.75 – 1.5 canonical range
  coherence: number;
  stability: number;
  autonomy: number;
  integrity: number;
  resilience: number;
  efficiency: number;
  growth: number;
  trend: "rising" | "stable" | "falling";
}

export interface ExpressionMessage {
  id: string;
  text: string;
  y: number; // canvas y position (floats upward)
  opacity: number;
  color: string;
  age: number; // ticks since spawned
}

export interface NovaState {
  nodes: NovaKuramotoNode[];
  kuramotoR: number; // global order parameter [0, 1]
  meanPhase: number; // mean phase angle
  satellites: NovaCouncilSatellite[];
  particles: PheromoneParticle[];
  qsov: QSOVState;
  expressions: ExpressionMessage[];
  beat: number;
  arousalLevel: number; // 0–1000
  driveMode: "Execution" | "Exploration" | "Rest" | "Learning";
  coherence: number; // 0–1
}

// ============================================================================
// INITIALIZATION
// ============================================================================

function initNodes(): NovaKuramotoNode[] {
  const nodes: NovaKuramotoNode[] = [];
  // Ring layout: 8 + 16 + 24 + 16 = 64 nodes
  const rings = [
    { count: 8, radius: 40, baseFreq: 40 }, // gamma inner
    { count: 16, radius: 70, baseFreq: 12 }, // beta mid
    { count: 24, radius: 100, baseFreq: 8 }, // alpha outer
    { count: 16, radius: 130, baseFreq: 4 }, // theta perimeter
  ];

  let id = 0;
  for (let r = 0; r < rings.length; r++) {
    const ring = rings[r];
    for (let i = 0; i < ring.count; i++) {
      const angle = (i / ring.count) * TWO_PI;
      // Scatter frequency slightly per Kuramoto model (ωᵢ = ω₀ + noise)
      const freq = ring.baseFreq * (1 + 0.1 * (Math.random() - 0.5));
      nodes.push({
        id,
        phase: Math.random() * TWO_PI,
        frequency: freq,
        amplitude: 0.5 + Math.random() * 0.5,
        x: Math.cos(angle) * ring.radius,
        y: Math.sin(angle) * ring.radius,
        ring: r,
        activation: 0.5,
      });
      id++;
    }
  }
  return nodes;
}

function initSatellites(): NovaCouncilSatellite[] {
  return COUNCIL_MEMBERS.map((m) => ({
    id: m.id,
    role: m.role,
    color: m.color,
    angle: m.angle,
    orbitRadius: COUNCIL_ORBIT_RADIUS,
    activation: 0.7 + Math.random() * 0.3,
    x: Math.cos(m.angle) * COUNCIL_ORBIT_RADIUS,
    y: Math.sin(m.angle) * COUNCIL_ORBIT_RADIUS,
    signalStrength: 0.6 + Math.random() * 0.4,
    phase: Math.random() * TWO_PI,
  }));
}

function initParticles(coherence: number): PheromoneParticle[] {
  const particles: PheromoneParticle[] = [];
  for (let i = 0; i < PHEROMONE_PARTICLE_COUNT; i++) {
    const angle = Math.random() * TWO_PI;
    const radius = 40 + Math.random() * 200;
    particles.push(
      spawnParticle(
        Math.cos(angle) * radius,
        Math.sin(angle) * radius,
        coherence,
      ),
    );
  }
  return particles;
}

function spawnParticle(
  x: number,
  y: number,
  coherence: number,
): PheromoneParticle {
  const speed = 0.3 + Math.random() * 0.5;
  const angle = Math.random() * TWO_PI;
  const hue = 160 + coherence * 60; // teal (160) → cyan-green (220) as coherence rises
  return {
    x,
    y,
    vx: Math.cos(angle) * speed,
    vy: Math.sin(angle) * speed,
    life: 1,
    maxLife: 120 + Math.random() * 120,
    size: 1 + Math.random() * 2.5,
    hue,
  };
}

export function computeQSOV(
  coherence: number,
  stability: number,
  autonomy: number,
  integrity: number,
  resilience: number,
  efficiency: number,
  growth: number,
  prevQSOV: number,
): QSOVState {
  const overall =
    coherence * 0.35 +
    stability * 0.2 +
    autonomy * 0.15 +
    integrity * 0.15 +
    resilience * 0.05 +
    efficiency * 0.05 +
    growth * 0.05;

  const clamped = Math.max(0, Math.min(1.5, overall));
  const trend =
    clamped > prevQSOV + 0.005
      ? "rising"
      : clamped < prevQSOV - 0.005
        ? "falling"
        : "stable";

  return {
    overall: clamped,
    coherence,
    stability,
    autonomy,
    integrity,
    resilience,
    efficiency,
    growth,
    trend,
  };
}

// ============================================================================
// EXPRESSION MESSAGE GENERATOR
// ============================================================================

const EXPRESSION_TEMPLATES = {
  highCoherence: [
    "SHELL 3 SYNCHRONIZED",
    "KURAMOTO R=0.{r} — PHASE LOCK",
    "COUNCIL QUORUM REACHED",
    "QSOV NOMINAL — SOVEREIGNTY ACTIVE",
    "MEMORIA ENCODING",
  ],
  lowCoherence: [
    "DRIFT DETECTED — KORE PULLING",
    "COHERENCE BELOW S₀ FLOOR",
    "RE-ENTRAINMENT PULSE FIRED",
    "SHELL 3 DESYNCHRONIZED",
    "AEGIS MONITORING",
  ],
  highArousal: [
    "VAEL ACTIVE — VIGILANT MODE",
    "AROUSAL CRITICAL — EMERGENCY MODE",
    "AEGIS SPIKE +400",
    "THREAT RESPONSE INITIATED",
    "SURVIVAL FOCUS ENGAGED",
  ],
  lowArousal: [
    "KORE CONSOLIDATING",
    "DEEP REST — MEMORIA REPLAY",
    "SLOW-WAVE PROCESSING",
    "HEBBIAN DECAY ACTIVE",
    "DREAM STATE ENGAGED",
  ],
  exploring: [
    "EXPLORATION MODE — LUMEN ACTIVE",
    "NOVEL STIMULUS +250",
    "AXIS PATTERN SCAN",
    "FORGE GENERATING",
    "LEXIS PARSING CONTEXT",
  ],
  executing: [
    "EXECUTION MODE — ALL SYSTEMS",
    "TASK PIPELINE ACTIVE",
    "FORGE OUTPUT STREAM",
    "COUNCIL VOTES: 5/7",
    "SOMA DRIVES ACTIVE",
  ],
};

export function generateExpression(
  coherence: number,
  arousal: number,
  driveMode: string,
  kuramotoR: number,
): string {
  let pool: string[];
  if (arousal > 800) {
    pool = EXPRESSION_TEMPLATES.highArousal;
  } else if (arousal < 300) {
    pool = EXPRESSION_TEMPLATES.lowArousal;
  } else if (coherence > 0.85) {
    pool = EXPRESSION_TEMPLATES.highCoherence;
  } else if (coherence < 0.6) {
    pool = EXPRESSION_TEMPLATES.lowCoherence;
  } else if (driveMode === "Exploration") {
    pool = EXPRESSION_TEMPLATES.exploring;
  } else {
    pool = EXPRESSION_TEMPLATES.executing;
  }

  const template = pool[Math.floor(Math.random() * pool.length)];
  const r = String(Math.round(kuramotoR * 100)).padStart(2, "0");
  return template.replace("{r}", r);
}

// ============================================================================
// NOVA STATE INITIALIZATION
// ============================================================================

export function initNovaState(
  coherence = 0.85,
  driveMode: NovaState["driveMode"] = "Execution",
  arousalLevel = 500,
): NovaState {
  const nodes = initNodes();
  const satellites = initSatellites();
  const particles = initParticles(coherence);

  const qsov = computeQSOV(
    coherence, // coherence
    0.88, // stability
    0.8, // autonomy
    0.85, // integrity
    0.72, // resilience
    0.78, // efficiency
    0.65, // growth
    0.75, // prevQSOV (floor)
  );

  return {
    nodes,
    kuramotoR: 0.0,
    meanPhase: 0.0,
    satellites,
    particles,
    qsov,
    expressions: [],
    beat: 0,
    arousalLevel,
    driveMode,
    coherence,
  };
}

// ============================================================================
// NOVA TICK — One simulation step (call at ~60fps for live animation)
// ============================================================================

export function tickNova(state: NovaState, dt: number): NovaState {
  const K = 0.3 + state.coherence * 0.4; // Kuramoto coupling strength K/N
  const N = state.nodes.length;

  // ── Kuramoto Phase Update ─────────────────────────────────────────────────
  // dθᵢ/dt = ωᵢ + (K/N) Σⱼ sin(θⱼ - θᵢ)
  const newNodes = state.nodes.map((node) => {
    let coupling = 0;
    for (const other of state.nodes) {
      coupling += Math.sin(other.phase - node.phase);
    }
    const dPhase = node.frequency * 0.001 * dt + (K / N) * coupling * dt * 0.01;
    const newPhase = (node.phase + dPhase) % TWO_PI;
    const activation = 0.5 + 0.5 * Math.sin(newPhase);
    return { ...node, phase: newPhase, activation };
  });

  // ── Kuramoto Order Parameter r(t) = |1/N Σⱼ exp(i·θⱼ)| ──────────────────
  let sumX = 0;
  let sumY = 0;
  for (const n of newNodes) {
    sumX += Math.cos(n.phase);
    sumY += Math.sin(n.phase);
  }
  const kuramotoR = Math.sqrt(sumX * sumX + sumY * sumY) / N;
  const meanPhase = Math.atan2(sumY / N, sumX / N);

  // ── Council Satellite Orbit Update ────────────────────────────────────────
  const orbitSpeed = 0.0003 * dt * (1 + state.arousalLevel / 2000);
  const newSatellites = state.satellites.map((s) => {
    const newAngle =
      s.angle + orbitSpeed + (s.id === "AEGIS" ? orbitSpeed * 0.5 : 0);
    const newPhase = (s.phase + 0.02 * dt * 0.001) % TWO_PI;
    const activation = 0.6 + 0.4 * Math.sin(newPhase);
    const x = Math.cos(newAngle) * s.orbitRadius;
    const y = Math.sin(newAngle) * s.orbitRadius;
    return { ...s, angle: newAngle, phase: newPhase, activation, x, y };
  });

  // ── Pheromone Particle Update ─────────────────────────────────────────────
  const pheromoneStrength = state.qsov.overall / 1.5;
  const newParticles = state.particles
    .map((p) => {
      // Drift toward/away from center based on queen signal
      const dist = Math.sqrt(p.x * p.x + p.y * p.y);
      const pullStrength = pheromoneStrength * 0.01;
      const pullX = dist > 0 ? (-p.x / dist) * pullStrength : 0;
      const pullY = dist > 0 ? (-p.y / dist) * pullStrength : 0;

      const newLife = p.life - 1 / p.maxLife;
      return {
        ...p,
        x: p.x + p.vx * dt * 0.1 + pullX,
        y: p.y + p.vy * dt * 0.1 + pullY,
        life: newLife,
      };
    })
    .filter((p) => p.life > 0);

  // Respawn dead particles
  while (newParticles.length < PHEROMONE_PARTICLE_COUNT) {
    const angle = Math.random() * TWO_PI;
    const radius = 150 + Math.random() * 100;
    newParticles.push(
      spawnParticle(
        Math.cos(angle) * radius,
        Math.sin(angle) * radius,
        state.coherence,
      ),
    );
  }

  // ── Expression Messages ───────────────────────────────────────────────────
  const newExpressions = state.expressions
    .map((e) => ({
      ...e,
      y: e.y - 0.3 * dt * 0.1,
      opacity: e.opacity - 0.003 * dt * 0.1,
      age: e.age + 1,
    }))
    .filter((e) => e.opacity > 0);

  // Spawn new expression every ~200 beats
  const newBeat = state.beat + 1;
  if (newBeat % 200 === 0) {
    const text = generateExpression(
      state.coherence,
      state.arousalLevel,
      state.driveMode,
      kuramotoR,
    );
    const councilColor =
      COUNCIL_MEMBERS[Math.floor(Math.random() * COUNCIL_MEMBERS.length)].color;
    newExpressions.push({
      id: `expr-${newBeat}`,
      text,
      y: 20,
      opacity: 1,
      color: councilColor,
      age: 0,
    });
  }

  // Keep max 5 expressions on screen
  const trimmedExpressions = newExpressions.slice(-5);

  return {
    ...state,
    nodes: newNodes,
    kuramotoR,
    meanPhase,
    satellites: newSatellites,
    particles: newParticles,
    expressions: trimmedExpressions,
    beat: newBeat,
  };
}

// ============================================================================
// SEED FROM LIVE ORGANISM DATA
// ============================================================================

export function seedNovaFromOrganism(
  state: NovaState,
  organism: {
    coherence: number;
    hz: number[];
    neuroChem: number[];
    driveMode: "Execution" | "Exploration" | "Rest" | "Learning";
  },
): NovaState {
  const { coherence, hz, neuroChem, driveMode } = organism;

  // Seed node phases from hz frequencies
  const newNodes = state.nodes.map((n, i) => ({
    ...n,
    phase: ((hz[i % hz.length] ?? 0.5) * TWO_PI) % TWO_PI,
    amplitude: neuroChem[i % neuroChem.length] ?? 0.5,
    activation: hz[i % hz.length] ?? 0.5,
  }));

  // QSOV derived from organism metrics
  const qsov = computeQSOV(
    coherence,
    0.85 + Math.sin(Date.now() * 0.0001) * 0.05, // stability oscillates
    0.78 + coherence * 0.1,
    0.88,
    0.7 + coherence * 0.05,
    0.75,
    0.6 + coherence * 0.1,
    state.qsov.overall,
  );

  // Arousal derived from neuroChem (higher avg neuroChem = higher arousal)
  const avgNeuroChem =
    neuroChem.length > 0
      ? neuroChem.reduce((s, v) => s + v, 0) / neuroChem.length
      : 0.5;
  const arousalLevel = Math.round(avgNeuroChem * 1000);

  return {
    ...state,
    nodes: newNodes,
    qsov,
    arousalLevel,
    driveMode,
    coherence,
  };
}

// ============================================================================
// UTILITY: Color for QSOV ring component
// ============================================================================

export function qsovRingColor(
  component: keyof typeof QSOV_COLORS,
  opacity: number,
): string {
  const hex = QSOV_COLORS[component];
  const r = Number.parseInt(hex.slice(1, 3), 16);
  const g = Number.parseInt(hex.slice(3, 5), 16);
  const b = Number.parseInt(hex.slice(5, 7), 16);
  return `rgba(${r}, ${g}, ${b}, ${opacity})`;
}

// ============================================================================
// UTILITY: Arousal label
// ============================================================================

export function arousalLabel(level: number): string {
  if (level < AROUSAL.DEEP_REST) return "DEEP REST";
  if (level < AROUSAL.LOW) return "LOW";
  if (level < AROUSAL.MODERATE) return "MODERATE";
  if (level < AROUSAL.HIGH) return "HIGH";
  return "CRITICAL";
}

export function arousalColor(level: number): string {
  if (level < AROUSAL.DEEP_REST) return "#64748b";
  if (level < AROUSAL.LOW) return "#60a5fa";
  if (level < AROUSAL.MODERATE) return "#4ade80";
  if (level < AROUSAL.HIGH) return "#f59e0b";
  return "#f43f5e";
}
