/**
 * PROTO-235 through PROTO-238 — SWARM Neural Protocols
 * Domain: SovereignNeuralEngine — Federated Learning & Swarm Neural Consensus
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * These protocols enable the CHIMERIA swarm to train, synchronize, and evolve
 * neural networks collectively without centralizing training data or model weights.
 *
 * ZERO EXTERNAL DEPENDENCIES — All neural computation sovereign.
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const EPSILON = 1e-10;

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-235: FEDERATED GRADIENT AGGREGATION PROTOCOL
//
// Each swarm node trains locally and transmits gradient updates.
// The aggregation uses φ-weighted FedAvg with Byzantine resilience:
// Trimmed mean excludes outlier gradients beyond φ·σ from the mean.
//
// ΔW_global = Σ_k (n_k/N) × clip(ΔW_k, φ·σ)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute mean of an array
 * @param {number[]} arr
 * @returns {number}
 */
function mean(arr) {
  if (arr.length === 0) return 0;
  return arr.reduce((a, b) => a + b, 0) / arr.length;
}

/**
 * Compute standard deviation
 * @param {number[]} arr
 * @returns {number}
 */
function stddev(arr) {
  if (arr.length < 2) return 0;
  const m = mean(arr);
  const variance = arr.reduce((sum, x) => sum + (x - m) * (x - m), 0) / arr.length;
  return Math.sqrt(variance);
}

/**
 * PROTO-235: Federated Gradient Aggregation
 * Byzantine-resilient gradient averaging with φ·σ clipping
 *
 * @param {Object[]} nodeGradients - Array of {nodeId, gradients: number[], sampleCount}
 * @param {Object} [options] - Options
 * @param {number} [options.clipFactor] - Clipping threshold factor (default: φ)
 * @returns {Object} Aggregated global gradient update
 */
