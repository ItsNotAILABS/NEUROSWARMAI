import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import {
  Activity,
  AtSign,
  BarChart2,
  Bot,
  Brain,
  Building2,
  ChevronDown,
  ChevronRight,
  Cpu,
  Database,
  Dna,
  Eye,
  FlaskConical,
  Globe,
  HelpCircle,
  Key,
  Layers,
  LogOut,
  Map as MapIcon,
  MessageSquare,
  Microscope,
  Plus,
  Radar,
  Shield,
  Shuffle,
  SlidersHorizontal,
  Sparkles,
  Swords,
  Terminal,
  Users,
  Wallet,
  Zap,
} from "lucide-react";
import { AnimatePresence, motion } from "motion/react";
import { useState } from "react";
import type { AppSection } from "../App";
import type { Workspace } from "../data/mockData";
import { useInternetIdentity } from "../hooks/useInternetIdentity";

interface SidebarProps {
  workspaces: Workspace[];
  activeWorkspaceId: string;
  activeThreadId: string;
  onSelectWorkspace: (wsId: string) => void;
  onSelectThread: (wsId: string, threadId: string) => void;
  onAddWorkspace: (name: string) => void;
  activeSection: AppSection;
  onSectionChange: (section: AppSection) => void;
  className?: string;
}

const TEAM_MEMBERS = [
  { name: "Alfredo M.", initials: "AM", status: "Online", color: "bg-primary" },
  {
    name: "Sarah J.",
    initials: "SJ",
    status: "Online",
    color: "bg-emerald-600",
  },
  { name: "Alex K.", initials: "AK", status: "Away", color: "bg-zinc-600" },
];

/** Uppercase tracking label — Linear-style nav section header */
function SectionLabel({ children }: { children: React.ReactNode }) {
  return (
    <span className="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 px-1">
      {children}
    </span>
  );
}

