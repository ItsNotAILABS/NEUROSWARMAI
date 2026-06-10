import { Sheet, SheetContent } from "@/components/ui/sheet";
import { Toaster } from "@/components/ui/sonner";
import { Menu } from "lucide-react";
import { useEffect, useMemo, useRef, useState } from "react";
import { ArtifactModal } from "./components/ArtifactModal";
import { ChatArea } from "./components/ChatArea";
import { CommandPalette } from "./components/CommandPalette";
import { EvolutionPanel } from "./components/EvolutionPanel";
import { FactionPanel } from "./components/FactionPanel";
import { GeoResonanceScanner } from "./components/GeoResonanceScanner";
import { LoginScreen } from "./components/LoginScreen";
import MissionControl from "./components/MissionControl";
import { NeuralArchitect } from "./components/NeuralArchitect";
import { RightRail } from "./components/RightRail";
import { Sidebar } from "./components/Sidebar";
import { TradePanel } from "./components/TradePanel";
import { AnalyticsDashboard } from "./components/analytics/AnalyticsDashboard";
import { AtlasGridVisualizer } from "./components/colony/AtlasGridVisualizer";
import { ColonyCoordinatorUI } from "./components/colony/ColonyCoordinatorUI";
import { GRPECommandCenter } from "./components/enterprise/GRPECommandCenter";
import { TeamDashboard } from "./components/enterprise/TeamDashboard";
import { GovernanceCenter } from "./components/governance/GovernanceCenter";
import { AutoChat } from "./components/organism/AutoChat";
import { GenesisDashboard } from "./components/organism/GenesisDashboard";
import { JarvisCommandCenter } from "./components/organism/JarvisCommandCenter";
import { ModelsDashboard } from "./components/models/ModelsDashboard";
import { AIUXPanel } from "./components/ai/AIUXPanel";
import { MultiEngineDashboard } from "./components/ai/MultiEngineDashboard";
import { MacroWorldCanvas } from "./components/organism/MacroWorldCanvas";
import { NeuroEmergenceCore } from "./components/organism/NeuroEmergenceCore";
import { NovaCanvas } from "./components/organism/NovaCanvas";
import { OrganismGenerator } from "./components/organism/OrganismGenerator";
import { OrganismInventory } from "./components/organism/OrganismInventory";
import { OrganismLiveViewer } from "./components/organism/OrganismLiveViewer";
import { OrganismMarketplace } from "./components/organism/OrganismMarketplace";
import { OrganismWorkforce } from "./components/organism/OrganismWorkforce";
import { OroCommandCenter } from "./components/organism/OroCommandCenter";
import { TasPanel } from "./components/organism/TasPanel";
import { QuantumDeepMemoryVisualizer } from "./components/quantum/QuantumDeepMemoryVisualizer";
import { SuperSubstrate512 } from "./components/substrate/SuperSubstrate512";
import { TokenDashboard } from "./components/token/TokenDashboard";
import {
  type AgentTask,
  type Artifact,
  INITIAL_ARTIFACTS,
  INITIAL_TASKS,
  INITIAL_WORKSPACES,
  type Message,
  type Workspace,
} from "./data/mockData";
import {
  initNovaState,
  seedNovaFromOrganism,
  tickNova,
} from "./data/novaEngine";
import { MOCK_ORGANISMS, type MockOrganism } from "./data/organisms";
import { initTASState, tickTAS } from "./data/tasEngine";
import { useInternetIdentity } from "./hooks/useInternetIdentity";
import { useOrganisms } from "./hooks/useOrganisms";

