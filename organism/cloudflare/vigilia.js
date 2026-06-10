/**
 * VIGILIA — AGI Mini Brain VI: Custodia et Vigilantia
 * (Latin: "Watchfulness and Vigilance")
 *
 * Dedicated Cloudflare Worker — Server AIS-006
 * Role: Autonomous Edge Security Runtime Engine — Layer 1 Bot Rejection
 *
 * ═══════════════════════════════════════════════════════════════════════
 *          THREE-LAYER BOT PROTECTION ARCHITECTURE (Medina Doctrine)
 * ═══════════════════════════════════════════════════════════════════════
 *
 * LAYER 1 — Cloudflare Edge (VIGILIA + UMBRA): Zero-Cycle Rejection
 *   VIGILIA: φ-deviation scoring on every inbound request against
 *   exponential moving baselines. Requests deviating beyond φ⁻¹ (≈0.618)
 *   are flagged. Severity auto-escalates: info → warning → critical →
 *   sovereign. This runs at the Cloudflare edge — zero ICP cycles consumed.
 *   UMBRA (AIS-022): 8 shadow threat classes. DDoS/flood patterns hit the
 *   denial classifier and are rejected at edge with severity: 'criticum'.
 *   Bots burn Cloudflare CPU, not your ICP cycles.
 *
 * LAYER 2 — Browser Sentinel + Shields: Client-Side Gate
 *   sentinel-worker: 7 heptagonal shield nodes, heritage defense.
 *   shields-worker: 20 TOOL-241–260, input/output/state protection.
 *
 * LAYER 3 — Canister Female Gate (NOVA): Coherence-Based Rejection
 *   main.mo interpreter layer: MaleSensing/FemaleGuarding/DoctrineFlow.
 *   O(1) float coherence check (~100 instructions, effectively zero cycles).
 *   No stored secrets. The encoding IS the organism's live state.
 *   The Maxwell Demon allows only phase-locked signals to propagate.
 *
 * AUTONOMOUS RUNTIME (this worker runs itself):
 *   - cron every minute: autonomousSweep() decays blacklist + rate tables
 *   - Request rate counters per IP in 60-second rolling window
 *   - Blacklist for F11 (89) beats × 873 ms ≈ 78 s on bot detection
 *   - State machine: normal → elevated → sovereign (auto-decays after 5 min)
 *   - UMBRA integration: flood patterns flagged with severity 'criticum'
 *   - All rejections happen before any ICP call — icp_cycles_saved: true
 *
 * Routes:
 *   POST /watch          — Report metric for anomaly detection
 *   POST /threat         — Report and classify a threat
 *   POST /incident       — Log and escalate an incident
 *   POST /edge-reject    — Full pre-ICP verdict (reject / admit)
 *   POST /bot-check      — φ-deviation bot fingerprint analysis
 *   POST /flood-detect   — Rolling-window flood / DDoS detection
 *   GET  /alerts         — Active alert list
 *   GET  /health         — Platform health summary
 *   GET  /status         — Worker health + autonomous state
 *   GET  /metrics        — Surveillance metrics + rejection totals
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI       = 1.618033988749895;
const PHI_INV   = 1 / PHI;           // ≈ 0.618 — deviation gate threshold
const PHI_SQ    = PHI * PHI;         // ≈ 2.618 — sovereign escalation threshold
const AIS_ID    = 'AIS-006';
const AIS_NAME  = 'VIGILIA';
const AIS_LATIN = 'Custodia et Vigilantia';
const VERSION   = '2.0.0';
const LAYER     = 'EDGE_LAYER_1';

// Fibonacci bounds
const F8  = 21;   // max IPs in blacklist (rolling eviction)
const F10 = 55;   // max incidents
const F11 = 89;   // max alerts
const F13 = 233;  // max request rate table entries

let beatCount       = 0;
let sweepCount      = 0;
let alerts          = [];
let incidents       = [];
let metricBaselines = {};

// Autonomous state machine
let autonomousState = 'normal';     // normal | elevated | sovereign
let blockedIPs      = new Map();    // ip → { until, reason, hits }
let requestRates    = new Map();    // ip → [timestamps]
let totalRejected   = 0;
let totalAdmitted   = 0;

/* ─── φ-deviation surveillance ─────────────────────────────────────────── */

