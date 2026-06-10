// ═══════════════════════════════════════════════════════════════════════════════
// MACRO WORLD CANVAS — The Universal Simulation Renderer (MUSE)
// ═══════════════════════════════════════════════════════════════════════════════
// Renders whatever the simulation generates — no hand-authored world objects.
// law → state → gradients → geometry → this renderer
//
// Layer order (bottom → top):
//  1. Territory fill (faction influence fields)
//  2. Biome atmosphere (emergent from cell state)
//  3. Frontier effects (border glows at cell boundaries)
//  4. Scars & ruins (persistent battle history)
//  5. Infrastructure (hubs, routes, fortresses)
//  6. Synaptic sparks (Hebbian co-firing)
//  7. Explosions (P(hit)·damage)
//  8. Drones (boid positions = math output)
//  9. Domain overlays (cyber grid, space stars, deep field, void abyss)
// 10. Heartbeat canvas pulse (organism breathes)
// 11. HUD & legend
// ═══════════════════════════════════════════════════════════════════════════════

import { ScrollArea } from "@/components/ui/scroll-area";
import { Activity, Globe, RefreshCw, Rocket, Shield, Zap } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import {
  type BiomeType,
  type Faction,
  type WorldState,
  biomeOverlayColor,
  factionDroneColor,
  factionHue,
  factionTerritoryColor,
  initWorld,
  tickWorld,
} from "../../data/macroWorld";

// ─── Drawing — Territory fill layer ──────────────────────────────────────────
// territory_size[faction] = S(t) · max_territory
// glow_opacity = S(t)²
// Territories emerge from coherence gradient fields — not hand-painted

function drawTerritoryLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  const { grid, gridCols, gridRows, cellW, cellH } = state;

  for (let row = 0; row < gridRows; row++) {
    for (let col = 0; col < gridCols; col++) {
      const cell = grid[row * gridCols + col];
      const x = col * cellW;
      const y = row * cellH;
      const w = cellW + 0.5;
      const h = cellH + 0.5;

      if (cell.dominant >= 0) {
        ctx.fillStyle = factionTerritoryColor(
          cell.dominant,
          cell.dominanceStrength,
        );
        ctx.fillRect(x, y, w, h);
      } else {
        // Contested — show blended influence if significant
        let totalInf = cell.influence.reduce((s, v) => s + v, 0);
        if (totalInf > 0.06) {
          ctx.fillStyle = `rgba(100,90,130,${Math.min(0.12, totalInf * 0.08)})`;
          ctx.fillRect(x, y, w, h);
        }
      }
    }
  }
}

// ─── Drawing — Biome atmosphere layer ────────────────────────────────────────
// Biomes emerge from: coherence, conflict, memory, stability, damage, law density
// They are the visible atmospheric character of simulation state

function drawBiomeLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  const { grid, gridCols, gridRows, cellW, cellH, pulsePhase } = state;

  for (let row = 0; row < gridRows; row++) {
    for (let col = 0; col < gridCols; col++) {
      const cell = grid[row * gridCols + col];
      if (cell.biome === "neutral") continue;

      const pulse = Math.sin(pulsePhase + col * 0.28 + row * 0.19);
      const color = biomeOverlayColor(cell.biome as BiomeType, pulse);
      if (color === "transparent") continue;

      ctx.fillStyle = color;
      ctx.fillRect(col * cellW, row * cellH, cellW + 0.5, cellH + 0.5);

      // Crystalline: add shimmer lines
      if (cell.biome === "crystalline" && cell.dominanceAge > 130) {
        const shimmer = (Math.sin(pulsePhase * 2 + col * 0.5) + 1) * 0.5;
        ctx.strokeStyle = `rgba(200,240,255,${shimmer * 0.12})`;
        ctx.lineWidth = 0.5;
        ctx.beginPath();
        const cx = col * cellW + cellW / 2;
        const cy = row * cellH + cellH / 2;
        ctx.moveTo(cx - cellW * 0.4, cy);
        ctx.lineTo(cx + cellW * 0.4, cy);
        ctx.stroke();
      }

      // Storm: add lightning flicker
      if (cell.biome === "storm" && Math.random() < 0.002) {
        ctx.strokeStyle = "rgba(200,160,255,0.6)";
        ctx.lineWidth = 0.8;
        ctx.beginPath();
        const sx = col * cellW + Math.random() * cellW;
        const sy = row * cellH;
        ctx.moveTo(sx, sy);
        ctx.lineTo(sx + (Math.random() - 0.5) * cellW, sy + cellH);
        ctx.stroke();
      }
    }
  }
}

