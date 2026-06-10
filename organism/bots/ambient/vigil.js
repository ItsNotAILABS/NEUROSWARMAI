/**
 * VIGIL — Organism Ambient Bot I: Telegram Pulse Monitor
 * (Latin: "Watchman")
 *
 * Cloudflare Worker — BOT-AMB-001
 * Platform: Telegram
 * Trigger: Cron — every hour (0 * * * *)
 * Role: Checks canister cycle balance and organism health every hour.
 *       Sends a Telegram alert if cycles are low or any AIS brain is
 *       unreachable. Also accepts on-demand GET /pulse for manual checks.
 *
 * Routes:
 *   GET /pulse             — Manual health check → Telegram message
 *   GET /status            — Worker self-health check
 *   GET /metrics           — Beat count + alert metrics
 *
 * Environment variables (Cloudflare Worker secrets):
 *   TELEGRAM_BOT_TOKEN     — From @BotFather
 *   TELEGRAM_CHAT_ID       — Your personal or group chat ID
 *   AIS_FLEET_URL          — AIS fleet index worker URL (optional)
 *   ICP_CANISTER_URL       — Organism canister URL (optional)
 *   CYCLE_LOW_THRESHOLD    — Cycle balance below which to alert (default: 0.5T)
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

import { sendTelegram, buildStatusMessage, escapeMd } from '../shared/telegram.js';

const PHI      = 1.618033988749895;
const PHI_INV  = 1 / PHI;
const BOT_ID   = 'BOT-AMB-001';
const BOT_NAME = 'VIGIL';
const BOT_LATIN= 'Vigil Perpetuus';
const VERSION  = '1.0.0';

// Alert if cycles drop below 0.5T (configurable via CYCLE_LOW_THRESHOLD env)
const DEFAULT_CYCLE_THRESHOLD = 5e11;

let beatCount  = 0;
let sweepCount = 0;
let alertsSent = 0;

/* ─── Health check logic ────────────────────────────────────────────────── */

async function collectHealth(env) {
  const health = {
    ts:       Date.now(),
    phi:      PHI,
    status:   'alive',
    cycles:   null,
    workers:  69,
    alerts:   [],
  };

  if (env?.AIS_FLEET_URL) {
    try {
      const res  = await fetch(`${env.AIS_FLEET_URL}/fleet/status`, { headers: { 'X-Bot-ID': BOT_ID } });
      const data = await res.json();
      health.workers = data.workers ?? 69;
      health.cycles  = data.canisterCycles ?? null;
      health.status  = data.status ?? 'alive';
    } catch {
      health.alerts.push('AIS fleet unreachable');
    }
  }

  // Check cycle threshold
  const threshold = parseInt(env?.CYCLE_LOW_THRESHOLD || DEFAULT_CYCLE_THRESHOLD, 10);
  if (health.cycles !== null && health.cycles < threshold) {
    health.alerts.push(`⚠️ Cycles low: ${(health.cycles / 1e12).toFixed(3)}T (threshold: ${(threshold / 1e12).toFixed(3)}T)`);
  }

  return health;
}

/* ─── Build Telegram pulse message ─────────────────────────────────────── */

function buildPulseMessage(health) {
  const statusIcon  = health.status === 'alive' ? '🟢' : '🔴';
  const cyclesStr   = health.cycles !== null ? `${(health.cycles / 1e12).toFixed(3)}T` : 'N/A';
  const alertStr    = health.alerts.length
    ? `\n\n⚠️ *Alerts \\(${escapeMd(String(health.alerts.length))}\\):*\n${health.alerts.map(a => `• ${escapeMd(a)}`).join('\n')}`
    : '';

  return buildStatusMessage(
    `${statusIcon} VIGIL Organism Pulse`,
    {
      Status:        health.status,
      'AIS Workers': String(health.workers),
      Cycles:        cyclesStr,
      'φ':           PHI.toFixed(6),
      Sweep:         String(++sweepCount),
    },
    `BOT\\-AMB\\-001 VIGIL | ${escapeMd(new Date(health.ts).toUTCString())}`
  ) + alertStr;
}

/* ─── Autonomous sweep (cron trigger) ──────────────────────────────────── */

async function autonomousSweep(env) {
  beatCount++;
  const health  = await collectHealth(env);
  const message = buildPulseMessage(health);
  const result  = await sendTelegram(message, env);

  if (result.ok) alertsSent++;
  return { sweep: sweepCount, alerts: health.alerts.length, telegramOk: result.ok, beat: beatCount };
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
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, latinName: BOT_LATIN, version: VERSION,
      status: 'alive', beat: beatCount, sweepCount, alertsSent, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      botId: BOT_ID, worker: BOT_NAME, beats: beatCount, sweepCount, alertsSent, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/pulse' && request.method === 'GET') {
    const result = await autonomousSweep(env);
    return new Response(JSON.stringify({ ...result, botId: BOT_ID }), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', botId: BOT_ID }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ─────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request, event.env ?? {})));
addEventListener('scheduled', event => event.waitUntil(autonomousSweep(event.env ?? {})));
