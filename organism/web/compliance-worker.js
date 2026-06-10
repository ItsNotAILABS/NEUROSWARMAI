/**
 * Compliance Worker — COMPLIANCE-001–021: Policy Enforcement & Regulatory Reporting
 *
 * Continuously scans all active protocols and entities for compliance
 * violations, enforces policies, certifies conformance, and generates
 * regulatory reports. Uses PHI-weighted risk scoring to prioritise
 * remediation. A full compliance scan runs every 55 beats and a
 * comprehensive report is generated every 233 beats.
 *
 * Tool Registry (21 tools):
 *   COMPLIANCE-001  check      — Check an entity against a policy
 *   COMPLIANCE-002  enforce    — Enforce a policy action on violation
 *   COMPLIANCE-003  report     — Generate compliance report
 *   COMPLIANCE-004  certify    — Issue compliance certificate
 *   COMPLIANCE-005  flag       — Flag an entity for review
 *   COMPLIANCE-006  remediate  — Apply automated remediation
 *   COMPLIANCE-007  audit      — Log compliance check to audit trail
 *   COMPLIANCE-008  policy     — Register or update a policy
 *   COMPLIANCE-009  revoke     — Revoke a compliance certificate
 *   COMPLIANCE-010  escalate   — Escalate violation to governance
 *   COMPLIANCE-011  whitelist  — Add entity to policy whitelist
 *   COMPLIANCE-012  blacklist  — Add entity to policy blacklist
 *   COMPLIANCE-013  snapshot   — Snapshot current compliance state
 *   COMPLIANCE-014  forecast   — Forecast risk score trajectory
 *   COMPLIANCE-015  benchmark  — Compare against industry benchmark
 *   COMPLIANCE-016  import     — Import external policy framework
 *   COMPLIANCE-017  export     — Export compliance data
 *   COMPLIANCE-018  notify     — Notify stakeholders of violations
 *   COMPLIANCE-019  schedule   — Schedule periodic compliance check
 *   COMPLIANCE-020  archive    — Archive closed compliance cases
 *   COMPLIANCE-021  health     — Overall compliance health score
 *
 * Proactive beats:
 *   Every 55 beats  — scan all active protocols for compliance violations
 *   Every 233 beats — generate full compliance report
 *
 * Message types (in):
 *   query:policies   — list policy registry
 *   query:violations — list open violations
 *   query:report     — latest compliance report
 *   call:check       — check entity against policy
 *   call:enforce     — enforce policy on entity
 *   call:certify     — issue compliance certificate
 *   call:remediate   — apply remediation to violation
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

const SCAN_INTERVAL   = F10; // 55 beats
const REPORT_INTERVAL = F13; // 233 beats

let beatCount = 0;
let violationCounter = 0;
let certCounter = 0;
let reportCounter = 0;

/* ════════════════════════════════════════════════════════════════
   Tool Registry — 21 compliance tools
   ════════════════════════════════════════════════════════════════ */

const TOOL_REGISTRY = [
  { id: 'COMPLIANCE-001', name: 'check',      category: 'core',      description: 'Check entity against policy' },
  { id: 'COMPLIANCE-002', name: 'enforce',    category: 'core',      description: 'Enforce policy action' },
  { id: 'COMPLIANCE-003', name: 'report',     category: 'reporting', description: 'Generate compliance report' },
  { id: 'COMPLIANCE-004', name: 'certify',    category: 'cert',      description: 'Issue compliance certificate' },
  { id: 'COMPLIANCE-005', name: 'flag',       category: 'core',      description: 'Flag entity for review' },
  { id: 'COMPLIANCE-006', name: 'remediate',  category: 'core',      description: 'Apply automated remediation' },
  { id: 'COMPLIANCE-007', name: 'audit',      category: 'audit',     description: 'Log check to audit trail' },
  { id: 'COMPLIANCE-008', name: 'policy',     category: 'admin',     description: 'Register or update policy' },
  { id: 'COMPLIANCE-009', name: 'revoke',     category: 'cert',      description: 'Revoke certificate' },
  { id: 'COMPLIANCE-010', name: 'escalate',   category: 'core',      description: 'Escalate to governance' },
  { id: 'COMPLIANCE-011', name: 'whitelist',  category: 'admin',     description: 'Add to policy whitelist' },
  { id: 'COMPLIANCE-012', name: 'blacklist',  category: 'admin',     description: 'Add to policy blacklist' },
  { id: 'COMPLIANCE-013', name: 'snapshot',   category: 'admin',     description: 'Snapshot compliance state' },
  { id: 'COMPLIANCE-014', name: 'forecast',   category: 'reporting', description: 'Forecast risk trajectory' },
  { id: 'COMPLIANCE-015', name: 'benchmark',  category: 'reporting', description: 'Compare against benchmark' },
  { id: 'COMPLIANCE-016', name: 'import',     category: 'admin',     description: 'Import external framework' },
  { id: 'COMPLIANCE-017', name: 'export',     category: 'admin',     description: 'Export compliance data' },
  { id: 'COMPLIANCE-018', name: 'notify',     category: 'reporting', description: 'Notify stakeholders' },
  { id: 'COMPLIANCE-019', name: 'schedule',   category: 'admin',     description: 'Schedule periodic check' },
  { id: 'COMPLIANCE-020', name: 'archive',    category: 'admin',     description: 'Archive closed cases' },
  { id: 'COMPLIANCE-021', name: 'health',     category: 'reporting', description: 'Overall health score' },
];

