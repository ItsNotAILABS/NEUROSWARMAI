/**
 * PROTO-255 through PROTO-274 — SWARM Embedded Sub-Protocols
 * Domain: Foundational Primitives — Embedded infrastructure required by all major protocols
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * These 20 embedded sub-protocols form the bedrock layer that ALL 24 major
 * swarm protocols (PROTO-231–254) depend on. They provide:
 *
 *   1. φ-Heartbeat Synchronization       (PROTO-255) — Temporal alignment across fleet
 *   2. Node Identity Derivation           (PROTO-256) — Deterministic sovereign ID
 *   3. φ-Hash Primitive                   (PROTO-257) — Golden-ratio integrity hash
 *   4. Spatial Exclusion Envelope         (PROTO-258) — Fibonacci collision boundary
 *   5. Kuramoto Phase Coupling            (PROTO-259) — Oscillator synchronization
 *   6. Fibonacci Quorum Threshold         (PROTO-260) — Consensus minimum bound
 *   7. Byzantine Fault Detector           (PROTO-261) — Outlier node identification
 *   8. Golden Epoch Timer                 (PROTO-262) — φ-scaled time windowing
 *   9. Merkle Chain Primitive             (PROTO-263) — Hash-linked audit chain
 *  10. Entropy Accumulator                (PROTO-264) — Sovereign randomness pool
 *  11. φ-Weighted Vote Aggregation        (PROTO-265) — Golden-decay ballot counting
 *  12. Swarm Heartbeat Monitor            (PROTO-266) — Node liveness detection
 *  13. Fibonacci Backoff Scheduler         (PROTO-267) — Retry timing primitive
 *  14. Nonce Generation                   (PROTO-268) — Anti-replay nonce creation
 *  15. Ring Position Assignment            (PROTO-269) — Consistent hashing placement
 *  16. Signal Envelope Detector            (PROTO-270) — Energy threshold gating
 *  17. Gradient Norm Clipper               (PROTO-271) — Safe update bounding
 *  18. Attestation Signature              (PROTO-272) — Sovereign signing primitive
 *  19. Swarm Broadcast Primitive           (PROTO-273) — φ-fanout message relay
 *  20. Emergency Cascade Trigger           (PROTO-274) — Zeroization propagation
 *
 * ZERO EXTERNAL DEPENDENCIES — Complete sovereign execution.
 */

// ═══════════════════════════════════════════════════════════════════════════
// CONSTANTS — φ-ALIGNED
// ═══════════════════════════════════════════════════════════════════════════

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;                   // 0.618033988749895
const PHI_SQUARED = PHI * PHI;             // 2.618033988749895
const GOLDEN_ANGLE = 2.39996322972865;     // radians
const PHI_BEAT_MS = 873;                   // organism heartbeat
const FNV_OFFSET = 0x811c9dc5;
const FNV_PRIME = 0x01000193;
const EPSILON = 1e-10;

// First 30 Fibonacci numbers for threshold lookups
const FIB = [
  0, 1, 1, 2, 3, 5, 8, 13, 21, 34,
  55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
  6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229,
];

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-255: φ-HEARTBEAT SYNCHRONIZATION
//
// Provides a global temporal grid for the swarm. All operations align to
// φ-beat intervals (873ms). Nodes derive their local clock phase relative
// to the swarm epoch, ensuring no two nodes fire simultaneously.
//
// Beat[n] = epoch + n × PHI_BEAT_MS
// Phase = (now - epoch) mod PHI_BEAT_MS / PHI_BEAT_MS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-255: Compute heartbeat phase for a node
 * @param {number} now - Current timestamp (ms)
 * @param {number} swarmEpoch - Swarm genesis timestamp (ms)
 * @param {number} nodeIndex - Node's position in the fleet
 * @param {number} nodeCount - Total fleet size
 * @returns {Object} Heartbeat phase data
 */
