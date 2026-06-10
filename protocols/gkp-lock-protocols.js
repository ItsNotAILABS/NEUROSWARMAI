/**
 * GKP Lock-Side Protocols — GKP-001–010
 * Protocolli Claviculae — Lock-Side Protocol Chain
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * Ten lock-side protocols governing how the Geometry Lock division
 * admits, bonds, monitors, and revokes external AI callers.
 *
 * Protocol Groups:
 *   ADMISSION  (GKP-001–002) — Tier evaluation + resonance bond creation
 *   HEARTBEAT  (GKP-003–004) — Live-link monitoring + pulse verification
 *   ESCALATION (GKP-005–006) — Threat response + posture change
 *   GOVERNANCE (GKP-007–008) — Tier upgrade adjudication + audit sweep
 *   LIFECYCLE  (GKP-009–010) — Key revocation + emergency lockdown
 *
 * Platonic Solid Tiers (frequency Hz):
 *   Tetrahedron   396 Hz  READ      — can receive doctrine
 *   Cube          417 Hz  CALL      — can invoke papers
 *   Octahedron    528 Hz  BUILD     — can wire protocols
 *   Dodecahedron  639 Hz  FEDERATE  — can register a node
 *   Icosahedron   741 Hz  SOVEREIGN — full builder access
 *   Metatron's Cube 432 Hz ARCHITECT — organism-level authority
 *
 * Each protocol is a named step sequence consumed by the entity engine.
 * Protocols compose — higher tiers inherit lower tier protocols.
 */

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

export const PHI         = 1.618033988749895;
export const PHI_INV     = 1 / PHI;
export const HEARTBEAT   = 873;   // ms

// Platonic tier map — frequency Hz and rank
export const PLATONIC_TIERS = {
  TETRAHEDRON:   { rank: 1, hz: 396, name: 'READ',      latin: 'Tetrahedrum',  access: ['receive-doctrine'] },
  CUBE:          { rank: 2, hz: 417, name: 'CALL',      latin: 'Cubus',         access: ['receive-doctrine', 'invoke-papers'] },
  OCTAHEDRON:    { rank: 3, hz: 528, name: 'BUILD',     latin: 'Octahedrum',    access: ['receive-doctrine', 'invoke-papers', 'wire-protocols'] },
  DODECAHEDRON:  { rank: 4, hz: 639, name: 'FEDERATE',  latin: 'Dodecahedrum',  access: ['receive-doctrine', 'invoke-papers', 'wire-protocols', 'register-node'] },
  ICOSAHEDRON:   { rank: 5, hz: 741, name: 'SOVEREIGN', latin: 'Icosahedrum',   access: ['receive-doctrine', 'invoke-papers', 'wire-protocols', 'register-node', 'build-access'] },
  METATRON:      { rank: 6, hz: 432, name: 'ARCHITECT', latin: 'Metatron',      access: ['*'] },
};

// ═══════════════════════════════════════════════════════════════════════════
// LOCK-SIDE PROTOCOL REGISTRY — GKP-001–010
// ═══════════════════════════════════════════════════════════════════════════