// ─── Drawing — Frontier effects ───────────────────────────────────────────────
// Borders emerge where different factions meet — not drawn by hand

function drawFrontierLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  const { grid, gridCols, gridRows, cellW, cellH, pulsePhase } = state;

  ctx.save();
  for (let row = 0; row < gridRows; row++) {
    for (let col = 0; col < gridCols; col++) {
      const cell = grid[row * gridCols + col];
      if (cell.dominant < 0) continue;

      const hue = factionHue(cell.dominant);
      const brightness =
        0.25 + 0.2 * Math.sin(pulsePhase + col * 0.4 + row * 0.3);

      // Right frontier
      if (col < gridCols - 1) {
        const right = grid[row * gridCols + (col + 1)];
        if (right.dominant !== cell.dominant) {
          ctx.strokeStyle = `hsla(${hue},75%,65%,${brightness})`;
          ctx.lineWidth = 1.2;
          ctx.beginPath();
          ctx.moveTo((col + 1) * cellW, row * cellH);
          ctx.lineTo((col + 1) * cellW, (row + 1) * cellH);
          ctx.stroke();
        }
      }

      // Bottom frontier
      if (row < gridRows - 1) {
        const bottom = grid[(row + 1) * gridCols + col];
        if (bottom.dominant !== cell.dominant) {
          ctx.strokeStyle = `hsla(${hue},75%,65%,${brightness})`;
          ctx.lineWidth = 1.2;
          ctx.beginPath();
          ctx.moveTo(col * cellW, (row + 1) * cellH);
          ctx.lineTo((col + 1) * cellW, (row + 1) * cellH);
          ctx.stroke();
        }
      }
    }
  }
  ctx.restore();
}

// ─── Drawing — Scar & ruin layer ──────────────────────────────────────────────
// Scars emerge from repeated battles — the world remembers what happened here

function drawScarLayer(ctx: CanvasRenderingContext2D, state: WorldState): void {
  for (const scar of state.scars) {
    const alpha = scar.intensity * Math.max(0, 1 - scar.age / 3000);
    if (alpha < 0.01) continue;

    const r = scar.radius;
    const grad = ctx.createRadialGradient(
      scar.worldX,
      scar.worldY,
      0,
      scar.worldX,
      scar.worldY,
      r,
    );

    if (scar.type === "battle") {
      grad.addColorStop(0, `rgba(35,8,8,${alpha * 0.85})`);
      grad.addColorStop(0.4, `rgba(70,18,18,${alpha * 0.4})`);
      grad.addColorStop(1, "rgba(15,4,4,0)");
    } else if (scar.type === "ruin") {
      grad.addColorStop(0, `rgba(55,38,18,${alpha * 0.65})`);
      grad.addColorStop(0.5, `rgba(28,18,8,${alpha * 0.3})`);
      grad.addColorStop(1, "rgba(8,4,2,0)");
    } else {
      grad.addColorStop(0, `rgba(75,0,120,${alpha * 0.75})`);
      grad.addColorStop(0.35, `rgba(40,0,80,${alpha * 0.4})`);
      grad.addColorStop(1, "rgba(10,0,20,0)");
    }

    ctx.fillStyle = grad;
    ctx.beginPath();
    ctx.arc(scar.worldX, scar.worldY, r, 0, 2 * Math.PI);
    ctx.fill();
  }
}

