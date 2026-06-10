import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  ArrowDown,
  ArrowUp,
  BarChart3,
  Brain,
  Calendar,
  Clock,
  Cpu,
  Database,
  Download,
  Filter,
  Heart,
  LineChart,
  Minus,
  RefreshCw,
  Settings,
  TrendingDown,
  TrendingUp,
  Zap,
} from "lucide-react";
import { useEffect, useState } from "react";
import type { MockOrganism } from "../../data/organisms";

// ===================== Types =====================

interface TimeRange {
  label: string;
  value: string;
  hours: number;
}

interface MetricData {
  current: number;
  previous: number;
  change: number;
  changePercent: number;
  trend: "up" | "down" | "stable";
}

interface DataPoint {
  timestamp: number;
  value: number;
  label: string;
}

interface TrendAnalysis {
  slope: number;
  r2: number;
  prediction: number;
  confidence: number;
  status: "excellent" | "good" | "fair" | "needs_attention";
}

interface HealthIndicator {
  name: string;
  value: number;
  status: "healthy" | "warning" | "critical";
  threshold: number;
  recommendation?: string;
}

interface OrganismHealth {
  overallScore: number;
  status: string;
  indicators: HealthIndicator[];
}

interface ActivityEvent {
  id: string;
  type: string;
  details: string;
  timestamp: number;
}

// ===================== Constants =====================

const TIME_RANGES: TimeRange[] = [
  { label: "1H", value: "1h", hours: 1 },
  { label: "6H", value: "6h", hours: 6 },
  { label: "24H", value: "24h", hours: 24 },
  { label: "7D", value: "7d", hours: 168 },
  { label: "30D", value: "30d", hours: 720 },
  { label: "ALL", value: "all", hours: 8760 },
];

const _METRIC_COLORS: Record<string, string> = {
  coherence: "text-primary",
  formaBalance: "text-amber-400",
  governanceScore: "text-blue-400",
  compoundIndex: "text-emerald-400",
  activationCount: "text-purple-400",
  hzMean: "text-cyan-400",
  neuroChemMean: "text-rose-400",
  mintRate: "text-orange-400",
};

// ===================== Utility Functions =====================

function generateHistoricalData(
  baseValue: number,
  variance: number,
  points: number,
  trend = 0,
): DataPoint[] {
  const now = Date.now();
  const interval = (24 * 60 * 60 * 1000) / points;

  return Array.from({ length: points }, (_, i) => {
    const trendAdjustment = trend * (i / points);
    const noise = (Math.random() - 0.5) * variance;
    const value = Math.max(0, Math.min(1, baseValue + trendAdjustment + noise));

    return {
      timestamp: now - (points - i) * interval,
      value,
      label: new Date(now - (points - i) * interval).toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
      }),
    };
  });
}

function calculateMetricData(
  current: number,
  historicalData: DataPoint[],
): MetricData {
  const previous =
    historicalData.length > 1
      ? historicalData[historicalData.length - 2].value
      : current;
  const change = current - previous;
  const changePercent = previous !== 0 ? (change / previous) * 100 : 0;

  return {
    current,
    previous,
    change,
    changePercent,
    trend: change > 0.001 ? "up" : change < -0.001 ? "down" : "stable",
  };
}

function calculateTrendAnalysis(data: DataPoint[]): TrendAnalysis {
  if (data.length < 2) {
    return { slope: 0, r2: 0, prediction: 0, confidence: 0, status: "fair" };
  }

  // Simple linear regression
  const n = data.length;
  let sumX = 0;
  let sumY = 0;
  let sumXY = 0;
  let sumXX = 0;

  data.forEach((point, i) => {
    sumX += i;
    sumY += point.value;
    sumXY += i * point.value;
    sumXX += i * i;
  });

  const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
  const intercept = (sumY - slope * sumX) / n;

  // Calculate R-squared
  const yMean = sumY / n;
  let ssRes = 0;
  let ssTot = 0;

  data.forEach((point, i) => {
    const predicted = slope * i + intercept;
    ssRes += (point.value - predicted) ** 2;
    ssTot += (point.value - yMean) ** 2;
  });

  const r2 = ssTot !== 0 ? 1 - ssRes / ssTot : 0;
  const prediction = slope * (n + 1) + intercept;
  const confidence = Math.min(1, (r2 + n / 24) / 2);

  const status: TrendAnalysis["status"] =
    r2 > 0.8 && slope > 0
      ? "excellent"
      : r2 > 0.6 && slope >= 0
        ? "good"
        : r2 > 0.4
          ? "fair"
          : "needs_attention";

  return {
    slope,
    r2,
    prediction: Math.max(0, Math.min(1, prediction)),
    confidence,
    status,
  };
}

