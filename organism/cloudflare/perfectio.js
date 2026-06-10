/**
 * PERFECTIO — AGI Mini Brain 064: Perfectio et Excellentia
 *
 * Dedicated Cloudflare Worker — Server AIS-064
 * Role: Perfection Engine
 *
 * This worker implements Perfection Engine capabilities using PHI golden-ratio
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
 *   POST /optimize           — Optimize objective via PHI gradient scoring
 *   POST /refine             — Score refinement progress using FIB iteration depth
 *   POST /perfect            — Calculate perfection score with PHI convergence
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-064';
const AIS_NAME  = 'PERFECTIO';
const AIS_LATIN = 'Perfectio et Excellentia';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function optimizeObjective(current, target, step) {
  const phiStep = step * PHI;
  const delta = target - current;
  const fibStep = FIB[Math.min(Math.abs(Math.floor(delta)), FIB.length - 1)];
  const next = current + Math.sign(delta) * phiStep * PHI_INV;
  return { current, target, step, delta, phiStep, fibStep, next, improved: Math.abs(target - next) < Math.abs(delta) };
}

function scoreRefinementProgress(iterations, improvements, depth) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiProgress = (improvements / (iterations || 1)) * PHI;
  const score = phiProgress * fibDepth;
  return { iterations, improvements, depth, fibDepth, phiProgress, score, converged: phiProgress > PHI_INV };
}

function calculatePerfectionScore(metrics, ideal, tolerance) {
  const phiTolerance = tolerance * PHI;
  const fibMetrics = FIB.slice(0, metrics.length);
  const deltas = metrics.map((m, i) => Math.abs(m - (ideal[i] || 1)));
  const weightedDelta = deltas.reduce((a, d, i) => a + d * (fibMetrics[i] || 1), 0);
  const perfect = weightedDelta <= phiTolerance;
  const score = PHI / (weightedDelta + PHI_INV);
  return { metricCount: metrics.length, ideal, tolerance, weightedDelta, phiTolerance, perfect, score };
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

  if (path === '/optimize' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = optimizeObjective(body.current||0, body.target||100, body.step||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/optimize', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/refine' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreRefinementProgress(body.iterations||100, body.improvements||75, body.depth||4);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/refine', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/perfect' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculatePerfectionScore(body.metrics||[0.95,0.92,0.98], body.ideal||[1,1,1], body.tolerance||0.05);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/perfect', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
