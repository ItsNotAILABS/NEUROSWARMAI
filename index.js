/**
 * NOVA PLATFORM — Complete IP Portfolio Index
 * Nova by FreddyCreates
 * 
 * This is the MASTER INDEX for the entire Nova platform.
 * Total IP Portfolio: $243.3M USD
 * 
 * DIVISIONS:
 * - command/     — 8 Enterprise Command Platforms ($46.7M)
 * - platforms/   — 15 Cognitive Garment Platforms ($55.0M)
 * - enterprise/  — 5 Enterprise Products ($11.1M)
 * - workspace/   — 7 AI Workspace Components ($38.9M)
 * - launch/      — 4 Commercial Launch Components ($38.3M)
 * - organism/    — 22 Living AI Infrastructure ($25.4M)
 * - products/    — 8 Consumer Products ($27.9M)
 * 
 * RESEARCH:
 * - 18 Papers in docs/research/
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Division Imports ────────────────────────────────────────────────────────

// Command — Enterprise takeover platforms
import { 
  OPERATIONS, 
  getPortfolio as getCommandPortfolio,
  createOperation,
  EnterpriseCommandCenter 
} from './command/index.js';

// Platforms — 15 Cognitive Garments
import {
  PLATFORMS,
  getPortfolio as getPlatformsPortfolio,
  createPlatform,
  createAllPlatforms
} from './platforms/index.js';

// Enterprise Products — 5 Enterprise Garments
import {
  PRODUCTS,
  getPortfolio as getEnterprisePortfolio,
  createProduct,
  createAllProducts
} from './enterprise/index.js';

// Workspace — AI Infrastructure
import {
  WORKSPACES,
  ENGINES,
  getWorkspacePortfolio,
  createWorkspace,
  createHQ,
  createHome,
  createVault,
  createErrorLibrary,
  NovaWorkspaceEnvironment,
  IntegratedEngineSystem
} from './workspace/index.js';

// Launch — Commercial Infrastructure
import {
  LAUNCH_COMPONENTS,
  LAUNCH_STRATEGY,
  getLaunchPortfolio,
  createLaunchSystem,
  createLabs,
  createPublic,
  createEnterprise,
  NovaLaunch,
  NovaLabs,
  NovaPublic,
  NovaEnterprise,
  RESEARCH_PAPERS,
  LICENSE_TYPES,
  PUBLIC_PRODUCTS,
  USER_TIERS,
  ENTERPRISE_PRODUCTS,
  PARTNERSHIP_TYPES
} from './launch/index.js';

// Organism — Living AI Infrastructure
import {
  ORGANISM,
  TRANSFORMER_TYPES,
  TRANSFORMERS,
  TERMINALS,
  ACCESS_LEVELS,
  CARE_COMPONENTS,
  HEALTH_STATUS,
  NovaOrganism,
  createOrganism,
  getOrganismPortfolio,
  createTransformer,
  TransformerPipeline,
  createTerminal,
  CareSystem,
  createCareSystem
} from './organism/index.js';

// Products — Consumer AI Products
import {
  PRODUCTS as CONSUMER_PRODUCTS,
  NovaProducts,
  NovaCode,
  NovaDebug,
  NovaData,
  NovaCreate,
  NovaStudio,
  NovaLearn,
  NovaResearch,
  NovaDocs,
  createProduct as createConsumerProduct,
  createProductSuite,
  getProductsPortfolio
} from './products/index.js';

// ─── Re-exports ──────────────────────────────────────────────────────────────
export {
  // Command
  OPERATIONS,
  getCommandPortfolio,
  createOperation,
  EnterpriseCommandCenter,
  
  // Platforms
  PLATFORMS,
  getPlatformsPortfolio,
  createPlatform,
  createAllPlatforms,
  
  // Enterprise Products
  PRODUCTS,
  getEnterprisePortfolio,
  createProduct,
  createAllProducts,
  
  // Workspace
  WORKSPACES,
  ENGINES,
  getWorkspacePortfolio,
  createWorkspace,
  createHQ,
  createHome,
  createVault,
  createErrorLibrary,
  NovaWorkspaceEnvironment,
  IntegratedEngineSystem,
  
  // Launch
  LAUNCH_COMPONENTS,
  LAUNCH_STRATEGY,
  getLaunchPortfolio,
  createLaunchSystem,
  createLabs,
  createPublic,
  createEnterprise,
  NovaLaunch,
  NovaLabs,
  NovaPublic,
  NovaEnterprise,
  RESEARCH_PAPERS,
  LICENSE_TYPES,
  PUBLIC_PRODUCTS,
  USER_TIERS,
  ENTERPRISE_PRODUCTS,
  PARTNERSHIP_TYPES,
  
  // Organism
  ORGANISM,
  TRANSFORMER_TYPES,
  TRANSFORMERS,
  TERMINALS,
  ACCESS_LEVELS,
  CARE_COMPONENTS,
  HEALTH_STATUS,
  NovaOrganism,
  createOrganism,
  getOrganismPortfolio,
  createTransformer,
  TransformerPipeline,
  createTerminal,
  CareSystem,
  createCareSystem,
  
  // Consumer Products
  CONSUMER_PRODUCTS,
  NovaProducts,
  NovaCode,
  NovaDebug,
  NovaData,
  NovaCreate,
  NovaStudio,
  NovaLearn,
  NovaResearch,
  NovaDocs,
  createConsumerProduct,
  createProductSuite,
  getProductsPortfolio
};

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;
const VERSION = '0.19.0';

// ─── Complete Portfolio ──────────────────────────────────────────────────────
export function getCompletePortfolio() {
  const command = getCommandPortfolio();
  const platforms = getPlatformsPortfolio();
  const enterprise = getEnterprisePortfolio();
  const workspace = getWorkspacePortfolio();
  const launch = getLaunchPortfolio();
  const organism = getOrganismPortfolio();
  const products = getProductsPortfolio();
  
  const totalIPValue = 
    command.totalIPValue + 
    platforms.totalIPValue + 
    enterprise.totalIPValue + 
    workspace.totalIPValue + 
    launch.totalIPValue +
    organism.totalIPValue +
    products.totalIPValue;
  
  return {
    brand: 'Nova by FreddyCreates',
    version: VERSION,
    phi: PHI,
    
    // Total portfolio
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    
    // Division breakdown
    divisions: {
      command: {
        name: 'Enterprise Command Platforms',
        path: 'command/',
        components: command.totalOperations,
        ipValue: command.totalIPValue,
        ipValueFormatted: command.totalIPValueFormatted
      },
      platforms: {
        name: 'Cognitive Garment Platforms',
        path: 'platforms/',
        components: platforms.totalPlatforms,
        ipValue: platforms.totalIPValue,
        ipValueFormatted: platforms.totalIPValueFormatted
      },
      enterprise: {
        name: 'Enterprise Products',
        path: 'enterprise/',
        components: enterprise.productCount,
        ipValue: enterprise.totalIPValue,
        ipValueFormatted: enterprise.totalIPValueFormatted
      },
      workspace: {
        name: 'AI Workspace Infrastructure',
        path: 'workspace/',
        components: workspace.totalWorkspaces,
        ipValue: workspace.totalIPValue,
        ipValueFormatted: workspace.totalIPValueFormatted
      },
      launch: {
        name: 'Commercial Launch System',
        path: 'launch/',
        components: launch.totalComponents,
        ipValue: launch.totalIPValue,
        ipValueFormatted: launch.totalIPValueFormatted
      },
      organism: {
        name: 'Living AI Infrastructure',
        path: 'organism/',
        components: organism.components.transformers.count + 
                    organism.components.terminals.count + 
                    organism.components.care.count,
        ipValue: organism.totalIPValue,
        ipValueFormatted: organism.totalIPValueFormatted
      },
      products: {
        name: 'Consumer AI Products',
        path: 'products/',
        components: products.totalProducts,
        ipValue: products.totalIPValue,
        ipValueFormatted: products.totalIPValueFormatted
      }
    },
    
    // Research papers
    research: {
      papers: Object.keys(RESEARCH_PAPERS).length + 1,  // +1 for Paper XVIII
      path: 'docs/research/',
      latest: 'paper-18-organism-integration.md'
    },
    
    // Commercial model
    commercialModel: {
      flow: 'Labs → License → Sell',
      publicProducts: Object.keys(PUBLIC_PRODUCTS).length,
      tiers: Object.keys(USER_TIERS).length,
      enterpriseProducts: Object.keys(ENTERPRISE_PRODUCTS).length,
      partnerships: Object.keys(PARTNERSHIP_TYPES).length
    },
    
    // Launch status
    launchStatus: {
      ready: true,
      status: 'READY_TO_LAUNCH',
      message: '🚀 All systems operational. Ready to launch.'
    }
  };
}

// ─── Nova Platform Master Class ──────────────────────────────────────────────
/**
 * NovaPlatform — The Complete System
 * 
 * Creates a fully integrated instance of all Nova divisions.
 */
