// ═══════════════════════════════════════════════════════════════════════════════
// ECONOMY ENGINE — FORMA Token Economy, Markets, Auctions, Trade Routes
// Owner: Alfredo Medina Hernandez | MedinaSITech@outlook.com
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Core Token Types ────────────────────────────────────────────────────────

export type CurrencyType = "FORMA" | "RAW" | "SIGNAL" | "ENTROPY" | "VOID";

export type MarketOrderType = "buy" | "sell" | "swap";
export type MarketOrderStatus = "open" | "filled" | "cancelled" | "expired";

export type AssetCategory =
  | "organism"
  | "territory"
  | "artifact"
  | "doctrine"
  | "signal"
  | "drone"
  | "law_token"
  | "anomaly_shard"
  | "memory_crystal"
  | "void_fragment";

export interface FormaAccount {
  holderId: string; // organism id or faction id
  holderType: "organism" | "faction" | "system";
  balance: number;
  stakedBalance: number;
  frozenBalance: number;
  earnedLifetime: number;
  spentLifetime: number;
  transactionCount: number;
  lastActivityTick: number;
  creditRating: number; // 0-1, affects loan access
}

export interface MarketAsset {
  id: string;
  category: AssetCategory;
  name: string;
  description: string;
  baseValue: number; // FORMA
  currentPrice: number;
  supply: number;
  demand: number;
  volatility: number; // 0-1
  rarity: "common" | "uncommon" | "rare" | "legendary" | "void";
  factionOrigin?: number;
  tickListed: number;
  tags: string[];
}

export interface MarketOrder {
  id: string;
  assetId: string;
  buyerId?: string;
  sellerId: string;
  type: MarketOrderType;
  quantity: number;
  pricePerUnit: number;
  totalValue: number;
  currency: CurrencyType;
  status: MarketOrderStatus;
  placedTick: number;
  filledTick?: number;
  expiryTick: number;
}

export interface TradeRoute {
  id: string;
  fromId: string; // faction or region id
  toId: string;
  commodities: Array<{
    assetId: string;
    volumePerTick: number;
    priceMultiplier: number;
  }>;
  totalVolumePerTick: number;
  establishedTick: number;
  active: boolean;
  disrupted: boolean;
  disruptionCause?: string;
  securityRating: number; // 0-1
  profitMargin: number; // 0-1
}

export interface AuctionLot {
  id: string;
  assetId: string;
  assetName: string;
  startPrice: number;
  currentBid: number;
  currentBidder?: string;
  reservePrice: number;
  openTick: number;
  closeTick: number;
  bids: AuctionBid[];
  settled: boolean;
  winnerId?: string;
  finalPrice?: number;
}

export interface AuctionBid {
  bidderId: string;
  amount: number;
  tick: number;
  auto: boolean;
}

export interface LoanContract {
  id: string;
  borrowerId: string;
  lenderId: string;
  principal: number;
  interestRate: number; // per 1000 ticks
  issuedTick: number;
  dueTick: number;
  remainingBalance: number;
  collateralAssetId?: string;
  defaulted: boolean;
  repaidTick?: number;
}

export interface EconomicPolicy {
  baseTaxRate: number;
  exportTariff: number;
  importTariff: number;
  subsidyFormaOrganisms: number;
  subsidyFormaInfra: number;
  priceFloorEnabled: boolean;
  priceCeilingEnabled: boolean;
  inflationTarget: number;
}

export interface MarketSnapshot {
  tick: number;
  totalLiquidity: number;
  activeOrders: number;
  volume24h: number; // last 1000 ticks equivalent
  dominantCurrency: CurrencyType;
  priceIndex: Record<string, number>; // assetId → price
  marketSentiment: "bull" | "bear" | "volatile" | "frozen";
  gini: number; // inequality 0-1
  topAssets: string[];
}

// ─── Economy Constants ───────────────────────────────────────────────────────

