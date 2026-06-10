/**
 * Micro Worker — Lightweight Task Executor Pool
 *
 * Web Worker that processes small, independent tasks in batches.
 * Handles task decomposition, parallel execution, result aggregation,
 * and priority scheduling. The organism's fine-grained labor force.
 *
 * Architecture:
 *   Task queue — priority-sorted with φ-weighted scheduling
 *   Batch processing — processes up to 13 (F7) tasks per cycle
 *   Result aggregation — collects and merges partial results
 *   Task types — compute, transform, validate, aggregate, format
 *   Retry logic — failed tasks retry up to 3 times with backoff
 *
 * Task Types:
 *   compute    — mathematical/logical computation
 *   transform  — data transformation/mapping
 *   validate   — data validation/checking
 *   aggregate  — combine multiple data sources
 *   format     — output formatting/serialization
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'submit', task }
 *   Main → Worker: { type: 'submitBatch', tasks }
 *   Main → Worker: { type: 'cancel', taskId }
 *   Main → Worker: { type: 'getQueue' }
 *   Worker → Main: { type: 'result', taskId, result }
 *   Worker → Main: { type: 'batch-result', results }
 *   Worker → Main: { type: 'task-error', taskId, error, retries }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;
const PROCESS_INTERVAL = 50;     // Process queue every 50ms
const BATCH_SIZE = 13;            // F7 — tasks per processing cycle
const MAX_QUEUE = 377;            // F14 — back-pressure threshold
const MAX_RETRIES = 3;

let beatCount = 0;
let running = true;
let taskIdCounter = 0;
let completedCount = 0;
let failedCount = 0;

/* ════════════════════════════════════════════════════════════════
   Task queue
   ════════════════════════════════════════════════════════════════ */

const taskQueue = [];
const results = [];
const MAX_RESULTS = 89; // F11

function submitTask(task) {
  if (taskQueue.length >= MAX_QUEUE) {
    return { error: 'queue-full', queueSize: taskQueue.length, max: MAX_QUEUE };
  }

  const taskRecord = {
    id: ++taskIdCounter,
    type: task.type || 'compute',
    payload: task.payload,
    priority: task.priority || 1.0,
    submittedAt: Date.now(),
    retries: 0,
    status: 'pending',
    callback: task.callback,
  };

  taskQueue.push(taskRecord);
  // Sort by priority descending
  taskQueue.sort((a, b) => b.priority - a.priority);

  return taskRecord;
}

/* ════════════════════════════════════════════════════════════════
   Task executors
   ════════════════════════════════════════════════════════════════ */

function executeTask(task) {
  switch (task.type) {
    case 'compute':
      return executeCompute(task.payload);
    case 'transform':
      return executeTransform(task.payload);
    case 'validate':
      return executeValidate(task.payload);
    case 'aggregate':
      return executeAggregate(task.payload);
    case 'format':
      return executeFormat(task.payload);
    default:
      return executeCompute(task.payload);
  }
}

function executeCompute(payload) {
  // Generic computation — evaluate mathematical expressions
  if (!payload) return { result: null };

  if (payload.operation === 'phi-scale') {
    return { result: (payload.value || 0) * PHI };
  }
  if (payload.operation === 'fibonacci') {
    const n = payload.n || 10;
    let a = 0, b = 1;
    for (let i = 0; i < n; i++) {
      const temp = b;
      b = a + b;
      a = temp;
    }
    return { result: b };
  }
  if (payload.operation === 'coherence') {
    // Compute coherence from activation array
    const activations = payload.activations || [];
    if (activations.length === 0) return { result: 0 };
    const mean = activations.reduce((a, b) => a + b, 0) / activations.length;
    let variance = 0;
    for (const v of activations) variance += (v - mean) * (v - mean);
    return { result: 1 - Math.sqrt(variance / activations.length) };
  }
  if (payload.operation === 'hash') {
    let hash = 2166136261;
    const str = String(payload.value || '');
    for (let i = 0; i < str.length; i++) {
      hash ^= str.charCodeAt(i);
      hash = (hash * 16777619) >>> 0;
    }
    return { result: hash };
  }

  return { result: payload };
}

function executeTransform(payload) {
  if (!payload || !payload.data) return { result: null };

  if (payload.operation === 'map' && payload.fn === 'phi-scale') {
    return { result: payload.data.map(v => v * PHI) };
  }
  if (payload.operation === 'filter' && payload.threshold !== undefined) {
    return { result: payload.data.filter(v => v >= payload.threshold) };
  }
  if (payload.operation === 'sort') {
    return { result: [...payload.data].sort((a, b) => a - b) };
  }
  if (payload.operation === 'normalize') {
    const max = Math.max(...payload.data);
    const min = Math.min(...payload.data);
    const range = max - min;
    return { result: range > 0 ? payload.data.map(v => (v - min) / range) : payload.data };
  }

  return { result: payload.data };
}

