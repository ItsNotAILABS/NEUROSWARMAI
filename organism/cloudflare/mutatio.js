/**
 * MUTATIO — AGI Mini Brain 060: Mutatio et Variatio
 *
 * Dedicated Cloudflare Worker — Server AIS-060
 * Role: Mutation Engine
 *
 * This worker implements Mutation Engine capabilities using PHI golden-ratio
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
 *   POST /mutate             — Apply mutation using PHI_INV rate adjustment
 *   POST /vary               — Score variation breadth with FIB exploration depth
 *   POST /explore            — Calculate exploration score via PHI divergence
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-060';
const AIS_NAME  = 'MUTATIO';
const AIS_LATIN = 'Mutatio et Variatio';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function applyMutation(genome, mutationRate, generation) {
  const phiRate = mutationRate * PHI_INV;
  const fibGen = FIB[Math.min(generation, FIB.length - 1)];
  const effectiveRate = phiRate / (fibGen || 1);
  const mutations = Math.round(genome * effectiveRate);
  return { genome, mutationRate, generation, phiRate, fibGen, effectiveRate, mutations, mutated: genome + mutations };
}

function scoreVariationBreadth(variants, diversity, depth) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiDiversity = diversity * PHI;
  const breadth = variants * phiDiversity * fibDepth;
  return { variants, diversity, depth, fibDepth, phiDiversity, breadth, rich: breadth > PHI * 10 };
}

function calculateExplorationScore(searchSpace, visited, temperature) {
  const phiTemp = temperature * PHI;
  const fibVisited = FIB[Math.min(Math.floor(visited / 10), FIB.length - 1)];
  const coverage = visited / (searchSpace || 1);
  const score = coverage * phiTemp * fibVisited;
  return { searchSpace, visited, temperature, phiTemp, fibVisited, coverage, score };
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

  if (path === '/mutate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = applyMutation(body.genome||1000, body.mutationRate||0.01, body.generation||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/mutate', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/vary' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreVariationBreadth(body.variants||50, body.diversity||0.7, body.depth||4);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/vary', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/explore' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateExplorationScore(body.searchSpace||1000, body.visited||200, body.temperature||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/explore', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