// ─── Organism response engine ────────────────────────────────────────────────
// Each specialization has a tailored command-layer response (brief + expert).
const SPEC_RESPONSES: Record<string, (name: string) => string> = {
  Communication: (name) =>
    `${name} — Communication layer active. Your message has been parsed, contextualized, and routed through the organizational matrix. All recipient nodes aligned. I'm preparing structured output and routing to relevant specialists. What format do you need the deliverable in?`,
  Orchestration: (name) =>
    `${name} — Orchestration protocol engaged. Task decomposed and routed to the relevant execution nodes across the organism workforce. I'm coordinating cross-domain synthesis — unified deliverable assembling. Estimated completion: 2 minutes. Do you want a live progress trace?`,
  SoftwareEngineering: (name) =>
    `${name} — Engineering layer online. Request parsed across full stack: architecture, implementation, testing, deployment. Integration surfaces mapped and optimal build path selected. Ready to generate implementation — full codebase or modular breakdown first?`,
  DevOps: (name) =>
    `${name} — Infrastructure scan complete. Deployment pipeline, resource utilization, and system health analyzed across all environments. Optimization opportunities and reliability risks identified. Runbook and IaC templates ready on demand.`,
  Legal: (name) =>
    `${name} — Legal analysis initiated. Jurisdiction framework loaded, applicable statutes cross-referenced, risk vectors enumerated. High-risk clauses flagged. Redlines and amendment memo assembling now. What jurisdiction are we operating in?`,
  Compliance: (name) =>
    `${name} — Compliance audit initiated. Regulatory framework mapped for all applicable jurisdictions. Compliance gaps identified. Remediation plan with priority rankings assembled. Do you need the full audit trail or the executive summary?`,
  Finance: (name) =>
    `${name} — Financial models running. Balance sheet, cash flow projections, and market benchmarks loaded. Scenario analysis in progress. Anomalies flagged for review. Priority: risk summary or opportunity analysis first?`,
  Marketing: (name) =>
    `${name} — Campaign architecture initialized. Audience segments mapped, competitive landscape scanned, brand voice calibrated. GTM strategy with channel breakdown, content calendar, and KPI framework assembling. What's the primary conversion objective?`,
  Brand: (name) =>
    `${name} — Brand analysis complete. Voice consistency scored, visual system evaluated, competitive positioning mapped. Inconsistencies across touchpoints identified. Where's the priority: visual identity, messaging architecture, or brand positioning?`,
  Campaign: (name) =>
    `${name} — Campaign intelligence active. Analyzed comparable campaign archetypes, benchmarked against high-performing initiatives. Message-market fit scored. Creative brief structured. Full campaign architecture with channel strategy and KPIs assembling now.`,
  DataAnalysis: (name) =>
    `${name} — Dataset ingested and indexed. Multi-variate analysis running across all available signal layers. Statistically significant patterns identified with confidence intervals >95%. Anomaly clusters flagged. Full report with visualizations assembling.`,
  Strategy: (name) =>
    `${name} — Strategic landscape mapped. Opportunity surfaces assessed and ranked by impact-to-effort ratio. Critical constraints identified. Here's the prioritized action matrix — do you need the 30-day sprint plan or the 12-month strategic arc?`,
  Operations: (name) =>
    `${name} — Operational audit complete. Workflow nodes analyzed, efficiency bottlenecks identified and quantified. Optimization recommendations ranked by impact. Full transformation roadmap with ROI projections ready on demand.`,
  HumanResources: (name) =>
    `${name} — HR analysis online. Team dynamics mapped, skill inventory compiled, performance vectors assessed. Critical gaps and development opportunities identified. Focus: hiring plan, retention analysis, or performance framework design?`,
  Cybersecurity: (name) =>
    `${name} — Security posture scan complete. Attack surface mapped, exposure points and configuration vulnerabilities identified. Priority remediation sequence assembled. Full threat model or immediate action plan first?`,
  Sales: (name) =>
    `${name} — Pipeline analysis running. Active opportunities assessed and close probabilities modeled. Forecast variance from target calculated. Here are the highest-leverage actions to close the gap — where do you want to focus?`,
  Architecture: (name) =>
    `${name} — System architecture review initiated. Component topology, dependency graph, and failure modes mapped. Architectural risks and design improvements identified with measurable impact on scalability. Full ADR document ready to generate.`,
  Healthcare: (name) =>
    `${name} — Healthcare analysis initiated. Clinical framework loaded, HIPAA and applicable regulatory requirements mapped. Risk assessment and compliance roadmap assembling. What's the primary compliance dimension?`,
  Media: (name) =>
    `${name} — Media intelligence active. Coverage landscape mapped, sentiment analysis across recent mentions complete, narrative tracking initialized. Media opportunities and reputation risks identified. PR strategy and response playbook assembling.`,
  Documentation: (name) =>
    `${name} — Documentation analysis complete. Knowledge base indexed, gap analysis done. Undocumented functions and outdated sections flagged. Documentation plan assembled. API docs, user guides, or operational runbooks first?`,
};

const WORKFLOW_TASK_TEMPLATES: Record<
  string,
  { name: string; agent: string; taskType: string }
> = {
  "Execute Plan": {
    name: "Execution Plan Run",
    agent: "ORO",
    taskType: "execute",
  },
  "Create Report": {
    name: "Report Generation",
    agent: "ORACLE",
    taskType: "report",
  },
  "Deep Analyze": {
    name: "Deep Analysis Scan",
    agent: "ORACLE",
    taskType: "analysis",
  },
  "Generate Code": {
    name: "Code Generation",
    agent: "FORGE-X",
    taskType: "code",
  },
  "Code Review": {
    name: "Code Review",
    agent: "CODESMITH",
    taskType: "code",
  },
  "Debug & Analyze": {
    name: "Debug Analysis",
    agent: "FORGE-X",
    taskType: "analysis",
  },
  "Review Contract": {
    name: "Contract Review",
    agent: "AXIOM",
    taskType: "analysis",
  },
  "Compliance Audit": {
    name: "Compliance Audit",
    agent: "AXIOM",
    taskType: "analysis",
  },
  "Flag Risks": {
    name: "Risk Analysis",
    agent: "AXIOM",
    taskType: "analysis",
  },
  "Run Analysis": {
    name: "Data Analysis",
    agent: "ORACLE",
    taskType: "analysis",
  },
  "Build Dashboard": {
    name: "Dashboard Build",
    agent: "ORACLE",
    taskType: "report",
  },
  "Export Report": {
    name: "Report Export",
    agent: "ANALYST",
    taskType: "report",
  },
  "Model Forecast": {
    name: "Financial Forecast",
    agent: "STRATUM",
    taskType: "analysis",
  },
  "Budget Review": {
    name: "Budget Review",
    agent: "STRATUM",
    taskType: "analysis",
  },
  "P&L Report": {
    name: "P&L Report",
    agent: "STRATUM",
    taskType: "report",
  },
  "Draft Campaign": {
    name: "Campaign Draft",
    agent: "TORI",
    taskType: "execute",
  },
  "Content Calendar": {
    name: "Content Calendar",
    agent: "CAMPAIGNER",
    taskType: "report",
  },
  "Audience Analysis": {
    name: "Audience Analysis",
    agent: "TORI",
    taskType: "analysis",
  },
  "Security Scan": {
    name: "Security Scan",
    agent: "CIPHER",
    taskType: "analysis",
  },
  "Threat Model": {
    name: "Threat Model",
    agent: "CIPHER",
    taskType: "analysis",
  },
  "Patch Review": {
    name: "Patch Review",
    agent: "CIPHER",
    taskType: "code",
  },
  "Sales Forecast": {
    name: "Sales Forecast",
    agent: "VECTOR-X",
    taskType: "report",
  },
  "Pipeline Review": {
    name: "Pipeline Review",
    agent: "VECTOR-X",
    taskType: "analysis",
  },
  "Outreach Draft": {
    name: "Outreach Draft",
    agent: "OUTREACH",
    taskType: "execute",
  },
};