function executeValidate(payload) {
  if (!payload) return { valid: false, error: 'no-payload' };

  if (payload.rule === 'range') {
    const inRange = payload.value >= (payload.min || 0) && payload.value <= (payload.max || 1);
    return { valid: inRange, value: payload.value, min: payload.min, max: payload.max };
  }
  if (payload.rule === 'non-empty') {
    return { valid: payload.value !== null && payload.value !== undefined && payload.value !== '' };
  }
  if (payload.rule === 'phi-ratio') {
    // Check if value is within 1% of a phi ratio
    const ratio = payload.value / (payload.reference || 1);
    const phiMatch = Math.abs(ratio - PHI) < 0.02;
    return { valid: phiMatch, ratio, phi: PHI };
  }

  return { valid: true };
}

function executeAggregate(payload) {
  if (!payload || !payload.values) return { result: null };

  const values = payload.values;
  const operation = payload.operation || 'sum';

  switch (operation) {
    case 'sum': return { result: values.reduce((a, b) => a + b, 0) };
    case 'mean': return { result: values.reduce((a, b) => a + b, 0) / values.length };
    case 'max': return { result: Math.max(...values) };
    case 'min': return { result: Math.min(...values) };
    case 'count': return { result: values.length };
    default: return { result: values };
  }
}

function executeFormat(payload) {
  if (!payload) return { result: '' };

  if (payload.format === 'json') {
    return { result: JSON.stringify(payload.data, null, payload.indent || 0) };
  }
  if (payload.format === 'csv') {
    if (Array.isArray(payload.data)) {
      return { result: payload.data.join(',') };
    }
    return { result: String(payload.data) };
  }
  if (payload.format === 'hex') {
    return { result: (payload.value >>> 0).toString(16) };
  }

  return { result: String(payload.data || payload.value || '') };
}

/* ════════════════════════════════════════════════════════════════
   Queue processor
   ════════════════════════════════════════════════════════════════ */

function processQueue() {
  const batch = taskQueue.splice(0, BATCH_SIZE);
  const batchResults = [];

  for (const task of batch) {
    try {
      const result = executeTask(task);
      task.status = 'completed';
      completedCount++;

      const taskResult = {
        taskId: task.id,
        type: task.type,
        result,
        completedAt: Date.now(),
        duration: Date.now() - task.submittedAt,
      };

      batchResults.push(taskResult);
      results.push(taskResult);
      if (results.length > MAX_RESULTS) results.shift();

      self.postMessage({ type: 'result', ...taskResult });

    } catch (err) {
      task.retries++;
      if (task.retries < MAX_RETRIES) {
        task.status = 'retry';
        taskQueue.push(task); // Re-queue for retry
      } else {
        task.status = 'failed';
        failedCount++;
        self.postMessage({
          type: 'task-error',
          taskId: task.id,
          error: err.message,
          retries: task.retries,
        });
      }
    }
  }

  if (batchResults.length > 1) {
    self.postMessage({ type: 'batch-result', results: batchResults, count: batchResults.length });
  }

  return batchResults.length;
}

/* ════════════════════════════════════════════════════════════════
   State
   ════════════════════════════════════════════════════════════════ */

function getState() {
  return {
    queueSize: taskQueue.length,
    maxQueue: MAX_QUEUE,
    completedCount,
    failedCount,
    totalSubmitted: taskIdCounter,
    resultBufferSize: results.length,
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'submit': {
      const task = submitTask(msg.task || msg);
      if (task.error) {
        self.postMessage({ type: 'submit-error', ...task });
      } else {
        self.postMessage({ type: 'submitted', taskId: task.id, queueSize: taskQueue.length });
      }
      break;
    }

    case 'submitBatch': {
      const submitted = [];
      for (const t of (msg.tasks || [])) {
        const task = submitTask(t);
        if (!task.error) submitted.push(task.id);
      }
      self.postMessage({ type: 'batch-submitted', count: submitted.length, taskIds: submitted });
      break;
    }

    case 'cancel': {
      const idx = taskQueue.findIndex(t => t.id === msg.taskId);
      if (idx >= 0) {
        taskQueue.splice(idx, 1);
        self.postMessage({ type: 'cancelled', taskId: msg.taskId });
      }
      break;
    }

    case 'getQueue':
      self.postMessage({
        type: 'queue-state',
        queue: taskQueue.map(t => ({ id: t.id, type: t.type, priority: t.priority, status: t.status })),
        ...getState(),
      });
      break;

    case 'getState':
      self.postMessage({ type: 'micro-state', ...getState() });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (processInterval) clearInterval(processInterval);
      self.postMessage({ type: 'stopped', ...getState() });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Auto-process — drain queue every 50ms
   ════════════════════════════════════════════════════════════════ */

const processInterval = setInterval(function () {
  if (!running) return;
  if (taskQueue.length > 0) processQueue();
}, PROCESS_INTERVAL);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  const state = getState();
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
