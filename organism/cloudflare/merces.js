/**
 * MERCES — AGI Mini Brain 039: Merces et Pretium
 *
 * Dedicated Cloudflare Worker — Server AIS-039
 * Role: Rewards & Pricing Engine
 *
 * This worker implements Rewards & Pricing Engine capabilities using PHI golden-ratio
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
 *   POST /reward             — Calculate reward points using PHI multipliers
 *   POST /price              — Optimize price with PHI demand elasticity
 *   POST /settle             — Settle reward debt with FIB-weighted allocation
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-039';
const AIS_NAME  = 'MERCES';
const AIS_LATIN = 'Merces et Pretium';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function calculateRewardPoints(spend, tier, streak) {
  const phiMultiplier = Math.pow(PHI, tier);
  const fibStreak = FIB[Math.min(streak, FIB.length - 1)];
  const points = spend * phiMultiplier * fibStreak;
  return { spend, tier, streak, phiMultiplier, fibStreak, points: Math.round(points) };
}

function optimizePrice(cost, demand, elasticity) {
  const phiElastic = elasticity * PHI;
  const optimal = cost * PHI * (1 + demand * phiElastic);
  const fibBands = FIB.map(f => ({ band: f, price: cost * (1 + f * 0.1) }));
  return { cost, optimal, phiElastic, margin: optimal - cost, fibBands: fibBands.slice(0, 5) };
}

function settleRewardDebt(points, debts) {
  const total = debts.reduce((a, v) => a + v, 0);
  const fibWeightsRaw = FIB.slice(0, debts.length);
  const fibSum = fibWeightsRaw.reduce((a, f) => a + f, 0) || 1;
  const allocations = debts.map((d, i) => ({
    debt: d,
    allocated: points * (fibWeightsRaw[i] || PHI_INV) / fibSum,
    settled: d <= points * PHI_INV
  }));
  return { points, total, allocations, surplus: points - total };
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

  if (path === '/reward' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateRewardPoints(body.spend||100, body.tier||1, body.streak||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/reward', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/price' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = optimizePrice(body.cost||50, body.demand||1, body.elasticity||0.5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/price', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/settle' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = settleRewardDebt(body.points||1000, body.debts||[200,300,100]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/settle', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
