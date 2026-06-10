/**
 * SecurityShield — Layer 2 Client-Side Security Status Component
 *
 * Production React component displaying real-time security status for the
 * three-layer bot protection architecture (Medina Doctrine).
 *
 * Displays:
 *   - Security state badge: OPTIMUS (green) / ELEVATED (amber) / SOVEREIGN (red)
 *   - Real-time metrics: bot score, rate per min, rejected count, layer 3 status
 *   - Live φ-deviation indicator
 *   - Per-layer status (Edge / Browser / Canister)
 *
 * Usage:
 *   <SecurityShield />                     ← compact badge mode
 *   <SecurityShield expanded />            ← full metrics panel
 *   <SecurityShield onBlock={callback} />  ← react to block events
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { useEffect, useState } from "react";
import { useEdgeSecurity, type SecurityState } from "../hooks/useEdgeSecurity";

// ─── Types ────────────────────────────────────────────────────────────────────

interface Layer3Status {
  layer3_inspect_total:    number;
  layer3_inspect_passed:   number;
  layer3_inspect_rejected: number;
  layer3_coherence:        number;
  layer3_gate_open:        boolean;
  layer3_rate_bucket:      number;
  layer3_rate_limit_max:   number;
  layer1_edge_rejections:  number;
  layer2_edge_rejections:  number;
  total_edge_reports:      number;
  gate_admissions:         number;
  gate_rejections:         number;
  phi_inv_threshold:       number;
  doctrine:                string;
}

interface SecurityShieldProps {
  expanded?: boolean;
  onBlock?: (reason: string) => void;
  /** Optional canister actor with getSecurityStatus() */
  actor?: { getSecurityStatus: () => Promise<Layer3Status> };
}

// ─── Colour tokens ────────────────────────────────────────────────────────────

const STATE_COLORS: Record<SecurityState, { bg: string; text: string; ring: string; dot: string }> = {
  optimus:   { bg: "bg-emerald-950", text: "text-emerald-400",  ring: "ring-emerald-700",  dot: "bg-emerald-400"  },
  elevated:  { bg: "bg-amber-950",   text: "text-amber-400",    ring: "ring-amber-600",    dot: "bg-amber-400"    },
  sovereign: { bg: "bg-red-950",     text: "text-red-400",      ring: "ring-red-600",      dot: "bg-red-400 animate-pulse" },
};

// ─── Helper formatters ────────────────────────────────────────────────────────

const PHI_INV = 0.6180339887498949;

function fmt(n: number, decimals = 3): string {
  return n.toFixed(decimals);
}

function scoreBar(score: number): string {
  const pct = Math.min(score / PHI_INV, 1) * 100;
  const filled = Math.round(pct / 10);
  return "█".repeat(filled) + "░".repeat(10 - filled);
}

function rateBar(rate: number): string {
  const pct = Math.min(rate / 89, 1) * 100;
  const filled = Math.round(pct / 10);
  return "█".repeat(filled) + "░".repeat(10 - filled);
}

// ─── Layer status pill ────────────────────────────────────────────────────────

function LayerPill({ label, ok, detail }: { label: string; ok: boolean; detail?: string }) {
  return (
    <div className={`flex items-center gap-1.5 rounded px-2 py-0.5 text-xs font-mono ${ok ? "bg-emerald-900/40 text-emerald-400" : "bg-red-900/40 text-red-400"}`}>
      <span className={`h-1.5 w-1.5 rounded-full ${ok ? "bg-emerald-400" : "bg-red-400"}`} />
      <span>{label}</span>
      {detail && <span className="opacity-60">{detail}</span>}
    </div>
  );
}

// ─── Main component ───────────────────────────────────────────────────────────

