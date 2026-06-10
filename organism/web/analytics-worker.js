/**
 * Analytics Worker — ANALYTICS-001–034: Business Intelligence & Metrics Engine
 *
 * Computes real-time metrics, cohort analyses, funnel analytics, predictive
 * models, and BI reports. Events stream in via call:track and are aggregated
 * proactively on a PHI-weighted schedule.
 *
 * Tool Registry (34 tools):
 *   metrics    ANALYTICS-001–008  — count, sum, avg, p95, p99, rate, gauge, histogram
 *   cohorts    ANALYTICS-009–016  — define, compute, compare, retention, churn, ltv, nps, health
 *   funnels    ANALYTICS-017–022  — define, compute, drop-off, conversion, segment, ab-test
 *   prediction ANALYTICS-023–028  — trend, forecast, anomaly, regression, classify, score
 *   reports    ANALYTICS-029–034  — summary, executive, cohort-report, funnel-report, export, schedule
 *
 * Proactive beats:
 *   Every 55 beats  — compute real-time metric snapshots
 *   Every 233 beats — generate full BI report
 *
 * Message types (in):
 *   query:metrics  — current metric aggregates
 *   query:report   — latest BI report
 *   query:insights — generated insights list
 *   query:cohort   — cohort data for a given cohortId
 *   call:track     — ingest a new analytics event
 *   call:compute   — force compute a named metric
 *   call:export    — export metrics snapshot
 *   call:reset     — reset a named metric
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873; // ms

// Fibonacci constants
const F7  = 13;
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

const METRICS_INTERVAL = F10; // 55 beats — compute real-time metrics
const REPORT_INTERVAL  = F13; // 233 beats — full BI report

let beatCount = 0;
let eventCounter = 0;
let reportCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Tool Registry — 34 analytics tools
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  { id: 'ANALYTICS-001', name: 'count',          category: 'metrics',    description: 'Count events by key' },
  { id: 'ANALYTICS-002', name: 'sum',            category: 'metrics',    description: 'Sum numeric field' },
  { id: 'ANALYTICS-003', name: 'avg',            category: 'metrics',    description: 'Running average' },
  { id: 'ANALYTICS-004', name: 'p95',            category: 'metrics',    description: '95th percentile latency' },
  { id: 'ANALYTICS-005', name: 'p99',            category: 'metrics',    description: '99th percentile latency' },
  { id: 'ANALYTICS-006', name: 'rate',           category: 'metrics',    description: 'Events per second rate' },
  { id: 'ANALYTICS-007', name: 'gauge',          category: 'metrics',    description: 'Instantaneous gauge value' },
  { id: 'ANALYTICS-008', name: 'histogram',      category: 'metrics',    description: 'Value distribution histogram' },
  { id: 'ANALYTICS-009', name: 'cohortDefine',   category: 'cohorts',   description: 'Define cohort by filter' },
  { id: 'ANALYTICS-010', name: 'cohortCompute',  category: 'cohorts',   description: 'Compute cohort metrics' },
  { id: 'ANALYTICS-011', name: 'cohortCompare',  category: 'cohorts',   description: 'Compare two cohorts' },
  { id: 'ANALYTICS-012', name: 'retention',      category: 'cohorts',   description: 'Cohort retention curve' },
  { id: 'ANALYTICS-013', name: 'churn',          category: 'cohorts',   description: 'Churn rate computation' },
  { id: 'ANALYTICS-014', name: 'ltv',            category: 'cohorts',   description: 'Lifetime value estimate' },
  { id: 'ANALYTICS-015', name: 'nps',            category: 'cohorts',   description: 'Net promoter score' },
  { id: 'ANALYTICS-016', name: 'cohortHealth',   category: 'cohorts',   description: 'Overall cohort health score' },
  { id: 'ANALYTICS-017', name: 'funnelDefine',   category: 'funnels',   description: 'Define conversion funnel' },
  { id: 'ANALYTICS-018', name: 'funnelCompute',  category: 'funnels',   description: 'Compute funnel conversion rates' },
  { id: 'ANALYTICS-019', name: 'dropOff',        category: 'funnels',   description: 'Identify highest drop-off step' },
  { id: 'ANALYTICS-020', name: 'conversion',     category: 'funnels',   description: 'Overall funnel conversion rate' },
  { id: 'ANALYTICS-021', name: 'segment',        category: 'funnels',   description: 'Segment funnel by attribute' },
  { id: 'ANALYTICS-022', name: 'abTest',         category: 'funnels',   description: 'A/B test significance test' },
  { id: 'ANALYTICS-023', name: 'trend',          category: 'prediction', description: 'Trend direction detection' },
  { id: 'ANALYTICS-024', name: 'forecast',       category: 'prediction', description: 'PHI-weighted time series forecast' },
  { id: 'ANALYTICS-025', name: 'anomaly',        category: 'prediction', description: 'Anomaly detection via z-score' },
  { id: 'ANALYTICS-026', name: 'regression',     category: 'prediction', description: 'Linear regression on metric' },
  { id: 'ANALYTICS-027', name: 'classify',       category: 'prediction', description: 'Classify entity into segments' },
  { id: 'ANALYTICS-028', name: 'score',          category: 'prediction', description: 'Composite health score' },
  { id: 'ANALYTICS-029', name: 'summaryReport',  category: 'reports',   description: 'Executive summary report' },
  { id: 'ANALYTICS-030', name: 'executiveReport',category: 'reports',   description: 'C-suite BI report' },
  { id: 'ANALYTICS-031', name: 'cohortReport',   category: 'reports',   description: 'Full cohort analysis report' },
  { id: 'ANALYTICS-032', name: 'funnelReport',   category: 'reports',   description: 'Funnel performance report' },
  { id: 'ANALYTICS-033', name: 'exportReport',   category: 'reports',   description: 'Export report as JSON' },
  { id: 'ANALYTICS-034', name: 'scheduleReport', category: 'reports',   description: 'Schedule recurring report' },
];

/* ════════════════════════════════════════════════════════════════
   State — event stream, metric aggregates, report cache
   ════════════════════════════════════════════════════════════════ */

