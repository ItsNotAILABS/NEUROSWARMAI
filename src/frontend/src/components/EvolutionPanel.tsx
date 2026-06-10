import React, { useState, useMemo } from "react";

// ── Types ────────────────────────────────────────────────────────────────────

export type MutationType =
  | "point"
  | "insertion"
  | "deletion"
  | "duplication"
  | "inversion"
  | "epigenetic";

export interface Trait {
  id: string;
  name: string;
  category: string;
  expressionLevel: number; // 0-1
  dominance: "dominant" | "recessive" | "codominant";
  heritable: boolean;
}

export interface MutationRecord {
  tick: number;
  type: MutationType;
  traitAffected: string;
  fitnessDelta: number;
  description: string;
}

export interface AncestorNode {
  id: string;
  name: string;
  generation: number;
  fitness: number;
  children: string[];
  isCurrentOrganism?: boolean;
}

export interface EvolutionHistory {
  fitnessOverTime: { tick: number; fitness: number }[];
  mutations: MutationRecord[];
  ancestors: AncestorNode[];
}

export interface EnvironmentalPressure {
  id: string;
  name: string;
  direction: "selecting_for" | "selecting_against" | "neutral";
  strength: number; // 0-1
  description: string;
}

export interface OrganismData {
  id: string;
  name: string;
  species: string;
  generation: number;
  fitness: number;
  traits: Trait[];
  genome: string; // abbreviated hex string
}

export interface EvolutionPanelProps {
  organism: OrganismData;
  evolutionHistory: EvolutionHistory;
  currentPressures: EnvironmentalPressure[];
  tick: number;
}

// ── MutationBadge ─────────────────────────────────────────────────────────────

const mutationColors: Record<MutationType, string> = {
  point: "bg-sky-900/40 text-sky-300 border-sky-700",
  insertion: "bg-emerald-900/40 text-emerald-300 border-emerald-700",
  deletion: "bg-red-900/40 text-red-300 border-red-700",
  duplication: "bg-violet-900/40 text-violet-300 border-violet-700",
  inversion: "bg-amber-900/40 text-amber-300 border-amber-700",
  epigenetic: "bg-pink-900/40 text-pink-300 border-pink-700",
};

function MutationBadge({ type }: { type: MutationType }) {
  return (
    <span
      className={`inline-flex items-center px-1.5 py-0.5 rounded border text-xs font-semibold ${mutationColors[type]}`}
    >
      {type}
    </span>
  );
}

// ── TraitExpressionBar ────────────────────────────────────────────────────────

function TraitExpressionBar({ trait }: { trait: Trait }) {
  const dominanceColor =
    trait.dominance === "dominant"
      ? "bg-emerald-500"
      : trait.dominance === "recessive"
        ? "bg-zinc-500"
        : "bg-amber-500";
  return (
    <div className="flex items-center gap-2">
      <div className="w-24 shrink-0">
        <p
          className="text-xs text-zinc-300 truncate font-medium"
          title={trait.name}
        >
          {trait.name}
        </p>
        <p className="text-xs text-zinc-600 truncate">{trait.category}</p>
      </div>
      <div className="flex-1 h-2 bg-zinc-700 rounded-full overflow-hidden">
        <div
          className={`h-full rounded-full transition-all ${dominanceColor}`}
          style={{ width: `${trait.expressionLevel * 100}%` }}
        />
      </div>
      <span className="text-xs font-mono text-zinc-400 w-8 text-right">
        {(trait.expressionLevel * 100).toFixed(0)}%
      </span>
      {!trait.heritable && (
        <span className="text-xs text-zinc-600" title="Non-heritable">
          ⊘
        </span>
      )}
    </div>
  );
}

// ── FitnessLandscapeChart ─────────────────────────────────────────────────────

