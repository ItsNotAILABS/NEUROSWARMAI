// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SUPER SUBSTRATE 512 — 512-NODE NEURAL NETWORK VISUALIZATION                                              ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THIS IS NOT A CONVENTIONAL NEURAL NETWORK VISUALIZATION.                                                 ║
// ║  512 nodes with 262,144 weights operating at 12 Hz with Kuramoto coupling.                               ║
// ║  Hebbian plasticity with LTP/LTD. Phase-Amplitude Coupling across shells.                                ║
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
  Brain,
  CircuitBoard,
  Cpu,
  Eye,
  EyeOff,
  Layers,
  Network,
  Pause,
  Play,
  RefreshCw,
  Settings,
  Sparkles,
  Target,
  TrendingUp,
  Waves,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";

import {
  HZ_NODE_NAMES,
  KURAMOTO_K_SUPER,
  PAC_MODULATION_DEPTH,
  PI,
  SUPER_DECAY,
  SUPER_ETA,
  SUPER_LTD_THRESHOLD,
  SUPER_LTP_THRESHOLD,
  SUPER_NODE_COUNT,
  SUPER_WEIGHT_COUNT,
  TOTAL_SHELLS,
  TWO_PI,
  calculateKuramotoOrderParameter,
  clamp,
  computeSuperFrequency,
  hebbianUpdate,
  lerp,
} from "@/lib/substrate/constants";

import type {
  SuperHebbianResult,
  SuperNode,
  SuperSubstrate,
  SuperWeightMatrix,
} from "@/lib/substrate/types";

// ═══════════════════════════════════════════════════════════════════════════════
// VISUALIZATION CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const CANVAS_SIZE = 800;
const NODE_RADIUS = 3;
const ACTIVE_NODE_RADIUS = 5;
const SHELL_RADIUS_BASE = 50;
const SHELL_RADIUS_INCREMENT = 55;
const ANIMATION_INTERVAL = 83; // ~12 Hz
const CONNECTION_OPACITY_BASE = 0.1;
const _CONNECTION_OPACITY_ACTIVE = 0.4;

// Color schemes for shells
const _SHELL_COLORS = [
  "oklch(70% 0.15 30)", // Shell 0: Red-orange
  "oklch(70% 0.15 60)", // Shell 1: Orange
  "oklch(70% 0.15 90)", // Shell 2: Yellow
  "oklch(70% 0.15 120)", // Shell 3: Yellow-green
  "oklch(70% 0.15 150)", // Shell 4: Green
  "oklch(70% 0.15 180)", // Shell 5: Cyan
  "oklch(70% 0.15 210)", // Shell 6: Light blue
  "oklch(70% 0.15 240)", // Shell 7: Blue
  "oklch(70% 0.15 270)", // Shell 8: Purple
  "oklch(70% 0.15 300)", // Shell 9: Magenta
  "oklch(70% 0.15 330)", // Shell 10: Pink
  "oklch(70% 0.15 360)", // Shell 11: Red
];

// ═══════════════════════════════════════════════════════════════════════════════
// SUBSTRATE INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════

function initializeSuperNodes(): SuperNode[] {
  const nodes: SuperNode[] = [];

  for (let i = 0; i < SUPER_NODE_COUNT; i++) {
    const shellId = Math.floor(i / (SUPER_NODE_COUNT / TOTAL_SHELLS));
    const frequency = computeSuperFrequency(i, shellId);

    nodes.push({
      id: i,
      frequency,
      phase: (i / SUPER_NODE_COUNT) * TWO_PI,
      amplitude: 1.0,
      activation: 0.5 + Math.random() * 0.3,
      threshold: 0.5,
      refractoryRemaining: 0,
      shellId,
      localCoherence: 0.75,
      cumulativeActivation: 0,
    });
  }

  return nodes;
}

