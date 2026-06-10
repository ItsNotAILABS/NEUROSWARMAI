/**
 * STRUCTURA — AGI Mini Brain 051: Structura et Fabrica
 *
 * Dedicated Cloudflare Worker — Server AIS-051
 * Role: Architecture Engine
 *
 * This worker implements Architecture Engine capabilities using PHI golden-ratio
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
 *   POST /architect          — Score architecture design using PHI complexity
 *   POST /design             — Evaluate design quality with FIB layering
 *   POST /blueprint          — Validate blueprint completeness with PHI ratios
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-051';
const AIS_NAME  = 'STRUCTURA';
const AIS_LATIN = 'Structura et Fabrica';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreArchitectureDesign(layers, dependencies, cohesion) {
  const phiCohesion = cohesion * PHI;
  const fibLayers = FIB[Math.min(layers, FIB.length - 1)];
  const coupling = dependencies / (layers * layers || 1);
  const score = (phiCohesion / (coupling + PHI_INV)) * fibLayers;
  return { layers, dependencies, cohesion, phiCohesion, fibLayers, coupling, score };
}

function evaluateDesignQuality(patterns, antiPatterns, coverage) {
  const fibPatterns = patterns.reduce((a, _, i) => a + FIB[i % FIB.length], 0);
  const phiCoverage = coverage * PHI;
  const penalty = antiPatterns * PHI_INV;
  const quality = (fibPatterns * phiCoverage) - penalty;
  return { patternCount: patterns.length, antiPatterns, coverage, fibPatterns, phiCoverage, penalty, quality };
}

function validateBlueprint(sections, complete, criticalSections) {
  const fibCritical = FIB[Math.min(criticalSections, FIB.length - 1)];
  const completeness = complete / (sections || 1);
  const phiComplete = completeness * PHI;
  const valid = completeness >= PHI_INV && phiComplete >= 1;
  return { sections, complete, completeness, phiComplete, fibCritical, valid, score: phiComplete * fibCritical };
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

  if (path === '/architect' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreArchitectureDesign(body.layers||4, body.dependencies||8, body.cohesion||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/architect', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/design' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = evaluateDesignQuality(body.patterns||["MVC","CQRS","Event"], body.antiPatterns||1, body.coverage||0.9);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/design', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/blueprint' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = validateBlueprint(body.sections||10, body.complete||9, body.criticalSections||4);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/blueprint', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
