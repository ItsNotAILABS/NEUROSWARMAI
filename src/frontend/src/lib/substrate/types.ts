// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SUBSTRATE TYPES — MATCHING BACKEND GENESIS ARCHITECTURE                                                  ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import type {
  Caste,
  ColonyMode,
  DriveMode,
  HzNodeName,
  Metal,
  Neurochemical,
  Organ,
  OrganismSpecialization,
  SignalType,
  TaskPriority,
  TaskStatus,
  TaskType,
  WorkflowType,
} from "./constants";

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: SUPER NODE TYPES (512-node substrate)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Individual node in the 512-node super substrate
 * Matches backend SuperNode type from super-organism-architecture.mo
 */
export interface SuperNode {
  id: number; // 0-511
  frequency: number; // Hz (0.1 - 100)
  phase: number; // [0, 2π)
  amplitude: number; // [0, 1]
  activation: number; // Current activation [0, 1]
  threshold: number; // Firing threshold
  refractoryRemaining: number; // Refractory period countdown
  shellId: number; // Which shell (0-11)
  localCoherence: number; // Node's local coherence
  cumulativeActivation: number; // For plasticity
}

/**
 * Sparse weight matrix for 512×512 connections
 * Uses block structure for memory efficiency
 */
export interface SuperWeightMatrix {
  blocks: number[][]; // 64 blocks of 4,096 weights each
  blockSize: number; // 64
  numBlocks: number; // 64
  totalWeights: number; // 262,144
  lastUpdate: number;
  ltpCount: number;
  ltdCount: number;
}

/**
 * Complete 512-node substrate state
 */
export interface SuperSubstrate {
  nodes: SuperNode[];
  weights: SuperWeightMatrix;
  shellId: number;
  name: string;
  coherence: number;
  kuramotoR: number;
  totalActivations: number;
  beat: number;
}

/**
 * Result of Hebbian update operation
 */
export interface SuperHebbianResult {
  ltpEvents: number;
  ltdEvents: number;
  totalUpdates: number;
  meanWeightChange: number;
  maxWeightChange: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: HZ SUBSTRATE TYPES (12-node hierarchy)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Individual Hz node in the 12-node hierarchy
 * fd(k) = 2.5 × 2^(k-4) for k = 1..12
 */
export interface HzNode {
  k: number; // Node index 1-12
  name: HzNodeName;
  frequency: number; // fd(k) = 2.5 × 2^(k-4)
  phase: number; // [0, 2π)
  amplitude: number; // [0, 1]
  activation: number; // Current activation
  description: string;
}

/**
 * Complete Hz substrate state
 */
export interface HzSubstrate {
  nodes: HzNode[];
  kuramotoR: number; // Order parameter
  kuramotoPsi: number; // Mean phase
  coherence: number;
  lastUpdate: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: ATLAS GRID TYPES (4,096 stigmergic cells)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Individual cell in the ATLAS stigmergic grid
 */
export interface AtlasCell {
  position: number; // 0-4095
  pheromone: number; // τ(x,t) — current concentration
  frequencyBand: number; // Which Hz band (0-11)
  lastDepositorId: number;
  lastDepositTime: number;
  depositRate: number; // σ — deposition rate
  signalType: SignalType;
  signalIntensity: number;
}

/**
 * Complete ATLAS grid state
 */
export interface AtlasGrid {
  cells: AtlasCell[];
  totalPheromone: number;
  avgPheromone: number;
  maxPheromone: number;
  activeSignals: number;
  lastEvaporation: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: COLONY ORGANISM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Trait activation vector (one per caste)
 */
export interface TraitVector {
  crow: number;
  dolphin: number;
  hive: number;
  elephant: number;
  shark: number;
  wolf: number;
  orca: number;
  eagle: number;
  octopus: number;
}

/**
 * Individual organism within a colony
 */
export interface ColonyOrganism {
  organismId: number;
  principal: string;

  // Hz substrate phases (12 nodes)
  phases: number[];
  frequencies: number[];

  // Trait/caste state
  traits: TraitVector;
  currentCaste: Caste;
  casteConfidence: number;

  // FORMA energy
  formaEnergy: number;
  formaReserve: number;

  // Coherence and drift
  localCoherence: number;
  genesisDrift: number;
  predictionError: number;

