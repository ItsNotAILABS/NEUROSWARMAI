/**
 * CENSUS TURBAE — Organism Airport Bot IV: Crowd / TSA Monitor
 * (Latin: "Census of the Crowd")
 *
 * Cloudflare Worker — BOT-AIR-004
 * Role: Fetches TSA checkpoint wait times and airport crowd levels
 *       to recommend the best time to arrive and which checkpoint to use.
 *       Uses the public TSA Wait Times API (no API key required).
 *
 * Routes:
 *   GET /wait?airport=LAX            — Current TSA wait times at airport
 *   GET /wait?airport=LAX&terminal=B — Wait time for specific terminal
 *   GET /best?airport=LAX            — Best checkpoint recommendation
 *   GET /airports                    — Supported airports
 *   GET /status                      — Worker self-health check
 *   GET /metrics                     — Beat count + query metrics
 *
 * Data source:
 *   TSA public data (no auth): https://www.tsawaittimes.com/api (community)
 *   Fallback: φ-weighted synthetic data for alpha mode
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-AIR-004';
const BOT_NAME = 'CENSUS TURBAE';
const BOT_LATIN= 'Census Turbae et Populi';
const VERSION  = '1.0.0';

let beatCount  = 0;
let queryCount = 0;

/* ─── Airport checkpoint reference data ────────────────────────────────── */

// Known TSA checkpoints by airport and terminal
const CHECKPOINTS = {
  LAX: [
    { id: 'LAX-T1-A',   terminal: '1', checkpoint: 'A', description: 'Terminal 1 South' },
    { id: 'LAX-T2-B',   terminal: '2', checkpoint: 'B', description: 'Terminal 2/3 Shared' },
    { id: 'LAX-TB-C',   terminal: 'B', checkpoint: 'C', description: 'TBIT Main' },
    { id: 'LAX-T4-G',   terminal: '4', checkpoint: 'G', description: 'Terminal 4 Upper' },
    { id: 'LAX-T7-H',   terminal: '7', checkpoint: 'H', description: 'Terminals 7/8 Shared' },
  ],
  JFK: [
    { id: 'JFK-T1',     terminal: '1', checkpoint: 'Main', description: 'Terminal 1 Security' },
    { id: 'JFK-T4',     terminal: '4', checkpoint: 'Main', description: 'Terminal 4 Security' },
    { id: 'JFK-T5',     terminal: '5', checkpoint: 'Main', description: 'JetBlue Security' },
    { id: 'JFK-T8',     terminal: '8', checkpoint: 'Main', description: 'Terminal 8 Security' },
  ],
  ORD: [
    { id: 'ORD-T1-B',   terminal: '1', checkpoint: 'B', description: 'Terminal 1 Rotunda' },
    { id: 'ORD-T2-E',   terminal: '2', checkpoint: 'E', description: 'Terminal 2 Main' },
    { id: 'ORD-T3-G',   terminal: '3', checkpoint: 'G', description: 'Terminal 3 Upper' },
    { id: 'ORD-T3-H',   terminal: '3', checkpoint: 'H', description: 'Terminal 3 Int\'l' },
  ],
  LHR: [
    { id: 'LHR-T2',     terminal: '2', checkpoint: 'Main', description: 'Terminal 2 Security' },
    { id: 'LHR-T3',     terminal: '3', checkpoint: 'Main', description: 'Terminal 3 Security' },
    { id: 'LHR-T4',     terminal: '4', checkpoint: 'Main', description: 'Terminal 4 Security' },
    { id: 'LHR-T5-A',   terminal: '5', checkpoint: 'A',    description: 'Terminal 5A Fast Track' },
    { id: 'LHR-T5-B',   terminal: '5', checkpoint: 'B',    description: 'Terminal 5B Security' },
  ],
  DFW: [
    { id: 'DFW-A',      terminal: 'A', checkpoint: 'Main', description: 'Terminal A' },
    { id: 'DFW-B',      terminal: 'B', checkpoint: 'Main', description: 'Terminal B' },
    { id: 'DFW-C',      terminal: 'C', checkpoint: 'Main', description: 'Terminal C' },
    { id: 'DFW-D',      terminal: 'D', checkpoint: 'Main', description: 'Terminal D Int\'l' },
    { id: 'DFW-E',      terminal: 'E', checkpoint: 'Main', description: 'Terminal E' },
  ],
};

/* ─── TSA wait data fetch ────────────────────────────────────────────────── */

