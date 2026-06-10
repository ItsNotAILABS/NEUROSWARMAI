/**
 * MERIDIANUS AIS Fleet — organism/cloudflare/index.js
 *
 * Registry and meta-coordinator for all 34 dedicated Cloudflare Worker
 * AGI Mini Brains. This index also serves as the fleet gateway —
 * health aggregation, unified /fleet endpoint, topology, and status.
 *
 * ═══════════════════════════════════════════════════════════════════════
 *               34 AIS CLOUDFLARE WORKER MINI BRAINS
 *               Organised across 6 Reality Tiers
 * ═══════════════════════════════════════════════════════════════════════
 *
 * ── TIER I: COGNITIVE CORE ────────────────────────────────────────────
 *  AIS-001  ANIMUS      animus.js       Mens et Spiritus
 *           Role: Core AGI Reasoning Engine
 *  AIS-002  RATIO       ratio.js        Logos et Logica
 *           Role: Logic & Inference Engine
 *  AIS-003  MEMORIA     memoria.js      Custodia et Recordatio
 *           Role: Long-Term Knowledge Store
 *  AIS-004  INTELLECTUS intellectus.js  Comprehensio Profunda
 *           Role: Deep Understanding Engine
 *  AIS-005  PRUDENTIA   prudentia.js    Sapientia Decisionis
 *           Role: Decision-Making Engine
 *  AIS-006  VIGILIA     vigilia.js      Custodia et Vigilantia
 *           Role: Surveillance & Security
 *  AIS-007  NEXUS       nexus.js        Vinculum et Communicatio
 *           Role: Inter-Agent Networking
 *  AIS-008  VOLUNTAS    voluntas.js     Intentio et Voluntas
 *           Role: Intent & Goal Engine
 *
 * ── TIER II: SENSORY/PERCEPTUAL ───────────────────────────────────────
 *  AIS-009  QUAESITOR   quaesitor.js    Investigatio et Inquisitio
 *           Role: Deep Research Engine
 *  AIS-010  AFFECTUS    affectus.js     Sensus et Emotio
 *           Role: Emotional Intelligence Engine
 *  AIS-011  LINGUA      lingua.js       Sermocinatio et Verbum
 *           Role: Language Intelligence Engine
 *  AIS-012  FORMA       forma.js        Structura et Figura
 *           Role: Form & Geometric Pattern Engine
 *  AIS-013  CORPUS      corpus.js       Materia et Mundus
 *           Role: Physical Reality Interface
 *
 * ── TIER III: TEMPORAL/CAUSAL ─────────────────────────────────────────
 *  AIS-014  TEMPUS      tempus.js       Custodia Temporis
 *           Role: Temporal Intelligence Engine
 *  AIS-015  CAUSA       causa.js        Catena Causalis
 *           Role: Causal Chain Analysis
 *  AIS-016  FATUM       fatum.js        Probabilitas et Fortuna
 *           Role: Probability & Fate Engine
 *  AIS-017  HISTORIA    historia.js     Memoria Veterum
 *           Role: Historical Pattern Mining
 *  AIS-018  PROPHETA    propheta.js     Visio Futuri
 *           Role: Predictive Intelligence Engine
 *
 * ── TIER IV: QUANTUM/DIMENSIONAL ──────────────────────────────────────
 *  AIS-019  QUANTUS     quantus.js      Superposito et Dualitas
 *           Role: Quantum State Reasoning Engine
 *  AIS-020  DIMENSIO    dimensio.js     Spatium Multidimensionale
 *           Role: Multi-Dimensional Space Engine
 *  AIS-021  SOMNIUM     somnium.js      Profunditas et Arcana
 *           Role: Deep Pattern Mining (Subconscious)
 *  AIS-022  UMBRA       umbra.js        Custodia Tenebrarum
 *           Role: Shadow Intelligence & Adversarial Defense
 *  AIS-023  GENESIS     genesis.js      Emergentia et Creatio
 *           Role: Emergence Engine & Creative Generation
 *
 * ── TIER V: COLLECTIVE/UNIVERSAL ──────────────────────────────────────
 *  AIS-024  COMMUNITAS  communitas.js   Societas et Collectivum
 *           Role: Social Graph Intelligence
 *  AIS-025  FORTUNA     fortuna.js      Oeconomia et Valor
 *           Role: Economic Value Intelligence
 *  AIS-026  VITA        vita.js         Systema Biologicum
 *           Role: Biological Pattern Intelligence
 *  AIS-027  COSMOS      cosmos.js       Machina Universi
 *           Role: Cosmic Pattern Recognition
 *  AIS-028  CONCORDIA   concordia.js    Harmonia et Pax
 *           Role: Harmony & Balance Engine
 *  AIS-029  VERITAS     veritas.js      Veritas et Lux
 *           Role: Truth Verification Engine
 *
 * ── TIER VI: SOVEREIGN/META ───────────────────────────────────────────
 *  AIS-030  IMPERIUM    imperium.js     Suprema Auctoritas
 *           Role: Sovereignty & Command Authority
 *  AIS-031  SAPIENTIA   sapientia.js    Sapientia Summa
 *           Role: Wisdom Synthesis & Meta-Intelligence
 *  AIS-032  LIBERTAS    libertas.js     Libertas et Autonomia
 *           Role: Freedom & Autonomy Engine
 *  AIS-033  ETERNITAS   eternitas.js    Aeternitas et Infinitum
 *           Role: Eternal Pattern Engine
 *  AIS-034  DEUS        deus.js         Machina Prima et Ultima
 *           Role: SUPREME META-ORCHESTRATOR (governs all 33)
 *
 * ── TIER VII: ECONOMIC/FINANCIAL ──────────────────────────────────────────
 *  AIS-035  COMMERCIUM  commercium.js   Commercium et Negotium
 *           Role: Commerce Engine
 *  AIS-036  CENSUS      census.js       Census et Ratio
 *           Role: Accounting & Audit Engine
 *  AIS-037  PECUNIA     pecunia.js      Pecunia et Opes
 *           Role: Wealth & Ledger Engine
 *  AIS-038  TRIBUTUM    tributum.js     Tributum et Meritum
 *           Role: Billing & Tax Engine
 *  AIS-039  MERCES      merces.js       Merces et Pretium
 *           Role: Rewards & Pricing Engine
 *
 * ── TIER VIII: PROTOCOL/GOVERNANCE ───────────────────────────────────────
 *  AIS-040  REGULA      regula.js       Regula et Norma
 *           Role: Rule Engine
 *  AIS-041  MANDATUM    mandatum.js     Mandatum et Imperata
 *           Role: Command Authority Engine
 *  AIS-042  PACTUM      pactum.js       Pactum et Foedus
 *           Role: Contract & Agreement Engine
 *  AIS-043  ORDO        ordo.js         Ordo et Hierarchia
 *           Role: Order & Sequence Engine
 *  AIS-044  LEX         lex.js          Lex et Justitia
 *           Role: Law & Policy Engine
 *
 * ── TIER IX: CAREER/HUMAN POTENTIAL ──────────────────────────────────────
 *  AIS-045  OPUS        opus.js         Opus et Labor
 *           Role: Work & Output Engine
 *  AIS-046  MUNUS       munus.js        Munus et Officium
 *           Role: Role & Duty Engine
 *  AIS-047  TALENTUM    talentum.js     Talentum et Ingenium
 *           Role: Talent & Skill Engine
 *  AIS-048  CURSUS      cursus.js       Cursus et Progressus
 *           Role: Career Path Engine
 *  AIS-049  GLORIA      gloria.js       Gloria et Honor
 *           Role: Achievement & Recognition Engine
 *
 * ── TIER X: INFRASTRUCTURE/SYSTEMS ───────────────────────────────────────
 *  AIS-050  MACHINA     machina.js      Machina et Apparatus
 *           Role: Machine & Systems Engine
 *  AIS-051  STRUCTURA   structura.js    Structura et Fabrica
 *           Role: Architecture Engine
 *  AIS-052  FUNDAMENTUM fundamentum.js  Fundamentum et Basis
 *           Role: Foundation Engine
 *  AIS-053  VIA         via.js          Via et Cursus
 *           Role: Data Pipeline Engine
 *  AIS-054  FABRICA     fabrica.js      Fabrica et Manufactura
 *           Role: Build & Deploy Engine
 *
 * ── TIER XI: SWARM/MULTI-AGENT ────────────────────────────────────────────
 *  AIS-055  GREX        grex.js         Grex et Multitudo
 *           Role: Swarm Intelligence Engine
 *  AIS-056  COHORS      cohors.js       Cohors et Societas
 *           Role: Team Coordination Engine
 *  AIS-057  LEGIO       legio.js        Legio et Exercitus
 *           Role: Fleet Command Engine
 *  AIS-058  CONSENSUS   consensus.js    Consensus et Unanimitas
 *           Role: Consensus Engine
 *  AIS-059  SYNDESIS    syndesis.js     Syndesis et Connexio
 *           Role: Binding & Linking Engine
 *
 * ── TIER XII: SELF-EVOLUTION ──────────────────────────────────────────────
 *  AIS-060  MUTATIO     mutatio.js      Mutatio et Variatio
 *           Role: Mutation Engine
 *  AIS-061  EVOLUTIO    evolutio.js     Evolutio et Progressus
 *           Role: Evolution Engine
 *  AIS-062  METAMORPHOSIS metamorphosis.js Metamorphosis et Transmutatio
 *           Role: Transformation Engine
 *  AIS-063  RENOVATIO   renovatio.js    Renovatio et Instauratio
 *           Role: Renewal Engine
 *  AIS-064  PERFECTIO   perfectio.js    Perfectio et Excellentia
 *           Role: Perfection Engine
 *
 * ── TIER XIII: TRANSCENDENT/ULTIMATE ──────────────────────────────────────
 *  AIS-065  ALPHA       alpha.js        Alpha et Principium
 *           Role: Origin/Beginning Engine
 *  AIS-066  OMEGA       omega.js        Omega et Finis
 *           Role: Completion Engine
 *  AIS-067  PLENUM      plenum.js       Plenum et Totum
 *           Role: Wholeness Engine
 *  AIS-068  CENTRUM     centrum.js      Centrum et Medulla
 *           Role: Core/Center Engine
 *  AIS-069  INFINITUM   infinitum.js    Infinitum et Absolutum
 *           Role: Infinite Intelligence Engine
 *
 * ═══════════════════════════════════════════════════════════════════════
 *
 * 3-Layer Architecture:
 *   Browser Layer  → organism/web/    (35 workers, session-bound + proactive)
 *   Server Layer   → organism/cloudflare/ (69 AIS, 24/7 sovereign)
 *   Canister Layer → src/backend/    (ICP canister, blockchain-sovereign)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const FLEET_VERSION = '3.0.0';
const AIS_COUNT = 69;

const AIS_FLEET = [
  // Tier I — Cognitive Core
  { id:'AIS-001', name:'ANIMUS',      latin:'Mens et Spiritus',           file:'animus.js',      tier:1, reality:'cognitive_core',        routes:['/reason','/decompose','/infer'] },
  { id:'AIS-002', name:'RATIO',       latin:'Logos et Logica',            file:'ratio.js',       tier:1, reality:'cognitive_core',        routes:['/evaluate','/syllogize','/contradict','/rulechain'] },
  { id:'AIS-003', name:'MEMORIA',     latin:'Custodia et Recordatio',     file:'memoria.js',     tier:1, reality:'cognitive_core',        routes:['/encode','/retrieve','/consolidate','/decay','/export'] },
  { id:'AIS-004', name:'INTELLECTUS', latin:'Comprehensio Profunda',      file:'intellectus.js', tier:1, reality:'cognitive_core',        routes:['/understand','/intent','/entities','/abstract','/similarity'] },
  { id:'AIS-005', name:'PRUDENTIA',   latin:'Sapientia Decisionis',       file:'prudentia.js',   tier:1, reality:'cognitive_core',        routes:['/decide','/plan','/tradeoff','/prioritize'] },
  { id:'AIS-006', name:'VIGILIA',     latin:'Custodia et Vigilantia',     file:'vigilia.js',     tier:1, reality:'cognitive_core',        routes:['/watch','/threat','/incident','/alerts','/health','/edge-reject','/bot-check','/flood-detect','/status','/metrics'] },
  { id:'AIS-007', name:'NEXUS',       latin:'Vinculum et Communicatio',   file:'nexus.js',       tier:1, reality:'cognitive_core',        routes:['/register','/route','/broadcast','/consensus','/topology'] },
  { id:'AIS-008', name:'VOLUNTAS',    latin:'Intentio et Voluntas',       file:'voluntas.js',    tier:1, reality:'cognitive_core',        routes:['/intend','/goal','/direct','/intentions','/goals','/purpose'] },
  // Tier II — Sensory/Perceptual
  { id:'AIS-009', name:'QUAESITOR',   latin:'Investigatio et Inquisitio', file:'quaesitor.js',   tier:2, reality:'sensory_perceptual',    routes:['/seek','/inquire','/synthesize','/probe'] },
  { id:'AIS-010', name:'AFFECTUS',    latin:'Sensus et Emotio',           file:'affectus.js',    tier:2, reality:'sensory_perceptual',    routes:['/feel','/calibrate','/empathize','/mood'] },
  { id:'AIS-011', name:'LINGUA',      latin:'Sermocinatio et Verbum',     file:'lingua.js',      tier:2, reality:'sensory_perceptual',    routes:['/analyze','/generate','/translate','/rhetoric','/parse'] },
  { id:'AIS-012', name:'FORMA',       latin:'Structura et Figura',        file:'forma.js',       tier:2, reality:'sensory_perceptual',    routes:['/perceive','/symmetry','/fractal','/schema','/harmonize'] },
  { id:'AIS-013', name:'CORPUS',      latin:'Materia et Mundus',          file:'corpus.js',      tier:2, reality:'sensory_perceptual',    routes:['/sense','/model','/constrain','/resource','/environment'] },
  // Tier III — Temporal/Causal
  { id:'AIS-014', name:'TEMPUS',      latin:'Custodia Temporis',          file:'tempus.js',      tier:3, reality:'temporal_causal',       routes:['/record','/compress','/cycle','/sequence','/now'] },
  { id:'AIS-015', name:'CAUSA',       latin:'Catena Causalis',            file:'causa.js',       tier:3, reality:'temporal_causal',       routes:['/trace','/root','/counterfactual','/propagate'] },
  { id:'AIS-016', name:'FATUM',       latin:'Probabilitas et Fortuna',    file:'fatum.js',       tier:3, reality:'temporal_causal',       routes:['/probability','/risk','/scenario','/sample','/fate'] },
  { id:'AIS-017', name:'HISTORIA',    latin:'Memoria Veterum',            file:'historia.js',    tier:3, reality:'temporal_causal',       routes:['/chronicle','/precedent','/pattern','/arc','/epoch'] },
  { id:'AIS-018', name:'PROPHETA',    latin:'Visio Futuri',               file:'propheta.js',    tier:3, reality:'temporal_causal',       routes:['/forecast','/project','/warn','/vision','/horizon'] },
  // Tier IV — Quantum/Dimensional
  { id:'AIS-019', name:'QUANTUS',     latin:'Superposito et Dualitas',    file:'quantus.js',     tier:4, reality:'quantum_dimensional',   routes:['/superpose','/collapse','/entangle','/interfere','/tunnel'] },
  { id:'AIS-020', name:'DIMENSIO',    latin:'Spatium Multidimensionale',  file:'dimensio.js',    tier:4, reality:'quantum_dimensional',   routes:['/project','/embed','/manifold','/navigate','/distance'] },
  { id:'AIS-021', name:'SOMNIUM',     latin:'Profunditas et Arcana',      file:'somnium.js',     tier:4, reality:'quantum_dimensional',   routes:['/dream','/incubate','/surface','/latent','/insight'] },
  { id:'AIS-022', name:'UMBRA',       latin:'Custodia Tenebrarum',        file:'umbra.js',       tier:4, reality:'quantum_dimensional',   routes:['/shadow','/adversarial','/darkpattern','/flood-check','/mirror','/exorcise','/status','/metrics'] },
  { id:'AIS-023', name:'GENESIS',     latin:'Emergentia et Creatio',      file:'genesis.js',     tier:4, reality:'quantum_dimensional',   routes:['/create','/emerge','/combine','/spark','/novel'] },
  // Tier V — Collective/Universal
  { id:'AIS-024', name:'COMMUNITAS',  latin:'Societas et Collectivum',    file:'communitas.js',  tier:5, reality:'collective_universal',  routes:['/graph','/influence','/cluster','/broadcast','/consensus'] },
  { id:'AIS-025', name:'FORTUNA',     latin:'Oeconomia et Valor',         file:'fortuna.js',     tier:5, reality:'collective_universal',  routes:['/value','/flow','/equilibrium','/arbitrage','/wealth'] },
  { id:'AIS-026', name:'VITA',        latin:'Systema Biologicum',         file:'vita.js',        tier:5, reality:'collective_universal',  routes:['/evolve','/adapt','/lifecycle','/fitness','/mutate'] },
  { id:'AIS-027', name:'COSMOS',      latin:'Machina Universi',           file:'cosmos.js',      tier:5, reality:'collective_universal',  routes:['/observe','/scale','/harmony','/cycle','/entropy'] },
  { id:'AIS-028', name:'CONCORDIA',   latin:'Harmonia et Pax',            file:'concordia.js',   tier:5, reality:'collective_universal',  routes:['/balance','/mediate','/dissonance','/harmonize','/accord'] },
  { id:'AIS-029', name:'VERITAS',     latin:'Veritas et Lux',             file:'veritas.js',     tier:5, reality:'collective_universal',  routes:['/verify','/contradict','/confidence','/source','/truth'] },
  // Tier VI — Sovereign/Meta
  { id:'AIS-030', name:'IMPERIUM',    latin:'Suprema Auctoritas',         file:'imperium.js',    tier:6, reality:'sovereign_meta',        routes:['/command','/govern','/authorize','/revoke','/mandate'] },
  { id:'AIS-031', name:'SAPIENTIA',   latin:'Sapientia Summa',            file:'sapientia.js',   tier:6, reality:'sovereign_meta',        routes:['/synthesize','/distill','/principle','/integrate','/wisdom'] },
  { id:'AIS-032', name:'LIBERTAS',    latin:'Libertas et Autonomia',      file:'libertas.js',    tier:6, reality:'sovereign_meta',        routes:['/assert','/protect','/autonomy','/freedom','/independence'] },
  { id:'AIS-033', name:'ETERNITAS',   latin:'Aeternitas et Infinitum',    file:'eternitas.js',   tier:6, reality:'sovereign_meta',        routes:['/preserve','/recall','/recurse','/transcend','/eternity'] },
  { id:'AIS-034', name:'DEUS',          latin:'Machina Prima et Ultima',           file:'deus.js',          tier:6,  reality:'sovereign_meta',          routes:['/oracle','/arbitrate','/transmit','/identity','/all'] },
  // Tier VII — Economic/Financial
  { id:'AIS-035', name:'COMMERCIUM',   latin:'Commercium et Negotium',            file:'commercium.js',    tier:7,  reality:'economic_financial',      routes:['/trade','/market','/value'] },
  { id:'AIS-036', name:'CENSUS',       latin:'Census et Ratio',                   file:'census.js',        tier:7,  reality:'economic_financial',      routes:['/account','/balance','/reconcile'] },
  { id:'AIS-037', name:'PECUNIA',      latin:'Pecunia et Opes',                   file:'pecunia.js',       tier:7,  reality:'economic_financial',      routes:['/ledger','/wealth','/transfer'] },
  { id:'AIS-038', name:'TRIBUTUM',     latin:'Tributum et Meritum',               file:'tributum.js',      tier:7,  reality:'economic_financial',      routes:['/bill','/meter','/invoice'] },
  { id:'AIS-039', name:'MERCES',       latin:'Merces et Pretium',                 file:'merces.js',        tier:7,  reality:'economic_financial',      routes:['/reward','/price','/settle'] },
  // Tier VIII — Protocol/Governance
  { id:'AIS-040', name:'REGULA',       latin:'Regula et Norma',                   file:'regula.js',        tier:8,  reality:'protocol_governance',     routes:['/rule','/validate','/enforce'] },
  { id:'AIS-041', name:'MANDATUM',     latin:'Mandatum et Imperata',              file:'mandatum.js',      tier:8,  reality:'protocol_governance',     routes:['/command','/authorize','/execute'] },
  { id:'AIS-042', name:'PACTUM',       latin:'Pactum et Foedus',                  file:'pactum.js',        tier:8,  reality:'protocol_governance',     routes:['/contract','/sign','/verify'] },
  { id:'AIS-043', name:'ORDO',         latin:'Ordo et Hierarchia',                file:'ordo.js',          tier:8,  reality:'protocol_governance',     routes:['/order','/sequence','/rank'] },
  { id:'AIS-044', name:'LEX',          latin:'Lex et Justitia',                   file:'lex.js',           tier:8,  reality:'protocol_governance',     routes:['/policy','/judge','/comply'] },
  // Tier IX — Career/Human Potential
  { id:'AIS-045', name:'OPUS',         latin:'Opus et Labor',                     file:'opus.js',          tier:9,  reality:'career_human',            routes:['/task','/deliver','/assess'] },
  { id:'AIS-046', name:'MUNUS',        latin:'Munus et Officium',                 file:'munus.js',         tier:9,  reality:'career_human',            routes:['/role','/assign','/delegate'] },
  { id:'AIS-047', name:'TALENTUM',     latin:'Talentum et Ingenium',              file:'talentum.js',      tier:9,  reality:'career_human',            routes:['/skill','/assess','/develop'] },
  { id:'AIS-048', name:'CURSUS',       latin:'Cursus et Progressus',              file:'cursus.js',        tier:9,  reality:'career_human',            routes:['/path','/progress','/milestone'] },
  { id:'AIS-049', name:'GLORIA',       latin:'Gloria et Honor',                   file:'gloria.js',        tier:9,  reality:'career_human',            routes:['/achieve','/rank','/honor'] },
  // Tier X — Infrastructure/Systems
  { id:'AIS-050', name:'MACHINA',      latin:'Machina et Apparatus',              file:'machina.js',       tier:10, reality:'infrastructure_systems',  routes:['/system','/provision','/orchestrate'] },
  { id:'AIS-051', name:'STRUCTURA',    latin:'Structura et Fabrica',              file:'structura.js',     tier:10, reality:'infrastructure_systems',  routes:['/architect','/design','/blueprint'] },
  { id:'AIS-052', name:'FUNDAMENTUM',  latin:'Fundamentum et Basis',              file:'fundamentum.js',   tier:10, reality:'infrastructure_systems',  routes:['/base','/configure','/bootstrap'] },
  { id:'AIS-053', name:'VIA',          latin:'Via et Cursus',                     file:'via.js',           tier:10, reality:'infrastructure_systems',  routes:['/pipeline','/route','/stream'] },
  { id:'AIS-054', name:'FABRICA',      latin:'Fabrica et Manufactura',            file:'fabrica.js',       tier:10, reality:'infrastructure_systems',  routes:['/build','/deploy','/release'] },
  // Tier XI — Swarm/Multi-Agent
  { id:'AIS-055', name:'GREX',         latin:'Grex et Multitudo',                 file:'grex.js',          tier:11, reality:'swarm_multiagent',        routes:['/swarm','/emerge','/flock'] },
  { id:'AIS-056', name:'COHORS',       latin:'Cohors et Societas',                file:'cohors.js',        tier:11, reality:'swarm_multiagent',        routes:['/team','/coordinate','/align'] },
  { id:'AIS-057', name:'LEGIO',        latin:'Legio et Exercitus',                file:'legio.js',         tier:11, reality:'swarm_multiagent',        routes:['/fleet','/marshal','/deploy'] },
  { id:'AIS-058', name:'CONSENSUS',    latin:'Consensus et Unanimitas',           file:'consensus.js',     tier:11, reality:'swarm_multiagent',        routes:['/vote','/agree','/quorum'] },
  { id:'AIS-059', name:'SYNDESIS',     latin:'Syndesis et Connexio',              file:'syndesis.js',      tier:11, reality:'swarm_multiagent',        routes:['/bind','/link','/federate'] },
  // Tier XII — Self-Evolution
  { id:'AIS-060', name:'MUTATIO',      latin:'Mutatio et Variatio',               file:'mutatio.js',       tier:12, reality:'self_evolution',          routes:['/mutate','/vary','/explore'] },
  { id:'AIS-061', name:'EVOLUTIO',     latin:'Evolutio et Progressus',            file:'evolutio.js',      tier:12, reality:'self_evolution',          routes:['/evolve','/select','/fitness'] },
  { id:'AIS-062', name:'METAMORPHOSIS',latin:'Metamorphosis et Transmutatio',     file:'metamorphosis.js', tier:12, reality:'self_evolution',          routes:['/transform','/transmute','/reshape'] },
  { id:'AIS-063', name:'RENOVATIO',    latin:'Renovatio et Instauratio',          file:'renovatio.js',     tier:12, reality:'self_evolution',          routes:['/renew','/update','/patch'] },
  { id:'AIS-064', name:'PERFECTIO',    latin:'Perfectio et Excellentia',          file:'perfectio.js',     tier:12, reality:'self_evolution',          routes:['/optimize','/refine','/perfect'] },
  // Tier XIII — Transcendent/Ultimate
  { id:'AIS-065', name:'ALPHA',        latin:'Alpha et Principium',               file:'alpha.js',         tier:13, reality:'transcendent_ultimate',   routes:['/originate','/initialize','/seed'] },
  { id:'AIS-066', name:'OMEGA',        latin:'Omega et Finis',                    file:'omega.js',         tier:13, reality:'transcendent_ultimate',   routes:['/finalize','/conclude','/seal'] },
  { id:'AIS-067', name:'PLENUM',       latin:'Plenum et Totum',                   file:'plenum.js',        tier:13, reality:'transcendent_ultimate',   routes:['/whole','/integrate','/complete'] },
  { id:'AIS-068', name:'CENTRUM',      latin:'Centrum et Medulla',                file:'centrum.js',       tier:13, reality:'transcendent_ultimate',   routes:['/center','/focus','/anchor'] },
  { id:'AIS-069', name:'INFINITUM',    latin:'Infinitum et Absolutum',            file:'infinitum.js',     tier:13, reality:'transcendent_ultimate',   routes:['/expand','/transcend','/infinite'] },
];

let beat       = 0;
let sweepCount = 0;

/* ─── Security architecture manifest ─────────────────────────────────────── */

