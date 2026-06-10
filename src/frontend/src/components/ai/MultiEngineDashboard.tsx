// ══════════════════════════════════════════════════════════════════════════════
// MULTI-ENGINE DASHBOARD — Full Engine Fleet Monitoring & Control
// Real-time visualization of all 27 engines across 6 categories with
// load graphs, route maps, and execution metrics.
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// ══════════════════════════════════════════════════════════════════════════════

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Activity,
  ArrowRight,
  Brain,
  Cpu,
  Gauge,
  Network,
  Power,
  Shield,
  Sparkles,
  TrendingUp,
} from "lucide-react";
import { useEffect, useState } from "react";
import {
  type EngineCategory,
  type EngineNode,
  type EngineRoute,
  type MultiEngineState,
  getActiveEngines,
  getEnginesByCategory,
  initMultiEngineState,
  tickMultiEngine,
} from "../../data/multiEngineOrchestrator";

// ─── Constants ───────────────────────────────────────────────────────────────

const CATEGORY_ICONS: Record<EngineCategory, typeof Brain> = {
  cognitive: Brain,
  intelligence: Sparkles,
  organism: Activity,
  pipeline: Network,
  governance: Shield,
  substrate: Cpu,
};

const CATEGORY_COLORS: Record<EngineCategory, string> = {
  cognitive: "#a78bfa",
  intelligence: "#22d3ee",
  organism: "#34d399",
  pipeline: "#fbbf24",
  governance: "#f87171",
  substrate: "#818cf8",
};

interface MultiEngineDashboardProps {
  className?: string;
}

// ─── Component ───────────────────────────────────────────────────────────────

