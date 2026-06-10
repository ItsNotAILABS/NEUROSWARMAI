/**
 * Workflow Worker — WORKFLOW-001–034: Proactive Workflow Execution Engine
 *
 * Manages and autonomously executes enterprise workflows across four
 * categories: trigger, transform, gate, and deliver. Schedules pending
 * workflows, optimises the execution graph, and reports execution results.
 *
 * Tool Registry (34 tools):
 *   Trigger   WORKFLOW-001–008  — event, cron, webhook, condition, signal, manual, batch, stream
 *   Transform WORKFLOW-009–017  — map, filter, reduce, enrich, split, merge, validate, normalise, aggregate
 *   Gate      WORKFLOW-018–025  — approve, reject, hold, route, branch, loop, retry, timeout
 *   Deliver   WORKFLOW-026–034  — notify, publish, store, archive, export, webhook-out, email, log, callback
 *
 * Proactive beats:
 *   Every 34 beats — auto-scan pending workflow queue and execute eligible entries
 *   Every 89 beats — optimise workflow dependency graph (PHI-weighted priority)
 *
 * Message types (in):
 *   query:workflows  — list all registered workflows
 *   query:status     — execution status for a given workflowId
 *   query:queue      — pending execution queue snapshot
 *   call:execute     — enqueue a workflow for execution
 *   call:pause       — pause an active workflow
 *   call:resume      — resume a paused workflow
 *   call:cancel      — cancel a pending / active workflow
 *   call:schedule    — schedule a future workflow execution
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873; // ms

// Fibonacci constants
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
const F18 = 2584;

const SCAN_INTERVAL  = F9;  // 34 beats — scan pending queue
const OPTIM_INTERVAL = F11; // 89 beats — optimise graph

let beatCount = 0;

/* ════════════════════════════════════════════════════════════════
   Tool Registry — 34 workflow tools in 4 categories
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  // Trigger category
  { id: 'WORKFLOW-001', name: 'eventTrigger',     category: 'trigger',    description: 'Fire workflow on named event' },
  { id: 'WORKFLOW-002', name: 'cronTrigger',      category: 'trigger',    description: 'Fire workflow on cron schedule' },
  { id: 'WORKFLOW-003', name: 'webhookTrigger',   category: 'trigger',    description: 'Fire workflow from inbound webhook' },
  { id: 'WORKFLOW-004', name: 'conditionTrigger', category: 'trigger',    description: 'Fire when boolean condition becomes true' },
  { id: 'WORKFLOW-005', name: 'signalTrigger',    category: 'trigger',    description: 'Fire on inter-workflow signal' },
  { id: 'WORKFLOW-006', name: 'manualTrigger',    category: 'trigger',    description: 'Fire on explicit user action' },
  { id: 'WORKFLOW-007', name: 'batchTrigger',     category: 'trigger',    description: 'Fire when batch threshold reached' },
  { id: 'WORKFLOW-008', name: 'streamTrigger',    category: 'trigger',    description: 'Fire on streaming data arrival' },
  // Transform category
  { id: 'WORKFLOW-009', name: 'mapTransform',     category: 'transform',  description: 'Map data items to new shape' },
  { id: 'WORKFLOW-010', name: 'filterTransform',  category: 'transform',  description: 'Filter items by predicate' },
  { id: 'WORKFLOW-011', name: 'reduceTransform',  category: 'transform',  description: 'Reduce items to aggregate value' },
  { id: 'WORKFLOW-012', name: 'enrichTransform',  category: 'transform',  description: 'Enrich items with external data' },
  { id: 'WORKFLOW-013', name: 'splitTransform',   category: 'transform',  description: 'Split payload into parallel branches' },
  { id: 'WORKFLOW-014', name: 'mergeTransform',   category: 'transform',  description: 'Merge parallel branch results' },
  { id: 'WORKFLOW-015', name: 'validateTransform',category: 'transform',  description: 'Validate payload against schema' },
  { id: 'WORKFLOW-016', name: 'normaliseTransform',category:'transform',  description: 'Normalise fields to standard form' },
  { id: 'WORKFLOW-017', name: 'aggregateTransform',category:'transform',  description: 'Aggregate grouped values' },
  // Gate category
  { id: 'WORKFLOW-018', name: 'approveGate',      category: 'gate',       description: 'Human or automated approval gate' },
  { id: 'WORKFLOW-019', name: 'rejectGate',       category: 'gate',       description: 'Reject flow and halt execution' },
  { id: 'WORKFLOW-020', name: 'holdGate',         category: 'gate',       description: 'Hold flow until condition clears' },
  { id: 'WORKFLOW-021', name: 'routeGate',        category: 'gate',       description: 'Route to one of N downstream steps' },
  { id: 'WORKFLOW-022', name: 'branchGate',       category: 'gate',       description: 'Conditional branch on field value' },
  { id: 'WORKFLOW-023', name: 'loopGate',         category: 'gate',       description: 'Loop step up to PHI*N iterations' },
  { id: 'WORKFLOW-024', name: 'retryGate',        category: 'gate',       description: 'Retry failed step with backoff' },
  { id: 'WORKFLOW-025', name: 'timeoutGate',      category: 'gate',       description: 'Timeout and fail after deadline' },
  // Deliver category
  { id: 'WORKFLOW-026', name: 'notifyDeliver',    category: 'deliver',    description: 'Send in-app notification' },
  { id: 'WORKFLOW-027', name: 'publishDeliver',   category: 'deliver',    description: 'Publish event to message bus' },
  { id: 'WORKFLOW-028', name: 'storeDeliver',     category: 'deliver',    description: 'Persist result to data store' },
  { id: 'WORKFLOW-029', name: 'archiveDeliver',   category: 'deliver',    description: 'Archive workflow run to cold storage' },
  { id: 'WORKFLOW-030', name: 'exportDeliver',    category: 'deliver',    description: 'Export result as file artifact' },
  { id: 'WORKFLOW-031', name: 'webhookOutDeliver',category: 'deliver',    description: 'POST result to outbound webhook' },
  { id: 'WORKFLOW-032', name: 'emailDeliver',     category: 'deliver',    description: 'Send email with workflow result' },
  { id: 'WORKFLOW-033', name: 'logDeliver',       category: 'deliver',    description: 'Write structured log entry' },
  { id: 'WORKFLOW-034', name: 'callbackDeliver',  category: 'deliver',    description: 'Invoke registered callback function' },
];

const toolMap = new Map(TOOL_REGISTRY.map(t => [t.id, t]));

/* ════════════════════════════════════════════════════════════════
   Workflow definitions (seed set)
   ════════════════════════════════════════════════════════════════ */