function assessOrganismHealth(organism: MockOrganism): OrganismHealth {
  const indicators: HealthIndicator[] = [];
  let totalScore = 0;
  let criticalCount = 0;
  let warningCount = 0;

  // Coherence indicator
  const coherenceStatus =
    organism.coherence >= 0.9
      ? "healthy"
      : organism.coherence >= 0.8
        ? "warning"
        : "critical";
  if (coherenceStatus === "critical") criticalCount++;
  if (coherenceStatus === "warning") warningCount++;

  indicators.push({
    name: "Coherence",
    value: organism.coherence,
    status: coherenceStatus,
    threshold: 0.85,
    recommendation:
      coherenceStatus !== "healthy"
        ? "Increase tick frequency to improve coherence"
        : undefined,
  });
  totalScore += organism.coherence;

  // FORMA Balance indicator
  const formaThreshold = 500;
  const formaScore = Math.min(1, organism.formaBalance / formaThreshold);
  const formaStatus =
    organism.formaBalance >= formaThreshold
      ? "healthy"
      : organism.formaBalance >= 200
        ? "warning"
        : "critical";
  if (formaStatus === "critical") criticalCount++;
  if (formaStatus === "warning") warningCount++;

  indicators.push({
    name: "FORMA Balance",
    value: formaScore,
    status: formaStatus,
    threshold: 1.0,
    recommendation:
      formaStatus !== "healthy"
        ? "Maintain regular activations to build FORMA"
        : undefined,
  });
  totalScore += formaScore;

  // Activation Maturity indicator
  const activationThreshold = 100;
  const activationScore = Math.min(
    1,
    organism.activationCount / activationThreshold,
  );
  const activationStatus =
    organism.activationCount >= activationThreshold
      ? "healthy"
      : organism.activationCount >= 50
        ? "warning"
        : "critical";
  if (activationStatus === "critical") criticalCount++;
  if (activationStatus === "warning") warningCount++;

  indicators.push({
    name: "Activation Maturity",
    value: activationScore,
    status: activationStatus,
    threshold: 1.0,
    recommendation:
      activationStatus !== "healthy"
        ? "Continue activating to build streak bonus"
        : undefined,
  });
  totalScore += activationScore;

  // Hz Grid Health
  const hzMean = organism.hz.reduce((a, b) => a + b, 0) / organism.hz.length;
  const hzStatus =
    hzMean >= 0.85 ? "healthy" : hzMean >= 0.78 ? "warning" : "critical";
  if (hzStatus === "critical") criticalCount++;
  if (hzStatus === "warning") warningCount++;

  indicators.push({
    name: "Hz Grid Health",
    value: hzMean,
    status: hzStatus,
    threshold: 0.85,
    recommendation:
      hzStatus !== "healthy"
        ? "Hz nodes below optimal - run more ticks"
        : undefined,
  });
  totalScore += hzMean;

  // NeuroChem Balance
  const neuroMean =
    organism.neuroChem.reduce((a, b) => a + b, 0) / organism.neuroChem.length;
  const neuroStatus =
    neuroMean >= 0.5 ? "healthy" : neuroMean >= 0.35 ? "warning" : "critical";
  if (neuroStatus === "critical") criticalCount++;
  if (neuroStatus === "warning") warningCount++;

  indicators.push({
    name: "NeuroChem Balance",
    value: neuroMean,
    status: neuroStatus,
    threshold: 0.5,
    recommendation:
      neuroStatus !== "healthy" ? "Neurochemical levels suboptimal" : undefined,
  });
  totalScore += neuroMean;

  const overallScore = (totalScore / 5) * 100;
  const status =
    criticalCount > 0
      ? "critical"
      : warningCount > 1
        ? "warning"
        : warningCount > 0
          ? "fair"
          : "healthy";

  return { overallScore, status, indicators };
}

