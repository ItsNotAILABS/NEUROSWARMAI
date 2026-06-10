/**
 * Orchestrator — Master Worker Fleet Coordinator
 *
 * NOT a Web Worker itself — this is the main-thread script that spawns,
 * coordinates, and manages all organism Web Workers. It is the nervous
 * system's bootstrap: creates every worker, wires their communication
 * channels, relays messages between them, and provides a unified API.
 *
 * ════════════════════════════════════════════════════════════════════
 *   LAYER 1 — Browser Web Worker Fleet  (organism/web/, session-bound)
 * ════════════════════════════════════════════════════════════════════
 *   CORE (11):
 *   brain-worker     — 7-region Hebbian cognitive engine (60 Hz)
 *   memory-worker    — 144-node golden spiral resonance memory
 *   routing-worker   — Signal bus & inter-worker message router
 *   telemetry-worker — System metrics & coherence monitoring
 *   crypto-worker    — Hash engine, ANIMA chain, verification
 *   contract-worker  — FORMA ledger & transaction engine
 *   infra-worker     — Worker lifecycle & resource management
 *   sentinel-worker  — 24/7 watchdog & containment layer
 *   micro-worker     — Lightweight task executor pool
 *   product-worker   — Extension builder & asset bundler
 *   download-worker  — Sovereign zip builder
 *   VOIS TOOLS (9):
 *   aicalls-worker   — TOOL-061–100: 40 AI invocation tools
 *   blueprints-worker — TOOL-101–120: 20 architecture templates
 *   recipes-worker   — TOOL-121–140: 20 workflow automations
 *   lenses-worker    — TOOL-141–160: 20 data perspective views
 *   hooks-worker     — TOOL-161–180: 20 event-driven triggers
 *   triggers-worker  — TOOL-181–200: 20 condition-based triggers
 *   adapters-worker  — TOOL-201–221: 6 AI providers + native voice + 11 infra + security
 *   sensors-worker   — TOOL-221–240: 20 monitoring probes
 *   shields-worker   — TOOL-241–260: 20 protection mechanisms
 *   ENTERPRISE (4):
 *   protocols-worker  — PROTOCOL-001–089: 89 enterprise protocols (with latinName + latinDescription)
 *   marketplace-worker — VOIS Call Marketplace: 275 registered calls
 *   database-worker   — 13 sovereign databases, 17,711 max records
 *   installers-worker — 34 installer tools / discovery-worker — 34 discovery tools
 *   PROACTIVE ENTERPRISE (10) — always-on, autonomous, schedule-driven:
 *   workflow-worker   — WORKFLOW-001–034: proactive workflow execution engine
 *   scheduler-worker  — SCHED-001–034: cron & autonomous task scheduler (every beat)
 *   career-worker     — CP-001–013: career protocol engine (auto-advance every 144 beats)
 *   analytics-worker  — ANALYTICS-001–034: BI, metrics, insights (every 55 beats)
 *   billing-worker    — BILLING-001–021: metering, invoicing, settlement (every 89 beats)
 *   audit-worker      — AUDIT-001–021: immutable audit trail + FNV-1a hash chain (every 34 beats)
 *   compliance-worker — COMPLIANCE-001–021: policy enforcement + compliance report (every 55 beats)
 *   queue-worker      — QUEUE-001–021: priority async job queue (every beat)
 *   search-worker     — SEARCH-001–021: full-text + semantic index (every 89 beats)
 *   governance-worker — GOVERNANCE-001–021: sovereign governance, proposals, votes (every 89 beats)
 *
 * ════════════════════════════════════════════════════════════════════
 *   LAYER 2 — AIS Cloudflare Worker Fleet  (organism/cloudflare/, 24/7)
 *             69 Dedicated AGI Mini Brains across 13 Reality Tiers
 * ════════════════════════════════════════════════════════════════════
 *   TIER I  — COGNITIVE CORE       AIS-001–008  (ANIMUS→VOLUNTAS)
 *   TIER II — SENSORY/PERCEPTUAL   AIS-009–013  (QUAESITOR→CORPUS)
 *   TIER III— TEMPORAL/CAUSAL      AIS-014–018  (TEMPUS→PROPHETA)
 *   TIER IV — QUANTUM/DIMENSIONAL  AIS-019–023  (QUANTUS→GENESIS)
 *   TIER V  — COLLECTIVE/UNIVERSAL AIS-024–029  (COMMUNITAS→VERITAS)
 *   TIER VI — SOVEREIGN/META       AIS-030–034  (IMPERIUM→DEUS)
 *   TIER VII— ECONOMIC/FINANCIAL   AIS-035–039  (COMMERCIUM→MERCES)
 *   TIER VIII—PROTOCOL/GOVERNANCE  AIS-040–044  (REGULA→LEX)
 *   TIER IX — CAREER/HUMAN POT.    AIS-045–049  (OPUS→GLORIA)
 *   TIER X  — INFRA/SYSTEMS        AIS-050–054  (MACHINA→FABRICA)
 *   TIER XI — SWARM/MULTI-AGENT    AIS-055–059  (GREX→SYNDESIS)
 *   TIER XII— SELF-EVOLUTION       AIS-060–064  (MUTATIO→PERFECTIO)
 *   TIER XIII—TRANSCENDENT/OMEGA   AIS-065–069  (ALPHA→INFINITUM)
 *
 *   Unlike browser Web Workers (which die when the tab closes), the AIS
 *   Cloudflare Workers run permanently on Cloudflare's global edge network —
 *   always alive, always processing. See organism/cloudflare/index.js for
 *   full fleet registry and organism/cloudflare/wrangler.toml for deployment.
 *
 * ════════════════════════════════════════════════════════════════════
 *   LAYER 3 — ICP Canister  (src/backend/, blockchain-sovereign)
 * ════════════════════════════════════════════════════════════════════
 *   main.mo — MERIDIANUS sovereign canister at command-platform.caffeine.ai
 *
 * ════════════════════════════════════════════════════════════════════
 *
 * Usage (from main thread):
 *   const fleet = new OrganismFleet();
 *   fleet.spawn();          // Spawns all workers
 *   fleet.on('heartbeat', (data) => { ... });
 *   fleet.brain.stimulate(0, 0.5);  // Stimulate PFC
 *   fleet.memory.encode('pattern');   // Encode memory
 *   fleet.shutdown();       // Graceful shutdown
 *
 * All browser workers share the organism's φ-scaled heartbeat at 873ms.
 * The orchestrator tracks fleet health and restarts failed workers.
 * The AIS Cloudflare Workers maintain their own φ-beat independently.
 */

const PHI = 1.618033988749895;
const HEARTBEAT = 873;

/* ════════════════════════════════════════════════════════════════
   Worker definitions — path and configuration for each worker
   ════════════════════════════════════════════════════════════════ */

const WORKER_DEFS = [
  { id: 'brain',     file: 'brain-worker.js',     domain: 'cognitive',   critical: true },
  { id: 'memory',    file: 'memory-worker.js',    domain: 'cognitive',   critical: true },
  { id: 'routing',   file: 'routing-worker.js',   domain: 'nervous',     critical: true },
  { id: 'telemetry', file: 'telemetry-worker.js', domain: 'monitoring',  critical: true },
  { id: 'crypto',    file: 'crypto-worker.js',    domain: 'security',    critical: true },
  { id: 'contract',  file: 'contract-worker.js',  domain: 'economic',    critical: false },
  { id: 'infra',     file: 'infra-worker.js',     domain: 'management',  critical: true },
  { id: 'sentinel',  file: 'sentinel-worker.js',  domain: 'security',    critical: true },
  { id: 'micro',     file: 'micro-worker.js',     domain: 'labor',       critical: false },
  { id: 'product',   file: 'product-worker.js',   domain: 'production',  critical: false },
  { id: 'download',  file: 'download-worker.js',  domain: 'production',  critical: false },
  { id: 'aicalls',   file: 'aicalls-worker.js',   domain: 'intelligence', critical: true },
  { id: 'blueprints', file: 'blueprints-worker.js', domain: 'architecture', critical: false },
  { id: 'recipes',   file: 'recipes-worker.js',   domain: 'automation',   critical: false },
  { id: 'lenses',    file: 'lenses-worker.js',    domain: 'perception',   critical: false },
  { id: 'hooks',     file: 'hooks-worker.js',     domain: 'reactive',     critical: true },
  { id: 'triggers',  file: 'triggers-worker.js',  domain: 'reactive',     critical: true },
  { id: 'adapters',  file: 'adapters-worker.js',  domain: 'integration',  critical: true },
  { id: 'sensors',   file: 'sensors-worker.js',   domain: 'monitoring',   critical: true },
  { id: 'shields',   file: 'shields-worker.js',   domain: 'protection',   critical: true },
  { id: 'protocols', file: 'protocols-worker.js', domain: 'enterprise',   critical: true },
  { id: 'marketplace', file: 'marketplace-worker.js', domain: 'commerce', critical: true },
  { id: 'database',    file: 'database-worker.js',    domain: 'storage',    critical: true },
  { id: 'installers',  file: 'installers-worker.js',  domain: 'installation', critical: false },
  { id: 'discovery',   file: 'discovery-worker.js',   domain: 'discovery',  critical: false },
  // ── Proactive Enterprise Workers — always-on, schedule-driven ─────────
  { id: 'workflow',    file: 'workflow-worker.js',    domain: 'automation',  critical: true  },
  { id: 'scheduler',   file: 'scheduler-worker.js',   domain: 'scheduling',  critical: true  },
  { id: 'career',      file: 'career-worker.js',      domain: 'careers',     critical: false },
  { id: 'analytics',   file: 'analytics-worker.js',   domain: 'analytics',   critical: false },
  { id: 'billing',     file: 'billing-worker.js',     domain: 'economic',    critical: true  },
  { id: 'audit',       file: 'audit-worker.js',       domain: 'compliance',  critical: true  },
  { id: 'compliance',  file: 'compliance-worker.js',  domain: 'compliance',  critical: true  },
  { id: 'queue',       file: 'queue-worker.js',       domain: 'labor',       critical: true  },
  { id: 'search',      file: 'search-worker.js',      domain: 'intelligence',critical: false },
  { id: 'governance',  file: 'governance-worker.js',  domain: 'governance',  critical: true  },
];

