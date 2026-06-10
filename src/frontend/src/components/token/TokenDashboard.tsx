// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  FORMA TOKEN DASHBOARD — SOVEREIGN TOKEN ECONOMY VISUALIZATION                                            ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
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
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { Slider } from "@/components/ui/slider";
import { Switch } from "@/components/ui/switch";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  ArrowDown,
  ArrowRight,
  ArrowUp,
  ArrowUpRight,
  Award,
  BarChart3,
  Coins,
  Crown,
  DollarSign,
  Download,
  ExternalLink,
  Flame,
  Gift,
  History,
  Loader2,
  Lock,
  LockKeyhole,
  PieChart,
  Plus,
  RefreshCw,
  Send,
  Sparkles,
  Timer,
  TrendingDown,
  TrendingUp,
  Unlock,
  Upload,
  Users,
  Wallet,
  Zap,
} from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";

import {
  FORMA_TOKEN,
  LOCK_DURATION_MULTIPLIERS,
  REWARD_CATEGORIES,
  REWARD_CATEGORY_COLORS,
  STAKING_TIERS,
  TRANSACTION_STATUS_COLORS,
  TRANSACTION_TYPES,
  TRANSACTION_TYPE_COLORS,
  calculateStakingAPY,
  calculateTransferFee,
  formatPercentage,
  formatTokenAmount,
  getStakingTier,
} from "@/lib/token/constants";

import type {
  RewardCategory,
  StakingTier,
  TransactionStatus,
  TransactionType,
} from "@/lib/token/constants";

import type {
  AccountOverview,
  MarketMetrics,
  PriceChartData,
  RewardRecord,
  StakingPosition,
  StakingStatistics,
  TokenBalance,
  TokenEconomyState,
  TokenSupply,
  TokenTransaction,
  TreasuryState,
} from "@/lib/token/types";

// ═══════════════════════════════════════════════════════════════════════════════
// INITIALIZATION FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════

function generateId(): string {
  return Math.random().toString(36).substring(2, 15);
}

function initializeTokenBalance(principal: string): TokenBalance {
  const total = 1000 + Math.random() * 50000;
  const staked = total * (0.3 + Math.random() * 0.4);
  const locked = total * Math.random() * 0.1;
  const pending = Math.random() * 500;

  return {
    principal,
    totalBalance: total,
    availableBalance: total - staked - locked,
    stakedBalance: staked,
    lockedBalance: locked,
    pendingRewards: pending,
    delegatedBalance: 0,
    lastUpdated: Date.now(),
  };
}

function initializeStakingPosition(
  principal: string,
  _index: number,
): StakingPosition {
  const amount = 100 + Math.random() * 10000;
  const tier = getStakingTier(amount);
  const durationIndex = Math.floor(
    Math.random() * LOCK_DURATION_MULTIPLIERS.length,
  );
  const duration = LOCK_DURATION_MULTIPLIERS[durationIndex];
  const startTime =
    Date.now() -
    Math.floor(Math.random() * duration.days * 24 * 60 * 60 * 1000 * 0.5);

  return {
    id: generateId(),
    principal,
    stakedAmount: amount,
    currentValue: amount * (1 + Math.random() * 0.1),
    lockStartTime: startTime,
    lockEndTime: startTime + duration.days * 24 * 60 * 60 * 1000,
    lockDurationDays: duration.days,
    apy: calculateStakingAPY(amount, duration.days, 1),
    accumulatedRewards: amount * 0.05 * Math.random(),
    lastRewardClaim: startTime + Math.floor(Math.random() * 30 * 86400000),
    autoCompound: Math.random() > 0.5,
    isActive: true,
    tier,
    tierMultiplier: STAKING_TIERS[tier].apyMultiplier,
    durationMultiplier: duration.multiplier,
    coherenceMultiplier: 1 + Math.random() * 0.2,
    effectiveMultiplier:
      STAKING_TIERS[tier].apyMultiplier *
      duration.multiplier *
      (1 + Math.random() * 0.2),
    createdAt: startTime,
    updatedAt: Date.now(),
  };
}

function initializeTokenTransaction(_index: number): TokenTransaction {
  const types = TRANSACTION_TYPES;
  const type = types[Math.floor(Math.random() * types.length)];
  const amount = 10 + Math.random() * 5000;
  const fee = calculateTransferFee(amount);

  return {
    id: generateId(),
    type,
    status:
      Math.random() > 0.1
        ? "Confirmed"
        : Math.random() > 0.5
          ? "Pending"
          : "Failed",
    amount,
    fee,
    burnAmount: amount * FORMA_TOKEN.BURN_RATE_PER_TX,
    netAmount: amount - fee - amount * FORMA_TOKEN.BURN_RATE_PER_TX,
    from: `principal-${generateId()}`,
    to: `principal-${generateId()}`,
    timestamp: Date.now() - Math.floor(Math.random() * 7 * 86400000),
    beat: 5000 + Math.floor(Math.random() * 1000),
    confirmedAt:
      Math.random() > 0.2
        ? Date.now() - Math.floor(Math.random() * 86400000)
        : null,
    memo: Math.random() > 0.7 ? "Transaction memo" : null,
    reference: null,
    metadata: {},
    blockHeight: Math.floor(Math.random() * 1000000),
    blockHash: `0x${generateId()}${generateId()}`,
    transactionHash: `0x${generateId()}${generateId()}`,
  };
}

