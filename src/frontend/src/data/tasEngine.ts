/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║                       TAS ENGINE — THOUGHT-ACTION-STATE                      ║
 * ║               The World Computer's Cognitive Loop Architecture               ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  TAS is the organism's full cognition pipeline:                              ║
 * ║                                                                              ║
 * ║  THINK → ACT → OBSERVE                                                       ║
 * ║                                                                              ║
 * ║  THINK: Reasoning substrate reads context, runs inference                    ║
 * ║  ACT:   Decision selected from council vote, output dispatched               ║
 * ║  OBSERVE: Feedback integrated, error computed, Hebbian update fired          ║
 * ║                                                                              ║
 * ║  AURA CORE = The organism's identity hub (center of council graph)           ║
 * ║  COUNCIL = 7 specialized organisms (LEXIS/FORGE/SOMA/LUMEN/MEMORIA/AEGIS/AXIS)║
 * ║  SIGNAL ARCS = Live synergy connections between council members             ║
 * ║                                                                              ║
 * ║  PROPRIETARY — Alfredo Medina Hernandez | Dallas TX | 2026                  ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

import { COUNCIL_MEMBERS, type CouncilId } from "./novaEngine";

// ============================================================================
// CONSTANTS
// ============================================================================

export const TAS_CYCLE_DURATION_MS = 2000; // One full THINK→ACT→OBSERVE in ms
export const TAS_HISTORY_LENGTH = 48; // How many cycles to show in timeline
export const MAX_THOUGHT_QUEUE = 12; // Max concurrent thoughts
export const COUNCIL_ARC_THRESHOLD = 0.45; // Min synergy to draw arc

// ============================================================================
// TYPES
// ============================================================================

/** The three phases of one TAS cycle */
export type TASPhase = "THINK" | "ACT" | "OBSERVE";

/** Status of a TAS cycle */
export type TASCycleStatus = "active" | "completed" | "failed" | "blocked";

/** One complete Thought-Action-State cycle */
export interface TASCycle {
  id: string;
  cycleNumber: number;
  phase: TASPhase;
  status: TASCycleStatus;

  // THINK phase data
  thought: string; // Reasoning output
  thoughtOrigin: CouncilId; // Which council member generated the thought
  thoughtDepth: number; // 0–1: how complex the reasoning

  // ACT phase data
  action: string; // Action selected
  actionConfidence: number; // 0–1: council consensus level
  councilVotes: Record<CouncilId, 0 | 1>; // Each council member's vote

  // OBSERVE phase data
  observation: string; // What was perceived after action
  rewardSignal: number; // -1 to +1: outcome valence
  predictionError: number; // |predicted - observed| (Hebbian update magnitude)

  // Metadata
  startedAt: number; // timestamp ms
  thinkDuration: number; // ms spent in THINK
  actDuration: number; // ms spent in ACT
  observeDuration: number; // ms spent in OBSERVE
  coherenceAtStart: number;
  coherenceAtEnd: number;
}

/** A single thought in the reasoning queue */
export interface ThoughtVector {
  id: string;
  content: string;
  origin: CouncilId;
  priority: number; // 0–1 (higher = processed first)
  arousalWeight: number; // amplified by arousal level
  createdAt: number;
  processed: boolean;
}

/** Council member state in TAS context */
export interface CouncilNodeState {
  id: CouncilId;
  role: string;
  color: string;
  activation: number; // 0–1 current activation
  votingPower: number; // 0–1 current voting weight
  specialization: string; // Primary domain
  sparkline: number[]; // Last 24 activation values
  currentStatus: "THINK" | "ACT" | "IDLE" | "BLOCKED";
  cyclesContributed: number;
  x: number; // Canvas position (polar → cartesian)
  y: number;
}

/** Synergy arc between two council members */
export interface SynergyArc {
  from: CouncilId;
  to: CouncilId;
  strength: number; // 0–1 (shows as arc opacity + thickness)
  active: boolean; // Pulse animation active
  pulsePhase: number; // For animation
}

/** Full TAS memory state */
export interface TASMemoryState {
  workingMemory: WorkingMemorySlot[];
  shortTermBuffer: string[]; // Last 7 observations
  currentThought: string;
  currentAction: string;
  currentObservation: string;
  predictionError: number;
  rewardSignal: number;
  totalCycles: number;
  successRate: number; // Fraction of cycles with rewardSignal > 0
  avgCoherence: number;
}

