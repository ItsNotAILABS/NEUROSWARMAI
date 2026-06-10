// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  GOVERNANCE TYPES — SOVEREIGN GOVERNANCE ARCHITECTURE                                                     ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import type {
  ActionType,
  DelegationType,
  GovernanceMetric,
  GovernanceRole,
  PriorityLevel,
  ProposalStatus,
  ProposalType,
  VoteType,
} from "./constants";

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: VOTER TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Voter profile
 */
export interface VoterProfile {
  principal: string;
  displayName: string | null;

  // Voting power
  formaBalance: number;
  stakedBalance: number;
  delegatedPowerReceived: number;
  delegatedPowerGiven: number;
  totalVotingPower: number;

  // Coherence multiplier (from organism state)
  coherenceMultiplier: number;

  // Roles
  roles: GovernanceRole[];

  // Stats
  proposalsCreated: number;
  proposalsVoted: number;
  participationRate: number;
  votingConsistency: number;

  // Delegations
  activeDelegationsReceived: number;
  activeDelegationsGiven: number;

  // Temporal
  joinedAt: number;
  lastVoteAt: number | null;
  lastProposalAt: number | null;
}

/**
 * Vote record
 */
export interface VoteRecord {
  id: string;
  proposalId: string;
  voter: string;
  voteType: VoteType;
  votingPower: number;
  timestamp: number;
  beat: number;
  reason: string | null;
  delegatedFrom: string[];
  signature: string | null;
}

/**
 * Vote tally
 */
export interface VoteTally {
  forVotes: number;
  againstVotes: number;
  abstainVotes: number;
  totalVotes: number;
  uniqueVoters: number;
  delegatedVotes: number;
  quorumReached: boolean;
  threshold: number;
  thresholdMet: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: PROPOSAL TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Proposal action
 */
export interface ProposalAction {
  id: string;
  actionType: ActionType;
  target: string;
  method: string;
  parameters: unknown[];
  value: number;
  description: string;
  order: number;
  executed: boolean;
  executedAt: number | null;
  result: unknown | null;
  error: string | null;
}

/**
 * Proposal metadata
 */
export interface ProposalMetadata {
  title: string;
  description: string;
  summary: string;
  category: string;
  tags: string[];
  links: { title: string; url: string }[];
  attachments: { name: string; hash: string; size: number }[];
}

/**
 * Proposal timeline event
 */
export interface ProposalTimelineEvent {
  id: string;
  proposalId: string;
  eventType:
    | "created"
    | "submitted"
    | "voting_started"
    | "voted"
    | "quorum_reached"
    | "passed"
    | "rejected"
    | "queued"
    | "executed"
    | "cancelled"
    | "expired"
    | "failed";
  timestamp: number;
  beat: number;
  actor: string | null;
  details: Record<string, unknown>;
}

/**
 * Full proposal
 */
export interface Proposal {
  id: string;
  proposalNumber: number;
  proposalType: ProposalType;
  status: ProposalStatus;
  priority: PriorityLevel;

  // Content
  metadata: ProposalMetadata;
  actions: ProposalAction[];

  // Proposer
  proposer: string;
  proposerVotingPower: number;
  sponsorsRequired: number;
  sponsors: string[];

  // Timing
  createdAt: number;
  createdBeat: number;
  submittedAt: number | null;
  votingStartBeat: number | null;
  votingEndBeat: number | null;
  executionBeat: number | null;

  // Voting
  tally: VoteTally;
  votes: VoteRecord[];

  // Requirements
  quorumRequired: number;
  thresholdRequired: number;
  executionDelay: number;

  // Timeline
  timeline: ProposalTimelineEvent[];

  // State
  executedAt: number | null;
  cancelledAt: number | null;
  cancelReason: string | null;
  vetoedBy: string | null;
  vetoedAt: number | null;
  vetoReason: string | null;
}

/**
 * Proposal summary (for lists)
 */
export interface ProposalSummary {
  id: string;
  proposalNumber: number;
  proposalType: ProposalType;
  status: ProposalStatus;
  priority: PriorityLevel;
  title: string;
  proposer: string;
  forVotes: number;
  againstVotes: number;
  quorumReached: boolean;
  votingEndBeat: number | null;
  createdAt: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: DELEGATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Delegation record
 */
export interface DelegationRecord {
  id: string;
  delegationType: DelegationType;
  delegator: string;
  delegatee: string;

  // Power
  powerAmount: number;
  powerPercentage: number;

