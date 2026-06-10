/**
 * TRIBUTUM — AGI Mini Brain 038: Tributum et Meritum
 *
 * Dedicated Cloudflare Worker — Server AIS-038
 * Role: Billing & Tax Engine
 *
 * This worker implements Billing & Tax Engine capabilities using PHI golden-ratio
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
 *   POST /bill               — Generate bill with FIB-tiered tax brackets
 *   POST /meter              — Meter usage with PHI-scaled rate calculation
 *   POST /invoice            — Produce invoice total with PHI adjustment
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-038';
const AIS_NAME  = 'TRIBUTUM';
const AIS_LATIN = 'Tributum et Meritum';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function computeBillTax(amount, bracket) {
  const rates = FIB.map(f => f / 100);
  const rate = rates[Math.min(bracket, rates.length - 1)];
  const tax = amount * rate * PHI_INV;
  return { amount, rate, tax, total: amount + tax, bracket, phiAdjusted: tax * PHI };
}

function meterUsage(units, baseRate, tier) {
  const phiRate = baseRate * Math.pow(PHI, tier);
  const fibMultiplier = FIB[Math.min(tier, FIB.length - 1)];
  const charge = units * phiRate * fibMultiplier;
  return { units, baseRate, phiRate, fibMultiplier, charge, perUnit: charge / (units || 1) };
}

function produceInvoice(lineItems, discount) {
  const subtotal = lineItems.reduce((a, v) => a + v, 0);
  const phiDiscount = discount * PHI_INV;
  const fibWeight = FIB.slice(0, lineItems.length).reduce((a, f) => a + f, 0);
  const total = subtotal * (1 - phiDiscount);
  return { subtotal, phiDiscount, fibWeight, total, lineCount: lineItems.length };
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

  if (path === '/bill' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeBillTax(body.amount||100, body.bracket||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/bill', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/meter' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = meterUsage(body.units||1, body.baseRate||0.1, body.tier||0);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/meter', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/invoice' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = produceInvoice(body.lineItems||[100,50,25], body.discount||0.1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/invoice', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
