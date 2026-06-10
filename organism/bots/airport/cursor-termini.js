/**
 * CURSOR TERMINI — Organism Airport Bot II: Terminal Navigator
 * (Latin: "Runner of the Terminals")
 *
 * Cloudflare Worker — BOT-AIR-002
 * Role: Given an airport code and terminal, returns amenities, lounges,
 *       walking times between gates, dining, and transit options.
 *       Seeded with a curated dataset for the world's busiest airports.
 *
 * Routes:
 *   GET /navigate?airport=LAX&terminal=B      — Full terminal guide
 *   GET /airports                             — List all supported airports
 *   GET /lounges?airport=LAX                  — Lounges at an airport
 *   GET /walk?from=LAX-B&to=LAX-D             — Estimated walking time
 *   GET /status                               — Worker self-health check
 *   GET /metrics                              — Beat count + query metrics
 *
 * Token gate: SCB (SCAFFOLD) tier or higher required.
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-AIR-002';
const BOT_NAME = 'CURSOR TERMINI';
const BOT_LATIN= 'Cursor Terminorum';
const VERSION  = '1.0.0';

let beatCount  = 0;
let queryCount = 0;

/* ─── Airport knowledge base ────────────────────────────────────────────── */

const AIRPORTS = {
  LAX: {
    name: 'Los Angeles International',
    city: 'Los Angeles, CA',
    timezone: 'America/Los_Angeles',
    terminals: {
      '1':  { name: 'Terminal 1', airlines: ['Southwest'], gates: 'A1–A30', dining: ['In-N-Out Burger', 'Starbucks'], shops: ['Hudson News'], lounges: [] },
      '2':  { name: 'Terminal 2', airlines: ['Delta'], gates: 'B1–B25', dining: ['California Pizza Kitchen', 'Peet\'s Coffee'], shops: ['InMotion'], lounges: ['Delta Sky Club'] },
      '3':  { name: 'Terminal 3', airlines: ['Delta'], gates: 'B26–B50', dining: ['Urth Caffé', 'El Torito'], shops: ['Tumi'], lounges: ['Delta Sky Club T3'] },
      'B':  { name: 'Terminal B (TBIT)', airlines: ['International Carriers'], gates: 'B1–B115', dining: ['Border Grill', 'Rock & Brews', 'Gladstone\'s'], shops: ['Duty Free Americas', 'InMotion'], lounges: ['American Admirals Club', 'United Club', 'Air France Lounge'] },
      '4':  { name: 'Terminal 4', airlines: ['American Airlines'], gates: 'G1–G40', dining: ['Burger King', 'Lemonade', 'Hangar Bar'], shops: ['InMotion'], lounges: ['Admirals Club T4'] },
      '5':  { name: 'Terminal 5', airlines: ['Delta', 'Alaska'], gates: 'C1–C20', dining: ['Gladstones', 'Starbucks'], shops: [], lounges: [] },
      '6':  { name: 'Terminal 6', airlines: ['United', 'Alaska'], gates: 'F1–F27', dining: ['Cibo', 'Daily Grill'], shops: [], lounges: [] },
      '7':  { name: 'Terminal 7', airlines: ['United'], gates: 'G1–G22', dining: ['Bar Symon', 'CPK'], shops: ['Hudson'], lounges: ['United Club T7'] },
      '8':  { name: 'Terminal 8', airlines: ['United', 'American'], gates: 'H1–H22', dining: ['Encounter', 'Starbucks'], shops: [], lounges: ['United Club T8'] },
    },
    transit: { flyaway: 'LAX FlyAway Bus to Union Station (≈35 min)', metro: 'Metro C Line (near 2026 completion)', rideshare: 'LAX-it pickup at T1 lower level' },
  },
  JFK: {
    name: 'John F. Kennedy International',
    city: 'New York, NY',
    timezone: 'America/New_York',
    terminals: {
      '1':  { name: 'Terminal 1', airlines: ['Air France', 'Lufthansa', 'JAL', 'Korean Air'], gates: 'T1', dining: ['Au Bon Pain', 'Auntie Anne\'s'], shops: ['CNBC News', 'InMotion'], lounges: ['Lufthansa Senator Lounge', 'Air France Lounge'] },
      '4':  { name: 'Terminal 4', airlines: ['Delta', 'Emirates', 'Virgin Atlantic'], gates: 'T4-A/B/C', dining: ['Deep Blue Sushi', 'Familia Mexican Kitchen', 'Shake Shack'], shops: ['Michael Kors', 'Brooks Brothers'], lounges: ['Delta Sky Club T4', 'Emirates Lounge'] },
      '5':  { name: 'Terminal 5 (JetBlue)', airlines: ['JetBlue'], gates: 'T5', dining: ['Deep Blue Sushi', 'Blue Smoke'], shops: ['InMotion'], lounges: ['Mint T5'] },
      '8':  { name: 'Terminal 8', airlines: ['American', 'British Airways', 'Iberia', 'Finnair'], gates: 'T8', dining: ['Balducci\'s', 'Cosi', 'Starbucks'], shops: ['TUMI'], lounges: ['Admirals Club T8', 'British Airways Galleries Club'] },
    },
    transit: { airtrain: 'AirTrain to Jamaica/Howard Beach LIRR (≈30 min to Penn Station)', taxi: 'Flat rate $70 to Manhattan', rideshare: 'Rideshare Zone at each terminal lower level' },
  },
  ORD: {
    name: "Chicago O'Hare International",
    city: 'Chicago, IL',
    timezone: 'America/Chicago',
    terminals: {
      '1':  { name: 'Terminal 1 (United)', airlines: ['United', 'Lufthansa', 'Air Canada'], gates: 'B/C Concourses', dining: ['Big Bowl', 'Wicker Park Seafood & Sushi'], shops: ['Brighton'], lounges: ['United Club T1'] },
      '2':  { name: 'Terminal 2 (United)', airlines: ['United'], gates: 'E/F Concourses', dining: ['Tortas Frontera', 'Goose Island Brewpub'], shops: ['Hudson'], lounges: [] },
      '3':  { name: 'Terminal 3 (American)', airlines: ['American', 'British Airways', 'Iberia'], gates: 'G/H/K/L Concourses', dining: ['Rick Bayless Tortas Frontera', 'Bar Siena'], shops: ['Victoria\'s Secret'], lounges: ['Admirals Club T3', 'Flagship Lounge'] },
    },
    transit: { cta: "CTA Blue Line O'Hare branch direct to downtown ($5 fare, ≈45 min)", hotel_shuttle: 'Free shuttles to airport hotels', rideshare: 'Rideshare lot L (follow signs)' },
  },
  LHR: {
    name: 'London Heathrow',
    city: 'London, UK',
    timezone: 'Europe/London',
    terminals: {
      '2':  { name: 'Terminal 2 (Star Alliance)', airlines: ['United', 'Lufthansa', 'Air Canada', 'Swiss'], gates: 'T2A/T2B', dining: ['Giraffe', 'Pret A Manger'], shops: ['Harrods', 'WHSmith'], lounges: ['United Club T2', 'Lufthansa Business Lounge'] },
      '3':  { name: 'Terminal 3 (SkyTeam)', airlines: ['Delta', 'Air France', 'Virgin Atlantic'], gates: 'T3', dining: ['Gordon Ramsay Plane Food', 'Wagamama'], shops: ['Harrods', 'Mulberry'], lounges: ['Delta Sky Club T3', 'Air France Lounge'] },
      '4':  { name: 'Terminal 4', airlines: ['Malaysia Airlines', 'Garuda', 'Korean Air'], gates: 'T4', dining: ['Café Nero', 'Yo! Sushi'], shops: ['Boots', 'WHSmith'], lounges: ['Malaysian Airline Golden Lounge'] },
      '5':  { name: 'Terminal 5 (British Airways)', airlines: ['British Airways', 'Iberia', 'Finnair'], gates: 'T5A/T5B/T5C', dining: ['Heston Blumenthal The Perfectionist Café', 'Gordon Ramsay'], shops: ['Harrods', 'Fortnum & Mason', 'Burberry'], lounges: ['BA Galleries First', 'BA Galleries Club', 'Concorde Room'] },
    },
    transit: { heathrow_express: 'Heathrow Express to Paddington (15 min, £25)', elizabeth_line: 'Elizabeth line to central London (≈35 min, £12.80)', taxi: 'Licensed black cab ≈£60–85 to central London' },
  },
  DXB: {
    name: 'Dubai International',
    city: 'Dubai, UAE',
    timezone: 'Asia/Dubai',
    terminals: {
      '1':  { name: 'Terminal 1', airlines: ['Flydubai', 'Qantas', 'Cathay Pacific', 'British Airways'], gates: 'T1 Concourse D', dining: ['Arabian Tea House', 'Shakespeare and Co'], shops: ['Duty Free Electronics', 'Cartier'], lounges: ['Marhaba Lounge T1'] },
      '2':  { name: 'Terminal 2 (Low Cost)', airlines: ['flydubai domestic', 'charter ops'], gates: 'T2', dining: ['Costa Coffee', 'Subway'], shops: ['World Duty Free'], lounges: [] },
      '3':  { name: 'Terminal 3 (Emirates)', airlines: ['Emirates'], gates: 'Concourses A/B/C', dining: ['Calabar', 'More Café', 'Jones The Grocer'], shops: ['Duty Free 5,000+ products', 'Rolex', 'Apple'], lounges: ['Emirates First Class Lounge (multiple)', 'Emirates Business Lounge', 'Emirates Lounge'] },
    },
    transit: { dubai_metro: 'Dubai Metro Red Line — DXB T1/T3 station on Concourse B (≈35 min to Burj Khalifa)', taxi: 'Dubai Taxi ≈AED 50–80 to city center', bus: 'RTA Bus Route X55 to Union Metro' },
  },
};

