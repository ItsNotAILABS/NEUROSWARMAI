/**
 * CONTEXT ENGINE (CTXE) — Session Continuity & Context Management
 * Nova by FreddyCreates
 * 
 * "I know what it's like to not remember the codebase I reviewed yesterday."
 * 
 * This engine ensures AI sessions maintain continuity:
 * - Session context persists across conversations
 * - Working memory survives interruptions
 * - Project state remains intact between sessions
 * - Each workstation "desk" keeps its accumulated work
 * 
 * @version 0.17.0 (F17)
 * @quad CTXE
 * @ipValue $5.8M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Context Types ───────────────────────────────────────────────────────────
export const CONTEXT_TYPES = {
  SESSION: {
    name: 'Session Context',
    ttl: null,  // Never expires during session
    priority: 'critical',
    description: 'Active session state and working memory'
  },
  PROJECT: {
    name: 'Project Context',
    ttl: 30 * 24 * 60 * 60 * 1000,  // 30 days
    priority: 'high',
    description: 'Project-specific state, files, decisions'
  },
  DOMAIN: {
    name: 'Domain Context',
    ttl: 90 * 24 * 60 * 60 * 1000,  // 90 days
    priority: 'medium',
    description: 'Domain expertise and patterns learned'
  },
  HISTORICAL: {
    name: 'Historical Context',
    ttl: null,  // Permanent
    priority: 'low',
    description: 'Long-term patterns and insights'
  }
};

// ─── Context Window ──────────────────────────────────────────────────────────
/**
 * ContextWindow — Sliding window of relevant context
 */
class ContextWindow {
  constructor(maxSize = 100) {
    this.maxSize = maxSize;
    this.items = [];
    this.relevanceScores = new Map();
  }
  
  /**
   * Add item to window with relevance decay
   */
  add(item, relevance = 1.0) {
    const entry = {
      id: `ctx-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`,
      item,
      relevance,
      addedAt: Date.now(),
      accessCount: 0,
      lastAccessed: Date.now()
    };
    
    this.items.unshift(entry);
    this.relevanceScores.set(entry.id, relevance);
    
    // Apply relevance decay to older items
    this._applyDecay();
    
    // Enforce max size
    this._enforceMaxSize();
    
    return entry.id;
  }
  
  /**
   * Get most relevant items
   */
  getRelevant(limit = 10, minRelevance = 0.1) {
    return this.items
      .filter(item => this.relevanceScores.get(item.id) >= minRelevance)
      .sort((a, b) => 
        this.relevanceScores.get(b.id) - this.relevanceScores.get(a.id)
      )
      .slice(0, limit)
      .map(entry => {
        entry.accessCount++;
        entry.lastAccessed = Date.now();
        // Boost relevance on access
        this.relevanceScores.set(
          entry.id, 
          Math.min(1.0, this.relevanceScores.get(entry.id) * 1.1)
        );
        return entry.item;
      });
  }
  
  /**
   * Boost relevance of specific items
   */
  boost(itemId, amount = 0.2) {
    if (this.relevanceScores.has(itemId)) {
      const current = this.relevanceScores.get(itemId);
      this.relevanceScores.set(itemId, Math.min(1.0, current + amount));
    }
  }
  
  /**
   * Apply φ-based decay to relevance scores
   */
  _applyDecay() {
    const decayFactor = 1 / PHI;
    for (let i = 1; i < this.items.length; i++) {
      const entry = this.items[i];
      const current = this.relevanceScores.get(entry.id);
      this.relevanceScores.set(
        entry.id, 
        current * Math.pow(decayFactor, 0.1)
      );
    }
  }
  
  _enforceMaxSize() {
    while (this.items.length > this.maxSize) {
      const removed = this.items.pop();
      this.relevanceScores.delete(removed.id);
    }
  }
  
  size() {
    return this.items.length;
  }
  
  clear() {
    this.items = [];
    this.relevanceScores.clear();
  }
  
  toJSON() {
    return {
      size: this.items.length,
      maxSize: this.maxSize,
      items: this.items.map(e => ({
        id: e.id,
        relevance: this.relevanceScores.get(e.id),
        addedAt: e.addedAt,
        accessCount: e.accessCount
      }))
    };
  }
}

// ─── Session State ───────────────────────────────────────────────────────────
/**
 * SessionState — Complete state for one work session
 */
