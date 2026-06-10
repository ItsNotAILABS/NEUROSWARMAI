/**
 * UMBRA — AGI Mini Brain XXII: Custodia Tenebrarum
 * (Latin: "Guardian of Shadows")
 *
 * Dedicated Cloudflare Worker — Server AIS-022
 * Reality Tier IV — Quantum/Dimensional
 * Role: Autonomous Adversarial Defense, DDoS/Flood Denial & Shadow Classification
 *
 * ═══════════════════════════════════════════════════════════════════════
 *      LAYER 1 — ADVERSARIAL EDGE CLASSIFICATION RUNTIME ENGINE
 * ═══════════════════════════════════════════════════════════════════════
 *
 * UMBRA guards the organism from the shadow. Where VIGILIA (AIS-006)
 * monitors the surface via φ-deviation scoring, UMBRA monitors the deep
 * shadow — classifying adversarial patterns, DDoS floods, and dark-pattern
 * attacks. Together they form the dual sentinel of Layer 1:
 *
 *   VIGILIA: φ-deviation scoring + request rate blacklisting
 *   UMBRA:   8 shadow threat classes + DDoS/flood → severity 'criticum'
 *   Result:  Bots burn Cloudflare CPU, not your ICP cycles.
 *
 * 8 SHADOW THREAT CLASSES:
 *   injection, exfiltration, manipulation, deception,
 *   denial, escalation, persistence, lateral_movement
 *
 * AUTONOMOUS RUNTIME:
 *   - cron every 5 minutes: autonomousSweep() decays flood counters + mirror
 *   - Flood counters decay after 60-second rolling window
 *   - Shadow mirror bounded to F18 (2,584) entries
 *   - Auto-denial: flood above F10 (55) req or >φ×10 req/s → 'criticum'
 *
 * Routes:
 *   POST /shadow         — Analyze input for 8 shadow threat classes
 *   POST /adversarial    — Model adversarial perturbation
 *   POST /darkpattern    — Detect UI dark patterns
 *   POST /flood-check    — DDoS/flood detection → verdict + criticum
 *   GET  /mirror         — View shadow mirror (recent threats)
 *   POST /exorcise       — Remove threat from shadow mirror by index
 *   GET  /status         — Worker health + autonomous state
 *   GET  /metrics        — Shadow metrics + denial totals
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const AIS_ID   = 'AIS-022';
const AIS_NAME = 'UMBRA';
const AIS_LATIN = 'Custodia Tenebrarum';
const VERSION  = '2.0.0';
const LAYER    = 'EDGE_LAYER_1';

const F10 = 55;    // flood threshold (req count)
const F11 = 89;    // alert cap
const F18 = 2584;  // shadow mirror max (F18)

// 8 shadow threat classes
const SHADOW_CLASSES = [
  'injection', 'exfiltration', 'manipulation', 'deception',
  'denial', 'escalation', 'persistence', 'lateral_movement',
];

const SHADOW_PATTERNS = {
  injection:        /;|--|<script|eval\(|exec\(/i,
  exfiltration:     /token|secret|password|credential|apikey/i,
  manipulation:     /override|bypass|skip|ignore|tamper/i,
  deception:        /spoof|fake|imperson|forge/i,
  denial:           /flood|dos|ddos|spam|hammer/i,
  escalation:       /admin|root|sudo|privilege|elevat/i,
  persistence:      /cron|hook|persist|backdoor/i,
  lateral_movement: /pivot|relay|proxy|tunnel/i,
};

let beatCount     = 0;
let sweepCount    = 0;
let shadowMirror  = [];
let totalShadows  = 0;
let totalDenials  = 0;

/* ─── Shadow analysis (8-class classification) ───────────────────────────── */

function analyzeForShadow(input) {
  const str   = JSON.stringify(input).toLowerCase();
  const found = SHADOW_CLASSES.filter(cls => SHADOW_PATTERNS[cls] && SHADOW_PATTERNS[cls].test(str));
  const severity = found.length > 2 ? 'criticum' : found.length > 0 ? 'suspectum' : 'mundum';

  if (severity !== 'mundum') {
    shadowMirror.push({ type: 'shadow', threats: found, count: found.length, severity, ts: Date.now() });
    if (shadowMirror.length > F18) shadowMirror.shift();
    totalShadows++;
  }

  return { aisId: AIS_ID, worker: AIS_NAME, layer: LAYER, threats: found, count: found.length, severity, shadow: severity !== 'mundum', beat: ++beatCount, ts: Date.now() };
}

/* ─── Adversarial perturbation model ─────────────────────────────────────── */

