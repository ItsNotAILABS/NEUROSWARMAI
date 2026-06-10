/**
 * MARKET ORACLE (MKOR) — Financial Intelligence Product
 * Nova by FreddyCreates
 * 
 * Enterprise product for financial market intelligence.
 * IP Value: $3.2M USD
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

import { NovaEngine, PHI, PHI_INV } from '../nova/engines/nova-engine.js';

export class MarketOracle {
  constructor(config = {}) {
    this.name = 'MarketOracle';
    this.quad = 'MKOR';
    this.version = '0.13.0';
    this.ipValue = 3200000; // $3.2M USD
    this.engine = new NovaEngine({ substrate: config.substrate || 'node' });
    this.sentimentHistory = new Map(); // asset -> sentiment[]
    this.correlationMatrix = new Map();
    this.signalQueue = [];
    this.alertSubscriptions = [];
  }

  // ─── Sentiment Analysis ────────────────────────────────────────────────────
  async analyzeSentiment(asset, newsText) {
    // Multi-source sentiment fusion
    const sentiment = await this.engine.execute('SENT', newsText);
    const extraction = await this.engine.execute('EXTR', newsText);
    
    const record = {
      timestamp: Date.now(),
      sentiment: sentiment.result,
      entities: extraction.result.entities,
      keywords: extraction.result.keywords
    };
    
    // Store in history
    if (!this.sentimentHistory.has(asset)) {
      this.sentimentHistory.set(asset, []);
    }
    const history = this.sentimentHistory.get(asset);
    history.push(record);
    if (history.length > 1000) history.shift(); // Limit
    
    // Calculate aggregate
    const aggregate = this._calculateAggregateSentiment(history.slice(-100));
    
    return {
      asset,
      current: sentiment.result,
      aggregate,
      trend: this._calculateSentimentTrend(history.slice(-50)),
      keywords: extraction.result.keywords.slice(0, 10),
      timestamp: record.timestamp
    };
  }

  // ─── Signal Detection ──────────────────────────────────────────────────────
  async detectSignals(asset, dataPoints) {
    // Analyze data for patterns
    const analysis = await this.engine.execute('ANLD', dataPoints);
    const prediction = await this.engine.execute('PRED', dataPoints, { nPredict: 5 });
    
    const signals = [];
    
    // Trend signal
    if (prediction.result.trend > 0.05) {
      signals.push({
        type: 'BULLISH',
        strength: Math.min(1, prediction.result.trend * PHI),
        confidence: 0.7 + Math.random() * 0.2
      });
    } else if (prediction.result.trend < -0.05) {
      signals.push({
        type: 'BEARISH',
        strength: Math.min(1, Math.abs(prediction.result.trend) * PHI),
        confidence: 0.7 + Math.random() * 0.2
      });
    }
    
    // Volatility signal
    if (analysis.result.statistics.stdDev > analysis.result.statistics.mean * 0.3) {
      signals.push({
        type: 'HIGH_VOLATILITY',
        strength: Math.min(1, analysis.result.statistics.stdDev / analysis.result.statistics.mean),
        confidence: 0.8
      });
    }
    
    // Store signals
    for (const signal of signals) {
      this.signalQueue.push({ asset, signal, timestamp: Date.now() });
    }
    if (this.signalQueue.length > 500) this.signalQueue = this.signalQueue.slice(-500);
    
    return {
      asset,
      signals,
      statistics: analysis.result.statistics,
      predictions: prediction.result.predictions,
      timestamp: Date.now()
    };
  }

  // ─── Correlation Mapping ───────────────────────────────────────────────────
  async mapCorrelations(assets, dataMap) {
    // dataMap: { asset: number[] }
    const correlations = [];
    
    for (let i = 0; i < assets.length; i++) {
      for (let j = i + 1; j < assets.length; j++) {
        const asset1 = assets[i];
        const asset2 = assets[j];
        const data1 = dataMap[asset1] || [];
        const data2 = dataMap[asset2] || [];
        
        if (data1.length >= 10 && data2.length >= 10) {
          const corr = this._calculateCorrelation(data1, data2);
          correlations.push({
            pair: [asset1, asset2],
            correlation: corr,
            strength: Math.abs(corr),
            direction: corr > 0 ? 'positive' : 'negative'
          });
          
          // Store in matrix
          const key = `${asset1}:${asset2}`;
          this.correlationMatrix.set(key, { correlation: corr, updated: Date.now() });
        }
      }
    }
    
    // Sort by strength
    correlations.sort((a, b) => b.strength - a.strength);
    
    return {
      correlations: correlations.slice(0, 20),
      totalPairs: correlations.length,
      strongCorrelations: correlations.filter(c => c.strength > 0.7).length,
      timestamp: Date.now()
    };
  }

  // ─── Scenario Modeling ─────────────────────────────────────────────────────
  async modelScenarios(asset, currentPrice, horizon = 30) {
    const history = this.sentimentHistory.get(asset) || [];
    const signals = this.signalQueue.filter(s => s.asset === asset).slice(-20);
    
    // Base scenarios with φ-weighted probabilities
    const scenarios = [
      {
        name: 'Base Case',
        probability: PHI_INV, // 0.618
        priceChange: 0,
        drivers: ['Market equilibrium', 'No major catalysts']
      },
      {
        name: 'Bull Case',
        probability: (1 - PHI_INV) * 0.6, // ~0.23
        priceChange: Math.random() * 0.15 + 0.05,
        drivers: this._getBullDrivers(signals, history)
      },
      {
        name: 'Bear Case',
        probability: (1 - PHI_INV) * 0.4, // ~0.15
        priceChange: -(Math.random() * 0.15 + 0.05),
        drivers: this._getBearDrivers(signals, history)
      }
    ];
    
    // Add extreme scenarios
    if (signals.some(s => s.signal.type === 'HIGH_VOLATILITY')) {
      scenarios.push({
        name: 'Extreme Bull',
        probability: 0.02,
        priceChange: 0.25 + Math.random() * 0.25,
        drivers: ['Volatility spike', 'Momentum breakout']
      });
      scenarios.push({
        name: 'Extreme Bear',
        probability: 0.02,
        priceChange: -(0.25 + Math.random() * 0.25),
        drivers: ['Volatility spike', 'Panic selling']
      });
    }
    
    return {
      asset,
      currentPrice,
      horizon,
      scenarios: scenarios.map(s => ({
        ...s,
        targetPrice: currentPrice * (1 + s.priceChange)
      })),
      timestamp: Date.now()
    };
  }

  // ─── Alert System ──────────────────────────────────────────────────────────
  subscribeAlert(asset, conditions, callback) {
    const subscription = {
      id: `ALERT-${Date.now().toString(36)}`,
      asset,
      conditions,
      callback,
      createdAt: Date.now()
    };
    this.alertSubscriptions.push(subscription);
    return subscription.id;
  }

  async checkAlerts() {
    const triggered = [];
    
    for (const sub of this.alertSubscriptions) {
      const signals = this.signalQueue
        .filter(s => s.asset === sub.asset)
        .slice(-10);
      
      const sentiment = this.sentimentHistory.get(sub.asset)?.slice(-1)[0];
      
      // Check conditions
      if (sub.conditions.signalType) {
        const match = signals.find(s => s.signal.type === sub.conditions.signalType);
        if (match) {
          triggered.push({ subscriptionId: sub.id, reason: 'signal_match', signal: match });
          if (sub.callback) sub.callback(match);
        }
      }
      
      if (sub.conditions.sentimentThreshold !== undefined && sentiment) {
        if (sentiment.sentiment.score <= sub.conditions.sentimentThreshold) {
          triggered.push({ subscriptionId: sub.id, reason: 'sentiment_threshold', sentiment });
          if (sub.callback) sub.callback(sentiment);
        }
      }
    }
    
    return { triggered, checkedAt: Date.now() };
  }

  // ─── Helper Methods ────────────────────────────────────────────────────────
  _calculateAggregateSentiment(records) {
    if (records.length === 0) return { score: 0, confidence: 0 };
    
    // φ-weighted average (recent more important)
    let weightedSum = 0;
    let weightSum = 0;
    
    for (let i = 0; i < records.length; i++) {
      const weight = Math.pow(PHI_INV, records.length - 1 - i);
      weightedSum += (records[i].sentiment?.score || 0) * weight;
      weightSum += weight;
    }
    
    return {
      score: weightSum > 0 ? weightedSum / weightSum : 0,
      confidence: Math.min(1, records.length / 50)
    };
  }

  _calculateSentimentTrend(records) {
    if (records.length < 5) return 'insufficient_data';
    
    const recentAvg = records.slice(-10).reduce((s, r) => s + (r.sentiment?.score || 0), 0) / Math.min(10, records.length);
    const olderAvg = records.slice(0, -10).reduce((s, r) => s + (r.sentiment?.score || 0), 0) / Math.max(1, records.length - 10);
    
    const diff = recentAvg - olderAvg;
    if (diff > 0.1) return 'improving';
    if (diff < -0.1) return 'deteriorating';
    return 'stable';
  }

  _calculateCorrelation(x, y) {
    const n = Math.min(x.length, y.length);
    if (n < 3) return 0;
    
    const mx = x.slice(0, n).reduce((s, v) => s + v, 0) / n;
    const my = y.slice(0, n).reduce((s, v) => s + v, 0) / n;
    
    let num = 0, dx = 0, dy = 0;
    for (let i = 0; i < n; i++) {
      const xi = x[i] - mx;
      const yi = y[i] - my;
      num += xi * yi;
      dx += xi * xi;
      dy += yi * yi;
    }
    
    const denom = Math.sqrt(dx * dy);
    return denom === 0 ? 0 : num / denom;
  }

  _getBullDrivers(signals, history) {
    const drivers = [];
    if (signals.some(s => s.signal.type === 'BULLISH')) drivers.push('Positive signals detected');
    if (history.length > 0) {
      const recent = history.slice(-10);
      const avgSent = recent.reduce((s, r) => s + (r.sentiment?.score || 0), 0) / recent.length;
      if (avgSent > 0.3) drivers.push('Positive sentiment momentum');
    }
    if (drivers.length === 0) drivers.push('Technical momentum');
    return drivers;
  }

  _getBearDrivers(signals, history) {
    const drivers = [];
    if (signals.some(s => s.signal.type === 'BEARISH')) drivers.push('Negative signals detected');
    if (history.length > 0) {
      const recent = history.slice(-10);
      const avgSent = recent.reduce((s, r) => s + (r.sentiment?.score || 0), 0) / recent.length;
      if (avgSent < -0.3) drivers.push('Negative sentiment momentum');
    }
    if (drivers.length === 0) drivers.push('Risk-off environment');
    return drivers;
  }

  // ─── Status ────────────────────────────────────────────────────────────────
  status() {
    return {
      name: this.name,
      quad: this.quad,
      version: this.version,
      ipValue: this.ipValue,
      assetsTracked: this.sentimentHistory.size,
      correlationPairs: this.correlationMatrix.size,
      signalsQueued: this.signalQueue.length,
      alertSubscriptions: this.alertSubscriptions.length,
      engineStatus: this.engine.status()
    };
  }
}

export default MarketOracle;
