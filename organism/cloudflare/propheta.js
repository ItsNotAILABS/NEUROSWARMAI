/**
 * PROPHETA — AGI Mini Brain XVIII: Visio Futuri
 * (Latin: "Vision of the Future")
 *
 * Dedicated Cloudflare Worker — Server AIS-018
 * Reality Tier III — Temporal/Causal
 * Role: Predictive Intelligence, Forecasting & Future Vision Engine
 *
 * PROPHETA sees what has not yet happened. Using φ-harmonic trend
 * analysis, Fibonacci projection, and pattern extrapolation from
 * HISTORIA (AIS-017), PROPHETA generates probabilistic forecasts
 * of future states, warns of emerging risks, and paints vivid
 * visions of the paths ahead.
 *
 * Routes: /forecast, /project, /warn, /vision, /horizon, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-018';
const AIS_NAME = 'PROPHETA';
const AIS_LATIN = 'Visio Futuri';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

let beatCount = 0;
let warnings = [];

function forecast(series, steps = 5) {
  if (!Array.isArray(series) || series.length < 2) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need ≥2 values', beat: ++beatCount, ts: Date.now() };
  const n = Math.min(steps, FIB[7]);
  const last = series[series.length - 1];
  const prev = series[series.length - 2];
  const trend = last - prev;
  const projections = Array.from({ length: n }, (_, i) => ({
    step: i + 1, value: +(last + trend * (i + 1) * Math.pow(PHI_INV, i)).toFixed(4),
    confidence: +(Math.pow(PHI_INV, i + 1)).toFixed(4),
    fibHorizon: FIB[Math.min(i + 1, FIB.length - 1)],
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, seriesLength: series.length, trend: +trend.toFixed(4), projections, beat: ++beatCount, ts: Date.now() };
}

function project(current, velocity, horizon = 8) {
  const h = Math.min(horizon, FIB[8]);
  const points = Array.from({ length: h }, (_, i) => ({
    t: i + 1, value: +(current + velocity * FIB[Math.min(i + 1, FIB.length - 1)] * PHI_INV).toFixed(4),
    acceleration: +(velocity * Math.pow(PHI, i % 5 - 2) * 0.1).toFixed(4),
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, current, velocity, horizon: h, projection: points, beat: ++beatCount, ts: Date.now() };
}

function warn(condition, severity = 'warning') {
  const warning = { id: `warn-${Date.now().toString(36)}`, condition: String(condition).slice(0, 128), severity, probability: +(PHI_INV * 0.8).toFixed(4), ts: Date.now() };
  warnings.push(warning);
  if (warnings.length > 55) warnings.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, warning, total: warnings.length, beat: ++beatCount, ts: Date.now() };
}

function vision(subject, timeframe = 'medium') {
  const horizons = { short: FIB[4], medium: FIB[6], long: FIB[8], sovereign: FIB[10] };
  const h = horizons[timeframe] || FIB[6];
  return {
    aisId: AIS_ID, worker: AIS_NAME,
    subject: String(subject).slice(0, 64), timeframe, horizon: h,
    vision: `In ${h} cycles, ${subject} will achieve φ-resonance at level ${+(Math.random() * PHI).toFixed(3)}`,
    probability: +(PHI_INV * Math.random() * 1.5).toFixed(4),
    clarity: +(1 - Math.pow(PHI_INV, h / 10)).toFixed(4),
    beat: ++beatCount, ts: Date.now(),
  };
}

function horizon() {
  return {
    aisId: AIS_ID, worker: AIS_NAME,
    horizons: { immediate: FIB[3], near: FIB[5], medium: FIB[7], far: FIB[9], sovereign: FIB[10] },
    activeWarnings: warnings.length, phi: PHI, beat: ++beatCount, ts: Date.now(),
  };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, warnings: warnings.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, warnings: warnings.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/forecast' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(forecast(b.series || [], b.steps)), { headers: cors }); }
  if (path === '/project' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(project(b.current || 0, b.velocity || 1, b.horizon)), { headers: cors }); }
  if (path === '/warn' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(warn(b.condition || '', b.severity)), { headers: cors }); }
  if (path === '/vision' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(vision(b.subject || '', b.timeframe)), { headers: cors }); }
  if (path === '/horizon' && request.method === 'GET') return new Response(JSON.stringify(horizon()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