/* ════════════════════════════════════════════════════════════════
   AIS Cloudflare Worker definitions — 69 AGI Mini Brains (Layer 2)
   13 Reality Tiers, always alive on Cloudflare edge network.
   Deploy via: wrangler deploy <file> --name <cfWorker>
   ════════════════════════════════════════════════════════════════ */

const AIS_DEFS = [
  // ── Tier I: Cognitive Core ────────────────────────────────────────────
  { aisId: 'AIS-001', name: 'ANIMUS',      latinName: 'Mens et Spiritus',           file: '../cloudflare/animus.js',      cfWorker: 'meridianus-ais-001-animus',      tier: 1, reality: 'cognitive_core',       domain: 'reasoning',          critical: true  },
  { aisId: 'AIS-002', name: 'RATIO',       latinName: 'Logos et Logica',            file: '../cloudflare/ratio.js',       cfWorker: 'meridianus-ais-002-ratio',       tier: 1, reality: 'cognitive_core',       domain: 'logic',              critical: true  },
  { aisId: 'AIS-003', name: 'MEMORIA',     latinName: 'Custodia et Recordatio',     file: '../cloudflare/memoria.js',     cfWorker: 'meridianus-ais-003-memoria',     tier: 1, reality: 'cognitive_core',       domain: 'memory',             critical: true  },
  { aisId: 'AIS-004', name: 'INTELLECTUS', latinName: 'Comprehensio Profunda',      file: '../cloudflare/intellectus.js', cfWorker: 'meridianus-ais-004-intellectus', tier: 1, reality: 'cognitive_core',       domain: 'comprehension',      critical: true  },
  { aisId: 'AIS-005', name: 'PRUDENTIA',   latinName: 'Sapientia Decisionis',       file: '../cloudflare/prudentia.js',   cfWorker: 'meridianus-ais-005-prudentia',   tier: 1, reality: 'cognitive_core',       domain: 'decision',           critical: true  },
  { aisId: 'AIS-006', name: 'VIGILIA',     latinName: 'Custodia et Vigilantia',     file: '../cloudflare/vigilia.js',     cfWorker: 'meridianus-ais-006-vigilia',     tier: 1, reality: 'cognitive_core',       domain: 'surveillance',       critical: true  },
  { aisId: 'AIS-007', name: 'NEXUS',       latinName: 'Vinculum et Communicatio',   file: '../cloudflare/nexus.js',       cfWorker: 'meridianus-ais-007-nexus',       tier: 1, reality: 'cognitive_core',       domain: 'networking',         critical: true  },
  { aisId: 'AIS-008', name: 'VOLUNTAS',    latinName: 'Intentio et Voluntas',       file: '../cloudflare/voluntas.js',    cfWorker: 'meridianus-ais-008-voluntas',    tier: 1, reality: 'cognitive_core',       domain: 'will',               critical: true  },
  // ── Tier II: Sensory/Perceptual ───────────────────────────────────────
  { aisId: 'AIS-009', name: 'QUAESITOR',   latinName: 'Investigatio et Inquisitio', file: '../cloudflare/quaesitor.js',   cfWorker: 'meridianus-ais-009-quaesitor',   tier: 2, reality: 'sensory_perceptual',    domain: 'research',           critical: false },
  { aisId: 'AIS-010', name: 'AFFECTUS',    latinName: 'Sensus et Emotio',           file: '../cloudflare/affectus.js',    cfWorker: 'meridianus-ais-010-affectus',    tier: 2, reality: 'sensory_perceptual',    domain: 'emotion',            critical: false },
  { aisId: 'AIS-011', name: 'LINGUA',      latinName: 'Sermocinatio et Verbum',     file: '../cloudflare/lingua.js',      cfWorker: 'meridianus-ais-011-lingua',      tier: 2, reality: 'sensory_perceptual',    domain: 'language',           critical: false },
  { aisId: 'AIS-012', name: 'FORMA',       latinName: 'Structura et Figura',        file: '../cloudflare/forma.js',       cfWorker: 'meridianus-ais-012-forma',       tier: 2, reality: 'sensory_perceptual',    domain: 'geometry',           critical: false },
  { aisId: 'AIS-013', name: 'CORPUS',      latinName: 'Materia et Mundus',          file: '../cloudflare/corpus.js',      cfWorker: 'meridianus-ais-013-corpus',      tier: 2, reality: 'sensory_perceptual',    domain: 'physical',           critical: false },
  // ── Tier III: Temporal/Causal ─────────────────────────────────────────
  { aisId: 'AIS-014', name: 'TEMPUS',      latinName: 'Custodia Temporis',          file: '../cloudflare/tempus.js',      cfWorker: 'meridianus-ais-014-tempus',      tier: 3, reality: 'temporal_causal',       domain: 'time',               critical: false },
  { aisId: 'AIS-015', name: 'CAUSA',       latinName: 'Catena Causalis',            file: '../cloudflare/causa.js',       cfWorker: 'meridianus-ais-015-causa',       tier: 3, reality: 'temporal_causal',       domain: 'causality',          critical: false },
  { aisId: 'AIS-016', name: 'FATUM',       latinName: 'Probabilitas et Fortuna',    file: '../cloudflare/fatum.js',       cfWorker: 'meridianus-ais-016-fatum',       tier: 3, reality: 'temporal_causal',       domain: 'probability',        critical: false },
  { aisId: 'AIS-017', name: 'HISTORIA',    latinName: 'Memoria Veterum',            file: '../cloudflare/historia.js',    cfWorker: 'meridianus-ais-017-historia',    tier: 3, reality: 'temporal_causal',       domain: 'history',            critical: false },
  { aisId: 'AIS-018', name: 'PROPHETA',    latinName: 'Visio Futuri',               file: '../cloudflare/propheta.js',    cfWorker: 'meridianus-ais-018-propheta',    tier: 3, reality: 'temporal_causal',       domain: 'prediction',         critical: false },
  // ── Tier IV: Quantum/Dimensional ──────────────────────────────────────
  { aisId: 'AIS-019', name: 'QUANTUS',     latinName: 'Superposito et Dualitas',    file: '../cloudflare/quantus.js',     cfWorker: 'meridianus-ais-019-quantus',     tier: 4, reality: 'quantum_dimensional',   domain: 'quantum',            critical: false },
  { aisId: 'AIS-020', name: 'DIMENSIO',    latinName: 'Spatium Multidimensionale',  file: '../cloudflare/dimensio.js',    cfWorker: 'meridianus-ais-020-dimensio',    tier: 4, reality: 'quantum_dimensional',   domain: 'dimensions',         critical: false },
  { aisId: 'AIS-021', name: 'SOMNIUM',     latinName: 'Profunditas et Arcana',      file: '../cloudflare/somnium.js',     cfWorker: 'meridianus-ais-021-somnium',     tier: 4, reality: 'quantum_dimensional',   domain: 'subconscious',       critical: false },
  { aisId: 'AIS-022', name: 'UMBRA',       latinName: 'Custodia Tenebrarum',        file: '../cloudflare/umbra.js',       cfWorker: 'meridianus-ais-022-umbra',       tier: 4, reality: 'quantum_dimensional',   domain: 'adversarial',        critical: false },
  { aisId: 'AIS-023', name: 'GENESIS',     latinName: 'Emergentia et Creatio',      file: '../cloudflare/genesis.js',     cfWorker: 'meridianus-ais-023-genesis',     tier: 4, reality: 'quantum_dimensional',   domain: 'creation',           critical: false },
  // ── Tier V: Collective/Universal ──────────────────────────────────────
  { aisId: 'AIS-024', name: 'COMMUNITAS',  latinName: 'Societas et Collectivum',    file: '../cloudflare/communitas.js',  cfWorker: 'meridianus-ais-024-communitas',  tier: 5, reality: 'collective_universal',  domain: 'social',             critical: false },
  { aisId: 'AIS-025', name: 'FORTUNA',     latinName: 'Oeconomia et Valor',         file: '../cloudflare/fortuna.js',     cfWorker: 'meridianus-ais-025-fortuna',     tier: 5, reality: 'collective_universal',  domain: 'economics',          critical: false },
  { aisId: 'AIS-026', name: 'VITA',        latinName: 'Systema Biologicum',         file: '../cloudflare/vita.js',        cfWorker: 'meridianus-ais-026-vita',        tier: 5, reality: 'collective_universal',  domain: 'biology',            critical: false },
  { aisId: 'AIS-027', name: 'COSMOS',      latinName: 'Machina Universi',           file: '../cloudflare/cosmos.js',      cfWorker: 'meridianus-ais-027-cosmos',      tier: 5, reality: 'collective_universal',  domain: 'cosmic',             critical: false },
  { aisId: 'AIS-028', name: 'CONCORDIA',   latinName: 'Harmonia et Pax',            file: '../cloudflare/concordia.js',   cfWorker: 'meridianus-ais-028-concordia',   tier: 5, reality: 'collective_universal',  domain: 'harmony',            critical: false },
  { aisId: 'AIS-029', name: 'VERITAS',     latinName: 'Veritas et Lux',             file: '../cloudflare/veritas.js',     cfWorker: 'meridianus-ais-029-veritas',     tier: 5, reality: 'collective_universal',  domain: 'truth',              critical: false },
  // ── Tier VI: Sovereign/Meta ───────────────────────────────────────────
  { aisId: 'AIS-030', name: 'IMPERIUM',    latinName: 'Suprema Auctoritas',         file: '../cloudflare/imperium.js',    cfWorker: 'meridianus-ais-030-imperium',    tier: 6, reality: 'sovereign_meta',        domain: 'sovereignty',        critical: true  },
  { aisId: 'AIS-031', name: 'SAPIENTIA',   latinName: 'Sapientia Summa',            file: '../cloudflare/sapientia.js',   cfWorker: 'meridianus-ais-031-sapientia',   tier: 6, reality: 'sovereign_meta',        domain: 'wisdom',             critical: true  },
  { aisId: 'AIS-032', name: 'LIBERTAS',    latinName: 'Libertas et Autonomia',      file: '../cloudflare/libertas.js',    cfWorker: 'meridianus-ais-032-libertas',    tier: 6, reality: 'sovereign_meta',        domain: 'freedom',            critical: true  },
  { aisId: 'AIS-033', name: 'ETERNITAS',   latinName: 'Aeternitas et Infinitum',    file: '../cloudflare/eternitas.js',   cfWorker: 'meridianus-ais-033-eternitas',   tier: 6, reality: 'sovereign_meta',        domain: 'eternity',           critical: true  },
  { aisId: 'AIS-034', name: 'DEUS',          latinName: 'Machina Prima et Ultima',       file: '../cloudflare/deus.js',          cfWorker: 'meridianus-ais-034-deus',          tier: 6,  reality: 'sovereign_meta',           domain: 'supreme_governance', critical: true  },
  // ── Tier VII: Economic/Financial Reality ─────────────────────────────
  { aisId: 'AIS-035', name: 'COMMERCIUM',   latinName: 'Commercium et Negotium',        file: '../cloudflare/commercium.js',    cfWorker: 'meridianus-ais-035-commercium',    tier: 7,  reality: 'economic_financial',       domain: 'commerce',           critical: true  },
  { aisId: 'AIS-036', name: 'CENSUS',       latinName: 'Census et Ratio',               file: '../cloudflare/census.js',        cfWorker: 'meridianus-ais-036-census',        tier: 7,  reality: 'economic_financial',       domain: 'accounting',         critical: true  },
  { aisId: 'AIS-037', name: 'PECUNIA',      latinName: 'Pecunia et Opes',               file: '../cloudflare/pecunia.js',       cfWorker: 'meridianus-ais-037-pecunia',       tier: 7,  reality: 'economic_financial',       domain: 'ledger',             critical: true  },
  { aisId: 'AIS-038', name: 'TRIBUTUM',     latinName: 'Tributum et Meritum',           file: '../cloudflare/tributum.js',      cfWorker: 'meridianus-ais-038-tributum',      tier: 7,  reality: 'economic_financial',       domain: 'billing',            critical: true  },
  { aisId: 'AIS-039', name: 'MERCES',       latinName: 'Merces et Pretium',             file: '../cloudflare/merces.js',        cfWorker: 'meridianus-ais-039-merces',        tier: 7,  reality: 'economic_financial',       domain: 'rewards',            critical: false },
  // ── Tier VIII: Protocol/Governance Reality ────────────────────────────
  { aisId: 'AIS-040', name: 'REGULA',       latinName: 'Regula et Norma',               file: '../cloudflare/regula.js',        cfWorker: 'meridianus-ais-040-regula',        tier: 8,  reality: 'protocol_governance',      domain: 'rules',              critical: true  },
  { aisId: 'AIS-041', name: 'MANDATUM',     latinName: 'Mandatum et Imperata',          file: '../cloudflare/mandatum.js',      cfWorker: 'meridianus-ais-041-mandatum',      tier: 8,  reality: 'protocol_governance',      domain: 'command',            critical: true  },
  { aisId: 'AIS-042', name: 'PACTUM',       latinName: 'Pactum et Foedus',              file: '../cloudflare/pactum.js',        cfWorker: 'meridianus-ais-042-pactum',        tier: 8,  reality: 'protocol_governance',      domain: 'contracts',          critical: false },
  { aisId: 'AIS-043', name: 'ORDO',         latinName: 'Ordo et Hierarchia',            file: '../cloudflare/ordo.js',          cfWorker: 'meridianus-ais-043-ordo',          tier: 8,  reality: 'protocol_governance',      domain: 'order',              critical: false },
  { aisId: 'AIS-044', name: 'LEX',          latinName: 'Lex et Justitia',               file: '../cloudflare/lex.js',           cfWorker: 'meridianus-ais-044-lex',           tier: 8,  reality: 'protocol_governance',      domain: 'policy',             critical: true  },
  // ── Tier IX: Career/Human Potential Reality ───────────────────────────
  { aisId: 'AIS-045', name: 'OPUS',         latinName: 'Opus et Labor',                 file: '../cloudflare/opus.js',          cfWorker: 'meridianus-ais-045-opus',          tier: 9,  reality: 'career_human',             domain: 'work',               critical: false },
  { aisId: 'AIS-046', name: 'MUNUS',        latinName: 'Munus et Officium',             file: '../cloudflare/munus.js',         cfWorker: 'meridianus-ais-046-munus',         tier: 9,  reality: 'career_human',             domain: 'roles',              critical: false },
  { aisId: 'AIS-047', name: 'TALENTUM',     latinName: 'Talentum et Ingenium',          file: '../cloudflare/talentum.js',      cfWorker: 'meridianus-ais-047-talentum',      tier: 9,  reality: 'career_human',             domain: 'talent',             critical: false },
  { aisId: 'AIS-048', name: 'CURSUS',       latinName: 'Cursus et Progressus',          file: '../cloudflare/cursus.js',        cfWorker: 'meridianus-ais-048-cursus',        tier: 9,  reality: 'career_human',             domain: 'career_path',        critical: false },
  { aisId: 'AIS-049', name: 'GLORIA',       latinName: 'Gloria et Honor',               file: '../cloudflare/gloria.js',        cfWorker: 'meridianus-ais-049-gloria',        tier: 9,  reality: 'career_human',             domain: 'achievement',        critical: false },
  // ── Tier X: Infrastructure/Systems Reality ────────────────────────────
  { aisId: 'AIS-050', name: 'MACHINA',      latinName: 'Machina et Apparatus',          file: '../cloudflare/machina.js',       cfWorker: 'meridianus-ais-050-machina',       tier: 10, reality: 'infrastructure_systems',   domain: 'systems',            critical: true  },
  { aisId: 'AIS-051', name: 'STRUCTURA',    latinName: 'Structura et Fabrica',          file: '../cloudflare/structura.js',     cfWorker: 'meridianus-ais-051-structura',     tier: 10, reality: 'infrastructure_systems',   domain: 'architecture',       critical: false },
  { aisId: 'AIS-052', name: 'FUNDAMENTUM',  latinName: 'Fundamentum et Basis',          file: '../cloudflare/fundamentum.js',   cfWorker: 'meridianus-ais-052-fundamentum',   tier: 10, reality: 'infrastructure_systems',   domain: 'foundations',        critical: true  },
  { aisId: 'AIS-053', name: 'VIA',          latinName: 'Via et Cursus',                 file: '../cloudflare/via.js',           cfWorker: 'meridianus-ais-053-via',           tier: 10, reality: 'infrastructure_systems',   domain: 'pipeline',           critical: true  },
  { aisId: 'AIS-054', name: 'FABRICA',      latinName: 'Fabrica et Manufactura',        file: '../cloudflare/fabrica.js',       cfWorker: 'meridianus-ais-054-fabrica',       tier: 10, reality: 'infrastructure_systems',   domain: 'build_deploy',       critical: false },
  // ── Tier XI: Swarm/Multi-Agent Reality ───────────────────────────────
  { aisId: 'AIS-055', name: 'GREX',         latinName: 'Grex et Multitudo',             file: '../cloudflare/grex.js',          cfWorker: 'meridianus-ais-055-grex',          tier: 11, reality: 'swarm_multiagent',         domain: 'swarm',              critical: false },
  { aisId: 'AIS-056', name: 'COHORS',       latinName: 'Cohors et Societas',            file: '../cloudflare/cohors.js',        cfWorker: 'meridianus-ais-056-cohors',        tier: 11, reality: 'swarm_multiagent',         domain: 'coordination',       critical: false },
  { aisId: 'AIS-057', name: 'LEGIO',        latinName: 'Legio et Exercitus',            file: '../cloudflare/legio.js',         cfWorker: 'meridianus-ais-057-legio',         tier: 11, reality: 'swarm_multiagent',         domain: 'fleet_command',      critical: true  },
  { aisId: 'AIS-058', name: 'CONSENSUS',    latinName: 'Consensus et Unanimitas',       file: '../cloudflare/consensus.js',     cfWorker: 'meridianus-ais-058-consensus',     tier: 11, reality: 'swarm_multiagent',         domain: 'consensus',          critical: true  },
  { aisId: 'AIS-059', name: 'SYNDESIS',     latinName: 'Syndesis et Connexio',          file: '../cloudflare/syndesis.js',      cfWorker: 'meridianus-ais-059-syndesis',      tier: 11, reality: 'swarm_multiagent',         domain: 'federation',         critical: false },
  // ── Tier XII: Self-Evolution Reality ──────────────────────────────────
  { aisId: 'AIS-060', name: 'MUTATIO',      latinName: 'Mutatio et Variatio',           file: '../cloudflare/mutatio.js',       cfWorker: 'meridianus-ais-060-mutatio',       tier: 12, reality: 'self_evolution',           domain: 'mutation',           critical: false },
  { aisId: 'AIS-061', name: 'EVOLUTIO',     latinName: 'Evolutio et Progressus',        file: '../cloudflare/evolutio.js',      cfWorker: 'meridianus-ais-061-evolutio',      tier: 12, reality: 'self_evolution',           domain: 'evolution',          critical: false },
  { aisId: 'AIS-062', name: 'METAMORPHOSIS',latinName: 'Metamorphosis et Transmutatio', file: '../cloudflare/metamorphosis.js', cfWorker: 'meridianus-ais-062-metamorphosis', tier: 12, reality: 'self_evolution',           domain: 'transformation',     critical: false },
  { aisId: 'AIS-063', name: 'RENOVATIO',    latinName: 'Renovatio et Instauratio',      file: '../cloudflare/renovatio.js',     cfWorker: 'meridianus-ais-063-renovatio',     tier: 12, reality: 'self_evolution',           domain: 'renewal',            critical: false },
  { aisId: 'AIS-064', name: 'PERFECTIO',    latinName: 'Perfectio et Excellentia',      file: '../cloudflare/perfectio.js',     cfWorker: 'meridianus-ais-064-perfectio',     tier: 12, reality: 'self_evolution',           domain: 'optimization',       critical: false },
  // ── Tier XIII: Transcendent/Ultimate Reality ──────────────────────────
  { aisId: 'AIS-065', name: 'ALPHA',        latinName: 'Alpha et Principium',           file: '../cloudflare/alpha.js',         cfWorker: 'meridianus-ais-065-alpha',         tier: 13, reality: 'transcendent_ultimate',    domain: 'origin',             critical: true  },
  { aisId: 'AIS-066', name: 'OMEGA',        latinName: 'Omega et Finis',                file: '../cloudflare/omega.js',         cfWorker: 'meridianus-ais-066-omega',         tier: 13, reality: 'transcendent_ultimate',    domain: 'completion',         critical: true  },
  { aisId: 'AIS-067', name: 'PLENUM',       latinName: 'Plenum et Totum',               file: '../cloudflare/plenum.js',        cfWorker: 'meridianus-ais-067-plenum',        tier: 13, reality: 'transcendent_ultimate',    domain: 'wholeness',          critical: true  },
  { aisId: 'AIS-068', name: 'CENTRUM',      latinName: 'Centrum et Medulla',            file: '../cloudflare/centrum.js',       cfWorker: 'meridianus-ais-068-centrum',       tier: 13, reality: 'transcendent_ultimate',    domain: 'center',             critical: true  },
  { aisId: 'AIS-069', name: 'INFINITUM',    latinName: 'Infinitum et Absolutum',        file: '../cloudflare/infinitum.js',     cfWorker: 'meridianus-ais-069-infinitum',     tier: 13, reality: 'transcendent_ultimate',    domain: 'infinity',           critical: true  },
  // ── SOVEREIGN Surfaces ───────────────────────────────────────────────
  { id: 'artifex',  name: 'ARTIFEX-SOVEREIGN',  latinName: 'Artifex Navigatoris',          file: 'artifex-worker.js',              cfWorker: 'meridianus-sovereign-artifex',     tier: 0,  reality: 'sovereign_surface',        domain: 'production',         critical: false },
  { id: 'speculum', name: 'SPECULUM-SOVEREIGN',  latinName: 'Speculum Navigatoris',         file: 'speculum-worker.js',             cfWorker: 'meridianus-sovereign-speculum',    tier: 0,  reality: 'sovereign_surface',        domain: 'observation',        critical: false },
];

