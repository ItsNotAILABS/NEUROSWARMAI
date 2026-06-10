// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  COLONY COORDINATOR — FULL COLONY INTELLIGENCE VISUALIZATION                                              ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { Slider } from "@/components/ui/slider";
import { Switch } from "@/components/ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Activity,
  AlertTriangle,
  Atom,
  Bird,
  Bug,
  Cat,
  CircleDot,
  Crown,
  Dog,
  Fish,
  Hexagon,
  Layers,
  Network,
  Pause,
  Play,
  RefreshCw,
  Settings,
  Sparkles,
  Target,
  TrendingUp,
  Users,
  Waves,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import {
  CASTES,
  CASTE_COLORS,
  COLONY_MODE_COLORS,
  HZ_NODE_COUNT,
  PI,
  QUORUM_BRITTLE,
  QUORUM_COMMITMENT,
  QUORUM_EXPLORATION,
  QUORUM_NEGOTIATION,
  TWO_PI,
  calculateColonyCoherence,
  calculateKuramotoOrderParameter,
  determineColonyMode,
} from "@/lib/substrate/constants";

import type { Caste, ColonyMode } from "@/lib/substrate/constants";
import type {
  ColonyOrganism,
  ColonyState,
  TraitVector,
} from "@/lib/substrate/types";

// ═══════════════════════════════════════════════════════════════════════════════
// VISUALIZATION CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const CANVAS_SIZE = 700;
const ORGANISM_RADIUS = 15;
const CENTER_RADIUS = 80;
const ORBIT_SPACING = 60;
const ANIMATION_INTERVAL = 83; // ~12 Hz

// ═══════════════════════════════════════════════════════════════════════════════
// COLONY INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

function initializeTraitVector(): TraitVector {
  return {
    crow: Math.random(),
    dolphin: Math.random(),
    hive: Math.random(),
    elephant: Math.random(),
    shark: Math.random(),
    wolf: Math.random(),
    orca: Math.random(),
    eagle: Math.random(),
    octopus: Math.random(),
  };
}

function determineCaste(traits: TraitVector): Caste {
  const entries = Object.entries(traits) as [Caste, number][];
  const sorted = entries.sort((a, b) => b[1] - a[1]);
  // Capitalize first letter
  const caste = sorted[0][0];
  return (caste.charAt(0).toUpperCase() + caste.slice(1)) as Caste;
}

function initializeColonyOrganism(id: number): ColonyOrganism {
  const traits = initializeTraitVector();
  const phases = Array.from(
    { length: HZ_NODE_COUNT },
    () => Math.random() * TWO_PI,
  );
  const frequencies = Array.from(
    { length: HZ_NODE_COUNT },
    (_, k) => 2.5 * 2 ** (k - 3),
  );

  return {
    organismId: id,
    principal: `organism-${id}`,
    phases,
    frequencies,
    traits,
    currentCaste: determineCaste(traits),
    casteConfidence: 0.5 + Math.random() * 0.5,
    formaEnergy: 100 + Math.random() * 100,
    formaReserve: 50 + Math.random() * 50,
    localCoherence: 0.5 + Math.random() * 0.3,
    genesisDrift: Math.random() * 0.1,
    predictionError: Math.random() * 0.2,
    atlasWritePermission: Math.random() > 0.5,
    lastHeartbeat: Date.now(),
    beatsSinceJoin: Math.floor(Math.random() * 1000),
    parentOrganismId: id > 0 ? Math.floor(Math.random() * id) : null,
    inheritanceAlpha: 0.3 + Math.random() * 0.4,
  };
}

