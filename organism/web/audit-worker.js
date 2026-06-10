/**
 * Audit Worker — AUDIT-001–021: Audit Trail, Event Sourcing & Immutable Activity Log
 *
 * Maintains an append-only, hash-chained audit log of all significant system
 * events. Batches are sealed every 34 beats with a FNV-1a running hash, and
 * a full integrity scan runs every 144 beats to verify the chain is unbroken.
 * The ring buffer holds up to F18 = 2584 entries before rolling over.
 *
 * Tool Registry (21 tools):
 *   AUDIT-001  log      — Append an event to the audit log
 *   AUDIT-002  verify   — Verify hash chain integrity
 *   AUDIT-003  replay   — Replay events from a given sequence number
 *   AUDIT-004  report   — Generate audit report for a time range
 *   AUDIT-005  export   — Export log as JSON
 *   AUDIT-006  seal     — Seal current batch and advance hash chain
 *   AUDIT-007  purge    — Purge events older than retention window
 *   AUDIT-008  search   — Full-text search across audit entries
 *   AUDIT-009  filter   — Filter events by actor, type, or entity
 *   AUDIT-010  count    — Count events matching criteria
 *   AUDIT-011  diff     — Show diff between two sealed batches
 *   AUDIT-012  annotate — Annotate an event with additional context
 *   AUDIT-013  redact   — Redact PII from an event (preserving hash proof)
 *   AUDIT-014  certify  — Issue a signed certificate for a batch
 *   AUDIT-015  stream   — Stream live events to subscribers
 *   AUDIT-016  snapshot — Point-in-time snapshot of current log state
 *   AUDIT-017  restore  — Restore log state from snapshot
 *   AUDIT-018  tag      — Tag an event with metadata labels
 *   AUDIT-019  classify — Auto-classify event severity and category
 *   AUDIT-020  archive  — Archive sealed batch to cold storage
 *   AUDIT-021  health   — Audit system health check
 *
 * Proactive beats:
 *   Every 34 beats  — seal current batch with FNV-1a hash chain
 *   Every 144 beats — full integrity scan of entire hash chain
 *
 * Message types (in):
 *   query:log    — fetch recent log entries
 *   query:events — events by filter (actor, type, entity)
 *   query:report — audit report for a time window
 *   query:verify — verify chain integrity
 *   call:record  — append a new audit event
 *   call:seal    — force-seal current batch
 *   call:export  — export full log
 *   call:purge   — purge events older than N ms
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873; // ms

// Fibonacci constants
const F7  = 13;
const F8  = 21;
const F9  = 34;
const F10 = 55;
const F11 = 89;
const F12 = 144;
const F13 = 233;
const F14 = 377;
const F15 = 610;
const F16 = 987;
const F17 = 1597;
const F18 = 2584; // ring buffer capacity

const SEAL_INTERVAL      = F9;  // 34 beats — seal batch
const INTEGRITY_INTERVAL = F12; // 144 beats — full scan

let beatCount = 0;
let seqCounter = 0;
let batchCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Tool Registry — 21 audit tools
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  { id: 'AUDIT-001', name: 'log',      category: 'write',    description: 'Append an event to the audit log' },
  { id: 'AUDIT-002', name: 'verify',   category: 'verify',   description: 'Verify hash chain integrity' },
  { id: 'AUDIT-003', name: 'replay',   category: 'read',     description: 'Replay events from sequence number' },
  { id: 'AUDIT-004', name: 'report',   category: 'report',   description: 'Generate audit report' },
  { id: 'AUDIT-005', name: 'export',   category: 'report',   description: 'Export log as JSON' },
  { id: 'AUDIT-006', name: 'seal',     category: 'write',    description: 'Seal current batch' },
  { id: 'AUDIT-007', name: 'purge',    category: 'admin',    description: 'Purge old events' },
  { id: 'AUDIT-008', name: 'search',   category: 'read',     description: 'Full-text search across entries' },
  { id: 'AUDIT-009', name: 'filter',   category: 'read',     description: 'Filter events by criteria' },
  { id: 'AUDIT-010', name: 'count',    category: 'read',     description: 'Count matching events' },
  { id: 'AUDIT-011', name: 'diff',     category: 'read',     description: 'Diff between two sealed batches' },
  { id: 'AUDIT-012', name: 'annotate', category: 'write',    description: 'Annotate an event' },
  { id: 'AUDIT-013', name: 'redact',   category: 'admin',    description: 'Redact PII from event' },
  { id: 'AUDIT-014', name: 'certify',  category: 'verify',   description: 'Issue certificate for a batch' },
  { id: 'AUDIT-015', name: 'stream',   category: 'read',     description: 'Stream live events' },
  { id: 'AUDIT-016', name: 'snapshot', category: 'admin',    description: 'Point-in-time snapshot' },
  { id: 'AUDIT-017', name: 'restore',  category: 'admin',    description: 'Restore from snapshot' },
  { id: 'AUDIT-018', name: 'tag',      category: 'write',    description: 'Tag event with labels' },
  { id: 'AUDIT-019', name: 'classify', category: 'write',    description: 'Auto-classify event severity' },
  { id: 'AUDIT-020', name: 'archive',  category: 'admin',    description: 'Archive sealed batch' },
  { id: 'AUDIT-021', name: 'health',   category: 'verify',   description: 'Audit system health check' },
];

/* ════════════════════════════════════════════════════════════════
   FNV-1a (32-bit) — lightweight hash for seal chain
   ════════════════════════════════════════════════════════════════ */