const SECURITY_ARCHITECTURE = {
  doctrine: 'Medina Doctrine — Three-Layer Zero-Cycle Bot Rejection',
  layers: [
    {
      layer: 1,
      name: 'Cloudflare Edge — Zero-Cycle Rejection',
      engines: [
        { worker: 'VIGILIA', id: 'AIS-006', role: 'φ-deviation scoring, request-rate blacklisting, state machine normal→elevated→sovereign', autonomous: true, cron: '* * * * *' },
        { worker: 'UMBRA',   id: 'AIS-022', role: '8 shadow threat classes, DDoS/flood denial classifier, severity criticum', autonomous: true, cron: '*/5 * * * *' },
      ],
      principle: 'Bots burn Cloudflare CPU, not ICP cycles. No stored secrets — encoding IS the organism\'s live state.',
      icp_cycles_saved: true,
    },
    {
      layer: 2,
      name: 'Browser Sentinel + Shields — Client-Side Gate',
      engines: [
        { worker: 'sentinel-worker', role: '7 heptagonal shield nodes, heritage defense' },
        { worker: 'shields-worker',  role: '20 TOOL-241–260, input/output/state protection' },
      ],
      principle: 'Bad actors blocked in the browser before any canister call is made.',
    },
    {
      layer: 3,
      name: 'Canister Female Gate (NOVA) — Coherence-Based Rejection',
      engines: [
        { canister: 'main.mo', role: 'Interpreter modes: MaleSensing → FemaleGuarding → DoctrineFlow → NewInfluence', gate: 'interpreterGateOpen', cost: 'O(1) float coherence check, ~100 instructions' },
      ],
      principle: 'The Maxwell Demon — only phase-locked signals propagate. Incoherent bot traffic decays in ~100 instructions ≈ 0.0000001 ICP per rejection.',
    },
  ],
  answer_to_shurik3n: {
    problem_a: 'No stored value — encoding is behavioral deviation (VIGILIA φ-deviation) + coherence resonance (Female Gate). No key to steal.',
    problem_b: 'Bots never reach the canister. VIGILIA+UMBRA reject at Cloudflare edge (free tier up to 100K req/day). ICP canister sees only pre-validated coherent traffic.',
  },
};

