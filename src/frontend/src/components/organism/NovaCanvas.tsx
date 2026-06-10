// ═══════════════════════════════════════════════════════════════════════════
// NOVA CANVAS — Living Organism Renderer (7-Layer Kuramoto Substrate)
// ═══════════════════════════════════════════════════════════════════════════

import { useEffect, useRef, useState } from "react";
import {
  COUNCIL_MEMBERS,
  DRIVE_AURA,
  type NovaState,
  QSOV_COLORS,
  TWO_PI,
  arousalColor,
  arousalLabel,
  initNovaState,
  qsovRingColor,
  seedNovaFromOrganism,
  tickNova,
} from "../../data/novaEngine";
import { MOCK_ORGANISMS, type MockOrganism } from "../../data/organisms";

interface NovaCanvasProps {
  organism?: MockOrganism;
}

const QSOV_KEYS = [
  "coherence",
  "stability",
  "autonomy",
  "integrity",
  "resilience",
  "efficiency",
  "growth",
] as const;

const RING_COLORS = ["#22d3ee", "#60a5fa", "#c084fc", "#a78bfa"];

// ── Canvas drawing helpers ───────────────────────────────────────────────────

function drawLayer1Pheromones(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
) {
  for (const p of state.particles) {
    ctx.beginPath();
    ctx.arc(cx + p.x, cy + p.y, p.size, 0, TWO_PI);
    ctx.fillStyle = `hsla(${p.hue}, 80%, 60%, ${p.life * 0.4})`;
    ctx.fill();
  }
}

function drawLayer2QSOVRings(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
  beat: number,
) {
  for (let i = 0; i < QSOV_KEYS.length; i++) {
    const key = QSOV_KEYS[i];
    const value = state.qsov[key] as number;
    const radius = 30 + i * 22;
    const opacity = 0.2 + value * 0.6;
    const rotOffset = beat * 0.002 * (i % 2 === 0 ? 1 : -1);
    const arcLen = TWO_PI * (0.6 + value * 0.35);

    ctx.beginPath();
    ctx.arc(cx, cy, radius, rotOffset, rotOffset + arcLen);
    ctx.strokeStyle = qsovRingColor(key, opacity);
    ctx.lineWidth = 1 + value;
    ctx.stroke();
  }
}

function drawLayer3NeuralWeb(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
) {
  // Draw sync lines first
  for (let i = 0; i < state.nodes.length; i++) {
    const a = state.nodes[i];
    for (let j = i + 1; j < state.nodes.length; j++) {
      const b = state.nodes[j];
      if (a.ring !== b.ring) continue;
      const phaseDiff = Math.abs(a.phase - b.phase);
      const diff = phaseDiff > Math.PI ? TWO_PI - phaseDiff : phaseDiff;
      if (diff > 0.4) continue;
      const proximity = 1 - diff / 0.4;
      const ax = cx + a.x;
      const ay = cy + a.y;
      const bx = cx + b.x;
      const by = cy + b.y;
      const midX = (ax + bx) / 2 + (Math.random() - 0.5) * 6;
      const midY = (ay + by) / 2 + (Math.random() - 0.5) * 6;
      ctx.beginPath();
      ctx.moveTo(ax, ay);
      ctx.quadraticCurveTo(midX, midY, bx, by);
      ctx.strokeStyle = `rgba(100, 180, 255, ${proximity * 0.25})`;
      ctx.lineWidth = 0.5;
      ctx.stroke();
    }
  }

  // Draw nodes
  for (const n of state.nodes) {
    const x = cx + n.x;
    const y = cy + n.y;
    const color = RING_COLORS[n.ring] ?? "#ffffff";
    const r = 2 + n.activation * 2;
    ctx.beginPath();
    ctx.arc(x, y, r, 0, TWO_PI);
    ctx.globalAlpha = 0.5 + n.activation * 0.5;
    ctx.fillStyle = color;
    ctx.fill();
    ctx.globalAlpha = 1;
  }
}

function drawLayer4Satellites(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
) {
  for (const s of state.satellites) {
    const sx = cx + s.x;
    const sy = cy + s.y;

    // Signal arc from center
    ctx.beginPath();
    ctx.moveTo(cx, cy);
    const ctrlX = cx + s.x * 0.5 + (Math.random() - 0.5) * 20;
    const ctrlY = cy + s.y * 0.5 + (Math.random() - 0.5) * 20;
    ctx.quadraticCurveTo(ctrlX, ctrlY, sx, sy);
    ctx.strokeStyle =
      s.color.replace("#", "").length === 6
        ? `rgba(${Number.parseInt(s.color.slice(1, 3), 16)}, ${Number.parseInt(s.color.slice(3, 5), 16)}, ${Number.parseInt(s.color.slice(5, 7), 16)}, ${s.signalStrength * 0.3})`
        : "rgba(255,255,255,0.2)";
    ctx.lineWidth = 0.8;
    ctx.stroke();

    // Glow circle
    const glowR = 12 + s.activation * 8;
    const grad = ctx.createRadialGradient(sx, sy, 0, sx, sy, glowR);
    grad.addColorStop(0, `${s.color}cc`);
    grad.addColorStop(1, `${s.color}00`);
    ctx.beginPath();
    ctx.arc(sx, sy, glowR, 0, TWO_PI);
    ctx.fillStyle = grad;
    ctx.fill();

    // Core dot
    ctx.beginPath();
    ctx.arc(sx, sy, 5, 0, TWO_PI);
    ctx.fillStyle = s.color;
    ctx.fill();

    // Label
    ctx.font = "8px monospace";
    ctx.fillStyle = "rgba(255,255,255,0.7)";
    ctx.textAlign = "center";
    ctx.fillText(s.id, sx, sy - glowR - 3);
  }
}

