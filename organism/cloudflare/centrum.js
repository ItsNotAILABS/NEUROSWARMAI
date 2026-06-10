/**
 * CENTRUM — AGI Mini Brain 068: Centrum et Medulla
 *
 * Dedicated Cloudflare Worker — Server AIS-068
 * Role: Core/Center Engine
 *
 * This worker implements Core/Center Engine capabilities using PHI golden-ratio
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
 *   POST /center             — Find center of mass using PHI-weighted coordinates
 *   POST /focus              — Score focus strength using FIB attention weights
 *   POST /anchor             — Calculate anchor stability with PHI-FIB coupling
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-068';
const AIS_NAME  = 'CENTRUM';
const AIS_LATIN = 'Centrum et Medulla';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function findCenterOfMass(coords, masses) {
  const totalMass = masses.reduce((a, m) => a + m, 0);
  const phiMass = totalMass * PHI;
  const centerX = coords.reduce((a, c, i) => a + c * (masses[i] || 1), 0) / (totalMass || 1);
  const fibStability = FIB[Math.min(coords.length, FIB.length - 1)];
  return { coordCount: coords.length, totalMass, phiMass, centerX, fibStability, stability: fibStability * PHI_INV };
}

function scoreFocusStrength(targets, attention, priority) {
  const fibPriority = FIB[Math.min(priority, FIB.length - 1)];
  const phiAttention = attention * PHI;
  const focus = (phiAttention / (targets || 1)) * fibPriority;
  const concentration = focus / PHI;
  return { targets, attention, priority, fibPriority, phiAttention, focus, concentration, sharp: concentration > 1 };
}

function calculateAnchorStability(load, anchorPoints, tension) {
  const fibAnchor = FIB[Math.min(anchorPoints, FIB.length - 1)];
  const phiTension = tension * PHI;
  const loadPerAnchor = load / (anchorPoints || 1);
  const stability = (fibAnchor * phiTension) / (loadPerAnchor || 1);
  return { load, anchorPoints, tension, fibAnchor, phiTension, loadPerAnchor, stability, secure: stability > PHI };
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

  if (path === '/center' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = findCenterOfMass(body.coords||[0,10,20,30], body.masses||[1,2,3,4]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/center', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/focus' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreFocusStrength(body.targets||3, body.attention||0.9, body.priority||4);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/focus', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/anchor' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateAnchorStability(body.load||1000, body.anchorPoints||4, body.tension||500);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/anchor', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
