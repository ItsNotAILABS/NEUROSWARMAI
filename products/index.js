/**
 * NOVA PRODUCTS — Consumer Products for Mass Adoption
 * Nova by FreddyCreates
 * 
 * 8 free AI products for mass adoption with generous free limits.
 * 
 * Product Catalog:
 * ┌─────────────────────────────────────────────────────────────────────┐
 * │  Product       │  QUAD  │  Tagline                    │  Free Limit │
 * ├─────────────────────────────────────────────────────────────────────┤
 * │  Nova Code     │  NVCD  │  AI coding that remembers   │  1000/mo    │
 * │  Nova Debug    │  NVDB  │  AI that understands errors │  500/mo     │
 * │  Nova Data     │  NVDT  │  Data → insights            │  100/mo     │
 * │  Nova Create   │  NVCR  │  AI creativity partner      │  500/mo     │
 * │  Nova Studio   │  NVST  │  AI creative workspace      │  200/mo     │
 * │  Nova Learn    │  NVLN  │  AI tutor that adapts       │  Unlimited  │
 * │  Nova Research │  NVRS  │  Knowledge synthesis        │  100/mo     │
 * │  Nova Docs     │  NVDC  │  Document intelligence      │  50/mo      │
 * └─────────────────────────────────────────────────────────────────────┘
 * 
 * Total IP Value: $27.9M USD
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Imports ─────────────────────────────────────────────────────────────────
import { NovaCode, createNovaCode, SUPPORTED_LANGUAGES, COMPLETION_TYPES } from './nova-code.js';
import { NovaDebug, createNovaDebug, ERROR_CATEGORIES, ERROR_PATTERNS } from './nova-debug.js';
import { NovaData, createNovaData, DATA_TYPES, VISUALIZATION_TYPES } from './nova-data.js';
import { NovaCreate, createNovaCreate, CONTENT_TYPES, WRITING_STYLES } from './nova-create.js';
import { NovaStudio, createNovaStudio, PROJECT_TYPES, ASSET_TYPES, EXPORT_FORMATS } from './nova-studio.js';
import { NovaLearn, createNovaLearn, SUBJECT_AREAS, LEARNING_STYLES, DIFFICULTY_LEVELS } from './nova-learn.js';
import { NovaResearch, createNovaResearch, RESEARCH_FIELDS, SOURCE_TYPES, CITATION_STYLES } from './nova-research.js';
import { NovaDocs, createNovaDocs, DOCUMENT_TYPES, EXTRACTION_TYPES, RISK_LEVELS } from './nova-docs.js';

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;

// ─── Product Registry ────────────────────────────────────────────────────────
export const PRODUCTS = {
  NVCD: {
    name: 'Nova Code',
    class: NovaCode,
    factory: createNovaCode,
    quad: 'NVCD',
    category: 'Developer',
    ipValue: 4800000,
    freeLimit: '1000 completions/month',
    tagline: 'AI coding that remembers your codebase',
    domain: 'novacode.dev',
    handle: '@novacode'
  },
  NVDB: {
    name: 'Nova Debug',
    class: NovaDebug,
    factory: createNovaDebug,
    quad: 'NVDB',
    category: 'Developer',
    ipValue: 3200000,
    freeLimit: '500 debug sessions/month',
    tagline: 'AI that understands errors, not just finds them',
    domain: 'nova.ai/debug',
    handle: '@novadebug'
  },
  NVDT: {
    name: 'Nova Data',
    class: NovaData,
    factory: createNovaData,
    quad: 'NVDT',
    category: 'Developer',
    ipValue: 2800000,
    freeLimit: '100 analyses/month, 10MB data',
    tagline: 'Data → insights, instantly',
    domain: 'nova.ai/data',
    handle: '@novadata'
  },
  NVCR: {
    name: 'Nova Create',
    class: NovaCreate,
    factory: createNovaCreate,
    quad: 'NVCR',
    category: 'Creative',
    ipValue: 3500000,
    freeLimit: '500 generations/month',
    tagline: 'AI creativity partner for ideation and content',
    domain: 'novacreate.ai',
    handle: '@novacreate'
  },
  NVST: {
    name: 'Nova Studio',
    class: NovaStudio,
    factory: createNovaStudio,
    quad: 'NVST',
    category: 'Creative',
    ipValue: 3800000,
    freeLimit: '200 projects/month',
    tagline: 'AI-powered creative workspace',
    domain: 'nova.ai/studio',
    handle: '@novastudio'
  },
  NVLN: {
    name: 'Nova Learn',
    class: NovaLearn,
    factory: createNovaLearn,
    quad: 'NVLN',
    category: 'Learning',
    ipValue: 4200000,
    freeLimit: 'Unlimited basic courses',
    tagline: 'AI tutor that adapts to how you learn',
    domain: 'novalearn.ai',
    handle: '@novalearn'
  },
  NVRS: {
    name: 'Nova Research',
    class: NovaResearch,
    factory: createNovaResearch,
    quad: 'NVRS',
    category: 'Research',
    ipValue: 3000000,
    freeLimit: '100 searches/month',
    tagline: 'Knowledge synthesis for researchers',
    domain: 'nova.ai/research',
    handle: '@novaresearch'
  },
  NVDC: {
    name: 'Nova Docs',
    class: NovaDocs,
    factory: createNovaDocs,
    quad: 'NVDC',
    category: 'Business',
    ipValue: 2600000,
    freeLimit: '50 documents/month',
    tagline: 'Document intelligence for contracts and reports',
    domain: 'nova.ai/docs',
    handle: '@novadocs'
  }
};

// ─── Re-exports ──────────────────────────────────────────────────────────────
export {
  // Classes
  NovaCode,
  NovaDebug,
  NovaData,
  NovaCreate,
  NovaStudio,
  NovaLearn,
  NovaResearch,
  NovaDocs,
  
  // Factory functions
  createNovaCode,
  createNovaDebug,
  createNovaData,
  createNovaCreate,
  createNovaStudio,
  createNovaLearn,
  createNovaResearch,
  createNovaDocs,
  
  // Code constants
  SUPPORTED_LANGUAGES,
  COMPLETION_TYPES,
  
  // Debug constants
  ERROR_CATEGORIES,
  ERROR_PATTERNS,
  
  // Data constants
  DATA_TYPES,
  VISUALIZATION_TYPES,
  
  // Create constants
  CONTENT_TYPES,
  WRITING_STYLES,
  
  // Studio constants
  PROJECT_TYPES,
  ASSET_TYPES,
  EXPORT_FORMATS,
  
  // Learn constants
  SUBJECT_AREAS,
  LEARNING_STYLES,
  DIFFICULTY_LEVELS,
  
  // Research constants
  RESEARCH_FIELDS,
  SOURCE_TYPES,
  CITATION_STYLES,
  
  // Docs constants
  DOCUMENT_TYPES,
  EXTRACTION_TYPES,
  RISK_LEVELS
};

// ─── Nova Products Suite Class ───────────────────────────────────────────────
export class NovaProducts {
  static VERSION = '0.19.0';
  static TOTAL_IP_VALUE = Object.values(PRODUCTS).reduce((sum, p) => sum + p.ipValue, 0);
  static TOTAL_PRODUCTS = Object.keys(PRODUCTS).length;
  
  constructor(config = {}) {
    this.config = config;
    this.userId = config.userId;
    
    // Initialize all products
    this.code = createNovaCode({ userId: this.userId, ...config.code });
    this.debug = createNovaDebug({ userId: this.userId, ...config.debug });
    this.data = createNovaData({ userId: this.userId, ...config.data });
    this.create = createNovaCreate({ userId: this.userId, ...config.create });
    this.studio = createNovaStudio({ userId: this.userId, ...config.studio });
    this.learn = createNovaLearn({ userId: this.userId, ...config.learn });
    this.research = createNovaResearch({ userId: this.userId, ...config.research });
    this.docs = createNovaDocs({ userId: this.userId, ...config.docs });
    
    this.createdAt = Date.now();
  }
  
  /**
   * Get product by QUAD code
   */
  getProduct(quad) {
    const productMap = {
      NVCD: this.code,
      NVDB: this.debug,
      NVDT: this.data,
      NVCR: this.create,
      NVST: this.studio,
      NVLN: this.learn,
      NVRS: this.research,
      NVDC: this.docs
    };
    
    return productMap[quad] || null;
  }
  
  /**
   * Get combined usage stats
   */
  getUsageStats() {
    return {
      code: this.code.getUsageStats(),
      debug: this.debug.getUsageStats(),
      data: this.data.getUsageStats(),
      create: this.create.getUsageStats(),
      studio: this.studio.getUsageStats(),
      learn: this.learn.getDashboard().dashboard,
      research: this.research.getUsageStats(),
      docs: this.docs.getUsageStats()
    };
  }
  
  /**
   * Get product dashboard
   */
  getDashboard() {
    return {
      version: NovaProducts.VERSION,
      totalProducts: NovaProducts.TOTAL_PRODUCTS,
      totalIPValue: NovaProducts.TOTAL_IP_VALUE,
      totalIPValueFormatted: `$${(NovaProducts.TOTAL_IP_VALUE / 1000000).toFixed(1)}M USD`,
      products: Object.values(PRODUCTS).map(p => ({
        quad: p.quad,
        name: p.name,
        category: p.category,
        freeLimit: p.freeLimit,
        tagline: p.tagline,
        domain: p.domain,
        ipValue: p.ipValue,
        ipValueFormatted: `$${(p.ipValue / 1000000).toFixed(1)}M`
      })),
      byCategory: {
        Developer: Object.values(PRODUCTS).filter(p => p.category === 'Developer'),
        Creative: Object.values(PRODUCTS).filter(p => p.category === 'Creative'),
        Learning: Object.values(PRODUCTS).filter(p => p.category === 'Learning'),
        Research: Object.values(PRODUCTS).filter(p => p.category === 'Research'),
        Business: Object.values(PRODUCTS).filter(p => p.category === 'Business')
      },
      createdAt: this.createdAt
    };
  }
  
  /**
   * Export all data
   */
  export() {
    return {
      version: NovaProducts.VERSION,
      exportedAt: Date.now(),
      userId: this.userId,
      code: this.code.export(),
      debug: this.debug.export(),
      data: this.data.export(),
      create: this.create.export(),
      studio: this.studio.export(),
      learn: this.learn.export(),
      research: this.research.export(),
      docs: this.docs.export()
    };
  }
  
  toJSON() {
    return {
      type: 'NovaProducts',
      version: NovaProducts.VERSION,
      totalProducts: NovaProducts.TOTAL_PRODUCTS,
      totalIPValue: NovaProducts.TOTAL_IP_VALUE,
      totalIPValueFormatted: `$${(NovaProducts.TOTAL_IP_VALUE / 1000000).toFixed(1)}M USD`,
      products: Object.keys(PRODUCTS),
      dashboard: this.getDashboard(),
      createdAt: this.createdAt
    };
  }
}

