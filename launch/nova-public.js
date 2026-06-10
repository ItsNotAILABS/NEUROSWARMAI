/**
 * NOVA PUBLIC — Free Tools for Mass Adoption
 * Nova by FreddyCreates
 * 
 * FREE platforms and tools for everyone.
 * Mass adoption strategy: Give value first, collect data, build ecosystem.
 * 
 * Target Users:
 * - Developers wanting AI coding assistance
 * - Creators wanting AI creative tools
 * - Students wanting AI learning tools
 * - Anyone who wants to try AI
 * 
 * Revenue Model:
 * - Freemium (free tier with limits, paid upgrades)
 * - Data collection (anonymized usage for AI improvement)
 * - Lead generation (enterprise upsell)
 * 
 * IP Portfolio: $9.5M USD
 * QUAD: NPUB
 * 
 * @version 0.18.0 (F18)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Public Product Registry ─────────────────────────────────────────────────
export const PUBLIC_PRODUCTS = {
  // Developer Tools
  NOVA_CODE: {
    name: 'Nova Code',
    tagline: 'AI coding assistant that remembers your codebase',
    category: 'Developer',
    freeLimit: '1000 completions/month',
    domain: 'code-assist',
    launchUrl: 'nova.ai/code',
    features: [
      'Code completion',
      'Bug detection',
      'Refactoring suggestions',
      'Documentation generation',
      'Session memory (remembers codebase)'
    ],
    dataCollected: ['usage patterns', 'anonymized code metrics', 'performance data']
  },
  
  NOVA_DEBUG: {
    name: 'Nova Debug',
    tagline: 'AI debugger that understands errors, not just finds them',
    category: 'Developer',
    freeLimit: '500 debug sessions/month',
    domain: 'debug-assist',
    launchUrl: 'nova.ai/debug',
    features: [
      'Stack trace analysis',
      'Root cause detection',
      'Fix suggestions',
      'Error pattern learning',
      'Cross-project error library'
    ],
    dataCollected: ['error signatures', 'fix effectiveness', 'debug patterns']
  },
  
  NOVA_DATA: {
    name: 'Nova Data',
    tagline: 'AI that turns your data into insights',
    category: 'Developer',
    freeLimit: '100 analyses/month, 10MB data',
    domain: 'data-assist',
    launchUrl: 'nova.ai/data',
    features: [
      'Data visualization',
      'Pattern detection',
      'Report generation',
      'SQL assistance',
      'Schema understanding'
    ],
    dataCollected: ['query patterns', 'schema structures', 'insight types']
  },
  
  // Creative Tools
  NOVA_CREATE: {
    name: 'Nova Create',
    tagline: 'AI creativity partner for ideation and content',
    category: 'Creative',
    freeLimit: '500 generations/month',
    domain: 'creative-assist',
    launchUrl: 'nova.ai/create',
    features: [
      'Content ideation',
      'Writing assistance',
      'Style adaptation',
      'Brand voice learning',
      'Multi-format output'
    ],
    dataCollected: ['content preferences', 'style patterns', 'engagement metrics']
  },
  
  NOVA_STUDIO: {
    name: 'Nova Studio',
    tagline: 'AI-powered creative workspace',
    category: 'Creative',
    freeLimit: '200 projects/month',
    domain: 'studio',
    launchUrl: 'nova.ai/studio',
    features: [
      'Project management',
      'Asset generation',
      'Collaboration tools',
      'Version control',
      'Export to any format'
    ],
    dataCollected: ['workflow patterns', 'collaboration data', 'output preferences']
  },
  
  // Learning Tools
  NOVA_LEARN: {
    name: 'Nova Learn',
    tagline: 'AI tutor that adapts to how you learn',
    category: 'Learning',
    freeLimit: 'Unlimited basic courses',
    domain: 'learning',
    launchUrl: 'nova.ai/learn',
    features: [
      'Adaptive learning',
      'Personalized curriculum',
      'Progress tracking',
      'Knowledge graphs',
      'Skill assessment'
    ],
    dataCollected: ['learning patterns', 'skill progression', 'content effectiveness']
  },
  
  // Research Tools
  NOVA_RESEARCH: {
    name: 'Nova Research',
    tagline: 'AI research assistant for knowledge synthesis',
    category: 'Research',
    freeLimit: '100 searches/month',
    domain: 'research',
    launchUrl: 'nova.ai/research',
    features: [
      'Paper summarization',
      'Citation management',
      'Knowledge synthesis',
      'Hypothesis generation',
      'Research graph building'
    ],
    dataCollected: ['research interests', 'citation patterns', 'discovery paths']
  },
  
  // Business Tools
  NOVA_DOCS: {
    name: 'Nova Docs',
    tagline: 'AI document intelligence for contracts and reports',
    category: 'Business',
    freeLimit: '50 documents/month',
    domain: 'documents',
    launchUrl: 'nova.ai/docs',
    features: [
      'Contract analysis',
      'Report generation',
      'Information extraction',
      'Comparison tools',
      'Template library'
    ],
    dataCollected: ['document structures', 'extraction accuracy', 'use cases']
  }
};

// ─── User Tier Definitions ───────────────────────────────────────────────────
export const USER_TIERS = {
  FREE: {
    name: 'Free',
    price: 0,
    limits: {
      apiCallsPerDay: 100,
      storageGB: 1,
      projectsActive: 5,
      teamMembers: 1
    },
    features: [
      'Access to all public tools',
      'Basic support',
      'Community forums',
      'Nova branding on outputs'
    ]
  },
  CREATOR: {
    name: 'Creator',
    price: 0,
    requirements: ['email verification', 'public profile'],
    limits: {
      apiCallsPerDay: 500,
      storageGB: 5,
      projectsActive: 20,
      teamMembers: 1
    },
    features: [
      'All Free features',
      'Increased limits',
      'Creator badge',
      'Analytics dashboard',
      'Priority processing'
    ]
  },
  PRO: {
    name: 'Pro',
    price: 49,
    limits: {
      apiCallsPerDay: 5000,
      storageGB: 50,
      projectsActive: 100,
      teamMembers: 5
    },
    features: [
      'All Creator features',
      'Remove Nova branding',
      'API access',
      'Priority support',
      'Custom integrations'
    ]
  },
  TEAM: {
    name: 'Team',
    price: 199,
    limits: {
      apiCallsPerDay: 20000,
      storageGB: 200,
      projectsActive: 500,
      teamMembers: 25
    },
    features: [
      'All Pro features',
      'Team management',
      'Shared workspaces',
      'Admin controls',
      'Usage analytics',
      'SSO integration'
    ]
  }
};

// ─── Nova Public Class ───────────────────────────────────────────────────────
export class NovaPublic {
  static VERSION = '0.18.0';
  static IP_VALUE = 9500000;
  static QUAD = 'NPUB';
  
  constructor(config = {}) {
    this.config = config;
    
    // Products
    this.products = new Map();
    for (const [id, product] of Object.entries(PUBLIC_PRODUCTS)) {
      this.products.set(id, { ...product, id, users: 0, usage: 0 });
    }
    
    // Users
    this.users = new Map();
    this.userIdCounter = 100000;
    
    // Data collection
    this.dataCollection = {
      sessions: [],
      events: [],
      metrics: {},
      consents: new Map()
    };
    
    // Analytics
    this.analytics = {
      totalUsers: 0,
      activeUsers: 0,
      totalSessions: 0,
      totalEvents: 0,
      byProduct: {},
      byTier: { FREE: 0, CREATOR: 0, PRO: 0, TEAM: 0 }
    };
    
    this.createdAt = Date.now();
  }
  
  /**
   * Register new user
   */
  registerUser(userData = {}) {
    const userId = `NOVA-U-${this.userIdCounter++}`;
    
    const user = {
      id: userId,
      email: userData.email,
      name: userData.name || 'Anonymous',
      tier: 'FREE',
      products: [],
      usage: {
        apiCalls: 0,
        storage: 0,
        lastActive: Date.now()
      },
      consents: {
        dataCollection: userData.dataConsent !== false,
        marketing: userData.marketingConsent || false,
        analytics: userData.analyticsConsent !== false
      },
      referralCode: this._generateReferralCode(userId),
      referredBy: userData.referralCode || null,
      createdAt: Date.now()
    };
    
    this.users.set(userId, user);
    this.analytics.totalUsers++;
    this.analytics.byTier[user.tier]++;
    
    // Track referral
    if (user.referredBy) {
      this._trackReferral(user.referredBy, userId);
    }
    
    return user;
  }
  
  _generateReferralCode(userId) {
    return `NOVA-${userId.split('-')[2]}-${Math.random().toString(36).substr(2, 4).toUpperCase()}`;
  }
  
  _trackReferral(referralCode, newUserId) {
    for (const user of this.users.values()) {
      if (user.referralCode === referralCode) {
        user.referrals = user.referrals || [];
        user.referrals.push({ userId: newUserId, at: Date.now() });
        break;
      }
    }
  }
  
  /**
   * Upgrade user tier
   */
  upgradeTier(userId, newTier) {
    const user = this.users.get(userId);
    if (!user) throw new Error('User not found');
    
    const oldTier = user.tier;
    this.analytics.byTier[oldTier]--;
    
    user.tier = newTier;
    user.upgradedAt = Date.now();
    
    this.analytics.byTier[newTier]++;
    
    return {
      userId,
      oldTier,
      newTier,
      limits: USER_TIERS[newTier].limits,
      upgradedAt: user.upgradedAt
    };
  }
  
  /**
   * Activate product for user
   */
  activateProduct(userId, productId) {
    const user = this.users.get(userId);
    if (!user) throw new Error('User not found');
    
    const product = this.products.get(productId);
    if (!product) throw new Error('Product not found');
    
    if (!user.products.includes(productId)) {
      user.products.push(productId);
      product.users++;
    }
    
    this.analytics.byProduct[productId] = (this.analytics.byProduct[productId] || 0) + 1;
    
    return {
      userId,
      productId,
      product: product.name,
      limits: this._getProductLimits(user.tier, productId),
      activatedAt: Date.now()
    };
  }
  
  _getProductLimits(tier, productId) {
    const tierLimits = USER_TIERS[tier].limits;
    const product = PUBLIC_PRODUCTS[productId];
    
    // Scale limits based on tier multiplier
    const multipliers = { FREE: 1, CREATOR: 5, PRO: 50, TEAM: 200 };
    const mult = multipliers[tier] || 1;
    
    return {
      dailyCalls: tierLimits.apiCallsPerDay,
      monthlyLimit: product.freeLimit.split(' ')[0] * mult,
      storage: tierLimits.storageGB
    };
  }
  
  /**
   * Record user activity (for data collection)
   */
  recordActivity(userId, activity = {}) {
    const user = this.users.get(userId);
    if (!user) throw new Error('User not found');
    if (!user.consents.dataCollection) return { recorded: false, reason: 'No consent' };
    
    const event = {
      id: `EVT-${Date.now()}-${Math.random().toString(36).substr(2, 6)}`,
      userId,
      type: activity.type || 'usage',
      product: activity.product,
      action: activity.action,
      metadata: this._anonymizeData(activity.metadata || {}),
      timestamp: Date.now()
    };
    
    this.dataCollection.events.push(event);
    this.analytics.totalEvents++;
    
    // Update user activity
    user.usage.apiCalls++;
    user.usage.lastActive = Date.now();
    
    // Update product usage
    if (activity.product) {
      const product = this.products.get(activity.product);
      if (product) product.usage++;
    }
    
    return { recorded: true, eventId: event.id };
  }
  
  _anonymizeData(data) {
    // Remove PII, keep usage patterns
    const anonymized = { ...data };
    delete anonymized.email;
    delete anonymized.name;
    delete anonymized.ip;
    delete anonymized.phone;
    return anonymized;
  }
  
  /**
   * Start session (tracks for engagement)
   */
  startSession(userId, productId) {
    const sessionId = `SES-${Date.now()}-${Math.random().toString(36).substr(2, 8)}`;
    
    const session = {
      id: sessionId,
      userId,
      productId,
      startedAt: Date.now(),
      endedAt: null,
      events: 0,
      active: true
    };
    
    this.dataCollection.sessions.push(session);
    this.analytics.totalSessions++;
    this.analytics.activeUsers = this._countActiveUsers();
    
    return session;
  }
  
  /**
   * End session
   */
  endSession(sessionId) {
    const session = this.dataCollection.sessions.find(s => s.id === sessionId);
    if (!session) throw new Error('Session not found');
    
    session.endedAt = Date.now();
    session.active = false;
    session.duration = session.endedAt - session.startedAt;
    
    this.analytics.activeUsers = this._countActiveUsers();
    
    return session;
  }
  
  _countActiveUsers() {
    const oneHourAgo = Date.now() - 60 * 60 * 1000;
    return this.dataCollection.sessions.filter(s => s.active || s.endedAt > oneHourAgo).length;
  }
  
  /**
   * Get aggregated data insights
   */
  getDataInsights() {
    return {
      userMetrics: {
        total: this.analytics.totalUsers,
        active: this.analytics.activeUsers,
        byTier: this.analytics.byTier,
        conversionRate: this._calculateConversionRate()
      },
      productMetrics: {
        byProduct: Object.fromEntries(
          Array.from(this.products.values()).map(p => [p.id, { users: p.users, usage: p.usage }])
        )
      },
      engagementMetrics: {
        totalSessions: this.analytics.totalSessions,
        totalEvents: this.analytics.totalEvents,
        avgSessionDuration: this._avgSessionDuration(),
        avgEventsPerSession: this.analytics.totalEvents / Math.max(this.analytics.totalSessions, 1)
      }
    };
  }
  
  _calculateConversionRate() {
    const paid = this.analytics.byTier.PRO + this.analytics.byTier.TEAM;
    return this.analytics.totalUsers > 0 ? paid / this.analytics.totalUsers : 0;
  }
  
  _avgSessionDuration() {
    const completed = this.dataCollection.sessions.filter(s => s.duration);
    if (completed.length === 0) return 0;
    return completed.reduce((sum, s) => sum + s.duration, 0) / completed.length;
  }
  
  /**
   * Get products list (for marketing)
   */
  getProductsForMarketing() {
    return Array.from(this.products.values()).map(p => ({
      id: p.id,
      name: p.name,
      tagline: p.tagline,
      category: p.category,
      freeLimit: p.freeLimit,
      launchUrl: p.launchUrl,
      features: p.features,
      users: p.users
    }));
  }
  
  /**
   * Export data
   */
  export() {
    return {
      version: NovaPublic.VERSION,
      exportedAt: Date.now(),
      users: Array.from(this.users.entries()),
      analytics: this.analytics,
      products: Array.from(this.products.entries())
    };
  }
  
  /**
   * Import data
   */
  import(data) {
    if (data.users) {
      this.users = new Map(data.users);
      const maxId = Math.max(...Array.from(this.users.keys()).map(id => parseInt(id.split('-')[2]) || 0));
      this.userIdCounter = maxId + 1;
    }
    if (data.analytics) this.analytics = data.analytics;
    if (data.products) this.products = new Map(data.products);
  }
  
  toJSON() {
    return {
      type: 'NovaPublic',
      quad: NovaPublic.QUAD,
      version: NovaPublic.VERSION,
      ipValue: NovaPublic.IP_VALUE,
      ipValueFormatted: `$${(NovaPublic.IP_VALUE / 1000000).toFixed(1)}M USD`,
      products: this.products.size,
      users: this.analytics.totalUsers,
      activeUsers: this.analytics.activeUsers,
      insights: this.getDataInsights(),
      createdAt: this.createdAt
    };
  }
}

// ─── Export ──────────────────────────────────────────────────────────────────
export default {
  NovaPublic,
  PUBLIC_PRODUCTS,
  USER_TIERS
};
