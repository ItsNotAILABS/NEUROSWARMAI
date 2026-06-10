/**
 * BRAND GUARDIAN (BRGD) — Brand Intelligence Product
 * Nova by FreddyCreates
 * 
 * Enterprise product for brand protection and perception intelligence.
 * IP Value: $1.6M USD
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

import { NovaEngine, PHI, PHI_INV } from '../nova/engines/nova-engine.js';

export class BrandGuardian {
  constructor(config = {}) {
    this.name = 'BrandGuardian';
    this.quad = 'BRGD';
    this.version = '0.13.0';
    this.ipValue = 1600000; // $1.6M USD
    this.engine = new NovaEngine({ substrate: config.substrate || 'node' });
    this.brandState = new Map();
    this.mentionHistory = [];
    this.crisisPatterns = [];
    this.influencerMap = new Map();
  }

  async monitorBrand(brandId, sources) {
    const brand = this.brandState.get(brandId) || {
      id: brandId,
      baselineSentiment: 0.6,
      mentions: [],
      alerts: [],
      createdAt: Date.now()
    };
    
    const newMentions = [];
    
    for (const source of sources) {
      const sentiment = await this.engine.execute('SENT', source.text);
      const extraction = await this.engine.execute('EXTR', source.text);
      
      const mention = {
        source: source.platform,
        text: source.text,
        timestamp: source.timestamp || Date.now(),
        sentiment: sentiment.result,
        entities: extraction.result.entities,
        keywords: extraction.result.keywords,
        reach: source.reach || 1
      };
      
      newMentions.push(mention);
      brand.mentions.push(mention);
      this.mentionHistory.push({ brandId, ...mention });
    }
    
    // Update brand state
    const currentSentiment = this._calculateCurrentSentiment(brand.mentions.slice(-100));
    const drift = currentSentiment - brand.baselineSentiment;
    
    brand.currentSentiment = currentSentiment;
    brand.sentimentDrift = drift;
    brand.updatedAt = Date.now();
    
    // Check for crisis
    const crisisIndicators = this._detectCrisisIndicators(brand, newMentions);
    if (crisisIndicators.length > 0) {
      brand.alerts.push({
        type: 'CRISIS_INDICATOR',
        indicators: crisisIndicators,
        timestamp: Date.now()
      });
    }
    
    this.brandState.set(brandId, brand);
    
    return {
      success: true,
      brandId,
      newMentions: newMentions.length,
      currentSentiment,
      sentimentDrift: drift,
      crisisIndicators
    };
  }

  async detectCrisis(brandId) {
    const brand = this.brandState.get(brandId);
    if (!brand) throw new Error(`Brand not found: ${brandId}`);
    
    const recentMentions = brand.mentions.slice(-50);
    const sentimentTrend = this._calculateSentimentTrend(recentMentions);
    const volumeSpike = this._detectVolumeSpike(recentMentions);
    const negativeKeywords = this._detectNegativeKeywords(recentMentions);
    
    const crisisScore = (
      (sentimentTrend < -0.2 ? 0.4 : 0) +
      (volumeSpike > 2 ? 0.3 : 0) +
      (negativeKeywords.length > 5 ? 0.3 : 0)
    );
    
    const crisis = {
      brandId,
      score: crisisScore,
      level: crisisScore > 0.7 ? 'high' : crisisScore > 0.4 ? 'medium' : 'low',
      indicators: {
        sentimentTrend,
        volumeSpike,
        negativeKeywords: negativeKeywords.slice(0, 10)
      },
      recommendation: crisisScore > 0.5 ? 'Crisis response team activation recommended' : 'Continue monitoring'
    };
    
    if (crisisScore > 0.3) {
      this.crisisPatterns.push({ ...crisis, timestamp: Date.now() });
    }
    
    return crisis;
  }

  async mapInfluencers(brandId, mentions) {
    const influencers = new Map();
    
    for (const mention of mentions) {
      if (mention.author && mention.reach > 1000) {
        const existing = influencers.get(mention.author) || {
          id: mention.author,
          mentions: 0,
          totalReach: 0,
          avgSentiment: 0,
          sentimentSum: 0
        };
        
        existing.mentions++;
        existing.totalReach += mention.reach;
        existing.sentimentSum += mention.sentiment?.score || 0;
        existing.avgSentiment = existing.sentimentSum / existing.mentions;
        existing.type = existing.avgSentiment > 0.3 ? 'advocate' : existing.avgSentiment < -0.3 ? 'critic' : 'neutral';
        
        influencers.set(mention.author, existing);
      }
    }
    
    const influencerList = [...influencers.values()];
    influencerList.sort((a, b) => b.totalReach - a.totalReach);
    
    // Store in map
    influencerList.forEach(inf => {
      this.influencerMap.set(`${brandId}:${inf.id}`, inf);
    });
    
    return {
      brandId,
      totalInfluencers: influencerList.length,
      advocates: influencerList.filter(i => i.type === 'advocate'),
      critics: influencerList.filter(i => i.type === 'critic'),
      neutral: influencerList.filter(i => i.type === 'neutral'),
      topByReach: influencerList.slice(0, 10)
    };
  }

  async analyzeCompetitor(brandId, competitorId, competitorMentions) {
    const brand = this.brandState.get(brandId);
    const brandSentiment = brand?.currentSentiment || 0.6;
    
    const competitorSentiment = this._calculateCurrentSentiment(competitorMentions);
    const competitorVolume = competitorMentions.length;
    const brandVolume = brand?.mentions.length || 0;
    
    const competitorKeywords = [];
    competitorMentions.forEach(m => {
      if (m.keywords) competitorKeywords.push(...m.keywords);
    });
    
    const keywordFreq = {};
    competitorKeywords.forEach(k => { keywordFreq[k] = (keywordFreq[k] || 0) + 1; });
    
    const topKeywords = Object.entries(keywordFreq)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 10)
      .map(([word, count]) => ({ word, count }));
    
    return {
      brandId,
      competitorId,
      comparison: {
        sentimentDiff: brandSentiment - competitorSentiment,
        volumeRatio: brandVolume / Math.max(1, competitorVolume),
        brandAdvantage: brandSentiment > competitorSentiment ? 'sentiment' : 
                        brandVolume > competitorVolume ? 'visibility' : 'competitor_ahead'
      },
      competitorInsights: {
        sentiment: competitorSentiment,
        volume: competitorVolume,
        topKeywords
      }
    };
  }

  async optimizeMessage(brandId, message, targetAudience) {
    const brand = this.brandState.get(brandId);
    const sentiment = await this.engine.execute('SENT', message);
    const extraction = await this.engine.execute('EXTR', message);
    
    // Analyze message alignment with brand sentiment
    const alignmentScore = brand ? 
      1 - Math.abs(sentiment.result.score - brand.baselineSentiment) : 
      sentiment.result.score;
    
    const optimization = {
      original: message,
      sentiment: sentiment.result,
      keywords: extraction.result.keywords,
      alignmentScore,
      recommendations: []
    };
    
    if (sentiment.result.score < brand?.baselineSentiment) {
      optimization.recommendations.push('Consider more positive framing');
    }
    
    if (extraction.result.keywords.length < 3) {
      optimization.recommendations.push('Add more relevant keywords for discoverability');
    }
    
    // φ-weighted performance prediction
    optimization.predictedPerformance = alignmentScore * PHI_INV + sentiment.result.score * (1 - PHI_INV);
    
    return optimization;
  }

  _calculateCurrentSentiment(mentions) {
    if (mentions.length === 0) return 0.6;
    
    let weightedSum = 0;
    let weightSum = 0;
    
    mentions.forEach((m, i) => {
      const weight = Math.pow(PHI_INV, mentions.length - 1 - i) * (m.reach || 1);
      weightedSum += (m.sentiment?.score || 0) * weight;
      weightSum += weight;
    });
    
    return weightSum > 0 ? weightedSum / weightSum : 0.6;
  }

  _calculateSentimentTrend(mentions) {
    if (mentions.length < 10) return 0;
    
    const recent = mentions.slice(-10);
    const older = mentions.slice(0, -10);
    
    const recentAvg = recent.reduce((s, m) => s + (m.sentiment?.score || 0), 0) / recent.length;
    const olderAvg = older.length > 0 ? 
      older.reduce((s, m) => s + (m.sentiment?.score || 0), 0) / older.length : 
      recentAvg;
    
    return recentAvg - olderAvg;
  }

  _detectVolumeSpike(mentions) {
    if (mentions.length < 10) return 1;
    
    const recentCount = mentions.filter(m => 
      m.timestamp > Date.now() - 24 * 60 * 60 * 1000
    ).length;
    
    const avgDaily = mentions.length / 7; // Assuming 7 days of data
    return avgDaily > 0 ? recentCount / avgDaily : 1;
  }

  _detectNegativeKeywords(mentions) {
    const crisisKeywords = ['scandal', 'boycott', 'lawsuit', 'recall', 'fraud', 'fail', 'disaster', 'crisis', 'outrage', 'backlash'];
    const found = [];
    
    mentions.forEach(m => {
      if (m.keywords) {
        m.keywords.forEach(k => {
          if (crisisKeywords.includes(k.toLowerCase()) && !found.includes(k)) {
            found.push(k);
          }
        });
      }
    });
    
    return found;
  }

  _detectCrisisIndicators(brand, newMentions) {
    const indicators = [];
    
    const negativeMentions = newMentions.filter(m => (m.sentiment?.score || 0) < -0.3);
    if (negativeMentions.length > newMentions.length * 0.4) {
      indicators.push('High negative mention ratio');
    }
    
    if (brand.sentimentDrift < -0.2) {
      indicators.push('Significant sentiment decline');
    }
    
    const negativeKeywords = this._detectNegativeKeywords(newMentions);
    if (negativeKeywords.length > 0) {
      indicators.push(`Crisis keywords detected: ${negativeKeywords.join(', ')}`);
    }
    
    return indicators;
  }

  status() {
    return {
      name: this.name,
      quad: this.quad,
      version: this.version,
      ipValue: this.ipValue,
      brandsMonitored: this.brandState.size,
      totalMentions: this.mentionHistory.length,
      crisisPatterns: this.crisisPatterns.length,
      influencersMapped: this.influencerMap.size,
      engineStatus: this.engine.status()
    };
  }
}

export default BrandGuardian;