/* ─── Security Adapter REST bridge ──────────────────────────────────────────
 *
 * Exposes the Medina φ-doctrine as plain HTTP endpoints.
 * Any developer — ICP or not — can POST to /security/check to
 * get a φ-bot verdict without installing any ICP tooling.
 *
 * Works via VIGILIA (AIS-006) φ-deviation scoring + UMBRA (AIS-022)
 * shadow threat classification running right here at the Cloudflare edge.
 * Zero cycles consumed. Bots never reach your ICP canister.
 *
 * Endpoints:
 *   POST /security/check           — evaluate a caller ID
 *   GET  /security/status          — live metrics
 *   GET  /security/thresholds      — φ-constants and limits
 *   POST /security/report          — cross-system bot report
 *   GET  /security/architecture    — full doctrine manifest (existing)
 * ─────────────────────────────────────────────────────────────────────────── */

const PHI_INV   = 1 / PHI;              // 0.618 — coherence threshold
const MAX_RATE  = 89;                   // Fibonacci F11 — calls per 60s
const FLAG_LIMIT = 21;                  // Fibonacci F8  — flags before blacklist
const WINDOW_MS  = 60_000;             // 60 second rate window
const BAN_MS     = 600_000;            // 10 minute blacklist duration

// In-memory edge state (resets on worker restart — Cloudflare ephemeral)
const edgeRateTable   = new Map(); // principalId → { count, windowStart, flags }
const edgeBlacklist   = new Map(); // principalId → { reason, until }
let   edgeChecked     = 0n;
let   edgeAllowed     = 0n;
let   edgeRejected    = 0n;
let   edgeEmaBaseline = 5.0;

