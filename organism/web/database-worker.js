/**
 * SPDX-License-Identifier: CPEL-1.0
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All rights reserved.
 * Framework: Medina Doctrine
 *
 * Database Worker — AGI-Managed Sovereign Database Layer
 *
 * 13 sovereign databases with AGI governance, Fibonacci-bounded capacity,
 * auto-indexing, auto-compaction, integrity verification, and living
 * artifact compression. The database is ALIVE — it self-manages through
 * phi-scaled governance intervals and Fibonacci compression.
 *
 * The 23rd Web Worker in the organism fleet. Every record is hash-verified,
 * every index is Fibonacci-bounded, every compaction follows golden-ratio
 * compression curves. The AGI governance engine runs autonomously on the
 * 873ms heartbeat — no external scheduler needed.
 *
 * ════════════════════════════════════════════════════════════════════════
 *                    13 SOVEREIGN DATABASES
 * ════════════════════════════════════════════════════════════════════════
 *
 *   DB-001  ORGANISM_STATE      — Brain snapshots, memory patterns, coupling
 *   DB-002  TOOL_REGISTRY       — 200+ tool definitions, versions, capabilities
 *   DB-003  PROTOCOL_REGISTRY   — 89+ protocol definitions, step graphs
 *   DB-004  MARKETPLACE_LEDGER  — Invocations, settlements, billing records
 *   DB-005  CLIENT_RECORDS      — Client profiles, tiers, quotas, health scores
 *   DB-006  AGENT_PROFILES      — 610 VOIS agents, capabilities, activation logs
 *   DB-007  ANIMA_CHAIN         — Immutable hash chain blocks, verification proofs
 *   DB-008  TELEMETRY_SERIES    — Time-series metrics, aggregated stats, baselines
 *   DB-009  AUDIT_LOG           — Platform operations audit trail, compliance events
 *   DB-010  KNOWLEDGE_GRAPH     — Entity nodes, relationships, embeddings
 *   DB-011  RESEARCH_CORPUS     — Papers, findings, experiments, citations
 *   DB-012  CONFIG_VAULT        — System configuration, feature flags, secrets refs
 *   DB-013  SHADOW_MIRROR       — Anonymized public-safe views, SHADOW clones
 *
 * ════════════════════════════════════════════════════════════════════════
 *                    AGI GOVERNANCE SCHEDULE
 * ════════════════════════════════════════════════════════════════════════
 *
 *   Every F9  (34)  beats — Auto-index rebuild across all databases
 *   Every F11 (89)  beats — Auto-compaction with Fibonacci compression
 *   Every F12 (144) beats — Integrity verification (hash checking)
 *   Every F13 (233) beats — Cross-database consistency check
 *
 * Fibonacci Compression:
 *   Records older than F8  (21) beats → merge every 2 adjacent → artifact
 *   Records older than F10 (55) beats → merge every 5 adjacent → artifact
 *   Records older than F12 (144) beats → merge every 21 adjacent → artifact
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'queryDatabase', dbId }
 *   Main → Worker: { type: 'queryRecord', dbId, recordId }
 *   Main → Worker: { type: 'queryRecords', dbId, filters, options }
 *   Main → Worker: { type: 'queryAcrossDatabases', query }
 *   Main → Worker: { type: 'queryStats', dbId }
 *   Main → Worker: { type: 'queryIndexes', dbId }
 *   Main → Worker: { type: 'queryIntegrity', dbId }
 *   Main → Worker: { type: 'queryCapacity' }
 *   Main → Worker: { type: 'queryAuditTrail', count }
 *   Main → Worker: { type: 'queryResearchCorpus', query }
 *   Main → Worker: { type: 'callInsert', dbId, record }
 *   Main → Worker: { type: 'callBatchInsert', dbId, records }
 *   Main → Worker: { type: 'callUpdate', dbId, recordId, updates }
 *   Main → Worker: { type: 'callRemove', dbId, recordId }
 *   Main → Worker: { type: 'callCompact', dbId }
 *   Main → Worker: { type: 'callMigrate', dbId, migration }
 *   Main → Worker: { type: 'callSnapshot', dbId }
 *   Main → Worker: { type: 'callRestore', dbId, snapshotId }
 *   Main → Worker: { type: 'callPurge', dbId, filters }
 *   Main → Worker: { type: 'callExport', dbId, format }
 *   Main → Worker: { type: 'getState' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'heartbeat', beat, phi, heartbeatMs, timestamp, status }
 *   Worker → Main: { type: 'agi-governance', action, dbId, stats }
 */

// ════════════════════════════════════════════════════════════════════════
//  CONSTANTS — Golden Ratio & Fibonacci Governance
// ════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_SQ = PHI * PHI;                    // 2.618033988749895
const PHI_NEG2 = PHI_INV * PHI_INV;          // 0.381966...
const PHI_NEG6 = Math.pow(PHI_INV, 6);       // 0.055728...
const HEARTBEAT = 873;
const MAX_RECORDS_PER_DB = 4181;    // F19
const MAX_TOTAL_RECORDS = 17711;    // F22
const MAX_SNAPSHOTS = 89;           // F11
const MAX_INDEXES = 610;            // F15
const MAX_AUDIT = 2584;             // F18
const AGI_INDEX_INTERVAL = 34;      // F9 beats — auto-index rebuild
const AGI_COMPACT_INTERVAL = 89;    // F11 beats — auto-compaction
const AGI_INTEGRITY_INTERVAL = 144; // F12 beats — integrity check
const AGI_CONSISTENCY_INTERVAL = 233; // F13 beats — cross-db consistency

// Fibonacci compression thresholds
const FIB_COMPRESS_TIER1_AGE = 21;  // F8 — merge every 2
const FIB_COMPRESS_TIER1_GROUP = 2; // F3
const FIB_COMPRESS_TIER2_AGE = 55;  // F10 — merge every 5
const FIB_COMPRESS_TIER2_GROUP = 5; // F5
const FIB_COMPRESS_TIER3_AGE = 144; // F12 — merge every 21
const FIB_COMPRESS_TIER3_GROUP = 21; // F8

let beatCount = 0;
let running = true;
let recordIdCounter = 0;
let snapshotIdCounter = 0;
let totalInserts = 0;
let totalUpdates = 0;
let totalDeletes = 0;
let totalQueries = 0;
let totalCompactions = 0;
let totalArtifactsCreated = 0;
let totalIntegrityChecks = 0;
let totalConsistencyChecks = 0;

// Fibonacci sequence cache for compression calculations
const FIB_CACHE = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711];

/**
 * Get the nth Fibonacci number (cached).
 */
function fib(n) {
  if (n < FIB_CACHE.length) return FIB_CACHE[n];
  var a = FIB_CACHE[FIB_CACHE.length - 2];
  var b = FIB_CACHE[FIB_CACHE.length - 1];
  for (var i = FIB_CACHE.length; i <= n; i++) {
    var c = a + b;
    a = b;
    b = c;
    FIB_CACHE.push(c);
  }
  return FIB_CACHE[n];
}

// ════════════════════════════════════════════════════════════════════════
//  FNV-1a HASH — Deterministic proof hash for all records
// ════════════════════════════════════════════════════════════════════════

function fnv1a(str) {
  let hash = 2166136261;
  for (let i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = (hash * 16777619) >>> 0;
  }
  return hash;
}

function fnv1aToString(input) {
  return fnv1a(input).toString(10);
}

function computeRecordHash(record) {
  const fields = Object.keys(record)
    .filter(function (k) { return k !== '_hash' && k !== '_tombstone'; })
    .sort();
  const payload = fields.map(function (k) {
    return k + ':' + JSON.stringify(record[k]);
  }).join('|');
  return fnv1a(payload);
}

/**
 * Compute a chain hash linking a record to its predecessor.
 * Used for ANIMA chain blocks and audit trail integrity.
 */
function computeChainHash(currentHash, previousHash) {
  var combined = String(previousHash) + '->' + String(currentHash);
  return fnv1a(combined);
}

/**
 * Compute a Merkle-style root hash from an array of record hashes.
 * Used for snapshot integrity verification.
 */
function computeMerkleRoot(hashes) {
  if (hashes.length === 0) return 0;
  if (hashes.length === 1) return hashes[0];

  var level = hashes.slice();
  while (level.length > 1) {
    var nextLevel = [];
    for (var i = 0; i < level.length; i += 2) {
      if (i + 1 < level.length) {
        nextLevel.push(fnv1a(String(level[i]) + ':' + String(level[i + 1])));
      } else {
        nextLevel.push(level[i]);
      }
    }
    level = nextLevel;
  }
  return level[0];
}

// ════════════════════════════════════════════════════════════════════════
//  RECORD VALIDATION — Schema enforcement for sovereign databases
// ════════════════════════════════════════════════════════════════════════

/**
 * Validate that a record has the required type field and belongs
 * to a valid recordType for its target database.
 */
function validateRecord(dbDef, record) {
  var errors = [];

  if (!record) {
    errors.push('Record is null or undefined');
    return { valid: false, errors: errors };
  }

  if (typeof record !== 'object') {
    errors.push('Record must be an object');
    return { valid: false, errors: errors };
  }

  // Type validation — must be one of the db's recordTypes
  if (record.type) {
    var validTypes = dbDef.recordTypes || [];
    var typeValid = false;
    for (var i = 0; i < validTypes.length; i++) {
      if (validTypes[i] === record.type) {
        typeValid = true;
        break;
      }
    }
    if (!typeValid && record.type !== 'compressed-artifact') {
      errors.push('Invalid record type "' + record.type + '" for database ' + dbDef.id);
    }
  }

  // Size validation — individual fields should not exceed reasonable limits
  var keys = Object.keys(record);
  for (var k = 0; k < keys.length; k++) {
    var key = keys[k];
    var val = record[key];
    if (typeof val === 'string' && val.length > 65536) {
      errors.push('Field "' + key + '" exceeds maximum string length (65536)');
    }
  }

  return { valid: errors.length === 0, errors: errors };
}

/**
 * Validate that a database ID is known and active.
 */
function validateDbId(dbId) {
  for (var i = 0; i < DATABASE_DEFS.length; i++) {
    if (DATABASE_DEFS[i].id === dbId) return true;
  }
  return false;
}

// ════════════════════════════════════════════════════════════════════════
//  ANIMA CHAIN MANAGEMENT — Hash chain extension for proof of life
// ════════════════════════════════════════════════════════════════════════

var animaChainHead = fnv1a('DATABASE-WORKER-GENESIS');
var animaChainLength = 0;
var animaChainHistory = [];
var MAX_CHAIN_HISTORY = 89; // F11

/**
 * Extend the ANIMA chain by one block.
 * Chain rule: head(t+1) = FNV-1a(head(t) + beat + timestamp)
 */
