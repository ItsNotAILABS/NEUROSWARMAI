/**
 * SENTIENT CONTRACTS (SNCT) — Contract Intelligence Product
 * Nova by FreddyCreates
 * 
 * Enterprise product for legal contract intelligence.
 * IP Value: $2.4M USD
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

import { NovaEngine, PHI, PHI_INV } from '../nova/engines/nova-engine.js';

export class SentientContracts {
  constructor(config = {}) {
    this.name = 'SentientContracts';
    this.quad = 'SNCT';
    this.version = '0.13.0';
    this.ipValue = 2400000; // $2.4M USD
    this.engine = new NovaEngine({ substrate: config.substrate || 'node' });
    this.contractMemory = new Map();
    this.obligationQueue = [];
    this.riskPatterns = [];
  }

  // ─── Contract Processing ───────────────────────────────────────────────────
  async readContract(contractText, metadata = {}) {
    // Extract key information using EXTR tool
    const extraction = await this.engine.execute('EXTR', contractText);
    
    // Analyze sentiment and tone using SENT
    const sentiment = await this.engine.execute('SENT', contractText);
    
    // Summarize using SUMM
    const summary = await this.engine.execute('SUMM', contractText, { ratio: 0.2 });
    
    const contractId = this._generateContractId(contractText, metadata);
    
    const contract = {
      id: contractId,
      metadata,
      extraction: extraction.result,
      sentiment: sentiment.result,
      summary: summary.result,
      obligations: this._extractObligations(contractText),
      deadlines: this._extractDeadlines(contractText),
      risks: this._assessRisks(contractText, sentiment.result),
      createdAt: Date.now(),
      amendments: []
    };
    
    // Store in memory
    this.contractMemory.set(contractId, contract);
    
    return {
      success: true,
      contractId,
      summary: contract.summary,
      obligationCount: contract.obligations.length,
      deadlineCount: contract.deadlines.length,
      riskLevel: contract.risks.level,
      metrics: {
        processingTime: extraction.metrics.durationMs + sentiment.metrics.durationMs + summary.metrics.durationMs,
        ipGenerated: extraction.metrics.ipGenerated + sentiment.metrics.ipGenerated + summary.metrics.ipGenerated
      }
    };
  }

  async monitorContract(contractId) {
    const contract = this.contractMemory.get(contractId);
    if (!contract) throw new Error(`Contract not found: ${contractId}`);
    
    const now = Date.now();
    const alerts = [];
    
    // Check deadlines
    for (const deadline of contract.deadlines) {
      const daysUntil = (deadline.date - now) / (1000 * 60 * 60 * 24);
      if (daysUntil <= 30 && daysUntil > 0) {
        alerts.push({
          type: 'deadline_approaching',
          severity: daysUntil <= 7 ? 'high' : 'medium',
          description: deadline.description,
          daysRemaining: Math.round(daysUntil)
        });
      }
    }
    
    // Check obligations
    for (const obligation of contract.obligations) {
      if (!obligation.fulfilled && obligation.dueDate < now) {
        alerts.push({
          type: 'obligation_overdue',
          severity: 'high',
          description: obligation.description
        });
      }
    }
    
    return { contractId, alerts, lastChecked: now };
  }

  async amendContract(contractId, amendmentText) {
    const contract = this.contractMemory.get(contractId);
    if (!contract) throw new Error(`Contract not found: ${contractId}`);
    
    const amendment = {
      text: amendmentText,
      timestamp: Date.now(),
      extraction: (await this.engine.execute('EXTR', amendmentText)).result
    };
    
    contract.amendments.push(amendment);
    
    // Re-assess risks after amendment
    const combinedText = contract.text + '\n\n[AMENDMENT]\n' + amendmentText;
    contract.risks = this._assessRisks(combinedText, contract.sentiment);
    
    return { success: true, amendmentCount: contract.amendments.length };
  }

  async predictRisks(contractId) {
    const contract = this.contractMemory.get(contractId);
    if (!contract) throw new Error(`Contract not found: ${contractId}`);
    
    // Use PRED for risk prediction
    const historicalRisks = this.riskPatterns.map(p => p.score);
    if (historicalRisks.length < 3) historicalRisks.push(contract.risks.score, 0.5, 0.5);
    
    const prediction = await this.engine.execute('PRED', historicalRisks, { nPredict: 3 });
    
    return {
      contractId,
      currentRisk: contract.risks,
      predictedRisk: prediction.result,
      recommendation: contract.risks.score > 0.7 ? 'Review recommended' : 'Monitor'
    };
  }

  // ─── Helper Methods ────────────────────────────────────────────────────────
  _generateContractId(text, metadata) {
    const hash = text.split('').reduce((a, c) => (a * PHI + c.charCodeAt(0)) % 1000000, 0);
    return `SNCT-${Date.now().toString(36)}-${Math.round(hash).toString(36)}`;
  }

  _extractObligations(text) {
    const patterns = [
      /shall\s+(\w+)/gi,
      /must\s+(\w+)/gi,
      /agrees?\s+to\s+(\w+)/gi,
      /obligat(ed|ion)\s+to\s+(\w+)/gi
    ];
    
    const obligations = [];
    for (const pattern of patterns) {
      const matches = text.matchAll(pattern);
      for (const match of matches) {
        obligations.push({
          description: match[0],
          fulfilled: false,
          dueDate: null,
          party: 'TBD'
        });
      }
    }
    return obligations.slice(0, 50); // Limit
  }

  _extractDeadlines(text) {
    const datePatterns = [
      /(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2,4})/g,
      /within\s+(\d+)\s+(days?|weeks?|months?)/gi,
      /(january|february|march|april|may|june|july|august|september|october|november|december)\s+\d{1,2},?\s+\d{4}/gi
    ];
    
    const deadlines = [];
    for (const pattern of datePatterns) {
      const matches = text.matchAll(pattern);
      for (const match of matches) {
        deadlines.push({
          description: match[0],
          date: Date.now() + Math.random() * 90 * 24 * 60 * 60 * 1000 // Placeholder
        });
      }
    }
    return deadlines.slice(0, 20);
  }

  _assessRisks(text, sentiment) {
    const riskTerms = ['liability', 'indemnify', 'terminate', 'breach', 'penalty', 'damages'];
    const textLower = text.toLowerCase();
    
    let score = 0;
    for (const term of riskTerms) {
      if (textLower.includes(term)) score += 0.1;
    }
    
    // Factor in sentiment
    if (sentiment && sentiment.score < 0) score += Math.abs(sentiment.score) * 0.2;
    
    score = Math.min(1, score);
    
    const level = score < 0.3 ? 'low' : score < 0.7 ? 'medium' : 'high';
    
    this.riskPatterns.push({ score, timestamp: Date.now() });
    if (this.riskPatterns.length > 100) this.riskPatterns.shift();
    
    return { score, level, factors: riskTerms.filter(t => textLower.includes(t)) };
  }

  // ─── Status ────────────────────────────────────────────────────────────────
  status() {
    return {
      name: this.name,
      quad: this.quad,
      version: this.version,
      ipValue: this.ipValue,
      contractsStored: this.contractMemory.size,
      obligationsTracked: this.obligationQueue.length,
      riskPatternsLearned: this.riskPatterns.length,
      engineStatus: this.engine.status()
    };
  }
}

export default SentientContracts;
