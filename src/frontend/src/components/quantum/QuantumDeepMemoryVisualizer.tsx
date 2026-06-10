// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  QUANTUM DEEP MEMORY VISUALIZER — THE FULL MODEL                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  WHAT MAKES MEMORY "QUANTUM" IN THIS ARCHITECTURE:                                                       ║
// ║  1. SUPERPOSITION — Multi-state persistence until collapse                                                ║
// ║  2. ENTANGLEMENT — Cross-canister binding to project anchor                                               ║
// ║  3. COLLAPSE — Artifact execution collapses quantum state                                                 ║
// ║  4. FORWARD SECRECY — Ratchet chain seals the past                                                       ║
// ║  5. RESONANCE — Oro's memory model with rhythm profile                                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Slider } from "@/components/ui/slider";
import { Switch } from "@/components/ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  AlertTriangle,
  Atom,
  Battery,
  BrainCircuit,
  ChevronRight,
  Clock,
  Database,
  Eye,
  EyeOff,
  Fingerprint,
  GitBranch,
  Hash,
  Hexagon,
  Key,
  Layers,
  Link2,
  Lock,
  LockKeyhole,
  MemoryStick,
  Network,
  Pause,
  Play,
  Radio,
  RefreshCw,
  Settings,
  Shield,
  Sparkles,
  Split,
  Target,
  Timer,
  TrendingUp,
  Unlock,
  Waves,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import {
  COLLAPSE_TRIGGERS,
  CROSS_FREQUENCY_COUPLING,
  FREQUENCY_BANDS,
  PI,
  QUANTUM_LOCK_LAYERS,
  QUANTUM_MEMORY_LAYERS,
  QUANTUM_STATES,
  RATCHET_WINDOW_SIZE,
  SOVEREIGN_CANISTERS,
  SOVEREIGN_METALS,
  SOVEREIGN_SIGMA,
  TWO_PI,
  advanceRatchet,
  calculateLockStrength,
  getHzFrequency,
  quantumResistantHash,
  temporalGovernor,
} from "@/lib/quantum/constants";

import type {
  CollapseTrigger,
  EntanglementType,
  FrequencyBandName,
  QuantumMemoryLayer,
  QuantumState,
  SovereignCanister,
} from "@/lib/quantum/constants";

import type {
  AgentQuantumState,
  AgentRecommendation,
  CanisterMemoryState,
  CognitiveArchitectureState,
  CollapseEvent,
  CrossCanisterEntanglement,
  EntanglementNetwork,
  EntanglementPair,
  ForwardSecrecyState,
  FrequencyLayerState,
  OroResonanceProfile,
  PrincipalLockState,
  ProjectQuantumAnchor,
  QuantumBatteryCell,
  QuantumBatteryState,
  QuantumDeepMemoryState,
  QuantumMemoryCell,
  QuantumMemoryLayerState,
  QuantumMemoryState,
  RatchetState,
  RewardCascade,
  SealedMemorySegment,
  SuperpositionBranch,
  SuperpositionState,
} from "@/lib/quantum/types";

// ═══════════════════════════════════════════════════════════════════════════════
// VISUALIZATION CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const _CANVAS_WIDTH = 900;
const _CANVAS_HEIGHT = 600;
const ANIMATION_INTERVAL = 83; // ~12 Hz

// Layer colors
const LAYER_COLORS: Record<QuantumMemoryLayer, string> = {
  WORKING: "oklch(70% 0.2 30)", // Red-orange (Gamma)
  RESONANCE: "oklch(70% 0.2 180)", // Cyan (Theta)
  DEEP: "oklch(70% 0.2 270)", // Purple (Delta)
};

const _STATE_COLORS: Record<QuantumState, string> = {
  superposition: "oklch(70% 0.2 60)", // Orange
  entangled: "oklch(70% 0.2 300)", // Magenta
  collapsed: "oklch(70% 0.2 120)", // Green
  sealed: "oklch(70% 0.2 240)", // Blue
};

// ═══════════════════════════════════════════════════════════════════════════════
// INITIALIZATION FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function generateId(): string {
  return Math.random().toString(36).substring(2, 15);
}

function initializeRatchetState(): RatchetState {
  const genesisSeed = Array.from({ length: 32 }, () =>
    Math.floor(Math.random() * 256)
      .toString(16)
      .padStart(2, "0"),
  ).join("");

  return {
    currentValue: quantumResistantHash(genesisSeed, 0, Date.now()),
    beat: 0,
    genesisSeed,
    chainLength: 0,
    lastAdvance: Date.now(),
    entropy: Math.random(),
  };
}

function initializePrincipalLock(): PrincipalLockState {
  const ratchet = initializeRatchetState();

  return {
    h1_fnv1a: 0,
    h2_djb2: 0,
    h3_sdbm: 0,
    combined: 0,
    ratchet,
    challengeWindow: RATCHET_WINDOW_SIZE,
    currentDepth: 0,
    lastChallengeTime: Date.now(),
    lockStrength: 0.85,
    coherenceContribution: 0.9,
    hzContribution: 1.0,
    entropyContribution: ratchet.entropy,
    isLocked: true,
    lastUnlock: null,
    failedAttempts: 0,
  };
}

