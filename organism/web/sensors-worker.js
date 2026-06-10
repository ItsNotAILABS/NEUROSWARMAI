/**
 * Sensors Worker — TOOL-221–240: Continuous Monitoring Probes
 *
 * Web Worker managing 20 sensor tools — continuous monitoring probes
 * that measure and report on various aspects of the organism's state.
 * Sensors run passively and emit readings at regular intervals.
 *
 * Tool Registry (20 tools):
 *   TOOL-221  cpuSensor           — CPU utilization monitoring
 *   TOOL-222  memorySensor        — Memory usage monitoring
 *   TOOL-223  latencySensor       — Request latency monitoring
 *   TOOL-224  throughputSensor    — Message throughput monitoring
 *   TOOL-225  errorRateSensor     — Error rate monitoring
 *   TOOL-226  coherenceSensor     — Brain coherence monitoring
 *   TOOL-227  emergenceSensor     — Emergence level monitoring
 *   TOOL-228  driftSensor         — System drift monitoring
 *   TOOL-229  arousalSensor       — Arousal level monitoring
 *   TOOL-230  entropyMeter        — System entropy measurement
 *   TOOL-231  networkSensor       — Network connectivity probe
 *   TOOL-232  storageSensor       — Storage utilization probe
 *   TOOL-233  queueDepthSensor    — Queue depth monitoring
 *   TOOL-234  workerLoadSensor    — Worker CPU load distribution
 *   TOOL-235  patternDensitySensor — Memory pattern density
 *   TOOL-236  signalStrengthSensor — Signal bus strength probe
 *   TOOL-237  chainHealthSensor   — ANIMA chain health monitoring
 *   TOOL-238  tokenFlowSensor     — FORMA token flow monitoring
 *   TOOL-239  heritageFieldSensor — Heritage node field strength
 *   TOOL-240  phiResonanceSensor  — φ-resonance frequency probe
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'enable', sensorId }
 *   Main → Worker: { type: 'disable', sensorId }
 *   Main → Worker: { type: 'reading', sensorId, value }
 *   Main → Worker: { type: 'getReadings', sensorId? }
 *   Main → Worker: { type: 'list' }
 *   Worker → Main: { type: 'sensor-reading', sensorId, value, unit, timestamp }
 *   Worker → Main: { type: 'sensor-alert', sensorId, value, threshold }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const SAMPLE_INTERVAL = 1000; // Sample sensors every 1s
const TOOL_BASE = 221;
const TOOL_COUNT = 20;
const TOOL_MAX = 240;
const MAX_READINGS = 144; // F12 readings per sensor

let beatCount = 0;
let running = true;
let totalReadings = 0;

/* ════════════════════════════════════════════════════════════════
   Sensor registry — 20 continuous monitoring probes
   ════════════════════════════════════════════════════════════════ */