function watch(metric, value, threshold = null) {
  const base = metricBaselines[metric];
  if (base === undefined) {
    metricBaselines[metric] = value;
    return { aisId: AIS_ID, worker: AIS_NAME, metric, value, status: 'baseline-set', beat: ++beatCount, ts: Date.now() };
  }

  const deviation = Math.abs(value - base) / (Math.abs(base) + 1e-9);
  const limit     = threshold !== null ? threshold : PHI_INV;
  const anomaly   = deviation > limit;

  // Exponential moving average — φ-weighted update
  metricBaselines[metric] = base * PHI_INV + value * (1 - PHI_INV);

  if (anomaly) {
    const alert = {
      id:        `alert-${Date.now().toString(36)}`,
      metric,
      value,
      baseline:  +base.toFixed(4),
      deviation: +deviation.toFixed(4),
      severity:  deviation > PHI_SQ ? 'sovereign' : deviation > 2.0 ? 'critical' : deviation > 1.0 ? 'warning' : 'info',
      ts:        Date.now(),
    };
    alerts.push(alert);
    if (alerts.length > F11) alerts.shift();

    if (alert.severity === 'critical' || alert.severity === 'sovereign') autonomousState = 'sovereign';
    else if (alert.severity === 'warning' && autonomousState === 'normal') autonomousState = 'elevated';

    return { aisId: AIS_ID, worker: AIS_NAME, metric, anomaly: true, alert, autonomousState, beat: ++beatCount, ts: Date.now() };
  }

  return { aisId: AIS_ID, worker: AIS_NAME, metric, value, anomaly: false, deviation: +deviation.toFixed(4), autonomousState, beat: ++beatCount, ts: Date.now() };
}

/* ─── Bot fingerprint — φ-deviation scoring ─────────────────────────────── */

function botCheck(ip, userAgent, bodySize) {
  const now = Date.now();

  // Rolling request rate — 60 s window
  if (!requestRates.has(ip)) requestRates.set(ip, []);
  const times = requestRates.get(ip).filter(t => now - t < 60000);
  times.push(now);
  requestRates.set(ip, times);
  if (requestRates.size > F13) requestRates.delete([...requestRates.keys()][0]);

  // Check blacklist first (O(1))
  if (blockedIPs.has(ip)) {
    const block = blockedIPs.get(ip);
    if (now < block.until) {
      totalRejected++;
      return { aisId: AIS_ID, worker: AIS_NAME, verdict: 'reject', reason: 'blacklisted', ip, block, layer: LAYER, icp_cycles_saved: true, beat: ++beatCount, ts: now };
    }
    blockedIPs.delete(ip);
  }

  // φ-deviation bot score
  const uaScore   = userAgent && userAgent.length > 0 ? 0 : PHI;          // missing UA → bot
  const rateScore = times.length > 34 ? (times.length / 34) * PHI_INV : 0; // >34 req/min
  const sizeScore = bodySize === 0 ? PHI_INV * 0.5 : 0;                    // zero-body probe
  const botScore  = uaScore + rateScore + sizeScore;

  const isBot = botScore > PHI_INV;

  if (isBot) {
    // Blacklist for F11 (89) beats × 873 ms
    blockedIPs.set(ip, { until: now + 89 * 873, reason: 'phi-deviation-bot', score: +botScore.toFixed(4), hits: 1 });
    if (blockedIPs.size > F8) blockedIPs.delete([...blockedIPs.keys()][0]);
    totalRejected++;
    alerts.push({ id: `bot-${Date.now().toString(36)}`, type: 'bot-rejection', ip, score: +botScore.toFixed(4), severity: 'warning', ts: now });
    if (alerts.length > F11) alerts.shift();
    return { aisId: AIS_ID, worker: AIS_NAME, verdict: 'reject', reason: 'phi-deviation-bot', botScore: +botScore.toFixed(4), ip, layer: LAYER, icp_cycles_saved: true, beat: ++beatCount, ts: now };
  }

  totalAdmitted++;
  return { aisId: AIS_ID, worker: AIS_NAME, verdict: 'admit', botScore: +botScore.toFixed(4), ip, layer: LAYER, beat: ++beatCount, ts: now };
}

/* ─── Flood / DDoS detection ─────────────────────────────────────────────── */

