// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  ATLAS GRID VISUALIZER — 4,096 CELL STIGMERGIC MEMORY GRID                                               ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE SEVEN LAWS OF ANT COLONY ARCHITECTURE IN COMPUTATIONAL FORM:                                        ║
// ║  1. STIGMERGY — Pheromone as Memory (ATLAS grid)                                                         ║
// ║  2. QUORUM SENSING — Collective Decision Without a Leader                                                 ║
// ║  3. DIVISION OF LABOR — Caste Without Hierarchy                                                           ║
// ║  4. FORK-TRAIL OPTIMIZATION — Gradient Descent Without Backpropagation                                   ║
// ║  5. MEMORY SPANNING GENERATIONS — Epigenetic State Transfer                                               ║
// ║  6. COLLECTIVE INTELLIGENCE — Emergence Without Understanding                                             ║
// ║  7. THE QUEEN'S SILENCE — Sovereign Without Commanding                                                    ║
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
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip";
import {
  Activity,
  AlertTriangle,
  Atom,
  Bug,
  Crosshair,
  Eye,
  EyeOff,
  Flame,
  Grid3X3,
  Hammer,
  Layers,
  Map as MapIcon,
  Pause,
  Play,
  RefreshCw,
  Search,
  Settings,
  Shield,
  Sparkles,
  Target,
  TrendingDown,
  TrendingUp,
  Waves,
  Wrench,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import {
  ACO_ALPHA,
  ACO_BETA,
  ACO_RHO,
  ALPHA_BAND_END,
  ATLAS_GRID_SIZE,
  BETA_BAND_END,
  DELTA_BAND_END,
  GAMMA_BAND_START,
  PHEROMONE_DEPOSIT_BASE,
  PHEROMONE_EVAPORATION,
  PI,
  SIGNAL_COLORS,
  SIGNAL_TYPES,
  THETA_BAND_END,
  TWO_PI,
  calculateTransitionProbability,
  getFrequencyBand,
  updatePheromone,
} from "@/lib/substrate/constants";

import type { SignalType } from "@/lib/substrate/constants";
import type { AtlasCell, AtlasGrid } from "@/lib/substrate/types";

// ═══════════════════════════════════════════════════════════════════════════════
// VISUALIZATION CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const GRID_SIZE = 64; // 64x64 = 4096 cells
const CELL_SIZE = 10;
const CANVAS_SIZE = GRID_SIZE * CELL_SIZE;
const ANIMATION_INTERVAL = 100; // 10 Hz update rate

// Color schemes for frequency bands
const FREQUENCY_BAND_COLORS: Record<string, string> = {
  Delta: "oklch(50% 0.15 270)", // Purple - slow structural
  Theta: "oklch(55% 0.15 240)", // Blue - memory
  Alpha: "oklch(60% 0.15 180)", // Cyan - idle/relaxed
  Beta: "oklch(65% 0.15 120)", // Green - active thinking
  "High-Beta": "oklch(70% 0.15 60)", // Yellow - stress
  Gamma: "oklch(75% 0.15 30)", // Red - fast tactical
};

// ═══════════════════════════════════════════════════════════════════════════════
// ATLAS GRID INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

function initializeAtlasCell(position: number): AtlasCell {
  const band = getFrequencyBand(position);
  const frequencyBand =
    band === "Delta"
      ? 0
      : band === "Theta"
        ? 1
        : band === "Alpha"
          ? 2
          : band === "Beta"
            ? 3
            : band === "High-Beta"
              ? 4
              : 5;

  return {
    position,
    pheromone: Math.random() * 10,
    frequencyBand,
    lastDepositorId: 0,
    lastDepositTime: Date.now(),
    depositRate: 0,
    signalType: "Neutral" as SignalType,
    signalIntensity: 0,
  };
}

function initializeAtlasGrid(): AtlasGrid {
  const cells: AtlasCell[] = [];

  for (let i = 0; i < ATLAS_GRID_SIZE; i++) {
    cells.push(initializeAtlasCell(i));
  }

  const totalPheromone = cells.reduce((sum, c) => sum + c.pheromone, 0);
  const avgPheromone = totalPheromone / cells.length;
  const maxPheromone = Math.max(...cells.map((c) => c.pheromone));

  return {
    cells,
    totalPheromone,
    avgPheromone,
    maxPheromone,
    activeSignals: 0,
    lastEvaporation: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// ATLAS UPDATE FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function evaporatePheromones(
  grid: AtlasGrid,
  rate: number = PHEROMONE_EVAPORATION,
): void {
  for (const cell of grid.cells) {
    cell.pheromone = updatePheromone(cell.pheromone, 0, rate);
  }

  grid.totalPheromone = grid.cells.reduce((sum, c) => sum + c.pheromone, 0);
  grid.avgPheromone = grid.totalPheromone / grid.cells.length;
  grid.maxPheromone = Math.max(...grid.cells.map((c) => c.pheromone));
  grid.lastEvaporation = Date.now();
}

function depositPheromone(
  grid: AtlasGrid,
  position: number,
  amount: number,
  signalType: SignalType,
  depositorId: number,
): void {
  if (position < 0 || position >= grid.cells.length) return;

  const cell = grid.cells[position];
  cell.pheromone = updatePheromone(cell.pheromone, amount, 0);
  cell.signalType = signalType;
  cell.signalIntensity = Math.min(1, cell.signalIntensity + 0.2);
  cell.lastDepositorId = depositorId;
  cell.lastDepositTime = Date.now();
  cell.depositRate = amount;

  // Update grid statistics
  grid.totalPheromone = grid.cells.reduce((sum, c) => sum + c.pheromone, 0);
  grid.avgPheromone = grid.totalPheromone / grid.cells.length;
  grid.maxPheromone = Math.max(...grid.cells.map((c) => c.pheromone));
  grid.activeSignals = grid.cells.filter(
    (c) => c.signalType !== "Neutral",
  ).length;
}

function simulateAntMovement(grid: AtlasGrid, antCount = 50): void {
  for (let a = 0; a < antCount; a++) {
    // Random starting position
    let position = Math.floor(Math.random() * ATLAS_GRID_SIZE);

    // Move for a few steps
    for (let step = 0; step < 5; step++) {
      const neighbors = getNeighborPositions(position);

      // Calculate transition probabilities
      let totalProb = 0;
      const probs: number[] = [];

      for (const neighbor of neighbors) {
        if (neighbor >= 0 && neighbor < ATLAS_GRID_SIZE) {
          const pheromone = grid.cells[neighbor].pheromone;
          const heuristic = 1 / (1 + Math.abs(neighbor - position));
          const prob = pheromone ** ACO_ALPHA * heuristic ** ACO_BETA;
          probs.push(prob);
          totalProb += prob;
        } else {
          probs.push(0);
        }
      }

      // Select next position based on probabilities
      const rand = Math.random() * totalProb;
      let cumProb = 0;
      let nextPosition = position;

      for (let i = 0; i < neighbors.length; i++) {
        cumProb += probs[i];
        if (
          rand <= cumProb &&
          neighbors[i] >= 0 &&
          neighbors[i] < ATLAS_GRID_SIZE
        ) {
          nextPosition = neighbors[i];
          break;
        }
      }

      // Deposit pheromone at new position
      const signalType = SIGNAL_TYPES[
        Math.floor(Math.random() * SIGNAL_TYPES.length)
      ] as SignalType;
      depositPheromone(
        grid,
        nextPosition,
        PHEROMONE_DEPOSIT_BASE / 10,
        signalType,
        a,
      );

      position = nextPosition;
    }
  }
}

function getNeighborPositions(position: number): number[] {
  const row = Math.floor(position / GRID_SIZE);
  const col = position % GRID_SIZE;

  const neighbors: number[] = [];

  // 8-connected neighborhood
  for (let dr = -1; dr <= 1; dr++) {
    for (let dc = -1; dc <= 1; dc++) {
      if (dr === 0 && dc === 0) continue;

      const newRow = row + dr;
      const newCol = col + dc;

      if (
        newRow >= 0 &&
        newRow < GRID_SIZE &&
        newCol >= 0 &&
        newCol < GRID_SIZE
      ) {
        neighbors.push(newRow * GRID_SIZE + newCol);
      }
    }
  }

  return neighbors;
}

function decaySignalIntensity(grid: AtlasGrid): void {
  for (const cell of grid.cells) {
    cell.signalIntensity *= 0.95;
    if (cell.signalIntensity < 0.05) {
      cell.signalType = "Neutral";
      cell.signalIntensity = 0;
    }
  }

  grid.activeSignals = grid.cells.filter(
    (c) => c.signalType !== "Neutral",
  ).length;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CELL DETAILS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface CellDetailsPanelProps {
  cell: AtlasCell | null;
  onClose: () => void;
}

function CellDetailsPanel({ cell, onClose }: CellDetailsPanelProps) {
  if (!cell) return null;

  const band = getFrequencyBand(cell.position);
  const row = Math.floor(cell.position / GRID_SIZE);
  const col = cell.position % GRID_SIZE;

  return (
    <Card className="absolute top-4 right-4 w-72 bg-background/95 backdrop-blur-sm border-border shadow-xl z-10">
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <CardTitle className="text-sm font-semibold">
            Cell [{row}, {col}]
          </CardTitle>
          <Button variant="ghost" size="sm" onClick={onClose}>
            <EyeOff className="w-4 h-4" />
          </Button>
        </div>
        <CardDescription className="text-xs">
          Position {cell.position} · {band} Band
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="space-y-1">
            <span className="text-muted-foreground">Pheromone</span>
            <div className="font-mono font-semibold">
              {cell.pheromone.toFixed(2)}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Signal Type</span>
            <div className="flex items-center gap-1">
              <div
                className="w-2 h-2 rounded-full"
                style={{ backgroundColor: SIGNAL_COLORS[cell.signalType] }}
              />
              <span className="font-semibold">{cell.signalType}</span>
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Intensity</span>
            <div className="font-mono font-semibold">
              {(cell.signalIntensity * 100).toFixed(1)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Deposit Rate</span>
            <div className="font-mono font-semibold">
              {cell.depositRate.toFixed(2)}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Freq Band</span>
            <div className="font-semibold">{cell.frequencyBand}</div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Last Depositor</span>
            <div className="font-mono font-semibold">
              #{cell.lastDepositorId}
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">Pheromone Level</span>
          <Progress value={Math.min(100, cell.pheromone)} className="h-2" />
        </div>

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">
            Signal Intensity
          </span>
          <Progress value={cell.signalIntensity * 100} className="h-2" />
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// FREQUENCY BAND PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface FrequencyBandPanelProps {
  grid: AtlasGrid;
  selectedBand: string | null;
  onBandSelect: (band: string | null) => void;
}

function FrequencyBandPanel({
  grid,
  selectedBand,
  onBandSelect,
}: FrequencyBandPanelProps) {
  const bandStats = useMemo(() => {
    const bands = ["Delta", "Theta", "Alpha", "Beta", "High-Beta", "Gamma"];

    return bands.map((band) => {
      const cells = grid.cells.filter(
        (c) => getFrequencyBand(c.position) === band,
      );
      const totalPheromone = cells.reduce((sum, c) => sum + c.pheromone, 0);
      const avgPheromone = cells.length > 0 ? totalPheromone / cells.length : 0;
      const activeSignals = cells.filter(
        (c) => c.signalType !== "Neutral",
      ).length;

      return {
        band,
        cellCount: cells.length,
        totalPheromone,
        avgPheromone,
        activeSignals,
        color: FREQUENCY_BAND_COLORS[band],
      };
    });
  }, [grid]);

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Waves className="w-4 h-4" />
          Frequency Bands
        </CardTitle>
        <CardDescription className="text-xs">
          ATLAS grid partitioned by neural frequency
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {bandStats.map((stat) => (
            <button
              type="button"
              key={stat.band}
              className={`w-full text-left p-2 rounded-lg cursor-pointer transition-colors ${
                selectedBand === stat.band
                  ? "bg-primary/20 border border-primary/50"
                  : "bg-surface hover:bg-surface-elevated"
              }`}
              onClick={() =>
                onBandSelect(selectedBand === stat.band ? null : stat.band)
              }
            >
              <div className="flex items-center justify-between mb-1">
                <div className="flex items-center gap-2">
                  <div
                    className="w-3 h-3 rounded"
                    style={{ backgroundColor: stat.color }}
                  />
                  <span className="text-xs font-semibold">{stat.band}</span>
                </div>
                <Badge variant="outline" className="text-[10px]">
                  {stat.cellCount} cells
                </Badge>
              </div>
              <div className="grid grid-cols-2 gap-2 mt-2">
                <div>
                  <span className="text-[10px] text-muted-foreground">
                    Avg τ
                  </span>
                  <div className="font-mono text-[10px]">
                    {stat.avgPheromone.toFixed(1)}
                  </div>
                </div>
                <div>
                  <span className="text-[10px] text-muted-foreground">
                    Signals
                  </span>
                  <div className="font-mono text-[10px]">
                    {stat.activeSignals}
                  </div>
                </div>
              </div>
            </button>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SIGNAL STATISTICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface SignalStatisticsPanelProps {
  grid: AtlasGrid;
  selectedSignal: SignalType | null;
  onSignalSelect: (signal: SignalType | null) => void;
}

function SignalStatisticsPanel({
  grid,
  selectedSignal,
  onSignalSelect,
}: SignalStatisticsPanelProps) {
  const signalStats = useMemo(() => {
    return SIGNAL_TYPES.map((signalType) => {
      const cells = grid.cells.filter((c) => c.signalType === signalType);
      const totalIntensity = cells.reduce(
        (sum, c) => sum + c.signalIntensity,
        0,
      );
      const avgIntensity = cells.length > 0 ? totalIntensity / cells.length : 0;

      return {
        signalType,
        count: cells.length,
        totalIntensity,
        avgIntensity,
        color: SIGNAL_COLORS[signalType],
      };
    });
  }, [grid]);

  const signalIcons: Record<SignalType, React.ReactNode> = {
    Discovery: <Search className="w-3 h-3" />,
    Threat: <Shield className="w-3 h-3" />,
    Repair: <Wrench className="w-3 h-3" />,
    Construction: <Hammer className="w-3 h-3" />,
    Neutral: <Target className="w-3 h-3" />,
  };

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Activity className="w-4 h-4" />
          Signal Types
        </CardTitle>
        <CardDescription className="text-xs">
          Pheromone signal classification
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {signalStats.map((stat) => (
            <button
              type="button"
              key={stat.signalType}
              className={`w-full text-left p-2 rounded-lg cursor-pointer transition-colors ${
                selectedSignal === stat.signalType
                  ? "bg-primary/20 border border-primary/50"
                  : "bg-surface hover:bg-surface-elevated"
              }`}
              onClick={() =>
                onSignalSelect(
                  selectedSignal === stat.signalType
                    ? null
                    : (stat.signalType as SignalType),
                )
              }
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div
                    className="w-6 h-6 rounded flex items-center justify-center"
                    style={{ backgroundColor: `${stat.color}40` }}
                  >
                    {signalIcons[stat.signalType as SignalType]}
                  </div>
                  <span className="text-xs font-semibold">
                    {stat.signalType}
                  </span>
                </div>
                <Badge variant="outline" className="text-[10px]">
                  {stat.count}
                </Badge>
              </div>
              {stat.count > 0 && (
                <div className="mt-2">
                  <Progress
                    value={stat.avgIntensity * 100}
                    className="h-1"
                    style={{
                      backgroundColor: `${stat.color}20`,
                    }}
                  />
                </div>
              )}
            </button>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// PHEROMONE STATISTICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface PheromoneStatisticsPanelProps {
  grid: AtlasGrid;
  evaporationRate: number;
  onEvaporationChange: (rate: number) => void;
  depositAmount: number;
  onDepositChange: (amount: number) => void;
}

function PheromoneStatisticsPanel({
  grid,
  evaporationRate,
  onEvaporationChange,
  depositAmount,
  onDepositChange,
}: PheromoneStatisticsPanelProps) {
  const topCells = useMemo(() => {
    return [...grid.cells]
      .sort((a, b) => b.pheromone - a.pheromone)
      .slice(0, 10);
  }, [grid]);

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Flame className="w-4 h-4" />
          Pheromone Dynamics
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-3 gap-2 text-xs">
          <div className="bg-surface p-2 rounded-lg text-center">
            <div className="text-muted-foreground">Total τ</div>
            <div className="font-mono font-semibold">
              {grid.totalPheromone.toFixed(0)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg text-center">
            <div className="text-muted-foreground">Avg τ</div>
            <div className="font-mono font-semibold">
              {grid.avgPheromone.toFixed(2)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg text-center">
            <div className="text-muted-foreground">Max τ</div>
            <div className="font-mono font-semibold">
              {grid.maxPheromone.toFixed(1)}
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Evaporation Rate (ρ)</span>
            <span className="font-mono">{evaporationRate.toFixed(3)}</span>
          </div>
          <Slider
            value={[evaporationRate * 1000]}
            onValueChange={([v]) => onEvaporationChange(v / 1000)}
            min={0}
            max={100}
            step={1}
            className="w-full"
          />
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Deposit Amount (Q)</span>
            <span className="font-mono">{depositAmount.toFixed(1)}</span>
          </div>
          <Slider
            value={[depositAmount]}
            onValueChange={([v]) => onDepositChange(v)}
            min={1}
            max={50}
            step={0.5}
            className="w-full"
          />
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">
            Top 10 Pheromone Cells
          </span>
          <ScrollArea className="h-32">
            <div className="space-y-1">
              {topCells.map((cell, i) => (
                <div
                  key={cell.position}
                  className="flex items-center justify-between text-[10px] px-2 py-1 bg-surface rounded"
                >
                  <span className="text-muted-foreground">
                    #{i + 1} Cell {cell.position}
                  </span>
                  <span className="font-mono">{cell.pheromone.toFixed(1)}</span>
                </div>
              ))}
            </div>
          </ScrollArea>
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
  viewMode: "pheromone" | "signal" | "frequency";
  onViewModeChange: (mode: "pheromone" | "signal" | "frequency") => void;
  antCount: number;
  onAntCountChange: (count: number) => void;
  animationSpeed: number;
  onSpeedChange: (speed: number) => void;
}

function ControlsPanel({
  isRunning,
  onToggleRunning,
  onReset,
  viewMode,
  onViewModeChange,
  antCount,
  onAntCountChange,
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
          <span className="text-xs text-muted-foreground">View Mode</span>
          <Select
            value={viewMode}
            onValueChange={(v) => onViewModeChange(v as any)}
          >
            <SelectTrigger className="h-8 text-xs">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="pheromone">Pheromone Level</SelectItem>
              <SelectItem value="signal">Signal Type</SelectItem>
              <SelectItem value="frequency">Frequency Band</SelectItem>
            </SelectContent>
          </Select>
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Ant Count</span>
            <span className="font-mono">{antCount}</span>
          </div>
          <Slider
            value={[antCount]}
            onValueChange={([v]) => onAntCountChange(v)}
            min={10}
            max={200}
            step={10}
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
// GLOBAL STATS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface GlobalStatsPanelProps {
  grid: AtlasGrid;
  beat: number;
}

function GlobalStatsPanel({ grid, beat }: GlobalStatsPanelProps) {
  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Grid3X3 className="w-4 h-4" />
          Grid Statistics
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Layers className="w-3 h-3" />
              Total Cells
            </div>
            <div className="font-mono font-semibold text-lg">
              {ATLAS_GRID_SIZE}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Activity className="w-3 h-3" />
              Active Signals
            </div>
            <div className="font-mono font-semibold text-lg">
              {grid.activeSignals}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Flame className="w-3 h-3" />
              Total τ
            </div>
            <div className="font-mono font-semibold text-lg">
              {grid.totalPheromone.toFixed(0)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground flex items-center gap-1">
              <Zap className="w-3 h-3" />
              Beat
            </div>
            <div className="font-mono font-semibold text-lg">{beat}</div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function AtlasGridVisualizer() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [grid, setGrid] = useState<AtlasGrid>(() => initializeAtlasGrid());
  const [isRunning, setIsRunning] = useState(true);
  const [selectedCell, setSelectedCell] = useState<AtlasCell | null>(null);
  const [selectedBand, setSelectedBand] = useState<string | null>(null);
  const [selectedSignal, setSelectedSignal] = useState<SignalType | null>(null);
  const [viewMode, setViewMode] = useState<
    "pheromone" | "signal" | "frequency"
  >("pheromone");
  const [evaporationRate, setEvaporationRate] = useState(PHEROMONE_EVAPORATION);
  const [depositAmount, setDepositAmount] = useState(
    PHEROMONE_DEPOSIT_BASE / 10,
  );
  const [antCount, setAntCount] = useState(50);
  const [animationSpeed, setAnimationSpeed] = useState(1);
  const [beat, setBeat] = useState(0);
  const [activeTab, setActiveTab] = useState("frequency");

  // Animation loop
  useEffect(() => {
    if (!isRunning) return;

    const interval = setInterval(() => {
      setGrid((prev) => {
        const newGrid: AtlasGrid = {
          ...prev,
          cells: prev.cells.map((c) => ({ ...c })),
        };

        // Evaporate pheromones
        evaporatePheromones(newGrid, evaporationRate);

        // Simulate ant movement
        simulateAntMovement(newGrid, antCount);

        // Decay signal intensity
        decaySignalIntensity(newGrid);

        return newGrid;
      });

      setBeat((b) => b + 1);
    }, ANIMATION_INTERVAL / animationSpeed);

    return () => clearInterval(interval);
  }, [isRunning, animationSpeed, evaporationRate, antCount]);

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

    // Clear canvas
    ctx.fillStyle = "oklch(10% 0.02 260)";
    ctx.fillRect(0, 0, CANVAS_SIZE, CANVAS_SIZE);

    // Draw cells
    for (let i = 0; i < ATLAS_GRID_SIZE; i++) {
      const cell = grid.cells[i];
      const row = Math.floor(i / GRID_SIZE);
      const col = i % GRID_SIZE;
      const x = col * CELL_SIZE;
      const y = row * CELL_SIZE;

      // Filter by selected band or signal
      const band = getFrequencyBand(cell.position);
      if (selectedBand && band !== selectedBand) continue;
      if (selectedSignal && cell.signalType !== selectedSignal) continue;

      let color: string;

      switch (viewMode) {
        case "pheromone": {
          const intensity = Math.min(1, cell.pheromone / 50);
          color = `oklch(${30 + intensity * 50}% ${0.1 + intensity * 0.1} 30)`;
          break;
        }

        case "signal":
          if (cell.signalType === "Neutral") {
            color = "oklch(20% 0.02 260)";
          } else {
            color =
              SIGNAL_COLORS[cell.signalType] +
              Math.floor(cell.signalIntensity * 255)
                .toString(16)
                .padStart(2, "0");
          }
          break;

        case "frequency":
          color = FREQUENCY_BAND_COLORS[band];
          break;
      }

      ctx.fillStyle = color;
      ctx.fillRect(x, y, CELL_SIZE - 1, CELL_SIZE - 1);

      // Highlight selected cell
      if (selectedCell?.position === cell.position) {
        ctx.strokeStyle = "oklch(90% 0.2 60)";
        ctx.lineWidth = 2;
        ctx.strokeRect(x, y, CELL_SIZE - 1, CELL_SIZE - 1);
      }
    }

    // Draw grid lines (very subtle)
    ctx.strokeStyle = "oklch(20% 0.02 260)";
    ctx.lineWidth = 0.5;

    for (let i = 0; i <= GRID_SIZE; i++) {
      ctx.beginPath();
      ctx.moveTo(i * CELL_SIZE, 0);
      ctx.lineTo(i * CELL_SIZE, CANVAS_SIZE);
      ctx.stroke();

      ctx.beginPath();
      ctx.moveTo(0, i * CELL_SIZE);
      ctx.lineTo(CANVAS_SIZE, i * CELL_SIZE);
      ctx.stroke();
    }
  }, [grid, selectedCell, selectedBand, selectedSignal, viewMode]);

  // Handle canvas click
  const handleCanvasClick = useCallback(
    (event: React.MouseEvent<HTMLCanvasElement>) => {
      const canvas = canvasRef.current;
      if (!canvas) return;

      const rect = canvas.getBoundingClientRect();
      const x = event.clientX - rect.left;
      const y = event.clientY - rect.top;

      const col = Math.floor(x / CELL_SIZE);
      const row = Math.floor(y / CELL_SIZE);

      if (col >= 0 && col < GRID_SIZE && row >= 0 && row < GRID_SIZE) {
        const position = row * GRID_SIZE + col;
        setSelectedCell(grid.cells[position]);
      }
    },
    [grid],
  );

  const handleReset = useCallback(() => {
    setGrid(initializeAtlasGrid());
    setSelectedCell(null);
    setSelectedBand(null);
    setSelectedSignal(null);
    setBeat(0);
  }, []);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-amber-500 to-orange-600 flex items-center justify-center">
            <MapIcon className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-sm font-bold">ATLAS Grid Visualizer</h1>
            <p className="text-xs text-muted-foreground">
              4,096 stigmergic cells · Pheromone dynamics · ACO optimization
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Badge variant={isRunning ? "default" : "secondary"}>
            {isRunning ? "RUNNING" : "PAUSED"}
          </Badge>
          <Badge variant="outline">Beat #{beat}</Badge>
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
            viewMode={viewMode}
            onViewModeChange={setViewMode}
            antCount={antCount}
            onAntCountChange={setAntCount}
            animationSpeed={animationSpeed}
            onSpeedChange={setAnimationSpeed}
          />
          <GlobalStatsPanel grid={grid} beat={beat} />
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
          <CellDetailsPanel
            cell={selectedCell}
            onClose={() => setSelectedCell(null)}
          />
        </div>

        {/* Right panel */}
        <div className="w-80 border-l border-border p-4 overflow-y-auto">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-3 mb-4">
              <TabsTrigger value="frequency" className="text-xs">
                Bands
              </TabsTrigger>
              <TabsTrigger value="signals" className="text-xs">
                Signals
              </TabsTrigger>
              <TabsTrigger value="pheromone" className="text-xs">
                τ Dynamics
              </TabsTrigger>
            </TabsList>

            <TabsContent value="frequency" className="mt-0">
              <FrequencyBandPanel
                grid={grid}
                selectedBand={selectedBand}
                onBandSelect={setSelectedBand}
              />
            </TabsContent>

            <TabsContent value="signals" className="mt-0">
              <SignalStatisticsPanel
                grid={grid}
                selectedSignal={selectedSignal}
                onSignalSelect={setSelectedSignal}
              />
            </TabsContent>

            <TabsContent value="pheromone" className="mt-0">
              <PheromoneStatisticsPanel
                grid={grid}
                evaporationRate={evaporationRate}
                onEvaporationChange={setEvaporationRate}
                depositAmount={depositAmount}
                onDepositChange={setDepositAmount}
              />
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
}

export default AtlasGridVisualizer;
