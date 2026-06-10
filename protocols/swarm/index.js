/**
 * CHIMERIA SWARM ALPHA PROTOCOLS — Sublibrary Index
 * 24 ALPHA-Tier Protocols (PROTO-231 through PROTO-254)
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * SPDX-License-Identifier: CPEL-1.0 | Framework: Medina Doctrine
 *
 * This is the unified entry point for the entire SWARM protocol sublibrary.
 * Import from here to access all 24 protocols and the orchestrator.
 *
 * PROTOCOL REGISTRY:
 * ─────────────────────────────────────────────────────────────────────────
 * PROTO-231: Tensor Shard Distribution     │ SovereignTensor
 * PROTO-232: Distributed Matrix Multiply   │ SovereignTensor
 * PROTO-233: Swarm Tensor Consensus        │ SovereignTensor
 * PROTO-234: Tensor Integrity Attestation  │ SovereignTensor
 * PROTO-235: Federated Gradient Aggregation│ SovereignNeuralEngine
 * PROTO-236: Swarm Attention Sync          │ SovereignNeuralEngine
 * PROTO-237: Neural Weight Gossip          │ SovereignNeuralEngine
 * PROTO-238: Swarm Knowledge Distillation  │ SovereignNeuralEngine
 * PROTO-239: Inference Load Balancer       │ SovereignInferenceRuntime
 * PROTO-240: Model Version Rollout         │ SovereignInferenceRuntime
 * PROTO-241: Inference Result Caching      │ SovereignInferenceRuntime
 * PROTO-242: Inference Audit Trail         │ SovereignInferenceRuntime
 * PROTO-243: Multi-Sensor Fusion           │ SovereignSIGINT
 * PROTO-244: Cooperative Geolocation       │ SovereignSIGINT
 * PROTO-245: Electronic Warfare Coord      │ SovereignSIGINT
 * PROTO-246: Spectrum Awareness            │ SovereignSIGINT
 * PROTO-247: Fleet Compliance Attestation  │ SovereignCompliance
 * PROTO-248: Export Control Gateway        │ SovereignCompliance
 * PROTO-249: Distributed Audit Chain       │ SovereignCompliance
 * PROTO-250: Supply Chain Integrity        │ SovereignCompliance
 * PROTO-251: Distributed Key Ceremony      │ SovereignAirGap
 * PROTO-252: Network Isolation Proof       │ SovereignAirGap
 * PROTO-253: Secure Boot Chain Verify      │ SovereignAirGap
 * PROTO-254: Zeroization Coordination      │ SovereignAirGap
 * ─────────────────────────────────────────────────────────────────────────
 *
 * ZERO EXTERNAL DEPENDENCIES — Complete sovereign execution.
 */

// ═══════════════════════════════════════════════════════════════════════════
// TENSOR PROTOCOLS (PROTO-231–234)
// ═══════════════════════════════════════════════════════════════════════════

export {
  computeShardWeights,
  tensorHash,
  tensorShardDistribution,
  matmul,
  distributedMatmul,
  tensorConsensus,
  tensorIntegrityAttestation,
} from './swarm-tensor-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// NEURAL PROTOCOLS (PROTO-235–238)
// ═══════════════════════════════════════════════════════════════════════════

export {
  mean,
  stddev,
  softmax,
  klDivergence,
  temperatureSoftmax,
  federatedGradientAggregation,
  swarmAttentionSync,
  neuralWeightGossip,
  swarmKnowledgeDistillation,
} from './swarm-neural-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// INFERENCE PROTOCOLS (PROTO-239–242)
// ═══════════════════════════════════════════════════════════════════════════

export {
  inferenceLoadBalancer,
  modelVersionRollout,
  inferenceResultCache,
  auditHash,
  inferenceAuditTrail,
} from './swarm-inference-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// SIGINT PROTOCOLS (PROTO-243–246)
// ═══════════════════════════════════════════════════════════════════════════

export {
  dempsterCombine,
  multiSensorFusion,
  cooperativeGeolocation,
  ewCoordination,
  spectrumAwareness,
} from './swarm-sigint-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// COMPLIANCE PROTOCOLS (PROTO-247–250)
// ═══════════════════════════════════════════════════════════════════════════

export {
  USML_CATEGORIES,
  NIST_FAMILIES,
  computeNodeComplianceScore,
  fleetComplianceAttestation,
  exportControlGateway,
  distributedAuditChain,
  supplyChainIntegrity,
} from './swarm-compliance-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// AIRGAP PROTOCOLS (PROTO-251–254)
// ═══════════════════════════════════════════════════════════════════════════

export {
  distributedKeyCeremony,
  reconstructSecret,
  modPow,
  modInverse,
  PRIME,
  networkIsolationProof,
  secureBootChainVerification,
  zeroizationCoordination,
} from './swarm-airgap-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// ADVANCED OPSEC PROTOCOLS (PROTO-263–272)
// ═══════════════════════════════════════════════════════════════════════════

export {
  shannonEntropy,
  renyiEntropy,
  ksDistance,
  phiDecay,
  klDivergence,
  mahalanobisDistance,
  logisticMap,
  autocorrelation,
  COVERT_CHANNEL_TYPES,
  TEMPEST_ZONES,
  COVER_TRAFFIC_PROFILES,
  detectTimingChannel,
  detectStorageChannel,
  eliminateCovertChannel,
  computeEmanationRisk,
  generateTempestCountermeasures,
  normalizeNodeBehavior,
  generateTimingMask,
  assessSideChannelVulnerability,
  computeLinkability,
  generateIdentityDivergence,
  generateLatticeParameters,
  computeQuantumAnonymitySet,
  generateTrafficMorphing,
  computeZeroizationEffectiveness,
  generateForensicsResistancePlan,
  scoreRelays,
  generateObfuscatedPath,
  generatePatternDisruption,
} from './swarm-opsec-advanced-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// ADVANCED COUNTER-INTELLIGENCE PROTOCOLS (PROTO-273–282)
// ═══════════════════════════════════════════════════════════════════════════

export {
  bayesianUpdate,
  multiHypothesisBayes,
  phiExponentialDecay,
  phiSigmoid,
  cosineSimilarity,
  phiWeightedAverage,
  informationGain,
  ADVERSARY_MODELS,
  KILL_CHAIN_PHASES,
  COGNITIVE_BIASES,
  RECON_PATTERNS,
  COUNTER_OP_PLAYBOOK,
  buildTransitionMatrix,
  predictAdversaryActions,
  computeTrustDecay,
  detectDoubleAgent,
  designCognitiveWarfare,
  assessSupplyChainIntegrity,
  computeKillChainDisruption,
  optimizeDisruptionAllocation,
  orchestrateDeception,
  correlateSIGINT,
  detectAndCounterReconnaissance,
  designResourceExhaustion,
  generateCounterOperationPlan,
} from './swarm-counterintel-advanced-protocols.js';

// ═══════════════════════════════════════════════════════════════════════════
// SWARM ORCHESTRATOR
// ═══════════════════════════════════════════════════════════════════════════

export {
  createSwarmState,
  executePreFlight,
  executeCompute,
  executeDeploy,
  executeSIGINT,
  executeEmergencyZeroize,
  executeSwarmMission,
} from './swarm-orchestrator.js';
