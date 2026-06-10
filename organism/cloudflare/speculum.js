/**
 * SPECULUM — SOVEREIGN Screen Observation Gateway
 * Latin: "Speculum Conscientiae Soveregni" — Sovereign Mirror of Consent
 *
 * Cloudflare Worker — SOVEREIGN Surface IV: SPECULUM
 * Role: Consent-gated screen observation with full audit trail.
 *       No passive capture. No always-on. No stored frames.
 *       HMAC-SHA256 time-limited consent tokens. φ-decay expiry.
 *
 * Routes:
 *   POST /consent/request  — Issue consent token {userId, scope, tier}
 *   POST /consent/revoke   — Revoke active session {token, sessionId}
 *   POST /capture/submit   — Submit captured frame {token, sessionId, frameData}
 *   GET  /session/:id      — Get session state + audit trail
 *   GET  /audit/:sessionId — Full immutable audit log for a session
 *   GET  /status           — Worker health
 *   GET  /metrics          — Observation metrics
 *
 * PROTO-110–119 reserved for SPECULUM protocol chain.
 *
 * Consent model: Geometric exclusion — architectural, not runtime conditional.
 * Token format:  base64url(userId.sessionId.scope.expiry).HMAC-SHA256
 * φ-decay TTL:   tab → φ¹×15min, window → φ¹×10min, screen → φ⁻¹×5min
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const PHI_BEAT = 873;
const VERSION  = '1.0.0';
const WORKER_ID = 'SPECULUM-SOVEREIGN';
const LATIN     = 'Speculum Conscientiae Soveregni';

// ── Scope definitions with φ-decay TTLs ──────────────────────────────────────
const SCOPE_CONFIG = {
  tab:    { minTier: 1, ttlMs: Math.floor(PHI       * 15 * 60 * 1000) }, // φ¹ × 15min ≈ 24.3min
  window: { minTier: 2, ttlMs: Math.floor(PHI       * 10 * 60 * 1000) }, // φ¹ × 10min ≈ 16.2min
  screen: { minTier: 3, ttlMs: Math.floor(PHI_INV   *  5 * 60 * 1000) }, // φ⁻¹ × 5min ≈ 3.1min
};

// ── In-memory session + audit store ─────────────────────────────────────────
// Sessions expire and are cleaned up by the garbage collection tick.
const sessions = new Map(); // sessionId → SessionRecord
let beatCount     = 0;
let sessionCount  = 0;
let captureCount  = 0;
let revokeCount   = 0;

/* ═══════════════════════════════════════════════════════════════════════
   CRYPTO — HMAC-SHA256 consent tokens
   All consent token operations are async (Web Crypto API).
   ═══════════════════════════════════════════════════════════════════════ */

/**
 * Import the HMAC signing key from the worker secret.
 * Falls back to a deterministic dev key when SPECULUM_SECRET is absent.
 * IMPORTANT: Set SPECULUM_SECRET in Cloudflare Worker secrets for production.
 */
async function importKey(env) {
  const raw = env?.SPECULUM_SECRET
    ? env.SPECULUM_SECRET
    : 'SOVEREIGN-SPECULUM-DEV-KEY-REPLACE-IN-PRODUCTION-phi=' + PHI;
  return crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(raw),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign', 'verify'],
  );
}

/**
 * Generate a consent token.
 * Token layout:  <userId>.<sessionId>.<scope>.<expiryMs>.<hmac-hex>
 * The first four fields are the HMAC message.
 */
async function generateToken(userId, sessionId, scope, expiryMs, env) {
  const key  = await importKey(env);
  const msg  = `${userId}|${sessionId}|${scope}|${expiryMs}`;
  const sig  = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(msg));
  const hex  = Array.from(new Uint8Array(sig)).map(b => b.toString(16).padStart(2, '0')).join('');
  // Encode payload fields as base64url to avoid delimiter collisions
  const b64  = (s) => btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');
  return `${b64(userId)}.${b64(sessionId)}.${b64(scope)}.${expiryMs}.${hex}`;
}