export const FORMA_TOTAL_SUPPLY = 21_000_000;
export const FORMA_INITIAL_EMISSION_RATE = 0.5; // per tick to ecosystem
export const FORMA_HALVING_INTERVAL = 10_000; // ticks
export const MARKET_TRANSACTION_FEE = 0.015; // 1.5%
export const AUCTION_EXTEND_ON_BID_TICKS = 50;
export const LOAN_DEFAULT_PENALTY = 0.25; // 25% extra owed
export const TRADE_ROUTE_SETUP_COST = 200;
export const TRADE_DISRUPTION_RECOVERY_TICKS = 300;
export const PRICE_ELASTICITY_BASE = 0.12;
export const DEMAND_SMOOTHING_FACTOR = 0.05;
export const RARITY_MULTIPLIERS: Record<MarketAsset["rarity"], number> = {
  common: 1,
  uncommon: 2.5,
  rare: 7,
  legendary: 22,
  void: 100,
};

// ─── Asset Catalog ───────────────────────────────────────────────────────────

export const ASSET_CATALOG: MarketAsset[] = [
  {
    id: "ast-drone-basic",
    category: "drone",
    name: "Field Drone Mk-I",
    description: "Standard patrol and collection drone. Reliable, no frills.",
    baseValue: 120,
    currentPrice: 120,
    supply: 500,
    demand: 300,
    volatility: 0.15,
    rarity: "common",
    tickListed: 0,
    tags: ["drone", "patrol", "combat"],
  },
  {
    id: "ast-drone-recon",
    category: "drone",
    name: "Recon Spectre",
    description: "Stealth reconnaissance drone. Emits no signal signature.",
    baseValue: 450,
    currentPrice: 450,
    supply: 120,
    demand: 200,
    volatility: 0.28,
    rarity: "uncommon",
    tickListed: 0,
    tags: ["drone", "recon", "stealth"],
  },
  {
    id: "ast-drone-siege",
    category: "drone",
    name: "Siege Leviathan",
    description: "Heavy siege drone. Decimates infrastructure at cost.",
    baseValue: 1800,
    currentPrice: 1800,
    supply: 30,
    demand: 80,
    volatility: 0.45,
    rarity: "rare",
    tickListed: 0,
    tags: ["drone", "siege", "heavy"],
  },
  {
    id: "ast-territory-prime",
    category: "territory",
    name: "Prime Grid Cell",
    description: "High-law-density territory parcel with stable material.",
    baseValue: 2000,
    currentPrice: 2000,
    supply: 50,
    demand: 150,
    volatility: 0.3,
    rarity: "rare",
    tickListed: 0,
    tags: ["territory", "prime", "stable"],
  },
  {
    id: "ast-artifact-memoria",
    category: "artifact",
    name: "Memoria Crystal",
    description: "Stores compressed organism memory state. Tradeable wisdom.",
    baseValue: 3500,
    currentPrice: 3500,
    supply: 20,
    demand: 60,
    volatility: 0.5,
    rarity: "rare",
    tickListed: 0,
    tags: ["memory", "artifact", "organism"],
  },
  {
    id: "ast-anomaly-shard",
    category: "anomaly_shard",
    name: "Void Shard Ω",
    description: "Fragment of a collapsed anomaly. Raw emergent energy.",
    baseValue: 12000,
    currentPrice: 12000,
    supply: 5,
    demand: 40,
    volatility: 0.8,
    rarity: "legendary",
    tickListed: 0,
    tags: ["void", "anomaly", "energy"],
  },
  {
    id: "ast-void-fragment",
    category: "void_fragment",
    name: "Unclass Void Fragment",
    description: "Unclassified void-space debris. Potentially catastrophic.",
    baseValue: 50000,
    currentPrice: 50000,
    supply: 1,
    demand: 10,
    volatility: 0.95,
    rarity: "void",
    tickListed: 0,
    tags: ["void", "fragment", "dangerous"],
  },
  {
    id: "ast-doctrine-expansion",
    category: "doctrine",
    name: "Expansion Codex",
    description: "Encoded strategic doctrine granting expansion bonuses.",
    baseValue: 800,
    currentPrice: 800,
    supply: 40,
    demand: 90,
    volatility: 0.22,
    rarity: "uncommon",
    tickListed: 0,
    tags: ["doctrine", "expansion", "faction"],
  },
  {
    id: "ast-signal-beacon",
    category: "signal",
    name: "Coherence Beacon",
    description: "Broadcasts organism coherence amplification signal.",
    baseValue: 600,
    currentPrice: 600,
    supply: 80,
    demand: 120,
    volatility: 0.18,
    rarity: "common",
    tickListed: 0,
    tags: ["signal", "organism", "boost"],
  },
  {
    id: "ast-law-token",
    category: "law_token",
    name: "World Law Token",
    description: "Represents one vote on macro world physical law parameters.",
    baseValue: 5000,
    currentPrice: 5000,
    supply: 10,
    demand: 30,
    volatility: 0.6,
    rarity: "legendary",
    tickListed: 0,
    tags: ["governance", "law", "world"],
  },
];

