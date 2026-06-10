/**
 * TOKEN ECONOMICS CHAOS ENGINE — Blockchain Simulation Testing
 * Nova by FreddyCreates
 * 
 * "Test the markets before they test you."
 * 
 * This engine simulates token economics and blockchain behavior:
 * - Virtual token transactions
 * - Market dynamics (supply/demand)
 * - User behavior modeling
 * - Attack vectors (flash loans, sandwich attacks)
 * - Stress testing tokenomics
 * 
 * Uses Monte Carlo simulations to explore economic edge cases
 * and find vulnerabilities in token systems.
 * 
 * @version 1.0.0
 * @copyright Nova Protocol by FreddyCreates
 */

import { PHI, PHI_INV, GREEK, FIBONACCI_SEQUENCE } from '../engines/greek-mathematics.js';
import { 
  MonteCarloSimulation, 
  DISTRIBUTION, 
  randomFromDistribution, 
  mean, 
  stddev, 
  confidenceInterval 
} from '../simulations/monte-carlo.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

/** Token types */
const TOKEN_TYPE = {
  UTILITY: 'UTILITY',
  GOVERNANCE: 'GOVERNANCE',
  SECURITY: 'SECURITY',
  STABLECOIN: 'STABLECOIN',
  NFT: 'NFT',
  LP: 'LP'  // Liquidity Provider
};

/** Transaction types */
const TX_TYPE = {
  TRANSFER: 'TRANSFER',
  MINT: 'MINT',
  BURN: 'BURN',
  STAKE: 'STAKE',
  UNSTAKE: 'UNSTAKE',
  SWAP: 'SWAP',
  PROVIDE_LIQUIDITY: 'PROVIDE_LIQUIDITY',
  REMOVE_LIQUIDITY: 'REMOVE_LIQUIDITY',
  VOTE: 'VOTE',
  CLAIM_REWARDS: 'CLAIM_REWARDS'
};

/** Attack types to simulate */
const ATTACK_TYPE = {
  FLASH_LOAN: 'FLASH_LOAN',
  SANDWICH: 'SANDWICH',
  FRONT_RUN: 'FRONT_RUN',
  WHALE_DUMP: 'WHALE_DUMP',
  SYBIL: 'SYBIL',
  REENTRANCY: 'REENTRANCY',
  ORACLE_MANIPULATION: 'ORACLE_MANIPULATION'
};

/** Market conditions */
const MARKET_CONDITION = {
  BULL: { name: 'Bull Market', multiplier: 1.5, volatility: 0.3 },
  BEAR: { name: 'Bear Market', multiplier: 0.6, volatility: 0.4 },
  STABLE: { name: 'Stable Market', multiplier: 1.0, volatility: 0.1 },
  VOLATILE: { name: 'Volatile Market', multiplier: 1.0, volatility: 0.8 },
  CRASH: { name: 'Market Crash', multiplier: 0.3, volatility: 0.9 }
};

// ═══════════════════════════════════════════════════════════════════════════
// VIRTUAL BLOCKCHAIN
// ═══════════════════════════════════════════════════════════════════════════

/**
 * VirtualBlock — A simulated blockchain block
 */
class VirtualBlock {
  constructor(previousHash, transactions) {
    this.timestamp = Date.now();
    this.transactions = transactions;
    this.previousHash = previousHash;
    this.nonce = 0;
    this.hash = this._calculateHash();
  }
  
  _calculateHash() {
    const data = `${this.timestamp}${this.previousHash}${JSON.stringify(this.transactions)}${this.nonce}`;
    // Simple hash simulation
    let hash = 0;
    for (let i = 0; i < data.length; i++) {
      const char = data.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash;
    }
    return hash.toString(16).padStart(16, '0');
  }
}

/**
 * VirtualBlockchain — Simulated blockchain for testing
 */
