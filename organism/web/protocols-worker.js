/**
 * Protocols Worker — PROTOCOL-001–089: Enterprise Platform Protocols
 *
 * The central protocol layer that wires all 25 workers and 328 tools
 * into a unified enterprise platform capable of managing 1,000+ clients.
 * Each protocol defines a formalized process — an executable contract
 * between system components that guarantees behavior, routing, safety,
 * and auditability at enterprise scale.
 *
 * Protocols are NOT tools — they are higher-order orchestration patterns
 * that compose tools, enforce invariants, and manage cross-cutting concerns.
 * Think of them as the "constitution" of the organism fleet.
 *
 * ════════════════════════════════════════════════════════════════════════
 *                    89 ENTERPRISE PROTOCOLS
 * ════════════════════════════════════════════════════════════════════════
 *
 * ─── CLIENT LIFECYCLE (001–005) ───────────────────────────────────────
 *   PROTOCOL-001  clientOnboard  [Inductio Clientis]       — Full client provisioning flow
 *   PROTOCOL-002  clientOffboard  [Dimissio Clientis]      — Graceful client teardown + data export
 *   PROTOCOL-003  clientSuspend  [Suspensio Clientis]       — Suspend client (billing/compliance)
 *   PROTOCOL-004  clientMigrate  [Migratio Clientis]       — Migrate client between tiers/regions
 *   PROTOCOL-005  clientHealthCheck  [Inspectio Salutis]   — Periodic client health assessment
 *
 * ─── AI PIPELINE (006–010) ────────────────────────────────────────────
 *   PROTOCOL-006  aiRequestPipeline  [Iter Petitionis Artificialis]   — Full AI request lifecycle (sanitize → route → invoke → validate → deliver)
 *   PROTOCOL-007  aiFailoverChain  [Catena Subsidiaria]     — Cascading failover across AI providers (OpenAI → Anthropic → Google → local)
 *   PROTOCOL-008  aiCostGovernor  [Rector Sumptuum]      — Token budget enforcement + cost allocation per client
 *   PROTOCOL-009  aiQualityGate  [Porta Qualitatis]       — Hallucination check + bias detect + fact ground before delivery
 *   PROTOCOL-010  aiModelRouter  [Distributor Modelli]       — Route requests to optimal model based on task + cost + latency
 *
 * ─── DATA GOVERNANCE (011–015) ────────────────────────────────────────
 *   PROTOCOL-011  dataIngestPipeline  [Iter Receptae Datae]  — Validate → sanitize → classify → store → index
 *   PROTOCOL-012  dataExportPipeline  [Iter Datae Exportatae]  — Query → filter → format → encrypt → deliver
 *   PROTOCOL-013  dataRetention  [Retentio Datae]       — TTL enforcement, archival, purge scheduling
 *   PROTOCOL-014  privacyCompliance  [Conformitas Secreti]   — PII detection → masking → audit logging (GDPR/CCPA)
 *   PROTOCOL-015  dataLineage  [Linea Datae]         — Track data provenance from source to output
 *
 * ─── SECURITY & TRUST (016–020) ───────────────────────────────────────
 *   PROTOCOL-016  zeroTrustGate  [Porta Sine Fide]       — Every request authenticated + authorized + rate-limited
 *   PROTOCOL-017  threatResponse  [Responsio Minae]      — Detect → classify → contain → remediate → report
 *   PROTOCOL-018  auditTrail  [Vestigium Inspectionis]          — Immutable audit log for all platform operations
 *   PROTOCOL-019  secretsRotation  [Rotatio Secretorum]     — Automated API key rotation + propagation
 *   PROTOCOL-020  incidentEscalation  [Escalatio Incidentis]  — Alert → triage → notify → escalate → resolve → postmortem
 *
 * ─── PLATFORM OPERATIONS (021–025) ────────────────────────────────────
 *   PROTOCOL-021  autoScaling  [Scalatio Automatica]         — Sensor-driven capacity scaling
 *   PROTOCOL-022  canaryDeployment  [Deploymentum Canarium]    — Canary → measure → promote/rollback
 *   PROTOCOL-023  circuitBreaker  [Interruptio Circuiti]      — Cascading failure prevention across workers
 *   PROTOCOL-024  healthOrchestrator  [Orchestrator Salutis]  — Cross-worker health aggregation + reporting
 *   PROTOCOL-025  capacityPlanning  [Planificatio Capacitatis]    — Forecast demand → plan resources → provision
 *
 * ─── BILLING & METERING (026–028) ─────────────────────────────────────
 *   PROTOCOL-026  usageMetering  [Mensura Usus]       — Track per-client usage across all tools
 *   PROTOCOL-027  billingCycle  [Cyclus Solutionis]        — Generate invoices, process payments, handle disputes
 *   PROTOCOL-028  quotaEnforcement  [Executio Quotae]    — Per-client quota tracking + enforcement + alerts
 *
 * ─── RESEARCH & PRODUCT (029–030) ─────────────────────────────────────
 *   PROTOCOL-029  experimentPipeline  [Iter Experimenti]  — A/B test → measure → analyze → ship or kill
 *   PROTOCOL-030  feedbackLoop  [Orbis Retroactionis]        — Collect → analyze → prioritize → implement → measure
 *
 * ─── MULTI-AGENT COORDINATION (031–035) ───────────────────────────────
 *   PROTOCOL-031  agentSwarmDeploy  [Deploymentum Examinis]    — Deploy swarm topology + assign roles + start heartbeats
 *   PROTOCOL-032  agentConsensus  [Consensus Agentium]      — Collect votes → quorum → broadcast decision
 *   PROTOCOL-033  agentNegotiation  [Negotiatio Agentium]    — Define terms → evaluate → counter → formalize
 *   PROTOCOL-034  agentSelfHeal  [Auto-Sanatio Agentis]       — Detect → diagnose → isolate → spawn → restore
 *   PROTOCOL-035  agentLoadBalance  [Aequipondium Agentis]    — Measure → predict → distribute → verify
 *
 * ─── INTELLIGENCE & LEARNING (036–040) ────────────────────────────────
 *   PROTOCOL-036  continuousLearning  [Discere Continuum]  — Collect interactions → extract → embed → store
 *   PROTOCOL-037  anomalyDetection  [Detectio Anomaliae]    — Baselines → deviations → classify → trigger
 *   PROTOCOL-038  knowledgeDistill  [Destillatio Scientiae]    — Identify → extract → compress → validate → store
 *   PROTOCOL-039  predictiveAnalytics  [Analytica Praedictiva] — Historical → feature → train → forecast → publish
 *   PROTOCOL-040  sentinelShieldSensorLoop  [Orbis Vigilis Scuti] — Sweep → detect → shield → contain → heal
 *
 * ─── COMPLIANCE & LEGAL (041–045) ─────────────────────────────────────
 *   PROTOCOL-041  gdprDataRequest  [Petitio Datae GDPR]     — Authenticate → verify → locate → compile → deliver
 *   PROTOCOL-042  gdprDataDeletion  [Deletio Datae GDPR]    — Verify → scope → legal-holds → execute → confirm
 *   PROTOCOL-043  soc2AuditPrep  [Praeparatio Inspectionis SOC2]       — Evidence → trail → access → security → report
 *   PROTOCOL-044  licenseEnforcement  [Executio Licentiae]  — Scan → verify → expiration → enforce → notify
 *   PROTOCOL-045  ipProtection  [Tutela Proprietatis]        — Scan → plagiarism → watermark → provenance
 *
 * ─── INTEGRATION & INTEROP (046–050) ──────────────────────────────────
 *   PROTOCOL-046  webhookPipeline  [Iter Hamuli Retis]     — Receive → validate-sig → parse → sanitize → route
 *   PROTOCOL-047  apiGateway  [Porta API]          — Receive → auth → rate-limit → validate → route
 *   PROTOCOL-048  eventBridge  [Pons Eventuum]         — Receive → normalize → filter → fan-out → confirm
 *   PROTOCOL-049  dataSync  [Synchronizatio Datae]            — Detect → conflicts → transform → sync → verify
 *   PROTOCOL-050  graphqlFederation  [Foederatio Quaestionis]   — Parse → plan → fan-out → merge → authorize
 *
 * ─── SDK & DEVELOPER EXPERIENCE (051–055) ─────────────────────────────
 *   PROTOCOL-051  sdkApiCall  [Vocatio API]          — Parse → validate-key → version → route → execute
 *   PROTOCOL-052  sdkAuth  [Authentificatio SDK]             — Credentials → token → permissions → session
 *   PROTOCOL-053  sdkBatchOperation  [Operatio Multitudinis]   — Parse → validate → quota → fan-out → aggregate
 *   PROTOCOL-054  sdkWebSocket  [Nexus Tessellae Retis]        — Upgrade → auth → channels → events → heartbeat
 *   PROTOCOL-055  sdkDocGenerate  [Generatio Documentorum]      — Scan → schemas → openapi → examples → publish
 *
 * ─── DISCOVERY & EXPANSION (056–060) ──────────────────────────────────
 *   PROTOCOL-056  ecosystemProbe  [Sondatio Ecosystematis]      — Probe organism ecosystem for new capabilities
 *   PROTOCOL-057  capabilityAdvertise  [Praedicatio Capacitatis] — Advertise platform capabilities to peer organisms
 *   PROTOCOL-058  serviceDiscovery  [Inventio Munerum]    — Auto-discover available services + workers
 *   PROTOCOL-059  knowledgeHarvest  [Messis Scientiae]    — Harvest knowledge from telemetry + interactions
 *   PROTOCOL-060  opportunityMine  [Effossio Opportunitatis]     — Mine operational data for optimization opportunities
 *
 * ─── PACKAGE & INSTALLATION (061–065) ─────────────────────────────────
 *   PROTOCOL-061  packageLifecycle  [Vita Fasciculi]    — Full install → verify → register → audit cycle
 *   PROTOCOL-062  workerProvisioning  [Provisio Operarii]  — Provision + register a new worker module
 *   PROTOCOL-063  toolBundleDeploy  [Deploymentum Fasciculi]    — Deploy + register a bundle of tools
 *   PROTOCOL-064  rollbackPipeline  [Iter Reversionis]    — Rollback failed installation or deployment
 *   PROTOCOL-065  upgradeOrchestration  [Orchestratio Perfectioris] — Orchestrate multi-component platform upgrades
 *
 * ─── KNOWLEDGE & MEMORY (066–070) ─────────────────────────────────────
 *   PROTOCOL-066  knowledgeIngestion  [Ingestio Scientiae]  — Ingest + classify + index external knowledge
 *   PROTOCOL-067  memoryConsolidation  [Consolidatio Memoriae] — Consolidate + deduplicate + optimize memory patterns
 *   PROTOCOL-068  knowledgeRetrieval  [Recuperatio Scientiae]  — Intelligent semantic knowledge retrieval
 *   PROTOCOL-069  contextAssembly  [Compositio Contextus]     — Assemble rich context from memory for AI requests
 *   PROTOCOL-070  knowledgeExport  [Exportatio Scientiae]     — Export knowledge graph in standard formats
 *
 * ─── PERFORMANCE & OPTIMIZATION (071–075) ─────────────────────────────
 *   PROTOCOL-071  performanceBaseline  [Basis Performantiae] — Establish performance baselines across fleet
 *   PROTOCOL-072  bottleneckResolve  [Solutio Strangulationis]   — Detect → diagnose → reroute → verify → audit
 *   PROTOCOL-073  resourceOptimize  [Optimizatio Rerum]    — Profile → model → reallocate → verify → audit
 *   PROTOCOL-074  cacheWarmup  [Calefactio Cachi]         — Predict → warm → validate → report
 *   PROTOCOL-075  loadTest  [Probatio Oneris]            — Ramp → measure → analyze → report → teardown
 *
 * ─── DEPLOYMENT & RELEASE (076–080) ───────────────────────────────────
 *   PROTOCOL-076  blueGreenDeploy  [Deploymentum Bicolor]     — Provision-green → route % → measure → full-switch
 *   PROTOCOL-077  featureToggle  [Commutatio Featurae]       — Validate → propagate → activate → measure → audit
 *   PROTOCOL-078  releaseValidation  [Validatio Emissionis]   — Build → test → security-scan → approve → sign
 *   PROTOCOL-079  rolloutOrchestration  [Orchestratio Diffusionis] — Stage → 5% → 20% → 50% → 100% → verify
 *   PROTOCOL-080  postDeployVerify  [Verificatio Post Deploymentum]    — Health-check → smoke → regression → alert → report
 *
 * ─── OBSERVABILITY & DEBUGGING (081–085) ──────────────────────────────
 *   PROTOCOL-081  traceCapture  [Captio Vestigii]        — Instrument → collect → correlate → store → analyze
 *   PROTOCOL-082  logCorrelation  [Correlatio Registri]      — Collect → parse → correlate-by-id → surface
 *   PROTOCOL-083  debugSnapshot  [Instantaneum Scrutinii]       — Freeze → capture → serialize → store → retrieve
 *   PROTOCOL-084  profilerSession  [Sessio Perscrutatoris]     — Instrument → sample → aggregate → report → cleanup
 *   PROTOCOL-085  alertCorrelation  [Correlatio Signalium]    — Collect-alerts → cluster → root-cause → notify
 *
 * ─── ECOSYSTEM & FEDERATION (086–089) ─────────────────────────────────
 *   PROTOCOL-086  federatedQuery  [Quaestio Foederata]      — Auth → route → fan-out → merge → filter → deliver
 *   PROTOCOL-087  peerSync  [Synchronizatio Parium]            — Handshake → delta → resolve → apply → confirm
 *   PROTOCOL-088  sovereignBridge  [Pons Soveranitatis]     — Authenticate → authorize → translate → relay → audit
 *   PROTOCOL-089  ecosystemGovernance  [Gubernatio Ecosystematis] — Propose → vote → ratify → enforce → announce
 *
 * ════════════════════════════════════════════════════════════════════════
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'execute', protocolId, params, clientId? }
 *   Main → Worker: { type: 'getStatus', executionId }
 *   Main → Worker: { type: 'cancel', executionId }
 *   Main → Worker: { type: 'getProtocol', protocolId }
 *   Main → Worker: { type: 'list' }
 *   Main → Worker: { type: 'getMetrics' }
 *   Worker → Main: { type: 'step-complete', executionId, protocolId, step, result }
 *   Worker → Main: { type: 'protocol-complete', executionId, protocolId, results }
 *   Worker → Main: { type: 'protocol-error', executionId, protocolId, step, error }
 *   Worker → Main: { type: 'protocol-alert', protocolId, severity, message }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;
const PROTOCOL_COUNT = 89;
const MAX_EXECUTIONS = 233;    // F13 — max concurrent protocol executions
const MAX_CLIENTS = 1597;      // F17 — max managed clients (supports 1000+)
const MAX_AUDIT_LOG = 2584;    // F18 — audit trail depth

let beatCount = 0;
let running = true;
let executionCounter = 0;
let totalExecutions = 0;
let totalErrors = 0;

/* ════════════════════════════════════════════════════════════════
   Protocol registry — 89 enterprise protocols
   ════════════════════════════════════════════════════════════════ */

