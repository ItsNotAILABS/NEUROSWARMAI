// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  TOKEN ECONOMY CONSTANTS — FORMA TOKEN ARCHITECTURE                                                       ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════
// TOKEN PARAMETERS
// ═══════════════════════════════════════════════════════════════════════════════

export const FORMA_TOKEN = {
  // Basic info
  NAME: "FORMA",
  SYMBOL: "FORMA",
  DECIMALS: 8,

  // Supply
  INITIAL_SUPPLY: 1_000_000_000, // 1 billion
  MAX_SUPPLY: 10_000_000_000, // 10 billion
  CIRCULATING_SUPPLY_TARGET: 0.5, // 50% of total

  // Economics
  INFLATION_RATE_ANNUAL: 0.02, // 2% annual inflation
  BURN_RATE_PER_TX: 0.001, // 0.1% burn per transaction
  STAKING_APY_BASE: 0.05, // 5% base APY
  STAKING_APY_MAX: 0.15, // 15% max APY

  // Fees
  TRANSFER_FEE_BASE: 0.001, // 0.1% transfer fee
  TRANSFER_FEE_MIN: 0.0001, // 0.01% minimum
  TRANSFER_FEE_MAX: 0.01, // 1% maximum

  // Staking
  MIN_STAKE_AMOUNT: 100,
  MAX_STAKE_AMOUNT: 10_000_000,
  MIN_LOCK_DURATION_BEATS: 10000, // ~14 minutes
  MAX_LOCK_DURATION_BEATS: 10_000_000, // ~9.6 days

  // Rewards
  REWARD_POOL_PERCENTAGE: 0.3, // 30% of inflation to rewards
  GOVERNANCE_POOL_PERCENTAGE: 0.2, // 20% to governance
  TREASURY_POOL_PERCENTAGE: 0.5, // 50% to treasury

  // Vesting
  TEAM_VESTING_DURATION_DAYS: 365,
  INVESTOR_VESTING_DURATION_DAYS: 180,
  ADVISOR_VESTING_DURATION_DAYS: 90,
} as const;

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSACTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const TRANSACTION_TYPES = [
  "Transfer",
  "Stake",
  "Unstake",
  "ClaimReward",
  "Burn",
  "Mint",
  "Delegate",
  "Undelegate",
  "GovernanceVote",
  "ProposalCreation",
  "TaskReward",
  "ReferralBonus",
  "TreasuryAllocation",
  "Fee",
] as const;

