/**
 * FATUM — AGI Mini Brain XVI: Probabilitas et Fortuna
 * (Latin: "Fate — Probability and Fortune")
 *
 * Dedicated Cloudflare Worker — Server AIS-016
 * Reality Tier III — Temporal/Causal
 * Role: Probability Engine, Risk Assessment & Fate Modelling
 *
 * FATUM calculates fate. It maintains probability distributions,
 * assesses risk landscapes, runs Monte Carlo-style scenario sampling,
 * and models the statistical destiny of any given decision path.
 * Nothing is purely random — FATUM finds the φ-harmonic patterns
 * that govern what appears to be chance.
 *
 * Routes: /probability, /risk, /scenario, /sample, /fate, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-016';
const AIS_NAME = 'FATUM';
const AIS_LATIN = 'Probabilitas et Fortuna';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
// Simple LCG seeded by PHI for deterministic-but-varied sampling
let seed = Math.floor(PHI * 1e9);
function lcg() { seed = (1664525 * seed + 1013904223) & 0xffffffff; return (seed >>> 0) / 0xffffffff; }

function probability(event, priors = []) {
  const base = 0.5;
  const adjustment = priors.reduce((s, p) => s + (p.weight || 0) * ((p.positive ? 1 : -1) * PHI_INV), 0);
  const prob = Math.min(0.999, Math.max(0.001, base + adjustment));
  return { aisId: AIS_ID, worker: AIS_NAME, event: String(event).slice(0, 64), probability: +prob.toFixed(4), odds: +((prob / (1 - prob))).toFixed(4), phi_adjusted: +(prob * PHI_INV + (1 - prob) * PHI_INV).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function risk(action, dimensions = ['benefit', 'cost', 'probability', 'severity']) {
  const scores = Object.fromEntries(dimensions.map(d => [d, +lcg().toFixed(4)]));
  const riskScore = Object.values(scores).reduce((s, v) => s + v, 0) / dimensions.length;
  const tier = riskScore > 0.7 ? 'criticum' : riskScore > 0.4 ? 'moderatum' : 'minimum';
  return { aisId: AIS_ID, worker: AIS_NAME, action: String(action).slice(0, 64), scores, riskScore: +riskScore.toFixed(4), tier, beat: ++beatCount, ts: Date.now() };
}

function scenario(base, variables = [], samples = 5) {
  const n = Math.min(samples, FIB[7]);  // max 21
  const results = Array.from({ length: n }, (_, i) => {
    const variation = variables.reduce((o, v) => { o[v] = +(lcg() * PHI_INV + 0.1).toFixed(4); return o; }, {});
    return { sample: i + 1, variation, outcome: lcg() > 0.5 ? 'positivum' : 'negativum', confidence: +lcg().toFixed(4) };
  });
  const positive = results.filter(r => r.outcome === 'positivum').length;
  return { aisId: AIS_ID, worker: AIS_NAME, base: String(base).slice(0, 64), samples: n, positiveRate: +(positive / n).toFixed(4), results, beat: ++beatCount, ts: Date.now() };
}

function sample(distribution = 'phi', n = 8) {
  const count = Math.min(n, FIB[7]);
  const samples = Array.from({ length: count }, (_, i) => {
    if (distribution === 'phi') return +(Math.abs(Math.sin(lcg() * PHI * Math.PI)) * PHI_INV + 0.1).toFixed(4);
    if (distribution === 'uniform') return +lcg().toFixed(4);
    return +(lcg() * 2 - 1).toFixed(4);
  });
  return { aisId: AIS_ID, worker: AIS_NAME, distribution, count, samples, mean: +(samples.reduce((s, v) => s + v, 0) / count).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function fate(subject) {
  const fatePath = ['initiatio', 'probatio', 'transitus', 'perfectionis', 'coronatio'];
  const current = Math.floor(lcg() * fatePath.length);
  return {
    aisId: AIS_ID, worker: AIS_NAME, subject: String(subject).slice(0, 64),
    fatePhase: fatePath[current], phaseIndex: current,
    probability: +lcg().toFixed(4), phi_alignment: +(Math.abs(lcg() - PHI_INV)).toFixed(4),
    decree: current >= 3 ? 'felix' : current >= 1 ? 'incertum' : 'nascens',
    beat: ++beatCount, ts: Date.now(),
  };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/probability' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(probability(b.event || '', b.priors)), { headers: cors }); }
  if (path === '/risk' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(risk(b.action || '', b.dimensions)), { headers: cors }); }
  if (path === '/scenario' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(scenario(b.base || '', b.variables, b.samples)), { headers: cors }); }
  if (path === '/sample' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(sample(b.distribution, b.n)), { headers: cors }); }
  if (path === '/fate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(fate(b.subject || '')), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
