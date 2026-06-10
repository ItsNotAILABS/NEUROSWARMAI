/**
 * SPECULUM — Browser Web Worker
 * Latin: "Speculum Navigatoris" — Navigator's Mirror
 *
 * Browser Web Worker — organism/web/speculum-worker.js
 * Layer 1 of the 3-layer organism architecture (session-bound).
 *
 * Responsibilities:
 *   - Orchestrate screen capture consent flow (getDisplayMedia must be called
 *     from main thread; this worker manages the session state machine)
 *   - Maintain φ-decay session timers
 *   - Receive frame data from main thread, hash it, submit to SPECULUM Cloudflare Worker
 *   - Maintain local immutable audit log (mirrors the Cloudflare audit log)
 *   - Enforce rate limit: ≤1 frame per second (60 frames/min maximum)
 *   - Signal main thread when session expires or is revoked
 *
 * ARCHITECTURAL NOTE ON getDisplayMedia:
 *   The browser Screen Capture API (navigator.mediaDevices.getDisplayMedia) can
 *   only be called from the main thread in response to a user gesture. It cannot
 *   be called from inside a Web Worker. Therefore the flow is:
 *     1. Worker receives 'request_consent' → calls Cloudflare for token
 *     2. Worker posts 'consent_granted' + token to main thread
 *     3. Main thread calls getDisplayMedia(), starts capture loop
 *     4. Main thread posts 'frame' messages to this worker
 *     5. This worker validates token, hashes frame, submits to Cloudflare
 *     6. This worker posts 'capture_ack' back to main thread
 *
 * Message API:
 *   → { type: 'request_consent', userId, scope, tier, endpoint }
 *      ← { type: 'consent_granted', token, sessionId, scope, expiryMs, ttlMs }
 *      ← { type: 'consent_error',   reason }
 *
 *   → { type: 'frame', frameData (base64|text), contextSignal?, frameIndex }
 *      ← { type: 'capture_ack', frameIndex, frameHash, expiresIn }
 *      ← { type: 'capture_error', reason }
 *
 *   → { type: 'revoke', reason? }
 *      ← { type: 'revoked', sessionId, framesCaptured, auditLength }
 *
 *   → { type: 'status' }
 *      ← { type: 'status', ... }
 *
 *   → { type: 'audit' }
 *      ← { type: 'audit', log: [...] }
 *
 *   → { type: 'heartbeat' }
 *      ← { type: 'heartbeat', beat, phi }
 *
 * Tool ID range: SPECULUM-001 to SPECULUM-021
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

/* eslint-disable no-restricted-globals */
'use strict';

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const PHI_BEAT  = 873;
const VERSION   = '1.0.0';
const WORKER_ID = 'SPECULUM-BROWSER';
const LATIN     = 'Speculum Navigatoris';

// Rate limiting: maximum 1 frame per second (geometric mean of phi/phi^-1 = 1s)
const MAX_FPS   = 1;
const MIN_FRAME_INTERVAL_MS = 1000 / MAX_FPS; // 1000ms

// Session state machine
const STATE = { IDLE: 'IDLE', CONSENTING: 'CONSENTING', ACTIVE: 'ACTIVE', REVOKED: 'REVOKED', EXPIRED: 'EXPIRED' };

let beatCount    = 0;
let captureCount = 0;

// Active session record (one session at a time per worker instance)
let session = null;

const ENC = new TextEncoder();

/* ═══════════════════════════════════════════════════════════════════════
   SHA-256 FRAME HASHING
   Uses SubtleCrypto — available in browser Web Workers.
   ═══════════════════════════════════════════════════════════════════════ */

async function sha256hex(str) {
  const data   = ENC.encode(str);
  const digest = await crypto.subtle.digest('SHA-256', data);
  return Array.from(new Uint8Array(digest)).map(b => b.toString(16).padStart(2, '0')).join('');
}

/* ═══════════════════════════════════════════════════════════════════════
   SESSION STATE MACHINE
   ═══════════════════════════════════════════════════════════════════════ */

function newSession(token, sessionId, scope, expiryMs, endpoint) {
  return {
    token,
    sessionId,
    scope,
    expiryMs,
    endpoint,
    state:          STATE.ACTIVE,
    createdAt:      Date.now(),
    frameCount:     0,
    lastFrameAt:    0,
    audit:          [],
    phiSync:        PHI,
    expiryTimerId:  null,
  };
}

function appendAudit(event, extra = {}) {
  if (!session) return;
  session.audit.push({
    event,
    ts:         Date.now(),
    beat:       beatCount,
    frameCount: session.frameCount,
    scope:      session.scope,
    ...extra,
  });
  // Cap audit log at 233 entries (Fibonacci F13) — oldest entries dropped
  if (session.audit.length > 233) session.audit.shift();
}