// ─── Price Engine ────────────────────────────────────────────────────────────

export function updateAssetPrice(asset: MarketAsset): number {
  const supplyDemandRatio = asset.supply > 0 ? asset.demand / asset.supply : 2;
  const elasticityFactor = 1 + (supplyDemandRatio - 1) * PRICE_ELASTICITY_BASE;
  const rarityMult = RARITY_MULTIPLIERS[asset.rarity];
  const volatilityJitter = 1 + (Math.random() - 0.5) * asset.volatility * 0.1;

  const targetPrice =
    asset.baseValue * rarityMult * elasticityFactor * volatilityJitter;
  // Smooth price move towards target
  const alpha = DEMAND_SMOOTHING_FACTOR;
  asset.currentPrice = asset.currentPrice * (1 - alpha) + targetPrice * alpha;
  return asset.currentPrice;
}

export function bulkUpdatePrices(assets: MarketAsset[]): void {
  for (const asset of assets) {
    updateAssetPrice(asset);
  }
}

export function applyShockToMarket(
  assets: MarketAsset[],
  shockType: "crash" | "boom" | "scarcity" | "surplus",
  magnitude: number, // 0-1
  affectedCategories: AssetCategory[],
): void {
  for (const asset of assets) {
    if (!affectedCategories.includes(asset.category)) continue;
    switch (shockType) {
      case "crash":
        asset.currentPrice *= 1 - magnitude * 0.6;
        asset.demand *= 1 - magnitude * 0.4;
        break;
      case "boom":
        asset.currentPrice *= 1 + magnitude * 0.8;
        asset.demand *= 1 + magnitude * 0.5;
        break;
      case "scarcity":
        asset.supply = Math.max(1, asset.supply * (1 - magnitude * 0.5));
        asset.currentPrice *= 1 + magnitude * 1.2;
        break;
      case "surplus":
        asset.supply *= 1 + magnitude * 1.0;
        asset.currentPrice *= 1 - magnitude * 0.4;
        break;
    }
    asset.currentPrice = Math.max(1, asset.currentPrice);
  }
}

// ─── Account Management ──────────────────────────────────────────────────────

export function createAccount(
  holderId: string,
  holderType: FormaAccount["holderType"],
  initialBalance = 0,
): FormaAccount {
  return {
    holderId,
    holderType,
    balance: initialBalance,
    stakedBalance: 0,
    frozenBalance: 0,
    earnedLifetime: initialBalance,
    spentLifetime: 0,
    transactionCount: 0,
    lastActivityTick: 0,
    creditRating: 0.5,
  };
}

export function transfer(
  from: FormaAccount,
  to: FormaAccount,
  amount: number,
  tick: number,
  applyFee = true,
): boolean {
  const fee = applyFee ? amount * MARKET_TRANSACTION_FEE : 0;
  const total = amount + fee;
  if (from.balance < total) return false;

  from.balance -= total;
  from.spentLifetime += total;
  from.transactionCount++;
  from.lastActivityTick = tick;

  to.balance += amount;
  to.earnedLifetime += amount;
  to.transactionCount++;
  to.lastActivityTick = tick;

  return true;
}

export function stake(account: FormaAccount, amount: number): boolean {
  if (account.balance < amount) return false;
  account.balance -= amount;
  account.stakedBalance += amount;
  return true;
}

export function unstake(
  account: FormaAccount,
  amount: number,
  rewards: number,
): void {
  const actual = Math.min(amount, account.stakedBalance);
  account.stakedBalance -= actual;
  account.balance += actual + rewards;
  account.earnedLifetime += rewards;
}

export function freeze(account: FormaAccount, amount: number): boolean {
  if (account.balance < amount) return false;
  account.balance -= amount;
  account.frozenBalance += amount;
  return true;
}

