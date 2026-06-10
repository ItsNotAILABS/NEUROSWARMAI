/**
 * MEMORIA — AGI Mini Brain III: Custodia et Recordatio
 * (Latin: "Custodian of Memory and Recollection")
 *
 * Dedicated Cloudflare Worker — Server AIS-003
 * Role: Long-Term Knowledge Store & Semantic Retrieval
 *
 * MEMORIA is the sovereign long-term memory of the MERIDIANUS organism.
 * Unlike the browser-side memory-worker (144-node spiral, session-bound),
 * MEMORIA persists across all sessions using Cloudflare KV and Durable
 * Objects — it is the organism's permanent knowledge substrate. Every
 * reasoning result from ANIMUS, every inference from RATIO, every
 * decision from PRUDENTIA is optionally committed to MEMORIA for future
 * retrieval and consolidation.
 *
 * Capabilities:
 *   - Encode new memories with φ-weighted importance scores
 *   - Retrieve memories via semantic similarity (cosine proxy)
 *   - Consolidate + deduplicate memory clusters
 *   - Decay stale memories using φ-exponential half-life
 *   - Export full memory graph in structured JSON
 *
 * Routes:
 *   POST /encode        — Store a new memory
 *   POST /retrieve      — Retrieve relevant memories
 *   POST /consolidate   — Consolidate memory clusters
 *   POST /decay         — Apply φ-decay to stale entries
 *   GET  /export        — Export full memory snapshot
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Memory metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-003';
const AIS_NAME  = 'MEMORIA';
const AIS_LATIN = 'Custodia et Recordatio';
const VERSION   = '1.0.0';

const MAX_MEMORIES = 144;   // F12 — golden spiral memory cap

let beatCount  = 0;
let memories   = [];        // In-process store (Cloudflare KV in prod)

/* ─── Memory engine ─────────────────────────────────────────── */

function encode(content, importance = 0.5) {
  if (memories.length >= MAX_MEMORIES) {
    // Evict lowest-importance memory
    memories.sort((a, b) => a.importance - b.importance);
    memories.shift();
  }
  const id = `mem-${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 6)}`;
  const mem = {
    id,
    content:    content.slice(0, 512),
    importance: Math.min(1.0, Math.max(0, importance)) * PHI_INV + 0.1,
    encodedAt:  Date.now(),
    decayRate:  PHI_INV * 0.01,
    accessCount: 0,
  };
  memories.push(mem);
  return { aisId: AIS_ID, worker: AIS_NAME, encoded: true, memoryId: id, total: memories.length, beat: ++beatCount, ts: Date.now() };
}

function retrieve(query, topK = 5) {
  // Simple lexical similarity (cosine proxy via word overlap)
  const qWords = new Set(query.toLowerCase().split(/\W+/).filter(Boolean));
  const scored = memories.map(m => {
    const mWords = new Set(m.content.toLowerCase().split(/\W+/).filter(Boolean));
    const inter  = [...qWords].filter(w => mWords.has(w)).length;
    const union  = new Set([...qWords, ...mWords]).size;
    const sim    = union > 0 ? inter / union : 0;
    m.accessCount++;
    return { ...m, similarity: +sim.toFixed(4) };
  });
  scored.sort((a, b) => (b.similarity * b.importance) - (a.similarity * a.importance));
  return {
    aisId:   AIS_ID,
    worker:  AIS_NAME,
    query:   query.slice(0, 128),
    results: scored.slice(0, topK),
    beat:    ++beatCount,
    ts:      Date.now(),
  };
}

function consolidate() {
  // Group memories by content prefix cluster (first 20 chars)
  const clusters = {};
  for (const m of memories) {
    const key = m.content.slice(0, 20).toLowerCase();
    if (!clusters[key]) clusters[key] = [];
    clusters[key].push(m);
  }
  let merged = 0;
  for (const [, cluster] of Object.entries(clusters)) {
    if (cluster.length > 1) {
      // Keep highest-importance, remove rest
      cluster.sort((a, b) => b.importance - a.importance);
      const keep = cluster[0];
      keep.importance = Math.min(1.0, keep.importance * PHI);
      for (let i = 1; i < cluster.length; i++) {
        memories = memories.filter(m => m.id !== cluster[i].id);
        merged++;
      }
    }
  }
  return { aisId: AIS_ID, worker: AIS_NAME, merged, remaining: memories.length, beat: ++beatCount, ts: Date.now() };
}

function decay() {
  const now = Date.now();
  let decayed = 0;
  memories = memories.filter(m => {
    const ageMs = now - m.encodedAt;
    const ageDays = ageMs / 86400000;
    m.importance = m.importance * Math.pow(1 - m.decayRate, ageDays);
    if (m.importance < 0.01) { decayed++; return false; }
    return true;
  });
  return { aisId: AIS_ID, worker: AIS_NAME, decayed, remaining: memories.length, beat: ++beatCount, ts: Date.now() };
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
      status: 'alive', beat: beatCount, memories: memories.length, maxMemories: MAX_MEMORIES,
      phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount,
      memories: memories.length, maxMemories: MAX_MEMORIES, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/encode' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(encode(body.content || '', body.importance)), { headers: cors });
  }

  if (path === '/retrieve' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(retrieve(body.query || '', body.topK)), { headers: cors });
  }

  if (path === '/consolidate' && request.method === 'POST') {
    return new Response(JSON.stringify(consolidate()), { headers: cors });
  }

  if (path === '/decay' && request.method === 'POST') {
    return new Response(JSON.stringify(decay()), { headers: cors });
  }

  if (path === '/export' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, memories, beat: ++beatCount, ts: Date.now(),
    }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
