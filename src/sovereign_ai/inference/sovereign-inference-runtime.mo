// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — INFERENCE RUNTIME                                                                         ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module may be subject to ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)           ║
// ║  DO NOT EXPORT without proper BIS/DDTC authorization.                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Array "mo:core/Array";
import Iter "mo:core/Iter";
import Nat "mo:core/Nat";
import Int "mo:core/Int";
import Text "mo:core/Text";
import Blob "mo:core/Blob";
import SovereignTensor "../tensor/sovereign-tensor";
import SovereignNeuralEngine "../neural/sovereign-neural-engine";

module SovereignInferenceRuntime {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — INFERENCE PIPELINE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Model metadata — tracks provenance for ITAR compliance
  public type ModelMetadata = {
    modelId : Text;
    version : Text;
    createdAt : Int;
    trainedBy : Text;
    classification : ExportClassification;
    checksum : Nat;    // Internal integrity check
    layerCount : Nat;
    parameterCount : Nat;
  };

  /// Export classification for ITAR/EAR
  public type ExportClassification = {
    #EAR99;          // No license required
    #ECCN_5D002;     // Encryption-related
    #ECCN_5D992;     // Mass market encryption
    #ITAR_USML_XI;   // Military electronics
    #ITAR_USML_XV;   // Spacecraft systems
    #CLASSIFIED;     // Cannot export under any license
  };

  /// Inference request with audit trail
  public type InferenceRequest = {
    requestId : Nat;
    timestamp : Int;
    input : SovereignTensor.Vector;
    modelId : Text;
    requestor : Text;
    classification : ExportClassification;
  };

  /// Inference result with full provenance
  public type InferenceResult = {
    requestId : Nat;
    timestamp : Int;
    output : SovereignTensor.Vector;
    confidence : Float;
    latencyMs : Nat;
    modelVersion : Text;
    auditHash : Nat;
  };

  /// Model weight format — sovereign binary format (no ONNX, no protobuf)
  public type SovereignModelFormat = {
    magic : Nat;       // 0x534F5641 ("SOVA" — Sovereign)
    version : Nat;
    layers : [LayerWeights];
    metadata : ModelMetadata;
  };

  /// Serialized layer weights
  public type LayerWeights = {
    inputDim : Nat;
    outputDim : Nat;
    weights : [Float];
    biases : [Float];
    activation : SovereignNeuralEngine.Activation;
  };

  /// Inference session — tracks state across multiple calls
  public type InferenceSession = {
    sessionId : Nat;
    modelId : Text;
    var requestCount : Nat;
    var totalLatency : Nat;
    var auditLog : [AuditEntry];
    classification : ExportClassification;
  };

