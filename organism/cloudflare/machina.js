/**
 * MACHINA — AGI Mini Brain 050: Machina et Apparatus
 *
 * Dedicated Cloudflare Worker — Server AIS-050
 * Role: Machine & Systems Engine
 *
 * This worker implements Machine & Systems Engine capabilities using PHI golden-ratio
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
 *   POST /system             — Score system health using FIB component weights
 *   POST /provision          — Calculate provisioning capacity with PHI scaling
 *   POST /orchestrate        — Orchestrate workloads using PHI-balanced distribution
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-050';
const AIS_NAME  = 'MACHINA';
const AIS_LATIN = 'Machina et Apparatus';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreSystemHealth(components, statuses, criticality) {
  const fibCriticality = FIB[Math.min(criticality, FIB.length - 1)];
  const healthyCount = statuses.filter(Boolean).length;
  const ratio = healthyCount / (components || 1);
  const phiHealth = ratio * PHI * fibCriticality;
  return { components, healthyCount, ratio, phiHealth, fibCriticality, healthy: ratio > PHI_INV };
}

function calculateProvisionCapacity(demand, nodes, redundancy) {
  const phiDemand = demand * PHI;
  const fibNodes = FIB[Math.min(nodes, FIB.length - 1)];
  const capacity = (nodes * fibNodes * redundancy) / (phiDemand || 1);
  const headroom = capacity - 1;
  return { demand, nodes, redundancy, phiDemand, fibNodes, capacity, headroom, sufficient: capacity >= 1 };
}

function orchestrateWorkloads(jobs, workers, priority) {
  const fibPriority = FIB[Math.min(priority, FIB.length - 1)];
  const phiLoad = (jobs / (workers || 1)) * PHI;
  const distribution = Array.from({ length: Math.min(workers, 10) }, (_, i) => ({
    worker: i, load: phiLoad / (FIB[i % FIB.length] || 1)
  }));
  return { jobs, workers, phiLoad, fibPriority, distribution, balanced: phiLoad < PHI };
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

  if (path === '/system' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreSystemHealth(body.components||5, body.statuses||[true,true,false,true,true], body.criticality||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/system', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/provision' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateProvisionCapacity(body.demand||100, body.nodes||5, body.redundancy||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/provision', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/orchestrate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = orchestrateWorkloads(body.jobs||100, body.workers||4, body.priority||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/orchestrate', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