function FitnessLandscapeChart({
  data,
  currentTick,
}: { data: { tick: number; fitness: number }[]; currentTick: number }) {
  const W = 320;
  const H = 80;
  if (!data.length) return null;

  const minF = Math.min(...data.map((d) => d.fitness));
  const maxF = Math.max(...data.map((d) => d.fitness));
  const range = maxF - minF || 1;
  const minT = data[0].tick;
  const maxT = data[data.length - 1].tick || minT + 1;

  const toX = (t: number) => ((t - minT) / (maxT - minT)) * W;
  const toY = (f: number) => H - ((f - minF) / range) * (H - 8) - 4;

  const pathD = data
    .map(
      (d, i) =>
        `${i === 0 ? "M" : "L"}${toX(d.tick).toFixed(1)},${toY(d.fitness).toFixed(1)}`,
    )
    .join(" ");
  const areaD = `${pathD} L${toX(data[data.length - 1].tick)},${H} L${toX(data[0].tick)},${H} Z`;

  const curX = toX(currentTick);

  return (
    <div className="space-y-1">
      <div className="flex justify-between text-xs text-zinc-500">
        <span>Fitness History</span>
        <span className="font-mono text-emerald-400">
          {data[data.length - 1]?.fitness.toFixed(3) ?? "—"}
        </span>
      </div>
      <svg
        width="100%"
        viewBox={`0 0 ${W} ${H}`}
        className="overflow-visible"
        preserveAspectRatio="none"
        role="img"
        aria-label="Fitness history chart"
      >
        <defs>
          <linearGradient id="fitGrad" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="#4ade80" stopOpacity="0.25" />
            <stop offset="100%" stopColor="#4ade80" stopOpacity="0" />
          </linearGradient>
        </defs>
        <path d={areaD} fill="url(#fitGrad)" />
        <path
          d={pathD}
          fill="none"
          stroke="#4ade80"
          strokeWidth="1.5"
          strokeLinejoin="round"
        />
        {curX >= 0 && curX <= W && (
          <line
            x1={curX}
            y1={0}
            x2={curX}
            y2={H}
            stroke="rgba(255,255,255,0.2)"
            strokeWidth="1"
            strokeDasharray="3,3"
          />
        )}
      </svg>
      <div className="flex justify-between text-xs text-zinc-600 font-mono">
        <span>{minF.toFixed(2)}</span>
        <span>{maxF.toFixed(2)}</span>
      </div>
    </div>
  );
}

// ── DriftVectorDisplay ────────────────────────────────────────────────────────