function initializeRewardRecord(_index: number): RewardRecord {
  const categories = REWARD_CATEGORIES;
  const category = categories[Math.floor(Math.random() * categories.length)];

  return {
    id: generateId(),
    recipient: `principal-${generateId()}`,
    category,
    amount: 1 + Math.random() * 100,
    source: "System",
    sourceId: generateId(),
    timestamp: Date.now() - Math.floor(Math.random() * 30 * 86400000),
    beat: 5000 + Math.floor(Math.random() * 1000),
    claimed: Math.random() > 0.3,
    claimedAt:
      Math.random() > 0.3
        ? Date.now() - Math.floor(Math.random() * 7 * 86400000)
        : null,
    description: `${category} reward`,
    metadata: {},
  };
}

function initializeTokenSupply(): TokenSupply {
  const total = 1_500_000_000;
  const circulating = total * 0.4;
  const staked = circulating * 0.35;
  const burned = total * 0.02;

  return {
    totalSupply: total,
    maxSupply: FORMA_TOKEN.MAX_SUPPLY,
    circulatingSupply: circulating,
    stakedSupply: staked,
    lockedSupply: total * 0.2,
    burnedSupply: burned,
    treasurySupply: total * 0.15,
    circulatingRatio: circulating / total,
    stakedRatio: staked / circulating,
    burnedRatio: burned / total,
    lastUpdated: Date.now(),
  };
}

function initializeMarketMetrics(): MarketMetrics {
  const price = 0.5 + Math.random() * 2;
  const change24h = (Math.random() - 0.5) * 20;

  return {
    price: {
      priceUSD: price,
      priceICP: price / 10,
      priceBTC: price / 50000,
      priceETH: price / 3000,
      change24h,
      change7d: (Math.random() - 0.5) * 30,
      change30d: (Math.random() - 0.5) * 50,
      lastUpdated: Date.now(),
    },
    marketCap: price * 600_000_000,
    fullyDilutedValuation: price * FORMA_TOKEN.MAX_SUPPLY,
    volume24h: 5_000_000 + Math.random() * 10_000_000,
    volumeChange24h: (Math.random() - 0.5) * 30,
    high24h: price * 1.05,
    low24h: price * 0.95,
    allTimeHigh: price * 2,
    allTimeHighDate: Date.now() - 90 * 86400000,
    allTimeLow: price * 0.1,
    allTimeLowDate: Date.now() - 365 * 86400000,
  };
}

function initializeStakingStatistics(): StakingStatistics {
  return {
    totalStaked: 200_000_000,
    totalStakers: 5000,
    avgStakeSize: 40000,
    avgLockDuration: 180,
    tierDistribution: {
      BRONZE: { count: 2000, amount: 1_000_000 },
      SILVER: { count: 1500, amount: 10_000_000 },
      GOLD: { count: 1000, amount: 50_000_000 },
      PLATINUM: { count: 400, amount: 80_000_000 },
      DIAMOND: { count: 100, amount: 59_000_000 },
    },
    totalRewardsDistributed: 5_000_000,
    pendingRewards: 200_000,
    avgAPY: 0.08,
    stakingTrend: [],
    apyTrend: [],
  };
}

function initializeTreasuryState(): TreasuryState {
  return {
    totalValueUSD: 50_000_000,
    balances: [
      {
        token: "FORMA",
        amount: 150_000_000,
        valueUSD: 45_000_000,
        allocation: 0.9,
        lastUpdated: Date.now(),
      },
      {
        token: "ICP",
        amount: 50000,
        valueUSD: 5_000_000,
        allocation: 0.1,
        lastUpdated: Date.now(),
      },
    ],
    rewardPoolBalance: 30_000_000,
    governancePoolBalance: 10_000_000,
    operationsBalance: 5_000_000,
    reserveBalance: 105_000_000,
    inflows30d: 2_000_000,
    outflows30d: 1_500_000,
    netFlow30d: 500_000,
    pendingAllocations: 3,
    lastAudit: Date.now() - 7 * 86400000,
    auditor: "Internal Audit",
  };
}