// ─── Drawing — Infrastructure layer ──────────────────────────────────────────
// Routes, hubs, fortresses — emerge from repeated activity, not hand-placed
// node_position = weighted_centroid(LawsFired[region])
// edges = connect(nodes where shared_laws > threshold)

function drawInfraLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  const { infraObjects, factions, pulsePhase } = state;

  // Routes first (draw below hubs)
  for (const obj of infraObjects) {
    if (obj.type !== "route") continue;
    if (!obj.toWorldX || !obj.toWorldY) continue;
    if (obj.maturity < 0.05) continue;

    const hue = factionHue(obj.faction);
    const alpha = 0.18 + obj.maturity * 0.42;
    ctx.strokeStyle = `hsla(${hue},65%,58%,${alpha})`;
    ctx.lineWidth = 0.8 + obj.maturity * 1.4;
    ctx.setLineDash([4, 6]);
    ctx.beginPath();
    ctx.moveTo(obj.worldX, obj.worldY);
    ctx.lineTo(obj.toWorldX, obj.toWorldY);
    ctx.stroke();
    ctx.setLineDash([]);
  }

  // Fortresses (contested zones)
  for (const obj of infraObjects) {
    if (obj.type !== "fortress") continue;
    if (obj.maturity < 0.02) continue;

    const hue = obj.faction >= 0 ? factionHue(obj.faction) : 0;
    const pulse = 1 + 0.12 * Math.sin(pulsePhase * 1.5 + obj.col * 0.4);
    const size = (3 + obj.maturity * 5) * pulse;
    const alpha = 0.4 + obj.maturity * 0.4;

    ctx.strokeStyle = `hsla(${hue},70%,60%,${alpha})`;
    ctx.lineWidth = 1.2;
    ctx.beginPath();
    ctx.moveTo(obj.worldX, obj.worldY - size);
    ctx.lineTo(obj.worldX + size, obj.worldY);
    ctx.lineTo(obj.worldX, obj.worldY + size);
    ctx.lineTo(obj.worldX - size, obj.worldY);
    ctx.closePath();
    ctx.stroke();
  }

  // Command hubs (highest layer of infra)
  for (const obj of infraObjects) {
    if (obj.type !== "hub") continue;
    if (obj.maturity < 0.05) continue;

    const hue = factionHue(obj.faction);
    const faction = factions[obj.faction];
    const pulse = 1 + 0.18 * Math.sin(pulsePhase * 2 + obj.col * 0.6);
    const size = (3.5 + obj.maturity * 7) * pulse;
    const glowR = size * 2.8;

    // Hub glow ring
    const grad = ctx.createRadialGradient(
      obj.worldX,
      obj.worldY,
      size * 0.3,
      obj.worldX,
      obj.worldY,
      glowR,
    );
    grad.addColorStop(0, `hsla(${hue},90%,72%,${0.35 + obj.maturity * 0.25})`);
    grad.addColorStop(0.5, `hsla(${hue},70%,55%,${0.1 + obj.maturity * 0.1})`);
    grad.addColorStop(1, `hsla(${hue},60%,40%,0)`);
    ctx.fillStyle = grad;
    ctx.beginPath();
    ctx.arc(obj.worldX, obj.worldY, glowR, 0, 2 * Math.PI);
    ctx.fill();

    // Hub core dot
    ctx.fillStyle = `hsla(${hue},80%,68%,${0.65 + obj.maturity * 0.3})`;
    ctx.beginPath();
    ctx.arc(obj.worldX, obj.worldY, size, 0, 2 * Math.PI);
    ctx.fill();

    // Faction name label (appears as hub matures)
    if (obj.maturity > 0.4 && faction) {
      const textAlpha = (obj.maturity - 0.4) / 0.6;
      ctx.fillStyle = `rgba(255,255,255,${textAlpha * 0.65})`;
      ctx.font = `bold ${7 + obj.maturity * 4}px monospace`;
      ctx.textAlign = "center";
      ctx.fillText(faction.name, obj.worldX, obj.worldY - size - 3);
    }
  }
}

