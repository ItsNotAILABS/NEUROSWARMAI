/**
 * WORKSPACE ENGINES — Index
 * Nova by FreddyCreates
 * 
 * The engines that power AI Workspace infrastructure:
 * - CTXE: Context Engine — Session continuity
 * - SYNC: Sync Engine — Collaboration protocol
 * - KNWL: Knowledge Engine — Institutional learning
 * 
 * Combined with the four core workspace components:
 * - AIHQ: AI HQ Workbuilding
 * - AIHM: AI Homes
 * - DTVT: Data Vault
 * - ERRL: Error Library
 * 
 * @version 0.17.0 (F17)
 * @copyright Nova Protocol by FreddyCreates
 */

// ─── Engine Imports ──────────────────────────────────────────────────────────
import { ContextEngine, CONTEXT_TYPES, ContextWindow, SessionState } from './context-engine.js';
import { SyncEngine, SYNC_PROTOCOLS, CHANNEL_TYPES, SyncMessage, Subscription, HandoffSession, ConsensusSession } from './sync-engine.js';
import { KnowledgeEngine, KNOWLEDGE_TYPES, CONFIDENCE_LEVELS, KnowledgeNode, LearningEvent, KnowledgeQuery } from './knowledge-engine.js';

// ─── Re-exports ──────────────────────────────────────────────────────────────
export {
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
  KnowledgeQuery
};

// ─── Engine Registry ─────────────────────────────────────────────────────────
export const ENGINES = {
  CTXE: {
    name: 'Context Engine',
    class: ContextEngine,
    quad: 'CTXE',
    category: 'Session Continuity',
    domain: 'Session Continuity',
    ipValue: 5800000,
    description: 'Session continuity and context management — desks keep their work'
  },
  SYNC: {
    name: 'Sync Engine',
    class: SyncEngine,
    quad: 'SYNC',
    category: 'Collaboration',
    domain: 'Collaboration Protocol',
    ipValue: 6500000,
    description: 'Cross-workstation collaboration and handoff protocols'
  },
  KNWL: {
    name: 'Knowledge Engine',
    class: KnowledgeEngine,
    quad: 'KNWL',
    category: 'Institutional Learning',
    domain: 'Institutional Knowledge',
    ipValue: 7200000,
    description: 'Organizational knowledge graph and learning system'
  }
};

// ─── Factory Functions ───────────────────────────────────────────────────────
export function createEngine(quad, config = {}) {
  const engine = ENGINES[quad];
  if (!engine) {
    throw new Error(`Unknown engine: ${quad}. Available: ${Object.keys(ENGINES).join(', ')}`);
  }
  return new engine.class(config);
}

export function createContextEngine(config = {}) {
  return new ContextEngine(config);
}

export function createSyncEngine(config = {}) {
  return new SyncEngine(config);
}

export function createKnowledgeEngine(config = {}) {
  return new KnowledgeEngine(config);
}

// ─── Portfolio ───────────────────────────────────────────────────────────────
export function getEnginePortfolio() {
  const engines = Object.values(ENGINES);
  const totalIPValue = engines.reduce((sum, e) => sum + e.ipValue, 0);
  
  return {
    brand: 'Nova Workspace Engines by FreddyCreates',
    category: 'AI Infrastructure Engines',
    version: '0.17.0',
    totalEngines: engines.length,
    totalIPValue,
    totalIPValueFormatted: `$${(totalIPValue / 1000000).toFixed(1)}M USD`,
    engines: engines.map(e => ({
      quad: e.quad,
      name: e.name,
      category: e.category,
      domain: e.domain,
      ipValue: e.ipValue,
      ipValueFormatted: `$${(e.ipValue / 1000000).toFixed(1)}M`
    })),
    description: 'Engines powering persistent AI workspace infrastructure'
  };
}

// ─── Integrated Engine System ────────────────────────────────────────────────
/**
 * IntegratedEngineSystem — All engines working together
 */
export class IntegratedEngineSystem {
  static VERSION = '0.17.0';
  static IP_VALUE = 19500000;  // Combined IP value
  
  constructor(config = {}) {
    this.config = config;
    
    // Initialize all engines
    this.context = new ContextEngine(config.context || {});
    this.sync = new SyncEngine(config.sync || {});
    this.knowledge = new KnowledgeEngine(config.knowledge || {});
    
    // Wire engines together
    this._wireEngines();
    
    this.createdAt = Date.now();
  }
  
