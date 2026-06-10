// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  FINANCE DASHBOARD — TREASURY, P&L, BALANCE SHEET, TOKEN ECONOMICS                                       ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
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
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  ArrowDown,
  ArrowUp,
  BarChart3,
  Briefcase,
  Calendar,
  Coins,
  CreditCard,
  DollarSign,
  FileText,
  Landmark,
  LineChart,
  Lock,
  PieChart,
  Receipt,
  Sparkles,
  TrendingDown,
  TrendingUp,
  Users,
  Wallet,
} from "lucide-react";
import { useEffect, useState } from "react";

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

interface FinanceDashboardProps {
  className?: string;
}

interface TokenBalance {
  symbol: string;
  name: string;
  balance: number;
  value: number;
  change24h: number;
  staked: number;
  vesting: number;
}

interface RevenueStream {
  source: string;
  amount: number;
  type: "Task" | "Document" | "Subscription" | "Fee" | "Trade";
  timestamp: number;
  architectShare: number;
  playerShare: number;
}

interface Expense {
  category: string;
  description: string;
  amount: number;
  timestamp: number;
  paidTo: string;
}

interface BalanceSheetItem {
  category: string;
  items: { name: string; value: number; type: "asset" | "liability" }[];
}

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

const MOCK_TOKENS: TokenBalance[] = [
  { symbol: "FORMA", name: "Core Utility Token", balance: 2500000, value: 2500000, change24h: 5.2, staked: 750000, vesting: 250000 },
  { symbol: "SEED", name: "Genesis Creation Token", balance: 500000, value: 2500000, change24h: 12.5, staked: 100000, vesting: 50000 },
  { symbol: "GTK", name: "Governance Token", balance: 1000000, value: 500000, change24h: -2.1, staked: 500000, vesting: 100000 },
  { symbol: "CVT", name: "Contribution Value", balance: 250000, value: 125000, change24h: 8.3, staked: 50000, vesting: 25000 },
  { symbol: "VCT", name: "Velocity Contribution", balance: 180000, value: 90000, change24h: 3.7, staked: 30000, vesting: 20000 },
  { symbol: "KNT", name: "Knowledge Token", balance: 450000, value: 225000, change24h: 6.8, staked: 100000, vesting: 50000 },
  { symbol: "SBT", name: "Soul-Bound Token", balance: 75000, value: 37500, change24h: 0, staked: 0, vesting: 0 },
  { symbol: "HBT", name: "Heritage Bond", balance: 320000, value: 160000, change24h: 1.5, staked: 200000, vesting: 80000 },
  { symbol: "DRT", name: "Doctrine Respect", balance: 125000, value: 62500, change24h: 4.2, staked: 50000, vesting: 25000 },
  { symbol: "OMT", name: "OMNIS Multiplier", balance: 50000, value: 250000, change24h: 15.8, staked: 25000, vesting: 10000 },
];

const MOCK_REVENUE: RevenueStream[] = [
  { source: "Enterprise Platform Subscription", amount: 250000, type: "Subscription", timestamp: Date.now() - 86400000, architectShare: 25000, playerShare: 225000 },
  { source: "Document Generation - Contract Pack", amount: 15000, type: "Document", timestamp: Date.now() - 172800000, architectShare: 1500, playerShare: 13500 },
  { source: "FORGE-X Development Tasks", amount: 85000, type: "Task", timestamp: Date.now() - 259200000, architectShare: 8500, playerShare: 76500 },
  { source: "Marketplace Transaction Fees", amount: 12500, type: "Fee", timestamp: Date.now() - 345600000, architectShare: 1250, playerShare: 11250 },
  { source: "Organism Trading Volume", amount: 45000, type: "Trade", timestamp: Date.now() - 432000000, architectShare: 4500, playerShare: 40500 },
];