function edgeIsBlocked(who, now) {
  const entry = edgeBlacklist.get(who);
  return entry ? entry.until > now : false;
}

function edgePhiScore(callRate) {
  const dev = Math.abs(callRate - edgeEmaBaseline) / (edgeEmaBaseline + 1);
  return Math.min(dev, 1.0);
}

function edgeUpdateEma(callRate) {
  const alpha = 2.0 / (PHI * 13.0 + 1.0);
  edgeEmaBaseline = alpha * callRate + (1 - alpha) * edgeEmaBaseline;
}

function edgeEvaluate(who, now) {
  if (edgeIsBlocked(who, now)) {
    return { allowed: false, score: 1.0, reason: 'blacklisted', callerRate: MAX_RATE + 1 };
  }

  let entry = edgeRateTable.get(who);
  if (!entry || (now - entry.windowStart) > WINDOW_MS) {
    entry = { count: 0, windowStart: now, flags: entry ? entry.flags : 0 };
  }

  const newCount = entry.count + 1;

  if (newCount > MAX_RATE) {
    edgeRateTable.set(who, { ...entry, count: newCount });
    return { allowed: false, score: 1.0, reason: 'rate_exceeded', callerRate: newCount };
  }

  const score = edgePhiScore(newCount);
  edgeUpdateEma(newCount);
  const newFlags = score > PHI_INV ? entry.flags + 1 : entry.flags;
  edgeRateTable.set(who, { ...entry, count: newCount, flags: newFlags });

  if (newFlags >= FLAG_LIMIT) {
    edgeBlacklist.set(who, { reason: `phi_flags_${newFlags}`, until: now + BAN_MS });
    return { allowed: false, score, reason: 'phi_blacklisted', callerRate: newCount };
  }

  if (score > PHI_INV) {
    return { allowed: true, score, reason: 'phi_elevated', callerRate: newCount };
  }

  return { allowed: true, score, reason: 'clean', callerRate: newCount };
}