export function SecurityShield({ expanded = false, onBlock, actor }: SecurityShieldProps) {
  const {
    securityState,
    isBlocked,
    botScore,
    ratePerMin,
    totalChecked,
    totalRejected,
    rateBucket,
  } = useEdgeSecurity();

  const [layer3, setLayer3] = useState<Layer3Status | null>(null);
  const [l3Error, setL3Error] = useState(false);

  // Poll Layer 3 status every 5 seconds when expanded + actor provided
  useEffect(() => {
    if (!expanded || !actor) return;
    let active = true;
    const poll = async () => {
      try {
        const status = await actor.getSecurityStatus();
        if (active) setLayer3(status);
      } catch {
        if (active) setL3Error(true);
      }
    };
    void poll();
    const id = setInterval(() => void poll(), 5000);
    return () => { active = false; clearInterval(id); };
  }, [expanded, actor]);

  // Notify parent on block
  useEffect(() => {
    if (isBlocked && onBlock) onBlock("phi-deviation-layer-2");
  }, [isBlocked, onBlock]);

  const colors = STATE_COLORS[securityState];
  const label  = securityState.toUpperCase();

  // ── Compact badge mode ────────────────────────────────────────────────────────
  if (!expanded) {
    return (
      <div
        className={`inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-mono ring-1 ${colors.bg} ${colors.text} ${colors.ring}`}
        title={`Security: ${label} | Bot score: ${fmt(botScore)} | Rate: ${ratePerMin}/min`}
      >
        <span className={`h-2 w-2 rounded-full ${colors.dot}`} />
        <span>SHIELD</span>
        <span className="opacity-70">{label}</span>
        {isBlocked && <span className="ml-1 rounded bg-red-600 px-1 text-white">BLOCKED</span>}
      </div>
    );
  }

  // ── Expanded metrics panel ────────────────────────────────────────────────────
  return (
    <div className={`rounded-xl border border-zinc-800 ${colors.bg}/30 bg-zinc-950 p-4 font-mono text-xs ring-1 ${colors.ring}/40 space-y-3`}>
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className={`h-2.5 w-2.5 rounded-full ${colors.dot}`} />
          <span className={`text-sm font-semibold ${colors.text}`}>SECURITY SHIELD</span>
          <span className={`rounded px-1.5 py-0.5 text-[10px] ring-1 ${colors.bg} ${colors.text} ${colors.ring}`}>{label}</span>
        </div>
        {isBlocked && (
          <span className="rounded bg-red-700 px-2 py-0.5 text-[10px] font-bold text-white tracking-widest">
            BLOCKED
          </span>
        )}
      </div>

      {/* φ-deviation score */}
      <div className="space-y-1">
        <div className="flex justify-between text-zinc-400">
          <span>φ-deviation score</span>
          <span className={botScore > PHI_INV ? "text-red-400" : "text-emerald-400"}>
            {fmt(botScore)} / {fmt(PHI_INV)} (φ⁻¹)
          </span>
        </div>
        <div className="text-zinc-500 tracking-widest">{scoreBar(botScore)}</div>
      </div>

      {/* Request rate */}
      <div className="space-y-1">
        <div className="flex justify-between text-zinc-400">
          <span>request rate / 60 s</span>
          <span className={rateBucket > 55 ? "text-amber-400" : "text-emerald-400"}>
            {rateBucket} / 89 (F11)
          </span>
        </div>
        <div className="text-zinc-500 tracking-widest">{rateBar(rateBucket)}</div>
      </div>

      {/* Counters */}
      <div className="grid grid-cols-3 gap-2 rounded-lg bg-zinc-900/60 p-2">
        <div className="text-center">
          <div className="text-zinc-500">checked</div>
          <div className="text-zinc-200">{totalChecked}</div>
        </div>
        <div className="text-center">
          <div className="text-zinc-500">rejected</div>
          <div className={totalRejected > 0 ? "text-red-400" : "text-emerald-400"}>{totalRejected}</div>
        </div>
        <div className="text-center">
          <div className="text-zinc-500">rate/min</div>
          <div className="text-zinc-200">{ratePerMin}</div>
        </div>
      </div>

      {/* Layer status */}
      <div className="space-y-1">
        <div className="text-zinc-500">layers</div>
        <div className="flex flex-wrap gap-1">
          <LayerPill label="L1 EDGE"   ok={true} detail="VIGILIA+UMBRA" />
          <LayerPill label="L2 BROWSER" ok={!isBlocked} detail={isBlocked ? "BLOCKED" : "active"} />
          <LayerPill
            label="L3 CANISTER"
            ok={layer3 ? layer3.layer3_gate_open : true}
            detail={layer3 ? `R=${fmt(layer3.layer3_coherence, 2)}` : l3Error ? "err" : "…"}
          />
        </div>
      </div>

      {/* Layer 3 canister metrics (when available) */}
      {layer3 && (
        <div className="space-y-1 rounded-lg bg-zinc-900/60 p-2">
          <div className="text-zinc-500 mb-1">canister gate (Layer 3)</div>
          <div className="grid grid-cols-2 gap-x-4 gap-y-0.5 text-zinc-400">
            <span>coherence R</span>
            <span className={layer3.layer3_coherence >= layer3.phi_inv_threshold ? "text-emerald-400" : "text-red-400"}>
              {fmt(layer3.layer3_coherence)}
            </span>
            <span>gate open</span>
            <span className={layer3.layer3_gate_open ? "text-emerald-400" : "text-amber-400"}>
              {layer3.layer3_gate_open ? "yes" : "no"}
            </span>
            <span>admitted</span>
            <span className="text-zinc-300">{layer3.gate_admissions.toString()}</span>
            <span>rejected</span>
            <span className={layer3.gate_rejections > 0 ? "text-red-400" : "text-zinc-300"}>
              {layer3.gate_rejections.toString()}
            </span>
            <span>L1 edge blocks</span>
            <span className="text-zinc-300">{layer3.layer1_edge_rejections.toString()}</span>
            <span>rate bucket</span>
            <span className="text-zinc-300">{layer3.layer3_rate_bucket.toString()} / {layer3.layer3_rate_limit_max.toString()}</span>
          </div>
        </div>
      )}

      {/* Doctrine */}
      <div className="rounded bg-zinc-900/40 px-2 py-1 text-zinc-600 leading-snug">
        Medina Doctrine · Three-Layer Zero-Cycle Bot Rejection ·{" "}
        <span className="text-zinc-500">φ⁻¹ = {fmt(PHI_INV)}</span>
      </div>
    </div>
  );
}