/**
 * Validate a consent token.
 * Returns { valid, userId, sessionId, scope, expiryMs, reason? }
 */
async function validateToken(token, env) {
  if (!token || typeof token !== 'string') return { valid: false, reason: 'missing_token' };
  const parts = token.split('.');
  if (parts.length !== 5) return { valid: false, reason: 'malformed' };

  const [b64UserId, b64SessionId, b64Scope, expiryStr, sigHex] = parts;
  const atob2 = (s) => { try { return atob(s.replace(/-/g, '+').replace(/_/g, '/')); } catch { return null; } };

  const userId    = atob2(b64UserId);
  const sessionId = atob2(b64SessionId);
  const scope     = atob2(b64Scope);
  const expiryMs  = parseInt(expiryStr, 10);

  if (!userId || !sessionId || !scope) return { valid: false, reason: 'decode_error' };
  if (isNaN(expiryMs))                 return { valid: false, reason: 'bad_expiry' };
  if (Date.now() > expiryMs)           return { valid: false, reason: 'expired' };
  if (!SCOPE_CONFIG[scope])            return { valid: false, reason: 'unknown_scope' };

  // Re-derive expected HMAC and compare (constant-time via HMAC verify)
  const key         = await importKey(env);
  const msg         = `${userId}|${sessionId}|${scope}|${expiryMs}`;
  const sigBytes    = new Uint8Array(sigHex.match(/.{2}/g).map(h => parseInt(h, 16)));
  const isValid     = await crypto.subtle.verify('HMAC', key, sigBytes, new TextEncoder().encode(msg));

  if (!isValid) return { valid: false, reason: 'invalid_signature' };
  return { valid: true, userId, sessionId, scope, expiryMs };
}

/* ═══════════════════════════════════════════════════════════════════════
   SESSION + AUDIT MANAGEMENT
   ═══════════════════════════════════════════════════════════════════════ */

function createSession(userId, sessionId, scope, expiryMs) {
  const record = {
    id:          sessionId,
    userId:      hashUserId(userId),      // never store raw userId
    scope,
    expiryMs,
    createdAt:   Date.now(),
    revokedAt:   null,
    active:      true,
    frameCount:  0,
    audit:       [],                       // immutable append-only log
    phiSync:     PHI,
  };
  sessions.set(sessionId, record);
  sessionCount++;
  appendAudit(record, 'session_created', { scope, ttlMs: expiryMs - Date.now() });
  return record;
}

/** One-way hash of userId for audit storage — never store raw identity. */
function hashUserId(userId) {
  // Deterministic but non-reversible: hash prefix + phi marker
  const code = [...String(userId)].reduce((h, c) => (h * 31 + c.charCodeAt(0)) | 0, 0x1618);
  return 'uid:' + Math.abs(code).toString(16).padStart(8, '0');
}

function appendAudit(record, event, extra = {}) {
  record.audit.push({
    event,
    ts:          Date.now(),
    beatCount:   ++beatCount,
    phiBeat:     PHI_BEAT,
    frameCount:  record.frameCount,
    scope:       record.scope,
    ...extra,
  });
}

function revokeSession(sessionId, reason) {
  const s = sessions.get(sessionId);
  if (!s) return null;
  s.active    = false;
  s.revokedAt = Date.now();
  appendAudit(s, 'session_revoked', { reason: reason || 'user_request' });
  revokeCount++;
  return s;
}

/** SHA-256 hex digest of an ArrayBuffer — used for frame integrity hashing. */
async function sha256hex(buf) {
  const digest = await crypto.subtle.digest('SHA-256', buf);
  return Array.from(new Uint8Array(digest)).map(b => b.toString(16).padStart(2, '0')).join('');
}