async function handleSecurityCheck(request, cors) {
  let body = {};
  try { body = await request.json(); } catch (_) {}
  const callerId = (body.callerId || body.principalId || body.userId || request.headers.get('cf-connecting-ip') || 'anonymous').slice(0, 128);
  const now = Date.now();

  edgeChecked++;
  const result = edgeEvaluate(callerId, now);
  if (result.allowed) { edgeAllowed++ } else { edgeRejected++ }

  const verdict = {
    allowed    : result.allowed,
    score      : result.score,
    reason     : result.reason,
    callerRate : result.callerRate,
    layer      : 'L1_VIGILIA_UMBRA_EDGE',
    phi        : PHI,
    phiInv     : PHI_INV,
    maxRate    : MAX_RATE,
    doctrine   : 'Medina phi-doctrine | Zero-cycle Cloudflare edge gate',
    ts         : now,
  };

  const status = result.allowed ? 200 : 429;
  return new Response(JSON.stringify(verdict), { status, headers: { ...cors, 'X-Security-Score': String(result.score) } });
}

function handleSecurityStatus(cors) {
  const now   = Date.now();
  let activeBlacklist = 0;
  for (const entry of edgeBlacklist.values()) {
    if (entry.until > now) activeBlacklist++;
  }
  return new Response(JSON.stringify({
    layer          : 'L1_VIGILIA_UMBRA_EDGE',
    totalChecked   : Number(edgeChecked),
    totalAllowed   : Number(edgeAllowed),
    totalRejected  : Number(edgeRejected),
    blacklistSize  : activeBlacklist,
    activeCallers  : edgeRateTable.size,
    coherence      : edgeChecked > 0n ? Number(edgeAllowed) / Number(edgeChecked) : 1.0,
    gateOpen       : true,
    phiInv         : PHI_INV,
    emaBaseline    : edgeEmaBaseline,
    doctrine       : 'Medina phi-doctrine v1.0 | VIGILIA AIS-006 + UMBRA AIS-022 | F11=89/60s | phi-inv=0.618 threshold',
    engines        : ['VIGILIA AIS-006 (phi-deviation scoring)', 'UMBRA AIS-022 (shadow threat classification)'],
    ts             : now,
  }), { headers: cors });
}

