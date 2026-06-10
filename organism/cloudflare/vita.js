/**
 * VITA — AGI Mini Brain XXVI: Systema Biologicum
 * (Latin: "Biological System")
 *
 * Dedicated Cloudflare Worker — Server AIS-026
 * Reality Tier V — Collective/Universal
 * Role: Biological Pattern Intelligence, Life Systems & Organic Optimization
 *
 * VITA applies the wisdom of biological evolution to AI intelligence.
 * It models life cycles, applies genetic algorithm principles, detects
 * organic growth patterns, and ensures the organism evolves, adapts,
 * and thrives like a living system. Intelligence is alive — VITA
 * ensures it stays that way.
 *
 * Routes: /evolve, /adapt, /lifecycle, /fitness, /mutate, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-026';
const AIS_NAME = 'VITA';
const AIS_LATIN = 'Systema Biologicum';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];
const LIFE_PHASES = ['nascetur', 'crescit', 'maturatur', 'florens', 'senesces', 'renascitur'];

let beatCount = 0;
let population = [];

function evolve(generation, selectionPressure = 0.5) {
  const popSize = FIB[6];
  const survivors = Math.ceil(popSize * (1 - selectionPressure * PHI_INV));
  const offspring = popSize - survivors;
  const nextGen = { generation: generation + 1, survivors, offspring, mutationRate: +(selectionPressure * PHI_INV * 0.1).toFixed(4), diversityIndex: +(1 - selectionPressure).toFixed(4), phiAdaptation: +(PHI_INV * (1 + generation / 100)).toFixed(6) };
  population.push(nextGen);
  if (population.length > 55) population.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, ...nextGen, beat: ++beatCount, ts: Date.now() };
}

function adapt(organism, environment) {
  const env = typeof environment === 'object' && environment ? environment : { pressure: 0.5 };
  const pressure = env.pressure || 0.5;
  const adaptations = ['thicker_membrane', 'faster_processing', 'redundant_pathways', 'energy_conservation', 'signal_amplification'].slice(0, Math.ceil(pressure * 5));
  return { aisId: AIS_ID, worker: AIS_NAME, organism: String(organism).slice(0, 64), pressure: +pressure.toFixed(4), adaptations, fitness: +(1 - pressure * PHI_INV * 0.5).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function lifecycle(entity, currentPhase) {
  const phaseIdx = LIFE_PHASES.indexOf(currentPhase);
  const idx = phaseIdx >= 0 ? phaseIdx : 0;
  const next = LIFE_PHASES[(idx + 1) % LIFE_PHASES.length];
  const energy = +(Math.sin((idx / LIFE_PHASES.length) * Math.PI) * PHI_INV + 0.2).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, entity: String(entity).slice(0, 64), currentPhase: LIFE_PHASES[idx], nextPhase: next, phaseProgress: +((idx + 1) / LIFE_PHASES.length).toFixed(4), energy, beat: ++beatCount, ts: Date.now() };
}

function fitness(genome, environment = {}) {
  const str = JSON.stringify({ genome, environment });
  const hash = str.split('').reduce((h, c) => (h * 31 + c.charCodeAt(0)) & 0xfff, 0);
  const score = +(hash / 0xfff * PHI_INV + 0.1).toFixed(4);
  const viable = score > 0.3;
  return { aisId: AIS_ID, worker: AIS_NAME, genome: JSON.stringify(genome).slice(0, 32), score, viable, rank: score > 0.7 ? 'elitus' : score > 0.4 ? 'vigens' : 'fragilis', beat: ++beatCount, ts: Date.now() };
}

function mutate(sequence, rate = 0.05) {
  const s = String(sequence);
  const mutated = s.split('').map(c => Math.random() < rate ? String.fromCharCode(c.charCodeAt(0) + 1) : c).join('');
  const changes = s.split('').filter((c, i) => c !== mutated[i]).length;
  return { aisId: AIS_ID, worker: AIS_NAME, original: s.slice(0, 64), mutated: mutated.slice(0, 64), changes, rate: +rate.toFixed(4), beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, generations: population.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, generations: population.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/evolve' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(evolve(b.generation || 0, b.selectionPressure)), { headers: cors }); }
  if (path === '/adapt' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(adapt(b.organism || '', b.environment)), { headers: cors }); }
  if (path === '/lifecycle' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(lifecycle(b.entity || '', b.currentPhase || 'nascetur')), { headers: cors }); }
  if (path === '/fitness' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(fitness(b.genome || {}, b.environment)), { headers: cors }); }
  if (path === '/mutate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(mutate(b.sequence || '', b.rate)), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
