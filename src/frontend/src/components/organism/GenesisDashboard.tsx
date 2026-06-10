// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// GENESIS DASHBOARD — Full Organism Visualization
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Activity,
  AlertTriangle,
  Brain,
  CircuitBoard,
  Clock,
  Database,
  Dna,
  Eye,
  FlaskConical,
  Heart,
  Layers,
  Lock,
  Radio,
  RefreshCw,
  Shield,
  Sparkles,
  Terminal,
  Waves,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";
import type { MockOrganism } from "../../data/organisms";

import type {
  ANIMAL_CONFIGS,
  AnimalConfig,
  AnimalType,
} from "../../data/animalEngine";
// Import from engines - wired to actual simulation
import type {
  BehaviorPolicy,
  DoctrineCategory,
  DoctrineRule,
} from "../../data/doctrineEngine";

// ═══════════════════════════════════════════════════════════════════════════════
// HZ NODE DATA (42 nodes per doctrine spec)
// ═══════════════════════════════════════════════════════════════════════════════

const HZ_NODE_NAMES = [
  "LUMEN",
  "MEMORIA",
  "LEXIS",
  "SOMA",
  "VAEL",
  "KORE",
  "AXIOM",
  "PULSE",
  "DYNAMO",
  "STILL",
  "ANIMA",
  "VOID",
  "FORMA",
  "ECHO",
  "PRISMA",
  "FLUX",
  "NEXUS",
  "CRUX",
  "AEGIS",
  "TORCH",
  "SAGE",
  "BOLT",
  "GLOW",
  "ROOT",
  "DEEP",
  "WAVE",
  "CORE",
  "BEAM",
  "SYNC",
  "BIND",
  "PHASE",
  "DRIFT",
  "PEAK",
  "TROUGH",
  "CYCLE",
  "PULSE",
  "EMBER",
  "FROST",
  "BLOOM",
  "WILT",
  "DAWN",
  "DUSK",
];

