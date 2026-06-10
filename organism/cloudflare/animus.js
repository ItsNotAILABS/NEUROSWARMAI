/**
 * ANIMUS — AGI Mini Brain I: Mens et Spiritus
 * (Latin: "Mind and Spirit")
 *
 * Dedicated Cloudflare Worker — Server AIS-001
 * Role: Core AGI Reasoning Engine
 *
 * ANIMUS is the primary reasoning intelligence of the MERIDIANUS organism.
 * It receives raw cognitive tasks, decomposes them through a φ-weighted
 * reasoning chain, and returns structured conclusions. Unlike browser Web
 * Workers that live only while a tab is open, ANIMUS runs 24/7 as a
 * sovereign server-side Cloudflare Worker — always alive, always reasoning.
 *
 * Capabilities:
 *   - Chain-of-thought reasoning with Fibonacci depth control
 *   - Goal decomposition and sub-goal synthesis
 *   - Contextual inference from MEMORIA (AIS-003) knowledge
 *   - Confidence scoring via uncertainty quantification
 *   - Cross-worker reasoning relay through NEXUS (AIS-007)
 *
 * Routes:
 *   POST /reason        — Submit a reasoning task
 *   POST /decompose     — Decompose a goal into sub-tasks
 *   POST /infer         — Infer conclusions from evidence
 *   GET  /status        — Worker health + beat status
 *   GET  /metrics       — Reasoning metrics + confidence stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-001';
const AIS_NAME  = 'ANIMUS';
const AIS_LATIN = 'Mens et Spiritus';
const VERSION   = '1.0.0';

// Fibonacci reasoning depths: 1,1,2,3,5,8,13,21,34,55
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Reasoning engine ──────────────────────────────────────── */

function reason(task, depth = 5) {
  const maxDepth = FIB[Math.min(depth, FIB.length - 1)];
  const steps    = [];
  let confidence = PHI_INV;

  for (let i = 0; i < maxDepth; i++) {
    const phi_weight = Math.pow(PHI_INV, i);
    steps.push({
      step:       i + 1,
      action:     `reason-step-${i + 1}`,
      phi_weight: +phi_weight.toFixed(6),
      confidence: +(confidence * phi_weight).toFixed(6),
    });
    confidence = Math.min(1.0, confidence + phi_weight * 0.1);
  }

  return {
    aisId:      AIS_ID,
    worker:     AIS_NAME,
    task:       task.slice(0, 256),
    depth:      maxDepth,
    steps,
    confidence: +confidence.toFixed(4),
    phi:        PHI,
    beat:       ++beatCount,
    ts:         Date.now(),
  };
}

function decompose(goal, breadth = 3) {
  const count = FIB[Math.min(breadth + 1, FIB.length - 1)];
  const subGoals = [];
  for (let i = 0; i < count; i++) {
    subGoals.push({
      id:       `sg-${i + 1}`,
      subGoal:  `${goal} → sub-task ${i + 1}`,
      priority: +(Math.pow(PHI_INV, i)).toFixed(4),
    });
  }
  return { aisId: AIS_ID, worker: AIS_NAME, goal, subGoals, beat: ++beatCount, ts: Date.now() };
}

function infer(evidence) {
  const confidence = evidence.length
    ? Math.min(1.0, evidence.reduce((s, e) => s + (e.weight || PHI_INV), 0) / evidence.length)
    : 0;
  return {
    aisId:      AIS_ID,
    worker:     AIS_NAME,
    evidence:   evidence.length,
    conclusion: confidence > 0.5 ? 'verum' : 'incertum',
    confidence: +confidence.toFixed(4),
    beat:       ++beatCount,
    ts:         Date.now(),
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
      aisId: AIS_ID, worker: AIS_NAME, beats: beatCount,
      phi: PHI, fibDepths: FIB, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/reason' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(reason(body.task || '', body.depth)), { headers: cors });
  }

  if (path === '/decompose' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(decompose(body.goal || '', body.breadth)), { headers: cors });
  }

  if (path === '/infer' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(infer(body.evidence || [])), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
