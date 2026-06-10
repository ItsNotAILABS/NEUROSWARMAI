/**
 * CORPUS — AGI Mini Brain XIII: Materia et Mundus
 * (Latin: "Matter and World")
 *
 * Dedicated Cloudflare Worker — Server AIS-013
 * Reality Tier II — Sensory/Perceptual
 * Role: Physical Reality Interface, Material World Sensor
 *
 * CORPUS bridges the AGI organism to physical reality. It models
 * physical constraints, resource states, environmental conditions,
 * and material parameters. CORPUS grounds the abstract intelligence
 * of the organism in physical reality — ensuring decisions account
 * for energy, latency, bandwidth, hardware, and thermodynamics.
 *
 * Routes: /sense, /model, /constrain, /resource, /environment, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-013';
const AIS_NAME = 'CORPUS';
const AIS_LATIN = 'Materia et Mundus';
const VERSION = '1.0.0';

let beatCount = 0;
let environment = { cpu: 0.3, memory: 0.5, bandwidth: 0.8, latency: 45, temperature: 22, energy: 0.9, ts: Date.now() };

function sense(metrics = {}) {
  if (metrics.cpu !== undefined) environment.cpu = Math.min(1, Math.max(0, metrics.cpu));
  if (metrics.memory !== undefined) environment.memory = Math.min(1, Math.max(0, metrics.memory));
  if (metrics.bandwidth !== undefined) environment.bandwidth = Math.min(1, Math.max(0, metrics.bandwidth));
  if (metrics.latency !== undefined) environment.latency = Math.max(0, metrics.latency);
  environment.ts = Date.now();
  const health = (environment.cpu < 0.8 && environment.memory < 0.9 && environment.bandwidth > 0.2) ? 'sanus' : 'aegrotus';
  return { aisId: AIS_ID, worker: AIS_NAME, environment: { ...environment }, health, beat: ++beatCount, ts: Date.now() };
}

function model(system) {
  const name = String(system).slice(0, 64);
  const phiModel = {
    name,
    capacity: +(Math.random() * PHI).toFixed(4),
    efficiency: +(PHI_INV + Math.random() * 0.2).toFixed(4),
    entropy: +(Math.random() * PHI_INV).toFixed(4),
    resilience: +(0.5 + Math.random() * 0.5).toFixed(4),
    phi_harmonic: +PHI.toFixed(6),
  };
  return { aisId: AIS_ID, worker: AIS_NAME, model: phiModel, beat: ++beatCount, ts: Date.now() };
}

function constrain(action, limits = {}) {
  const checks = {
    cpu: (limits.maxCpu || 0.9) >= environment.cpu,
    memory: (limits.maxMemory || 0.9) >= environment.memory,
    latency: (limits.maxLatency || 1000) >= environment.latency,
    energy: (limits.minEnergy || 0.1) <= environment.energy,
  };
  const feasible = Object.values(checks).every(Boolean);
  return { aisId: AIS_ID, worker: AIS_NAME, action: String(action).slice(0, 64), checks, feasible, environment: { ...environment }, beat: ++beatCount, ts: Date.now() };
}

function resource(type = 'all') {
  const resources = {
    cpu: { used: environment.cpu, free: +(1 - environment.cpu).toFixed(4), unit: 'ratio' },
    memory: { used: environment.memory, free: +(1 - environment.memory).toFixed(4), unit: 'ratio' },
    bandwidth: { used: +(1 - environment.bandwidth).toFixed(4), free: environment.bandwidth, unit: 'ratio' },
    energy: { used: +(1 - environment.energy).toFixed(4), free: environment.energy, unit: 'ratio' },
  };
  return { aisId: AIS_ID, worker: AIS_NAME, resources: type === 'all' ? resources : { [type]: resources[type] || null }, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, environment, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, environment, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/sense' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(sense(b.metrics || {})), { headers: cors }); }
  if (path === '/model' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(model(b.system || '')), { headers: cors }); }
  if (path === '/constrain' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(constrain(b.action || '', b.limits)), { headers: cors }); }
  if (path === '/resource' && request.method === 'GET') return new Response(JSON.stringify(resource(url.searchParams.get('type') || 'all')), { headers: cors });
  if (path === '/environment' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, environment, beat: ++beatCount, ts: Date.now() }), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
