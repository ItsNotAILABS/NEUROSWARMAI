/**
 * Sentinel Worker — 24/7 Watchdog & Containment Layer
 *
 * Web Worker that runs permanently as the organism's immune system.
 * Monitors for threats, anomalies, and failures. Implements the
 * containment layer where failures decay rather than delete.
 * Runs threat detection patterns and maintains defense posture.
 *
 * Architecture:
 *   Watchdog — monitors all worker heartbeats for failures
 *   Threat detection — pattern-based anomaly identification
 *   Containment — failures decay at φ⁻⁶ threshold (0.0557)
 *   Defense posture — escalation levels based on threat count
 *   Heritage defense — 7 heritage nodes form heptagonal shield
 *   Audit log — immutable event log for forensics
 *
 * Defense Posture Levels:
 *   GREEN  — all clear, coherence > 0.85
 *   YELLOW — minor anomalies, coherence 0.60-0.85
 *   ORANGE — active threats, coherence 0.40-0.60
 *   RED    — critical, coherence < 0.40
 *
 * Containment Layer (from architecture):
 *   Failures don't delete — they DECAY
 *   Pathways below φ⁻⁶ (0.0557) coupling residue DISSOLVE
 *   Max 89 active containments (Fibonacci F11)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'threat', source, details, severity }
 *   Main → Worker: { type: 'workerDeath', workerId, workerType }
 *   Main → Worker: { type: 'anomaly', metric, value, threshold }
 *   Main → Worker: { type: 'getPosture' }
 *   Main → Worker: { type: 'getContainment' }
 *   Worker → Main: { type: 'alert', severity, message, action }
 *   Worker → Main: { type: 'posture-change', from, to, reason }
 *   Worker → Main: { type: 'containment-update', active, dissolved }
 *   Worker → Main: { type: 'heartbeat', beat, status }
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_NEG6 = Math.pow(PHI_INV, 6); // 0.055728...
const HEARTBEAT = 873;
const MAX_CONTAINMENTS = 89;  // F11
const SCAN_INTERVAL = 1000;   // Threat scan every 1s

let beatCount = 0;
let running = true;

/* ════════════════════════════════════════════════════════════════
   Defense posture
   ════════════════════════════════════════════════════════════════ */

const POSTURES = ['GREEN', 'YELLOW', 'ORANGE', 'RED'];
let currentPosture = 'GREEN';
let postureHistory = [];
const MAX_POSTURE_HISTORY = 55; // F10

function setPosture(newPosture, reason) {
  if (newPosture === currentPosture) return;

  const oldPosture = currentPosture;
  currentPosture = newPosture;

  postureHistory.push({
    from: oldPosture,
    to: newPosture,
    reason,
    timestamp: Date.now(),
  });
  if (postureHistory.length > MAX_POSTURE_HISTORY) postureHistory.shift();

  self.postMessage({
    type: 'posture-change',
    from: oldPosture,
    to: newPosture,
    reason,
    timestamp: Date.now(),
  });
}

/* ════════════════════════════════════════════════════════════════
   Threat registry
   ════════════════════════════════════════════════════════════════ */

const threats = [];
const MAX_THREATS = 144; // F12

function registerThreat(source, details, severity) {
  const threat = {
    id: threats.length + 1,
    source,
    details,
    severity: severity || 'warning',
    timestamp: Date.now(),
    containmentStrength: 1.0,
    status: 'active',
  };

  threats.push(threat);
  if (threats.length > MAX_THREATS) threats.shift();

  // Escalate posture based on active threat count
  const activeThreats = threats.filter(t => t.status === 'active');
  const criticalCount = activeThreats.filter(t => t.severity === 'critical').length;

  if (criticalCount > 3) {
    setPosture('RED', 'critical-threats-' + criticalCount);
  } else if (activeThreats.length > 8) {
    setPosture('ORANGE', 'active-threats-' + activeThreats.length);
  } else if (activeThreats.length > 3) {
    setPosture('YELLOW', 'threats-detected-' + activeThreats.length);
  }

  // Generate alert
  self.postMessage({
    type: 'alert',
    severity: threat.severity,
    message: 'Threat detected from ' + source + ': ' + (typeof details === 'string' ? details : JSON.stringify(details)),
    action: severity === 'critical' ? 'immediate-containment' : 'monitor',
    threatId: threat.id,
  });

  return threat;
}

/* ════════════════════════════════════════════════════════════════
   Containment layer — failures decay, not delete
   ════════════════════════════════════════════════════════════════ */

const containments = [];

function addContainment(source, failure) {
  if (containments.length >= MAX_CONTAINMENTS) {
    // Dissolve weakest containment to make room
    let weakestIdx = 0;
    let weakestStrength = Infinity;
    for (let i = 0; i < containments.length; i++) {
      if (containments[i].strength < weakestStrength) {
        weakestStrength = containments[i].strength;
        weakestIdx = i;
      }
    }
    containments.splice(weakestIdx, 1);
  }

  const containment = {
    id: containments.length + 1,
    source,
    failure,
    strength: 1.0,
    createdAt: Date.now(),
    lastDecay: Date.now(),
  };

  containments.push(containment);
  return containment;
}

