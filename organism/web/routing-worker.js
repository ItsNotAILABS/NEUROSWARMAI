/**
 * Routing Worker — Signal Bus & Inter-Worker Message Router
 *
 * Central nervous system of the organism's Web Worker fleet.
 * Routes messages between workers, manages subscriptions,
 * and dispatches signals to ALPHA orchestrator domains.
 *
 * Architecture:
 *   Signal Bus — pub/sub message routing between all workers
 *   Channel system — typed channels for domain-specific signals
 *   ALPHA dispatch — routes to CHIMERA/PHANTOM/ORBITAL/IRONVEIL domains
 *   Priority queue — φ-weighted signal priority
 *   Back-pressure — drops low-priority signals when bus is saturated
 *
 * Channels:
 *   'brain'      — cognitive signals (activations, spikes, weights)
 *   'memory'     — pattern encode/recall/decay events
 *   'telemetry'  — metrics, health, coherence reports
 *   'crypto'     — hash computations, chain extensions
 *   'contract'   — FORMA transactions, marketplace events
 *   'infra'      — worker lifecycle, spawn/kill events
 *   'sentinel'   — threat alerts, containment events
 *   'micro'      — task dispatch, batch results
 *   'product'    — build events, deployment status
 *   'alpha'      — ALPHA orchestrator coordination signals
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'route', channel, payload, priority? }
 *   Main → Worker: { type: 'subscribe', channel, workerId }
 *   Main → Worker: { type: 'unsubscribe', channel, workerId }
 *   Main → Worker: { type: 'broadcast', payload }
 *   Worker → Main: { type: 'routed', channel, payload, target }
 *   Worker → Main: { type: 'bus-state', channels, subscribers, queueDepth }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;
const MAX_QUEUE_DEPTH = 233;  // Fibonacci F13 — back-pressure threshold
const FLUSH_INTERVAL = 50;     // Process queue every 50ms

let beatCount = 0;
let running = true;
let totalRouted = 0;
let totalDropped = 0;

/* ════════════════════════════════════════════════════════════════
   Channel definitions
   ════════════════════════════════════════════════════════════════ */

const CHANNELS = [
  'brain', 'memory', 'telemetry', 'crypto', 'contract',
  'infra', 'sentinel', 'micro', 'product', 'alpha',
  'aicalls', 'blueprints', 'recipes', 'lenses', 'hooks',
  'triggers', 'adapters', 'sensors', 'shields',
  'protocols',
];

// Subscriber registry: channel → Set of workerIds
const subscribers = {};
for (const ch of CHANNELS) {
  subscribers[ch] = new Set();
}

// Signal queue — priority-sorted
const signalQueue = [];

// Route log — last N routed signals for telemetry
const routeLog = [];
const MAX_LOG = 89; // F11

/* ════════════════════════════════════════════════════════════════
   Signal routing
   ════════════════════════════════════════════════════════════════ */

function routeSignal(channel, payload, priority) {
  const signal = {
    channel,
    payload,
    priority: priority || 1.0,
    timestamp: Date.now(),
    id: ++totalRouted,
  };

  // Back-pressure: drop low-priority signals if queue is full
  if (signalQueue.length >= MAX_QUEUE_DEPTH) {
    if (signal.priority < PHI - 1) { // Below 0.618 priority = droppable
      totalDropped++;
      return null;
    }
    // Drop the lowest priority signal in queue
    let lowestIdx = 0;
    let lowestPri = signalQueue[0].priority;
    for (let i = 1; i < signalQueue.length; i++) {
      if (signalQueue[i].priority < lowestPri) {
        lowestPri = signalQueue[i].priority;
        lowestIdx = i;
      }
    }
    if (signal.priority > lowestPri) {
      signalQueue.splice(lowestIdx, 1);
      totalDropped++;
    } else {
      totalDropped++;
      return null;
    }
  }

  signalQueue.push(signal);

  // Sort by priority descending
  signalQueue.sort((a, b) => b.priority - a.priority);

  return signal;
}

