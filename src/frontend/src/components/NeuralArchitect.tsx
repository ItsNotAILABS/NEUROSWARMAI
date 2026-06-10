import React, { useRef, useEffect, useState, useCallback } from "react";

// ── Import from hebbianEngine for neural plasticity types ──
import type { Synapse as HebbianSynapse } from "../data/hebbianEngine";

// ── Types ────────────────────────────────────────────────────────────────────

export type NodeType =
  | "sensory"
  | "motor"
  | "associative"
  | "emotional"
  | "executive"
  | "quantum";

export interface NeuralNode {
  id: string;
  type: NodeType;
  label: string;
  activation: number; // 0-1
  layer: number;
  x?: number;
  y?: number;
}

// UI Synapse for visualization (distinct from HebbianSynapse which is for learning)
export interface UISynapse {
  id: string;
  fromId: string;
  toId: string;
  weight: number; // -1 to 1
  active: boolean;
}

// Re-export as Synapse for backwards compatibility
export type Synapse = UISynapse;

export interface NeuralArchitecture {
  nodes: NeuralNode[];
  synapses: UISynapse[];
  layers: number;
  cognitiveLoad: number; // 0-1
}

export interface ThoughtVector {
  dimensions: { label: string; value: number }[]; // value 0-1
}

export interface CognitiveState {
  thoughtVector: ThoughtVector;
  memoryConsolidation: number; // 0-1
  arousal: number;
  valence: number;
  attentionFocus: string;
}

export interface NeuralArchitectProps {
  architecture: NeuralArchitecture;
  cognitiveState: CognitiveState;
  tick: number;
  onNodeSelect?: (nodeId: string) => void;
}

// ── Constants ─────────────────────────────────────────────────────────────────

const NODE_COLORS: Record<NodeType, string> = {
  sensory: "#60a5fa", // blue
  motor: "#fb923c", // orange
  associative: "#4ade80", // green
  emotional: "#f472b6", // pink
  executive: "#f4f4f5", // white
  quantum: "#c084fc", // purple
};

const NODE_GLOW: Record<NodeType, string> = {
  sensory: "rgba(96,165,250,0.6)",
  motor: "rgba(251,146,60,0.6)",
  associative: "rgba(74,222,128,0.6)",
  emotional: "rgba(244,114,182,0.6)",
  executive: "rgba(244,244,245,0.4)",
  quantum: "rgba(192,132,252,0.7)",
};

const NODE_RADIUS = 10;

// ── Layout helper ─────────────────────────────────────────────────────────────

function layoutNodes(
  nodes: NeuralNode[],
  width: number,
  height: number,
): NeuralNode[] {
  const layers = Math.max(...nodes.map((n) => n.layer), 0) + 1;
  const byLayer: Record<number, NeuralNode[]> = {};
  for (const n of nodes) {
    if (!byLayer[n.layer]) byLayer[n.layer] = [];
    byLayer[n.layer].push(n);
  }
  const laid: NeuralNode[] = [];
  for (let l = 0; l < layers; l++) {
    const group = byLayer[l] || [];
    const x = ((l + 0.5) / layers) * width;
    group.forEach((n, i) => {
      const y = ((i + 0.5) / group.length) * height;
      laid.push({ ...n, x, y });
    });
  }
  return laid;
}

// ── RadarChart (thought vector) ───────────────────────────────────────────────

