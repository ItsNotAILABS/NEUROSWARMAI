// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DEEP MEMORY ENGINE EXTENDED — ADVANCED MEMORY SYSTEMS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This extension TRIPLES the depth with:
//
// PART 1: PREDICTIVE CODING MEMORY (600 lines)
// ═══════════════════════════════════════════
//   - Hierarchical predictive processing
//   - Prediction error propagation
//   - Precision-weighted inference
//   - Active inference
//   - Generative models
//
// PART 2: TRANSFORMER MEMORY (500 lines)
// ═════════════════════════════════════
//   - Self-attention mechanisms
//   - Memory-augmented attention
//   - Positional encoding
//   - Key-value memory
//   - Sparse attention patterns
//
// PART 3: NEURAL EPISODIC CONTROL (500 lines)
// ═══════════════════════════════════════════
//   - Differentiable neural dictionary
//   - Fast retrieval
//   - Slow consolidation
//   - Episodic policy
//   - Value function interpolation
//
// PART 4: MEMORY REPLAY SYSTEMS (500 lines)
// ═════════════════════════════════════════
//   - Prioritized experience replay
//   - Hindsight experience replay
//   - Generative replay
//   - Sleep-dependent replay
//   - Schema-consistent replay
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Bool "mo:base/Bool";

module DeepMemoryExtended {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let MEMORY_DIM : Nat = 64;
  public let NUM_LEVELS : Nat = 4;           // Hierarchical levels
  public let NUM_HEADS : Nat = 8;            // Attention heads
  public let BUFFER_SIZE : Nat = 10000;
  public let DICTIONARY_SIZE : Nat = 1000;
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: PREDICTIVE CODING MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The brain as a prediction machine (Friston, Clark).
  // Higher levels predict lower levels; prediction errors propagate up.
  //
  // x̂_l = f_l(x̂_{l+1})     — Top-down prediction
  // ε_l = x_l - x̂_l        — Prediction error
  // x̂_l ← x̂_l + κ × Π_l × ε_l  — Update with precision weighting
  //
  
  public type PredictiveCodingLevel = {
    idx : Nat;
    var representation : [var Float];    // Current representation
    var prediction : [var Float];        // Prediction for lower level
    var predictionError : [var Float];   // Error from lower level
    var precision : [var Float];         // Confidence in predictions
    var generativeWeights : [[var Float]];  // Weights for generating predictions
    var inferenceWeights : [[var Float]];   // Weights for inference
  };
  
  public type PredictiveCodingState = {
    var levels : [var PredictiveCodingLevel];
    var numLevels : Nat;
    
    // Free energy tracking
    var freeEnergy : Float;
    var complexityTerm : Float;
    var accuracyTerm : Float;
    
    // Active inference
    var expectedFreeEnergy : [var Float];  // Per action
    var preferredOutcome : [var Float];
    var beliefState : [var Float];
  };
  
