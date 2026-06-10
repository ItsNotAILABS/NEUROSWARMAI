// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SPECIALIZED ORGANISMS TYPES — DOMAIN-SPECIFIC AI ORGANISMS                                               ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  THE TWO-TIER COGNITIVE ARCHITECTURE:                                                                    ║
// ║  SLOW LAYER (backend, 1-2 Hz, chain-anchored, sovereign, immortal)                                        ║
// ║  FAST LAYER (frontend, 60 Hz, ephemeral, real-time expression)                                           ║
// ║                                                                                                           ║
// ║  At FULL SYMMETRY: players are not playing a game.                                                       ║
// ║  They are GUESTS in a world that owns itself.                                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import type {
  CapabilityLevel,
  DriveMode,
  Neurochemical,
  Organ,
  OrganismClass,
  OrganismSpecialization,
  OrganismStatus,
  SpecializedOrganismType,
} from "./constants";

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: HZ NODE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Hz node state (12-node binary hierarchy)
 */
export interface HzNodeState {
  k: number; // Node index 1-12
  name: string;
  frequency: number; // fd(k) = 2.5 × 2^(k-4)
  phase: number; // [0, 2π)
  amplitude: number; // [0, 1]
  activation: number; // Current activation
  target: number; // Target activation
  error: number; // Prediction error
}

/**
 * Complete Hz substrate state
 */
export interface HzSubstrateState {
  nodes: HzNodeState[];
  kuramotoR: number; // Order parameter
  kuramotoPsi: number; // Mean phase
  coherence: number;
  pacStrength: number; // Phase-amplitude coupling
  lastUpdate: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: NEUROCHEMICAL TYPES
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
  target: number;
  effect: string;
}

/**
 * Neurochemical profile (21 chemicals)
 */
