/**
 * Telemetry Worker — System Metrics & Coherence Monitoring
 *
 * Web Worker that continuously monitors the organism's health across
 * all subsystems. Tracks coherence, drift, emergence, arousal, and
 * per-worker health. Computes rolling statistics and anomaly detection.
 *
 * Architecture:
 *   Metric collection — receives health reports from all workers
 *   Rolling windows — 60s, 300s, 3600s statistical windows
 *   Coherence tracking — Kuramoto R order parameter computation
 *   Anomaly detection — φ-scaled thresholds for alert generation
 *   Health scoring — composite organism health 0.0-1.0
 *
 * Tracked metrics:
 *   coherence    — brain region synchrony (0-1)
 *   emergence    — coherence × (1 - drift)
 *   arousal      — system activation level
 *   drift        — instability measure
 *   workerHealth — per-worker alive/dead + latency
 *   memoryLoad   — pattern count / max patterns
 *   busLoad      — signal queue depth / max
 *   cpuPressure  — estimated CPU time per tick
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'metric', source, name, value }
 *   Main → Worker: { type: 'workerReport', workerId, status, latency }
 *   Main → Worker: { type: 'getMetrics', window? }
 *   Main → Worker: { type: 'getHealth' }
 *   Worker → Main: { type: 'metrics', data, window }
 *   Worker → Main: { type: 'health', score, breakdown }
 *   Worker → Main: { type: 'anomaly', metric, value, threshold, severity }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;

let beatCount = 0;
let running = true;

/* ════════════════════════════════════════════════════════════════
   Metric storage — rolling windows
   ════════════════════════════════════════════════════════════════ */

const WINDOWS = {
  short: 60000,    // 60 seconds
  medium: 300000,  // 5 minutes
  long: 3600000,   // 1 hour
};

// Time-series buffers: metric name → array of { value, timestamp }
const timeSeries = new Map();

// Worker health registry
const workerRegistry = new Map();

// Anomaly thresholds (φ-scaled)
const THRESHOLDS = {
  coherence:    { low: PHI_INV * 0.5, high: 1.0, critical: 0.2 },
  emergence:    { low: 0.3, high: 1.0, critical: 0.1 },
  drift:        { low: 0.0, high: 0.6, critical: 0.8 },
  arousal:      { low: 0.1, high: 0.95, critical: 0.99 },
  memoryLoad:   { low: 0.0, high: 0.85, critical: 0.95 },
  busLoad:      { low: 0.0, high: 0.75, critical: 0.9 },
};

function recordMetric(source, name, value) {
  const key = source + '.' + name;
  if (!timeSeries.has(key)) {
    timeSeries.set(key, []);
  }

  const now = Date.now();
  const series = timeSeries.get(key);
  series.push({ value, timestamp: now });

  // Prune entries older than the longest window
  const cutoff = now - WINDOWS.long;
  while (series.length > 0 && series[0].timestamp < cutoff) {
    series.shift();
  }

  // Anomaly detection
  checkAnomaly(name, value);
}

function checkAnomaly(name, value) {
  const threshold = THRESHOLDS[name];
  if (!threshold) return;

  let severity = null;

  if (value < threshold.critical || (name === 'drift' && value > threshold.critical)) {
    severity = 'critical';
  } else if (value < threshold.low || value > threshold.high) {
    severity = 'warning';
  }

  if (severity) {
    self.postMessage({
      type: 'anomaly',
      metric: name,
      value,
      threshold,
      severity,
      timestamp: Date.now(),
    });
  }
}

/* ════════════════════════════════════════════════════════════════
   Statistics — rolling window computations
   ════════════════════════════════════════════════════════════════ */

function getWindowStats(key, windowMs) {
  const series = timeSeries.get(key);
  if (!series || series.length === 0) return null;

  const cutoff = Date.now() - windowMs;
  const windowed = series.filter(s => s.timestamp >= cutoff);
  if (windowed.length === 0) return null;

  const values = windowed.map(s => s.value);
  const count = values.length;
  const sum = values.reduce((a, b) => a + b, 0);
  const mean = sum / count;

  let variance = 0;
  let min = values[0];
  let max = values[0];
  for (const v of values) {
    variance += (v - mean) * (v - mean);
    if (v < min) min = v;
    if (v > max) max = v;
  }
  variance /= count;

  return {
    count,
    mean,
    stddev: Math.sqrt(variance),
    min,
    max,
    latest: values[values.length - 1],
  };
}

