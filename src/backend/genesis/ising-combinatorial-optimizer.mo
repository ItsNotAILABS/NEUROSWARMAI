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
// ISING COMBINATORIAL OPTIMIZER — REAL-TIME OPTIMIZATION VIA SPIN SYSTEMS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements an Ising model for combinatorial optimization, allowing the organism to solve
// NP-hard optimization problems in real-time through simulated annealing and spin dynamics.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// Ising Energy:         E = -Σᵢⱼ Jᵢⱼsᵢsⱼ - Σᵢ hᵢsᵢ
// Boltzmann:            P(state) ∝ exp(-E/kT)
// Metropolis:           P(flip) = min(1, exp(-ΔE/kT))
// Temperature Schedule: T(t) = T₀ × α^t (geometric cooling)
// Ground State:         argmin_s E(s) — optimal configuration
// Magnetization:        M = (1/N) Σᵢ sᵢ
// Susceptibility:       χ = ∂M/∂h = (1/kT)(⟨M²⟩ - ⟨M⟩²)
//
// OPTIMIZATION PROBLEMS MAPPED TO ISING:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • MAX-CUT:           Jᵢⱼ = -wᵢⱼ (edge weight), minimize E → maximize cut
// • Graph Coloring:    Jᵢⱼ = +1 for adjacent vertices of same color
// • Satisfiability:    Each clause maps to interaction terms
// • Traveling Salesman: City assignment variables with constraints
// • Resource Allocation: Binary assignment variables
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Maps organism decisions to Ising spin configurations
// • Provides real-time optimization for drive competition
// • Optimizes resource allocation (FORMA distribution)
// • Solves constraint satisfaction for workflow scheduling
// • Temperature tied to arousal state (high arousal = high T = exploration)
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

module IsingCombinatorialOptimizer {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  
  /// Boltzmann constant (normalized to 1 for our system)
  public let K_BOLTZMANN : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ISING LATTICE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Default lattice size
  public let DEFAULT_LATTICE_SIZE : Nat = 64;
  
  /// Maximum spin count for arbitrary graphs
  public let MAX_SPINS : Nat = 1024;
  
  /// Maximum iterations per optimization run
  public let MAX_ITERATIONS : Nat = 10000;
  
  /// Default initial temperature
  public let DEFAULT_T_INITIAL : Float = 10.0;
  
  /// Default final temperature
  public let DEFAULT_T_FINAL : Float = 0.01;
  
  /// Default cooling rate (geometric)
  public let DEFAULT_COOLING_RATE : Float = 0.99;
  
  /// S₀ floor integration
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SPIN TYPE — FUNDAMENTAL ISING VARIABLE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Ising spin: +1 or -1
  public type Spin = {
    #Up;    // +1
    #Down;  // -1
  };
  
