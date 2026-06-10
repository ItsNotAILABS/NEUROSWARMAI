/**
 * NOVA ENTERPRISE PRODUCTS — Index
 * Nova by FreddyCreates
 * 
 * Five enterprise-grade Cognitive Garments for AI systems to wear.
 * Total IP Portfolio Value: $11.1M USD
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

// Product Imports
import { SentientContracts } from './sentient-contracts.js';
import { MarketOracle } from './market-oracle.js';
import { TalentCompass } from './talent-compass.js';
import { SupplyMind } from './supply-mind.js';
import { BrandGuardian } from './brand-guardian.js';

// Re-export products
export { SentientContracts, MarketOracle, TalentCompass, SupplyMind, BrandGuardian };

// ─── Product Registry ────────────────────────────────────────────────────────
export const PRODUCTS = {
  SNCT: {
    name: 'SentientContracts',
    class: SentientContracts,
    domain: 'Legal Technology',
    ipValue: 2400000,
    description: 'Contract intelligence that reads, remembers, and anticipates'
  },
  MKOR: {
    name: 'MarketOracle',
    class: MarketOracle,
    domain: 'Financial Intelligence',
    ipValue: 3200000,
    description: 'Market perception that feels sentiment and sees correlations'
  },
  TLCP: {
    name: 'TalentCompass',
    class: TalentCompass,
    domain: 'Human Capital',
    ipValue: 1800000,
    description: 'Workforce intelligence that understands potential and dynamics'
  },
  SPMD: {
    name: 'SupplyMind',
    class: SupplyMind,
    domain: 'Operations',
    ipValue: 2100000,
    description: 'Supply chain intelligence that predicts and optimizes'
  },
  BRGD: {
    name: 'BrandGuardian',
    class: BrandGuardian,
    domain: 'Marketing Technology',
    ipValue: 1600000,
    description: 'Brand intelligence that monitors, protects, and amplifies'
  }
};

// ─── Portfolio Summary ───────────────────────────────────────────────────────
export function getPortfolio() {
  const products = Object.values(PRODUCTS);
  const totalIPValue = products.reduce((sum, p) => sum + p.ipValue, 0);
  
  return {
    brand: 'Nova by FreddyCreates',
    category: 'Cognitive Garments',
    productCount: products.length,
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    products: products.map(p => ({
      quad: Object.keys(PRODUCTS).find(k => PRODUCTS[k] === p),
      name: p.name,
      domain: p.domain,
      ipValue: p.ipValue,
      ipValueFormatted: `$${(p.ipValue / 1000000).toFixed(1)}M`
    }))
  };
}

// ─── Factory Function ────────────────────────────────────────────────────────
export function createProduct(quad, config = {}) {
  const product = PRODUCTS[quad];
  if (!product) {
    throw new Error(`Unknown product: ${quad}. Available: ${Object.keys(PRODUCTS).join(', ')}`);
  }
  return new product.class(config);
}

// ─── Create All Products ─────────────────────────────────────────────────────
export function createAllProducts(config = {}) {
  return {
    SNCT: new SentientContracts(config),
    MKOR: new MarketOracle(config),
    TLCP: new TalentCompass(config),
    SPMD: new SupplyMind(config),
    BRGD: new BrandGuardian(config)
  };
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  PRODUCTS,
  getPortfolio,
  createProduct,
  createAllProducts,
  SentientContracts,
  MarketOracle,
  TalentCompass,
  SupplyMind,
  BrandGuardian
};