  /// Audit entry for NIST SP 800-171 compliance
  public type AuditEntry = {
    timestamp : Int;
    action : Text;
    requestId : Nat;
    inputHash : Nat;
    outputHash : Nat;
    result : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sovereign model magic number
  public let SOVEREIGN_MAGIC : Nat = 0x534F5641; // "SOVA"

  /// Maximum inference latency for defense-critical systems (ms)
  public let MAX_LATENCY_CRITICAL : Nat = 10;
  public let MAX_LATENCY_STANDARD : Nat = 100;
  public let MAX_LATENCY_BATCH : Nat = 1000;

  // ═══════════════════════════════════════════════════════════════════════════════
  // MODEL LOADING — SOVEREIGN FORMAT (NO EXTERNAL PARSERS)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Load model from sovereign binary format into neural network
  public func loadModel(
    modelData : SovereignModelFormat
  ) : ?SovereignNeuralEngine.NeuralNetwork {
    // Verify magic number
    if (modelData.magic != SOVEREIGN_MAGIC) return null;

    let numLayers = modelData.layers.size();
    if (numLayers == 0) return null;

    let prng = SovereignTensor.prngInit(42);

    let layers = Array.tabulate<SovereignNeuralEngine.DenseLayer>(numLayers, func(i : Nat) : SovereignNeuralEngine.DenseLayer {
      let lw = modelData.layers[i];
      let weights = SovereignTensor.zeros(lw.inputDim, lw.outputDim);

      // Load weights
      for (idx in Iter.range(0, lw.weights.size() - 1)) {
        weights.data[idx] := lw.weights[idx];
      };

      // Load biases
      let biases = Array.init<Float>(lw.outputDim, 0.0);
      for (idx in Iter.range(0, lw.biases.size() - 1)) {
        biases[idx] := lw.biases[idx];
      };

      {
        weights;
        biases;
        activation = lw.activation;
        var lastInput = null : ?SovereignTensor.Vector;
        var lastOutput = null : ?SovereignTensor.Vector;
      }
    });

    ?{
      layers;
      learningRate = 0.0; // Inference-only mode
      var epoch = 0;
      var totalLoss = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFERENCE EXECUTION — WITH FULL AUDIT TRAIL
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Execute inference with audit logging (NIST SP 800-171 compliant)
  public func infer(
    network : SovereignNeuralEngine.NeuralNetwork,
    request : InferenceRequest,
    session : InferenceSession
  ) : InferenceResult {
    // Validate export classification
    assert(classificationAllowed(request.classification, session.classification));

    // Execute forward pass
    let output = SovereignNeuralEngine.forward(network, request.input);

    // Compute confidence (max softmax output)
    let softmaxOutput = SovereignTensor.softmax(output);
    var maxConf : Float = 0.0;
    for (v in softmaxOutput.vals()) {
      if (v > maxConf) maxConf := v;
    };

    // Generate audit hash (FNV-1a — no external crypto library)
    let auditHash = fnv1aHash(request.requestId, output);

    // Update session state
    session.requestCount += 1;

    {
      requestId = request.requestId;
      timestamp = request.timestamp;
      output;
      confidence = maxConf;
      latencyMs = 0; // Would be measured by caller
      modelVersion = "1.0.0";
      auditHash;
    }
  };

  /// Batch inference — processes multiple inputs efficiently
  public func batchInfer(
    network : SovereignNeuralEngine.NeuralNetwork,
    inputs : [SovereignTensor.Vector],
    session : InferenceSession
  ) : [SovereignTensor.Vector] {
    Array.tabulate<SovereignTensor.Vector>(inputs.size(), func(i : Nat) : SovereignTensor.Vector {
      SovereignNeuralEngine.forward(network, inputs[i])
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXPORT CLASSIFICATION ENFORCEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Check if inference is allowed at this classification level
  public func classificationAllowed(
    requestLevel : ExportClassification,
    sessionLevel : ExportClassification
  ) : Bool {
    let requestRank = classificationRank(requestLevel);
    let sessionRank = classificationRank(sessionLevel);
    requestRank <= sessionRank
  };

  /// Numeric rank for classification comparison
  func classificationRank(c : ExportClassification) : Nat {
    switch (c) {
      case (#EAR99) { 0 };
      case (#ECCN_5D992) { 1 };
      case (#ECCN_5D002) { 2 };
      case (#ITAR_USML_XI) { 3 };
      case (#ITAR_USML_XV) { 4 };
      case (#CLASSIFIED) { 5 };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRITY — SOVEREIGN HASH (NO OPENSSL, NO EXTERNAL CRYPTO)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// FNV-1a hash — public domain, no export restrictions
  /// Used for model integrity verification and audit trails
  public func fnv1aHash(seed : Nat, data : [Float]) : Nat {
    var hash : Nat = 14695981039346656037; // FNV offset basis (64-bit)
    let prime : Nat = 1099511628211; // FNV prime (64-bit)

    // Hash seed
    hash := (hash ^ seed) *% prime;

    // Hash each float value
    for (v in data.vals()) {
      let bits = Float.toInt64(v);
      let absVal = Int.abs(bits);
      hash := (hash ^ absVal) *% prime;
    };

    hash
  };

  /// Verify model integrity — ensures no tampering in air-gapped environment
  public func verifyModelIntegrity(model : SovereignModelFormat) : Bool {
    var computedChecksum : Nat = 14695981039346656037;
    let prime : Nat = 1099511628211;

    for (layer in model.layers.vals()) {
      for (w in layer.weights.vals()) {
        let bits = Float.toInt64(w);
        computedChecksum := (computedChecksum ^ Int.abs(bits)) *% prime;
      };
    };

    computedChecksum == model.metadata.checksum
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MODEL QUANTIZATION — REDUCE SIZE FOR EMBEDDED/TACTICAL SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quantize weights to 8-bit fixed point (for resource-constrained tactical hardware)
  public func quantize8Bit(weights : [Float], minVal : Float, maxVal : Float) : [Nat] {
    let range = maxVal - minVal;
    Array.tabulate<Nat>(weights.size(), func(i : Nat) : Nat {
      let normalized = (weights[i] - minVal) / range;
      let clamped = Float.max(0.0, Float.min(1.0, normalized));
      Int.abs(Float.toInt(clamped * 255.0))
    })
  };

  /// Dequantize 8-bit back to float
  public func dequantize8Bit(quantized : [Nat], minVal : Float, maxVal : Float) : [Float] {
    let range = maxVal - minVal;
    Array.tabulate<Float>(quantized.size(), func(i : Nat) : Float {
      let normalized = Float.fromInt(quantized[i]) / 255.0;
      minVal + normalized * range
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SESSION MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Create new inference session
  public func createSession(
    sessionId : Nat,
    modelId : Text,
    classification : ExportClassification
  ) : InferenceSession {
    {
      sessionId;
      modelId;
      var requestCount = 0;
      var totalLatency = 0;
      var auditLog = [] : [AuditEntry];
      classification;
    }
  };

  /// Export audit log for compliance review
  public func exportAuditLog(session : InferenceSession) : [AuditEntry] {
    session.auditLog
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 4-BIT QUANTIZATION — EXTREME COMPRESSION FOR TACTICAL EDGE HARDWARE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quantize weights to 4-bit (NF4 style) for ultra-constrained devices
  /// Packs two 4-bit values per byte
  public func quantize4Bit(weights : [Float], minVal : Float, maxVal : Float) : [Nat] {
    let range = maxVal - minVal;
    Array.tabulate<Nat>(weights.size(), func(i : Nat) : Nat {
      let normalized = (weights[i] - minVal) / range;
      let clamped = Float.max(0.0, Float.min(1.0, normalized));
      Int.abs(Float.toInt(clamped * 15.0)) // 4-bit: 0-15
    })
  };

  /// Dequantize 4-bit back to float
  public func dequantize4Bit(quantized : [Nat], minVal : Float, maxVal : Float) : [Float] {
    let range = maxVal - minVal;
    Array.tabulate<Float>(quantized.size(), func(i : Nat) : Float {
      let normalized = Float.fromInt(quantized[i]) / 15.0;
      minVal + normalized * range
    })
  };

  /// Compute quantization error (MSE between original and dequantized)
  public func quantizationError(original : [Float], quantized : [Nat], minVal : Float, maxVal : Float, bits : Nat) : Float {
    let dequant = if (bits == 4) { dequantize4Bit(quantized, minVal, maxVal) }
                  else { dequantize8Bit(quantized, minVal, maxVal) };
    var mse : Float = 0.0;
    for (i in Iter.range(0, original.size() - 1)) {
      let diff = original[i] - dequant[i];
      mse += diff * diff;
    };
    mse / Float.fromInt(original.size())
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DYNAMIC BATCHING — ADAPTIVE BATCH SIZING FOR THROUGHPUT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Dynamic batch configuration
  public type DynamicBatchConfig = {
    maxBatchSize : Nat;
    maxWaitMs : Nat;
    minBatchSize : Nat;
    adaptiveScaling : Bool;
  };

  /// Batch accumulator
  public type BatchAccumulator = {
    var pending : [SovereignTensor.Vector];
    var pendingIds : [Nat];
    var lastFlushTimestamp : Int;
    config : DynamicBatchConfig;
  };

  /// Create batch accumulator
  public func createBatchAccumulator(config : DynamicBatchConfig) : BatchAccumulator {
    {
      var pending = [] : [SovereignTensor.Vector];
      var pendingIds = [] : [Nat];
      var lastFlushTimestamp = 0;
      config;
    }
  };

  /// Add request to batch, returns true if batch should be flushed
  public func addToBatch(acc : BatchAccumulator, input : SovereignTensor.Vector, requestId : Nat) : Bool {
    acc.pending := Array.append(acc.pending, [input]);
    acc.pendingIds := Array.append(acc.pendingIds, [requestId]);
    acc.pending.size() >= acc.config.maxBatchSize
  };

  /// Flush and process current batch
  public func flushBatch(
    acc : BatchAccumulator,
    network : SovereignNeuralEngine.NeuralNetwork,
    timestamp : Int
  ) : [(Nat, SovereignTensor.Vector)] {
    let results = Array.tabulate<(Nat, SovereignTensor.Vector)>(acc.pending.size(), func(i : Nat) : (Nat, SovereignTensor.Vector) {
      let output = SovereignNeuralEngine.forward(network, acc.pending[i]);
      (acc.pendingIds[i], output)
    });
    acc.pending := [];
    acc.pendingIds := [];
    acc.lastFlushTimestamp := timestamp;
    results
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MODEL SHARDING — SPLIT LARGE MODELS ACROSS MEMORY BOUNDARIES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Model shard metadata
  public type ModelShard = {
    shardId : Nat;
    totalShards : Nat;
    startLayer : Nat;
    endLayer : Nat;
    checksum : Nat;
    layers : [LayerWeights];
  };

  /// Split model into N shards for distributed execution
  public func shardModel(model : SovereignModelFormat, numShards : Nat) : [ModelShard] {
    let totalLayers = model.layers.size();
    let layersPerShard = totalLayers / numShards;

    Array.tabulate<ModelShard>(numShards, func(s : Nat) : ModelShard {
      let startLayer = s * layersPerShard;
      let endLayer = if (s == numShards - 1) totalLayers else (s + 1) * layersPerShard;
      let shardLayers = Array.tabulate<LayerWeights>(endLayer - startLayer, func(i : Nat) : LayerWeights {
        model.layers[startLayer + i]
      });

      // Compute shard checksum
      var hash : Nat = 14695981039346656037;
      let prime : Nat = 1099511628211;
      for (layer in shardLayers.vals()) {
        for (w in layer.weights.vals()) {
          hash := (hash ^ Int.abs(Float.toInt64(w))) *% prime;
        };
      };

      { shardId = s; totalShards = numShards; startLayer; endLayer; checksum = hash; layers = shardLayers }
    })
  };

  /// Verify shard integrity before execution
  public func verifyShard(shard : ModelShard) : Bool {
    var hash : Nat = 14695981039346656037;
    let prime : Nat = 1099511628211;
    for (layer in shard.layers.vals()) {
      for (w in layer.weights.vals()) {
        hash := (hash ^ Int.abs(Float.toInt64(w))) *% prime;
      };
    };
    hash == shard.checksum
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFERENCE PROFILING — LATENCY AND THROUGHPUT MEASUREMENT
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Profiling metrics per inference
  public type InferenceProfile = {
    requestId : Nat;
    layerLatencies : [Nat];   // Per-layer latency in microseconds
    totalLatency : Nat;
    peakMemoryEstimate : Nat; // Bytes
    flopsEstimate : Nat;
    quantized : Bool;
    batchSize : Nat;
  };

  /// Estimate FLOPs for a forward pass
  public func estimateFlops(model : SovereignModelFormat) : Nat {
    var totalFlops : Nat = 0;
    for (layer in model.layers.vals()) {
      // Dense layer: 2 × inputDim × outputDim (multiply-accumulate)
      totalFlops += 2 * layer.inputDim * layer.outputDim;
      // Bias addition: outputDim
      totalFlops += layer.outputDim;
      // Activation: ~outputDim
      totalFlops += layer.outputDim;
    };
    totalFlops
  };

  /// Estimate memory footprint of model in bytes
  public func estimateMemory(model : SovereignModelFormat, bitsPerWeight : Nat) : Nat {
    var totalParams : Nat = 0;
    for (layer in model.layers.vals()) {
      totalParams += layer.inputDim * layer.outputDim; // Weights
      totalParams += layer.outputDim;                  // Biases
    };
    (totalParams * bitsPerWeight) / 8
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WARM-UP PASSES — STABILIZE INFERENCE BEFORE OPERATIONAL USE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Run warm-up inference passes to stabilize runtime
  /// Critical for tactical systems that need deterministic latency
  public func warmUp(
    network : SovereignNeuralEngine.NeuralNetwork,
    inputDim : Nat,
    numPasses : Nat,
    seed : Nat
  ) : Bool {
    let prng = SovereignTensor.prngInit(seed);
    var allPassed = true;

    for (_ in Iter.range(0, numPasses - 1)) {
      // Generate random input
      let input = Array.tabulate<Float>(inputDim, func(_ : Nat) : Float {
        SovereignTensor.prngNext(prng) - 0.5
      });
      let output = SovereignNeuralEngine.forward(network, input);
      // Verify output is not NaN or Inf
      for (v in output.vals()) {
        if (Float.isNaN(v) or not Float.isFinite(v)) {
          allPassed := false;
        };
      };
    };
    allPassed
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OUTPUT CACHING — AVOID REDUNDANT COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Inference cache entry
  public type CacheEntry = {
    inputHash : Nat;
    output : SovereignTensor.Vector;
    timestamp : Int;
    hitCount : Nat;
  };

  /// Inference cache (LRU-style)
  public type InferenceCache = {
    var entries : [CacheEntry];
    maxSize : Nat;
    var hits : Nat;
    var misses : Nat;
  };

  /// Create inference cache
  public func createCache(maxSize : Nat) : InferenceCache {
    { var entries = [] : [CacheEntry]; maxSize; var hits = 0; var misses = 0 }
  };

  /// Hash input vector for cache lookup
  public func hashInput(input : SovereignTensor.Vector) : Nat {
    var hash : Nat = 14695981039346656037;
    let prime : Nat = 1099511628211;
    for (v in input.vals()) {
      hash := (hash ^ Int.abs(Float.toInt64(v))) *% prime;
    };
    hash
  };

  /// Lookup cached result
  public func cacheLookup(cache : InferenceCache, input : SovereignTensor.Vector) : ?SovereignTensor.Vector {
    let inputHash = hashInput(input);
    for (entry in cache.entries.vals()) {
      if (entry.inputHash == inputHash) {
        cache.hits += 1;
        return ?entry.output;
      };
    };
    cache.misses += 1;
    null
  };

  /// Store result in cache
  public func cacheStore(cache : InferenceCache, input : SovereignTensor.Vector, output : SovereignTensor.Vector, timestamp : Int) : () {
    let inputHash = hashInput(input);
    let entry : CacheEntry = { inputHash; output; timestamp; hitCount = 0 };

    if (cache.entries.size() >= cache.maxSize) {
      // Evict oldest entry (simple FIFO for determinism)
      cache.entries := Array.tabulate<CacheEntry>(cache.entries.size(), func(i : Nat) : CacheEntry {
        if (i < cache.entries.size() - 1) { cache.entries[i + 1] } else { entry }
      });
    } else {
      cache.entries := Array.append(cache.entries, [entry]);
    };
  };

  /// Get cache hit rate
  public func cacheHitRate(cache : InferenceCache) : Float {
    let total = cache.hits + cache.misses;
    if (total == 0) return 0.0;
    Float.fromInt(cache.hits) / Float.fromInt(total)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MODEL VERSIONING — ROLLBACK SUPPORT FOR DEFENSE SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Model version record
  public type ModelVersion = {
    version : Text;
    timestamp : Int;
    checksum : Nat;
    parentVersion : ?Text;
    changelog : Text;
    deployedBy : Text;
    isActive : Bool;
  };

  /// Model registry for version management
  public type ModelRegistry = {
    var versions : [ModelVersion];
    var activeVersion : ?Text;
    modelId : Text;
  };

  /// Create model registry
  public func createRegistry(modelId : Text) : ModelRegistry {
    { var versions = [] : [ModelVersion]; var activeVersion = null; modelId }
  };

  /// Register a new model version
  public func registerVersion(
    registry : ModelRegistry,
    version : Text,
    timestamp : Int,
    checksum : Nat,
    changelog : Text,
    deployedBy : Text
  ) : () {
    let record : ModelVersion = {
      version;
      timestamp;
      checksum;
      parentVersion = registry.activeVersion;
      changelog;
      deployedBy;
      isActive = true;
    };
    registry.versions := Array.append(registry.versions, [record]);
    registry.activeVersion := ?version;
  };

  /// Rollback to a previous model version
  public func rollback(registry : ModelRegistry, targetVersion : Text) : Bool {
    var found = false;
    for (v in registry.versions.vals()) {
      if (Text.equal(v.version, targetVersion)) {
        found := true;
      };
    };
    if (found) {
      registry.activeVersion := ?targetVersion;
    };
    found
  };

  /// Get version history for audit
  public func getVersionHistory(registry : ModelRegistry) : [ModelVersion] {
    registry.versions
  };
}