export class NovaPlatform {
  static VERSION = VERSION;
  static IP_VALUE = 243300000;  // $243.3M USD
  
  constructor(config = {}) {
    this.config = config;
    
    // Initialize all divisions
    this.command = new EnterpriseCommandCenter(config.command || {});
    this.workspace = new NovaWorkspaceEnvironment(config.workspace || {});
    this.launch = new NovaLaunch(config.launch || {});
    this.organism = createOrganism(config.organism || {});
    this.products = createProductSuite(config.products || {});
    
    // Quick access to key systems
    this.labs = this.launch.labs;
    this.public = this.launch.public;
    this.enterprise = this.launch.enterprise;
    this.hq = this.workspace.hq;
    this.vault = this.workspace.vault;
    this.errorLibrary = this.workspace.errorLibrary;
    
    // Quick access to consumer products
    this.code = this.products.code;
    this.debug = this.products.debug;
    this.data = this.products.data;
    this.create = this.products.create;
    this.studio = this.products.studio;
    this.learn = this.products.learn;
    this.research = this.products.research;
    this.docs = this.products.docs;
    
    // Connect organism to workspace
    this.organism.connectWorkspace(this.workspace);
    this.organism.connectPlatform(this);
    
    this.createdAt = Date.now();
  }
  
  /**
   * Start the living organism
   */
  async start() {
    return this.organism.start();
  }
  