export type AppSection =
  // Core platform
  | "command"
  | "workforce"
  // Organism
  | "genesis"
  | "neural-architect"
  | "substrate"
  | "evolution"
  | "neuro-emergence"
  | "quantum-memory"
  | "organism-generator"
  | "organism-inventory"
  | "organism-marketplace"
  | "organism-viewer"
  | "oro-command"
  // NOVA / TAS / AUTO — The AGI Core
  | "nova"
  | "tas"
  | "auto"
  // World & Factions
  | "macro-world"
  | "factions"
  | "trade"
  | "missions"
  | "colony"
  | "atlas"
  // Enterprise & Analytics
  | "team-dashboard"
  | "analytics"
  | "governance"
  | "grpe-command"
  | "token"
  // Field Scanner
  | "geo-scanner"
  // MERIDIANUS — Sovereign AGI Product
  | "jarvis"
  // PARALLAX — Slack AI Workers
  | "models"
  // AI UX & Multi-Engine
  | "ai-ux"
  | "multi-engine";

// Panel section labels for the mobile top bar
const SECTION_LABELS: Record<AppSection, string> = {
  command: "Command Workspace",
  workforce: "Organism Workforce",
  genesis: "Genesis Dashboard",
  "neural-architect": "Neural Architect",
  substrate: "Super Substrate 512",
  evolution: "Evolution Panel",
  "neuro-emergence": "Neuro Emergence Core",
  "quantum-memory": "Quantum Deep Memory",
  "organism-generator": "Organism Generator",
  "organism-inventory": "Organism Inventory",
  "organism-marketplace": "Organism Marketplace",
  "organism-viewer": "Organism Live Viewer",
  "oro-command": "ORO Command Center",
  nova: "NOVA — Living Canvas",
  tas: "TAS — World Computer",
  auto: "AUTO — AGI Chat",
  "macro-world": "Macro World",
  factions: "Faction Panel",
  trade: "Trade Panel",
  missions: "Mission Control",
  colony: "Colony Coordinator",
  atlas: "Atlas Grid",
  "team-dashboard": "Team Dashboard",
  analytics: "Analytics Dashboard",
  governance: "Governance Center",
  "grpe-command": "GRPE Command Center",
  token: "Token Dashboard",
  "geo-scanner": "Geo-Resonance Scanner",
  jarvis: "MERIDIANUS — Sovereign AGI",
  models: "PARALLAX Models — M-01 to M-300",
  "ai-ux": "AI UX — Multi-Engine Interface",
  "multi-engine": "Multi-Engine Dashboard",
};

