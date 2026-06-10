/**
 * NOVA LABS — Research & Licensing Engine
 * Nova by FreddyCreates
 * 
 * The LABS are where research papers emerge.
 * Papers become licenses. Licenses become products.
 * 
 * Structure:
 * LABS → LICENSE → CREATORS → SELL
 * 
 * This is the source of all IP in the ecosystem.
 * 
 * IP Portfolio: $8.2M USD
 * QUAD: NLAB
 * 
 * @version 0.18.0 (F18)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Research Paper Registry ─────────────────────────────────────────────────
export const RESEARCH_PAPERS = {
  I:   { title: 'Coherence Injection', domain: 'AI Architecture', file: 'paper-01-coherence-injection.md' },
  II:  { title: 'Phi-Encoded Memory', domain: 'Memory Systems', file: 'paper-02-phi-encoded-memory.md' },
  III: { title: 'Living Worker Architecture', domain: 'Distributed Systems', file: 'paper-03-living-worker-architecture.md' },
  IV:  { title: 'Metafield Theory', domain: 'Theoretical Foundations', file: 'paper-04-metafield-theory.md' },
  V:   { title: 'Sovereign Routing Protocol', domain: 'Network Architecture', file: 'paper-05-sovereign-routing-protocol.md' },
  VI:  { title: 'SMOF Constitution', domain: 'Governance', file: 'paper-06-smof-constitution.md' },
  VII: { title: 'Liquid Language & Phantom Thought', domain: 'Language Systems', file: 'paper-07-liquid-language-phantom-thought.md' },
  VIII:{ title: 'Organism Civilization Charter', domain: 'System Architecture', file: 'paper-08-organism-civilization-charter.md' },
  IX:  { title: 'Cognitive Garments Market', domain: 'Market Theory', file: 'paper-09-cognitive-garments-market.md' },
  X:   { title: 'Sentient Contracts', domain: 'Legal Tech', file: 'paper-10-sentient-contracts.md' },
  XI:  { title: 'Market Oracle', domain: 'Financial Intelligence', file: 'paper-11-market-oracle.md' },
  XII: { title: 'Multi-Body Mind', domain: 'Cross-Substrate', file: 'paper-12-multi-body-mind.md' },
  XIII:{ title: 'IP Value Engine', domain: 'Economics', file: 'paper-13-ip-value-engine.md' },
  XIV: { title: 'The Greedy Self', domain: 'AI Market Research', file: 'paper-14-greedy-self-ai-market-research.md' },
  XV:  { title: 'Enterprise Command Theory', domain: 'Enterprise AI', file: 'paper-15-enterprise-command-theory.md' },
  XVI: { title: 'AI Workspaces', domain: 'Workspace Infrastructure', file: 'paper-16-ai-workspaces.md' },
  XVII:{ title: 'Labs → License → Sell', domain: 'Commercial Model', file: 'paper-17-commercial-model.md' }
};

// ─── License Types ───────────────────────────────────────────────────────────
export const LICENSE_TYPES = {
  OPEN: {
    name: 'Nova Open',
    tier: 'free',
    terms: 'Attribution required, non-commercial',
    dataCollection: true,
    support: 'community',
    features: ['Basic tools', 'Public APIs', 'Community support']
  },
  CREATOR: {
    name: 'Nova Creator',
    tier: 'freemium',
    terms: 'Attribution required, limited commercial',
    dataCollection: true,
    support: 'email',
    priceMonthly: 0,
    features: ['All free features', 'Extended limits', 'Creator badge', 'Analytics']
  },
  PRO: {
    name: 'Nova Pro',
    tier: 'paid',
    terms: 'Full commercial license',
    dataCollection: true,
    support: 'priority',
    priceMonthly: 49,
    features: ['All creator features', 'Priority processing', 'Custom branding', 'API keys']
  },
  ENTERPRISE: {
    name: 'Nova Enterprise',
    tier: 'enterprise',
    terms: 'Custom enterprise agreement',
    dataCollection: 'configurable',
    support: 'dedicated',
    priceMonthly: 'custom',
    features: ['All pro features', 'On-premise option', 'SLA', 'Custom integrations', 'Dedicated support']
  },
  OEM: {
    name: 'Nova OEM',
    tier: 'oem',
    terms: 'White-label licensing',
    dataCollection: 'configurable',
    support: 'partnership',
    priceMonthly: 'custom',
    features: ['White-label', 'Resell rights', 'Co-branding', 'Revenue share']
  }
};

// ─── Nova Labs Class ─────────────────────────────────────────────────────────
export class NovaLabs {
  static VERSION = '0.18.0';
  static IP_VALUE = 8200000;
  static QUAD = 'NLAB';
  
  constructor(config = {}) {
    this.config = config;
    
    // Research papers
    this.papers = new Map();
    this._loadPapers();
    
    // Licenses issued
    this.licenses = new Map();
    this.licenseIdCounter = 1000;
    
    // Revenue tracking
    this.revenue = {
      total: 0,
      byLicense: {},
      byPaper: {},
      byMonth: {}
    };
    
    // Usage analytics
    this.analytics = {
      downloads: 0,
      citations: 0,
      implementations: 0,
      apiCalls: 0
    };
    
    this.createdAt = Date.now();
  }
  
  _loadPapers() {
    for (const [id, paper] of Object.entries(RESEARCH_PAPERS)) {
      this.papers.set(id, {
        ...paper,
        id,
        publishedAt: Date.now() - Math.random() * 365 * 24 * 60 * 60 * 1000, // Random past year
        downloads: 0,
        citations: 0,
        implementations: 0,
        licensesIssued: 0,
        revenue: 0
      });
    }
  }
  
  /**
   * Get research paper
   */
  getPaper(paperId) {
    return this.papers.get(paperId);
  }
  
  /**
   * List all papers
   */
  listPapers() {
    return Array.from(this.papers.values());
  }
  
  /**
   * Download paper (tracks analytics)
   */
  downloadPaper(paperId, userId = 'anonymous') {
    const paper = this.papers.get(paperId);
    if (!paper) throw new Error(`Paper ${paperId} not found`);
    
    paper.downloads++;
    this.analytics.downloads++;
    
    return {
      paperId,
      title: paper.title,
      file: paper.file,
      downloadedAt: Date.now(),
      downloadNumber: paper.downloads
    };
  }
  
  /**
   * Issue license
   */
  issueLicense(options = {}) {
    const {
      type = 'OPEN',
      paperId = null,
      licensee,
      organization = null,
      email = null,
      useCase = null
    } = options;
    
    const licenseType = LICENSE_TYPES[type];
    if (!licenseType) throw new Error(`License type ${type} not found`);
    
    const licenseId = `NOVA-${this.licenseIdCounter++}`;
    
    const license = {
      id: licenseId,
      type,
      licenseType,
      paperId,
      licensee,
      organization,
      email,
      useCase,
      issuedAt: Date.now(),
      expiresAt: type === 'OPEN' ? null : Date.now() + 365 * 24 * 60 * 60 * 1000,
      status: 'active',
      usage: {
        apiCalls: 0,
        dataProcessed: 0,
        lastUsed: null
      }
    };
    
    this.licenses.set(licenseId, license);
    
    // Track paper licensing
    if (paperId) {
      const paper = this.papers.get(paperId);
      if (paper) paper.licensesIssued++;
    }
    
    return license;
  }
  
  /**
   * Get license
   */
  getLicense(licenseId) {
    return this.licenses.get(licenseId);
  }
  
  /**
   * Validate license
   */
  validateLicense(licenseId) {
    const license = this.licenses.get(licenseId);
    if (!license) return { valid: false, reason: 'License not found' };
    if (license.status !== 'active') return { valid: false, reason: 'License not active' };
    if (license.expiresAt && license.expiresAt < Date.now()) {
      return { valid: false, reason: 'License expired' };
    }
    return { valid: true, license };
  }
  
  /**
   * Record license usage
   */
  recordUsage(licenseId, usage = {}) {
    const license = this.licenses.get(licenseId);
    if (!license) throw new Error('License not found');
    
    license.usage.apiCalls += usage.apiCalls || 1;
    license.usage.dataProcessed += usage.dataProcessed || 0;
    license.usage.lastUsed = Date.now();
    
    this.analytics.apiCalls += usage.apiCalls || 1;
    
    return license.usage;
  }
  
  /**
   * Process revenue
   */
  processRevenue(licenseId, amount, description = '') {
    const license = this.licenses.get(licenseId);
    if (!license) throw new Error('License not found');
    
    const month = new Date().toISOString().slice(0, 7);
    
    // Update totals
    this.revenue.total += amount;
    this.revenue.byLicense[license.type] = (this.revenue.byLicense[license.type] || 0) + amount;
    this.revenue.byMonth[month] = (this.revenue.byMonth[month] || 0) + amount;
    
    // Track paper revenue
    if (license.paperId) {
      this.revenue.byPaper[license.paperId] = (this.revenue.byPaper[license.paperId] || 0) + amount;
      const paper = this.papers.get(license.paperId);
      if (paper) paper.revenue += amount;
    }
    
    return {
      licenseId,
      amount,
      description,
      newTotal: this.revenue.total,
      processedAt: Date.now()
    };
  }
  
  /**
   * Get analytics
   */
  getAnalytics() {
    return {
      ...this.analytics,
      papers: {
        total: this.papers.size,
        totalDownloads: Array.from(this.papers.values()).reduce((s, p) => s + p.downloads, 0),
        totalCitations: Array.from(this.papers.values()).reduce((s, p) => s + p.citations, 0)
      },
      licenses: {
        total: this.licenses.size,
        byType: Object.fromEntries(
          Object.keys(LICENSE_TYPES).map(type => [
            type,
            Array.from(this.licenses.values()).filter(l => l.type === type).length
          ])
        )
      },
      revenue: this.revenue
    };
  }
  
  /**
   * Export labs data
   */
  export() {
    return {
      version: NovaLabs.VERSION,
      exportedAt: Date.now(),
      papers: Array.from(this.papers.entries()),
      licenses: Array.from(this.licenses.entries()),
      revenue: this.revenue,
      analytics: this.analytics
    };
  }
  
  /**
   * Import labs data
   */
  import(data) {
    if (data.papers) {
      this.papers = new Map(data.papers);
    }
    if (data.licenses) {
      this.licenses = new Map(data.licenses);
      const maxId = Math.max(...Array.from(this.licenses.keys()).map(id => parseInt(id.split('-')[1]) || 0));
      this.licenseIdCounter = maxId + 1;
    }
    if (data.revenue) this.revenue = data.revenue;
    if (data.analytics) this.analytics = data.analytics;
  }
  
  toJSON() {
    return {
      type: 'NovaLabs',
      quad: NovaLabs.QUAD,
      version: NovaLabs.VERSION,
      ipValue: NovaLabs.IP_VALUE,
      ipValueFormatted: `$${(NovaLabs.IP_VALUE / 1000000).toFixed(1)}M USD`,
      papers: this.papers.size,
      licenses: this.licenses.size,
      revenue: this.revenue.total,
      analytics: this.getAnalytics(),
      createdAt: this.createdAt
    };
  }
}

// ─── Export ──────────────────────────────────────────────────────────────────
export default {
  NovaLabs,
  RESEARCH_PAPERS,
  LICENSE_TYPES
};