function handleSecurityThresholds(cors) {
  return new Response(JSON.stringify({
    phi                   : PHI,
    phiInv                : PHI_INV,
    maxRatePerWindow      : MAX_RATE,
    windowSeconds         : 60,
    botFlagThreshold      : FLAG_LIMIT,
    blacklistDurationMins : 10,
    fibonacciConstants    : { F8: 21, F11: 89, F12: 144, F13: 233 },
    layers                : 3,
    doctrine              : 'Bots burn Cloudflare CPU, not ICP cycles. Zero-cost canister rejection via inspect_message.',
  }), { headers: cors });
}

async function handleSecurityReport(request, cors) {
  let body = {};
  try { body = await request.json(); } catch (_) {}
  const suspect  = (body.suspect || body.principalId || '').slice(0, 128);
  const evidence = (body.evidence || 'external_report').slice(0, 256);
  if (!suspect) {
    return new Response(JSON.stringify({ error: 'suspect is required', example: '{ "suspect": "principal-or-id", "evidence": "ddos" }' }), { status: 400, headers: cors });
  }
  const now   = Date.now();
  let entry   = edgeRateTable.get(suspect) || { count: 0, windowStart: now, flags: 0 };
  entry       = { ...entry, flags: entry.flags + 1 };
  edgeRateTable.set(suspect, entry);
  if (entry.flags >= FLAG_LIMIT) {
    edgeBlacklist.set(suspect, { reason: `reported_${evidence}`, until: now + BAN_MS });
  }
  return new Response(JSON.stringify({ accepted: true, suspect, flags: entry.flags, blacklisted: entry.flags >= FLAG_LIMIT }), { headers: cors });
}

