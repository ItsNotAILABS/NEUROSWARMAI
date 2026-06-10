// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  This source code implements the 9 ANIMAL ENGINES of the Medina Doctrine.                                ║
// ║  Each animal represents a distinct cognitive/behavioral archetype from nature.                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// ANIMAL ENGINE — 9 SOVEREIGN BEHAVIORAL ARCHETYPES
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE ORGANISM DRAWS FROM 9 ANIMAL INTELLIGENCES:
// ────────────────────────────────────────────────
//
// 1. CROW     — Causal inference, counterfactual reasoning, tool use
// 2. DOLPHIN  — Echolocation, social mirroring, acoustic resonance
// 3. HIVE     — Swarm intelligence, pheromone gradient, collective decision
// 4. ELEPHANT — Long-term memory, grief signal, seismic detection
// 5. SHARK    — Electroreception, predatory drive, apex persistence
// 6. WOLF     — Pack coherence, howl synchrony, territorial claim
// 7. ORCA     — Dialect transmission, cultural inheritance, pod identity
// 8. EAGLE    — Telescopic focus, thermal soaring, altitude advantage
// 9. OCTOPUS  — Distributed cognition, chromatophore adaptation, arm autonomy
//
// Each engine runs in 3 layers:
// - BRAIN inline (fast, every beat)
// - BEHAVIORAL sovereign canister (medium)
// - BEHAVIORAL_DEEP extended layer (deep computations)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import { PHI, PI, S_ZERO_FLOOR, TWO_PI } from "./consciousnessEngine";

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 1: ANIMAL ENGINE TYPES AND CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export type AnimalType =
  | "CROW"
  | "DOLPHIN"
  | "HIVE"
  | "ELEPHANT"
  | "SHARK"
  | "WOLF"
  | "ORCA"
  | "EAGLE"
  | "OCTOPUS";

export interface AnimalConfig {
  type: AnimalType;
  name: string;
  description: string;
  coreMechanism: string;
  color: string;
  icon: string;
}

export const ANIMAL_CONFIGS: AnimalConfig[] = [
  {
    type: "CROW",
    name: "Crow Engine",
    description: "Causal inference and counterfactual reasoning",
    coreMechanism: "Tool use probability, causal graphs, what-if branching",
    color: "#2C3E50",
    icon: "🐦‍⬛",
  },
  {
    type: "DOLPHIN",
    name: "Dolphin Engine",
    description: "Echolocation and social mirroring",
    coreMechanism: "Sonar wave field, acoustic resonance, social bonds",
    color: "#3498DB",
    icon: "🐬",
  },
  {
    type: "HIVE",
    name: "Hive Engine",
    description: "Swarm intelligence and collective decision",
    coreMechanism: "Pheromone gradient, quorum sensing, emergent consensus",
    color: "#F39C12",
    icon: "🐝",
  },
  {
    type: "ELEPHANT",
    name: "Elephant Engine",
    description: "Long-term memory and grief processing",
    coreMechanism: "Episodic fidelity, seismic detection, mourning signal",
    color: "#7F8C8D",
    icon: "🐘",
  },
  {
    type: "SHARK",
    name: "Shark Engine",
    description: "Electroreception and predatory drive",
    coreMechanism: "Electric field sensing, apex persistence, hunt mode",
    color: "#1ABC9C",
    icon: "🦈",
  },
  {
    type: "WOLF",
    name: "Wolf Engine",
    description: "Pack coherence and territorial behavior",
    coreMechanism: "Howl synchrony (Kuramoto), pack bonds, territory claim",
    color: "#95A5A6",
    icon: "🐺",
  },
  {
    type: "ORCA",
    name: "Orca Engine",
    description: "Cultural transmission and pod identity",
    coreMechanism: "Dialect inheritance ODE, pod hash, cultural memory",
    color: "#34495E",
    icon: "🐋",
  },
  {
    type: "EAGLE",
    name: "Eagle Engine",
    description: "Telescopic focus and altitude advantage",
    coreMechanism: "Visual acuity sigmoid, thermal soaring, overview effect",
    color: "#D35400",
    icon: "🦅",
  },
  {
    type: "OCTOPUS",
    name: "Octopus Engine",
    description: "Distributed cognition and adaptation",
    coreMechanism: "Arm autonomy model, chromatophore matching, shape-shift",
    color: "#9B59B6",
    icon: "🐙",
  },
];

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 2: INDIVIDUAL ANIMAL ENGINE STATES
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// CROW ENGINE — Causal inference, counterfactual reasoning, tool use
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface CrowEngineState {
  // Causal inference
  causalGraph: Map<string, string[]>; // cause → effects
  causalStrengths: Map<string, number>;

  // Counterfactual reasoning
  counterfactualBranches: CounterfactualBranch[];
  activeCounterfactual: number | null;

  // Tool use
  toolUseProbability: number;
  toolInventory: string[];
  toolEffectiveness: Map<string, number>;

  // Outputs
  causalInferenceScore: number;
  counterfactualDepth: number;
  adaptiveBehavior: number;
}

export interface CounterfactualBranch {
  id: number;
  hypothesis: string;
  probability: number;
  expectedOutcome: number;
  actualOutcome: number | null;
}

export function initCrowEngine(): CrowEngineState {
  return {
    causalGraph: new Map(),
    causalStrengths: new Map(),
    counterfactualBranches: [],
    activeCounterfactual: null,
    toolUseProbability: 0.3,
    toolInventory: [],
    toolEffectiveness: new Map(),
    causalInferenceScore: 0.5,
    counterfactualDepth: 0,
    adaptiveBehavior: 0.5,
  };
}

/**
 * Run the Crow Engine — Causal inference and counterfactual reasoning
 */
