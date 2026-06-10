// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  CEO ENTERPRISE DASHBOARD — COMPLETE COMMAND AND CONTROL CENTER                                           ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE ARCHITECT'S WINDOW — Real-time view of the entire enterprise.                                       ║
// ║  All organisms, projects, revenue, governance, compliance — one unified view.                            ║
// ║  All metrics compound. All formulas interconnect. All mathematics are real.                              ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  AlertTriangle,
  ArrowDown,
  ArrowUp,
  Award,
  BarChart3,
  Brain,
  Briefcase,
  Building2,
  Calendar,
  Check,
  CheckCircle2,
  ChevronRight,
  Clock,
  Coins,
  Crown,
  DollarSign,
  FileText,
  Flame,
  FolderKanban,
  GitBranch,
  Globe2,
  Heart,
  Layers,
  LayoutGrid,
  LineChart,
  ListTodo,
  Lock,
  Mail,
  MessageSquare,
  Milestone,
  Network,
  PieChart,
  Scale,
  Settings,
  Shield,
  ShieldCheck,
  Sparkles,
  Star,
  Target,
  Timer,
  TrendingDown,
  TrendingUp,
  Trophy,
  User,
  UserCheck,
  UserPlus,
  Users,
  Vote,
  Wallet,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 1: TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface CEODashboardProps {
  className?: string;
}

interface ExecutiveSummary {
  totalOrganisms: number;
  activeProjects: number;
  totalRevenue: number;
  revenueChange: number;
  complianceScore: number;
  kuramotoR: number;
  systemHeartbeat: number;
  lawEngineScore: number;
  heritageAvg: number;
  omnisCharge: number;
  activeTasks: number;
  completedTasks: number;
  pendingApprovals: number;
  slaViolations: number;
}

interface OrganismStatus {
  id: string;
  name: string;
  class: "Avatar" | "Entity" | "Worker";
  specialization: string;
  coherence: number;
  driveMode: "Execution" | "Exploration" | "Learning" | "Rest";
  activeTasks: number;
  performanceScore: number;
  formaBalance: number;
}

interface ProjectSummary {
  id: string;
  name: string;
  status: "Planning" | "Active" | "OnHold" | "Completed";
  progress: number;
  budget: number;
  spent: number;
  teamSize: number;
  deadline: string;
  health: "Good" | "AtRisk" | "Critical";
}

interface TreasuryStatus {
  totalForma: number;
  totalSeed: number;
  totalGtk: number;
  totalStaked: number;
  pendingRevenue: number;
  architectShare: number;
  playerShare: number;
  jubileeCycle: number;
  beatsUntilJubilee: number;
}

interface GovernanceStatus {
  activeProposals: number;
  pendingVotes: number;
  councilMembers: number;
  quorumMet: boolean;
  lastProposalId: string;
  complianceScore: number;
  criticalViolations: number;
  openViolations: number;
}

