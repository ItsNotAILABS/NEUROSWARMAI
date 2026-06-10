/**
 * COHORS — AGI Mini Brain 056: Cohors et Societas
 *
 * Dedicated Cloudflare Worker — Server AIS-056
 * Role: Team Coordination Engine
 *
 * This worker implements Team Coordination Engine capabilities using PHI golden-ratio
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
 *   POST /team               — Score team synergy using PHI coordination index
 *   POST /coordinate         — Coordinate tasks using FIB allocation weights
 *   POST /align              — Align team goals with PHI-weighted consensus
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-056';
const AIS_NAME  = 'COHORS';
const AIS_LATIN = 'Cohors et Societas';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function scoreTeamSynergy(members, collaborations, diversity) {
  const phiDiversity = diversity * PHI;
  const fibMembers = FIB[Math.min(members, FIB.length - 1)];
  const collabRate = collaborations / (members * (members - 1) || 1);
  const synergy = phiDiversity * collabRate * fibMembers;
  return { members, collaborations, diversity, phiDiversity, fibMembers, collabRate, synergy };
}

function coordinateTasks(tasks, assignees, urgency) {
  const fibUrgency = FIB[Math.min(urgency, FIB.length - 1)];
  const phiLoad = (tasks / (assignees || 1)) * PHI;
  const allocation = Array.from({ length: Math.min(assignees, 10) }, (_, i) => ({
    assignee: i, tasks: Math.round(tasks / assignees), fibSlot: FIB[i % FIB.length], load: phiLoad
  }));
  return { tasks, assignees, urgency, fibUrgency, phiLoad, allocation };
}

function alignTeamGoals(goals, agreements, weight) {
  const fibAgreements = FIB[Math.min(agreements, FIB.length - 1)];
  const phiWeight = weight * PHI;
  const alignment = (agreements / (goals || 1)) * phiWeight * fibAgreements;
  const aligned = alignment > PHI;
  return { goals, agreements, weight, fibAgreements, phiWeight, alignment, aligned };
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

  if (path === '/team' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreTeamSynergy(body.members||5, body.collaborations||10, body.diversity||0.7);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/team', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/coordinate' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = coordinateTasks(body.tasks||20, body.assignees||4, body.urgency||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/coordinate', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/align' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = alignTeamGoals(body.goals||8, body.agreements||6, body.weight||1.2);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/align', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