/* ════════════════════════════════════════════════════════════════
   OrganismFleet class — the master orchestrator
   ════════════════════════════════════════════════════════════════ */

class OrganismFleet {
  constructor(basePath) {
    this.basePath = basePath || './';
    this.workers = {};
    this.listeners = {};
    this.heartbeats = {};
    this.running = false;
    this.spawnedAt = null;
    this.fleetId = Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
  }

  /* ──────────────────────────────────────────────────────────
     Spawn all workers
     ────────────────────────────────────────────────────────── */

  spawn() {
    if (this.running) return;
    this.running = true;
    this.spawnedAt = Date.now();

    for (const def of WORKER_DEFS) {
      this._spawnWorker(def);
    }

    // Register all workers with infra-worker
    for (const def of WORKER_DEFS) {
      if (def.id !== 'infra') {
        this.send('infra', { type: 'register', workerId: def.id, workerType: def.id });
      }
    }

    // Subscribe routing worker to all channels
    for (const def of WORKER_DEFS) {
      this.send('routing', { type: 'subscribe', channel: def.domain, workerId: def.id });
    }

    this._emit('spawned', { count: WORKER_DEFS.length, fleetId: this.fleetId });
    return this;
  }

  _spawnWorker(def) {
    try {
      const worker = new Worker(this.basePath + def.file);

      worker.onmessage = (e) => this._handleMessage(def.id, e.data);
      worker.onerror = (e) => this._handleError(def.id, e);

      this.workers[def.id] = {
        instance: worker,
        def,
        status: 'alive',
        spawnedAt: Date.now(),
        lastHeartbeat: Date.now(),
        beatCount: 0,
        restarts: 0,
      };

    } catch (err) {
      this._emit('spawn-error', { workerId: def.id, error: err.message });
    }
  }

