// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEMORY TIMELINE — Episodic / Semantic / Working Memory Visualization
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Archive,
  BookOpen,
  Brain,
  Clock,
  Database,
  Eye,
  FlaskConical,
  History,
  Layers,
  Lightbulb,
  RefreshCw,
  Sparkles,
  Target,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════
// MEMORY TRACE
// ═══════════════════════════════════════════════════════════════════════════════

interface MemoryTrace {
  id: string;
  type:
    | "episodic"
    | "semantic"
    | "procedural"
    | "working"
    | "implicit"
    | "flash"
    | "prospective";
  content: string;
  strength: number;
  formationBeat: number;
  lastAccessBeat: number;
  accessCount: number;
  decay: number;
  phase: number; // Phase at formation
  coherenceAtFormation: number;
  linkedTraces: string[];
  tags: string[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// MEMORY BANK
// ═══════════════════════════════════════════════════════════════════════════════

interface MemoryBank {
  type: string;
  icon: React.ElementType;
  description: string;
  capacity: string;
  traces: MemoryTrace[];
  totalStrength: number;
  averageDecay: number;
  color: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// POWER-LAW DECAY
// ═══════════════════════════════════════════════════════════════════════════════

function computePowerLawStrength(
  m0: number,
  formationBeat: number,
  currentBeat: number,
  alpha = 0.5,
): number {
  const dt = Math.max(1, currentBeat - formationBeat + 1);
  return m0 * dt ** -alpha;
}

// ═══════════════════════════════════════════════════════════════════════════════
// GENERATE MOCK TRACES
// ═══════════════════════════════════════════════════════════════════════════════

function generateMockTraces(currentBeat: number): MemoryTrace[] {
  const traces: MemoryTrace[] = [];

  // Episodic memories
  const episodicContents = [
    "User initiated deep analysis on Q3 financial projections",
    "Successfully generated campaign strategy for enterprise launch",
    "Encountered coherence spike during KORE stabilization",
    "First organism-to-organism communication established",
    "Completed full doctrine alignment verification",
    "Achieved 98.7% coherence during peak execution",
    "Memory consolidation cycle completed at dawn",
  ];
  episodicContents.forEach((content, i) => {
    traces.push({
      id: `ep-${i}`,
      type: "episodic",
      content,
      strength: computePowerLawStrength(
        1.0,
        currentBeat - (i + 1) * 100,
        currentBeat,
      ),
      formationBeat: currentBeat - (i + 1) * 100,
      lastAccessBeat: currentBeat - i * 10,
      accessCount: Math.floor(Math.random() * 20) + 1,
      decay: 0.5,
      phase: Math.random() * 2 * Math.PI,
      coherenceAtFormation: 0.8 + Math.random() * 0.15,
      linkedTraces: [],
      tags: ["event", "milestone"],
    });
  });

  // Semantic memories
  const semanticContents = [
    "FORMA: Token minted per coherence × base × streak",
    "S₀ = 0.75: The eternal floor, the root constant",
    "K_f measures cross-substrate phase alignment",
    "Jasmine's Law: Spherical helix expansion r(t)=r₀e^(st)",
    "VAEL escalates frequency under threat",
    "KORE pulls all phases toward stability",
    "Elephant memory: 2048 entries, no expiry",
    "Bee sacrifice: Emergency coherence boost",
  ];
  semanticContents.forEach((content, i) => {
    traces.push({
      id: `sem-${i}`,
      type: "semantic",
      content,
      strength: 0.9 + Math.random() * 0.1, // Semantic decays slower
      formationBeat: currentBeat - (i + 1) * 500,
      lastAccessBeat: currentBeat - Math.floor(Math.random() * 50),
      accessCount: Math.floor(Math.random() * 100) + 50,
      decay: 0.3,
      phase: Math.random() * 2 * Math.PI,
      coherenceAtFormation: 0.85 + Math.random() * 0.1,
      linkedTraces: [],
      tags: ["doctrine", "equation"],
    });
  });

  // Procedural memories
  const proceduralContents = [
    "Hebbian learning: Δw = lr × pre × post",
    "Phase advance: φ(t+1) = φ(t) + 2π·f/ν",
    "Coherence update: C = λC + (1-λ)S - μD + ρK",
    "STDP: Pre-before-post → LTP, Post-before-pre → LTD",
  ];
  proceduralContents.forEach((content, i) => {
    traces.push({
      id: `proc-${i}`,
      type: "procedural",
      content,
      strength: 0.95, // Procedural rarely decays
      formationBeat: currentBeat - (i + 1) * 1000,
      lastAccessBeat: currentBeat,
      accessCount: Math.floor(Math.random() * 1000) + 500,
      decay: 0.1,
      phase: Math.random() * 2 * Math.PI,
      coherenceAtFormation: 0.9,
      linkedTraces: [],
      tags: ["skill", "algorithm"],
    });
  });

  // Working memory (limited, recent)
  const workingContents = [
    "Current task: Expand frontend components",
    "Active context: Genesis organism visualization",
    "Pending: Memory timeline implementation",
  ];
  workingContents.forEach((content, i) => {
    traces.push({
      id: `work-${i}`,
      type: "working",
      content,
      strength: 0.99,
      formationBeat: currentBeat - i * 2,
      lastAccessBeat: currentBeat,
      accessCount: i + 1,
      decay: 0.8, // Working memory decays fast
      phase: Math.random() * 2 * Math.PI,
      coherenceAtFormation: 0.88,
      linkedTraces: [],
      tags: ["active", "now"],
    });
  });

  // Flash memories (high emotional salience)
  traces.push({
    id: "flash-1",
    type: "flash",
    content: "Genesis moment: First coherent thought emerged",
    strength: 1.0,
    formationBeat: 0,
    lastAccessBeat: currentBeat - 100,
    accessCount: 50,
    decay: 0.05, // Flash memories barely decay
    phase: 0,
    coherenceAtFormation: 0.75,
    linkedTraces: [],
    tags: ["origin", "sacred"],
  });

  // Prospective memories
  traces.push({
    id: "pros-1",
    type: "prospective",
    content: "Future: Complete full organism deployment on ICP",
    strength: 0.85,
    formationBeat: currentBeat - 200,
    lastAccessBeat: currentBeat - 10,
    accessCount: 15,
    decay: 0.4,
    phase: Math.random() * 2 * Math.PI,
    coherenceAtFormation: 0.82,
    linkedTraces: [],
    tags: ["goal", "future"],
  });

  return traces;
}

// ═══════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function MemoryTimeline() {
  const [isLive, setIsLive] = useState(true);
  const [currentBeat, setCurrentBeat] = useState(10000);
  const [traces, setTraces] = useState<MemoryTrace[]>([]);
  const [selectedType, setSelectedType] = useState<string | null>(null);
  const [selectedTrace, setSelectedTrace] = useState<MemoryTrace | null>(null);
  const [_viewMode, _setViewMode] = useState<"list" | "timeline">("list");

  // Initialize and tick
  // biome-ignore lint/correctness/useExhaustiveDependencies: intentional — only initialize once on mount
  useEffect(() => {
    setTraces(generateMockTraces(currentBeat));
  }, []);

  useEffect(() => {
    if (!isLive) return;

    const interval = setInterval(() => {
      setCurrentBeat((b) => b + 1);

      // Recalculate trace strengths with power-law decay
      setTraces((prev) =>
        prev.map((trace) => ({
          ...trace,
          strength:
            trace.type === "working"
              ? Math.max(0.1, trace.strength - 0.01) // Working memory decays linearly
              : computePowerLawStrength(
                  1.0,
                  trace.formationBeat,
                  currentBeat + 1,
                  trace.decay,
                ),
        })),
      );
    }, 3000);

    return () => clearInterval(interval);
  }, [isLive, currentBeat]);

  // Group traces by type
  const memoryBanks: MemoryBank[] = [
    {
      type: "episodic",
      icon: History,
      description: "Events and experiences",
      capacity: "Unbounded",
      traces: traces.filter((t) => t.type === "episodic"),
      totalStrength: 0,
      averageDecay: 0.5,
      color: "oklch(60% 0.15 200)",
    },
    {
      type: "semantic",
      icon: BookOpen,
      description: "Facts and knowledge",
      capacity: "Unbounded",
      traces: traces.filter((t) => t.type === "semantic"),
      totalStrength: 0,
      averageDecay: 0.3,
      color: "oklch(62% 0.14 165)",
    },
    {
      type: "procedural",
      icon: FlaskConical,
      description: "Skills and algorithms",
      capacity: "Unbounded",
      traces: traces.filter((t) => t.type === "procedural"),
      totalStrength: 0,
      averageDecay: 0.1,
      color: "oklch(55% 0.13 280)",
    },
    {
      type: "working",
      icon: Brain,
      description: "Active maintenance",
      capacity: "4 slots",
      traces: traces.filter((t) => t.type === "working"),
      totalStrength: 0,
      averageDecay: 0.8,
      color: "oklch(65% 0.16 45)",
    },
    {
      type: "flash",
      icon: Zap,
      description: "High-salience moments",
      capacity: "Unbounded",
      traces: traces.filter((t) => t.type === "flash"),
      totalStrength: 0,
      averageDecay: 0.05,
      color: "oklch(70% 0.18 60)",
    },
    {
      type: "prospective",
      icon: Target,
      description: "Future intentions",
      capacity: "Unbounded",
      traces: traces.filter((t) => t.type === "prospective"),
      totalStrength: 0,
      averageDecay: 0.4,
      color: "oklch(58% 0.12 320)",
    },
  ].map((bank) => ({
    ...bank,
    totalStrength: bank.traces.reduce((a, t) => a + t.strength, 0),
  }));

  const totalTraces = traces.length;
  const totalStrength = traces.reduce((a, t) => a + t.strength, 0);
  const filteredTraces = selectedType
    ? traces.filter((t) => t.type === selectedType)
    : traces;

  const typeColors: Record<string, string> = {
    episodic: "bg-blue-500/20 text-blue-400 border-blue-500/30",
    semantic: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30",
    procedural: "bg-purple-500/20 text-purple-400 border-purple-500/30",
    working: "bg-amber-500/20 text-amber-400 border-amber-500/30",
    flash: "bg-orange-500/20 text-orange-400 border-orange-500/30",
    prospective: "bg-pink-500/20 text-pink-400 border-pink-500/30",
    implicit: "bg-slate-500/20 text-slate-400 border-slate-500/30",
  };

  return (
    <ScrollArea className="flex-1 h-full bg-background">
      <div className="p-6 space-y-6">
        {/* Header */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Database className="w-6 h-6 text-primary" />
            <div>
              <h1 className="text-xl font-bold text-foreground tracking-tight">
                MEMORY TIMELINE
              </h1>
              <p className="text-xs text-muted-foreground">
                Power-law decay · NO trace cap · 7 memory types
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
              BEAT #{currentBeat}
            </Badge>
          </div>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {[
            {
              label: "Total Traces",
              value: totalTraces.toLocaleString(),
              icon: Archive,
            },
            {
              label: "Total Strength",
              value: totalStrength.toFixed(2),
              icon: Sparkles,
            },
            {
              label: "Working Slots",
              value: `${memoryBanks.find((b) => b.type === "working")?.traces.length || 0}/4`,
              icon: Brain,
            },
            { label: "Memory Banks", value: "7 Active", icon: Layers },
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

        {/* Memory Banks Overview */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-4">
            <Layers className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              7 MEMORY BANKS
            </span>
            <span className="text-[9px] text-muted-foreground/40">
              — NO trace cap per Medina Doctrine
            </span>
          </div>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-3">
            {memoryBanks.map((bank) => {
              const Icon = bank.icon;
              const isSelected = selectedType === bank.type;
              return (
                <button
                  type="button"
                  key={bank.type}
                  onClick={() => setSelectedType(isSelected ? null : bank.type)}
                  className={`p-3 rounded-lg border text-left transition-all ${
                    isSelected
                      ? "bg-primary/10 border-primary/30"
                      : "bg-surface-elevated border-border/50 hover:border-border"
                  }`}
                >
                  <div className="flex items-center gap-2 mb-2">
                    <Icon
                      className={`w-4 h-4 ${isSelected ? "text-primary" : "text-muted-foreground/50"}`}
                    />
                    <span className="text-[11px] font-semibold text-foreground uppercase">
                      {bank.type}
                    </span>
                  </div>
                  <div className="text-[9px] text-muted-foreground/50 mb-2">
                    {bank.description}
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] text-primary font-mono">
                      {bank.traces.length} traces
                    </span>
                    <span className="text-[9px] text-muted-foreground/40">
                      {bank.capacity}
                    </span>
                  </div>
                  <Progress
                    value={(bank.totalStrength / bank.traces.length) * 100 || 0}
                    className="h-1 mt-2"
                  />
                </button>
              );
            })}
          </div>
        </div>

        {/* Power-Law Decay Formula */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center gap-2 mb-3">
            <FlaskConical className="w-4 h-4 text-primary" />
            <span className="text-xs font-semibold text-foreground">
              POWER-LAW MEMORY DECAY
            </span>
          </div>
          <div className="font-mono text-sm text-primary bg-background/50 p-3 rounded border border-border/30">
            W(t) = Σᵢ M₀ · (H(t) - H_formation_i + 1)^(-α)
          </div>
          <div className="mt-2 text-[10px] text-muted-foreground/50">
            Where α ∈ [0.05, 0.8] varies by memory type. Lower α = slower decay.
            <br />
            Flash memories: α=0.05 | Semantic: α=0.3 | Working: α=0.8
          </div>
        </div>

        {/* Trace List */}
        <div className="bg-surface border border-border rounded-lg p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <Clock className="w-4 h-4 text-primary" />
              <span className="text-xs font-semibold text-foreground">
                MEMORY TRACES{" "}
                {selectedType && `· ${selectedType.toUpperCase()}`}
              </span>
            </div>
            <span className="text-[10px] text-muted-foreground/40">
              {filteredTraces.length} traces
            </span>
          </div>
          <div className="space-y-2 max-h-[500px] overflow-y-auto">
            {filteredTraces
              .sort((a, b) => b.strength - a.strength)
              .map((trace) => (
                <button
                  type="button"
                  key={trace.id}
                  onClick={() => setSelectedTrace(trace)}
                  className={`w-full p-3 rounded-lg border text-left transition-all ${
                    selectedTrace?.id === trace.id
                      ? "bg-primary/10 border-primary/30"
                      : "bg-surface-elevated border-border/50 hover:border-border"
                  }`}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 mb-1">
                        <span
                          className={`text-[9px] px-1.5 py-0.5 rounded border ${typeColors[trace.type]}`}
                        >
                          {trace.type}
                        </span>
                        <span className="text-[9px] text-muted-foreground/40">
                          Beat #{trace.formationBeat}
                        </span>
                      </div>
                      <div className="text-[11px] text-foreground truncate">
                        {trace.content}
                      </div>
                      <div className="flex items-center gap-3 mt-1">
                        {trace.tags.map((tag) => (
                          <span
                            key={tag}
                            className="text-[8px] text-muted-foreground/30"
                          >
                            #{tag}
                          </span>
                        ))}
                      </div>
                    </div>
                    <div className="text-right shrink-0">
                      <div className="text-[11px] font-mono text-primary">
                        {(trace.strength * 100).toFixed(1)}%
                      </div>
                      <div className="text-[9px] text-muted-foreground/40">
                        {trace.accessCount} accesses
                      </div>
                    </div>
                  </div>
                  <Progress
                    value={trace.strength * 100}
                    className="h-1 mt-2"
                    style={
                      {
                        "--progress-color": typeColors[trace.type]?.includes(
                          "blue",
                        )
                          ? "oklch(60% 0.15 200)"
                          : typeColors[trace.type]?.includes("emerald")
                            ? "oklch(62% 0.14 165)"
                            : "oklch(62% 0.145 165)",
                      } as React.CSSProperties
                    }
                  />
                </button>
              ))}
          </div>
        </div>

        {/* Selected Trace Detail */}
        {selectedTrace && (
          <div className="bg-surface border border-primary/30 rounded-lg p-4">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Eye className="w-4 h-4 text-primary" />
                <span className="text-xs font-semibold text-foreground">
                  TRACE DETAIL
                </span>
              </div>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setSelectedTrace(null)}
              >
                Close
              </Button>
            </div>
            <div className="space-y-4">
              <div>
                <span className="text-[9px] text-muted-foreground/50 uppercase">
                  Content
                </span>
                <div className="text-sm text-foreground mt-1">
                  {selectedTrace.content}
                </div>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Type
                  </span>
                  <div
                    className={`text-[11px] mt-1 px-2 py-1 rounded inline-block ${typeColors[selectedTrace.type]}`}
                  >
                    {selectedTrace.type}
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Strength
                  </span>
                  <div className="text-lg font-mono text-primary">
                    {(selectedTrace.strength * 100).toFixed(3)}%
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Formed At
                  </span>
                  <div className="text-sm font-mono text-foreground">
                    Beat #{selectedTrace.formationBeat}
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Age
                  </span>
                  <div className="text-sm font-mono text-foreground">
                    {currentBeat - selectedTrace.formationBeat} beats
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Decay Rate (α)
                  </span>
                  <div className="text-sm font-mono text-foreground">
                    {selectedTrace.decay}
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Access Count
                  </span>
                  <div className="text-sm font-mono text-foreground">
                    {selectedTrace.accessCount}
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Coherence at Formation
                  </span>
                  <div className="text-sm font-mono text-primary">
                    {(selectedTrace.coherenceAtFormation * 100).toFixed(2)}%
                  </div>
                </div>
                <div>
                  <span className="text-[9px] text-muted-foreground/50">
                    Phase at Formation
                  </span>
                  <div className="text-sm font-mono text-foreground">
                    {selectedTrace.phase.toFixed(4)} rad
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Footer */}
        <div className="text-center text-[10px] text-muted-foreground/30 pb-4">
          Memory Timeline · Power-Law Decay · Owner: Alfredo Medina Hernandez
        </div>
      </div>
    </ScrollArea>
  );
}
