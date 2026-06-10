// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  QUANTUM TYPES — DEEP MEMORY ARCHITECTURE                                                                 ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  WHAT MAKES MEMORY "QUANTUM" IN THIS ARCHITECTURE:                                                       ║
// ║  1. Superposition — Multi-state persistence                                                               ║
// ║  2. Entanglement — Cross-canister binding                                                                 ║
// ║  3. Collapse — Artifact execution                                                                         ║
// ║  4. Forward Secrecy — Temporal quantum binding                                                            ║
// ║  5. Resonance — Oro's memory model                                                                        ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import type {
  CollapseTrigger,
  EntanglementType,
  FrequencyBandName,
  QuantumMemoryLayer,
  QuantumState,
  SovereignCanister,
  SovereignMetal,
} from "./constants";

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: QUANTUM MEMORY CELL
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Quantum amplitude (complex number representation)
 */
export interface QuantumAmplitude {
  real: number;
  imaginary: number;
}

/**
 * Single quantum memory cell
 */
export interface QuantumMemoryCell {
  id: string;
  layer: QuantumMemoryLayer;
  frequencyBand: FrequencyBandName;

  // Quantum state
  state: QuantumState;
  amplitude: QuantumAmplitude;
  phase: number; // [0, 2π)
  probability: number; // |amplitude|²

  // Content
  content: unknown;
  contentType: string;
  contentHash: number;

  // Temporal
  createdAt: number;
  lastAccessed: number;
  accessCount: number;

  // Entanglement
  entangledWith: string[]; // IDs of entangled cells
  entanglementType: EntanglementType | null;

  // Ratchet
  ratchetState: number;
  ratchetBeat: number;
}

/**
 * Quantum memory layer state
 */
export interface QuantumMemoryLayerState {
  layer: QuantumMemoryLayer;
  cells: QuantumMemoryCell[];
  totalCells: number;
  activeCount: number;
  superpositionCount: number;
  entangledCount: number;
  collapsedCount: number;
  avgCoherence: number;
  totalEnergy: number;
}

/**
 * Complete quantum memory state
 */
export interface QuantumMemoryState {
  working: QuantumMemoryLayerState;
  deep: QuantumMemoryLayerState;
  resonance: QuantumMemoryLayerState;
  totalCells: number;
  globalCoherence: number;
  globalPhase: number;
  currentBeat: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: QUANTUM-RESISTANT PRINCIPAL LOCK
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Hash layer result
 */
export interface HashLayerResult {
  layer: number;
  name: string;
  input: string | number;
  output: number;
  timestamp: number;
}

/**
 * Ratchet state
 */
export interface RatchetState {
  currentValue: number;
  beat: number;
  genesisSeed: string;
  chainLength: number;
  lastAdvance: number;
  entropy: number;
}

/**
 * Principal lock state
 */
export interface PrincipalLockState {
  // Hash layers
  h1_fnv1a: number;
  h2_djb2: number;
  h3_sdbm: number;
  combined: number;

  // Ratchet
  ratchet: RatchetState;

  // Depth challenge
  challengeWindow: number;
  currentDepth: number;
  lastChallengeTime: number;

  // Lock strength
  lockStrength: number;
  coherenceContribution: number;
  hzContribution: number;
  entropyContribution: number;

