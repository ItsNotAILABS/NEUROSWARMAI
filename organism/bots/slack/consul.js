/**
 * CONSUL — Organism Slack Bot III: AI Query Router
 * (Latin: "Advisor / Consul")
 *
 * Cloudflare Worker — BOT-SLACK-003
 * Slash Command: /ask <query>
 * Role: Routes natural-language queries from Slack to the MERIDIANUS
 *       ANIMUS brain worker (AIS-001) and returns the reasoning result
 *       as a formatted Slack Block Kit message.
 *
 * Routes:
 *   POST /slack/events     — Slack slash command endpoint (/ask)
 *   GET  /status           — Worker self-health check
 *   GET  /metrics          — Beat count + query metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   SLACK_SIGNING_SECRET   — Slack app signing secret
 *   AIS_ANIMUS_URL         — ANIMUS worker URL (AIS-001)
 *   ICP_CANISTER_URL       — Organism token canister URL (optional)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { verifySlackRequest, parseSlackBody, slackResponse, slackError } from '../shared/slack-verify.js';
import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-SLACK-003';
const BOT_NAME = 'CONSUL';
const BOT_LATIN= 'Consul Cogitationis';
const VERSION  = '1.0.0';

let beatCount  = 0;
let queryCount = 0;

/* ─── Route query to ANIMUS ────────────────────────────────────────────── */

async function askAnimus(query, env) {
  if (!env?.AIS_ANIMUS_URL) {
    // Alpha fallback: local φ-weighted reasoning stub
    const steps = [];
    const depth = Math.min(5, query.split(' ').length);
    let confidence = PHI_INV;
    for (let i = 0; i < depth; i++) {
      const w = Math.pow(PHI_INV, i);
      steps.push({ step: i + 1, phi_weight: +w.toFixed(4), confidence: +(confidence * w).toFixed(4) });
      confidence = Math.min(1.0, confidence + w * 0.1);
    }
    return {
      task:       query,
      steps,
      confidence: +confidence.toFixed(4),
      source:     'alpha-stub',
      aisId:      'AIS-001',
      worker:     'ANIMUS',
      phi:        PHI,
      beat:       ++beatCount,
    };
  }

  try {
    const res  = await fetch(`${env.AIS_ANIMUS_URL}/reason`, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json', 'X-Bot-ID': BOT_ID },
      body:    JSON.stringify({ task: query, depth: 5 }),
    });
    return await res.json();
  } catch {
    return { task: query, confidence: 0, error: 'animus_unreachable', phi: PHI, beat: ++beatCount };
  }
}

/* ─── Format ANIMUS result for Slack ──────────────────────────────────── */

function buildReasoningBlocks(query, result) {
  const confidencePct = ((result.confidence || 0) * 100).toFixed(1);
  const steps         = (result.steps || []).slice(0, 5);

  const stepLines = steps.map(s =>
    `• Step ${s.step} — φ-weight: \`${s.phi_weight}\` | confidence: \`${s.confidence}\``
  ).join('\n');

  return {
    response_type: 'in_channel',
    blocks: [
      {
        type: 'header',
        text: { type: 'plain_text', text: '🧠 CONSUL — Reasoning Result', emoji: true },
      },
      {
        type: 'section',
        text: { type: 'mrkdwn', text: `*Query:* ${query.slice(0, 300)}` },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Confidence:*\n${confidencePct}%` },
          { type: 'mrkdwn', text: `*Source:*\n${result.aisId || 'AIS-001'} ANIMUS` },
        ],
      },
      ...(stepLines ? [{
        type: 'section',
        text: { type: 'mrkdwn', text: `*Reasoning Steps:*\n${stepLines}` },
      }] : []),
      {
        type: 'context',
        elements: [
          { type: 'mrkdwn', text: `CONSUL (${BOT_ID}) | Query #${queryCount} | ${new Date().toUTCString()}` },
        ],
      },
    ],
  };
}

/* ─── Request handler ──────────────────────────────────────────────────── */

async function handleRequest(request, env) {
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-Bot-ID': BOT_ID,
    'X-Bot-Name': BOT_NAME,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type,x-slack-signature,x-slack-request-timestamp' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, queryCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, queryCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/slack/events' && request.method === 'POST') {
    const cloned   = request.clone();
    const verified = await verifySlackRequest(cloned, env?.SLACK_SIGNING_SECRET);
    if (!verified) {
      return new Response(JSON.stringify(slackError('Unauthorized — invalid Slack signature')), { status: 403, headers: cors });
    }

    const rawBody = await request.text();
    const body    = parseSlackBody(rawBody);
    const text    = (body.text || '').trim();

    if (!text) {
      return new Response(JSON.stringify(slackError('Usage: `/ask <your question>`')), { status: 200, headers: cors });
    }

    let query = text;
    let tier  = 1;

    if (text.startsWith('token:')) {
      const spaceIdx = text.indexOf(' ');
      const tokenId  = text.slice(6, spaceIdx > 0 ? spaceIdx : undefined).trim();
      query          = spaceIdx > 0 ? text.slice(spaceIdx + 1).trim() : '';
      const tokenResult = await verifyToken(tokenId, env);
      if (!tokenResult.ok) {
        return new Response(JSON.stringify(slackError('Token invalid.')), { status: 200, headers: cors });
      }
      tier = tokenResult.tier;
    }

    if (!canAccess(tier, 'slack-ask')) {
      return new Response(JSON.stringify(slackError('Access denied. Requires CHR token tier or higher.')), { status: 200, headers: cors });
    }
    if (!query) {
      return new Response(JSON.stringify(slackError('Usage: `/ask <your question>`')), { status: 200, headers: cors });
    }

    beatCount++;
    queryCount++;
    const result  = await askAnimus(query, env);
    const payload = buildReasoningBlocks(query, result);
    return new Response(JSON.stringify(payload), { status: 200, headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