/** Collapsible nav group with label */
function NavGroup({
  label,
  children,
}: {
  label: string;
  children: React.ReactNode;
}) {
  const [open, setOpen] = useState(true);
  return (
    <div>
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        className="flex items-center gap-1 mb-1.5 px-1 w-full group"
      >
        <SectionLabel>{label}</SectionLabel>
        {open ? (
          <ChevronDown className="w-2.5 h-2.5 text-muted-foreground/40 group-hover:text-muted-foreground transition-colors" />
        ) : (
          <ChevronRight className="w-2.5 h-2.5 text-muted-foreground/40 group-hover:text-muted-foreground transition-colors" />
        )}
      </button>
      <AnimatePresence initial={false}>
        {open && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.14 }}
            className="overflow-hidden"
          >
            <div className="space-y-0.5">{children}</div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

/** Single nav item */
function NavItem({
  icon: Icon,
  label,
  section,
  activeSection,
  onSectionChange,
  ocid,
}: {
  icon: React.ElementType;
  label: string;
  section: AppSection;
  activeSection: AppSection;
  onSectionChange: (s: AppSection) => void;
  ocid: string;
}) {
  const isActive = activeSection === section;
  return (
    <button
      type="button"
      data-ocid={ocid}
      onClick={() => onSectionChange(section)}
      className={`w-full flex items-center gap-2.5 px-2 py-1.5 rounded-lg text-xs transition-all text-left touch-manipulation ${
        isActive
          ? "bg-surface-elevated text-foreground"
          : "text-muted-foreground/60 hover:text-foreground hover:bg-surface-elevated/50"
      }`}
    >
      <Icon
        className={`w-3.5 h-3.5 shrink-0 ${isActive ? "text-primary" : "text-muted-foreground/40"}`}
      />
      <span className="font-medium truncate">{label}</span>
      {isActive && (
        <span className="ml-auto w-1.5 h-1.5 rounded-full bg-primary shrink-0" />
      )}
    </button>
  );
}

function WorkspaceItem({
  workspace,
  isActive,
  activeThreadId,
  onSelectWorkspace,
  onSelectThread,
}: {
  workspace: Workspace;
  isActive: boolean;
  activeThreadId: string;
  onSelectWorkspace: (id: string) => void;
  onSelectThread: (wsId: string, tid: string) => void;
}) {
  const [expanded, setExpanded] = useState(isActive);

  return (
    <div>
      <button
        type="button"
        data-ocid={`workspace.item.${workspace.id}`}
        onClick={() => {
          onSelectWorkspace(workspace.id);
          setExpanded(true);
        }}
        className={`w-full flex items-center gap-2 px-2 py-2 rounded-lg text-left text-xs transition-all ${
          isActive
            ? "bg-surface-elevated text-foreground"
            : "text-muted-foreground hover:text-foreground hover:bg-surface-elevated/50"
        }`}
      >
        {/* Expand toggle */}
        <button
          type="button"
          onClick={(e) => {
            e.stopPropagation();
            setExpanded((v) => !v);
          }}
          className="shrink-0 text-muted-foreground/50 hover:text-muted-foreground transition-colors"
        >
          {expanded ? (
            <ChevronDown className="w-3 h-3" />
          ) : (
            <ChevronRight className="w-3 h-3" />
          )}
        </button>

        <span
          className={`flex-1 font-medium truncate text-xs ${
            isActive ? "text-foreground" : "text-muted-foreground"
          }`}
        >
          {workspace.name}
        </span>

        {/* Active accent dot */}
        {isActive && (
          <span className="w-1.5 h-1.5 rounded-full bg-primary shrink-0" />
        )}
      </button>

      <AnimatePresence initial={false}>
        {expanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.16 }}
            className="overflow-hidden"
          >
            <div className="ml-4 mt-0.5 border-l border-border/60 pl-3 space-y-0.5 pb-0.5">
              {workspace.threads.map((thread) => {
                const isThreadActive = activeThreadId === thread.id;
                return (
                  <button
                    type="button"
                    key={thread.id}
                    data-ocid={`thread.item.${thread.id}`}
                    onClick={() => onSelectThread(workspace.id, thread.id)}
                    className={`w-full flex items-center gap-2 px-2 py-1.5 rounded-md text-left transition-all ${
                      isThreadActive
                        ? "text-primary bg-primary/10"
                        : "text-muted-foreground/70 hover:text-foreground hover:bg-surface-elevated/50"
                    }`}
                  >
                    <MessageSquare
                      className={`w-3 h-3 shrink-0 ${
                        isThreadActive
                          ? "text-primary"
                          : "text-muted-foreground/40"
                      }`}
                    />
                    <span className="truncate text-[11px]">{thread.title}</span>
                  </button>
                );
              })}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

export function Sidebar({
  workspaces,
  activeWorkspaceId,
  activeThreadId,
  onSelectWorkspace,
  onSelectThread,
  onAddWorkspace,
  activeSection,
  onSectionChange,
  className = "",
}: SidebarProps) {
  const [newWsOpen, setNewWsOpen] = useState(false);
  const [newWsName, setNewWsName] = useState("");
  const { clear, identity } = useInternetIdentity();
  const principal = identity?.getPrincipal().toString();
  const shortPrincipal = principal ? `${principal.slice(0, 10)}…` : "Anonymous";

  const handleCreate = () => {
    if (newWsName.trim()) {
      onAddWorkspace(newWsName.trim());
      setNewWsName("");
      setNewWsOpen(false);
    }
  };

  return (
    <aside
      className={`w-[248px] shrink-0 h-full bg-sidebar flex flex-col border-r border-border overflow-hidden ${className}`}
    >
      {/* Brand */}
      <div className="px-4 py-4 border-b border-border">
        <div className="flex items-center gap-3">
          {/* Circular gradient brand mark */}
          <div
            className="w-8 h-8 rounded-full flex items-center justify-center shrink-0"
            style={{
              background:
                "conic-gradient(from 135deg, oklch(55% 0.145 165), oklch(70% 0.16 165), oklch(55% 0.145 165))",
              boxShadow: "0 0 10px oklch(62% 0.145 165 / 0.25)",
            }}
          >
            <span className="text-[11px] font-black text-background select-none tracking-tight">
              OC
            </span>
          </div>
          <div className="leading-none">
            <div className="text-xs font-bold text-foreground tracking-tight">
              Organism
            </div>
            <div className="text-[10px] text-muted-foreground/60 mt-0.5 tracking-wide uppercase">
              Command Platform
            </div>
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-3 py-3 space-y-4">
        {/* ── PLATFORM ─────────────────────────────────────────────── */}
        <NavGroup label="Platform">
          <NavItem
            icon={Terminal}
            label="Command Workspace"
            section="command"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.command.link"
          />
          <NavItem
            icon={Cpu}
            label="Organism Workforce"
            section="workforce"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.workforce.link"
          />
        </NavGroup>

        <div className="border-t border-border/40" />

        {/* ── ORGANISM ─────────────────────────────────────────────── */}
        <NavGroup label="Organism">
          <NavItem
            icon={Dna}
            label="Genesis Dashboard"
            section="genesis"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.genesis.link"
          />
          <NavItem
            icon={Brain}
            label="Neural Architect"
            section="neural-architect"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.neural-architect.link"
          />
          <NavItem
            icon={Layers}
            label="Super Substrate 512"
            section="substrate"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.substrate.link"
          />
          <NavItem
            icon={Shuffle}
            label="Evolution Panel"
            section="evolution"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.evolution.link"
          />
          <NavItem
            icon={Activity}
            label="Neuro Emergence"
            section="neuro-emergence"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.neuro-emergence.link"
          />
          <NavItem
            icon={Zap}
            label="Quantum Memory"
            section="quantum-memory"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.quantum-memory.link"
          />
          <NavItem
            icon={FlaskConical}
            label="Organism Generator"
            section="organism-generator"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.organism-generator.link"
          />
          <NavItem
            icon={Database}
            label="Organism Inventory"
            section="organism-inventory"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.organism-inventory.link"
          />
          <NavItem
            icon={Shuffle}
            label="Marketplace"
            section="organism-marketplace"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.organism-marketplace.link"
          />
          <NavItem
            icon={Eye}
            label="Live Viewer"
            section="organism-viewer"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.organism-viewer.link"
          />
          <NavItem
            icon={AtSign}
            label="ORO Command"
            section="oro-command"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.oro-command.link"
          />
        </NavGroup>

        <div className="border-t border-border/40" />

        {/* ── AGI CORE ─────────────────────────────────────────────── */}
        <NavGroup label="AGI Core">
          <NavItem
            icon={Sparkles}
            label="NOVA — Living Canvas"
            section="nova"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.nova.link"
          />
          <NavItem
            icon={Cpu}
            label="TAS — World Computer"
            section="tas"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.tas.link"
          />
          <NavItem
            icon={Bot}
            label="AUTO — AGI Chat"
            section="auto"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.auto.link"
          />
        </NavGroup>

        <div className="border-t border-border/40" />

        {/* ── WORLD ────────────────────────────────────────────────── */}
        <NavGroup label="World">
          <NavItem
            icon={Globe}
            label="Macro World"
            section="macro-world"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.macro-world.link"
          />
          <NavItem
            icon={Swords}
            label="Factions"
            section="factions"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.factions.link"
          />
          <NavItem
            icon={Activity}
            label="Trade"
            section="trade"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.trade.link"
          />
          <NavItem
            icon={Shield}
            label="Mission Control"
            section="missions"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.missions.link"
          />
          <NavItem
            icon={Microscope}
            label="Colony"
            section="colony"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.colony.link"
          />
          <NavItem
            icon={MapIcon}
            label="Atlas Grid"
            section="atlas"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.atlas.link"
          />
        </NavGroup>

        <div className="border-t border-border/40" />

        {/* ── ENTERPRISE ───────────────────────────────────────────── */}
        <NavGroup label="Enterprise">
          <NavItem
            icon={Users}
            label="Team Dashboard"
            section="team-dashboard"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.team-dashboard.link"
          />
          <NavItem
            icon={BarChart2}
            label="Analytics"
            section="analytics"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.analytics.link"
          />
          <NavItem
            icon={Building2}
            label="Governance"
            section="governance"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.governance.link"
          />
          <NavItem
            icon={Globe}
            label="GRPE Command"
            section="grpe-command"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.grpe-command.link"
          />
          <NavItem
            icon={Wallet}
            label="Token Dashboard"
            section="token"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.token.link"
          />
          <NavItem
            icon={Radar}
            label="Geo Scanner"
            section="geo-scanner"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.geo-scanner.link"
          />
          <NavItem
            icon={Bot}
            label="MERIDIANUS"
            section="jarvis"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.jarvis.link"
          />
          <NavItem
            icon={Brain}
            label="PARALLAX Models"
            section="models"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.models.link"
          />
          <NavItem
            icon={Brain}
            label="AI UX"
            section="ai-ux"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.ai-ux.link"
          />
          <NavItem
            icon={Brain}
            label="Multi-Engine"
            section="multi-engine"
            activeSection={activeSection}
            onSectionChange={onSectionChange}
            ocid="nav.multi-engine.link"
          />
        </NavGroup>

        <div className="border-t border-border/40" />

        {/* ── WORKSPACES ───────────────────────────────────────────── */}
        {activeSection === "command" && (
          <div>
            <div className="flex items-center justify-between mb-2 px-1">
              <SectionLabel>Workspaces</SectionLabel>
              <button
                type="button"
                data-ocid="workspace.open_modal_button"
                onClick={() => setNewWsOpen(true)}
                className="p-0.5 text-muted-foreground/50 hover:text-muted-foreground transition-colors rounded"
              >
                <Plus className="w-3 h-3" />
              </button>
            </div>
            <div className="space-y-0.5">
              {workspaces.map((ws) => (
                <WorkspaceItem
                  key={ws.id}
                  workspace={ws}
                  isActive={ws.id === activeWorkspaceId}
                  activeThreadId={activeThreadId}
                  onSelectWorkspace={onSelectWorkspace}
                  onSelectThread={onSelectThread}
                />
              ))}
            </div>
          </div>
        )}

        <div className="border-t border-border/40" />

        {/* ── TEAM ────────────────────────────────────────────────── */}
        <div>
          <div className="mb-2 px-1">
            <SectionLabel>Team</SectionLabel>
          </div>
          <div className="space-y-0.5">
            {TEAM_MEMBERS.map((member) => (
              <div
                key={member.name}
                className="flex items-center gap-2.5 px-2 py-1.5 rounded-lg hover:bg-surface-elevated/50 transition-colors"
              >
                <div
                  className={`w-6 h-6 rounded-md ${member.color} flex items-center justify-center text-[9px] font-bold text-white shrink-0`}
                >
                  {member.initials}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="text-xs text-foreground leading-tight">
                    {member.name}
                  </div>
                </div>
                <span
                  className={`w-1.5 h-1.5 rounded-full shrink-0 ${
                    member.status === "Online"
                      ? "bg-success"
                      : "bg-muted-foreground/30"
                  }`}
                />
              </div>
            ))}
          </div>
        </div>

        <div className="border-t border-border/40" />

        {/* ── SETTINGS ────────────────────────────────────────────── */}
        <div>
          <div className="mb-2 px-1">
            <SectionLabel>Settings</SectionLabel>
          </div>
          <div className="space-y-0.5">
            {[
              { icon: Key, label: "API Keys" },
              { icon: SlidersHorizontal, label: "Configuration" },
              { icon: HelpCircle, label: "Support" },
            ].map(({ icon: Icon, label }) => (
              <button
                type="button"
                key={label}
                data-ocid={`settings.${label.toLowerCase().replace(" ", "_")}.link`}
                className="w-full flex items-center gap-2.5 px-2 py-1.5 rounded-lg text-xs text-muted-foreground/60 hover:text-foreground hover:bg-surface-elevated/50 transition-colors text-left"
              >
                <Icon className="w-3.5 h-3.5" />
                <span>{label}</span>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* User footer */}
      <div className="px-3 py-3 border-t border-border">
        <div className="flex items-center gap-2.5 px-2">
          <div className="w-6 h-6 rounded-md bg-primary flex items-center justify-center text-[9px] font-bold text-primary-foreground shrink-0">
            AM
          </div>
          <div className="flex-1 min-w-0">
            <div className="text-xs text-foreground font-semibold truncate leading-tight">
              Alfredo Medina
            </div>
            <div className="text-[10px] text-muted-foreground/50 truncate leading-tight font-mono">
              {shortPrincipal}
            </div>
          </div>
          <button
            type="button"
            data-ocid="auth.logout.button"
            onClick={clear}
            aria-label="Logout"
            className="text-muted-foreground/40 hover:text-muted-foreground transition-colors"
          >
            <LogOut className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>

      <Dialog open={newWsOpen} onOpenChange={setNewWsOpen}>
        <DialogContent
          data-ocid="workspace.dialog"
          className="bg-surface border-border"
        >
          <DialogHeader>
            <DialogTitle className="text-foreground">New Workspace</DialogTitle>
          </DialogHeader>
          <Input
            data-ocid="workspace.input"
            value={newWsName}
            onChange={(e) => setNewWsName(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && handleCreate()}
            placeholder="Workspace name..."
            className="bg-surface-elevated border-border text-foreground"
            autoFocus
          />
          <DialogFooter>
            <Button
              data-ocid="workspace.cancel_button"
              variant="ghost"
              onClick={() => setNewWsOpen(false)}
              className="text-muted-foreground"
            >
              Cancel
            </Button>
            <Button
              data-ocid="workspace.confirm_button"
              onClick={handleCreate}
              className="bg-primary text-primary-foreground hover:bg-primary/90"
            >
              Create
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </aside>
  );
}