export function unfreeze(account: FormaAccount, amount: number): void {
  const actual = Math.min(amount, account.frozenBalance);
  account.frozenBalance -= actual;
  account.balance += actual;
}

// ─── Order Book ──────────────────────────────────────────────────────────────

export class OrderBook {
  private orders = new Map<string, MarketOrder>();
  private ordersByAsset = new Map<string, string[]>();

  placeOrder(order: MarketOrder): void {
    this.orders.set(order.id, order);
    if (!this.ordersByAsset.has(order.assetId)) {
      this.ordersByAsset.set(order.assetId, []);
    }
    this.ordersByAsset.get(order.assetId)!.push(order.id);
  }

  getOpenOrdersForAsset(assetId: string): MarketOrder[] {
    return (this.ordersByAsset.get(assetId) ?? [])
      .map((id) => this.orders.get(id)!)
      .filter((o) => o && o.status === "open");
  }

  cancelOrder(orderId: string): boolean {
    const order = this.orders.get(orderId);
    if (!order || order.status !== "open") return false;
    order.status = "cancelled";
    return true;
  }

  matchOrders(
    assetId: string,
    currentTick: number,
  ): Array<{ buyOrder: MarketOrder; sellOrder: MarketOrder; price: number }> {
    const open = this.getOpenOrdersForAsset(assetId);
    const buys = open
      .filter((o) => o.type === "buy")
      .sort((a, b) => b.pricePerUnit - a.pricePerUnit);
    const sells = open
      .filter((o) => o.type === "sell")
      .sort((a, b) => a.pricePerUnit - b.pricePerUnit);
    const matches: Array<{
      buyOrder: MarketOrder;
      sellOrder: MarketOrder;
      price: number;
    }> = [];

    let bi = 0;
    let si = 0;
    while (bi < buys.length && si < sells.length) {
      const buy = buys[bi];
      const sell = sells[si];
      if (buy.pricePerUnit >= sell.pricePerUnit) {
        const price = (buy.pricePerUnit + sell.pricePerUnit) / 2;
        matches.push({ buyOrder: buy, sellOrder: sell, price });
        buy.status = "filled";
        buy.filledTick = currentTick;
        sell.status = "filled";
        sell.filledTick = currentTick;
        bi++;
        si++;
      } else {
        break;
      }
    }

    return matches;
  }

  pruneExpired(currentTick: number): number {
    let count = 0;
    for (const order of this.orders.values()) {
      if (order.status === "open" && currentTick > order.expiryTick) {
        order.status = "expired";
        count++;
      }
    }
    return count;
  }

  getDepth(assetId: string): { bids: number[]; asks: number[] } {
    const open = this.getOpenOrdersForAsset(assetId);
    return {
      bids: open
        .filter((o) => o.type === "buy")
        .map((o) => o.pricePerUnit)
        .sort((a, b) => b - a),
      asks: open
        .filter((o) => o.type === "sell")
        .map((o) => o.pricePerUnit)
        .sort((a, b) => a - b),
    };
  }
}

// ─── Auction System ──────────────────────────────────────────────────────────

export class AuctionHouse {
  private lots = new Map<string, AuctionLot>();

  listLot(lot: AuctionLot): void {
    this.lots.set(lot.id, lot);
  }

  bid(
    lotId: string,
    bidderId: string,
    amount: number,
    tick: number,
    auto = false,
  ): boolean {
    const lot = this.lots.get(lotId);
    if (!lot || lot.settled || tick > lot.closeTick) return false;
    if (amount <= lot.currentBid) return false;

    lot.currentBid = amount;
    lot.currentBidder = bidderId;
    lot.bids.push({ bidderId, amount, tick, auto });

    // Extend if bid placed near close
    if (lot.closeTick - tick < AUCTION_EXTEND_ON_BID_TICKS) {
      lot.closeTick += AUCTION_EXTEND_ON_BID_TICKS;
    }

    return true;
  }

  settle(lotId: string, currentTick: number): AuctionLot | null {
    const lot = this.lots.get(lotId);
    if (!lot || lot.settled || currentTick < lot.closeTick) return null;

    lot.settled = true;
    if (lot.currentBid >= lot.reservePrice && lot.currentBidder) {
      lot.winnerId = lot.currentBidder;
      lot.finalPrice = lot.currentBid;
    } else {
      lot.winnerId = undefined;
      lot.finalPrice = undefined;
    }

    return lot;
  }