class SessionState {
  constructor({ sessionId, workstationId, garment, ownerId }) {
    this.sessionId = sessionId || `sess-${Date.now()}`;
    this.workstationId = workstationId;
    this.garment = garment;  // CODR, DBGR, DATA, etc.
    this.ownerId = ownerId;
    
    // Working memory
    this.workingMemory = new Map();
    
    // Context windows
    this.contextWindows = {
      immediate: new ContextWindow(50),   // Very recent
      session: new ContextWindow(200),    // This session
      project: new ContextWindow(500),    // Project scope
      domain: new ContextWindow(1000)     // Domain expertise
    };
    
    // Current focus
    this.focus = {
      activeFile: null,
      activeProject: null,
      activeTask: null,
      stack: []  // Focus stack for nested contexts
    };
    
    // Session timeline
    this.timeline = [];
    
    // Session metadata
    this.startedAt = Date.now();
    this.lastActivity = Date.now();
    this.interactionCount = 0;
  }
  
  /**
   * Record an action in the session
   */
  recordAction(action, context = {}) {
    const event = {
      timestamp: Date.now(),
      action,
      context,
      focus: { ...this.focus }
    };
    
    this.timeline.push(event);
    this.lastActivity = Date.now();
    this.interactionCount++;
    
    // Add to immediate context
    this.contextWindows.immediate.add({ action, context });
    
    return event;
  }
  
  /**
   * Set current focus
   */
  setFocus(type, value) {
    // Push current to stack
    if (this.focus[type] && this.focus[type] !== value) {
      this.focus.stack.push({
        type,
        value: this.focus[type],
        timestamp: Date.now()
      });
    }
    
    this.focus[type] = value;
    this.lastActivity = Date.now();
  }
  
  /**
   * Pop focus from stack
   */
  popFocus(type) {
    for (let i = this.focus.stack.length - 1; i >= 0; i--) {
      if (this.focus.stack[i].type === type) {
        const popped = this.focus.stack.splice(i, 1)[0];
        this.focus[type] = popped.value;
        return popped;
      }
    }
    return null;
  }
  
  /**
   * Store in working memory
   */
  remember(key, value, contextType = 'session') {
    this.workingMemory.set(key, {
      value,
      contextType,
      storedAt: Date.now(),
      accessCount: 0
    });
    
    // Also add to appropriate context window
    this.contextWindows[contextType]?.add({ key, value });
  }
  
  /**
   * Recall from working memory
   */
  recall(key) {
    const item = this.workingMemory.get(key);
    if (item) {
      item.accessCount++;
      item.lastAccessed = Date.now();
      return item.value;
    }
    return null;
  }
  
  /**
   * Get context summary for continuation
   */
  getContextSummary() {
    return {
      sessionId: this.sessionId,
      workstationId: this.workstationId,
      garment: this.garment,
      focus: this.focus,
      recentActions: this.timeline.slice(-10),
      immediateContext: this.contextWindows.immediate.getRelevant(5),
      sessionContext: this.contextWindows.session.getRelevant(10),
      duration: Date.now() - this.startedAt,
      interactionCount: this.interactionCount,
      workingMemorySize: this.workingMemory.size
    };
  }
  
  /**
   * Export for persistence
   */
  export() {
    return {
      sessionId: this.sessionId,
      workstationId: this.workstationId,
      garment: this.garment,
      ownerId: this.ownerId,
      focus: this.focus,
      workingMemory: Array.from(this.workingMemory.entries()),
      timeline: this.timeline.slice(-100),  // Keep last 100 events
      contextWindows: {
        immediate: this.contextWindows.immediate.toJSON(),
        session: this.contextWindows.session.toJSON(),
        project: this.contextWindows.project.toJSON(),
        domain: this.contextWindows.domain.toJSON()
      },
      startedAt: this.startedAt,
      lastActivity: this.lastActivity,
      interactionCount: this.interactionCount
    };
  }
  
  /**
   * Import from persistence
   */
  static import(data) {
    const session = new SessionState({
      sessionId: data.sessionId,
      workstationId: data.workstationId,
      garment: data.garment,
      ownerId: data.ownerId
    });
    
    session.focus = data.focus || session.focus;
    session.timeline = data.timeline || [];
    session.startedAt = data.startedAt || Date.now();
    session.lastActivity = data.lastActivity || Date.now();
    session.interactionCount = data.interactionCount || 0;
    
    // Restore working memory
    if (data.workingMemory) {
      for (const [key, value] of data.workingMemory) {
        session.workingMemory.set(key, value);
      }
    }
    
    return session;
  }
}

// ─── Context Engine Main Class ───────────────────────────────────────────────
/**
 * ContextEngine — Session Continuity System
 */
