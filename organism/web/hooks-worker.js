/**
 * Hooks Worker — TOOL-161–180: Event-Driven Automation Triggers
 *
 * Web Worker managing 20 hook tools — event-driven automation triggers
 * that fire when specific organism events occur. Hooks are the
 * reactive nervous system: they listen for patterns and trigger
 * automated responses.
 *
 * Tool Registry (20 tools):
 *   TOOL-161  onCoherenceChange   — Fires when Kuramoto R crosses threshold
 *   TOOL-162  onEmergence         — Fires when emergence level changes
 *   TOOL-163  onWorkerDeath       — Fires when a worker dies/restarts
 *   TOOL-164  onThreatDetected    — Fires when sentinel detects threat
 *   TOOL-165  onMemoryEncode      — Fires when a new pattern is encoded
 *   TOOL-166  onMemoryRecall      — Fires on pattern recall event
 *   TOOL-167  onTransaction       — Fires on FORMA transaction
 *   TOOL-168  onBuildComplete     — Fires when product build completes
 *   TOOL-169  onAnomalyDetected   — Fires when telemetry finds anomaly
 *   TOOL-170  onHeartbeat         — Fires on every heartbeat cycle
 *   TOOL-171  onPostureChange     — Fires when defense posture changes
 *   TOOL-172  onSpike             — Fires when brain region spikes
 *   TOOL-173  onChainExtend       — Fires when ANIMA chain extends
 *   TOOL-174  onTaskComplete      — Fires when micro-task completes
 *   TOOL-175  onBatchComplete     — Fires when task batch completes
 *   TOOL-176  onContainmentDecay  — Fires when containment dissolves
 *   TOOL-177  onScaleEvent        — Fires on auto-scaling events
 *   TOOL-178  onConfigChange      — Fires when configuration changes
 *   TOOL-179  onBusOverflow       — Fires when signal bus hits back-pressure
 *   TOOL-180  onFleetStateChange  — Fires when fleet composition changes
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'register', hookId, config }
 *   Main → Worker: { type: 'unregister', hookId }
 *   Main → Worker: { type: 'emit', event, data }
 *   Main → Worker: { type: 'list' }
 *   Worker → Main: { type: 'hook-fired', hookId, event, data, action }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const TOOL_BASE = 161;
const TOOL_COUNT = 20;
const TOOL_MAX = 180;
const MAX_HOOKS = 144; // F12 — max registered hooks
const MAX_FIRE_LOG = 233; // F13

let beatCount = 0;
let running = true;
let fireCount = 0;

/* ════════════════════════════════════════════════════════════════
   Hook registry — 20 event-driven hooks
   ════════════════════════════════════════════════════════════════ */

const HOOK_REGISTRY = [
  { id: 161, name: 'onCoherenceChange',  event: 'coherence-change',  domain: 'cognitive' },
  { id: 162, name: 'onEmergence',         event: 'emergence-change',  domain: 'cognitive' },
  { id: 163, name: 'onWorkerDeath',       event: 'worker-death',      domain: 'infra' },
  { id: 164, name: 'onThreatDetected',    event: 'threat-detected',   domain: 'security' },
  { id: 165, name: 'onMemoryEncode',      event: 'memory-encode',     domain: 'memory' },
  { id: 166, name: 'onMemoryRecall',      event: 'memory-recall',     domain: 'memory' },
  { id: 167, name: 'onTransaction',       event: 'transaction',       domain: 'economic' },
  { id: 168, name: 'onBuildComplete',     event: 'build-complete',    domain: 'production' },
  { id: 169, name: 'onAnomalyDetected',  event: 'anomaly-detected',  domain: 'monitoring' },
  { id: 170, name: 'onHeartbeat',         event: 'heartbeat',         domain: 'system' },
  { id: 171, name: 'onPostureChange',     event: 'posture-change',    domain: 'security' },
  { id: 172, name: 'onSpike',             event: 'spike',             domain: 'cognitive' },
  { id: 173, name: 'onChainExtend',       event: 'chain-extend',      domain: 'crypto' },
  { id: 174, name: 'onTaskComplete',      event: 'task-complete',     domain: 'labor' },
  { id: 175, name: 'onBatchComplete',     event: 'batch-complete',    domain: 'labor' },
  { id: 176, name: 'onContainmentDecay',  event: 'containment-decay', domain: 'security' },
  { id: 177, name: 'onScaleEvent',        event: 'scale-event',       domain: 'infra' },
  { id: 178, name: 'onConfigChange',      event: 'config-change',     domain: 'system' },
  { id: 179, name: 'onBusOverflow',       event: 'bus-overflow',      domain: 'nervous' },
  { id: 180, name: 'onFleetStateChange',  event: 'fleet-change',      domain: 'infra' },
];