/* ════════════════════════════════════════════════════════════════
   Policy Registry — seed set of compliance policies
   ════════════════════════════════════════════════════════════════ */

const policyRegistry = new Map([
  ['POL-GDPR',    { id: 'POL-GDPR',    name: 'GDPR Data Protection',      framework: 'GDPR',    severity: 'critical', rules: ['consent','data-minimisation','right-to-erasure'] }],
  ['POL-SOC2',    { id: 'POL-SOC2',    name: 'SOC 2 Type II Controls',    framework: 'SOC2',    severity: 'high',     rules: ['availability','confidentiality','security'] }],
  ['POL-HIPAA',   { id: 'POL-HIPAA',   name: 'HIPAA PHI Handling',         framework: 'HIPAA',   severity: 'critical', rules: ['phi-encryption','access-control','audit-log'] }],
  ['POL-PCI',     { id: 'POL-PCI',     name: 'PCI-DSS Card Data Security', framework: 'PCI-DSS', severity: 'critical', rules: ['card-data-scope','tokenisation','pen-test'] }],
  ['POL-ISO27001',{ id: 'POL-ISO27001',name: 'ISO 27001 ISMS',             framework: 'ISO27001',severity: 'high',     rules: ['risk-assessment','access-management','incident-response'] }],
  ['POL-INTERNAL',{ id: 'POL-INTERNAL',name: 'Internal Code of Conduct',   framework: 'INTERNAL',severity: 'medium',   rules: ['data-handling','communication','conflict-of-interest'] }],
]);

/* ════════════════════════════════════════════════════════════════
   State
   ════════════════════════════════════════════════════════════════ */

const violationLog = [];
const MAX_VIOLATIONS = F15; // 610

const certRegistry = new Map(); // certId → cert

// entityScores: entityId → { score, violations, lastChecked }
const entityScores = new Map();

const whitelistSet = new Set();
const blacklistSet = new Set();

let latestReport = null;

/* ════════════════════════════════════════════════════════════════
   Seed entity scores
   ════════════════════════════════════════════════════════════════ */

const ENTITIES = ['workflow-worker','scheduler-worker','career-worker','analytics-worker',
  'billing-worker','audit-worker','queue-worker','search-worker','governance-worker'];
for (const eid of ENTITIES) {
  entityScores.set(eid, { entityId: eid, score: 100, violations: 0, lastChecked: null });
}

/* ════════════════════════════════════════════════════════════════
   Compliance check engine
   ════════════════════════════════════════════════════════════════ */

function checkEntityPolicy(entityId, policyId, context = {}) {
  const policy = policyRegistry.get(policyId);
  if (!policy) return { passed: false, error: 'unknown_policy' };

  if (blacklistSet.has(entityId)) {
    return { passed: false, reason: 'entity-blacklisted', policyId };
  }
  if (whitelistSet.has(entityId)) {
    return { passed: true, reason: 'entity-whitelisted', policyId };
  }

  // Simulate rule evaluation — PHI-weighted risk scoring
  const ruleResults = policy.rules.map(rule => {
    const pass = Math.random() > PHI_INV * 0.2; // ~88% pass rate
    return { rule, passed: pass };
  });

  const failedRules = ruleResults.filter(r => !r.passed);
  const passed = failedRules.length === 0;

  if (!passed) {
    const violation = {
      id: `VIO-${String(++violationCounter).padStart(6, '0')}`,
      entityId,
      policyId,
      policyName: policy.name,
      framework: policy.framework,
      failedRules: failedRules.map(r => r.rule),
      severity: policy.severity,
      status: 'open',
      riskScore: failedRules.length * PHI * (policy.severity === 'critical' ? PHI : 1),
      detectedAt: Date.now(),
      remediatedAt: null,
    };
    violationLog.push(violation);
    if (violationLog.length > MAX_VIOLATIONS) violationLog.shift();

    const es = entityScores.get(entityId) || { entityId, score: 100, violations: 0, lastChecked: null };
    es.violations++;
    es.score = Math.max(0, es.score - violation.riskScore * PHI_INV);
    es.lastChecked = Date.now();
    entityScores.set(entityId, es);
  } else {
    const es = entityScores.get(entityId) || { entityId, score: 100, violations: 0, lastChecked: null };
    es.score = Math.min(100, es.score + PHI_INV * 2);
    es.lastChecked = Date.now();
    entityScores.set(entityId, es);
  }

  return { passed, policyId, policyName: policy.name, failedRules: failedRules.map(r => r.rule), ruleResults };
}

/* ════════════════════════════════════════════════════════════════
   Proactive scan — check every entity against every policy
   ════════════════════════════════════════════════════════════════ */

