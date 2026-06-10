/**
 * NOVA ORGANISM — Living AI Infrastructure
 * Nova by FreddyCreates
 * 
 * The Organism is the complete living AI system that integrates:
 * - Transformers: Data flow transformation pipelines
 * - Terminals: AGI access interfaces
 * - Care System: Self-healing and maintenance
 * 
 * Connected to:
 * - Workspace: AI HQ, Homes, Vault, Error Library
 * - Command: Enterprise platforms
 * - Platforms: Cognitive Garments
 * - Launch: Commercial infrastructure
 * 
 * "The system that cares for itself."
 * 
 * Total IP Value: $25.4M USD (Transformers + Terminals + Care)
 * 
 * @version 0.19.0 (F19)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Imports ─────────────────────────────────────────────────────────────────
import {
  TRANSFORMER_TYPES,
  TRANSFORMERS,
  Transformer,
  TransformerPipeline,
  InputTransformer,
  ProcessTransformer,
  OutputTransformer,
  SyncTransformer,
  CareTransformer,
  createTransformer,
  getTransformerPortfolio
} from './transformers/index.js';

import {
  TERMINALS,
  ACCESS_LEVELS,
  Terminal,
  HQTerminal,
  HomeTerminal,
  VaultTerminal,
  ErrorTerminal,
  MainTerminal,
  createTerminal,
  getTerminalPortfolio
} from './terminals/index.js';

import {
  CARE_COMPONENTS,
  HEALTH_STATUS,
  CareComponent,
  Healer,
  Synchronizer,
  Preparer,
  Maintainer,
  Watcher,
  CareSystem,
  createCareSystem,
  getCarePortfolio
} from './care/index.js';

// ─── Constants ───────────────────────────────────────────────────────────────
const PHI = 1.618033988749895;
const VERSION = '0.19.0';

// ─── Re-exports ──────────────────────────────────────────────────────────────
export {
  // Transformers
  TRANSFORMER_TYPES,
  TRANSFORMERS,
  Transformer,
  TransformerPipeline,
  InputTransformer,
  ProcessTransformer,
  OutputTransformer,
  SyncTransformer,
  CareTransformer,
  createTransformer,
  getTransformerPortfolio,
  
  // Terminals
  TERMINALS,
  ACCESS_LEVELS,
  Terminal,
  HQTerminal,
  HomeTerminal,
  VaultTerminal,
  ErrorTerminal,
  MainTerminal,
  createTerminal,
  getTerminalPortfolio,
  
  // Care System
  CARE_COMPONENTS,
  HEALTH_STATUS,
  CareComponent,
  Healer,
  Synchronizer,
  Preparer,
  Maintainer,
  Watcher,
  CareSystem,
  createCareSystem,
  getCarePortfolio
};

// ─── Organism Component Registry ─────────────────────────────────────────────
export const ORGANISM = {
  TRANSFORMERS: {
    name: 'Organism Transformers',
    path: 'organism/transformers/',
    type: 'pipeline',
    ipValue: 8400000,
    description: 'Data flow transformation layer'
  },
  TERMINALS: {
    name: 'Organism Terminals',
    path: 'organism/terminals/',
    type: 'interface',
    ipValue: 7800000,
    description: 'AGI access interface layer'
  },
  CARE: {
    name: 'Organism Care System',
    path: 'organism/care/',
    type: 'maintenance',
    ipValue: 9200000,
    description: 'Self-healing and maintenance layer'
  }
};

// ─── Living Organism Class ───────────────────────────────────────────────────
/**
 * NovaOrganism — The Living AI Infrastructure
 * 
 * A complete, self-sustaining AI system that:
 * - Processes data through Transformers
 * - Provides access through Terminals
 * - Maintains itself through the Care System
 * - Integrates with Workspace for persistence
 */
export class NovaOrganism {
  static VERSION = VERSION;
  static IP_VALUE = 25400000;  // $25.4M USD
  
