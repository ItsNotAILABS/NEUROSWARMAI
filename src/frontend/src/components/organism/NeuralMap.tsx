// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// NEURAL MAP — Cortical Layer Visualization
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Activity,
  Brain,
  CircuitBoard,
  Cpu,
  Eye,
  Layers,
  RefreshCw,
  Sparkles,
  Waves,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════
// CORTICAL LAYER DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface CorticalLayer {
  id: string;
  name: string;
  fullName: string;
  thickness: number;
  excitatory: number;
  inhibitory: number;
  activity: number;
  oscillationBand: string;
  feedforward: number;
  feedback: number;
  color: string;
}

const CORTICAL_LAYERS: CorticalLayer[] = [
  {
    id: "L1",
    name: "L1",
    fullName: "Molecular Layer",
    thickness: 0.05,
    excitatory: 0.0,
    inhibitory: 0.1,
    activity: 0.3,
    oscillationBand: "Gamma",
    feedforward: 0.2,
    feedback: 0.8,
    color: "oklch(70% 0.12 200)",
  },
  {
    id: "L2",
    name: "L2",
    fullName: "External Granular",
    thickness: 0.15,
    excitatory: 0.7,
    inhibitory: 0.3,
    activity: 0.6,
    oscillationBand: "Beta",
    feedforward: 0.6,
    feedback: 0.4,
    color: "oklch(65% 0.14 180)",
  },
  {
    id: "L3",
    name: "L3",
    fullName: "External Pyramidal",
    thickness: 0.25,
    excitatory: 0.75,
    inhibitory: 0.25,
    activity: 0.75,
    oscillationBand: "Beta",
    feedforward: 0.7,
    feedback: 0.3,
    color: "oklch(60% 0.15 165)",
  },
  {
    id: "L4",
    name: "L4",
    fullName: "Internal Granular",
    thickness: 0.2,
    excitatory: 0.65,
    inhibitory: 0.35,
    activity: 0.85,
    oscillationBand: "Alpha",
    feedforward: 0.9,
    feedback: 0.1,
    color: "oklch(55% 0.14 150)",
  },
  {
    id: "L5",
    name: "L5",
    fullName: "Internal Pyramidal",
    thickness: 0.2,
    excitatory: 0.8,
    inhibitory: 0.2,
    activity: 0.7,
    oscillationBand: "Theta",
    feedforward: 0.8,
    feedback: 0.2,
    color: "oklch(50% 0.13 135)",
  },
  {
    id: "L6",
    name: "L6",
    fullName: "Multiform Layer",
    thickness: 0.15,
    excitatory: 0.7,
    inhibitory: 0.3,
    activity: 0.5,
    oscillationBand: "Delta",
    feedforward: 0.3,
    feedback: 0.7,
    color: "oklch(45% 0.12 120)",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// OSCILLATION BAND DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface OscillationBand {
  name: string;
  frequency: string;
  amplitude: number;
  phase: number;
  coherence: number;
  description: string;
  color: string;
}

const OSCILLATION_BANDS: OscillationBand[] = [
  {
    name: "Delta",
    frequency: "0.5-4 Hz",
    amplitude: 0.3,
    phase: 0,
    coherence: 0.7,
    description: "Deep sleep, unconscious",
    color: "oklch(55% 0.15 280)",
  },
  {
    name: "Theta",
    frequency: "4-8 Hz",
    amplitude: 0.4,
    phase: 0,
    coherence: 0.75,
    description: "Memory, navigation",
    color: "oklch(60% 0.15 200)",
  },
  {
    name: "Alpha",
    frequency: "8-13 Hz",
    amplitude: 0.5,
    phase: 0,
    coherence: 0.82,
    description: "Relaxed attention",
    color: "oklch(62% 0.14 165)",
  },
  {
    name: "Beta",
    frequency: "13-30 Hz",
    amplitude: 0.35,
    phase: 0,
    coherence: 0.68,
    description: "Active thinking",
    color: "oklch(58% 0.13 100)",
  },
  {
    name: "Gamma",
    frequency: "30-100 Hz",
    amplitude: 0.25,
    phase: 0,
    coherence: 0.6,
    description: "Binding, consciousness",
    color: "oklch(65% 0.16 45)",
  },
  {
    name: "High Gamma",
    frequency: "100-200 Hz",
    amplitude: 0.15,
    phase: 0,
    coherence: 0.55,
    description: "Local processing",
    color: "oklch(70% 0.14 30)",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// THALAMIC NUCLEI DATA
// ═══════════════════════════════════════════════════════════════════════════════

interface ThalamicNucleus {
  name: string;
  type: string;
  firingRate: number;
  burstMode: boolean;
  gating: number;
  corticalTargets: string[];
}

const THALAMIC_NUCLEI: ThalamicNucleus[] = [
  {
    name: "LGN",
    type: "Relay",
    firingRate: 0.75,
    burstMode: false,
    gating: 0.85,
    corticalTargets: ["V1", "V2"],
  },
  {
    name: "MGN",
    type: "Relay",
    firingRate: 0.7,
    burstMode: false,
    gating: 0.8,
    corticalTargets: ["A1"],
  },
  {
    name: "VPL",
    type: "Relay",
    firingRate: 0.72,
    burstMode: false,
    gating: 0.82,
    corticalTargets: ["S1"],
  },
  {
    name: "Pulvinar",
    type: "Association",
    firingRate: 0.6,
    burstMode: true,
    gating: 0.65,
    corticalTargets: ["PFC", "PPC"],
  },
  {
    name: "MD",
    type: "Association",
    firingRate: 0.55,
    burstMode: true,
    gating: 0.6,
    corticalTargets: ["PFC"],
  },
  {
    name: "Reticular",
    type: "Inhibitory",
    firingRate: 0.5,
    burstMode: true,
    gating: 0.4,
    corticalTargets: ["ALL"],
  },
];

// ═══════════════════════════════════════════════════════════════════════════════
// PLASTICITY STATE
// ═══════════════════════════════════════════════════════════════════════════════

interface PlasticityState {
  ltpActive: boolean;
  ltdActive: boolean;
  ltpMagnitude: number;
  ltdMagnitude: number;
  stdpWindow: number;
  bcmThreshold: number;
  homeostaticActive: boolean;
  totalLtpEvents: number;
  totalLtdEvents: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CORTICAL COLUMN
// ═══════════════════════════════════════════════════════════════════════════════

interface CorticalColumn {
  id: number;
  x: number;
  y: number;
  activity: number;
  tuning: number;
  selected: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface NeuralMapProps {
  coherence?: number;
}

export function NeuralMap({ coherence = 0.85 }: NeuralMapProps) {
  const [isLive, setIsLive] = useState(true);
  const [tick, setTick] = useState(0);
  const [layers, setLayers] = useState(CORTICAL_LAYERS);
  const [oscillations, setOscillations] = useState(OSCILLATION_BANDS);
  const [thalamus, setThalamus] = useState(THALAMIC_NUCLEI);
  const [columns, setColumns] = useState<CorticalColumn[]>([]);
  const [selectedColumn, setSelectedColumn] = useState<CorticalColumn | null>(
    null,
  );
  const [plasticity, setPlasticity] = useState<PlasticityState>({
    ltpActive: true,
    ltdActive: true,
    ltpMagnitude: 0.1,
    ltdMagnitude: 0.05,
    stdpWindow: 20,
    bcmThreshold: 0.5,
    homeostaticActive: true,
    totalLtpEvents: 0,
    totalLtdEvents: 0,
  });

  // Initialize cortical columns (8x8 grid)
  useEffect(() => {
    const cols: CorticalColumn[] = [];
    for (let y = 0; y < 8; y++) {
      for (let x = 0; x < 8; x++) {
        cols.push({
          id: y * 8 + x,
          x,
          y,
          activity: 0.3 + Math.random() * 0.5,
          tuning: Math.random(),
          selected: false,
        });
      }
    }
    setColumns(cols);
  }, []);

  // Live tick simulation
  // biome-ignore lint/correctness/useExhaustiveDependencies: coherence is a bias input read inside setOscillations closure — adding it to deps would reset the interval on every coherence tick unnecessarily
  useEffect(() => {
    if (!isLive) return;

    const interval = setInterval(() => {
      setTick((t) => t + 1);

      // Update layer activities
      setLayers((prev) =>
        prev.map((layer) => ({
          ...layer,
          activity: Math.max(
            0.1,
            Math.min(1, layer.activity + (Math.random() - 0.48) * 0.05),
          ),
        })),
      );

      // Update oscillation phases
      setOscillations((prev) =>
        prev.map((osc) => ({
          ...osc,
          phase:
            (osc.phase + 0.1 * Number.parseFloat(osc.frequency.split("-")[0])) %
            (2 * Math.PI),
          amplitude: Math.max(
            0.1,
            Math.min(1, osc.amplitude + (Math.random() - 0.5) * 0.02),
          ),
          coherence: Math.max(
            0.3,
            Math.min(
              1,
              // Bias oscillation coherence toward the organism's real coherence
              osc.coherence +
                (Math.random() - 0.48) * 0.02 +
                (coherence - osc.coherence) * 0.05,
            ),
          ),
        })),
      );

      // Update thalamic nuclei
      setThalamus((prev) =>
        prev.map((nuc) => ({
          ...nuc,
          firingRate: Math.max(
            0.2,
            Math.min(1, nuc.firingRate + (Math.random() - 0.48) * 0.03),
          ),
          gating: Math.max(
            0.2,
            Math.min(1, nuc.gating + (Math.random() - 0.48) * 0.02),
          ),
        })),
      );

      // Update cortical columns
      setColumns((prev) =>
        prev.map((col) => ({
          ...col,
          activity: Math.max(
            0.1,
            Math.min(1, col.activity + (Math.random() - 0.48) * 0.08),
          ),
        })),
      );

      // Update plasticity
      setPlasticity((prev) => ({
        ...prev,
        ltpMagnitude: Math.max(
          0.05,
          Math.min(0.2, prev.ltpMagnitude + (Math.random() - 0.5) * 0.01),
        ),
        ltdMagnitude: Math.max(
          0.02,
          Math.min(0.1, prev.ltdMagnitude + (Math.random() - 0.5) * 0.005),
        ),
        bcmThreshold: Math.max(
          0.3,
          Math.min(0.7, prev.bcmThreshold + (Math.random() - 0.5) * 0.01),
        ),
        totalLtpEvents: prev.totalLtpEvents + (Math.random() > 0.7 ? 1 : 0),
        totalLtdEvents: prev.totalLtdEvents + (Math.random() > 0.8 ? 1 : 0),
      }));
    }, 2000);

    return () => clearInterval(interval);
  }, [isLive]);

  const globalActivity =
    layers.reduce((a, l) => a + l.activity, 0) / layers.length;
  const dominantOscillation = oscillations.reduce((a, b) =>
    a.amplitude > b.amplitude ? a : b,
  );

  return (
    <ScrollArea className="flex-1 h-full bg-background">
      <div className="p-6 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Brain className="w-6 h-6 text-primary" />
            <div>
              <h1 className="text-xl font-bold text-foreground tracking-tight">
                NEURAL MAP
              </h1>
              <p className="text-xs text-muted-foreground">
                Cortical architecture visualization · 6 layers × 64 columns
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
                style={isLive ? { animationDuration: "2s" } : {}}
              />
              {isLive ? "LIVE" : "PAUSED"}
            </Button>
            <Badge variant="outline" className="text-[10px] font-mono">
              TICK #{tick}
            </Badge>
          </div>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {[
            {
              label: "Global Activity",
              value: `${(globalActivity * 100).toFixed(1)}%`,
              icon: Activity,
            },
            {
              label: "Dominant Band",
              value: dominantOscillation.name,
              icon: Waves,
            },
            {
              label: "LTP Events",
              value: plasticity.totalLtpEvents.toString(),
              icon: Zap,
            },
            {
              label: "BCM Threshold",
              value: plasticity.bcmThreshold.toFixed(3),
              icon: CircuitBoard,
            },
          ].map(({ label, value, icon: Icon }) => (
            <div
              key={label}
              className="bg-surface border border-border rounded-lg p-3"
            >
              <div className="flex items-center gap-1.5 mb-1">
                <Icon className="w-3 h-3 text-muted-foreground/50" />
                <span className="text-[9px] uppercase tracking-widest text-muted-foreground/50">
                  {label}
                </span>
              </div>
              <div className="text-lg font-bold font-mono text-foreground">
                {value}
              </div>
            </div>
          ))}
        </div>

        {/* 6-Layer Cortical Stack */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Layers className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              6-LAYER CORTICAL STACK
            </span>
          </div>
          <div className="space-y-2">
            {layers.map((layer) => (
              <div key={layer.id} className="flex items-center gap-3">
                <div className="w-10 text-[10px] font-mono font-bold text-muted-foreground">
                  {layer.id}
                </div>
                <div className="w-32 text-[10px] text-muted-foreground/60 truncate">
                  {layer.fullName}
                </div>
                <div className="flex-1">
                  <div
                    className="h-8 rounded transition-all duration-500"
                    style={{
                      width: `${layer.activity * 100}%`,
                      background: `linear-gradient(90deg, ${layer.color}, ${layer.color.replace(")", " / 0.5)")})`,
                      boxShadow:
                        layer.activity > 0.7
                          ? `0 0 12px ${layer.color.replace(")", " / 0.4)")}`
                          : "none",
                    }}
                  />
                </div>
                <div className="w-16 text-right">
                  <span className="text-[10px] font-mono text-primary">
                    {(layer.activity * 100).toFixed(1)}%
                  </span>
                </div>
                <div className="w-16 text-[9px] text-muted-foreground/40">
                  {layer.oscillationBand}
                </div>
              </div>
            ))}
          </div>
          <div className="mt-4 flex items-center gap-6 text-[9px] text-muted-foreground/40">
            <div className="flex items-center gap-2">
              <span className="text-emerald-400">●</span> Feedforward
            </div>
            <div className="flex items-center gap-2">
              <span className="text-amber-400">●</span> Feedback
            </div>
            <div className="flex items-center gap-2">
              <span className="text-blue-400">●</span> Lateral
            </div>
          </div>
        </div>

        {/* Oscillation Bands */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Waves className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              OSCILLATION BANDS
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
            {oscillations.map((osc) => (
              <div
                key={osc.name}
                className={`p-3 rounded-lg border transition-all ${
                  osc.name === dominantOscillation.name
                    ? "bg-primary/10 border-primary/30"
                    : "bg-surface-elevated border-border/50"
                }`}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[11px] font-semibold text-foreground">
                    {osc.name}
                  </span>
                  {osc.name === dominantOscillation.name && (
                    <span className="text-[8px] px-1 py-0.5 rounded bg-primary/20 text-primary">
                      DOMINANT
                    </span>
                  )}
                </div>
                <div className="text-[9px] text-muted-foreground/50 mb-2">
                  {osc.frequency}
                </div>
                <div className="space-y-1">
                  <div className="flex items-center justify-between text-[8px]">
                    <span className="text-muted-foreground/40">Amplitude</span>
                    <span className="text-primary">
                      {(osc.amplitude * 100).toFixed(0)}%
                    </span>
                  </div>
                  <Progress value={osc.amplitude * 100} className="h-1" />
                  <div className="flex items-center justify-between text-[8px]">
                    <span className="text-muted-foreground/40">Coherence</span>
                    <span className="text-primary">
                      {(osc.coherence * 100).toFixed(0)}%
                    </span>
                  </div>
                  <Progress value={osc.coherence * 100} className="h-1" />
                </div>
                <div className="text-[8px] text-muted-foreground/30 mt-2">
                  {osc.description}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Cortical Column Grid */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Cpu className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              CORTICAL COLUMN GRID · 8×8 = 64 COLUMNS
            </span>
          </div>
          <div
            className="grid gap-1"
            style={{ gridTemplateColumns: "repeat(8, 1fr)" }}
          >
            {columns.map((col) => (
              <button
                type="button"
                key={col.id}
                onClick={() => setSelectedColumn(col)}
                className={`aspect-square rounded border transition-all ${
                  selectedColumn?.id === col.id
                    ? "border-primary ring-2 ring-primary/30"
                    : "border-border/30 hover:border-border"
                }`}
                style={{
                  background: `oklch(${30 + col.activity * 35}% ${0.1 + col.activity * 0.08} 165 / ${0.3 + col.activity * 0.7})`,
                  boxShadow:
                    col.activity > 0.7
                      ? "0 0 8px oklch(60% 0.14 165 / 0.4)"
                      : "none",
                }}
                title={`Column ${col.id}: Activity ${(col.activity * 100).toFixed(1)}%`}
              />
            ))}
          </div>
          {selectedColumn && (
            <div className="mt-4 p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="flex items-center justify-between mb-2">
                <span className="text-[11px] font-semibold text-foreground">
                  Column {selectedColumn.id}
                </span>
                <span className="text-[10px] text-muted-foreground/50">
                  ({selectedColumn.x}, {selectedColumn.y})
                </span>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <div className="text-[9px] text-muted-foreground/50 mb-1">
                    Activity
                  </div>
                  <Progress
                    value={selectedColumn.activity * 100}
                    className="h-1.5"
                  />
                  <span className="text-[10px] text-primary">
                    {(selectedColumn.activity * 100).toFixed(1)}%
                  </span>
                </div>
                <div>
                  <div className="text-[9px] text-muted-foreground/50 mb-1">
                    Tuning
                  </div>
                  <Progress
                    value={selectedColumn.tuning * 100}
                    className="h-1.5"
                  />
                  <span className="text-[10px] text-muted-foreground">
                    {(selectedColumn.tuning * 100).toFixed(1)}%
                  </span>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Thalamocortical Loop */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <CircuitBoard className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              THALAMOCORTICAL LOOP · 6 NUCLEI
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
            {thalamus.map((nuc) => (
              <div
                key={nuc.name}
                className="p-3 rounded-lg bg-surface-elevated border border-border/50"
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-[11px] font-semibold text-foreground">
                    {nuc.name}
                  </span>
                  <span
                    className={`text-[8px] px-1 py-0.5 rounded ${
                      nuc.type === "Relay"
                        ? "bg-emerald-500/20 text-emerald-400"
                        : nuc.type === "Association"
                          ? "bg-blue-500/20 text-blue-400"
                          : "bg-amber-500/20 text-amber-400"
                    }`}
                  >
                    {nuc.type}
                  </span>
                </div>
                <div className="space-y-1">
                  <div className="flex items-center justify-between text-[8px]">
                    <span className="text-muted-foreground/40">Firing</span>
                    <span className="text-primary">
                      {(nuc.firingRate * 100).toFixed(0)}%
                    </span>
                  </div>
                  <Progress value={nuc.firingRate * 100} className="h-1" />
                  <div className="flex items-center justify-between text-[8px]">
                    <span className="text-muted-foreground/40">Gating</span>
                    <span className="text-muted-foreground">
                      {(nuc.gating * 100).toFixed(0)}%
                    </span>
                  </div>
                  <Progress value={nuc.gating * 100} className="h-1" />
                </div>
                <div className="mt-2 flex items-center gap-1">
                  {nuc.burstMode && (
                    <span className="text-[7px] px-1 py-0.5 rounded bg-amber-500/20 text-amber-400">
                      BURST
                    </span>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Plasticity Panel */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Sparkles className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              PLASTICITY MECHANISMS
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[10px] font-semibold text-foreground mb-2">
                LTP / LTD
              </div>
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-[9px] text-emerald-400">
                    LTP Active
                  </span>
                  <span className="text-[9px] font-mono text-foreground">
                    {plasticity.ltpMagnitude.toFixed(3)}
                  </span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-[9px] text-red-400">LTD Active</span>
                  <span className="text-[9px] font-mono text-foreground">
                    {plasticity.ltdMagnitude.toFixed(3)}
                  </span>
                </div>
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[10px] font-semibold text-foreground mb-2">
                STDP
              </div>
              <div className="text-[9px] text-muted-foreground/50">
                Window: {plasticity.stdpWindow}ms
              </div>
              <div className="text-[9px] text-muted-foreground/50">
                Asymmetry: 1.5x
              </div>
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[10px] font-semibold text-foreground mb-2">
                BCM
              </div>
              <div className="text-[9px] text-muted-foreground/50">
                Threshold: {plasticity.bcmThreshold.toFixed(3)}
              </div>
              <Progress
                value={plasticity.bcmThreshold * 100}
                className="h-1 mt-1"
              />
            </div>
            <div className="p-3 rounded-lg bg-surface-elevated border border-border/50">
              <div className="text-[10px] font-semibold text-foreground mb-2">
                Event Counts
              </div>
              <div className="flex items-center justify-between">
                <span className="text-[9px] text-emerald-400">
                  LTP: {plasticity.totalLtpEvents}
                </span>
                <span className="text-[9px] text-red-400">
                  LTD: {plasticity.totalLtdEvents}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center text-[10px] text-muted-foreground/30 pb-4">
          Neural Map · Cortical Engine · Owner: Alfredo Medina Hernandez
        </div>
      </div>
    </ScrollArea>
  );
}
