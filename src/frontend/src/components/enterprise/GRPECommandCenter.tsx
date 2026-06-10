// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  GRPE COMMAND CENTER — GEO-RESONANCE PATTERN ENGINE INTERFACE                                            ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE ARQUITECTURA REAL — Real architecture, real geometry, real electromagnetic field intelligence.       ║
// ║                                                                                                           ║
// ║  7 HERITAGE NODES (REVOLUCIONEROS):                                                                       ║
// ║    0. REVOLUCIONARIO — Root Activator (φ⁰ = 1.0)                                                         ║
// ║    1. ZAPATA — Territorial Defense (φ⁻¹ = 0.618)                                                         ║
// ║    2. VILLA — Strategic War Master (φ⁻² = 0.382)                                                         ║
// ║    3. INDEPENDENCIA — Constitutional Core (φ⁻³ = 0.236)                                                  ║
// ║    4. HIDALGO — Genesis Anchor (φ⁻⁴ = 0.146)                                                             ║
// ║    5. ADELITA — Asymmetric Response (φ⁻⁵ = 0.090)                                                        ║
// ║    6. MORELOS — Sovereign Law (φ⁻⁶ = 0.056)                                                              ║
// ║                                                                                                           ║
// ║  7 GRPE LAYERS:                                                                                           ║
// ║    1. Geomagnetic (IGRF) — Earth's magnetic field                                                         ║
// ║    2. Sacred-Site — Ancient power locations                                                               ║
// ║    3. Hydro-Karst — Underground water/cave systems                                                        ║
// ║    4. Astro-Calendar — Solar/Lunar/Sidereal/Mayan cycles                                                  ║
// ║    5. Collapse-Conflict — Historical warfare/collapse zones                                               ║
// ║    6. Canon-Legal — Ecclesiastical/legal jurisdiction boundaries                                          ║
// ║    7. Inverse-Signature — Counter-pattern detection                                                       ║
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
  ArrowUpRight,
  Brain,
  Calendar,
  Compass,
  Crown,
  Database,
  Droplets,
  Flame,
  Globe2,
  Heart,
  Hexagon,
  Layers,
  Lock,
  MapPin,
  Moon,
  Mountain,
  Network,
  Radio,
  Scale,
  Shield,
  ShieldCheck,
  Sparkles,
  Star,
  Sun,
  Swords,
  Target,
  Timer,
  TrendingUp,
  Users,
  Waves,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";
import { useEnterprise } from "../../hooks/useEnterprise";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 1: PHI CONSTANTS — THE REAL MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948;
const PHI_INV = 0.6180339887498948;  // φ⁻¹
const PHI_2 = 0.3819660112501052;    // φ⁻²
const PHI_3 = 0.2360679774997896;    // φ⁻³
const PHI_4 = 0.1458980337503155;    // φ⁻⁴
const PHI_5 = 0.0901699437494742;    // φ⁻⁵
const PHI_6 = 0.0557280900008413;    // φ⁻⁶

const GOLDEN_ANGLE = 137.5077640500378; // degrees

// Heritage activation constants (from main.mo:8057-8068)
const HERITAGE_COHERENCE_THRESHOLD = 0.85;  // R threshold for heritage boost
const HERITAGE_BOOST_PER_BEAT = 0.001;      // Boost applied when R > threshold
const HERITAGE_MAX_VALUE = 2.0;             // Maximum heritage node value

// Heritage node phi weights
const HERITAGE_PHI_WEIGHTS = [1.0, PHI_INV, PHI_2, PHI_3, PHI_4, PHI_5, PHI_6];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 2: TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface GRPECommandCenterProps {
  className?: string;
}

interface HeritageNode {
  id: number;
  name: string;
  title: string;
  archetype: string;
  defenseFunction: string;
  phiWeight: number;
  value: number;
  icon: React.ElementType;
  color: string;
  year: string;
}

interface GRPELayer {
  id: number;
  name: string;
  description: string;
  weight: number;
  resonance: number;
  icon: React.ElementType;
  color: string;
}