  settleAll(currentTick: number): AuctionLot[] {
    const settled: AuctionLot[] = [];
    for (const lot of this.lots.values()) {
      if (!lot.settled && currentTick >= lot.closeTick) {
        const result = this.settle(lot.id, currentTick);
        if (result) settled.push(result);
      }
    }
    return settled;
  }

  getActiveLots(currentTick: number): AuctionLot[] {
    return [...this.lots.values()].filter(
      (l) => !l.settled && currentTick <= l.closeTick,
    );
  }
}

// ─── Trade Route Engine ──────────────────────────────────────────────────────

export function createTradeRoute(
  fromId: string,
  toId: string,
  commodities: TradeRoute["commodities"],
  tick: number,
  accounts: Map<string, FormaAccount>,
): TradeRoute | null {
  const fromAccount = accounts.get(fromId);
  if (!fromAccount || fromAccount.balance < TRADE_ROUTE_SETUP_COST) return null;

  fromAccount.balance -= TRADE_ROUTE_SETUP_COST;

  return {
    id: `route-${fromId}-${toId}-${tick}`,
    fromId,
    toId,
    commodities,
    totalVolumePerTick: commodities.reduce(
      (sum, c) => sum + c.volumePerTick,
      0,
    ),
    establishedTick: tick,
    active: true,
    disrupted: false,
    securityRating: 0.7 + Math.random() * 0.3,
    profitMargin: 0.1 + Math.random() * 0.2,
  };
}

export function tickTradeRoute(
  route: TradeRoute,
  fromAccount: FormaAccount,
  _toAccount: FormaAccount,
  assets: Map<string, MarketAsset>,
  _tick: number,
): number {
  if (!route.active || route.disrupted) return 0;

  let profit = 0;
  for (const commodity of route.commodities) {
    const asset = assets.get(commodity.assetId);
    if (!asset) continue;
    const revenue =
      commodity.volumePerTick * asset.currentPrice * commodity.priceMultiplier;
    const fee = revenue * MARKET_TRANSACTION_FEE;
    fromAccount.balance += revenue - fee;
    fromAccount.earnedLifetime += revenue - fee;
    profit += revenue - fee;
    asset.demand += commodity.volumePerTick * 0.1;
  }

  // Random disruption
  if (Math.random() < (1 - route.securityRating) * 0.002) {
    route.disrupted = true;
    route.disruptionCause = "interdiction";
  }

  return profit;
}

// ─── Loan System ─────────────────────────────────────────────────────────────

export function issueLoan(
  borrowerAccount: FormaAccount,
  lenderAccount: FormaAccount,
  principal: number,
  interestRate: number,
  durationTicks: number,
  tick: number,
  collateralAssetId?: string,
): LoanContract | null {
  if (borrowerAccount.creditRating < 0.3) return null;
  if (lenderAccount.balance < principal) return null;

  lenderAccount.balance -= principal;
  borrowerAccount.balance += principal;
  borrowerAccount.earnedLifetime += principal;

  return {
    id: `loan-${borrowerAccount.holderId}-${tick}`,
    borrowerId: borrowerAccount.holderId,
    lenderId: lenderAccount.holderId,
    principal,
    interestRate,
    issuedTick: tick,
    dueTick: tick + durationTicks,
    remainingBalance: principal * (1 + interestRate),
    collateralAssetId,
    defaulted: false,
  };
}

export function repayLoan(
  loan: LoanContract,
  borrowerAccount: FormaAccount,
  lenderAccount: FormaAccount,
  amount: number,
  tick: number,
): boolean {
  if (borrowerAccount.balance < amount) return false;
  borrowerAccount.balance -= amount;
  lenderAccount.balance += amount;
  loan.remainingBalance -= amount;

  if (loan.remainingBalance <= 0) {
    loan.repaidTick = tick;
    borrowerAccount.creditRating = Math.min(
      1,
      borrowerAccount.creditRating + 0.05,
    );
  }

  return true;
}

export function processLoanDefault(
  loan: LoanContract,
  borrowerAccount: FormaAccount,
  _tick: number,
): void {
  loan.defaulted = true;
  borrowerAccount.creditRating = Math.max(
    0,
    borrowerAccount.creditRating - 0.3,
  );
  // Penalty: remaining balance inflated
  loan.remainingBalance *= 1 + LOAN_DEFAULT_PENALTY;
}

