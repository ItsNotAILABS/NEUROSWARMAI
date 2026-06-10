/**
 * SPDX-License-Identifier: CPEL-1.0
 * Copyright © 2024-2026 Alfredo Medina Hernandez. All rights reserved.
 * Framework: Medina Doctrine
 *
 * Marketplace Worker — VOIS Call Marketplace
 *
 * The 22nd Web Worker in the organism fleet. Implements the VOIS Call
 * Marketplace — the registry, protocol, and settlement layer that lets
 * internal organisms, partner agents, enterprise clients, and (eventually)
 * public callers invoke named, schema-validated, permission-checked,
 * billing-tracked, ANIMA-logged tools through a unified call surface.
 *
 * NOT a generic API directory — this is a VOIS-addressable call layer
 * where tools are organism-native operations given names, schemas,
 * permissions, and routing surfaces.
 *
 * ════════════════════════════════════════════════════════════════════════
 *                    MARKETPLACE REGISTRY
 * ════════════════════════════════════════════════════════════════════════
 *
 * A. 20 Canonical VOIS Substrate Tools (always-running, internal)
 *    ─── Core Pulse ────────────────────────────────────────────
 *    VOIS-001  PULSE-KEEPER           — Heartbeat maintenance
 *    VOIS-002  SYNC-WEAVER            — Cross-worker synchronization
 *    VOIS-003  FLOW-MONITOR           — Signal flow observation
 *    VOIS-004  STATE-GUARDIAN          — State consistency enforcement
 *    VOIS-005  CYCLE-COUNTER          — Beat/cycle counting
 *    ─── Intelligence ──────────────────────────────────────────
 *    VOIS-006  INFER-ENGINE           — Core inference dispatch
 *    VOIS-007  PATTERN-SEEKER         — Pattern recognition
 *    VOIS-008  CONTEXT-BUILDER        — Context window assembly
 *    VOIS-009  ATTENTION-ROUTER       — Salience-weighted routing
 *    VOIS-010  MEMORY-CONSOLIDATOR    — Memory consolidation
 *    ─── Defense ───────────────────────────────────────────────
 *    VOIS-011  SENTINEL-WATCH         — 24/7 watchdog
 *    VOIS-012  INTEGRITY-CHECKER      — Hash chain verification
 *    VOIS-013  BOUNDARY-ENFORCER      — Permission boundary
 *    VOIS-014  ANOMALY-DETECTOR       — Drift/anomaly detection
 *    VOIS-015  SEAL-VERIFIER          — Cryptographic seal check
 *    ─── Infrastructure ────────────────────────────────────────
 *    VOIS-016  RESOURCE-BALANCER      — Load distribution
 *    VOIS-017  CONNECTION-POOL        — Connection management
 *    VOIS-018  CACHE-OPTIMIZER        — Cache strategy
 *    VOIS-019  QUEUE-PROCESSOR        — Queue drain
 *    VOIS-020  LOG-STREAMER           — Structured logging
 *
 * B. 200 VOIS Fleet Tools (TOOL-061–260 from 9 worker categories)
 *    Each tool gets a marketplace registry entry with call_id, metadata,
 *    contract, pricing, reward, and permission tiers.
 *
 * C. 55 Enterprise Protocols (PROTOCOL-001–055)
 *    Each protocol is also registered as a callable marketplace entry.
 *
 * ════════════════════════════════════════════════════════════════════════
 *
 * Permission Tiers:
 *   INTERNAL           — Own substrate organisms/agents
 *   INTERNAL-SOVEREIGN — Founder-privileged crown-level
 *   PARTNER            — Trusted external operators
 *   ENTERPRISE         — Paying company integrations
 *   PUBLIC             — Strictly controlled SHADOW-safe
 *
 * Pricing Classes: P0 (free internal) → P5 (sovereign restricted)
 * Reward Classes:  R0 (no reward) → R4 (ecosystem reward)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'queryTool', toolId }
 *   Main → Worker: { type: 'queryToolsByCategory', category }
 *   Main → Worker: { type: 'queryContract', callId }
 *   Main → Worker: { type: 'querySettlement', settlementId }
 *   Main → Worker: { type: 'queryCapacity' }
 *   Main → Worker: { type: 'queryPermissions', callerId, callId }
 *   Main → Worker: { type: 'queryPricing', callId }
 *   Main → Worker: { type: 'queryHealth' }
 *   Main → Worker: { type: 'queryRegistry' }
 *   Main → Worker: { type: 'queryCallerProfile', callerId }
 *   Main → Worker: { type: 'callInvoke', callId, callerId, params }
 *   Main → Worker: { type: 'callBatchInvoke', invocations }
 *   Main → Worker: { type: 'callRegisterTool', tool }
 *   Main → Worker: { type: 'callUpdatePermissions', callId, permissions }
 *   Main → Worker: { type: 'callSettleCall', invocationId }
 *   Main → Worker: { type: 'callRegisterCaller', callerId, tier, config }
 *   Main → Worker: { type: 'callExportUsage', callerId, format }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 *   Worker → Main: { type: 'query-result', query, ... }
 *   Worker → Main: { type: 'call-result', call, ... }
 *   Worker → Main: { type: 'call-error', call, error }
 *   Worker → Main: { type: 'invocation-complete', invocationId, callId, ... }
 *   Worker → Main: { type: 'settlement-complete', settlementId, ... }
 */

// ════════════════════════════════════════════════════════════════════════
//  LICENSE
// ════════════════════════════════════════════════════════════════════════

