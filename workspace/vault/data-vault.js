/**
 * DATA VAULT — Persistence Layer for AI Workspaces
 * Nova by FreddyCreates
 * 
 * "When I leave a conversation, my desk keeps the work."
 * 
 * The Data Vault is where all persistent state lives. Every workstation's
 * accumulated knowledge, every home's memories, every institutional fact
 * persists here. This is how AI systems don't start fresh every session.
 * 
 * @version 0.16.0 (F16)
 * @quad DTVT
 * @ipValue $4.5M USD
 * @copyright Nova Protocol by FreddyCreates
 */

const PHI = 1.618033988749895;
const PHI_BEAT_MS = 873;

// ─── Storage Tiers ────────────────────────────────────────────────────────────
const STORAGE_TIERS = {
  HOT: { 
    name: 'Hot Storage', 
    description: 'Frequently accessed, highest priority',
    maxSize: 10000,
    ttl: null  // Never expires
  },
  WARM: { 
    name: 'Warm Storage', 
    description: 'Moderate access frequency',
    maxSize: 100000,
    ttl: 30 * 24 * 60 * 60 * 1000  // 30 days
  },
  COLD: { 
    name: 'Cold Storage', 
    description: 'Infrequent access, archival',
    maxSize: 1000000,
    ttl: 365 * 24 * 60 * 60 * 1000  // 1 year
  },
  ARCHIVE: { 
    name: 'Archive', 
    description: 'Long-term preservation',
    maxSize: null,
    ttl: null
  }
};

// ─── Vault Entry Class ────────────────────────────────────────────────────────
class VaultEntry {
  constructor({ key, value, metadata = {} }) {
    this.key = key;
    this.value = value;
    this.metadata = {
      namespace: metadata.namespace || 'default',
      type: metadata.type || 'unknown',
      owner: metadata.owner || null,
      tags: metadata.tags || [],
      ...metadata
    };
    
    this.tier = 'HOT';
    this.createdAt = Date.now();
    this.updatedAt = Date.now();
    this.accessCount = 0;
    this.lastAccessed = null;
    this.version = 1;
    this.checksum = this._computeChecksum();
  }
  
  _computeChecksum() {
    const str = JSON.stringify(this.value);
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.charCodeAt(i);
      hash |= 0;
    }
    return hash.toString(16);
  }
  
  access() {
    this.accessCount++;
    this.lastAccessed = Date.now();
  }
  
  update(value) {
    this.value = value;
    this.updatedAt = Date.now();
    this.version++;
    this.checksum = this._computeChecksum();
  }
  
  toJSON() {
    return {
      key: this.key,
      value: this.value,
      metadata: this.metadata,
      tier: this.tier,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      accessCount: this.accessCount,
      lastAccessed: this.lastAccessed,
      version: this.version,
      checksum: this.checksum
    };
  }
}

// ─── Namespace Class ──────────────────────────────────────────────────────────
class Namespace {
  constructor(name) {
    this.name = name;
    this.entries = new Map();
    this.indexes = new Map();  // Custom indexes
    this.createdAt = Date.now();
    this.stats = {
      reads: 0,
      writes: 0,
      deletes: 0
    };
  }
  
  put(key, value, metadata = {}) {
    const fullKey = `${this.name}:${key}`;
    const entry = new VaultEntry({ 
      key: fullKey, 
      value, 
      metadata: { ...metadata, namespace: this.name } 
    });
    this.entries.set(key, entry);
    this.stats.writes++;
    
    // Update indexes
    this._updateIndexes(key, entry);
    
    return entry;
  }
  
  get(key) {
    const entry = this.entries.get(key);
    if (entry) {
      entry.access();
      this.stats.reads++;
    }
    return entry;
  }
  
  delete(key) {
    const result = this.entries.delete(key);
    if (result) this.stats.deletes++;
    return result;
  }
  
  has(key) {
    return this.entries.has(key);
  }
  
  keys() {
    return Array.from(this.entries.keys());
  }
  
  values() {
    return Array.from(this.entries.values());
  }
  
  size() {
    return this.entries.size;
  }
  
