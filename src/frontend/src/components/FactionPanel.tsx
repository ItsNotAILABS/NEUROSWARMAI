import type React from "react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

// ---------------------------------------------------------------------------
// Import types from factionEngine — wired to the actual simulation
// ---------------------------------------------------------------------------
import type {
  UIDiplomaticStance as DiplomaticStance,
  UIFaction as Faction,
  UIFactionDiplomacy as FactionDiplomacy,
  UIFactionEvent as FactionEvent,
  UIFactionResource as FactionResource,
  UIPowerTier as PowerTier,
} from "../data/factionEngine";

// Re-export types for consumers
export type {
  DiplomaticStance,
  PowerTier,
  FactionDiplomacy,
  FactionResource,
  FactionEvent,
  Faction,
};

// Local archetype type for UI
export type FactionArchetype =
  | "militarist"
  | "mercantile"
  | "ecclesiastic"
  | "technocratic"
  | "nomadic"
  | "isolationist"
  | "expansionist"
  | "fortifier"
  | "diplomat"
  | "exploiter"
  | "phantom"
  | "zealot"
  | "merchant"
  | "scavenger";

export interface FactionPanelProps {
  factions: Faction[];
  tick: number;
  onSelectFaction: (factionId: string) => void;
}

// ---------------------------------------------------------------------------
// Utility helpers
// ---------------------------------------------------------------------------

function stanceColor(stance: DiplomaticStance): string {
  const map: Record<DiplomaticStance, string> = {
    war: "bg-red-700 text-red-100",
    hostile: "bg-orange-700 text-orange-100",
    neutral: "bg-gray-600 text-gray-200",
    friendly: "bg-green-700 text-green-100",
    allied: "bg-cyan-700 text-cyan-100",
    vassal: "bg-purple-700 text-purple-100",
    suzerain: "bg-yellow-700 text-yellow-100",
  };
  return map[stance] ?? "bg-gray-700 text-gray-200";
}

function tierColor(tier: PowerTier): string {
  const map: Record<PowerTier, string> = {
    Hegemon: "bg-yellow-500 text-yellow-950",
    Major: "bg-blue-500 text-blue-950",
    Minor: "bg-gray-500 text-gray-950",
    Remnant: "bg-stone-700 text-stone-200",
  };
  return map[tier];
}

function severityColor(s: FactionEvent["severity"]): string {
  const map = {
    low: "text-gray-400",
    medium: "text-yellow-400",
    high: "text-orange-400",
    critical: "text-red-400",
  };
  return map[s];
}

function eventIcon(type: FactionEvent["type"]): string {
  const map: Record<FactionEvent["type"], string> = {
    battle: "⚔️",
    treaty: "🤝",
    expansion: "🏴",
    collapse: "💀",
    election: "🗳️",
    trade: "💰",
    schism: "⚡",
    miracle: "✨",
  };
  return map[type] ?? "📋";
}

function archetypeIcon(arch: FactionArchetype | string): string {
  const map: Record<string, string> = {
    militarist: "⚔️",
    mercantile: "💱",
    ecclesiastic: "🕍",
    technocratic: "🔬",
    nomadic: "🌀",
    isolationist: "🛡️",
    // Engine archetypes
    expansionist: "🏴",
    fortifier: "🏰",
    diplomat: "🤝",
    exploiter: "⛏️",
    phantom: "👻",
    zealot: "✦",
    merchant: "💰",
    scavenger: "🦴",
  };
  return map[arch] ?? "⬢";
}

function formatTick(tick: number): string {
  const day = Math.floor(tick / 24);
  const hour = tick % 24;
  return `Day ${day} ${String(hour).padStart(2, "0")}:00`;
}

// ---------------------------------------------------------------------------
// FactionRankBadge
// ---------------------------------------------------------------------------

interface FactionRankBadgeProps {
  tier: PowerTier;
  rank: number;
}

const FactionRankBadge: React.FC<FactionRankBadgeProps> = ({ tier, rank }) => (
  <span
    className={`inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-xs font-bold ${tierColor(tier)}`}
  >
    #{rank} {tier}
  </span>
);

// ---------------------------------------------------------------------------
// FactionResourceBar
// ---------------------------------------------------------------------------

interface FactionResourceBarProps {
  label: string;
  value: number;
  max: number;
  color: string;
}