function generateActivityEvents(organism: MockOrganism): ActivityEvent[] {
  const events: ActivityEvent[] = [];
  const now = Date.now();
  const types = ["tick", "chat", "drive_change", "milestone"];

  for (let i = 0; i < 10; i++) {
    const type = types[Math.floor(Math.random() * types.length)];
    events.push({
      id: `event-${i}`,
      type,
      details:
        type === "tick"
          ? `Shell tick #${organism.activationCount - i}`
          : type === "chat"
            ? "Workforce chat interaction"
            : type === "drive_change"
              ? `Drive mode changed to ${organism.driveMode}`
              : "Milestone reached",
      timestamp: now - i * 3600000,
    });
  }

  return events;
}

// ===================== Sub-Components =====================

interface MetricCardProps {
  title: string;
  value: string;
  metric: MetricData;
  icon: React.ElementType;
  colorClass: string;
}

function MetricCard({
  title,
  value,
  metric,
  icon: Icon,
  colorClass,
}: MetricCardProps) {
  const TrendIcon =
    metric.trend === "up"
      ? TrendingUp
      : metric.trend === "down"
        ? TrendingDown
        : Minus;

  return (
    <Card className="bg-surface border-border">
      <CardContent className="p-4">
        <div className="flex items-center justify-between mb-2">
          <div className="flex items-center gap-2">
            <Icon className={`w-4 h-4 ${colorClass}`} />
            <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
              {title}
            </span>
          </div>
          <div
            className={`flex items-center gap-1 text-[10px] ${
              metric.trend === "up"
                ? "text-emerald-400"
                : metric.trend === "down"
                  ? "text-rose-400"
                  : "text-muted-foreground/40"
            }`}
          >
            <TrendIcon className="w-3 h-3" />
            {metric.changePercent >= 0 ? "+" : ""}
            {metric.changePercent.toFixed(2)}%
          </div>
        </div>
        <div className={`text-2xl font-bold font-mono ${colorClass}`}>
          {value}
        </div>
      </CardContent>
    </Card>
  );
}

interface MiniChartProps {
  data: DataPoint[];
  color: string;
  height?: number;
}

function MiniChart({ data, color, height = 40 }: MiniChartProps) {
  if (data.length < 2) return null;

  const values = data.map((d) => d.value);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const range = max - min || 1;

  const points = data
    .map((d, i) => {
      const x = (i / (data.length - 1)) * 100;
      const y = ((d.value - min) / range) * height;
      return `${x},${height - y}`;
    })
    .join(" ");

  return (
    <svg
      className="w-full"
      height={height}
      viewBox={`0 0 100 ${height}`}
      preserveAspectRatio="none"
      aria-label="Analytics sparkline chart"
      role="img"
    >
      <polyline
        points={points}
        fill="none"
        stroke={color}
        strokeWidth="1.5"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  );
}

interface HealthIndicatorRowProps {
  indicator: HealthIndicator;
}

function HealthIndicatorRow({ indicator }: HealthIndicatorRowProps) {
  const statusColors = {
    healthy: "text-emerald-400 bg-emerald-500/10",
    warning: "text-amber-400 bg-amber-500/10",
    critical: "text-rose-400 bg-rose-500/10",
  };

  return (
    <div className="flex items-center gap-3 py-2">
      <div className="flex-1">
        <div className="flex items-center justify-between mb-1">
          <span className="text-xs text-muted-foreground">
            {indicator.name}
          </span>
          <span
            className={`text-[10px] px-1.5 py-0.5 rounded ${statusColors[indicator.status]}`}
          >
            {indicator.status.toUpperCase()}
          </span>
        </div>
        <Progress
          value={indicator.value * 100}
          className="h-1.5 bg-surface-elevated"
        />
        <div className="flex items-center justify-between mt-1">
          <span className="text-[10px] text-muted-foreground/40">
            {(indicator.value * 100).toFixed(1)}%
          </span>
          <span className="text-[10px] text-muted-foreground/40">
            Target: {(indicator.threshold * 100).toFixed(0)}%
          </span>
        </div>
      </div>
    </div>
  );
}

interface ActivityFeedProps {
  events: ActivityEvent[];
}

