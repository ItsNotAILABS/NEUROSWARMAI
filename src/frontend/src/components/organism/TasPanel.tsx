// ═══════════════════════════════════════════════════════════════════════════
// TAS PANEL — Thought-Action-State World Computer
// ═══════════════════════════════════════════════════════════════════════════

import { ScrollArea } from "@/components/ui/scroll-area";
import { useEffect, useRef, useState } from "react";
import { TWO_PI } from "../../data/novaEngine";
import {
  type CouncilNodeState,
  type TASCycle,
  type TASState,
  councilStatusColor,
  initTASState,
  tasPhaseColor,
  tickTAS,
} from "../../data/tasEngine";

const CANVAS_SIZE = 400;
const AURA_RADIUS = 24;
const _GRAPH_RADIUS = 160;

// ── AURA Canvas ───────────────────────────────────────────────────────────────

function drawAuraCanvas(canvas: HTMLCanvasElement, state: TASState) {
  const ctx = canvas.getContext("2d");
  if (!ctx) return;
  const cx = CANVAS_SIZE / 2;
  const cy = CANVAS_SIZE / 2;

  ctx.clearRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);
  ctx.fillStyle = "#050a0e";
  ctx.fillRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);

  // Draw active synergy arcs
  for (const arc of state.synergyArcs) {
    if (!arc.active) continue;
    const fromNode = state.council.find((c) => c.id === arc.from);
    const toNode = state.council.find((c) => c.id === arc.to);
    if (!fromNode || !toNode) continue;

    const fx = cx + fromNode.x;
    const fy = cy + fromNode.y;
    const tx = cx + toNode.x;
    const ty = cy + toNode.y;
    const midX = (fx + tx) / 2 + (cy - fy) * 0.2;
    const midY = (fy + ty) / 2 + (fx - cx) * 0.2;

    // Arc line
    ctx.beginPath();
    ctx.moveTo(fx, fy);
    ctx.quadraticCurveTo(midX, midY, tx, ty);
    ctx.strokeStyle = `rgba(100,160,255,${arc.strength * 0.5})`;
    ctx.lineWidth = arc.strength * 2;
    ctx.stroke();

    // Pulse dot along arc
    const t = (Math.sin(arc.pulsePhase) + 1) / 2;
    const px = (1 - t) * (1 - t) * fx + 2 * (1 - t) * t * midX + t * t * tx;
    const py = (1 - t) * (1 - t) * fy + 2 * (1 - t) * t * midY + t * t * ty;
    ctx.beginPath();
    ctx.arc(px, py, 3, 0, TWO_PI);
    ctx.fillStyle = `rgba(100,220,255,${arc.strength})`;
    ctx.fill();
  }

  // Draw council nodes
  for (const node of state.council) {
    const nx = cx + node.x;
    const ny = cy + node.y;

    // Glow
    const gGrad = ctx.createRadialGradient(
      nx,
      ny,
      0,
      nx,
      ny,
      20 + node.activation * 10,
    );
    gGrad.addColorStop(0, `${node.color}80`);
    gGrad.addColorStop(1, `${node.color}00`);
    ctx.beginPath();
    ctx.arc(nx, ny, 20 + node.activation * 10, 0, TWO_PI);
    ctx.fillStyle = gGrad;
    ctx.fill();

    // Node circle
    ctx.beginPath();
    ctx.arc(nx, ny, 8 + node.activation * 4, 0, TWO_PI);
    ctx.fillStyle = `${node.color}cc`;
    ctx.strokeStyle = node.color;
    ctx.lineWidth = 1.5;
    ctx.fill();
    ctx.stroke();

    // Label
    ctx.font = "7px monospace";
    ctx.fillStyle = "rgba(255,255,255,0.8)";
    ctx.textAlign = "center";
    ctx.textBaseline = "alphabetic";
    ctx.fillText(node.id, nx, ny - 16);
  }

  // AURA core
  const auraR = AURA_RADIUS * (0.8 + state.auraActivation * 0.4);
  const coreGrad = ctx.createRadialGradient(cx, cy, 0, cx, cy, auraR * 2);
  coreGrad.addColorStop(0, "#22d3ee80");
  coreGrad.addColorStop(1, "#22d3ee00");
  ctx.beginPath();
  ctx.arc(cx, cy, auraR * 2, 0, TWO_PI);
  ctx.fillStyle = coreGrad;
  ctx.fill();

  ctx.beginPath();
  ctx.arc(cx, cy, auraR, 0, TWO_PI);
  ctx.fillStyle = "#22d3eecc";
  ctx.strokeStyle = "#22d3ee";
  ctx.lineWidth = 2;
  ctx.fill();
  ctx.stroke();

  // Active council name in center
  const activeMember = state.council.find(
    (c) => c.currentStatus === "THINK" || c.currentStatus === "ACT",
  );
  if (activeMember) {
    ctx.font = "bold 8px monospace";
    ctx.fillStyle = activeMember.color;
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText(activeMember.id, cx, cy);
  } else {
    ctx.font = "bold 8px monospace";
    ctx.fillStyle = "#22d3ee";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText("AURA", cx, cy);
  }
}

