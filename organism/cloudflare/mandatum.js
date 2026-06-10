/**
 * MANDATUM — AGI Mini Brain 041: Mandatum et Imperata
 *
 * Dedicated Cloudflare Worker — Server AIS-041
 * Role: Command Authority Engine
 *
 * This worker implements Command Authority Engine capabilities using PHI golden-ratio
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
 *   POST /command            — Register command with PHI authority scoring
 *   POST /authorize          — Authorize action using PHI-weighted trust level
 *   POST /execute            — Execute command with FIB sequencing priority
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-041';
const AIS_NAME  = 'MANDATUM';
const AIS_LATIN = 'Mandatum et Imperata';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function registerCommand(cmdId, level, scope) {
  const phiAuth = Math.pow(PHI, level);
  const fibScope = FIB[Math.min(scope, FIB.length - 1)];
  const authority = phiAuth * fibScope;
  return { cmdId, level, scope, phiAuth, fibScope, authority };
}

function authorizeAction(actorId, trustLevel, required) {
  const phiTrust = trustLevel * PHI;
  const fibRequired = FIB[Math.min(required, FIB.length - 1)];
  const authorized = phiTrust >= fibRequired;
  const confidence = authorized ? phiTrust / fibRequired : 0;
  return { actorId, phiTrust, fibRequired, authorized, confidence };
}

function executeSequence(commands, priority) {
  const fibPriority = FIB[Math.min(priority, FIB.length - 1)];
  const phiWeight = priority * PHI;
  const ordered = commands.map((c, i) => ({ cmd: c, order: i * FIB[i % FIB.length], phiSlot: i * PHI }));
  return { commands, fibPriority, phiWeight, ordered, executionScore: fibPriority * phiWeight };
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

  if (path === '/command' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = registerCommand(body.cmdId||"CMD1", body.level||1, body.scope||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/command', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/authorize' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = authorizeAction(body.actorId||"A1", body.trustLevel||1, body.required||2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/authorize', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/execute' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = executeSequence(body.commands||["init","run","stop"], body.priority||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/execute', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
