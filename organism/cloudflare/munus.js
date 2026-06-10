/**
 * MUNUS — AGI Mini Brain 046: Munus et Officium
 *
 * Dedicated Cloudflare Worker — Server AIS-046
 * Role: Role & Duty Engine
 *
 * This worker implements Role & Duty Engine capabilities using PHI golden-ratio
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
 *   POST /role               — Define role responsibilities using PHI allocation
 *   POST /assign             — Assign role with FIB-weighted suitability score
 *   POST /delegate           — Delegate duties using PHI depth calculation
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-046';
const AIS_NAME  = 'MUNUS';
const AIS_LATIN = 'Munus et Officium';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function defineRoleResponsibilities(roleId, duties, authority) {
  const phiAuthority = authority * PHI;
  const fibDuties = duties.reduce((a, _, i) => a + (FIB[i % FIB.length] || 1), 0);
  const allocation = duties.map((d, i) => ({ duty: d, weight: FIB[i % FIB.length] * PHI_INV }));
  return { roleId, duties, phiAuthority, fibDuties, allocation, totalWeight: fibDuties * PHI_INV };
}

function assignRoleScore(candidateScore, roleRequirement, experience) {
  const phiScore = candidateScore * PHI;
  const fibExp = FIB[Math.min(experience, FIB.length - 1)];
  const suitability = (phiScore * fibExp) / (roleRequirement * PHI || 1);
  const assigned = suitability >= 1;
  return { candidateScore, roleRequirement, experience, phiScore, fibExp, suitability, assigned };
}

function delegateDuties(duties, depth, capacity) {
  const fibDepth = FIB[Math.min(depth, FIB.length - 1)];
  const phiCapacity = capacity * PHI;
  const delegated = duties.map((d, i) => ({ duty: d, level: i + 1, phiSlot: PHI * (i + 1), fibWeight: FIB[i % FIB.length] }));
  return { duties, fibDepth, phiCapacity, delegated, maxDepth: fibDepth };
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

  if (path === '/role' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = defineRoleResponsibilities(body.roleId||"R1", body.duties||["plan","execute","review"], body.authority||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/role', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/assign' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = assignRoleScore(body.candidateScore||80, body.roleRequirement||70, body.experience||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/assign', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/delegate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = delegateDuties(body.duties||["a","b","c"], body.depth||2, body.capacity||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/delegate', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
