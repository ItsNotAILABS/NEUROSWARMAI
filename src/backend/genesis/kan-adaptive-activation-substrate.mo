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
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// KAN ADAPTIVE ACTIVATION SUBSTRATE — KOLMOGOROV-ARNOLD NETWORK LEARNABLE ACTIVATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements Kolmogorov-Arnold Networks (KAN) with learnable activation functions on edges
// rather than fixed activations on nodes. This allows the organism to adapt its own activation functions
// during learning, providing unprecedented flexibility in function approximation.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// Kolmogorov-Arnold Representation Theorem:
//   Any continuous multivariate function f(x₁,...,xₙ) can be represented as:
//   f(x) = Σᵢ Φᵢ(Σⱼ φᵢⱼ(xⱼ))
//
// KAN Edge Function (learnable):
//   φᵢⱼ(x) = Σₖ cᵢⱼₖ Bₖ(x)
//   where Bₖ are B-spline basis functions
//
// B-Spline Basis (degree d):
//   Bₖ,ₐ(x) = Cox-de Boor recursion:
//   Bₖ,₀(x) = 1 if tₖ ≤ x < tₖ₊₁, else 0
//   Bₖ,ₐ(x) = ((x-tₖ)/(tₖ₊ₐ-tₖ))Bₖ,ₐ₋₁(x) + ((tₖ₊ₐ₊₁-x)/(tₖ₊ₐ₊₁-tₖ₊₁))Bₖ₊₁,ₐ₋₁(x)
//
// Gradient for coefficient cᵢⱼₖ:
//   ∂L/∂cᵢⱼₖ = ∂L/∂φᵢⱼ × Bₖ(xⱼ)
//
// ADVANTAGES OVER MLPs:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Activation functions are learned, not fixed
// • Better interpretability (can extract symbolic formulas)
// • Faster convergence for smooth functions
// • Natural sparsity through edge pruning
// • Compositionality matches mathematical structure
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Replaces fixed activations in neural substrates
// • Each shell can have its own learned activation patterns
// • Activation functions can specialize by domain
// • Pruning enables sparse, efficient computation
// • Symbolic extraction for doctrine knowledge
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module KANAdaptiveActivationSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  public let PHI : Float = 1.61803398874989484820;
  public let SQRT_2 : Float = 1.41421356237309504880;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KAN CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Default B-spline degree
  public let DEFAULT_SPLINE_DEGREE : Nat = 3;  // Cubic splines
  
  /// Default number of control points (determines flexibility)
  public let DEFAULT_NUM_CONTROL_POINTS : Nat = 8;
  
  /// Default grid range for input normalization
  public let DEFAULT_GRID_MIN : Float = -1.0;
  public let DEFAULT_GRID_MAX : Float = 1.0;
  
  /// Learning rate for coefficient updates
  public let DEFAULT_LEARNING_RATE : Float = 0.01;
  
  /// Regularization strength (L2 on coefficients)
  public let DEFAULT_L2_REG : Float = 0.001;
  
  /// Pruning threshold (remove edges with small coefficients)
  public let PRUNING_THRESHOLD : Float = 0.01;
  
  /// Maximum layer width
  public let MAX_LAYER_WIDTH : Nat = 256;
  
  /// S₀ floor integration
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // B-SPLINE BASIS TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// B-spline configuration
  public type BSplineConfig = {
    degree : Nat;              // Spline degree (typically 3 for cubic)
    numControlPoints : Nat;    // Number of control points
    knots : [Float];           // Knot vector (size = numControlPoints + degree + 1)
    gridMin : Float;           // Input range minimum
    gridMax : Float;           // Input range maximum
  };
  
  /// Compute knot vector for uniform B-spline
  public func computeUniformKnots(
    degree : Nat,
    numControlPoints : Nat,
    gridMin : Float,
    gridMax : Float
  ) : [Float] {
    let numKnots = numControlPoints + degree + 1;
    let numInterior = numControlPoints - degree + 1;
    
    Array.tabulate<Float>(numKnots, func(i : Nat) : Float {
      if (i < degree) {
        gridMin
      } else if (i >= numKnots - degree) {
        gridMax
      } else {
        let interiorIdx = i - degree;
        gridMin + Float.fromInt(interiorIdx) * (gridMax - gridMin) / Float.fromInt(numInterior - 1)
      }
    })
  };
  
  /// Initialize B-spline configuration
  public func initBSplineConfig(
    degree : Nat,
    numControlPoints : Nat,
    gridMin : Float,
    gridMax : Float
  ) : BSplineConfig {
    {
      degree = degree;
      numControlPoints = numControlPoints;
      knots = computeUniformKnots(degree, numControlPoints, gridMin, gridMax);
      gridMin = gridMin;
      gridMax = gridMax;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // B-SPLINE EVALUATION — COX-DE BOOR RECURSION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Evaluate B-spline basis function Bₖ,ₐ(x) using Cox-de Boor recursion
  public func evaluateBSplineBasis(
    config : BSplineConfig,
    k : Nat,      // Basis function index
    x : Float     // Input value
  ) : Float {
    // Clamp x to grid range
    let xClamped = Float.max(config.gridMin, Float.min(config.gridMax, x));
    
    // Use iterative Cox-de Boor algorithm
    evaluateBSplineBasisRecursive(config.knots, k, config.degree, xClamped)
  };
  
  /// Recursive Cox-de Boor evaluation
  func evaluateBSplineBasisRecursive(
    knots : [Float],
    k : Nat,
    degree : Nat,
    x : Float
  ) : Float {
    if (degree == 0) {
      // Base case: degree 0
      if (k < knots.size() - 1) {
        if (x >= knots[k] and x < knots[k + 1]) {
          1.0
        } else if (k + 1 == knots.size() - 1 and x == knots[k + 1]) {
          // Handle right boundary
          1.0
        } else {
          0.0
        }
      } else {
        0.0
      }
    } else {
      // Recursive case
      var result : Float = 0.0;
      
      // First term: ((x - t_k) / (t_{k+d} - t_k)) * B_{k,d-1}(x)
      if (k + degree < knots.size()) {
        let denom1 = knots[k + degree] - knots[k];
        if (Float.abs(denom1) > 1e-10) {
          let coeff1 = (x - knots[k]) / denom1;
          let b1 = evaluateBSplineBasisRecursive(knots, k, degree - 1, x);
          result += coeff1 * b1;
        };
      };
      
      // Second term: ((t_{k+d+1} - x) / (t_{k+d+1} - t_{k+1})) * B_{k+1,d-1}(x)
      if (k + degree + 1 < knots.size() and k + 1 < knots.size()) {
        let denom2 = knots[k + degree + 1] - knots[k + 1];
        if (Float.abs(denom2) > 1e-10) {
          let coeff2 = (knots[k + degree + 1] - x) / denom2;
          let b2 = evaluateBSplineBasisRecursive(knots, k + 1, degree - 1, x);
          result += coeff2 * b2;
        };
      };
      
      result
    }
  };
  
  /// Evaluate all B-spline basis functions at x
  public func evaluateAllBSplineBasis(
    config : BSplineConfig,
    x : Float
  ) : [Float] {
    Array.tabulate<Float>(config.numControlPoints, func(k : Nat) : Float {
      evaluateBSplineBasis(config, k, x)
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KAN EDGE TYPE — LEARNABLE ACTIVATION FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A single KAN edge with learnable activation
  public type KANEdge = {
    sourceNode : Nat;
    targetNode : Nat;
    var coefficients : [var Float];  // cᵢⱼₖ for each control point
    splineConfig : BSplineConfig;
    var magnitude : Float;           // ||c|| for pruning decisions
    var gradient : [var Float];      // Accumulated gradient
    var isActive : Bool;             // Whether edge is pruned
    var lastUpdate : Int;
  };
  
  /// Create a new KAN edge with random initialization
  public func createKANEdge(
    source : Nat,
    target : Nat,
    config : BSplineConfig,
    initScale : Float,
    seed : Nat
  ) : KANEdge {
    let coeffs = Array.init<Float>(config.numControlPoints, func(i : Nat) : Float {
      // Initialize with small random values
      let pseudoRandom = Float.fromInt((seed * 1103515245 + i * 12345) % 1000) / 1000.0;
      (pseudoRandom - 0.5) * 2.0 * initScale
    });
    
    let grads = Array.init<Float>(config.numControlPoints, 0.0);
    
    {
      sourceNode = source;
      targetNode = target;
      var coefficients = coeffs;
      splineConfig = config;
      var magnitude = computeCoeffMagnitude(Array.freeze(coeffs));
      var gradient = grads;
      var isActive = true;
      var lastUpdate = 0;
    }
  };
  
  /// Compute coefficient magnitude ||c||
  func computeCoeffMagnitude(coeffs : [Float]) : Float {
    var sumSq : Float = 0.0;
    for (c in coeffs.vals()) {
      sumSq += c * c;
    };
    Float.sqrt(sumSq)
  };
  
  /// Evaluate KAN edge function: φᵢⱼ(x) = Σₖ cᵢⱼₖ Bₖ(x)
  public func evaluateKANEdge(edge : KANEdge, x : Float) : Float {
    if (not edge.isActive) { return 0.0 };
    
    let basis = evaluateAllBSplineBasis(edge.splineConfig, x);
    var result : Float = 0.0;
    
    for (k in Iter.range(0, edge.splineConfig.numControlPoints - 1)) {
      result += edge.coefficients[k] * basis[k];
    };
    
    result
  };
  
  /// Compute gradient of KAN edge w.r.t. coefficients
  /// ∂φ/∂cₖ = Bₖ(x)
  public func computeKANEdgeGradient(
    edge : KANEdge,
    x : Float,
    upstreamGradient : Float  // ∂L/∂φ
  ) : [Float] {
    if (not edge.isActive) {
      return Array.freeze(Array.init<Float>(edge.splineConfig.numControlPoints, 0.0));
    };
    
    let basis = evaluateAllBSplineBasis(edge.splineConfig, x);
    
    Array.tabulate<Float>(edge.splineConfig.numControlPoints, func(k : Nat) : Float {
      upstreamGradient * basis[k]
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KAN LAYER TYPE — COLLECTION OF EDGES BETWEEN LAYERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A single KAN layer (all edges from one layer to the next)
  public type KANLayer = {
    inputWidth : Nat;
    outputWidth : Nat;
    edges : [[var KANEdge]];      // edges[i][j] from input i to output j
    var activeEdgeCount : Nat;
    splineConfig : BSplineConfig;
    var lastForwardPass : Int;
  };
  
  /// Create a new KAN layer
  public func createKANLayer(
    inputWidth : Nat,
    outputWidth : Nat,
    config : BSplineConfig,
    initScale : Float,
    seed : Nat
  ) : KANLayer {
    let edges = Array.tabulate<[var KANEdge]>(inputWidth, func(i : Nat) : [var KANEdge] {
      Array.init<KANEdge>(outputWidth, func(j : Nat) : KANEdge {
        createKANEdge(i, j, config, initScale, seed + i * outputWidth + j)
      })
    });
    
    {
      inputWidth = inputWidth;
      outputWidth = outputWidth;
      edges = edges;
      var activeEdgeCount = inputWidth * outputWidth;
      splineConfig = config;
      var lastForwardPass = 0;
    }
  };
  
  /// Forward pass through KAN layer
  /// output[j] = Σᵢ φᵢⱼ(input[i])
  public func forwardKANLayer(layer : KANLayer, input : [Float]) : [Float] {
    Array.tabulate<Float>(layer.outputWidth, func(j : Nat) : Float {
      var sum : Float = 0.0;
      for (i in Iter.range(0, layer.inputWidth - 1)) {
        if (i < input.size()) {
          let edge = layer.edges[i][j];
          sum += evaluateKANEdge(edge, input[i]);
        };
      };
      sum
    })
  };
  
  /// Backward pass through KAN layer
  public func backwardKANLayer(
    layer : KANLayer,
    input : [Float],
    outputGradient : [Float]
  ) : ([Float], [[var [Float]]]) {
    // Input gradient: ∂L/∂x[i] = Σⱼ (∂L/∂y[j]) × (∂φᵢⱼ/∂x[i])
    let inputGrad = Array.init<Float>(layer.inputWidth, 0.0);
    
    // Coefficient gradients
    let coeffGrads = Array.tabulate<[var [Float]]>(layer.inputWidth, func(i : Nat) : [var [Float]] {
      Array.init<[Float]>(layer.outputWidth, func(j : Nat) : [Float] {
        Array.freeze(Array.init<Float>(layer.splineConfig.numControlPoints, 0.0))
      })
    });
    
    for (j in Iter.range(0, layer.outputWidth - 1)) {
      let gradJ = if (j < outputGradient.size()) { outputGradient[j] } else { 0.0 };
      
      for (i in Iter.range(0, layer.inputWidth - 1)) {
        let edge = layer.edges[i][j];
        if (edge.isActive and i < input.size()) {
          // Coefficient gradient
          let cGrad = computeKANEdgeGradient(edge, input[i], gradJ);
          coeffGrads[i][j] := cGrad;
          
          // Input gradient (numerical approximation)
          let eps = 1e-5;
          let fPlus = evaluateKANEdge(edge, input[i] + eps);
          let fMinus = evaluateKANEdge(edge, input[i] - eps);
          let dPhiDx = (fPlus - fMinus) / (2.0 * eps);
          inputGrad[i] += gradJ * dPhiDx;
        };
      };
    };
    
    (Array.freeze(inputGrad), coeffGrads)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE KAN NETWORK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete KAN network
  public type KANNetwork = {
    layers : [var KANLayer];
    layerWidths : [Nat];         // [input_dim, hidden1, hidden2, ..., output_dim]
    splineConfig : BSplineConfig;
    var learningRate : Float;
    var l2Reg : Float;
    var totalUpdates : Nat;
    var totalPruned : Nat;
    var lastTrainBeat : Int;
  };
  
  /// Create a KAN network with given architecture
  public func createKANNetwork(
    layerWidths : [Nat],
    config : BSplineConfig,
    learningRate : Float,
    l2Reg : Float,
    seed : Nat
  ) : KANNetwork {
    if (layerWidths.size() < 2) {
      // At least input and output
      return createKANNetwork([1, 1], config, learningRate, l2Reg, seed);
    };
    
    let layers = Array.init<KANLayer>(layerWidths.size() - 1, func(l : Nat) : KANLayer {
      createKANLayer(
        layerWidths[l],
        layerWidths[l + 1],
        config,
        1.0 / Float.sqrt(Float.fromInt(layerWidths[l])),
        seed + l * 10000
      )
    });
    
    {
      layers = layers;
      layerWidths = layerWidths;
      splineConfig = config;
      var learningRate = learningRate;
      var l2Reg = l2Reg;
      var totalUpdates = 0;
      var totalPruned = 0;
      var lastTrainBeat = 0;
    }
  };
  
  /// Forward pass through entire KAN network
  public func forwardKAN(network : KANNetwork, input : [Float]) : [Float] {
    var current = input;
    
    for (l in Iter.range(0, network.layers.size() - 1)) {
      current := forwardKANLayer(network.layers[l], current);
    };
    
    current
  };
  
  /// Store intermediate activations for backward pass
  public func forwardKANWithCache(
    network : KANNetwork,
    input : [Float]
  ) : ([Float], [[Float]]) {
    let cache = Buffer.Buffer<[Float]>(network.layers.size() + 1);
    cache.add(input);
    
    var current = input;
    for (l in Iter.range(0, network.layers.size() - 1)) {
      current := forwardKANLayer(network.layers[l], current);
      cache.add(current);
    };
    
    (current, Buffer.toArray(cache))
  };
  
  /// Backward pass through entire network
  public func backwardKAN(
    network : KANNetwork,
    cache : [[Float]],
    outputGradient : [Float]
  ) : [[[var [Float]]]] {
    var currentGrad = outputGradient;
    let allCoeffGrads = Buffer.Buffer<[[var [Float]]]>(network.layers.size());
    
    // Backward through layers in reverse order
    var l = network.layers.size();
    while (l > 0) {
      l -= 1;
      let layerInput = cache[l];
      let (inputGrad, coeffGrads) = backwardKANLayer(network.layers[l], layerInput, currentGrad);
      allCoeffGrads.add(coeffGrads);
      currentGrad := inputGrad;
    };
    
    // Reverse to get correct order
    let result = Buffer.toArray(allCoeffGrads);
    Array.tabulate<[[var [Float]]]>(result.size(), func(i : Nat) : [[var [Float]]] {
      result[result.size() - 1 - i]
    })
  };
  
  /// Update network parameters using gradients
  public func updateKANParameters(
    network : KANNetwork,
    coeffGrads : [[[var [Float]]]],
    currentBeat : Int
  ) : () {
    for (l in Iter.range(0, network.layers.size() - 1)) {
      let layer = network.layers[l];
      
      for (i in Iter.range(0, layer.inputWidth - 1)) {
        for (j in Iter.range(0, layer.outputWidth - 1)) {
          let edge = layer.edges[i][j];
          if (edge.isActive) {
            let grads = if (l < coeffGrads.size() and i < coeffGrads[l].size() and 
                           j < coeffGrads[l][i].size()) {
              coeffGrads[l][i][j]
            } else {
              Array.freeze(Array.init<Float>(layer.splineConfig.numControlPoints, 0.0))
            };
            
            // Update coefficients with gradient descent + L2 regularization
            for (k in Iter.range(0, layer.splineConfig.numControlPoints - 1)) {
              if (k < grads.size()) {
                let grad = grads[k] + network.l2Reg * edge.coefficients[k];
                edge.coefficients[k] -= network.learningRate * grad;
              };
            };
            
            // Update magnitude
            edge.magnitude := computeCoeffMagnitude(Array.freeze(edge.coefficients));
            edge.lastUpdate := currentBeat;
          };
        };
      };
    };
    
    network.totalUpdates += 1;
    network.lastTrainBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRAINING — COMPLETE TRAINING STEP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Loss function: Mean Squared Error
  public func computeMSELoss(predicted : [Float], target : [Float]) : Float {
    var loss : Float = 0.0;
    let n = Nat.min(predicted.size(), target.size());
    
    for (i in Iter.range(0, n - 1)) {
      let diff = predicted[i] - target[i];
      loss += diff * diff;
    };
    
    if (n > 0) { loss / Float.fromInt(n) } else { 0.0 }
  };
  
  /// Compute output gradient for MSE loss
  public func computeMSEGradient(predicted : [Float], target : [Float]) : [Float] {
    let n = Nat.min(predicted.size(), target.size());
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      2.0 * (predicted[i] - target[i]) / Float.fromInt(n)
    })
  };
  
  /// Single training step
  public func trainStep(
    network : KANNetwork,
    input : [Float],
    target : [Float],
    currentBeat : Int
  ) : Float {
    // Forward pass with caching
    let (output, cache) = forwardKANWithCache(network, input);
    
    // Compute loss
    let loss = computeMSELoss(output, target);
    
    // Compute output gradient
    let outputGrad = computeMSEGradient(output, target);
    
    // Backward pass
    let coeffGrads = backwardKAN(network, cache, outputGrad);
    
    // Update parameters
    updateKANParameters(network, coeffGrads, currentBeat);
    
    loss
  };
  
  /// Batch training
  public func trainBatch(
    network : KANNetwork,
    inputs : [[Float]],
    targets : [[Float]],
    currentBeat : Int
  ) : Float {
    var totalLoss : Float = 0.0;
    let batchSize = Nat.min(inputs.size(), targets.size());
    
    for (i in Iter.range(0, batchSize - 1)) {
      totalLoss += trainStep(network, inputs[i], targets[i], currentBeat);
    };
    
    if (batchSize > 0) { totalLoss / Float.fromInt(batchSize) } else { 0.0 }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PRUNING — REMOVING INACTIVE EDGES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Prune edges with small magnitude
  public func pruneEdges(network : KANNetwork, threshold : Float) : Nat {
    var pruned : Nat = 0;
    
    for (l in Iter.range(0, network.layers.size() - 1)) {
      let layer = network.layers[l];
      
      for (i in Iter.range(0, layer.inputWidth - 1)) {
        for (j in Iter.range(0, layer.outputWidth - 1)) {
          let edge = layer.edges[i][j];
          if (edge.isActive and edge.magnitude < threshold) {
            edge.isActive := false;
            layer.activeEdgeCount -= 1;
            pruned += 1;
          };
        };
      };
    };
    
    network.totalPruned += pruned;
    pruned
  };
  
  /// Get network sparsity (fraction of pruned edges)
  public func getSparsity(network : KANNetwork) : Float {
    var total : Nat = 0;
    var active : Nat = 0;
    
    for (l in Iter.range(0, network.layers.size() - 1)) {
      let layer = network.layers[l];
      total += layer.inputWidth * layer.outputWidth;
      active += layer.activeEdgeCount;
    };
    
    if (total > 0) {
      1.0 - Float.fromInt(active) / Float.fromInt(total)
    } else { 0.0 }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SYMBOLIC EXTRACTION — IDENTIFY LEARNED FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Symbolic function type
  public type SymbolicFunction = {
    #Identity;
    #Constant : Float;
    #Linear : { slope : Float; intercept : Float };
    #Quadratic : { a : Float; b : Float; c : Float };
    #Sine : { amplitude : Float; frequency : Float; phase : Float };
    #Exponential : { base : Float; scale : Float };
    #ReLU : { threshold : Float };
    #Sigmoid;
    #Unknown;
  };
  
  /// Try to identify symbolic form of learned edge function
  public func identifySymbolicForm(edge : KANEdge) : SymbolicFunction {
    if (not edge.isActive) { return #Constant(0.0) };
    
    // Sample edge function at multiple points
    let samples = 20;
    let xs = Array.tabulate<Float>(samples, func(i : Nat) : Float {
      edge.splineConfig.gridMin + Float.fromInt(i) * 
        (edge.splineConfig.gridMax - edge.splineConfig.gridMin) / Float.fromInt(samples - 1)
    });
    
    let ys = Array.tabulate<Float>(samples, func(i : Nat) : Float {
      evaluateKANEdge(edge, xs[i])
    });
    
    // Check for constant function
    var isConstant = true;
    let firstY = ys[0];
    for (y in ys.vals()) {
      if (Float.abs(y - firstY) > 0.01) {
        isConstant := false;
      };
    };
    if (isConstant) { return #Constant(firstY) };
    
    // Check for linear function: fit y = mx + b
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    
    for (i in Iter.range(0, samples - 1)) {
      sumX += xs[i];
      sumY += ys[i];
      sumXY += xs[i] * ys[i];
      sumX2 += xs[i] * xs[i];
    };
    
    let n = Float.fromInt(samples);
    let slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    let intercept = (sumY - slope * sumX) / n;
    
    // Check linear fit quality
    var linearError : Float = 0.0;
    for (i in Iter.range(0, samples - 1)) {
      let predicted = slope * xs[i] + intercept;
      linearError += (ys[i] - predicted) * (ys[i] - predicted);
    };
    linearError := Float.sqrt(linearError / n);
    
    if (linearError < 0.01) {
      if (Float.abs(slope) < 0.01 and Float.abs(intercept) < 0.01) {
        return #Constant(0.0);
      } else if (Float.abs(slope - 1.0) < 0.01 and Float.abs(intercept) < 0.01) {
        return #Identity;
      } else {
        return #Linear({ slope = slope; intercept = intercept });
      };
    };
    
    // Could add more sophisticated symbolic detection here
    // (quadratic, sine, exponential, etc.)
    
    #Unknown
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATION WITH ORGANISM — HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// KAN state for organism integration
  public type KANState = {
    network : KANNetwork;
    var trainingLoss : Float;
    var validationLoss : Float;
    var currentSparsity : Float;
    var learnedSymbols : [(Nat, Nat, Nat, SymbolicFunction)];  // (layer, i, j, symbol)
    var lastAnalysisBeat : Int;
    var isConverged : Bool;
  };
  
  /// Initialize KAN state for organism
  public func initKANState(
    architecture : [Nat],
    seed : Nat
  ) : KANState {
    let config = initBSplineConfig(
      DEFAULT_SPLINE_DEGREE,
      DEFAULT_NUM_CONTROL_POINTS,
      DEFAULT_GRID_MIN,
      DEFAULT_GRID_MAX
    );
    
    {
      network = createKANNetwork(architecture, config, DEFAULT_LEARNING_RATE, DEFAULT_L2_REG, seed);
      var trainingLoss = 1.0;
      var validationLoss = 1.0;
      var currentSparsity = 0.0;
      var learnedSymbols = [];
      var lastAnalysisBeat = 0;
      var isConverged = false;
    }
  };
  
  /// Main heartbeat update for KAN
  public func heartbeatUpdate(
    state : KANState,
    trainingInputs : [[Float]],
    trainingTargets : [[Float]],
    doPrune : Bool,
    currentBeat : Int
  ) : {
    loss : Float;
    sparsity : Float;
    symbolsIdentified : Nat;
  } {
    // Training step
    let loss = trainBatch(state.network, trainingInputs, trainingTargets, currentBeat);
    state.trainingLoss := loss;
    
    // Pruning (periodically)
    if (doPrune and currentBeat % 100 == 0) {
      let _ = pruneEdges(state.network, PRUNING_THRESHOLD);
    };
    
    state.currentSparsity := getSparsity(state.network);
    
    // Symbol analysis (less frequently)
    var symbolsFound : Nat = 0;
    if (currentBeat % 1000 == 0 or currentBeat - state.lastAnalysisBeat > 1000) {
      let symbols = Buffer.Buffer<(Nat, Nat, Nat, SymbolicFunction)>(10);
      
      for (l in Iter.range(0, state.network.layers.size() - 1)) {
        let layer = state.network.layers[l];
        for (i in Iter.range(0, layer.inputWidth - 1)) {
          for (j in Iter.range(0, layer.outputWidth - 1)) {
            let symbol = identifySymbolicForm(layer.edges[i][j]);
            switch (symbol) {
              case (#Unknown) {};
              case (_) {
                symbols.add((l, i, j, symbol));
                symbolsFound += 1;
              };
            };
          };
        };
      };
      
      state.learnedSymbols := Buffer.toArray(symbols);
      state.lastAnalysisBeat := currentBeat;
    };
    
    // Convergence check
    state.isConverged := loss < 0.001 and state.currentSparsity > 0.5;
    
    {
      loss = loss;
      sparsity = state.currentSparsity;
      symbolsIdentified = symbolsFound;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Evaluate network on input
  public func evaluate(state : KANState, input : [Float]) : [Float] {
    forwardKAN(state.network, input)
  };
  
  /// Get training loss
  public func getTrainingLoss(state : KANState) : Float {
    state.trainingLoss
  };
  
  /// Get sparsity
  public func getNetworkSparsity(state : KANState) : Float {
    state.currentSparsity
  };
  
  /// Get learned symbols
  public func getLearnedSymbols(state : KANState) : [(Nat, Nat, Nat, SymbolicFunction)] {
    state.learnedSymbols
  };
  
  /// Check convergence
  public func isConverged(state : KANState) : Bool {
    state.isConverged
  };
  
  /// Get total parameters
  public func getTotalParameters(state : KANState) : Nat {
    var total : Nat = 0;
    for (l in Iter.range(0, state.network.layers.size() - 1)) {
      let layer = state.network.layers[l];
      total += layer.inputWidth * layer.outputWidth * layer.splineConfig.numControlPoints;
    };
    total
  };
  
  /// Get active parameters (non-pruned)
  public func getActiveParameters(state : KANState) : Nat {
    var active : Nat = 0;
    for (l in Iter.range(0, state.network.layers.size() - 1)) {
      let layer = state.network.layers[l];
      active += layer.activeEdgeCount * layer.splineConfig.numControlPoints;
    };
    active
  };

}
