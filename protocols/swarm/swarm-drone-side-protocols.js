/**
 * PROTO-255 through PROTO-262 — DRONE SIDE ENGINE Protocols
 * Domain: SovereignDroneEdge — On-node engines for NeuroSwarm / CHIMERIA
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * ZERO EXTERNAL DEPENDENCIES
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_BEAT = 873;
const KURAMOTO_MIN = 0.85;
const THREAT_THRESHOLD = 0.55;
const THREAT_FAST_MS = 12;

const DRONE_SIDE_ENGINES = ['DSEN', 'DNAV', 'DMESH', 'DTHR', 'DFORM', 'DRT'];

const DRONE_LAWS = [
  {
    id: 'NSW-L001_KURAMOTO_COHERENCE',
    severity: 'CRITICAL',
    action: 'HOLD_ACTUATION',
    check: (ctx) => ctx.kuramotoR < KURAMOTO_MIN,
  },
  {
    id: 'NSW-L002_THREAT_FAST_PATH',
    severity: 'HIGH',
    action: 'ALERT_GUARDIAN',
    check: (ctx) => ctx.threatDecisionMs > THREAT_FAST_MS,
  },
  {
    id: 'NSW-L003_GPS_DENIED_NAV',
    severity: 'HIGH',
    action: 'DEGRADE_TO_INERTIAL',
    check: (ctx) => ctx.gpsDenied && !ctx.navOk,
  },
  {
    id: 'NSW-L004_JAM_FAILOVER',
    severity: 'CRITICAL',
    action: 'SWITCH_ORBITAL_ROUTE',
    check: (ctx) => ctx.groundJammed && ctx.accessMode !== 'orbital_preferred',
  },
  {
    id: 'NSW-L005_MESH_PARTITION',
    severity: 'HIGH',
    action: 'GOSSIP_HEAL',
    check: (ctx) => ctx.meshPartitions > 0,
  },
  {
    id: 'NSW-L006_FORMATION_INTEGRITY',
    severity: 'MEDIUM',
    action: 'REFORM_LATTICE',
    check: (ctx) => ctx.formationError > PHI_INV,
  },
  {
    id: 'NSW-L007_SIDE_ENGINE_ATTEST',
    severity: 'CRITICAL',
    action: 'BLOCK_TICK',
    check: (ctx) => !DRONE_SIDE_ENGINES.every((e) => ctx.enginesAttested.includes(e)),
  },
  {
    id: 'NSW-L008_ROE_GATE',
    severity: 'CRITICAL',
    action: 'BLOCK_ACTUATION',
    check: (ctx) => ctx.actuationRequested && ctx.roeScore < 0.5,
  },
];

function evaluateDroneLaws(ctx) {
  const violations = [];
  for (const law of DRONE_LAWS) {
    if (law.check(ctx)) {
      violations.push({
        lawId: law.id,
        severity: law.severity,
        action: law.action,
      });
    }
  }
  return violations;
}

/** PROTO-255: Sensor ingest + fusion */
function droneSensorIngest(readings) {
  const imu = readings?.imu || [0, 0, 9.81];
  const gps = readings?.gps || { fix: true };
  const baro = readings?.baro || { altitude_m: 100 };
  const gpsConf = gps.fix ? 0.9 : 0;
  const baroConf = 0.7;
  const fusedAlt =
    (gpsConf * baro.altitude_m + baroConf * baro.altitude_m) /
    Math.max(gpsConf + baroConf, 1e-9);
  const imuNorm = Math.sqrt(imu.reduce((s, x) => s + x * x, 0));
  return {
    protocol: 'PROTO-255',
    engine: 'DSEN',
    fusedAltitudeM: fusedAlt,
    imuNorm,
    gpsFix: !!gps.fix,
  };
}

/** PROTO-256: Edge navigation solve */
function droneNavigationSolve(fused, options = {}) {
  const gpsDenied = !!options.gpsDenied;
  const velocity = options.velocity || [0.1, 0, 0];
  const dt = PHI_BEAT / 1000;
  let position = options.position || [0, 0, fused.fusedAltitudeM || 100];
  let navOk;
  if (gpsDenied) {
    position = [
      position[0] + velocity[0] * dt,
      position[1] + velocity[1] * dt,
      position[2] + velocity[2] * dt,
    ];
    navOk = true;
  } else {
    position = [0, 0, fused.fusedAltitudeM || 100];
    navOk = !!fused.gpsFix;
  }
  return {
    protocol: 'PROTO-256',
    engine: 'DNAV',
    navOk,
    position,
    gpsDenied,
  };
}

/** PROTO-257: Local gossip mesh tick */
function droneMeshGossipTick(agentId, neighborVotes = [], localThreat = false) {
  const votes = [localThreat, ...neighborVotes];
  const threatVotes = votes.filter(Boolean).length;
  const consensusThreat = threatVotes > votes.length / 2;
  const meshPartitions = neighborVotes.length === 0 && agentId !== 'solo' ? 1 : 0;
  return {
    protocol: 'PROTO-257',
    engine: 'DMESH',
    consensusThreat,
    meshPartitions,
    voteRatio: threatVotes / Math.max(votes.length, 1),
  };
}