  constructor(config = {}) {
    this.config = config;
    
    // ─── Core Systems ────────────────────────────────────────────────────────
    
    // Care System (initialized first - it watches everything)
    this.care = new CareSystem(config.care || {});
    
    // ─── Transformers ────────────────────────────────────────────────────────
    
    // Input pipeline
    this.inputPipeline = new TransformerPipeline('input', {});
    this.inputPipeline.add(createTransformer('USRI'));
    this.inputPipeline.add(createTransformer('APII'));
    
    // Process pipeline  
    this.processPipeline = new TransformerPipeline('process', {});
    this.processPipeline.add(createTransformer('COGP'));
    this.processPipeline.add(createTransformer('DFLW'));
    this.processPipeline.add(createTransformer('CTXP'));
    
    // Output pipeline
    this.outputPipeline = new TransformerPipeline('output', {});
    this.outputPipeline.add(createTransformer('USRO'));
    this.outputPipeline.add(createTransformer('APIO'));
    
    // Sync pipeline
    this.syncPipeline = new TransformerPipeline('sync', {});
    this.syncPipeline.add(createTransformer('DBSN'));
    this.syncPipeline.add(createTransformer('NTSN'));
    
    // Care pipeline
    this.carePipeline = new TransformerPipeline('care', {});
    this.carePipeline.add(createTransformer('HLTH'));
    this.carePipeline.add(createTransformer('RECO'));
    
    // ─── Terminals ───────────────────────────────────────────────────────────
    
    this.terminals = {
      main: createTerminal('MNTM', { accessLevel: ACCESS_LEVELS.SYSTEM }),
      hq: createTerminal('HQTM', { accessLevel: ACCESS_LEVELS.ADMIN }),
      home: createTerminal('HMTM', { accessLevel: ACCESS_LEVELS.USER }),
      vault: createTerminal('VTTM', { accessLevel: ACCESS_LEVELS.ADMIN }),
      error: createTerminal('ERTM', { accessLevel: ACCESS_LEVELS.WORKER })
    };
    
    // ─── External Connections ────────────────────────────────────────────────
    
    this.workspace = null;  // NovaWorkspaceEnvironment
    this.platform = null;   // NovaPlatform
    
    // ─── State ───────────────────────────────────────────────────────────────
    
    this.running = false;
    this.metrics = {
      processed: 0,
      errors: 0,
      sessions: 0,
      uptime: 0
    };
    
    this.createdAt = Date.now();
  }
  
  // ─── Connection Methods ────────────────────────────────────────────────────
  
  /**
   * Connect workspace infrastructure
   */
  connectWorkspace(workspace) {
    this.workspace = workspace;
    
    // Wire terminals to workspace components
    if (workspace.hq) {
      this.terminals.hq.setHQ(workspace.hq);
    }
    if (workspace.vault) {
      this.terminals.vault.setVault(workspace.vault);
    }
    if (workspace.errorLibrary) {
      this.terminals.error.setErrorLibrary(workspace.errorLibrary);
    }
    
    // Register workspace with care system
    this.care.watcher.watch('workspace.hq', workspace.hq, { maxErrors: 100 });
    this.care.watcher.watch('workspace.vault', workspace.vault, { maxErrors: 50 });
    this.care.watcher.watch('workspace.errorLibrary', workspace.errorLibrary);
    
    this.care.synchronizer.registerTarget('workspace', workspace);
    
    return this;
  }
  
  /**
   * Connect full platform
   */
  connectPlatform(platform) {
    this.platform = platform;
    this.terminals.main.setPlatform(platform);
    
    // Connect workspace if available
    if (platform.workspace) {
      this.connectWorkspace(platform.workspace);
    }
    
    // Register platform with care system
    this.care.watcher.watch('platform', platform);
    this.care.synchronizer.registerTarget('platform', platform);
    
    return this;
  }
  
  // ─── Data Flow Methods ─────────────────────────────────────────────────────
  
  /**
   * Process input through the organism
   */
  async processInput(data) {
    const startTime = Date.now();
    
    try {
      // 1. Input transformation
      const inputResult = await this.inputPipeline.execute(data);
      if (!inputResult.success) {
        throw new Error(inputResult.error || 'Input transformation failed');
      }
      
      // 2. Process transformation
      const processResult = await this.processPipeline.execute(inputResult.data);
      if (!processResult.success) {
        throw new Error(processResult.error || 'Process transformation failed');
      }
      
      // 3. Output transformation
      const outputResult = await this.outputPipeline.execute(processResult.data);
      if (!outputResult.success) {
        throw new Error(outputResult.error || 'Output transformation failed');
      }
      
      this.metrics.processed++;
      
      return {
        success: true,
        data: outputResult.data,
        trace: {
          input: inputResult.trace,
          process: processResult.trace,
          output: outputResult.trace
        },
        latency: Date.now() - startTime
      };
      
    } catch (error) {
      this.metrics.errors++;
      
      // Attempt self-healing
      const healResult = await this.care.heal(error, { data });
      
      return {
        success: false,
        error: error.message,
        healed: healResult.healed,
        latency: Date.now() - startTime
      };
    }
  }
  
  /**
   * Sync data across systems
   */
  async syncData(data) {
    return this.syncPipeline.execute(data);
  }
  
  /**
   * Run care cycle on data
   */
  async careCheck(data) {
    return this.carePipeline.execute(data);
  }
  
  // ─── Terminal Access Methods ───────────────────────────────────────────────
  
  /**
   * Start a terminal session
   */
  startSession(terminalType, agentId, metadata = {}) {
    const terminal = this.terminals[terminalType];
    if (!terminal) {
      return { success: false, error: `Unknown terminal: ${terminalType}` };
    }
    
    const session = terminal.startSession(agentId, metadata);
    this.metrics.sessions++;
    
    return session;
  }
  
  /**
   * End a terminal session
   */
  endSession(terminalType, sessionId) {
    const terminal = this.terminals[terminalType];
    if (!terminal) {
      return { success: false, error: `Unknown terminal: ${terminalType}` };
    }
    
    return terminal.endSession(sessionId);
  }
  