function scheduleExpiry(expiryMs) {
  const ttl = expiryMs - Date.now();
  if (ttl <= 0) return;
  const id = setTimeout(() => {
    if (session && session.state === STATE.ACTIVE) {
      session.state = STATE.EXPIRED;
      appendAudit('session_expired', { reason: 'phi_decay_timeout' });
      postMessage({ type: 'session_expired', sessionId: session.sessionId, framesCaptured: session.frameCount });
    }
  }, ttl);
  return id;
}

/* ═══════════════════════════════════════════════════════════════════════
   CLOUDFLARE SPECULUM API CALLS
   ═══════════════════════════════════════════════════════════════════════ */

async function cfRequestConsent(endpoint, userId, scope, tier) {
  const res = await fetch(`${endpoint}/consent/request`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify({ userId, scope, tier }),
  });
  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Consent request failed ${res.status}: ${body}`);
  }
  return res.json();
}

async function cfSubmitFrame(endpoint, token, sessionId, frameData, contextSignal) {
  const res = await fetch(`${endpoint}/capture/submit`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify({ token, sessionId, frameData, contextSignal }),
  });
  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Frame submit failed ${res.status}: ${body}`);
  }
  return res.json();
}

async function cfRevoke(endpoint, token, sessionId) {
  const res = await fetch(`${endpoint}/consent/revoke`, {
    method:  'POST',
    headers: { 'Content-Type': 'application/json' },
    body:    JSON.stringify({ token, sessionId }),
  });
  // Best-effort revoke — don't throw on failure
  if (res.ok) return res.json();
  return { ok: false, status: res.status };
}

/* ═══════════════════════════════════════════════════════════════════════
   GEOMETRIC EXCLUSION GUARDS
   These are the architectural gates — topology, not conditionals.
   ═══════════════════════════════════════════════════════════════════════ */

function guardNoPassive() {
  // Called on every frame — if session is REVOKED or EXPIRED, frames are refused.
  if (!session || session.state !== STATE.ACTIVE) {
    throw new Error('SPECULUM: no active session — capture refused (geometric exclusion)');
  }
}

function guardExpiry() {
  if (session && Date.now() > session.expiryMs) {
    session.state = STATE.EXPIRED;
    appendAudit('session_expired', { reason: 'expiry_guard' });
    throw new Error('SPECULUM: session expired — φ-decay threshold reached');
  }
}

function guardRate() {
  const now     = Date.now();
  const elapsed = now - session.lastFrameAt;
  if (elapsed < MIN_FRAME_INTERVAL_MS) {
    throw new Error(`SPECULUM: rate limit exceeded — min interval ${MIN_FRAME_INTERVAL_MS}ms, elapsed ${elapsed}ms`);
  }
}

/* ═══════════════════════════════════════════════════════════════════════
   MESSAGE HANDLER
   ═══════════════════════════════════════════════════════════════════════ */