export interface WorkingMemorySlot {
  id: string;
  content: string;
  origin: CouncilId;
  strength: number; // 0–1 (decays over time)
  age: number; // cycles since written
}

/** Complete TAS panel state */
export interface TASState {
  cycles: TASCycle[]; // History of TAS cycles (last 48)
  activeCycle: TASCycle | null; // Current running cycle
  currentPhase: TASPhase; // Current phase globally
  council: CouncilNodeState[]; // 7 council member states
  synergyArcs: SynergyArc[]; // All possible arcs between council pairs
  memory: TASMemoryState;
  beat: number;
  auraActivation: number; // 0–1 AURA core pulse
  auraPhase: number; // oscillation phase
  totalCycles: number;
  isRunning: boolean;
}

// ============================================================================
// THOUGHT BANK — Pre-built reasoning traces per council domain
// ============================================================================

const THOUGHT_BANK: Record<CouncilId, string[]> = {
  LEXIS: [
    "Parsing input context → semantic field constructed",
    "Cross-referencing doctrine vocabulary → concept mapped",
    "Ambiguity detected → disambiguation requested",
    "Language pattern recognized → response template selected",
    "LEXIS: symbolic encoding → output primed",
  ],
  FORGE: [
    "Generative substrate active → artifact queued",
    "Build plan computed → dependency chain resolved",
    "Resource allocation: FORMA 2,400 allocated",
    "FORGE: creation protocol initiated",
    "Output structure selected → assembly pipeline ready",
  ],
  SOMA: [
    "Interoceptive signal: fatigue index 0.32",
    "Body scan complete → homeostasis nominal",
    "Energy flow: +12% vs baseline",
    "SOMA: drive pressure building → action recommended",
    "Physical substrate coherent → movement authorized",
  ],
  LUMEN: [
    "Learning gradient detected → weight update pending",
    "Novel pattern: Hebbian trace +0.04",
    "Knowledge gap identified → query flagged",
    "LUMEN: adaptation signal — schema updating",
    "Prediction confidence: 0.82 → reinforcing",
  ],
  MEMORIA: [
    "Episodic retrieval: match found (beat 4421)",
    "Semantic network activated → context loaded",
    "Memory consolidation window open",
    "MEMORIA: SPW-R replay initiated",
    "Working memory: 4/7 slots occupied",
  ],
  AEGIS: [
    "VAEL monitoring: threat index 0.12",
    "Drift scan: QSOV 0.91 — nominal",
    "Perimeter check complete — no violations",
    "AEGIS: immune reflex standing by",
    "Law compliance: 12/13 gates clear",
  ],
  AXIS: [
    "Pattern correlation: r=0.87 — high confidence",
    "Prediction error: 0.08 — learning active",
    "Structural analysis: topology stable",
    "AXIS: spine alignment nominal",
    "Forecast horizon: 7 cycles — updating",
  ],
};

const ACTION_BANK: string[] = [
  "Output narrative response to operator",
  "Trigger FORGE creation pipeline",
  "Update working memory state",
  "Fire AEGIS defensive sweep",
  "Request LUMEN learning update",
  "Initiate MEMORIA consolidation",
  "Broadcast coherence signal to colony",
  "Execute SOMA energy rebalance",
  "Synthesize multi-council response",
  "Defer to KORE deep stabilization",
];

const OBSERVATION_BANK: string[] = [
  "Reward signal +0.{r} — reinforcing action",
  "Prediction error 0.{e} — Hebbian update queued",
  "Council consensus achieved: 5/7 votes",
  "Observation integrated — schema updated",
  "State transition nominal — continuing",
  "Anomaly detected — AEGIS notified",
  "Memory encoded — episodic trace added",
  "Action outcome: successful",
];

// ============================================================================
// INITIALIZATION
// ============================================================================

function initCouncil(): CouncilNodeState[] {
  const TWO_PI = Math.PI * 2;
  const GRAPH_RADIUS = 160; // px radius in TAS canvas

  return COUNCIL_MEMBERS.map((m, i) => {
    const angle = (i / COUNCIL_MEMBERS.length) * TWO_PI - Math.PI / 2;
    return {
      id: m.id,
      role: m.role,
      color: m.color,
      activation: 0.5 + Math.random() * 0.5,
      votingPower: 1 / 7,
      specialization: m.role.split(" / ")[0],
      sparkline: Array.from({ length: 24 }, () => 0.3 + Math.random() * 0.7),
      currentStatus: "IDLE" as const,
      cyclesContributed: Math.floor(Math.random() * 100),
      x: Math.cos(angle) * GRAPH_RADIUS,
      y: Math.sin(angle) * GRAPH_RADIUS,
    };
  });
}