// ─── Market Snapshot ─────────────────────────────────────────────────────────

export function takeMarketSnapshot(
  assets: MarketAsset[],
  accounts: FormaAccount[],
  orders: MarketOrder[],
  tick: number,
): MarketSnapshot {
  const totalLiquidity = accounts.reduce((s, a) => s + a.balance, 0);
  const activeOrders = orders.filter((o) => o.status === "open").length;
  const recentOrders = orders.filter(
    (o) => o.status === "filled" && tick - (o.filledTick ?? 0) < 1000,
  );
  const volume24h = recentOrders.reduce((s, o) => s + o.totalValue, 0);

  const priceIndex: Record<string, number> = {};
  for (const a of assets) {
    priceIndex[a.id] = a.currentPrice;
  }

  const balances = accounts.map((a) => a.balance).sort((a, b) => a - b);
  const gini = computeGini(balances);

  const sortedAssets = [...assets].sort((a, b) => b.demand - a.demand);
  const topAssets = sortedAssets.slice(0, 5).map((a) => a.id);

  const avgVol =
    assets.reduce((s, a) => s + a.volatility, 0) / (assets.length || 1);
  let sentiment: MarketSnapshot["marketSentiment"] = "volatile";
  if (volume24h < 1000) sentiment = "frozen";
  else if (avgVol < 0.25 && totalLiquidity > 100000) sentiment = "bull";
  else if (avgVol < 0.25) sentiment = "bear";

  return {
    tick,
    totalLiquidity,
    activeOrders,
    volume24h,
    dominantCurrency: "FORMA",
    priceIndex,
    marketSentiment: sentiment,
    gini,
    topAssets,
  };
}

function computeGini(sortedBalances: number[]): number {
  const n = sortedBalances.length;
  if (n === 0) return 0;
  let numerator = 0;
  const total = sortedBalances.reduce((s, v) => s + v, 0);
  if (total === 0) return 0;
  for (let i = 0; i < n; i++) {
    numerator += (2 * (i + 1) - n - 1) * sortedBalances[i];
  }
  return Math.abs(numerator) / (n * total);
}

// ─── FORMA Emission ──────────────────────────────────────────────────────────

export function getEmissionRate(tick: number): number {
  const halvings = Math.floor(tick / FORMA_HALVING_INTERVAL);
  return FORMA_INITIAL_EMISSION_RATE / 2 ** halvings;
}

export function emitFORMA(
  recipientAccounts: FormaAccount[],
  tick: number,
  weights?: number[],
): void {
  const rate = getEmissionRate(tick);
  const totalWeight = weights
    ? weights.reduce((s, w) => s + w, 0)
    : recipientAccounts.length;

  recipientAccounts.forEach((acc, i) => {
    const weight = weights ? (weights[i] ?? 0) : 1;
    const amount = (rate * weight) / (totalWeight || 1);
    acc.balance += amount;
    acc.earnedLifetime += amount;
  });
}

// ─── Economic Policy ─────────────────────────────────────────────────────────

export const DEFAULT_ECONOMIC_POLICY: EconomicPolicy = {
  baseTaxRate: 0.05,
  exportTariff: 0.03,
  importTariff: 0.04,
  subsidyFormaOrganisms: 0.02,
  subsidyFormaInfra: 0.01,
  priceFloorEnabled: false,
  priceCeilingEnabled: false,
  inflationTarget: 0.02,
};

export function applyTaxation(
  accounts: FormaAccount[],
  policy: EconomicPolicy,
  _tick: number,
): number {
  let totalCollected = 0;
  for (const acc of accounts) {
    if (acc.holderType === "system") continue;
    const tax = acc.balance * policy.baseTaxRate * 0.001; // per-tick fraction
    acc.balance = Math.max(0, acc.balance - tax);
    totalCollected += tax;
  }
  return totalCollected;
}

// ─── Wealth Distribution Stats ───────────────────────────────────────────────

export interface WealthStats {
  mean: number;
  median: number;
  top10pct: number;
  bottom10pct: number;
  gini: number;
  totalSupply: number;
  richestId: string;
  poorestId: string;
}

