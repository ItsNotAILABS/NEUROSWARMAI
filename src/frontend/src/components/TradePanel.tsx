import React, { useState, useMemo } from "react";

// ── Import types from economyEngine — wired to the actual economy simulation ──
import type {
  UIAsset as Asset,
  UIAuctionLot as AuctionLot,
  UIMarketSentiment as MarketSentiment,
  UIMarketSnapshot as MarketSnapshot,
  UIOrderBookEntry as OrderBookEntry,
  UITradeRoute as TradeRoute,
} from "../data/economyEngine";

// Re-export types for consumers
export type {
  MarketSentiment,
  Asset,
  OrderBookEntry,
  TradeRoute,
  AuctionLot,
  MarketSnapshot,
};

export interface TradePanelProps {
  assets: Asset[];
  routes: TradeRoute[];
  snapshot: MarketSnapshot;
  tick: number;
  onBuyAsset: (assetId: string, amount: number) => void;
  onSellAsset: (assetId: string, amount: number) => void;
}

// ── MarketSentimentBadge ─────────────────────────────────────────────────────

const sentimentConfig: Record<
  MarketSentiment,
  { color: string; dot: string; label: string }
> = {
  Bull: {
    color: "text-emerald-400 bg-emerald-900/40 border-emerald-700",
    dot: "bg-emerald-400",
    label: "Bull Market",
  },
  Bear: {
    color: "text-red-400 bg-red-900/40 border-red-700",
    dot: "bg-red-400",
    label: "Bear Market",
  },
  Volatile: {
    color: "text-yellow-400 bg-yellow-900/40 border-yellow-700",
    dot: "bg-yellow-400",
    label: "Volatile",
  },
  Frozen: {
    color: "text-sky-400 bg-sky-900/40 border-sky-700",
    dot: "bg-sky-400",
    label: "Frozen",
  },
};