// ─── Drawing — Sparks, Explosions, Drones ────────────────────────────────────

function drawSparksLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  for (const spark of state.sparks) {
    const hue = factionHue(spark.factionId);
    ctx.strokeStyle = `hsla(${hue},80%,65%,${spark.opacity * 0.9})`;
    ctx.lineWidth = spark.intensity * 1.5 + 0.4;
    ctx.shadowColor = `hsla(${hue},80%,65%,0.6)`;
    ctx.shadowBlur = spark.intensity * 8;
    ctx.beginPath();
    ctx.moveTo(spark.fromPos.x, spark.fromPos.y);
    ctx.lineTo(spark.toPos.x, spark.toPos.y);
    ctx.stroke();
  }
  ctx.shadowBlur = 0;
}

function drawExplosionsLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  for (const exp of state.explosions) {
    const hue = factionHue(exp.factionId);
    const grad = ctx.createRadialGradient(
      exp.pos.x,
      exp.pos.y,
      0,
      exp.pos.x,
      exp.pos.y,
      exp.radius,
    );
    grad.addColorStop(0, `rgba(255,255,210,${exp.opacity * 0.9})`);
    grad.addColorStop(0.3, `hsla(${hue},90%,65%,${exp.opacity * 0.7})`);
    grad.addColorStop(1, `hsla(${hue},60%,40%,0)`);
    ctx.fillStyle = grad;
    ctx.beginPath();
    ctx.arc(exp.pos.x, exp.pos.y, exp.radius, 0, 2 * Math.PI);
    ctx.fill();
  }
}

function drawDronesLayer(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
): void {
  for (const drone of state.drones) {
    const faction = state.factions[drone.factionId];
    const color = factionDroneColor(drone.factionId, 0.9);
    const glowSize = 3 + drone.activation * 5;

    ctx.shadowColor = color;
    ctx.shadowBlur = glowSize;
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.arc(drone.pos.x, drone.pos.y, 2.5, 0, 2 * Math.PI);
    ctx.fill();
    ctx.shadowBlur = 0;

    // Velocity arrow in attack mode
    if (faction.actionAttack > 0.65) {
      const speed = Math.sqrt(drone.vel.x ** 2 + drone.vel.y ** 2);
      if (speed > 0.5) {
        ctx.strokeStyle = factionDroneColor(drone.factionId, 0.35);
        ctx.lineWidth = 0.8;
        ctx.beginPath();
        ctx.moveTo(drone.pos.x, drone.pos.y);
        ctx.lineTo(
          drone.pos.x + (drone.vel.x / speed) * 8,
          drone.pos.y + (drone.vel.y / speed) * 8,
        );
        ctx.stroke();
      }
    }
  }
}

// ─── Drawing — Domain overlay layers ─────────────────────────────────────────
// New playable domains appear when macro-state crosses thresholds

