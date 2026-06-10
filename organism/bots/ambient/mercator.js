/**
 * MERCATOR — Organism Ambient Bot III: Discord Scout
 * (Latin: "Merchant / Scout / Explorer")
 *
 * Cloudflare Worker — BOT-AMB-003
 * Platform: Discord (Webhook)
 * Trigger: On-demand (POST /scout) or Cron (every 8h)
 * Role: Summarizes open GitHub Issues and pull requests into a formatted
 *       Discord embed thread, giving the team a live view of the repo.
 *
 * Routes:
 *   POST /scout            — Manual trigger → fetch + post to Discord
 *   GET  /status           — Worker self-health check
 *   GET  /metrics          — Beat count + scout metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   DISCORD_WEBHOOK_URL    — Discord channel webhook URL
 *   GITHUB_TOKEN           — PAT with repo read scope
 *   GITHUB_OWNER           — Repository owner (e.g. "FreddyCreates")
 *   GITHUB_REPO            — Repository name (e.g. "command-platform")
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-AMB-003';
const BOT_NAME = 'MERCATOR';
const BOT_LATIN= 'Mercator Explorans';
const VERSION  = '1.0.0';

let beatCount  = 0;
let scoutCount = 0;

/* ─── GitHub API helpers ────────────────────────────────────────────────── */

async function fetchGitHub(path, env) {
  const token = env?.GITHUB_TOKEN;
  const headers = {
    'Accept':        'application/vnd.github+json',
    'User-Agent':    `MERIDIANUS-MERCATOR/${VERSION}`,
    'X-GitHub-Api-Version': '2022-11-28',
  };
  if (token) headers['Authorization'] = `Bearer ${token}`;

  const res = await fetch(`https://api.github.com${path}`, { headers });
  if (!res.ok) return null;
  return res.json();
}

async function fetchRepoSummary(env) {
  const owner = env?.GITHUB_OWNER || 'FreddyCreates';
  const repo  = env?.GITHUB_REPO  || 'command-platform';

  const [issues, prs] = await Promise.all([
    fetchGitHub(`/repos/${owner}/${repo}/issues?state=open&per_page=5`, env),
    fetchGitHub(`/repos/${owner}/${repo}/pulls?state=open&per_page=5`, env),
  ]);

  return {
    owner,
    repo,
    issues: Array.isArray(issues) ? issues.filter(i => !i.pull_request) : [],
    prs:    Array.isArray(prs)    ? prs    : [],
  };
}

/* ─── Build Discord embed ────────────────────────────────────────────────── */

function buildDiscordPayload(summary) {
  const ts    = new Date().toISOString();
  const phi   = PHI.toFixed(6);
  const repo  = `${summary.owner}/${summary.repo}`;
  const url   = `https://github.com/${repo}`;

  const issueLines = summary.issues.length
    ? summary.issues.map(i => `• [#${i.number}](${i.html_url}) ${i.title.slice(0, 80)}`).join('\n')
    : '_No open issues_';

  const prLines = summary.prs.length
    ? summary.prs.map(p => `• [#${p.number}](${p.html_url}) ${p.title.slice(0, 80)}`).join('\n')
    : '_No open PRs_';

  return {
    embeds: [
      {
        title:       `📡 MERCATOR — ${repo} Scout`,
        description: `φ-weighted intelligence report | φ = ${phi}`,
        url,
        color:       0x5865F2, // Discord blurple
        timestamp:   ts,
        fields: [
          {
            name:   `📋 Open Issues (${summary.issues.length})`,
            value:  issueLines.slice(0, 1024),
            inline: false,
          },
          {
            name:   `🔀 Open Pull Requests (${summary.prs.length})`,
            value:  prLines.slice(0, 1024),
            inline: false,
          },
        ],
        footer: {
          text: `${BOT_ID} MERCATOR | Scout #${scoutCount}`,
        },
      },
    ],
  };
}

/* ─── Send to Discord webhook ───────────────────────────────────────────── */

async function sendDiscord(payload, env) {
  const webhookUrl = env?.DISCORD_WEBHOOK_URL;
  if (!webhookUrl) return { ok: false, error: 'DISCORD_WEBHOOK_URL not configured' };

  try {
    const res = await fetch(webhookUrl, {
      method:  'POST',
      headers: { 'Content-Type': 'application/json' },
      body:    JSON.stringify(payload),
    });
    return res.ok ? { ok: true } : { ok: false, error: `HTTP ${res.status}` };
  } catch (err) {
    return { ok: false, error: err.message || 'fetch_error' };
  }
}

/* ─── Scout mission ─────────────────────────────────────────────────────── */

async function runScout(env) {
  beatCount++;
  scoutCount++;
  const summary = await fetchRepoSummary(env);
  const payload = buildDiscordPayload(summary);
  const result  = await sendDiscord(payload, env);
  return { ...result, scoutCount, issues: summary.issues.length, prs: summary.prs.length, beat: beatCount };
}

/* ─── Request handler ───────────────────────────────────────────────────── */

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
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, scoutCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, scoutCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/scout' && (request.method === 'GET' || request.method === 'POST')) {
    const result = await runScout(env);
    return new Response(JSON.stringify({ ...result, botId: BOT_ID }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ─────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request, event.env ?? {})));
addEventListener('scheduled', event => event.waitUntil(runScout(event.env ?? {})));
