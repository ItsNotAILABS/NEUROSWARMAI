/**
 * PROTO-226 — GeometricKeyProtocol
 * Clavis Geometrica — Geometric Access Gate
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 *
 * A geometric key is an access gate where the shape of a presented token —
 * not a string password — proves identity and grants access.
 *
 * Identity is encoded as a phase vector [θ₁, θ₂, ..., θₙ] derived from a
 * shared secret and the current φ-time window. The lock computes the Kuramoto
 * order parameter R between the presented token and the registered resonance
 * envelope. If R > EMERGENCE_THRESHOLD (φ⁻¹ ≈ 0.618) the phases resonate →
 * access is granted. If R < threshold → access denied, mismatch logged.
 *
 * Mathematics:
 *   Key generation   — θⱼ = hmac(secret, callerId + window + j) × 2π
 *   Phase distance   — Δθⱼ = θ_presented[j] − θ_envelope[j]
 *   Kuramoto R       — R = |1/N × Σ e^(iΔθⱼ)|
 *                         = √((1/N Σ cos Δθⱼ)² + (1/N Σ sin Δθⱼ)²)
 *   Access decision  — R > PHI_INV (0.618...)
 *
 * Time rotation: key window = floor(Date.now() / (HEARTBEAT × PHI))
 *   — the key's phase shape drifts predictably with the φ-rhythm
 *   — a captured key expires within one φ-heartbeat window
 *
 * Key dimensions: N = 8 (aligned with 8 organism sub-tokens)
 *
 * HMAC: HMAC-SHA-256 via SubtleCrypto (Web Crypto API) when available;
 *       falls back to HMAC-FNV-1a (matches crypto-worker pattern) when
 *       SubtleCrypto is not present (e.g. older runtimes, test harnesses).
 *
 * Adaptive threshold: the emergence threshold starts at φ⁻¹ (0.618) and
 * tightens under attack (YELLOW→+0.05, ORANGE→+0.10, RED→+0.15) so
 * defensive mode demands higher resonance for access.
 *
 * Protocol: module export (not a Web Worker)
 *   await GeometricKeyProtocol.generateKey(callerId, sharedSecret, timeWindow?)
 *   await GeometricKeyProtocol.validateKey(token, callerId)
 *         GeometricKeyProtocol.registerCaller(callerId, sharedSecret, opts?)
 *         GeometricKeyProtocol.revokeKey(callerId)
 *         GeometricKeyProtocol.getStatus(callerId)
 *         GeometricKeyProtocol.getMetrics()
 *         GeometricKeyProtocol.setEmergenceThreshold(t)
 *         GeometricKeyProtocol.getEmergenceThreshold()
 */

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════

const PHI              = 1.618033988749895;
const PHI_INV          = 1 / PHI;                    // 0.6180339...
const HEARTBEAT        = 873;                         // ms — organism φ-beat
const KEY_DIMENSIONS   = 8;                           // phase vector length
const TWO_PI           = 2 * Math.PI;
const FNV_OFFSET       = 2166136261;
const FNV_PRIME        = 16777619;

// Kuramoto resonance threshold — φ⁻¹, the emergence threshold
// Mutable — tightens in defensive mode via setEmergenceThreshold()
let _emergenceThreshold = PHI_INV;                // 0.618... (default)

// Clock-skew tolerance: allow 1 adjacent time window either side
const WINDOW_TOLERANCE = 1;

// Max registered callers (F13 = 233)
const MAX_CALLERS = 233;

// Audit log depth (F18 = 2584)
const MAX_AUDIT_LOG = 2584;

// ═══════════════════════════════════════════════════════════════════════════
// SUBTLECRYPTO DETECTION
// ═══════════════════════════════════════════════════════════════════════════