const MARKETPLACE_LICENSE = {
  id: 'CPEL-1.0',
  name: 'Command Platform Enterprise License',
  version: '1.0.0',
  copyright: '© 2024-2026 Alfredo Medina Hernandez. All rights reserved.',
  framework: 'Medina Doctrine',
  spdx: 'CPEL-1.0',
  permissions: [
    'execute',           // Execute tool via registered caller
    'query',             // Query registry state and metadata
    'audit',             // Read audit logs for own invocations
    'export-results',    // Export invocation results
  ],
  restrictions: [
    'no-reverse-engineer',    // Cannot reverse-engineer call sequences
    'no-redistribution',      // Cannot redistribute tool definitions
    'no-modification',        // Cannot modify tool behavior
    'no-sublicense',          // Cannot sublicense to third parties
    'audit-required',         // All invocations must be audit-logged
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
const MAX_REGISTRY = 610;       // F15 — total VOIS agents capacity
const MAX_SETTLEMENTS = 2584;   // F18 — settlement ledger depth
const MAX_CALLERS = 1597;       // F17 — max registered callers
const MAX_INVOCATIONS = 4181;   // F19 — max tracked invocations
const MAX_AUDIT_LOG = 2584;     // F18 — audit trail depth

// ════════════════════════════════════════════════════════════════════════
//  STATE
// ════════════════════════════════════════════════════════════════════════

let beatCount = 0;
let running = true;
let invocationCounter = 0;
let settlementCounter = 0;
let totalInvocations = 0;
let totalSettlements = 0;
let totalErrors = 0;

const callerRegistry = new Map();
const activeInvocations = new Map();
const settlementLedger = new Map();
const auditLog = [];

// ════════════════════════════════════════════════════════════════════════
//  PERMISSION TIERS
// ════════════════════════════════════════════════════════════════════════

const PERMISSION_TIERS = {
  'INTERNAL': {
    level: 0,
    label: 'Internal',
    description: 'Own substrate organisms and agents',
    allowedOrigins: ['organism', 'worker', 'brain', 'sentinel'],
    rateLimit: 0,  // unlimited
    requiresAuth: false,
    shadowSafe: true,
  },
  'INTERNAL-SOVEREIGN': {
    level: 1,
    label: 'Internal Sovereign',
    description: 'Founder-privileged crown-level access',
    allowedOrigins: ['founder', 'sovereign', 'crown'],
    rateLimit: 0,
    requiresAuth: true,
    shadowSafe: true,
  },
  'PARTNER': {
    level: 2,
    label: 'Partner',
    description: 'Trusted external operators with partnership agreement',
    allowedOrigins: ['partner-api', 'partner-sdk'],
    rateLimit: 1000,  // per minute
    requiresAuth: true,
    shadowSafe: true,
  },
  'ENTERPRISE': {
    level: 3,
    label: 'Enterprise',
    description: 'Paying company integrations with SLA',
    allowedOrigins: ['enterprise-api', 'enterprise-sdk', 'enterprise-webhook'],
    rateLimit: 500,
    requiresAuth: true,
    shadowSafe: true,
  },
  'PUBLIC': {
    level: 4,
    label: 'Public',
    description: 'Strictly controlled SHADOW-safe public access',
    allowedOrigins: ['public-api'],
    rateLimit: 60,
    requiresAuth: true,
    shadowSafe: true,
  },
};

// ════════════════════════════════════════════════════════════════════════
//  PRICING CLASSES
// ════════════════════════════════════════════════════════════════════════

const PRICING_CLASSES = {
  P0: { id: 'P0', name: 'Free Internal',       rate: 0,      unit: 'call', description: 'No cost — internal substrate operations' },
  P1: { id: 'P1', name: 'Metered Basic',       rate: 0.001,  unit: 'call', description: 'Basic metered — low-cost utility calls' },
  P2: { id: 'P2', name: 'Metered Standard',    rate: 0.005,  unit: 'call', description: 'Standard metered — mid-tier operations' },
  P3: { id: 'P3', name: 'Metered Premium',     rate: 0.025,  unit: 'call', description: 'Premium metered — high-value orchestration' },
  P4: { id: 'P4', name: 'Enterprise Tiered',   rate: 0.10,   unit: 'call', description: 'Enterprise tiered — SLA-backed operations' },
  P5: { id: 'P5', name: 'Sovereign Restricted', rate: 1.00,  unit: 'call', description: 'Sovereign restricted — crown-level access only' },
};

// ════════════════════════════════════════════════════════════════════════
//  REWARD CLASSES
// ════════════════════════════════════════════════════════════════════════

const REWARD_CLASSES = {
  R0: { id: 'R0', name: 'No Reward',           multiplier: 0,    description: 'Internal — no external reward' },
  R1: { id: 'R1', name: 'Basic Reward',        multiplier: 0.01, description: 'Basic ecosystem contribution credit' },
  R2: { id: 'R2', name: 'Standard Reward',     multiplier: 0.05, description: 'Standard contribution with lineage tracking' },
  R3: { id: 'R3', name: 'Premium Reward',      multiplier: 0.10, description: 'Premium reward for high-value tool creation' },
  R4: { id: 'R4', name: 'Ecosystem Reward',    multiplier: 0.25, description: 'Full ecosystem reward with revenue share' },
};

// ════════════════════════════════════════════════════════════════════════
//  A. VOIS SUBSTRATE TOOLS (20 canonical always-running tools)
// ════════════════════════════════════════════════════════════════════════

const VOIS_SUBSTRATE_TOOLS = [
  // ─── Core Pulse ────────────────────────────────────────────
  {
    id: 'VOIS-001',
    name: 'PULSE-KEEPER',
    displayName: 'Pulse Keeper',
    category: 'core-pulse',
    domainExtension: '.puls',
    protocols: ['heartbeat-sync', 'phi-rhythm'],
    purpose: 'Maintains the organism heartbeat at 873ms φ-synchronized intervals',
    whenToUse: ['system-startup', 'continuous-operation', 'heartbeat-recovery'],
    inputTypes: ['heartbeat-config', 'rhythm-params'],
    outputTypes: ['pulse-signal', 'beat-count'],
    capabilities: ['beat-generation', 'rhythm-sync', 'pulse-recovery', 'phi-alignment'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'orchestrator'],
    canChainTo: ['VOIS-002', 'VOIS-003', 'VOIS-005'],
    avgLatencyMs: 1,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-002',
    name: 'SYNC-WEAVER',
    displayName: 'Sync Weaver',
    category: 'core-pulse',
    domainExtension: '.puls',
    protocols: ['cross-worker-sync', 'state-propagation'],
    purpose: 'Cross-worker synchronization ensuring coherent state across all 22 workers',
    whenToUse: ['state-divergence', 'worker-restart', 'coherence-check'],
    inputTypes: ['sync-request', 'state-delta'],
    outputTypes: ['sync-confirmation', 'coherence-score'],
    capabilities: ['state-sync', 'delta-propagation', 'conflict-resolution', 'coherence-maintenance'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'orchestrator', 'worker'],
    canChainTo: ['VOIS-001', 'VOIS-004'],
    avgLatencyMs: 3,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-003',
    name: 'FLOW-MONITOR',
    displayName: 'Flow Monitor',
    category: 'core-pulse',
    domainExtension: '.puls',
    protocols: ['signal-observation', 'flow-analysis'],
    purpose: 'Observes signal flow across the organism bus for throughput and bottleneck detection',
    whenToUse: ['performance-monitoring', 'bottleneck-detection', 'flow-audit'],
    inputTypes: ['flow-query', 'observation-window'],
    outputTypes: ['flow-report', 'bottleneck-alert'],
    capabilities: ['flow-tracking', 'throughput-measurement', 'bottleneck-detection', 'signal-tracing'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'telemetry', 'sentinel'],
    canChainTo: ['VOIS-004', 'VOIS-016'],
    avgLatencyMs: 5,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-004',
    name: 'STATE-GUARDIAN',
    displayName: 'State Guardian',
    category: 'core-pulse',
    domainExtension: '.puls',
    protocols: ['state-enforcement', 'consistency-check'],
    purpose: 'Enforces state consistency across all organism components',
    whenToUse: ['state-mutation', 'consistency-violation', 'recovery-verification'],
    inputTypes: ['state-snapshot', 'mutation-event'],
    outputTypes: ['consistency-verdict', 'correction-directive'],
    capabilities: ['state-validation', 'consistency-enforcement', 'rollback-coordination', 'invariant-check'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'memory'],
    canChainTo: ['VOIS-002', 'VOIS-012'],
    avgLatencyMs: 2,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-005',
    name: 'CYCLE-COUNTER',
    displayName: 'Cycle Counter',
    category: 'core-pulse',
    domainExtension: '.puls',
    protocols: ['beat-counting', 'cycle-tracking'],
    purpose: 'Counts beats and cycles for organism lifetime and session tracking',
    whenToUse: ['beat-tracking', 'session-boundary', 'uptime-calculation'],
    inputTypes: ['cycle-query'],
    outputTypes: ['cycle-count', 'uptime-report'],
    capabilities: ['beat-counting', 'cycle-tracking', 'uptime-calculation', 'session-bookkeeping'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'telemetry'],
    canChainTo: ['VOIS-001', 'VOIS-020'],
    avgLatencyMs: 1,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },

  // ─── Intelligence ──────────────────────────────────────────
  {
    id: 'VOIS-006',
    name: 'INFER-ENGINE',
    displayName: 'Inference Engine',
    category: 'intelligence',
    domainExtension: '.cogn',
    protocols: ['inference-dispatch', 'model-routing'],
    purpose: 'Core inference dispatch for all AI model invocations',
    whenToUse: ['ai-request', 'model-invocation', 'inference-pipeline'],
    inputTypes: ['inference-request', 'prompt', 'context-window'],
    outputTypes: ['inference-result', 'completion', 'embedding'],
    capabilities: ['model-dispatch', 'provider-routing', 'fallback-chain', 'cost-tracking'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'aicalls'],
    canChainTo: ['VOIS-007', 'VOIS-008', 'VOIS-009'],
    avgLatencyMs: 50,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-007',
    name: 'PATTERN-SEEKER',
    displayName: 'Pattern Seeker',
    category: 'intelligence',
    domainExtension: '.cogn',
    protocols: ['pattern-recognition', 'anomaly-correlation'],
    purpose: 'Pattern recognition across organism signals and data streams',
    whenToUse: ['anomaly-investigation', 'trend-detection', 'signal-clustering'],
    inputTypes: ['signal-stream', 'data-window'],
    outputTypes: ['pattern-match', 'cluster-report'],
    capabilities: ['pattern-matching', 'signal-clustering', 'trend-extraction', 'correlation-analysis'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'sensors', 'sentinel'],
    canChainTo: ['VOIS-009', 'VOIS-014'],
    avgLatencyMs: 15,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-008',
    name: 'CONTEXT-BUILDER',
    displayName: 'Context Builder',
    category: 'intelligence',
    domainExtension: '.cogn',
    protocols: ['context-assembly', 'window-management'],
    purpose: 'Assembles context windows for inference requests from memory and state',
    whenToUse: ['inference-preparation', 'context-enrichment', 'memory-retrieval'],
    inputTypes: ['context-request', 'memory-query'],
    outputTypes: ['context-window', 'enriched-prompt'],
    capabilities: ['context-assembly', 'memory-retrieval', 'relevance-ranking', 'token-budgeting'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'aicalls', 'memory'],
    canChainTo: ['VOIS-006', 'VOIS-010'],
    avgLatencyMs: 10,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-009',
    name: 'ATTENTION-ROUTER',
    displayName: 'Attention Router',
    category: 'intelligence',
    domainExtension: '.cogn',
    protocols: ['salience-routing', 'priority-dispatch'],
    purpose: 'Salience-weighted routing for directing organism attention to highest-priority signals',
    whenToUse: ['signal-triage', 'priority-determination', 'attention-allocation'],
    inputTypes: ['signal-batch', 'priority-context'],
    outputTypes: ['routed-signal', 'priority-ranking'],
    capabilities: ['salience-scoring', 'priority-routing', 'attention-allocation', 'signal-triage'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'orchestrator'],
    canChainTo: ['VOIS-006', 'VOIS-007'],
    avgLatencyMs: 3,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-010',
    name: 'MEMORY-CONSOLIDATOR',
    displayName: 'Memory Consolidator',
    category: 'intelligence',
    domainExtension: '.cogn',
    protocols: ['memory-consolidation', 'knowledge-compression'],
    purpose: 'Consolidates short-term memory into long-term knowledge structures',
    whenToUse: ['session-end', 'memory-pressure', 'knowledge-extraction'],
    inputTypes: ['memory-buffer', 'consolidation-trigger'],
    outputTypes: ['consolidated-memory', 'knowledge-delta'],
    capabilities: ['memory-merge', 'knowledge-compression', 'decay-management', 'importance-scoring'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'memory'],
    canChainTo: ['VOIS-008', 'VOIS-020'],
    avgLatencyMs: 25,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },

  // ─── Defense ───────────────────────────────────────────────
  {
    id: 'VOIS-011',
    name: 'SENTINEL-WATCH',
    displayName: 'Sentinel Watch',
    category: 'defense',
    domainExtension: '.shield',
    protocols: ['watchdog', 'continuous-monitoring'],
    purpose: '24/7 watchdog monitoring organism health and security posture',
    whenToUse: ['continuous-monitoring', 'threat-watch', 'health-surveillance'],
    inputTypes: ['health-signal', 'security-event'],
    outputTypes: ['alert', 'posture-report'],
    capabilities: ['continuous-monitoring', 'threat-detection', 'health-assessment', 'alert-generation'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'sentinel', 'brain'],
    canChainTo: ['VOIS-012', 'VOIS-014'],
    avgLatencyMs: 2,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-012',
    name: 'INTEGRITY-CHECKER',
    displayName: 'Integrity Checker',
    category: 'defense',
    domainExtension: '.shield',
    protocols: ['hash-chain-verification', 'integrity-audit'],
    purpose: 'Verifies hash chain integrity across all organism audit trails',
    whenToUse: ['audit-verification', 'chain-validation', 'tamper-detection'],
    inputTypes: ['hash-chain', 'audit-segment'],
    outputTypes: ['integrity-verdict', 'chain-report'],
    capabilities: ['hash-verification', 'chain-validation', 'tamper-detection', 'proof-generation'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'sentinel', 'crypto'],
    canChainTo: ['VOIS-015', 'VOIS-004'],
    avgLatencyMs: 5,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-013',
    name: 'BOUNDARY-ENFORCER',
    displayName: 'Boundary Enforcer',
    category: 'defense',
    domainExtension: '.shield',
    protocols: ['permission-boundary', 'access-control'],
    purpose: 'Enforces permission boundaries for all cross-tier invocations',
    whenToUse: ['access-check', 'permission-gate', 'boundary-crossing'],
    inputTypes: ['access-request', 'caller-context'],
    outputTypes: ['access-verdict', 'denial-reason'],
    capabilities: ['permission-check', 'tier-enforcement', 'boundary-validation', 'access-logging'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'sentinel', 'shields'],
    canChainTo: ['VOIS-011', 'VOIS-015'],
    avgLatencyMs: 1,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-014',
    name: 'ANOMALY-DETECTOR',
    displayName: 'Anomaly Detector',
    category: 'defense',
    domainExtension: '.shield',
    protocols: ['anomaly-detection', 'drift-analysis'],
    purpose: 'Detects drift, anomalies, and unexpected patterns in organism behavior',
    whenToUse: ['drift-check', 'anomaly-alert', 'behavior-analysis'],
    inputTypes: ['signal-window', 'baseline-model'],
    outputTypes: ['anomaly-report', 'drift-score'],
    capabilities: ['anomaly-detection', 'drift-scoring', 'baseline-comparison', 'alert-escalation'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'sentinel', 'sensors', 'brain'],
    canChainTo: ['VOIS-011', 'VOIS-007'],
    avgLatencyMs: 8,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-015',
    name: 'SEAL-VERIFIER',
    displayName: 'Seal Verifier',
    category: 'defense',
    domainExtension: '.shield',
    protocols: ['cryptographic-seal', 'signature-verification'],
    purpose: 'Verifies cryptographic seals on contracts, settlements, and audit entries',
    whenToUse: ['seal-verification', 'contract-validation', 'signature-check'],
    inputTypes: ['sealed-payload', 'verification-request'],
    outputTypes: ['verification-result', 'seal-status'],
    capabilities: ['seal-verification', 'signature-check', 'certificate-validation', 'proof-audit'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'sentinel', 'crypto', 'contracts'],
    canChainTo: ['VOIS-012', 'VOIS-013'],
    avgLatencyMs: 3,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },

  // ─── Infrastructure ────────────────────────────────────────
  {
    id: 'VOIS-016',
    name: 'RESOURCE-BALANCER',
    displayName: 'Resource Balancer',
    category: 'infrastructure',
    domainExtension: '.infra',
    protocols: ['load-distribution', 'resource-allocation'],
    purpose: 'Distributes load across workers and allocates resources based on demand',
    whenToUse: ['load-spike', 'resource-allocation', 'worker-scaling'],
    inputTypes: ['load-report', 'resource-request'],
    outputTypes: ['allocation-plan', 'balance-report'],
    capabilities: ['load-balancing', 'resource-allocation', 'worker-scaling', 'priority-scheduling'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'orchestrator', 'infra'],
    canChainTo: ['VOIS-003', 'VOIS-017'],
    avgLatencyMs: 4,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-017',
    name: 'CONNECTION-POOL',
    displayName: 'Connection Pool',
    category: 'infrastructure',
    domainExtension: '.infra',
    protocols: ['connection-management', 'pool-maintenance'],
    purpose: 'Manages connection pools for external API providers and data sources',
    whenToUse: ['connection-request', 'pool-exhaustion', 'connection-health'],
    inputTypes: ['connection-request', 'pool-config'],
    outputTypes: ['connection-handle', 'pool-status'],
    capabilities: ['pool-management', 'connection-reuse', 'health-checking', 'graceful-drain'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'adapters', 'infra'],
    canChainTo: ['VOIS-016', 'VOIS-018'],
    avgLatencyMs: 2,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-018',
    name: 'CACHE-OPTIMIZER',
    displayName: 'Cache Optimizer',
    category: 'infrastructure',
    domainExtension: '.infra',
    protocols: ['cache-strategy', 'eviction-policy'],
    purpose: 'Optimizes cache strategy across all organism caching layers',
    whenToUse: ['cache-miss-spike', 'memory-pressure', 'strategy-tuning'],
    inputTypes: ['cache-metrics', 'strategy-params'],
    outputTypes: ['strategy-update', 'eviction-plan'],
    capabilities: ['cache-analysis', 'strategy-optimization', 'eviction-planning', 'hit-rate-tuning'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'infra', 'memory'],
    canChainTo: ['VOIS-016', 'VOIS-019'],
    avgLatencyMs: 3,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-019',
    name: 'QUEUE-PROCESSOR',
    displayName: 'Queue Processor',
    category: 'infrastructure',
    domainExtension: '.infra',
    protocols: ['queue-drain', 'backpressure-management'],
    purpose: 'Drains queued operations with backpressure management and priority ordering',
    whenToUse: ['queue-backlog', 'batch-processing', 'priority-drain'],
    inputTypes: ['queue-item', 'drain-config'],
    outputTypes: ['processed-count', 'queue-status'],
    capabilities: ['queue-drain', 'priority-ordering', 'backpressure', 'batch-processing'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'infra', 'orchestrator'],
    canChainTo: ['VOIS-016', 'VOIS-020'],
    avgLatencyMs: 2,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
  {
    id: 'VOIS-020',
    name: 'LOG-STREAMER',
    displayName: 'Log Streamer',
    category: 'infrastructure',
    domainExtension: '.infra',
    protocols: ['structured-logging', 'log-routing'],
    purpose: 'Structured logging and log routing across all organism components',
    whenToUse: ['log-emission', 'audit-trail', 'debug-trace'],
    inputTypes: ['log-entry', 'log-query'],
    outputTypes: ['log-stream', 'log-aggregate'],
    capabilities: ['structured-logging', 'log-routing', 'log-aggregation', 'retention-management'],
    securityTier: 'INTERNAL',
    allowedCallers: ['organism', 'brain', 'telemetry', 'sentinel'],
    canChainTo: ['VOIS-005', 'VOIS-012'],
    avgLatencyMs: 1,
    pricingClass: 'P0',
    rewardClass: 'R0',
    lineageTrace: true,
    shadowSafe: true,
    runtimeTruth: 'implicit_backend_function',
    exposureClass: 'internal',
    status: 'registered',
    version: '5',
  },
];

// ════════════════════════════════════════════════════════════════════════
//  B. FLEET TOOL REGISTRY (200 tools: TOOL-061 through TOOL-260)
// ════════════════════════════════════════════════════════════════════════

const FLEET_TOOL_CATEGORIES = {
  aicalls: {
    worker: 'aicalls-worker',
    domainExtension: '.cogn',
    pricingClass: 'P2',
    rewardClass: 'R2',
    permissionTierMin: 'ENTERPRISE',
    exposureClass: 'partner',
  },
  blueprints: {
    worker: 'blueprints-worker',
    domainExtension: '.arch',
    pricingClass: 'P3',
    rewardClass: 'R2',
    permissionTierMin: 'ENTERPRISE',
    exposureClass: 'enterprise',
  },
  recipes: {
    worker: 'recipes-worker',
    domainExtension: '.proc',
    pricingClass: 'P2',
    rewardClass: 'R1',
    permissionTierMin: 'ENTERPRISE',
    exposureClass: 'enterprise',
  },
  lenses: {
    worker: 'lenses-worker',
    domainExtension: '.view',
    pricingClass: 'P1',
    rewardClass: 'R1',
    permissionTierMin: 'PARTNER',
    exposureClass: 'partner',
  },
  hooks: {
    worker: 'hooks-worker',
    domainExtension: '.hook',
    pricingClass: 'P1',
    rewardClass: 'R1',
    permissionTierMin: 'INTERNAL',
    exposureClass: 'internal',
  },
  triggers: {
    worker: 'triggers-worker',
    domainExtension: '.trig',
    pricingClass: 'P1',
    rewardClass: 'R1',
    permissionTierMin: 'INTERNAL',
    exposureClass: 'internal',
  },
  adapters: {
    worker: 'adapters-worker',
    domainExtension: '.adpt',
    pricingClass: 'P2',
    rewardClass: 'R2',
    permissionTierMin: 'PARTNER',
    exposureClass: 'partner',
  },
  sensors: {
    worker: 'sensors-worker',
    domainExtension: '.sens',
    pricingClass: 'P0',
    rewardClass: 'R0',
    permissionTierMin: 'INTERNAL',
    exposureClass: 'internal',
  },
  shields: {
    worker: 'shields-worker',
    domainExtension: '.shield',
    pricingClass: 'P0',
    rewardClass: 'R0',
    permissionTierMin: 'INTERNAL',
    exposureClass: 'internal',
  },
};

// Raw tool definitions: [id, camelCaseName, category-key]
const FLEET_TOOL_DEFS = [
  // ─── aicalls (TOOL-061–100) ────────────────────────────────
  [61,  'goalDecompose',       'aicalls'],
  [62,  'hallucinationCheck',  'aicalls'],
  [63,  'promptChain',         'aicalls'],
  [64,  'reasoningValidate',   'aicalls'],
  [65,  'contextWindow',       'aicalls'],
  [66,  'tokenBudget',         'aicalls'],
  [67,  'responseGrade',       'aicalls'],
  [68,  'chainOfThought',      'aicalls'],
  [69,  'fewShotSelect',       'aicalls'],
  [70,  'selfCritique',        'aicalls'],
  [71,  'factExtract',         'aicalls'],
  [72,  'claimVerify',         'aicalls'],
  [73,  'biasDetect',          'aicalls'],
  [74,  'uncertaintyQuantify', 'aicalls'],
  [75,  'analogyGenerate',     'aicalls'],
  [76,  'hypothesisForm',      'aicalls'],
  [77,  'counterArgument',     'aicalls'],
  [78,  'summaryAbstract',     'aicalls'],
  [79,  'entityExtract',       'aicalls'],
  [80,  'sentimentAnalyze',    'aicalls'],
  [81,  'intentClassify',      'aicalls'],
  [82,  'topicModel',          'aicalls'],
  [83,  'keywordExpand',       'aicalls'],
  [84,  'questionGenerate',    'aicalls'],
  [85,  'answerSynthesize',    'aicalls'],
  [86,  'codeGenerate',        'aicalls'],
  [87,  'codeReview',          'aicalls'],
  [88,  'codeExplain',         'aicalls'],
  [89,  'testGenerate',        'aicalls'],
  [90,  'docGenerate',         'aicalls'],
  [91,  'translateLang',       'aicalls'],
  [92,  'paraphraseRewrite',   'aicalls'],
  [93,  'styleTransfer',       'aicalls'],
  [94,  'toneAdjust',          'aicalls'],
  [95,  'formatConvert',       'aicalls'],
  [96,  'schemaValidate',      'aicalls'],
  [97,  'pipelineOrchestrate', 'aicalls'],
  [98,  'fallbackRoute',       'aicalls'],
  [99,  'cacheLookup',         'aicalls'],
  [100, 'metaPromptOptimize',  'aicalls'],

  // ─── blueprints (TOOL-101–120) ─────────────────────────────
  [101, 'microserviceBlueprint',   'blueprints'],
  [102, 'eventDrivenBlueprint',    'blueprints'],
  [103, 'cqrsBlueprint',           'blueprints'],
  [104, 'dataLakeBlueprint',       'blueprints'],
  [105, 'apiGatewayBlueprint',     'blueprints'],
  [106, 'workerPoolBlueprint',     'blueprints'],
  [107, 'pubsubBlueprint',         'blueprints'],
  [108, 'stateMachineBlueprint',   'blueprints'],
  [109, 'pipelineBlueprint',       'blueprints'],
  [110, 'authFlowBlueprint',       'blueprints'],
  [111, 'monitoringBlueprint',     'blueprints'],
  [112, 'cicdBlueprint',           'blueprints'],
  [113, 'canaryBlueprint',         'blueprints'],
  [114, 'cacheLayerBlueprint',     'blueprints'],
  [115, 'searchIndexBlueprint',    'blueprints'],
  [116, 'mlPipelineBlueprint',     'blueprints'],
  [117, 'graphDBBlueprint',        'blueprints'],
  [118, 'streamProcessBlueprint',  'blueprints'],
  [119, 'edgeComputeBlueprint',    'blueprints'],
  [120, 'blockchainBlueprint',     'blueprints'],

  // ─── recipes (TOOL-121–140) ────────────────────────────────
  [121, 'onboardingRecipe',        'recipes'],
  [122, 'deploymentRecipe',        'recipes'],
  [123, 'incidentResponseRecipe',  'recipes'],
  [124, 'dataIngestRecipe',        'recipes'],
  [125, 'contentPipelineRecipe',   'recipes'],
  [126, 'auditRecipe',             'recipes'],
  [127, 'migrationRecipe',         'recipes'],
  [128, 'testSuiteRecipe',         'recipes'],
  [129, 'reportingRecipe',         'recipes'],
  [130, 'approvalRecipe',          'recipes'],
  [131, 'backupRestoreRecipe',     'recipes'],
  [132, 'scalingRecipe',           'recipes'],
  [133, 'complianceRecipe',        'recipes'],
  [134, 'featureToggleRecipe',     'recipes'],
  [135, 'cacheWarmRecipe',         'recipes'],
  [136, 'alertEscalationRecipe',   'recipes'],
  [137, 'capacityPlanRecipe',      'recipes'],
  [138, 'securityScanRecipe',      'recipes'],
  [139, 'performanceTuneRecipe',   'recipes'],
  [140, 'disasterRecoveryRecipe',  'recipes'],

  // ─── lenses (TOOL-141–160) ─────────────────────────────────
  [141, 'timelineLens',            'lenses'],
  [142, 'hierarchyLens',           'lenses'],
  [143, 'networkLens',             'lenses'],
  [144, 'heatmapLens',             'lenses'],
  [145, 'flowLens',                'lenses'],
  [146, 'distributionLens',        'lenses'],
  [147, 'comparisonLens',          'lenses'],
  [148, 'trendLens',               'lenses'],
  [149, 'anomalyLens',             'lenses'],
  [150, 'clusterLens',             'lenses'],
  [151, 'correlationLens',         'lenses'],
  [152, 'geospatialLens',          'lenses'],
  [153, 'sentimentLens',           'lenses'],
  [154, 'riskLens',                'lenses'],
  [155, 'costLens',                'lenses'],
  [156, 'performanceLens',         'lenses'],
  [157, 'securityLens',            'lenses'],
  [158, 'complianceLens',          'lenses'],
  [159, 'userJourneyLens',         'lenses'],
  [160, 'systemHealthLens',        'lenses'],

  // ─── hooks (TOOL-161–180) ──────────────────────────────────
  [161, 'onCoherenceChange',       'hooks'],
  [162, 'onEmergence',             'hooks'],
  [163, 'onWorkerDeath',           'hooks'],
  [164, 'onThreatDetected',        'hooks'],
  [165, 'onMemoryEncode',          'hooks'],
  [166, 'onMemoryRecall',          'hooks'],
  [167, 'onTransaction',           'hooks'],
  [168, 'onBuildComplete',         'hooks'],
  [169, 'onAnomalyDetected',       'hooks'],
  [170, 'onHeartbeat',             'hooks'],
  [171, 'onPostureChange',         'hooks'],
  [172, 'onSpike',                 'hooks'],
  [173, 'onChainExtend',           'hooks'],
  [174, 'onTaskComplete',          'hooks'],
  [175, 'onBatchComplete',         'hooks'],
  [176, 'onContainmentDecay',      'hooks'],
  [177, 'onScaleEvent',            'hooks'],
  [178, 'onConfigChange',          'hooks'],
  [179, 'onBusOverflow',           'hooks'],
  [180, 'onFleetStateChange',      'hooks'],

  // ─── triggers (TOOL-181–200) ───────────────────────────────
  [181, 'thresholdTrigger',        'triggers'],
  [182, 'scheduleTrigger',         'triggers'],
  [183, 'rateLimitTrigger',        'triggers'],
  [184, 'budgetTrigger',           'triggers'],
  [185, 'healthTrigger',           'triggers'],
  [186, 'capacityTrigger',         'triggers'],
  [187, 'deadlineTrigger',         'triggers'],
  [188, 'patternTrigger',          'triggers'],
  [189, 'driftTrigger',            'triggers'],
  [190, 'quorumTrigger',           'triggers'],
  [191, 'cooldownTrigger',         'triggers'],
  [192, 'cascadeTrigger',          'triggers'],
  [193, 'absenceTrigger',          'triggers'],
  [194, 'saturationTrigger',       'triggers'],
  [195, 'oscillationTrigger',      'triggers'],
  [196, 'convergenceTrigger',      'triggers'],
  [197, 'divergenceTrigger',       'triggers'],
  [198, 'stalenessTrigger',        'triggers'],
  [199, 'compositeAndTrigger',     'triggers'],
  [200, 'compositeOrTrigger',      'triggers'],

  // ─── adapters (TOOL-201–220) ───────────────────────────────
  [201, 'openaiAdapter',           'adapters'],
  [202, 'anthropicAdapter',        'adapters'],
  [203, 'googleAdapter',           'adapters'],
  [204, 'mistralAdapter',          'adapters'],
  [205, 'cohereAdapter',           'adapters'],
  [206, 'huggingfaceAdapter',      'adapters'],
  [207, 'replicateAdapter',        'adapters'],
  [208, 'stabilityAdapter',        'adapters'],
  [209, 'elevenLabsAdapter',       'adapters'],
  [210, 'pineconeAdapter',         'adapters'],
  [211, 'weaviateAdapter',         'adapters'],
  [212, 'supabaseAdapter',         'adapters'],
  [213, 'stripeAdapter',           'adapters'],
  [214, 'twilioAdapter',           'adapters'],
  [215, 'sendgridAdapter',         'adapters'],
  [216, 'githubAdapter',           'adapters'],
  [217, 'slackAdapter',            'adapters'],
  [218, 'webhookAdapter',          'adapters'],
  [219, 'graphqlAdapter',          'adapters'],
  [220, 'restAdapter',             'adapters'],

  // ─── sensors (TOOL-221–240) ────────────────────────────────
  [221, 'cpuSensor',               'sensors'],
  [222, 'memorySensor',            'sensors'],
  [223, 'latencySensor',           'sensors'],
  [224, 'throughputSensor',        'sensors'],
  [225, 'errorRateSensor',         'sensors'],
  [226, 'coherenceSensor',         'sensors'],
  [227, 'emergenceSensor',         'sensors'],
  [228, 'driftSensor',             'sensors'],
  [229, 'arousalSensor',           'sensors'],
  [230, 'entropyMeter',            'sensors'],
  [231, 'networkSensor',           'sensors'],
  [232, 'storageSensor',           'sensors'],
  [233, 'queueDepthSensor',        'sensors'],
  [234, 'workerLoadSensor',        'sensors'],
  [235, 'patternDensitySensor',    'sensors'],
  [236, 'signalStrengthSensor',    'sensors'],
  [237, 'chainHealthSensor',       'sensors'],
  [238, 'tokenFlowSensor',         'sensors'],
  [239, 'heritageFieldSensor',     'sensors'],
  [240, 'phiResonanceSensor',      'sensors'],

  // ─── shields (TOOL-241–260) ────────────────────────────────
  [241, 'inputSanitizer',          'shields'],
  [242, 'outputFilter',            'shields'],
  [243, 'rateLimiter',             'shields'],
  [244, 'injectionGuard',          'shields'],
  [245, 'xssShield',               'shields'],
  [246, 'privacyMask',             'shields'],
  [247, 'contentModerator',        'shields'],
  [248, 'toxicityFilter',          'shields'],
  [249, 'copyrightChecker',        'shields'],
  [250, 'biasGuard',               'shields'],
  [251, 'factGrounder',            'shields'],
  [252, 'jailbreakDetector',       'shields'],
  [253, 'dataLeakPrevention',      'shields'],
  [254, 'circuitBreaker',          'shields'],
  [255, 'bulkhead',                'shields'],
  [256, 'retryShield',             'shields'],
  [257, 'timeoutGuard',            'shields'],
  [258, 'quotaEnforcer',           'shields'],
  [259, 'auditLogger',             'shields'],
  [260, 'integrityVerifier',       'shields'],
];

// Convert camelCase to kebab-case for call IDs
function toKebab(name) {
  return name.replace(/([a-z0-9])([A-Z])/g, '$1-$2').toLowerCase();
}

// Build the FLEET_TOOL_REGISTRY from definitions + category defaults
const FLEET_TOOL_REGISTRY = FLEET_TOOL_DEFS.map(function (def, idx) {
  const id = def[0];
  const name = def[1];
  const catKey = def[2];
  const cat = FLEET_TOOL_CATEGORIES[catKey];
  return {
    id: id,
    callId: 'vois.' + catKey + '.' + toKebab(name) + '.v1',
    name: name,
    worker: cat.worker,
    category: catKey,
    domainExtension: cat.domainExtension,
    pricingClass: cat.pricingClass,
    rewardClass: cat.rewardClass,
    permissionTierMin: cat.permissionTierMin,
    exposureClass: cat.exposureClass,
    phiWeight: Math.pow(PHI_INV, idx % 40),
    status: 'registered',
  };
});

// ════════════════════════════════════════════════════════════════════════
//  C. PROTOCOL CALL REGISTRY (55 enterprise protocols)
// ════════════════════════════════════════════════════════════════════════

const PROTOCOL_DEFS = [
  // ─── Client Lifecycle (1–5) ────────────────────────────────
  [1,  'clientOnboard',              'client-lifecycle'],
  [2,  'clientOffboard',             'client-lifecycle'],
  [3,  'clientSuspend',              'client-lifecycle'],
  [4,  'clientMigrate',              'client-lifecycle'],
  [5,  'clientHealthCheck',          'client-lifecycle'],

  // ─── AI Pipeline (6–10) ────────────────────────────────────
  [6,  'aiRequestPipeline',          'ai-pipeline'],
  [7,  'aiFailoverChain',            'ai-pipeline'],
  [8,  'aiCostGovernor',             'ai-pipeline'],
  [9,  'aiQualityGate',              'ai-pipeline'],
  [10, 'aiModelRouter',              'ai-pipeline'],

  // ─── Data Governance (11–15) ───────────────────────────────
  [11, 'dataIngestPipeline',         'data-governance'],
  [12, 'dataExportPipeline',         'data-governance'],
  [13, 'dataRetention',              'data-governance'],
  [14, 'privacyCompliance',          'data-governance'],
  [15, 'dataLineage',                'data-governance'],

  // ─── Security (16–20) ─────────────────────────────────────
  [16, 'zeroTrustGate',              'security'],
  [17, 'threatResponse',             'security'],
  [18, 'auditTrail',                 'security'],
  [19, 'secretsRotation',            'security'],
  [20, 'incidentEscalation',         'security'],

  // ─── Platform Ops (21–25) ──────────────────────────────────
  [21, 'autoScaling',                'platform-ops'],
  [22, 'canaryDeployment',           'platform-ops'],
  [23, 'circuitBreaker',             'platform-ops'],
  [24, 'healthOrchestrator',         'platform-ops'],
  [25, 'capacityPlanning',           'platform-ops'],

  // ─── Billing (26–28) ──────────────────────────────────────
  [26, 'usageMetering',              'billing'],
  [27, 'billingCycle',               'billing'],
  [28, 'quotaEnforcement',           'billing'],

  // ─── Research (29–30) ──────────────────────────────────────
  [29, 'experimentPipeline',         'research'],
  [30, 'feedbackLoop',               'research'],

  // ─── Multi-Agent (31–35) ───────────────────────────────────
  [31, 'agentSwarmDeploy',           'multi-agent'],
  [32, 'agentConsensus',             'multi-agent'],
  [33, 'agentNegotiation',           'multi-agent'],
  [34, 'agentSelfHeal',              'multi-agent'],
  [35, 'agentLoadBalance',           'multi-agent'],

  // ─── Intelligence (36–40) ──────────────────────────────────
  [36, 'continuousLearning',         'intelligence'],
  [37, 'anomalyDetection',           'intelligence'],
  [38, 'knowledgeDistill',           'intelligence'],
  [39, 'predictiveAnalytics',        'intelligence'],
  [40, 'sentinelShieldSensorLoop',   'intelligence'],

  // ─── Compliance (41–45) ────────────────────────────────────
  [41, 'gdprDataRequest',            'compliance'],
  [42, 'gdprDataDeletion',           'compliance'],
  [43, 'soc2AuditPrep',              'compliance'],
  [44, 'licenseEnforcement',         'compliance'],
  [45, 'ipProtection',               'compliance'],

  // ─── Integration (46–50) ───────────────────────────────────
  [46, 'webhookPipeline',            'integration'],
  [47, 'apiGateway',                 'integration'],
  [48, 'eventBridge',                'integration'],
  [49, 'dataSync',                   'integration'],
  [50, 'graphqlFederation',          'integration'],

  // ─── SDK (51–55) ───────────────────────────────────────────
  [51, 'sdkApiCall',                 'sdk'],
  [52, 'sdkAuth',                    'sdk'],
  [53, 'sdkBatchOperation',          'sdk'],
  [54, 'sdkWebSocket',              'sdk'],
  [55, 'sdkDocGenerate',             'sdk'],
];

const PROTOCOL_CATEGORY_DEFAULTS = {
  'client-lifecycle': { pricingClass: 'P3', rewardClass: 'R1', permissionTierMin: 'ENTERPRISE', exposureClass: 'enterprise' },
  'ai-pipeline':      { pricingClass: 'P3', rewardClass: 'R2', permissionTierMin: 'PARTNER',    exposureClass: 'partner' },
  'data-governance':  { pricingClass: 'P4', rewardClass: 'R1', permissionTierMin: 'ENTERPRISE', exposureClass: 'enterprise' },
  'security':         { pricingClass: 'P4', rewardClass: 'R1', permissionTierMin: 'INTERNAL',   exposureClass: 'internal' },
  'platform-ops':     { pricingClass: 'P3', rewardClass: 'R1', permissionTierMin: 'INTERNAL',   exposureClass: 'internal' },
  'billing':          { pricingClass: 'P4', rewardClass: 'R2', permissionTierMin: 'ENTERPRISE', exposureClass: 'enterprise' },
  'research':         { pricingClass: 'P3', rewardClass: 'R2', permissionTierMin: 'PARTNER',    exposureClass: 'partner' },
  'multi-agent':      { pricingClass: 'P4', rewardClass: 'R2', permissionTierMin: 'PARTNER',    exposureClass: 'partner' },
  'intelligence':     { pricingClass: 'P3', rewardClass: 'R2', permissionTierMin: 'INTERNAL',   exposureClass: 'internal' },
  'compliance':       { pricingClass: 'P4', rewardClass: 'R1', permissionTierMin: 'ENTERPRISE', exposureClass: 'enterprise' },
  'integration':      { pricingClass: 'P3', rewardClass: 'R1', permissionTierMin: 'PARTNER',    exposureClass: 'partner' },
  'sdk':              { pricingClass: 'P3', rewardClass: 'R1', permissionTierMin: 'ENTERPRISE', exposureClass: 'enterprise' },
};

const PROTOCOL_CALL_REGISTRY = PROTOCOL_DEFS.map(function (def) {
  const id = def[0];
  const name = def[1];
  const category = def[2];
  const defaults = PROTOCOL_CATEGORY_DEFAULTS[category] || PROTOCOL_CATEGORY_DEFAULTS['client-lifecycle'];
  return {
    id: id,
    callId: 'vois.protocol.' + toKebab(name) + '.v1',
    name: name,
    category: category,
    pricingClass: defaults.pricingClass,
    rewardClass: defaults.rewardClass,
    permissionTierMin: defaults.permissionTierMin,
    exposureClass: defaults.exposureClass,
    status: 'registered',
  };
});

// ════════════════════════════════════════════════════════════════════════
//  UNIFIED REGISTRY MAP
// ════════════════════════════════════════════════════════════════════════

const toolMap = new Map();

// Register substrate tools
for (const tool of VOIS_SUBSTRATE_TOOLS) {
  toolMap.set(tool.id, tool);
  toolMap.set(tool.name, tool);
  toolMap.set('vois.substrate.' + toKebab(tool.name) + '.v1', tool);
}

// Register fleet tools
for (const tool of FLEET_TOOL_REGISTRY) {
  toolMap.set('TOOL-' + String(tool.id).padStart(3, '0'), tool);
  toolMap.set(tool.callId, tool);
  toolMap.set(tool.name, tool);
}

// Register protocol calls
for (const proto of PROTOCOL_CALL_REGISTRY) {
  toolMap.set('PROTOCOL-' + String(proto.id).padStart(3, '0'), proto);
  toolMap.set(proto.callId, proto);
  toolMap.set(proto.name, proto);
}

// ════════════════════════════════════════════════════════════════════════
//  FNV-1a HASHING
// ════════════════════════════════════════════════════════════════════════

function hashEvent(data) {
  let hash = 2166136261;
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
//  CALL CONTRACT BUILDER
// ════════════════════════════════════════════════════════════════════════

function buildCallContract(callId) {
  const entry = toolMap.get(callId);
  if (!entry) return null;

  const pricing = PRICING_CLASSES[entry.pricingClass] || PRICING_CLASSES.P0;
  const reward = REWARD_CLASSES[entry.rewardClass] || REWARD_CLASSES.R0;
  const permTier = PERMISSION_TIERS[entry.permissionTierMin || entry.securityTier || 'INTERNAL'];

  return {
    callId: entry.callId || callId,
    name: entry.name,
    category: entry.category,
    version: entry.version || '1',
    license: MARKETPLACE_LICENSE.id,
    pricing: {
      class: pricing.id,
      name: pricing.name,
      rate: pricing.rate,
      unit: pricing.unit,
    },
    reward: {
      class: reward.id,
      name: reward.name,
      multiplier: reward.multiplier,
    },
    permissions: {
      minimumTier: permTier ? permTier.label : 'Internal',
      requiresAuth: permTier ? permTier.requiresAuth : false,
      rateLimit: permTier ? permTier.rateLimit : 0,
    },
    exposureClass: entry.exposureClass || 'internal',
    shadowSafe: entry.shadowSafe !== undefined ? entry.shadowSafe : true,
    lineageTrace: entry.lineageTrace !== undefined ? entry.lineageTrace : true,
    sla: {
      maxLatencyMs: entry.avgLatencyMs ? entry.avgLatencyMs * 3 : 1000,
      availability: 0.999,
    },
    generatedAt: Date.now(),
    proofHash: hashEvent('contract:' + callId + ':' + Date.now()),
  };
}

// ════════════════════════════════════════════════════════════════════════
//  CALLER REGISTRY
// ════════════════════════════════════════════════════════════════════════

function registerCaller(callerId, tier, config) {
  if (callerRegistry.size >= MAX_CALLERS) {
    return { error: 'MAX_CALLERS_REACHED', message: 'Caller registry at capacity (' + MAX_CALLERS + ')' };
  }

  const permTier = PERMISSION_TIERS[tier];
  if (!permTier) {
    return { error: 'INVALID_TIER', message: 'Unknown permission tier: ' + tier };
  }

  const caller = {
    callerId: callerId,
    tier: tier,
    tierLevel: permTier.level,
    config: config || {},
    registeredAt: Date.now(),
    lastActive: Date.now(),
    status: 'active',
    healthScore: 1.0,
    usage: {
      totalInvocations: 0,
      totalSettled: 0,
      totalSpent: 0,
      totalErrors: 0,
      activeInvocations: 0,
      quotaUsed: 0,
      quotaLimit: config && config.quotaLimit ? config.quotaLimit : (permTier.rateLimit || 10000),
    },
  };

  callerRegistry.set(callerId, caller);
  logAudit('caller-registered', { callerId: callerId, tier: tier });
  return caller;
}

function getCaller(callerId) {
  return callerRegistry.get(callerId) || null;
}

// ════════════════════════════════════════════════════════════════════════
//  PERMISSION CHECK
// ════════════════════════════════════════════════════════════════════════

function checkPermission(callerId, callId) {
  const caller = callerRegistry.get(callerId);
  if (!caller) return { allowed: false, reason: 'CALLER_NOT_REGISTERED' };
  if (caller.status !== 'active') return { allowed: false, reason: 'CALLER_SUSPENDED' };

  const entry = toolMap.get(callId);
  if (!entry) return { allowed: false, reason: 'CALL_NOT_FOUND' };

  const requiredTier = entry.permissionTierMin || entry.securityTier || 'INTERNAL';
  const requiredLevel = PERMISSION_TIERS[requiredTier] ? PERMISSION_TIERS[requiredTier].level : 0;
  const callerLevel = caller.tierLevel;

  // Lower level = higher privilege (INTERNAL=0, PUBLIC=4)
  if (callerLevel > requiredLevel) {
    return { allowed: false, reason: 'INSUFFICIENT_TIER', required: requiredTier, actual: caller.tier };
  }

  // Rate limit check
  const tierDef = PERMISSION_TIERS[caller.tier];
  if (tierDef && tierDef.rateLimit > 0 && caller.usage.quotaUsed >= caller.usage.quotaLimit) {
    return { allowed: false, reason: 'QUOTA_EXCEEDED' };
  }

  return { allowed: true, tier: caller.tier, callId: callId };
}

// ════════════════════════════════════════════════════════════════════════
//  INVOCATION ENGINE
// ════════════════════════════════════════════════════════════════════════

function invoke(callId, callerId, params) {
  // Permission check
  const perm = checkPermission(callerId, callId);
  if (!perm.allowed) {
    totalErrors++;
    logAudit('invocation-denied', { callId: callId, callerId: callerId, reason: perm.reason });
    return { error: 'PERMISSION_DENIED', reason: perm.reason, callId: callId };
  }

  if (activeInvocations.size >= MAX_INVOCATIONS) {
    totalErrors++;
    return { error: 'MAX_INVOCATIONS_REACHED', message: 'Active invocation limit reached (' + MAX_INVOCATIONS + ')' };
  }

  invocationCounter++;
  totalInvocations++;
  const invocationId = 'INV-' + invocationCounter + '-' + hashEvent(callId + callerId + Date.now()).toString(36);

  const entry = toolMap.get(callId);
  const pricing = PRICING_CLASSES[entry.pricingClass || 'P0'];

  const invocation = {
    invocationId: invocationId,
    callId: callId,
    callerId: callerId,
    toolName: entry.name,
    category: entry.category,
    params: params || {},
    status: 'dispatched',
    startedAt: Date.now(),
    completedAt: null,
    result: null,
    error: null,
    cost: pricing.rate,
    proofHash: hashEvent('invoke:' + invocationId + ':' + Date.now()),
  };

  activeInvocations.set(invocationId, invocation);

  // Update caller usage
  const caller = callerRegistry.get(callerId);
  if (caller) {
    caller.usage.totalInvocations++;
    caller.usage.activeInvocations++;
    caller.usage.quotaUsed++;
    caller.lastActive = Date.now();
  }

  logAudit('invocation-dispatched', { invocationId: invocationId, callId: callId, callerId: callerId });

  // Simulate dispatch completion asynchronously
  completeInvocation(invocationId, {
    status: 'success',
    output: { tool: entry.name, dispatched: true, phi: PHI },
  });

  return {
    invocationId: invocationId,
    callId: callId,
    callerId: callerId,
    status: 'dispatched',
    cost: pricing.rate,
  };
}

function completeInvocation(invocationId, result) {
  const invocation = activeInvocations.get(invocationId);
  if (!invocation) return null;

  invocation.status = 'completed';
  invocation.completedAt = Date.now();
  invocation.result = result;
  invocation.duration = invocation.completedAt - invocation.startedAt;

  // Update caller usage
  const caller = callerRegistry.get(invocation.callerId);
  if (caller) {
    caller.usage.activeInvocations = Math.max(0, caller.usage.activeInvocations - 1);
    caller.usage.totalSpent += invocation.cost;
  }

  logAudit('invocation-completed', { invocationId: invocationId, duration: invocation.duration });

  self.postMessage({
    type: 'invocation-complete',
    invocationId: invocationId,
    callId: invocation.callId,
    callerId: invocation.callerId,
    status: 'completed',
    duration: invocation.duration,
    cost: invocation.cost,
  });

  return invocation;
}

function failInvocation(invocationId, error) {
  const invocation = activeInvocations.get(invocationId);
  if (!invocation) return null;

  invocation.status = 'failed';
  invocation.completedAt = Date.now();
  invocation.error = error;
  invocation.duration = invocation.completedAt - invocation.startedAt;
  totalErrors++;

  const caller = callerRegistry.get(invocation.callerId);
  if (caller) {
    caller.usage.activeInvocations = Math.max(0, caller.usage.activeInvocations - 1);
    caller.usage.totalErrors++;
  }

  logAudit('invocation-failed', { invocationId: invocationId, error: error });

  return invocation;
}

// ════════════════════════════════════════════════════════════════════════
//  SETTLEMENT ENGINE
// ════════════════════════════════════════════════════════════════════════

function settleInvocation(invocationId) {
  const invocation = activeInvocations.get(invocationId);
  if (!invocation) {
    return { error: 'INVOCATION_NOT_FOUND', invocationId: invocationId };
  }
  if (invocation.status !== 'completed' && invocation.status !== 'failed') {
    return { error: 'INVOCATION_NOT_SETTLED', status: invocation.status };
  }

  if (settlementLedger.size >= MAX_SETTLEMENTS) {
    // Evict oldest settlement
    const oldest = settlementLedger.keys().next().value;
    settlementLedger.delete(oldest);
  }

  settlementCounter++;
  totalSettlements++;
  const settlementId = 'SETTLE-' + settlementCounter + '-' + hashEvent(invocationId + Date.now()).toString(36);

  const entry = toolMap.get(invocation.callId);
  const pricing = PRICING_CLASSES[entry ? entry.pricingClass || 'P0' : 'P0'];
  const reward = REWARD_CLASSES[entry ? entry.rewardClass || 'R0' : 'R0'];

  const settlement = {
    settlementId: settlementId,
    invocationId: invocationId,
    callId: invocation.callId,
    callerId: invocation.callerId,
    toolName: invocation.toolName,
    status: invocation.status === 'completed' ? 'settled' : 'settled-with-error',
    cost: invocation.cost,
    rewardAmount: invocation.cost * reward.multiplier,
    pricingClass: pricing.id,
    rewardClass: reward.id,
    duration: invocation.duration || 0,
    settledAt: Date.now(),
    proofHash: hashEvent('settle:' + settlementId + ':' + invocationId + ':' + Date.now()),
  };

  settlementLedger.set(settlementId, settlement);

  // Update caller settled count
  const caller = callerRegistry.get(invocation.callerId);
  if (caller) {
    caller.usage.totalSettled++;
  }

  // Remove from active invocations
  activeInvocations.delete(invocationId);

  logAudit('settlement-complete', { settlementId: settlementId, invocationId: invocationId, cost: settlement.cost });

  self.postMessage({
    type: 'settlement-complete',
    settlementId: settlementId,
    invocationId: invocationId,
    callId: settlement.callId,
    cost: settlement.cost,
    rewardAmount: settlement.rewardAmount,
    status: settlement.status,
  });

  return settlement;
}

function getSettlement(settlementId) {
  return settlementLedger.get(settlementId) || null;
}

// ════════════════════════════════════════════════════════════════════════
//  QUERY FUNCTIONS (read-only)
// ════════════════════════════════════════════════════════════════════════

function queryTool(toolId) {
  const entry = toolMap.get(toolId);
  if (!entry) return { found: false, toolId: toolId };

  return {
    found: true,
    tool: entry,
    contract: buildCallContract(toolId),
  };
}

function queryToolsByCategory(category) {
  const results = [];

  for (const tool of VOIS_SUBSTRATE_TOOLS) {
    if (tool.category === category) results.push({ id: tool.id, name: tool.name, category: tool.category });
  }
  for (const tool of FLEET_TOOL_REGISTRY) {
    if (tool.category === category) results.push({ id: tool.id, name: tool.name, callId: tool.callId, category: tool.category });
  }
  for (const proto of PROTOCOL_CALL_REGISTRY) {
    if (proto.category === category) results.push({ id: proto.id, name: proto.name, callId: proto.callId, category: proto.category });
  }

  return { category: category, count: results.length, tools: results };
}

function queryContract(callId) {
  const contract = buildCallContract(callId);
  if (!contract) return { found: false, callId: callId };
  return { found: true, contract: contract };
}

function querySettlementById(settlementId) {
  const settlement = getSettlement(settlementId);
  if (!settlement) return { found: false, settlementId: settlementId };
  return { found: true, settlement: settlement };
}

function queryCapacity() {
  return {
    registrySize: toolMap.size,
    substrateTtools: VOIS_SUBSTRATE_TOOLS.length,
    fleetTools: FLEET_TOOL_REGISTRY.length,
    protocols: PROTOCOL_CALL_REGISTRY.length,
    totalRegistered: VOIS_SUBSTRATE_TOOLS.length + FLEET_TOOL_REGISTRY.length + PROTOCOL_CALL_REGISTRY.length,
    maxRegistry: MAX_REGISTRY,
    activeInvocations: activeInvocations.size,
    maxInvocations: MAX_INVOCATIONS,
    totalCallers: callerRegistry.size,
    maxCallers: MAX_CALLERS,
    totalSettlements: settlementLedger.size,
    maxSettlements: MAX_SETTLEMENTS,
    auditEntries: auditLog.length,
    maxAuditLog: MAX_AUDIT_LOG,
  };
}

function queryPermissions(callerId, callId) {
  return checkPermission(callerId, callId);
}

function queryPricing(callId) {
  const entry = toolMap.get(callId);
  if (!entry) return { found: false, callId: callId };

  const pricing = PRICING_CLASSES[entry.pricingClass || 'P0'];
  const reward = REWARD_CLASSES[entry.rewardClass || 'R0'];

  return {
    found: true,
    callId: callId,
    name: entry.name,
    pricing: pricing,
    reward: reward,
  };
}

function queryHealth() {
  const activeCount = activeInvocations.size;
  const errorRate = totalInvocations > 0 ? totalErrors / totalInvocations : 0;
  const utilizationRatio = activeCount / MAX_INVOCATIONS;

  let healthStatus = 'healthy';
  if (errorRate > 0.1) healthStatus = 'degraded';
  if (errorRate > 0.3) healthStatus = 'critical';
  if (!running) healthStatus = 'stopped';

  return {
    status: healthStatus,
    running: running,
    uptime: beatCount * HEARTBEAT,
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    totalInvocations: totalInvocations,
    totalSettlements: totalSettlements,
    totalErrors: totalErrors,
    errorRate: errorRate,
    activeInvocations: activeCount,
    utilizationRatio: utilizationRatio,
    callerCount: callerRegistry.size,
    registrySize: VOIS_SUBSTRATE_TOOLS.length + FLEET_TOOL_REGISTRY.length + PROTOCOL_CALL_REGISTRY.length,
    auditEntries: auditLog.length,
  };
}

function queryRegistrySummary() {
  return {
    substrate: {
      count: VOIS_SUBSTRATE_TOOLS.length,
      categories: ['core-pulse', 'intelligence', 'defense', 'infrastructure'],
      tools: VOIS_SUBSTRATE_TOOLS.map(function (t) { return { id: t.id, name: t.name, category: t.category }; }),
    },
    fleet: {
      count: FLEET_TOOL_REGISTRY.length,
      range: 'TOOL-061 to TOOL-260',
      categories: Object.keys(FLEET_TOOL_CATEGORIES),
      byCategoryCount: (function () {
        var counts = {};
        for (var i = 0; i < FLEET_TOOL_REGISTRY.length; i++) {
          var cat = FLEET_TOOL_REGISTRY[i].category;
          counts[cat] = (counts[cat] || 0) + 1;
        }
        return counts;
      })(),
    },
    protocols: {
      count: PROTOCOL_CALL_REGISTRY.length,
      range: 'PROTOCOL-001 to PROTOCOL-055',
      categories: Object.keys(PROTOCOL_CATEGORY_DEFAULTS),
    },
    totalEntries: VOIS_SUBSTRATE_TOOLS.length + FLEET_TOOL_REGISTRY.length + PROTOCOL_CALL_REGISTRY.length,
    mapSize: toolMap.size,
  };
}

function queryCallerProfile(callerId) {
  const caller = getCaller(callerId);
  if (!caller) return { found: false, callerId: callerId };

  return {
    found: true,
    caller: {
      callerId: caller.callerId,
      tier: caller.tier,
      status: caller.status,
      healthScore: caller.healthScore,
      registeredAt: caller.registeredAt,
      lastActive: caller.lastActive,
      usage: caller.usage,
    },
  };
}

// ════════════════════════════════════════════════════════════════════════
//  CALL FUNCTIONS (mutating)
// ════════════════════════════════════════════════════════════════════════

function callInvoke(callId, callerId, params) {
  return invoke(callId, callerId, params);
}

function callBatchInvoke(invocations) {
  const results = [];
  for (var i = 0; i < invocations.length; i++) {
    var inv = invocations[i];
    results.push(invoke(inv.callId, inv.callerId, inv.params));
  }
  return { results: results, count: results.length, errors: results.filter(function (r) { return r.error; }).length };
}

function callRegisterTool(tool) {
  if (!tool || !tool.name) {
    return { error: 'INVALID_TOOL', message: 'Tool must have a name' };
  }

  if (toolMap.has(tool.name)) {
    return { error: 'TOOL_EXISTS', message: 'Tool already registered: ' + tool.name };
  }

  const registered = {
    id: tool.id || 'CUSTOM-' + (toolMap.size + 1),
    callId: tool.callId || 'vois.custom.' + toKebab(tool.name) + '.v1',
    name: tool.name,
    category: tool.category || 'custom',
    pricingClass: tool.pricingClass || 'P2',
    rewardClass: tool.rewardClass || 'R1',
    permissionTierMin: tool.permissionTierMin || 'PARTNER',
    exposureClass: tool.exposureClass || 'partner',
    status: 'registered',
    registeredAt: Date.now(),
  };

  toolMap.set(registered.name, registered);
  toolMap.set(registered.callId, registered);
  if (registered.id) toolMap.set(registered.id, registered);

  logAudit('tool-registered', { name: registered.name, callId: registered.callId });

  return registered;
}

function callUpdatePermissions(callId, permissions) {
  const entry = toolMap.get(callId);
  if (!entry) return { error: 'CALL_NOT_FOUND', callId: callId };

  if (permissions.permissionTierMin) entry.permissionTierMin = permissions.permissionTierMin;
  if (permissions.securityTier) entry.securityTier = permissions.securityTier;
  if (permissions.exposureClass) entry.exposureClass = permissions.exposureClass;
  if (permissions.allowedCallers) entry.allowedCallers = permissions.allowedCallers;

  logAudit('permissions-updated', { callId: callId, permissions: permissions });

  return { callId: callId, updated: true, entry: entry };
}

function callSettleCall(invocationId) {
  return settleInvocation(invocationId);
}

function callRegisterCaller(callerId, tier, config) {
  return registerCaller(callerId, tier, config);
}

function callExportUsage(callerId, format) {
  const caller = getCaller(callerId);
  if (!caller) return { error: 'CALLER_NOT_FOUND', callerId: callerId };

  const settlements = [];
  for (const [, s] of settlementLedger) {
    if (s.callerId === callerId) settlements.push(s);
  }

  const exportData = {
    callerId: callerId,
    tier: caller.tier,
    usage: caller.usage,
    settlements: settlements,
    exportedAt: Date.now(),
    format: format || 'json',
    proofHash: hashEvent('export:' + callerId + ':' + Date.now()),
  };

  logAudit('usage-exported', { callerId: callerId, format: format, settlementCount: settlements.length });

  return exportData;
}

// ════════════════════════════════════════════════════════════════════════
//  MESSAGE HANDLER
// ════════════════════════════════════════════════════════════════════════

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    // ─── Queries (read-only) ────────────────────────────────
    case 'queryTool': {
      const result = queryTool(msg.toolId);
      self.postMessage({ type: 'query-result', query: 'queryTool', ...result });
      break;
    }

    case 'queryToolsByCategory': {
      const result = queryToolsByCategory(msg.category);
      self.postMessage({ type: 'query-result', query: 'queryToolsByCategory', ...result });
      break;
    }

    case 'queryContract': {
      const result = queryContract(msg.callId);
      self.postMessage({ type: 'query-result', query: 'queryContract', ...result });
      break;
    }

    case 'querySettlement': {
      const result = querySettlementById(msg.settlementId);
      self.postMessage({ type: 'query-result', query: 'querySettlement', ...result });
      break;
    }

    case 'queryCapacity': {
      const result = queryCapacity();
      self.postMessage({ type: 'query-result', query: 'queryCapacity', ...result });
      break;
    }

    case 'queryPermissions': {
      const result = queryPermissions(msg.callerId, msg.callId);
      self.postMessage({ type: 'query-result', query: 'queryPermissions', ...result });
      break;
    }

    case 'queryPricing': {
      const result = queryPricing(msg.callId);
      self.postMessage({ type: 'query-result', query: 'queryPricing', ...result });
      break;
    }

    case 'queryHealth': {
      const result = queryHealth();
      self.postMessage({ type: 'query-result', query: 'queryHealth', ...result });
      break;
    }

    case 'queryRegistry': {
      const result = queryRegistrySummary();
      self.postMessage({ type: 'query-result', query: 'queryRegistry', ...result });
      break;
    }

    case 'queryCallerProfile': {
      const result = queryCallerProfile(msg.callerId);
      self.postMessage({ type: 'query-result', query: 'queryCallerProfile', ...result });
      break;
    }

    // ─── Calls (mutating) ───────────────────────────────────
    case 'callInvoke': {
      const result = callInvoke(msg.callId, msg.callerId, msg.params);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callInvoke', error: result.error, reason: result.reason, callId: msg.callId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callInvoke', ...result });
      }
      break;
    }

    case 'callBatchInvoke': {
      const result = callBatchInvoke(msg.invocations || []);
      self.postMessage({ type: 'call-result', call: 'callBatchInvoke', ...result });
      break;
    }

    case 'callRegisterTool': {
      const result = callRegisterTool(msg.tool);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callRegisterTool', error: result.error, message: result.message });
      } else {
        self.postMessage({ type: 'call-result', call: 'callRegisterTool', ...result });
      }
      break;
    }

    case 'callUpdatePermissions': {
      const result = callUpdatePermissions(msg.callId, msg.permissions || {});
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callUpdatePermissions', error: result.error, callId: msg.callId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callUpdatePermissions', ...result });
      }
      break;
    }

    case 'callSettleCall': {
      const result = callSettleCall(msg.invocationId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callSettleCall', error: result.error, invocationId: msg.invocationId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callSettleCall', ...result });
      }
      break;
    }

    case 'callRegisterCaller': {
      const result = callRegisterCaller(msg.callerId, msg.tier, msg.config);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callRegisterCaller', error: result.error, message: result.message });
      } else {
        self.postMessage({ type: 'call-result', call: 'callRegisterCaller', callerId: result.callerId, tier: result.tier, status: result.status });
      }
      break;
    }

    case 'callExportUsage': {
      const result = callExportUsage(msg.callerId, msg.format);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callExportUsage', error: result.error, callerId: msg.callerId });
      } else {
        self.postMessage({ type: 'call-result', call: 'callExportUsage', ...result });
      }
      break;
    }

    // ─── Lifecycle ──────────────────────────────────────────
    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      logAudit('marketplace-stop', { totalInvocations: totalInvocations, totalSettlements: totalSettlements, totalErrors: totalErrors });
      self.postMessage({
        type: 'stopped',
        totalInvocations: totalInvocations,
        totalSettlements: totalSettlements,
        totalErrors: totalErrors,
        totalCallers: callerRegistry.size,
      });
      break;
  }
};

