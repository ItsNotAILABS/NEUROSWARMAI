/**
 * GeometryBridge — sdk/geometry-lock/geometry-bridge.js
 * Pons Geometriae — Adapter: External Caller ↔ Medina Calls
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * The bridge sits in front of the organism's call surface (medina-calls)
 * and enforces geometric key validation before forwarding any request.
 * It is itself an EXCHANGE Intelligence Contract:
 *   "When partner presents resonating key → forward call to medina-calls"
 *
 * Flow:
 *   External caller (Nova partner / Google AI)
 *         ↓  presents geometric key token
 *   GeometryBridge.call(token, route, params)
 *         ↓  GeometricKeyProtocol.validateKey(token)
 *         ↓  R > 0.618? Yes
 *   sdk/medina-calls → organism tech/calls/tools
 *         ↓  No
 *   Denied + logged + sentinel alerted
 *
 * Supported medina-call routes (extensible):
 *   'civitas'     — civitas-calls   (community / governance layer)
 *   'organism'    — organism-calls  (organism lifecycle operations)
 *   'governance'  — governance-calls (CPL-L law queries and enforcement)
 *
 * Intelligence Contract (EXCHANGE):
 *   trigger  : key resonates (R > PHI_INV)
 *   exchange : forward call to requested medina-calls route
 *   guard    : R ≤ PHI_INV → deny + log + alert sentinel
 *
 * Usage:
 *   const bridge = new GeometryBridge();
 *   const result = await bridge.call(token, 'organism', { op: 'status' });
 */

import GeometryLockSDK from './geometry-lock-sdk.js';

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const PHI        = 1.618033988749895;
const PHI_INV    = 1 / PHI;
const HEARTBEAT  = 873;

// Max bridge request log (F13 = 233)
const MAX_REQUEST_LOG = 233;

// ═══════════════════════════════════════════════════════════════════════════
// MEDINA CALLS STUBS
// The organism's medina-calls surface.  In a full deployment these import
// from sdk/medina-calls/{civitas,organism,governance}-calls.js; the stubs
// here allow the bridge to function before those modules exist and make
// the call-forwarding contract explicit.
// ═══════════════════════════════════════════════════════════════════════════

const MEDINA_ROUTES = {
  civitas: {
    name   : 'civitas-calls',
    handle : async (params, context) => ({
      route   : 'civitas',
      handled : true,
      params,
      context,
      note    : 'civitas-calls — community and governance surface',
    }),
  },
  organism: {
    name   : 'organism-calls',
    handle : async (params, context) => ({
      route   : 'organism',
      handled : true,
      params,
      context,
      note    : 'organism-calls — lifecycle and coordination surface',
    }),
  },
  governance: {
    name   : 'governance-calls',
    handle : async (params, context) => ({
      route   : 'governance',
      handled : true,
      params,
      context,
      note    : 'governance-calls — CPL-L law and policy surface',
    }),
  },
};

// ═══════════════════════════════════════════════════════════════════════════
// INTELLIGENCE CONTRACT — EXCHANGE definition
// ═══════════════════════════════════════════════════════════════════════════

const EXCHANGE_CONTRACT = {
  id          : 'EXCHANGE-GEOMETRY-001',
  proto       : 'PROTO-226',
  type        : 'EXCHANGE',
  trigger     : 'key-resonates',
  triggerCond : `R > ${PHI_INV.toFixed(9)}`,
  exchange    : 'forward-call-to-medina',
  guard       : 'deny + log + alert-sentinel',
  phi         : PHI,
  heartbeatMs : HEARTBEAT,
  createdAt   : new Date('2026-01-01').getTime(),
};

// ═══════════════════════════════════════════════════════════════════════════
// GEOMETRY BRIDGE CLASS
// ═══════════════════════════════════════════════════════════════════════════

class GeometryBridge {
  constructor() {
    this._requestLog  = [];
    this._sentinelLog = [];
    this._totalCalls  = 0;
    this._totalGranted  = 0;
    this._totalDenied   = 0;
  }

  // ── EXCHANGE CONTRACT — main entry point ───────────────────────────────

