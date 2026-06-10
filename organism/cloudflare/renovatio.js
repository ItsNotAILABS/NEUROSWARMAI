/**
 * RENOVATIO — AGI Mini Brain 063: Renovatio et Instauratio
 *
 * Dedicated Cloudflare Worker — Server AIS-063
 * Role: Renewal Engine
 *
 * This worker implements Renewal Engine capabilities using PHI golden-ratio
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
 *   POST /renew              — Schedule renewal with FIB cycle intervals
 *   POST /update             — Score update priority using PHI freshness decay
 *   POST /patch              — Calculate patch priority using FIB severity weights
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-063';
const AIS_NAME  = 'RENOVATIO';
const AIS_LATIN = 'Renovatio et Instauratio';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scheduleRenewal(resourceId, age, cycleBase) {
  const fibCycle = FIB[Math.min(cycleBase, FIB.length - 1)];
  const phiAge = age * PHI;
  const nextCycle = fibCycle * Math.ceil(phiAge / (fibCycle || 1));
  const urgency = phiAge / (fibCycle || 1);
  return { resourceId, age, cycleBase, fibCycle, phiAge, nextCycle, urgency, due: urgency >= 1 };
}

function scoreUpdatePriority(version, staleDays, importance) {
  const phiDecay = Math.pow(PHI_INV, staleDays / 30);
  const fibImportance = FIB[Math.min(importance, FIB.length - 1)];
  const priority = (1 - phiDecay) * fibImportance * importance;
  return { version, staleDays, phiDecay, fibImportance, priority, urgent: priority > FIB[5] };
}

function calculatePatchPriority(patchId, severity, affectedSystems) {
  const fibSeverity = FIB[Math.min(severity, FIB.length - 1)];
  const phiAffected = affectedSystems * PHI;
  const priority = fibSeverity * phiAffected;
  return { patchId, severity, affectedSystems, fibSeverity, phiAffected, priority, critical: severity >= 8 };
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

  if (path === '/renew' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scheduleRenewal(body.resourceId||"R1", body.age||30, body.cycleBase||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/renew', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/update' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreUpdatePriority(body.version||"1.0.0", body.staleDays||7, body.importance||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/update', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/patch' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculatePatchPriority(body.patchId||"P1", body.severity||5, body.affectedSystems||10);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/patch', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