const workflowRegistry = new Map([
  ['WF-001', { id: 'WF-001', name: 'OnboardingFlow',    steps: ['WORKFLOW-001','WORKFLOW-009','WORKFLOW-018','WORKFLOW-026'], priority: PHI }],
  ['WF-002', { id: 'WF-002', name: 'DataIngestion',     steps: ['WORKFLOW-008','WORKFLOW-016','WORKFLOW-015','WORKFLOW-028'], priority: PHI * PHI }],
  ['WF-003', { id: 'WF-003', name: 'ComplianceScan',    steps: ['WORKFLOW-004','WORKFLOW-012','WORKFLOW-018','WORKFLOW-033'], priority: 1.0 }],
  ['WF-004', { id: 'WF-004', name: 'RevenueReport',     steps: ['WORKFLOW-002','WORKFLOW-011','WORKFLOW-017','WORKFLOW-030'], priority: PHI_INV }],
  ['WF-005', { id: 'WF-005', name: 'AlertDispatch',     steps: ['WORKFLOW-005','WORKFLOW-022','WORKFLOW-026','WORKFLOW-031'], priority: PHI * 2 }],
]);

/* ════════════════════════════════════════════════════════════════
   State
   ════════════════════════════════════════════════════════════════ */

const executionQueue = [];      // pending / scheduled
const activeExecutions = new Map();
const executionHistory = [];
const MAX_HISTORY = F18;        // 2584

const optimisationGraph = {
  edges: new Map(),             // workflowId → [dependsOn workflowId]
  weights: new Map(),           // workflowId → PHI-weighted score
  lastOptimised: 0,
};

let execCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Execution engine
   ════════════════════════════════════════════════════════════════ */

function createExecution(workflowId, payload = {}, scheduledAt = null) {
  const wf = workflowRegistry.get(workflowId);
  if (!wf) return null;
  const id = `EX-${Date.now()}-${++execCounter}`;
  return {
    id,
    workflowId,
    workflowName: wf.name,
    steps: [...wf.steps],
    currentStep: 0,
    status: scheduledAt ? 'scheduled' : 'pending',
    payload,
    scheduledAt,
    createdAt: Date.now(),
    startedAt: null,
    completedAt: null,
    results: [],
    phiWeight: wf.priority * Math.pow(PHI_INV, wf.steps.length),
  };
}

function advanceExecution(exec) {
  if (exec.status === 'paused' || exec.status === 'cancelled') return;
  if (exec.currentStep >= exec.steps.length) {
    exec.status = 'completed';
    exec.completedAt = Date.now();
    return;
  }
  const stepId = exec.steps[exec.currentStep];
  const tool = toolMap.get(stepId);
  const result = { step: stepId, tool: tool ? tool.name : stepId, ts: Date.now(), outcome: 'ok' };
  exec.results.push(result);
  exec.currentStep++;
  if (exec.currentStep >= exec.steps.length) {
    exec.status = 'completed';
    exec.completedAt = Date.now();
  }
}