  /**
   * Execute command on terminal
   */
  async executeCommand(terminalType, command, args = {}) {
    const terminal = this.terminals[terminalType];
    if (!terminal) {
      return { success: false, error: `Unknown terminal: ${terminalType}` };
    }
    
    return terminal.execute(command, args);
  }
  
  // ─── Lifecycle Methods ─────────────────────────────────────────────────────
  
  /**
   * Start the organism
   */
  async start() {
    if (this.running) return;
    
    // Prepare system
    await this.care.prepare();
    
    // Start care cycle
    this.care.start();
    
    this.running = true;
    this.metrics.uptime = Date.now();
    
    return {
      started: true,
      timestamp: Date.now()
    };
  }
  
  /**
   * Stop the organism
   */
  stop() {
    this.care.stop();
    this.running = false;
    
    return {
      stopped: true,
      uptime: Date.now() - this.metrics.uptime
    };
  }
  
  /**
   * Heartbeat
   */
  heartbeat() {
    return {
      organism: 'NovaOrganism',
      version: NovaOrganism.VERSION,
      running: this.running,
      metrics: this.metrics,
      terminals: Object.keys(this.terminals).length,
      pipelines: 5,
      care: this.care.heartbeat(),
      timestamp: Date.now()
    };
  }
  
  // ─── Status Methods ────────────────────────────────────────────────────────
  
  /**
   * Get organism status
   */
  getStatus() {
    return {
      version: NovaOrganism.VERSION,
      running: this.running,
      metrics: this.metrics,
      
      pipelines: {
        input: this.inputPipeline.getMetrics(),
        process: this.processPipeline.getMetrics(),
        output: this.outputPipeline.getMetrics(),
        sync: this.syncPipeline.getMetrics(),
        care: this.carePipeline.getMetrics()
      },
      
      terminals: Object.entries(this.terminals).map(([key, term]) => ({
        key,
        ...term.getStatus()
      })),
      
      care: this.care.getStatus(),
      
      connections: {
        workspace: !!this.workspace,
        platform: !!this.platform
      },
      
      uptime: this.running ? Date.now() - this.metrics.uptime : 0,
      createdAt: this.createdAt
    };
  }
  
  /**
   * Export organism state
   */
  export() {
    return {
      version: NovaOrganism.VERSION,
      exportedAt: Date.now(),
      metrics: this.metrics,
      care: this.care.export()
    };
  }
  
  /**
   * Import organism state
   */
  import(data) {
    if (data.metrics) {
      Object.assign(this.metrics, data.metrics);
    }
    // Care system state is internal
  }
  
  toJSON() {
    return {
      type: 'NovaOrganism',
      version: NovaOrganism.VERSION,
      ipValue: NovaOrganism.IP_VALUE,
      ipValueFormatted: `$${(NovaOrganism.IP_VALUE / 1000000).toFixed(1)}M USD`,
      description: 'Living AI Infrastructure — The system that cares for itself',
      ...this.getStatus()
    };
  }
}

// ─── Portfolio ───────────────────────────────────────────────────────────────
export function getOrganismPortfolio() {
  const transformers = getTransformerPortfolio();
  const terminals = getTerminalPortfolio();
  const care = getCarePortfolio();
  
  const totalIPValue = transformers.totalIPValue + terminals.totalIPValue + care.totalIPValue;
  
  return {
    brand: 'Nova Organism by FreddyCreates',
    version: VERSION,
    description: 'Living AI Infrastructure — The system that cares for itself',
    
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    
    components: {
      transformers: {
        count: transformers.totalTransformers,
        ipValue: transformers.totalIPValue,
        ipValueFormatted: transformers.totalIPValueFormatted
      },
      terminals: {
        count: terminals.totalTerminals,
        ipValue: terminals.totalIPValue,
        ipValueFormatted: terminals.totalIPValueFormatted
      },
      care: {
        count: care.totalComponents,
        ipValue: care.totalIPValue,
        ipValueFormatted: care.totalIPValueFormatted
      }
    },
    
    capabilities: [
      'Data Flow: Transform data through input→process→output pipelines',
      'Terminal Access: AGI interfaces to all system components',
      'Self-Healing: Automatic error detection and recovery',
      'State Sync: Cross-component state synchronization',
      'Health Monitoring: Continuous system health tracking',
      'Maintenance: Automated optimization and cleanup'
    ],
    
    details: {
      transformers,
      terminals,
      care
    }
  };
}

// ─── Factory ─────────────────────────────────────────────────────────────────
export function createOrganism(config = {}) {
  return new NovaOrganism(config);
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  VERSION,
  ORGANISM,
  
  // Classes
  NovaOrganism,
  
  // Factory
  createOrganism,
  
  // Portfolio
  getOrganismPortfolio,
  
  // Sub-exports
  transformers: {
    TRANSFORMER_TYPES,
    TRANSFORMERS,
    createTransformer,
    TransformerPipeline
  },
  
  terminals: {
    TERMINALS,
    ACCESS_LEVELS,
    createTerminal
  },
  
  care: {
    CARE_COMPONENTS,
    HEALTH_STATUS,
    CareSystem,
    createCareSystem
  }
};
