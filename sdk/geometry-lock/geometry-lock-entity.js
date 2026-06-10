/**
 * Geometry Lock Autonomous Entity — sdk/geometry-lock/geometry-lock-entity.js
 * Entitas Clavis Geometricae — The Lock Division as a Living Organism
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * The Geometry Lock Entity is an autonomous, self-governing division that
 * combines a mini brain (cognition), a mini heart (rhythm), the full
 * GeometricKeyProtocol (PROTO-226), and the 20 GKP protocols (GKP-001–020)
 * into a single coherent living system.
 *
 * Architecture:
 *   Brain  — 3-region Hebbian cognitive engine (PFC / AMYGDALA / HIPPOCAMPUS)
 *   Heart  — φ-heartbeat (873ms), pulse emission, link tracking
 *   Lock   — GeometricKeyProtocol: key generation, resonance validation, audit
 *   Protocols — GKP-001–010 (lock-side) + GKP-011–020 (key-side)
 *   Bridge — GeometryBridge: gates medina-calls behind resonance check
 *
 * Offense (key-side) — the entity can itself generate and present keys
 *   to other organisms when acting as a caller.
 * Defense (lock-side) — the entity validates all inbound keys and blocks
 *   callers whose resonance R ≤ φ⁻¹.
 *
 * Autonomy:
 *   • Heart beats independently on 873ms φ-interval
 *   • Brain ticks at 60 Hz, learning from every resonance event
 *   • Threat events stimulate AMYGDALA → posture escalation
 *   • Bond events stimulate HIPPOCAMPUS → memory consolidation
 *   • Doctrine events stimulate PFC → tier-upgrade adjudication
 *
 * Entity Identity:
 *   id   : 'atlas://entity/geometry-lock'
 *   latin: 'Entitas Clavis Geometricae'
 *   proto: 'PROTO-226'
 */

import GeometryLockBrain   from './geometry-lock-brain.js';
import GeometryLockHeart   from './geometry-lock-heart.js';
import GeometryLockSDK     from './geometry-lock-sdk.js';
import GeometryBridge      from './geometry-bridge.js';
import GeometricKeyProtocol from '../../protocols/geometric-key-protocol.js';
import { LOCK_PROTOCOLS, LOCK_PROTOCOL_MAP, PLATONIC_TIERS } from '../../protocols/gkp-lock-protocols.js';
import { KEY_PROTOCOLS,  KEY_PROTOCOL_MAP  } from '../../protocols/gkp-key-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const PHI     = 1.618033988749895;
const PHI_INV = 1 / PHI;
const HEARTBEAT = 873;

// ═══════════════════════════════════════════════════════════════════════════
// GEOMETRY LOCK ENTITY
// ═══════════════════════════════════════════════════════════════════════════