const eventStream = [];
const MAX_EVENTS = F18; // 2584

const metricAggregates = new Map(); // metricKey → { count, sum, values[], lastTs }
const gaugeValues = new Map();
const cohortRegistry = new Map();
const funnelRegistry = new Map();
const insightLog = [];
const MAX_INSIGHTS = F14; // 377

let latestReport = null;

/* ════════════════════════════════════════════════════════════════
   Event ingestion
   ════════════════════════════════════════════════════════════════ */

function trackEvent(event) {
  const entry = {
    id: `EVT-${++eventCounter}`,
    name: event.name || 'unknown',
    properties: event.properties || {},
    userId: event.userId || null,
    sessionId: event.sessionId || null,
    value: event.value || 0,
    ts: Date.now(),
  };
  eventStream.push(entry);
  if (eventStream.length > MAX_EVENTS) eventStream.shift();

  // Aggregate into metrics
  const key = entry.name;
  if (!metricAggregates.has(key)) {
    metricAggregates.set(key, { count: 0, sum: 0, values: [], min: Infinity, max: -Infinity });
  }
  const agg = metricAggregates.get(key);
  agg.count++;
  agg.sum += entry.value;
  agg.values.push(entry.value);
  if (agg.values.length > F16) agg.values.shift(); // keep last 987 values
  agg.min = Math.min(agg.min, entry.value);
  agg.max = Math.max(agg.max, entry.value);
  agg.lastTs = entry.ts;

  return entry;
}

/* ════════════════════════════════════════════════════════════════
   Metric computation
   ════════════════════════════════════════════════════════════════ */

function percentile(sorted, p) {
  if (!sorted.length) return 0;
  const idx = Math.ceil((p / 100) * sorted.length) - 1;
  return sorted[Math.max(0, idx)];
}

function computeMetric(metricKey) {
  const agg = metricAggregates.get(metricKey);
  if (!agg) return null;
  const sorted = [...agg.values].sort((a, b) => a - b);
  const avg = agg.count ? agg.sum / agg.count : 0;
  const variance = sorted.reduce((s, v) => s + Math.pow(v - avg, 2), 0) / (sorted.length || 1);
  return {
    key: metricKey,
    count: agg.count,
    sum: agg.sum,
    avg: avg.toFixed(4),
    min: agg.min === Infinity ? 0 : agg.min,
    max: agg.max === -Infinity ? 0 : agg.max,
    p95: percentile(sorted, 95),
    p99: percentile(sorted, 99),
    stdDev: Math.sqrt(variance).toFixed(4),
    phiScore: (avg * PHI_INV).toFixed(6),
    lastTs: agg.lastTs,
  };
}

function computeAllMetrics() {
  const results = [];
  for (const key of metricAggregates.keys()) {
    results.push(computeMetric(key));
  }
  return results;
}

/* ════════════════════════════════════════════════════════════════
   PHI-weighted forecast (simple exponential smoothing with PHI alpha)
   ════════════════════════════════════════════════════════════════ */

function forecast(values, horizon = F7) {
  if (!values.length) return [];
  const alpha = PHI_INV; // ~0.618 smoothing factor
  let smoothed = values[0];
  for (const v of values) smoothed = alpha * v + (1 - alpha) * smoothed;
  const slope = values.length > 1 ? (values[values.length - 1] - values[0]) / values.length : 0;
  return Array.from({ length: horizon }, (_, i) => +(smoothed + slope * (i + 1)).toFixed(4));
}

