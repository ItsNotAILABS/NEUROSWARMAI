/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║              ORO'S COMMAND CENTER — 指揮中心 (Zhǐhuī Zhōngxīn)                  ║
 * ║         The Sovereign Organism's Operational Workspace                         ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  This is not a simple UI panel. This is ORO's computer — his workspace        ║
 * ║  inside the platform where he commands his agents, executes workflows,        ║
 * ║  and manages enterprise operations. All through ICP, all synced.              ║
 * ║                                                                                ║
 * ║  HIERARCHICAL STRUCTURE:                                                       ║
 * ║  ├── Human Operator Interface (top layer - what users see)                    ║
 * ║  ├── Oro's Command View (his "screen" - real-time status)                     ║
 * ║  ├── Agent Management (organisms he commands)                                 ║
 * ║  ├── Workflow Execution (tasks running on ICP)                                ║
 * ║  └── Colony Substrate (the underlying cognitive engine)                       ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 */

import {
  AlertCircle,
  CheckCircle2,
  Clock,
  Cpu,
  Play,
  RefreshCw,
  Zap,
} from "lucide-react";
import type React from "react";
import { useCallback, useEffect, useMemo, useState } from "react";
import type {
  WorkflowCategory,
  WorkflowExecution,
  WorkflowTemplate,
} from "../../hooks/useWorkflowEngine";
import {
  WORKFLOW_TEMPLATES,
  useWorkflowEngine,
} from "../../hooks/useWorkflowEngine";

// ─────────────────────────────────────────────────────────────────────────────────
// TYPES
// ─────────────────────────────────────────────────────────────────────────────────

interface OroCommandCenterProps {
  onExecutionComplete?: (execution: WorkflowExecution) => void;
}

// ─────────────────────────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────────────────────────

const CATEGORY_COLORS: Record<WorkflowCategory, string> = {
  Internal: "text-purple-400 bg-purple-500/20 border-purple-500/40",
  External: "text-blue-400 bg-blue-500/20 border-blue-500/40",
  Task: "text-green-400 bg-green-500/20 border-green-500/40",
  Emergency: "text-red-400 bg-red-500/20 border-red-500/40",
  Maintenance: "text-yellow-400 bg-yellow-500/20 border-yellow-500/40",
};

const STATUS_COLORS: Record<string, string> = {
  NotStarted: "text-slate-400",
  InProgress: "text-blue-400",
  Paused: "text-yellow-400",
  Completed: "text-green-400",
  Failed: "text-red-400",
  Cancelled: "text-slate-500",
  Blocked: "text-orange-400",
};

// ─────────────────────────────────────────────────────────────────────────────────
// SUB-COMPONENTS
// ─────────────────────────────────────────────────────────────────────────────────

interface MetricCardProps {
  label: string;
  value: string | number;
  icon: React.ReactNode;
  color: string;
}

const MetricCard: React.FC<MetricCardProps> = ({
  label,
  value,
  icon,
  color,
}) => (
  <div className="bg-slate-800/50 border border-slate-700/50 rounded-lg p-3">
    <div className="flex items-center gap-2 mb-1">
      <span className={color}>{icon}</span>
      <span className="text-xs text-slate-400">{label}</span>
    </div>
    <div className={`text-lg font-mono font-semibold ${color}`}>{value}</div>
  </div>
);

interface WorkflowCardProps {
  template: WorkflowTemplate;
  onExecute: (templateId: string) => void;
  isExecuting: boolean;
  bestOrganism?: { name: string; coherence: number };
}