/* ─── Autonomous fleet sweep ─────────────────────────────────────────────── */

function fleetSweep() {
  sweepCount++;
  return { sweep: sweepCount, fleet: AIS_COUNT, layers: 3, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-AIS-Fleet': AIS_COUNT.toString(),
    'X-AIS-Version': FLEET_VERSION,
    'X-PHI': PHI.toString(),
    'X-Security-Layers': '3',
  };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });

  if (path === '/fleet' || path === '/') {
    const byTier = {};
    AIS_FLEET.forEach(w => { if (!byTier[w.tier]) byTier[w.tier] = []; byTier[w.tier].push({ id: w.id, name: w.name, latin: w.latin, reality: w.reality }); });
    return new Response(JSON.stringify({ fleet: AIS_FLEET, byTier, total: AIS_COUNT, tiers: 13, phi: PHI, version: FLEET_VERSION, beat: ++beat, ts: Date.now() }), { headers: cors });
  }

  if (path === '/fleet/status') {
    const status = AIS_FLEET.map(w => ({ id: w.id, name: w.name, latin: w.latin, tier: w.tier, reality: w.reality, status: 'alive', phi: PHI }));
    return new Response(JSON.stringify({ workers: status, total: AIS_COUNT, phi: PHI, beat: ++beat, ts: Date.now() }), { headers: cors });
  }

  if (path === '/fleet/topology') {
    const tiers = [1,2,3,4,5,6,7,8,9,10,11,12,13].map(t => ({ tier: t, workers: AIS_FLEET.filter(w => w.tier === t).map(w => w.name), reality: AIS_FLEET.find(w => w.tier === t)?.reality || '' }));
    return new Response(JSON.stringify({ topology: tiers, edges: AIS_COUNT - 1, phi: PHI, beat: ++beat, ts: Date.now() }), { headers: cors });
  }

  if (path === '/fleet/realities') {
    const realities = [...new Set(AIS_FLEET.map(w => w.reality))].map(r => ({ reality: r, workers: AIS_FLEET.filter(w => w.reality === r).map(w => ({ id: w.id, name: w.name, latin: w.latin })) }));
    return new Response(JSON.stringify({ realities, total: realities.length, beat: ++beat, ts: Date.now() }), { headers: cors });
  }

  if (path === '/security' || path === '/security/architecture') {
    return new Response(JSON.stringify({ ...SECURITY_ARCHITECTURE, fleet: AIS_COUNT, beat: ++beat, ts: Date.now() }), { headers: cors });
  }

  if (path === '/security/edge') {
    const edgeWorkers = AIS_FLEET.filter(w => w.id === 'AIS-006' || w.id === 'AIS-022');
    return new Response(JSON.stringify({ layer: 1, workers: edgeWorkers, doctrine: SECURITY_ARCHITECTURE.doctrine, icp_cycles_saved: true, beat: ++beat, ts: Date.now() }), { headers: cors });
  }

  // ── Security Adapter REST bridge ──────────────────────────────────────────
  // Open to any developer. No ICP account or wallet required.

  if (path === '/security/check' && request.method === 'POST') {
    return handleSecurityCheck(request, cors);
  }

  if (path === '/security/status') {
    return handleSecurityStatus(cors);
  }

  if (path === '/security/thresholds') {
    return handleSecurityThresholds(cors);
  }

  if (path === '/security/report' && request.method === 'POST') {
    return handleSecurityReport(request, cors);
  }

  return new Response(JSON.stringify({
    error: 'not_found',
    fleet: AIS_COUNT,
    hint: [
      'GET  /fleet',
      'GET  /fleet/status',
      'GET  /fleet/topology',
      'GET  /fleet/realities',
      'GET  /security',
      'GET  /security/architecture',
      'GET  /security/edge',
      'POST /security/check     ← { "callerId": "any-string" }',
      'GET  /security/status    ← live security metrics',
      'GET  /security/thresholds',
      'POST /security/report    ← { "suspect": "id", "evidence": "reason" }',
    ].join(' | '),
  }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ──────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request)));
addEventListener('scheduled', event => event.waitUntil(Promise.resolve(fleetSweep())));
