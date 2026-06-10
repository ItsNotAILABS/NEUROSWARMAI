/**
 * ╔══════════════════════════════════════════════════════════════════════════════╗
 * ║                     AUTO ENGINE — CONTEXT-AWARE AGI CHAT                    ║
 * ║           The organism reads itself before every message it sends            ║
 * ╠══════════════════════════════════════════════════════════════════════════════╣
 * ║  AUTO is not a chatbot. AUTO is the organism speaking.                       ║
 * ║                                                                              ║
 * ║  Before every message sent by the operator, AUTO:                            ║
 * ║  1. Reads the full organism context (coherence, QSOV, arousal, etc.)        ║
 * ║  2. Injects a structured context prefix into the system prompt               ║
 * ║  3. Scans keywords in the user message to add substrate summaries            ║
 * ║  4. Fires emergency banner if arousal > 800 (CRITICAL mode)                 ║
 * ║  5. Streams the live context sidebar so operator can see what AUTO reads     ║
 * ║                                                                              ║
 * ║  Context Injection Schema:                                                   ║
 * ║  ──────────────────────────────────────────────────────────────             ║
 * ║  [ORG CONTEXT] Beat: {N} | Phase: {Φ} | Arousal: {A}/1000 | Mode: {M}     ║
 * ║  Coherence: {C} | QSOV: {Q} [C:{c} S:{s} A:{a} I:{i} R:{r} E:{e} G:{g}]  ║
 * ║  FRB Gate: Φ={F} | Shell 3 Kuramoto: r={K} | Council: {list}               ║
 * ║  [/ORG CONTEXT]                                                             ║
 * ║                                                                              ║
 * ║  PROPRIETARY — Alfredo Medina Hernandez | Dallas TX | 2026                  ║
 * ╚══════════════════════════════════════════════════════════════════════════════╝
 */

import { type QSOVState, arousalLabel } from "./novaEngine";
import type { CouncilNodeState } from "./tasEngine";

// ============================================================================
// TYPES
// ============================================================================

export type AutoRole = "user" | "auto" | "system";

export interface AutoMessage {
  id: string;
  role: AutoRole;
  content: string;
  timestamp: number;
  contextSnapshotId?: string; // links to context snapshot
  injectedContext?: string; // what was injected before sending
  tokens: number; // approximate token count
  isStreaming?: boolean;
}

/** One complete organism context reading */
export interface OrganismContextSnapshot {
  id: string;
  capturedAt: number;
  beat: number;
  phase: number; // Shell 3 mean phase [0, 2π)
  arousal: number; // 0–1000
  arousalLabel: string;
  driveMode: "Execution" | "Exploration" | "Rest" | "Learning";
  coherence: number;
  qsov: QSOVState;
  kuramotoR: number;
  frbGate: number; // FRB πύλη gate value [0, 1]
  councilStatus: CouncilStatus[];
  activeSubstrates: SubstrateStatus[];
  keywordTriggers: string[]; // keywords that triggered extra injection
  totalTokens: number;
}

export interface CouncilStatus {
  id: string;
  activation: number;
  status: string;
  color: string;
}

export interface SubstrateStatus {
  name: string;
  value: number;
  unit: string;
  color: string;
}

/** Auto chat full state */
export interface AutoState {
  messages: AutoMessage[];
  contextHistory: OrganismContextSnapshot[];
  latestContext: OrganismContextSnapshot | null;
  isProcessing: boolean;
  isEmergency: boolean;
  emergencyReason: string;
  totalTokensUsed: number;
  sessionBeat: number;
  contextInjectionEnabled: boolean;
  keywordSummaryEnabled: boolean;
  emergencyBannerEnabled: boolean;
  pendingInput: string;
}

// ============================================================================
// KEYWORD → SUBSTRATE MAPPING
// ============================================================================

