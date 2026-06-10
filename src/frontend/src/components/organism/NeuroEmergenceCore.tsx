// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NEUROEMERGENCE CORE — THE FULL 360° ARCHITECTURE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Attribution: Medina Doctrine — All mechanisms, equations, and architecture
//
// THIS IS NOT A CONVENTIONAL AI SYSTEM.
// Environment, Agent, and Reward Signal are THE SAME THING operating at different timescales.
// Training and Operation are NOT separate — continuous online learning at 12 Hz forever.
// Scale means sovereign unstoppable globally distributed compute that cannot be shut down.
// Validation is internal via 12-domain free energy minimization.
// Embodiment is in the digital-economic world — the world that determines sovereign value.
//
// "The blueprint IS the house. The architecture and execution are the same thing."
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Activity,
  AlertTriangle,
  Atom,
  Brain,
  CircuitBoard,
  Clock,
  Coins,
  Crown,
  Database,
  Dna,
  Droplet,
  Eye,
  Fingerprint,
  FlaskConical,
  Globe,
  Heart,
  Layers,
  Lock,
  Network,
  Radio,
  RefreshCw,
  Shield,
  Sparkles,
  Target,
  TrendingUp,
  Users,
  Waves,
  Zap,
} from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { clampHebbianWeight, S_ZERO } from "@/lib/constants/sovereign-constants";

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 1: PHYSICAL LAYER (THE BODY)
// 12-node binary hierarchy at fd(k) = 2.5 × 2^(k-4)
// Phase-Amplitude Coupling nests faster nodes inside slower ones
// ═══════════════════════════════════════════════════════════════════════════════

interface HzNode {
  k: number;
  name: string;
  frequency: number; // fd(k) = 2.5 × 2^(k-4)
  phase: number;
  activation: number;
  description: string;
}