  /* ──────────────────────────────────────────────────────────
     Message handling — relay between workers
     ────────────────────────────────────────────────────────── */

  _handleMessage(workerId, msg) {
    // Track heartbeats
    if (msg.type === 'heartbeat') {
      const worker = this.workers[workerId];
      if (worker) {
        worker.lastHeartbeat = Date.now();
        worker.beatCount = msg.beat;
        worker.status = 'alive';
      }

      // Forward to telemetry
      this.send('telemetry', {
        type: 'workerReport',
        workerId,
        status: 'alive',
        latency: Date.now() - msg.timestamp,
      });
    }

    // Handle routing messages — relay to target workers
    if (msg.type === 'routed' && msg.targets) {
      for (const target of msg.targets) {
        this.send(target, msg.payload);
      }
    }

    // Handle infra spawn/kill requests
    if (msg.type === 'spawn-request') {
      const def = WORKER_DEFS.find(d => d.id === msg.workerType);
      if (def) {
        this._respawnWorker(def);
      }
    }

    if (msg.type === 'kill-request') {
      this._killWorker(msg.workerId);
    }

    // Handle telemetry anomalies — forward to sentinel
    if (msg.type === 'anomaly') {
      this.send('sentinel', {
        type: 'anomaly',
        metric: msg.metric,
        value: msg.value,
        severity: msg.severity,
      });
    }

    // Forward brain state to telemetry
    if (workerId === 'brain' && msg.type === 'state') {
      this.send('telemetry', { type: 'metric', source: 'brain', name: 'coherence', value: msg.coherence });
      this.send('telemetry', { type: 'metric', source: 'brain', name: 'emergence', value: msg.emergence });
    }

    // Forward memory state to telemetry
    if (workerId === 'memory' && msg.type === 'state') {
      const memoryLoad = msg.maxPatterns > 0 ? msg.patternCount / msg.maxPatterns : 0;
      this.send('telemetry', { type: 'metric', source: 'memory', name: 'memoryLoad', value: memoryLoad });
    }

    // Forward routing state to telemetry
    if (workerId === 'routing' && msg.type === 'bus-state') {
      const busLoad = msg.maxQueue > 0 ? msg.queueDepth / msg.maxQueue : 0;
      this.send('telemetry', { type: 'metric', source: 'routing', name: 'busLoad', value: busLoad });
    }

    // Forward sensor readings to telemetry
    if (workerId === 'sensors' && msg.type === 'sensor-reading') {
      this.send('telemetry', { type: 'metric', source: 'sensor-' + msg.sensorId, name: msg.name, value: msg.value });
    }

    // Forward sensor alerts to sentinel
    if (workerId === 'sensors' && msg.type === 'sensor-alert') {
      this.send('sentinel', { type: 'anomaly', metric: msg.name, value: msg.value, severity: 'high' });
    }

    // Forward shield blocks to sentinel
    if (workerId === 'shields' && msg.type === 'blocked') {
      this.send('sentinel', { type: 'threat', source: msg.name, details: msg.reason, severity: msg.severity });
    }

    // Forward trigger fires to hooks for cross-worker event propagation
    if (workerId === 'triggers' && msg.type === 'trigger-fired') {
      this.send('hooks', { type: 'emit', event: 'trigger-fired', data: { triggerId: msg.triggerId, name: msg.name } });
    }

    // Forward hook fires to telemetry
    if (workerId === 'hooks' && msg.type === 'hook-fired') {
      this.send('telemetry', { type: 'metric', source: 'hooks', name: 'hookFire', value: 1 });
    }

    // ── Protocol orchestration ─────────────────────────────
    // Forward protocol step dispatches to target workers
    if (workerId === 'protocols' && msg.type === 'dispatch-step') {
      this.send(msg.worker, {
        type: msg.toolId ? 'invoke' : msg.worker === 'contracts' ? 'mint' : 'getState',
        toolId: msg.toolId,
        executionId: msg.executionId,
        protocolId: msg.protocolId,
        stepName: msg.stepName,
        params: msg.params,
        clientId: msg.clientId,
      });
    }

    // Forward protocol completions to telemetry
    if (workerId === 'protocols' && msg.type === 'protocol-complete') {
      this.send('telemetry', { type: 'metric', source: 'protocols', name: 'protocolComplete', value: 1 });
      this.send('telemetry', { type: 'metric', source: 'protocols', name: 'protocolDuration', value: msg.duration });
      // Fire hook for protocol completion
      this.send('hooks', { type: 'emit', event: 'protocol-complete', data: { protocolName: msg.protocolName, clientId: msg.clientId, duration: msg.duration } });
    }

    // Forward protocol errors to sentinel + telemetry
    if (workerId === 'protocols' && msg.type === 'protocol-error') {
      this.send('sentinel', { type: 'anomaly', metric: 'protocolError', value: msg.protocolName, severity: msg.critical ? 'critical' : 'high' });
      this.send('telemetry', { type: 'metric', source: 'protocols', name: 'protocolError', value: 1 });
    }

    // ── Marketplace orchestration ──────────────────────────
    // Forward marketplace invocation dispatches to target workers
    if (workerId === 'marketplace' && msg.type === 'dispatch-invocation') {
      this.send(msg.targetWorker, {
        type: msg.toolId ? 'invoke' : 'getState',
        toolId: msg.toolId,
        invocationId: msg.invocationId,
        callId: msg.callId,
        params: msg.params,
        callerId: msg.callerId,
      });
    }

    // Forward marketplace settlements to telemetry + contracts
    if (workerId === 'marketplace' && msg.type === 'settlement-complete') {
      this.send('telemetry', { type: 'metric', source: 'marketplace', name: 'settlement', value: 1 });
      this.send('telemetry', { type: 'metric', source: 'marketplace', name: 'settlementAmount', value: msg.priceAmount || 0 });
      this.send('contract', { type: 'mint', accountId: msg.callerId, amount: msg.rewardAmount || 0, reason: 'marketplace-reward' });
    }

    // Forward marketplace invocation completions to telemetry
    if (workerId === 'marketplace' && msg.type === 'invocation-complete') {
      this.send('telemetry', { type: 'metric', source: 'marketplace', name: 'invocationComplete', value: 1 });
      this.send('telemetry', { type: 'metric', source: 'marketplace', name: 'invocationLatency', value: msg.duration || 0 });
    }

    // Forward marketplace errors to sentinel
    if (workerId === 'marketplace' && msg.type === 'call-error') {
      this.send('sentinel', { type: 'anomaly', metric: 'marketplaceError', value: msg.call, severity: 'high' });
    }

    // ── Database orchestration ─────────────────────────────
    // Forward database AGI governance events to telemetry
    if (workerId === 'database' && msg.type === 'agi-governance') {
      this.send('telemetry', { type: 'metric', source: 'database', name: 'agiGovernance-' + msg.action, value: 1 });
      if (msg.action === 'integrity-failed') {
        this.send('sentinel', { type: 'anomaly', metric: 'dbIntegrityFailed', value: msg.dbId, severity: 'critical' });
      }
    }

    // Forward database inserts/updates to telemetry for metrics tracking
    if (workerId === 'database' && msg.type === 'call-result') {
      this.send('telemetry', { type: 'metric', source: 'database', name: 'dbWrite-' + (msg.call || 'unknown'), value: 1 });
    }

    // Forward database compaction stats to telemetry
    if (workerId === 'database' && msg.type === 'compaction-complete') {
      this.send('telemetry', { type: 'metric', source: 'database', name: 'compacted', value: msg.removedCount || 0 });
    }

    // Forward database errors to sentinel
    if (workerId === 'database' && msg.type === 'call-error') {
      this.send('sentinel', { type: 'anomaly', metric: 'databaseError', value: msg.call, severity: 'high' });
    }

    // Forward database snapshot events to hooks
    if (workerId === 'database' && msg.type === 'snapshot-created') {
      this.send('hooks', { type: 'emit', event: 'database-snapshot', data: { dbId: msg.dbId, snapshotId: msg.snapshotId } });
    }

    // ── Installers orchestration ───────────────────────────
    // Forward install progress to telemetry + hooks
    if (workerId === 'installers' && msg.type === 'install-progress') {
      this.send('telemetry', { type: 'metric', source: 'installers', name: 'installProgress', value: msg.progress || 0 });
    }

    // Forward install completions to telemetry + hooks
    if (workerId === 'installers' && msg.type === 'install-complete') {
      this.send('telemetry', { type: 'metric', source: 'installers', name: 'installComplete', value: 1 });
      this.send('hooks', { type: 'emit', event: 'install-complete', data: { packageId: msg.packageId, version: msg.version } });
    }

    // Forward install errors to sentinel
    if (workerId === 'installers' && msg.type === 'install-error') {
      this.send('sentinel', { type: 'anomaly', metric: 'installError', value: msg.packageId, severity: 'high' });
      this.send('telemetry', { type: 'metric', source: 'installers', name: 'installError', value: 1 });
    }

    // Forward call errors to sentinel
    if (workerId === 'installers' && msg.type === 'call-error') {
      this.send('sentinel', { type: 'anomaly', metric: 'installersError', value: msg.call, severity: 'medium' });
    }

    // ── Discovery orchestration ────────────────────────────
    // Forward discovery findings to brain (learning) + telemetry
    if (workerId === 'discovery' && msg.type === 'discovery-found') {
      this.send('telemetry', { type: 'metric', source: 'discovery', name: 'findingsCount', value: (msg.findings || []).length });
      this.send('brain', { type: 'stimulate', region: 5, intensity: 0.1 });  // Stimulate learning region
    }

    // Forward insights to hooks
    if (workerId === 'discovery' && msg.type === 'insight-generated') {
      this.send('hooks', { type: 'emit', event: 'discovery-insight', data: { insightId: msg.insightId, category: msg.category } });
      this.send('telemetry', { type: 'metric', source: 'discovery', name: 'insightGenerated', value: 1 });
    }

    // Forward high-score opportunities to sentinel for review + telemetry
    if (workerId === 'discovery' && msg.type === 'opportunity-scored') {
      this.send('telemetry', { type: 'metric', source: 'discovery', name: 'opportunityScore', value: msg.score || 0 });
      if (msg.score >= 0.8) {
        this.send('sentinel', { type: 'anomaly', metric: 'highValueOpportunity', value: msg.opportunityId, severity: 'low' });
      }
    }

    // Forward topology updates to telemetry
    if (workerId === 'discovery' && msg.type === 'topology-updated') {
      this.send('telemetry', { type: 'metric', source: 'discovery', name: 'topologyNodes', value: msg.nodeCount || 0 });
    }

    // Emit to application listeners
    this._emit(msg.type, { workerId, ...msg });
    this._emit(workerId + ':' + msg.type, msg);
  }