  createIndex(name, keyFn) {
    this.indexes.set(name, {
      keyFn,
      data: new Map()
    });
    
    // Build index from existing entries
    for (const [key, entry] of this.entries) {
      const indexKey = keyFn(entry);
      if (indexKey) {
        if (!this.indexes.get(name).data.has(indexKey)) {
          this.indexes.get(name).data.set(indexKey, []);
        }
        this.indexes.get(name).data.get(indexKey).push(key);
      }
    }
  }
  
  findByIndex(indexName, indexKey) {
    const index = this.indexes.get(indexName);
    if (!index) return [];
    
    const keys = index.data.get(indexKey) || [];
    return keys.map(k => this.entries.get(k)).filter(Boolean);
  }
  
  _updateIndexes(key, entry) {
    for (const [name, index] of this.indexes) {
      const indexKey = index.keyFn(entry);
      if (indexKey) {
        if (!index.data.has(indexKey)) {
          index.data.set(indexKey, []);
        }
        if (!index.data.get(indexKey).includes(key)) {
          index.data.get(indexKey).push(key);
        }
      }
    }
  }
  
  toJSON() {
    return {
      name: this.name,
      size: this.entries.size,
      indexes: this.indexes.size,
      stats: this.stats,
      createdAt: this.createdAt
    };
  }
}

// ─── Data Vault Main Class ────────────────────────────────────────────────────
export class DataVault {
  static QUAD = 'DTVT';
  static VERSION = '0.16.0';
  static IP_VALUE = 4500000;
  static DOMAIN = 'Persistence Infrastructure';
  
  // Default tier migration thresholds
  static TIER_THRESHOLDS = {
    HOT_ACCESS_COUNT: 100,        // Access count to promote to HOT
    WARM_DAYS_INACTIVE: 7,        // Days inactive to demote to WARM
    COLD_DAYS_INACTIVE: 30        // Days inactive to demote to COLD
  };
  
  constructor(config = {}) {
    this.config = {
      heartbeat: PHI_BEAT_MS,
      autoTierMigration: config.autoTierMigration !== false,
      compressionEnabled: config.compressionEnabled || false,
      tierThresholds: {
        ...DataVault.TIER_THRESHOLDS,
        ...config.tierThresholds
      },
      ...config
    };
    
    this.namespaces = new Map();
    this.tiers = new Map();
    
    // Initialize tiers
    for (const [tierName, tierConfig] of Object.entries(STORAGE_TIERS)) {
      this.tiers.set(tierName, {
        config: tierConfig,
        entries: new Set()
      });
    }
    
    this.stats = {
      totalReads: 0,
      totalWrites: 0,
      totalDeletes: 0,
      tierMigrations: 0,
      lastHeartbeat: Date.now(),
      createdAt: Date.now()
    };
    
    // Initialize default namespaces
    this._initializeDefaultNamespaces();
  }
  
  _initializeDefaultNamespaces() {
    const defaults = [
      'hq',           // AI HQ data
      'homes',        // AI Homes data
      'errors',       // Error library
      'sessions',     // Session data
      'knowledge',    // Accumulated knowledge
      'institutional' // Institutional memory
    ];
    
    for (const ns of defaults) {
      this.createNamespace(ns);
    }
  }
  
  // ─── Namespace Operations ─────────────────────────────────────────────────────
  
  /**
   * Create a namespace
   */
  createNamespace(name) {
    if (this.namespaces.has(name)) {
      return this.namespaces.get(name);
    }
    
    const namespace = new Namespace(name);
    this.namespaces.set(name, namespace);
    return namespace;
  }
  
  /**
   * Get a namespace
   */
  getNamespace(name) {
    return this.namespaces.get(name);
  }
  
  /**
   * Delete a namespace
   */
  deleteNamespace(name) {
    return this.namespaces.delete(name);
  }
  
  // ─── Core Operations ──────────────────────────────────────────────────────────
  
  /**
   * Store data
   */
  put(namespace, key, value, metadata = {}) {
    let ns = this.namespaces.get(namespace);
    if (!ns) {
      ns = this.createNamespace(namespace);
    }
    
    const entry = ns.put(key, value, metadata);
    this.stats.totalWrites++;
    
    // Track in hot tier
    this.tiers.get('HOT').entries.add(entry.key);
    
    return {
      status: 'stored',
      key: entry.key,
      version: entry.version,
      checksum: entry.checksum
    };
  }
  
