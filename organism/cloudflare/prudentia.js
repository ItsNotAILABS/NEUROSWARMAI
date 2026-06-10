/**
 * PRUDENTIA — AGI Mini Brain V: Sapientia Decisionis
 * (Latin: "Wisdom of Decision")
 *
 * Dedicated Cloudflare Worker — Server AIS-005
 * Role: Decision-Making & Strategic Planning Engine
 *
 * PRUDENTIA is the decision engine of the MERIDIANUS organism. It
 * synthesizes inputs from ANIMUS (reasoning), RATIO (logic), MEMORIA
 * (knowledge), and INTELLECTUS (comprehension) to produce ranked
 * action plans. PRUDENTIA governs the organism's strategic will —
 * it weighs options, models consequences, and selects optimal paths
 * using φ-weighted utility functions and Fibonacci-bounded lookahead.
 *
 * Capabilities:
 *   - Multi-option decision ranking with φ-utility scoring
 *   - Consequence modelling (benefit/risk/cost/time)
 *   - Strategic planning with Fibonacci lookahead depth
 *   - Trade-off resolution via Pareto frontier selection
 *   - Priority queuing for organism action plans
 *
 * Routes:
 *   POST /decide        — Rank and select optimal action
 *   POST /plan          — Generate strategic plan for a goal
 *   POST /tradeoff      — Resolve trade-offs between options
 *   POST /prioritize    — Prioritize a list of tasks
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Decision metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-005';
const AIS_NAME  = 'PRUDENTIA';
const AIS_LATIN = 'Sapientia Decisionis';
const VERSION   = '1.0.0';

const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let decisionLog = [];

/* ─── Decision engine ───────────────────────────────────────── */

function decide(options, context = '') {
  if (!options || options.length === 0) {
    return { aisId: AIS_ID, worker: AIS_NAME, error: 'no options', beat: ++beatCount, ts: Date.now() };
  }

  const scored = options.map((opt, i) => {
    const utility   = typeof opt === 'object'
      ? (opt.benefit || 0.5) * PHI - (opt.risk || 0.5) * PHI_INV - (opt.cost || 0.5) * 0.1
      : (1 / (i + 1)) * PHI_INV;
    return {
      option:  typeof opt === 'object' ? opt.name || `option-${i + 1}` : String(opt),
      utility: +utility.toFixed(4),
      rank:    0,
    };
  });

  scored.sort((a, b) => b.utility - a.utility);
  scored.forEach((s, i) => s.rank = i + 1);

  const decision = { id: `dec-${Date.now().toString(36)}`, choice: scored[0], context, ts: Date.now() };
  decisionLog.push(decision);
  if (decisionLog.length > FIB[7]) decisionLog.shift();  // max 21 in log

  return { aisId: AIS_ID, worker: AIS_NAME, choice: scored[0].option, utility: scored[0].utility, ranked: scored, beat: ++beatCount, ts: Date.now() };
}

function plan(goal, depth = 3) {
  const steps = FIB[Math.min(depth + 1, 8)];  // Fibonacci step count
  const plan  = [];
  for (let i = 0; i < steps; i++) {
    const phi_w = Math.pow(PHI_INV, i);
    plan.push({
      phase:      i + 1,
      action:     `${goal}-phase-${i + 1}`,
      priority:   +phi_w.toFixed(4),
      effort:     +(1 - phi_w).toFixed(4),
      deadline:   `T+${FIB[i + 1]}d`,
    });
  }
  return { aisId: AIS_ID, worker: AIS_NAME, goal: goal.slice(0, 128), steps: plan.length, plan, beat: ++beatCount, ts: Date.now() };
}

function tradeoff(options) {
  // Pareto: find non-dominated options (max benefit, min cost)
  const pareto = options.filter(o => {
    return !options.some(other =>
      other !== o &&
      (other.benefit || 0) >= (o.benefit || 0) &&
      (other.cost || 0)    <= (o.cost || 0) &&
      ((other.benefit || 0) > (o.benefit || 0) || (other.cost || 0) < (o.cost || 0))
    );
  });
  return { aisId: AIS_ID, worker: AIS_NAME, total: options.length, paretoOptimal: pareto.length, pareto, beat: ++beatCount, ts: Date.now() };
}

function prioritize(tasks) {
  const scored = tasks.map((t, i) => ({
    task:     typeof t === 'string' ? t : t.name || `task-${i + 1}`,
    urgency:  typeof t === 'object' ? (t.urgency || 0.5) : 0.5,
    impact:   typeof t === 'object' ? (t.impact || 0.5) : 0.5,
    priority: +(((t.urgency || 0.5) * PHI + (t.impact || 0.5)) * PHI_INV).toFixed(4),
  }));
  scored.sort((a, b) => b.priority - a.priority);
  scored.forEach((s, i) => s.rank = i + 1);
  return { aisId: AIS_ID, worker: AIS_NAME, tasks: scored, beat: ++beatCount, ts: Date.now() };
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
      status: 'alive', beat: beatCount, decisions: decisionLog.length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, decisions: decisionLog.length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/decide' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(decide(body.options, body.context)), { headers: cors });
  }

  if (path === '/plan' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(plan(body.goal || '', body.depth)), { headers: cors });
  }

  if (path === '/tradeoff' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(tradeoff(body.options || [])), { headers: cors });
  }

  if (path === '/prioritize' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(prioritize(body.tasks || [])), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