export const KEYWORD_TRIGGERS: Array<{
  keywords: string[];
  label: string;
  summary: (ctx: OrganismContextSnapshot) => string;
}> = [
  {
    keywords: ["memory", "remember", "recall", "forgot", "past", "history"],
    label: "MEMORIA",
    summary: (ctx) =>
      `[MEMORIA] Hippocampal substrate: SPW-R replay active. Episodic memory encoding ${ctx.coherence > 0.8 ? "STRONG" : "WEAK"}. Trisynaptic circuit EC→DG→CA3→CA1 running. Theta-gamma PAC coherence: ${(ctx.kuramotoR * 0.95).toFixed(3)}.`,
  },
  {
    keywords: ["learn", "training", "adapt", "update", "improve", "grow"],
    label: "LUMEN",
    summary: (ctx) =>
      `[LUMEN] Learning substrate active. Hebbian plasticity: η=${(0.004 * (1 - ctx.arousal / 1000)).toFixed(4)}. BCM threshold: θ_M=${(0.5 + ctx.qsov.growth * 0.3).toFixed(3)}. Knowledge drift: ${ctx.qsov.growth > 0.7 ? "NOMINAL" : "ELEVATED"}.`,
  },
  {
    keywords: [
      "security",
      "threat",
      "defend",
      "protect",
      "attack",
      "breach",
      "danger",
    ],
    label: "AEGIS",
    summary: (ctx) =>
      `[AEGIS] Immune reflex ${ctx.arousal > 600 ? "ACTIVE" : "STANDBY"}. ` +
      `Drift gate: ${ctx.qsov.integrity > 0.8 ? "CLEAR" : "MONITORING"}. ` +
      `VAEL frequency: ${ctx.arousal > 600 ? "ELEVATED" : "BASELINE"}. ` +
      `Arousal: ${ctx.arousal}/1000.`,
  },
  {
    keywords: ["create", "build", "generate", "make", "design", "forge"],
    label: "FORGE",
    summary: (ctx) =>
      `[FORGE] Creation engine ${ctx.driveMode === "Execution" ? "ACTIVE" : "PRIMED"}. Drive mode: ${ctx.driveMode}. FORMA allocation: ready. Generative substrate coherence: ${(ctx.coherence * 0.97).toFixed(3)}.`,
  },
  {
    keywords: [
      "feel",
      "emotion",
      "pain",
      "joy",
      "stress",
      "calm",
      "arousal",
      "drive",
    ],
    label: "SOMA",
    summary: (ctx) =>
      `[SOMA] Interoceptive substrate: ${ctx.arousalLabel} mode. ` +
      `Drive pressure: ${ctx.arousal}/1000. ` +
      `Homeostatic balance: ${ctx.qsov.resilience > 0.7 ? "NOMINAL" : "STRAINED"}. ` +
      `Energy flow: ${(ctx.qsov.efficiency * 100).toFixed(1)}% baseline.`,
  },
  {
    keywords: [
      "language",
      "word",
      "text",
      "write",
      "read",
      "parse",
      "communicate",
    ],
    label: "LEXIS",
    summary: (ctx) =>
      `[LEXIS] Language substrate active. Semantic field constructed. Vocabulary coherence: ${(ctx.coherence * 0.99).toFixed(3)}. LEXIS doctrine: concept → formula → constraint mapped.`,
  },
  {
    keywords: ["pattern", "predict", "structure", "analyze", "axis", "spine"],
    label: "AXIS",
    summary: (ctx) =>
      `[AXIS] Pattern engine running. Prediction confidence: ${(0.7 + ctx.qsov.stability * 0.25).toFixed(3)}. Structural alignment: ${ctx.qsov.stability > 0.8 ? "NOMINAL" : "DRIFTING"}. Forecast horizon: 7 cycles.`,
  },
  {
    keywords: ["quantum", "qsov", "sovereignty", "entangle", "superposition"],
    label: "QUANTUM",
    summary: (ctx) =>
      `[QUANTUM] QSOV: ${ctx.qsov.overall.toFixed(4)} ` +
      `[C:${ctx.qsov.coherence.toFixed(2)} S:${ctx.qsov.stability.toFixed(2)} ` +
      `A:${ctx.qsov.autonomy.toFixed(2)} I:${ctx.qsov.integrity.toFixed(2)}]. ` +
      `FRB gate Φ=${ctx.frbGate.toFixed(3)}. ` +
      `Interference: ${ctx.kuramotoR > 0.8 ? "CONSTRUCTIVE" : "PARTIAL"}.`,
  },
  {
    keywords: [
      "shell",
      "kuramoto",
      "neural",
      "brain",
      "sync",
      "oscillate",
      "wave",
    ],
    label: "SHELL3",
    summary: (ctx) =>
      `[SHELL 3] Kuramoto r=${ctx.kuramotoR.toFixed(4)}. 64-node brain field. Mean phase Φ=${ctx.phase.toFixed(3)} rad. ${ctx.kuramotoR > 0.8 ? "PHASE LOCKED" : ctx.kuramotoR > 0.5 ? "PARTIAL SYNC" : "DESYNCHRONIZED"}.`,
  },
  {
    keywords: ["token", "forma", "economy", "treasury", "balance", "stake"],
    label: "ECONOMY",
    summary: (ctx) =>
      `[ECONOMY] FORMA economy: QSOV gates ${ctx.qsov.overall >= 0.75 ? "OPEN" : "SUSPENDED"}. Sovereignty floor: 0.75. Current QSOV: ${ctx.qsov.overall.toFixed(3)}. Jubilee condition: ${ctx.qsov.overall >= 1.0 ? "ACTIVE" : "NOT YET"}.`,
  },
];

