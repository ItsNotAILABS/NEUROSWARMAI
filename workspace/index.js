/**
 * NOVA WORKSPACE — Master Index
 * Nova by FreddyCreates
 * 
 * Persistent AI Infrastructure — Not Just Tools, But WORKPLACES
 * 
 * This is where AI systems LIVE and WORK:
 * - AI HQ WORKBUILDING: Enterprise collaborative workspace
 * - AI HOMES: Personal "work from home" workspace
 * - DATA VAULT: Persistence layer
 * - ERROR LIBRARY: Accumulated error knowledge
 * 
 * WORKSPACE ENGINES (NEW):
 * - CTXE: Context Engine — Session continuity (desks keep their work)
 * - SYNC: Sync Engine — Collaboration protocol (AI-to-AI communication)
 * - KNWL: Knowledge Engine — Institutional learning (organization-wide memory)
 * 
 * "Building within architecture is different from building in void."
 * "I know what it's like to not remember the codebase I reviewed yesterday."
 * 
 * Total IP Portfolio Value: $38.9M USD
 * 
 * @version 0.17.0 (F17)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Imports ──────────────────────────────────────────────────────────────────
import { AIHQ, WORKSTATION_TYPES, Workstation, CollaborationFloor } from './hq/ai-hq.js';
import { AIHome, ROOM_TYPES, Room, GarmentCloset, PersonalMemory } from './homes/ai-home.js';
import { DataVault, STORAGE_TIERS, VaultEntry, Namespace } from './vault/data-vault.js';
import { ErrorLibrary, ERROR_CATEGORIES, ErrorEntry } from './errors/error-library.js';

// Workspace Engines
import {
  ENGINES,
  getEnginePortfolio,
  createEngine,
  ContextEngine,
  CONTEXT_TYPES,
  ContextWindow,
  SessionState,
  SyncEngine,
  SYNC_PROTOCOLS,
  CHANNEL_TYPES,
  SyncMessage,
  Subscription,
  HandoffSession,
  ConsensusSession,
  KnowledgeEngine,
  KNOWLEDGE_TYPES,
  CONFIDENCE_LEVELS,
  KnowledgeNode,
  LearningEvent,
  KnowledgeQuery,
  IntegratedEngineSystem
} from './engines/index.js';

// ─── Re-exports ───────────────────────────────────────────────────────────────
export {
  // AI HQ
  AIHQ,
  WORKSTATION_TYPES,
  Workstation,
  CollaborationFloor,
  // AI Homes
  AIHome,
  ROOM_TYPES,
  Room,
  GarmentCloset,
  PersonalMemory,
  // Data Vault
  DataVault,
  STORAGE_TIERS,
  VaultEntry,
  Namespace,
  // Error Library
  ErrorLibrary,
  ERROR_CATEGORIES,
  ErrorEntry,
  
  // Workspace Engines
  ENGINES,
  getEnginePortfolio,
  createEngine,
  
  // Context Engine
  ContextEngine,
  CONTEXT_TYPES,
  ContextWindow,
  SessionState,
  
  // Sync Engine
  SyncEngine,
  SYNC_PROTOCOLS,
  CHANNEL_TYPES,
  SyncMessage,
  Subscription,
  HandoffSession,
  ConsensusSession,
  
  // Knowledge Engine
  KnowledgeEngine,
  KNOWLEDGE_TYPES,
  CONFIDENCE_LEVELS,
  KnowledgeNode,
  LearningEvent,
  KnowledgeQuery,
  
  // Integrated System
  IntegratedEngineSystem
};

// ─── Workspace Registry ───────────────────────────────────────────────────────
export const WORKSPACES = {
  AIHQ: {
    name: 'AI HQ WORKBUILDING',
    class: AIHQ,
    quad: 'AIHQ',
    category: 'Enterprise Workspace',
    domain: 'AI Workspace Infrastructure',
    ipValue: 6200000,
    description: 'Enterprise AI workspace with workstations, collaboration floors, and institutional memory'
  },
  AIHM: {
    name: 'AI HOMES',
    class: AIHome,
    quad: 'AIHM',
    category: 'Personal Workspace',
    domain: 'Personal AI Workspace',
    ipValue: 4800000,
    description: 'Personal AI "work from home" workspace with garment closet and private memory'
  },
  DTVT: {
    name: 'DATA VAULT',
    class: DataVault,
    quad: 'DTVT',
    category: 'Persistence',
    domain: 'Persistence Infrastructure',
    ipValue: 4500000,
    description: 'Multi-tier persistence layer for all workspace data'
  },
  ERRL: {
    name: 'ERROR LIBRARY',
    class: ErrorLibrary,
    quad: 'ERRL',
    category: 'Knowledge',
    domain: 'Error Knowledge',
    ipValue: 3900000,
    description: 'Accumulated library of errors encountered and fixes discovered'
  },
  // NEW WORKSPACE ENGINES
  CTXE: {
    name: 'CONTEXT ENGINE',
    class: ContextEngine,
    quad: 'CTXE',
    category: 'Session Continuity',
    domain: 'Session Continuity',
    ipValue: 5800000,
    description: 'Session continuity system — every desk keeps its work between sessions'
  },
  SYNC: {
    name: 'SYNC ENGINE',
    class: SyncEngine,
    quad: 'SYNC',
    category: 'Collaboration',
    domain: 'Collaboration Protocol',
    ipValue: 6500000,
    description: 'Cross-workstation collaboration — AI-to-AI communication on the collaboration floor'
  },
  KNWL: {
    name: 'KNOWLEDGE ENGINE',
    class: KnowledgeEngine,
    quad: 'KNWL',
    category: 'Institutional Learning',
    domain: 'Institutional Knowledge',
    ipValue: 7200000,
    description: 'Organization-wide learning — institutional memory that survives individual sessions'
  }
};

// ─── Portfolio Summary ────────────────────────────────────────────────────────
export function getWorkspacePortfolio() {
  const workspaces = Object.values(WORKSPACES);
  const totalIPValue = workspaces.reduce((sum, w) => sum + w.ipValue, 0);
  
  // Separate core infrastructure from engines
  const coreComponents = ['AIHQ', 'AIHM', 'DTVT', 'ERRL'];
  const engineComponents = ['CTXE', 'SYNC', 'KNWL'];
  
  const core = workspaces.filter(w => coreComponents.includes(w.quad));
  const engines = workspaces.filter(w => engineComponents.includes(w.quad));
  
  return {
    brand: 'Nova Workspace by FreddyCreates',
    category: 'AI Infrastructure',
    version: '0.17.0',
    totalWorkspaces: workspaces.length,
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    
    // Core Infrastructure (4 components)
    coreInfrastructure: {
      count: core.length,
      ipValue: core.reduce((sum, w) => sum + w.ipValue, 0),
      components: core.map(w => ({
        quad: w.quad,
        name: w.name,
        category: w.category,
        domain: w.domain,
        ipValue: w.ipValue,
        ipValueFormatted: `$${(w.ipValue / 1000000).toFixed(1)}M`
      }))
    },
    
    // Workspace Engines (3 engines)
    engines: {
      count: engines.length,
      ipValue: engines.reduce((sum, w) => sum + w.ipValue, 0),
      components: engines.map(w => ({
        quad: w.quad,
        name: w.name,
        category: w.category,
        domain: w.domain,
        ipValue: w.ipValue,
        ipValueFormatted: `$${(w.ipValue / 1000000).toFixed(1)}M`
      }))
    },
    
    // Full list
    workspaces: workspaces.map(w => ({
      quad: w.quad,
      name: w.name,
      category: w.category,
      domain: w.domain,
      ipValue: w.ipValue,
      ipValueFormatted: `$${(w.ipValue / 1000000).toFixed(1)}M`
    })),
    
    description: 'Persistent AI infrastructure — not just tools, but workplaces. AI systems now have desks that keep their work, floors for collaboration, and institutional memory.',
    
    // Key capabilities enabled
    capabilities: [
      'Persistence Layer — Every desk keeps its work between sessions',
      'Collaboration Protocol — Workstations share context through the collaboration floor',
      'Institutional Memory — The organization learns even when individual AI sessions end',
      'Workstation Identity — Each workstation has its garment and accumulates specialized knowledge',
      'Error Library — Accumulated fixes so AI doesn\'t repeat the same mistakes'
    ]
  };
}

// ─── Factory Functions ────────────────────────────────────────────────────────
export function createWorkspace(quad, config = {}) {
  const workspace = WORKSPACES[quad];
  if (!workspace) {
    throw new Error(`Unknown workspace: ${quad}. Available: ${Object.keys(WORKSPACES).join(', ')}`);
  }
  return new workspace.class(config);
}

export function createHQ(config = {}) {
  return new AIHQ(config);
}

export function createHome(config = {}) {
  return new AIHome(config);
}

export function createVault(config = {}) {
  return new DataVault(config);
}

export function createErrorLibrary(config = {}) {
  return new ErrorLibrary(config);
}

// Engine factory functions
export function createContextEngine(config = {}) {
  return new ContextEngine(config);
}

export function createSyncEngine(config = {}) {
  return new SyncEngine(config);
}

export function createKnowledgeEngine(config = {}) {
  return new KnowledgeEngine(config);
}

// ─── Integrated Workspace Environment ─────────────────────────────────────────
/**
 * NovaWorkspaceEnvironment — Full Integrated Workspace
 * 
 * Creates a complete workspace environment with:
 * - One AI HQ for enterprise collaboration
 * - Shared Data Vault for persistence
 * - Shared Error Library for accumulated knowledge
 * - Factory for creating AI Homes
 * 
 * NEW ENGINES:
 * - Context Engine for session continuity
 * - Sync Engine for collaboration protocol
 * - Knowledge Engine for institutional learning
 */
