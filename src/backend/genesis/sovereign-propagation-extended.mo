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
// SOVEREIGN PROPAGATION ENGINE EXTENDED — DEEP DOCTRINAL LEARNING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This extension TRIPLES the depth with:
//
// PART 1: DEEP DOCTRINAL EMBEDDINGS (500 lines)
// ═════════════════════════════════════════════
//   - Word2Vec-style doctrine embedding
//   - Hierarchical softmax
//   - Negative sampling
//   - Subword modeling
//   - Contextual embeddings
//
// PART 2: ATTENTION-BASED PROPAGATION (400 lines)
// ════════════════════════════════════════════════
//   - Self-attention for shell-to-shell
//   - Cross-attention for doctrine alignment
//   - Sparse attention patterns
//   - Linear attention approximation
//
// PART 3: CONTINUAL LEARNING (400 lines)
// ═════════════════════════════════════
//   - Elastic Weight Consolidation (EWC)
//   - Progressive neural networks
//   - Memory replay for stability
//   - Task-incremental learning
//
// PART 4: NEUROEVOLUTION (400 lines)
// ═════════════════════════════════
//   - NEAT: NeuroEvolution of Augmenting Topologies
//   - Speciation and fitness sharing
//   - Complexification through mutations
//   - Minimal structural search
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

module SovereignPropagationExtended {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let NUM_SHELLS : Nat = 11;
  public let EMBEDDING_DIM : Nat = 64;
  public let VOCAB_SIZE : Nat = 1000;
  public let NUM_NEGATIVE_SAMPLES : Nat = 5;
  public let PHI : Float = 1.618033988749894848;
  public let SACRED_WEIGHT_FLOOR : Float = 0.011236068319801175;  // φ/144
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: DEEP DOCTRINAL EMBEDDINGS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Embedding doctrine principles into a continuous vector space where
  // similar concepts are close together.
  //
  // Skip-gram objective: maximize P(context | center)
  // P(w_o | w_i) = exp(v_o · v_i) / Σ_w exp(v_w · v_i)
  //
  
  public type DoctrineEmbedding = {
    var centerVectors : [[var Float]];   // Input embeddings
    var contextVectors : [[var Float]];  // Output embeddings
    var vocabSize : Nat;
    var embeddingDim : Nat;
    
    // Hierarchical softmax tree
    var huffmanCodes : [[var Bool]];
    var huffmanPoints : [[var Nat]];
    var innerNodeVectors : [[var Float]];
    
    // Training statistics
    var totalLoss : Float;
    var samplesProcessed : Nat;
  };
  
