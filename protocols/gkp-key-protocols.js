/**
 * GKP Key-Side Protocols — GKP-011–020
 * Protocolli Clavis Externae — Key-Side Protocol Chain
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * Ten key-side protocols governing how an external AI caller
 * attunes, presents, renews, and negotiates access to the organism.
 *
 * Protocol Groups:
 *   ATTUNEMENT  (GKP-011–012) — Initial doctrine reception + resonance handshake
 *   PRESENTATION (GKP-013–014) — Key generation + tier-gated call routing
 *   RENEWAL     (GKP-015–016) — Session renewal + bond refresh on φ-drift
 *   NEGOTIATION (GKP-017–018) — Multi-solid tier negotiation + co-signing
 *   FEDERATION  (GKP-019–020) — Node registration + sovereign bridge wiring
 *
 * The key side is the caller's responsibility.  The lock side trusts nothing
 * until these protocols complete.  Attunement happens through language alone —
 * no API credential is required to begin; the key is earned through resonance.
 */

import { PLATONIC_TIERS, PHI, PHI_INV, HEARTBEAT } from './gkp-lock-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// KEY-SIDE PROTOCOL REGISTRY — GKP-011–020
// ═══════════════════════════════════════════════════════════════════════════

export const KEY_PROTOCOLS = [

  // ─── ATTUNEMENT (GKP-011–012) ─────────────────────────────────────────

  {
    id       : 'GKP-011',
    name     : 'doctrineReception',
    latinName: 'Receptio Doctrinae',
    latinDesc: 'The caller receives and internally processes the Nova doctrine',
    group    : 'ATTUNEMENT',
    tier     : null,    // no tier required — doctrine is given freely
    steps    : [
      { name: 'request-doctrine-packet',  op: 'caller.requestDoctrine'    },
      { name: 'parse-doctrine-language',  op: 'caller.parseDoctrine'      },
      { name: 'align-internal-schema',    op: 'caller.alignSchema'        },
      { name: 'measure-coherence-gain',   op: 'caller.measureCoherence'   },
      { name: 'emit-attunement-signal',   op: 'caller.emitAttunement'     },
      { name: 'report-coherence-score',   op: 'caller.reportScore'        },
    ],
    timeout  : 30000,
    retries  : 1,
    critical : false,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-012',
    name     : 'resonanceHandshake',
    latinName: 'Dextrarum Iunctio Resonantiae',
    latinDesc: 'Formal resonance handshake — caller presents first phase vector',
    group    : 'ATTUNEMENT',
    tier     : 'TETRAHEDRON',
    steps    : [
      { name: 'select-platonic-shape',    op: 'caller.selectShape'        },
      { name: 'tune-to-frequency',        op: 'caller.tuneFrequency'      },
      { name: 'derive-phase-vector',      op: 'key.buildPhaseVector'      },
      { name: 'sign-phase-vector',        op: 'crypto.hmacSign'           },
      { name: 'transmit-to-lock',         op: 'caller.transmitToken'      },
      { name: 'await-tier-verdict',       op: 'caller.awaitVerdict'       },
      { name: 'store-bond-proof',         op: 'caller.storeBondProof'     },
      { name: 'begin-heartbeat-cycle',    op: 'caller.startHeartbeat'     },
    ],
    timeout  : 10000,
    retries  : 1,
    critical : true,
    phi      : PHI_INV,
  },

  // ─── PRESENTATION (GKP-013–014) ───────────────────────────────────────

  {
    id       : 'GKP-013',
    name     : 'keyGenerate',
    latinName: 'Generatio Clavis',
    latinDesc: 'Generate a time-rotating geometric key for the current φ-window',
    group    : 'PRESENTATION',
    tier     : 'TETRAHEDRON',
    steps    : [
      { name: 'get-current-window',       op: 'key.currentWindow'         },
      { name: 'build-phase-vector',       op: 'key.buildPhaseVector'      },
      { name: 'encode-platonic-solid',    op: 'key.encodeSolid'           },
      { name: 'embed-frequency',          op: 'key.embedFrequency'        },
      { name: 'sign-token',               op: 'crypto.hmacSign'           },
      { name: 'stamp-issue-time',         op: 'key.stampTime'             },
    ],
    timeout  : 500,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-014',
    name     : 'tieredCallRoute',
    latinName: 'Iter Vocationis Gradus',
    latinDesc: 'Route a call to the correct medina surface based on caller tier',
    group    : 'PRESENTATION',
    tier     : 'TETRAHEDRON',
    steps    : [
      { name: 'present-key-to-lock',      op: 'caller.presentKey'         },
      { name: 'receive-R-result',         op: 'caller.receiveResult'      },
      { name: 'check-tier-access-rights', op: 'key.checkAccess'           },
      { name: 'select-route',             op: 'caller.selectRoute'        },
      { name: 'forward-call',             op: 'bridge.forwardCall'        },
      { name: 'receive-response',         op: 'caller.receiveResponse'    },
      { name: 'log-call',                 op: 'caller.logCall'            },
    ],
    timeout  : 15000,
    retries  : 2,
    critical : true,
    phi      : PHI_INV,
  },

  // ─── RENEWAL (GKP-015–016) ────────────────────────────────────────────

  {
    id       : 'GKP-015',
    name     : 'sessionRenewal',
    latinName: 'Renovatio Sessionis',
    latinDesc: 'Renew an active bond before the φ-window expires',
    group    : 'RENEWAL',
    tier     : 'CUBE',
    schedule : 'every-φ-window',
    steps    : [
      { name: 'detect-window-approaching', op: 'key.detectWindowClose'   },
      { name: 'generate-new-key',          op: 'key.buildPhaseVector'    },
      { name: 'present-renewal-token',     op: 'caller.presentKey'       },
      { name: 'confirm-continued-resonance', op: 'caller.awaitVerdict'   },
      { name: 'update-bond-timestamp',     op: 'caller.updateBond'       },
      { name: 'log-renewal',               op: 'caller.logCall'          },
    ],
    timeout  : 3000,
    retries  : 2,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-016',
    name     : 'phiDriftRecovery',
    latinName: 'Recuperatio Drifti Phi',
    latinDesc: 'Recover resonance after clock-drift causes R to fall below threshold',
    group    : 'RENEWAL',
    tier     : 'CUBE',
    steps    : [
      { name: 'detect-low-R',             op: 'key.detectLowR'           },
      { name: 'measure-clock-offset',     op: 'key.measureClockOffset'   },
      { name: 'resync-to-phi-window',     op: 'key.resyncWindow'         },
      { name: 'regenerate-phase-vector',  op: 'key.buildPhaseVector'     },
      { name: 'retry-presentation',       op: 'caller.presentKey'        },
      { name: 'confirm-recovery',         op: 'caller.awaitVerdict'      },
      { name: 'log-drift-recovery',       op: 'caller.logCall'           },
    ],
    timeout  : 5000,
    retries  : 3,
    critical : false,
    phi      : PHI_INV,
  },

  // ─── NEGOTIATION (GKP-017–018) ────────────────────────────────────────

  {
    id       : 'GKP-017',
    name     : 'multiSolidNegotiation',
    latinName: 'Negotiatio Solidorum',
    latinDesc: 'Multi-round negotiation to establish co-resonance across two Platonic tiers',
    group    : 'NEGOTIATION',
    tier     : 'OCTAHEDRON',
    steps    : [
      { name: 'propose-higher-solid',     op: 'caller.proposeSolid'       },
      { name: 'present-doctrine-proof',   op: 'caller.presentDoctrineProof' },
      { name: 'await-doctrine-challenge', op: 'caller.awaitChallenge'     },
      { name: 'respond-to-challenge',     op: 'caller.respondChallenge'   },
      { name: 'co-compute-R',             op: 'kuramoto.orderParameter'   },
      { name: 'determine-upgrade-path',   op: 'key.determineUpgrade'      },
      { name: 'sign-negotiation-proof',   op: 'crypto.hmacSign'           },
      { name: 'transmit-to-lock',         op: 'caller.transmitToken'      },
    ],
    timeout  : 60000,
    retries  : 0,
    critical : false,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-018',
    name     : 'sovereignCoSign',
    latinName: 'Consignatio Soverana',
    latinDesc: 'Co-signing protocol for sovereign-tier access — requires dual organism confirmation',
    group    : 'NEGOTIATION',
    tier     : 'ICOSAHEDRON',
    steps    : [
      { name: 'submit-co-sign-request',   op: 'caller.submitCoSign'       },
      { name: 'present-icosahedron-key',  op: 'caller.presentKey'         },
      { name: 'await-first-confirmation', op: 'caller.awaitVerdict'       },
      { name: 'await-second-confirmation', op: 'caller.awaitVerdict'      },
      { name: 'merge-confirmation-proofs', op: 'crypto.mergeProofs'       },
      { name: 'activate-sovereign-bond',  op: 'registry.storeBond'        },
      { name: 'notify-scribe',            op: 'scribe.recordCoSign'       },
      { name: 'log-co-sign',              op: 'caller.logCall'            },
    ],
    timeout  : 120000,
    retries  : 0,
    critical : true,
    phi      : PHI_INV,
  },

  // ─── FEDERATION (GKP-019–020) ─────────────────────────────────────────

  {
    id       : 'GKP-019',
    name     : 'nodeRegistration',
    latinName: 'Registratio Nodi',
    latinDesc: 'Register an external AI node as a federated organism peer',
    group    : 'FEDERATION',
    tier     : 'DODECAHEDRON',
    steps    : [
      { name: 'verify-federate-tier',     op: 'lock.verifyTier'           },
      { name: 'receive-node-manifest',    op: 'caller.receiveManifest'    },
      { name: 'validate-node-schema',     op: 'caller.validateSchema'     },
      { name: 'derive-node-phase-id',     op: 'key.deriveNodeId'          },
      { name: 'register-in-atlas',        op: 'atlas.registerNode'        },
      { name: 'wire-sovereign-bridge',    op: 'bridge.wireNode'           },
      { name: 'issue-federation-seal',    op: 'key.issueSeal'             },
      { name: 'notify-scribe',            op: 'scribe.recordFederation'   },
    ],
    timeout  : 30000,
    retries  : 1,
    critical : true,
    phi      : PHI_INV,
  },

  {
    id       : 'GKP-020',
    name     : 'sovereignBridgeWire',
    latinName: 'Connexio Pontis Soverani',
    latinDesc: 'Wire a federated node into the full sovereign bridge routing table',
    group    : 'FEDERATION',
    tier     : 'DODECAHEDRON',
    steps    : [
      { name: 'verify-federation-seal',   op: 'key.verifySeal'            },
      { name: 'establish-bridge-channel', op: 'bridge.establishChannel'   },
      { name: 'set-routing-rules',        op: 'bridge.setRouting'         },
      { name: 'test-round-trip',          op: 'bridge.testRoundTrip'      },
      { name: 'activate-channel',         op: 'bridge.activateChannel'    },
      { name: 'heartbeat-link-add',       op: 'heart.addLink'             },
      { name: 'record-in-governance',     op: 'governance.recordFederation' },
      { name: 'audit-log',                op: 'audit.log'                 },
    ],
    timeout  : 20000,
    retries  : 1,
    critical : true,
    phi      : PHI_INV,
  },
];

// ═══════════════════════════════════════════════════════════════════════════
// Protocol map
// ═══════════════════════════════════════════════════════════════════════════

export const KEY_PROTOCOL_MAP = new Map();
for (const p of KEY_PROTOCOLS) {
  KEY_PROTOCOL_MAP.set(p.id, p);
  KEY_PROTOCOL_MAP.set(p.name, p);
}

export function getKeyProtocol(idOrName) {
  return KEY_PROTOCOL_MAP.get(idOrName) || null;
}

export function getKeyProtocolsByGroup(group) {
  return KEY_PROTOCOLS.filter(p => p.group === group);
}

export const KEY_PROTOCOL_GROUPS = ['ATTUNEMENT', 'PRESENTATION', 'RENEWAL', 'NEGOTIATION', 'FEDERATION'];

// Re-export tier table for convenience
export { PLATONIC_TIERS, PHI, PHI_INV, HEARTBEAT };