function initializeAccountOverview(principal: string): AccountOverview {
  const balance = initializeTokenBalance(principal);
  const positions = Array.from({ length: 3 }, (_, i) =>
    initializeStakingPosition(principal, i),
  );
  const rewards = Array.from({ length: 5 }, (_, i) =>
    initializeRewardRecord(i),
  );

  return {
    principal,
    displayName: "My Account",
    balance,
    stakingTier: getStakingTier(balance.stakedBalance),
    stakingPositions: positions,
    totalStaked: positions.reduce((sum, p) => sum + p.stakedAmount, 0),
    avgLockDuration:
      positions.reduce((sum, p) => sum + p.lockDurationDays, 0) /
      positions.length,
    totalRewardsEarned: 5000 + Math.random() * 10000,
    unclaimedRewards: 100 + Math.random() * 500,
    rewardHistory: rewards,
    transactionCount: 50 + Math.floor(Math.random() * 200),
    lastTransactionAt: Date.now() - Math.floor(Math.random() * 86400000),
    votingPower: balance.stakedBalance * 1.5,
    delegationsReceived: Math.floor(Math.random() * 5),
    delegationsGiven: Math.floor(Math.random() * 2),
    firstTransactionAt: Date.now() - 365 * 86400000,
    accountAge: 365,
  };
}

