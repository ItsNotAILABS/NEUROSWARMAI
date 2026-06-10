/**
 * TALENTUM — AGI Mini Brain 047: Talentum et Ingenium
 *
 * Dedicated Cloudflare Worker — Server AIS-047
 * Role: Talent & Skill Engine
 *
 * This worker implements Talent & Skill Engine capabilities using PHI golden-ratio
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
 *   POST /skill              — Normalize skill score using PHI scaling
 *   POST /assess             — Assess talent profile with FIB milestone weights
 *   POST /develop            — Generate development roadmap via FIB stages
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-047';
const AIS_NAME  = 'TALENTUM';
const AIS_LATIN = 'Talentum et Ingenium';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function normalizeSkillScore(raw, max, baseline) {
  const normalized = (raw - baseline) / ((max - baseline) || 1);
  const phiNorm = normalized * PHI;
  const fibLevel = FIB.findIndex(f => f >= raw * 10) + 1;
  return { raw, max, baseline, normalized, phiNorm, fibLevel, rating: phiNorm > PHI_INV ? 'proficient' : 'developing' };
}

function assessTalentProfile(skills, weights, milestones) {
  const fibMilestones = milestones.map((m, i) => ({ milestone: m, fibWeight: FIB[i % FIB.length] }));
  const weighted = skills.reduce((a, s, i) => a + s * (weights[i] || 1) * PHI, 0);
  const total = weights.reduce((a, w) => a + w, 0) * PHI;
  const score = weighted / (total || 1);
  return { skills, weighted, total, score, fibMilestones, percentile: Math.min(score * 100, 100) };
}

function generateDevelopmentRoadmap(currentLevel, targetLevel) {
  const steps = targetLevel - currentLevel;
  const roadmap = FIB.slice(0, Math.min(steps, FIB.length)).map((f, i) => ({
    stage: i + 1, fibTarget: f, phiProgress: PHI * (i + 1) / (steps || 1), description: `Stage ${i + 1} milestone`
  }));
  return { currentLevel, targetLevel, steps, roadmap, completionScore: steps * PHI };
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

  if (path === '/skill' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = normalizeSkillScore(body.raw||75, body.max||100, body.baseline||0);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/skill', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/assess' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = assessTalentProfile(body.skills||[80,70,90], body.weights||[1,2,1], body.milestones||["basic","intermediate","advanced"]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/assess', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/develop' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = generateDevelopmentRoadmap(body.currentLevel||1, body.targetLevel||5);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/develop', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