function drawLayer5DriveAura(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
) {
  const aura = DRIVE_AURA[state.driveMode];
  const pulseFactor = 0.4 + Math.sin(state.beat * 0.01) * 0.1;
  const grad = ctx.createRadialGradient(cx, cy, 0, cx, cy, 120);
  grad.addColorStop(
    0,
    aura.inner +
      Math.round(pulseFactor * 255)
        .toString(16)
        .padStart(2, "0"),
  );
  grad.addColorStop(1, `${aura.outer}00`);
  ctx.beginPath();
  ctx.arc(cx, cy, 120, 0, TWO_PI);
  ctx.fillStyle = grad;
  ctx.fill();
}

function drawLayer6IdentityCore(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
  organism: MockOrganism,
) {
  const breathR = 20 + Math.sin(state.beat * 0.05) * 4;
  const qsov = state.qsov.overall;
  const coreColor =
    qsov > 1.0 ? "#4ade80" : qsov > 0.75 ? "#facc15" : "#f43f5e";

  // Outer glow
  const grad = ctx.createRadialGradient(cx, cy, 0, cx, cy, breathR * 2.5);
  grad.addColorStop(0, `${coreColor}80`);
  grad.addColorStop(1, `${coreColor}00`);
  ctx.beginPath();
  ctx.arc(cx, cy, breathR * 2.5, 0, TWO_PI);
  ctx.fillStyle = grad;
  ctx.fill();

  // Core circle
  ctx.beginPath();
  ctx.arc(cx, cy, breathR, 0, TWO_PI);
  ctx.fillStyle = `${coreColor}cc`;
  ctx.fill();
  ctx.strokeStyle = coreColor;
  ctx.lineWidth = 1.5;
  ctx.stroke();

  // Coherence value inside
  ctx.font = "bold 9px monospace";
  ctx.fillStyle = "#000";
  ctx.textAlign = "center";
  ctx.textBaseline = "middle";
  ctx.fillText(state.coherence.toFixed(2), cx, cy);

  // Name above
  ctx.font = "10px monospace";
  ctx.fillStyle = "rgba(255,255,255,0.9)";
  ctx.textBaseline = "alphabetic";
  ctx.fillText(organism.name, cx, cy - breathR - 8);

  // Class below
  ctx.font = "8px monospace";
  ctx.fillStyle = "rgba(180,180,180,0.7)";
  ctx.textBaseline = "top";
  ctx.fillText(organism.class.toUpperCase(), cx, cy + breathR + 4);
  ctx.textBaseline = "alphabetic";
}

function drawLayer7Expressions(
  ctx: CanvasRenderingContext2D,
  state: NovaState,
  cx: number,
  cy: number,
) {
  for (const expr of state.expressions) {
    ctx.globalAlpha = Math.max(0, expr.opacity);
    ctx.font = "9px monospace";
    ctx.fillStyle = expr.color;
    ctx.textAlign = "center";
    ctx.textBaseline = "alphabetic";
    ctx.fillText(expr.text, cx, cy + expr.y);
  }
  ctx.globalAlpha = 1;
}

// ── Main Component ───────────────────────────────────────────────────────────