interface AEGISStatus {
  emergencyMode: boolean;
  shieldStrength: number;
  rollbackCount: number;
  lastRollbackBeat: number;
  snapshotCount: number;
  doctrineIntact: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 2: MOCK DATA FOR UI DEMONSTRATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const MOCK_EXECUTIVE_SUMMARY: ExecutiveSummary = {
  totalOrganisms: 23,
  activeProjects: 8,
  totalRevenue: 1250000,
  revenueChange: 12.5,
  complianceScore: 98.5,
  kuramotoR: 0.92,
  systemHeartbeat: 45678,
  lawEngineScore: 0.97,
  heritageAvg: 1.45,
  omnisCharge: 0.78,
  activeTasks: 156,
  completedTasks: 847,
  pendingApprovals: 12,
  slaViolations: 2,
};

const MOCK_ORGANISMS: OrganismStatus[] = [
  { id: "org-1", name: "ORO", class: "Avatar", specialization: "Communication + Orchestration", coherence: 0.95, driveMode: "Execution", activeTasks: 12, performanceScore: 98, formaBalance: 15000 },
  { id: "org-2", name: "NEXUS", class: "Avatar", specialization: "Orchestration + Strategy", coherence: 0.92, driveMode: "Execution", activeTasks: 8, performanceScore: 96, formaBalance: 12500 },
  { id: "org-3", name: "FORGE-X", class: "Entity", specialization: "Software Engineering + DevOps", coherence: 0.89, driveMode: "Learning", activeTasks: 25, performanceScore: 94, formaBalance: 8900 },
  { id: "org-4", name: "AXIOM", class: "Entity", specialization: "Legal + Compliance", coherence: 0.94, driveMode: "Execution", activeTasks: 15, performanceScore: 97, formaBalance: 11200 },
  { id: "org-5", name: "STRATUM", class: "Entity", specialization: "Finance", coherence: 0.91, driveMode: "Execution", activeTasks: 10, performanceScore: 95, formaBalance: 9800 },
  { id: "org-6", name: "CIPHER", class: "Entity", specialization: "Cybersecurity + Compliance", coherence: 0.96, driveMode: "Exploration", activeTasks: 7, performanceScore: 99, formaBalance: 10500 },
];

const MOCK_PROJECTS: ProjectSummary[] = [
  { id: "proj-1", name: "Enterprise Platform v2.0", status: "Active", progress: 75, budget: 500000, spent: 375000, teamSize: 8, deadline: "2026-06-15", health: "Good" },
  { id: "proj-2", name: "FORMA Token Launch", status: "Active", progress: 60, budget: 250000, spent: 180000, teamSize: 5, deadline: "2026-05-01", health: "Good" },
  { id: "proj-3", name: "Compliance Framework", status: "Active", progress: 85, budget: 150000, spent: 140000, teamSize: 4, deadline: "2026-04-30", health: "AtRisk" },
  { id: "proj-4", name: "AEGIS Security Audit", status: "Planning", progress: 10, budget: 100000, spent: 10000, teamSize: 3, deadline: "2026-07-01", health: "Good" },
];

const MOCK_TREASURY: TreasuryStatus = {
  totalForma: 2500000,
  totalSeed: 500000,
  totalGtk: 1000000,
  totalStaked: 750000,
  pendingRevenue: 125000,
  architectShare: 125000,
  playerShare: 1125000,
  jubileeCycle: 1,
  beatsUntilJubilee: 735840,
};

const MOCK_GOVERNANCE: GovernanceStatus = {
  activeProposals: 3,
  pendingVotes: 5,
  councilMembers: 12,
  quorumMet: true,
  lastProposalId: "PROP-47",
  complianceScore: 98.5,
  criticalViolations: 0,
  openViolations: 2,
};

const MOCK_AEGIS: AEGISStatus = {
  emergencyMode: false,
  shieldStrength: 1.0,
  rollbackCount: 3,
  lastRollbackBeat: 42156,
  snapshotCount: 7,
  doctrineIntact: true,
};

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 3: UTILITY COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

function MetricCard({ 
  title, 
  value, 
  change, 
  icon: Icon, 
  color,
  subtitle,
}: { 
  title: string; 
  value: string | number; 
  change?: number; 
  icon: React.ElementType; 
  color: string;
  subtitle?: string;
}) {
  return (
    <Card className={`bg-black/40 border-${color}/30 hover:border-${color}/50 transition-all`}>
      <CardContent className="p-4">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-xs text-zinc-400 uppercase tracking-wider">{title}</p>
            <p className={`text-2xl font-bold text-${color}`}>{value}</p>
            {subtitle && <p className="text-xs text-zinc-500">{subtitle}</p>}
          </div>
          <div className={`p-3 rounded-lg bg-${color}/20`}>
            <Icon className={`w-5 h-5 text-${color}`} />
          </div>
        </div>
        {change !== undefined && (
          <div className="flex items-center mt-2 text-xs">
            {change >= 0 ? (
              <ArrowUp className="w-3 h-3 text-green-500 mr-1" />
            ) : (
              <ArrowDown className="w-3 h-3 text-red-500 mr-1" />
            )}
            <span className={change >= 0 ? "text-green-500" : "text-red-500"}>
              {Math.abs(change).toFixed(1)}%
            </span>
            <span className="text-zinc-500 ml-1">vs last period</span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function OrganismRow({ organism }: { organism: OrganismStatus }) {
  const classBadge = {
    Avatar: "bg-purple-500/20 text-purple-400 border-purple-500/30",
    Entity: "bg-blue-500/20 text-blue-400 border-blue-500/30",
    Worker: "bg-green-500/20 text-green-400 border-green-500/30",
  };

  const driveColor = {
    Execution: "text-green-400",
    Exploration: "text-blue-400",
    Learning: "text-yellow-400",
    Rest: "text-zinc-400",
  };

  return (
    <div className="flex items-center justify-between p-3 bg-black/30 rounded-lg border border-zinc-800 hover:border-zinc-700 transition-all">
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-amber-500/20 to-orange-600/20 flex items-center justify-center">
          <Brain className="w-5 h-5 text-amber-400" />
        </div>
        <div>
          <div className="flex items-center gap-2">
            <span className="font-semibold text-zinc-100">{organism.name}</span>
            <Badge variant="outline" className={classBadge[organism.class]}>
              {organism.class}
            </Badge>
          </div>
          <p className="text-xs text-zinc-500">{organism.specialization}</p>
        </div>
      </div>
      
      <div className="flex items-center gap-6">
        <div className="text-right">
          <p className="text-xs text-zinc-400">Coherence</p>
          <p className="font-semibold text-cyan-400">{(organism.coherence * 100).toFixed(1)}%</p>
        </div>
        <div className="text-right">
          <p className="text-xs text-zinc-400">Drive</p>
          <p className={`font-semibold ${driveColor[organism.driveMode]}`}>{organism.driveMode}</p>
        </div>
        <div className="text-right">
          <p className="text-xs text-zinc-400">Tasks</p>
          <p className="font-semibold text-zinc-200">{organism.activeTasks}</p>
        </div>
        <div className="text-right">
          <p className="text-xs text-zinc-400">FORMA</p>
          <p className="font-semibold text-amber-400">{organism.formaBalance.toLocaleString()}</p>
        </div>
      </div>
    </div>
  );
}

function ProjectRow({ project }: { project: ProjectSummary }) {
  const statusColor = {
    Planning: "bg-blue-500/20 text-blue-400 border-blue-500/30",
    Active: "bg-green-500/20 text-green-400 border-green-500/30",
    OnHold: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
    Completed: "bg-purple-500/20 text-purple-400 border-purple-500/30",
  };

  const healthColor = {
    Good: "text-green-400",
    AtRisk: "text-yellow-400",
    Critical: "text-red-400",
  };

  const healthIcon = {
    Good: CheckCircle2,
    AtRisk: AlertTriangle,
    Critical: AlertTriangle,
  };

  const HealthIcon = healthIcon[project.health];

  return (
    <div className="p-4 bg-black/30 rounded-lg border border-zinc-800 hover:border-zinc-700 transition-all">
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-3">
          <FolderKanban className="w-5 h-5 text-blue-400" />
          <span className="font-semibold text-zinc-100">{project.name}</span>
          <Badge variant="outline" className={statusColor[project.status]}>
            {project.status}
          </Badge>
        </div>
        <div className="flex items-center gap-2">
          <HealthIcon className={`w-4 h-4 ${healthColor[project.health]}`} />
          <span className={`text-sm ${healthColor[project.health]}`}>{project.health}</span>
        </div>
      </div>
      
      <div className="space-y-2">
        <div className="flex items-center justify-between text-sm">
          <span className="text-zinc-400">Progress</span>
          <span className="text-zinc-200">{project.progress}%</span>
        </div>
        <Progress value={project.progress} className="h-2" />
      </div>
      
      <div className="flex items-center justify-between mt-3 text-xs text-zinc-400">
        <div className="flex items-center gap-4">
          <span className="flex items-center gap-1">
            <Users className="w-3 h-3" />
            {project.teamSize} members
          </span>
          <span className="flex items-center gap-1">
            <Calendar className="w-3 h-3" />
            Due: {project.deadline}
          </span>
        </div>
        <div className="flex items-center gap-4">
          <span>Budget: ${project.budget.toLocaleString()}</span>
          <span>Spent: ${project.spent.toLocaleString()}</span>
        </div>
      </div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 4: MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export function CEODashboard({ className = "" }: CEODashboardProps) {
  const [summary, setSummary] = useState<ExecutiveSummary>(MOCK_EXECUTIVE_SUMMARY);
  const [organisms, setOrganisms] = useState<OrganismStatus[]>(MOCK_ORGANISMS);
  const [projects, setProjects] = useState<ProjectSummary[]>(MOCK_PROJECTS);
  const [treasury, setTreasury] = useState<TreasuryStatus>(MOCK_TREASURY);
  const [governance, setGovernance] = useState<GovernanceStatus>(MOCK_GOVERNANCE);
  const [aegis, setAegis] = useState<AEGISStatus>(MOCK_AEGIS);
  const [activeTab, setActiveTab] = useState("overview");

  // Simulate real-time updates
  useEffect(() => {
    const interval = setInterval(() => {
      setSummary(prev => ({
        ...prev,
        systemHeartbeat: prev.systemHeartbeat + 1,
        kuramotoR: Math.min(1, Math.max(0.75, prev.kuramotoR + (Math.random() - 0.5) * 0.01)),
        lawEngineScore: Math.min(1, Math.max(0.9, prev.lawEngineScore + (Math.random() - 0.5) * 0.005)),
      }));
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  return (
    <div className={`min-h-screen bg-zinc-950 text-zinc-100 p-6 ${className}`}>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Crown className="w-6 h-6 text-amber-400" />
            CEO Enterprise Dashboard
          </h1>
          <p className="text-sm text-zinc-400 mt-1">
            Complete command and control center — Beat #{summary.systemHeartbeat.toLocaleString()}
          </p>
        </div>
        <div className="flex items-center gap-4">
          <div className="flex items-center gap-2 px-3 py-1.5 bg-green-500/20 rounded-full border border-green-500/30">
            <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
            <span className="text-sm text-green-400">System Online</span>
          </div>
          <Badge variant="outline" className="border-cyan-500/30 text-cyan-400">
            r = {summary.kuramotoR.toFixed(3)}
          </Badge>
          <Badge variant="outline" className="border-amber-500/30 text-amber-400">
            Heritage: {summary.heritageAvg.toFixed(2)}×
          </Badge>
        </div>
      </div>

      {/* Main Content */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="bg-zinc-900 border border-zinc-800">
          <TabsTrigger value="overview" className="data-[state=active]:bg-zinc-800">
            <LayoutGrid className="w-4 h-4 mr-2" />
            Overview
          </TabsTrigger>
          <TabsTrigger value="organisms" className="data-[state=active]:bg-zinc-800">
            <Brain className="w-4 h-4 mr-2" />
            Organisms
          </TabsTrigger>
          <TabsTrigger value="projects" className="data-[state=active]:bg-zinc-800">
            <FolderKanban className="w-4 h-4 mr-2" />
            Projects
          </TabsTrigger>
          <TabsTrigger value="treasury" className="data-[state=active]:bg-zinc-800">
            <Wallet className="w-4 h-4 mr-2" />
            Treasury
          </TabsTrigger>
          <TabsTrigger value="governance" className="data-[state=active]:bg-zinc-800">
            <Scale className="w-4 h-4 mr-2" />
            Governance
          </TabsTrigger>
          <TabsTrigger value="security" className="data-[state=active]:bg-zinc-800">
            <Shield className="w-4 h-4 mr-2" />
            Security
          </TabsTrigger>
        </TabsList>

        {/* Overview Tab */}
        <TabsContent value="overview" className="space-y-6">
          {/* Key Metrics */}
          <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
            <MetricCard
              title="Total Organisms"
              value={summary.totalOrganisms}
              icon={Brain}
              color="amber"
              subtitle="Active workforce"
            />
            <MetricCard
              title="Active Projects"
              value={summary.activeProjects}
              icon={FolderKanban}
              color="blue"
            />
            <MetricCard
              title="Revenue"
              value={`$${(summary.totalRevenue / 1000).toFixed(0)}K`}
              change={summary.revenueChange}
              icon={DollarSign}
              color="green"
            />
            <MetricCard
              title="Compliance"
              value={`${summary.complianceScore}%`}
              icon={ShieldCheck}
              color="cyan"
            />
            <MetricCard
              title="Active Tasks"
              value={summary.activeTasks}
              icon={ListTodo}
              color="purple"
            />
            <MetricCard
              title="Approvals"
              value={summary.pendingApprovals}
              icon={CheckCircle2}
              color="orange"
              subtitle="Pending review"
            />
          </div>

          {/* Main Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* System Health */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Activity className="w-5 h-5 text-green-400" />
                  System Health
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-zinc-400">Kuramoto Coherence (r)</span>
                    <span className="text-cyan-400">{(summary.kuramotoR * 100).toFixed(1)}%</span>
                  </div>
                  <Progress value={summary.kuramotoR * 100} className="h-2" />
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-zinc-400">Law Engine Score</span>
                    <span className="text-green-400">{(summary.lawEngineScore * 100).toFixed(1)}%</span>
                  </div>
                  <Progress value={summary.lawEngineScore * 100} className="h-2" />
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-zinc-400">OMNIS Charge</span>
                    <span className="text-purple-400">{(summary.omnisCharge * 100).toFixed(0)}%</span>
                  </div>
                  <Progress value={summary.omnisCharge * 100} className="h-2" />
                </div>
                <Separator className="bg-zinc-800" />
                <div className="flex items-center justify-between">
                  <span className="text-sm text-zinc-400">Doctrine Integrity</span>
                  <Badge className="bg-green-500/20 text-green-400 border-green-500/30">
                    <Check className="w-3 h-3 mr-1" />
                    Intact
                  </Badge>
                </div>
              </CardContent>
            </Card>

            {/* Top Organisms */}
            <Card className="bg-black/40 border-zinc-800 lg:col-span-2">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Brain className="w-5 h-5 text-amber-400" />
                  Top Performing Organisms
                </CardTitle>
              </CardHeader>
              <CardContent>
                <ScrollArea className="h-[300px]">
                  <div className="space-y-3">
                    {organisms.slice(0, 5).map(organism => (
                      <OrganismRow key={organism.id} organism={organism} />
                    ))}
                  </div>
                </ScrollArea>
              </CardContent>
            </Card>
          </div>

          {/* Active Projects */}
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <FolderKanban className="w-5 h-5 text-blue-400" />
                Active Projects
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {projects.map(project => (
                  <ProjectRow key={project.id} project={project} />
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Organisms Tab */}
        <TabsContent value="organisms" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <MetricCard
              title="Total Organisms"
              value={summary.totalOrganisms}
              icon={Brain}
              color="amber"
            />
            <MetricCard
              title="Active in Execution"
              value={organisms.filter(o => o.driveMode === "Execution").length}
              icon={Zap}
              color="green"
            />
            <MetricCard
              title="Total FORMA Balance"
              value={organisms.reduce((sum, o) => sum + o.formaBalance, 0).toLocaleString()}
              icon={Coins}
              color="amber"
            />
          </div>
          
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Brain className="w-5 h-5 text-amber-400" />
                All Organisms
              </CardTitle>
              <CardDescription>Complete workforce status and metrics</CardDescription>
            </CardHeader>
            <CardContent>
              <ScrollArea className="h-[500px]">
                <div className="space-y-3">
                  {organisms.map(organism => (
                    <OrganismRow key={organism.id} organism={organism} />
                  ))}
                </div>
              </ScrollArea>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Projects Tab */}
        <TabsContent value="projects" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <MetricCard
              title="Active Projects"
              value={projects.filter(p => p.status === "Active").length}
              icon={FolderKanban}
              color="blue"
            />
            <MetricCard
              title="Total Budget"
              value={`$${(projects.reduce((sum, p) => sum + p.budget, 0) / 1000).toFixed(0)}K`}
              icon={DollarSign}
              color="green"
            />
            <MetricCard
              title="Team Members"
              value={projects.reduce((sum, p) => sum + p.teamSize, 0)}
              icon={Users}
              color="purple"
            />
            <MetricCard
              title="At Risk"
              value={projects.filter(p => p.health !== "Good").length}
              icon={AlertTriangle}
              color="yellow"
            />
          </div>
          
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <FolderKanban className="w-5 h-5 text-blue-400" />
                Project Portfolio
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {projects.map(project => (
                  <ProjectRow key={project.id} project={project} />
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Treasury Tab */}
        <TabsContent value="treasury" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <MetricCard
              title="Total FORMA"
              value={treasury.totalForma.toLocaleString()}
              icon={Coins}
              color="amber"
            />
            <MetricCard
              title="Total SEED"
              value={treasury.totalSeed.toLocaleString()}
              icon={Sparkles}
              color="purple"
            />
            <MetricCard
              title="Staked"
              value={treasury.totalStaked.toLocaleString()}
              icon={Lock}
              color="cyan"
            />
            <MetricCard
              title="GTK (Governance)"
              value={treasury.totalGtk.toLocaleString()}
              icon={Vote}
              color="blue"
            />
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Revenue Distribution */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <PieChart className="w-5 h-5 text-green-400" />
                  Revenue Distribution
                </CardTitle>
                <CardDescription>10% Architect / 90% Players (Doctrine Law)</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-center justify-between p-3 bg-amber-500/10 rounded-lg border border-amber-500/30">
                  <div>
                    <p className="text-sm text-zinc-400">Architect Share (10%)</p>
                    <p className="text-xl font-bold text-amber-400">
                      ${treasury.architectShare.toLocaleString()}
                    </p>
                  </div>
                  <Crown className="w-8 h-8 text-amber-400" />
                </div>
                <div className="flex items-center justify-between p-3 bg-green-500/10 rounded-lg border border-green-500/30">
                  <div>
                    <p className="text-sm text-zinc-400">Player Share (90%)</p>
                    <p className="text-xl font-bold text-green-400">
                      ${treasury.playerShare.toLocaleString()}
                    </p>
                  </div>
                  <Users className="w-8 h-8 text-green-400" />
                </div>
                <div className="flex items-center justify-between p-3 bg-blue-500/10 rounded-lg border border-blue-500/30">
                  <div>
                    <p className="text-sm text-zinc-400">Pending Distribution</p>
                    <p className="text-xl font-bold text-blue-400">
                      ${treasury.pendingRevenue.toLocaleString()}
                    </p>
                  </div>
                  <Timer className="w-8 h-8 text-blue-400" />
                </div>
              </CardContent>
            </Card>

            {/* Jubilee Cycle */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Calendar className="w-5 h-5 text-purple-400" />
                  Jubilee Economic Cycle
                </CardTitle>
                <CardDescription>7-year reset cycle per Doctrine Law</CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="text-center p-6 bg-purple-500/10 rounded-lg border border-purple-500/30">
                  <p className="text-sm text-zinc-400 mb-2">Current Cycle</p>
                  <p className="text-5xl font-bold text-purple-400">{treasury.jubileeCycle}</p>
                  <p className="text-sm text-zinc-400 mt-2">of 7 years</p>
                </div>
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-zinc-400">Progress to Jubilee</span>
                    <span className="text-purple-400">
                      {((1 - treasury.beatsUntilJubilee / 735840) * 100).toFixed(1)}%
                    </span>
                  </div>
                  <Progress value={(1 - treasury.beatsUntilJubilee / 735840) * 100} className="h-2" />
                </div>
                <p className="text-xs text-zinc-500 text-center">
                  {treasury.beatsUntilJubilee.toLocaleString()} beats until next Jubilee reset
                </p>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* Governance Tab */}
        <TabsContent value="governance" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <MetricCard
              title="Active Proposals"
              value={governance.activeProposals}
              icon={FileText}
              color="blue"
            />
            <MetricCard
              title="Pending Votes"
              value={governance.pendingVotes}
              icon={Vote}
              color="purple"
            />
            <MetricCard
              title="Council Members"
              value={governance.councilMembers}
              icon={Users}
              color="cyan"
            />
            <MetricCard
              title="Open Violations"
              value={governance.openViolations}
              icon={AlertTriangle}
              color="yellow"
            />
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Scale className="w-5 h-5 text-blue-400" />
                  Council Status
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex items-center justify-between p-3 bg-zinc-900 rounded-lg">
                  <span className="text-zinc-400">Quorum Status</span>
                  <Badge className={governance.quorumMet 
                    ? "bg-green-500/20 text-green-400 border-green-500/30" 
                    : "bg-red-500/20 text-red-400 border-red-500/30"}>
                    {governance.quorumMet ? "Quorum Met" : "No Quorum"}
                  </Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-zinc-900 rounded-lg">
                  <span className="text-zinc-400">Last Proposal</span>
                  <span className="text-blue-400 font-mono">{governance.lastProposalId}</span>
                </div>
                <div className="flex items-center justify-between p-3 bg-zinc-900 rounded-lg">
                  <span className="text-zinc-400">Compliance Score</span>
                  <span className="text-green-400">{governance.complianceScore}%</span>
                </div>
              </CardContent>
            </Card>

            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <ShieldCheck className="w-5 h-5 text-green-400" />
                  Compliance Summary
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-zinc-400">Overall Compliance</span>
                    <span className="text-green-400">{governance.complianceScore}%</span>
                  </div>
                  <Progress value={governance.complianceScore} className="h-2" />
                </div>
                <div className="flex items-center justify-between p-3 bg-zinc-900 rounded-lg">
                  <span className="text-zinc-400">Critical Violations</span>
                  <Badge className={governance.criticalViolations === 0
                    ? "bg-green-500/20 text-green-400 border-green-500/30"
                    : "bg-red-500/20 text-red-400 border-red-500/30"}>
                    {governance.criticalViolations}
                  </Badge>
                </div>
                <div className="flex items-center justify-between p-3 bg-zinc-900 rounded-lg">
                  <span className="text-zinc-400">Open Violations</span>
                  <Badge className="bg-yellow-500/20 text-yellow-400 border-yellow-500/30">
                    {governance.openViolations}
                  </Badge>
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* Security Tab */}
        <TabsContent value="security" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <MetricCard
              title="Shield Strength"
              value={`${(aegis.shieldStrength * 100).toFixed(0)}%`}
              icon={Shield}
              color="cyan"
            />
            <MetricCard
              title="Snapshots"
              value={aegis.snapshotCount}
              icon={Layers}
              color="blue"
            />
            <MetricCard
              title="Rollbacks"
              value={aegis.rollbackCount}
              icon={Clock}
              color="purple"
            />
            <MetricCard
              title="Emergency Mode"
              value={aegis.emergencyMode ? "ACTIVE" : "Off"}
              icon={AlertTriangle}
              color={aegis.emergencyMode ? "red" : "green"}
            />
          </div>

          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Shield className="w-5 h-5 text-cyan-400" />
                AEGIS Defense Status
              </CardTitle>
              <CardDescription>K=7 snapshot ring buffer with auto-rollback capability</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="p-4 bg-zinc-900 rounded-lg">
                  <div className="flex items-center justify-between mb-4">
                    <span className="text-zinc-400">Doctrine Integrity</span>
                    <Badge className={aegis.doctrineIntact
                      ? "bg-green-500/20 text-green-400 border-green-500/30"
                      : "bg-red-500/20 text-red-400 border-red-500/30"}>
                      {aegis.doctrineIntact ? "INTACT" : "COMPROMISED"}
                    </Badge>
                  </div>
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-zinc-400">Shield Strength</span>
                      <span className="text-cyan-400">{(aegis.shieldStrength * 100).toFixed(0)}%</span>
                    </div>
                    <Progress value={aegis.shieldStrength * 100} className="h-2" />
                  </div>
                </div>

                <div className="p-4 bg-zinc-900 rounded-lg">
                  <p className="text-zinc-400 mb-2">Snapshot Ring (K=7)</p>
                  <div className="flex gap-2">
                    {[0, 1, 2, 3, 4, 5, 6].map(slot => (
                      <div
                        key={slot}
                        className={`w-8 h-8 rounded flex items-center justify-center text-xs font-mono
                          ${slot < aegis.snapshotCount 
                            ? 'bg-cyan-500/20 text-cyan-400 border border-cyan-500/30' 
                            : 'bg-zinc-800 text-zinc-600 border border-zinc-700'}`}
                      >
                        {slot}
                      </div>
                    ))}
                  </div>
                  <p className="text-xs text-zinc-500 mt-2">
                    Last rollback: Beat #{aegis.lastRollbackBeat.toLocaleString()}
                  </p>
                </div>
              </div>

              <div className="flex gap-4">
                <Button variant="outline" className="flex-1">
                  <Layers className="w-4 h-4 mr-2" />
                  Take Snapshot
                </Button>
                <Button variant="outline" className="flex-1">
                  <Clock className="w-4 h-4 mr-2" />
                  View History
                </Button>
                <Button variant="destructive" className="flex-1" disabled={aegis.emergencyMode}>
                  <AlertTriangle className="w-4 h-4 mr-2" />
                  Emergency Stop
                </Button>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

export default CEODashboard;