function flushQueue() {
  const batch = signalQueue.splice(0, 13); // Process up to 13 (F7) signals per flush

  for (const signal of batch) {
    const targets = subscribers[signal.channel];

    // Post to main thread for relay to target workers
    self.postMessage({
      type: 'routed',
      channel: signal.channel,
      payload: signal.payload,
      targets: targets ? Array.from(targets) : [],
      priority: signal.priority,
      signalId: signal.id,
    });

    // Log for telemetry
    routeLog.push({
      id: signal.id,
      channel: signal.channel,
      timestamp: signal.timestamp,
      targetCount: targets ? targets.size : 0,
    });
    if (routeLog.length > MAX_LOG) routeLog.shift();
  }

  return batch.length;
}

/* ════════════════════════════════════════════════════════════════
   ALPHA domain dispatch
   ════════════════════════════════════════════════════════════════ */

const ALPHA_DOMAINS = {
  chimera:  { domain: 'physical', nodes: 89, agents: 144 },
  phantom:  { domain: 'virtual',  nodes: 89, agents: 233 },
  orbital:  { domain: 'space',    nodes: 55, agents: 89 },
  ironveil: { domain: 'infra',    nodes: 55, agents: 89 },
};

function dispatchToAlpha(domain, signal) {
  const alpha = ALPHA_DOMAINS[domain];
  if (!alpha) return;

  self.postMessage({
    type: 'alpha-dispatch',
    domain,
    alpha,
    signal,
    timestamp: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Bus state
   ════════════════════════════════════════════════════════════════ */

function getBusState() {
  const channelStats = {};
  for (const ch of CHANNELS) {
    channelStats[ch] = {
      subscribers: subscribers[ch].size,
      queued: signalQueue.filter(s => s.channel === ch).length,
    };
  }

  return {
    channels: CHANNELS.length,
    channelStats,
    queueDepth: signalQueue.length,
    maxQueue: MAX_QUEUE_DEPTH,
    totalRouted,
    totalDropped,
    logSize: routeLog.length,
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'route': {
      const signal = routeSignal(msg.channel, msg.payload, msg.priority);
      if (!signal) {
        self.postMessage({ type: 'dropped', channel: msg.channel, reason: 'back-pressure' });
      }
      break;
    }

    case 'subscribe': {
      const ch = msg.channel;
      if (subscribers[ch]) {
        subscribers[ch].add(msg.workerId);
        self.postMessage({ type: 'subscribed', channel: ch, workerId: msg.workerId, count: subscribers[ch].size });
      }
      break;
    }

    case 'unsubscribe': {
      const ch = msg.channel;
      if (subscribers[ch]) {
        subscribers[ch].delete(msg.workerId);
        self.postMessage({ type: 'unsubscribed', channel: ch, workerId: msg.workerId });
      }
      break;
    }

    case 'broadcast': {
      // Route to all channels
      for (const ch of CHANNELS) {
        routeSignal(ch, msg.payload, msg.priority || 0.5);
      }
      break;
    }

    case 'alpha-dispatch':
      dispatchToAlpha(msg.domain, msg.signal);
      break;

    case 'flush':
      flushQueue();
      break;

    case 'getState':
      self.postMessage({ type: 'bus-state', ...getBusState() });
      break;

    case 'getLog':
      self.postMessage({ type: 'route-log', log: routeLog.slice() });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (flushInterval) clearInterval(flushInterval);
      self.postMessage({ type: 'stopped', ...getBusState() });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Auto-flush — process queued signals every 50ms
   ════════════════════════════════════════════════════════════════ */

const flushInterval = setInterval(function () {
  if (!running) return;
  flushQueue();
}, FLUSH_INTERVAL);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const state = getBusState();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    ...state,
  });
}, HEARTBEAT);
