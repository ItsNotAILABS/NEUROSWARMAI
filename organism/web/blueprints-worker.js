/**
 * Blueprints Worker — TOOL-101–120: Reusable Architecture Templates
 *
 * Web Worker managing 20 blueprint tools — reusable architecture
 * templates for building systems, workflows, and organism components.
 * Blueprints are parametric: they accept configuration and produce
 * fully-specified architecture documents.
 *
 * Tool Registry (20 tools):
 *   TOOL-101  microserviceBlueprint  — Microservice architecture template
 *   TOOL-102  eventDrivenBlueprint   — Event-driven system template
 *   TOOL-103  cqrsBlueprint          — CQRS + event sourcing template
 *   TOOL-104  dataLakeBlueprint      — Data lake / warehouse template
 *   TOOL-105  apiGatewayBlueprint    — API gateway + routing template
 *   TOOL-106  workerPoolBlueprint    — Worker pool / task queue template
 *   TOOL-107  pubsubBlueprint        — Pub/sub messaging template
 *   TOOL-108  stateMachineBlueprint  — Finite state machine template
 *   TOOL-109  pipelineBlueprint      — Data processing pipeline template
 *   TOOL-110  authFlowBlueprint      — Authentication / authorization flow
 *   TOOL-111  monitoringBlueprint    — Monitoring & alerting stack
 *   TOOL-112  cicdBlueprint          — CI/CD pipeline template
 *   TOOL-113  canaryBlueprint        — Canary / blue-green deployment
 *   TOOL-114  cacheLayerBlueprint    — Distributed cache layer
 *   TOOL-115  searchIndexBlueprint   — Full-text search index
 *   TOOL-116  mlPipelineBlueprint    — ML training / inference pipeline
 *   TOOL-117  graphDBBlueprint       — Graph database architecture
 *   TOOL-118  streamProcessBlueprint — Real-time stream processing
 *   TOOL-119  edgeComputeBlueprint   — Edge / fog computing template
 *   TOOL-120  blockchainBlueprint    — Blockchain / ledger template
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'generate', toolId, config }
 *   Main → Worker: { type: 'list' }
 *   Main → Worker: { type: 'validate', blueprintId, config }
 *   Worker → Main: { type: 'blueprint', toolId, blueprint, metadata }
 *   Worker → Main: { type: 'catalog', blueprints }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const TOOL_BASE = 101;
const TOOL_COUNT = 20;
const TOOL_MAX = 120;

let beatCount = 0;
let running = true;
let generateCount = 0;

/* ════════════════════════════════════════════════════════════════
   Blueprint registry — 20 architecture templates
   ════════════════════════════════════════════════════════════════ */

const BLUEPRINT_REGISTRY = [
  { id: 101, name: 'microserviceBlueprint',  domain: 'backend',    complexity: 'high' },
  { id: 102, name: 'eventDrivenBlueprint',   domain: 'messaging',  complexity: 'high' },
  { id: 103, name: 'cqrsBlueprint',          domain: 'backend',    complexity: 'high' },
  { id: 104, name: 'dataLakeBlueprint',      domain: 'data',       complexity: 'high' },
  { id: 105, name: 'apiGatewayBlueprint',    domain: 'networking', complexity: 'medium' },
  { id: 106, name: 'workerPoolBlueprint',    domain: 'compute',    complexity: 'medium' },
  { id: 107, name: 'pubsubBlueprint',        domain: 'messaging',  complexity: 'medium' },
  { id: 108, name: 'stateMachineBlueprint',  domain: 'logic',      complexity: 'medium' },
  { id: 109, name: 'pipelineBlueprint',      domain: 'data',       complexity: 'medium' },
  { id: 110, name: 'authFlowBlueprint',      domain: 'security',   complexity: 'high' },
  { id: 111, name: 'monitoringBlueprint',    domain: 'observability', complexity: 'medium' },
  { id: 112, name: 'cicdBlueprint',          domain: 'devops',     complexity: 'medium' },
  { id: 113, name: 'canaryBlueprint',        domain: 'devops',     complexity: 'high' },
  { id: 114, name: 'cacheLayerBlueprint',    domain: 'data',       complexity: 'medium' },
  { id: 115, name: 'searchIndexBlueprint',   domain: 'data',       complexity: 'medium' },
  { id: 116, name: 'mlPipelineBlueprint',    domain: 'ml',         complexity: 'high' },
  { id: 117, name: 'graphDBBlueprint',       domain: 'data',       complexity: 'high' },
  { id: 118, name: 'streamProcessBlueprint', domain: 'data',       complexity: 'high' },
  { id: 119, name: 'edgeComputeBlueprint',   domain: 'compute',    complexity: 'high' },
  { id: 120, name: 'blockchainBlueprint',    domain: 'ledger',     complexity: 'high' },
];