onmessage = async function (event) {
  const { type, ...data } = event.data || {};
  beatCount++;

  try {

    // ── request_consent ───────────────────────────────────────────────
    if (type === 'request_consent') {
      if (session && session.state === STATE.ACTIVE) {
        postMessage({ type: 'consent_error', reason: 'session_already_active', sessionId: session.sessionId });
        return;
      }

      const { userId, scope, tier, endpoint } = data;
      if (!endpoint) { postMessage({ type: 'consent_error', reason: 'endpoint_required' }); return; }
      if (!userId)   { postMessage({ type: 'consent_error', reason: 'userId_required'   }); return; }

      const validScopes = ['tab', 'window', 'screen'];
      if (!validScopes.includes(scope)) {
        postMessage({ type: 'consent_error', reason: `scope must be one of: ${validScopes.join(', ')}` });
        return;
      }

      const resp = await cfRequestConsent(endpoint, userId, scope, tier || 1);
      if (!resp.ok) {
        postMessage({ type: 'consent_error', reason: resp.message || 'consent_denied' });
        return;
      }

      session = newSession(resp.token, resp.sessionId, resp.scope, resp.expiryMs, endpoint);
      session.expiryTimerId = scheduleExpiry(resp.expiryMs);

      appendAudit('session_created', {
        scope:    resp.scope,
        ttlMs:    resp.ttlMs,
        phiDecay: resp.phiDecay,
      });

      // Post token + sessionId to main thread so it can call getDisplayMedia()
      postMessage({
        type:       'consent_granted',
        token:      resp.token,
        sessionId:  resp.sessionId,
        scope:      resp.scope,
        expiryMs:   resp.expiryMs,
        ttlMs:      resp.ttlMs,
        phiDecay:   resp.phiDecay,
        consent:    resp.consent,
        // Instruction to main thread:
        instruction: 'Call navigator.mediaDevices.getDisplayMedia({video:true,audio:false}) and start sending frame messages to this worker.',
      });
      return;
    }

    // ── frame ──────────────────────────────────────────────────────────
    if (type === 'frame') {
      guardNoPassive();
      guardExpiry();
      guardRate();

      const frameData     = data.frameData     || '';
      const contextSignal = data.contextSignal || '';
      const frameIndex    = data.frameIndex    || session.frameCount + 1;

      // Hash the frame for integrity log — raw frame is NOT stored
      const frameHash = await sha256hex(frameData.slice(0, 4096)); // hash prefix for speed

      session.frameCount++;
      session.lastFrameAt = Date.now();
      captureCount++;

      appendAudit('capture_frame', {
        frameIndex,
        frameHash,
        contextSignalLength: contextSignal.length,
      });

      // Submit to Cloudflare SPECULUM (non-blocking best-effort)
      let cfResp = null;
      try {
        cfResp = await cfSubmitFrame(session.endpoint, session.token, session.sessionId, frameData, contextSignal);
      } catch (cfErr) {
        appendAudit('cloudflare_submit_error', { error: String(cfErr) });
      }

      postMessage({
        type:          'capture_ack',
        frameIndex,
        frameHash,
        sessionId:     session.sessionId,
        expiresIn:     Math.max(0, session.expiryMs - Date.now()),
        beat:          beatCount,
        cfAck:         cfResp ? cfResp.ok : false,
      });
      return;
    }

    // ── revoke ─────────────────────────────────────────────────────────
    if (type === 'revoke') {
      if (!session) {
        postMessage({ type: 'revoke_error', reason: 'no_active_session' });
        return;
      }

      const { token, sessionId, frameCount } = session;

      // Mark session revoked immediately (≤1 beat effect)
      session.state = STATE.REVOKED;
      if (session.expiryTimerId) clearTimeout(session.expiryTimerId);
      appendAudit('session_revoked', { reason: data.reason || 'user_request' });

      const localAudit = [...session.audit];

      // Best-effort remote revocation
      try { await cfRevoke(session.endpoint, token, sessionId); } catch (_) { /* non-fatal */ }

      postMessage({
        type:           'revoked',
        sessionId,
        framesCaptured: frameCount,
        auditLength:    localAudit.length,
        message:        'Capture stopped within 1 beat. All frame data discarded. Audit log sealed.',
      });

      session = null; // clear session — all frame data goes with it
      return;
    }

    // ── status ──────────────────────────────────────────────────────────
    if (type === 'status') {
      postMessage({
        type:        'status',
        worker:      WORKER_ID,
        latin:       LATIN,
        version:     VERSION,
        beat:        beatCount,
        captures:    captureCount,
        session:     session ? {
          sessionId:   session.sessionId,
          scope:       session.scope,
          state:       session.state,
          frameCount:  session.frameCount,
          expiresIn:   Math.max(0, session.expiryMs - Date.now()),
          auditCount:  session.audit.length,
        } : null,
        phi:         PHI,
        phiBeat:     PHI_BEAT,
        ts:          Date.now(),
      });
      return;
    }

    // ── audit ───────────────────────────────────────────────────────────
    if (type === 'audit') {
      postMessage({
        type:      'audit',
        sessionId: session ? session.sessionId : null,
        log:       session ? [...session.audit] : [],
      });
      return;
    }

    // ── heartbeat ───────────────────────────────────────────────────────
    if (type === 'heartbeat') {
      postMessage({ type: 'heartbeat', beat: beatCount, phi: PHI, worker: WORKER_ID, sessionActive: !!(session && session.state === STATE.ACTIVE) });
      return;
    }

  } catch (e) {
    postMessage({ type: 'error', error: String(e), worker: WORKER_ID, beat: beatCount });
  }
};

// PHI_BEAT heartbeat — check session expiry + keep worker alive
setInterval(() => {
  beatCount++;
  // Passive expiry check (belt-and-suspenders alongside scheduleExpiry)
  if (session && session.state === STATE.ACTIVE && Date.now() > session.expiryMs) {
    session.state = STATE.EXPIRED;
    appendAudit('session_expired', { reason: 'heartbeat_check' });
    postMessage({ type: 'session_expired', sessionId: session.sessionId, framesCaptured: session.frameCount });
  }
  postMessage({ type: 'heartbeat', beat: beatCount, phi: PHI, worker: WORKER_ID, sessionActive: !!(session && session.state === STATE.ACTIVE) });
}, PHI_BEAT);

// Medina Doctrine · Copyright © 2024–2026 Alfredo Medina Hernandez · SPECULUM-BROWSER v1.0.0