export class VirtualBlockchain {
  constructor(config = {}) {
    this.chainId = config.chainId || `CHAIN-${Date.now().toString(36)}`;
    this.chain = [this._createGenesisBlock()];
    this.pendingTransactions = [];
    this.blockTime = config.blockTime || 12000;  // 12 seconds like Ethereum
    this.maxTxPerBlock = config.maxTxPerBlock || 100;
    
    // State
    this.accounts = new Map();
    this.tokens = new Map();
    this.contracts = new Map();
    
    // Metrics
    this.metrics = {
      totalBlocks: 1,
      totalTransactions: 0,
      failedTransactions: 0,
      gasUsed: 0
    };
  }
  
  _createGenesisBlock() {
    return new VirtualBlock('0', [{ type: 'GENESIS', timestamp: Date.now() }]);
  }
  
  /**
   * Create an account
   */
  createAccount(address, initialBalance = 0) {
    this.accounts.set(address, {
      address,
      balance: initialBalance,
      nonce: 0,
      tokens: new Map()
    });
    return this.accounts.get(address);
  }
  
  /**
   * Deploy a token contract
   */
  deployToken(config) {
    const tokenAddress = `TOKEN-${Date.now().toString(36)}`;
    
    const token = {
      address: tokenAddress,
      name: config.name || 'Token',
      symbol: config.symbol || 'TKN',
      type: config.type || TOKEN_TYPE.UTILITY,
      totalSupply: config.initialSupply || 1000000,
      decimals: config.decimals || 18,
      maxSupply: config.maxSupply || Infinity,
      owner: config.owner,
      
      // Economics
      burnRate: config.burnRate || 0,
      mintRate: config.mintRate || 0,
      stakingReward: config.stakingReward || 0,
      
      // State
      holders: new Map(),
      staked: new Map(),
      
      // Metrics
      transfers: 0,
      burns: 0,
      mints: 0
    };
    
    // Allocate initial supply to owner
    if (config.owner) {
      token.holders.set(config.owner, config.initialSupply || 1000000);
    }
    
    this.tokens.set(tokenAddress, token);
    
    return token;
  }
  
  /**
   * Execute a transaction
   */
  executeTransaction(tx) {
    this.metrics.totalTransactions++;
    
    const result = {
      txHash: `TX-${Date.now().toString(36)}-${Math.random().toString(36).substr(2, 9)}`,
      success: true,
      gasUsed: 21000,  // Base gas
      timestamp: Date.now()
    };
    
    try {
      switch (tx.type) {
        case TX_TYPE.TRANSFER:
          this._executeTransfer(tx);
          result.gasUsed += 5000;
          break;
        
        case TX_TYPE.MINT:
          this._executeMint(tx);
          result.gasUsed += 10000;
          break;
        
        case TX_TYPE.BURN:
          this._executeBurn(tx);
          result.gasUsed += 8000;
          break;
        
        case TX_TYPE.STAKE:
          this._executeStake(tx);
          result.gasUsed += 15000;
          break;
        
        case TX_TYPE.SWAP:
          this._executeSwap(tx);
          result.gasUsed += 50000;
          break;
        
        default:
          result.gasUsed += 5000;
      }
      
      this.metrics.gasUsed += result.gasUsed;
      
    } catch (error) {
      result.success = false;
      result.error = error.message;
      this.metrics.failedTransactions++;
    }
    
    this.pendingTransactions.push({ ...tx, result });
    
    return result;
  }
  
  _executeTransfer(tx) {
    const token = this.tokens.get(tx.token);
    if (!token) throw new Error('Token not found');
    
    const fromBalance = token.holders.get(tx.from) || 0;
    if (fromBalance < tx.amount) throw new Error('Insufficient balance');
    
    // Apply burn rate
    const burnAmount = tx.amount * token.burnRate;
    const transferAmount = tx.amount - burnAmount;
    
    token.holders.set(tx.from, fromBalance - tx.amount);
    token.holders.set(tx.to, (token.holders.get(tx.to) || 0) + transferAmount);
    
    if (burnAmount > 0) {
      token.totalSupply -= burnAmount;
      token.burns++;
    }
    
    token.transfers++;
  }
  
