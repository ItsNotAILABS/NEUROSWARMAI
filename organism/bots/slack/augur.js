/**
 * AUGUR — Organism Slack Bot IV: Forecaster
 * (Latin: "One Who Reads Omens / Forecaster")
 *
 * Cloudflare Worker — BOT-SLACK-004
 * Slash Command: /forecast
 * Role: Reports token prices, canister cycle balance, and organism
 *       performance metrics as a formatted Slack dashboard.
 *
 * Routes:
 *   POST /slack/events     — Slack slash command endpoint (/forecast)
 *   GET  /status           — Worker self-health check
 *   GET  /metrics          — Beat count + forecast metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   SLACK_SIGNING_SECRET   — Slack app signing secret
 *   AIS_FLEET_URL          — Base URL of the AIS fleet index worker
 *   ICP_CANISTER_URL       — Organism token canister URL (optional)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { verifySlackRequest, parseSlackBody, slackError } from '../shared/slack-verify.js';
import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-SLACK-004';
const BOT_NAME = 'AUGUR';
const BOT_LATIN= 'Augur Praedictionis';
const VERSION  = '1.0.0';

// Fibonacci series for metric display
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233];

let beatCount     = 0;
let forecastCount = 0;

/* ─── Fetch organism metrics ───────────────────────────────────────────── */

async function fetchMetrics(env) {
  if (!env?.AIS_FLEET_URL) {
    // Alpha stub: φ-weighted synthetic metrics
    const cyclesT = (4.236e12 * PHI).toFixed(0);         // PHANTOM tier cycles
    return {
      canisterCycles:  cyclesT,
      workersOnline:   69,
      webWorkers:      35,
      phi:             PHI,
      phi_beat:        873,
      tokens: {
        CHR: (1000 * PHI).toFixed(2),
        PHT: (PHI * PHI * 100).toFixed(2),
        GOL: (PHI * 89).toFixed(2),
      },
      source: 'alpha-stub',
      beat:   ++beatCount,
    };
  }

  try {
    const [fleetRes] = await Promise.all([
      fetch(`${env.AIS_FLEET_URL}/fleet/status`, { headers: { 'X-Bot-ID': BOT_ID } }),
    ]);
    const fleet = await fleetRes.json();
    return { ...fleet, beat: ++beatCount };
  } catch {
    return { error: 'fleet_unreachable', phi: PHI, beat: ++beatCount };
  }
}

/* ─── Format forecast for Slack ────────────────────────────────────────── */

function buildForecastBlocks(metrics) {
  const ts      = new Date().toUTCString();
  const cycles  = metrics.canisterCycles ? `${(metrics.canisterCycles / 1e12).toFixed(3)}T` : 'N/A';
  const workers = `${metrics.workersOnline ?? 69} AIS + ${metrics.webWorkers ?? 35} Web`;
  const tokens  = metrics.tokens || {};

  const tokenLines = Object.entries(tokens)
    .map(([sym, val]) => `• *${sym}:* \`${val}\``)
    .join('\n');

  return {
    response_type: 'in_channel',
    blocks: [
      {
        type: 'header',
        text: { type: 'plain_text', text: '🔮 AUGUR — Organism Forecast', emoji: true },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Canister Cycles:*\n${cycles}` },
          { type: 'mrkdwn', text: `*Workers Online:*\n${workers}` },
          { type: 'mrkdwn', text: `*φ Constant:*\n${PHI.toFixed(6)}` },
          { type: 'mrkdwn', text: `*φ-Beat:*\n${metrics.phi_beat ?? 873}ms` },
        ],
      },
      ...(tokenLines ? [{
        type: 'section',
        text: { type: 'mrkdwn', text: `*Token Forecast:*\n${tokenLines}` },
      }] : []),
      {
        type: 'context',
        elements: [{ type: 'mrkdwn', text: `AUGUR (${BOT_ID}) | Forecast #${forecastCount} | ${ts}` }],
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
      status: 'alive', beat: beatCount, forecastCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, forecastCount, phi: PHI, ts: Date.now(),
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
    let tier      = 1;

    if (text.startsWith('token:')) {
      const tokenId     = text.replace('token:', '').trim();
      const tokenResult = await verifyToken(tokenId, env);
      if (!tokenResult.ok) {
        return new Response(JSON.stringify(slackError('Token invalid.')), { status: 200, headers: cors });
      }
      tier = tokenResult.tier;
    }

    if (!canAccess(tier, 'slack-forecast')) {
      return new Response(JSON.stringify(slackError('Access denied. Requires CHR token tier or higher.')), { status: 200, headers: cors });
    }

    beatCount++;
    forecastCount++;
    const metrics = await fetchMetrics(env);
    const payload = buildForecastBlocks(metrics);
    return new Response(JSON.stringify(payload), { status: 200, headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
