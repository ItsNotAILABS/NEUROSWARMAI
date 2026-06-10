/**
 * COMMERCIUM — AGI Mini Brain 035: Commercium et Negotium
 *
 * Dedicated Cloudflare Worker — Server AIS-035
 * Role: Commerce Engine
 *
 * This worker implements Commerce Engine capabilities using PHI golden-ratio
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
 *   POST /trade              — Execute trade orders using PHI-weighted volume scoring
 *   POST /market             — Compute market price via golden-ratio adjustment
 *   POST /value              — Score asset value using FIB depth weights
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-035';
const AIS_NAME  = 'COMMERCIUM';
const AIS_LATIN = 'Commercium et Negotium';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function computeTradeVolume(qty, price) {
  const phiAdjusted = qty * PHI * price;
  const fibWeight = FIB.reduce((a, f, i) => a + f * (i + 1), 0);
  return { volume: phiAdjusted, weight: fibWeight, score: phiAdjusted / fibWeight };
}

function computeMarketPrice(basePrice, demand, supply) {
  const ratio = demand / (supply || 1);
  const phiPressure = ratio > 1 ? ratio * PHI : ratio * PHI_INV;
  const fibIndex = FIB[Math.min(Math.floor(ratio * 3), FIB.length - 1)];
  return { price: basePrice * phiPressure, pressure: phiPressure, fibIndex };
}

function scoreAssetValue(cost, age, liquidity) {
  const decay = Math.pow(PHI_INV, age);
  const liqScore = liquidity * PHI;
  const fibDepth = FIB.slice(0, 5).reduce((a, f) => a + f * decay, 0);
  return { value: cost * decay + liqScore, decay, fibDepth, score: (cost * decay * liqScore) / (fibDepth || 1) };
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

  if (path === '/trade' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeTradeVolume(body.qty||1, body.price||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/trade', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/market' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeMarketPrice(body.basePrice||100, body.demand||1, body.supply||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/market', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/value' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreAssetValue(body.cost||100, body.age||1, body.liquidity||0.5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/value', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