  /**
   * Present a geometric key token and, if resonance is confirmed, forward
   * the call to the requested medina-calls route.
   *
   * @param {object} token   Geometric key token (from GeometryLockSDK.generateKey)
   * @param {string} route   Target medina-calls route: 'civitas'|'organism'|'governance'
   * @param {object} [params] Call parameters forwarded to the route handler
   * @returns {Promise<object>} result with { granted, r, callResult? }
   */
  async call(token, route, params = {}) {
    this._totalCalls++;

    // ── Step 1: validate geometric key ────────────────────────────────────
    const validation = GeometryLockSDK.validateKey(token);

    const requestEntry = {
      timestamp : Date.now(),
      callerId  : token && token.callerId ? token.callerId : 'unknown',
      route,
      granted   : validation.granted,
      r         : validation.r,
      psi       : validation.psi,
      reason    : validation.reason || null,
    };
    this._recordRequest(requestEntry);

    // ── Step 2: gate decision ─────────────────────────────────────────────
    if (!validation.granted) {
      this._totalDenied++;
      this._alertSentinel(requestEntry);
      return {
        granted  : false,
        r        : validation.r,
        psi      : validation.psi,
        reason   : validation.reason || 'resonance-denied',
        contract : EXCHANGE_CONTRACT.id,
      };
    }

    // ── Step 3: resolve route ─────────────────────────────────────────────
    const handler = MEDINA_ROUTES[route];
    if (!handler) {
      this._totalDenied++;
      return {
        granted : false,
        r       : validation.r,
        reason  : 'unknown-route',
        route,
      };
    }

    // ── Step 4: forward call (EXCHANGE fires) ─────────────────────────────
    this._totalGranted++;
    const context = {
      callerId  : validation.callerId,
      tier      : validation.tier,
      r         : validation.r,
      psi       : validation.psi,
      contract  : EXCHANGE_CONTRACT.id,
      timestamp : Date.now(),
    };

    let callResult;
    try {
      callResult = await handler.handle(params, context);
    } catch (err) {
      return {
        granted    : true,
        r          : validation.r,
        route,
        callResult : null,
        error      : err.message || 'handler-error',
      };
    }

    return {
      granted    : true,
      r          : validation.r,
      psi        : validation.psi,
      route,
      callResult,
      contract   : EXCHANGE_CONTRACT.id,
    };
  }

  // ── Internal helpers ───────────────────────────────────────────────────

  _recordRequest(entry) {
    this._requestLog.push(entry);
    if (this._requestLog.length > MAX_REQUEST_LOG) this._requestLog.shift();
  }

  _alertSentinel(entry) {
    const alert = {
      timestamp : Date.now(),
      severity  : 'HIGH',
      source    : 'GeometryBridge',
      message   : `Unkeyed or invalid call blocked — R=${entry.r.toFixed(4)}, caller=${entry.callerId}`,
      reason    : entry.reason,
      callerId  : entry.callerId,
      route     : entry.route,
      proto     : 'PROTO-226',
    };
    this._sentinelLog.push(alert);
    if (this._sentinelLog.length > MAX_REQUEST_LOG) this._sentinelLog.shift();

    // In a full deployment, this posts to the sentinel-worker via postMessage.
    // The stub emits a structured event that the sentinel can consume.
    if (typeof self !== 'undefined' && self.postMessage) {
      self.postMessage({ type: 'threat', source: 'GeometryBridge', details: alert, severity: 'HIGH' });
    }
  }

  // ── Observability ──────────────────────────────────────────────────────

  getContract() {
    return EXCHANGE_CONTRACT;
  }

  getMetrics() {
    return {
      bridge          : 'GeometryBridge',
      proto           : 'PROTO-226',
      contract        : EXCHANGE_CONTRACT.id,
      totalCalls      : this._totalCalls,
      totalGranted    : this._totalGranted,
      totalDenied     : this._totalDenied,
      grantRate       : this._totalCalls > 0 ? this._totalGranted / this._totalCalls : 0,
      requestLogSize  : this._requestLog.length,
      sentinelAlerts  : this._sentinelLog.length,
      emergenceThreshold: PHI_INV,
      routes          : Object.keys(MEDINA_ROUTES),
    };
  }

  getRequestLog(count = 50) {
    return this._requestLog.slice(-count);
  }

  getSentinelLog(count = 50) {
    return this._sentinelLog.slice(-count);
  }

  /**
   * Register a medina-calls route handler.
   * Use this to wire real sdk/medina-calls modules into the bridge.
   *
   * @param {string}   routeName  e.g. 'civitas'
   * @param {string}   name       Human-readable module name
   * @param {Function} handle     async (params, context) => result
   */
  registerRoute(routeName, name, handle) {
    if (typeof routeName !== 'string' || typeof handle !== 'function') {
      throw new Error('GeometryBridge.registerRoute: invalid arguments');
    }
    MEDINA_ROUTES[routeName] = { name, handle };
  }
}

export default GeometryBridge;