  // Connection to colony
  atlasWritePermission: boolean;
  lastHeartbeat: number;
  beatsSinceJoin: number;

  // Epigenetic inheritance
  parentOrganismId: number | null;
  inheritanceAlpha: number;
}

/**
 * Complete colony state
 */
export interface ColonyState {
  colonyId: number;
  organisms: ColonyOrganism[];
  organismCount: number;
  atlasGrid: AtlasGrid;
  rColony: number;
  psiGlobal: number;
  colonyMode: ColonyMode;
  quorumActive: boolean;
  quorumThreshold: number;
  totalForma: number;
  totalBeats: number;
  genesisTime: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: SHELL STATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Complete shell state for an organism
 */
export interface ShellState {
  coherence: number;
  formaBalance: number;
  driveMode: DriveMode;
  hz: number[];
  neuroChem: number[];
  activationCount: number;
  governanceScore: number;
  compoundIndex: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: ORGANISM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Transfer event record
 */
export interface TransferEvent {
  from: string;
  to: string;
  timestamp: number;
}

/**
 * Complete organism type
 */
export interface Organism {
  id: string;
  name: string;
  owner: string;
  class: "Avatar" | "Entity" | "Worker";
  specializations: OrganismSpecialization[];
  genesisHash: string;
  shell: ShellState;
  transferLog: TransferEvent[];
  createdAt: number;
  isForSale: boolean;
  salePrice: number;
}

/**
 * Organism listing for marketplace
 */
export interface OrganismListing {
  organism: Organism;
  listedAt: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: CHEMICAL LAYER TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Neurochemical state
 */
export interface NeurochemicalState {
  name: Neurochemical;
  level: number; // [0, 1]
  receptorSaturation: number; // [0, 1]
  productionRate: number;
  decayRate: number;
  effect: string;
}

/**
 * Organ state
 */
export interface OrganState {
  name: Organ;
  health: number; // [0, 1]
  delta: number; // Homeostatic delta
  activity: number;
  stress: number;
}

/**
 * Metal state
 */
export interface MetalState {
  name: Metal;
  conductivity: number; // [0, 1]
  hebbianInfluence: number;
  concentration: number;
}

/**
 * Complete chemical layer state
 */
export interface ChemicalLayerState {
  neurochemicals: NeurochemicalState[];
  organs: OrganState[];
  metals: MetalState[];
  overallHealth: number;
  homeostasisIndex: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: TASK TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Task metrics
 */
export interface TaskMetrics {
  estimatedDuration: number;
  actualDuration: number;
  qualityScore: number;
  efficiencyScore: number;
  resourcesUsed: number;
  completionReward: number;
}

/**
 * Complete task type
 */
export interface Task {
  id: number;
  name: string;
  description: string;
  taskType: TaskType;
  priority: TaskPriority;
  status: TaskStatus;
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  deadline: number | null;
  assignee: string | null;
  dependencies: number[];
  subtasks: number[];
  parentTask: number | null;
  inputs: Record<string, string>;
  outputs: Record<string, string>;
  metrics: TaskMetrics;
  retryCount: number;
  lastError: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: WORKFLOW TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workflow step
 */
export interface WorkflowStep {
  id: number;
  name: string;
  description: string;
  taskType: TaskType;
  dependencies: number[];
  condition: string | null;
  timeout: number | null;
  retryPolicy: {
    maxRetries: number;
    backoffMultiplier: number;
  };
  status: TaskStatus;
  result: string | null;
}

/**
 * Complete workflow type
 */
export interface Workflow {
  id: number;
  name: string;
  description: string;
  workflowType: WorkflowType;
  status: TaskStatus;
  steps: WorkflowStep[];
  currentStep: number;
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  owner: string;
  priority: TaskPriority;
  tags: string[];
  metadata: Record<string, string>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 10: WORKFORCE MESSAGE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Workforce chat message
 */
export interface WorkforceMessage {
  id: string;
  threadId: string;
  organismId: string;
  role: "user" | "assistant" | "system";
  content: string;
  artifactType: string | null;
  artifactContent: string | null;
  timestamp: number;
}

/**
 * Chat thread
 */
export interface ChatThread {
  id: string;
  title: string;
  messages: WorkforceMessage[];
  createdAt: number;
  updatedAt: number;
  participants: string[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 11: ARTIFACT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Artifact record
 */
export interface ArtifactRecord {
  id: string;
  organismId: string;
  owner: string;
  artifactType: string;
  title: string;
  content: string;
  createdAt: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 12: QUANTUM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Quantum state
 */
export interface QuantumState {
  id: number;
  amplitude: { real: number; imaginary: number };
  phase: number;
  probability: number;
  entangledWith: number[];
  coherenceTime: number;
  measurementHistory: number[];
}

/**
 * Quantum register
 */
export interface QuantumRegister {
  qubits: QuantumState[];
  entanglementMatrix: number[][];
  globalPhase: number;
  coherence: number;
  temperature: number;
}

/**
 * Quantum gate operation
 */
export interface QuantumGate {
  name: string;
  matrix: number[][];
  targetQubits: number[];
  controlQubits: number[];
  parameters: number[];
}

/**
 * Quantum circuit
 */
export interface QuantumCircuit {
  id: string;
  name: string;
  gates: QuantumGate[];
  inputQubits: number;
  outputQubits: number;
  depth: number;
  measurements: number[];
}

/**
 * Quantum battery state
 */
export interface QuantumBattery {
  capacity: number;
  charge: number;
  chargeRate: number;
  dischargeRate: number;
  efficiency: number;
  entanglementBonus: number;
  coherenceMultiplier: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 13: GOVERNANCE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Proposal status
 */
export type ProposalStatus =
  | "Draft"
  | "Active"
  | "Passed"
  | "Rejected"
  | "Executed"
  | "Cancelled"
  | "Expired";

/**
 * Vote type
 */
export type VoteType = "For" | "Against" | "Abstain";

/**
 * Vote record
 */
export interface Vote {
  voter: string;
  proposalId: number;
  voteType: VoteType;
  weight: number;
  timestamp: number;
  reason: string | null;
}

/**
 * Governance proposal
 */
export interface Proposal {
  id: number;
  title: string;
  description: string;
  proposer: string;
  status: ProposalStatus;
  createdAt: number;
  startTime: number;
  endTime: number;
  executionTime: number | null;
  forVotes: number;
  againstVotes: number;
  abstainVotes: number;
  quorumRequired: number;
  votes: Vote[];
  actions: ProposalAction[];
  metadata: Record<string, string>;
}

/**
 * Proposal action
 */
export interface ProposalAction {
  id: number;
  target: string;
  method: string;
  parameters: string[];
  value: number;
  executed: boolean;
}

/**
 * Governance parameters
 */
export interface GovernanceParams {
  votingPeriod: number;
  quorumPercentage: number;
  supermajorityThreshold: number;
  proposalThreshold: number;
  executionDelay: number;
  maxActions: number;
}

/**
 * Delegation record
 */
export interface Delegation {
  delegator: string;
  delegatee: string;
  weight: number;
  timestamp: number;
  expiry: number | null;
}

/**
 * Complete governance state
 */
export interface GovernanceState {
  proposals: Proposal[];
  activeProposals: number[];
  delegations: Delegation[];
  params: GovernanceParams;
  totalVotingPower: number;
  proposalCount: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 14: TOKEN ECONOMY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token balance
 */
export interface TokenBalance {
  owner: string;
  balance: number;
  stakedBalance: number;
  lockedBalance: number;
  pendingRewards: number;
  lastClaimTime: number;
}

/**
 * Token transfer
 */
export interface TokenTransfer {
  id: string;
  from: string;
  to: string;
  amount: number;
  timestamp: number;
  memo: string | null;
  fee: number;
}

/**
 * Staking position
 */
export interface StakingPosition {
  id: string;
  staker: string;
  amount: number;
  startTime: number;
  lockDuration: number;
  unlockTime: number;
  rewardRate: number;
  accumulatedRewards: number;
  autoCompound: boolean;
}

/**
 * Reward distribution
 */
export interface RewardDistribution {
  id: string;
  recipient: string;
  amount: number;
  reason: string;
  timestamp: number;
  category: "task" | "governance" | "staking" | "referral" | "bonus";
}

/**
 * Token economics state
 */
export interface TokenEconomicsState {
  totalSupply: number;
  circulatingSupply: number;
  stakedSupply: number;
  burnedSupply: number;
  treasuryBalance: number;
  inflationRate: number;
  burnRate: number;
  stakingAPY: number;
  priceUSD: number;
  marketCap: number;
}

/**
 * Complete FORMA token state
 */
export interface FormaTokenState {
  economics: TokenEconomicsState;
  balances: TokenBalance[];
  transfers: TokenTransfer[];
  stakingPositions: StakingPosition[];
  rewardDistributions: RewardDistribution[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 15: SPECIALIZED ORGANISM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Legal compliance organism state
 */
export interface LegalComplianceState {
  jurisdictions: string[];
  activeContracts: number;
  pendingReviews: number;
  complianceScore: number;
  lastAudit: number;
  regulations: string[];
  riskLevel: "low" | "medium" | "high";
}

/**
 * Finance trading organism state
 */
export interface FinanceTradingState {
  portfolioValue: number;
  openPositions: number;
  dailyPnL: number;
  totalPnL: number;
  riskExposure: number;
  sharpeRatio: number;
  maxDrawdown: number;
  winRate: number;
}

/**
 * Engineering technical organism state
 */
export interface EngineeringTechnicalState {
  activeProjects: number;
  codeReviews: number;
  deployments: number;
  testCoverage: number;
  bugCount: number;
  techDebt: number;
  velocity: number;
  uptime: number;
}

/**
 * Research science organism state
 */
export interface ResearchScienceState {
  activeExperiments: number;
  hypotheses: number;
  dataPoints: number;
  publications: number;
  citations: number;
  peerReviews: number;
  reproducibilityScore: number;
  innovationIndex: number;
}

/**
 * Creative content organism state
 */
export interface CreativeContentState {
  contentPieces: number;
  engagementRate: number;
  impressions: number;
  conversions: number;
  brandScore: number;
  creativityIndex: number;
  audienceGrowth: number;
  contentQuality: number;
}

/**
 * Operations logistics organism state
 */
export interface OperationsLogisticsState {
  activeOrders: number;
  fulfillmentRate: number;
  avgDeliveryTime: number;
  inventoryTurnover: number;
  warehouseUtilization: number;
  costEfficiency: number;
  supplierScore: number;
  customerSatisfaction: number;
}

/**
 * Specialized organism base
 */
export interface SpecializedOrganismBase {
  organismId: string;
  specialization: OrganismSpecialization;
  activeSince: number;
  totalTasks: number;
  successRate: number;
  reputation: number;
}

/**
 * Union type for all specialized states
 */
export type SpecializedOrganismState =
  | { type: "legal"; state: LegalComplianceState }
  | { type: "finance"; state: FinanceTradingState }
  | { type: "engineering"; state: EngineeringTechnicalState }
  | { type: "research"; state: ResearchScienceState }
  | { type: "creative"; state: CreativeContentState }
  | { type: "operations"; state: OperationsLogisticsState };

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 16: ANALYTICS TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Time series data point
 */
export interface TimeSeriesPoint {
  timestamp: number;
  value: number;
}

/**
 * Analytics metric
 */
export interface AnalyticsMetric {
  name: string;
  value: number;
  change: number;
  changePercent: number;
  trend: "up" | "down" | "stable";
  timeSeries: TimeSeriesPoint[];
}

/**
 * Dashboard widget
 */
export interface DashboardWidget {
  id: string;
  type: "metric" | "chart" | "table" | "map" | "heatmap";
  title: string;
  data: AnalyticsMetric | AnalyticsMetric[];
  config: Record<string, unknown>;
}

/**
 * Analytics dashboard
 */
export interface AnalyticsDashboard {
  id: string;
  name: string;
  widgets: DashboardWidget[];
  refreshInterval: number;
  lastRefresh: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 17: MEMORY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Memory event
 */
export interface MemoryEvent {
  id: string;
  timestamp: number;
  eventType: string;
  content: string;
  importance: number;
  emotionalValence: number;
  associations: string[];
  consolidationLevel: number;
}

/**
 * Memory layer
 */
export interface MemoryLayer {
  name: string;
  capacity: number;
  used: number;
  events: MemoryEvent[];
  consolidationRate: number;
  decayRate: number;
}

/**
 * Deep memory state
 */
export interface DeepMemoryState {
  workingMemory: MemoryLayer;
  shortTermMemory: MemoryLayer;
  longTermMemory: MemoryLayer;
  proceduralMemory: MemoryLayer;
  episodicMemory: MemoryLayer;
  semanticMemory: MemoryLayer;
  totalCapacity: number;
  totalUsed: number;
  consolidationProgress: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 18: ENTERPRISE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * User role
 */
export type UserRole = "admin" | "operator" | "viewer" | "guest";

/**
 * Permission
 */
export interface Permission {
  resource: string;
  action: "create" | "read" | "update" | "delete" | "execute";
  granted: boolean;
}

/**
 * User account
 */
export interface UserAccount {
  principal: string;
  displayName: string;
  email: string | null;
  role: UserRole;
  permissions: Permission[];
  createdAt: number;
  lastLogin: number;
  isActive: boolean;
}

/**
 * Audit log entry
 */
export interface AuditLogEntry {
  id: string;
  timestamp: number;
  actor: string;
  action: string;
  resource: string;
  resourceId: string;
  details: Record<string, unknown>;
  ipAddress: string | null;
  success: boolean;
}

/**
 * System health
 */
export interface SystemHealth {
  status: "healthy" | "degraded" | "unhealthy";
  uptime: number;
  cpuUsage: number;
  memoryUsage: number;
  diskUsage: number;
  networkLatency: number;
  errorRate: number;
  requestsPerSecond: number;
}

/**
 * Enterprise configuration
 */
export interface EnterpriseConfig {
  tenantId: string;
  tenantName: string;
  maxUsers: number;
  maxOrganisms: number;
  maxWorkflows: number;
  features: string[];
  billingPlan: string;
  expiryDate: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 19: REAL-TIME SYNC TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Sync status
 */
export type SyncStatus = "synced" | "syncing" | "offline" | "error";

/**
 * Sync event
 */
export interface SyncEvent {
  id: string;
  type: "create" | "update" | "delete";
  resource: string;
  resourceId: string;
  data: unknown;
  timestamp: number;
  version: number;
}

/**
 * Sync state
 */
export interface SyncState {
  status: SyncStatus;
  lastSync: number;
  pendingEvents: SyncEvent[];
  conflictCount: number;
  version: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 20: NOTIFICATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Notification type
 */
export type NotificationType =
  | "info"
  | "success"
  | "warning"
  | "error"
  | "task"
  | "governance"
  | "token"
  | "system";

/**
 * Notification
 */
export interface Notification {
  id: string;
  type: NotificationType;
  title: string;
  message: string;
  timestamp: number;
  read: boolean;
  actionUrl: string | null;
  metadata: Record<string, unknown>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 21: FORM/INPUT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Form field
 */
export interface FormField {
  name: string;
  type:
    | "text"
    | "number"
    | "select"
    | "checkbox"
    | "textarea"
    | "date"
    | "file";
  label: string;
  placeholder?: string;
  required: boolean;
  validation?: {
    min?: number;
    max?: number;
    pattern?: string;
    message?: string;
  };
  options?: { value: string; label: string }[];
  defaultValue?: unknown;
}

/**
 * Form definition
 */
export interface FormDefinition {
  id: string;
  title: string;
  description?: string;
  fields: FormField[];
  submitLabel: string;
  cancelLabel?: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 22: VISUALIZATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Graph node
 */
export interface GraphNode {
  id: string;
  label: string;
  type: string;
  x?: number;
  y?: number;
  data: Record<string, unknown>;
  style?: Record<string, unknown>;
}

/**
 * Graph edge
 */
export interface GraphEdge {
  id: string;
  source: string;
  target: string;
  label?: string;
  weight?: number;
  style?: Record<string, unknown>;
}

/**
 * Graph data
 */
export interface GraphData {
  nodes: GraphNode[];
  edges: GraphEdge[];
}

/**
 * Heatmap cell
 */
export interface HeatmapCell {
  x: number;
  y: number;
  value: number;
  label?: string;
}

/**
 * Heatmap data
 */
export interface HeatmapData {
  cells: HeatmapCell[];
  xLabels: string[];
  yLabels: string[];
  minValue: number;
  maxValue: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 23: EXPORT/IMPORT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Export format
 */
export type ExportFormat = "json" | "csv" | "xlsx" | "pdf";

/**
 * Export options
 */
export interface ExportOptions {
  format: ExportFormat;
  includeMetadata: boolean;
  dateRange?: { start: number; end: number };
  filters?: Record<string, unknown>;
}

/**
 * Import result
 */
export interface ImportResult {
  success: boolean;
  recordsImported: number;
  recordsFailed: number;
  errors: { row: number; message: string }[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 24: SEARCH TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Search filter
 */
export interface SearchFilter {
  field: string;
  operator: "eq" | "ne" | "gt" | "lt" | "gte" | "lte" | "contains" | "in";
  value: unknown;
}

/**
 * Search sort
 */
export interface SearchSort {
  field: string;
  direction: "asc" | "desc";
}

/**
 * Search query
 */
export interface SearchQuery {
  query?: string;
  filters: SearchFilter[];
  sort: SearchSort[];
  page: number;
  pageSize: number;
}

/**
 * Search result
 */
export interface SearchResult<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 25: KALMAN FILTER TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Kalman filter state
 */
export interface KalmanState {
  estimate: number[];
  errorCovariance: number[][];
  processNoise: number[][];
  measurementNoise: number[][];
  transitionMatrix: number[][];
  observationMatrix: number[][];
}

/**
 * Kalman prediction result
 */
export interface KalmanPrediction {
  predictedState: number[];
  predictedCovariance: number[][];
  innovation: number[];
  innovationCovariance: number[][];
  kalmanGain: number[][];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 26: Q-LEARNING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Q-Table entry
 */
export interface QTableEntry {
  state: string;
  action: string;
  value: number;
  visits: number;
  lastUpdate: number;
}

/**
 * Q-Learning state
 */
export interface QLearningState {
  qTable: QTableEntry[];
  learningRate: number;
  discountFactor: number;
  explorationRate: number;
  explorationDecay: number;
  minExploration: number;
  totalEpisodes: number;
  totalSteps: number;
  avgReward: number;
}

/**
 * Q-Learning action result
 */
export interface QLearningActionResult {
  action: string;
  qValue: number;
  isExploration: boolean;
  stateValue: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 27: FREE ENERGY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Free energy domain
 */
export interface FreeEnergyDomain {
  name: string;
  prediction: number[];
  observation: number[];
  precision: number;
  freeEnergy: number;
  entropy: number;
}

/**
 * Free energy state
 */
export interface FreeEnergyState {
  domains: FreeEnergyDomain[];
  totalFreeEnergy: number;
  expectedFreeEnergy: number;
  variationalBound: number;
  modelEvidence: number;
  surprisal: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 28: PHASE-AMPLITUDE COUPLING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * PAC coupling
 */
export interface PACCoupling {
  lowFreqNode: number;
  highFreqNode: number;
  modulationIndex: number;
  preferredPhase: number;
  couplingStrength: number;
}

/**
 * PAC state
 */
export interface PACState {
  couplings: PACCoupling[];
  globalModulation: number;
  crossFrequencyPower: number[];
  phaseHistogram: number[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 29: UTILITY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Result type for operations that can fail
 */
export type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

/**
 * Loading state
 */
export type LoadingState = "idle" | "loading" | "success" | "error";

/**
 * Async state wrapper
 */
export interface AsyncState<T> {
  data: T | null;
  loading: boolean;
  error: Error | null;
  lastFetch: number | null;
}

/**
 * Paginated response
 */
export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  totalPages: number;
}

/**
 * Range type
 */
export interface Range {
  min: number;
  max: number;
}

/**
 * Coordinates
 */
export interface Coordinates {
  x: number;
  y: number;
}

/**
 * 3D Coordinates
 */
export interface Coordinates3D extends Coordinates {
  z: number;
}

/**
 * Dimension
 */
export interface Dimension {
  width: number;
  height: number;
}

/**
 * Bounds
 */
export interface Bounds extends Coordinates, Dimension {}

/**
 * Color with alpha
 */
export interface RGBA {
  r: number;
  g: number;
  b: number;
  a: number;
}

/**
 * HSL color
 */
export interface HSLA {
  h: number;
  s: number;
  l: number;
  a: number;
}