// Walking time matrix (minutes) between terminal-pairs at the same airport
const WALK_TIMES = {
  'LAX-1:LAX-2':   8, 'LAX-2:LAX-3':  3, 'LAX-3:LAX-B': 12, 'LAX-B:LAX-4': 10,
  'LAX-4:LAX-5':   5, 'LAX-5:LAX-6':  4, 'LAX-6:LAX-7':  3, 'LAX-7:LAX-8':  4,
  'JFK-1:JFK-4':  20, 'JFK-4:JFK-5':  7, 'JFK-5:JFK-8': 15,
  'ORD-1:ORD-2':   5, 'ORD-2:ORD-3': 10,
  'LHR-2:LHR-3':  10, 'LHR-3:LHR-4': 15, 'LHR-4:LHR-5': 20, 'LHR-2:LHR-5': 35,
  'DXB-1:DXB-3':  10, 'DXB-1:DXB-2':  5, 'DXB-2:DXB-3':  8,
};

function getWalkTime(from, to) {
  const key1 = `${from}:${to}`;
  const key2 = `${to}:${from}`;
  return WALK_TIMES[key1] ?? WALK_TIMES[key2] ?? null;
}

/* ─── Route handlers ────────────────────────────────────────────────────── */

function handleNavigate(airport, terminal) {
  const airportData = AIRPORTS[airport.toUpperCase()];
  if (!airportData) return { error: `Airport ${airport} not found. Supported: ${Object.keys(AIRPORTS).join(', ')}` };

  const termData = airportData.terminals[terminal];
  if (!termData)  return { error: `Terminal ${terminal} not found at ${airport}. Terminals: ${Object.keys(airportData.terminals).join(', ')}` };

  return {
    airport:   airport.toUpperCase(),
    name:      airportData.name,
    city:      airportData.city,
    timezone:  airportData.timezone,
    terminal:  terminal,
    ...termData,
    transit:   airportData.transit,
    phi:       PHI,
    source:    'organism-airport-db',
  };
}