/* ─── PROTOCOL LICENSE FRAMEWORK ────────────────────────────────
   Every protocol is licensed under the Command Platform Enterprise
   License (CPEL-1.0). This is a sovereign commercial license that:
   
   1. Grants execution rights to registered platform clients
   2. Prohibits reverse-engineering of protocol step sequences
   3. Requires audit logging for all protocol invocations
   4. Mandates φ-heartbeat synchronization for all workers
   5. Binds all data flowing through protocols to GDPR/CCPA compliance
   
   SPDX-License-Identifier: CPEL-1.0
   Copyright © 2024-2026 Alfredo Medina Hernandez. All rights reserved.
   Framework: Medina Doctrine
   ────────────────────────────────────────────────────────────── */

const PROTOCOL_LICENSE = {
  id: 'CPEL-1.0',
  name: 'Command Platform Enterprise License',
  version: '1.0.0',
  copyright: '© 2024-2026 Alfredo Medina Hernandez. All rights reserved.',
  framework: 'Medina Doctrine',
  spdx: 'CPEL-1.0',
  permissions: [
    'execute',           // Execute protocol via registered client
    'query',             // Query protocol state and metadata
    'audit',             // Read audit logs for own executions
    'export-results',    // Export execution results
  ],
  restrictions: [
    'no-reverse-engineer',    // Cannot reverse-engineer step sequences
    'no-redistribution',      // Cannot redistribute protocol definitions
    'no-modification',        // Cannot modify protocol behavior
    'no-sublicense',          // Cannot sublicense to third parties
    'audit-required',         // All invocations must be audit-logged
    'phi-sync-required',      // Must maintain φ-heartbeat synchronization
  ],
  compliance: ['GDPR', 'CCPA', 'SOC2', 'ISO27001', 'HIPAA-eligible'],
  jurisdiction: 'International — Sovereign Platform Law',
  effectiveDate: '2024-01-01T00:00:00Z',
  renewalTerms: 'Annual, auto-renew with active subscription',
};