function federatedGradientAggregation(nodeGradients, options = {}) {
  const clipFactor = options.clipFactor ?? PHI;
  const N = nodeGradients.length;

  if (N === 0) return { protocol: 'PROTO-235', error: 'No gradients' };

  const gradientLength = nodeGradients[0].gradients.length;
  const totalSamples = nodeGradients.reduce((s, ng) => s + ng.sampleCount, 0);

  // Per-dimension: compute mean, stddev, then trimmed mean
  const globalGradient = new Array(gradientLength).fill(0);
  const clippedNodes = [];

  for (let d = 0; d < gradientLength; d++) {
    const values = nodeGradients.map(ng => ng.gradients[d]);
    const m = mean(values);
    const s = stddev(values);
    const clipThreshold = clipFactor * s;

    let weightedSum = 0;
    let weightTotal = 0;

    for (let k = 0; k < N; k++) {
      const val = nodeGradients[k].gradients[d];
      const deviation = Math.abs(val - m);

      if (deviation > clipThreshold && s > EPSILON) {
        // Clip to boundary
        const clipped = m + Math.sign(val - m) * clipThreshold;
        weightedSum += clipped * (nodeGradients[k].sampleCount / totalSamples);
        if (!clippedNodes.includes(nodeGradients[k].nodeId)) {
          clippedNodes.push(nodeGradients[k].nodeId);
        }
      } else {
        weightedSum += val * (nodeGradients[k].sampleCount / totalSamples);
      }
      weightTotal += nodeGradients[k].sampleCount / totalSamples;
    }

    globalGradient[d] = weightTotal > EPSILON ? weightedSum / weightTotal : 0;
  }

  return {
    protocol: 'PROTO-235',
    name: 'Federated Gradient Aggregation',
    module: 'SovereignNeuralEngine',
    nodeCount: N,
    gradientDimensions: gradientLength,
    totalSamples,
    clipFactor,
    clippedNodes,
    clippedRatio: clippedNodes.length / N,
    globalGradient,
    l2Norm: Math.sqrt(globalGradient.reduce((s, g) => s + g * g, 0)),
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-236: SWARM ATTENTION SYNCHRONIZATION PROTOCOL
//
// Synchronizes multi-head attention weights across fleet nodes.
// Uses Kuramoto-inspired phase alignment on attention score distributions.
// When attention coherence R > φ⁻¹, the fleet achieves "shared focus."
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Softmax over an array (sovereign, no deps)
 * @param {number[]} logits
 * @returns {number[]}
 */
function softmax(logits) {
  const maxVal = Math.max(...logits);
  const exps = logits.map(x => Math.exp(x - maxVal));
  const sumExp = exps.reduce((a, b) => a + b, 0);
  return exps.map(e => e / sumExp);
}

/**
 * KL-divergence between two distributions
 * @param {number[]} P - Reference distribution
 * @param {number[]} Q - Approximation
 * @returns {number}
 */
function klDivergence(P, Q) {
  let kl = 0;
  for (let i = 0; i < P.length; i++) {
    if (P[i] > EPSILON && Q[i] > EPSILON) {
      kl += P[i] * Math.log(P[i] / Q[i]);
    }
  }
  return kl;
}

/**
 * PROTO-236: Swarm Attention Synchronization
 * Aligns attention distributions across fleet nodes
 *
 * @param {Object[]} nodeAttentions - Array of {nodeId, attentionScores: number[]}
 * @param {Object} [options] - Options
 * @param {number} [options.coherenceThreshold] - Threshold for shared focus (default: φ⁻¹)
 * @returns {Object} Synchronization state with coherence metrics
 */
function swarmAttentionSync(nodeAttentions, options = {}) {
  const coherenceThreshold = options.coherenceThreshold ?? PHI_INV;
  const N = nodeAttentions.length;

  if (N === 0) return { protocol: 'PROTO-236', error: 'No attention data' };

  // Normalize all attention scores to distributions
  const distributions = nodeAttentions.map(na => softmax(na.attentionScores));

  // Compute centroid distribution (mean attention)
  const dim = distributions[0].length;
  const centroid = new Array(dim).fill(0);
  for (const dist of distributions) {
    for (let i = 0; i < dim; i++) {
      centroid[i] += dist[i] / N;
    }
  }

  // Compute coherence: 1 - mean(KL(node || centroid))
  const divergences = distributions.map(dist => klDivergence(dist, centroid));
  const meanDivergence = mean(divergences);
  const coherence = Math.exp(-meanDivergence); // Map to [0,1]

  const sharedFocus = coherence > coherenceThreshold;

  // Find most-attended position (swarm consensus attention)
  const focusPosition = centroid.indexOf(Math.max(...centroid));

  return {
    protocol: 'PROTO-236',
    name: 'Swarm Attention Synchronization',
    module: 'SovereignNeuralEngine',
    nodeCount: N,
    attentionDimension: dim,
    coherence,
    coherenceThreshold,
    sharedFocus,
    meanDivergence,
    focusPosition,
    centroidDistribution: centroid,
    nodeDivergences: nodeAttentions.map((na, i) => ({
      nodeId: na.nodeId,
      divergence: divergences[i],
      aligned: divergences[i] < -Math.log(coherenceThreshold),
    })),
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-237: NEURAL WEIGHT GOSSIP PROTOCOL
//
// Decentralized weight sharing using gossip protocol.
// Each round, a node shares weights with φ⁻¹ fraction of peers.
// Convergence guaranteed by exponential mixing (O(log N) rounds).
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PROTO-237: Neural Weight Gossip
 * Decentralized model synchronization via gossip protocol
 *
 * @param {Object[]} nodeModels - Array of {nodeId, weights: number[], version}
 * @param {number} initiatorId - Node initiating gossip round
 * @param {Object} [options] - Options
 * @param {number} [options.fanout] - Number of peers to gossip to (default: ceil(N×φ⁻¹))
 * @param {number} [options.mixingRate] - Weight averaging rate (default: 0.5)
 * @returns {Object} Gossip round result
 */
function neuralWeightGossip(nodeModels, initiatorId, options = {}) {
  const N = nodeModels.length;
  const fanout = options.fanout ?? Math.ceil(N * PHI_INV);
  const mixingRate = options.mixingRate ?? 0.5;

  const initiator = nodeModels.find(nm => nm.nodeId === initiatorId);
  if (!initiator) return { protocol: 'PROTO-237', error: 'Initiator not found' };

  // Select peers (deterministic selection based on version for reproducibility)
  const peers = nodeModels
    .filter(nm => nm.nodeId !== initiatorId)
    .sort((a, b) => {
      const ha = (a.nodeId * 2654435761 + initiator.version) % 1000;
      const hb = (b.nodeId * 2654435761 + initiator.version) % 1000;
      return ha - hb;
    })
    .slice(0, fanout);

  // Average weights with selected peers
  const dim = initiator.weights.length;
  const newWeights = new Array(dim);

  for (let d = 0; d < dim; d++) {
    let peerSum = 0;
    for (const peer of peers) {
      peerSum += peer.weights[d];
    }
    const peerMean = peers.length > 0 ? peerSum / peers.length : initiator.weights[d];
    newWeights[d] = (1 - mixingRate) * initiator.weights[d] + mixingRate * peerMean;
  }

  // Convergence metric: L2 distance between old and new weights
  let l2Delta = 0;
  for (let d = 0; d < dim; d++) {
    const diff = newWeights[d] - initiator.weights[d];
    l2Delta += diff * diff;
  }
  l2Delta = Math.sqrt(l2Delta);

  return {
    protocol: 'PROTO-237',
    name: 'Neural Weight Gossip',
    module: 'SovereignNeuralEngine',
    initiatorId,
    fanout,
    peersContacted: peers.map(p => p.nodeId),
    mixingRate,
    weightDimension: dim,
    l2Delta,
    converged: l2Delta < EPSILON,
    roundsToConverge: Math.ceil(Math.log(N) / Math.log(fanout + 1)),
    newWeights,
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-238: SWARM KNOWLEDGE DISTILLATION PROTOCOL
//
// Distills collective swarm knowledge into a compact student model.
// Teacher ensemble: soft labels from all fleet models averaged.
// Temperature scaling: T = φ (golden-ratio temperature for soft targets).
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Temperature-scaled softmax
 * @param {number[]} logits
 * @param {number} T - Temperature
 * @returns {number[]}
 */
function temperatureSoftmax(logits, T) {
  const scaled = logits.map(x => x / T);
  return softmax(scaled);
}

/**
 * PROTO-238: Swarm Knowledge Distillation
 * Distills fleet-wide knowledge into compact model using φ-temperature
 *
 * @param {Object[]} teacherOutputs - Array of {nodeId, logits: number[]}
 * @param {number[]} studentLogits - Current student model outputs
 * @param {Object} [options] - Options
 * @param {number} [options.temperature] - Distillation temperature (default: φ)
 * @param {number} [options.alpha] - Hard vs soft label balance (default: φ⁻¹)
 * @returns {Object} Distillation result with loss and gradient signals
 */
function swarmKnowledgeDistillation(teacherOutputs, studentLogits, options = {}) {
  const T = options.temperature ?? PHI;
  const alpha = options.alpha ?? PHI_INV;
  const N = teacherOutputs.length;

  if (N === 0) return { protocol: 'PROTO-238', error: 'No teacher outputs' };

  const dim = teacherOutputs[0].logits.length;

  // Ensemble teacher: average soft labels at temperature T
  const ensembleSoft = new Array(dim).fill(0);
  for (const teacher of teacherOutputs) {
    const soft = temperatureSoftmax(teacher.logits, T);
    for (let i = 0; i < dim; i++) {
      ensembleSoft[i] += soft[i] / N;
    }
  }

  // Student soft labels at temperature T
  const studentSoft = temperatureSoftmax(studentLogits, T);

  // KL-divergence loss (distillation loss)
  const distillationLoss = klDivergence(ensembleSoft, studentSoft);

  // Gradient signal for student (simplified: soft_teacher - soft_student)
  const gradientSignal = ensembleSoft.map((t, i) => (t - studentSoft[i]) * T * T);

  // Teacher agreement (how much teachers agree with each other)
  const teacherSofts = teacherOutputs.map(t => temperatureSoftmax(t.logits, T));
  const teacherVariance = new Array(dim).fill(0);
  for (let i = 0; i < dim; i++) {
    const vals = teacherSofts.map(ts => ts[i]);
    const m = mean(vals);
    teacherVariance[i] = mean(vals.map(v => (v - m) * (v - m)));
  }
  const meanTeacherVariance = mean(teacherVariance);

  return {
    protocol: 'PROTO-238',
    name: 'Swarm Knowledge Distillation',
    module: 'SovereignNeuralEngine',
    teacherCount: N,
    outputDimension: dim,
    temperature: T,
    alpha,
    distillationLoss,
    teacherAgreement: 1 - meanTeacherVariance * dim,
    ensembleSoftLabels: ensembleSoft,
    gradientSignal,
    gradientNorm: Math.sqrt(gradientSignal.reduce((s, g) => s + g * g, 0)),
    timestamp: Date.now(),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

export {
  // Utilities
  mean, stddev, softmax, klDivergence, temperatureSoftmax,
  // PROTO-235
  federatedGradientAggregation,
  // PROTO-236
  swarmAttentionSync,
  // PROTO-237
  neuralWeightGossip,
  // PROTO-238
  swarmKnowledgeDistillation,
};
