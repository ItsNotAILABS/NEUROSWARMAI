/**
 * ECONOMIC ENGINE - FRONTEND VERSION (FEMALE)
 *
 * MEDINA'S MIRROR LAW (Law 9):
 * Backend (Male): FORMA minting, Architect Reserve, Player Pool - THE AUTHORITY
 * Frontend (Female): Visual expression, mint particles, rate display
 *
 * The frontend doesn't mint FORMA.
 * It DISPLAYS what the backend mints.
 * It shows the player their value accumulating in real-time.
 *
 * FORMA Minting Formula (Backend):
 * mintRate = 0.275 × territories × r × architectSignal
 *
 * PROPRIETARY INTELLECTUAL PROPERTY
 */

// ============================================================================
// FORMA TOKEN CONSTANTS
// ============================================================================

export const FORMA_CONSTANTS = {
  /** Base mint rate coefficient */
  BASE_MINT_COEFFICIENT: 0.275,

  /** Architect reserve percentage */
  ARCHITECT_RESERVE_PERCENTAGE: 0.1,

  /** Player pool percentage */
  PLAYER_POOL_PERCENTAGE: 0.9,

  /** OMNIS surge multiplier */
  OMNIS_SURGE_MULTIPLIER: 2.75,

  /** Minimum mint rate per beat */
  MIN_MINT_RATE: 0.0001,

  /** Maximum mint rate per beat */
  MAX_MINT_RATE: 10.0,

  /** FORMA token decimals */
  TOKEN_DECIMALS: 8,

  /** Genesis supply */
  GENESIS_SUPPLY: 0,

  /** Maximum theoretical supply (soft cap) */
  MAX_SUPPLY: 1_000_000_000, // 1 billion
} as const;

// ============================================================================
// ECONOMIC METRICS
// ============================================================================

export interface FormaMintState {
  /** Current mint rate per beat */
  mintRatePerBeat: number;

  /** Total FORMA minted all time */
  totalMinted: number;

  /** Current circulating supply */
  circulatingSupply: number;

  /** Architect reserve balance */
  architectReserve: number;

  /** Player pool balance */
  playerPoolBalance: number;

  /** Current OMNIS multiplier active */
  omnisMultiplierActive: boolean;

  /** Current effective multiplier */
  effectiveMultiplier: number;

  /** Last mint beat */
  lastMintBeat: number;

  /** Mints this session */
  sessionMints: number;

  /** Session FORMA earned */
  sessionFormaEarned: number;
}

export interface PlayerEconomicState {
  /** Player wallet balance */
  walletBalance: number;

  /** Pending (uncommitted) earnings */
  pendingEarnings: number;

  /** Total earned all time */
  totalEarned: number;

  /** Total spent all time */
  totalSpent: number;

  /** Current earning rate per beat */
  earningRatePerBeat: number;

  /** Territory bonus multiplier */
  territoryBonus: number;

  /** Faction bonus multiplier */
  factionBonus: number;

  /** Session start balance */
  sessionStartBalance: number;

  /** Session earnings so far */
  sessionEarnings: number;
}

// ============================================================================
// YIELD OPTIMIZATION
// ============================================================================

export interface YieldOptimizerState {
  /** Current APY estimate */
  currentAPY: number;

  /** 7-day average APY */
  averageAPY7d: number;

  /** 30-day average APY */
  averageAPY30d: number;

  /** Optimal territory allocation */
  optimalTerritoryAllocation: Record<number, number>;

  /** Optimal faction choice */
  optimalFaction: number | null;

  /** Yield efficiency score (0-1) */
  yieldEfficiency: number;

  /** Recommendations */
  recommendations: YieldRecommendation[];
}

export interface YieldRecommendation {
  type: "territory" | "faction" | "timing" | "strategy";
  priority: "low" | "medium" | "high";
  description: string;
  expectedImpact: number; // Percentage improvement
  action: string;
}

// ============================================================================
// ECONOMIC EVENTS
// ============================================================================

export type EconomicEventType =
  | "mint"
  | "transfer"
  | "earn"
  | "spend"
  | "stake"
  | "unstake"
  | "reward"
  | "penalty"
  | "omnis_bonus"
  | "territory_bonus"
  | "faction_bonus";

export interface EconomicEvent {
  type: EconomicEventType;
  amount: number;
  timestamp: number;
  beat: number;
  tick: number;
  source: "backend" | "frontend";
  details: Record<string, unknown>;
}

