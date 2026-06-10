/**
 * PECUNIA — AGI Mini Brain 037: Pecunia et Opes
 *
 * Dedicated Cloudflare Worker — Server AIS-037
 * Role: Wealth & Ledger Engine
 *
 * This worker implements Wealth & Ledger Engine capabilities using PHI golden-ratio
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
 *   POST /ledger             — Record ledger entry with FIB-indexed priority
 *   POST /wealth             — Compute compound wealth using PHI growth
 *   POST /transfer           — Process transfer with PHI-weighted fee scoring
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-037';
const AIS_NAME  = 'PECUNIA';
const AIS_LATIN = 'Pecunia et Opes';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function recordLedgerEntry(amount, category, priority) {
  const fibPriority = FIB[Math.min(priority, FIB.length - 1)];
  const phiAmount = amount * PHI;
  const index = fibPriority * phiAmount;
  return { amount, phiAmount, category, fibPriority, index, ts: Date.now() };
}

function computeCompoundWealth(principal, rate, years) {
  const phiRate = rate * PHI;
  const compounded = principal * Math.pow(1 + phiRate, years);
  const fibGrowth = FIB.slice(0, Math.min(years, FIB.length)).map(f => principal * (1 + rate * f / 10));
  return { principal, compounded, phiRate, fibGrowth, multiplier: compounded / (principal || 1) };
}

function processTransfer(amount, source, destination) {
  const fee = amount * PHI_INV * 0.01;
  const fibScore = FIB.reduce((a, f) => a + (amount > f * 100 ? 1 : 0), 0);
  const net = amount - fee;
  return { amount, fee, net, source, destination, fibScore, approved: fibScore > 3 };
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

  if (path === '/ledger' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = recordLedgerEntry(body.amount||0, body.category||"general", body.priority||0);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/ledger', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/wealth' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeCompoundWealth(body.principal||1000, body.rate||0.05, body.years||10);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/wealth', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/transfer' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = processTransfer(body.amount||0, body.source||"A", body.destination||"B");
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/transfer', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
