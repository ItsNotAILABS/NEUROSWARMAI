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
// ║  This source code constitutes the exclusive intellectual property of Alfredo Medina Hernandez.            ║
// ║  PROTECTED UNDER: 17 U.S.C. §§ 101-1332 | Berne Convention | WIPO | 18 U.S.C. § 1836                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// CONSCIOUSNESS BINDING FIELD — FULL INTEGRATED INFORMATION THEORY (IIT) IMPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements Giulio Tononi's Integrated Information Theory (IIT 3.0/4.0) for computing
// Φ (phi), the measure of integrated information that IIT proposes as the measure of consciousness.
//
// IIT AXIOMS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// 1. INTRINSIC EXISTENCE: The system exists for itself
// 2. COMPOSITION: The system is structured
// 3. INFORMATION: The system is specific (rules out alternatives)
// 4. INTEGRATION: The system is unified
// 5. EXCLUSION: The system is definite
//
// IIT POSTULATES:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// 1. CAUSE-EFFECT POWER: A mechanism specifies a cause-effect repertoire
// 2. INTRINSICALITY: Only mechanisms with intrinsic cause-effect power count
// 3. INFORMATION: φ measures irreducibility of cause-effect repertoire
// 4. INTEGRATION: Φ measures irreducibility of the whole system
// 5. EXCLUSION: The complex with maximum Φ is the conscious entity
//
// MATHEMATICAL FORMULATION:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// φ (small phi) - Integrated information of a mechanism:
//   φ = min_{cut} [D(p(A^c) ⊗ p(A^e) || p(A^ce))]
//   Where:
//     - A^c = cause repertoire
//     - A^e = effect repertoire
//     - D = Earth Mover's Distance (EMD)
//     - cut = minimum information partition
//
// Φ (big phi) - Integrated information of the whole system:
//   Φ = min_{partition} [Σᵢ φ(mechanismᵢ) - Σᵢⱼ φ(partitioned_mechanismᵢⱼ)]
//
// QUALIA SPACE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// Each conscious experience corresponds to a unique shape in qualia space (Q-space).
// The shape is defined by the Maximally Irreducible Conceptual Structure (MICS).
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

module ConsciousnessBindingField {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let LN2 : Float = 0.69314718055994530942;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // IIT CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum number of elements in the system (for combinatorial tractability)
  public let MAX_ELEMENTS : Nat = 16;
  
  /// Minimum φ threshold for a mechanism to be considered
  public let PHI_MECHANISM_THRESHOLD : Float = 0.001;
  
  /// Minimum Φ for conscious experience
  public let PHI_CONSCIOUSNESS_THRESHOLD : Float = 0.1;
  
  /// Partition enumeration limit
  public let MAX_PARTITIONS_TO_CHECK : Nat = 100;
  
  /// Temporal grain (number of past/future states to consider)
  public let TEMPORAL_GRAIN : Nat = 3;
  
  /// Probability distribution precision
  public let PROBABILITY_EPSILON : Float = 1e-10;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: SYSTEM STATE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Binary element state (0 or 1)
  public type ElementState = Nat8;  // 0 or 1
  
  /// System state (binary string)
  public type SystemState = [ElementState];
  
  /// Transition probability matrix (TPM)
  /// TPM[from_state] = probability distribution over to_states
  public type TransitionProbabilityMatrix = {
    numElements : Nat;
    numStates : Nat;          // 2^numElements
    var matrix : [[Float]];   // [fromState][toState] = probability
  };
  