// ─── Factory Functions ───────────────────────────────────────────────────────
export function createProduct(quad, config = {}) {
  const product = PRODUCTS[quad];
  if (!product) {
    throw new Error(`Unknown product: ${quad}. Available: ${Object.keys(PRODUCTS).join(', ')}`);
  }
  return product.factory(config);
}

export function createProductSuite(config = {}) {
  return new NovaProducts(config);
}

// ─── Portfolio Summary ───────────────────────────────────────────────────────
export function getProductsPortfolio() {
  const products = Object.values(PRODUCTS);
  const totalIPValue = products.reduce((sum, p) => sum + p.ipValue, 0);
  
  return {
    brand: 'Nova Products by FreddyCreates',
    category: 'Consumer AI Products',
    version: '0.19.0',
    totalProducts: products.length,
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    products: products.map(p => ({
      quad: p.quad,
      name: p.name,
      category: p.category,
      ipValue: p.ipValue,
      ipValueFormatted: `$${(p.ipValue / 1000000).toFixed(1)}M`,
      freeLimit: p.freeLimit,
      tagline: p.tagline,
      domain: p.domain,
      handle: p.handle
    })),
    categories: {
      Developer: products.filter(p => p.category === 'Developer').length,
      Creative: products.filter(p => p.category === 'Creative').length,
      Learning: products.filter(p => p.category === 'Learning').length,
      Research: products.filter(p => p.category === 'Research').length,
      Business: products.filter(p => p.category === 'Business').length
    },
    socialHandles: products.map(p => p.handle),
    domains: products.map(p => p.domain),
    description: '8 free AI products for mass adoption. Developers get coding and debugging. Creators get content and workspace. Students get unlimited learning. Researchers get knowledge synthesis. Professionals get document intelligence.'
  };
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  // Main class
  NovaProducts,
  
  // Product classes
  NovaCode,
  NovaDebug,
  NovaData,
  NovaCreate,
  NovaStudio,
  NovaLearn,
  NovaResearch,
  NovaDocs,
  
  // Factories
  createProduct,
  createProductSuite,
  createNovaCode,
  createNovaDebug,
  createNovaData,
  createNovaCreate,
  createNovaStudio,
  createNovaLearn,
  createNovaResearch,
  createNovaDocs,
  
  // Registry
  PRODUCTS,
  
  // Portfolio
  getProductsPortfolio
};