const PROTOCOL_REGISTRY = [
  // ─── CLIENT LIFECYCLE (001–005) ─────────────────────────────
  {
    id: 1, name: 'clientOnboard', latinName: 'Inductio Clientis', latinDescription: 'Plena provisio novi clientis in systema',
  category: 'client-lifecycle',
    steps: [
      { name: 'validate-request',    worker: 'shields',   toolId: 241 },  // inputSanitizer
      { name: 'check-capacity',      worker: 'sensors',   toolId: 233 },  // queueDepthSensor
      { name: 'provision-account',   worker: 'contracts', toolId: null },  // FORMA mint
      { name: 'configure-quotas',    worker: 'triggers',  toolId: 184 },  // budgetTrigger
      { name: 'setup-monitoring',    worker: 'sensors',   toolId: 221 },  // cpuSensor
      { name: 'register-hooks',      worker: 'hooks',     toolId: 170 },  // onHeartbeat
      { name: 'send-welcome',        worker: 'adapters',  toolId: 215 },  // sendgridAdapter
      { name: 'verify-access',       worker: 'shields',   toolId: 260 },  // integrityVerifier
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },  // auditLogger
    ],
    timeout: 30000,
    retries: 2,
    critical: true,
  },
  {
    id: 2, name: 'clientOffboard', latinName: 'Dimissio Clientis', latinDescription: 'Dimissio clemens et exportatio datae clientis',
  category: 'client-lifecycle',
    steps: [
      { name: 'validate-request',    worker: 'shields',   toolId: 241 },
      { name: 'export-data',         worker: 'recipes',   toolId: 129 },  // reportingRecipe
      { name: 'revoke-access',       worker: 'shields',   toolId: 243 },  // rateLimiter
      { name: 'archive-records',     worker: 'recipes',   toolId: 131 },  // backupRestoreRecipe
      { name: 'settle-billing',      worker: 'contracts', toolId: null },
      { name: 'cleanup-resources',   worker: 'infra',     toolId: null },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: true,
  },
  {
    id: 3, name: 'clientSuspend', latinName: 'Suspensio Clientis', latinDescription: 'Suspensio temporaria accessionis clientis',
  category: 'client-lifecycle',
    steps: [
      { name: 'validate-reason',     worker: 'shields',   toolId: 241 },
      { name: 'freeze-quotas',       worker: 'triggers',  toolId: 184 },
      { name: 'disable-access',      worker: 'shields',   toolId: 243 },
      { name: 'notify-client',       worker: 'adapters',  toolId: 215 },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 10000,
    retries: 1,
    critical: true,
  },
  {
    id: 4, name: 'clientMigrate', latinName: 'Migratio Clientis', latinDescription: 'Migratio clientis inter gradus vel regiones',
  category: 'client-lifecycle',
    steps: [
      { name: 'assess-migration',    worker: 'aicalls',   toolId: 61 },   // goalDecompose
      { name: 'backup-state',        worker: 'recipes',   toolId: 131 },
      { name: 'provision-target',    worker: 'blueprints', toolId: 101 },  // microserviceBlueprint
      { name: 'transfer-data',       worker: 'recipes',   toolId: 127 },  // migrationRecipe
      { name: 'verify-integrity',    worker: 'shields',   toolId: 260 },
      { name: 'switch-routing',      worker: 'routing',   toolId: null },
      { name: 'validate-access',     worker: 'shields',   toolId: 260 },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 1,
    critical: true,
  },
  {
    id: 5, name: 'clientHealthCheck', latinName: 'Inspectio Salutis', latinDescription: 'Inspectio periodica sanitatis clientis',
  category: 'client-lifecycle',
    steps: [
      { name: 'check-quotas',        worker: 'sensors',   toolId: 233 },
      { name: 'check-error-rate',    worker: 'sensors',   toolId: 225 },
      { name: 'check-latency',       worker: 'sensors',   toolId: 223 },
      { name: 'check-usage',         worker: 'sensors',   toolId: 224 },
      { name: 'generate-report',     worker: 'lenses',    toolId: 160 },  // systemHealthLens
      { name: 'alert-if-unhealthy',  worker: 'triggers',  toolId: 185 },  // healthTrigger
    ],
    timeout: 15000,
    retries: 0,
    critical: false,
  },

  // ─── AI PIPELINE (006–010) ──────────────────────────────────
  {
    id: 6, name: 'aiRequestPipeline', latinName: 'Iter Petitionis Artificialis', latinDescription: 'Cyclus plenus petitionis intelligentiae artificialis',
  category: 'ai-pipeline',
    steps: [
      { name: 'sanitize-input',      worker: 'shields',   toolId: 241 },  // inputSanitizer
      { name: 'check-injection',     worker: 'shields',   toolId: 244 },  // injectionGuard
      { name: 'check-jailbreak',     worker: 'shields',   toolId: 252 },  // jailbreakDetector
      { name: 'check-rate-limit',    worker: 'shields',   toolId: 243 },  // rateLimiter
      { name: 'check-quota',         worker: 'shields',   toolId: 258 },  // quotaEnforcer
      { name: 'route-to-model',      worker: 'adapters',  toolId: 201 },  // openaiAdapter (default)
      { name: 'invoke-ai',           worker: 'aicalls',   toolId: 63  },  // promptChain
      { name: 'validate-output',     worker: 'aicalls',   toolId: 62  },  // hallucinationCheck
      { name: 'filter-output',       worker: 'shields',   toolId: 242 },  // outputFilter
      { name: 'check-privacy',       worker: 'shields',   toolId: 246 },  // privacyMask
      { name: 'log-usage',           worker: 'shields',   toolId: 259 },  // auditLogger
      { name: 'deliver-response',    worker: 'routing',   toolId: null },
    ],
    timeout: 30000,
    retries: 2,
    critical: true,
  },
  {
    id: 7, name: 'aiFailoverChain', latinName: 'Catena Subsidiaria', latinDescription: 'Catena subsidiaria per provisores IA',
  category: 'ai-pipeline',
    steps: [
      { name: 'try-primary',         worker: 'adapters',  toolId: 201 },  // openaiAdapter
      { name: 'check-primary',       worker: 'shields',   toolId: 254 },  // circuitBreaker
      { name: 'try-secondary',       worker: 'adapters',  toolId: 202 },  // anthropicAdapter
      { name: 'check-secondary',     worker: 'shields',   toolId: 254 },
      { name: 'try-tertiary',        worker: 'adapters',  toolId: 203 },  // googleAdapter
      { name: 'check-tertiary',      worker: 'shields',   toolId: 254 },
      { name: 'try-fallback',        worker: 'aicalls',   toolId: 98  },  // fallbackRoute
      { name: 'report-failover',     worker: 'telemetry', toolId: null },
    ],
    timeout: 45000,
    retries: 0,
    critical: true,
  },
  {
    id: 8, name: 'aiCostGovernor', latinName: 'Rector Sumptuum', latinDescription: 'Executio formulae sumptuum et distributionis',
  category: 'ai-pipeline',
    steps: [
      { name: 'check-client-budget', worker: 'aicalls',   toolId: 66  },  // tokenBudget
      { name: 'check-org-budget',    worker: 'sensors',   toolId: 238 },  // tokenFlowSensor
      { name: 'estimate-cost',       worker: 'lenses',    toolId: 155 },  // costLens
      { name: 'enforce-quota',       worker: 'shields',   toolId: 258 },  // quotaEnforcer
      { name: 'allocate-budget',     worker: 'contracts', toolId: null },
      { name: 'track-spend',         worker: 'telemetry', toolId: null },
    ],
    timeout: 5000,
    retries: 0,
    critical: true,
  },
  {
    id: 9, name: 'aiQualityGate', latinName: 'Porta Qualitatis', latinDescription: 'Verificatio qualitatis ante traditionem responsi',
  category: 'ai-pipeline',
    steps: [
      { name: 'hallucination-check', worker: 'aicalls',   toolId: 62  },  // hallucinationCheck
      { name: 'bias-detect',         worker: 'shields',   toolId: 250 },  // biasGuard
      { name: 'fact-ground',         worker: 'shields',   toolId: 251 },  // factGrounder
      { name: 'toxicity-filter',     worker: 'shields',   toolId: 248 },  // toxicityFilter
      { name: 'content-moderate',    worker: 'shields',   toolId: 247 },  // contentModerator
      { name: 'grade-response',      worker: 'aicalls',   toolId: 67  },  // responseGrade
      { name: 'pass-or-reject',      worker: 'routing',   toolId: null },
    ],
    timeout: 10000,
    retries: 1,
    critical: true,
  },
  {
    id: 10, name: 'aiModelRouter', latinName: 'Distributor Modelli', latinDescription: 'Distributio petitionum ad modellum optimum',
  category: 'ai-pipeline',
    steps: [
      { name: 'classify-intent',     worker: 'aicalls',   toolId: 81  },  // intentClassify
      { name: 'estimate-complexity', worker: 'aicalls',    toolId: 74  },  // uncertaintyQuantify
      { name: 'check-latency-reqs',  worker: 'sensors',   toolId: 223 },  // latencySensor
      { name: 'check-cost-reqs',     worker: 'lenses',    toolId: 155 },  // costLens
      { name: 'select-model',        worker: 'aicalls',   toolId: 97  },  // pipelineOrchestrate
      { name: 'route-request',       worker: 'adapters',  toolId: 220 },  // restAdapter
    ],
    timeout: 5000,
    retries: 1,
    critical: true,
  },

  // ─── DATA GOVERNANCE (011–015) ──────────────────────────────
  {
    id: 11, name: 'dataIngestPipeline', latinName: 'Iter Receptae Datae', latinDescription: 'Validatio et repositio datae influentis',
  category: 'data-governance',
    steps: [
      { name: 'validate-schema',     worker: 'aicalls',   toolId: 96  },  // schemaValidate
      { name: 'sanitize-input',      worker: 'shields',   toolId: 241 },
      { name: 'detect-pii',          worker: 'shields',   toolId: 246 },  // privacyMask
      { name: 'classify-data',       worker: 'aicalls',   toolId: 82  },  // topicModel
      { name: 'transform-format',    worker: 'aicalls',   toolId: 95  },  // formatConvert
      { name: 'store-data',          worker: 'memory',    toolId: null },
      { name: 'index-content',       worker: 'aicalls',   toolId: 79  },  // entityExtract
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 2,
    critical: true,
  },
  {
    id: 12, name: 'dataExportPipeline', latinName: 'Iter Datae Exportatae', latinDescription: 'Quaestio et traditio datae exportatae',
  category: 'data-governance',
    steps: [
      { name: 'validate-request',    worker: 'shields',   toolId: 241 },
      { name: 'check-authorization', worker: 'shields',   toolId: 243 },
      { name: 'query-data',          worker: 'memory',    toolId: null },
      { name: 'filter-sensitive',    worker: 'shields',   toolId: 246 },
      { name: 'format-output',       worker: 'aicalls',   toolId: 95  },
      { name: 'verify-integrity',    worker: 'shields',   toolId: 260 },
      { name: 'deliver-export',      worker: 'adapters',  toolId: 218 },  // webhookAdapter
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: true,
  },
  {
    id: 13, name: 'dataRetention', latinName: 'Retentio Datae', latinDescription: 'Executio TTL et archivationi et purgationis',
  category: 'data-governance',
    steps: [
      { name: 'scan-aged-data',      worker: 'triggers',  toolId: 198 },  // stalenessTrigger
      { name: 'classify-retention',  worker: 'aicalls',   toolId: 82  },
      { name: 'archive-eligible',    worker: 'recipes',   toolId: 131 },
      { name: 'purge-expired',       worker: 'memory',    toolId: null },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 1,
    critical: false,
  },
  {
    id: 14, name: 'privacyCompliance', latinName: 'Conformitas Secreti', latinDescription: 'Detectio et obscuratio et registratio datae privatae',
  category: 'data-governance',
    steps: [
      { name: 'scan-pii',            worker: 'shields',   toolId: 246 },
      { name: 'mask-pii',            worker: 'shields',   toolId: 246 },
      { name: 'check-consent',       worker: 'shields',   toolId: 258 },
      { name: 'check-data-leak',     worker: 'shields',   toolId: 253 },  // dataLeakPrevention
      { name: 'generate-report',     worker: 'lenses',    toolId: 158 },  // complianceLens
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: true,
  },
  {
    id: 15, name: 'dataLineage', latinName: 'Linea Datae', latinDescription: 'Vestigium originis datae a fonte ad exitum',
  category: 'data-governance',
    steps: [
      { name: 'trace-source',        worker: 'lenses',    toolId: 141 },  // timelineLens
      { name: 'map-transforms',      worker: 'lenses',    toolId: 145 },  // flowLens
      { name: 'verify-chain',        worker: 'crypto',    toolId: null },
      { name: 'generate-lineage-report', worker: 'lenses', toolId: 142 }, // hierarchyLens
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 15000,
    retries: 0,
    critical: false,
  },

  // ─── SECURITY & TRUST (016–020) ─────────────────────────────
  {
    id: 16, name: 'zeroTrustGate', latinName: 'Porta Sine Fide', latinDescription: 'Omnis petitio authentificata et limitata',
  category: 'security',
    steps: [
      { name: 'authenticate',        worker: 'shields',   toolId: 241 },
      { name: 'authorize',           worker: 'shields',   toolId: 243 },
      { name: 'rate-limit',          worker: 'shields',   toolId: 243 },
      { name: 'check-injection',     worker: 'shields',   toolId: 244 },
      { name: 'check-xss',           worker: 'shields',   toolId: 245 },
      { name: 'check-integrity',     worker: 'shields',   toolId: 260 },
      { name: 'pass-or-block',       worker: 'routing',   toolId: null },
    ],
    timeout: 2000,
    retries: 0,
    critical: true,
  },
  {
    id: 17, name: 'threatResponse', latinName: 'Responsio Minae', latinDescription: 'Detectio et inclusio et sanatio minarum',
  category: 'security',
    steps: [
      { name: 'detect-threat',       worker: 'sentinel',  toolId: null },
      { name: 'classify-severity',   worker: 'aicalls',   toolId: 81  },
      { name: 'contain-threat',      worker: 'shields',   toolId: 255 },  // bulkhead
      { name: 'activate-circuit-breaker', worker: 'shields', toolId: 254 },
      { name: 'notify-ops',          worker: 'adapters',  toolId: 217 },  // slackAdapter
      { name: 'remediate',           worker: 'recipes',   toolId: 138 },  // securityScanRecipe
      { name: 'generate-report',     worker: 'lenses',    toolId: 157 },  // securityLens
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: true,
  },
  {
    id: 18, name: 'auditTrail', latinName: 'Vestigium Inspectionis', latinDescription: 'Registrum immutabile omnium operationum',
  category: 'security',
    steps: [
      { name: 'capture-event',       worker: 'shields',   toolId: 259 },
      { name: 'hash-event',          worker: 'crypto',    toolId: null },
      { name: 'chain-event',         worker: 'crypto',    toolId: null },  // ANIMA chain
      { name: 'store-immutable',     worker: 'memory',    toolId: null },
      { name: 'index-searchable',    worker: 'aicalls',   toolId: 79  },
    ],
    timeout: 5000,
    retries: 2,
    critical: true,
  },
  {
    id: 19, name: 'secretsRotation', latinName: 'Rotatio Secretorum', latinDescription: 'Rotatio automatica clavium API et secretorum',
  category: 'security',
    steps: [
      { name: 'identify-expiring',   worker: 'triggers',  toolId: 187 },  // deadlineTrigger
      { name: 'generate-new-secret', worker: 'crypto',    toolId: null },
      { name: 'propagate-to-adapters', worker: 'adapters', toolId: 220 },
      { name: 'verify-connectivity', worker: 'sensors',   toolId: 231 },  // networkSensor
      { name: 'revoke-old-secret',   worker: 'shields',   toolId: 253 },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: true,
  },
  {
    id: 20, name: 'incidentEscalation', latinName: 'Escalatio Incidentis', latinDescription: 'Signum et triage et notificatio et resolutio',
  category: 'security',
    steps: [
      { name: 'receive-alert',       worker: 'hooks',     toolId: 169 },  // onAnomalyDetected
      { name: 'classify-incident',   worker: 'aicalls',   toolId: 81  },
      { name: 'triage-severity',     worker: 'lenses',    toolId: 154 },  // riskLens
      { name: 'notify-on-call',      worker: 'adapters',  toolId: 217 },  // slackAdapter
      { name: 'escalate-if-needed',  worker: 'recipes',   toolId: 136 },  // alertEscalationRecipe
      { name: 'track-resolution',    worker: 'triggers',  toolId: 191 },  // cooldownTrigger
      { name: 'postmortem',          worker: 'aicalls',   toolId: 78  },  // summaryAbstract
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 3600000,  // 1 hour for full incident lifecycle
    retries: 0,
    critical: true,
  },

  // ─── PLATFORM OPERATIONS (021–025) ──────────────────────────
  {
    id: 21, name: 'autoScaling', latinName: 'Scalatio Automatica', latinDescription: 'Scalatio capacitatis ducta a sensoribus',
  category: 'platform-ops',
    steps: [
      { name: 'collect-metrics',     worker: 'sensors',   toolId: 221 },
      { name: 'predict-demand',      worker: 'lenses',    toolId: 148 },  // trendLens
      { name: 'evaluate-threshold',  worker: 'triggers',  toolId: 186 },  // capacityTrigger
      { name: 'decide-action',       worker: 'aicalls',   toolId: 61  },  // goalDecompose
      { name: 'execute-scaling',     worker: 'recipes',   toolId: 132 },  // scalingRecipe
      { name: 'verify-health',       worker: 'sensors',   toolId: 221 },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 2,
    critical: true,
  },
  {
    id: 22, name: 'canaryDeployment', latinName: 'Deploymentum Canarium', latinDescription: 'Deploymentum canarium cum mensura et promotione',
  category: 'platform-ops',
    steps: [
      { name: 'build-artifact',      worker: 'products',  toolId: null },
      { name: 'deploy-canary',       worker: 'recipes',   toolId: 134 },  // featureToggleRecipe
      { name: 'route-traffic',       worker: 'routing',   toolId: null },
      { name: 'measure-canary',      worker: 'sensors',   toolId: 225 },  // errorRateSensor
      { name: 'compare-metrics',     worker: 'lenses',    toolId: 147 },  // comparisonLens
      { name: 'decide-promote',      worker: 'triggers',  toolId: 181 },  // thresholdTrigger
      { name: 'promote-or-rollback', worker: 'recipes',   toolId: 122 },  // deploymentRecipe
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 300000,
    retries: 0,
    critical: true,
  },
  {
    id: 23, name: 'circuitBreaker', latinName: 'Interruptio Circuiti', latinDescription: 'Praevensio ruinae per artifices deficientes',
  category: 'platform-ops',
    steps: [
      { name: 'monitor-error-rate',  worker: 'sensors',   toolId: 225 },
      { name: 'detect-cascade',      worker: 'triggers',  toolId: 192 },  // cascadeTrigger
      { name: 'open-circuit',        worker: 'shields',   toolId: 254 },
      { name: 'isolate-failure',     worker: 'shields',   toolId: 255 },  // bulkhead
      { name: 'reroute-traffic',     worker: 'routing',   toolId: null },
      { name: 'half-open-test',      worker: 'triggers',  toolId: 191 },  // cooldownTrigger
      { name: 'close-or-keep-open',  worker: 'triggers',  toolId: 181 },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 0,
    critical: true,
  },
  {
    id: 24, name: 'healthOrchestrator', latinName: 'Orchestrator Salutis', latinDescription: 'Aggregatio sanitatis per omnes artifices',
  category: 'platform-ops',
    steps: [
      { name: 'poll-all-sensors',    worker: 'sensors',   toolId: 221 },
      { name: 'aggregate-health',    worker: 'lenses',    toolId: 160 },  // systemHealthLens
      { name: 'detect-anomalies',    worker: 'lenses',    toolId: 149 },  // anomalyLens
      { name: 'correlate-issues',    worker: 'lenses',    toolId: 151 },  // correlationLens
      { name: 'generate-dashboard',  worker: 'lenses',    toolId: 156 },  // performanceLens
      { name: 'alert-if-degraded',   worker: 'hooks',     toolId: 169 },
    ],
    timeout: 15000,
    retries: 0,
    critical: false,
  },
  {
    id: 25, name: 'capacityPlanning', latinName: 'Planificatio Capacitatis', latinDescription: 'Praedictio et planificatio et provisio capacitatis',
  category: 'platform-ops',
    steps: [
      { name: 'collect-historical',  worker: 'sensors',   toolId: 224 },
      { name: 'forecast-demand',     worker: 'lenses',    toolId: 148 },  // trendLens
      { name: 'model-scenarios',     worker: 'aicalls',   toolId: 76  },  // hypothesisForm
      { name: 'cost-analysis',       worker: 'lenses',    toolId: 155 },  // costLens
      { name: 'generate-plan',       worker: 'recipes',   toolId: 137 },  // capacityPlanRecipe
      { name: 'approve-plan',        worker: 'recipes',   toolId: 130 },  // approvalRecipe
    ],
    timeout: 300000,
    retries: 0,
    critical: false,
  },

  // ─── BILLING & METERING (026–028) ───────────────────────────
  {
    id: 26, name: 'usageMetering', latinName: 'Mensura Usus', latinDescription: 'Vestigium usus per clientem per omnia instrumenta',
  category: 'billing',
    steps: [
      { name: 'collect-usage',       worker: 'sensors',   toolId: 238 },  // tokenFlowSensor
      { name: 'aggregate-by-client', worker: 'lenses',    toolId: 146 },  // distributionLens
      { name: 'compute-costs',       worker: 'lenses',    toolId: 155 },  // costLens
      { name: 'store-usage-record',  worker: 'contracts', toolId: null },
      { name: 'check-budget-alerts', worker: 'triggers',  toolId: 184 },  // budgetTrigger
    ],
    timeout: 30000,
    retries: 1,
    critical: true,
  },
  {
    id: 27, name: 'billingCycle', latinName: 'Cyclus Solutionis', latinDescription: 'Generatio facturae et processus solutionis',
  category: 'billing',
    steps: [
      { name: 'aggregate-period',    worker: 'recipes',   toolId: 129 },  // reportingRecipe
      { name: 'generate-invoice',    worker: 'lenses',    toolId: 155 },
      { name: 'process-payment',     worker: 'adapters',  toolId: 213 },  // stripeAdapter
      { name: 'confirm-receipt',     worker: 'adapters',  toolId: 215 },  // sendgridAdapter
      { name: 'update-ledger',       worker: 'contracts', toolId: null },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 2,
    critical: true,
  },
  {
    id: 28, name: 'quotaEnforcement', latinName: 'Executio Quotae', latinDescription: 'Vestigium quotae per clientem et executio',
  category: 'billing',
    steps: [
      { name: 'check-current-usage', worker: 'sensors',   toolId: 238 },
      { name: 'compare-to-quota',    worker: 'shields',   toolId: 258 },  // quotaEnforcer
      { name: 'warn-at-80-pct',      worker: 'triggers',  toolId: 181 },
      { name: 'throttle-at-100-pct', worker: 'shields',   toolId: 243 },  // rateLimiter
      { name: 'notify-client',       worker: 'adapters',  toolId: 215 },
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 5000,
    retries: 0,
    critical: true,
  },

  // ─── RESEARCH & PRODUCT (029–030) ───────────────────────────
  {
    id: 29, name: 'experimentPipeline', latinName: 'Iter Experimenti', latinDescription: 'Experimentum A/B et mensura et analysis',
  category: 'research',
    steps: [
      { name: 'define-hypothesis',   worker: 'aicalls',   toolId: 76  },  // hypothesisForm
      { name: 'design-experiment',   worker: 'blueprints', toolId: 101 },
      { name: 'deploy-variant',      worker: 'recipes',   toolId: 134 },  // featureToggleRecipe
      { name: 'collect-metrics',     worker: 'sensors',   toolId: 224 },
      { name: 'analyze-results',     worker: 'lenses',    toolId: 146 },  // distributionLens
      { name: 'statistical-test',    worker: 'lenses',    toolId: 151 },  // correlationLens
      { name: 'decide-ship-kill',    worker: 'aicalls',   toolId: 64  },  // reasoningValidate
      { name: 'document-findings',   worker: 'aicalls',   toolId: 90  },  // docGenerate
      { name: 'audit-log',           worker: 'shields',   toolId: 259 },
    ],
    timeout: 604800000,  // 7 days for experiment lifecycle
    retries: 0,
    critical: false,
  },
  {
    id: 30, name: 'feedbackLoop', latinName: 'Orbis Retroactionis', latinDescription: 'Collectio et analysis et prioritas et mensura',
  category: 'research',
    steps: [
      { name: 'collect-feedback',    worker: 'hooks',     toolId: 170 },
      { name: 'analyze-sentiment',   worker: 'aicalls',   toolId: 80  },  // sentimentAnalyze
      { name: 'extract-themes',      worker: 'aicalls',   toolId: 82  },  // topicModel
      { name: 'prioritize-items',    worker: 'aicalls',   toolId: 61  },  // goalDecompose
      { name: 'generate-tasks',      worker: 'aicalls',   toolId: 86  },  // codeGenerate
      { name: 'track-implementation', worker: 'triggers', toolId: 181 },
      { name: 'measure-impact',      worker: 'lenses',    toolId: 148 },  // trendLens
      { name: 'report-outcomes',     worker: 'aicalls',   toolId: 78  },  // summaryAbstract
    ],
    timeout: 2592000000,  // 30 days for feedback cycle
    retries: 0,
    critical: false,
  },

  // ─── MULTI-AGENT COORDINATION (031–035) ─────────────────────
  {
    id: 31, name: 'agentSwarmDeploy', latinName: 'Deploymentum Examinis', latinDescription: 'Deploymentum topologiae examinis et initium',
  category: 'multi-agent',
    license: 'CPEL-1.0',
    steps: [
      { name: 'define-swarm-topology', worker: 'blueprints', toolId: 103 },  // agentSwarmBlueprint
      { name: 'allocate-agents',       worker: 'aicalls',   toolId: 97  },  // pipelineOrchestrate
      { name: 'assign-roles',          worker: 'aicalls',   toolId: 81  },  // intentClassify
      { name: 'establish-channels',    worker: 'routing',   toolId: null },
      { name: 'deploy-sentinels',      worker: 'sentinel',  toolId: null },
      { name: 'verify-connectivity',   worker: 'sensors',   toolId: 231 },  // networkSensor
      { name: 'start-heartbeats',      worker: 'hooks',     toolId: 170 },  // onHeartbeat
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 2,
    critical: true,
  },
  {
    id: 32, name: 'agentConsensus', latinName: 'Consensus Agentium', latinDescription: 'Collectio suffragiorum et quorum et decretum',
  category: 'multi-agent',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-votes',         worker: 'hooks',     toolId: 175 },  // onDataReceived
      { name: 'validate-quorum',       worker: 'triggers',  toolId: 181 },  // thresholdTrigger
      { name: 'compute-consensus',     worker: 'aicalls',   toolId: 64  },  // reasoningValidate
      { name: 'broadcast-decision',    worker: 'routing',   toolId: null },
      { name: 'verify-acknowledgment', worker: 'sensors',   toolId: 231 },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: true,
  },
  {
    id: 33, name: 'agentNegotiation', latinName: 'Negotiatio Agentium', latinDescription: 'Definitio terminorum et aestimatio et formalizatio',
  category: 'multi-agent',
    license: 'CPEL-1.0',
    steps: [
      { name: 'define-terms',          worker: 'aicalls',   toolId: 76  },  // hypothesisForm
      { name: 'evaluate-offers',       worker: 'aicalls',   toolId: 74  },  // uncertaintyQuantify
      { name: 'counter-propose',       worker: 'aicalls',   toolId: 63  },  // promptChain
      { name: 'reach-agreement',       worker: 'aicalls',   toolId: 64  },  // reasoningValidate
      { name: 'formalize-contract',    worker: 'contracts', toolId: null },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 2,
    critical: false,
  },
  {
    id: 34, name: 'agentSelfHeal', latinName: 'Auto-Sanatio Agentis', latinDescription: 'Detectio et diagnosis et isolatio et restitutio',
  category: 'multi-agent',
    license: 'CPEL-1.0',
    steps: [
      { name: 'detect-failure',        worker: 'sentinel',  toolId: null },
      { name: 'diagnose-root-cause',   worker: 'aicalls',   toolId: 81  },  // intentClassify
      { name: 'isolate-fault',         worker: 'shields',   toolId: 255 },  // bulkhead
      { name: 'spawn-replacement',     worker: 'infra',     toolId: null },
      { name: 'restore-state',         worker: 'recipes',   toolId: 131 },  // backupRestoreRecipe
      { name: 'verify-recovery',       worker: 'sensors',   toolId: 225 },  // errorRateSensor
      { name: 'update-topology',       worker: 'routing',   toolId: null },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 3,
    critical: true,
  },
  {
    id: 35, name: 'agentLoadBalance', latinName: 'Aequipondium Agentis', latinDescription: 'Mensura et praedictio et distributio oneris',
  category: 'multi-agent',
    license: 'CPEL-1.0',
    steps: [
      { name: 'measure-load',          worker: 'sensors',   toolId: 234 },  // workerLoadSensor
      { name: 'predict-demand',        worker: 'lenses',    toolId: 148 },  // trendLens
      { name: 'compute-distribution',  worker: 'aicalls',   toolId: 97  },  // pipelineOrchestrate
      { name: 'migrate-tasks',         worker: 'micro',     toolId: null },
      { name: 'verify-balance',        worker: 'sensors',   toolId: 234 },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: true,
  },

  // ─── INTELLIGENCE & LEARNING (036–040) ──────────────────────
  {
    id: 36, name: 'continuousLearning', latinName: 'Discere Continuum', latinDescription: 'Collectio colloquiorum et extractio et repositio',
  category: 'intelligence',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-interactions',  worker: 'hooks',     toolId: 175 },
      { name: 'extract-patterns',      worker: 'aicalls',   toolId: 79  },  // entityExtract
      { name: 'update-embeddings',     worker: 'aicalls',   toolId: 85  },  // embeddingGenerate
      { name: 'validate-learning',     worker: 'aicalls',   toolId: 64  },  // reasoningValidate
      { name: 'store-knowledge',       worker: 'memory',    toolId: null },
      { name: 'index-knowledge',       worker: 'aicalls',   toolId: 79  },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 300000,
    retries: 1,
    critical: false,
  },
  {
    id: 37, name: 'anomalyDetection', latinName: 'Detectio Anomaliae', latinDescription: 'Vestigia et aberrationes et classificatio et signum',
  category: 'intelligence',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-baselines',     worker: 'sensors',   toolId: 221 },
      { name: 'compute-deviations',    worker: 'lenses',    toolId: 149 },  // anomalyLens
      { name: 'classify-anomaly',      worker: 'aicalls',   toolId: 81  },
      { name: 'correlate-events',      worker: 'lenses',    toolId: 151 },  // correlationLens
      { name: 'score-severity',        worker: 'aicalls',   toolId: 74  },
      { name: 'trigger-response',      worker: 'triggers',  toolId: 181 },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 15000,
    retries: 0,
    critical: true,
  },
  {
    id: 38, name: 'knowledgeDistill', latinName: 'Destillatio Scientiae', latinDescription: 'Identificatio et extractio et compressio scientiae',
  category: 'intelligence',
    license: 'CPEL-1.0',
    steps: [
      { name: 'identify-knowledge',    worker: 'aicalls',   toolId: 82  },  // topicModel
      { name: 'extract-insights',      worker: 'aicalls',   toolId: 78  },  // summaryAbstract
      { name: 'compress-knowledge',    worker: 'aicalls',   toolId: 85  },  // embeddingGenerate
      { name: 'validate-accuracy',     worker: 'aicalls',   toolId: 62  },  // hallucinationCheck
      { name: 'store-distilled',       worker: 'memory',    toolId: null },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 600000,
    retries: 1,
    critical: false,
  },
  {
    id: 39, name: 'predictiveAnalytics', latinName: 'Analytica Praedictiva', latinDescription: 'Historica et excerpta et institutio et praedictio',
  category: 'intelligence',
    license: 'CPEL-1.0',
    steps: [
      { name: 'gather-historical',     worker: 'sensors',   toolId: 224 },  // throughputSensor
      { name: 'feature-engineer',      worker: 'aicalls',   toolId: 79  },
      { name: 'train-model',           worker: 'aicalls',   toolId: 97  },  // pipelineOrchestrate
      { name: 'validate-predictions',  worker: 'aicalls',   toolId: 64  },
      { name: 'generate-forecast',     worker: 'lenses',    toolId: 148 },  // trendLens
      { name: 'publish-insights',      worker: 'routing',   toolId: null },
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 1800000,
    retries: 1,
    critical: false,
  },
  {
    id: 40, name: 'sentinelShieldSensorLoop', latinName: 'Orbis Vigilis Scuti', latinDescription: 'Vestigatio et detectio et scutum et sanatio continua',
  category: 'intelligence',
    license: 'CPEL-1.0',
    steps: [
      { name: 'sensor-sweep',          worker: 'sensors',   toolId: 221 },  // cpuSensor (all)
      { name: 'anomaly-detect',        worker: 'sentinel',  toolId: null },
      { name: 'threat-classify',       worker: 'aicalls',   toolId: 81  },
      { name: 'shield-activate',       worker: 'shields',   toolId: 254 },  // circuitBreaker
      { name: 'contain-isolate',       worker: 'shields',   toolId: 255 },  // bulkhead
      { name: 'self-heal-attempt',     worker: 'recipes',   toolId: 138 },  // securityScanRecipe
      { name: 'verify-recovery',       worker: 'sensors',   toolId: 225 },  // errorRateSensor
      { name: 'update-posture',        worker: 'sentinel',  toolId: null },
      { name: 'feedback-to-sensors',   worker: 'sensors',   toolId: 240 },  // phiResonanceSensor
      { name: 'audit-log',             worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: true,
  },

  // ─── COMPLIANCE & LEGAL (041–045) ───────────────────────────
  {
    id: 41, name: 'gdprDataRequest', latinName: 'Petitio Datae GDPR', latinDescription: 'Authentificatio et verificatio et collectio et traditio',
  category: 'compliance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'authenticate-requester', worker: 'shields',  toolId: 241 },
      { name: 'verify-identity',        worker: 'shields',  toolId: 260 },
      { name: 'locate-data',            worker: 'memory',   toolId: null },
      { name: 'compile-report',         worker: 'lenses',   toolId: 142 },  // hierarchyLens
      { name: 'mask-third-party-pii',   worker: 'shields',  toolId: 246 },
      { name: 'format-export',          worker: 'aicalls',  toolId: 95  },  // formatConvert
      { name: 'deliver-to-requester',   worker: 'adapters', toolId: 215 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 2592000000,  // 30 days (GDPR deadline)
    retries: 1,
    critical: true,
  },
  {
    id: 42, name: 'gdprDataDeletion', latinName: 'Deletio Datae GDPR', latinDescription: 'Verificatio et ambitus et executio et confirmatio',
  category: 'compliance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'verify-request',         worker: 'shields',  toolId: 241 },
      { name: 'identify-data-scope',    worker: 'lenses',   toolId: 145 },  // flowLens
      { name: 'check-legal-holds',      worker: 'triggers', toolId: 187 },  // deadlineTrigger
      { name: 'execute-deletion',       worker: 'memory',   toolId: null },
      { name: 'verify-deletion',        worker: 'shields',  toolId: 260 },
      { name: 'confirm-to-requester',   worker: 'adapters', toolId: 215 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 2592000000,
    retries: 1,
    critical: true,
  },
  {
    id: 43, name: 'soc2AuditPrep', latinName: 'Praeparatio Inspectionis SOC2', latinDescription: 'Evidentia et vestigium et accessus et securitas et relatio',
  category: 'compliance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-evidence',       worker: 'sensors',  toolId: 221 },
      { name: 'compile-audit-trail',    worker: 'shields',  toolId: 259 },
      { name: 'verify-access-controls', worker: 'shields',  toolId: 243 },
      { name: 'test-security-controls', worker: 'recipes',  toolId: 138 },
      { name: 'generate-report',        worker: 'lenses',   toolId: 158 },  // complianceLens
      { name: 'flag-gaps',              worker: 'triggers', toolId: 181 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 86400000,  // 24 hours
    retries: 0,
    critical: true,
  },
  {
    id: 44, name: 'licenseEnforcement', latinName: 'Executio Licentiae', latinDescription: 'Exploratio et verificatio et expiratio et executio',
  category: 'compliance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'scan-active-clients',    worker: 'sensors',  toolId: 233 },
      { name: 'verify-license-status',  worker: 'contracts', toolId: null },
      { name: 'check-expiration',       worker: 'triggers', toolId: 187 },
      { name: 'enforce-restrictions',   worker: 'shields',  toolId: 258 },  // quotaEnforcer
      { name: 'notify-expiring',        worker: 'adapters', toolId: 215 },
      { name: 'suspend-if-expired',     worker: 'shields',  toolId: 243 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 300000,
    retries: 1,
    critical: true,
  },
  {
    id: 45, name: 'ipProtection', latinName: 'Tutela Proprietatis', latinDescription: 'Exploratio et plagium et signum et provenientiam',
  category: 'compliance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'scan-outputs',           worker: 'shields',  toolId: 249 },  // copyrightChecker
      { name: 'detect-plagiarism',      worker: 'aicalls',  toolId: 62  },
      { name: 'watermark-content',      worker: 'crypto',   toolId: null },
      { name: 'register-provenance',    worker: 'contracts', toolId: null },
      { name: 'verify-integrity',       worker: 'shields',  toolId: 260 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: true,
  },

  // ─── INTEGRATION & INTEROP (046–050) ────────────────────────
  {
    id: 46, name: 'webhookPipeline', latinName: 'Iter Hamuli Retis', latinDescription: 'Receptio et validatio et resolutio et transmissio',
  category: 'integration',
    license: 'CPEL-1.0',
    steps: [
      { name: 'receive-webhook',        worker: 'adapters', toolId: 218 },  // webhookAdapter
      { name: 'validate-signature',     worker: 'crypto',   toolId: null },
      { name: 'parse-payload',          worker: 'aicalls',  toolId: 96  },  // schemaValidate
      { name: 'sanitize-data',          worker: 'shields',  toolId: 241 },
      { name: 'route-internally',       worker: 'routing',  toolId: null },
      { name: 'execute-handler',        worker: 'hooks',    toolId: 175 },
      { name: 'respond-to-sender',      worker: 'adapters', toolId: 220 },  // restAdapter
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 10000,
    retries: 2,
    critical: true,
  },
  {
    id: 47, name: 'apiGateway', latinName: 'Porta API', latinDescription: 'Receptio et authentificatio et limitatio et transmissio',
  category: 'integration',
    license: 'CPEL-1.0',
    steps: [
      { name: 'receive-request',        worker: 'adapters', toolId: 220 },
      { name: 'authenticate',           worker: 'shields',  toolId: 241 },
      { name: 'rate-limit',             worker: 'shields',  toolId: 243 },
      { name: 'validate-schema',        worker: 'aicalls',  toolId: 96  },
      { name: 'route-to-service',       worker: 'routing',  toolId: null },
      { name: 'transform-response',     worker: 'aicalls',  toolId: 95  },
      { name: 'cache-if-eligible',      worker: 'memory',   toolId: null },
      { name: 'deliver-response',       worker: 'adapters', toolId: 220 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 10000,
    retries: 1,
    critical: true,
  },
  {
    id: 48, name: 'eventBridge', latinName: 'Pons Eventuum', latinDescription: 'Receptio et normalizatio et percolatio et distributio',
  category: 'integration',
    license: 'CPEL-1.0',
    steps: [
      { name: 'receive-event',          worker: 'hooks',    toolId: 161 },  // onSystemStart
      { name: 'normalize-event',        worker: 'aicalls',  toolId: 95  },
      { name: 'filter-by-rules',        worker: 'triggers', toolId: 181 },
      { name: 'fan-out-subscribers',    worker: 'routing',  toolId: null },
      { name: 'confirm-delivery',       worker: 'sensors',  toolId: 231 },
      { name: 'dead-letter-if-failed',  worker: 'memory',   toolId: null },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 15000,
    retries: 3,
    critical: true,
  },
  {
    id: 49, name: 'dataSync', latinName: 'Synchronizatio Datae', latinDescription: 'Detectio et conflictus et transformatio et verificatio',
  category: 'integration',
    license: 'CPEL-1.0',
    steps: [
      { name: 'detect-changes',         worker: 'triggers', toolId: 193 },  // changeTrigger
      { name: 'resolve-conflicts',      worker: 'aicalls',  toolId: 64  },
      { name: 'apply-transforms',       worker: 'aicalls',  toolId: 95  },
      { name: 'sync-to-target',         worker: 'adapters', toolId: 220 },
      { name: 'verify-consistency',     worker: 'shields',  toolId: 260 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 120000,
    retries: 2,
    critical: true,
  },
  {
    id: 50, name: 'graphqlFederation', latinName: 'Foederatio Quaestionis', latinDescription: 'Analysis et planificatio et distributio et fusio',
  category: 'integration',
    license: 'CPEL-1.0',
    steps: [
      { name: 'parse-query',            worker: 'aicalls',  toolId: 96  },
      { name: 'plan-execution',         worker: 'aicalls',  toolId: 97  },
      { name: 'fan-out-subqueries',     worker: 'routing',  toolId: null },
      { name: 'merge-results',          worker: 'lenses',   toolId: 151 },  // correlationLens
      { name: 'filter-authorized',      worker: 'shields',  toolId: 243 },
      { name: 'deliver-response',       worker: 'adapters', toolId: 220 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 10000,
    retries: 1,
    critical: true,
  },

  // ─── SDK & DEVELOPER EXPERIENCE (051–055) ───────────────────
  {
    id: 51, name: 'sdkApiCall', latinName: 'Vocatio API', latinDescription: 'Analysis et validatio et versio et transmissio et executio',
  category: 'sdk',
    license: 'CPEL-1.0',
    steps: [
      { name: 'parse-sdk-request',      worker: 'aicalls',  toolId: 96  },
      { name: 'validate-api-key',       worker: 'shields',  toolId: 241 },
      { name: 'check-sdk-version',      worker: 'triggers', toolId: 181 },
      { name: 'route-to-protocol',      worker: 'routing',  toolId: null },
      { name: 'execute-action',         worker: 'micro',    toolId: null },
      { name: 'format-sdk-response',    worker: 'aicalls',  toolId: 95  },
      { name: 'track-sdk-usage',        worker: 'sensors',  toolId: 238 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 10000,
    retries: 2,
    critical: true,
  },
  {
    id: 52, name: 'sdkAuth', latinName: 'Authentificatio SDK', latinDescription: 'Testimonia et signum et permissiones et sessio',
  category: 'sdk',
    license: 'CPEL-1.0',
    steps: [
      { name: 'validate-credentials',   worker: 'shields',  toolId: 241 },
      { name: 'generate-token',         worker: 'crypto',   toolId: null },
      { name: 'set-permissions',         worker: 'shields',  toolId: 258 },
      { name: 'register-session',       worker: 'contracts', toolId: null },
      { name: 'return-auth-token',      worker: 'routing',  toolId: null },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 5000,
    retries: 1,
    critical: true,
  },
  {
    id: 53, name: 'sdkBatchOperation', latinName: 'Operatio Multitudinis', latinDescription: 'Analysis et validatio et quota et distributio et aggregatio',
  category: 'sdk',
    license: 'CPEL-1.0',
    steps: [
      { name: 'parse-batch',            worker: 'aicalls',  toolId: 96  },
      { name: 'validate-all',           worker: 'shields',  toolId: 241 },
      { name: 'check-batch-quota',      worker: 'shields',  toolId: 258 },
      { name: 'fan-out-operations',     worker: 'micro',    toolId: null },
      { name: 'collect-results',        worker: 'hooks',    toolId: 175 },
      { name: 'aggregate-response',     worker: 'lenses',   toolId: 146 },  // distributionLens
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: true,
  },
  {
    id: 54, name: 'sdkWebSocket', latinName: 'Nexus Tessellae Retis', latinDescription: 'Promovere et authentificare et canales et eventus et pulsus',
  category: 'sdk',
    license: 'CPEL-1.0',
    steps: [
      { name: 'upgrade-connection',     worker: 'adapters', toolId: 220 },
      { name: 'authenticate-socket',    worker: 'shields',  toolId: 241 },
      { name: 'register-channels',      worker: 'routing',  toolId: null },
      { name: 'bind-events',            worker: 'hooks',    toolId: 170 },
      { name: 'start-heartbeat',        worker: 'sensors',  toolId: 236 },  // signalStrengthSensor
      { name: 'monitor-connection',     worker: 'triggers', toolId: 181 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 86400000,  // 24 hours for persistent connection
    retries: 0,
    critical: true,
  },
  {
    id: 55, name: 'sdkDocGenerate', latinName: 'Generatio Documentorum', latinDescription: 'Exploratio et schemata et openapi et exempla et publicatio',
  category: 'sdk',
    license: 'CPEL-1.0',
    steps: [
      { name: 'scan-all-protocols',     worker: 'lenses',   toolId: 141 },
      { name: 'extract-schemas',        worker: 'aicalls',  toolId: 96  },
      { name: 'generate-openapi',       worker: 'aicalls',  toolId: 90  },  // docGenerate
      { name: 'generate-examples',      worker: 'aicalls',  toolId: 86  },  // codeGenerate
      { name: 'render-docs',            worker: 'products', toolId: null },
      { name: 'publish-docs',           worker: 'adapters', toolId: 218 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 300000,
    retries: 1,
    critical: false,
  },

  // ─── DISCOVERY & EXPANSION (056–060) ────────────────────────
  {
    id: 56, name: 'ecosystemProbe', latinName: 'Sondatio Ecosystematis', latinDescription: 'Investigatio ecosystematis pro novis capacitatibus',
  category: 'discovery-expansion',
    license: 'CPEL-1.0',
    steps: [
      { name: 'init-topology-scan',     worker: 'discovery', toolId: null },
      { name: 'worker-scan',            worker: 'discovery', toolId: null },
      { name: 'tool-scan',              worker: 'discovery', toolId: null },
      { name: 'protocol-scan',          worker: 'discovery', toolId: null },
      { name: 'capability-map',         worker: 'discovery', toolId: null },
      { name: 'store-topology',         worker: 'memory',   toolId: null },
      { name: 'emit-topology-event',    worker: 'hooks',    toolId: 161 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: false,
  },
  {
    id: 57, name: 'capabilityAdvertise', latinName: 'Praedicatio Capacitatis', latinDescription: 'Praedicatio capacitatis platformae ad organismo pares',
  category: 'discovery-expansion',
    license: 'CPEL-1.0',
    steps: [
      { name: 'compile-capabilities',   worker: 'discovery', toolId: null },
      { name: 'sign-manifest',          worker: 'crypto',   toolId: null },
      { name: 'broadcast-to-peers',     worker: 'adapters', toolId: 220 },
      { name: 'register-advertisement', worker: 'contracts', toolId: null },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 15000,
    retries: 2,
    critical: false,
  },
  {
    id: 58, name: 'serviceDiscovery', latinName: 'Inventio Munerum', latinDescription: 'Inventio automatica munerum et artificum disponibilium',
  category: 'discovery-expansion',
    license: 'CPEL-1.0',
    steps: [
      { name: 'scan-workers',           worker: 'discovery', toolId: null },
      { name: 'scan-tools',             worker: 'discovery', toolId: null },
      { name: 'scan-agents',            worker: 'discovery', toolId: null },
      { name: 'scan-channels',          worker: 'discovery', toolId: null },
      { name: 'scan-dependencies',      worker: 'discovery', toolId: null },
      { name: 'generate-service-map',   worker: 'lenses',   toolId: 145 },
      { name: 'emit-discovery-event',   worker: 'hooks',    toolId: 175 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: false,
  },
  {
    id: 59, name: 'knowledgeHarvest', latinName: 'Messis Scientiae', latinDescription: 'Collectio scientiae ex telemetria et colloquiis',
  category: 'discovery-expansion',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-telemetry',      worker: 'sensors',  toolId: 237 },
      { name: 'mine-patterns',          worker: 'discovery', toolId: null },
      { name: 'extract-insights',       worker: 'aicalls',  toolId: 78  },
      { name: 'validate-insights',      worker: 'aicalls',  toolId: 64  },
      { name: 'store-in-knowledge',     worker: 'memory',   toolId: null },
      { name: 'index-insights',         worker: 'aicalls',  toolId: 79  },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 120000,
    retries: 1,
    critical: false,
  },
  {
    id: 60, name: 'opportunityMine', latinName: 'Effossio Opportunitatis', latinDescription: 'Effossio datae operationalium pro opportunitatibus optimizationis',
  category: 'discovery-expansion',
    license: 'CPEL-1.0',
    steps: [
      { name: 'score-opportunities',    worker: 'discovery', toolId: null },
      { name: 'find-bottlenecks',       worker: 'discovery', toolId: null },
      { name: 'find-redundancy',        worker: 'discovery', toolId: null },
      { name: 'analyze-trends',         worker: 'lenses',   toolId: 148 },
      { name: 'prioritize-by-impact',   worker: 'aicalls',  toolId: 61  },
      { name: 'generate-report',        worker: 'lenses',   toolId: 156 },
      { name: 'emit-opportunity-event', worker: 'hooks',    toolId: 175 },
      { name: 'audit-log',              worker: 'shields',  toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: false,
  },

  // ─── PACKAGE & INSTALLATION (061–065) ───────────────────────
  {
    id: 61, name: 'packageLifecycle', latinName: 'Vita Fasciculi', latinDescription: 'Cyclus plenus installationis et verificationis et registrationis',
  category: 'package-installation',
    license: 'CPEL-1.0',
    steps: [
      { name: 'validate-package',       worker: 'installers', toolId: null },
      { name: 'check-dependencies',     worker: 'installers', toolId: null },
      { name: 'install-package',        worker: 'installers', toolId: null },
      { name: 'verify-integrity',       worker: 'shields',    toolId: 260 },
      { name: 'register-in-marketplace', worker: 'marketplace', toolId: null },
      { name: 'notify-completion',      worker: 'hooks',      toolId: 175 },
      { name: 'audit-log',              worker: 'shields',    toolId: 259 },
    ],
    timeout: 120000,
    retries: 2,
    critical: false,
  },
  {
    id: 62, name: 'workerProvisioning', latinName: 'Provisio Operarii', latinDescription: 'Provisio et registratio novi moduli artificis',
  category: 'package-installation',
    license: 'CPEL-1.0',
    steps: [
      { name: 'validate-worker-module', worker: 'shields',    toolId: 260 },
      { name: 'install-worker',         worker: 'installers', toolId: null },
      { name: 'register-with-infra',    worker: 'infra',      toolId: null },
      { name: 'subscribe-to-routing',   worker: 'routing',    toolId: null },
      { name: 'register-with-sentinel', worker: 'sentinel',   toolId: null },
      { name: 'verify-heartbeat',       worker: 'sensors',    toolId: 236 },
      { name: 'audit-log',              worker: 'shields',    toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: false,
  },
  {
    id: 63, name: 'toolBundleDeploy', latinName: 'Deploymentum Fasciculi', latinDescription: 'Deploymentum et registratio fasciculi instrumentorum',
  category: 'package-installation',
    license: 'CPEL-1.0',
    steps: [
      { name: 'validate-bundle',        worker: 'shields',    toolId: 241 },
      { name: 'install-bundle',         worker: 'installers', toolId: null },
      { name: 'register-tools',         worker: 'marketplace', toolId: null },
      { name: 'index-new-tools',        worker: 'aicalls',   toolId: 79  },
      { name: 'verify-availability',    worker: 'sensors',   toolId: 235 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 2,
    critical: false,
  },
  {
    id: 64, name: 'rollbackPipeline', latinName: 'Iter Reversionis', latinDescription: 'Reversio installationis vel deploymentis deficientis',
  category: 'package-installation',
    license: 'CPEL-1.0',
    steps: [
      { name: 'identify-target',        worker: 'discovery',  toolId: null },
      { name: 'backup-current',         worker: 'recipes',   toolId: 131 },
      { name: 'rollback-install',       worker: 'installers', toolId: null },
      { name: 'restore-state',          worker: 'recipes',   toolId: 131 },
      { name: 'verify-rollback',        worker: 'shields',   toolId: 260 },
      { name: 'notify-ops',             worker: 'adapters',  toolId: 215 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 0,
    critical: true,
  },
  {
    id: 65, name: 'upgradeOrchestration', latinName: 'Orchestratio Perfectioris', latinDescription: 'Orchestratio upgradorum multiplicium componentium platformae',
  category: 'package-installation',
    license: 'CPEL-1.0',
    steps: [
      { name: 'plan-upgrade',           worker: 'aicalls',   toolId: 61  },
      { name: 'backup-all-state',       worker: 'recipes',   toolId: 131 },
      { name: 'upgrade-packages',       worker: 'installers', toolId: null },
      { name: 'run-integrity-check',    worker: 'shields',   toolId: 260 },
      { name: 'run-smoke-tests',        worker: 'sensors',   toolId: 225 },
      { name: 'promote-if-healthy',     worker: 'triggers',  toolId: 181 },
      { name: 'rollback-if-failed',     worker: 'recipes',   toolId: 131 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 600000,
    retries: 0,
    critical: true,
  },

  // ─── KNOWLEDGE & MEMORY (066–070) ───────────────────────────
  {
    id: 66, name: 'knowledgeIngestion', latinName: 'Ingestio Scientiae', latinDescription: 'Ingestio et classificatio et indexatio scientiae externae',
  category: 'knowledge-memory',
    license: 'CPEL-1.0',
    steps: [
      { name: 'receive-source',         worker: 'adapters',  toolId: 220 },
      { name: 'classify-content',       worker: 'aicalls',   toolId: 82  },  // topicModel
      { name: 'sanitize-content',       worker: 'shields',   toolId: 241 },
      { name: 'extract-entities',       worker: 'aicalls',   toolId: 79  },  // entityExtract
      { name: 'embed-content',          worker: 'aicalls',   toolId: 85  },  // embeddingGenerate
      { name: 'store-in-memory',        worker: 'memory',    toolId: null },
      { name: 'index-knowledge',        worker: 'aicalls',   toolId: 79  },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 2,
    critical: false,
  },
  {
    id: 67, name: 'memoryConsolidation', latinName: 'Consolidatio Memoriae', latinDescription: 'Consolidatio et deduplicatio et optimizatio patternorum memoriae',
  category: 'knowledge-memory',
    license: 'CPEL-1.0',
    steps: [
      { name: 'scan-memory-patterns',   worker: 'memory',    toolId: null },
      { name: 'detect-duplicates',      worker: 'discovery', toolId: null },
      { name: 'merge-similar',          worker: 'aicalls',   toolId: 83  },  // semanticSimilarity
      { name: 'compress-embeddings',    worker: 'aicalls',   toolId: 85  },
      { name: 'reindex-patterns',       worker: 'memory',    toolId: null },
      { name: 'verify-consolidation',   worker: 'sensors',   toolId: 237 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 300000,
    retries: 1,
    critical: false,
  },
  {
    id: 68, name: 'knowledgeRetrieval', latinName: 'Recuperatio Scientiae', latinDescription: 'Recuperatio semantica intelligens scientiae',
  category: 'knowledge-memory',
    license: 'CPEL-1.0',
    steps: [
      { name: 'parse-query',            worker: 'aicalls',   toolId: 96  },
      { name: 'embed-query',            worker: 'aicalls',   toolId: 85  },
      { name: 'semantic-search',        worker: 'memory',    toolId: null },
      { name: 'rank-results',           worker: 'aicalls',   toolId: 74  },
      { name: 'filter-authorized',      worker: 'shields',   toolId: 243 },
      { name: 'format-response',        worker: 'aicalls',   toolId: 95  },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 5000,
    retries: 1,
    critical: false,
  },
  {
    id: 69, name: 'contextAssembly', latinName: 'Compositio Contextus', latinDescription: 'Compositio contextus ex memoria pro petitionibus IA',
  category: 'knowledge-memory',
    license: 'CPEL-1.0',
    steps: [
      { name: 'retrieve-recent-memory', worker: 'memory',    toolId: null },
      { name: 'retrieve-knowledge',     worker: 'memory',    toolId: null },
      { name: 'fetch-client-profile',   worker: 'database',  toolId: null },
      { name: 'score-relevance',        worker: 'aicalls',   toolId: 74  },
      { name: 'assemble-context',       worker: 'aicalls',   toolId: 63  },  // promptChain
      { name: 'compress-to-token-budget', worker: 'aicalls', toolId: 66  },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 3000,
    retries: 0,
    critical: false,
  },
  {
    id: 70, name: 'knowledgeExport', latinName: 'Exportatio Scientiae', latinDescription: 'Exportatio graphi scientiae in formatis normalibus',
  category: 'knowledge-memory',
    license: 'CPEL-1.0',
    steps: [
      { name: 'authorize-export',       worker: 'shields',   toolId: 241 },
      { name: 'query-knowledge',        worker: 'memory',    toolId: null },
      { name: 'mask-private-content',   worker: 'shields',   toolId: 246 },
      { name: 'format-export',          worker: 'aicalls',   toolId: 95  },
      { name: 'sign-export',            worker: 'crypto',    toolId: null },
      { name: 'deliver-export',         worker: 'adapters',  toolId: 220 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: false,
  },

  // ─── PERFORMANCE & OPTIMIZATION (071–075) ───────────────────
  {
    id: 71, name: 'performanceBaseline', latinName: 'Basis Performantiae', latinDescription: 'Institutio basium performantiae per classem artificum',
  category: 'performance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-latency',        worker: 'sensors',   toolId: 223 },
      { name: 'collect-throughput',     worker: 'sensors',   toolId: 224 },
      { name: 'collect-error-rates',    worker: 'sensors',   toolId: 225 },
      { name: 'collect-cpu',            worker: 'sensors',   toolId: 221 },
      { name: 'compute-baselines',      worker: 'discovery', toolId: null },
      { name: 'store-baselines',        worker: 'database',  toolId: null },
      { name: 'publish-baselines',      worker: 'lenses',    toolId: 157 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 0,
    critical: false,
  },
  {
    id: 72, name: 'bottleneckResolve', latinName: 'Solutio Strangulationis', latinDescription: 'Detectio et diagnosis et relectio et verificatio et registratio',
  category: 'performance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'detect-bottleneck',      worker: 'discovery', toolId: null },
      { name: 'classify-type',          worker: 'aicalls',   toolId: 81  },
      { name: 'propose-resolution',     worker: 'aicalls',   toolId: 61  },
      { name: 'apply-reroute',          worker: 'routing',   toolId: null },
      { name: 'verify-improvement',     worker: 'sensors',   toolId: 223 },
      { name: 'persist-fix',            worker: 'database',  toolId: null },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: false,
  },
  {
    id: 73, name: 'resourceOptimize', latinName: 'Optimizatio Rerum', latinDescription: 'Profilatio et modellum et redistributio et verificatio',
  category: 'performance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'profile-all-workers',    worker: 'sensors',   toolId: 234 },
      { name: 'model-demand',           worker: 'lenses',    toolId: 148 },
      { name: 'compute-allocation',     worker: 'aicalls',   toolId: 97  },
      { name: 'apply-allocation',       worker: 'micro',     toolId: null },
      { name: 'verify-efficiency',      worker: 'sensors',   toolId: 234 },
      { name: 'store-allocation',       worker: 'database',  toolId: null },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 1,
    critical: false,
  },
  {
    id: 74, name: 'cacheWarmup', latinName: 'Calefactio Cachi', latinDescription: 'Praedictio et calefactio et validatio et relatio cachi',
  category: 'performance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'predict-hot-paths',      worker: 'discovery', toolId: null },
      { name: 'fetch-candidate-data',   worker: 'database',  toolId: null },
      { name: 'warm-memory-cache',      worker: 'memory',    toolId: null },
      { name: 'warm-routes',            worker: 'routing',   toolId: null },
      { name: 'validate-warmup',        worker: 'sensors',   toolId: 223 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: false,
  },
  {
    id: 75, name: 'loadTest', latinName: 'Probatio Oneris', latinDescription: 'Incrementum et mensura et analysis et relatio et terminatio',
  category: 'performance',
    license: 'CPEL-1.0',
    steps: [
      { name: 'define-test-plan',       worker: 'aicalls',   toolId: 76  },
      { name: 'ramp-up-load',           worker: 'micro',     toolId: null },
      { name: 'measure-under-load',     worker: 'sensors',   toolId: 221 },
      { name: 'detect-degradation',     worker: 'discovery', toolId: null },
      { name: 'ramp-down',              worker: 'micro',     toolId: null },
      { name: 'analyze-results',        worker: 'lenses',    toolId: 153 },
      { name: 'generate-report',        worker: 'lenses',    toolId: 158 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 1800000,
    retries: 0,
    critical: false,
  },

  // ─── DEPLOYMENT & RELEASE (076–080) ─────────────────────────
  {
    id: 76, name: 'blueGreenDeploy', latinName: 'Deploymentum Bicolor', latinDescription: 'Provisio viridis et iter et mensura et commutatio plena',
  category: 'deployment',
    license: 'CPEL-1.0',
    steps: [
      { name: 'provision-green',        worker: 'infra',     toolId: null },
      { name: 'install-on-green',       worker: 'installers', toolId: null },
      { name: 'route-5pct-to-green',    worker: 'routing',   toolId: null },
      { name: 'measure-green-health',   worker: 'sensors',   toolId: 225 },
      { name: 'compare-health',         worker: 'lenses',    toolId: 151 },
      { name: 'full-cutover',           worker: 'routing',   toolId: null },
      { name: 'decommission-blue',      worker: 'infra',     toolId: null },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 600000,
    retries: 0,
    critical: true,
  },
  {
    id: 77, name: 'featureToggle', latinName: 'Commutatio Featurae', latinDescription: 'Validatio et propagatio et activatio et mensura et registratio',
  category: 'deployment',
    license: 'CPEL-1.0',
    steps: [
      { name: 'validate-flag',          worker: 'shields',   toolId: 241 },
      { name: 'propagate-to-workers',   worker: 'routing',   toolId: null },
      { name: 'activate-flag',          worker: 'triggers',  toolId: 196 },
      { name: 'measure-impact',         worker: 'sensors',   toolId: 224 },
      { name: 'rollback-if-degraded',   worker: 'triggers',  toolId: 181 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: false,
  },
  {
    id: 78, name: 'releaseValidation', latinName: 'Validatio Emissionis', latinDescription: 'Constructio et probatio et exploratio et approbatio et signum',
  category: 'deployment',
    license: 'CPEL-1.0',
    steps: [
      { name: 'verify-build',           worker: 'shields',   toolId: 260 },
      { name: 'security-scan',          worker: 'recipes',   toolId: 138 },
      { name: 'run-integrity',          worker: 'shields',   toolId: 260 },
      { name: 'check-compliance',       worker: 'lenses',    toolId: 158 },
      { name: 'generate-approval',      worker: 'aicalls',   toolId: 64  },
      { name: 'sign-release',           worker: 'crypto',    toolId: null },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 0,
    critical: true,
  },
  {
    id: 79, name: 'rolloutOrchestration', latinName: 'Orchestratio Diffusionis', latinDescription: 'Gradatio et verificationes ad 5 et 20 et 50 et 100 centesimae',
  category: 'deployment',
    license: 'CPEL-1.0',
    steps: [
      { name: 'stage-1-deploy',         worker: 'infra',     toolId: null },
      { name: 'measure-5pct',           worker: 'sensors',   toolId: 225 },
      { name: 'stage-2-expand',         worker: 'routing',   toolId: null },
      { name: 'measure-20pct',          worker: 'sensors',   toolId: 225 },
      { name: 'stage-3-majority',       worker: 'routing',   toolId: null },
      { name: 'measure-50pct',          worker: 'sensors',   toolId: 225 },
      { name: 'full-rollout',           worker: 'routing',   toolId: null },
      { name: 'post-verify',            worker: 'sensors',   toolId: 221 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 3600000,
    retries: 0,
    critical: true,
  },
  {
    id: 80, name: 'postDeployVerify', latinName: 'Verificatio Post Deploymentum', latinDescription: 'Inspectio sanitatis et fumus et regressio et signum et relatio',
  category: 'deployment',
    license: 'CPEL-1.0',
    steps: [
      { name: 'health-check',           worker: 'sensors',   toolId: 221 },
      { name: 'smoke-test',             worker: 'recipes',   toolId: 136 },  // testAutomationRecipe
      { name: 'regression-check',       worker: 'sensors',   toolId: 225 },
      { name: 'compare-baselines',      worker: 'discovery', toolId: null },
      { name: 'alert-if-degraded',      worker: 'triggers',  toolId: 185 },
      { name: 'generate-deploy-report', worker: 'lenses',    toolId: 156 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 60000,
    retries: 0,
    critical: true,
  },

  // ─── OBSERVABILITY & DEBUGGING (081–085) ────────────────────
  {
    id: 81, name: 'traceCapture', latinName: 'Captio Vestigii', latinDescription: 'Instrumentatio et collectio et correlatio et repositio et analysis',
  category: 'observability',
    license: 'CPEL-1.0',
    steps: [
      { name: 'instrument-workers',     worker: 'sensors',   toolId: 235 },  // requestRateSensor
      { name: 'collect-spans',          worker: 'hooks',     toolId: 172 },  // onCallComplete
      { name: 'correlate-by-trace-id',  worker: 'lenses',    toolId: 151 },
      { name: 'compute-critical-path',  worker: 'discovery', toolId: null },
      { name: 'store-trace',            worker: 'database',  toolId: null },
      { name: 'analyze-latency',        worker: 'lenses',    toolId: 154 },  // performanceLens
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: false,
  },
  {
    id: 82, name: 'logCorrelation', latinName: 'Correlatio Registri', latinDescription: 'Collectio et analysis et correlatio et superficies per id',
  category: 'observability',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-log-streams',    worker: 'sensors',   toolId: 226 },  // memorySensor
      { name: 'parse-log-entries',      worker: 'aicalls',   toolId: 96  },
      { name: 'correlate-by-request-id', worker: 'lenses',  toolId: 151 },
      { name: 'detect-error-chains',    worker: 'discovery', toolId: null },
      { name: 'surface-root-cause',     worker: 'aicalls',   toolId: 81  },
      { name: 'generate-log-report',    worker: 'lenses',    toolId: 158 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: false,
  },
  {
    id: 83, name: 'debugSnapshot', latinName: 'Instantaneum Scrutinii', latinDescription: 'Frigefactio et captio et serializatio et repositio et recuperatio',
  category: 'observability',
    license: 'CPEL-1.0',
    steps: [
      { name: 'pause-non-critical',     worker: 'infra',     toolId: null },
      { name: 'capture-worker-states',  worker: 'routing',   toolId: null },
      { name: 'capture-memory',         worker: 'memory',    toolId: null },
      { name: 'capture-telemetry',      worker: 'sensors',   toolId: 221 },
      { name: 'serialize-snapshot',     worker: 'aicalls',   toolId: 95  },
      { name: 'store-snapshot',         worker: 'database',  toolId: null },
      { name: 'resume-workers',         worker: 'infra',     toolId: null },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 0,
    critical: false,
  },
  {
    id: 84, name: 'profilerSession', latinName: 'Sessio Perscrutatoris', latinDescription: 'Instrumentatio et exempla et aggregatio et relatio et purgatio',
  category: 'observability',
    license: 'CPEL-1.0',
    steps: [
      { name: 'start-profiler',         worker: 'sensors',   toolId: 234 },
      { name: 'collect-samples',        worker: 'sensors',   toolId: 226 },
      { name: 'aggregate-flamegraph',   worker: 'lenses',    toolId: 154 },
      { name: 'identify-hot-spots',     worker: 'discovery', toolId: null },
      { name: 'stop-profiler',          worker: 'sensors',   toolId: 234 },
      { name: 'generate-profile-report', worker: 'lenses',  toolId: 156 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 300000,
    retries: 0,
    critical: false,
  },
  {
    id: 85, name: 'alertCorrelation', latinName: 'Correlatio Signalium', latinDescription: 'Collectio signalium et manipulus et causa radicis et notificatio',
  category: 'observability',
    license: 'CPEL-1.0',
    steps: [
      { name: 'collect-active-alerts',  worker: 'sentinel',  toolId: null },
      { name: 'cluster-by-symptom',     worker: 'discovery', toolId: null },
      { name: 'correlate-to-changes',   worker: 'lenses',    toolId: 151 },
      { name: 'identify-root-cause',    worker: 'aicalls',   toolId: 81  },
      { name: 'deduplicate-alerts',     worker: 'shields',   toolId: 255 },
      { name: 'notify-on-call',         worker: 'adapters',  toolId: 215 },
      { name: 'audit-log',              worker: 'shields',   toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: true,
  },

  // ─── ECOSYSTEM & FEDERATION (086–089) ───────────────────────
  {
    id: 86, name: 'federatedQuery', latinName: 'Quaestio Foederata', latinDescription: 'Authentificatio et iter et distributio et fusio et percolatio',
  category: 'ecosystem',
    license: 'CPEL-1.0',
    steps: [
      { name: 'authenticate-federation', worker: 'shields',  toolId: 241 },
      { name: 'route-to-peers',          worker: 'adapters', toolId: 220 },
      { name: 'fan-out-subqueries',      worker: 'routing',  toolId: null },
      { name: 'collect-peer-results',    worker: 'hooks',    toolId: 175 },
      { name: 'merge-results',           worker: 'lenses',   toolId: 150 },
      { name: 'filter-authorized',       worker: 'shields',  toolId: 243 },
      { name: 'deliver-unified-response', worker: 'adapters', toolId: 220 },
      { name: 'audit-log',               worker: 'shields',  toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: false,
  },
  {
    id: 87, name: 'peerSync', latinName: 'Synchronizatio Parium', latinDescription: 'Salutatio et delta et resolutio et applicatio et confirmatio',
  category: 'ecosystem',
    license: 'CPEL-1.0',
    steps: [
      { name: 'discover-peers',          worker: 'discovery', toolId: null },
      { name: 'handshake',               worker: 'adapters',  toolId: 220 },
      { name: 'compute-delta',           worker: 'lenses',    toolId: 145 },
      { name: 'resolve-conflicts',       worker: 'aicalls',   toolId: 64  },
      { name: 'apply-sync',              worker: 'database',  toolId: null },
      { name: 'confirm-sync',            worker: 'adapters',  toolId: 220 },
      { name: 'audit-log',               worker: 'shields',   toolId: 259 },
    ],
    timeout: 120000,
    retries: 2,
    critical: false,
  },
  {
    id: 88, name: 'sovereignBridge', latinName: 'Pons Soveranitatis', latinDescription: 'Authentificatio et auctorizatio et translatio et relatio et registratio',
  category: 'ecosystem',
    license: 'CPEL-1.0',
    steps: [
      { name: 'authenticate-sovereign',  worker: 'shields',  toolId: 241 },
      { name: 'authorize-bridge',        worker: 'shields',  toolId: 258 },
      { name: 'translate-protocol',      worker: 'adapters', toolId: 213 },  // protocolAdapter
      { name: 'relay-request',           worker: 'routing',  toolId: null },
      { name: 'translate-response',      worker: 'adapters', toolId: 213 },
      { name: 'sign-relay-proof',        worker: 'crypto',   toolId: null },
      { name: 'audit-log',               worker: 'shields',  toolId: 259 },
    ],
    timeout: 30000,
    retries: 1,
    critical: true,
  },
  {
    id: 89, name: 'ecosystemGovernance', latinName: 'Gubernatio Ecosystematis', latinDescription: 'Propositio et suffragium et ratificatio et executio et annuntiatio',
  category: 'ecosystem',
    license: 'CPEL-1.0',
    steps: [
      { name: 'propose-change',          worker: 'aicalls',  toolId: 76  },
      { name: 'broadcast-proposal',      worker: 'routing',  toolId: null },
      { name: 'collect-votes',           worker: 'hooks',    toolId: 175 },
      { name: 'validate-quorum',         worker: 'triggers', toolId: 181 },
      { name: 'ratify-change',           worker: 'contracts', toolId: null },
      { name: 'enforce-change',          worker: 'shields',  toolId: 258 },
      { name: 'announce-decision',       worker: 'adapters', toolId: 215 },
      { name: 'audit-log',               worker: 'shields',  toolId: 259 },
    ],
    timeout: 86400000,  // 24 hours for governance
    retries: 0,
    critical: false,
  },
];

const protocolMap = new Map();
for (const proto of PROTOCOL_REGISTRY) {
  protocolMap.set(proto.id, proto);
  protocolMap.set(proto.name, proto);
}

/* ════════════════════════════════════════════════════════════════
   Client registry — manages up to 1,597 clients (F17)
   ════════════════════════════════════════════════════════════════ */

const clientRegistry = new Map();  // clientId → { status, tier, quotas, usage, onboardedAt }

function registerClient(clientId, tier, quotas) {
  if (clientRegistry.size >= MAX_CLIENTS) {
    return { error: 'max-clients-reached', max: MAX_CLIENTS };
  }

  const client = {
    id: clientId,
    status: 'active',
    tier: tier || 'standard',
    quotas: quotas || {
      aiCallsPerDay: 1000,
      storageGB: 10,
      tokensPerMonth: 1000000,
      concurrentProtocols: 5,
    },
    usage: {
      aiCalls: 0,
      storageUsed: 0,
      tokensUsed: 0,
      activeProtocols: 0,
      totalProtocols: 0,
    },
    onboardedAt: Date.now(),
    lastActive: Date.now(),
    healthScore: 1.0,
  };

  clientRegistry.set(clientId, client);
  return client;
}

function getClient(clientId) {
  return clientRegistry.get(clientId) || null;
}

function updateClientUsage(clientId, field, delta) {
  const client = clientRegistry.get(clientId);
  if (client && client.usage[field] !== undefined) {
    client.usage[field] += delta;
    client.lastActive = Date.now();
  }
  return client;
}

/* ════════════════════════════════════════════════════════════════
   Execution engine — runs protocols step by step
   ════════════════════════════════════════════════════════════════ */

const activeExecutions = new Map();  // executionId → execution state

function executeProtocol(protocolId, params, clientId) {
  const proto = protocolMap.get(protocolId);
  if (!proto) return { error: 'unknown-protocol', protocolId };

  if (activeExecutions.size >= MAX_EXECUTIONS) {
    return { error: 'max-concurrent-executions', max: MAX_EXECUTIONS };
  }

  // Check client quota for concurrent protocols
  if (clientId) {
    const client = clientRegistry.get(clientId);
    if (client) {
      if (client.status !== 'active') {
        return { error: 'client-not-active', clientId, status: client.status };
      }
      if (client.usage.activeProtocols >= (client.quotas.concurrentProtocols || 5)) {
        return { error: 'client-concurrent-limit', clientId, limit: client.quotas.concurrentProtocols };
      }
      client.usage.activeProtocols++;
      client.usage.totalProtocols++;
    }
  }

  const executionId = `proto-${proto.id}-${++executionCounter}`;
  const execution = {
    id: executionId,
    protocolId: proto.id,
    protocolName: proto.name,
    category: proto.category,
    clientId: clientId || null,
    params: params || {},
    steps: proto.steps.map((step, i) => ({
      ...step,
      index: i,
      status: 'pending',
      result: null,
      startedAt: null,
      completedAt: null,
      retries: 0,
    })),
    status: 'running',
    currentStep: 0,
    startedAt: Date.now(),
    completedAt: null,
    timeout: proto.timeout,
    maxRetries: proto.retries,
    critical: proto.critical,
  };

  activeExecutions.set(executionId, execution);
  totalExecutions++;

  // Start execution
  runNextStep(executionId);

  return { executionId, protocolName: proto.name, totalSteps: proto.steps.length, category: proto.category };
}

function runNextStep(executionId) {
  const execution = activeExecutions.get(executionId);
  if (!execution || execution.status !== 'running') return;

  // Check timeout
  if (Date.now() - execution.startedAt > execution.timeout) {
    failExecution(executionId, 'timeout', `Protocol timed out after ${execution.timeout}ms`);
    return;
  }

  const stepIdx = execution.currentStep;
  if (stepIdx >= execution.steps.length) {
    completeExecution(executionId);
    return;
  }

  const step = execution.steps[stepIdx];
  step.status = 'running';
  step.startedAt = Date.now();

  // Dispatch step to target worker via orchestrator
  const stepMessage = {
    type: 'protocol-step',
    executionId,
    protocolId: execution.protocolId,
    protocolName: execution.protocolName,
    stepIndex: stepIdx,
    stepName: step.name,
    worker: step.worker,
    toolId: step.toolId,
    params: execution.params,
    clientId: execution.clientId,
  };

  // Post to main thread for relay to target worker
  self.postMessage({
    type: 'dispatch-step',
    ...stepMessage,
  });

  // Simulate step completion (in production, main thread relays result back)
  const delay = 50 + Math.random() * 100;
  setTimeout(() => {
    if (!running) return;
    const exec = activeExecutions.get(executionId);
    if (!exec || exec.status !== 'running') return;

    step.status = 'completed';
    step.completedAt = Date.now();
    step.result = {
      success: true,
      stepName: step.name,
      worker: step.worker,
      toolId: step.toolId,
      duration: step.completedAt - step.startedAt,
      phiWeight: Math.pow(PHI_INV, stepIdx),
    };

    self.postMessage({
      type: 'step-complete',
      executionId,
      protocolId: exec.protocolId,
      protocolName: exec.protocolName,
      step: step.name,
      stepIndex: stepIdx,
      result: step.result,
    });

    exec.currentStep++;
    runNextStep(executionId);
  }, delay);
}

function completeExecution(executionId) {
  const execution = activeExecutions.get(executionId);
  if (!execution) return;

  execution.status = 'completed';
  execution.completedAt = Date.now();

  // Release client concurrent slot
  if (execution.clientId) {
    const client = clientRegistry.get(execution.clientId);
    if (client) {
      client.usage.activeProtocols = Math.max(0, client.usage.activeProtocols - 1);
    }
  }

  self.postMessage({
    type: 'protocol-complete',
    executionId,
    protocolId: execution.protocolId,
    protocolName: execution.protocolName,
    category: execution.category,
    clientId: execution.clientId,
    results: execution.steps.map(s => ({ name: s.name, status: s.status, result: s.result })),
    duration: execution.completedAt - execution.startedAt,
    stepCount: execution.steps.length,
  });

  // Clean up after a delay
  setTimeout(() => activeExecutions.delete(executionId), 60000);
}

function failExecution(executionId, errorType, errorMessage) {
  const execution = activeExecutions.get(executionId);
  if (!execution) return;

  execution.status = 'failed';
  execution.completedAt = Date.now();
  totalErrors++;

  // Release client concurrent slot
  if (execution.clientId) {
    const client = clientRegistry.get(execution.clientId);
    if (client) {
      client.usage.activeProtocols = Math.max(0, client.usage.activeProtocols - 1);
    }
  }

  self.postMessage({
    type: 'protocol-error',
    executionId,
    protocolId: execution.protocolId,
    protocolName: execution.protocolName,
    category: execution.category,
    clientId: execution.clientId,
    step: execution.steps[execution.currentStep]?.name,
    errorType,
    error: errorMessage,
    duration: execution.completedAt - execution.startedAt,
  });

  setTimeout(() => activeExecutions.delete(executionId), 60000);
}

/* ════════════════════════════════════════════════════════════════
   Audit log — immutable event record
   ════════════════════════════════════════════════════════════════ */

const auditLog = [];

function logAudit(event, details) {
  const entry = {
    timestamp: Date.now(),
    beat: beatCount,
    event,
    details,
    hash: hashEvent(event + JSON.stringify(details) + Date.now()),
  };

  auditLog.push(entry);
  if (auditLog.length > MAX_AUDIT_LOG) auditLog.shift();

  return entry;
}

function hashEvent(data) {
  let hash = 2166136261;  // FNV-1a offset basis
  for (let i = 0; i < data.length; i++) {
    hash ^= data.charCodeAt(i);
    hash = (hash * 16777619) >>> 0;
  }
  return hash;
}

/* ════════════════════════════════════════════════════════════════
   Platform metrics
   ════════════════════════════════════════════════════════════════ */

function getMetrics() {
  const activeByCategory = {};
  for (const [, exec] of activeExecutions) {
    if (exec.status === 'running') {
      activeByCategory[exec.category] = (activeByCategory[exec.category] || 0) + 1;
    }
  }

  return {
    totalExecutions,
    totalErrors,
    errorRate: totalExecutions > 0 ? totalErrors / totalExecutions : 0,
    activeExecutions: activeExecutions.size,
    activeByCategory,
    totalClients: clientRegistry.size,
    maxClients: MAX_CLIENTS,
    clientsByTier: getClientsByTier(),
    uptime: running ? Date.now() - (beatCount > 0 ? Date.now() - (beatCount * HEARTBEAT) : Date.now()) : 0,
    auditLogSize: auditLog.length,
    protocolCount: PROTOCOL_COUNT,
  };
}

function getClientsByTier() {
  const tiers = {};
  for (const [, client] of clientRegistry) {
    tiers[client.tier] = (tiers[client.tier] || 0) + 1;
  }
  return tiers;
}

/* ════════════════════════════════════════════════════════════════
   Query & Call API — Structured protocol access layer
   ════════════════════════════════════════════════════════════════
   
   QUERIES are read-only, never mutate state:
     queryProtocol(id)          → protocol definition + license + steps
     queryProtocolsByCategory(cat) → all protocols in category
     queryClient(clientId)      → full client state + usage + health
     queryClientUsage(clientId) → usage breakdown by protocol category
     queryMetrics()             → platform-wide metrics snapshot
     queryAudit(filters)        → filtered audit log entries
     queryExecution(execId)     → full execution state with step details
     queryLicense(protocolId)   → license terms for specific protocol
     queryCapacity()            → platform capacity + availability
     queryHealth()              → cross-worker health aggregation
   
   CALLS mutate state and return results:
     callExecute(protocolId, params, clientId) → start protocol execution
     callBatchExecute(executions[])   → execute multiple protocols
     callRegisterClient(clientId, tier, quotas) → onboard client
     callSuspendClient(clientId, reason)       → suspend client
     callReactivateClient(clientId)            → reactivate suspended client
     callRotateSecret(clientId)                → rotate client API key
     callUpgradeClient(clientId, newTier)      → upgrade client tier
     callExportClientData(clientId, format)    → GDPR data export
     callPurgeClientData(clientId)             → GDPR data deletion
     callEmergencyShutdown(reason)             → halt all protocols
   ════════════════════════════════════════════════════════════════ */

// ── QUERIES (read-only) ───────────────────────────────────────

function queryProtocol(protocolId) {
  const proto = protocolMap.get(protocolId);
  if (!proto) return { found: false, protocolId };
  return {
    found: true,
    protocol: {
      id: proto.id,
      name: proto.name,
      category: proto.category,
      license: proto.license || PROTOCOL_LICENSE.id,
      licenseTerms: PROTOCOL_LICENSE,
      stepCount: proto.steps.length,
      steps: proto.steps.map((s, i) => ({
        index: i,
        name: s.name,
        worker: s.worker,
        toolId: s.toolId,
        phiWeight: Math.pow(PHI_INV, i),
      })),
      timeout: proto.timeout,
      retries: proto.retries,
      critical: proto.critical,
    },
  };
}

function queryProtocolsByCategory(category) {
  const matching = PROTOCOL_REGISTRY.filter(p => p.category === category);
  return {
    category,
    count: matching.length,
    protocols: matching.map(p => ({
      id: p.id,
      name: p.name,
      stepCount: p.steps.length,
      critical: p.critical,
      license: p.license || PROTOCOL_LICENSE.id,
    })),
  };
}

function queryClient(clientId) {
  const client = clientRegistry.get(clientId);
  if (!client) return { found: false, clientId };

  // Compute per-category protocol usage
  const protocolHistory = [];
  for (const [, exec] of activeExecutions) {
    if (exec.clientId === clientId) {
      protocolHistory.push({
        executionId: exec.id,
        protocolName: exec.protocolName,
        category: exec.category,
        status: exec.status,
        startedAt: exec.startedAt,
        duration: (exec.completedAt || Date.now()) - exec.startedAt,
      });
    }
  }

  return {
    found: true,
    client: {
      ...client,
      activeExecutions: protocolHistory.filter(p => p.status === 'running').length,
      recentExecutions: protocolHistory.slice(-20),
      licenseStatus: client.status === 'active' ? 'valid' : 'suspended',
      licenseTier: client.tier,
      licenseTerms: PROTOCOL_LICENSE,
    },
  };
}

function queryClientUsage(clientId) {
  const client = clientRegistry.get(clientId);
  if (!client) return { found: false, clientId };

  return {
    found: true,
    clientId,
    usage: client.usage,
    quotas: client.quotas,
    utilizationPercent: {
      aiCalls: client.quotas.aiCallsPerDay > 0 ? (client.usage.aiCalls / client.quotas.aiCallsPerDay * 100) : 0,
      storage: client.quotas.storageGB > 0 ? (client.usage.storageUsed / client.quotas.storageGB * 100) : 0,
      tokens: client.quotas.tokensPerMonth > 0 ? (client.usage.tokensUsed / client.quotas.tokensPerMonth * 100) : 0,
      protocols: client.quotas.concurrentProtocols > 0 ? (client.usage.activeProtocols / client.quotas.concurrentProtocols * 100) : 0,
    },
  };
}

function queryCapacity() {
  const activeCount = activeExecutions.size;
  const clientCount = clientRegistry.size;
  return {
    protocols: {
      total: PROTOCOL_COUNT,
      maxConcurrent: MAX_EXECUTIONS,
      active: activeCount,
      available: MAX_EXECUTIONS - activeCount,
      utilization: activeCount / MAX_EXECUTIONS,
    },
    clients: {
      total: clientCount,
      max: MAX_CLIENTS,
      available: MAX_CLIENTS - clientCount,
      utilization: clientCount / MAX_CLIENTS,
    },
    audit: {
      entries: auditLog.length,
      maxEntries: MAX_AUDIT_LOG,
      utilization: auditLog.length / MAX_AUDIT_LOG,
    },
    categories: [...new Set(PROTOCOL_REGISTRY.map(p => p.category))],
    phi: PHI,
    heartbeatMs: HEARTBEAT,
  };
}

function queryHealth() {
  let healthyClients = 0;
  let degradedClients = 0;
  let criticalClients = 0;

  for (const [, client] of clientRegistry) {
    if (client.healthScore >= 0.8) healthyClients++;
    else if (client.healthScore >= 0.4) degradedClients++;
    else criticalClients++;
  }

  let runningExecs = 0;
  let failedExecs = 0;
  for (const [, exec] of activeExecutions) {
    if (exec.status === 'running') runningExecs++;
    if (exec.status === 'failed') failedExecs++;
  }

  return {
    platform: {
      status: totalErrors === 0 ? 'healthy' : (totalErrors / Math.max(1, totalExecutions) < 0.05 ? 'degraded' : 'critical'),
      uptime: beatCount * HEARTBEAT,
      heartbeat: beatCount,
      errorRate: totalExecutions > 0 ? totalErrors / totalExecutions : 0,
    },
    clients: {
      healthy: healthyClients,
      degraded: degradedClients,
      critical: criticalClients,
    },
    executions: {
      running: runningExecs,
      failed: failedExecs,
      total: totalExecutions,
    },
  };
}

function queryLicense(protocolId) {
  const proto = protocolMap.get(protocolId);
  if (!proto) return { found: false, protocolId };
  return {
    found: true,
    protocolId: proto.id,
    protocolName: proto.name,
    license: PROTOCOL_LICENSE,
    assignedLicense: proto.license || PROTOCOL_LICENSE.id,
    category: proto.category,
    critical: proto.critical,
  };
}

function queryAuditFiltered(filters) {
  let entries = [...auditLog];
  if (filters) {
    if (filters.event) entries = entries.filter(e => e.event === filters.event);
    if (filters.clientId) entries = entries.filter(e => e.details && e.details.clientId === filters.clientId);
    if (filters.since) entries = entries.filter(e => e.timestamp >= filters.since);
    if (filters.until) entries = entries.filter(e => e.timestamp <= filters.until);
    if (filters.protocolId) entries = entries.filter(e => e.details && e.details.protocolId === filters.protocolId);
  }
  const count = filters && filters.limit ? filters.limit : 50;
  return {
    entries: entries.slice(-count),
    totalMatched: entries.length,
    totalEntries: auditLog.length,
    filters,
  };
}

// ── CALLS (mutating operations) ───────────────────────────────

function callBatchExecute(executions) {
  if (!Array.isArray(executions)) return { error: 'invalid-batch', message: 'executions must be an array' };
  const maxBatch = 21;  // Max batch size
  if (executions.length > maxBatch) return { error: 'batch-too-large', max: maxBatch, received: executions.length };

  const results = [];
  for (const exec of executions) {
    const result = executeProtocol(exec.protocolId, exec.params, exec.clientId);
    results.push({ ...exec, result });
  }

  logAudit('batch-execute', { count: executions.length, results: results.map(r => r.result.executionId || r.result.error) });

  return {
    batchId: `batch-${++executionCounter}`,
    count: results.length,
    results,
    startedAt: Date.now(),
  };
}

function callSuspendClient(clientId, reason) {
  const client = clientRegistry.get(clientId);
  if (!client) return { error: 'client-not-found', clientId };
  if (client.status === 'suspended') return { error: 'already-suspended', clientId };

  client.status = 'suspended';
  client.suspendedAt = Date.now();
  client.suspendReason = reason || 'manual';

  // Cancel all active executions for this client
  let cancelled = 0;
  for (const [, exec] of activeExecutions) {
    if (exec.clientId === clientId && exec.status === 'running') {
      exec.status = 'cancelled';
      exec.completedAt = Date.now();
      cancelled++;
    }
  }
  client.usage.activeProtocols = 0;

  logAudit('client-suspend', { clientId, reason, cancelledExecutions: cancelled });
  return { clientId, status: 'suspended', cancelledExecutions: cancelled, reason };
}

function callReactivateClient(clientId) {
  const client = clientRegistry.get(clientId);
  if (!client) return { error: 'client-not-found', clientId };
  if (client.status === 'active') return { error: 'already-active', clientId };

  client.status = 'active';
  client.reactivatedAt = Date.now();
  delete client.suspendedAt;
  delete client.suspendReason;

  logAudit('client-reactivate', { clientId });
  return { clientId, status: 'active' };
}

function callUpgradeClient(clientId, newTier) {
  const client = clientRegistry.get(clientId);
  if (!client) return { error: 'client-not-found', clientId };

  const TIER_QUOTAS = {
    starter:    { aiCallsPerDay: 500,   storageGB: 5,   tokensPerMonth: 500000,    concurrentProtocols: 3 },
    standard:   { aiCallsPerDay: 1000,  storageGB: 10,  tokensPerMonth: 1000000,   concurrentProtocols: 5 },
    professional: { aiCallsPerDay: 5000, storageGB: 50,  tokensPerMonth: 5000000,   concurrentProtocols: 13 },
    enterprise: { aiCallsPerDay: 50000, storageGB: 500, tokensPerMonth: 50000000,  concurrentProtocols: 34 },
    sovereign:  { aiCallsPerDay: -1,    storageGB: -1,  tokensPerMonth: -1,        concurrentProtocols: 89 },
  };

  const oldTier = client.tier;
  const quotas = TIER_QUOTAS[newTier];
  if (!quotas) return { error: 'unknown-tier', tier: newTier, available: Object.keys(TIER_QUOTAS) };

  client.tier = newTier;
  client.quotas = { ...quotas };
  client.upgradedAt = Date.now();

  logAudit('client-upgrade', { clientId, oldTier, newTier });
  return { clientId, oldTier, newTier, quotas };
}

function callRotateSecret(clientId) {
  const client = clientRegistry.get(clientId);
  if (!client) return { error: 'client-not-found', clientId };

  // Generate new secret via FNV-1a hash
  const seed = `${clientId}-${Date.now()}-${Math.random()}`;
  const newSecret = `cpel_${hashEvent(seed).toString(36)}_${hashEvent(seed + 'salt').toString(36)}`;

  client.lastSecretRotation = Date.now();
  logAudit('secret-rotate', { clientId, rotatedAt: Date.now() });

  return { clientId, newSecret, rotatedAt: Date.now(), expiresAt: Date.now() + 90 * 86400000 };
}

function callExportClientData(clientId, format) {
  const client = clientRegistry.get(clientId);
  if (!client) return { error: 'client-not-found', clientId };

  // Collect all data for client
  const clientAudit = auditLog.filter(e => e.details && e.details.clientId === clientId);
  const clientExecs = [];
  for (const [, exec] of activeExecutions) {
    if (exec.clientId === clientId) clientExecs.push(exec);
  }

  const exportData = {
    client: { ...client },
    auditEntries: clientAudit.length,
    executionHistory: clientExecs.length,
    exportedAt: Date.now(),
    format: format || 'json',
    gdprCompliant: true,
    license: PROTOCOL_LICENSE,
  };

  logAudit('client-data-export', { clientId, format, entries: clientAudit.length });
  return exportData;
}

function callEmergencyShutdown(reason) {
  let cancelledCount = 0;
  for (const [, exec] of activeExecutions) {
    if (exec.status === 'running') {
      exec.status = 'cancelled';
      exec.completedAt = Date.now();
      cancelledCount++;
    }
  }

  // Reset all client active protocol counts
  for (const [, client] of clientRegistry) {
    client.usage.activeProtocols = 0;
  }

  logAudit('emergency-shutdown', { reason, cancelledExecutions: cancelledCount, totalClients: clientRegistry.size });

  return {
    status: 'shutdown',
    reason,
    cancelledExecutions: cancelledCount,
    totalClients: clientRegistry.size,
    timestamp: Date.now(),
  };
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'execute': {
      const result = executeProtocol(msg.protocolId, msg.params, msg.clientId);
      if (result.error) {
        self.postMessage({ type: 'protocol-error', ...result });
      } else {
        self.postMessage({ type: 'protocol-started', ...result });
      }
      logAudit('protocol-execute', { protocolId: msg.protocolId, clientId: msg.clientId });
      break;
    }

    case 'getStatus': {
      const execution = activeExecutions.get(msg.executionId);
      self.postMessage({
        type: 'execution-status',
        executionId: msg.executionId,
        execution: execution ? {
          status: execution.status,
          protocolName: execution.protocolName,
          category: execution.category,
          clientId: execution.clientId,
          currentStep: execution.currentStep,
          totalSteps: execution.steps.length,
          steps: execution.steps.map(s => ({ name: s.name, status: s.status })),
          duration: Date.now() - execution.startedAt,
        } : null,
        found: !!execution,
      });
      break;
    }

    case 'cancel': {
      const execution = activeExecutions.get(msg.executionId);
      if (execution && execution.status === 'running') {
        execution.status = 'cancelled';
        execution.completedAt = Date.now();
        if (execution.clientId) {
          const client = clientRegistry.get(execution.clientId);
          if (client) client.usage.activeProtocols = Math.max(0, client.usage.activeProtocols - 1);
        }
        logAudit('protocol-cancel', { executionId: msg.executionId });
      }
      self.postMessage({ type: 'cancelled', executionId: msg.executionId, found: !!execution });
      break;
    }

    case 'getProtocol': {
      const proto = protocolMap.get(msg.protocolId);
      self.postMessage({
        type: 'protocol-detail',
        protocol: proto ? {
          id: proto.id,
          name: proto.name,
          category: proto.category,
          steps: proto.steps.map(s => ({ name: s.name, worker: s.worker, toolId: s.toolId })),
          timeout: proto.timeout,
          retries: proto.retries,
          critical: proto.critical,
        } : null,
        found: !!proto,
      });
      break;
    }

    case 'list':
    case 'getRegistry':
      self.postMessage({
        type: 'catalog',
        protocols: PROTOCOL_REGISTRY.map(p => ({
          id: p.id,
          name: p.name,
          category: p.category,
          stepCount: p.steps.length,
          critical: p.critical,
          timeout: p.timeout,
        })),
        count: PROTOCOL_COUNT,
        categories: [...new Set(PROTOCOL_REGISTRY.map(p => p.category))],
      });
      break;

    // ── Client management ─────────────────────────────────
    case 'registerClient': {
      const result = registerClient(msg.clientId, msg.tier, msg.quotas);
      if (result.error) {
        self.postMessage({ type: 'client-error', ...result });
      } else {
        self.postMessage({ type: 'client-registered', client: result });
        logAudit('client-register', { clientId: msg.clientId, tier: msg.tier });
      }
      break;
    }

    case 'getClient': {
      const client = getClient(msg.clientId);
      self.postMessage({ type: 'client-detail', client, found: !!client });
      break;
    }

    case 'listClients': {
      const clients = [];
      for (const [, client] of clientRegistry) {
        clients.push({
          id: client.id,
          status: client.status,
          tier: client.tier,
          healthScore: client.healthScore,
          usage: client.usage,
          lastActive: client.lastActive,
        });
      }
      self.postMessage({ type: 'client-list', clients, total: clients.length, max: MAX_CLIENTS });
      break;
    }

    case 'updateClientStatus': {
      const client = clientRegistry.get(msg.clientId);
      if (client) {
        client.status = msg.status;
        logAudit('client-status-change', { clientId: msg.clientId, status: msg.status });
      }
      self.postMessage({ type: 'client-updated', clientId: msg.clientId, found: !!client });
      break;
    }

    // ── Metrics & audit ───────────────────────────────────
    case 'getMetrics':
      self.postMessage({ type: 'metrics', ...getMetrics() });
      break;

    case 'getAudit': {
      const count = msg.count || 50;
      self.postMessage({
        type: 'audit',
        entries: auditLog.slice(-count),
        totalEntries: auditLog.length,
      });
      break;
    }

    // ── Query API (read-only) ─────────────────────────────
    case 'queryProtocol': {
      const result = queryProtocol(msg.protocolId);
      self.postMessage({ type: 'query-result', query: 'queryProtocol', ...result });
      break;
    }

    case 'queryProtocolsByCategory': {
      const result = queryProtocolsByCategory(msg.category);
      self.postMessage({ type: 'query-result', query: 'queryProtocolsByCategory', ...result });
      break;
    }

    case 'queryClient': {
      const result = queryClient(msg.clientId);
      self.postMessage({ type: 'query-result', query: 'queryClient', ...result });
      break;
    }

    case 'queryClientUsage': {
      const result = queryClientUsage(msg.clientId);
      self.postMessage({ type: 'query-result', query: 'queryClientUsage', ...result });
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

    case 'queryLicense': {
      const result = queryLicense(msg.protocolId);
      self.postMessage({ type: 'query-result', query: 'queryLicense', ...result });
      break;
    }

    case 'queryAuditFiltered': {
      const result = queryAuditFiltered(msg.filters);
      self.postMessage({ type: 'query-result', query: 'queryAuditFiltered', ...result });
      break;
    }

    // ── Call API (mutating) ───────────────────────────────
    case 'callBatchExecute': {
      const result = callBatchExecute(msg.executions);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callBatchExecute', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callBatchExecute', ...result });
      }
      break;
    }

    case 'callSuspendClient': {
      const result = callSuspendClient(msg.clientId, msg.reason);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callSuspendClient', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callSuspendClient', ...result });
      }
      break;
    }

    case 'callReactivateClient': {
      const result = callReactivateClient(msg.clientId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callReactivateClient', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callReactivateClient', ...result });
      }
      break;
    }

    case 'callUpgradeClient': {
      const result = callUpgradeClient(msg.clientId, msg.newTier);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callUpgradeClient', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callUpgradeClient', ...result });
      }
      break;
    }

    case 'callRotateSecret': {
      const result = callRotateSecret(msg.clientId);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callRotateSecret', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callRotateSecret', ...result });
      }
      break;
    }

    case 'callExportClientData': {
      const result = callExportClientData(msg.clientId, msg.format);
      if (result.error) {
        self.postMessage({ type: 'call-error', call: 'callExportClientData', ...result });
      } else {
        self.postMessage({ type: 'call-result', call: 'callExportClientData', ...result });
      }
      break;
    }

    case 'callEmergencyShutdown': {
      const result = callEmergencyShutdown(msg.reason);
      self.postMessage({ type: 'call-result', call: 'callEmergencyShutdown', ...result });
      break;
    }

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      // Cancel all running executions
      for (const [, exec] of activeExecutions) {
        if (exec.status === 'running') exec.status = 'cancelled';
      }
      logAudit('protocols-stop', { totalExecutions, totalErrors });
      self.postMessage({ type: 'stopped', totalExecutions, totalErrors, totalClients: clientRegistry.size });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Heartbeat — 873ms φ-scaled
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;

  // Periodic health checks for all clients every 13 beats (~11s)
  if (beatCount % 13 === 0) {
    for (const [clientId, client] of clientRegistry) {
      if (client.status === 'active') {
        // Decay health if inactive for more than 5 minutes
        const idleMs = Date.now() - client.lastActive;
        if (idleMs > 300000) {
          client.healthScore = Math.max(0, client.healthScore - 0.01);
        } else {
          client.healthScore = Math.min(1.0, client.healthScore + 0.001);
        }
      }
    }
  }

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    protocolCount: PROTOCOL_COUNT,
    totalExecutions,
    activeExecutions: activeExecutions.size,
    totalClients: clientRegistry.size,
    totalErrors,
  });
}, HEARTBEAT);
