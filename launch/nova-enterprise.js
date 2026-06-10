/**
 * NOVA ENTERPRISE — Revenue Generation Engine
 * Nova by FreddyCreates
 * 
 * Enterprise sales, partnerships, and revenue operations.
 * 
 * Revenue Streams:
 * 1. Subscription (Pro/Team/Enterprise)
 * 2. Usage-based (API calls, compute, storage)
 * 3. Licensing (OEM, white-label)
 * 4. Professional Services (implementation, training)
 * 5. Partnerships (reseller, integrations)
 * 
 * Target: $10M ARR Year 1, $100M ARR Year 3
 * 
 * IP Portfolio: $12.4M USD
 * QUAD: NENT
 * 
 * @version 0.18.0 (F18)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Enterprise Products ─────────────────────────────────────────────────────
export const ENTERPRISE_PRODUCTS = {
  NOVA_ENTERPRISE: {
    name: 'Nova Enterprise Platform',
    type: 'subscription',
    description: 'Full access to all Nova AI platforms with enterprise features',
    basePrice: 2499,
    priceModel: 'per month',
    includes: [
      'All 15 Cognitive Garment platforms',
      'Unlimited API calls',
      'On-premise deployment option',
      'SSO/SAML integration',
      'Dedicated account manager',
      '99.9% SLA',
      'Custom training'
    ]
  },
  
  NOVA_PRIVATE_CLOUD: {
    name: 'Nova Private Cloud',
    type: 'deployment',
    description: 'Dedicated Nova infrastructure in your cloud',
    basePrice: 9999,
    priceModel: 'per month',
    includes: [
      'Private VPC deployment',
      'Data residency compliance',
      'Custom security controls',
      'Isolated compute',
      'Direct support line'
    ]
  },
  
  NOVA_API_PRO: {
    name: 'Nova API Pro',
    type: 'usage',
    description: 'High-volume API access with SLA',
    pricing: {
      calls: { rate: 0.001, unit: 'per call', volumeDiscounts: true },
      compute: { rate: 0.02, unit: 'per compute-minute' },
      storage: { rate: 0.10, unit: 'per GB-month' }
    },
    volumeDiscounts: [
      { threshold: 100000, discount: 0.10 },
      { threshold: 1000000, discount: 0.25 },
      { threshold: 10000000, discount: 0.40 }
    ]
  },
  
  NOVA_OEM: {
    name: 'Nova OEM License',
    type: 'license',
    description: 'White-label Nova technology in your products',
    pricing: 'custom',
    models: [
      { name: 'Royalty', terms: '% of revenue using Nova tech' },
      { name: 'Flat Fee', terms: 'Annual licensing fee' },
      { name: 'Hybrid', terms: 'Base fee + reduced royalty' }
    ],
    includes: [
      'White-label rights',
      'Remove all Nova branding',
      'Resell to customers',
      'Custom integrations',
      'Technical partnership'
    ]
  },
  
  NOVA_PROFESSIONAL_SERVICES: {
    name: 'Nova Professional Services',
    type: 'services',
    description: 'Implementation, training, and consulting',
    offerings: [
      { name: 'Implementation', rate: 250, unit: 'per hour', description: 'Setup and integration' },
      { name: 'Training', rate: 500, unit: 'per session', description: '2-hour team training' },
      { name: 'Consulting', rate: 350, unit: 'per hour', description: 'AI strategy consulting' },
      { name: 'Custom Development', rate: 300, unit: 'per hour', description: 'Custom features' }
    ]
  }
};

// ─── Partnership Types ───────────────────────────────────────────────────────
export const PARTNERSHIP_TYPES = {
  RESELLER: {
    name: 'Reseller Partner',
    commission: 0.20,
    requirements: ['Sales certification', '5+ deals/year'],
    benefits: ['Reseller discount', 'Marketing materials', 'Lead referrals']
  },
  TECHNOLOGY: {
    name: 'Technology Partner',
    commission: 0.15,
    requirements: ['Technical certification', 'Integration built'],
    benefits: ['API priority access', 'Co-marketing', 'Integration showcase']
  },
  CONSULTING: {
    name: 'Consulting Partner',
    commission: 0.25,
    requirements: ['AI expertise', '3+ implementations'],
    benefits: ['Referral bonus', 'Training resources', 'Customer success support']
  },
  STRATEGIC: {
    name: 'Strategic Partner',
    commission: 'custom',
    requirements: ['Large customer base', 'Strategic alignment'],
    benefits: ['Custom pricing', 'Joint product development', 'Executive sponsorship']
  }
};

// ─── Nova Enterprise Class ───────────────────────────────────────────────────
export class NovaEnterprise {
  static VERSION = '0.18.0';
  static IP_VALUE = 12400000;
  static QUAD = 'NENT';
  
  constructor(config = {}) {
    this.config = config;
    
    // Customers
    this.customers = new Map();
    this.customerIdCounter = 10000;
    
    // Deals/Opportunities
    this.deals = new Map();
    this.dealIdCounter = 1000;
    
    // Partnerships
    this.partners = new Map();
    this.partnerIdCounter = 500;
    
    // Revenue tracking
    this.revenue = {
      total: 0,
      mrr: 0,  // Monthly Recurring Revenue
      arr: 0,  // Annual Recurring Revenue
      byProduct: {},
      byCustomer: {},
      byMonth: {}
    };
    
    // Pipeline
    this.pipeline = {
      total: 0,
      byStage: {
        lead: 0,
        qualified: 0,
        proposal: 0,
        negotiation: 0,
        closed: 0,
        lost: 0
      }
    };
    
    this.createdAt = Date.now();
  }
  
  /**
   * Register enterprise customer
   */
  registerCustomer(customerData = {}) {
    const customerId = `NOVA-C-${this.customerIdCounter++}`;
    
    const customer = {
      id: customerId,
      company: customerData.company,
      industry: customerData.industry,
      size: customerData.size || 'unknown',  // SMB, Mid-Market, Enterprise
      contacts: customerData.contacts || [],
      products: [],
      subscriptions: [],
      status: 'prospect',
      revenue: {
        total: 0,
        mrr: 0,
        arr: 0
      },
      usageMetrics: {
        apiCalls: 0,
        storage: 0,
        compute: 0
      },
      createdAt: Date.now()
    };
    
    this.customers.set(customerId, customer);
    
    return customer;
  }
  
  /**
   * Create sales deal
   */
  createDeal(dealData = {}) {
    const dealId = `NOVA-D-${this.dealIdCounter++}`;
    
    const deal = {
      id: dealId,
      customerId: dealData.customerId,
      company: dealData.company,
      product: dealData.product,
      value: dealData.value || 0,
      stage: 'lead',
      probability: 0.1,
      closeDate: dealData.closeDate || Date.now() + 90 * 24 * 60 * 60 * 1000,  // 90 days
      contacts: dealData.contacts || [],
      notes: dealData.notes || [],
      activities: [],
      createdAt: Date.now()
    };
    
    this.deals.set(dealId, deal);
    this._updatePipeline();
    
    return deal;
  }
  
  /**
   * Update deal stage
   */
  updateDealStage(dealId, newStage, notes = '') {
    const deal = this.deals.get(dealId);
    if (!deal) throw new Error('Deal not found');
    
    const stageProbabilities = {
      lead: 0.1,
      qualified: 0.25,
      proposal: 0.50,
      negotiation: 0.75,
      closed: 1.0,
      lost: 0.0
    };
    
    const oldStage = deal.stage;
    deal.stage = newStage;
    deal.probability = stageProbabilities[newStage] || 0;
    
    deal.activities.push({
      type: 'stage_change',
      from: oldStage,
      to: newStage,
      notes,
      at: Date.now()
    });
    
    // If closed won, process revenue
    if (newStage === 'closed') {
      this._processDealWon(deal);
    }
    
    this._updatePipeline();
    
    return deal;
  }
  
  _processDealWon(deal) {
    // Update customer
    if (deal.customerId) {
      const customer = this.customers.get(deal.customerId);
      if (customer) {
        customer.status = 'customer';
        customer.products.push(deal.product);
        customer.revenue.total += deal.value;
        
        // If subscription, add to MRR
        const product = ENTERPRISE_PRODUCTS[deal.product];
        if (product && (product.type === 'subscription' || product.type === 'deployment')) {
          customer.revenue.mrr += deal.value;
          customer.revenue.arr = customer.revenue.mrr * 12;
        }
      }
    }
    
    // Update revenue
    this._recordRevenue(deal.value, deal.product, deal.customerId);
  }
  
  _recordRevenue(amount, product, customerId) {
    const month = new Date().toISOString().slice(0, 7);
    
    this.revenue.total += amount;
    this.revenue.byProduct[product] = (this.revenue.byProduct[product] || 0) + amount;
    this.revenue.byCustomer[customerId] = (this.revenue.byCustomer[customerId] || 0) + amount;
    this.revenue.byMonth[month] = (this.revenue.byMonth[month] || 0) + amount;
    
    // Update MRR/ARR (assume subscription = monthly recurring)
    const productDef = ENTERPRISE_PRODUCTS[product];
    if (productDef && (productDef.type === 'subscription' || productDef.type === 'deployment')) {
      this.revenue.mrr += amount;
      this.revenue.arr = this.revenue.mrr * 12;
    }
  }
  
  _updatePipeline() {
    this.pipeline.total = 0;
    this.pipeline.byStage = {
      lead: 0,
      qualified: 0,
      proposal: 0,
      negotiation: 0,
      closed: 0,
      lost: 0
    };
    
    for (const deal of this.deals.values()) {
      if (deal.stage !== 'closed' && deal.stage !== 'lost') {
        this.pipeline.total += deal.value * deal.probability;
      }
      this.pipeline.byStage[deal.stage] = (this.pipeline.byStage[deal.stage] || 0) + deal.value;
    }
  }
  
  /**
   * Register partner
   */
  registerPartner(partnerData = {}) {
    const partnerId = `NOVA-P-${this.partnerIdCounter++}`;
    
    const partnerType = PARTNERSHIP_TYPES[partnerData.type] || PARTNERSHIP_TYPES.RESELLER;
    
    const partner = {
      id: partnerId,
      company: partnerData.company,
      type: partnerData.type || 'RESELLER',
      typeDetails: partnerType,
      contacts: partnerData.contacts || [],
      status: 'pending',
      referrals: [],
      revenue: 0,
      commission: 0,
      createdAt: Date.now()
    };
    
    this.partners.set(partnerId, partner);
    
    return partner;
  }
  
  /**
   * Record partner referral
   */
  recordReferral(partnerId, dealId) {
    const partner = this.partners.get(partnerId);
    if (!partner) throw new Error('Partner not found');
    
    const deal = this.deals.get(dealId);
    if (!deal) throw new Error('Deal not found');
    
    partner.referrals.push({
      dealId,
      value: deal.value,
      at: Date.now()
    });
    
    deal.partnerId = partnerId;
    
    // If deal is closed, calculate commission
    if (deal.stage === 'closed') {
      const commission = deal.value * (partner.typeDetails.commission || 0.15);
      partner.commission += commission;
      partner.revenue += deal.value;
    }
    
    return partner;
  }
  
  /**
   * Process usage-based billing
   */
  processUsageBilling(customerId, usage = {}) {
    const customer = this.customers.get(customerId);
    if (!customer) throw new Error('Customer not found');
    
    const pricing = ENTERPRISE_PRODUCTS.NOVA_API_PRO.pricing;
    
    let charges = 0;
    const breakdown = {};
    
    // Calculate API call charges
    if (usage.apiCalls) {
      customer.usageMetrics.apiCalls += usage.apiCalls;
      const callCharges = usage.apiCalls * pricing.calls.rate;
      charges += callCharges;
      breakdown.apiCalls = { units: usage.apiCalls, charge: callCharges };
    }
    
    // Calculate compute charges
    if (usage.compute) {
      customer.usageMetrics.compute += usage.compute;
      const computeCharges = usage.compute * pricing.compute.rate;
      charges += computeCharges;
      breakdown.compute = { units: usage.compute, charge: computeCharges };
    }
    
    // Calculate storage charges
    if (usage.storage) {
      customer.usageMetrics.storage += usage.storage;
      const storageCharges = usage.storage * pricing.storage.rate;
      charges += storageCharges;
      breakdown.storage = { units: usage.storage, charge: storageCharges };
    }
    
    // Apply volume discounts
    const totalApiCalls = customer.usageMetrics.apiCalls;
    let discount = 0;
    for (const tier of ENTERPRISE_PRODUCTS.NOVA_API_PRO.volumeDiscounts) {
      if (totalApiCalls >= tier.threshold) {
        discount = tier.discount;
      }
    }
    
    const finalCharges = charges * (1 - discount);
    
    // Record revenue
    if (finalCharges > 0) {
      this._recordRevenue(finalCharges, 'NOVA_API_PRO', customerId);
      customer.revenue.total += finalCharges;
    }
    
    return {
      customerId,
      period: new Date().toISOString().slice(0, 7),
      usage,
      breakdown,
      subtotal: charges,
      discount: discount * 100 + '%',
      total: finalCharges
    };
  }
  
  /**
   * Get sales dashboard
   */
  getDashboard() {
    return {
      revenue: {
        total: this.revenue.total,
        mrr: this.revenue.mrr,
        arr: this.revenue.arr,
        byMonth: this.revenue.byMonth
      },
      pipeline: {
        total: this.pipeline.total,
        byStage: this.pipeline.byStage,
        dealCount: this.deals.size
      },
      customers: {
        total: this.customers.size,
        byStatus: this._customersByStatus()
      },
      partners: {
        total: this.partners.size,
        totalReferrals: Array.from(this.partners.values()).reduce((s, p) => s + p.referrals.length, 0)
      }
    };
  }
  
  _customersByStatus() {
    const statuses = {};
    for (const customer of this.customers.values()) {
      statuses[customer.status] = (statuses[customer.status] || 0) + 1;
    }
    return statuses;
  }
  
  /**
   * Export data
   */
  export() {
    return {
      version: NovaEnterprise.VERSION,
      exportedAt: Date.now(),
      customers: Array.from(this.customers.entries()),
      deals: Array.from(this.deals.entries()),
      partners: Array.from(this.partners.entries()),
      revenue: this.revenue,
      pipeline: this.pipeline
    };
  }
  
  /**
   * Import data
   */
  import(data) {
    if (data.customers) {
      this.customers = new Map(data.customers);
      const maxId = Math.max(...Array.from(this.customers.keys()).map(id => parseInt(id.split('-')[2]) || 0));
      this.customerIdCounter = maxId + 1;
    }
    if (data.deals) {
      this.deals = new Map(data.deals);
      const maxId = Math.max(...Array.from(this.deals.keys()).map(id => parseInt(id.split('-')[2]) || 0));
      this.dealIdCounter = maxId + 1;
    }
    if (data.partners) {
      this.partners = new Map(data.partners);
      const maxId = Math.max(...Array.from(this.partners.keys()).map(id => parseInt(id.split('-')[2]) || 0));
      this.partnerIdCounter = maxId + 1;
    }
    if (data.revenue) this.revenue = data.revenue;
    if (data.pipeline) this.pipeline = data.pipeline;
  }
  
  toJSON() {
    return {
      type: 'NovaEnterprise',
      quad: NovaEnterprise.QUAD,
      version: NovaEnterprise.VERSION,
      ipValue: NovaEnterprise.IP_VALUE,
      ipValueFormatted: `$${(NovaEnterprise.IP_VALUE / 1000000).toFixed(1)}M USD`,
      customers: this.customers.size,
      deals: this.deals.size,
      partners: this.partners.size,
      dashboard: this.getDashboard(),
      createdAt: this.createdAt
    };
  }
}

// ─── Export ──────────────────────────────────────────────────────────────────
export default {
  NovaEnterprise,
  ENTERPRISE_PRODUCTS,
  PARTNERSHIP_TYPES
};