function RadarChart({
  vector,
  size = 120,
}: { vector: ThoughtVector; size?: number }) {
  const { dimensions } = vector;
  if (!dimensions.length) return null;
  const cx = size / 2;
  const cy = size / 2;
  const r = size / 2 - 16;
  const n = dimensions.length;
  const angle = (i: number) => (Math.PI * 2 * i) / n - Math.PI / 2;

  const gridPoints = (scale: number) =>
    Array.from({ length: n }, (_, i) => {
      const a = angle(i);
      return `${cx + Math.cos(a) * r * scale},${cy + Math.sin(a) * r * scale}`;
    }).join(" ");

  const dataPoints = dimensions
    .map((d, i) => {
      const a = angle(i);
      const rv = Math.max(0, Math.min(1, d.value));
      return `${cx + Math.cos(a) * r * rv},${cy + Math.sin(a) * r * rv}`;
    })
    .join(" ");

  return (
    <svg
      width={size}
      height={size}
      viewBox={`0 0 ${size} ${size}`}
      aria-label="Neural architect radar chart"
      role="img"
    >
      {[0.25, 0.5, 0.75, 1].map((s) => (
        <polygon
          key={s}
          points={gridPoints(s)}
          fill="none"
          stroke="rgba(255,255,255,0.08)"
          strokeWidth="1"
        />
      ))}
      {Array.from({ length: n }, (_, i) => {
        const a = angle(i);
        return (
          <line
            key={a}
            x1={cx}
            y1={cy}
            x2={cx + Math.cos(a) * r}
            y2={cy + Math.sin(a) * r}
            stroke="rgba(255,255,255,0.08)"
            strokeWidth="1"
          />
        );
      })}
      <polygon
        points={dataPoints}
        fill="rgba(192,132,252,0.2)"
        stroke="#c084fc"
        strokeWidth="1.5"
      />
      {dimensions.map((d, i) => {
        const a = angle(i);
        const lx = cx + Math.cos(a) * (r + 10);
        const ly = cy + Math.sin(a) * (r + 10);
        return (
          <text
            key={d.label}
            x={lx}
            y={ly}
            textAnchor="middle"
            dominantBaseline="middle"
            fontSize="7"
            fill="rgba(255,255,255,0.5)"
          >
            {d.label}
          </text>
        );
      })}
    </svg>
  );
}

// ── StatBadge ─────────────────────────────────────────────────────────────────

function StatBadge({
  label,
  value,
  color = "text-zinc-200",
}: { label: string; value: string | number; color?: string }) {
  return (
    <div className="rounded-lg bg-zinc-800/60 px-3 py-2 text-center">
      <p className="text-xs text-zinc-500 mb-0.5">{label}</p>
      <p className={`text-sm font-mono font-bold ${color}`}>{value}</p>
    </div>
  );
}

// ── ProgressBar ───────────────────────────────────────────────────────────────

function ProgressBar({
  label,
  value,
  color = "bg-violet-500",
}: { label: string; value: number; color?: string }) {
  return (
    <div className="space-y-1">
      <div className="flex justify-between text-xs">
        <span className="text-zinc-400">{label}</span>
        <span className="text-zinc-300 font-mono">
          {(value * 100).toFixed(0)}%
        </span>
      </div>
      <div className="h-1.5 bg-zinc-700 rounded-full overflow-hidden">
        <div
          className={`h-full rounded-full transition-all ${color}`}
          style={{ width: `${value * 100}%` }}
        />
      </div>
    </div>
  );
}

// ── NodeInfoPanel ─────────────────────────────────────────────────────────────

