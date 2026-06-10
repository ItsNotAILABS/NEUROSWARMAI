import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Activity,
  ArrowLeft,
  Database,
  Globe,
  MessageSquare,
  RefreshCw,
  Server,
  Zap,
} from "lucide-react";
import { useEffect, useRef, useState } from "react";
import type { MockOrganism } from "../../data/organisms";
import { useActor } from "../../hooks/useActor";
import { useInternetIdentity } from "../../hooks/useInternetIdentity";

interface OrganismLiveViewerProps {
  organism: MockOrganism;
  onBack: () => void;
  onChat: (organism: MockOrganism) => void;
}

type DriveMode = "Execution" | "Exploration" | "Rest" | "Learning";

const DRIVE_COLORS: Record<DriveMode, string> = {
  Execution: "text-primary bg-primary/10 border-primary/30",
  Exploration: "text-amber-400 bg-amber-500/10 border-amber-500/30",
  Rest: "text-slate-400 bg-slate-500/10 border-slate-500/30",
  Learning: "text-blue-400 bg-blue-500/10 border-blue-500/30",
};

const NEURO_LABELS = [
  "FORMA-Flux",
  "Signal-Gate",
  "Coherence-Bind",
  "Resonance-Inhibit",
  "Activation-Amp",
  "Drive-Surge",
  "Memory-Anchor",
  "Bond-Field",
];

interface ShellView {
  coherence: number;
  formaBalance: number;
  activationCount: number;
  driveMode: DriveMode;
  hz: number[];
  neuroChem: number[];
}

function extractDriveMode(dm: unknown): DriveMode {
  if (dm && typeof dm === "object") {
    const key = Object.keys(dm)[0];
    if (
      key === "Execution" ||
      key === "Exploration" ||
      key === "Rest" ||
      key === "Learning"
    ) {
      return key as DriveMode;
    }
  }
  return "Execution";
}

// Pure local simulation — mirrors the backend tickShell math exactly.
// Runs when backend is unavailable (unauthenticated or organism not on-chain).
function simulateTick(prev: ShellView): ShellView {
  const lr = 0.005;
  const s0 = 0.75;
  const clipVal = (v: number) => Math.max(s0, Math.min(1.0, v));

  // Inner Hebbian layer (nodes 0-11, ring topology)
  const innerHz = prev.hz.slice(0, 12).map((v, i) => {
    const left = prev.hz[i === 0 ? 11 : i - 1];
    const right = prev.hz[i === 11 ? 0 : i + 1];
    const delta = lr * v * ((left + right) / 2);
    return clipVal(v + delta);
  });
  const innerMean = innerHz.reduce((a, b) => a + b, 0) / 12;

  // Expanded brain layer (nodes 12-25)
  const expandedHz = prev.hz.slice(12).map((v, j) => {
    const weight = Math.min(1.0, 0.5 + j * 0.04);
    const target = weight * innerMean + (1 - weight) * v;
    return clipVal(v + lr * (target - v));
  });

  const newHz = [...innerHz, ...expandedHz];
  const newCoherence = Math.max(
    s0,
    Math.min(1.0, newHz.reduce((a, b) => a + b, 0) / 26),
  );
  const streak = Math.min(2.0, 1.0 + prev.activationCount * 0.001);
  const formaMint = newCoherence * 2.0 * streak;

  const newDriveMode: DriveMode =
    newCoherence >= 0.92
      ? "Execution"
      : newCoherence >= 0.84
        ? "Exploration"
        : newCoherence >= 0.78
          ? "Learning"
          : "Rest";

  const newNeuroChem = prev.neuroChem.map((v, i) => {
    let boost = 0.001;
    if (newDriveMode === "Execution")
      boost = i < 3 ? 0.003 : i < 6 ? -0.001 : 0.001;
    else if (newDriveMode === "Exploration")
      boost = i >= 2 && i < 5 ? 0.003 : -0.001;
    else if (newDriveMode === "Learning")
      boost = i >= 4 && i < 7 ? 0.003 : -0.001;
    return Math.max(0, Math.min(1, v + boost));
  });

  return {
    coherence: newCoherence,
    formaBalance: prev.formaBalance + formaMint,
    activationCount: prev.activationCount + 1,
    driveMode: newDriveMode,
    hz: newHz,
    neuroChem: newNeuroChem,
  };
}