export function runCrowEngine(
  state: CrowEngineState,
  observation: number[],
  reward: number,
): CrowEngineState {
  const updated = { ...state };

  // 1. Update causal inference based on observations
  // Simple: if observation[i] > threshold and reward > 0, strengthen causal link
  const threshold = 0.5;
  for (let i = 0; i < observation.length; i++) {
    if (observation[i] > threshold) {
      const cause = `obs_${i}`;
      const effect = "reward";
      const key = `${cause}->${effect}`;

      const currentStrength = state.causalStrengths.get(key) || 0;
      const newStrength = currentStrength + 0.01 * reward * observation[i];
      updated.causalStrengths.set(key, clamp(newStrength, 0, 1));
    }
  }

  // 2. Counterfactual branching — "What if observation[0] was different?"
  if (state.counterfactualBranches.length < 5) {
    const branch: CounterfactualBranch = {
      id: state.counterfactualBranches.length,
      hypothesis: `obs_0 = ${1 - observation[0]}`,
      probability: 0.2,
      expectedOutcome: reward * 0.8, // Pessimistic estimate
      actualOutcome: null,
    };
    updated.counterfactualBranches = [...state.counterfactualBranches, branch];
  }

  // 3. Tool use probability updates
  // Higher reward → more likely to use tools in the future
  updated.toolUseProbability = clamp(
    state.toolUseProbability + 0.01 * (reward - 0.5),
    0.1,
    0.9,
  );

  // 4. Compute outputs
  updated.causalInferenceScore = computeCausalInferenceScore(updated);
  updated.counterfactualDepth = updated.counterfactualBranches.length;
  updated.adaptiveBehavior =
    (updated.causalInferenceScore + updated.toolUseProbability) / 2;

  return updated;
}