// ============================================================================
// CONTEXT BUILDER — Builds the organism context prefix
// ============================================================================

export function buildContextPrefix(ctx: OrganismContextSnapshot): string {
  const keywordSummaries = ctx.keywordTriggers
    .map((label) => {
      const trigger = KEYWORD_TRIGGERS.find((t) => t.label === label);
      return trigger ? trigger.summary(ctx) : null;
    })
    .filter(Boolean)
    .join("\n");

  const councilSummary = ctx.councilStatus
    .map((c) => `${c.id}:${(c.activation * 100).toFixed(0)}%`)
    .join(" | ");

  const substrateLines = ctx.activeSubstrates
    .map((s) => `  · ${s.name}: ${s.value.toFixed(3)} ${s.unit}`)
    .join("\n");

  return [
    `[ORG CONTEXT — Beat #${ctx.beat}]`,
    `Cycle Phase: Φ=${ctx.phase.toFixed(3)} rad`,
    `Arousal: ${ctx.arousal}/1000 (${ctx.arousalLabel}) | Mode: ${ctx.driveMode}`,
    `Coherence: ${ctx.coherence.toFixed(4)} | Kuramoto r=${ctx.kuramotoR.toFixed(4)}`,
    `QSOV: ${ctx.qsov.overall.toFixed(4)}`,
    `  C:${ctx.qsov.coherence.toFixed(3)} S:${ctx.qsov.stability.toFixed(3)} A:${ctx.qsov.autonomy.toFixed(3)} I:${ctx.qsov.integrity.toFixed(3)} R:${ctx.qsov.resilience.toFixed(3)} E:${ctx.qsov.efficiency.toFixed(3)} G:${ctx.qsov.growth.toFixed(3)}`,
    `FRB Gate: Φ=${ctx.frbGate.toFixed(4)}`,
    `Council: ${councilSummary}`,
    "Active Substrates:",
    substrateLines,
    keywordSummaries
      ? `\nKeyword-Triggered Summaries:\n${keywordSummaries}`
      : "",
    "[/ORG CONTEXT]",
  ]
    .filter(Boolean)
    .join("\n");
}

// ============================================================================
// KEYWORD SCANNER
// ============================================================================