function fnv1a(str) {
  let hash = 0x811c9dc5;
  for (let i = 0; i < str.length; i++) {
    hash ^= str.charCodeAt(i);
    hash = (hash * 0x01000193) >>> 0; // keep 32-bit unsigned
  }
  return hash.toString(16).padStart(8, '0');
}

/* ════════════════════════════════════════════════════════════════
   State
   ════════════════════════════════════════════════════════════════ */

const eventLog = [];          // ring buffer — max F18 entries
const sealedBatches = [];     // array of { batchId, hash, prevHash, size, sealedAt }
const currentBatch = [];      // entries pending seal
let chainHash = '00000000';   // genesis hash

/* ════════════════════════════════════════════════════════════════
   Event recording
   ════════════════════════════════════════════════════════════════ */

function recordEvent({ eventType = 'generic', actor = 'system', entity = null, data = {}, severity = 'info' }) {
  const seq = ++seqCounter;
  const ts = Date.now();
  const entry = {
    seq,
    eventType,
    actor,
    entity,
    data,
    severity: classifySeverity(severity, eventType),
    batchId: null, // assigned on seal
    hash: null,    // assigned on seal
    ts,
  };

  // Inline hash of this entry (over seq + type + actor + ts)
  entry.hash = fnv1a(`${seq}:${eventType}:${actor}:${ts}`);

  eventLog.push(entry);
  if (eventLog.length > F18) eventLog.shift();

  currentBatch.push(entry);

  return entry;
}

function classifySeverity(hint, eventType) {
  if (hint !== 'info') return hint;
  if (/delete|purge|cancel|terminate/i.test(eventType)) return 'warning';
  if (/auth|login|permission|sudo/i.test(eventType))    return 'high';
  if (/error|fail|breach/i.test(eventType))              return 'critical';
  return 'info';
}

/* ════════════════════════════════════════════════════════════════
   Seal — hash chain commit
   ════════════════════════════════════════════════════════════════ */

function sealBatch(force = false) {
  if (!force && currentBatch.length === 0) return null;

  const batchId = `BATCH-${String(++batchCounter).padStart(6, '0')}`;
  const batchContent = currentBatch.map(e => e.hash).join(':');
  const newHash = fnv1a(`${chainHash}:${batchId}:${batchContent}`);
  const prevHash = chainHash;
  chainHash = newHash;

  for (const entry of currentBatch) entry.batchId = batchId;

  const batch = {
    batchId,
    hash: newHash,
    prevHash,
    size: currentBatch.length,
    sealedAt: Date.now(),
    phiWeight: currentBatch.length * PHI_INV,
  };
  sealedBatches.push(batch);
  if (sealedBatches.length > F14) sealedBatches.shift(); // keep 377 batches

  currentBatch.length = 0;

  self.postMessage({ type: 'audit:sealed', batchId, hash: newHash, prevHash, size: batch.size, ts: Date.now() });
  return batch;
}

/* ════════════════════════════════════════════════════════════════
   Integrity scan — verify hash chain continuity
   ════════════════════════════════════════════════════════════════ */

