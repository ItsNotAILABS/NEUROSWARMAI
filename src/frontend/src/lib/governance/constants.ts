// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  GOVERNANCE CONSTANTS — SOVEREIGN GOVERNANCE ARCHITECTURE                                                 ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════
// GOVERNANCE PARAMETERS
// ═══════════════════════════════════════════════════════════════════════════════

export const GOVERNANCE_PARAMS = {
  // Voting periods (in beats)
  VOTING_PERIOD_SHORT: 500, // ~41 seconds at 12 Hz
  VOTING_PERIOD_STANDARD: 1000, // ~83 seconds
  VOTING_PERIOD_LONG: 5000, // ~7 minutes
  VOTING_PERIOD_EXTENDED: 10000, // ~14 minutes

  // Quorum requirements
  QUORUM_PERCENTAGE_LOW: 0.2, // 20% for minor proposals
  QUORUM_PERCENTAGE_STANDARD: 0.33, // 33% for standard proposals
  QUORUM_PERCENTAGE_HIGH: 0.5, // 50% for major changes
  QUORUM_PERCENTAGE_CRITICAL: 0.67, // 67% for critical decisions

  // Supermajority thresholds
  SIMPLE_MAJORITY: 0.5, // 50% + 1
  SUPERMAJORITY_LOW: 0.6, // 60%
  SUPERMAJORITY_STANDARD: 0.67, // 67%
  SUPERMAJORITY_HIGH: 0.75, // 75%
  SUPERMAJORITY_CRITICAL: 0.8, // 80%

  // Proposal thresholds (FORMA required)
  PROPOSAL_THRESHOLD_MINOR: 10,
  PROPOSAL_THRESHOLD_STANDARD: 100,
  PROPOSAL_THRESHOLD_MAJOR: 1000,
  PROPOSAL_THRESHOLD_CRITICAL: 10000,

  // Execution delays (in beats)
  EXECUTION_DELAY_IMMEDIATE: 0,
  EXECUTION_DELAY_SHORT: 100,
  EXECUTION_DELAY_STANDARD: 500,
  EXECUTION_DELAY_LONG: 1000,

  // Limits
  MAX_ACTIONS_PER_PROPOSAL: 10,
  MAX_ACTIVE_PROPOSALS: 100,
  MAX_VOTES_PER_USER: 1,
  MAX_DELEGATIONS: 10,

  // Timeouts
  PROPOSAL_EXPIRY_BEATS: 50000,
  DELEGATION_EXPIRY_BEATS: 100000,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// PROPOSAL TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const PROPOSAL_TYPES = [
  "ParameterChange", // Change system parameters
  "TreasuryAllocation", // Allocate treasury funds
  "UpgradeProposal", // Upgrade canister code
  "PolicyChange", // Change policies
  "EmergencyAction", // Emergency actions
  "OrganismModification", // Modify organism parameters
  "WorkflowChange", // Change workflow definitions
  "AccessControl", // Modify access controls
  "TokenEconomics", // Modify token economics
  "GovernanceChange", // Modify governance parameters
  "IntegrationProposal", // Add/remove integrations
  "StrategicDecision", // Major strategic decisions
] as const;