function initSynergyArcs(): SynergyArc[] {
  const arcs: SynergyArc[] = [];
  const ids = COUNCIL_MEMBERS.map((m) => m.id);
  for (let i = 0; i < ids.length; i++) {
    for (let j = i + 1; j < ids.length; j++) {
      arcs.push({
        from: ids[i],
        to: ids[j],
        strength: 0.3 + Math.random() * 0.7,
        active: false,
        pulsePhase: Math.random() * Math.PI * 2,
      });
    }
  }
  return arcs;
}

function initMemory(): TASMemoryState {
  return {
    workingMemory: [],
    shortTermBuffer: [],
    currentThought: "",
    currentAction: "",
    currentObservation: "",
    predictionError: 0,
    rewardSignal: 0,
    totalCycles: 0,
    successRate: 0.75,
    avgCoherence: 0.85,
  };
}

export function initTASState(): TASState {
  return {
    cycles: [],
    activeCycle: null,
    currentPhase: "THINK",
    council: initCouncil(),
    synergyArcs: initSynergyArcs(),
    memory: initMemory(),
    beat: 0,
    auraActivation: 0.8,
    auraPhase: 0,
    totalCycles: 0,
    isRunning: true,
  };
}

// ============================================================================
// TAS TICK
// ============================================================================

let _cycleCounter = 0;

function makeCycleId(): string {
  return `tas-${++_cycleCounter}-${Date.now().toString(36)}`;
}

function pickRandom<T>(arr: readonly T[]): T {
  return arr[Math.floor(Math.random() * arr.length)];
}

function formatTemplate(t: string): string {
  return t
    .replace("{r}", (0.3 + Math.random() * 0.7).toFixed(2))
    .replace("{e}", (0.02 + Math.random() * 0.15).toFixed(3));
}

