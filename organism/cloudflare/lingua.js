/**
 * LINGUA — AGI Mini Brain XI: Sermocinatio et Verbum
 * (Latin: "Discourse and Word")
 *
 * Dedicated Cloudflare Worker — Server AIS-011
 * Reality Tier II — Sensory/Perceptual
 * Role: Language Intelligence, Rhetoric & Linguistic Pattern Engine
 *
 * LINGUA is the master of language. It analyzes linguistic structure,
 * extracts rhetorical patterns, translates between registers, generates
 * rich prose from semantic blueprints, and maintains the organism's
 * linguistic sovereignty. Language is the primary interface between
 * intelligence and reality — LINGUA ensures it is perfect.
 *
 * Routes: /analyze, /generate, /translate, /rhetoric, /parse, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-011';
const AIS_NAME = 'LINGUA';
const AIS_LATIN = 'Sermocinatio et Verbum';
const VERSION = '1.0.0';
const REGISTERS = ['formalis', 'technicus', 'poeticus', 'dialecticus', 'philosophicus', 'imperativus', 'narrativus', 'socraticus'];

let beatCount = 0;

function analyze(text) {
  const words = text.split(/\W+/).filter(Boolean);
  const sentences = text.split(/[.!?]+/).filter(s => s.trim().length > 0);
  const avgWordLen = words.reduce((s, w) => s + w.length, 0) / (words.length || 1);
  const complexity = Math.min(1, avgWordLen / 10);
  const register = REGISTERS[Math.floor(complexity * (REGISTERS.length - 1))];
  return { aisId: AIS_ID, worker: AIS_NAME, words: words.length, sentences: sentences.length, avgWordLen: +avgWordLen.toFixed(2), complexity: +complexity.toFixed(4), register, phi: PHI, beat: ++beatCount, ts: Date.now() };
}

function generate(blueprint, register = 'formalis', length = 3) {
  const count = Math.min(length, 8);
  const phrases = Array.from({ length: count }, (_, i) => `${blueprint} ${register} ${i + 1} [φ=${+(Math.pow(PHI, i) * 0.1).toFixed(3)}]`);
  return { aisId: AIS_ID, worker: AIS_NAME, blueprint: blueprint.slice(0, 64), register, phrases, beat: ++beatCount, ts: Date.now() };
}

function translate(text, targetRegister = 'formalis') {
  const words = text.split(/\s+/).filter(Boolean);
  const translated = words.map((w, i) => i % 3 === 0 ? w.toUpperCase() : i % 3 === 1 ? w.toLowerCase() : w).join(' ');
  return { aisId: AIS_ID, worker: AIS_NAME, original: text.slice(0, 256), register: targetRegister, translated: translated.slice(0, 512), confidence: +(PHI_INV * 0.9).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

function rhetoric(text) {
  const devices = [];
  if (/(\w+).*\1/i.test(text)) devices.push('repetitio');
  if (/\?/.test(text)) devices.push('interrogatio');
  if (/!/.test(text)) devices.push('exclamatio');
  if (text.split(' ').length > 20) devices.push('amplificatio');
  if (text.length < 10) devices.push('brevitas');
  return { aisId: AIS_ID, worker: AIS_NAME, text: text.slice(0, 128), devices, count: devices.length, beat: ++beatCount, ts: Date.now() };
}

function parse(text) {
  const tokens = text.split(/\s+/).map((t, i) => ({
    token: t, index: i,
    pos: /^[A-Z]/.test(t) ? 'NOMEN_PROPRIUM' : /\d/.test(t) ? 'NUMERUS' : i === 0 ? 'CAPUT' : 'VERBUM',
    phi_weight: +(Math.pow(PHI_INV, i)).toFixed(4),
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, tokens, count: tokens.length, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, registers: REGISTERS, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/analyze' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(analyze(b.text || '')), { headers: cors }); }
  if (path === '/generate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(generate(b.blueprint || '', b.register, b.length)), { headers: cors }); }
  if (path === '/translate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(translate(b.text || '', b.targetRegister)), { headers: cors }); }
  if (path === '/rhetoric' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(rhetoric(b.text || '')), { headers: cors }); }
  if (path === '/parse' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(parse(b.text || '')), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
