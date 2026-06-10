import type React from "react";
import { useEffect, useState } from "react";

// ── Types ────────────────────────────────────────────────────────────────────

type MissionType =
  | "recon"
  | "extraction"
  | "siege"
  | "infiltration"
  | "escort"
  | "assassination"
  | "sabotage"
  | "research"
  | "trade_run"
  | "anomaly_harvest";

type MissionStatus = "active" | "pending" | "completed";

interface Objective {
  id: string;
  label: string;
  complete: boolean;
  progress: number; // 0-100
}

interface Mission {
  id: string;
  title: string;
  type: MissionType;
  status: MissionStatus;
  difficulty: 1 | 2 | 3 | 4 | 5;
  assignedAgentIds: string[];
  objectives: Objective[];
  timeRemainingTicks: number;
  totalTicks: number;
  reward: number;
  narrativeBrief: string;
  successProbability: number; // 0-100
}

interface Agent {
  id: string;
  name: string;
  role: string;
  available: boolean;
  avatarInitials: string;
}

interface MissionControlProps {
  missions: Mission[];
  agents: Agent[];
  tick: number;
  onAssign: (missionId: string, agentId: string) => void;
  onRecall: (missionId: string, agentId: string) => void;
  onArchive: (missionId: string) => void;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

const MISSION_ICONS: Record<MissionType, string> = {
  recon: "🔍",
  extraction: "📦",
  siege: "⚔",
  infiltration: "👻",
  escort: "🛡",
  assassination: "🎯",
  sabotage: "💥",
  research: "🔬",
  trade_run: "💱",
  anomaly_harvest: "🌀",
};

const DIFFICULTY_LABELS: Record<number, string> = {
  1: "Trivial",
  2: "Easy",
  3: "Moderate",
  4: "Hard",
  5: "Extreme",
};

const DIFFICULTY_COLORS: Record<number, string> = {
  1: "text-green-400",
  2: "text-lime-400",
  3: "text-yellow-400",
  4: "text-orange-400",
  5: "text-red-500",
};

const STATUS_COLORS: Record<MissionStatus, string> = {
  active: "bg-blue-500/20 text-blue-300 border-blue-500/40",
  pending: "bg-yellow-500/20 text-yellow-300 border-yellow-500/40",
  completed: "bg-green-500/20 text-green-300 border-green-500/40",
};

function formatTicks(ticks: number): string {
  if (ticks <= 0) return "Expired";
  const mins = Math.floor(ticks / 60);
  const secs = ticks % 60;
  return mins > 0 ? `${mins}m ${secs}s` : `${secs}s`;
}

// ── Sub-components ────────────────────────────────────────────────────────────

interface SuccessProbabilityBarProps {
  probability: number;
}

const SuccessProbabilityBar: React.FC<SuccessProbabilityBarProps> = ({
  probability,
}) => {
  const color =
    probability >= 75
      ? "bg-green-500"
      : probability >= 50
        ? "bg-yellow-500"
        : probability >= 25
          ? "bg-orange-500"
          : "bg-red-600";

  return (
    <div className="mt-2">
      <div className="flex justify-between text-xs text-slate-400 mb-1">
        <span>Success Probability</span>
        <span className={probability >= 50 ? "text-green-400" : "text-red-400"}>
          {probability}%
        </span>
      </div>
      <div className="h-1.5 w-full bg-slate-700 rounded-full overflow-hidden">
        <div
          className={`h-full rounded-full transition-all duration-500 ${color}`}
          style={{ width: `${probability}%` }}
        />
      </div>
    </div>
  );
};

interface ObjectiveListProps {
  objectives: Objective[];
}

const ObjectiveList: React.FC<ObjectiveListProps> = ({ objectives }) => (
  <div className="space-y-2 mt-3">
    {objectives.map((obj) => (
      <div key={obj.id}>
        <div className="flex items-center gap-2 text-xs mb-0.5">
          <span className={obj.complete ? "text-green-400" : "text-slate-400"}>
            {obj.complete ? "✔" : "○"}
          </span>
          <span
            className={
              obj.complete ? "text-green-300 line-through" : "text-slate-300"
            }
          >
            {obj.label}
          </span>
          <span className="ml-auto text-slate-500">{obj.progress}%</span>
        </div>
        <div className="h-1 w-full bg-slate-700 rounded-full overflow-hidden ml-4">
          <div
            className={`h-full rounded-full transition-all duration-500 ${obj.complete ? "bg-green-500" : "bg-blue-500"}`}
            style={{ width: `${obj.progress}%` }}
          />
        </div>
      </div>
    ))}
  </div>
);

interface RewardPreviewProps {
  reward: number;
  difficulty: number;
}

const RewardPreview: React.FC<RewardPreviewProps> = ({
  reward,
  difficulty,
}) => (
  <div className="flex items-center gap-2 bg-slate-800/60 rounded-lg px-3 py-1.5 mt-2">
    <span className="text-yellow-400 text-sm">💰</span>
    <span className="text-xs text-slate-400">Reward</span>
    <span className="ml-auto text-sm font-bold text-yellow-300">
      {reward.toLocaleString()}{" "}
      <span className="text-xs font-normal text-yellow-500">CR</span>
    </span>
    <span className={`text-xs ml-2 ${DIFFICULTY_COLORS[difficulty]}`}>
      {DIFFICULTY_LABELS[difficulty]}
    </span>
  </div>
);

interface AgentAssignPanelProps {
  missionId: string;
  assignedAgentIds: string[];
  agents: Agent[];
  onAssign: (missionId: string, agentId: string) => void;
  onRecall: (missionId: string, agentId: string) => void;
}

const AgentAssignPanel: React.FC<AgentAssignPanelProps> = ({
  missionId,
  assignedAgentIds,
  agents,
  onAssign,
  onRecall,
}) => {
  const assigned = agents.filter((a) => assignedAgentIds.includes(a.id));
  const available = agents.filter(
    (a) => a.available && !assignedAgentIds.includes(a.id),
  );

  return (
    <div className="mt-3 border-t border-slate-700/50 pt-3">
      <p className="text-xs text-slate-500 mb-2 uppercase tracking-wider">
        Assigned Agents
      </p>
      <div className="flex flex-wrap gap-1.5 mb-2">
        {assigned.length === 0 && (
          <span className="text-xs text-slate-600 italic">None assigned</span>
        )}
        {assigned.map((a) => (
          <button
            type="button"
            key={a.id}
            onClick={() => onRecall(missionId, a.id)}
            title={`Recall ${a.name}`}
            className="flex items-center gap-1 bg-blue-800/40 hover:bg-red-800/50 border border-blue-600/40 hover:border-red-500/60 text-blue-200 hover:text-red-300 rounded-full px-2 py-0.5 text-xs transition-colors"
          >
            <span className="w-5 h-5 rounded-full bg-slate-700 flex items-center justify-center text-[10px] font-bold">
              {a.avatarInitials}
            </span>
            {a.name}
            <span className="ml-1 text-red-400 text-[10px]">✕</span>
          </button>
        ))}
      </div>
      {available.length > 0 && (
        <div>
          <p className="text-xs text-slate-500 mb-1 uppercase tracking-wider">
            Available
          </p>
          <div className="flex flex-wrap gap-1.5">
            {available.slice(0, 4).map((a) => (
              <button
                type="button"
                key={a.id}
                onClick={() => onAssign(missionId, a.id)}
                title={`Assign ${a.name}`}
                className="flex items-center gap-1 bg-slate-700/50 hover:bg-green-800/40 border border-slate-600/40 hover:border-green-500/60 text-slate-300 hover:text-green-200 rounded-full px-2 py-0.5 text-xs transition-colors"
              >
                <span className="w-5 h-5 rounded-full bg-slate-600 flex items-center justify-center text-[10px] font-bold">
                  {a.avatarInitials}
                </span>
                {a.name}
                <span className="ml-1 text-green-400 text-[10px]">+</span>
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

interface MissionBriefingModalProps {
  mission: Mission;
  onClose: () => void;
}

const MissionBriefingModal: React.FC<MissionBriefingModalProps> = ({
  mission,
  onClose,
}) => (
  <dialog
    className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 backdrop-blur-sm"
    onClick={onClose}
    onKeyDown={(e) => {
      if (e.key === "Escape") onClose();
    }}
    aria-modal="true"
  >
    <div
      className="bg-slate-900 border border-slate-700 rounded-2xl shadow-2xl max-w-lg w-full mx-4 p-6"
      onClick={(e) => e.stopPropagation()}
      onKeyDown={(e) => e.stopPropagation()}
      role="document"
    >
      <div className="flex items-start justify-between mb-4">
        <div className="flex items-center gap-3">
          <span className="text-3xl">{MISSION_ICONS[mission.type]}</span>
          <div>
            <h2 className="text-lg font-bold text-white">{mission.title}</h2>
            <p className="text-xs text-slate-400 capitalize">
              {mission.type.replace("_", " ")}
            </p>
          </div>
        </div>
        <button
          type="button"
          onClick={onClose}
          className="text-slate-500 hover:text-white text-xl leading-none"
        >
          ✕
        </button>
      </div>

      <div className="bg-slate-800/60 rounded-xl p-4 mb-4 text-sm text-slate-300 leading-relaxed border border-slate-700/50">
        <p className="text-xs text-slate-500 uppercase tracking-wider mb-2">
          Mission Brief
        </p>
        {mission.narrativeBrief}
      </div>

      <div className="mb-4">
        <p className="text-xs text-slate-500 uppercase tracking-wider mb-2">
          Objectives
        </p>
        <ObjectiveList objectives={mission.objectives} />
      </div>

      <RewardPreview reward={mission.reward} difficulty={mission.difficulty} />
      <SuccessProbabilityBar probability={mission.successProbability} />

      <div className="mt-4 flex gap-2 justify-end">
        <button
          type="button"
          onClick={onClose}
          className="px-4 py-2 rounded-lg bg-slate-700 hover:bg-slate-600 text-slate-200 text-sm transition-colors"
        >
          Close
        </button>
      </div>
    </div>
  </dialog>
);

interface MissionCardProps {
  mission: Mission;
  agents: Agent[];
  onAssign: (missionId: string, agentId: string) => void;
  onRecall: (missionId: string, agentId: string) => void;
  onArchive: (missionId: string) => void;
}

const MissionCard: React.FC<MissionCardProps> = ({
  mission,
  agents,
  onAssign,
  onRecall,
  onArchive,
}) => {
  const [showBrief, setShowBrief] = useState(false);
  const [expanded, setExpanded] = useState(false);

  const completedObjectives = mission.objectives.filter(
    (o) => o.complete,
  ).length;
  const timePercent =
    mission.totalTicks > 0
      ? Math.round((mission.timeRemainingTicks / mission.totalTicks) * 100)
      : 0;

  return (
    <>
      <div className="bg-slate-900 border border-slate-700/60 rounded-xl p-4 hover:border-slate-500/70 transition-all duration-200 shadow-lg">
        {/* Header */}
        <div className="flex items-start justify-between gap-2">
          <div className="flex items-center gap-2 min-w-0">
            <span className="text-2xl flex-shrink-0">
              {MISSION_ICONS[mission.type]}
            </span>
            <div className="min-w-0">
              <h3 className="text-sm font-semibold text-white truncate">
                {mission.title}
              </h3>
              <p className="text-xs text-slate-500 capitalize">
                {mission.type.replace("_", " ")}
              </p>
            </div>
          </div>
          <div className="flex items-center gap-2 flex-shrink-0">
            <span
              className={`text-xs px-2 py-0.5 rounded-full border capitalize ${STATUS_COLORS[mission.status]}`}
            >
              {mission.status}
            </span>
            <span
              className={`text-xs font-medium ${DIFFICULTY_COLORS[mission.difficulty]}`}
            >
              {"★".repeat(mission.difficulty)}
            </span>
          </div>
        </div>

        {/* Time remaining */}
        {mission.status === "active" && (
          <div className="mt-3">
            <div className="flex justify-between text-xs text-slate-400 mb-1">
              <span>Time Remaining</span>
              <span
                className={timePercent < 25 ? "text-red-400" : "text-slate-300"}
              >
                {formatTicks(mission.timeRemainingTicks)}
              </span>
            </div>
            <div className="h-1.5 w-full bg-slate-700 rounded-full overflow-hidden">
              <div
                className={`h-full rounded-full transition-all duration-500 ${
                  timePercent < 25
                    ? "bg-red-500"
                    : timePercent < 50
                      ? "bg-yellow-500"
                      : "bg-blue-500"
                }`}
                style={{ width: `${timePercent}%` }}
              />
            </div>
          </div>
        )}

        {/* Objective summary */}
        <div className="mt-2 text-xs text-slate-400">
          Objectives: {completedObjectives}/{mission.objectives.length} complete
        </div>

        <SuccessProbabilityBar probability={mission.successProbability} />
        <RewardPreview
          reward={mission.reward}
          difficulty={mission.difficulty}
        />

        {/* Expanded section */}
        {expanded && (
          <>
            <ObjectiveList objectives={mission.objectives} />
            <AgentAssignPanel
              missionId={mission.id}
              assignedAgentIds={mission.assignedAgentIds}
              agents={agents}
              onAssign={onAssign}
              onRecall={onRecall}
            />
          </>
        )}

        {/* Actions */}
        <div className="mt-3 flex gap-2">
          <button
            type="button"
            onClick={() => setExpanded((v) => !v)}
            className="flex-1 text-xs py-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 transition-colors border border-slate-700/50"
          >
            {expanded ? "Collapse" : "Expand"}
          </button>
          <button
            type="button"
            onClick={() => setShowBrief(true)}
            className="flex-1 text-xs py-1.5 rounded-lg bg-blue-900/40 hover:bg-blue-800/60 text-blue-300 transition-colors border border-blue-700/40"
          >
            Briefing
          </button>
          {mission.status === "completed" && (
            <button
              type="button"
              onClick={() => onArchive(mission.id)}
              className="text-xs py-1.5 px-3 rounded-lg bg-slate-800 hover:bg-red-900/40 text-slate-400 hover:text-red-400 transition-colors border border-slate-700/50"
            >
              Archive
            </button>
          )}
        </div>
      </div>

      {showBrief && (
        <MissionBriefingModal
          mission={mission}
          onClose={() => setShowBrief(false)}
        />
      )}
    </>
  );
};

// ── Stats Panel ───────────────────────────────────────────────────────────────

interface StatsPanelProps {
  missions: Mission[];
}

const StatsPanel: React.FC<StatsPanelProps> = ({ missions }) => {
  const total = missions.length;
  const completed = missions.filter((m) => m.status === "completed").length;
  const successRate = total > 0 ? Math.round((completed / total) * 100) : 0;
  const avgReward =
    completed > 0
      ? Math.round(
          missions
            .filter((m) => m.status === "completed")
            .reduce((acc, m) => acc + m.reward, 0) / completed,
        )
      : 0;

  const stats = [
    {
      label: "Total Missions",
      value: total,
      icon: "📋",
      color: "text-slate-200",
    },
    {
      label: "Success Rate",
      value: `${successRate}%`,
      icon: "✅",
      color: "text-green-400",
    },
    {
      label: "Avg Reward",
      value: `${avgReward.toLocaleString()} CR`,
      icon: "💰",
      color: "text-yellow-400",
    },
    {
      label: "Active Now",
      value: missions.filter((m) => m.status === "active").length,
      icon: "⚡",
      color: "text-blue-400",
    },
  ];

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
      {stats.map((s) => (
        <div
          key={s.label}
          className="bg-slate-900 border border-slate-700/50 rounded-xl p-3 flex flex-col gap-1"
        >
          <div className="flex items-center gap-2 text-xs text-slate-500">
            <span>{s.icon}</span>
            {s.label}
          </div>
          <div className={`text-lg font-bold ${s.color}`}>{s.value}</div>
        </div>
      ))}
    </div>
  );
};

// ── Main Component ────────────────────────────────────────────────────────────

type FilterTab = "all" | MissionStatus;

const MissionControl: React.FC<MissionControlProps> = ({
  missions,
  agents,
  tick,
  onAssign,
  onRecall,
  onArchive,
}) => {
  const [activeTab, setActiveTab] = useState<FilterTab>("all");
  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState<MissionType | "all">("all");
  const [displayedTick, setDisplayedTick] = useState(tick);

  useEffect(() => {
    setDisplayedTick(tick);
  }, [tick]);

  const tabs: { key: FilterTab; label: string; count: number }[] = [
    { key: "all", label: "All", count: missions.length },
    {
      key: "active",
      label: "Active",
      count: missions.filter((m) => m.status === "active").length,
    },
    {
      key: "pending",
      label: "Pending",
      count: missions.filter((m) => m.status === "pending").length,
    },
    {
      key: "completed",
      label: "Completed",
      count: missions.filter((m) => m.status === "completed").length,
    },
  ];

  const filtered = missions.filter((m) => {
    const matchTab = activeTab === "all" || m.status === activeTab;
    const matchSearch =
      search === "" ||
      m.title.toLowerCase().includes(search.toLowerCase()) ||
      m.type.toLowerCase().includes(search.toLowerCase());
    const matchType = typeFilter === "all" || m.type === typeFilter;
    return matchTab && matchSearch && matchType;
  });

  const missionTypes = Array.from(new Set(missions.map((m) => m.type)));

  return (
    <div className="min-h-screen bg-slate-950 text-white p-4 md:p-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-white tracking-tight">
            Mission Control
          </h1>
          <p className="text-sm text-slate-400 mt-0.5">
            Tick{" "}
            <span className="text-blue-400 font-mono">{displayedTick}</span> —
            Living World Operations
          </p>
        </div>
        <div className="flex items-center gap-2">
          <span className="h-2 w-2 rounded-full bg-green-400 animate-pulse" />
          <span className="text-xs text-green-400">LIVE</span>
        </div>
      </div>

      {/* Stats */}
      <StatsPanel missions={missions} />

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-3 mb-4">
        <input
          type="text"
          placeholder="Search missions…"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="flex-1 bg-slate-800 border border-slate-700 rounded-lg px-3 py-2 text-sm text-slate-200 placeholder-slate-500 focus:outline-none focus:border-blue-500"
        />
        <select
          value={typeFilter}
          onChange={(e) => setTypeFilter(e.target.value as MissionType | "all")}
          className="bg-slate-800 border border-slate-700 rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-blue-500"
        >
          <option value="all">All Types</option>
          {missionTypes.map((t) => (
            <option key={t} value={t}>
              {MISSION_ICONS[t]} {t.replace("_", " ")}
            </option>
          ))}
        </select>
      </div>

      {/* Tabs */}
      <div className="flex gap-1 mb-6 bg-slate-900 p-1 rounded-xl border border-slate-700/50 w-fit">
        {tabs.map((tab) => (
          <button
            type="button"
            key={tab.key}
            onClick={() => setActiveTab(tab.key)}
            className={`px-4 py-1.5 rounded-lg text-sm font-medium transition-colors flex items-center gap-1.5 ${
              activeTab === tab.key
                ? "bg-blue-600 text-white shadow"
                : "text-slate-400 hover:text-slate-200"
            }`}
          >
            {tab.label}
            <span
              className={`text-xs px-1.5 py-0.5 rounded-full ${
                activeTab === tab.key
                  ? "bg-blue-500 text-white"
                  : "bg-slate-700 text-slate-400"
              }`}
            >
              {tab.count}
            </span>
          </button>
        ))}
      </div>

      {/* Mission Grid */}
      {filtered.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-slate-600">
          <span className="text-4xl mb-3">📭</span>
          <p className="text-sm">No missions match your filters.</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
          {filtered.map((mission) => (
            <MissionCard
              key={mission.id}
              mission={mission}
              agents={agents}
              onAssign={onAssign}
              onRecall={onRecall}
              onArchive={onArchive}
            />
          ))}
        </div>
      )}
    </div>
  );
};

export default MissionControl;
export type { Mission, Agent, MissionType, MissionStatus, Objective };
