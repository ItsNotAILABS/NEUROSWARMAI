#!/usr/bin/env node
/**
 * Governance Cycle - Event Ingestion and CPL-L Evaluation
 * Reads governance events from dist/governance/events/ and evaluates CPL-L conditions
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Paths
const EVENTS_DIR = path.join(__dirname, '../dist/governance/events');
const AUDIT_LOG = path.join(__dirname, '../dist/governance/audit.jsonl');
const META_METRICS = path.join(__dirname, '../dist/governance/metrics.json');

// CPL-L Law Definitions (from event specs)
const CPL_L_LAWS = {
  // Fleet State Laws
  NO_MISSING_WORKFLOWS: {
    eventType: 'fleet_state',
    condition: (ctx) => ctx.missing_workflows?.length > 0,
    severity: 'CRITICAL',
    action: 'BLOCK_RELEASE',
    description: 'One or more bots are missing or failed',
  },
  FLEET_HEALTH_DEGRADED: {
    eventType: 'fleet_state',
    condition: (ctx) => {
      const ratio = ctx.bots_healthy / ctx.bots_total;
      return ratio < 0.8;
    },
    severity: 'HIGH',
    action: 'ALERT_GUARDIAN',
    description: 'Fleet health below 80%',
  },
  POLICY_COMPLIANCE_LOW: {
    eventType: 'fleet_state',
    condition: (ctx) => ctx.policy_compliance < 0.9,
    severity: 'MEDIUM',
    action: 'ALERT_ORACLE',
    description: 'Policy compliance below 90%',
  },

  // Economy State Laws
  COVERAGE_TOO_LOW: {
    eventType: 'economy_state',
    condition: (ctx) => ctx.coverage?.test_coverage < 0.7,
    severity: 'HIGH',
    action: 'BLOCK_RELEASE',
    description: 'Test coverage below 70%',
  },
  DOC_COVERAGE_LOW: {
    eventType: 'economy_state',
    condition: (ctx) => ctx.coverage?.doc_coverage < 0.8,
    severity: 'MEDIUM',
    action: 'ALERT_ORACLE',
    description: 'Documentation coverage below 80%',
  },
  COMPLEXITY_SPIKE: {
    eventType: 'economy_state',
    condition: (ctx) => ctx.complexity_score > 0.75,
    severity: 'MEDIUM',
    action: 'ALERT_ORACLE',
    description: 'Ecosystem complexity exceeds threshold',
  },

  // Learning State Laws
  NO_LEARNING_PROGRESS: {
    eventType: 'learning_state',
    condition: (ctx) => ctx.training_signals === 0 && ctx.hebbian_synapses_trained === 0,
    severity: 'MEDIUM',
    action: 'ALERT_ORACLE',
    description: 'Learning cycle produced no progress',
  },
  RAPID_PROTOCOL_EVOLUTION: {
    eventType: 'learning_state',
    condition: (ctx) => ctx.protocols_evolved > 5,
    severity: 'HIGH',
    action: 'ALERT_GUARDIAN',
    description: 'Too many protocols changed at once',
  },
  HIGH_ERROR_RATE: {
    eventType: 'learning_state',
    condition: (ctx) => ctx.error_rate > 0.3,
    severity: 'MEDIUM',
    action: 'ADJUST_LEARNING_RATE',
    description: 'Learning error rate exceeds 30%',
  },

  // Topology State Laws
  NO_DEAD_LINKS_ALLOWED: {
    eventType: 'topology_state',
    condition: (ctx) => ctx.dead_links > 0,
    severity: 'CRITICAL',
    action: 'BLOCK_RELEASE',
    description: 'Dead links detected in topology',
  },
  TOO_MANY_ORPHANS: {
    eventType: 'topology_state',
    condition: (ctx, event) => {
      const orphanRatio = ctx.orphans / ctx.files;
      return orphanRatio > 0.1;
    },
    severity: 'MEDIUM',
    action: 'ALERT_ORACLE',
    description: 'More than 10% of files are orphaned',
  },
  CIRCULAR_DEPENDENCIES: {
    eventType: 'topology_state',
    condition: (ctx) => ctx.cycles_detected > 0,
    severity: 'HIGH',
    action: 'ALERT_GUARDIAN',
    description: 'Circular dependencies detected',
  },
  EXCESSIVE_DEPTH: {
    eventType: 'topology_state',
    condition: (ctx) => ctx.max_depth > 10,
    severity: 'MEDIUM',
    action: 'REVIEW_ARCHITECTURE',
    description: 'Dependency chains too deep',
  },

  // Geometry Lock Laws (PROTO-226 — Clavis Geometrica)
  BLOCK_UNKEYED_CALLS: {
    eventType: 'security_state',
    condition: (ctx) => ctx.unkeyed_call_attempts > 0,
    severity: 'CRITICAL',
    action: 'BLOCK_UNKEYED_CALLS',
    description: 'Calls reached medina-calls without a valid geometric key (R > φ⁻¹)',
  },
  GEOMETRY_LOCK_GRANT_RATE_LOW: {
    eventType: 'security_state',
    condition: (ctx) => ctx.geometry_lock_grant_rate < 0.5 && ctx.geometry_lock_total_validations > 10,
    severity: 'HIGH',
    action: 'ALERT_GUARDIAN',
    description: 'Geometry lock grant rate below 50% — possible key drift or replay attack',
  },
  GEOMETRY_LOCK_CALLERS_DEGRADED: {
    eventType: 'security_state',
    condition: (ctx) => ctx.geometry_lock_active_callers === 0,
    severity: 'MEDIUM',
    action: 'ALERT_ORACLE',
    description: 'No active callers registered with the geometry lock',
  },

  // Drone Swarm State Laws (NeuroSwarm drone-side engines)
  DRONE_COHERENCE_LOW: {
    eventType: 'drone_swarm_state',
    condition: (ctx) => ctx.kuramoto_r_mean < 0.85,
    severity: 'CRITICAL',
    action: 'HOLD_ACTUATION',
    description: 'Fleet Kuramoto coherence below 0.85',
  },
  DRONE_THREAT_SLOW: {
    eventType: 'drone_swarm_state',
    condition: (ctx) => ctx.threat_fast_p50_ms > 12,
    severity: 'HIGH',
    action: 'ALERT_GUARDIAN',
    description: 'Threat-fast path exceeds 12ms p50',
  },
  DRONE_JAM_FAILOVER_BROKEN: {
    eventType: 'drone_swarm_state',
    condition: (ctx) => ctx.jam_failover_ok === false,
    severity: 'CRITICAL',
    action: 'SWITCH_ORBITAL_ROUTE',
    description: 'Jam failover to orbital_preferred failed',
  },
  DRONE_ENGINE_ATTEST_INCOMPLETE: {
    eventType: 'drone_swarm_state',
    condition: (ctx) => ctx.engines_attested_ratio < 1.0,
    severity: 'CRITICAL',
    action: 'BLOCK_TICK',
    description: 'Not all six drone-side engines attested',
  },
  DRONE_LAW_CRITICAL: {
    eventType: 'drone_swarm_state',
    condition: (ctx) => ctx.law_violations_critical > 0,
    severity: 'CRITICAL',
    action: 'BLOCK_RELEASE',
    description: 'Critical CPL-L violations in drone swarm tick',
  },
};

// Meta Engine Metric Extractors
const METRIC_EXTRACTORS = {
  fleet_state: (ctx) => ({
    'bot_fleet.health_ratio': ctx.bots_healthy / ctx.bots_total,
    'bot_fleet.total_count': ctx.bots_total,
    'bot_fleet.policy_compliance': ctx.policy_compliance,
    'bot_fleet.missing_count': ctx.missing_workflows?.length || 0,
  }),
  economy_state: (ctx) => ({
    'economy.assets_total': ctx.assets_total,
    'economy.coverage': ctx.coverage?.test_coverage,
    'economy.doc_coverage': ctx.coverage?.doc_coverage,
    'economy.complexity_score': ctx.complexity_score,
    'economy.sdk_count': ctx.sdk_count,
    'economy.protocol_count': ctx.protocol_count,
  }),
  learning_state: (ctx) => ({
    'learning.signals_per_cycle': ctx.training_signals,
    'learning.synapses_trained': ctx.hebbian_synapses_trained,
    'learning.protocols_evolved': ctx.protocols_evolved,
    'learning.error_rate': ctx.error_rate,
    'learning.cycle_duration': ctx.cycle_duration_ms / 1000,
    'learning.learning_rate': ctx.learning_rate,
  }),
  topology_state: (ctx) => ({
    'topology.orphans': ctx.orphans,
    'topology.dead_links': ctx.dead_links,
    'topology.graph_centrality_max': ctx.most_connected_degree,
    'topology.graph_nodes': ctx.graph_nodes,
    'topology.graph_edges': ctx.graph_edges,
    'topology.graph_density': ctx.graph_edges / (ctx.graph_nodes * (ctx.graph_nodes - 1)) || 0,
    'topology.cycles_detected': ctx.cycles_detected,
    'topology.max_depth': ctx.max_depth,
  }),
  security_state: (ctx) => ({
    'security.unkeyed_call_attempts': ctx.unkeyed_call_attempts,
    'security.geometry_lock_grant_rate': ctx.geometry_lock_grant_rate,
    'security.geometry_lock_total_validations': ctx.geometry_lock_total_validations,
    'security.geometry_lock_active_callers': ctx.geometry_lock_active_callers,
    'security.geometry_lock_total_denied': ctx.geometry_lock_total_denied,
  }),
  drone_swarm_state: (ctx) => ({
    'drone_swarm.coherence_mean': ctx.kuramoto_r_mean,
    'drone_swarm.threat_fast_p50_ms': ctx.threat_fast_p50_ms,
    'drone_swarm.engine_attest_ratio': ctx.engines_attested_ratio,
    'drone_swarm.law_violations_critical': ctx.law_violations_critical,
    'drone_swarm.agents_healthy_ratio': ctx.agents_healthy / ctx.n_agents,
    'drone_swarm.jam_failover_ok': ctx.jam_failover_ok ? 1 : 0,
  }),
};

/**
 * Read all governance events from dist/governance/events/
 */