  _executeMint(tx) {
    const token = this.tokens.get(tx.token);
    if (!token) throw new Error('Token not found');
    if (tx.from !== token.owner) throw new Error('Not authorized to mint');
    if (token.totalSupply + tx.amount > token.maxSupply) throw new Error('Max supply exceeded');
    
    token.holders.set(tx.to, (token.holders.get(tx.to) || 0) + tx.amount);
    token.totalSupply += tx.amount;
    token.mints++;
  }
  
  _executeBurn(tx) {
    const token = this.tokens.get(tx.token);
    if (!token) throw new Error('Token not found');
    
    const balance = token.holders.get(tx.from) || 0;
    if (balance < tx.amount) throw new Error('Insufficient balance');
    
    token.holders.set(tx.from, balance - tx.amount);
    token.totalSupply -= tx.amount;
    token.burns++;
  }
  
  _executeStake(tx) {
    const token = this.tokens.get(tx.token);
    if (!token) throw new Error('Token not found');
    
    const balance = token.holders.get(tx.from) || 0;
    if (balance < tx.amount) throw new Error('Insufficient balance');
    
    token.holders.set(tx.from, balance - tx.amount);
    token.staked.set(tx.from, (token.staked.get(tx.from) || 0) + tx.amount);
  }
  
  _executeSwap(tx) {
    // Simplified AMM swap
    const tokenIn = this.tokens.get(tx.tokenIn);
    const tokenOut = this.tokens.get(tx.tokenOut);
    
    if (!tokenIn || !tokenOut) throw new Error('Token not found');
    
    const balanceIn = tokenIn.holders.get(tx.from) || 0;
    if (balanceIn < tx.amountIn) throw new Error('Insufficient balance');
    
    // Constant product formula: x * y = k
    // Simplified: amountOut = (reserveOut * amountIn) / (reserveIn + amountIn)
    const reserveIn = tokenIn.totalSupply * 0.1;  // 10% in liquidity pool
    const reserveOut = tokenOut.totalSupply * 0.1;
    
    const amountOut = (reserveOut * tx.amountIn) / (reserveIn + tx.amountIn);
    
    if (amountOut < tx.minAmountOut) throw new Error('Slippage exceeded');
    
    tokenIn.holders.set(tx.from, balanceIn - tx.amountIn);
    tokenOut.holders.set(tx.from, (tokenOut.holders.get(tx.from) || 0) + amountOut);
  }
  
  /**
   * Mine a new block
   */
  mineBlock() {
    const transactions = this.pendingTransactions.splice(0, this.maxTxPerBlock);
    
    if (transactions.length === 0) return null;
    
    const previousBlock = this.chain[this.chain.length - 1];
    const newBlock = new VirtualBlock(previousBlock.hash, transactions);
    
    this.chain.push(newBlock);
    this.metrics.totalBlocks++;
    
    return newBlock;
  }
  