  // Status
  isLocked: boolean;
  lastUnlock: number | null;
  failedAttempts: number;
}

/**
 * Lock verification request
 */
export interface LockVerificationRequest {
  principal: string;
  context: number;
  salt: number;
  challengeResponse: number;
  beat: number;
}

/**
 * Lock verification result
 */
export interface LockVerificationResult {
  success: boolean;
  layersVerified: number;
  failedAt: string | null;
  lockStrength: number;
  timestamp: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: SUPERPOSITION STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Superposition branch
 */
export interface SuperpositionBranch {
  id: string;
  probability: number;
  state: unknown;
  createdAt: number;
  conditions: string[];
}

/**
 * Superposition state (multiple possibilities)
 */
export interface SuperpositionState {
  id: string;
  branches: SuperpositionBranch[];
  totalBranches: number;
  dominantBranch: string | null;
  dominantProbability: number;
  collapseReady: boolean;
  lastMeasurement: number | null;
}

/**
 * Collapse event
 */
export interface CollapseEvent {
  id: string;
  superpositionId: string;
  trigger: CollapseTrigger;
  selectedBranch: string;
  collapsedState: unknown;
  eliminatedBranches: string[];
  timestamp: number;
  beat: number;
  artifactId: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: ENTANGLEMENT STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Entanglement pair
 */
export interface EntanglementPair {
  id: string;
  cellA: string;
  cellB: string;
  type: EntanglementType;
  strength: number; // [0, 1]
  createdAt: number;
  lastCorrelation: number;
  correlationCount: number;
}

/**
 * Cross-canister entanglement
 */
export interface CrossCanisterEntanglement {
  id: string;
  sourceCanister: SovereignCanister;
  targetCanister: SovereignCanister;
  projectPrincipal: string; // Reference anchor
  entangledCells: string[];
  strength: number;
  createdAt: number;
  lastSync: number;
}

/**
 * Entanglement network
 */
export interface EntanglementNetwork {
  pairs: EntanglementPair[];
  crossCanister: CrossCanisterEntanglement[];
  totalEntanglements: number;
  avgStrength: number;
  networkCoherence: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: FORWARD SECRECY (TEMPORAL BINDING)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Sealed memory segment
 */
export interface SealedMemorySegment {
  id: string;
  startBeat: number;
  endBeat: number;
  finalRatchetValue: number;
  cellCount: number;
  contentHashes: number[];
  sealedAt: number;
  irreversible: boolean;
}

/**
 * Forward secrecy state
 */
export interface ForwardSecrecyState {
  currentBeat: number;
  ratchetState: RatchetState;
  sealedSegments: SealedMemorySegment[];
  totalSealed: number;
  lastSeal: number;
  nextSealBeat: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: ORO RESONANCE MEMORY
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Session record
 */
export interface SessionRecord {
  id: string;
  startTime: number;
  endTime: number | null;
  duration: number;
  messageCount: number;
  questionCount: number;
  commandCount: number;
  artifactsGenerated: number;
  avgResponseTime: number;
}

/**
 * Standing instruction
 */
export interface StandingInstruction {
  id: string;
  instruction: string;
  priority: number;
  createdAt: number;
  lastApplied: number;
  applyCount: number;
  active: boolean;
  scope: "global" | "project" | "session";
}

/**
 * Output cadence measurement
 */
export interface OutputCadence {
  timestamp: number;
  responseTimeMs: number;
  tokenCount: number;
  contentType: string;
}

/**
 * Activity rhythm (hourly bins)
 */
export interface ActivityRhythm {
  hour: number; // 0-23
  avgActivity: number; // Rolling average
  peakDays: number[]; // Days of week with peaks
  questionTypes: Record<string, number>;
}

/**
 * Oro resonance profile
 */
export interface OroResonanceProfile {
  principalId: string;

  // Sessions
  sessions: SessionRecord[];
  totalSessions: number;
  avgSessionDuration: number;

  // Standing instructions
  standingInstructions: StandingInstruction[];
  activeInstructions: number;

  // Cadence
  cadenceMeasurements: OutputCadence[];
  rollingAvgResponseTime: number;

  // Rhythm
  activityRhythm: ActivityRhythm[];
  peakHours: number[];
  mostActiveDay: number;

  // Question analysis
  questionTypeDistribution: Record<string, number>;
  topQuestionTypes: string[];

  // Resonance metrics
  resonanceScore: number;
  consistencyIndex: number;
  engagementLevel: number;

  // Temporal
  firstSession: number;
  lastSession: number;
  totalInteractionTime: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: FREQUENCY-LAYERED COGNITIVE STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Frequency layer state
 */
export interface FrequencyLayerState {
  band: FrequencyBandName;
  currentHz: number;
  phase: number;
  amplitude: number;
  activity: number;

