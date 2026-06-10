/**
 * PLENUM — AGI Mini Brain 067: Plenum et Totum
 *
 * Dedicated Cloudflare Worker — Server AIS-067
 * Role: Wholeness Engine
 *
 * This worker implements Wholeness Engine capabilities using PHI golden-ratio
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
 *   POST /whole              — Assess wholeness score using PHI integration
 *   POST /integrate          — Integrate subsystems with FIB harmonic weights
 *   POST /complete           — Score completeness via PHI-ratio gap analysis
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-067';
const AIS_NAME  = 'PLENUM';
const AIS_LATIN = 'Plenum et Totum';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function assessWholenessScore(components, present, harmony) {
  const phiHarmony = harmony * PHI;
  const fibComponents = FIB[Math.min(components, FIB.length - 1)];
  const completeness = present / (components || 1);
  const wholeness = completeness * phiHarmony * fibComponents;
  return { components, present, harmony, phiHarmony, fibComponents, completeness, wholeness, whole: completeness >= PHI_INV };
}

function integrateSubsystems(systems, weights, coupling) {
  const phiCoupling = coupling * PHI;
  const fibSystems = FIB[Math.min(systems.length, FIB.length - 1)];
  const integrated = systems.map((s, i) => ({
    system: s, weight: weights[i] || 1, fibHarmonic: FIB[i % FIB.length], contribution: (weights[i] || 1) * PHI
  }));
  const totalHarmony = integrated.reduce((a, s) => a + s.fibHarmonic * s.contribution, 0);
  return { systemCount: systems.length, coupling, phiCoupling, fibSystems, integrated, totalHarmony };
}

function scoreCompleteness(required, provided, critical) {
  const fibCritical = FIB[Math.min(critical, FIB.length - 1)];
  const coverage = provided / (required || 1);
  const phiCoverage = coverage * PHI;
  const gap = 1 - coverage;
  const score = phiCoverage * fibCritical * (1 - gap * PHI_INV);
  return { required, provided, critical, coverage, phiCoverage, gap, fibCritical, score, complete: gap < PHI_INV * 0.1 };
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

  if (path === '/whole' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = assessWholenessScore(body.components||10, body.present||9, body.harmony||0.9);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/whole', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/integrate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = integrateSubsystems(body.systems||["A","B","C"], body.weights||[1,2,1], body.coupling||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/integrate', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/complete' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreCompleteness(body.required||10, body.provided||9, body.critical||4);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/complete', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
