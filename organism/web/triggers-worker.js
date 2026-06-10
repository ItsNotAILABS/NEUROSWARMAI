/**
 * Triggers Worker — TOOL-181–200: Condition-Based Auto-Execution
 *
 * Web Worker managing 20 trigger tools — condition-based auto-execution
 * rules that continuously evaluate and fire when conditions are met.
 * Unlike hooks (event-driven), triggers are condition-driven: they
 * poll state and fire when predicates become true.
 *
 * Tool Registry (20 tools):
 *   TOOL-181  thresholdTrigger      — Fire when metric crosses threshold
 *   TOOL-182  scheduleTrigger       — Fire on schedule (cron-like)
 *   TOOL-183  rateLimitTrigger      — Fire when rate limit is approached
 *   TOOL-184  budgetTrigger         — Fire when budget threshold crossed
 *   TOOL-185  healthTrigger         — Fire when health score drops
 *   TOOL-186  capacityTrigger       — Fire when capacity threshold reached
 *   TOOL-187  deadlineTrigger       — Fire when deadline approaches
 *   TOOL-188  patternTrigger        — Fire when data pattern matched
 *   TOOL-189  driftTrigger          — Fire when drift exceeds tolerance
 *   TOOL-190  quorumTrigger         — Fire when quorum is reached/lost
 *   TOOL-191  cooldownTrigger       — Fire after cooldown period expires
 *   TOOL-192  cascadeTrigger        — Fire in cascade (trigger chains)
 *   TOOL-193  absenceTrigger        — Fire when expected event is absent
 *   TOOL-194  saturationTrigger     — Fire when system is saturated
 *   TOOL-195  oscillationTrigger    — Fire when values oscillate
 *   TOOL-196  convergenceTrigger    — Fire when values converge
 *   TOOL-197  divergenceTrigger     — Fire when values diverge
 *   TOOL-198  stalenessTrigger      — Fire when data becomes stale
 *   TOOL-199  compositeAndTrigger   — Fire when ALL sub-conditions met
 *   TOOL-200  compositeOrTrigger    — Fire when ANY sub-condition met
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'create', toolId, condition, action }
 *   Main → Worker: { type: 'update', triggerId, updates }
 *   Main → Worker: { type: 'delete', triggerId }
 *   Main → Worker: { type: 'setState', key, value }
 *   Main → Worker: { type: 'list' }
 *   Worker → Main: { type: 'trigger-fired', triggerId, toolId, action }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const EVAL_INTERVAL = 500;  // Evaluate triggers every 500ms
const TOOL_BASE = 181;
const TOOL_COUNT = 20;
const TOOL_MAX = 200;
const MAX_TRIGGERS = 144; // F12

let beatCount = 0;
let running = true;
let fireCount = 0;
let triggerIdCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Trigger type registry — 20 condition-based tools
   ════════════════════════════════════════════════════════════════ */

const TRIGGER_REGISTRY = [
  { id: 181, name: 'thresholdTrigger',   evaluator: 'threshold' },
  { id: 182, name: 'scheduleTrigger',    evaluator: 'schedule' },
  { id: 183, name: 'rateLimitTrigger',   evaluator: 'rate' },
  { id: 184, name: 'budgetTrigger',      evaluator: 'threshold' },
  { id: 185, name: 'healthTrigger',      evaluator: 'threshold' },
  { id: 186, name: 'capacityTrigger',    evaluator: 'threshold' },
  { id: 187, name: 'deadlineTrigger',    evaluator: 'deadline' },
  { id: 188, name: 'patternTrigger',     evaluator: 'pattern' },
  { id: 189, name: 'driftTrigger',       evaluator: 'drift' },
  { id: 190, name: 'quorumTrigger',      evaluator: 'quorum' },
  { id: 191, name: 'cooldownTrigger',    evaluator: 'cooldown' },
  { id: 192, name: 'cascadeTrigger',     evaluator: 'cascade' },
  { id: 193, name: 'absenceTrigger',     evaluator: 'absence' },
  { id: 194, name: 'saturationTrigger',  evaluator: 'threshold' },
  { id: 195, name: 'oscillationTrigger', evaluator: 'oscillation' },
  { id: 196, name: 'convergenceTrigger', evaluator: 'convergence' },
  { id: 197, name: 'divergenceTrigger',  evaluator: 'divergence' },
  { id: 198, name: 'stalenessTrigger',   evaluator: 'staleness' },
  { id: 199, name: 'compositeAndTrigger', evaluator: 'composite-and' },
  { id: 200, name: 'compositeOrTrigger',  evaluator: 'composite-or' },
];