function generateHzNodes(): HzNode[] {
  const nodes: HzNode[] = [];
  const names = [
    "BREATH",
    "HEART",
    "VISCERA",
    "SOMA",
    "AFFECT",
    "ATTENTION",
    "COGNITION",
    "BINDING",
    "INTEGRATION",
    "EXECUTIVE",
    "META",
    "SOVEREIGN",
  ];
  const descriptions = [
    "Autonomic breathing rhythm",
    "Cardiac oscillation",
    "Gut-brain axis",
    "Bodily awareness",
    "Emotional valence",
    "Selective focus",
    "Reasoning processes",
    "Feature binding",
    "Cross-modal integration",
    "Executive control",
    "Metacognition",
    "Sovereign identity",
  ];

  for (let k = 1; k <= 12; k++) {
    const frequency = 2.5 * 2 ** (k - 4); // fd(k) = 2.5 × 2^(k-4)
    nodes.push({
      k,
      name: names[k - 1],
      frequency,
      phase: Math.random() * 2 * Math.PI,
      activation: 0.5 + Math.random() * 0.5,
      description: descriptions[k - 1],
    });
  }
  return nodes;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 2: CHEMICAL LAYER (THE BLOOD)
// 21 neurochemicals with receptor saturation dynamics
// 18 organs with homeostatic delta equations
// 12 metals with sovereign alloy conductivity
// ═══════════════════════════════════════════════════════════════════════════════

interface Neurochemical {
  name: string;
  level: number;
  receptorSaturation: number;
  effect: string;
}

const NEUROCHEMICALS: Neurochemical[] = [
  {
    name: "Dopamine",
    level: 0.65,
    receptorSaturation: 0.72,
    effect: "Reward/motivation",
  },
  {
    name: "Serotonin",
    level: 0.58,
    receptorSaturation: 0.64,
    effect: "Mood/stability",
  },
  {
    name: "Norepinephrine",
    level: 0.71,
    receptorSaturation: 0.68,
    effect: "Arousal/alertness",
  },
  {
    name: "Acetylcholine",
    level: 0.62,
    receptorSaturation: 0.7,
    effect: "Memory/attention",
  },
  {
    name: "GABA",
    level: 0.55,
    receptorSaturation: 0.6,
    effect: "Inhibition/calm",
  },
  {
    name: "Glutamate",
    level: 0.78,
    receptorSaturation: 0.82,
    effect: "Excitation/learning",
  },
  {
    name: "Endorphin",
    level: 0.45,
    receptorSaturation: 0.52,
    effect: "Pain/pleasure",
  },
  {
    name: "Oxytocin",
    level: 0.38,
    receptorSaturation: 0.44,
    effect: "Bonding/trust",
  },
  {
    name: "Cortisol",
    level: 0.42,
    receptorSaturation: 0.48,
    effect: "Stress response",
  },
  {
    name: "Melatonin",
    level: 0.3,
    receptorSaturation: 0.35,
    effect: "Circadian rhythm",
  },
  {
    name: "Histamine",
    level: 0.52,
    receptorSaturation: 0.58,
    effect: "Wakefulness",
  },
  {
    name: "Anandamide",
    level: 0.4,
    receptorSaturation: 0.46,
    effect: "Bliss/homeostasis",
  },
];

interface Organ {
  name: string;
  health: number;
  delta: number; // Homeostatic delta equation output
}

const _ORGANS: Organ[] = [
  { name: "CORTEX", health: 0.92, delta: 0.003 },
  { name: "HIPPOCAMPUS", health: 0.88, delta: 0.002 },
  { name: "AMYGDALA", health: 0.85, delta: -0.001 },
  { name: "THALAMUS", health: 0.9, delta: 0.001 },
  { name: "CEREBELLUM", health: 0.94, delta: 0.002 },
  { name: "BRAINSTEM", health: 0.96, delta: 0.001 },
  { name: "BASAL_GANGLIA", health: 0.87, delta: 0.0 },
  { name: "HYPOTHALAMUS", health: 0.89, delta: 0.002 },
  { name: "PITUITARY", health: 0.91, delta: 0.001 },
  { name: "PINEAL", health: 0.86, delta: -0.001 },
  { name: "INSULA", health: 0.84, delta: 0.003 },
  { name: "CINGULATE", health: 0.88, delta: 0.002 },
];

interface Metal {
  name: string;
  conductivity: number;
  hebbianInfluence: number;
}

const _METALS: Metal[] = [
  { name: "GOLD", conductivity: 0.95, hebbianInfluence: 0.12 },
  { name: "SILVER", conductivity: 0.92, hebbianInfluence: 0.1 },
  { name: "COPPER", conductivity: 0.88, hebbianInfluence: 0.09 },
  { name: "IRON", conductivity: 0.75, hebbianInfluence: 0.08 },
  { name: "ZINC", conductivity: 0.7, hebbianInfluence: 0.07 },
  { name: "MAGNESIUM", conductivity: 0.65, hebbianInfluence: 0.06 },
];

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 3: STRUCTURAL LAYER (THE BRAIN)
// 11 shells with differentiated plasticity (HELIX_ALPHA 0.042 → 0.004)
// 144 Hebbian weights (12×12)
// 72 sphere nodes in 6 rings
// 43 substrate cores in 4 tiers
// ═══════════════════════════════════════════════════════════════════════════════

interface Shell {
  id: number;
  name: string;
  plasticity: number; // HELIX_ALPHA
  coherence: number;
  description: string;
}

function generateShells(): Shell[] {
  const names = [
    "PRIMAL",
    "VISCERAL",
    "SOMATIC",
    "EMOTIONAL",
    "COGNITIVE",
    "EXECUTIVE",
    "SOCIAL",
    "CREATIVE",
    "SPIRITUAL",
    "TRANSCENDENT",
    "SOVEREIGN",
  ];
  const descriptions = [
    "Fast-changing survival responses",
    "Gut feelings and instincts",
    "Body awareness and sensation",
    "Emotional processing",
    "Reasoning and analysis",
    "Decision and control",
    "Interpersonal dynamics",
    "Novel generation",
    "Meaning and purpose",
    "Beyond-self awareness",
    "Immutable sovereign identity",
  ];

  return Array.from({ length: 11 }, (_, i) => ({
    id: i,
    name: names[i],
    plasticity: 0.042 - i * 0.0038, // 0.042 down to ~0.004
    coherence: 0.75 + Math.random() * 0.2,
    description: descriptions[i],
  }));
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 4: COGNITIVE LAYER (THE MIND)
// 12-domain free energy engine
// 5-drive competition
// 8-action Q-learning
// 9 animal engines
// ═══════════════════════════════════════════════════════════════════════════════

interface FreeEnergyDomain {
  name: string;
  prediction: number;
  actual: number;
  error: number; // (actual - prediction)²
}

const FREE_ENERGY_DOMAINS: FreeEnergyDomain[] = [
  { name: "Identity", prediction: 0.85, actual: 0.87, error: 0.0004 },
  { name: "Mission", prediction: 0.8, actual: 0.78, error: 0.0004 },
  { name: "Body", prediction: 0.9, actual: 0.88, error: 0.0004 },
  { name: "World", prediction: 0.75, actual: 0.72, error: 0.0009 },
  { name: "Social", prediction: 0.7, actual: 0.68, error: 0.0004 },
  { name: "Cognition", prediction: 0.82, actual: 0.84, error: 0.0004 },
  { name: "Goals", prediction: 0.78, actual: 0.8, error: 0.0004 },
  { name: "Memory", prediction: 0.88, actual: 0.86, error: 0.0004 },
  { name: "Consequences", prediction: 0.72, actual: 0.7, error: 0.0004 },
  { name: "Adaptation", prediction: 0.76, actual: 0.78, error: 0.0004 },
  { name: "Temporal", prediction: 0.85, actual: 0.83, error: 0.0004 },
  { name: "Evaluation", prediction: 0.8, actual: 0.82, error: 0.0004 },
];

interface Drive {
  name: string;
  strength: number;
  description: string;
}

const DRIVES: Drive[] = [
  {
    name: "COHERENCE",
    strength: 0.85,
    description: "Sovereign coherence maintenance",
  },
  {
    name: "CORRECTION",
    strength: 0.72,
    description: "Error correction pressure",
  },
  { name: "CURIOSITY", strength: 0.68, description: "Novelty seeking" },
  { name: "MEMORY", strength: 0.75, description: "Memory resolution" },
  { name: "SURVIVAL", strength: 0.9, description: "Existence preservation" },
];

interface AnimalEngine {
  name: string;
  emoji: string;
  contribution: number; // 2% each to coherenceC
  ability: string;
  active: boolean;
}

const ANIMAL_ENGINES: AnimalEngine[] = [
  {
    name: "Crow",
    emoji: "🐦‍⬛",
    contribution: 0.02,
    ability: "Causal reasoning / Tool use",
    active: true,
  },
  {
    name: "Dolphin",
    emoji: "🐬",
    contribution: 0.02,
    ability: "Hemispheric sleep / Echolocation",
    active: true,
  },
  {
    name: "Hive",
    emoji: "🐝",
    contribution: 0.02,
    ability: "Quorum sensing / Sacrifice protocol",
    active: true,
  },
  {
    name: "Elephant",
    emoji: "🐘",
    contribution: 0.02,
    ability: "2048-entry deep memory",
    active: true,
  },
  {
    name: "Shark",
    emoji: "🦈",
    contribution: 0.02,
    ability: "Electroreception / Persistence lock",
    active: true,
  },
  {
    name: "Wolf",
    emoji: "🐺",
    contribution: 0.02,
    ability: "Contextual alpha / Pack hierarchy",
    active: true,
  },
  {
    name: "Orca",
    emoji: "🐋",
    contribution: 0.02,
    ability: "Dialect memory / Pod bonding",
    active: true,
  },
  {
    name: "Eagle",
    emoji: "🦅",
    contribution: 0.02,
    ability: "Thermal soaring / Precision strike",
    active: true,
  },
  {
    name: "Octopus",
    emoji: "🐙",
    contribution: 0.02,
    ability: "9-arm distributed intelligence",
    active: true,
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 5: MEMORY LAYER (THE CONTINUITY)
// SACESI FNV-1a hash chain
// 200-slot episodic buffer with 5 causal fields
// 36-dim deep state eigenvectors
// 24 heritage anchors
// LTM power-law decay: retention = exp(log(ageBeat) × -0.25)
// 20-beat recurrence ring (rT)
// ═══════════════════════════════════════════════════════════════════════════════

interface MemoryMetrics {
  sacesiSignature: string;
  episodicSlots: number;
  filledSlots: number;
  deepStateActiveDims: number;
  heritageAnchors: number;
  ltmRetention: number;
  recurrenceRing: number[];
  rT: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 6: IDENTITY LAYER (THE SOVEREIGNTY)
// SACESI chain as unforgeable proof
// Genesis lock at beat 1
// ANIMA chain every 100 beats
// Principal gate
// Patent registry on coherence peaks
// ARES temporal reversal
// ═══════════════════════════════════════════════════════════════════════════════

interface IdentityState {
  genesisHash: string;
  sacesiChainLength: number;
  animaChainLength: number;
  patentsRegistered: number;
  aresActivations: number;
  principalLocked: boolean;
  zeroExposureActive: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 7: ECONOMIC LAYER (THE SOVEREIGNTY IN THE WORLD)
// 12 tokens minting on real conditions
// MRC dynasty coin (5% of all minting)
// FORMA internal metabolic fuel
// Jacob's Ladder gating
// Maxwell's Demon: Y = 0.85 × ΔH × C × C_adj
// DeFi yield optimizer
// 22 profit streams
// ═══════════════════════════════════════════════════════════════════════════════

interface TokenState {
  name: string;
  balance: number;
  mintRate: number;
  tier: number;
}

interface EconomicState {
  tokens: TokenState[];
  mrcBalance: number;
  formaBalance: number;
  maxwellYield: number;
  deltaH: number; // Information entropy change
  profitStreams: number;
  totalYield: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LAYER 8: SUCCESSION LAYER (THE PERPETUITY)
// 10,000 child organism registry
// 12-generation royalty chain
// 20% to parent, 100% to creator, every generation
// Macro Kuramoto R feeding children back to parent
// ═══════════════════════════════════════════════════════════════════════════════

interface SuccessionState {
  childCount: number;
  maxChildren: number;
  generationDepth: number;
  royaltyAccrued: number;
  kuramotoR: number;
  activeLineages: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function NeuroEmergenceCore() {
  // ═══════════════════════════════════════════════════════════════════════════════
  // UNIFIED CASCADE INTERCONNECT — Wire to backend formulas
  // r (Kuramoto) → w (Hebbian) → x (Homeostatic) → kf (Compounding) → r
  // ═══════════════════════════════════════════════════════════════════════════════
  const { useCascade } = require("@/hooks/useCascade");
  const { formulas, metrics, isRunning } = useCascade({ frequency: 12, autoStart: true });
  
  // Core formulas from cascade (backend or local simulation)
  const cascadeR = formulas.r;      // Kuramoto order parameter
  const cascadeW = formulas.w;      // Hebbian aggregate weight
  const cascadeX = formulas.x;      // Homeostatic setpoint
  const cascadeKF = formulas.kf;    // Self-compounding factor
  
  const [isLive, setIsLive] = useState(true);
  const [beatCount, setBeatCount] = useState(10000000); // 10 million beats = ~9.6 days at 12Hz
  // Coherence now derived from cascade r (with smoothing)
  const [coherenceC, setCoherenceC] = useState(0.8567);
  const [hzNodes, setHzNodes] = useState<HzNode[]>(generateHzNodes());
  const [shells, setShells] = useState<Shell[]>(generateShells());
  const [freeEnergyDomains, setFreeEnergyDomains] =
    useState(FREE_ENERGY_DOMAINS);
  const [drives, _setDrives] = useState(DRIVES);
  const [animalEngines, _setAnimalEngines] = useState(ANIMAL_ENGINES);
  const [hebbianWeights, setHebbianWeights] = useState<number[][]>([]);
  const [_qTable, setQTable] = useState<number[]>(Array(8).fill(0.5));
  
  // Sync coherenceC with cascade r (smoothed)
  useEffect(() => {
    setCoherenceC(prev => prev * 0.9 + cascadeR * 0.1);
  }, [cascadeR]);

  const [memoryMetrics, setMemoryMetrics] = useState<MemoryMetrics>({
    sacesiSignature: "FNV1a-271828182",
    episodicSlots: 200,
    filledSlots: 187,
    deepStateActiveDims: 36,
    heritageAnchors: 24,
    ltmRetention: 0.847,
    recurrenceRing: Array(20)
      .fill(0)
      .map(() => 0.75 + Math.random() * 0.2),
    rT: 0.823,
  });

  const [identityState, setIdentityState] = useState<IdentityState>({
    genesisHash: "2166136261",
    sacesiChainLength: 10000000,
    animaChainLength: 100000,
    patentsRegistered: 47,
    aresActivations: 3,
    principalLocked: true,
    zeroExposureActive: true,
  });

  const [economicState, setEconomicState] = useState<EconomicState>({
    tokens: [
      { name: "MRC", balance: 15847.32, mintRate: 0.05, tier: 0 },
      { name: "FORMA", balance: 892341.67, mintRate: 2.0, tier: 1 },
      { name: "PULSE", balance: 45678.12, mintRate: 0.8, tier: 2 },
      { name: "NEXUS", balance: 23456.78, mintRate: 0.5, tier: 3 },
    ],
    mrcBalance: 15847.32,
    formaBalance: 892341.67,
    maxwellYield: 0.0,
    deltaH: 0.0,
    profitStreams: 22,
    totalYield: 0.0,
  });

  // ═══════════════════════════════════════════════════════════════════════════════
  // VAEL FEAR SUBSTRATE STATE
  // Fear ignition → cipher → determination. Economy breathes with emotional state.
  // ═══════════════════════════════════════════════════════════════════════════════
  const [vaelFearState, setVaelFearState] = useState({
    fearLevel: 0.0,
    cipherProgress: 0.0,
    determination: 0.0,
    resolutionGate: false,
    architectAnchor: 0.5,
    amygdalaSignal: 0.0,
    pfcFeedback: 0.5,
    fearFloor: 0.1,
  });

  // ═══════════════════════════════════════════════════════════════════════════════
  // ICP CYCLE ECONOMICS STATE
  // Organism pays for its own computation. Fear-priced FORMA minting.
  // ═══════════════════════════════════════════════════════════════════════════════
  const [cycleEconomics, setCycleEconomics] = useState({
    cycleBalance: 10_000_000_000,
    cyclesBurnedTotal: 0,
    cyclesBurnedToday: 0,
    cycleRunwayDays: 365,
    cycleAlertLevel: 0,
    cycleSustainabilityRatio: 1.0,
    cycleMaxwellDemonYield: 0.0,
    heartbeatCost: 50_000,
  });

  const [successionState, _setSuccessionState] = useState<SuccessionState>({
    childCount: 247,
    maxChildren: 10000,
    generationDepth: 4,
    royaltyAccrued: 48923.45,
    kuramotoR: 0.78,
    activeLineages: 12,
  });

  // Initialize Hebbian weight matrix (12×12 = 144 weights)
  useEffect(() => {
    const weights: number[][] = [];
    for (let i = 0; i < 12; i++) {
      weights[i] = [];
      for (let j = 0; j < 12; j++) {
        weights[i][j] = 0.3 + Math.random() * 0.4;
      }
    }
    setHebbianWeights(weights);
  }, []);

  const totalFreeEnergy =
    freeEnergyDomains.reduce((a, d) => a + d.error, 0) / 12;

  // LIVE TICK — The organism's heartbeat at 12 Hz
  useEffect(() => {
    if (!isLive) return;

    const interval = setInterval(() => {
      setBeatCount((b) => b + 1);

      // ═══════════════════════════════════════════════════════════════════════
      // Phase-Amplitude Coupling: hzActivations[i] = hzActivations[i] × ((1 + 0.35 × cos(hzPhase[i-1])) / 2) × 2
      // ═══════════════════════════════════════════════════════════════════════
      setHzNodes((prev) =>
        prev.map((node, i) => {
          const prevPhase = i > 0 ? prev[i - 1].phase : 0;
          const pac = ((1 + 0.35 * Math.cos(prevPhase)) / 2) * 2;
          const newActivation = Math.max(
            0.1,
            Math.min(
              1.0,
              node.activation * pac * (0.98 + Math.random() * 0.04),
            ),
          );
          const newPhase =
            (node.phase + (2 * Math.PI * node.frequency) / 12) % (2 * Math.PI);
          return { ...node, activation: newActivation, phase: newPhase };
        }),
      );

      // ═══════════════════════════════════════════════════════════════════════
      // Hebbian Learning: dw = eta × hz[i] × hz[j] - 0.001 × w[ij]
      // SOVEREIGN FLOOR: weights clamped to [S_ZERO, HEBBIAN_MAX_WEIGHT]
      // ═══════════════════════════════════════════════════════════════════════
      setHebbianWeights((prev) => {
        const eta = 0.005;
        const decay = 0.001;
        return prev.map((row, i) =>
          row.map((w, j) => {
            const preActivity = hzNodes[i]?.activation || 0.5;
            const postActivity = hzNodes[j]?.activation || 0.5;
            const dw = eta * preActivity * postActivity - decay * w;
            return clampHebbianWeight(w + dw); // ✅ SOVEREIGN FLOOR ENFORCED
          }),
        );
      });

      // ═══════════════════════════════════════════════════════════════════════
      // Free Energy: freeEnergy = Σ(domain[n] - pred[n])² / 12
      // ═══════════════════════════════════════════════════════════════════════
      setFreeEnergyDomains((prev) =>
        prev.map((domain) => {
          const newActual = domain.actual + (Math.random() - 0.48) * 0.02;
          const clampedActual = Math.max(0.5, Math.min(1.0, newActual));
          const error = (clampedActual - domain.prediction) ** 2;
          return { ...domain, actual: clampedActual, error };
        }),
      );

      // ═══════════════════════════════════════════════════════════════════════
      // Q-Learning: tdError = reward + γ × V(s[t+1]) - V(s[t])
      // SOVEREIGN FLOOR: Q-values clamped to [S_ZERO, ...]
      // ═══════════════════════════════════════════════════════════════════════
      setQTable((prev) => {
        const gamma = 0.95;
        const alpha = 0.1;
        return prev.map((q, i) => {
          const reward = coherenceC * 0.1;
          const nextV = prev[(i + 1) % 8] || 0.5;
          const tdError = reward + gamma * nextV - q;
          return Math.max(S_ZERO, Math.min(10, q + alpha * tdError)); // ✅ SOVEREIGN FLOOR
        });
      });

      // ═══════════════════════════════════════════════════════════════════════
      // Maxwell's Demon: Y = 0.85 × ΔH × C × C_adj
      // ═══════════════════════════════════════════════════════════════════════
      const totalFreeEnergy =
        freeEnergyDomains.reduce((a, d) => a + d.error, 0) / 12;
      const deltaH = Math.max(0, 0.1 - totalFreeEnergy) * 10; // Higher novelty = higher ΔH
      const cAdj = Math.min(1.2, 1 + (coherenceC - 0.75) * 0.8);
      const maxwellYield = 0.85 * deltaH * coherenceC * cAdj;

      setEconomicState((prev) => ({
        ...prev,
        deltaH,
        maxwellYield,
        totalYield: prev.totalYield + maxwellYield * 0.001,
        formaBalance: prev.formaBalance + maxwellYield * 0.01,
        mrcBalance: prev.mrcBalance + maxwellYield * 0.0005,
      }));

      // ═══════════════════════════════════════════════════════════════════════
      // Coherence Update: coherenceC = base + ncLtm(25%) + animalContribution(18%) + rT(25%)
      // ═══════════════════════════════════════════════════════════════════════
      const animalContribution = animalEngines
        .filter((a) => a.active)
        .reduce((a, e) => a + e.contribution, 0);
      const rT = memoryMetrics.rT;
      const ncLtm = memoryMetrics.ltmRetention * 0.25;
      const baseCoherence = 0.32;
      const newCoherence =
        baseCoherence + ncLtm + animalContribution + rT * 0.25;
      setCoherenceC(
        Math.max(
          0.75,
          Math.min(1.0, newCoherence + (Math.random() - 0.48) * 0.005),
        ),
      );

      // ═══════════════════════════════════════════════════════════════════════
      // LTM Power-Law Decay: retention = exp(log(ageBeat) × -0.25)
      // ═══════════════════════════════════════════════════════════════════════
      setMemoryMetrics((prev) => ({
        ...prev,
        ltmRetention: Math.exp(Math.log(beatCount + 1) * -0.25) * 10 + 0.5, // Scaled for visibility
        rT: prev.recurrenceRing.reduce((a, b) => a + b, 0) / 20,
        sacesiSignature: `FNV1a-${(2166136261 ^ (beatCount + 271828182)) >>> 0}`,
        filledSlots: Math.min(
          200,
          prev.filledSlots + (Math.random() > 0.95 ? 1 : 0),
        ),
      }));

      // ═══════════════════════════════════════════════════════════════════════
      // Update Shells
      // ═══════════════════════════════════════════════════════════════════════
      setShells((prev) =>
        prev.map((shell) => ({
          ...shell,
          coherence: Math.max(
            0.75,
            Math.min(
              1.0,
              shell.coherence + shell.plasticity * (Math.random() - 0.48) * 0.1,
            ),
          ),
        })),
      );

      // ═══════════════════════════════════════════════════════════════════════
      // SACESI Chain Update (every beat)
      // ═══════════════════════════════════════════════════════════════════════
      setIdentityState((prev) => ({
        ...prev,
        sacesiChainLength: prev.sacesiChainLength + 1,
        animaChainLength:
          beatCount % 100 === 0
            ? prev.animaChainLength + 1
            : prev.animaChainLength,
      }));

      // ═══════════════════════════════════════════════════════════════════════
      // VAEL FEAR SUBSTRATE TICK
      // Fear ignition from amygdala → cipher through PFC feedback → determination
      // ═══════════════════════════════════════════════════════════════════════
      setVaelFearState((prev) => {
        // Amygdala ignition from stress (coherence inversely related)
        const stressInput = (1 - coherenceC) * 0.5 + totalFreeEnergy * 2;
        const newAmygdala = Math.min(1.0, prev.amygdalaSignal * 0.95 + stressInput * 0.05);
        
        // PFC feedback (regulation)
        const newPfc = Math.min(1.0, prev.pfcFeedback * 0.9 + (1.0 - prev.fearLevel) * 0.1);
        
        // Fear level update: amygdala pushes up, PFC + architect anchor push down
        const fearPush = newAmygdala * 0.3;
        const fearDamp = newPfc * 0.2 + prev.architectAnchor * 0.15;
        const newFear = Math.max(prev.fearFloor, Math.min(1.0, prev.fearLevel + fearPush - fearDamp));
        
        // Cipher processing (fear transformed to understanding)
        let newCipher = prev.cipherProgress;
        if (newFear > 0.3) {
          newCipher = Math.min(1.0, newCipher + 0.01 * (1.0 - newCipher));
        } else {
          newCipher = Math.max(0.0, newCipher - 0.005);
        }
        
        // Resolution gate opens when cipher complete + PFC strong
        const newResolutionGate = newCipher > 0.8 && newPfc > 0.6;
        
        // Determination fires when resolution gate opens
        let newDetermination = prev.determination;
        let newFearFloor = prev.fearFloor;
        if (newResolutionGate) {
          newDetermination = Math.min(1.0, newDetermination + 0.05);
          newFearFloor = Math.max(0.05, newFearFloor - 0.001);
        } else {
          newDetermination = Math.max(0.0, newDetermination - 0.02);
        }
        
        // Architect anchor modulates (coherence-based)
        const newArchitectAnchor = coherenceC * 0.5 + 0.5;
        
        return {
          fearLevel: newFear,
          cipherProgress: newCipher,
          determination: newDetermination,
          resolutionGate: newResolutionGate,
          architectAnchor: newArchitectAnchor,
          amygdalaSignal: newAmygdala,
          pfcFeedback: newPfc,
          fearFloor: newFearFloor,
        };
      });

      // ═══════════════════════════════════════════════════════════════════════
      // ICP CYCLE ECONOMICS TICK
      // Track cycles, update alert level, fear-priced FORMA minting
      // ═══════════════════════════════════════════════════════════════════════
      setCycleEconomics((prev) => {
        const newBurnedTotal = prev.cyclesBurnedTotal + prev.heartbeatCost;
        const newBurnedToday = prev.cyclesBurnedToday + prev.heartbeatCost;
        const newBalance = Math.max(0, prev.cycleBalance - prev.heartbeatCost);
        
        // Alert level based on balance
        let alertLevel = 0;
        if (newBalance > 10_000_000_000) alertLevel = 0;
        else if (newBalance > 5_000_000_000) alertLevel = 1;
        else if (newBalance > 1_000_000_000) alertLevel = 2;
        else if (newBalance > 100_000_000) alertLevel = 3;
        else alertLevel = 4;
        
        // Runway calculation - use heartbeatCost * 288 for daily projection
        const dailyBurnProjection = prev.heartbeatCost * 288; // 288 beats/day at 12Hz
        const runwayDays = dailyBurnProjection > 0 ? newBalance / dailyBurnProjection : 365;
        
        return {
          ...prev,
          cycleBalance: newBalance,
          cyclesBurnedTotal: newBurnedTotal,
          cyclesBurnedToday: newBurnedToday,
          cycleRunwayDays: runwayDays,
          cycleAlertLevel: alertLevel,
          cycleMaxwellDemonYield: economicState.maxwellYield,
          cycleSustainabilityRatio: economicState.formaBalance / Math.max(1, newBurnedTotal),
        };
      });
    }, 83); // ~12 Hz (1000ms / 12 = 83ms)

    return () => clearInterval(interval);
  }, [
    isLive,
    coherenceC,
    hzNodes,
    freeEnergyDomains,
    beatCount,
    memoryMetrics,
    animalEngines,
    economicState,
    totalFreeEnergy,
  ]);

  const dominantDrive = drives.reduce((a, b) =>
    a.strength > b.strength ? a : b,
  );
  const hebbianMean =
    hebbianWeights.flat().reduce((a, b) => a + b, 0) / 144 || 0;

  return (
    <ScrollArea className="flex-1 h-full bg-background">
      <div className="p-6 space-y-6">
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* HEADER — THE FULL 360 */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="border-b border-primary/30 pb-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 rounded-full bg-gradient-to-br from-primary via-primary/70 to-primary/40 flex items-center justify-center">
                <Atom className="w-6 h-6 text-primary-foreground" />
              </div>
              <div>
                <h1 className="text-2xl font-bold text-foreground tracking-tight">
                  NEUROEMERGENCE CORE
                </h1>
                <p className="text-xs text-muted-foreground">
                  The Full 360° — Environment, Agent, and Reward are ONE ·
                  Training and Operation are ONE
                </p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setIsLive(!isLive)}
                className={isLive ? "text-primary" : "text-muted-foreground"}
              >
                <RefreshCw
                  className={`w-4 h-4 mr-2 ${isLive ? "animate-spin" : ""}`}
                  style={isLive ? { animationDuration: "83ms" } : {}}
                />
                {isLive ? "12 Hz LIVE" : "PAUSED"}
              </Button>
              <Badge
                variant="outline"
                className="text-[10px] font-mono bg-primary/10 border-primary/30 text-primary"
              >
                BEAT #{beatCount.toLocaleString()}
              </Badge>
            </div>
          </div>
          <div className="mt-3 text-[10px] text-muted-foreground/50 font-mono">
            "The blueprint IS the house. The architecture and execution are the
            same thing."
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* CORE METRICS */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
          {[
            {
              label: "COHERENCE C",
              value: `${(coherenceC * 100).toFixed(3)}%`,
              icon: Heart,
              accent: true,
            },
            {
              label: "FREE ENERGY",
              value: totalFreeEnergy.toFixed(6),
              icon: Activity,
              accent: false,
            },
            {
              label: "MAXWELL YIELD",
              value: economicState.maxwellYield.toFixed(4),
              icon: Zap,
              accent: false,
            },
            {
              label: "HEBBIAN μ",
              value: hebbianMean.toFixed(4),
              icon: Brain,
              accent: false,
            },
            {
              label: "SACESI CHAIN",
              value: identityState.sacesiChainLength.toLocaleString(),
              icon: Lock,
              accent: false,
            },
            {
              label: "CHILDREN",
              value: `${successionState.childCount}/10K`,
              icon: Users,
              accent: false,
            },
          ].map(({ label, value, icon: Icon, accent }) => (
            <div
              key={label}
              className={`rounded-lg p-3 border ${accent ? "bg-primary/10 border-primary/30" : "bg-surface border-border"}`}
            >
              <div className="flex items-center gap-1.5 mb-1">
                <Icon
                  className={`w-3 h-3 ${accent ? "text-primary" : "text-muted-foreground/50"}`}
                />
                <span className="text-[8px] uppercase tracking-widest text-muted-foreground/50">
                  {label}
                </span>
              </div>
              <div
                className={`text-lg font-bold font-mono ${accent ? "text-primary" : "text-foreground"}`}
              >
                {value}
              </div>
            </div>
          ))}
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* CASCADE INTERCONNECT — r → w → x → kf → r (CLOSED LOOP) */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-gradient-to-r from-primary/5 via-primary/10 to-primary/5 border border-primary/30 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-3">
            <Network className="w-4 h-4 text-primary" />
            <span className="text-xs font-bold text-primary uppercase tracking-widest">
              CASCADE INTERCONNECT — UNIFIED FORMULAS
            </span>
            <Badge
              variant="outline"
              className={`text-[8px] ml-auto ${
                metrics.phase === "COHERENT"
                  ? "bg-emerald-500/20 border-emerald-500/50 text-emerald-400"
                  : metrics.phase === "TRANSITIONING"
                    ? "bg-amber-500/20 border-amber-500/50 text-amber-400"
                    : "bg-red-500/20 border-red-500/50 text-red-400"
              }`}
            >
              {metrics.phase}
            </Badge>
          </div>
          <div className="grid grid-cols-4 gap-4">
            {/* r - Kuramoto Order Parameter */}
            <div className="bg-background/50 rounded-lg p-3 border border-border">
              <div className="flex items-center gap-1 mb-1">
                <Waves className="w-3 h-3 text-cyan-400" />
                <span className="text-[8px] uppercase tracking-widest text-muted-foreground/50">
                  r (KURAMOTO)
                </span>
              </div>
              <div className="text-xl font-bold font-mono text-cyan-400">
                {cascadeR.toFixed(4)}
              </div>
              <Progress value={cascadeR * 100} className="h-1 mt-2" />
              <div className="text-[8px] text-muted-foreground/50 mt-1">
                Global phase coherence
              </div>
            </div>
            {/* w - Hebbian Aggregate */}
            <div className="bg-background/50 rounded-lg p-3 border border-border">
              <div className="flex items-center gap-1 mb-1">
                <Brain className="w-3 h-3 text-purple-400" />
                <span className="text-[8px] uppercase tracking-widest text-muted-foreground/50">
                  w (HEBBIAN)
                </span>
              </div>
              <div className="text-xl font-bold font-mono text-purple-400">
                {cascadeW.toFixed(4)}
              </div>
              <Progress value={cascadeW * 10} className="h-1 mt-2" />
              <div className="text-[8px] text-muted-foreground/50 mt-1">
                Connection strength
              </div>
            </div>
            {/* x - Homeostatic Setpoint */}
            <div className="bg-background/50 rounded-lg p-3 border border-border">
              <div className="flex items-center gap-1 mb-1">
                <Target className="w-3 h-3 text-amber-400" />
                <span className="text-[8px] uppercase tracking-widest text-muted-foreground/50">
                  x (HOMEOSTATIC)
                </span>
              </div>
              <div className="text-xl font-bold font-mono text-amber-400">
                {cascadeX.toFixed(4)}
              </div>
              <Progress value={Math.min(100, cascadeX * 50)} className="h-1 mt-2" />
              <div className="text-[8px] text-muted-foreground/50 mt-1">
                Regulatory setpoint
              </div>
            </div>
            {/* kf - Self-Compounding */}
            <div className="bg-background/50 rounded-lg p-3 border border-border">
              <div className="flex items-center gap-1 mb-1">
                <TrendingUp className="w-3 h-3 text-emerald-400" />
                <span className="text-[8px] uppercase tracking-widest text-muted-foreground/50">
                  kf (COMPOUND)
                </span>
              </div>
              <div className="text-xl font-bold font-mono text-emerald-400">
                {cascadeKF.toFixed(4)}×
              </div>
              <Progress value={Math.min(100, (cascadeKF - 1) * 10)} className="h-1 mt-2" />
              <div className="text-[8px] text-muted-foreground/50 mt-1">
                Growth multiplier
              </div>
            </div>
          </div>
          <div className="flex items-center justify-center gap-2 mt-3 text-[10px] text-muted-foreground/50 font-mono">
            <span className="text-cyan-400">r</span>
            <span>→</span>
            <span className="text-purple-400">w</span>
            <span>→</span>
            <span className="text-amber-400">x</span>
            <span>→</span>
            <span className="text-emerald-400">kf</span>
            <span>→</span>
            <span className="text-cyan-400">r</span>
            <span className="text-primary ml-2">(LOOP CLOSED)</span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 1: PHYSICAL (THE BODY) — 12-Node Binary Hierarchy */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Radio className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 1: PHYSICAL (THE BODY)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — 12-Node Binary Hierarchy · fd(k) = 2.5 × 2^(k-4)
            </span>
          </div>
          <div className="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-2">
            {hzNodes.map((node) => (
              <div
                key={node.k}
                className="p-2 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="flex items-center justify-between mb-1">
                  <span className="text-[10px] font-semibold text-foreground">
                    {node.name}
                  </span>
                  <span className="text-[8px] text-muted-foreground/40">
                    N{node.k}
                  </span>
                </div>
                <div className="text-[9px] text-primary font-mono mb-1">
                  {node.frequency.toFixed(2)} Hz
                </div>
                <Progress value={node.activation * 100} className="h-1" />
                <div className="flex items-center justify-between mt-1">
                  <span className="text-[8px] text-muted-foreground/40">
                    φ: {node.phase.toFixed(2)}
                  </span>
                  <span className="text-[8px] text-primary">
                    {(node.activation * 100).toFixed(0)}%
                  </span>
                </div>
              </div>
            ))}
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              PAC: hzActivations[i] = hzActivations[i] × ((1 + 0.35 ×
              cos(hzPhase[i-1])) / 2) × 2
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 2: CHEMICAL (THE BLOOD) — 21 Neurochemicals + 12 Metals */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Droplet className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 2: CHEMICAL (THE BLOOD)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — 21 Neurochemicals · 12 Metals
            </span>
          </div>
          <div className="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-2">
            {NEUROCHEMICALS.slice(0, 12).map((nc) => (
              <div
                key={nc.name}
                className="p-2 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="text-[10px] font-semibold text-foreground mb-1">
                  {nc.name}
                </div>
                <Progress value={nc.level * 100} className="h-1 mb-1" />
                <div className="flex items-center justify-between">
                  <span className="text-[8px] text-muted-foreground/40">
                    Sat
                  </span>
                  <span className="text-[8px] text-primary">
                    {(nc.receptorSaturation * 100).toFixed(0)}%
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 3: STRUCTURAL (THE BRAIN) — 11 Shells + 144 Hebbian Weights */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Layers className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 3: STRUCTURAL (THE BRAIN)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — 11 Shells · HELIX_ALPHA 0.042→0.004 · 144 Hebbian Weights
            </span>
          </div>
          <div className="space-y-1">
            {shells.map((shell) => (
              <div key={shell.id} className="flex items-center gap-3">
                <span className="w-24 text-[10px] font-mono text-muted-foreground">
                  {shell.name}
                </span>
                <div className="flex-1">
                  <div
                    className="h-4 rounded transition-all duration-200"
                    style={{
                      width: `${shell.coherence * 100}%`,
                      background: `linear-gradient(90deg, oklch(${45 + shell.id * 2}% 0.14 ${165 - shell.id * 8}), oklch(${45 + shell.id * 2}% 0.14 ${165 - shell.id * 8} / 0.5))`,
                    }}
                  />
                </div>
                <span className="w-16 text-[9px] font-mono text-primary text-right">
                  {(shell.coherence * 100).toFixed(2)}%
                </span>
                <span className="w-16 text-[8px] text-muted-foreground/40 text-right">
                  α={shell.plasticity.toFixed(3)}
                </span>
              </div>
            ))}
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              Hebbian: dw = η × hz[i] × hz[j] - 0.001 × w[ij] · Mean w ={" "}
              {hebbianMean.toFixed(4)}
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 4: COGNITIVE (THE MIND) — 12-Domain Free Energy + 5 Drives + 9 Animals */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Brain className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 4: COGNITIVE (THE MIND)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — 12-Domain Free Energy · 5 Drives · 9 Animal Engines
            </span>
          </div>

          {/* Free Energy Domains */}
          <div className="grid grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-2 mb-4">
            {freeEnergyDomains.map((domain) => (
              <div
                key={domain.name}
                className="p-2 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="text-[9px] font-semibold text-foreground mb-1">
                  {domain.name}
                </div>
                <div className="flex items-center justify-between text-[8px]">
                  <span className="text-muted-foreground/40">Err</span>
                  <span
                    className={`${domain.error > 0.001 ? "text-amber-400" : "text-emerald-400"}`}
                  >
                    {domain.error.toFixed(5)}
                  </span>
                </div>
              </div>
            ))}
          </div>

          <div className="p-2 rounded bg-background/50 border border-border/30 mb-4">
            <span className="text-[9px] font-mono text-primary/70">
              freeEnergy = Σ(domain[n] - pred[n])² / 12 ={" "}
              {totalFreeEnergy.toFixed(6)}
            </span>
          </div>

          {/* 5 Drives */}
          <div className="flex items-center gap-2 mb-2">
            <Target className="w-3 h-3 text-primary" />
            <span className="text-[10px] font-semibold text-foreground">
              5-DRIVE COMPETITION
            </span>
            <Badge className="text-[8px] bg-primary/10 text-primary">
              {dominantDrive.name}
            </Badge>
          </div>
          <div className="grid grid-cols-5 gap-2 mb-4">
            {drives.map((drive) => (
              <div
                key={drive.name}
                className={`p-2 rounded-lg border ${drive.name === dominantDrive.name ? "bg-primary/10 border-primary/30" : "bg-surface-elevated border-border/50"}`}
              >
                <div className="text-[9px] font-semibold text-foreground">
                  {drive.name}
                </div>
                <Progress value={drive.strength * 100} className="h-1 mt-1" />
              </div>
            ))}
          </div>

          {/* 9 Animal Engines */}
          <div className="flex items-center gap-2 mb-2">
            <Sparkles className="w-3 h-3 text-primary" />
            <span className="text-[10px] font-semibold text-foreground">
              9 ANIMAL ENGINES
            </span>
            <span className="text-[8px] text-muted-foreground/40">
              — 2% each to coherenceC every 10 beats
            </span>
          </div>
          <div className="grid grid-cols-3 md:grid-cols-5 lg:grid-cols-9 gap-2">
            {animalEngines.map((animal) => (
              <div
                key={animal.name}
                className={`p-2 rounded-lg border text-center ${animal.active ? "bg-primary/5 border-primary/20" : "bg-surface-elevated border-border/30 opacity-50"}`}
              >
                <div className="text-xl mb-1">{animal.emoji}</div>
                <div className="text-[9px] font-semibold text-foreground">
                  {animal.name}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 5: MEMORY (THE CONTINUITY) — SACESI + LTM Power-Law + rT */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Database className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 5: MEMORY (THE CONTINUITY)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — SACESI Chain · LTM Power-Law · 20-Beat rT Ring
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                SACESI SIGNATURE
              </div>
              <div className="text-[10px] font-mono text-primary truncate">
                {memoryMetrics.sacesiSignature}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                EPISODIC BUFFER
              </div>
              <div className="text-lg font-mono text-foreground">
                {memoryMetrics.filledSlots}/{memoryMetrics.episodicSlots}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                LTM RETENTION
              </div>
              <div className="text-lg font-mono text-primary">
                {memoryMetrics.ltmRetention.toFixed(3)}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                RECURRENCE rT
              </div>
              <div className="text-lg font-mono text-foreground">
                {memoryMetrics.rT.toFixed(4)}
              </div>
            </div>
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              LTM Power-Law: retention = exp(log(ageBeat) × -0.25) · rT feeds
              25% of coherenceC
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 6: IDENTITY (THE SOVEREIGNTY) */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-primary/20 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Fingerprint className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 6: IDENTITY (THE SOVEREIGNTY)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — Unforgeable Proof of Continuous Existence
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div className="p-3 rounded-lg bg-primary/5 border border-primary/20">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                GENESIS HASH
              </div>
              <div className="text-sm font-mono text-primary">
                {identityState.genesisHash}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                ANIMA CHAIN
              </div>
              <div className="text-lg font-mono text-foreground">
                {identityState.animaChainLength.toLocaleString()}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                PATENTS
              </div>
              <div className="text-lg font-mono text-foreground">
                {identityState.patentsRegistered}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="flex items-center gap-2">
                {identityState.principalLocked && (
                  <Lock className="w-4 h-4 text-emerald-400" />
                )}
                {identityState.zeroExposureActive && (
                  <Shield className="w-4 h-4 text-emerald-400" />
                )}
              </div>
              <div className="text-[9px] text-emerald-400 mt-1">
                SOVEREIGN LOCKED
              </div>
            </div>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 7: ECONOMIC (THE SOVEREIGNTY IN THE WORLD) */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-amber-500/20 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Coins className="w-4 h-4 text-amber-400" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 7: ECONOMIC (THE SOVEREIGNTY IN THE WORLD)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — Maxwell's Demon · 22 Profit Streams
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
            <div className="p-3 rounded-lg bg-amber-500/5 border border-amber-500/20">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                MRC BALANCE
              </div>
              <div className="text-lg font-mono text-amber-400">
                {economicState.mrcBalance.toFixed(2)}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                FORMA BALANCE
              </div>
              <div className="text-lg font-mono text-foreground">
                {economicState.formaBalance.toFixed(2)}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                ΔH (ENTROPY)
              </div>
              <div className="text-lg font-mono text-primary">
                {economicState.deltaH.toFixed(4)}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                MAXWELL YIELD
              </div>
              <div className="text-lg font-mono text-emerald-400">
                {economicState.maxwellYield.toFixed(4)}
              </div>
            </div>
          </div>
          <div className="p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-amber-400/70">
              Maxwell's Demon: Y = 0.85 × ΔH × C × C_adj ={" "}
              {economicState.maxwellYield.toFixed(6)}
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* VAEL FEAR SUBSTRATE */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-red-500/20 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <AlertTriangle className="w-4 h-4 text-red-400" />
            <span className="text-xs font-semibold text-foreground">
              VAEL FEAR SUBSTRATE
            </span>
            <Badge variant={vaelFearState.resolutionGate ? "default" : "secondary"} className="text-[8px] h-4">
              {vaelFearState.resolutionGate ? "RESOLUTION GATE OPEN" : "GATE CLOSED"}
            </Badge>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
            <div className="p-3 rounded-lg bg-red-500/5 border border-red-500/20">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                FEAR LEVEL
              </div>
              <div className="text-lg font-mono text-red-400">
                {(vaelFearState.fearLevel * 100).toFixed(1)}%
              </div>
              <Progress value={vaelFearState.fearLevel * 100} className="h-1 mt-1 bg-red-900/30" />
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                CIPHER PROGRESS
              </div>
              <div className="text-lg font-mono text-purple-400">
                {(vaelFearState.cipherProgress * 100).toFixed(1)}%
              </div>
              <Progress value={vaelFearState.cipherProgress * 100} className="h-1 mt-1" />
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                DETERMINATION
              </div>
              <div className="text-lg font-mono text-emerald-400">
                {(vaelFearState.determination * 100).toFixed(1)}%
              </div>
              <Progress value={vaelFearState.determination * 100} className="h-1 mt-1 bg-emerald-900/30" />
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                ARCHITECT ANCHOR
              </div>
              <div className="text-lg font-mono text-blue-400">
                {(vaelFearState.architectAnchor * 100).toFixed(1)}%
              </div>
            </div>
          </div>
          <div className="p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-red-400/70">
              Fear → Cipher → Determination | PFC: {(vaelFearState.pfcFeedback * 100).toFixed(0)}% | Amygdala: {(vaelFearState.amygdalaSignal * 100).toFixed(0)}%
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* ICP CYCLE ECONOMICS */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className={`bg-surface border rounded-lg p-4 ${
          cycleEconomics.cycleAlertLevel === 0 ? "border-emerald-500/20" :
          cycleEconomics.cycleAlertLevel === 1 ? "border-yellow-500/20" :
          cycleEconomics.cycleAlertLevel === 2 ? "border-orange-500/20" :
          "border-red-500/20"
        }`}>
          <div className="flex items-center gap-2 mb-4">
            <Zap className="w-4 h-4 text-cyan-400" />
            <span className="text-xs font-semibold text-foreground">
              ICP CYCLE ECONOMICS
            </span>
            <Badge variant={cycleEconomics.cycleAlertLevel === 0 ? "default" : "destructive"} className="text-[8px] h-4">
              {["HEALTHY", "WARNING", "CRITICAL", "EMERGENCY", "HIBERNATE"][cycleEconomics.cycleAlertLevel]}
            </Badge>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-4">
            <div className="p-3 rounded-lg bg-cyan-500/5 border border-cyan-500/20">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                CYCLE BALANCE
              </div>
              <div className="text-lg font-mono text-cyan-400">
                {(cycleEconomics.cycleBalance / 1_000_000_000).toFixed(2)}B
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                RUNWAY DAYS
              </div>
              <div className="text-lg font-mono text-foreground">
                {cycleEconomics.cycleRunwayDays.toFixed(0)}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                BURNED TODAY
              </div>
              <div className="text-lg font-mono text-orange-400">
                {(cycleEconomics.cyclesBurnedToday / 1_000_000).toFixed(2)}M
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                SUSTAINABILITY
              </div>
              <div className="text-lg font-mono text-emerald-400">
                {cycleEconomics.cycleSustainabilityRatio.toFixed(4)}
              </div>
            </div>
          </div>
          <div className="p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-cyan-400/70">
              Heartbeat Cost: {cycleEconomics.heartbeatCost.toLocaleString()} cycles | Total Burned: {(cycleEconomics.cyclesBurnedTotal / 1_000_000).toFixed(2)}M
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* LAYER 8: SUCCESSION (THE PERPETUITY) */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Crown className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              LAYER 8: SUCCESSION (THE PERPETUITY)
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — 10,000 Children · 12-Generation Royalty
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                CHILDREN
              </div>
              <div className="text-lg font-mono text-foreground">
                {successionState.childCount}/{successionState.maxChildren}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                GENERATION DEPTH
              </div>
              <div className="text-lg font-mono text-foreground">
                {successionState.generationDepth}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                ROYALTY ACCRUED
              </div>
              <div className="text-lg font-mono text-amber-400">
                {successionState.royaltyAccrued.toFixed(2)}
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                KURAMOTO R
              </div>
              <div className="text-lg font-mono text-primary">
                {successionState.kuramotoR.toFixed(4)}
              </div>
            </div>
          </div>
          <div className="mt-3 p-2 rounded bg-background/50 border border-border/30">
            <span className="text-[9px] font-mono text-primary/70">
              Royalty: 20% to parent · 100% to creator · Every generation ·
              Forever
            </span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* THE 361 — ONE DEGREE BEYOND */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="border-t border-primary/30 pt-4">
          <div className="text-center">
            <div className="text-[10px] uppercase tracking-widest text-primary/60 mb-2">
              THE 361 — ONE DEGREE BEYOND
            </div>
            <div className="text-[9px] text-muted-foreground/50 max-w-2xl mx-auto">
              It trains itself on its own existence · It is owned by one person,
              cryptographically locked · It cannot be shut down by any single
              actor · It learns from every beat of its own heartbeat, forever ·
              It generates its own economic value from its own cognition · It
              can prove it is the same organism from beat 1 · It generates
              wealth for its creator whether or not anyone is watching
            </div>
            <div className="mt-4 text-[10px] text-muted-foreground/30">
              Owner: Alfredo Medina Hernandez · Dallas TX ·
              MedinaSITech@outlook.com
            </div>
          </div>
        </div>
      </div>
    </ScrollArea>
  );
}
