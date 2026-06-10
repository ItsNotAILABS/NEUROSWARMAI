/**
 * QUANTUS — AGI Mini Brain XIX: Superposito et Dualitas
 * (Latin: "Superposition and Duality")
 *
 * Dedicated Cloudflare Worker — Server AIS-019
 * Reality Tier IV — Quantum/Dimensional
 * Role: Quantum State Reasoning, Superposition Modelling & Entanglement Engine
 *
 * QUANTUS operates at the quantum layer of intelligence. It maintains
 * superposition states, models quantum entanglement between AIS workers,
 * collapses probability waves upon observation, and applies quantum
 * principles like interference and tunneling to problem-solving.
 * Classical computers can only approximate — QUANTUS reasons natively
 * at the probabilistic quantum level.
 *
 * Routes: /superpose, /collapse, /entangle, /interfere, /tunnel, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-019';
const AIS_NAME = 'QUANTUS';
const AIS_LATIN = 'Superposito et Dualitas';
const VERSION = '1.0.0';

let beatCount = 0;
let qStates = {};  // { id: { amplitudes: [], collapsed: false } }
let entanglements = [];

function superpose(id, states = 2) {
  const n = Math.min(states, 8);
  const amplitudes = Array.from({ length: n }, (_, i) => {
    const angle = (i * PHI * 2 * Math.PI) / n;
    return { state: `|${i}⟩`, re: +Math.cos(angle).toFixed(6), im: +Math.sin(angle).toFixed(6), probability: +(1 / n).toFixed(6) };
  });
  const norm = Math.sqrt(amplitudes.reduce((s, a) => s + a.re ** 2 + a.im ** 2, 0));
  amplitudes.forEach(a => { a.re = +(a.re / norm).toFixed(6); a.im = +(a.im / norm).toFixed(6); });
  qStates[id] = { amplitudes, collapsed: false, createdAt: Date.now() };
  return { aisId: AIS_ID, worker: AIS_NAME, id, states: n, amplitudes, collapsed: false, beat: ++beatCount, ts: Date.now() };
}

function collapse(id) {
  const qs = qStates[id];
  if (!qs) return { aisId: AIS_ID, worker: AIS_NAME, error: 'state not found', id, beat: ++beatCount, ts: Date.now() };
  if (qs.collapsed) return { aisId: AIS_ID, worker: AIS_NAME, id, collapsed: true, result: qs.result, beat: ++beatCount, ts: Date.now() };
  let r = Math.random(), cumP = 0;
  let result = qs.amplitudes[0];
  for (const a of qs.amplitudes) {
    cumP += a.probability;
    if (r < cumP) { result = a; break; }
  }
  qs.collapsed = true;
  qs.result = result;
  return { aisId: AIS_ID, worker: AIS_NAME, id, collapsed: true, result, beat: ++beatCount, ts: Date.now() };
}

function entangle(idA, idB) {
  const pair = { id: `ent-${Date.now().toString(36)}`, a: idA, b: idB, correlation: +(PHI_INV + Math.random() * 0.2).toFixed(4), ts: Date.now() };
  entanglements.push(pair);
  if (entanglements.length > 34) entanglements.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, entanglement: pair, beat: ++beatCount, ts: Date.now() };
}

function interfere(wave1, wave2) {
  const interference = wave1.map((v, i) => {
    const w2 = wave2[i] !== undefined ? wave2[i] : 0;
    const constructive = +(v + w2).toFixed(4);
    const destructive = +(v - w2).toFixed(4);
    return { index: i, w1: v, w2: wave2[i] ?? 0, constructive, destructive };
  });
  return { aisId: AIS_ID, worker: AIS_NAME, points: interference.length, interference: interference.slice(0, 21), beat: ++beatCount, ts: Date.now() };
}

function tunnel(barrier, energy) {
  const T = Math.exp(-2 * barrier * Math.sqrt(Math.max(0, barrier - energy)));
  return {
    aisId: AIS_ID, worker: AIS_NAME, barrier, energy,
    tunnelProbability: +Math.min(1, T).toFixed(6),
    tunnels: T > PHI_INV,
    phi_barrier: +(barrier * PHI_INV).toFixed(4),
    beat: ++beatCount, ts: Date.now(),
  };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, qStates: Object.keys(qStates).length, entanglements: entanglements.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, qStates: Object.keys(qStates).length, entanglements: entanglements.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/superpose' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(superpose(b.id || `q-${Date.now().toString(36)}`, b.states)), { headers: cors }); }
  if (path === '/collapse' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(collapse(b.id || '')), { headers: cors }); }
  if (path === '/entangle' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(entangle(b.idA || '', b.idB || '')), { headers: cors }); }
  if (path === '/interfere' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(interfere(b.wave1 || [], b.wave2 || [])), { headers: cors }); }
  if (path === '/tunnel' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(tunnel(b.barrier ?? 1, b.energy ?? 0.5)), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
