// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  OPERATIONS CENTER — SLA MONITORING, INCIDENT MANAGEMENT, SYSTEM HEALTH                                  ║
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
  Activity,
  AlertCircle,
  AlertTriangle,
  ArrowDown,
  ArrowUp,
  Bell,
  Brain,
  Check,
  CheckCircle2,
  Clock,
  Cpu,
  Database,
  Eye,
  FileText,
  Flame,
  Gauge,
  Heart,
  HelpCircle,
  Info,
  Layers,
  LineChart,
  MessageSquare,
  Monitor,
  Network,
  Play,
  RefreshCw,
  Server,
  Settings,
  Shield,
  Target,
  Timer,
  TrendingDown,
  TrendingUp,
  Users,
  Wrench,
  XCircle,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface OperationsCenterProps {
  className?: string;
}

interface SystemService {
  id: string;
  name: string;
  status: "Healthy" | "Degraded" | "Down" | "Maintenance";
  uptime: number;
  latency: number;
  requestsPerMinute: number;
  errorRate: number;
  lastHealthCheck: number;
}

interface SLAMetric {
  id: string;
  name: string;
  target: number;
  current: number;
  unit: string;
  status: "Met" | "AtRisk" | "Violated";
  trend: "up" | "down" | "stable";
  measurementPeriod: string;
}

interface Incident {
  id: string;
  title: string;
  severity: "Critical" | "High" | "Medium" | "Low";
  status: "Open" | "Investigating" | "Identified" | "Monitoring" | "Resolved";
  affectedServices: string[];
  createdAt: number;
  updatedAt: number;
  assignee: string;
  impactDescription: string;
}

interface MaintenanceWindow {
  id: string;
  title: string;
  description: string;
  scheduledStart: number;
  scheduledEnd: number;
  affectedServices: string[];
  status: "Scheduled" | "InProgress" | "Completed" | "Cancelled";
  notificationSent: boolean;
}