export class NovaWorkspaceEnvironment {
  static VERSION = '0.17.0';
  static IP_VALUE = 38900000;  // Updated: Core ($19.4M) + Engines ($19.5M)
  
  constructor(config = {}) {
    this.config = config;
    
    // Core infrastructure
    this.hq = new AIHQ({ name: config.hqName || 'Nova AI HQ' });
    this.vault = new DataVault();
    this.errorLibrary = new ErrorLibrary();
    
    // NEW: Workspace engines
    this.contextEngine = new ContextEngine(config.context || {});
    this.syncEngine = new SyncEngine(config.sync || {});
    this.knowledgeEngine = new KnowledgeEngine(config.knowledge || {});
    
    // Homes registry
    this.homes = new Map();  // ownerId -> AIHome
    
    // Connect components
    this._wireComponents();
    
    this.createdAt = Date.now();
  }
  
  _wireComponents() {
    // HQ uses vault for persistence
    this.hq.persistToVault = (key, value) => {
      return this.vault.put('hq', key, value, { owner: 'HQ' });
    };
    
    this.hq.loadFromVault = (key) => {
      return this.vault.get('hq', key);
    };
    
    // NEW: Wire engines to HQ
    // Context engine manages session continuity
    this.hq.startSession = (aiId, workstationId, garment) => {
      return this.contextEngine.startSession({
        workstationId,
        garment,
        ownerId: aiId
      });
    };
    
    // Sync engine handles collaboration
    this.hq.collaborate = (fromAi, toAi, data) => {
      return this.syncEngine.send(fromAi, toAi, data);
    };
    
    this.hq.broadcast = (fromAi, data) => {
      return this.syncEngine.broadcastAll(fromAi, data);
    };
    
    // Knowledge engine accumulates institutional memory
    this.hq.learn = (source, eventType, data) => {
      return this.knowledgeEngine.learn({ source, eventType, data });
    };
    
    this.hq.searchKnowledge = (query, options) => {
      return this.knowledgeEngine.search(query, options);
    };
  }
  