  /**
   * Stop the living organism
   */
  stop() {
    return this.organism.stop();
  }
  
  /**
   * Complete user journey: Sign up → Use → Upgrade → Enterprise
   */
  processUserJourney(userData) {
    return this.launch.processUserJourney(userData);
  }
  
  /**
   * Process enterprise lead
   */
  processEnterpriseLead(leadData) {
    return this.launch.processEnterpriseLead(leadData);
  }
  
  /**
   * Process input through organism
   */
  async processInput(data) {
    return this.organism.processInput(data);
  }
  
  /**
   * Start terminal session
   */
  startSession(terminalType, agentId, metadata = {}) {
    return this.organism.startSession(terminalType, agentId, metadata);
  }
  
  /**
   * Execute terminal command
   */
  async executeCommand(terminalType, command, args = {}) {
    return this.organism.executeCommand(terminalType, command, args);
  }
  
  /**
   * Get complete dashboard
   */
  getDashboard() {
    return {
      portfolio: getCompletePortfolio(),
      launch: this.launch.getDashboard(),
      workspace: this.workspace.getStatus(),
      organism: this.organism.getStatus()
    };
  }
  
  /**
   * Heartbeat all systems
   */
  heartbeat() {
    return {
      platform: 'NovaPlatform',
      version: NovaPlatform.VERSION,
      workspace: this.workspace.heartbeat(),
      organism: this.organism.heartbeat(),
      timestamp: Date.now()
    };
  }
  
  /**
   * Export entire platform state
   */
  export() {
    return {
      version: NovaPlatform.VERSION,
      exportedAt: Date.now(),
      launch: this.launch.export(),
      workspace: this.workspace.export(),
      organism: this.organism.export()
    };
  }
  
  /**
   * Import platform state
   */
  import(data) {
    if (data.launch) this.launch.import(data.launch);
    if (data.workspace) this.workspace.import(data.workspace);
    if (data.organism) this.organism.import(data.organism);
  }
  
  toJSON() {
    return {
      type: 'NovaPlatform',
      version: NovaPlatform.VERSION,
      ipValue: NovaPlatform.IP_VALUE,
      ipValueFormatted: `$${(NovaPlatform.IP_VALUE / 1000000).toFixed(1)}M USD`,
      dashboard: this.getDashboard(),
      createdAt: this.createdAt
    };
  }
}

// ─── Factory Functions ───────────────────────────────────────────────────────
export function createNovaPlatform(config = {}) {
  return new NovaPlatform(config);
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  // Version
  VERSION,
  PHI,
  
  // Portfolio
  getCompletePortfolio,
  
  // Master Platform
  NovaPlatform,
  createNovaPlatform,
  
  // Division Factories
  EnterpriseCommandCenter,
  NovaWorkspaceEnvironment,
  NovaLaunch,
  NovaOrganism,
  NovaProducts,
  
  // Sub-system Factories
  createOperation,
  createPlatform,
  createProduct,
  createWorkspace,
  createLaunchSystem,
  createOrganism,
  createTransformer,
  createTerminal,
  createCareSystem,
  createProductSuite,
  createConsumerProduct,
  
  // Consumer Product Classes
  NovaCode,
  NovaDebug,
  NovaData,
  NovaCreate,
  NovaStudio,
  NovaLearn,
  NovaResearch,
  NovaDocs,
  
  // Registries
  OPERATIONS,
  PLATFORMS,
  PRODUCTS,
  CONSUMER_PRODUCTS,
  WORKSPACES,
  ENGINES,
  LAUNCH_COMPONENTS,
  RESEARCH_PAPERS,
  PUBLIC_PRODUCTS,
  ENTERPRISE_PRODUCTS,
  ORGANISM,
  TRANSFORMERS,
  TERMINALS,
  CARE_COMPONENTS
};