const FactionResourceBar: React.FC<FactionResourceBarProps> = ({
  label,
  value,
  max,
  color,
}) => {
  const pct = Math.min(100, Math.max(0, (value / max) * 100));
  return (
    <div className="flex flex-col gap-0.5">
      <div className="flex justify-between text-xs text-gray-400">
        <span>{label}</span>
        <span>{value.toLocaleString()}</span>
      </div>
      <div className="h-1.5 w-full rounded-full bg-gray-700">
        <div
          className={`h-1.5 rounded-full transition-all duration-500 ${color}`}
          style={{ width: `${pct}%` }}
        />
      </div>
    </div>
  );
};

// ---------------------------------------------------------------------------
// DiplomacyMatrix
// ---------------------------------------------------------------------------

interface DiplomacyMatrixProps {
  factions: Faction[];
  focusedFactionId: string | null;
}

const DiplomacyMatrix: React.FC<DiplomacyMatrixProps> = ({
  factions,
  focusedFactionId,
}) => {
  const focused = factions.find((f) => f.id === focusedFactionId);
  if (!focused) {
    return (
      <div className="text-gray-500 text-sm p-3">
        Select a faction to view diplomacy.
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-2">
      <h3 className="text-xs font-semibold uppercase tracking-widest text-gray-400">
        {focused.sigil} {focused.name} — Diplomatic Relations
      </h3>
      <div className="grid grid-cols-1 gap-1">
        {factions
          .filter((f) => f.id !== focusedFactionId)
          .map((other) => {
            const rel = focused.diplomacy.find(
              (d) => d.targetFactionId === other.id,
            );
            const stance: DiplomaticStance = rel?.stance ?? "neutral";
            const trust = rel?.trustLevel ?? 50;
            return (
              <div
                key={other.id}
                className="flex items-center justify-between rounded bg-gray-800 px-3 py-1.5"
              >
                <div className="flex items-center gap-2 text-sm text-gray-200">
                  <span>{other.sigil}</span>
                  <span>{other.name}</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-20 h-1 bg-gray-700 rounded-full">
                    <div
                      className="h-1 bg-cyan-500 rounded-full"
                      style={{ width: `${trust}%` }}
                    />
                  </div>
                  <span
                    className={`rounded px-1.5 py-0.5 text-xs font-semibold ${stanceColor(stance)}`}
                  >
                    {stance.toUpperCase()}
                  </span>
                </div>
              </div>
            );
          })}
      </div>
    </div>
  );
};

// ---------------------------------------------------------------------------
// FactionEventFeed
// ---------------------------------------------------------------------------

interface FactionEventFeedProps {
  events: FactionEvent[];
  factions: Faction[];
  filterFactionId: string | null;
  currentTick: number;
}

const FactionEventFeed: React.FC<FactionEventFeedProps> = ({
  events,
  factions,
  filterFactionId,
  currentTick,
}) => {
  const factionMap = useMemo(() => {
    const m: Record<string, Faction> = {};
    for (const f of factions) {
      m[f.id] = f;
    }
    return m;
  }, [factions]);

  const filtered = useMemo(() => {
    const base = filterFactionId
      ? events.filter((e) => e.factionId === filterFactionId)
      : events;
    return [...base].sort((a, b) => b.tick - a.tick).slice(0, 20);
  }, [events, filterFactionId]);

  return (
    <div className="flex flex-col gap-0.5 max-h-72 overflow-y-auto pr-1">
      {filtered.length === 0 && (
        <div className="text-gray-500 text-sm p-2">No events recorded.</div>
      )}
      {filtered.map((ev) => {
        const faction = factionMap[ev.factionId];
        const tickDelta = currentTick - ev.tick;
        return (
          <div
            key={ev.id}
            className="flex items-start gap-2 rounded bg-gray-800/60 px-2 py-1.5 hover:bg-gray-800 transition-colors"
          >
            <span className="text-base leading-none mt-0.5">
              {eventIcon(ev.type)}
            </span>
            <div className="flex flex-col flex-1 min-w-0">
              <div className="flex items-center gap-1 text-xs text-gray-500">
                <span className="font-mono">{formatTick(ev.tick)}</span>
                {tickDelta > 0 && (
                  <span className="text-gray-600">({tickDelta}t ago)</span>
                )}
                {faction && (
                  <span style={{ color: faction.color }}>
                    {faction.sigil} {faction.name}
                  </span>
                )}
              </div>
              <p
                className={`text-xs leading-tight truncate ${severityColor(ev.severity)}`}
              >
                {ev.description}
              </p>
            </div>
          </div>
        );
      })}
    </div>
  );
};

// ---------------------------------------------------------------------------
// AllianceGraph (SVG-based simple network)
// ---------------------------------------------------------------------------

interface AllianceGraphProps {
  factions: Faction[];
  onSelectFaction: (id: string) => void;
}

const GRAPH_W = 340;
const GRAPH_H = 220;

function placeFactionNodes(
  factions: Faction[],
): Record<string, [number, number]> {
  const positions: Record<string, [number, number]> = {};
  const n = factions.length;
  factions.forEach((f, i) => {
    const angle = (2 * Math.PI * i) / n - Math.PI / 2;
    const rx = GRAPH_W / 2 - 36;
    const ry = GRAPH_H / 2 - 28;
    positions[f.id] = [
      GRAPH_W / 2 + rx * Math.cos(angle),
      GRAPH_H / 2 + ry * Math.sin(angle),
    ];
  });
  return positions;
}

const AllianceGraph: React.FC<AllianceGraphProps> = ({
  factions,
  onSelectFaction,
}) => {
  const positions = useMemo(() => placeFactionNodes(factions), [factions]);

  const edges = useMemo(() => {
    const seen = new Set<string>();
    const result: Array<{
      from: string;
      to: string;
      stance: DiplomaticStance;
    }> = [];
    for (const f of factions) {
      for (const d of f.diplomacy) {
        if (d.stance === "neutral") continue;
        const key = [f.id, d.targetFactionId].sort().join(":");
        if (seen.has(key)) continue;
        seen.add(key);
        result.push({ from: f.id, to: d.targetFactionId, stance: d.stance });
      }
    }
    return result;
  }, [factions]);

  const edgeStrokeColor: Record<DiplomaticStance, string> = {
    war: "#dc2626",
    hostile: "#ea580c",
    neutral: "#6b7280",
    friendly: "#16a34a",
    allied: "#06b6d4",
    vassal: "#a855f7",
    suzerain: "#eab308",
  };

  return (
    <svg
      width={GRAPH_W}
      height={GRAPH_H}
      className="rounded bg-gray-900 border border-gray-700 select-none"
      role="img"
      aria-label="Faction diplomacy graph"
    >
      {edges.map((e) => {
        const from = positions[e.from];
        const to = positions[e.to];
        if (!from || !to) return null;
        return (
          <line
            key={`${e.from}-${e.to}`}
            x1={from[0]}
            y1={from[1]}
            x2={to[0]}
            y2={to[1]}
            stroke={edgeStrokeColor[e.stance]}
            strokeWidth={
              e.stance === "war" || e.stance === "allied" ? 2.5 : 1.5
            }
            strokeDasharray={
              e.stance === "hostile" || e.stance === "war" ? "4,3" : undefined
            }
            opacity={0.7}
          />
        );
      })}
      {factions.map((f) => {
        const pos = positions[f.id];
        if (!pos) return null;
        return (
          <g
            key={f.id}
            transform={`translate(${pos[0]},${pos[1]})`}
            onClick={() => onSelectFaction(f.id)}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ") {
                e.preventDefault();
                onSelectFaction(f.id);
              }
            }}
            tabIndex={0}
            style={{ cursor: "pointer" }}
          >
            <circle r={16} fill={f.color} opacity={0.25} />
            <circle r={12} fill={f.color} opacity={0.6} />
            <text
              textAnchor="middle"
              dominantBaseline="central"
              fontSize={11}
              fill="#fff"
            >
              {f.sigil}
            </text>
            <text
              y={22}
              textAnchor="middle"
              fontSize={8}
              fill="#d1d5db"
              style={{ pointerEvents: "none" }}
            >
              {f.name.slice(0, 8)}
            </text>
          </g>
        );
      })}
    </svg>
  );
};

