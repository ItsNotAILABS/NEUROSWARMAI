// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  TEAM DASHBOARD — ENTERPRISE TEAM MANAGEMENT FOR 50-PERSON OFFICE                                        ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THIS IS THE ENTERPRISE TEAM DASHBOARD — Real workplace management.                                       ║
// ║  Built for a 50-person office. Tracks everything: people, teams, projects, decisions.                    ║
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
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import {
  Activity,
  AlertTriangle,
  ArrowDown,
  ArrowUp,
  Award,
  BarChart3,
  Briefcase,
  Building2,
  Calendar,
  Check,
  CheckCircle2,
  ChevronRight,
  Clock,
  Crown,
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
  Mail,
  MessageSquare,
  Milestone,
  Network,
  PieChart,
  Settings,
  Shield,
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
  Wallet,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 1: TYPE DEFINITIONS FOR UI
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface TeamDashboardProps {
  className?: string;
}

interface DashboardMetric {
  label: string;
  value: string | number;
  change?: number;
  changeLabel?: string;
  icon: React.ReactNode;
  color: string;
  trend?: "up" | "down" | "stable";
}

interface PersonSummary {
  id: string;
  name: string;
  role: string;
  department: string;
  level: number;
  performance: number;
  trust: number;
  capacity: number;
  burnoutRisk: number;
  streak: number;
  avatar?: string;
}

interface TeamSummary {
  id: string;
  name: string;
  lead: string;
  memberCount: number;
  velocity: number;
  morale: number;
  synergy: number;
  projects: number;
}

interface ProjectSummary {
  id: string;
  name: string;
  owner: string;
  status: string;
  progress: number;
  budget: { spent: number; total: number };
  successProbability: number;
  daysRemaining: number;
}

interface DecisionSummary {
  id: string;
  title: string;
  type: string;
  status: string;
  dueDate: number;
  votes: number;
  requiredVotes: number;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 2: MOCK DATA GENERATION — REALISTIC 50-PERSON ENTERPRISE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const DEPARTMENTS = [
  "Engineering",
  "Product",
  "Design",
  "Marketing",
  "Sales",
  "Operations",
  "Finance",
  "Legal",
  "HR",
];
const FIRST_NAMES = [
  "Alex",
  "Jordan",
  "Taylor",
  "Morgan",
  "Casey",
  "Riley",
  "Quinn",
  "Avery",
  "Cameron",
  "Jamie",
  "Reese",
  "Dakota",
  "Skyler",
  "Phoenix",
  "Sage",
  "Blake",
  "Drew",
  "Hayden",
  "Peyton",
  "Robin",
];
const LAST_NAMES = [
  "Chen",
  "Smith",
  "Johnson",
  "Williams",
  "Brown",
  "Jones",
  "Garcia",
  "Miller",
  "Davis",
  "Rodriguez",
  "Martinez",
  "Hernandez",
  "Lopez",
  "Wilson",
  "Anderson",
  "Thomas",
  "Taylor",
  "Moore",
  "Jackson",
  "Martin",
];
const ROLES: Record<number, string[]> = {
  0: ["Software Engineer", "Designer", "Analyst", "Specialist", "Coordinator"],
  1: ["Senior Engineer", "Senior Designer", "Team Lead", "Project Manager"],
  2: [
    "Staff Engineer",
    "Principal Designer",
    "Engineering Manager",
    "Product Manager",
  ],
  3: ["Director of Engineering", "Director of Product", "Director of Design"],
  4: ["VP Engineering", "VP Product", "VP Marketing", "VP Sales"],
  5: ["CTO", "CEO", "CFO", "COO", "CPO"],
  6: ["Board Member", "Advisor"],
};

function generateMockPerson(
  id: number,
  level: number,
  department: string,
  _managerId: string | null,
): PersonSummary {
  const firstName = FIRST_NAMES[id % FIRST_NAMES.length];
  const lastName = LAST_NAMES[(id * 7) % LAST_NAMES.length];
  const roles = ROLES[level] ?? ROLES[0];
  const role = roles![id % roles!.length]!;

  return {
    id: `person-${id}`,
    name: `${firstName} ${lastName}`,
    role,
    department,
    level,
    performance: 60 + Math.random() * 35,
    trust: 0.5 + Math.random() * 0.45,
    capacity: 0.5 + Math.random() * 0.45,
    burnoutRisk: Math.random() * 0.4,
    streak: Math.floor(Math.random() * 30),
  };
}

function generateMockTeam(
  id: number,
  department: string,
  leadId: string,
): TeamSummary {
  return {
    id: `team-${id}`,
    name: `${department} Team ${id + 1}`,
    lead: leadId,
    memberCount: 4 + Math.floor(Math.random() * 6),
    velocity: 70 + Math.random() * 25,
    morale: 65 + Math.random() * 30,
    synergy: 1.2 + Math.random() * 0.8,
    projects: 1 + Math.floor(Math.random() * 3),
  };
}

function generateMockProject(id: number, owner: string): ProjectSummary {
  const statuses = ["planning", "active", "on_hold"];
  const names = [
    "Platform Migration",
    "Mobile App v2",
    "API Redesign",
    "Dashboard Overhaul",
    "Payment Integration",
    "Analytics Engine",
    "Security Audit",
    "Performance Optimization",
  ];

  const total = 50000 + Math.random() * 200000;
  const spent = Math.random() * total * 0.8;

  return {
    id: `project-${id}`,
    name: names[id % names.length]!,
    owner,
    status: statuses[id % statuses.length]!,
    progress: Math.random() * 100,
    budget: { spent, total },
    successProbability: 0.6 + Math.random() * 0.35,
    daysRemaining: Math.floor(Math.random() * 90),
  };
}

function generateMockDecision(id: number): DecisionSummary {
  const types = ["strategic", "tactical", "resource", "personnel", "technical"];
  const statuses = ["draft", "voting", "under_review", "approved"];
  const titles = [
    "Q2 Resource Allocation",
    "New Hire Approval - Engineering",
    "Technology Stack Migration",
    "Partnership Agreement Review",
    "Budget Reallocation Request",
    "Remote Work Policy Update",
    "Security Protocol Enhancement",
    "Vendor Contract Renewal",
  ];

  return {
    id: `decision-${id}`,
    title: titles[id % titles.length]!,
    type: types[id % types.length]!,
    status: statuses[id % statuses.length]!,
    dueDate: Date.now() + Math.random() * 14 * 24 * 60 * 60 * 1000,
    votes: Math.floor(Math.random() * 8),
    requiredVotes: 5,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 3: HELPER COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

function MetricCard({ metric }: { metric: DashboardMetric }) {
  const TrendIcon =
    metric.trend === "up"
      ? TrendingUp
      : metric.trend === "down"
        ? TrendingDown
        : Activity;
  const trendColor =
    metric.trend === "up"
      ? "text-emerald-400"
      : metric.trend === "down"
        ? "text-red-400"
        : "text-zinc-400";

  return (
    <Card className="bg-zinc-900/50 border-zinc-800 hover:border-zinc-700 transition-colors">
      <CardContent className="p-4">
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-3">
            <div
              className={`w-10 h-10 rounded-lg flex items-center justify-center ${metric.color}`}
            >
              {metric.icon}
            </div>
            <div>
              <p className="text-xs text-zinc-500 uppercase tracking-wider font-medium">
                {metric.label}
              </p>
              <p className="text-2xl font-bold text-zinc-100">{metric.value}</p>
            </div>
          </div>
          {metric.change !== undefined && (
            <div className={`flex items-center gap-1 ${trendColor}`}>
              <TrendIcon className="w-4 h-4" />
              <span className="text-sm font-medium">
                {metric.change > 0 ? "+" : ""}
                {metric.change.toFixed(1)}%
              </span>
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

function PersonRow({ person, rank }: { person: PersonSummary; rank: number }) {
  const burnoutLevel =
    person.burnoutRisk > 0.6
      ? "high"
      : person.burnoutRisk > 0.3
        ? "medium"
        : "low";
  const burnoutColor =
    burnoutLevel === "high"
      ? "text-red-400"
      : burnoutLevel === "medium"
        ? "text-yellow-400"
        : "text-emerald-400";

  return (
    <div className="flex items-center gap-4 p-3 rounded-lg bg-zinc-900/30 hover:bg-zinc-900/50 transition-colors">
      <div className="w-8 text-center">
        <span className="text-xs font-mono text-zinc-500">#{rank}</span>
      </div>
      <div className="w-10 h-10 rounded-full bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center text-white font-bold text-sm">
        {person.name
          .split(" ")
          .map((n) => n[0])
          .join("")}
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="font-medium text-zinc-100 truncate">
            {person.name}
          </span>
          {person.streak > 7 && (
            <Badge
              variant="outline"
              className="text-orange-400 border-orange-400/30 text-[10px] px-1.5"
            >
              <Flame className="w-3 h-3 mr-1" />
              {person.streak}d
            </Badge>
          )}
        </div>
        <div className="flex items-center gap-2 text-xs text-zinc-500">
          <span>{person.role}</span>
          <span>•</span>
          <span>{person.department}</span>
        </div>
      </div>
      <div className="flex items-center gap-4">
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger>
              <div className="text-center">
                <div className="text-sm font-semibold text-zinc-100">
                  {person.performance.toFixed(0)}
                </div>
                <div className="text-[10px] text-zinc-500">Perf</div>
              </div>
            </TooltipTrigger>
            <TooltipContent>Performance Score</TooltipContent>
          </Tooltip>
        </TooltipProvider>
        <TooltipProvider>
          <Tooltip>
            <TooltipTrigger>
              <div className="text-center">
                <div className={`text-sm font-semibold ${burnoutColor}`}>
                  {(person.burnoutRisk * 100).toFixed(0)}%
                </div>
                <div className="text-[10px] text-zinc-500">Burnout</div>
              </div>
            </TooltipTrigger>
            <TooltipContent>Burnout Risk</TooltipContent>
          </Tooltip>
        </TooltipProvider>
        <div className="w-24">
          <Progress value={person.capacity * 100} className="h-2" />
          <div className="text-[10px] text-zinc-500 mt-1 text-center">
            Capacity
          </div>
        </div>
      </div>
    </div>
  );
}

function TeamRow({ team }: { team: TeamSummary }) {
  const synergyColor =
    team.synergy > 1.5
      ? "text-emerald-400"
      : team.synergy > 1.2
        ? "text-cyan-400"
        : "text-zinc-400";

  return (
    <div className="flex items-center gap-4 p-3 rounded-lg bg-zinc-900/30 hover:bg-zinc-900/50 transition-colors">
      <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center">
        <Users className="w-5 h-5 text-white" />
      </div>
      <div className="flex-1 min-w-0">
        <div className="font-medium text-zinc-100 truncate">{team.name}</div>
        <div className="text-xs text-zinc-500">
          {team.memberCount} members • {team.projects} projects
        </div>
      </div>
      <div className="flex items-center gap-6">
        <div className="text-center">
          <div className="text-sm font-semibold text-zinc-100">
            {team.velocity.toFixed(0)}
          </div>
          <div className="text-[10px] text-zinc-500">Velocity</div>
        </div>
        <div className="text-center">
          <div className="text-sm font-semibold text-cyan-400">
            {team.morale.toFixed(0)}%
          </div>
          <div className="text-[10px] text-zinc-500">Morale</div>
        </div>
        <div className="text-center">
          <div className={`text-sm font-semibold ${synergyColor}`}>
            {team.synergy.toFixed(2)}x
          </div>
          <div className="text-[10px] text-zinc-500">Synergy</div>
        </div>
      </div>
    </div>
  );
}

function ProjectRow({ project }: { project: ProjectSummary }) {
  const statusColor =
    project.status === "active"
      ? "bg-emerald-500"
      : project.status === "planning"
        ? "bg-blue-500"
        : "bg-yellow-500";
  const probabilityColor =
    project.successProbability > 0.8
      ? "text-emerald-400"
      : project.successProbability > 0.6
        ? "text-cyan-400"
        : "text-yellow-400";

  return (
    <div className="flex items-center gap-4 p-3 rounded-lg bg-zinc-900/30 hover:bg-zinc-900/50 transition-colors">
      <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-orange-500 to-red-600 flex items-center justify-center">
        <FolderKanban className="w-5 h-5 text-white" />
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="font-medium text-zinc-100 truncate">
            {project.name}
          </span>
          <span className={`w-2 h-2 rounded-full ${statusColor}`} />
        </div>
        <div className="text-xs text-zinc-500">
          {project.daysRemaining} days remaining
        </div>
      </div>
      <div className="flex items-center gap-6">
        <div className="w-32">
          <div className="flex justify-between text-[10px] text-zinc-500 mb-1">
            <span>Progress</span>
            <span>{project.progress.toFixed(0)}%</span>
          </div>
          <Progress value={project.progress} className="h-2" />
        </div>
        <div className="text-center">
          <div className="text-sm font-semibold text-zinc-100">
            ${(project.budget.spent / 1000).toFixed(0)}k / $
            {(project.budget.total / 1000).toFixed(0)}k
          </div>
          <div className="text-[10px] text-zinc-500">Budget</div>
        </div>
        <div className="text-center">
          <div className={`text-sm font-semibold ${probabilityColor}`}>
            {(project.successProbability * 100).toFixed(0)}%
          </div>
          <div className="text-[10px] text-zinc-500">Success</div>
        </div>
      </div>
    </div>
  );
}

function DecisionRow({ decision }: { decision: DecisionSummary }) {
  const daysUntilDue = Math.ceil(
    (decision.dueDate - Date.now()) / (1000 * 60 * 60 * 24),
  );
  const isUrgent = daysUntilDue <= 3;
  const statusColor =
    decision.status === "approved"
      ? "text-emerald-400 bg-emerald-400/10"
      : decision.status === "voting"
        ? "text-cyan-400 bg-cyan-400/10"
        : decision.status === "under_review"
          ? "text-yellow-400 bg-yellow-400/10"
          : "text-zinc-400 bg-zinc-400/10";

  return (
    <div className="flex items-center gap-4 p-3 rounded-lg bg-zinc-900/30 hover:bg-zinc-900/50 transition-colors">
      <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-teal-500 to-emerald-600 flex items-center justify-center">
        <GitBranch className="w-5 h-5 text-white" />
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center gap-2">
          <span className="font-medium text-zinc-100 truncate">
            {decision.title}
          </span>
          {isUrgent && (
            <Badge
              variant="outline"
              className="text-red-400 border-red-400/30 text-[10px] px-1.5"
            >
              <Clock className="w-3 h-3 mr-1" />
              Urgent
            </Badge>
          )}
        </div>
        <div className="text-xs text-zinc-500 capitalize">
          {decision.type} • Due in {daysUntilDue} days
        </div>
      </div>
      <div className="flex items-center gap-4">
        <Badge className={`${statusColor} capitalize text-xs`}>
          {decision.status.replace("_", " ")}
        </Badge>
        <div className="text-center">
          <div className="text-sm font-semibold text-zinc-100">
            {decision.votes}/{decision.requiredVotes}
          </div>
          <div className="text-[10px] text-zinc-500">Votes</div>
        </div>
      </div>
    </div>
  );
}

function HealthGauge({
  value,
  label,
  color,
}: { value: number; label: string; color: string }) {
  const circumference = 2 * Math.PI * 36;
  const offset = circumference - (value / 100) * circumference;

  return (
    <div className="flex flex-col items-center">
      <div className="relative w-24 h-24">
        <svg
          className="w-24 h-24 transform -rotate-90"
          aria-label="Health gauge"
          role="img"
        >
          <circle
            cx="48"
            cy="48"
            r="36"
            fill="none"
            stroke="currentColor"
            strokeWidth="8"
            className="text-zinc-800"
          />
          <circle
            cx="48"
            cy="48"
            r="36"
            fill="none"
            stroke="currentColor"
            strokeWidth="8"
            strokeDasharray={circumference}
            strokeDashoffset={offset}
            strokeLinecap="round"
            className={color}
          />
        </svg>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className="text-2xl font-bold text-zinc-100">
            {value.toFixed(0)}
          </span>
        </div>
      </div>
      <span className="mt-2 text-xs text-zinc-500 uppercase tracking-wider">
        {label}
      </span>
    </div>
  );
}

function ActivityFeed() {
  const activities = [
    {
      icon: CheckCircle2,
      text: "Platform Migration milestone completed",
      time: "5m ago",
      color: "text-emerald-400",
    },
    {
      icon: UserPlus,
      text: "New team member joined Engineering",
      time: "1h ago",
      color: "text-cyan-400",
    },
    {
      icon: GitBranch,
      text: "Q2 Budget decision approved",
      time: "2h ago",
      color: "text-purple-400",
    },
    {
      icon: Star,
      text: "Design Team hit velocity record",
      time: "3h ago",
      color: "text-yellow-400",
    },
    {
      icon: AlertTriangle,
      text: "Burnout risk detected in Sales",
      time: "5h ago",
      color: "text-red-400",
    },
    {
      icon: Trophy,
      text: "Engineering streak: 14 days",
      time: "6h ago",
      color: "text-orange-400",
    },
  ];

  return (
    <Card className="bg-zinc-900/50 border-zinc-800">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Activity className="w-4 h-4 text-cyan-400" />
          Activity Feed
        </CardTitle>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-64">
          <div className="space-y-3">
            {activities.map((activity, i) => (
              <div
                key={`${activity.text}-${i}`}
                className="flex items-start gap-3"
              >
                <activity.icon className={`w-4 h-4 mt-0.5 ${activity.color}`} />
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-zinc-300">{activity.text}</p>
                  <p className="text-[10px] text-zinc-500">{activity.time}</p>
                </div>
              </div>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

function DepartmentBreakdown({ people }: { people: PersonSummary[] }) {
  const departments = useMemo(() => {
    const deptMap = new Map<
      string,
      { count: number; avgPerformance: number; avgBurnout: number }
    >();

    for (const person of people) {
      const existing = deptMap.get(person.department) ?? {
        count: 0,
        avgPerformance: 0,
        avgBurnout: 0,
      };
      existing.count++;
      existing.avgPerformance =
        (existing.avgPerformance * (existing.count - 1) + person.performance) /
        existing.count;
      existing.avgBurnout =
        (existing.avgBurnout * (existing.count - 1) + person.burnoutRisk) /
        existing.count;
      deptMap.set(person.department, existing);
    }

    return Array.from(deptMap.entries()).map(([name, data]) => ({
      name,
      ...data,
    }));
  }, [people]);

  return (
    <Card className="bg-zinc-900/50 border-zinc-800">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Building2 className="w-4 h-4 text-purple-400" />
          Department Breakdown
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-3">
          {departments.slice(0, 6).map((dept) => (
            <div key={dept.name} className="flex items-center gap-3">
              <div className="w-24 truncate text-sm text-zinc-300">
                {dept.name}
              </div>
              <div className="flex-1">
                <div className="flex items-center justify-between text-[10px] text-zinc-500 mb-1">
                  <span>{dept.count} people</span>
                  <span>Perf: {dept.avgPerformance.toFixed(0)}</span>
                </div>
                <Progress value={dept.avgPerformance} className="h-1.5" />
              </div>
              <div
                className={`text-xs font-medium ${dept.avgBurnout > 0.3 ? "text-red-400" : "text-emerald-400"}`}
              >
                {(dept.avgBurnout * 100).toFixed(0)}%
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 4: MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export function TeamDashboard({ className = "" }: TeamDashboardProps) {
  const [activeTab, setActiveTab] = useState("overview");
  const [tick, setTick] = useState(0);

  // Generate mock data for 50-person enterprise
  const people = useMemo(() => {
    const result: PersonSummary[] = [];
    let id = 0;

    // C-Suite (3)
    for (let i = 0; i < 3; i++) {
      result.push(generateMockPerson(id++, 5, "Executive", null));
    }

    // VPs (5)
    for (let i = 0; i < 5; i++) {
      result.push(
        generateMockPerson(
          id++,
          4,
          DEPARTMENTS[i % DEPARTMENTS.length]!,
          "person-0",
        ),
      );
    }

    // Directors (7)
    for (let i = 0; i < 7; i++) {
      result.push(
        generateMockPerson(
          id++,
          3,
          DEPARTMENTS[i % DEPARTMENTS.length]!,
          `person-${3 + (i % 5)}`,
        ),
      );
    }

    // Managers (10)
    for (let i = 0; i < 10; i++) {
      result.push(
        generateMockPerson(
          id++,
          2,
          DEPARTMENTS[i % DEPARTMENTS.length]!,
          `person-${8 + (i % 7)}`,
        ),
      );
    }

    // Team Leads (10)
    for (let i = 0; i < 10; i++) {
      result.push(
        generateMockPerson(
          id++,
          1,
          DEPARTMENTS[i % DEPARTMENTS.length]!,
          `person-${15 + (i % 10)}`,
        ),
      );
    }

    // ICs (15)
    for (let i = 0; i < 15; i++) {
      result.push(
        generateMockPerson(
          id++,
          0,
          DEPARTMENTS[i % DEPARTMENTS.length]!,
          `person-${25 + (i % 10)}`,
        ),
      );
    }

    return result;
  }, []);

  const teams = useMemo(() => {
    return Array.from({ length: 10 }, (_, i) =>
      generateMockTeam(
        i,
        DEPARTMENTS[i % DEPARTMENTS.length]!,
        `person-${25 + i}`,
      ),
    );
  }, []);

  const projects = useMemo(() => {
    return Array.from({ length: 8 }, (_, i) =>
      generateMockProject(i, people[15 + (i % 10)]?.name ?? "Unknown"),
    );
  }, [people]);

  const decisions = useMemo(() => {
    return Array.from({ length: 6 }, (_, i) => generateMockDecision(i));
  }, []);

  // Calculate organization-wide metrics
  const metrics: DashboardMetric[] = useMemo(() => {
    const avgPerformance =
      people.reduce((sum, p) => sum + p.performance, 0) / people.length;
    const avgTrust =
      people.reduce((sum, p) => sum + p.trust, 0) / people.length;
    const _avgCapacity =
      people.reduce((sum, p) => sum + p.capacity, 0) / people.length;
    const totalBurnoutRisk = people.filter((p) => p.burnoutRisk > 0.5).length;
    const avgVelocity =
      teams.reduce((sum, t) => sum + t.velocity, 0) / teams.length;
    const activeProjects = projects.filter((p) => p.status === "active").length;
    const pendingDecisions = decisions.filter(
      (d) => d.status === "voting" || d.status === "under_review",
    ).length;
    const avgStreak =
      people.reduce((sum, p) => sum + p.streak, 0) / people.length;

    return [
      {
        label: "Total Headcount",
        value: people.length,
        icon: <Users className="w-5 h-5 text-white" />,
        color: "bg-cyan-500/20",
        trend: "stable",
      },
      {
        label: "Avg Performance",
        value: `${avgPerformance.toFixed(1)}%`,
        change: 3.2,
        icon: <TrendingUp className="w-5 h-5 text-white" />,
        color: "bg-emerald-500/20",
        trend: "up",
      },
      {
        label: "Team Velocity",
        value: avgVelocity.toFixed(0),
        change: -1.5,
        icon: <Zap className="w-5 h-5 text-white" />,
        color: "bg-yellow-500/20",
        trend: "down",
      },
      {
        label: "Burnout Alerts",
        value: totalBurnoutRisk,
        icon: <AlertTriangle className="w-5 h-5 text-white" />,
        color: "bg-red-500/20",
        trend: totalBurnoutRisk > 5 ? "down" : "up",
      },
      {
        label: "Active Projects",
        value: activeProjects,
        icon: <FolderKanban className="w-5 h-5 text-white" />,
        color: "bg-purple-500/20",
        trend: "stable",
      },
      {
        label: "Pending Decisions",
        value: pendingDecisions,
        icon: <GitBranch className="w-5 h-5 text-white" />,
        color: "bg-orange-500/20",
        trend: "stable",
      },
      {
        label: "Trust Index",
        value: `${(avgTrust * 100).toFixed(0)}%`,
        change: 1.8,
        icon: <Heart className="w-5 h-5 text-white" />,
        color: "bg-pink-500/20",
        trend: "up",
      },
      {
        label: "Avg Streak",
        value: `${avgStreak.toFixed(1)}d`,
        change: 2.1,
        icon: <Flame className="w-5 h-5 text-white" />,
        color: "bg-orange-500/20",
        trend: "up",
      },
    ];
  }, [people, teams, projects, decisions]);

  // Calculate health scores
  const healthScores = useMemo(() => {
    const avgPerformance =
      people.reduce((sum, p) => sum + p.performance, 0) / people.length;
    const avgMorale =
      teams.reduce((sum, t) => sum + t.morale, 0) / teams.length;
    const avgCapacity =
      (people.reduce((sum, p) => sum + p.capacity, 0) / people.length) * 100;
    const projectHealth =
      (projects.reduce((sum, p) => sum + p.successProbability, 0) /
        projects.length) *
      100;

    return {
      performance: avgPerformance,
      morale: avgMorale,
      capacity: avgCapacity,
      projects: projectHealth,
    };
  }, [people, teams, projects]);

  // Simulate tick
  useEffect(() => {
    const interval = setInterval(() => {
      setTick((t) => t + 1);
    }, 5000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div
      className={`flex flex-col h-full bg-zinc-950 text-zinc-100 ${className}`}
    >
      {/* Header */}
      <div className="shrink-0 border-b border-zinc-800 bg-zinc-900/50 backdrop-blur-sm">
        <div className="flex items-center justify-between px-6 py-4">
          <div className="flex items-center gap-4">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-500 to-blue-600 flex items-center justify-center">
              <Building2 className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold">Enterprise Dashboard</h1>
              <p className="text-sm text-zinc-500">
                50-person organization • {teams.length} teams •{" "}
                {projects.length} projects
              </p>
            </div>
          </div>
          <div className="flex items-center gap-4">
            <Badge
              variant="outline"
              className="text-cyan-400 border-cyan-400/30"
            >
              <Activity className="w-3 h-3 mr-1" />
              Live
            </Badge>
            <span className="text-xs text-zinc-500 font-mono">
              Tick #{tick}
            </span>
            <Button
              variant="outline"
              size="sm"
              className="text-zinc-400 border-zinc-700"
            >
              <Settings className="w-4 h-4 mr-2" />
              Settings
            </Button>
          </div>
        </div>

        <Tabs value={activeTab} onValueChange={setActiveTab} className="px-6">
          <TabsList className="bg-zinc-900/50 border border-zinc-800">
            <TabsTrigger
              value="overview"
              className="data-[state=active]:bg-zinc-800"
            >
              <LayoutGrid className="w-4 h-4 mr-2" />
              Overview
            </TabsTrigger>
            <TabsTrigger
              value="people"
              className="data-[state=active]:bg-zinc-800"
            >
              <Users className="w-4 h-4 mr-2" />
              People
            </TabsTrigger>
            <TabsTrigger
              value="teams"
              className="data-[state=active]:bg-zinc-800"
            >
              <Network className="w-4 h-4 mr-2" />
              Teams
            </TabsTrigger>
            <TabsTrigger
              value="projects"
              className="data-[state=active]:bg-zinc-800"
            >
              <FolderKanban className="w-4 h-4 mr-2" />
              Projects
            </TabsTrigger>
            <TabsTrigger
              value="decisions"
              className="data-[state=active]:bg-zinc-800"
            >
              <GitBranch className="w-4 h-4 mr-2" />
              Decisions
            </TabsTrigger>
          </TabsList>
        </Tabs>
      </div>

      {/* Content */}
      <ScrollArea className="flex-1">
        <div className="p-6">
          <Tabs value={activeTab}>
            {/* Overview Tab */}
            <TabsContent value="overview" className="m-0 space-y-6">
              {/* Metrics Grid */}
              <div className="grid grid-cols-4 gap-4">
                {metrics.slice(0, 8).map((metric) => (
                  <MetricCard key={metric.label} metric={metric} />
                ))}
              </div>

              {/* Health Gauges */}
              <Card className="bg-zinc-900/50 border-zinc-800">
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-semibold flex items-center gap-2">
                    <Heart className="w-4 h-4 text-pink-400" />
                    Organization Health
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="flex justify-around py-4">
                    <HealthGauge
                      value={healthScores.performance}
                      label="Performance"
                      color="text-emerald-400"
                    />
                    <HealthGauge
                      value={healthScores.morale}
                      label="Morale"
                      color="text-cyan-400"
                    />
                    <HealthGauge
                      value={healthScores.capacity}
                      label="Capacity"
                      color="text-purple-400"
                    />
                    <HealthGauge
                      value={healthScores.projects}
                      label="Projects"
                      color="text-orange-400"
                    />
                  </div>
                </CardContent>
              </Card>

              {/* Two Column Layout */}
              <div className="grid grid-cols-2 gap-6">
                <ActivityFeed />
                <DepartmentBreakdown people={people} />
              </div>

              {/* Top Performers */}
              <Card className="bg-zinc-900/50 border-zinc-800">
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm font-semibold flex items-center gap-2">
                    <Trophy className="w-4 h-4 text-yellow-400" />
                    Top Performers
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    {people
                      .sort((a, b) => b.performance - a.performance)
                      .slice(0, 5)
                      .map((person, i) => (
                        <PersonRow
                          key={person.id}
                          person={person}
                          rank={i + 1}
                        />
                      ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* People Tab */}
            <TabsContent value="people" className="m-0 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold">
                  All People ({people.length})
                </h2>
                <Button size="sm" className="bg-cyan-500 hover:bg-cyan-600">
                  <UserPlus className="w-4 h-4 mr-2" />
                  Add Person
                </Button>
              </div>
              <Card className="bg-zinc-900/50 border-zinc-800">
                <CardContent className="p-4">
                  <ScrollArea className="h-[600px]">
                    <div className="space-y-2">
                      {people
                        .sort(
                          (a, b) =>
                            b.level - a.level || b.performance - a.performance,
                        )
                        .map((person, i) => (
                          <PersonRow
                            key={person.id}
                            person={person}
                            rank={i + 1}
                          />
                        ))}
                    </div>
                  </ScrollArea>
                </CardContent>
              </Card>
            </TabsContent>

            {/* Teams Tab */}
            <TabsContent value="teams" className="m-0 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold">
                  All Teams ({teams.length})
                </h2>
                <Button size="sm" className="bg-purple-500 hover:bg-purple-600">
                  <Users className="w-4 h-4 mr-2" />
                  Create Team
                </Button>
              </div>
              <Card className="bg-zinc-900/50 border-zinc-800">
                <CardContent className="p-4">
                  <div className="space-y-2">
                    {teams
                      .sort((a, b) => b.synergy - a.synergy)
                      .map((team) => (
                        <TeamRow key={team.id} team={team} />
                      ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* Projects Tab */}
            <TabsContent value="projects" className="m-0 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold">
                  All Projects ({projects.length})
                </h2>
                <Button size="sm" className="bg-orange-500 hover:bg-orange-600">
                  <FolderKanban className="w-4 h-4 mr-2" />
                  New Project
                </Button>
              </div>
              <Card className="bg-zinc-900/50 border-zinc-800">
                <CardContent className="p-4">
                  <div className="space-y-2">
                    {projects
                      .sort(
                        (a, b) => b.successProbability - a.successProbability,
                      )
                      .map((project) => (
                        <ProjectRow key={project.id} project={project} />
                      ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* Decisions Tab */}
            <TabsContent value="decisions" className="m-0 space-y-6">
              <div className="flex items-center justify-between">
                <h2 className="text-lg font-semibold">
                  Pending Decisions ({decisions.length})
                </h2>
                <Button size="sm" className="bg-teal-500 hover:bg-teal-600">
                  <GitBranch className="w-4 h-4 mr-2" />
                  New Decision
                </Button>
              </div>
              <Card className="bg-zinc-900/50 border-zinc-800">
                <CardContent className="p-4">
                  <div className="space-y-2">
                    {decisions
                      .sort((a, b) => a.dueDate - b.dueDate)
                      .map((decision) => (
                        <DecisionRow key={decision.id} decision={decision} />
                      ))}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </ScrollArea>
    </div>
  );
}

export default TeamDashboard;
