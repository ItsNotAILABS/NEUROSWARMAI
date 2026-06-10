#!/usr/bin/env node
/**
 * Emit drone_swarm_state.json governance event from swarm drone-side tick.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { executeDroneSide } from '../protocols/swarm/swarm-orchestrator.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const OUT = path.join(__dirname, '../dist/governance/events/drone_swarm_state.json');

const agents = Array.from({ length: 8 }, (_, i) => ({ agentId: `drone-${String(i + 1).padStart(3, '0')}` }));
const result = executeDroneSide({ agents, kuramotoR: 0.91 }, { protocolsExecuted: [] });

const payload = {
  entity_id: 'atlas://engine/neuroswarm-drone-side',
  op: 'drone_swarm_tick_completed',
  timestamp: new Date().toISOString(),
  context: {
    n_agents: result.agentsTotal,
    agents_healthy: result.agentsHealthy,
    kuramoto_r_mean: result.kuramotoRMean,
    threat_consensus: result.ticks.some((t) => t.threat) ? 'threat' : 'clear',
    threat_fast_p50_ms: result.threatFastP50Ms,
    jam_failover_ok: result.jamFailoverOk,
    engines_attested_ratio: result.enginesAttestedRatio,
    law_violations_critical: result.lawViolationsCritical,
    law_violations_total: result.lawViolationsTotal,
    access_modes: [...new Set(result.ticks.map((t) => t.accessMode))],
    protocols_invoked: result.protocols,
    side_engines: ['DSEN', 'DNAV', 'DMESH', 'DTHR', 'DFORM', 'DRT'],
  },
};

fs.mkdirSync(path.dirname(OUT), { recursive: true });
fs.writeFileSync(OUT, JSON.stringify(payload, null, 2));
console.log(`Wrote ${OUT}`);
console.log(`goNoGo: ${result.goNoGo}, coherence: ${result.kuramotoRMean.toFixed(3)}`);