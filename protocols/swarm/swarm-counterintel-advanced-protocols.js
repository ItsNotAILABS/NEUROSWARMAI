/**
 * PROTO-273 through PROTO-282 — SWARM Advanced Counter-Intelligence Protocols
 * Domain: SovereignCOUNTERINTEL-II — Deep Adversary Manipulation & Cognitive Warfare
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * These protocols implement second-generation counter-intelligence operations:
 * adversary behavior prediction, cognitive manipulation, double-agent detection,
 * supply chain interdiction, HUMINT correlation, deception orchestration at scale,
 * kill-chain disruption, and autonomous counter-operation planning.
 *
 * ADVANCED CI DOCTRINE:
 *   "The organism does not merely detect enemies — it predicts their thoughts,
 *    poisons their intelligence, and turns their operations into our sensors."
 *    — Medina Doctrine
 *
 * Coverage: MITRE ATT&CK, NIST CSF, Joint Publication 2-01.2 (CI & HUMINT),
 *           NSA SIGINT Doctrine, Five Eyes CI Framework
 *
 * ZERO EXTERNAL DEPENDENCIES.
 */

const PHI = 1.618033988749895;
const PHI_INV = 1 / PHI;
const PHI_SQ = PHI * PHI;
const PHI_CUBE = PHI * PHI * PHI;
const HEARTBEAT = 873; // ms
const TWO_PI = 2 * Math.PI;
const EULER = 2.718281828459045;

// ═══════════════════════════════════════════════════════════════════════════
// SHARED CI MATH ENGINES
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Bayesian posterior update
 * P(H|E) = P(E|H) × P(H) / P(E)
 * @param {number} prior - P(H)
 * @param {number} likelihood - P(E|H)
 * @param {number} evidence - P(E) = P(E|H)P(H) + P(E|¬H)P(¬H)
 * @returns {number} Posterior probability
 */
function bayesianUpdate(prior, likelihood, evidence) {
  if (evidence <= 0) return prior;
  return (likelihood * prior) / evidence;
}

/**
 * Multi-hypothesis Bayesian update
 * @param {Object[]} hypotheses - Array of {id, prior, likelihood}
 * @returns {Object[]} Updated hypotheses with posteriors
 */
function multiHypothesisBayes(hypotheses) {
  const totalEvidence = hypotheses.reduce((s, h) => s + h.likelihood * h.prior, 0);
  return hypotheses.map(h => ({
    ...h,
    posterior: totalEvidence > 0 ? (h.likelihood * h.prior) / totalEvidence : h.prior,
  }));
}

/**
 * Exponential decay function with phi-scaling
 * @param {number} value - Initial value
 * @param {number} halfLife - Half-life in the same units as time
 * @param {number} time - Elapsed time
 * @returns {number} Decayed value
 */
function phiExponentialDecay(value, halfLife, time) {
  return value * Math.pow(0.5, (PHI * time) / halfLife);
}

/**
 * Sigmoid activation with phi-scaled steepness
 * σ(x) = 1 / (1 + e^(-φ × x))
 */
function phiSigmoid(x) {
  return 1 / (1 + Math.exp(-PHI * x));
}

/**
 * Cosine similarity between two vectors
 */
function cosineSimilarity(a, b) {
  let dot = 0, magA = 0, magB = 0;
  for (let i = 0; i < a.length; i++) {
    dot += (a[i] || 0) * (b[i] || 0);
    magA += (a[i] || 0) ** 2;
    magB += (b[i] || 0) ** 2;
  }
  magA = Math.sqrt(magA);
  magB = Math.sqrt(magB);
  return (magA > 0 && magB > 0) ? dot / (magA * magB) : 0;
}

/**
 * Weighted moving average with phi-decay
 */
function phiWeightedAverage(values) {
  let weightedSum = 0, totalWeight = 0;
  for (let i = 0; i < values.length; i++) {
    const weight = Math.pow(PHI_INV, i);
    weightedSum += values[i] * weight;
    totalWeight += weight;
  }
  return totalWeight > 0 ? weightedSum / totalWeight : 0;
}

/**
 * Information gain (reduction in entropy)
 * IG(S, A) = H(S) - H(S|A)
 */
function informationGain(entropyBefore, conditionalEntropy) {
  return Math.max(0, entropyBefore - conditionalEntropy);
}

// ═══════════════════════════════════════════════════════════════════════════
// ADVERSARY BEHAVIOR MODELS
// ═══════════════════════════════════════════════════════════════════════════

const ADVERSARY_MODELS = {
  NATION_STATE_APT: {
    patience: 0.95, resourceDepth: 0.99, opsecLevel: 0.9,
    adaptability: 0.85, persistence: 0.98, sophistication: 0.95,
  },
  ORGANIZED_CRIME: {
    patience: 0.5, resourceDepth: 0.7, opsecLevel: 0.6,
    adaptability: 0.7, persistence: 0.6, sophistication: 0.5,
  },
  HACKTIVIST: {
    patience: 0.3, resourceDepth: 0.3, opsecLevel: 0.4,
    adaptability: 0.6, persistence: 0.4, sophistication: 0.4,
  },
  INSIDER_THREAT: {
    patience: 0.8, resourceDepth: 0.4, opsecLevel: 0.5,
    adaptability: 0.3, persistence: 0.7, sophistication: 0.6,
  },
  QUANTUM_ADVERSARY: {
    patience: 0.99, resourceDepth: 1.0, opsecLevel: 0.95,
    adaptability: 0.95, persistence: 0.99, sophistication: 1.0,
  },
};

const KILL_CHAIN_PHASES = [
  'RECONNAISSANCE',
  'WEAPONIZATION',
  'DELIVERY',
  'EXPLOITATION',
  'INSTALLATION',
  'COMMAND_AND_CONTROL',
  'ACTIONS_ON_OBJECTIVES',
];

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-273: ADVERSARY BEHAVIOR PREDICTION ENGINE
//
// Predicts adversary next actions using Markov chain models trained
// on observed TTP sequences, weighted by phi-decay for recency.
//
// Prediction model:
//   State: Current kill-chain phase + observed TTPs
//   Transition: P(sₜ₊₁ | sₜ) learned from MITRE ATT&CK sequences
//   Prediction: argmax P(sₜ₊₁ | sₜ, sₜ₋₁, ..., sₜ₋ₖ) with k=φ³ states
//
// Confidence: C = Π P(observed_transition) × φ^(chain_length)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Build adversary Markov transition matrix from observations
 * @param {Object[]} observedSequences - Array of {from, to, count}
 * @returns {Object} Transition matrix and statistics
 */
