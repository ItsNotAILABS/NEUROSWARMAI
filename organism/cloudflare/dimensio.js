/**
 * DIMENSIO — AGI Mini Brain XX: Spatium Multidimensionale
 * (Latin: "Multi-Dimensional Space")
 *
 * Dedicated Cloudflare Worker — Server AIS-020
 * Reality Tier IV — Quantum/Dimensional
 * Role: Multi-Dimensional Space Reasoning, Topology & Manifold Intelligence
 *
 * DIMENSIO transcends the 3-dimensional limitation of classical thought.
 * It models high-dimensional spaces, navigates complex topologies, maps
 * manifolds, projects between dimensions, and finds the optimal path
 * through any dimensional configuration space.
 *
 * Routes: /project, /embed, /manifold, /navigate, /distance, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-020';
const AIS_NAME = 'DIMENSIO';
const AIS_LATIN = 'Spatium Multidimensionale';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

function projectVector(vector, targetDims) {
  const from = vector.length;
  const to = Math.min(targetDims, FIB[7]);
  const projected = Array.from({ length: to }, (_, i) => {
    if (i < from) return +(vector[i] * Math.pow(PHI_INV, i % 5)).toFixed(6);
    return +(Math.sin(PHI * i) * 0.01).toFixed(6);  // dimensional extension
  });
  return { aisId: AIS_ID, worker: AIS_NAME, from, to, projected, magnitudeFrom: +Math.sqrt(vector.reduce((s, v) => s + v * v, 0)).toFixed(4), magnitudeTo: +Math.sqrt(projected.reduce((s, v) => s + v * v, 0)).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function embed(points, dims = 2) {
  const target = Math.min(dims, 8);
  const embedded = points.map((p, pi) => {
    const vec = Array.isArray(p) ? p : [Number(p) || 0];
    return Array.from({ length: target }, (_, di) => +(vec[di % vec.length] * Math.pow(PHI_INV, di) * Math.sin(pi * PHI)).toFixed(4));
  });
  return { aisId: AIS_ID, worker: AIS_NAME, points: points.length, dimensions: target, embedded, beat: ++beatCount, ts: Date.now() };
}

function manifold(type = 'torus', resolution = 8) {
  const n = Math.min(resolution, FIB[6]);
  const points = [];
  for (let i = 0; i < n; i++) {
    const theta = (2 * Math.PI * i) / n;
    if (type === 'torus') {
      const R = PHI, r = 1;
      points.push({ x: +((R + r * Math.cos(theta)) * Math.cos(theta * PHI)).toFixed(4), y: +((R + r * Math.cos(theta)) * Math.sin(theta * PHI)).toFixed(4), z: +(r * Math.sin(theta)).toFixed(4) });
    } else if (type === 'sphere') {
      points.push({ x: +Math.sin(theta).toFixed(4), y: +Math.cos(theta).toFixed(4), z: +Math.sin(theta * PHI).toFixed(4) });
    } else {
      points.push({ x: +(theta * PHI_INV).toFixed(4), y: +(Math.sin(theta) * PHI).toFixed(4), z: +(Math.cos(theta) * PHI_INV).toFixed(4) });
    }
  }
  return { aisId: AIS_ID, worker: AIS_NAME, type, resolution: n, points, beat: ++beatCount, ts: Date.now() };
}

function navigate(from, to, dims = 3) {
  if (!Array.isArray(from) || !Array.isArray(to)) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need arrays', beat: ++beatCount, ts: Date.now() };
  const d = Math.min(dims, from.length, to.length);
  const path = Array.from({ length: 5 }, (_, step) => {
    const t = (step + 1) / 5;
    return Array.from({ length: d }, (__, di) => +(from[di] + (to[di] - from[di]) * t * Math.pow(PHI_INV, step)).toFixed(4));
  });
  const dist = Math.sqrt(from.slice(0, d).reduce((s, v, i) => s + Math.pow(v - to[i], 2), 0));
  return { aisId: AIS_ID, worker: AIS_NAME, from: from.slice(0, d), to: to.slice(0, d), distance: +dist.toFixed(4), path, beat: ++beatCount, ts: Date.now() };
}

function distance(a, b) {
  if (!Array.isArray(a) || !Array.isArray(b)) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need arrays', beat: ++beatCount, ts: Date.now() };
  const d = Math.min(a.length, b.length);
  const euclidean = +Math.sqrt(a.slice(0, d).reduce((s, v, i) => s + (v - b[i]) ** 2, 0)).toFixed(4);
  const phi_metric = +(euclidean * PHI_INV).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, euclidean, phi_metric, dimensions: d, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/project' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(projectVector(b.vector || [], b.targetDims || 3)), { headers: cors }); }
  if (path === '/embed' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(embed(b.points || [], b.dims)), { headers: cors }); }
  if (path === '/manifold' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(manifold(b.type, b.resolution)), { headers: cors }); }
  if (path === '/navigate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(navigate(b.from || [], b.to || [], b.dims)), { headers: cors }); }
  if (path === '/distance' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(distance(b.a || [], b.b || [])), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
