/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║                    CHIMERIA AI DIVISION — AGENTS INDEX                         ║
 * ║        Complete Agent Registry for All Defense Verticals                       ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                    ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 */

export {
  DefenseAgent,
  SentinelAgent,
  AegisAgent,
  VitalsAgent,
  CortexAgent,
  MeridianAgent,
  PhoenixAgent,
  GuardianAgent,
  HelixAgent,
  NexusAgent,
  OracleAgent,
  DefenseFleet
} from './healthcare-defense-fleet.js';

export {
  ThreatHunterAgent,
  PenTestAgent,
  EndpointProtectionAgent,
  DLPAgent,
  CyberDefenseFleet
} from './cyber-defense-fleet.js';

// ═══════════════════════════════════════════════════════════════════════════════
// UNIFIED AGENT PROVISIONER
// ═══════════════════════════════════════════════════════════════════════════════

import { DefenseFleet } from './healthcare-defense-fleet.js';
import { CyberDefenseFleet } from './cyber-defense-fleet.js';

/**
 * Provision all defense fleets for a client
 */
export function provisionClientDefense(clientConfig) {
  const healthcare = new DefenseFleet(clientConfig);
  const cyber = new CyberDefenseFleet(clientConfig);

  // Activate all
  const hcStatus = healthcare.activateAll();
  const cyberStatus = cyber.activateAll();

  return {
    clientId: clientConfig.clientId,
    provisionedAt: new Date().toISOString(),
    fleets: {
      healthcare: hcStatus,
      cyber: cyberStatus
    },
    totalAgents: 14,
    status: 'FULL_OPERATIONAL'
  };
}

export default { provisionClientDefense };