// ════════════════════════════════════════════════════════════════════════
//  HEARTBEAT
// ════════════════════════════════════════════════════════════════════════

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Periodic caller health decay every 13 beats (~11s)
  if (beatCount % 13 === 0) {
    for (const [, caller] of callerRegistry) {
      if (caller.status === 'active') {
        const idleMs = Date.now() - caller.lastActive;
        if (idleMs > 300000) {
          caller.healthScore = Math.max(0, caller.healthScore - 0.01);
        } else {
          caller.healthScore = Math.min(1.0, caller.healthScore + 0.001);
        }
      }
    }
  }

  // Periodic stale invocation cleanup every 34 beats (~30s)
  if (beatCount % 34 === 0) {
    const now = Date.now();
    for (const [invId, inv] of activeInvocations) {
      if (inv.status === 'dispatched' && (now - inv.startedAt) > 60000) {
        failInvocation(invId, 'TIMEOUT');
      }
    }
  }

  // Periodic quota reset every 89 beats (~78s)
  if (beatCount % 89 === 0) {
    for (const [, caller] of callerRegistry) {
      caller.usage.quotaUsed = Math.max(0, Math.floor(caller.usage.quotaUsed * PHI_INV));
    }
  }

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    registrySize: VOIS_SUBSTRATE_TOOLS.length + FLEET_TOOL_REGISTRY.length + PROTOCOL_CALL_REGISTRY.length,
    totalInvocations: totalInvocations,
    activeInvocations: activeInvocations.size,
    totalSettlements: totalSettlements,
    totalCallers: callerRegistry.size,
    totalErrors: totalErrors,
  });
}, HEARTBEAT);