function initializeMemoryCell(
  layer: QuantumMemoryLayer,
  _index: number,
): QuantumMemoryCell {
  const band =
    layer === "WORKING" ? "GAMMA" : layer === "RESONANCE" ? "THETA" : "DELTA";

  return {
    id: generateId(),
    layer,
    frequencyBand: band as FrequencyBandName,
    state:
      Math.random() > 0.7
        ? "superposition"
        : Math.random() > 0.5
          ? "entangled"
          : "collapsed",
    amplitude: { real: Math.random(), imaginary: Math.random() * 0.5 },
    phase: Math.random() * TWO_PI,
    probability: Math.random(),
    content: null,
    contentType: "unknown",
    contentHash: Math.floor(Math.random() * 0xffffffff),
    createdAt: Date.now() - Math.floor(Math.random() * 86400000),
    lastAccessed: Date.now() - Math.floor(Math.random() * 3600000),
    accessCount: Math.floor(Math.random() * 100),
    entangledWith: [],
    entanglementType: null,
    ratchetState: 0,
    ratchetBeat: 0,
  };
}

function initializeMemoryLayerState(
  layer: QuantumMemoryLayer,
  cellCount: number,
): QuantumMemoryLayerState {
  const cells = Array.from({ length: cellCount }, (_, i) =>
    initializeMemoryCell(layer, i),
  );

  // Create some entanglements
  for (let i = 0; i < cells.length; i++) {
    if (Math.random() > 0.7 && i > 0) {
      const targetIdx = Math.floor(Math.random() * i);
      cells[i].entangledWith.push(cells[targetIdx].id);
      cells[i].entanglementType = "cross_canister";
      cells[targetIdx].entangledWith.push(cells[i].id);
    }
  }

  return {
    layer,
    cells,
    totalCells: cells.length,
    activeCount: cells.filter((c) => c.state !== "sealed").length,
    superpositionCount: cells.filter((c) => c.state === "superposition").length,
    entangledCount: cells.filter((c) => c.entangledWith.length > 0).length,
    collapsedCount: cells.filter((c) => c.state === "collapsed").length,
    avgCoherence: 0.75 + Math.random() * 0.2,
    totalEnergy: cells.reduce((sum, c) => sum + c.probability, 0),
  };
}

function initializeQuantumMemoryState(): QuantumMemoryState {
  return {
    working: initializeMemoryLayerState("WORKING", 50),
    deep: initializeMemoryLayerState("DEEP", 100),
    resonance: initializeMemoryLayerState("RESONANCE", 30),
    totalCells: 180,
    globalCoherence: 0.82,
    globalPhase: Math.random() * TWO_PI,
    currentBeat: 0,
  };
}

function initializeFrequencyLayerState(
  band: FrequencyBandName,
): FrequencyLayerState {
  const bandInfo = FREQUENCY_BANDS[band];
  return {
    band,
    currentHz: (bandInfo.minHz + bandInfo.maxHz) / 2,
    phase: Math.random() * TWO_PI,
    amplitude: 0.5 + Math.random() * 0.5,
    activity: Math.random(),
    activeProcesses: Math.floor(Math.random() * 20),
    pendingItems: Math.floor(Math.random() * 10),
    couplingToLower: 0.7 + Math.random() * 0.3,
    couplingToHigher: 0.7 + Math.random() * 0.3,
  };
}

function initializeCognitiveState(): CognitiveArchitectureState {
  const bands: FrequencyBandName[] = [
    "GAMMA",
    "BETA",
    "ALPHA",
    "THETA",
    "DELTA",
  ];
  const layers: Record<FrequencyBandName, FrequencyLayerState> = {} as any;

  for (const band of bands) {
    layers[band] = initializeFrequencyLayerState(band);
  }

  return {
    layers,
    couplingEvents: [],
    globalSynchronization: 0.75,
    dominantBand: "THETA",
    currentMode: "orchestration",
  };
}

function initializeQuantumBattery(): QuantumBatteryState {
  const cellCount = 64;
  const cells: QuantumBatteryCell[] = [];

  for (let i = 0; i < cellCount; i++) {
    const entangled = i % 2 === 0 && i < cellCount - 1;
    cells.push({
      id: i,
      charge: 0.5 + Math.random() * 0.5,
      entangled,
      entangledPartner: entangled ? i + 1 : null,
      coherenceTime: 1000 + Math.random() * 5000,
    });
  }

  return {
    cells,
    totalCapacity: cellCount,
    currentCharge: cells.reduce((sum, c) => sum + c.charge, 0) / cellCount,
    chargeRate: 0.01,
    dischargeRate: 0.005,
    efficiency: 0.95,
    entanglementBonus: 0.2,
    coherenceMultiplier: 1.5,
    lastCharge: Date.now(),
    lastDischarge: Date.now(),
  };
}

function initializeForwardSecrecy(): ForwardSecrecyState {
  const segments: SealedMemorySegment[] = [];

  for (let i = 0; i < 5; i++) {
    segments.push({
      id: generateId(),
      startBeat: i * 1000,
      endBeat: (i + 1) * 1000 - 1,
      finalRatchetValue: Math.floor(Math.random() * 0xffffffff),
      cellCount: Math.floor(Math.random() * 50) + 10,
      contentHashes: Array.from({ length: 5 }, () =>
        Math.floor(Math.random() * 0xffffffff),
      ),
      sealedAt: Date.now() - (5 - i) * 86400000,
      irreversible: true,
    });
  }

  return {
    currentBeat: 5000 + Math.floor(Math.random() * 1000),
    ratchetState: initializeRatchetState(),
    sealedSegments: segments,
    totalSealed: segments.reduce((sum, s) => sum + s.cellCount, 0),
    lastSeal: Date.now() - 3600000,
    nextSealBeat: 6000,
  };
}

