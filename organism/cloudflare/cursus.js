/**
 * CURSUS — AGI Mini Brain 048: Cursus et Progressus
 *
 * Dedicated Cloudflare Worker — Server AIS-048
 * Role: Career Path Engine
 *
 * This worker implements Career Path Engine capabilities using PHI golden-ratio
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
 *   POST /path               — Score career path options using PHI weights
 *   POST /progress           — Calculate progress percentile with PHI milestones
 *   POST /milestone          — Evaluate milestone achievement using FIB scoring
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-048';
const AIS_NAME  = 'CURSUS';
const AIS_LATIN = 'Cursus et Progressus';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreCareerPath(options, affinities, riskTolerance) {
  const phiRisk = riskTolerance * PHI;
  const scored = options.map((opt, i) => ({
    option: opt, affinity: affinities[i] || 0.5,
    score: (affinities[i] || 0.5) * PHI * FIB[i % FIB.length], phiRisk
  }));
  scored.sort((a, b) => b.score - a.score);
  return { scored, recommended: scored[0], phi: PHI };
}

function calculateProgressPercentile(completed, total, phiWeight) {
  const ratio = completed / (total || 1);
  const phiProgress = ratio * PHI * phiWeight;
  const fibSteps = FIB.filter(f => f <= completed).length;
  const percentile = Math.min(phiProgress * 100 / PHI, 100);
  return { completed, total, ratio, phiProgress, fibSteps, percentile };
}

function evaluateMilestone(milestoneId, achieved, expected, difficulty) {
  const fibDifficulty = FIB[Math.min(difficulty, FIB.length - 1)];
  const phiExpected = expected * PHI;
  const score = achieved / (phiExpected || 1) * fibDifficulty;
  const passed = score >= PHI_INV;
  return { milestoneId, achieved, expected, difficulty, fibDifficulty, phiExpected, score, passed };
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

  if (path === '/path' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreCareerPath(body.options||["eng","mgmt","research"], body.affinities||[0.9,0.6,0.8], body.riskTolerance||0.5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/path', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/progress' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateProgressPercentile(body.completed||7, body.total||10, body.phiWeight||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/progress', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/milestone' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = evaluateMilestone(body.milestoneId||"M1", body.achieved||85, body.expected||80, body.difficulty||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/milestone', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