const SENSOR_REGISTRY = [
  { id: 221, name: 'cpuSensor',            unit: 'percent',  min: 0, max: 100, alertThreshold: 85 },
  { id: 222, name: 'memorySensor',         unit: 'percent',  min: 0, max: 100, alertThreshold: 90 },
  { id: 223, name: 'latencySensor',        unit: 'ms',       min: 0, max: 5000, alertThreshold: 2000 },
  { id: 224, name: 'throughputSensor',     unit: 'msg/s',    min: 0, max: 10000, alertThreshold: 50 },
  { id: 225, name: 'errorRateSensor',      unit: 'percent',  min: 0, max: 100, alertThreshold: 5 },
  { id: 226, name: 'coherenceSensor',      unit: 'R',        min: 0, max: 1,   alertThreshold: 0.4 },
  { id: 227, name: 'emergenceSensor',      unit: 'level',    min: 0, max: 1,   alertThreshold: 0.3 },
  { id: 228, name: 'driftSensor',          unit: 'drift',    min: 0, max: 1,   alertThreshold: 0.5 },
  { id: 229, name: 'arousalSensor',        unit: 'level',    min: 0, max: 1,   alertThreshold: 0.9 },
  { id: 230, name: 'entropyMeter',         unit: 'bits',     min: 0, max: 10,  alertThreshold: 8 },
  { id: 231, name: 'networkSensor',        unit: 'status',   min: 0, max: 1,   alertThreshold: 0.5 },
  { id: 232, name: 'storageSensor',        unit: 'percent',  min: 0, max: 100, alertThreshold: 90 },
  { id: 233, name: 'queueDepthSensor',     unit: 'items',    min: 0, max: 1000, alertThreshold: 800 },
  { id: 234, name: 'workerLoadSensor',     unit: 'percent',  min: 0, max: 100, alertThreshold: 80 },
  { id: 235, name: 'patternDensitySensor', unit: 'patterns', min: 0, max: 144, alertThreshold: 130 },
  { id: 236, name: 'signalStrengthSensor', unit: 'dB',       min: -100, max: 0, alertThreshold: -80 },
  { id: 237, name: 'chainHealthSensor',    unit: 'status',   min: 0, max: 1,   alertThreshold: 0.5 },
  { id: 238, name: 'tokenFlowSensor',      unit: 'FORMA/s',  min: 0, max: 1000, alertThreshold: 10 },
  { id: 239, name: 'heritageFieldSensor',  unit: 'strength', min: 0, max: 2,   alertThreshold: 0.3 },
  { id: 240, name: 'phiResonanceSensor',   unit: 'Hz',       min: 0, max: 1000, alertThreshold: 100 },
];

const sensorMap = new Map();
for (const sensor of SENSOR_REGISTRY) {
  sensorMap.set(sensor.id, sensor);
  sensorMap.set(sensor.name, sensor);
}

// Sensor state: enabled/disabled + readings buffer
const sensorState = new Map();
for (const sensor of SENSOR_REGISTRY) {
  sensorState.set(sensor.id, {
    enabled: true,
    readings: [],
    lastValue: null,
    lastReading: null,
    alertActive: false,
  });
}

/* ════════════════════════════════════════════════════════════════
   Sensor reading & alerting
   ════════════════════════════════════════════════════════════════ */

function recordReading(sensorId, value) {
  const sensor = sensorMap.get(sensorId);
  if (!sensor) return { error: 'unknown-sensor', sensorId };

  const state = sensorState.get(sensor.id);
  if (!state || !state.enabled) return { skipped: true, reason: 'disabled' };

  const reading = {
    sensorId: sensor.id,
    name: sensor.name,
    value,
    unit: sensor.unit,
    timestamp: Date.now(),
    phiWeight: Math.pow(PHI_INV, sensor.id - TOOL_BASE),
  };

  state.readings.push(reading);
  if (state.readings.length > MAX_READINGS) state.readings.shift();
  state.lastValue = value;
  state.lastReading = Date.now();
  totalReadings++;

  // Check alert threshold
  let alert = false;
  if (sensor.id === 226 || sensor.id === 227 || sensor.id === 231 || sensor.id === 237) {
    // Low-is-bad sensors (coherence, emergence, network, chain health)
    alert = value < sensor.alertThreshold;
  } else if (sensor.id === 224) {
    // Throughput: low is bad
    alert = value < sensor.alertThreshold;
  } else if (sensor.id === 236) {
    // Signal strength: more negative is worse
    alert = value < sensor.alertThreshold;
  } else {
    // Standard: high-is-bad sensors
    alert = value > sensor.alertThreshold;
  }

  if (alert && !state.alertActive) {
    state.alertActive = true;
    self.postMessage({
      type: 'sensor-alert',
      sensorId: sensor.id,
      name: sensor.name,
      value,
      threshold: sensor.alertThreshold,
      unit: sensor.unit,
      timestamp: Date.now(),
    });
  } else if (!alert && state.alertActive) {
    state.alertActive = false;
    self.postMessage({
      type: 'sensor-clear',
      sensorId: sensor.id,
      name: sensor.name,
      value,
      timestamp: Date.now(),
    });
  }

  return reading;
}

