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
// LYAPUNOV CHAOTIC CORE ROUTER — DYNAMICAL STABILITY ANALYSIS AND DIFFERENTIAL ROUTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements per-core Lyapunov exponent computation to distinguish between chaotic (λ > 0)
// and stable (λ < 0) computational cores. Tasks are routed differentially: chaotic cores for exploration,
// stable cores for execution.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// Lyapunov Exponent (Maximal):
//   λ = lim(t→∞) (1/t) × ln(|δx(t)|/|δx(0)|)
//   where δx is a perturbation to the trajectory
//
// Lyapunov Spectrum (all exponents):
//   λ₁ ≥ λ₂ ≥ ... ≥ λₙ for n-dimensional system
//   Sum rule: Σλᵢ = trace(Jacobian)
//
// Classification:
//   λ > 0: Chaotic (exponential divergence, sensitive to initial conditions)
//   λ < 0: Stable (exponential convergence to attractor)
//   λ ≈ 0: Edge of Chaos (critical, optimal computation)
//
// Jacobian Method:
//   For dx/dt = f(x), the variational equation is:
//   dδ/dt = J(x)δ where J = ∂f/∂x
//   λ = lim(1/t) ∫₀ᵗ ⟨J(x(s))δ(s), δ(s)⟩/|δ|² ds
//
// Finite-Time Lyapunov Exponent (FTLE):
//   λᵀ(x₀) = (1/T) ln(||∂φᵀ(x₀)/∂x₀||)
//   where φᵀ is the flow map
//
// EDGE OF CHAOS COMPUTATION:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Maximal computational capability occurs at λ ≈ 0
// • Information processing peaks at critical point
// • Balance between memory (λ < 0) and sensitivity (λ > 0)
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Each shell/core has its Lyapunov exponent computed
// • Chaotic cores (λ > 0) handle exploration, creativity, novelty
// • Stable cores (λ < 0) handle execution, memory, precision
// • Edge-of-chaos cores (λ ≈ 0) handle complex computation
// • Dynamic rebalancing based on task requirements
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

module LyapunovChaoticCoreRouter {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LYAPUNOV CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Perturbation size for numerical differentiation
  public let PERTURBATION_SIZE : Float = 1e-8;
  
  /// Renormalization threshold (when perturbation grows too large)
  public let RENORM_THRESHOLD : Float = 1e6;
  
  /// Minimum trajectory length for reliable estimate
  public let MIN_TRAJECTORY_LENGTH : Nat = 100;
  
  /// Window size for FTLE computation
  public let FTLE_WINDOW : Nat = 50;
  
  /// Edge of chaos threshold (|λ| < this is considered edge)
  public let EDGE_OF_CHAOS_THRESHOLD : Float = 0.1;
  
  /// Chaotic threshold (λ > this is definitely chaotic)
  public let CHAOTIC_THRESHOLD : Float = 0.5;
  
  /// Maximum number of cores to track
  public let MAX_CORES : Nat = 64;
  
  /// S₀ floor integration
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DYNAMICAL SYSTEM TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// State vector for a dynamical system
  public type StateVector = {
    var values : [var Float];
    dimension : Nat;
    var time : Float;
  };
  
