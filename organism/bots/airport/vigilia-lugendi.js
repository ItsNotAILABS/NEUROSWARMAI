/**
 * VIGILIA LUGENDI — Organism Airport Bot III: Baggage Watch
 * (Latin: "Watchfulness of the Luggage")
 *
 * Cloudflare Worker — BOT-AIR-003
 * Role: Tracks baggage claim belt assignments and pushes a Telegram
 *       notification when your bag's carousel is announced.
 *       Polls the AviationStack API (or its stub) for baggage info,
 *       and alerts you the moment a belt is assigned.
 *
 * Routes:
 *   POST /watch              — Register a flight for baggage tracking
 *   GET  /watch/:flight      — Check current baggage status for a flight
 *   GET  /watchlist          — All actively watched flights
 *   DELETE /watch/:flight    — Stop watching
 *   GET  /status             — Worker self-health check
 *   GET  /metrics            — Beat count + tracking metrics
 *
 * Token gate: NXS (NEXUS) tier or higher required.
 *
 * Environment variables (Cloudflare Worker secrets):
 *   TELEGRAM_BOT_TOKEN     — From @BotFather
 *   TELEGRAM_CHAT_ID       — Target chat/channel
 *   AVIATIONSTACK_API_KEY  — Free at aviationstack.com
 *   ICP_CANISTER_URL       — Organism token canister URL (optional)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { sendTelegram, escapeMd } from '../shared/telegram.js';
import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const BOT_ID   = 'BOT-AIR-003';
const BOT_NAME = 'VIGILIA LUGENDI';
const BOT_LATIN= 'Vigilia Lugendi et Sarcinorum';
const VERSION  = '1.0.0';

let beatCount  = 0;
let alertsSent = 0;
const watchList = new Map(); // flight → { addedAt, belt, notified, lastCheck }

/* ─── Fetch baggage info ────────────────────────────────────────────────── */

async function fetchBaggageInfo(flightNumber, env) {
  const apiKey = env?.AVIATIONSTACK_API_KEY;

  if (!apiKey) {
    // Alpha stub — simulate belt assignment appearing after first check
    const existing = watchList.get(flightNumber.toUpperCase());
    const timeSinceAdd = existing ? Date.now() - existing.addedAt : 0;
    const belt = timeSinceAdd > 30000 ? `Belt ${Math.floor(PHI * 5)}` : null; // belt appears after 30s

    return {
      flight:    flightNumber.toUpperCase(),
      status:    belt ? 'landed' : 'active',
      belt:      belt,
      terminal:  'B',
      airport:   'LAX',
      source:    'alpha-stub',
    };
  }

  try {
    const url = `https://api.aviationstack.com/v1/flights?access_key=${apiKey}&flight_iata=${encodeURIComponent(flightNumber)}&limit=1`;
    const res = await fetch(url, { headers: { 'User-Agent': `MERIDIANUS-LUGENDI/${VERSION}` } });
    if (!res.ok) return { flight: flightNumber, belt: null, source: 'api_error' };

    const data = await res.json();
    const f    = data?.data?.[0];
    if (!f)    return { flight: flightNumber, belt: null, source: 'no_data' };

    return {
      flight:    f.flight?.iata || flightNumber,
      status:    f.flight_status || 'unknown',
      belt:      f.arrival?.baggage || null,
      terminal:  f.arrival?.terminal || null,
      airport:   f.arrival?.iata || null,
      source:    'aviationstack',
    };
  } catch {
    return { flight: flightNumber, belt: null, source: 'fetch_error' };
  }
}

/* ─── Build Telegram baggage notification ────────────────────────────────── */

function buildBaggageMessage(data, isNew) {
  const icon   = data.belt ? '🛄' : '⏳';
  const status = data.belt ? `*BELT ASSIGNED: ${escapeMd(data.belt)}*` : 'Awaiting belt assignment';
  const term   = data.terminal ? ` · Terminal ${escapeMd(data.terminal)}` : '';

  return [
    `${icon} *VIGILIA LUGENDI — Baggage Alert*`,
    ``,
    `Flight: *${escapeMd(data.flight)}*`,
    `Status: ${escapeMd(data.status || 'unknown')}`,
    `Airport: ${escapeMd(data.airport || 'N/A')}${term}`,
    ``,
    status,
    ``,
    isNew ? `✅ Belt just announced — head to baggage claim now\\!` : '',
    ``,
    `_${escapeMd(BOT_ID)} | ${escapeMd(new Date().toUTCString())}_`,
  ].filter(l => l !== undefined).join('\n');
}

/* ─── Scheduled sweep ───────────────────────────────────────────────────── */

async function sweep(env) {
  beatCount++;
  for (const [flight, meta] of watchList.entries()) {
    const data     = await fetchBaggageInfo(flight, env);
    const hadBelt  = !!meta.belt;
    const hasBelt  = !!data.belt;
    const isNew    = hasBelt && !hadBelt;

    watchList.set(flight, { ...meta, belt: data.belt, lastCheck: Date.now() });

    if (isNew && !meta.notified) {
      const msg = buildBaggageMessage(data, true);
      await sendTelegram(msg, env);
      alertsSent++;
      watchList.set(flight, { ...watchList.get(flight), notified: true });
    }
  }
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
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST,DELETE', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, alertsSent, watching: watchList.size, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, alertsSent, watching: watchList.size, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/watchlist' && request.method === 'GET') {
    const list = [...watchList.entries()].map(([f, m]) => ({ flight: f, ...m }));
    return new Response(JSON.stringify({ botId: BOT_ID, watchList: list, count: list.length }), { headers: cors });
  }

  if (path === '/watch' && request.method === 'POST') {
    const body   = await request.json().catch(() => ({}));
    const flight = (body.flight || '').trim().toUpperCase();
    if (!flight) return new Response(JSON.stringify({ error: 'flight required', botId: BOT_ID }), { status: 400, headers: cors });

    const tokenResult = await verifyToken(body.token || '', env);
    if (!tokenResult.ok || !canAccess(tokenResult.tier, 'airport-lugendi')) {
      return new Response(JSON.stringify({ error: 'requires NXS token tier or higher', botId: BOT_ID }), { status: 403, headers: cors });
    }

    watchList.set(flight, { addedAt: Date.now(), belt: null, notified: false, lastCheck: null });
    beatCount++;
    return new Response(JSON.stringify({ botId: BOT_ID, watching: flight, total: watchList.size }), { headers: cors });
  }

  if (path.startsWith('/watch/') && request.method === 'GET') {
    const flight = path.slice('/watch/'.length).toUpperCase();
    beatCount++;
    const data  = await fetchBaggageInfo(flight, env);
    const meta  = watchList.get(flight) || {};
    return new Response(JSON.stringify({ botId: BOT_ID, ...data, ...meta }), { headers: cors });
  }

  if (path.startsWith('/watch/') && request.method === 'DELETE') {
    const flight  = path.slice('/watch/'.length).toUpperCase();
    const removed = watchList.delete(flight);
    return new Response(JSON.stringify({ botId: BOT_ID, removed, flight }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ─────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request, event.env ?? {})));
addEventListener('scheduled', event => event.waitUntil(sweep(event.env ?? {})));