function getReadings(sensorId) {
  if (sensorId !== undefined) {
    const sensor = sensorMap.get(sensorId);
    if (!sensor) return { error: 'unknown-sensor', sensorId };
    const state = sensorState.get(sensor.id);
    return {
      sensorId: sensor.id,
      name: sensor.name,
      readings: state ? state.readings.slice(-20) : [],
      lastValue: state ? state.lastValue : null,
      enabled: state ? state.enabled : false,
      alertActive: state ? state.alertActive : false,
    };
  }

  // All sensors summary
  const summary = [];
  for (const sensor of SENSOR_REGISTRY) {
    const state = sensorState.get(sensor.id);
    summary.push({
      id: sensor.id,
      name: sensor.name,
      enabled: state.enabled,
      lastValue: state.lastValue,
      readingCount: state.readings.length,
      alertActive: state.alertActive,
      unit: sensor.unit,
    });
  }
  return { sensors: summary, totalReadings };
}

/* ════════════════════════════════════════════════════════════════
   Simulated sensor sampling — generates readings
   ════════════════════════════════════════════════════════════════ */

function sampleAllSensors() {
  for (const sensor of SENSOR_REGISTRY) {
    const state = sensorState.get(sensor.id);
    if (!state || !state.enabled) continue;

    // Generate simulated value based on sensor type
    let value;
    const prev = state.lastValue;

    if (prev !== null) {
      // Random walk from previous value
      const range = sensor.max - sensor.min;
      const drift = (Math.random() - 0.5) * range * 0.05;
      value = Math.max(sensor.min, Math.min(sensor.max, prev + drift));
    } else {
      // Initial value at midpoint + noise
      const mid = (sensor.max + sensor.min) / 2;
      value = mid + (Math.random() - 0.5) * (sensor.max - sensor.min) * 0.2;
    }

    const reading = recordReading(sensor.id, value);
    if (reading && !reading.error && !reading.skipped) {
      self.postMessage({ type: 'sensor-reading', ...reading });
    }
  }
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'enable': {
      const state = sensorState.get(msg.sensorId);
      if (state) {
        state.enabled = true;
        self.postMessage({ type: 'sensor-enabled', sensorId: msg.sensorId });
      }
      break;
    }

    case 'disable': {
      const state = sensorState.get(msg.sensorId);
      if (state) {
        state.enabled = false;
        state.alertActive = false;
        self.postMessage({ type: 'sensor-disabled', sensorId: msg.sensorId });
      }
      break;
    }

    case 'reading': {
      const result = recordReading(msg.sensorId, msg.value);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      }
      break;
    }

    case 'getReadings': {
      const result = getReadings(msg.sensorId);
      self.postMessage({ type: 'readings', ...result });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        sensors: SENSOR_REGISTRY.map(s => ({
          id: s.id, name: s.name, unit: s.unit,
          min: s.min, max: s.max, alertThreshold: s.alertThreshold,
          enabled: sensorState.get(s.id).enabled,
        })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
      });
      break;

    case 'getStats':
      self.postMessage({
        type: 'stats',
        totalReadings,
        activeSensors: [...sensorState.values()].filter(s => s.enabled).length,
        alertCount: [...sensorState.values()].filter(s => s.alertActive).length,
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (sampleInterval) clearInterval(sampleInterval);
      self.postMessage({ type: 'stopped', totalReadings });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Sampling loop — runs every 1s
   ════════════════════════════════════════════════════════════════ */

const sampleInterval = setInterval(function () {
  if (!running) return;
  sampleAllSensors();
}, SAMPLE_INTERVAL);

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
    toolRange: 'TOOL-221–240',
    totalReadings,
    activeSensors: [...sensorState.values()].filter(s => s.enabled).length,
    alertCount: [...sensorState.values()].filter(s => s.alertActive).length,
  });
}, HEARTBEAT);
