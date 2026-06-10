/**
 * GLORIA — AGI Mini Brain 049: Gloria et Honor
 *
 * Dedicated Cloudflare Worker — Server AIS-049
 * Role: Achievement & Recognition Engine
 *
 * This worker implements Achievement & Recognition Engine capabilities using PHI golden-ratio
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
 *   POST /achieve            — Record achievement with PHI-scaled impact score
 *   POST /rank               — Rank achievements using FIB honor multipliers
 *   POST /honor              — Award honor score with PHI compound prestige
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-049';
const AIS_NAME  = 'GLORIA';
const AIS_LATIN = 'Gloria et Honor';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function recordAchievement(achievementId, impact, rarity) {
  const phiImpact = impact * PHI;
  const fibRarity = FIB[Math.min(Math.floor(rarity * 10), FIB.length - 1)];
  const score = phiImpact * fibRarity;
  return { achievementId, impact, rarity, phiImpact, fibRarity, score, tier: score > 100 ? 'legendary' : score > 50 ? 'epic' : 'rare' };
}

function rankAchievements(achievements, scores) {
  const phiScores = scores.map((s, i) => ({
    achievement: achievements[i] || `ACH-${i}`, score: s,
    phiScore: s * PHI, fibBonus: FIB[i % FIB.length], honor: s * PHI * FIB[i % FIB.length]
  }));
  phiScores.sort((a, b) => b.honor - a.honor);
  phiScores.forEach((a, i) => { a.rank = i + 1; });
  return { ranked: phiScores, topHonor: phiScores[0] };
}

function awardHonorScore(baseHonor, tenure, legacy) {
  const phiTenure = Math.pow(PHI, Math.min(tenure, 8));
  const fibLegacy = FIB[Math.min(legacy, FIB.length - 1)];
  const prestige = baseHonor * phiTenure * fibLegacy;
  return { baseHonor, tenure, legacy, phiTenure, fibLegacy, prestige, title: prestige > 10000 ? 'Grand Master' : prestige > 1000 ? 'Master' : 'Journeyman' };
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

  if (path === '/achieve' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = recordAchievement(body.achievementId||"ACH-1", body.impact||0.9, body.rarity||0.8);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/achieve', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/rank' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = rankAchievements(body.achievements||["speed","quality","innovation"], body.scores||[90,85,95]);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/rank', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/honor' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = awardHonorScore(body.baseHonor||100, body.tenure||5, body.legacy||3);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/honor', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