  /// Convert spin to float value
  public func spinToFloat(s : Spin) : Float {
    switch (s) {
      case (#Up) { 1.0 };
      case (#Down) { -1.0 };
    }
  };
  
  /// Flip a spin
  public func flipSpin(s : Spin) : Spin {
    switch (s) {
      case (#Up) { #Down };
      case (#Down) { #Up };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LATTICE TOPOLOGY TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lattice topology for regular Ising models
  public type LatticeTopology = {
    #Square2D;      // Standard 2D square lattice
    #Triangular2D;  // Triangular lattice (6 neighbors)
    #Cubic3D;       // 3D cubic lattice
    #FullyConnected; // All-to-all (mean field)
    #Arbitrary;     // Custom graph (defined by J matrix)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COUPLING MATRIX TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Coupling matrix Jᵢⱼ for arbitrary Ising graphs
  public type CouplingMatrix = {
    var values : [[var Float]];  // Jᵢⱼ coupling strengths
    dimension : Nat;             // Number of spins
    var nonZeroCount : Nat;      // Number of non-zero couplings
    isSymmetric : Bool;          // J = J^T
  };
  
  /// External field vector hᵢ
  public type ExternalField = {
    var values : [var Float];
    dimension : Nat;
    var isUniform : Bool;
    var uniformValue : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ISING STATE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete Ising system state
  public type IsingState = {
    var spins : [var Spin];          // Current spin configuration
    numSpins : Nat;
    coupling : CouplingMatrix;       // Jᵢⱼ
    field : ExternalField;           // hᵢ
    var energy : Float;              // Current energy E
    var magnetization : Float;       // M = (1/N)Σsᵢ
    var temperature : Float;         // Current temperature T
    topology : LatticeTopology;
    var flipCount : Nat;             // Total spin flips
    var acceptCount : Nat;           // Accepted flips
    var lastUpdate : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ANNEALING SCHEDULE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Temperature annealing schedule
  public type AnnealingSchedule = {
    #Geometric;           // T(t) = T₀ × α^t
    #Linear;              // T(t) = T₀ - (T₀ - T_f) × t/t_max
    #Logarithmic;         // T(t) = T₀ / ln(2 + t)
    #Adaptive;            // Adjust based on acceptance rate
    #Boltzmann;           // T(t) = T₀ / (1 + ln(1 + t))
  };
  
  public type AnnealingParams = {
    schedule : AnnealingSchedule;
    initialTemp : Float;
    finalTemp : Float;
    coolingRate : Float;       // α for geometric
    maxIterations : Nat;
    equilibrationSteps : Nat;  // Steps at each temperature
    targetAcceptance : Float;  // For adaptive schedule
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OPTIMIZATION RESULT TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Result of Ising optimization
  public type OptimizationResult = {
    bestSpins : [Spin];
    bestEnergy : Float;
    finalEnergy : Float;
    iterationsUsed : Nat;
    acceptanceRate : Float;
    magnetization : Float;
    converged : Bool;
    energyHistory : [Float];  // Energy at each temperature step
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PROBLEM MAPPING TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Mapping from decision variables to Ising spins
  public type ProblemMapping = {
    #MaxCut : { edges : [(Nat, Nat, Float)] };  // (i, j, weight)
    #Satisfiability : { clauses : [[Int]] };     // CNF clauses (negative = negated)
    #GraphColoring : { edges : [(Nat, Nat)]; numColors : Nat };
    #ResourceAllocation : { costs : [[Float]]; constraints : [[Float]] };
    #DriveCompetition : { drives : [Float]; inhibition : [[Float]] };
    #Custom : { J : [[Float]]; h : [Float] };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize coupling matrix
  public func initCouplingMatrix(n : Nat) : CouplingMatrix {
    let values = Array.tabulate<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, 0.0)
    });
    
    {
      var values = values;
      dimension = n;
      var nonZeroCount = 0;
      isSymmetric = true;
    }
  };
  
  /// Initialize external field
  public func initExternalField(n : Nat, uniformValue : Float) : ExternalField {
    {
      var values = Array.init<Float>(n, uniformValue);
      dimension = n;
      var isUniform = true;
      var uniformValue = uniformValue;
    }
  };
  
  /// Initialize Ising state with random spins
  public func initIsingState(
    n : Nat,
    topology : LatticeTopology,
    initialTemp : Float,
    seed : Nat
  ) : IsingState {
    // Initialize random-ish spins based on seed
    let spins = Array.init<Spin>(n, func(i : Nat) : Spin {
      if ((seed + i * 7) % 2 == 0) { #Up } else { #Down }
    });
    
    let coupling = initCouplingMatrix(n);
    let field = initExternalField(n, 0.0);
    
    // Set coupling based on topology
    switch (topology) {
      case (#Square2D) {
        let side = Int.abs(Float.toInt(Float.sqrt(Float.fromInt(n))));
        setSquareLatticeCoupling(coupling, side);
      };
      case (#FullyConnected) {
        setFullyConnectedCoupling(coupling, -1.0 / Float.fromInt(n));  // Antiferromagnetic
      };
      case (#Arbitrary) {
        // Coupling will be set later
      };
      case (_) {
        // Default to no coupling
      };
    };
    
    let state : IsingState = {
      var spins = spins;
      numSpins = n;
      coupling = coupling;
      field = field;
      var energy = 0.0;
      var magnetization = 0.0;
      var temperature = initialTemp;
      topology = topology;
      var flipCount = 0;
      var acceptCount = 0;
      var lastUpdate = 0;
    };
    
    // Compute initial energy and magnetization
    state.energy := computeEnergy(state);
    state.magnetization := computeMagnetization(state);
    
    state
  };
  
  /// Set coupling for 2D square lattice (ferromagnetic J = 1)
  func setSquareLatticeCoupling(coupling : CouplingMatrix, side : Int) : () {
    let n = side * side;
    var nonZero : Nat = 0;
    
    for (i in Iter.range(0, Int.abs(n) - 1)) {
      let row = i / Int.abs(side);
      let col = i % Int.abs(side);
      
      // Right neighbor
      if (col < Int.abs(side) - 1) {
        coupling.values[i][i + 1] := 1.0;
        coupling.values[i + 1][i] := 1.0;
        nonZero += 2;
      };
      
      // Down neighbor
      if (row < Int.abs(side) - 1) {
        coupling.values[i][i + Int.abs(side)] := 1.0;
        coupling.values[i + Int.abs(side)][i] := 1.0;
        nonZero += 2;
      };
    };
    
    coupling.nonZeroCount := nonZero;
  };
  
  /// Set fully connected coupling
  func setFullyConnectedCoupling(coupling : CouplingMatrix, strength : Float) : () {
    var nonZero : Nat = 0;
    
    for (i in Iter.range(0, coupling.dimension - 1)) {
      for (j in Iter.range(i + 1, coupling.dimension - 1)) {
        coupling.values[i][j] := strength;
        coupling.values[j][i] := strength;
        nonZero += 2;
      };
    };
    
    coupling.nonZeroCount := nonZero;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY COMPUTATION — THE ISING HAMILTONIAN
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute total energy: E = -Σᵢⱼ Jᵢⱼsᵢsⱼ - Σᵢ hᵢsᵢ
  public func computeEnergy(state : IsingState) : Float {
    var energy : Float = 0.0;
    let n = state.numSpins;
    
    // Interaction term: -Σᵢⱼ Jᵢⱼsᵢsⱼ
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let Jij = state.coupling.values[i][j];
        if (Jij != 0.0) {
          let si = spinToFloat(state.spins[i]);
          let sj = spinToFloat(state.spins[j]);
          energy -= Jij * si * sj;
        };
      };
    };
    
    // External field term: -Σᵢ hᵢsᵢ
    for (i in Iter.range(0, n - 1)) {
      let hi = state.field.values[i];
      if (hi != 0.0) {
        let si = spinToFloat(state.spins[i]);
        energy -= hi * si;
      };
    };
    
    energy
  };
  
  /// Compute energy change from flipping spin i
  /// ΔE = 2sᵢ(Σⱼ Jᵢⱼsⱼ + hᵢ)
  public func computeDeltaEnergy(state : IsingState, i : Nat) : Float {
    let si = spinToFloat(state.spins[i]);
    var localField : Float = 0.0;
    
    // Sum of coupling contributions from neighbors
    for (j in Iter.range(0, state.numSpins - 1)) {
      if (i != j) {
        let Jij = state.coupling.values[i][j];
        if (Jij != 0.0) {
          let sj = spinToFloat(state.spins[j]);
          localField += Jij * sj;
        };
      };
    };
    
    // Add external field
    localField += state.field.values[i];
    
    // ΔE = 2sᵢ × (local field)
    2.0 * si * localField
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAGNETIZATION — ORDER PARAMETER
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute magnetization: M = (1/N)Σsᵢ
  public func computeMagnetization(state : IsingState) : Float {
    var sum : Float = 0.0;
    for (i in Iter.range(0, state.numSpins - 1)) {
      sum += spinToFloat(state.spins[i]);
    };
    sum / Float.fromInt(state.numSpins)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // METROPOLIS-HASTINGS DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Perform one Metropolis-Hastings step
  /// P(accept) = min(1, exp(-ΔE/kT))
  public func metropolisStep(
    state : IsingState,
    spinIndex : Nat,
    randomValue : Float  // Random number in [0, 1)
  ) : Bool {
    if (spinIndex >= state.numSpins) { return false };
    
    let deltaE = computeDeltaEnergy(state, spinIndex);
    
    var accept = false;
    
    if (deltaE <= 0.0) {
      // Always accept energy-lowering moves
      accept := true;
    } else {
      // Accept with Boltzmann probability
      let beta = 1.0 / (K_BOLTZMANN * state.temperature);
      let acceptProb = Float.exp(-beta * deltaE);
      accept := randomValue < acceptProb;
    };
    
    if (accept) {
      // Flip the spin
      state.spins[spinIndex] := flipSpin(state.spins[spinIndex]);
      state.energy += deltaE;
      state.flipCount += 1;
      state.acceptCount += 1;
      
      // Update magnetization incrementally
      let deltaMag = -2.0 * spinToFloat(flipSpin(state.spins[spinIndex])) / Float.fromInt(state.numSpins);
      state.magnetization += deltaMag;
    };
    
    accept
  };
  
  /// Perform one Monte Carlo sweep (N Metropolis steps)
  public func monteCarloSweep(
    state : IsingState,
    randomSeed : Nat
  ) : Nat {
    var accepted : Nat = 0;
    let n = state.numSpins;
    
    // Attempt to flip each spin once (on average)
    for (step in Iter.range(0, n - 1)) {
      // Simple pseudo-random selection
      let spinIdx = (randomSeed * 1103515245 + step * 12345) % n;
      let randomVal = Float.fromInt((randomSeed * 48271 + step * 22695477) % 1000000) / 1000000.0;
      
      if (metropolisStep(state, spinIdx, randomVal)) {
        accepted += 1;
      };
    };
    
    accepted
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPERATURE SCHEDULES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update temperature according to schedule
  public func updateTemperature(
    currentTemp : Float,
    iteration : Nat,
    params : AnnealingParams
  ) : Float {
    switch (params.schedule) {
      case (#Geometric) {
        // T(t) = T₀ × α^t
        currentTemp * params.coolingRate
      };
      case (#Linear) {
        // T(t) = T₀ - (T₀ - T_f) × t/t_max
        let progress = Float.fromInt(iteration) / Float.fromInt(params.maxIterations);
        params.initialTemp - (params.initialTemp - params.finalTemp) * progress
      };
      case (#Logarithmic) {
        // T(t) = T₀ / ln(2 + t)
        params.initialTemp / Float.log(2.0 + Float.fromInt(iteration))
      };
      case (#Boltzmann) {
        // T(t) = T₀ / (1 + ln(1 + t))
        params.initialTemp / (1.0 + Float.log(1.0 + Float.fromInt(iteration)))
      };
      case (#Adaptive) {
        // Adjust based on acceptance rate (implemented in optimization loop)
        currentTemp * params.coolingRate
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SIMULATED ANNEALING — MAIN OPTIMIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run simulated annealing optimization
  public func simulatedAnnealing(
    state : IsingState,
    params : AnnealingParams,
    randomSeed : Nat
  ) : OptimizationResult {
    var bestEnergy = state.energy;
    let bestSpins = Array.init<Spin>(state.numSpins, #Up);
    
    // Copy initial spins to best
    for (i in Iter.range(0, state.numSpins - 1)) {
      bestSpins[i] := state.spins[i];
    };
    
    let energyHistory = Buffer.Buffer<Float>(params.maxIterations / 10);
    var iteration : Nat = 0;
    var totalAccepted : Nat = 0;
    var converged = false;
    var seed = randomSeed;
    
    // Main annealing loop
    while (iteration < params.maxIterations and state.temperature > params.finalTemp) {
      // Equilibrate at current temperature
      var eqAccepted : Nat = 0;
      for (eq in Iter.range(0, params.equilibrationSteps - 1)) {
        seed := (seed * 1103515245 + 12345) % 2147483647;
        eqAccepted += monteCarloSweep(state, seed);
      };
      totalAccepted += eqAccepted;
      
      // Check for new best
      if (state.energy < bestEnergy) {
        bestEnergy := state.energy;
        for (i in Iter.range(0, state.numSpins - 1)) {
          bestSpins[i] := state.spins[i];
        };
      };
      
      // Record energy periodically
      if (iteration % 10 == 0) {
        energyHistory.add(state.energy);
      };
      
      // Adaptive schedule: adjust cooling rate based on acceptance
      let newTemp = switch (params.schedule) {
        case (#Adaptive) {
          let acceptRate = Float.fromInt(eqAccepted) / 
                          Float.fromInt(params.equilibrationSteps * state.numSpins);
          if (acceptRate > params.targetAcceptance + 0.1) {
            // Too many accepts → cool faster
            state.temperature * (params.coolingRate - 0.01)
          } else if (acceptRate < params.targetAcceptance - 0.1) {
            // Too few accepts → cool slower
            state.temperature * (params.coolingRate + 0.01)
          } else {
            state.temperature * params.coolingRate
          }
        };
        case (_) {
          updateTemperature(state.temperature, iteration, params)
        };
      };
      
      state.temperature := Float.max(newTemp, params.finalTemp);
      iteration += 1;
      
      // Check for convergence (no improvement for many iterations)
      if (energyHistory.size() > 100) {
        let recent = energyHistory.get(energyHistory.size() - 1);
        let old = energyHistory.get(energyHistory.size() - 100);
        if (Float.abs(recent - old) < 1e-6) {
          converged := true;
          // break not available, use early termination via while condition
          iteration := params.maxIterations;
        };
      };
    };
    
    let totalSteps = iteration * params.equilibrationSteps * state.numSpins;
    
    {
      bestSpins = Array.freeze(bestSpins);
      bestEnergy = bestEnergy;
      finalEnergy = state.energy;
      iterationsUsed = iteration;
      acceptanceRate = Float.fromInt(totalAccepted) / Float.fromInt(totalSteps);
      magnetization = computeMagnetization(state);
      converged = converged;
      energyHistory = Buffer.toArray(energyHistory);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PROBLEM MAPPING — CONVERT DECISIONS TO ISING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Map MAX-CUT problem to Ising model
  public func mapMaxCut(
    edges : [(Nat, Nat, Float)],
    numVertices : Nat
  ) : IsingState {
    let state = initIsingState(numVertices, #Arbitrary, DEFAULT_T_INITIAL, 12345);
    
    // For MAX-CUT: minimize E = -Σᵢⱼ wᵢⱼ × ½(1 - sᵢsⱼ)
    // This is equivalent to: E = -Σᵢⱼ (-wᵢⱼ/2)sᵢsⱼ + const
    // So Jᵢⱼ = wᵢⱼ/2 (positive coupling)
    for ((i, j, w) in edges.vals()) {
      if (i < numVertices and j < numVertices) {
        state.coupling.values[i][j] := w / 2.0;
        state.coupling.values[j][i] := w / 2.0;
      };
    };
    
    state.energy := computeEnergy(state);
    state
  };
  
  /// Map drive competition to Ising model
  /// Drives compete for activation, inhibition encoded as coupling
  public func mapDriveCompetition(
    driveStrengths : [Float],
    inhibitionMatrix : [[Float]]
  ) : IsingState {
    let n = driveStrengths.size();
    let state = initIsingState(n, #Arbitrary, DEFAULT_T_INITIAL, 12345);
    
    // External field = drive strength (bias toward activation)
    for (i in Iter.range(0, n - 1)) {
      state.field.values[i] := driveStrengths[i];
    };
    
    // Coupling = -inhibition (negative coupling = competition)
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j and i < inhibitionMatrix.size() and j < inhibitionMatrix[i].size()) {
          state.coupling.values[i][j] := -inhibitionMatrix[i][j];
        };
      };
    };
    
    state.energy := computeEnergy(state);
    state
  };
  
  /// Map resource allocation to Ising model
  public func mapResourceAllocation(
    costs : [[Float]],     // costs[i][j] = cost of assigning resource i to task j
    constraints : [[Float]] // constraint matrix
  ) : IsingState {
    // Create binary variables for each (resource, task) pair
    let numResources = costs.size();
    let numTasks = if (costs.size() > 0) { costs[0].size() } else { 0 };
    let n = numResources * numTasks;
    
    let state = initIsingState(n, #Arbitrary, DEFAULT_T_INITIAL, 12345);
    
    // External field = -cost (prefer lower cost assignments)
    for (i in Iter.range(0, numResources - 1)) {
      for (j in Iter.range(0, numTasks - 1)) {
        let idx = i * numTasks + j;
        state.field.values[idx] := -costs[i][j];
      };
    };
    
    // Coupling enforces constraints (one resource per task, one task per resource)
    // Penalize if same resource assigned to multiple tasks
    for (i in Iter.range(0, numResources - 1)) {
      for (j1 in Iter.range(0, numTasks - 1)) {
        for (j2 in Iter.range(j1 + 1, numTasks - 1)) {
          let idx1 = i * numTasks + j1;
          let idx2 = i * numTasks + j2;
          state.coupling.values[idx1][idx2] := -10.0;  // Strong penalty
          state.coupling.values[idx2][idx1] := -10.0;
        };
      };
    };
    
    // Penalize if same task assigned to multiple resources
    for (j in Iter.range(0, numTasks - 1)) {
      for (i1 in Iter.range(0, numResources - 1)) {
        for (i2 in Iter.range(i1 + 1, numResources - 1)) {
          let idx1 = i1 * numTasks + j;
          let idx2 = i2 * numTasks + j;
          state.coupling.values[idx1][idx2] := -10.0;
          state.coupling.values[idx2][idx1] := -10.0;
        };
      };
    };
    
    state.energy := computeEnergy(state);
    state
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SOLUTION EXTRACTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Extract MAX-CUT solution from spins
  public func extractMaxCutSolution(spins : [Spin]) : ([Nat], [Nat]) {
    let setA = Buffer.Buffer<Nat>(spins.size());
    let setB = Buffer.Buffer<Nat>(spins.size());
    
    for (i in Iter.range(0, spins.size() - 1)) {
      switch (spins[i]) {
        case (#Up) { setA.add(i) };
        case (#Down) { setB.add(i) };
      };
    };
    
    (Buffer.toArray(setA), Buffer.toArray(setB))
  };
  
  /// Extract drive competition winner(s) from spins
  public func extractActiveDrives(spins : [Spin]) : [Nat] {
    let active = Buffer.Buffer<Nat>(spins.size());
    
    for (i in Iter.range(0, spins.size() - 1)) {
      switch (spins[i]) {
        case (#Up) { active.add(i) };
        case (#Down) {};
      };
    };
    
    Buffer.toArray(active)
  };
  
  /// Extract resource allocation from spins
  public func extractResourceAllocation(
    spins : [Spin],
    numResources : Nat,
    numTasks : Nat
  ) : [(Nat, Nat)] {
    let assignments = Buffer.Buffer<(Nat, Nat)>(numResources);
    
    for (i in Iter.range(0, numResources - 1)) {
      for (j in Iter.range(0, numTasks - 1)) {
        let idx = i * numTasks + j;
        if (idx < spins.size()) {
          switch (spins[idx]) {
            case (#Up) { assignments.add((i, j)) };
            case (#Down) {};
          };
        };
      };
    };
    
    Buffer.toArray(assignments)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUICK OPTIMIZATION — SINGLE-CALL INTERFACE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Quick MAX-CUT optimization
  public func optimizeMaxCut(
    edges : [(Nat, Nat, Float)],
    numVertices : Nat,
    maxIter : Nat
  ) : {
    setA : [Nat];
    setB : [Nat];
    cutValue : Float;
  } {
    let state = mapMaxCut(edges, numVertices);
    let params : AnnealingParams = {
      schedule = #Geometric;
      initialTemp = DEFAULT_T_INITIAL;
      finalTemp = DEFAULT_T_FINAL;
      coolingRate = DEFAULT_COOLING_RATE;
      maxIterations = maxIter;
      equilibrationSteps = 10;
      targetAcceptance = 0.3;
    };
    
    let result = simulatedAnnealing(state, params, Time.now() % 1000000);
    let (setA, setB) = extractMaxCutSolution(result.bestSpins);
    
    // Compute cut value
    var cutValue : Float = 0.0;
    for ((i, j, w) in edges.vals()) {
      let inA_i = Array.indexOf<Nat>(i, setA, Nat.equal);
      let inA_j = Array.indexOf<Nat>(j, setA, Nat.equal);
      switch (inA_i, inA_j) {
        case (?_, null) { cutValue += w };  // i in A, j in B
        case (null, ?_) { cutValue += w };  // i in B, j in A
        case (_, _) {};  // Both in same set
      };
    };
    
    { setA = setA; setB = setB; cutValue = cutValue }
  };
  
  /// Quick drive competition optimization
  public func optimizeDriveCompetition(
    driveStrengths : [Float],
    inhibitionMatrix : [[Float]],
    maxIter : Nat
  ) : {
    activeDrives : [Nat];
    totalActivation : Float;
  } {
    let state = mapDriveCompetition(driveStrengths, inhibitionMatrix);
    let params : AnnealingParams = {
      schedule = #Geometric;
      initialTemp = 5.0;  // Lower initial temp for faster convergence
      finalTemp = 0.1;
      coolingRate = 0.95;
      maxIterations = maxIter;
      equilibrationSteps = 5;
      targetAcceptance = 0.3;
    };
    
    let result = simulatedAnnealing(state, params, Time.now() % 1000000);
    let active = extractActiveDrives(result.bestSpins);
    
    var totalActivation : Float = 0.0;
    for (i in active.vals()) {
      if (i < driveStrengths.size()) {
        totalActivation += driveStrengths[i];
      };
    };
    
    { activeDrives = active; totalActivation = totalActivation }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATION WITH ORGANISM — HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Optimizer state for organism integration
  public type OptimizerState = {
    var currentProblem : ?IsingState;
    var lastResult : ?OptimizationResult;
    var totalOptimizations : Nat;
    var totalIterations : Nat;
    var averageAcceptance : Float;
    var lastOptimizationBeat : Int;
  };
  
  /// Initialize optimizer state
  public func initOptimizerState() : OptimizerState {
    {
      var currentProblem = null;
      var lastResult = null;
      var totalOptimizations = 0;
      var totalIterations = 0;
      var averageAcceptance = 0.0;
      var lastOptimizationBeat = 0;
    }
  };
  
  /// Main heartbeat update for Ising optimizer
  public func heartbeatUpdate(
    optState : OptimizerState,
    problem : ProblemMapping,
    arousalLevel : Float,  // High arousal = high temperature (exploration)
    currentBeat : Int
  ) : ?OptimizationResult {
    // Map arousal to temperature (higher arousal = more exploration)
    let baseTemp = 1.0 + 9.0 * arousalLevel;  // 1.0 to 10.0
    let coolingRate = 0.95 + 0.04 * (1.0 - arousalLevel);  // Slower cooling when calm
    
    // Create Ising state from problem
    let state = switch (problem) {
      case (#MaxCut(p)) {
        let numVerts = if (p.edges.size() > 0) {
          var maxV : Nat = 0;
          for ((i, j, _) in p.edges.vals()) {
            if (i > maxV) { maxV := i };
            if (j > maxV) { maxV := j };
          };
          maxV + 1
        } else { 0 };
        mapMaxCut(p.edges, numVerts)
      };
      case (#DriveCompetition(p)) {
        mapDriveCompetition(p.drives, p.inhibition)
      };
      case (#ResourceAllocation(p)) {
        mapResourceAllocation(p.costs, p.constraints)
      };
      case (#Custom(p)) {
        let n = p.h.size();
        let state = initIsingState(n, #Arbitrary, baseTemp, Int.abs(currentBeat) % 1000000);
        for (i in Iter.range(0, n - 1)) {
          state.field.values[i] := p.h[i];
          for (j in Iter.range(0, n - 1)) {
            if (i < p.J.size() and j < p.J[i].size()) {
              state.coupling.values[i][j] := p.J[i][j];
            };
          };
        };
        state.energy := computeEnergy(state);
        state
      };
      case (_) {
        // Unsupported problem type
        return null;
      };
    };
    
    let params : AnnealingParams = {
      schedule = #Geometric;
      initialTemp = baseTemp;
      finalTemp = 0.01;
      coolingRate = coolingRate;
      maxIterations = 100;  // Limited per heartbeat
      equilibrationSteps = 5;
      targetAcceptance = 0.3;
    };
    
    let result = simulatedAnnealing(state, params, Int.abs(currentBeat) % 1000000);
    
    // Update state
    optState.currentProblem := ?state;
    optState.lastResult := ?result;
    optState.totalOptimizations += 1;
    optState.totalIterations += result.iterationsUsed;
    optState.averageAcceptance := (optState.averageAcceptance * 
      Float.fromInt(optState.totalOptimizations - 1) + result.acceptanceRate) / 
      Float.fromInt(optState.totalOptimizations);
    optState.lastOptimizationBeat := currentBeat;
    
    ?result
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get current energy
  public func getEnergy(state : IsingState) : Float {
    state.energy
  };
  
  /// Get current magnetization
  public func getMagnetization(state : IsingState) : Float {
    state.magnetization
  };
  
  /// Get current temperature
  public func getTemperature(state : IsingState) : Float {
    state.temperature
  };
  
  /// Get spin configuration as array of floats (+1/-1)
  public func getSpinConfiguration(state : IsingState) : [Float] {
    Array.tabulate<Float>(state.numSpins, func(i : Nat) : Float {
      spinToFloat(state.spins[i])
    })
  };
  
  /// Get acceptance rate
  public func getAcceptanceRate(state : IsingState) : Float {
    if (state.flipCount > 0) {
      Float.fromInt(state.acceptCount) / Float.fromInt(state.flipCount)
    } else { 0.0 }
  };

}