// ── Cycle block ───────────────────────────────────────────────────────────────

function CycleBlock({ cycle }: { cycle: TASCycle }) {
  const col = tasPhaseColor(cycle.phase);
  const rewardColor = cycle.rewardSignal > 0 ? "#4ade80" : "#f43f5e";
  return (
    <div
      className="flex-shrink-0 w-24 rounded p-1.5 border text-xs font-mono"
      style={{
        background: `${col}15`,
        borderColor: `${col}55`,
      }}
    >
      <div className="font-bold" style={{ color: col }}>
        {cycle.phase}
      </div>
      <div className="text-muted-foreground truncate">#{cycle.cycleNumber}</div>
      <div className="truncate text-foreground/70">{cycle.thoughtOrigin}</div>
      <div style={{ color: rewardColor }}>
        {cycle.rewardSignal > 0 ? "+" : ""}
        {cycle.rewardSignal.toFixed(2)}
      </div>
      <div className="text-muted-foreground">
        {(cycle.actionConfidence * 100).toFixed(0)}%
      </div>
    </div>
  );
}

// ── Sparkline ─────────────────────────────────────────────────────────────────

function Sparkline({ data, color }: { data: number[]; color: string }) {
  const w = 72;
  const h = 18;
  if (data.length < 2) return null;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const pts = data
    .map((v, i) => {
      const x = (i / (data.length - 1)) * w;
      const y = h - ((v - min) / range) * h;
      return `${x},${y}`;
    })
    .join(" ");
  return (
    <svg
      width={w}
      height={h}
      className="block"
      aria-label="TAS sparkline chart"
      role="img"
    >
      <polyline
        points={pts}
        fill="none"
        stroke={color}
        strokeWidth={1.2}
        strokeLinejoin="round"
      />
    </svg>
  );
}

// ── Council Card ──────────────────────────────────────────────────────────────

function CouncilCard({ node }: { node: CouncilNodeState }) {
  const statusColor = councilStatusColor(node.currentStatus);
  return (
    <div
      className="rounded border border-border p-2 text-xs font-mono mb-1.5"
      style={{ borderLeftColor: node.color, borderLeftWidth: 3 }}
    >
      <div className="flex items-center justify-between mb-1">
        <span className="font-bold" style={{ color: node.color }}>
          {node.id}
        </span>
        <span
          className="px-1 py-0.5 rounded text-xs"
          style={{
            background: `${statusColor}25`,
            color: statusColor,
            border: `1px solid ${statusColor}50`,
          }}
        >
          {node.currentStatus}
        </span>
      </div>
      <div className="text-muted-foreground truncate mb-1">{node.role}</div>
      <div className="flex items-center gap-2 mb-1">
        <div className="flex-1 h-1.5 bg-muted rounded overflow-hidden">
          <div
            className="h-full rounded"
            style={{
              width: `${node.activation * 100}%`,
              background: node.color,
            }}
          />
        </div>
        <span className="text-muted-foreground">
          {(node.activation * 100).toFixed(0)}%
        </span>
      </div>
      <div className="flex items-center justify-between">
        <Sparkline data={node.sparkline} color={node.color} />
        <span className="text-muted-foreground text-xs">
          {node.cyclesContributed}c
        </span>
      </div>
    </div>
  );
}

// ── Main Component ────────────────────────────────────────────────────────────