function initializeColonyState(organismCount = 20): ColonyState {
  const organisms = Array.from({ length: organismCount }, (_, i) =>
    initializeColonyOrganism(i),
  );
  const organismPhases = organisms.map((o) => o.phases);
  const { rColony, psiGlobal } = calculateColonyCoherence(organismPhases);

  return {
    colonyId: 1,
    organisms,
    organismCount,
    atlasGrid: {
      cells: [],
      totalPheromone: 0,
      avgPheromone: 0,
      maxPheromone: 0,
      activeSignals: 0,
      lastEvaporation: Date.now(),
    },
    rColony,
    psiGlobal,
    colonyMode: determineColonyMode(rColony),
    quorumActive: rColony >= QUORUM_COMMITMENT,
    quorumThreshold: QUORUM_COMMITMENT,
    totalForma: organisms.reduce((sum, o) => sum + o.formaEnergy, 0),
    totalBeats: 0,
    genesisTime: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// COLONY UPDATE FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function updateOrganismPhases(
  organisms: ColonyOrganism[],
  couplingStrength: number,
): void {
  for (const organism of organisms) {
    for (let k = 0; k < HZ_NODE_COUNT; k++) {
      const omega = organism.frequencies[k] * TWO_PI;

      // Mean field coupling to other organisms at same Hz level
      let sumSin = 0;
      for (const other of organisms) {
        if (other.organismId !== organism.organismId) {
          sumSin += Math.sin(other.phases[k] - organism.phases[k]);
        }
      }

      const coupling = (couplingStrength * sumSin) / organisms.length;
      const dt = 1 / 12;
      organism.phases[k] =
        (organism.phases[k] + (omega + coupling) * dt) % TWO_PI;
    }

    // Update local coherence
    const { r } = calculateKuramotoOrderParameter(organism.phases);
    organism.localCoherence = r;
  }
}

function updateCasteTraits(organisms: ColonyOrganism[]): void {
  for (const organism of organisms) {
    // Slight random drift in traits
    const traits = organism.traits;
    const keys = Object.keys(traits) as (keyof TraitVector)[];

    for (const key of keys) {
      traits[key] = Math.max(
        0,
        Math.min(1, traits[key] + (Math.random() - 0.5) * 0.02),
      );
    }

    // Update caste based on dominant trait
    const newCaste = determineCaste(traits);
    if (newCaste !== organism.currentCaste) {
      organism.currentCaste = newCaste;
      organism.casteConfidence = 0.5;
    } else {
      organism.casteConfidence = Math.min(1, organism.casteConfidence + 0.01);
    }
  }
}

function updateFormaEnergy(organisms: ColonyOrganism[]): void {
  for (const organism of organisms) {
    // Energy dynamics
    const consumption = 0.5 + Math.random() * 0.5;
    const generation = organism.localCoherence * 2;

    organism.formaEnergy = Math.max(
      0,
      Math.min(300, organism.formaEnergy - consumption + generation),
    );

    // Reserve transfer
    if (organism.formaEnergy < 50 && organism.formaReserve > 10) {
      const transfer = Math.min(10, organism.formaReserve);
      organism.formaReserve -= transfer;
      organism.formaEnergy += transfer;
    }

    // Reserve regeneration
    if (organism.formaEnergy > 150) {
      organism.formaReserve = Math.min(100, organism.formaReserve + 0.5);
    }
  }
}

function updateColonyState(
  colony: ColonyState,
  couplingStrength: number,
): ColonyState {
  const newOrganisms = colony.organisms.map((o) => ({
    ...o,
    phases: [...o.phases],
    traits: { ...o.traits },
  }));

  updateOrganismPhases(newOrganisms, couplingStrength);
  updateCasteTraits(newOrganisms);
  updateFormaEnergy(newOrganisms);

  const organismPhases = newOrganisms.map((o) => o.phases);
  const { rColony, psiGlobal } = calculateColonyCoherence(organismPhases);
  const colonyMode = determineColonyMode(rColony);

  return {
    ...colony,
    organisms: newOrganisms,
    rColony,
    psiGlobal,
    colonyMode,
    quorumActive: rColony >= colony.quorumThreshold,
    totalForma: newOrganisms.reduce((sum, o) => sum + o.formaEnergy, 0),
    totalBeats: colony.totalBeats + 1,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// VISUALIZATION HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

function getOrganismPosition(
  organism: ColonyOrganism,
  organismCount: number,
  centerX: number,
  centerY: number,
): { x: number; y: number } {
  const casteIndex = CASTES.indexOf(organism.currentCaste);
  const _casteOrganisms = organismCount / CASTES.length;
  const orbitRadius = CENTER_RADIUS + (casteIndex % 3) * ORBIT_SPACING;

  const baseAngle = (organism.organismId / organismCount) * TWO_PI;
  const phaseOffset = organism.phases[0] * 0.1; // Subtle phase influence
  const angle = baseAngle + phaseOffset - PI / 2;

  return {
    x: centerX + orbitRadius * Math.cos(angle),
    y: centerY + orbitRadius * Math.sin(angle),
  };
}

function getCasteIcon(caste: Caste): React.ReactNode {
  const icons: Record<Caste, React.ReactNode> = {
    Crow: <Bird className="w-3 h-3" />,
    Dolphin: <Fish className="w-3 h-3" />,
    Hive: <Hexagon className="w-3 h-3" />,
    Elephant: <CircleDot className="w-3 h-3" />,
    Shark: <Fish className="w-3 h-3" />,
    Wolf: <Dog className="w-3 h-3" />,
    Orca: <Fish className="w-3 h-3" />,
    Eagle: <Bird className="w-3 h-3" />,
    Octopus: <Bug className="w-3 h-3" />,
  };
  return icons[caste] || <CircleDot className="w-3 h-3" />;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ORGANISM DETAILS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface OrganismDetailsPanelProps {
  organism: ColonyOrganism | null;
  onClose: () => void;
}

function OrganismDetailsPanel({
  organism,
  onClose,
}: OrganismDetailsPanelProps) {
  if (!organism) return null;

  const traitEntries = Object.entries(organism.traits) as [
    keyof TraitVector,
    number,
  ][];
  const sortedTraits = traitEntries.sort((a, b) => b[1] - a[1]);

  return (
    <Card className="absolute top-4 right-4 w-80 bg-background/95 backdrop-blur-sm border-border shadow-xl z-10">
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div
              className="w-8 h-8 rounded-full flex items-center justify-center"
              style={{
                backgroundColor: `${CASTE_COLORS[organism.currentCaste]}40`,
              }}
            >
              {getCasteIcon(organism.currentCaste)}
            </div>
            <div>
              <CardTitle className="text-sm font-semibold">
                Organism #{organism.organismId}
              </CardTitle>
              <CardDescription className="text-xs">
                {organism.currentCaste} ·{" "}
                {(organism.casteConfidence * 100).toFixed(0)}% confidence
              </CardDescription>
            </div>
          </div>
          <Button variant="ghost" size="sm" onClick={onClose}>
            ×
          </Button>
        </div>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="space-y-1">
            <span className="text-muted-foreground">FORMA Energy</span>
            <div className="font-mono font-semibold">
              {organism.formaEnergy.toFixed(1)}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">FORMA Reserve</span>
            <div className="font-mono font-semibold">
              {organism.formaReserve.toFixed(1)}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Local Coherence</span>
            <div className="font-mono font-semibold">
              {(organism.localCoherence * 100).toFixed(1)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Genesis Drift</span>
            <div className="font-mono font-semibold">
              {(organism.genesisDrift * 100).toFixed(2)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Prediction Error</span>
            <div className="font-mono font-semibold">
              {(organism.predictionError * 100).toFixed(2)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Beats Since Join</span>
            <div className="font-mono font-semibold">
              {organism.beatsSinceJoin}
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground font-semibold">
            Trait Vector
          </span>
          <div className="space-y-1">
            {sortedTraits.slice(0, 5).map(([trait, value]) => (
              <div key={trait} className="flex items-center gap-2">
                <span className="text-[10px] text-muted-foreground w-16 capitalize">
                  {trait}
                </span>
                <Progress value={value * 100} className="h-1.5 flex-1" />
                <span className="text-[10px] font-mono w-8">
                  {(value * 100).toFixed(0)}%
                </span>
              </div>
            ))}
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground font-semibold">
            Hz Phases
          </span>
          <div className="grid grid-cols-6 gap-1">
            {organism.phases.map((phase, k) => (
              <div
                key={phase}
                className="w-6 h-6 rounded-full flex items-center justify-center text-[8px] font-mono"
                style={{
                  backgroundColor: `oklch(${40 + (phase / TWO_PI) * 40}% 0.15 ${(k / 12) * 360})`,
                }}
              >
                {k + 1}
              </div>
            ))}
          </div>
        </div>

        <div className="flex items-center gap-2">
          <Badge
            variant={organism.atlasWritePermission ? "default" : "secondary"}
            className="text-[10px]"
          >
            {organism.atlasWritePermission ? "ATLAS Write" : "Read Only"}
          </Badge>
          {organism.parentOrganismId !== null && (
            <Badge variant="outline" className="text-[10px]">
              Parent: #{organism.parentOrganismId}
            </Badge>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUORUM SENSING PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface QuorumSensingPanelProps {
  colony: ColonyState;
  onThresholdChange: (threshold: number) => void;
}

function QuorumSensingPanel({
  colony,
  onThresholdChange,
}: QuorumSensingPanelProps) {
  const modeDescription: Record<ColonyMode, string> = {
    Exploration:
      "Independent counterfactual branches — organisms exploring independently",
    Negotiation:
      "Consensus building — organisms negotiating shared understanding",
    Commitment: "Coordinated action — colony acting as unified entity",
  };

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Users className="w-4 h-4" />
          Quorum Sensing
        </CardTitle>
        <CardDescription className="text-xs">
          Collective decision without a leader
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div
          className="text-center p-4 rounded-lg"
          style={{
            backgroundColor: `${COLONY_MODE_COLORS[colony.colonyMode]}20`,
          }}
        >
          <div
            className="text-2xl font-bold mb-1"
            style={{ color: COLONY_MODE_COLORS[colony.colonyMode] }}
          >
            {colony.colonyMode.toUpperCase()}
          </div>
          <div className="text-xs text-muted-foreground">
            {modeDescription[colony.colonyMode]}
          </div>
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Colony Coherence (r)</span>
            <span className="font-mono font-semibold">
              {colony.rColony.toFixed(4)}
            </span>
          </div>
          <div className="relative h-8">
            <Progress value={colony.rColony * 100} className="h-8" />
            {/* Threshold markers */}
            <div
              className="absolute top-0 bottom-0 w-0.5 bg-yellow-500"
              style={{ left: `${QUORUM_EXPLORATION * 100}%` }}
            />
            <div
              className="absolute top-0 bottom-0 w-0.5 bg-green-500"
              style={{ left: `${QUORUM_COMMITMENT * 100}%` }}
            />
            <div
              className="absolute top-0 bottom-0 w-0.5 bg-red-500"
              style={{ left: `${QUORUM_BRITTLE * 100}%` }}
            />
          </div>
          <div className="flex justify-between text-[10px] text-muted-foreground">
            <span>0%</span>
            <span className="text-yellow-500">30% Explore</span>
            <span className="text-green-500">70% Commit</span>
            <span className="text-red-500">95% Brittle</span>
          </div>
        </div>

        <Separator />

        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground">Global Phase (Ψ)</div>
            <div className="font-mono font-semibold">
              {((colony.psiGlobal * 180) / PI).toFixed(1)}°
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground">Quorum Status</div>
            <div
              className="font-semibold"
              style={{ color: colony.quorumActive ? "#10B981" : "#6B7280" }}
            >
              {colony.quorumActive ? "ACTIVE" : "INACTIVE"}
            </div>
          </div>
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Quorum Threshold</span>
            <span className="font-mono">
              {(colony.quorumThreshold * 100).toFixed(0)}%
            </span>
          </div>
          <Slider
            value={[colony.quorumThreshold * 100]}
            onValueChange={([v]) => onThresholdChange(v / 100)}
            min={10}
            max={95}
            step={5}
            className="w-full"
          />
        </div>

        {colony.rColony > QUORUM_BRITTLE && (
          <div className="flex items-center gap-2 p-2 rounded-lg bg-red-500/20 text-red-500">
            <AlertTriangle className="w-4 h-4" />
            <span className="text-xs font-semibold">
              Pride Before Fall Warning!
            </span>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CASTE DISTRIBUTION PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface CasteDistributionPanelProps {
  organisms: ColonyOrganism[];
  selectedCaste: Caste | null;
  onCasteSelect: (caste: Caste | null) => void;
}

function CasteDistributionPanel({
  organisms,
  selectedCaste,
  onCasteSelect,
}: CasteDistributionPanelProps) {
  const casteStats = useMemo(() => {
    return CASTES.map((caste) => {
      const casteOrganisms = organisms.filter((o) => o.currentCaste === caste);
      const avgCoherence =
        casteOrganisms.length > 0
          ? casteOrganisms.reduce((sum, o) => sum + o.localCoherence, 0) /
            casteOrganisms.length
          : 0;
      const avgEnergy =
        casteOrganisms.length > 0
          ? casteOrganisms.reduce((sum, o) => sum + o.formaEnergy, 0) /
            casteOrganisms.length
          : 0;

      return {
        caste,
        count: casteOrganisms.length,
        avgCoherence,
        avgEnergy,
        color: CASTE_COLORS[caste],
      };
    });
  }, [organisms]);

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Layers className="w-4 h-4" />
          Caste Distribution
        </CardTitle>
        <CardDescription className="text-xs">
          Division of labor — caste without hierarchy
        </CardDescription>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-64">
          <div className="space-y-2">
            {casteStats.map((stat) => (
              <button
                type="button"
                key={stat.caste}
                className={`w-full text-left p-2 rounded-lg cursor-pointer transition-colors ${
                  selectedCaste === stat.caste
                    ? "bg-primary/20 border border-primary/50"
                    : "bg-surface hover:bg-surface-elevated"
                }`}
                onClick={() =>
                  onCasteSelect(
                    selectedCaste === stat.caste ? null : stat.caste,
                  )
                }
              >
                <div className="flex items-center justify-between mb-1">
                  <div className="flex items-center gap-2">
                    <div
                      className="w-6 h-6 rounded flex items-center justify-center"
                      style={{ backgroundColor: `${stat.color}40` }}
                    >
                      {getCasteIcon(stat.caste)}
                    </div>
                    <span className="text-xs font-semibold">{stat.caste}</span>
                  </div>
                  <Badge variant="outline" className="text-[10px]">
                    {stat.count}
                  </Badge>
                </div>
                {stat.count > 0 && (
                  <div className="grid grid-cols-2 gap-2 mt-2">
                    <div>
                      <span className="text-[10px] text-muted-foreground">
                        Coherence
                      </span>
                      <Progress
                        value={stat.avgCoherence * 100}
                        className="h-1 mt-1"
                      />
                    </div>
                    <div>
                      <span className="text-[10px] text-muted-foreground">
                        Energy
                      </span>
                      <Progress
                        value={stat.avgEnergy / 3}
                        className="h-1 mt-1"
                      />
                    </div>
                  </div>
                )}
              </button>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// COLONY STATISTICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface ColonyStatisticsPanelProps {
  colony: ColonyState;
}

function ColonyStatisticsPanel({ colony }: ColonyStatisticsPanelProps) {
  const avgCoherence = useMemo(
    () =>
      colony.organisms.reduce((sum, o) => sum + o.localCoherence, 0) /
      colony.organisms.length,
    [colony.organisms],
  );

  const avgEnergy = useMemo(
    () =>
      colony.organisms.reduce((sum, o) => sum + o.formaEnergy, 0) /
      colony.organisms.length,
    [colony.organisms],
  );

  const atlasWriters = useMemo(
    () => colony.organisms.filter((o) => o.atlasWritePermission).length,
    [colony.organisms],
  );

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Activity className="w-4 h-4" />
          Colony Statistics
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Users className="w-3 h-3" />
              Organisms
            </div>
            <div className="font-mono font-semibold text-lg">
              {colony.organismCount}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Zap className="w-3 h-3" />
              Total FORMA
            </div>
            <div className="font-mono font-semibold text-lg">
              {colony.totalForma.toFixed(0)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Target className="w-3 h-3" />
              Avg Coherence
            </div>
            <div className="font-mono font-semibold text-lg">
              {(avgCoherence * 100).toFixed(1)}%
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Sparkles className="w-3 h-3" />
              Avg Energy
            </div>
            <div className="font-mono font-semibold text-lg">
              {avgEnergy.toFixed(1)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Network className="w-3 h-3" />
              ATLAS Writers
            </div>
            <div className="font-mono font-semibold text-lg">
              {atlasWriters}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Activity className="w-3 h-3" />
              Total Beats
            </div>
            <div className="font-mono font-semibold text-lg">
              {colony.totalBeats}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONTROLS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface ControlsPanelProps {
  isRunning: boolean;
  onToggleRunning: () => void;
  onReset: () => void;
  couplingStrength: number;
  onCouplingChange: (strength: number) => void;
  organismCount: number;
  onOrganismCountChange: (count: number) => void;
  animationSpeed: number;
  onSpeedChange: (speed: number) => void;
}

function ControlsPanel({
  isRunning,
  onToggleRunning,
  onReset,
  couplingStrength,
  onCouplingChange,
  organismCount,
  onOrganismCountChange,
  animationSpeed,
  onSpeedChange,
}: ControlsPanelProps) {
  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Settings className="w-4 h-4" />
          Controls
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex items-center gap-2">
          <Button
            variant={isRunning ? "secondary" : "default"}
            size="sm"
            onClick={onToggleRunning}
            className="flex-1"
          >
            {isRunning ? (
              <>
                <Pause className="w-4 h-4 mr-2" />
                Pause
              </>
            ) : (
              <>
                <Play className="w-4 h-4 mr-2" />
                Run
              </>
            )}
          </Button>
          <Button variant="outline" size="sm" onClick={onReset}>
            <RefreshCw className="w-4 h-4" />
          </Button>
        </div>

        <Separator />

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Coupling Strength (K)</span>
            <span className="font-mono">{couplingStrength.toFixed(2)}</span>
          </div>
          <Slider
            value={[couplingStrength * 100]}
            onValueChange={([v]) => onCouplingChange(v / 100)}
            min={0}
            max={50}
            step={1}
            className="w-full"
          />
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Organism Count</span>
            <span className="font-mono">{organismCount}</span>
          </div>
          <Slider
            value={[organismCount]}
            onValueChange={([v]) => onOrganismCountChange(v)}
            min={5}
            max={50}
            step={5}
            className="w-full"
          />
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Animation Speed</span>
            <span className="font-mono">{animationSpeed}x</span>
          </div>
          <Slider
            value={[animationSpeed]}
            onValueChange={([v]) => onSpeedChange(v)}
            min={0.25}
            max={4}
            step={0.25}
            className="w-full"
          />
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function ColonyCoordinatorUI() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [colony, setColony] = useState<ColonyState>(() =>
    initializeColonyState(20),
  );
  const [isRunning, setIsRunning] = useState(true);
  const [selectedOrganism, setSelectedOrganism] =
    useState<ColonyOrganism | null>(null);
  const [selectedCaste, setSelectedCaste] = useState<Caste | null>(null);
  const [couplingStrength, setCouplingStrength] = useState(0.1);
  const [organismCount, setOrganismCount] = useState(20);
  const [animationSpeed, setAnimationSpeed] = useState(1);
  const [activeTab, setActiveTab] = useState("quorum");

  // Animation loop
  useEffect(() => {
    if (!isRunning) return;

    const interval = setInterval(() => {
      setColony((prev) => updateColonyState(prev, couplingStrength));
    }, ANIMATION_INTERVAL / animationSpeed);

    return () => clearInterval(interval);
  }, [isRunning, animationSpeed, couplingStrength]);

  // Reset when organism count changes
  useEffect(() => {
    setColony(initializeColonyState(organismCount));
    setSelectedOrganism(null);
  }, [organismCount]);

  // Canvas rendering
  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    canvas.width = CANVAS_SIZE * dpr;
    canvas.height = CANVAS_SIZE * dpr;
    ctx.scale(dpr, dpr);

    const centerX = CANVAS_SIZE / 2;
    const centerY = CANVAS_SIZE / 2;

    // Clear canvas
    ctx.fillStyle = "oklch(10% 0.02 260)";
    ctx.fillRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);

    // Draw orbit circles
    for (let i = 0; i < 3; i++) {
      ctx.beginPath();
      ctx.arc(centerX, centerY, CENTER_RADIUS + i * ORBIT_SPACING, 0, TWO_PI);
      ctx.strokeStyle = "oklch(25% 0.02 260)";
      ctx.lineWidth = 1;
      ctx.stroke();
    }

    // Draw center (Queen's domain)
    ctx.beginPath();
    ctx.arc(centerX, centerY, 40, 0, TWO_PI);
    const gradient = ctx.createRadialGradient(
      centerX,
      centerY,
      0,
      centerX,
      centerY,
      40,
    );
    gradient.addColorStop(0, `${COLONY_MODE_COLORS[colony.colonyMode]}60`);
    gradient.addColorStop(1, `${COLONY_MODE_COLORS[colony.colonyMode]}10`);
    ctx.fillStyle = gradient;
    ctx.fill();

    ctx.beginPath();
    ctx.arc(centerX, centerY, 40, 0, TWO_PI);
    ctx.strokeStyle = COLONY_MODE_COLORS[colony.colonyMode];
    ctx.lineWidth = 2;
    ctx.stroke();

    // Draw organisms
    for (const organism of colony.organisms) {
      if (selectedCaste && organism.currentCaste !== selectedCaste) continue;

      const { x, y } = getOrganismPosition(
        organism,
        colony.organismCount,
        centerX,
        centerY,
      );
      const color = CASTE_COLORS[organism.currentCaste];
      const radius = ORGANISM_RADIUS * (0.8 + organism.localCoherence * 0.4);

      // Glow effect for high coherence
      if (organism.localCoherence > 0.7) {
        ctx.beginPath();
        ctx.arc(x, y, radius + 5, 0, TWO_PI);
        ctx.fillStyle = `${color}30`;
        ctx.fill();
      }

      // Main circle
      ctx.beginPath();
      ctx.arc(x, y, radius, 0, TWO_PI);
      ctx.fillStyle = `${color}80`;
      ctx.fill();
      ctx.strokeStyle = color;
      ctx.lineWidth = 2;
      ctx.stroke();

      // Selection highlight
      if (selectedOrganism?.organismId === organism.organismId) {
        ctx.beginPath();
        ctx.arc(x, y, radius + 4, 0, TWO_PI);
        ctx.strokeStyle = "oklch(90% 0.2 60)";
        ctx.lineWidth = 3;
        ctx.stroke();
      }

      // Energy indicator
      const energyRatio = organism.formaEnergy / 300;
      ctx.beginPath();
      ctx.arc(x, y, radius - 3, -PI / 2, -PI / 2 + energyRatio * TWO_PI);
      ctx.strokeStyle =
        energyRatio > 0.5
          ? "#10B981"
          : energyRatio > 0.2
            ? "#F59E0B"
            : "#EF4444";
      ctx.lineWidth = 2;
      ctx.stroke();
    }

    // Draw colony coherence indicator
    const coherenceAngle = colony.rColony * TWO_PI;
    ctx.beginPath();
    ctx.arc(centerX, centerY, 50, -PI / 2, -PI / 2 + coherenceAngle);
    ctx.strokeStyle = COLONY_MODE_COLORS[colony.colonyMode];
    ctx.lineWidth = 4;
    ctx.stroke();
  }, [colony, selectedOrganism, selectedCaste]);

  // Handle canvas click
  const handleCanvasClick = useCallback(
    (event: React.MouseEvent<HTMLCanvasElement>) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const rect = canvas.getBoundingClientRect();
      const x = event.clientX - rect.left;
      const y = event.clientY - rect.top;

      const centerX = CANVAS_SIZE / 2;
      const centerY = CANVAS_SIZE / 2;

      // Find clicked organism
      let closest: ColonyOrganism | null = null;
      let closestDist = Number.POSITIVE_INFINITY;

      for (const organism of colony.organisms) {
        if (selectedCaste && organism.currentCaste !== selectedCaste) continue;

        const pos = getOrganismPosition(
          organism,
          colony.organismCount,
          centerX,
          centerY,
        );
        const dist = Math.sqrt((x - pos.x) ** 2 + (y - pos.y) ** 2);

        if (dist < ORGANISM_RADIUS * 1.5 && dist < closestDist) {
          closest = organism;
          closestDist = dist;
        }
      }

      setSelectedOrganism(closest);
    },
    [colony, selectedCaste],
  );

  const handleReset = useCallback(() => {
    setColony(initializeColonyState(organismCount));
    setSelectedOrganism(null);
    setSelectedCaste(null);
  }, [organismCount]);

  const handleQuorumThresholdChange = useCallback((threshold: number) => {
    setColony((prev) => ({
      ...prev,
      quorumThreshold: threshold,
      quorumActive: prev.rColony >= threshold,
    }));
  }, []);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center">
            <Crown className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-sm font-bold">Colony Coordinator</h1>
            <p className="text-xs text-muted-foreground">
              {colony.organismCount} organisms · 9 castes · Quorum sensing
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Badge
            variant="default"
            style={{ backgroundColor: COLONY_MODE_COLORS[colony.colonyMode] }}
          >
            {colony.colonyMode.toUpperCase()}
          </Badge>
          <Badge variant="outline">Beat #{colony.totalBeats}</Badge>
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left panel */}
        <div className="w-72 border-r border-border p-4 overflow-y-auto space-y-4">
          <ControlsPanel
            isRunning={isRunning}
            onToggleRunning={() => setIsRunning(!isRunning)}
            onReset={handleReset}
            couplingStrength={couplingStrength}
            onCouplingChange={setCouplingStrength}
            organismCount={organismCount}
            onOrganismCountChange={setOrganismCount}
            animationSpeed={animationSpeed}
            onSpeedChange={setAnimationSpeed}
          />
          <ColonyStatisticsPanel colony={colony} />
        </div>

        {/* Center - Canvas */}
        <div className="flex-1 flex items-center justify-center p-4 relative">
          <canvas
            ref={canvasRef}
            width={CANVAS_SIZE}
            height={CANVAS_SIZE}
            className="rounded-lg border border-border cursor-crosshair"
            style={{ width: CANVAS_SIZE, height: CANVAS_SIZE }}
            onClick={handleCanvasClick}
            onKeyDown={(e) => {
              if (e.key === "Enter" || e.key === " ")
                handleCanvasClick(
                  e as unknown as React.MouseEvent<HTMLCanvasElement>,
                );
            }}
            tabIndex={0}
          />
          <OrganismDetailsPanel
            organism={selectedOrganism}
            onClose={() => setSelectedOrganism(null)}
          />
        </div>

        {/* Right panel */}
        <div className="w-80 border-l border-border p-4 overflow-y-auto">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-2 mb-4">
              <TabsTrigger value="quorum" className="text-xs">
                Quorum
              </TabsTrigger>
              <TabsTrigger value="castes" className="text-xs">
                Castes
              </TabsTrigger>
            </TabsList>

            <TabsContent value="quorum" className="mt-0">
              <QuorumSensingPanel
                colony={colony}
                onThresholdChange={handleQuorumThresholdChange}
              />
            </TabsContent>

            <TabsContent value="castes" className="mt-0">
              <CasteDistributionPanel
                organisms={colony.organisms}
                selectedCaste={selectedCaste}
                onCasteSelect={setSelectedCaste}
              />
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
}

export default ColonyCoordinatorUI;
