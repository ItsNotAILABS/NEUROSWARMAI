/**
 * NUNTIUS — Organism Slack Bot I: Status Messenger
 * (Latin: "Messenger")
 *
 * Cloudflare Worker — BOT-SLACK-001
 * Slash Command: /status
 * Role: Posts the daily Organism health report to a Slack channel.
 *
 * Receives Slack slash command POST, verifies Slack signature, queries
 * the organism AIS fleet for live status, and returns a formatted
 * Block Kit message with φ-weighted health indicators.
 *
 * Routes:
 *   POST /slack/events     — Slack slash command endpoint (/status)
 *   GET  /status           — Worker self-health check
 *   GET  /metrics          — Beat count + invocation metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   SLACK_SIGNING_SECRET   — Slack app signing secret
 *   AIS_FLEET_URL          — Base URL of the AIS fleet index worker
 *   ICP_CANISTER_URL       — Organism token canister URL (optional)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { verifySlackRequest, parseSlackBody, slackResponse, slackError } from '../shared/slack-verify.js';
import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-SLACK-001';
const BOT_NAME = 'NUNTIUS';
const BOT_LATIN= 'Nuntius Status';
const VERSION  = '1.0.0';

let beatCount    = 0;
let invocations  = 0;

/* ─── Organism health aggregator ───────────────────────────────────────── */

async function fetchOrganismStatus(env) {
  if (!env?.AIS_FLEET_URL) {
    return {
      status: 'alpha',
      workers: 69,
      uptime:  '100%',
      phi:     PHI,
      beat:    ++beatCount,
      note:    'AIS_FLEET_URL not configured — alpha mode',
    };
  }

  try {
    const res  = await fetch(`${env.AIS_FLEET_URL}/fleet/status`, {
      headers: { 'X-Bot-ID': BOT_ID },
    });
    const data = await res.json();
    return { ...data, beat: ++beatCount };
  } catch {
    return { status: 'unreachable', beat: ++beatCount, phi: PHI };
  }
}

/* ─── Slack response builder ───────────────────────────────────────────── */

function buildStatusBlocks(status) {
  const health    = status.status === 'alive' || status.status === 'alpha' ? '🟢 Online' : '🔴 Degraded';
  const phi_str   = PHI.toFixed(6);
  const ts        = new Date().toUTCString();

  return {
    response_type: 'in_channel',
    blocks: [
      {
        type: 'header',
        text: { type: 'plain_text', text: '⚡ MERIDIANUS Organism Status', emoji: true },
      },
      {
        type: 'section',
        fields: [
          { type: 'mrkdwn', text: `*Status:*\n${health}` },
          { type: 'mrkdwn', text: `*Workers:*\n${status.workers ?? 69} AIS + 35 Web` },
          { type: 'mrkdwn', text: `*φ Constant:*\n${phi_str}` },
          { type: 'mrkdwn', text: `*Beat:*\n#${status.beat ?? beatCount}` },
        ],
      },
      {
        type: 'context',
        elements: [
          { type: 'mrkdwn', text: `NUNTIUS (${BOT_ID}) | ${ts}` },
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
      status: 'alive', beat: beatCount, invocations, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, invocations, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/slack/events' && request.method === 'POST') {
    // Clone request so body can be read twice (verification + parsing)
    const cloned = request.clone();
    const verified = await verifySlackRequest(cloned, env?.SLACK_SIGNING_SECRET);
    if (!verified) {
      return new Response(JSON.stringify(slackError('Unauthorized — invalid Slack signature')), { status: 403, headers: cors });
    }

    const rawBody  = await request.text();
    const body     = parseSlackBody(rawBody);
    const command  = body.command || '';
    const text     = (body.text || '').trim();

    // Optional token verification
    let tier = 1;
    if (text.startsWith('token:')) {
      const tokenId = text.replace('token:', '').trim();
      const tokenResult = await verifyToken(tokenId, env);
      if (!tokenResult.ok) {
        return new Response(JSON.stringify(slackError(`Token invalid. Use CHR tier or higher to access /status.`)), { status: 200, headers: cors });
      }
      tier = tokenResult.tier;
    }

    invocations++;
    if (!canAccess(tier, 'slack-status')) {
      return new Response(JSON.stringify(slackError('Access denied. Requires CHR token tier or higher.')), { status: 200, headers: cors });
    }

    const status = await fetchOrganismStatus(env);
    const payload = buildStatusBlocks(status);
    return new Response(JSON.stringify(payload), { status: 200, headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