const triggerTypeMap = new Map();
for (const t of TRIGGER_REGISTRY) {
  triggerTypeMap.set(t.id, t);
  triggerTypeMap.set(t.name, t);
}

// Active trigger instances
const activeTriggers = new Map();

// Shared state that triggers evaluate against
const triggerState = new Map();

// Fire log
const fireLog = [];
const MAX_FIRE_LOG = 233; // F13

/* ════════════════════════════════════════════════════════════════
   Trigger creation & management
   ════════════════════════════════════════════════════════════════ */

function createTrigger(toolId, condition, action) {
  const triggerType = triggerTypeMap.get(toolId);
  if (!triggerType) return { error: 'unknown-trigger-type', toolId };
  if (activeTriggers.size >= MAX_TRIGGERS) return { error: 'max-triggers-reached', max: MAX_TRIGGERS };

  const triggerId = `trig-${triggerType.id}-${++triggerIdCounter}`;
  const trigger = {
    id: triggerId,
    toolId: triggerType.id,
    name: triggerType.name,
    evaluator: triggerType.evaluator,
    condition: condition || {},
    action: action || 'notify',
    enabled: true,
    createdAt: Date.now(),
    lastEval: null,
    lastFired: null,
    fireCount: 0,
    consecutiveFires: 0,
    cooldownUntil: 0,
  };

  activeTriggers.set(triggerId, trigger);
  return { triggerId, toolId: triggerType.id, name: triggerType.name };
}

/* ════════════════════════════════════════════════════════════════
   Trigger evaluation engine — runs every EVAL_INTERVAL
   ════════════════════════════════════════════════════════════════ */

function evaluateAllTriggers() {
  const now = Date.now();

  for (const [triggerId, trigger] of activeTriggers) {
    if (!trigger.enabled) continue;
    if (now < trigger.cooldownUntil) continue;

    trigger.lastEval = now;
    let shouldFire = false;

    try {
      shouldFire = evaluateTrigger(trigger, now);
    } catch (err) {
      // Evaluation error — don't fire
      continue;
    }

    if (shouldFire) {
      trigger.fireCount++;
      trigger.consecutiveFires++;
      trigger.lastFired = now;
      fireCount++;

      // Apply cooldown (min 1s between fires)
      const cooldown = trigger.condition.cooldownMs || 1000;
      trigger.cooldownUntil = now + cooldown;

      const fireRecord = {
        triggerId,
        toolId: trigger.toolId,
        name: trigger.name,
        action: trigger.action,
        firedAt: now,
        consecutiveFires: trigger.consecutiveFires,
        phiWeight: Math.pow(PHI_INV, trigger.toolId - TOOL_BASE),
      };

      fireLog.push(fireRecord);
      if (fireLog.length > MAX_FIRE_LOG) fireLog.shift();

      self.postMessage({ type: 'trigger-fired', ...fireRecord });
    } else {
      trigger.consecutiveFires = 0;
    }
  }
}