function extendAnimaChain() {
  var input = String(animaChainHead) + ':' + beatCount + ':' + Date.now();
  var newHead = fnv1a(input);
  animaChainLength++;

  animaChainHistory.push({
    head: newHead,
    previousHead: animaChainHead,
    length: animaChainLength,
    beat: beatCount,
    timestamp: Date.now()
  });

  if (animaChainHistory.length > MAX_CHAIN_HISTORY) {
    animaChainHistory.shift();
  }

  animaChainHead = newHead;

  // Persist chain extension to ANIMA_CHAIN database
  if (animaChainLength % 13 === 0) { // Every 13 beats, persist a chain block
    engine.insert('DB-007', {
      type: 'chain-extension',
      blockHeight: animaChainLength,
      hash: newHead,
      previousHash: animaChainHistory.length > 1
        ? animaChainHistory[animaChainHistory.length - 2].head
        : 0,
      payload: 'Database worker chain extension at beat ' + beatCount,
      worker: 'database-worker',
      timestamp: Date.now(),
      nonce: (beatCount * 16777619) >>> 0,
      verified: true
    });
  }

  return { head: newHead, length: animaChainLength };
}

/**
 * Verify the ANIMA chain integrity by checking consecutive history entries.
 */
function verifyAnimaChain() {
  if (animaChainHistory.length < 2) {
    return { valid: true, length: animaChainLength, checked: 0 };
  }

  var valid = true;
  var checked = 0;
  for (var i = 1; i < animaChainHistory.length; i++) {
    var entry = animaChainHistory[i];
    var prevEntry = animaChainHistory[i - 1];
    if (entry.previousHead !== prevEntry.head) {
      valid = false;
      break;
    }
    checked++;
  }

  return { valid: valid, length: animaChainLength, checked: checked, head: animaChainHead };
}

// ════════════════════════════════════════════════════════════════════════
//  HEALTH SCORING — PHI-scaled database health computation
// ════════════════════════════════════════════════════════════════════════

/**
 * Compute a health score for a single database (0.0 – 1.0).
 * Factors: utilization, tombstone ratio, integrity, freshness.
 */
function computeDbHealth(dbId) {
  var db = engine.databases.get(dbId);
  if (!db) return { score: 0, factors: {} };

  var totalRecords = db.records.size;
  var maxRecords = db.maxRecords;
  var tombstoneCount = 0;
  var artifactCount = 0;
  var liveCount = 0;

  db.records.forEach(function (rec) {
    if (rec._tombstone) tombstoneCount++;
    else if (rec.type === 'compressed-artifact') artifactCount++;
    else liveCount++;
  });

  // Factor 1: Utilization — ideal is between 0.1 and PHI_INV of capacity
  var utilization = totalRecords / maxRecords;
  var utilizationScore = 1.0;
  if (utilization > 0.95) utilizationScore = 0.2;
  else if (utilization > PHI_INV) utilizationScore = 1.0 - ((utilization - PHI_INV) * PHI);
  else if (utilization < 0.01 && totalRecords > 0) utilizationScore = 0.8;

  // Factor 2: Tombstone ratio — lower is better
  var tombstoneRatio = totalRecords > 0 ? tombstoneCount / totalRecords : 0;
  var tombstoneScore = 1.0 - (tombstoneRatio * PHI);
  if (tombstoneScore < 0) tombstoneScore = 0;

  // Factor 3: Integrity — based on last integrity check
  var integrityScore = 1.0;
  if (db.stats.integrityFailed > 0) {
    var failRate = db.stats.integrityFailed / (db.stats.integrityPassed + db.stats.integrityFailed);
    integrityScore = 1.0 - failRate;
  }

  // Factor 4: Freshness — how recently was the DB modified
  var now = Date.now();
  var age = now - (db.stats.lastModified || db.stats.createdAt);
  var freshnessScore = 1.0;
  if (age > 3600000) freshnessScore = PHI_INV; // older than 1 hour
  if (age > 86400000) freshnessScore = PHI_NEG2; // older than 1 day

  // Weighted combination using PHI ratios
  var score = (
    utilizationScore * PHI_INV +
    tombstoneScore * PHI_NEG2 +
    integrityScore * PHI_INV +
    freshnessScore * PHI_NEG6
  ) / (PHI_INV + PHI_NEG2 + PHI_INV + PHI_NEG6);

  // Clamp to [0, 1]
  if (score > 1.0) score = 1.0;
  if (score < 0.0) score = 0.0;

  return {
    score: Math.round(score * 10000) / 10000,
    factors: {
      utilization: Math.round(utilizationScore * 1000) / 1000,
      tombstone: Math.round(tombstoneScore * 1000) / 1000,
      integrity: Math.round(integrityScore * 1000) / 1000,
      freshness: Math.round(freshnessScore * 1000) / 1000
    },
    metrics: {
      totalRecords: totalRecords,
      liveRecords: liveCount,
      tombstones: tombstoneCount,
      artifacts: artifactCount,
      capacity: maxRecords,
      utilizationPct: Math.round(utilization * 10000) / 100
    }
  };
}

/**
 * Compute aggregate health across all databases.
 */
function computeFleetHealth() {
  var scores = [];
  var dbHealths = [];

  engine.databases.forEach(function (db, dbId) {
    var health = computeDbHealth(dbId);
    scores.push(health.score);
    dbHealths.push({
      dbId: dbId,
      name: db.name,
      score: health.score,
      factors: health.factors,
      metrics: health.metrics
    });
  });

  // Aggregate score — geometric mean scaled by PHI
  var product = 1.0;
  for (var i = 0; i < scores.length; i++) {
    product *= Math.max(scores[i], 0.001); // avoid zero
  }
  var geoMean = Math.pow(product, 1.0 / scores.length);

  // Minimum score acts as a floor warning
  var minScore = 1.0;
  var minDb = '';
  for (var j = 0; j < dbHealths.length; j++) {
    if (dbHealths[j].score < minScore) {
      minScore = dbHealths[j].score;
      minDb = dbHealths[j].dbId;
    }
  }

  return {
    overallScore: Math.round(geoMean * 10000) / 10000,
    minScore: Math.round(minScore * 10000) / 10000,
    minScoreDb: minDb,
    databaseCount: dbHealths.length,
    databases: dbHealths,
    animaChain: {
      head: animaChainHead,
      length: animaChainLength,
      valid: verifyAnimaChain().valid
    }
  };
}

// ════════════════════════════════════════════════════════════════════════
//  TELEMETRY RECORDING — Metrics pushed to TELEMETRY_SERIES (DB-008)
// ════════════════════════════════════════════════════════════════════════

var lastTelemetryBeat = 0;
var TELEMETRY_SAMPLE_INTERVAL = 13; // Every F7 beats, record telemetry

/**
 * Record current database metrics into DB-008 (TELEMETRY_SERIES).
 */
function recordTelemetry() {
  if (beatCount - lastTelemetryBeat < TELEMETRY_SAMPLE_INTERVAL) return;
  lastTelemetryBeat = beatCount;

  var totalRecords = engine.getTotalRecordCount();
  var health = computeFleetHealth();

  engine.insert('DB-008', {
    type: 'system-metric',
    metricName: 'database.totalRecords',
    value: totalRecords,
    workerId: 'database-worker',
    window: 'point',
    beat: beatCount,
    timestamp: Date.now()
  });

  engine.insert('DB-008', {
    type: 'system-metric',
    metricName: 'database.healthScore',
    value: health.overallScore,
    workerId: 'database-worker',
    window: 'point',
    beat: beatCount,
    timestamp: Date.now()
  });

  engine.insert('DB-008', {
    type: 'system-metric',
    metricName: 'database.inserts',
    value: totalInserts,
    workerId: 'database-worker',
    window: 'cumulative',
    beat: beatCount,
    timestamp: Date.now()
  });

  engine.insert('DB-008', {
    type: 'system-metric',
    metricName: 'database.queries',
    value: totalQueries,
    workerId: 'database-worker',
    window: 'cumulative',
    beat: beatCount,
    timestamp: Date.now()
  });
}

// ════════════════════════════════════════════════════════════════════════
//  13 DATABASE DEFINITIONS
// ════════════════════════════════════════════════════════════════════════

const DATABASE_DEFS = [
  {
    id: 'DB-001',
    name: 'ORGANISM_STATE',
    description: 'Brain snapshots, memory patterns, coupling values, heritage status, GRPE scans, alpha orchestrator states',
    recordTypes: [
      'brain-snapshot', 'memory-pattern', 'coupling-value',
      'heritage-status', 'grpe-scan', 'alpha-state',
      'region-activation', 'coherence-reading', 'emergence-score'
    ],
    indexes: ['type', 'timestamp', 'region', 'coherence', 'source'],
    retentionPolicy: 'fibonacci-compress',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-002',
    name: 'TOOL_REGISTRY',
    description: 'All 200+ tool definitions, versions, capabilities, dependencies, performance stats',
    recordTypes: [
      'tool-definition', 'tool-version', 'tool-capability',
      'tool-dependency', 'performance-stat', 'tool-config',
      'tool-schema', 'tool-permission', 'tool-metric'
    ],
    indexes: ['toolId', 'name', 'category', 'version', 'status'],
    retentionPolicy: 'permanent',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-003',
    name: 'PROTOCOL_REGISTRY',
    description: 'All 89+ protocol definitions, step graphs, execution templates, versioning',
    recordTypes: [
      'protocol-definition', 'step-graph', 'execution-template',
      'protocol-version', 'protocol-dependency', 'protocol-config',
      'step-node', 'step-edge', 'execution-log'
    ],
    indexes: ['protocolId', 'name', 'category', 'version', 'status'],
    retentionPolicy: 'permanent',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-004',
    name: 'MARKETPLACE_LEDGER',
    description: 'Invocations, settlements, caller profiles, billing records, usage analytics',
    recordTypes: [
      'invocation', 'settlement', 'caller-profile',
      'billing-record', 'usage-analytic', 'revenue-entry',
      'cost-allocation', 'refund', 'pricing-tier'
    ],
    indexes: ['callerId', 'toolId', 'timestamp', 'status', 'amount'],
    retentionPolicy: 'fibonacci-compress',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-005',
    name: 'CLIENT_RECORDS',
    description: 'Client profiles, tiers, quotas, usage history, health scores, SLA compliance',
    recordTypes: [
      'client-profile', 'client-tier', 'client-quota',
      'usage-history', 'health-score', 'sla-compliance',
      'client-config', 'client-contact', 'client-billing'
    ],
    indexes: ['clientId', 'name', 'tier', 'status', 'healthScore'],
    retentionPolicy: 'permanent',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-006',
    name: 'AGENT_PROFILES',
    description: '610 VOIS agents, capabilities, activation logs, performance metrics',
    recordTypes: [
      'agent-profile', 'agent-capability', 'activation-log',
      'performance-metric', 'agent-config', 'agent-state',
      'skill-matrix', 'task-assignment', 'agent-health'
    ],
    indexes: ['agentId', 'name', 'role', 'status', 'capability'],
    retentionPolicy: 'fibonacci-compress',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-007',
    name: 'ANIMA_CHAIN',
    description: 'Immutable hash chain blocks, verification proofs, genesis references',
    recordTypes: [
      'chain-block', 'verification-proof', 'genesis-reference',
      'chain-extension', 'integrity-seal', 'chain-fork',
      'merge-proof', 'anchor-block', 'witness-record'
    ],
    indexes: ['blockHeight', 'hash', 'previousHash', 'timestamp', 'type'],
    retentionPolicy: 'immutable',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-008',
    name: 'TELEMETRY_SERIES',
    description: 'Time-series metrics from all workers, aggregated stats, anomaly baselines',
    recordTypes: [
      'metric-point', 'aggregated-stat', 'anomaly-baseline',
      'worker-metric', 'system-metric', 'latency-sample',
      'throughput-sample', 'error-rate', 'resource-usage'
    ],
    indexes: ['metricName', 'workerId', 'timestamp', 'window', 'value'],
    retentionPolicy: 'fibonacci-compress',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-009',
    name: 'AUDIT_LOG',
    description: 'All platform operations audit trail, compliance events, access logs',
    recordTypes: [
      'operation-audit', 'compliance-event', 'access-log',
      'permission-check', 'data-access', 'config-change',
      'security-event', 'api-call', 'admin-action'
    ],
    indexes: ['operation', 'dbId', 'timestamp', 'actor', 'severity'],
    retentionPolicy: 'fibonacci-compress',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-010',
    name: 'KNOWLEDGE_GRAPH',
    description: 'Entity nodes, relationships, embeddings, graph traversal indexes',
    recordTypes: [
      'entity-node', 'relationship', 'embedding',
      'graph-index', 'traversal-path', 'cluster',
      'concept', 'annotation', 'edge-weight'
    ],
    indexes: ['entityId', 'entityType', 'relationship', 'source', 'target'],
    retentionPolicy: 'permanent',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-011',
    name: 'RESEARCH_CORPUS',
    description: 'Papers, findings, experiments, citations, methodology records',
    recordTypes: [
      'paper', 'finding', 'experiment',
      'citation', 'methodology', 'dataset',
      'hypothesis', 'conclusion', 'review'
    ],
    indexes: ['title', 'author', 'category', 'timestamp', 'status'],
    retentionPolicy: 'permanent',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-012',
    name: 'CONFIG_VAULT',
    description: 'System configuration, feature flags, secrets references, deployment configs',
    recordTypes: [
      'system-config', 'feature-flag', 'secret-reference',
      'deployment-config', 'env-variable', 'service-endpoint',
      'threshold-config', 'policy-rule', 'override'
    ],
    indexes: ['key', 'category', 'environment', 'status', 'version'],
    retentionPolicy: 'permanent',
    maxRecords: MAX_RECORDS_PER_DB
  },
  {
    id: 'DB-013',
    name: 'SHADOW_MIRROR',
    description: 'Anonymized public-safe data views, SHADOW clone records, lineage traces',
    recordTypes: [
      'shadow-view', 'clone-record', 'lineage-trace',
      'anonymized-record', 'public-projection', 'mirror-sync',
      'redaction-log', 'consent-record', 'export-manifest'
    ],
    indexes: ['sourceDb', 'sourceId', 'timestamp', 'status', 'mirrorType'],
    retentionPolicy: 'fibonacci-compress',
    maxRecords: MAX_RECORDS_PER_DB
  }
];

