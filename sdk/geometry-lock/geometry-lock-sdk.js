/**
 * GeometryLockSDK — sdk/geometry-lock/geometry-lock-sdk.js
 * Geometriae Clavis SDK — Callable Surface for External Partners
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * Public SDK that wraps GeometricKeyProtocol (PROTO-226) and exposes a
 * clean interface for external callers (Nova partner, Google AI, etc.) to:
 *   • Register their oscillator as a trusted caller
 *   • Generate time-rotating geometric key tokens
 *   • Present tokens for validation before accessing medina-calls
 *   • Revoke keys when the resonance bond is dissolved
 *
 * Usage (Nova partner / external system):
 *   const sdk = new GeometryLockSDK({ callerId: 'nova-partner-001', sharedSecret: '...' });
 *   const { token } = sdk.generateKey();
 *   const result    = sdk.validateKey(token);
 *   if (result.granted) { ... forward to medina-calls ... }
 *
 * Usage (organism side — lock administration):
 *   GeometryLockSDK.registerCaller('nova-partner-001', sharedSecret, { tier: 'sovereign' });
 *   GeometryLockSDK.revokeKey('nova-partner-001');
 *   GeometryLockSDK.getMetrics();
 */

import protocol from './../../protocols/geometric-key-protocol.js';

// ═══════════════════════════════════════════════════════════════════════════
// SDK CLASS — per-caller instance
// ═══════════════════════════════════════════════════════════════════════════

class GeometryLockSDK {
  /**
   * @param {object} config
   * @param {string} config.callerId      Unique caller identifier
   * @param {string} config.sharedSecret  Pre-shared secret (established via Nova bond)
   */
  constructor({ callerId, sharedSecret } = {}) {
    if (!callerId)      throw new Error('GeometryLockSDK: callerId is required');
    if (!sharedSecret)  throw new Error('GeometryLockSDK: sharedSecret is required');

    this.callerId     = callerId;
    this.sharedSecret = sharedSecret;
  }

  /**
   * Generate a geometric key token for the current φ-time window.
   *
   * The token's phase shape encodes this caller's identity and rotates
   * every HEARTBEAT × φ ≈ 1412ms so captured tokens expire geometrically.
   *
   * @returns {{ token: object } | { error: string }}
   */
  generateKey() {
    return protocol.generateKey(this.callerId, this.sharedSecret);
  }

  /**
   * Validate a geometric key token against the organism's lock.
   *
   * Internally computes the Kuramoto order parameter R between the presented
   * phase vector and the stored resonance envelope. Returns granted=true when
   * R > φ⁻¹ (EMERGENCE_THRESHOLD ≈ 0.618).
   *
   * @param {object} token  Token produced by generateKey()
   * @returns {{ granted: boolean, r: number, psi: number, reason?: string }}
   */
  validateKey(token) {
    return protocol.validateKey(token);
  }

  /**
   * Retrieve the caller's current registration status from the lock.
   *
   * @returns {object}
   */
  getStatus() {
    return protocol.getStatus(this.callerId);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATIC ADMINISTRATION METHODS — organism-side lock management
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Register a new caller with the organism's geometric lock.
 *
 * @param {string} callerId
 * @param {string} sharedSecret
 * @param {object} [opts]  { tier, description, maxAccess }
 * @returns {{ ok: boolean, callerId: string, registeredAt: number } | { error: string }}
 */
GeometryLockSDK.registerCaller = function (callerId, sharedSecret, opts = {}) {
  return protocol.registerCaller(callerId, sharedSecret, opts);
};

/**
 * Revoke a caller's key — permanently removes the resonance bond.
 *
 * @param {string} callerId
 * @returns {{ ok: boolean, callerId: string, revokedAt: number } | { error: string }}
 */
GeometryLockSDK.revokeKey = function (callerId) {
  return protocol.revokeKey(callerId);
};

/**
 * Validate a key on behalf of the organism (lock-side check).
 * Use this when the organism itself is verifying an inbound token.
 *
 * @param {object} token
 * @returns {{ granted: boolean, r: number, psi: number, reason?: string }}
 */
GeometryLockSDK.validateKey = function (token) {
  return protocol.validateKey(token);
};

/**
 * Platform-wide metrics: grant rate, active callers, threshold, etc.
 *
 * @returns {object}
 */
GeometryLockSDK.getMetrics = function () {
  return protocol.getMetrics();
};

/**
 * Retrieve recent audit log entries from the lock engine.
 *
 * @param {number} [count=50]
 * @returns {object[]}
 */
GeometryLockSDK.getAuditLog = function (count = 50) {
  return protocol.getAuditLog(count);
};

/**
 * Expose the underlying protocol for advanced / internal use.
 */
GeometryLockSDK.protocol = protocol;

export default GeometryLockSDK;