interface Alert {
  id: string;
  type: "Warning" | "Error" | "Critical" | "Info";
  message: string;
  source: string;
  timestamp: number;
  acknowledged: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const MOCK_SERVICES: SystemService[] = [
  { id: "svc-1", name: "Brain Canister", status: "Healthy", uptime: 99.99, latency: 45, requestsPerMinute: 1250, errorRate: 0.01, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-2", name: "AEGIS Defense", status: "Healthy", uptime: 99.95, latency: 32, requestsPerMinute: 850, errorRate: 0.02, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-3", name: "Colony Coordinator", status: "Healthy", uptime: 99.98, latency: 55, requestsPerMinute: 620, errorRate: 0.01, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-4", name: "Token Treasury", status: "Healthy", uptime: 100.0, latency: 28, requestsPerMinute: 450, errorRate: 0.00, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-5", name: "Law Engine", status: "Healthy", uptime: 99.97, latency: 62, requestsPerMinute: 720, errorRate: 0.01, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-6", name: "QMEM Substrate", status: "Degraded", uptime: 98.50, latency: 125, requestsPerMinute: 380, errorRate: 0.15, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-7", name: "Artifact Store", status: "Healthy", uptime: 99.92, latency: 48, requestsPerMinute: 280, errorRate: 0.03, lastHealthCheck: Date.now() - 30000 },
  { id: "svc-8", name: "Macro Sphere", status: "Healthy", uptime: 99.94, latency: 38, requestsPerMinute: 520, errorRate: 0.02, lastHealthCheck: Date.now() - 30000 },
];

const MOCK_SLAS: SLAMetric[] = [
  { id: "sla-1", name: "System Uptime", target: 99.9, current: 99.95, unit: "%", status: "Met", trend: "stable", measurementPeriod: "30 days" },
  { id: "sla-2", name: "Coherence Threshold", target: 0.85, current: 0.92, unit: "r", status: "Met", trend: "up", measurementPeriod: "7 days" },
  { id: "sla-3", name: "Law Engine Response", target: 100, current: 62, unit: "ms", status: "Met", trend: "stable", measurementPeriod: "24 hours" },
  { id: "sla-4", name: "Task Completion Rate", target: 95, current: 92, unit: "%", status: "AtRisk", trend: "down", measurementPeriod: "7 days" },
  { id: "sla-5", name: "Error Rate", target: 0.1, current: 0.08, unit: "%", status: "Met", trend: "stable", measurementPeriod: "24 hours" },
  { id: "sla-6", name: "Doctrine Integrity", target: 100, current: 100, unit: "%", status: "Met", trend: "stable", measurementPeriod: "Always" },
];

const MOCK_INCIDENTS: Incident[] = [
  {
    id: "inc-1",
    title: "QMEM Substrate Latency Spike",
    severity: "Medium",
    status: "Investigating",
    affectedServices: ["QMEM Substrate", "Deep Memory"],
    createdAt: Date.now() - 3600000,
    updatedAt: Date.now() - 1800000,
    assignee: "CIPHER",
    impactDescription: "Memory retrieval operations experiencing 3x normal latency",
  },
  {
    id: "inc-2",
    title: "Temporary Coherence Dip",
    severity: "Low",
    status: "Monitoring",
    affectedServices: ["Brain Canister"],
    createdAt: Date.now() - 7200000,
    updatedAt: Date.now() - 3600000,
    assignee: "NEXUS",
    impactDescription: "Brief coherence dip to 0.88 during high load, recovered to 0.92",
  },
];

const MOCK_MAINTENANCE: MaintenanceWindow[] = [
  {
    id: "maint-1",
    title: "Scheduled Colony Coordinator Update",
    description: "Deploying performance optimizations for ACO algorithm",
    scheduledStart: Date.now() + 86400000 * 2,
    scheduledEnd: Date.now() + 86400000 * 2 + 7200000,
    affectedServices: ["Colony Coordinator", "ATLAS Grid"],
    status: "Scheduled",
    notificationSent: true,
  },
];

const MOCK_ALERTS: Alert[] = [
  { id: "alert-1", type: "Warning", message: "QMEM latency exceeds threshold (125ms > 100ms)", source: "QMEM Substrate", timestamp: Date.now() - 1800000, acknowledged: false },
  { id: "alert-2", type: "Info", message: "Heritage compounding checkpoint completed", source: "Heritage Engine", timestamp: Date.now() - 3600000, acknowledged: true },
  { id: "alert-3", type: "Warning", message: "Task completion rate trending down (92% vs 95% target)", source: "SLA Monitor", timestamp: Date.now() - 5400000, acknowledged: false },
  { id: "alert-4", type: "Info", message: "AEGIS snapshot ring rotated successfully", source: "AEGIS Defense", timestamp: Date.now() - 7200000, acknowledged: true },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export function OperationsCenter({ className = "" }: OperationsCenterProps) {
  const [services, setServices] = useState<SystemService[]>(MOCK_SERVICES);
  const [slas, setSlas] = useState<SLAMetric[]>(MOCK_SLAS);
  const [incidents, setIncidents] = useState<Incident[]>(MOCK_INCIDENTS);
  const [maintenance, setMaintenance] = useState<MaintenanceWindow[]>(MOCK_MAINTENANCE);
  const [alerts, setAlerts] = useState<Alert[]>(MOCK_ALERTS);
  const [activeTab, setActiveTab] = useState("dashboard");

  // Calculate summary metrics
  const healthyServices = services.filter(s => s.status === "Healthy").length;
  const slasMet = slas.filter(s => s.status === "Met").length;
  const openIncidents = incidents.filter(i => i.status !== "Resolved").length;
  const unacknowledgedAlerts = alerts.filter(a => !a.acknowledged).length;

  // Simulate real-time updates
  useEffect(() => {
    const interval = setInterval(() => {
      setServices(prev => prev.map(s => ({
        ...s,
        latency: Math.max(10, s.latency + Math.floor(Math.random() * 20) - 10),
        requestsPerMinute: Math.max(100, s.requestsPerMinute + Math.floor(Math.random() * 100) - 50),
        lastHealthCheck: Date.now(),
      })));
    }, 5000);

    return () => clearInterval(interval);
  }, []);

  const getStatusColor = (status: string) => {
    switch (status) {
      case "Healthy": return "bg-green-500/20 text-green-400 border-green-500/30";
      case "Degraded": return "bg-yellow-500/20 text-yellow-400 border-yellow-500/30";
      case "Down": return "bg-red-500/20 text-red-400 border-red-500/30";
      case "Maintenance": return "bg-blue-500/20 text-blue-400 border-blue-500/30";
      default: return "bg-zinc-500/20 text-zinc-400 border-zinc-500/30";
    }
  };

  const getSeverityColor = (severity: string) => {
    switch (severity) {
      case "Critical": return "bg-red-500/20 text-red-400 border-red-500/30";
      case "High": return "bg-orange-500/20 text-orange-400 border-orange-500/30";
      case "Medium": return "bg-yellow-500/20 text-yellow-400 border-yellow-500/30";
      case "Low": return "bg-blue-500/20 text-blue-400 border-blue-500/30";
      default: return "bg-zinc-500/20 text-zinc-400 border-zinc-500/30";
    }
  };

  const getAlertIcon = (type: string) => {
    switch (type) {
      case "Critical": return <XCircle className="w-4 h-4 text-red-400" />;
      case "Error": return <AlertCircle className="w-4 h-4 text-red-400" />;
      case "Warning": return <AlertTriangle className="w-4 h-4 text-yellow-400" />;
      case "Info": return <Info className="w-4 h-4 text-blue-400" />;
      default: return <HelpCircle className="w-4 h-4 text-zinc-400" />;
    }
  };

  return (
    <div className={`min-h-screen bg-zinc-950 text-zinc-100 p-6 ${className}`}>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Monitor className="w-6 h-6 text-cyan-400" />
            Operations Center
          </h1>
          <p className="text-sm text-zinc-400 mt-1">
            System health monitoring, SLA tracking, and incident management
          </p>
        </div>
        <div className="flex items-center gap-4">
          <div className={`flex items-center gap-2 px-3 py-1.5 rounded-full border ${
            healthyServices === services.length 
              ? 'bg-green-500/20 border-green-500/30' 
              : 'bg-yellow-500/20 border-yellow-500/30'
          }`}>
            <div className={`w-2 h-2 rounded-full ${
              healthyServices === services.length ? 'bg-green-500' : 'bg-yellow-500'
            } animate-pulse`} />
            <span className={`text-sm ${
              healthyServices === services.length ? 'text-green-400' : 'text-yellow-400'
            }`}>
              {healthyServices}/{services.length} Services Healthy
            </span>
          </div>
          {unacknowledgedAlerts > 0 && (
            <Badge variant="outline" className="bg-red-500/20 text-red-400 border-red-500/30">
              <Bell className="w-3 h-3 mr-1" />
              {unacknowledgedAlerts} Alerts
            </Badge>
          )}
          <Button variant="outline" size="sm">
            <RefreshCw className="w-4 h-4 mr-2" />
            Refresh
          </Button>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <Card className={`bg-black/40 ${healthyServices === services.length ? 'border-green-500/30' : 'border-yellow-500/30'}`}>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Services</p>
                <p className={`text-2xl font-bold ${healthyServices === services.length ? 'text-green-400' : 'text-yellow-400'}`}>
                  {healthyServices}/{services.length}
                </p>
                <p className="text-xs text-zinc-500">Healthy</p>
              </div>
              <Server className={`w-8 h-8 ${healthyServices === services.length ? 'text-green-400' : 'text-yellow-400'}`} />
            </div>
          </CardContent>
        </Card>

        <Card className={`bg-black/40 ${slasMet === slas.length ? 'border-cyan-500/30' : 'border-yellow-500/30'}`}>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">SLAs</p>
                <p className={`text-2xl font-bold ${slasMet === slas.length ? 'text-cyan-400' : 'text-yellow-400'}`}>
                  {slasMet}/{slas.length}
                </p>
                <p className="text-xs text-zinc-500">Met</p>
              </div>
              <Target className={`w-8 h-8 ${slasMet === slas.length ? 'text-cyan-400' : 'text-yellow-400'}`} />
            </div>
          </CardContent>
        </Card>

        <Card className={`bg-black/40 ${openIncidents === 0 ? 'border-green-500/30' : 'border-orange-500/30'}`}>
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Incidents</p>
                <p className={`text-2xl font-bold ${openIncidents === 0 ? 'text-green-400' : 'text-orange-400'}`}>
                  {openIncidents}
                </p>
                <p className="text-xs text-zinc-500">Open</p>
              </div>
              <AlertTriangle className={`w-8 h-8 ${openIncidents === 0 ? 'text-green-400' : 'text-orange-400'}`} />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-purple-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Maintenance</p>
                <p className="text-2xl font-bold text-purple-400">
                  {maintenance.filter(m => m.status === "Scheduled").length}
                </p>
                <p className="text-xs text-zinc-500">Scheduled</p>
              </div>
              <Wrench className="w-8 h-8 text-purple-400" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Main Content */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="bg-zinc-900 border border-zinc-800">
          <TabsTrigger value="dashboard" className="data-[state=active]:bg-zinc-800">
            <Gauge className="w-4 h-4 mr-2" />
            Dashboard
          </TabsTrigger>
          <TabsTrigger value="services" className="data-[state=active]:bg-zinc-800">
            <Server className="w-4 h-4 mr-2" />
            Services
          </TabsTrigger>
          <TabsTrigger value="slas" className="data-[state=active]:bg-zinc-800">
            <Target className="w-4 h-4 mr-2" />
            SLAs
          </TabsTrigger>
          <TabsTrigger value="incidents" className="data-[state=active]:bg-zinc-800">
            <AlertTriangle className="w-4 h-4 mr-2" />
            Incidents
          </TabsTrigger>
          <TabsTrigger value="alerts" className="data-[state=active]:bg-zinc-800">
            <Bell className="w-4 h-4 mr-2" />
            Alerts
          </TabsTrigger>
        </TabsList>

        {/* Dashboard Tab */}
        <TabsContent value="dashboard" className="space-y-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Service Status Grid */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Server className="w-5 h-5 text-cyan-400" />
                  Service Status
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-2 gap-3">
                  {services.map(service => (
                    <div key={service.id} className="p-3 bg-zinc-900 rounded-lg">
                      <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-semibold text-zinc-100">{service.name}</span>
                        <Badge variant="outline" className={getStatusColor(service.status)}>
                          {service.status}
                        </Badge>
                      </div>
                      <div className="flex items-center justify-between text-xs text-zinc-400">
                        <span>{service.latency}ms</span>
                        <span>{service.requestsPerMinute} rpm</span>
                        <span>{service.uptime.toFixed(2)}%</span>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Recent Alerts */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Bell className="w-5 h-5 text-amber-400" />
                  Recent Alerts
                </CardTitle>
              </CardHeader>
              <CardContent>
                <ScrollArea className="h-[300px]">
                  <div className="space-y-3">
                    {alerts.map(alert => (
                      <div key={alert.id} className={`p-3 rounded-lg border ${
                        alert.acknowledged ? 'bg-zinc-900 border-zinc-800' : 'bg-zinc-900/80 border-zinc-700'
                      }`}>
                        <div className="flex items-center gap-2 mb-1">
                          {getAlertIcon(alert.type)}
                          <span className="text-sm text-zinc-100">{alert.message}</span>
                        </div>
                        <div className="flex items-center justify-between text-xs text-zinc-500">
                          <span>{alert.source}</span>
                          <span>{Math.floor((Date.now() - alert.timestamp) / 60000)}m ago</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </CardContent>
            </Card>
          </div>

          {/* SLA Status */}
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Target className="w-5 h-5 text-green-400" />
                SLA Performance
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
                {slas.map(sla => {
                  const percentage = sla.unit === "%" || sla.unit === "r" 
                    ? (sla.current / sla.target) * 100 
                    : sla.current <= sla.target ? 100 : (sla.target / sla.current) * 100;
                  const statusColor = {
                    Met: "text-green-400",
                    AtRisk: "text-yellow-400",
                    Violated: "text-red-400",
                  };
                  const trendIcon = {
                    up: <ArrowUp className="w-3 h-3 text-green-400" />,
                    down: <ArrowDown className="w-3 h-3 text-red-400" />,
                    stable: <Activity className="w-3 h-3 text-zinc-400" />,
                  };

                  return (
                    <div key={sla.id} className="p-4 bg-zinc-900 rounded-lg text-center">
                      <p className="text-xs text-zinc-400 mb-1">{sla.name}</p>
                      <p className={`text-xl font-bold ${statusColor[sla.status]}`}>
                        {sla.current}{sla.unit === "%" || sla.unit === "r" ? sla.unit : ` ${sla.unit}`}
                      </p>
                      <div className="flex items-center justify-center gap-1 text-xs text-zinc-500">
                        {trendIcon[sla.trend]}
                        <span>Target: {sla.target}{sla.unit}</span>
                      </div>
                    </div>
                  );
                })}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Services Tab */}
        <TabsContent value="services" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Server className="w-5 h-5 text-cyan-400" />
                All Services
              </CardTitle>
              <CardDescription>Detailed service health and performance metrics</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {services.map(service => (
                  <div key={service.id} className="p-4 bg-zinc-900 rounded-lg">
                    <div className="flex items-center justify-between mb-4">
                      <div className="flex items-center gap-3">
                        <div className={`w-3 h-3 rounded-full ${
                          service.status === "Healthy" ? 'bg-green-500' :
                          service.status === "Degraded" ? 'bg-yellow-500' :
                          'bg-red-500'
                        } animate-pulse`} />
                        <span className="font-semibold text-zinc-100">{service.name}</span>
                        <Badge variant="outline" className={getStatusColor(service.status)}>
                          {service.status}
                        </Badge>
                      </div>
                      <div className="flex items-center gap-4 text-sm">
                        <span className="text-zinc-400">
                          Last check: {Math.floor((Date.now() - service.lastHealthCheck) / 1000)}s ago
                        </span>
                        <Button variant="outline" size="sm">
                          <Eye className="w-4 h-4 mr-1" />
                          Details
                        </Button>
                      </div>
                    </div>
                    <div className="grid grid-cols-4 gap-4">
                      <div className="space-y-1">
                        <p className="text-xs text-zinc-400">Uptime</p>
                        <Progress value={service.uptime} className="h-2" />
                        <p className="text-sm font-semibold text-green-400">{service.uptime.toFixed(2)}%</p>
                      </div>
                      <div className="text-center">
                        <p className="text-xs text-zinc-400">Latency</p>
                        <p className={`text-lg font-bold ${
                          service.latency < 100 ? 'text-green-400' : 'text-yellow-400'
                        }`}>{service.latency}ms</p>
                      </div>
                      <div className="text-center">
                        <p className="text-xs text-zinc-400">Requests/min</p>
                        <p className="text-lg font-bold text-cyan-400">{service.requestsPerMinute}</p>
                      </div>
                      <div className="text-center">
                        <p className="text-xs text-zinc-400">Error Rate</p>
                        <p className={`text-lg font-bold ${
                          service.errorRate < 0.1 ? 'text-green-400' : 'text-yellow-400'
                        }`}>{service.errorRate.toFixed(2)}%</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* SLAs Tab */}
        <TabsContent value="slas" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Target className="w-5 h-5 text-green-400" />
                SLA Definitions & Performance
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {slas.map(sla => {
                  const statusColor = {
                    Met: "border-green-500/30 bg-green-500/10",
                    AtRisk: "border-yellow-500/30 bg-yellow-500/10",
                    Violated: "border-red-500/30 bg-red-500/10",
                  };
                  const percentage = sla.unit === "%" || sla.unit === "r"
                    ? Math.min(100, (sla.current / sla.target) * 100)
                    : Math.min(100, sla.current <= sla.target ? 100 : (sla.target / sla.current) * 100);

                  return (
                    <div key={sla.id} className={`p-4 rounded-lg border ${statusColor[sla.status]}`}>
                      <div className="flex items-center justify-between mb-3">
                        <div>
                          <p className="font-semibold text-zinc-100">{sla.name}</p>
                          <p className="text-xs text-zinc-400">Measured over {sla.measurementPeriod}</p>
                        </div>
                        <Badge variant="outline" className={
                          sla.status === "Met" ? "bg-green-500/20 text-green-400 border-green-500/30" :
                          sla.status === "AtRisk" ? "bg-yellow-500/20 text-yellow-400 border-yellow-500/30" :
                          "bg-red-500/20 text-red-400 border-red-500/30"
                        }>
                          {sla.status}
                        </Badge>
                      </div>
                      <div className="space-y-2">
                        <div className="flex items-center justify-between text-sm">
                          <span className="text-zinc-400">Current: {sla.current}{sla.unit}</span>
                          <span className="text-zinc-400">Target: {sla.target}{sla.unit}</span>
                        </div>
                        <Progress value={percentage} className="h-2" />
                      </div>
                    </div>
                  );
                })}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Incidents Tab */}
        <TabsContent value="incidents" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <AlertTriangle className="w-5 h-5 text-orange-400" />
                Incident Management
              </CardTitle>
              <CardDescription>Active and recent incidents</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {incidents.map(incident => (
                  <div key={incident.id} className="p-4 bg-zinc-900 rounded-lg border border-zinc-800">
                    <div className="flex items-center justify-between mb-3">
                      <div className="flex items-center gap-2">
                        <Badge variant="outline" className={getSeverityColor(incident.severity)}>
                          {incident.severity}
                        </Badge>
                        <span className="font-semibold text-zinc-100">{incident.title}</span>
                      </div>
                      <Badge variant="outline">
                        {incident.status}
                      </Badge>
                    </div>
                    <p className="text-sm text-zinc-400 mb-3">{incident.impactDescription}</p>
                    <div className="flex items-center justify-between text-xs text-zinc-500">
                      <div className="flex items-center gap-4">
                        <span>Assigned: {incident.assignee}</span>
                        <span>Affected: {incident.affectedServices.join(", ")}</span>
                      </div>
                      <div className="flex items-center gap-4">
                        <span>Created: {Math.floor((Date.now() - incident.createdAt) / 3600000)}h ago</span>
                        <span>Updated: {Math.floor((Date.now() - incident.updatedAt) / 60000)}m ago</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Alerts Tab */}
        <TabsContent value="alerts" className="space-y-6">
          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle className="flex items-center gap-2 text-lg">
                <Bell className="w-5 h-5 text-amber-400" />
                Alert History
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {alerts.map(alert => (
                  <div key={alert.id} className={`p-4 rounded-lg border ${
                    alert.acknowledged ? 'bg-zinc-900 border-zinc-800' : 'bg-zinc-900/80 border-zinc-700'
                  }`}>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        {getAlertIcon(alert.type)}
                        <div>
                          <p className="text-sm font-semibold text-zinc-100">{alert.message}</p>
                          <p className="text-xs text-zinc-500">Source: {alert.source}</p>
                        </div>
                      </div>
                      <div className="flex items-center gap-4">
                        <span className="text-xs text-zinc-500">
                          {Math.floor((Date.now() - alert.timestamp) / 60000)}m ago
                        </span>
                        {!alert.acknowledged && (
                          <Button variant="outline" size="sm">
                            <Check className="w-4 h-4 mr-1" />
                            Acknowledge
                          </Button>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

export default OperationsCenter;
