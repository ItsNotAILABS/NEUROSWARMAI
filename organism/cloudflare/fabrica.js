/**
 * FABRICA — AGI Mini Brain 054: Fabrica et Manufactura
 *
 * Dedicated Cloudflare Worker — Server AIS-054
 * Role: Build & Deploy Engine
 *
 * This worker implements Build & Deploy Engine capabilities using PHI golden-ratio
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
 *   POST /build              — Score build priority using FIB dependency depth
 *   POST /deploy             — Assess deploy readiness with PHI quality gates
 *   POST /release            — Calculate release confidence using PHI and FIB
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-054';
const AIS_NAME  = 'FABRICA';
const AIS_LATIN = 'Fabrica et Manufactura';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreBuildPriority(artifact, depth, testCoverage) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiCoverage = testCoverage * PHI;
  const priority = fibDepth * phiCoverage;
  return { artifact, depth, testCoverage, fibDepth, phiCoverage, priority, queue: Math.ceil(priority) };
}

function assessDeployReadiness(checks, passed, rollbackReady) {
  const fibChecks = FIB[Math.min(checks, FIB.length - 1)];
  const phiPassed = passed * PHI;
  const readiness = (phiPassed / (checks || 1)) * (rollbackReady ? PHI : PHI_INV) * fibChecks;
  const ready = readiness >= fibChecks;
  return { checks, passed, rollbackReady, fibChecks, phiPassed, readiness, ready };
}

function calculateReleaseConfidence(version, incidents, testRuns) {
  const fibTestRuns = FIB[Math.min(testRuns, FIB.length - 1)];
  const incidentPenalty = incidents * PHI_INV;
  const phiVersion = (parseFloat(version) || 1) * PHI;
  const confidence = (fibTestRuns * phiVersion) / (incidentPenalty + 1);
  return { version, incidents, testRuns, fibTestRuns, phiVersion, incidentPenalty, confidence, go: confidence > PHI };
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

  if (path === '/build' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreBuildPriority(body.artifact||"app", body.depth||3, body.testCoverage||0.85);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/build', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/deploy' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = assessDeployReadiness(body.checks||10, body.passed||9, body.rollbackReady||true);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/deploy', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/release' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateReleaseConfidence(body.version||"1.0", body.incidents||0, body.testRuns||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/release', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
