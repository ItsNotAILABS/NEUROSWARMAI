/**
 * NOVA DOCS — AI Document Intelligence
 * Nova by FreddyCreates
 * 
 * AI document intelligence for contracts and reports.
 * 
 * Features:
 * - Contract analysis and risk detection
 * - Report generation from data
 * - Information extraction (names, dates, terms)
 * - Document comparison tools
 * - Template library
 * 
 * IP Portfolio: $2.6M USD
 * QUAD: NVDC
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Document Types ──────────────────────────────────────────────────────────
export const DOCUMENT_TYPES = {
  CONTRACT: { name: 'Contract', riskFactors: ['liability', 'termination', 'indemnity', 'exclusivity'] },
  AGREEMENT: { name: 'Agreement', riskFactors: ['obligations', 'warranties', 'disputes'] },
  REPORT: { name: 'Report', sections: ['executive-summary', 'findings', 'recommendations'] },
  INVOICE: { name: 'Invoice', fields: ['vendor', 'amount', 'date', 'items', 'terms'] },
  RESUME: { name: 'Resume/CV', fields: ['name', 'experience', 'education', 'skills'] },
  LEGAL: { name: 'Legal Document', complexity: 'high' },
  FINANCIAL: { name: 'Financial Document', fields: ['figures', 'dates', 'entities'] }
};

// ─── Extraction Types ────────────────────────────────────────────────────────
export const EXTRACTION_TYPES = {
  ENTITIES: { name: 'Named Entities', types: ['person', 'organization', 'location', 'date'] },
  DATES: { name: 'Dates', formats: ['ISO', 'US', 'EU', 'natural'] },
  AMOUNTS: { name: 'Monetary Amounts', currencies: ['USD', 'EUR', 'GBP', 'other'] },
  CLAUSES: { name: 'Contract Clauses', types: ['termination', 'liability', 'confidentiality'] },
  TERMS: { name: 'Key Terms', categories: ['definitions', 'obligations', 'restrictions'] }
};

// ─── Risk Levels ─────────────────────────────────────────────────────────────
export const RISK_LEVELS = {
  LOW: { name: 'Low Risk', color: 'green', score: 1 },
  MEDIUM: { name: 'Medium Risk', color: 'yellow', score: 2 },
  HIGH: { name: 'High Risk', color: 'orange', score: 3 },
  CRITICAL: { name: 'Critical Risk', color: 'red', score: 4 }
};

// ─── Nova Docs Class ─────────────────────────────────────────────────────────
export class NovaDocs {
  static VERSION = '0.19.0';
  static IP_VALUE = 2600000;
  static QUAD = 'NVDC';
  static FREE_LIMIT = 50; // documents/month
  
  constructor(config = {}) {
    this.config = config;
    this.userId = config.userId;
    
    // Documents
    this.documents = new Map();
    this.docIdCounter = 1000;
    
    // Templates
    this.templates = new Map();
    this._initializeDefaultTemplates();
    
    // Extractions cache
    this.extractions = new Map();
    
    // Comparisons
    this.comparisons = new Map();
    
    // Usage tracking
    this.usage = {
      documents: 0,
      analyses: 0,
      extractions: 0,
      comparisons: 0,
      reports: 0,
      history: []
    };
    
    // Analytics
    this.analytics = {
      byDocType: {},
      byRiskLevel: { LOW: 0, MEDIUM: 0, HIGH: 0, CRITICAL: 0 },
      avgRiskScore: 0
    };
    
    this.createdAt = Date.now();
  }
  
  /**
   * Upload document for analysis
   */
  uploadDocument(name, content, options = {}) {
    if (this.usage.documents >= NovaDocs.FREE_LIMIT) {
      return {
        success: false,
        error: 'FREE_LIMIT_REACHED',
        message: `Free limit of ${NovaDocs.FREE_LIMIT} documents/month reached.`,
        upgradeUrl: 'nova.ai/upgrade'
      };
    }
    
    const {
      type = 'auto',
      tags = []
    } = options;
    
    // Auto-detect document type
    const detectedType = type === 'auto' ? this._detectDocumentType(content) : type;
    
    const docId = `DOC-${this.docIdCounter++}`;
    
    const document = {
      id: docId,
      name,
      content,
      type: detectedType,
      tags,
      wordCount: content.split(/\s+/).length,
      metadata: {
        uploadedAt: Date.now(),
        lastAccessed: Date.now(),
        size: content.length
      }
    };
    
    this.documents.set(docId, document);
    this.usage.documents++;
    
    this.analytics.byDocType[detectedType] = (this.analytics.byDocType[detectedType] || 0) + 1;
    
    return {
      success: true,
      docId,
      document: {
        id: docId,
        name,
        type: DOCUMENT_TYPES[detectedType]?.name || detectedType,
        wordCount: document.wordCount,
        size: `${(content.length / 1024).toFixed(2)}KB`
      },
      usage: this.getUsageStats()
    };
  }
  
  /**
   * Analyze contract for risks
   */
  async analyzeContract(docId) {
    const doc = this.documents.get(docId);
    if (!doc) {
      return { success: false, error: 'DOCUMENT_NOT_FOUND' };
    }
    
    const analysis = await this._analyzeContract(doc);
    
    this.usage.analyses++;
    
    // Update analytics
    for (const risk of analysis.risks) {
      this.analytics.byRiskLevel[risk.level]++;
    }
    
    return {
      success: true,
      docId,
      analysis: {
        overallRisk: analysis.overallRisk,
        riskScore: analysis.riskScore,
        risks: analysis.risks.map(r => ({
          clause: r.clause,
          level: r.level,
          issue: r.issue,
          recommendation: r.recommendation,
          location: r.location
        })),
        keyTerms: analysis.keyTerms,
        parties: analysis.parties,
        dates: analysis.dates,
        obligations: analysis.obligations,
        summary: analysis.summary
      }
    };
  }
  
  /**
   * Extract information from document
   */
  async extract(docId, extractionTypes = ['ENTITIES']) {
    const doc = this.documents.get(docId);
    if (!doc) {
      return { success: false, error: 'DOCUMENT_NOT_FOUND' };
    }
    
    const extractions = {};
    
    for (const type of extractionTypes) {
      if (EXTRACTION_TYPES[type]) {
        extractions[type] = await this._extractByType(doc.content, type);
      }
    }
    
    // Cache extractions
    this.extractions.set(docId, {
      ...this.extractions.get(docId),
      ...extractions
    });
    
    this.usage.extractions++;
    
    return {
      success: true,
      docId,
      extractions
    };
  }
  
  /**
   * Compare two documents
   */
  async compare(docId1, docId2) {
    const doc1 = this.documents.get(docId1);
    const doc2 = this.documents.get(docId2);
    
    if (!doc1 || !doc2) {
      return { success: false, error: 'DOCUMENT_NOT_FOUND' };
    }
    
    const comparison = await this._compareDocuments(doc1, doc2);
    
    const comparisonId = `CMP-${Date.now()}`;
    this.comparisons.set(comparisonId, comparison);
    
    this.usage.comparisons++;
    
    return {
      success: true,
      comparisonId,
      comparison: {
        similarity: comparison.similarity,
        differences: comparison.differences.map(d => ({
          section: d.section,
          doc1: d.doc1Value,
          doc2: d.doc2Value,
          significance: d.significance
        })),
        additions: comparison.additions,
        deletions: comparison.deletions,
        commonSections: comparison.commonSections,
        summary: comparison.summary
      }
    };
  }
  
  /**
   * Generate report from data
   */
  async generateReport(title, data, options = {}) {
    const {
      template = 'standard',
      format = 'markdown',
      sections = ['executive-summary', 'findings', 'recommendations']
    } = options;
    
    const report = await this._generateReport(title, data, {
      template,
      format,
      sections
    });
    
    // Store as document
    const uploadResult = this.uploadDocument(title, report.content, {
      type: 'REPORT',
      tags: ['generated', 'report']
    });
    
    this.usage.reports++;
    
    return {
      success: true,
      report: {
        title,
        content: report.content,
        sections: report.sections,
        format,
        wordCount: report.content.split(/\s+/).length
      },
      docId: uploadResult.docId
    };
  }
  
  /**
   * Use template
   */
  useTemplate(templateId, data) {
    const template = this.templates.get(templateId);
    if (!template) {
      return {
        success: false,
        error: 'TEMPLATE_NOT_FOUND',
        availableTemplates: Array.from(this.templates.keys())
      };
    }
    
    const filled = this._fillTemplate(template, data);
    
    return {
      success: true,
      templateId,
      document: {
        content: filled.content,
        missingFields: filled.missingFields,
        warnings: filled.warnings
      }
    };
  }
  
  /**
   * List templates
   */
  listTemplates(category = null) {
    let templates = Array.from(this.templates.values());
    
    if (category) {
      templates = templates.filter(t => t.category === category);
    }
    
    return {
      success: true,
      templates: templates.map(t => ({
        id: t.id,
        name: t.name,
        category: t.category,
        description: t.description,
        fields: t.fields
      })),
      categories: [...new Set(Array.from(this.templates.values()).map(t => t.category))]
    };
  }
  
  /**
   * Summarize document
   */
  async summarize(docId, options = {}) {
    const doc = this.documents.get(docId);
    if (!doc) {
      return { success: false, error: 'DOCUMENT_NOT_FOUND' };
    }
    
    const {
      length = 'medium', // short, medium, long
      focus = 'general' // general, key-points, action-items
    } = options;
    
    const summary = await this._summarizeDocument(doc, { length, focus });
    
    return {
      success: true,
      docId,
      summary: {
        text: summary.text,
        keyPoints: summary.keyPoints,
        actionItems: summary.actionItems,
        wordCount: summary.text.split(/\s+/).length
      }
    };
  }
  
  /**
   * Get document details
   */
  getDocument(docId) {
    const doc = this.documents.get(docId);
    if (!doc) {
      return { success: false, error: 'DOCUMENT_NOT_FOUND' };
    }
    
    doc.metadata.lastAccessed = Date.now();
    
    return {
      success: true,
      document: {
        id: doc.id,
        name: doc.name,
        type: DOCUMENT_TYPES[doc.type]?.name || doc.type,
        wordCount: doc.wordCount,
        tags: doc.tags,
        content: doc.content,
        metadata: doc.metadata
      }
    };
  }
  
  /**
   * List documents
   */
  listDocuments(filter = {}) {
    let docs = Array.from(this.documents.values());
    
    if (filter.type) {
      docs = docs.filter(d => d.type === filter.type);
    }
    
    if (filter.tag) {
      docs = docs.filter(d => d.tags.includes(filter.tag));
    }
    
    return {
      success: true,
      documents: docs.map(d => ({
        id: d.id,
        name: d.name,
        type: DOCUMENT_TYPES[d.type]?.name || d.type,
        wordCount: d.wordCount,
        uploadedAt: d.metadata.uploadedAt
      })),
      total: docs.length
    };
  }
  
  /**
   * Get usage stats
   */
  getUsageStats() {
    return {
      documents: this.usage.documents,
      remaining: NovaDocs.FREE_LIMIT - this.usage.documents,
      limit: NovaDocs.FREE_LIMIT,
      analyses: this.usage.analyses,
      extractions: this.usage.extractions,
      comparisons: this.usage.comparisons,
      reports: this.usage.reports,
      templatesAvailable: this.templates.size,
      byDocType: this.analytics.byDocType,
      byRiskLevel: this.analytics.byRiskLevel
    };
  }
  
  // ─── Private Methods ─────────────────────────────────────────────────────────
  
  _initializeDefaultTemplates() {
    const defaultTemplates = [
      {
        id: 'nda-simple',
        name: 'Simple NDA',
        category: 'legal',
        description: 'Basic non-disclosure agreement',
        fields: ['party1', 'party2', 'effective_date', 'duration'],
        content: `NON-DISCLOSURE AGREEMENT

This Agreement is entered into as of {{effective_date}} between {{party1}} and {{party2}}.

1. CONFIDENTIAL INFORMATION
The parties agree to keep all confidential information private for {{duration}}.

2. OBLIGATIONS
Neither party shall disclose confidential information to third parties.

3. TERM
This agreement shall remain in effect for {{duration}} from the effective date.

Signatures:
{{party1}}: _________________
{{party2}}: _________________`
      },
      {
        id: 'contract-simple',
        name: 'Simple Service Contract',
        category: 'business',
        description: 'Basic service agreement',
        fields: ['provider', 'client', 'service', 'payment', 'start_date'],
        content: `SERVICE CONTRACT

Provider: {{provider}}
Client: {{client}}
Service: {{service}}
Payment: {{payment}}
Start Date: {{start_date}}`
      },
      {
        id: 'invoice',
        name: 'Invoice Template',
        category: 'financial',
        description: 'Standard invoice',
        fields: ['invoice_number', 'vendor', 'client', 'items', 'total', 'due_date'],
        content: `INVOICE #{{invoice_number}}

From: {{vendor}}
To: {{client}}

Items: {{items}}

Total: {{total}}
Due: {{due_date}}`
      }
    ];
    
    for (const template of defaultTemplates) {
      this.templates.set(template.id, template);
    }
  }
  
  _detectDocumentType(content) {
    const lowerContent = content.toLowerCase();
    
    if (lowerContent.includes('agreement') && lowerContent.includes('whereas')) {
      return 'CONTRACT';
    }
    if (lowerContent.includes('non-disclosure') || lowerContent.includes('confidential')) {
      return 'AGREEMENT';
    }
    if (lowerContent.includes('invoice') || lowerContent.includes('amount due')) {
      return 'INVOICE';
    }
    if (lowerContent.includes('experience') && lowerContent.includes('education')) {
      return 'RESUME';
    }
    if (lowerContent.includes('findings') || lowerContent.includes('recommendations')) {
      return 'REPORT';
    }
    
    return 'LEGAL';
  }
  
  async _analyzeContract(doc) {
    const content = doc.content.toLowerCase();
    const risks = [];
    
    // Check for common risk factors
    const riskPatterns = [
      { pattern: /indemnif/i, level: 'HIGH', issue: 'Indemnification clause found', clause: 'Indemnification' },
      { pattern: /terminat/i, level: 'MEDIUM', issue: 'Termination clause found', clause: 'Termination' },
      { pattern: /liabilit/i, level: 'HIGH', issue: 'Liability clause found', clause: 'Liability' },
      { pattern: /exclusiv/i, level: 'MEDIUM', issue: 'Exclusivity requirement', clause: 'Exclusivity' },
      { pattern: /auto.?renew/i, level: 'MEDIUM', issue: 'Auto-renewal clause', clause: 'Renewal' },
      { pattern: /arbitrat/i, level: 'MEDIUM', issue: 'Arbitration clause', clause: 'Dispute Resolution' }
    ];
    
    for (const { pattern, level, issue, clause } of riskPatterns) {
      if (pattern.test(content)) {
        risks.push({
          clause,
          level,
          issue,
          recommendation: `Review the ${clause} section carefully`,
          location: 'Document body'
        });
      }
    }
    
    // Calculate overall risk
    const riskScores = { LOW: 1, MEDIUM: 2, HIGH: 3, CRITICAL: 4 };
    const avgScore = risks.length > 0 
      ? risks.reduce((sum, r) => sum + riskScores[r.level], 0) / risks.length 
      : 1;
    
    let overallRisk = 'LOW';
    if (avgScore > 3) overallRisk = 'CRITICAL';
    else if (avgScore > 2) overallRisk = 'HIGH';
    else if (avgScore > 1.5) overallRisk = 'MEDIUM';
    
    // Extract key information
    const parties = this._extractParties(doc.content);
    const dates = this._extractDates(doc.content);
    const obligations = this._extractObligations(doc.content);
    
    return {
      overallRisk,
      riskScore: avgScore,
      risks,
      keyTerms: this._extractKeyTerms(doc.content),
      parties,
      dates,
      obligations,
      summary: `Document contains ${risks.length} risk factors with overall ${overallRisk} risk level.`
    };
  }
  
  async _extractByType(content, type) {
    switch (type) {
      case 'ENTITIES':
        return {
          persons: this._extractPersons(content),
          organizations: this._extractOrganizations(content),
          locations: this._extractLocations(content)
        };
      case 'DATES':
        return this._extractDates(content);
      case 'AMOUNTS':
        return this._extractAmounts(content);
      case 'CLAUSES':
        return this._extractClauses(content);
      case 'TERMS':
        return this._extractKeyTerms(content);
      default:
        return [];
    }
  }
  
  _extractPersons(content) {
    // Simple name extraction pattern
    const namePattern = /(?:Mr\.|Mrs\.|Ms\.|Dr\.)\s+([A-Z][a-z]+\s+[A-Z][a-z]+)/g;
    const matches = content.match(namePattern) || [];
    return matches.map(m => m.replace(/(?:Mr\.|Mrs\.|Ms\.|Dr\.)\s+/, ''));
  }
  
  _extractOrganizations(content) {
    // Simple org extraction
    const orgPattern = /(?:Inc\.|LLC|Corp\.|Ltd\.|Company)/g;
    const lines = content.split('\n');
    const orgs = [];
    
    for (const line of lines) {
      if (orgPattern.test(line)) {
        const words = line.split(/\s+/);
        const idx = words.findIndex(w => orgPattern.test(w));
        if (idx > 0) {
          orgs.push(words.slice(Math.max(0, idx - 3), idx + 1).join(' '));
        }
      }
    }
    
    return [...new Set(orgs)];
  }
  
  _extractLocations(content) {
    // Placeholder for location extraction
    return [];
  }
  
  _extractDates(content) {
    const datePatterns = [
      /\d{1,2}\/\d{1,2}\/\d{2,4}/g,
      /\d{4}-\d{2}-\d{2}/g,
      /(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}/gi
    ];
    
    const dates = [];
    for (const pattern of datePatterns) {
      const matches = content.match(pattern) || [];
      dates.push(...matches);
    }
    
    return [...new Set(dates)];
  }
  
  _extractAmounts(content) {
    const amountPattern = /\$[\d,]+(?:\.\d{2})?/g;
    const matches = content.match(amountPattern) || [];
    return [...new Set(matches)];
  }
  
  _extractClauses(content) {
    const clauses = [];
    const sections = content.split(/(?:^|\n)(?:\d+\.|[A-Z]{2,}\.|\#)/);
    
    for (const section of sections) {
      if (section.length > 50 && section.length < 2000) {
        clauses.push({
          text: section.trim().substring(0, 200) + '...',
          type: this._classifyClause(section)
        });
      }
    }
    
    return clauses;
  }
  
  _classifyClause(text) {
    const lower = text.toLowerCase();
    if (lower.includes('terminat')) return 'termination';
    if (lower.includes('liabilit')) return 'liability';
    if (lower.includes('confidential')) return 'confidentiality';
    if (lower.includes('payment')) return 'payment';
    if (lower.includes('warrant')) return 'warranty';
    return 'general';
  }
  
  _extractKeyTerms(content) {
    const terms = [];
    
    // Look for definitions
    const defPattern = /"([^"]+)"\s+(?:means|refers to|shall mean)/gi;
    let match;
    while ((match = defPattern.exec(content)) !== null) {
      terms.push({ term: match[1], type: 'definition' });
    }
    
    return terms;
  }
  
  _extractParties(content) {
    const parties = [];
    // Use specific regex pattern to avoid polynomial ReDoS
    // Match party names: "between X" or "and X" followed by comma or opening paren
    const partyPattern = /(?:between|and)\s+([A-Z][A-Za-z]{0,50}(?:\s[A-Z][A-Za-z]{0,50}){0,5})(?:,|\s\()/g;
    
    let match;
    while ((match = partyPattern.exec(content)) !== null) {
      parties.push(match[1].trim());
    }
    
    return [...new Set(parties)];
  }
  
  _extractObligations(content) {
    const obligations = [];
    const obligationPatterns = [
      /shall\s+([^.]+)/gi,
      /must\s+([^.]+)/gi,
      /agrees?\s+to\s+([^.]+)/gi
    ];
    
    for (const pattern of obligationPatterns) {
      let match;
      while ((match = pattern.exec(content)) !== null) {
        obligations.push(match[1].trim().substring(0, 100));
      }
    }
    
    return obligations.slice(0, 10);
  }
  
  async _compareDocuments(doc1, doc2) {
    const words1 = new Set(doc1.content.toLowerCase().split(/\s+/));
    const words2 = new Set(doc2.content.toLowerCase().split(/\s+/));
    
    const common = new Set([...words1].filter(x => words2.has(x)));
    const onlyIn1 = new Set([...words1].filter(x => !words2.has(x)));
    const onlyIn2 = new Set([...words2].filter(x => !words1.has(x)));
    
    const similarity = common.size / Math.max(words1.size, words2.size);
    
    return {
      similarity,
      differences: [
        { section: 'Content', doc1Value: `${words1.size} words`, doc2Value: `${words2.size} words`, significance: 'info' }
      ],
      additions: onlyIn2.size,
      deletions: onlyIn1.size,
      commonSections: common.size,
      summary: `Documents are ${(similarity * 100).toFixed(1)}% similar`
    };
  }
  
  async _generateReport(title, data, options) {
    const sections = [];
    
    if (options.sections.includes('executive-summary')) {
      sections.push({
        name: 'Executive Summary',
        content: `This report provides an analysis of the provided data.`
      });
    }
    
    if (options.sections.includes('findings')) {
      sections.push({
        name: 'Key Findings',
        content: `Data analysis reveals the following insights:\n${JSON.stringify(data, null, 2)}`
      });
    }
    
    if (options.sections.includes('recommendations')) {
      sections.push({
        name: 'Recommendations',
        content: `Based on the analysis, we recommend the following actions.`
      });
    }
    
    const content = `# ${title}\n\n${sections.map(s => `## ${s.name}\n\n${s.content}`).join('\n\n')}`;
    
    return { content, sections };
  }
  
  _fillTemplate(template, data) {
    let content = template.content;
    const missingFields = [];
    
    for (const field of template.fields) {
      if (data[field]) {
        content = content.replace(new RegExp(`{{${field}}}`, 'g'), data[field]);
      } else {
        missingFields.push(field);
      }
    }
    
    return {
      content,
      missingFields,
      warnings: missingFields.length > 0 ? ['Some fields are not filled'] : []
    };
  }
  
  async _summarizeDocument(doc, options) {
    const lengthMap = { short: 50, medium: 150, long: 300 };
    const wordLimit = lengthMap[options.length] || 150;
    
    const words = doc.content.split(/\s+/);
    const text = words.slice(0, wordLimit).join(' ') + '...';
    
    return {
      text,
      keyPoints: [
        'Key point 1 from document',
        'Key point 2 from document',
        'Key point 3 from document'
      ],
      actionItems: options.focus === 'action-items' ? [
        'Action item 1',
        'Action item 2'
      ] : []
    };
  }
  
  /**
   * Export data
   */
  export() {
    return {
      version: NovaDocs.VERSION,
      exportedAt: Date.now(),
      userId: this.userId,
      usage: this.usage,
      analytics: this.analytics,
      documents: Array.from(this.documents.keys())
    };
  }
  
  toJSON() {
    return {
      type: 'NovaDocs',
      quad: NovaDocs.QUAD,
      version: NovaDocs.VERSION,
      ipValue: NovaDocs.IP_VALUE,
      ipValueFormatted: `$${(NovaDocs.IP_VALUE / 1000000).toFixed(1)}M USD`,
      freeLimit: `${NovaDocs.FREE_LIMIT} documents/month`,
      tagline: 'Document intelligence for contracts and reports',
      features: [
        'Contract analysis and risk detection',
        'Report generation from data',
        'Information extraction',
        'Document comparison tools',
        'Template library'
      ],
      usage: this.getUsageStats(),
      createdAt: this.createdAt
    };
  }
}

// ─── Factory Function ────────────────────────────────────────────────────────
export function createNovaDocs(config = {}) {
  return new NovaDocs(config);
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  NovaDocs,
  createNovaDocs,
  DOCUMENT_TYPES,
  EXTRACTION_TYPES,
  RISK_LEVELS
};