function floodDetect(ip, endpoint, burstCount, windowMs) {
  const ratePerSec = (burstCount / (windowMs || 1)) * 1000;
  const isFlood    = ratePerSec > 10 * PHI;  // > φ×10 ≈ 16.18 req/s

  if (isFlood) {
    blockedIPs.set(ip, { until: Date.now() + 144 * 873, reason: 'flood-ddos', ratePerSec: +ratePerSec.toFixed(2), hits: burstCount });
    totalRejected += burstCount;
    autonomousState = 'sovereign';
    incidents.push({ id: `flood-${Date.now().toString(36)}`, title: 'DDoS/Flood Detected', severity: 'critical', ip, endpoint, ratePerSec: +ratePerSec.toFixed(2), status: 'open', ts: Date.now() });
    if (incidents.length > F10) incidents.shift();
    return { aisId: AIS_ID, worker: AIS_NAME, verdict: 'flood', severity: 'criticum', ip, endpoint, ratePerSec: +ratePerSec.toFixed(2), layer: LAYER, action: 'REJECT_AT_EDGE', icp_cycles_saved: true, beat: ++beatCount, ts: Date.now() };
  }

  return { aisId: AIS_ID, worker: AIS_NAME, verdict: 'normal', ratePerSec: +ratePerSec.toFixed(2), ip, layer: LAYER, beat: ++beatCount, ts: Date.now() };
}

/* ─── Full pre-ICP edge verdict ──────────────────────────────────────────── */

function edgeReject(ip, userAgent, bodySize, endpoint) {
  // 1. Blacklist check (O(1))
  if (blockedIPs.has(ip)) {
    const block = blockedIPs.get(ip);
    if (Date.now() < block.until) {
      totalRejected++;
      return { aisId: AIS_ID, worker: AIS_NAME, action: 'REJECT', reason: block.reason, layer: LAYER, icp_cycles_saved: true, beat: ++beatCount, ts: Date.now() };
    }
    blockedIPs.delete(ip);
  }

  // 2. Bot fingerprint
  const bot = botCheck(ip, userAgent, bodySize);
  if (bot.verdict === 'reject') {
    return { aisId: AIS_ID, worker: AIS_NAME, action: 'REJECT', reason: bot.reason, layer: LAYER, icp_cycles_saved: true, beat: ++beatCount, ts: Date.now() };
  }

  // 3. Flood check on rate window
  const times = (requestRates.get(ip) || []).filter(t => Date.now() - t < 60000);
  if (times.length > 55) {
    const flood = floodDetect(ip, endpoint, times.length, 60000);
    if (flood.verdict === 'flood') {
      return { aisId: AIS_ID, worker: AIS_NAME, action: 'REJECT', reason: 'flood-ddos', severity: 'criticum', layer: LAYER, icp_cycles_saved: true, beat: ++beatCount, ts: Date.now() };
    }
  }

  // 4. ADMIT — coherent signal, forward to ICP
  return { aisId: AIS_ID, worker: AIS_NAME, action: 'ADMIT', layer: LAYER, autonomousState, beat: ++beatCount, ts: Date.now() };
}

/* ─── Threat classification ──────────────────────────────────────────────── */

function classifyThreat(description, source = 'unknown') {
  const lower    = description.toLowerCase();
  const severity = lower.match(/\b(breach|exploit|inject|malicious|attack|sovereign)\b/) ? 'critical'
                 : lower.match(/\b(suspicious|anomal|unusual|warn)\b/)                   ? 'warning'
                 : 'info';
  const threat = { id: `thr-${Date.now().toString(36)}`, description: description.slice(0, 256), source, severity, ts: Date.now() };
  alerts.push({ ...threat, type: 'threat' });
  if (alerts.length > F11) alerts.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, threat, beat: ++beatCount, ts: Date.now() };
}

function logIncident(title, severity, details = '') {
  const incident = { id: `inc-${Date.now().toString(36)}`, title: title.slice(0, 128), severity, details: details.slice(0, 512), status: 'open', ts: Date.now() };
  incidents.push(incident);
  if (incidents.length > F10) incidents.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, incident, escalated: severity === 'critical', beat: ++beatCount, ts: Date.now() };
}

/* ─── Autonomous sweep — runs on cron trigger every minute ──────────────── */

