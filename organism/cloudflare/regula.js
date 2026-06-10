/**
 * REGULA — AGI Mini Brain 040: Regula et Norma
 *
 * Dedicated Cloudflare Worker — Server AIS-040
 * Role: Rule Engine
 *
 * This worker implements Rule Engine capabilities using PHI golden-ratio
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
 *   POST /rule               — Score rule priority using FIB weights
 *   POST /validate           — Validate input against PHI-weighted rule set
 *   POST /enforce            — Enforce rule with PHI confidence scoring
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-040';
const AIS_NAME  = 'REGULA';
const AIS_LATIN = 'Regula et Norma';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreRulePriority(ruleId, severity, frequency) {
  const fibSeverity = FIB[Math.min(severity, FIB.length - 1)];
  const phiFreq = frequency * PHI;
  const priority = fibSeverity * phiFreq;
  return { ruleId, fibSeverity, phiFreq, priority, tier: Math.ceil(priority / 10) };
}

function validateInput(value, min, max, rules) {
  const inRange = value >= min && value <= max;
  const phiMid = (min + max) * PHI_INV;
  const fibRuleScore = rules.reduce((a, r, i) => a + (r ? FIB[i % FIB.length] : 0), 0);
  const confidence = fibRuleScore / (rules.length * PHI || 1);
  return { value, inRange, phiMid, fibRuleScore, confidence, valid: inRange && confidence > 0.5 };
}

function enforceRule(ruleId, context, weight) {
  const phiWeight = weight * PHI;
  const fibDepth = FIB[Math.min(Math.floor(phiWeight), FIB.length - 1)];
  const enforced = phiWeight > 1;
  const confidence = enforced ? PHI_INV * phiWeight : PHI_INV;
  return { ruleId, context, phiWeight, fibDepth, enforced, confidence };
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

  if (path === '/rule' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreRulePriority(body.ruleId||"R1", body.severity||1, body.frequency||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/rule', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/validate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = validateInput(body.value||50, body.min||0, body.max||100, body.rules||[true,true,false]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/validate', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/enforce' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = enforceRule(body.ruleId||"R1", body.context||"default", body.weight||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/enforce', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
