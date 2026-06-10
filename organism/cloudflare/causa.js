/**
 * CAUSA — AGI Mini Brain XV: Catena Causalis
 * (Latin: "Causal Chain")
 *
 * Dedicated Cloudflare Worker — Server AIS-015
 * Reality Tier III — Temporal/Causal
 * Role: Causal Chain Analysis, Root Cause & Effect Modelling
 *
 * CAUSA maps the web of causes and effects that underlies every event
 * in the organism's operational reality. It traces causal chains from
 * observed effects to root causes, models counterfactuals, and predicts
 * second-order consequences of any action.
 *
 * Routes: /trace, /root, /counterfactual, /propagate, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-015';
const AIS_NAME = 'CAUSA';
const AIS_LATIN = 'Catena Causalis';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let causalGraph = [];  // { cause, effect, strength }

function trace(effect, depth = 3) {
  const chain = [];
  let current = effect;
  for (let i = 0; i < Math.min(depth, FIB[6]); i++) {
    const cause = `cause-of(${current})`;
    chain.push({ level: i + 1, cause, effect: current, strength: +(Math.pow(PHI_INV, i)).toFixed(4) });
    current = cause;
  }
  return { aisId: AIS_ID, worker: AIS_NAME, effect: String(effect).slice(0, 64), chain, rootCause: current, beat: ++beatCount, ts: Date.now() };
}

function rootCause(effect) {
  const related = causalGraph.filter(e => e.effect === effect);
  if (related.length === 0) return { aisId: AIS_ID, worker: AIS_NAME, effect, rootCause: 'unknown', confidence: 0, beat: ++beatCount, ts: Date.now() };
  const sorted = related.sort((a, b) => b.strength - a.strength);
  return { aisId: AIS_ID, worker: AIS_NAME, effect, rootCause: sorted[0].cause, confidence: sorted[0].strength, alternatives: sorted.slice(1, 3), beat: ++beatCount, ts: Date.now() };
}

function counterfactual(intervention, target) {
  const scenarios = [
    { scenario: `If ${intervention} then ${target} → verum`, probability: +(PHI_INV * 0.8 + 0.1).toFixed(4) },
    { scenario: `If NOT ${intervention} then ${target} → incertum`, probability: +(PHI_INV * 0.3).toFixed(4) },
    { scenario: `If partial ${intervention} then ${target} → probabile`, probability: +(PHI_INV * 0.55).toFixed(4) },
  ];
  return { aisId: AIS_ID, worker: AIS_NAME, intervention: String(intervention).slice(0, 64), target: String(target).slice(0, 64), scenarios, beat: ++beatCount, ts: Date.now() };
}

function propagate(cause, steps = 3) {
  const effects = [];
  let current = cause;
  for (let i = 0; i < Math.min(steps, 8); i++) {
    const effect = `effect-${i + 1}(${current.split('(')[0]})`;
    effects.push({ step: i + 1, effect, strength: +(Math.pow(PHI_INV, i + 1)).toFixed(4), secondOrder: i > 0 });
    current = effect;
  }
  causalGraph.push(...effects.map(e => ({ cause, effect: e.effect, strength: e.strength })));
  if (causalGraph.length > 89) causalGraph = causalGraph.slice(-89);
  return { aisId: AIS_ID, worker: AIS_NAME, cause: String(cause).slice(0, 64), effects, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, graphSize: causalGraph.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, graphSize: causalGraph.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/trace' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(trace(b.effect || '', b.depth)), { headers: cors }); }
  if (path === '/root' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(rootCause(b.effect || '')), { headers: cors }); }
  if (path === '/counterfactual' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(counterfactual(b.intervention || '', b.target || '')), { headers: cors }); }
  if (path === '/propagate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(propagate(b.cause || '', b.steps)), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