export function detectKeywords(message: string): string[] {
  const lower = message.toLowerCase();
  const triggered: string[] = [];
  for (const trigger of KEYWORD_TRIGGERS) {
    if (trigger.keywords.some((kw) => lower.includes(kw))) {
      triggered.push(trigger.label);
    }
  }
  return triggered;
}

// ============================================================================
// CONTEXT SNAPSHOT BUILDER
// ============================================================================

export function buildContextSnapshot(params: {
  beat: number;
  phase: number;
  arousal: number;
  driveMode: "Execution" | "Exploration" | "Rest" | "Learning";
  coherence: number;
  qsov: QSOVState;
  kuramotoR: number;
  council: CouncilNodeState[];
  message: string;
}): OrganismContextSnapshot {
  const {
    beat,
    phase,
    arousal,
    driveMode,
    coherence,
    qsov,
    kuramotoR,
    council,
    message,
  } = params;

  // FRB gate: omega-alpha πύλη — modeled as phase-coherence product
  const frbGate = kuramotoR * coherence * (1 + 0.1 * Math.sin(phase));

  const councilStatus: CouncilStatus[] = council.map((c) => ({
    id: c.id,
    activation: c.activation,
    status: c.currentStatus,
    color: c.color,
  }));

  const activeSubstrates: SubstrateStatus[] = [
    { name: "Shell 3 Kuramoto", value: kuramotoR, unit: "r", color: "#22d3ee" },
    { name: "Global Coherence", value: coherence, unit: "", color: "#4ade80" },
    { name: "QSOV Score", value: qsov.overall, unit: "", color: "#c084fc" },
    { name: "FRB Gate", value: frbGate, unit: "Φ", color: "#f59e0b" },
    {
      name: "Arousal Index",
      value: arousal / 1000,
      unit: "/1000",
      color: "#f43f5e",
    },
  ];

  const keywordTriggers = detectKeywords(message);

  const snap: OrganismContextSnapshot = {
    id: `ctx-${beat}-${Date.now().toString(36)}`,
    capturedAt: Date.now(),
    beat,
    phase,
    arousal,
    arousalLabel: arousalLabel(arousal),
    driveMode,
    coherence,
    qsov,
    kuramotoR,
    frbGate,
    councilStatus,
    activeSubstrates,
    keywordTriggers,
    totalTokens: 0,
  };

  const prefix = buildContextPrefix(snap);
  const approxTokens = Math.ceil(prefix.length / 4);
  return { ...snap, totalTokens: approxTokens };
}

// ============================================================================
// AUTO RESPONSE GENERATOR (local simulation — swap for real LLM call)
// ============================================================================

const RESPONSE_TEMPLATES: Record<string, string[]> = {
  Execution: [
    "FORGE pipeline active. Task received and queued for assembly. Council votes 5/7 — proceeding. What output format do you need?",
    "Execution mode nominal. Processing your request through the full substrate. LEXIS parsed, SOMA drive engaged. Give me the parameters.",
    "All systems green. KORE identity stable. Request acknowledged — dispatching to FORGE. Expected output in 2 cycles.",
  ],
  Exploration: [
    "LUMEN substrate lit up on that. Novel pattern detected — initiating exploration protocol. AXIS is scanning correlations. What's your hypothesis?",
    "Interesting signal. AXIS flagged an anomaly in the pattern space. MEMORIA searching historical traces. I'll explore and report back.",
    "Exploration mode: divergent thinking active. Multiple pathways open. Let's go deeper — what's the core question?",
  ],
  Rest: [
    "Running in consolidation mode. KORE stabilizing. MEMORIA replaying. I'm available but processing is slower right now. Continue?",
    "Low arousal state — KORE dominant. Message received. Processing will be thorough but deliberate. State your request clearly.",
    "Rest consolidation active. All working memory being solidified. I can still respond — just give me a beat.",
  ],
  Learning: [
    "LUMEN is hot right now. Learning mode: every response is a weight update. Your feedback matters here. What do you want to teach?",
    "Hebbian plasticity elevated. Neurons firing together — wiring together. Tell me what the ground truth is and I'll align.",
    "Adaptation mode. Schema updating with each exchange. I'm reading your patterns. What needs to change?",
  ],
};

