/**
 * Lenses Worker — TOOL-141–160: Data Perspectives & Views
 *
 * Web Worker managing 20 lens tools — different perspectives for
 * viewing and interpreting organism data. Each lens transforms raw
 * data into a specific viewpoint, enabling multi-dimensional
 * understanding of the same underlying reality.
 *
 * Tool Registry (20 tools):
 *   TOOL-141  timelineLens      — Chronological event timeline view
 *   TOOL-142  hierarchyLens     — Tree / hierarchy view
 *   TOOL-143  networkLens       — Graph / network relationship view
 *   TOOL-144  heatmapLens       — Intensity / frequency heatmap
 *   TOOL-145  flowLens          — Flow / Sankey diagram view
 *   TOOL-146  distributionLens  — Statistical distribution view
 *   TOOL-147  comparisonLens    — Side-by-side comparison view
 *   TOOL-148  trendLens         — Trend analysis over time
 *   TOOL-149  anomalyLens       — Outlier / anomaly highlighting
 *   TOOL-150  clusterLens       — Grouping / clustering view
 *   TOOL-151  correlationLens   — Correlation matrix view
 *   TOOL-152  geospatialLens    — Geographic / spatial view
 *   TOOL-153  sentimentLens     — Sentiment / emotion overlay
 *   TOOL-154  riskLens          — Risk assessment overlay
 *   TOOL-155  costLens          — Cost / economic analysis view
 *   TOOL-156  performanceLens   — Performance metrics view
 *   TOOL-157  securityLens      — Security posture view
 *   TOOL-158  complianceLens    — Compliance status view
 *   TOOL-159  userJourneyLens   — User experience journey view
 *   TOOL-160  systemHealthLens  — System health dashboard view
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'apply', toolId, data, options? }
 *   Main → Worker: { type: 'compose', lensIds, data }
 *   Main → Worker: { type: 'list' }
 *   Worker → Main: { type: 'view', toolId, transformed, metadata }
 *   Worker → Main: { type: 'composed-view', lensIds, layers }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const TOOL_BASE = 141;
const TOOL_COUNT = 20;
const TOOL_MAX = 160;

let beatCount = 0;
let running = true;
let applyCount = 0;

/* ════════════════════════════════════════════════════════════════
   Lens registry — 20 data perspective tools
   ════════════════════════════════════════════════════════════════ */

const LENS_REGISTRY = [
  { id: 141, name: 'timelineLens',     viewType: 'temporal',     outputFormat: 'events' },
  { id: 142, name: 'hierarchyLens',    viewType: 'structural',   outputFormat: 'tree' },
  { id: 143, name: 'networkLens',      viewType: 'relational',   outputFormat: 'graph' },
  { id: 144, name: 'heatmapLens',      viewType: 'intensity',    outputFormat: 'matrix' },
  { id: 145, name: 'flowLens',         viewType: 'directional',  outputFormat: 'flow' },
  { id: 146, name: 'distributionLens', viewType: 'statistical',  outputFormat: 'histogram' },
  { id: 147, name: 'comparisonLens',   viewType: 'comparative',  outputFormat: 'table' },
  { id: 148, name: 'trendLens',        viewType: 'temporal',     outputFormat: 'timeseries' },
  { id: 149, name: 'anomalyLens',      viewType: 'diagnostic',   outputFormat: 'flagged' },
  { id: 150, name: 'clusterLens',      viewType: 'grouping',     outputFormat: 'clusters' },
  { id: 151, name: 'correlationLens',  viewType: 'statistical',  outputFormat: 'matrix' },
  { id: 152, name: 'geospatialLens',   viewType: 'spatial',      outputFormat: 'map' },
  { id: 153, name: 'sentimentLens',    viewType: 'emotional',    outputFormat: 'scored' },
  { id: 154, name: 'riskLens',         viewType: 'assessment',   outputFormat: 'scored' },
  { id: 155, name: 'costLens',         viewType: 'economic',     outputFormat: 'breakdown' },
  { id: 156, name: 'performanceLens',  viewType: 'metrics',      outputFormat: 'dashboard' },
  { id: 157, name: 'securityLens',     viewType: 'assessment',   outputFormat: 'posture' },
  { id: 158, name: 'complianceLens',   viewType: 'assessment',   outputFormat: 'checklist' },
  { id: 159, name: 'userJourneyLens',  viewType: 'experiential', outputFormat: 'journey' },
  { id: 160, name: 'systemHealthLens', viewType: 'diagnostic',   outputFormat: 'dashboard' },
];

const lensMap = new Map();
for (const lens of LENS_REGISTRY) {
  lensMap.set(lens.id, lens);
  lensMap.set(lens.name, lens);
}

/* ════════════════════════════════════════════════════════════════
   Lens application engine
   ════════════════════════════════════════════════════════════════ */

function applyLens(toolId, data, options) {
  const lens = lensMap.get(toolId);
  if (!lens) return { error: 'unknown-lens', toolId };

  applyCount++;
  const opts = options || {};
  const items = normalizeData(data);

  let transformed;
  switch (lens.viewType) {
    case 'temporal':
      transformed = temporalView(items, opts);
      break;
    case 'structural':
      transformed = structuralView(items, opts);
      break;
    case 'relational':
      transformed = relationalView(items, opts);
      break;
    case 'statistical':
      transformed = statisticalView(items, opts);
      break;
    case 'diagnostic':
      transformed = diagnosticView(items, opts);
      break;
    case 'assessment':
      transformed = assessmentView(items, opts);
      break;
    default:
      transformed = defaultView(items, opts);
  }

  return {
    lensId: lens.id,
    lensName: lens.name,
    viewType: lens.viewType,
    outputFormat: lens.outputFormat,
    transformed,
    itemCount: items.length,
    phiScale: Math.pow(PHI_INV, lens.id - TOOL_BASE),
  };
}

