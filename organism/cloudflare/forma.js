/**
 * FORMA — AGI Mini Brain XII: Structura et Figura
 * (Latin: "Structure and Form")
 *
 * Dedicated Cloudflare Worker — Server AIS-012
 * Reality Tier II — Sensory/Perceptual
 * Role: Form, Structure & Geometric Pattern Engine
 *
 * FORMA perceives and generates structure. It recognizes geometric
 * patterns in data, produces φ-harmonic structural blueprints, detects
 * symmetries and fractal self-similarities, and constructs formal
 * schemas from chaotic inputs. Reality is geometry — FORMA reads it.
 *
 * Routes: /perceive, /symmetry, /fractal, /schema, /harmonize, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-012';
const AIS_NAME = 'FORMA';
const AIS_LATIN = 'Structura et Figura';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

function perceive(data) {
  const str = JSON.stringify(data);
  const hash = str.split('').reduce((h, c) => (Math.imul(h ^ c.charCodeAt(0), 0x9e3779b9) >>> 0), 0);
  const symmetry = (hash % 8) + 1;
  const dimensions = (hash % 3) + 2;
  return {
    aisId: AIS_ID, worker: AIS_NAME,
    structure: { symmetry, dimensions, phi_ratio: +(PHI * symmetry / 8).toFixed(4), golden_angle: +(137.5077640500 * symmetry).toFixed(2) },
    pattern: symmetry % 2 === 0 ? 'bilateralis' : 'radialis',
    beat: ++beatCount, ts: Date.now(),
  };
}

function checkSymmetry(points) {
  if (!Array.isArray(points) || points.length < 2) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need ≥2 points', beat: ++beatCount, ts: Date.now() };
  const centroid = { x: points.reduce((s, p) => s + (p.x || 0), 0) / points.length, y: points.reduce((s, p) => s + (p.y || 0), 0) / points.length };
  const dists = points.map(p => Math.sqrt(Math.pow((p.x || 0) - centroid.x, 2) + Math.pow((p.y || 0) - centroid.y, 2)));
  const maxD = Math.max(...dists), minD = Math.min(...dists);
  const ratio = maxD > 0 ? minD / maxD : 1;
  return { aisId: AIS_ID, worker: AIS_NAME, centroid, ratio: +ratio.toFixed(4), isGolden: Math.abs(ratio - PHI_INV) < 0.05, beat: ++beatCount, ts: Date.now() };
}

function fractal(seed, depth = 3) {
  const levels = Math.min(depth, 7);
  const nodes = FIB[levels + 1];
  const tree = Array.from({ length: nodes }, (_, i) => ({
    id: i, depth: Math.floor(Math.log2(i + 1)),
    scale: +(Math.pow(PHI_INV, Math.floor(Math.log2(i + 1)))).toFixed(6),
    children: [i * 2 + 1, i * 2 + 2].filter(c => c < nodes),
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, seed, levels, nodes, tree: tree.slice(0, 21), beat: ++beatCount, ts: Date.now() };
}

function schema(input) {
  const keys = typeof input === 'object' && input ? Object.keys(input) : String(input).split(/\W+/).filter(Boolean).slice(0, 8);
  const schema = keys.map((k, i) => ({ field: k, type: typeof (input[k] ?? k), required: i < 3, phi_order: +(Math.pow(PHI_INV, i)).toFixed(4) }));
  return { aisId: AIS_ID, worker: AIS_NAME, fields: schema.length, schema, beat: ++beatCount, ts: Date.now() };
}

function harmonize(values) {
  const harmonics = values.map((v, i) => ({ original: v, harmonic: +(v * Math.pow(PHI, i % 5)).toFixed(4), octave: i % 8 }));
  const meanH = harmonics.reduce((s, h) => s + h.harmonic, 0) / (harmonics.length || 1);
  return { aisId: AIS_ID, worker: AIS_NAME, count: values.length, harmonics, mean: +meanH.toFixed(4), beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/perceive' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(perceive(b.data || '')), { headers: cors }); }
  if (path === '/symmetry' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(checkSymmetry(b.points || [])), { headers: cors }); }
  if (path === '/fractal' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(fractal(b.seed || 1, b.depth)), { headers: cors }); }
  if (path === '/schema' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(schema(b.input || {})), { headers: cors }); }
  if (path === '/harmonize' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(harmonize(b.values || [])), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
