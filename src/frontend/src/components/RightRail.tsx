import { Progress } from "@/components/ui/progress";
import { ChevronRight, Code2, Database, FileText, Network } from "lucide-react";
import { AnimatePresence, motion } from "motion/react";
import type { AgentTask, Artifact } from "../data/mockData";

interface RightRailProps {
  tasks: AgentTask[];
  artifacts: Artifact[];
  onArtifactClick: (artifact: Artifact) => void;
  className?: string;
}

function TaskStatusPill({ status }: { status: AgentTask["status"] }) {
  if (status === "RUNNING") {
    return (
      <div className="flex items-center gap-1.5">
        <span className="w-1.5 h-1.5 rounded-full bg-sky-400 animate-pulse shrink-0" />
        <span className="text-[10px] font-medium text-sky-400 uppercase tracking-wide">
          Running
        </span>
      </div>
    );
  }
  if (status === "DONE") {
    return (
      <span className="text-[10px] font-medium text-emerald-400 uppercase tracking-wide">
        Done
      </span>
    );
  }
  return (
    <span className="text-[10px] font-medium text-red-400 uppercase tracking-wide">
      Failed
    </span>
  );
}

function ArtifactIcon({ type }: { type: Artifact["type"] }) {
  if (type === "code") return <Code2 className="w-3.5 h-3.5 text-primary" />;
  if (type === "pdf") return <FileText className="w-3.5 h-3.5 text-sky-400" />;
  return <Network className="w-3.5 h-3.5 text-emerald-400" />;
}

/** Uppercase tracking section header — consistent with Sidebar */
function RailSectionHeader({
  title,
  badge,
}: {
  title: string;
  badge?: React.ReactNode;
}) {
  return (
    <div className="px-4 py-2.5 border-b border-border bg-sidebar/80 flex items-center justify-between">
      <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
        {title}
      </span>
      {badge}
    </div>
  );
}

export function RightRail({
  tasks,
  artifacts,
  onArtifactClick,
  className = "",
}: RightRailProps) {
  const runningCount = tasks.filter((t) => t.status === "RUNNING").length;

  return (
    <aside
      className={`w-[288px] shrink-0 h-full bg-sidebar border-l border-border flex flex-col overflow-hidden ${className}`}
    >
      <div className="flex-1 overflow-y-auto p-3 space-y-3">
        {/* FORMA Economy Bar */}
        <div className="rounded-xl border border-border bg-surface overflow-hidden">
          <div className="px-4 py-3 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Database className="w-3.5 h-3.5 text-primary" />
              <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/60">
                FORMA Economy
              </span>
            </div>
            <div className="flex items-center gap-1.5">
              <span className="font-mono text-sm font-bold text-primary">
                2,847
              </span>
              <span className="text-[10px] text-muted-foreground/50 font-semibold uppercase tracking-wide">
                FORMA
              </span>
            </div>
          </div>
        </div>

        {/* Agent Task Queue */}
        <div className="rounded-xl border border-border bg-surface overflow-hidden">
          <RailSectionHeader
            title="Agent Tasks"
            badge={
              runningCount > 0 ? (
                <div className="flex items-center gap-1.5">
                  <span className="w-1.5 h-1.5 rounded-full bg-sky-400 animate-pulse" />
                  <span className="text-[10px] text-sky-400 font-medium">
                    {runningCount} active
                  </span>
                </div>
              ) : null
            }
          />
          <div className="divide-y divide-border/60">
            <AnimatePresence initial={false}>
              {tasks.map((task, i) => (
                <motion.div
                  key={task.id}
                  data-ocid={`task.item.${i + 1}`}
                  initial={{ opacity: 0, x: 8 }}
                  animate={{ opacity: 1, x: 0 }}
                  exit={{ opacity: 0, x: 8 }}
                  transition={{ duration: 0.18 }}
                  className="px-4 py-3"
                >
                  <div className="flex items-start justify-between gap-2 mb-0.5">
                    <div className="flex-1 min-w-0">
                      <div className="text-xs font-medium text-foreground truncate">
                        {task.name}
                      </div>
                      <div className="text-[10px] text-muted-foreground/60 mt-0.5 font-mono truncate">
                        {task.agent}
                      </div>
                    </div>
                    <TaskStatusPill status={task.status} />
                  </div>
                  {task.status === "RUNNING" && (
                    <div className="mt-2.5 space-y-1.5">
                      <Progress
                        value={task.progress}
                        className="h-1.5 bg-surface-elevated [&>div]:bg-sky-400"
                      />
                      <div className="flex items-center justify-between">
                        <span className="text-[10px] text-muted-foreground/50">
                          Processing...
                        </span>
                        <span className="text-[10px] text-muted-foreground/60 font-mono">
                          {task.progress}%
                        </span>
                      </div>
                    </div>
                  )}
                </motion.div>
              ))}
            </AnimatePresence>
            {tasks.length === 0 && (
              <div
                data-ocid="task.empty_state"
                className="px-4 py-8 text-center"
              >
                <div className="w-8 h-8 rounded-full bg-surface-elevated border border-border flex items-center justify-center mx-auto mb-2">
                  <span className="text-muted-foreground/30 text-xs">—</span>
                </div>
                <p className="text-xs text-muted-foreground/50">
                  No active tasks
                </p>
              </div>
            )}
          </div>
        </div>

        {/* Artifacts */}
        <div className="rounded-xl border border-border bg-surface overflow-hidden">
          <RailSectionHeader
            title="Artifacts"
            badge={
              artifacts.length > 0 ? (
                <span className="text-[10px] text-muted-foreground/50 font-mono">
                  {artifacts.length}
                </span>
              ) : null
            }
          />
          <div className="divide-y divide-border/60">
            {artifacts.map((artifact, i) => (
              <button
                type="button"
                key={artifact.id}
                data-ocid={`artifact.item.${i + 1}`}
                onClick={() => onArtifactClick(artifact)}
                className="w-full px-4 py-3 flex items-center gap-3 hover:bg-surface-elevated/50 transition-colors text-left group"
              >
                <div className="w-7 h-7 rounded-lg bg-surface-elevated border border-border/60 flex items-center justify-center shrink-0">
                  <ArtifactIcon type={artifact.type} />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-xs font-medium text-foreground truncate">
                    {artifact.name}
                  </div>
                  <div className="text-[10px] text-muted-foreground/50 mt-0.5 capitalize">
                    {artifact.type === "pdf"
                      ? `${artifact.pages} pages · ${artifact.size}`
                      : artifact.type === "code"
                        ? artifact.language?.toUpperCase()
                        : "Interactive Canvas"}
                  </div>
                </div>
                <ChevronRight className="w-3.5 h-3.5 text-muted-foreground/30 group-hover:text-muted-foreground transition-colors shrink-0" />
              </button>
            ))}
            {artifacts.length === 0 && (
              <div className="px-4 py-8 text-center">
                <p className="text-xs text-muted-foreground/50">
                  No artifacts yet
                </p>
              </div>
            )}
          </div>
        </div>
      </div>
    </aside>
  );
}