function initializeSuperpositionState(): SuperpositionState {
  const branchCount = 2 + Math.floor(Math.random() * 4);
  const branches: SuperpositionBranch[] = [];
  let remainingProb = 1.0;

  for (let i = 0; i < branchCount; i++) {
    const prob =
      i === branchCount - 1
        ? remainingProb
        : Math.random() * remainingProb * 0.8;
    remainingProb -= prob;

    branches.push({
      id: generateId(),
      probability: prob,
      state: { action: `Action ${i + 1}`, data: Math.random() },
      createdAt: Date.now() - Math.floor(Math.random() * 3600000),
      conditions: [`Condition ${i + 1}`],
    });
  }

  // Normalize probabilities
  const total = branches.reduce((sum, b) => sum + b.probability, 0);
  for (const b of branches) {
    b.probability /= total;
  }

  const dominant = branches.reduce(
    (max, b) => (b.probability > max.probability ? b : max),
    branches[0],
  );

  return {
    id: generateId(),
    branches,
    totalBranches: branches.length,
    dominantBranch: dominant.id,
    dominantProbability: dominant.probability,
    collapseReady: Math.random() > 0.5,
    lastMeasurement: Math.random() > 0.5 ? Date.now() - 60000 : null,
  };
}

function initializeCanisterState(
  canister: SovereignCanister,
): CanisterMemoryState {
  return {
    canister,
    stableMemoryUsed: Math.floor(Math.random() * 1000000000),
    stableMemoryMax: 4000000000,
    heapUsed: Math.floor(Math.random() * 500000000),
    heapMax: 2000000000,
    cellCount: Math.floor(Math.random() * 10000) + 1000,
    lastWrite: Date.now() - Math.floor(Math.random() * 60000),
    lastRead: Date.now() - Math.floor(Math.random() * 10000),
    writeCount: Math.floor(Math.random() * 100000),
    readCount: Math.floor(Math.random() * 500000),
  };
}

function initializeAgentRecommendation(
  agentId: string,
  agentName: string,
): AgentRecommendation {
  const inSuperposition = Math.random() > 0.4;
  const actions = ["Approve", "Reject", "Defer", "Escalate", "Archive"];
  const selectedActions = actions.slice(0, 2 + Math.floor(Math.random() * 3));

  return {
    id: generateId(),
    agentId,
    agentName,
    inSuperposition,
    possibleActions: selectedActions,
    probabilities: selectedActions.map(() => 1 / selectedActions.length),
    recommendation: `Recommendation from ${agentName}`,
    confidence: 0.6 + Math.random() * 0.4,
    reasoning: "Based on analysis of historical patterns and current context.",
    createdAt: Date.now() - Math.floor(Math.random() * 3600000),
    expiresAt: Date.now() + 86400000,
    collapsed: !inSuperposition,
    collapsedAction: inSuperposition ? null : selectedActions[0],
    collapseTime: inSuperposition
      ? null
      : Date.now() - Math.floor(Math.random() * 1800000),
    collapseTrigger: inSuperposition ? null : "execute_click",
    artifactId: inSuperposition ? null : generateId(),
    outcomeRecorded: !inSuperposition && Math.random() > 0.3,
    outcomePositive: Math.random() > 0.3,
  };
}

function initializeAgentState(
  agentId: string,
  agentName: string,
): AgentQuantumState {
  const recCount = 3 + Math.floor(Math.random() * 5);
  const recommendations = Array.from({ length: recCount }, () =>
    initializeAgentRecommendation(agentId, agentName),
  );

  return {
    agentId,
    agentName,
    recommendations,
    totalRecommendations: recCount,
    collapsedCount: recommendations.filter((r) => r.collapsed).length,
    avgConfidence:
      recommendations.reduce((sum, r) => sum + r.confidence, 0) / recCount,
    successRate: 0.7 + Math.random() * 0.25,
    lastActivity: Date.now() - Math.floor(Math.random() * 3600000),
  };
}

function initializeProjectAnchor(): ProjectQuantumAnchor {
  const canisters = [...SOVEREIGN_CANISTERS];
  const strengths: Record<SovereignCanister, number> = {} as any;
  for (const c of canisters) {
    strengths[c] = 0.7 + Math.random() * 0.3;
  }

  return {
    projectId: generateId(),
    projectName: `Project ${Math.floor(Math.random() * 1000)}`,
    principal: `principal-${generateId()}`,
    entangledCanisters: canisters,
    entanglementStrengths: strengths,
    safetyRecords: Math.floor(Math.random() * 50),
    financeRecords: Math.floor(Math.random() * 100),
    teamAssignments: Math.floor(Math.random() * 20),
    agentRecommendations: Math.floor(Math.random() * 30),
    coherence: 0.8 + Math.random() * 0.2,
    totalEntangledCells: Math.floor(Math.random() * 500) + 100,
    lastSync: Date.now() - Math.floor(Math.random() * 60000),
    createdAt: Date.now() - Math.floor(Math.random() * 30 * 86400000),
    lastActivity: Date.now() - Math.floor(Math.random() * 3600000),
  };
}