function NodeInfoPanel({
  node,
  synapses,
  allNodes,
}: { node: NeuralNode; synapses: Synapse[]; allNodes: NeuralNode[] }) {
  const incoming = synapses.filter((s) => s.toId === node.id);
  const outgoing = synapses.filter((s) => s.fromId === node.id);
  const nodeMap = Object.fromEntries(allNodes.map((n) => [n.id, n]));
  return (
    <div className="rounded-lg border border-zinc-700 bg-zinc-800/60 p-3 space-y-2">
      <div className="flex items-center gap-2">
        <span
          className="w-3 h-3 rounded-full inline-block"
          style={{ backgroundColor: NODE_COLORS[node.type] }}
        />
        <p className="text-sm font-semibold text-zinc-100">{node.label}</p>
        <span className="text-xs text-zinc-500 capitalize">{node.type}</span>
      </div>
      <div className="grid grid-cols-2 gap-2 text-xs">
        <div>
          <span className="text-zinc-500">Activation: </span>
          <span className="font-mono text-zinc-200">
            {node.activation.toFixed(3)}
          </span>
        </div>
        <div>
          <span className="text-zinc-500">Layer: </span>
          <span className="font-mono text-zinc-200">{node.layer}</span>
        </div>
        <div>
          <span className="text-zinc-500">In: </span>
          <span className="font-mono text-zinc-200">{incoming.length}</span>
        </div>
        <div>
          <span className="text-zinc-500">Out: </span>
          <span className="font-mono text-zinc-200">{outgoing.length}</span>
        </div>
      </div>
      {incoming.length > 0 && (
        <div>
          <p className="text-xs text-zinc-500 mb-1">Incoming</p>
          <div className="space-y-0.5">
            {incoming.slice(0, 4).map((s) => (
              <div key={s.id} className="flex justify-between text-xs">
                <span className="text-zinc-400 truncate">
                  {nodeMap[s.fromId]?.label ?? s.fromId}
                </span>
                <span
                  className={`font-mono ${s.weight >= 0 ? "text-emerald-400" : "text-red-400"}`}
                >
                  {s.weight.toFixed(2)}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

// ── NeuralArchitect (main) ────────────────────────────────────────────────────

export function NeuralArchitect({
  architecture,
  cognitiveState,
  tick,
  onNodeSelect,
}: NeuralArchitectProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const rafRef = useRef<number>(0);
  const [selectedNode, setSelectedNode] = useState<NeuralNode | null>(null);
  const [hoveredNode, setHoveredNode] = useState<NeuralNode | null>(null);
  const [canvasSize, setCanvasSize] = useState({ w: 600, h: 320 });
  const containerRef = useRef<HTMLDivElement>(null);
  const tickRef = useRef(tick);
  tickRef.current = tick;

  const laidOut = React.useMemo(
    () => layoutNodes(architecture.nodes, canvasSize.w, canvasSize.h),
    [architecture.nodes, canvasSize],
  );
  const nodeMap = React.useMemo(
    () => Object.fromEntries(laidOut.map((n) => [n.id, n])),
    [laidOut],
  );

  // Resize observer
  useEffect(() => {
    const el = containerRef.current;
    if (!el) return;
    const ro = new ResizeObserver((entries) => {
      const e = entries[0];
      if (e)
        setCanvasSize({
          w: e.contentRect.width,
          h: Math.max(280, e.contentRect.height),
        });
    });
    ro.observe(el);
    return () => ro.disconnect();
  }, []);

  // Canvas draw loop
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    let frame = 0;

    const draw = () => {
      frame++;
      const { w, h } = { w: canvas.width, h: canvas.height };
      ctx.clearRect(0, 0, w, h);

      // Background grid
      ctx.strokeStyle = "rgba(255,255,255,0.03)";
      ctx.lineWidth = 1;
      for (let gx = 0; gx < w; gx += 40) {
        ctx.beginPath();
        ctx.moveTo(gx, 0);
        ctx.lineTo(gx, h);
        ctx.stroke();
      }
      for (let gy = 0; gy < h; gy += 40) {
        ctx.beginPath();
        ctx.moveTo(0, gy);
        ctx.lineTo(w, gy);
        ctx.stroke();
      }

      // Draw synapses
      for (const syn of architecture.synapses) {
        const from = nodeMap[syn.fromId];
        const to = nodeMap[syn.toId];
        if (!from?.x || !to?.x) continue;
        const opacity = Math.abs(syn.weight) * 0.7;
        const isActive = syn.active;
        const pulse = isActive
          ? 0.4 + 0.6 * Math.abs(Math.sin(frame * 0.05))
          : 1;
        ctx.save();
        ctx.globalAlpha = opacity * pulse;
        ctx.strokeStyle = syn.weight >= 0 ? "#34d399" : "#f87171";
        ctx.lineWidth = isActive ? 1.5 : 0.8;
        ctx.beginPath();
        const cpx = (from.x! + to.x!) / 2;
        const cpy = (from.y! + to.y!) / 2 - 30;
        ctx.moveTo(from.x!, from.y!);
        ctx.quadraticCurveTo(cpx, cpy, to.x!, to.y!);
        ctx.stroke();
        ctx.restore();
      }

      // Draw nodes
      for (const node of laidOut) {
        if (!node.x || !node.y) continue;
        const color = NODE_COLORS[node.type];
        const glow = NODE_GLOW[node.type];
        const isSelected = selectedNode?.id === node.id;
        const isHovered = hoveredNode?.id === node.id;
        const activationPulse =
          node.activation > 0.5
            ? 0.7 + 0.3 * Math.abs(Math.sin(frame * 0.08 + node.layer))
            : 1;
        const radius = NODE_RADIUS * (isSelected ? 1.4 : isHovered ? 1.2 : 1);

        if (node.activation > 0.3 || isSelected) {
          ctx.save();
          ctx.globalAlpha = node.activation * activationPulse * 0.5;
          const grad = ctx.createRadialGradient(
            node.x,
            node.y,
            0,
            node.x,
            node.y,
            radius * 3,
          );
          grad.addColorStop(0, glow);
          grad.addColorStop(1, "transparent");
          ctx.fillStyle = grad;
          ctx.beginPath();
          ctx.arc(node.x, node.y, radius * 3, 0, Math.PI * 2);
          ctx.fill();
          ctx.restore();
        }

        ctx.save();
        ctx.globalAlpha = 0.3 + node.activation * 0.7;
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.arc(node.x, node.y, radius, 0, Math.PI * 2);
        ctx.fill();
        ctx.restore();

        if (isSelected || isHovered) {
          ctx.save();
          ctx.strokeStyle = color;
          ctx.lineWidth = 2;
          ctx.globalAlpha = 0.9;
          ctx.beginPath();
          ctx.arc(node.x, node.y, radius + 3, 0, Math.PI * 2);
          ctx.stroke();
          ctx.restore();
        }

        // Label
        ctx.save();
        ctx.fillStyle = "rgba(255,255,255,0.7)";
        ctx.font = "8px monospace";
        ctx.textAlign = "center";
        ctx.fillText(node.label.slice(0, 6), node.x, node.y + radius + 10);
        ctx.restore();
      }

      rafRef.current = requestAnimationFrame(draw);
    };

    rafRef.current = requestAnimationFrame(draw);
    return () => cancelAnimationFrame(rafRef.current);
  }, [laidOut, nodeMap, architecture.synapses, selectedNode, hoveredNode]);

  const getNodeAtPos = useCallback(
    (cx: number, cy: number): NeuralNode | null => {
      const canvas = canvasRef.current;
      if (!canvas) return null;
      const rect = canvas.getBoundingClientRect();
      const mx = (cx - rect.left) * (canvas.width / rect.width);
      const my = (cy - rect.top) * (canvas.height / rect.height);
      return (
        laidOut.find((n) => {
          if (!n.x || !n.y) return false;
          return Math.hypot(n.x - mx, n.y - my) <= NODE_RADIUS * 1.5;
        }) ?? null
      );
    },
    [laidOut],
  );

  const handleMouseMove = useCallback(
    (e: React.MouseEvent) => {
      setHoveredNode(getNodeAtPos(e.clientX, e.clientY));
    },
    [getNodeAtPos],
  );

  const handleClick = useCallback(
    (e: React.MouseEvent) => {
      const node = getNodeAtPos(e.clientX, e.clientY);
      setSelectedNode(node);
      if (node) onNodeSelect?.(node.id);
    },
    [getNodeAtPos, onNodeSelect],
  );

  const totalNodes = architecture.nodes.length;
  const totalSynapses = architecture.synapses.length;
  const activeNodes = architecture.nodes.filter(
    (n) => n.activation > 0.5,
  ).length;

  return (
    <div className="h-full flex flex-col bg-zinc-900 text-zinc-100 rounded-xl border border-zinc-800 overflow-hidden">
      {/* Header */}
      <div className="px-4 pt-4 pb-3 border-b border-zinc-800">
        <div className="flex items-center justify-between mb-3">
          <div>
            <h2 className="text-base font-bold text-zinc-100 tracking-tight">
              Neural Architect
            </h2>
            <p className="text-xs text-zinc-500">
              Tick #{tick.toLocaleString()} · Focus:{" "}
              <span className="text-violet-300">
                {cognitiveState.attentionFocus}
              </span>
            </p>
          </div>
          <div className="flex items-center gap-1.5 flex-wrap justify-end">
            {(Object.keys(NODE_COLORS) as NodeType[]).map((t) => (
              <span
                key={t}
                className="flex items-center gap-1 text-xs text-zinc-400"
              >
                <span
                  className="w-2 h-2 rounded-full inline-block"
                  style={{ backgroundColor: NODE_COLORS[t] }}
                />
                {t}
              </span>
            ))}
          </div>
        </div>
        <div className="grid grid-cols-4 gap-2">
          <StatBadge label="Nodes" value={totalNodes} />
          <StatBadge
            label="Active"
            value={activeNodes}
            color="text-emerald-400"
          />
          <StatBadge label="Synapses" value={totalSynapses} />
          <StatBadge
            label="Layers"
            value={architecture.layers}
            color="text-violet-300"
          />
        </div>
      </div>

      {/* Canvas */}
      <div
        ref={containerRef}
        className="relative flex-1 min-h-0 cursor-crosshair"
      >
        <canvas
          ref={canvasRef}
          width={canvasSize.w}
          height={canvasSize.h}
          className="w-full h-full"
          onMouseMove={handleMouseMove}
          onClick={handleClick}
          onKeyDown={(e) => {
            if (e.key === "Enter" || e.key === " ")
              handleClick(e as unknown as React.MouseEvent);
          }}
          onMouseLeave={() => setHoveredNode(null)}
          tabIndex={0}
        />
        {hoveredNode && (
          <div className="absolute top-2 left-2 pointer-events-none bg-zinc-900/90 border border-zinc-700 rounded px-2 py-1 text-xs text-zinc-200">
            <span className="font-semibold">{hoveredNode.label}</span>
            <span className="text-zinc-500 ml-2">{hoveredNode.type}</span>
            <span className="text-violet-300 ml-2 font-mono">
              act={hoveredNode.activation.toFixed(3)}
            </span>
          </div>
        )}
      </div>

      {/* Bottom panels */}
      <div className="border-t border-zinc-800 px-4 py-3 space-y-3">
        <div className="grid grid-cols-2 gap-4">
          {/* Cognitive state */}
          <div className="space-y-2">
            <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
              Cognitive State
            </p>
            <ProgressBar
              label="Cognitive Load"
              value={architecture.cognitiveLoad}
              color="bg-amber-500"
            />
            <ProgressBar
              label="Memory Consolidation"
              value={cognitiveState.memoryConsolidation}
              color="bg-violet-500"
            />
            <ProgressBar
              label="Arousal"
              value={cognitiveState.arousal}
              color="bg-pink-500"
            />
            <ProgressBar
              label="Valence"
              value={(cognitiveState.valence + 1) / 2}
              color="bg-sky-500"
            />
          </div>
          {/* Thought vector radar */}
          <div className="flex flex-col items-center justify-center">
            <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider mb-1 self-start">
              Thought Vector
            </p>
            <RadarChart vector={cognitiveState.thoughtVector} size={110} />
          </div>
        </div>

        {/* Selected node info */}
        {selectedNode && (
          <div>
            <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider mb-1">
              Selected Node
            </p>
            <NodeInfoPanel
              node={selectedNode}
              synapses={architecture.synapses}
              allNodes={architecture.nodes}
            />
          </div>
        )}
      </div>
    </div>
  );
}

export default NeuralArchitect;