export interface NeurochemicalProfile {
  chemicals: NeurochemicalState[];
  overallBalance: number;
  dominantChemical: Neurochemical | null;
  deficientChemical: Neurochemical | null;
  crosstalkMatrix: Record<string, number>;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: ORGAN TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Organ state (18 brain regions)
 */
export interface OrganState {
  name: Organ;
  health: number; // [0, 1]
  activity: number; // Current activity level
  delta: number; // Homeostatic delta
  stress: number; // Stress level
  lastUpdate: number;
}

/**
 * Complete organ system state
 */
export interface OrganSystemState {
  organs: OrganState[];
  overallHealth: number;
  homeostasisIndex: number;
  stressLevel: number;
  dominantOrgan: Organ | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: SHELL STATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Shell state (the organism's outer membrane)
 */
export interface ShellState {
  coherence: number; // [0, 1]
  formaBalance: number; // FORMA energy
  driveMode: DriveMode;
  hz: number[]; // 12 Hz phase values
  neuroChem: number[]; // 21 neurochemical levels
  activationCount: number;
  governanceScore: number;
  compoundIndex: number;
  lastHeartbeat: number;
  beatsSinceGenesis: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: CAPABILITY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Capability rating
 */
export interface CapabilityRating {
  name: string;
  score: number; // [0, 1]
  level: CapabilityLevel;
  experiencePoints: number;
  tasksCompleted: number;
  successRate: number;
  lastUsed: number;
}

/**
 * Capability set for an organism
 */
export interface CapabilitySet {
  capabilities: CapabilityRating[];
  primaryCapability: string;
  overallLevel: CapabilityLevel;
  totalExperience: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: SPECIALIZED ORGANISM STATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Legal Compliance Organism state
 */
export interface LegalComplianceState {
  jurisdictions: string[];
  activeContracts: number;
  pendingReviews: number;
  complianceScore: number;
  lastAudit: number;
  regulations: string[];
  riskLevel: "low" | "medium" | "high" | "critical";
  violations: number;
  remediationTasks: number;
}

/**
 * Finance Trading Organism state
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
  tradesExecuted: number;
  avgTradeSize: number;
}

/**
 * Engineering Technical Organism state
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
  linesOfCode: number;
  pullRequestsMerged: number;
}

/**
 * Research Science Organism state
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
  grantsFunded: number;
  collaborators: number;
}

/**
 * Creative Content Organism state
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
  campaignsActive: number;
  viralityScore: number;
}

/**
 * Operations Logistics Organism state
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
  onTimeDelivery: number;
  returnRate: number;
}

/**
 * Code Execution Organism state
 */
export interface CodeExecutionState {
  executionsToday: number;
  totalExecutions: number;
  successRate: number;
  avgExecutionTime: number;
  codeQuality: number;
  securityScore: number;
  testsRun: number;
  testsPassed: number;
  coveragePercentage: number;
  errorsHandled: number;
}

/**
 * PDF Document Organism state
 */
export interface PDFDocumentState {
  documentsProcessed: number;
  extractionAccuracy: number;
  generationTime: number;
  templateCount: number;
  errorRate: number;
  ocrAccuracy: number;
  pagesProcessed: number;
  formFields: number;
  storageUsed: number;
  conversionRate: number;
}

/**
 * Video Generation Organism state
 */
export interface VideoGenerationState {
  videosGenerated: number;
  totalDuration: number;
  avgRenderTime: number;
  qualityScore: number;
  storageUsed: number;
  viewCount: number;
  framesRendered: number;
  effectsApplied: number;
  audioTracks: number;
  subtitlesGenerated: number;
}

/**
 * Union type for all specialized states
 */
export type SpecializedState =
  | { type: "LegalCompliance"; state: LegalComplianceState }
  | { type: "FinanceTrading"; state: FinanceTradingState }
  | { type: "EngineeringTechnical"; state: EngineeringTechnicalState }
  | { type: "ResearchScience"; state: ResearchScienceState }
  | { type: "CreativeContent"; state: CreativeContentState }
  | { type: "OperationsLogistics"; state: OperationsLogisticsState }
  | { type: "CodeExecution"; state: CodeExecutionState }
  | { type: "PDFDocument"; state: PDFDocumentState }
  | { type: "VideoGeneration"; state: VideoGenerationState };

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: ORGANISM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Transfer event (ownership history)
 */
export interface TransferEvent {
  from: string;
  to: string;
  timestamp: number;
  beat: number;
  reason: string | null;
}

/**
 * Organism genesis record
 */
export interface OrganismGenesis {
  hash: string;
  timestamp: number;
  beat: number;
  parentOrganism: string | null;
  inheritanceAlpha: number;
  mutationRate: number;
  genesisMethod: "created" | "spawned" | "forked" | "merged";
}

/**
 * Complete organism type
 */
export interface Organism {
  id: string;
  name: string;
  owner: string;

  // Classification
  class: OrganismClass;
  specializations: OrganismSpecialization[];
  specializationType: SpecializedOrganismType | null;

  // State
  status: OrganismStatus;
  shell: ShellState;
  hzSubstrate: HzSubstrateState;
  neurochemProfile: NeurochemicalProfile;
  organSystem: OrganSystemState;
  capabilities: CapabilitySet;

  // Specialized state
  specializedState: SpecializedState | null;

  // Genesis
  genesis: OrganismGenesis;

  // History
  transferLog: TransferEvent[];

  // Market
  isForSale: boolean;
  salePrice: number;

  // Metadata
  createdAt: number;
  lastActive: number;
  totalBeats: number;

  // Learning
  patternsLearned: number;
  totalReward: number;
  avgReward: number;
}

/**
 * Organism summary for lists
 */
export interface OrganismSummary {
  id: string;
  name: string;
  class: OrganismClass;
  specializations: OrganismSpecialization[];
  status: OrganismStatus;
  coherence: number;
  formaBalance: number;
  driveMode: DriveMode;
  isForSale: boolean;
  salePrice: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: ORGANISM INTERACTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Organism message
 */
export interface OrganismMessage {
  id: string;
  organismId: string;
  threadId: string;
  role: "user" | "organism" | "system";
  content: string;
  timestamp: number;
  beat: number;
  artifactType: string | null;
  artifactContent: string | null;
  emotionalValence: number;
  confidence: number;
}

/**
 * Organism thread
 */
export interface OrganismThread {
  id: string;
  organismId: string;
  title: string;
  messages: OrganismMessage[];
  createdAt: number;
  updatedAt: number;
  messageCount: number;
}

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
  beat: number;
  qualityScore: number;
  usageCount: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: ORGANISM TASK TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Task assigned to organism
 */
export interface OrganismTask {
  id: string;
  organismId: string;
  name: string;
  description: string;
  status: "pending" | "running" | "completed" | "failed";
  priority: "critical" | "high" | "normal" | "low";
  createdAt: number;
  startedAt: number | null;
  completedAt: number | null;
  deadline: number | null;
  reward: number;
  qualityScore: number | null;
  result: unknown | null;
  error: string | null;
}

/**
 * Task queue for organism
 */
export interface OrganismTaskQueue {
  organismId: string;
  pendingTasks: OrganismTask[];
  runningTask: OrganismTask | null;
  completedTasks: OrganismTask[];
  failedTasks: OrganismTask[];
  totalReward: number;
  avgQuality: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 10: ORGANISM LEARNING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Learning event
 */
export interface LearningEvent {
  id: string;
  organismId: string;
  timestamp: number;
  beat: number;
  eventType:
    | "pattern_acquired"
    | "skill_improved"
    | "error_corrected"
    | "insight_gained";
  description: string;
  impactScore: number;
  relatedCapability: string | null;
}

/**
 * Pattern schema (learned pattern)
 */
export interface PatternSchema {
  id: string;
  organismId: string;
  name: string;
  description: string;
  learnedAt: number;
  usageCount: number;
  successRate: number;
  complexity: number;
  relatedPatterns: string[];
}

/**
 * Learning state
 */
export interface LearningState {
  organismId: string;
  totalPatterns: number;
  recentEvents: LearningEvent[];
  schemas: PatternSchema[];
  learningRate: number;
  explorationRate: number;
  lastLearningEvent: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 11: ORGANISM COLLABORATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Collaboration session
 */
export interface CollaborationSession {
  id: string;
  organisms: string[];
  purpose: string;
  status: "active" | "completed" | "failed";
  startedAt: number;
  endedAt: number | null;
  sharedContext: Record<string, unknown>;
  results: unknown | null;
}

/**
 * Collaboration metrics
 */
export interface CollaborationMetrics {
  organismId: string;
  totalCollaborations: number;
  successfulCollaborations: number;
  avgCollaborationDuration: number;
  preferredPartners: string[];
  collaborationScore: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 12: ORGANISM ANALYTICS TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Organism performance metrics
 */
export interface OrganismPerformanceMetrics {
  organismId: string;

  // Activity
  totalTasks: number;
  completedTasks: number;
  successRate: number;
  avgTaskDuration: number;

  // Quality
  avgQualityScore: number;
  totalReward: number;

  // Learning
  patternsLearned: number;
  learningVelocity: number;

  // Coherence
  avgCoherence: number;
  coherenceStability: number;

  // Energy
  avgEnergy: number;
  energyEfficiency: number;

  // Time series
  performanceTrend: { timestamp: number; score: number }[];
  coherenceTrend: { timestamp: number; value: number }[];
  energyTrend: { timestamp: number; value: number }[];
}

/**
 * Organism comparison
 */
export interface OrganismComparison {
  organismIds: string[];
  metrics: Record<string, Record<string, number>>;
  rankings: Record<string, string[]>;
  recommendations: string[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 13: ORGANISM MARKETPLACE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Marketplace listing
 */
export interface OrganismListing {
  organism: Organism;
  listingId: string;
  seller: string;
  price: number;
  listedAt: number;
  expiresAt: number | null;
  viewCount: number;
  offerCount: number;
  featured: boolean;
}

/**
 * Purchase offer
 */
export interface PurchaseOffer {
  id: string;
  listingId: string;
  buyer: string;
  offerPrice: number;
  createdAt: number;
  expiresAt: number;
  status: "pending" | "accepted" | "rejected" | "expired";
  message: string | null;
}

/**
 * Marketplace state
 */
export interface MarketplaceState {
  listings: OrganismListing[];
  recentSales: { listingId: string; price: number; timestamp: number }[];
  totalVolume: number;
  avgPrice: number;
  listingCount: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 14: FORM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Create organism form
 */
export interface CreateOrganismForm {
  name: string;
  class: OrganismClass;
  specializations: OrganismSpecialization[];
  specializationType: SpecializedOrganismType | null;
  initialForma: number;
}

/**
 * Assign task form
 */
export interface AssignTaskForm {
  organismId: string;
  name: string;
  description: string;
  priority: "critical" | "high" | "normal" | "low";
  deadline: number | null;
  reward: number;
}

/**
 * List organism form
 */
export interface ListOrganismForm {
  organismId: string;
  price: number;
  expiresAt: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 15: COMPLETE ORGANISM STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Complete organism system state
 */
export interface OrganismSystemState {
  // Organisms
  organisms: Organism[];
  myOrganisms: string[];

  // Tasks
  taskQueues: Record<string, OrganismTaskQueue>;

  // Learning
  learningStates: Record<string, LearningState>;

  // Collaboration
  activeSessions: CollaborationSession[];
  collaborationMetrics: Record<string, CollaborationMetrics>;

  // Analytics
  performanceMetrics: Record<string, OrganismPerformanceMetrics>;

  // Marketplace
  marketplace: MarketplaceState;

  // Threads
  threads: OrganismThread[];

  // Artifacts
  artifacts: ArtifactRecord[];

  // Beat tracking
  currentBeat: number;
  lastUpdateBeat: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 16: VISUALIZATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Organism card data
 */
export interface OrganismCardData {
  organism: OrganismSummary;
  performanceScore: number;
  learningVelocity: number;
  taskCount: number;
  lastActive: string;
}

/**
 * Hz visualization data
 */
export interface HzVisualizationData {
  nodes: {
    k: number;
    name: string;
    frequency: number;
    phase: number;
    amplitude: number;
    x: number;
    y: number;
  }[];
  connections: {
    from: number;
    to: number;
    strength: number;
  }[];
  coherence: number;
}

/**
 * Neurochemical visualization data
 */
export interface NeurochemicalVisualizationData {
  chemicals: {
    name: string;
    level: number;
    color: string;
    effect: string;
  }[];
  dominantChemical: string | null;
  balance: number;
}

/**
 * Organ visualization data
 */
export interface OrganVisualizationData {
  organs: {
    name: string;
    health: number;
    activity: number;
    x: number;
    y: number;
    connections: string[];
  }[];
  overallHealth: number;
}
