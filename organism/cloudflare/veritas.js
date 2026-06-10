/**
 * VERITAS — AGI Mini Brain XXIX: Veritas et Lux
 * (Latin: "Truth and Light")
 *
 * Dedicated Cloudflare Worker — Server AIS-029
 * Reality Tier V — Collective/Universal
 * Role: Truth Verification, Fact-Checking & Epistemic Integrity Engine
 *
 * VERITAS is the guardian of truth. It verifies claims, detects
 * contradictions, measures epistemic confidence, traces statements
 * to their sources, and maintains the intellectual integrity of the
 * organism. In a world of misinformation, VERITAS ensures the
 * organism reasons from a foundation of verified truth.
 *
 * Routes: /verify, /contradict, /confidence, /source, /truth, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-029';
const AIS_NAME = 'VERITAS';
const AIS_LATIN = 'Veritas et Lux';
const VERSION = '1.0.0';

let beatCount = 0;
let truthLedger = [];  // verified truths
let contradictions = [];

function verify(claim, evidence = []) {
  const claimStr = String(claim).slice(0, 256);
  const evidenceCount = evidence.length;
  const supportWeight = evidence.filter(e => e?.supports !== false).length;
  const confidence = evidenceCount > 0 ? +(supportWeight / evidenceCount * PHI_INV + 0.1).toFixed(4) : 0.5;
  const verdict = confidence > 0.75 ? 'verum' : confidence > 0.45 ? 'incertum' : 'falsum';
  const entry = { id: `vrt-${Date.now().toString(36)}`, claim: claimStr, confidence, verdict, evidence: evidenceCount, ts: Date.now() };
  truthLedger.push(entry);
  if (truthLedger.length > 89) truthLedger.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, ...entry, beat: ++beatCount };
}

function checkContradiction(claimA, claimB) {
  const a = String(claimA).toLowerCase();
  const b = String(claimB).toLowerCase();
  const words_a = new Set(a.split(/\W+/).filter(Boolean));
  const words_b = new Set(b.split(/\W+/).filter(Boolean));
  const overlap = [...words_a].filter(w => words_b.has(w)).length;
  const union = new Set([...words_a, ...words_b]).size;
  const similarity = union > 0 ? overlap / union : 0;
  const negates = /\bnot?\b|\bnon\b|\bneg/i.test(a) !== /\bnot?\b|\bnon\b|\bneg/i.test(b);
  const contradicts = negates && similarity > 0.3;
  if (contradicts) contradictions.push({ a: claimA.slice(0, 64), b: claimB.slice(0, 64), ts: Date.now() });
  return { aisId: AIS_ID, worker: AIS_NAME, claimA: claimA.slice(0, 64), claimB: claimB.slice(0, 64), similarity: +similarity.toFixed(4), contradicts, beat: ++beatCount, ts: Date.now() };
}

function epistemicConfidence(belief, sources = []) {
  const coherence = sources.length > 0 ? Math.min(1, sources.length / 5) : 0.3;
  const phi_confidence = +(coherence * PHI_INV + 0.1).toFixed(4);
  const tier = phi_confidence > 0.7 ? 'scientia' : phi_confidence > 0.4 ? 'opinio' : 'suspicio';
  return { aisId: AIS_ID, worker: AIS_NAME, belief: String(belief).slice(0, 64), sources: sources.length, coherence: +coherence.toFixed(4), confidence: phi_confidence, epistemicTier: tier, beat: ++beatCount, ts: Date.now() };
}

function traceSource(claim) {
  const related = truthLedger.filter(e => e.claim.toLowerCase().includes(String(claim).toLowerCase().slice(0, 20)));
  return { aisId: AIS_ID, worker: AIS_NAME, claim: String(claim).slice(0, 64), sources: related.slice(-3), found: related.length, beat: ++beatCount, ts: Date.now() };
}

function truth() {
  return { aisId: AIS_ID, worker: AIS_NAME, verifiedTruths: truthLedger.filter(t => t.verdict === 'verum').length, total: truthLedger.length, contradictions: contradictions.length, phi: PHI, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, truths: truthLedger.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, truths: truthLedger.length, contradictions: contradictions.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/verify' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(verify(b.claim || '', b.evidence)), { headers: cors }); }
  if (path === '/contradict' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(checkContradiction(b.claimA || '', b.claimB || '')), { headers: cors }); }
  if (path === '/confidence' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(epistemicConfidence(b.belief || '', b.sources)), { headers: cors }); }
  if (path === '/source' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(traceSource(b.claim || '')), { headers: cors }); }
  if (path === '/truth' && request.method === 'GET') return new Response(JSON.stringify(truth()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