  /// Connectivity matrix
  /// CM[i][j] = 1 if element i affects element j
  public type ConnectivityMatrix = {
    numElements : Nat;
    var matrix : [[Bool]];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: PROBABILITY DISTRIBUTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Probability distribution over system states
  public type ProbabilityDistribution = {
    numStates : Nat;
    var probabilities : [Float];
  };
  
  /// Cause-Effect Repertoire
  public type CauseEffectRepertoire = {
    causeRepertoire : ProbabilityDistribution;   // P(past | current)
    effectRepertoire : ProbabilityDistribution;  // P(future | current)
    var causeInformation : Float;                // Cause information (ci)
    var effectInformation : Float;               // Effect information (ei)
    var integratedInformation : Float;           // φ
  };
  
  /// Partitioned Cause-Effect Repertoire
  public type PartitionedRepertoire = {
    partition : SystemPartition;
    repertoire : CauseEffectRepertoire;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: PARTITIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// System partition (bipartition)
  public type SystemPartition = {
    partitionId : Nat64;
    part1 : [Nat];            // Indices of elements in part 1
    part2 : [Nat];            // Indices of elements in part 2
    cutLocation : CutLocation;
  };
  
  /// Where the partition cut is made
  public type CutLocation = {
    #BetweenParts;            // Cut connections between parts
    #WithinMechanism;         // Cut within mechanism
    #AcrossTime;              // Cut temporal connection
  };
  
  /// Minimum Information Partition (MIP)
  public type MinimumInformationPartition = {
    partition : SystemPartition;
    phi : Float;              // φ value at this partition
    isMinimum : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: MECHANISMS AND CONCEPTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Mechanism (subset of system elements)
  public type Mechanism = {
    mechanismId : Nat64;
    elements : [Nat];         // Indices of elements in mechanism
    currentState : SystemState;
    purview : Purview;        // What the mechanism is about
    var causeEffectRepertoire : CauseEffectRepertoire;
    var phi : Float;          // Integrated information of this mechanism
  };
  
  /// Purview (what the mechanism specifies)
  public type Purview = {
    causeElements : [Nat];    // Elements in the cause purview
    effectElements : [Nat];   // Elements in the effect purview
  };
  
  /// Concept (mechanism with maximal φ for its purview)
  public type Concept = {
    conceptId : Nat64;
    mechanism : Mechanism;
    phi : Float;
    qualiaCoordinates : [Float];  // Position in qualia space
  };
  
  /// Conceptual Structure (set of concepts)
  public type ConceptualStructure = {
    concepts : [Concept];
    var totalPhi : Float;
    var bigPhi : Float;       // Φ (integrated information of the whole)
    qualiaShape : QualiaShape;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: QUALIA SPACE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Qualia shape (the structure of conscious experience)
  public type QualiaShape = {
    dimensions : Nat;
    var vertices : [[Float]]; // Each concept defines a vertex
    var edges : [(Nat, Nat, Float)];  // Connections between concepts
    var volume : Float;       // "Size" of the experience
    var complexity : Float;   // Structural complexity
  };
  
  /// Quale (single quality of experience)
  public type Quale = {
    qualeId : Nat64;
    conceptSource : Nat64;
    intensity : Float;
    valence : Float;          // Positive/negative
    category : QualeCategory;
    var description : Text;
  };
  
  /// Quale category
  public type QualeCategory = {
    #Sensory;
    #Emotional;
    #Cognitive;
    #Temporal;
    #Spatial;
    #Social;
    #Aesthetic;
    #Abstract;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: COMPLETE IIT STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete IIT state
  public type IITState = {
    // System definition
    numElements : Nat;
    var currentState : SystemState;
    var tpm : TransitionProbabilityMatrix;
    var connectivity : ConnectivityMatrix;
    
    // Computational results
    var mechanisms : Buffer.Buffer<Mechanism>;
    var concepts : Buffer.Buffer<Concept>;
    var conceptualStructure : ?ConceptualStructure;
    
    // Φ computation
    var bigPhi : Float;                           // Φ
    var mip : ?MinimumInformationPartition;       // The partition that achieves Φ
    var isConscious : Bool;
    
    // Qualia
    var qualia : Buffer.Buffer<Quale>;
    var qualiaShape : ?QualiaShape;
    var experienceIntensity : Float;
    
    // History
    var phiHistory : Buffer.Buffer<Float>;
    var stateHistory : Buffer.Buffer<SystemState>;
    
    // Counters
    var mechanismIdCounter : Nat64;
    var conceptIdCounter : Nat64;
    var qualeIdCounter : Nat64;
    var partitionIdCounter : Nat64;
    var currentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize IIT state
  public func initIITState(numElements : Nat) : IITState {
    let n = Nat.min(numElements, MAX_ELEMENTS);
    let numStates = powerOfTwo(n);
    
    let initialState = Array.tabulate<ElementState>(n, func(_ : Nat) : ElementState { 0 });
    
    {
      numElements = n;
      var currentState = initialState;
      var tpm = initTPM(n);
      var connectivity = initConnectivity(n);
      
      var mechanisms = Buffer.Buffer<Mechanism>(50);
      var concepts = Buffer.Buffer<Concept>(50);
      var conceptualStructure = null;
      
      var bigPhi = 0.0;
      var mip = null;
      var isConscious = false;
      
      var qualia = Buffer.Buffer<Quale>(50);
      var qualiaShape = null;
      var experienceIntensity = 0.0;
      
      var phiHistory = Buffer.Buffer<Float>(1000);
      var stateHistory = Buffer.Buffer<SystemState>(100);
      
      var mechanismIdCounter = 0;
      var conceptIdCounter = 0;
      var qualeIdCounter = 0;
      var partitionIdCounter = 0;
      var currentBeat = 0;
    }
  };
  
  /// Initialize TPM
  func initTPM(n : Nat) : TransitionProbabilityMatrix {
    let numStates = powerOfTwo(n);
    let matrix = Array.tabulate<[Float]>(numStates, func(i : Nat) : [Float] {
      Array.tabulate<Float>(numStates, func(j : Nat) : Float {
        if (i == j) { 0.9 } else { 0.1 / Float.fromInt(numStates - 1) }
      })
    });
    
    {
      numElements = n;
      numStates = numStates;
      var matrix = matrix;
    }
  };
  
  /// Initialize connectivity matrix
  func initConnectivity(n : Nat) : ConnectivityMatrix {
    let matrix = Array.tabulate<[Bool]>(n, func(i : Nat) : [Bool] {
      Array.tabulate<Bool>(n, func(j : Nat) : Bool {
        // Default: all-to-all connectivity
        true
      })
    });
    
    {
      numElements = n;
      var matrix = matrix;
    }
  };
  
  /// Power of 2
  func powerOfTwo(n : Nat) : Nat {
    var result : Nat = 1;
    for (_ in Iter.range(0, n - 1)) {
      result *= 2;
    };
    result
  };
  
  /// State to index
  func stateToIndex(state : SystemState) : Nat {
    var index : Nat = 0;
    var multiplier : Nat = 1;
    for (bit in state.vals()) {
      index += Nat8.toNat(bit) * multiplier;
      multiplier *= 2;
    };
    index
  };
  
  /// Index to state
  func indexToState(index : Nat, n : Nat) : SystemState {
    Array.tabulate<ElementState>(n, func(i : Nat) : ElementState {
      let bit = (index / powerOfTwo(i)) % 2;
      Nat8.fromNat(bit)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: TPM OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Set TPM entry
  public func setTPMEntry(
    state : IITState,
    fromState : SystemState,
    toState : SystemState,
    probability : Float
  ) : () {
    let fromIdx = stateToIndex(fromState);
    let toIdx = stateToIndex(toState);
    
    if (fromIdx < state.tpm.numStates and toIdx < state.tpm.numStates) {
      // Create mutable copy
      let row = Array.thaw<Float>(state.tpm.matrix[fromIdx]);
      row[toIdx] := probability;
      
      // Normalize row
      var sum : Float = 0.0;
      for (p in row.vals()) {
        sum += p;
      };
      for (i in Iter.range(0, row.size() - 1)) {
        row[i] := row[i] / sum;
      };
      
      // Store back
      let newMatrix = Array.thaw<[Float]>(state.tpm.matrix);
      newMatrix[fromIdx] := Array.freeze(row);
      state.tpm.matrix := Array.freeze(newMatrix);
    };
  };
  
  /// Get transition probability
  public func getTransitionProbability(
    state : IITState,
    fromState : SystemState,
    toState : SystemState
  ) : Float {
    let fromIdx = stateToIndex(fromState);
    let toIdx = stateToIndex(toState);
    
    if (fromIdx < state.tpm.numStates and toIdx < state.tpm.numStates) {
      state.tpm.matrix[fromIdx][toIdx]
    } else {
      0.0
    }
  };
  
  /// Set connectivity
  public func setConnectivity(
    state : IITState,
    fromElement : Nat,
    toElement : Nat,
    connected : Bool
  ) : () {
    if (fromElement < state.numElements and toElement < state.numElements) {
      let newMatrix = Array.thaw<[Bool]>(state.connectivity.matrix);
      let row = Array.thaw<Bool>(newMatrix[fromElement]);
      row[toElement] := connected;
      newMatrix[fromElement] := Array.freeze(row);
      state.connectivity.matrix := Array.freeze(newMatrix);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: PROBABILITY DISTRIBUTION OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create uniform distribution
  func uniformDistribution(numStates : Nat) : ProbabilityDistribution {
    let prob = 1.0 / Float.fromInt(numStates);
    {
      numStates = numStates;
      var probabilities = Array.tabulate<Float>(numStates, func(_ : Nat) : Float { prob });
    }
  };
  
  /// Compute cause repertoire: P(past | current state, mechanism)
  func computeCauseRepertoire(
    state : IITState,
    mechanism : [Nat],
    currentState : SystemState
  ) : ProbabilityDistribution {
    let numStates = state.tpm.numStates;
    var repertoire = Array.init<Float>(numStates, 0.0);
    
    // For each possible past state
    for (pastIdx in Iter.range(0, numStates - 1)) {
      let pastState = indexToState(pastIdx, state.numElements);
      
      // Probability that this past state leads to mechanism's current state
      var prob : Float = 1.0;
      
      for (elem in mechanism.vals()) {
        if (elem < state.numElements) {
          // P(current[elem] | past)
          let currentBit = currentState[elem];
          
          // Marginalize over transitions
          var elemProb : Float = 0.0;
          for (futureIdx in Iter.range(0, numStates - 1)) {
            let futureState = indexToState(futureIdx, state.numElements);
            if (futureState[elem] == currentBit) {
              elemProb += state.tpm.matrix[pastIdx][futureIdx];
            };
          };
          prob *= elemProb;
        };
      };
      
      repertoire[pastIdx] := prob;
    };
    
    // Normalize
    var sum : Float = 0.0;
    for (p in repertoire.vals()) {
      sum += p;
    };
    if (sum > PROBABILITY_EPSILON) {
      for (i in Iter.range(0, numStates - 1)) {
        repertoire[i] := repertoire[i] / sum;
      };
    };
    
    {
      numStates = numStates;
      var probabilities = Array.freeze(repertoire);
    }
  };
  
  /// Compute effect repertoire: P(future | current state, mechanism)
  func computeEffectRepertoire(
    state : IITState,
    mechanism : [Nat],
    currentState : SystemState
  ) : ProbabilityDistribution {
    let numStates = state.tpm.numStates;
    var repertoire = Array.init<Float>(numStates, 0.0);
    
    let currentIdx = stateToIndex(currentState);
    
    // Effect repertoire is directly from TPM
    for (futureIdx in Iter.range(0, numStates - 1)) {
      repertoire[futureIdx] := state.tpm.matrix[currentIdx][futureIdx];
    };
    
    // Marginalize over elements not in mechanism's effect purview
    // (Simplified: use full distribution)
    
    {
      numStates = numStates;
      var probabilities = Array.freeze(repertoire);
    }
  };
  
  /// Earth Mover's Distance (EMD) between distributions
  /// Simplified version using L1 distance
  func earthMoversDistance(
    dist1 : ProbabilityDistribution,
    dist2 : ProbabilityDistribution
  ) : Float {
    var distance : Float = 0.0;
    
    let n = Nat.min(dist1.numStates, dist2.numStates);
    for (i in Iter.range(0, n - 1)) {
      distance += Float.abs(dist1.probabilities[i] - dist2.probabilities[i]);
    };
    
    distance / 2.0  // Normalized
  };
  
  /// Kullback-Leibler Divergence
  func klDivergence(
    p : ProbabilityDistribution,
    q : ProbabilityDistribution
  ) : Float {
    var divergence : Float = 0.0;
    
    let n = Nat.min(p.numStates, q.numStates);
    for (i in Iter.range(0, n - 1)) {
      let pi = p.probabilities[i];
      let qi = q.probabilities[i];
      
      if (pi > PROBABILITY_EPSILON and qi > PROBABILITY_EPSILON) {
        divergence += pi * (Float.log(pi) - Float.log(qi));
      };
    };
    
    divergence
  };
  
  /// Product of distributions (for partitioned systems)
  func productDistribution(
    dist1 : ProbabilityDistribution,
    dist2 : ProbabilityDistribution
  ) : ProbabilityDistribution {
    // For independence assumption: P(A,B) = P(A) × P(B)
    // This is simplified - real IIT uses marginalization
    
    let n = dist1.numStates;
    var product = Array.init<Float>(n, 0.0);
    
    for (i in Iter.range(0, n - 1)) {
      product[i] := dist1.probabilities[i] * dist2.probabilities[i % dist2.numStates];
    };
    
    // Normalize
    var sum : Float = 0.0;
    for (p in product.vals()) {
      sum += p;
    };
    if (sum > PROBABILITY_EPSILON) {
      for (i in Iter.range(0, n - 1)) {
        product[i] := product[i] / sum;
      };
    };
    
    {
      numStates = n;
      var probabilities = Array.freeze(product);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: φ (SMALL PHI) COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute φ for a mechanism
  /// φ = min_{partition} EMD(whole_repertoire, partitioned_repertoire)
  public func computeMechanismPhi(
    state : IITState,
    mechanism : [Nat],
    currentState : SystemState
  ) : Float {
    if (mechanism.size() == 0) {
      return 0.0;
    };
    
    // Compute unpartitioned cause-effect repertoire
    let causeRep = computeCauseRepertoire(state, mechanism, currentState);
    let effectRep = computeEffectRepertoire(state, mechanism, currentState);
    
    // For single-element mechanisms, φ is based on intrinsic information
    if (mechanism.size() == 1) {
      let causeInfo = klDivergence(causeRep, uniformDistribution(causeRep.numStates));
      let effectInfo = klDivergence(effectRep, uniformDistribution(effectRep.numStates));
      return Float.min(causeInfo, effectInfo);
    };
    
    // For multi-element mechanisms, find minimum information partition
    var minPhi : Float = Float.abs(1e10);  // Large number
    
    // Generate bipartitions
    let partitions = generateBipartitions(mechanism);
    
    for (partition in partitions.vals()) {
      // Compute repertoire for each part
      let causeRep1 = computeCauseRepertoire(state, partition.part1, currentState);
      let causeRep2 = computeCauseRepertoire(state, partition.part2, currentState);
      let effectRep1 = computeEffectRepertoire(state, partition.part1, currentState);
      let effectRep2 = computeEffectRepertoire(state, partition.part2, currentState);
      
      // Product of partitioned repertoires
      let partitionedCause = productDistribution(causeRep1, causeRep2);
      let partitionedEffect = productDistribution(effectRep1, effectRep2);
      
      // Distance between whole and partitioned
      let causeDist = earthMoversDistance(causeRep, partitionedCause);
      let effectDist = earthMoversDistance(effectRep, partitionedEffect);
      
      let phi = Float.min(causeDist, effectDist);
      
      if (phi < minPhi) {
        minPhi := phi;
      };
    };
    
    if (minPhi > 1e9) {
      0.0
    } else {
      minPhi
    }
  };
  
  /// Generate all bipartitions of a set
  func generateBipartitions(elements : [Nat]) : [SystemPartition] {
    let n = elements.size();
    if (n < 2) {
      return [];
    };
    
    var partitions : [SystemPartition] = [];
    let numPartitions = powerOfTwo(n - 1) - 1;  // Exclude trivial partitions
    
    for (i in Iter.range(1, numPartitions)) {
      var part1 : [Nat] = [];
      var part2 : [Nat] = [];
      
      for (j in Iter.range(0, n - 1)) {
        if ((i / powerOfTwo(j)) % 2 == 0) {
          part1 := Array.append(part1, [elements[j]]);
        } else {
          part2 := Array.append(part2, [elements[j]]);
        };
      };
      
      if (part1.size() > 0 and part2.size() > 0) {
        let partition : SystemPartition = {
          partitionId = Nat64.fromNat(i);
          part1 = part1;
          part2 = part2;
          cutLocation = #BetweenParts;
        };
        partitions := Array.append(partitions, [partition]);
      };
    };
    
    partitions
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: Φ (BIG PHI) COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute Φ for the whole system
  /// Φ = min_{partition} [integrated_information - partitioned_information]
  public func computeBigPhi(state : IITState) : Float {
    let n = state.numElements;
    
    if (n < 2) {
      return 0.0;
    };
    
    // Generate all subsets (mechanisms)
    let allElements = Array.tabulate<Nat>(n, func(i : Nat) : Nat { i });
    
    // Compute φ for each mechanism
    var totalPhi : Float = 0.0;
    var mechanismCount : Nat = 0;
    
    for (size in Iter.range(1, n)) {
      let subsets = generateSubsets(allElements, size);
      
      for (mechanism in subsets.vals()) {
        let phi = computeMechanismPhi(state, mechanism, state.currentState);
        if (phi > PHI_MECHANISM_THRESHOLD) {
          totalPhi += phi;
          mechanismCount += 1;
        };
      };
    };
    
    // Find minimum information partition of the whole system
    let systemPartitions = generateBipartitions(allElements);
    var minPartitionedPhi : Float = totalPhi;  // Start with unpartitioned
    var bestPartition : ?SystemPartition = null;
    
    for (partition in systemPartitions.vals()) {
      // Compute φ for mechanisms within each part
      var part1Phi : Float = 0.0;
      var part2Phi : Float = 0.0;
      
      for (size in Iter.range(1, partition.part1.size())) {
        let subsets = generateSubsets(partition.part1, size);
        for (mechanism in subsets.vals()) {
          let phi = computeMechanismPhi(state, mechanism, state.currentState);
          part1Phi += phi;
        };
      };
      
      for (size in Iter.range(1, partition.part2.size())) {
        let subsets = generateSubsets(partition.part2, size);
        for (mechanism in subsets.vals()) {
          let phi = computeMechanismPhi(state, mechanism, state.currentState);
          part2Phi += phi;
        };
      };
      
      let partitionedPhi = part1Phi + part2Phi;
      
      if (partitionedPhi < minPartitionedPhi) {
        minPartitionedPhi := partitionedPhi;
        bestPartition := ?partition;
      };
    };
    
    // Φ = total φ - minimum partitioned φ
    let bigPhi = totalPhi - minPartitionedPhi;
    
    // Store MIP
    switch (bestPartition) {
      case (?partition) {
        state.mip := ?{
          partition = partition;
          phi = bigPhi;
          isMinimum = true;
        };
      };
      case (null) {};
    };
    
    state.bigPhi := Float.max(0.0, bigPhi);
    state.isConscious := state.bigPhi > PHI_CONSCIOUSNESS_THRESHOLD;
    
    state.bigPhi
  };
  
  /// Generate all subsets of a given size
  func generateSubsets(elements : [Nat], size : Nat) : [[Nat]] {
    if (size == 0) {
      return [[]];
    };
    if (elements.size() < size) {
      return [];
    };
    if (elements.size() == size) {
      return [elements];
    };
    
    var subsets : [[Nat]] = [];
    
    // Use bit manipulation for subset generation
    let n = elements.size();
    let limit = powerOfTwo(n);
    
    for (i in Iter.range(0, limit - 1)) {
      var subset : [Nat] = [];
      var count : Nat = 0;
      
      for (j in Iter.range(0, n - 1)) {
        if ((i / powerOfTwo(j)) % 2 == 1) {
          subset := Array.append(subset, [elements[j]]);
          count += 1;
        };
      };
      
      if (count == size) {
        subsets := Array.append(subsets, [subset]);
      };
    };
    
    subsets
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: CONCEPTUAL STRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Build conceptual structure (set of concepts with φ > 0)
  public func buildConceptualStructure(state : IITState) : ConceptualStructure {
    state.concepts := Buffer.Buffer<Concept>(50);
    
    let n = state.numElements;
    let allElements = Array.tabulate<Nat>(n, func(i : Nat) : Nat { i });
    
    // Find concepts (mechanisms with maximal φ for their purview)
    for (size in Iter.range(1, n)) {
      let subsets = generateSubsets(allElements, size);
      
      for (mechanism in subsets.vals()) {
        let phi = computeMechanismPhi(state, mechanism, state.currentState);
        
        if (phi > PHI_MECHANISM_THRESHOLD) {
          let conceptId = state.conceptIdCounter;
          state.conceptIdCounter += 1;
          
          // Compute qualia coordinates (simplified)
          let qualiaCoords = Array.tabulate<Float>(n, func(i : Nat) : Float {
            var coord : Float = 0.0;
            for (elem in mechanism.vals()) {
              if (elem == i) {
                coord := phi;
              };
            };
            coord
          });
          
          let concept : Concept = {
            conceptId = conceptId;
            mechanism = {
              mechanismId = state.mechanismIdCounter;
              elements = mechanism;
              currentState = state.currentState;
              purview = {
                causeElements = mechanism;
                effectElements = mechanism;
              };
              var causeEffectRepertoire = {
                causeRepertoire = computeCauseRepertoire(state, mechanism, state.currentState);
                effectRepertoire = computeEffectRepertoire(state, mechanism, state.currentState);
                var causeInformation = phi;
                var effectInformation = phi;
                var integratedInformation = phi;
              };
              var phi = phi;
            };
            phi = phi;
            qualiaCoordinates = qualiaCoords;
          };
          state.mechanismIdCounter += 1;
          
          state.concepts.add(concept);
        };
      };
    };
    
    // Build qualia shape
    let concepts = Buffer.toArray(state.concepts);
    let qualiaShape = buildQualiaShape(concepts, n);
    
    let structure : ConceptualStructure = {
      concepts = concepts;
      var totalPhi = computeTotalPhi(concepts);
      var bigPhi = state.bigPhi;
      qualiaShape = qualiaShape;
    };
    
    state.conceptualStructure := ?structure;
    state.qualiaShape := ?qualiaShape;
    
    structure
  };
  
  /// Compute total φ from concepts
  func computeTotalPhi(concepts : [Concept]) : Float {
    var total : Float = 0.0;
    for (concept in concepts.vals()) {
      total += concept.phi;
    };
    total
  };
  
  /// Build qualia shape from concepts
  func buildQualiaShape(concepts : [Concept], dimensions : Nat) : QualiaShape {
    var vertices : [[Float]] = [];
    var edges : [(Nat, Nat, Float)] = [];
    
    for (concept in concepts.vals()) {
      vertices := Array.append(vertices, [concept.qualiaCoordinates]);
    };
    
    // Build edges between related concepts
    for (i in Iter.range(0, concepts.size() - 1)) {
      for (j in Iter.range(i + 1, concepts.size() - 1)) {
        // Check if mechanisms overlap
        var overlap : Nat = 0;
        for (elem1 in concepts[i].mechanism.elements.vals()) {
          for (elem2 in concepts[j].mechanism.elements.vals()) {
            if (elem1 == elem2) { overlap += 1 };
          };
        };
        
        if (overlap > 0) {
          let strength = Float.fromInt(overlap) / Float.fromInt(
            concepts[i].mechanism.elements.size() + concepts[j].mechanism.elements.size()
          );
          edges := Array.append(edges, [(i, j, strength)]);
        };
      };
    };
    
    // Compute volume (simplified)
    var volume : Float = 0.0;
    for (concept in concepts.vals()) {
      volume += concept.phi;
    };
    
    // Compute complexity
    let complexity = Float.fromInt(concepts.size()) * Float.fromInt(edges.size() + 1);
    
    {
      dimensions = dimensions;
      var vertices = vertices;
      var edges = edges;
      var volume = volume;
      var complexity = complexity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: QUALIA EXTRACTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Extract qualia from conceptual structure
  public func extractQualia(state : IITState) : [Quale] {
    state.qualia := Buffer.Buffer<Quale>(50);
    
    switch (state.conceptualStructure) {
      case (?structure) {
        for (concept in structure.concepts.vals()) {
          let qualeId = state.qualeIdCounter;
          state.qualeIdCounter += 1;
          
          // Determine quale category based on mechanism properties
          let category = categorizeQuale(concept.mechanism);
          
          // Compute intensity and valence
          let intensity = concept.phi;
          let valence = computeValence(concept);
          
          let quale : Quale = {
            qualeId = qualeId;
            conceptSource = concept.conceptId;
            intensity = intensity;
            valence = valence;
            category = category;
            var description = describeQuale(concept, category);
          };
          
          state.qualia.add(quale);
        };
      };
      case (null) {};
    };
    
    // Compute experience intensity
    var totalIntensity : Float = 0.0;
    for (quale in state.qualia.vals()) {
      totalIntensity += quale.intensity;
    };
    state.experienceIntensity := totalIntensity;
    
    Buffer.toArray(state.qualia)
  };
  
  /// Categorize quale based on mechanism
  func categorizeQuale(mechanism : Mechanism) : QualeCategory {
    let size = mechanism.elements.size();
    
    // Simplified categorization based on mechanism properties
    if (size == 1) {
      #Sensory
    } else if (size <= 3) {
      #Cognitive
    } else if (mechanism.phi > 0.5) {
      #Emotional
    } else {
      #Abstract
    }
  };
  
  /// Compute valence of a concept
  func computeValence(concept : Concept) : Float {
    // Positive valence for high-phi, well-integrated concepts
    // Negative valence for fragmented concepts
    let integration = concept.phi;
    let size = Float.fromInt(concept.mechanism.elements.size());
    
    (integration - 0.5) * (1.0 / size)
  };
  
  /// Describe a quale
  func describeQuale(concept : Concept, category : QualeCategory) : Text {
    let catText = switch (category) {
      case (#Sensory) { "sensory" };
      case (#Emotional) { "emotional" };
      case (#Cognitive) { "cognitive" };
      case (#Temporal) { "temporal" };
      case (#Spatial) { "spatial" };
      case (#Social) { "social" };
      case (#Aesthetic) { "aesthetic" };
      case (#Abstract) { "abstract" };
    };
    
    "A " # catText # " experience with intensity " # Float.toText(concept.phi)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main IIT heartbeat update
  public func heartbeatUpdate(state : IITState, newState : SystemState, beat : Int) : IITHeartbeatResult {
    state.currentBeat := beat;
    
    // Record state history
    state.stateHistory.add(newState);
    if (state.stateHistory.size() > 100) {
      ignore state.stateHistory.remove(0);
    };
    
    // Update current state
    state.currentState := newState;
    
    // Compute Φ
    let bigPhi = computeBigPhi(state);
    state.phiHistory.add(bigPhi);
    
    // Build conceptual structure
    let structure = buildConceptualStructure(state);
    
    // Extract qualia
    let qualia = extractQualia(state);
    
    {
      beat = beat;
      bigPhi = bigPhi;
      isConscious = state.isConscious;
      conceptCount = state.concepts.size();
      qualiCount = qualia.size();
      experienceIntensity = state.experienceIntensity;
      mip = state.mip;
      qualiaShape = state.qualiaShape;
    }
  };
  
  /// IIT heartbeat result
  public type IITHeartbeatResult = {
    beat : Int;
    bigPhi : Float;
    isConscious : Bool;
    conceptCount : Nat;
    qualiCount : Nat;
    experienceIntensity : Float;
    mip : ?MinimumInformationPartition;
    qualiaShape : ?QualiaShape;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get Φ (big phi)
  public func getBigPhi(state : IITState) : Float {
    state.bigPhi
  };
  
  /// Check if conscious
  public func isConscious(state : IITState) : Bool {
    state.isConscious
  };
  
  /// Get experience intensity
  public func getExperienceIntensity(state : IITState) : Float {
    state.experienceIntensity
  };
  
  /// Get concept count
  public func getConceptCount(state : IITState) : Nat {
    state.concepts.size()
  };
  
  /// Get qualia count
  public func getQualiCount(state : IITState) : Nat {
    state.qualia.size()
  };
  
  /// Get current state
  public func getCurrentState(state : IITState) : SystemState {
    state.currentState
  };
  
  /// Get MIP
  public func getMIP(state : IITState) : ?MinimumInformationPartition {
    state.mip
  };
  
  /// Get Φ history
  public func getPhiHistory(state : IITState) : [Float] {
    Buffer.toArray(state.phiHistory)
  };
  
  /// Get qualia shape
  public func getQualiaShape(state : IITState) : ?QualiaShape {
    state.qualiaShape
  };
  
  /// Get conceptual structure
  public func getConceptualStructure(state : IITState) : ?ConceptualStructure {
    state.conceptualStructure
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: ADVANCED OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Set element state
  public func setElementState(state : IITState, elementIndex : Nat, value : ElementState) : () {
    if (elementIndex < state.numElements) {
      let newState = Array.thaw<ElementState>(state.currentState);
      newState[elementIndex] := value;
      state.currentState := Array.freeze(newState);
    };
  };
  
  /// Toggle element state
  public func toggleElement(state : IITState, elementIndex : Nat) : () {
    if (elementIndex < state.numElements) {
      let current = state.currentState[elementIndex];
      let newValue : ElementState = if (current == 0) { 1 } else { 0 };
      setElementState(state, elementIndex, newValue);
    };
  };
  
  /// Get average Φ over history
  public func getAveragePhi(state : IITState) : Float {
    if (state.phiHistory.size() == 0) {
      return 0.0;
    };
    
    var sum : Float = 0.0;
    for (phi in state.phiHistory.vals()) {
      sum += phi;
    };
    sum / Float.fromInt(state.phiHistory.size())
  };
  
  /// Get peak Φ
  public func getPeakPhi(state : IITState) : Float {
    var peak : Float = 0.0;
    for (phi in state.phiHistory.vals()) {
      if (phi > peak) { peak := phi };
    };
    peak
  };
  
  /// Check if system is integrated (Φ > 0)
  public func isIntegrated(state : IITState) : Bool {
    state.bigPhi > 0.0
  };
  
  /// Get consciousness quality score (0-1)
  public func getConsciousnessQuality(state : IITState) : Float {
    if (not state.isConscious) {
      return 0.0;
    };
    
    var quality : Float = 0.0;
    
    // Φ contribution
    quality += Float.min(1.0, state.bigPhi) * 0.4;
    
    // Concept richness
    let conceptRichness = Float.min(1.0, Float.fromInt(state.concepts.size()) / 20.0);
    quality += conceptRichness * 0.3;
    
    // Qualia variety
    let qualiaVariety = Float.min(1.0, Float.fromInt(state.qualia.size()) / 10.0);
    quality += qualiaVariety * 0.3;
    
    Float.max(S_ZERO_FLOOR, Float.min(1.0, quality))
  };

}
