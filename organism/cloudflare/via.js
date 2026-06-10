/**
 * VIA — AGI Mini Brain 053: Via et Cursus
 *
 * Dedicated Cloudflare Worker — Server AIS-053
 * Role: Data Pipeline Engine
 *
 * This worker implements Data Pipeline Engine capabilities using PHI golden-ratio
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
 *   POST /pipeline           — Calculate pipeline throughput with PHI ratios
 *   POST /route              — Optimize route scoring using FIB hop weights
 *   POST /stream             — Score stream health using PHI flow analysis
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-053';
const AIS_NAME  = 'VIA';
const AIS_LATIN = 'Via et Cursus';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function calculatePipelineThroughput(inputRate, stages, dropRate) {
  const phiRate = inputRate * PHI;
  const fibStages = FIB[Math.min(stages, FIB.length - 1)];
  const effectiveRate = phiRate * Math.pow(1 - dropRate, stages);
  const efficiency = effectiveRate / (phiRate || 1);
  return { inputRate, stages, dropRate, phiRate, fibStages, effectiveRate, efficiency };
}

function optimizeRouteScore(hops, latencies, bandwidth) {
  const fibHops = hops.map((h, i) => ({ hop: h, fibWeight: FIB[i % FIB.length], latency: latencies[i] || 1 }));
  const totalLatency = fibHops.reduce((a, h) => a + h.latency * h.fibWeight, 0);
  const phiBandwidth = bandwidth * PHI;
  const score = phiBandwidth / (totalLatency || 1);
  return { hopCount: hops.length, totalLatency, phiBandwidth, score, optimal: score > PHI };
}

function scoreStreamHealth(msgRate, errorRate, lag) {
  const phiMsgRate = msgRate * PHI;
  const fibLag = FIB[Math.min(Math.floor(lag / 100), FIB.length - 1)];
  const health = phiMsgRate * (1 - errorRate) / (fibLag || 1);
  return { msgRate, errorRate, lag, phiMsgRate, fibLag, health, healthy: health > PHI };
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

  if (path === '/pipeline' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculatePipelineThroughput(body.inputRate||1000, body.stages||3, body.dropRate||0.01);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/pipeline', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/route' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = optimizeRouteScore(body.hops||["A","B","C"], body.latencies||[10,20,15], body.bandwidth||1000);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/route', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/stream' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreStreamHealth(body.msgRate||500, body.errorRate||0.001, body.lag||50);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/stream', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