function readGovernanceEvents() {
  if (!fs.existsSync(EVENTS_DIR)) {
    console.log(`Events directory not found: ${EVENTS_DIR}`);
    return [];
  }

  const files = fs.readdirSync(EVENTS_DIR).filter(f => f.endsWith('.json'));
  const events = [];

  for (const file of files) {
    try {
      const filePath = path.join(EVENTS_DIR, file);
      const content = fs.readFileSync(filePath, 'utf8');
      const event = JSON.parse(content);
      events.push({ ...event, _sourceFile: file });
    } catch (err) {
      console.error(`Failed to read event ${file}:`, err.message);
    }
  }

  return events;
}

/**
 * Evaluate CPL-L conditions against an event
 */
function evaluateCPLConditions(event) {
  const violations = [];
  const eventType = event._sourceFile.replace('.json', '');

  for (const [lawName, law] of Object.entries(CPL_L_LAWS)) {
    if (law.eventType === eventType) {
      try {
        const triggered = law.condition(event.context, event);
        if (triggered) {
          violations.push({
            law: lawName,
            severity: law.severity,
            action: law.action,
            description: law.description,
            event: event.entity_id,
            timestamp: new Date().toISOString(),
          });
        }
      } catch (err) {
        console.error(`Error evaluating law ${lawName}:`, err.message);
      }
    }
  }

  return violations;
}

