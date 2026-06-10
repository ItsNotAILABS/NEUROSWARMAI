/**
 * PRAECO — Organism Ambient Bot II: Pushover Release Herald
 * (Latin: "Town Crier / Herald")
 *
 * Cloudflare Worker — BOT-AMB-002
 * Platform: Pushover (iOS, Android, Desktop)
 * Trigger: Webhook — called by GitHub Actions on release/deploy events
 *          Cron    — every 8 hours for periodic organism digest
 * Role: Pushes instant release and deploy notifications to your devices.
 *       Receives GitHub webhook events (release published, workflow run
 *       completed) and sends high-priority Pushover notifications.
 *
 * Routes:
 *   POST /notify           — Accept a JSON notification payload
 *   POST /github           — GitHub webhook endpoint (release/workflow_run)
 *   GET  /digest           — Manual trigger → send 8h organism digest
 *   GET  /status           — Worker self-health check
 *   GET  /metrics          — Beat count + notification metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   PUSHOVER_APP_TOKEN     — From pushover.net/apps
 *   PUSHOVER_USER_KEY      — Your Pushover user/group key
 *   GITHUB_WEBHOOK_SECRET  — Optional: HMAC secret to verify GitHub webhooks
 *   AIS_FLEET_URL          — AIS fleet index worker URL (optional)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { sendPushover, PRIORITY, SOUND } from '../shared/pushover.js';

const PHI      = 1.618033988749895;
const BOT_ID   = 'BOT-AMB-002';
const BOT_NAME = 'PRAECO';
const BOT_LATIN= 'Praeco Nuntii';
const VERSION  = '1.0.0';

let beatCount    = 0;
let notifCount   = 0;
let digestCount  = 0;

/* ─── GitHub webhook signature verification ────────────────────────────── */

async function verifyGitHubWebhook(request, secret) {
  if (!secret) return true; // skip if no secret configured

  const sig     = request.headers.get('x-hub-signature-256') || '';
  const body    = await request.text();
  const encoder = new TextEncoder();
  const keyData = encoder.encode(secret);
  const msgData = encoder.encode(body);

  const key     = await crypto.subtle.importKey('raw', keyData, { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const sigBuf  = await crypto.subtle.sign('HMAC', key, msgData);
  const sigHex  = 'sha256=' + Array.from(new Uint8Array(sigBuf)).map(b => b.toString(16).padStart(2, '0')).join('');

  // Constant-time comparison
  if (sig.length !== sigHex.length) return false;
  let diff = 0;
  for (let i = 0; i < sig.length; i++) diff |= sig.charCodeAt(i) ^ sigHex.charCodeAt(i);
  return diff === 0;
}

/* ─── Parse GitHub event → notification payload ─────────────────────────── */

function parseGitHubEvent(eventType, payload) {
  if (eventType === 'release') {
    const rel = payload.release || {};
    return {
      title:    `🚀 MERIDIANUS Release ${rel.tag_name || 'unknown'}`,
      message:  `${rel.name || 'New release'}\n${(rel.body || '').slice(0, 200)}`,
      priority: PRIORITY.HIGH,
      sound:    SOUND.COSMIC,
      url:      rel.html_url,
      url_title:'View Release',
    };
  }

  if (eventType === 'workflow_run') {
    const run    = payload.workflow_run || {};
    const status = run.conclusion || run.status || 'unknown';
    const ok     = status === 'success';
    return {
      title:    `${ok ? '✅' : '❌'} Deploy ${status}: ${run.name || 'workflow'}`,
      message:  `Branch: ${run.head_branch || 'unknown'}\nCommit: ${(run.head_sha || '').slice(0, 7)}`,
      priority: ok ? PRIORITY.NORMAL : PRIORITY.HIGH,
      sound:    ok ? SOUND.MAGIC : SOUND.SIREN,
      url:      run.html_url,
      url_title:'View Run',
    };
  }

  return {
    title:    `📡 MERIDIANUS Event: ${eventType}`,
    message:  JSON.stringify(payload).slice(0, 400),
    priority: PRIORITY.NORMAL,
  };
}

/* ─── Organism digest (8h summary) ─────────────────────────────────────── */

async function sendDigest(env) {
  digestCount++;
  beatCount++;
  const now = new Date().toUTCString();
  const msg = [
    `MERIDIANUS Organism — 8h Digest #${digestCount}`,
    `Workers: 69 AIS + 35 Web`,
    `φ: ${PHI.toFixed(6)}`,
    `Beat: ${beatCount}`,
    `Notifs sent: ${notifCount}`,
    `Time: ${now}`,
  ].join('\n');

  return sendPushover(msg, '🛰️ PRAECO Digest', env, { priority: PRIORITY.NORMAL, sound: SOUND.PUSHOVER });
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
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type,x-hub-signature-256' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, notifCount, digestCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, notifCount, digestCount, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/digest' && request.method === 'GET') {
    const result = await sendDigest(env);
    return new Response(JSON.stringify({ ...result, botId: BOT_ID, digestCount }), { headers: cors });
  }

  if (path === '/notify' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    beatCount++;
    notifCount++;
    const result = await sendPushover(
      (body.message || 'MERIDIANUS notification').slice(0, 1024),
      (body.title   || 'PRAECO').slice(0, 250),
      env,
      { priority: body.priority ?? PRIORITY.NORMAL, sound: body.sound ?? '' }
    );
    return new Response(JSON.stringify({ ...result, botId: BOT_ID, notifCount }), { headers: cors });
  }

  if (path === '/github' && request.method === 'POST') {
    const cloned    = request.clone();
    const verified  = await verifyGitHubWebhook(cloned, env?.GITHUB_WEBHOOK_SECRET);
    if (!verified) {
      return new Response(JSON.stringify({ error: 'invalid_signature', botId: BOT_ID }), { status: 403, headers: cors });
    }

    const eventType = request.headers.get('x-github-event') || 'unknown';
    const body      = await request.json().catch(() => ({}));
    const notif     = parseGitHubEvent(eventType, body);

    beatCount++;
    notifCount++;
    const result = await sendPushover(notif.message, notif.title, env, {
      priority:  notif.priority,
      sound:     notif.sound,
      url:       notif.url,
      url_title: notif.url_title,
    });

    return new Response(JSON.stringify({ ...result, botId: BOT_ID, event: eventType, notifCount }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ─────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request, event.env ?? {})));
addEventListener('scheduled', event => event.waitUntil(sendDigest(event.env ?? {})));
