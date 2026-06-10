/**
 * GREX — AGI Mini Brain 055: Grex et Multitudo
 *
 * Dedicated Cloudflare Worker — Server AIS-055
 * Role: Swarm Intelligence Engine
 *
 * This worker implements Swarm Intelligence Engine capabilities using PHI golden-ratio
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
 *   POST /swarm              — Calculate swarm emergence index via PHI
 *   POST /emerge             — Score emergent behavior using FIB pattern depth
 *   POST /flock              — Compute flocking alignment score with PHI vectors
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-055';
const AIS_NAME  = 'GREX';
const AIS_LATIN = 'Grex et Multitudo';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function calculateEmergenceIndex(agents, interactions, density) {
  const phiDensity = density * PHI;
  const fibInteractions = FIB[Math.min(Math.floor(interactions / (agents || 1)), FIB.length - 1)];
  const emergence = Math.log1p(agents) * phiDensity * fibInteractions;
  return { agents, interactions, density, phiDensity, fibInteractions, emergence, complex: emergence > PHI * 10 };
}

function scoreEmergentBehavior(patterns, depth, coherence) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiCoherence = coherence * PHI;
  const patternScore = patterns.reduce((a, p, i) => a + p * FIB[i % FIB.length], 0);
  const behavior = patternScore * phiCoherence * fibDepth;
  return { patternCount: patterns.length, depth, coherence, fibDepth, phiCoherence, patternScore, behavior };
}

function computeFlockingAlignment(velocities, positions) {
  const avgVel = velocities.reduce((a, v) => a + v, 0) / (velocities.length || 1);
  const phiAvg = avgVel * PHI;
  const fibCohesion = FIB[Math.min(positions.length, FIB.length - 1)];
  const alignment = velocities.reduce((a, v) => a + Math.abs(v - avgVel), 0) / (velocities.length || 1);
  return { avgVel, phiAvg, fibCohesion, alignment, score: fibCohesion / (alignment * PHI + 1) };
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

  if (path === '/swarm' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateEmergenceIndex(body.agents||100, body.interactions||500, body.density||0.5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/swarm', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/emerge' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreEmergentBehavior(body.patterns||[1,0,1,1,0], body.depth||3, body.coherence||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/emerge', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/flock' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeFlockingAlignment(body.velocities||[1.0,1.1,0.9,1.05], body.positions||[0,1,2,3]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/flock', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
