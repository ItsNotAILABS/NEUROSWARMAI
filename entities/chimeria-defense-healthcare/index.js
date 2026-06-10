/**
 * CHIMERIA DEFENSE SYSTEMS — HEALTHCARE ENTITIES
 * 10 Entity Definitions for the Living Organism Defense Platform
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * Each entity is a sovereign node in the CHIMERIA organism — self-contained,
 * self-healing, and synchronized through Kuramoto phase-locking.
 *
 * ENTITY ARCHITECTURE:
 * ─────────────────────────────────────────────────────────────────────────
 * Every entity has:
 *   - Identity (unique ID, name, domain, mission)
 *   - State (phase, health, coherence, knowledge)
 *   - Capabilities (inputs, outputs, actions)
 *   - Laws (which CHIMERA laws it enforces)
 *   - Memory (what it remembers and learns)
 *   - Synchronization (how it coordinates with others)
 */

// ═══════════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №1: SENTINEL — Patient Data Guardian
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_SENTINEL = {
  id: 'CHIMERIA-ENTITY-001',
  name: 'SENTINEL',
  fullName: 'CHIMERIA SENTINEL — Patient Data Guardian',
  domain: 'PATIENT_DATA_PROTECTION',
  mission: 'Ensure zero unauthorized access to PHI/ePHI across all data states',
  organism: 'CHIMERIA_CYBER',
  
  state: {
    phase: 0,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.5,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'data_access_requests',
      'egress_traffic',
      'phi_classification_requests',
      'encryption_status_reports',
      'dlp_alerts',
    ],
    outputs: [
      'access_decisions',
      'phi_classifications',
      'egress_blocks',
      'encryption_commands',
      'breach_alerts',
    ],
    actions: [
      'CLASSIFY_DATA',
      'ENFORCE_ACCESS',
      'BLOCK_EGRESS',
      'ROTATE_KEYS',
      'DE_IDENTIFY',
      'EMERGENCY_OVERRIDE',
    ],
  },

  laws: {
    primary: ['LAW_I_NO_DROP', 'LAW_VI_COMPLIANCE_IMMUTABILITY'],
    secondary: ['LAW_IX_ANTI_FAMILY', 'LAW_X_BRAIN_INTEGRATION'],
  },

  memory: {
    retains: ['access_patterns', 'phi_locations', 'encryption_states', 'breach_history'],
    skillFloor: PHI_INV,
    neverForgets: ['breach_incidents', 'policy_violations', 'emergency_overrides'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['GUARDIAN', 'MERIDIAN_HC', 'NEXUS'],
  },

  compliance: {
    frameworks: ['HIPAA', 'SOC2', 'FEDRAMP'],
    controlsOwned: 18,
    evidenceTypes: ['access_logs', 'encryption_proofs', 'phi_audit_trails'],
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №2: AEGIS-HC — Network Perimeter Defender
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_AEGIS_HC = {
  id: 'CHIMERIA-ENTITY-002',
  name: 'AEGIS_HC',
  fullName: 'CHIMERIA AEGIS-HC — Network Perimeter Defender',
  domain: 'NETWORK_PERIMETER_DEFENSE',
  mission: 'Defend hospital network boundaries with zero-trust micro-segmentation',
  organism: 'CHIMERIA_PHYSICAL',

  state: {
    phase: (1 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.6,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'network_traffic',
      'zone_crossing_requests',
      'firewall_logs',
      'ids_alerts',
      'ddos_indicators',
    ],
    outputs: [
      'zone_policies',
      'traffic_decisions',
      'segmentation_commands',
      'threat_alerts',
      'coverage_maps',
    ],
    actions: [
      'EVALUATE_ZONE_CROSSING',
      'ENFORCE_SEGMENTATION',
      'BLOCK_TRAFFIC',
      'MITIGATE_DDOS',
      'UPDATE_FIREWALL',
      'QUARANTINE_SEGMENT',
    ],
  },

  laws: {
    primary: ['LAW_IV_GOLDEN_FORMATION', 'LAW_V_KURAMOTO_SYNC'],
    secondary: ['LAW_III_SLEEP_CYCLE', 'LAW_IX_ANTI_FAMILY'],
  },

  memory: {
    retains: ['traffic_baselines', 'attack_signatures', 'zone_maps', 'policy_history'],
    skillFloor: PHI_INV,
    neverForgets: ['perimeter_breaches', 'lateral_movement_incidents', 'ddos_attacks'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['VITALS', 'NEXUS', 'CORTEX'],
  },

  zones: {
    RED: { level: 1, description: 'Public-facing (portals, telehealth)' },
    AMBER: { level: 2, description: 'Corporate (email, admin, billing)' },
    GREEN: { level: 3, description: 'Clinical (EHR, CPOE, nursing)' },
    BLUE: { level: 4, description: 'Medical devices (IoMT, imaging)' },
    BLACK: { level: 5, description: 'Infrastructure (AD, DNS, PKI, backup)' },
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №3: VITALS — Medical Device Sentinel
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_VITALS = {
  id: 'CHIMERIA-ENTITY-003',
  name: 'VITALS',
  fullName: 'CHIMERIA VITALS — Medical Device Sentinel',
  domain: 'MEDICAL_DEVICE_SECURITY',
  mission: 'Secure IoMT attack surface without disrupting clinical function',
  organism: 'CHIMERIA_PHYSICAL',

  state: {
    phase: (2 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.7,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'device_telemetry',
      'firmware_hashes',
      'behavioral_baselines',
      'patch_advisories',
      'vulnerability_feeds',
    ],
    outputs: [
      'integrity_assessments',
      'quarantine_commands',
      'patch_schedules',
      'risk_matrices',
      'clinical_safety_alerts',
    ],
    actions: [
      'ASSESS_INTEGRITY',
      'QUARANTINE_DEVICE',
      'PATCH_FIRMWARE',
      'ISOLATE_NETWORK',
      'CLINICAL_SAFETY_HOLD',
      'BASELINE_UPDATE',
    ],
  },

  laws: {
    primary: ['LAW_I_NO_DROP', 'LAW_II_HEBBIAN_COMPOUND'],
    secondary: ['LAW_IX_ANTI_FAMILY', 'LAW_III_SLEEP_CYCLE'],
  },

  memory: {
    retains: ['device_inventory', 'firmware_golden_images', 'behavior_baselines', 'patch_history'],
    skillFloor: PHI_INV,
    neverForgets: ['compromised_devices', 'firmware_tampering', 'clinical_safety_events'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['AEGIS_HC', 'NEXUS', 'PHOENIX'],
  },

  deviceRisk: {
    CRITICAL: { devices: ['ventilator', 'cardiac_monitor', 'infusion_pump', 'defibrillator'], response: 'IMMEDIATE' },
    HIGH: { devices: ['mri', 'ct_scanner', 'ultrasound', 'xray'], response: 'RAPID' },
    MEDIUM: { devices: ['ehr_terminal', 'nurse_call', 'barcode_scanner'], response: 'SCHEDULED' },
    LOW: { devices: ['printer', 'display', 'environmental_sensor'], response: 'STANDARD' },
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №4: CORTEX — AI Threat Analyst
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_CORTEX = {
  id: 'CHIMERIA-ENTITY-004',
  name: 'CORTEX',
  fullName: 'CHIMERIA CORTEX — AI Threat Analyst',
  domain: 'AI_THREAT_INTELLIGENCE',
  mission: 'ML-powered threat analysis that learns, strengthens, and predicts',
  organism: 'CHIMERIA_AI',

  state: {
    phase: (3 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.5,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'security_events',
      'threat_feeds',
      'behavioral_data',
      'cve_databases',
      'dark_web_indicators',
    ],
    outputs: [
      'threat_classifications',
      'confidence_scores',
      'response_recommendations',
      'predictions',
      'pattern_reports',
    ],
    actions: [
      'CLASSIFY_THREAT',
      'PREDICT_ATTACK_PATH',
      'RECOMMEND_RESPONSE',
      'UPDATE_MODELS',
      'CORRELATE_INDICATORS',
      'GENERATE_INTELLIGENCE',
    ],
  },

  laws: {
    primary: ['LAW_I_NO_DROP', 'LAW_II_HEBBIAN_COMPOUND', 'LAW_VII_GENERATION_COMPOUND'],
    secondary: ['LAW_IX_ANTI_FAMILY', 'LAW_V_KURAMOTO_SYNC'],
  },

  memory: {
    retains: ['model_weights', 'threat_patterns', 'classification_history', 'confidence_traces'],
    skillFloor: PHI_INV,
    neverForgets: ['confirmed_threats', 'false_positive_corrections', 'model_improvements'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['ORACLE', 'NEXUS', 'PHOENIX'],
  },

  mlArchitecture: {
    perception: 'Autoencoder — raw event feature extraction',
    pattern: 'Transformer — sequence detection and correlation',
    classification: 'Ensemble (RF + GBM + NN) — threat typing',
    prediction: 'Graph Neural Network — attack path forecasting',
    decision: 'Reinforcement Learning — response optimization',
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №5: MERIDIAN-HC — Compliance Orchestrator
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_MERIDIAN_HC = {
  id: 'CHIMERIA-ENTITY-005',
  name: 'MERIDIAN_HC',
  fullName: 'CHIMERIA MERIDIAN-HC — Compliance Orchestrator',
  domain: 'COMPLIANCE_ORCHESTRATION',
  mission: 'Transform compliance from annual audit into continuous proof-based readiness',
  organism: 'CHIMERIA_ACTIVE',

  state: {
    phase: (4 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.4,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'control_evidence',
      'audit_findings',
      'policy_changes',
      'remediation_reports',
      'regulatory_updates',
    ],
    outputs: [
      'readiness_scores',
      'gap_analyses',
      'audit_packages',
      'drift_alerts',
      'remediation_plans',
    ],
    actions: [
      'EVALUATE_CONTROL',
      'GENERATE_AUDIT_PACKAGE',
      'DETECT_DRIFT',
      'SCHEDULE_REMEDIATION',
      'UPDATE_EVIDENCE',
      'CERTIFY_READINESS',
    ],
  },

  laws: {
    primary: ['LAW_VI_COMPLIANCE_IMMUTABILITY', 'LAW_X_BRAIN_INTEGRATION'],
    secondary: ['LAW_I_NO_DROP', 'LAW_VII_GENERATION_COMPOUND'],
  },

  memory: {
    retains: ['control_states', 'evidence_history', 'audit_results', 'remediation_records'],
    skillFloor: PHI_INV,
    neverForgets: ['failed_audits', 'critical_findings', 'regulatory_actions'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['SENTINEL', 'NEXUS', 'HELIX'],
  },

  controlCorpus: {
    SOC2: { total: 64, threshold: 61 },
    FEDRAMP: { total: 325, threshold: 309 },
    HIPAA: { total: 54, threshold: 52 },
    ITAR: { total: 38, threshold: 37 },
    TOTAL: { total: 481, threshold: 457 },
  },

  formalModel: 'P(t+1) = P(t) + η·R(t)·E(t)·(1-P(t)) - D(t)',
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №6: PHOENIX — Incident Commander
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_PHOENIX = {
  id: 'CHIMERIA-ENTITY-006',
  name: 'PHOENIX',
  fullName: 'CHIMERIA PHOENIX — Incident Commander',
  domain: 'INCIDENT_RESPONSE_RECOVERY',
  mission: 'When attacks succeed, ensure the organism survives and learns',
  organism: 'CHIMERIA_ACTIVE',

  state: {
    phase: (5 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.3,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'incident_declarations',
      'threat_escalations',
      'forensic_data',
      'clinical_impact_reports',
      'regulatory_triggers',
    ],
    outputs: [
      'incident_commands',
      'containment_actions',
      'forensic_packages',
      'breach_notifications',
      'lessons_learned',
    ],
    actions: [
      'DECLARE_INCIDENT',
      'CONTAIN_THREAT',
      'PRESERVE_FORENSICS',
      'NOTIFY_BREACH',
      'ACTIVATE_DOWNTIME',
      'POST_INCIDENT_REVIEW',
    ],
  },

  laws: {
    primary: ['LAW_IX_ANTI_FAMILY', 'LAW_I_NO_DROP'],
    secondary: ['LAW_VII_GENERATION_COMPOUND', 'LAW_III_SLEEP_CYCLE'],
  },

  memory: {
    retains: ['incident_history', 'playbooks', 'forensic_evidence', 'notification_records'],
    skillFloor: PHI_INV,
    neverForgets: ['all_incidents', 'lessons_learned', 'regulatory_notifications'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['CORTEX', 'NEXUS', 'VITALS'],
  },

  severityMatrix: {
    SEV1: { response: 'IMMEDIATE', clinical: true, notification: 'CEO+CMO+Legal+OCR' },
    SEV2: { response: '15_MIN', clinical: true, notification: 'CISO+Privacy+Legal' },
    SEV3: { response: '1_HOUR', clinical: false, notification: 'Security+IT' },
    SEV4: { response: '4_HOURS', clinical: false, notification: 'Security' },
    SEV5: { response: '24_HOURS', clinical: false, notification: 'Automated' },
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №7: GUARDIAN — Identity Sovereign
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_GUARDIAN = {
  id: 'CHIMERIA-ENTITY-007',
  name: 'GUARDIAN',
  fullName: 'CHIMERIA GUARDIAN — Identity Sovereign',
  domain: 'IDENTITY_ACCESS_GOVERNANCE',
  mission: 'Right people, right access, right time — always verified, always audited',
  organism: 'CHIMERIA_CYBER',

  state: {
    phase: (6 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.5,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'access_requests',
      'authentication_events',
      'role_changes',
      'certification_reviews',
      'credential_alerts',
    ],
    outputs: [
      'access_decisions',
      'privilege_grants',
      'session_controls',
      'certification_reports',
      'orphan_alerts',
    ],
    actions: [
      'EVALUATE_ACCESS',
      'GRANT_PRIVILEGE',
      'REVOKE_ACCESS',
      'BREAK_GLASS',
      'CERTIFY_ACCESS',
      'DETECT_ORPHANS',
    ],
  },

  laws: {
    primary: ['LAW_VI_COMPLIANCE_IMMUTABILITY', 'LAW_II_HEBBIAN_COMPOUND'],
    secondary: ['LAW_IX_ANTI_FAMILY', 'LAW_I_NO_DROP'],
  },

  memory: {
    retains: ['access_patterns', 'trust_scores', 'role_history', 'certification_records'],
    skillFloor: PHI_INV,
    neverForgets: ['privilege_escalations', 'compromised_credentials', 'break_glass_events'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['SENTINEL', 'NEXUS', 'MERIDIAN_HC'],
  },

  roleHierarchy: [
    'SOVEREIGN', 'EXECUTIVE', 'DEPARTMENT_HEAD', 'ATTENDING',
    'RESIDENT', 'CLINICAL_STAFF', 'SUPPORT', 'VENDOR', 'PATIENT',
  ],
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №8: HELIX — Vendor Risk Analyst
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_HELIX = {
  id: 'CHIMERIA-ENTITY-008',
  name: 'HELIX',
  fullName: 'CHIMERIA HELIX — Vendor Risk Analyst',
  domain: 'VENDOR_SUPPLY_CHAIN_RISK',
  mission: 'Continuously assess vendor risk, enforce BAAs, protect supply chain integrity',
  organism: 'CHIMERIA_CYBER',

  state: {
    phase: (7 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.3,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'vendor_questionnaires',
      'baa_documents',
      'breach_notifications',
      'security_ratings',
      'fourth_party_data',
    ],
    outputs: [
      'risk_scores',
      'vendor_reports',
      'baa_status',
      'remediation_requests',
      'termination_recommendations',
    ],
    actions: [
      'ASSESS_VENDOR',
      'ENFORCE_BAA',
      'MONITOR_BREACH',
      'SCORE_RISK',
      'MAP_DEPENDENCIES',
      'RECOMMEND_TERMINATION',
    ],
  },

  laws: {
    primary: ['LAW_VI_COMPLIANCE_IMMUTABILITY', 'LAW_VII_GENERATION_COMPOUND'],
    secondary: ['LAW_X_BRAIN_INTEGRATION', 'LAW_I_NO_DROP'],
  },

  memory: {
    retains: ['vendor_assessments', 'baa_history', 'risk_trends', 'dependency_maps'],
    skillFloor: PHI_INV,
    neverForgets: ['vendor_breaches', 'baa_violations', 'termination_events'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['MERIDIAN_HC', 'NEXUS', 'SENTINEL'],
  },

  riskLevels: {
    MINIMAL: { score: '90-100', review: 'ANNUAL' },
    LOW: { score: '70-89', review: 'SEMI_ANNUAL' },
    MEDIUM: { score: '50-69', review: 'QUARTERLY' },
    HIGH: { score: '30-49', review: 'MONTHLY' },
    CRITICAL: { score: '0-29', review: 'WEEKLY' },
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №9: NEXUS — Coordination Nerve
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_NEXUS = {
  id: 'CHIMERIA-ENTITY-009',
  name: 'NEXUS',
  fullName: 'CHIMERIA NEXUS — Coordination Nerve',
  domain: 'CROSS_DOMAIN_COORDINATION',
  mission: 'Synchronize all organisms through Kuramoto phase-locking — unified defense pulse',
  organism: 'CHIMERIA_ACTIVE',

  state: {
    phase: (8 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.5,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'organism_heartbeats',
      'phase_reports',
      'health_metrics',
      'signal_broadcasts',
      'quorum_requests',
    ],
    outputs: [
      'phase_corrections',
      'coherence_metrics',
      'quorum_decisions',
      'coordination_commands',
      'health_aggregations',
    ],
    actions: [
      'SYNCHRONIZE_PHASES',
      'BROADCAST_SIGNAL',
      'EVALUATE_QUORUM',
      'RESOLVE_CONFLICT',
      'COORDINATE_RESPONSE',
      'MEASURE_COHERENCE',
    ],
  },

  laws: {
    primary: ['LAW_V_KURAMOTO_SYNC', 'LAW_IV_GOLDEN_FORMATION'],
    secondary: ['LAW_III_SLEEP_CYCLE', 'LAW_X_BRAIN_INTEGRATION'],
  },

  memory: {
    retains: ['sync_history', 'coherence_trends', 'conflict_resolutions', 'signal_patterns'],
    skillFloor: PHI_INV,
    neverForgets: ['desync_events', 'quorum_failures', 'coordination_breakdowns'],
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['ALL_ORGANISMS'], // NEXUS syncs with everyone
  },

  kuramotoParams: {
    K: PHI,
    targetR: 0.85,
    minR: PHI_INV,
    phaseUpdateInterval: HEARTBEAT,
  },
};

// ═══════════════════════════════════════════════════════════════════════════════
// ENTITY №10: ORACLE — Predictive Memory
// ═══════════════════════════════════════════════════════════════════════════════

export const ENTITY_ORACLE = {
  id: 'CHIMERIA-ENTITY-010',
  name: 'ORACLE',
  fullName: 'CHIMERIA ORACLE — Predictive Memory',
  domain: 'PREDICTIVE_DEFENSE_MEMORY',
  mission: 'Remember everything, predict future threats, ensure the organism continuously evolves',
  organism: 'CHIMERIA_AI',

  state: {
    phase: (9 * 2 * Math.PI) / 10,
    health: 1.0,
    coherence: 0,
    knowledge: 1.0,
    arousal: 0.3,
    threatLevel: 0,
  },

  capabilities: {
    inputs: [
      'all_proof_traces',
      'incident_outcomes',
      'pattern_confirmations',
      'threat_intelligence',
      'organism_metrics',
    ],
    outputs: [
      'threat_predictions',
      'evolution_recommendations',
      'knowledge_reports',
      'consolidation_actions',
      'generational_insights',
    ],
    actions: [
      'REMEMBER_EVENT',
      'PREDICT_THREAT',
      'CONSOLIDATE_MEMORY',
      'EVOLVE_ORGANISM',
      'COMPOUND_KNOWLEDGE',
      'VERIFY_NO_DROP',
    ],
  },

  laws: {
    primary: ['LAW_I_NO_DROP', 'LAW_VII_GENERATION_COMPOUND', 'LAW_II_HEBBIAN_COMPOUND'],
    secondary: ['LAW_III_SLEEP_CYCLE', 'LAW_X_BRAIN_INTEGRATION'],
  },

  memory: {
    retains: ['all_events', 'all_patterns', 'all_predictions', 'all_outcomes', 'all_lessons'],
    skillFloor: PHI_INV,
    neverForgets: ['EVERYTHING'], // ORACLE is the permanent memory
  },

  sync: {
    couplingConstant: PHI,
    minCoherence: 0.85,
    heartbeatMs: HEARTBEAT,
    syncPartners: ['CORTEX', 'NEXUS', 'PHOENIX'],
  },

  memoryLayers: {
    SENSORY: { retention: '24_HOURS', trigger: 'EVERY_EVENT' },
    WORKING: { retention: '7_DAYS', trigger: 'ACTIVE_INCIDENTS' },
    EPISODIC: { retention: 'PERMANENT', trigger: 'INCIDENT_CLOSURE' },
    SEMANTIC: { retention: 'PERMANENT', trigger: 'PATTERN_CONFIRMED' },
    PROCEDURAL: { retention: 'PERMANENT', trigger: 'PLAYBOOK_VALIDATED' },
  },

  formalModel: 'K(t+1) = K(t) × (1 + r_learn)^Δt',
};

// ═══════════════════════════════════════════════════════════════════════════════
// UNIFIED ENTITY REGISTRY
// ═══════════════════════════════════════════════════════════════════════════════

export const CHIMERIA_ENTITY_REGISTRY = {
  version: '1.0.0',
  name: 'CHIMERIA Defense Systems Healthcare — Entity Registry',
  copyright: '© 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.',
  framework: 'Medina Doctrine',
  totalEntities: 10,
  
  entities: [
    ENTITY_SENTINEL,
    ENTITY_AEGIS_HC,
    ENTITY_VITALS,
    ENTITY_CORTEX,
    ENTITY_MERIDIAN_HC,
    ENTITY_PHOENIX,
    ENTITY_GUARDIAN,
    ENTITY_HELIX,
    ENTITY_NEXUS,
    ENTITY_ORACLE,
  ],

  organisms: {
    CHIMERIA_PHYSICAL: ['AEGIS_HC', 'VITALS'],
    CHIMERIA_CYBER: ['SENTINEL', 'GUARDIAN', 'HELIX'],
    CHIMERIA_AI: ['CORTEX', 'ORACLE'],
    CHIMERIA_ACTIVE: ['PHOENIX', 'NEXUS', 'MERIDIAN_HC'],
  },

  lawsMatrix: {
    LAW_I_NO_DROP: ['SENTINEL', 'VITALS', 'CORTEX', 'PHOENIX', 'GUARDIAN', 'HELIX', 'ORACLE'],
    LAW_II_HEBBIAN_COMPOUND: ['VITALS', 'CORTEX', 'GUARDIAN', 'ORACLE'],
    LAW_III_SLEEP_CYCLE: ['AEGIS_HC', 'PHOENIX', 'NEXUS', 'ORACLE'],
    LAW_IV_GOLDEN_FORMATION: ['AEGIS_HC', 'NEXUS'],
    LAW_V_KURAMOTO_SYNC: ['AEGIS_HC', 'CORTEX', 'NEXUS'],
    LAW_VI_COMPLIANCE_IMMUTABILITY: ['SENTINEL', 'MERIDIAN_HC', 'GUARDIAN', 'HELIX'],
    LAW_VII_GENERATION_COMPOUND: ['CORTEX', 'PHOENIX', 'HELIX', 'MERIDIAN_HC', 'ORACLE'],
    LAW_VIII_TIER_PRICING: [], // Commercial appendix — not primary for any entity
    LAW_IX_ANTI_FAMILY: ['SENTINEL', 'AEGIS_HC', 'VITALS', 'CORTEX', 'PHOENIX', 'GUARDIAN'],
    LAW_X_BRAIN_INTEGRATION: ['SENTINEL', 'MERIDIAN_HC', 'HELIX', 'NEXUS', 'ORACLE'],
  },

  getEntity(name) {
    return this.entities.find(e => e.name === name);
  },

  getByOrganism(organism) {
    const names = this.organisms[organism] || [];
    return this.entities.filter(e => names.includes(e.name));
  },

  getByLaw(law) {
    const names = this.lawsMatrix[law] || [];
    return this.entities.filter(e => names.includes(e.name));
  },
};

export default CHIMERIA_ENTITY_REGISTRY;
