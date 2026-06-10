/**
 * Infrastructure Worker — Worker Lifecycle & Resource Management
 *
 * Web Worker that manages the entire worker fleet. Tracks spawned
 * workers, monitors their health, handles restarts on failure,
 * and manages resource allocation across the organism.
 *
 * Architecture:
 *   Worker registry — tracks all spawned workers with health status
 *   Lifecycle management — spawn, kill, restart coordination
 *   Resource monitoring — memory pressure, CPU estimates, worker count
 *   Fleet coordination — ensures minimum worker count per domain
 *   Graceful shutdown — ordered shutdown with state preservation
 *
 * Worker Fleet (standard deployment):
 *   brain-worker     — 7-region Hebbian cognitive engine
 *   memory-worker    — 144-node golden spiral resonance memory
 *   routing-worker   — Signal bus, inter-worker message router
 *   telemetry-worker — Metrics, coherence, health monitoring
 *   crypto-worker    — Hash engine, ANIMA chain, verification
 *   contract-worker  — FORMA ledger, transactions, marketplace
 *   infra-worker     — THIS worker (self-monitoring)
 *   sentinel-worker  — 24/7 watchdog, threat detection
 *   micro-worker     — Task execution pool
 *   product-worker   — Extension builder, asset bundler
 *   download-worker  — Zip builder for extensions
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'register', workerId, workerType }
 *   Main → Worker: { type: 'deregister', workerId }
 *   Main → Worker: { type: 'healthReport', workerId, status, metrics }
 *   Main → Worker: { type: 'requestRestart', workerId }
 *   Main → Worker: { type: 'getFleet' }
 *   Main → Worker: { type: 'shutdown' }
 *   Worker → Main: { type: 'spawn-request', workerType, reason }
 *   Worker → Main: { type: 'kill-request', workerId, reason }
 *   Worker → Main: { type: 'fleet-state', workers, health }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;
const HEALTH_CHECK_INTERVAL = 2000;  // Check fleet health every 2s
const DEAD_THRESHOLD = 5000;          // Worker dead if no report in 5s
const MAX_RESTART_ATTEMPTS = 5;

let beatCount = 0;
let running = true;

/* ════════════════════════════════════════════════════════════════
   Worker fleet registry
   ════════════════════════════════════════════════════════════════ */

const REQUIRED_WORKERS = [
  'brain', 'memory', 'routing', 'telemetry', 'crypto',
  'contract', 'sentinel', 'micro', 'product', 'download',
];

const fleet = new Map();  // workerId → worker info

function registerWorker(workerId, workerType, metadata) {
  const workerInfo = {
    id: workerId,
    type: workerType,
    status: 'alive',
    registeredAt: Date.now(),
    lastReport: Date.now(),
    restartCount: 0,
    metrics: {},
    metadata: metadata || {},
  };
  fleet.set(workerId, workerInfo);

  return workerInfo;
}

function deregisterWorker(workerId) {
  const worker = fleet.get(workerId);
  if (worker) {
    worker.status = 'deregistered';
    worker.deregisteredAt = Date.now();
  }
  return worker;
}

function updateHealth(workerId, status, metrics) {
  const worker = fleet.get(workerId);
  if (!worker) return null;

  worker.status = status;
  worker.lastReport = Date.now();
  if (metrics) {
    worker.metrics = { ...worker.metrics, ...metrics };
  }

  return worker;
}

/* ════════════════════════════════════════════════════════════════
   Health check — detect dead workers, request restarts
   ════════════════════════════════════════════════════════════════ */

function healthCheck() {
  const now = Date.now();
  const deadWorkers = [];
  const missingTypes = [];

  // Check for dead workers
  for (const [id, worker] of fleet) {
    if (worker.status === 'deregistered') continue;

    const timeSinceReport = now - worker.lastReport;
    if (timeSinceReport > DEAD_THRESHOLD) {
      worker.status = 'dead';
      deadWorkers.push(worker);

      // Request restart if under max attempts
      if (worker.restartCount < MAX_RESTART_ATTEMPTS) {
        worker.restartCount++;
        self.postMessage({
          type: 'spawn-request',
          workerType: worker.type,
          reason: 'dead-restart',
          attempt: worker.restartCount,
          previousId: id,
        });
      } else {
        self.postMessage({
          type: 'worker-abandoned',
          workerId: id,
          workerType: worker.type,
          reason: 'max-restarts-exceeded',
        });
      }
    }
  }

  // Check for missing required worker types
  const activeTypes = new Set();
  for (const worker of fleet.values()) {
    if (worker.status === 'alive') activeTypes.add(worker.type);
  }

  for (const requiredType of REQUIRED_WORKERS) {
    if (!activeTypes.has(requiredType)) {
      missingTypes.push(requiredType);
      self.postMessage({
        type: 'spawn-request',
        workerType: requiredType,
        reason: 'missing-required',
      });
    }
  }

  return { deadWorkers: deadWorkers.length, missingTypes };
}