  // Scope
  proposalTypes: ProposalType[] | null; // null = all types

  // Timing
  createdAt: number;
  expiresAt: number | null;
  revokedAt: number | null;

  // State
  isActive: boolean;
  usedInProposals: string[];
}

/**
 * Delegation network node
 */
export interface DelegationNetworkNode {
  principal: string;
  displayName: string | null;
  ownPower: number;
  receivedPower: number;
  delegatedPower: number;
  netPower: number;
  delegationsIn: string[];
  delegationsOut: string[];
}

/**
 * Delegation network
 */
export interface DelegationNetwork {
  nodes: DelegationNetworkNode[];
  edges: { from: string; to: string; power: number }[];
  totalDelegations: number;
  totalDelegatedPower: number;
  avgDelegationChainLength: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: GOVERNANCE ANALYTICS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Governance metric value
 */
export interface GovernanceMetricValue {
  metric: GovernanceMetric;
  value: number;
  change: number;
  changePercent: number;
  trend: "up" | "down" | "stable";
  timestamp: number;
}

/**
 * Governance analytics
 */
export interface GovernanceAnalytics {
  // Overall stats
  totalProposals: number;
  activeProposals: number;
  passedProposals: number;
  rejectedProposals: number;
  executedProposals: number;

  // Voting stats
  totalVotesCast: number;
  uniqueVoters: number;
  avgParticipationRate: number;
  avgQuorumAchievement: number;

  // Power distribution
  totalVotingPower: number;
  topVotersPower: number; // Top 10%
  medianVotingPower: number;
  giniCoefficient: number;

  // Delegation stats
  totalDelegations: number;
  delegatedPowerRatio: number;
  avgDelegationSize: number;

  // Timing stats
  avgVotingDuration: number;
  avgExecutionDelay: number;

  // Metrics
  metrics: GovernanceMetricValue[];

