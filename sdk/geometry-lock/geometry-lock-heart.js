/**
 * Geometry Lock Mini Heart — sdk/geometry-lock/geometry-lock-heart.js
 * Cor Clavis — φ-Heartbeat Pulse Engine for the Lock Division
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * The heart is the organism's rhythm — the beat that keeps every bond alive.
 * It fires every 873ms (the φ-heartbeat), emits pulse events to all live
 * resonance links, broadcasts posture changes, and knows when to freeze.
 *
 * Responsibilities:
 *   • Maintain the φ-beat timer (873ms)
 *   • Track all live resonance links (active caller bonds)
 *   • Emit per-link pulse events on every beat
 *   • Broadcast posture changes to all links
 *   • Freeze (halt beats) during emergency lockdown
 *   • Thaw (resume beats) on posture recovery
 *   • Report vitals: beat count, link count, pulse rate
 *
 * Listeners receive: { type: 'pulse', beat, links, posture, phi }
 */

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const HEARTBEAT = 873;   // ms — organism φ-beat

// Max tracked links (F11 = 89)
const MAX_LINKS = 89;

// ═══════════════════════════════════════════════════════════════════════════
// GEOMETRY LOCK HEART CLASS
// ═══════════════════════════════════════════════════════════════════════════

class GeometryLockHeart {
  constructor() {
    this.beatCount  = 0;
    this.running    = false;
    this.frozen     = false;
    this.posture    = 'GREEN';
    this.links      = new Map();   // callerId → link metadata
    this._listeners = [];
    this._timer     = null;
    this._startedAt = null;
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────

  start() {
    if (this.running) return;
    this.running    = true;
    this.frozen     = false;
    this._startedAt = Date.now();
    this._timer     = setInterval(() => this._beat(), HEARTBEAT);
  }

  stop() {
    if (this._timer) {
      clearInterval(this._timer);
      this._timer = null;
    }
    this.running = false;
  }

  /** Freeze beats — called during emergency lockdown (GKP-010). */
  freeze() {
    this.frozen = true;
    this._emit({ type: 'freeze', beat: this.beatCount, posture: 'RED', phi: PHI });
  }

  /** Thaw beats — called when posture recovers from RED. */
  thaw() {
    this.frozen = false;
    this._emit({ type: 'thaw', beat: this.beatCount, posture: this.posture, phi: PHI });
  }

  // ── Links ──────────────────────────────────────────────────────────────

  /**
   * Add a resonance link (called on bond creation — GKP-002).
   * @param {string} callerId
   * @param {{ tier: string, solid: string }} meta
   */
  addLink(callerId, meta = {}) {
    if (this.links.size >= MAX_LINKS) {
      // Dissolve the oldest link to make room
      const oldest = [...this.links.entries()].sort((a, b) => a[1].addedAt - b[1].addedAt)[0];
      if (oldest) this.links.delete(oldest[0]);
    }
    this.links.set(callerId, {
      callerId,
      tier     : meta.tier || 'TETRAHEDRON',
      solid    : meta.solid || 'Tetrahedrum',
      addedAt  : Date.now(),
      lastPulse: null,
      healthy  : true,
    });
  }

  /**
   * Remove a link (called on revocation — GKP-009).
   * @param {string} callerId
   */
  removeLink(callerId) {
    this.links.delete(callerId);
  }

  /**
   * Notify a caller that their key has been revoked.
   * @param {string} callerId
   */
  notifyRevoked(callerId) {
    this._emit({ type: 'revoked', callerId, beat: this.beatCount, phi: PHI });
    this.removeLink(callerId);
  }

  // ── Posture ────────────────────────────────────────────────────────────

  /**
   * Update posture and broadcast to all links.
   * @param {string} posture  GREEN | YELLOW | ORANGE | RED
   */
  broadcastPosture(posture) {
    this.posture = posture;
    this._emit({ type: 'posture', posture, beat: this.beatCount, phi: PHI });
  }

  /**
   * Adapt the lock's Kuramoto emergence threshold based on the current
   * defensive posture.  Called whenever posture changes so that attacks
   * automatically tighten the resonance gate — the organism defends itself.
   *
   * Posture → threshold mapping:
   *   GREEN  → φ⁻¹         (0.618) — constitutional default
   *   YELLOW → φ⁻¹ + 0.05  (0.668) — elevated
   *   ORANGE → φ⁻¹ + 0.10  (0.718) — defensive
   *   RED    → φ⁻¹ + 0.15  (0.768) — lockdown
   *
   * @param {string} posture    GREEN | YELLOW | ORANGE | RED
   * @param {object} protocol   GeometricKeyProtocol instance (has setEmergenceThreshold)
   * @returns {number}          The new threshold value
   */
  adaptThreshold(posture, protocol) {
    const POSTURE_THRESHOLDS = {
      GREEN  : PHI_INV,
      YELLOW : PHI_INV + 0.05,
      ORANGE : PHI_INV + 0.10,
      RED    : PHI_INV + 0.15,
    };
    const t = POSTURE_THRESHOLDS[posture] ?? PHI_INV;
    if (protocol && typeof protocol.setEmergenceThreshold === 'function') {
      protocol.setEmergenceThreshold(t);
    }
    this._emit({ type: 'threshold-adapted', posture, threshold: t, beat: this.beatCount, phi: PHI });
    return t;
  }

  // ── Pulse all links ────────────────────────────────────────────────────

  pulseAll() {
    const ts = Date.now();
    for (const [, link] of this.links) {
      link.lastPulse = ts;
    }
    this._emit({
      type    : 'pulse-all',
      beat    : this.beatCount,
      links   : this.links.size,
      posture : this.posture,
      phi     : PHI,
    });
  }

  // ── Listeners ──────────────────────────────────────────────────────────

  on(listener) {
    if (typeof listener === 'function') this._listeners.push(listener);
    return () => { this._listeners = this._listeners.filter(l => l !== listener); };
  }

  _emit(event) {
    for (const fn of this._listeners) {
      try { fn(event); } catch (_) { /* isolate listener errors */ }
    }
  }

  // ── Internal beat ──────────────────────────────────────────────────────

  _beat() {
    this.beatCount++;
    if (this.frozen) return;

    const pulse = {
      type    : 'pulse',
      beat    : this.beatCount,
      links   : this.links.size,
      posture : this.posture,
      phi     : PHI,
      uptime  : this._startedAt ? Date.now() - this._startedAt : 0,
    };

    // Update last-pulse timestamp for each link
    const ts = Date.now();
    for (const [, link] of this.links) {
      link.lastPulse = ts;
    }

    this._emit(pulse);
  }

  // ── Vitals snapshot ────────────────────────────────────────────────────

  getVitals() {
    return {
      running   : this.running,
      frozen    : this.frozen,
      posture   : this.posture,
      beatCount : this.beatCount,
      links     : this.links.size,
      maxLinks  : MAX_LINKS,
      heartbeat : HEARTBEAT,
      phi       : PHI,
      uptime    : this._startedAt ? Date.now() - this._startedAt : 0,
    };
  }

  getLinks() {
    return [...this.links.values()];
  }
}

export default GeometryLockHeart;