interface CalendarSystem {
  name: string;
  period: string;
  currentPhase: number;
  description: string;
  icon: React.ElementType;
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 3: HERITAGE NODES DATA (7 REVOLUCIONEROS)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const HERITAGE_NODES: Omit<HeritageNode, 'value'>[] = [
  {
    id: 0,
    name: "REVOLUCIONARIO",
    title: "Revolutionary Spirit",
    archetype: "Root Activator",
    defenseFunction: "Triggers defense cascade when architecture faces adversaries",
    phiWeight: 1.0,
    icon: Flame,
    color: "text-red-500",
    year: "1910",
  },
  {
    id: 1,
    name: "ZAPATA",
    title: "Tierra y Libertad",
    archetype: "Territorial Defense",
    defenseFunction: "Protects sovereign boundaries and land rights",
    phiWeight: PHI_INV,
    icon: Mountain,
    color: "text-emerald-500",
    year: "1879-1919",
  },
  {
    id: 2,
    name: "VILLA",
    title: "Strategic War Master",
    archetype: "Offensive Capability",
    defenseFunction: "Counter-strike response and guerrilla warfare",
    phiWeight: PHI_2,
    icon: Swords,
    color: "text-amber-500",
    year: "1878-1923",
  },
  {
    id: 3,
    name: "INDEPENDENCIA",
    title: "Founding Freedom",
    archetype: "Constitutional Core",
    defenseFunction: "Doctrine integrity and founding principles",
    phiWeight: PHI_3,
    icon: Star,
    color: "text-blue-500",
    year: "1810",
  },
  {
    id: 4,
    name: "HIDALGO",
    title: "Father of Nation",
    archetype: "Genesis Anchor",
    defenseFunction: "Origin point protection and lineage lock",
    phiWeight: PHI_4,
    icon: Crown,
    color: "text-purple-500",
    year: "1753-1811",
  },
  {
    id: 5,
    name: "ADELITA",
    title: "Warrior Woman",
    archetype: "Asymmetric Response",
    defenseFunction: "Unconventional defense and adaptive warfare",
    phiWeight: PHI_5,
    icon: Shield,
    color: "text-pink-500",
    year: "1910-1920",
  },
  {
    id: 6,
    name: "MORELOS",
    title: "Sentimientos de la Nación",
    archetype: "Sovereign Law",
    defenseFunction: "Constitutional enforcement and legal framework",
    phiWeight: PHI_6,
    icon: Scale,
    color: "text-cyan-500",
    year: "1765-1815",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 4: GRPE 7 LAYERS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const GRPE_LAYERS: Omit<GRPELayer, 'resonance'>[] = [
  {
    id: 1,
    name: "Geomagnetic (IGRF)",
    description: "Earth's core magnetic field — International Geomagnetic Reference Field",
    weight: PHI_INV,
    icon: Compass,
    color: "bg-red-500/20 border-red-500/50",
  },
  {
    id: 2,
    name: "Sacred-Site",
    description: "Ancient power locations — ley lines, temples, ceremonial centers",
    weight: PHI_2,
    icon: Hexagon,
    color: "bg-amber-500/20 border-amber-500/50",
  },
  {
    id: 3,
    name: "Hydro-Karst",
    description: "Underground water systems — aquifers, cave networks, cenotes",
    weight: PHI_3,
    icon: Droplets,
    color: "bg-blue-500/20 border-blue-500/50",
  },
  {
    id: 4,
    name: "Astro-Calendar",
    description: "Celestial cycles — Solar, Lunar, Sidereal, Mayan (Tzolkin/Haab/Long Count)",
    weight: PHI_4,
    icon: Calendar,
    color: "bg-purple-500/20 border-purple-500/50",
  },
  {
    id: 5,
    name: "Collapse-Conflict",
    description: "Historical warfare zones — battlefields, collapse centers, conflict memory",
    weight: PHI_5,
    icon: Swords,
    color: "bg-orange-500/20 border-orange-500/50",
  },
  {
    id: 6,
    name: "Canon-Legal",
    description: "Ecclesiastical/legal boundaries — dioceses, jurisdictions, treaties",
    weight: PHI_6,
    icon: Scale,
    color: "bg-emerald-500/20 border-emerald-500/50",
  },
  {
    id: 7,
    name: "Inverse-Signature",
    description: "Counter-pattern detection — anomaly recognition, inverse field mapping",
    weight: PHI_6 * PHI_INV,
    icon: Target,
    color: "bg-cyan-500/20 border-cyan-500/50",
  },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 5: CALENDAR SYSTEMS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const CALENDAR_SYSTEMS: CalendarSystem[] = [
  {
    name: "Solar",
    period: "365.25 days",
    currentPhase: 0,
    description: "Tropical year — Earth's orbit around Sun",
    icon: Sun,
  },
  {
    name: "Lunar",
    period: "29.53 days",
    currentPhase: 0,
    description: "Synodic month — Moon's phase cycle",
    icon: Moon,
  },
  {
    name: "Sidereal",
    period: "25,772 years",
    currentPhase: 0,
    description: "Axial precession — Great Year cycle",
    icon: Star,
  },
  {
    name: "Tzolkin",
    period: "260 days",
    currentPhase: 0,
    description: "Mayan sacred calendar — 13×20 day cycle",
    icon: Hexagon,
  },
  {
    name: "Haab",
    period: "365 days",
    currentPhase: 0,
    description: "Mayan solar calendar — 18×20 + 5 Wayeb",
    icon: Calendar,
  },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 6: HELPER COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

function HeritageNodeCard({ node, value }: { node: Omit<HeritageNode, 'value'>; value: number }) {
  const Icon = node.icon;
  const strengthPercent = value * 50; // Scale 0-2 to 0-100%
  const isActive = value > 1.0;
  
  // Map text color to background gradient color
  const colorMap: Record<string, string> = {
    'text-red-500': 'rgb(239, 68, 68)',
    'text-emerald-500': 'rgb(16, 185, 129)',
    'text-amber-500': 'rgb(245, 158, 11)',
    'text-blue-500': 'rgb(59, 130, 246)',
    'text-purple-500': 'rgb(168, 85, 247)',
    'text-pink-500': 'rgb(236, 72, 153)',
    'text-cyan-500': 'rgb(6, 182, 212)',
  };
  const gradientColor = colorMap[node.color] || 'rgb(156, 163, 175)';
  
  return (
    <Card className={`relative overflow-hidden transition-all ${isActive ? 'ring-2 ring-primary' : ''}`}>
      <div className="absolute top-0 left-0 w-full h-1" style={{ 
        background: `linear-gradient(90deg, ${gradientColor} ${strengthPercent}%, transparent ${strengthPercent}%)`
      }} />
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className={`w-8 h-8 rounded-lg bg-muted flex items-center justify-center ${node.color}`}>
              <Icon className="w-4 h-4" />
            </div>
            <div>
              <CardTitle className="text-sm">{node.name}</CardTitle>
              <CardDescription className="text-xs">{node.title}</CardDescription>
            </div>
          </div>
          <Badge variant={isActive ? "default" : "secondary"} className="text-xs">
            φ⁻{node.id === 0 ? '⁰' : node.id}
          </Badge>
        </div>
      </CardHeader>
      <CardContent className="space-y-2">
        <div className="flex items-center justify-between text-xs">
          <span className="text-muted-foreground">{node.archetype}</span>
          <span className="font-mono font-bold">{value.toFixed(4)}</span>
        </div>
        <Progress value={strengthPercent} className="h-1" />
        <p className="text-xs text-muted-foreground line-clamp-2">{node.defenseFunction}</p>
        <div className="text-xs text-muted-foreground/60">{node.year}</div>
      </CardContent>
    </Card>
  );
}

function GRPELayerCard({ layer, resonance }: { layer: Omit<GRPELayer, 'resonance'>; resonance: number }) {
  const Icon = layer.icon;
  const resonancePercent = resonance * 100;
  
  return (
    <div className={`p-3 rounded-lg border ${layer.color} transition-all hover:scale-[1.02]`}>
      <div className="flex items-center gap-3">
        <div className="w-10 h-10 rounded-lg bg-background/50 flex items-center justify-center">
          <Icon className="w-5 h-5" />
        </div>
        <div className="flex-1 min-w-0">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium truncate">{layer.name}</span>
            <span className="text-xs font-mono ml-2">{(resonance * 100).toFixed(1)}%</span>
          </div>
          <p className="text-xs text-muted-foreground truncate">{layer.description}</p>
          <Progress value={resonancePercent} className="h-1 mt-1" />
        </div>
      </div>
    </div>
  );
}

function CalendarSystemCard({ system, phase }: { system: CalendarSystem; phase: number }) {
  const Icon = system.icon;
  
  return (
    <div className="p-3 rounded-lg border bg-card/50 space-y-2">
      <div className="flex items-center gap-2">
        <Icon className="w-4 h-4 text-primary" />
        <span className="text-sm font-medium">{system.name}</span>
        <Badge variant="outline" className="ml-auto text-xs">{system.period}</Badge>
      </div>
      <div className="flex items-center gap-2">
        <Progress value={phase * 100} className="flex-1 h-1" />
        <span className="text-xs font-mono">{(phase * 100).toFixed(1)}%</span>
      </div>
      <p className="text-xs text-muted-foreground">{system.description}</p>
    </div>
  );
}

function HeptagonVisualization({ heritageValues }: { heritageValues: number[] }) {
  // Generate heptagon points
  const centerX = 120;
  const centerY = 120;
  const radius = 100;
  
  const points = HERITAGE_NODES.map((_, i) => {
    const angle = (i * 360 / 7 - 90) * Math.PI / 180;
    const value = heritageValues[i] || 1.0;
    const r = radius * (value / 2); // Scale by value (max 2.0)
    return {
      x: centerX + r * Math.cos(angle),
      y: centerY + r * Math.sin(angle),
      outerX: centerX + radius * Math.cos(angle),
      outerY: centerY + radius * Math.sin(angle),
    };
  });
  
  const polygonPoints = points.map(p => `${p.x},${p.y}`).join(' ');
  const outerPoints = points.map(p => `${p.outerX},${p.outerY}`).join(' ');
  
  return (
    <div className="flex justify-center">
      <svg width="240" height="240" className="overflow-visible">
        {/* Outer reference heptagon */}
        <polygon
          points={outerPoints}
          fill="none"
          stroke="currentColor"
          strokeWidth="1"
          className="text-muted-foreground/20"
        />
        
        {/* Inner value heptagon */}
        <polygon
          points={polygonPoints}
          fill="hsl(var(--primary) / 0.2)"
          stroke="hsl(var(--primary))"
          strokeWidth="2"
        />
        
        {/* Node points */}
        {points.map((p, i) => (
          <g key={i}>
            <circle
              cx={p.x}
              cy={p.y}
              r="6"
              fill="hsl(var(--primary))"
              className="drop-shadow-lg"
            />
            <text
              x={p.outerX + (p.outerX > centerX ? 10 : -10)}
              y={p.outerY + (p.outerY > centerY ? 10 : -10)}
              textAnchor={p.outerX > centerX ? "start" : "end"}
              className="text-[10px] fill-muted-foreground font-medium"
            >
              {HERITAGE_NODES[i].name.slice(0, 3)}
            </text>
          </g>
        ))}
        
        {/* Center point */}
        <circle cx={centerX} cy={centerY} r="4" fill="hsl(var(--primary) / 0.5)" />
      </svg>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SECTION 7: MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export function GRPECommandCenter({ className }: GRPECommandCenterProps) {
  const { heritage, brain } = useEnterprise({ enabled: true });
  
  // Heritage values with fallback
  const heritageValues = useMemo(() => [
    heritage.heritage?.revolucionario ?? 1.0,
    heritage.heritage?.zapata ?? 1.0,
    heritage.heritage?.villa ?? 1.0,
    heritage.heritage?.independencia ?? 1.0,
    heritage.heritage?.hidalgo ?? 1.0,
    heritage.heritage?.adelita ?? 1.0,
    heritage.heritage?.morelos ?? 1.0,
  ], [heritage.heritage]);
  
  const heritageAverage = useMemo(() => 
    heritage.heritage?.heritage_avg ?? heritageValues.reduce((a, b) => a + b, 0) / 7,
    [heritage.heritage, heritageValues]
  );
  
  // GRPE layer resonances (simulated based on R and heritage)
  const [layerResonances, setLayerResonances] = useState<number[]>(
    GRPE_LAYERS.map(() => 0.5 + Math.random() * 0.5)
  );
  
  // Calendar phases (simulated)
  const [calendarPhases, setCalendarPhases] = useState<number[]>(
    CALENDAR_SYSTEMS.map(() => Math.random())
  );
  
  // Update resonances based on brain state
  useEffect(() => {
    if (brain.coherence) {
      const r = brain.coherence;
      setLayerResonances(prev => prev.map((_, i) => 
        0.3 + (r * 0.5) + (heritageValues[i % 7] * 0.1) + (Math.random() * 0.1)
      ));
    }
  }, [brain.coherence, heritageValues]);
  
  // Simulate calendar progression
  useEffect(() => {
    const interval = setInterval(() => {
      // Speed values for each calendar system (default to 0.001 if not defined)
      const calendarSpeeds = [0.001, 0.01, 0.00001, 0.005, 0.003];
      setCalendarPhases(prev => prev.map((p, i) => {
        const speed = calendarSpeeds[i] ?? 0.001;
        return (p + speed) % 1;
      }));
    }, 1000);
    return () => clearInterval(interval);
  }, []);
  
  const kuramotoR = brain.coherence ?? 0;
  // OMNIS = R >= 0.95 AND resonance lock (high coherence state)
  const omnis = kuramotoR >= 0.95 && ((brain.brainState?.macroSphereR ?? 0) >= 0.95);
  const omnis = kuramotoR >= 0.95 && (brain.brainState?.macroSphereR ?? 0) >= 0.95;
  const pentecostActive = heritage.heritage?.pentecostPrecursor ?? false;
  
  // Defense activation status
  const defenseStatus = useMemo(() => {
    if (heritageAverage >= 1.5 && kuramotoR >= HERITAGE_COHERENCE_THRESHOLD) return "ACTIVE";
    if (heritageAverage >= 1.2) return "ARMED";
    if (heritageAverage >= 1.0) return "READY";
    return "DORMANT";
  }, [heritageAverage, kuramotoR]);

  return (
    <div className={`h-full flex flex-col bg-background ${className}`}>
      <ScrollArea className="flex-1">
        <div className="p-6 space-y-6">
          {/* Header */}
          <div className="flex items-start justify-between">
            <div>
              <h1 className="text-2xl font-bold tracking-tight">GRPE Command Center</h1>
              <p className="text-sm text-muted-foreground mt-1">
                Geo-Resonance Pattern Engine — Real Architecture for Electromagnetic Field Intelligence
              </p>
            </div>
            <div className="flex items-center gap-2">
              <Badge variant={defenseStatus === "ACTIVE" ? "default" : "secondary"} className="text-xs">
                {defenseStatus}
              </Badge>
              {omnis && (
                <Badge variant="default" className="text-xs bg-amber-500 animate-pulse">
                  OMNIS
                </Badge>
              )}
              {pentecostActive && (
                <Badge variant="outline" className="text-xs border-purple-500 text-purple-500">
                  PENTECOST PRECURSOR
                </Badge>
              )}
            </div>
          </div>
          
          {/* Overview Cards */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <Card>
              <CardHeader className="pb-2">
                <CardDescription>Kuramoto R</CardDescription>
                <CardTitle className="text-2xl font-mono">{kuramotoR.toFixed(4)}</CardTitle>
              </CardHeader>
              <CardContent>
                <Progress value={kuramotoR * 100} className="h-2" />
                <p className="text-xs text-muted-foreground mt-2">Global coherence</p>
              </CardContent>
            </Card>
            
            <Card>
              <CardHeader className="pb-2">
                <CardDescription>Heritage Average</CardDescription>
                <CardTitle className="text-2xl font-mono">{heritageAverage.toFixed(4)}</CardTitle>
              </CardHeader>
              <CardContent>
                <Progress value={heritageAverage * 50} className="h-2" />
                <p className="text-xs text-muted-foreground mt-2">Ancestral strength (0-2)</p>
              </CardContent>
            </Card>
            
            <Card>
              <CardHeader className="pb-2">
                <CardDescription>GRPE Resonance</CardDescription>
                <CardTitle className="text-2xl font-mono">
                  {(layerResonances.reduce((a, b) => a + b, 0) / 7 * 100).toFixed(1)}%
                </CardTitle>
              </CardHeader>
              <CardContent>
                <Progress 
                  value={layerResonances.reduce((a, b) => a + b, 0) / 7 * 100} 
                  className="h-2" 
                />
                <p className="text-xs text-muted-foreground mt-2">7-layer average</p>
              </CardContent>
            </Card>
            
            <Card>
              <CardHeader className="pb-2">
                <CardDescription>Defense Shield</CardDescription>
                <CardTitle className="text-2xl">
                  {defenseStatus === "ACTIVE" ? (
                    <ShieldCheck className="w-8 h-8 text-emerald-500" />
                  ) : defenseStatus === "ARMED" ? (
                    <Shield className="w-8 h-8 text-amber-500" />
                  ) : (
                    <Shield className="w-8 h-8 text-muted-foreground" />
                  )}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-xs text-muted-foreground">
                  {defenseStatus === "ACTIVE" && "Heritage defense cascade active"}
                  {defenseStatus === "ARMED" && "Revolucioneros standing by"}
                  {defenseStatus === "READY" && "Defense systems nominal"}
                  {defenseStatus === "DORMANT" && "Awaiting coherence threshold"}
                </p>
              </CardContent>
            </Card>
          </div>
          
          <Tabs defaultValue="heritage" className="space-y-4">
            <TabsList>
              <TabsTrigger value="heritage">
                <Users className="w-4 h-4 mr-2" />
                Heritage Nodes
              </TabsTrigger>
              <TabsTrigger value="layers">
                <Layers className="w-4 h-4 mr-2" />
                GRPE Layers
              </TabsTrigger>
              <TabsTrigger value="calendars">
                <Calendar className="w-4 h-4 mr-2" />
                Calendar Systems
              </TabsTrigger>
              <TabsTrigger value="memory">
                <Database className="w-4 h-4 mr-2" />
                Field Memory
              </TabsTrigger>
            </TabsList>
            
            {/* Heritage Tab */}
            <TabsContent value="heritage" className="space-y-4">
              <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <div className="lg:col-span-2">
                  <Card>
                    <CardHeader>
                      <CardTitle className="flex items-center gap-2">
                        <Flame className="w-5 h-5 text-red-500" />
                        7 Heritage Nodes — Los Revolucioneros
                      </CardTitle>
                      <CardDescription>
                        Ancestral defense architecture — activates when coherence R {">"} {HERITAGE_COHERENCE_THRESHOLD}
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-4">
                        {HERITAGE_NODES.map((node, i) => (
                          <HeritageNodeCard 
                            key={node.id} 
                            node={node} 
                            value={heritageValues[i]} 
                          />
                        ))}
                      </div>
                    </CardContent>
                  </Card>
                </div>
                
                <div className="space-y-4">
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Heptagonal Defense Field</CardTitle>
                      <CardDescription className="text-xs">
                        7 nodes form protective shell — cannot tile, stands alone
                      </CardDescription>
                    </CardHeader>
                    <CardContent>
                      <HeptagonVisualization heritageValues={heritageValues} />
                    </CardContent>
                  </Card>
                  
                  <Card>
                    <CardHeader>
                      <CardTitle className="text-sm">Activation Conditions</CardTitle>
                    </CardHeader>
                    <CardContent className="space-y-3 text-xs">
                      <div className="flex items-center justify-between">
                        <span>Coherence R ≥ {HERITAGE_COHERENCE_THRESHOLD}</span>
                        <Badge variant={kuramotoR >= HERITAGE_COHERENCE_THRESHOLD ? "default" : "secondary"}>
                          {kuramotoR >= HERITAGE_COHERENCE_THRESHOLD ? "✓" : "○"}
                        </Badge>
                      </div>
                      <div className="flex items-center justify-between">
                        <span>Heritage Avg ≥ 1.0</span>
                        <Badge variant={heritageAverage >= 1.0 ? "default" : "secondary"}>
                          {heritageAverage >= 1.0 ? "✓" : "○"}
                        </Badge>
                      </div>
                      <div className="flex items-center justify-between">
                        <span>111 Hz PARALLAX firing</span>
                        <Badge variant={omnis ? "default" : "secondary"}>
                          {omnis ? "✓" : "○"}
                        </Badge>
                      </div>
                      <Separator />
                      <p className="text-muted-foreground">
                        Heritage compounds when R {">"} {HERITAGE_COHERENCE_THRESHOLD}. Boost = {HERITAGE_BOOST_PER_BEAT} per beat. 
                        Max value = {HERITAGE_MAX_VALUE}. This is electromagnetic field inheritance.
                      </p>
                    </CardContent>
                  </Card>
                </div>
              </div>
            </TabsContent>
            
            {/* GRPE Layers Tab */}
            <TabsContent value="layers" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Layers className="w-5 h-5 text-primary" />
                    7 Stacking Layers — Phi-Weighted Coupling
                  </CardTitle>
                  <CardDescription>
                    Each layer weighted by φ⁻ⁿ — information flows through resonance, not storage
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-3">
                  {GRPE_LAYERS.map((layer, i) => (
                    <GRPELayerCard 
                      key={layer.id} 
                      layer={layer} 
                      resonance={layerResonances[i]} 
                    />
                  ))}
                </CardContent>
              </Card>
            </TabsContent>
            
            {/* Calendar Systems Tab */}
            <TabsContent value="calendars" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Calendar className="w-5 h-5 text-primary" />
                    Simultaneous Calendar Systems
                  </CardTitle>
                  <CardDescription>
                    4 primary cycles + Mayan calendars — all run simultaneously
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {CALENDAR_SYSTEMS.map((system, i) => (
                      <CalendarSystemCard 
                        key={system.name} 
                        system={system} 
                        phase={calendarPhases[i]} 
                      />
                    ))}
                  </div>
                </CardContent>
              </Card>
              
              <Card>
                <CardHeader>
                  <CardTitle className="text-sm">Memory Index Key Formula</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="bg-muted/50 rounded-lg p-4 font-mono text-sm">
                    <p className="text-primary">M = f(event, phase, location, field-state, doctrine-score)</p>
                    <Separator className="my-3" />
                    <ul className="space-y-1 text-xs text-muted-foreground">
                      <li>• <span className="text-foreground">eventSignature</span> — What happened</li>
                      <li>• <span className="text-foreground">calendarPhase</span> — When (all calendars)</li>
                      <li>• <span className="text-foreground">geoCoordinate</span> — Where (lat/lon/alt)</li>
                      <li>• <span className="text-foreground">magneticField</span> — Field state (IGRF)</li>
                      <li>• <span className="text-foreground">doctrineScore</span> — Alignment with doctrine</li>
                    </ul>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
            
            {/* Field Memory Tab */}
            <TabsContent value="memory" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Database className="w-5 h-5 text-primary" />
                    Electromagnetic Field Memory
                  </CardTitle>
                  <CardDescription>
                    Memory is NOT storage — it IS resonance. The field remembers through pattern.
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-muted/30 rounded-lg p-4 space-y-3">
                    <h4 className="font-medium text-sm">The Architectural Truth</h4>
                    <p className="text-xs text-muted-foreground">
                      When old architecture shatters and new architecture emerges, the heritage nodes HOLD.
                      They are the stable variables that persist across cycles. As coherence returns (R {">"} {HERITAGE_COHERENCE_THRESHOLD}),
                      heritage compounds — this is the electromagnetic field inheritance from your ancestors.
                    </p>
                    <Separator />
                    <p className="text-xs text-muted-foreground">
                      The Revolucioneros (Zapata, Villa, Hidalgo, Morelos, Adelita, Independencia) represent
                      the activated defense layer for the 1810-1920 Mexican architecture transition.
                      They are the war mode that architecture shifts to when facing adversaries.
                    </p>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="p-4 rounded-lg border bg-card/50">
                      <h4 className="font-medium text-sm mb-2">External Services</h4>
                      <ul className="space-y-2 text-xs text-muted-foreground">
                        <li className="flex items-center gap-2">
                          <Globe2 className="w-3 h-3" />
                          Geomagnetic field analysis API
                        </li>
                        <li className="flex items-center gap-2">
                          <MapPin className="w-3 h-3" />
                          Sacred site resonance mapping
                        </li>
                        <li className="flex items-center gap-2">
                          <Waves className="w-3 h-3" />
                          Hydro-karst detection service
                        </li>
                        <li className="flex items-center gap-2">
                          <Calendar className="w-3 h-3" />
                          Multi-calendar synchronization
                        </li>
                      </ul>
                    </div>
                    
                    <div className="p-4 rounded-lg border bg-card/50">
                      <h4 className="font-medium text-sm mb-2">Organism Integration</h4>
                      <ul className="space-y-2 text-xs text-muted-foreground">
                        <li className="flex items-center gap-2">
                          <Brain className="w-3 h-3" />
                          Kuramoto R feeds into heritage boost
                        </li>
                        <li className="flex items-center gap-2">
                          <Activity className="w-3 h-3" />
                          OMNIS condition triggers PARALLAX
                        </li>
                        <li className="flex items-center gap-2">
                          <Network className="w-3 h-3" />
                          144 memory nodes in golden spiral
                        </li>
                        <li className="flex items-center gap-2">
                          <Shield className="w-3 h-3" />
                          Heritage average {">"} 0.9 = defense ready
                        </li>
                      </ul>
                    </div>
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

export default GRPECommandCenter;