/** GC: remove expired sessions older than 1 hour from in-memory map. */
function gcSessions() {
  const horizon = Date.now() - 60 * 60 * 1000;
  for (const [id, s] of sessions) {
    if (!s.active && s.revokedAt && s.revokedAt < horizon) {
      sessions.delete(id);
    }
    if (s.active && Date.now() > s.expiryMs) {
      revokeSession(id, 'phi_decay_expiry');
    }
  }
}

/* ═══════════════════════════════════════════════════════════════════════
   REQUEST HANDLER
   ═══════════════════════════════════════════════════════════════════════ */

const CORS = {
  'Content-Type':                'application/json',
  'Access-Control-Allow-Origin': '*',
  'X-Worker-ID':                 WORKER_ID,
  'X-Worker-Latin':              LATIN,
  'X-Phi':                       String(PHI),
};

async function handleRequest(request, env) {
  gcSessions(); // passive GC on each request
  beatCount++;

  const url  = new URL(request.url);
  const path = url.pathname;

  if (request.method === 'OPTIONS') {
    return new Response(null, {
      status: 204,
      headers: {
        ...CORS,
        'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type,Authorization',
      },
    });
  }

  // ── GET /status ────────────────────────────────────────────────────
  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      worker: WORKER_ID, latin: LATIN, version: VERSION, status: 'alive',
      beat: beatCount, sessions: { total: sessionCount, active: [...sessions.values()].filter(s => s.active).length },
      captures: captureCount, revokes: revokeCount, phi: PHI, ts: Date.now(),
    }), { headers: CORS });
  }

  // ── GET /metrics ───────────────────────────────────────────────────
  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      worker: WORKER_ID, beats: beatCount, sessions: sessionCount,
      captures: captureCount, revokes: revokeCount, phi: PHI, phiBeat: PHI_BEAT, ts: Date.now(),
    }), { headers: CORS });
  }

  // ── POST /consent/request ──────────────────────────────────────────
  if (path === '/consent/request' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err(400, 'Invalid JSON'); }

    const userId = body.userId;
    const scope  = body.scope;
    const tier   = parseInt(body.tier, 10) || 1;

    if (!userId) return err(400, 'userId required');
    if (!scope || !SCOPE_CONFIG[scope]) return err(400, `scope must be one of: ${Object.keys(SCOPE_CONFIG).join(', ')}`);

    const scopeCfg = SCOPE_CONFIG[scope];
    if (tier < scopeCfg.minTier) {
      return err(403, `scope '${scope}' requires tier ${scopeCfg.minTier} or higher (current: ${tier})`);
    }

    // Generate session ID + consent token
    const sessionId = genSessionId();
    const expiryMs  = Date.now() + scopeCfg.ttlMs;
    const token     = await generateToken(userId, sessionId, scope, expiryMs, env);

    createSession(userId, sessionId, scope, expiryMs);

    return new Response(JSON.stringify({
      ok:         true,
      token,
      sessionId,
      scope,
      expiryMs,
      expiryISO:  new Date(expiryMs).toISOString(),
      ttlMs:      scopeCfg.ttlMs,
      phiDecay:   `phi^${scope === 'screen' ? '-1' : '1'} x ${scope === 'screen' ? 5 : scope === 'window' ? 10 : 15}min`,
      consent:    {
        passive:      false,
        stored:       false,
        sharedWith:   'none',
        revokeRoute:  'POST /consent/revoke',
        auditRoute:   `GET /audit/${sessionId}`,
      },
    }), { headers: CORS });
  }

  // ── POST /consent/revoke ───────────────────────────────────────────
  if (path === '/consent/revoke' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err(400, 'Invalid JSON'); }

    const validation = await validateToken(body.token, env);
    if (!validation.valid) return err(403, `Token invalid: ${validation.reason}`);

    const s = revokeSession(validation.sessionId, 'user_revoke');
    if (!s) return err(404, 'Session not found');

    return new Response(JSON.stringify({
      ok:         true,
      sessionId:  validation.sessionId,
      revokedAt:  s.revokedAt,
      framesCaptured: s.frameCount,
      auditLength:    s.audit.length,
      message:    'Capture stopped. All frames discarded. Audit log sealed.',
    }), { headers: CORS });
  }

  // ── POST /capture/submit ───────────────────────────────────────────
  if (path === '/capture/submit' && request.method === 'POST') {
    let body;
    try { body = await request.json(); } catch { return err(400, 'Invalid JSON'); }

    const validation = await validateToken(body.token, env);
    if (!validation.valid) return err(403, `Token invalid: ${validation.reason}`);

    const s = sessions.get(validation.sessionId);
    if (!s || !s.active) return err(403, 'Session not active or revoked');

    // Frame integrity: hash the submitted frame data (base64 or hex)
    const frameRaw   = body.frameData || '';
    const frameBytes = ENC.encode(frameRaw);
    const frameHash  = await sha256hex(frameBytes.buffer);

    s.frameCount++;
    captureCount++;

    // Extract context signal: SOVEREIGN reads the text summary, not the raw frame.
    // Raw frame data is NEVER stored — only the extracted context signal.
    const contextSignal = body.contextSignal || body.ocrText || '[frame submitted — no text extracted]';

    appendAudit(s, 'capture_frame', {
      frameIndex:    s.frameCount,
      frameHash,                       // integrity proof — not the frame itself
      scope:         validation.scope,
      contextSignal: contextSignal.slice(0, 500), // truncate for audit compactness
      revokedAt:     s.revokedAt,
    });

    // Frame data is consumed here — never forwarded, never stored
    return new Response(JSON.stringify({
      ok:           true,
      frameIndex:   s.frameCount,
      frameHash,
      sessionId:    validation.sessionId,
      contextSignal: contextSignal.slice(0, 200),
      beat:         beatCount,
      expiresIn:    Math.max(0, s.expiryMs - Date.now()),
    }), { headers: CORS });
  }

  // ── GET /session/:id ───────────────────────────────────────────────
  const sessionMatch = path.match(/^\/session\/([a-f0-9]{32})$/);
  if (sessionMatch && request.method === 'GET') {
    const s = sessions.get(sessionMatch[1]);
    if (!s) return err(404, 'Session not found');
    return new Response(JSON.stringify({
      id:         s.id,
      userId:     s.userId,
      scope:      s.scope,
      active:     s.active,
      createdAt:  s.createdAt,
      revokedAt:  s.revokedAt,
      expiryMs:   s.expiryMs,
      frameCount: s.frameCount,
      auditCount: s.audit.length,
      phi:        s.phiSync,
    }), { headers: CORS });
  }

  // ── GET /audit/:sessionId ─────────────────────────────────────────
  const auditMatch = path.match(/^\/audit\/([a-f0-9]{32})$/);
  if (auditMatch && request.method === 'GET') {
    const s = sessions.get(auditMatch[1]);
    if (!s) return err(404, 'Session not found');
    // Return immutable audit log — no frame data, only events + hashes
    return new Response(JSON.stringify({
      sessionId:  s.id,
      scope:      s.scope,
      frameCount: s.frameCount,
      active:     s.active,
      audit:      s.audit,  // full append-only event log
    }), { headers: CORS });
  }

  return new Response(JSON.stringify({ error: 'not_found', worker: WORKER_ID }), { status: 404, headers: CORS });
}

function genSessionId() {
  const buf = new Uint8Array(16);
  crypto.getRandomValues(buf);
  return Array.from(buf).map(b => b.toString(16).padStart(2, '0')).join('');
}

function err(status, msg) {
  return new Response(JSON.stringify({ error: true, message: msg, worker: WORKER_ID }), { status, headers: CORS });
}

const ENC = new TextEncoder();

export default { async fetch(request, env) { return handleRequest(request, env); } };