function getMetrics(windowName) {
  const windowMs = WINDOWS[windowName] || WINDOWS.short;
  const result = {};

  for (const key of timeSeries.keys()) {
    const stats = getWindowStats(key, windowMs);
    if (stats) result[key] = stats;
  }

  return result;
}

/* ════════════════════════════════════════════════════════════════
   Worker health tracking
   ════════════════════════════════════════════════════════════════ */

function updateWorkerHealth(workerId, status, latency) {
  workerRegistry.set(workerId, {
    status,
    latency: latency || 0,
    lastReport: Date.now(),
  });
}

function getWorkerHealth() {
  const now = Date.now();
  const workers = {};
  let aliveCount = 0;
  let totalLatency = 0;
  let workerCount = 0;

  for (const [id, info] of workerRegistry) {
    const age = now - info.lastReport;
    const alive = age < HEARTBEAT * 3; // 3 missed heartbeats = dead
    workers[id] = {
      status: alive ? info.status : 'dead',
      latency: info.latency,
      lastReport: info.lastReport,
      age,
      alive,
    };
    if (alive) aliveCount++;
    totalLatency += info.latency;
    workerCount++;
  }

  return {
    workers,
    aliveCount,
    totalCount: workerCount,
    meanLatency: workerCount > 0 ? totalLatency / workerCount : 0,
  };
}

/* ════════════════════════════════════════════════════════════════
   Composite health score
   ════════════════════════════════════════════════════════════════ */

function computeHealth() {
  const wh = getWorkerHealth();
  const workerScore = wh.totalCount > 0 ? wh.aliveCount / wh.totalCount : 0;

  // Get latest metrics
  const coherence = getLatest('brain.coherence');
  const emergence = getLatest('brain.emergence');
  const memoryLoad = getLatest('memory.memoryLoad');
  const busLoad = getLatest('routing.busLoad');

  // Composite: weighted average with φ-scaling
  const weights = {
    workers: PHI_INV,       // 0.618
    coherence: PHI_INV,     // 0.618
    emergence: 0.5,
    memory: 0.3,
    bus: 0.2,
  };

  let totalWeight = 0;
  let weighted = 0;

  if (workerScore !== null) { weighted += workerScore * weights.workers; totalWeight += weights.workers; }
  if (coherence !== null) { weighted += coherence * weights.coherence; totalWeight += weights.coherence; }
  if (emergence !== null) { weighted += emergence * weights.emergence; totalWeight += weights.emergence; }
  if (memoryLoad !== null) { weighted += (1 - memoryLoad) * weights.memory; totalWeight += weights.memory; }
  if (busLoad !== null) { weighted += (1 - busLoad) * weights.bus; totalWeight += weights.bus; }

  const score = totalWeight > 0 ? weighted / totalWeight : 0.5;

  return {
    score,
    breakdown: {
      workerScore,
      coherence,
      emergence,
      memoryLoad,
      busLoad,
    },
    workerHealth: wh,
  };
}

function getLatest(key) {
  const series = timeSeries.get(key);
  if (!series || series.length === 0) return null;
  return series[series.length - 1].value;
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'metric':
      recordMetric(msg.source, msg.name, msg.value);
      break;

    case 'workerReport':
      updateWorkerHealth(msg.workerId, msg.status, msg.latency);
      break;

    case 'getMetrics': {
      const data = getMetrics(msg.window || 'short');
      self.postMessage({ type: 'metrics', data, window: msg.window || 'short' });
      break;
    }

    case 'getHealth': {
      const health = computeHealth();
      self.postMessage({ type: 'health', ...health });
      break;
    }

    case 'getState':
      self.postMessage({
        type: 'telemetry-state',
        metricKeys: Array.from(timeSeries.keys()),
        workerCount: workerRegistry.size,
        health: computeHealth().score,
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', health: computeHealth() });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const health = computeHealth();
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    healthScore: health.score,
    workerCount: workerRegistry.size,
  });
}, HEARTBEAT);