const blueprintMap = new Map();
for (const bp of BLUEPRINT_REGISTRY) {
  blueprintMap.set(bp.id, bp);
  blueprintMap.set(bp.name, bp);
}

/* ════════════════════════════════════════════════════════════════
   Blueprint generation engine
   ════════════════════════════════════════════════════════════════ */

function generateBlueprint(toolId, config) {
  const bp = blueprintMap.get(toolId);
  if (!bp) return { error: 'unknown-blueprint', toolId };

  generateCount++;
  const cfg = config || {};

  const blueprint = {
    id: `bp-${bp.id}-${generateCount}`,
    templateId: bp.id,
    name: bp.name,
    domain: bp.domain,
    complexity: bp.complexity,
    generatedAt: Date.now(),
    config: cfg,
    components: generateComponents(bp, cfg),
    connections: generateConnections(bp, cfg),
    constraints: generateConstraints(bp, cfg),
    phiScale: Math.pow(PHI_INV, bp.id - TOOL_BASE),
  };

  return blueprint;
}

function generateComponents(bp, cfg) {
  const baseComponents = {
    microserviceBlueprint: ['api-gateway', 'service-registry', 'load-balancer', 'service-mesh', 'config-server'],
    eventDrivenBlueprint: ['event-store', 'event-bus', 'projector', 'command-handler', 'saga-orchestrator'],
    cqrsBlueprint: ['command-bus', 'query-bus', 'event-store', 'read-model', 'write-model'],
    workerPoolBlueprint: ['task-queue', 'worker-pool', 'result-store', 'scheduler', 'health-monitor'],
    pubsubBlueprint: ['publisher', 'subscriber', 'topic-registry', 'dead-letter-queue', 'message-store'],
    stateMachineBlueprint: ['state-store', 'transition-engine', 'guard-evaluator', 'action-executor', 'history-log'],
    pipelineBlueprint: ['source', 'transform', 'filter', 'aggregate', 'sink'],
    monitoringBlueprint: ['metric-collector', 'alert-engine', 'dashboard', 'log-aggregator', 'trace-store'],
  };

  const components = baseComponents[bp.name] || ['input', 'processor', 'output', 'store', 'monitor'];
  const scale = cfg.scale || 1;

  return components.map((name, i) => ({
    name,
    type: bp.domain,
    index: i,
    replicas: Math.max(1, Math.round(scale * (1 + i * 0.2))),
    phiWeight: Math.pow(PHI_INV, i),
  }));
}

function generateConnections(bp, cfg) {
  const components = generateComponents(bp, cfg);
  const connections = [];
  for (let i = 0; i < components.length - 1; i++) {
    connections.push({
      from: components[i].name,
      to: components[i + 1].name,
      type: 'data-flow',
      weight: Math.pow(PHI_INV, i),
    });
  }
  // Add feedback loop from last to first
  if (components.length > 2) {
    connections.push({
      from: components[components.length - 1].name,
      to: components[0].name,
      type: 'feedback',
      weight: Math.pow(PHI_INV, components.length),
    });
  }
  return connections;
}

function generateConstraints(bp, cfg) {
  return {
    maxLatencyMs: cfg.maxLatencyMs || (bp.complexity === 'high' ? 500 : 200),
    minAvailability: cfg.minAvailability || 0.999,
    maxConcurrency: cfg.maxConcurrency || 1000,
    dataRetentionDays: cfg.dataRetentionDays || 90,
    securityLevel: cfg.securityLevel || (bp.domain === 'security' ? 'critical' : 'standard'),
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'generate': {
      const result = generateBlueprint(msg.toolId, msg.config);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      } else {
        self.postMessage({ type: 'blueprint', toolId: msg.toolId, blueprint: result, metadata: { generateCount } });
      }
      break;
    }

    case 'validate': {
      const bp = blueprintMap.get(msg.blueprintId || msg.toolId);
      const valid = !!bp;
      self.postMessage({ type: 'validated', toolId: msg.blueprintId, valid, errors: valid ? [] : ['Blueprint not found'] });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        blueprints: BLUEPRINT_REGISTRY.map(b => ({ id: b.id, name: b.name, domain: b.domain, complexity: b.complexity })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
      });
      break;

    case 'getStats':
      self.postMessage({ type: 'stats', generateCount, toolCount: TOOL_COUNT });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', generateCount });
      break;
  }
};

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
    toolRange: 'TOOL-101–120',
    generateCount,
  });
}, HEARTBEAT);