export function NovaCanvas({ organism }: NovaCanvasProps) {
  const org = organism ?? MOCK_ORGANISMS[0];
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const stateRef = useRef<NovaState>(
    seedNovaFromOrganism(initNovaState(org.coherence, org.driveMode), org),
  );
  const rafRef = useRef<number | null>(null);
  const lastRef = useRef<number>(0);
  const [hudState, setHudState] = useState<NovaState>(stateRef.current);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    let lastHudUpdate = 0;

    function render(ts: number) {
      const dt = ts - lastRef.current;
      lastRef.current = ts;

      // Tick at ~30fps (clamp dt to avoid huge jumps)
      const clampedDt = Math.min(dt, 100);
      stateRef.current = tickNova(stateRef.current, clampedDt);

      const ctx = canvas!.getContext("2d");
      if (!ctx) return;

      const w = canvas!.width;
      const h = canvas!.height;
      const cx = w / 2;
      const cy = h / 2;

      ctx.clearRect(0, 0, w, h);
      ctx.fillStyle = "#050a0e";
      ctx.fillRect(0, 0, w, h);

      drawLayer1Pheromones(ctx, stateRef.current, cx, cy);
      drawLayer2QSOVRings(ctx, stateRef.current, cx, cy, stateRef.current.beat);
      drawLayer3NeuralWeb(ctx, stateRef.current, cx, cy);
      drawLayer4Satellites(ctx, stateRef.current, cx, cy);
      drawLayer5DriveAura(ctx, stateRef.current, cx, cy);
      drawLayer6IdentityCore(ctx, stateRef.current, cx, cy, org);
      drawLayer7Expressions(ctx, stateRef.current, cx, cy);

      // NOVA label
      ctx.font = "10px monospace";
      ctx.fillStyle = "#4ade80";
      ctx.textAlign = "left";
      ctx.textBaseline = "top";
      ctx.fillText("NOVA", 12, 12);

      // Update HUD at ~5fps
      if (ts - lastHudUpdate > 200) {
        setHudState({ ...stateRef.current });
        lastHudUpdate = ts;
      }

      rafRef.current = requestAnimationFrame(render);
    }

    rafRef.current = requestAnimationFrame(render);
    return () => {
      if (rafRef.current !== null) cancelAnimationFrame(rafRef.current);
    };
  }, [org]);

  // Resize canvas to fill container
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const obs = new ResizeObserver(() => {
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;
    });
    obs.observe(canvas);
    canvas.width = canvas.offsetWidth;
    canvas.height = canvas.offsetHeight;
    return () => obs.disconnect();
  }, []);

  const arousalPct = (hudState.arousalLevel / 1000) * 100;
  const arousalCol = arousalColor(hudState.arousalLevel);
  const trendArrow =
    hudState.qsov.trend === "rising"
      ? "↑"
      : hudState.qsov.trend === "falling"
        ? "↓"
        : "→";

  return (
    <div className="flex flex-col h-full bg-background text-foreground">
      {/* Canvas fills remaining space */}
      <canvas
        ref={canvasRef}
        className="flex-1 w-full block"
        style={{ background: "#050a0e" }}
      />

      {/* Bottom HUD */}
      <div className="flex-shrink-0 border-t border-border bg-background/90 px-4 py-2 flex flex-wrap gap-4 items-center text-xs font-mono">
        {/* Arousal bar */}
        <div className="flex items-center gap-2 min-w-32">
          <span className="text-muted-foreground">AROUSAL</span>
          <span style={{ color: arousalCol }}>
            {hudState.arousalLevel}/1000
          </span>
          <div className="w-20 h-2 bg-muted rounded overflow-hidden">
            <div
              className="h-full rounded transition-all"
              style={{ width: `${arousalPct}%`, background: arousalCol }}
            />
          </div>
          <span style={{ color: arousalCol }}>
            {arousalLabel(hudState.arousalLevel)}
          </span>
        </div>

        {/* QSOV */}
        <div className="flex items-center gap-1">
          <span className="text-muted-foreground">QSOV</span>
          <span
            style={{
              color: hudState.qsov.overall >= 0.75 ? "#c084fc" : "#f43f5e",
            }}
          >
            {hudState.qsov.overall.toFixed(4)}
          </span>
          <span className="text-yellow-400">{trendArrow}</span>
        </div>

        {/* Kuramoto r */}
        <div className="flex items-center gap-1">
          <span className="text-muted-foreground">KURAMOTO</span>
          <span className="text-cyan-400">
            r = {hudState.kuramotoR.toFixed(4)}
          </span>
        </div>

        {/* Beat */}
        <div className="flex items-center gap-1">
          <span className="text-muted-foreground">BEAT</span>
          <span className="text-foreground">#{hudState.beat}</span>
        </div>

        {/* Drive mode */}
        <div className="flex items-center gap-1">
          <span className="text-muted-foreground">MODE</span>
          <span
            className="px-1.5 py-0.5 rounded text-xs"
            style={{
              background: `${DRIVE_AURA[hudState.driveMode].inner}33`,
              color: DRIVE_AURA[hudState.driveMode].inner,
              border: `1px solid ${DRIVE_AURA[hudState.driveMode].inner}55`,
            }}
          >
            {hudState.driveMode.toUpperCase()}
          </span>
        </div>

        {/* QSOV components mini */}
        <div className="flex items-center gap-1 ml-auto">
          {QSOV_KEYS.map((k) => (
            <span
              key={k}
              className="text-xs"
              style={{ color: QSOV_COLORS[k] }}
              title={k}
            >
              {(hudState.qsov[k] as number).toFixed(2)}
            </span>
          ))}
        </div>
      </div>
    </div>
  );
}