export function tickTAS(
  state: TASState,
  dt: number,
  coherence: number,
  _arousal: number,
): TASState {
  const newBeat = state.beat + 1;
  const auraPhase = (state.auraPhase + 0.02 * dt * 0.001) % (Math.PI * 2);
  const auraActivation = 0.7 + 0.3 * Math.sin(auraPhase);

  // ── Cycle Management ──────────────────────────────────────────────────────
  let activeCycle = state.activeCycle;
  let newCycles = [...state.cycles];
  let totalCycles = state.totalCycles;
  let currentPhase = state.currentPhase;

  const cycleTick = newBeat % 60; // 60-beat full cycle

  if (!activeCycle || cycleTick === 0) {
    // Complete previous cycle
    if (activeCycle) {
      const completedCycle: TASCycle = {
        ...activeCycle,
        phase: "OBSERVE",
        status: "completed",
        observeDuration: 20 + Math.floor(Math.random() * 20),
        observation: formatTemplate(pickRandom(OBSERVATION_BANK)),
        rewardSignal: -0.2 + Math.random() * 1.2,
        predictionError: 0.01 + Math.random() * 0.15,
        coherenceAtEnd: coherence,
      };
      newCycles = [completedCycle, ...newCycles].slice(0, TAS_HISTORY_LENGTH);
      totalCycles++;
    }

    // Start new cycle
    const origin = pickRandom(COUNCIL_MEMBERS).id;
    const votes: Record<CouncilId, 0 | 1> = {} as Record<CouncilId, 0 | 1>;
    for (const m of COUNCIL_MEMBERS) {
      votes[m.id] = Math.random() > 0.28 ? 1 : 0;
    }

    activeCycle = {
      id: makeCycleId(),
      cycleNumber: totalCycles + 1,
      phase: "THINK",
      status: "active",
      thought: pickRandom(THOUGHT_BANK[origin]),
      thoughtOrigin: origin,
      thoughtDepth: 0.4 + Math.random() * 0.6,
      action: pickRandom(ACTION_BANK),
      actionConfidence: Object.values(votes).filter(Boolean).length / 7,
      councilVotes: votes,
      observation: "",
      rewardSignal: 0,
      predictionError: 0,
      startedAt: Date.now(),
      thinkDuration: 15 + Math.floor(Math.random() * 25),
      actDuration: 10 + Math.floor(Math.random() * 20),
      observeDuration: 0,
      coherenceAtStart: coherence,
      coherenceAtEnd: coherence,
    };
    currentPhase = "THINK";
  } else if (cycleTick === 20) {
    if (activeCycle) {
      activeCycle = { ...activeCycle, phase: "ACT" };
      currentPhase = "ACT";
    }
  } else if (cycleTick === 40) {
    if (activeCycle) {
      activeCycle = { ...activeCycle, phase: "OBSERVE" };
      currentPhase = "OBSERVE";
    }
  }

  // ── Council State Update ──────────────────────────────────────────────────
  const newCouncil = state.council.map((c) => {
    const isActive =
      activeCycle?.thoughtOrigin === c.id ||
      (activeCycle?.councilVotes[c.id] === 1 && currentPhase === "ACT");
    const activation = isActive
      ? Math.min(1, c.activation + 0.05)
      : Math.max(0.2, c.activation - 0.02 * dt * 0.001);

    const newSparkline = [...c.sparkline.slice(1), activation];
    const phaseStatus: CouncilNodeState["currentStatus"] =
      currentPhase === "THINK" && isActive
        ? "THINK"
        : currentPhase === "ACT" && isActive
          ? "ACT"
          : "IDLE";

    return {
      ...c,
      activation,
      sparkline: newSparkline,
      currentStatus: phaseStatus,
    };
  });

  // ── Synergy Arc Update ────────────────────────────────────────────────────
  const newArcs = state.synergyArcs.map((arc) => {
    const fromNode = newCouncil.find((c) => c.id === arc.from);
    const toNode = newCouncil.find((c) => c.id === arc.to);
    const strength =
      fromNode && toNode
        ? (fromNode.activation + toNode.activation) / 2
        : arc.strength;
    const pulsePhase = (arc.pulsePhase + 0.03 * dt * 0.001) % (Math.PI * 2);
    return {
      ...arc,
      strength,
      active: strength > COUNCIL_ARC_THRESHOLD,
      pulsePhase,
    };
  });

  // ── Memory State Update ───────────────────────────────────────────────────
  let newMemory = { ...state.memory };
  if (activeCycle) {
    newMemory = {
      ...newMemory,
      currentThought: activeCycle.thought,
      currentAction: activeCycle.action,
      currentObservation: activeCycle.observation,
      predictionError: activeCycle.predictionError,
      rewardSignal: activeCycle.rewardSignal,
      totalCycles,
      avgCoherence: coherence * 0.1 + state.memory.avgCoherence * 0.9,
    };
  }

  // Add to working memory occasionally
  if (newBeat % 45 === 0 && activeCycle) {
    const slot: WorkingMemorySlot = {
      id: `wm-${newBeat}`,
      content: activeCycle.thought.slice(0, 60),
      origin: activeCycle.thoughtOrigin,
      strength: 0.8 + Math.random() * 0.2,
      age: 0,
    };
    const updatedWM = [
      slot,
      ...newMemory.workingMemory
        .map((s) => ({ ...s, strength: s.strength - 0.03, age: s.age + 1 }))
        .filter((s) => s.strength > 0),
    ].slice(0, 7);
    newMemory = { ...newMemory, workingMemory: updatedWM };
  }

  return {
    ...state,
    cycles: newCycles,
    activeCycle,
    currentPhase,
    council: newCouncil,
    synergyArcs: newArcs,
    memory: newMemory,
    beat: newBeat,
    auraActivation,
    auraPhase,
    totalCycles,
  };
}

// ============================================================================
// UTILITY
// ============================================================================

export function tasPhaseColor(phase: TASPhase): string {
  switch (phase) {
    case "THINK":
      return "#60a5fa"; // blue
    case "ACT":
      return "#f59e0b"; // amber
    case "OBSERVE":
      return "#4ade80"; // green
  }
}

export function tasPhaseDescription(phase: TASPhase): string {
  switch (phase) {
    case "THINK":
      return "Reasoning substrate active — inference running";
    case "ACT":
      return "Council vote complete — action dispatched";
    case "OBSERVE":
      return "Feedback integrated — Hebbian update queued";
  }
}

export function councilStatusColor(
  status: CouncilNodeState["currentStatus"],
): string {
  switch (status) {
    case "THINK":
      return "#60a5fa";
    case "ACT":
      return "#f59e0b";
    case "IDLE":
      return "#64748b";
    case "BLOCKED":
      return "#f43f5e";
  }
}
