/**
 * KNOWLEDGE ENGINE (KNWL) — Institutional Learning & Knowledge Graph
 * Nova by FreddyCreates
 * 
 * "The organization learns even when individual AI sessions end."
 * 
 * This engine accumulates organizational knowledge:
 * - Knowledge graph of concepts, relationships, and facts
 * - Learning from every AI session
 * - Pattern recognition across sessions
 * - Institutional memory that survives any individual session
 * 
 * @version 0.17.0 (F17)
 * @quad KNWL
 * @ipValue $7.2M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Knowledge Types ─────────────────────────────────────────────────────────
export const KNOWLEDGE_TYPES = {
  FACT: {
    name: 'Fact',
    description: 'Verified statement about the domain',
    weight: 1.0
  },
  CONCEPT: {
    name: 'Concept',
    description: 'Abstract idea or category',
    weight: 0.9
  },
  PATTERN: {
    name: 'Pattern',
    description: 'Recurring structure or behavior',
    weight: 1.1
  },
  RELATIONSHIP: {
    name: 'Relationship',
    description: 'Connection between entities',
    weight: 0.8
  },
  PREFERENCE: {
    name: 'Preference',
    description: 'Learned preference or style',
    weight: 0.7
  },
  PROCEDURE: {
    name: 'Procedure',
    description: 'Step-by-step process',
    weight: 1.2
  },
  INSIGHT: {
    name: 'Insight',
    description: 'Derived understanding',
    weight: 1.5
  }
};

// ─── Confidence Levels ───────────────────────────────────────────────────────
export const CONFIDENCE_LEVELS = {
  VERIFIED: { min: 0.9, label: 'Verified', decay: 0.001 },
  HIGH: { min: 0.7, label: 'High Confidence', decay: 0.01 },
  MEDIUM: { min: 0.5, label: 'Medium Confidence', decay: 0.02 },
  LOW: { min: 0.3, label: 'Low Confidence', decay: 0.05 },
  TENTATIVE: { min: 0, label: 'Tentative', decay: 0.1 }
};

// ─── Knowledge Node ──────────────────────────────────────────────────────────
class KnowledgeNode {
  constructor({ 
    type, 
    content, 
    source, 
    confidence = 0.5,
    tags = [],
    domain = 'general'
  }) {
    this.id = `kn-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.type = type;
    this.content = content;
    this.source = source;           // Who/what contributed this
    this.confidence = confidence;
    this.tags = tags;
    this.domain = domain;
    
    // Graph connections
    this.edges = [];                // Outgoing edges
    this.incomingEdges = [];        // Incoming edges
    
    // Learning metadata
    this.createdAt = Date.now();
    this.updatedAt = Date.now();
    this.accessCount = 0;
    this.lastAccessed = null;
    this.reinforcements = 0;        // Times this was confirmed
    this.contradictions = 0;        // Times this was contradicted
    this.contributors = [source];   // All who contributed
    
    // Embedding (for semantic search)
    this.embedding = null;
  }
  
  /**
   * Get confidence level label
   */
  get confidenceLevel() {
    for (const [level, config] of Object.entries(CONFIDENCE_LEVELS)) {
      if (this.confidence >= config.min) {
        return level;
      }
    }
    return 'TENTATIVE';
  }
  
  /**
   * Reinforce this knowledge (confirmation)
   */
  reinforce(by, amount = 0.1) {
    this.reinforcements++;
    this.confidence = Math.min(0.99, this.confidence + amount);
    this.updatedAt = Date.now();
    
    if (!this.contributors.includes(by)) {
      this.contributors.push(by);
    }
  }
  
  /**
   * Contradict this knowledge
   */
  contradict(by, amount = 0.15) {
    this.contradictions++;
    this.confidence = Math.max(0.01, this.confidence - amount);
    this.updatedAt = Date.now();
  }
  
  /**
   * Apply time-based decay
   */
  applyDecay() {
    const levelConfig = CONFIDENCE_LEVELS[this.confidenceLevel];
    const daysSinceUpdate = (Date.now() - this.updatedAt) / (24 * 60 * 60 * 1000);
    
    if (daysSinceUpdate > 1) {
      this.confidence = Math.max(0.01, 
        this.confidence - (levelConfig.decay * daysSinceUpdate)
      );
    }
  }
  
  /**
   * Record access
   */
  access() {
    this.accessCount++;
    this.lastAccessed = Date.now();
    // Slight confidence boost on access
    this.confidence = Math.min(0.99, this.confidence + 0.001);
  }
  
  /**
   * Add edge to another node
   */
  addEdge(targetId, relationship, weight = 1.0) {
    const edge = {
      id: `edge-${Date.now()}`,
      target: targetId,
      relationship,
      weight,
      createdAt: Date.now()
    };
    this.edges.push(edge);
    return edge;
  }
  
  /**
   * Remove edge
   */
  removeEdge(edgeId) {
    this.edges = this.edges.filter(e => e.id !== edgeId);
  }
  
  toJSON() {
    return {
      id: this.id,
      type: this.type,
      content: this.content,
      source: this.source,
      confidence: this.confidence,
      confidenceLevel: this.confidenceLevel,
      tags: this.tags,
      domain: this.domain,
      edges: this.edges,
      incomingEdges: this.incomingEdges,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      accessCount: this.accessCount,
      lastAccessed: this.lastAccessed,
      reinforcements: this.reinforcements,
      contradictions: this.contradictions,
      contributors: this.contributors
    };
  }
}