export function computeWealthStats(accounts: FormaAccount[]): WealthStats {
  if (accounts.length === 0) {
    return {
      mean: 0,
      median: 0,
      top10pct: 0,
      bottom10pct: 0,
      gini: 0,
      totalSupply: 0,
      richestId: "",
      poorestId: "",
    };
  }

  const sorted = [...accounts].sort((a, b) => a.balance - b.balance);
  const total = sorted.reduce((s, a) => s + a.balance, 0);
  const mean = total / sorted.length;
  const mid = Math.floor(sorted.length / 2);
  const median =
    sorted.length % 2 === 0
      ? (sorted[mid - 1].balance + sorted[mid].balance) / 2
      : sorted[mid].balance;

  const top10 = Math.ceil(sorted.length * 0.1);
  const bot10 = Math.ceil(sorted.length * 0.1);

  const top10total =
    sorted.slice(-top10).reduce((s, a) => s + a.balance, 0) /
    (top10 * mean || 1);
  const bot10total =
    sorted.slice(0, bot10).reduce((s, a) => s + a.balance, 0) /
    (bot10 * mean || 1);

  return {
    mean,
    median,
    top10pct: top10total,
    bottom10pct: bot10total,
    gini: computeGini(sorted.map((a) => a.balance)),
    totalSupply: total,
    richestId: sorted[sorted.length - 1].holderId,
    poorestId: sorted[0].holderId,
  };
}

// ─── Forma Price Oracle ──────────────────────────────────────────────────────

export interface PriceOracle {
  assetId: string;
  twapPrice: number; // time-weighted average
  lastSpotPrice: number;
  high24h: number;
  low24h: number;
  priceHistory: number[]; // rolling window
  lastUpdateTick: number;
}

export function updatePriceOracle(
  oracle: PriceOracle,
  spotPrice: number,
  tick: number,
): void {
  oracle.priceHistory.push(spotPrice);
  if (oracle.priceHistory.length > 1000) oracle.priceHistory.shift();

  const windowSize = Math.min(oracle.priceHistory.length, 200);
  const window = oracle.priceHistory.slice(-windowSize);
  oracle.twapPrice = window.reduce((s, p) => s + p, 0) / window.length;
  oracle.high24h = Math.max(...window);
  oracle.low24h = Math.min(...window);
  oracle.lastSpotPrice = spotPrice;
  oracle.lastUpdateTick = tick;
}

export function createPriceOracle(
  assetId: string,
  initialPrice: number,
): PriceOracle {
  return {
    assetId,
    twapPrice: initialPrice,
    lastSpotPrice: initialPrice,
    high24h: initialPrice,
    low24h: initialPrice,
    priceHistory: [initialPrice],
    lastUpdateTick: 0,
  };
}

// ─── Forma Staking Rewards ───────────────────────────────────────────────────

export interface StakingPool {
  id: string;
  name: string;
  totalStaked: number;
  rewardRatePerTick: number;
  lockupTicks: number;
  minStake: number;
  stakers: Map<string, { amount: number; stakedTick: number }>;
}

export function createStakingPool(
  id: string,
  name: string,
  rewardRate: number,
  lockupTicks: number,
  minStake: number,
): StakingPool {
  return {
    id,
    name,
    totalStaked: 0,
    rewardRatePerTick: rewardRate,
    lockupTicks,
    minStake,
    stakers: new Map(),
  };
}

export function joinPool(
  pool: StakingPool,
  holderId: string,
  amount: number,
  tick: number,
): boolean {
  if (amount < pool.minStake) return false;
  const existing = pool.stakers.get(holderId);
  if (existing) {
    existing.amount += amount;
  } else {
    pool.stakers.set(holderId, { amount, stakedTick: tick });
  }
  pool.totalStaked += amount;
  return true;
}

export function tickStakingPool(
  pool: StakingPool,
  accounts: Map<string, FormaAccount>,
  _tick: number,
): void {
  if (pool.totalStaked === 0) return;
  const totalReward = pool.rewardRatePerTick * pool.totalStaked;
  for (const [holderId, stakeInfo] of pool.stakers) {
    const share = stakeInfo.amount / pool.totalStaked;
    const reward = totalReward * share;
    const acc = accounts.get(holderId);
    if (acc) {
      acc.balance += reward;
      acc.earnedLifetime += reward;
    }
  }
}