// ════════════════════════════════════════════════════════════════════════
//  DATABASE ENGINE — In-Memory Sovereign Database
// ════════════════════════════════════════════════════════════════════════

function DatabaseEngine() {
  this.databases = new Map();
  this.initialized = false;
  this.createdAt = Date.now();
}

/**
 * Initialize a single database from its definition.
 * Creates the records map, index maps, stats, and snapshots array.
 */
DatabaseEngine.prototype.initDatabase = function (dbDef) {
  var indexMap = new Map();
  for (var i = 0; i < dbDef.indexes.length; i++) {
    indexMap.set(dbDef.indexes[i], new Map());
  }

  var db = {
    id: dbDef.id,
    name: dbDef.name,
    description: dbDef.description,
    recordTypes: dbDef.recordTypes,
    indexFields: dbDef.indexes,
    retentionPolicy: dbDef.retentionPolicy,
    maxRecords: dbDef.maxRecords,
    records: new Map(),
    indexes: indexMap,
    snapshots: [],
    stats: {
      inserts: 0,
      updates: 0,
      deletes: 0,
      queries: 0,
      compactions: 0,
      snapshotsCreated: 0,
      lastCompaction: null,
      lastIntegrityCheck: null,
      artifactsCreated: 0,
      integrityPassed: 0,
      integrityFailed: 0,
      createdAt: Date.now(),
      lastModified: Date.now()
    },
    migrations: [],
    version: 1
  };

  this.databases.set(dbDef.id, db);
  return db;
};

/**
 * Initialize all 13 databases from DATABASE_DEFS.
 */
DatabaseEngine.prototype.initAll = function () {
  for (var i = 0; i < DATABASE_DEFS.length; i++) {
    this.initDatabase(DATABASE_DEFS[i]);
  }
  this.initialized = true;
};

/**
 * Generate a unique record ID.
 */
DatabaseEngine.prototype.generateId = function () {
  recordIdCounter++;
  return 'REC-' + recordIdCounter.toString(36).toUpperCase().padStart(8, '0');
};

/**
 * Generate a unique snapshot ID.
 */
DatabaseEngine.prototype.generateSnapshotId = function () {
  snapshotIdCounter++;
  return 'SNAP-' + snapshotIdCounter.toString(36).toUpperCase().padStart(6, '0');
};

/**
 * Insert a record into a database.
 * Auto-generates _id, timestamps, version, hash. Auto-indexes all index fields.
 */
DatabaseEngine.prototype.insert = function (dbId, record) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  if (db.records.size >= db.maxRecords) {
    return { error: true, message: 'Database ' + dbId + ' at capacity: ' + db.maxRecords };
  }

  var totalCount = this.getTotalRecordCount();
  if (totalCount >= MAX_TOTAL_RECORDS) {
    return { error: true, message: 'Total record limit reached: ' + MAX_TOTAL_RECORDS };
  }

  var now = Date.now();
  var id = record._id || this.generateId();

  var stored = {};
  var keys = Object.keys(record);
  for (var k = 0; k < keys.length; k++) {
    if (keys[k] !== '_id') {
      stored[keys[k]] = record[keys[k]];
    }
  }
  stored._id = id;
  stored._dbId = dbId;
  stored._createdAt = now;
  stored._updatedAt = now;
  stored._version = 1;
  stored._tombstone = false;
  stored._hash = computeRecordHash(stored);
  stored._beat = beatCount;

  db.records.set(id, stored);
  this.rebuildIndexesForRecord(db, stored);

  db.stats.inserts++;
  db.stats.lastModified = now;
  totalInserts++;

  return { error: false, id: id, dbId: dbId, hash: stored._hash };
};

/**
 * Batch insert up to F11 (89) records into a database.
 */
DatabaseEngine.prototype.batchInsert = function (dbId, records) {
  var maxBatch = 89; // F11
  var batch = records.slice(0, maxBatch);
  var results = [];
  var succeeded = 0;
  var failed = 0;

  for (var i = 0; i < batch.length; i++) {
    var result = this.insert(dbId, batch[i]);
    results.push(result);
    if (result.error) {
      failed++;
    } else {
      succeeded++;
    }
  }

  return {
    error: false,
    dbId: dbId,
    total: batch.length,
    succeeded: succeeded,
    failed: failed,
    truncated: records.length > maxBatch,
    results: results
  };
};

/**
 * Get a record by ID from a database.
 */
DatabaseEngine.prototype.get = function (dbId, recordId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var record = db.records.get(recordId);
  if (!record) {
    return { error: true, message: 'Record not found: ' + recordId };
  }

  if (record._tombstone) {
    return { error: true, message: 'Record deleted: ' + recordId };
  }

  db.stats.queries++;
  totalQueries++;

  return { error: false, record: record };
};

/**
 * Query records in a database with filters, sort, limit, offset.
 * Filters are field:value pairs. Options: { sort, limit, offset, includeTombstones }.
 */
DatabaseEngine.prototype.query = function (dbId, filters, options) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  options = options || {};
  var limit = options.limit || 100;
  var offset = options.offset || 0;
  var sortField = options.sort || '_createdAt';
  var sortDir = options.sortDir || 'desc';
  var includeTombstones = options.includeTombstones || false;

  // Try index-based lookup for single-field equality filters
  var filterKeys = filters ? Object.keys(filters) : [];
  var candidates = null;

  if (filterKeys.length === 1 && db.indexes.has(filterKeys[0])) {
    var indexMap = db.indexes.get(filterKeys[0]);
    var indexValue = String(filters[filterKeys[0]]);
    var indexed = indexMap.get(indexValue);
    if (indexed) {
      candidates = [];
      indexed.forEach(function (recId) {
        var rec = db.records.get(recId);
        if (rec) candidates.push(rec);
      });
    } else {
      candidates = [];
    }
  }

  // Fall back to full scan
  if (candidates === null) {
    candidates = [];
    db.records.forEach(function (rec) {
      candidates.push(rec);
    });
  }

  // Apply filters
  var results = [];
  for (var i = 0; i < candidates.length; i++) {
    var rec = candidates[i];
    if (!includeTombstones && rec._tombstone) continue;

    var match = true;
    for (var f = 0; f < filterKeys.length; f++) {
      var key = filterKeys[f];
      if (rec[key] !== undefined && String(rec[key]) !== String(filters[key])) {
        match = false;
        break;
      }
      if (rec[key] === undefined) {
        match = false;
        break;
      }
    }
    if (match) {
      results.push(rec);
    }
  }

  // Sort
  results.sort(function (a, b) {
    var va = a[sortField];
    var vb = b[sortField];
    if (va === undefined) va = 0;
    if (vb === undefined) vb = 0;
    if (sortDir === 'asc') return va > vb ? 1 : va < vb ? -1 : 0;
    return va < vb ? 1 : va > vb ? -1 : 0;
  });

  var total = results.length;
  results = results.slice(offset, offset + limit);

  db.stats.queries++;
  totalQueries++;

  return {
    error: false,
    dbId: dbId,
    records: results,
    total: total,
    limit: limit,
    offset: offset,
    hasMore: (offset + limit) < total
  };
};

/**
 * Partial update of a record. Re-indexes after update.
 */
DatabaseEngine.prototype.update = function (dbId, recordId, updates) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var record = db.records.get(recordId);
  if (!record) {
    return { error: true, message: 'Record not found: ' + recordId };
  }

  if (record._tombstone) {
    return { error: true, message: 'Cannot update deleted record: ' + recordId };
  }

  // Remove old index entries
  this.removeIndexesForRecord(db, record);

  // Apply updates (skip internal fields)
  var updateKeys = Object.keys(updates);
  for (var i = 0; i < updateKeys.length; i++) {
    var key = updateKeys[i];
    if (key.charAt(0) === '_') continue; // protect internal fields
    record[key] = updates[key];
  }

  record._updatedAt = Date.now();
  record._version++;
  record._hash = computeRecordHash(record);
  record._beat = beatCount;

  // Rebuild indexes
  this.rebuildIndexesForRecord(db, record);

  db.stats.updates++;
  db.stats.lastModified = Date.now();
  totalUpdates++;

  return {
    error: false,
    id: recordId,
    dbId: dbId,
    version: record._version,
    hash: record._hash
  };
};

/**
 * Soft delete — sets _tombstone to true.
 */
