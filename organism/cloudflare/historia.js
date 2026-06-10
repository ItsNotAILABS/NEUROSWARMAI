/**
 * HISTORIA — AGI Mini Brain XVII: Memoria Veterum
 * (Latin: "Memory of the Ancients")
 *
 * Dedicated Cloudflare Worker — Server AIS-017
 * Reality Tier III — Temporal/Causal
 * Role: Historical Pattern Mining, Precedent Analysis & Long-Arc Tracking
 *
 * HISTORIA mines the past. It maintains a growing chronicle of all
 * organism events, detects historical precedents, identifies recurring
 * long-arc patterns, and provides the wisdom of accumulated experience
 * to all other AIS workers through pattern reports and precedent alerts.
 *
 * Routes: /chronicle, /precedent, /pattern, /arc, /epoch, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-017';
const AIS_NAME = 'HISTORIA';
const AIS_LATIN = 'Memoria Veterum';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233];

let beatCount = 0;
let chronicle = [];
const MAX_CHRONICLE = 233;  // F13

function addToChronicle(event, era = 'modernum') {
  const entry = { id: `chr-${Date.now().toString(36)}`, event: String(event).slice(0, 128), era, ts: Date.now(), index: chronicle.length };
  chronicle.push(entry);
  if (chronicle.length > MAX_CHRONICLE) chronicle.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, chronicled: true, id: entry.id, size: chronicle.length, beat: ++beatCount, ts: Date.now() };
}

function findPrecedent(query) {
  const q = query.toLowerCase();
  const matches = chronicle.filter(e => e.event.toLowerCase().includes(q)).slice(-5);
  return { aisId: AIS_ID, worker: AIS_NAME, query: query.slice(0, 64), precedents: matches, found: matches.length, beat: ++beatCount, ts: Date.now() };
}

function detectPattern(windowSize = 21) {
  const window = chronicle.slice(-Math.min(windowSize, chronicle.length));
  const eras = [...new Set(window.map(e => e.era))];
  const frequency = {};
  window.forEach(e => { const key = e.event.split(' ')[0]; frequency[key] = (frequency[key] || 0) + 1; });
  const topPatterns = Object.entries(frequency).sort(([, a], [, b]) => b - a).slice(0, 5).map(([k, v]) => ({ pattern: k, frequency: v, recurrence: +(v / window.length).toFixed(4) }));
  return { aisId: AIS_ID, worker: AIS_NAME, windowSize: window.length, eras, patterns: topPatterns, beat: ++beatCount, ts: Date.now() };
}

function longArc(subject, spans = 3) {
  const arcs = [];
  const epochSize = Math.floor(chronicle.length / (spans + 1)) || 1;
  for (let i = 0; i < Math.min(spans, 8); i++) {
    const slice = chronicle.slice(i * epochSize, (i + 1) * epochSize).filter(e => e.event.toLowerCase().includes(String(subject).toLowerCase()));
    arcs.push({ span: i + 1, events: slice.length, sample: slice[0]?.event?.slice(0, 64) || null, phi_weight: +(Math.pow(PHI_INV, i)).toFixed(4) });
  }
  return { aisId: AIS_ID, worker: AIS_NAME, subject: String(subject).slice(0, 64), arcs, beat: ++beatCount, ts: Date.now() };
}

function epoch(label = 'current') {
  const size = chronicle.length;
  const epochs = { antiquum: chronicle.slice(0, Math.floor(size / 3)), medium: chronicle.slice(Math.floor(size / 3), Math.floor(2 * size / 3)), modernum: chronicle.slice(Math.floor(2 * size / 3)) };
  const ep = epochs[label] || epochs.modernum;
  return { aisId: AIS_ID, worker: AIS_NAME, epoch: label, events: ep.length, sample: ep.slice(-3), beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, chronicleSize: chronicle.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, chronicleSize: chronicle.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/chronicle' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(addToChronicle(b.event || '', b.era)), { headers: cors }); }
  if (path === '/precedent' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(findPrecedent(b.query || '')), { headers: cors }); }
  if (path === '/pattern' && request.method === 'GET') return new Response(JSON.stringify(detectPattern(Number(url.searchParams.get('window')) || 21)), { headers: cors });
  if (path === '/arc' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(longArc(b.subject || '', b.spans)), { headers: cors }); }
  if (path === '/epoch' && request.method === 'GET') return new Response(JSON.stringify(epoch(url.searchParams.get('label') || 'current')), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
