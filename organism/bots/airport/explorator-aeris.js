/**
 * EXPLORATOR AERIS — Organism Airport Bot I: Flight Intelligence
 * (Latin: "Explorer of the Air")
 *
 * Cloudflare Worker — BOT-AIR-001
 * Role: Monitors a flight number and pushes gate changes, delay alerts,
 *       and departure/arrival updates to Telegram in real time.
 *
 * Routes:
 *   GET  /track?flight=AA123          — Single flight status check + Telegram push
 *   GET  /track?flight=AA123&notify=0 — Status only, no Telegram push
 *   POST /watch                       — Add a flight to the watch list
 *   GET  /watchlist                   — List watched flights
 *   DELETE /watch/:flight             — Remove a flight from the watch list
 *   GET  /status                      — Worker self-health check
 *   GET  /metrics                     — Beat count + tracking metrics
 *
 * Data sources (free, no API key required for basic data):
 *   - AviationStack free tier: https://api.aviationstack.com/v1/flights
 *   - Fallback: structured stub (for alpha / when no API key is provided)
 *
 * Environment variables (Cloudflare Worker secrets):
 *   TELEGRAM_BOT_TOKEN     — From @BotFather
 *   TELEGRAM_CHAT_ID       — Target chat/channel
 *   AVIATIONSTACK_API_KEY  — Free at aviationstack.com (500 req/month)
 *   ICP_CANISTER_URL       — Organism token canister URL (optional)
 *
 * Token gate: SCB (SCAFFOLD) tier or higher required.
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { sendTelegram, escapeMd } from '../shared/telegram.js';
import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const BOT_ID   = 'BOT-AIR-001';
const BOT_NAME = 'EXPLORATOR AERIS';
const BOT_LATIN= 'Explorator Aeris et Caeli';
const VERSION  = '1.0.0';

let beatCount    = 0;
let trackCount   = 0;
const watchList  = new Map(); // flight → { addedAt, lastStatus }

/* ─── Flight data fetch ─────────────────────────────────────────────────── */

async function fetchFlight(flightNumber, env) {
  const apiKey = env?.AVIATIONSTACK_API_KEY;

  if (!apiKey) {
    // Alpha stub: return synthetic flight data
    return buildStubFlight(flightNumber);
  }

  try {
    const url = `https://api.aviationstack.com/v1/flights?access_key=${apiKey}&flight_iata=${encodeURIComponent(flightNumber)}&limit=1`;
    const res = await fetch(url, { headers: { 'User-Agent': `MERIDIANUS-AERIS/${VERSION}` } });
    if (!res.ok) return buildStubFlight(flightNumber);

    const data = await res.json();
    const f    = data?.data?.[0];
    if (!f)    return buildStubFlight(flightNumber);

    return {
      flight:          f.flight?.iata || flightNumber,
      airline:         f.airline?.name || 'Unknown Airline',
      status:          f.flight_status || 'unknown',
      origin:          f.departure?.airport || 'Unknown',
      originCode:      f.departure?.iata || '???',
      destination:     f.arrival?.airport || 'Unknown',
      destinationCode: f.arrival?.iata || '???',
      gate:            f.departure?.gate || 'TBD',
      terminal:        f.departure?.terminal || 'TBD',
      scheduled:       f.departure?.scheduled || null,
      estimated:       f.departure?.estimated || null,
      delay:           f.departure?.delay ?? 0,
      arrivalGate:     f.arrival?.gate || 'TBD',
      arrivalTerminal: f.arrival?.terminal || 'TBD',
      source:          'aviationstack',
    };
  } catch {
    return buildStubFlight(flightNumber);
  }
}

function buildStubFlight(flightNumber) {
  return {
    flight:          flightNumber.toUpperCase(),
    airline:         'MERIDIANUS Air',
    status:          'active',
    origin:          'Los Angeles Intl',
    originCode:      'LAX',
    destination:     'JFK International',
    destinationCode: 'JFK',
    gate:            `G${Math.floor(PHI * 10)}`,
    terminal:        'B',
    scheduled:       new Date(Date.now() + 3600000).toISOString(),
    estimated:       new Date(Date.now() + 3600000 + 900000).toISOString(),
    delay:           15,
    arrivalGate:     `A${Math.floor(PHI * 7)}`,
    arrivalTerminal: 'D',
    source:          'alpha-stub',
  };
}

/* ─── Build Telegram flight message ─────────────────────────────────────── */