// Use the platform's native HMAC-SHA-256 when available (browsers, Node 18+,
// Cloudflare Workers).  Falls back to HMAC-FNV-1a for environments without
// SubtleCrypto (test harnesses, CI without --experimental-vm-modules, etc.).
const _subtle = (
  typeof globalThis !== 'undefined' &&
  globalThis.crypto &&
  typeof globalThis.crypto.subtle === 'object'
) ? globalThis.crypto.subtle : null;

// ═══════════════════════════════════════════════════════════════════════════
// FNV-1a HELPERS  (matches crypto-worker.js — fallback when no SubtleCrypto)
// ═══════════════════════════════════════════════════════════════════════════

function fnv1a(input) {
  let hash = FNV_OFFSET;
  for (let i = 0; i < input.length; i++) {
    hash ^= input.charCodeAt(i);
    hash  = (hash * FNV_PRIME) >>> 0;
  }
  return hash;
}

/**
 * HMAC-FNV — message authentication (same construction as crypto-worker)
 * Not cryptographically secure; sufficient for organism inter-worker auth.
 * Used as fallback when SubtleCrypto is unavailable.
 */
function hmacFnv(key, message) {
  const keyHash = fnv1a(key);
  const inner   = fnv1a(keyHash.toString(16) + ':' + message);
  const outer   = fnv1a(inner.toString(16)   + ':' + keyHash.toString(16));
  return outer;
}

// ═══════════════════════════════════════════════════════════════════════════
// HMAC-SHA-256 via SubtleCrypto  (primary path)
// ═══════════════════════════════════════════════════════════════════════════

const _textEncoder = typeof TextEncoder !== 'undefined' ? new TextEncoder() : null;

/**
 * Compute HMAC-SHA-256(keyStr, messageStr) → Uint8Array (32 bytes).
 * When SubtleCrypto is not available, produces 4 bytes from HMAC-FNV-1a so
 * the caller can handle both lengths transparently via uint32 extraction.
 *
 * @param {string} keyStr
 * @param {string} messageStr
 * @returns {Promise<Uint8Array>}
 */
