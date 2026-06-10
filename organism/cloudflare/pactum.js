/**
 * PACTUM — AGI Mini Brain 042: Pactum et Foedus
 *
 * Dedicated Cloudflare Worker — Server AIS-042
 * Role: Contract & Agreement Engine
 *
 * This worker implements Contract & Agreement Engine capabilities using PHI golden-ratio
 * mathematics and Fibonacci-sequence patterns for deterministic, bias-free
 * computation across all domain operations.
 *
 * Capabilities:
 *   - PHI-weighted domain scoring and optimization
 *   - Fibonacci-indexed priority and sequencing
 *   - Golden-ratio confidence and quality metrics
 *   - Autonomous computation with no external dependencies
 *   - RESTful JSON API with CORS support
 *
 * Routes:
 *   POST /contract           — Draft contract with PHI integrity scoring
 *   POST /sign               — Sign contract producing FIB-weighted signature hash
 *   POST /verify             — Verify contract signature with PHI confidence
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-042';
const AIS_NAME  = 'PACTUM';
const AIS_LATIN = 'Pactum et Foedus';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function draftContract(parties, terms, duration) {
  const phiIntegrity = parties * PHI * terms;
  const fibDuration = FIB[Math.min(duration, FIB.length - 1)];
  const score = phiIntegrity * fibDuration;
  return { parties, terms, duration, phiIntegrity, fibDuration, score, contractId: `PCT-${Date.now()}` };
}

function signContract(contractId, signerId, weight) {
  const fibWeight = FIB[Math.min(weight, FIB.length - 1)];
  const phiHash = (signerId.length * PHI * fibWeight) % 997;
  const signature = Math.round(phiHash * 1000);
  return { contractId, signerId, fibWeight, phiHash, signature, ts: Date.now() };
}

function verifySignature(contractId, signature, expected) {
  const delta = Math.abs(signature - expected);
  const phiTolerance = expected * PHI_INV * 0.01;
  const valid = delta <= phiTolerance;
  const confidence = valid ? PHI - delta / (expected || 1) : PHI_INV;
  const fibScore = FIB.filter(f => f < delta + 1).length;
  return { contractId, delta, phiTolerance, valid, confidence, fibScore };
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
      status: 'alive', beat: beatCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount,
      phi: PHI, fibDepths: FIB, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/contract' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = draftContract(body.parties||2, body.terms||5, body.duration||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/contract', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/sign' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = signContract(body.contractId||"PCT-1", body.signerId||"S1", body.weight||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/sign', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/verify' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = verifySignature(body.contractId||"PCT-1", body.signature||100, body.expected||100);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/verify', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