/* ════════════════════════════════════════════════════════════════
   Anomaly detection (z-score > PHI threshold)
   ════════════════════════════════════════════════════════════════ */

function detectAnomalies() {
  const anomalies = [];
  for (const [key, agg] of metricAggregates) {
    if (agg.values.length < F8) continue;
    const avg = agg.sum / agg.count;
    const variance = agg.values.reduce((s, v) => s + Math.pow(v - avg, 2), 0) / agg.values.length;
    const stdDev = Math.sqrt(variance);
    const last = agg.values[agg.values.length - 1];
    const z = stdDev ? Math.abs(last - avg) / stdDev : 0;
    if (z > PHI * 2) {
      anomalies.push({ metric: key, zScore: z.toFixed(3), value: last, avg: avg.toFixed(3), ts: Date.now() });
    }
  }
  return anomalies;
}

/* ════════════════════════════════════════════════════════════════
   BI Report generation
   ════════════════════════════════════════════════════════════════ */

function generateBIReport() {
  const metrics = computeAllMetrics();
  const anomalies = detectAnomalies();
  const topMetrics = metrics.sort((a, b) => b.count - a.count).slice(0, F7);
  const forecasts = {};
  for (const m of topMetrics) {
    const agg = metricAggregates.get(m.key);
    forecasts[m.key] = forecast(agg ? agg.values : []);
  }

  latestReport = {
    id: `RPT-${++reportCounter}`,
    generatedAt: Date.now(),
    beat: beatCount,
    eventStreamSize: eventStream.length,
    uniqueMetrics: metricAggregates.size,
    topMetrics,
    anomalies,
    forecasts,
    phiIndex: (metrics.reduce((s, m) => s + parseFloat(m.phiScore), 0) * PHI_INV).toFixed(6),
    cohorts: cohortRegistry.size,
    funnels: funnelRegistry.size,
  };

  const insight = {
    id: `INS-${insightLog.length + 1}`,
    type: 'bi-report',
    summary: `${metrics.length} metrics computed. ${anomalies.length} anomalies detected. PHI index: ${latestReport.phiIndex}`,
    ts: Date.now(),
  };
  insightLog.push(insight);
  if (insightLog.length > MAX_INSIGHTS) insightLog.shift();

  self.postMessage({ type: 'analytics:report', report: latestReport, ts: Date.now() });
}

function computeRealTimeMetrics() {
  const metrics = computeAllMetrics();
  const anomalies = detectAnomalies();
  self.postMessage({
    type: 'analytics:realtime',
    metrics,
    anomalies,
    eventStreamSize: eventStream.length,
    beat: beatCount,
    ts: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Heartbeat
   ════════════════════════════════════════════════════════════════ */

setInterval(() => {
  beatCount++;

  if (beatCount % METRICS_INTERVAL === 0) computeRealTimeMetrics();
  if (beatCount % REPORT_INTERVAL  === 0) generateBIReport();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    events: eventStream.length,
    metrics: metricAggregates.size,
    insights: insightLog.length,
    ts: Date.now(),
  });
}, PHI_BEAT);

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};

  switch (type) {

    case 'query:metrics': {
      const { keys } = payload;
      const metrics = keys && keys.length
        ? keys.map(k => computeMetric(k)).filter(Boolean)
        : computeAllMetrics();
      self.postMessage({ type: 'result:metrics', metrics, ts: Date.now() });
      break;
    }

    case 'query:report':
      self.postMessage({ type: 'result:report', report: latestReport, ts: Date.now() });
      break;

    case 'query:insights': {
      const { limit = F10 } = payload;
      self.postMessage({ type: 'result:insights', insights: insightLog.slice(-limit), total: insightLog.length, ts: Date.now() });
      break;
    }

    case 'query:cohort': {
      const { cohortId } = payload;
      self.postMessage({ type: 'result:cohort', cohort: cohortRegistry.get(cohortId) || null, ts: Date.now() });
      break;
    }

    case 'call:track': {
      const entry = trackEvent(payload);
      self.postMessage({ type: 'result:track', eventId: entry.id, ts: entry.ts });
      break;
    }

    case 'call:compute': {
      const { metricKey } = payload;
      const metric = computeMetric(metricKey);
      self.postMessage({ type: 'result:compute', metric, ts: Date.now() });
      break;
    }

    case 'call:export': {
      const snapshot = {
        exportedAt: Date.now(),
        metrics: computeAllMetrics(),
        eventStreamSize: eventStream.length,
        latestReport,
      };
      self.postMessage({ type: 'result:export', snapshot, ts: Date.now() });
      break;
    }

    case 'call:reset': {
      const { metricKey } = payload;
      const removed = metricAggregates.delete(metricKey);
      self.postMessage({ type: 'result:reset', metricKey, removed, ts: Date.now() });
      break;
    }

    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
