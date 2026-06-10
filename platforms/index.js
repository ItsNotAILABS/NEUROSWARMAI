/**
 * NOVA PLATFORMS — Master Index
 * Nova by FreddyCreates
 * 
 * 15 Enterprise Cognitive Garment Platforms
 * - 5 Developer Platforms
 * - 10 Enterprise Platforms
 * 
 * Total IP Portfolio Value: $55.0M USD
 * 
 * @version 0.13.0 (F13)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Developer Platforms ───────────────────────────────────────────────────────
import { CodeSovereignty } from './developer/code-sovereignty.js';
import { DebugConsciousness } from './developer/debug-consciousness.js';
import { CyberSecurityMind } from './developer/cyber-security-mind.js';
import { CloudInfrastructure } from './developer/cloud-infrastructure.js';
import { DataIntelligence } from './developer/data-intelligence.js';

// ─── Enterprise Platforms ──────────────────────────────────────────────────────
import { ResearchIntelligence } from './enterprise/research-intelligence.js';
import { HealthIntelligence } from './enterprise/health-intelligence.js';
import { LegalCompliance } from './enterprise/legal-compliance.js';
import { EducationIntelligence } from './enterprise/education-intelligence.js';
import { CreativeIntelligence } from './enterprise/creative-intelligence.js';
import { SustainabilityIntelligence } from './enterprise/sustainability-intelligence.js';
import { GovernmentIntelligence } from './enterprise/government-intelligence.js';
import { MediaIntelligence } from './enterprise/media-intelligence.js';
import { ScientificDiscovery } from './enterprise/scientific-discovery.js';
import { PhilosophyEthics } from './enterprise/philosophy-ethics.js';

// ─── Re-exports ────────────────────────────────────────────────────────────────
export {
  // Developer
  CodeSovereignty,
  DebugConsciousness,
  CyberSecurityMind,
  CloudInfrastructure,
  DataIntelligence,
  // Enterprise
  ResearchIntelligence,
  HealthIntelligence,
  LegalCompliance,
  EducationIntelligence,
  CreativeIntelligence,
  SustainabilityIntelligence,
  GovernmentIntelligence,
  MediaIntelligence,
  ScientificDiscovery,
  PhilosophyEthics
};

// ─── Platform Registry ─────────────────────────────────────────────────────────
export const PLATFORMS = {
  // Developer Platforms
  CODR: {
    name: 'CodeSovereignty',
    class: CodeSovereignty,
    category: 'Developer',
    domain: 'Code Intelligence',
    ipValue: 4200000,
    description: 'Complete code intelligence platform — understands, generates, evolves'
  },
  DBGR: {
    name: 'DebugConsciousness',
    class: DebugConsciousness,
    category: 'Developer',
    domain: 'Debug Intelligence',
    ipValue: 3800000,
    description: 'Debug consciousness that UNDERSTANDS errors, not just finds them'
  },
  CYBS: {
    name: 'CyberSecurityMind',
    class: CyberSecurityMind,
    category: 'Developer',
    domain: 'Security Intelligence',
    ipValue: 5100000,
    description: 'Security consciousness — thinks like attacker, defends like guardian'
  },
  CLDS: {
    name: 'CloudInfrastructure',
    class: CloudInfrastructure,
    category: 'Developer',
    domain: 'Cloud Intelligence',
    ipValue: 4500000,
    description: 'Cloud consciousness that thinks in architectures across all providers'
  },
  DATA: {
    name: 'DataIntelligence',
    class: DataIntelligence,
    category: 'Developer',
    domain: 'Data Intelligence',
    ipValue: 4800000,
    description: 'Data consciousness — understands schemas, generates insights'
  },
  
  // Enterprise Platforms
  RESR: {
    name: 'ResearchIntelligence',
    class: ResearchIntelligence,
    category: 'Enterprise',
    domain: 'Research Intelligence',
    ipValue: 3600000,
    description: 'Research synthesis, hypothesis generation, discovery acceleration'
  },
  HLTH: {
    name: 'HealthIntelligence',
    class: HealthIntelligence,
    category: 'Enterprise',
    domain: 'Healthcare Intelligence',
    ipValue: 5200000,
    description: 'Patient outcomes, treatment optimization, population health'
  },
  LEGC: {
    name: 'LegalCompliance',
    class: LegalCompliance,
    category: 'Enterprise',
    domain: 'Legal Intelligence',
    ipValue: 3900000,
    description: 'Regulatory monitoring, compliance assessment, policy generation'
  },
  EDUC: {
    name: 'EducationIntelligence',
    class: EducationIntelligence,
    category: 'Enterprise',
    domain: 'Education Intelligence',
    ipValue: 2800000,
    description: 'Personalized learning, curriculum design, outcome prediction'
  },
  CRTV: {
    name: 'CreativeIntelligence',
    class: CreativeIntelligence,
    category: 'Enterprise',
    domain: 'Creative Intelligence',
    ipValue: 3400000,
    description: 'Ideation, concept development, creative strategy orchestration'
  },
  SUST: {
    name: 'SustainabilityIntelligence',
    class: SustainabilityIntelligence,
    category: 'Enterprise',
    domain: 'Sustainability Intelligence',
    ipValue: 3100000,
    description: 'Carbon tracking, ESG reporting, supply chain sustainability'
  },
  GOVT: {
    name: 'GovernmentIntelligence',
    class: GovernmentIntelligence,
    category: 'Enterprise',
    domain: 'Government Intelligence',
    ipValue: 4300000,
    description: 'Policy analysis, civic engagement, public sector optimization'
  },
  MDIA: {
    name: 'MediaIntelligence',
    class: MediaIntelligence,
    category: 'Enterprise',
    domain: 'Media Intelligence',
    ipValue: 2900000,
    description: 'Content analysis, audience intelligence, distribution optimization'
  },
  SCIF: {
    name: 'ScientificDiscovery',
    class: ScientificDiscovery,
    category: 'Enterprise',
    domain: 'Scientific Intelligence',
    ipValue: 4700000,
    description: 'Hypothesis generation, experiment design, discovery acceleration'
  },
  PHIL: {
    name: 'PhilosophyEthics',
    class: PhilosophyEthics,
    category: 'Enterprise',
    domain: 'Philosophy & Ethics Intelligence',
    ipValue: 2600000,
    description: 'Ethical analysis, philosophical reasoning, wisdom synthesis'
  }
};

// ─── Portfolio Summary ─────────────────────────────────────────────────────────
export function getPortfolio() {
  const platforms = Object.values(PLATFORMS);
  const developer = platforms.filter(p => p.category === 'Developer');
  const enterprise = platforms.filter(p => p.category === 'Enterprise');
  const totalIPValue = platforms.reduce((sum, p) => sum + p.ipValue, 0);
  
  return {
    brand: 'Nova Platforms by FreddyCreates',
    category: 'Cognitive Garments',
    version: '0.13.0',
    totalPlatforms: platforms.length,
    developer: {
      count: developer.length,
      ipValue: developer.reduce((sum, p) => sum + p.ipValue, 0)
    },
    enterprise: {
      count: enterprise.length,
      ipValue: enterprise.reduce((sum, p) => sum + p.ipValue, 0)
    },
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    platforms: platforms.map(p => ({
      quad: Object.keys(PLATFORMS).find(k => PLATFORMS[k] === p),
      name: p.name,
      category: p.category,
      domain: p.domain,
      ipValue: p.ipValue,
      ipValueFormatted: `$${(p.ipValue / 1000000).toFixed(1)}M`
    }))
  };
}

// ─── Factory Functions ─────────────────────────────────────────────────────────
export function createPlatform(quad, config = {}) {
  const platform = PLATFORMS[quad];
  if (!platform) {
    throw new Error(`Unknown platform: ${quad}. Available: ${Object.keys(PLATFORMS).join(', ')}`);
  }
  return new platform.class(config);
}

export function createDeveloperPlatforms(config = {}) {
  return {
    CODR: new CodeSovereignty(config),
    DBGR: new DebugConsciousness(config),
    CYBS: new CyberSecurityMind(config),
    CLDS: new CloudInfrastructure(config),
    DATA: new DataIntelligence(config)
  };
}

export function createEnterprisePlatforms(config = {}) {
  return {
    RESR: new ResearchIntelligence(config),
    HLTH: new HealthIntelligence(config),
    LEGC: new LegalCompliance(config),
    EDUC: new EducationIntelligence(config),
    CRTV: new CreativeIntelligence(config),
    SUST: new SustainabilityIntelligence(config),
    GOVT: new GovernmentIntelligence(config),
    MDIA: new MediaIntelligence(config),
    SCIF: new ScientificDiscovery(config),
    PHIL: new PhilosophyEthics(config)
  };
}

export function createAllPlatforms(config = {}) {
  return {
    ...createDeveloperPlatforms(config),
    ...createEnterprisePlatforms(config)
  };
}

// ─── Default Export ────────────────────────────────────────────────────────────
export default {
  PLATFORMS,
  getPortfolio,
  createPlatform,
  createDeveloperPlatforms,
  createEnterprisePlatforms,
  createAllPlatforms
};