export function leavePool(
  pool: StakingPool,
  holderId: string,
  account: FormaAccount,
  tick: number,
): boolean {
  const stakeInfo = pool.stakers.get(holderId);
  if (!stakeInfo) return false;
  if (tick - stakeInfo.stakedTick < pool.lockupTicks) return false;

  account.balance += stakeInfo.amount;
  account.stakedBalance = Math.max(0, account.stakedBalance - stakeInfo.amount);
  pool.totalStaked -= stakeInfo.amount;
  pool.stakers.delete(holderId);
  return true;
}

// ─── UI Adapter Types ────────────────────────────────────────────────────────
// These types match the TradePanel component's expected format for rendering

export type UIMarketSentiment = "Bull" | "Bear" | "Volatile" | "Frozen";

export interface UIAsset {
  id: string;
  name: string;
  symbol: string;
  price: number;
  priceHistory: number[];
  volume24h: number;
  change24h: number;
  totalSupply: number;
}

export interface UIOrderBookEntry {
  price: number;
  quantity: number;
  side: "bid" | "ask";
}

export interface UITradeRoute {
  id: string;
  from: string;
  to: string;
  commodities: string[];
  profitMargin: number;
  disrupted: boolean;
  disruptionReason?: string;
  activeCarriers: number;
  distanceUnits: number;
}

export interface UIAuctionLot {
  id: string;
  name: string;
  currentBid: number;
  endsAtTick: number;
  category: string;
}

export interface UIMarketSnapshot {
  sentiment: UIMarketSentiment;
  formaSupply: number;
  formaEmissionRate: number;
  totalMarketCap: number;
  orderBook: UIOrderBookEntry[];
  auctionLots: UIAuctionLot[];
}

/**
 * Convert internal MarketAsset to UI-compatible Asset format
 */
export function toUIAsset(
  asset: MarketAsset,
  priceHistory: number[] = [],
): UIAsset {
  return {
    id: asset.id,
    name: asset.name,
    symbol: asset.name.substring(0, 4).toUpperCase(),
    price: asset.currentPrice,
    priceHistory,
    volume24h: asset.demand * asset.currentPrice,
    change24h: ((asset.currentPrice - asset.baseValue) / asset.baseValue) * 100,
    totalSupply: asset.supply,
  };
}

/**
 * Convert internal TradeRoute to UI-compatible format
 */
export function toUITradeRoute(route: TradeRoute): UITradeRoute {
  return {
    id: route.id,
    from: route.fromId,
    to: route.toId,
    commodities: route.commodities.map((c) => c.assetId),
    profitMargin: route.profitMargin * 100,
    disrupted: route.disrupted,
    disruptionReason: route.disruptionCause,
    activeCarriers: route.active ? 1 : 0,
    distanceUnits: 10, // Default distance
  };
}

/**
 * Convert internal AuctionLot to UI-compatible format
 */
export function toUIAuctionLot(lot: AuctionLot): UIAuctionLot {
  return {
    id: lot.id,
    name: lot.assetName,
    currentBid: lot.currentBid,
    endsAtTick: lot.closeTick,
    category: "artifact", // Default category
  };
}

/**
 * Convert internal MarketSnapshot to UI-compatible format
 */
export function toUIMarketSnapshot(
  snapshot: MarketSnapshot,
  orderBook: MarketOrder[],
  auctions: AuctionLot[],
): UIMarketSnapshot {
  const sentimentMap: Record<
    MarketSnapshot["marketSentiment"],
    UIMarketSentiment
  > = {
    bull: "Bull",
    bear: "Bear",
    volatile: "Volatile",
    frozen: "Frozen",
  };

  return {
    sentiment: sentimentMap[snapshot.marketSentiment],
    formaSupply: FORMA_TOTAL_SUPPLY,
    formaEmissionRate: FORMA_INITIAL_EMISSION_RATE,
    totalMarketCap: snapshot.totalLiquidity,
    orderBook: orderBook.map((order) => ({
      price: order.pricePerUnit,
      quantity: order.quantity,
      side: order.type === "buy" ? "bid" : "ask",
    })),
    auctionLots: auctions.map(toUIAuctionLot),
  };
}
