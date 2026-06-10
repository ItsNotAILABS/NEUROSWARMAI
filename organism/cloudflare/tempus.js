/**
 * TEMPUS — AGI Mini Brain XIV: Custodia Temporis
 * (Latin: "Guardian of Time")
 *
 * Dedicated Cloudflare Worker — Server AIS-014
 * Reality Tier III — Temporal/Causal
 * Role: Temporal Intelligence, Time-Series Analysis & Chronological Memory
 *
 * TEMPUS governs time. It tracks temporal patterns, detects cycles,
 * compresses historical time-series into φ-harmonic summaries, and
 * maintains chronological order across all AIS operations. Time is
 * the fabric of causality — TEMPUS is its sovereign custodian.
 *
 * Routes: /record, /compress, /cycle, /sequence, /now, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-014';
const AIS_NAME = 'TEMPUS';
const AIS_LATIN = 'Custodia Temporis';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];

let beatCount = 0;
let timeline = [];   // { id, event, ts, phi_weight }
const MAX_TIMELINE = 144;  // F12

function record(event, metadata = {}) {
  const entry = {
    id: `evt-${Date.now().toString(36)}`,
    event: String(event).slice(0, 128),
    metadata,
    ts: Date.now(),
    phi_weight: +(1 / (timeline.length + 1)).toFixed(6),
    epoch: Math.floor(Date.now() / (PHI * 1e9)),
  };
  timeline.push(entry);
  if (timeline.length > MAX_TIMELINE) timeline.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, recorded: true, id: entry.id, total: timeline.length, beat: ++beatCount, ts: Date.now() };
}

function compress(windowMs = 3600000) {
  const cutoff = Date.now() - windowMs;
  const window = timeline.filter(e => e.ts >= cutoff);
  const compressed = window.length > FIB[5] ? window.filter((_, i) => i % Math.ceil(window.length / FIB[5]) === 0) : window;
  return { aisId: AIS_ID, worker: AIS_NAME, original: window.length, compressed: compressed.length, ratio: +(compressed.length / (window.length || 1)).toFixed(4), events: compressed, beat: ++beatCount, ts: Date.now() };
}

function detectCycle(values) {
  if (!values || values.length < 3) return { aisId: AIS_ID, worker: AIS_NAME, cycle: null, beat: ++beatCount, ts: Date.now() };
  // Find approximate period by checking autocorrelation at Fibonacci lags
  let bestLag = 1, bestCorr = -Infinity;
  for (const lag of FIB.slice(1, 8)) {
    if (lag >= values.length) break;
    let corr = 0;
    for (let i = lag; i < values.length; i++) corr += values[i] * values[i - lag];
    corr /= (values.length - lag);
    if (corr > bestCorr) { bestCorr = corr; bestLag = lag; }
  }
  return { aisId: AIS_ID, worker: AIS_NAME, period: bestLag, correlation: +bestCorr.toFixed(4), cycleType: bestLag <= 3 ? 'ultra' : bestLag <= 8 ? 'short' : 'long', beat: ++beatCount, ts: Date.now() };
}

function sequence(events) {
  const sorted = [...events].sort((a, b) => (a.ts || 0) - (b.ts || 0));
  const gaps = sorted.slice(1).map((e, i) => ({ before: sorted[i].id || i, after: e.id || i + 1, gapMs: (e.ts || 0) - (sorted[i].ts || 0) }));
  return { aisId: AIS_ID, worker: AIS_NAME, ordered: sorted, gaps, beat: ++beatCount, ts: Date.now() };
}

function now() {
  const ts = Date.now();
  const phi_epoch = +(ts / (PHI * 1e9)).toFixed(6);
  const fib_second = FIB.find(f => f * 1000 > ts % 60000) || 1;
  return { aisId: AIS_ID, worker: AIS_NAME, ts, iso: new Date(ts).toISOString(), phi_epoch, fib_second, timeline_size: timeline.length, beat: ++beatCount };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, timelineSize: timeline.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, timelineSize: timeline.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/now' && request.method === 'GET') return new Response(JSON.stringify(now()), { headers: cors });
  if (path === '/record' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(record(b.event || '', b.metadata)), { headers: cors }); }
  if (path === '/compress' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(compress(b.windowMs)), { headers: cors }); }
  if (path === '/cycle' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(detectCycle(b.values || [])), { headers: cors }); }
  if (path === '/sequence' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(sequence(b.events || [])), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