// ============================================================================
// ECONOMIC ENGINE CONFIGURATION
// ============================================================================

export interface EconomicEngineConfig {
  /** Enable visual mint effects */
  enableMintEffects: boolean;

  /** Enable earning notifications */
  enableEarningNotifications: boolean;

  /** Notification threshold (minimum FORMA to notify) */
  notificationThreshold: number;

  /** Update rate for display (ticks) */
  displayUpdateInterval: number;

  /** Sync interval with backend (ticks) */
  backendSyncInterval: number;

  /** Enable yield optimizer */
  enableYieldOptimizer: boolean;

  /** Event history size */
  eventHistorySize: number;
}

export const DEFAULT_ECONOMIC_CONFIG: EconomicEngineConfig = {
  enableMintEffects: true,
  enableEarningNotifications: true,
  notificationThreshold: 0.01,
  displayUpdateInterval: 6, // 10 times per second
  backendSyncInterval: 300, // Every 5 seconds
  enableYieldOptimizer: true,
  eventHistorySize: 1000,
};

// ============================================================================
// MINT EFFECT VISUALS
// ============================================================================

export const MINT_VISUAL_EFFECTS = {
  /** Particle effect for normal mint */
  NORMAL_MINT: {
    particleCount: 20,
    color: "#FFD700", // Gold
    size: 0.1,
    duration: 1000,
    spread: 0.5,
    velocity: 2,
  },

  /** Particle effect for OMNIS-boosted mint */
  OMNIS_MINT: {
    particleCount: 50,
    color: "#FF00FF", // Magenta
    size: 0.15,
    duration: 2000,
    spread: 1.0,
    velocity: 3,
  },

  /** Particle effect for territory bonus */
  TERRITORY_BONUS: {
    particleCount: 30,
    color: "#00FF00", // Green
    size: 0.12,
    duration: 1500,
    spread: 0.7,
    velocity: 2.5,
  },

  /** Screen effect for large earnings */
  LARGE_EARNING: {
    flashColor: "#FFD700",
    flashDuration: 300,
    screenShake: 0.01,
    bloomIntensity: 1.2,
  },
} as const;

// ============================================================================
// EARNING FORMULAS (FRONTEND CALCULATION)
// These mirror the backend formulas for display purposes
// ============================================================================

/**
 * Calculate base mint rate
 * mintRate = 0.275 × territories × r × architectSignal
 */
export function calculateBaseMintRate(
  territoriesControlled: number,
  kuramotoR: number,
  architectSignal: number,
): number {
  return (
    FORMA_CONSTANTS.BASE_MINT_COEFFICIENT *
    territoriesControlled *
    kuramotoR *
    architectSignal
  );
}

/**
 * Calculate player share of mint
 */
export function calculatePlayerShare(
  totalMint: number,
  playerContribution: number,
  totalContribution: number,
): number {
  if (totalContribution <= 0) return 0;
  const playerPoolMint = totalMint * FORMA_CONSTANTS.PLAYER_POOL_PERCENTAGE;
  return playerPoolMint * (playerContribution / totalContribution);
}

/**
 * Calculate OMNIS bonus
 */
export function calculateOmnisBonus(
  baseAmount: number,
  omnisActive: boolean,
): number {
  if (!omnisActive) return baseAmount;
  return baseAmount * FORMA_CONSTANTS.OMNIS_SURGE_MULTIPLIER;
}

/**
 * Calculate territory bonus multiplier
 */
export function calculateTerritoryBonus(
  territoriesControlled: number,
  totalTerritories: number,
): number {
  if (totalTerritories <= 0) return 1.0;
  const controlPercentage = territoriesControlled / totalTerritories;
  return 1.0 + controlPercentage * 0.5; // Up to 50% bonus for full control
}

/**
 * Format FORMA amount for display
 */
export function formatFormaAmount(amount: number, decimals = 4): string {
  if (amount >= 1_000_000) {
    return `${(amount / 1_000_000).toFixed(2)}M`;
  }
  if (amount >= 1_000) {
    return `${(amount / 1_000).toFixed(2)}K`;
  }
  return amount.toFixed(decimals);
}

/**
 * Format earning rate for display
 */
export function formatEarningRate(ratePerBeat: number): string {
  const ratePerMinute = ratePerBeat * 60; // Assuming ~1 beat per second
  return `${formatFormaAmount(ratePerMinute)} FORMA/min`;
}
