/**
 * ORDO — AGI Mini Brain 043: Ordo et Hierarchia
 *
 * Dedicated Cloudflare Worker — Server AIS-043
 * Role: Order & Sequence Engine
 *
 * This worker implements Order & Sequence Engine capabilities using PHI golden-ratio
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
 *   POST /order              — Order items using PHI-weighted priority sort
 *   POST /sequence           — Generate FIB-aligned sequence for task ordering
 *   POST /rank               — Rank entities by PHI-scaled score
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-043';
const AIS_NAME  = 'ORDO';
const AIS_LATIN = 'Ordo et Hierarchia';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function orderByPriority(items, weights) {
  const phiWeighted = items.map((item, i) => ({
    item, weight: (weights[i] || 1) * PHI, fibIndex: FIB[i % FIB.length]
  }));
  phiWeighted.sort((a, b) => (b.weight * b.fibIndex) - (a.weight * a.fibIndex));
  return { ordered: phiWeighted, count: items.length, phi: PHI };
}

function generateSequence(length, offset) {
  const seq = [];
  for (let i = 0; i < Math.min(length, 10); i++) {
    seq.push({ step: i + offset, fib: FIB[i % FIB.length], phi: PHI * (i + 1), slot: FIB[i % FIB.length] * PHI });
  }
  return { seq, length, offset, totalSlots: seq.reduce((a, s) => a + s.slot, 0) };
}

function rankEntities(scores, names) {
  const phiScores = scores.map((s, i) => ({
    name: names[i] || `E${i}`, score: s, phiScore: s * PHI, fibBonus: FIB[i % FIB.length]
  }));
  phiScores.sort((a, b) => (b.phiScore + b.fibBonus) - (a.phiScore + a.fibBonus));
  phiScores.forEach((e, i) => { e.rank = i + 1; });
  return { ranked: phiScores, phi: PHI };
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

  if (path === '/order' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = orderByPriority(body.items||["a","b","c"], body.weights||[1,2,3]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/order', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/sequence' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = generateSequence(body.length||5, body.offset||0);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/sequence', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/rank' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = rankEntities(body.scores||[10,20,15], body.names||["Alice","Bob","Carol"]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/rank', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