export type ProposalType = (typeof PROPOSAL_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// PROPOSAL STATUSES
// ═══════════════════════════════════════════════════════════════════════════════

export const PROPOSAL_STATUSES = [
  "Draft", // Being prepared
  "Pending", // Awaiting voting period
  "Active", // Voting in progress
  "Passed", // Voting passed
  "Rejected", // Voting rejected
  "Queued", // Queued for execution
  "Executed", // Successfully executed
  "Cancelled", // Cancelled by proposer
  "Expired", // Expired without execution
  "Failed", // Execution failed
  "Vetoed", // Vetoed by guardian
] as const;

export type ProposalStatus = (typeof PROPOSAL_STATUSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// VOTE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const VOTE_TYPES = ["For", "Against", "Abstain"] as const;

export type VoteType = (typeof VOTE_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// GOVERNANCE ROLES
// ═══════════════════════════════════════════════════════════════════════════════

export const GOVERNANCE_ROLES = [
  "Citizen", // Basic voting rights
  "Delegate", // Can receive delegations
  "Proposer", // Can create proposals
  "Guardian", // Emergency veto power
  "Admin", // Full admin access
  "Observer", // Read-only access
] as const;

export type GovernanceRole = (typeof GOVERNANCE_ROLES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// ACTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const ACTION_TYPES = [
  "TransferTokens",
  "UpdateParameter",
  "UpgradeCanister",
  "MintTokens",
  "BurnTokens",
  "GrantRole",
  "RevokeRole",
  "PauseSystem",
  "ResumeSystem",
  "EmergencyStop",
  "ModifyOrganism",
  "CreateWorkflow",
  "UpdateWorkflow",
  "DeleteWorkflow",
] as const;

export type ActionType = (typeof ACTION_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// DELEGATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const DELEGATION_TYPES = [
  "Full", // All voting power
  "Partial", // Percentage of voting power
  "TopicSpecific", // Only for specific proposal types
  "TimeLimit", // With expiration
] as const;

export type DelegationType = (typeof DELEGATION_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// PRIORITY LEVELS
// ═══════════════════════════════════════════════════════════════════════════════

export const PRIORITY_LEVELS = [
  "Low",
  "Medium",
  "High",
  "Critical",
  "Emergency",
] as const;

export type PriorityLevel = (typeof PRIORITY_LEVELS)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// STATUS COLORS
// ═══════════════════════════════════════════════════════════════════════════════

export const PROPOSAL_STATUS_COLORS: Record<ProposalStatus, string> = {
  Draft: "oklch(60% 0.1 240)",
  Pending: "oklch(60% 0.15 60)",
  Active: "oklch(70% 0.2 210)",
  Passed: "oklch(70% 0.2 150)",
  Rejected: "oklch(60% 0.2 30)",
  Queued: "oklch(65% 0.15 270)",
  Executed: "oklch(70% 0.2 120)",
  Cancelled: "oklch(50% 0.05 240)",
  Expired: "oklch(50% 0.1 30)",
  Failed: "oklch(50% 0.2 0)",
  Vetoed: "oklch(50% 0.2 330)",
};

export const VOTE_TYPE_COLORS: Record<VoteType, string> = {
  For: "oklch(70% 0.2 150)",
  Against: "oklch(60% 0.2 30)",
  Abstain: "oklch(60% 0.1 240)",
};

export const PRIORITY_COLORS: Record<PriorityLevel, string> = {
  Low: "oklch(60% 0.1 240)",
  Medium: "oklch(65% 0.15 60)",
  High: "oklch(65% 0.2 30)",
  Critical: "oklch(60% 0.25 0)",
  Emergency: "oklch(50% 0.3 330)",
};

// ═══════════════════════════════════════════════════════════════════════════════
// GOVERNANCE METRICS
// ═══════════════════════════════════════════════════════════════════════════════

export const GOVERNANCE_METRICS = {
  PARTICIPATION_RATE: "participation_rate",
  PROPOSAL_SUCCESS_RATE: "proposal_success_rate",
  AVG_VOTING_TIME: "avg_voting_time",
  DELEGATION_RATIO: "delegation_ratio",
  QUORUM_ACHIEVEMENT_RATE: "quorum_achievement_rate",
  EXECUTION_SUCCESS_RATE: "execution_success_rate",
  VOTER_TURNOUT: "voter_turnout",
  PROPOSAL_VELOCITY: "proposal_velocity",
} as const;

export type GovernanceMetric =
  (typeof GOVERNANCE_METRICS)[keyof typeof GOVERNANCE_METRICS];

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Calculate voting power
 */
export function calculateVotingPower(
  formaBalance: number,
  stakedBalance: number,
  delegatedPower: number,
  coherenceMultiplier = 1,
): number {
  const basePower = formaBalance + stakedBalance * 1.5;
  return (basePower + delegatedPower) * coherenceMultiplier;
}

/**
 * Check if quorum is met
 */
export function isQuorumMet(
  totalVotes: number,
  totalVotingPower: number,
  quorumPercentage: number,
): boolean {
  return totalVotes / totalVotingPower >= quorumPercentage;
}

/**
 * Check if proposal passed
 */
export function isProposalPassed(
  forVotes: number,
  againstVotes: number,
  threshold: number,
): boolean {
  const total = forVotes + againstVotes;
  if (total === 0) return false;
  return forVotes / total >= threshold;
}

/**
 * Calculate time remaining
 */
export function calculateTimeRemaining(
  endBeat: number,
  currentBeat: number,
  beatsPerSecond = 12,
): { beats: number; seconds: number; display: string } {
  const beatsRemaining = Math.max(0, endBeat - currentBeat);
  const secondsRemaining = beatsRemaining / beatsPerSecond;

  if (secondsRemaining < 60) {
    return {
      beats: beatsRemaining,
      seconds: secondsRemaining,
      display: `${Math.ceil(secondsRemaining)}s`,
    };
  }
  if (secondsRemaining < 3600) {
    return {
      beats: beatsRemaining,
      seconds: secondsRemaining,
      display: `${Math.ceil(secondsRemaining / 60)}m`,
    };
  }
  return {
    beats: beatsRemaining,
    seconds: secondsRemaining,
    display: `${Math.ceil(secondsRemaining / 3600)}h`,
  };
}

/**
 * Get required quorum for proposal type
 */
export function getRequiredQuorum(proposalType: ProposalType): number {
  switch (proposalType) {
    case "EmergencyAction":
    case "GovernanceChange":
      return GOVERNANCE_PARAMS.QUORUM_PERCENTAGE_CRITICAL;
    case "UpgradeProposal":
    case "TokenEconomics":
      return GOVERNANCE_PARAMS.QUORUM_PERCENTAGE_HIGH;
    case "TreasuryAllocation":
    case "PolicyChange":
      return GOVERNANCE_PARAMS.QUORUM_PERCENTAGE_STANDARD;
    default:
      return GOVERNANCE_PARAMS.QUORUM_PERCENTAGE_LOW;
  }
}

/**
 * Get required threshold for proposal type
 */
export function getRequiredThreshold(proposalType: ProposalType): number {
  switch (proposalType) {
    case "EmergencyAction":
    case "GovernanceChange":
      return GOVERNANCE_PARAMS.SUPERMAJORITY_CRITICAL;
    case "UpgradeProposal":
    case "TokenEconomics":
      return GOVERNANCE_PARAMS.SUPERMAJORITY_HIGH;
    case "TreasuryAllocation":
    case "PolicyChange":
      return GOVERNANCE_PARAMS.SUPERMAJORITY_STANDARD;
    default:
      return GOVERNANCE_PARAMS.SIMPLE_MAJORITY;
  }
}

/**
 * Get voting period for proposal type
 */
export function getVotingPeriod(proposalType: ProposalType): number {
  switch (proposalType) {
    case "EmergencyAction":
      return GOVERNANCE_PARAMS.VOTING_PERIOD_SHORT;
    case "GovernanceChange":
    case "UpgradeProposal":
      return GOVERNANCE_PARAMS.VOTING_PERIOD_EXTENDED;
    case "TreasuryAllocation":
    case "PolicyChange":
      return GOVERNANCE_PARAMS.VOTING_PERIOD_LONG;
    default:
      return GOVERNANCE_PARAMS.VOTING_PERIOD_STANDARD;
  }
}

/**
 * Get execution delay for proposal type
 */
export function getExecutionDelay(proposalType: ProposalType): number {
  switch (proposalType) {
    case "EmergencyAction":
      return GOVERNANCE_PARAMS.EXECUTION_DELAY_IMMEDIATE;
    case "UpgradeProposal":
    case "GovernanceChange":
      return GOVERNANCE_PARAMS.EXECUTION_DELAY_LONG;
    case "TreasuryAllocation":
      return GOVERNANCE_PARAMS.EXECUTION_DELAY_STANDARD;
    default:
      return GOVERNANCE_PARAMS.EXECUTION_DELAY_SHORT;
  }
}

/**
 * Get proposal threshold for type
 */
export function getProposalThreshold(proposalType: ProposalType): number {
  switch (proposalType) {
    case "EmergencyAction":
    case "GovernanceChange":
      return GOVERNANCE_PARAMS.PROPOSAL_THRESHOLD_CRITICAL;
    case "UpgradeProposal":
    case "TokenEconomics":
      return GOVERNANCE_PARAMS.PROPOSAL_THRESHOLD_MAJOR;
    case "TreasuryAllocation":
    case "PolicyChange":
      return GOVERNANCE_PARAMS.PROPOSAL_THRESHOLD_STANDARD;
    default:
      return GOVERNANCE_PARAMS.PROPOSAL_THRESHOLD_MINOR;
  }
}

/**
 * Format voting power
 */
export function formatVotingPower(power: number): string {
  if (power >= 1_000_000) {
    return `${(power / 1_000_000).toFixed(1)}M`;
  }
  if (power >= 1_000) {
    return `${(power / 1_000).toFixed(1)}K`;
  }
  return power.toFixed(0);
}

/**
 * Calculate participation rate
 */
export function calculateParticipationRate(
  uniqueVoters: number,
  eligibleVoters: number,
): number {
  if (eligibleVoters === 0) return 0;
  return uniqueVoters / eligibleVoters;
}
