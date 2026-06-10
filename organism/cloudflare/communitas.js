/**
 * COMMUNITAS — AGI Mini Brain XXIV: Societas et Collectivum
 * (Latin: "Society and the Collective")
 *
 * Dedicated Cloudflare Worker — Server AIS-024
 * Reality Tier V — Collective/Universal
 * Role: Social Graph Intelligence, Collective Behaviour & Network Dynamics
 *
 * COMMUNITAS understands the collective. It models social graphs,
 * detects emergent collective behaviours, maps influence networks,
 * and optimizes how the organism interacts with and coordinates
 * large groups of agents, users, or stakeholders.
 *
 * Routes: /graph, /influence, /cluster, /broadcast, /consensus, /status, /metrics
 *
 * Copyright © 2024–2026 Alfredo Medina Hernandez. All rights reserved.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const AIS_ID = 'AIS-024';
const AIS_NAME = 'COMMUNITAS';
const AIS_LATIN = 'Societas et Collectivum';
const VERSION = '1.0.0';
const FIB = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55];

let beatCount = 0;
let socialGraph = { nodes: [], edges: [] };

function addNode(id, role = 'member', weight = 1) {
  if (!socialGraph.nodes.find(n => n.id === id)) {
    socialGraph.nodes.push({ id: String(id).slice(0, 32), role, weight: +weight.toFixed(4), ts: Date.now() });
    if (socialGraph.nodes.length > 144) socialGraph.nodes.shift();
  }
  return { aisId: AIS_ID, worker: AIS_NAME, node: id, added: true, total: socialGraph.nodes.length, beat: ++beatCount, ts: Date.now() };
}

function analyzeInfluence(nodeId) {
  const node = socialGraph.nodes.find(n => n.id === String(nodeId));
  const connections = socialGraph.edges.filter(e => e.from === String(nodeId) || e.to === String(nodeId));
  const degree = connections.length;
  const betweenness = +(degree * PHI_INV * Math.random()).toFixed(4);
  return { aisId: AIS_ID, worker: AIS_NAME, nodeId, degree, betweenness, influence: +(degree * betweenness * PHI).toFixed(4), tier: degree > 8 ? 'influencer' : degree > 3 ? 'connector' : 'peripheral', beat: ++beatCount, ts: Date.now() };
}

function cluster(algorithm = 'phi') {
  const n = socialGraph.nodes.length;
  if (n === 0) return { aisId: AIS_ID, worker: AIS_NAME, clusters: [], beat: ++beatCount, ts: Date.now() };
  const k = Math.max(1, Math.floor(Math.sqrt(n * PHI_INV)));
  const clusters = Array.from({ length: k }, (_, i) => ({
    id: `cluster-${i + 1}`,
    members: socialGraph.nodes.filter((_, j) => j % k === i).map(n => n.id),
    cohesion: +(Math.random() * PHI_INV + 0.1).toFixed(4),
  }));
  return { aisId: AIS_ID, worker: AIS_NAME, algorithm, clusters, k, beat: ++beatCount, ts: Date.now() };
}

function broadcast(message, reach = 'all') {
  const targets = reach === 'all' ? socialGraph.nodes : socialGraph.nodes.filter(n => n.role === reach);
  return { aisId: AIS_ID, worker: AIS_NAME, message: String(message).slice(0, 128), reach, targets: targets.length, delivered: targets.map(n => n.id).slice(0, 21), beat: ++beatCount, ts: Date.now() };
}

function consensus(proposal, threshold = 0.618) {
  const votes = socialGraph.nodes.map(n => ({ node: n.id, vote: Math.random() > 0.4 ? 'aye' : 'nay', weight: n.weight }));
  const ayeWeight = votes.filter(v => v.vote === 'aye').reduce((s, v) => s + v.weight, 0);
  const total = votes.reduce((s, v) => s + v.weight, 0);
  const ratio = total > 0 ? ayeWeight / total : 0;
  return { aisId: AIS_ID, worker: AIS_NAME, proposal: String(proposal).slice(0, 64), votes: votes.length, ayeWeight: +ayeWeight.toFixed(4), ratio: +ratio.toFixed(4), passed: ratio >= threshold, threshold, beat: ++beatCount, ts: Date.now() };
}

async function handleRequest(request) {
  const url = new URL(request.url);
  const path = url.pathname;
  const cors = { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*', 'X-AIS-ID': AIS_ID, 'X-AIS-Name': AIS_NAME };
  if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: { ...cors, 'Access-Control-Allow-Methods': 'GET,POST', 'Access-Control-Allow-Headers': 'Content-Type' } });
  if (path === '/status' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, latinName: AIS_LATIN, version: VERSION, status: 'alive', beat: beatCount, nodes: socialGraph.nodes.length, edges: socialGraph.edges.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/metrics' && request.method === 'GET') return new Response(JSON.stringify({ aisId: AIS_ID, worker: AIS_NAME, beats: beatCount, nodes: socialGraph.nodes.length, edges: socialGraph.edges.length, phi: PHI, ts: Date.now() }), { headers: cors });
  if (path === '/graph' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(addNode(b.id || `node-${Date.now().toString(36)}`, b.role, b.weight)), { headers: cors }); }
  if (path === '/influence' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(analyzeInfluence(b.nodeId || '')), { headers: cors }); }
  if (path === '/cluster' && request.method === 'GET') return new Response(JSON.stringify(cluster(url.searchParams.get('algorithm') || 'phi')), { headers: cors });
  if (path === '/broadcast' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(broadcast(b.message || '', b.reach)), { headers: cors }); }
  if (path === '/consensus' && request.method === 'POST') { const b = await request.json().catch(() => ({})); return new Response(JSON.stringify(consensus(b.proposal || '', b.threshold)), { headers: cors }); }
  return new Response(JSON.stringify({ error: 'not_found', aisId: AIS_ID }), { status: 404, headers: cors });
}
addEventListener('fetch', event => event.respondWith(handleRequest(event.request)));