async function fetchWaitTimes(airport, env) {
  // Try the community TSA API first; fall back to φ-synthetic data
  const airportCode = airport.toUpperCase();
  const checkpoints = CHECKPOINTS[airportCode];

  if (!checkpoints) {
    return { error: `Airport ${airportCode} not in database. Supported: ${Object.keys(CHECKPOINTS).join(', ')}` };
  }

  try {
    // Attempt to fetch from TSA open data endpoint
    const url = `https://www.tsawaittimes.com/api/airports/${airportCode}.json`;
    const res = await fetch(url, {
      headers: { 'User-Agent': `MERIDIANUS-CENSUS/${VERSION}`, 'Accept': 'application/json' },
      signal:  AbortSignal.timeout(4000),
    });

    if (res.ok) {
      const data = await res.json();
      if (data && Array.isArray(data.checkpoints)) {
        return {
          airport:     airportCode,
          checkpoints: data.checkpoints,
          source:      'tsa-api',
          ts:          Date.now(),
        };
      }
    }
  } catch {
    // Fallthrough to synthetic data
  }

  // φ-weighted synthetic data (alpha mode / API unavailable)
  const now      = new Date();
  const hour     = now.getUTCHours();
  // Peak hours: 6–9am, 4–7pm → higher wait times
  const isPeak   = (hour >= 6 && hour <= 9) || (hour >= 16 && hour <= 19);
  const baseWait = isPeak ? 25 : 10;

  const syntheticCheckpoints = checkpoints.map((cp, i) => {
    const wait = Math.round(baseWait * Math.pow(PHI_INV, i % 3) + Math.random() * 5);
    return {
      id:          cp.id,
      terminal:    cp.terminal,
      checkpoint:  cp.checkpoint,
      description: cp.description,
      wait_minutes: wait,
      tsa_pre:      Math.max(2, Math.round(wait * PHI_INV)),
      crowd_level:  wait > 20 ? 'high' : wait > 10 ? 'moderate' : 'low',
    };
  });

  return {
    airport:     airportCode,
    checkpoints: syntheticCheckpoints,
    source:      'phi-synthetic',
    peak:        isPeak,
    ts:          Date.now(),
  };
}

/* ─── Best checkpoint recommendation ───────────────────────────────────── */

function recommendBest(waitData, terminal) {
  let checkpoints = waitData.checkpoints || [];

  if (terminal) {
    const filtered = checkpoints.filter(cp => cp.terminal === terminal);
    if (filtered.length > 0) checkpoints = filtered;
  }

  if (!checkpoints.length) return { error: 'No checkpoints available' };

  const best    = checkpoints.reduce((a, b) => (a.wait_minutes ?? 99) < (b.wait_minutes ?? 99) ? a : b);
  const phiTime = +(best.wait_minutes * PHI_INV).toFixed(1);

  return {
    recommended:    best,
    alternatives:   checkpoints.filter(cp => cp.id !== best.id),
    phi_estimate:   phiTime,
    arrive_by:      `${phiTime} min before boarding to clear security at ${best.description}`,
  };
}

/* ─── Request handler ───────────────────────────────────────────────────── */

async function handleRequest(request, env) {
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-Bot-ID': BOT_ID,
    'X-Bot-Name': BOT_NAME,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, queryCount, airports: Object.keys(CHECKPOINTS).length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, queryCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/airports' && request.method === 'GET') {
    const list = Object.entries(CHECKPOINTS).map(([code, cps]) => ({
      code, checkpoints: cps.length,
    }));
    return new Response(JSON.stringify({ botId: BOT_ID, airports: list }), { headers: cors });
  }

  if (path === '/wait' && request.method === 'GET') {
    const airport  = (url.searchParams.get('airport') || '').toUpperCase();
    const terminal = url.searchParams.get('terminal') || '';
    if (!airport) return new Response(JSON.stringify({ error: 'airport param required', botId: BOT_ID }), { status: 400, headers: cors });

    beatCount++;
    queryCount++;
    const waitData = await fetchWaitTimes(airport, env);
    if (waitData.error) return new Response(JSON.stringify({ botId: BOT_ID, ...waitData }), { status: 404, headers: cors });

    const filtered = terminal
      ? { ...waitData, checkpoints: waitData.checkpoints.filter(cp => cp.terminal === terminal) }
      : waitData;

    return new Response(JSON.stringify({ botId: BOT_ID, ...filtered }), { headers: cors });
  }

  if (path === '/best' && request.method === 'GET') {
    const airport  = (url.searchParams.get('airport') || '').toUpperCase();
    const terminal = url.searchParams.get('terminal') || '';
    if (!airport) return new Response(JSON.stringify({ error: 'airport param required', botId: BOT_ID }), { status: 400, headers: cors });

    beatCount++;
    queryCount++;
    const waitData = await fetchWaitTimes(airport, env);
    if (waitData.error) return new Response(JSON.stringify({ botId: BOT_ID, ...waitData }), { status: 404, headers: cors });

    const best = recommendBest(waitData, terminal);
    return new Response(JSON.stringify({ botId: BOT_ID, airport, ...best, source: waitData.source }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