function MarketSentimentBadge({ sentiment }: { sentiment: MarketSentiment }) {
  const cfg = sentimentConfig[sentiment];
  return (
    <span
      className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full border text-xs font-semibold ${cfg.color}`}
    >
      <span className={`w-2 h-2 rounded-full animate-pulse ${cfg.dot}`} />
      {cfg.label}
    </span>
  );
}

// ── WealthDistributionBar ────────────────────────────────────────────────────

function WealthDistributionBar({ assets }: { assets: Asset[] }) {
  const total = assets.reduce((s, a) => s + a.totalSupply * a.price, 0) || 1;
  const slices = assets.slice(0, 6).map((a) => ({
    name: a.symbol,
    pct: (a.totalSupply * a.price) / total,
    color: `hsl(${(assets.indexOf(a) * 53) % 360},70%,55%)`,
  }));
  let offset = 0;
  return (
    <div className="space-y-1">
      <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
        Wealth Distribution
      </p>
      <div className="flex h-3 rounded-full overflow-hidden w-full bg-zinc-800">
        {slices.map((s) => {
          const _left = offset;
          offset += s.pct * 100;
          return (
            <div
              key={s.name}
              title={`${s.name}: ${(s.pct * 100).toFixed(1)}%`}
              style={{ width: `${s.pct * 100}%`, backgroundColor: s.color }}
            />
          );
        })}
      </div>
      <div className="flex flex-wrap gap-x-3 gap-y-0.5">
        {slices.map((s, _i) => (
          <span
            key={s.name}
            className="text-xs text-zinc-400 flex items-center gap-1"
          >
            <span
              className="w-2 h-2 rounded-sm inline-block"
              style={{ backgroundColor: s.color }}
            />
            {s.name} {(s.pct * 100).toFixed(1)}%
          </span>
        ))}
      </div>
    </div>
  );
}

// ── Sparkline (SVG polyline) ─────────────────────────────────────────────────

function Sparkline({
  data,
  color = "#34d399",
  width = 80,
  height = 28,
}: { data: number[]; color?: string; width?: number; height?: number }) {
  if (!data || data.length < 2)
    return <span className="text-zinc-600 text-xs">—</span>;
  const min = Math.min(...data);
  const max = Math.max(...data);
  const range = max - min || 1;
  const pts = data
    .map((v, i) => {
      const x = (i / (data.length - 1)) * width;
      const y = height - ((v - min) / range) * height;
      return `${x},${y}`;
    })
    .join(" ");
  return (
    <svg
      width={width}
      height={height}
      viewBox={`0 0 ${width} ${height}`}
      className="overflow-visible"
      aria-label="Trade sparkline chart"
      role="img"
    >
      <polyline
        points={pts}
        fill="none"
        stroke={color}
        strokeWidth="1.5"
        strokeLinejoin="round"
        strokeLinecap="round"
      />
    </svg>
  );
}

// ── AssetPriceRow ────────────────────────────────────────────────────────────

function AssetPriceRow({
  asset,
  onBuy,
  onSell,
}: {
  asset: Asset;
  onBuy: (id: string, amt: number) => void;
  onSell: (id: string, amt: number) => void;
}) {
  const up = asset.change24h >= 0;
  const changeColor = up ? "text-emerald-400" : "text-red-400";
  const sparkColor = up ? "#34d399" : "#f87171";
  return (
    <div className="flex items-center gap-3 px-3 py-2 rounded-lg bg-zinc-800/50 hover:bg-zinc-800 transition-colors group">
      <div className="w-8 h-8 rounded-full flex items-center justify-center bg-zinc-700 text-xs font-bold text-zinc-200 shrink-0">
        {asset.symbol.slice(0, 2)}
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-sm font-semibold text-zinc-100 truncate">
          {asset.name}
        </p>
        <p className="text-xs text-zinc-500">{asset.symbol}</p>
      </div>
      <div className="hidden sm:block">
        <Sparkline data={asset.priceHistory} color={sparkColor} />
      </div>
      <div className="text-right shrink-0">
        <p className="text-sm font-mono font-semibold text-zinc-100">
          {asset.price.toFixed(4)}
        </p>
        <p className={`text-xs font-mono ${changeColor}`}>
          {up ? "+" : ""}
          {asset.change24h.toFixed(2)}%
        </p>
      </div>
      <div className="flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
        <button
          type="button"
          onClick={() => onBuy(asset.id, 1)}
          className="px-2 py-0.5 text-xs rounded bg-emerald-700 hover:bg-emerald-600 text-white font-semibold"
        >
          Buy
        </button>
        <button
          type="button"
          onClick={() => onSell(asset.id, 1)}
          className="px-2 py-0.5 text-xs rounded bg-red-700 hover:bg-red-600 text-white font-semibold"
        >
          Sell
        </button>
      </div>
    </div>
  );
}

// ── OrderBookDepth ───────────────────────────────────────────────────────────

function OrderBookDepth({ entries }: { entries: OrderBookEntry[] }) {
  const bids = entries.filter((e) => e.side === "bid").slice(0, 5);
  const asks = entries.filter((e) => e.side === "ask").slice(0, 5);
  const maxQty = Math.max(...entries.map((e) => e.quantity), 1);
  return (
    <div className="space-y-2">
      <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
        Order Book
      </p>
      <div className="grid grid-cols-2 gap-2">
        <div className="space-y-0.5">
          <p className="text-xs text-emerald-400 font-semibold mb-1">Bids</p>
          {bids.map((b) => (
            <div
              key={`bid-${b.price}`}
              className="relative flex justify-between text-xs px-1 py-0.5 rounded overflow-hidden"
            >
              <div
                className="absolute inset-y-0 left-0 bg-emerald-900/30 rounded"
                style={{ width: `${(b.quantity / maxQty) * 100}%` }}
              />
              <span className="relative text-emerald-300 font-mono">
                {b.price.toFixed(3)}
              </span>
              <span className="relative text-zinc-400 font-mono">
                {b.quantity.toFixed(2)}
              </span>
            </div>
          ))}
        </div>
        <div className="space-y-0.5">
          <p className="text-xs text-red-400 font-semibold mb-1">Asks</p>
          {asks.map((a) => (
            <div
              key={`ask-${a.price}`}
              className="relative flex justify-between text-xs px-1 py-0.5 rounded overflow-hidden"
            >
              <div
                className="absolute inset-y-0 right-0 bg-red-900/30 rounded"
                style={{ width: `${(a.quantity / maxQty) * 100}%` }}
              />
              <span className="relative text-red-300 font-mono">
                {a.price.toFixed(3)}
              </span>
              <span className="relative text-zinc-400 font-mono">
                {a.quantity.toFixed(2)}
              </span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ── TradeRouteCard ───────────────────────────────────────────────────────────

function TradeRouteCard({ route }: { route: TradeRoute }) {
  return (
    <div
      className={`rounded-lg border px-3 py-2.5 space-y-1.5 ${route.disrupted ? "border-red-700 bg-red-900/10" : "border-zinc-700 bg-zinc-800/40"}`}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2 text-sm font-semibold text-zinc-100">
          <span>{route.from}</span>
          <span className="text-zinc-500">→</span>
          <span>{route.to}</span>
        </div>
        <div className="flex items-center gap-2">
          {route.disrupted && (
            <span className="text-xs text-red-400 bg-red-900/40 border border-red-700 px-1.5 py-0.5 rounded-full font-medium">
              ⚠ Disrupted
            </span>
          )}
          <span
            className={`text-xs font-mono font-semibold ${route.profitMargin >= 0 ? "text-emerald-400" : "text-red-400"}`}
          >
            {route.profitMargin >= 0 ? "+" : ""}
            {route.profitMargin.toFixed(1)}%
          </span>
        </div>
      </div>
      <div className="flex flex-wrap gap-1">
        {route.commodities.map((c) => (
          <span
            key={c}
            className="text-xs bg-zinc-700 text-zinc-300 px-1.5 py-0.5 rounded"
          >
            {c}
          </span>
        ))}
      </div>
      <div className="flex items-center gap-4 text-xs text-zinc-500">
        <span>🚢 {route.activeCarriers} carriers</span>
        <span>📍 {route.distanceUnits} units</span>
        {route.disruptionReason && (
          <span className="text-red-400">{route.disruptionReason}</span>
        )}
      </div>
    </div>
  );
}

// ── AuctionCountdown ─────────────────────────────────────────────────────────

function AuctionCountdown({
  lots,
  tick,
}: { lots: AuctionLot[]; tick: number }) {
  return (
    <div className="space-y-2">
      <p className="text-xs text-zinc-400 font-medium uppercase tracking-wider">
        Live Auctions
      </p>
      {lots.length === 0 && (
        <p className="text-xs text-zinc-600">No active auctions</p>
      )}
      {lots.map((lot) => {
        const remaining = lot.endsAtTick - tick;
        const urgent = remaining < 20;
        return (
          <div
            key={lot.id}
            className="flex items-center justify-between rounded-lg bg-zinc-800/50 px-3 py-2 gap-2"
          >
            <div className="flex-1 min-w-0">
              <p className="text-xs font-semibold text-zinc-200 truncate">
                {lot.name}
              </p>
              <p className="text-xs text-zinc-500">{lot.category}</p>
            </div>
            <div className="text-right shrink-0">
              <p className="text-xs font-mono text-amber-400 font-semibold">
                {lot.currentBid.toFixed(2)} FORMA
              </p>
              <p
                className={`text-xs font-mono ${urgent ? "text-red-400 animate-pulse" : "text-zinc-500"}`}
              >
                {remaining > 0 ? `${remaining} ticks` : "ENDED"}
              </p>
            </div>
          </div>
        );
      })}
    </div>
  );
}

// ── FORMA Supply Panel ───────────────────────────────────────────────────────

function FormaSupplyPanel({
  supply,
  emissionRate,
}: { supply: number; emissionRate: number }) {
  return (
    <div className="rounded-lg border border-violet-800 bg-violet-900/10 px-4 py-3 space-y-2">
      <div className="flex items-center justify-between">
        <p className="text-xs font-semibold text-violet-300 uppercase tracking-wider">
          FORMA Token
        </p>
        <span className="text-xs text-violet-400 bg-violet-900/40 border border-violet-700 px-1.5 py-0.5 rounded-full">
          Native Currency
        </span>
      </div>
      <div className="grid grid-cols-2 gap-3">
        <div>
          <p className="text-xs text-zinc-500">Total Supply</p>
          <p className="text-lg font-mono font-bold text-violet-300">
            {supply.toLocaleString()}
          </p>
        </div>
        <div>
          <p className="text-xs text-zinc-500">Emission Rate</p>
          <p className="text-lg font-mono font-bold text-violet-300">
            {emissionRate.toFixed(2)}
            <span className="text-xs text-zinc-500 ml-1">/tick</span>
          </p>
        </div>
      </div>
    </div>
  );
}

// ── TradePanel (main) ────────────────────────────────────────────────────────

export function TradePanel({
  assets,
  routes,
  snapshot,
  tick,
  onBuyAsset,
  onSellAsset,
}: TradePanelProps) {
  const [activeTab, setActiveTab] = useState<"assets" | "routes" | "orderbook">(
    "assets",
  );
  const [searchQuery, setSearchQuery] = useState("");

  const filteredAssets = useMemo(
    () =>
      assets.filter(
        (a) =>
          a.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
          a.symbol.toLowerCase().includes(searchQuery.toLowerCase()),
      ),
    [assets, searchQuery],
  );

  const totalMarketCap = assets.reduce(
    (s, a) => s + a.price * a.totalSupply,
    0,
  );

  const tabs: { key: "assets" | "routes" | "orderbook"; label: string }[] = [
    { key: "assets", label: "Assets" },
    { key: "routes", label: "Routes" },
    { key: "orderbook", label: "Order Book" },
  ];

  return (
    <div className="h-full flex flex-col bg-zinc-900 text-zinc-100 rounded-xl border border-zinc-800 overflow-hidden">
      {/* Header */}
      <div className="px-4 pt-4 pb-3 border-b border-zinc-800 space-y-3">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-base font-bold text-zinc-100 tracking-tight">
              Trade Nexus
            </h2>
            <p className="text-xs text-zinc-500">
              Tick #{tick.toLocaleString()}
            </p>
          </div>
          <MarketSentimentBadge sentiment={snapshot.sentiment} />
        </div>
        <div className="grid grid-cols-3 gap-2 text-center">
          {[
            {
              label: "Market Cap",
              value: `${(totalMarketCap / 1_000_000).toFixed(2)}M`,
            },
            { label: "Assets", value: assets.length },
            { label: "Routes", value: routes.length },
          ].map((stat) => (
            <div
              key={stat.label}
              className="rounded-lg bg-zinc-800/60 px-2 py-1.5"
            >
              <p className="text-xs text-zinc-500">{stat.label}</p>
              <p className="text-sm font-mono font-bold text-zinc-200">
                {stat.value}
              </p>
            </div>
          ))}
        </div>
        <WealthDistributionBar assets={assets} />
      </div>

      {/* FORMA supply */}
      <div className="px-4 py-3 border-b border-zinc-800">
        <FormaSupplyPanel
          supply={snapshot.formaSupply}
          emissionRate={snapshot.formaEmissionRate}
        />
      </div>

      {/* Tabs */}
      <div className="flex border-b border-zinc-800">
        {tabs.map((t) => (
          <button
            type="button"
            key={t.key}
            onClick={() => setActiveTab(t.key)}
            className={`flex-1 py-2 text-xs font-semibold transition-colors ${
              activeTab === t.key
                ? "text-violet-300 border-b-2 border-violet-500 bg-violet-900/10"
                : "text-zinc-500 hover:text-zinc-300"
            }`}
          >
            {t.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto px-4 py-3 space-y-3">
        {activeTab === "assets" && (
          <>
            <input
              type="text"
              placeholder="Search assets…"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-zinc-800 border border-zinc-700 rounded-lg px-3 py-1.5 text-sm text-zinc-100 placeholder-zinc-500 focus:outline-none focus:border-violet-600"
            />
            <div className="space-y-1.5">
              {filteredAssets.map((asset) => (
                <AssetPriceRow
                  key={asset.id}
                  asset={asset}
                  onBuy={onBuyAsset}
                  onSell={onSellAsset}
                />
              ))}
              {filteredAssets.length === 0 && (
                <p className="text-xs text-zinc-600 text-center py-6">
                  No assets match "{searchQuery}"
                </p>
              )}
            </div>
          </>
        )}

        {activeTab === "routes" && (
          <div className="space-y-2">
            {routes.length === 0 && (
              <p className="text-xs text-zinc-600 text-center py-6">
                No trade routes active
              </p>
            )}
            {routes.map((r) => (
              <TradeRouteCard key={r.id} route={r} />
            ))}
          </div>
        )}

        {activeTab === "orderbook" && (
          <div className="space-y-4">
            <OrderBookDepth entries={snapshot.orderBook} />
            <AuctionCountdown lots={snapshot.auctionLots} tick={tick} />
          </div>
        )}
      </div>
    </div>
  );
}

export default TradePanel;