function initializeSuperWeights(): SuperWeightMatrix {
  const blockSize = 64;
  const numBlocks = 64;
  const blocks: number[][] = [];

  for (let b = 0; b < numBlocks; b++) {
    const block: number[] = [];
    for (let w = 0; w < blockSize * blockSize; w++) {
      const row = Math.floor(w / blockSize);
      const col = w % blockSize;
      const globalRow = Math.floor(b / 8) * blockSize + row;
      const globalCol = (b % 8) * blockSize + col;

      // Weights stronger for nearby nodes
      const distance = Math.abs(globalRow - globalCol);
      const baseWeight = 0.3 * Math.exp(-distance / 50);
      block.push(baseWeight + ((globalRow * 7 + globalCol * 13) % 100) / 1000);
    }
    blocks.push(block);
  }

  return {
    blocks,
    blockSize,
    numBlocks,
    totalWeights: SUPER_WEIGHT_COUNT,
    lastUpdate: Date.now(),
    ltpCount: 0,
    ltdCount: 0,
  };
}

function initializeSuperSubstrate(
  name: string,
  shellId: number,
): SuperSubstrate {
  return {
    nodes: initializeSuperNodes(),
    weights: initializeSuperWeights(),
    shellId,
    name,
    coherence: 0.75,
    kuramotoR: 0,
    totalActivations: 0,
    beat: 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUBSTRATE UPDATE FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function updateKuramotoPhases(
  nodes: SuperNode[],
  couplingStrength: number = KURAMOTO_K_SUPER,
): void {
  const _N = nodes.length;
  const phases = nodes.map((n) => n.phase);
  const { r, psi } = calculateKuramotoOrderParameter(phases);

  for (const node of nodes) {
    // Kuramoto coupling: dθ/dt = ω + K*r*sin(Ψ - θ)
    const coupling = couplingStrength * r * Math.sin(psi - node.phase);
    const dt = 1 / 12; // 12 Hz update rate
    node.phase =
      (node.phase + (node.frequency * TWO_PI + coupling) * dt) % TWO_PI;
    node.localCoherence = r;
  }
}

function updatePACModulation(nodes: SuperNode[]): void {
  // Phase-Amplitude Coupling: slower nodes modulate faster node amplitudes
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];

    // Find slower reference node (lower shell)
    if (node.shellId > 0) {
      const refNodeIdx = Math.floor(
        (node.shellId - 1) * (SUPER_NODE_COUNT / TOTAL_SHELLS) +
          (i % (SUPER_NODE_COUNT / TOTAL_SHELLS)),
      );
      const refNode = nodes[refNodeIdx];

      // Modulate amplitude based on slower node's phase
      const modulation =
        (PAC_MODULATION_DEPTH * (1 + Math.cos(refNode.phase))) / 2;
      node.amplitude = clamp(
        node.amplitude * (1 - PAC_MODULATION_DEPTH / 2 + modulation),
        0,
        1,
      );
    }
  }
}

function updateNodeActivations(
  nodes: SuperNode[],
  weights: SuperWeightMatrix,
): void {
  const blockSize = weights.blockSize;

  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];

    if (node.refractoryRemaining > 0) {
      node.refractoryRemaining--;
      node.activation = 0;
      continue;
    }

    // Calculate weighted input from connected nodes
    let totalInput = 0;
    const blockRow = Math.floor(i / blockSize);

    for (let j = 0; j < Math.min(128, nodes.length); j++) {
      const blockCol = Math.floor(j / blockSize);
      const blockIdx = blockRow * 8 + blockCol;

      if (blockIdx < weights.blocks.length) {
        const localRow = i % blockSize;
        const localCol = j % blockSize;
        const weightIdx = localRow * blockSize + localCol;
        const weight = weights.blocks[blockIdx][weightIdx];
        totalInput += weight * nodes[j].activation * nodes[j].amplitude;
      }
    }

    // Apply sigmoid activation with phase modulation
    const phaseModulation = (1 + Math.cos(node.phase)) / 2;
    const rawActivation = 1 / (1 + Math.exp(-totalInput * phaseModulation));

    // Fire if above threshold
    if (rawActivation > node.threshold) {
      node.activation = rawActivation;
      node.cumulativeActivation += rawActivation;
      node.refractoryRemaining = 2; // 2 beat refractory period
    } else {
      node.activation = rawActivation * 0.3; // Subthreshold activity
    }
  }
}