/* ════════════════════════════════════════════════════════════════
   Fleet state
   ════════════════════════════════════════════════════════════════ */

function getFleetState() {
  const workers = {};
  let aliveCount = 0;
  let deadCount = 0;
  let totalRestarts = 0;

  for (const [id, worker] of fleet) {
    workers[id] = {
      id: worker.id,
      type: worker.type,
      status: worker.status,
      uptime: Date.now() - worker.registeredAt,
      lastReport: worker.lastReport,
      restartCount: worker.restartCount,
      metrics: worker.metrics,
    };

    if (worker.status === 'alive') aliveCount++;
    if (worker.status === 'dead') deadCount++;
    totalRestarts += worker.restartCount;
  }

  // Fleet coverage
  const activeTypes = new Set();
  for (const w of fleet.values()) {
    if (w.status === 'alive') activeTypes.add(w.type);
  }
  const coverage = REQUIRED_WORKERS.length > 0
    ? activeTypes.size / REQUIRED_WORKERS.length
    : 1;

  return {
    workers,
    totalWorkers: fleet.size,
    aliveCount,
    deadCount,
    totalRestarts,
    coverage,
    requiredTypes: REQUIRED_WORKERS.length,
    activeTypes: activeTypes.size,
  };
}

/* ════════════════════════════════════════════════════════════════
   Shutdown coordination — ordered worker termination
   ════════════════════════════════════════════════════════════════ */

function initiateShutdown() {
  // Shutdown order: micro → product → contract → crypto → telemetry →
  // sentinel → memory → brain → routing → download
  const shutdownOrder = [
    'micro', 'product', 'contract', 'crypto', 'telemetry',
    'sentinel', 'memory', 'brain', 'routing', 'download',
  ];

  const shutdownPlan = [];
  for (const type of shutdownOrder) {
    for (const [id, worker] of fleet) {
      if (worker.type === type && worker.status === 'alive') {
        shutdownPlan.push({ workerId: id, workerType: type });
      }
    }
  }

  // Request kills in order
  for (const target of shutdownPlan) {
    self.postMessage({
      type: 'kill-request',
      workerId: target.workerId,
      workerType: target.workerType,
      reason: 'ordered-shutdown',
    });
  }

  return shutdownPlan;
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'register': {
      const worker = registerWorker(msg.workerId, msg.workerType, msg.metadata);
      self.postMessage({ type: 'registered', ...worker });
      break;
    }

    case 'deregister': {
      const worker = deregisterWorker(msg.workerId);
      self.postMessage({ type: 'deregistered', workerId: msg.workerId, worker });
      break;
    }

    case 'healthReport': {
      const worker = updateHealth(msg.workerId, msg.status || 'alive', msg.metrics);
      if (!worker) {
        // Auto-register unknown workers
        registerWorker(msg.workerId, msg.workerType || 'unknown', msg.metrics);
      }
      break;
    }

    case 'requestRestart': {
      const worker = fleet.get(msg.workerId);
      if (worker) {
        worker.status = 'restarting';
        worker.restartCount++;
        self.postMessage({
          type: 'kill-request',
          workerId: msg.workerId,
          reason: 'manual-restart',
        });
        // Spawn request after kill
        self.postMessage({
          type: 'spawn-request',
          workerType: worker.type,
          reason: 'manual-restart',
          previousId: msg.workerId,
        });
      }
      break;
    }

    case 'getFleet':
      self.postMessage({ type: 'fleet-state', ...getFleetState() });
      break;

    case 'getState':
      self.postMessage({ type: 'infra-state', ...getFleetState() });
      break;

    case 'shutdown': {
      const plan = initiateShutdown();
      self.postMessage({ type: 'shutdown-initiated', plan });
      break;
    }

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (healthCheckInterval) clearInterval(healthCheckInterval);
      self.postMessage({ type: 'stopped', ...getFleetState() });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Health check loop — runs every 2s
   ════════════════════════════════════════════════════════════════ */

const healthCheckInterval = setInterval(function () {
  if (!running) return;
  healthCheck();
}, HEALTH_CHECK_INTERVAL);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const state = getFleetState();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    fleetSize: state.totalWorkers,
    aliveCount: state.aliveCount,
    coverage: state.coverage,
  });
}, HEARTBEAT);