// ---------------------------------------------------------------------------
// FactionCard
// ---------------------------------------------------------------------------

interface FactionCardProps {
  faction: Faction;
  isSelected: boolean;
  onSelect: (id: string) => void;
}

const RESOURCE_MAX = 10000;

const FactionCard: React.FC<FactionCardProps> = ({
  faction,
  isSelected,
  onSelect,
}) => {
  const [expanded, setExpanded] = useState(false);

  const handleClick = useCallback(() => {
    onSelect(faction.id);
    setExpanded((e) => !e);
  }, [faction.id, onSelect]);

  const handleKeyDown = useCallback(
    (e: React.KeyboardEvent) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        handleClick();
      }
    },
    [handleClick],
  );

  const coherenceColor =
    faction.coherence > 70
      ? "bg-green-500"
      : faction.coherence > 40
        ? "bg-yellow-500"
        : "bg-red-500";

  return (
    <button
      type="button"
      className={`rounded-lg border transition-all duration-200 cursor-pointer ${
        isSelected
          ? "border-cyan-500 bg-gray-800 shadow-lg shadow-cyan-900/40"
          : "border-gray-700 bg-gray-850 hover:border-gray-500 hover:bg-gray-800"
      }`}
      onClick={handleClick}
      onKeyDown={handleKeyDown}
      tabIndex={0}
      style={
        isSelected ? { boxShadow: `0 0 0 1px ${faction.color}44` } : undefined
      }
    >
      {/* Header */}
      <div className="flex items-center gap-3 p-3">
        <div
          className="flex h-10 w-10 items-center justify-center rounded-full text-xl border-2"
          style={{
            borderColor: faction.color,
            background: `${faction.color}22`,
          }}
        >
          {faction.sigil}
        </div>
        <div className="flex flex-col flex-1 min-w-0">
          <div className="flex items-center gap-2">
            <span className="font-bold text-gray-100 truncate">
              {faction.name}
            </span>
            {faction.isPlayer && (
              <span className="text-xs bg-cyan-800 text-cyan-200 rounded px-1">
                YOU
              </span>
            )}
          </div>
          <div className="flex items-center gap-2 text-xs text-gray-400">
            <span>
              {archetypeIcon(faction.archetype)} {faction.archetype}
            </span>
            <span>·</span>
            <span>🏙 {faction.cellsControlled} cells</span>
            <span>·</span>
            <span>👥 {(faction.population / 1000).toFixed(1)}K</span>
          </div>
        </div>
        <div className="flex flex-col items-end gap-1">
          <FactionRankBadge tier={faction.powerTier} rank={1} />
        </div>
      </div>

      {/* Coherence bar */}
      <div className="px-3 pb-2">
        <div className="flex justify-between text-xs text-gray-500 mb-0.5">
          <span>Coherence</span>
          <span>{faction.coherence.toFixed(1)}%</span>
        </div>
        <div className="h-2 w-full rounded-full bg-gray-700">
          <div
            className={`h-2 rounded-full transition-all duration-700 ${coherenceColor}`}
            style={{ width: `${faction.coherence}%` }}
          />
        </div>
      </div>

      {/* Expanded section */}
      {expanded && (
        <div className="border-t border-gray-700 px-3 py-3 flex flex-col gap-3">
          {/* Resources */}
          <div className="flex flex-col gap-1.5">
            <h4 className="text-xs font-semibold uppercase tracking-widest text-gray-500">
              Resources
            </h4>
            <FactionResourceBar
              label="FORMA"
              value={faction.resources.forma}
              max={RESOURCE_MAX}
              color="bg-cyan-500"
            />
            <FactionResourceBar
              label="Food"
              value={faction.resources.food}
              max={RESOURCE_MAX}
              color="bg-green-500"
            />
            <FactionResourceBar
              label="Industry"
              value={faction.resources.industry}
              max={RESOURCE_MAX}
              color="bg-orange-500"
            />
            <FactionResourceBar
              label="Influence"
              value={faction.resources.influence}
              max={RESOURCE_MAX}
              color="bg-purple-500"
            />
          </div>

          {/* Recent events preview */}
          <div className="flex flex-col gap-1">
            <h4 className="text-xs font-semibold uppercase tracking-widest text-gray-500">
              Recent Events
            </h4>
            {faction.recentEvents.slice(0, 3).map((ev) => (
              <div
                key={ev.id}
                className="flex items-center gap-1.5 text-xs text-gray-400"
              >
                <span>{eventIcon(ev.type)}</span>
                <span
                  className={severityColor(ev.severity)}
                  style={{ flex: 1 }}
                >
                  {ev.description}
                </span>
                <span className="text-gray-600 font-mono text-xs shrink-0">
                  T{ev.tick}
                </span>
              </div>
            ))}
            {faction.recentEvents.length === 0 && (
              <span className="text-gray-600 text-xs">No recent events.</span>
            )}
          </div>
        </div>
      )}
    </button>
  );
};

