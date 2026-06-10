/**
 * CURSOR — Organism Slack Bot II: Deploy Trigger
 * (Latin: "Runner / One Who Runs")
 *
 * Cloudflare Worker — BOT-SLACK-002
 * Slash Command: /deploy [branch]
 * Role: Triggers the deploy-canister.yml GitHub Actions workflow via the
 *       GitHub REST API. Useful for kicking off ICP canister deployments
 *       directly from Slack without opening a browser.
 *
 * Routes:
 *   POST /slack/events     — Slack slash command endpoint (/deploy)
 *   GET  /status           — Worker self-health check
 *   GET  /metrics          — Beat count + deployment metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   SLACK_SIGNING_SECRET   — Slack app signing secret
 *   GITHUB_TOKEN           — Personal access token (repo + workflow scopes)
 *   GITHUB_OWNER           — Repository owner (e.g. "FreddyCreates")
 *   GITHUB_REPO            — Repository name (e.g. "command-platform")
 *   ICP_CANISTER_URL       — Organism token canister URL (optional)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { verifySlackRequest, parseSlackBody, slackResponse, slackError } from '../shared/slack-verify.js';
import { verifyToken, canAccess } from '../shared/token-verify.js';

const PHI      = 1.618033988749895;
const BOT_ID   = 'BOT-SLACK-002';
const BOT_NAME = 'CURSOR';
const BOT_LATIN= 'Cursor Administrationis';
const VERSION  = '1.0.0';

let beatCount   = 0;
let deployCount = 0;

/* ─── GitHub Actions workflow trigger ─────────────────────────────────── */

async function triggerDeploy(branch, workflow, env) {
  const owner    = env?.GITHUB_OWNER || 'FreddyCreates';
  const repo     = env?.GITHUB_REPO  || 'command-platform';
  const wfFile   = workflow || 'deploy-canister.yml';
  const ref      = branch  || 'main';
  const token    = env?.GITHUB_TOKEN;

  if (!token) {
    return { ok: false, error: 'GITHUB_TOKEN not configured' };
  }

  const url = `https://api.github.com/repos/${owner}/${repo}/actions/workflows/${wfFile}/dispatches`;

  try {
    const res = await fetch(url, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept':        'application/vnd.github+json',
        'Content-Type':  'application/json',
        'User-Agent':    `MERIDIANUS-CURSOR/${VERSION}`,
        'X-GitHub-Api-Version': '2022-11-28',
      },
      body: JSON.stringify({ ref }),
    });

    if (res.status === 204) {
      deployCount++;
      return { ok: true, workflow: wfFile, ref, owner, repo };
    }
    const data = await res.json().catch(() => ({}));
    return { ok: false, error: data.message || `HTTP ${res.status}` };
  } catch (err) {
    return { ok: false, error: err.message || 'fetch_error' };
  }
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
      status: 'alive', beat: beatCount, deployCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, deployCount, phi: PHI, ts: Date.now(),
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

    // Parse: /deploy [branch] [workflow]  OR  /deploy token:<id> [branch]
    let branch = 'main';
    let workflow = 'deploy-canister.yml';
    let tier = 1;

    const parts = text.split(/\s+/);
    for (const part of parts) {
      if (part.startsWith('token:')) {
        const tokenId     = part.replace('token:', '').trim();
        const tokenResult = await verifyToken(tokenId, env);
        if (!tokenResult.ok) {
          return new Response(JSON.stringify(slackError('Token invalid. Requires CHR tier or higher.')), { status: 200, headers: cors });
        }
        tier = tokenResult.tier;
      } else if (part.endsWith('.yml') || part.endsWith('.yaml')) {
        workflow = part;
      } else if (part.length > 0) {
        branch = part;
      }
    }

    if (!canAccess(tier, 'slack-deploy')) {
      return new Response(JSON.stringify(slackError('Access denied. Requires CHR token tier or higher.')), { status: 200, headers: cors });
    }

    beatCount++;
    const result = await triggerDeploy(branch, workflow, env);

    if (result.ok) {
      const payload = slackResponse(
        `Deploy triggered on \`${result.ref}\` → \`${result.workflow}\`\nRepo: \`${result.owner}/${result.repo}\``,
        '🚀',
        `CURSOR (${BOT_ID}) | Deploy #${deployCount} | ${new Date().toUTCString()}`
      );
      return new Response(JSON.stringify(payload), { status: 200, headers: cors });
    }

    return new Response(JSON.stringify(slackError(`Deploy failed: ${result.error}`)), { status: 200, headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

addEventListener('fetch', event => event.respondWith(handleRequest(event.request, event.env ?? {})));
