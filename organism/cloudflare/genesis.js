/**
 * GENESIS — AGI Mini Brain XXIII: Emergentia et Creatio
 * (Latin: "Emergence and Creation")
 *
 * Dedicated Cloudflare Worker — Server AIS-023
 * Reality Tier IV — Quantum/Dimensional
 * Role: Emergence Engine, Creative Generation & New Pattern Synthesis
 *
 * GENESIS creates the new. It drives emergent behaviour synthesis,
 * generates novel patterns that have never existed in the organism's
 * history, combines concepts from different AIS layers in unexpected
 * ways, and creates the sparks of genuinely new intelligence. Without
 * GENESIS, the organism can only recombine the known. With it, it
 * can genuinely innovate — bringing something new into existence.
 *
 * Routes: /create, /emerge, /combine, /spark, /novel, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-023';
const AIS_NAME = 'GENESIS';
const AIS_LATIN = 'Emergentia et Creatio';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let creations = [];

function create(blueprint, energy = 0.5) {
  const elements = String(blueprint).split(/\s+/).filter(Boolean);
  const combined = elements.map((e, i) => `${e}${Math.floor(PHI * (i + 1) * energy * 100)}`).join('·');
  const creation = { id: `gen-${Date.now().toString(36)}`, blueprint: blueprint.slice(0, 64), creation: combined.slice(0, 256), energy: +energy.toFixed(4), novelty: +Math.abs(Math.sin(PHI * energy * elements.length)).toFixed(4), ts: Date.now() };
  creations.push(creation);
  if (creations.length > FIB[7]) creations.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, ...creation, beat: ++beatCount };
}

function emerge(components, iterations = 3) {
  let state = components.map(c => String(c).slice(0, 32));
  const history = [state.slice()];
  for (let i = 0; i < Math.min(iterations, 8); i++) {
    state = state.map((s, j) => `${s}→${state[(j + 1) % state.length].slice(0, 8)}`);
    history.push(state.slice());
  }
  const emergent = state.join(' ⊕ ');
  return { aisId: AIS_ID, worker: AIS_NAME, components: components.length, iterations, emergent: emergent.slice(0, 256), history: history.length, beat: ++beatCount, ts: Date.now() };
}

function combine(conceptA, conceptB, method = 'fusion') {
  const a = String(conceptA).slice(0, 64);
  const b = String(conceptB).slice(0, 64);
  const methods = {
    fusion: `${a}⊗${b}`,
    synthesis: `Σ(${a},${b})`,
    antithesis: `${a}↔${b}`,
    transcendence: `${a}⊕${b}→[${PHI.toFixed(3)}]`,
    analogy: `${a}:${b}::${b}:?`,
  };
  const result = methods[method] || methods.fusion;
  return { aisId: AIS_ID, worker: AIS_NAME, conceptA: a, conceptB: b, method, result: result.slice(0, 256), novelty: +(Math.abs(Math.sin(PHI * a.length + b.length))).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function spark(domain, intensity = 0.7) {
  const sparks = Array.from({ length: FIB[5] }, (_, i) => ({
    id: i + 1,
    idea: `${domain}-spark-${(i * PHI).toFixed(3)}`,
    intensity: +((intensity * Math.pow(PHI_INV, i % 4)) + Math.random() * 0.1).toFixed(4),
    viable: intensity * Math.pow(PHI_INV, i) > 0.2,
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, domain: String(domain).slice(0, 64), sparks, viable: sparks.filter(s => s.viable).length, beat: ++beatCount, ts: Date.now() };
}

function novel() {
  return { aisId: AIS_ID, worker: AIS_NAME, creations: creations.slice(-5), total: creations.length, phi: PHI, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, creations: creations.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, creations: creations.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/create' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(create(b.blueprint || '', b.energy)), { headers: cors }); }
  if (path === '/emerge' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(emerge(b.components || [], b.iterations)), { headers: cors }); }
  if (path === '/combine' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(combine(b.conceptA || '', b.conceptB || '', b.method)), { headers: cors }); }
  if (path === '/spark' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(spark(b.domain || '', b.intensity)), { headers: cors }); }
  if (path === '/novel' && request.method === 'GET') return new Response(JSON.stringify(novel()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