// ---------------------------------------------------------------------------
// Power Rankings Panel
// ---------------------------------------------------------------------------

interface PowerRankingsPanelProps {
  factions: Faction[];
  onSelectFaction: (id: string) => void;
}

const TIER_ORDER: PowerTier[] = ["Hegemon", "Major", "Minor", "Remnant"];

const PowerRankingsPanel: React.FC<PowerRankingsPanelProps> = ({
  factions,
  onSelectFaction,
}) => {
  const grouped = useMemo(() => {
    const g: Partial<Record<PowerTier, Faction[]>> = {};
    for (const t of TIER_ORDER) {
      g[t] = factions.filter((f) => f.powerTier === t);
    }
    return g;
  }, [factions]);

  return (
    <div className="flex flex-col gap-3">
      {TIER_ORDER.map((tier) => {
        const members = grouped[tier] ?? [];
        if (members.length === 0) return null;
        return (
          <div key={tier}>
            <div
              className={`inline-flex items-center rounded-full px-3 py-0.5 text-xs font-bold mb-2 ${tierColor(tier)}`}
            >
              {tier === "Hegemon" ? "👑 " : ""}
              {tier}
            </div>
            <div className="grid grid-cols-2 gap-2">
              {members.map((f) => (
                <button
                  type="button"
                  key={f.id}
                  onClick={() => onSelectFaction(f.id)}
                  className="flex items-center gap-2 rounded bg-gray-800 px-2 py-1.5 text-left hover:bg-gray-700 transition-colors border border-gray-700 hover:border-gray-500"
                >
                  <span className="text-base" style={{ color: f.color }}>
                    {f.sigil}
                  </span>
                  <div className="flex flex-col min-w-0">
                    <span className="text-xs font-semibold text-gray-200 truncate">
                      {f.name}
                    </span>
                    <span className="text-xs text-gray-500">
                      {f.cellsControlled} cells
                    </span>
                  </div>
                </button>
              ))}
            </div>
          </div>
        );
      })}
    </div>
  );
};

