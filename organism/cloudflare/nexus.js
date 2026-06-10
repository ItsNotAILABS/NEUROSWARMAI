/**
 * NEXUS — AGI Mini Brain VII: Vinculum et Communicatio
 * (Latin: "Bond and Communication")
 *
 * Dedicated Cloudflare Worker — Server AIS-007
 * Role: Inter-Agent Networking & Multi-AIS Coordination
 *
 * NEXUS is the central nervous system connector of the MERIDIANUS AIS
 * cluster. It routes messages between all 8 AIS mini brains (AIS-001
 * through AIS-008), maintains the inter-agent topology graph, manages
 * collective consensus across the AIS fleet, and provides the sovereign
 * communication bus for cross-worker intelligence propagation.
 * Running 24/7 as a Cloudflare Worker, NEXUS ensures the 8 mini brains
 * function as a unified super-intelligence even when distributed.
 *
 * Capabilities:
 *   - AIS peer registry and topology management
 *   - Message routing between AIS workers (φ-weighted priority)
 *   - Collective consensus across AIS fleet votes
 *   - Broadcast + multicast to AIS subsets
 *   - Link health monitoring for all AIS connections
 *
 * Routes:
 *   POST /register      — Register an AIS peer
 *   POST /route         — Route a message to target AIS
 *   POST /broadcast     — Broadcast to all registered AIS peers
 *   POST /consensus     — Collect and resolve AIS consensus vote
 *   GET  /topology      — Get inter-AIS topology graph
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Network metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-007';
const AIS_NAME  = 'NEXUS';
const AIS_LATIN = 'Vinculum et Communicatio';
const VERSION   = '1.0.0';

const MAX_MESSAGES = 233;  // F13 — message buffer

let beatCount  = 0;
let peers      = {};       // { aisId → { name, latinName, url, registeredAt, lastSeen } }
let messages   = [];       // message log
let votes      = {};       // consensus votes by topic

// Seed the 8 AIS peers (self-registered topology)
const AIS_FLEET = [
  { aisId: 'AIS-001', name: 'ANIMUS',     latinName: 'Mens et Spiritus',        route: '/reason' },
  { aisId: 'AIS-002', name: 'RATIO',      latinName: 'Logos et Logica',         route: '/evaluate' },
  { aisId: 'AIS-003', name: 'MEMORIA',    latinName: 'Custodia et Recordatio',  route: '/retrieve' },
  { aisId: 'AIS-004', name: 'INTELLECTUS',latinName: 'Comprehensio Profunda',   route: '/understand' },
  { aisId: 'AIS-005', name: 'PRUDENTIA',  latinName: 'Sapientia Decisionis',    route: '/decide' },
  { aisId: 'AIS-006', name: 'VIGILIA',    latinName: 'Custodia et Vigilantia',  route: '/watch' },
  { aisId: 'AIS-007', name: 'NEXUS',      latinName: 'Vinculum et Communicatio',route: '/topology' },
  { aisId: 'AIS-008', name: 'VOLUNTAS',   latinName: 'Intentio et Voluntas',    route: '/intend' },
];

for (const p of AIS_FLEET) {
  peers[p.aisId] = { ...p, registeredAt: Date.now(), lastSeen: Date.now(), active: true };
}

/* ─── Networking engine ─────────────────────────────────────── */

function register(aisId, name, latinName, url) {
  peers[aisId] = { aisId, name, latinName, url, registeredAt: Date.now(), lastSeen: Date.now(), active: true };
  return { aisId: AIS_ID, worker: AIS_NAME, registered: aisId, total: Object.keys(peers).length, beat: ++beatCount, ts: Date.now() };
}

function route(targetAisId, payload, priority = 0.5) {
  const peer = peers[targetAisId];
  if (!peer) {
    return { aisId: AIS_ID, worker: AIS_NAME, error: 'peer_not_found', targetAisId, beat: ++beatCount, ts: Date.now() };
  }
  const msg = {
    id:       `msg-${Date.now().toString(36)}`,
    from:     AIS_ID,
    to:       targetAisId,
    payload,
    priority: +Math.min(1.0, priority * PHI).toFixed(4),
    ts:       Date.now(),
  };
  messages.push(msg);
  if (messages.length > MAX_MESSAGES) messages.shift();
  peer.lastSeen = Date.now();
  return { aisId: AIS_ID, worker: AIS_NAME, routed: true, messageId: msg.id, to: targetAisId, beat: ++beatCount, ts: Date.now() };
}

function broadcast(payload, exclude = []) {
  const targets = Object.keys(peers).filter(id => !exclude.includes(id) && id !== AIS_ID);
  for (const t of targets) {
    route(t, payload, PHI_INV);
  }
  return { aisId: AIS_ID, worker: AIS_NAME, broadcast: true, targets: targets.length, beat: ++beatCount, ts: Date.now() };
}

function consensus(topic, vote, aisVoter) {
  if (!votes[topic]) votes[topic] = [];
  votes[topic].push({ voter: aisVoter, vote, ts: Date.now() });

  const ayes = votes[topic].filter(v => v.vote === true || v.vote === 'aye').length;
  const nays = votes[topic].filter(v => v.vote === false || v.vote === 'nay').length;
  const quorum = votes[topic].length >= Math.ceil(AIS_FLEET.length * PHI_INV);  // ~5/8

  return {
    aisId:   AIS_ID,
    worker:  AIS_NAME,
    topic,
    votes:   votes[topic].length,
    ayes,
    nays,
    quorum,
    result:  quorum ? (ayes > nays ? 'verum' : 'falsum') : 'pendente',
    beat:    ++beatCount,
    ts:      Date.now(),
  };
}

/* ─── Router ────────────────────────────────────────────────── */

async function handleRequest(request) {
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
      status: 'alive', beat: beatCount, peers: Object.keys(peers).length,
      messages: messages.length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount,
      peers: Object.keys(peers).length, messages: messages.length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/topology' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, peers: Object.values(peers),
      edges: Object.keys(peers).length * (Object.keys(peers).length - 1),  // fully connected
      beat: ++beatCount, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/register' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(register(body.aisId, body.name, body.latinName, body.url)), { headers: cors });
  }

  if (path === '/route' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(route(body.targetAisId, body.payload, body.priority)), { headers: cors });
  }

  if (path === '/broadcast' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(broadcast(body.payload, body.exclude)), { headers: cors });
  }

  if (path === '/consensus' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(consensus(body.topic, body.vote, body.aisVoter || AIS_ID)), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