function DriftVectorDisplay({
  pressures,
}: { pressures: EnvironmentalPressure[] }) {
  const forPressures = pressures.filter((p) => p.direction === "selecting_for");
  const againstPressures = pressures.filter(
    (p) => p.direction === "selecting_against",
  );
  return (
    <div className="space-y-2">
      <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
        Drift Vectors
      </p>
      {pressures.length === 0 && (
        <p className="text-xs text-zinc-600">No active pressures</p>
      )}
      <div className="grid grid-cols-2 gap-2">
        {forPressures.length > 0 && (
          <div>
            <p className="text-xs text-emerald-400 font-semibold mb-1">
              ↑ Selecting For
            </p>
            {forPressures.map((p) => (
              <div key={p.id} className="space-y-0.5 mb-1.5">
                <div className="flex items-center justify-between">
                  <span className="text-xs text-zinc-300 truncate">
                    {p.name}
                  </span>
                  <span className="text-xs font-mono text-emerald-300">
                    {(p.strength * 100).toFixed(0)}%
                  </span>
                </div>
                <div className="h-1 bg-zinc-700 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-emerald-500 rounded-full"
                    style={{ width: `${p.strength * 100}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        )}
        {againstPressures.length > 0 && (
          <div>
            <p className="text-xs text-red-400 font-semibold mb-1">
              ↓ Selecting Against
            </p>
            {againstPressures.map((p) => (
              <div key={p.id} className="space-y-0.5 mb-1.5">
                <div className="flex items-center justify-between">
                  <span className="text-xs text-zinc-300 truncate">
                    {p.name}
                  </span>
                  <span className="text-xs font-mono text-red-300">
                    {(p.strength * 100).toFixed(0)}%
                  </span>
                </div>
                <div className="h-1 bg-zinc-700 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-red-500 rounded-full"
                    style={{ width: `${p.strength * 100}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

// ── LineageTree (SVG) ─────────────────────────────────────────────────────────

function LineageTree({ ancestors }: { ancestors: AncestorNode[] }) {
  const W = 320;
  const H = 160;
  if (!ancestors.length)
    return <p className="text-xs text-zinc-600">No lineage data</p>;

  const maxGen = Math.max(...ancestors.map((a) => a.generation));
  const byGen: Record<number, AncestorNode[]> = {};
  for (const a of ancestors) {
    if (!byGen[a.generation]) byGen[a.generation] = [];
    byGen[a.generation].push(a);
  }

  const positions: Record<string, { x: number; y: number }> = {};
  for (let g = 0; g <= maxGen; g++) {
    const group = byGen[g] || [];
    for (let i = 0; i < group.length; i++) {
      const node = group[i];
      positions[node.id] = {
        x: ((g + 0.5) / (maxGen + 1)) * W,
        y: ((i + 0.5) / group.length) * H,
      };
    }
  }

  const edges: {
    x1: number;
    y1: number;
    x2: number;
    y2: number;
    id: string;
  }[] = [];
  for (const node of ancestors) {
    for (const childId of node.children) {
      const p = positions[node.id];
      const c = positions[childId];
      if (p && c)
        edges.push({
          x1: p.x,
          y1: p.y,
          x2: c.x,
          y2: c.y,
          id: `${node.id}-${childId}`,
        });
    }
  }

  return (
    <div className="space-y-1">
      <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
        Lineage Tree
      </p>
      <svg
        width="100%"
        viewBox={`0 0 ${W} ${H}`}
        className="overflow-visible"
        preserveAspectRatio="xMidYMid meet"
        role="img"
        aria-label="Lineage tree visualization"
      >
        {edges.map((e) => (
          <line
            key={e.id}
            x1={e.x1}
            y1={e.y1}
            x2={e.x2}
            y2={e.y2}
            stroke="rgba(255,255,255,0.12)"
            strokeWidth="1.5"
          />
        ))}
        {ancestors.map((node) => {
          const pos = positions[node.id];
          if (!pos) return null;
          const isCurrent = node.isCurrentOrganism;
          const r = isCurrent ? 7 : 5;
          const fill = isCurrent
            ? "#c084fc"
            : `hsl(${node.fitness * 120},60%,50%)`;
          return (
            <g key={node.id}>
              {isCurrent && (
                <circle
                  cx={pos.x}
                  cy={pos.y}
                  r={r + 5}
                  fill="rgba(192,132,252,0.15)"
                />
              )}
              <circle
                cx={pos.x}
                cy={pos.y}
                r={r}
                fill={fill}
                stroke={isCurrent ? "#c084fc" : "rgba(255,255,255,0.2)"}
                strokeWidth={isCurrent ? 2 : 1}
              />
              <text
                x={pos.x}
                y={pos.y + r + 9}
                textAnchor="middle"
                fontSize="7"
                fill="rgba(255,255,255,0.5)"
              >
                {node.name.slice(0, 8)}
              </text>
            </g>
          );
        })}
      </svg>
      <div className="flex justify-between text-xs text-zinc-600">
        <span>Gen 0</span>
        <span>Gen {maxGen}</span>
      </div>
    </div>
  );
}

// ── MutationTable ─────────────────────────────────────────────────────────────

function MutationTable({ mutations }: { mutations: MutationRecord[] }) {
  const [showAll, setShowAll] = useState(false);
  const displayed = showAll ? mutations : mutations.slice(-10).reverse();
  return (
    <div className="space-y-2">
      <div className="flex items-center justify-between">
        <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
          Mutation History
        </p>
        <button
          type="button"
          onClick={() => setShowAll((v) => !v)}
          className="text-xs text-zinc-500 hover:text-zinc-300 transition-colors"
        >
          {showAll ? "Show less" : `All (${mutations.length})`}
        </button>
      </div>
      <div className="overflow-x-auto">
        <table className="w-full text-xs">
          <thead>
            <tr className="text-zinc-500 border-b border-zinc-800">
              <th className="text-left pb-1 font-medium">Tick</th>
              <th className="text-left pb-1 font-medium">Type</th>
              <th className="text-left pb-1 font-medium">Trait</th>
              <th className="text-right pb-1 font-medium">Δ Fitness</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-zinc-800/50">
            {displayed.map((m) => (
              <tr
                key={`${m.tick}-${m.traitAffected}`}
                className="hover:bg-zinc-800/30 transition-colors"
              >
                <td className="py-1 font-mono text-zinc-500">{m.tick}</td>
                <td className="py-1">
                  <MutationBadge type={m.type} />
                </td>
                <td
                  className="py-1 text-zinc-300 max-w-[100px] truncate"
                  title={m.description}
                >
                  {m.traitAffected}
                </td>
                <td
                  className={`py-1 text-right font-mono font-semibold ${m.fitnessDelta >= 0 ? "text-emerald-400" : "text-red-400"}`}
                >
                  {m.fitnessDelta >= 0 ? "+" : ""}
                  {m.fitnessDelta.toFixed(4)}
                </td>
              </tr>
            ))}
            {displayed.length === 0 && (
              <tr>
                <td colSpan={4} className="py-3 text-center text-zinc-600">
                  No mutations recorded
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// ── EvolutionPanel (main) ─────────────────────────────────────────────────────

export function EvolutionPanel({
  organism,
  evolutionHistory,
  currentPressures,
  tick,
}: EvolutionPanelProps) {
  const [activeTab, setActiveTab] = useState<
    "traits" | "lineage" | "mutations" | "pressures"
  >("traits");
  const [traitSearch, setTraitSearch] = useState("");

  const filteredTraits = useMemo(
    () =>
      organism.traits.filter(
        (t) =>
          t.name.toLowerCase().includes(traitSearch.toLowerCase()) ||
          t.category.toLowerCase().includes(traitSearch.toLowerCase()),
      ),
    [organism.traits, traitSearch],
  );

  const traitsByCategory = useMemo(() => {
    const map: Record<string, Trait[]> = {};
    for (const t of filteredTraits) {
      if (!map[t.category]) map[t.category] = [];
      map[t.category].push(t);
    }
    return map;
  }, [filteredTraits]);

  const netFitnessDelta = evolutionHistory.mutations.reduce(
    (s, m) => s + m.fitnessDelta,
    0,
  );
  const beneficialCount = evolutionHistory.mutations.filter(
    (m) => m.fitnessDelta > 0,
  ).length;

  const tabs: {
    key: "traits" | "lineage" | "mutations" | "pressures";
    label: string;
  }[] = [
    { key: "traits", label: "Traits" },
    { key: "lineage", label: "Lineage" },
    { key: "mutations", label: "Mutations" },
    { key: "pressures", label: "Pressures" },
  ];

  return (
    <div className="h-full flex flex-col bg-zinc-900 text-zinc-100 rounded-xl border border-zinc-800 overflow-hidden">
      {/* Header */}
      <div className="px-4 pt-4 pb-3 border-b border-zinc-800 space-y-3">
        <div className="flex items-start justify-between">
          <div>
            <h2 className="text-base font-bold text-zinc-100 tracking-tight">
              {organism.name}
            </h2>
            <p className="text-xs text-zinc-500">
              {organism.species} · Gen {organism.generation}
            </p>
            <p className="text-xs text-zinc-600 font-mono mt-0.5 truncate max-w-[200px]">
              Genome: {organism.genome}
            </p>
          </div>
          <div className="text-right">
            <p className="text-xs text-zinc-500 mb-0.5">Fitness Score</p>
            <p className="text-xl font-mono font-bold text-emerald-400">
              {organism.fitness.toFixed(4)}
            </p>
            <p
              className={`text-xs font-mono ${netFitnessDelta >= 0 ? "text-emerald-400" : "text-red-400"}`}
            >
              Lifetime Δ {netFitnessDelta >= 0 ? "+" : ""}
              {netFitnessDelta.toFixed(4)}
            </p>
          </div>
        </div>

        {/* Stats row */}
        <div className="grid grid-cols-4 gap-2 text-center">
          {[
            { label: "Traits", value: organism.traits.length },
            { label: "Mutations", value: evolutionHistory.mutations.length },
            {
              label: "Beneficial",
              value: beneficialCount,
              color: "text-emerald-400",
            },
            {
              label: "Pressures",
              value: currentPressures.length,
              color: "text-amber-400",
            },
          ].map((s) => (
            <div
              key={s.label}
              className="rounded-lg bg-zinc-800/60 px-2 py-1.5"
            >
              <p className="text-xs text-zinc-500">{s.label}</p>
              <p
                className={`text-sm font-mono font-bold ${s.color ?? "text-zinc-200"}`}
              >
                {s.value}
              </p>
            </div>
          ))}
        </div>

        {/* Fitness chart */}
        <FitnessLandscapeChart
          data={evolutionHistory.fitnessOverTime}
          currentTick={tick}
        />
      </div>

      {/* Tabs */}
      <div className="flex border-b border-zinc-800">
        {tabs.map((t) => (
          <button
            type="button"
            key={t.key}
            onClick={() => setActiveTab(t.key)}
            className={`flex-1 py-2 text-xs font-semibold transition-colors ${
              activeTab === t.key
                ? "text-emerald-300 border-b-2 border-emerald-500 bg-emerald-900/10"
                : "text-zinc-500 hover:text-zinc-300"
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto px-4 py-3 space-y-4">
        {activeTab === "traits" && (
          <>
            <input
              type="text"
              placeholder="Search traits…"
              value={traitSearch}
              onChange={(e) => setTraitSearch(e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded-lg px-3 py-1.5 text-sm text-zinc-100 placeholder-zinc-500 focus:outline-none focus:border-emerald-600"
            />
            {Object.entries(traitsByCategory).map(([cat, traits]) => (
              <div key={cat} className="space-y-1.5">
                <p className="text-xs text-zinc-500 font-semibold uppercase tracking-wider border-b border-zinc-800 pb-1">
                  {cat}
                </p>
                {traits.map((t) => (
                  <TraitExpressionBar key={t.id} trait={t} />
                ))}
              </div>
            ))}
            {filteredTraits.length === 0 && (
              <p className="text-xs text-zinc-600 text-center py-6">
                No traits match "{traitSearch}"
              </p>
            )}
          </>
        )}

        {activeTab === "lineage" && (
          <LineageTree ancestors={evolutionHistory.ancestors} />
        )}

        {activeTab === "mutations" && (
          <MutationTable mutations={evolutionHistory.mutations} />
        )}

        {activeTab === "pressures" && (
          <div className="space-y-4">
            <DriftVectorDisplay pressures={currentPressures} />
            {currentPressures.length > 0 && (
              <div className="space-y-2">
                <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
                  Details
                </p>
                {currentPressures.map((p) => (
                  <div
                    key={p.id}
                    className={`rounded-lg border px-3 py-2 space-y-1 ${
                      p.direction === "selecting_for"
                        ? "border-emerald-800 bg-emerald-900/10"
                        : p.direction === "selecting_against"
                          ? "border-red-800 bg-red-900/10"
                          : "border-zinc-700 bg-zinc-800/30"
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <p className="text-sm font-semibold text-zinc-200">
                        {p.name}
                      </p>
                      <span
                        className={`text-xs font-mono font-semibold ${
                          p.direction === "selecting_for"
                            ? "text-emerald-400"
                            : p.direction === "selecting_against"
                              ? "text-red-400"
                              : "text-zinc-400"
                        }`}
                      >
                        {p.direction === "selecting_for"
                          ? "▲"
                          : p.direction === "selecting_against"
                            ? "▼"
                            : "—"}{" "}
                        {(p.strength * 100).toFixed(0)}%
                      </span>
                    </div>
                    <p className="text-xs text-zinc-500">{p.description}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
}

export default EvolutionPanel;