DatabaseEngine.prototype.remove = function (dbId, recordId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var record = db.records.get(recordId);
  if (!record) {
    return { error: true, message: 'Record not found: ' + recordId };
  }

  if (record._tombstone) {
    return { error: true, message: 'Record already deleted: ' + recordId };
  }

  record._tombstone = true;
  record._updatedAt = Date.now();
  record._version++;
  record._hash = computeRecordHash(record);

  db.stats.deletes++;
  db.stats.lastModified = Date.now();
  totalDeletes++;

  return { error: false, id: recordId, dbId: dbId, tombstoned: true };
};

/**
 * Compact a database — remove tombstones, rebuild indexes,
 * Fibonacci-compress old data into artifacts.
 */
DatabaseEngine.prototype.compact = function (dbId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var removedTombstones = 0;
  var artifactsCreated = 0;
  var compressedRecords = 0;
  var now = Date.now();

  // Phase 1: Remove tombstoned records
  var toRemove = [];
  db.records.forEach(function (rec, id) {
    if (rec._tombstone) {
      toRemove.push(id);
    }
  });
  for (var i = 0; i < toRemove.length; i++) {
    db.records.delete(toRemove[i]);
    removedTombstones++;
  }

  // Phase 2: Fibonacci compression (only for fibonacci-compress policy)
  if (db.retentionPolicy === 'fibonacci-compress') {
    var compressed = this.fibonacciCompress(db);
    artifactsCreated += compressed.artifacts;
    compressedRecords += compressed.compressed;
  }

  // Phase 3: Rebuild all indexes
  this.rebuildAllIndexes(db);

  db.stats.compactions++;
  db.stats.lastCompaction = now;
  db.stats.artifactsCreated += artifactsCreated;
  totalCompactions++;
  totalArtifactsCreated += artifactsCreated;

  return {
    error: false,
    dbId: dbId,
    removedTombstones: removedTombstones,
    artifactsCreated: artifactsCreated,
    compressedRecords: compressedRecords,
    remainingRecords: db.records.size
  };
};

/**
 * Fibonacci compression — merge old records into artifact summaries.
 * Tier 1: records older than F8 (21) beats, merge every 2 adjacent
 * Tier 2: records older than F10 (55) beats, merge every 5 adjacent
 * Tier 3: records older than F12 (144) beats, merge every 21 adjacent
 */
DatabaseEngine.prototype.fibonacciCompress = function (db) {
  var artifacts = 0;
  var compressed = 0;

  // Collect non-tombstoned, non-artifact records sorted by beat
  var records = [];
  db.records.forEach(function (rec) {
    if (!rec._tombstone && rec.type !== 'compressed-artifact') {
      records.push(rec);
    }
  });

  records.sort(function (a, b) {
    return (a._beat || 0) - (b._beat || 0);
  });

  // Tier 3 first (most aggressive), then 2, then 1
  var tiers = [
    { age: FIB_COMPRESS_TIER3_AGE, group: FIB_COMPRESS_TIER3_GROUP, tier: 3 },
    { age: FIB_COMPRESS_TIER2_AGE, group: FIB_COMPRESS_TIER2_GROUP, tier: 2 },
    { age: FIB_COMPRESS_TIER1_AGE, group: FIB_COMPRESS_TIER1_GROUP, tier: 1 }
  ];

  for (var t = 0; t < tiers.length; t++) {
    var tier = tiers[t];
    var eligible = [];

    for (var i = 0; i < records.length; i++) {
      var age = beatCount - (records[i]._beat || 0);
      if (age >= tier.age && records[i].type !== 'compressed-artifact') {
        eligible.push(records[i]);
      }
    }

    // Group eligible records and merge
    var groupStart = 0;
    while (groupStart + tier.group <= eligible.length) {
      var group = eligible.slice(groupStart, groupStart + tier.group);

      // Create artifact
      var artifactData = {
        type: 'compressed-artifact',
        compressionTier: tier.tier,
        sourceCount: group.length,
        sourceIds: group.map(function (r) { return r._id; }),
        sourceTypes: [],
        minBeat: Infinity,
        maxBeat: 0,
        minCreatedAt: Infinity,
        maxCreatedAt: 0,
        summary: {}
      };

      var typeSet = {};
      for (var g = 0; g < group.length; g++) {
        var rec = group[g];
        if (rec.type) typeSet[rec.type] = true;
        if ((rec._beat || 0) < artifactData.minBeat) artifactData.minBeat = rec._beat || 0;
        if ((rec._beat || 0) > artifactData.maxBeat) artifactData.maxBeat = rec._beat || 0;
        if (rec._createdAt < artifactData.minCreatedAt) artifactData.minCreatedAt = rec._createdAt;
        if (rec._createdAt > artifactData.maxCreatedAt) artifactData.maxCreatedAt = rec._createdAt;
      }
      artifactData.sourceTypes = Object.keys(typeSet);

      // Remove source records
      for (var g2 = 0; g2 < group.length; g2++) {
        db.records.delete(group[g2]._id);
        compressed++;
      }

      // Insert artifact
      this.insert(db.id, artifactData);
      artifacts++;

      // Remove compressed records from the working array
      for (var r = 0; r < group.length; r++) {
        var idx = records.indexOf(group[r]);
        if (idx > -1) records.splice(idx, 1);
      }

      // Don't advance groupStart since we spliced from eligible
      // Re-slice eligible from updated records
      eligible = [];
      for (var j = 0; j < records.length; j++) {
        var recAge = beatCount - (records[j]._beat || 0);
        if (recAge >= tier.age && records[j].type !== 'compressed-artifact') {
          eligible.push(records[j]);
        }
      }
      groupStart = 0;
    }
  }

  return { artifacts: artifacts, compressed: compressed };
};

/**
 * Create a point-in-time snapshot of a database.
 */
DatabaseEngine.prototype.snapshot = function (dbId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  if (db.snapshots.length >= MAX_SNAPSHOTS) {
    db.snapshots.shift(); // remove oldest
  }

  var snapshotId = this.generateSnapshotId();
  var recordsCopy = {};
  db.records.forEach(function (rec, id) {
    recordsCopy[id] = JSON.parse(JSON.stringify(rec));
  });

  var snap = {
    id: snapshotId,
    dbId: dbId,
    timestamp: Date.now(),
    beat: beatCount,
    recordCount: db.records.size,
    records: recordsCopy,
    version: db.version
  };

  db.snapshots.push(snap);
  db.stats.snapshotsCreated++;

  return {
    error: false,
    snapshotId: snapshotId,
    dbId: dbId,
    recordCount: snap.recordCount,
    timestamp: snap.timestamp
  };
};

/**
 * Restore a database from a snapshot.
 */
DatabaseEngine.prototype.restore = function (dbId, snapshotId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var snap = null;
  for (var i = 0; i < db.snapshots.length; i++) {
    if (db.snapshots[i].id === snapshotId) {
      snap = db.snapshots[i];
      break;
    }
  }

  if (!snap) {
    return { error: true, message: 'Snapshot not found: ' + snapshotId };
  }

  // Replace all records
  db.records.clear();
  var recordIds = Object.keys(snap.records);
  for (var j = 0; j < recordIds.length; j++) {
    db.records.set(recordIds[j], JSON.parse(JSON.stringify(snap.records[recordIds[j]])));
  }

  // Rebuild indexes
  this.rebuildAllIndexes(db);

  db.stats.lastModified = Date.now();

  return {
    error: false,
    dbId: dbId,
    snapshotId: snapshotId,
    restoredRecords: db.records.size,
    snapshotTimestamp: snap.timestamp
  };
};

/**
 * Bulk purge records matching filters.
 */
DatabaseEngine.prototype.purge = function (dbId, filters) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var filterKeys = filters ? Object.keys(filters) : [];
  var purged = 0;
  var toPurge = [];

  db.records.forEach(function (rec, id) {
    var match = true;
    for (var f = 0; f < filterKeys.length; f++) {
      if (String(rec[filterKeys[f]]) !== String(filters[filterKeys[f]])) {
        match = false;
        break;
      }
    }
    if (match) {
      toPurge.push(id);
    }
  });

  for (var i = 0; i < toPurge.length; i++) {
    db.records.delete(toPurge[i]);
    purged++;
  }

  this.rebuildAllIndexes(db);
  db.stats.deletes += purged;
  db.stats.lastModified = Date.now();
  totalDeletes += purged;

  return { error: false, dbId: dbId, purged: purged };
};

/**
 * Export a database in JSON or CSV format.
 */
DatabaseEngine.prototype.exportDb = function (dbId, format) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  format = format || 'json';
  var records = [];
  db.records.forEach(function (rec) {
    if (!rec._tombstone) {
      records.push(rec);
    }
  });

  if (format === 'csv') {
    if (records.length === 0) {
      return { error: false, dbId: dbId, format: 'csv', data: '', recordCount: 0 };
    }
    var allKeys = {};
    for (var i = 0; i < records.length; i++) {
      var recKeys = Object.keys(records[i]);
      for (var k = 0; k < recKeys.length; k++) {
        allKeys[recKeys[k]] = true;
      }
    }
    var headers = Object.keys(allKeys);
    var lines = [headers.join(',')];
    for (var j = 0; j < records.length; j++) {
      var row = [];
      for (var h = 0; h < headers.length; h++) {
        var val = records[j][headers[h]];
        if (val === undefined) val = '';
        row.push(String(val).replace(/,/g, ';'));
      }
      lines.push(row.join(','));
    }
    return { error: false, dbId: dbId, format: 'csv', data: lines.join('\n'), recordCount: records.length };
  }

  return {
    error: false,
    dbId: dbId,
    format: 'json',
    data: JSON.stringify(records),
    recordCount: records.length
  };
};

/**
 * Apply a schema migration to a database.
 * Migration: { version, description, addFields: {}, removeFields: [], renameFields: {} }
 */
DatabaseEngine.prototype.migrate = function (dbId, migration) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  if (!migration || !migration.version) {
    return { error: true, message: 'Migration must have a version' };
  }

  if (migration.version <= db.version) {
    return { error: true, message: 'Migration version must be greater than current: ' + db.version };
  }

  var affected = 0;
  var addFields = migration.addFields || {};
  var removeFields = migration.removeFields || [];
  var renameFields = migration.renameFields || {};
  var addKeys = Object.keys(addFields);
  var renameKeys = Object.keys(renameFields);

  db.records.forEach(function (rec) {
    // Add new fields with defaults
    for (var a = 0; a < addKeys.length; a++) {
      if (rec[addKeys[a]] === undefined) {
        rec[addKeys[a]] = addFields[addKeys[a]];
      }
    }
    // Remove fields
    for (var r = 0; r < removeFields.length; r++) {
      delete rec[removeFields[r]];
    }
    // Rename fields
    for (var n = 0; n < renameKeys.length; n++) {
      var oldName = renameKeys[n];
      var newName = renameFields[oldName];
      if (rec[oldName] !== undefined) {
        rec[newName] = rec[oldName];
        delete rec[oldName];
      }
    }
    rec._version++;
    rec._updatedAt = Date.now();
    rec._hash = computeRecordHash(rec);
    affected++;
  });

  db.version = migration.version;
  db.migrations.push({
    version: migration.version,
    description: migration.description || '',
    appliedAt: Date.now(),
    affected: affected
  });

  // Add new index fields if needed
  if (migration.addIndexes) {
    for (var idx = 0; idx < migration.addIndexes.length; idx++) {
      var field = migration.addIndexes[idx];
      if (!db.indexes.has(field)) {
        db.indexes.set(field, new Map());
        db.indexFields.push(field);
      }
    }
  }

  this.rebuildAllIndexes(db);

  return {
    error: false,
    dbId: dbId,
    version: db.version,
    affected: affected,
    migrationsApplied: db.migrations.length
  };
};