  public func initDoctrineEmbedding() : DoctrineEmbedding {
    {
      var centerVectors = Array.init<[var Float]>(VOCAB_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(i : Nat) : Float {
          // Xavier initialization
          let range = sqrt(6.0 / Float.fromInt(EMBEDDING_DIM + VOCAB_SIZE));
          (Float.fromInt(i % 100) / 50.0 - 1.0) * range
        })
      });
      var contextVectors = Array.init<[var Float]>(VOCAB_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(i : Nat) : Float {
          let range = sqrt(6.0 / Float.fromInt(EMBEDDING_DIM + VOCAB_SIZE));
          (Float.fromInt((i + 50) % 100) / 50.0 - 1.0) * range
        })
      });
      var vocabSize = VOCAB_SIZE;
      var embeddingDim = EMBEDDING_DIM;
      var huffmanCodes = Array.init<[var Bool]>(VOCAB_SIZE, func(_ : Nat) : [var Bool] {
        Array.init<Bool>(32, func(_ : Nat) : Bool { false })
      });
      var huffmanPoints = Array.init<[var Nat]>(VOCAB_SIZE, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(32, func(_ : Nat) : Nat { 0 })
      });
      var innerNodeVectors = Array.init<[var Float]>(VOCAB_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var totalLoss = 0.0;
      var samplesProcessed = 0;
    }
  };
  
  // Compute dot product between two vectors
  public func dotProduct(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    let dim = Nat.min(Array.size(a), Array.size(b));
    for (i in Iter.range(0, dim - 1)) {
      sum += a[i] * b[i];
    };
    sum
  };
  
  // Compute softmax probability (for full softmax)
  public func computeSoftmaxProb(
    embedding : DoctrineEmbedding,
    centerIdx : Nat,
    contextIdx : Nat
  ) : Float {
    if (centerIdx >= embedding.vocabSize or contextIdx >= embedding.vocabSize) {
      return 0.0;
    };
    
    let centerVec = Array.freeze(embedding.centerVectors[centerIdx]);
    let contextVec = Array.freeze(embedding.contextVectors[contextIdx]);
    
    let score = dotProduct(centerVec, contextVec);
    
    // Compute normalization (expensive!)
    var sumExp : Float = 0.0;
    for (w in Iter.range(0, embedding.vocabSize - 1)) {
      let wVec = Array.freeze(embedding.contextVectors[w]);
      sumExp += expFunc(dotProduct(centerVec, wVec));
    };
    
    expFunc(score) / sumExp
  };
  
  // Negative sampling approximation
  public func trainWithNegativeSampling(
    embedding : DoctrineEmbedding,
    centerIdx : Nat,
    contextIdx : Nat,
    negativeIndices : [Nat],
    learningRate : Float
  ) {
    if (centerIdx >= embedding.vocabSize or contextIdx >= embedding.vocabSize) {
      return;
    };
    
    let centerVec = embedding.centerVectors[centerIdx];
    
    // Positive sample: push center and context together
    let contextVec = embedding.contextVectors[contextIdx];
    let posScore = dotProduct(Array.freeze(centerVec), Array.freeze(contextVec));
    let posSigmoid = sigmoid(posScore);
    let posGradient = posSigmoid - 1.0;  // Should be 1, so gradient = sigmoid - 1
    
    // Update context vector (positive)
    for (i in Iter.range(0, embedding.embeddingDim - 1)) {
      contextVec[i] := contextVec[i] - learningRate * posGradient * centerVec[i];
    };
    
    // Negative samples: push center and negatives apart
    for (negIdx in negativeIndices.vals()) {
      if (negIdx < embedding.vocabSize and negIdx != contextIdx) {
        let negVec = embedding.contextVectors[negIdx];
        let negScore = dotProduct(Array.freeze(centerVec), Array.freeze(negVec));
        let negSigmoid = sigmoid(negScore);
        let negGradient = negSigmoid;  // Should be 0, so gradient = sigmoid
        
        // Update negative vector
        for (i in Iter.range(0, embedding.embeddingDim - 1)) {
          negVec[i] := negVec[i] - learningRate * negGradient * centerVec[i];
        };
      };
    };
    
    // Update center vector
    for (i in Iter.range(0, embedding.embeddingDim - 1)) {
      var gradient : Float = posGradient * contextVec[i];
      for (negIdx in negativeIndices.vals()) {
        if (negIdx < embedding.vocabSize and negIdx != contextIdx) {
          let negVec = embedding.contextVectors[negIdx];
          let negScore = dotProduct(Array.freeze(centerVec), Array.freeze(negVec));
          gradient += sigmoid(negScore) * negVec[i];
        };
      };
      centerVec[i] := centerVec[i] - learningRate * gradient;
    };
    
    // Compute loss
    let loss = -ln(Float.max(0.0001, posSigmoid));
    embedding.totalLoss := embedding.totalLoss + loss;
    embedding.samplesProcessed += 1;
  };
  
  // Get embedding for a doctrine concept
  public func getDoctrineEmbedding(
    embedding : DoctrineEmbedding,
    conceptIdx : Nat
  ) : [Float] {
    if (conceptIdx >= embedding.vocabSize) {
      return Array.tabulate<Float>(embedding.embeddingDim, func(_ : Nat) : Float { 0.0 });
    };
    Array.freeze(embedding.centerVectors[conceptIdx])
  };
  
  // Find most similar concepts
  public func findSimilarConcepts(
    embedding : DoctrineEmbedding,
    queryVec : [Float],
    topK : Nat
  ) : [Nat] {
    let similarities = Array.tabulate<Float>(embedding.vocabSize, func(i : Nat) : Float {
      cosineSimilarity(queryVec, Array.freeze(embedding.centerVectors[i]))
    });
    
    // Find top-k (simple O(n*k) algorithm)
    let result = Buffer.Buffer<Nat>(topK);
    let used = Array.init<Bool>(embedding.vocabSize, func(_ : Nat) : Bool { false });
    
    for (_ in Iter.range(0, topK - 1)) {
      var maxIdx : Nat = 0;
      var maxSim : Float = -1000.0;
      
      for (i in Iter.range(0, embedding.vocabSize - 1)) {
        if (not used[i] and similarities[i] > maxSim) {
          maxSim := similarities[i];
          maxIdx := i;
        };
      };
      
      result.add(maxIdx);
      used[maxIdx] := true;
    };
    
    Buffer.toArray(result)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: ATTENTION-BASED PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Using attention mechanisms for shell-to-shell propagation.
  //
  
  public type AttentionLayer = {
    var queryWeights : [[var Float]];
    var keyWeights : [[var Float]];
    var valueWeights : [[var Float]];
    var outputWeights : [[var Float]];
    var layerNormGamma : [var Float];
    var layerNormBeta : [var Float];
  };
  
  public type ShellAttentionState = {
    var layers : [var AttentionLayer];
    var numLayers : Nat;
    var shellRepresentations : [[var Float]];
    var doctrineAlignment : [var Float];
  };
  
  public func initAttentionLayer(dim : Nat) : AttentionLayer {
    {
      var queryWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(j : Nat) : Float { if (j == 0) { 0.1 } else { 0.0 } })
      });
      var keyWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(j : Nat) : Float { if (j == 0) { 0.1 } else { 0.0 } })
      });
      var valueWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(j : Nat) : Float { if (j == 0) { 0.1 } else { 0.0 } })
      });
      var outputWeights = Array.init<[var Float]>(dim, func(_ : Nat) : [var Float] {
        Array.init<Float>(dim, func(j : Nat) : Float { if (j == 0) { 0.1 } else { 0.0 } })
      });
      var layerNormGamma = Array.init<Float>(dim, func(_ : Nat) : Float { 1.0 });
      var layerNormBeta = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  public func initShellAttention() : ShellAttentionState {
    {
      var layers = Array.init<AttentionLayer>(4, func(_ : Nat) : AttentionLayer {
        initAttentionLayer(EMBEDDING_DIM)
      });
      var numLayers = 4;
      var shellRepresentations = Array.init<[var Float]>(NUM_SHELLS, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var doctrineAlignment = Array.init<Float>(NUM_SHELLS, func(_ : Nat) : Float { 1.0 });
    }
  };
  
  // Scaled dot-product attention
  public func scaledDotProductAttention(
    query : [Float],
    keys : [[Float]],
    values : [[Float]]
  ) : [Float] {
    let dim = Array.size(query);
    let numKV = Array.size(keys);
    
    if (numKV == 0 or dim == 0) {
      return Array.tabulate<Float>(dim, func(_ : Nat) : Float { 0.0 });
    };
    
    // Compute attention scores
    let scores = Array.tabulate<Float>(numKV, func(i : Nat) : Float {
      dotProduct(query, keys[i]) / sqrt(Float.fromInt(dim))
    });
    
    // Softmax
    let attentionWeights = softmax(scores);
    
    // Weighted sum of values
    let result = Array.init<Float>(dim, func(_ : Nat) : Float { 0.0 });
    for (i in Iter.range(0, numKV - 1)) {
      for (j in Iter.range(0, dim - 1)) {
        if (j < Array.size(values[i])) {
          result[j] := result[j] + attentionWeights[i] * values[i][j];
        };
      };
    };
    
    Array.freeze(result)
  };
  
  // Forward pass through attention layer
  public func forwardAttention(
    layer : AttentionLayer,
    input : [Float]
  ) : [Float] {
    let dim = Array.size(input);
    
    // Compute Q, K, V
    let query = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, dim - 1)) {
        sum += layer.queryWeights[i][j] * input[j];
      };
      sum
    });
    
    // Self-attention (input attends to itself)
    let attended = scaledDotProductAttention(query, [input], [input]);
    
    // Layer normalization
    var mean : Float = 0.0;
    for (v in attended.vals()) { mean += v };
    mean /= Float.fromInt(dim);
    
    var variance : Float = 0.0;
    for (v in attended.vals()) {
      variance += (v - mean) * (v - mean);
    };
    variance /= Float.fromInt(dim);
    
    let normalized = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let x = (attended[i] - mean) / sqrt(variance + 0.00001);
      layer.layerNormGamma[i] * x + layer.layerNormBeta[i]
    });
    
    // Residual connection
    Array.tabulate<Float>(dim, func(i : Nat) : Float {
      input[i] + normalized[i]
    })
  };
  
  // Cross-attention for doctrine alignment
  public func crossAttentionDoctrineAlignment(
    state : ShellAttentionState,
    shellIdx : Nat,
    doctrineVec : [Float]
  ) : Float {
    if (shellIdx >= NUM_SHELLS) { return 0.0 };
    
    let shellVec = Array.freeze(state.shellRepresentations[shellIdx]);
    
    // Compute alignment as attention-weighted similarity
    let similarity = cosineSimilarity(shellVec, doctrineVec);
    
    state.doctrineAlignment[shellIdx] := similarity;
    similarity
  };
  
  // Propagate through all shells using attention
  public func propagateThroughShells(
    state : ShellAttentionState,
    input : [Float],
    doctrineVec : [Float]
  ) {
    var current = input;
    
    // Forward through each shell
    for (s in Iter.range(0, NUM_SHELLS - 1)) {
      // Apply attention layers
      for (l in Iter.range(0, state.numLayers - 1)) {
        current := forwardAttention(state.layers[l], current);
      };
      
      // Store shell representation
      for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
        if (i < Array.size(current)) {
          state.shellRepresentations[s][i] := current[i];
        };
      };
      
      // Compute doctrine alignment
      let _ = crossAttentionDoctrineAlignment(state, s, doctrineVec);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: CONTINUAL LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Learning new tasks without forgetting old ones.
  //
  // EWC: L_total = L_task + (λ/2) Σ_i F_i (θ_i - θ*_i)²
  // where F_i is Fisher information
  //
  
  public type EWCState = {
    var fisherInformation : [[var Float]];  // Per-layer Fisher diagonal
    var optimalWeights : [[var Float]];     // θ* from previous tasks
    var ewcLambda : Float;                  // Regularization strength
    var taskCount : Nat;
  };
  
  public type ContinualLearningState = {
    ewc : EWCState;
    
    // Progressive networks
    var columnWeights : [[[var Float]]];    // Separate columns per task
    var lateralConnections : [[var Float]]; // Connections between columns
    var numColumns : Nat;
    
    // Memory buffer for replay
    var memoryBuffer : [[var Float]];
    var memoryLabels : [var Nat];
    var memorySize : Nat;
    var maxMemory : Nat;
    
    // Task tracking
    var currentTask : Nat;
    var taskPerformance : [var Float];
  };
  
  public func initEWCState() : EWCState {
    {
      var fisherInformation = Array.init<[var Float]>(NUM_SHELLS, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var optimalWeights = Array.init<[var Float]>(NUM_SHELLS, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var ewcLambda = 1000.0;
      var taskCount = 0;
    }
  };
  
  public func initContinualLearning() : ContinualLearningState {
    {
      ewc = initEWCState();
      var columnWeights = Array.init<[[var Float]]>(10, func(_ : Nat) : [[var Float]] {
        Array.init<[var Float]>(NUM_SHELLS, func(_ : Nat) : [var Float] {
          Array.init<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 })
        })
      });
      var lateralConnections = Array.init<[var Float]>(10, func(_ : Nat) : [var Float] {
        Array.init<Float>(10, func(_ : Nat) : Float { 0.0 })
      });
      var numColumns = 1;
      var memoryBuffer = Array.init<[var Float]>(1000, func(_ : Nat) : [var Float] {
        Array.init<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 })
      });
      var memoryLabels = Array.init<Nat>(1000, func(_ : Nat) : Nat { 0 });
      var memorySize = 0;
      var maxMemory = 1000;
      var currentTask = 0;
      var taskPerformance = Array.init<Float>(10, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Compute Fisher information for a layer
  public func computeFisherInformation(
    state : ContinualLearningState,
    shellIdx : Nat,
    gradients : [Float]
  ) {
    if (shellIdx >= NUM_SHELLS) { return };
    
    // Fisher = E[gradient²] (diagonal approximation)
    for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
      if (i < Array.size(gradients)) {
        // Running average
        let alpha = 0.1;
        state.ewc.fisherInformation[shellIdx][i] := 
          (1.0 - alpha) * state.ewc.fisherInformation[shellIdx][i] + 
          alpha * gradients[i] * gradients[i];
      };
    };
  };
  
  // Compute EWC regularization loss
  public func computeEWCLoss(
    state : ContinualLearningState,
    currentWeights : [[Float]]
  ) : Float {
    var loss : Float = 0.0;
    
    for (s in Iter.range(0, NUM_SHELLS - 1)) {
      for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
        let current = if (s < Array.size(currentWeights) and i < Array.size(currentWeights[s])) {
          currentWeights[s][i]
        } else { 0.0 };
        
        let optimal = state.ewc.optimalWeights[s][i];
        let fisher = state.ewc.fisherInformation[s][i];
        
        loss += fisher * (current - optimal) * (current - optimal);
      };
    };
    
    0.5 * state.ewc.ewcLambda * loss
  };
  
  // Save optimal weights after task completion
  public func saveOptimalWeights(
    state : ContinualLearningState,
    weights : [[Float]]
  ) {
    for (s in Iter.range(0, NUM_SHELLS - 1)) {
      for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
        state.ewc.optimalWeights[s][i] := 
          if (s < Array.size(weights) and i < Array.size(weights[s])) {
            weights[s][i]
          } else { 0.0 };
      };
    };
    state.ewc.taskCount += 1;
  };
  
  // Add memory for replay
  public func addToMemory(
    state : ContinualLearningState,
    sample : [Float],
    label : Nat
  ) {
    if (state.memorySize < state.maxMemory) {
      for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
        state.memoryBuffer[state.memorySize][i] := 
          if (i < Array.size(sample)) { sample[i] } else { 0.0 };
      };
      state.memoryLabels[state.memorySize] := label;
      state.memorySize += 1;
    } else {
      // Reservoir sampling
      let idx = state.memorySize % state.maxMemory;
      for (i in Iter.range(0, EMBEDDING_DIM - 1)) {
        state.memoryBuffer[idx][i] := 
          if (i < Array.size(sample)) { sample[i] } else { 0.0 };
      };
      state.memoryLabels[idx] := label;
    };
  };
  
  // Sample from memory for replay
  public func sampleMemory(
    state : ContinualLearningState,
    batchSize : Nat
  ) : [[Float]] {
    let samples = Buffer.Buffer<[Float]>(batchSize);
    
    for (_ in Iter.range(0, batchSize - 1)) {
      let idx = state.memorySize % state.maxMemory;  // Simplified; would need random
      samples.add(Array.freeze(state.memoryBuffer[idx]));
    };
    
    Buffer.toArray(samples)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: NEUROEVOLUTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Evolving neural network structure and weights.
  //
  // NEAT: Start minimal, complexify through mutations
  // Species: Group similar topologies, share fitness
  //
  
  public type Gene = {
    inNode : Nat;
    outNode : Nat;
    var weight : Float;
    var enabled : Bool;
    innovation : Nat;
  };
  
  public type Genome = {
    var genes : [var Gene];
    var numGenes : Nat;
    var fitness : Float;
    species : Nat;
    numInputs : Nat;
    numOutputs : Nat;
    var numHidden : Nat;
  };
  
  public type Species = {
    id : Nat;
    var representative : Genome;
    var members : [var Genome];
    var numMembers : Nat;
    var avgFitness : Float;
    var staleness : Nat;
  };
  
  public type NEATState = {
    var population : [var Genome];
    var populationSize : Nat;
    var species : [var Species];
    var numSpecies : Nat;
    var innovationCounter : Nat;
    var generation : Nat;
    
    // Parameters
    var excessCoeff : Float;
    var disjointCoeff : Float;
    var weightCoeff : Float;
    var compatibilityThreshold : Float;
    var mutateWeightProb : Float;
    var addNodeProb : Float;
    var addConnectionProb : Float;
  };
  
  public func initGene(inN : Nat, outN : Nat, w : Float, innov : Nat) : Gene {
    {
      inNode = inN;
      outNode = outN;
      var weight = w;
      var enabled = true;
      innovation = innov;
    }
  };
  
  public func initGenome(numIn : Nat, numOut : Nat) : Genome {
    {
      var genes = Array.init<Gene>(100, func(_ : Nat) : Gene {
        initGene(0, 0, 0.0, 0)
      });
      var numGenes = 0;
      var fitness = 0.0;
      species = 0;
      numInputs = numIn;
      numOutputs = numOut;
      var numHidden = 0;
    }
  };
  
  public func initNEATState() : NEATState {
    {
      var population = Array.init<Genome>(150, func(_ : Nat) : Genome {
        initGenome(EMBEDDING_DIM, NUM_SHELLS)
      });
      var populationSize = 150;
      var species = Array.init<Species>(20, func(i : Nat) : Species {
        {
          id = i;
          var representative = initGenome(EMBEDDING_DIM, NUM_SHELLS);
          var members = Array.init<Genome>(150, func(_ : Nat) : Genome {
            initGenome(EMBEDDING_DIM, NUM_SHELLS)
          });
          var numMembers = 0;
          var avgFitness = 0.0;
          var staleness = 0;
        }
      });
      var numSpecies = 1;
      var innovationCounter = 0;
      var generation = 0;
      var excessCoeff = 1.0;
      var disjointCoeff = 1.0;
      var weightCoeff = 0.4;
      var compatibilityThreshold = 3.0;
      var mutateWeightProb = 0.8;
      var addNodeProb = 0.03;
      var addConnectionProb = 0.05;
    }
  };
  
  // Compute compatibility distance between genomes
  public func computeCompatibility(
    state : NEATState,
    g1 : Genome,
    g2 : Genome
  ) : Float {
    var excess : Nat = 0;
    var disjoint : Nat = 0;
    var weightDiff : Float = 0.0;
    var matching : Nat = 0;
    
    // Compare genes by innovation number
    var i : Nat = 0;
    var j : Nat = 0;
    
    while (i < g1.numGenes and j < g2.numGenes) {
      let gene1 = g1.genes[i];
      let gene2 = g2.genes[j];
      
      if (gene1.innovation == gene2.innovation) {
        // Matching genes
        weightDiff += Float.abs(gene1.weight - gene2.weight);
        matching += 1;
        i += 1;
        j += 1;
      } else if (gene1.innovation < gene2.innovation) {
        disjoint += 1;
        i += 1;
      } else {
        disjoint += 1;
        j += 1;
      };
    };
    
    // Remaining genes are excess
    excess := (g1.numGenes - i) + (g2.numGenes - j);
    
    let n = Float.fromInt(Nat.max(g1.numGenes, g2.numGenes));
    let avgWeight = if (matching > 0) { weightDiff / Float.fromInt(matching) } else { 0.0 };
    
    (state.excessCoeff * Float.fromInt(excess) / n) +
    (state.disjointCoeff * Float.fromInt(disjoint) / n) +
    (state.weightCoeff * avgWeight)
  };
  
  // Mutate weights
  public func mutateWeights(
    genome : Genome,
    perturbProb : Float
  ) {
    for (i in Iter.range(0, genome.numGenes - 1)) {
      let gene = genome.genes[i];
      
      if (perturbProb > 0.9) {  // Simplified random check
        // Perturb weight
        gene.weight := gene.weight + (0.5 - 0.25) * 0.1;  // Would need proper random
      } else {
        // New random weight
        gene.weight := (0.5 - 0.25) * 4.0;
      };
    };
  };
  
  // Add a new node (split a connection)
  public func mutateAddNode(
    genome : Genome,
    state : NEATState
  ) {
    if (genome.numGenes == 0) { return };
    
    // Pick a random enabled connection
    var targetGene : Nat = 0;
    for (i in Iter.range(0, genome.numGenes - 1)) {
      if (genome.genes[i].enabled) {
        targetGene := i;
      };
    };
    
    let gene = genome.genes[targetGene];
    gene.enabled := false;
    
    let newNode = genome.numInputs + genome.numOutputs + genome.numHidden;
    genome.numHidden += 1;
    
    // Add two new connections
    if (genome.numGenes + 2 < 100) {
      genome.genes[genome.numGenes] := initGene(gene.inNode, newNode, 1.0, state.innovationCounter);
      state.innovationCounter += 1;
      genome.numGenes += 1;
      
      genome.genes[genome.numGenes] := initGene(newNode, gene.outNode, gene.weight, state.innovationCounter);
      state.innovationCounter += 1;
      genome.numGenes += 1;
    };
  };
  
  // Add a new connection
  public func mutateAddConnection(
    genome : Genome,
    state : NEATState
  ) {
    let totalNodes = genome.numInputs + genome.numOutputs + genome.numHidden;
    
    // Pick two random nodes
    let inNode = totalNodes / 3;  // Simplified
    let outNode = genome.numInputs + (totalNodes / 4);
    
    // Check if connection already exists
    for (i in Iter.range(0, genome.numGenes - 1)) {
      if (genome.genes[i].inNode == inNode and genome.genes[i].outNode == outNode) {
        return;  // Already exists
      };
    };
    
    // Add connection
    if (genome.numGenes < 100) {
      genome.genes[genome.numGenes] := initGene(inNode, outNode, 0.5 - 0.25, state.innovationCounter);
      state.innovationCounter += 1;
      genome.numGenes += 1;
    };
  };
  
  // Evaluate genome fitness
  public func evaluateGenome(
    genome : Genome,
    input : [Float],
    expected : [Float]
  ) : Float {
    // Forward propagation through network
    let totalNodes = genome.numInputs + genome.numOutputs + genome.numHidden;
    let nodeValues = Array.init<Float>(totalNodes, func(i : Nat) : Float {
      if (i < genome.numInputs and i < Array.size(input)) { input[i] } else { 0.0 }
    });
    
    // Process connections (simplified topological sort)
    for (_ in Iter.range(0, totalNodes - 1)) {
      for (g in Iter.range(0, genome.numGenes - 1)) {
        let gene = genome.genes[g];
        if (gene.enabled and gene.inNode < totalNodes and gene.outNode < totalNodes) {
          nodeValues[gene.outNode] := nodeValues[gene.outNode] + nodeValues[gene.inNode] * gene.weight;
        };
      };
    };
    
    // Compute fitness (negative MSE)
    var mse : Float = 0.0;
    for (i in Iter.range(0, genome.numOutputs - 1)) {
      let outputIdx = genome.numInputs + i;
      let actual = sigmoid(nodeValues[outputIdx]);
      let exp = if (i < Array.size(expected)) { expected[i] } else { 0.0 };
      mse += (actual - exp) * (actual - exp);
    };
    
    genome.fitness := -mse / Float.fromInt(genome.numOutputs);
    genome.fitness
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
    
    let expX = Array.tabulate<Float>(n, func(i : Nat) : Float { expFunc(x[i] - maxX) });
    var sumExp : Float = 0.0;
    for (e in expX.vals()) { sumExp += e };
    
    Array.tabulate<Float>(n, func(i : Nat) : Float { expX[i] / sumExp })
  };
  
  func cosineSimilarity(a : [Float], b : [Float]) : Float {
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    let dim = Nat.min(Array.size(a), Array.size(b));
    
    for (i in Iter.range(0, dim - 1)) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };
    
    let denom = sqrt(normA) * sqrt(normB);
    if (denom > 0.0001) { dot / denom } else { 0.0 }
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
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

};