function performHebbianUpdate(
  nodes: SuperNode[],
  weights: SuperWeightMatrix,
): SuperHebbianResult {
  let ltpEvents = 0;
  let ltdEvents = 0;
  let totalUpdates = 0;
  let totalChange = 0;
  let maxChange = 0;

  const blockSize = weights.blockSize;

  // Sample a subset of weights for efficiency
  const sampleSize = 1000;

  for (let s = 0; s < sampleSize; s++) {
    const i = Math.floor(Math.random() * nodes.length);
    const j = Math.floor(Math.random() * Math.min(128, nodes.length));

    const blockRow = Math.floor(i / blockSize);
    const blockCol = Math.floor(j / blockSize);
    const blockIdx = blockRow * 8 + blockCol;

    if (blockIdx < weights.blocks.length) {
      const localRow = i % blockSize;
      const localCol = j % blockSize;
      const weightIdx = localRow * blockSize + localCol;

      const currentWeight = weights.blocks[blockIdx][weightIdx];
      const { newWeight, isLTP, isLTD } = hebbianUpdate(
        currentWeight,
        nodes[i].activation,
        nodes[j].activation,
        SUPER_ETA,
        SUPER_DECAY,
      );

      const change = Math.abs(newWeight - currentWeight);
      totalChange += change;
      maxChange = Math.max(maxChange, change);

      weights.blocks[blockIdx][weightIdx] = newWeight;
      totalUpdates++;

      if (isLTP) ltpEvents++;
      if (isLTD) ltdEvents++;
    }
  }

  weights.ltpCount += ltpEvents;
  weights.ltdCount += ltdEvents;
  weights.lastUpdate = Date.now();

  return {
    ltpEvents,
    ltdEvents,
    totalUpdates,
    meanWeightChange: totalUpdates > 0 ? totalChange / totalUpdates : 0,
    maxWeightChange: maxChange,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// VISUALIZATION HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

function getNodePosition(
  nodeId: number,
  shellId: number,
  centerX: number,
  centerY: number,
  nodesPerShell: number,
): { x: number; y: number } {
  const radius = SHELL_RADIUS_BASE + shellId * SHELL_RADIUS_INCREMENT;
  const angleOffset = (nodeId % nodesPerShell) / nodesPerShell;
  const angle = angleOffset * TWO_PI - PI / 2;

  return {
    x: centerX + radius * Math.cos(angle),
    y: centerY + radius * Math.sin(angle),
  };
}

function getActivationColor(activation: number, shellId: number): string {
  const hue = (shellId / TOTAL_SHELLS) * 360;
  const lightness = 40 + activation * 40;
  const saturation = 60 + activation * 30;
  return `oklch(${lightness}% 0.${Math.floor(saturation / 10)} ${hue})`;
}

// ═══════════════════════════════════════════════════════════════════════════════
// NODE DETAILS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface NodeDetailsPanelProps {
  node: SuperNode | null;
  onClose: () => void;
}

function NodeDetailsPanel({ node, onClose }: NodeDetailsPanelProps) {
  if (!node) return null;

  const shellName = HZ_NODE_NAMES[node.shellId] || `Shell ${node.shellId}`;

  return (
    <Card className="absolute top-4 right-4 w-80 bg-background/95 backdrop-blur-sm border-border shadow-xl">
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <CardTitle className="text-sm font-semibold">
            Node {node.id}
          </CardTitle>
          <Button variant="ghost" size="sm" onClick={onClose}>
            <EyeOff className="w-4 h-4" />
          </Button>
        </div>
        <CardDescription className="text-xs">
          {shellName} Shell (ID: {node.shellId})
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="space-y-1">
            <span className="text-muted-foreground">Frequency</span>
            <div className="font-mono font-semibold">
              {node.frequency.toFixed(2)} Hz
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Phase</span>
            <div className="font-mono font-semibold">
              {((node.phase * 180) / PI).toFixed(1)}°
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Activation</span>
            <div className="font-mono font-semibold">
              {(node.activation * 100).toFixed(1)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Amplitude</span>
            <div className="font-mono font-semibold">
              {(node.amplitude * 100).toFixed(1)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Threshold</span>
            <div className="font-mono font-semibold">
              {(node.threshold * 100).toFixed(1)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Coherence</span>
            <div className="font-mono font-semibold">
              {(node.localCoherence * 100).toFixed(1)}%
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Cumulative</span>
            <div className="font-mono font-semibold">
              {node.cumulativeActivation.toFixed(2)}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Refractory</span>
            <div className="font-mono font-semibold">
              {node.refractoryRemaining} beats
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">
            Activation Level
          </span>
          <Progress value={node.activation * 100} className="h-2" />
        </div>

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">Local Coherence</span>
          <Progress value={node.localCoherence * 100} className="h-2" />
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHELL STATISTICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface ShellStatisticsPanelProps {
  nodes: SuperNode[];
  selectedShell: number | null;
  onShellSelect: (shell: number | null) => void;
}

function ShellStatisticsPanel({
  nodes,
  selectedShell,
  onShellSelect,
}: ShellStatisticsPanelProps) {
  interface ShellStat {
    shellId: number;
    name: string;
    avgActivation: number;
    avgCoherence: number;
    activeCount: number;
    totalNodes: number;
  }

  const shellStats = useMemo(() => {
    const stats: ShellStat[] = [];
    const _nodesPerShell = SUPER_NODE_COUNT / TOTAL_SHELLS;

    for (let s = 0; s < TOTAL_SHELLS; s++) {
      const shellNodes = nodes.filter((n) => n.shellId === s);
      const avgActivation =
        shellNodes.length > 0
          ? shellNodes.reduce((sum, n) => sum + n.activation, 0) /
            shellNodes.length
          : 0;
      const avgCoherence =
        shellNodes.length > 0
          ? shellNodes.reduce((sum, n) => sum + n.localCoherence, 0) /
            shellNodes.length
          : 0;
      const activeCount = shellNodes.filter((n) => n.activation > 0.5).length;

      stats.push({
        shellId: s,
        name: HZ_NODE_NAMES[s] || `Shell ${s}`,
        avgActivation,
        avgCoherence,
        activeCount,
        totalNodes: shellNodes.length,
      });
    }

    return stats;
  }, [nodes]);

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Layers className="w-4 h-4" />
          Shell Statistics
        </CardTitle>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-64">
          <div className="space-y-2">
            {shellStats.map((stat) => (
              <button
                type="button"
                key={stat.shellId}
                className={`w-full text-left p-2 rounded-lg cursor-pointer transition-colors ${
                  selectedShell === stat.shellId
                    ? "bg-primary/20 border border-primary/50"
                    : "bg-surface hover:bg-surface-elevated"
                }`}
                onClick={() =>
                  onShellSelect(
                    selectedShell === stat.shellId ? null : stat.shellId,
                  )
                }
              >
                <div className="flex items-center justify-between mb-1">
                  <span className="text-xs font-semibold">{stat.name}</span>
                  <Badge variant="outline" className="text-[10px]">
                    {stat.activeCount}/{stat.totalNodes}
                  </Badge>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div>
                    <span className="text-[10px] text-muted-foreground">
                      Activation
                    </span>
                    <Progress
                      value={stat.avgActivation * 100}
                      className="h-1 mt-1"
                    />
                  </div>
                  <div>
                    <span className="text-[10px] text-muted-foreground">
                      Coherence
                    </span>
                    <Progress
                      value={stat.avgCoherence * 100}
                      className="h-1 mt-1"
                    />
                  </div>
                </div>
              </button>
            ))}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// HEBBIAN STATISTICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface HebbianStatisticsPanelProps {
  weights: SuperWeightMatrix;
  lastResult: SuperHebbianResult | null;
}

function HebbianStatisticsPanel({
  weights,
  lastResult,
}: HebbianStatisticsPanelProps) {
  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Network className="w-4 h-4" />
          Hebbian Plasticity
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="space-y-1">
            <span className="text-muted-foreground">Total Weights</span>
            <div className="font-mono font-semibold">
              {weights.totalWeights.toLocaleString()}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Block Size</span>
            <div className="font-mono font-semibold">
              {weights.blockSize}×{weights.blockSize}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">LTP Events</span>
            <div className="font-mono font-semibold text-green-500">
              {weights.ltpCount.toLocaleString()}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">LTD Events</span>
            <div className="font-mono font-semibold text-red-500">
              {weights.ltdCount.toLocaleString()}
            </div>
          </div>
        </div>

        {lastResult && (
          <>
            <Separator />
            <div className="space-y-2">
              <span className="text-xs text-muted-foreground">Last Update</span>
              <div className="grid grid-cols-2 gap-2 text-xs">
                <div className="bg-surface p-2 rounded">
                  <div className="text-muted-foreground">LTP</div>
                  <div className="font-mono text-green-500">
                    {lastResult.ltpEvents}
                  </div>
                </div>
                <div className="bg-surface p-2 rounded">
                  <div className="text-muted-foreground">LTD</div>
                  <div className="font-mono text-red-500">
                    {lastResult.ltdEvents}
                  </div>
                </div>
                <div className="bg-surface p-2 rounded">
                  <div className="text-muted-foreground">Mean Δw</div>
                  <div className="font-mono">
                    {lastResult.meanWeightChange.toExponential(2)}
                  </div>
                </div>
                <div className="bg-surface p-2 rounded">
                  <div className="text-muted-foreground">Max Δw</div>
                  <div className="font-mono">
                    {lastResult.maxWeightChange.toExponential(2)}
                  </div>
                </div>
              </div>
            </div>
          </>
        )}

        <Separator />

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">LTP Threshold</span>
            <span className="font-mono">{SUPER_LTP_THRESHOLD}</span>
          </div>
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">LTD Threshold</span>
            <span className="font-mono">{SUPER_LTD_THRESHOLD}</span>
          </div>
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Learning Rate (η)</span>
            <span className="font-mono">{SUPER_ETA}</span>
          </div>
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Decay Rate (λ)</span>
            <span className="font-mono">{SUPER_DECAY}</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// KURAMOTO PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface KuramotoPanelProps {
  nodes: SuperNode[];
  couplingStrength: number;
  onCouplingChange: (value: number) => void;
}

function KuramotoPanel({
  nodes,
  couplingStrength,
  onCouplingChange,
}: KuramotoPanelProps) {
  const phases = useMemo(() => nodes.map((n) => n.phase), [nodes]);
  const { r, psi } = useMemo(
    () => calculateKuramotoOrderParameter(phases),
    [phases],
  );

  const phaseDistribution = useMemo(() => {
    const bins = new Array(36).fill(0);
    for (const phase of phases) {
      const bin = Math.floor((phase / TWO_PI) * 36) % 36;
      bins[bin]++;
    }
    const maxBin = Math.max(...bins);
    return bins.map((b) => b / maxBin);
  }, [phases]);

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Waves className="w-4 h-4" />
          Kuramoto Coupling
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="space-y-1">
            <span className="text-muted-foreground">Order Parameter (r)</span>
            <div className="font-mono font-semibold text-lg">
              {r.toFixed(4)}
            </div>
          </div>
          <div className="space-y-1">
            <span className="text-muted-foreground">Mean Phase (Ψ)</span>
            <div className="font-mono font-semibold text-lg">
              {((psi * 180) / PI).toFixed(1)}°
            </div>
          </div>
        </div>

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">Synchronization</span>
          <Progress value={r * 100} className="h-3" />
          <div className="flex justify-between text-[10px] text-muted-foreground">
            <span>Desync</span>
            <span>Full Sync</span>
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs text-muted-foreground">
              Coupling Strength (K)
            </span>
            <span className="text-xs font-mono">
              {couplingStrength.toFixed(3)}
            </span>
          </div>
          <Slider
            value={[couplingStrength * 100]}
            onValueChange={([v]) => onCouplingChange(v / 100)}
            min={0}
            max={20}
            step={0.1}
            className="w-full"
          />
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">
            Phase Distribution
          </span>
          <div className="flex items-end h-12 gap-[2px]">
            {phaseDistribution.map((height) => (
              <div
                key={height.toFixed(8)}
                className="flex-1 bg-primary/60 rounded-t"
                style={{ height: `${height * 100}%` }}
              />
            ))}
          </div>
          <div className="flex justify-between text-[10px] text-muted-foreground">
            <span>0°</span>
            <span>180°</span>
            <span>360°</span>
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
  showConnections: boolean;
  onToggleConnections: () => void;
  showLabels: boolean;
  onToggleLabels: () => void;
  animationSpeed: number;
  onSpeedChange: (speed: number) => void;
}

function ControlsPanel({
  isRunning,
  onToggleRunning,
  onReset,
  showConnections,
  onToggleConnections,
  showLabels,
  onToggleLabels,
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

        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs">Show Connections</span>
            <Switch
              checked={showConnections}
              onCheckedChange={onToggleConnections}
            />
          </div>
          <div className="flex items-center justify-between">
            <span className="text-xs">Show Labels</span>
            <Switch checked={showLabels} onCheckedChange={onToggleLabels} />
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <span className="text-xs text-muted-foreground">
              Animation Speed
            </span>
            <span className="text-xs font-mono">{animationSpeed}x</span>
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
// GLOBAL METRICS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface GlobalMetricsPanelProps {
  substrate: SuperSubstrate;
}

function GlobalMetricsPanel({ substrate }: GlobalMetricsPanelProps) {
  const avgActivation = useMemo(
    () =>
      substrate.nodes.reduce((sum, n) => sum + n.activation, 0) /
      substrate.nodes.length,
    [substrate.nodes],
  );

  const avgCoherence = useMemo(
    () =>
      substrate.nodes.reduce((sum, n) => sum + n.localCoherence, 0) /
      substrate.nodes.length,
    [substrate.nodes],
  );

  const activeNodes = useMemo(
    () => substrate.nodes.filter((n) => n.activation > 0.5).length,
    [substrate.nodes],
  );

  const totalCumulative = useMemo(
    () => substrate.nodes.reduce((sum, n) => sum + n.cumulativeActivation, 0),
    [substrate.nodes],
  );

  return (
    <Card className="bg-background/95 backdrop-blur-sm border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Activity className="w-4 h-4" />
          Global Metrics
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Brain className="w-3 h-3" />
              <span>Total Nodes</span>
            </div>
            <div className="font-mono font-semibold text-lg">
              {SUPER_NODE_COUNT}
            </div>
          </div>

          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Zap className="w-3 h-3" />
              <span>Active Nodes</span>
            </div>
            <div className="font-mono font-semibold text-lg">{activeNodes}</div>
          </div>

          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <TrendingUp className="w-3 h-3" />
              <span>Avg Activation</span>
            </div>
            <div className="font-mono font-semibold text-lg">
              {(avgActivation * 100).toFixed(1)}%
            </div>
          </div>

          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Target className="w-3 h-3" />
              <span>Coherence</span>
            </div>
            <div className="font-mono font-semibold text-lg">
              {(avgCoherence * 100).toFixed(1)}%
            </div>
          </div>

          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Cpu className="w-3 h-3" />
              <span>Beat</span>
            </div>
            <div className="font-mono font-semibold text-lg">
              {substrate.beat}
            </div>
          </div>

          <div className="bg-surface p-3 rounded-lg">
            <div className="flex items-center gap-2 text-muted-foreground mb-1">
              <Sparkles className="w-3 h-3" />
              <span>Cumulative</span>
            </div>
            <div className="font-mono font-semibold text-lg">
              {totalCumulative.toFixed(0)}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function SuperSubstrate512() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [substrate, setSubstrate] = useState<SuperSubstrate>(() =>
    initializeSuperSubstrate("Primary Substrate", 0),
  );
  const [isRunning, setIsRunning] = useState(true);
  const [selectedNode, setSelectedNode] = useState<SuperNode | null>(null);
  const [selectedShell, setSelectedShell] = useState<number | null>(null);
  const [showConnections, setShowConnections] = useState(false);
  const [showLabels, setShowLabels] = useState(false);
  const [animationSpeed, setAnimationSpeed] = useState(1);
  const [couplingStrength, setCouplingStrength] = useState(KURAMOTO_K_SUPER);
  const [lastHebbianResult, setLastHebbianResult] =
    useState<SuperHebbianResult | null>(null);
  const [activeTab, setActiveTab] = useState("visualization");

  // Animation loop
  useEffect(() => {
    if (!isRunning) return;

    const interval = setInterval(() => {
      setSubstrate((prev) => {
        const newNodes = [...prev.nodes.map((n) => ({ ...n }))];
        const newWeights = {
          ...prev.weights,
          blocks: prev.weights.blocks.map((b) => [...b]),
        };

        // Update phases with Kuramoto coupling
        updateKuramotoPhases(newNodes, couplingStrength);

        // Update PAC modulation
        updatePACModulation(newNodes);

        // Update node activations
        updateNodeActivations(newNodes, newWeights);

        // Perform Hebbian update
        const hebbianResult = performHebbianUpdate(newNodes, newWeights);
        setLastHebbianResult(hebbianResult);

        // Calculate new coherence
        const phases = newNodes.map((n) => n.phase);
        const { r } = calculateKuramotoOrderParameter(phases);

        return {
          ...prev,
          nodes: newNodes,
          weights: newWeights,
          kuramotoR: r,
          coherence: r,
          beat: prev.beat + 1,
          totalActivations:
            prev.totalActivations +
            newNodes.filter((n) => n.activation > 0.5).length,
        };
      });
    }, ANIMATION_INTERVAL / animationSpeed);

    return () => clearInterval(interval);
  }, [isRunning, animationSpeed, couplingStrength]);

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

    const centerX = CANVAS_SIZE / 2;
    const centerY = CANVAS_SIZE / 2;
    const nodesPerShell = SUPER_NODE_COUNT / TOTAL_SHELLS;

    // Draw shell circles
    for (let s = 0; s < TOTAL_SHELLS; s++) {
      const radius = SHELL_RADIUS_BASE + s * SHELL_RADIUS_INCREMENT;
      ctx.beginPath();
      ctx.arc(centerX, centerY, radius, 0, TWO_PI);
      ctx.strokeStyle =
        selectedShell === s ? "oklch(70% 0.15 180)" : "oklch(30% 0.05 260)";
      ctx.lineWidth = selectedShell === s ? 2 : 1;
      ctx.stroke();
    }

    // Draw connections (if enabled and limited for performance)
    if (showConnections) {
      ctx.globalAlpha = CONNECTION_OPACITY_BASE;
      const sampleConnections = 500;

      for (let i = 0; i < sampleConnections; i++) {
        const nodeA =
          substrate.nodes[Math.floor(Math.random() * substrate.nodes.length)];
        const nodeB =
          substrate.nodes[
            Math.floor(Math.random() * Math.min(128, substrate.nodes.length))
          ];

        if (nodeA.activation > 0.3 && nodeB.activation > 0.3) {
          const posA = getNodePosition(
            nodeA.id,
            nodeA.shellId,
            centerX,
            centerY,
            nodesPerShell,
          );
          const posB = getNodePosition(
            nodeB.id,
            nodeB.shellId,
            centerX,
            centerY,
            nodesPerShell,
          );

          ctx.beginPath();
          ctx.moveTo(posA.x, posA.y);
          ctx.lineTo(posB.x, posB.y);
          ctx.strokeStyle = `oklch(60% 0.1 ${(nodeA.shellId / TOTAL_SHELLS) * 360})`;
          ctx.lineWidth = 0.5;
          ctx.stroke();
        }
      }
      ctx.globalAlpha = 1;
    }

    // Draw nodes
    for (const node of substrate.nodes) {
      if (selectedShell !== null && node.shellId !== selectedShell) continue;

      const { x, y } = getNodePosition(
        node.id,
        node.shellId,
        centerX,
        centerY,
        nodesPerShell,
      );
      const radius = node.activation > 0.5 ? ACTIVE_NODE_RADIUS : NODE_RADIUS;
      const color = getActivationColor(node.activation, node.shellId);

      ctx.beginPath();
      ctx.arc(x, y, radius, 0, TWO_PI);
      ctx.fillStyle = color;
      ctx.fill();

      // Draw selection highlight
      if (selectedNode?.id === node.id) {
        ctx.beginPath();
        ctx.arc(x, y, radius + 3, 0, TWO_PI);
        ctx.strokeStyle = "oklch(90% 0.2 60)";
        ctx.lineWidth = 2;
        ctx.stroke();
      }
    }

    // Draw labels (if enabled)
    if (showLabels) {
      ctx.font = "10px monospace";
      ctx.fillStyle = "oklch(70% 0.05 260)";
      ctx.textAlign = "center";

      for (let s = 0; s < TOTAL_SHELLS; s++) {
        const radius = SHELL_RADIUS_BASE + s * SHELL_RADIUS_INCREMENT;
        const label = HZ_NODE_NAMES[s] || `S${s}`;
        ctx.fillText(label, centerX, centerY - radius - 10);
      }
    }
  }, [substrate, selectedNode, selectedShell, showConnections, showLabels]);

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
      const nodesPerShell = SUPER_NODE_COUNT / TOTAL_SHELLS;

      // Find clicked node
      let closestNode: SuperNode | null = null;
      let closestDistance = Number.POSITIVE_INFINITY;

      for (const node of substrate.nodes) {
        if (selectedShell !== null && node.shellId !== selectedShell) continue;

        const pos = getNodePosition(
          node.id,
          node.shellId,
          centerX,
          centerY,
          nodesPerShell,
        );
        const distance = Math.sqrt((x - pos.x) ** 2 + (y - pos.y) ** 2);

        if (distance < 10 && distance < closestDistance) {
          closestNode = node;
          closestDistance = distance;
        }
      }

      setSelectedNode(closestNode);
    },
    [substrate.nodes, selectedShell],
  );

  const handleReset = useCallback(() => {
    setSubstrate(initializeSuperSubstrate("Primary Substrate", 0));
    setSelectedNode(null);
    setSelectedShell(null);
    setLastHebbianResult(null);
  }, []);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-purple-500 to-blue-600 flex items-center justify-center">
            <Brain className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-sm font-bold">SuperSubstrate 512</h1>
            <p className="text-xs text-muted-foreground">
              512 nodes · 262,144 weights · Kuramoto coupling · Hebbian
              plasticity
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <Badge variant={isRunning ? "default" : "secondary"}>
            {isRunning ? "RUNNING" : "PAUSED"}
          </Badge>
          <Badge variant="outline">Beat #{substrate.beat}</Badge>
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
            showConnections={showConnections}
            onToggleConnections={() => setShowConnections(!showConnections)}
            showLabels={showLabels}
            onToggleLabels={() => setShowLabels(!showLabels)}
            animationSpeed={animationSpeed}
            onSpeedChange={setAnimationSpeed}
          />
          <GlobalMetricsPanel substrate={substrate} />
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
          <NodeDetailsPanel
            node={selectedNode}
            onClose={() => setSelectedNode(null)}
          />
        </div>

        {/* Right panel */}
        <div className="w-80 border-l border-border p-4 overflow-y-auto">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-3 mb-4">
              <TabsTrigger value="shells" className="text-xs">
                Shells
              </TabsTrigger>
              <TabsTrigger value="kuramoto" className="text-xs">
                Kuramoto
              </TabsTrigger>
              <TabsTrigger value="hebbian" className="text-xs">
                Hebbian
              </TabsTrigger>
            </TabsList>

            <TabsContent value="shells" className="mt-0">
              <ShellStatisticsPanel
                nodes={substrate.nodes}
                selectedShell={selectedShell}
                onShellSelect={setSelectedShell}
              />
            </TabsContent>

            <TabsContent value="kuramoto" className="mt-0">
              <KuramotoPanel
                nodes={substrate.nodes}
                couplingStrength={couplingStrength}
                onCouplingChange={setCouplingStrength}
              />
            </TabsContent>

            <TabsContent value="hebbian" className="mt-0">
              <HebbianStatisticsPanel
                weights={substrate.weights}
                lastResult={lastHebbianResult}
              />
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
}

export default SuperSubstrate512;