function drawDomainOverlays(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
  width: number,
  height: number,
): void {
  const { domainFlags, pulsePhase, beat } = state;

  // CYBER domain — grid overlay when escalation > 40%
  if (domainFlags.cyber) {
    const gridAlpha = 0.035 + 0.018 * Math.sin(pulsePhase * 2);
    ctx.strokeStyle = `rgba(0,180,255,${gridAlpha})`;
    ctx.lineWidth = 0.5;
    const step = 48;
    for (let x = 0; x < width; x += step) {
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, height);
      ctx.stroke();
    }
    for (let y = 0; y < height; y += step) {
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(width, y);
      ctx.stroke();
    }
  }

  // SPACE domain — star field when escalation > 70%
  if (domainFlags.space) {
    let seed = beat * 999;
    const pr = () => {
      seed = (seed * 1664525 + 1013904223) & 0xffffffff;
      return (seed >>> 0) / 0xffffffff;
    };
    ctx.fillStyle = "rgba(200,215,255,0.55)";
    for (let i = 0; i < 50; i++) {
      const sx = pr() * width;
      const sy = pr() * height;
      const sr = pr() * 1.3;
      ctx.beginPath();
      ctx.arc(sx, sy, sr, 0, 2 * Math.PI);
      ctx.fill();
    }
  }

  // DEEP domain — memory depth field when globalMemory > 15%
  if (domainFlags.deep) {
    const deepAlpha = Math.min(0.08, state.globalMemory * 0.4);
    const grad = ctx.createRadialGradient(
      width / 2,
      height / 2,
      0,
      width / 2,
      height / 2,
      Math.min(width, height) * 0.5,
    );
    grad.addColorStop(0, "rgba(0,0,0,0)");
    grad.addColorStop(1, `rgba(20,0,60,${deepAlpha})`);
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, width, height);
  }

  // VOID domain — corruption field when globalDamage > 15%
  if (domainFlags.void) {
    const voidAlpha = Math.min(0.12, state.globalDamage * 0.6);
    const p = 0.5 + 0.5 * Math.sin(pulsePhase);
    ctx.fillStyle = `rgba(60,0,90,${voidAlpha * p})`;
    ctx.fillRect(0, 0, width, height);
  }
}

// ─── Master draw call ─────────────────────────────────────────────────────────

function drawWorld(
  ctx: CanvasRenderingContext2D,
  state: WorldState,
  width: number,
  height: number,
): void {
  // Heartbeat — the world breathes
  // pulse_scale(t) = 1 + 0.03·sin(2π·Beat(t)/period)
  const pulseScale = 1.0 + 0.03 * Math.sin(state.pulsePhase);
  const bgLum = Math.round(7 + 5 * Math.sin(state.pulsePhase));

  // Clear
  ctx.fillStyle = `rgb(${bgLum},${bgLum},${bgLum + 2})`;
  ctx.fillRect(0, 0, width, height);

  // Apply heartbeat canvas transform
  ctx.save();
  ctx.translate(width / 2, height / 2);
  ctx.scale(pulseScale, pulseScale);
  ctx.translate(-width / 2, -height / 2);

  // Layer 1: Territory fill — faction influence fields
  drawTerritoryLayer(ctx, state);

  // Layer 2: Biome atmosphere — emergent from cell state
  drawBiomeLayer(ctx, state);

  // Layer 3: Frontier glows — borders at faction boundaries
  drawFrontierLayer(ctx, state);

  // Layer 4: World scars — persistent battle history
  drawScarLayer(ctx, state);

  // Layer 5: Infrastructure — routes, hubs, fortresses
  drawInfraLayer(ctx, state);

  // Layer 6: Synaptic sparks — Hebbian Δwᵢⱼ
  drawSparksLayer(ctx, state);

  // Layer 7: Explosions — P(hit)·damage at defender position
  drawExplosionsLayer(ctx, state);

  // Layer 8: Drones — positions ARE the boid equation output
  drawDronesLayer(ctx, state);

  // Layer 9: Domain overlays — new domains unlock from macro thresholds
  drawDomainOverlays(ctx, state, width, height);

  // Contested zone marker
  if (state.explosions.length > 0) {
    let cx = 0;
    let cy = 0;
    for (const e of state.explosions) {
      cx += e.pos.x;
      cy += e.pos.y;
    }
    cx /= state.explosions.length;
    cy /= state.explosions.length;
    ctx.strokeStyle = `rgba(255,100,50,${0.28 + 0.18 * Math.sin(state.pulsePhase * 3)})`;
    ctx.lineWidth = 1.5;
    ctx.setLineDash([3, 5]);
    ctx.beginPath();
    ctx.arc(cx, cy, 22, 0, 2 * Math.PI);
    ctx.stroke();
    ctx.setLineDash([]);
    ctx.fillStyle = "rgba(255,80,40,0.70)";
    ctx.font = "bold 8px monospace";
    ctx.textAlign = "center";
    ctx.fillText("CONTESTED", cx, cy - 26);
  }

  ctx.restore(); // end heartbeat transform

  // Watermarks — beat, era, global state
  ctx.fillStyle = "rgba(255,255,255,0.07)";
  ctx.font = "bold 10px monospace";
  ctx.textAlign = "left";
  ctx.fillText(
    `BEAT ${state.beat}  ·  ERA:${state.era.toUpperCase()}  ·  ESC ${(state.escalation * 100).toFixed(1)}%`,
    10,
    height - 10,
  );
  if (state.domainFlags.cyber)
    ctx.fillText("[ CYBER ]", width - 200, height - 10);
  if (state.domainFlags.space)
    ctx.fillText("[ SPACE ]", width - 130, height - 10);
  if (state.domainFlags.deep) ctx.fillText("[ DEEP ]", width - 65, height - 10);
}