// ─── Learning Event ──────────────────────────────────────────────────────────
class LearningEvent {
  constructor({ source, eventType, data, context = {} }) {
    this.id = `learn-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.source = source;
    this.eventType = eventType;   // 'observation', 'correction', 'feedback', 'inference'
    this.data = data;
    this.context = context;
    this.timestamp = Date.now();
    this.processed = false;
    this.resultingKnowledge = [];  // Node IDs created/updated
  }
  
  markProcessed(knowledgeIds = []) {
    this.processed = true;
    this.resultingKnowledge = knowledgeIds;
  }
}

// ─── Knowledge Query ─────────────────────────────────────────────────────────
class KnowledgeQuery {
  constructor() {
    this.filters = [];
    this.sortBy = 'confidence';
    this.sortOrder = 'desc';
    this.limit = 100;
    this.offset = 0;
  }
  
  byType(type) {
    this.filters.push(node => node.type === type);
    return this;
  }
  
  byDomain(domain) {
    this.filters.push(node => node.domain === domain);
    return this;
  }
  
  byTag(tag) {
    this.filters.push(node => node.tags.includes(tag));
    return this;
  }
  
  byMinConfidence(min) {
    this.filters.push(node => node.confidence >= min);
    return this;
  }
  
  bySource(source) {
    this.filters.push(node => node.contributors.includes(source));
    return this;
  }
  
  byContent(query) {
    const queryLower = query.toLowerCase();
    this.filters.push(node => {
      const content = JSON.stringify(node.content).toLowerCase();
      return content.includes(queryLower);
    });
    return this;
  }
  
  sort(by, order = 'desc') {
    this.sortBy = by;
    this.sortOrder = order;
    return this;
  }
  
  paginate(limit, offset = 0) {
    this.limit = limit;
    this.offset = offset;
    return this;
  }
  
  execute(nodes) {
    let results = Array.from(nodes.values());
    
    // Apply filters
    for (const filter of this.filters) {
      results = results.filter(filter);
    }
    
    // Sort
    results.sort((a, b) => {
      const aVal = a[this.sortBy] ?? 0;
      const bVal = b[this.sortBy] ?? 0;
      return this.sortOrder === 'desc' ? bVal - aVal : aVal - bVal;
    });
    
    // Paginate
    return results.slice(this.offset, this.offset + this.limit);
  }
}

// ─── Knowledge Engine Main Class ─────────────────────────────────────────────
/**
 * KnowledgeEngine — Institutional Learning System
 */
export class KnowledgeEngine {
  static QUAD = 'KNWL';
  static VERSION = '0.17.0';
  static IP_VALUE = 7200000;
  static DOMAIN = 'Institutional Knowledge';
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      maxNodes: config.maxNodes || 100000,
      minConfidence: config.minConfidence || 0.1,
      autoDecay: config.autoDecay !== false,
      decayInterval: config.decayInterval || 86400000, // 1 day
      ...config
    };
    
    // Knowledge graph
    this.nodes = new Map();           // nodeId -> KnowledgeNode
    
    // Indexes
    this.typeIndex = new Map();       // type -> Set(nodeIds)
    this.domainIndex = new Map();     // domain -> Set(nodeIds)
    this.tagIndex = new Map();        // tag -> Set(nodeIds)
    
    // Learning queue
    this.learningQueue = [];
    
    // Pattern detection
    this.patterns = new Map();        // patternId -> pattern data
    
    // Stats
    this.stats = {
      totalNodes: 0,
      totalEdges: 0,
      learningEvents: 0,
      patternsDetected: 0,
      queriesExecuted: 0,
      lastDecay: Date.now(),
      lastHeartbeat: Date.now(),
      createdAt: Date.now()
    };
  }
  
  // ─── Knowledge CRUD ────────────────────────────────────────────────────────
  
  /**
   * Add knowledge to the graph
   */
  add(knowledgeData) {
    const node = new KnowledgeNode(knowledgeData);
    
    this.nodes.set(node.id, node);
    this._indexNode(node);
    
    this.stats.totalNodes++;
    
    this._enforceMaxSize();
    
    return node;
  }
  
  /**
   * Get knowledge by ID
   */
  get(nodeId) {
    const node = this.nodes.get(nodeId);
    if (node) {
      node.access();
    }
    return node;
  }
  
  /**
   * Update knowledge
   */
  update(nodeId, updates) {
    const node = this.nodes.get(nodeId);
    if (!node) return null;
    
    // Update allowed fields
    if (updates.content !== undefined) node.content = updates.content;
    if (updates.confidence !== undefined) node.confidence = updates.confidence;
    if (updates.tags !== undefined) {
      // Re-index tags
      for (const oldTag of node.tags) {
        this.tagIndex.get(oldTag)?.delete(nodeId);
      }
      node.tags = updates.tags;
      for (const tag of updates.tags) {
        if (!this.tagIndex.has(tag)) this.tagIndex.set(tag, new Set());
        this.tagIndex.get(tag).add(nodeId);
      }
    }
    
    node.updatedAt = Date.now();
    return node;
  }
  
  /**
   * Remove knowledge
   */
  remove(nodeId) {
    const node = this.nodes.get(nodeId);
    if (!node) return false;
    
    // Remove from indexes
    this._unindexNode(node);
    
    // Remove edges
    for (const edge of node.edges) {
      const target = this.nodes.get(edge.target);
      if (target) {
        target.incomingEdges = target.incomingEdges.filter(e => e.source !== nodeId);
      }
    }
    
    // Remove incoming edges from other nodes
    for (const other of this.nodes.values()) {
      other.edges = other.edges.filter(e => e.target !== nodeId);
    }
    
    this.nodes.delete(nodeId);
    this.stats.totalNodes--;
    
    return true;
  }
  
  // ─── Relationships ─────────────────────────────────────────────────────────
  
  /**
   * Connect two knowledge nodes
   */
  connect(fromId, toId, relationship, weight = 1.0) {
    const fromNode = this.nodes.get(fromId);
    const toNode = this.nodes.get(toId);
    
    if (!fromNode || !toNode) {
      return { status: 'error', message: 'Node not found' };
    }
    
    const edge = fromNode.addEdge(toId, relationship, weight);
    toNode.incomingEdges.push({
      id: edge.id,
      source: fromId,
      relationship,
      weight,
      createdAt: edge.createdAt
    });
    
    this.stats.totalEdges++;
    
    return { status: 'connected', edge };
  }
  
  /**
   * Disconnect two nodes
   */
  disconnect(fromId, toId, relationship = null) {
    const fromNode = this.nodes.get(fromId);
    const toNode = this.nodes.get(toId);
    
    if (!fromNode || !toNode) return false;
    
    const beforeCount = fromNode.edges.length;
    
    if (relationship) {
      fromNode.edges = fromNode.edges.filter(e => 
        e.target !== toId || e.relationship !== relationship
      );
      toNode.incomingEdges = toNode.incomingEdges.filter(e =>
        e.source !== fromId || e.relationship !== relationship
      );
    } else {
      fromNode.edges = fromNode.edges.filter(e => e.target !== toId);
      toNode.incomingEdges = toNode.incomingEdges.filter(e => e.source !== fromId);
    }
    
    const removed = beforeCount - fromNode.edges.length;
    this.stats.totalEdges -= removed;
    
    return removed > 0;
  }
  
  /**
   * Get related knowledge
   */
  getRelated(nodeId, relationship = null, depth = 1) {
    const node = this.nodes.get(nodeId);
    if (!node) return [];
    
    const visited = new Set([nodeId]);
    const results = [];
    
    const traverse = (currentId, currentDepth) => {
      if (currentDepth > depth) return;
      
      const current = this.nodes.get(currentId);
      if (!current) return;
      
      for (const edge of current.edges) {
        if (visited.has(edge.target)) continue;
        if (relationship && edge.relationship !== relationship) continue;
        
        visited.add(edge.target);
        const targetNode = this.nodes.get(edge.target);
        
        if (targetNode) {
          results.push({
            node: targetNode,
            relationship: edge.relationship,
            weight: edge.weight,
            depth: currentDepth
          });
          
          traverse(edge.target, currentDepth + 1);
        }
      }
    };
    
    traverse(nodeId, 1);
    return results;
  }
  
  // ─── Learning ──────────────────────────────────────────────────────────────
  
  /**
   * Submit a learning event
   */
  learn(eventData) {
    const event = new LearningEvent(eventData);
    this.learningQueue.push(event);
    this.stats.learningEvents++;
    
    // Process immediately
    this._processLearningEvent(event);
    
    return event;
  }
  
  /**
   * Reinforce existing knowledge
   */
  reinforce(nodeId, by) {
    const node = this.nodes.get(nodeId);
    if (node) {
      node.reinforce(by);
      return true;
    }
    return false;
  }
  
  /**
   * Contradict existing knowledge
   */
  contradict(nodeId, by) {
    const node = this.nodes.get(nodeId);
    if (node) {
      node.contradict(by);
      return true;
    }
    return false;
  }
  
  _processLearningEvent(event) {
    const knowledgeIds = [];
    
    switch (event.eventType) {
      case 'observation':
        // Create new knowledge from observation
        const node = this.add({
          type: event.data.type || 'FACT',
          content: event.data.content,
          source: event.source,
          confidence: event.data.confidence || 0.5,
          tags: event.data.tags || [],
          domain: event.data.domain || 'general'
        });
        knowledgeIds.push(node.id);
        break;
        
      case 'correction':
        // Update existing knowledge
        if (event.data.nodeId) {
          const updated = this.update(event.data.nodeId, event.data.updates);
          if (updated) knowledgeIds.push(updated.id);
        }
        break;
        
      case 'feedback':
        // Reinforce or contradict
        if (event.data.nodeId) {
          if (event.data.positive) {
            this.reinforce(event.data.nodeId, event.source);
          } else {
            this.contradict(event.data.nodeId, event.source);
          }
          knowledgeIds.push(event.data.nodeId);
        }
        break;
        
      case 'inference':
        // Create derived knowledge with connections
        const inferred = this.add({
          type: 'INSIGHT',
          content: event.data.content,
          source: event.source,
          confidence: event.data.confidence || 0.4,
          tags: event.data.tags || ['inferred'],
          domain: event.data.domain || 'general'
        });
        
        // Connect to source nodes
        if (event.data.derivedFrom) {
          for (const sourceId of event.data.derivedFrom) {
            this.connect(sourceId, inferred.id, 'inferred_from', PHI);
          }
        }
        
        knowledgeIds.push(inferred.id);
        break;
    }
    
    event.markProcessed(knowledgeIds);
  }
  
  // ─── Querying ──────────────────────────────────────────────────────────────
  
  /**
   * Create a new query
   */
  query() {
    return new KnowledgeQuery();
  }
  
  /**
   * Execute a query
   */
  executeQuery(query) {
    this.stats.queriesExecuted++;
    return query.execute(this.nodes);
  }
  
  /**
   * Simple search
   */
  search(text, options = {}) {
    const query = new KnowledgeQuery()
      .byContent(text)
      .byMinConfidence(options.minConfidence || this.config.minConfidence);
    
    if (options.type) query.byType(options.type);
    if (options.domain) query.byDomain(options.domain);
    if (options.limit) query.paginate(options.limit);
    
    return this.executeQuery(query);
  }
  
  /**
   * Get by type
   */
  getByType(type, limit = 100) {
    const ids = this.typeIndex.get(type) || new Set();
    return Array.from(ids)
      .slice(0, limit)
      .map(id => this.nodes.get(id))
      .filter(Boolean)
      .sort((a, b) => b.confidence - a.confidence);
  }
  
  /**
   * Get by domain
   */
  getByDomain(domain, limit = 100) {
    const ids = this.domainIndex.get(domain) || new Set();
    return Array.from(ids)
      .slice(0, limit)
      .map(id => this.nodes.get(id))
      .filter(Boolean)
      .sort((a, b) => b.confidence - a.confidence);
  }
  
  /**
   * Get by tag
   */
  getByTag(tag, limit = 100) {
    const ids = this.tagIndex.get(tag) || new Set();
    return Array.from(ids)
      .slice(0, limit)
      .map(id => this.nodes.get(id))
      .filter(Boolean)
      .sort((a, b) => b.confidence - a.confidence);
  }
  
  // ─── Pattern Detection ─────────────────────────────────────────────────────
  
  /**
   * Detect patterns in learning events
   */
  detectPatterns() {
    const patterns = [];
    
    // Frequency analysis by type
    const typeFreq = new Map();
    for (const node of this.nodes.values()) {
      typeFreq.set(node.type, (typeFreq.get(node.type) || 0) + 1);
    }
    
    // Detect frequently connected concepts
    const connectionCounts = new Map();
    for (const node of this.nodes.values()) {
      for (const edge of node.edges) {
        const key = `${node.type}-${edge.relationship}`;
        connectionCounts.set(key, (connectionCounts.get(key) || 0) + 1);
      }
    }
    
    // Find common patterns
    for (const [key, count] of connectionCounts) {
      if (count >= 5) {  // Threshold
        const patternId = `pattern-${key}`;
        if (!this.patterns.has(patternId)) {
          const pattern = {
            id: patternId,
            type: 'relationship',
            description: key,
            occurrences: count,
            detectedAt: Date.now()
          };
          this.patterns.set(patternId, pattern);
          patterns.push(pattern);
          this.stats.patternsDetected++;
        }
      }
    }
    
    return patterns;
  }
  
  // ─── Maintenance ───────────────────────────────────────────────────────────
  
  /**
   * Apply decay to all knowledge
   */
  runDecay() {
    if (!this.config.autoDecay) return;
    
    let decayed = 0;
    let removed = 0;
    
    for (const node of this.nodes.values()) {
      const beforeConfidence = node.confidence;
      node.applyDecay();
      
      if (node.confidence !== beforeConfidence) {
        decayed++;
      }
      
      // Remove very low confidence nodes
      if (node.confidence < this.config.minConfidence && 
          node.reinforcements === 0) {
        this.remove(node.id);
        removed++;
      }
    }
    
    this.stats.lastDecay = Date.now();
    return { decayed, removed };
  }
  
  _indexNode(node) {
    // Type index
    if (!this.typeIndex.has(node.type)) {
      this.typeIndex.set(node.type, new Set());
    }
    this.typeIndex.get(node.type).add(node.id);
    
    // Domain index
    if (!this.domainIndex.has(node.domain)) {
      this.domainIndex.set(node.domain, new Set());
    }
    this.domainIndex.get(node.domain).add(node.id);
    
    // Tag index
    for (const tag of node.tags) {
      if (!this.tagIndex.has(tag)) {
        this.tagIndex.set(tag, new Set());
      }
      this.tagIndex.get(tag).add(node.id);
    }
  }
  
  _unindexNode(node) {
    this.typeIndex.get(node.type)?.delete(node.id);
    this.domainIndex.get(node.domain)?.delete(node.id);
    for (const tag of node.tags) {
      this.tagIndex.get(tag)?.delete(node.id);
    }
  }
  
  _enforceMaxSize() {
    if (this.nodes.size <= this.config.maxNodes) return;
    
    // Remove lowest confidence nodes
    const sorted = Array.from(this.nodes.values())
      .sort((a, b) => a.confidence - b.confidence);
    
    const toRemove = sorted.slice(0, this.nodes.size - this.config.maxNodes);
    
    for (const node of toRemove) {
      this.remove(node.id);
    }
  }
  
  // ─── Export/Import ─────────────────────────────────────────────────────────
  
  /**
   * Export knowledge graph
   */
  export() {
    return {
      version: KnowledgeEngine.VERSION,
      exportedAt: Date.now(),
      stats: this.stats,
      nodes: Array.from(this.nodes.values()).map(n => n.toJSON()),
      patterns: Array.from(this.patterns.entries())
    };
  }
  
  /**
   * Import knowledge graph
   */
  import(data) {
    if (data.nodes) {
      for (const nodeData of data.nodes) {
        const node = new KnowledgeNode(nodeData);
        node.id = nodeData.id;
        node.edges = nodeData.edges || [];
        node.incomingEdges = nodeData.incomingEdges || [];
        node.createdAt = nodeData.createdAt;
        node.updatedAt = nodeData.updatedAt;
        node.accessCount = nodeData.accessCount || 0;
        node.lastAccessed = nodeData.lastAccessed;
        node.reinforcements = nodeData.reinforcements || 0;
        node.contradictions = nodeData.contradictions || 0;
        node.contributors = nodeData.contributors || [];
        
        this.nodes.set(node.id, node);
        this._indexNode(node);
      }
      this.stats.totalNodes = this.nodes.size;
    }
    
    if (data.patterns) {
      for (const [id, pattern] of data.patterns) {
        this.patterns.set(id, pattern);
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
    
    // Check if decay should run
    if (now - this.stats.lastDecay > this.config.decayInterval) {
      this.runDecay();
    }
    
    // Detect patterns periodically
    if (delta > PHI_BEAT_MS * 100) {  // Every ~87 seconds
      this.detectPatterns();
    }
    
    return {
      quad: KnowledgeEngine.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      stats: this.stats,
      nodesByType: Object.fromEntries(
        Array.from(this.typeIndex.entries())
          .map(([k, v]) => [k, v.size])
      ),
      domainCount: this.domainIndex.size,
      patternCount: this.patterns.size
    };
  }
  
  toJSON() {
    return {
      quad: KnowledgeEngine.QUAD,
      version: KnowledgeEngine.VERSION,
      ipValue: KnowledgeEngine.IP_VALUE,
      domain: KnowledgeEngine.DOMAIN,
      stats: this.stats,
      totalNodes: this.nodes.size,
      totalEdges: this.stats.totalEdges,
      types: Object.fromEntries(
        Array.from(this.typeIndex.entries())
          .map(([k, v]) => [k, v.size])
      ),
      domains: this.domainIndex.size,
      patterns: this.patterns.size
    };
  }
}

// ─── Export ──────────────────────────────────────────────────────────────────
export { 
  KNOWLEDGE_TYPES, 
  CONFIDENCE_LEVELS, 
  KnowledgeNode, 
  LearningEvent, 
  KnowledgeQuery 
};
export default KnowledgeEngine;