/**
 * Get statistics for a database.
 */
DatabaseEngine.prototype.getStats = function (dbId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var liveCount = 0;
  var tombstoneCount = 0;
  var artifactCount = 0;
  db.records.forEach(function (rec) {
    if (rec._tombstone) {
      tombstoneCount++;
    } else if (rec.type === 'compressed-artifact') {
      artifactCount++;
    } else {
      liveCount++;
    }
  });

  var indexCount = 0;
  db.indexes.forEach(function (idx) {
    indexCount += idx.size;
  });

  return {
    error: false,
    dbId: dbId,
    name: db.name,
    totalRecords: db.records.size,
    liveRecords: liveCount,
    tombstones: tombstoneCount,
    artifacts: artifactCount,
    capacity: db.maxRecords,
    utilizationPct: Math.round((db.records.size / db.maxRecords) * 10000) / 100,
    indexEntries: indexCount,
    indexFields: db.indexFields,
    snapshotCount: db.snapshots.length,
    version: db.version,
    retentionPolicy: db.retentionPolicy,
    stats: db.stats
  };
};

/**
 * Cross-database query — search across all databases.
 */
DatabaseEngine.prototype.queryAcross = function (query) {
  var self = this;
  var results = [];
  var searched = 0;
  var filters = query.filters || {};
  var limit = query.limit || 50;
  var targetDbs = query.databases || null;

  this.databases.forEach(function (db, dbId) {
    if (targetDbs && targetDbs.indexOf(dbId) === -1) return;
    searched++;

    var queryResult = self.query(dbId, filters, { limit: limit, sort: query.sort });
    if (!queryResult.error) {
      for (var i = 0; i < queryResult.records.length; i++) {
        results.push(queryResult.records[i]);
      }
    }
  });

  // Sort combined results
  var sortField = query.sort || '_createdAt';
  results.sort(function (a, b) {
    var va = a[sortField] || 0;
    var vb = b[sortField] || 0;
    return vb > va ? 1 : vb < va ? -1 : 0;
  });

  if (results.length > limit) {
    results = results.slice(0, limit);
  }

  totalQueries++;

  return {
    error: false,
    results: results,
    total: results.length,
    databasesSearched: searched,
    limit: limit
  };
};

/**
 * Return index metadata for a database.
 */
DatabaseEngine.prototype.queryIndexes = function (dbId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var indexInfo = [];
  db.indexes.forEach(function (indexMap, field) {
    indexInfo.push({
      field: field,
      uniqueValues: indexMap.size,
      totalEntries: 0
    });
    indexMap.forEach(function (ids) {
      indexInfo[indexInfo.length - 1].totalEntries += ids.size;
    });
  });

  return {
    error: false,
    dbId: dbId,
    indexes: indexInfo,
    totalIndexes: indexInfo.length,
    maxIndexes: MAX_INDEXES
  };
};

/**
 * Verify hash integrity of all records in a database.
 */
DatabaseEngine.prototype.checkIntegrity = function (dbId) {
  var db = this.databases.get(dbId);
  if (!db) {
    return { error: true, message: 'Database not found: ' + dbId };
  }

  var passed = 0;
  var failed = 0;
  var failures = [];

  db.records.forEach(function (rec, id) {
    var expectedHash = computeRecordHash(rec);
    if (rec._hash === expectedHash) {
      passed++;
    } else {
      failed++;
      if (failures.length < 20) {
        failures.push({
          id: id,
          expected: expectedHash,
          actual: rec._hash
        });
      }
    }
  });

  db.stats.lastIntegrityCheck = Date.now();
  db.stats.integrityPassed += passed;
  db.stats.integrityFailed += failed;
  totalIntegrityChecks++;

  return {
    error: false,
    dbId: dbId,
    passed: passed,
    failed: failed,
    totalChecked: passed + failed,
    failures: failures,
    healthy: failed === 0
  };
};

/**
 * Cross-database consistency verification.
 * Checks referential integrity, index consistency, and record counts.
 */
DatabaseEngine.prototype.checkConsistency = function () {
  var self = this;
  var results = [];
  var totalPassed = 0;
  var totalFailed = 0;

  this.databases.forEach(function (db, dbId) {
    var checks = { dbId: dbId, name: db.name, issues: [] };

    // Check 1: Record count within bounds
    if (db.records.size > db.maxRecords) {
      checks.issues.push({
        check: 'capacity',
        message: 'Over capacity: ' + db.records.size + ' > ' + db.maxRecords
      });
    }

    // Check 2: Index consistency — every indexed record should exist
    db.indexes.forEach(function (indexMap, field) {
      indexMap.forEach(function (ids, value) {
        ids.forEach(function (recId) {
          if (!db.records.has(recId)) {
            checks.issues.push({
              check: 'index-orphan',
              field: field,
              value: value,
              recordId: recId
            });
          }
        });
      });
    });

    // Check 3: Hash validity — sample check (every PHI_INV fraction)
    var sampleSize = Math.max(1, Math.floor(db.records.size * PHI_INV));
    var checked = 0;
    db.records.forEach(function (rec) {
      if (checked >= sampleSize) return;
      var expected = computeRecordHash(rec);
      if (rec._hash !== expected) {
        checks.issues.push({
          check: 'hash-mismatch',
          recordId: rec._id,
          expected: expected,
          actual: rec._hash
        });
      }
      checked++;
    });

    // Check 4: Snapshot sanity
    if (db.snapshots.length > MAX_SNAPSHOTS) {
      checks.issues.push({
        check: 'snapshot-overflow',
        count: db.snapshots.length,
        max: MAX_SNAPSHOTS
      });
    }

    if (checks.issues.length === 0) {
      totalPassed++;
    } else {
      totalFailed++;
    }

    results.push(checks);
  });

  totalConsistencyChecks++;

  return {
    error: false,
    databasesChecked: results.length,
    passed: totalPassed,
    failed: totalFailed,
    healthy: totalFailed === 0,
    results: results
  };
};

/**
 * Get total record count across all databases.
 */
DatabaseEngine.prototype.getTotalRecordCount = function () {
  var total = 0;
  this.databases.forEach(function (db) {
    total += db.records.size;
  });
  return total;
};

// ════════════════════════════════════════════════════════════════════════
//  INDEX MANAGEMENT
// ════════════════════════════════════════════════════════════════════════

/**
 * Add index entries for a single record.
 */
DatabaseEngine.prototype.rebuildIndexesForRecord = function (db, record) {
  for (var i = 0; i < db.indexFields.length; i++) {
    var field = db.indexFields[i];
    var value = record[field];
    if (value !== undefined) {
      var indexMap = db.indexes.get(field);
      if (indexMap) {
        var key = String(value);
        if (!indexMap.has(key)) {
          indexMap.set(key, new Set());
        }
        indexMap.get(key).add(record._id);
      }
    }
  }
};

/**
 * Remove index entries for a single record.
 */
DatabaseEngine.prototype.removeIndexesForRecord = function (db, record) {
  for (var i = 0; i < db.indexFields.length; i++) {
    var field = db.indexFields[i];
    var value = record[field];
    if (value !== undefined) {
      var indexMap = db.indexes.get(field);
      if (indexMap) {
        var key = String(value);
        var set = indexMap.get(key);
        if (set) {
          set.delete(record._id);
          if (set.size === 0) {
            indexMap.delete(key);
          }
        }
      }
    }
  }
};

/**
 * Rebuild all indexes for a database from scratch.
 */
DatabaseEngine.prototype.rebuildAllIndexes = function (db) {
  // Clear all indexes
  db.indexes.forEach(function (indexMap) {
    indexMap.clear();
  });

  // Rebuild from all records
  var self = this;
  db.records.forEach(function (record) {
    self.rebuildIndexesForRecord(db, record);
  });
};

// ════════════════════════════════════════════════════════════════════════
//  INSTANTIATE DATABASE ENGINE
// ════════════════════════════════════════════════════════════════════════

var engine = new DatabaseEngine();
engine.initAll();

// ════════════════════════════════════════════════════════════════════════
//  AUDIT LOGGER — All operations logged to DB-009
// ════════════════════════════════════════════════════════════════════════

function auditLog(operation, dbId, details) {
  var auditDbId = 'DB-009';
  var auditDb = engine.databases.get(auditDbId);
  if (!auditDb) return;

  // Guard against audit overflow
  if (auditDb.records.size >= MAX_AUDIT) {
    // Purge oldest 10% to make room
    var toPurge = Math.floor(MAX_AUDIT * 0.1);
    var oldest = [];
    auditDb.records.forEach(function (rec, id) {
      oldest.push({ id: id, ts: rec._createdAt || 0 });
    });
    oldest.sort(function (a, b) { return a.ts - b.ts; });
    for (var i = 0; i < Math.min(toPurge, oldest.length); i++) {
      auditDb.records.delete(oldest[i].id);
    }
  }

  engine.insert(auditDbId, {
    type: 'operation-audit',
    operation: operation,
    dbId: dbId || 'system',
    details: details || {},
    beat: beatCount,
    timestamp: Date.now(),
    severity: 'info'
  });
}

// ════════════════════════════════════════════════════════════════════════
//  AGI GOVERNANCE ENGINE — Autonomous Database Management
// ════════════════════════════════════════════════════════════════════════

/**
 * AGI Index Rebuild — runs every F9 (34) beats.
 * Rebuilds all indexes across all databases to ensure consistency.
 */
function agiIndexRebuild() {
  var results = [];
  engine.databases.forEach(function (db, dbId) {
    var beforeCount = 0;
    db.indexes.forEach(function (idx) { beforeCount += idx.size; });

    engine.rebuildAllIndexes(db);

    var afterCount = 0;
    db.indexes.forEach(function (idx) { afterCount += idx.size; });

    results.push({
      dbId: dbId,
      name: db.name,
      indexesBefore: beforeCount,
      indexesAfter: afterCount,
      recordCount: db.records.size
    });
  });

  self.postMessage({
    type: 'agi-governance',
    action: 'index-rebuild',
    beat: beatCount,
    timestamp: Date.now(),
    stats: {
      databasesProcessed: results.length,
      results: results
    }
  });

  auditLog('agi-index-rebuild', null, {
    databasesProcessed: results.length,
    beat: beatCount
  });
}

/**
 * AGI Compaction — runs every F11 (89) beats.
 * Compacts all databases: removes tombstones, Fibonacci-compresses old records.
 */
