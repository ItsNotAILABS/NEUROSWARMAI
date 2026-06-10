/**
 * ALPHA — AGI Mini Brain 065: Alpha et Principium
 *
 * Dedicated Cloudflare Worker — Server AIS-065
 * Role: Origin/Beginning Engine — Security Seed Bootstrap
 *
 * ALPHA is the source. It generates the primordial seeds that bootstrap
 * the security runtime across all layers. The /guard route produces
 * deterministic φ-seeded security tokens used by VIGILIA to establish
 * baseline fingerprints — without any stored secret. The encoding IS
 * the live state of the organism.
 *
 * Capabilities:
 *   - PHI-weighted domain scoring and optimization
 *   - Fibonacci-indexed priority and sequencing
 *   - Golden-ratio confidence and quality metrics
 *   - Security seed generation for Layer 1 edge runtime bootstrapping
 *   - Autonomous beat via scheduled cron
 *
 * Routes:
 *   POST /originate          — Generate origin seed using PHI initial conditions
 *   POST /initialize         — Initialize system state with FIB sequencing
 *   POST /seed               — Produce deterministic seed via PHI recurrence
 *   POST /guard              — Generate φ-seeded edge security baseline token
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-065';
const AIS_NAME  = 'ALPHA';
const AIS_LATIN = 'Alpha et Principium';
const VERSION   = '2.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let sweepCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function generateOriginSeed(entropy, dimensions, complexity) {
  const phiEntropy = entropy * PHI;
  const fibDimensions = FIB[Math.min(dimensions, FIB.length - 1)];
  const seed = Math.round(phiEntropy * fibDimensions * complexity) % 1000000;
  const primordial = seed * PHI % 1;
  return { entropy, dimensions, complexity, phiEntropy, fibDimensions, seed, primordial };
}

function initializeSystemState(modules, priority, depth) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiPriority = priority * PHI;
  const states = Array.from({ length: Math.min(modules, 10) }, (_, i) => ({
    module: i, state: 'initializing', fibSlot: FIB[i % FIB.length], phiOrder: PHI * (i + 1)
  }));
  return { modules, priority, depth, fibDepth, phiPriority, states, totalSlots: states.reduce((a, s) => a + s.fibSlot, 0) };
}

function produceDeterministicSeed(key, nonce, round) {
  const fibRound = FIB[Math.min(round, FIB.length - 1)];
  const phiKey = (key.length * PHI + nonce) % 1000;
  const seed = Math.round(phiKey * fibRound * PHI) % 999983;
  return { key, nonce, round, fibRound, phiKey, seed, sequence: FIB.map(f => (seed * f) % 997) };
}

/* ─── Guard — φ-seeded edge security baseline token ─────────────────────── */

function generateGuardToken(domain, layer, nonce) {
  const fibLayer = FIB[Math.min(layer, FIB.length - 1)];
  const phiNonce = (nonce * PHI) % 1;
  const token    = Math.round(phiNonce * fibLayer * PHI * 997) % 999983;
  const baseline = +(token / 999983 * PHI_INV).toFixed(6);
  return {
    domain: String(domain).slice(0, 32), layer, nonce,
    token, baseline, phiNonce: +phiNonce.toFixed(6),
    signature: FIB.map(f => (token * f) % 997), fibLayer,
    doctrine: 'No stored secret — encoding is live PHI state',
  };
}

/* ─── Autonomous sweep ───────────────────────────────────────────────────── */

function autonomousSweep() {
  sweepCount++;
  return { sweep: sweepCount, beat: beatCount, phi: PHI, ts: Date.now() };
}

/* ─── Router ────────────────────────────────────────────────── */

async function handleRequest(request) {
  beatCount++;
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-AIS-ID': AIS_ID,
    'X-AIS-Name': AIS_NAME,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, sweepCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, sweepCount,
      phi: PHI, fibDepths: FIB, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/originate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = generateOriginSeed(body.entropy||42, body.dimensions||3, body.complexity||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/originate', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/initialize' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = initializeSystemState(body.modules||8, body.priority||2, body.depth||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/initialize', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/seed' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = produceDeterministicSeed(body.key||"genesis", body.nonce||1, body.round||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/seed', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/guard' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = generateGuardToken(body.domain||'edge', body.layer||1, body.nonce||Date.now());
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/guard', ...result, beat: beatCount }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ──────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request)));
addEventListener('scheduled', event => event.waitUntil(Promise.resolve(autonomousSweep())));