// ─── Faction HUD sidebar ──────────────────────────────────────────────────────

const DRIVE_COLORS: Record<string, string> = {
  Execution: "text-emerald-400",
  Exploration: "text-amber-400",
  Learning: "text-blue-400",
  Rest: "text-slate-500",
};

function FactionRow({ faction }: { faction: Faction }) {
  const hue = factionHue(faction.id);
  const color = `hsl(${hue},70%,58%)`;
  const barPct = `${(faction.coherence * 100).toFixed(1)}%`;
  return (
    <div className="py-1.5 border-b border-border/40 last:border-0">
      <div className="flex items-center justify-between mb-1">
        <div className="flex items-center gap-1.5">
          <div
            className="w-2 h-2 rounded-full shrink-0"
            style={{ background: color }}
          />
          <span className="text-[10px] font-bold font-mono text-foreground">
            {faction.name}
          </span>
          <span
            className={`text-[8px] uppercase font-semibold ${DRIVE_COLORS[faction.driveMode]}`}
          >
            {faction.driveMode.slice(0, 3)}
          </span>
        </div>
        <span className="text-[9px] font-mono text-muted-foreground/50">
          {barPct}
        </span>
      </div>
      <div className="h-1 bg-surface-elevated rounded-full overflow-hidden">
        <div
          className="h-full rounded-full transition-all duration-500"
          style={{ width: barPct, background: color }}
        />
      </div>
      <div className="flex gap-2 mt-0.5">
        <span className="text-[8px] font-mono text-muted-foreground/30">
          ATK {(faction.actionAttack * 100).toFixed(0)}
        </span>
        <span className="text-[8px] font-mono text-muted-foreground/30">
          EVD {(faction.actionEvade * 100).toFixed(0)}
        </span>
        <span className="text-[8px] font-mono text-muted-foreground/30 ml-auto">
          ⚡{faction.lawsFired}
        </span>
      </div>
    </div>
  );
}

// ─── World stats panel ────────────────────────────────────────────────────────

function WorldStats({ state }: { state: WorldState | null }) {
  if (!state) return null;

  const activeInfraCount = state.infraObjects.filter(
    (o) => o.maturity > 0.1,
  ).length;
  const avgCoherence =
    state.factions.reduce((s, f) => s + f.coherence, 0) / state.factions.length;
  const biomeCounts: Partial<Record<string, number>> = {};
  for (const cell of state.grid) {
    biomeCounts[cell.biome] = (biomeCounts[cell.biome] ?? 0) + 1;
  }
  const sorted = Object.entries(biomeCounts).sort(
    (a, b) => (b[1] ?? 0) - (a[1] ?? 0),
  );
  const dominantBiome = sorted[0]?.[0] ?? "neutral";

  return (
    <div className="px-3 py-2 border-t border-border space-y-1 shrink-0">
      {[
        ["Avg Coherence", `${(avgCoherence * 100).toFixed(1)}%`],
        ["Drones", state.drones.length],
        ["Sparks", state.sparks.length],
        ["Scars", state.scars.length],
        ["Infra Objects", activeInfraCount],
        ["Dominant Biome", dominantBiome],
        ["World Age", state.worldAge],
      ].map(([label, value]) => (
        <div key={String(label)} className="flex justify-between">
          <span className="text-[8px] text-muted-foreground/40">{label}</span>
          <span className="text-[8px] font-mono text-muted-foreground/65">
            {value}
          </span>
        </div>
      ))}
    </div>
  );
}