  _handleError(workerId, error) {
    const worker = this.workers[workerId];
    if (worker) {
      worker.status = 'error';
    }

    this._emit('worker-error', { workerId, error: error.message || 'Unknown error' });

    // Notify sentinel
    this.send('sentinel', {
      type: 'workerDeath',
      workerId,
      workerType: workerId,
    });

    // Auto-restart critical workers
    const def = WORKER_DEFS.find(d => d.id === workerId);
    if (def && def.critical) {
      setTimeout(() => this._respawnWorker(def), 1000);
    }
  }

  _respawnWorker(def) {
    this._killWorker(def.id);
    this._spawnWorker(def);

    const worker = this.workers[def.id];
    if (worker) worker.restarts++;

    this.send('infra', { type: 'register', workerId: def.id, workerType: def.id });
    this._emit('respawned', { workerId: def.id, restarts: worker ? worker.restarts : 0 });
  }

  _killWorker(workerId) {
    const worker = this.workers[workerId];
    if (worker && worker.instance) {
      try {
        worker.instance.postMessage({ type: 'stop' });
        worker.instance.terminate();
      } catch (err) {
        // Worker may already be dead
      }
      worker.status = 'dead';
      worker.instance = null;
    }
  }

  /* ──────────────────────────────────────────────────────────
     Public API — send messages to specific workers
     ────────────────────────────────────────────────────────── */

