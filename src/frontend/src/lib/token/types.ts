// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  TOKEN ECONOMY TYPES — FORMA TOKEN ARCHITECTURE                                                           ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import type {
  AllocationCategory,
  RewardCategory,
  StakingTier,
  TransactionStatus,
  TransactionType,
  VestingType,
} from "./constants";

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 1: ACCOUNT TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token balance
 */
export interface TokenBalance {
  principal: string;
  totalBalance: number;
  availableBalance: number;
  stakedBalance: number;
  lockedBalance: number;
  pendingRewards: number;
  delegatedBalance: number;
  lastUpdated: number;
}

/**
 * Account overview
 */
export interface AccountOverview {
  principal: string;
  displayName: string | null;

  // Balances
  balance: TokenBalance;

  // Staking
  stakingTier: StakingTier;
  stakingPositions: StakingPosition[];
  totalStaked: number;
  avgLockDuration: number;

  // Rewards
  totalRewardsEarned: number;
  unclaimedRewards: number;
  rewardHistory: RewardRecord[];

  // Activity
  transactionCount: number;
  lastTransactionAt: number | null;

  // Governance
  votingPower: number;
  delegationsReceived: number;
  delegationsGiven: number;

  // Temporal
  firstTransactionAt: number;
  accountAge: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 2: TRANSACTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token transaction
 */
export interface TokenTransaction {
  id: string;
  type: TransactionType;
  status: TransactionStatus;

  // Amounts
  amount: number;
  fee: number;
  burnAmount: number;
  netAmount: number;

  // Parties
  from: string;
  to: string;

  // Timing
  timestamp: number;
  beat: number;
  confirmedAt: number | null;

  // Details
  memo: string | null;
  reference: string | null;
  metadata: Record<string, unknown>;

  // Block info
  blockHeight: number | null;
  blockHash: string | null;
  transactionHash: string;
}

/**
 * Transaction summary
 */
export interface TransactionSummary {
  id: string;
  type: TransactionType;
  status: TransactionStatus;
  amount: number;
  from: string;
  to: string;
  timestamp: number;
}

/**
 * Transaction filter
 */
export interface TransactionFilter {
  types?: TransactionType[];
  statuses?: TransactionStatus[];
  minAmount?: number;
  maxAmount?: number;
  from?: string;
  to?: string;
  startTime?: number;
  endTime?: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 3: STAKING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Staking position
 */
export interface StakingPosition {
  id: string;
  principal: string;

  // Amounts
  stakedAmount: number;
  currentValue: number;

  // Lock
  lockStartTime: number;
  lockEndTime: number;
  lockDurationDays: number;

  // Rewards
  apy: number;
  accumulatedRewards: number;
  lastRewardClaim: number;
  autoCompound: boolean;

  // Status
  isActive: boolean;
  tier: StakingTier;

  // Multipliers
  tierMultiplier: number;
  durationMultiplier: number;
  coherenceMultiplier: number;
  effectiveMultiplier: number;

  // Temporal
  createdAt: number;
  updatedAt: number;
}

/**
 * Staking statistics
 */
export interface StakingStatistics {
  totalStaked: number;
  totalStakers: number;
  avgStakeSize: number;
  avgLockDuration: number;

  // Tier distribution
  tierDistribution: Record<StakingTier, { count: number; amount: number }>;

  // Rewards
  totalRewardsDistributed: number;
  pendingRewards: number;
  avgAPY: number;

  // Trends
  stakingTrend: { timestamp: number; totalStaked: number }[];
  apyTrend: { timestamp: number; apy: number }[];
}

/**
 * Stake form
 */
export interface StakeForm {
  amount: number;
  lockDurationDays: number;
  autoCompound: boolean;
}

/**
 * Unstake form
 */
export interface UnstakeForm {
  positionId: string;
  amount: number;
  claimRewards: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 4: REWARD TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Reward record
 */
export interface RewardRecord {
  id: string;
  recipient: string;
  category: RewardCategory;

  // Amounts
  amount: number;

  // Source
  source: string;
  sourceId: string | null;

