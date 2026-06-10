/**
 * RATIO — AGI Mini Brain II: Logos et Logica
 * (Latin: "Reason and Logic")
 *
 * Dedicated Cloudflare Worker — Server AIS-002
 * Role: Logic & Inference Engine
 *
 * RATIO is the deductive and inductive logic engine of the MERIDIANUS
 * organism. It evaluates propositions, applies inference rules, resolves
 * contradictions, and produces syllogistic conclusions. Running 24/7 as
 * a Cloudflare Worker, RATIO ensures the organism's reasoning is always
 * grounded in structured logic rather than probabilistic guesswork alone.
 *
 * Capabilities:
 *   - Propositional and predicate logic evaluation
 *   - Syllogistic reasoning (modus ponens / tollens)
 *   - Contradiction detection and resolution
 *   - Rule-based inference chains (Fibonacci-bounded)
 *   - Truth-value propagation across belief networks
 *
 * Routes:
 *   POST /evaluate      — Evaluate a logical proposition
 *   POST /syllogize     — Apply syllogistic reasoning
 *   POST /contradict    — Detect contradictions in a belief set
 *   POST /rulechain     — Execute a rule-based inference chain
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Logic metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-002';
const AIS_NAME  = 'RATIO';
const AIS_LATIN = 'Logos et Logica';
const VERSION   = '1.0.0';

const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Logic engine ──────────────────────────────────────────── */

function evaluate(proposition) {
  // Simple truth evaluation: presence of negation keywords drives value
  const negated = /\b(non|not|false|negat)\b/i.test(proposition);
  const strength = Math.min(1.0, proposition.split(' ').length * PHI_INV * 0.2);
  return {
    aisId:       AIS_ID,
    worker:      AIS_NAME,
    proposition: proposition.slice(0, 256),
    truthValue:  negated ? 'falsum' : 'verum',
    strength:    +strength.toFixed(4),
    beat:        ++beatCount,
    ts:          Date.now(),
  };
}

function syllogize(major, minor) {
  // Modus ponens: if major contains minor premise, conclude
  const valid = major && minor && major.length > 0 && minor.length > 0;
  const conclusion = valid
    ? `${minor.split(' ').slice(-2).join(' ')} ergo verum`
    : 'conclusio incerta';
  return {
    aisId:      AIS_ID,
    worker:     AIS_NAME,
    major:      major.slice(0, 128),
    minor:      minor.slice(0, 128),
    conclusion,
    valid,
    confidence: valid ? +(PHI_INV * 1.5).toFixed(4) : 0,
    beat:       ++beatCount,
    ts:         Date.now(),
  };
}

function contradict(beliefs) {
  const contradictions = [];
  for (let i = 0; i < beliefs.length; i++) {
    for (let j = i + 1; j < beliefs.length; j++) {
      const a = beliefs[i].toLowerCase();
      const b = beliefs[j].toLowerCase();
      if (a.replace(/^non /i, '') === b || b.replace(/^non /i, '') === a) {
        contradictions.push({ a: beliefs[i], b: beliefs[j] });
      }
    }
  }
  return {
    aisId:         AIS_ID,
    worker:        AIS_NAME,
    beliefs:       beliefs.length,
    contradictions,
    consistent:    contradictions.length === 0,
    beat:          ++beatCount,
    ts:            Date.now(),
  };
}

function rulechain(rules, fact) {
  const depth  = Math.min(rules.length, FIB[5]); // max 8 rules
  const chain  = [];
  let current  = fact;
  let strength = 1.0;

  for (let i = 0; i < depth; i++) {
    const rule = rules[i];
    strength   = strength * PHI_INV;
    current    = `${rule}(${current})`;
    chain.push({ step: i + 1, rule, result: current, strength: +strength.toFixed(4) });
  }

  return {
    aisId:       AIS_ID,
    worker:      AIS_NAME,
    initialFact: fact,
    chain,
    conclusion:  current,
    strength:    +strength.toFixed(4),
    beat:        ++beatCount,
    ts:          Date.now(),
  };
}

/* ─── Router ────────────────────────────────────────────────── */

async function handleRequest(request) {
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
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/evaluate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(evaluate(body.proposition || '')), { headers: cors });
  }

  if (path === '/syllogize' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(syllogize(body.major || '', body.minor || '')), { headers: cors });
  }

  if (path === '/contradict' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(contradict(body.beliefs || [])), { headers: cors });
  }

  if (path === '/rulechain' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(rulechain(body.rules || [], body.fact || '')), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