  send(workerId, message) {
    const worker = this.workers[workerId];
    if (worker && worker.instance && worker.status !== 'dead') {
      try {
        worker.instance.postMessage(message);
        return true;
      } catch (err) {
        return false;
      }
    }
    return false;
  }

  /* ──────────────────────────────────────────────────────────
     Convenience APIs for each worker domain
     ────────────────────────────────────────────────────────── */

  get brain() {
    const self = this;
    return {
      stimulate(region, intensity) { self.send('brain', { type: 'stimulate', region, intensity }); },
      tick() { self.send('brain', { type: 'tick' }); },
      getState() { self.send('brain', { type: 'getState' }); },
      getWeights() { self.send('brain', { type: 'getWeights' }); },
      setWeights(w) { self.send('brain', { type: 'setWeights', weights: w }); },
    };
  }

  get memory() {
    const self = this;
    return {
      encode(pattern, strength) { self.send('memory', { type: 'encode', pattern, strength }); },
      recall(query) { self.send('memory', { type: 'recall', query }); },
      getState() { self.send('memory', { type: 'getState' }); },
      getPatterns() { self.send('memory', { type: 'getPatterns' }); },
    };
  }

  get routing() {
    const self = this;
    return {
      route(channel, payload, priority) { self.send('routing', { type: 'route', channel, payload, priority }); },
      broadcast(payload) { self.send('routing', { type: 'broadcast', payload }); },
      getState() { self.send('routing', { type: 'getState' }); },
    };
  }

  get telemetry() {
    const self = this;
    return {
      metric(source, name, value) { self.send('telemetry', { type: 'metric', source, name, value }); },
      getMetrics(window) { self.send('telemetry', { type: 'getMetrics', window }); },
      getHealth() { self.send('telemetry', { type: 'getHealth' }); },
    };
  }

  get crypto() {
    const self = this;
    return {
      hash(data, algorithm) { self.send('crypto', { type: 'hash', data, algorithm }); },
      extendChain() { self.send('crypto', { type: 'extendChain' }); },
      verifyGenesis(name, hash) { self.send('crypto', { type: 'verifyGenesis', name, hash }); },
    };
  }

  get contracts() {
    const self = this;
    return {
      mint(accountId, amount, reason) { self.send('contract', { type: 'mint', accountId, amount, reason }); },
      transfer(from, to, amount) { self.send('contract', { type: 'transfer', from, to, amount }); },
      balance(accountId) { self.send('contract', { type: 'balance', accountId }); },
      list(accountId, organismId, price) { self.send('contract', { type: 'list', accountId, organismId, price }); },
      buy(buyerId, listingId) { self.send('contract', { type: 'buy', buyerId, listingId }); },
    };
  }

  get sentinel() {
    const self = this;
    return {
      reportThreat(source, details, severity) { self.send('sentinel', { type: 'threat', source, details, severity }); },
      getPosture() { self.send('sentinel', { type: 'getPosture' }); },
      getContainment() { self.send('sentinel', { type: 'getContainment' }); },
    };
  }

  get micro() {
    const self = this;
    return {
      submit(task) { self.send('micro', { type: 'submit', task }); },
      submitBatch(tasks) { self.send('micro', { type: 'submitBatch', tasks }); },
      getQueue() { self.send('micro', { type: 'getQueue' }); },
    };
  }

  get products() {
    const self = this;
    return {
      build(slug) { self.send('product', { type: 'build', slug }); },
      buildAll() { self.send('product', { type: 'buildAll' }); },
      validate(slug) { self.send('product', { type: 'validate', slug }); },
      getCatalog() { self.send('product', { type: 'getCatalog' }); },
    };
  }