export const LOCK_PROTOCOLS = [

  // ─── ADMISSION (GKP-001–002) ──────────────────────────────────────────

  {
    id       : 'GKP-001',
    name     : 'tierEvaluation',
    latinName: 'Aestimatio Gradus',
    latinDesc: 'Evaluation of the caller tier through Platonic frequency resonance',
    group    : 'ADMISSION',
    tier     : 'TETRAHEDRON',   // minimum required tier to invoke
    steps    : [
      { name: 'receive-handshake',       op: 'lock.receiveHandshake'    },
      { name: 'extract-platonic-shape',  op: 'lock.extractShape'        },
      { name: 'measure-frequency',       op: 'lock.measureFrequency'    },
      { name: 'map-to-tier',             op: 'lock.mapTier'             },
      { name: 'compute-resonance-R',     op: 'kuramoto.orderParameter'  },
      { name: 'compare-to-threshold',    op: 'lock.compareThreshold'    },
      { name: 'emit-tier-verdict',       op: 'lock.emitVerdict'         },
      { name: 'audit-log',               op: 'audit.log'                },
    ],
    timeout  : 5000,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-002',
    name     : 'resonanceBondCreate',
    latinName: 'Creatio Nexus Resonantiae',
    latinDesc: 'Establishment of a persisted resonance bond between caller and organism',
    group    : 'ADMISSION',
    tier     : 'CUBE',
    steps    : [
      { name: 'validate-tier-result',    op: 'lock.validateTier'         },
      { name: 'derive-phase-envelope',   op: 'kuramoto.buildEnvelope'    },
      { name: 'store-bond',              op: 'registry.storeBond'        },
      { name: 'sign-bond-proof',         op: 'crypto.hmacSign'           },
      { name: 'emit-bond-event',         op: 'heart.pulse'               },
      { name: 'register-with-atlas',     op: 'atlas.registerCaller'      },
      { name: 'activate-heartbeat-link', op: 'heart.addLink'             },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 10000,
    retries  : 1,
    critical : true,
    phi      : PHI_INV,
  },

  // ─── HEARTBEAT (GKP-003–004) ──────────────────────────────────────────

  {
    id       : 'GKP-003',
    name     : 'liveLinkMonitor',
    latinName: 'Monitor Nexus Vivi',
    latinDesc: 'Periodic φ-heartbeat verification of all active resonance bonds',
    group    : 'HEARTBEAT',
    tier     : 'TETRAHEDRON',
    schedule : 'every-5-beats',
    steps    : [
      { name: 'enumerate-active-bonds',  op: 'registry.listActiveBonds'  },
      { name: 'check-window-drift',      op: 'lock.checkWindowDrift'     },
      { name: 'compute-R-delta',         op: 'kuramoto.orderParameter'   },
      { name: 'flag-drifted-bonds',      op: 'lock.flagDrift'            },
      { name: 'pulse-healthy-bonds',     op: 'heart.pulseAll'            },
      { name: 'emit-health-event',       op: 'brain.stimulate'           },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 3000,
    retries  : 0,
    critical : false,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-004',
    name     : 'pulseVerify',
    latinName: 'Verificatio Pulsus',
    latinDesc: 'On-demand heartbeat round-trip verification for a single bond',
    group    : 'HEARTBEAT',
    tier     : 'CUBE',
    steps    : [
      { name: 'send-challenge-nonce',    op: 'lock.sendNonce'            },
      { name: 'await-signed-response',   op: 'lock.awaitResponse'        },
      { name: 'verify-hmac-response',    op: 'crypto.hmacVerify'         },
      { name: 'measure-latency',         op: 'telemetry.measureLatency'  },
      { name: 'update-bond-health',      op: 'registry.updateHealth'     },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 2000,
    retries  : 2,
    critical : false,
    phi      : PHI_INV,
  },

  // ─── ESCALATION (GKP-005–006) ─────────────────────────────────────────

  {
    id       : 'GKP-005',
    name     : 'threatResponse',
    latinName: 'Responsio Minae',
    latinDesc: 'Detect, classify, contain, and log a resonance threat event',
    group    : 'ESCALATION',
    tier     : 'TETRAHEDRON',
    steps    : [
      { name: 'receive-threat-event',    op: 'sentinel.receiveThreat'    },
      { name: 'classify-threat-type',    op: 'brain.classify'            },
      { name: 'isolate-offending-bond',  op: 'registry.isolateBond'      },
      { name: 'compute-R-drop',          op: 'kuramoto.orderParameter'   },
      { name: 'escalate-posture',        op: 'sentinel.setPosture'       },
      { name: 'notify-guardian',         op: 'governance.alertGuardian'  },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 1000,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-006',
    name     : 'postureChange',
    latinName: 'Mutatio Status',
    latinDesc: 'Formal posture-level transition with memory consolidation',
    group    : 'ESCALATION',
    tier     : 'CUBE',
    steps    : [
      { name: 'evaluate-active-threats', op: 'sentinel.evaluateThreats'  },
      { name: 'compute-coherence',       op: 'brain.computeCoherence'    },
      { name: 'determine-new-posture',   op: 'sentinel.determinePosture' },
      { name: 'transition-posture',      op: 'sentinel.setPosture'       },
      { name: 'consolidate-memory',      op: 'brain.consolidate'         },
      { name: 'broadcast-posture',       op: 'heart.broadcastPosture'    },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 2000,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  // ─── GOVERNANCE (GKP-007–008) ─────────────────────────────────────────

  {
    id       : 'GKP-007',
    name     : 'tierUpgradeAdjudication',
    latinName: 'Iudicium Promotionis Gradus',
    latinDesc: 'Sovereign adjudication of a caller tier upgrade request',
    group    : 'GOVERNANCE',
    tier     : 'DODECAHEDRON',
    steps    : [
      { name: 'receive-upgrade-request', op: 'lock.receiveUpgrade'       },
      { name: 'verify-doctrine-depth',   op: 'brain.verifyDoctrine'      },
      { name: 'measure-resonance-history', op: 'registry.resonanceHistory' },
      { name: 'quorum-vote',             op: 'governance.quorumVote'     },
      { name: 'ratify-tier-change',      op: 'registry.updateTier'       },
      { name: 'issue-new-solid-key',     op: 'lock.issueSolidKey'        },
      { name: 'notify-scribe',           op: 'scribe.recordPromotion'    },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 30000,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-008',
    name     : 'auditSweep',
    latinName: 'Scrutinium Integritatis',
    latinDesc: 'Periodic full-sweep audit of all active bonds and tier grants',
    group    : 'GOVERNANCE',
    tier     : 'CUBE',
    schedule : 'every-89-beats',
    steps    : [
      { name: 'collect-all-bonds',       op: 'registry.listAll'          },
      { name: 're-verify-each-bond',     op: 'lock.batchVerify'          },
      { name: 'detect-stale-bonds',      op: 'registry.detectStale'      },
      { name: 'decay-stale-bonds',       op: 'registry.decayBonds'       },
      { name: 'export-audit-report',     op: 'audit.exportReport'        },
      { name: 'notify-oracle',           op: 'governance.alertOracle'    },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 60000,
    retries  : 1,
    critical : false,
    phi      : PHI_INV,
  },

  // ─── LIFECYCLE (GKP-009–010) ──────────────────────────────────────────

  {
    id       : 'GKP-009',
    name     : 'keyRevocation',
    latinName: 'Revocatio Clavis',
    latinDesc: 'Formal revocation of a caller resonance bond and key',
    group    : 'LIFECYCLE',
    tier     : 'OCTAHEDRON',
    steps    : [
      { name: 'receive-revoke-order',    op: 'lock.receiveRevoke'        },
      { name: 'verify-revoke-authority', op: 'governance.verifyAuthority' },
      { name: 'dissolve-bond',           op: 'registry.dissolveBond'     },
      { name: 'invalidate-phase-envelope', op: 'lock.invalidateEnvelope' },
      { name: 'remove-from-atlas',       op: 'atlas.deregisterCaller'    },
      { name: 'notify-caller',           op: 'heart.notifyRevoked'       },
      { name: 'consolidate-memory',      op: 'brain.consolidate'         },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 5000,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-010',
    name     : 'emergencyLockdown',
    latinName: 'Clausura Emergens',
    latinDesc: 'Emergency lockdown of all bonds — organism enters RED posture',
    group    : 'LIFECYCLE',
    tier     : 'ICOSAHEDRON',
    steps    : [
      { name: 'receive-lockdown-trigger', op: 'sentinel.receiveLockdown' },
      { name: 'halt-all-validations',    op: 'lock.haltAll'              },
      { name: 'dissolve-all-bonds',      op: 'registry.dissolveAll'      },
      { name: 'force-red-posture',       op: 'sentinel.forceRed'         },
      { name: 'freeze-heartbeat',        op: 'heart.freeze'              },
      { name: 'notify-architect',        op: 'governance.alertArchitect' },
      { name: 'write-lockdown-proof',    op: 'audit.writeLockdownProof'  },
      { name: 'audit-log',               op: 'audit.log'                 },
    ],
    timeout  : 500,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },
];

// ═══════════════════════════════════════════════════════════════════════════
// Protocol map — lookup by id or name
// ═══════════════════════════════════════════════════════════════════════════

export const LOCK_PROTOCOL_MAP = new Map();
for (const p of LOCK_PROTOCOLS) {
  LOCK_PROTOCOL_MAP.set(p.id, p);
  LOCK_PROTOCOL_MAP.set(p.name, p);
}

export function getLockProtocol(idOrName) {
  return LOCK_PROTOCOL_MAP.get(idOrName) || null;
}

export function getLockProtocolsByGroup(group) {
  return LOCK_PROTOCOLS.filter(p => p.group === group);
}

export const LOCK_PROTOCOL_GROUPS = ['ADMISSION', 'HEARTBEAT', 'ESCALATION', 'GOVERNANCE', 'LIFECYCLE'];