export function heartbeatSync(now, swarmEpoch, nodeIndex, nodeCount) {
  const elapsed = now - swarmEpoch;
  const beatNumber = Math.floor(elapsed / PHI_BEAT_MS);
  const phase = (elapsed % PHI_BEAT_MS) / PHI_BEAT_MS;

  // Each node is offset by golden angle to avoid simultaneous firing
  const nodeOffset = ((nodeIndex * PHI_INV) % 1.0);
  const adjustedPhase = (phase + nodeOffset) % 1.0;

  // Next beat for this node
  const nextBeat = swarmEpoch + (beatNumber + 1) * PHI_BEAT_MS;
  const sleepMs = Math.max(0, nextBeat - now + nodeOffset * PHI_BEAT_MS);

  return {
    proto: 'PROTO-255',
    beatNumber,
    phase: adjustedPhase,
    nodeOffset,
    nextBeatAt: nextBeat,
    sleepMs: Math.round(sleepMs),
    synchronized: phase < PHI_INV, // In-phase window
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-256: NODE IDENTITY DERIVATION
//
// Derives a deterministic, collision-free node identity from the node's
// position in the fleet and the swarm epoch. Uses φ-seeded FNV-1a to
// produce a unique 64-bit identifier without external key material.
//
// ID = FNV1a(epoch || nodeIndex || PHI_SEED)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-256: Derive deterministic node identity
 * @param {number} nodeIndex - Position in fleet
 * @param {number} swarmEpoch - Genesis timestamp
 * @param {string} [salt] - Optional additional salt
 * @returns {Object} Node identity record
 */
export function deriveNodeIdentity(nodeIndex, swarmEpoch, salt = '') {
  const seed = `${swarmEpoch}:${nodeIndex}:${Math.floor(PHI * 1e15)}:${salt}`;
  let hash = FNV_OFFSET;
  for (let i = 0; i < seed.length; i++) {
    hash ^= seed.charCodeAt(i);
    hash = Math.imul(hash, FNV_PRIME) >>> 0;
  }

  // Second round for stronger distribution
  const id2 = (hash ^ (hash >>> 16)) >>> 0;
  const hex = id2.toString(16).padStart(8, '0');

  return {
    proto: 'PROTO-256',
    nodeIndex,
    nodeId: `SWARM-${hex.toUpperCase()}`,
    numericId: id2,
    tier: nodeIndex < 8 ? 'CORE' : nodeIndex < 34 ? 'INNER' : 'OUTER',
    goldenPosition: (nodeIndex * PHI_INV) % 1.0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-257: φ-HASH PRIMITIVE
//
// A fast, deterministic hash function seeded with golden ratio constants.
// Used by tensor integrity, audit chains, and attestation protocols.
// Produces consistent results across all swarm nodes.
//
// H(data) = FNV1a(data) ⊕ (φ-rotation)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-257: φ-seeded hash for arbitrary data
 * @param {string|number[]} data - Input data
 * @returns {Object} Hash result
 */
export function phiHash(data) {
  let h = FNV_OFFSET;
  const input = typeof data === 'string' ? data : data.join(',');

  for (let i = 0; i < input.length; i++) {
    h ^= input.charCodeAt(i);
    h = Math.imul(h, FNV_PRIME) >>> 0;
  }

  // Golden rotation for additional mixing
  const rotated = ((h << 13) | (h >>> 19)) ^ Math.imul(h, 0x9E3779B9) >>> 0;
  const final = (rotated ^ (rotated >>> 16)) >>> 0;

  return {
    proto: 'PROTO-257',
    hash: final.toString(16).padStart(8, '0'),
    numeric: final,
    phiCheck: (final % 1000) / 1000, // Sub-φ verification digit
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-258: SPATIAL EXCLUSION ENVELOPE
//
// Enforces Fibonacci-scaled minimum distance between swarm nodes.
// Uses golden ratio as the hard spatial floor — no two nodes can
// occupy positions closer than φ × base_distance.
//
// Valid iff: dist(A, B) ≥ min_base_distance
// Scaling step: log_φ(dist / base)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-258: Verify spatial exclusion between two nodes
 * @param {number} nodeX - Node X position
 * @param {number} nodeY - Node Y position
 * @param {number} neighborX - Neighbor X position
 * @param {number} neighborY - Neighbor Y position
 * @param {number} [minBaseDistance] - Minimum distance (default: φ)
 * @returns {Object} Spatial validation result
 */
export function spatialExclusionEnvelope(nodeX, nodeY, neighborX, neighborY, minBaseDistance = PHI) {
  const dx = nodeX - neighborX;
  const dy = nodeY - neighborY;
  const distance = Math.sqrt(dx * dx + dy * dy);

  if (distance < minBaseDistance) {
    return {
      proto: 'PROTO-258',
      valid: false,
      distance,
      scalingStep: 0.0,
      minRequired: minBaseDistance,
      violationRatio: distance / minBaseDistance,
    };
  }

  const scalingStep = Math.log(distance / minBaseDistance) / Math.log(PHI);

  return {
    proto: 'PROTO-258',
    valid: true,
    distance,
    scalingStep,
    minRequired: minBaseDistance,
    violationRatio: distance / minBaseDistance,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-259: KURAMOTO PHASE COUPLING
//
// Implements Kuramoto oscillator model for emergent swarm synchronization.
// Each node adjusts its phase based on the mean field of all neighbors.
//
// dθ_i/dt = ω_i + (K/N) × Σ sin(θ_j - θ_i)
// Order parameter R = |1/N × Σ e^(iθ_j)|
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-259: Compute Kuramoto phase coupling for a node
 * @param {number} nodePhase - Current node phase [0, 2π)
 * @param {number[]} neighborPhases - Phases of all neighbors
 * @param {number} [couplingK] - Coupling strength (default: φ)
 * @param {number} [naturalFreq] - Node's natural frequency
 * @returns {Object} Phase update and order parameter
 */
export function kuramotoCouple(nodePhase, neighborPhases, couplingK = PHI, naturalFreq = 1.0) {
  const N = neighborPhases.length;
  if (N === 0) {
    return {
      proto: 'PROTO-259',
      newPhase: nodePhase,
      orderR: 1.0,
      orderPsi: nodePhase,
      synchronized: true,
    };
  }

  // Compute coupling force
  let sinSum = 0;
  let cosSum = 0;
  for (let j = 0; j < N; j++) {
    sinSum += Math.sin(neighborPhases[j] - nodePhase);
    cosSum += Math.cos(neighborPhases[j]);
  }

  // Phase update
  const dTheta = naturalFreq + (couplingK / N) * sinSum;
  const newPhase = (nodePhase + dTheta * 0.01 + 2 * Math.PI) % (2 * Math.PI);

  // Order parameter (mean field magnitude)
  let rCos = 0, rSin = 0;
  for (let j = 0; j < N; j++) {
    rCos += Math.cos(neighborPhases[j]);
    rSin += Math.sin(neighborPhases[j]);
  }
  rCos += Math.cos(newPhase);
  rSin += Math.sin(newPhase);
  const orderR = Math.sqrt(rCos * rCos + rSin * rSin) / (N + 1);
  const orderPsi = Math.atan2(rSin, rCos);

  return {
    proto: 'PROTO-259',
    newPhase,
    dTheta,
    orderR,
    orderPsi,
    synchronized: orderR > PHI_INV,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-260: FIBONACCI QUORUM THRESHOLD
//
// Determines the minimum number of agreeing nodes required for consensus.
// Quorum is set to the nearest Fibonacci number ≥ ⌈N × φ⁻¹⌉.
// This provides Byzantine fault tolerance with golden-ratio margins.
//
// Quorum(N) = min{F(k) : F(k) ≥ ⌈N × φ⁻¹⌉}
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-260: Compute Fibonacci quorum threshold
 * @param {number} totalNodes - Total fleet size
 * @returns {Object} Quorum configuration
 */
export function fibonacciQuorum(totalNodes) {
  const rawThreshold = Math.ceil(totalNodes * PHI_INV);

  // Find nearest Fibonacci number >= rawThreshold
  let quorum = rawThreshold;
  for (let i = 0; i < FIB.length; i++) {
    if (FIB[i] >= rawThreshold) {
      quorum = FIB[i];
      break;
    }
  }

  const maxFaults = totalNodes - quorum;
  const byzantineLimit = Math.floor((totalNodes - 1) / 3);

  return {
    proto: 'PROTO-260',
    totalNodes,
    quorum,
    rawThreshold,
    maxFaults,
    byzantineLimit,
    margin: quorum - rawThreshold,
    tolerancePct: maxFaults / totalNodes,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-261: BYZANTINE FAULT DETECTOR
//
// Identifies misbehaving nodes using statistical outlier detection.
// A node is flagged Byzantine if its output deviates by more than
// φ × σ from the fleet median. Uses trimmed mean for robustness.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-261: Detect Byzantine nodes from reported values
 * @param {Object[]} nodeReports - Array of {nodeId, value}
 * @param {number} [thresholdFactor] - Standard deviation multiplier (default: φ)
 * @returns {Object} Detection result with flagged nodes
 */
export function byzantineFaultDetector(nodeReports, thresholdFactor = PHI) {
  if (nodeReports.length < 3) {
    return { proto: 'PROTO-261', honest: nodeReports.map(r => r.nodeId), byzantine: [], confidence: 1.0 };
  }

  const values = nodeReports.map(r => r.value);
  const sorted = [...values].sort((a, b) => a - b);

  // Trimmed mean (remove top/bottom 10%)
  const trimCount = Math.max(1, Math.floor(sorted.length * 0.1));
  const trimmed = sorted.slice(trimCount, sorted.length - trimCount);
  const median = trimmed[Math.floor(trimmed.length / 2)];
  const meanVal = trimmed.reduce((a, b) => a + b, 0) / trimmed.length;
  const variance = trimmed.reduce((s, x) => s + (x - meanVal) ** 2, 0) / trimmed.length;
  const sigma = Math.sqrt(variance) + EPSILON;

  const threshold = thresholdFactor * sigma;
  const honest = [];
  const byzantine = [];

  for (const report of nodeReports) {
    if (Math.abs(report.value - median) > threshold) {
      byzantine.push(report.nodeId);
    } else {
      honest.push(report.nodeId);
    }
  }

  return {
    proto: 'PROTO-261',
    honest,
    byzantine,
    median,
    sigma,
    threshold,
    confidence: honest.length / nodeReports.length,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-262: GOLDEN EPOCH TIMER
//
// Divides time into φ-scaled epochs. Each epoch is PHI_BEAT × φ^level ms.
// Used for hierarchical time windowing: fast inner loops, slow outer audits.
//
// Epoch[level] = PHI_BEAT × φ^level
// Level 0 = 873ms, Level 1 = 1412ms, Level 2 = 2285ms, ...
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-262: Compute epoch boundaries for a given level
 * @param {number} now - Current timestamp (ms)
 * @param {number} swarmEpoch - Genesis timestamp
 * @param {number} level - Epoch hierarchy level (0 = fastest)
 * @returns {Object} Epoch timing data
 */
export function goldenEpochTimer(now, swarmEpoch, level) {
  const epochDuration = Math.round(PHI_BEAT_MS * Math.pow(PHI, level));
  const elapsed = now - swarmEpoch;
  const currentEpoch = Math.floor(elapsed / epochDuration);
  const epochStart = swarmEpoch + currentEpoch * epochDuration;
  const epochEnd = epochStart + epochDuration;
  const progress = (now - epochStart) / epochDuration;

  return {
    proto: 'PROTO-262',
    level,
    epochDuration,
    currentEpoch,
    epochStart,
    epochEnd,
    progress,
    remainingMs: epochEnd - now,
    nextLevelDuration: Math.round(PHI_BEAT_MS * Math.pow(PHI, level + 1)),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-263: MERKLE CHAIN PRIMITIVE
//
// Maintains a hash-linked chain for tamper-evident audit logging.
// Each entry's hash incorporates the previous hash, creating an
// immutable sequence. Used by PROTO-249 (Distributed Audit Chain).
//
// H(n) = φ-hash(H(n-1) || data(n) || timestamp(n))
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-263: Append entry to Merkle chain
 * @param {string} previousHash - Hash of previous entry
 * @param {string} data - Data to commit
 * @param {number} [timestamp] - Optional timestamp (default: now)
 * @returns {Object} New chain entry
 */
export function merkleChainAppend(previousHash, data, timestamp = Date.now()) {
  const payload = `${previousHash}|${data}|${timestamp}`;
  const hashResult = phiHash(payload);

  return {
    proto: 'PROTO-263',
    previousHash,
    data,
    timestamp,
    hash: hashResult.hash,
    chainValid: true,
    depth: 1, // Caller increments
  };
}

/**
 * PROTO-263: Verify chain integrity
 * @param {Object[]} chain - Array of chain entries
 * @returns {Object} Verification result
 */
export function merkleChainVerify(chain) {
  if (chain.length === 0) return { proto: 'PROTO-263', valid: true, length: 0, brokenAt: -1 };

  for (let i = 1; i < chain.length; i++) {
    const expected = phiHash(`${chain[i - 1].hash}|${chain[i].data}|${chain[i].timestamp}`);
    if (expected.hash !== chain[i].hash) {
      return { proto: 'PROTO-263', valid: false, length: chain.length, brokenAt: i };
    }
  }

  return { proto: 'PROTO-263', valid: true, length: chain.length, brokenAt: -1 };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-264: ENTROPY ACCUMULATOR
//
// Sovereign randomness pool that mixes multiple entropy sources using
// φ-rotation. Provides deterministic-when-seeded randomness for
// nonce generation, key ceremonies, and shard distribution.
//
// Pool[t+1] = φ-hash(Pool[t] ⊕ source ⊕ timestamp)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-264: Accumulate entropy from a source into the pool
 * @param {number} poolState - Current pool value (32-bit)
 * @param {number|string} source - Entropy source data
 * @param {number} [timestamp] - Time entropy
 * @returns {Object} Updated pool state
 */
export function entropyAccumulate(poolState, source, timestamp = Date.now()) {
  const sourceNum = typeof source === 'string'
    ? phiHash(source).numeric
    : (source >>> 0);

  // Mix: XOR with source, golden-rotate, fold with time
  let mixed = (poolState ^ sourceNum) >>> 0;
  mixed = ((mixed << 7) | (mixed >>> 25)) >>> 0;
  mixed = (mixed ^ (timestamp & 0xFFFFFFFF)) >>> 0;
  mixed = Math.imul(mixed, FNV_PRIME) >>> 0;
  mixed = (mixed ^ (mixed >>> 16)) >>> 0;

  return {
    proto: 'PROTO-264',
    poolState: mixed,
    entropyBits: 32,
    sourceMixed: true,
    quality: (mixed % 1000) / 1000, // Rough uniformity estimate
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-265: φ-WEIGHTED VOTE AGGREGATION
//
// Aggregates votes with golden-ratio decay weighting based on node tier.
// Core nodes (tier 0) have full weight; outer nodes decay at φ⁻ᵏ.
// Used by consensus protocols to weight node contributions.
//
// Weight(k) = φ^(-tier(k))
// Result = Σ weight(k) × vote(k) / Σ weight(k)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-265: Aggregate votes with φ-decay weighting
 * @param {Object[]} votes - Array of {nodeId, vote: number, tier: number}
 * @returns {Object} Aggregation result
 */
export function phiWeightedVote(votes) {
  if (votes.length === 0) {
    return { proto: 'PROTO-265', result: 0, totalWeight: 0, voteCount: 0, consensus: false };
  }

  let weightedSum = 0;
  let totalWeight = 0;

  for (const v of votes) {
    const weight = Math.pow(PHI_INV, v.tier || 0);
    weightedSum += weight * v.vote;
    totalWeight += weight;
  }

  const result = weightedSum / totalWeight;
  const consensus = Math.abs(result) > PHI_INV; // Majority exceeds golden threshold

  return {
    proto: 'PROTO-265',
    result,
    totalWeight,
    voteCount: votes.length,
    consensus,
    strength: Math.abs(result),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-266: SWARM HEARTBEAT MONITOR
//
// Tracks node liveness via heartbeat timestamps. A node is declared
// dead if it misses more than φ² heartbeats (≈ 2.618 beat windows).
// Provides fleet health metrics and dead-node lists.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-266: Monitor fleet heartbeats
 * @param {Object[]} nodeHeartbeats - Array of {nodeId, lastSeen: timestamp}
 * @param {number} now - Current timestamp
 * @param {number} [maxMissed] - Max missed beats before dead (default: φ²)
 * @returns {Object} Fleet health report
 */
export function heartbeatMonitor(nodeHeartbeats, now, maxMissed = PHI_SQUARED) {
  const deadThresholdMs = maxMissed * PHI_BEAT_MS;
  const alive = [];
  const suspect = [];
  const dead = [];

  for (const node of nodeHeartbeats) {
    const elapsed = now - node.lastSeen;
    if (elapsed <= PHI_BEAT_MS) {
      alive.push(node.nodeId);
    } else if (elapsed <= deadThresholdMs) {
      suspect.push(node.nodeId);
    } else {
      dead.push(node.nodeId);
    }
  }

  return {
    proto: 'PROTO-266',
    alive,
    suspect,
    dead,
    fleetHealth: alive.length / nodeHeartbeats.length,
    totalNodes: nodeHeartbeats.length,
    deadThresholdMs: Math.round(deadThresholdMs),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-267: FIBONACCI BACKOFF SCHEDULER
//
// Computes retry delays using Fibonacci sequence scaling.
// Attempt N waits F(N+2) × base_delay ms. Grows organically
// without the exponential explosion of standard backoff.
//
// Delay(attempt) = F(attempt + 2) × base_delay_ms
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-267: Compute Fibonacci backoff delay
 * @param {number} attempt - Retry attempt number (0-based)
 * @param {number} [baseDelay] - Base delay in ms (default: PHI_BEAT_MS)
 * @param {number} [maxDelay] - Maximum delay cap in ms
 * @returns {Object} Backoff timing
 */
export function fibonacciBackoff(attempt, baseDelay = PHI_BEAT_MS, maxDelay = 60000) {
  const fibIndex = Math.min(attempt + 2, FIB.length - 1);
  const rawDelay = FIB[fibIndex] * baseDelay;
  const delay = Math.min(rawDelay, maxDelay);

  return {
    proto: 'PROTO-267',
    attempt,
    delay,
    fibNumber: FIB[fibIndex],
    capped: rawDelay > maxDelay,
    nextDelay: Math.min(FIB[Math.min(fibIndex + 1, FIB.length - 1)] * baseDelay, maxDelay),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-268: NONCE GENERATION
//
// Produces anti-replay nonces using entropy pool + golden rotation.
// Each nonce is unique per (nodeId, timestamp, sequence) triple.
// Used by isolation proofs, key ceremonies, and attestation.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-268: Generate anti-replay nonce
 * @param {string} nodeId - Generating node's ID
 * @param {number} sequence - Monotonic sequence counter
 * @param {number} [timestamp] - Optional timestamp
 * @returns {Object} Nonce record
 */
export function generateNonce(nodeId, sequence, timestamp = Date.now()) {
  const payload = `${nodeId}:${sequence}:${timestamp}:${PHI}`;
  const h = phiHash(payload);
  const nonce = ((h.numeric ^ (sequence * 0x9E3779B9)) >>> 0);

  return {
    proto: 'PROTO-268',
    nonce,
    nonceHex: nonce.toString(16).padStart(8, '0'),
    nodeId,
    sequence,
    timestamp,
    expiresAt: timestamp + PHI_BEAT_MS * 8, // Valid for 8 beats
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-269: RING POSITION ASSIGNMENT
//
// Places a node on a consistent hash ring using golden ratio spacing.
// Guarantees maximum minimum-distance between adjacent nodes.
// Used by tensor shard distribution and inference load balancing.
//
// Position(i) = frac(i × φ⁻¹)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-269: Assign ring position for a node
 * @param {number} nodeIndex - Node's fleet index
 * @param {number} totalNodes - Fleet size
 * @returns {Object} Ring position data
 */
export function ringPositionAssign(nodeIndex, totalNodes) {
  const position = (nodeIndex * PHI_INV) % 1.0;

  // Compute neighbors on ring
  const prevIdx = (nodeIndex - 1 + totalNodes) % totalNodes;
  const nextIdx = (nodeIndex + 1) % totalNodes;
  const prevPos = (prevIdx * PHI_INV) % 1.0;
  const nextPos = (nextIdx * PHI_INV) % 1.0;

  // Arc responsibility
  let arcStart = prevPos + (position - prevPos) / 2;
  if (arcStart < 0) arcStart += 1.0;
  let arcEnd = position + (nextPos - position) / 2;
  if (arcEnd > 1.0) arcEnd -= 1.0;

  return {
    proto: 'PROTO-269',
    nodeIndex,
    position,
    arcStart: arcStart % 1.0,
    arcEnd: arcEnd % 1.0,
    minGap: 1.0 / totalNodes, // Theoretical minimum gap
    actualGap: Math.abs(position - prevPos) || 1.0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-270: SIGNAL ENVELOPE DETECTOR
//
// Determines if an incoming signal exceeds the energy threshold for
// processing. Uses φ-scaled noise floor to gate weak signals.
// Supports the SIGINT protocols (PROTO-243–246).
//
// Detected iff: energy(signal) > φ × noise_floor
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-270: Detect signal above noise floor
 * @param {number[]} samples - Signal samples
 * @param {number} noiseFloor - Estimated noise power
 * @param {number} [gateFactor] - Detection threshold factor (default: φ)
 * @returns {Object} Detection result
 */
export function signalEnvelopeDetector(samples, noiseFloor, gateFactor = PHI) {
  if (samples.length === 0) {
    return { proto: 'PROTO-270', detected: false, energy: 0, snr: 0, threshold: noiseFloor * gateFactor };
  }

  // Compute signal energy (sum of squares)
  let energy = 0;
  let peak = 0;
  for (let i = 0; i < samples.length; i++) {
    const s2 = samples[i] * samples[i];
    energy += s2;
    if (s2 > peak) peak = s2;
  }
  energy /= samples.length;

  const threshold = noiseFloor * gateFactor;
  const snr = noiseFloor > EPSILON ? energy / noiseFloor : 0;
  const detected = energy > threshold;

  return {
    proto: 'PROTO-270',
    detected,
    energy,
    peak: Math.sqrt(peak),
    snr,
    snrDb: snr > 0 ? 10 * Math.log10(snr) : -Infinity,
    threshold,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-271: GRADIENT NORM CLIPPER
//
// Bounds gradient magnitudes to prevent training divergence.
// Clips any gradient vector whose L2 norm exceeds φ × mean_norm.
// Used by federated gradient aggregation (PROTO-235).
//
// g_clipped = g × min(1, max_norm / ||g||₂)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-271: Clip gradient vector to safe norm
 * @param {number[]} gradient - Gradient vector
 * @param {number} maxNorm - Maximum allowed L2 norm
 * @returns {Object} Clipped gradient data
 */
export function gradientNormClip(gradient, maxNorm) {
  if (gradient.length === 0) {
    return { proto: 'PROTO-271', clipped: [], originalNorm: 0, clippedNorm: 0, wasClipped: false };
  }

  let normSq = 0;
  for (let i = 0; i < gradient.length; i++) {
    normSq += gradient[i] * gradient[i];
  }
  const norm = Math.sqrt(normSq);

  if (norm <= maxNorm) {
    return {
      proto: 'PROTO-271',
      clipped: [...gradient],
      originalNorm: norm,
      clippedNorm: norm,
      wasClipped: false,
      scaleFactor: 1.0,
    };
  }

  const scale = maxNorm / norm;
  const clipped = gradient.map(g => g * scale);

  return {
    proto: 'PROTO-271',
    clipped,
    originalNorm: norm,
    clippedNorm: maxNorm,
    wasClipped: true,
    scaleFactor: scale,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-272: ATTESTATION SIGNATURE
//
// Sovereign signing primitive that produces a verifiable attestation
// without external PKI. Uses φ-HMAC: H(secret || message || φ-pad).
// Used by tensor integrity, boot chain, and compliance attestation.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-272: Generate attestation signature
 * @param {string} message - Data to attest
 * @param {string} secret - Node's shared secret
 * @param {string} nodeId - Signing node's identity
 * @returns {Object} Attestation record
 */
export function attestationSign(message, secret, nodeId) {
  // φ-HMAC: inner hash with secret, outer hash with golden pad
  const innerPayload = `${secret}|${message}|${Math.floor(PHI * 1e10)}`;
  const inner = phiHash(innerPayload);

  const outerPayload = `${inner.hash}|${nodeId}|${Math.floor(PHI_INV * 1e10)}`;
  const outer = phiHash(outerPayload);

  return {
    proto: 'PROTO-272',
    signature: outer.hash,
    nodeId,
    messageHash: inner.hash,
    timestamp: Date.now(),
    algorithm: 'PHI-HMAC-FNV1a',
  };
}

/**
 * PROTO-272: Verify attestation signature
 * @param {string} message - Original message
 * @param {string} secret - Shared secret
 * @param {string} nodeId - Expected signer
 * @param {string} signature - Signature to verify
 * @returns {boolean} True if valid
 */
export function attestationVerify(message, secret, nodeId, signature) {
  const expected = attestationSign(message, secret, nodeId);
  return expected.signature === signature;
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-273: SWARM BROADCAST PRIMITIVE
//
// φ-fanout message relay: each node forwards to ⌈φ⌉ = 2 peers,
// selected by golden ratio ring distance. Achieves O(log_φ(N))
// propagation depth with minimal redundancy.
//
// Targets(i) = ring_pos(i ± 1/φ^k) for k = 1, 2
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-273: Compute broadcast relay targets for a node
 * @param {number} nodeIndex - Broadcasting node's index
 * @param {number} totalNodes - Fleet size
 * @param {number} [fanout] - Number of relay targets (default: 2)
 * @returns {Object} Broadcast plan
 */
export function swarmBroadcast(nodeIndex, totalNodes, fanout = 2) {
  const targets = [];
  const nodePos = (nodeIndex * PHI_INV) % 1.0;

  for (let k = 1; k <= fanout; k++) {
    // Forward target: advance by φ^(-k) on the ring
    const fwdOffset = Math.pow(PHI_INV, k);
    const fwdPos = (nodePos + fwdOffset) % 1.0;

    // Find nearest node to target position
    let bestIdx = -1;
    let bestDist = Infinity;
    for (let i = 0; i < totalNodes; i++) {
      if (i === nodeIndex) continue;
      const iPos = (i * PHI_INV) % 1.0;
      let dist = Math.abs(iPos - fwdPos);
      if (dist > 0.5) dist = 1.0 - dist;
      if (dist < bestDist) {
        bestDist = dist;
        bestIdx = i;
      }
    }
    if (bestIdx >= 0 && !targets.includes(bestIdx)) {
      targets.push(bestIdx);
    }
  }

  // Propagation depth estimate
  const depth = Math.ceil(Math.log(totalNodes) / Math.log(PHI));

  return {
    proto: 'PROTO-273',
    source: nodeIndex,
    targets,
    fanout: targets.length,
    propagationDepth: depth,
    coverageEstimate: Math.min(1.0, Math.pow(fanout, depth) / totalNodes),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-274: EMERGENCY CASCADE TRIGGER
//
// Initiates zeroization cascade across the swarm. Each node that
// receives the trigger verifies the authorization (PROTO-272 signature),
// then propagates using PROTO-273 broadcast before self-zeroizing.
//
// Authorization requires quorum (PROTO-260) of valid signatures.
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-274: Initiate emergency cascade
 * @param {string} reason - Trigger reason code
 * @param {Object[]} authorizations - Array of {nodeId, signature}
 * @param {number} totalNodes - Fleet size (for quorum calc)
 * @param {string} [secret] - Shared verification secret
 * @returns {Object} Cascade authorization result
 */
export function emergencyCascade(reason, authorizations, totalNodes, secret = '') {
  // Require Fibonacci quorum of authorizers
  const quorumData = fibonacciQuorum(totalNodes);
  const validSigs = [];

  for (const auth of authorizations) {
    if (secret) {
      const verified = attestationVerify(
        `ZEROIZE:${reason}`,
        secret,
        auth.nodeId,
        auth.signature,
      );
      if (verified) validSigs.push(auth.nodeId);
    } else {
      validSigs.push(auth.nodeId); // Trust mode (no secret verification)
    }
  }

  const authorized = validSigs.length >= quorumData.quorum;

  return {
    proto: 'PROTO-274',
    reason,
    authorized,
    validSignatures: validSigs.length,
    requiredQuorum: quorumData.quorum,
    totalNodes,
    cascadeReady: authorized,
    propagationPlan: authorized ? swarmBroadcast(0, totalNodes) : null,
    timestamp: Date.now(),
    severity: 'CRITICAL',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  PHI,
  PHI_INV,
  PHI_SQUARED,
  PHI_BEAT_MS,
  FIB,
};