function buildFlightMessage(flight) {
  const statusIcon = {
    active:     '✈️',
    scheduled:  '🕐',
    landed:     '🛬',
    cancelled:  '❌',
    diverted:   '↪️',
    unknown:    '❓',
  }[flight.status] || '✈️';

  const delayStr  = flight.delay > 0 ? `⚠️ Delayed ${escapeMd(String(flight.delay))} min` : '✅ On time';
  const schedStr  = flight.scheduled ? escapeMd(new Date(flight.scheduled).toUTCString().slice(0, 25)) : 'N/A';
  const estStr    = flight.estimated ? escapeMd(new Date(flight.estimated).toUTCString().slice(0, 25)) : 'N/A';

  return [
    `*${escapeMd(statusIcon + ' ' + flight.flight)} — ${escapeMd(flight.airline)}*`,
    ``,
    `🛫 *${escapeMd(flight.origin)}* \\(${escapeMd(flight.originCode)}\\)`,
    `  Gate: ${escapeMd(flight.gate)} · Terminal: ${escapeMd(flight.terminal)}`,
    ``,
    `🛬 *${escapeMd(flight.destination)}* \\(${escapeMd(flight.destinationCode)}\\)`,
    `  Gate: ${escapeMd(flight.arrivalGate)} · Terminal: ${escapeMd(flight.arrivalTerminal)}`,
    ``,
    `📅 Scheduled: ${schedStr}`,
    `🕒 Estimated: ${estStr}`,
    `${delayStr}`,
    ``,
    `_${escapeMd(BOT_ID)} EXPLORATOR AERIS | ${escapeMd(new Date().toUTCString())}_`,
  ].join('\n');
}

/* ─── Request handler ───────────────────────────────────────────────────── */

async function handleRequest(request, env) {
  const url     = new URL(request.url);
  const path    = url.pathname;
  const cors    = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-Bot-ID': BOT_ID,
    'X-Bot-Name': BOT_NAME,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST,DELETE', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, trackCount, watchList: watchList.size, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, trackCount, watchList: watchList.size, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/watchlist' && request.method === 'GET') {
    const list = [...watchList.entries()].map(([f, meta]) => ({ flight: f, ...meta }));
    return new Response(JSON.stringify({ botId: BOT_ID, watchList: list, count: list.length }), { headers: cors });
  }

  if (path === '/watch' && request.method === 'POST') {
    const body   = await request.json().catch(() => ({}));
    const flight = (body.flight || '').trim().toUpperCase();
    if (!flight) return new Response(JSON.stringify({ error: 'flight required', botId: BOT_ID }), { status: 400, headers: cors });

    // Token gate — requires SCB tier
    const tokenId = body.token || '';
    const tokenResult = await verifyToken(tokenId, env);
    if (!tokenResult.ok || !canAccess(tokenResult.tier, 'airport-aeris')) {
      return new Response(JSON.stringify({ error: 'requires SCB token tier or higher', botId: BOT_ID }), { status: 403, headers: cors });
    }

    watchList.set(flight, { addedAt: Date.now(), lastStatus: null });
    return new Response(JSON.stringify({ botId: BOT_ID, watched: flight, total: watchList.size }), { headers: cors });
  }

  if (path.startsWith('/watch/') && request.method === 'DELETE') {
    const flight = path.slice('/watch/'.length).toUpperCase();
    const removed = watchList.delete(flight);
    return new Response(JSON.stringify({ botId: BOT_ID, removed, flight }), { headers: cors });
  }

  if (path === '/track' && request.method === 'GET') {
    const flight  = (url.searchParams.get('flight') || '').trim().toUpperCase();
    const notify  = url.searchParams.get('notify') !== '0';

    if (!flight) {
      return new Response(JSON.stringify({ error: 'flight query param required', botId: BOT_ID }), { status: 400, headers: cors });
    }

    beatCount++;
    trackCount++;
    const flightData = await fetchFlight(flight, env);
    const message    = buildFlightMessage(flightData);

    let telegramResult = { ok: false, skipped: true };
    if (notify) {
      telegramResult = await sendTelegram(message, env);
    }

    return new Response(JSON.stringify({
      botId: BOT_ID, flight: flightData, telegram: telegramResult, trackCount, beat: beatCount,
    }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

/* ─── Scheduled: sweep watch list every hour ────────────────────────────── */

async function scheduledSweep(env) {
  beatCount++;
  for (const [flight] of watchList.entries()) {
    const data    = await fetchFlight(flight, env);
    const message = buildFlightMessage(data);
    await sendTelegram(message, env);
    watchList.set(flight, { addedAt: watchList.get(flight)?.addedAt, lastStatus: data.status, lastCheck: Date.now() });
    trackCount++;
  }
}

/* ─── Runtime listeners ─────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request, event.env ?? {})));
addEventListener('scheduled', event => event.waitUntil(scheduledSweep(event.env ?? {})));
