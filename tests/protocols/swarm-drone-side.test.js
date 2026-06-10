/**
 * NeuroSwarm drone-side protocol smoke tests (PROTO-255–262)
 */

import { describe, it, expect } from 'vitest';
import {
  DRONE_SIDE_ENGINES,
  executeDroneSideTick,
  droneLawGate,
  droneJamFailoverRoute,
} from '../../protocols/swarm/swarm-drone-side-protocols.js';
import { executeDroneSide } from '../../protocols/swarm/swarm-orchestrator.js';

describe('swarm drone-side protocols', () => {
  it('declares six side engines', () => {
    expect(DRONE_SIDE_ENGINES).toEqual(['DSEN', 'DNAV', 'DMESH', 'DTHR', 'DFORM', 'DRT']);
  });

  it('executes full tick with law gate pass', () => {
    const tick = executeDroneSideTick({ agentId: 'drone-001', kuramotoR: 0.91 });
    expect(tick.ok).toBe(true);
    expect(tick.protocols).toContain('PROTO-262');
    expect(tick.attestation.complete).toBe(true);
  });

  it('fails jam failover law when ground jammed but wrong route', () => {
    const gate = droneLawGate({
      kuramotoR: 0.9,
      threatDecisionMs: 1,
      gpsDenied: false,
      navOk: true,
      groundJammed: true,
      accessMode: 'ground_mesh',
      meshPartitions: 0,
      formationError: 0.1,
      enginesAttested: DRONE_SIDE_ENGINES,
      roeScore: 1,
      actuationRequested: false,
    });
    expect(gate.goNoGo).toBe(false);
    expect(gate.criticalCount).toBeGreaterThan(0);
  });

  it('switches to orbital on jam failover route', () => {
    const route = droneJamFailoverRoute(true);
    expect(route.accessMode).toBe('orbital_preferred');
  });

  it('fleet executeDroneSide aggregates healthy agents', () => {
    const agents = [{ agentId: 'a1' }, { agentId: 'a2' }, { agentId: 'a3' }];
    const result = executeDroneSide({ agents, kuramotoR: 0.92 }, { protocolsExecuted: [] });
    expect(result.goNoGo).toBe(true);
    expect(result.agentsHealthy).toBe(3);
    expect(result.protocols).toContain('PROTO-255');
  });
});