function evaluateTrigger(trigger, now) {
  const cond = trigger.condition;

  switch (trigger.evaluator) {
    case 'threshold': {
      const key = cond.metric || cond.key;
      const value = triggerState.get(key);
      if (value === undefined) return false;
      if (cond.above !== undefined) return value > cond.above;
      if (cond.below !== undefined) return value < cond.below;
      if (cond.equals !== undefined) return value === cond.equals;
      return false;
    }

    case 'schedule': {
      const interval = cond.intervalMs || 60000;
      return !trigger.lastFired || (now - trigger.lastFired >= interval);
    }

    case 'rate': {
      const key = cond.metric || cond.key;
      const value = triggerState.get(key);
      const limit = cond.limit || 100;
      return value !== undefined && value > limit * 0.9;
    }

    case 'deadline': {
      const deadline = cond.deadline || cond.timestamp;
      if (!deadline) return false;
      const warningMs = cond.warningMs || 300000; // 5min default
      return deadline - now <= warningMs && deadline > now;
    }

    case 'staleness': {
      const key = cond.key || cond.metric;
      const lastUpdate = triggerState.get(key + '_timestamp');
      const maxAge = cond.maxAgeMs || 60000;
      return lastUpdate !== undefined && (now - lastUpdate > maxAge);
    }

    case 'absence': {
      const key = cond.key;
      return !triggerState.has(key);
    }

    case 'cooldown': {
      const duration = cond.durationMs || 30000;
      const startKey = cond.startKey;
      const startTime = triggerState.get(startKey);
      return startTime !== undefined && (now - startTime >= duration);
    }

    case 'quorum': {
      const keys = cond.keys || [];
      const threshold = cond.threshold || keys.length;
      const present = keys.filter(k => triggerState.has(k) && triggerState.get(k)).length;
      return present >= threshold;
    }

    case 'drift': {
      const key = cond.key;
      const value = triggerState.get(key);
      const baseline = cond.baseline || 0;
      const tolerance = cond.tolerance || 0.1;
      return value !== undefined && Math.abs(value - baseline) > tolerance;
    }

    case 'convergence': {
      const keys = cond.keys || [];
      if (keys.length < 2) return false;
      const values = keys.map(k => triggerState.get(k)).filter(v => v !== undefined);
      if (values.length < 2) return false;
      const spread = Math.max(...values) - Math.min(...values);
      return spread < (cond.threshold || 0.05);
    }

    case 'divergence': {
      const keys = cond.keys || [];
      if (keys.length < 2) return false;
      const values = keys.map(k => triggerState.get(k)).filter(v => v !== undefined);
      if (values.length < 2) return false;
      const spread = Math.max(...values) - Math.min(...values);
      return spread > (cond.threshold || 0.5);
    }

    case 'composite-and': {
      const subs = cond.conditions || [];
      return subs.every(sub => evaluateTrigger({ evaluator: sub.evaluator || 'threshold', condition: sub }, now));
    }

    case 'composite-or': {
      const subs = cond.conditions || [];
      return subs.some(sub => evaluateTrigger({ evaluator: sub.evaluator || 'threshold', condition: sub }, now));
    }

    default:
      return false;
  }
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'create': {
      const result = createTrigger(msg.toolId, msg.condition, msg.action);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      } else {
        self.postMessage({ type: 'trigger-created', ...result });
      }
      break;
    }

    case 'update': {
      const trigger = activeTriggers.get(msg.triggerId);
      if (trigger && msg.updates) {
        Object.assign(trigger, msg.updates);
        self.postMessage({ type: 'trigger-updated', triggerId: msg.triggerId });
      }
      break;
    }

    case 'delete': {
      const found = activeTriggers.has(msg.triggerId);
      activeTriggers.delete(msg.triggerId);
      self.postMessage({ type: 'trigger-deleted', triggerId: msg.triggerId, found });
      break;
    }

    case 'setState': {
      triggerState.set(msg.key, msg.value);
      if (msg.timestamp !== false) {
        triggerState.set(msg.key + '_timestamp', Date.now());
      }
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        triggerTypes: TRIGGER_REGISTRY.map(t => ({ id: t.id, name: t.name, evaluator: t.evaluator })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
        activeTriggers: activeTriggers.size,
      });
      break;

    case 'getStats':
      self.postMessage({
        type: 'stats',
        totalFires: fireCount,
        activeTriggers: activeTriggers.size,
        maxTriggers: MAX_TRIGGERS,
        stateKeys: triggerState.size,
        recentFires: fireLog.slice(-10),
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (evalInterval) clearInterval(evalInterval);
      self.postMessage({ type: 'stopped', totalFires: fireCount });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Evaluation loop — runs every 500ms
   ════════════════════════════════════════════════════════════════ */

const evalInterval = setInterval(function () {
  if (!running) return;
  evaluateAllTriggers();
}, EVAL_INTERVAL);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — 873ms φ-scaled
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    toolRange: 'TOOL-181–200',
    totalFires: fireCount,
    activeTriggers: activeTriggers.size,
  });
}, HEARTBEAT);