/**
 * Extract Meta Engine metrics from event
 */
function extractMetrics(event) {
  const eventType = event._sourceFile.replace('.json', '');
  const extractor = METRIC_EXTRACTORS[eventType];

  if (!extractor) {
    return {};
  }

  try {
    return extractor(event.context);
  } catch (err) {
    console.error(`Error extracting metrics from ${eventType}:`, err.message);
    return {};
  }
}

/**
 * Log violations to audit trail
 */
function logViolations(violations) {
  if (violations.length === 0) return;

  const auditDir = path.dirname(AUDIT_LOG);
  if (!fs.existsSync(auditDir)) {
    fs.mkdirSync(auditDir, { recursive: true });
  }

  const entries = violations.map(v => JSON.stringify(v)).join('\n') + '\n';
  fs.appendFileSync(AUDIT_LOG, entries);
}

/**
 * Update Meta Engine metrics
 */
function updateMetrics(allMetrics) {
  const metricsDir = path.dirname(META_METRICS);
  if (!fs.existsSync(metricsDir)) {
    fs.mkdirSync(metricsDir, { recursive: true });
  }

  const timestamp = new Date().toISOString();
  const metricsSnapshot = {
    timestamp,
    metrics: allMetrics,
  };

  fs.writeFileSync(META_METRICS, JSON.stringify(metricsSnapshot, null, 2));
}

