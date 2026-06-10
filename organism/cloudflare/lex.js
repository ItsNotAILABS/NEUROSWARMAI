/**
 * LEX — AGI Mini Brain 044: Lex et Justitia
 *
 * Dedicated Cloudflare Worker — Server AIS-044
 * Role: Law & Policy Engine
 *
 * This worker implements Law & Policy Engine capabilities using PHI golden-ratio
 * mathematics and Fibonacci-sequence patterns for deterministic, bias-free
 * computation across all domain operations.
 *
 * Capabilities:
 *   - PHI-weighted domain scoring and optimization
 *   - Fibonacci-indexed priority and sequencing
 *   - Golden-ratio confidence and quality metrics
 *   - Autonomous computation with no external dependencies
 *   - RESTful JSON API with CORS support
 *
 * Routes:
 *   POST /policy             — Score policy compliance using PHI weighting
 *   POST /judge              — Produce judgment confidence with FIB precedents
 *   POST /comply             — Calculate compliance level using PHI ratios
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-044';
const AIS_NAME  = 'LEX';
const AIS_LATIN = 'Lex et Justitia';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scorePolicyCompliance(checks, passing, weight) {
  const phiWeight = weight * PHI;
  const fibBase = FIB[Math.min(checks, FIB.length - 1)];
  const ratio = passing / (checks || 1);
  const score = ratio * phiWeight * fibBase;
  return { checks, passing, ratio, phiWeight, fibBase, score, compliant: ratio >= PHI_INV };
}

function judgeWithPrecedents(caseStrength, precedents, bias) {
  const fibPrecedents = precedents.reduce((a, v, i) => a + v * (FIB[i % FIB.length] || 1), 0);
  const phiBias = bias * PHI;
  const confidence = (caseStrength * PHI + fibPrecedents) / (phiBias || 1);
  const verdict = confidence > PHI ? 'affirm' : confidence < 1 ? 'deny' : 'partial';
  return { caseStrength, fibPrecedents, phiBias, confidence, verdict };
}

function calculateCompliance(rules, satisfied, threshold) {
  const fibThreshold = FIB[Math.min(Math.floor(threshold * 10), FIB.length - 1)];
  const phiSatisfied = satisfied * PHI;
  const level = phiSatisfied / (rules || 1);
  const compliant = level >= fibThreshold * PHI_INV;
  return { rules, satisfied, threshold, phiSatisfied, fibThreshold, level, compliant };
}

/* ─── Router ────────────────────────────────────────────────── */

async function handleRequest(request) {
  beatCount++;
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-AIS-ID': AIS_ID,
    'X-AIS-Name': AIS_NAME,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount,
      phi: PHI, fibDepths: FIB, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/policy' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scorePolicyCompliance(body.checks||10, body.passing||8, body.weight||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/policy', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/judge' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = judgeWithPrecedents(body.caseStrength||0.8, body.precedents||[1,1,0,1], body.bias||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/judge', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/comply' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateCompliance(body.rules||10, body.satisfied||8, body.threshold||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/comply', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