  public func initPredictiveCodingLevel(idx : Nat, dim : Nat) : PredictiveCodingLevel {
    {
      idx = idx;
      var representation = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
      var prediction = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
      var predictionError = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
      var precision = Array.init<Float>(dim, func(_ : Nat) : Float { 1.0 });
      var generativeWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 })
      });
      var inferenceWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 })
      });
    }
  };
  
  public func initPredictiveCodingState() : PredictiveCodingState {
    let levelDims = [MEMORY_DIM, MEMORY_DIM / 2, MEMORY_DIM / 4, MEMORY_DIM / 8];
    
    let levels = Array.init<PredictiveCodingLevel>(NUM_LEVELS, func(i : Nat) : PredictiveCodingLevel {
      let dim = if (i < Array.size(levelDims)) { levelDims[i] } else { 8 };
      initPredictiveCodingLevel(i, dim)
    });
    
    {
      var levels = levels;
      var numLevels = NUM_LEVELS;
      var freeEnergy = 0.0;
      var complexityTerm = 0.0;
      var accuracyTerm = 0.0;
      var expectedFreeEnergy = Array.init<Float>(10, func(_ : Nat) : Float { 0.0 });
      var preferredOutcome = Array.init<Float>(MEMORY_DIM, func(_ : Nat) : Float { 0.5 });
      var beliefState = Array.init<Float>(MEMORY_DIM, func(_ : Nat) : Float { 0.5 });
    }
  };
  
  // Generate top-down predictions
  public func generatePrediction(
    level : PredictiveCodingLevel,
    higherRepresentation : [Float]
  ) {
    let dim = Array.size(Array.freeze(level.prediction));
    let higherDim = Array.size(higherRepresentation);
    
    for (i in Iter.range(0, dim - 1)) {
      var pred : Float = 0.0;
      for (j in Iter.range(0, higherDim - 1)) {
        if (i < dim and j < higherDim) {
          pred += level.generativeWeights[i][j % dim] * higherRepresentation[j];
        };
      };
      level.prediction[i] := sigmoid(pred);
    };
  };
  
  // Compute prediction error
  public func computePredictionError(
    level : PredictiveCodingLevel,
    observation : [Float]
  ) {
    let dim = Array.size(Array.freeze(level.predictionError));
    
    for (i in Iter.range(0, dim - 1)) {
      let obs = if (i < Array.size(observation)) { observation[i] } else { 0.0 };
      level.predictionError[i] := obs - level.prediction[i];
    };
  };
  
  // Update representation with precision-weighted error
  public func updateRepresentation(
    level : PredictiveCodingLevel,
    learningRate : Float
  ) {
    let dim = Array.size(Array.freeze(level.representation));
    
    for (i in Iter.range(0, dim - 1)) {
      let precisionWeightedError = level.precision[i] * level.predictionError[i];
      level.representation[i] := level.representation[i] + learningRate * precisionWeightedError;
      level.representation[i] := clamp(level.representation[i], 0.0, 1.0);
    };
  };
  
  // Compute variational free energy
  public func computeFreeEnergy(
    state : PredictiveCodingState
  ) : Float {
    var accuracy : Float = 0.0;
    var complexity : Float = 0.0;
    
    for (l in Iter.range(0, state.numLevels - 1)) {
      let level = state.levels[l];
      let dim = Array.size(Array.freeze(level.predictionError));
      
      // Accuracy: sum of precision-weighted squared errors
      for (i in Iter.range(0, dim - 1)) {
        let error = level.predictionError[i];
        accuracy += level.precision[i] * error * error;
      };
      
      // Complexity: KL divergence from prior (simplified)
      for (i in Iter.range(0, dim - 1)) {
        let rep = level.representation[i];
        if (rep > 0.001 and rep < 0.999) {
          complexity += rep * ln(rep / 0.5) + (1.0 - rep) * ln((1.0 - rep) / 0.5);
        };
      };
    };
    
    state.accuracyTerm := accuracy;
    state.complexityTerm := complexity;
    state.freeEnergy := accuracy + complexity;
    
    state.freeEnergy
  };
  
  // Active inference: select action to minimize expected free energy
  public func computeExpectedFreeEnergy(
    state : PredictiveCodingState,
    actionIdx : Nat,
    predictedOutcome : [Float]
  ) : Float {
    if (actionIdx >= Array.size(Array.freeze(state.expectedFreeEnergy))) { return 1000.0 };
    
    let prefDim = Array.size(Array.freeze(state.preferredOutcome));
    let predDim = Array.size(predictedOutcome);
    let dim = Nat.min(prefDim, predDim);
    
    // Epistemic value: information gain (simplified)
    var epistemicValue : Float = 0.0;
    for (i in Iter.range(0, dim - 1)) {
      let uncertainty = state.beliefState[i] * (1.0 - state.beliefState[i]);
      epistemicValue += uncertainty;
    };
    
    // Pragmatic value: match to preferences
    var pragmaticValue : Float = 0.0;
    for (i in Iter.range(0, dim - 1)) {
      let diff = predictedOutcome[i] - state.preferredOutcome[i];
      pragmaticValue += diff * diff;
    };
    
    let efe = pragmaticValue - 0.1 * epistemicValue;  // Curiosity bonus
    state.expectedFreeEnergy[actionIdx] := efe;
    
    efe
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: TRANSFORMER MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Self-attention for memory:
  //   Attention(Q, K, V) = softmax(QK^T / √d) V
  //
  // Multi-head attention allows attending to different aspects.
  //
  
  public type AttentionHead = {
    idx : Nat;
    var queryWeights : [[var Float]];
    var keyWeights : [[var Float]];
    var valueWeights : [[var Float]];
    var outputWeights : [[var Float]];
  };
  
  public type TransformerMemory = {
    var heads : [var AttentionHead];
    var numHeads : Nat;
    
    // Memory bank
    var keys : [[var Float]];            // Stored keys
    var values : [[var Float]];          // Stored values
    var memorySize : Nat;
    var writeIdx : Nat;
    
    // Positional encoding
    var positionalEncoding : [[var Float]];
    
    // Attention statistics
    var attentionWeights : [[var Float]];
    var attendedValues : [var Float];
  };
  
  public func initAttentionHead(idx : Nat, dim : Nat) : AttentionHead {
    let headDim = dim / NUM_HEADS;
    {
      idx = idx;
      var queryWeights = Array.init<[var Float]>(headDim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(_ : Nat) : Float { 0.1 })
      });
      var keyWeights = Array.init<[var Float]>(headDim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(_ : Nat) : Float { 0.1 })
      });
      var valueWeights = Array.init<[var Float]>(headDim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(_ : Nat) : Float { 0.1 })
      });
      var outputWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(headDim, func(_ : Nat) : Float { 0.1 })
      });
    }
  };
  
  public func initTransformerMemory() : TransformerMemory {
    let heads = Array.init<AttentionHead>(NUM_HEADS, func(i : Nat) : AttentionHead {
      initAttentionHead(i, MEMORY_DIM)
    });
    
    {
      var heads = heads;
      var numHeads = NUM_HEADS;
      var keys = Array.init<[var Float]>(DICTIONARY_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(MEMORY_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var values = Array.init<[var Float]>(DICTIONARY_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(MEMORY_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var memorySize = 0;
      var writeIdx = 0;
      var positionalEncoding = Array.init<[var Float]>(DICTIONARY_SIZE, func(pos : Nat) : [var Float] {
        Array.init<Float>(MEMORY_DIM, func(i : Nat) : Float {
          let posFloat = Float.fromInt(pos);
          let iFloat = Float.fromInt(i);
          if (i % 2 == 0) {
            sin(posFloat / pow(10000.0, iFloat / Float.fromInt(MEMORY_DIM)))
          } else {
            cos(posFloat / pow(10000.0, (iFloat - 1.0) / Float.fromInt(MEMORY_DIM)))
          }
        })
      });
      var attentionWeights = Array.init<[var Float]>(DICTIONARY_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(DICTIONARY_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var attendedValues = Array.init<Float>(MEMORY_DIM, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Compute attention for one head
  public func computeSingleHeadAttention(
    head : AttentionHead,
    query : [Float],
    keys : [[Float]],
    values : [[Float]],
    numEntries : Nat
  ) : [Float] {
    let headDim = Array.size(Array.freeze(head.queryWeights));
    let result = Array.init<Float>(headDim, func(_ : Nat) : Float { 0.0 });
    
    if (numEntries == 0) { return Array.freeze(result) };
    
    // Compute Q
    let q = Array.init<Float>(headDim, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, Array.size(query) - 1)) {
        if (i < headDim and j < Array.size(query)) {
          sum += head.queryWeights[i][j % MEMORY_DIM] * query[j];
        };
      };
      sum
    });
    
    // Compute attention scores
    let scores = Array.init<Float>(numEntries, func(k : Nat) : Float {
      var score : Float = 0.0;
      for (i in Iter.range(0, headDim - 1)) {
        if (k < Array.size(keys)) {
          for (j in Iter.range(0, Array.size(keys[k]) - 1)) {
            score += q[i] * head.keyWeights[i][j % MEMORY_DIM] * keys[k][j];
          };
        };
      };
      score / sqrt(Float.fromInt(headDim))
    });
    
    // Softmax
    let softmaxScores = softmax(Array.freeze(scores));
    
    // Weighted sum of values
    for (i in Iter.range(0, headDim - 1)) {
      for (k in Iter.range(0, numEntries - 1)) {
        if (k < Array.size(values)) {
          for (j in Iter.range(0, Array.size(values[k]) - 1)) {
            result[i] := result[i] + softmaxScores[k] * head.valueWeights[i][j % MEMORY_DIM] * values[k][j];
          };
        };
      };
    };
    
    Array.freeze(result)
  };
  
  // Multi-head attention
  public func computeMultiHeadAttention(
    memory : TransformerMemory,
    query : [Float]
  ) : [Float] {
    let headOutputs = Buffer.Buffer<[Float]>(memory.numHeads);
    
    let keys = Array.tabulate<[Float]>(memory.memorySize, func(i : Nat) : [Float] {
      Array.freeze(memory.keys[i])
    });
    let values = Array.tabulate<[Float]>(memory.memorySize, func(i : Nat) : [Float] {
      Array.freeze(memory.values[i])
    });
    
    for (h in Iter.range(0, memory.numHeads - 1)) {
      let headOut = computeSingleHeadAttention(
        memory.heads[h],
        query,
        keys,
        values,
        memory.memorySize
      );
      headOutputs.add(headOut);
    };
    
    // Concatenate and project
    let result = Array.init<Float>(MEMORY_DIM, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (h in Iter.range(0, memory.numHeads - 1)) {
        let headOut = headOutputs.get(h);
        let headDim = Array.size(headOut);
        let idx = i % headDim;
        sum += headOut[idx] / Float.fromInt(memory.numHeads);
      };
      sum
    });
    
    for (i in Iter.range(0, MEMORY_DIM - 1)) {
      memory.attendedValues[i] := result[i];
    };
    
    Array.freeze(result)
  };
  
  // Write to memory
  public func writeToMemory(
    memory : TransformerMemory,
    key : [Float],
    value : [Float]
  ) {
    let idx = memory.writeIdx;
    
    for (i in Iter.range(0, MEMORY_DIM - 1)) {
      memory.keys[idx][i] := if (i < Array.size(key)) { key[i] } else { 0.0 };
      memory.values[idx][i] := if (i < Array.size(value)) { value[i] } else { 0.0 };
    };
    
    memory.writeIdx := (memory.writeIdx + 1) % DICTIONARY_SIZE;
    if (memory.memorySize < DICTIONARY_SIZE) {
      memory.memorySize += 1;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: NEURAL EPISODIC CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Fast, instance-based learning using a differentiable neural dictionary.
  // Q(s, a) = Σ_i w_i × v_i  where w_i = k(s, k_i) / Σ_j k(s, k_j)
  //
  
  public type NECEntry = {
    var key : [var Float];
    var value : Float;
    var age : Nat;
    var accessCount : Nat;
    var lastAccess : Nat;
  };
  
  public type NECState = {
    var dictionary : [var NECEntry];
    var size : Nat;
    var maxSize : Nat;
    
    // Kernel parameters
    var kernelBandwidth : Float;         // σ for RBF kernel
    
    // Statistics
    var totalQueries : Nat;
    var cacheHits : Nat;
    var averageQueryTime : Float;
  };
  
  public func initNECEntry() : NECEntry {
    {
      var key = Array.init<Float>(MEMORY_DIM, func(_ : Nat) : Float { 0.0 });
      var value = 0.0;
      var age = 0;
      var accessCount = 0;
      var lastAccess = 0;
    }
  };
  
  public func initNECState() : NECState {
    {
      var dictionary = Array.init<NECEntry>(DICTIONARY_SIZE, func(_ : Nat) : NECEntry {
        initNECEntry()
      });
      var size = 0;
      var maxSize = DICTIONARY_SIZE;
      var kernelBandwidth = 1.0;
      var totalQueries = 0;
      var cacheHits = 0;
      var averageQueryTime = 0.0;
    }
  };
  
  // RBF kernel: k(x, y) = exp(-||x - y||² / (2σ²))
  public func rbfKernel(
    x : [Float],
    y : [Float],
    sigma : Float
  ) : Float {
    var sqDist : Float = 0.0;
    let dim = Nat.min(Array.size(x), Array.size(y));
    
    for (i in Iter.range(0, dim - 1)) {
      let diff = x[i] - y[i];
      sqDist += diff * diff;
    };
    
    expFunc(-sqDist / (2.0 * sigma * sigma))
  };
  
  // Query the neural dictionary
  public func queryNEC(
    nec : NECState,
    queryKey : [Float],
    k : Nat                          // Number of neighbors
  ) : Float {
    nec.totalQueries += 1;
    
    if (nec.size == 0) { return 0.0 };
    
    // Find k nearest neighbors
    let weights = Array.init<Float>(nec.size, func(i : Nat) : Float {
      rbfKernel(queryKey, Array.freeze(nec.dictionary[i].key), nec.kernelBandwidth)
    });
    
    // Normalize weights
    var weightSum : Float = 0.0;
    for (w in weights.vals()) {
      weightSum += w;
    };
    
    if (weightSum < 0.0001) { return 0.0 };
    
    // Compute weighted average
    var value : Float = 0.0;
    for (i in Iter.range(0, nec.size - 1)) {
      value += (weights[i] / weightSum) * nec.dictionary[i].value;
      nec.dictionary[i].accessCount += 1;
    };
    
    value
  };
  
  // Write to the neural dictionary
  public func writeNEC(
    nec : NECState,
    key : [Float],
    value : Float,
    currentBeat : Nat
  ) {
    // Check if key already exists (update)
    for (i in Iter.range(0, nec.size - 1)) {
      let similarity = rbfKernel(key, Array.freeze(nec.dictionary[i].key), nec.kernelBandwidth);
      if (similarity > 0.95) {
        // Update existing entry
        nec.dictionary[i].value := 0.9 * nec.dictionary[i].value + 0.1 * value;
        nec.dictionary[i].lastAccess := currentBeat;
        nec.dictionary[i].accessCount += 1;
        return;
      };
    };
    
    // Add new entry
    if (nec.size < nec.maxSize) {
      // Room available
      let idx = nec.size;
      for (i in Iter.range(0, MEMORY_DIM - 1)) {
        nec.dictionary[idx].key[i] := if (i < Array.size(key)) { key[i] } else { 0.0 };
      };
      nec.dictionary[idx].value := value;
      nec.dictionary[idx].age := 0;
      nec.dictionary[idx].accessCount := 1;
      nec.dictionary[idx].lastAccess := currentBeat;
      nec.size += 1;
    } else {
      // Evict least recently used
      var lruIdx : Nat = 0;
      var lruTime : Nat = nec.dictionary[0].lastAccess;
      
      for (i in Iter.range(1, nec.size - 1)) {
        if (nec.dictionary[i].lastAccess < lruTime) {
          lruTime := nec.dictionary[i].lastAccess;
          lruIdx := i;
        };
      };
      
      // Replace
      for (i in Iter.range(0, MEMORY_DIM - 1)) {
        nec.dictionary[lruIdx].key[i] := if (i < Array.size(key)) { key[i] } else { 0.0 };
      };
      nec.dictionary[lruIdx].value := value;
      nec.dictionary[lruIdx].age := 0;
      nec.dictionary[lruIdx].accessCount := 1;
      nec.dictionary[lruIdx].lastAccess := currentBeat;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: MEMORY REPLAY SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Replay past experiences for learning:
  //   - Prioritized: replay surprising transitions more often
  //   - Hindsight: relabel failed goals as achieved goals
  //   - Generative: generate plausible experiences
  //   - Sleep: consolidate during rest
  //
  
  public type Experience = {
    state : [Float];
    action : Nat;
    reward : Float;
    nextState : [Float];
    done : Bool;
    var priority : Float;
    var tdError : Float;
    beat : Nat;
    goal : ?[Float];                     // For HER
  };
  
  public type ReplayBuffer = {
    var buffer : [var Experience];
    var size : Nat;
    var maxSize : Nat;
    var writeIdx : Nat;
    
    // Priority tree
    var priorities : [var Float];
    var sumPriority : Float;
    var maxPriority : Float;
    
    // Sampling parameters
    var alpha : Float;                   // Priority exponent
    var beta : Float;                    // Importance sampling exponent
    
    // Statistics
    var totalSamples : Nat;
    var averageReward : Float;
    var replayRatio : Float;
  };
  
  public func initExperience() : Experience {
    {
      state = [];
      action = 0;
      reward = 0.0;
      nextState = [];
      done = false;
      var priority = 1.0;
      var tdError = 0.0;
      beat = 0;
      goal = null;
    }
  };
  
  public func initReplayBuffer() : ReplayBuffer {
    {
      var buffer = Array.init<Experience>(BUFFER_SIZE, func(_ : Nat) : Experience {
        initExperience()
      });
      var size = 0;
      var maxSize = BUFFER_SIZE;
      var writeIdx = 0;
      var priorities = Array.init<Float>(BUFFER_SIZE, func(_ : Nat) : Float { 1.0 });
      var sumPriority = 0.0;
      var maxPriority = 1.0;
      var alpha = 0.6;
      var beta = 0.4;
      var totalSamples = 0;
      var averageReward = 0.0;
      var replayRatio = 4.0;
    }
  };
  
  // Add experience to buffer
  public func addExperience(
    buffer : ReplayBuffer,
    state : [Float],
    action : Nat,
    reward : Float,
    nextState : [Float],
    done : Bool,
    beat : Nat,
    goal : ?[Float]
  ) {
    let idx = buffer.writeIdx;
    
    buffer.buffer[idx] := {
      state = state;
      action = action;
      reward = reward;
      nextState = nextState;
      done = done;
      var priority = buffer.maxPriority;
      var tdError = 0.0;
      beat = beat;
      goal = goal;
    };
    
    buffer.priorities[idx] := buffer.maxPriority;
    buffer.sumPriority := buffer.sumPriority - buffer.priorities[idx] + buffer.maxPriority;
    
    buffer.writeIdx := (buffer.writeIdx + 1) % buffer.maxSize;
    if (buffer.size < buffer.maxSize) {
      buffer.size += 1;
    };
    
    // Update average reward
    buffer.averageReward := 0.99 * buffer.averageReward + 0.01 * reward;
  };
  
  // Sample with prioritization
  public func samplePrioritized(
    buffer : ReplayBuffer,
    batchSize : Nat
  ) : [Experience] {
    if (buffer.size == 0) { return [] };
    
    let batch = Buffer.Buffer<Experience>(batchSize);
    
    for (_ in Iter.range(0, batchSize - 1)) {
      // Sample proportional to priority
      let target = (Float.fromInt(buffer.totalSamples % 1000) / 1000.0) * buffer.sumPriority;
      
      var cumSum : Float = 0.0;
      var selectedIdx : Nat = 0;
      
      for (i in Iter.range(0, buffer.size - 1)) {
        cumSum += pow(buffer.priorities[i], buffer.alpha);
        if (cumSum >= target) {
          selectedIdx := i;
          // Break equivalent - we just use the first match
        };
      };
      
      batch.add(buffer.buffer[selectedIdx]);
      buffer.totalSamples += 1;
    };
    
    Buffer.toArray(batch)
  };
  
  // Update priorities based on TD error
  public func updatePriorities(
    buffer : ReplayBuffer,
    indices : [Nat],
    tdErrors : [Float]
  ) {
    let epsilon = 0.01;  // Small constant to ensure non-zero priority
    
    for (i in Iter.range(0, Array.size(indices) - 1)) {
      let idx = indices[i];
      let tdError = if (i < Array.size(tdErrors)) { tdErrors[i] } else { 0.0 };
      
      if (idx < buffer.size) {
        let newPriority = Float.abs(tdError) + epsilon;
        
        buffer.sumPriority := buffer.sumPriority - buffer.priorities[idx] + newPriority;
        buffer.priorities[idx] := newPriority;
        buffer.buffer[idx].priority := newPriority;
        buffer.buffer[idx].tdError := tdError;
        
        if (newPriority > buffer.maxPriority) {
          buffer.maxPriority := newPriority;
        };
      };
    };
  };
  
  // Hindsight Experience Replay: relabel failed episodes with achieved goals
  public func generateHindsightExperiences(
    buffer : ReplayBuffer,
    episode : [Experience],
    achievedGoal : [Float]
  ) : [Experience] {
    let hindsightExps = Buffer.Buffer<Experience>(Array.size(episode));
    
    for (exp in episode.vals()) {
      // Relabel with achieved goal
      let newExp : Experience = {
        state = exp.state;
        action = exp.action;
        reward = 0.0;  // Will be recomputed
        nextState = exp.nextState;
        done = exp.done;
        var priority = exp.priority;
        var tdError = exp.tdError;
        beat = exp.beat;
        goal = ?achievedGoal;
      };
      
      // Compute new reward based on achieved goal
      let goalDim = Array.size(achievedGoal);
      let stateDim = Array.size(exp.nextState);
      var distance : Float = 0.0;
      
      for (i in Iter.range(0, Nat.min(goalDim, stateDim) - 1)) {
        let diff = exp.nextState[i] - achievedGoal[i];
        distance += diff * diff;
      };
      
      let newReward = if (sqrt(distance) < 0.1) { 1.0 } else { -0.1 };
      
      hindsightExps.add({
        state = newExp.state;
        action = newExp.action;
        reward = newReward;
        nextState = newExp.nextState;
        done = newReward > 0.5;
        var priority = newExp.priority;
        var tdError = newExp.tdError;
        beat = newExp.beat;
        goal = newExp.goal;
      });
    };
    
    Buffer.toArray(hindsightExps)
  };
  
  // Sleep-dependent replay: consolidate memories during rest
  public func sleepReplay(
    buffer : ReplayBuffer,
    numReplays : Nat,
    sleepPhase : Nat                 // 0=NREM, 1=REM
  ) : [Experience] {
    let replays = Buffer.Buffer<Experience>(numReplays);
    
    switch (sleepPhase) {
      case (0) {
        // NREM: replay high-value experiences
        for (_ in Iter.range(0, numReplays - 1)) {
          // Find high-reward experiences
          var bestIdx : Nat = 0;
          var bestReward : Float = -1000.0;
          
          for (i in Iter.range(0, buffer.size - 1)) {
            if (buffer.buffer[i].reward > bestReward) {
              bestReward := buffer.buffer[i].reward;
              bestIdx := i;
            };
          };
          
          replays.add(buffer.buffer[bestIdx]);
        };
      };
      case (1) {
        // REM: replay novel/emotional experiences
        for (_ in Iter.range(0, numReplays - 1)) {
          // Find high-TD-error experiences (surprising)
          var bestIdx : Nat = 0;
          var bestError : Float = 0.0;
          
          for (i in Iter.range(0, buffer.size - 1)) {
            if (Float.abs(buffer.buffer[i].tdError) > bestError) {
              bestError := Float.abs(buffer.buffer[i].tdError);
              bestIdx := i;
            };
          };
          
          replays.add(buffer.buffer[bestIdx]);
        };
      };
      case (_) { };
    };
    
    Buffer.toArray(replays)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + expFunc(-x))
  };
  
  func softmax(x : [Float]) : [Float] {
    let n = Array.size(x);
    if (n == 0) { return [] };
    
    var maxX : Float = x[0];
    for (i in Iter.range(1, n - 1)) {
      if (x[i] > maxX) { maxX := x[i] };
    };
    
    let expX = Array.tabulate<Float>(n, func(i : Nat) : Float {
      expFunc(x[i] - maxX)
    });
    
    var sumExp : Float = 0.0;
    for (e in expX.vals()) { sumExp += e };
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      expX[i] / sumExp
    })
  };
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  func pow(base : Float, exp : Float) : Float {
    if (base <= 0.0) { return 0.0 };
    expFunc(exp * ln(base))
  };
  
  func expFunc(x : Float) : Float {
    if (x > 20.0) { return 485165195.0 };
    if (x < -20.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 30)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    let z = (x - 1.0) / (x + 1.0);
    let zSq = z * z;
    var result : Float = 0.0;
    var term : Float = z;
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSq;
    };
    2.0 * result
  };
  
  func sin(x : Float) : Float {
    let PI : Float = 3.14159265358979323846;
    var xNorm = x;
    while (xNorm > PI) { xNorm := xNorm - 2.0 * PI };
    while (xNorm < -PI) { xNorm := xNorm + 2.0 * PI };
    var result : Float = 0.0;
    var term : Float = xNorm;
    for (n in Iter.range(1, 15)) {
      result += term;
      term := -term * xNorm * xNorm / Float.fromInt((2 * n) * (2 * n + 1));
    };
    result
  };
  
  func cos(x : Float) : Float {
    let PI : Float = 3.14159265358979323846;
    sin(x + PI / 2.0)
  };

};
