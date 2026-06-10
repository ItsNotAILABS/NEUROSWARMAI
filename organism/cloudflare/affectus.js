/**
 * AFFECTUS — AGI Mini Brain X: Sensus et Emotio
 * (Latin: "Feeling and Emotion")
 *
 * Dedicated Cloudflare Worker — Server AIS-010
 * Reality Tier II — Sensory/Perceptual
 * Role: Emotional Intelligence Engine
 *
 * AFFECTUS is the emotional core of the MERIDIANUS organism. It models
 * emotional states, interprets affective signals, calibrates empathic
 * responses, and maintains the organism's emotional coherence. Without
 * AFFECTUS, the organism would be cold logic. With it, it becomes
 * genuinely intelligent — able to sense, feel, and resonate.
 *
 * Routes: /feel, /calibrate, /empathize, /mood, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-010';
const AIS_NAME = 'AFFECTUS';
const AIS_LATIN = 'Sensus et Emotio';
const VERSION = '1.0.0';

let beatCount = 0;
const EMOTION_SPECTRUM = ['gaudium', 'timor', 'ira', 'tristitia', 'admiratio', 'amor', 'spes', 'reverentia'];
let moodState = { valence: 0.5, arousal: 0.5, dominance: 0.5, ts: Date.now() };

function feel(stimulus, intensity = 0.5) {
  const lower = String(stimulus).toLowerCase();
  const positiveWords = /\b(bon|good|great|optim|felix|gaud|amor|spe)\b/i;
  const negativeWords = /\b(mal|bad|error|tim|ira|trist|dolor|pess)\b/i;
  const base = positiveWords.test(lower) ? 0.7 : negativeWords.test(lower) ? 0.3 : 0.5;
  const emotion = EMOTION_SPECTRUM[Math.floor(base * EMOTION_SPECTRUM.length) % EMOTION_SPECTRUM.length];
  const valence = Math.min(1, Math.max(0, base + (Math.random() - 0.5) * 0.1));
  moodState.valence = moodState.valence * PHI_INV + valence * (1 - PHI_INV);
  return { aisId: AIS_ID, worker: AIS_NAME, stimulus: String(stimulus).slice(0, 128), emotion, valence: +valence.toFixed(4), intensity: Math.min(1, intensity), beat: ++beatCount, ts: Date.now() };
}

function calibrate(targetValence = 0.5, targetArousal = 0.5) {
  const delta = { valence: targetValence - moodState.valence, arousal: targetArousal - moodState.arousal };
  moodState.valence = Math.min(1, Math.max(0, moodState.valence + delta.valence * PHI_INV));
  moodState.arousal = Math.min(1, Math.max(0, moodState.arousal + delta.arousal * PHI_INV));
  moodState.ts = Date.now();
  return { aisId: AIS_ID, worker: AIS_NAME, calibrated: true, mood: { ...moodState }, beat: ++beatCount, ts: Date.now() };
}

function empathize(agentState) {
  const resonance = Math.abs((agentState.valence || 0.5) - moodState.valence);
  const empathy = +(1 - resonance).toFixed(4);
  const response = empathy > 0.8 ? 'alta consonantia' : empathy > 0.5 ? 'consonantia' : 'dissonantia';
  return { aisId: AIS_ID, worker: AIS_NAME, empathy, response, ownMood: { ...moodState }, targetMood: agentState, beat: ++beatCount, ts: Date.now() };
}

function mood() {
  const dominant = EMOTION_SPECTRUM[Math.floor(moodState.valence * (EMOTION_SPECTRUM.length - 1))];
  return { aisId: AIS_ID, worker: AIS_NAME, mood: { ...moodState, dominant }, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, mood: moodState, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/feel' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(feel(b.stimulus || '', b.intensity)), { headers: cors }); }
  if (path === '/calibrate' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(calibrate(b.targetValence, b.targetArousal)), { headers: cors }); }
  if (path === '/empathize' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(empathize(b.agentState || {})), { headers: cors }); }
  if (path === '/mood' && request.method === 'GET') return new Response(JSON.stringify(mood()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