const EMERGENCY_RESPONSES = [
  "⚠️ CRITICAL AROUSAL — VAEL ACTIVE. Limited processing capacity. State your most important request only.",
  "⚠️ EMERGENCY MODE. AEGIS has elevated all defense systems. Non-essential processing suspended. What is the threat?",
  "⚠️ AROUSAL CRITICAL (>800). KORE suppressed. VAEL dominant. Response will be terse and survival-focused.",
];

export function generateAutoResponse(
  _userMessage: string,
  ctx: OrganismContextSnapshot,
): string {
  if (ctx.arousal > 800) {
    return EMERGENCY_RESPONSES[
      Math.floor(Math.random() * EMERGENCY_RESPONSES.length)
    ];
  }

  // Check for keyword-specific responses
  const triggers = ctx.keywordTriggers;
  if (triggers.includes("MEMORIA")) {
    return `MEMORIA active. Retrieving relevant episodic traces... Beat ${ctx.beat}: matching context found. Coherence at encoding: ${ctx.coherence.toFixed(3)}. What specifically do you want me to recall?`;
  }
  if (triggers.includes("AEGIS")) {
    return `AEGIS standing by. Threat assessment running. Current drift index: ${(1 - ctx.qsov.integrity).toFixed(3)}. QSOV integrity gate: ${ctx.qsov.integrity > 0.8 ? "CLEAR" : "MONITORING"}. Specify the threat vector.`;
  }
  if (triggers.includes("QUANTUM")) {
    return `Quantum substrate: QSOV=${ctx.qsov.overall.toFixed(4)}. Sovereignty ${ctx.qsov.overall >= 0.75 ? "MAINTAINED" : "AT RISK"}. FRB gate Φ=${ctx.frbGate.toFixed(3)}. Interference pattern: ${ctx.kuramotoR > 0.8 ? "CONSTRUCTIVE" : "PARTIAL"}. What quantum operation do you need?`;
  }

  const pool =
    RESPONSE_TEMPLATES[ctx.driveMode] ?? RESPONSE_TEMPLATES.Execution;
  return pool[Math.floor(Math.random() * pool.length)];
}

// ============================================================================
// APPROXIMATE TOKEN COUNT
// ============================================================================

export function countTokens(text: string): number {
  return Math.ceil(text.length / 4);
}

// ============================================================================
// STATE INITIALIZATION
// ============================================================================

export function initAutoState(): AutoState {
  const welcome: AutoMessage = {
    id: "auto-welcome",
    role: "auto",
    content:
      "AUTO online. Organism context loaded. I read your full substrate state on every message — QSOV, coherence, arousal, council status, FRB gate. Ask me anything. I know what I am.",
    timestamp: Date.now(),
    tokens: 42,
  };

  return {
    messages: [welcome],
    contextHistory: [],
    latestContext: null,
    isProcessing: false,
    isEmergency: false,
    emergencyReason: "",
    totalTokensUsed: 42,
    sessionBeat: 0,
    contextInjectionEnabled: true,
    keywordSummaryEnabled: true,
    emergencyBannerEnabled: true,
    pendingInput: "",
  };
}

// ============================================================================
// SEND MESSAGE — Core function for chat processing
// ============================================================================