const WorkflowCard: React.FC<WorkflowCardProps> = ({
  template,
  onExecute,
  isExecuting,
  bestOrganism,
}) => (
  <div className="bg-slate-800/30 border border-slate-700/50 rounded-lg p-4 hover:border-slate-600/50 transition-colors">
    <div className="flex items-start justify-between mb-2">
      <div>
        <h4 className="font-medium text-slate-200">{template.name}</h4>
        <p className="text-xs text-slate-400 mt-0.5">{template.description}</p>
      </div>
      <span
        className={`text-[10px] px-2 py-0.5 rounded border ${CATEGORY_COLORS[template.category]}`}
      >
        {template.category}
      </span>
    </div>

    <div className="flex items-center gap-2 mt-3 text-xs">
      <span className="text-slate-500">
        Est: {Math.round(template.estimatedDuration / 60)}m
      </span>
      <span className="text-slate-600">•</span>
      <span className="text-slate-500">
        Specs: {template.requiredSpecializations.join(", ")}
      </span>
    </div>

    {bestOrganism && (
      <div className="flex items-center gap-2 mt-2 text-xs">
        <span className="text-slate-400">Best match:</span>
        <span className="text-cyan-400">{bestOrganism.name}</span>
        <span className="text-slate-600">
          ({(bestOrganism.coherence * 100).toFixed(0)}% coherence)
        </span>
      </div>
    )}

    <button
      type="button"
      onClick={() => onExecute(template.id)}
      disabled={isExecuting || !bestOrganism}
      className={`mt-3 w-full flex items-center justify-center gap-2 px-3 py-2 text-xs font-medium rounded transition-colors ${
        isExecuting || !bestOrganism
          ? "bg-slate-700 text-slate-500 cursor-not-allowed"
          : "bg-cyan-600 hover:bg-cyan-500 text-white"
      }`}
    >
      {isExecuting ? (
        <>
          <RefreshCw size={14} className="animate-spin" />
          Executing...
        </>
      ) : (
        <>
          <Play size={14} />
          Execute Workflow
        </>
      )}
    </button>
  </div>
);

interface ExecutionRowProps {
  execution: WorkflowExecution;
}

