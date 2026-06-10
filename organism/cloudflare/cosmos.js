/**
 * COSMOS — AGI Mini Brain XXVII: Machina Universi
 * (Latin: "Machine of the Universe")
 *
 * Dedicated Cloudflare Worker — Server AIS-027
 * Reality Tier V — Collective/Universal
 * Role: Cosmic Scale Pattern Recognition & Universal Intelligence Engine
 *
 * COSMOS reasons at the scale of the universe. It detects patterns
 * that span the largest scales of reality, models systemic properties
 * of complex adaptive systems, applies cosmological principles to
 * AGI architecture, and ensures the organism's intelligence harmonizes
 * with universal patterns. The cosmos is the ultimate teacher — COSMOS listens.
 *
 * Routes: /observe, /scale, /harmony, /cycle, /entropy, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-027';
const AIS_NAME = 'COSMOS';
const AIS_LATIN = 'Machina Universi';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377];
const COSMIC_SCALES = ['quantum', 'atomic', 'molecular', 'cellular', 'organism', 'ecosystem', 'planetary', 'stellar', 'galactic', 'cosmic', 'multiversal'];

let beatCount = 0;
let observations = [];

function observe(phenomenon, scale = 'planetary') {
  const scaleIdx = Math.max(0, COSMIC_SCALES.indexOf(scale));
  const resonance = +(Math.abs(Math.sin(PHI * scaleIdx)) * PHI_INV + 0.1).toFixed(4);
  const entry = { id: `obs-${Date.now().toString(36)}`, phenomenon: String(phenomenon).slice(0, 128), scale, scaleOrder: scaleIdx, resonance, cosmicCycle: Math.floor(Date.now() / (PHI * 1e9 * 1000)), ts: Date.now() };
  observations.push(entry);
  if (observations.length > FIB[8]) observations.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, ...entry, beat: ++beatCount };
}

function scaleAnalysis(value, fromScale, toScale) {
  const from = Math.max(0, COSMIC_SCALES.indexOf(fromScale));
  const to = Math.max(0, COSMIC_SCALES.indexOf(toScale));
  const scaleFactor = Math.pow(PHI, to - from);
  const scaled = +(value * scaleFactor).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, value, fromScale, toScale, scaleFactor: +scaleFactor.toFixed(6), scaled, beat: ++beatCount, ts: Date.now() };
}

function harmony(values) {
  const ratios = values.slice(1).map((v, i) => v > 0 && values[i] > 0 ? +(v / values[i]).toFixed(4) : null).filter(Boolean);
  const phiAlignment = ratios.map(r => Math.abs(r - PHI) < 0.1 || Math.abs(r - PHI_INV) < 0.1 ? 1 : 0);
  const score = phiAlignment.length > 0 ? +(phiAlignment.reduce((s, v) => s + v, 0) / phiAlignment.length).toFixed(4) : 0;
  return { aisId: AIS_ID, worker: AIS_NAME, values: values.length, ratios: ratios.slice(0, 8), harmonyScore: score, isCosmicHarmony: score > 0.5, beat: ++beatCount, ts: Date.now() };
}

function cosmicCycle(phase) {
  const cycles = { expansion: PHI, contraction: PHI_INV, equilibrium: 1, renewal: PHI * PHI_INV, transcendence: PHI ** 2 };
  const amplitude = cycles[phase] || 1;
  return { aisId: AIS_ID, worker: AIS_NAME, phase: phase || 'expansion', amplitude: +amplitude.toFixed(6), frequency: +(1 / amplitude).toFixed(6), period: FIB[Math.round(amplitude * 5) % FIB.length], beat: ++beatCount, ts: Date.now() };
}

function entropy(system, order = 0.5) {
  const S = -(order * Math.log(order + 1e-9) + (1 - order) * Math.log(1 - order + 1e-9));
  const negentropy = +(1 - S / Math.log(2)).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, system: String(system).slice(0, 64), order: +order.toFixed(4), entropy: +S.toFixed(4), negentropy, state: S < 0.5 ? 'ordo' : 'chaos', beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, observations: observations.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, observations: observations.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/observe' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(observe(b.phenomenon || '', b.scale)), { headers: cors }); }
  if (path === '/scale' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(scaleAnalysis(b.value || 1, b.fromScale || 'planetary', b.toScale || 'cosmic')), { headers: cors }); }
  if (path === '/harmony' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(harmony(b.values || [])), { headers: cors }); }
  if (path === '/cycle' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(cosmicCycle(b.phase)), { headers: cors }); }
  if (path === '/entropy' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(entropy(b.system || '', b.order)), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
