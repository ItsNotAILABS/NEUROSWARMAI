/**
 * OPUS — AGI Mini Brain 045: Opus et Labor
 *
 * Dedicated Cloudflare Worker — Server AIS-045
 * Role: Work & Output Engine
 *
 * This worker implements Work & Output Engine capabilities using PHI golden-ratio
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
 *   POST /task               — Score task complexity with PHI weighting
 *   POST /deliver            — Calculate delivery quality using FIB milestones
 *   POST /assess             — Assess productivity using PHI and FIB ratios
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-045';
const AIS_NAME  = 'OPUS';
const AIS_LATIN = 'Opus et Labor';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreTaskComplexity(subtasks, dependencies, depth) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiComplexity = (subtasks + dependencies) * PHI;
  const score = phiComplexity * fibDepth;
  return { subtasks, dependencies, depth, fibDepth, phiComplexity, score, tier: Math.ceil(score / 10) };
}

function calculateDeliveryQuality(completed, total, onTime) {
  const ratio = completed / (total || 1);
  const phiRatio = ratio * PHI;
  const fibMilestones = FIB.filter(f => f <= total).length;
  const quality = phiRatio * (onTime ? PHI : PHI_INV) * fibMilestones;
  return { completed, total, ratio, phiRatio, fibMilestones, quality, grade: quality > PHI ? 'A' : quality > 1 ? 'B' : 'C' };
}

function assessProductivity(hoursWorked, output, efficiency) {
  const phiOutput = output * PHI;
  const fibHours = FIB[Math.min(Math.floor(hoursWorked / 8), FIB.length - 1)];
  const productivity = (phiOutput * efficiency) / (hoursWorked || 1);
  return { hoursWorked, output, efficiency, phiOutput, fibHours, productivity, score: productivity * fibHours };
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

  if (path === '/task' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreTaskComplexity(body.subtasks||5, body.dependencies||3, body.depth||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/task', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/deliver' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateDeliveryQuality(body.completed||8, body.total||10, body.onTime||true);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/deliver', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/assess' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = assessProductivity(body.hoursWorked||40, body.output||100, body.efficiency||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/assess', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
