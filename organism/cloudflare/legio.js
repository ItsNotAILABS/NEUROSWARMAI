/**
 * LEGIO — AGI Mini Brain 057: Legio et Exercitus
 *
 * Dedicated Cloudflare Worker — Server AIS-057
 * Role: Fleet Command Engine
 *
 * This worker implements Fleet Command Engine capabilities using PHI golden-ratio
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
 *   POST /fleet              — Score fleet readiness using PHI deployment ratios
 *   POST /marshal            — Marshal units using FIB priority sequencing
 *   POST /deploy             — Calculate deploy efficiency with PHI wave strategy
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-057';
const AIS_NAME  = 'LEGIO';
const AIS_LATIN = 'Legio et Exercitus';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreFleetReadiness(units, operational, reserve) {
  const phiReserve = reserve * PHI;
  const fibUnits = FIB[Math.min(units, FIB.length - 1)];
  const readiness = (operational / (units || 1)) * phiReserve * fibUnits;
  return { units, operational, reserve, phiReserve, fibUnits, readiness, ready: readiness > PHI };
}

function marshalUnits(units, priority, threat) {
  const fibThreat = FIB[Math.min(threat, FIB.length - 1)];
  const phiPriority = priority * PHI;
  const marshaled = Array.from({ length: Math.min(units, 10) }, (_, i) => ({
    unit: i + 1, fibRank: FIB[i % FIB.length], phiSlot: PHI * (i + 1), threat: fibThreat
  }));
  return { units, fibThreat, phiPriority, marshaled, waves: Math.ceil(units / (fibThreat || 1)) };
}

function calculateDeployWaveEfficiency(waves, unitsPerWave, interval) {
  const phiInterval = interval * PHI;
  const fibWaves = FIB[Math.min(waves, FIB.length - 1)];
  const totalTime = waves * phiInterval;
  const efficiency = (unitsPerWave * fibWaves) / (totalTime || 1);
  return { waves, unitsPerWave, interval, phiInterval, fibWaves, totalTime, efficiency };
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

  if (path === '/fleet' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreFleetReadiness(body.units||100, body.operational||85, body.reserve||15);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/fleet', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/marshal' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = marshalUnits(body.units||50, body.priority||3, body.threat||4);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/marshal', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/deploy' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateDeployWaveEfficiency(body.waves||5, body.unitsPerWave||20, body.interval||60);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/deploy', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
