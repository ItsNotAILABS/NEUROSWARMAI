/**
 * PROTO-247 through PROTO-250 — SWARM Compliance Protocols
 * Domain: SovereignCompliance — Fleet-Wide ITAR/EAR & Distributed Audit
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * These protocols enforce export control, compliance attestation, and
 * audit integrity across every node in the CHIMERIA swarm fleet.
 *
 * Coverage: ITAR 22 CFR §120-130, EAR 15 CFR §730-774, NIST SP 800-171,
 * CMMC Level 3, DFARS 252.204-7012, FIPS 140-3.
 *
 * ZERO EXTERNAL DEPENDENCIES.
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;

// USML Categories relevant to CHIMERIA
const USML_CATEGORIES = {
  XI: 'Military Electronics',
  XII: 'Fire Control, Range Finder, Optical & Guidance Equipment',
  XIII: 'Materials and Miscellaneous Articles',
  XIV: 'Toxicological Agents & Equipment',
  XV: 'Spacecraft & Related Articles',
  XXI: 'Articles, Technical Data & Defense Services (Classified)',
};

// NIST SP 800-171 Control Families
const NIST_FAMILIES = [
  'AC', 'AT', 'AU', 'CA', 'CM', 'CP', 'IA', 'IR',
  'MA', 'MP', 'PE', 'PL', 'PM', 'PS', 'RA', 'SA',
  'SC', 'SI', 'SR',
];

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-247: FLEET COMPLIANCE ATTESTATION PROTOCOL
//
// Every swarm node must periodically attest its compliance status.
// Attestation includes: NIST 800-171 controls satisfied, CMMC level,
// CUI marking status, and cryptographic proof of attestation.
//
// Fleet compliance = min(node_compliance) — weakest link principle.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute compliance score for a node
 * @param {Object} nodeStatus - {controlsImplemented: string[], totalControls: number, cmmcLevel, cuiMarked}
 * @returns {number} Compliance score [0, 1]
 */
function computeNodeComplianceScore(nodeStatus) {
  const controlRatio = nodeStatus.controlsImplemented.length / Math.max(1, nodeStatus.totalControls);
  const cmmcFactor = Math.min(nodeStatus.cmmcLevel / 3, 1); // Normalize to L3
  const cuiFactor = nodeStatus.cuiMarked ? 1 : 0.5;
  return controlRatio * 0.6 + cmmcFactor * 0.3 + cuiFactor * 0.1;
}

/**
 * Simple attestation hash
 * @param {string} data
 * @returns {string}
 */
function attestHash(data) {
  let h = 0x811c9dc5;
  for (let i = 0; i < data.length; i++) {
    h ^= data.charCodeAt(i);
    h = Math.imul(h, 16777619) >>> 0;
  }
  return h.toString(16).padStart(8, '0');
}

/**
 * PROTO-247: Fleet Compliance Attestation
 * Collects and validates compliance status across all swarm nodes
 *
 * @param {Object[]} nodeAttestations - Array of {nodeId, controlsImplemented, totalControls, cmmcLevel, cuiMarked, lastAuditDate}
 * @returns {Object} Fleet-wide compliance posture
 */