  /// Jacobian matrix
  public type JacobianMatrix = {
    var elements : [[var Float]];  // n × n matrix
    dimension : Nat;
    var trace : Float;
    var determinant : Float;
    var maxEigenvalue : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LYAPUNOV EXPONENT TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lyapunov exponent estimate for one direction
  public type LyapunovExponent = {
    var value : Float;             // The exponent λ
    var uncertainty : Float;       // Estimation uncertainty
    var sampleCount : Nat;         // Number of samples used
    var converged : Bool;          // Whether estimate has converged
    var lastUpdate : Int;
  };
  
  /// Full Lyapunov spectrum for n-dimensional system
  public type LyapunovSpectrum = {
    exponents : [var LyapunovExponent];  // λ₁ ≥ λ₂ ≥ ... ≥ λₙ
    dimension : Nat;
    var maxExponent : Float;       // λ_max (determines chaos)
    var sumExponents : Float;      // Σλᵢ (Kaplan-Yorke dimension)
    var lyapunovDimension : Float; // D_L (fractal dimension of attractor)
    var kolmogorovEntropy : Float; // K = Σ{λᵢ > 0} λᵢ (information production)
  };
  
  /// Core stability classification
  public type StabilityClass = {
    #Chaotic;          // λ_max > CHAOTIC_THRESHOLD
    #EdgeOfChaos;      // |λ_max| < EDGE_OF_CHAOS_THRESHOLD
    #Stable;           // λ_max < -EDGE_OF_CHAOS_THRESHOLD
    #Periodic;         // λ_max ≈ 0 but not chaotic (limit cycle)
    #FixedPoint;       // All λ < 0 (attractor is fixed point)
    #Unknown;          // Insufficient data
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE STATE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// State of a single computational core
  public type CoreState = {
    coreId : Nat;
    shellId : Nat8;
    var state : StateVector;
    var perturbation : StateVector;  // For variational equation
    spectrum : LyapunovSpectrum;
    var stabilityClass : StabilityClass;
    var trajectoryHistory : Buffer.Buffer<[Float]>;
    var taskAssignment : ?TaskType;
    var utilizationRate : Float;
    var lastAnalysis : Int;
  };
  
  /// Task types for routing
  public type TaskType = {
    #Exploration;      // Creative, novel, exploratory tasks
    #Execution;        // Precise, deterministic, routine tasks
    #Computation;      // Complex computations requiring edge-of-chaos
    #Memory;           // Memory storage and retrieval
    #Learning;         // Adaptive learning tasks
    #Integration;      // Multi-modal integration
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FINITE-TIME LYAPUNOV EXPONENT (FTLE)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// FTLE field for spatial analysis
  public type FTLEField = {
    var values : [[var Float]];    // FTLE at each grid point
    gridSize : Nat;
    timeWindow : Float;
    var maxFTLE : Float;
    var minFTLE : Float;
    var ridges : [(Nat, Nat)];     // Locations of FTLE ridges (LCS)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize state vector
  public func initStateVector(dimension : Nat, initialValues : [Float]) : StateVector {
    let values = Array.init<Float>(dimension, func(i : Nat) : Float {
      if (i < initialValues.size()) { initialValues[i] } else { 0.0 }
    });
    
    {
      var values = values;
      dimension = dimension;
      var time = 0.0;
    }
  };
  
  /// Initialize Jacobian matrix
  public func initJacobianMatrix(dimension : Nat) : JacobianMatrix {
    let elements = Array.tabulate<[var Float]>(dimension, func(i : Nat) : [var Float] {
      Array.init<Float>(dimension, func(j : Nat) : Float {
        if (i == j) { 0.0 } else { 0.0 }  // Will be computed
      })
    });
    
    {
      var elements = elements;
      dimension = dimension;
      var trace = 0.0;
      var determinant = 0.0;
      var maxEigenvalue = 0.0;
    }
  };
  
  /// Initialize Lyapunov exponent
  public func initLyapunovExponent() : LyapunovExponent {
    {
      var value = 0.0;
      var uncertainty = 1.0;
      var sampleCount = 0;
      var converged = false;
      var lastUpdate = 0;
    }
  };
  
  /// Initialize Lyapunov spectrum
  public func initLyapunovSpectrum(dimension : Nat) : LyapunovSpectrum {
    let exponents = Array.init<LyapunovExponent>(dimension, func(_ : Nat) : LyapunovExponent {
      initLyapunovExponent()
    });
    
    {
      exponents = exponents;
      dimension = dimension;
      var maxExponent = 0.0;
      var sumExponents = 0.0;
      var lyapunovDimension = 0.0;
      var kolmogorovEntropy = 0.0;
    }
  };
  
  /// Initialize core state
  public func initCoreState(
    coreId : Nat,
    shellId : Nat8,
    dimension : Nat,
    initialState : [Float]
  ) : CoreState {
    // Initialize perturbation orthogonal to state
    let pertValues = Array.tabulate<Float>(dimension, func(i : Nat) : Float {
      if (i == 0) { PERTURBATION_SIZE } else { 0.0 }
    });
    
    {
      coreId = coreId;
      shellId = shellId;
      var state = initStateVector(dimension, initialState);
      var perturbation = initStateVector(dimension, pertValues);
      spectrum = initLyapunovSpectrum(dimension);
      var stabilityClass = #Unknown;
      var trajectoryHistory = Buffer.Buffer<[Float]>(MIN_TRAJECTORY_LENGTH);
      var taskAssignment = null;
      var utilizationRate = 0.0;
      var lastAnalysis = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // JACOBIAN COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Jacobian matrix numerically using finite differences
  /// J[i,j] = ∂f_i/∂x_j ≈ (f_i(x + ε_j) - f_i(x - ε_j)) / 2ε
  public func computeJacobianNumerical(
    jacobian : JacobianMatrix,
    state : StateVector,
    dynamics : (StateVector) -> [Float]  // The dynamical system f(x)
  ) : () {
    let n = jacobian.dimension;
    let baseDerivatives = dynamics(state);
    
    for (j in Iter.range(0, n - 1)) {
      // Perturb in j direction
      let originalJ = state.values[j];
      
      // Forward perturbation
      state.values[j] := originalJ + PERTURBATION_SIZE;
      let forwardDerivs = dynamics(state);
      
      // Backward perturbation
      state.values[j] := originalJ - PERTURBATION_SIZE;
      let backwardDerivs = dynamics(state);
      
      // Restore
      state.values[j] := originalJ;
      
      // Central difference for each component
      for (i in Iter.range(0, n - 1)) {
        if (i < forwardDerivs.size() and i < backwardDerivs.size()) {
          jacobian.elements[i][j] := (forwardDerivs[i] - backwardDerivs[i]) / 
                                     (2.0 * PERTURBATION_SIZE);
        };
      };
    };
    
    // Compute trace (sum of diagonal)
    var trace : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      trace += jacobian.elements[i][i];
    };
    jacobian.trace := trace;
    
    // For 2D systems, compute determinant directly
    if (n == 2) {
      jacobian.determinant := jacobian.elements[0][0] * jacobian.elements[1][1] -
                              jacobian.elements[0][1] * jacobian.elements[1][0];
      
      // Eigenvalues for 2D: λ = (trace ± √(trace² - 4*det)) / 2
      let discriminant = trace * trace - 4.0 * jacobian.determinant;
      if (discriminant >= 0.0) {
        let sqrtDisc = Float.sqrt(discriminant);
        let lambda1 = (trace + sqrtDisc) / 2.0;
        let lambda2 = (trace - sqrtDisc) / 2.0;
        jacobian.maxEigenvalue := Float.max(lambda1, lambda2);
      } else {
        // Complex eigenvalues: real part is trace/2
        jacobian.maxEigenvalue := trace / 2.0;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LYAPUNOV EXPONENT COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Evolve perturbation using variational equation
  /// dδ/dt = J(x)δ
  public func evolvePerturbation(
    perturbation : StateVector,
    jacobian : JacobianMatrix,
    dt : Float
  ) : () {
    let n = perturbation.dimension;
    let newValues = Array.init<Float>(n, 0.0);
    
    // Matrix-vector multiplication: dδ/dt = Jδ
    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        sum += jacobian.elements[i][j] * perturbation.values[j];
      };
      newValues[i] := perturbation.values[i] + sum * dt;
    };
    
    // Update
    for (i in Iter.range(0, n - 1)) {
      perturbation.values[i] := newValues[i];
    };
    perturbation.time += dt;
  };
  
  /// Compute perturbation magnitude
  public func perturbationMagnitude(perturbation : StateVector) : Float {
    var sumSq : Float = 0.0;
    for (i in Iter.range(0, perturbation.dimension - 1)) {
      sumSq += perturbation.values[i] * perturbation.values[i];
    };
    Float.sqrt(sumSq)
  };
  
  /// Renormalize perturbation and accumulate Lyapunov exponent
  /// Returns the local Lyapunov exponent contribution
  public func renormalizePerturbation(
    perturbation : StateVector,
    targetMagnitude : Float
  ) : Float {
    let mag = perturbationMagnitude(perturbation);
    if (mag < 1e-15) { return -100.0 };  // Very negative (stable)
    
    // Local Lyapunov contribution: ln(|δ_new|/|δ_old|)
    let localLyapunov = Float.log(mag / targetMagnitude);
    
    // Renormalize
    let scale = targetMagnitude / mag;
    for (i in Iter.range(0, perturbation.dimension - 1)) {
      perturbation.values[i] *= scale;
    };
    
    localLyapunov
  };
  
  /// Update Lyapunov exponent estimate with new sample
  public func updateLyapunovEstimate(
    exponent : LyapunovExponent,
    localContribution : Float,
    timeInterval : Float,
    currentBeat : Int
  ) : () {
    // Lyapunov exponent: λ = (1/T) × ln(|δ(T)|/|δ(0)|)
    let localLambda = localContribution / timeInterval;
    
    // Running average with decaying weight
    let n = Float.fromInt(exponent.sampleCount + 1);
    let alpha = 1.0 / n;  // Weight for new sample
    
    let oldValue = exponent.value;
    exponent.value := (1.0 - alpha) * oldValue + alpha * localLambda;
    
    // Update uncertainty (standard error of mean)
    let diff = localLambda - exponent.value;
    exponent.uncertainty := Float.sqrt(
      ((n - 1.0) * exponent.uncertainty * exponent.uncertainty + diff * diff) / n
    );
    
    exponent.sampleCount += 1;
    exponent.lastUpdate := currentBeat;
    
    // Check convergence
    if (exponent.sampleCount > MIN_TRAJECTORY_LENGTH and 
        exponent.uncertainty < 0.1 * Float.abs(exponent.value)) {
      exponent.converged := true;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SPECTRUM ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update spectrum statistics from individual exponents
  public func updateSpectrumStatistics(spectrum : LyapunovSpectrum) : () {
    let n = spectrum.dimension;
    
    // Sort exponents (descending)
    let sortedValues = Array.tabulate<Float>(n, func(i : Nat) : Float {
      spectrum.exponents[i].value
    });
    // Note: Motoko doesn't have built-in sort, assuming pre-sorted by construction
    
    // Max exponent
    var maxExp : Float = -1000.0;
    var sumExp : Float = 0.0;
    var kolmogorov : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let lambda = spectrum.exponents[i].value;
      if (lambda > maxExp) { maxExp := lambda };
      sumExp += lambda;
      if (lambda > 0.0) { kolmogorov += lambda };
    };
    
    spectrum.maxExponent := maxExp;
    spectrum.sumExponents := sumExp;
    spectrum.kolmogorovEntropy := kolmogorov;
    
    // Kaplan-Yorke (Lyapunov) dimension
    // D_L = j + (1/|λ_{j+1}|) × Σᵢ₌₁ʲ λᵢ where j is largest index with Σ ≥ 0
    var cumSum : Float = 0.0;
    var j : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      cumSum += spectrum.exponents[i].value;
      if (cumSum >= 0.0) { j := i + 1 };
    };
    
    if (j > 0 and j < n) {
      let lambdaJP1 = spectrum.exponents[j].value;
      if (Float.abs(lambdaJP1) > 1e-10) {
        var partialSum : Float = 0.0;
        for (i in Iter.range(0, j - 1)) {
          partialSum += spectrum.exponents[i].value;
        };
        spectrum.lyapunovDimension := Float.fromInt(j) + partialSum / Float.abs(lambdaJP1);
      };
    };
  };
  
  /// Classify stability from spectrum
  public func classifyStability(spectrum : LyapunovSpectrum) : StabilityClass {
    let maxLambda = spectrum.maxExponent;
    let sumLambda = spectrum.sumExponents;
    
    // Check if any exponent has converged
    var hasConverged = false;
    for (i in Iter.range(0, spectrum.dimension - 1)) {
      if (spectrum.exponents[i].converged) {
        hasConverged := true;
      };
    };
    
    if (not hasConverged) {
      return #Unknown;
    };
    
    // Classify based on max exponent
    if (maxLambda > CHAOTIC_THRESHOLD) {
      return #Chaotic;
    };
    
    if (Float.abs(maxLambda) < EDGE_OF_CHAOS_THRESHOLD) {
      // Check if truly edge-of-chaos or periodic
      // Periodic: λ_max ≈ 0 but system is not chaotic
      if (spectrum.kolmogorovEntropy < EDGE_OF_CHAOS_THRESHOLD) {
        return #Periodic;
      };
      return #EdgeOfChaos;
    };
    
    if (maxLambda < -EDGE_OF_CHAOS_THRESHOLD) {
      // Check if fixed point (all negative) or stable orbit
      var allNegative = true;
      for (i in Iter.range(0, spectrum.dimension - 1)) {
        if (spectrum.exponents[i].value >= 0.0) {
          allNegative := false;
        };
      };
      
      if (allNegative) {
        return #FixedPoint;
      };
      return #Stable;
    };
    
    #Stable
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Analyze a core's dynamics and update its Lyapunov spectrum
  public func analyzeCoreStability(
    core : CoreState,
    dynamics : (StateVector) -> [Float],
    dt : Float,
    steps : Nat,
    currentBeat : Int
  ) : () {
    let jacobian = initJacobianMatrix(core.state.dimension);
    var totalTime : Float = 0.0;
    var localLyapunovSum : Float = 0.0;
    
    for (step in Iter.range(0, steps - 1)) {
      // Compute Jacobian at current state
      computeJacobianNumerical(jacobian, core.state, dynamics);
      
      // Evolve perturbation
      evolvePerturbation(core.perturbation, jacobian, dt);
      
      totalTime += dt;
      
      // Check if renormalization needed
      let mag = perturbationMagnitude(core.perturbation);
      if (mag > RENORM_THRESHOLD or mag < PERTURBATION_SIZE * 0.001) {
        let contribution = renormalizePerturbation(core.perturbation, PERTURBATION_SIZE);
        localLyapunovSum += contribution;
        
        // Update exponent estimate
        if (totalTime > 0.0) {
          updateLyapunovEstimate(
            core.spectrum.exponents[0],
            localLyapunovSum,
            totalTime,
            currentBeat
          );
          localLyapunovSum := 0.0;
        };
      };
      
      // Record trajectory
      let stateSnapshot = Array.tabulate<Float>(core.state.dimension, func(i : Nat) : Float {
        core.state.values[i]
      });
      core.trajectoryHistory.add(stateSnapshot);
      
      // Keep trajectory history bounded
      if (core.trajectoryHistory.size() > MIN_TRAJECTORY_LENGTH * 2) {
        ignore core.trajectoryHistory.remove(0);
      };
      
      // Evolve main state (external dynamics should be applied)
      // Note: In practice, the dynamics function updates core.state
    };
    
    // Final renormalization and update
    if (totalTime > 0.0) {
      let contribution = renormalizePerturbation(core.perturbation, PERTURBATION_SIZE);
      localLyapunovSum += contribution;
      updateLyapunovEstimate(
        core.spectrum.exponents[0],
        localLyapunovSum,
        totalTime,
        currentBeat
      );
    };
    
    // Update spectrum statistics
    updateSpectrumStatistics(core.spectrum);
    
    // Classify stability
    core.stabilityClass := classifyStability(core.spectrum);
    core.lastAnalysis := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK ROUTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Router state
  public type RouterState = {
    cores : [var CoreState];
    var chaoticCores : [Nat];      // Indices of chaotic cores
    var stableCores : [Nat];       // Indices of stable cores
    var edgeCores : [Nat];         // Indices of edge-of-chaos cores
    var taskQueue : [(TaskType, Nat)];  // (task, priority)
    var totalTasksRouted : Nat;
    var lastRoutingUpdate : Int;
  };
  
  /// Initialize router state
  public func initRouterState(
    numCores : Nat,
    coreDimension : Nat,
    shellIds : [Nat8]
  ) : RouterState {
    let cores = Array.init<CoreState>(numCores, func(i : Nat) : CoreState {
      let shellId = if (i < shellIds.size()) { shellIds[i] } else { Nat8.fromNat(0) };
      let initialState = Array.tabulate<Float>(coreDimension, func(j : Nat) : Float {
        Float.sin(Float.fromInt(i * 7 + j * 3))  // Pseudo-random initial state
      });
      initCoreState(i, shellId, coreDimension, initialState)
    });
    
    {
      cores = cores;
      var chaoticCores = [];
      var stableCores = [];
      var edgeCores = [];
      var taskQueue = [];
      var totalTasksRouted = 0;
      var lastRoutingUpdate = 0;
    }
  };
  
  /// Update core classification lists
  public func updateCoreClassifications(router : RouterState) : () {
    let chaotic = Buffer.Buffer<Nat>(router.cores.size());
    let stable = Buffer.Buffer<Nat>(router.cores.size());
    let edge = Buffer.Buffer<Nat>(router.cores.size());
    
    for (i in Iter.range(0, router.cores.size() - 1)) {
      let core = router.cores[i];
      switch (core.stabilityClass) {
        case (#Chaotic) { chaotic.add(i) };
        case (#Stable) { stable.add(i) };
        case (#FixedPoint) { stable.add(i) };
        case (#EdgeOfChaos) { edge.add(i) };
        case (#Periodic) { stable.add(i) };
        case (#Unknown) {};
      };
    };
    
    router.chaoticCores := Buffer.toArray(chaotic);
    router.stableCores := Buffer.toArray(stable);
    router.edgeCores := Buffer.toArray(edge);
  };
  
  /// Get optimal task type for a core's stability class
  public func getOptimalTaskType(stabilityClass : StabilityClass) : TaskType {
    switch (stabilityClass) {
      case (#Chaotic) { #Exploration };
      case (#EdgeOfChaos) { #Computation };
      case (#Stable) { #Execution };
      case (#FixedPoint) { #Memory };
      case (#Periodic) { #Integration };
      case (#Unknown) { #Execution };
    }
  };
  
  /// Route a task to an appropriate core
  public func routeTask(
    router : RouterState,
    taskType : TaskType
  ) : ?Nat {
    // Find cores suitable for this task type
    let candidates = switch (taskType) {
      case (#Exploration) { router.chaoticCores };
      case (#Execution) { router.stableCores };
      case (#Computation) { 
        if (router.edgeCores.size() > 0) { router.edgeCores }
        else { router.stableCores }
      };
      case (#Memory) { router.stableCores };
      case (#Learning) { 
        if (router.edgeCores.size() > 0) { router.edgeCores }
        else { router.chaoticCores }
      };
      case (#Integration) { router.edgeCores };
    };
    
    if (candidates.size() == 0) {
      return null;
    };
    
    // Select least utilized core among candidates
    var bestCore : ?Nat = null;
    var lowestUtilization : Float = 2.0;
    
    for (coreIdx in candidates.vals()) {
      let core = router.cores[coreIdx];
      if (core.taskAssignment == null and core.utilizationRate < lowestUtilization) {
        lowestUtilization := core.utilizationRate;
        bestCore := ?coreIdx;
      };
    };
    
    // Assign task to selected core
    switch (bestCore) {
      case (?idx) {
        router.cores[idx].taskAssignment := ?taskType;
        router.cores[idx].utilizationRate += 0.1;
        router.totalTasksRouted += 1;
      };
      case (null) {};
    };
    
    bestCore
  };
  
  /// Release a core from its task assignment
  public func releaseCore(router : RouterState, coreIdx : Nat) : () {
    if (coreIdx < router.cores.size()) {
      router.cores[coreIdx].taskAssignment := null;
      router.cores[coreIdx].utilizationRate *= 0.9;  // Decay utilization
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main heartbeat update for Lyapunov router
  public func heartbeatUpdate(
    router : RouterState,
    dynamics : (StateVector) -> [Float],
    dt : Float,
    analysisSteps : Nat,
    currentBeat : Int
  ) : {
    numChaotic : Nat;
    numStable : Nat;
    numEdge : Nat;
    maxLyapunov : Float;
    averageLyapunov : Float;
  } {
    var maxLambda : Float = -1000.0;
    var sumLambda : Float = 0.0;
    var count : Nat = 0;
    
    // Analyze each core
    for (i in Iter.range(0, router.cores.size() - 1)) {
      let core = router.cores[i];
      
      // Only analyze if not recently analyzed
      if (currentBeat - core.lastAnalysis > 10) {
        analyzeCoreStability(core, dynamics, dt, analysisSteps, currentBeat);
      };
      
      let lambda = core.spectrum.maxExponent;
      if (lambda > maxLambda) { maxLambda := lambda };
      sumLambda += lambda;
      count += 1;
    };
    
    // Update classifications
    updateCoreClassifications(router);
    router.lastRoutingUpdate := currentBeat;
    
    let avgLambda = if (count > 0) { sumLambda / Float.fromInt(count) } else { 0.0 };
    
    {
      numChaotic = router.chaoticCores.size();
      numStable = router.stableCores.size();
      numEdge = router.edgeCores.size();
      maxLyapunov = maxLambda;
      averageLyapunov = avgLambda;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get max Lyapunov exponent for a core
  public func getMaxLyapunov(router : RouterState, coreIdx : Nat) : Float {
    if (coreIdx < router.cores.size()) {
      router.cores[coreIdx].spectrum.maxExponent
    } else { 0.0 }
  };
  
  /// Get stability classification for a core
  public func getCoreStability(router : RouterState, coreIdx : Nat) : StabilityClass {
    if (coreIdx < router.cores.size()) {
      router.cores[coreIdx].stabilityClass
    } else { #Unknown }
  };
  
  /// Get chaotic core count
  public func getChaoticCoreCount(router : RouterState) : Nat {
    router.chaoticCores.size()
  };
  
  /// Get stable core count
  public func getStableCoreCount(router : RouterState) : Nat {
    router.stableCores.size()
  };
  
  /// Get edge-of-chaos core count
  public func getEdgeCoreCount(router : RouterState) : Nat {
    router.edgeCores.size()
  };
  
  /// Get Kolmogorov entropy for system (information production rate)
  public func getKolmogorovEntropy(router : RouterState) : Float {
    var totalEntropy : Float = 0.0;
    for (i in Iter.range(0, router.cores.size() - 1)) {
      totalEntropy += router.cores[i].spectrum.kolmogorovEntropy;
    };
    totalEntropy
  };
  
  /// Check if system is at edge of chaos (optimal computation)
  public func isAtEdgeOfChaos(router : RouterState) : Bool {
    var edgeCount : Nat = 0;
    var totalCount : Nat = 0;
    
    for (i in Iter.range(0, router.cores.size() - 1)) {
      switch (router.cores[i].stabilityClass) {
        case (#EdgeOfChaos) { edgeCount += 1 };
        case (#Unknown) {};
        case (_) { totalCount += 1 };
      };
      totalCount += 1;
    };
    
    if (totalCount > 0) {
      Float.fromInt(edgeCount) / Float.fromInt(totalCount) > 0.3
    } else { false }
  };

}