  // Timing
  timestamp: number;
  beat: number;

  // Status
  claimed: boolean;
  claimedAt: number | null;

  // Details
  description: string;
  metadata: Record<string, unknown>;
}

/**
 * Reward pool
 */
export interface RewardPool {
  category: RewardCategory;
  totalPool: number;
  distributedAmount: number;
  remainingAmount: number;
  distributionRate: number;
  lastDistribution: number;
  recipients: number;
}

/**
 * Reward distribution
 */
export interface RewardDistribution {
  id: string;
  category: RewardCategory;
  totalAmount: number;
  recipientCount: number;
  timestamp: number;
  beat: number;
  distributions: { recipient: string; amount: number }[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 5: VESTING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Vesting schedule
 */
export interface VestingSchedule {
  id: string;
  beneficiary: string;
  vestingType: VestingType;

  // Amounts
  totalAmount: number;
  vestedAmount: number;
  claimedAmount: number;
  remainingAmount: number;

  // Timing
  startTime: number;
  endTime: number;
  cliffTime: number | null;

  // Schedule
  vestingDurationDays: number;
  cliffDurationDays: number;

  // Status
  isActive: boolean;
  isFullyVested: boolean;

  // Milestones
  milestones: VestingMilestone[];
}

/**
 * Vesting milestone
 */
export interface VestingMilestone {
  id: string;
  scheduleId: string;
  percentage: number;
  amount: number;
  unlockTime: number;
  isUnlocked: boolean;
  isClaimed: boolean;
  claimedAt: number | null;
}

/**
 * Vesting summary
 */
export interface VestingSummary {
  totalVesting: number;
  totalVested: number;
  totalClaimed: number;
  totalPending: number;
  scheduleCount: number;
  nextUnlockTime: number | null;
  nextUnlockAmount: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 6: SUPPLY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token supply
 */
export interface TokenSupply {
  totalSupply: number;
  maxSupply: number;
  circulatingSupply: number;
  stakedSupply: number;
  lockedSupply: number;
  burnedSupply: number;
  treasurySupply: number;

  // Ratios
  circulatingRatio: number;
  stakedRatio: number;
  burnedRatio: number;

  // Last update
  lastUpdated: number;
}

/**
 * Supply breakdown
 */
export interface SupplyBreakdown {
  category: AllocationCategory;
  totalAllocation: number;
  currentAmount: number;
  vestedAmount: number;
  distributedAmount: number;
  remainingAmount: number;
}

/**
 * Inflation metrics
 */
export interface InflationMetrics {
  annualRate: number;
  currentSupply: number;
  projectedSupply1Y: number;
  projectedSupply5Y: number;
  inflationSchedule: { year: number; rate: number; supply: number }[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 7: MARKET TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token price
 */
export interface TokenPrice {
  priceUSD: number;
  priceICP: number;
  priceBTC: number;
  priceETH: number;
  change24h: number;
  change7d: number;
  change30d: number;
  lastUpdated: number;
}

/**
 * Market metrics
 */
export interface MarketMetrics {
  price: TokenPrice;
  marketCap: number;
  fullyDilutedValuation: number;
  volume24h: number;
  volumeChange24h: number;
  high24h: number;
  low24h: number;
  allTimeHigh: number;
  allTimeHighDate: number;
  allTimeLow: number;
  allTimeLowDate: number;
}

/**
 * Price history point
 */
export interface PriceHistoryPoint {
  timestamp: number;
  price: number;
  volume: number;
  marketCap: number;
}

/**
 * Price chart data
 */
export interface PriceChartData {
  timeframe: "1h" | "24h" | "7d" | "30d" | "1y" | "all";
  data: PriceHistoryPoint[];
  high: number;
  low: number;
  avg: number;
  change: number;
  changePercent: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 8: TREASURY TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Treasury balance
 */
export interface TreasuryTokenBalance {
  token: string;
  amount: number;
  valueUSD: number;
  allocation: number;
  lastUpdated: number;
}

/**
 * Treasury state
 */
export interface TreasuryState {
  totalValueUSD: number;
  balances: TreasuryTokenBalance[];

  // Allocations
  rewardPoolBalance: number;
  governancePoolBalance: number;
  operationsBalance: number;
  reserveBalance: number;

  // Activity
  inflows30d: number;
  outflows30d: number;
  netFlow30d: number;

  // Proposals
  pendingAllocations: number;

  // Last update
  lastAudit: number;
  auditor: string | null;
}

/**
 * Treasury allocation request
 */
export interface TreasuryAllocationRequest {
  id: string;
  proposalId: string;
  recipient: string;
  amount: number;
  purpose: string;
  status: "pending" | "approved" | "executed" | "rejected";
  createdAt: number;
  executedAt: number | null;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 9: ANALYTICS TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token analytics
 */
export interface TokenAnalytics {
  // Supply metrics
  supply: TokenSupply;
  inflationMetrics: InflationMetrics;

  // Market metrics
  market: MarketMetrics;
  priceHistory: PriceChartData;

  // Staking metrics
  staking: StakingStatistics;

  // Transaction metrics
  totalTransactions: number;
  transactionsToday: number;
  avgTransactionSize: number;
  uniqueAddresses: number;
  activeAddresses24h: number;

  // Treasury
  treasury: TreasuryState;

  // Holder distribution
  holderDistribution: {
    range: string;
    count: number;
    totalBalance: number;
    percentage: number;
  }[];

  // Top holders
  topHolders: {
    address: string;
    balance: number;
    percentage: number;
    rank: number;
  }[];
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 10: NOTIFICATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Token notification
 */
export interface TokenNotification {
  id: string;
  type:
    | "transfer_received"
    | "transfer_sent"
    | "stake_complete"
    | "unstake_complete"
    | "reward_available"
    | "reward_claimed"
    | "vesting_unlocked"
    | "price_alert";
  title: string;
  message: string;
  amount: number | null;
  transactionId: string | null;
  timestamp: number;
  read: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 11: FORM TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Transfer form
 */
export interface TransferForm {
  to: string;
  amount: number;
  memo: string | null;
}

/**
 * Claim rewards form
 */
export interface ClaimRewardsForm {
  positionIds: string[];
  reinvest: boolean;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 12: COMPLETE STATE TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Complete token economy state
 */
export interface TokenEconomyState {
  // Supply
  supply: TokenSupply;
  supplyBreakdown: SupplyBreakdown[];

  // Market
  market: MarketMetrics;
  priceHistory: PriceChartData;

  // Staking
  stakingStats: StakingStatistics;
  stakingPositions: StakingPosition[];

  // Rewards
  rewardPools: RewardPool[];
  recentDistributions: RewardDistribution[];

  // Vesting
  vestingSchedules: VestingSchedule[];
  vestingSummary: VestingSummary;

  // Treasury
  treasury: TreasuryState;

  // Analytics
  analytics: TokenAnalytics;

  // Recent transactions
  recentTransactions: TokenTransaction[];

  // Current beat
  currentBeat: number;
  lastUpdated: number;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SECTION 13: VISUALIZATION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Supply chart data
 */
export interface SupplyChartData {
  labels: string[];
  datasets: {
    label: string;
    data: number[];
    color: string;
  }[];
}

/**
 * Staking tier card
 */
export interface StakingTierCard {
  tier: StakingTier;
  name: string;
  minStake: number;
  maxStake: number;
  apyMultiplier: number;
  votingMultiplier: number;
  color: string;
  stakerCount: number;
  totalStaked: number;
  isCurrentTier: boolean;
}

/**
 * Reward breakdown
 */
export interface RewardBreakdown {
  category: RewardCategory;
  amount: number;
  percentage: number;
  color: string;
  trend: "up" | "down" | "stable";
}

/**
 * Token flow visualization
 */
export interface TokenFlowVisualization {
  nodes: {
    id: string;
    label: string;
    value: number;
    type: "source" | "sink" | "intermediate";
  }[];
  links: {
    source: string;
    target: string;
    value: number;
    label: string;
  }[];
}