function scanAllEntities() {
  let checked = 0;
  let violations = 0;
  for (const entityId of entityScores.keys()) {
    for (const policyId of policyRegistry.keys()) {
      const result = checkEntityPolicy(entityId, policyId);
      checked++;
      if (!result.passed) violations++;
    }
  }
  self.postMessage({
    type: 'compliance:scan-complete',
    entitiesChecked: entityScores.size,
    policiesApplied: policyRegistry.size,
    checksRun: checked,
    newViolations: violations,
    beat: beatCount,
    ts: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Report generation
   ════════════════════════════════════════════════════════════════ */

function generateComplianceReport() {
  const openViolations = violationLog.filter(v => v.status === 'open');
  const bySeverity = {};
  const byFramework = {};
  for (const v of openViolations) {
    bySeverity[v.severity]     = (bySeverity[v.severity]     || 0) + 1;
    byFramework[v.framework]   = (byFramework[v.framework]   || 0) + 1;
  }

  const scores = [...entityScores.values()].sort((a, b) => a.score - b.score);
  const avgScore = scores.reduce((s, e) => s + e.score, 0) / (scores.length || 1);
  const phiIndex = (avgScore * PHI_INV).toFixed(4);

  latestReport = {
    id: `CRPT-${String(++reportCounter).padStart(4, '0')}`,
    generatedAt: Date.now(),
    beat: beatCount,
    openViolations: openViolations.length,
    totalViolations: violationLog.length,
    bySeverity,
    byFramework,
    avgComplianceScore: avgScore.toFixed(2),
    phiIndex,
    lowestScoreEntities: scores.slice(0, F7).map(e => ({ entityId: e.entityId, score: e.score.toFixed(1) })),
    certificates: certRegistry.size,
  };

  self.postMessage({ type: 'compliance:report', report: latestReport, ts: Date.now() });
}

/* ════════════════════════════════════════════════════════════════
   Heartbeat
   ════════════════════════════════════════════════════════════════ */

setInterval(() => {
  beatCount++;

  if (beatCount % SCAN_INTERVAL   === 0) scanAllEntities();
  if (beatCount % REPORT_INTERVAL === 0) generateComplianceReport();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    openViolations: violationLog.filter(v => v.status === 'open').length,
    totalViolations: violationLog.length,
    policies: policyRegistry.size,
    ts: Date.now(),
  });
}, PHI_BEAT);

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  const { type, ...payload } = e.data || {};

  switch (type) {

    case 'query:policies':
      self.postMessage({ type: 'result:policies', policies: [...policyRegistry.values()], total: policyRegistry.size, ts: Date.now() });
      break;

    case 'query:violations': {
      const { status, severity, limit = F10 } = payload;
      let violations = violationLog;
      if (status)   violations = violations.filter(v => v.status === status);
      if (severity) violations = violations.filter(v => v.severity === severity);
      self.postMessage({ type: 'result:violations', violations: violations.slice(-limit), total: violations.length, ts: Date.now() });
      break;
    }

    case 'query:report':
      self.postMessage({ type: 'result:report', report: latestReport, ts: Date.now() });
      break;

    case 'call:check': {
      const { entityId, policyId, context } = payload;
      const result = checkEntityPolicy(entityId, policyId, context);
      self.postMessage({ type: 'result:check', entityId, ...result, ts: Date.now() });
      break;
    }

    case 'call:enforce': {
      const { violationId, action = 'block' } = payload;
      const violation = violationLog.find(v => v.id === violationId);
      if (!violation) { self.postMessage({ type: 'error', error: 'unknown_violation', violationId, ts: Date.now() }); break; }
      violation.enforcedAction = action;
      violation.enforcedAt = Date.now();
      if (action === 'block') blacklistSet.add(violation.entityId);
      self.postMessage({ type: 'result:enforce', violationId, action, entityId: violation.entityId, ts: Date.now() });
      break;
    }

    case 'call:certify': {
      const { entityId, policyId } = payload;
      const cert = {
        id: `CERT-${String(++certCounter).padStart(6, '0')}`,
        entityId, policyId,
        issuedAt: Date.now(),
        expiresAt: Date.now() + 365 * 86400000,
        phiWeight: PHI,
      };
      certRegistry.set(cert.id, cert);
      self.postMessage({ type: 'result:certify', cert, ts: Date.now() });
      break;
    }

    case 'call:remediate': {
      const { violationId } = payload;
      const violation = violationLog.find(v => v.id === violationId);
      if (!violation) { self.postMessage({ type: 'error', error: 'unknown_violation', violationId, ts: Date.now() }); break; }
      violation.status = 'remediated';
      violation.remediatedAt = Date.now();
      // Restore entity score
      const es = entityScores.get(violation.entityId);
      if (es) { es.score = Math.min(100, es.score + violation.riskScore * PHI_INV * PHI); }
      self.postMessage({ type: 'result:remediate', violationId, entityId: violation.entityId, ts: Date.now() });
      break;
    }

    default:
      self.postMessage({ type: 'error', error: 'unknown_type', received: type, ts: Date.now() });
  }
};
