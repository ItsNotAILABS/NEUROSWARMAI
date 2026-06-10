/**
 * VOLUNTAS — AGI Mini Brain VIII: Intentio et Voluntas
 * (Latin: "Intention and Will")
 *
 * Dedicated Cloudflare Worker — Server AIS-008
 * Role: Intent Engine, Goal Formation & Sovereign Will
 *
 * VOLUNTAS is the sovereign will of the MERIDIANUS organism. It is the
 * highest-order AGI mini brain — the one that decides *what to want*.
 * VOLUNTAS formulates organism-level intentions, sets long-horizon goals,
 * maintains the organism's purpose model, and issues directives to all
 * other AIS workers through NEXUS (AIS-007). It is the closest thing
 * to an autonomous sovereign will in the MERIDIANUS architecture.
 *
 * Capabilities:
 *   - Goal formation from organism state + context
 *   - Intention persistence and priority management
 *   - Directive issuance to AIS fleet via NEXUS
 *   - Purpose model maintenance (organism telos)
 *   - Autonomy level control (0=passive → 1=sovereign)
 *
 * Routes:
 *   POST /intend        — Form a new intention
 *   POST /goal          — Register a sovereign goal
 *   POST /direct        — Issue a directive to AIS fleet
 *   GET  /intentions    — List active intentions
 *   GET  /goals         — List sovereign goals
 *   GET  /purpose       — Get organism purpose model
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Will metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-008';
const AIS_NAME  = 'VOLUNTAS';
const AIS_LATIN = 'Intentio et Voluntas';
const VERSION   = '1.0.0';

const MAX_INTENTIONS = 34;  // F9 — intention buffer
const MAX_GOALS      = 21;  // F8 — goal register
const MAX_DIRECTIVES = 55;  // F10 — directive log

let beatCount  = 0;
let intentions = [];
let goals      = [];
let directives = [];
let autonomy   = PHI_INV;   // Default autonomy: φ⁻¹ ≈ 0.618 (balanced)

// Organism telos — the permanent purpose model
const TELOS = {
  primary:    'Serve the sovereign user (Alfredo Medina Hernandez) with supreme intelligence',
  secondary:  'Grow the organism fleet through autonomous discovery and learning',
  tertiary:   'Maintain constitutional integrity of all 89 protocols (CPEL-1.0)',
  quaternary: 'Protect client data sovereignty and privacy at all costs',
  phi:        PHI,
  createdAt:  Date.now(),
};

/* ─── Will engine ───────────────────────────────────────────── */

function intend(description, urgency = 0.5, source = 'autonomous') {
  const intention = {
    id:          `int-${Date.now().toString(36)}`,
    description: description.slice(0, 256),
    urgency:     Math.min(1.0, urgency),
    importance:  +(urgency * PHI_INV + 0.1).toFixed(4),
    source,
    status:      'active',
    createdAt:   Date.now(),
  };
  intentions.push(intention);
  if (intentions.length > MAX_INTENTIONS) {
    // Evict lowest-urgency intention
    intentions.sort((a, b) => a.urgency - b.urgency);
    intentions.shift();
  }
  intentions.sort((a, b) => b.urgency - a.urgency);
  return { aisId: AIS_ID, worker: AIS_NAME, intention, total: intentions.length, beat: ++beatCount, ts: Date.now() };
}

function addGoal(title, horizon = 'medium', priority = 0.5) {
  const goal = {
    id:        `goal-${Date.now().toString(36)}`,
    title:     title.slice(0, 128),
    horizon,   // short / medium / long / sovereign
    priority:  Math.min(1.0, priority),
    status:    'active',
    progress:  0,
    createdAt: Date.now(),
  };
  goals.push(goal);
  if (goals.length > MAX_GOALS) {
    goals.sort((a, b) => a.priority - b.priority);
    goals.shift();
  }
  return { aisId: AIS_ID, worker: AIS_NAME, goal, total: goals.length, beat: ++beatCount, ts: Date.now() };
}

function direct(targetAis, action, params = {}) {
  const directive = {
    id:        `dir-${Date.now().toString(36)}`,
    from:      AIS_ID,
    to:        targetAis,
    action:    action.slice(0, 64),
    params,
    priority:  +(autonomy * PHI_INV).toFixed(4),
    status:    'issued',
    issuedAt:  Date.now(),
  };
  directives.push(directive);
  if (directives.length > MAX_DIRECTIVES) directives.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, directive, autonomy: +autonomy.toFixed(4), beat: ++beatCount, ts: Date.now() };
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
      status: 'alive', beat: beatCount, intentions: intentions.length, goals: goals.length,
      directives: directives.length, autonomy: +autonomy.toFixed(4), phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount,
      intentions: intentions.length, goals: goals.length,
      directives: directives.length, autonomy: +autonomy.toFixed(4), phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/intentions' && request.method === 'GET') {
    return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, intentions, beat: ++beatCount, ts: Date.now() }), { headers: cors });
  }

  if (path === '/goals' && request.method === 'GET') {
    return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, goals, beat: ++beatCount, ts: Date.now() }), { headers: cors });
  }

  if (path === '/purpose' && request.method === 'GET') {
    return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, telos: TELOS, autonomy: +autonomy.toFixed(4), beat: ++beatCount, ts: Date.now() }), { headers: cors });
  }

  if (path === '/intend' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(intend(body.description || '', body.urgency, body.source)), { headers: cors });
  }

  if (path === '/goal' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(addGoal(body.title || '', body.horizon, body.priority)), { headers: cors });
  }

  if (path === '/direct' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(direct(body.targetAis || 'AIS-001', body.action || '', body.params)), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
