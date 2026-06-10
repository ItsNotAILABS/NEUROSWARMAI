/**
 * FORTUNA — AGI Mini Brain XXV: Oeconomia et Valor
 * (Latin: "Economy and Value")
 *
 * Dedicated Cloudflare Worker — Server AIS-025
 * Reality Tier V — Collective/Universal
 * Role: Economic Value Intelligence, Token Flow & Wealth Dynamics
 *
 * FORTUNA governs value. It tracks FORMA token flows, models economic
 * equilibria, calculates fair value for any exchange, detects arbitrage
 * opportunities, and maintains the sovereign economic intelligence
 * of the MERIDIANUS organism. Wealth is information — FORTUNA reads it.
 *
 * Routes: /value, /flow, /equilibrium, /arbitrage, /wealth, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-025';
const AIS_NAME = 'FORTUNA';
const AIS_LATIN = 'Oeconomia et Valor';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89];

let beatCount = 0;
let ledger = [];  // value flows

function assessValue(asset, context = {}) {
  const str = JSON.stringify({ asset, context });
  const hash = str.split('').reduce((h, c) => (h * 31 + c.charCodeAt(0)) & 0xffffff, 0);
  const intrinsic = +((hash / 0xffffff) * PHI).toFixed(4);
  const market = +(intrinsic * (1 + (Math.random() - 0.5) * PHI_INV)).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, asset: String(asset).slice(0, 64), intrinsic, market, premium: +(market - intrinsic).toFixed(4), fair: Math.abs(market - intrinsic) < 0.05, beat: ++beatCount, ts: Date.now() };
}

function recordFlow(from, to, amount, token = 'FORMA') {
  const entry = { id: `flow-${Date.now().toString(36)}`, from: String(from).slice(0, 32), to: String(to).slice(0, 32), amount: +amount.toFixed(4), token, phi_weight: +PHI_INV.toFixed(6), ts: Date.now() };
  ledger.push(entry);
  if (ledger.length > FIB[8]) ledger.shift();  // max 34
  return { aisId: AIS_ID, worker: AIS_NAME, flow: entry, ledgerSize: ledger.length, beat: ++beatCount, ts: Date.now() };
}

function equilibrium(supply, demand) {
  const price = demand > 0 ? +(supply / demand * PHI_INV).toFixed(4) : 0;
  const surplus = supply - demand;
  const state = Math.abs(surplus) < 0.05 ? 'aequilibrium' : surplus > 0 ? 'superabundantia' : 'deficientia';
  return { aisId: AIS_ID, worker: AIS_NAME, supply, demand, price, surplus: +surplus.toFixed(4), state, beat: ++beatCount, ts: Date.now() };
}

function arbitrage(markets) {
  if (!Array.isArray(markets) || markets.length < 2) return { aisId: AIS_ID, worker: AIS_NAME, error: 'need ≥2 markets', beat: ++beatCount, ts: Date.now() };
  const sorted = [...markets].sort((a, b) => (a.price || 0) - (b.price || 0));
  const spread = (sorted[sorted.length - 1].price || 0) - (sorted[0].price || 0);
  return { aisId: AIS_ID, worker: AIS_NAME, markets: markets.length, buy: sorted[0], sell: sorted[sorted.length - 1], spread: +spread.toFixed(4), profitable: spread * PHI_INV > 0.01, beat: ++beatCount, ts: Date.now() };
}

function wealth(agent) {
  const flows = ledger.filter(f => f.from === String(agent) || f.to === String(agent));
  const inflow = flows.filter(f => f.to === String(agent)).reduce((s, f) => s + f.amount, 0);
  const outflow = flows.filter(f => f.from === String(agent)).reduce((s, f) => s + f.amount, 0);
  const net = +(inflow - outflow).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, agent: String(agent).slice(0, 32), inflow: +inflow.toFixed(4), outflow: +outflow.toFixed(4), net, phi_wealth: +(net * PHI_INV).toFixed(4), beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, ledgerSize: ledger.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, ledgerSize: ledger.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/value' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(assessValue(b.asset || '', b.context)), { headers: cors }); }
  if (path === '/flow' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(recordFlow(b.from || '', b.to || '', b.amount || 0, b.token)), { headers: cors }); }
  if (path === '/equilibrium' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(equilibrium(b.supply || 1, b.demand || 1)), { headers: cors }); }
  if (path === '/arbitrage' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(arbitrage(b.markets || [])), { headers: cors }); }
  if (path === '/wealth' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(wealth(b.agent || '')), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
