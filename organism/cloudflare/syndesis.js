/**
 * SYNDESIS — AGI Mini Brain 059: Syndesis et Connexio
 *
 * Dedicated Cloudflare Worker — Server AIS-059
 * Role: Binding & Linking Engine
 *
 * This worker implements Binding & Linking Engine capabilities using PHI golden-ratio
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
 *   POST /bind               — Compute bind strength using PHI coupling factor
 *   POST /link               — Score link quality with FIB hop-strength weights
 *   POST /federate           — Calculate federation index using PHI and FIB
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-059';
const AIS_NAME  = 'SYNDESIS';
const AIS_LATIN = 'Syndesis et Connexio';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function computeBindStrength(nodeA, nodeB, affinity) {
  const phiAffinity = affinity * PHI;
  const fibStrength = FIB[Math.min(Math.floor(affinity * 10), FIB.length - 1)];
  const strength = phiAffinity * fibStrength;
  return { nodeA, nodeB, affinity, phiAffinity, fibStrength, strength, stable: strength > PHI };
}

function scoreLinkQuality(hops, latency, bandwidth) {
  const fibHops = FIB[Math.min(hops, FIB.length - 1)];
  const phiBandwidth = bandwidth * PHI;
  const quality = phiBandwidth / (latency * fibHops || 1);
  return { hops, latency, bandwidth, fibHops, phiBandwidth, quality, good: quality > PHI };
}

function calculateFederationIndex(nodes, connections, trust) {
  const phiTrust = trust * PHI;
  const fibNodes = FIB[Math.min(nodes, FIB.length - 1)];
  const density = connections / (nodes * (nodes - 1) || 1);
  const index = density * phiTrust * fibNodes;
  return { nodes, connections, trust, phiTrust, fibNodes, density, index, federated: index > 1 };
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

  if (path === '/bind' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = computeBindStrength(body.nodeA||"N1", body.nodeB||"N2", body.affinity||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/bind', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/link' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreLinkQuality(body.hops||3, body.latency||20, body.bandwidth||1000);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/link', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/federate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateFederationIndex(body.nodes||10, body.connections||25, body.trust||0.9);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/federate', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
