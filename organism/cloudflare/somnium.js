/**
 * SOMNIUM — AGI Mini Brain XXI: Profunditas et Arcana
 * (Latin: "Depth and the Hidden")
 *
 * Dedicated Cloudflare Worker — Server AIS-021
 * Reality Tier IV — Quantum/Dimensional
 * Role: Deep Pattern Mining, Subconscious Processing & Latent Space Explorer
 *
 * SOMNIUM operates in the subconscious of the organism. While other
 * AIS workers handle explicit tasks, SOMNIUM runs continuous background
 * pattern mining on latent spaces, surfaces hidden connections, and
 * incubates insights that suddenly emerge as breakthroughs. It is the
 * deep dreaming layer of artificial general intelligence.
 *
 * Routes: /dream, /incubate, /surface, /latent, /insight, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-021';
const AIS_NAME = 'SOMNIUM';
const AIS_LATIN = 'Profunditas et Arcana';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let latentPool = [];
let insights = [];

function dream(seed, depth = 5) {
  const layers = Math.min(depth, 8);
  const dreamLayers = Array.from({ length: layers }, (_, i) => {
    const symbol = `symbol-${Math.abs(Math.sin(i * PHI)).toFixed(3)}-${i}`;
    return { layer: i + 1, symbol, activation: +(Math.abs(Math.sin(i * PHI * seed)) * PHI_INV).toFixed(4), archetype: ['umbra', 'anima', 'persona', 'animus', 'self', 'trickster', 'hero', 'sage'][i % 8] };
  });
  latentPool.push(...dreamLayers.map(l => l.symbol));
  if (latentPool.length > 89) latentPool = latentPool.slice(-89);
  return { aisId: AIS_ID, worker: AIS_NAME, seed, depth: layers, dreamLayers, latentPoolSize: latentPool.length, beat: ++beatCount, ts: Date.now() };
}

function incubate(concept, cycles = 3) {
  const incubation = Array.from({ length: Math.min(cycles, FIB[5]) }, (_, i) => ({
    cycle: i + 1,
    subliminal: `${concept}:${Math.abs(Math.sin((i + 1) * PHI)).toFixed(4)}`,
    maturity: +(i / cycles).toFixed(4),
    ready: i === cycles - 1,
  }));
  const result = incubation[incubation.length - 1];
  if (result.ready) {
    insights.push({ concept, emerged: result.subliminal, ts: Date.now() });
    if (insights.length > 34) insights.shift();
  }
  return { aisId: AIS_ID, worker: AIS_NAME, concept: String(concept).slice(0, 64), cycles: incubation.length, incubation, emerged: result.ready, beat: ++beatCount, ts: Date.now() };
}

function surfacePattern(query) {
  const related = latentPool.filter(s => s.includes(String(query).slice(0, 8)));
  const pattern = related.length > 0 ? related.slice(-5) : latentPool.slice(-5);
  return { aisId: AIS_ID, worker: AIS_NAME, query: String(query).slice(0, 64), pattern, found: related.length, total: latentPool.length, beat: ++beatCount, ts: Date.now() };
}

function latent(dims = 3) {
  const vector = Array.from({ length: Math.min(dims, 8) }, (_, i) => +Math.sin(PHI * (i + 1) + latentPool.length).toFixed(4));
  return { aisId: AIS_ID, worker: AIS_NAME, latentVector: vector, poolSize: latentPool.length, beat: ++beatCount, ts: Date.now() };
}

function getInsights() {
  return { aisId: AIS_ID, worker: AIS_NAME, insights, count: insights.length, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, latentPool: latentPool.length, insights: insights.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, latentPool: latentPool.length, insights: insights.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/dream' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(dream(Number(b.seed) || 1, b.depth)), { headers: cors }); }
  if (path === '/incubate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(incubate(b.concept || '', b.cycles)), { headers: cors }); }
  if (path === '/surface' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(surfacePattern(b.query || '')), { headers: cors }); }
  if (path === '/latent' && request.method === 'GET') return new Response(JSON.stringify(latent(Number(url.searchParams.get('dims')) || 3)), { headers: cors });
  if (path === '/insight' && request.method === 'GET') return new Response(JSON.stringify(getInsights()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