function agiCompaction() {
  var results = [];
  var totalRemoved = 0;
  var totalArtifacts = 0;

  engine.databases.forEach(function (db, dbId) {
    // Skip immutable databases
    if (db.retentionPolicy === 'immutable') return;

    var result = engine.compact(dbId);
    if (!result.error) {
      totalRemoved += result.removedTombstones;
      totalArtifacts += result.artifactsCreated;
      results.push({
        dbId: dbId,
        name: db.name,
        removedTombstones: result.removedTombstones,
        artifactsCreated: result.artifactsCreated,
        compressedRecords: result.compressedRecords,
        remainingRecords: result.remainingRecords
      });
    }
  });

  self.postMessage({
    type: 'agi-governance',
    action: 'compaction',
    beat: beatCount,
    timestamp: Date.now(),
    removed: totalRemoved,
    artifacts: totalArtifacts,
    stats: {
      databasesProcessed: results.length,
      results: results
    }
  });

  auditLog('agi-compaction', null, {
    totalRemoved: totalRemoved,
    totalArtifacts: totalArtifacts,
    beat: beatCount
  });
}

/**
 * AGI Integrity Check — runs every F12 (144) beats.
 * Verifies hash integrity of all records in all databases.
 */
function agiIntegrityCheck() {
  var results = [];
  var totalPassed = 0;
  var totalFailed = 0;

  engine.databases.forEach(function (db, dbId) {
    var result = engine.checkIntegrity(dbId);
    if (!result.error) {
      totalPassed += result.passed;
      totalFailed += result.failed;
      results.push({
        dbId: dbId,
        name: db.name,
        passed: result.passed,
        failed: result.failed,
        healthy: result.healthy
      });
    }
  });

  self.postMessage({
    type: 'agi-governance',
    action: 'integrity-check',
    beat: beatCount,
    timestamp: Date.now(),
    passed: totalPassed,
    failed: totalFailed,
    stats: {
      databasesChecked: results.length,
      allHealthy: totalFailed === 0,
      results: results
    }
  });

  auditLog('agi-integrity-check', null, {
    totalPassed: totalPassed,
    totalFailed: totalFailed,
    beat: beatCount
  });
}

/**
 * AGI Consistency Check — runs every F13 (233) beats.
 * Cross-database consistency verification.
 */
function agiConsistencyCheck() {
  var result = engine.checkConsistency();

  self.postMessage({
    type: 'agi-governance',
    action: 'consistency-check',
    beat: beatCount,
    timestamp: Date.now(),
    results: {
      databasesChecked: result.databasesChecked,
      passed: result.passed,
      failed: result.failed,
      healthy: result.healthy,
      details: result.results
    }
  });

  auditLog('agi-consistency-check', null, {
    passed: result.passed,
    failed: result.failed,
    healthy: result.healthy,
    beat: beatCount
  });
}

/**
 * Run all AGI governance actions that are due at the current beat.
 */
function runAgiGovernance() {
  if (beatCount > 0 && beatCount % AGI_INDEX_INTERVAL === 0) {
    agiIndexRebuild();
  }

  if (beatCount > 0 && beatCount % AGI_COMPACT_INTERVAL === 0) {
    agiCompaction();
  }

  if (beatCount > 0 && beatCount % AGI_INTEGRITY_INTERVAL === 0) {
    agiIntegrityCheck();
  }

  if (beatCount > 0 && beatCount % AGI_CONSISTENCY_INTERVAL === 0) {
    agiConsistencyCheck();
  }
}

// ════════════════════════════════════════════════════════════════════════
//  AUTO-REGISTRATION ENGINE — Seed initial data on startup
// ════════════════════════════════════════════════════════════════════════

/**
 * Seed all 13 database definitions into DB-002 (TOOL_REGISTRY)
 * so the organism knows what databases exist.
 */
function seedToolRegistry() {
  for (var i = 0; i < DATABASE_DEFS.length; i++) {
    var def = DATABASE_DEFS[i];
    engine.insert('DB-002', {
      type: 'tool-definition',
      toolId: def.id,
      name: def.name,
      description: def.description,
      category: 'database',
      recordTypes: def.recordTypes,
      indexes: def.indexes,
      retentionPolicy: def.retentionPolicy,
      maxRecords: def.maxRecords,
      version: '1.0.0',
      status: 'active',
      registeredAt: Date.now(),
      registeredBy: 'database-worker'
    });
  }
}

/**
 * Seed initial configuration into DB-012 (CONFIG_VAULT).
 */
function seedConfigVault() {
  var configs = [
    {
      type: 'system-config',
      key: 'database.heartbeat',
      value: HEARTBEAT,
      category: 'timing',
      environment: 'all',
      description: 'Database worker heartbeat interval in ms',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.maxRecordsPerDb',
      value: MAX_RECORDS_PER_DB,
      category: 'capacity',
      environment: 'all',
      description: 'Maximum records per database (F19)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.maxTotalRecords',
      value: MAX_TOTAL_RECORDS,
      category: 'capacity',
      environment: 'all',
      description: 'Maximum total records across all databases (F22)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.agiIndexInterval',
      value: AGI_INDEX_INTERVAL,
      category: 'governance',
      environment: 'all',
      description: 'Auto-index rebuild interval in beats (F9)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.agiCompactInterval',
      value: AGI_COMPACT_INTERVAL,
      category: 'governance',
      environment: 'all',
      description: 'Auto-compaction interval in beats (F11)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.agiIntegrityInterval',
      value: AGI_INTEGRITY_INTERVAL,
      category: 'governance',
      environment: 'all',
      description: 'Integrity check interval in beats (F12)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.agiConsistencyInterval',
      value: AGI_CONSISTENCY_INTERVAL,
      category: 'governance',
      environment: 'all',
      description: 'Consistency check interval in beats (F13)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.phi',
      value: PHI,
      category: 'constants',
      environment: 'all',
      description: 'Golden ratio constant',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.maxSnapshots',
      value: MAX_SNAPSHOTS,
      category: 'capacity',
      environment: 'all',
      description: 'Maximum snapshots per database (F11)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.maxIndexes',
      value: MAX_INDEXES,
      category: 'capacity',
      environment: 'all',
      description: 'Maximum index entries (F15)',
      status: 'active'
    },
    {
      type: 'system-config',
      key: 'database.maxAudit',
      value: MAX_AUDIT,
      category: 'capacity',
      environment: 'all',
      description: 'Maximum audit records (F18)',
      status: 'active'
    },
    {
      type: 'feature-flag',
      key: 'database.fibonacciCompression',
      value: true,
      category: 'features',
      environment: 'all',
      description: 'Enable Fibonacci compression on compaction',
      status: 'active'
    },
    {
      type: 'feature-flag',
      key: 'database.agiGovernance',
      value: true,
      category: 'features',
      environment: 'all',
      description: 'Enable AGI autonomous governance',
      status: 'active'
    }
  ];

  for (var i = 0; i < configs.length; i++) {
    engine.insert('DB-012', configs[i]);
  }
}

/**
 * Create genesis ANIMA chain block in DB-007 (ANIMA_CHAIN).
 */
function seedAnimaGenesis() {
  var genesisHash = fnv1a('ORGANISM-GENESIS-DATABASE-WORKER-' + Date.now());

  engine.insert('DB-007', {
    type: 'genesis-reference',
    blockHeight: 0,
    hash: genesisHash,
    previousHash: 0,
    payload: 'Database Worker Genesis Block',
    worker: 'database-worker',
    timestamp: Date.now(),
    nonce: Math.floor(Math.random() * 4294967296),
    verified: true
  });

  engine.insert('DB-007', {
    type: 'chain-block',
    blockHeight: 1,
    hash: fnv1a('BLOCK-1-' + genesisHash),
    previousHash: genesisHash,
    payload: 'Database engine initialized with 13 sovereign databases',
    worker: 'database-worker',
    timestamp: Date.now(),
    nonce: Math.floor(Math.random() * 4294967296),
    verified: true
  });
}

/**
 * Seed initial knowledge graph entities into DB-010 (KNOWLEDGE_GRAPH).
 * These represent the core organism concepts that the graph is built from.
 */
function seedKnowledgeGraph() {
  var entities = [
    { entityId: 'ENTITY-001', entityType: 'concept', name: 'Organism', description: 'The living AGI organism', relationship: 'root', source: 'genesis', target: 'all' },
    { entityId: 'ENTITY-002', entityType: 'concept', name: 'PHI', description: 'Golden ratio governing all proportions', relationship: 'governs', source: 'mathematics', target: 'organism' },
    { entityId: 'ENTITY-003', entityType: 'concept', name: 'Fibonacci', description: 'Fibonacci sequence bounding all capacities', relationship: 'bounds', source: 'mathematics', target: 'capacity' },
    { entityId: 'ENTITY-004', entityType: 'component', name: 'DatabaseEngine', description: 'Core in-memory sovereign database engine', relationship: 'contains', source: 'organism', target: 'databases' },
    { entityId: 'ENTITY-005', entityType: 'component', name: 'AGIGovernance', description: 'Autonomous governance engine', relationship: 'manages', source: 'organism', target: 'databases' },
    { entityId: 'ENTITY-006', entityType: 'component', name: 'AnimaChain', description: 'Hash chain proof of life', relationship: 'proves', source: 'organism', target: 'liveness' },
    { entityId: 'ENTITY-007', entityType: 'component', name: 'FibonacciCompression', description: 'Logarithmic compression following Fibonacci ratios', relationship: 'compresses', source: 'governance', target: 'records' },
    { entityId: 'ENTITY-008', entityType: 'concept', name: 'Heartbeat', description: '873ms pulse driving all organism activity', relationship: 'drives', source: 'timing', target: 'organism' },
    { entityId: 'ENTITY-009', entityType: 'component', name: 'IndexEngine', description: 'Auto-indexing system for all databases', relationship: 'indexes', source: 'governance', target: 'records' },
    { entityId: 'ENTITY-010', entityType: 'concept', name: 'Sovereignty', description: 'Each database is sovereign — self-managed', relationship: 'defines', source: 'architecture', target: 'databases' },
    { entityId: 'ENTITY-011', entityType: 'component', name: 'AuditTrail', description: 'Immutable audit log for all operations', relationship: 'audits', source: 'compliance', target: 'operations' },
    { entityId: 'ENTITY-012', entityType: 'component', name: 'SnapshotEngine', description: 'Point-in-time snapshot and restore', relationship: 'preserves', source: 'resilience', target: 'databases' },
    { entityId: 'ENTITY-013', entityType: 'concept', name: 'MedinaDoctrineDB', description: 'Database layer of the Medina Doctrine framework', relationship: 'implements', source: 'doctrine', target: 'databases' }
  ];

  for (var i = 0; i < entities.length; i++) {
    engine.insert('DB-010', Object.assign({ type: 'entity-node' }, entities[i]));
  }

  // Seed relationships between entities
  var relationships = [
    { source: 'ENTITY-001', target: 'ENTITY-004', relationship: 'contains', weight: PHI },
    { source: 'ENTITY-001', target: 'ENTITY-005', relationship: 'contains', weight: PHI },
    { source: 'ENTITY-002', target: 'ENTITY-003', relationship: 'derives', weight: PHI_INV },
    { source: 'ENTITY-004', target: 'ENTITY-009', relationship: 'uses', weight: PHI_INV },
    { source: 'ENTITY-005', target: 'ENTITY-007', relationship: 'uses', weight: PHI_INV },
    { source: 'ENTITY-005', target: 'ENTITY-009', relationship: 'manages', weight: PHI },
    { source: 'ENTITY-006', target: 'ENTITY-008', relationship: 'extends-via', weight: 1.0 },
    { source: 'ENTITY-001', target: 'ENTITY-010', relationship: 'exemplifies', weight: PHI },
    { source: 'ENTITY-011', target: 'ENTITY-004', relationship: 'monitors', weight: PHI_INV },
    { source: 'ENTITY-012', target: 'ENTITY-004', relationship: 'protects', weight: PHI_INV },
    { source: 'ENTITY-013', target: 'ENTITY-001', relationship: 'governs', weight: PHI }
  ];

  for (var j = 0; j < relationships.length; j++) {
    engine.insert('DB-010', Object.assign({ type: 'relationship' }, relationships[j]));
  }
}