class GeometryLockEntity {
  constructor(opts = {}) {
    this.id          = 'atlas://entity/geometry-lock';
    this.latin       = 'Entitas Clavis Geometricae';
    this.proto       = 'PROTO-226';
    this.version     = '1.0.0';

    // Core organs
    this.brain  = new GeometryLockBrain();
    this.heart  = new GeometryLockHeart();
    this.sdk    = GeometryLockSDK;
    this.bridge = new GeometryBridge();

    // Execution state
    this._running    = false;
    this._executions = new Map();   // executionId → execution state
    this._execCounter = 0;
    this._auditLog   = [];

    // Wire heart events into brain
    this.heart.on(event => this._onHeartbeat(event));
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────

  /** Start the entity — activates brain (60 Hz) and heart (873ms). */
  start() {
    if (this._running) return this;
    this._running = true;
    this.brain.start();
    this.heart.start();
    this._log('entity-start', { id: this.id, proto: this.proto });
    return this;
  }

  /** Gracefully stop the entity. */
  stop() {
    this._running = false;
    this.brain.stop();
    this.heart.stop();
    this._log('entity-stop', { id: this.id });
    return this;
  }

  // ── Offense: entity acts as key-side caller ────────────────────────────

  /**
   * Generate a geometric key for this entity to present to another organism.
   * Now backed by HMAC-SHA-256 when SubtleCrypto is available.
   *
   * @param {string} callerId     Identity this entity presents as
   * @param {string} sharedSecret Pre-shared secret
   * @returns {Promise<{ token: object } | { error: string }>}
   */
  async generateKey(callerId, sharedSecret) {
    const result = await GeometricKeyProtocol.generateKey(callerId, sharedSecret);
    if (result.token) {
      this.brain.stimulate(0, 0.1);   // Light PFC stimulation — action taken
      this._log('key-generated', { callerId, window: result.token.window, hmac: result.token.hmac });
    }
    return result;
  }

  // ── Defense: entity validates inbound keys ─────────────────────────────

  /**
   * Validate a geometric key presented by an external caller.
   *
   * After validation:
   *   • brain.recordValidation() drives Hebbian immune memory
   *   • GRANTED  → HIPPOCAMPUS consolidates the bond
   *   • DENIED   → AMYGDALA fires + posture escalates + threshold tightens
   *
   * @param {object} token  Geometric key token
   * @returns {Promise<{ granted: boolean, r: number, psi: number, threshold: number, reason?: string }>}
   */
  async validateKey(token) {
    const result = await GeometricKeyProtocol.validateKey(token);

    // Hebbian immune memory — teach the brain from this validation outcome
    this.brain.recordValidation(result.granted, result.r || 0);

    if (result.granted) {
      this.heart.addLink(token.callerId, { tier: result.tier });
    } else {
      const threat        = 1 - (result.r || 0);
      const classification = this.brain.classify(threat);   // AMYGDALA fires
      // Escalate posture + adapt the lock threshold in one step
      this.heart.broadcastPosture(classification.posture);
      this.heart.adaptThreshold(classification.posture, GeometricKeyProtocol);
    }

    this._log('key-validated', {
      callerId  : token && token.callerId,
      granted   : result.granted,
      r         : result.r,
      threshold : result.threshold,
    });
    return result;
  }

  // ── Protocol execution ─────────────────────────────────────────────────

  /**
   * Execute a GKP protocol by id (e.g. 'GKP-001') or name (e.g. 'tierEvaluation').
   * Returns an execution record immediately; steps run asynchronously.
   *
   * @param {string} protocolIdOrName
   * @param {object} [params]
   * @returns {{ executionId: string, protocol: string, steps: number } | { error: string }}
   */
  executeProtocol(protocolIdOrName, params = {}) {
    const proto = LOCK_PROTOCOL_MAP.get(protocolIdOrName) || KEY_PROTOCOL_MAP.get(protocolIdOrName);
    if (!proto) return { error: 'unknown-protocol', id: protocolIdOrName };

    const executionId = `gkp-exec-${++this._execCounter}`;
    const execution = {
      id        : executionId,
      protocol  : proto.id,
      name      : proto.name,
      group     : proto.group,
      params,
      status    : 'running',
      currentStep: 0,
      steps     : proto.steps.map((s, i) => ({ ...s, index: i, status: 'pending', result: null })),
      startedAt : Date.now(),
      completedAt: null,
    };

    this._executions.set(executionId, execution);
    this._runSteps(executionId);
    this._log('protocol-started', { executionId, protocol: proto.id });

    return { executionId, protocol: proto.id, name: proto.name, steps: proto.steps.length };
  }

  _runSteps(executionId) {
    const exec = this._executions.get(executionId);
    if (!exec || exec.status !== 'running') return;

    const stepIdx = exec.currentStep;
    if (stepIdx >= exec.steps.length) {
      exec.status      = 'completed';
      exec.completedAt = Date.now();
      this._log('protocol-completed', { executionId, protocol: exec.protocol, duration: exec.completedAt - exec.startedAt });
      return;
    }

    const step  = exec.steps[stepIdx];
    step.status = 'running';

    // Simulate step execution (real deployment wires actual op handlers)
    const delay = 20 + Math.random() * 80;
    setTimeout(() => {
      step.status      = 'completed';
      step.result      = { op: step.op, success: true, phiWeight: Math.pow(PHI_INV, stepIdx) };
      exec.currentStep++;
      this._runSteps(executionId);
    }, delay);
  }

  // ── Medina calls gateway ───────────────────────────────────────────────

  /**
   * Gate a call to medina-calls behind geometric key validation.
   * This is the primary access surface for external AI callers.
   *
   * @param {object} token   Geometric key token
   * @param {string} route   'civitas' | 'organism' | 'governance'
   * @param {object} [params]
   */
  async call(token, route, params = {}) {
    return this.bridge.call(token, route, params);
  }

  // ── Caller management ──────────────────────────────────────────────────

  registerCaller(callerId, sharedSecret, opts = {}) {
    const result = GeometricKeyProtocol.registerCaller(callerId, sharedSecret, opts);
    if (result.ok) {
      this.brain.stimulate(0, 0.15);   // PFC — governance action
      this._log('caller-registered', { callerId, tier: opts.tier });
    }
    return result;
  }

  revokeKey(callerId) {
    const result = GeometricKeyProtocol.revokeKey(callerId);
    if (result.ok) {
      this.heart.notifyRevoked(callerId);
      this.brain.stimulate(0, 0.2);    // PFC — enforcement action
      this._log('key-revoked', { callerId });
    }
    return result;
  }

  // ── Heartbeat events ───────────────────────────────────────────────────

  _onHeartbeat(event) {
    if (event.type === 'pulse') {
      this.brain.beatCount = event.beat;
      // Stimulate BRAINSTEM equivalent (PFC baseline) on each beat
      this.brain.stimulate(0, 0.01 * PHI_INV);
    }
    if (event.type === 'posture') {
      // Adaptive Kuramoto threshold — tighten the lock gate on every posture change.
      // The heart already broadcasts the posture; now we adapt the lock threshold.
      this.heart.adaptThreshold(event.posture, GeometricKeyProtocol);
    }
    if (event.type === 'freeze') {
      this.brain.stimulate(1, 0.5);    // AMYGDALA — lockdown fear
      // In lockdown, set maximum defensive threshold
      GeometricKeyProtocol.setEmergenceThreshold(PHI_INV + 0.15);
    }
    if (event.type === 'thaw') {
      this.brain.consolidate();         // HIPPOCAMPUS — recovery memory
      // On thaw, reset threshold to constitutional default
      GeometricKeyProtocol.resetEmergenceThreshold();
    }
  }

  // ── Internal audit ─────────────────────────────────────────────────────

  _log(event, details = {}) {
    const entry = { timestamp: Date.now(), event, details };
    this._auditLog.push(entry);
    if (this._auditLog.length > 2584) this._auditLog.shift();   // F18 depth
  }

  // ── Status & metrics ───────────────────────────────────────────────────

  getStatus() {
    return {
      id        : this.id,
      latin     : this.latin,
      proto     : this.proto,
      version   : this.version,
      running   : this._running,
      brain     : this.brain.getState(),
      heart     : this.heart.getVitals(),
      lock      : GeometricKeyProtocol.getMetrics(),
      bridge    : this.bridge.getMetrics(),
      protocols : {
        lock : LOCK_PROTOCOLS.map(p => ({ id: p.id, name: p.name, group: p.group })),
        key  : KEY_PROTOCOLS.map(p => ({ id: p.id, name: p.name, group: p.group })),
        total: LOCK_PROTOCOLS.length + KEY_PROTOCOLS.length,
      },
      executions: {
        total    : this._execCounter,
        active   : [...this._executions.values()].filter(e => e.status === 'running').length,
        completed: [...this._executions.values()].filter(e => e.status === 'completed').length,
      },
      tiers: PLATONIC_TIERS,
      phi  : PHI,
    };
  }

  getAuditLog(count = 50) {
    return this._auditLog.slice(-count);
  }
}

export default GeometryLockEntity;