export type TransactionType = (typeof TRANSACTION_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSACTION STATUSES
// ═══════════════════════════════════════════════════════════════════════════════

export const TRANSACTION_STATUSES = [
  "Pending",
  "Confirmed",
  "Failed",
  "Cancelled",
] as const;

export type TransactionStatus = (typeof TRANSACTION_STATUSES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// STAKING TIERS
// ═══════════════════════════════════════════════════════════════════════════════

export const STAKING_TIERS = {
  BRONZE: {
    name: "Bronze",
    minStake: 100,
    maxStake: 999,
    apyMultiplier: 1.0,
    votingMultiplier: 1.0,
    color: "oklch(60% 0.1 30)",
  },
  SILVER: {
    name: "Silver",
    minStake: 1000,
    maxStake: 9999,
    apyMultiplier: 1.2,
    votingMultiplier: 1.1,
    color: "oklch(70% 0.05 240)",
  },
  GOLD: {
    name: "Gold",
    minStake: 10000,
    maxStake: 99999,
    apyMultiplier: 1.5,
    votingMultiplier: 1.25,
    color: "oklch(75% 0.15 60)",
  },
  PLATINUM: {
    name: "Platinum",
    minStake: 100000,
    maxStake: 999999,
    apyMultiplier: 1.8,
    votingMultiplier: 1.5,
    color: "oklch(80% 0.05 180)",
  },
  DIAMOND: {
    name: "Diamond",
    minStake: 1000000,
    maxStake: Number.POSITIVE_INFINITY,
    apyMultiplier: 2.0,
    votingMultiplier: 2.0,
    color: "oklch(85% 0.1 300)",
  },
} as const;

export type StakingTier = keyof typeof STAKING_TIERS;

// ═══════════════════════════════════════════════════════════════════════════════
// LOCK DURATION MULTIPLIERS
// ═══════════════════════════════════════════════════════════════════════════════

export const LOCK_DURATION_MULTIPLIERS = [
  { days: 30, multiplier: 1.0, name: "1 Month" },
  { days: 90, multiplier: 1.25, name: "3 Months" },
  { days: 180, multiplier: 1.5, name: "6 Months" },
  { days: 365, multiplier: 2.0, name: "1 Year" },
  { days: 730, multiplier: 2.5, name: "2 Years" },
  { days: 1095, multiplier: 3.0, name: "3 Years" },
] as const;

// ═══════════════════════════════════════════════════════════════════════════════
// REWARD CATEGORIES
// ═══════════════════════════════════════════════════════════════════════════════

export const REWARD_CATEGORIES = [
  "Staking",
  "Governance",
  "TaskCompletion",
  "Referral",
  "LiquidityProvision",
  "CommunityContribution",
  "BugBounty",
  "OrganismPerformance",
] as const;

export type RewardCategory = (typeof REWARD_CATEGORIES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// VESTING TYPES
// ═══════════════════════════════════════════════════════════════════════════════

export const VESTING_TYPES = [
  "Team",
  "Investor",
  "Advisor",
  "Community",
  "Ecosystem",
  "Treasury",
] as const;

export type VestingType = (typeof VESTING_TYPES)[number];

// ═══════════════════════════════════════════════════════════════════════════════
// ALLOCATION CATEGORIES
// ═══════════════════════════════════════════════════════════════════════════════

export const ALLOCATION_CATEGORIES = {
  TEAM: { percentage: 0.15, vesting: true, vestingDays: 365 },
  INVESTORS: { percentage: 0.2, vesting: true, vestingDays: 180 },
  ADVISORS: { percentage: 0.05, vesting: true, vestingDays: 90 },
  COMMUNITY: { percentage: 0.25, vesting: false, vestingDays: 0 },
  ECOSYSTEM: { percentage: 0.2, vesting: false, vestingDays: 0 },
  TREASURY: { percentage: 0.15, vesting: false, vestingDays: 0 },
} as const;

export type AllocationCategory = keyof typeof ALLOCATION_CATEGORIES;

// ═══════════════════════════════════════════════════════════════════════════════
// COLORS
// ═══════════════════════════════════════════════════════════════════════════════

export const TRANSACTION_TYPE_COLORS: Record<TransactionType, string> = {
  Transfer: "oklch(65% 0.15 210)",
  Stake: "oklch(70% 0.2 150)",
  Unstake: "oklch(65% 0.15 60)",
  ClaimReward: "oklch(70% 0.2 120)",
  Burn: "oklch(60% 0.2 30)",
  Mint: "oklch(70% 0.2 180)",
  Delegate: "oklch(65% 0.15 270)",
  Undelegate: "oklch(60% 0.1 240)",
  GovernanceVote: "oklch(65% 0.15 300)",
  ProposalCreation: "oklch(65% 0.2 330)",
  TaskReward: "oklch(70% 0.2 90)",
  ReferralBonus: "oklch(70% 0.2 60)",
  TreasuryAllocation: "oklch(60% 0.1 240)",
  Fee: "oklch(50% 0.05 240)",
};

export const TRANSACTION_STATUS_COLORS: Record<TransactionStatus, string> = {
  Pending: "oklch(65% 0.15 60)",
  Confirmed: "oklch(70% 0.2 150)",
  Failed: "oklch(60% 0.2 30)",
  Cancelled: "oklch(50% 0.05 240)",
};

export const REWARD_CATEGORY_COLORS: Record<RewardCategory, string> = {
  Staking: "oklch(70% 0.2 150)",
  Governance: "oklch(65% 0.15 300)",
  TaskCompletion: "oklch(70% 0.2 90)",
  Referral: "oklch(70% 0.2 60)",
  LiquidityProvision: "oklch(65% 0.15 210)",
  CommunityContribution: "oklch(70% 0.2 180)",
  BugBounty: "oklch(65% 0.2 30)",
  OrganismPerformance: "oklch(70% 0.15 270)",
};

// ═══════════════════════════════════════════════════════════════════════════════
// UTILITY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Format token amount
 */
export function formatTokenAmount(amount: number, decimals = 2): string {
  if (amount >= 1_000_000_000) {
    return `${(amount / 1_000_000_000).toFixed(decimals)}B`;
  }
  if (amount >= 1_000_000) {
    return `${(amount / 1_000_000).toFixed(decimals)}M`;
  }
  if (amount >= 1_000) {
    return `${(amount / 1_000).toFixed(decimals)}K`;
  }
  return amount.toFixed(decimals);
}

/**
 * Get staking tier
 */
export function getStakingTier(amount: number): StakingTier {
  if (amount >= STAKING_TIERS.DIAMOND.minStake) return "DIAMOND";
  if (amount >= STAKING_TIERS.PLATINUM.minStake) return "PLATINUM";
  if (amount >= STAKING_TIERS.GOLD.minStake) return "GOLD";
  if (amount >= STAKING_TIERS.SILVER.minStake) return "SILVER";
  return "BRONZE";
}

/**
 * Calculate staking APY
 */
export function calculateStakingAPY(
  amount: number,
  lockDurationDays: number,
  coherenceMultiplier = 1,
): number {
  const tier = getStakingTier(amount);
  const tierInfo = STAKING_TIERS[tier];

  const durationMultiplier =
    LOCK_DURATION_MULTIPLIERS.find((d) => d.days <= lockDurationDays)
      ?.multiplier ?? 1;

  const baseAPY = FORMA_TOKEN.STAKING_APY_BASE;
  const effectiveAPY =
    baseAPY * tierInfo.apyMultiplier * durationMultiplier * coherenceMultiplier;

  return Math.min(effectiveAPY, FORMA_TOKEN.STAKING_APY_MAX);
}

/**
 * Calculate rewards
 */
export function calculateRewards(
  stakedAmount: number,
  apy: number,
  durationBeats: number,
  beatsPerYear: number = 12 * 60 * 60 * 24 * 365,
): number {
  const yearFraction = durationBeats / beatsPerYear;
  return stakedAmount * apy * yearFraction;
}

/**
 * Calculate transfer fee
 */
export function calculateTransferFee(amount: number): number {
  const feeRate = Math.max(
    FORMA_TOKEN.TRANSFER_FEE_MIN,
    Math.min(FORMA_TOKEN.TRANSFER_FEE_MAX, FORMA_TOKEN.TRANSFER_FEE_BASE),
  );
  return amount * feeRate;
}

/**
 * Calculate burn amount
 */
export function calculateBurnAmount(amount: number): number {
  return amount * FORMA_TOKEN.BURN_RATE_PER_TX;
}

/**
 * Calculate vested amount
 */
export function calculateVestedAmount(
  totalAmount: number,
  vestingStartTime: number,
  vestingDurationDays: number,
  currentTime: number,
): number {
  const elapsedMs = currentTime - vestingStartTime;
  const vestingDurationMs = vestingDurationDays * 24 * 60 * 60 * 1000;

  if (elapsedMs >= vestingDurationMs) return totalAmount;
  if (elapsedMs <= 0) return 0;

  return totalAmount * (elapsedMs / vestingDurationMs);
}

/**
 * Calculate inflation
 */
export function calculateInflation(
  currentSupply: number,
  annualRate: number,
  beatsElapsed: number,
  beatsPerYear: number = 12 * 60 * 60 * 24 * 365,
): number {
  const yearFraction = beatsElapsed / beatsPerYear;
  return currentSupply * annualRate * yearFraction;
}

/**
 * Format percentage
 */
export function formatPercentage(value: number, decimals = 2): string {
  return `${(value * 100).toFixed(decimals)}%`;
}

/**
 * Calculate market cap
 */
export function calculateMarketCap(
  circulatingSupply: number,
  priceUSD: number,
): number {
  return circulatingSupply * priceUSD;
}

/**
 * Calculate fully diluted valuation
 */
export function calculateFDV(maxSupply: number, priceUSD: number): number {
  return maxSupply * priceUSD;
}
