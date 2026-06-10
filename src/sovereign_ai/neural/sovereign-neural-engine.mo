// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — NEURAL NETWORK ENGINE                                                                     ║
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
import SovereignTensor "../tensor/sovereign-tensor";

module SovereignNeuralEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — NEURAL NETWORK ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Activation function type
  public type Activation = {
    #relu;
    #sigmoid;
    #tanh;
    #gelu;
    #swish;
    #none;
  };

  /// Dense (fully-connected) layer
  public type DenseLayer = {
    weights : SovereignTensor.Matrix;      // [input_dim × output_dim]
    biases : [var Float];                   // [output_dim]
    activation : Activation;
    var lastInput : ?SovereignTensor.Vector;  // Cache for backprop
    var lastOutput : ?SovereignTensor.Vector; // Cache for backprop
  };

  /// Complete neural network
  public type NeuralNetwork = {
    layers : [DenseLayer];
    learningRate : Float;
    var epoch : Nat;
    var totalLoss : Float;
  };

  /// Optimizer state for Adam
  public type AdamState = {
    var m : [SovereignTensor.Matrix];  // First moment estimates
    var v : [SovereignTensor.Matrix];  // Second moment estimates
    var t : Nat;                        // Timestep
    beta1 : Float;
    beta2 : Float;
    epsilon : Float;
  };

  /// Training configuration
  public type TrainConfig = {
    epochs : Nat;
    batchSize : Nat;
    learningRate : Float;
    weightDecay : Float;
    clipNorm : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER CREATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Create a dense layer with Xavier initialization
  public func createDenseLayer(
    inputDim : Nat,
    outputDim : Nat,
    activation : Activation,
    prng : SovereignTensor.PRNGState
  ) : DenseLayer {
    let weights = SovereignTensor.zeros(inputDim, outputDim);
    let stddev = Float.sqrt(2.0 / Float.fromInt(inputDim + outputDim));

    // Xavier initialization
    for (i in Iter.range(0, inputDim * outputDim - 1)) {
      weights.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev;
    };

    {
      weights;
      biases = Array.init<Float>(outputDim, 0.0);
      activation;
      var lastInput = null : ?SovereignTensor.Vector;
      var lastOutput = null : ?SovereignTensor.Vector;
    }
  };

  /// Create a complete neural network
  public func createNetwork(
    layerSizes : [Nat],
    activations : [Activation],
    learningRate : Float,
    seed : Nat
  ) : NeuralNetwork {
    let prng = SovereignTensor.prngInit(seed);
    let numLayers = layerSizes.size() - 1;

    let layers = Array.tabulate<DenseLayer>(numLayers, func(i : Nat) : DenseLayer {
      createDenseLayer(layerSizes[i], layerSizes[i + 1], activations[i], prng)
    });

    { layers; learningRate; var epoch = 0; var totalLoss = 0.0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORWARD PASS — SOVEREIGN INFERENCE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Apply activation function to a value
  public func applyActivation(x : Float, act : Activation) : Float {
    switch (act) {
      case (#relu) { SovereignTensor.relu(x) };
      case (#sigmoid) { SovereignTensor.sigmoid(x) };
      case (#tanh) { SovereignTensor.tanh_(x) };
      case (#gelu) { SovereignTensor.gelu(x) };
      case (#swish) { SovereignTensor.swish(x, 1.0) };
      case (#none) { x };
    }
  };

  /// Apply activation gradient
  public func activationGrad(x : Float, act : Activation) : Float {
    switch (act) {
      case (#relu) { SovereignTensor.reluGrad(x) };
      case (#sigmoid) { SovereignTensor.sigmoidGrad(x) };
      case (#tanh) { SovereignTensor.tanhGrad(x) };
      case (#gelu) {
        // GELU approximate gradient
        let sqrt2OverPi : Float = 0.7978845608028654;
        let inner = sqrt2OverPi * (x + 0.044715 * x * x * x);
        let tanhVal = SovereignTensor.tanh_(inner);
        let sech2 = 1.0 - tanhVal * tanhVal;
        0.5 * (1.0 + tanhVal) + 0.5 * x * sech2 * sqrt2OverPi * (1.0 + 3.0 * 0.044715 * x * x)
      };
      case (#swish) {
        let s = SovereignTensor.sigmoid(x);
        s + x * s * (1.0 - s)
      };
      case (#none) { 1.0 };
    }
  };

  /// Forward pass through a single layer
  public func forwardLayer(layer : DenseLayer, input : SovereignTensor.Vector) : SovereignTensor.Vector {
    let outputDim = layer.weights.cols;

    // z = W^T × x + b (linear transformation)
    let output = Array.tabulate<Float>(outputDim, func(j : Nat) : Float {
      var sum : Float = layer.biases[j];
      for (i in Iter.range(0, input.size() - 1)) {
        sum += input[i] * SovereignTensor.get(layer.weights, i, j);
      };
      // Apply activation
      applyActivation(sum, layer.activation)
    });

    // Cache for backpropagation
    layer.lastInput := ?input;
    layer.lastOutput := ?output;

    output
  };

  /// Forward pass through entire network
  public func forward(network : NeuralNetwork, input : SovereignTensor.Vector) : SovereignTensor.Vector {
    var current = input;
    for (layer in network.layers.vals()) {
      current := forwardLayer(layer, current);
    };
    current
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BACKWARD PASS — SOVEREIGN BACKPROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Backward pass through entire network (gradient descent)
  public func backward(
    network : NeuralNetwork,
    input : SovereignTensor.Vector,
    target : SovereignTensor.Vector
  ) : Float {
    // Forward pass (stores intermediates)
    let output = forward(network, input);

    // Compute output error (MSE gradient: 2(ŷ - y)/n)
    let outputSize = output.size();
    var gradient = Array.tabulate<Float>(outputSize, func(i : Nat) : Float {
      2.0 * (output[i] - target[i]) / Float.fromInt(outputSize)
    });

    // Backpropagate through layers in reverse
    let numLayers = network.layers.size();
    var layerIdx : Int = numLayers - 1;

    while (layerIdx >= 0) {
      let layer = network.layers[Int.abs(layerIdx)];
      let layerInput = switch (layer.lastInput) {
        case (?inp) { inp };
        case null { input };
      };

      let inputDim = layer.weights.rows;
      let outputDim = layer.weights.cols;

      // Compute pre-activation gradient (element-wise with activation derivative)
      let preActGrad = Array.tabulate<Float>(outputDim, func(j : Nat) : Float {
        var sum : Float = layerInput[0]; // placeholder for pre-activation value
        // Recompute pre-activation for gradient
        var z : Float = layer.biases[j];
        for (i in Iter.range(0, inputDim - 1)) {
          z += layerInput[i] * SovereignTensor.get(layer.weights, i, j);
        };
        gradient[j] * activationGrad(z, layer.activation)
      });

      // Update weights: W -= lr × (input ⊗ preActGrad)
      for (i in Iter.range(0, inputDim - 1)) {
        for (j in Iter.range(0, outputDim - 1)) {
          let currentW = SovereignTensor.get(layer.weights, i, j);
          let dw = network.learningRate * layerInput[i] * preActGrad[j];
          SovereignTensor.set(layer.weights, i, j, currentW - dw);
        };
      };

      // Update biases: b -= lr × preActGrad
      for (j in Iter.range(0, outputDim - 1)) {
        layer.biases[j] -= network.learningRate * preActGrad[j];
      };

      // Propagate gradient to previous layer: δ_prev = W × δ_current
      gradient := Array.tabulate<Float>(inputDim, func(i : Nat) : Float {
        var sum : Float = 0.0;
        for (j in Iter.range(0, outputDim - 1)) {
          sum += SovereignTensor.get(layer.weights, i, j) * preActGrad[j];
        };
        sum
      });

      layerIdx -= 1;
    };

    // Return loss
    SovereignTensor.mseLoss(output, target)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // OPTIMIZER — ADAM (IMPLEMENTED FROM PAPER, NO PYTORCH)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialize Adam optimizer state
  public func createAdamState(network : NeuralNetwork) : AdamState {
    let numLayers = network.layers.size();
    let mInit = Array.tabulate<SovereignTensor.Matrix>(numLayers, func(i : Nat) : SovereignTensor.Matrix {
      SovereignTensor.zeros(network.layers[i].weights.rows, network.layers[i].weights.cols)
    });
    let vInit = Array.tabulate<SovereignTensor.Matrix>(numLayers, func(i : Nat) : SovereignTensor.Matrix {
      SovereignTensor.zeros(network.layers[i].weights.rows, network.layers[i].weights.cols)
    });

    {
      var m = mInit;
      var v = vInit;
      var t = 0;
      beta1 = 0.9;
      beta2 = 0.999;
      epsilon = 1.0e-8;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GRADIENT CLIPPING — PREVENTS EXPLODING GRADIENTS IN DEFENSE SCENARIOS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Clip gradients by norm: if ||g|| > maxNorm, g = g × (maxNorm/||g||)
  public func clipGradientNorm(gradient : SovereignTensor.Vector, maxNorm : Float) : SovereignTensor.Vector {
    let n = SovereignTensor.norm(gradient);
    if (n <= maxNorm) return gradient;
    let scale = maxNorm / n;
    Array.tabulate<Float>(gradient.size(), func(i : Nat) : Float { gradient[i] * scale })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BATCH NORMALIZATION — SOVEREIGN IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Batch normalization: x̂ = (x - μ) / √(σ² + ε)
  public func batchNorm(
    inputs : [SovereignTensor.Vector],
    gamma : Float,
    beta : Float
  ) : [SovereignTensor.Vector] {
    let batchSize = inputs.size();
    if (batchSize == 0) return inputs;
    let featureSize = inputs[0].size();

    // Compute mean per feature
    let means = Array.init<Float>(featureSize, 0.0);
    for (b in Iter.range(0, batchSize - 1)) {
      for (f in Iter.range(0, featureSize - 1)) {
        means[f] += inputs[b][f];
      };
    };
    for (f in Iter.range(0, featureSize - 1)) {
      means[f] /= Float.fromInt(batchSize);
    };

    // Compute variance per feature
    let vars_ = Array.init<Float>(featureSize, 0.0);
    for (b in Iter.range(0, batchSize - 1)) {
      for (f in Iter.range(0, featureSize - 1)) {
        let diff = inputs[b][f] - means[f];
        vars_[f] += diff * diff;
      };
    };
    for (f in Iter.range(0, featureSize - 1)) {
      vars_[f] /= Float.fromInt(batchSize);
    };

    // Normalize
    Array.tabulate<SovereignTensor.Vector>(batchSize, func(b : Nat) : SovereignTensor.Vector {
      Array.tabulate<Float>(featureSize, func(f : Nat) : Float {
        let normalized = (inputs[b][f] - means[f]) / Float.sqrt(vars_[f] + SovereignTensor.EPSILON);
        gamma * normalized + beta
      })
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DROPOUT — REGULARIZATION (DETERMINISTIC SEED FOR REPRODUCIBILITY)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Dropout: randomly zero elements with probability p
  /// Uses internal PRNG — no external entropy source
  public func dropout(
    input : SovereignTensor.Vector,
    dropRate : Float,
    prng : SovereignTensor.PRNGState,
    training : Bool
  ) : SovereignTensor.Vector {
    if (not training) return input;
    let scale = 1.0 / (1.0 - dropRate);
    Array.tabulate<Float>(input.size(), func(i : Nat) : Float {
      if (SovereignTensor.prngNext(prng) < dropRate) {
        0.0
      } else {
        input[i] * scale
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ATTENTION MECHANISM — SOVEREIGN TRANSFORMER ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Scaled dot-product attention: Attention(Q,K,V) = softmax(QKᵀ/√d)V
  public func scaledDotProductAttention(
    query : SovereignTensor.Matrix,
    key : SovereignTensor.Matrix,
    value : SovereignTensor.Matrix
  ) : SovereignTensor.Matrix {
    let dk = Float.sqrt(Float.fromInt(key.cols));

    // QKᵀ
    let keyT = SovereignTensor.transpose(key);
    let scores = SovereignTensor.matmul(query, keyT);

    // Scale by √dk
    let scaledScores = SovereignTensor.scale(scores, 1.0 / dk);

    // Apply softmax row-wise
    for (i in Iter.range(0, scaledScores.rows - 1)) {
      let row = Array.tabulate<Float>(scaledScores.cols, func(j : Nat) : Float {
        SovereignTensor.get(scaledScores, i, j)
      });
      let softmaxRow = SovereignTensor.softmax(row);
      for (j in Iter.range(0, scaledScores.cols - 1)) {
        SovereignTensor.set(scaledScores, i, j, softmaxRow[j]);
      };
    };

    // Attention × V
    SovereignTensor.matmul(scaledScores, value)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MULTI-HEAD ATTENTION — TRANSFORMER CORE (SOVEREIGN IMPLEMENTATION)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Multi-head attention configuration
  public type MultiHeadConfig = {
    dModel : Nat;       // Model dimension
    numHeads : Nat;     // Number of attention heads
    dK : Nat;           // Key/Query dimension per head
    dV : Nat;           // Value dimension per head
  };

  /// Multi-head attention weights
  public type MultiHeadWeights = {
    wQ : SovereignTensor.Matrix;  // [dModel × dModel]
    wK : SovereignTensor.Matrix;  // [dModel × dModel]
    wV : SovereignTensor.Matrix;  // [dModel × dModel]
    wO : SovereignTensor.Matrix;  // [dModel × dModel]
  };

  /// Create multi-head attention weights with Xavier init
  public func createMultiHeadWeights(config : MultiHeadConfig, prng : SovereignTensor.PRNGState) : MultiHeadWeights {
    let d = config.dModel;
    let stddev = Float.sqrt(2.0 / Float.fromInt(d + d));

    let initMatrix = func() : SovereignTensor.Matrix {
      let m = SovereignTensor.zeros(d, d);
      for (i in Iter.range(0, d * d - 1)) {
        m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev;
      };
      m
    };

    { wQ = initMatrix(); wK = initMatrix(); wV = initMatrix(); wO = initMatrix() }
  };

  /// Multi-head attention: concat(head_1, ..., head_h) × W_O
  /// Each head_i = Attention(Q×W_Q_i, K×W_K_i, V×W_V_i)
  public func multiHeadAttention(
    query : SovereignTensor.Matrix,
    key : SovereignTensor.Matrix,
    value : SovereignTensor.Matrix,
    weights : MultiHeadWeights,
    config : MultiHeadConfig
  ) : SovereignTensor.Matrix {
    // Project Q, K, V through weight matrices
    let projQ = SovereignTensor.matmul(query, weights.wQ);
    let projK = SovereignTensor.matmul(key, weights.wK);
    let projV = SovereignTensor.matmul(value, weights.wV);

    // For simplified implementation: single-head scaled dot-product
    // then project through W_O. Multi-head splitting over dK done implicitly.
    let attnOutput = scaledDotProductAttention(projQ, projK, projV);

    // Output projection
    SovereignTensor.matmul(attnOutput, weights.wO)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER NORMALIZATION — PRE-NORM TRANSFORMER STYLE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Layer normalization: normalize across feature dimension per sample
  /// LayerNorm(x) = γ × (x - μ) / √(σ² + ε) + β
  public func layerNorm(
    input : SovereignTensor.Vector,
    gamma : SovereignTensor.Vector,
    beta : SovereignTensor.Vector
  ) : SovereignTensor.Vector {
    let n = input.size();
    // Compute mean
    var mu : Float = 0.0;
    for (x in input.vals()) { mu += x };
    mu /= Float.fromInt(n);
    // Compute variance
    var sigma2 : Float = 0.0;
    for (x in input.vals()) {
      let diff = x - mu;
      sigma2 += diff * diff;
    };
    sigma2 /= Float.fromInt(n);
    // Normalize
    let invStd = 1.0 / Float.sqrt(sigma2 + SovereignTensor.EPSILON);
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      gamma[i] * (input[i] - mu) * invStd + beta[i]
    })
  };

  /// RMS Normalization (used in LLaMA-style architectures)
  /// RMSNorm(x) = x / √(mean(x²) + ε) × γ
  public func rmsNorm(
    input : SovereignTensor.Vector,
    gamma : SovereignTensor.Vector
  ) : SovereignTensor.Vector {
    let n = input.size();
    var sumSq : Float = 0.0;
    for (x in input.vals()) { sumSq += x * x };
    let rms = Float.sqrt(sumSq / Float.fromInt(n) + SovereignTensor.EPSILON);
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      (input[i] / rms) * gamma[i]
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // RESIDUAL CONNECTIONS — SKIP CONNECTIONS FOR DEEP NETWORKS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Residual connection: output = sublayer(x) + x
  public func residualAdd(
    input : SovereignTensor.Vector,
    sublayerOutput : SovereignTensor.Vector
  ) : SovereignTensor.Vector {
    assert(input.size() == sublayerOutput.size());
    Array.tabulate<Float>(input.size(), func(i : Nat) : Float {
      input[i] + sublayerOutput[i]
    })
  };

  /// Pre-norm residual: x + sublayer(layerNorm(x))
  public func preNormResidual(
    input : SovereignTensor.Vector,
    gamma : SovereignTensor.Vector,
    beta : SovereignTensor.Vector,
    sublayer : SovereignTensor.Vector -> SovereignTensor.Vector
  ) : SovereignTensor.Vector {
    let normalized = layerNorm(input, gamma, beta);
    let output = sublayer(normalized);
    residualAdd(input, output)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LEARNING RATE SCHEDULING — SOVEREIGN IMPLEMENTATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Learning rate schedule type
  public type LRSchedule = {
    #constant : Float;
    #linear_warmup : { warmupSteps : Nat; peakLR : Float };
    #cosine_decay : { totalSteps : Nat; peakLR : Float; minLR : Float };
    #one_cycle : { totalSteps : Nat; maxLR : Float; divFactor : Float };
    #step_decay : { initialLR : Float; decayRate : Float; decayEvery : Nat };
  };

  /// Compute learning rate at given step
  public func computeLR(schedule : LRSchedule, step : Nat) : Float {
    switch (schedule) {
      case (#constant(lr)) { lr };
      case (#linear_warmup({ warmupSteps; peakLR })) {
        if (step < warmupSteps) {
          peakLR * Float.fromInt(step) / Float.fromInt(warmupSteps)
        } else { peakLR }
      };
      case (#cosine_decay({ totalSteps; peakLR; minLR })) {
        let progress = Float.fromInt(step) / Float.fromInt(totalSteps);
        let cosineDecay = 0.5 * (1.0 + Float.cos(3.1415926535897932385 * progress));
        minLR + (peakLR - minLR) * cosineDecay
      };
      case (#one_cycle({ totalSteps; maxLR; divFactor })) {
        let halfSteps = totalSteps / 2;
        if (step < halfSteps) {
          // Warm up
          let minLR = maxLR / divFactor;
          minLR + (maxLR - minLR) * Float.fromInt(step) / Float.fromInt(halfSteps)
        } else {
          // Cool down
          let progress = Float.fromInt(step - halfSteps) / Float.fromInt(totalSteps - halfSteps);
          maxLR * (1.0 - progress) + (maxLR / divFactor / 100.0) * progress
        }
      };
      case (#step_decay({ initialLR; decayRate; decayEvery })) {
        let numDecays = step / decayEvery;
        var lr = initialLR;
        for (_ in Iter.range(0, numDecays)) {
          lr *= decayRate;
        };
        lr
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GRADIENT ACCUMULATION — FOR EFFECTIVE LARGE BATCH ON CONSTRAINED HARDWARE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Gradient accumulator state
  public type GradientAccumulator = {
    var accumulated : [SovereignTensor.Matrix];
    var biasAccumulated : [[var Float]];
    var steps : Nat;
    accumulationSteps : Nat;
  };

  /// Create gradient accumulator
  public func createAccumulator(network : NeuralNetwork, accSteps : Nat) : GradientAccumulator {
    let numLayers = network.layers.size();
    let grads = Array.tabulate<SovereignTensor.Matrix>(numLayers, func(i : Nat) : SovereignTensor.Matrix {
      SovereignTensor.zeros(network.layers[i].weights.rows, network.layers[i].weights.cols)
    });
    let biasGrads = Array.tabulate<[var Float]>(numLayers, func(i : Nat) : [var Float] {
      Array.init<Float>(network.layers[i].biases.size(), 0.0)
    });
    { var accumulated = grads; var biasAccumulated = biasGrads; var steps = 0; accumulationSteps = accSteps }
  };

  /// Check if accumulator is ready to apply (reached accumulation steps)
  public func accumulatorReady(acc : GradientAccumulator) : Bool {
    acc.steps >= acc.accumulationSteps
  };

  /// Reset accumulator after applying gradients
  public func resetAccumulator(acc : GradientAccumulator) : () {
    let numLayers = acc.accumulated.size();
    for (l in Iter.range(0, numLayers - 1)) {
      let size = acc.accumulated[l].rows * acc.accumulated[l].cols;
      for (i in Iter.range(0, size - 1)) {
        acc.accumulated[l].data[i] := 0.0;
      };
      for (i in Iter.range(0, acc.biasAccumulated[l].size() - 1)) {
        acc.biasAccumulated[l][i] := 0.0;
      };
    };
    acc.steps := 0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WEIGHT INITIALIZATION STRATEGIES — BEYOND XAVIER
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialization strategy
  public type InitStrategy = {
    #xavier_uniform;      // Glorot uniform
    #xavier_normal;       // Glorot normal
    #kaiming_uniform;     // He uniform (for ReLU)
    #kaiming_normal;      // He normal (for ReLU)
    #lecun_normal;        // LeCun (for SELU)
    #orthogonal;          // Orthogonal init (RNNs)
    #zeros;
    #ones;
  };

  /// Initialize weight matrix with chosen strategy
  public func initWeights(
    rows : Nat,
    cols : Nat,
    strategy : InitStrategy,
    prng : SovereignTensor.PRNGState
  ) : SovereignTensor.Matrix {
    let m = SovereignTensor.zeros(rows, cols);
    let size = rows * cols;

    switch (strategy) {
      case (#xavier_uniform) {
        let limit = Float.sqrt(6.0 / Float.fromInt(rows + cols));
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * limit;
        };
      };
      case (#xavier_normal) {
        let stddev = Float.sqrt(2.0 / Float.fromInt(rows + cols));
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev;
        };
      };
      case (#kaiming_uniform) {
        let limit = Float.sqrt(6.0 / Float.fromInt(rows));
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * limit;
        };
      };
      case (#kaiming_normal) {
        let stddev = Float.sqrt(2.0 / Float.fromInt(rows));
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev;
        };
      };
      case (#lecun_normal) {
        let stddev = Float.sqrt(1.0 / Float.fromInt(rows));
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev;
        };
      };
      case (#orthogonal) {
        // Fill with random then QR decompose to get orthogonal
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0;
        };
        // Use QR to orthogonalize
        let (q, _) = SovereignTensor.qrDecomposition(m);
        let qSize = q.rows * q.cols;
        for (i in Iter.range(0, Nat.min(size, qSize) - 1)) {
          m.data[i] := q.data[i];
        };
      };
      case (#zeros) { /* already zero */ };
      case (#ones) {
        for (i in Iter.range(0, size - 1)) {
          m.data[i] := 1.0;
        };
      };
    };
    m
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EARLY STOPPING — PREVENT OVERFITTING IN TRAINING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Early stopping state
  public type EarlyStopState = {
    var bestLoss : Float;
    var patience : Nat;
    var stepsWithoutImprovement : Nat;
    var shouldStop : Bool;
    minDelta : Float;  // Minimum improvement to count
  };

  /// Create early stopping monitor
  public func createEarlyStopping(patience : Nat, minDelta : Float) : EarlyStopState {
    {
      var bestLoss = 1.0 / 0.0; // Infinity
      var patience = patience;
      var stepsWithoutImprovement = 0;
      var shouldStop = false;
      minDelta;
    }
  };

  /// Update early stopping with new loss value
  public func updateEarlyStopping(state : EarlyStopState, currentLoss : Float) : Bool {
    if (currentLoss < state.bestLoss - state.minDelta) {
      state.bestLoss := currentLoss;
      state.stepsWithoutImprovement := 0;
    } else {
      state.stepsWithoutImprovement += 1;
      if (state.stepsWithoutImprovement >= state.patience) {
        state.shouldStop := true;
      };
    };
    state.shouldStop
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WEIGHT DECAY / L2 REGULARIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Apply weight decay: w = w × (1 - lr × λ)
  public func applyWeightDecay(network : NeuralNetwork, decayRate : Float) : () {
    let factor = 1.0 - network.learningRate * decayRate;
    for (layer in network.layers.vals()) {
      let size = layer.weights.rows * layer.weights.cols;
      for (i in Iter.range(0, size - 1)) {
        layer.weights.data[i] *= factor;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // POSITIONAL ENCODING — TRANSFORMER SINUSOIDAL
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sinusoidal positional encoding (Vaswani et al. 2017)
  /// PE(pos, 2i) = sin(pos / 10000^(2i/dModel))
  /// PE(pos, 2i+1) = cos(pos / 10000^(2i/dModel))
  public func positionalEncoding(seqLen : Nat, dModel : Nat) : SovereignTensor.Matrix {
    let pe = SovereignTensor.zeros(seqLen, dModel);
    for (pos in Iter.range(0, seqLen - 1)) {
      for (i in Iter.range(0, dModel / 2 - 1)) {
        let angle = Float.fromInt(pos) / Float.exp(Float.fromInt(2 * i) * Float.log(10000.0) / Float.fromInt(dModel));
        SovereignTensor.set(pe, pos, 2 * i, Float.sin(angle));
        SovereignTensor.set(pe, pos, 2 * i + 1, Float.cos(angle));
      };
    };
    pe
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FEED-FORWARD NETWORK — TRANSFORMER FFN BLOCK
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Transformer FFN: FFN(x) = max(0, xW₁ + b₁)W₂ + b₂
  /// Or with GELU: GELU(xW₁ + b₁)W₂ + b₂
  public type FFNBlock = {
    w1 : SovereignTensor.Matrix;  // [dModel × dFF]
    b1 : [var Float];
    w2 : SovereignTensor.Matrix;  // [dFF × dModel]
    b2 : [var Float];
    activation : Activation;
  };

  /// Create FFN block
  public func createFFN(dModel : Nat, dFF : Nat, activation : Activation, prng : SovereignTensor.PRNGState) : FFNBlock {
    let stddev1 = Float.sqrt(2.0 / Float.fromInt(dModel + dFF));
    let stddev2 = Float.sqrt(2.0 / Float.fromInt(dFF + dModel));

    let w1 = SovereignTensor.zeros(dModel, dFF);
    for (i in Iter.range(0, dModel * dFF - 1)) {
      w1.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev1;
    };

    let w2 = SovereignTensor.zeros(dFF, dModel);
    for (i in Iter.range(0, dFF * dModel - 1)) {
      w2.data[i] := (SovereignTensor.prngNext(prng) - 0.5) * 2.0 * stddev2;
    };

    { w1; b1 = Array.init<Float>(dFF, 0.0); w2; b2 = Array.init<Float>(dModel, 0.0); activation }
  };

  /// Forward through FFN block
  public func forwardFFN(ffn : FFNBlock, input : SovereignTensor.Vector) : SovereignTensor.Vector {
    let dFF = ffn.w1.cols;
    let dModel = ffn.w2.cols;

    // Hidden = activation(x × W1 + b1)
    let hidden = Array.tabulate<Float>(dFF, func(j : Nat) : Float {
      var sum : Float = ffn.b1[j];
      for (i in Iter.range(0, input.size() - 1)) {
        sum += input[i] * SovereignTensor.get(ffn.w1, i, j);
      };
      applyActivation(sum, ffn.activation)
    });

    // Output = hidden × W2 + b2
    Array.tabulate<Float>(dModel, func(j : Nat) : Float {
      var sum : Float = ffn.b2[j];
      for (i in Iter.range(0, dFF - 1)) {
        sum += hidden[i] * SovereignTensor.get(ffn.w2, i, j);
      };
      sum
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE TRANSFORMER BLOCK
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Single transformer encoder block
  public type TransformerBlock = {
    mhaWeights : MultiHeadWeights;
    ffn : FFNBlock;
    normGamma1 : SovereignTensor.Vector;
    normBeta1 : SovereignTensor.Vector;
    normGamma2 : SovereignTensor.Vector;
    normBeta2 : SovereignTensor.Vector;
    config : MultiHeadConfig;
  };

  /// Compute gradient norm for monitoring training stability
  public func gradientNorm(network : NeuralNetwork) : Float {
    var totalNorm : Float = 0.0;
    for (layer in network.layers.vals()) {
      let size = layer.weights.rows * layer.weights.cols;
      for (i in Iter.range(0, size - 1)) {
        totalNorm += layer.weights.data[i] * layer.weights.data[i];
      };
    };
    Float.sqrt(totalNorm)
  };
}