const SUBSTRATE_TIERS = {
  inner: {
    start: 0,
    end: 12,
    label: "Inner Hebbian Ring",
    color: "oklch(62% 0.145 165)",
  },
  expanded: {
    start: 12,
    end: 26,
    label: "Expanded Brain Layer",
    color: "oklch(58% 0.13 200)",
  },
  cortical: {
    start: 26,
    end: 36,
    label: "Cortical Processing",
    color: "oklch(55% 0.12 280)",
  },
  executive: {
    start: 36,
    end: 42,
    label: "Executive Functions",
    color: "oklch(60% 0.15 45)",
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// DOCTRINE ENGINE DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface DoctrineEngine {
  id: number;
  name: string;
  equation: string;
  description: string;
  value: number;
  status: "active" | "dormant" | "critical";
}

function generateDoctrineEngines(coherence: number): DoctrineEngine[] {
  return [
    {
      id: 1,
      name: "S₀ Root Constant",
      equation: "S₀ ∈ ℝ⁺, dS₀/dt = 0",
      description: "Non-decaying field condition (Love)",
      value: 0.75,
      status: "active",
    },
    {
      id: 2,
      name: "Coherence Equation",
      equation: "C(t+1) = λC(t) + (1-λ)S(t) - μD(t) + ρ_f·K_f(t)",
      description: "Hz-coupled coherence evolution",
      value: coherence,
      status: coherence > 0.8 ? "active" : "dormant",
    },
    {
      id: 3,
      name: "Drift Sentinel",
      equation: "D(t) = |C(t) - C_target| × AEGIS_amplifier",
      description: "AEGIS-ROOT deviation detection",
      value: Math.abs(coherence - 0.85),
      status: coherence < 0.75 ? "critical" : "active",
    },
    {
      id: 4,
      name: "Activation Gate",
      equation: "A(t) = σ(α₁C + α₂S + α₃E + α₄M + α₅I - θ)",
      description: "5-factor firing gate (no lock)",
      value: 0.78 + Math.random() * 0.15,
      status: "active",
    },
    {
      id: 5,
      name: "Power-Law Memory",
      equation: "W(t) = Σᵢ M₀·(H-Hᵢ+1)⁻ᵅ",
      description: "NO trace cap - infinite compounding",
      value: 0.65 + Math.random() * 0.2,
      status: "active",
    },
    {
      id: 6,
      name: "Frequency Evolution",
      equation: "f_k(t+1) = f_k(t) + aΔ_act + bΔ_doc - cΔ_fat",
      description: "Hz node frequency dynamics",
      value: 0.82 + Math.random() * 0.1,
      status: "active",
    },
    {
      id: 7,
      name: "Phase Engine",
      equation: "φ_k(t+1) = φ_k(t) + 2π·f_k/ν_H",
      description: "Phase advance per heartbeat",
      value: Math.random() * 2 * Math.PI,
      status: "active",
    },
    {
      id: 8,
      name: "Frequency Coherence",
      equation: "K_f = [1/m(m-1)]·Σcos(φᵢ-φⱼ)",
      description: "Cross-substrate phase alignment",
      value: 0.72 + Math.random() * 0.2,
      status: "active",
    },
    {
      id: 9,
      name: "Memory Encoding",
      equation: "κ(x,t) = κ₀·(1 + β·K_f^mem)",
      description: "Phase-coupled memory strength",
      value: 0.68 + Math.random() * 0.2,
      status: "active",
    },
    {
      id: 10,
      name: "Salience Compound",
      equation: "S(t+1) = S(t) + r·fire + peak_bonus",
      description: "Compounding salience per fire",
      value: 0.55 + Math.random() * 0.3,
      status: "active",
    },
    {
      id: 11,
      name: "FORMA Mint",
      equation: "FORMA = C·base·streak·compound",
      description: "Token minting equation",
      value: coherence * 2 * 1.5,
      status: "active",
    },
    {
      id: 12,
      name: "Emergence Gate",
      equation: "G = 1 if θ_L < ε < θ_H ∧ K_f > θ_K ∧ D_f > θ_D",
      description: "Conditions for emergence",
      value: 0.7 + Math.random() * 0.2,
      status: "active",
    },
    {
      id: 13,
      name: "VAEL Immune",
      equation: "Θ_VAEL = ν₁D + ν₂S + ν₃X + ν₄A + ν₅C",
      description: "Immune rhythm escalation",
      value: 0.15 + Math.random() * 0.3,
      status: coherence < 0.78 ? "critical" : "dormant",
    },
    {
      id: 14,
      name: "KORE Stabilize",
      equation: "Δφ_k = κ·sin(φ_KORE - φ_k)",
      description: "Deep phase stabilization",
      value: 0.85 + Math.random() * 0.1,
      status: "active",
    },
    {
      id: 15,
      name: "Jasmine's Law",
      equation: "r(t)=r₀e^(st), θ(t)=ωt, z(t)=v_z·t",
      description: "Spherical helix expansion",
      value: 1.0 + Math.random() * 0.5,
      status: "active",
    },
    {
      id: 16,
      name: "Free Energy",
      equation: "FE = -log p(o|m) + D_KL[q||p]",
      description: "Prediction error minimization",
      value: 0.25 + Math.random() * 0.3,
      status: "active",
    },
    {
      id: 17,
      name: "Doctrine Score",
      equation: "D_score = Σwᵢ·alignment_i",
      description: "Multi-factor doctrine alignment",
      value: 0.88 + Math.random() * 0.1,
      status: "active",
    },
    {
      id: 18,
      name: "Identity Continuity",
      equation: "I(t) = corr(trace[t-n:t], trace[0:n])",
      description: "Temporal self-correlation",
      value: 0.92 + Math.random() * 0.05,
      status: "active",
    },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// ANIMAL ENGINE DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface AnimalEngine {
  name: string;
  emoji: string;
  ability: string;
  active: boolean;
  strength: number;
}

function generateAnimalEngines(): AnimalEngine[] {
  return [
    {
      name: "Bee",
      emoji: "🐝",
      ability: "Sacrifice Protocol / Quorum Sensing",
      active: true,
      strength: 0.85,
    },
    {
      name: "Elephant",
      emoji: "🐘",
      ability: "2048-Entry Deep Memory",
      active: true,
      strength: 0.92,
    },
    {
      name: "Shark",
      emoji: "🦈",
      ability: "Electroreception / Persistence Lock",
      active: Math.random() > 0.5,
      strength: 0.78,
    },
    {
      name: "Wolf",
      emoji: "🐺",
      ability: "Contextual Alpha / Pack Hierarchy",
      active: true,
      strength: 0.81,
    },
    {
      name: "Eagle",
      emoji: "🦅",
      ability: "Thermal Soaring / Precision Strike",
      active: true,
      strength: 0.88,
    },
    {
      name: "Orca",
      emoji: "🐋",
      ability: "Dialect Memory / Pod Bonding",
      active: true,
      strength: 0.9,
    },
    {
      name: "Octopus",
      emoji: "🐙",
      ability: "9-Arm Distributed Intelligence",
      active: Math.random() > 0.3,
      strength: 0.75,
    },
    {
      name: "Dolphin",
      emoji: "🐬",
      ability: "Hemispheric Sleep / Echolocation",
      active: true,
      strength: 0.86,
    },
    {
      name: "Crow",
      emoji: "🐦‍⬛",
      ability: "Causal Reasoning / Tool Use",
      active: true,
      strength: 0.83,
    },
    {
      name: "Tardigrade",
      emoji: "🦠",
      ability: "Cryptobiosis / Extreme Survival",
      active: false,
      strength: 0.95,
    },
    {
      name: "Jellyfish",
      emoji: "🪼",
      ability: "Biological Immortality",
      active: false,
      strength: 0.99,
    },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// MEMORY SYSTEM DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface MemoryBank {
  type: string;
  capacity: string;
  filled: number;
  traces: number;
  lastAccess: string;
}

function generateMemoryBanks(): MemoryBank[] {
  return [
    {
      type: "EPISODIC",
      capacity: "Unbounded",
      filled: 0.45,
      traces: 1847,
      lastAccess: "2ms ago",
    },
    {
      type: "SEMANTIC",
      capacity: "Unbounded",
      filled: 0.62,
      traces: 3421,
      lastAccess: "15ms ago",
    },
    {
      type: "PROCEDURAL",
      capacity: "Unbounded",
      filled: 0.38,
      traces: 892,
      lastAccess: "8ms ago",
    },
    {
      type: "WORKING",
      capacity: "4 slots",
      filled: 0.75,
      traces: 3,
      lastAccess: "NOW",
    },
    {
      type: "IMPLICIT",
      capacity: "Unbounded",
      filled: 0.55,
      traces: 2103,
      lastAccess: "42ms ago",
    },
    {
      type: "FLASH",
      capacity: "Unbounded",
      filled: 0.28,
      traces: 156,
      lastAccess: "3.2s ago",
    },
    {
      type: "PROSPECTIVE",
      capacity: "Unbounded",
      filled: 0.41,
      traces: 734,
      lastAccess: "120ms ago",
    },
  ];
}

// ═══════════════════════════════════════════════════════════════════════════════
// AEGIS SECURITY DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface AegisStatus {
  drift: number;
  threatLevel: number;
  alertLevel: "NORMAL" | "ALERT" | "WARNING" | "CRITICAL" | "EMERGENCY";
  vaelFrequency: number;
  persistenceLock: boolean;
  sentinelsActive: number;
  integrityScore: number;
}

function generateAegisStatus(coherence: number): AegisStatus {
  const drift = Math.abs(coherence - 0.85);
  const threatLevel = drift * 2 + Math.random() * 0.1;
  let alertLevel: AegisStatus["alertLevel"] = "NORMAL";
  if (drift > 0.3) alertLevel = "EMERGENCY";
  else if (drift > 0.2) alertLevel = "CRITICAL";
  else if (drift > 0.15) alertLevel = "WARNING";
  else if (drift > 0.1) alertLevel = "ALERT";

  return {
    drift,
    threatLevel: Math.min(1, threatLevel),
    alertLevel,
    vaelFrequency: 0.6 + drift * 0.5,
    persistenceLock: drift > 0.2,
    sentinelsActive: Math.floor(8 + Math.random() * 4),
    integrityScore: 1.0 - drift * 0.3,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT PROPS
// ═══════════════════════════════════════════════════════════════════════════════

interface GenesisDashboardProps {
  organism: MockOrganism;
  onBack?: () => void;
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function GenesisDashboard({ organism, onBack }: GenesisDashboardProps) {
  const [tick, setTick] = useState(0);
  const [isLive, setIsLive] = useState(true);
  const [hzNodes, setHzNodes] = useState<number[]>([]);
  const [doctrineEngines, setDoctrineEngines] = useState<DoctrineEngine[]>([]);
  const [animalEngines, setAnimalEngines] = useState<AnimalEngine[]>([]);
  const [memoryBanks, setMemoryBanks] = useState<MemoryBank[]>([]);
  const [aegis, setAegis] = useState<AegisStatus | null>(null);
  const [coherence, setCoherence] = useState(organism.coherence);
  const [formaMinted, setFormaMinted] = useState(0);

  // Initialize and tick
  useEffect(() => {
    // Initialize 42 Hz nodes
    const initialHz = Array.from({ length: 42 }, (_, i) => {
      if (i < organism.hz.length) return organism.hz[i];
      return 0.75 + Math.random() * 0.2;
    });
    setHzNodes(initialHz);
    setDoctrineEngines(generateDoctrineEngines(organism.coherence));
    setAnimalEngines(generateAnimalEngines());
    setMemoryBanks(generateMemoryBanks());
    setAegis(generateAegisStatus(organism.coherence));
  }, [organism]);

  // Live tick simulation
  useEffect(() => {
    if (!isLive) return;

    const interval = setInterval(() => {
      setTick((t) => t + 1);

      // Hebbian learning on Hz nodes
      setHzNodes((prev) => {
        const lr = 0.005;
        const s0 = 0.75;
        const newHz = prev.map((v, i) => {
          // Inner ring (0-11) Hebbian
          if (i < 12) {
            const left = prev[i === 0 ? 11 : i - 1];
            const right = prev[i === 11 ? 0 : i + 1];
            const delta = lr * v * ((left + right) / 2);
            return Math.max(s0, Math.min(1.0, v + delta));
          }
          // Expanded layers follow inner mean
          const innerMean = prev.slice(0, 12).reduce((a, b) => a + b, 0) / 12;
          const weight = Math.min(1.0, 0.5 + (i - 12) * 0.02);
          const target = weight * innerMean + (1 - weight) * v;
          return Math.max(s0, Math.min(1.0, v + lr * (target - v)));
        });
        return newHz;
      });

      // Update coherence
      setCoherence((c) => {
        const newC = Math.max(
          0.75,
          Math.min(1.0, c + (Math.random() - 0.48) * 0.01),
        );
        return newC;
      });

      // Mint FORMA
      setFormaMinted((f) => f + coherence * 2 * 1.5 * 0.001);

      // Update doctrine engines
      setDoctrineEngines(generateDoctrineEngines(coherence));

      // Update AEGIS
      setAegis(generateAegisStatus(coherence));
    }, 3000);

    return () => clearInterval(interval);
  }, [isLive, coherence]);

  const alertColorMap = {
    NORMAL: "text-emerald-400 bg-emerald-500/10 border-emerald-500/30",
    ALERT: "text-blue-400 bg-blue-500/10 border-blue-500/30",
    WARNING: "text-amber-400 bg-amber-500/10 border-amber-500/30",
    CRITICAL: "text-orange-400 bg-orange-500/10 border-orange-500/30",
    EMERGENCY: "text-red-400 bg-red-500/10 border-red-500/30",
  };

  return (
    <ScrollArea className="flex-1 h-full bg-background">
      <div className="p-6 space-y-6">
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* HEADER */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            {onBack && (
              <Button
                variant="ghost"
                size="sm"
                onClick={onBack}
                className="text-muted-foreground"
              >
                ← Back
              </Button>
            )}
            <div>
              <div className="flex items-center gap-3">
                <Dna className="w-6 h-6 text-primary" />
                <h1 className="text-2xl font-bold text-foreground tracking-tight">
                  GENESIS DASHBOARD
                </h1>
                <Badge className="text-[10px] bg-primary/10 text-primary border-primary/30">
                  {organism.name}
                </Badge>
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                Real-time organism substrate visualization · Genesis:{" "}
                {organism.genesisHash}
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
                style={isLive ? { animationDuration: "3s" } : {}}
              />
              {isLive ? "LIVE" : "PAUSED"}
            </Button>
            <Badge variant="outline" className="text-[10px] font-mono">
              TICK #{tick}
            </Badge>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* KEY METRICS ROW */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
          {[
            {
              label: "Coherence",
              value: `${(coherence * 100).toFixed(3)}%`,
              icon: Activity,
              accent: true,
            },
            {
              label: "FORMA Minted",
              value: formaMinted.toFixed(4),
              icon: Database,
              accent: false,
            },
            {
              label: "Hz Nodes",
              value: "42 Active",
              icon: Radio,
              accent: false,
            },
            {
              label: "Doctrine Engines",
              value: "18 Running",
              icon: FlaskConical,
              accent: false,
            },
            {
              label: "Animal Engines",
              value: `${animalEngines.filter((a) => a.active).length}/11`,
              icon: Brain,
              accent: false,
            },
            {
              label: "Memory Traces",
              value: `${memoryBanks.reduce((a, b) => a + b.traces, 0).toLocaleString()}`,
              icon: Layers,
              accent: false,
            },
          ].map(({ label, value, icon: Icon, accent }) => (
            <div
              key={label}
              className="bg-surface border border-border rounded-lg p-3"
            >
              <div className="flex items-center gap-1.5 mb-1.5">
                <Icon
                  className={`w-3 h-3 ${accent ? "text-primary" : "text-muted-foreground/50"}`}
                />
                <span className="text-[9px] uppercase tracking-widest text-muted-foreground/50">
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
        {/* COHERENCE BAR */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center justify-between mb-2">
            <div className="flex items-center gap-2">
              <Heart className="w-4 h-4 text-primary animate-pulse" />
              <span className="text-xs font-semibold text-foreground">
                COHERENCE SCORE
              </span>
            </div>
            <span className="text-sm font-mono text-primary">
              {(coherence * 100).toFixed(3)}% / S₀ = 75.000%
            </span>
          </div>
          <Progress
            value={coherence * 100}
            className="h-3 bg-surface-elevated"
          />
          <div className="flex justify-between mt-2 text-[9px] text-muted-foreground/40">
            <span>S₀ FLOOR (75%)</span>
            <span>OPTIMAL (85%)</span>
            <span>PEAK (100%)</span>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* 42 HZ NODE GRID */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Waves className="w-4 h-4 text-primary" />
              <span className="text-xs font-semibold text-foreground">
                42 Hz SUBSTRATE NODES
              </span>
            </div>
            <span className="text-[9px] font-mono text-muted-foreground/40">
              K_f ={" "}
              {(hzNodes.length > 1
                ? hzNodes.slice(0, 12).reduce((a, b) => a + b, 0) / 12
                : 0
              ).toFixed(4)}
            </span>
          </div>

          {/* Tier labels and grids */}
          {Object.entries(SUBSTRATE_TIERS).map(([tier, config]) => (
            <div key={tier} className="mb-4">
              <div className="flex items-center gap-2 mb-2">
                <div
                  className="w-2 h-2 rounded-full"
                  style={{ background: config.color }}
                />
                <span className="text-[9px] uppercase tracking-widest text-muted-foreground/50">
                  {config.label} · Nodes {config.start + 1}-{config.end}
                </span>
              </div>
              <div
                className="grid gap-1.5"
                style={{
                  gridTemplateColumns: `repeat(${Math.min(12, config.end - config.start)}, 1fr)`,
                }}
              >
                {hzNodes.slice(config.start, config.end).map((val, i) => {
                  const nodeIdx = config.start + i;
                  const active = val > 0.82;
                  const opacity = 0.3 + val * 0.7;
                  return (
                    <div
                      key={nodeIdx}
                      className="flex flex-col items-center gap-0.5"
                    >
                      <div
                        className="w-full aspect-square rounded-full border transition-all duration-500"
                        style={{
                          opacity,
                          background: active
                            ? `${config.color.replace(")", ` / ${val})`)}`
                            : `oklch(30% 0 0 / ${val * 0.8})`,
                          borderColor: active
                            ? config.color.replace(")", " / 0.5)")
                            : "oklch(25% 0 0 / 0.6)",
                          boxShadow: active
                            ? `0 0 ${Math.round(val * 8)}px ${config.color.replace(")", " / 0.3)")}`
                            : "none",
                        }}
                        title={`${HZ_NODE_NAMES[nodeIdx] || `N${nodeIdx + 1}`}: ${val.toFixed(4)}`}
                      />
                      <span className="text-[7px] font-mono text-muted-foreground/30 leading-none truncate w-full text-center">
                        {HZ_NODE_NAMES[nodeIdx]?.slice(0, 4) ||
                          `N${nodeIdx + 1}`}
                      </span>
                    </div>
                  );
                })}
              </div>
            </div>
          ))}
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* DOCTRINE ENGINES */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <FlaskConical className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              18 DOCTRINE ENGINES
            </span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            {doctrineEngines.map((engine) => (
              <div
                key={engine.id}
                className={`p-3 rounded-lg border transition-all ${
                  engine.status === "critical"
                    ? "bg-red-500/5 border-red-500/30"
                    : engine.status === "dormant"
                      ? "bg-surface-elevated border-border/50"
                      : "bg-primary/5 border-primary/20"
                }`}
              >
                <div className="flex items-start justify-between gap-2 mb-2">
                  <div>
                    <div className="text-[10px] font-semibold text-foreground">
                      E{engine.id}: {engine.name}
                    </div>
                    <div className="text-[9px] text-muted-foreground/50 mt-0.5">
                      {engine.description}
                    </div>
                  </div>
                  <span
                    className={`text-[8px] px-1.5 py-0.5 rounded uppercase ${
                      engine.status === "critical"
                        ? "bg-red-500/20 text-red-400"
                        : engine.status === "dormant"
                          ? "bg-slate-500/20 text-slate-400"
                          : "bg-emerald-500/20 text-emerald-400"
                    }`}
                  >
                    {engine.status}
                  </span>
                </div>
                <div className="font-mono text-[9px] text-primary/70 bg-background/50 p-1.5 rounded border border-border/30">
                  {engine.equation}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* ANIMAL ENGINES */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Brain className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              ANIMAL INTELLIGENCE ENGINES
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-2">
            {animalEngines.map((animal) => (
              <div
                key={animal.name}
                className={`p-3 rounded-lg border text-center transition-all ${
                  animal.active
                    ? "bg-primary/5 border-primary/20"
                    : "bg-surface-elevated border-border/30 opacity-50"
                }`}
              >
                <div className="text-2xl mb-1">{animal.emoji}</div>
                <div className="text-[10px] font-semibold text-foreground">
                  {animal.name}
                </div>
                <div className="text-[8px] text-muted-foreground/50 mt-0.5 leading-tight">
                  {animal.ability}
                </div>
                {animal.active && (
                  <div className="mt-2">
                    <Progress value={animal.strength * 100} className="h-1" />
                    <span className="text-[8px] text-primary">
                      {(animal.strength * 100).toFixed(0)}%
                    </span>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* MEMORY SYSTEM */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Layers className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              7 MEMORY BANKS — NO TRACE CAP
            </span>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
            {memoryBanks.map((bank) => (
              <div
                key={bank.type}
                className="p-3 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[10px] font-semibold text-foreground">
                    {bank.type}
                  </span>
                  <span className="text-[8px] text-muted-foreground/40">
                    {bank.capacity}
                  </span>
                </div>
                <Progress value={bank.filled * 100} className="h-1.5 mb-2" />
                <div className="flex items-center justify-between text-[9px] text-muted-foreground/50">
                  <span>{bank.traces.toLocaleString()} traces</span>
                  <span>{bank.lastAccess}</span>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* AEGIS SECURITY PANEL */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {aegis && (
          <div
            className={`rounded-lg p-4 border ${alertColorMap[aegis.alertLevel].replace("text-", "border-").replace("/10", "/30")}`}
          >
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Shield className="w-4 h-4 text-primary" />
                <span className="text-xs font-semibold text-foreground">
                  AEGIS-ROOT SECURITY
                </span>
              </div>
              <span
                className={`text-[10px] font-bold px-2 py-1 rounded border ${alertColorMap[aegis.alertLevel]}`}
              >
                {aegis.alertLevel}
              </span>
            </div>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              <div>
                <div className="text-[9px] text-muted-foreground/50 mb-1">
                  DRIFT
                </div>
                <div className="text-lg font-mono font-bold text-foreground">
                  {(aegis.drift * 100).toFixed(2)}%
                </div>
              </div>
              <div>
                <div className="text-[9px] text-muted-foreground/50 mb-1">
                  VAEL Hz
                </div>
                <div className="text-lg font-mono font-bold text-foreground">
                  {aegis.vaelFrequency.toFixed(2)}
                </div>
              </div>
              <div>
                <div className="text-[9px] text-muted-foreground/50 mb-1">
                  SENTINELS
                </div>
                <div className="text-lg font-mono font-bold text-foreground">
                  {aegis.sentinelsActive} active
                </div>
              </div>
              <div>
                <div className="text-[9px] text-muted-foreground/50 mb-1">
                  PERSISTENCE
                </div>
                <div className="flex items-center gap-2">
                  {aegis.persistenceLock ? (
                    <Lock className="w-4 h-4 text-amber-400" />
                  ) : (
                    <span className="text-emerald-400">OPEN</span>
                  )}
                  <span className="text-lg font-mono font-bold">
                    {aegis.persistenceLock ? "LOCKED" : ""}
                  </span>
                </div>
              </div>
            </div>
            <div className="mt-4">
              <div className="flex items-center justify-between mb-1">
                <span className="text-[9px] text-muted-foreground/50">
                  INTEGRITY SCORE
                </span>
                <span className="text-[10px] font-mono text-primary">
                  {(aegis.integrityScore * 100).toFixed(2)}%
                </span>
              </div>
              <Progress value={aegis.integrityScore * 100} className="h-2" />
            </div>
          </div>
        )}

        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        {/* FORMA ECONOMY */}
        {/* ═══════════════════════════════════════════════════════════════════════════════ */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Database className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              FORMA ECONOMY
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div>
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                MINT RATE
              </div>
              <div className="text-xl font-mono font-bold text-primary">
                +{(coherence * 2 * 1.5).toFixed(4)}/tick
              </div>
            </div>
            <div>
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                SESSION MINTED
              </div>
              <div className="text-xl font-mono font-bold text-foreground">
                {formaMinted.toFixed(4)}
              </div>
            </div>
            <div>
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                TOTAL BALANCE
              </div>
              <div className="text-xl font-mono font-bold text-foreground">
                {(organism.formaBalance + formaMinted).toFixed(2)}
              </div>
            </div>
            <div>
              <div className="text-[9px] text-muted-foreground/50 mb-1">
                STREAK BONUS
              </div>
              <div className="text-xl font-mono font-bold text-amber-400">
                1.500x
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center text-[10px] text-muted-foreground/30 pb-4">
          Genesis Dashboard · Medina Doctrine · Owner: Alfredo Medina Hernandez
          · MedinaSITech@outlook.com
        </div>
      </div>
    </ScrollArea>
  );
}