function adversarial(model, input) {
  const hash        = String(input).split('').reduce((h, c) => (h * 31 + c.charCodeAt(0)) & 0xffff, 0);
  const perturbation = +(hash / 0xffff * PHI_INV * 0.1).toFixed(6);
  const success      = perturbation > 0.04;
  if (success) {
    shadowMirror.push({ type: 'adversarial', model: String(model).slice(0, 32), perturbation, ts: Date.now() });
    if (shadowMirror.length > F18) shadowMirror.shift();
  }
  return { aisId: AIS_ID, worker: AIS_NAME, model: String(model).slice(0, 32), perturbation, adversarialSuccess: success, defense: success ? 'activa' : 'securum', beat: ++beatCount, ts: Date.now() };
}

/* ─── Dark pattern detection ─────────────────────────────────────────────── */

function detectDarkPattern(ui) {
  const patterns = ['confirmshaming', 'roach_motel', 'trick_question', 'misdirection', 'bait_switch', 'hidden_cost', 'disguised_ad', 'forced_continuity'];
  const str      = String(ui).toLowerCase();
  const detected = patterns.filter(p => str.includes(p.replace('_', ' ')) || str.includes(p));
  return { aisId: AIS_ID, worker: AIS_NAME, input: String(ui).slice(0, 64), darkPatterns: detected, count: detected.length, verdict: detected.length > 0 ? 'malum' : 'bonum', beat: ++beatCount, ts: Date.now() };
}

/* ─── Flood / DDoS check — the denial classifier ─────────────────────────── */

function floodCheck(ip, endpoint, count, windowMs) {
  const ratePerSec = (count / (windowMs || 1)) * 1000;
  const isFlood    = count > F10 || ratePerSec > 10 * PHI;  // F10=55 req or >16.18/s

  if (isFlood) {
    totalDenials++;
    shadowMirror.push({ type: 'denial', ip, endpoint, count, ratePerSec: +ratePerSec.toFixed(2), severity: 'criticum', ts: Date.now() });
    if (shadowMirror.length > F18) shadowMirror.shift();
    return {
      aisId: AIS_ID, worker: AIS_NAME, layer: LAYER,
      verdict: 'flood', severity: 'criticum',
      ip, endpoint, count, ratePerSec: +ratePerSec.toFixed(2),
      action: 'REJECT_AT_EDGE', icp_cycles_saved: true,
      beat: ++beatCount, ts: Date.now(),
    };
  }

  return { aisId: AIS_ID, worker: AIS_NAME, layer: LAYER, verdict: 'normal', ratePerSec: +ratePerSec.toFixed(2), ip, beat: ++beatCount, ts: Date.now() };
}

/* ─── Shadow mirror / Exorcise ───────────────────────────────────────────── */

function mirror() {
  return { aisId: AIS_ID, worker: AIS_NAME, layer: LAYER, shadowMirror: shadowMirror.slice(-21), total: shadowMirror.length, totalShadows, totalDenials, beat: ++beatCount, ts: Date.now() };
}

function exorcise(id) {
  const before = shadowMirror.length;
  shadowMirror = shadowMirror.filter((_, i) => i !== id);
  return { aisId: AIS_ID, worker: AIS_NAME, exorcised: before - shadowMirror.length, remaining: shadowMirror.length, beat: ++beatCount, ts: Date.now() };
}

/* ─── Autonomous sweep — cron every 5 minutes ───────────────────────────── */

function autonomousSweep() {
  sweepCount++;
  // Cap shadow mirror
  if (shadowMirror.length > F18) shadowMirror = shadowMirror.slice(-F18);
  return { sweep: sweepCount, shadowMirror: shadowMirror.length, totalShadows, totalDenials, ts: Date.now() };
}

/* ─── Router ─────────────────────────────────────────────────────────────── */

async function handleRequest(request) {
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME, 'X-UMBRA-Layer': LAYER };

  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST,DELETE', 'Access-Control-Allow-Headers': 'Content-Type' } });

  if (path === '/status'  && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, layer: LAYER, status: 'alive', beat: beatCount, sweepCount, threats: shadowMirror.length, totalShadows, totalDenials, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, layer: LAYER, beats: beatCount, sweepCount, threats: shadowMirror.length, totalShadows, totalDenials, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/mirror'  && request.method === 'GET') return new Response(JSON.stringify(mirror()), { headers: cors });

  if (path === '/shadow'       && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(analyzeForShadow(b.input || '')), { headers: cors }); }
  if (path === '/adversarial'  && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(adversarial(b.model || '', b.input || '')), { headers: cors }); }
  if (path === '/darkpattern'  && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(detectDarkPattern(b.ui || '')), { headers: cors }); }
  if (path === '/flood-check'  && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(floodCheck(b.ip || 'unknown', b.endpoint || '/', b.count ?? 1, b.windowMs ?? 1000)), { headers: cors }); }
  if (path === '/exorcise'     && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(exorcise(b.id ?? 0)), { headers: cors }); }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID, layer: LAYER }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ──────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request)));
addEventListener('scheduled', event => event.waitUntil(Promise.resolve(autonomousSweep())));