function scanAndExecutePending() {
  const now = Date.now();
  const scheduled = executionQueue.filter(e => e.status === 'scheduled' && e.scheduledAt <= now);
  for (const ex of scheduled) ex.status = 'pending';

  const pending = executionQueue
    .filter(e => e.status === 'pending')
    .sort((a, b) => b.phiWeight - a.phiWeight)
    .slice(0, F8); // process up to 21 per scan

  for (const ex of pending) {
    ex.status = 'running';
    ex.startedAt = Date.now();
    activeExecutions.set(ex.id, ex);
    // Execute all steps synchronously (in-worker simulation)
    while (ex.status === 'running') advanceExecution(ex);
    activeExecutions.delete(ex.id);
    executionHistory.push({ ...ex });
    if (executionHistory.length > MAX_HISTORY) executionHistory.shift();
    const idx = executionQueue.indexOf(ex);
    if (idx !== -1) executionQueue.splice(idx, 1);
  }

  self.postMessage({
    type: 'workflow:scan-complete',
    scanned: pending.length,
    queueDepth: executionQueue.length,
    beat: beatCount,
    ts: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Graph optimisation — PHI-weighted topological sort
   ════════════════════════════════════════════════════════════════ */

function optimiseGraph() {
  let totalWeight = 0;
  for (const [id, wf] of workflowRegistry) {
    const w = wf.priority * Math.pow(PHI_INV, wf.steps.length);
    optimisationGraph.weights.set(id, w);
    totalWeight += w;
  }
  optimisationGraph.lastOptimised = Date.now();

  self.postMessage({
    type: 'workflow:graph-optimised',
    workflowCount: workflowRegistry.size,
    totalWeight: totalWeight.toFixed(6),
    beat: beatCount,
    ts: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Heartbeat
   ════════════════════════════════════════════════════════════════ */

setInterval(() => {
  beatCount++;

  if (beatCount % SCAN_INTERVAL === 0) scanAndExecutePending();
  if (beatCount % OPTIM_INTERVAL === 0) optimiseGraph();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    active: activeExecutions.size,
    queued: executionQueue.length,
    historySize: executionHistory.length,
    ts: Date.now(),
  });
}, PHI_BEAT);

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};

  switch (type) {

    case 'query:workflows':
      self.postMessage({
        type: 'result:workflows',
        workflows: [...workflowRegistry.values()],
        total: workflowRegistry.size,
        ts: Date.now(),
      });
      break;

    case 'query:status': {
      const { executionId } = payload;
      const active = activeExecutions.get(executionId);
      const historical = executionHistory.find(e => e.id === executionId);
      const queued = executionQueue.find(e => e.id === executionId);
      const found = active || historical || queued || null;
      self.postMessage({ type: 'result:status', execution: found, ts: Date.now() });
      break;
    }

    case 'query:queue':
      self.postMessage({
        type: 'result:queue',
        queue: executionQueue.map(e => ({
          id: e.id, workflowId: e.workflowId, status: e.status,
          scheduledAt: e.scheduledAt, phiWeight: e.phiWeight,
        })),
        depth: executionQueue.length,
        ts: Date.now(),
      });
      break;

    case 'call:execute': {
      const { workflowId, data } = payload;
      if (!workflowRegistry.has(workflowId)) {
        self.postMessage({ type: 'error', error: 'unknown_workflow', workflowId, ts: Date.now() });
        break;
      }
      const ex = createExecution(workflowId, data);
      executionQueue.push(ex);
      self.postMessage({ type: 'result:execute', executionId: ex.id, status: ex.status, ts: Date.now() });
      break;
    }

    case 'call:pause': {
      const { executionId } = payload;
      const ex = activeExecutions.get(executionId) || executionQueue.find(e => e.id === executionId);
      if (ex && ex.status === 'running') ex.status = 'paused';
      self.postMessage({ type: 'result:pause', executionId, paused: !!ex, ts: Date.now() });
      break;
    }

    case 'call:resume': {
      const { executionId } = payload;
      const ex = executionQueue.find(e => e.id === executionId);
      if (ex && ex.status === 'paused') ex.status = 'pending';
      self.postMessage({ type: 'result:resume', executionId, resumed: !!ex, ts: Date.now() });
      break;
    }

    case 'call:cancel': {
      const { executionId } = payload;
      const idx = executionQueue.findIndex(e => e.id === executionId);
      if (idx !== -1) { executionQueue[idx].status = 'cancelled'; executionQueue.splice(idx, 1); }
      const active = activeExecutions.get(executionId);
      if (active) { active.status = 'cancelled'; activeExecutions.delete(executionId); }
      self.postMessage({ type: 'result:cancel', executionId, ts: Date.now() });
      break;
    }

    case 'call:schedule': {
      const { workflowId, data, runAt } = payload;
      if (!workflowRegistry.has(workflowId)) {
        self.postMessage({ type: 'error', error: 'unknown_workflow', workflowId, ts: Date.now() });
        break;
      }
      const ex = createExecution(workflowId, data, runAt || Date.now() + PHI_BEAT * PHI);
      executionQueue.push(ex);
      self.postMessage({ type: 'result:schedule', executionId: ex.id, scheduledAt: ex.scheduledAt, ts: Date.now() });
      break;
    }

    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