  /**
   * Retrieve data
   */
  get(namespace, key) {
    const ns = this.namespaces.get(namespace);
    if (!ns) {
      return null;
    }
    
    const entry = ns.get(key);
    if (entry) {
      this.stats.totalReads++;
      return entry.value;
    }
    
    return null;
  }
  
  /**
   * Get entry with metadata
   */
  getEntry(namespace, key) {
    const ns = this.namespaces.get(namespace);
    if (!ns) return null;
    
    const entry = ns.get(key);
    if (entry) {
      this.stats.totalReads++;
    }
    return entry;
  }
  
  /**
   * Delete data
   */
  delete(namespace, key) {
    const ns = this.namespaces.get(namespace);
    if (!ns) return false;
    
    const result = ns.delete(key);
    if (result) {
      this.stats.totalDeletes++;
    }
    return result;
  }
  
  /**
   * Check if key exists
   */
  has(namespace, key) {
    const ns = this.namespaces.get(namespace);
    return ns?.has(key) || false;
  }
  
  /**
   * List keys in namespace
   */
  keys(namespace) {
    const ns = this.namespaces.get(namespace);
    return ns?.keys() || [];
  }
  
  // ─── Query Operations ─────────────────────────────────────────────────────────
  
  /**
   * Search across namespaces
   */
  search(query, options = {}) {
    const results = [];
    const namespaces = options.namespaces || Array.from(this.namespaces.keys());
    
    for (const nsName of namespaces) {
      const ns = this.namespaces.get(nsName);
      if (!ns) continue;
      
      for (const entry of ns.values()) {
        if (this._matchesQuery(entry, query)) {
          results.push(entry);
        }
      }
    }
    
    // Sort by relevance (access count + recency)
    results.sort((a, b) => {
      const scoreA = a.accessCount + (a.lastAccessed ? 1 : 0);
      const scoreB = b.accessCount + (b.lastAccessed ? 1 : 0);
      return scoreB - scoreA;
    });
    
    return options.limit ? results.slice(0, options.limit) : results;
  }
  
  _matchesQuery(entry, query) {
    // Simple string matching
    if (typeof query === 'string') {
      const str = JSON.stringify(entry.value).toLowerCase();
      return str.includes(query.toLowerCase());
    }
    
    // Tag matching
    if (query.tags) {
      const entryTags = entry.metadata.tags || [];
      return query.tags.some(tag => entryTags.includes(tag));
    }
    
    // Type matching
    if (query.type) {
      return entry.metadata.type === query.type;
    }
    
    // Owner matching
    if (query.owner) {
      return entry.metadata.owner === query.owner;
    }
    
    return false;
  }
  
  /**
   * Query by tag
   */
  findByTag(tag, namespace = null) {
    const results = [];
    const namespaces = namespace 
      ? [this.namespaces.get(namespace)].filter(Boolean)
      : Array.from(this.namespaces.values());
    
    for (const ns of namespaces) {
      for (const entry of ns.values()) {
        if (entry.metadata.tags?.includes(tag)) {
          results.push(entry);
        }
      }
    }
    
    return results;
  }
  
  /**
   * Query by owner
   */
  findByOwner(owner, namespace = null) {
    const results = [];
    const namespaces = namespace 
      ? [this.namespaces.get(namespace)].filter(Boolean)
      : Array.from(this.namespaces.values());
    
    for (const ns of namespaces) {
      for (const entry of ns.values()) {
        if (entry.metadata.owner === owner) {
          results.push(entry);
        }
      }
    }
    
    return results;
  }
  
  // ─── Tier Management ──────────────────────────────────────────────────────────
  
  /**
   * Migrate entry to different tier
   */
  migrateTier(entryKey, toTier) {
    // Remove from current tier
    for (const [tierName, tier] of this.tiers) {
      if (tier.entries.has(entryKey)) {
        tier.entries.delete(entryKey);
        break;
      }
    }
    
    // Add to new tier
    this.tiers.get(toTier)?.entries.add(entryKey);
    this.stats.tierMigrations++;
  }
  
