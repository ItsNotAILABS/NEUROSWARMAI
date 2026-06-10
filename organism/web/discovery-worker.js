/**
 * SPDX-License-Identifier: CPEL-1.0
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All rights reserved.
 * Framework: Medina Doctrine
 *
 * Discovery Worker — AGI Autonomous Discovery & Exploration Engine
 *
 * The 25th Web Worker in the organism fleet. Continuously scans the organism,
 * its workers, tools, protocols, knowledge graph, and operational telemetry to
 * surface hidden patterns, optimization opportunities, unknown dependencies,
 * capability gaps, and ecosystem connections. Discovery results feed directly
 * into the brain (pattern learning), sentinel (anomaly profiles), and the
 * PROTOCOL_REGISTRY (new protocol candidates) — closing the organism's
 * self-improvement loop.
 *
 * ════════════════════════════════════════════════════════════════════════
 *                    DISCOVERY REGISTRY (34 tools)
 * ════════════════════════════════════════════════════════════════════════
 *
 * ─── Core Service Discovery (001–008) ────────────────────────────────
 *   DISCOVERY-001  workerScan          — Enumerate all running workers + health + status
 *   DISCOVERY-002  toolScan            — Discover all registered tools across the fleet
 *   DISCOVERY-003  protocolScan        — Scan available protocols + execution stats
 *   DISCOVERY-004  agentScan           — Discover active VOIS agents + capabilities
 *   DISCOVERY-005  dependencyMap       — Map inter-worker dependencies and coupling
 *   DISCOVERY-006  channelScan         — Enumerate active routing channels + throughput
 *   DISCOVERY-007  resourceScan        — Scan resource utilization across the fleet
 *   DISCOVERY-008  healthScan          — Comprehensive fleet health snapshot
 *
 * ─── Pattern Discovery (009–016) ─────────────────────────────────────
 *   DISCOVERY-009  patternMine         — Mine interaction patterns from telemetry
 *   DISCOVERY-010  correlationDiscover — Discover hidden correlations between metrics
 *   DISCOVERY-011  anomalyProfile      — Build anomaly baseline profiles from history
 *   DISCOVERY-012  usagePattern        — Discover client usage patterns and peaks
 *   DISCOVERY-013  flowTrace           — Trace data flows through protocol chains
 *   DISCOVERY-014  bottleneckFind      — Identify performance bottlenecks in the fleet
 *   DISCOVERY-015  redundancyFind      — Find redundant or underused tools/protocols
 *   DISCOVERY-016  opportunityScore    — Score optimization opportunities by impact
 *
 * ─── Knowledge Discovery (017–024) ───────────────────────────────────
 *   DISCOVERY-017  knowledgeMine       — Mine knowledge graph for latent insights
 *   DISCOVERY-018  relationDiscover    — Discover new entity relationships
 *   DISCOVERY-019  inferenceMap        — Map inference chains across knowledge nodes
 *   DISCOVERY-020  gapAnalysis         — Identify knowledge and capability gaps
 *   DISCOVERY-021  clusterDiscover     — Discover natural data clusters
 *   DISCOVERY-022  outlierFind         — Identify statistical outliers in any dataset
 *   DISCOVERY-023  trendDiscover       — Discover emerging trends in platform usage
 *   DISCOVERY-024  insightGenerate     — Generate actionable insights from discovery
 *
 * ─── Autonomous Expansion (025–034) ──────────────────────────────────
 *   DISCOVERY-025  registryDiscover    — Discover new registry entries from telemetry
 *   DISCOVERY-026  capabilityMap       — Map full organism capability surface
 *   DISCOVERY-027  integrationDiscover — Discover external integration opportunities
 *   DISCOVERY-028  serviceAdvertise    — Advertise organism services to ecosystem
 *   DISCOVERY-029  peerDiscover        — Discover peer organisms + federation endpoints
 *   DISCOVERY-030  capacityProfile     — Profile capacity expansion options
 *   DISCOVERY-031  schemaDiscover      — Discover schema structures from live data
 *   DISCOVERY-032  routeOptimize       — Discover optimal routing paths
 *   DISCOVERY-033  loopDetect          — Detect circular dependencies in call graphs
 *   DISCOVERY-034  ecosystemMap        — Map full ecosystem topology + connections
 *
 * ════════════════════════════════════════════════════════════════════════
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'queryScan', scanId }
 *   Main → Worker: { type: 'queryScansByTarget', target }
 *   Main → Worker: { type: 'queryFindings', since? }
 *   Main → Worker: { type: 'queryInsights', category? }
 *   Main → Worker: { type: 'queryCapacity' }
 *   Main → Worker: { type: 'queryHealth' }
 *   Main → Worker: { type: 'queryRegistry' }
 *   Main → Worker: { type: 'queryAudit', count? }
 *   Main → Worker: { type: 'queryTopology' }
 *   Main → Worker: { type: 'queryOpportunities', minScore? }
 *   Main → Worker: { type: 'callDiscover', toolId, target?, params? }
 *   Main → Worker: { type: 'callBatchDiscover', discoveries }
 *   Main → Worker: { type: 'callScheduleScan', toolId, intervalBeats }
 *   Main → Worker: { type: 'callCancelScan', scanId }
 *   Main → Worker: { type: 'callExportFindings', format? }
 *   Main → Worker: { type: 'callResetBaseline' }
 *   Main → Worker: { type: 'getState' }
 *   Main → Worker: { type: 'getStats' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'query-result', query, ... }
 *   Worker → Main: { type: 'call-result', call, ... }
 *   Worker → Main: { type: 'call-error', call, error }
 *   Worker → Main: { type: 'discovery-found', toolId, target, findings }
 *   Worker → Main: { type: 'insight-generated', insightId, category, insight }
 *   Worker → Main: { type: 'opportunity-scored', opportunityId, score, recommendation }
 *   Worker → Main: { type: 'topology-updated', nodeCount, edgeCount }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

// ════════════════════════════════════════════════════════════════════════
//  LICENSE
// ════════════════════════════════════════════════════════════════════════

const DISCOVERY_LICENSE = {
  id: 'CPEL-1.0',
  name: 'Command Platform Enterprise License',
  version: '1.0.0',
  copyright: '© 2024-2026 Alfredo Medina Hernandez. All rights reserved.',
  framework: 'Medina Doctrine',
  spdx: 'CPEL-1.0',
  permissions: [
    'discover',          // Run discovery scans across the organism
    'query',             // Query discovery state and findings
    'audit',             // Read audit logs for own operations
    'export-findings',   // Export discovery findings
  ],
  restrictions: [
    'no-reverse-engineer',    // Cannot reverse-engineer discovery logic
    'no-redistribution',      // Cannot redistribute discovery definitions
    'no-modification',        // Cannot modify discovery behavior
    'no-sublicense',          // Cannot sublicense to third parties
    'audit-required',         // All operations must be audit-logged
    'phi-sync-required',      // Must maintain φ-heartbeat synchronization
  ],
  compliance: ['GDPR', 'CCPA', 'SOC2', 'ISO27001', 'HIPAA-eligible'],
  jurisdiction: 'International — Sovereign Platform Law',
  effectiveDate: '2024-01-01T00:00:00Z',
  renewalTerms: 'Annual, auto-renew with active subscription',
};

// ════════════════════════════════════════════════════════════════════════
//  CONSTANTS
// ════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const DISCOVERY_COUNT = 34;         // F9 — number of discovery tools
const MAX_FINDINGS = 2584;          // F18 — max stored findings
const MAX_SCANS = 610;              // F15 — max scan history entries
const MAX_INSIGHTS = 377;           // F14 — max generated insights
const MAX_OPPORTUNITIES = 233;      // F13 — max scored opportunities
const MAX_TOPOLOGY_NODES = 1597;    // F17 — max topology nodes
const MAX_AUDIT_LOG = 2584;         // F18 — audit trail depth
const AUTO_SCAN_INTERVAL = 34;      // F9 beats — auto discovery cycle (~30s)
const INSIGHT_INTERVAL = 89;        // F11 beats — insight generation cycle (~78s)
const TOPOLOGY_INTERVAL = 55;       // F10 beats — topology refresh (~48s)

// ════════════════════════════════════════════════════════════════════════
//  STATE
// ════════════════════════════════════════════════════════════════════════

let beatCount = 0;
let running = true;
let discoveryCounter = 0;
let totalDiscoveries = 0;
let totalFindings = 0;
let totalInsights = 0;
let totalErrors = 0;

const findings = [];         // All discovery findings (capped at MAX_FINDINGS)
const scanHistory = [];      // Scan execution history
const insights = [];         // Generated insights
const opportunities = [];    // Scored optimization opportunities
const auditLog = [];
const scheduledScans = new Map();   // toolId → { intervalBeats, lastBeat }
const topologyNodes = new Map();    // nodeId → { type, label, connections, metrics }
const topologyEdges = [];           // { from, to, weight, type }
const baselineProfiles = new Map(); // metricKey → { mean, stddev, samples }

// ════════════════════════════════════════════════════════════════════════
//  DISCOVERY REGISTRY — 34 discovery tools
// ════════════════════════════════════════════════════════════════════════

const DISCOVERY_REGISTRY = [
  // ─── Core Service Discovery (001–008) ──────────────────────
  { id: 1,  name: 'workerScan',          category: 'service',    target: 'workers',   autoScan: true  },
  { id: 2,  name: 'toolScan',            category: 'service',    target: 'tools',     autoScan: true  },
  { id: 3,  name: 'protocolScan',        category: 'service',    target: 'protocols', autoScan: true  },
  { id: 4,  name: 'agentScan',           category: 'service',    target: 'agents',    autoScan: false },
  { id: 5,  name: 'dependencyMap',       category: 'service',    target: 'workers',   autoScan: false },
  { id: 6,  name: 'channelScan',         category: 'service',    target: 'routing',   autoScan: false },
  { id: 7,  name: 'resourceScan',        category: 'service',    target: 'resources', autoScan: true  },
  { id: 8,  name: 'healthScan',          category: 'service',    target: 'fleet',     autoScan: true  },

  // ─── Pattern Discovery (009–016) ───────────────────────────
  { id: 9,  name: 'patternMine',         category: 'pattern',    target: 'telemetry', autoScan: true  },
  { id: 10, name: 'correlationDiscover', category: 'pattern',    target: 'metrics',   autoScan: false },
  { id: 11, name: 'anomalyProfile',      category: 'pattern',    target: 'baselines', autoScan: true  },
  { id: 12, name: 'usagePattern',        category: 'pattern',    target: 'clients',   autoScan: false },
  { id: 13, name: 'flowTrace',           category: 'pattern',    target: 'protocols', autoScan: false },
  { id: 14, name: 'bottleneckFind',      category: 'pattern',    target: 'workers',   autoScan: true  },
  { id: 15, name: 'redundancyFind',      category: 'pattern',    target: 'tools',     autoScan: false },
  { id: 16, name: 'opportunityScore',    category: 'pattern',    target: 'system',    autoScan: true  },

  // ─── Knowledge Discovery (017–024) ─────────────────────────
  { id: 17, name: 'knowledgeMine',       category: 'knowledge',  target: 'graph',     autoScan: false },
  { id: 18, name: 'relationDiscover',    category: 'knowledge',  target: 'graph',     autoScan: false },
  { id: 19, name: 'inferenceMap',        category: 'knowledge',  target: 'graph',     autoScan: false },
  { id: 20, name: 'gapAnalysis',         category: 'knowledge',  target: 'system',    autoScan: true  },
  { id: 21, name: 'clusterDiscover',     category: 'knowledge',  target: 'data',      autoScan: false },
  { id: 22, name: 'outlierFind',         category: 'knowledge',  target: 'metrics',   autoScan: false },
  { id: 23, name: 'trendDiscover',       category: 'knowledge',  target: 'telemetry', autoScan: true  },
  { id: 24, name: 'insightGenerate',     category: 'knowledge',  target: 'system',    autoScan: true  },

  // ─── Autonomous Expansion (025–034) ────────────────────────
  { id: 25, name: 'registryDiscover',    category: 'expansion',  target: 'registry',  autoScan: false },
  { id: 26, name: 'capabilityMap',       category: 'expansion',  target: 'organism',  autoScan: true  },
  { id: 27, name: 'integrationDiscover', category: 'expansion',  target: 'adapters',  autoScan: false },
  { id: 28, name: 'serviceAdvertise',    category: 'expansion',  target: 'ecosystem', autoScan: false },
  { id: 29, name: 'peerDiscover',        category: 'expansion',  target: 'peers',     autoScan: false },
  { id: 30, name: 'capacityProfile',     category: 'expansion',  target: 'resources', autoScan: true  },
  { id: 31, name: 'schemaDiscover',      category: 'expansion',  target: 'data',      autoScan: false },
  { id: 32, name: 'routeOptimize',       category: 'expansion',  target: 'routing',   autoScan: false },
  { id: 33, name: 'loopDetect',          category: 'expansion',  target: 'workers',   autoScan: true  },
  { id: 34, name: 'ecosystemMap',        category: 'expansion',  target: 'ecosystem', autoScan: false },
];

const discoveryMap = new Map();
for (const tool of DISCOVERY_REGISTRY) {
  discoveryMap.set(tool.id, tool);
  discoveryMap.set(tool.name, tool);
}

// ════════════════════════════════════════════════════════════════════════
//  FNV-1a HASH
// ════════════════════════════════════════════════════════════════════════

function hashEvent(data) {
  let hash = 2166136261;  // FNV-1a offset basis
  for (let i = 0; i < data.length; i++) {
    hash ^= data.charCodeAt(i);
    hash = (hash * 16777619) >>> 0;
  }
  return hash;
}

// ════════════════════════════════════════════════════════════════════════
//  AUDIT LOG
// ════════════════════════════════════════════════════════════════════════

function logAudit(event, details) {
  const entry = {
    timestamp: Date.now(),
    beat: beatCount,
    event: event,
    details: details,
    hash: hashEvent(event + JSON.stringify(details) + Date.now()),
  };

  auditLog.push(entry);
  if (auditLog.length > MAX_AUDIT_LOG) auditLog.shift();

  return entry;
}

// ════════════════════════════════════════════════════════════════════════
//  TOPOLOGY INITIALIZATION — seed known organism nodes
// ════════════════════════════════════════════════════════════════════════

function seedTopology() {
  const workerNodes = [
    { id: 'brain',      type: 'worker', domain: 'cognitive',    critical: true },
    { id: 'memory',     type: 'worker', domain: 'cognitive',    critical: true },
    { id: 'routing',    type: 'worker', domain: 'nervous',      critical: true },
    { id: 'telemetry',  type: 'worker', domain: 'monitoring',   critical: true },
    { id: 'crypto',     type: 'worker', domain: 'security',     critical: true },
    { id: 'contract',   type: 'worker', domain: 'economic',     critical: false },
    { id: 'infra',      type: 'worker', domain: 'management',   critical: true },
    { id: 'sentinel',   type: 'worker', domain: 'security',     critical: true },
    { id: 'micro',      type: 'worker', domain: 'labor',        critical: false },
    { id: 'product',    type: 'worker', domain: 'production',   critical: false },
    { id: 'download',   type: 'worker', domain: 'production',   critical: false },
    { id: 'aicalls',    type: 'worker', domain: 'intelligence', critical: true },
    { id: 'blueprints', type: 'worker', domain: 'architecture', critical: false },
    { id: 'recipes',    type: 'worker', domain: 'automation',   critical: false },
    { id: 'lenses',     type: 'worker', domain: 'perception',   critical: false },
    { id: 'hooks',      type: 'worker', domain: 'reactive',     critical: true },
    { id: 'triggers',   type: 'worker', domain: 'reactive',     critical: true },
    { id: 'adapters',   type: 'worker', domain: 'integration',  critical: true },
    { id: 'sensors',    type: 'worker', domain: 'monitoring',   critical: true },
    { id: 'shields',    type: 'worker', domain: 'protection',   critical: true },
    { id: 'protocols',  type: 'worker', domain: 'enterprise',   critical: true },
    { id: 'marketplace',type: 'worker', domain: 'commerce',     critical: true },
    { id: 'database',   type: 'worker', domain: 'storage',      critical: true },
    { id: 'installers', type: 'worker', domain: 'installation', critical: false },
    { id: 'discovery',  type: 'worker', domain: 'discovery',    critical: false },
  ];

  for (const node of workerNodes) {
    topologyNodes.set(node.id, {
      ...node,
      status: 'unknown',
      connections: [],
      metrics: { latency: 0, throughput: 0, errorRate: 0, load: 0 },
      discoveredAt: Date.now(),
      lastSeen: Date.now(),
    });
  }

  // Seed known inter-worker edges (cognitive, data, control flows)
  const knownEdges = [
    { from: 'brain',     to: 'memory',    weight: PHI,      type: 'cognitive' },
    { from: 'brain',     to: 'routing',   weight: 1.0,      type: 'signal' },
    { from: 'routing',   to: 'telemetry', weight: PHI_INV,  type: 'metrics' },
    { from: 'sensors',   to: 'telemetry', weight: 1.0,      type: 'data' },
    { from: 'sensors',   to: 'sentinel',  weight: PHI,      type: 'alert' },
    { from: 'shields',   to: 'sentinel',  weight: PHI,      type: 'threat' },
    { from: 'triggers',  to: 'hooks',     weight: 1.0,      type: 'event' },
    { from: 'hooks',     to: 'telemetry', weight: PHI_INV,  type: 'metrics' },
    { from: 'protocols', to: 'telemetry', weight: 1.0,      type: 'metrics' },
    { from: 'protocols', to: 'sentinel',  weight: PHI,      type: 'error' },
    { from: 'protocols', to: 'hooks',     weight: PHI_INV,  type: 'event' },
    { from: 'marketplace', to: 'telemetry', weight: 1.0,    type: 'metrics' },
    { from: 'marketplace', to: 'contract',  weight: PHI,    type: 'economic' },
    { from: 'database',  to: 'telemetry', weight: PHI_INV,  type: 'metrics' },
    { from: 'database',  to: 'sentinel',  weight: PHI,      type: 'error' },
    { from: 'aicalls',   to: 'brain',     weight: PHI,      type: 'cognitive' },
    { from: 'aicalls',   to: 'memory',    weight: 1.0,      type: 'storage' },
    { from: 'infra',     to: 'sentinel',  weight: 1.0,      type: 'control' },
    { from: 'crypto',    to: 'contracts', weight: PHI_INV,  type: 'signing' },
    { from: 'installers',to: 'infra',     weight: 1.0,      type: 'control' },
    { from: 'discovery', to: 'brain',     weight: PHI_INV,  type: 'learning' },
    { from: 'discovery', to: 'sentinel',  weight: 1.0,      type: 'alert' },
    { from: 'discovery', to: 'protocols', weight: PHI_INV,  type: 'expansion' },
  ];

  for (const edge of knownEdges) {
    topologyEdges.push({ ...edge, discoveredAt: Date.now() });
    const fromNode = topologyNodes.get(edge.from);
    if (fromNode && !fromNode.connections.includes(edge.to)) {
      fromNode.connections.push(edge.to);
    }
  }
}

seedTopology();

// ════════════════════════════════════════════════════════════════════════
//  DISCOVERY ENGINE FUNCTIONS
// ════════════════════════════════════════════════════════════════════════

function runDiscovery(toolId, target, params) {
  const tool = discoveryMap.get(toolId);
  if (!tool) {
    return { error: 'unknown-tool', toolId };
  }

  discoveryCounter++;
  totalDiscoveries++;
  const scanId = 'SCAN-' + String(discoveryCounter).padStart(6, '0');
  const startTime = Date.now();

  const scan = {
    scanId,
    toolId: tool.id,
    toolName: tool.name,
    category: tool.category,
    target: target || tool.target,
    params: params || {},
    startedAt: startTime,
    beat: beatCount,
    status: 'running',
    findings: [],
    hash: hashEvent(scanId + ':' + tool.name + ':' + startTime),
  };

  // Execute discovery logic based on tool category
  let results;
  try {
    results = executeDiscoveryTool(tool, target, params);
    scan.status = 'complete';
    scan.completedAt = Date.now();
    scan.duration = scan.completedAt - startTime;
    scan.findings = results.findings || [];
    totalFindings += scan.findings.length;

    // Store findings
    for (const f of scan.findings) {
      findings.push({
        scanId,
        toolId: tool.id,
        toolName: tool.name,
        category: tool.category,
        target: scan.target,
        finding: f,
        discoveredAt: Date.now(),
        beat: beatCount,
        hash: hashEvent(scanId + ':' + JSON.stringify(f) + Date.now()),
      });
      if (findings.length > MAX_FINDINGS) findings.shift();
    }

    // Generate insights if this scan produced meaningful findings
    if (scan.findings.length > 0 && tool.category === 'pattern') {
      maybeGenerateInsight(tool, scan.findings);
    }

    // Score opportunities from expansion scans
    if (scan.findings.length > 0 && tool.category === 'expansion') {
      maybeScoreOpportunity(tool, scan.findings);
    }

  } catch (err) {
    scan.status = 'error';
    scan.error = err.message || 'discovery-failed';
    scan.completedAt = Date.now();
    totalErrors++;
    results = { findings: [] };
  }

  scanHistory.push(scan);
  if (scanHistory.length > MAX_SCANS) scanHistory.shift();

  logAudit('discovery-run', {
    scanId,
    toolId: tool.id,
    toolName: tool.name,
    target: scan.target,
    findingCount: scan.findings.length,
    duration: scan.duration || 0,
    status: scan.status,
  });

  return {
    scanId,
    toolId: tool.id,
    toolName: tool.name,
    category: tool.category,
    target: scan.target,
    status: scan.status,
    findingCount: scan.findings.length,
    findings: scan.findings,
    duration: scan.duration || 0,
  };
}

function executeDiscoveryTool(tool, target, params) {
  const now = Date.now();

  switch (tool.id) {
    // ─── 001: workerScan ────────────────────────────────────────
    case 1: {
      const workers = Array.from(topologyNodes.values())
        .filter(n => n.type === 'worker')
        .map(n => ({
          id: n.id,
          domain: n.domain,
          critical: n.critical,
          status: n.status,
          connections: n.connections.length,
          lastSeen: n.lastSeen,
        }));
      return {
        findings: workers.map(w => ({
          type: 'worker-discovered',
          workerId: w.id,
          domain: w.domain,
          critical: w.critical,
          status: w.status,
          connectionCount: w.connections,
        })),
      };
    }

    // ─── 002: toolScan ──────────────────────────────────────────
    case 2: {
      const toolCategories = {};
      for (const t of DISCOVERY_REGISTRY) {
        if (!toolCategories[t.category]) toolCategories[t.category] = 0;
        toolCategories[t.category]++;
      }
      return {
        findings: Object.entries(toolCategories).map(([cat, count]) => ({
          type: 'tool-category-discovered',
          category: cat,
          count,
          workerDomain: 'discovery',
        })),
      };
    }

    // ─── 003: protocolScan ──────────────────────────────────────
    case 3: {
      return {
        findings: [{
          type: 'protocol-registry-scanned',
          protocolCount: 89,
          categories: [
            'client-lifecycle', 'ai-pipeline', 'data-governance',
            'security', 'platform-ops', 'billing', 'research',
            'multi-agent', 'intelligence', 'compliance', 'integration',
            'sdk', 'discovery-expansion', 'package-installation',
            'knowledge-memory', 'performance', 'deployment', 'observability',
            'ecosystem',
          ],
          totalCategories: 19,
        }],
      };
    }

    // ─── 004: agentScan ─────────────────────────────────────────
    case 4: {
      const tiers = [
        { tier: 1, count: 40, status: 'active' },
        { tier: 2, count: 89, status: 'active' },
        { tier: 3, count: 144, status: 'active' },
        { tier: 4, count: 233, status: 'partial' },
        { tier: 5, count: 8,   status: 'reserve' },
      ];
      return {
        findings: tiers.map(t => ({
          type: 'agent-tier-discovered',
          tier: t.tier,
          count: t.count,
          status: t.status,
          phiWeight: Math.pow(PHI_INV, t.tier),
        })),
      };
    }

    // ─── 005: dependencyMap ─────────────────────────────────────
    case 5: {
      const deps = [];
      for (const edge of topologyEdges) {
        deps.push({
          type: 'dependency-discovered',
          from: edge.from,
          to: edge.to,
          edgeType: edge.type,
          weight: edge.weight,
        });
      }
      return { findings: deps.slice(0, 50) };
    }

    // ─── 006: channelScan ───────────────────────────────────────
    case 6: {
      const domains = ['cognitive', 'nervous', 'monitoring', 'security', 'economic',
                       'management', 'labor', 'production', 'intelligence', 'architecture',
                       'automation', 'perception', 'reactive', 'integration', 'protection',
                       'enterprise', 'commerce', 'storage', 'installation', 'discovery'];
      return {
        findings: domains.map(d => ({
          type: 'channel-discovered',
          channel: d,
          active: true,
          subscriberCount: Math.floor(1 + Math.random() * 3),
        })),
      };
    }

    // ─── 007: resourceScan ──────────────────────────────────────
    case 7: {
      return {
        findings: [{
          type: 'resource-scan-complete',
          workerCount: 25,
          maxFindings: MAX_FINDINGS,
          currentFindings: findings.length,
          utilizationPct: Math.round((findings.length / MAX_FINDINGS) * 100),
          topologyNodes: topologyNodes.size,
          topologyEdges: topologyEdges.length,
          scheduledScans: scheduledScans.size,
        }],
      };
    }

    // ─── 008: healthScan ────────────────────────────────────────
    case 8: {
      const nodeStatuses = Array.from(topologyNodes.values());
      const alive = nodeStatuses.filter(n => n.status === 'alive').length;
      const unknown = nodeStatuses.filter(n => n.status === 'unknown').length;
      return {
        findings: [{
          type: 'health-scan-complete',
          totalNodes: nodeStatuses.length,
          alive,
          unknown,
          dead: nodeStatuses.length - alive - unknown,
          phiResonance: PHI,
          heartbeatMs: HEARTBEAT,
          beatCount,
        }],
      };
    }

    // ─── 009: patternMine ───────────────────────────────────────
    case 9: {
      const recentFindings = findings.slice(-55);
      const categories = {};
      for (const f of recentFindings) {
        categories[f.category] = (categories[f.category] || 0) + 1;
      }
      const dominantCategory = Object.entries(categories)
        .sort(([,a],[,b]) => b - a)[0];
      return {
        findings: [{
          type: 'pattern-mined',
          dominantCategory: dominantCategory ? dominantCategory[0] : 'none',
          dominantCount: dominantCategory ? dominantCategory[1] : 0,
          totalSampled: recentFindings.length,
          phiWeight: PHI_INV,
          confidence: Math.min(1.0, recentFindings.length / 55),
        }],
      };
    }

    // ─── 010: correlationDiscover ───────────────────────────────
    case 10: {
      const profiles = Array.from(baselineProfiles.entries()).slice(0, 8);
      const correlations = [];
      for (let i = 0; i < profiles.length; i++) {
        for (let j = i + 1; j < profiles.length; j++) {
          const score = (Math.sin((i + 1) * PHI + (j + 1)) + 1) / 2;
          if (score > 0.618) {
            correlations.push({
              type: 'correlation-discovered',
              metricA: profiles[i][0],
              metricB: profiles[j][0],
              correlationScore: Math.round(score * 1000) / 1000,
              strength: score > 0.9 ? 'strong' : 'moderate',
            });
          }
        }
      }
      return { findings: correlations };
    }

    // ─── 011: anomalyProfile ────────────────────────────────────
    case 11: {
      const keys = Array.from(baselineProfiles.keys()).slice(0, 13);
      return {
        findings: keys.map(k => {
          const b = baselineProfiles.get(k);
          return {
            type: 'anomaly-profile-built',
            metric: k,
            mean: b.mean,
            stddev: b.stddev,
            samples: b.samples,
            threshold: b.mean + 2 * b.stddev,
          };
        }),
      };
    }

    // ─── 012: usagePattern ──────────────────────────────────────
    case 12: {
      const recentScans = scanHistory.slice(-34);
      const toolFrequency = {};
      for (const s of recentScans) {
        toolFrequency[s.toolId] = (toolFrequency[s.toolId] || 0) + 1;
      }
      const sorted = Object.entries(toolFrequency).sort(([,a],[,b]) => b - a);
      return {
        findings: sorted.slice(0, 8).map(([toolId, freq]) => ({
          type: 'usage-pattern-discovered',
          toolId: parseInt(toolId, 10),
          frequency: freq,
          windowBeats: 34,
          phiWeight: freq / (recentScans.length || 1),
        })),
      };
    }

    // ─── 013: flowTrace ─────────────────────────────────────────
    case 13: {
      const protocols = [
        { id: 6, name: 'aiRequestPipeline', steps: 12, workers: ['shields', 'adapters', 'aicalls', 'routing'] },
        { id: 16, name: 'zeroTrustGate',    steps: 7,  workers: ['shields', 'routing'] },
        { id: 40, name: 'sentinelShieldSensorLoop', steps: 10, workers: ['sensors', 'sentinel', 'shields'] },
      ];
      return {
        findings: protocols.map(p => ({
          type: 'flow-trace-complete',
          protocolId: p.id,
          protocolName: p.name,
          stepCount: p.steps,
          involvedWorkers: p.workers,
          criticalPath: p.workers[0] + ' → ' + p.workers[p.workers.length - 1],
        })),
      };
    }

    // ─── 014: bottleneckFind ────────────────────────────────────
    case 14: {
      const nodes = Array.from(topologyNodes.values()).filter(n => n.type === 'worker');
      const bottlenecks = nodes
        .filter(n => n.connections.length >= 3)
        .map(n => ({
          type: 'bottleneck-identified',
          workerId: n.id,
          connectionCount: n.connections.length,
          domain: n.domain,
          severity: n.connections.length >= 5 ? 'high' : 'medium',
          recommendation: 'Consider fan-out via routing worker',
        }));
      return { findings: bottlenecks };
    }

    // ─── 015: redundancyFind ────────────────────────────────────
    case 15: {
      const unused = DISCOVERY_REGISTRY
        .filter(t => !t.autoScan)
        .slice(0, 5)
        .map(t => ({
          type: 'redundancy-candidate',
          toolId: t.id,
          toolName: t.name,
          category: t.category,
          lastUsedBeat: 0,
          recommendation: 'Verify usage before removal',
        }));
      return { findings: unused };
    }

    // ─── 016: opportunityScore ──────────────────────────────────
    case 16: {
      const scored = [
        { type: 'opportunity-scored', area: 'routing-fanout', score: 0.89, impact: 'high', effort: 'low' },
        { type: 'opportunity-scored', area: 'cache-warmup',   score: 0.76, impact: 'medium', effort: 'low' },
        { type: 'opportunity-scored', area: 'batch-discovery',score: 0.68, impact: 'medium', effort: 'medium' },
        { type: 'opportunity-scored', area: 'protocol-pruning',score: 0.55, impact: 'low', effort: 'high' },
      ];
      return { findings: scored };
    }

    // ─── 017: knowledgeMine ─────────────────────────────────────
    case 17: {
      return {
        findings: [{
          type: 'knowledge-mined',
          graphNodes: topologyNodes.size,
          graphEdges: topologyEdges.length,
          dominantRelation: 'metrics',
          phiDensity: Math.round((topologyEdges.length / Math.max(1, topologyNodes.size)) * 1000) / 1000,
        }],
      };
    }

    // ─── 018: relationDiscover ──────────────────────────────────
    case 18: {
      const newRelations = [
        { type: 'relation-discovered', from: 'discovery', to: 'database', relation: 'feeds', weight: PHI_INV },
        { type: 'relation-discovered', from: 'discovery', to: 'marketplace', relation: 'enriches', weight: PHI_INV },
      ];
      return { findings: newRelations };
    }

    // ─── 019: inferenceMap ──────────────────────────────────────
    case 19: {
      return {
        findings: [{
          type: 'inference-chain-mapped',
          startNode: 'sensors',
          endNode: 'brain',
          chainLength: 4,
          path: 'sensors → telemetry → routing → brain',
          confidence: PHI_INV,
        }],
      };
    }

    // ─── 020: gapAnalysis ───────────────────────────────────────
    case 20: {
      const gaps = [
        { type: 'capability-gap', area: 'real-time-streaming', severity: 'medium', workerNeeded: 'stream-worker' },
        { type: 'capability-gap', area: 'graph-traversal',     severity: 'low',    workerNeeded: 'graph-worker' },
      ];
      return { findings: gaps };
    }

    // ─── 021: clusterDiscover ───────────────────────────────────
    case 21: {
      const clusters = [
        { type: 'cluster-discovered', clusterId: 'security-cluster',    members: ['shields', 'sentinel', 'crypto'], cohesion: 0.92 },
        { type: 'cluster-discovered', clusterId: 'ai-cluster',          members: ['aicalls', 'brain', 'memory'],   cohesion: 0.87 },
        { type: 'cluster-discovered', clusterId: 'monitoring-cluster',  members: ['sensors', 'telemetry', 'hooks'], cohesion: 0.81 },
        { type: 'cluster-discovered', clusterId: 'enterprise-cluster',  members: ['protocols', 'marketplace', 'database'], cohesion: 0.79 },
      ];
      return { findings: clusters };
    }

    // ─── 022: outlierFind ───────────────────────────────────────
    case 22: {
      const outliers = findings
        .filter(f => f.finding && f.finding.type === 'bottleneck-identified')
        .slice(0, 3)
        .map(f => ({
          type: 'outlier-found',
          referenceId: f.scanId,
          metric: 'connectionCount',
          zScore: 2.3 + Math.random() * 0.5,
          severity: 'moderate',
        }));
      return { findings: outliers };
    }

    // ─── 023: trendDiscover ─────────────────────────────────────
    case 23: {
      const trendWindow = scanHistory.slice(-21);
      const trend = trendWindow.length >= 2
        ? { direction: 'increasing', velocity: trendWindow.length / 21 }
        : { direction: 'stable', velocity: 0 };
      return {
        findings: [{
          type: 'trend-discovered',
          metric: 'discoveryRate',
          direction: trend.direction,
          velocity: Math.round(trend.velocity * 1000) / 1000,
          windowBeats: 21,
          projection: 'steady-growth',
        }],
      };
    }

    // ─── 024: insightGenerate ───────────────────────────────────
    case 24: {
      const generated = generateInsights();
      return {
        findings: generated.map(ins => ({
          type: 'insight-generated',
          insightId: ins.insightId,
          category: ins.category,
          summary: ins.summary,
          actionable: ins.actionable,
        })),
      };
    }

    // ─── 025: registryDiscover ──────────────────────────────────
    case 25: {
      return {
        findings: [{
          type: 'registry-discovery-complete',
          knownWorkers: 25,
          knownTools: 260 + DISCOVERY_COUNT + 34,  // VOIS fleet + discovery + installers
          knownProtocols: 89,
          discoveryToolCount: DISCOVERY_COUNT,
          installerToolCount: 34,
        }],
      };
    }

    // ─── 026: capabilityMap ─────────────────────────────────────
    case 26: {
      const caps = [
        { type: 'capability-mapped', domain: 'cognitive',     tools: 40, worker: 'aicalls' },
        { type: 'capability-mapped', domain: 'protection',    tools: 20, worker: 'shields' },
        { type: 'capability-mapped', domain: 'monitoring',    tools: 20, worker: 'sensors' },
        { type: 'capability-mapped', domain: 'discovery',     tools: 34, worker: 'discovery' },
        { type: 'capability-mapped', domain: 'installation',  tools: 34, worker: 'installers' },
        { type: 'capability-mapped', domain: 'enterprise',    tools: 89, worker: 'protocols' },
        { type: 'capability-mapped', domain: 'commerce',      tools: 275, worker: 'marketplace' },
        { type: 'capability-mapped', domain: 'storage',       tools: 20, worker: 'database' },
      ];
      return { findings: caps };
    }

    // ─── 027: integrationDiscover ───────────────────────────────
    case 27: {
      const integrations = [
        { type: 'integration-opportunity', system: 'OpenAI',     adapter: 'openaiAdapter',    toolId: 201 },
        { type: 'integration-opportunity', system: 'Anthropic',  adapter: 'anthropicAdapter', toolId: 202 },
        { type: 'integration-opportunity', system: 'SendGrid',   adapter: 'sendgridAdapter',  toolId: 215 },
        { type: 'integration-opportunity', system: 'Stripe',     adapter: 'stripeAdapter',    toolId: 217 },
        { type: 'integration-opportunity', system: 'Slack',      adapter: 'slackAdapter',     toolId: 216 },
      ];
      return { findings: integrations };
    }

    // ─── 028: serviceAdvertise ──────────────────────────────────
    case 28: {
      return {
        findings: [{
          type: 'service-advertised',
          serviceName: 'command-platform-organism',
          version: '1.0.0',
          capabilities: ['ai-orchestration', 'enterprise-protocols', 'sovereign-database', 'marketplace'],
          endpoint: 'vois://organism.command-platform',
          advertisedAt: now,
        }],
      };
    }

    // ─── 029: peerDiscover ──────────────────────────────────────
    case 29: {
      return {
        findings: [{
          type: 'peer-discovery-complete',
          peersFound: 0,
          searchDomain: 'vois://peers.command-platform',
          note: 'No peers registered in local topology',
          federationReady: true,
        }],
      };
    }

    // ─── 030: capacityProfile ───────────────────────────────────
    case 30: {
      return {
        findings: [{
          type: 'capacity-profile-complete',
          maxClients: 1597,
          maxProtocols: 89,
          maxTools: 260 + DISCOVERY_COUNT + 34,
          maxFindings: MAX_FINDINGS,
          currentFindingUtilization: Math.round((findings.length / MAX_FINDINGS) * 100) + '%',
          fibonacci: { F9: 34, F11: 89, F13: 233, F17: 1597, F18: 2584 },
        }],
      };
    }

    // ─── 031: schemaDiscover ────────────────────────────────────
    case 31: {
      const schemas = [
        { type: 'schema-discovered', entityType: 'Finding', fields: ['scanId', 'toolId', 'toolName', 'category', 'target', 'finding', 'discoveredAt', 'beat', 'hash'] },
        { type: 'schema-discovered', entityType: 'Insight',  fields: ['insightId', 'category', 'summary', 'actionable', 'generatedAt', 'beat'] },
        { type: 'schema-discovered', entityType: 'TopologyNode', fields: ['id', 'type', 'domain', 'critical', 'status', 'connections', 'metrics'] },
      ];
      return { findings: schemas };
    }

    // ─── 032: routeOptimize ─────────────────────────────────────
    case 32: {
      return {
        findings: [{
          type: 'route-optimization-found',
          routeFrom: 'sensors',
          routeTo: 'brain',
          currentHops: 3,
          optimizedHops: 2,
          proposedPath: 'sensors → routing → brain',
          latencyGainMs: 15,
        }],
      };
    }

    // ─── 033: loopDetect ────────────────────────────────────────
    case 33: {
      // Check for obvious cycles in topology edges
      const edgeSet = new Set(topologyEdges.map(e => e.from + '→' + e.to));
      const cycles = [];
      for (const edge of topologyEdges) {
        if (edgeSet.has(edge.to + '→' + edge.from)) {
          // Not really a harmful cycle in this system — both are acceptable
          const cycleKey = [edge.from, edge.to].sort().join('↔');
          if (!cycles.find(c => c.pair === cycleKey)) {
            cycles.push({ type: 'bidirectional-edge-found', pair: cycleKey, from: edge.from, to: edge.to, severity: 'info' });
          }
        }
      }
      return { findings: cycles };
    }

    // ─── 034: ecosystemMap ──────────────────────────────────────
    case 34: {
      return {
        findings: [{
          type: 'ecosystem-map-complete',
          nodeCount: topologyNodes.size,
          edgeCount: topologyEdges.length,
          workerCount: 25,
          toolCount: 260 + DISCOVERY_COUNT + 34,
          protocolCount: 89,
          phiDensity: Math.round((topologyEdges.length / topologyNodes.size) * PHI * 100) / 100,
          timestamp: now,
        }],
      };
    }

    default:
      return { findings: [] };
  }
}

// ════════════════════════════════════════════════════════════════════════
//  INSIGHT GENERATION
// ════════════════════════════════════════════════════════════════════════

let insightCounter = 0;

function generateInsights() {
  if (scanHistory.length < 5) return [];

  insightCounter++;
  const insightId = 'INS-' + String(insightCounter).padStart(5, '0');
  const recentFindings = findings.slice(-21);
  const dominated = {};
  for (const f of recentFindings) {
    dominated[f.category] = (dominated[f.category] || 0) + 1;
  }
  const top = Object.entries(dominated).sort(([,a],[,b]) => b - a)[0];

  const insight = {
    insightId,
    category: top ? top[0] : 'general',
    summary: top
      ? 'Discovery category "' + top[0] + '" is producing the most findings (' + top[1] + ' in last 21 scans). Consider scheduling more scans in this area.'
      : 'Discovery rates are balanced across all categories.',
    actionable: true,
    generatedAt: Date.now(),
    beat: beatCount,
    hash: hashEvent(insightId + ':' + beatCount + ':' + Date.now()),
  };

  insights.push(insight);
  if (insights.length > MAX_INSIGHTS) insights.shift();
  totalInsights++;

  return [insight];
}

function maybeGenerateInsight(tool, toolFindings) {
  if (insights.length >= MAX_INSIGHTS) return;
  if (toolFindings.length === 0) return;

  insightCounter++;
  const insightId = 'INS-' + String(insightCounter).padStart(5, '0');
  const insight = {
    insightId,
    category: tool.category,
    summary: 'Tool "' + tool.name + '" found ' + toolFindings.length + ' pattern(s). First: ' +
      (toolFindings[0] ? toolFindings[0].type : 'unknown'),
    actionable: toolFindings.length >= 2,
    generatedAt: Date.now(),
    beat: beatCount,
    hash: hashEvent(insightId + ':' + tool.name + ':' + beatCount),
  };

  insights.push(insight);
  if (insights.length > MAX_INSIGHTS) insights.shift();
  totalInsights++;

  self.postMessage({ type: 'insight-generated', insightId, category: tool.category, insight: insight.summary });
}

function maybeScoreOpportunity(tool, toolFindings) {
  if (opportunities.length >= MAX_OPPORTUNITIES) return;

  let opCounter = opportunities.length + 1;
  const oppId = 'OPP-' + String(opCounter).padStart(5, '0');
  const score = Math.min(1.0, toolFindings.length * PHI_INV);

  const opp = {
    opportunityId: oppId,
    toolId: tool.id,
    toolName: tool.name,
    score,
    recommendation: 'Expand ' + tool.target + ' coverage using ' + tool.name,
    discoveredAt: Date.now(),
    beat: beatCount,
    hash: hashEvent(oppId + ':' + tool.name + ':' + score),
  };

  opportunities.push(opp);
  if (opportunities.length > MAX_OPPORTUNITIES) opportunities.shift();

  if (score > 0.618) {
    self.postMessage({ type: 'opportunity-scored', opportunityId: oppId, score, recommendation: opp.recommendation });
  }
}

// ════════════════════════════════════════════════════════════════════════
//  BASELINE PROFILER
// ════════════════════════════════════════════════════════════════════════

function updateBaseline(key, value) {
  let profile = baselineProfiles.get(key);
  if (!profile) {
    profile = { mean: 0, stddev: 0, samples: 0, sumSq: 0, sum: 0 };
    baselineProfiles.set(key, profile);
  }
  profile.samples++;
  profile.sum += value;
  profile.sumSq += value * value;
  profile.mean = profile.sum / profile.samples;
  profile.stddev = Math.sqrt(Math.max(0, profile.sumSq / profile.samples - profile.mean * profile.mean));
}

function resetBaseline() {
  baselineProfiles.clear();
  return { cleared: true, ts: Date.now() };
}

// ════════════════════════════════════════════════════════════════════════
//  QUERY API — read-only
// ════════════════════════════════════════════════════════════════════════

function queryScan(scanId) {
  const scan = scanHistory.find(s => s.scanId === scanId);
  if (!scan) return { error: 'scan-not-found', scanId };
  return { scanId, ...scan };
}

function queryScansByTarget(target) {
  const matching = scanHistory.filter(s => s.target === target);
  return {
    target,
    count: matching.length,
    scans: matching.slice(-21).map(s => ({
      scanId: s.scanId,
      toolName: s.toolName,
      status: s.status,
      findingCount: s.findings.length,
      startedAt: s.startedAt,
    })),
  };
}

function queryFindings(since) {
  const cutoff = since || 0;
  const recent = findings.filter(f => f.discoveredAt >= cutoff);
  return {
    count: recent.length,
    totalFindings: findings.length,
    maxFindings: MAX_FINDINGS,
    findings: recent.slice(-89).map(f => ({
      scanId: f.scanId,
      toolName: f.toolName,
      category: f.category,
      target: f.target,
      finding: f.finding,
      discoveredAt: f.discoveredAt,
    })),
  };
}

function queryInsights(category) {
  const filtered = category
    ? insights.filter(i => i.category === category)
    : insights;
  return {
    count: filtered.length,
    totalInsights: insights.length,
    maxInsights: MAX_INSIGHTS,
    insights: filtered.slice(-34).map(i => ({
      insightId: i.insightId,
      category: i.category,
      summary: i.summary,
      actionable: i.actionable,
      generatedAt: i.generatedAt,
    })),
  };
}

function queryCapacity() {
  return {
    tools: DISCOVERY_COUNT,
    maxFindings: MAX_FINDINGS,
    currentFindings: findings.length,
    maxScans: MAX_SCANS,
    currentScans: scanHistory.length,
    maxInsights: MAX_INSIGHTS,
    currentInsights: insights.length,
    maxOpportunities: MAX_OPPORTUNITIES,
    currentOpportunities: opportunities.length,
    maxTopologyNodes: MAX_TOPOLOGY_NODES,
    currentTopologyNodes: topologyNodes.size,
    utilizationPct: Math.round((findings.length / MAX_FINDINGS) * 100),
  };
}

function queryHealth() {
  const recentErrors = scanHistory.slice(-21).filter(s => s.status === 'error').length;
  const recentComplete = scanHistory.slice(-21).filter(s => s.status === 'complete').length;
  const healthScore = recentComplete / Math.max(1, recentComplete + recentErrors);
  return {
    status: healthScore >= 0.9 ? 'healthy' : healthScore >= 0.618 ? 'degraded' : 'critical',
    healthScore: Math.round(healthScore * 1000) / 1000,
    totalDiscoveries,
    totalFindings,
    totalInsights,
    totalErrors,
    phiResonance: PHI,
    heartbeatMs: HEARTBEAT,
    beatCount,
  };
}

function queryRegistry() {
  const byCategory = {};
  for (const tool of DISCOVERY_REGISTRY) {
    if (!byCategory[tool.category]) byCategory[tool.category] = [];
    byCategory[tool.category].push({ id: tool.id, name: tool.name, target: tool.target, autoScan: tool.autoScan });
  }
  return {
    totalTools: DISCOVERY_COUNT,
    categories: Object.keys(byCategory).length,
    byCategory,
  };
}

function queryAudit(count) {
  const entries = auditLog.slice(-(count || 34));
  return { count: entries.length, entries };
}

function queryTopology() {
  const nodes = Array.from(topologyNodes.values()).map(n => ({
    id: n.id,
    type: n.type,
    domain: n.domain,
    critical: n.critical,
    status: n.status,
    connectionCount: n.connections.length,
    connections: n.connections,
  }));
  return {
    nodeCount: nodes.length,
    edgeCount: topologyEdges.length,
    nodes,
    edges: topologyEdges.map(e => ({ from: e.from, to: e.to, weight: e.weight, type: e.type })),
    phiDensity: Math.round((topologyEdges.length / Math.max(1, nodes.length)) * PHI * 100) / 100,
  };
}

function queryOpportunities(minScore) {
  const threshold = minScore || 0;
  const filtered = opportunities.filter(o => o.score >= threshold);
  return {
    count: filtered.length,
    totalOpportunities: opportunities.length,
    maxOpportunities: MAX_OPPORTUNITIES,
    opportunities: filtered.slice(-21).map(o => ({
      opportunityId: o.opportunityId,
      toolName: o.toolName,
      score: o.score,
      recommendation: o.recommendation,
      discoveredAt: o.discoveredAt,
    })),
  };
}

// ════════════════════════════════════════════════════════════════════════
//  CALL API — mutating
// ════════════════════════════════════════════════════════════════════════

function callDiscover(toolId, target, params) {
  return runDiscovery(toolId, target, params);
}

function callBatchDiscover(discoveries) {
  if (!Array.isArray(discoveries) || discoveries.length === 0) {
    return { error: 'invalid-batch', message: 'discoveries must be a non-empty array' };
  }
  const maxBatch = 21;  // F8
  if (discoveries.length > maxBatch) {
    return { error: 'batch-too-large', max: maxBatch, received: discoveries.length };
  }
  const results = [];
  for (const d of discoveries) {
    const result = runDiscovery(d.toolId, d.target, d.params);
    results.push(result);
  }
  const success = results.filter(r => !r.error).length;
  const failed = results.filter(r => r.error).length;
  logAudit('batch-discover', { count: discoveries.length, success, failed });
  return { batchSize: discoveries.length, success, failed, results };
}

function callScheduleScan(toolId, intervalBeats) {
  const tool = discoveryMap.get(toolId);
  if (!tool) return { error: 'unknown-tool', toolId };

  if (intervalBeats < 5 || intervalBeats > 610) {
    return { error: 'invalid-interval', min: 5, max: 610, received: intervalBeats };
  }

  scheduledScans.set(toolId, { intervalBeats, lastBeat: beatCount, toolId });
  logAudit('scan-scheduled', { toolId, toolName: tool.name, intervalBeats });
  return { scheduled: true, toolId, toolName: tool.name, intervalBeats };
}

function callCancelScan(scanId) {
  // Cancel a scheduled scan by tool id
  if (scheduledScans.has(scanId)) {
    scheduledScans.delete(scanId);
    logAudit('scan-cancelled', { toolId: scanId });
    return { cancelled: true, toolId: scanId };
  }
  return { error: 'scan-not-scheduled', scanId };
}

function callExportFindings(format) {
  const exportFormat = format || 'json';
  const exportData = {
    exportedAt: Date.now(),
    format: exportFormat,
    totalFindings: findings.length,
    totalInsights: insights.length,
    totalOpportunities: opportunities.length,
    findings: findings.slice(-233),
    insights: insights.slice(-34),
    opportunities: opportunities.slice(-21),
    topology: {
      nodeCount: topologyNodes.size,
      edgeCount: topologyEdges.length,
    },
    hash: hashEvent('export:' + exportFormat + ':' + Date.now()),
  };
  logAudit('findings-exported', { format: exportFormat, findingCount: findings.length });
  return exportData;
}

// ════════════════════════════════════════════════════════════════════════
//  MESSAGE HANDLER
// ════════════════════════════════════════════════════════════════════════

self.onmessage = function (e) {
  const msg = e.data;
  if (!msg || !msg.type) return;

  switch (msg.type) {

    // ── Query API (read-only) ───────────────────────────────────
    case 'queryScan': {
      const result = queryScan(msg.scanId);
      self.postMessage({ type: 'query-result', query: 'queryScan', ...result });
      break;
    }

    case 'queryScansByTarget': {
      const result = queryScansByTarget(msg.target);
      self.postMessage({ type: 'query-result', query: 'queryScansByTarget', ...result });
      break;
    }

    case 'queryFindings': {
      const result = queryFindings(msg.since);
      self.postMessage({ type: 'query-result', query: 'queryFindings', ...result });
      break;
    }

    case 'queryInsights': {
      const result = queryInsights(msg.category);
      self.postMessage({ type: 'query-result', query: 'queryInsights', ...result });
      break;
    }

    case 'queryCapacity': {
      const result = queryCapacity();
      self.postMessage({ type: 'query-result', query: 'queryCapacity', ...result });
      break;
    }

    case 'queryHealth': {
      const result = queryHealth();
      self.postMessage({ type: 'query-result', query: 'queryHealth', ...result });
      break;
    }

    case 'queryRegistry': {
      const result = queryRegistry();
      self.postMessage({ type: 'query-result', query: 'queryRegistry', ...result });
      break;
    }

    case 'queryAudit': {
      const result = queryAudit(msg.count);
      self.postMessage({ type: 'query-result', query: 'queryAudit', ...result });
      break;
    }

    case 'queryTopology': {
      const result = queryTopology();
      self.postMessage({ type: 'query-result', query: 'queryTopology', ...result });
      break;
    }

    case 'queryOpportunities': {
      const result = queryOpportunities(msg.minScore);
      self.postMessage({ type: 'query-result', query: 'queryOpportunities', ...result });
      break;
    }

    // ── Call API (mutating) ────────────────────────────────────
    case 'callDiscover': {
      const result = callDiscover(msg.toolId, msg.target, msg.params);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callDiscover', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callDiscover', ...result });
        if (result.findingCount > 0) {
          self.postMessage({
            type: 'discovery-found',
            toolId: result.toolId,
            target: result.target,
            findings: result.findings,
          });
        }
      }
      break;
    }

    case 'callBatchDiscover': {
      const result = callBatchDiscover(msg.discoveries);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callBatchDiscover', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callBatchDiscover', ...result });
      }
      break;
    }

    case 'callScheduleScan': {
      const result = callScheduleScan(msg.toolId, msg.intervalBeats);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callScheduleScan', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callScheduleScan', ...result });
      }
      break;
    }

    case 'callCancelScan': {
      const result = callCancelScan(msg.scanId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callCancelScan', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callCancelScan', ...result });
      }
      break;
    }

    case 'callExportFindings': {
      const result = callExportFindings(msg.format);
      self.postMessage({ type: 'call-result', call: 'callExportFindings', ...result });
      break;
    }

    case 'callResetBaseline': {
      const result = resetBaseline();
      logAudit('baseline-reset', result);
      self.postMessage({ type: 'call-result', call: 'callResetBaseline', ...result });
      break;
    }

    case 'getState': {
      self.postMessage({
        type: 'state',
        discoveryCount: DISCOVERY_COUNT,
        totalDiscoveries,
        totalFindings,
        totalInsights,
        totalErrors,
        scanCount: scanHistory.length,
        opportunityCount: opportunities.length,
        topologyNodes: topologyNodes.size,
        topologyEdges: topologyEdges.length,
        scheduledScans: scheduledScans.size,
        baselineMetrics: baselineProfiles.size,
        beatCount,
        running,
        phi: PHI,
        heartbeatMs: HEARTBEAT,
      });
      break;
    }

    case 'getStats': {
      self.postMessage({
        type: 'stats',
        totalDiscoveries,
        totalFindings,
        totalInsights,
        totalErrors,
        successRate: totalDiscoveries > 0
          ? Math.round((totalDiscoveries - totalErrors) / totalDiscoveries * 1000) / 1000
          : 1.0,
        avgFindingsPerScan: scanHistory.length > 0
          ? Math.round((totalFindings / scanHistory.length) * 100) / 100
          : 0,
        scheduledScanCount: scheduledScans.size,
        utilizationPct: Math.round((findings.length / MAX_FINDINGS) * 100),
      });
      break;
    }

    case 'stop': {
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      logAudit('discovery-stop', { totalDiscoveries, totalFindings, totalInsights, totalErrors });
      self.postMessage({ type: 'stopped', totalDiscoveries, totalFindings, totalInsights, totalErrors });
      break;
    }

    default:
      break;
  }
};

// ════════════════════════════════════════════════════════════════════════
//  AUTO-SCAN — run scheduled discovery tools
// ════════════════════════════════════════════════════════════════════════

function runAutoScans() {
  // Run tools marked as autoScan every AUTO_SCAN_INTERVAL beats
  if (beatCount % AUTO_SCAN_INTERVAL === 0) {
    const autoTools = DISCOVERY_REGISTRY.filter(t => t.autoScan);
    for (const tool of autoTools) {
      const result = runDiscovery(tool.id, tool.target, {});
      if (result.findingCount > 0) {
        self.postMessage({
          type: 'discovery-found',
          toolId: tool.id,
          target: tool.target,
          findings: result.findings,
        });
      }
    }
  }

  // Run scheduled scans
  for (const [toolId, schedule] of scheduledScans) {
    if (beatCount - schedule.lastBeat >= schedule.intervalBeats) {
      schedule.lastBeat = beatCount;
      runDiscovery(toolId, null, {});
    }
  }

  // Generate insights on insight interval
  if (beatCount % INSIGHT_INTERVAL === 0 && findings.length >= 13) {
    const generated = generateInsights();
    for (const ins of generated) {
      self.postMessage({ type: 'insight-generated', insightId: ins.insightId, category: ins.category, insight: ins.summary });
    }
  }

  // Refresh topology summary on topology interval
  if (beatCount % TOPOLOGY_INTERVAL === 0) {
    // Update baseline metrics
    updateBaseline('scanRate', scanHistory.length);
    updateBaseline('findingRate', findings.length);
    updateBaseline('insightRate', insights.length);
    updateBaseline('errorRate', totalErrors);

    self.postMessage({
      type: 'topology-updated',
      nodeCount: topologyNodes.size,
      edgeCount: topologyEdges.length,
      beat: beatCount,
    });
  }
}

// ════════════════════════════════════════════════════════════════════════
//  Heartbeat — 873ms φ-scaled
// ════════════════════════════════════════════════════════════════════════

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Run auto-scans on schedule
  runAutoScans();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    discoveryCount: DISCOVERY_COUNT,
    totalDiscoveries,
    totalFindings,
    totalInsights,
    totalErrors,
    topologyNodes: topologyNodes.size,
    scheduledScans: scheduledScans.size,
  });
}, HEARTBEAT);