  // Content
  activeProcesses: number;
  pendingItems: number;

  // Coupling
  couplingToLower: number;
  couplingToHigher: number;
}

/**
 * Cross-frequency coupling event
 */
export interface CrossFrequencyCouplingEvent {
  id: string;
  fromBand: FrequencyBandName;
  toBand: FrequencyBandName;
  strength: number;
  timestamp: number;
  trigger: string;
  dataTransferred: number;
}

/**
 * Cognitive architecture state
 */
export interface CognitiveArchitectureState {
  layers: Record<FrequencyBandName, FrequencyLayerState>;
  couplingEvents: CrossFrequencyCouplingEvent[];
  globalSynchronization: number;
  dominantBand: FrequencyBandName;
  currentMode:
    | "inference"
    | "preparation"
    | "gating"
    | "orchestration"
    | "consolidation";
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: SOVEREIGN CANISTER STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Canister memory state
 */
export interface CanisterMemoryState {
  canister: SovereignCanister;
  stableMemoryUsed: number;
  stableMemoryMax: number;
  heapUsed: number;
  heapMax: number;
  cellCount: number;
  lastWrite: number;
  lastRead: number;
  writeCount: number;
  readCount: number;
}

/**
 * Inter-canister call record
 */
export interface InterCanisterCall {
  id: string;
  source: SovereignCanister;
  target: SovereignCanister;
  method: string;
  timestamp: number;
  latencyMs: number;
  success: boolean;
  dataSize: number;
}

/**
 * Sovereign canister network state
 */
export interface SovereignCanisterNetwork {
  canisters: Record<SovereignCanister, CanisterMemoryState>;
  interCanisterCalls: InterCanisterCall[];
  totalCalls: number;
  avgLatency: number;
  networkHealth: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: SOVEREIGN METALS STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Metal conductivity state
 */
export interface MetalConductivityState {
  metal: SovereignMetal;
  baseValue: number; // Classical reference (for display)
  sovereignValue: number; // Always 1.0
  currentConductivity: number;
  contribution: string;
  lastMeasurement: number;
}

/**
 * Alloy state (combined metals)
 */
export interface AlloyState {
  metals: MetalConductivityState[];
  totalConductivity: number;
  sovereignStrength: number;
  resonanceAmplification: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 10: QUANTUM BATTERY STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Quantum battery cell
 */
export interface QuantumBatteryCell {
  id: number;
  charge: number; // [0, 1]
  entangled: boolean;
  entangledPartner: number | null;
  coherenceTime: number;
}

/**
 * Quantum battery state
 */
export interface QuantumBatteryState {
  cells: QuantumBatteryCell[];
  totalCapacity: number;
  currentCharge: number;
  chargeRate: number;
  dischargeRate: number;
  efficiency: number;
  entanglementBonus: number;
  coherenceMultiplier: number;
  lastCharge: number;
  lastDischarge: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 11: AGENT RECOMMENDATION (SUPERPOSITION → COLLAPSE)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Agent recommendation (in superposition until executed)
 */
export interface AgentRecommendation {
  id: string;
  agentId: string;
  agentName: string;

  // Superposition state
  inSuperposition: boolean;
  possibleActions: string[];
  probabilities: number[];

  // Content
  recommendation: string;
  confidence: number;
  reasoning: string;

  // Temporal
  createdAt: number;
  expiresAt: number;

  // Collapse info
  collapsed: boolean;
  collapsedAction: string | null;
  collapseTime: number | null;
  collapseTrigger: CollapseTrigger | null;
  artifactId: string | null;

  // Learning
  outcomeRecorded: boolean;
  outcomePositive: boolean | null;
}

/**
 * Agent state in quantum memory
 */
export interface AgentQuantumState {
  agentId: string;
  agentName: string;
  recommendations: AgentRecommendation[];
  totalRecommendations: number;
  collapsedCount: number;
  avgConfidence: number;
  successRate: number;
  lastActivity: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 12: PROJECT ENTANGLEMENT (ANCHOR)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Project as quantum anchor
 */
export interface ProjectQuantumAnchor {
  projectId: string;
  projectName: string;
  principal: string;