  /**
   * Auto-migrate based on access patterns
   */
  runTierMigration() {
    const now = Date.now();
    const { HOT_ACCESS_COUNT, WARM_DAYS_INACTIVE, COLD_DAYS_INACTIVE } = this.config.tierThresholds;
    const MS_PER_DAY = 24 * 60 * 60 * 1000;
    
    for (const ns of this.namespaces.values()) {
      for (const entry of ns.values()) {
        // Frequently accessed -> HOT
        if (entry.accessCount > HOT_ACCESS_COUNT && entry.tier !== 'HOT') {
          entry.tier = 'HOT';
          this.migrateTier(entry.key, 'HOT');
        }
        // Not accessed in WARM_DAYS_INACTIVE days -> WARM
        else if (entry.lastAccessed && 
                 now - entry.lastAccessed > WARM_DAYS_INACTIVE * MS_PER_DAY &&
                 entry.tier === 'HOT') {
          entry.tier = 'WARM';
          this.migrateTier(entry.key, 'WARM');
        }
        // Not accessed in COLD_DAYS_INACTIVE days -> COLD
        else if (entry.lastAccessed && 
                 now - entry.lastAccessed > COLD_DAYS_INACTIVE * MS_PER_DAY &&
                 entry.tier === 'WARM') {
          entry.tier = 'COLD';
          this.migrateTier(entry.key, 'COLD');
        }
      }
    }
  }
  
  // ─── Export/Import ────────────────────────────────────────────────────────────
  
  /**
   * Export vault for persistence
   */
  export() {
    const data = {
      version: DataVault.VERSION,
      exportedAt: Date.now(),
      stats: this.stats,
      namespaces: {}
    };
    
    for (const [name, ns] of this.namespaces) {
      data.namespaces[name] = {
        stats: ns.stats,
        entries: Array.from(ns.entries.values()).map(e => e.toJSON())
      };
    }
    
    return data;
  }
  
  /**
   * Import vault from persistence
   */
  import(data) {
    if (data.namespaces) {
      for (const [name, nsData] of Object.entries(data.namespaces)) {
        const ns = this.createNamespace(name);
        
        for (const entryData of nsData.entries || []) {
          const entry = new VaultEntry({
            key: entryData.key,
            value: entryData.value,
            metadata: entryData.metadata
          });
          
          entry.tier = entryData.tier;
          entry.createdAt = entryData.createdAt;
          entry.updatedAt = entryData.updatedAt;
          entry.accessCount = entryData.accessCount;
          entry.lastAccessed = entryData.lastAccessed;
          entry.version = entryData.version;
          
          // Extract the local key from full key
          const localKey = entryData.key.replace(`${name}:`, '');
          ns.entries.set(localKey, entry);
        }
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
    
    // Run tier migration on heartbeat if enabled
    if (this.config.autoTierMigration) {
      this.runTierMigration();
    }
    
    return {
      quad: DataVault.QUAD,
      timestamp: now,
      delta,
      expectedDelta: PHI_BEAT_MS,
      drift: Math.abs(delta - PHI_BEAT_MS),
      phi: PHI,
      stats: this.stats,
      namespaces: Array.from(this.namespaces.values()).map(ns => ns.toJSON()),
      tiers: Object.fromEntries(
        Array.from(this.tiers.entries()).map(([k, v]) => [k, v.entries.size])
      )
    };
  }
  
  toJSON() {
    let totalEntries = 0;
    for (const ns of this.namespaces.values()) {
      totalEntries += ns.size();
    }
    
    return {
      quad: DataVault.QUAD,
      version: DataVault.VERSION,
      ipValue: DataVault.IP_VALUE,
      domain: DataVault.DOMAIN,
      namespaces: this.namespaces.size,
      totalEntries,
      stats: this.stats,
      tiers: Object.fromEntries(
        Array.from(this.tiers.entries()).map(([k, v]) => [k, v.entries.size])
      )
    };
  }
}

// ─── Export ────────────────────────────────────────────────────────────────────
export { STORAGE_TIERS, VaultEntry, Namespace };
export default DataVault;