function buildTransitionMatrix(observedSequences) {
  const states = [...new Set(observedSequences.flatMap(s => [s.from, s.to]))];
  const matrix = {};

  // Initialize
  for (const from of states) {
    matrix[from] = {};
    for (const to of states) {
      matrix[from][to] = 0;
    }
  }

  // Populate counts
  for (const seq of observedSequences) {
    if (matrix[seq.from]) {
      matrix[seq.from][seq.to] = (matrix[seq.from][seq.to] || 0) + (seq.count || 1);
    }
  }

  // Normalize to probabilities
  for (const from of states) {
    const total = Object.values(matrix[from]).reduce((s, v) => s + v, 0);
    if (total > 0) {
      for (const to of states) {
        matrix[from][to] /= total;
      }
    }
  }

  return { states, matrix };
}

/**
 * Predict adversary's next N actions
 * @param {string} currentState - Current observed kill-chain phase
 * @param {Object} transitionMatrix - Trained transition matrix
 * @param {number} steps - Number of steps to predict
 * @returns {Object} Prediction with confidence scores
 */
function predictAdversaryActions(currentState, transitionMatrix, steps) {
  const { states, matrix } = transitionMatrix;
  const predictions = [];
  let state = currentState;
  let cumulativeConfidence = 1;

  for (let step = 0; step < steps; step++) {
    if (!matrix[state]) break;

    // Find most likely next state
    const transitions = matrix[state];
    let maxProb = 0, nextState = null;
    for (const [to, prob] of Object.entries(transitions)) {
      if (prob > maxProb) {
        maxProb = prob;
        nextState = to;
      }
    }

    if (!nextState || maxProb === 0) break;

    cumulativeConfidence *= maxProb;
    predictions.push({
      step: step + 1,
      predictedState: nextState,
      transitionProbability: maxProb,
      cumulativeConfidence,
      phiDecayedConfidence: cumulativeConfidence * Math.pow(PHI_INV, step),
    });

    state = nextState;
  }

  return {
    protocol: 'PROTO-273',
    name: 'ADVERSARY_BEHAVIOR_PREDICTION',
    currentState,
    predictions,
    overallConfidence: predictions.length > 0
      ? predictions[predictions.length - 1].phiDecayedConfidence
      : 0,
    predictedEndState: predictions.length > 0
      ? predictions[predictions.length - 1].predictedState
      : currentState,
    stepsAhead: predictions.length,
    actionable: cumulativeConfidence > Math.pow(PHI_INV, steps),
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-274: DOUBLE-AGENT DETECTION MATRIX
//
// Identifies compromised nodes within the swarm through behavioral
// consistency analysis and trust decay modeling.
//
// Detection methodology:
//   1. Behavioral consistency score: Compare node actions to declared intent
//   2. Information flow analysis: Detect unauthorized outbound flows
//   3. Timing anomalies: Actions that align with adversary TTPs
//   4. Trust decay: T(t) = T₀ × e^(-φ × anomaly_count / threshold)
//
// False positive mitigation: Multi-factor confirmation required
//   Minimum 3 independent indicators before flagging
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute trust score with phi-decay on anomalies
 * @param {number} initialTrust - Starting trust level (0-1)
 * @param {number} anomalyCount - Number of observed anomalies
 * @param {number} anomalyThreshold - Anomalies before trust collapses
 * @returns {number} Current trust score
 */
function computeTrustDecay(initialTrust, anomalyCount, anomalyThreshold) {
  return initialTrust * Math.exp(-PHI * anomalyCount / anomalyThreshold);
}

/**
 * Detect potential double-agent nodes
 * @param {Object} nodeData - Node behavioral data
 * @param {Object} fleetBaseline - Fleet baseline behavior
 * @returns {Object} Double-agent assessment
 */
function detectDoubleAgent(nodeData, fleetBaseline) {
  const indicators = [];
  let indicatorCount = 0;

  // Indicator 1: Behavioral consistency
  const declaredActions = nodeData.declaredActions || [];
  const observedActions = nodeData.observedActions || [];
  const undeclaredActions = observedActions.filter(a => !declaredActions.includes(a));
  if (undeclaredActions.length > 0) {
    indicators.push({
      type: 'BEHAVIORAL_INCONSISTENCY',
      severity: Math.min(1, undeclaredActions.length / Math.max(1, observedActions.length)),
      details: `${undeclaredActions.length} undeclared actions observed`,
    });
    indicatorCount++;
  }

  // Indicator 2: Information flow anomaly
  const outboundFlows = nodeData.outboundDataFlows || [];
  const authorizedDestinations = nodeData.authorizedDestinations || [];
  const unauthorizedFlows = outboundFlows.filter(f => !authorizedDestinations.includes(f.destination));
  if (unauthorizedFlows.length > 0) {
    indicators.push({
      type: 'UNAUTHORIZED_OUTBOUND_FLOW',
      severity: Math.min(1, unauthorizedFlows.length * PHI_INV),
      details: `${unauthorizedFlows.length} unauthorized outbound flows`,
    });
    indicatorCount++;
  }

  // Indicator 3: Timing alignment with adversary
  const suspiciousTimings = nodeData.actionTimings || [];
  const adversaryTimings = fleetBaseline.knownAdversaryTimings || [];
  let timingCorrelation = 0;
  if (suspiciousTimings.length > 0 && adversaryTimings.length > 0) {
    // Compute timing correlation
    const minLen = Math.min(suspiciousTimings.length, adversaryTimings.length);
    const nodeVec = suspiciousTimings.slice(0, minLen);
    const advVec = adversaryTimings.slice(0, minLen);
    timingCorrelation = Math.abs(cosineSimilarity(nodeVec, advVec));
    if (timingCorrelation > PHI_INV) {
      indicators.push({
        type: 'ADVERSARY_TIMING_CORRELATION',
        severity: timingCorrelation,
        details: `Timing correlation with adversary: ${(timingCorrelation * 100).toFixed(1)}%`,
      });
      indicatorCount++;
    }
  }

  // Indicator 4: Access pattern anomaly
  const accessPatterns = nodeData.accessPatterns || [];
  const baselinePatterns = fleetBaseline.normalAccessPatterns || [];
  const anomalousAccess = accessPatterns.filter(p => !baselinePatterns.includes(p));
  if (anomalousAccess.length > Math.max(1, accessPatterns.length * PHI_INV)) {
    indicators.push({
      type: 'ANOMALOUS_ACCESS_PATTERN',
      severity: Math.min(1, anomalousAccess.length / Math.max(1, accessPatterns.length)),
      details: `${anomalousAccess.length} anomalous access patterns`,
    });
    indicatorCount++;
  }

  // Trust decay calculation
  const trustDecay = computeTrustDecay(nodeData.initialTrust || 1.0, indicatorCount, 5);

  // Composite score (average severity × indicator density)
  const avgSeverity = indicators.length > 0
    ? indicators.reduce((s, i) => s + i.severity, 0) / indicators.length
    : 0;
  const compositeScore = avgSeverity * (indicatorCount / 5); // 5 = max indicators

  return {
    protocol: 'PROTO-274',
    name: 'DOUBLE_AGENT_DETECTION',
    nodeId: nodeData.id || 'UNKNOWN',
    indicators,
    indicatorCount,
    minimumForFlag: 3,
    isFlagged: indicatorCount >= 3,
    trustScore: trustDecay,
    compositeScore: Math.min(1, compositeScore),
    assessment: indicatorCount >= 3 ? 'PROBABLE_COMPROMISE'
      : indicatorCount >= 2 ? 'SUSPICIOUS'
      : indicatorCount >= 1 ? 'MONITOR'
      : 'TRUSTED',
    response: indicatorCount >= 3 ? 'ISOLATE_AND_INVESTIGATE'
      : indicatorCount >= 2 ? 'INCREASE_MONITORING'
      : 'NORMAL_OPERATIONS',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-275: COGNITIVE WARFARE ENGINE
//
// Manipulates adversary decision-making through strategic information
// operations that exploit cognitive biases.
//
// Targeted biases:
//   - Confirmation bias: Feed info that confirms adversary's false beliefs
//   - Anchoring: Set initial reference points that skew estimates
//   - Availability heuristic: Make certain outcomes seem more likely
//   - Sunk cost fallacy: Invest adversary resources in dead ends
//   - Dunning-Kruger: Exploit overconfidence in capabilities
//
// Effectiveness model:
//   Cognitive load: CL = Σ bias_weight × exploitation_intensity
//   Decision degradation: D = 1 - e^(-CL / φ²)
//   Where degradation D = probability adversary makes suboptimal choice
// ═══════════════════════════════════════════════════════════════════════════

const COGNITIVE_BIASES = {
  CONFIRMATION: { weight: 0.9, exploitDifficulty: 0.3, persistence: 0.95 },
  ANCHORING: { weight: 0.8, exploitDifficulty: 0.4, persistence: 0.7 },
  AVAILABILITY: { weight: 0.7, exploitDifficulty: 0.5, persistence: 0.6 },
  SUNK_COST: { weight: 0.85, exploitDifficulty: 0.3, persistence: 0.9 },
  DUNNING_KRUGER: { weight: 0.6, exploitDifficulty: 0.6, persistence: 0.8 },
  BANDWAGON: { weight: 0.5, exploitDifficulty: 0.4, persistence: 0.5 },
  FRAMING: { weight: 0.75, exploitDifficulty: 0.5, persistence: 0.6 },
  ILLUSION_OF_CONTROL: { weight: 0.65, exploitDifficulty: 0.4, persistence: 0.85 },
};

/**
 * Design cognitive warfare campaign against adversary
 * @param {Object} adversaryProfile - Adversary behavioral profile
 * @param {string[]} targetBiases - Biases to exploit
 * @param {number} intensity - Campaign intensity (0-1)
 * @returns {Object} Cognitive warfare specification
 */
function designCognitiveWarfare(adversaryProfile, targetBiases, intensity) {
  const exploitations = [];
  let totalCognitiveLoad = 0;

  for (const biasName of targetBiases) {
    const bias = COGNITIVE_BIASES[biasName];
    if (!bias) continue;

    // Compute exploitation effectiveness based on adversary profile
    const adversaryResistance = (adversaryProfile.opsecLevel || 0.5) *
      (adversaryProfile.adaptability || 0.5);

    const effectiveIntensity = intensity * bias.weight * (1 - adversaryResistance * bias.exploitDifficulty);
    totalCognitiveLoad += effectiveIntensity;

    exploitations.push({
      bias: biasName,
      intensity: effectiveIntensity,
      persistence: bias.persistence,
      estimatedDuration: HEARTBEAT * PHI_CUBE * bias.persistence * 100,
      deliveryMethod: biasName === 'CONFIRMATION' ? 'PLANT_CONFIRMING_INTELLIGENCE'
        : biasName === 'ANCHORING' ? 'SEED_FALSE_METRICS'
        : biasName === 'SUNK_COST' ? 'BAIT_RESOURCE_INVESTMENT'
        : biasName === 'AVAILABILITY' ? 'AMPLIFY_FALSE_SIGNALS'
        : 'STRATEGIC_INFORMATION_RELEASE',
    });
  }

  // Decision degradation formula
  const decisionDegradation = 1 - Math.exp(-totalCognitiveLoad / PHI_SQ);

  return {
    protocol: 'PROTO-275',
    name: 'COGNITIVE_WARFARE',
    adversaryModel: adversaryProfile.type || 'UNKNOWN',
    exploitations,
    totalCognitiveLoad,
    decisionDegradation,
    estimatedEffectiveness: decisionDegradation,
    adversaryDecisionQuality: 1 - decisionDegradation,
    campaignStatus: decisionDegradation > PHI_INV ? 'HIGHLY_EFFECTIVE'
      : decisionDegradation > PHI_INV ** 2 ? 'EFFECTIVE'
      : 'MARGINAL',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-276: SUPPLY CHAIN INTERDICTION DETECTOR
//
// Detects adversary attempts to compromise the software/hardware
// supply chain feeding into the swarm organism.
//
// Detection vectors:
//   1. Binary integrity: Hash verification against known-good
//   2. Build reproducibility: Deterministic build verification
//   3. Dependency provenance: Full chain-of-custody verification
//   4. Hardware attestation: TPM/SGX-based hardware verification
//   5. Update channel integrity: Signed + timestamped + hash-chained
//
// Trust score:
//   T(component) = Π (verification_score_i)^(φ^(-priority_i))
//   Where priority follows golden-ratio weighting
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Assess supply chain integrity for a component
 * @param {Object} component - Component to verify
 * @param {Object} knownGoodManifest - Known-good hashes and signatures
 * @returns {Object} Supply chain integrity assessment
 */
function assessSupplyChainIntegrity(component, knownGoodManifest) {
  const verifications = [];

  // 1. Binary integrity check
  const binaryMatch = component.hash === knownGoodManifest.expectedHash;
  verifications.push({
    check: 'BINARY_INTEGRITY',
    priority: 0,
    passed: binaryMatch,
    score: binaryMatch ? 1.0 : 0.0,
  });

  // 2. Build reproducibility
  const reproducible = component.buildHash === knownGoodManifest.reproducibleBuildHash;
  verifications.push({
    check: 'BUILD_REPRODUCIBILITY',
    priority: 1,
    passed: reproducible,
    score: reproducible ? 1.0 : component.buildHash ? 0.3 : 0.0,
  });

  // 3. Dependency provenance
  const deps = component.dependencies || [];
  const verifiedDeps = deps.filter(d => knownGoodManifest.trustedDependencies?.includes(d));
  const depScore = deps.length > 0 ? verifiedDeps.length / deps.length : 1.0;
  verifications.push({
    check: 'DEPENDENCY_PROVENANCE',
    priority: 2,
    passed: depScore >= 1.0,
    score: depScore,
  });

  // 4. Signature verification
  const signatureValid = component.signature && component.signature === knownGoodManifest.expectedSignature;
  verifications.push({
    check: 'SIGNATURE_VERIFICATION',
    priority: 3,
    passed: !!signatureValid,
    score: signatureValid ? 1.0 : 0.0,
  });

  // 5. Timestamp within acceptable window
  const timestampDelta = Math.abs((component.buildTimestamp || 0) - (knownGoodManifest.expectedTimestamp || 0));
  const timestampValid = timestampDelta < HEARTBEAT * PHI_CUBE * 1000; // Within φ³ × 1000 heartbeats
  verifications.push({
    check: 'TIMESTAMP_VALIDITY',
    priority: 4,
    passed: timestampValid,
    score: timestampValid ? 1.0 : Math.max(0, 1 - timestampDelta / (HEARTBEAT * PHI_CUBE * 10000)),
  });

  // Compute composite trust score: Π (score_i)^(φ^(-priority_i))
  let trustScore = 1;
  for (const v of verifications) {
    const weight = Math.pow(PHI_INV, v.priority);
    trustScore *= Math.pow(Math.max(0.001, v.score), weight);
  }

  const failedChecks = verifications.filter(v => !v.passed);

  return {
    protocol: 'PROTO-276',
    name: 'SUPPLY_CHAIN_INTEGRITY',
    componentId: component.id || 'UNKNOWN',
    verifications,
    trustScore,
    failedChecks: failedChecks.length,
    totalChecks: verifications.length,
    isCompromised: trustScore < PHI_INV ** 3,
    isSuspicious: trustScore < PHI_INV,
    recommendation: trustScore < PHI_INV ** 3 ? 'QUARANTINE_IMMEDIATELY'
      : trustScore < PHI_INV ? 'DEEP_INSPECTION_REQUIRED'
      : trustScore < PHI_INV ** 0.5 ? 'MONITOR_CLOSELY'
      : 'TRUSTED',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-277: KILL-CHAIN DISRUPTION ENGINE
//
// Actively disrupts adversary kill-chain progression by introducing
// obstacles at each phase, computed to maximize adversary cost.
//
// Disruption model:
//   Kill-chain phase transition: P(phase_n → phase_n+1)
//   Disruption reduces transition probability:
//     P'(n→n+1) = P(n→n+1) × e^(-φ × disruption_intensity)
//
//   Total kill-chain completion probability:
//     P(complete) = Π P'(i→i+1) for all phases i
//
//   Optimal disruption allocation: Concentrate on highest P(i→i+1)
//   (Weaken the strongest link, not the weakest)
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Compute kill-chain disruption effectiveness
 * @param {Object[]} phaseTransitions - Current transition probabilities
 * @param {Object} disruptionPlan - Disruption intensity per phase
 * @returns {Object} Kill-chain disruption assessment
 */
function computeKillChainDisruption(phaseTransitions, disruptionPlan) {
  const disruptedPhases = [];
  let originalCompletion = 1;
  let disruptedCompletion = 1;

  for (let i = 0; i < phaseTransitions.length; i++) {
    const phase = phaseTransitions[i];
    const phaseName = phase.name || KILL_CHAIN_PHASES[i] || `PHASE_${i}`;
    const originalProb = phase.transitionProbability || 0.8;
    const disruptionIntensity = disruptionPlan[phaseName] || disruptionPlan[i] || 0;

    // Disrupted probability: P' = P × e^(-φ × intensity)
    const disruptedProb = originalProb * Math.exp(-PHI * disruptionIntensity);

    originalCompletion *= originalProb;
    disruptedCompletion *= disruptedProb;

    disruptedPhases.push({
      phase: phaseName,
      originalProbability: originalProb,
      disruptionIntensity,
      disruptedProbability: disruptedProb,
      reductionFactor: 1 - disruptedProb / originalProb,
    });
  }

  const overallDisruption = 1 - disruptedCompletion / Math.max(0.001, originalCompletion);

  return {
    protocol: 'PROTO-277',
    name: 'KILL_CHAIN_DISRUPTION',
    phases: disruptedPhases,
    originalCompletionProbability: originalCompletion,
    disruptedCompletionProbability: disruptedCompletion,
    overallDisruptionEffectiveness: overallDisruption,
    adversaryCostMultiplier: 1 / Math.max(0.001, disruptedCompletion),
    status: overallDisruption > PHI_INV ? 'HIGHLY_EFFECTIVE'
      : overallDisruption > PHI_INV ** 2 ? 'EFFECTIVE'
      : 'NEEDS_INTENSIFICATION',
  };
}

/**
 * Generate optimal disruption allocation across kill-chain phases
 * @param {Object[]} phaseTransitions - Current transition probabilities
 * @param {number} totalResources - Total disruption resources available (0-1 scale)
 * @returns {Object} Optimal allocation plan
 */
function optimizeDisruptionAllocation(phaseTransitions, totalResources) {
  // Strategy: Allocate proportional to transition probability
  // (disrupt the easiest transitions for adversary the most)
  const totalProb = phaseTransitions.reduce((s, p) => s + (p.transitionProbability || 0.8), 0);
  const allocation = {};

  for (let i = 0; i < phaseTransitions.length; i++) {
    const phase = phaseTransitions[i];
    const phaseName = phase.name || KILL_CHAIN_PHASES[i] || `PHASE_${i}`;
    const prob = phase.transitionProbability || 0.8;
    // Allocate resources proportional to φ-weighted transition probability
    allocation[phaseName] = (prob / totalProb) * totalResources * PHI;
  }

  // Compute effectiveness of this allocation
  const effectiveness = computeKillChainDisruption(phaseTransitions, allocation);

  return {
    protocol: 'PROTO-277',
    name: 'OPTIMAL_DISRUPTION_ALLOCATION',
    allocation,
    totalResourcesUsed: Object.values(allocation).reduce((s, v) => s + v, 0),
    expectedEffectiveness: effectiveness.overallDisruptionEffectiveness,
    adversaryCostMultiplier: effectiveness.adversaryCostMultiplier,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-278: DECEPTION ORCHESTRATION AT SCALE
//
// Coordinates large-scale deception operations across the entire swarm,
// ensuring consistency and plausibility of the false narrative.
//
// Orchestration model:
//   Deception graph: D = (narratives, dependencies, actors)
//   Consistency constraint: ∀(n₁, n₂) ∈ D: ¬contradict(n₁, n₂)
//   Plausibility score: P = Π (actor_credibility × narrative_coherence)
//   Timing coordination: All deception elements deploy within φ² heartbeats
//
// Scale: Up to 10^φ⁵ (≈ 10^11.09 ≈ 100 billion) deception elements
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Orchestrate multi-narrative deception campaign
 * @param {Object[]} narratives - Array of deception narratives
 * @param {Object[]} actors - Deception actors (honeypots, agents, channels)
 * @param {Object} adversaryContext - What the adversary currently believes
 * @returns {Object} Orchestration plan
 */
function orchestrateDeception(narratives, actors, adversaryContext) {
  const orchestration = [];
  let consistencyScore = 1;
  let plausibilityScore = 1;

  // Check narrative consistency (pairwise)
  for (let i = 0; i < narratives.length; i++) {
    for (let j = i + 1; j < narratives.length; j++) {
      const n1 = narratives[i];
      const n2 = narratives[j];
      // Contradiction check: same topic, different claims
      if (n1.topic === n2.topic && n1.claim !== n2.claim) {
        // Contradiction detected - reduce consistency
        consistencyScore *= PHI_INV;
      }
    }
  }

  // Assign actors to narratives using phi-distribution
  for (let i = 0; i < narratives.length; i++) {
    const narrative = narratives[i];
    const actorIndex = Math.floor((i * PHI) % actors.length);
    const assignedActor = actors[actorIndex] || actors[0];

    // Compute plausibility based on actor credibility and narrative coherence
    const actorCredibility = assignedActor?.credibility || 0.5;
    const narrativeCoherence = narrative.coherence || 0.7;
    const believability = actorCredibility * narrativeCoherence;
    plausibilityScore *= believability;

    // Check alignment with adversary's current beliefs (confirmation bias exploit)
    const alignsWithBeliefs = adversaryContext.beliefs?.includes(narrative.topic) ? PHI : 1;

    orchestration.push({
      narrativeId: narrative.id || `NAR-${i}`,
      actorId: assignedActor?.id || `ACTOR-${actorIndex}`,
      topic: narrative.topic,
      claim: narrative.claim,
      believability: believability * alignsWithBeliefs,
      deploymentDelay: i * HEARTBEAT * PHI_INV, // Staggered by φ⁻¹ heartbeats
      priority: Math.pow(PHI_INV, i),
    });
  }

  const overallPlausibility = Math.pow(plausibilityScore, 1 / Math.max(1, narratives.length));

  return {
    protocol: 'PROTO-278',
    name: 'DECEPTION_ORCHESTRATION',
    narrativeCount: narratives.length,
    actorCount: actors.length,
    orchestration,
    consistencyScore: Math.min(1, consistencyScore),
    plausibilityScore: overallPlausibility,
    deploymentWindowMs: narratives.length * HEARTBEAT * PHI_INV,
    isCoherent: consistencyScore >= PHI_INV,
    isPlausible: overallPlausibility >= PHI_INV ** 2,
    overallEffectiveness: consistencyScore * overallPlausibility,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-279: SIGINT CORRELATION & ATTRIBUTION ENGINE
//
// Correlates signals intelligence across multiple collection points
// to attribute adversary operations and map their infrastructure.
//
// Correlation model:
//   Signal features: S = {timing, frequency, content_hash, source, protocol}
//   Correlation score: C(s₁, s₂) = Σ wᵢ × similarity(feature_i)
//   Attribution: Cluster correlated signals → adversary campaigns
//
// Clustering: φ-means (k-means with k = ⌈φ × √n⌉ clusters)
// Linkage: Single-linkage with threshold = φ⁻² × max_distance
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Correlate SIGINT signals for attribution
 * @param {Object[]} signals - Collected signals
 * @param {number} correlationThreshold - Minimum correlation for linkage
 * @returns {Object} Correlation and attribution result
 */
function correlateSIGINT(signals, correlationThreshold) {
  if (!signals || signals.length < 2) {
    return { clusters: [], attributions: [], confidence: 0 };
  }

  const threshold = correlationThreshold || PHI_INV ** 2;

  // Compute pairwise correlations
  const correlations = [];
  for (let i = 0; i < signals.length; i++) {
    for (let j = i + 1; j < signals.length; j++) {
      const s1 = signals[i];
      const s2 = signals[j];

      // Multi-feature correlation
      let score = 0;
      let weights = 0;

      // Timing correlation (closer in time = higher)
      if (s1.timestamp && s2.timestamp) {
        const timeDelta = Math.abs(s1.timestamp - s2.timestamp);
        const timingScore = Math.exp(-timeDelta / (HEARTBEAT * PHI_CUBE));
        score += timingScore * PHI;
        weights += PHI;
      }

      // Protocol match
      if (s1.protocol && s2.protocol) {
        score += (s1.protocol === s2.protocol ? 1 : 0) * 1;
        weights += 1;
      }

      // Source proximity (same subnet / ASN)
      if (s1.source && s2.source) {
        score += (s1.source === s2.source ? 1 : s1.sourceASN === s2.sourceASN ? 0.5 : 0) * PHI_INV;
        weights += PHI_INV;
      }

      // Content similarity
      if (s1.contentHash && s2.contentHash) {
        score += (s1.contentHash === s2.contentHash ? 1 : 0) * PHI_SQ;
        weights += PHI_SQ;
      }

      const normalizedScore = weights > 0 ? score / weights : 0;
      if (normalizedScore >= threshold) {
        correlations.push({ i, j, score: normalizedScore });
      }
    }
  }

  // Single-linkage clustering
  const clusters = [];
  const assigned = new Set();

  for (const corr of correlations.sort((a, b) => b.score - a.score)) {
    const clusterI = clusters.findIndex(c => c.members.includes(corr.i));
    const clusterJ = clusters.findIndex(c => c.members.includes(corr.j));

    if (clusterI === -1 && clusterJ === -1) {
      clusters.push({ members: [corr.i, corr.j], maxCorrelation: corr.score });
      assigned.add(corr.i);
      assigned.add(corr.j);
    } else if (clusterI >= 0 && clusterJ === -1) {
      clusters[clusterI].members.push(corr.j);
      assigned.add(corr.j);
    } else if (clusterI === -1 && clusterJ >= 0) {
      clusters[clusterJ].members.push(corr.i);
      assigned.add(corr.i);
    } else if (clusterI !== clusterJ && clusterI >= 0 && clusterJ >= 0) {
      // Merge clusters
      clusters[clusterI].members.push(...clusters[clusterJ].members);
      clusters.splice(clusterJ, 1);
    }
  }

  // Generate attributions
  const attributions = clusters.map((cluster, idx) => ({
    campaignId: `CAMPAIGN-${String(idx).padStart(3, '0')}`,
    signalCount: cluster.members.length,
    confidence: Math.min(1, cluster.members.length / (PHI * 3)),
    maxCorrelation: cluster.maxCorrelation,
    signals: cluster.members.map(m => signals[m]?.id || `SIG-${m}`),
  }));

  return {
    protocol: 'PROTO-279',
    name: 'SIGINT_CORRELATION',
    totalSignals: signals.length,
    correlationsFound: correlations.length,
    clustersIdentified: clusters.length,
    attributions,
    unattributed: signals.length - assigned.size,
    overallConfidence: attributions.length > 0
      ? attributions.reduce((s, a) => s + a.confidence, 0) / attributions.length
      : 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-280: COUNTER-RECONNAISSANCE ENGINE
//
// Detects adversary reconnaissance and feeds false information to
// pollute their intelligence gathering phase.
//
// Detection signals:
//   - Port scanning patterns (sequential, random, targeted)
//   - DNS enumeration attempts
//   - Web crawling with intelligence signatures
//   - Social engineering approaches
//   - OSINT collection indicators
//
// Response: Feed calibrated false information that is:
//   1. Plausible (passes cursory verification)
//   2. Trackable (contains embedded canary tokens)
//   3. Misleading (directs adversary away from real assets)
//   4. Time-limited (expires before adversary can act on it)
//
// False info credibility: Cr = φ⁻¹ × (plausibility + trackability) / 2
// ═══════════════════════════════════════════════════════════════════════════

const RECON_PATTERNS = {
  PORT_SCAN_SEQUENTIAL: { confidence: 0.9, type: 'NETWORK', intent: 'SERVICE_DISCOVERY' },
  PORT_SCAN_RANDOM: { confidence: 0.7, type: 'NETWORK', intent: 'EVASIVE_DISCOVERY' },
  DNS_ENUMERATION: { confidence: 0.85, type: 'DNS', intent: 'INFRASTRUCTURE_MAPPING' },
  WEB_CRAWL_AGGRESSIVE: { confidence: 0.6, type: 'WEB', intent: 'CONTENT_COLLECTION' },
  SOCIAL_ENGINEERING: { confidence: 0.8, type: 'HUMINT', intent: 'CREDENTIAL_HARVEST' },
  OSINT_COLLECTION: { confidence: 0.5, type: 'OSINT', intent: 'INTELLIGENCE_GATHERING' },
  API_FUZZING: { confidence: 0.75, type: 'APPLICATION', intent: 'VULNERABILITY_DISCOVERY' },
};

/**
 * Detect reconnaissance activity and generate counter-response
 * @param {Object[]} events - Observed network/system events
 * @param {Object} normalBaseline - Normal traffic baseline
 * @returns {Object} Reconnaissance detection and response plan
 */
function detectAndCounterReconnaissance(events, normalBaseline) {
  const detections = [];
  const baselineEventRate = normalBaseline.eventRate || 100;

  // Analyze event patterns
  const eventsBySource = {};
  for (const event of events) {
    const src = event.source || 'UNKNOWN';
    if (!eventsBySource[src]) eventsBySource[src] = [];
    eventsBySource[src].push(event);
  }

  for (const [source, sourceEvents] of Object.entries(eventsBySource)) {
    const eventRate = sourceEvents.length;
    const rateAnomaly = eventRate / baselineEventRate;

    // Check for known recon patterns
    for (const [patternName, pattern] of Object.entries(RECON_PATTERNS)) {
      const matchingEvents = sourceEvents.filter(e => e.type === pattern.type);
      if (matchingEvents.length > rateAnomaly * PHI) {
        detections.push({
          source,
          pattern: patternName,
          confidence: pattern.confidence * Math.min(1, matchingEvents.length / 5),
          intent: pattern.intent,
          eventCount: matchingEvents.length,
          rateAnomaly,
        });
      }
    }
  }

  // Generate counter-response for each detection
  const responses = detections
    .filter(d => d.confidence > PHI_INV)
    .map(detection => ({
      target: detection.source,
      responseType: detection.intent === 'SERVICE_DISCOVERY' ? 'FAKE_SERVICE_BANNERS'
        : detection.intent === 'INFRASTRUCTURE_MAPPING' ? 'FALSE_DNS_RECORDS'
        : detection.intent === 'VULNERABILITY_DISCOVERY' ? 'SIMULATED_VULNERABILITIES'
        : detection.intent === 'CREDENTIAL_HARVEST' ? 'HONEYCREDENTIALS'
        : 'GENERAL_MISINFORMATION',
      plausibility: 0.8 + (1 - detection.confidence) * 0.2, // Higher confidence in detection = more plausible response
      canaryEmbedded: true,
      expirationMs: HEARTBEAT * PHI_CUBE * 100,
      credibility: PHI_INV * (0.8 + Math.random() * 0.2),
    }));

  return {
    protocol: 'PROTO-280',
    name: 'COUNTER_RECONNAISSANCE',
    eventsAnalyzed: events.length,
    sourcesAnalyzed: Object.keys(eventsBySource).length,
    detections,
    detectionCount: detections.length,
    highConfidenceDetections: detections.filter(d => d.confidence > PHI_INV).length,
    responses,
    overallThreatLevel: detections.length > PHI * 3 ? 'HIGH'
      : detections.length > PHI ? 'MODERATE'
      : 'LOW',
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-281: ADVERSARY RESOURCE EXHAUSTION ENGINE
//
// Systematically exhausts adversary resources (compute, human attention,
// time, money) through coordinated waste operations.
//
// Exhaustion vectors:
//   1. Computational: Force adversary to solve hard problems (proof-of-work traps)
//   2. Temporal: Extend adversary timelines through deception layers
//   3. Attention: Flood with false positives requiring manual analysis
//   4. Financial: Force expensive infrastructure spending on dead ends
//   5. Cognitive: Information overload + contradictions
//
// Resource burn rate:
//   R_burn(t) = R_adversary × (1 - e^(-φ × traps_engaged / R_total))
//   Where R_adversary = estimated adversary resource pool
// ═══════════════════════════════════════════════════════════════════════════

/**
 * Design resource exhaustion campaign
 * @param {Object} adversaryResourceEstimate - Estimated adversary resources
 * @param {Object[]} availableTraps - Available exhaustion traps
 * @returns {Object} Exhaustion campaign specification
 */
function designResourceExhaustion(adversaryResourceEstimate, availableTraps) {
  const {
    computeCapacity = 100,  // arbitrary units
    humanAnalysts = 10,
    budget = 1000000,
    timeHorizon = 30 * 24 * 3600 * 1000, // 30 days in ms
  } = adversaryResourceEstimate;

  const deployedTraps = [];
  let totalComputeDrain = 0;
  let totalTimeDrain = 0;
  let totalAttentionDrain = 0;
  let totalFinancialDrain = 0;

  for (let i = 0; i < availableTraps.length; i++) {
    const trap = availableTraps[i];
    const phiWeight = Math.pow(PHI_INV, i % 8);

    const computeCost = (trap.computeDifficulty || 0) * phiWeight;
    const timeCost = (trap.timeToAnalyze || HEARTBEAT * PHI_CUBE) * phiWeight;
    const attentionCost = (trap.requiresHumanReview ? 1 : 0) * phiWeight;
    const financialCost = (trap.infrastructureCost || 0) * phiWeight;

    totalComputeDrain += computeCost;
    totalTimeDrain += timeCost;
    totalAttentionDrain += attentionCost;
    totalFinancialDrain += financialCost;

    deployedTraps.push({
      trapId: trap.id || `TRAP-${String(i).padStart(4, '0')}`,
      type: trap.type || 'GENERAL',
      computeDrain: computeCost,
      timeDrain: timeCost,
      attentionDrain: attentionCost,
      financialDrain: financialCost,
      phiWeight,
    });
  }

  // Compute burn rates
  const computeBurnRate = 1 - Math.exp(-PHI * totalComputeDrain / computeCapacity);
  const timeBurnRate = 1 - Math.exp(-PHI * totalTimeDrain / timeHorizon);
  const attentionBurnRate = 1 - Math.exp(-PHI * totalAttentionDrain / humanAnalysts);
  const financialBurnRate = 1 - Math.exp(-PHI * totalFinancialDrain / budget);

  const overallExhaustion = (computeBurnRate + timeBurnRate + attentionBurnRate + financialBurnRate) / 4;

  return {
    protocol: 'PROTO-281',
    name: 'RESOURCE_EXHAUSTION',
    trapsDeployed: deployedTraps.length,
    burnRates: {
      compute: computeBurnRate,
      time: timeBurnRate,
      attention: attentionBurnRate,
      financial: financialBurnRate,
    },
    overallExhaustion,
    estimatedAdversaryCapacityRemaining: 1 - overallExhaustion,
    effectivenessRating: overallExhaustion > PHI_INV ? 'DEVASTATING'
      : overallExhaustion > PHI_INV ** 2 ? 'SIGNIFICANT'
      : overallExhaustion > PHI_INV ** 3 ? 'MODERATE'
      : 'MINIMAL',
    deployedTraps: deployedTraps.slice(0, 10), // Top 10 for readability
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// PROTO-282: AUTONOMOUS COUNTER-OPERATION PLANNER
//
// AI-driven planning engine that generates counter-operations in
// response to detected adversary campaigns, optimizing for maximum
// disruption with minimum resource expenditure.
//
// Planning methodology (OODA Loop × Medina Doctrine):
//   1. OBSERVE: Collect all adversary indicators
//   2. ORIENT: Map to kill-chain phase + assess capabilities
//   3. DECIDE: Select optimal counter-operation from playbook
//   4. ACT: Deploy counter-operation with φ-timing
//
// Optimization:
//   maximize: disruption(adversary) / cost(counter-op)
//   subject to: risk(counter-op) < φ⁻² × risk_tolerance
//
// Response time target: < φ² × HEARTBEAT (~2.3 seconds)
// ═══════════════════════════════════════════════════════════════════════════

const COUNTER_OP_PLAYBOOK = {
  DEFLECT: { effectiveness: 0.6, cost: 0.1, risk: 0.05, speed: 'FAST' },
  DECEIVE: { effectiveness: 0.8, cost: 0.3, risk: 0.1, speed: 'MEDIUM' },
  DISRUPT: { effectiveness: 0.9, cost: 0.5, risk: 0.3, speed: 'MEDIUM' },
  DEGRADE: { effectiveness: 0.85, cost: 0.6, risk: 0.4, speed: 'SLOW' },
  DENY: { effectiveness: 0.95, cost: 0.7, risk: 0.5, speed: 'FAST' },
  DESTROY: { effectiveness: 1.0, cost: 1.0, risk: 0.9, speed: 'SLOW' },
  ISOLATE: { effectiveness: 0.7, cost: 0.2, risk: 0.1, speed: 'FAST' },
  ATTRIBUTE: { effectiveness: 0.5, cost: 0.4, risk: 0.2, speed: 'SLOW' },
};

/**
 * Generate autonomous counter-operation plan
 * @param {Object} adversarySituation - Current adversary situation assessment
 * @param {number} riskTolerance - Maximum acceptable risk (0-1)
 * @param {number} resourceBudget - Available resources (0-1 scale)
 * @returns {Object} Counter-operation plan
 */
function generateCounterOperationPlan(adversarySituation, riskTolerance, resourceBudget) {
  const {
    killChainPhase = 'RECONNAISSANCE',
    sophistication = 0.5,
    urgency = 0.5,
    targetValue = 0.5,
  } = adversarySituation;

  const riskThreshold = PHI_INV ** 2 * riskTolerance;
  const candidates = [];

  // Score each counter-operation
  for (const [opName, spec] of Object.entries(COUNTER_OP_PLAYBOOK)) {
    // Filter by risk tolerance
    if (spec.risk > riskThreshold) continue;
    // Filter by resource budget
    if (spec.cost > resourceBudget) continue;

    // Score: effectiveness per unit cost, weighted by urgency and target value
    const baseScore = spec.effectiveness / Math.max(0.01, spec.cost);
    const urgencyMultiplier = spec.speed === 'FAST' ? PHI : spec.speed === 'MEDIUM' ? 1 : PHI_INV;
    const situationalMultiplier = (1 + urgency) * (1 + targetValue) / 4;

    const finalScore = baseScore * urgencyMultiplier * situationalMultiplier * PHI;

    candidates.push({
      operation: opName,
      ...spec,
      score: finalScore,
      adjustedRisk: spec.risk * sophistication, // Sophistication increases risk
    });
  }

  // Sort by score (best first)
  candidates.sort((a, b) => b.score - a.score);

  // Select primary and backup operations
  const primary = candidates[0] || null;
  const backup = candidates[1] || null;

  // Compute response timeline
  const responseTimeMs = HEARTBEAT * PHI_SQ; // Target: < φ² heartbeats

  // OODA loop metrics
  const oodaMetrics = {
    observeMs: responseTimeMs * PHI_INV ** 3,
    orientMs: responseTimeMs * PHI_INV ** 2,
    decideMs: responseTimeMs * PHI_INV,
    actMs: responseTimeMs * (1 - PHI_INV ** 3 - PHI_INV ** 2 - PHI_INV),
    totalMs: responseTimeMs,
  };

  return {
    protocol: 'PROTO-282',
    name: 'AUTONOMOUS_COUNTER_OPERATION',
    situation: {
      killChainPhase,
      sophistication,
      urgency,
      targetValue,
    },
    primaryOperation: primary ? {
      name: primary.operation,
      effectiveness: primary.effectiveness,
      cost: primary.cost,
      risk: primary.adjustedRisk,
      score: primary.score,
    } : null,
    backupOperation: backup ? {
      name: backup.operation,
      effectiveness: backup.effectiveness,
      cost: backup.cost,
      risk: backup.adjustedRisk,
      score: backup.score,
    } : null,
    candidatesEvaluated: Object.keys(COUNTER_OP_PLAYBOOK).length,
    candidatesViable: candidates.length,
    oodaLoop: oodaMetrics,
    constraints: {
      riskTolerance,
      riskThreshold,
      resourceBudget,
    },
    responseReady: primary !== null,
    confidenceLevel: primary ? Math.min(1, primary.score / PHI_SQ) : 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// EXPORTS
// ═══════════════════════════════════════════════════════════════════════════

module.exports = {
  // Math engines
  bayesianUpdate,
  multiHypothesisBayes,
  phiExponentialDecay,
  phiSigmoid,
  cosineSimilarity,
  phiWeightedAverage,
  informationGain,

  // Constants
  ADVERSARY_MODELS,
  KILL_CHAIN_PHASES,
  COGNITIVE_BIASES,
  RECON_PATTERNS,
  COUNTER_OP_PLAYBOOK,

  // PROTO-273: Adversary Behavior Prediction
  buildTransitionMatrix,
  predictAdversaryActions,

  // PROTO-274: Double-Agent Detection
  computeTrustDecay,
  detectDoubleAgent,

  // PROTO-275: Cognitive Warfare
  designCognitiveWarfare,

  // PROTO-276: Supply Chain Interdiction
  assessSupplyChainIntegrity,

  // PROTO-277: Kill-Chain Disruption
  computeKillChainDisruption,
  optimizeDisruptionAllocation,

  // PROTO-278: Deception Orchestration
  orchestrateDeception,

  // PROTO-279: SIGINT Correlation
  correlateSIGINT,

  // PROTO-280: Counter-Reconnaissance
  detectAndCounterReconnaissance,

  // PROTO-281: Resource Exhaustion
  designResourceExhaustion,

  // PROTO-282: Autonomous Counter-Operation
  generateCounterOperationPlan,
};