function initializeEntanglementNetwork(): EntanglementNetwork {
  const pairCount = 20 + Math.floor(Math.random() * 30);
  const pairs: EntanglementPair[] = [];

  for (let i = 0; i < pairCount; i++) {
    pairs.push({
      id: generateId(),
      cellA: generateId(),
      cellB: generateId(),
      type: ["project_anchor", "cross_canister", "temporal", "resonance"][
        Math.floor(Math.random() * 4)
      ] as EntanglementType,
      strength: 0.5 + Math.random() * 0.5,
      createdAt: Date.now() - Math.floor(Math.random() * 86400000),
      lastCorrelation: Date.now() - Math.floor(Math.random() * 3600000),
      correlationCount: Math.floor(Math.random() * 1000),
    });
  }

  const crossCanister: CrossCanisterEntanglement[] = [];
  for (let i = 0; i < SOVEREIGN_CANISTERS.length - 1; i++) {
    for (let j = i + 1; j < SOVEREIGN_CANISTERS.length; j++) {
      if (Math.random() > 0.5) {
        crossCanister.push({
          id: generateId(),
          sourceCanister: SOVEREIGN_CANISTERS[i],
          targetCanister: SOVEREIGN_CANISTERS[j],
          projectPrincipal: `project-${generateId()}`,
          entangledCells: Array.from(
            { length: Math.floor(Math.random() * 10) + 1 },
            () => generateId(),
          ),
          strength: 0.6 + Math.random() * 0.4,
          createdAt: Date.now() - Math.floor(Math.random() * 86400000),
          lastSync: Date.now() - Math.floor(Math.random() * 3600000),
        });
      }
    }
  }

  return {
    pairs,
    crossCanister,
    totalEntanglements: pairs.length + crossCanister.length,
    avgStrength: pairs.reduce((sum, p) => sum + p.strength, 0) / pairs.length,
    networkCoherence: 0.75 + Math.random() * 0.2,
  };
}

