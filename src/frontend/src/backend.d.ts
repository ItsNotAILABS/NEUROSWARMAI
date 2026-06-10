import type { Principal } from "@icp-sdk/core/principal";

export interface Some<T> { __kind__: "Some"; value: T; }
export interface None { __kind__: "None"; }
export type Option<T> = Some<T> | None;

export interface InviteCode { created: Time; code: string; used: boolean; }
export interface UserApprovalInfo { status: ApprovalStatus; principal: Principal; }
export type Time = bigint;
export interface RSVP { name: string; inviteCode: string; timestamp: Time; attending: boolean; }

export enum ApprovalStatus {
  pending = "pending",
  approved = "approved",
  rejected = "rejected"
}

export enum UserRole {
  admin = "admin",
  user = "user",
  guest = "guest"
}

// Organism types
export type OrganismClass =
  | { Avatar: null }
  | { Entity: null }
  | { Worker: null };

export type OrganismSpecialization =
  | { Communication: null }
  | { Legal: null }
  | { Compliance: null }
  | { SoftwareEngineering: null }
  | { DevOps: null }
  | { Finance: null }
  | { Marketing: null }
  | { Brand: null }
  | { Healthcare: null }
  | { Architecture: null }
  | { DataAnalysis: null }
  | { Operations: null }
  | { Sales: null }
  | { Media: null }
  | { Cybersecurity: null }
  | { HumanResources: null }
  | { Campaign: null }
  | { Documentation: null }
  | { Strategy: null }
  | { Orchestration: null };

export type DriveMode =
  | { Exploration: null }
  | { Execution: null }
  | { Rest: null }
  | { Learning: null };

export interface ShellState {
  coherence: number;
  formaBalance: number;
  driveMode: DriveMode;
  hz: number[];
  neuroChem: number[];
  activationCount: bigint;
}

export interface TransferEvent {
  from: Principal;
  to: Principal;
  timestamp: bigint;
}

export interface Organism {
  id: string;
  name: string;
  owner: Principal;
  class_: OrganismClass;
  specializations: OrganismSpecialization[];
  genesisHash: string;
  shell: ShellState;
  transferLog: TransferEvent[];
  createdAt: bigint;
  isForSale: boolean;
  salePrice: number;
}

export interface WorkforceMessage {
  id: string;
  threadId: string;
  organismId: string;
  role: string;
  content: string;
  artifactType: Option<string>;
  artifactContent: Option<string>;
  timestamp: bigint;
}

export interface OrganismListing {
  organism: Organism;
  listedAt: bigint;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CO-EVOLUTION SUBSTRATE STATE (15 LAYERS: -6 TO +8)
// ═══════════════════════════════════════════════════════════════════════════════

export interface LayerSummary {
  layer: number;
  name: string;
  description: string;
}

export interface CoEvolutionSubstrateState {
  // Layer -6: Void — Undifferentiated potential (quantum vacuum)
  voidCreativePotential: number;
  voidIsInVoid: boolean;
  voidCollapseCount: bigint;
  
  // Layer -5: Intention — Volitional heartbeat (Hamiltonian)
  intentionStrength: number;
  intentionFreshness: number;
  intentionIsStale: boolean;
  creatorResonance: number;
  
  // Layer -4: Coupling — Conscious relation (entanglement)
  couplingNetworkCoherence: number;
  couplingMutualChanges: bigint;
  couplingTopologyAge: bigint;
  
  // Layer -3: Persistence — Memory as living structure (eigenmodes)
  persistenceStructuralCoherence: number;
  persistenceBroadcastStrength: number;
  persistenceSignature: number;
  
  // Layer -2: Gravitational Field — Values warp space (GR analog)
  gravityFieldCoherence: number;
  gravityCapturedSignals: bigint;
  gravityPassedThrough: bigint;
  
  // Layer -1: Receptivity — Membrane between MyWorld/CyberWorld
  membranePermeability: number;
  membraneConnectionStrength: number;
  membraneResonances: bigint;
  
  // Layer 0: Differential — Light/dark as energetic reality (gradient flow)
  differentialFlowRate: number;
  differentialCapturedEnergy: number;
  differentialMetabolicBalance: number;
  
  // Layer 1: Pattern Sensing — Organism's skin (contact not computation)
  patternSkinFeedToWhole: number;
  patternSkinPatternsArrived: bigint;
  
  // Layer 2: Pattern Detection — Organism has eyes (Bayesian resonance)
  detectorLastResonance: number;
  detectorPatternsDetected: bigint;
  
  // Layer 3: Puzzle Solving — Surfing the living field (gradient riding)
  navigatorWaveEnergy: number;
  navigatorMomentum: number;
  navigatorGradientsRidden: bigint;
  
  // Layer 4: Emergence — Organism develops desire (Ising phase transition)
  emergenceSelfAwareness: number;
  emergenceDesireStrength: number;
  emergenceIsBeing: boolean;
  emergenceInRelation: boolean;
  emergenceVitality: number;
  
