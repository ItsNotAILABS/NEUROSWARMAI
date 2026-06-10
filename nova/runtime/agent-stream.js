// nova/runtime/agent-stream.js
// Nova Agent Streaming — SSE bridge for all 4 sovereign agents
// Streams agent state, capabilities, and phi-beat pulses to any connected client
// Brand: Nova by FreddyCreates

import { readFileSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dir = dirname(fileURLToPath(import.meta.url));
const ROOT  = join(__dir, '../..');
const PHI   = 1.618033988749895;
const PHI_INV = 0.6180339887498949;
const PHI_BEAT = 873;

// ─── AGENT DEFINITIONS ────────────────────────────────────────────────────
export const AGENTS = {
  sovereign: {
    name:     'SOVEREIGN',
    version:  '3.0',
    sections: 14,  // I–XIV
    model:    'claude-sonnet-4-5',
    path:     '.github/agents/sovereign.md',
    surfaces: ['VINCULUM','NUNTIUS-SOVEREIGN','ARTIFEX-SOVEREIGN','SPECULUM-SOVEREIGN'],
    capabilities: [
      'Tool Contract (Section VII)',
      'TUNGSTEN Layer (Section VIII)',
      'PM Workflow Engine (Section IX)',
      'All 7 research papers',
      'All 40 cognitive languages',
      'All 20 Nova tools',
      'All 15 AIS systems',
      'All 27 workflows',
      '194 genesis modules',
    ],
    phi_role: 'Unified master — everything routes through SOVEREIGN',
  },
  meridianus: {
    name:     'MERIDIANUS',
    version:  '2.0',
    sections:  6,
    model:    'claude-sonnet-4-5',
    path:     '.github/agents/meridianus.md',
    surfaces: ['architecture','codebase'],
    capabilities: ['Full-stack architecture','ICP canister design','Cloudflare worker design','Nova tool design'],
    phi_role: 'Sovereign architect — builds and reads all code',
  },
  organism: {
    name:     'ORGANISM',
    version:  '2.0',
    sections:  5,
    model:    'claude-sonnet-4-5',
    path:     '.github/agents/organism.md',
    surfaces: ['workers','bots','ci'],
    capabilities: ['Cloudflare worker engineering','GitHub Actions bots','Debugging','CI/CD'],
    phi_role: 'Engineer/debugger — workers, bots, CI',
  },
  magister: {
    name:     'MAGISTER',
    version:  '1.0',
    sections:  4,
    model:    'claude-sonnet-4-5',
    path:     '.github/agents/magister.md',
    surfaces: ['vision','research'],
    capabilities: ['All 7 research papers','Platform vision','Cognitive languages','AIS theory'],
    phi_role: 'Visionary — holds all research + platform vision',
  },
};

// ─── STREAM EVENTS ────────────────────────────────────────────────────────
export function agentConnectEvent(agentKey) {
  const agent = AGENTS[agentKey];
  if (!agent) return null;
  return {
    event: 'connect',
    data:  { connected: true, agent: agent.name, version: agent.version, phi: PHI, ts: Date.now() },
  };
}

export function agentStateEvent(agentKey) {
  const agent = AGENTS[agentKey];
  if (!agent) return null;
  const mdPath  = join(ROOT, agent.path);
  const lines   = existsSync(mdPath) ? readFileSync(mdPath,'utf-8').split('\n').length : 0;
  return {
    event: 'state',
    data:  {
      agent:        agent.name,
      version:      agent.version,
      model:        agent.model,
      sections:     agent.sections,
      lines,
      surfaces:     agent.surfaces,
      capabilities: agent.capabilities,
      phi_role:     agent.phi_role,
      phi:          PHI,
      ts:           Date.now(),
    },
  };
}

export function phiBeatEvent(beatCount) {
  return {
    event: 'phi-beat',
    data:  {
      phi:       PHI,
      phi_inv:   PHI_INV,
      beat_ms:   PHI_BEAT,
      beat_n:    beatCount,
      fib_zone:  fibZone(beatCount),
      ts:        Date.now(),
    },
  };
}

function fibZone(n) {
  const FIB = [1,1,2,3,5,8,13,21,34,55,89];
  for (let i = FIB.length-1; i >= 0; i--) {
    if (n >= FIB[i]) return `F${i+1}=${FIB[i]}`;
  }
  return 'F1=1';
}

// ─── STREAM WRITER ────────────────────────────────────────────────────────
export function formatSSE(event, data) {
  return `event: ${event}\ndata: ${JSON.stringify(data)}\n\n`;
}

// ─── AGENT STREAM HANDLER (for nova-runtime integration) ──────────────────
export async function streamAgent(agentKey, res) {
  const agent = AGENTS[agentKey];
  if (!agent) {
    res.writeHead(404, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify({ error: `Agent '${agentKey}' not found`, known: Object.keys(AGENTS) }));
  }

  res.writeHead(200, {
    'Content-Type':  'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection':    'keep-alive',
    'X-Nova-Phi':    String(PHI),
    'X-Nova-Agent':  agent.name,
  });

  // 1. Connect event
  const connectEv = agentConnectEvent(agentKey);
  res.write(formatSSE(connectEv.event, connectEv.data));

  // 2. State event
  const stateEv = agentStateEvent(agentKey);
  res.write(formatSSE(stateEv.event, stateEv.data));

  // 3. Phi-beats (F9=34 beats at PHI_BEAT intervals)
  let beatCount = 0;
  const maxBeats = 34; // F9 = 34

  return new Promise((resolve) => {
    const id = setInterval(() => {
      if (res.destroyed) { clearInterval(id); return resolve(); }
      res.write(formatSSE('phi-beat', phiBeatEvent(beatCount).data));
      if (++beatCount >= maxBeats) {
        clearInterval(id);
        res.write(formatSSE('done', { agent: agent.name, beats: beatCount, phi: PHI }));
        res.end();
        resolve();
      }
    }, PHI_BEAT);
  });
}

// ─── CLI / DIRECT USE ─────────────────────────────────────────────────────
if (process.argv[1].endsWith('agent-stream.js')) {
  const agentKey = process.argv[2] || 'sovereign';
  console.log('Nova Agent Stream —', agentKey.toUpperCase());
  const agent = AGENTS[agentKey];
  if (!agent) { console.error('Unknown agent:', agentKey, '\nKnown:', Object.keys(AGENTS)); process.exit(1); }
  console.log(JSON.stringify(agentStateEvent(agentKey).data, null, 2));
  console.log('\nTo SSE stream: GET http://localhost:8973/agents/' + agentKey + '/stream');
}
