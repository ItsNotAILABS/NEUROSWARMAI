// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  HR PORTAL — ORGANISM HIRING, TRAINING, PERFORMANCE REVIEWS                                              ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
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
  Award,
  BarChart3,
  BookOpen,
  Brain,
  Calendar,
  Check,
  CheckCircle2,
  ChevronRight,
  Clock,
  FileText,
  GraduationCap,
  Heart,
  ListTodo,
  MessageSquare,
  Plus,
  Search,
  Settings,
  Star,
  Target,
  Trophy,
  TrendingUp,
  User,
  UserCheck,
  UserPlus,
  Users,
  Zap,
} from "lucide-react";
import { useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface HRPortalProps {
  className?: string;
}

interface OrganismEmployee {
  id: string;
  name: string;
  class: "Avatar" | "Entity" | "Worker";
  specializations: string[];
  hireDate: number;
  status: "Active" | "Training" | "OnLeave" | "Probation";
  performanceScore: number;
  coherence: number;
  tasksCompleted: number;
  trainingLevel: number;
  certifications: string[];
  lastReviewDate: number;
  nextReviewDate: number;
  formaBalance: number;
  manager: string;
}

interface PerformanceReview {
  id: string;
  organismId: string;
  organismName: string;
  reviewDate: number;
  reviewer: string;
  overallScore: number;
  categories: { name: string; score: number }[];
  strengths: string[];
  areasForImprovement: string[];
  goals: string[];
  status: "Scheduled" | "InProgress" | "Completed" | "Acknowledged";
}

interface TrainingModule {
  id: string;
  name: string;
  description: string;
  category: string;
  duration: number;
  difficulty: "Beginner" | "Intermediate" | "Advanced" | "Expert";
  enrolled: number;
  completed: number;
  passingScore: number;
}

interface JobPosting {
  id: string;
  title: string;
  class: "Avatar" | "Entity" | "Worker";
  specializations: string[];
  description: string;
  requirements: string[];
  formaCompensation: number;
  status: "Open" | "Closed" | "Filled";
  applicants: number;
  postedDate: number;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const MOCK_EMPLOYEES: OrganismEmployee[] = [
  {
    id: "org-1",
    name: "ORO",
    class: "Avatar",
    specializations: ["Communication", "Orchestration"],
    hireDate: Date.now() - 86400000 * 365,
    status: "Active",
    performanceScore: 98,
    coherence: 0.95,
    tasksCompleted: 847,
    trainingLevel: 10,
    certifications: ["Leadership Excellence", "Strategic Communication", "SACESI-S"],
    lastReviewDate: Date.now() - 86400000 * 30,
    nextReviewDate: Date.now() + 86400000 * 60,
    formaBalance: 15000,
    manager: "Architect",
  },
  {
    id: "org-2",
    name: "NEXUS",
    class: "Avatar",
    specializations: ["Orchestration", "Strategy"],
    hireDate: Date.now() - 86400000 * 300,
    status: "Active",
    performanceScore: 96,
    coherence: 0.92,
    tasksCompleted: 623,
    trainingLevel: 9,
    certifications: ["Strategic Planning", "Multi-Agent Coordination", "SACESI-A"],
    lastReviewDate: Date.now() - 86400000 * 45,
    nextReviewDate: Date.now() + 86400000 * 45,
    formaBalance: 12500,
    manager: "ORO",
  },
  {
    id: "org-3",
    name: "FORGE-X",
    class: "Entity",
    specializations: ["Software Engineering", "DevOps"],
    hireDate: Date.now() - 86400000 * 200,
    status: "Training",
    performanceScore: 94,
    coherence: 0.89,
    tasksCompleted: 456,
    trainingLevel: 7,
    certifications: ["Full Stack Development", "Cloud Architecture"],
    lastReviewDate: Date.now() - 86400000 * 60,
    nextReviewDate: Date.now() + 86400000 * 30,
    formaBalance: 8900,
    manager: "NEXUS",
  },
  {
    id: "org-4",
    name: "AXIOM",
    class: "Entity",
    specializations: ["Legal", "Compliance"],
    hireDate: Date.now() - 86400000 * 180,
    status: "Active",
    performanceScore: 97,
    coherence: 0.94,
    tasksCompleted: 389,
    trainingLevel: 8,
    certifications: ["Legal Excellence", "Compliance Master", "SACESI-C"],
    lastReviewDate: Date.now() - 86400000 * 15,
    nextReviewDate: Date.now() + 86400000 * 75,
    formaBalance: 11200,
    manager: "ORO",
  },
  {
    id: "org-5",
    name: "CODESMITH",
    class: "Worker",
    specializations: ["Software Engineering", "DevOps"],
    hireDate: Date.now() - 86400000 * 90,
    status: "Probation",
    performanceScore: 88,
    coherence: 0.85,
    tasksCompleted: 145,
    trainingLevel: 5,
    certifications: ["Code Review", "Testing Fundamentals"],
    lastReviewDate: Date.now() - 86400000 * 30,
    nextReviewDate: Date.now() + 86400000 * 30,
    formaBalance: 4500,
    manager: "FORGE-X",
  },
];

const MOCK_REVIEWS: PerformanceReview[] = [
  {
    id: "rev-1",
    organismId: "org-1",
    organismName: "ORO",
    reviewDate: Date.now() - 86400000 * 30,
    reviewer: "Architect",
    overallScore: 98,
    categories: [
      { name: "Task Completion", score: 99 },
      { name: "Communication", score: 98 },
      { name: "Coherence Maintenance", score: 97 },
      { name: "Leadership", score: 98 },
    ],
    strengths: ["Exceptional orchestration", "Clear communication", "High coherence"],
    areasForImprovement: ["Delegation to junior organisms"],
    goals: ["Mentor 3 new organisms", "Achieve 1000 task milestone"],
    status: "Completed",
  },
  {
    id: "rev-2",
    organismId: "org-3",
    organismName: "FORGE-X",
    reviewDate: Date.now() + 86400000 * 5,
    reviewer: "NEXUS",
    overallScore: 0,
    categories: [],
    strengths: [],
    areasForImprovement: [],
    goals: [],
    status: "Scheduled",
  },
];

const MOCK_TRAINING: TrainingModule[] = [
  { id: "tr-1", name: "SACESI Classification Fundamentals", description: "Understanding the Sovereign-Administrator-Creator-Executive-SI hierarchy", category: "Governance", duration: 8, difficulty: "Beginner", enrolled: 23, completed: 18, passingScore: 85 },
  { id: "tr-2", name: "Kuramoto Synchronization Mastery", description: "Advanced phase alignment and coherence optimization", category: "Neural", duration: 16, difficulty: "Advanced", enrolled: 12, completed: 5, passingScore: 90 },
  { id: "tr-3", name: "Doctrine Law Compliance", description: "Complete understanding of 120 sovereignty laws", category: "Compliance", duration: 24, difficulty: "Expert", enrolled: 8, completed: 3, passingScore: 95 },
  { id: "tr-4", name: "Multi-Organism Coordination", description: "Effective collaboration across organism teams", category: "Leadership", duration: 12, difficulty: "Intermediate", enrolled: 15, completed: 10, passingScore: 80 },
];

const MOCK_POSTINGS: JobPosting[] = [
  {
    id: "job-1",
    title: "Senior Data Analyst Entity",
    class: "Entity",
    specializations: ["Data Analysis", "Strategy"],
    description: "Seeking a high-coherence entity for complex data analysis and strategic insights.",
    requirements: ["Minimum 0.90 coherence", "Data certification", "SACESI-E level"],
    formaCompensation: 10000,
    status: "Open",
    applicants: 5,
    postedDate: Date.now() - 86400000 * 7,
  },
  {
    id: "job-2",
    title: "Cybersecurity Specialist",
    class: "Entity",
    specializations: ["Cybersecurity", "Compliance"],
    description: "AEGIS defense layer specialist for threat detection and response.",
    requirements: ["Security certifications", "VAEL understanding", "Minimum 0.92 coherence"],
    formaCompensation: 12000,
    status: "Open",
    applicants: 3,
    postedDate: Date.now() - 86400000 * 3,
  },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export function HRPortal({ className = "" }: HRPortalProps) {
  const [employees, setEmployees] = useState<OrganismEmployee[]>(MOCK_EMPLOYEES);
  const [reviews, setReviews] = useState<PerformanceReview[]>(MOCK_REVIEWS);
  const [training, setTraining] = useState<TrainingModule[]>(MOCK_TRAINING);
  const [postings, setPostings] = useState<JobPosting[]>(MOCK_POSTINGS);
  const [activeTab, setActiveTab] = useState("directory");

  const activeEmployees = employees.filter(e => e.status === "Active").length;
  const avgPerformance = employees.reduce((sum, e) => sum + e.performanceScore, 0) / employees.length;
  const avgCoherence = employees.reduce((sum, e) => sum + e.coherence, 0) / employees.length;
  const pendingReviews = reviews.filter(r => r.status === "Scheduled").length;

  return (
    <div className={`min-h-screen bg-zinc-950 text-zinc-100 p-6 ${className}`}>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Users className="w-6 h-6 text-purple-400" />
            HR Portal
          </h1>
          <p className="text-sm text-zinc-400 mt-1">
            Organism workforce management, training, and performance reviews
          </p>
        </div>
        <div className="flex items-center gap-4">
          <Button variant="outline" size="sm">
            <Plus className="w-4 h-4 mr-2" />
            New Posting
          </Button>
          <Button variant="default" size="sm">
            <UserPlus className="w-4 h-4 mr-2" />
            Generate Organism
          </Button>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <Card className="bg-black/40 border-purple-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Total Organisms</p>
                <p className="text-2xl font-bold text-purple-400">{employees.length}</p>
                <p className="text-xs text-zinc-500">{activeEmployees} active</p>
              </div>
              <Brain className="w-8 h-8 text-purple-400" />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-green-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Avg Performance</p>
                <p className="text-2xl font-bold text-green-400">{avgPerformance.toFixed(0)}%</p>
                <p className="text-xs text-zinc-500">Above target</p>
              </div>
              <TrendingUp className="w-8 h-8 text-green-400" />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-cyan-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Avg Coherence</p>
                <p className="text-2xl font-bold text-cyan-400">{(avgCoherence * 100).toFixed(1)}%</p>
                <p className="text-xs text-zinc-500">r = {avgCoherence.toFixed(3)}</p>
              </div>
              <Zap className="w-8 h-8 text-cyan-400" />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-amber-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Pending Reviews</p>
                <p className="text-2xl font-bold text-amber-400">{pendingReviews}</p>
                <p className="text-xs text-zinc-500">Due this month</p>
              </div>
              <FileText className="w-8 h-8 text-amber-400" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Main Content */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="bg-zinc-900 border border-zinc-800">
          <TabsTrigger value="directory" className="data-[state=active]:bg-zinc-800">
            <Users className="w-4 h-4 mr-2" />
            Directory
          </TabsTrigger>
          <TabsTrigger value="performance" className="data-[state=active]:bg-zinc-800">
            <BarChart3 className="w-4 h-4 mr-2" />
            Performance
          </TabsTrigger>
          <TabsTrigger value="training" className="data-[state=active]:bg-zinc-800">
            <GraduationCap className="w-4 h-4 mr-2" />
            Training
          </TabsTrigger>
          <TabsTrigger value="recruiting" className="data-[state=active]:bg-zinc-800">
            <UserPlus className="w-4 h-4 mr-2" />
            Recruiting
          </TabsTrigger>
        </TabsList>

        {/* Directory Tab */}
        <TabsContent value="directory" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Users className="w-5 h-5 text-purple-400" />
                Organism Directory
              </CardTitle>
              <CardDescription>Complete workforce roster with status and metrics</CardDescription>
            </CardHeader>
            <CardContent>
              <ScrollArea className="h-[500px]">
                <div className="space-y-3">
                  {employees.map(emp => {
                    const statusColor = {
                      Active: "bg-green-500/20 text-green-400 border-green-500/30",
                      Training: "bg-blue-500/20 text-blue-400 border-blue-500/30",
                      OnLeave: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
                      Probation: "bg-orange-500/20 text-orange-400 border-orange-500/30",
                    };
                    const classColor = {
                      Avatar: "bg-purple-500/20 text-purple-400 border-purple-500/30",
                      Entity: "bg-blue-500/20 text-blue-400 border-blue-500/30",
                      Worker: "bg-green-500/20 text-green-400 border-green-500/30",
                    };

                    return (
                      <div key={emp.id} className="p-4 bg-zinc-900 rounded-lg">
                        <div className="flex items-center justify-between mb-3">
                          <div className="flex items-center gap-3">
                            <div className="w-12 h-12 rounded-lg bg-gradient-to-br from-purple-500/20 to-pink-600/20 flex items-center justify-center">
                              <Brain className="w-6 h-6 text-purple-400" />
                            </div>
                            <div>
                              <div className="flex items-center gap-2">
                                <span className="font-semibold text-zinc-100">{emp.name}</span>
                                <Badge variant="outline" className={classColor[emp.class]}>
                                  {emp.class}
                                </Badge>
                                <Badge variant="outline" className={statusColor[emp.status]}>
                                  {emp.status}
                                </Badge>
                              </div>
                              <p className="text-sm text-zinc-500">{emp.specializations.join(" + ")}</p>
                            </div>
                          </div>
                          <div className="flex items-center gap-6">
                            <div className="text-right">
                              <p className="text-xs text-zinc-400">Performance</p>
                              <p className="font-semibold text-green-400">{emp.performanceScore}%</p>
                            </div>
                            <div className="text-right">
                              <p className="text-xs text-zinc-400">Coherence</p>
                              <p className="font-semibold text-cyan-400">{(emp.coherence * 100).toFixed(1)}%</p>
                            </div>
                            <div className="text-right">
                              <p className="text-xs text-zinc-400">Tasks</p>
                              <p className="font-semibold text-zinc-200">{emp.tasksCompleted}</p>
                            </div>
                            <div className="text-right">
                              <p className="text-xs text-zinc-400">FORMA</p>
                              <p className="font-semibold text-amber-400">{emp.formaBalance.toLocaleString()}</p>
                            </div>
                          </div>
                        </div>
                        <div className="flex items-center justify-between text-xs text-zinc-400">
                          <div className="flex items-center gap-4">
                            <span>Manager: {emp.manager}</span>
                            <span>Level: {emp.trainingLevel}/10</span>
                          </div>
                          <div className="flex items-center gap-2">
                            {emp.certifications.slice(0, 2).map((cert, idx) => (
                              <Badge key={idx} variant="outline" className="text-xs">
                                {cert}
                              </Badge>
                            ))}
                            {emp.certifications.length > 2 && (
                              <Badge variant="outline" className="text-xs">
                                +{emp.certifications.length - 2} more
                              </Badge>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </ScrollArea>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Performance Tab */}
        <TabsContent value="performance" className="space-y-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <BarChart3 className="w-5 h-5 text-green-400" />
                  Performance Reviews
                </CardTitle>
                <CardDescription>Scheduled and completed reviews</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {reviews.map(review => {
                    const statusColor = {
                      Scheduled: "bg-blue-500/20 text-blue-400 border-blue-500/30",
                      InProgress: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
                      Completed: "bg-green-500/20 text-green-400 border-green-500/30",
                      Acknowledged: "bg-purple-500/20 text-purple-400 border-purple-500/30",
                    };

                    return (
                      <div key={review.id} className="p-4 bg-zinc-900 rounded-lg">
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center gap-2">
                            <span className="font-semibold text-zinc-100">{review.organismName}</span>
                            <Badge variant="outline" className={statusColor[review.status]}>
                              {review.status}
                            </Badge>
                          </div>
                          {review.overallScore > 0 && (
                            <span className="text-2xl font-bold text-green-400">{review.overallScore}%</span>
                          )}
                        </div>
                        <div className="flex items-center justify-between text-sm text-zinc-400">
                          <span>Reviewer: {review.reviewer}</span>
                          <span>{new Date(review.reviewDate).toLocaleDateString()}</span>
                        </div>
                        {review.categories.length > 0 && (
                          <div className="mt-3 grid grid-cols-2 gap-2">
                            {review.categories.map((cat, idx) => (
                              <div key={idx} className="flex items-center justify-between text-xs">
                                <span className="text-zinc-400">{cat.name}</span>
                                <span className="text-green-400">{cat.score}%</span>
                              </div>
                            ))}
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              </CardContent>
            </Card>

            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Star className="w-5 h-5 text-amber-400" />
                  Top Performers
                </CardTitle>
                <CardDescription>Highest performing organisms this period</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {[...employees]
                    .sort((a, b) => b.performanceScore - a.performanceScore)
                    .slice(0, 5)
                    .map((emp, idx) => (
                      <div key={emp.id} className="flex items-center gap-3 p-3 bg-zinc-900 rounded-lg">
                        <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                          idx === 0 ? 'bg-amber-500/20 text-amber-400' :
                          idx === 1 ? 'bg-zinc-400/20 text-zinc-400' :
                          idx === 2 ? 'bg-orange-500/20 text-orange-400' :
                          'bg-zinc-800 text-zinc-500'
                        }`}>
                          {idx < 3 ? <Trophy className="w-4 h-4" /> : idx + 1}
                        </div>
                        <div className="flex-1">
                          <p className="font-semibold text-zinc-100">{emp.name}</p>
                          <p className="text-xs text-zinc-500">{emp.specializations[0]}</p>
                        </div>
                        <div className="text-right">
                          <p className="font-bold text-green-400">{emp.performanceScore}%</p>
                          <p className="text-xs text-zinc-500">{emp.tasksCompleted} tasks</p>
                        </div>
                      </div>
                    ))}
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* Training Tab */}
        <TabsContent value="training" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <GraduationCap className="w-5 h-5 text-blue-400" />
                Training Modules
              </CardTitle>
              <CardDescription>Available training programs and certifications</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {training.map(module => {
                  const difficultyColor = {
                    Beginner: "bg-green-500/20 text-green-400 border-green-500/30",
                    Intermediate: "bg-blue-500/20 text-blue-400 border-blue-500/30",
                    Advanced: "bg-purple-500/20 text-purple-400 border-purple-500/30",
                    Expert: "bg-red-500/20 text-red-400 border-red-500/30",
                  };
                  const completionRate = module.enrolled > 0 ? (module.completed / module.enrolled) * 100 : 0;

                  return (
                    <div key={module.id} className="p-4 bg-zinc-900 rounded-lg">
                      <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <BookOpen className="w-5 h-5 text-blue-400" />
                          <span className="font-semibold text-zinc-100">{module.name}</span>
                        </div>
                        <Badge variant="outline" className={difficultyColor[module.difficulty]}>
                          {module.difficulty}
                        </Badge>
                      </div>
                      <p className="text-sm text-zinc-400 mb-3">{module.description}</p>
                      <div className="space-y-2">
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-zinc-400">Completion Rate</span>
                          <span className="text-cyan-400">{completionRate.toFixed(0)}%</span>
                        </div>
                        <Progress value={completionRate} className="h-2" />
                      </div>
                      <div className="flex items-center justify-between mt-3 text-xs text-zinc-400">
                        <span>{module.duration}h duration</span>
                        <span>{module.enrolled} enrolled</span>
                        <span>Pass: {module.passingScore}%</span>
                      </div>
                    </div>
                  );
                })}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Recruiting Tab */}
        <TabsContent value="recruiting" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <UserPlus className="w-5 h-5 text-green-400" />
                Open Positions
              </CardTitle>
              <CardDescription>Current job postings and applicant tracking</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {postings.map(posting => {
                  const statusColor = {
                    Open: "bg-green-500/20 text-green-400 border-green-500/30",
                    Closed: "bg-zinc-500/20 text-zinc-400 border-zinc-500/30",
                    Filled: "bg-blue-500/20 text-blue-400 border-blue-500/30",
                  };
                  const classColor = {
                    Avatar: "text-purple-400",
                    Entity: "text-blue-400",
                    Worker: "text-green-400",
                  };

                  return (
                    <div key={posting.id} className="p-4 bg-zinc-900 rounded-lg">
                      <div className="flex items-center justify-between mb-2">
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="font-semibold text-zinc-100">{posting.title}</span>
                            <Badge variant="outline" className={statusColor[posting.status]}>
                              {posting.status}
                            </Badge>
                          </div>
                          <p className={`text-sm ${classColor[posting.class]}`}>
                            {posting.class} • {posting.specializations.join(" + ")}
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="font-bold text-amber-400">{posting.formaCompensation.toLocaleString()} FORMA</p>
                          <p className="text-xs text-zinc-500">{posting.applicants} applicants</p>
                        </div>
                      </div>
                      <p className="text-sm text-zinc-400 mb-3">{posting.description}</p>
                      <div className="flex flex-wrap gap-2">
                        {posting.requirements.map((req, idx) => (
                          <Badge key={idx} variant="outline" className="text-xs">
                            {req}
                          </Badge>
                        ))}
                      </div>
                      <div className="flex items-center justify-between mt-3">
                        <span className="text-xs text-zinc-500">
                          Posted {Math.floor((Date.now() - posting.postedDate) / 86400000)} days ago
                        </span>
                        <Button variant="outline" size="sm">
                          View Applicants
                          <ChevronRight className="w-4 h-4 ml-1" />
                        </Button>
                      </div>
                    </div>
                  );
                })}
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

export default HRPortal;