/**
 * Seed initial agent profiles into DB-006 (AGENT_PROFILES).
 * Seeds the core VOIS agent archetypes that populate the fleet.
 */
function seedAgentProfiles() {
  var archetypes = [
    { agentId: 'VOIS-ARCH-001', name: 'PulseKeeper', role: 'infrastructure', capability: 'heartbeat-maintenance', status: 'active' },
    { agentId: 'VOIS-ARCH-002', name: 'SyncWeaver', role: 'infrastructure', capability: 'cross-worker-sync', status: 'active' },
    { agentId: 'VOIS-ARCH-003', name: 'FlowMonitor', role: 'observability', capability: 'signal-flow-observation', status: 'active' },
    { agentId: 'VOIS-ARCH-004', name: 'StateGuardian', role: 'governance', capability: 'state-consistency', status: 'active' },
    { agentId: 'VOIS-ARCH-005', name: 'InferEngine', role: 'intelligence', capability: 'core-inference', status: 'active' },
    { agentId: 'VOIS-ARCH-006', name: 'PatternSeeker', role: 'intelligence', capability: 'pattern-recognition', status: 'active' },
    { agentId: 'VOIS-ARCH-007', name: 'SentinelWatch', role: 'defense', capability: 'watchdog', status: 'active' },
    { agentId: 'VOIS-ARCH-008', name: 'IntegrityChecker', role: 'defense', capability: 'hash-verification', status: 'active' },
    { agentId: 'VOIS-ARCH-009', name: 'ResourceBalancer', role: 'infrastructure', capability: 'load-distribution', status: 'active' },
    { agentId: 'VOIS-ARCH-010', name: 'CacheOptimizer', role: 'infrastructure', capability: 'cache-strategy', status: 'active' },
    { agentId: 'VOIS-ARCH-011', name: 'AnomalyDetector', role: 'defense', capability: 'drift-detection', status: 'active' },
    { agentId: 'VOIS-ARCH-012', name: 'MemoryConsolidator', role: 'intelligence', capability: 'memory-consolidation', status: 'active' },
    { agentId: 'VOIS-ARCH-013', name: 'DatabaseGovernor', role: 'governance', capability: 'database-governance', status: 'active' }
  ];

  for (var i = 0; i < archetypes.length; i++) {
    engine.insert('DB-006', Object.assign({
      type: 'agent-profile',
      registeredAt: Date.now(),
      registeredBy: 'database-worker',
      version: '1.0.0'
    }, archetypes[i]));
  }
}

/**
 * Seed initial client record template into DB-005 (CLIENT_RECORDS).
 */
function seedClientTemplate() {
  engine.insert('DB-005', {
    type: 'client-config',
    clientId: 'TEMPLATE-001',
    name: 'Default Client Template',
    tier: 'standard',
    status: 'template',
    healthScore: 1.0,
    quotas: {
      maxRequests: 10000,
      maxStorage: 104857600,
      maxAgents: 10
    },
    slaTarget: 0.999,
    createdAt: Date.now()
  });
}

/**
 * Seed initial protocol references into DB-003 (PROTOCOL_REGISTRY).
 */
function seedProtocolRegistry() {
  var protocols = [
    { protocolId: 'PROTOCOL-001', name: 'clientOnboard', category: 'client-lifecycle', version: '1.0.0', status: 'active', description: 'Full client provisioning flow' },
    { protocolId: 'PROTOCOL-006', name: 'aiRequestPipeline', category: 'ai-pipeline', version: '1.0.0', status: 'active', description: 'Full AI request lifecycle' },
    { protocolId: 'PROTOCOL-011', name: 'dataIngestPipeline', category: 'data-governance', version: '1.0.0', status: 'active', description: 'Validate, sanitize, classify, store, index' },
    { protocolId: 'PROTOCOL-016', name: 'zeroTrustGate', category: 'security', version: '1.0.0', status: 'active', description: 'Every request authenticated and authorized' },
    { protocolId: 'PROTOCOL-018', name: 'auditTrail', category: 'security', version: '1.0.0', status: 'active', description: 'Immutable audit log for all operations' },
    { protocolId: 'PROTOCOL-021', name: 'autoScaling', category: 'platform-ops', version: '1.0.0', status: 'active', description: 'Sensor-driven capacity scaling' },
    { protocolId: 'PROTOCOL-026', name: 'organismBootstrap', category: 'organism', version: '1.0.0', status: 'active', description: 'Full organism startup sequence' }
  ];

  for (var i = 0; i < protocols.length; i++) {
    engine.insert('DB-003', Object.assign({ type: 'protocol-definition', registeredAt: Date.now() }, protocols[i]));
  }
}

/**
 * Seed shadow mirror configuration into DB-013 (SHADOW_MIRROR).
 */
function seedShadowMirror() {
  // Register which databases have shadow mirrors
  var mirrorableDbs = ['DB-002', 'DB-003', 'DB-005', 'DB-008', 'DB-011'];
  for (var i = 0; i < mirrorableDbs.length; i++) {
    engine.insert('DB-013', {
      type: 'mirror-sync',
      sourceDb: mirrorableDbs[i],
      mirrorType: 'anonymized',
      status: 'configured',
      lastSync: null,
      syncInterval: fib(10) * HEARTBEAT, // F10 * 873ms
      redactionRules: ['pii', 'secrets', 'internal-ids'],
      timestamp: Date.now()
    });
  }
}

// Run auto-registration on startup
seedToolRegistry();
seedConfigVault();
seedAnimaGenesis();
seedKnowledgeGraph();
seedAgentProfiles();
seedClientTemplate();
seedProtocolRegistry();
seedShadowMirror();

auditLog('startup', null, {
  databases: DATABASE_DEFS.length,
  engine: 'DatabaseEngine',
  timestamp: Date.now()
});

// ════════════════════════════════════════════════════════════════════════
//  CAPACITY & STATE HELPERS
// ════════════════════════════════════════════════════════════════════════

/**
 * Get capacity information across all databases.
 */
function getCapacity() {
  var dbCapacities = [];
  var totalRecords = 0;
  var totalTombstones = 0;
  var totalArtifacts = 0;

  engine.databases.forEach(function (db, dbId) {
    var live = 0;
    var tombstones = 0;
    var artifacts = 0;
    db.records.forEach(function (rec) {
      if (rec._tombstone) {
        tombstones++;
      } else if (rec.type === 'compressed-artifact') {
        artifacts++;
      } else {
        live++;
      }
    });

    totalRecords += db.records.size;
    totalTombstones += tombstones;
    totalArtifacts += artifacts;

    dbCapacities.push({
      dbId: dbId,
      name: db.name,
      records: db.records.size,
      live: live,
      tombstones: tombstones,
      artifacts: artifacts,
      capacity: db.maxRecords,
      utilizationPct: Math.round((db.records.size / db.maxRecords) * 10000) / 100
    });
  });

  return {
    totalRecords: totalRecords,
    maxTotalRecords: MAX_TOTAL_RECORDS,
    totalUtilizationPct: Math.round((totalRecords / MAX_TOTAL_RECORDS) * 10000) / 100,
    totalTombstones: totalTombstones,
    totalArtifacts: totalArtifacts,
    databases: dbCapacities
  };
}

/**
 * Get the full worker state.
 */
function getWorkerState() {
  var dbStates = [];
  engine.databases.forEach(function (db, dbId) {
    dbStates.push({
      id: dbId,
      name: db.name,
      records: db.records.size,
      snapshots: db.snapshots.length,
      version: db.version,
      retentionPolicy: db.retentionPolicy,
      stats: {
        inserts: db.stats.inserts,
        updates: db.stats.updates,
        deletes: db.stats.deletes,
        queries: db.stats.queries,
        compactions: db.stats.compactions
      }
    });
  });

  return {
    beat: beatCount,
    running: running,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    uptime: Date.now() - engine.createdAt,
    databases: dbStates,
    totals: {
      inserts: totalInserts,
      updates: totalUpdates,
      deletes: totalDeletes,
      queries: totalQueries,
      compactions: totalCompactions,
      artifacts: totalArtifactsCreated,
      integrityChecks: totalIntegrityChecks,
      consistencyChecks: totalConsistencyChecks
    },
    capacity: getCapacity(),
    governance: {
      indexInterval: AGI_INDEX_INTERVAL,
      compactInterval: AGI_COMPACT_INTERVAL,
      integrityInterval: AGI_INTEGRITY_INTERVAL,
      consistencyInterval: AGI_CONSISTENCY_INTERVAL,
      nextIndex: AGI_INDEX_INTERVAL - (beatCount % AGI_INDEX_INTERVAL),
      nextCompact: AGI_COMPACT_INTERVAL - (beatCount % AGI_COMPACT_INTERVAL),
      nextIntegrity: AGI_INTEGRITY_INTERVAL - (beatCount % AGI_INTEGRITY_INTERVAL),
      nextConsistency: AGI_CONSISTENCY_INTERVAL - (beatCount % AGI_CONSISTENCY_INTERVAL)
    }
  };
}

// ════════════════════════════════════════════════════════════════════════
//  QUERY HELPERS — Research corpus and audit trail
// ════════════════════════════════════════════════════════════════════════

/**
 * Query the research corpus (DB-011) with text search.
 */
function queryResearchCorpus(query) {
  var db = engine.databases.get('DB-011');
  if (!db) {
    return { error: true, message: 'Research corpus not found' };
  }

  var searchText = (query.text || '').toLowerCase();
  var category = query.category || null;
  var limit = query.limit || 50;
  var results = [];

  db.records.forEach(function (rec) {
    if (rec._tombstone) return;

    var match = false;

    // Text search across title, author, description fields
    if (searchText) {
      var searchable = [
        rec.title || '',
        rec.author || '',
        rec.description || '',
        rec.category || '',
        rec.type || ''
      ].join(' ').toLowerCase();

      if (searchable.indexOf(searchText) > -1) {
        match = true;
      }
    } else {
      match = true;
    }

    // Category filter
    if (match && category && rec.category !== category) {
      match = false;
    }

    if (match) {
      results.push(rec);
    }
  });

  results.sort(function (a, b) {
    return (b._createdAt || 0) - (a._createdAt || 0);
  });

  if (results.length > limit) {
    results = results.slice(0, limit);
  }

  totalQueries++;

  return {
    error: false,
    results: results,
    total: results.length,
    searchText: searchText,
    category: category
  };
}

/**
 * Query the audit trail (DB-009) with filters.
 */