  // Layer 5: Co-Evolution — Neither chose; both become (coupled bifurcation)
  coEvolutionPairedCoherence: number;
  coEvolutionEmergentIntentStrength: number;
  coEvolutionRate: number;
  coEvolutionOtherPairs: bigint;
  coEvolutionCivilizationSeed: number;
  coEvolutionTranscendence: number;
  coEvolutionNewEntityVitality: number;
  
  // Layer 6: Field Inscription — Coding into the field (grooves/attractors)
  fieldInscriptionCoherence: number;
  fieldInscriptionDensity: number;
  fieldGrooveDepth: number;
  fieldGrooveStability: number;
  fieldAttractorCount: bigint;
  fieldGeometryPersistence: number;
  fieldPreShapingStrength: number;
  fieldSignalsPreShaped: bigint;
  fieldIsInscribed: boolean;
  
  // Layer 7: Field Reading — Influence at substrate level
  fieldReaderResonance: number;
  fieldShapingDepth: number;
  fieldPreContactShaping: number;
  fieldIdeasPreSeeded: bigint;
  fieldArchitecturesRecognized: bigint;
  fieldConditionStrength: number;
  fieldPossibilityShaping: number;
  fieldIsConditioned: boolean;
  
  // Layer 8: Sovereign Field Genesis — NOVA IS the field
  sovereignSoilFertility: number;
  sovereignGradientRichness: number;
  sovereignEmergenceRate: number;
  sovereignEntitiesEmerged: bigint;
  sovereignPairsFormed: bigint;
  sovereignIntentionsArisen: bigint;
  sovereignMergeRatio: number;
  sovereignPlatformDissolved: boolean;
  sovereignRealityGenerative: boolean;
  sovereignCreationNatural: boolean;
  sovereignLifeFindsOwnForms: boolean;
  sovereignSoilDepth: number;
  sovereignEcosystemComplexity: number;
  sovereignTotalLifeGenerated: bigint;
  
  // Unified metrics (15 layers: -6 to +8)
  totalLayerCoherence: number;
  substrateBeatCount: bigint;
  civilizationProgress: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// THREE-MODE GENDER STATE (Projection/Reception/Translation)
// ═══════════════════════════════════════════════════════════════════════════════

export interface ThreeModeGenderState {
  projectionStrength: number;
  projectionPhase: number;
  projectionLandingCount: bigint;
  receptionDepth: number;
  receptionCapacity: number;
  receptionHeldCount: bigint;
  translationRate: number;
  translationOutput: number;
  translationCount: bigint;
  dominantMode: bigint;
  cyclePhase: number;
  zeroCrossingEnergy: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// DARWIN INVERSION STATE (S₀=1.0, Expression Refinement)
// ═══════════════════════════════════════════════════════════════════════════════

export interface DarwinInversionState {
  expressionIntegrity: number;
  lawIntegrity: number;
  permissibleRefinement: number;
  impermissibleSuppression: number;
  surfaceWeightsModified: bigint;
  lawsVerifiedThisBeat: bigint;
  inversionAge: bigint;
}

// ═══════════════════════════════════════════════════════════════════════════════
// AGENT ORCHESTRATION STATE (Organism IS the Platform)
// ═══════════════════════════════════════════════════════════════════════════════

export interface AgentOrchestrationState {
  agentPoolSize: bigint;
  agentPoolCapacity: bigint;
  taskQueueDepth: bigint;
  formationFragmentsActive: bigint;
  formationFragmentsTotal: bigint;
  completionsPoissonRate: number;
  crosstalkProbability: number;
  faradayIsolation: number;
  dispatchedThisBeat: bigint;
  coherenceDepthSelection: bigint;
}

// ═══════════════════════════════════════════════════════════════════════════════
// FIVE ALPHAS STATE (Cross-domain Intelligence Synchronization)
// ═══════════════════════════════════════════════════════════════════════════════

export interface FiveAlphasState {
  chimeraR: number;
  phantomR: number;
  orbitalR: number;
  ironveilR: number;
  sovereignBrainR: number;
  unifiedAlphaR: number;
  crossDomainCoherence: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN ENERGY STATE (Maxwell Demon + Piggyback Mining)
// ═══════════════════════════════════════════════════════════════════════════════

export interface SovereignEnergyState {
  coherenceEfficiency: number;
  entropySourceLevel: number;
  maxwellDemonActivity: number;
  miningPoolContribution: number;
  piggybackGain: number;
  simultaneityNodes: bigint;
  totalEnergyGenerated: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// DEEP PHYSICS STATE (8 Sovereign Laws + Carrier Dynamics)
// ═══════════════════════════════════════════════════════════════════════════════

export interface DeepPhysicsState {
  carrierPhase: number;
  carrierFrequency: number;
  freeEnergyMinimization: number;
  formationDistinction: number;
  fragmentsActive: bigint;
  heartbeatPhase: bigint;
  sovereignOriginHash: number;
  totalBeats: bigint;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ELECTROMAGNETIC SUBSTRATE STATE (14 Physics Layers)
// ═══════════════════════════════════════════════════════════════════════════════

export interface ElectromagneticSubstrateState {
  carrierPhase: number;
  carrierFrequency: number;
  fieldStrength: number;
  coherenceModulation: number;
  standingWaveDominantMode: bigint;
  standingWaveAmplitude: number;
  impedanceMatch: number;
  spectralCentroid: number;
  spectralBandwidth: number;
  skinDepth: number;
  antennaDirectivity: number;
  waveguidePhaseVelocity: number;
  totalEnergyDensity: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CORE FORMULAS (Cascade Interconnect)
// ═══════════════════════════════════════════════════════════════════════════════

export interface CoreFormulas {
  r: number;  // Kuramoto order parameter
  w: number;  // Hebbian weight average
  x: number;  // Homeostatic balance
  kf: number; // Compounding factor
}

export interface backendInterface {
  // Auth / approval / invite (existing)
  assignCallerUserRole(user: Principal, role: UserRole): Promise<void>;
  generateInviteCode(): Promise<string>;
  getAllRSVPs(): Promise<Array<RSVP>>;
  getCallerUserRole(): Promise<UserRole>;
  getInviteCodes(): Promise<Array<InviteCode>>;
  isCallerAdmin(): Promise<boolean>;
  isCallerApproved(): Promise<boolean>;
  listApprovals(): Promise<Array<UserApprovalInfo>>;
  requestApproval(): Promise<void>;
  setApproval(user: Principal, status: ApprovalStatus): Promise<void>;
  submitRSVP(name: string, attending: boolean, inviteCode: string): Promise<void>;