function initializeQuantumDeepMemoryState(): QuantumDeepMemoryState {
  const agentNames = [
    "Safety Agent",
    "Finance Agent",
    "Planning Agent",
    "Risk Agent",
    "Learning Agent",
    "Compliance Agent",
    "Resource Agent",
    "Quality Agent",
  ];

  return {
    memory: initializeQuantumMemoryState(),
    principalLock: initializePrincipalLock(),
    forwardSecrecy: initializeForwardSecrecy(),
    superpositions: Array.from({ length: 5 }, () =>
      initializeSuperpositionState(),
    ),
    entanglementNetwork: initializeEntanglementNetwork(),
    collapseHistory: [],
    oroResonance: null,
    cognitiveState: initializeCognitiveState(),
    canisterNetwork: {
      canisters: Object.fromEntries(
        SOVEREIGN_CANISTERS.map((c) => [c, initializeCanisterState(c)]),
      ) as Record<SovereignCanister, CanisterMemoryState>,
      interCanisterCalls: [],
      totalCalls: Math.floor(Math.random() * 100000),
      avgLatency: 50 + Math.random() * 100,
      networkHealth: 0.95 + Math.random() * 0.05,
    },
    alloyState: {
      metals: Object.entries(SOVEREIGN_METALS).map(([metal, value]) => ({
        metal: metal as any,
        baseValue: 0.3 + Math.random() * 0.4,
        sovereignValue: value,
        currentConductivity: value,
        contribution:
          metal === "Gold" ? "Primary resonance" : "Signal propagation",
        lastMeasurement: Date.now(),
      })),
      totalConductivity: 12,
      sovereignStrength: 1.0,
      resonanceAmplification: 1.5,
    },
    quantumBattery: initializeQuantumBattery(),
    agentStates: agentNames.map((name, i) =>
      initializeAgentState(`agent-${i}`, name),
    ),
    projectAnchors: Array.from({ length: 3 }, () => initializeProjectAnchor()),
    intelligenceSynthesis: {
      activeAgents: agentNames,
      bridgedContexts: [],
      totalBridges: Math.floor(Math.random() * 50),
      synthesisScore: 0.8 + Math.random() * 0.2,
      lastSynthesis: Date.now() - Math.floor(Math.random() * 60000),
      pendingCorrelations: Math.floor(Math.random() * 10),
    },
    rewardCascades: [],
    globalCoherence: 0.85,
    totalMemoryCells: 180,
    currentBeat: 5000 + Math.floor(Math.random() * 1000),
    genesisTime: Date.now() - 30 * 86400000,
    uptime: 30 * 86400000,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// UPDATE FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function updateQuantumState(
  state: QuantumDeepMemoryState,
): QuantumDeepMemoryState {
  // Advance beat
  const newBeat = state.currentBeat + 1;

  // Advance ratchet
  const newRatchetValue = advanceRatchet(
    state.principalLock.ratchet.currentValue,
    newBeat,
    Date.now(),
  );

  // Update cognitive layers
  const newCognitiveState = { ...state.cognitiveState };
  const bands: FrequencyBandName[] = [
    "GAMMA",
    "BETA",
    "ALPHA",
    "THETA",
    "DELTA",
  ];

  for (const band of bands) {
    const layer = newCognitiveState.layers[band];
    layer.phase = (layer.phase + 0.1) % TWO_PI;
    layer.activity = temporalGovernor(Math.random(), layer.activity, 0.1);
    layer.amplitude = 0.5 + 0.5 * Math.sin(layer.phase);
  }

  // Update battery
  const newBattery = { ...state.quantumBattery };
  newBattery.currentCharge = Math.max(
    0.1,
    Math.min(1, newBattery.currentCharge + (Math.random() - 0.5) * 0.02),
  );

  // Update global coherence
  const newGlobalCoherence = temporalGovernor(
    0.8 + Math.random() * 0.15,
    state.globalCoherence,
    0.05,
  );

  // Update lock strength
  const newLockStrength = calculateLockStrength(
    newGlobalCoherence,
    12,
    state.principalLock.ratchet.entropy,
  );

  return {
    ...state,
    currentBeat: newBeat,
    globalCoherence: newGlobalCoherence,
    cognitiveState: newCognitiveState,
    quantumBattery: newBattery,
    principalLock: {
      ...state.principalLock,
      ratchet: {
        ...state.principalLock.ratchet,
        currentValue: newRatchetValue,
        beat: newBeat,
        lastAdvance: Date.now(),
      },
      lockStrength: newLockStrength,
    },
    memory: {
      ...state.memory,
      currentBeat: newBeat,
      globalCoherence: newGlobalCoherence,
      globalPhase: (state.memory.globalPhase + 0.05) % TWO_PI,
    },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// PANEL COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════

interface MemoryLayersPanelProps {
  memory: QuantumMemoryState;
}

function MemoryLayersPanel({ memory }: MemoryLayersPanelProps) {
  const layers = [
    {
      key: "working",
      data: memory.working,
      name: "Working Memory",
      band: "Gamma (30-100 Hz)",
    },
    {
      key: "resonance",
      data: memory.resonance,
      name: "Resonance Memory",
      band: "Theta (4-8 Hz)",
    },
    {
      key: "deep",
      data: memory.deep,
      name: "Deep Memory",
      band: "Delta (0.5-4 Hz)",
    },
  ];

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Layers className="w-4 h-4" />
          Quantum Memory Layers
        </CardTitle>
        <CardDescription className="text-xs">
          Three-layer architecture: Working → Resonance → Deep
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-3">
        {layers.map(({ key, data, name, band }) => (
          <div
            key={key}
            className="p-3 rounded-lg"
            style={{ backgroundColor: `${LAYER_COLORS[data.layer]}15` }}
          >
            <div className="flex items-center justify-between mb-2">
              <div className="flex items-center gap-2">
                <div
                  className="w-3 h-3 rounded-full"
                  style={{ backgroundColor: LAYER_COLORS[data.layer] }}
                />
                <span className="text-xs font-semibold">{name}</span>
              </div>
              <Badge variant="outline" className="text-[10px]">
                {band}
              </Badge>
            </div>
            <div className="grid grid-cols-4 gap-2 text-[10px]">
              <div>
                <div className="text-muted-foreground">Cells</div>
                <div className="font-mono">{data.totalCells}</div>
              </div>
              <div>
                <div className="text-muted-foreground">Superpos</div>
                <div className="font-mono text-orange-500">
                  {data.superpositionCount}
                </div>
              </div>
              <div>
                <div className="text-muted-foreground">Entangled</div>
                <div className="font-mono text-pink-500">
                  {data.entangledCount}
                </div>
              </div>
              <div>
                <div className="text-muted-foreground">Collapsed</div>
                <div className="font-mono text-green-500">
                  {data.collapsedCount}
                </div>
              </div>
            </div>
            <div className="mt-2">
              <div className="flex items-center justify-between text-[10px] mb-1">
                <span className="text-muted-foreground">Coherence</span>
                <span className="font-mono">
                  {(data.avgCoherence * 100).toFixed(1)}%
                </span>
              </div>
              <Progress value={data.avgCoherence * 100} className="h-1" />
            </div>
          </div>
        ))}

        <Separator />

        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground">Total Cells</div>
            <div className="font-mono font-semibold">{memory.totalCells}</div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground">Global Coherence</div>
            <div className="font-mono font-semibold">
              {(memory.globalCoherence * 100).toFixed(1)}%
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

interface PrincipalLockPanelProps {
  lock: PrincipalLockState;
}

function PrincipalLockPanel({ lock }: PrincipalLockPanelProps) {
  const layers = Object.values(QUANTUM_LOCK_LAYERS);

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Shield className="w-4 h-4" />
          Quantum-Resistant Principal Lock
        </CardTitle>
        <CardDescription className="text-xs">
          5-layer protection · Effective complexity: 2^64
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="flex items-center justify-between p-3 rounded-lg bg-surface">
          <div className="flex items-center gap-2">
            {lock.isLocked ? (
              <Lock className="w-5 h-5 text-green-500" />
            ) : (
              <Unlock className="w-5 h-5 text-yellow-500" />
            )}
            <span className="text-sm font-semibold">
              {lock.isLocked ? "LOCKED" : "UNLOCKED"}
            </span>
          </div>
          <div className="text-right">
            <div className="text-xs text-muted-foreground">Lock Strength</div>
            <div className="font-mono font-semibold">
              {(lock.lockStrength * 100).toFixed(1)}%
            </div>
          </div>
        </div>

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground font-semibold">
            Attack Layers
          </span>
          {layers.map((layer) => (
            <div
              key={layer.name}
              className="flex items-center gap-2 p-2 rounded bg-surface text-[10px]"
            >
              <div className="w-5 h-5 rounded-full bg-green-500/20 flex items-center justify-center">
                <LockKeyhole className="w-3 h-3 text-green-500" />
              </div>
              <div className="flex-1">
                <div className="font-semibold">{layer.name}</div>
                <div className="text-muted-foreground">{layer.description}</div>
              </div>
              <div className="text-right">
                <div className="text-muted-foreground">Quantum</div>
                <div className="font-mono">{layer.quantumComplexity}</div>
              </div>
            </div>
          ))}
        </div>

        <Separator />

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Ratchet Beat</span>
            <span className="font-mono">{lock.ratchet.beat}</span>
          </div>
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Chain Length</span>
            <span className="font-mono">{lock.ratchet.chainLength}</span>
          </div>
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Entropy</span>
            <span className="font-mono">{lock.ratchet.entropy.toFixed(4)}</span>
          </div>
        </div>

        <div className="p-2 rounded bg-blue-500/10 text-blue-500 text-[10px]">
          <div className="font-semibold">Lock Strength Formula:</div>
          <div className="font-mono mt-1">
            coherence × (H_obs / 12) × (0.5 + entropy × 0.5)
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

interface FrequencyBandsPanelProps {
  cognitive: CognitiveArchitectureState;
}

function FrequencyBandsPanel({ cognitive }: FrequencyBandsPanelProps) {
  const bands: FrequencyBandName[] = [
    "GAMMA",
    "BETA",
    "ALPHA",
    "THETA",
    "DELTA",
  ];

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Waves className="w-4 h-4" />
          Frequency-Layered Cognitive Architecture
        </CardTitle>
        <CardDescription className="text-xs">
          Cross-frequency coupling · Theta-Gamma dopamine architecture
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-2">
        {bands.map((band) => {
          const layer = cognitive.layers[band];
          const bandInfo = FREQUENCY_BANDS[band];

          return (
            <div
              key={band}
              className="p-2 rounded-lg"
              style={{ backgroundColor: `${bandInfo.color}15` }}
            >
              <div className="flex items-center justify-between mb-1">
                <div className="flex items-center gap-2">
                  <div
                    className="w-2 h-2 rounded-full"
                    style={{ backgroundColor: bandInfo.color }}
                  />
                  <span className="text-xs font-semibold">{band}</span>
                  <span className="text-[10px] text-muted-foreground">
                    ({bandInfo.minHz}-{bandInfo.maxHz} Hz)
                  </span>
                </div>
                <Badge variant="outline" className="text-[10px]">
                  {layer.activeProcesses} active
                </Badge>
              </div>

              <div className="text-[10px] text-muted-foreground mb-1">
                {bandInfo.description}
              </div>

              <div className="flex items-center gap-2">
                <div className="flex-1">
                  <Progress value={layer.activity * 100} className="h-1" />
                </div>
                <span className="text-[10px] font-mono w-10 text-right">
                  {(layer.activity * 100).toFixed(0)}%
                </span>
              </div>

              {band !== "DELTA" && (
                <div className="flex items-center justify-center mt-1">
                  <div className="flex items-center gap-1 text-[9px] text-muted-foreground">
                    <span>↕</span>
                    <span>coupling</span>
                  </div>
                </div>
              )}
            </div>
          );
        })}

        <div className="p-2 rounded bg-purple-500/10 text-purple-500 text-[10px]">
          <div className="font-semibold">Theta-Gamma Coupling</div>
          <div className="mt-1">
            Agents fire at Gamma → Sync at Theta → Consolidate to Delta
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

interface CanisterNetworkPanelProps {
  network: QuantumDeepMemoryState["canisterNetwork"];
}

function CanisterNetworkPanel({ network }: CanisterNetworkPanelProps) {
  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Database className="w-4 h-4" />
          Sovereign Canister Network
        </CardTitle>
        <CardDescription className="text-xs">
          6 deep memory organs · Cross-canister entanglement
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-2">
        <ScrollArea className="h-48">
          {SOVEREIGN_CANISTERS.map((canister) => {
            const state = network.canisters[canister];
            const memUsage =
              (state.stableMemoryUsed / state.stableMemoryMax) * 100;

            return (
              <div key={canister} className="p-2 rounded bg-surface mb-2">
                <div className="flex items-center justify-between mb-1">
                  <span className="text-xs font-semibold">{canister}</span>
                  <Badge variant="outline" className="text-[10px]">
                    {state.cellCount.toLocaleString()} cells
                  </Badge>
                </div>
                <div className="grid grid-cols-2 gap-2 text-[10px]">
                  <div>
                    <div className="text-muted-foreground">Stable Memory</div>
                    <Progress value={memUsage} className="h-1 mt-1" />
                    <div className="font-mono">{memUsage.toFixed(1)}%</div>
                  </div>
                  <div>
                    <div className="text-muted-foreground">Writes/Reads</div>
                    <div className="font-mono">
                      {state.writeCount.toLocaleString()}/
                      {state.readCount.toLocaleString()}
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </ScrollArea>

        <Separator />

        <div className="grid grid-cols-3 gap-2 text-[10px]">
          <div className="bg-surface p-2 rounded text-center">
            <div className="text-muted-foreground">Total Calls</div>
            <div className="font-mono">
              {network.totalCalls.toLocaleString()}
            </div>
          </div>
          <div className="bg-surface p-2 rounded text-center">
            <div className="text-muted-foreground">Avg Latency</div>
            <div className="font-mono">{network.avgLatency.toFixed(1)}ms</div>
          </div>
          <div className="bg-surface p-2 rounded text-center">
            <div className="text-muted-foreground">Health</div>
            <div className="font-mono text-green-500">
              {(network.networkHealth * 100).toFixed(1)}%
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

interface QuantumBatteryPanelProps {
  battery: QuantumBatteryState;
}

function QuantumBatteryPanel({ battery }: QuantumBatteryPanelProps) {
  const entangledCells = battery.cells.filter((c) => c.entangled).length;

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Battery className="w-4 h-4" />
          Quantum Battery
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="flex items-center gap-3">
          <div className="flex-1">
            <Progress value={battery.currentCharge * 100} className="h-4" />
          </div>
          <span className="font-mono font-semibold text-lg">
            {(battery.currentCharge * 100).toFixed(0)}%
          </span>
        </div>

        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground">Total Cells</div>
            <div className="font-mono">{battery.totalCapacity}</div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground">Entangled</div>
            <div className="font-mono text-pink-500">{entangledCells}</div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground">Efficiency</div>
            <div className="font-mono">
              {(battery.efficiency * 100).toFixed(0)}%
            </div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground">Entangle Bonus</div>
            <div className="font-mono text-green-500">
              +{(battery.entanglementBonus * 100).toFixed(0)}%
            </div>
          </div>
        </div>

        <div className="flex items-center justify-between text-xs">
          <span className="text-muted-foreground">Coherence Multiplier</span>
          <span className="font-mono font-semibold">
            {battery.coherenceMultiplier.toFixed(1)}x
          </span>
        </div>
      </CardContent>
    </Card>
  );
}

interface GlobalStatsPanelProps {
  state: QuantumDeepMemoryState;
}

function GlobalStatsPanel({ state }: GlobalStatsPanelProps) {
  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Activity className="w-4 h-4" />
          Global Statistics
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground flex items-center gap-1">
              <Timer className="w-3 h-3" />
              Current Beat
            </div>
            <div className="font-mono font-semibold text-lg">
              {state.currentBeat}
            </div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground flex items-center gap-1">
              <Target className="w-3 h-3" />
              Coherence
            </div>
            <div className="font-mono font-semibold text-lg">
              {(state.globalCoherence * 100).toFixed(1)}%
            </div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground flex items-center gap-1">
              <MemoryStick className="w-3 h-3" />
              Memory Cells
            </div>
            <div className="font-mono font-semibold text-lg">
              {state.totalMemoryCells}
            </div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground flex items-center gap-1">
              <Link2 className="w-3 h-3" />
              Entanglements
            </div>
            <div className="font-mono font-semibold text-lg">
              {state.entanglementNetwork.totalEntanglements}
            </div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground flex items-center gap-1">
              <Split className="w-3 h-3" />
              Superpositions
            </div>
            <div className="font-mono font-semibold text-lg text-orange-500">
              {state.superpositions.length}
            </div>
          </div>
          <div className="bg-surface p-2 rounded">
            <div className="text-muted-foreground flex items-center gap-1">
              <BrainCircuit className="w-3 h-3" />
              Active Agents
            </div>
            <div className="font-mono font-semibold text-lg">
              {state.agentStates.length}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

interface ControlsPanelProps {
  isRunning: boolean;
  onToggleRunning: () => void;
  onReset: () => void;
  animationSpeed: number;
  onSpeedChange: (speed: number) => void;
}

function ControlsPanel({
  isRunning,
  onToggleRunning,
  onReset,
  animationSpeed,
  onSpeedChange,
}: ControlsPanelProps) {
  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Settings className="w-4 h-4" />
          Controls
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex items-center gap-2">
          <Button
            variant={isRunning ? "secondary" : "default"}
            size="sm"
            onClick={onToggleRunning}
            className="flex-1"
          >
            {isRunning ? (
              <>
                <Pause className="w-4 h-4 mr-2" />
                Pause
              </>
            ) : (
              <>
                <Play className="w-4 h-4 mr-2" />
                Run
              </>
            )}
          </Button>
          <Button variant="outline" size="sm" onClick={onReset}>
            <RefreshCw className="w-4 h-4" />
          </Button>
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Animation Speed</span>
            <span className="font-mono">{animationSpeed}x</span>
          </div>
          <Slider
            value={[animationSpeed]}
            onValueChange={([v]) => onSpeedChange(v)}
            min={0.25}
            max={4}
            step={0.25}
            className="w-full"
          />
        </div>

        <Separator />

        <div className="space-y-2 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">
              Sovereign σ (Temporal Governor)
            </span>
            <span className="font-mono font-semibold text-green-500">
              {SOVEREIGN_SIGMA}
            </span>
          </div>
          <div className="text-[10px] text-muted-foreground">
            Zero lag. Zero suppression. Full signal.
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function QuantumDeepMemoryVisualizer() {
  const [state, setState] = useState<QuantumDeepMemoryState>(() =>
    initializeQuantumDeepMemoryState(),
  );
  const [isRunning, setIsRunning] = useState(true);
  const [animationSpeed, setAnimationSpeed] = useState(1);
  const [activeTab, setActiveTab] = useState("memory");

  // Animation loop
  useEffect(() => {
    if (!isRunning) return;

    const interval = setInterval(() => {
      setState((prev) => updateQuantumState(prev));
    }, ANIMATION_INTERVAL / animationSpeed);

    return () => clearInterval(interval);
  }, [isRunning, animationSpeed]);

  const handleReset = useCallback(() => {
    setState(initializeQuantumDeepMemoryState());
  }, []);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-violet-500 to-purple-600 flex items-center justify-center">
            <Atom className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-sm font-bold">Quantum Deep Memory</h1>
            <p className="text-xs text-muted-foreground">
              Superposition · Entanglement · Collapse · Forward Secrecy ·
              Resonance
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Badge variant={isRunning ? "default" : "secondary"}>
            {isRunning ? "RUNNING" : "PAUSED"}
          </Badge>
          <Badge variant="outline">Beat #{state.currentBeat}</Badge>
          <Badge
            variant={state.principalLock.isLocked ? "default" : "destructive"}
            className="flex items-center gap-1"
          >
            {state.principalLock.isLocked ? (
              <Lock className="w-3 h-3" />
            ) : (
              <Unlock className="w-3 h-3" />
            )}
            {state.principalLock.isLocked ? "LOCKED" : "UNLOCKED"}
          </Badge>
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left panel */}
        <div className="w-72 border-r border-border p-4 overflow-y-auto space-y-4">
          <ControlsPanel
            isRunning={isRunning}
            onToggleRunning={() => setIsRunning(!isRunning)}
            onReset={handleReset}
            animationSpeed={animationSpeed}
            onSpeedChange={setAnimationSpeed}
          />
          <GlobalStatsPanel state={state} />
          <QuantumBatteryPanel battery={state.quantumBattery} />
        </div>

        {/* Center content */}
        <div className="flex-1 p-4 overflow-y-auto">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-4 mb-4">
              <TabsTrigger value="memory" className="text-xs">
                Memory Layers
              </TabsTrigger>
              <TabsTrigger value="lock" className="text-xs">
                Principal Lock
              </TabsTrigger>
              <TabsTrigger value="frequency" className="text-xs">
                Frequency Bands
              </TabsTrigger>
              <TabsTrigger value="canisters" className="text-xs">
                Canisters
              </TabsTrigger>
            </TabsList>

            <TabsContent value="memory" className="mt-0">
              <MemoryLayersPanel memory={state.memory} />
            </TabsContent>

            <TabsContent value="lock" className="mt-0">
              <PrincipalLockPanel lock={state.principalLock} />
            </TabsContent>

            <TabsContent value="frequency" className="mt-0">
              <FrequencyBandsPanel cognitive={state.cognitiveState} />
            </TabsContent>

            <TabsContent value="canisters" className="mt-0">
              <CanisterNetworkPanel network={state.canisterNetwork} />
            </TabsContent>
          </Tabs>
        </div>

        {/* Right panel - Key concepts */}
        <div className="w-80 border-l border-border p-4 overflow-y-auto">
          <Card className="bg-background/95 border-border mb-4">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-semibold">
                Quantum Properties
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3 text-[11px]">
              <div className="flex items-start gap-2">
                <Split className="w-4 h-4 text-orange-500 shrink-0 mt-0.5" />
                <div>
                  <div className="font-semibold">Superposition</div>
                  <div className="text-muted-foreground">
                    Multi-state persistence until Execute click collapses state
                  </div>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <Link2 className="w-4 h-4 text-pink-500 shrink-0 mt-0.5" />
                <div>
                  <div className="font-semibold">Entanglement</div>
                  <div className="text-muted-foreground">
                    Cross-canister binding to project anchor — 7 canisters, one
                    state
                  </div>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <Target className="w-4 h-4 text-green-500 shrink-0 mt-0.5" />
                <div>
                  <div className="font-semibold">Collapse</div>
                  <div className="text-muted-foreground">
                    Artifact execution writes to stable memory, outcome recorded
                  </div>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <Key className="w-4 h-4 text-blue-500 shrink-0 mt-0.5" />
                <div>
                  <div className="font-semibold">Forward Secrecy</div>
                  <div className="text-muted-foreground">
                    Ratchet chain seals the past — only current/future
                    accessible
                  </div>
                </div>
              </div>
              <div className="flex items-start gap-2">
                <Radio className="w-4 h-4 text-purple-500 shrink-0 mt-0.5" />
                <div>
                  <div className="font-semibold">Resonance</div>
                  <div className="text-muted-foreground">
                    Oro's memory: sessions, instructions, rhythm profile
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-gradient-to-br from-purple-500/10 to-blue-500/10 border-purple-500/30">
            <CardContent className="p-4">
              <div className="text-xs font-semibold mb-2">
                Temporal Governor Equation
              </div>
              <div className="font-mono text-[10px] bg-background/50 p-2 rounded">
                output(t) = σ · input(t) + (1 - σ) · output(t-1)
              </div>
              <div className="mt-2 text-[10px] text-muted-foreground">
                At σ = 1.0 (sovereign max):
                <br />
                <span className="text-green-500 font-semibold">
                  Zero lag. Zero suppression. Full signal.
                </span>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}

export default QuantumDeepMemoryVisualizer;