const hookMap = new Map();
for (const hook of HOOK_REGISTRY) {
  hookMap.set(hook.id, hook);
  hookMap.set(hook.name, hook);
}

// Registered hook instances (user-configured subscriptions)
const registeredHooks = new Map();

// Event → hook ID mapping for fast dispatch
const eventIndex = new Map();
for (const hook of HOOK_REGISTRY) {
  if (!eventIndex.has(hook.event)) eventIndex.set(hook.event, []);
  eventIndex.get(hook.event).push(hook.id);
}

// Fire log
const fireLog = [];

/* ════════════════════════════════════════════════════════════════
   Hook registration & event dispatch
   ════════════════════════════════════════════════════════════════ */

function registerHook(hookId, config) {
  const hook = hookMap.get(hookId);
  if (!hook) return { error: 'unknown-hook', hookId };
  if (registeredHooks.size >= MAX_HOOKS) return { error: 'max-hooks-reached', max: MAX_HOOKS };

  const registration = {
    hookId: hook.id,
    hookName: hook.name,
    event: hook.event,
    config: config || {},
    filter: config ? config.filter : null,
    action: config ? config.action : null,
    enabled: true,
    registeredAt: Date.now(),
    fireCount: 0,
  };

  const regId = `hook-${hook.id}-${Date.now().toString(36)}`;
  registeredHooks.set(regId, registration);

  return { registrationId: regId, hookId: hook.id, hookName: hook.name, event: hook.event };
}

function unregisterHook(regId) {
  const found = registeredHooks.has(regId);
  registeredHooks.delete(regId);
  return { registrationId: regId, found };
}

function emitEvent(event, data) {
  const hookIds = eventIndex.get(event) || [];
  const fired = [];

  for (const hookId of hookIds) {
    // Check all registrations for this hook
    for (const [regId, reg] of registeredHooks) {
      if (reg.hookId === hookId && reg.enabled) {
        // Apply filter if configured
        if (reg.filter && !matchFilter(data, reg.filter)) continue;

        reg.fireCount++;
        fireCount++;

        const fireRecord = {
          registrationId: regId,
          hookId,
          hookName: reg.hookName,
          event,
          data,
          action: reg.action || 'notify',
          firedAt: Date.now(),
          phiWeight: Math.pow(PHI_INV, hookId - TOOL_BASE),
        };

        fired.push(fireRecord);
        fireLog.push(fireRecord);
        if (fireLog.length > MAX_FIRE_LOG) fireLog.shift();

        self.postMessage({
          type: 'hook-fired',
          ...fireRecord,
        });
      }
    }
  }

  return { event, firedCount: fired.length, hookIds };
}

function matchFilter(data, filter) {
  if (!data || !filter) return true;
  for (const [key, value] of Object.entries(filter)) {
    if (data[key] !== value) return false;
  }
  return true;
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'register': {
      const result = registerHook(msg.hookId, msg.config);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      } else {
        self.postMessage({ type: 'hook-registered', ...result });
      }
      break;
    }

    case 'unregister': {
      const result = unregisterHook(msg.hookId || msg.registrationId);
      self.postMessage({ type: 'hook-unregistered', ...result });
      break;
    }

    case 'emit': {
      const result = emitEvent(msg.event, msg.data);
      self.postMessage({ type: 'event-processed', ...result });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        hooks: HOOK_REGISTRY.map(h => ({ id: h.id, name: h.name, event: h.event, domain: h.domain })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
        registered: registeredHooks.size,
      });
      break;

    case 'getStats':
      self.postMessage({
        type: 'stats',
        totalFires: fireCount,
        registeredHooks: registeredHooks.size,
        maxHooks: MAX_HOOKS,
        recentFires: fireLog.slice(-10).map(f => ({ hookName: f.hookName, event: f.event, firedAt: f.firedAt })),
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', totalFires: fireCount });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Heartbeat — 873ms φ-scaled
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Self-emit heartbeat event to trigger onHeartbeat hooks
  emitEvent('heartbeat', { beat: beatCount, timestamp: Date.now() });

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    toolRange: 'TOOL-161–180',
    totalFires: fireCount,
    registeredHooks: registeredHooks.size,
  });
}, HEARTBEAT);
