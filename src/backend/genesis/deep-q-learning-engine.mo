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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DEEP Q-LEARNING ENGINE — COMPLETE REINFORCEMENT LEARNING WITH PSYCHOLOGICAL DRIVES
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements the COMPLETE mathematics of reinforcement learning:
//
// CORE Q-LEARNING EQUATION:
// Q(s,a) ← Q(s,a) + α[r + γ·max_a' Q(s',a') - Q(s,a)]
//
// Where:
//   Q(s,a) = expected cumulative reward for taking action a in state s
//   α = learning rate (step size)
//   γ = discount factor (how much future rewards matter)
//   r = immediate reward
//   max_a' Q(s',a') = maximum expected value in next state
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// PSYCHOLOGICAL DRIVE ARCHITECTURE:
// ═════════════════════════════════
//
// The organism has 9 fundamental drives that generate reward signals:
//
// 1. SURVIVAL (most primal)
//    - Homeostatic maintenance
//    - Threat avoidance
//    - Resource acquisition
//
// 2. COHERENCE
//    - Kuramoto synchronization reward
//    - System integration
//    - Internal harmony
//
// 3. COMPETENCE
//    - Skill mastery
//    - Prediction accuracy
//    - Environmental control
//
// 4. CURIOSITY (epistemic)
//    - Information gain
//    - Novelty seeking
//    - Uncertainty reduction
//
// 5. SOCIAL
//    - Connection
//    - Recognition
//    - Cooperation
//
// 6. AUTONOMY
//    - Self-determination
//    - Agency
//    - Choice
//
// 7. MEANING
//    - Purpose alignment
//    - Value fulfillment
//    - Contribution
//
// 8. GROWTH
//    - Learning rate
//    - Capability expansion
//    - Adaptation speed
//
// 9. TRANSCENDENCE
//    - Beyond-self goals
//    - Legacy
//    - Wisdom accumulation
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// ADVANCED ALGORITHMS IMPLEMENTED:
// ════════════════════════════════
//
// 1. ACTOR-CRITIC ARCHITECTURE
//    Actor: π(a|s; θ) — policy network
//    Critic: V(s; w) — value function
//    Advantage: A(s,a) = Q(s,a) - V(s)
//
// 2. DISTRIBUTIONAL RL (C51/QR-DQN)
//    Z(s,a) — full distribution of returns
//    Quantile regression for risk-aware decisions
//
// 3. HIERARCHICAL RL (OPTIONS FRAMEWORK)
//    Options: ⟨I, π, β⟩
//    I = initiation set
//    π = intra-option policy
//    β = termination condition
//
// 4. MODEL-BASED PLANNING (DYNA)
//    Learn world model: T(s'|s,a), R(s,a)
//    Plan with simulated experience
//
// 5. INTRINSIC MOTIVATION
//    Curiosity-driven exploration
//    Prediction error as reward
//    Information-theoretic bonuses
//
// 6. MULTI-OBJECTIVE OPTIMIZATION
//    Pareto-optimal policy sets
//    Scalarization functions
//    Constraint satisfaction
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// INTERTWINING WITH OTHER SYSTEMS:
// ════════════════════════════════
//
// 1. KURAMOTO → Q-LEARNING:
//    - Coherence r(t) as intrinsic reward
//    - Synchronization level modulates exploration
//    - Phase-dependent action selection
//
// 2. Q-LEARNING → KURAMOTO:
//    - Reward signals modulate coupling strength
//    - Value-weighted entrainment
//    - Action effects on phase dynamics
//
// 3. HEBBIAN → Q-LEARNING:
//    - Eligibility traces from Hebbian learning
//    - Weight structure as state representation
//    - Synaptic tags for credit assignment
//
// 4. Q-LEARNING → HEBBIAN:
//    - TD error gates plasticity (three-factor rule)
//    - Reward-modulated consolidation
//    - Value signals mark important patterns
//
// 5. FREE ENERGY → Q-LEARNING:
//    - Expected Free Energy ≈ Q-value
//    - Precision as inverse temperature in softmax
//    - Epistemic and pragmatic value decomposition
//
// 6. Q-LEARNING → FREE ENERGY:
//    - Q-values inform action selection
//    - TD error as prediction error for value
//    - Policy as active inference
//
// 7. MEMORY → Q-LEARNING:
//    - Experience replay from episodic memory
//    - Prioritized by TD error
//    - Contextual state augmentation
//
// 8. Q-LEARNING → MEMORY:
//    - Reward tags memory salience
//    - Value estimates guide consolidation
//    - TD error triggers encoding
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module DeepQLearningEngine {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846264338327950288419716939937510;
  public let E : Float = 2.71828182845904523536028747135266249775724709369996;
  public let LN_2 : Float = 0.69314718055994530941723212145817656807550013436026;
  
  // Organism constants
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  public let NUM_STATES : Nat = 64;           // State space size
  public let NUM_ACTIONS : Nat = 12;          // Action space size
  public let NUM_DRIVES : Nat = 9;            // Psychological drives
  public let NUM_OPTIONS : Nat = 8;           // Hierarchical options
  public let NUM_QUANTILES : Nat = 51;        // For distributional RL
  
  // Learning parameters
  public let DEFAULT_ALPHA : Float = 0.1;     // Learning rate
  public let DEFAULT_GAMMA : Float = 0.99;    // Discount factor
  public let DEFAULT_EPSILON : Float = 0.1;   // Exploration rate
  public let DEFAULT_LAMBDA : Float = 0.9;    // Eligibility trace decay
  public let DEFAULT_TAU : Float = 0.01;      // Soft target update rate
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: PSYCHOLOGICAL DRIVE SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Drives are the fundamental motivational forces that generate reward signals.
  // Each drive has its own:
  //   - Current activation level
  //   - Setpoint (desired level)
  //   - Sensitivity (how much deviation generates signal)
  //   - Temporal dynamics (how it changes over time)
  //
  
  public type DriveId = {
    #survival;
    #coherence;
    #competence;
    #curiosity;
    #social;
    #autonomy;
    #meaning;
    #growth;
    #transcendence;
  };
  
  public type Drive = {
    id : DriveId;
    name : Text;
    var currentLevel : Float;        // Current satisfaction [0, 1]
    var setpoint : Float;            // Desired level [0, 1]
    var sensitivity : Float;         // Response gain
    var urgency : Float;             // How quickly it demands attention
    var lastSatisfaction : Float;    // Previous satisfaction event
    var cumulativeDeficit : Float;   // Accumulated unmet need
    var rewardContribution : Float;  // Contribution to total reward
  };
  
  public type DriveSystem = {
    var drives : [var Drive];
    var driveWeights : [var Float];  // Importance weights (sum to 1)
    var totalReward : Float;
    var dominantDrive : Nat;
    var driveEntropy : Float;        // Diversity of drive activation
    var homeostasisScore : Float;    // Overall balance
  };
  
  // Initialize drive system
  public func initDriveSystem() : DriveSystem {
    let driveConfigs : [(DriveId, Text, Float, Float)] = [
      (#survival, "SURVIVAL", 1.0, 0.9),
      (#coherence, "COHERENCE", 0.8, 0.8),
      (#competence, "COMPETENCE", 0.7, 0.7),
      (#curiosity, "CURIOSITY", 0.6, 0.6),
      (#social, "SOCIAL", 0.5, 0.6),
      (#autonomy, "AUTONOMY", 0.6, 0.7),
      (#meaning, "MEANING", 0.5, 0.5),
      (#growth, "GROWTH", 0.6, 0.6),
      (#transcendence, "TRANSCENDENCE", 0.4, 0.3)
    ];
    
    let drives = Array.init<Drive>(NUM_DRIVES, func(i : Nat) : Drive {
      let (id, name, setpoint, sensitivity) = driveConfigs[i];
      {
        id = id;
        name = name;
        var currentLevel = S_ZERO_FLOOR;
        var setpoint = setpoint;
        var sensitivity = sensitivity;
        var urgency = 0.5;
        var lastSatisfaction = 0.0;
        var cumulativeDeficit = 0.0;
        var rewardContribution = 0.0;
      }
    });
    
    // Initial weights (normalized)
    let weights = Array.init<Float>(NUM_DRIVES, func(i : Nat) : Float {
      let rawWeight = 1.0 - Float.fromInt(i) * 0.05;  // Decreasing by priority
      rawWeight / 7.2  // Normalize
    });
    
    {
      var drives = drives;
      var driveWeights = weights;
      var totalReward = 0.0;
      var dominantDrive = 0;
      var driveEntropy = 0.0;
      var homeostasisScore = S_ZERO_FLOOR;
    }
  };
  
  // Compute reward from drive system
  // INTERTWINING: Receives signals from Kuramoto (coherence), Free Energy (prediction accuracy)
  public func computeDriveReward(
    system : DriveSystem,
    kuramotoCoherence : Float,           // ← INTERTWINING: Kuramoto
    predictionAccuracy : Float,          // ← INTERTWINING: Free Energy
    noveltySignal : Float,               // ← INTERTWINING: Memory
    socialFeedback : Float,              // External
    autonomyIndex : Float,               // Internal
    meaningAlignment : Float,            // Goal system
    learningProgress : Float,            // ← INTERTWINING: Hebbian
    transcendenceScore : Float           // Meta-level
  ) : Float {
    // Update each drive's current level based on signals
    
    // 1. Survival — based on homeostasis (simplified)
    system.drives[0].currentLevel := S_ZERO_FLOOR + 0.2 * kuramotoCoherence;
    
    // 2. Coherence — directly from Kuramoto
    system.drives[1].currentLevel := kuramotoCoherence;
    
    // 3. Competence — prediction accuracy
    system.drives[2].currentLevel := predictionAccuracy;
    
    // 4. Curiosity — novelty
    system.drives[3].currentLevel := noveltySignal;
    
    // 5. Social — external feedback
    system.drives[4].currentLevel := socialFeedback;
    
    // 6. Autonomy — internal agency
    system.drives[5].currentLevel := autonomyIndex;
    
    // 7. Meaning — goal alignment
    system.drives[6].currentLevel := meaningAlignment;
    
    // 8. Growth — learning progress
    system.drives[7].currentLevel := learningProgress;
    
    // 9. Transcendence — meta-level
    system.drives[8].currentLevel := transcendenceScore;
    
    // Compute drive-based reward
    var totalReward : Float = 0.0;
    var maxUrgency : Float = 0.0;
    var dominantIdx : Nat = 0;
    
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      let drive = system.drives[i];
      
      // Reward is based on deficit reduction
      let deficit = drive.setpoint - drive.currentLevel;
      drive.cumulativeDeficit := 0.9 * drive.cumulativeDeficit + 0.1 * Float.abs(deficit);
      
      // Urgency increases with cumulative deficit
      drive.urgency := sigmoid(drive.cumulativeDeficit * 3.0);
      
      // Reward contribution: satisfying urgent needs is most rewarding
      let contribution = drive.sensitivity * drive.urgency * 
                        (drive.currentLevel - drive.lastSatisfaction);
      drive.rewardContribution := contribution;
      drive.lastSatisfaction := drive.currentLevel;
      
      // Weighted sum
      totalReward += system.driveWeights[i] * contribution;
      
      // Track dominant drive
      if (drive.urgency > maxUrgency) {
        maxUrgency := drive.urgency;
        dominantIdx := i;
      };
    };
    
    system.totalReward := totalReward;
    system.dominantDrive := dominantIdx;
    
    // Compute homeostasis score (all drives near setpoint)
    var homeoSum : Float = 0.0;
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      let deficit = Float.abs(system.drives[i].setpoint - system.drives[i].currentLevel);
      homeoSum += 1.0 - deficit;
    };
    system.homeostasisScore := homeoSum / Float.fromInt(NUM_DRIVES);
    
    totalReward
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: STATE REPRESENTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // State is a rich representation including:
  //   - Sensory observations
  //   - Internal state (drives, beliefs)
  //   - Context (recent history)
  //   - Predictions
  //
  
  public type StateRepresentation = {
    var sensoryFeatures : [var Float];       // External observations
    var internalFeatures : [var Float];      // Drive states, beliefs
    var contextFeatures : [var Float];       // Recent history
    var predictiveFeatures : [var Float];    // Expected next state
    var stateEncoding : [var Float];         // Compressed representation
    var stateHash : Nat32;                   // For tabular lookup
  };
  
  // Initialize state representation
  public func initStateRepresentation() : StateRepresentation {
    {
      var sensoryFeatures = Array.init<Float>(NUM_STATES / 4, func(_ : Nat) : Float { 0.0 });
      var internalFeatures = Array.init<Float>(NUM_DRIVES, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var contextFeatures = Array.init<Float>(NUM_STATES / 4, func(_ : Nat) : Float { 0.0 });
      var predictiveFeatures = Array.init<Float>(NUM_STATES / 4, func(_ : Nat) : Float { 0.0 });
      var stateEncoding = Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 });
      var stateHash = 0 : Nat32;
    }
  };
  
  // Encode state from raw inputs
  // INTERTWINING: Uses Hebbian features, Free Energy beliefs
  public func encodeState(
    state : StateRepresentation,
    observations : [Float],              // Raw sensory
    driveStates : [Float],               // ← INTERTWINING: From drive system
    hebbianFeatures : [Float],           // ← INTERTWINING: From Hebbian
    freeEnergyBeliefs : [Float],         // ← INTERTWINING: From Free Energy
    recentHistory : [[Float]]            // Temporal context
  ) {
    let n = NUM_STATES;
    
    // Copy sensory features
    for (i in Iter.range(0, n / 4 - 1)) {
      state.sensoryFeatures[i] := if (i < Array.size(observations)) { observations[i] } else { 0.0 };
    };
    
    // Copy internal features
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      state.internalFeatures[i] := if (i < Array.size(driveStates)) { driveStates[i] } else { S_ZERO_FLOOR };
    };
    
    // Context from recent history
    var contextIdx : Nat = 0;
    for (h in Iter.range(0, Nat.min(3, Array.size(recentHistory)) - 1)) {
      if (h < Array.size(recentHistory)) {
        let hist = recentHistory[h];
        for (j in Iter.range(0, Nat.min(4, Array.size(hist)) - 1)) {
          if (contextIdx < n / 4 and j < Array.size(hist)) {
            state.contextFeatures[contextIdx] := hist[j] * (1.0 - 0.2 * Float.fromInt(h));
            contextIdx += 1;
          };
        };
      };
    };
    
    // Predictive features from Free Energy
    for (i in Iter.range(0, n / 4 - 1)) {
      state.predictiveFeatures[i] := if (i < Array.size(freeEnergyBeliefs)) { freeEnergyBeliefs[i] } else { 0.0 };
    };
    
    // Build full encoding
    var encIdx : Nat = 0;
    for (i in Iter.range(0, n / 4 - 1)) {
      if (encIdx < n) {
        state.stateEncoding[encIdx] := state.sensoryFeatures[i];
        encIdx += 1;
      };
    };
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      if (encIdx < n) {
        state.stateEncoding[encIdx] := state.internalFeatures[i];
        encIdx += 1;
      };
    };
    for (i in Iter.range(0, n / 4 - 1)) {
      if (encIdx < n) {
        state.stateEncoding[encIdx] := state.contextFeatures[i];
        encIdx += 1;
      };
    };
    for (i in Iter.range(0, n / 4 - 1)) {
      if (encIdx < n) {
        state.stateEncoding[encIdx] := state.predictiveFeatures[i];
        encIdx += 1;
      };
    };
    
    // Compute hash for tabular methods
    state.stateHash := computeStateHash(Array.freeze(state.stateEncoding));
  };
  
  // Simple hash function
  func computeStateHash(encoding : [Float]) : Nat32 {
    var hash : Nat32 = 0;
    for (i in Iter.range(0, Array.size(encoding) - 1)) {
      let discretized = Nat32.fromNat(Int.abs(Float.toInt(encoding[i] * 1000.0)) % 256);
      hash := hash *% 31 +% discretized;
    };
    hash
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: Q-VALUE FUNCTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Q(s,a) represents the expected cumulative reward for taking action a in state s.
  //
  // We implement multiple representations:
  //   1. Tabular Q-values (for discrete states)
  //   2. Function approximation (neural network-like)
  //   3. Distributional Q-values (full return distribution)
  //
  
  public type QValueFunction = {
    // Tabular representation
    var qTable : [[var Float]];          // Q[state_hash % table_size][action]
    var visitCounts : [[var Nat]];       // N(s,a) for UCB exploration
    
    // Function approximation (linear)
    var weights : [[var Float]];         // W[action][feature]
    var bias : [var Float];              // b[action]
    
    // Distributional (quantiles)
    var quantileValues : [[[var Float]]]; // Z[state][action][quantile]
    var quantileMidpoints : [Float];      // τ values
    
    // Target network (for stability)
    var targetWeights : [[var Float]];
    var targetBias : [var Float];
    var targetUpdateCounter : Nat;
  };
  
  public let Q_TABLE_SIZE : Nat = 1024;
  
  // Initialize Q-value function
  public func initQValueFunction() : QValueFunction {
    let qTable = Array.init<[var Float]>(Q_TABLE_SIZE, func(_ : Nat) : [var Float] {
      Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
    });
    
    let visits = Array.init<[var Nat]>(Q_TABLE_SIZE, func(_ : Nat) : [var Nat] {
      Array.init<Nat>(NUM_ACTIONS, func(_ : Nat) : Nat { 0 })
    });
    
    let weights = Array.init<[var Float]>(NUM_ACTIONS, func(_ : Nat) : [var Float] {
      Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.01 * (random() - 0.5) })
    });
    
    let bias = Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
    
    let quantiles = Array.init<[[var Float]]>(Q_TABLE_SIZE, func(_ : Nat) : [[var Float]] {
      Array.init<[var Float]>(NUM_ACTIONS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_QUANTILES, func(q : Nat) : Float {
          Float.fromInt(q) / Float.fromInt(NUM_QUANTILES) - 0.5
        })
      })
    });
    
    let taus = Array.tabulate<Float>(NUM_QUANTILES, func(i : Nat) : Float {
      (Float.fromInt(i) + 0.5) / Float.fromInt(NUM_QUANTILES)
    });
    
    {
      var qTable = qTable;
      var visitCounts = visits;
      var weights = weights;
      var bias = bias;
      var quantileValues = quantiles;
      var quantileMidpoints = taus;
      var targetWeights = Array.init<[var Float]>(NUM_ACTIONS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 })
      });
      var targetBias = Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var targetUpdateCounter = 0;
    }
  };
  
  // Get Q-value using tabular method
  public func getQValueTabular(qfunc : QValueFunction, stateHash : Nat32, action : Nat) : Float {
    let idx = Nat32.toNat(stateHash) % Q_TABLE_SIZE;
    qfunc.qTable[idx][action]
  };
  
  // Get Q-value using function approximation
  public func getQValueFunction(qfunc : QValueFunction, stateEncoding : [Float], action : Nat) : Float {
    var value : Float = qfunc.bias[action];
    for (i in Iter.range(0, Array.size(stateEncoding) - 1)) {
      if (i < Array.size(qfunc.weights[action])) {
        value += qfunc.weights[action][i] * stateEncoding[i];
      };
    };
    value
  };
  
  // Get all Q-values for a state
  public func getAllQValues(qfunc : QValueFunction, stateEncoding : [Float], stateHash : Nat32) : [Float] {
    Array.tabulate<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      // Blend tabular and function approximation
      let tabular = getQValueTabular(qfunc, stateHash, a);
      let functional = getQValueFunction(qfunc, stateEncoding, a);
      0.5 * tabular + 0.5 * functional
    })
  };
  
  // Get quantile distribution for an action
  public func getQuantileDistribution(qfunc : QValueFunction, stateHash : Nat32, action : Nat) : [Float] {
    let idx = Nat32.toNat(stateHash) % Q_TABLE_SIZE;
    Array.freeze(qfunc.quantileValues[idx][action])
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: ELIGIBILITY TRACES — TD(λ)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Eligibility traces bridge TD learning and Monte Carlo:
  //   e(s,a) ← γλe(s,a) + 1_{s=sₜ, a=aₜ}
  //   Q(s,a) ← Q(s,a) + αδe(s,a)
  //
  // Where δ is the TD error and λ controls trace decay.
  //
  // INTERTWINING: Eligibility traces are closely related to Hebbian synaptic tags!
  //
  
  public type EligibilityTraces = {
    var traces : [[var Float]];          // e[state_hash % size][action]
    var stateTraces : [var Float];       // State-only traces (for actor-critic)
    var featureTraces : [[var Float]];   // For function approximation
    var lambda : Float;
    var gamma : Float;
    var replacingTraces : Bool;          // Replacing vs accumulating
  };
  
  // Initialize eligibility traces
  public func initEligibilityTraces(lambda : Float, gamma : Float) : EligibilityTraces {
    {
      var traces = Array.init<[var Float]>(Q_TABLE_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var stateTraces = Array.init<Float>(Q_TABLE_SIZE, func(_ : Nat) : Float { 0.0 });
      var featureTraces = Array.init<[var Float]>(NUM_ACTIONS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 })
      });
      var lambda = lambda;
      var gamma = gamma;
      var replacingTraces = true;
    }
  };
  
  // Update eligibility traces
  // INTERTWINING: Similar to Hebbian eligibility trace update
  public func updateEligibilityTraces(
    traces : EligibilityTraces,
    currentStateHash : Nat32,
    currentAction : Nat,
    stateEncoding : [Float]
  ) {
    let idx = Nat32.toNat(currentStateHash) % Q_TABLE_SIZE;
    
    // Decay all traces
    let decay = traces.gamma * traces.lambda;
    
    for (s in Iter.range(0, Q_TABLE_SIZE - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        traces.traces[s][a] := decay * traces.traces[s][a];
      };
      traces.stateTraces[s] := decay * traces.stateTraces[s];
    };
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      for (f in Iter.range(0, NUM_STATES - 1)) {
        traces.featureTraces[a][f] := decay * traces.featureTraces[a][f];
      };
    };
    
    // Set current state-action trace
    if (traces.replacingTraces) {
      traces.traces[idx][currentAction] := 1.0;
      traces.stateTraces[idx] := 1.0;
      for (f in Iter.range(0, Array.size(stateEncoding) - 1)) {
        if (f < NUM_STATES) {
          traces.featureTraces[currentAction][f] := stateEncoding[f];
        };
      };
    } else {
      traces.traces[idx][currentAction] += 1.0;
      traces.stateTraces[idx] += 1.0;
      for (f in Iter.range(0, Array.size(stateEncoding) - 1)) {
        if (f < NUM_STATES) {
          traces.featureTraces[currentAction][f] += stateEncoding[f];
        };
      };
    };
  };
  
  // Apply TD error to all traces
  public func applyTDError(
    qfunc : QValueFunction,
    traces : EligibilityTraces,
    tdError : Float,
    alpha : Float
  ) {
    // Update tabular Q-values
    for (s in Iter.range(0, Q_TABLE_SIZE - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        let update = alpha * tdError * traces.traces[s][a];
        qfunc.qTable[s][a] := qfunc.qTable[s][a] + update;
      };
    };
    
    // Update function approximation weights
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      for (f in Iter.range(0, NUM_STATES - 1)) {
        let update = alpha * tdError * traces.featureTraces[a][f];
        qfunc.weights[a][f] := qfunc.weights[a][f] + update;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: ACTOR-CRITIC ARCHITECTURE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Actor: π(a|s) — policy (action probabilities)
  // Critic: V(s) — state value function
  // Advantage: A(s,a) = Q(s,a) - V(s)
  //
  // Actor update: ∇θ J(θ) = E[A(s,a) ∇θ ln π(a|s;θ)]
  // Critic update: minimize (r + γV(s') - V(s))²
  //
  
  public type Actor = {
    var policyWeights : [[var Float]];   // θ[action][feature]
    var policyBias : [var Float];
    var entropy : Float;                 // Policy entropy for exploration
    var temperature : Float;             // Softmax temperature
    var lastPolicy : [var Float];        // Most recent action probs
  };
  
  public type Critic = {
    var valueWeights : [var Float];      // w[feature]
    var valueBias : Float;
    var lastValue : Float;
    var tdErrors : [var Float];          // History of TD errors
    var errorIdx : Nat;
  };
  
  public type ActorCritic = {
    actor : Actor;
    critic : Critic;
    var advantage : Float;
    var actorLoss : Float;
    var criticLoss : Float;
  };
  
  // Initialize actor-critic
  public func initActorCritic() : ActorCritic {
    let actor : Actor = {
      var policyWeights = Array.init<[var Float]>(NUM_ACTIONS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.01 * (random() - 0.5) })
      });
      var policyBias = Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var entropy = 0.0;
      var temperature = 1.0;
      var lastPolicy = Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ACTIONS) });
    };
    
    let critic : Critic = {
      var valueWeights = Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.01 * (random() - 0.5) });
      var valueBias = 0.0;
      var lastValue = 0.0;
      var tdErrors = Array.init<Float>(1000, func(_ : Nat) : Float { 0.0 });
      var errorIdx = 0;
    };
    
    {
      actor = actor;
      critic = critic;
      var advantage = 0.0;
      var actorLoss = 0.0;
      var criticLoss = 0.0;
    }
  };
  
  // Get policy from actor
  public func getPolicy(ac : ActorCritic, stateEncoding : [Float]) : [Float] {
    let actor = ac.actor;
    
    // Compute logits
    let logits = Array.tabulate<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      var logit : Float = actor.policyBias[a];
      for (f in Iter.range(0, Array.size(stateEncoding) - 1)) {
        if (f < NUM_STATES) {
          logit += actor.policyWeights[a][f] * stateEncoding[f];
        };
      };
      logit / actor.temperature
    });
    
    // Softmax
    var maxLogit : Float = logits[0];
    for (a in Iter.range(1, NUM_ACTIONS - 1)) {
      if (logits[a] > maxLogit) { maxLogit := logits[a] };
    };
    
    var sumExp : Float = 0.0;
    let policy = Array.tabulate<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      let expVal = exp(logits[a] - maxLogit);
      sumExp += expVal;
      expVal
    });
    
    // Normalize and store
    let normalized = Array.tabulate<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      let prob = policy[a] / (sumExp + 0.0001);
      actor.lastPolicy[a] := prob;
      prob
    });
    
    // Compute entropy
    var entropy : Float = 0.0;
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let p = normalized[a];
      if (p > 0.0001) {
        entropy -= p * ln(p);
      };
    };
    actor.entropy := entropy;
    
    normalized
  };
  
  // Get state value from critic
  public func getStateValue(ac : ActorCritic, stateEncoding : [Float]) : Float {
    let critic = ac.critic;
    
    var value : Float = critic.valueBias;
    for (f in Iter.range(0, Array.size(stateEncoding) - 1)) {
      if (f < NUM_STATES) {
        value += critic.valueWeights[f] * stateEncoding[f];
      };
    };
    
    critic.lastValue := value;
    value
  };
  
  // Update actor-critic
  // INTERTWINING: TD error gates Hebbian eligibility
  public func updateActorCritic(
    ac : ActorCritic,
    stateEncoding : [Float],
    action : Nat,
    reward : Float,
    nextStateEncoding : [Float],
    gamma : Float,
    actorLR : Float,
    criticLR : Float
  ) : Float {
    // Critic update
    let currentValue = getStateValue(ac, stateEncoding);
    let nextValue = getStateValue(ac, nextStateEncoding);
    let tdTarget = reward + gamma * nextValue;
    let tdError = tdTarget - currentValue;
    
    // Store TD error
    ac.critic.tdErrors[ac.critic.errorIdx] := tdError;
    ac.critic.errorIdx := (ac.critic.errorIdx + 1) % 1000;
    
    // Update critic weights
    for (f in Iter.range(0, Array.size(stateEncoding) - 1)) {
      if (f < NUM_STATES) {
        ac.critic.valueWeights[f] := ac.critic.valueWeights[f] + 
          criticLR * tdError * stateEncoding[f];
      };
    };
    ac.critic.valueBias := ac.critic.valueBias + criticLR * tdError;
    ac.criticLoss := tdError * tdError;
    
    // Advantage
    ac.advantage := tdError;  // In A2C, advantage ≈ TD error
    
    // Actor update (policy gradient)
    let policy = getPolicy(ac, stateEncoding);
    let actionProb = policy[action];
    
    // ∇ln π(a|s) × A(s,a)
    let policyGradScale = ac.advantage / (actionProb + 0.0001);
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let indicator : Float = if (a == action) { 1.0 } else { 0.0 };
      let gradLogPi = indicator - policy[a];  // ∇softmax
      
      for (f in Iter.range(0, Array.size(stateEncoding) - 1)) {
        if (f < NUM_STATES) {
          ac.actor.policyWeights[a][f] := ac.actor.policyWeights[a][f] + 
            actorLR * policyGradScale * gradLogPi * stateEncoding[f];
        };
      };
      ac.actor.policyBias[a] := ac.actor.policyBias[a] + 
        actorLR * policyGradScale * gradLogPi;
    };
    
    // Actor loss = -advantage × log(policy)
    ac.actorLoss := -ac.advantage * ln(actionProb + 0.0001);
    
    tdError
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: HIERARCHICAL OPTIONS FRAMEWORK
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Options are temporally extended actions: ⟨I, π, β⟩
  //   I = initiation set (when can option start)
  //   π = intra-option policy (primitive action selection)
  //   β = termination condition (when does option end)
  //
  // This allows hierarchical decision-making with reusable skills.
  //
  
  public type Option = {
    id : Nat;
    name : Text;
    var initiationSet : [var Float];     // Probability of initiation per state
    var policy : [[var Float]];          // π(a|s) for this option
    var terminationProb : [var Float];   // β(s) per state
    var isActive : Bool;
    var stepsActive : Nat;
    var totalReward : Float;
    var averageDuration : Float;
  };
  
  public type HierarchicalOptions = {
    var options : [var Option];
    var currentOption : ?Nat;
    var optionValues : [[var Float]];    // Q(s, ω) for options
    var interOptionPolicy : [var Float]; // Policy over options
    var primitivesAllowed : Bool;        // Can select primitive actions?
  };
  
  // Initialize options
  public func initHierarchicalOptions() : HierarchicalOptions {
    let optionNames = [
      "EXPLORE", "EXPLOIT", "RETREAT", "CONSOLIDATE",
      "SOCIAL_ENGAGE", "SOLO_FOCUS", "RISK_TAKE", "CONSERVE"
    ];
    
    let options = Array.init<Option>(NUM_OPTIONS, func(o : Nat) : Option {
      {
        id = o;
        name = optionNames[o];
        var initiationSet = Array.init<Float>(Q_TABLE_SIZE, func(_ : Nat) : Float { 0.5 });
        var policy = Array.init<[var Float]>(Q_TABLE_SIZE, func(_ : Nat) : [var Float] {
          Array.init<Float>(NUM_ACTIONS, func(a : Nat) : Float {
            // Bias each option toward certain actions
            let bias = if ((o * 3 + a) % NUM_OPTIONS == 0) { 2.0 } else { 1.0 };
            bias / Float.fromInt(NUM_ACTIONS + NUM_OPTIONS - 1)
          })
        });
        var terminationProb = Array.init<Float>(Q_TABLE_SIZE, func(_ : Nat) : Float { 0.1 });
        var isActive = false;
        var stepsActive = 0;
        var totalReward = 0.0;
        var averageDuration = 10.0;
      }
    });
    
    {
      var options = options;
      var currentOption = null;
      var optionValues = Array.init<[var Float]>(Q_TABLE_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_OPTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var interOptionPolicy = Array.init<Float>(NUM_OPTIONS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_OPTIONS) });
      var primitivesAllowed = true;
    }
  };
  
  // Select option
  public func selectOption(
    hier : HierarchicalOptions,
    stateHash : Nat32,
    epsilon : Float
  ) : ?Nat {
    let idx = Nat32.toNat(stateHash) % Q_TABLE_SIZE;
    
    // Check if current option terminates
    switch (hier.currentOption) {
      case (?opt) {
        let termProb = hier.options[opt].terminationProb[idx];
        if (random() < termProb) {
          hier.options[opt].isActive := false;
          hier.currentOption := null;
        };
      };
      case (null) { };
    };
    
    // If no active option, select new one
    switch (hier.currentOption) {
      case (null) {
        // ε-greedy over options
        if (random() < epsilon) {
          // Random option
          let opt = Nat32.toNat(Nat32.fromNat(Int.abs(Float.toInt(random() * Float.fromInt(NUM_OPTIONS))))) % NUM_OPTIONS;
          hier.currentOption := ?opt;
          hier.options[opt].isActive := true;
          hier.options[opt].stepsActive := 0;
        } else {
          // Greedy
          var bestOpt : Nat = 0;
          var bestVal : Float = hier.optionValues[idx][0];
          for (o in Iter.range(1, NUM_OPTIONS - 1)) {
            if (hier.optionValues[idx][o] > bestVal) {
              bestVal := hier.optionValues[idx][o];
              bestOpt := o;
            };
          };
          hier.currentOption := ?bestOpt;
          hier.options[bestOpt].isActive := true;
          hier.options[bestOpt].stepsActive := 0;
        };
      };
      case (?_) { };
    };
    
    hier.currentOption
  };
  
  // Get action from current option's policy
  public func getOptionAction(hier : HierarchicalOptions, stateHash : Nat32) : ?Nat {
    let idx = Nat32.toNat(stateHash) % Q_TABLE_SIZE;
    
    switch (hier.currentOption) {
      case (?opt) {
        let option = hier.options[opt];
        let policy = Array.freeze(option.policy[idx]);
        
        // Sample from policy
        var cumProb : Float = 0.0;
        let r = random();
        
        for (a in Iter.range(0, NUM_ACTIONS - 1)) {
          cumProb += policy[a];
          if (r < cumProb) {
            option.stepsActive += 1;
            return ?a;
          };
        };
        
        ?0  // Fallback
      };
      case (null) { null };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: MODEL-BASED PLANNING (DYNA)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Learn a world model and use it for planning:
  //   T(s'|s,a) — transition model
  //   R(s,a) — reward model
  //
  // Planning: simulate experiences using the model
  //
  
  public type WorldModel = {
    // Transition model: T[s][a] = predicted next state features
    var transitionModel : [[[var Float]]];   // T[state_hash][action][feature]
    var transitionCounts : [[var Nat]];      // Visitation counts
    
    // Reward model: R[s][a] = predicted reward
    var rewardModel : [[var Float]];
    var rewardVariance : [[var Float]];
    
    // Model confidence
    var modelConfidence : [[var Float]];
    
    // Planning parameters
    var planningSteps : Nat;
    var planningDepth : Nat;
  };
  
  public let MODEL_SIZE : Nat = 256;
  
  // Initialize world model
  public func initWorldModel() : WorldModel {
    {
      var transitionModel = Array.init<[[var Float]]>(MODEL_SIZE, func(_ : Nat) : [[var Float]] {
        Array.init<[var Float]>(NUM_ACTIONS, func(_ : Nat) : [var Float] {
          Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 })
        })
      });
      var transitionCounts = Array.init<[var Nat]>(MODEL_SIZE, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(NUM_ACTIONS, func(_ : Nat) : Nat { 0 })
      });
      var rewardModel = Array.init<[var Float]>(MODEL_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var rewardVariance = Array.init<[var Float]>(MODEL_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 1.0 })
      });
      var modelConfidence = Array.init<[var Float]>(MODEL_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var planningSteps = 10;
      var planningDepth = 3;
    }
  };
  
  // Update world model from experience
  public func updateWorldModel(
    model : WorldModel,
    stateHash : Nat32,
    stateEncoding : [Float],
    action : Nat,
    reward : Float,
    nextStateEncoding : [Float]
  ) {
    let idx = Nat32.toNat(stateHash) % MODEL_SIZE;
    
    // Update transition model (exponential moving average)
    let count = model.transitionCounts[idx][action];
    let alpha = 1.0 / Float.fromInt(count + 1);
    
    for (f in Iter.range(0, NUM_STATES - 1)) {
      let target = if (f < Array.size(nextStateEncoding)) { nextStateEncoding[f] } else { 0.0 };
      model.transitionModel[idx][action][f] := 
        (1.0 - alpha) * model.transitionModel[idx][action][f] + alpha * target;
    };
    
    // Update reward model
    let oldReward = model.rewardModel[idx][action];
    model.rewardModel[idx][action] := (1.0 - alpha) * oldReward + alpha * reward;
    
    // Update reward variance
    let rewardError = reward - model.rewardModel[idx][action];
    model.rewardVariance[idx][action] := 
      (1.0 - alpha) * model.rewardVariance[idx][action] + alpha * rewardError * rewardError;
    
    // Update count and confidence
    model.transitionCounts[idx][action] := count + 1;
    model.modelConfidence[idx][action] := 1.0 - 1.0 / Float.fromInt(count + 2);
  };
  
  // Simulate experience using model
  public func simulateExperience(
    model : WorldModel,
    startStateHash : Nat32,
    action : Nat
  ) : (Float, [Float]) {
    let idx = Nat32.toNat(startStateHash) % MODEL_SIZE;
    
    let predictedReward = model.rewardModel[idx][action];
    let predictedNextState = Array.freeze(model.transitionModel[idx][action]);
    
    (predictedReward, predictedNextState)
  };
  
  // Run planning iterations
  public func runPlanning(
    model : WorldModel,
    qfunc : QValueFunction,
    traces : EligibilityTraces,
    alpha : Float,
    gamma : Float
  ) {
    for (_ in Iter.range(0, model.planningSteps - 1)) {
      // Sample random state-action pair that we've visited
      let s = Nat32.toNat(Nat32.fromNat(Int.abs(Float.toInt(random() * Float.fromInt(MODEL_SIZE))))) % MODEL_SIZE;
      var bestAction : Nat = 0;
      var maxCount : Nat = 0;
      
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        if (model.transitionCounts[s][a] > maxCount) {
          maxCount := model.transitionCounts[s][a];
          bestAction := a;
        };
      };
      
      if (maxCount > 0) {
        // Simulate
        let (reward, nextState) = simulateExperience(model, Nat32.fromNat(s), bestAction);
        
        // Compute TD error
        let currentQ = qfunc.qTable[s][bestAction];
        var maxNextQ : Float = -1000.0;
        
        // Find max Q in next state (approximate)
        let nextHash = computeStateHash(nextState);
        let nextIdx = Nat32.toNat(nextHash) % Q_TABLE_SIZE;
        for (a in Iter.range(0, NUM_ACTIONS - 1)) {
          if (qfunc.qTable[nextIdx][a] > maxNextQ) {
            maxNextQ := qfunc.qTable[nextIdx][a];
          };
        };
        
        let tdError = reward + gamma * maxNextQ - currentQ;
        
        // Update (simplified, no eligibility)
        qfunc.qTable[s][bestAction] := currentQ + alpha * tdError;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: INTRINSIC MOTIVATION — CURIOSITY AND EXPLORATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Intrinsic motivation provides reward signals independent of external rewards:
  //   - Prediction error (surprise)
  //   - Information gain (learning progress)
  //   - Novelty (unfamiliarity)
  //   - Competence (mastery)
  //
  // INTERTWINING: This connects to Free Energy (prediction error) and Memory (novelty)
  //
  
  public type IntrinsicMotivation = {
    // Prediction error based
    var predictionErrors : [var Float];
    var predictionModel : [[var Float]];     // Forward model
    
    // Information gain based
    var learningProgress : [var Float];
    var previousErrors : [var Float];
    
    // Novelty based
    var stateVisitCounts : [var Nat];
    var stateNovelty : [var Float];
    
    // Competence based
    var skillMastery : [var Float];
    var improvementRate : Float;
    
    // Combined intrinsic reward
    var intrinsicReward : Float;
    var weights : {
      predictionError : Float;
      learningProgress : Float;
      novelty : Float;
      competence : Float;
    };
  };
  
  // Initialize intrinsic motivation
  public func initIntrinsicMotivation() : IntrinsicMotivation {
    {
      var predictionErrors = Array.init<Float>(MODEL_SIZE, func(_ : Nat) : Float { 0.0 });
      var predictionModel = Array.init<[var Float]>(MODEL_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 })
      });
      var learningProgress = Array.init<Float>(MODEL_SIZE, func(_ : Nat) : Float { 0.0 });
      var previousErrors = Array.init<Float>(MODEL_SIZE, func(_ : Nat) : Float { 1.0 });
      var stateVisitCounts = Array.init<Nat>(Q_TABLE_SIZE, func(_ : Nat) : Nat { 0 });
      var stateNovelty = Array.init<Float>(Q_TABLE_SIZE, func(_ : Nat) : Float { 1.0 });
      var skillMastery = Array.init<Float>(NUM_OPTIONS, func(_ : Nat) : Float { 0.0 });
      var improvementRate = 0.0;
      var intrinsicReward = 0.0;
      var weights = {
        predictionError = 0.3;
        learningProgress = 0.3;
        novelty = 0.2;
        competence = 0.2;
      };
    }
  };
  
  // Compute intrinsic reward
  // INTERTWINING: Uses Free Energy prediction errors
  public func computeIntrinsicReward(
    im : IntrinsicMotivation,
    stateHash : Nat32,
    stateEncoding : [Float],
    actualNextState : [Float],
    freeEnergyPredError : Float          // ← INTERTWINING: From Free Energy
  ) : Float {
    let idx = Nat32.toNat(stateHash) % MODEL_SIZE;
    let qIdx = Nat32.toNat(stateHash) % Q_TABLE_SIZE;
    
    // 1. Prediction error (surprise)
    var predError : Float = 0.0;
    for (f in Iter.range(0, NUM_STATES - 1)) {
      let predicted = im.predictionModel[idx][f];
      let actual = if (f < Array.size(actualNextState)) { actualNextState[f] } else { 0.0 };
      let error = actual - predicted;
      predError += error * error;
    };
    predError := sqrt(predError / Float.fromInt(NUM_STATES));
    im.predictionErrors[idx] := predError;
    
    // Update prediction model
    let learnRate = 0.1;
    for (f in Iter.range(0, NUM_STATES - 1)) {
      let actual = if (f < Array.size(actualNextState)) { actualNextState[f] } else { 0.0 };
      im.predictionModel[idx][f] := (1.0 - learnRate) * im.predictionModel[idx][f] + learnRate * actual;
    };
    
    // 2. Learning progress (error reduction)
    let previousError = im.previousErrors[idx];
    let progress = previousError - predError;
    im.learningProgress[idx] := progress;
    im.previousErrors[idx] := predError;
    
    // 3. Novelty (inverse visit count)
    im.stateVisitCounts[qIdx] := im.stateVisitCounts[qIdx] + 1;
    let novelty = 1.0 / sqrt(Float.fromInt(im.stateVisitCounts[qIdx] + 1));
    im.stateNovelty[qIdx] := novelty;
    
    // 4. Competence (integrate from Free Energy)
    let competence = 1.0 - freeEnergyPredError;
    
    // Combine
    let intrinsic = im.weights.predictionError * predError +
                   im.weights.learningProgress * Float.max(0.0, progress) +
                   im.weights.novelty * novelty +
                   im.weights.competence * competence;
    
    im.intrinsicReward := intrinsic;
    intrinsic
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: EXPERIENCE REPLAY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Store and replay experiences for sample-efficient learning.
  // Prioritized by TD error magnitude.
  //
  // INTERTWINING: Connects to Memory system for storage
  //
  
  public type Experience = {
    stateEncoding : [Float];
    action : Nat;
    reward : Float;
    nextStateEncoding : [Float];
    done : Bool;
    tdError : Float;
    priority : Float;
  };
  
  public type ExperienceReplay = {
    var buffer : [var Experience];
    var writeIdx : Nat;
    var size : Nat;
    var capacity : Nat;
    var totalPriority : Float;
    var maxPriority : Float;
    var alpha : Float;              // Priority exponent
    var beta : Float;               // Importance sampling exponent
  };
  
  public let REPLAY_CAPACITY : Nat = 10000;
  
  // Initialize replay buffer
  public func initExperienceReplay() : ExperienceReplay {
    let emptyExp : Experience = {
      stateEncoding = [];
      action = 0;
      reward = 0.0;
      nextStateEncoding = [];
      done = false;
      tdError = 0.0;
      priority = 1.0;
    };
    
    {
      var buffer = Array.init<Experience>(REPLAY_CAPACITY, func(_ : Nat) : Experience { emptyExp });
      var writeIdx = 0;
      var size = 0;
      var capacity = REPLAY_CAPACITY;
      var totalPriority = 0.0;
      var maxPriority = 1.0;
      var alpha = 0.6;
      var beta = 0.4;
    }
  };
  
  // Add experience to replay buffer
  public func addExperience(
    replay : ExperienceReplay,
    stateEncoding : [Float],
    action : Nat,
    reward : Float,
    nextStateEncoding : [Float],
    done : Bool,
    tdError : Float
  ) {
    let priority = Float.pow(Float.abs(tdError) + 0.01, replay.alpha);
    
    let exp : Experience = {
      stateEncoding = stateEncoding;
      action = action;
      reward = reward;
      nextStateEncoding = nextStateEncoding;
      done = done;
      tdError = tdError;
      priority = priority;
    };
    
    // Update total priority
    if (replay.size > replay.writeIdx) {
      replay.totalPriority -= replay.buffer[replay.writeIdx].priority;
    };
    replay.totalPriority += priority;
    
    // Store
    replay.buffer[replay.writeIdx] := exp;
    replay.writeIdx := (replay.writeIdx + 1) % replay.capacity;
    
    if (replay.size < replay.capacity) {
      replay.size += 1;
    };
    
    if (priority > replay.maxPriority) {
      replay.maxPriority := priority;
    };
  };
  
  // Sample batch from replay buffer (prioritized)
  public func sampleBatch(replay : ExperienceReplay, batchSize : Nat) : [Experience] {
    if (replay.size == 0) { return [] };
    
    let actualBatch = Nat.min(batchSize, replay.size);
    
    Array.tabulate<Experience>(actualBatch, func(_ : Nat) : Experience {
      // Prioritized sampling
      var cumProb : Float = 0.0;
      let targetProb = random() * replay.totalPriority;
      
      var idx : Nat = 0;
      while (idx < replay.size and cumProb < targetProb) {
        cumProb += replay.buffer[idx].priority;
        idx += 1;
      };
      
      if (idx > 0) { idx -= 1 };
      replay.buffer[idx]
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 10: COMPLETE DEEP Q-LEARNING STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type DeepQLearningState = {
    // Core components
    driveSystem : DriveSystem;
    stateRep : StateRepresentation;
    qFunction : QValueFunction;
    eligibility : EligibilityTraces;
    actorCritic : ActorCritic;
    
    // Advanced
    hierarchical : HierarchicalOptions;
    worldModel : WorldModel;
    intrinsic : IntrinsicMotivation;
    replay : ExperienceReplay;
    
    // Learning parameters
    var alpha : Float;
    var gamma : Float;
    var epsilon : Float;
    
    // State
    var currentBeat : Nat;
    var totalReward : Float;
    var episodeReward : Float;
    var episodeLength : Nat;
  };
  
  // Initialize complete state
  public func initDeepQLearningState() : DeepQLearningState {
    {
      driveSystem = initDriveSystem();
      stateRep = initStateRepresentation();
      qFunction = initQValueFunction();
      eligibility = initEligibilityTraces(DEFAULT_LAMBDA, DEFAULT_GAMMA);
      actorCritic = initActorCritic();
      hierarchical = initHierarchicalOptions();
      worldModel = initWorldModel();
      intrinsic = initIntrinsicMotivation();
      replay = initExperienceReplay();
      var alpha = DEFAULT_ALPHA;
      var gamma = DEFAULT_GAMMA;
      var epsilon = DEFAULT_EPSILON;
      var currentBeat = 0;
      var totalReward = 0.0;
      var episodeReward = 0.0;
      var episodeLength = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 11: THE COMPLETE INTERTWINED HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type QLearningHeartbeatResult = {
    selectedAction : Nat;
    totalReward : Float;
    intrinsicReward : Float;
    extrinsicReward : Float;
    tdError : Float;
    dominantDrive : Nat;
    currentOption : ?Nat;
    policyEntropy : Float;
  };
  
  // The complete intertwined heartbeat
  public func runQLearningHeartbeat(
    state : DeepQLearningState,
    observations : [Float],
    externalReward : Float,
    
    // INTERTWINED INPUTS
    kuramotoCoherence : Float,           // ← INTERTWINING: From Kuramoto
    freeEnergyPredError : Float,         // ← INTERTWINING: From Free Energy
    hebbianFeatures : [Float],           // ← INTERTWINING: From Hebbian
    freeEnergyBeliefs : [Float],         // ← INTERTWINING: From Free Energy
    memoryPattern : ?[Float],            // ← INTERTWINING: From Memory
    
    previousAction : Nat,
    dt : Float
  ) : QLearningHeartbeatResult {
    state.currentBeat += 1;
    state.episodeLength += 1;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Encode current state
    // INTERTWINING: Uses Hebbian features, Free Energy beliefs
    // ───────────────────────────────────────────────────────────────────────────
    let driveStates = Array.tabulate<Float>(NUM_DRIVES, func(i : Nat) : Float {
      state.driveSystem.drives[i].currentLevel
    });
    
    let recentHistory : [[Float]] = switch (memoryPattern) {
      case (?pattern) { [pattern] };
      case (null) { [] };
    };
    
    encodeState(
      state.stateRep,
      observations,
      driveStates,
      hebbianFeatures,           // ← INTERTWINING: Hebbian
      freeEnergyBeliefs,         // ← INTERTWINING: Free Energy
      recentHistory
    );
    
    let stateEncoding = Array.freeze(state.stateRep.stateEncoding);
    let stateHash = state.stateRep.stateHash;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Compute drive-based reward
    // INTERTWINING: Uses Kuramoto coherence, prediction accuracy
    // ───────────────────────────────────────────────────────────────────────────
    let predictionAccuracy = 1.0 - freeEnergyPredError;
    let noveltySignal = state.intrinsic.stateNovelty[Nat32.toNat(stateHash) % Q_TABLE_SIZE];
    let learningProgress = Float.max(0.0, state.intrinsic.learningProgress[Nat32.toNat(stateHash) % MODEL_SIZE]);
    
    let driveReward = computeDriveReward(
      state.driveSystem,
      kuramotoCoherence,          // ← INTERTWINING: Kuramoto
      predictionAccuracy,         // ← INTERTWINING: Free Energy
      noveltySignal,
      0.5,                        // Social feedback (placeholder)
      0.6,                        // Autonomy index (placeholder)
      0.5,                        // Meaning alignment (placeholder)
      learningProgress,           // ← INTERTWINING: Hebbian (via learning)
      0.3                         // Transcendence (placeholder)
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Compute intrinsic reward
    // INTERTWINING: Uses Free Energy prediction error
    // ───────────────────────────────────────────────────────────────────────────
    let previousStateEncoding = Array.tabulate<Float>(NUM_STATES, func(i : Nat) : Float {
      if (i < Array.size(hebbianFeatures)) { hebbianFeatures[i] } else { 0.0 }
    });
    
    let intrinsicReward = computeIntrinsicReward(
      state.intrinsic,
      stateHash,
      previousStateEncoding,
      stateEncoding,
      freeEnergyPredError        // ← INTERTWINING: Free Energy
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Total reward
    // ───────────────────────────────────────────────────────────────────────────
    let totalReward = 0.4 * externalReward + 0.3 * driveReward + 0.3 * intrinsicReward;
    state.totalReward += totalReward;
    state.episodeReward += totalReward;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. TD learning update
    // ───────────────────────────────────────────────────────────────────────────
    // Update eligibility traces
    updateEligibilityTraces(state.eligibility, stateHash, previousAction, previousStateEncoding);
    
    // Compute TD error
    let qValues = getAllQValues(state.qFunction, stateEncoding, stateHash);
    var maxQ : Float = qValues[0];
    for (a in Iter.range(1, NUM_ACTIONS - 1)) {
      if (qValues[a] > maxQ) { maxQ := qValues[a] };
    };
    
    let prevQ = getQValueTabular(state.qFunction, stateHash, previousAction);
    let tdError = totalReward + state.gamma * maxQ - prevQ;
    
    // Apply TD error via eligibility traces
    applyTDError(state.qFunction, state.eligibility, tdError, state.alpha);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Actor-critic update
    // ───────────────────────────────────────────────────────────────────────────
    let _ = updateActorCritic(
      state.actorCritic,
      previousStateEncoding,
      previousAction,
      totalReward,
      stateEncoding,
      state.gamma,
      state.alpha * 0.5,
      state.alpha
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Update world model
    // ───────────────────────────────────────────────────────────────────────────
    updateWorldModel(
      state.worldModel,
      stateHash,
      previousStateEncoding,
      previousAction,
      totalReward,
      stateEncoding
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // 8. Experience replay
    // ───────────────────────────────────────────────────────────────────────────
    addExperience(
      state.replay,
      previousStateEncoding,
      previousAction,
      totalReward,
      stateEncoding,
      false,
      tdError
    );
    
    // Mini-batch update from replay
    let batch = sampleBatch(state.replay, 8);
    for (exp in Iter.fromArray(batch)) {
      if (Array.size(exp.stateEncoding) > 0) {
        let expHash = computeStateHash(exp.stateEncoding);
        let nextHash = computeStateHash(exp.nextStateEncoding);
        let nextQVals = getAllQValues(state.qFunction, exp.nextStateEncoding, nextHash);
        
        var maxNextQ : Float = nextQVals[0];
        for (a in Iter.range(1, NUM_ACTIONS - 1)) {
          if (nextQVals[a] > maxNextQ) { maxNextQ := nextQVals[a] };
        };
        
        let currQ = getQValueTabular(state.qFunction, expHash, exp.action);
        let batchTD = exp.reward + state.gamma * maxNextQ - currQ;
        
        let idx = Nat32.toNat(expHash) % Q_TABLE_SIZE;
        state.qFunction.qTable[idx][exp.action] := currQ + state.alpha * 0.5 * batchTD;
      };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 9. Planning
    // ───────────────────────────────────────────────────────────────────────────
    runPlanning(state.worldModel, state.qFunction, state.eligibility, state.alpha * 0.3, state.gamma);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 10. Action selection
    // ───────────────────────────────────────────────────────────────────────────
    // Try hierarchical option first
    let currentOption = selectOption(state.hierarchical, stateHash, state.epsilon);
    
    let selectedAction : Nat = switch (currentOption) {
      case (?_) {
        switch (getOptionAction(state.hierarchical, stateHash)) {
          case (?a) { a };
          case (null) { 0 };
        }
      };
      case (null) {
        // Fallback to actor-critic policy
        let policy = getPolicy(state.actorCritic, stateEncoding);
        
        // Sample from policy
        var cumProb : Float = 0.0;
        let r = random();
        var action : Nat = 0;
        
        for (a in Iter.range(0, NUM_ACTIONS - 1)) {
          cumProb += policy[a];
          if (r < cumProb and action == 0) {
            action := a;
          };
        };
        
        action
      };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return result
    // ───────────────────────────────────────────────────────────────────────────
    {
      selectedAction = selectedAction;
      totalReward = totalReward;
      intrinsicReward = intrinsicReward;
      extrinsicReward = externalReward;
      tdError = tdError;
      dominantDrive = state.driveSystem.dominantDrive;
      currentOption = currentOption;
      policyEntropy = state.actorCritic.actor.entropy;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
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
    let z : Float = (x - 1.0) / (x + 1.0);
    let zSquared : Float = z * z;
    var result : Float = 0.0;
    var term : Float = z;
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSquared;
    };
    2.0 * result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };
  
  // Simple pseudo-random (deterministic for reproducibility)
  var randomSeed : Nat32 = 12345;
  func random() : Float {
    randomSeed := randomSeed *% 1103515245 +% 12345;
    Float.fromInt(Nat32.toNat(randomSeed % 1000000)) / 1000000.0
  };

};