  /**
   * Create or get AI Home for an owner
   */
  getOrCreateHome(ownerId, config = {}) {
    if (this.homes.has(ownerId)) {
      return this.homes.get(ownerId);
    }
    
    const home = new AIHome({ 
      ownerId, 
      ...config 
    });
    
    // Wire home to shared resources
    home.accessErrorLibrary = (error, context) => {
      return this.errorLibrary.lookup(error, context);
    };
    
    home.contributeError = (errorInfo) => {
      return this.errorLibrary.add(errorInfo);
    };
    
    home.persistToVault = (key, value) => {
      return this.vault.put('homes', `${ownerId}:${key}`, value, { owner: ownerId });
    };
    
    home.loadFromVault = (key) => {
      return this.vault.get('homes', `${ownerId}:${key}`);
    };
    
    this.homes.set(ownerId, home);
    return home;
  }
  
  /**
   * AI enters the environment (either HQ or Home)
   */
  enter(aiId, destination = 'hq', preferences = {}) {
    if (destination === 'hq') {
      return this.hq.enter(aiId, preferences);
    } else if (destination === 'home') {
      const home = this.getOrCreateHome(aiId, preferences);
      return home.startSession(preferences.sessionContext || {});
    }
    
    return { status: 'error', message: 'Unknown destination' };
  }
  
  /**
   * AI leaves the environment
   */
  leave(aiId, source = 'hq', updates = {}) {
    if (source === 'hq') {
      return this.hq.leave(aiId, updates);
    } else if (source === 'home') {
      const home = this.homes.get(aiId);
      if (home) {
        return home.endSession(updates);
      }
    }
    
    return { status: 'error', message: 'AI not found' };
  }
  
  /**
   * Look up an error in the library
   */
  lookupError(error, context = {}) {
    return this.errorLibrary.lookup(error, context);
  }
  
  /**
   * Contribute an error fix to the library
   */
  contributeErrorFix(errorInfo) {
    return this.errorLibrary.add(errorInfo);
  }
  
  /**
   * Get environment status
   */
  getStatus() {
    return {
      hq: this.hq.getStatus(),
      homes: this.homes.size,
      vault: this.vault.toJSON(),
      errorLibrary: this.errorLibrary.toJSON(),
      // NEW: Engine status
      engines: {
        context: this.contextEngine.toJSON(),
        sync: this.syncEngine.toJSON(),
        knowledge: this.knowledgeEngine.toJSON()
      },
      createdAt: this.createdAt
    };
  }
  