async function hmacSha256Bytes(keyStr, messageStr) {
  if (_subtle && _textEncoder) {
    const rawKey = await _subtle.importKey(
      'raw',
      _textEncoder.encode(keyStr),
      { name: 'HMAC', hash: 'SHA-256' },
      false,
      ['sign'],
    );
    const sig = await _subtle.sign('HMAC', rawKey, _textEncoder.encode(messageStr));
    return new Uint8Array(sig);
  }
  // Fallback: HMAC-FNV-1a — pack uint32 into a 4-byte Uint8Array
  const u32 = hmacFnv(keyStr, messageStr);
  const buf  = new Uint8Array(4);
  buf[0] = (u32 >>> 24) & 0xFF;
  buf[1] = (u32 >>> 16) & 0xFF;
  buf[2] = (u32 >>>  8) & 0xFF;
  buf[3] =  u32         & 0xFF;
  return buf;
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY MATERIAL DERIVATION  (async — backed by HMAC-SHA-256)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Derive the current φ-time window index.
 * Window width = HEARTBEAT × PHI ≈ 1412ms
 * Key rotates at each window boundary.
 */
function currentTimeWindow() {
  return Math.floor(Date.now() / (HEARTBEAT * PHI));
}

/**
 * Derive a single phase angle for dimension j using HMAC-SHA-256.
 * θⱼ ∈ [0, 2π)
 *
 * Uses the first 4 bytes of the HMAC output as a uint32, then normalises
 * to [0, 2π).  With SHA-256 this is cryptographically uniform; with the
 * FNV-1a fallback it is the full 32-bit hash output.
 *
 * @returns {Promise<number>}
 */
async function derivePhaseAngle(sharedSecret, callerId, window, j) {
  const bytes = await hmacSha256Bytes(sharedSecret, `${callerId}:${window}:${j}`);
  // Extract first uint32 and normalise to [0, 2π)
  const u32 = ((bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3]) >>> 0;
  return (u32 / 0x100000000) * TWO_PI;
}

/**
 * Build an N-dimensional phase vector for a caller at a given time window.
 * Returns Float64Array of length KEY_DIMENSIONS.
 *
 * @returns {Promise<Float64Array>}
 */
async function buildPhaseVector(sharedSecret, callerId, window) {
  const phases = new Float64Array(KEY_DIMENSIONS);
  for (let j = 0; j < KEY_DIMENSIONS; j++) {
    phases[j] = await derivePhaseAngle(sharedSecret, callerId, window, j);
  }
  return phases;
}

/**
 * Compute a token signature string using HMAC-SHA-256.
 * Returns a hex-encoded string of the first 8 bytes (64 bits).
 *
 * @returns {Promise<string>}
 */
async function tokenSignature(sharedSecret, callerId, window, phaseSig) {
  const bytes = await hmacSha256Bytes(sharedSecret, `${callerId}:${window}:${phaseSig}`);
  // Hex-encode the full output for transport
  return Array.from(bytes).map(b => b.toString(16).padStart(2, '0')).join('');
}

// ═══════════════════════════════════════════════════════════════════════════
// KURAMOTO ORDER PARAMETER
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute the Kuramoto order parameter R ∈ [0, 1] for an array of phase
 * differences.  R = 1 means perfect resonance; R = 0 means total incoherence.
 *
 *   R·e^(iΨ) = (1/N) Σⱼ e^(iΔθⱼ)
 *   R        = √((mean cos Δθⱼ)² + (mean sin Δθⱼ)²)
 *
 * @param {Float64Array|number[]} deltas  Phase-difference vector Δθⱼ
 * @returns {{ r: number, psi: number }}  Coherence R and mean phase Ψ
 */
function kuramotoOrderParameter(deltas) {
  const n = deltas.length;
  if (n === 0) return { r: 0, psi: 0 };

  let sumCos = 0;
  let sumSin = 0;
  for (let i = 0; i < n; i++) {
    sumCos += Math.cos(deltas[i]);
    sumSin += Math.sin(deltas[i]);
  }

  const meanCos = sumCos / n;
  const meanSin = sumSin / n;
  const r       = Math.sqrt(meanCos * meanCos + meanSin * meanSin);
  const psi     = Math.atan2(meanSin, meanCos);

  return { r, psi };
}

/**
 * Compute phase differences Δθⱼ = θ_presented[j] − θ_envelope[j]
 * wrapped to (−π, π].
 */
function phaseDeltas(presented, envelope) {
  const deltas = new Float64Array(KEY_DIMENSIONS);
  for (let j = 0; j < KEY_DIMENSIONS; j++) {
    let d = presented[j] - envelope[j];
    // Wrap to (-π, π]
    while (d >  Math.PI) d -= TWO_PI;
    while (d < -Math.PI) d += TWO_PI;
    deltas[j] = d;
  }
  return deltas;
}

// ═══════════════════════════════════════════════════════════════════════════
// CALLER REGISTRY
// ═══════════════════════════════════════════════════════════════════════════

// callerId → { sharedSecret, registeredAt, lastAccess, accessCount, revoked, opts }
const callerRegistry = new Map();

// ═══════════════════════════════════════════════════════════════════════════
// AUDIT LOG
// ═══════════════════════════════════════════════════════════════════════════

const auditLog = [];

function logAudit(event, callerId, details) {
  const entry = {
    timestamp : Date.now(),
    event,
    callerId  : callerId || null,
    details   : details || {},
  };
  auditLog.push(entry);
  if (auditLog.length > MAX_AUDIT_LOG) auditLog.shift();
  return entry;
}

// ═══════════════════════════════════════════════════════════════════════════
// METRICS
// ═══════════════════════════════════════════════════════════════════════════

let totalValidations = 0;
let totalGranted     = 0;
let totalDenied      = 0;
let totalRevocations = 0;

// ═══════════════════════════════════════════════════════════════════════════
// PROTOCOL PUBLIC API
// ═══════════════════════════════════════════════════════════════════════════

const GeometricKeyProtocol = {

  /**
   * Register a caller and their shared secret with the lock.
   *
   * @param {string} callerId      Unique caller identifier
   * @param {string} sharedSecret  Secret shared out-of-band (e.g. via Nova bond)
   * @param {object} [opts]        Optional: { tier, description, maxAccess }
   * @returns {{ ok: boolean, callerId: string, registeredAt: number } | { error: string }}
   */
  registerCaller(callerId, sharedSecret, opts = {}) {
    if (!callerId || typeof callerId !== 'string') {
      return { error: 'invalid-caller-id' };
    }
    if (!sharedSecret || typeof sharedSecret !== 'string') {
      return { error: 'invalid-shared-secret' };
    }
    if (callerRegistry.size >= MAX_CALLERS) {
      return { error: 'registry-full', max: MAX_CALLERS };
    }

    const existing = callerRegistry.get(callerId);
    if (existing && !existing.revoked) {
      return { error: 'caller-already-registered', callerId };
    }

    const record = {
      sharedSecret,
      registeredAt : Date.now(),
      lastAccess   : null,
      accessCount  : 0,
      revoked      : false,
      tier         : opts.tier        || 'standard',
      description  : opts.description || '',
      maxAccess    : opts.maxAccess   || -1,     // -1 = unlimited
    };

    callerRegistry.set(callerId, record);
    logAudit('caller-registered', callerId, { tier: record.tier });

    return { ok: true, callerId, registeredAt: record.registeredAt };
  },

  /**
   * Revoke a caller's access key — permanently removes the resonance bond.
   *
   * @param {string} callerId
   * @returns {{ ok: boolean, callerId: string, revokedAt: number } | { error: string }}
   */
  revokeKey(callerId) {
    const record = callerRegistry.get(callerId);
    if (!record) return { error: 'caller-not-found', callerId };
    if (record.revoked) return { error: 'already-revoked', callerId };

    record.revoked    = true;
    record.revokedAt  = Date.now();
    totalRevocations++;

    logAudit('key-revoked', callerId, { revokedAt: record.revokedAt });
    return { ok: true, callerId, revokedAt: record.revokedAt };
  },

  /**
   * Generate a geometric key token for a caller.
   *
   * The token contains:
   *   - phases     : number[]   — the N-dimensional phase vector (JSON-safe)
   *   - window     : number     — the φ-time window index
   *   - callerId   : string
   *   - signature  : string     — hex-encoded HMAC-SHA-256 of (callerId+window+phases)
   *   - issuedAt   : number     — timestamp
   *   - hmac       : 'sha256' | 'fnv1a'  — which HMAC was used
   *
   * @param {string} callerId
   * @param {string} sharedSecret  Must match the registered secret
   * @param {number} [timeWindow]  Override (defaults to currentTimeWindow())
   * @returns {Promise<{ token: object } | { error: string }>}
   */
  async generateKey(callerId, sharedSecret, timeWindow) {
    if (!callerId || !sharedSecret) {
      return { error: 'missing-parameters' };
    }

    const window = timeWindow !== undefined ? timeWindow : currentTimeWindow();
    const phases = await buildPhaseVector(sharedSecret, callerId, window);

    // Sign the token: HMAC over callerId + window + serialised phases
    const phaseSig  = Array.from(phases).map(p => p.toFixed(8)).join(',');
    const signature = await tokenSignature(sharedSecret, callerId, window, phaseSig);

    const token = {
      callerId,
      window,
      phases   : Array.from(phases),   // serialisable for transport
      signature,
      issuedAt : Date.now(),
      proto    : 'PROTO-226',
      hmac     : _subtle ? 'sha256' : 'fnv1a',
    };

    logAudit('key-generated', callerId, { window, hmac: token.hmac });
    return { token };
  },

  /**
   * Validate a geometric key token presented by a caller.
   *
   * Steps:
   *   1. Look up caller in registry
   *   2. Verify HMAC-SHA-256 signature (tamper-proof)
   *   3. Check token is within the valid time window (±WINDOW_TOLERANCE)
   *   4. Reconstruct the expected resonance envelope from the shared secret
   *   5. Compute phase deltas and Kuramoto R
   *   6. Decision: R > _emergenceThreshold → GRANTED, else DENIED
   *
   * The emergence threshold is adaptive — it tightens in defensive mode
   * (call setEmergenceThreshold() from the heart's adaptThreshold() hook).
   *
   * @param {object} token  Token produced by generateKey()
   * @returns {Promise<{ granted: boolean, r: number, psi: number, threshold: number, reason?: string }>}
   */
  async validateKey(token) {
    totalValidations++;

    if (!token || typeof token !== 'object') {
      totalDenied++;
      logAudit('key-denied', null, { reason: 'invalid-token-format' });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'invalid-token-format' };
    }

    const { callerId, window: tokenWindow, phases: presentedPhasesArr, signature } = token;

    // 1. Caller lookup
    const record = callerRegistry.get(callerId);
    if (!record) {
      totalDenied++;
      logAudit('key-denied', callerId, { reason: 'caller-not-registered' });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'caller-not-registered' };
    }

    if (record.revoked) {
      totalDenied++;
      logAudit('key-denied', callerId, { reason: 'caller-revoked' });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'caller-revoked' };
    }

    // 2. Access limit check
    if (record.maxAccess > 0 && record.accessCount >= record.maxAccess) {
      totalDenied++;
      logAudit('key-denied', callerId, { reason: 'access-limit-reached', limit: record.maxAccess });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'access-limit-reached' };
    }

    // 3. Phase vector integrity check
    if (!Array.isArray(presentedPhasesArr) || presentedPhasesArr.length !== KEY_DIMENSIONS) {
      totalDenied++;
      logAudit('key-denied', callerId, { reason: 'invalid-phase-vector' });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'invalid-phase-vector' };
    }

    // 4. HMAC-SHA-256 signature verification
    const presentedPhases = new Float64Array(presentedPhasesArr);
    const phaseSig        = Array.from(presentedPhases).map(p => p.toFixed(8)).join(',');
    const expectedSig     = await tokenSignature(record.sharedSecret, callerId, tokenWindow, phaseSig);
    if (signature !== expectedSig) {
      totalDenied++;
      logAudit('key-denied', callerId, { reason: 'signature-mismatch' });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'signature-mismatch' };
    }

    // 5. Time window check (±WINDOW_TOLERANCE)
    const nowWindow = currentTimeWindow();
    if (Math.abs(tokenWindow - nowWindow) > WINDOW_TOLERANCE) {
      totalDenied++;
      logAudit('key-denied', callerId, { reason: 'window-expired', tokenWindow, nowWindow });
      return { granted: false, r: 0, psi: 0, threshold: _emergenceThreshold, reason: 'window-expired' };
    }

    // 6. Reconstruct resonance envelope from shared secret + token window
    const envelope = await buildPhaseVector(record.sharedSecret, callerId, tokenWindow);

    // 7. Compute phase deltas and Kuramoto order parameter
    const deltas       = phaseDeltas(presentedPhases, envelope);
    const { r, psi }   = kuramotoOrderParameter(deltas);

    // 8. Resonance decision — uses the current (possibly tightened) threshold
    const threshold = _emergenceThreshold;
    if (r > threshold) {
      record.accessCount++;
      record.lastAccess = Date.now();
      totalGranted++;
      logAudit('key-granted', callerId, { r, psi, window: tokenWindow, threshold });
      return { granted: true, r, psi, threshold, callerId, tier: record.tier };
    }

    totalDenied++;
    logAudit('key-denied', callerId, {
      reason   : 'resonance-below-threshold',
      r,
      psi,
      threshold,
      window   : tokenWindow,
    });
    return {
      granted   : false,
      r,
      psi,
      threshold,
      reason    : 'resonance-below-threshold',
    };
  },

  /**
   * Retrieve the current registration status of a caller.
   *
   * @param {string} callerId
   * @returns {object}
   */
  getStatus(callerId) {
    const record = callerRegistry.get(callerId);
    if (!record) return { found: false, callerId };

    return {
      found        : true,
      callerId,
      registered   : !record.revoked,
      revoked      : record.revoked,
      registeredAt : record.registeredAt,
      lastAccess   : record.lastAccess,
      accessCount  : record.accessCount,
      tier         : record.tier,
      description  : record.description,
      revokedAt    : record.revokedAt || null,
    };
  },

  /**
   * Platform-wide metrics snapshot.
   */
  getMetrics() {
    const activeCounts = {};
    for (const [id, rec] of callerRegistry) {
      if (!rec.revoked) {
        activeCounts[rec.tier] = (activeCounts[rec.tier] || 0) + 1;
      }
    }

    return {
      proto             : 'PROTO-226',
      totalCallers      : callerRegistry.size,
      activeCallers     : [...callerRegistry.values()].filter(r => !r.revoked).length,
      totalValidations,
      totalGranted,
      totalDenied,
      totalRevocations,
      grantRate         : totalValidations > 0 ? totalGranted / totalValidations : 0,
      emergenceThreshold: _emergenceThreshold,
      defaultThreshold  : PHI_INV,
      thresholdTightened: _emergenceThreshold > PHI_INV,
      hmacAlgorithm     : _subtle ? 'HMAC-SHA-256' : 'HMAC-FNV-1a (fallback)',
      keyDimensions     : KEY_DIMENSIONS,
      heartbeatMs       : HEARTBEAT,
      phi               : PHI,
      callersByTier     : activeCounts,
      auditLogSize      : auditLog.length,
    };
  },

  // ── Adaptive emergence threshold ──────────────────────────────────────

  /**
   * Set the Kuramoto emergence threshold.
   * Called by the heart's adaptThreshold() when posture changes:
   *   GREEN  → φ⁻¹         (0.618)
   *   YELLOW → φ⁻¹ + 0.05  (0.668)
   *   ORANGE → φ⁻¹ + 0.10  (0.718)
   *   RED    → φ⁻¹ + 0.15  (0.768)
   *
   * @param {number} t  New threshold ∈ [PHI_INV, 1.0)
   */
  setEmergenceThreshold(t) {
    if (typeof t !== 'number' || t < PHI_INV || t >= 1.0) return;
    _emergenceThreshold = t;
  },

  /**
   * Return the current emergence threshold (may be tightened in defensive mode).
   * @returns {number}
   */
  getEmergenceThreshold() {
    return _emergenceThreshold;
  },

  /**
   * Reset the emergence threshold back to the constitutional default (φ⁻¹).
   */
  resetEmergenceThreshold() {
    _emergenceThreshold = PHI_INV;
  },

  /**
   * Return recent audit log entries.
   *
   * @param {number} [count=50]
   * @returns {object[]}
   */
  getAuditLog(count = 50) {
    return auditLog.slice(-count);
  },

  // ── Expose internal helpers for testing and sub-protocols ────────────
  _internal: {
    currentTimeWindow,
    buildPhaseVector,
    hmacSha256Bytes,
    hmacFnv,
    kuramotoOrderParameter,
    phaseDeltas,
    KEY_DIMENSIONS,
    get EMERGENCE_THRESHOLD() { return _emergenceThreshold; },
    PHI,
    PHI_INV,
    HEARTBEAT,
  },
};

export default GeometricKeyProtocol;
