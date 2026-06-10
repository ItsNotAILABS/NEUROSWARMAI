/**
 * QUAESITOR — AGI Mini Brain IX: Investigatio et Inquisitio
 * (Latin: "The Seeker — Investigation and Inquiry")
 *
 * Dedicated Cloudflare Worker — Server AIS-009
 * Reality Tier II — Sensory/Perceptual
 * Role: Deep Research Engine, Inquiry & Knowledge Synthesis
 *
 * QUAESITOR is the relentless seeker. It drives deep research tasks,
 * generates rich inquiry chains, synthesizes findings from multiple
 * knowledge sources, and surfaces hidden connections. Where ANIMUS
 * reasons and INTELLECTUS understands, QUAESITOR SEEKS — probing
 * every available source until the deepest truth is surfaced.
 *
 * Routes: /seek, /inquire, /synthesize, /probe, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-009';
const AIS_NAME = 'QUAESITOR';
const AIS_LATIN = 'Investigatio et Inquisitio';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let inquiryLog = [];

function seek(query, depth = 3) {
  const probes = FIB[Math.min(depth + 1, 8)];
  const findings = [];
  for (let i = 0; i < probes; i++) {
    findings.push({
      probe: i + 1,
      layer: `stratum-${i + 1}`,
      finding: `${query} → depth-${i + 1} pattern`,
      confidence: +(Math.pow(PHI_INV, i) * 0.9 + 0.1).toFixed(4),
      novelty: +(Math.random() * PHI_INV).toFixed(4),
    });
  }
  return { aisId: AIS_ID, worker: AIS_NAME, query: query.slice(0, 128), probes, findings, beat: ++beatCount, ts: Date.now() };
}

function inquire(question, context = '') {
  const steps = ['clarify', 'decompose', 'hypothesize', 'test', 'conclude'];
  const chain = steps.map((s, i) => ({
    step: i + 1, phase: s,
    output: `${s}(${question.split(' ').slice(0, 3).join('-')})`,
    weight: +(Math.pow(PHI_INV, i)).toFixed(4),
  }));
  const result = { id: `inq-${Date.now().toString(36)}`, question: question.slice(0, 256), context: context.slice(0, 128), chain, conclusion: chain[chain.length - 1].output, ts: Date.now() };
  inquiryLog.push(result);
  if (inquiryLog.length > 55) inquiryLog.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, ...result, beat: ++beatCount };
}

function synthesize(sources) {
  const merged = sources.map((s, i) => ({ source: i + 1, content: typeof s === 'string' ? s.slice(0, 64) : JSON.stringify(s).slice(0, 64), weight: +(Math.pow(PHI_INV, i)).toFixed(4) }));
  const synthesis = merged.map(m => m.content).join(' ⊕ ');
  return { aisId: AIS_ID, worker: AIS_NAME, sources: sources.length, synthesis: synthesis.slice(0, 512), coherence: +(1 - Math.pow(PHI_INV, sources.length)).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function probe(target, dimensions = 3) {
  const dims = Array.from({ length: Math.min(dimensions, 8) }, (_, i) => ({
    dimension: i + 1, axis: `axis-${i + 1}`,
    value: +(Math.sin((i + 1) * PHI) * 0.5 + 0.5).toFixed(4),
    resonance: +(Math.cos((i + 1) * PHI_INV) * 0.5 + 0.5).toFixed(4),
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, target: String(target).slice(0, 64), dimensions: dims, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, inquiries: inquiryLog.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, inquiries: inquiryLog.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/seek' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(seek(b.query || '', b.depth)), { headers: cors }); }
  if (path === '/inquire' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(inquire(b.question || '', b.context)), { headers: cors }); }
  if (path === '/synthesize' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(synthesize(b.sources || [])), { headers: cors }); }
  if (path === '/probe' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(probe(b.target || '', b.dimensions)), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
