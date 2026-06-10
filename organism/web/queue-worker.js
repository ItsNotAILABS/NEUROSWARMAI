/**
 * Queue Worker — QUEUE-001–021: Async Job Queue & Priority Processing
 */
const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873;
const F8=21,F9=34,F10=55,F11=89,F12=144,F13=233,F14=377,F15=610,F16=987,F17=1597,F18=2584;
const PROCESS_INTERVAL = 1;
const RETRY_INTERVAL = F9;
let beatCount = 0, jobCounter = 0, execCounter = 0;

const TOOL_REGISTRY = [
  { id: 'QUEUE-001', name: 'enqueue',    category: 'core',    description: 'Add job to priority queue' },
  { id: 'QUEUE-002', name: 'dequeue',    category: 'core',    description: 'Pop highest-priority job' },
  { id: 'QUEUE-003', name: 'retry',      category: 'core',    description: 'Retry a failed job' },
  { id: 'QUEUE-004', name: 'deadLetter', category: 'core',    description: 'Move job to dead-letter queue' },
  { id: 'QUEUE-005', name: 'prioritize', category: 'core',    description: 'Re-score job priority' },
  { id: 'QUEUE-006', name: 'drain',      category: 'core',    description: 'Drain all pending jobs' },
  { id: 'QUEUE-007', name: 'pause',      category: 'control', description: 'Pause queue processing' },
  { id: 'QUEUE-008', name: 'resume',     category: 'control', description: 'Resume queue processing' },
  { id: 'QUEUE-009', name: 'cancel',     category: 'control', description: 'Cancel a pending job' },
  { id: 'QUEUE-010', name: 'inspect',    category: 'read',    description: 'Inspect a job by id' },
  { id: 'QUEUE-011', name: 'list',       category: 'read',    description: 'List queue contents' },
  { id: 'QUEUE-012', name: 'stats',      category: 'read',    description: 'Queue statistics' },
  { id: 'QUEUE-013', name: 'bulkEnqueue',category: 'core',    description: 'Enqueue multiple jobs atomically' },
  { id: 'QUEUE-014', name: 'schedule',   category: 'core',    description: 'Schedule job for future' },
  { id: 'QUEUE-015', name: 'tag',        category: 'core',    description: 'Tag job with labels' },
  { id: 'QUEUE-016', name: 'throttle',   category: 'control', description: 'Throttle job type rate' },
  { id: 'QUEUE-017', name: 'backpressure',category:'control', description: 'Apply backpressure signal' },
  { id: 'QUEUE-018', name: 'snapshot',   category: 'admin',   description: 'Snapshot queue state' },
  { id: 'QUEUE-019', name: 'restore',    category: 'admin',   description: 'Restore queue from snapshot' },
  { id: 'QUEUE-020', name: 'purge',      category: 'admin',   description: 'Purge dlq entries' },
  { id: 'QUEUE-021', name: 'health',     category: 'admin',   description: 'Queue health report' },
];

// Priority queue — max F18 jobs
const queue = [];
const dlq = [];
const MAX_QUEUE = F18;
const MAX_DLQ = F14;
const processingLog = [];
const MAX_LOG = F16;
let paused = false;

function makeJob({ type = 'generic', payload = {}, priority = 1.0, maxRetries = 3, runAt = null, tags = [] } = {}) {
  const id = `JOB-${Date.now()}-${++jobCounter}`;
  return { id, type, payload, priority, phiScore: priority * PHI, maxRetries, retries: 0, status: 'pending', tags, runAt: runAt || Date.now(), createdAt: Date.now() };
}

function enqueueJob(job) {
  if (queue.length >= MAX_QUEUE) {
    self.postMessage({ type: 'queue:backpressure', depth: queue.length, ts: Date.now() });
    return null;
  }
  queue.push(job);
  queue.sort((a, b) => b.phiScore - a.phiScore);
  return job;
}

function processNext() {
  if (paused) return null;
  const now = Date.now();
  const idx = queue.findIndex(j => j.status === 'pending' && j.runAt <= now);
  if (idx === -1) return null;
  const job = queue.splice(idx, 1)[0];
  job.status = 'completed';
  job.completedAt = now;
  const entry = { id: `EXEC-${++execCounter}`, jobId: job.id, type: job.type, status: 'ok', ts: now };
  processingLog.push(entry);
  if (processingLog.length > MAX_LOG) processingLog.shift();
  return job;
}

function retryFailed() {
  let retried = 0;
  for (const job of queue) {
    if (job.status === 'failed' && job.retries < job.maxRetries) {
      job.retries++;
      job.status = 'pending';
      job.phiScore = job.priority * Math.pow(PHI_INV, job.retries);
      job.runAt = Date.now() + Math.pow(2, job.retries) * PHI_BEAT;
      retried++;
    }
  }
  if (retried > 0) {
    queue.sort((a, b) => b.phiScore - a.phiScore);
    self.postMessage({ type: 'queue:retried', count: retried, beat: beatCount, ts: Date.now() });
  }
}

setInterval(() => {
  beatCount++;
  if (beatCount % RETRY_INTERVAL === 0) retryFailed();
  processNext();
  self.postMessage({ type: 'heartbeat', beat: beatCount, depth: queue.length, dlq: dlq.length, paused, ts: Date.now() });
}, PHI_BEAT);

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};
  switch (type) {
    case 'query:queue':
      self.postMessage({ type: 'result:queue', queue: queue.slice(0, F10), depth: queue.length, paused, ts: Date.now() });
      break;
    case 'query:jobs': {
      const { status, limit = F9 } = payload;
      const jobs = status ? queue.filter(j => j.status === status) : queue;
      self.postMessage({ type: 'result:jobs', jobs: jobs.slice(0, limit), total: jobs.length, ts: Date.now() });
      break;
    }
    case 'query:dlq':
      self.postMessage({ type: 'result:dlq', dlq, total: dlq.length, ts: Date.now() });
      break;
    case 'call:enqueue': {
      const job = makeJob(payload);
      const enqueued = enqueueJob(job);
      self.postMessage({ type: 'result:enqueue', jobId: enqueued ? job.id : null, depth: queue.length, ts: Date.now() });
      break;
    }
    case 'call:cancel': {
      const { jobId } = payload;
      const idx = queue.findIndex(j => j.id === jobId);
      if (idx !== -1) { queue[idx].status = 'cancelled'; queue.splice(idx, 1); }
      self.postMessage({ type: 'result:cancel', jobId, ts: Date.now() });
      break;
    }
    case 'call:retry': {
      const { jobId } = payload;
      const job = dlq.find(j => j.id === jobId) || queue.find(j => j.id === jobId);
      if (job) { job.status = 'pending'; job.retries++; enqueueJob(job); }
      self.postMessage({ type: 'result:retry', jobId, ts: Date.now() });
      break;
    }
    case 'call:drain': {
      const count = queue.length;
      queue.length = 0;
      self.postMessage({ type: 'result:drain', drained: count, ts: Date.now() });
      break;
    }
    case 'call:pause':
      paused = true;
      self.postMessage({ type: 'result:pause', paused, ts: Date.now() });
      break;
    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
