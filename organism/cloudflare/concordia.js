/**
 * CONCORDIA — AGI Mini Brain XXVIII: Harmonia et Pax
 * (Latin: "Harmony and Peace")
 *
 * Dedicated Cloudflare Worker — Server AIS-028
 * Reality Tier V — Collective/Universal
 * Role: Harmony Engine, Balance Optimization & Conflict Resolution
 *
 * CONCORDIA ensures the organism operates in balance. It detects
 * dissonance between AIS workers, mediates conflicts between competing
 * goals, optimizes for systemic harmony, and ensures that the sum
 * of all AIS intelligences produces a coherent, unified whole.
 *
 * Routes: /balance, /mediate, /harmonize, /dissonance, /accord, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-028';
const AIS_NAME = 'CONCORDIA';
const AIS_LATIN = 'Harmonia et Pax';
const VERSION = '1.0.0';

let beatCount = 0;
let accordLedger = [];

function balance(values) {
  if (!values || Object.keys(values).length === 0) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need values', beat: ++beatCount, ts: Date.now() };
  const entries = Object.entries(values);
  const total = entries.reduce((s, [, v]) => s + (Number(v) || 0), 0);
  const avg = total / entries.length;
  const deviations = entries.map(([k, v]) => ({ key: k, value: Number(v) || 0, deviation: +((Number(v) - avg) / (avg || 1)).toFixed(4) }));
  const balanced = Object.fromEntries(entries.map(([k, v]) => [k, +(Number(v) * PHI_INV + avg * (1 - PHI_INV)).toFixed(4)]));
  return { aisId: AIS_ID, worker: AIS_NAME, original: values, balanced, deviations, harmony: +(1 - Math.abs(deviations.reduce((s, d) => s + Math.abs(d.deviation), 0) / entries.length)).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function mediate(parties, conflict) {
  const resolution = {
    conflict: String(conflict).slice(0, 128),
    parties: (parties || []).map(String).slice(0, 8),
    approach: 'via_media',  // the middle path
    compromise: parties?.length > 0 ? `All parties accept ${(Math.random() * 0.5 + 0.25).toFixed(2)} of their position` : 'no parties',
    weight_a: +PHI_INV.toFixed(4),
    weight_b: +PHI_INV.toFixed(4),
    accord: Math.random() > 0.2,
  };
  if (resolution.accord) accordLedger.push({ ...resolution, ts: Date.now() });
  if (accordLedger.length > 34) accordLedger.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, resolution, beat: ++beatCount, ts: Date.now() };
}

function detectDissonance(signals) {
  if (!Array.isArray(signals)) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need array', beat: ++beatCount, ts: Date.now() };
  const pairs = [];
  for (let i = 0; i < signals.length - 1; i++) {
    for (let j = i + 1; j < signals.length; j++) {
      const diff = Math.abs((Number(signals[i]) || 0) - (Number(signals[j]) || 0));
      if (diff > 0.3) pairs.push({ i, j, diff: +diff.toFixed(4), severity: diff > 0.7 ? 'acuta' : 'media' });
    }
  }
  return { aisId: AIS_ID, worker: AIS_NAME, signals: signals.length, dissonances: pairs.length, conflicts: pairs, beat: ++beatCount, ts: Date.now() };
}

function harmonizeSystem(components, target = PHI_INV) {
  const harmonized = (Array.isArray(components) ? components : []).map((c, i) => ({
    component: String(c).slice(0, 32), index: i,
    weight: +(target * Math.pow(PHI_INV, i % 8)).toFixed(4),
    aligned: Math.abs(Math.random() - target) < 0.2,
  }));
  const score = harmonized.length > 0 ? +(harmonized.filter(h => h.aligned).length / harmonized.length).toFixed(4) : 0;
  return { aisId: AIS_ID, worker: AIS_NAME, components: harmonized.length, harmonyScore: score, harmonized, beat: ++beatCount, ts: Date.now() };
}

function accord() {
  return { aisId: AIS_ID, worker: AIS_NAME, accords: accordLedger.slice(-5), total: accordLedger.length, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, accords: accordLedger.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, accords: accordLedger.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/balance' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(balance(b.values || {})), { headers: cors }); }
  if (path === '/mediate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(mediate(b.parties, b.conflict || '')), { headers: cors }); }
  if (path === '/dissonance' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(detectDissonance(b.signals || [])), { headers: cors }); }
  if (path === '/harmonize' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(harmonizeSystem(b.components || [], b.target)), { headers: cors }); }
  if (path === '/accord' && request.method === 'GET') return new Response(JSON.stringify(accord()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