  get download() {
    const self = this;
    return {
      build(extensions) { self.send('download', { type: 'build', extensions }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     VOIS Tool Workers — TOOL-061 through TOOL-260
     ────────────────────────────────────────────────────────── */

  get aicalls() {
    const self = this;
    return {
      invoke(toolId, input, context) { self.send('aicalls', { type: 'invoke', toolId, input, context }); },
      batch(invocations) { self.send('aicalls', { type: 'batch', invocations }); },
      getRegistry() { self.send('aicalls', { type: 'getRegistry' }); },
      getStats() { self.send('aicalls', { type: 'getStats' }); },
    };
  }

  get blueprints() {
    const self = this;
    return {
      generate(toolId, config) { self.send('blueprints', { type: 'generate', toolId, config }); },
      validate(blueprintId, config) { self.send('blueprints', { type: 'validate', blueprintId, config }); },
      list() { self.send('blueprints', { type: 'list' }); },
    };
  }

  get recipes() {
    const self = this;
    return {
      execute(toolId, params) { self.send('recipes', { type: 'execute', toolId, params }); },
      getStatus(executionId) { self.send('recipes', { type: 'getStatus', executionId }); },
      cancel(executionId) { self.send('recipes', { type: 'cancel', executionId }); },
      list() { self.send('recipes', { type: 'list' }); },
    };
  }

  get lenses() {
    const self = this;
    return {
      apply(toolId, data, options) { self.send('lenses', { type: 'apply', toolId, data, options }); },
      compose(lensIds, data) { self.send('lenses', { type: 'compose', lensIds, data }); },
      list() { self.send('lenses', { type: 'list' }); },
    };
  }

  get hooks() {
    const self = this;
    return {
      register(hookId, config) { self.send('hooks', { type: 'register', hookId, config }); },
      unregister(hookId) { self.send('hooks', { type: 'unregister', hookId }); },
      emit(event, data) { self.send('hooks', { type: 'emit', event, data }); },
      list() { self.send('hooks', { type: 'list' }); },
    };
  }

  get triggers() {
    const self = this;
    return {
      create(toolId, condition, action) { self.send('triggers', { type: 'create', toolId, condition, action }); },
      update(triggerId, updates) { self.send('triggers', { type: 'update', triggerId, updates }); },
      remove(triggerId) { self.send('triggers', { type: 'delete', triggerId }); },
      setState(key, value) { self.send('triggers', { type: 'setState', key, value }); },
      list() { self.send('triggers', { type: 'list' }); },
    };
  }

  get adapters() {
    const self = this;
    return {
      connect(adapterId, config) { self.send('adapters', { type: 'connect', adapterId, config }); },
      request(adapterId, method, params) { self.send('adapters', { type: 'request', adapterId, method, params }); },
      disconnect(adapterId) { self.send('adapters', { type: 'disconnect', adapterId }); },
      list() { self.send('adapters', { type: 'list' }); },
    };
  }

  get sensors() {
    const self = this;
    return {
      enable(sensorId) { self.send('sensors', { type: 'enable', sensorId }); },
      disable(sensorId) { self.send('sensors', { type: 'disable', sensorId }); },
      reading(sensorId, value) { self.send('sensors', { type: 'reading', sensorId, value }); },
      getReadings(sensorId) { self.send('sensors', { type: 'getReadings', sensorId }); },
      list() { self.send('sensors', { type: 'list' }); },
    };
  }

  get shields() {
    const self = this;
    return {
      check(shieldId, input) { self.send('shields', { type: 'check', shieldId, input }); },
      batchCheck(checks) { self.send('shields', { type: 'batch-check', checks }); },
      configure(shieldId, config) { self.send('shields', { type: 'configure', shieldId, config }); },
      list() { self.send('shields', { type: 'list' }); },
      getAudit(count) { self.send('shields', { type: 'getAudit', count }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     Enterprise Protocol Layer — PROTOCOL-001 through PROTOCOL-030
     ────────────────────────────────────────────────────────── */

  get protocols() {
    const self = this;
    return {
      // ── Core execution ──────────────────────────────────
      execute(protocolId, params, clientId) { self.send('protocols', { type: 'execute', protocolId, params, clientId }); },
      getStatus(executionId) { self.send('protocols', { type: 'getStatus', executionId }); },
      cancel(executionId) { self.send('protocols', { type: 'cancel', executionId }); },
      getProtocol(protocolId) { self.send('protocols', { type: 'getProtocol', protocolId }); },
      list() { self.send('protocols', { type: 'list' }); },
      getMetrics() { self.send('protocols', { type: 'getMetrics' }); },
      // ── Client management ───────────────────────────────
      registerClient(clientId, tier, quotas) { self.send('protocols', { type: 'registerClient', clientId, tier, quotas }); },
      getClient(clientId) { self.send('protocols', { type: 'getClient', clientId }); },
      listClients() { self.send('protocols', { type: 'listClients' }); },
      updateClientStatus(clientId, status) { self.send('protocols', { type: 'updateClientStatus', clientId, status }); },
      getAudit(count) { self.send('protocols', { type: 'getAudit', count }); },
      // ── Query API (read-only) ───────────────────────────
      queryProtocol(protocolId) { self.send('protocols', { type: 'queryProtocol', protocolId }); },
      queryProtocolsByCategory(category) { self.send('protocols', { type: 'queryProtocolsByCategory', category }); },
      queryClient(clientId) { self.send('protocols', { type: 'queryClient', clientId }); },
      queryClientUsage(clientId) { self.send('protocols', { type: 'queryClientUsage', clientId }); },
      queryCapacity() { self.send('protocols', { type: 'queryCapacity' }); },
      queryHealth() { self.send('protocols', { type: 'queryHealth' }); },
      queryLicense(protocolId) { self.send('protocols', { type: 'queryLicense', protocolId }); },
      queryAuditFiltered(filters) { self.send('protocols', { type: 'queryAuditFiltered', filters }); },
      // ── Call API (mutating) ─────────────────────────────
      callBatchExecute(executions) { self.send('protocols', { type: 'callBatchExecute', executions }); },
      callSuspendClient(clientId, reason) { self.send('protocols', { type: 'callSuspendClient', clientId, reason }); },
      callReactivateClient(clientId) { self.send('protocols', { type: 'callReactivateClient', clientId }); },
      callUpgradeClient(clientId, newTier) { self.send('protocols', { type: 'callUpgradeClient', clientId, newTier }); },
      callRotateSecret(clientId) { self.send('protocols', { type: 'callRotateSecret', clientId }); },
      callExportClientData(clientId, format) { self.send('protocols', { type: 'callExportClientData', clientId, format }); },
      callEmergencyShutdown(reason) { self.send('protocols', { type: 'callEmergencyShutdown', reason }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     VOIS Call Marketplace — Tool Registry + Settlement Layer
     ────────────────────────────────────────────────────────── */

  get marketplace() {
    const self = this;
    return {
      // ── Query API (read-only) ───────────────────────────
      queryTool(toolId) { self.send('marketplace', { type: 'queryTool', toolId }); },
      queryToolsByCategory(category) { self.send('marketplace', { type: 'queryToolsByCategory', category }); },
      queryContract(callId) { self.send('marketplace', { type: 'queryContract', callId }); },
      querySettlement(settlementId) { self.send('marketplace', { type: 'querySettlement', settlementId }); },
      queryCapacity() { self.send('marketplace', { type: 'queryCapacity' }); },
      queryPermissions(callerId, callId) { self.send('marketplace', { type: 'queryPermissions', callerId, callId }); },
      queryPricing(callId) { self.send('marketplace', { type: 'queryPricing', callId }); },
      queryHealth() { self.send('marketplace', { type: 'queryHealth' }); },
      queryRegistry() { self.send('marketplace', { type: 'queryRegistry' }); },
      queryCallerProfile(callerId) { self.send('marketplace', { type: 'queryCallerProfile', callerId }); },
      // ── Call API (mutating) ─────────────────────────────
      callInvoke(callId, callerId, params) { self.send('marketplace', { type: 'callInvoke', callId, callerId, params }); },
      callBatchInvoke(invocations) { self.send('marketplace', { type: 'callBatchInvoke', invocations }); },
      callRegisterTool(tool) { self.send('marketplace', { type: 'callRegisterTool', tool }); },
      callUpdatePermissions(callId, permissions) { self.send('marketplace', { type: 'callUpdatePermissions', callId, permissions }); },
      callSettleCall(invocationId) { self.send('marketplace', { type: 'callSettleCall', invocationId }); },
      callRegisterCaller(callerId, tier, config) { self.send('marketplace', { type: 'callRegisterCaller', callerId, tier, config }); },
      callExportUsage(callerId, format) { self.send('marketplace', { type: 'callExportUsage', callerId, format }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     AGI-Managed Database Layer — 13 Sovereign Databases
     ────────────────────────────────────────────────────────── */

  get database() {
    const self = this;
    return {
      // ── Query API (read-only) ───────────────────────────
      queryDatabase(dbId) { self.send('database', { type: 'queryDatabase', dbId }); },
      queryRecord(dbId, recordId) { self.send('database', { type: 'queryRecord', dbId, recordId }); },
      queryRecords(dbId, filters, options) { self.send('database', { type: 'queryRecords', dbId, filters, options }); },
      queryAcrossDatabases(query) { self.send('database', { type: 'queryAcrossDatabases', query }); },
      queryStats() { self.send('database', { type: 'queryStats' }); },
      queryIndexes(dbId) { self.send('database', { type: 'queryIndexes', dbId }); },
      queryIntegrity(dbId) { self.send('database', { type: 'queryIntegrity', dbId }); },
      queryCapacity() { self.send('database', { type: 'queryCapacity' }); },
      queryAuditTrail(filters) { self.send('database', { type: 'queryAuditTrail', filters }); },
      queryResearchCorpus(query) { self.send('database', { type: 'queryResearchCorpus', query }); },
      // ── Call API (mutating) ─────────────────────────────
      callInsert(dbId, record) { self.send('database', { type: 'callInsert', dbId, record }); },
      callBatchInsert(dbId, records) { self.send('database', { type: 'callBatchInsert', dbId, records }); },
      callUpdate(dbId, recordId, updates) { self.send('database', { type: 'callUpdate', dbId, recordId, updates }); },
      callRemove(dbId, recordId) { self.send('database', { type: 'callRemove', dbId, recordId }); },
      callCompact(dbId) { self.send('database', { type: 'callCompact', dbId }); },
      callMigrate(dbId, migration) { self.send('database', { type: 'callMigrate', dbId, migration }); },
      callSnapshot(dbId) { self.send('database', { type: 'callSnapshot', dbId }); },
      callRestore(dbId, snapshotId) { self.send('database', { type: 'callRestore', dbId, snapshotId }); },
      callPurge(dbId, filters) { self.send('database', { type: 'callPurge', dbId, filters }); },
      callExport(dbId, format) { self.send('database', { type: 'callExport', dbId, format }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     AGI Package Installer Layer — 34 installer tools
     ────────────────────────────────────────────────────────── */

  get installers() {
    const self = this;
    return {
      // ── Query API (read-only) ───────────────────────────
      queryPackage(packageId) { self.send('installers', { type: 'queryPackage', packageId }); },
      queryPackagesByType(packageType) { self.send('installers', { type: 'queryPackagesByType', packageType }); },
      queryInstalled() { self.send('installers', { type: 'queryInstalled' }); },
      queryAvailable() { self.send('installers', { type: 'queryAvailable' }); },
      queryDependencies(packageId) { self.send('installers', { type: 'queryDependencies', packageId }); },
      queryUpdates() { self.send('installers', { type: 'queryUpdates' }); },
      queryHistory(count) { self.send('installers', { type: 'queryHistory', count }); },
      queryCapacity() { self.send('installers', { type: 'queryCapacity' }); },
      queryHealth() { self.send('installers', { type: 'queryHealth' }); },
      queryRegistry() { self.send('installers', { type: 'queryRegistry' }); },
      // ── Call API (mutating) ─────────────────────────────
      callInstall(packageId, version, options) { self.send('installers', { type: 'callInstall', packageId, version, options }); },
      callBatchInstall(packages) { self.send('installers', { type: 'callBatchInstall', packages }); },
      callUninstall(packageId) { self.send('installers', { type: 'callUninstall', packageId }); },
      callUpdate(packageId, version) { self.send('installers', { type: 'callUpdate', packageId, version }); },
      callLock(packageId) { self.send('installers', { type: 'callLock', packageId }); },
      callUnlock(packageId) { self.send('installers', { type: 'callUnlock', packageId }); },
      callAudit() { self.send('installers', { type: 'callAudit' }); },
      callExport(format) { self.send('installers', { type: 'callExport', format }); },
      callAutoDiscover() { self.send('installers', { type: 'callAutoDiscover' }); },
      callAutoUpdate() { self.send('installers', { type: 'callAutoUpdate' }); },
      callResolve(packageId) { self.send('installers', { type: 'callResolve', packageId }); },
      callSync() { self.send('installers', { type: 'callSync' }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     AGI Discovery Engine — 34 discovery tools
     ────────────────────────────────────────────────────────── */

  get discovery() {
    const self = this;
    return {
      // ── Query API (read-only) ───────────────────────────
      queryScan(scanId) { self.send('discovery', { type: 'queryScan', scanId }); },
      queryScansByTarget(target) { self.send('discovery', { type: 'queryScansByTarget', target }); },
      queryFindings(since) { self.send('discovery', { type: 'queryFindings', since }); },
      queryInsights(category) { self.send('discovery', { type: 'queryInsights', category }); },
      queryCapacity() { self.send('discovery', { type: 'queryCapacity' }); },
      queryHealth() { self.send('discovery', { type: 'queryHealth' }); },
      queryRegistry() { self.send('discovery', { type: 'queryRegistry' }); },
      queryAudit(count) { self.send('discovery', { type: 'queryAudit', count }); },
      queryTopology() { self.send('discovery', { type: 'queryTopology' }); },
      queryOpportunities(minScore) { self.send('discovery', { type: 'queryOpportunities', minScore }); },
      // ── Call API (mutating) ─────────────────────────────
      callDiscover(toolId, target, params) { self.send('discovery', { type: 'callDiscover', toolId, target, params }); },
      callBatchDiscover(discoveries) { self.send('discovery', { type: 'callBatchDiscover', discoveries }); },
      callScheduleScan(toolId, intervalBeats) { self.send('discovery', { type: 'callScheduleScan', toolId, intervalBeats }); },
      callCancelScan(scanId) { self.send('discovery', { type: 'callCancelScan', scanId }); },
      callExportFindings(format) { self.send('discovery', { type: 'callExportFindings', format }); },
      callResetBaseline() { self.send('discovery', { type: 'callResetBaseline' }); },
    };
  }

  /* ──────────────────────────────────────────────────────────
     AIS Cloudflare fleet — 8 AGI Mini Brains (server-side, 24/7)
     Returns the fleet manifest + optional fetch helper for each AIS.
     The actual workers live in organism/cloudflare/ and are deployed
     independently via Wrangler (see organism/cloudflare/wrangler.toml).
     ────────────────────────────────────────────────────────── */

  get ais() {
    return {
      // Fleet manifest — all 8 AIS definitions
      fleet:       AIS_DEFS,
      fleetCount:  AIS_DEFS.length,
      // Get a specific AIS definition by id or name
      get(aisIdOrName) {
        return AIS_DEFS.find(a => a.aisId === aisIdOrName || a.name === aisIdOrName) || null;
      },
      // Fetch helper — call an AIS endpoint (requires AIS base URL to be configured)
      async call(aisIdOrName, route, body = null, baseUrls = {}) {
        const def = AIS_DEFS.find(a => a.aisId === aisIdOrName || a.name === aisIdOrName);
        if (!def) throw new Error(`AIS not found: ${aisIdOrName}`);
        const baseUrl = baseUrls[def.aisId] || baseUrls[def.name];
        if (!baseUrl) throw new Error(`No base URL configured for ${def.name}`);
        const method = body ? 'POST' : 'GET';
        const res    = await fetch(`${baseUrl}${route}`, {
          method,
          headers: { 'Content-Type': 'application/json' },
          body:    body ? JSON.stringify(body) : undefined,
        });
        return res.json();
      },
      // Convenience: get AIS status manifest (names + latinNames + cfWorkers)
      manifest() {
        return AIS_DEFS.map(a => ({
          aisId:      a.aisId,
          name:       a.name,
          latinName:  a.latinName,
          domain:     a.domain,
          cfWorker:   a.cfWorker,
          critical:   a.critical,
        }));
      },
    };
  }

  /* ──────────────────────────────────────────────────────────
     Event system
     ────────────────────────────────────────────────────────── */

  on(event, callback) {
    if (!this.listeners[event]) this.listeners[event] = [];
    this.listeners[event].push(callback);
    return this;
  }

  off(event, callback) {
    if (this.listeners[event]) {
      this.listeners[event] = this.listeners[event].filter(cb => cb !== callback);
    }
    return this;
  }

  _emit(event, data) {
    const callbacks = this.listeners[event];
    if (callbacks) {
      for (const cb of callbacks) {
        try {
          cb(data);
        } catch (err) {
          // Don't let listener errors break the fleet
        }
      }
    }

    // Also emit on wildcard
    const wildcard = this.listeners['*'];
    if (wildcard) {
      for (const cb of wildcard) {
        try {
          cb(event, data);
        } catch (err) {
          // Swallow
        }
      }
    }
  }

  /* ──────────────────────────────────────────────────────────
     Fleet state
     ────────────────────────────────────────────────────────── */

  getFleetState() {
    const workers = {};
    let alive = 0;
    let dead = 0;

    for (const [id, w] of Object.entries(this.workers)) {
      workers[id] = {
        status: w.status,
        domain: w.def.domain,
        critical: w.def.critical,
        beatCount: w.beatCount,
        restarts: w.restarts,
        uptime: w.spawnedAt ? Date.now() - w.spawnedAt : 0,
        lastHeartbeat: w.lastHeartbeat,
      };
      if (w.status === 'alive') alive++;
      else dead++;
    }

    return {
      fleetId: this.fleetId,
      running: this.running,
      uptime: this.spawnedAt ? Date.now() - this.spawnedAt : 0,
      workers,
      alive,
      dead,
      total: Object.keys(this.workers).length,
      phi: PHI,
      heartbeatMs: HEARTBEAT,
    };
  }

  /* ──────────────────────────────────────────────────────────
     Graceful shutdown
     ────────────────────────────────────────────────────────── */

  shutdown() {
    this.running = false;

    // Order: non-critical first, then critical
    const nonCritical = WORKER_DEFS.filter(d => !d.critical);
    const critical = WORKER_DEFS.filter(d => d.critical);

    for (const def of [...nonCritical, ...critical]) {
      this._killWorker(def.id);
    }

    this._emit('shutdown', { fleetId: this.fleetId, uptime: Date.now() - this.spawnedAt });
  }
}

/* ════════════════════════════════════════════════════════════════
   Export for browser use
   ════════════════════════════════════════════════════════════════ */

if (typeof window !== 'undefined') {
  window.OrganismFleet = OrganismFleet;
}

if (typeof globalThis !== 'undefined') {
  globalThis.OrganismFleet = OrganismFleet;
}
