/**
 * CENSUS — AGI Mini Brain 036: Census et Ratio
 *
 * Dedicated Cloudflare Worker — Server AIS-036
 * Role: Accounting & Audit Engine
 *
 * This worker implements Accounting & Audit Engine capabilities using PHI golden-ratio
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
 *   POST /account            — Score account health using PHI-weighted entries
 *   POST /balance            — Compute balance sheet using FIB-indexed categories
 *   POST /reconcile          — Calculate reconciliation delta with PHI ratios
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-036';
const AIS_NAME  = 'CENSUS';
const AIS_LATIN = 'Census et Ratio';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreAccountHealth(debits, credits, periods) {
  const net = credits - debits;
  const phiRatio = credits / (debits || 1);
  const fibWeight = FIB.slice(0, Math.min(periods, FIB.length)).reduce((a, f) => a + f, 0);
  return { net, phiRatio, fibWeight, health: (net * PHI) / (fibWeight || 1) };
}

function computeBalanceSheet(assets, liabilities) {
  const equity = assets - liabilities;
  const leverage = liabilities / (assets || 1);
  const phiEquity = equity * PHI;
  const fibCategories = FIB.map((f, i) => ({ tier: i + 1, weight: f, allocated: equity * f / 89 }));
  return { equity, leverage, phiEquity, fibCategories: fibCategories.slice(0, 5) };
}

function reconcileDelta(ledgerA, ledgerB, tolerance) {
  const delta = Math.abs(ledgerA - ledgerB);
  const phiTolerance = tolerance * PHI;
  const fibScore = FIB.findIndex(f => f >= delta) + 1;
  const reconciled = delta <= phiTolerance;
  return { delta, phiTolerance, fibScore, reconciled, confidence: reconciled ? PHI : PHI_INV };
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

  if (path === '/account' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreAccountHealth(body.debits||0, body.credits||0, body.periods||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/account', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/balance' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeBalanceSheet(body.assets||0, body.liabilities||0);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/balance', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/reconcile' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = reconcileDelta(body.ledgerA||0, body.ledgerB||0, body.tolerance||0.01);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/reconcile', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