  getState() {
    return {
      chainId: this.chainId,
      blockHeight: this.chain.length,
      pendingTx: this.pendingTransactions.length,
      accounts: this.accounts.size,
      tokens: this.tokens.size,
      metrics: { ...this.metrics }
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// VIRTUAL USER (ECONOMIC AGENT)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * VirtualTrader — Simulated market participant
 */
export class VirtualTrader {
  constructor(config = {}) {
    this.address = config.address || `TRADER-${Date.now().toString(36)}`;
    
    // Behavioral parameters
    this.riskTolerance = config.riskTolerance || randomFromDistribution(DISTRIBUTION.BETA, { a: 2, b: 3 });
    this.tradingFrequency = config.tradingFrequency || randomFromDistribution(DISTRIBUTION.EXPONENTIAL, { lambda: 0.1 });
    this.holdingPeriod = config.holdingPeriod || randomFromDistribution(DISTRIBUTION.EXPONENTIAL, { lambda: 0.01 });
    
    // Trader type
    this.type = config.type || this._determineType();
    
    // Portfolio
    this.portfolio = new Map();
    this.transactions = [];
    
    // State
    this.sentiment = 0.5;  // 0 = bearish, 1 = bullish
    this.lastAction = null;
  }
  
  _determineType() {
    const r = Math.random();
    if (r < 0.1) return 'WHALE';        // 10% whales
    if (r < 0.3) return 'INSTITUTIONAL';// 20% institutional
    if (r < 0.7) return 'RETAIL';       // 40% retail
    return 'BOT';                        // 30% bots
  }
  
  /**
   * Decide on an action based on market conditions
   */
  decideAction(marketCondition, tokenPrice, portfolio) {
    // Update sentiment based on market
    this.sentiment = this.sentiment * 0.9 + (marketCondition.multiplier > 1 ? 0.7 : 0.3) * 0.1;
    
    // Trading decision based on type
    const action = {
      type: null,
      amount: 0,
      reason: null
    };
    
    switch (this.type) {
      case 'WHALE':
        // Whales move markets
        if (this.sentiment > 0.7 && Math.random() < 0.3) {
          action.type = 'BUY';
          action.amount = portfolio.balance * 0.3 * this.riskTolerance;
          action.reason = 'accumulation';
        } else if (this.sentiment < 0.3 && Math.random() < 0.4) {
          action.type = 'SELL';
          action.amount = portfolio.tokens * 0.5;
          action.reason = 'distribution';
        }
        break;
      
      case 'INSTITUTIONAL':
        // DCA strategy
        if (Math.random() < this.tradingFrequency) {
          action.type = 'BUY';
          action.amount = portfolio.balance * 0.05;
          action.reason = 'dca';
        }
        break;
      
      case 'RETAIL':
        // FOMO/FUD driven
        if (this.sentiment > 0.8 && Math.random() < 0.5) {
          action.type = 'BUY';
          action.amount = portfolio.balance * this.riskTolerance;
          action.reason = 'fomo';
        } else if (this.sentiment < 0.2 && Math.random() < 0.6) {
          action.type = 'SELL';
          action.amount = portfolio.tokens * 0.8;
          action.reason = 'panic';
        }
        break;
      
      case 'BOT':
        // Arbitrage/MEV
        if (Math.random() < this.tradingFrequency * 10) {
          action.type = Math.random() < 0.5 ? 'BUY' : 'SELL';
          action.amount = portfolio.balance * 0.1;
          action.reason = 'arbitrage';
        }
        break;
    }
    
    this.lastAction = action;
    return action;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TOKEN CHAOS TESTER
// ═══════════════════════════════════════════════════════════════════════════

/**
 * TokenChaosTester — Monte Carlo testing of token economics
 */
export class TokenChaosTester {
  constructor(config = {}) {
    this.testerId = config.testerId || `TOKTEST-${Date.now().toString(36)}`;
    this.blockchain = new VirtualBlockchain(config.blockchain);
    this.simulation = new MonteCarloSimulation({ simulations: config.simulations || 1000 });
    
    // Market state
    this.marketCondition = config.marketCondition || MARKET_CONDITION.STABLE;
    this.priceHistory = [];
    this.basePrice = config.basePrice || 1.0;
    
    // Traders
    this.traders = [];
    
    // Results
    this.testResults = [];
  }
  
  /**
   * Deploy a test token
   */
  deployTestToken(config = {}) {
    return this.blockchain.deployToken({
      name: config.name || 'Test Token',
      symbol: config.symbol || 'TEST',
      type: config.type || TOKEN_TYPE.UTILITY,
      initialSupply: config.initialSupply || 1000000,
      maxSupply: config.maxSupply || 10000000,
      burnRate: config.burnRate || 0.01,
      stakingReward: config.stakingReward || 0.05,
      owner: config.owner || 'DEPLOYER'
    });
  }
  
  /**
   * Initialize traders
   */
  initializeTraders(count = 100) {
    this.traders = [];
    
    for (let i = 0; i < count; i++) {
      this.traders.push(new VirtualTrader({
        address: `trader-${i}`
      }));
    }
    
    // Create accounts on blockchain
    for (const trader of this.traders) {
      const balance = trader.type === 'WHALE' 
        ? 1000000 
        : trader.type === 'INSTITUTIONAL' 
          ? 100000 
          : 1000;
      
      this.blockchain.createAccount(trader.address, balance);
    }
    
    return this.traders;
  }
  
  /**
   * Simulate price movement
   */
  simulatePrice(currentPrice) {
    const volatility = this.marketCondition.volatility;
    const trend = this.marketCondition.multiplier > 1 ? 0.001 : -0.001;
    
    // Geometric Brownian Motion
    const dt = 1 / 365;  // Daily
    const drift = (trend - 0.5 * volatility * volatility) * dt;
    const diffusion = volatility * Math.sqrt(dt) * randomFromDistribution(DISTRIBUTION.NORMAL);
    
    const newPrice = currentPrice * Math.exp(drift + diffusion);
    
    return Math.max(0.01, newPrice);  // Floor at 0.01
  }
  
  /**
   * Run a single market simulation step
   */
  simulateStep(token, step) {
    // Update price
    this.basePrice = this.simulatePrice(this.basePrice);
    this.priceHistory.push({ step, price: this.basePrice, timestamp: Date.now() });
    
    // Each trader decides and acts
    const actions = [];
    
    for (const trader of this.traders) {
      const account = this.blockchain.accounts.get(trader.address);
      const tokenBalance = token.holders.get(trader.address) || 0;
      
      const decision = trader.decideAction(
        this.marketCondition,
        this.basePrice,
        { balance: account.balance, tokens: tokenBalance }
      );
      
      if (decision.type && decision.amount > 0) {
        // Execute transaction
        const tx = {
          type: decision.type === 'BUY' ? TX_TYPE.TRANSFER : TX_TYPE.TRANSFER,
          from: decision.type === 'BUY' ? token.owner : trader.address,
          to: decision.type === 'BUY' ? trader.address : token.owner,
          token: token.address,
          amount: Math.floor(decision.amount)
        };
        
        if (tx.amount > 0) {
          const result = this.blockchain.executeTransaction(tx);
          actions.push({ trader: trader.address, decision, result });
        }
      }
    }
    
    return {
      step,
      price: this.basePrice,
      actions: actions.length,
      successfulActions: actions.filter(a => a.result.success).length,
      tokenState: {
        totalSupply: token.totalSupply,
        holders: token.holders.size,
        transfers: token.transfers
      }
    };
  }
  
  /**
   * Run complete token economics simulation
   */
  async runSimulation(options = {}) {
    const days = options.days || 30;
    const stepsPerDay = options.stepsPerDay || 24;
    const totalSteps = days * stepsPerDay;
    
    // Deploy token
    const token = this.deployTestToken(options.token);
    
    // Initialize traders
    this.initializeTraders(options.traderCount || 100);
    
    // Distribute initial tokens
    for (const trader of this.traders) {
      const amount = trader.type === 'WHALE' 
        ? 100000 
        : trader.type === 'INSTITUTIONAL' 
          ? 10000 
          : 100;
      
      token.holders.set(trader.address, amount);
    }
    
    // Reset state
    this.priceHistory = [];
    this.basePrice = options.basePrice || 1.0;
    
    // Run simulation
    const stepResults = [];
    
    for (let step = 0; step < totalSteps; step++) {
      const result = this.simulateStep(token, step);
      stepResults.push(result);
      
      // Mine block periodically
      if (step % 10 === 0) {
        this.blockchain.mineBlock();
      }
      
      // Yield to event loop
      if (step % 100 === 0) {
        await new Promise(resolve => setTimeout(resolve, 0));
      }
    }
    
    // Analyze results
    const prices = this.priceHistory.map(p => p.price);
    const returns = [];
    for (let i = 1; i < prices.length; i++) {
      returns.push((prices[i] - prices[i-1]) / prices[i-1]);
    }
    
    const analysis = {
      initialPrice: options.basePrice || 1.0,
      finalPrice: this.basePrice,
      priceChange: ((this.basePrice - (options.basePrice || 1.0)) / (options.basePrice || 1.0)) * 100,
      maxPrice: Math.max(...prices),
      minPrice: Math.min(...prices),
      volatility: stddev(returns) * Math.sqrt(365),  // Annualized
      sharpeRatio: mean(returns) / stddev(returns) * Math.sqrt(365),
      maxDrawdown: this._calculateMaxDrawdown(prices),
      
      tokenMetrics: {
        finalSupply: token.totalSupply,
        totalBurns: token.burns,
        totalMints: token.mints,
        totalTransfers: token.transfers,
        uniqueHolders: token.holders.size
      },
      
      blockchainMetrics: this.blockchain.getState(),
      
      priceHistory: this.priceHistory,
      confidenceInterval: confidenceInterval(prices, 0.95)
    };
    
    this.testResults.push(analysis);
    
    return analysis;
  }
  
  _calculateMaxDrawdown(prices) {
    let maxDrawdown = 0;
    let peak = prices[0];
    
    for (const price of prices) {
      if (price > peak) {
        peak = price;
      }
      const drawdown = (peak - price) / peak;
      if (drawdown > maxDrawdown) {
        maxDrawdown = drawdown;
      }
    }
    
    return maxDrawdown;
  }
  
  /**
   * Run attack simulation
   */
  async simulateAttack(attackType, token, options = {}) {
    const results = {
      attackType,
      success: false,
      impact: 0,
      details: {}
    };
    
    switch (attackType) {
      case ATTACK_TYPE.WHALE_DUMP:
        // Simulate a whale selling large amount
        const whaleAmount = token.totalSupply * 0.2;
        const preBefore = this.basePrice;
        
        // Price impact from large sell
        this.basePrice *= (1 - (whaleAmount / token.totalSupply) * 0.5);
        
        results.success = true;
        results.impact = (preBefore - this.basePrice) / preBefore;
        results.details = {
          amountSold: whaleAmount,
          priceImpact: results.impact,
          priceAfter: this.basePrice
        };
        break;
      
      case ATTACK_TYPE.FLASH_LOAN:
        // Simulate flash loan attack
        const loanAmount = token.totalSupply * 0.5;
        const manipulatedPrice = this.basePrice * 0.7;
        const profit = loanAmount * (this.basePrice - manipulatedPrice);
        
        results.success = profit > 0;
        results.impact = profit / (token.totalSupply * this.basePrice);
        results.details = {
          loanAmount,
          manipulatedPrice,
          profit,
          riskAssessment: 'HIGH'
        };
        break;
      
      case ATTACK_TYPE.SANDWICH:
        // Simulate sandwich attack
        const victimTrade = options.victimTradeSize || 10000;
        const frontrunProfit = victimTrade * 0.01;  // 1% profit
        
        results.success = true;
        results.impact = frontrunProfit / victimTrade;
        results.details = {
          victimTradeSize: victimTrade,
          frontrunProfit,
          slippageExploited: '1%'
        };
        break;
    }
    
    return results;
  }
  
  /**
   * Set market condition
   */
  setMarketCondition(condition) {
    if (MARKET_CONDITION[condition]) {
      this.marketCondition = MARKET_CONDITION[condition];
    }
    return this.marketCondition;
  }
  
  toJSON() {
    return {
      type: 'TokenChaosTester',
      version: '1.0.0',
      testerId: this.testerId,
      marketCondition: this.marketCondition.name,
      traderCount: this.traders.length,
      priceHistory: this.priceHistory.length,
      testCount: this.testResults.length,
      blockchainState: this.blockchain.getState()
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  TOKEN_TYPE,
  TX_TYPE,
  ATTACK_TYPE,
  MARKET_CONDITION
};

export function createBlockchain(config = {}) {
  return new VirtualBlockchain(config);
}

export function createTokenTester(config = {}) {
  return new TokenChaosTester(config);
}

export default {
  TOKEN_TYPE,
  TX_TYPE,
  ATTACK_TYPE,
  MARKET_CONDITION,
  VirtualBlockchain,
  VirtualTrader,
  TokenChaosTester,
  createBlockchain,
  createTokenTester
};