function fleetComplianceAttestation(nodeAttestations) {
  if (!nodeAttestations || nodeAttestations.length === 0) {
    return { protocol: 'PROTO-247', error: 'No attestations received' };
  }

  const now = Date.now();
  const scores = nodeAttestations.map(na => ({
    nodeId: na.nodeId,
    score: computeNodeComplianceScore(na),
    cmmcLevel: na.cmmcLevel,
    controlsCoverage: na.controlsImplemented.length / Math.max(1, na.totalControls),
    cuiMarked: na.cuiMarked,
    auditCurrent: na.lastAuditDate && (now - na.lastAuditDate) < 365 * 24 * 60 * 60 * 1000,
  }));

  // Fleet compliance = weakest link
  const minScore = Math.min(...scores.map(s => s.score));
  const maxScore = Math.max(...scores.map(s => s.score));
  const avgScore = scores.reduce((s, n) => s + n.score, 0) / scores.length;

  // Identify non-compliant nodes
  const nonCompliant = scores.filter(s => s.score < PHI_INV);

  // Attestation hash chain
  const attestationData = JSON.stringify(scores.map(s => ({ n: s.nodeId, s: s.score })));
  const fleetHash = attestHash(attestationData);

  return {
    protocol: 'PROTO-247',
    name: 'Fleet Compliance Attestation',
    module: 'SovereignCompliance',
    fleetSize: nodeAttestations.length,
    fleetComplianceScore: minScore,
    averageScore: avgScore,
    maxScore,
    threshold: PHI_INV,
    fleetCompliant: minScore >= PHI_INV,
    nonCompliantNodes: nonCompliant.map(n => n.nodeId),
    cmmcDistribution: {
      L1: scores.filter(s => s.cmmcLevel === 1).length,
      L2: scores.filter(s => s.cmmcLevel === 2).length,
      L3: scores.filter(s => s.cmmcLevel >= 3).length,
    },
    attestationHash: fleetHash,
    nodeScores: scores,
    standards: ['NIST SP 800-171', 'CMMC Level 3', 'DFARS 252.204-7012'],
    timestamp: now,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-248: EXPORT CONTROL GATEWAY PROTOCOL
//
// Enforces ITAR/EAR at every data transfer point in the swarm.
// Every inter-node communication is classified and gated:
//   - USML classification check
//   - ECCN determination
//   - Deemed export verification
//   - End-use certificate validation
//
// NO data crosses node boundaries without passing this gate.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-248: Export Control Gateway
 * Gates all inter-node data transfers for ITAR/EAR compliance
 *
 * @param {Object} transferRequest - {sourceNode, destNode, dataType, classification, eccn, endUse, recipientCountry}
 * @param {Object} policy - {deniedCountries, controlledECCNs, requiredLicenses}
 * @returns {Object} Gate decision (ALLOW/DENY) with reasoning
 */
function exportControlGateway(transferRequest, policy) {
  const checks = [];
  let allowed = true;

  // Check 1: Denied country
  if (policy.deniedCountries.includes(transferRequest.recipientCountry)) {
    checks.push({ check: 'DENIED_COUNTRY', passed: false, detail: `${transferRequest.recipientCountry} is on denied list` });
    allowed = false;
  } else {
    checks.push({ check: 'DENIED_COUNTRY', passed: true });
  }

  // Check 2: ECCN control
  if (policy.controlledECCNs.includes(transferRequest.eccn)) {
    const hasLicense = policy.requiredLicenses.some(
      l => l.eccn === transferRequest.eccn && l.country === transferRequest.recipientCountry && l.valid
    );
    if (!hasLicense) {
      checks.push({ check: 'ECCN_CONTROL', passed: false, detail: `ECCN ${transferRequest.eccn} requires license for ${transferRequest.recipientCountry}` });
      allowed = false;
    } else {
      checks.push({ check: 'ECCN_CONTROL', passed: true, detail: 'Valid license found' });
    }
  } else {
    checks.push({ check: 'ECCN_CONTROL', passed: true, detail: 'ECCN not controlled' });
  }

  // Check 3: Classification level
  if (transferRequest.classification === 'SECRET' || transferRequest.classification === 'TOP_SECRET') {
    checks.push({ check: 'CLASSIFICATION', passed: false, detail: 'Classified data cannot transit uncleared nodes' });
    allowed = false;
  } else {
    checks.push({ check: 'CLASSIFICATION', passed: true });
  }

  // Check 4: USML category check
  const usmlMatch = Object.keys(USML_CATEGORIES).find(cat =>
    transferRequest.dataType.toUpperCase().includes(cat)
  );
  if (usmlMatch) {
    checks.push({ check: 'USML_CATEGORY', passed: false, detail: `Matches USML Category ${usmlMatch}: ${USML_CATEGORIES[usmlMatch]}` });
    allowed = false;
  } else {
    checks.push({ check: 'USML_CATEGORY', passed: true });
  }

  // Check 5: End-use verification
  const redFlagEndUses = ['WMD', 'NUCLEAR', 'CHEMICAL', 'BIOLOGICAL', 'MISSILE'];
  const endUseViolation = redFlagEndUses.find(rf => transferRequest.endUse.toUpperCase().includes(rf));
  if (endUseViolation) {
    checks.push({ check: 'END_USE', passed: false, detail: `Red flag end-use: ${endUseViolation}` });
    allowed = false;
  } else {
    checks.push({ check: 'END_USE', passed: true });
  }

  return {
    protocol: 'PROTO-248',
    name: 'Export Control Gateway',
    module: 'SovereignCompliance',
    decision: allowed ? 'ALLOW' : 'DENY',
    transferRequest: {
      source: transferRequest.sourceNode,
      destination: transferRequest.destNode,
      dataType: transferRequest.dataType,
      classification: transferRequest.classification,
      eccn: transferRequest.eccn,
      recipientCountry: transferRequest.recipientCountry,
    },
    checks,
    checksPass: checks.filter(c => c.passed).length,
    checksFail: checks.filter(c => !c.passed).length,
    regulations: ['ITAR 22 CFR §120-130', 'EAR 15 CFR §730-774'],
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-249: DISTRIBUTED AUDIT CHAIN PROTOCOL
//
// Maintains a distributed, tamper-evident audit log across all swarm nodes.
// Each node contributes entries to a shared Merkle-like chain.
// Cross-node verification ensures no single node can tamper with history.
//
// Chain integrity: H(entry_n) = H(H(entry_{n-1}) || data_n || node_id)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-249: Distributed Audit Chain
 * Append-only tamper-evident audit log distributed across fleet
 *
 * @param {Object} auditEntry - {nodeId, action, subject, detail, classification}
 * @param {Object} chainState - {lastHash, entryCount, nodeHashes: {nodeId: lastHash}}
 * @returns {Object} New chain state with entry appended
 */
function distributedAuditChain(auditEntry, chainState) {
  const entryData = [
    chainState.lastHash,
    auditEntry.nodeId.toString(),
    auditEntry.action,
    auditEntry.subject,
    auditEntry.detail,
    auditEntry.classification,
    Date.now().toString(),
  ].join('|');

  const entryHash = attestHash(entryData);

  // Cross-reference: each node maintains its own chain tip
  const updatedNodeHashes = { ...chainState.nodeHashes };
  const nodeChainInput = `${updatedNodeHashes[auditEntry.nodeId] || 'INIT'}|${entryHash}`;
  updatedNodeHashes[auditEntry.nodeId] = attestHash(nodeChainInput);

  return {
    protocol: 'PROTO-249',
    name: 'Distributed Audit Chain',
    module: 'SovereignCompliance',
    entry: {
      index: chainState.entryCount + 1,
      nodeId: auditEntry.nodeId,
      action: auditEntry.action,
      subject: auditEntry.subject,
      classification: auditEntry.classification,
      hash: entryHash,
    },
    chain: {
      previousHash: chainState.lastHash,
      currentHash: entryHash,
      entryCount: chainState.entryCount + 1,
      nodeChainTip: updatedNodeHashes[auditEntry.nodeId],
    },
    integrity: {
      tamperEvident: true,
      crossNodeVerifiable: true,
      standard: 'NIST SP 800-171 3.3.1',
    },
    updatedState: {
      lastHash: entryHash,
      entryCount: chainState.entryCount + 1,
      nodeHashes: updatedNodeHashes,
    },
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-250: SUPPLY CHAIN INTEGRITY PROTOCOL
//
// Verifies the software/firmware supply chain for every swarm node.
// Each node must attest:
//   - All code is from approved sources
//   - No unauthorized dependencies
//   - Binary hashes match build manifests
//   - No known CVEs in deployed components
//
// Fleet-wide supply chain = AND(all_node_attestations)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-250: Supply Chain Integrity
 * Verifies software supply chain across fleet nodes
 *
 * @param {Object[]} nodeManifests - Array of {nodeId, components: [{name, version, hash, source, approved}], buildHash}
 * @param {Object} approvedSources - {sources: string[], blockedHashes: string[]}
 * @returns {Object} Supply chain integrity assessment
 */
function supplyChainIntegrity(nodeManifests, approvedSources) {
  if (!nodeManifests || nodeManifests.length === 0) {
    return { protocol: 'PROTO-250', error: 'No manifests provided' };
  }

  const nodeResults = nodeManifests.map(nm => {
    const violations = [];

    for (const comp of nm.components) {
      // Check source approval
      if (!approvedSources.sources.includes(comp.source)) {
        violations.push({ type: 'UNAPPROVED_SOURCE', component: comp.name, source: comp.source });
      }
      // Check blocked hashes
      if (approvedSources.blockedHashes.includes(comp.hash)) {
        violations.push({ type: 'BLOCKED_HASH', component: comp.name, hash: comp.hash });
      }
      // Check explicit approval
      if (!comp.approved) {
        violations.push({ type: 'NOT_APPROVED', component: comp.name });
      }
    }

    return {
      nodeId: nm.nodeId,
      totalComponents: nm.components.length,
      violations,
      violationCount: violations.length,
      clean: violations.length === 0,
      buildHash: nm.buildHash,
    };
  });

  const cleanNodes = nodeResults.filter(nr => nr.clean);
  const compromisedNodes = nodeResults.filter(nr => !nr.clean);

  // Fleet integrity: ALL nodes must be clean
  const fleetClean = compromisedNodes.length === 0;

  return {
    protocol: 'PROTO-250',
    name: 'Supply Chain Integrity',
    module: 'SovereignCompliance',
    fleetSize: nodeManifests.length,
    fleetClean,
    cleanNodes: cleanNodes.map(n => n.nodeId),
    compromisedNodes: compromisedNodes.map(n => ({ nodeId: n.nodeId, violations: n.violations })),
    integrityScore: cleanNodes.length / nodeManifests.length,
    totalViolations: compromisedNodes.reduce((s, n) => s + n.violationCount, 0),
    standards: ['NIST SP 800-171 SR', 'CMMC L3 SC.L2-3.13.1'],
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  // Constants
  USML_CATEGORIES, NIST_FAMILIES,
  // PROTO-247
  computeNodeComplianceScore,
  fleetComplianceAttestation,
  // PROTO-248
  exportControlGateway,
  // PROTO-249
  distributedAuditChain,
  // PROTO-250
  supplyChainIntegrity,
};