  _wireEngines() {
    // Context changes trigger sync broadcasts
    this.context.onContextChange = (sessionId, change) => {
      this.sync.publish(sessionId, 'context-updates', {
        sessionId,
        change,
        timestamp: Date.now()
      });
    };
    
    // Learning events update knowledge engine
    this.context.onInsight = (insight) => {
      this.knowledge.learn({
        source: 'context-engine',
        eventType: 'inference',
        data: {
          content: insight,
          tags: ['auto-inferred'],
          confidence: 0.6
        }
      });
    };
    
    // Sync events can trigger learning
    this.sync.onConsensusReached = (session) => {
      this.knowledge.learn({
        source: 'sync-engine',
        eventType: 'observation',
        data: {
          type: 'FACT',
          content: {
            topic: session.topic,
            decision: session.proposal,
            result: session.status
          },
          tags: ['consensus', 'decision'],
          confidence: 0.8
        }
      });
    };
  }
  
  /**
   * Start a session with full engine support
   */
  startSession(config) {
    // Start context session
    const session = this.context.startSession(config);
    
    // Register as sync endpoint
    this.sync.registerEndpoint(session.sessionId, {
      type: 'session',
      garment: config.garment
    });
    
    return session;
  }
  
  /**
   * End a session
   */
  endSession(sessionId) {
    // Capture any final insights for knowledge
    const session = this.context.getSession(sessionId);
    if (session) {
      const summary = session.getContextSummary();
      
      // Learn from session
      if (summary.interactionCount > 10) {  // Substantial session
        this.knowledge.learn({
          source: sessionId,
          eventType: 'observation',
          data: {
            type: 'PATTERN',
            content: {
              sessionSummary: true,
              garment: session.garment,
              duration: summary.duration,
              interactions: summary.interactionCount
            },
            tags: ['session-pattern'],
            confidence: 0.5
          }
        });
      }
    }
    
    // End context session
    const result = this.context.endSession(sessionId);
    
    // Unregister from sync
    this.sync.unregisterEndpoint(sessionId);
    
    return result;
  }
  
  /**
   * Collaborate between sessions
   */
  collaborate(fromSession, toSession, data) {
    return this.sync.send(fromSession, toSession, data, {
      protocol: 'REQUEST'
    });
  }
  
  /**
   * Handoff task between workstations
   */
  handoff(taskId, from, to, context, reason) {
    return this.sync.initiateHandoff({
      taskId,
      fromWorkstation: from,
      toWorkstation: to,
      context,
      reason
    });
  }
  
  /**
   * Learn something new
   */
  learn(source, eventType, data) {
    return this.knowledge.learn({ source, eventType, data });
  }
  
  /**
   * Search institutional knowledge
   */
  searchKnowledge(query, options = {}) {
    return this.knowledge.search(query, options);
  }
  
  /**
   * Get system status
   */
  getStatus() {
    return {
      context: this.context.toJSON(),
      sync: this.sync.toJSON(),
      knowledge: this.knowledge.toJSON(),
      createdAt: this.createdAt
    };
  }
  
  /**
   * Export all state
   */
  export() {
    return {
      version: IntegratedEngineSystem.VERSION,
      exportedAt: Date.now(),
      context: this.context.export(),
      sync: this.sync.export(),
      knowledge: this.knowledge.export()
    };
  }
  
  /**
   * Import state
   */
  import(data) {
    if (data.context) this.context.import(data.context);
    if (data.sync) this.sync.import(data.sync);
    if (data.knowledge) this.knowledge.import(data.knowledge);
  }
  
  /**
   * Heartbeat all engines
   */
  heartbeat() {
    return {
      timestamp: Date.now(),
      context: this.context.heartbeat(),
      sync: this.sync.heartbeat(),
      knowledge: this.knowledge.heartbeat()
    };
  }
  
  toJSON() {
    return {
      type: 'IntegratedEngineSystem',
      version: IntegratedEngineSystem.VERSION,
      ipValue: IntegratedEngineSystem.IP_VALUE,
      ...this.getStatus()
    };
  }
}

// ─── Default Export ──────────────────────────────────────────────────────────
export default {
  ENGINES,
  getEnginePortfolio,
  createEngine,
  createContextEngine,
  createSyncEngine,
  createKnowledgeEngine,
  IntegratedEngineSystem
};