export function OrganismLiveViewer({
  organism,
  onBack,
  onChat,
}: OrganismLiveViewerProps) {
  const [shell, setShell] = useState<ShellView>({
    coherence: organism.coherence,
    formaBalance: organism.formaBalance,
    activationCount: organism.activationCount,
    driveMode: organism.driveMode,
    hz: [...organism.hz],
    neuroChem: [...organism.neuroChem],
  });
  const [tick, setTick] = useState(0);
  const [isPolling, setIsPolling] = useState(true);
  const [backendConnected, setBackendConnected] = useState(false);
  const { actor } = useActor();
  const { identity } = useInternetIdentity();
  const tickRef = useRef(0);

  useEffect(() => {
    if (!isPolling) return;

    async function doTick() {
      if (actor && identity) {
        try {
          // Fire real shell tick on-chain
          await (actor as any).tickOrganismShell(organism.id);
          // Read the updated state
          const result = await (actor as any).getOrganismState(organism.id);
          if (result && Array.isArray(result) && result.length > 0) {
            const s = result[0];
            setShell({
              coherence: s.coherence,
              formaBalance: s.formaBalance,
              activationCount: Number(s.activationCount),
              driveMode: extractDriveMode(s.driveMode),
              hz: Array.from(s.hz as number[]),
              neuroChem: Array.from(s.neuroChem as number[]),
            });
            setBackendConnected(true);
            tickRef.current += 1;
            setTick(tickRef.current);
            return;
          }
        } catch {
          // Fall through to local simulation
        }
      }
      // Fallback: run the same Hebbian math locally
      setShell((prev) => simulateTick(prev));
      setBackendConnected(false);
      tickRef.current += 1;
      setTick(tickRef.current);
    }

    doTick();
    const interval = setInterval(doTick, 3000);
    return () => clearInterval(interval);
  }, [actor, identity, isPolling, organism.id]);

  function classBadgeStyle() {
    if (organism.class === "Avatar")
      return "text-amber-400 bg-amber-500/15 border-amber-500/30";
    if (organism.class === "Entity")
      return "text-primary bg-primary/15 border-primary/30";
    return "text-slate-400 bg-slate-500/15 border-slate-500/30";
  }

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="flex items-center gap-3 px-6 py-4 border-b border-border shrink-0">
        <button
          type="button"
          data-ocid="viewer.cancel_button"
          onClick={onBack}
          className="text-muted-foreground hover:text-foreground transition-colors"
        >
          <ArrowLeft className="w-4 h-4" />
        </button>
        <div className="flex-1 flex items-center gap-3 flex-wrap">
          <span className="text-base font-bold text-foreground tracking-tight">
            {organism.name}
          </span>
          <span
            className={`text-[10px] font-semibold uppercase tracking-widest px-1.5 py-0.5 rounded border ${classBadgeStyle()}`}
          >
            {organism.class}
          </span>
          <span
            className={`text-[10px] font-semibold uppercase tracking-widest px-1.5 py-0.5 rounded border ${DRIVE_COLORS[shell.driveMode]}`}
          >
            {shell.driveMode}
          </span>
          {/* Backend/Simulated indicator */}
          <div
            className={`flex items-center gap-1 px-1.5 py-0.5 rounded border text-[9px] font-semibold uppercase tracking-widest ${
              backendConnected
                ? "text-emerald-400 border-emerald-500/30 bg-emerald-500/5"
                : "text-muted-foreground/40 border-border/30"
            }`}
          >
            <Server className="w-2.5 h-2.5" />
            {backendConnected ? "ON-CHAIN" : "SIMULATED"}
          </div>
        </div>
        <div className="flex items-center gap-2">
          {/* WEB REACH badge */}
          <div className="flex items-center gap-1.5 px-2 py-1 rounded border border-emerald-500/30 bg-emerald-500/5">
            <Globe className="w-3 h-3 text-emerald-400" />
            <span className="text-[10px] font-semibold uppercase tracking-widest text-emerald-400">
              WEB REACH
            </span>
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
          </div>
          <button
            type="button"
            onClick={() => setIsPolling((v) => !v)}
            className={`flex items-center gap-1.5 text-[10px] px-2 py-1 rounded border transition-colors ${
              isPolling
                ? "text-primary border-primary/30 bg-primary/5"
                : "text-muted-foreground border-border"
            }`}
          >
            <RefreshCw
              className={`w-3 h-3 ${isPolling ? "animate-spin" : ""}`}
              style={isPolling ? { animationDuration: "3s" } : {}}
            />
            {isPolling ? "LIVE" : "PAUSED"}
          </button>
          <Button
            size="sm"
            data-ocid="viewer.primary_button"
            onClick={() => onChat(organism)}
            className="h-7 text-[11px] bg-primary text-primary-foreground hover:bg-primary/90"
          >
            <MessageSquare className="w-3 h-3 mr-1" />
            CHAT
          </Button>
        </div>
      </div>

      <ScrollArea className="flex-1">
        <div className="p-6 space-y-6">
          {/* Genesis hash */}
          <div className="font-mono text-[10px] text-muted-foreground/40">
            GENESIS HASH · {organism.genesisHash}
          </div>

          {/* Key metrics */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {[
              {
                label: "Coherence",
                value: `${(shell.coherence * 100).toFixed(3)}%`,
                icon: Activity,
                accent: true,
              },
              {
                label: "FORMA Balance",
                value: `${shell.formaBalance.toFixed(2)}`,
                icon: Database,
                accent: false,
              },
              {
                label: "Activations",
                value: `${shell.activationCount}`,
                icon: Zap,
                accent: false,
              },
              {
                label: "Tick",
                value: `#${tick}`,
                icon: RefreshCw,
                accent: false,
              },
            ].map(({ label, value, icon: Icon, accent }) => (
              <div
                key={label}
                className="bg-surface border border-border rounded-lg p-3"
              >
                <div className="flex items-center gap-1.5 mb-1.5">
                  <Icon
                    className={`w-3 h-3 ${
                      accent ? "text-primary" : "text-muted-foreground/50"
                    }`}
                  />
                  <span className="text-[10px] uppercase tracking-widest text-muted-foreground/50">
                    {label}
                  </span>
                </div>
                <div
                  className={`text-xl font-bold font-mono ${
                    accent ? "text-primary" : "text-foreground"
                  }`}
                >
                  {value}
                </div>
              </div>
            ))}
          </div>

          {/* Coherence bar */}
          <div>
            <div className="flex items-center justify-between mb-2">
              <span className="text-[10px] uppercase tracking-widest text-muted-foreground/50">
                Coherence Score
              </span>
              <span className="text-xs font-mono text-primary">
                {(shell.coherence * 100).toFixed(3)}% / S₀=75.000%
              </span>
            </div>
            <Progress
              value={shell.coherence * 100}
              className="h-2 bg-surface-elevated"
            />
          </div>

          {/* Hz Node Grid */}
          <div>
            <div className="flex items-center justify-between mb-3">
              <span className="text-[10px] uppercase tracking-widest text-muted-foreground/50">
                Hz Node Grid · 26 Nodes
              </span>
              <span className="text-[9px] font-mono text-muted-foreground/30">
                Inner Hebbian (N01–N12) + Expanded Brain (N13–N26)
              </span>
            </div>
            <div
              className="grid gap-2"
              style={{ gridTemplateColumns: "repeat(6, 1fr)" }}
            >
              {shell.hz.map((val, i) => {
                const active = val > 0.82;
                const isInner = i < 12;
                const opacity = 0.2 + val * 0.8;
                const nodeLabel = `N${String(i + 1).padStart(2, "0")}`;
                return (
                  <div
                    key={nodeLabel}
                    className="flex flex-col items-center gap-0.5"
                  >
                    <div
                      className="w-full aspect-square rounded-full border transition-all duration-500"
                      style={{
                        opacity,
                        background: active
                          ? isInner
                            ? `oklch(62% 0.145 165 / ${val})`
                            : `oklch(58% 0.13 200 / ${val})`
                          : `oklch(30% 0 0 / ${val * 0.8})`,
                        borderColor: active
                          ? isInner
                            ? "oklch(62% 0.145 165 / 0.5)"
                            : "oklch(58% 0.13 200 / 0.5)"
                          : "oklch(25% 0 0 / 0.6)",
                        boxShadow: active
                          ? `0 0 ${Math.round(val * 12)}px ${
                              isInner
                                ? "oklch(62% 0.145 165 / 0.4)"
                                : "oklch(58% 0.13 200 / 0.3)"
                            }`
                          : "none",
                      }}
                      title={`${nodeLabel}: ${val.toFixed(4)} | ${
                        isInner ? "Inner Hebbian" : "Expanded Brain"
                      }`}
                    />
                    <span className="text-[8px] font-mono text-muted-foreground/30 leading-none">
                      {nodeLabel}
                    </span>
                  </div>
                );
              })}
            </div>
            {/* Legend */}
            <div className="mt-3 flex items-center gap-4">
              <span className="text-[9px] font-mono text-muted-foreground/30">
                5kHz → 10MHz | S₀ floor: 0.75
              </span>
              <div className="flex items-center gap-3">
                <div className="flex items-center gap-1">
                  <div
                    className="w-2 h-2 rounded-full"
                    style={{ background: "oklch(62% 0.145 165 / 0.8)" }}
                  />
                  <span className="text-[8px] text-muted-foreground/40">
                    Inner (Hebbian)
                  </span>
                </div>
                <div className="flex items-center gap-1">
                  <div
                    className="w-2 h-2 rounded-full"
                    style={{ background: "oklch(58% 0.13 200 / 0.8)" }}
                  />
                  <span className="text-[8px] text-muted-foreground/40">
                    Expanded (Brain)
                  </span>
                </div>
                <div className="flex items-center gap-1">
                  <div className="w-2 h-2 rounded-full bg-zinc-700" />
                  <span className="text-[8px] text-muted-foreground/40">
                    Idle
                  </span>
                </div>
              </div>
            </div>
          </div>

          {/* Neurochemical bars */}
          <div>
            <div className="text-[10px] uppercase tracking-widest text-muted-foreground/50 mb-3">
              Sovereign Substrate · 8 Channels
            </div>
            <div className="space-y-2">
              {shell.neuroChem.map((val, i) => (
                <div key={NEURO_LABELS[i]} className="flex items-center gap-3">
                  <span className="text-[10px] font-mono text-muted-foreground/50 w-36 shrink-0">
                    {NEURO_LABELS[i]}
                  </span>
                  <div className="flex-1 h-1.5 bg-surface-elevated rounded-full overflow-hidden">
                    <div
                      className="h-full rounded-full transition-all duration-700"
                      style={{
                        width: `${val * 100}%`,
                        background: `oklch(${40 + val * 30}% 0.145 165)`,
                      }}
                    />
                  </div>
                  <span className="text-[10px] font-mono text-muted-foreground/40 w-10 text-right">
                    {(val * 100).toFixed(1)}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* FORMA economy */}
          <div className="bg-surface border border-border rounded-lg p-4">
            <div className="text-[10px] uppercase tracking-widest text-muted-foreground/50 mb-2">
              FORMA Economy
            </div>
            <div className="grid grid-cols-3 gap-4">
              <div>
                <div className="text-[10px] text-muted-foreground/40 mb-1">
                  Mint Rate
                </div>
                <div className="text-sm font-bold font-mono text-primary">
                  +
                  {(
                    shell.coherence *
                    2 *
                    Math.min(2, 1 + shell.activationCount * 0.001)
                  ).toFixed(4)}
                  /tick
                </div>
              </div>
              <div>
                <div className="text-[10px] text-muted-foreground/40 mb-1">
                  Balance
                </div>
                <div className="text-sm font-bold font-mono text-foreground">
                  {shell.formaBalance.toFixed(2)}
                </div>
              </div>
              <div>
                <div className="text-[10px] text-muted-foreground/40 mb-1">
                  Streak Bonus
                </div>
                <div className="text-sm font-bold font-mono text-amber-400">
                  {Math.min(2, 1 + shell.activationCount * 0.001).toFixed(3)}x
                </div>
              </div>
            </div>
          </div>

          {/* Specializations */}
          <div>
            <div className="text-[10px] uppercase tracking-widest text-muted-foreground/50 mb-2">
              Specialization Stack
            </div>
            <div className="flex flex-wrap gap-1.5">
              {organism.specializations.map((s) => (
                <span
                  key={s}
                  className="text-[11px] px-2 py-1 rounded bg-primary/10 text-primary border border-primary/20"
                >
                  {s}
                </span>
              ))}
            </div>
          </div>
        </div>
      </ScrollArea>
    </div>
  );
}
