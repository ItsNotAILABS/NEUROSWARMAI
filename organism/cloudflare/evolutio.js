/**
 * EVOLUTIO — AGI Mini Brain 061: Evolutio et Progressus
 *
 * Dedicated Cloudflare Worker — Server AIS-061
 * Role: Evolution Engine
 *
 * This worker implements Evolution Engine capabilities using PHI golden-ratio
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
 *   POST /evolve             — Evolve population using PHI fitness pressure
 *   POST /select             — Select top candidates via FIB tournament scoring
 *   POST /fitness            — Compute fitness score using PHI-normalized traits
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-061';
const AIS_NAME  = 'EVOLUTIO';
const AIS_LATIN = 'Evolutio et Progressus';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function evolvePopulation(population, fitnessScores, generations) {
  const phiPressure = PHI * (1 - 1 / (generations || 1));
  const fibGen = FIB[Math.min(generations, FIB.length - 1)];
  const survivors = Math.round(population * PHI_INV);
  const avgFitness = fitnessScores.reduce((a, f) => a + f, 0) / (fitnessScores.length || 1);
  return { population, survivors, avgFitness, phiPressure, fibGen, nextGen: survivors * fibGen };
}

function selectCandidates(candidates, scores, tournamentSize) {
  const fibSize = FIB[Math.min(tournamentSize, FIB.length - 1)];
  const phiScores = scores.map((s, i) => ({ candidate: candidates[i] || `C${i}`, score: s, phiScore: s * PHI, fibBonus: FIB[i % FIB.length] }));
  phiScores.sort((a, b) => (b.phiScore + b.fibBonus) - (a.phiScore + a.fibBonus));
  return { tournamentSize, fibSize, selected: phiScores.slice(0, fibSize), phi: PHI };
}

function computeFitnessScore(traits, weights, environment) {
  const phiEnv = environment * PHI;
  const fibWeights = FIB.slice(0, traits.length);
  const fitness = traits.reduce((a, t, i) => a + t * (weights[i] || 1) * (fibWeights[i] || 1), 0);
  const normalized = fitness / (traits.length * phiEnv || 1);
  return { traitCount: traits.length, weights, environment, phiEnv, fitness, normalized, elite: normalized > PHI_INV };
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

  if (path === '/evolve' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = evolvePopulation(body.population||100, body.fitnessScores||[0.8,0.6,0.9,0.7], body.generations||10);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/evolve', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/select' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = selectCandidates(body.candidates||["A","B","C","D","E"], body.scores||[0.9,0.7,0.85,0.6,0.8], body.tournamentSize||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/select', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/fitness' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeFitnessScore(body.traits||[0.8,0.7,0.9], body.weights||[1,2,1], body.environment||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/fitness', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