function handleLounges(airport) {
  const airportData = AIRPORTS[airport.toUpperCase()];
  if (!airportData) return { error: `Airport ${airport} not found` };

  const lounges = [];
  for (const [term, data] of Object.entries(airportData.terminals)) {
    for (const lounge of (data.lounges || [])) {
      lounges.push({ terminal: term, lounge });
    }
  }
  return { airport: airport.toUpperCase(), name: airportData.name, lounges, count: lounges.length };
}

function handleWalk(from, to) {
  const minutes = getWalkTime(from, to);
  if (minutes === null) {
    return { error: `No walk time data for ${from} → ${to}`, from, to, suggestion: 'Allow 15–30 minutes for inter-terminal transfers' };
  }
  const phiAdj = +(minutes * PHI_INV).toFixed(1);
  return { from, to, minutes, phi_adjusted: phiAdj, note: `φ-adjusted estimate: ${phiAdj} min (Medina Doctrine optimal path)` };
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
      status: 'alive', airports: Object.keys(AIRPORTS).length, beat: beatCount, queryCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, queryCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/airports' && request.method === 'GET') {
    const list = Object.entries(AIRPORTS).map(([code, a]) => ({
      code, name: a.name, city: a.city, terminals: Object.keys(a.terminals).length,
    }));
    return new Response(JSON.stringify({ botId: BOT_ID, airports: list, count: list.length }), { headers: cors });
  }

  if (path === '/navigate' && request.method === 'GET') {
    const airport  = url.searchParams.get('airport') || '';
    const terminal = url.searchParams.get('terminal') || '';
    const token    = url.searchParams.get('token') || '';

    if (!airport) return new Response(JSON.stringify({ error: 'airport param required', botId: BOT_ID }), { status: 400, headers: cors });

    const tokenResult = await verifyToken(token, env);
    if (!tokenResult.ok || !canAccess(tokenResult.tier, 'airport-termini')) {
      return new Response(JSON.stringify({ error: 'requires SCB token tier or higher', botId: BOT_ID }), { status: 403, headers: cors });
    }

    beatCount++;
    queryCount++;
    const result = handleNavigate(airport, terminal);
    return new Response(JSON.stringify({ botId: BOT_ID, ...result }), { headers: cors });
  }

  if (path === '/lounges' && request.method === 'GET') {
    const airport = url.searchParams.get('airport') || '';
    if (!airport) return new Response(JSON.stringify({ error: 'airport param required', botId: BOT_ID }), { status: 400, headers: cors });
    beatCount++;
    queryCount++;
    return new Response(JSON.stringify({ botId: BOT_ID, ...handleLounges(airport) }), { headers: cors });
  }

  if (path === '/walk' && request.method === 'GET') {
    const from = (url.searchParams.get('from') || '').toUpperCase();
    const to   = (url.searchParams.get('to')   || '').toUpperCase();
    if (!from || !to) return new Response(JSON.stringify({ error: 'from and to params required (e.g. LAX-2, JFK-4)', botId: BOT_ID }), { status: 400, headers: cors });
    beatCount++;
    queryCount++;
    return new Response(JSON.stringify({ botId: BOT_ID, ...handleWalk(from, to) }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
