// nova/runtime/nova-runtime.js
// Nova Native Runtime — The Sovereign Tool Chain Runtime
// Serves all 4 agents, all 27 workflows, all 20 tools, all 15 AIS via native HTTP
// φ-beat heartbeat at 873ms (1000×φ⁻¹)
// Brand: Nova by FreddyCreates
//
// Usage: node nova/runtime/nova-runtime.js
// Port:  8973 (φ-harmonic: 8+9+7+3=27=3³, 89+73=162≈100φ)

import { createServer } from 'http';
import { readFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT  = join(__dir, '../..');
const PORT  = parseInt(process.env.NOVA_PORT) || 8973;
const HOST  = process.env.NOVA_HOST || '0.0.0.0';

const PHI       = 1.618033988749895;
const PHI_INV   = 0.6180339887498949;
const PHI_BEAT  = 873; // ms

// ─── LAZY REGISTRY ────────────────────────────────────────────────────────
let _registry = null;
async function getRegistry() {
  if (!_registry) {
    const mod = await import('../registry/index.js');
    _registry = mod.default;
    _registry.load();
  }
  return _registry;
}

// ─── LAZY AIS LOADERS ──────────────────────────────────────────────────────
const AIS_MODULES = {};
async function getAIS(name) {
  const key = name.toLowerCase().replace(/-nova$/,'');
  if (!AIS_MODULES[key]) {
    const paths = {
      'animus': '../ais/animus-nova.js',
      'lingua': '../ais/lingua-nova.js',
      'optica': '../ais/optica-nova.js',
      'tactus': '../ais/tactus-nova.js',
      'nexus':  '../ais/nexus-nova.js',
    };
    const p = paths[key];
    if (!p) return null;
    AIS_MODULES[key] = await import(p);
  }
  return AIS_MODULES[key];
}

// ─── AGENTS ───────────────────────────────────────────────────────────────
const AGENTS = {
  'sovereign':  { name:'SOVEREIGN',  version:'3.0', sections:14, model:'claude-sonnet-4-5', path:'.github/agents/sovereign.md'  },
  'meridianus': { name:'MERIDIANUS', version:'2.0', sections:6,  model:'claude-sonnet-4-5', path:'.github/agents/meridianus.md' },
  'organism':   { name:'ORGANISM',   version:'2.0', sections:5,  model:'claude-sonnet-4-5', path:'.github/agents/organism.md'   },
  'magister':   { name:'MAGISTER',   version:'1.0', sections:4,  model:'claude-sonnet-4-5', path:'.github/agents/magister.md'   },
};

// ─── RESPONSE HELPERS ──────────────────────────────────────────────────────
function json(res, data, status = 200) {
  const body = JSON.stringify(data, null, 2);
  res.writeHead(status, {
    'Content-Type':  'application/json',
    'X-Nova-Phi':    String(PHI),
    'X-Nova-Brand':  'Nova',
    'X-Nova-Beat':   String(PHI_BEAT),
    'X-Powered-By':  'nova-runtime@F12',
    'Access-Control-Allow-Origin': '*',
  });
  res.end(body);
}

function sse(res) {
  res.writeHead(200, {
    'Content-Type':  'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection':    'keep-alive',
    'X-Nova-Phi':    String(PHI),
    'X-Nova-Brand':  'Nova',
    'Access-Control-Allow-Origin': '*',
  });
  return {
    send: (data, event = 'nova') => res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`),
    beat: () => res.write(`event: phi-beat\ndata: ${JSON.stringify({ phi:PHI, ts:Date.now(), beat_ms:PHI_BEAT })}\n\n`),
    end:  () => res.end(),
  };
}

async function parseBody(req) {
  return new Promise((resolve) => {
    let body = '';
    req.on('data', chunk => body += chunk);
    req.on('end', () => {
      try { resolve(JSON.parse(body || '{}')); }
      catch { resolve({}); }
    });
  });
}

function notFound(res, msg = 'Not found') {
  json(res, { error: msg, phi: PHI }, 404);
}

// ─── ROUTER ───────────────────────────────────────────────────────────────
async function router(req, res) {
  const url    = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
  const path   = url.pathname;
  const method = req.method;

  // CORS preflight
  if (method === 'OPTIONS') {
    res.writeHead(204, { 'Access-Control-Allow-Origin':'*', 'Access-Control-Allow-Methods':'GET,POST,OPTIONS', 'Access-Control-Allow-Headers':'Content-Type' });
    return res.end();
  }

  // ── GET /health ─────────────────────────────────────────────────────────
  if (path === '/health' && method === 'GET') {
    return json(res, {
      status:    'NOVA_LIVE',
      brand:     'Nova',
      phi:       PHI,
      phi_beat:  PHI_BEAT,
      port:      PORT,
      uptime_s:  process.uptime().toFixed(1),
      tools:     20, ais: 15, agents: 4, workflows: 27,
      ts:        new Date().toISOString(),
    });
  }

  // ── GET /phi-beat ────────────────────────────────────────────────────────
  if (path === '/phi-beat' && method === 'GET') {
    const stream = sse(res);
    const t = Date.now();
    let i = 0;
    const id = setInterval(() => {
      stream.beat();
      if (++i >= 89) { clearInterval(id); stream.end(); } // F11 = 89 beats
    }, PHI_BEAT);
    req.on('close', () => clearInterval(id));
    return;
  }

  // ── GET /tools ───────────────────────────────────────────────────────────
  if (path === '/tools' && method === 'GET') {
    const reg = await getRegistry();
    return json(res, { tools: reg.listTools(), count: reg.listTools().length, phi: PHI });
  }

  // ── GET /tools/:name ─────────────────────────────────────────────────────
  const toolGet = path.match(/^\/tools\/([^\/]+)$/);
  if (toolGet && method === 'GET') {
    const reg  = await getRegistry();
    const tool = reg.get(toolGet[1]);
    if (!tool) return notFound(res, `Tool '${toolGet[1]}' not found`);
    return json(res, tool);
  }

  // ── POST /tools/:name/call ────────────────────────────────────────────────
  const toolCall = path.match(/^\/tools\/([^\/]+)\/call$/);
  if (toolCall && method === 'POST') {
    const payload = await parseBody(req);
    const reg     = await getRegistry();
    try {
      const result = await reg.call(toolCall[1], payload);
      return json(res, result);
    } catch(e) {
      return json(res, { error: e.message, phi: PHI }, 400);
    }
  }

  // ── GET /ais ─────────────────────────────────────────────────────────────
  if (path === '/ais' && method === 'GET') {
    const reg = await getRegistry();
    return json(res, { ais: reg.listAIS(), count: reg.listAIS().length, phi: PHI });
  }

  // ── POST /ais/:name/query ─────────────────────────────────────────────────
  const aisQuery = path.match(/^\/ais\/([^\/]+)\/query$/);
  if (aisQuery && method === 'POST') {
    const payload = await parseBody(req);
    const mod     = await getAIS(aisQuery[1]);
    if (!mod) return notFound(res, `AIS '${aisQuery[1]}' not found`);
    try {
      const result = await mod.default(payload);
      return json(res, result);
    } catch(e) {
      return json(res, { error: e.message, phi: PHI }, 500);
    }
  }

  // ── GET /agents ───────────────────────────────────────────────────────────
  if (path === '/agents' && method === 'GET') {
    return json(res, { agents: Object.values(AGENTS), count: 4, phi: PHI });
  }

  // ── GET /agents/:name ────────────────────────────────────────────────────
  const agentGet = path.match(/^\/agents\/([^\/]+)$/);
  if (agentGet && method === 'GET') {
    const agent = AGENTS[agentGet[1].toLowerCase()];
    if (!agent) return notFound(res, `Agent '${agentGet[1]}' not found`);
    const mdPath = join(ROOT, agent.path);
    const content = existsSync(mdPath) ? readFileSync(mdPath, 'utf-8').slice(0, 500) + '...' : 'Not loaded';
    return json(res, { ...agent, preview: content });
  }

  // ── GET /agents/:name/stream — SSE agent stream ───────────────────────────
  const agentStream = path.match(/^\/agents\/([^\/]+)\/stream$/);
  if (agentStream && method === 'GET') {
    const agentKey  = agentStream[1].toLowerCase();
    const agent     = AGENTS[agentKey];
    if (!agent) return notFound(res, `Agent '${agentKey}' not found`);

    const stream = sse(res);
    stream.send({ connected: true, agent: agent.name, phi: PHI }, 'connect');

    // Stream agent metadata + phi-beats
    const agentData = { ...agent, phi: PHI, ts: new Date().toISOString() };
    stream.send(agentData, 'agent');

    let beats = 0;
    const id = setInterval(() => {
      stream.beat();
      if (++beats >= 34) { // F9 = 34 beats per agent stream
        clearInterval(id);
        stream.send({ done: true, agent: agent.name, beats }, 'done');
        stream.end();
      }
    }, PHI_BEAT);
    req.on('close', () => clearInterval(id));
    return;
  }

  // ── GET /workflows ────────────────────────────────────────────────────────
  if (path === '/workflows' && method === 'GET') {
    const mod = await import('../tools/nova-orchestrate.js');
    const result = await mod.default({ action: 'list' });
    return json(res, result);
  }

  // ── POST /workflows/:name/trigger ─────────────────────────────────────────
  const wfTrigger = path.match(/^\/workflows\/([^\/]+)\/trigger$/);
  if (wfTrigger && method === 'POST') {
    const payload = await parseBody(req);
    const mod     = await import('../tools/nova-orchestrate.js');
    const result  = await mod.default({
      action: 'trigger',
      workflow: wfTrigger[1],
      ...payload,
    });
    return json(res, result);
  }

  // ── POST /registry/query — aquarium caller ───────────────────────────────
  if (path === '/registry/query' && method === 'POST') {
    const payload = await parseBody(req);
    const reg     = await getRegistry();
    const action  = payload.action || 'query';
    if (action === 'search') return json(res, reg.search(payload.term || ''));
    if (action === 'get')    return json(res, reg.get(payload.name));
    if (action === 'resolve')return json(res, reg.resolve(parseInt(payload.slot)));
    if (action === 'pack')   return json(res, reg.pack());
    if (action === 'status') return json(res, reg.status());
    return json(res, reg.query(payload.filter || {}));
  }

  // ── GET / — root info ──────────────────────────────────────────────────
  if (path === '/' && method === 'GET') {
    return json(res, {
      name:      'Nova Runtime',
      brand:     'Nova by FreddyCreates',
      platform:  'command-platform',
      version:   'F12 (1.44.0)',
      phi:        PHI,
      phi_beat:   PHI_BEAT,
      port:       PORT,
      endpoints: {
        health:          'GET  /health',
        phi_beat:        'GET  /phi-beat          (SSE)',
        tools_list:      'GET  /tools',
        tool_get:        'GET  /tools/:name',
        tool_call:       'POST /tools/:name/call',
        ais_list:        'GET  /ais',
        ais_query:       'POST /ais/:name/query',
        agents_list:     'GET  /agents',
        agent_get:       'GET  /agents/:name',
        agent_stream:    'GET  /agents/:name/stream  (SSE)',
        workflows_list:  'GET  /workflows',
        workflow_trigger:'POST /workflows/:name/trigger',
        registry_query:  'POST /registry/query',
      },
      tools:     20, ais: 15, agents: 4, workflows: 27,
      charter:   'nova/CHARTER.md',
      manifest:  'nova.toml',
      math: {
        phi:        PHI,
        phi_inv:    PHI_INV,
        phi_beat:   `${PHI_BEAT}ms`,
        fib_law:    'version(n) = F(n) — names emerge from numbers',
      },
    });
  }

  return notFound(res, `Route '${path}' not found`);
}

// ─── SERVER ───────────────────────────────────────────────────────────────
const server = createServer(async (req, res) => {
  try {
    await router(req, res);
  } catch(e) {
    console.error('[nova-runtime] Error:', e.message);
    try { json(res, { error: e.message, phi: PHI }, 500); } catch{}
  }
});

server.listen(PORT, HOST, () => {
  console.log(`
╔══════════════════════════════════════════════════════════════╗
║  NOVA RUNTIME — Sovereign Tool Chain                         ║
║  Brand: Nova by FreddyCreates                               ║
║  φ = ${PHI}                                  ║
║  φ-beat = ${PHI_BEAT}ms                                             ║
╠══════════════════════════════════════════════════════════════╣
║  http://${HOST}:${PORT}                                       ║
║                                                              ║
║  Tools:     20  (Fibonacci versioned F1–F20)                ║
║  AIS:       15  (10 alpha + 5 multimodal)                   ║
║  Agents:     4  (sovereign/meridianus/organism/magister)     ║
║  Workflows: 27  (11 bots + 14 system + 2 ci/cd)            ║
╠══════════════════════════════════════════════════════════════╣
║  GET  /health          — platform health                     ║
║  GET  /phi-beat        — SSE φ heartbeat                    ║
║  GET  /tools           — list all 20 Nova tools              ║
║  POST /tools/:name/call — call any tool                      ║
║  GET  /ais             — list all 15 AIS                    ║
║  POST /ais/:name/query  — query any AIS                     ║
║  GET  /agents/:name/stream — SSE agent stream               ║
║  GET  /workflows        — list all 27 workflows              ║
║  POST /registry/query   — aquarium caller                   ║
╚══════════════════════════════════════════════════════════════╝
`);
});

// ─── PHI-BEAT HEARTBEAT ───────────────────────────────────────────────────
// The platform pulses at φ-beat = 873ms — synchronized to biological rhythms
// 1/0.873 = 1.147Hz — close to theta brain wave (4-8Hz subharmonic)
setInterval(() => {
  // Silent internal heartbeat — each beat is F(n) cycles since start
  const uptime = process.uptime();
  const beats  = Math.floor(uptime * 1000 / PHI_BEAT);
  // Every F9=34 beats, log status
  if (beats % 34 === 0 && beats > 0) {
    console.log(`[nova-runtime] φ-beat #${beats} | uptime: ${uptime.toFixed(0)}s | φ=${PHI}`);
  }
}, PHI_BEAT);

export default server;