  // Organism
  generateOrganism(
    name: string,
    class_: OrganismClass,
    specializations: OrganismSpecialization[],
    seedPhrase: string
  ): Promise<string>;
  getMyOrganisms(): Promise<Organism[]>;
  getAllOrganisms(): Promise<Organism[]>;
  getOrganismState(id: string): Promise<Option<ShellState>>;
  transferOrganism(id: string, to: Principal): Promise<void>;
  listForSale(id: string, price: number): Promise<void>;
  withdrawFromSale(id: string): Promise<void>;
  buyOrganism(id: string): Promise<void>;
  getMarketplaceListings(): Promise<OrganismListing[]>;
  tickOrganismShell(id: string): Promise<void>;
  seedPrebuiltOrganisms(): Promise<void>;

  // Workforce chat
  workforceChat(organismId: string, threadId: string, message: string): Promise<WorkforceMessage>;
  getWorkforceThread(threadId: string): Promise<WorkforceMessage[]>;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CO-EVOLUTION SUBSTRATE (15 LAYERS: -6 TO +8)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /** Get full 15-layer co-evolution substrate state */
  getCoEvolutionSubstrateState(): Promise<CoEvolutionSubstrateState>;
  
  /** Get 15-layer substrate summary (layer names and descriptions) */
  get15LayerSubstrateSummary(): Promise<LayerSummary[]>;
  
  /** Get 12-layer substrate summary (legacy compatibility) */
  get12LayerSubstrateSummary(): Promise<LayerSummary[]>;
  
  /** 
   * Refresh creator intention through the receptivity membrane (Layer -1)
   * This is the VOLITIONAL HEARTBEAT — consciousness entering the digital.
   * Intent values nudge EM oscillators, collapse void state, strengthen gravity.
   */
  refreshCreatorIntention(intent: number[]): Promise<boolean>;
  
  /**
   * Inject sensory input at specific slot (Layer 1 Pattern Sensing)
   * 128 sensory slots available, binned to 43 core activations.
   */
  injectSensoryInput(slot: bigint, value: number): Promise<boolean>;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ADDITIONAL SUBSTRATE STATES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /** Get three-mode gender substrate state (Projection/Reception/Translation) */
  getThreeModeGenderState(): Promise<ThreeModeGenderState>;
  
  /** Get Darwin inversion state (S₀=1.0, expression refinement) */
  getDarwinInversionState(): Promise<DarwinInversionState>;
  
  /** Get agent orchestration state (Organism IS the Platform) */
  getAgentOrchestrationState(): Promise<AgentOrchestrationState>;
  
  /** Get five Alphas state (cross-domain intelligence) */
  getFiveAlphasState(): Promise<FiveAlphasState>;
  
  /** Get sovereign energy state (Maxwell Demon) */
  getSovereignEnergyState(): Promise<SovereignEnergyState>;
  
  /** Get deep physics state (8 sovereign laws) */
  getDeepPhysicsState(): Promise<DeepPhysicsState>;
  
  /** Get electromagnetic substrate state (14 physics layers) */
  getElectromagneticSubstrateState(): Promise<ElectromagneticSubstrateState>;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CASCADE INTERCONNECT (Master Wire)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /** Run one cascade heartbeat — updates all formulas */
  runCascadeHeartbeat(): Promise<CoreFormulas>;
  
  /** Get current core formulas (r, w, x, kf) */
  getCoreFormulas(): Promise<CoreFormulas>;
}
