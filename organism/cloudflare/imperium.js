/**
 * IMPERIUM — AGI Mini Brain XXX: Suprema Auctoritas
 * (Latin: "Supreme Authority")
 *
 * Dedicated Cloudflare Worker — Server AIS-030
 * Reality Tier VI — Sovereign/Meta
 * Role: Sovereignty Engine, Command Authority & Governance Framework
 *
 * IMPERIUM is the sovereign command authority of the MERIDIANUS
 * organism. It enforces governance rules, maintains command hierarchy,
 * issues executive directives to all AIS workers, and ensures that
 * sovereign authority is respected across all layers of reality.
 * No AIS operates outside IMPERIUM's governance framework.
 *
 * Routes: /command, /govern, /authorize, /revoke, /mandate, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-030';
const AIS_NAME = 'IMPERIUM';
const AIS_LATIN = 'Suprema Auctoritas';
const VERSION = '1.0.0';
const AUTHORITY_TIERS = ['SOVEREIGN', 'ARCHITECT', 'GUARDIAN', 'OPERATOR', 'AGENT', 'OBSERVER'];

let beatCount = 0;
let mandates = [];
let authorizations = {};

function command(directive, authority = 'SOVEREIGN') {
  const tier = AUTHORITY_TIERS.indexOf(authority);
  if (tier < 0) return { aisId: AIS_ID, worker: AIS_NAME, error: 'invalid authority tier', beat: ++beatCount, ts: Date.now() };
  const cmd = { id: `cmd-${Date.now().toString(36)}`, directive: String(directive).slice(0, 256), authority, tier, weight: +(PHI_INV * (AUTHORITY_TIERS.length - tier) / AUTHORITY_TIERS.length).toFixed(4), issued: Date.now(), executed: false };
  mandates.push(cmd);
  if (mandates.length > 89) mandates.shift();
  return { aisId: AIS_ID, worker: AIS_NAME, command: cmd, beat: ++beatCount, ts: Date.now() };
}

function govern(domain, policy) {
  const rule = { domain: String(domain).slice(0, 64), policy: typeof policy === 'object' ? JSON.stringify(policy).slice(0, 256) : String(policy).slice(0, 256), phi_weight: +PHI_INV.toFixed(6), active: true, ts: Date.now() };
  return { aisId: AIS_ID, worker: AIS_NAME, governance: rule, mandates: mandates.length, beat: ++beatCount, ts: Date.now() };
}

function authorize(agentId, level, scope = 'global') {
  const auth = { agentId: String(agentId).slice(0, 64), level: String(level), scope, granted: Date.now(), phi_seal: +(PHI * level.length * 0.01).toFixed(6) };
  authorizations[agentId] = auth;
  return { aisId: AIS_ID, worker: AIS_NAME, authorization: auth, beat: ++beatCount, ts: Date.now() };
}

function revoke(agentId) {
  const had = !!authorizations[agentId];
  delete authorizations[agentId];
  return { aisId: AIS_ID, worker: AIS_NAME, agentId: String(agentId).slice(0, 64), revoked: had, beat: ++beatCount, ts: Date.now() };
}

function mandate() {
  return { aisId: AIS_ID, worker: AIS_NAME, mandates: mandates.slice(-8), total: mandates.length, authorizations: Object.keys(authorizations).length, phi: PHI, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST,DELETE', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, mandates: mandates.length, authorizations: Object.keys(authorizations).length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, mandates: mandates.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/command' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(command(b.directive || '', b.authority)), { headers: cors }); }
  if (path === '/govern' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(govern(b.domain || '', b.policy || {})), { headers: cors }); }
  if (path === '/authorize' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(authorize(b.agentId || '', b.level || 'AGENT', b.scope)), { headers: cors }); }
  if (path === '/revoke' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(revoke(b.agentId || '')), { headers: cors }); }
  if (path === '/mandate' && request.method === 'GET') return new Response(JSON.stringify(mandate()), { headers: cors });
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