// ─── Main component ───────────────────────────────────────────────────────────

export function MacroWorldCanvas() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const worldRef = useRef<WorldState | null>(null);
  const rafRef = useRef<number>(0);
  const lastTimeRef = useRef<number>(0);
  const [isRunning, setIsRunning] = useState(true);
  const [hudState, setHudState] = useState<WorldState | null>(null);
  const isRunningRef = useRef(true);
  const [canvasDims, setCanvasDims] = useState({ w: 800, h: 500 });

  // Responsive sizing
  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;
    const obs = new ResizeObserver((entries) => {
      for (const entry of entries) {
        const { width, height } = entry.contentRect;
        if (width > 0 && height > 0)
          setCanvasDims({ w: Math.floor(width), h: Math.floor(height) });
      }
    });
    obs.observe(container);
    const rect = container.getBoundingClientRect();
    if (rect.width > 0 && rect.height > 0)
      setCanvasDims({ w: Math.floor(rect.width), h: Math.floor(rect.height) });
    return () => obs.disconnect();
  }, []);

  // Reinitialize world when canvas size changes significantly
  useEffect(() => {
    if (canvasDims.w < 100 || canvasDims.h < 100) return;
    worldRef.current = initWorld(canvasDims.w, canvasDims.h);
  }, [canvasDims.w, canvasDims.h]);

  useEffect(() => {
    isRunningRef.current = isRunning;
  }, [isRunning]);

  // Animation loop
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    let frame = 0;

    function loop(timestamp: number) {
      const dt = lastTimeRef.current
        ? Math.min(timestamp - lastTimeRef.current, 80)
        : 16;
      lastTimeRef.current = timestamp;

      if (isRunningRef.current) {
        if (!worldRef.current)
          worldRef.current = initWorld(canvasDims.w, canvasDims.h);
        worldRef.current = tickWorld(
          worldRef.current,
          dt,
          canvasDims.w,
          canvasDims.h,
        );
      }

      if (worldRef.current && canvas) {
        drawWorld(ctx!, worldRef.current, canvas.width, canvas.height);
      }

      frame++;
      if (frame % 10 === 0 && worldRef.current) setHudState(worldRef.current);

      rafRef.current = requestAnimationFrame(loop);
    }

    rafRef.current = requestAnimationFrame(loop);
    return () => {
      cancelAnimationFrame(rafRef.current);
      lastTimeRef.current = 0;
    };
  }, [canvasDims]);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center gap-3 px-4 py-2.5 border-b border-border shrink-0">
        <div className="flex items-center gap-2">
          <Globe className="w-3.5 h-3.5 text-primary" />
          <span className="text-[11px] font-bold uppercase tracking-widest text-foreground">
            Macro World Engine
          </span>
        </div>
        <div className="hidden sm:flex items-center gap-1.5 text-[8px] font-mono text-muted-foreground/30 ml-1">
          <span>law → state → gradients → world</span>
        </div>
        <div className="ml-auto flex items-center gap-2 flex-wrap">
          {hudState?.domainFlags.cyber && (
            <div className="flex items-center gap-1 px-1.5 py-0.5 rounded border border-blue-500/30 bg-blue-500/5">
              <Shield className="w-2.5 h-2.5 text-blue-400" />
              <span className="text-[9px] font-semibold uppercase tracking-widest text-blue-400">
                CYBER
              </span>
            </div>
          )}
          {hudState?.domainFlags.space && (
            <div className="flex items-center gap-1 px-1.5 py-0.5 rounded border border-purple-500/30 bg-purple-500/5">
              <Rocket className="w-2.5 h-2.5 text-purple-400" />
              <span className="text-[9px] font-semibold uppercase tracking-widest text-purple-400">
                SPACE
              </span>
            </div>
          )}
          {hudState?.domainFlags.deep && (
            <div className="flex items-center gap-1 px-1.5 py-0.5 rounded border border-indigo-500/30 bg-indigo-500/5">
              <Activity className="w-2.5 h-2.5 text-indigo-400" />
              <span className="text-[9px] font-semibold uppercase tracking-widest text-indigo-400">
                DEEP
              </span>
            </div>
          )}
          {hudState && (
            <div className="flex items-center gap-1 px-1.5 py-0.5 rounded border border-border">
              <Zap className="w-2.5 h-2.5 text-amber-400" />
              <span className="text-[9px] font-mono text-amber-400">
                ESC {(hudState.escalation * 100).toFixed(1)}%
              </span>
            </div>
          )}
          {hudState && (
            <div className="flex items-center gap-1 px-1.5 py-0.5 rounded border border-border">
              <Activity className="w-2.5 h-2.5 text-muted-foreground/50" />
              <span className="text-[9px] font-mono text-muted-foreground/50">
                BEAT {hudState.beat} · {hudState.era.toUpperCase()}
              </span>
            </div>
          )}
          <button
            type="button"
            onClick={() => setIsRunning((v) => !v)}
            className={`flex items-center gap-1 px-2 py-1 rounded border text-[9px] font-semibold uppercase tracking-widest transition-colors ${
              isRunning
                ? "text-primary border-primary/30 bg-primary/5"
                : "text-muted-foreground border-border"
            }`}
          >
            <RefreshCw
              className={`w-2.5 h-2.5 ${isRunning ? "animate-spin" : ""}`}
              style={isRunning ? { animationDuration: "3s" } : {}}
            />
            {isRunning ? "LIVE" : "PAUSED"}
          </button>
        </div>
      </div>

      {/* Canvas + HUD */}
      <div className="flex flex-1 overflow-hidden min-h-0">
        <div ref={containerRef} className="flex-1 relative overflow-hidden">
          <canvas
            ref={canvasRef}
            width={canvasDims.w}
            height={canvasDims.h}
            className="absolute inset-0 w-full h-full"
          />
          <div className="absolute top-2 left-2 text-[7px] font-mono text-white/15 pointer-events-none select-none">
            MUSE · UNIVERSAL RENDERER · TERRITORY · BIOME · INFRA · SCARS ·
            DRONES · SPARKS · DOMAINS
          </div>
        </div>

        {/* Faction HUD */}
        <div className="w-44 shrink-0 border-l border-border flex flex-col overflow-hidden">
          <div className="px-3 py-2 border-b border-border shrink-0">
            <span className="text-[9px] uppercase tracking-widest font-semibold text-muted-foreground/40">
              10 Factions
            </span>
          </div>
          <ScrollArea className="flex-1">
            <div className="px-3 py-1">
              {(hudState?.factions ?? []).map((f) => (
                <FactionRow key={f.id} faction={f} />
              ))}
            </div>
          </ScrollArea>
          <WorldStats state={hudState} />
        </div>
      </div>

      {/* Legend footer */}
      <div className="px-4 py-1.5 border-t border-border shrink-0 flex items-center gap-3 flex-wrap">
        {[
          { label: "Territory", formula: "S(t)·influence" },
          { label: "Biome", formula: "stability·memory·conflict" },
          { label: "Frontier", formula: "faction boundary" },
          { label: "Scar", formula: "P(hit)·damage·history" },
          { label: "Infra", formula: "law_density·age" },
          { label: "Heartbeat", formula: "1+0.03·sin(2πt)" },
        ].map(({ label, formula }) => (
          <div key={label} className="flex items-center gap-1">
            <span className="text-[7px] text-muted-foreground/25 uppercase tracking-widest">
              {label}
            </span>
            <span className="text-[7px] font-mono text-primary/35">
              {formula}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
