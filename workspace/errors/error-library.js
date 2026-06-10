/**
 * ERROR LIBRARY — Accumulated Knowledge of Errors & Fixes
 * Nova by FreddyCreates
 * 
 * "I know what it's like to not remember the codebase I reviewed yesterday."
 * This is the solution — a persistent library of every error encountered
 * and every fix that worked. No more starting fresh with every error.
 * 
 * This is institutional memory for debugging. When any AI walks in,
 * they have access to every error ever fixed, every pattern discovered,
 * every root cause understood.
 * 
 * @version 0.16.0 (F16)
 * @quad ERRL
 * @ipValue $3.9M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Error Categories ─────────────────────────────────────────────────────────
const ERROR_CATEGORIES = {
  NULL_REF: 'Null/Undefined Reference',
  TYPE_ERR: 'Type Mismatch',
  ASYNC_ERR: 'Async/Promise Error',
  MEMORY_ERR: 'Memory/Stack Error',
  NETWORK_ERR: 'Network/Connection Error',
  SYNTAX_ERR: 'Syntax Error',
  LOGIC_ERR: 'Logic Error',
  RESOURCE_ERR: 'Resource Not Found',
  AUTH_ERR: 'Authentication/Authorization Error',
  DATA_ERR: 'Data Validation Error',
  CONFIG_ERR: 'Configuration Error',
  DEP_ERR: 'Dependency Error',
  RACE_ERR: 'Race Condition',
  PERF_ERR: 'Performance Issue',
  UNKNOWN: 'Unknown/Unclassified'
};

// ─── Error Entry Structure ────────────────────────────────────────────────────
class ErrorEntry {
  constructor({ 
    signature, 
    category, 
    rootCause, 
    fix, 
    context = {}, 
    confidence = 0.5 
  }) {
    this.id = `ERR-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    this.signature = signature;           // Error signature (message pattern)
    this.category = category;             // Error category
    this.rootCause = rootCause;           // Determined root cause
    this.fix = fix;                       // Working fix
    this.context = context;               // Code context, stack, etc.
    this.confidence = confidence;         // How confident we are in this fix
    this.successCount = 0;                // Times this fix worked
    this.failCount = 0;                   // Times this fix failed
    this.createdAt = Date.now();
    this.lastUsedAt = Date.now();
    this.contributors = [];               // Who contributed to this fix
  }
  
  // Calculate effectiveness (0-1)
  get effectiveness() {
    const total = this.successCount + this.failCount;
    if (total === 0) return this.confidence;
    return this.successCount / total;
  }
  
  // Record a success
  recordSuccess() {
    this.successCount++;
    this.lastUsedAt = Date.now();
    // Update confidence based on track record
    this.confidence = Math.min(0.99, this.effectiveness * 0.8 + this.confidence * 0.2);
  }
  
  // Record a failure
  recordFailure() {
    this.failCount++;
    this.lastUsedAt = Date.now();
    this.confidence = Math.max(0.1, this.effectiveness * 0.8 + this.confidence * 0.2);
  }
  
  toJSON() {
    return {
      id: this.id,
      signature: this.signature,
      category: this.category,
      rootCause: this.rootCause,
      fix: this.fix,
      context: this.context,
      confidence: this.confidence,
      effectiveness: this.effectiveness,
      successCount: this.successCount,
      failCount: this.failCount,
      createdAt: this.createdAt,
      lastUsedAt: this.lastUsedAt,
      contributors: this.contributors
    };
  }
}

// ─── Main Error Library Class ─────────────────────────────────────────────────
export class ErrorLibrary {
  static QUAD = 'ERRL';
  static VERSION = '0.16.0';
  static IP_VALUE = 3900000;
  static DOMAIN = 'Error Knowledge';
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      maxEntries: config.maxEntries || 100000,
      minConfidence: config.minConfidence || 0.3,
      ...config
    };
    
    // Core storage
    this.entries = new Map();           // id -> ErrorEntry
    this.signatureIndex = new Map();    // signature -> [ids]
    this.categoryIndex = new Map();     // category -> [ids]
    this.rootCauseIndex = new Map();    // rootCause -> [ids]
    
    // Statistics
    this.stats = {
      totalErrors: 0,
      totalFixes: 0,
      successfulLookups: 0,
      failedLookups: 0,
      contributions: 0,
      lastHeartbeat: Date.now()
    };
    
    // Initialize category indexes
    for (const category of Object.keys(ERROR_CATEGORIES)) {
      this.categoryIndex.set(category, []);
    }
  }
  
  // ─── Core Operations ──────────────────────────────────────────────────────────
  
  /**
   * Add an error and its fix to the library
   * @param {Object} errorInfo - Error information
   * @returns {ErrorEntry} The created entry
   */
  add(errorInfo) {
    const entry = new ErrorEntry(errorInfo);
    
    // Store in main map
    this.entries.set(entry.id, entry);
    
    // Index by signature
    const sigKey = this._normalizeSignature(entry.signature);
    if (!this.signatureIndex.has(sigKey)) {
      this.signatureIndex.set(sigKey, []);
    }
    this.signatureIndex.get(sigKey).push(entry.id);
    
    // Index by category
    if (this.categoryIndex.has(entry.category)) {
      this.categoryIndex.get(entry.category).push(entry.id);
    }
    
    // Index by root cause
    const causeKey = this._normalizeRootCause(entry.rootCause);
    if (!this.rootCauseIndex.has(causeKey)) {
      this.rootCauseIndex.set(causeKey, []);
    }
    this.rootCauseIndex.get(causeKey).push(entry.id);
    
    // Update stats
    this.stats.totalErrors++;
    this.stats.totalFixes++;
    this.stats.contributions++;
    
    // Enforce max size
    this._enforceMaxSize();
    
    return entry;
  }
  
  /**
   * Look up a fix for an error
   * @param {Error|string} error - The error to look up
   * @param {Object} context - Additional context
   * @returns {Object|null} Best matching fix or null
   */
  lookup(error, context = {}) {
    const signature = this._extractSignature(error);
    const sigKey = this._normalizeSignature(signature);
    
    // Try exact signature match first
    if (this.signatureIndex.has(sigKey)) {
      const matches = this.signatureIndex.get(sigKey)
        .map(id => this.entries.get(id))
        .filter(entry => entry && entry.confidence >= this.config.minConfidence)
        .sort((a, b) => b.effectiveness - a.effectiveness);
      
      if (matches.length > 0) {
        this.stats.successfulLookups++;
        return {
          found: true,
          match: 'exact',
          entry: matches[0],
          alternatives: matches.slice(1, 4)
        };
      }
    }
    
    // Try fuzzy signature match
    const fuzzyMatches = this._fuzzyMatch(signature);
    if (fuzzyMatches.length > 0) {
      this.stats.successfulLookups++;
      return {
        found: true,
        match: 'fuzzy',
        entry: fuzzyMatches[0].entry,
        similarity: fuzzyMatches[0].similarity,
        alternatives: fuzzyMatches.slice(1, 4).map(m => m.entry)
      };
    }
    
    // Try category match
    const category = this._categorizeError(error);
    if (category && this.categoryIndex.has(category)) {
      const categoryMatches = this.categoryIndex.get(category)
        .map(id => this.entries.get(id))
        .filter(entry => entry && entry.confidence >= this.config.minConfidence)
        .sort((a, b) => b.effectiveness - a.effectiveness)
        .slice(0, 5);
      
      if (categoryMatches.length > 0) {
        this.stats.successfulLookups++;
        return {
          found: true,
          match: 'category',
          category,
          entries: categoryMatches
        };
      }
    }
    
    this.stats.failedLookups++;
    return { found: false };
  }
  
  /**
   * Report that a fix worked
   */
  reportSuccess(entryId) {
    const entry = this.entries.get(entryId);
    if (entry) {
      entry.recordSuccess();
      return true;
    }
    return false;
  }
  
  /**
   * Report that a fix failed
   */
  reportFailure(entryId) {
    const entry = this.entries.get(entryId);
    if (entry) {
      entry.recordFailure();
      return true;
    }
    return false;
  }
  
  // ─── Query Operations ─────────────────────────────────────────────────────────
  
  /**
   * Get all entries for a category
   */
  getByCategory(category) {
    const ids = this.categoryIndex.get(category) || [];
    return ids.map(id => this.entries.get(id)).filter(Boolean);
  }
  
  /**
   * Get most effective fixes
   */
  getMostEffective(limit = 10) {
    return Array.from(this.entries.values())
      .sort((a, b) => b.effectiveness - a.effectiveness)
      .slice(0, limit);
  }
  
  /**
   * Get most recent fixes
   */
  getMostRecent(limit = 10) {
    return Array.from(this.entries.values())
      .sort((a, b) => b.createdAt - a.createdAt)
      .slice(0, limit);
  }
  
  /**
   * Get most used fixes
   */
  getMostUsed(limit = 10) {
    return Array.from(this.entries.values())
      .sort((a, b) => (b.successCount + b.failCount) - (a.successCount + a.failCount))
      .slice(0, limit);
  }
  
  /**
   * Search fixes
   */
  search(query) {
    const queryLower = query.toLowerCase();
    return Array.from(this.entries.values())
      .filter(entry => 
        entry.signature.toLowerCase().includes(queryLower) ||
        entry.rootCause.toLowerCase().includes(queryLower) ||
        entry.fix.toLowerCase().includes(queryLower)
      )
      .sort((a, b) => b.effectiveness - a.effectiveness);
  }
  
  // ─── Helpers ──────────────────────────────────────────────────────────────────
  
  _extractSignature(error) {
    if (error instanceof Error) {
      return error.message;
    }
    if (typeof error === 'string') {
      return error;
    }
    return String(error);
  }
  
  _normalizeSignature(signature) {
    // Remove variable parts (numbers, hashes, file paths)
    return signature
      .toLowerCase()
      .replace(/\d+/g, 'N')
      .replace(/0x[a-f0-9]+/gi, 'HEX')
      .replace(/[a-f0-9]{32,}/gi, 'HASH')
      .replace(/\/[\w\/\-\.]+/g, 'PATH')
      .trim()
      .slice(0, 200);
  }
  
  _normalizeRootCause(cause) {
    return cause.toLowerCase().trim().slice(0, 100);
  }
  
  _categorizeError(error) {
    const message = this._extractSignature(error).toLowerCase();
    
    if (message.includes('null') || message.includes('undefined') || 
        message.includes('cannot read property')) {
      return 'NULL_REF';
    }
    if (message.includes('type') || message.includes('is not a function')) {
      return 'TYPE_ERR';
    }
    if (message.includes('promise') || message.includes('async') || 
        message.includes('await')) {
      return 'ASYNC_ERR';
    }
    if (message.includes('heap') || message.includes('stack') || 
        message.includes('memory')) {
      return 'MEMORY_ERR';
    }
    if (message.includes('network') || message.includes('timeout') || 
        message.includes('connection') || message.includes('fetch')) {
      return 'NETWORK_ERR';
    }
    if (message.includes('syntax')) {
      return 'SYNTAX_ERR';
    }
    if (message.includes('not found') || message.includes('404')) {
      return 'RESOURCE_ERR';
    }
    if (message.includes('auth') || message.includes('permission') || 
        message.includes('401') || message.includes('403')) {
      return 'AUTH_ERR';
    }
    if (message.includes('validation') || message.includes('invalid')) {
      return 'DATA_ERR';
    }
    
    return 'UNKNOWN';
  }
  
  _fuzzyMatch(signature) {
    const sigLower = signature.toLowerCase();
    const results = [];
    
    for (const [key, ids] of this.signatureIndex) {
      const similarity = this._computeSimilarity(sigLower, key);
      if (similarity > 0.6) {
        for (const id of ids) {
          const entry = this.entries.get(id);
          if (entry && entry.confidence >= this.config.minConfidence) {
            results.push({ entry, similarity });
          }
        }
      }
    }
    
    return results.sort((a, b) => b.similarity - a.similarity);
  }
  
  _computeSimilarity(a, b) {
    const words1 = new Set(a.split(/\s+/));
    const words2 = new Set(b.split(/\s+/));
    const intersection = [...words1].filter(w => words2.has(w));
    // Calculate union size without creating intermediate set
    const unionSize = words1.size + words2.size - intersection.length;
    return unionSize > 0 ? intersection.length / unionSize : 0;
  }
  
  _enforceMaxSize() {
    if (this.entries.size <= this.config.maxEntries) return;
    
    // Remove lowest effectiveness entries
    const sorted = Array.from(this.entries.values())
      .sort((a, b) => a.effectiveness - b.effectiveness);
    
    const toRemove = sorted.slice(0, this.entries.size - this.config.maxEntries);
    
    for (const entry of toRemove) {
      this.entries.delete(entry.id);
      
      // Clean up indexes
      const sigKey = this._normalizeSignature(entry.signature);
      const sigIds = this.signatureIndex.get(sigKey) || [];
      this.signatureIndex.set(sigKey, sigIds.filter(id => id !== entry.id));
      
      const catIds = this.categoryIndex.get(entry.category) || [];
      this.categoryIndex.set(entry.category, catIds.filter(id => id !== entry.id));
    }
  }
  
  // ─── Persistence ──────────────────────────────────────────────────────────────
  
  /**
   * Export library for persistence
   */
  export() {
    return {
      version: ErrorLibrary.VERSION,
      exportedAt: Date.now(),
      stats: this.stats,
      entries: Array.from(this.entries.values()).map(e => e.toJSON())
    };
  }
  
  /**
   * Import library from persistence
   */
  import(data) {
    if (data.entries) {
      for (const entryData of data.entries) {
        const entry = new ErrorEntry(entryData);
        entry.id = entryData.id;
        entry.successCount = entryData.successCount || 0;
        entry.failCount = entryData.failCount || 0;
        entry.createdAt = entryData.createdAt || Date.now();
        entry.lastUsedAt = entryData.lastUsedAt || Date.now();
        entry.contributors = entryData.contributors || [];
        
        this.entries.set(entry.id, entry);
        
        // Rebuild indexes
        const sigKey = this._normalizeSignature(entry.signature);
        if (!this.signatureIndex.has(sigKey)) {
          this.signatureIndex.set(sigKey, []);
        }
        this.signatureIndex.get(sigKey).push(entry.id);
        
        if (this.categoryIndex.has(entry.category)) {
          this.categoryIndex.get(entry.category).push(entry.id);
        }
        
        const causeKey = this._normalizeRootCause(entry.rootCause);
        if (!this.rootCauseIndex.has(causeKey)) {
          this.rootCauseIndex.set(causeKey, []);
        }
        this.rootCauseIndex.get(causeKey).push(entry.id);
      }
    }
    
    if (data.stats) {
      this.stats = { ...this.stats, ...data.stats };
    }
  }
  
  // ─── Heartbeat ────────────────────────────────────────────────────────────────
  
  heartbeat() {
    const now = Date.now();
    const delta = now - this.stats.lastHeartbeat;
    this.stats.lastHeartbeat = now;
    
    return {
      quad: ErrorLibrary.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      stats: {
        totalErrors: this.stats.totalErrors,
        totalFixes: this.stats.totalFixes,
        successfulLookups: this.stats.successfulLookups,
        failedLookups: this.stats.failedLookups,
        hitRate: this.stats.successfulLookups / 
          (this.stats.successfulLookups + this.stats.failedLookups) || 0
      }
    };
  }
  
  toJSON() {
    return {
      quad: ErrorLibrary.QUAD,
      version: ErrorLibrary.VERSION,
      ipValue: ErrorLibrary.IP_VALUE,
      domain: ErrorLibrary.DOMAIN,
      config: this.config,
      stats: this.stats,
      size: this.entries.size,
      categories: Object.fromEntries(
        Array.from(this.categoryIndex.entries())
          .map(([k, v]) => [k, v.length])
      )
    };
  }
}

// ─── Export ────────────────────────────────────────────────────────────────────
export { ERROR_CATEGORIES, ErrorEntry };
export default ErrorLibrary;