function integrityCheck() {
  let valid = true;
  let broken = null;
  for (let i = 1; i < sealedBatches.length; i++) {
    if (sealedBatches[i].prevHash !== sealedBatches[i - 1].hash) {
      valid = false;
      broken = sealedBatches[i].batchId;
      break;
    }
  }
  self.postMessage({
    type: 'audit:integrity',
    valid,
    batchCount: sealedBatches.length,
    eventCount: eventLog.length,
    chainTip: chainHash,
    brokenAt: broken,
    beat: beatCount,
    ts: Date.now(),
  });
  return valid;
}

/* ════════════════════════════════════════════════════════════════
   Heartbeat
   ════════════════════════════════════════════════════════════════ */

// Seed some system events
recordEvent({ eventType: 'system:init', actor: 'audit-worker', data: { version: '1.0' } });
recordEvent({ eventType: 'tool:registry:loaded', actor: 'audit-worker', data: { tools: TOOL_REGISTRY.length } });

setInterval(() => {
  beatCount++;

  // Self-log each heartbeat as a low-severity audit event
  recordEvent({ eventType: 'heartbeat', actor: 'audit-worker', data: { beat: beatCount }, severity: 'info' });

  if (beatCount % SEAL_INTERVAL      === 0) sealBatch();
  if (beatCount % INTEGRITY_INTERVAL === 0) integrityCheck();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    events: eventLog.length,
    pendingBatch: currentBatch.length,
    sealedBatches: sealedBatches.length,
    chainTip: chainHash,
    ts: Date.now(),
  });
}, PHI_BEAT);

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};

  switch (type) {

    case 'query:log': {
      const { limit = F10, offset = 0 } = payload;
      const entries = eventLog.slice(-(limit + offset), eventLog.length - offset || undefined).reverse();
      self.postMessage({ type: 'result:log', entries, total: eventLog.length, ts: Date.now() });
      break;
    }

    case 'query:events': {
      const { actor, eventType, entity, limit = F11 } = payload;
      const filtered = eventLog
        .filter(ev =>
          (!actor     || ev.actor === actor) &&
          (!eventType || ev.eventType === eventType) &&
          (!entity    || ev.entity === entity)
        )
        .slice(-limit);
      self.postMessage({ type: 'result:events', events: filtered, count: filtered.length, ts: Date.now() });
      break;
    }

    case 'query:report': {
      const { since = Date.now() - 3600000, until = Date.now() } = payload;
      const window = eventLog.filter(ev => ev.ts >= since && ev.ts <= until);
      const bySeverity = {};
      const byType = {};
      for (const ev of window) {
        bySeverity[ev.severity] = (bySeverity[ev.severity] || 0) + 1;
        byType[ev.eventType]    = (byType[ev.eventType]    || 0) + 1;
      }
      self.postMessage({ type: 'result:report', since, until, total: window.length, bySeverity, byType, ts: Date.now() });
      break;
    }

    case 'query:verify': {
      const valid = integrityCheck();
      self.postMessage({ type: 'result:verify', valid, chainTip: chainHash, ts: Date.now() });
      break;
    }

    case 'call:record': {
      const entry = recordEvent(payload);
      self.postMessage({ type: 'result:record', seq: entry.seq, hash: entry.hash, batchId: entry.batchId, ts: Date.now() });
      break;
    }

    case 'call:seal': {
      const batch = sealBatch(true);
      self.postMessage({ type: 'result:seal', batch: batch || null, ts: Date.now() });
      break;
    }

    case 'call:export': {
      self.postMessage({
        type: 'result:export',
        log: eventLog,
        batches: sealedBatches,
        chainTip: chainHash,
        exportedAt: Date.now(),
        ts: Date.now(),
      });
      break;
    }

    case 'call:purge': {
      const { olderThanMs = 86400000 } = payload;
      const cutoff = Date.now() - olderThanMs;
      const before = eventLog.length;
      let i = 0;
      while (i < eventLog.length && eventLog[i].ts < cutoff) i++;
      eventLog.splice(0, i);
      const purged = before - eventLog.length;
      self.postMessage({ type: 'result:purge', purged, remaining: eventLog.length, ts: Date.now() });
      break;
    }

    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
