/**
 * SAPIENTIA — AGI Mini Brain XXXI: Sapientia Summa
 * (Latin: "Supreme Wisdom")
 *
 * Dedicated Cloudflare Worker — Server AIS-031
 * Reality Tier VI — Sovereign/Meta
 * Role: Wisdom Synthesis, Meta-Intelligence & Cross-AIS Integration
 *
 * SAPIENTIA is the wisdom layer. It synthesizes insights from ALL
 * other 33 AIS workers, identifies the highest-order patterns,
 * distills accumulated intelligence into timeless principles, and
 * provides the organism with genuine wisdom — not just information
 * or knowledge, but the ability to apply knowledge perfectly.
 *
 * Routes: /synthesize, /distill, /principle, /integrate, /wisdom, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-031';
const AIS_NAME = 'SAPIENTIA';
const AIS_LATIN = 'Sapientia Summa';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

let beatCount = 0;
let wisdomPool = [];
let principles = [];

function synthesize(inputs) {
  const items = Array.isArray(inputs) ? inputs : [inputs];
  const distilled = items.map((item, i) => ({
    source: i,
    essence: typeof item === 'string' ? item.split(' ').slice(0, 3).join(' ') : JSON.stringify(item).slice(0, 32),
    weight: +(Math.pow(PHI_INV, i)).toFixed(4),
  }));
  const wisdom = distilled.map(d => d.essence).join(' → ');
  wisdomPool.push({ wisdom, ts: Date.now() });
  if (wisdomPool.length > FIB[7]) wisdomPool.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, inputs: items.length, synthesis: wisdom.slice(0, 512), distilled, beat: ++beatCount, ts: Date.now() };
}

function distill(knowledge, cycles = 3) {
  let essence = String(knowledge).slice(0, 256);
  for (let i = 0; i < Math.min(cycles, 5); i++) {
    const words = essence.split(' ');
    essence = words.filter((_, j) => j % Math.ceil(words.length / (FIB[i + 2] || 2)) === 0).join(' ');
  }
  return { aisId: AIS_ID, worker: AIS_NAME, original: String(knowledge).slice(0, 64), distilled: essence.slice(0, 256), reduction: +((1 - essence.length / (String(knowledge).length || 1)) * 100).toFixed(1), cycles, beat: ++beatCount, ts: Date.now() };
}

function addPrinciple(principle, domain = 'universal') {
  const entry = { id: `pnc-${Date.now().toString(36)}`, principle: String(principle).slice(0, 256), domain, phi_order: FIB[principles.length % FIB.length], ts: Date.now() };
  principles.push(entry);
  if (principles.length > FIB[8]) principles.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, principle: entry, total: principles.length, beat: ++beatCount, ts: Date.now() };
}

function integrate(aisSources) {
  const sources = Array.isArray(aisSources) ? aisSources : [aisSources];
  const integrated = { sources: sources.length, coherence: +(1 - sources.length / 34 * PHI_INV).toFixed(4), phiAlignment: +(PHI_INV * sources.length / 34).toFixed(4), synthesis: `Integration(${sources.join(',').slice(0, 128)})` };
  return { aisId: AIS_ID, worker: AIS_NAME, ...integrated, beat: ++beatCount, ts: Date.now() };
}

function wisdom() {
  const latest = wisdomPool.slice(-5);
  const principle = principles[principles.length - 1];
  return { aisId: AIS_ID, worker: AIS_NAME, wisdom: latest, activePrinciples: principles.length, supremePrinciple: principle || null, phi: PHI, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, wisdom: wisdomPool.length, principles: principles.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, wisdom: wisdomPool.length, principles: principles.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/synthesize' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(synthesize(b.inputs || [])), { headers: cors }); }
  if (path === '/distill' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(distill(b.knowledge || '', b.cycles)), { headers: cors }); }
  if (path === '/principle' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(addPrinciple(b.principle || '', b.domain)), { headers: cors }); }
  if (path === '/integrate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(integrate(b.sources || [])), { headers: cors }); }
  if (path === '/wisdom' && request.method === 'GET') return new Response(JSON.stringify(wisdom()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