  // Entangled canisters
  entangledCanisters: SovereignCanister[];
  entanglementStrengths: Record<SovereignCanister, number>;

  // Linked data
  safetyRecords: number; // JHAs
  financeRecords: number; // Budget items
  teamAssignments: number;
  agentRecommendations: number;

  // Quantum state
  coherence: number;
  totalEntangledCells: number;
  lastSync: number;

  // Temporal
  createdAt: number;
  lastActivity: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 13: INTELLIGENCE SYNTHESIS (CORPUS CALLOSUM)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Cross-departmental context
 */
export interface CrossDepartmentalContext {
  id: string;
  departments: string[];
  sharedEntities: string[];
  correlations: Record<string, number>;
  lastUpdate: number;
}

/**
 * Intelligence synthesis state (bridges all 14 agents)
 */
export interface IntelligenceSynthesisState {
  activeAgents: string[];
  bridgedContexts: CrossDepartmentalContext[];
  totalBridges: number;
  synthesisScore: number;
  lastSynthesis: number;
  pendingCorrelations: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 14: REWARD CASCADE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Reward signal
 */
export interface RewardSignal {
  id: string;
  trigger: CollapseTrigger;
  magnitude: number;
  source: string;
  timestamp: number;
  beat: number;
}

/**
 * Reward cascade (theta-gamma coupling)
 */
export interface RewardCascade {
  id: string;
  initialSignal: RewardSignal;
  cascadeSteps: {
    band: FrequencyBandName;
    timestamp: number;
    amplitude: number;
  }[];
  totalAmplification: number;
  consolidatedToDeep: boolean;
  consolidationTime: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 15: COMPLETE QUANTUM DEEP MEMORY STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Complete quantum deep memory state
 */
export interface QuantumDeepMemoryState {
  // Memory layers
  memory: QuantumMemoryState;

  // Security
  principalLock: PrincipalLockState;
  forwardSecrecy: ForwardSecrecyState;

  // Quantum properties
  superpositions: SuperpositionState[];
  entanglementNetwork: EntanglementNetwork;
  collapseHistory: CollapseEvent[];

  // Oro
  oroResonance: OroResonanceProfile | null;

  // Cognitive architecture
  cognitiveState: CognitiveArchitectureState;

  // Infrastructure
  canisterNetwork: SovereignCanisterNetwork;
  alloyState: AlloyState;
  quantumBattery: QuantumBatteryState;

  // Agents
  agentStates: AgentQuantumState[];

  // Projects
  projectAnchors: ProjectQuantumAnchor[];

  // Intelligence synthesis
  intelligenceSynthesis: IntelligenceSynthesisState;

  // Rewards
  rewardCascades: RewardCascade[];

  // Global metrics
  globalCoherence: number;
  totalMemoryCells: number;
  currentBeat: number;
  genesisTime: number;
  uptime: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 16: VISUALIZATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Memory cell visualization
 */
export interface MemoryCellVisualization {
  id: string;
  x: number;
  y: number;
  radius: number;
  color: string;
  opacity: number;
  layer: QuantumMemoryLayer;
  state: QuantumState;
  entanglementLines: { targetId: string; strength: number }[];
}

/**
 * Frequency band visualization
 */
export interface FrequencyBandVisualization {
  band: FrequencyBandName;
  y: number;
  height: number;
  color: string;
  waveAmplitude: number;
  waveFrequency: number;
  activity: number;
}

/**
 * Ratchet visualization
 */
export interface RatchetVisualization {
  currentBeat: number;
  chainLinks: {
    beat: number;
    value: number;
    sealed: boolean;
  }[];
  windowStart: number;
  windowEnd: number;
}

/**
 * Lock strength visualization
 */
export interface LockStrengthVisualization {
  layers: {
    name: string;
    verified: boolean;
    strength: number;
  }[];
  totalStrength: number;
  isLocked: boolean;
}