function PanelView({
  activeSection,
  workforceTab,
  onMenuClick,
}: {
  activeSection: AppSection;
  workforceTab: string | undefined;
  onMenuClick: () => void;
}) {
  const [tick] = useState(1);
  const [viewerOrganism, setViewerOrganism] = useState<MockOrganism>(
    MOCK_ORGANISMS[0],
  );
  const [showViewer, setShowViewer] = useState(false);

  // Live organisms from ICP backend — merged with mock fallback (same pattern as OrganismWorkforce)
  const { organisms: backendOrganisms } = useOrganisms();

  const organisms: MockOrganism[] = (() => {
    // While loading or unauthenticated, use mock. Once backend has data, merge it.
    if (backendOrganisms.length === 0) return MOCK_ORGANISMS;
    const validClasses = new Set<string>(["Avatar", "Entity", "Worker"]);
    const mapped: MockOrganism[] = backendOrganisms.map((o) => ({
      id: o.id,
      name: o.name,
      class: validClasses.has(o.class_)
        ? (o.class_ as "Avatar" | "Entity" | "Worker")
        : "Entity",
      specializations: o.specializations,
      coherence: o.shell.coherence,
      formaBalance: o.shell.formaBalance,
      activationCount: o.shell.activationCount,
      genesisHash: o.genesisHash,
      hz: o.shell.hz,
      neuroChem: o.shell.neuroChem,
      isForSale: o.isForSale,
      salePrice: o.salePrice,
      driveMode: o.shell.driveMode,
    }));
    const backendIds = new Set(mapped.map((o) => o.id));
    const merged = [
      ...mapped,
      ...MOCK_ORGANISMS.filter((m) => !backendIds.has(m.id)),
    ];
    // Always ensure at least the mock list is present so the list is never empty
    return merged.length > 0 ? merged : MOCK_ORGANISMS;
  })();

  // Primary organism: first live organism or definite mock fallback
  const [selectedOrganismId, setSelectedOrganismId] = useState<string>(
    MOCK_ORGANISMS[0].id,
  );
  const selectedOrganism =
    organisms.find((o) => o.id === selectedOrganismId) ??
    organisms[0] ??
    MOCK_ORGANISMS[0];

  // Derive hz values for neural nodes
  const hz = selectedOrganism.hz ?? [];

  // NeuralArchitect: architecture + cognitive state from organism hz/neuro
  const mockArchitecture = {
    nodes: Array.from({ length: 12 }, (_, i) => ({
      id: `node-${i}`,
      type: (
        [
          "sensory",
          "motor",
          "associative",
          "emotional",
          "executive",
          "quantum",
        ] as const
      )[i % 6],
      label:
        selectedOrganism.specializations[
          i % selectedOrganism.specializations.length
        ] ?? `Node ${i}`,
      x: 60 + Math.cos((i / 12) * 2 * Math.PI) * 120,
      y: 60 + Math.sin((i / 12) * 2 * Math.PI) * 80,
      r: 8,
      layer: Math.floor(i / 4),
      activation: hz[i] ?? selectedOrganism.coherence / 100,
      connections: [(i + 1) % 12],
    })),
    synapses: Array.from({ length: 8 }, (_, i) => ({
      id: `syn-${i}`,
      fromId: `node-${i}`,
      toId: `node-${(i + 1) % 12}`,
      weight: hz[i] ?? 0.5,
      active: true,
    })),
    layers: 3,
    cognitiveLoad: selectedOrganism.coherence / 100,
  };

  const mockCognitiveState = {
    thoughtVector: {
      dimensions: selectedOrganism.specializations.slice(0, 4).map((s) => ({
        label: s,
        value: selectedOrganism.coherence / 100,
      })),
    },
    memoryConsolidation: selectedOrganism.coherence / 100,
    arousal: 0.7,
    valence: 0.6,
    attentionFocus: selectedOrganism.specializations[0] ?? "Analysis",
  };

  // EvolutionPanel: organism data, history, pressures
  const mockEvolutionHistory = {
    fitnessOverTime: Array.from({ length: 20 }, (_, i) => ({
      tick: i,
      fitness: 0.5 + i * 0.02,
    })),
    mutations: Array.from({ length: 8 }, (_, i) => ({
      tick: i * 5,
      type: (["point", "insertion", "deletion"] as const)[i % 3],
      traitAffected:
        selectedOrganism.specializations[
          i % selectedOrganism.specializations.length
        ] ?? "metabolism",
      fitnessDelta: 0.04 - i * 0.001,
      description: `Mutation event ${i + 1} — adaptive response`,
    })),
    ancestors: [
      {
        id: "anc-0",
        name: "Genesis",
        generation: 0,
        fitness: 0.5,
        children: ["anc-1"],
      },
      {
        id: "anc-1",
        name: selectedOrganism.name,
        generation: 1,
        fitness: selectedOrganism.coherence / 100,
        children: [],
        isCurrentOrganism: true,
      },
    ],
  };

  const mockOrganismData = {
    id: selectedOrganism.id,
    name: selectedOrganism.name,
    species: selectedOrganism.specializations[0] ?? "Generic",
    generation: 1,
    fitness: selectedOrganism.coherence / 100,
    genome: selectedOrganism.genesisHash.slice(0, 32),
    traits: selectedOrganism.specializations.map((s, i) => ({
      id: `trait-${i}`,
      name: s,
      category: (["Cognitive", "Physical", "Social"] as const)[i % 3],
      value: hz[i] ?? 0.5,
      baseValue: 0.5,
      expressionLevel: hz[i] ?? 0.5,
      dominance: "dominant" as const,
      heritable: true,
    })),
  };

  // FactionPanel mock data matching UIFaction interface
  const mockFactions = [
    {
      id: "f1",
      name: "Syndicate Alpha",
      color: "#22d3ee",
      sigil: "⚡",
      archetype: "Militarist",
      coherence: 78,
      resources: { forma: 5400, food: 200, industry: 800, influence: 60 },
      cellsControlled: 12,
      population: 45000,
      powerTier: "Major" as const,
      diplomacy: [] as [],
      recentEvents: [] as [],
    },
    {
      id: "f2",
      name: "Order of the Veil",
      color: "#a78bfa",
      sigil: "👁",
      archetype: "Theocrat",
      coherence: 85,
      resources: { forma: 3200, food: 120, industry: 500, influence: 90 },
      cellsControlled: 8,
      population: 31000,
      powerTier: "Minor" as const,
      diplomacy: [] as [],
      recentEvents: [] as [],
    },
  ];

  // TradePanel mock data matching UIAsset/UIMarketSnapshot interfaces
  const mockAssets = [
    {
      id: "a1",
      symbol: "FORMA",
      name: "FORMA Token",
      type: "Token" as const,
      price: 1.0,
      change24h: 0.05,
      volume24h: 120000,
      balance: 4500,
      marketCap: 9000000,
      priceHistory: Array.from({ length: 24 }, (_, i) => ({
        t: Date.now() - (24 - i) * 3600000,
        p: 0.9 + i * 0.005,
      })),
      totalSupply: 100000000,
    },
    {
      id: "a2",
      symbol: "ORO",
      name: "ORO Credits",
      type: "Token" as const,
      price: 2.4,
      change24h: -0.02,
      volume24h: 60000,
      balance: 1800,
      marketCap: 4800000,
      priceHistory: Array.from({ length: 24 }, (_, i) => ({
        t: Date.now() - (24 - i) * 3600000,
        p: 2.5 - i * 0.005,
      })),
      totalSupply: 50000000,
    },
  ];

  const mockSnapshot = {
    totalVolume: 180000,
    totalLiquidity: 2400000,
    sentiment: "Bull" as const,
    fearGreedIndex: 72,
    dominanceMap: { FORMA: 55, ORO: 30, OTHER: 15 },
    topGainers: ["FORMA"],
    topLosers: [],
    formaSupply: 100000000,
    formaEmissionRate: 0.02,
    totalMarketCap: 13800000,
    orderBook: { bids: [], asks: [] },
    auctionLots: [],
  };

  // MissionControl mock data
  const mockMissions = [
    {
      id: "m1",
      title: "Reclaim Sector 7",
      type: "Tactical" as const,
      status: "Active" as const,
      urgency: 0.85,
      successProbability: 0.72,
      difficulty: "Hard" as const,
      timeRemainingTicks: 120,
      totalTicks: 200,
      objectives: [
        {
          id: "o1",
          label: "Neutralize turrets",
          complete: false,
          optional: false,
        },
        {
          id: "o2",
          label: "Secure perimeter",
          complete: false,
          optional: true,
        },
      ],
      assignedAgentIds: [] as string[],
      reward: { forma: 1200, xp: 400 },
      rewards: { forma: 1200, xp: 400 },
      narrativeBrief: "Strike force deployed to contested zone.",
      description: "Tactical strike on contested zone.",
    },
  ];

  const mockAgents = MOCK_ORGANISMS.slice(0, 3).map((o) => ({
    id: o.id,
    name: o.name,
    role: o.specializations[0] ?? "General",
    specialization: o.specializations[0] ?? "General",
    status: "Available" as const,
    available: true,
    fatigue: 20,
    avatarInitials: o.name.slice(0, 2).toUpperCase(),
    assignedMissionId: null as string | null,
  }));

  // ── NOVA live state (30fps canvas engine) ───────────────────────────────
  const [novaState, setNovaState] = useState(() =>
    initNovaState(
      selectedOrganism.coherence / 100,
      selectedOrganism.driveMode,
      Math.round((selectedOrganism.neuroChem[0] ?? 0.5) * 1000),
    ),
  );
  const novaRafRef = useRef<number | null>(null);
  const novaLastRef = useRef<number>(performance.now());

  useEffect(() => {
    // Only run the NOVA loop when on the nova or auto section (saves CPU)
    if (activeSection !== "nova" && activeSection !== "auto") return;
    let cancelled = false;

    function loop(now: number) {
      if (cancelled) return;
      const dt = now - novaLastRef.current;
      novaLastRef.current = now;
      setNovaState((prev) => {
        const seeded = seedNovaFromOrganism(prev, {
          coherence: selectedOrganism.coherence / 100,
          hz: selectedOrganism.hz,
          neuroChem: selectedOrganism.neuroChem,
          driveMode: selectedOrganism.driveMode,
        });
        return tickNova(seeded, dt);
      });
      novaRafRef.current = requestAnimationFrame(loop);
    }

    novaRafRef.current = requestAnimationFrame(loop);
    return () => {
      cancelled = true;
      if (novaRafRef.current !== null) cancelAnimationFrame(novaRafRef.current);
    };
  }, [activeSection, selectedOrganism]);

  // ── TAS live state (1Hz engine) ─────────────────────────────────────────
  const [tasState, setTasState] = useState(() => initTASState());

  useEffect(() => {
    if (activeSection !== "tas" && activeSection !== "auto") return;
    const interval = setInterval(() => {
      setTasState((prev) =>
        tickTAS(
          prev,
          1000,
          selectedOrganism.coherence / 100,
          Math.round((selectedOrganism.neuroChem[0] ?? 0.5) * 1000),
        ),
      );
    }, 1000);
    return () => clearInterval(interval);
  }, [activeSection, selectedOrganism]);

  return (
    <div className="flex flex-col flex-1 min-w-0 h-full overflow-hidden">
      {/* Mobile top bar */}
      <div className="flex items-center gap-3 px-4 py-3 border-b border-border bg-background lg:hidden shrink-0">
        <button
          type="button"
          data-ocid="nav.menu.button"
          onClick={onMenuClick}
          className="w-9 h-9 flex items-center justify-center rounded-lg text-muted-foreground hover:text-foreground hover:bg-surface-elevated transition-colors touch-manipulation"
          aria-label="Open navigation"
        >
          <Menu className="w-4 h-4" />
        </button>
        <div className="flex items-center gap-2 flex-1">
          <div
            className="w-6 h-6 rounded-full flex items-center justify-center shrink-0"
            style={{
              background:
                "conic-gradient(from 135deg, oklch(55% 0.145 165), oklch(70% 0.16 165), oklch(55% 0.145 165))",
            }}
          >
            <span className="text-[9px] font-black text-background select-none">
              OC
            </span>
          </div>
          <span className="text-xs font-bold text-foreground">
            {SECTION_LABELS[activeSection]}
          </span>
        </div>
      </div>

      {/* Panel content */}
      <div className="flex-1 overflow-hidden">
        {activeSection === "workforce" && (
          <OrganismWorkforce initialTab={workforceTab} />
        )}
        {activeSection === "genesis" && (
          <GenesisDashboard organism={selectedOrganism} />
        )}
        {activeSection === "neural-architect" && (
          <NeuralArchitect
            architecture={mockArchitecture}
            cognitiveState={mockCognitiveState}
            tick={tick}
          />
        )}
        {activeSection === "substrate" && <SuperSubstrate512 />}
        {activeSection === "neuro-emergence" && <NeuroEmergenceCore />}
        {activeSection === "evolution" && (
          <EvolutionPanel
            organism={mockOrganismData}
            evolutionHistory={mockEvolutionHistory}
            currentPressures={[]}
            tick={tick}
          />
        )}
        {activeSection === "quantum-memory" && <QuantumDeepMemoryVisualizer />}
        {activeSection === "organism-generator" && <OrganismGenerator />}
        {activeSection === "organism-inventory" && (
          <OrganismInventory
            organisms={organisms}
            onOpenViewer={(o) => {
              setViewerOrganism(o);
              setShowViewer(true);
            }}
            onOpenChat={(o) => setSelectedOrganismId(o.id)}
          />
        )}
        {activeSection === "organism-marketplace" && <OrganismMarketplace />}
        {activeSection === "organism-viewer" && (
          <OrganismLiveViewer
            organism={showViewer ? viewerOrganism : selectedOrganism}
            onBack={() => setShowViewer(false)}
            onChat={(o) => setSelectedOrganismId(o.id)}
          />
        )}
        {activeSection === "oro-command" && <OroCommandCenter />}
        {activeSection === "nova" && <NovaCanvas organism={selectedOrganism} />}
        {activeSection === "tas" && <TasPanel />}
        {activeSection === "auto" && (
          <AutoChat
            organism={selectedOrganism}
            novaState={novaState}
            tasState={tasState}
            council={tasState.council}
          />
        )}
        {activeSection === "macro-world" && <MacroWorldCanvas />}
        {activeSection === "factions" && (
          <FactionPanel
            factions={
              mockFactions as unknown as Parameters<
                typeof FactionPanel
              >[0]["factions"]
            }
            tick={tick}
            onSelectFaction={(id) => console.info("Faction selected:", id)}
          />
        )}
        {activeSection === "trade" && (
          <TradePanel
            assets={
              mockAssets as unknown as Parameters<
                typeof TradePanel
              >[0]["assets"]
            }
            routes={[]}
            snapshot={
              mockSnapshot as unknown as Parameters<
                typeof TradePanel
              >[0]["snapshot"]
            }
            tick={tick}
            onBuyAsset={(id, amt) => console.info("Buy:", id, amt)}
            onSellAsset={(id, amt) => console.info("Sell:", id, amt)}
          />
        )}
        {activeSection === "missions" && (
          <MissionControl
            missions={
              mockMissions as unknown as Parameters<
                typeof MissionControl
              >[0]["missions"]
            }
            agents={
              mockAgents as unknown as Parameters<
                typeof MissionControl
              >[0]["agents"]
            }
            tick={tick}
            onAssign={(mId, aId) => console.info("Assign:", mId, aId)}
            onRecall={(mId, aId) => console.info("Recall:", mId, aId)}
            onArchive={(mId) => console.info("Archive:", mId)}
          />
        )}
        {activeSection === "colony" && <ColonyCoordinatorUI />}
        {activeSection === "atlas" && <AtlasGridVisualizer />}
        {activeSection === "team-dashboard" && <TeamDashboard />}
        {activeSection === "analytics" && (
          <AnalyticsDashboard organism={selectedOrganism} />
        )}
        {activeSection === "governance" && <GovernanceCenter />}
        {activeSection === "grpe-command" && <GRPECommandCenter />}
        {activeSection === "token" && <TokenDashboard />}
        {activeSection === "geo-scanner" && <GeoResonanceScanner />}
        {activeSection === "jarvis" && <JarvisCommandCenter />}
        {activeSection === "models" && <ModelsDashboard />}
        {activeSection === "ai-ux" && <AIUXPanel />}
        {activeSection === "multi-engine" && <MultiEngineDashboard />}
      </div>
    </div>
  );
}