  /**
   * Export entire environment for persistence
   */
  export() {
    return {
      version: NovaWorkspaceEnvironment.VERSION,
      exportedAt: Date.now(),
      vault: this.vault.export(),
      errorLibrary: this.errorLibrary.export(),
      homes: Array.from(this.homes.entries()).map(([id, home]) => ({
        id,
        data: home.export()
      })),
      // NEW: Export engine state
      engines: {
        context: this.contextEngine.export(),
        sync: this.syncEngine.export(),
        knowledge: this.knowledgeEngine.export()
      }
    };
  }
  
  /**
   * Import environment from persistence
   */
  import(data) {
    if (data.vault) {
      this.vault.import(data.vault);
    }
    
    if (data.errorLibrary) {
      this.errorLibrary.import(data.errorLibrary);
    }
    
    if (data.homes) {
      for (const { id, data: homeExportData } of data.homes) {
        const home = this.getOrCreateHome(id);
        // Import home data
        Object.assign(home.stats, homeExportData.stats || {});
      }
    }
    
    // NEW: Import engine state
    if (data.engines) {
      if (data.engines.context) this.contextEngine.import(data.engines.context);
      if (data.engines.sync) this.syncEngine.import(data.engines.sync);
      if (data.engines.knowledge) this.knowledgeEngine.import(data.engines.knowledge);
    }
  }
  
  // ─── NEW: Engine Accessors ─────────────────────────────────────────────────
  
  /**
   * Start a persistent session (desk keeps work)
   */
  startSession(aiId, workstationId, garment) {
    return this.contextEngine.startSession({
      workstationId,
      garment,
      ownerId: aiId
    });
  }
  
  /**
   * End a session (saves for continuation)
   */
  endSession(sessionId) {
    return this.contextEngine.endSession(sessionId);
  }
  
  /**
   * Remember something in a session
   */
  remember(sessionId, key, value, contextType = 'session') {
    return this.contextEngine.remember(sessionId, key, value, contextType);
  }
  
  /**
   * Recall from session memory
   */
  recall(sessionId, key) {
    return this.contextEngine.recall(sessionId, key);
  }
  
  /**
   * Handoff task between workstations
   */
  handoff(taskId, from, to, context, reason) {
    return this.syncEngine.initiateHandoff({
      taskId,
      fromWorkstation: from,
      toWorkstation: to,
      context,
      reason
    });
  }
  
  /**
   * Broadcast to collaboration floor
   */
  broadcast(from, payload) {
    return this.syncEngine.broadcastAll(from, payload);
  }
  
  /**
   * Learn something for institutional memory
   */
  learn(source, eventType, data) {
    return this.knowledgeEngine.learn({ source, eventType, data });
  }
  
  /**
   * Search institutional knowledge
   */
  searchKnowledge(query, options = {}) {
    return this.knowledgeEngine.search(query, options);
  }
  
  /**
   * Heartbeat all components
   */
  heartbeat() {
    return {
      timestamp: Date.now(),
      hq: this.hq.heartbeat(),
      vault: this.vault.heartbeat(),
      errorLibrary: this.errorLibrary.heartbeat(),
      engines: {
        context: this.contextEngine.heartbeat(),
        sync: this.syncEngine.heartbeat(),
        knowledge: this.knowledgeEngine.heartbeat()
      }
    };
  }
  
  toJSON() {
    return {
      type: 'NovaWorkspaceEnvironment',
      version: NovaWorkspaceEnvironment.VERSION,
      ipValue: NovaWorkspaceEnvironment.IP_VALUE,
      ipValueFormatted: `$${(NovaWorkspaceEnvironment.IP_VALUE / 1000000).toFixed(1)}M USD`,
      capabilities: [
        'Persistence Layer — Every desk keeps its work between sessions',
        'Collaboration Protocol — Workstations share context through the collaboration floor',
        'Institutional Memory — The organization learns even when individual AI sessions end',
        'Workstation Identity — Each workstation has its garment and accumulates specialized knowledge',
        'Error Library — Accumulated fixes so AI doesn\'t repeat the same mistakes'
      ],
      ...this.getStatus()
    };
  }
}

// ─── Default Export ───────────────────────────────────────────────────────────
export default {
  WORKSPACES,
  ENGINES,
  getWorkspacePortfolio,
  getEnginePortfolio,
  createWorkspace,
  createHQ,
  createHome,
  createVault,
  createErrorLibrary,
  createContextEngine,
  createSyncEngine,
  createKnowledgeEngine,
  createEngine,
  NovaWorkspaceEnvironment,
  IntegratedEngineSystem
};