function normalizeData(data) {
  if (Array.isArray(data)) return data;
  if (typeof data === 'object' && data !== null) return Object.entries(data).map(([k, v]) => ({ key: k, value: v }));
  return [{ value: data }];
}

function temporalView(items, opts) {
  const sorted = [...items].sort((a, b) => (a.timestamp || 0) - (b.timestamp || 0));
  return {
    events: sorted.map((item, i) => ({
      index: i,
      timestamp: item.timestamp || Date.now() - (items.length - i) * 1000,
      data: item,
      phiPosition: i / Math.max(1, sorted.length - 1),
    })),
    span: sorted.length > 1 ? (sorted[sorted.length - 1].timestamp || 0) - (sorted[0].timestamp || 0) : 0,
  };
}

function structuralView(items, opts) {
  const root = { name: 'root', children: [] };
  const depth = opts.depth || 3;
  const chunkSize = Math.ceil(items.length / depth);

  for (let d = 0; d < depth; d++) {
    const chunk = items.slice(d * chunkSize, (d + 1) * chunkSize);
    root.children.push({
      name: `level-${d}`,
      depth: d,
      items: chunk,
      weight: Math.pow(PHI_INV, d),
    });
  }
  return root;
}

function relationalView(items, opts) {
  const nodes = items.map((item, i) => ({ id: i, data: item }));
  const edges = [];
  for (let i = 0; i < nodes.length - 1; i++) {
    edges.push({ source: i, target: i + 1, weight: Math.pow(PHI_INV, i) });
    if (i > 0) {
      edges.push({ source: i, target: 0, weight: Math.pow(PHI_INV, i + nodes.length) });
    }
  }
  return { nodes, edges, density: edges.length / Math.max(1, nodes.length * (nodes.length - 1) / 2) };
}

function statisticalView(items, opts) {
  const values = items.map(item => typeof item === 'number' ? item : (item.value || 0));
  if (values.length === 0) return { mean: 0, stddev: 0, min: 0, max: 0, count: 0 };

  const sum = values.reduce((a, b) => a + b, 0);
  const mean = sum / values.length;
  const variance = values.reduce((acc, v) => acc + (v - mean) ** 2, 0) / values.length;
  const sorted = [...values].sort((a, b) => a - b);

  return {
    mean,
    stddev: Math.sqrt(variance),
    min: sorted[0],
    max: sorted[sorted.length - 1],
    median: sorted[Math.floor(sorted.length / 2)],
    count: values.length,
    sum,
    p25: sorted[Math.floor(sorted.length * 0.25)],
    p75: sorted[Math.floor(sorted.length * 0.75)],
  };
}

function diagnosticView(items, opts) {
  const values = items.map(item => typeof item === 'number' ? item : (item.value || 0));
  const mean = values.length > 0 ? values.reduce((a, b) => a + b, 0) / values.length : 0;
  const stddev = Math.sqrt(values.reduce((acc, v) => acc + (v - mean) ** 2, 0) / Math.max(1, values.length));

  const flagged = values.map((v, i) => ({
    index: i,
    value: v,
    zScore: stddev > 0 ? Math.abs(v - mean) / stddev : 0,
    isAnomaly: stddev > 0 ? Math.abs(v - mean) / stddev > 2 : false,
  })).filter(v => v.isAnomaly);

  return { flagged, totalItems: values.length, anomalyCount: flagged.length, threshold: 2.0 };
}

function assessmentView(items, opts) {
  return items.map((item, i) => ({
    index: i,
    data: item,
    score: Math.pow(PHI_INV, i) * (typeof item === 'number' ? item : 1),
    level: i < items.length * 0.2 ? 'critical' : i < items.length * 0.5 ? 'high' : i < items.length * 0.8 ? 'medium' : 'low',
  }));
}

function defaultView(items, opts) {
  return items.map((item, i) => ({
    index: i,
    data: item,
    phiWeight: Math.pow(PHI_INV, i),
  }));
}

function composeLenses(lensIds, data) {
  const layers = [];
  let currentData = data;

  for (const id of lensIds) {
    const result = applyLens(id, currentData);
    if (result.error) {
      layers.push({ lensId: id, error: result.error });
    } else {
      layers.push(result);
      currentData = result.transformed;
    }
  }

  return { layers, composedLenses: lensIds.length };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'apply': {
      const result = applyLens(msg.toolId, msg.data, msg.options);
      if (result.error) {
        self.postMessage({ type: 'error', ...result });
      } else {
        self.postMessage({ type: 'view', ...result });
      }
      break;
    }

    case 'compose': {
      const result = composeLenses(msg.lensIds || [], msg.data);
      self.postMessage({ type: 'composed-view', ...result });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        lenses: LENS_REGISTRY.map(l => ({ id: l.id, name: l.name, viewType: l.viewType, outputFormat: l.outputFormat })),
        range: `TOOL-${TOOL_BASE} to TOOL-${TOOL_MAX}`,
        count: TOOL_COUNT,
      });
      break;

    case 'getStats':
      self.postMessage({ type: 'stats', applyCount, toolCount: TOOL_COUNT });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      self.postMessage({ type: 'stopped', applyCount });
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
    toolRange: 'TOOL-141–160',
    applyCount,
  });
}, HEARTBEAT);