export function TasPanel() {
  const [state, setState] = useState<TASState>(() => initTASState());
  const stateRef = useRef(state);
  stateRef.current = state;

  const canvasRef = useRef<HTMLCanvasElement>(null);
  const timelineRef = useRef<HTMLDivElement>(null);

  // Tick at 1 Hz
  useEffect(() => {
    const id = setInterval(() => {
      setState((prev) => {
        const next = tickTAS(prev, 1000, 0.85, 500);
        return next;
      });
    }, 1000);
    return () => clearInterval(id);
  }, []);

  // Also tick aura canvas at ~30fps with requestAnimationFrame
  useEffect(() => {
    let raf: number;
    function loop() {
      if (canvasRef.current) {
        drawAuraCanvas(canvasRef.current, stateRef.current);
      }
      raf = requestAnimationFrame(loop);
    }
    raf = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(raf);
  }, []);

  // Auto-scroll timeline to right
  // biome-ignore lint/correctness/useExhaustiveDependencies: only reset on organism change
  useEffect(() => {
    if (timelineRef.current) {
      timelineRef.current.scrollLeft = timelineRef.current.scrollWidth;
    }
  }, [state.cycles]);

  const phaseColor = tasPhaseColor(state.currentPhase);
  const last20 = state.cycles.slice(-20);

  return (
    <div className="flex flex-col h-full bg-background text-foreground font-mono text-xs">
      {/* TOP: TAS Stream */}
      <div
        className="flex-shrink-0 border-b border-border"
        style={{ height: 120 }}
      >
        <div className="flex items-center gap-2 px-3 py-1 border-b border-border/50">
          <span className="text-muted-foreground">TAS STREAM</span>
          <span
            className="px-2 py-0.5 rounded font-bold"
            style={{
              background: `${phaseColor}25`,
              color: phaseColor,
              border: `1px solid ${phaseColor}50`,
            }}
          >
            {state.currentPhase}
          </span>
          <span className="text-muted-foreground ml-auto">
            cycle #{state.totalCycles}
          </span>
        </div>
        <div
          ref={timelineRef}
          className="flex gap-1.5 px-2 py-1.5 overflow-x-auto"
          style={{ height: 82 }}
        >
          {last20.map((c) => (
            <CycleBlock key={c.id} cycle={c} />
          ))}
          {state.activeCycle && (
            <CycleBlock key={state.activeCycle.id} cycle={state.activeCycle} />
          )}
        </div>
      </div>

      {/* MIDDLE: two columns */}
      <div className="flex flex-1 min-h-0">
        {/* LEFT: AURA Canvas */}
        <div
          className="flex-shrink-0 border-r border-border flex flex-col"
          style={{ width: 350 }}
        >
          <div className="px-3 py-1 border-b border-border/50 text-muted-foreground">
            AURA CANVAS
          </div>
          <div className="flex-1 flex items-center justify-center overflow-hidden bg-black/20">
            <canvas
              ref={canvasRef}
              width={CANVAS_SIZE}
              height={CANVAS_SIZE}
              style={{
                width: "100%",
                height: "100%",
                objectFit: "contain",
              }}
            />
          </div>
        </div>

        {/* RIGHT: Council Cards */}
        <div className="flex-1 flex flex-col min-w-0">
          <div className="px-3 py-1 border-b border-border/50 text-muted-foreground">
            COUNCIL CARDS
          </div>
          <ScrollArea className="flex-1">
            <div className="p-2">
              {state.council.map((node) => (
                <CouncilCard key={node.id} node={node} />
              ))}
            </div>
          </ScrollArea>
        </div>
      </div>

      {/* BOTTOM: Memory State */}
      <div
        className="flex-shrink-0 border-t border-border"
        style={{ height: 180 }}
      >
        <div className="px-3 py-1 border-b border-border/50 text-muted-foreground">
          TAS MEMORY STATE
        </div>
        <div
          className="grid grid-cols-2 gap-x-4 gap-y-0.5 px-3 py-1.5 overflow-auto"
          style={{ maxHeight: 130 }}
        >
          {[
            {
              label: "THOUGHT",
              value: state.memory.currentThought || "—",
              color: "#60a5fa",
            },
            {
              label: "ACTION",
              value: state.memory.currentAction || "—",
              color: "#f59e0b",
            },
            {
              label: "OBSERVATION",
              value: state.memory.currentObservation || "—",
              color: "#4ade80",
            },
            {
              label: "PRED ERROR",
              value: state.memory.predictionError.toFixed(4),
              color: "#fb923c",
            },
            {
              label: "REWARD",
              value: state.memory.rewardSignal.toFixed(3),
              color: state.memory.rewardSignal >= 0 ? "#4ade80" : "#f43f5e",
            },
            {
              label: "TOTAL CYCLES",
              value: String(state.memory.totalCycles),
              color: "#94a3b8",
            },
            {
              label: "SUCCESS RATE",
              value: `${(state.memory.successRate * 100).toFixed(1)}%`,
              color: "#c084fc",
            },
            {
              label: "AVG COHERENCE",
              value: state.memory.avgCoherence.toFixed(4),
              color: "#22d3ee",
            },
          ].map(({ label, value, color }) => (
            <div key={label} className="flex gap-1 items-baseline truncate">
              <span className="text-muted-foreground flex-shrink-0">
                {label}:
              </span>
              <span className="truncate" style={{ color }}>
                {value}
              </span>
            </div>
          ))}
        </div>
        {/* Working memory slots */}
        {state.memory.workingMemory.length > 0 && (
          <div className="px-3 pb-1 flex flex-wrap gap-1">
            {state.memory.workingMemory.map((slot) => (
              <span
                key={slot.id}
                className="px-1.5 py-0.5 rounded text-xs truncate max-w-40"
                style={{
                  background: "#1e293b",
                  border: "1px solid #334155",
                  color: "#94a3b8",
                  opacity: slot.strength,
                }}
                title={slot.content}
              >
                [{slot.origin}] {slot.content.slice(0, 24)}…
              </span>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