function ActivityFeed({ events }: ActivityFeedProps) {
  const typeIcons: Record<string, React.ElementType> = {
    tick: RefreshCw,
    chat: Activity,
    drive_change: Brain,
    milestone: Zap,
  };

  return (
    <div className="space-y-2">
      {events.map((event) => {
        const Icon = typeIcons[event.type] || Activity;
        return (
          <div
            key={event.id}
            className="flex items-start gap-3 py-2 border-b border-border/30 last:border-0"
          >
            <div className="w-6 h-6 rounded-full bg-surface-elevated flex items-center justify-center shrink-0">
              <Icon className="w-3 h-3 text-muted-foreground/60" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-xs text-foreground">{event.details}</div>
              <div className="text-[10px] text-muted-foreground/40">
                {new Date(event.timestamp).toLocaleString()}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
}

// ===================== Main Component =====================

interface AnalyticsDashboardProps {
  organism: MockOrganism;
  onBack?: () => void;
}

export function AnalyticsDashboard({ organism }: AnalyticsDashboardProps) {
  const [timeRange, setTimeRange] = useState<string>("24h");
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [activeTab, setActiveTab] = useState("overview");

  // Generate historical data for charts
  const [coherenceHistory] = useState(() =>
    generateHistoricalData(organism.coherence, 0.05, 24, 0.02),
  );
  const [formaHistory] = useState(() =>
    generateHistoricalData(organism.formaBalance / 1000, 0.1, 24, 0.05),
  );
  const [hzHistory] = useState(() =>
    generateHistoricalData(
      organism.hz.reduce((a, b) => a + b, 0) / organism.hz.length,
      0.03,
      24,
      0.01,
    ),
  );
  const [neuroHistory] = useState(() =>
    generateHistoricalData(
      organism.neuroChem.reduce((a, b) => a + b, 0) / organism.neuroChem.length,
      0.05,
      24,
      0,
    ),
  );

  // Calculate metrics
  const coherenceMetric = calculateMetricData(
    organism.coherence,
    coherenceHistory,
  );
  const formaMetric = calculateMetricData(
    organism.formaBalance,
    formaHistory.map((d) => ({ ...d, value: d.value * 1000 })),
  );
  const hzMetric = calculateMetricData(
    organism.hz.reduce((a, b) => a + b, 0) / organism.hz.length,
    hzHistory,
  );
  const neuroMetric = calculateMetricData(
    organism.neuroChem.reduce((a, b) => a + b, 0) / organism.neuroChem.length,
    neuroHistory,
  );

  // Calculate trends
  const coherenceTrend = calculateTrendAnalysis(coherenceHistory);
  const formaTrend = calculateTrendAnalysis(formaHistory);

  // Health assessment
  const health = assessOrganismHealth(organism);

  // Activity events
  const [activityEvents] = useState(() => generateActivityEvents(organism));

  // Streak calculation
  const streakBonus = Math.min(2.0, 1.0 + organism.activationCount * 0.001);
  const mintRate = organism.coherence * 2.0 * streakBonus;

  const handleRefresh = async () => {
    setIsRefreshing(true);
    await new Promise((r) => setTimeout(r, 1000));
    setIsRefreshing(false);
  };

  return (
    <div className="flex flex-col h-full bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-6 py-4 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <BarChart3 className="w-5 h-5 text-primary" />
          <div>
            <h1 className="text-lg font-bold text-foreground">
              Analytics Dashboard
            </h1>
            <p className="text-xs text-muted-foreground">
              {organism.name} · {organism.class} · Genesis:{" "}
              {organism.genesisHash.slice(0, 8)}...
            </p>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Time range selector */}
          <div className="flex items-center gap-1 bg-surface rounded-lg p-1">
            {TIME_RANGES.map((range) => (
              <button
                key={range.value}
                type="button"
                onClick={() => setTimeRange(range.value)}
                className={`px-2 py-1 text-[10px] font-semibold rounded transition-colors ${
                  timeRange === range.value
                    ? "bg-primary text-primary-foreground"
                    : "text-muted-foreground hover:text-foreground"
                }`}
              >
                {range.label}
              </button>
            ))}
          </div>

          <Button
            variant="outline"
            size="sm"
            onClick={handleRefresh}
            disabled={isRefreshing}
            className="h-8"
          >
            <RefreshCw
              className={`w-3 h-3 mr-1 ${isRefreshing ? "animate-spin" : ""}`}
            />
            Refresh
          </Button>

          <Button variant="outline" size="sm" className="h-8">
            <Download className="w-3 h-3 mr-1" />
            Export
          </Button>
        </div>
      </div>

      <ScrollArea className="flex-1">
        <div className="p-6 space-y-6">
          {/* Key Metrics Grid */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <MetricCard
              title="Coherence"
              value={`${(organism.coherence * 100).toFixed(2)}%`}
              metric={coherenceMetric}
              icon={Activity}
              colorClass="text-primary"
            />
            <MetricCard
              title="FORMA Balance"
              value={organism.formaBalance.toFixed(2)}
              metric={formaMetric}
              icon={Database}
              colorClass="text-amber-400"
            />
            <MetricCard
              title="Hz Mean"
              value={`${(hzMetric.current * 100).toFixed(2)}%`}
              metric={hzMetric}
              icon={Brain}
              colorClass="text-cyan-400"
            />
            <MetricCard
              title="NeuroChem"
              value={`${(neuroMetric.current * 100).toFixed(2)}%`}
              metric={neuroMetric}
              icon={Heart}
              colorClass="text-rose-400"
            />
          </div>

          {/* Tabs for different views */}
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="bg-surface border border-border">
              <TabsTrigger value="overview" className="text-xs">
                Overview
              </TabsTrigger>
              <TabsTrigger value="trends" className="text-xs">
                Trends
              </TabsTrigger>
              <TabsTrigger value="health" className="text-xs">
                Health
              </TabsTrigger>
              <TabsTrigger value="activity" className="text-xs">
                Activity
              </TabsTrigger>
            </TabsList>

            {/* Overview Tab */}
            <TabsContent value="overview" className="mt-4 space-y-4">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                {/* Coherence Chart */}
                <Card className="bg-surface border-border">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm flex items-center justify-between">
                      <span className="flex items-center gap-2">
                        <Activity className="w-4 h-4 text-primary" />
                        Coherence History
                      </span>
                      <span className="text-xs font-normal text-muted-foreground">
                        {timeRange.toUpperCase()}
                      </span>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="h-32 mb-2">
                      <MiniChart
                        data={coherenceHistory}
                        color="oklch(62% 0.145 165)"
                        height={128}
                      />
                    </div>
                    <div className="flex items-center justify-between text-[10px] text-muted-foreground/40">
                      <span>{coherenceHistory[0]?.label}</span>
                      <span>
                        {coherenceHistory[coherenceHistory.length - 1]?.label}
                      </span>
                    </div>
                  </CardContent>
                </Card>

                {/* FORMA Chart */}
                <Card className="bg-surface border-border">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm flex items-center justify-between">
                      <span className="flex items-center gap-2">
                        <Database className="w-4 h-4 text-amber-400" />
                        FORMA Accumulation
                      </span>
                      <span className="text-xs font-normal text-muted-foreground">
                        {timeRange.toUpperCase()}
                      </span>
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="h-32 mb-2">
                      <MiniChart
                        data={formaHistory}
                        color="oklch(75% 0.15 85)"
                        height={128}
                      />
                    </div>
                    <div className="flex items-center justify-between text-[10px] text-muted-foreground/40">
                      <span>{formaHistory[0]?.label}</span>
                      <span>
                        {formaHistory[formaHistory.length - 1]?.label}
                      </span>
                    </div>
                  </CardContent>
                </Card>
              </div>

              {/* Stats Grid */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <Card className="bg-surface border-border">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <Zap className="w-4 h-4 text-purple-400" />
                      <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
                        Activations
                      </span>
                    </div>
                    <div className="text-xl font-bold font-mono text-foreground">
                      {organism.activationCount}
                    </div>
                    <div className="text-[10px] text-muted-foreground/40 mt-1">
                      Streak: {streakBonus.toFixed(3)}x
                    </div>
                  </CardContent>
                </Card>

                <Card className="bg-surface border-border">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <TrendingUp className="w-4 h-4 text-emerald-400" />
                      <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
                        Mint Rate
                      </span>
                    </div>
                    <div className="text-xl font-bold font-mono text-emerald-400">
                      +{mintRate.toFixed(4)}
                    </div>
                    <div className="text-[10px] text-muted-foreground/40 mt-1">
                      FORMA per tick
                    </div>
                  </CardContent>
                </Card>

                <Card className="bg-surface border-border">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <Brain className="w-4 h-4 text-blue-400" />
                      <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
                        Drive Mode
                      </span>
                    </div>
                    <div
                      className={`text-xl font-bold ${
                        organism.driveMode === "Execution"
                          ? "text-primary"
                          : organism.driveMode === "Exploration"
                            ? "text-amber-400"
                            : organism.driveMode === "Learning"
                              ? "text-blue-400"
                              : "text-slate-400"
                      }`}
                    >
                      {organism.driveMode}
                    </div>
                    <div className="text-[10px] text-muted-foreground/40 mt-1">
                      Based on coherence
                    </div>
                  </CardContent>
                </Card>

                <Card className="bg-surface border-border">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-2 mb-2">
                      <Heart className="w-4 h-4 text-rose-400" />
                      <span className="text-[10px] uppercase tracking-widest text-muted-foreground/60">
                        Health Score
                      </span>
                    </div>
                    <div
                      className={`text-xl font-bold font-mono ${
                        health.status === "healthy"
                          ? "text-emerald-400"
                          : health.status === "fair"
                            ? "text-amber-400"
                            : "text-rose-400"
                      }`}
                    >
                      {health.overallScore.toFixed(1)}%
                    </div>
                    <div className="text-[10px] text-muted-foreground/40 mt-1">
                      {health.status.toUpperCase()}
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            {/* Trends Tab */}
            <TabsContent value="trends" className="mt-4 space-y-4">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                {/* Coherence Trend Analysis */}
                <Card className="bg-surface border-border">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm">
                      Coherence Trend Analysis
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Slope
                        </div>
                        <div
                          className={`text-lg font-bold font-mono ${
                            coherenceTrend.slope > 0
                              ? "text-emerald-400"
                              : "text-rose-400"
                          }`}
                        >
                          {coherenceTrend.slope > 0 ? "+" : ""}
                          {(coherenceTrend.slope * 1000).toFixed(4)}
                        </div>
                      </div>
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          R² Score
                        </div>
                        <div className="text-lg font-bold font-mono text-foreground">
                          {coherenceTrend.r2.toFixed(4)}
                        </div>
                      </div>
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Prediction
                        </div>
                        <div className="text-lg font-bold font-mono text-primary">
                          {(coherenceTrend.prediction * 100).toFixed(2)}%
                        </div>
                      </div>
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Confidence
                        </div>
                        <div className="text-lg font-bold font-mono text-foreground">
                          {(coherenceTrend.confidence * 100).toFixed(1)}%
                        </div>
                      </div>
                    </div>

                    <div
                      className={`p-3 rounded-lg ${
                        coherenceTrend.status === "excellent"
                          ? "bg-emerald-500/10 border border-emerald-500/30"
                          : coherenceTrend.status === "good"
                            ? "bg-blue-500/10 border border-blue-500/30"
                            : coherenceTrend.status === "fair"
                              ? "bg-amber-500/10 border border-amber-500/30"
                              : "bg-rose-500/10 border border-rose-500/30"
                      }`}
                    >
                      <div
                        className={`text-xs font-semibold ${
                          coherenceTrend.status === "excellent"
                            ? "text-emerald-400"
                            : coherenceTrend.status === "good"
                              ? "text-blue-400"
                              : coherenceTrend.status === "fair"
                                ? "text-amber-400"
                                : "text-rose-400"
                        }`}
                      >
                        {coherenceTrend.status.toUpperCase().replace("_", " ")}
                      </div>
                      <div className="text-[10px] text-muted-foreground mt-1">
                        {coherenceTrend.status === "excellent"
                          ? "Coherence is trending strongly upward with high correlation"
                          : coherenceTrend.status === "good"
                            ? "Coherence is stable or improving"
                            : coherenceTrend.status === "fair"
                              ? "Coherence trend is uncertain - monitor closely"
                              : "Coherence needs attention - consider increasing tick frequency"}
                      </div>
                    </div>
                  </CardContent>
                </Card>

                {/* FORMA Trend Analysis */}
                <Card className="bg-surface border-border">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm">
                      FORMA Accumulation Trend
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Growth Rate
                        </div>
                        <div
                          className={`text-lg font-bold font-mono ${
                            formaTrend.slope > 0
                              ? "text-emerald-400"
                              : "text-rose-400"
                          }`}
                        >
                          {formaTrend.slope > 0 ? "+" : ""}
                          {(formaTrend.slope * 100).toFixed(2)}%
                        </div>
                      </div>
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Consistency
                        </div>
                        <div className="text-lg font-bold font-mono text-foreground">
                          {(formaTrend.r2 * 100).toFixed(1)}%
                        </div>
                      </div>
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Est. 24H Gain
                        </div>
                        <div className="text-lg font-bold font-mono text-amber-400">
                          +{(mintRate * 24 * 20).toFixed(2)}
                        </div>
                      </div>
                      <div>
                        <div className="text-[10px] uppercase tracking-widest text-muted-foreground/60 mb-1">
                          Est. 7D Gain
                        </div>
                        <div className="text-lg font-bold font-mono text-amber-400">
                          +{(mintRate * 24 * 20 * 7).toFixed(2)}
                        </div>
                      </div>
                    </div>

                    <div className="p-3 rounded-lg bg-amber-500/10 border border-amber-500/30">
                      <div className="text-xs font-semibold text-amber-400">
                        FORMA ECONOMY
                      </div>
                      <div className="text-[10px] text-muted-foreground mt-1">
                        Current mint rate: {mintRate.toFixed(4)}/tick · Streak
                        bonus: {streakBonus.toFixed(3)}x · Projected balance
                        (30d):{" "}
                        {(
                          organism.formaBalance +
                          mintRate * 24 * 20 * 30
                        ).toFixed(2)}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </TabsContent>

            {/* Health Tab */}
            <TabsContent value="health" className="mt-4 space-y-4">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
                {/* Overall Health Score */}
                <Card className="bg-surface border-border lg:col-span-1">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm">Overall Health</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="flex flex-col items-center py-4">
                      <div
                        className={`text-5xl font-bold font-mono ${
                          health.status === "healthy"
                            ? "text-emerald-400"
                            : health.status === "fair"
                              ? "text-amber-400"
                              : health.status === "warning"
                                ? "text-amber-400"
                                : "text-rose-400"
                        }`}
                      >
                        {health.overallScore.toFixed(0)}
                      </div>
                      <div className="text-sm text-muted-foreground mt-1">
                        out of 100
                      </div>
                      <div
                        className={`mt-3 px-3 py-1 rounded-full text-xs font-semibold ${
                          health.status === "healthy"
                            ? "bg-emerald-500/10 text-emerald-400"
                            : health.status === "fair"
                              ? "bg-amber-500/10 text-amber-400"
                              : health.status === "warning"
                                ? "bg-amber-500/10 text-amber-400"
                                : "bg-rose-500/10 text-rose-400"
                        }`}
                      >
                        {health.status.toUpperCase()}
                      </div>
                    </div>
                  </CardContent>
                </Card>

                {/* Health Indicators */}
                <Card className="bg-surface border-border lg:col-span-2">
                  <CardHeader className="pb-2">
                    <CardTitle className="text-sm">Health Indicators</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-1">
                      {health.indicators.map((indicator) => (
                        <HealthIndicatorRow
                          key={indicator.name}
                          indicator={indicator}
                        />
                      ))}
                    </div>
                  </CardContent>
                </Card>
              </div>

              {/* Recommendations */}
              <Card className="bg-surface border-border">
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm">Recommendations</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    {health.indicators
                      .filter((i) => i.recommendation)
                      .map((indicator) => (
                        <div
                          key={indicator.name}
                          className={`p-3 rounded-lg border ${
                            indicator.status === "critical"
                              ? "bg-rose-500/5 border-rose-500/30"
                              : "bg-amber-500/5 border-amber-500/30"
                          }`}
                        >
                          <div className="flex items-start gap-2">
                            <div
                              className={`w-1.5 h-1.5 rounded-full mt-1.5 ${
                                indicator.status === "critical"
                                  ? "bg-rose-400"
                                  : "bg-amber-400"
                              }`}
                            />
                            <div>
                              <div className="text-xs font-medium text-foreground">
                                {indicator.name}
                              </div>
                              <div className="text-[10px] text-muted-foreground mt-0.5">
                                {indicator.recommendation}
                              </div>
                            </div>
                          </div>
                        </div>
                      ))}
                    {health.indicators.filter((i) => i.recommendation)
                      .length === 0 && (
                      <div className="p-3 rounded-lg bg-emerald-500/5 border border-emerald-500/30">
                        <div className="flex items-center gap-2">
                          <div className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                          <div className="text-xs text-emerald-400">
                            All health indicators are optimal. No
                            recommendations at this time.
                          </div>
                        </div>
                      </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            </TabsContent>

            {/* Activity Tab */}
            <TabsContent value="activity" className="mt-4 space-y-4">
              <Card className="bg-surface border-border">
                <CardHeader className="pb-2">
                  <CardTitle className="text-sm flex items-center justify-between">
                    <span>Recent Activity</span>
                    <span className="text-xs font-normal text-muted-foreground">
                      Last {activityEvents.length} events
                    </span>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <ActivityFeed events={activityEvents} />
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </ScrollArea>
    </div>
  );
}