const MOCK_BALANCE_SHEET: BalanceSheetItem[] = [
  {
    category: "Current Assets",
    items: [
      { name: "Token Holdings", value: 5950000, type: "asset" },
      { name: "Staked Assets", value: 1805000, type: "asset" },
      { name: "Accounts Receivable", value: 450000, type: "asset" },
      { name: "Pending Revenue", value: 125000, type: "asset" },
    ],
  },
  {
    category: "Fixed Assets",
    items: [
      { name: "Organism IP Value", value: 2500000, type: "asset" },
      { name: "Platform Infrastructure", value: 1500000, type: "asset" },
      { name: "Genesis Hash Value", value: 1000000, type: "asset" },
    ],
  },
  {
    category: "Current Liabilities",
    items: [
      { name: "Pending Payroll", value: 175000, type: "liability" },
      { name: "Vesting Obligations", value: 610000, type: "liability" },
      { name: "Subscription Prepayments", value: 85000, type: "liability" },
    ],
  },
  {
    category: "Long-term Liabilities",
    items: [
      { name: "Future Token Distributions", value: 500000, type: "liability" },
      { name: "Heritage Obligations", value: 250000, type: "liability" },
    ],
  },
];

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// COMPONENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

export function FinanceDashboard({ className = "" }: FinanceDashboardProps) {
  const [tokens, setTokens] = useState<TokenBalance[]>(MOCK_TOKENS);
  const [revenue, setRevenue] = useState<RevenueStream[]>(MOCK_REVENUE);
  const [activeTab, setActiveTab] = useState("treasury");

  // Calculate totals
  const totalTokenValue = tokens.reduce((sum, t) => sum + t.value, 0);
  const totalStaked = tokens.reduce((sum, t) => sum + t.staked, 0);
  const totalVesting = tokens.reduce((sum, t) => sum + t.vesting, 0);
  const totalRevenue = revenue.reduce((sum, r) => sum + r.amount, 0);
  const totalArchitectShare = revenue.reduce((sum, r) => sum + r.architectShare, 0);
  const totalPlayerShare = revenue.reduce((sum, r) => sum + r.playerShare, 0);

  // Calculate balance sheet totals
  const totalAssets = MOCK_BALANCE_SHEET
    .flatMap(c => c.items)
    .filter(i => i.type === "asset")
    .reduce((sum, i) => sum + i.value, 0);
  
  const totalLiabilities = MOCK_BALANCE_SHEET
    .flatMap(c => c.items)
    .filter(i => i.type === "liability")
    .reduce((sum, i) => sum + i.value, 0);
  
  const netWorth = totalAssets - totalLiabilities;

  return (
    <div className={`min-h-screen bg-zinc-950 text-zinc-100 p-6 ${className}`}>
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold flex items-center gap-2">
            <Landmark className="w-6 h-6 text-green-400" />
            Finance Dashboard
          </h1>
          <p className="text-sm text-zinc-400 mt-1">
            Treasury management, P&L analysis, and token economics
          </p>
        </div>
        <div className="flex items-center gap-4">
          <Badge variant="outline" className="border-green-500/30 text-green-400">
            Net Worth: ${(netWorth / 1000000).toFixed(2)}M
          </Badge>
          <Button variant="outline" size="sm">
            <FileText className="w-4 h-4 mr-2" />
            Export Report
          </Button>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <Card className="bg-black/40 border-green-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Total Portfolio</p>
                <p className="text-2xl font-bold text-green-400">${(totalTokenValue / 1000000).toFixed(2)}M</p>
              </div>
              <Wallet className="w-8 h-8 text-green-400" />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-cyan-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Total Staked</p>
                <p className="text-2xl font-bold text-cyan-400">${(totalStaked / 1000).toFixed(0)}K</p>
              </div>
              <Lock className="w-8 h-8 text-cyan-400" />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-purple-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Total Revenue</p>
                <p className="text-2xl font-bold text-purple-400">${(totalRevenue / 1000).toFixed(0)}K</p>
              </div>
              <TrendingUp className="w-8 h-8 text-purple-400" />
            </div>
          </CardContent>
        </Card>

        <Card className="bg-black/40 border-amber-500/30">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-xs text-zinc-400 uppercase tracking-wider">Architect Share</p>
                <p className="text-2xl font-bold text-amber-400">${(totalArchitectShare / 1000).toFixed(0)}K</p>
              </div>
              <Coins className="w-8 h-8 text-amber-400" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Main Content */}
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="bg-zinc-900 border border-zinc-800">
          <TabsTrigger value="treasury" className="data-[state=active]:bg-zinc-800">
            <Wallet className="w-4 h-4 mr-2" />
            Treasury
          </TabsTrigger>
          <TabsTrigger value="pnl" className="data-[state=active]:bg-zinc-800">
            <BarChart3 className="w-4 h-4 mr-2" />
            P&L
          </TabsTrigger>
          <TabsTrigger value="balance" className="data-[state=active]:bg-zinc-800">
            <Briefcase className="w-4 h-4 mr-2" />
            Balance Sheet
          </TabsTrigger>
          <TabsTrigger value="tokens" className="data-[state=active]:bg-zinc-800">
            <Coins className="w-4 h-4 mr-2" />
            Token Economics
          </TabsTrigger>
        </TabsList>

        {/* Treasury Tab */}
        <TabsContent value="treasury" className="space-y-6">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Token Holdings */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <Coins className="w-5 h-5 text-amber-400" />
                  Token Holdings
                </CardTitle>
                <CardDescription>Multi-token treasury allocation</CardDescription>
              </CardHeader>
              <CardContent>
                <ScrollArea className="h-[400px]">
                  <div className="space-y-3">
                    {tokens.map(token => (
                      <div key={token.symbol} className="p-3 bg-zinc-900 rounded-lg">
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center gap-2">
                            <div className="w-8 h-8 rounded-full bg-gradient-to-br from-amber-500/20 to-orange-600/20 flex items-center justify-center">
                              <span className="text-xs font-bold text-amber-400">{token.symbol.slice(0, 2)}</span>
                            </div>
                            <div>
                              <p className="font-semibold text-zinc-100">{token.symbol}</p>
                              <p className="text-xs text-zinc-500">{token.name}</p>
                            </div>
                          </div>
                          <div className="text-right">
                            <p className="font-semibold text-zinc-100">{token.balance.toLocaleString()}</p>
                            <p className={`text-xs flex items-center justify-end gap-1 ${token.change24h >= 0 ? 'text-green-400' : 'text-red-400'}`}>
                              {token.change24h >= 0 ? <ArrowUp className="w-3 h-3" /> : <ArrowDown className="w-3 h-3" />}
                              {Math.abs(token.change24h).toFixed(1)}%
                            </p>
                          </div>
                        </div>
                        <div className="flex items-center justify-between text-xs text-zinc-400">
                          <span>Staked: {token.staked.toLocaleString()}</span>
                          <span>Vesting: {token.vesting.toLocaleString()}</span>
                          <span className="text-green-400">${token.value.toLocaleString()}</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </CardContent>
            </Card>

            {/* Revenue Streams */}
            <Card className="bg-black/40 border-zinc-800">
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-lg">
                  <TrendingUp className="w-5 h-5 text-green-400" />
                  Revenue Streams
                </CardTitle>
                <CardDescription>Recent revenue with 10/90 split</CardDescription>
              </CardHeader>
              <CardContent>
                <ScrollArea className="h-[400px]">
                  <div className="space-y-3">
                    {revenue.map((r, idx) => (
                      <div key={idx} className="p-3 bg-zinc-900 rounded-lg">
                        <div className="flex items-center justify-between mb-2">
                          <div>
                            <p className="font-semibold text-zinc-100">{r.source}</p>
                            <Badge variant="outline" className="text-xs mt-1">
                              {r.type}
                            </Badge>
                          </div>
                          <p className="text-lg font-bold text-green-400">
                            ${r.amount.toLocaleString()}
                          </p>
                        </div>
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-amber-400">Architect: ${r.architectShare.toLocaleString()}</span>
                          <span className="text-green-400">Players: ${r.playerShare.toLocaleString()}</span>
                        </div>
                        <Progress value={90} className="h-1 mt-2" />
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* P&L Tab */}
        <TabsContent value="pnl" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <Card className="bg-green-500/10 border-green-500/30">
              <CardContent className="p-4 text-center">
                <p className="text-sm text-zinc-400">Total Revenue</p>
                <p className="text-3xl font-bold text-green-400">${(totalRevenue / 1000).toFixed(0)}K</p>
              </CardContent>
            </Card>
            <Card className="bg-red-500/10 border-red-500/30">
              <CardContent className="p-4 text-center">
                <p className="text-sm text-zinc-400">Total Expenses</p>
                <p className="text-3xl font-bold text-red-400">$175K</p>
              </CardContent>
            </Card>
            <Card className="bg-cyan-500/10 border-cyan-500/30">
              <CardContent className="p-4 text-center">
                <p className="text-sm text-zinc-400">Net Profit</p>
                <p className="text-3xl font-bold text-cyan-400">${((totalRevenue - 175000) / 1000).toFixed(0)}K</p>
              </CardContent>
            </Card>
          </div>

          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle>Profit & Loss Statement</CardTitle>
              <CardDescription>Current period financial performance</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="space-y-2">
                  <h3 className="text-sm font-semibold text-green-400 uppercase tracking-wider">Revenue</h3>
                  {revenue.map((r, idx) => (
                    <div key={idx} className="flex items-center justify-between p-2 bg-zinc-900/50 rounded">
                      <span className="text-zinc-300">{r.source}</span>
                      <span className="text-green-400">${r.amount.toLocaleString()}</span>
                    </div>
                  ))}
                  <div className="flex items-center justify-between p-2 bg-green-500/10 rounded font-semibold">
                    <span className="text-green-400">Total Revenue</span>
                    <span className="text-green-400">${totalRevenue.toLocaleString()}</span>
                  </div>
                </div>

                <Separator className="bg-zinc-800" />

                <div className="space-y-2">
                  <h3 className="text-sm font-semibold text-red-400 uppercase tracking-wider">Expenses</h3>
                  <div className="flex items-center justify-between p-2 bg-zinc-900/50 rounded">
                    <span className="text-zinc-300">Organism Payroll</span>
                    <span className="text-red-400">$120,000</span>
                  </div>
                  <div className="flex items-center justify-between p-2 bg-zinc-900/50 rounded">
                    <span className="text-zinc-300">Infrastructure Costs</span>
                    <span className="text-red-400">$35,000</span>
                  </div>
                  <div className="flex items-center justify-between p-2 bg-zinc-900/50 rounded">
                    <span className="text-zinc-300">Operations</span>
                    <span className="text-red-400">$20,000</span>
                  </div>
                  <div className="flex items-center justify-between p-2 bg-red-500/10 rounded font-semibold">
                    <span className="text-red-400">Total Expenses</span>
                    <span className="text-red-400">$175,000</span>
                  </div>
                </div>

                <Separator className="bg-zinc-800" />

                <div className="flex items-center justify-between p-3 bg-cyan-500/10 rounded-lg border border-cyan-500/30">
                  <span className="text-lg font-bold text-cyan-400">Net Profit</span>
                  <span className="text-2xl font-bold text-cyan-400">${(totalRevenue - 175000).toLocaleString()}</span>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Balance Sheet Tab */}
        <TabsContent value="balance" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <Card className="bg-green-500/10 border-green-500/30">
              <CardContent className="p-4 text-center">
                <p className="text-sm text-zinc-400">Total Assets</p>
                <p className="text-3xl font-bold text-green-400">${(totalAssets / 1000000).toFixed(2)}M</p>
              </CardContent>
            </Card>
            <Card className="bg-red-500/10 border-red-500/30">
              <CardContent className="p-4 text-center">
                <p className="text-sm text-zinc-400">Total Liabilities</p>
                <p className="text-3xl font-bold text-red-400">${(totalLiabilities / 1000000).toFixed(2)}M</p>
              </CardContent>
            </Card>
            <Card className="bg-cyan-500/10 border-cyan-500/30">
              <CardContent className="p-4 text-center">
                <p className="text-sm text-zinc-400">Net Worth</p>
                <p className="text-3xl font-bold text-cyan-400">${(netWorth / 1000000).toFixed(2)}M</p>
              </CardContent>
            </Card>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {MOCK_BALANCE_SHEET.map((category, idx) => (
              <Card key={idx} className="bg-black/40 border-zinc-800">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2 text-lg">
                    {category.items[0].type === "asset" ? (
                      <TrendingUp className="w-5 h-5 text-green-400" />
                    ) : (
                      <TrendingDown className="w-5 h-5 text-red-400" />
                    )}
                    {category.category}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    {category.items.map((item, itemIdx) => (
                      <div key={itemIdx} className="flex items-center justify-between p-2 bg-zinc-900/50 rounded">
                        <span className="text-zinc-300">{item.name}</span>
                        <span className={item.type === "asset" ? "text-green-400" : "text-red-400"}>
                          ${item.value.toLocaleString()}
                        </span>
                      </div>
                    ))}
                    <div className={`flex items-center justify-between p-2 rounded font-semibold ${
                      category.items[0].type === "asset" ? "bg-green-500/10" : "bg-red-500/10"
                    }`}>
                      <span className={category.items[0].type === "asset" ? "text-green-400" : "text-red-400"}>
                        Subtotal
                      </span>
                      <span className={category.items[0].type === "asset" ? "text-green-400" : "text-red-400"}>
                        ${category.items.reduce((sum, i) => sum + i.value, 0).toLocaleString()}
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </TabsContent>

        {/* Token Economics Tab */}
        <TabsContent value="tokens" className="space-y-6">
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
            {tokens.slice(0, 5).map(token => (
              <Card key={token.symbol} className="bg-black/40 border-zinc-800">
                <CardContent className="p-4 text-center">
                  <div className="w-12 h-12 mx-auto rounded-full bg-gradient-to-br from-amber-500/20 to-orange-600/20 flex items-center justify-center mb-2">
                    <span className="text-sm font-bold text-amber-400">{token.symbol}</span>
                  </div>
                  <p className="font-semibold text-zinc-100">{token.balance.toLocaleString()}</p>
                  <p className={`text-xs ${token.change24h >= 0 ? 'text-green-400' : 'text-red-400'}`}>
                    {token.change24h >= 0 ? '+' : ''}{token.change24h.toFixed(1)}%
                  </p>
                </CardContent>
              </Card>
            ))}
          </div>

          <Card className="bg-black/40 border-zinc-800">
            <CardHeader>
              <CardTitle>Token Distribution</CardTitle>
              <CardDescription>Allocation across all token types</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-3">
                  {tokens.map(token => {
                    const percentage = (token.value / totalTokenValue) * 100;
                    return (
                      <div key={token.symbol} className="space-y-1">
                        <div className="flex items-center justify-between text-sm">
                          <span className="text-zinc-300">{token.symbol}</span>
                          <span className="text-zinc-400">{percentage.toFixed(1)}%</span>
                        </div>
                        <Progress value={percentage} className="h-2" />
                      </div>
                    );
                  })}
                </div>
                <div className="space-y-4">
                  <div className="p-4 bg-zinc-900 rounded-lg">
                    <p className="text-sm text-zinc-400">Total Circulating</p>
                    <p className="text-2xl font-bold text-amber-400">
                      {tokens.reduce((sum, t) => sum + t.balance, 0).toLocaleString()}
                    </p>
                  </div>
                  <div className="p-4 bg-zinc-900 rounded-lg">
                    <p className="text-sm text-zinc-400">Total Staked</p>
                    <p className="text-2xl font-bold text-cyan-400">
                      {totalStaked.toLocaleString()}
                    </p>
                  </div>
                  <div className="p-4 bg-zinc-900 rounded-lg">
                    <p className="text-sm text-zinc-400">Total Vesting</p>
                    <p className="text-2xl font-bold text-purple-400">
                      {totalVesting.toLocaleString()}
                    </p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}

export default FinanceDashboard;
