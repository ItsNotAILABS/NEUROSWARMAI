/**
 * CONSENSUS — AGI Mini Brain 058: Consensus et Unanimitas
 *
 * Dedicated Cloudflare Worker — Server AIS-058
 * Role: Consensus Engine
 *
 * This worker implements Consensus Engine capabilities using PHI golden-ratio
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
 *   POST /vote               — Weight votes using PHI preference scaling
 *   POST /agree              — Score agreement level with FIB vote thresholds
 *   POST /quorum             — Calculate quorum requirement using FIB ratios
 *   GET  /status             — Worker health + beat status
 *   GET  /metrics            — Domain metrics + stats
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;
const AIS_ID    = 'AIS-058';
const AIS_NAME  = 'CONSENSUS';
const AIS_LATIN = 'Consensus et Unanimitas';
const VERSION   = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;

/* ─── Domain functions ──────────────────────────────────────── */

function weightVotes(votes, weights, bias) {
  const phiBias = bias * PHI;
  const fibWeights = FIB.slice(0, votes.length);
  const weighted = votes.map((v, i) => ({
    vote: v, weight: (weights[i] || 1) * PHI, fibWeight: fibWeights[i] || 1,
    score: v * (weights[i] || 1) * PHI * (fibWeights[i] || 1)
  }));
  const total = weighted.reduce((a, w) => a + w.score, 0);
  return { voteCount: votes.length, phiBias, weighted, total, normalized: total / (weighted.length * PHI || 1) };
}

function scoreAgreement(yesVotes, totalVotes, threshold) {
  const ratio = yesVotes / (totalVotes || 1);
  const phiRatio = ratio * PHI;
  const fibThreshold = FIB[Math.min(Math.floor(threshold * 10), FIB.length - 1)];
  const agreed = ratio >= threshold;
  return { yesVotes, totalVotes, ratio, phiRatio, fibThreshold, agreed, confidence: phiRatio * fibThreshold };
}

function calculateQuorum(totalMembers, participatingMembers) {
  const fibQuorum = FIB[Math.min(Math.floor(totalMembers / 10), FIB.length - 1)];
  const phiRequired = totalMembers * PHI_INV;
  const quorumMet = participatingMembers >= phiRequired;
  const participation = participatingMembers / (totalMembers || 1);
  return { totalMembers, participatingMembers, fibQuorum, phiRequired, participation, quorumMet };
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

  if (path === '/vote' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = weightVotes(body.votes||[1,0,1,1,1], body.weights||[1,1,2,1,1], body.bias||1);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/vote', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/agree' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = scoreAgreement(body.yesVotes||7, body.totalVotes||10, body.threshold||0.6);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/agree', ...result, beat: beatCount }), { headers: cors });
  }

  if (path === '/quorum' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    const result = calculateQuorum(body.totalMembers||21, body.participatingMembers||14);
    return new Response(JSON.stringify({ aisId: AIS_ID, route: '/quorum', ...result, beat: beatCount }), { headers: cors });
  }


  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