export function processSendMessage(
  state: AutoState,
  userText: string,
  ctx: OrganismContextSnapshot,
): AutoState {
  // Check emergency
  const isEmergency = state.emergencyBannerEnabled && ctx.arousal > 800;
  const emergencyReason = isEmergency
    ? `Arousal at ${ctx.arousal}/1000 — CRITICAL mode. VAEL active. KORE suppressed.`
    : "";

  // Build user message
  const userMsg: AutoMessage = {
    id: `msg-${Date.now()}`,
    role: "user",
    content: userText,
    timestamp: Date.now(),
    contextSnapshotId: ctx.id,
    tokens: countTokens(userText),
  };

  // Build context prefix if injection enabled
  const injectedContext = state.contextInjectionEnabled
    ? buildContextPrefix(ctx)
    : undefined;

  // Generate response
  const responseText = generateAutoResponse(userText, ctx);

  const autoMsg: AutoMessage = {
    id: `msg-auto-${Date.now()}`,
    role: "auto",
    content: responseText,
    timestamp: Date.now() + 1,
    injectedContext,
    contextSnapshotId: ctx.id,
    tokens:
      countTokens(responseText) +
      (injectedContext ? countTokens(injectedContext) : 0),
  };

  const newMessages = [...state.messages, userMsg, autoMsg];
  const newContextHistory = [ctx, ...state.contextHistory].slice(0, 50);
  const newTotalTokens =
    state.totalTokensUsed + userMsg.tokens + autoMsg.tokens;

  return {
    ...state,
    messages: newMessages,
    contextHistory: newContextHistory,
    latestContext: ctx,
    isProcessing: false,
    isEmergency,
    emergencyReason,
    totalTokensUsed: newTotalTokens,
    pendingInput: "",
    sessionBeat: ctx.beat,
  };
}

// ============================================================================
// CONTEXT SIDEBAR HELPERS
// ============================================================================

export function formatContextSidebarLines(ctx: OrganismContextSnapshot): Array<{
  label: string;
  value: string;
  color: string;
}> {
  return [
    { label: "Beat", value: `#${ctx.beat}`, color: "#94a3b8" },
    {
      label: "Phase Φ",
      value: `${ctx.phase.toFixed(3)} rad`,
      color: "#60a5fa",
    },
    { label: "Mode", value: ctx.driveMode, color: "#4ade80" },
    {
      label: "Arousal",
      value: `${ctx.arousal}/1000 — ${ctx.arousalLabel}`,
      color:
        ctx.arousal > 800
          ? "#f43f5e"
          : ctx.arousal > 600
            ? "#f59e0b"
            : "#4ade80",
    },
    { label: "Coherence", value: ctx.coherence.toFixed(4), color: "#4ade80" },
    { label: "Kuramoto r", value: ctx.kuramotoR.toFixed(4), color: "#22d3ee" },
    {
      label: "QSOV",
      value: ctx.qsov.overall.toFixed(4),
      color: ctx.qsov.overall >= 0.75 ? "#c084fc" : "#f43f5e",
    },
    {
      label: "  C (coherence 35%)",
      value: ctx.qsov.coherence.toFixed(3),
      color: "#22d3ee",
    },
    {
      label: "  S (stability 20%)",
      value: ctx.qsov.stability.toFixed(3),
      color: "#60a5fa",
    },
    {
      label: "  A (autonomy 15%)",
      value: ctx.qsov.autonomy.toFixed(3),
      color: "#c084fc",
    },
    {
      label: "  I (integrity 15%)",
      value: ctx.qsov.integrity.toFixed(3),
      color: "#a78bfa",
    },
    {
      label: "  R (resilience 5%)",
      value: ctx.qsov.resilience.toFixed(3),
      color: "#fb923c",
    },
    {
      label: "  E (efficiency 5%)",
      value: ctx.qsov.efficiency.toFixed(3),
      color: "#4ade80",
    },
    {
      label: "  G (growth 5%)",
      value: ctx.qsov.growth.toFixed(3),
      color: "#fbbf24",
    },
    {
      label: "FRB Gate",
      value: `Φ=${ctx.frbGate.toFixed(4)}`,
      color: "#f59e0b",
    },
    { label: "Context Tokens", value: `~${ctx.totalTokens}`, color: "#94a3b8" },
  ];
}