function initializeTokenEconomyState(): TokenEconomyState {
  const principal = `user-${generateId()}`;

  return {
    supply: initializeTokenSupply(),
    supplyBreakdown: [],
    market: initializeMarketMetrics(),
    priceHistory: {
      timeframe: "7d",
      data: [],
      high: 2,
      low: 0.5,
      avg: 1.2,
      change: 5,
      changePercent: 5,
    },
    stakingStats: initializeStakingStatistics(),
    stakingPositions: Array.from({ length: 3 }, (_, i) =>
      initializeStakingPosition(principal, i),
    ),
    rewardPools: [],
    recentDistributions: [],
    vestingSchedules: [],
    vestingSummary: {
      totalVesting: 0,
      totalVested: 0,
      totalClaimed: 0,
      totalPending: 0,
      scheduleCount: 0,
      nextUnlockTime: null,
      nextUnlockAmount: null,
    },
    treasury: initializeTreasuryState(),
    analytics: {
      supply: initializeTokenSupply(),
      inflationMetrics: {
        annualRate: 0.02,
        currentSupply: 1_500_000_000,
        projectedSupply1Y: 1_530_000_000,
        projectedSupply5Y: 1_650_000_000,
        inflationSchedule: [],
      },
      market: initializeMarketMetrics(),
      priceHistory: {
        timeframe: "7d",
        data: [],
        high: 2,
        low: 0.5,
        avg: 1.2,
        change: 5,
        changePercent: 5,
      },
      staking: initializeStakingStatistics(),
      totalTransactions: 100000,
      transactionsToday: 500,
      avgTransactionSize: 1000,
      uniqueAddresses: 10000,
      activeAddresses24h: 2000,
      treasury: initializeTreasuryState(),
      holderDistribution: [],
      topHolders: [],
    },
    recentTransactions: Array.from({ length: 10 }, (_, i) =>
      initializeTokenTransaction(i),
    ),
    currentBeat: 5500,
    lastUpdated: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// BALANCE CARD COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface BalanceCardProps {
  account: AccountOverview;
  market: MarketMetrics;
}

function BalanceCard({ account, market }: BalanceCardProps) {
  const totalValueUSD = account.balance.totalBalance * market.price.priceUSD;

  return (
    <Card className="bg-gradient-to-br from-purple-500/10 to-blue-500/10 border-purple-500/30">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Wallet className="w-4 h-4" />
          My Balance
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="text-center">
          <div className="text-3xl font-mono font-bold">
            {formatTokenAmount(account.balance.totalBalance, 2)}{" "}
            <span className="text-lg text-muted-foreground">FORMA</span>
          </div>
          <div className="text-sm text-muted-foreground">
            ≈ $
            {totalValueUSD.toLocaleString(undefined, {
              maximumFractionDigits: 2,
            })}{" "}
            USD
          </div>
        </div>

        <Separator />

        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="bg-background/50 p-2 rounded-lg">
            <div className="text-muted-foreground">Available</div>
            <div className="font-mono font-semibold">
              {formatTokenAmount(account.balance.availableBalance)}
            </div>
          </div>
          <div className="bg-background/50 p-2 rounded-lg">
            <div className="text-muted-foreground">Staked</div>
            <div className="font-mono font-semibold text-green-500">
              {formatTokenAmount(account.balance.stakedBalance)}
            </div>
          </div>
          <div className="bg-background/50 p-2 rounded-lg">
            <div className="text-muted-foreground">Locked</div>
            <div className="font-mono font-semibold text-yellow-500">
              {formatTokenAmount(account.balance.lockedBalance)}
            </div>
          </div>
          <div className="bg-background/50 p-2 rounded-lg">
            <div className="text-muted-foreground">Rewards</div>
            <div className="font-mono font-semibold text-purple-500">
              {formatTokenAmount(account.balance.pendingRewards)}
            </div>
          </div>
        </div>

        <div className="flex items-center justify-between">
          <Badge
            style={{
              backgroundColor: STAKING_TIERS[account.stakingTier].color,
            }}
            className="text-white"
          >
            {account.stakingTier} Tier
          </Badge>
          <div className="text-xs text-muted-foreground">
            Voting Power: {formatTokenAmount(account.votingPower)}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRICE CARD COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface PriceCardProps {
  market: MarketMetrics;
}

function PriceCard({ market }: PriceCardProps) {
  const isPositive = market.price.change24h >= 0;

  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <TrendingUp className="w-4 h-4" />
          FORMA Price
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="flex items-end justify-between">
          <div>
            <div className="text-2xl font-mono font-bold">
              ${market.price.priceUSD.toFixed(4)}
            </div>
            <div
              className={`text-sm flex items-center gap-1 ${isPositive ? "text-green-500" : "text-red-500"}`}
            >
              {isPositive ? (
                <ArrowUp className="w-3 h-3" />
              ) : (
                <ArrowDown className="w-3 h-3" />
              )}
              {Math.abs(market.price.change24h).toFixed(2)}% (24h)
            </div>
          </div>
          <div className="text-right text-xs text-muted-foreground">
            <div>High: ${market.high24h.toFixed(4)}</div>
            <div>Low: ${market.low24h.toFixed(4)}</div>
          </div>
        </div>

        <Separator />

        <div className="grid grid-cols-2 gap-3 text-xs">
          <div>
            <div className="text-muted-foreground">Market Cap</div>
            <div className="font-mono font-semibold">
              ${formatTokenAmount(market.marketCap)}
            </div>
          </div>
          <div>
            <div className="text-muted-foreground">24h Volume</div>
            <div className="font-mono font-semibold">
              ${formatTokenAmount(market.volume24h)}
            </div>
          </div>
          <div>
            <div className="text-muted-foreground">FDV</div>
            <div className="font-mono font-semibold">
              ${formatTokenAmount(market.fullyDilutedValuation)}
            </div>
          </div>
          <div>
            <div className="text-muted-foreground">ATH</div>
            <div className="font-mono font-semibold">
              ${market.allTimeHigh.toFixed(4)}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUPPLY OVERVIEW COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface SupplyOverviewProps {
  supply: TokenSupply;
}

function SupplyOverview({ supply }: SupplyOverviewProps) {
  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <PieChart className="w-4 h-4" />
          Token Supply
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div className="text-center p-3 bg-surface rounded-lg">
            <div className="text-xs text-muted-foreground">Total Supply</div>
            <div className="text-lg font-mono font-semibold">
              {formatTokenAmount(supply.totalSupply)}
            </div>
          </div>
          <div className="text-center p-3 bg-surface rounded-lg">
            <div className="text-xs text-muted-foreground">Circulating</div>
            <div className="text-lg font-mono font-semibold">
              {formatTokenAmount(supply.circulatingSupply)}
            </div>
          </div>
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Staked</span>
            <span className="font-mono">
              {formatTokenAmount(supply.stakedSupply)} (
              {formatPercentage(supply.stakedRatio)})
            </span>
          </div>
          <Progress value={supply.stakedRatio * 100} className="h-2" />
        </div>

        <div className="space-y-2">
          <div className="flex items-center justify-between text-xs">
            <span className="text-muted-foreground">Burned</span>
            <span className="font-mono text-red-500">
              {formatTokenAmount(supply.burnedSupply)} (
              {formatPercentage(supply.burnedRatio)})
            </span>
          </div>
          <Progress
            value={supply.burnedRatio * 100}
            className="h-2 bg-red-500/20"
          />
        </div>

        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">Locked</span>
            <span className="font-mono">
              {formatTokenAmount(supply.lockedSupply)}
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">Treasury</span>
            <span className="font-mono">
              {formatTokenAmount(supply.treasurySupply)}
            </span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// STAKING OVERVIEW COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

interface StakingOverviewProps {
  stats: StakingStatistics;
}

function StakingOverview({ stats }: StakingOverviewProps) {
  const tiers = Object.entries(STAKING_TIERS) as [
    StakingTier,
    (typeof STAKING_TIERS)[StakingTier],
  ][];

  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Lock className="w-4 h-4" />
          Staking Overview
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div className="text-center p-3 bg-surface rounded-lg">
            <div className="text-xs text-muted-foreground">Total Staked</div>
            <div className="text-lg font-mono font-semibold text-green-500">
              {formatTokenAmount(stats.totalStaked)}
            </div>
          </div>
          <div className="text-center p-3 bg-surface rounded-lg">
            <div className="text-xs text-muted-foreground">Avg APY</div>
            <div className="text-lg font-mono font-semibold text-purple-500">
              {formatPercentage(stats.avgAPY)}
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-2">
          <span className="text-xs text-muted-foreground">
            Tier Distribution
          </span>
          {tiers.map(([tier, info]) => {
            const tierStats = stats.tierDistribution[tier];
            const percentage = tierStats
              ? (tierStats.amount / stats.totalStaked) * 100
              : 0;

            return (
              <div key={tier} className="space-y-1">
                <div className="flex items-center justify-between text-[10px]">
                  <div className="flex items-center gap-2">
                    <div
                      className="w-2 h-2 rounded-full"
                      style={{ backgroundColor: info.color }}
                    />
                    <span>{info.name}</span>
                  </div>
                  <span className="font-mono">
                    {tierStats?.count ?? 0} stakers
                  </span>
                </div>
                <Progress value={percentage} className="h-1" />
              </div>
            );
          })}
        </div>

        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">Total Stakers</span>
            <span className="font-mono">
              {stats.totalStakers.toLocaleString()}
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">Avg Stake</span>
            <span className="font-mono">
              {formatTokenAmount(stats.avgStakeSize)}
            </span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// STAKING POSITIONS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface StakingPositionsPanelProps {
  positions: StakingPosition[];
  onStake: () => void;
  onUnstake: (positionId: string) => void;
  onClaimRewards: (positionId: string) => void;
}

function StakingPositionsPanel({
  positions,
  onStake,
  onUnstake,
  onClaimRewards,
}: StakingPositionsPanelProps) {
  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <div className="flex items-center justify-between">
          <CardTitle className="text-sm font-semibold flex items-center gap-2">
            <LockKeyhole className="w-4 h-4" />
            My Staking Positions
          </CardTitle>
          <Button size="sm" onClick={onStake}>
            <Plus className="w-4 h-4 mr-1" />
            Stake
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-64">
          <div className="space-y-3">
            {positions.map((position) => {
              const timeRemaining = Math.max(
                0,
                position.lockEndTime - Date.now(),
              );
              const daysRemaining = Math.ceil(timeRemaining / 86400000);
              const unlocked = timeRemaining <= 0;

              return (
                <div
                  key={position.id}
                  className="p-3 rounded-lg bg-surface space-y-2"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Badge
                        style={{
                          backgroundColor: STAKING_TIERS[position.tier].color,
                        }}
                        className="text-white text-[10px]"
                      >
                        {position.tier}
                      </Badge>
                      <span className="text-xs font-semibold">
                        {formatTokenAmount(position.stakedAmount)} FORMA
                      </span>
                    </div>
                    <div className="text-xs text-right">
                      <div className="font-mono text-green-500">
                        +{formatTokenAmount(position.accumulatedRewards)}
                      </div>
                      <div className="text-[10px] text-muted-foreground">
                        rewards
                      </div>
                    </div>
                  </div>

                  <div className="grid grid-cols-3 gap-2 text-[10px]">
                    <div>
                      <div className="text-muted-foreground">APY</div>
                      <div className="font-mono font-semibold">
                        {formatPercentage(position.apy)}
                      </div>
                    </div>
                    <div>
                      <div className="text-muted-foreground">Duration</div>
                      <div className="font-mono">
                        {position.lockDurationDays} days
                      </div>
                    </div>
                    <div>
                      <div className="text-muted-foreground">Remaining</div>
                      <div
                        className={`font-mono ${unlocked ? "text-green-500" : ""}`}
                      >
                        {unlocked ? "Unlocked" : `${daysRemaining}d`}
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center justify-between text-[10px]">
                    <div className="flex items-center gap-1">
                      {position.autoCompound && (
                        <Badge variant="outline" className="text-[8px]">
                          Auto-compound
                        </Badge>
                      )}
                      <span className="text-muted-foreground">
                        {position.effectiveMultiplier.toFixed(2)}x multiplier
                      </span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Button
                        variant="ghost"
                        size="sm"
                        className="h-6 text-[10px]"
                        onClick={() => onClaimRewards(position.id)}
                      >
                        Claim
                      </Button>
                      {unlocked && (
                        <Button
                          variant="ghost"
                          size="sm"
                          className="h-6 text-[10px]"
                          onClick={() => onUnstake(position.id)}
                        >
                          Unstake
                        </Button>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
            {positions.length === 0 && (
              <div className="text-center py-8 text-muted-foreground text-sm">
                No staking positions yet
              </div>
            )}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRANSACTIONS PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface TransactionsPanelProps {
  transactions: TokenTransaction[];
}

function TransactionsPanel({ transactions }: TransactionsPanelProps) {
  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <History className="w-4 h-4" />
          Recent Transactions
        </CardTitle>
      </CardHeader>
      <CardContent>
        <ScrollArea className="h-64">
          <div className="space-y-2">
            {transactions.map((tx) => {
              const isIncoming =
                tx.type === "ClaimReward" || tx.type === "TaskReward";

              return (
                <div
                  key={tx.id}
                  className="flex items-center justify-between p-2 rounded bg-surface"
                >
                  <div className="flex items-center gap-2">
                    <div
                      className="w-8 h-8 rounded-full flex items-center justify-center"
                      style={{
                        backgroundColor: `${TRANSACTION_TYPE_COLORS[tx.type]}30`,
                      }}
                    >
                      {tx.type === "Transfer" && <Send className="w-4 h-4" />}
                      {tx.type === "Stake" && <Lock className="w-4 h-4" />}
                      {tx.type === "Unstake" && <Unlock className="w-4 h-4" />}
                      {tx.type === "ClaimReward" && (
                        <Gift className="w-4 h-4" />
                      )}
                      {tx.type === "Burn" && <Flame className="w-4 h-4" />}
                      {tx.type === "Mint" && <Sparkles className="w-4 h-4" />}
                      {![
                        "Transfer",
                        "Stake",
                        "Unstake",
                        "ClaimReward",
                        "Burn",
                        "Mint",
                      ].includes(tx.type) && <Coins className="w-4 h-4" />}
                    </div>
                    <div>
                      <div className="text-xs font-semibold">{tx.type}</div>
                      <div className="text-[10px] text-muted-foreground">
                        {new Date(tx.timestamp).toLocaleDateString()}
                      </div>
                    </div>
                  </div>
                  <div className="text-right">
                    <div
                      className={`text-xs font-mono font-semibold ${isIncoming ? "text-green-500" : ""}`}
                    >
                      {isIncoming ? "+" : ""}
                      {formatTokenAmount(tx.amount)}
                    </div>
                    <Badge
                      variant="outline"
                      className="text-[8px]"
                      style={{ color: TRANSACTION_STATUS_COLORS[tx.status] }}
                    >
                      {tx.status}
                    </Badge>
                  </div>
                </div>
              );
            })}
          </div>
        </ScrollArea>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// TREASURY PANEL
// ═══════════════════════════════════════════════════════════════════════════════

interface TreasuryPanelProps {
  treasury: TreasuryState;
}

function TreasuryPanel({ treasury }: TreasuryPanelProps) {
  return (
    <Card className="bg-background/95 border-border">
      <CardHeader className="pb-2">
        <CardTitle className="text-sm font-semibold flex items-center gap-2">
          <Crown className="w-4 h-4" />
          Treasury
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="text-center p-4 bg-surface rounded-lg">
          <div className="text-xs text-muted-foreground">Total Value</div>
          <div className="text-2xl font-mono font-semibold">
            ${treasury.totalValueUSD.toLocaleString()}
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3 text-xs">
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground">Reward Pool</div>
            <div className="font-mono font-semibold">
              {formatTokenAmount(treasury.rewardPoolBalance)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground">Governance Pool</div>
            <div className="font-mono font-semibold">
              {formatTokenAmount(treasury.governancePoolBalance)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground">Operations</div>
            <div className="font-mono font-semibold">
              {formatTokenAmount(treasury.operationsBalance)}
            </div>
          </div>
          <div className="bg-surface p-2 rounded-lg">
            <div className="text-muted-foreground">Reserve</div>
            <div className="font-mono font-semibold">
              {formatTokenAmount(treasury.reserveBalance)}
            </div>
          </div>
        </div>

        <Separator />

        <div className="space-y-1 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">30d Inflows</span>
            <span className="font-mono text-green-500">
              +${formatTokenAmount(treasury.inflows30d)}
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-muted-foreground">30d Outflows</span>
            <span className="font-mono text-red-500">
              -${formatTokenAmount(treasury.outflows30d)}
            </span>
          </div>
          <div className="flex items-center justify-between font-semibold">
            <span className="text-muted-foreground">Net Flow</span>
            <span
              className={`font-mono ${treasury.netFlow30d >= 0 ? "text-green-500" : "text-red-500"}`}
            >
              {treasury.netFlow30d >= 0 ? "+" : ""}$
              {formatTokenAmount(treasury.netFlow30d)}
            </span>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// STAKE DIALOG
// ═══════════════════════════════════════════════════════════════════════════════

interface StakeDialogProps {
  open: boolean;
  onClose: () => void;
  availableBalance: number;
  onStake: (
    amount: number,
    durationDays: number,
    autoCompound: boolean,
  ) => void;
}

function StakeDialog({
  open,
  onClose,
  availableBalance,
  onStake,
}: StakeDialogProps) {
  const [amount, setAmount] = useState("");
  const [durationIndex, setDurationIndex] = useState(2);
  const [autoCompound, setAutoCompound] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const duration = LOCK_DURATION_MULTIPLIERS[durationIndex];
  const numAmount = Number.parseFloat(amount) || 0;
  const tier = getStakingTier(numAmount);
  const apy = calculateStakingAPY(numAmount, duration.days, 1);
  const estimatedReward = numAmount * apy * (duration.days / 365);

  const handleSubmit = async () => {
    setIsSubmitting(true);
    await new Promise((r) => setTimeout(r, 1000));
    onStake(numAmount, duration.days, autoCompound);
    setIsSubmitting(false);
    setAmount("");
    onClose();
  };

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="text-base">Stake FORMA</DialogTitle>
          <DialogDescription className="text-xs">
            Lock your tokens to earn rewards
          </DialogDescription>
        </DialogHeader>

        <div className="space-y-4 py-4">
          <div className="space-y-2">
            <div className="flex items-center justify-between text-xs">
              <span className="text-muted-foreground">Amount</span>
              <span className="text-muted-foreground">
                Available: {formatTokenAmount(availableBalance)} FORMA
              </span>
            </div>
            <div className="relative">
              <Input
                type="number"
                placeholder="0.00"
                value={amount}
                onChange={(e) => setAmount(e.target.value)}
                className="pr-20"
              />
              <Button
                variant="ghost"
                size="sm"
                className="absolute right-1 top-1 h-7 text-xs"
                onClick={() => setAmount(availableBalance.toString())}
              >
                MAX
              </Button>
            </div>
          </div>

          <div className="space-y-2">
            <span className="text-xs text-muted-foreground">Lock Duration</span>
            <div className="grid grid-cols-3 gap-2">
              {LOCK_DURATION_MULTIPLIERS.slice(0, 6).map((d, i) => (
                <Button
                  key={d.days}
                  variant={durationIndex === i ? "default" : "outline"}
                  size="sm"
                  className="text-xs"
                  onClick={() => setDurationIndex(i)}
                >
                  {d.name}
                </Button>
              ))}
            </div>
          </div>

          <div className="flex items-center justify-between">
            <span className="text-xs text-muted-foreground">
              Auto-compound rewards
            </span>
            <Switch checked={autoCompound} onCheckedChange={setAutoCompound} />
          </div>

          <div className="bg-surface p-4 rounded-lg space-y-2 text-xs">
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">Staking Tier</span>
              <Badge
                style={{ backgroundColor: STAKING_TIERS[tier].color }}
                className="text-white"
              >
                {tier}
              </Badge>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">APY</span>
              <span className="font-mono font-semibold text-green-500">
                {formatPercentage(apy)}
              </span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">Duration Multiplier</span>
              <span className="font-mono">{duration.multiplier}x</span>
            </div>
            <Separator />
            <div className="flex items-center justify-between font-semibold">
              <span className="text-muted-foreground">Estimated Reward</span>
              <span className="font-mono text-green-500">
                +{formatTokenAmount(estimatedReward)} FORMA
              </span>
            </div>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" onClick={onClose} disabled={isSubmitting}>
            Cancel
          </Button>
          <Button
            onClick={handleSubmit}
            disabled={
              numAmount <= 0 || numAmount > availableBalance || isSubmitting
            }
          >
            {isSubmitting ? (
              <>
                <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                Staking...
              </>
            ) : (
              <>
                <Lock className="w-4 h-4 mr-2" />
                Stake
              </>
            )}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════

export function TokenDashboard() {
  const [state, _setState] = useState<TokenEconomyState>(() =>
    initializeTokenEconomyState(),
  );
  const [account, _setAccount] = useState<AccountOverview>(() =>
    initializeAccountOverview(`user-${generateId()}`),
  );
  const [stakeDialogOpen, setStakeDialogOpen] = useState(false);
  const [activeTab, setActiveTab] = useState("overview");

  const handleStake = useCallback(
    (amount: number, durationDays: number, autoCompound: boolean) => {
      console.log("Stake:", { amount, durationDays, autoCompound });
    },
    [],
  );

  const handleUnstake = useCallback((positionId: string) => {
    console.log("Unstake:", positionId);
  }, []);

  const handleClaimRewards = useCallback((positionId: string) => {
    console.log("Claim rewards:", positionId);
  }, []);

  return (
    <div className="flex flex-col h-full overflow-hidden bg-background">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-3 border-b border-border shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-yellow-500 to-orange-600 flex items-center justify-center">
            <Coins className="w-5 h-5 text-white" />
          </div>
          <div>
            <h1 className="text-sm font-bold">FORMA Token Dashboard</h1>
            <p className="text-xs text-muted-foreground">
              Supply: {formatTokenAmount(state.supply.totalSupply)} · Market
              Cap: ${formatTokenAmount(state.market.marketCap)}
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          <div
            className={`flex items-center gap-1 text-sm ${state.market.price.change24h >= 0 ? "text-green-500" : "text-red-500"}`}
          >
            {state.market.price.change24h >= 0 ? (
              <ArrowUp className="w-4 h-4" />
            ) : (
              <ArrowDown className="w-4 h-4" />
            )}
            ${state.market.price.priceUSD.toFixed(4)}
          </div>
          <Badge variant="outline">Beat #{state.currentBeat}</Badge>
        </div>
      </div>

      {/* Main content */}
      <div className="flex-1 flex overflow-hidden">
        {/* Left panel - Account */}
        <div className="w-80 border-r border-border p-4 overflow-y-auto space-y-4">
          <BalanceCard account={account} market={state.market} />
          <PriceCard market={state.market} />
        </div>

        {/* Center - Main content */}
        <div className="flex-1 p-4 overflow-y-auto">
          <Tabs value={activeTab} onValueChange={setActiveTab}>
            <TabsList className="grid w-full grid-cols-4 mb-4">
              <TabsTrigger value="overview" className="text-xs">
                Overview
              </TabsTrigger>
              <TabsTrigger value="staking" className="text-xs">
                Staking
              </TabsTrigger>
              <TabsTrigger value="transactions" className="text-xs">
                Transactions
              </TabsTrigger>
              <TabsTrigger value="treasury" className="text-xs">
                Treasury
              </TabsTrigger>
            </TabsList>

            <TabsContent value="overview" className="mt-0 space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <SupplyOverview supply={state.supply} />
                <StakingOverview stats={state.stakingStats} />
              </div>
            </TabsContent>

            <TabsContent value="staking" className="mt-0">
              <StakingPositionsPanel
                positions={state.stakingPositions}
                onStake={() => setStakeDialogOpen(true)}
                onUnstake={handleUnstake}
                onClaimRewards={handleClaimRewards}
              />
            </TabsContent>

            <TabsContent value="transactions" className="mt-0">
              <TransactionsPanel transactions={state.recentTransactions} />
            </TabsContent>

            <TabsContent value="treasury" className="mt-0">
              <TreasuryPanel treasury={state.treasury} />
            </TabsContent>
          </Tabs>
        </div>

        {/* Right panel - Quick actions */}
        <div className="w-72 border-l border-border p-4 overflow-y-auto space-y-4">
          <Card className="bg-background/95 border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-semibold">
                Quick Actions
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              <Button
                className="w-full justify-start"
                variant="outline"
                size="sm"
                onClick={() => setStakeDialogOpen(true)}
              >
                <Lock className="w-4 h-4 mr-2" />
                Stake FORMA
              </Button>
              <Button
                className="w-full justify-start"
                variant="outline"
                size="sm"
              >
                <Send className="w-4 h-4 mr-2" />
                Transfer
              </Button>
              <Button
                className="w-full justify-start"
                variant="outline"
                size="sm"
              >
                <Gift className="w-4 h-4 mr-2" />
                Claim Rewards
              </Button>
              <Button
                className="w-full justify-start"
                variant="outline"
                size="sm"
              >
                <ExternalLink className="w-4 h-4 mr-2" />
                View on Explorer
              </Button>
            </CardContent>
          </Card>

          <Card className="bg-background/95 border-border">
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-semibold">
                Staking Tiers
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {(
                Object.entries(STAKING_TIERS) as [
                  StakingTier,
                  (typeof STAKING_TIERS)[StakingTier],
                ][]
              ).map(([tier, info]) => (
                <div
                  key={tier}
                  className="flex items-center justify-between p-2 rounded"
                  style={{ backgroundColor: `${info.color}15` }}
                >
                  <div className="flex items-center gap-2">
                    <div
                      className="w-3 h-3 rounded-full"
                      style={{ backgroundColor: info.color }}
                    />
                    <span className="text-xs font-semibold">{info.name}</span>
                  </div>
                  <div className="text-[10px] text-muted-foreground">
                    {info.apyMultiplier}x APY
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Dialogs */}
      <StakeDialog
        open={stakeDialogOpen}
        onClose={() => setStakeDialogOpen(false)}
        availableBalance={account.balance.availableBalance}
        onStake={handleStake}
      />
    </div>
  );
}

export default TokenDashboard;
