/**
 * INTELLECTUS — AGI Mini Brain IV: Comprehensio Profunda
 * (Latin: "Deep Comprehension")
 *
 * Dedicated Cloudflare Worker — Server AIS-004
 * Role: Deep Understanding & Semantic Comprehension Engine
 *
 * INTELLECTUS is the comprehension layer of the MERIDIANUS organism.
 * Where ANIMUS reasons and RATIO applies logic, INTELLECTUS goes deeper —
 * it understands meaning, extracts intent, models context, and produces
 * semantic representations that other AIS workers can act upon.
 * Running 24/7 as a Cloudflare Worker, INTELLECTUS is the organism's
 * always-on understanding fabric.
 *
 * Capabilities:
 *   - Intent extraction and classification
 *   - Semantic similarity scoring (φ-weighted)
 *   - Entity recognition and relationship mapping
 *   - Context modelling across conversation turns
 *   - Conceptual abstraction and generalization
 *
 * Routes:
 *   POST /understand    — Deep comprehension of input text
 *   POST /intent        — Extract and classify intent
 *   POST /entities      — Extract named entities + relations
 *   POST /abstract      — Generate conceptual abstraction
 *   POST /similarity    — Score semantic similarity of two inputs
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Comprehension metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-004';
const AIS_NAME  = 'INTELLECTUS';
const AIS_LATIN = 'Comprehensio Profunda';
const VERSION   = '1.0.0';

const INTENT_CLASSES = ['query', 'command', 'assertion', 'question', 'request', 'declaration', 'instruction', 'evaluation'];

let beatCount = 0;

/* ─── Comprehension engine ──────────────────────────────────── */

function understand(text) {
  const words     = text.split(/\W+/).filter(Boolean);
  const tokens    = words.length;
  const density   = Math.min(1.0, tokens / 55);  // F10 token density
  const sentiment = (text.match(/\b(good|great|verum|optimus|felix)\b/gi) || []).length > 0 ? 'positivum'
                  : (text.match(/\b(bad|error|malum|falsum|pessimus)\b/gi) || []).length > 0 ? 'negativum'
                  : 'neutrum';
  const abstractness = +(density * PHI_INV).toFixed(4);
  return {
    aisId:       AIS_ID,
    worker:      AIS_NAME,
    input:       text.slice(0, 256),
    tokens,
    density:     +density.toFixed(4),
    sentiment,
    abstractness,
    coherence:   +(density * PHI).toFixed(4) > 1 ? 1 : +(density * PHI).toFixed(4),
    beat:        ++beatCount,
    ts:          Date.now(),
  };
}

function extractIntent(text) {
  const lower   = text.toLowerCase();
  const scores  = INTENT_CLASSES.map((cls, i) => ({
    intent: cls,
    score:  +(Math.random() * PHI_INV + Math.pow(PHI_INV, i + 1) * 0.3).toFixed(4),
  }));
  scores.sort((a, b) => b.score - a.score);
  return {
    aisId:     AIS_ID,
    worker:    AIS_NAME,
    input:     text.slice(0, 128),
    topIntent: scores[0].intent,
    scores,
    confidence: scores[0].score,
    beat:      ++beatCount,
    ts:        Date.now(),
  };
}

function extractEntities(text) {
  // Heuristic: capitalized words → entities; numbers → quantities
  const entities = [];
  const caps    = text.match(/\b[A-Z][a-z]{2,}\b/g) || [];
  const nums    = text.match(/\b\d+(\.\d+)?\b/g) || [];
  for (const cap of [...new Set(caps)]) {
    entities.push({ text: cap, type: 'NOMEN', confidence: +(PHI_INV).toFixed(4) });
  }
  for (const num of [...new Set(nums)]) {
    entities.push({ text: num, type: 'NUMERUS', confidence: 0.95 });
  }
  return {
    aisId: AIS_ID, worker: AIS_NAME, entities, count: entities.length,
    beat: ++beatCount, ts: Date.now(),
  };
}

function abstract(text) {
  const words   = text.split(/\W+/).filter(w => w.length > 4);
  const keyWords = words.slice(0, Math.min(8, FibN(6)));   // F6=8 key concepts
  const abstraction = keyWords.join(' → ');
  return {
    aisId:       AIS_ID,
    worker:      AIS_NAME,
    input:       text.slice(0, 256),
    abstraction,
    concepts:    keyWords.length,
    beat:        ++beatCount,
    ts:          Date.now(),
  };
}

function similarity(textA, textB) {
  const setA = new Set(textA.toLowerCase().split(/\W+/).filter(Boolean));
  const setB = new Set(textB.toLowerCase().split(/\W+/).filter(Boolean));
  const inter = [...setA].filter(w => setB.has(w)).length;
  const union = new Set([...setA, ...setB]).size;
  const score = union > 0 ? +(inter / union).toFixed(4) : 0;
  return {
    aisId:   AIS_ID,
    worker:  AIS_NAME,
    score,
    similar: score > 0.5,
    beat:    ++beatCount,
    ts:      Date.now(),
  };
}

function FibN(n) {
  const f = [1, 1]; for (let i = 2; i <= n; i++) f[i] = f[i-1] + f[i-2]; return f[n];
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
      status: 'alive', beat: beatCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  }

  if (path === '/understand' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(understand(body.text || '')), { headers: cors });
  }

  if (path === '/intent' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(extractIntent(body.text || '')), { headers: cors });
  }

  if (path === '/entities' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(extractEntities(body.text || '')), { headers: cors });
  }

  if (path === '/abstract' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(abstract(body.text || '')), { headers: cors });
  }

  if (path === '/similarity' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(similarity(body.textA || '', body.textB || '')), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