function queryAuditTrail(count, filters) {
  count = count || 100;
  var db = engine.databases.get('DB-009');
  if (!db) {
    return { error: true, message: 'Audit log not found' };
  }

  var filterKeys = filters ? Object.keys(filters) : [];
  var results = [];

  db.records.forEach(function (rec) {
    if (rec._tombstone) return;

    var match = true;
    for (var f = 0; f < filterKeys.length; f++) {
      if (String(rec[filterKeys[f]]) !== String(filters[filterKeys[f]])) {
        match = false;
        break;
      }
    }

    if (match) {
      results.push(rec);
    }
  });

  results.sort(function (a, b) {
    return (b._createdAt || 0) - (a._createdAt || 0);
  });

  if (results.length > count) {
    results = results.slice(0, count);
  }

  totalQueries++;

  return {
    error: false,
    results: results,
    total: results.length,
    maxCount: count
  };
}

// ════════════════════════════════════════════════════════════════════════
//  MESSAGE HANDLER — postMessage Protocol
// ════════════════════════════════════════════════════════════════════════

self.onmessage = function (e) {
  var msg = e.data;

  switch (msg.type) {

    // ──────────────────────────────────────────────────────────────────
    //  QUERY API — 10 Read Operations
    // ──────────────────────────────────────────────────────────────────

    case 'queryDatabase': {
      var dbId = msg.dbId;
      var db = engine.databases.get(dbId);
      if (!db) {
        self.postMessage({ type: 'error', message: 'Database not found: ' + dbId });
        break;
      }
      var stats = engine.getStats(dbId);
      self.postMessage({
        type: 'database-info',
        dbId: dbId,
        name: db.name,
        description: db.description,
        recordTypes: db.recordTypes,
        indexFields: db.indexFields,
        retentionPolicy: db.retentionPolicy,
        stats: stats
      });
      auditLog('queryDatabase', dbId, {});
      break;
    }

    case 'queryRecord': {
      var result = engine.get(msg.dbId, msg.recordId);
      if (result.error) {
        self.postMessage({ type: 'error', message: result.message, dbId: msg.dbId, recordId: msg.recordId });
      } else {
        self.postMessage({ type: 'record', dbId: msg.dbId, record: result.record });
      }
      auditLog('queryRecord', msg.dbId, { recordId: msg.recordId });
      break;
    }

    case 'queryRecords': {
      var queryResult = engine.query(msg.dbId, msg.filters || {}, msg.options || {});
      if (queryResult.error) {
        self.postMessage({ type: 'error', message: queryResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({
          type: 'records',
          dbId: msg.dbId,
          records: queryResult.records,
          total: queryResult.total,
          limit: queryResult.limit,
          offset: queryResult.offset,
          hasMore: queryResult.hasMore
        });
      }
      auditLog('queryRecords', msg.dbId, { filters: msg.filters });
      break;
    }

    case 'queryAcrossDatabases': {
      var crossResult = engine.queryAcross(msg.query || {});
      self.postMessage({
        type: 'cross-query-result',
        results: crossResult.results,
        total: crossResult.total,
        databasesSearched: crossResult.databasesSearched
      });
      auditLog('queryAcrossDatabases', null, { query: msg.query });
      break;
    }

    case 'queryStats': {
      var statsResult = engine.getStats(msg.dbId);
      if (statsResult.error) {
        self.postMessage({ type: 'error', message: statsResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'db-stats', ...statsResult });
      }
      break;
    }

    case 'queryIndexes': {
      var indexResult = engine.queryIndexes(msg.dbId);
      if (indexResult.error) {
        self.postMessage({ type: 'error', message: indexResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'index-info', ...indexResult });
      }
      break;
    }

    case 'queryIntegrity': {
      var integrityResult = engine.checkIntegrity(msg.dbId);
      if (integrityResult.error) {
        self.postMessage({ type: 'error', message: integrityResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'integrity-result', ...integrityResult });
      }
      auditLog('queryIntegrity', msg.dbId, { passed: integrityResult.passed, failed: integrityResult.failed });
      break;
    }

    case 'queryCapacity': {
      var capacity = getCapacity();
      self.postMessage({ type: 'capacity', ...capacity });
      break;
    }

    case 'queryAuditTrail': {
      var auditResult = queryAuditTrail(msg.count, msg.filters);
      if (auditResult.error) {
        self.postMessage({ type: 'error', message: auditResult.message });
      } else {
        self.postMessage({ type: 'audit-trail', ...auditResult });
      }
      break;
    }

    case 'queryResearchCorpus': {
      var researchResult = queryResearchCorpus(msg.query || {});
      if (researchResult.error) {
        self.postMessage({ type: 'error', message: researchResult.message });
      } else {
        self.postMessage({ type: 'research-results', ...researchResult });
      }
      break;
    }

    // ──────────────────────────────────────────────────────────────────
    //  CALL API — 10 Mutation Operations
    // ──────────────────────────────────────────────────────────────────

    case 'callInsert': {
      var insertResult = engine.insert(msg.dbId, msg.record || {});
      if (insertResult.error) {
        self.postMessage({ type: 'error', message: insertResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'inserted', ...insertResult });
      }
      auditLog('callInsert', msg.dbId, { id: insertResult.id });
      break;
    }

    case 'callBatchInsert': {
      var batchResult = engine.batchInsert(msg.dbId, msg.records || []);
      if (batchResult.error) {
        self.postMessage({ type: 'error', message: batchResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'batch-inserted', ...batchResult });
      }
      auditLog('callBatchInsert', msg.dbId, { count: (msg.records || []).length, succeeded: batchResult.succeeded });
      break;
    }

    case 'callUpdate': {
      var updateResult = engine.update(msg.dbId, msg.recordId, msg.updates || {});
      if (updateResult.error) {
        self.postMessage({ type: 'error', message: updateResult.message, dbId: msg.dbId, recordId: msg.recordId });
      } else {
        self.postMessage({ type: 'updated', ...updateResult });
      }
      auditLog('callUpdate', msg.dbId, { recordId: msg.recordId });
      break;
    }

    case 'callRemove': {
      var removeResult = engine.remove(msg.dbId, msg.recordId);
      if (removeResult.error) {
        self.postMessage({ type: 'error', message: removeResult.message, dbId: msg.dbId, recordId: msg.recordId });
      } else {
        self.postMessage({ type: 'removed', ...removeResult });
      }
      auditLog('callRemove', msg.dbId, { recordId: msg.recordId });
      break;
    }

    case 'callCompact': {
      var compactResult = engine.compact(msg.dbId);
      if (compactResult.error) {
        self.postMessage({ type: 'error', message: compactResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'compacted', ...compactResult });
      }
      auditLog('callCompact', msg.dbId, { removed: compactResult.removedTombstones, artifacts: compactResult.artifactsCreated });
      break;
    }

    case 'callMigrate': {
      var migrateResult = engine.migrate(msg.dbId, msg.migration || {});
      if (migrateResult.error) {
        self.postMessage({ type: 'error', message: migrateResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'migrated', ...migrateResult });
      }
      auditLog('callMigrate', msg.dbId, { version: (msg.migration || {}).version });
      break;
    }

    case 'callSnapshot': {
      var snapResult = engine.snapshot(msg.dbId);
      if (snapResult.error) {
        self.postMessage({ type: 'error', message: snapResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'snapshot-created', ...snapResult });
      }
      auditLog('callSnapshot', msg.dbId, { snapshotId: snapResult.snapshotId });
      break;
    }

    case 'callRestore': {
      var restoreResult = engine.restore(msg.dbId, msg.snapshotId);
      if (restoreResult.error) {
        self.postMessage({ type: 'error', message: restoreResult.message, dbId: msg.dbId, snapshotId: msg.snapshotId });
      } else {
        self.postMessage({ type: 'restored', ...restoreResult });
      }
      auditLog('callRestore', msg.dbId, { snapshotId: msg.snapshotId });
      break;
    }

    case 'callPurge': {
      var purgeResult = engine.purge(msg.dbId, msg.filters || {});
      if (purgeResult.error) {
        self.postMessage({ type: 'error', message: purgeResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'purged', ...purgeResult });
      }
      auditLog('callPurge', msg.dbId, { filters: msg.filters, purged: purgeResult.purged });
      break;
    }

    case 'callExport': {
      var exportResult = engine.exportDb(msg.dbId, msg.format || 'json');
      if (exportResult.error) {
        self.postMessage({ type: 'error', message: exportResult.message, dbId: msg.dbId });
      } else {
        self.postMessage({ type: 'exported', ...exportResult });
      }
      auditLog('callExport', msg.dbId, { format: msg.format });
      break;
    }

    // ──────────────────────────────────────────────────────────────────
    //  SYSTEM API — State & Lifecycle
    // ──────────────────────────────────────────────────────────────────

    case 'getState': {
      var state = getWorkerState();
      self.postMessage({ type: 'database-state', ...state });
      break;
    }

    case 'getHealth': {
      var healthReport = computeFleetHealth();
      self.postMessage({ type: 'health-report', ...healthReport });
      break;
    }

    case 'getChain': {
      var chainStatus = verifyAnimaChain();
      self.postMessage({
        type: 'chain-status',
        head: animaChainHead,
        length: animaChainLength,
        valid: chainStatus.valid,
        checked: chainStatus.checked,
        historySize: animaChainHistory.length
      });
      break;
    }

    case 'getDatabaseDefs': {
      self.postMessage({
        type: 'database-defs',
        definitions: DATABASE_DEFS.map(function (def) {
          return {
            id: def.id,
            name: def.name,
            description: def.description,
            recordTypes: def.recordTypes,
            indexes: def.indexes,
            retentionPolicy: def.retentionPolicy,
            maxRecords: def.maxRecords
          };
        }),
        count: DATABASE_DEFS.length
      });
      break;
    }

    case 'stop': {
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      auditLog('shutdown', null, { beat: beatCount, uptime: Date.now() - engine.createdAt });
      var finalState = getWorkerState();
      self.postMessage({ type: 'stopped', ...finalState });
      break;
    }
  }
};

// ════════════════════════════════════════════════════════════════════════
//  HEARTBEAT — 873ms AGI-governed pulse
// ════════════════════════════════════════════════════════════════════════

var heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Extend the ANIMA chain every heartbeat — proof of life
  extendAnimaChain();

  // Run AGI governance at scheduled intervals
  runAgiGovernance();

  // Record telemetry samples
  recordTelemetry();

  // Report heartbeat
  var totalRecords = engine.getTotalRecordCount();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    databases: engine.databases.size,
    totalRecords: totalRecords,
    totalInserts: totalInserts,
    totalQueries: totalQueries,
    animaHead: animaChainHead,
    animaLength: animaChainLength,
    governance: {
      nextIndex: AGI_INDEX_INTERVAL - (beatCount % AGI_INDEX_INTERVAL),
      nextCompact: AGI_COMPACT_INTERVAL - (beatCount % AGI_COMPACT_INTERVAL),
      nextIntegrity: AGI_INTEGRITY_INTERVAL - (beatCount % AGI_INTEGRITY_INTERVAL),
      nextConsistency: AGI_CONSISTENCY_INTERVAL - (beatCount % AGI_CONSISTENCY_INTERVAL)
    }
  });
}, HEARTBEAT);