/** PROTO-258: Spectral threat fast path */
function droneSpectralThreat(spectrum = []) {
  const t0 = Date.now();
  let score = 0;
  if (spectrum.length > 0) {
    const mean = spectrum.reduce((a, b) => a + b, 0) / spectrum.length;
    const variance =
      spectrum.reduce((s, x) => s + (x - mean) ** 2, 0) / spectrum.length;
    score = Math.min(1, Math.sqrt(variance) * PHI_INV);
  }
  const threatDecisionMs = Date.now() - t0;
  return {
    protocol: 'PROTO-258',
    engine: 'DTHR',
    threatScore: score,
    threat: score >= THREAT_THRESHOLD,
    threatDecisionMs,
  };
}

/** PROTO-259: Formation lattice update */
function droneFormationLattice(agentIndex, position = [0, 0, 100]) {
  const goldenAngle = 2.39996322972865;
  const slotX = Math.cos(agentIndex * goldenAngle) * PHI;
  const slotY = Math.sin(agentIndex * goldenAngle) * PHI;
  const target = [slotX, slotY, position[2]];
  const error =
    Math.sqrt(
      target.reduce((s, t, i) => s + (t - (position[i] || 0)) ** 2, 0)
    ) / (PHI * 3);
  return {
    protocol: 'PROTO-259',
    engine: 'DFORM',
    formationError: error,
    targetSlot: target,
  };
}

/** PROTO-260: Jam failover routing */
function droneJamFailoverRoute(groundJammed = false, policy = 'auto') {
  const accessMode = groundJammed ? 'orbital_preferred' : 'ground_mesh';
  return {
    protocol: 'PROTO-260',
    engine: 'DRT',
    accessMode,
    routeOk: true,
    groundJammed,
    policy,
  };
}

/** PROTO-261: Side engine attestation */
function droneSideEngineAttestation(engineOutputs) {
  const attested = DRONE_SIDE_ENGINES.filter((code) =>
    engineOutputs.some((o) => o.engine === code)
  );
  return {
    protocol: 'PROTO-261',
    enginesAttested: attested,
    complete: attested.length === DRONE_SIDE_ENGINES.length,
    commitment: attested.join('|'),
  };
}

/** PROTO-262: CPL-L law gate */
function droneLawGate(context) {
  const violations = evaluateDroneLaws(context);
  const critical = violations.filter((v) => v.severity === 'CRITICAL');
  return {
    protocol: 'PROTO-262',
    violations,
    criticalCount: critical.length,
    goNoGo: critical.length === 0,
    blocked: critical.length > 0,
  };
}

/** Full drone-side tick — all engines + attestation + law gate */
function executeDroneSideTick(config = {}) {
  const agentId = config.agentId || 'drone-001';
  const readings = config.readings || {
    imu: [0, 0, 9.81],
    gps: { fix: !config.gpsDenied },
    baro: { altitude_m: 100 },
  };
  const spectrum = config.spectrum || [0.2, 0.25, 0.8, 0.3, 0.22];

  const sen = droneSensorIngest(readings);
  const nav = droneNavigationSolve(sen, {
    gpsDenied: config.gpsDenied,
    velocity: config.velocity,
    position: config.position,
  });
  const thr = droneSpectralThreat(spectrum);
  const mesh = droneMeshGossipTick(
    agentId,
    config.neighborVotes || [false, true, false],
    thr.threat
  );
  const form = droneFormationLattice(config.agentIndex || 0, nav.position);
  const route = droneJamFailoverRoute(config.groundJammed);

  const engineOutputs = [sen, nav, thr, mesh, form, route];
  const attest = droneSideEngineAttestation(engineOutputs);

  const lawCtx = {
    kuramotoR: config.kuramotoR ?? 0.9,
    threatDecisionMs: thr.threatDecisionMs,
    gpsDenied: !!config.gpsDenied,
    navOk: nav.navOk,
    groundJammed: !!config.groundJammed,
    accessMode: route.accessMode,
    meshPartitions: mesh.meshPartitions,
    formationError: form.formationError,
    enginesAttested: attest.enginesAttested,
    roeScore: config.roeScore ?? 1.0,
    actuationRequested: !!config.actuationRequested,
  };
  const gate = droneLawGate(lawCtx);

  return {
    agentId,
    engines: engineOutputs,
    attestation: attest,
    lawGate: gate,
    threat: thr.threat,
    threatScore: thr.threatScore,
    accessMode: route.accessMode,
    protocols: engineOutputs.map((o) => o.protocol).concat(['PROTO-261', 'PROTO-262']),
    ok: gate.goNoGo,
    timestamp: Date.now(),
  };
}

export {
  DRONE_SIDE_ENGINES,
  DRONE_LAWS,
  droneSensorIngest,
  droneNavigationSolve,
  droneMeshGossipTick,
  droneSpectralThreat,
  droneFormationLattice,
  droneJamFailoverRoute,
  droneSideEngineAttestation,
  droneLawGate,
  executeDroneSideTick,
  evaluateDroneLaws,
  PHI,
  PHI_INV,
  PHI_BEAT,
  KURAMOTO_MIN,
  THREAT_THRESHOLD,
};