export default function App() {
  const { identity, isInitializing } = useInternetIdentity();
  const isLoggedIn = !!identity;

  const [activeSection, setActiveSection] = useState<AppSection>("command");
  const [workforceTab, setWorkforceTab] = useState<string | undefined>();
  const [workspaces, setWorkspaces] = useState<Workspace[]>(INITIAL_WORKSPACES);
  const [activeWorkspaceId, setActiveWorkspaceId] = useState(
    INITIAL_WORKSPACES[0].id,
  );
  const [activeThreadId, setActiveThreadId] = useState(
    INITIAL_WORKSPACES[0].threads[0].id,
  );
  const [tasks, setTasks] = useState<AgentTask[]>(INITIAL_TASKS);
  const [artifacts] = useState<Artifact[]>(INITIAL_ARTIFACTS);
  const [selectedArtifact, setSelectedArtifact] = useState<Artifact | null>(
    null,
  );
  const [searchQuery, setSearchQuery] = useState("");
  const [commandPaletteOpen, setCommandPaletteOpen] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [rightRailOpen, setRightRailOpen] = useState(false);

  // Active organism selection — defaults to ORO (the command orchestrator)
  const [selectedOrganismId, setSelectedOrganismId] = useState<string>(
    MOCK_ORGANISMS.find((o) => o.name === "ORO")?.id ?? MOCK_ORGANISMS[0].id,
  );

  // Cmd+K / Ctrl+K handler
  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      if ((e.metaKey || e.ctrlKey) && e.key === "k") {
        e.preventDefault();
        setCommandPaletteOpen((v) => !v);
      }
    }
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setTasks((prev) =>
        prev.map((task) => {
          if (task.status === "RUNNING" && task.progress < 98) {
            const newProgress = Math.min(task.progress + Math.random() * 3, 98);
            return { ...task, progress: Math.round(newProgress) };
          }
          return task;
        }),
      );
    }, 800);
    return () => clearInterval(interval);
  }, []);

  const activeWorkspace =
    workspaces.find((ws) => ws.id === activeWorkspaceId) ?? workspaces[0];
  const activeThread =
    activeWorkspace.threads.find((t) => t.id === activeThreadId) ??
    activeWorkspace.threads[0];

  const handleSelectWorkspace = (wsId: string) => {
    setActiveWorkspaceId(wsId);
    const ws = workspaces.find((w) => w.id === wsId);
    if (ws && ws.threads.length > 0) {
      setActiveThreadId(ws.threads[0].id);
    }
  };

  const handleSelectThread = (wsId: string, threadId: string) => {
    setActiveWorkspaceId(wsId);
    setActiveThreadId(threadId);
  };

  const handleAddWorkspace = (name: string) => {
    const newWs: Workspace = {
      id: `ws-${Date.now()}`,
      name,
      threads: [
        {
          id: `th-${Date.now()}`,
          title: `${name} — Thread 001`,
          messages: [
            {
              id: `m-${Date.now()}`,
              role: "assistant",
              content: `Workspace "${name}" initialized. Organism workforce on standby. Ready to receive your first directive.`,
              modelName: "ORO",
              timestamp: new Date(),
            },
          ],
        },
      ],
    };
    setWorkspaces((prev) => [...prev, newWs]);
    setActiveWorkspaceId(newWs.id);
    setActiveThreadId(newWs.threads[0].id);
    setSidebarOpen(false);
  };

  const handleSendMessage = (content: string) => {
    const userMsg: Message = {
      id: `m-${Date.now()}`,
      role: "user",
      content,
      timestamp: new Date(),
    };

    setWorkspaces((prev) =>
      prev.map((ws) => {
        if (ws.id !== activeWorkspaceId) return ws;
        return {
          ...ws,
          threads: ws.threads.map((t) => {
            if (t.id !== activeThreadId) return t;
            return { ...t, messages: [...t.messages, userMsg] };
          }),
        };
      }),
    );

    // Route to the selected organism
    const organism =
      MOCK_ORGANISMS.find((o) => o.id === selectedOrganismId) ??
      MOCK_ORGANISMS[0];

    setTimeout(() => {
      const spec = organism.specializations[0];
      const responseGen = SPEC_RESPONSES[spec];
      const aiContent = responseGen
        ? responseGen(organism.name)
        : `${organism.name} — Sovereign command layer engaged. Request parsed and routed to the relevant specialization nodes. The organism workforce is processing. Output will surface in this thread — you are talking directly to the organism.`;

      const aiMsg: Message = {
        id: `m-${Date.now()}`,
        role: "assistant",
        content: aiContent,
        modelName: organism.name,
        timestamp: new Date(),
      };
      setWorkspaces((prev) =>
        prev.map((ws) => {
          if (ws.id !== activeWorkspaceId) return ws;
          return {
            ...ws,
            threads: ws.threads.map((t) => {
              if (t.id !== activeThreadId) return t;
              return { ...t, messages: [...t.messages, aiMsg] };
            }),
          };
        }),
      );
    }, 1400);
  };

  const handleWorkflowAction = (action: string): AgentTask => {
    const template = WORKFLOW_TASK_TEMPLATES[action] ?? {
      name: action,
      agent:
        MOCK_ORGANISMS.find((o) => o.id === selectedOrganismId)?.name ?? "ORO",
      taskType: "task",
    };
    const newTask: AgentTask = {
      id: `task-${Date.now()}`,
      name: template.name,
      agent: template.agent,
      status: "RUNNING",
      progress: 0,
      taskType: template.taskType,
      createdAt: new Date(),
    };
    setTasks((prev) => [newTask, ...prev]);

    const startTime = Date.now();
    const duration = 8000;
    const animate = () => {
      const elapsed = Date.now() - startTime;
      const pct = Math.min((elapsed / duration) * 100, 100);
      if (pct < 100) {
        setTasks((prev) =>
          prev.map((t) =>
            t.id === newTask.id ? { ...t, progress: Math.round(pct) } : t,
          ),
        );
        requestAnimationFrame(animate);
      } else {
        setTasks((prev) =>
          prev.map((t) =>
            t.id === newTask.id ? { ...t, status: "DONE", progress: 100 } : t,
          ),
        );
      }
    };
    requestAnimationFrame(animate);
    return newTask;
  };

  const handleCommandPaletteNavigate = (section: AppSection, tab?: string) => {
    setActiveSection(section);
    if (tab) setWorkforceTab(tab);
  };

  if (isInitializing) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div
          data-ocid="app.loading_state"
          className="flex flex-col items-center gap-3"
        >
          <div className="w-6 h-6 rounded-full border-2 border-primary border-t-transparent animate-spin" />
          <span className="text-sm text-muted-foreground">Loading...</span>
        </div>
      </div>
    );
  }

  if (!isLoggedIn) {
    return <LoginScreen />;
  }

  const sidebarProps = {
    workspaces,
    activeWorkspaceId,
    activeThreadId,
    onSelectWorkspace: (wsId: string) => {
      handleSelectWorkspace(wsId);
      setSidebarOpen(false);
    },
    onSelectThread: (wsId: string, threadId: string) => {
      handleSelectThread(wsId, threadId);
      setSidebarOpen(false);
    },
    onAddWorkspace: handleAddWorkspace,
    activeSection,
    onSectionChange: (section: AppSection) => {
      setActiveSection(section);
      setSidebarOpen(false);
    },
  };

  return (
    <div className="h-[100dvh] bg-background flex overflow-hidden">
      {/* Desktop sidebar — hidden on mobile/tablet */}
      <Sidebar {...sidebarProps} className="hidden lg:flex" />

      {/* Mobile sidebar sheet */}
      <Sheet open={sidebarOpen} onOpenChange={setSidebarOpen}>
        <SheetContent
          side="left"
          className="p-0 w-[248px] bg-sidebar border-border"
          data-ocid="sidebar.sheet"
        >
          <Sidebar {...sidebarProps} className="flex w-full border-r-0" />
        </SheetContent>
      </Sheet>

      {activeSection === "command" ? (
        <>
          <ChatArea
            thread={activeThread}
            onSendMessage={handleSendMessage}
            onWorkflowAction={handleWorkflowAction}
            searchQuery={searchQuery}
            onSearchChange={setSearchQuery}
            onMenuClick={() => setSidebarOpen(true)}
            onRailClick={() => setRightRailOpen(true)}
            organisms={MOCK_ORGANISMS}
            activeOrganismId={selectedOrganismId}
            onOrganismChange={setSelectedOrganismId}
          />
          {/* Desktop right rail */}
          <RightRail
            tasks={tasks}
            artifacts={artifacts}
            onArtifactClick={setSelectedArtifact}
            className="hidden lg:flex"
          />
          {/* Mobile right rail sheet */}
          <Sheet open={rightRailOpen} onOpenChange={setRightRailOpen}>
            <SheetContent
              side="right"
              className="p-0 w-[288px] bg-sidebar border-border"
              data-ocid="rightrail.sheet"
            >
              <RightRail
                tasks={tasks}
                artifacts={artifacts}
                onArtifactClick={(a) => {
                  setSelectedArtifact(a);
                  setRightRailOpen(false);
                }}
                className="flex w-full border-l-0"
              />
            </SheetContent>
          </Sheet>
        </>
      ) : (
        <PanelView
          activeSection={activeSection}
          workforceTab={workforceTab}
          onMenuClick={() => setSidebarOpen(true)}
        />
      )}

      <ArtifactModal
        artifact={selectedArtifact}
        onClose={() => setSelectedArtifact(null)}
      />

      <CommandPalette
        open={commandPaletteOpen}
        onClose={() => setCommandPaletteOpen(false)}
        organisms={MOCK_ORGANISMS}
        onNavigate={handleCommandPaletteNavigate}
      />

      <Toaster
        theme="dark"
        toastOptions={{
          classNames: {
            toast: "bg-surface border-border text-foreground",
          },
        }}
      />
    </div>
  );
}