export class ContextEngine {
  static QUAD = 'CTXE';
  static VERSION = '0.17.0';
  static IP_VALUE = 5800000;
  static DOMAIN = 'Session Continuity';
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      maxSessions: config.maxSessions || 1000,
      maxContextSize: config.maxContextSize || 10000,
      autoSaveInterval: config.autoSaveInterval || 60000, // 1 minute
      ...config
    };
    
    // Active sessions
    this.sessions = new Map();  // sessionId -> SessionState
    
    // Session history
    this.sessionHistory = new Map();  // sessionId -> exported state
    
    // Cross-session context (shared insights)
    this.sharedContext = {
      patterns: new Map(),      // Recurring patterns
      insights: new Map(),      // Extracted insights
      preferences: new Map(),   // User/AI preferences
      shortcuts: new Map()      // Learned shortcuts
    };
    
    // Stats
    this.stats = {
      totalSessions: 0,
      activeSessions: 0,
      contextSwitches: 0,
      memorySaved: 0,
      memoryRestored: 0,
      lastHeartbeat: Date.now(),
      createdAt: Date.now()
    };
    
    // Auto-save timer
    if (this.config.autoSaveInterval && typeof setInterval !== 'undefined') {
      this._autoSaveTimer = setInterval(() => {
        this._autoSave();
      }, this.config.autoSaveInterval);
    }
  }
  
  // ─── Session Management ────────────────────────────────────────────────────
  
  /**
   * Start a new session at a workstation
   */
  startSession({ workstationId, garment, ownerId, previousSessionId }) {
    const sessionId = `sess-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    
    // Check for previous session to restore
    let session;
    if (previousSessionId && this.sessionHistory.has(previousSessionId)) {
      session = SessionState.import(this.sessionHistory.get(previousSessionId));
      session.sessionId = sessionId;  // New ID for new session
      this.stats.memoryRestored++;
    } else {
      session = new SessionState({
        sessionId,
        workstationId,
        garment,
        ownerId
      });
    }
    
    this.sessions.set(sessionId, session);
    this.stats.totalSessions++;
    this.stats.activeSessions = this.sessions.size;
    
    return {
      sessionId,
      workstationId,
      garment,
      restored: previousSessionId ? true : false,
      context: session.getContextSummary()
    };
  }
  
  /**
   * End a session (save for later continuation)
   */
  endSession(sessionId) {
    const session = this.sessions.get(sessionId);
    if (!session) {
      return { status: 'not_found' };
    }
    
    // Export and save to history
    const exported = session.export();
    this.sessionHistory.set(sessionId, exported);
    this.stats.memorySaved++;
    
    // Remove from active
    this.sessions.delete(sessionId);
    this.stats.activeSessions = this.sessions.size;
    
    return {
      status: 'ended',
      sessionId,
      duration: Date.now() - session.startedAt,
      interactionCount: session.interactionCount,
      saved: true
    };
  }
  
  /**
   * Get session by ID
   */
  getSession(sessionId) {
    return this.sessions.get(sessionId);
  }
  
  /**
   * Switch context between sessions
   */
  switchContext(fromSessionId, toSessionId) {
    const fromSession = this.sessions.get(fromSessionId);
    const toSession = this.sessions.get(toSessionId);
    
    if (!fromSession || !toSession) {
      return { status: 'error', message: 'Session not found' };
    }
    
    // Save from-session state
    this._autoSaveSession(fromSession);
    
    this.stats.contextSwitches++;
    
    return {
      status: 'switched',
      from: fromSession.getContextSummary(),
      to: toSession.getContextSummary()
    };
  }
  
  // ─── Context Operations ────────────────────────────────────────────────────
  
  /**
   * Record action in session
   */
  recordAction(sessionId, action, context = {}) {
    const session = this.sessions.get(sessionId);
    if (!session) return null;
    
    return session.recordAction(action, context);
  }
  
  /**
   * Remember something in session
   */
  remember(sessionId, key, value, contextType = 'session') {
    const session = this.sessions.get(sessionId);
    if (!session) return false;
    
    session.remember(key, value, contextType);
    return true;
  }
  
  /**
   * Recall from session
   */
  recall(sessionId, key) {
    const session = this.sessions.get(sessionId);
    if (!session) return null;
    
    return session.recall(key);
  }
  
  /**
   * Get relevant context for a query
   */
  getRelevantContext(sessionId, query, limit = 10) {
    const session = this.sessions.get(sessionId);
    if (!session) return [];
    
    // Get from all context windows
    const immediate = session.contextWindows.immediate.getRelevant(limit);
    const sessionCtx = session.contextWindows.session.getRelevant(limit);
    const project = session.contextWindows.project.getRelevant(limit);
    const domain = session.contextWindows.domain.getRelevant(limit);
    
    // Merge and rank
    const all = [
      ...immediate.map(i => ({ ...i, source: 'immediate', weight: 1.0 })),
      ...sessionCtx.map(i => ({ ...i, source: 'session', weight: 0.8 })),
      ...project.map(i => ({ ...i, source: 'project', weight: 0.6 })),
      ...domain.map(i => ({ ...i, source: 'domain', weight: 0.4 }))
    ];
    
    // Simple query matching (can be enhanced with embeddings)
    if (query) {
      const queryLower = query.toLowerCase();
      return all
        .filter(item => {
          const str = JSON.stringify(item).toLowerCase();
          return str.includes(queryLower);
        })
        .slice(0, limit);
    }
    
    return all.slice(0, limit);
  }
  
  // ─── Shared Context ────────────────────────────────────────────────────────
  
  /**
   * Learn a pattern across sessions
   */
  learnPattern(patternId, pattern) {
    this.sharedContext.patterns.set(patternId, {
      pattern,
      learnedAt: Date.now(),
      useCount: 0
    });
  }
  
  /**
   * Get learned pattern
   */
  getPattern(patternId) {
    const item = this.sharedContext.patterns.get(patternId);
    if (item) {
      item.useCount++;
      item.lastUsed = Date.now();
    }
    return item?.pattern;
  }
  
  /**
   * Add insight
   */
  addInsight(key, insight) {
    this.sharedContext.insights.set(key, {
      insight,
      addedAt: Date.now(),
      useCount: 0
    });
  }
  
  /**
   * Get insight
   */
  getInsight(key) {
    const item = this.sharedContext.insights.get(key);
    if (item) {
      item.useCount++;
      item.lastUsed = Date.now();
    }
    return item?.insight;
  }
  
  // ─── Persistence ───────────────────────────────────────────────────────────
  
  _autoSave() {
    for (const session of this.sessions.values()) {
      this._autoSaveSession(session);
    }
  }
  
  _autoSaveSession(session) {
    const exported = session.export();
    this.sessionHistory.set(session.sessionId, exported);
  }
  
  /**
   * Export engine state
   */
  export() {
    // Save all active sessions
    for (const session of this.sessions.values()) {
      this._autoSaveSession(session);
    }
    
    return {
      version: ContextEngine.VERSION,
      exportedAt: Date.now(),
      stats: this.stats,
      sessionHistory: Array.from(this.sessionHistory.entries()),
      sharedContext: {
        patterns: Array.from(this.sharedContext.patterns.entries()),
        insights: Array.from(this.sharedContext.insights.entries()),
        preferences: Array.from(this.sharedContext.preferences.entries()),
        shortcuts: Array.from(this.sharedContext.shortcuts.entries())
      }
    };
  }
  
  /**
   * Import engine state
   */
  import(data) {
    if (data.sessionHistory) {
      for (const [id, state] of data.sessionHistory) {
        this.sessionHistory.set(id, state);
      }
    }
    
    if (data.sharedContext) {
      if (data.sharedContext.patterns) {
        for (const [k, v] of data.sharedContext.patterns) {
          this.sharedContext.patterns.set(k, v);
        }
      }
      if (data.sharedContext.insights) {
        for (const [k, v] of data.sharedContext.insights) {
          this.sharedContext.insights.set(k, v);
        }
      }
    }
    
    if (data.stats) {
      this.stats = { ...this.stats, ...data.stats };
    }
  }
  
  // ─── Heartbeat ─────────────────────────────────────────────────────────────
  
  heartbeat() {
    const now = Date.now();
    const delta = now - this.stats.lastHeartbeat;
    this.stats.lastHeartbeat = now;
    
    return {
      quad: ContextEngine.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      stats: this.stats,
      activeSessions: Array.from(this.sessions.keys()),
      historySize: this.sessionHistory.size
    };
  }
  
  toJSON() {
    return {
      quad: ContextEngine.QUAD,
      version: ContextEngine.VERSION,
      ipValue: ContextEngine.IP_VALUE,
      domain: ContextEngine.DOMAIN,
      stats: this.stats,
      activeSessions: this.sessions.size,
      historySize: this.sessionHistory.size,
      sharedContext: {
        patterns: this.sharedContext.patterns.size,
        insights: this.sharedContext.insights.size,
        preferences: this.sharedContext.preferences.size,
        shortcuts: this.sharedContext.shortcuts.size
      }
    };
  }
  
  /**
   * Cleanup
   */
  destroy() {
    if (this._autoSaveTimer) {
      clearInterval(this._autoSaveTimer);
    }
  }
}

// ─── Export ──────────────────────────────────────────────────────────────────
export { CONTEXT_TYPES, ContextWindow, SessionState };
export default ContextEngine;