/**
 * Main governance cycle
 */
async function runGovernanceCycle() {
  console.log('═══════════════════════════════════════════════════════════');
  console.log('  GOVERNANCE CYCLE - CPL-L Evaluation');
  console.log('  Φ-synchronized at 873ms PHI_BEAT');
  console.log('═══════════════════════════════════════════════════════════\n');

  // Read events
  const events = readGovernanceEvents();
  console.log(`📥 Ingested ${events.length} governance events\n`);

  if (events.length === 0) {
    console.log('No events to process. Exiting.\n');
    return { violations: [], metrics: {} };
  }

  // Evaluate CPL-L conditions
  const allViolations = [];
  const allMetrics = {};

  for (const event of events) {
    const eventType = event._sourceFile.replace('.json', '');
    console.log(`⚖️  Evaluating ${eventType} from ${event.entity_id}`);

    // Check for violations
    const violations = evaluateCPLConditions(event);
    if (violations.length > 0) {
      console.log(`   ⚠️  ${violations.length} violations detected:`);
      violations.forEach(v => {
        console.log(`      [${v.severity}] ${v.law}: ${v.description}`);
        console.log(`      Action: ${v.action}`);
      });
      allViolations.push(...violations);
    } else {
      console.log(`   ✓ No violations`);
    }

    // Extract metrics
    const metrics = extractMetrics(event);
    Object.assign(allMetrics, metrics);
    console.log(`   📊 Extracted ${Object.keys(metrics).length} metrics\n`);
  }

  // Log violations
  if (allViolations.length > 0) {
    logViolations(allViolations);
    console.log(`📝 Logged ${allViolations.length} violations to audit trail\n`);
  }

  // Update metrics
  updateMetrics(allMetrics);
  console.log(`📊 Updated ${Object.keys(allMetrics).length} metrics in Meta Engine\n`);

  // Summary
  console.log('═══════════════════════════════════════════════════════════');
  console.log(`  CYCLE COMPLETE`);
  console.log(`  Events: ${events.length}`);
  console.log(`  Violations: ${allViolations.length}`);
  console.log(`  Metrics: ${Object.keys(allMetrics).length}`);

  const criticalViolations = allViolations.filter(v => v.severity === 'CRITICAL');
  if (criticalViolations.length > 0) {
    console.log(`  🚨 CRITICAL: ${criticalViolations.length} CRITICAL violations require immediate action`);
  }
  console.log('═══════════════════════════════════════════════════════════\n');

  return { violations: allViolations, metrics: allMetrics };
}

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  runGovernanceCycle()
    .then(({ violations }) => {
      const criticalCount = violations.filter(v => v.severity === 'CRITICAL').length;
      process.exit(criticalCount > 0 ? 1 : 0);
    })
    .catch(err => {
      console.error('Governance cycle failed:', err);
      process.exit(1);
    });
}

export { runGovernanceCycle, evaluateCPLConditions, extractMetrics };