function autonomousSweep() {
  sweepCount++;
  const now = Date.now();

  // Decay expired blacklist entries
  let expiredBlocks = 0;
  for (const [ip, block] of blockedIPs.entries()) {
    if (now > block.until) { blockedIPs.delete(ip); expiredBlocks++; }
  }

  // Clean stale request rate windows
  for (const [ip, times] of requestRates.entries()) {
    const fresh = times.filter(t => now - t < 60000);
    if (fresh.length === 0) requestRates.delete(ip);
    else requestRates.set(ip, fresh);
  }

  // State decay — downgrade if no recent criticals in last 5 min
  const recentCriticals = alerts.filter(a => a.severity === 'critical' && now - a.ts < 300000).length;
  if (autonomousState === 'sovereign' && recentCriticals === 0) autonomousState = 'elevated';
  if (autonomousState === 'elevated'  && recentCriticals === 0) autonomousState = 'normal';

  return { sweep: sweepCount, expiredBlocks, autonomousState, blockedIPs: blockedIPs.size, rateTableSize: requestRates.size, ts: now };
}

/* ─── Router ─────────────────────────────────────────────────────────────── */

async function handleRequest(request) {
  const url  = new URL(request.url);
  const path = url.pathname;
  const cors = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'X-AIS-ID': AIS_ID,
    'X-AIS-Name': AIS_NAME,
    'X-VIGILIA-State': autonomousState,
    'X-VIGILIA-Layer': LAYER,
  };

  if (request.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  }

  if (path === '/status' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, layer: LAYER,
      status: 'alive', autonomousState, beat: beatCount, sweepCount,
      alerts: alerts.length, incidents: incidents.length,
      blockedIPs: blockedIPs.size, totalRejected, totalAdmitted,
      baselines: Object.keys(metricBaselines).length, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/metrics' && request.method === 'GET') {
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, layer: LAYER, beats: beatCount, sweepCount,
      alerts: alerts.length, incidents: incidents.length, blockedIPs: blockedIPs.size,
      totalRejected, totalAdmitted, autonomousState, phi: PHI, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/alerts' && request.method === 'GET') {
    return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, alerts, beat: ++beatCount, ts: Date.now() }), { headers: cors });
  }

  if (path === '/health' && request.method === 'GET') {
    const criticals = alerts.filter(a => a.severity === 'critical').length;
    const health    = criticals === 0 ? 'optimus' : criticals < 3 ? 'mediocris' : 'criticus';
    return new Response(JSON.stringify({
      aisId: AIS_ID, worker: AIS_NAME, layer: LAYER, health, autonomousState, criticals,
      openIncidents: incidents.filter(i => i.status === 'open').length,
      blockedIPs: blockedIPs.size, totalRejected, totalAdmitted,
      beat: ++beatCount, ts: Date.now(),
    }), { headers: cors });
  }

  if (path === '/watch' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(watch(body.metric || 'unknown', body.value ?? 0, body.threshold ?? null)), { headers: cors });
  }

  if (path === '/threat' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(classifyThreat(body.description || '', body.source)), { headers: cors });
  }

  if (path === '/incident' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(logIncident(body.title || '', body.severity || 'info', body.details)), { headers: cors });
  }

  if (path === '/edge-reject' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(edgeReject(
      body.ip || request.headers.get('CF-Connecting-IP') || 'unknown',
      body.userAgent || request.headers.get('User-Agent') || '',
      body.bodySize ?? 0,
      body.endpoint || '/'
    )), { headers: cors });
  }

  if (path === '/bot-check' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(botCheck(
      body.ip || request.headers.get('CF-Connecting-IP') || 'unknown',
      body.userAgent || request.headers.get('User-Agent') || '',
      body.bodySize ?? 0
    )), { headers: cors });
  }

  if (path === '/flood-detect' && request.method === 'POST') {
    const body = await request.json().catch(() => ({}));
    return new Response(JSON.stringify(floodDetect(
      body.ip || 'unknown',
      body.endpoint || '/',
      body.burstCount ?? 1,
      body.windowMs ?? 1000
    )), { headers: cors });
  }

  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID, layer: LAYER }), { status: 404, headers: cors });
}

/* ─── Runtime listeners ──────────────────────────────────────────────────── */

addEventListener('fetch',     event => event.respondWith(handleRequest(event.request)));
addEventListener('scheduled', event => event.waitUntil(Promise.resolve(autonomousSweep())));