function processDecay() {
  let dissolved = 0;

  for (let i = containments.length - 1; i >= 0; i--) {
    // Decay strength
    containments[i].strength *= 0.998;
    containments[i].lastDecay = Date.now();

    // Dissolve if below φ⁻⁶ threshold
    if (containments[i].strength < PHI_NEG6) {
      containments.splice(i, 1);
      dissolved++;
    }
  }

  // Also decay threats
  for (let i = threats.length - 1; i >= 0; i--) {
    if (threats[i].status === 'active') {
      threats[i].containmentStrength *= 0.999;
      if (threats[i].containmentStrength < PHI_NEG6) {
        threats[i].status = 'dissolved';
      }
    }
  }

  // Re-evaluate posture after decay
  const activeThreats = threats.filter(t => t.status === 'active');
  const criticalCount = activeThreats.filter(t => t.severity === 'critical').length;

  if (criticalCount === 0 && activeThreats.length <= 3) {
    if (activeThreats.length === 0) {
      setPosture('GREEN', 'all-threats-resolved');
    } else {
      setPosture('YELLOW', 'threats-decaying');
    }
  }

  if (dissolved > 0) {
    self.postMessage({
      type: 'containment-update',
      active: containments.length,
      dissolved,
      maxContainments: MAX_CONTAINMENTS,
    });
  }

  return { dissolved, active: containments.length };
}

/* ════════════════════════════════════════════════════════════════
   Heritage defense nodes — heptagonal shield
   Heritage nodes activate when R > 0.85
   ════════════════════════════════════════════════════════════════ */

const heritageNodes = [
  { name: 'REVOLUCIONARIO', phiScale: 1.0,              boost: 0, maxBoost: 2.0 },
  { name: 'ZAPATA',         phiScale: PHI_INV,           boost: 0, maxBoost: 2.0 },
  { name: 'VILLA',          phiScale: PHI_INV * PHI_INV, boost: 0, maxBoost: 2.0 },
  { name: 'INDEPENDENCIA',  phiScale: Math.pow(PHI_INV, 3), boost: 0, maxBoost: 2.0 },
  { name: 'HIDALGO',        phiScale: Math.pow(PHI_INV, 4), boost: 0, maxBoost: 2.0 },
  { name: 'ADELITA',        phiScale: Math.pow(PHI_INV, 5), boost: 0, maxBoost: 2.0 },
  { name: 'MORELOS',        phiScale: Math.pow(PHI_INV, 6), boost: 0, maxBoost: 2.0 },
];

function updateHeritage(coherence) {
  if (coherence > 0.85) {
    for (const node of heritageNodes) {
      node.boost = Math.min(node.maxBoost, node.boost + 0.001);
    }
  }
  return heritageNodes.map(n => ({ name: n.name, boost: n.boost, phiScale: n.phiScale }));
}

/* ════════════════════════════════════════════════════════════════
   Audit log — immutable event record
   ════════════════════════════════════════════════════════════════ */

const auditLog = [];
const MAX_AUDIT = 233; // F13

function audit(event, details) {
  auditLog.push({
    event,
    details,
    timestamp: Date.now(),
    posture: currentPosture,
  });
  if (auditLog.length > MAX_AUDIT) auditLog.shift();
}

/* ════════════════════════════════════════════════════════════════
   Message handler
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function (e) {
  const msg = e.data;

  switch (msg.type) {
    case 'threat': {
      const threat = registerThreat(msg.source, msg.details, msg.severity);
      audit('threat', { source: msg.source, severity: msg.severity, threatId: threat.id });
      break;
    }

    case 'workerDeath': {
      registerThreat(msg.workerId, 'Worker died: ' + msg.workerType, 'warning');
      addContainment(msg.workerId, { type: 'worker-death', workerType: msg.workerType });
      audit('worker-death', { workerId: msg.workerId, workerType: msg.workerType });
      break;
    }

    case 'anomaly': {
      registerThreat('telemetry', msg.metric + ' anomaly: ' + msg.value, msg.severity || 'warning');
      audit('anomaly', { metric: msg.metric, value: msg.value });
      break;
    }

    case 'heritageUpdate': {
      const heritage = updateHeritage(msg.coherence || 0);
      self.postMessage({ type: 'heritage-state', nodes: heritage });
      break;
    }

    case 'getPosture':
      self.postMessage({
        type: 'posture-state',
        posture: currentPosture,
        activeThreats: threats.filter(t => t.status === 'active').length,
        history: postureHistory.slice(-10),
      });
      break;

    case 'getContainment':
      self.postMessage({
        type: 'containment-state',
        active: containments.length,
        maxContainments: MAX_CONTAINMENTS,
        containments: containments.map(c => ({
          id: c.id,
          source: c.source,
          strength: c.strength,
          age: Date.now() - c.createdAt,
        })),
      });
      break;

    case 'getAudit':
      self.postMessage({ type: 'audit-log', log: auditLog.slice(-(msg.count || 50)) });
      break;

    case 'getState':
      self.postMessage({
        type: 'sentinel-state',
        posture: currentPosture,
        activeThreats: threats.filter(t => t.status === 'active').length,
        totalThreats: threats.length,
        containments: containments.length,
        auditSize: auditLog.length,
        heritage: heritageNodes.map(n => ({ name: n.name, boost: n.boost })),
      });
      break;

    case 'stop':
      running = false;
      if (heartbeatInterval) clearInterval(heartbeatInterval);
      if (scanInterval) clearInterval(scanInterval);
      self.postMessage({ type: 'stopped', posture: currentPosture });
      break;
  }
};

/* ════════════════════════════════════════════════════════════════
   Threat scan & decay — runs every 1s
   ════════════════════════════════════════════════════════════════ */

const scanInterval = setInterval(function () {
  if (!running) return;
  processDecay();
}, SCAN_INTERVAL);

/* ════════════════════════════════════════════════════════════════
   Heartbeat — runs permanently at 873ms
   ════════════════════════════════════════════════════════════════ */

const heartbeatInterval = setInterval(function () {
  if (!running) return;
  beatCount++;
  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    posture: currentPosture,
    activeThreats: threats.filter(t => t.status === 'active').length,
    containments: containments.length,
  });
}, HEARTBEAT);