// ---------------------------------------------------------------------------
// Main FactionPanel component
// ---------------------------------------------------------------------------

type Tab = "factions" | "diplomacy" | "rankings" | "events" | "graph";

export const FactionPanel: React.FC<FactionPanelProps> = ({
  factions,
  tick,
  onSelectFaction,
}) => {
  const [selectedFactionId, setSelectedFactionId] = useState<string | null>(
    null,
  );
  const [activeTab, setActiveTab] = useState<Tab>("factions");
  const [searchQuery, setSearchQuery] = useState("");
  const [sortBy, setSortBy] = useState<"rank" | "coherence" | "cells">("rank");
  const [filterTier, setFilterTier] = useState<PowerTier | "all">("all");

  const allEvents = useMemo(
    () => factions.flatMap((f) => f.recentEvents),
    [factions],
  );

  const handleSelectFaction = useCallback(
    (id: string) => {
      setSelectedFactionId(id);
      onSelectFaction(id);
    },
    [onSelectFaction],
  );

  const rankedFactions = useMemo(() => {
    const tierRank: Record<PowerTier, number> = {
      Hegemon: 0,
      Major: 1,
      Minor: 2,
      Remnant: 3,
    };
    return [...factions].sort((a, b) => {
      if (sortBy === "rank") {
        const td = tierRank[a.powerTier] - tierRank[b.powerTier];
        if (td !== 0) return td;
        return b.cellsControlled - a.cellsControlled;
      }
      if (sortBy === "coherence") return b.coherence - a.coherence;
      return b.cellsControlled - a.cellsControlled;
    });
  }, [factions, sortBy]);

  const filteredFactions = useMemo(() => {
    return rankedFactions.filter((f) => {
      const matchSearch =
        searchQuery === "" ||
        f.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        f.archetype.toLowerCase().includes(searchQuery.toLowerCase());
      const matchTier = filterTier === "all" || f.powerTier === filterTier;
      return matchSearch && matchTier;
    });
  }, [rankedFactions, searchQuery, filterTier]);

  const tabs: { key: Tab; label: string }[] = [
    { key: "factions", label: "Factions" },
    { key: "diplomacy", label: "Diplomacy" },
    { key: "rankings", label: "Rankings" },
    { key: "events", label: "Events" },
    { key: "graph", label: "Graph" },
  ];

  // Auto-select first faction
  useEffect(() => {
    if (!selectedFactionId && factions.length > 0) {
      setSelectedFactionId(factions[0].id);
    }
  }, [factions, selectedFactionId]);

  const tickRef = useRef(tick);
  tickRef.current = tick;

  return (
    <div className="flex flex-col h-full bg-gray-900 text-gray-100 rounded-xl border border-gray-700 overflow-hidden shadow-2xl">
      {/* Top bar */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-gray-700 bg-gray-900/90 backdrop-blur">
        <div className="flex items-center gap-2">
          <span className="text-lg">🌍</span>
          <h2 className="font-bold text-gray-100 tracking-tight">
            Faction Intelligence
          </h2>
          <span className="text-xs bg-gray-800 text-gray-400 rounded px-2 py-0.5 font-mono">
            T{tick}
          </span>
        </div>
        <div className="flex items-center gap-2 text-xs text-gray-500">
          <span>{factions.length} factions</span>
          <span>·</span>
          <span>
            {factions.reduce((s, f) => s + f.cellsControlled, 0)} cells
          </span>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex border-b border-gray-700 bg-gray-900/70">
        {tabs.map((t) => (
          <button
            type="button"
            key={t.key}
            onClick={() => setActiveTab(t.key)}
            className={`px-4 py-2 text-xs font-semibold uppercase tracking-widest transition-colors ${
              activeTab === t.key
                ? "text-cyan-400 border-b-2 border-cyan-500"
                : "text-gray-500 hover:text-gray-300"
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto px-3 py-3">
        {/* Factions Tab */}
        {activeTab === "factions" && (
          <div className="flex flex-col gap-3">
            {/* Search + filters */}
            <div className="flex gap-2">
              <input
                type="text"
                placeholder="Search factions..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="flex-1 rounded bg-gray-800 border border-gray-700 px-3 py-1.5 text-sm text-gray-200 placeholder-gray-600 focus:outline-none focus:border-cyan-600"
              />
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value as typeof sortBy)}
                className="rounded bg-gray-800 border border-gray-700 px-2 py-1.5 text-xs text-gray-300 focus:outline-none"
              >
                <option value="rank">By Rank</option>
                <option value="coherence">By Coherence</option>
                <option value="cells">By Cells</option>
              </select>
              <select
                value={filterTier}
                onChange={(e) =>
                  setFilterTier(e.target.value as typeof filterTier)
                }
                className="rounded bg-gray-800 border border-gray-700 px-2 py-1.5 text-xs text-gray-300 focus:outline-none"
              >
                <option value="all">All Tiers</option>
                {TIER_ORDER.map((t) => (
                  <option key={t} value={t}>
                    {t}
                  </option>
                ))}
              </select>
            </div>

            {/* Cards */}
            <div className="flex flex-col gap-2">
              {filteredFactions.map((faction) => (
                <FactionCard
                  key={faction.id}
                  faction={faction}
                  isSelected={selectedFactionId === faction.id}
                  onSelect={handleSelectFaction}
                />
              ))}
              {filteredFactions.length === 0 && (
                <div className="text-center text-gray-600 py-8 text-sm">
                  No factions match your filters.
                </div>
              )}
            </div>
          </div>
        )}

        {/* Diplomacy Tab */}
        {activeTab === "diplomacy" && (
          <div className="flex flex-col gap-4">
            <div className="flex gap-2 flex-wrap">
              {factions.map((f) => (
                <button
                  type="button"
                  key={f.id}
                  onClick={() => handleSelectFaction(f.id)}
                  className={`flex items-center gap-1.5 rounded-full px-3 py-1 text-xs font-semibold border transition-colors ${
                    selectedFactionId === f.id
                      ? "border-cyan-500 bg-cyan-900/40 text-cyan-300"
                      : "border-gray-700 bg-gray-800 text-gray-400 hover:border-gray-500"
                  }`}
                >
                  <span>{f.sigil}</span>
                  <span>{f.name}</span>
                </button>
              ))}
            </div>
            <DiplomacyMatrix
              factions={factions}
              focusedFactionId={selectedFactionId}
            />
            <div className="flex gap-2 flex-wrap text-xs mt-1">
              {(
                [
                  "war",
                  "hostile",
                  "neutral",
                  "friendly",
                  "allied",
                  "vassal",
                  "suzerain",
                ] as DiplomaticStance[]
              ).map((s) => (
                <span
                  key={s}
                  className={`rounded px-2 py-0.5 font-semibold ${stanceColor(s)}`}
                >
                  {s}
                </span>
              ))}
            </div>
          </div>
        )}

        {/* Rankings Tab */}
        {activeTab === "rankings" && (
          <PowerRankingsPanel
            factions={rankedFactions}
            onSelectFaction={handleSelectFaction}
          />
        )}

        {/* Events Tab */}
        {activeTab === "events" && (
          <div className="flex flex-col gap-3">
            <div className="flex items-center gap-2 flex-wrap">
              <span className="text-xs text-gray-500 uppercase tracking-widest">
                Filter by:
              </span>
              <button
                type="button"
                onClick={() => handleSelectFaction("")}
                className={`text-xs rounded-full px-3 py-0.5 border ${
                  !selectedFactionId
                    ? "border-cyan-500 text-cyan-300 bg-cyan-900/30"
                    : "border-gray-700 text-gray-400"
                }`}
              >
                All Factions
              </button>
              {factions.map((f) => (
                <button
                  type="button"
                  key={f.id}
                  onClick={() => handleSelectFaction(f.id)}
                  className={`text-xs rounded-full px-3 py-0.5 border ${
                    selectedFactionId === f.id
                      ? "border-cyan-500 text-cyan-300 bg-cyan-900/30"
                      : "border-gray-700 text-gray-400"
                  }`}
                >
                  {f.sigil} {f.name}
                </button>
              ))}
            </div>
            <FactionEventFeed
              events={allEvents}
              factions={factions}
              filterFactionId={selectedFactionId}
              currentTick={tick}
            />
          </div>
        )}

        {/* Graph Tab */}
        {activeTab === "graph" && (
          <div className="flex flex-col gap-4 items-center">
            <p className="text-xs text-gray-500 text-center">
              Node color = faction color. Edge color = diplomatic stance. Click
              a node to select.
            </p>
            <AllianceGraph
              factions={factions}
              onSelectFaction={handleSelectFaction}
            />
            {/* Legend */}
            <div className="flex flex-wrap gap-2 justify-center text-xs">
              {[
                {
                  stance: "war" as DiplomaticStance,
                  label: "War",
                  color: "#dc2626",
                },
                {
                  stance: "hostile" as DiplomaticStance,
                  label: "Hostile",
                  color: "#ea580c",
                },
                {
                  stance: "friendly" as DiplomaticStance,
                  label: "Friendly",
                  color: "#16a34a",
                },
                {
                  stance: "allied" as DiplomaticStance,
                  label: "Allied",
                  color: "#06b6d4",
                },
                {
                  stance: "vassal" as DiplomaticStance,
                  label: "Vassal",
                  color: "#a855f7",
                },
                {
                  stance: "suzerain" as DiplomaticStance,
                  label: "Suzerain",
                  color: "#eab308",
                },
              ].map(({ label, color }) => (
                <div key={label} className="flex items-center gap-1">
                  <div
                    className="h-2 w-6 rounded-full"
                    style={{ background: color }}
                  />
                  <span className="text-gray-400">{label}</span>
                </div>
              ))}
            </div>
            {selectedFactionId && (
              <div className="w-full">
                <DiplomacyMatrix
                  factions={factions}
                  focusedFactionId={selectedFactionId}
                />
              </div>
            )}
          </div>
        )}
      </div>

      {/* Footer status bar */}
      <div className="flex items-center justify-between px-4 py-2 border-t border-gray-700 bg-gray-900/80 text-xs text-gray-600">
        <span>
          {selectedFactionId
            ? `Selected: ${factions.find((f) => f.id === selectedFactionId)?.name ?? "—"}`
            : "No faction selected"}
        </span>
        <span className="font-mono">{formatTick(tick)}</span>
      </div>
    </div>
  );
};

export default FactionPanel;