export function MultiEngineDashboard({ className }: MultiEngineDashboardProps) {
  const [state, setState] = useState<MultiEngineState>(initMultiEngineState);
  const [loadHistory, setLoadHistory] = useState<number[]>([]);

  // PHI-beat tick
  useEffect(() => {
    const interval = setInterval(() => {
      setState((prev) => {
        const next = tickMultiEngine(prev);
        setLoadHistory((h) => [...h.slice(-30), next.avgSystemLoad]);
        return next;
      });
    }, 873);
    return () => clearInterval(interval);
  }, []);

  const activeEngines = getActiveEngines(state);
  const enginesByCategory = getEnginesByCategory(state);

  return (
    <div className={`flex flex-col h-full bg-background ${className || ""}`}>
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border">
        <div className="flex items-center gap-2">
          <Gauge className="w-5 h-5 text-cyan-400" />
          <h2 className="text-sm font-bold text-foreground">Multi-Engine Dashboard</h2>
        </div>
        <div className="flex items-center gap-2">
          <Badge variant="outline" className="text-xs font-mono text-green-400">
            <Power className="w-3 h-3 mr-1" />
            {state.engines.length} ENGINES
          </Badge>
        </div>
      </div>

      <ScrollArea className="flex-1">
        <div className="p-4 space-y-4">
          {/* ─── System Overview Cards ──────────────────────────────────── */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-2">
            <MetricCard
              label="Active Engines"
              value={`${activeEngines.length}/${state.engines.length}`}
              icon={<Cpu className="w-3.5 h-3.5 text-cyan-400" />}
            />
            <MetricCard
              label="System Load"
              value={`${(state.avgSystemLoad * 100).toFixed(1)}%`}
              icon={<Gauge className="w-3.5 h-3.5 text-yellow-400" />}
            />
            <MetricCard
              label="φ Coherence"
              value={state.phiCoherence.toFixed(4)}
              icon={<Sparkles className="w-3.5 h-3.5 text-purple-400" />}
            />
            <MetricCard
              label="Executions"
              value={state.totalExecutions.toLocaleString()}
              icon={<TrendingUp className="w-3.5 h-3.5 text-green-400" />}
            />
          </div>

          {/* ─── Load Sparkline ─────────────────────────────────────────── */}
          <Card className="bg-muted/30 border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-xs flex items-center gap-2">
                <Activity className="w-3.5 h-3.5 text-cyan-400" />
                System Load (30 beats)
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="flex items-end gap-[2px] h-12">
                {loadHistory.map((load, i) => (
                  <div
                    key={i}
                    className="flex-1 rounded-t transition-all"
                    style={{
                      height: `${Math.max(2, load * 100)}%`,
                      background: load > 0.7 ? "#f87171" : load > 0.4 ? "#fbbf24" : "#22d3ee",
                      opacity: 0.5 + (i / loadHistory.length) * 0.5,
                    }}
                  />
                ))}
                {loadHistory.length === 0 && (
                  <span className="text-[10px] text-muted-foreground font-mono">Collecting data...</span>
                )}
              </div>
            </CardContent>
          </Card>

          {/* ─── Engine Categories ──────────────────────────────────────── */}
          {(Object.entries(enginesByCategory) as [EngineCategory, EngineNode[]][]).map(
            ([category, engines]) => {
              const Icon = CATEGORY_ICONS[category];
              const color = CATEGORY_COLORS[category];
              const avgLoad = engines.reduce((a, e) => a + e.load, 0) / engines.length;
              const activeCount = engines.filter(
                (e) => e.status === "active" || e.status === "processing"
              ).length;

              return (
                <Card key={category} className="bg-muted/30 border-border">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-xs flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <Icon className="w-3.5 h-3.5" style={{ color }} />
                        <span className="uppercase tracking-wider">{category}</span>
                        <span className="text-muted-foreground font-normal">
                          ({engines.length} engines)
                        </span>
                      </div>
                      <div className="flex items-center gap-2">
                        <Badge variant="outline" className="text-[9px]">
                          {activeCount} active
                        </Badge>
                        <Badge variant="outline" className="text-[9px]">
                          {(avgLoad * 100).toFixed(0)}% load
                        </Badge>
                      </div>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-1.5">
                      {engines.map((engine) => (
                        <EngineRow key={engine.id} engine={engine} color={color} />
                      ))}
                    </div>
                  </CardContent>
                </Card>
              );
            }
          )}

          {/* ─── Active Routes ──────────────────────────────────────────── */}
          <Card className="bg-muted/30 border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-xs flex items-center gap-2">
                <Network className="w-3.5 h-3.5 text-cyan-400" />
                Active Routes ({state.routes.filter((r) => r.active).length})
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-1">
                {state.routes
                  .filter((r) => r.active)
                  .map((route) => (
                    <RouteRow key={`${route.sourceId}-${route.targetId}`} route={route} engines={state.engines} />
                  ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </ScrollArea>
    </div>
  );
}

// ─── Sub-Components ──────────────────────────────────────────────────────────

function MetricCard({ label, value, icon }: { label: string; value: string; icon: React.ReactNode }) {
  return (
    <Card className="bg-muted/30 border-border">
      <CardContent className="p-3">
        <div className="flex items-center gap-2">
          {icon}
          <div>
            <div className="text-[10px] text-muted-foreground">{label}</div>
            <div className="text-sm font-bold font-mono text-foreground">{value}</div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

function EngineRow({ engine, color }: { engine: EngineNode; color: string }) {
  const statusEmoji: Record<string, string> = {
    idle: "○",
    active: "●",
    processing: "◉",
    error: "✗",
    cooldown: "◐",
  };

  return (
    <div className="flex items-center gap-2 text-xs font-mono">
      <span style={{ color }} className="text-[10px]">
        {statusEmoji[engine.status]}
      </span>
      <span className="flex-1 truncate text-foreground">{engine.name}</span>
      <span className="text-[9px] text-muted-foreground w-10 text-right">
        {engine.avgLatencyMs}ms
      </span>
      <span className="text-[9px] text-muted-foreground w-12 text-right">
        {engine.executionCount}×
      </span>
      <div className="w-16">
        <Progress value={engine.load * 100} className="h-1.5" />
      </div>
    </div>
  );
}

function RouteRow({ route, engines }: { route: EngineRoute; engines: EngineNode[] }) {
  const source = engines.find((e) => e.id === route.sourceId);
  const target = engines.find((e) => e.id === route.targetId);

  return (
    <div className="flex items-center gap-1.5 text-[10px] font-mono text-muted-foreground">
      <span className="text-foreground">{source?.name || route.sourceId}</span>
      <ArrowRight className="w-2.5 h-2.5" />
      <span className="text-foreground">{target?.name || route.targetId}</span>
      <span className="ml-auto text-cyan-400">{(route.weight * 100).toFixed(0)}%</span>
    </div>
  );
}