function computeCausalInferenceScore(state: CrowEngineState): number {
  if (state.causalStrengths.size === 0) return 0.5;

  let sum = 0;
  for (const strength of state.causalStrengths.values()) {
    sum += strength;
  }
  return sum / state.causalStrengths.size;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// DOLPHIN ENGINE — Echolocation, social mirroring, acoustic resonance
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface DolphinEngineState {
  // Echolocation (sonar)
  sonarWave: number[]; // 64-sample sonar field
  sonarFrequency: number; // Current sonar frequency (Hz)
  echoReturn: number[]; // Returned echoes

  // Social mirroring
  socialBonds: Map<string, number>; // entity → bond strength
  mirroringStrength: number;
  podId: string;

  // Acoustic resonance
  acousticResonanceField: number[];
  resonanceQ: number; // Quality factor

  // Outputs
  sonarClarity: number;
  socialCohesion: number;
  acousticPower: number;
}

export function initDolphinEngine(): DolphinEngineState {
  return {
    sonarWave: new Array(64).fill(0),
    sonarFrequency: 200, // Hz
    echoReturn: new Array(64).fill(0),
    socialBonds: new Map(),
    mirroringStrength: 0.5,
    podId: "pod_0",
    acousticResonanceField: new Array(12).fill(0),
    resonanceQ: 10,
    sonarClarity: 0.5,
    socialCohesion: 0.5,
    acousticPower: 0.5,
  };
}

/**
 * Run the Dolphin Engine — Echolocation and social dynamics
 */
export function runDolphinEngine(
  state: DolphinEngineState,
  environmentSignal: number[],
  nearbyEntities: string[],
): DolphinEngineState {
  const updated = { ...state };

  // 1. Update sonar wave
  // Generate outgoing sonar pulse
  for (let i = 0; i < 64; i++) {
    const t = i / 64;
    updated.sonarWave[i] =
      Math.sin(TWO_PI * state.sonarFrequency * t) * Math.exp(-t * 3); // Exponential decay
  }

  // 2. Process echo returns
  // Convolve environment signal with sonar wave (simplified)
  for (let i = 0; i < 64; i++) {
    const envSignal = environmentSignal[i % environmentSignal.length] || 0;
    updated.echoReturn[i] = updated.sonarWave[i] * envSignal * 0.8;
  }

  // 3. Update social bonds
  for (const entity of nearbyEntities) {
    const currentBond = state.socialBonds.get(entity) || 0;
    // Bonds strengthen with proximity
    const newBond = clamp(currentBond + 0.05, 0, 1);
    updated.socialBonds.set(entity, newBond);
  }

  // 4. Acoustic resonance field
  // Model sympathetic resonance with Hz substrate
  for (let i = 0; i < 12; i++) {
    const freq = state.sonarFrequency / (i + 1); // Harmonic series
    updated.acousticResonanceField[i] =
      1.0 / (1.0 + ((freq - 100) / 50) ** 2 / state.resonanceQ);
  }

  // 5. Compute outputs
  updated.sonarClarity = computeSonarClarity(updated);
  updated.socialCohesion = computeSocialCohesion(updated);
  updated.acousticPower =
    updated.acousticResonanceField.reduce((a, b) => a + b, 0) / 12;

  return updated;
}

function computeSonarClarity(state: DolphinEngineState): number {
  // Signal-to-noise ratio of echo returns
  const signalPower = state.echoReturn.reduce((a, b) => a + b * b, 0) / 64;
  return clamp(signalPower * 10, 0, 1);
}

function computeSocialCohesion(state: DolphinEngineState): number {
  if (state.socialBonds.size === 0) return 0.5;

  let sum = 0;
  for (const bond of state.socialBonds.values()) {
    sum += bond;
  }
  return sum / state.socialBonds.size;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// HIVE ENGINE — Swarm intelligence, pheromone gradient, collective decision
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface HiveEngineState {
  // Pheromone grid (8x8 = 64 zones)
  pheromoneGrid: number[][];
  pheromoneDecayRate: number;
  depositRate: number;

  // Swarm state
  swarmSize: number;
  workerDistribution: number[]; // Distribution across zones

  // Quorum sensing
  quorumThreshold: number;
  quorumAchieved: boolean;

  // Collective decision
  collectiveChoice: number | null;
  choiceConfidence: number;

  // Ant Colony Optimization (ACO)
  acoAlpha: number; // Pheromone importance
  acoBeta: number; // Heuristic importance

  // Outputs
  swarmCoherence: number;
  collectiveIntelligence: number;
  emergentBehavior: number;
}

export function initHiveEngine(): HiveEngineState {
  return {
    pheromoneGrid: Array(8)
      .fill(null)
      .map(() => Array(8).fill(0.1)),
    pheromoneDecayRate: 0.95,
    depositRate: 0.1,
    swarmSize: 100,
    workerDistribution: new Array(64).fill(100 / 64),
    quorumThreshold: 0.6,
    quorumAchieved: false,
    collectiveChoice: null,
    choiceConfidence: 0,
    acoAlpha: 1.0,
    acoBeta: 2.0,
    swarmCoherence: 0.5,
    collectiveIntelligence: 0.5,
    emergentBehavior: 0.5,
  };
}

/**
 * Run the Hive Engine — Swarm intelligence
 */
export function runHiveEngine(
  state: HiveEngineState,
  rewardSignal: number[], // Reward at each zone
  queenSignal: number,
): HiveEngineState {
  const updated = { ...state };

  // 1. Pheromone decay
  for (let i = 0; i < 8; i++) {
    for (let j = 0; j < 8; j++) {
      updated.pheromoneGrid[i][j] *= state.pheromoneDecayRate;
    }
  }

  // 2. Pheromone deposit based on reward
  for (let idx = 0; idx < 64; idx++) {
    const i = Math.floor(idx / 8);
    const j = idx % 8;
    const reward = rewardSignal[idx] || 0;

    if (reward > 0) {
      updated.pheromoneGrid[i][j] += state.depositRate * reward;
    }
  }

  // 3. Worker redistribution using ACO
  const totalPheromone = updated.pheromoneGrid
    .flat()
    .reduce((a, b) => a + b, 0);
  for (let idx = 0; idx < 64; idx++) {
    const i = Math.floor(idx / 8);
    const j = idx % 8;

    // Probability of moving to this zone
    const pheromone = updated.pheromoneGrid[i][j];
    const heuristic = rewardSignal[idx] || 0.1;

    const attractiveness =
      pheromone ** state.acoAlpha * heuristic ** state.acoBeta;

    updated.workerDistribution[idx] =
      (attractiveness / (totalPheromone + 0.01)) * state.swarmSize;
  }

  // 4. Quorum sensing
  const maxZone = Math.max(...updated.workerDistribution);
  const quorumFraction = maxZone / state.swarmSize;
  updated.quorumAchieved = quorumFraction >= state.quorumThreshold;

  // 5. Collective decision
  if (updated.quorumAchieved) {
    updated.collectiveChoice = updated.workerDistribution.indexOf(maxZone);
    updated.choiceConfidence = quorumFraction;
  } else {
    updated.collectiveChoice = null;
    updated.choiceConfidence = quorumFraction;
  }

  // 6. Queen signal modulation
  // Queen signal biases pheromone toward center
  if (queenSignal > 0) {
    const centerI = 3.5;
    const centerJ = 3.5;
    for (let i = 0; i < 8; i++) {
      for (let j = 0; j < 8; j++) {
        const distance = Math.sqrt((i - centerI) ** 2 + (j - centerJ) ** 2);
        const boost = queenSignal * Math.exp(-distance / 2);
        updated.pheromoneGrid[i][j] += boost * 0.01;
      }
    }
  }

  // 7. Compute outputs
  updated.swarmCoherence = computeSwarmCoherence(updated);
  updated.collectiveIntelligence =
    (updated.swarmCoherence + updated.choiceConfidence) / 2;
  updated.emergentBehavior = updated.quorumAchieved ? 1.0 : 0.5;

  return updated;
}

function computeSwarmCoherence(state: HiveEngineState): number {
  // Measure how concentrated the swarm is
  const variance = computeVariance(state.workerDistribution);
  const maxVariance = (state.swarmSize * state.swarmSize) / 64;
  return 1 - Math.min(1, variance / maxVariance);
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ELEPHANT ENGINE — Long-term memory, grief signal, seismic detection
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface ElephantEngineState {
  // Long-term memory (episodic)
  episodicMemory: EpisodicMemoryEntry[];
  memoryCapacity: number;
  memoryFidelity: number;

  // Grief processing
  griefSignal: number;
  lossEvents: LossEvent[];
  mourningState: "none" | "acute" | "processing" | "integrated";

  // Seismic detection
  seismicSensitivity: number;
  groundVibration: number;
  infrasonicCommunication: number[];

  // Social memory
  familyBonds: Map<string, number>;
  matriarchId: string | null;

  // Outputs
  memoryStrength: number;
  emotionalResilience: number;
  socialWisdom: number;
}

export interface EpisodicMemoryEntry {
  timestamp: number;
  context: string;
  emotionalValence: number;
  strength: number;
}

export interface LossEvent {
  entityId: string;
  timestamp: number;
  griefIntensity: number;
  processed: boolean;
}

export function initElephantEngine(): ElephantEngineState {
  return {
    episodicMemory: [],
    memoryCapacity: 200,
    memoryFidelity: 0.95,
    griefSignal: 0,
    lossEvents: [],
    mourningState: "none",
    seismicSensitivity: 0.8,
    groundVibration: 0,
    infrasonicCommunication: new Array(8).fill(0),
    familyBonds: new Map(),
    matriarchId: null,
    memoryStrength: 0.5,
    emotionalResilience: 0.5,
    socialWisdom: 0.5,
  };
}

/**
 * Run the Elephant Engine — Memory and grief processing
 */
export function runElephantEngine(
  state: ElephantEngineState,
  currentExperience: { context: string; valence: number },
  lossSignal: string | null,
  seismicInput: number,
): ElephantEngineState {
  const updated = { ...state };
  const now = Date.now();

  // 1. Episodic memory encoding
  if (Math.abs(currentExperience.valence) > 0.3) {
    // Emotionally significant
    const entry: EpisodicMemoryEntry = {
      timestamp: now,
      context: currentExperience.context,
      emotionalValence: currentExperience.valence,
      strength: 1.0,
    };

    updated.episodicMemory = [entry, ...state.episodicMemory];

    // Capacity limit
    if (updated.episodicMemory.length > state.memoryCapacity) {
      updated.episodicMemory = updated.episodicMemory.slice(
        0,
        state.memoryCapacity,
      );
    }
  }

  // 2. Memory decay
  updated.episodicMemory = updated.episodicMemory
    .map((entry) => ({
      ...entry,
      strength: entry.strength * state.memoryFidelity,
    }))
    .filter((entry) => entry.strength > 0.1);

  // 3. Grief processing
  if (lossSignal) {
    const lossEvent: LossEvent = {
      entityId: lossSignal,
      timestamp: now,
      griefIntensity: 1.0,
      processed: false,
    };
    updated.lossEvents = [...state.lossEvents, lossEvent];
    updated.mourningState = "acute";
    updated.griefSignal = 1.0;
  }

  // Process existing grief
  if (state.lossEvents.length > 0) {
    let totalGrief = 0;
    updated.lossEvents = state.lossEvents
      .map((event) => {
        const age = (now - event.timestamp) / (1000 * 60 * 60 * 24); // Days
        const decayedIntensity = event.griefIntensity * Math.exp(-age / 30); // 30-day half-life
        totalGrief += decayedIntensity;

        return {
          ...event,
          griefIntensity: decayedIntensity,
          processed: decayedIntensity < 0.1,
        };
      })
      .filter((event) => !event.processed);

    updated.griefSignal = Math.min(1, totalGrief);

    if (totalGrief < 0.1) {
      updated.mourningState = "integrated";
    } else if (totalGrief < 0.5) {
      updated.mourningState = "processing";
    }
  }

  // 4. Seismic detection
  updated.groundVibration = seismicInput * state.seismicSensitivity;

  // 5. Infrasonic communication update
  // Generate infrasonic call based on emotional state
  for (let i = 0; i < 8; i++) {
    const freq = 14 + i * 2; // 14-30 Hz (infrasound)
    const amplitude =
      (1 - updated.griefSignal) * 0.5 + currentExperience.valence * 0.5;
    updated.infrasonicCommunication[i] =
      amplitude * Math.sin((freq * now) / 1000);
  }

  // 6. Compute outputs
  updated.memoryStrength = computeMemoryStrength(updated);
  updated.emotionalResilience = 1 - updated.griefSignal * 0.5;
  updated.socialWisdom =
    (updated.memoryStrength + updated.emotionalResilience) / 2;

  return updated;
}

function computeMemoryStrength(state: ElephantEngineState): number {
  if (state.episodicMemory.length === 0) return 0.5;

  const avgStrength =
    state.episodicMemory.reduce((a, e) => a + e.strength, 0) /
    state.episodicMemory.length;
  return avgStrength;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// SHARK ENGINE — Electroreception, predatory drive, apex persistence
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface SharkEngineState {
  // Electroreception (Ampullae of Lorenzini)
  electricField: number[][]; // 16x16 field grid
  fieldSensitivity: number;
  detectedTargets: DetectedTarget[];

  // Predatory drive
  predatoryDrive: number;
  huntMode: "patrol" | "stalking" | "attack" | "feeding";
  targetLock: string | null;

  // Apex persistence
  apexStatus: number; // Dominance score
  territorySize: number;
  intimidationAura: number;

  // Lateral line (pressure sensing)
  lateralLineSignal: number[];

  // Outputs
  huntingEfficiency: number;
  dominance: number;
  survivalDrive: number;
}

export interface DetectedTarget {
  id: string;
  position: [number, number];
  electricSignature: number;
  threatLevel: number;
}

export function initSharkEngine(): SharkEngineState {
  return {
    electricField: Array(16)
      .fill(null)
      .map(() => Array(16).fill(0)),
    fieldSensitivity: 0.001, // Can detect nanovolts
    detectedTargets: [],
    predatoryDrive: 0.5,
    huntMode: "patrol",
    targetLock: null,
    apexStatus: 0.8,
    territorySize: 100,
    intimidationAura: 0.7,
    lateralLineSignal: new Array(32).fill(0),
    huntingEfficiency: 0.5,
    dominance: 0.7,
    survivalDrive: 0.8,
  };
}

/**
 * Run the Shark Engine — Predatory intelligence
 */
export function runSharkEngine(
  state: SharkEngineState,
  electricFieldInput: number[][],
  pressureWave: number[],
  hungerLevel: number,
): SharkEngineState {
  const updated = { ...state };

  // 1. Update electric field sensing
  updated.electricField = electricFieldInput.map((row) => [...row]);

  // 2. Detect targets via electroreception
  updated.detectedTargets = [];
  for (let i = 0; i < 16; i++) {
    for (let j = 0; j < 16; j++) {
      const fieldStrength = Math.abs(updated.electricField[i][j]);
      if (fieldStrength > state.fieldSensitivity) {
        updated.detectedTargets.push({
          id: `target_${i}_${j}`,
          position: [i, j],
          electricSignature: fieldStrength,
          threatLevel: fieldStrength > 0.1 ? 0.3 : 0.1, // Large = threat
        });
      }
    }
  }

  // 3. Update predatory drive based on hunger
  updated.predatoryDrive = clamp(
    state.predatoryDrive * 0.95 + hungerLevel * 0.1,
    0,
    1,
  );

  // 4. Hunt mode state machine
  if (updated.detectedTargets.length > 0 && updated.predatoryDrive > 0.6) {
    // Find closest/best target
    const bestTarget = updated.detectedTargets.reduce((best, t) =>
      t.electricSignature > best.electricSignature ? t : best,
    );

    if (state.huntMode === "patrol") {
      updated.huntMode = "stalking";
      updated.targetLock = bestTarget.id;
    } else if (state.huntMode === "stalking" && updated.predatoryDrive > 0.8) {
      updated.huntMode = "attack";
    }
  } else if (state.huntMode !== "patrol") {
    updated.huntMode = "patrol";
    updated.targetLock = null;
  }

  // 5. Lateral line processing
  updated.lateralLineSignal = pressureWave.slice(0, 32);

  // 6. Apex status update
  // Dominance increases with successful hunts (simulated by predatory drive)
  updated.apexStatus = clamp(
    state.apexStatus + (updated.huntMode === "attack" ? 0.01 : -0.001),
    0.5,
    1.0,
  );

  // 7. Compute outputs
  updated.huntingEfficiency = updated.detectedTargets.length > 0 ? 0.8 : 0.3;
  updated.dominance = updated.apexStatus * updated.intimidationAura;
  updated.survivalDrive = (updated.predatoryDrive + updated.apexStatus) / 2;

  return updated;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// WOLF ENGINE — Pack coherence, howl synchrony, territorial behavior
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface WolfEngineState {
  // Pack structure
  packId: string;
  packSize: number;
  alphaStatus: boolean;
  packRank: number;

  // Howl synchrony (Kuramoto model for wolves)
  howlPhases: number[]; // Phase of each pack member
  howlFrequency: number; // Base howl frequency
  howlCoupling: number; // Coupling strength K
  howlSynchrony: number; // Order parameter r

  // Territory
  territoryBoundary: [number, number][]; // Polygon vertices
  scentMarkings: ScentMark[];
  territorialClaim: number;

  // Pack coordination
  packCoherence: number;
  huntCoordination: number;

  // Outputs
  packBondStrength: number;
  territorialControl: number;
  alphaInfluence: number;
}

export interface ScentMark {
  position: [number, number];
  timestamp: number;
  strength: number;
}

export function initWolfEngine(): WolfEngineState {
  return {
    packId: "pack_0",
    packSize: 7,
    alphaStatus: false,
    packRank: 4,
    howlPhases: new Array(7).fill(0).map((_, i) => (i / 7) * TWO_PI),
    howlFrequency: 1.0,
    howlCoupling: 0.5,
    howlSynchrony: 0,
    territoryBoundary: [],
    scentMarkings: [],
    territorialClaim: 0.5,
    packCoherence: 0.5,
    huntCoordination: 0.5,
    packBondStrength: 0.5,
    territorialControl: 0.5,
    alphaInfluence: 0.3,
  };
}

/**
 * Run the Wolf Engine — Pack dynamics and territory
 */
export function runWolfEngine(
  state: WolfEngineState,
  _packMemberPhases: number[],
  currentPosition: [number, number],
  dt = 0.1,
): WolfEngineState {
  const updated = { ...state };

  // 1. Kuramoto model for howl synchrony
  // dθᵢ/dt = ω + (K/N) Σⱼ sin(θⱼ - θᵢ)
  const N = state.packSize;
  const newPhases = [...state.howlPhases];

  for (let i = 0; i < N; i++) {
    let coupling = 0;
    for (let j = 0; j < N; j++) {
      coupling += Math.sin(state.howlPhases[j] - state.howlPhases[i]);
    }

    const dTheta =
      state.howlFrequency * TWO_PI + (state.howlCoupling / N) * coupling;
    newPhases[i] = (state.howlPhases[i] + dTheta * dt) % TWO_PI;
  }
  updated.howlPhases = newPhases;

  // Compute order parameter r
  let sumCos = 0;
  let sumSin = 0;
  for (const phase of newPhases) {
    sumCos += Math.cos(phase);
    sumSin += Math.sin(phase);
  }
  updated.howlSynchrony = Math.sqrt(sumCos * sumCos + sumSin * sumSin) / N;

  // 2. Territory marking
  // Add scent mark at current position periodically
  const recentMark = state.scentMarkings.find(
    (m) =>
      Math.abs(m.position[0] - currentPosition[0]) < 1 &&
      Math.abs(m.position[1] - currentPosition[1]) < 1,
  );

  if (!recentMark) {
    updated.scentMarkings = [
      ...state.scentMarkings,
      {
        position: currentPosition,
        timestamp: Date.now(),
        strength: 1.0,
      },
    ].slice(-100); // Keep max 100 markings
  }

  // Decay scent markings
  updated.scentMarkings = updated.scentMarkings
    .map((mark) => ({
      ...mark,
      strength: mark.strength * 0.99,
    }))
    .filter((mark) => mark.strength > 0.1);

  // 3. Pack coherence from howl synchrony
  updated.packCoherence = updated.howlSynchrony;

  // 4. Alpha status check
  if (state.packRank <= 2) {
    updated.alphaStatus = true;
    updated.alphaInfluence = 0.8;
  }

  // 5. Territorial control
  updated.territorialClaim =
    (updated.scentMarkings.length / 50) * updated.packCoherence;

  // 6. Compute outputs
  updated.packBondStrength = updated.packCoherence;
  updated.territorialControl = clamp(updated.territorialClaim, 0, 1);

  return updated;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// ORCA ENGINE — Cultural transmission, dialect inheritance, pod identity
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface OrcaEngineState {
  // Pod identity
  podId: string;
  podHash: string; // Unique pod signature
  matrilineId: string;

  // Dialect (cultural transmission)
  dialectVector: number[]; // 16-dimensional call repertoire
  dialectDrift: number; // How much dialect has drifted

  // Cultural transmission ODE
  culturalMemory: number[]; // Accumulated cultural knowledge
  transmissionRate: number;

  // Pod coordination
  podSize: number;
  podCoherence: number;
  echolocationField: number[];

  // Hunting culture
  huntingTechnique: "carousel" | "wave_wash" | "beach_hunt" | "standard";
  techniqueEfficiency: number;

  // Outputs
  culturalFidelity: number;
  podIdentityStrength: number;
  culturalInheritance: number;
}

export function initOrcaEngine(): OrcaEngineState {
  return {
    podId: "pod_0",
    podHash: "",
    matrilineId: "matriline_0",
    dialectVector: new Array(16).fill(0).map((_, i) => Math.sin(i / 2)),
    dialectDrift: 0,
    culturalMemory: new Array(32).fill(0.5),
    transmissionRate: 0.1,
    podSize: 12,
    podCoherence: 0.7,
    echolocationField: new Array(64).fill(0),
    huntingTechnique: "standard",
    techniqueEfficiency: 0.5,
    culturalFidelity: 0.8,
    podIdentityStrength: 0.7,
    culturalInheritance: 0.6,
  };
}

/**
 * Run the Orca Engine — Cultural dynamics
 */
export function runOrcaEngine(
  state: OrcaEngineState,
  podMemberDialects: number[][],
  environmentInput: number[],
): OrcaEngineState {
  const updated = { ...state };

  // 1. Cultural transmission ODE
  // dC/dt = α × (C_pod - C_self) + noise
  // C = cultural memory
  if (podMemberDialects.length > 0) {
    const podMeanDialect = new Array(16).fill(0);
    for (const dialect of podMemberDialects) {
      for (let i = 0; i < 16; i++) {
        podMeanDialect[i] += (dialect[i] || 0) / podMemberDialects.length;
      }
    }

    // Update own dialect toward pod mean
    updated.dialectVector = state.dialectVector.map((v, i) => {
      const diff = podMeanDialect[i] - v;
      return v + state.transmissionRate * diff + (Math.random() - 0.5) * 0.01;
    });
  }

  // 2. Dialect drift measurement
  const initialDialect = new Array(16).fill(0).map((_, i) => Math.sin(i / 2));
  let driftSum = 0;
  for (let i = 0; i < 16; i++) {
    driftSum += Math.abs(updated.dialectVector[i] - initialDialect[i]);
  }
  updated.dialectDrift = driftSum / 16;

  // 3. Pod hash computation (unique identity)
  let hashVal = 0;
  for (let i = 0; i < 16; i++) {
    hashVal =
      (hashVal * 31 + Math.floor(updated.dialectVector[i] * 1000)) % 1000000;
  }
  updated.podHash = `pod_${hashVal.toString(16)}`;

  // 4. Cultural memory update
  updated.culturalMemory = state.culturalMemory.map((m, i) => {
    const input = environmentInput[i % environmentInput.length] || 0;
    return m * 0.99 + input * 0.01;
  });

  // 5. Hunting technique selection based on environment
  const avgEnv =
    environmentInput.reduce((a, b) => a + b, 0) / environmentInput.length;
  if (avgEnv > 0.7) {
    updated.huntingTechnique = "carousel";
    updated.techniqueEfficiency = 0.8;
  } else if (avgEnv > 0.5) {
    updated.huntingTechnique = "wave_wash";
    updated.techniqueEfficiency = 0.7;
  }

  // 6. Compute outputs
  updated.culturalFidelity = 1 - updated.dialectDrift;
  updated.podIdentityStrength = updated.podCoherence * updated.culturalFidelity;
  updated.culturalInheritance =
    (updated.culturalFidelity + state.transmissionRate) / 2;

  return updated;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// EAGLE ENGINE — Telescopic focus, thermal soaring, altitude advantage
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface EagleEngineState {
  // Visual system
  visualAcuity: number; // 0-1, enhanced vision
  focalLength: number; // Current zoom level
  focusTarget: [number, number] | null;
  visualField: number[][]; // 32x32 visual input

  // Thermal soaring
  altitude: number;
  thermalLift: number;
  thermalMap: number[][]; // 8x8 thermal grid
  soaringEfficiency: number;

  // Overview effect
  overviewScope: number; // How much of terrain is visible
  strategicAdvantage: number;

  // Dive attack
  diveSpeed: number;
  diveAngle: number;
  inDive: boolean;

  // Outputs
  visualClarity: number;
  aerialDominance: number;
  tacticalAwareness: number;
}

export function initEagleEngine(): EagleEngineState {
  return {
    visualAcuity: 0.9,
    focalLength: 1.0,
    focusTarget: null,
    visualField: Array(32)
      .fill(null)
      .map(() => Array(32).fill(0)),
    altitude: 100,
    thermalLift: 0,
    thermalMap: Array(8)
      .fill(null)
      .map(() => Array(8).fill(0.3)),
    soaringEfficiency: 0.7,
    overviewScope: 0.5,
    strategicAdvantage: 0.5,
    diveSpeed: 0,
    diveAngle: 0,
    inDive: false,
    visualClarity: 0.5,
    aerialDominance: 0.5,
    tacticalAwareness: 0.5,
  };
}

/**
 * Run the Eagle Engine — Aerial intelligence
 */
export function runEagleEngine(
  state: EagleEngineState,
  visualInput: number[][],
  thermalInput: number[][],
  targetPosition: [number, number] | null,
): EagleEngineState {
  const updated = { ...state };

  // 1. Telescopic focus
  // Visual acuity sigmoid: f(x) = 1 / (1 + e^(-k*(x-threshold)))
  if (targetPosition) {
    const distance = Math.sqrt(
      (targetPosition[0] - 16) ** 2 + (targetPosition[1] - 16) ** 2,
    );

    // Adjust focal length
    updated.focalLength = 1 + Math.log(1 + distance / 10);
    updated.focusTarget = targetPosition;

    // Enhanced acuity when focused
    updated.visualAcuity = clamp(
      state.visualAcuity + 0.1 * (1 / (1 + distance / 100)),
      0.5,
      0.99,
    );
  }

  // 2. Process visual field with acuity
  updated.visualField = visualInput.map((row) =>
    row.map((pixel) => pixel * state.visualAcuity),
  );

  // 3. Thermal soaring
  updated.thermalMap = thermalInput;

  // Find strongest thermal
  let maxThermal = 0;
  for (let i = 0; i < 8; i++) {
    for (let j = 0; j < 8; j++) {
      maxThermal = Math.max(maxThermal, thermalInput[i]?.[j] || 0);
    }
  }
  updated.thermalLift = maxThermal;

  // Altitude dynamics
  const lift = updated.thermalLift * updated.soaringEfficiency;
  const drag = 0.1;
  updated.altitude = Math.max(0, state.altitude + lift - drag);

  // 4. Overview effect (higher altitude = more visibility)
  updated.overviewScope = Math.tanh(updated.altitude / 500);

  // 5. Dive mechanics
  if (targetPosition && state.altitude > 50 && !state.inDive) {
    updated.inDive = true;
    updated.diveAngle = 45;
  }

  if (state.inDive) {
    updated.diveSpeed =
      state.altitude * Math.sin((state.diveAngle * PI) / 180) * 0.1;
    updated.altitude -= updated.diveSpeed;

    if (updated.altitude < 10) {
      updated.inDive = false;
      updated.diveSpeed = 0;
    }
  }

  // 6. Compute outputs
  updated.visualClarity =
    (updated.visualAcuity * (1 + updated.focalLength)) / 2;
  updated.aerialDominance = (updated.altitude / 500 + updated.thermalLift) / 2;
  updated.tacticalAwareness =
    (updated.overviewScope + updated.visualClarity + updated.aerialDominance) /
    3;

  return updated;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// OCTOPUS ENGINE — Distributed cognition, chromatophore adaptation, arm autonomy
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

export interface OctopusEngineState {
  // Distributed cognition (8 arms + central brain)
  centralBrain: number[]; // 32-node central network
  armNetworks: number[][]; // 8 arms × 16 nodes each
  armAutonomy: number[]; // Autonomy level per arm

  // Chromatophore adaptation
  skinColor: [number, number, number]; // RGB
  targetColor: [number, number, number];
  adaptationSpeed: number;
  camouflageScore: number;

  // Shape-shifting
  currentShape: "normal" | "flat" | "spiky" | "compact";
  shapeShiftProbability: number;
  bodyTexture: number;

  // Cognitive distribution
  decentralizationIndex: number;
  parallelProcessing: number;

  // Outputs
  adaptability: number;
  problemSolving: number;
  escapeArtistry: number;
}

export function initOctopusEngine(): OctopusEngineState {
  return {
    centralBrain: new Array(32).fill(0.5),
    armNetworks: Array(8)
      .fill(null)
      .map(() => new Array(16).fill(0.5)),
    armAutonomy: new Array(8).fill(0.5),
    skinColor: [128, 128, 128],
    targetColor: [128, 128, 128],
    adaptationSpeed: 0.1,
    camouflageScore: 0.5,
    currentShape: "normal",
    shapeShiftProbability: 0.3,
    bodyTexture: 0.5,
    decentralizationIndex: 0.6,
    parallelProcessing: 0.7,
    adaptability: 0.7,
    problemSolving: 0.6,
    escapeArtistry: 0.5,
  };
}

/**
 * Run the Octopus Engine — Distributed intelligence and adaptation
 */
export function runOctopusEngine(
  state: OctopusEngineState,
  environmentColor: [number, number, number],
  threatLevel: number,
  armInputs: number[][],
): OctopusEngineState {
  const updated = { ...state };

  // 1. Chromatophore adaptation
  updated.targetColor = environmentColor;
  updated.skinColor = state.skinColor.map((c, i) => {
    const target = environmentColor[i];
    const diff = target - c;
    return Math.round(c + diff * state.adaptationSpeed);
  }) as [number, number, number];

  // Camouflage score: how close to target color
  const colorDiff = Math.sqrt(
    state.skinColor.reduce(
      (sum, c, i) => sum + (c - environmentColor[i]) ** 2,
      0,
    ),
  );
  updated.camouflageScore = 1 - colorDiff / (255 * Math.sqrt(3));

  // 2. Distributed arm processing
  updated.armNetworks = armInputs.map((input, armIdx) => {
    return state.armNetworks[armIdx].map((node, i) => {
      const armInput = input[i % input.length] || 0;
      const centralSignal = state.centralBrain[i % 32] || 0.5;

      // Arm autonomy determines how much central control vs local
      const autonomy = state.armAutonomy[armIdx];
      return (
        node * 0.9 + armInput * autonomy + centralSignal * (1 - autonomy) * 0.1
      );
    });
  });

  // 3. Central brain integration
  updated.centralBrain = state.centralBrain.map((node, i) => {
    // Aggregate from all arms
    let armSum = 0;
    for (let arm = 0; arm < 8; arm++) {
      armSum += state.armNetworks[arm][i % 16] || 0;
    }
    return node * 0.95 + (armSum / 8) * 0.05;
  });

  // 4. Arm autonomy adjustment
  // Higher threat = more central control (lower autonomy)
  updated.armAutonomy = state.armAutonomy.map((a) =>
    clamp(a - threatLevel * 0.1 + 0.05, 0.2, 0.9),
  );

  // 5. Shape-shifting
  if (threatLevel > 0.7 && Math.random() < state.shapeShiftProbability) {
    const shapes: OctopusEngineState["currentShape"][] = [
      "flat",
      "spiky",
      "compact",
    ];
    updated.currentShape = shapes[Math.floor(Math.random() * shapes.length)];
    updated.bodyTexture = Math.random();
  } else if (threatLevel < 0.3) {
    updated.currentShape = "normal";
  }

  // 6. Compute outputs
  updated.decentralizationIndex =
    state.armAutonomy.reduce((a, b) => a + b, 0) / 8;
  updated.parallelProcessing =
    updated.armNetworks.reduce(
      (sum, arm) => sum + arm.reduce((a, b) => a + b, 0) / 16,
      0,
    ) / 8;

  updated.adaptability =
    (updated.camouflageScore + updated.decentralizationIndex) / 2;
  updated.problemSolving =
    (updated.parallelProcessing + updated.decentralizationIndex) / 2;
  updated.escapeArtistry =
    updated.currentShape !== "normal" ? 0.9 : updated.adaptability;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 3: COMBINED ANIMAL ENGINE STATE
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export interface AllAnimalEnginesState {
  crow: CrowEngineState;
  dolphin: DolphinEngineState;
  hive: HiveEngineState;
  elephant: ElephantEngineState;
  shark: SharkEngineState;
  wolf: WolfEngineState;
  orca: OrcaEngineState;
  eagle: EagleEngineState;
  octopus: OctopusEngineState;

  // Composite outputs
  compositeIntelligence: number;
  adaptiveCapacity: number;
  survivalIndex: number;
}

export function initAllAnimalEngines(): AllAnimalEnginesState {
  return {
    crow: initCrowEngine(),
    dolphin: initDolphinEngine(),
    hive: initHiveEngine(),
    elephant: initElephantEngine(),
    shark: initSharkEngine(),
    wolf: initWolfEngine(),
    orca: initOrcaEngine(),
    eagle: initEagleEngine(),
    octopus: initOctopusEngine(),
    compositeIntelligence: 0.5,
    adaptiveCapacity: 0.5,
    survivalIndex: 0.5,
  };
}

/**
 * Update all animal engines and compute composite outputs
 */
export function updateAllAnimalEngines(
  state: AllAnimalEnginesState,
): AllAnimalEnginesState {
  const updated = { ...state };

  // Compute composite intelligence
  updated.compositeIntelligence =
    (state.crow.causalInferenceScore +
      state.dolphin.socialCohesion +
      state.hive.collectiveIntelligence +
      state.elephant.socialWisdom +
      state.orca.culturalFidelity +
      state.eagle.tacticalAwareness +
      state.octopus.problemSolving) /
    7;

  // Compute adaptive capacity
  updated.adaptiveCapacity =
    (state.octopus.adaptability +
      state.hive.emergentBehavior +
      state.crow.adaptiveBehavior +
      state.eagle.aerialDominance) /
    4;

  // Compute survival index
  updated.survivalIndex =
    (state.shark.survivalDrive +
      state.wolf.territorialControl +
      state.elephant.emotionalResilience +
      state.octopus.escapeArtistry) /
    4;

  return updated;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 4: UTILITY FUNCTIONS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

function clamp(value: number, min: number, max: number): number {
  return Math.max(min, Math.min(max, value));
}

function computeVariance(values: number[]): number {
  if (values.length === 0) return 0;
  const mean = values.reduce((a, b) => a + b, 0) / values.length;
  return values.reduce((sum, v) => sum + (v - mean) ** 2, 0) / values.length;
}

// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// SECTION 5: DIAGNOSTICS
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────

export function getAnimalEngineDiagnostics(
  state: AllAnimalEnginesState,
): string {
  const lines: string[] = [
    "═══════════════════════════════════════════════════════════════════════════════",
    "                    ANIMAL ENGINE DIAGNOSTICS                                  ",
    "                      MEDINA DOCTRINE                                          ",
    "═══════════════════════════════════════════════════════════════════════════════",
    "",
    `Composite Intelligence: ${(state.compositeIntelligence * 100).toFixed(1)}%`,
    `Adaptive Capacity: ${(state.adaptiveCapacity * 100).toFixed(1)}%`,
    `Survival Index: ${(state.survivalIndex * 100).toFixed(1)}%`,
    "",
    "─── INDIVIDUAL ENGINES ───────────────────────────────────────────────────────",
  ];

  const engines = [
    { name: "🐦‍⬛ CROW", score: state.crow.causalInferenceScore },
    { name: "🐬 DOLPHIN", score: state.dolphin.socialCohesion },
    { name: "🐝 HIVE", score: state.hive.collectiveIntelligence },
    { name: "🐘 ELEPHANT", score: state.elephant.memoryStrength },
    { name: "🦈 SHARK", score: state.shark.dominance },
    { name: "🐺 WOLF", score: state.wolf.packBondStrength },
    { name: "🐋 ORCA", score: state.orca.culturalFidelity },
    { name: "🦅 EAGLE", score: state.eagle.tacticalAwareness },
    { name: "🐙 OCTOPUS", score: state.octopus.adaptability },
  ];

  for (const engine of engines) {
    const bar = "█".repeat(Math.round(engine.score * 20)).padEnd(20, "░");
    lines.push(
      `  ${engine.name.padEnd(15)} ${bar} ${(engine.score * 100).toFixed(0)}%`,
    );
  }

  lines.push("");
  lines.push(
    "═══════════════════════════════════════════════════════════════════════════════",
  );

  return lines.join("\n");
}