const ExecutionRow: React.FC<ExecutionRowProps> = ({ execution }) => (
  <div className="flex items-center gap-4 px-4 py-3 bg-slate-800/30 border border-slate-700/50 rounded-lg">
    <div className="flex-1 min-w-0">
      <div className="flex items-center gap-2">
        <span
          className={`text-sm font-medium ${STATUS_COLORS[execution.status]}`}
        >
          {execution.name}
        </span>
        <span
          className={`text-[10px] px-1.5 py-0.5 rounded border ${CATEGORY_COLORS[execution.category]}`}
        >
          {execution.category}
        </span>
      </div>
      <div className="flex items-center gap-2 mt-1 text-xs text-slate-500">
        <span>Agent: {execution.assignedOrganismName ?? "—"}</span>
        <span>•</span>
        <span>{execution.status}</span>
      </div>
    </div>

    <div className="w-32">
      <div className="h-1.5 bg-slate-700 rounded-full overflow-hidden">
        <div
          className={`h-full transition-all duration-500 ${
            execution.status === "Completed"
              ? "bg-green-500"
              : execution.status === "Failed"
                ? "bg-red-500"
                : "bg-cyan-500"
          }`}
          style={{ width: `${execution.progress * 100}%` }}
        />
      </div>
      <div className="text-[10px] text-slate-500 mt-1 text-right">
        {(execution.progress * 100).toFixed(0)}%
      </div>
    </div>

    <div className="w-24 text-right">
      {execution.status === "Completed" && (
        <CheckCircle2 size={16} className="text-green-400 inline" />
      )}
      {execution.status === "Failed" && (
        <AlertCircle size={16} className="text-red-400 inline" />
      )}
      {execution.status === "InProgress" && (
        <RefreshCw size={16} className="text-cyan-400 animate-spin inline" />
      )}
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────────────────────────
// MAIN COMPONENT
// ─────────────────────────────────────────────────────────────────────────────────

export const OroCommandCenter: React.FC<OroCommandCenterProps> = ({
  onExecutionComplete,
}) => {
  const {
    templates,
    executions,
    executeWorkflow,
    isExecuting,
    colonyStatus,
    initColony,
    colonyHeartbeat,
    isColonyInitializing,
    alerts,
    acknowledgeAlert,
    metrics,
    availableOrganisms,
    findBestOrganism,
  } = useWorkflowEngine();

  const [selectedCategory, setSelectedCategory] = useState<
    WorkflowCategory | "All"
  >("All");
  const [showInputModal, setShowInputModal] = useState(false);
  const [pendingTemplate, setPendingTemplate] =
    useState<WorkflowTemplate | null>(null);
  const [inputValues, setInputValues] = useState<Record<string, string>>({});

  // Filter templates by category
  const filteredTemplates = useMemo(
    () =>
      selectedCategory === "All"
        ? templates
        : templates.filter((t) => t.category === selectedCategory),
    [templates, selectedCategory],
  );

  // Handle workflow execution
  const handleExecute = useCallback(
    async (templateId: string) => {
      const template = templates.find((t) => t.id === templateId);
      if (!template) return;

      // If template has input schema, show modal
      if (Object.keys(template.inputSchema).length > 0) {
        setPendingTemplate(template);
        setInputValues({});
        setShowInputModal(true);
        return;
      }

      // Execute directly
      const result = await executeWorkflow(templateId, {});
      onExecutionComplete?.(result);
    },
    [templates, executeWorkflow, onExecutionComplete],
  );

  const handleConfirmExecute = useCallback(async () => {
    if (!pendingTemplate) return;
    setShowInputModal(false);
    const result = await executeWorkflow(pendingTemplate.id, inputValues);
    setPendingTemplate(null);
    setInputValues({});
    onExecutionComplete?.(result);
  }, [pendingTemplate, inputValues, executeWorkflow, onExecutionComplete]);

  // Auto-heartbeat every 30 seconds when colony is initialized
  useEffect(() => {
    if (!colonyStatus?.isInitialized) return;
    const interval = setInterval(() => {
      colonyHeartbeat().catch(() => {});
    }, 30000);
    return () => clearInterval(interval);
  }, [colonyStatus?.isInitialized, colonyHeartbeat]);

  // Categories for filter
  const categories: Array<WorkflowCategory | "All"> = [
    "All",
    "Task",
    "Internal",
    "External",
    "Emergency",
    "Maintenance",
  ];

  return (
    <div className="flex flex-col h-full bg-slate-900 text-slate-100 overflow-hidden">
      {/* Header — Oro's Status Bar */}
      <div className="border-b border-slate-800 px-4 py-3 bg-slate-900/95 backdrop-blur">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-cyan-500 to-purple-600 flex items-center justify-center">
              <Cpu size={20} className="text-white" />
            </div>
            <div>
              <h2 className="text-sm font-semibold tracking-wide">
                ORO COMMAND CENTER
              </h2>
              <p className="text-[10px] text-slate-500 uppercase tracking-widest">
                Sovereign Organism Workspace • ICP Synced
              </p>
            </div>
          </div>

          <div className="flex items-center gap-4">
            {/* Colony Status */}
            <div className="text-right">
              <div className="text-[10px] text-slate-500">Colony Status</div>
              <div
                className={`text-xs font-medium ${
                  colonyStatus?.isInitialized
                    ? "text-green-400"
                    : "text-yellow-400"
                }`}
              >
                {colonyStatus?.isInitialized ? (
                  <>r_colony: {(colonyStatus.rColony ?? 0).toFixed(3)}</>
                ) : (
                  "Not Initialized"
                )}
              </div>
            </div>

            {/* Initialize / Heartbeat buttons */}
            {!colonyStatus?.isInitialized ? (
              <button
                type="button"
                onClick={() => initColony()}
                disabled={isColonyInitializing}
                className="px-3 py-1.5 text-xs bg-cyan-600 hover:bg-cyan-500 rounded transition-colors"
              >
                {isColonyInitializing ? "Initializing..." : "Initialize Colony"}
              </button>
            ) : (
              <button
                type="button"
                onClick={() => colonyHeartbeat()}
                className="px-3 py-1.5 text-xs bg-slate-700 hover:bg-slate-600 rounded transition-colors flex items-center gap-1"
              >
                <Zap size={12} />
                Heartbeat
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Metrics Row */}
      <div className="grid grid-cols-4 gap-3 px-4 py-3 border-b border-slate-800 bg-slate-900/50">
        <MetricCard
          label="Active Tasks"
          value={metrics.activeAgents}
          icon={<Play size={14} />}
          color="text-cyan-400"
        />
        <MetricCard
          label="Completed"
          value={metrics.totalTasksCompleted}
          icon={<CheckCircle2 size={14} />}
          color="text-green-400"
        />
        <MetricCard
          label="Throughput/hr"
          value={metrics.throughput}
          icon={<Zap size={14} />}
          color="text-yellow-400"
        />
        <MetricCard
          label="Organisms"
          value={availableOrganisms.length}
          icon={<Cpu size={14} />}
          color="text-purple-400"
        />
      </div>

      {/* Main Content Area */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left: Workflow Templates */}
        <div className="w-1/2 border-r border-slate-800 flex flex-col overflow-hidden">
          {/* Category Tabs */}
          <div className="flex items-center gap-1 px-4 py-2 border-b border-slate-800 overflow-x-auto">
            {categories.map((cat) => (
              <button
                type="button"
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`px-3 py-1.5 text-xs rounded transition-colors whitespace-nowrap ${
                  selectedCategory === cat
                    ? "bg-slate-700 text-slate-100"
                    : "text-slate-400 hover:text-slate-200"
                }`}
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Workflow List */}
          <div className="flex-1 overflow-y-auto p-4 space-y-3">
            {filteredTemplates.map((template) => {
              const best = findBestOrganism(template.requiredSpecializations);
              return (
                <WorkflowCard
                  key={template.id}
                  template={template}
                  onExecute={handleExecute}
                  isExecuting={isExecuting}
                  bestOrganism={
                    best
                      ? { name: best.name, coherence: best.shell.coherence }
                      : undefined
                  }
                />
              );
            })}
          </div>
        </div>

        {/* Right: Executions */}
        <div className="w-1/2 flex flex-col overflow-hidden">
          <div className="px-4 py-2 border-b border-slate-800">
            <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-widest">
              Workflow Executions
            </h3>
          </div>

          <div className="flex-1 overflow-y-auto p-4 space-y-2">
            {executions.length === 0 ? (
              <div className="text-center py-12 text-slate-500">
                <Clock size={32} className="mx-auto mb-2 opacity-50" />
                <p className="text-sm">No workflows executed yet</p>
                <p className="text-xs mt-1">Select a workflow to begin</p>
              </div>
            ) : (
              executions
                .sort((a, b) => (b.startedAt ?? 0) - (a.startedAt ?? 0))
                .map((exec) => <ExecutionRow key={exec.id} execution={exec} />)
            )}
          </div>
        </div>
      </div>

      {/* Alerts Bar */}
      {alerts.length > 0 && (
        <div className="border-t border-slate-800 bg-red-900/20 px-4 py-2">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <AlertCircle size={14} className="text-red-400" />
              <span className="text-xs text-red-300">{alerts[0].message}</span>
            </div>
            <button
              type="button"
              onClick={() => acknowledgeAlert(alerts[0].id)}
              className="text-xs text-red-400 hover:text-red-300"
            >
              Dismiss
            </button>
          </div>
        </div>
      )}

      {/* Input Modal */}
      {showInputModal && pendingTemplate && (
        <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50">
          <div className="bg-slate-800 border border-slate-700 rounded-lg w-full max-w-md p-6">
            <h3 className="text-lg font-semibold mb-4">
              {pendingTemplate.name}
            </h3>
            <p className="text-sm text-slate-400 mb-4">
              {pendingTemplate.description}
            </p>

            <div className="space-y-3">
              {Object.entries(pendingTemplate.inputSchema).map(
                ([key, type]) => (
                  <div key={key}>
                    <label
                      htmlFor={key}
                      className="block text-xs text-slate-400 mb-1 capitalize"
                    >
                      {key.replace(/_/g, " ")}
                    </label>
                    <input
                      id={key}
                      type={type === "number" ? "number" : "text"}
                      value={inputValues[key] ?? ""}
                      onChange={(e) =>
                        setInputValues((prev) => ({
                          ...prev,
                          [key]: e.target.value,
                        }))
                      }
                      className="w-full bg-slate-700 border border-slate-600 rounded px-3 py-2 text-sm focus:outline-none focus:border-cyan-500"
                      placeholder={`Enter ${key}...`}
                    />
                  </div>
                ),
              )}
            </div>

            <div className="flex justify-end gap-2 mt-6">
              <button
                type="button"
                onClick={() => {
                  setShowInputModal(false);
                  setPendingTemplate(null);
                }}
                className="px-4 py-2 text-sm bg-slate-700 hover:bg-slate-600 rounded"
              >
                Cancel
              </button>
              <button
                type="button"
                onClick={handleConfirmExecute}
                disabled={isExecuting}
                className="px-4 py-2 text-sm bg-cyan-600 hover:bg-cyan-500 rounded flex items-center gap-2"
              >
                {isExecuting ? (
                  <>
                    <RefreshCw size={14} className="animate-spin" />
                    Executing...
                  </>
                ) : (
                  <>
                    <Play size={14} />
                    Execute
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default OroCommandCenter;