  // Time series
  proposalsOverTime: { timestamp: number; count: number }[];
  participationOverTime: { timestamp: number; rate: number }[];
  votingPowerDistribution: { range: string; count: number }[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: GOVERNANCE EVENTS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Governance event
 */
export interface GovernanceEvent {
  id: string;
  eventType:
    | "proposal_created"
    | "proposal_submitted"
    | "vote_cast"
    | "delegation_created"
    | "delegation_revoked"
    | "proposal_executed"
    | "proposal_cancelled"
    | "quorum_reached"
    | "threshold_met";
  timestamp: number;
  beat: number;
  actor: string;
  proposalId: string | null;
  delegationId: string | null;
  details: Record<string, unknown>;
}

/**
 * Governance activity feed
 */
export interface GovernanceActivityFeed {
  events: GovernanceEvent[];
  totalEvents: number;
  hasMore: boolean;
  lastEventId: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: GOVERNANCE CONFIGURATION
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Governance configuration
 */
export interface GovernanceConfiguration {
  // Voting periods
  votingPeriods: Record<PriorityLevel, number>;

  // Quorum requirements
  quorumRequirements: Record<ProposalType, number>;

  // Threshold requirements
  thresholdRequirements: Record<ProposalType, number>;

  // Execution delays
  executionDelays: Record<PriorityLevel, number>;

  // Proposal thresholds
  proposalThresholds: Record<ProposalType, number>;

  // Limits
  maxActionsPerProposal: number;
  maxActiveProposals: number;
  maxDelegations: number;

  // Features
  delegationEnabled: boolean;
  vetoEnabled: boolean;
  emergencyActionsEnabled: boolean;

  // Guardians
  guardians: string[];

  // Last updated
  updatedAt: number;
  updatedBy: string;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: GOVERNANCE STATE
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Complete governance state
 */
export interface GovernanceState {
  // Configuration
  config: GovernanceConfiguration;

  // Proposals
  proposals: Proposal[];
  activeProposalIds: string[];
  queuedProposalIds: string[];
  proposalCount: number;

  // Voters
  voters: VoterProfile[];
  voterCount: number;
  totalVotingPower: number;

  // Delegations
  delegations: DelegationRecord[];
  delegationNetwork: DelegationNetwork;

  // Analytics
  analytics: GovernanceAnalytics;

  // Activity
  recentActivity: GovernanceActivityFeed;

  // Beat tracking
  currentBeat: number;
  lastUpdateBeat: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: FORM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Create proposal form
 */
export interface CreateProposalForm {
  proposalType: ProposalType;
  priority: PriorityLevel;
  title: string;
  description: string;
  summary: string;
  category: string;
  tags: string[];
  actions: Omit<
    ProposalAction,
    "id" | "executed" | "executedAt" | "result" | "error"
  >[];
}

/**
 * Cast vote form
 */
export interface CastVoteForm {
  proposalId: string;
  voteType: VoteType;
  reason: string | null;
}

/**
 * Create delegation form
 */
export interface CreateDelegationForm {
  delegationType: DelegationType;
  delegatee: string;
  powerPercentage: number;
  proposalTypes: ProposalType[] | null;
  expiresAt: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: VISUALIZATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Proposal card data
 */
export interface ProposalCardData {
  proposal: ProposalSummary;
  timeRemaining: string | null;
  votingProgress: number;
  quorumProgress: number;
  userVote: VoteType | null;
  userCanVote: boolean;
}

/**
 * Voter card data
 */
export interface VoterCardData {
  voter: VoterProfile;
  rank: number;
  powerPercentage: number;
  recentActivity: GovernanceEvent[];
}

/**
 * Delegation graph node
 */
export interface DelegationGraphNode {
  id: string;
  label: string;
  power: number;
  x: number;
  y: number;
  color: string;
  size: number;
}

/**
 * Delegation graph edge
 */
export interface DelegationGraphEdge {
  id: string;
  source: string;
  target: string;
  power: number;
  weight: number;
}

/**
 * Delegation graph
 */
export interface DelegationGraph {
  nodes: DelegationGraphNode[];
  edges: DelegationGraphEdge[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 10: NOTIFICATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Governance notification
 */
export interface GovernanceNotification {
  id: string;
  type:
    | "new_proposal"
    | "voting_started"
    | "voting_ending"
    | "quorum_reached"
    | "proposal_passed"
    | "proposal_rejected"
    | "proposal_executed"
    | "delegation_received"
    | "delegation_revoked";
  title: string;
  message: string;
  proposalId: string | null;
  delegationId: string | null;
  timestamp: number;
  read: boolean;
  actionUrl: string | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 11: TREASURY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Treasury balance
 */
export interface TreasuryBalance {
  token: string;
  balance: number;
  lockedBalance: number;
  availableBalance: number;
  pendingOutflow: number;
  pendingInflow: number;
  lastUpdated: number;
}

/**
 * Treasury transaction
 */
export interface TreasuryTransaction {
  id: string;
  type: "inflow" | "outflow" | "lock" | "unlock";
  token: string;
  amount: number;
  from: string;
  to: string;
  proposalId: string | null;
  description: string;
  timestamp: number;
  beat: number;
  status: "pending" | "completed" | "failed";
}

/**
 * Treasury state
 */
export interface TreasuryState {
  balances: TreasuryBalance[];
  recentTransactions: TreasuryTransaction[];
  totalValueUSD: number;
  lastAudit: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 12: GUARDIAN TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Guardian action
 */
export interface GuardianAction {
  id: string;
  guardian: string;
  actionType:
    | "veto"
    | "emergency_stop"
    | "emergency_resume"
    | "parameter_override";
  proposalId: string | null;
  reason: string;
  timestamp: number;
  beat: number;
  reversed: boolean;
  reversedBy: string | null;
  reversedAt: number | null;
}

/**
 * Guardian state
 */
export interface GuardianState {
  guardians: string[];
  actions: GuardianAction[];
  emergencyActive: boolean;
  lastEmergencyAction: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 13: HISTORICAL TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Historical proposal data
 */
export interface HistoricalProposalData {
  proposal: Proposal;
  finalTally: VoteTally;
  executionResult: unknown | null;
  impact: string | null;
}

/**
 * Governance history
 */
export interface GovernanceHistory {
  proposals: HistoricalProposalData[];
  totalProposals: number;
  passRate: number;
  avgParticipation: number;
  periodStart: number;
  periodEnd: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 14: SIMULATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Vote simulation
 */
export interface VoteSimulation {
  proposalId: string;
  currentTally: VoteTally;
  simulatedVotes: { voter: string; voteType: VoteType; power: number }[];
  projectedTally: VoteTally;
  projectedOutcome: "pass" | "fail" | "pending";
  confidenceLevel: number;
}

/**
 * Quorum simulation
 */
export interface QuorumSimulation {
  proposalId: string;
  currentParticipation: number;
  requiredQuorum: number;
  projectedParticipation: number;
  likelyVoters: string[];
  timeToQuorum: number | null;
}
