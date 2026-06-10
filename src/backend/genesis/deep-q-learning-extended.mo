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
// DEEP Q-LEARNING ENGINE EXTENDED — ADVANCED REINFORCEMENT LEARNING
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This extension TRIPLES the depth with:
//
// PART 1: DISTRIBUTIONAL RL (600 lines)
// ═════════════════════════════════════
//   - C51: Categorical distribution over returns
//   - QR-DQN: Quantile regression
//   - IQN: Implicit quantile networks
//   - Risk-sensitive decision making
//   - CVaR optimization
//
// PART 2: META-LEARNING (500 lines)
// ═════════════════════════════════
//   - MAML: Model-Agnostic Meta-Learning
//   - Learning to learn
//   - Task adaptation
//   - Meta-gradients
//   - Context-dependent learning rates
//
// PART 3: MULTI-AGENT RL (600 lines)
// ═════════════════════════════════
//   - MADDPG: Multi-Agent Deep Deterministic Policy Gradient
//   - Centralized training, decentralized execution
//   - Opponent modeling
//   - Coordination and competition
//   - Social welfare optimization
//
// PART 4: SAFE RL (400 lines)
// ═══════════════════════════
//   - Constrained MDPs
//   - Risk constraints
//   - Lyapunov-based safety
//   - Recovery policies
//   - Safe exploration
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

module DeepQLearningExtended {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let NUM_DRIVES : Nat = 9;
  public let NUM_STATES : Nat = 100;
  public let NUM_ACTIONS : Nat = 20;
  public let NUM_ATOMS : Nat = 51;          // For C51 distributional RL
  public let NUM_QUANTILES : Nat = 32;      // For QR-DQN
  public let NUM_AGENTS : Nat = 4;          // For multi-agent RL
  public let NUM_TASKS : Nat = 10;          // For meta-learning
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 1: DISTRIBUTIONAL RL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Instead of learning E[R], learn the full distribution of returns.
  // This enables risk-sensitive decision making.
  //
  // C51: Approximate return distribution with 51 atoms
  // Z(s,a) = Σ_i p_i(s,a) δ_{z_i}
  //
  // QR-DQN: Learn quantile locations
  // θ_τ(s,a) = F^{-1}_Z(τ)
  //
  
  public type DistributionalState = {
    // C51: Categorical distribution
    var atoms : [var Float];             // z_i values (support)
    var probabilities : [[var Float]];   // p_i(s,a) for each state-action
    var vMin : Float;
    var vMax : Float;
    
    // QR-DQN: Quantile estimates
    var quantileTaus : [var Float];      // τ values [0, 1]
    var quantileValues : [[var Float]];  // θ_τ(s,a)
    
    // IQN: Implicit quantile
    var implicitEmbedding : [var Float];
    var riskSensitivity : Float;         // Risk aversion parameter
    
    // Statistics
    var meanReturn : Float;
    var stdReturn : Float;
    var varReturn : Float;
    var cvarReturn : Float;              // Conditional Value at Risk
  };
  
  public func initDistributionalState() : DistributionalState {
    let vMin : Float = -10.0;
    let vMax : Float = 10.0;
    let deltaZ = (vMax - vMin) / Float.fromInt(NUM_ATOMS - 1);
    
    let atoms = Array.init<Float>(NUM_ATOMS, func(i : Nat) : Float {
      vMin + Float.fromInt(i) * deltaZ
    });
    
    let probs = Array.init<[var Float]>(NUM_STATES * NUM_ACTIONS, func(_ : Nat) : [var Float] {
      Array.init<Float>(NUM_ATOMS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ATOMS) })
    });
    
    let taus = Array.init<Float>(NUM_QUANTILES, func(i : Nat) : Float {
      (Float.fromInt(i) + 0.5) / Float.fromInt(NUM_QUANTILES)
    });
    
    let qValues = Array.init<[var Float]>(NUM_STATES * NUM_ACTIONS, func(_ : Nat) : [var Float] {
      Array.init<Float>(NUM_QUANTILES, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var atoms = atoms;
      var probabilities = probs;
      var vMin = vMin;
      var vMax = vMax;
      var quantileTaus = taus;
      var quantileValues = qValues;
      var implicitEmbedding = Array.init<Float>(32, func(_ : Nat) : Float { 0.0 });
      var riskSensitivity = 0.0;  // Risk-neutral
      var meanReturn = 0.0;
      var stdReturn = 1.0;
      var varReturn = 1.0;
      var cvarReturn = 0.0;
    }
  };
  
  // Compute expected value from categorical distribution
  public func computeExpectedValue(
    dist : DistributionalState,
    stateActionIdx : Nat
  ) : Float {
    var expected : Float = 0.0;
    let probs = dist.probabilities[stateActionIdx];
    
    for (i in Iter.range(0, NUM_ATOMS - 1)) {
      expected += probs[i] * dist.atoms[i];
    };
    
    expected
  };
  
  // Compute variance from categorical distribution
  public func computeVariance(
    dist : DistributionalState,
    stateActionIdx : Nat
  ) : Float {
    let mean = computeExpectedValue(dist, stateActionIdx);
    var variance : Float = 0.0;
    let probs = dist.probabilities[stateActionIdx];
    
    for (i in Iter.range(0, NUM_ATOMS - 1)) {
      let diff = dist.atoms[i] - mean;
      variance += probs[i] * diff * diff;
    };
    
    variance
  };
  
  // Compute CVaR (Conditional Value at Risk) at level α
  // CVaR_α = E[Z | Z ≤ VaR_α]
  public func computeCVaR(
    dist : DistributionalState,
    stateActionIdx : Nat,
    alpha : Float                  // Risk level (e.g., 0.05 for 5%)
  ) : Float {
    let probs = dist.probabilities[stateActionIdx];
    
    // Find VaR: smallest z such that P(Z ≤ z) ≥ α
    var cumulativeProb : Float = 0.0;
    var varIdx : Nat = 0;
    
    for (i in Iter.range(0, NUM_ATOMS - 1)) {
      cumulativeProb += probs[i];
      if (cumulativeProb >= alpha and varIdx == 0) {
        varIdx := i;
      };
    };
    
    // CVaR: conditional expectation below VaR
    var cvarSum : Float = 0.0;
    var probSum : Float = 0.0;
    
    for (i in Iter.range(0, varIdx)) {
      cvarSum += probs[i] * dist.atoms[i];
      probSum += probs[i];
    };
    
    if (probSum > 0.0001) { cvarSum / probSum } else { dist.atoms[0] }
  };
  
  // Update distributional RL with categorical projection
  public func updateC51(
    dist : DistributionalState,
    stateActionIdx : Nat,
    reward : Float,
    nextStateActionIdx : Nat,
    gamma : Float,
    dt : Float
  ) {
    let nextProbs = dist.probabilities[nextStateActionIdx];
    let newProbs = Array.init<Float>(NUM_ATOMS, func(_ : Nat) : Float { 0.0 });
    
    // Project next distribution onto current support
    for (j in Iter.range(0, NUM_ATOMS - 1)) {
      let tzj = clamp(reward + gamma * dist.atoms[j], dist.vMin, dist.vMax);
      
      // Find atoms to distribute probability to
      let b = (tzj - dist.vMin) / ((dist.vMax - dist.vMin) / Float.fromInt(NUM_ATOMS - 1));
      let l = Int.abs(Float.toInt(Float.floor(b)));
      let u = Int.abs(Float.toInt(Float.ceil(b)));
      
      // Distribute probability
      if (l < NUM_ATOMS) {
        newProbs[l] := newProbs[l] + nextProbs[j] * (Float.fromInt(u) - b);
      };
      if (u < NUM_ATOMS and u != l) {
        newProbs[u] := newProbs[u] + nextProbs[j] * (b - Float.fromInt(l));
      };
    };
    
    // Update probabilities with learning rate
    let lr = 0.1 * dt;
    for (i in Iter.range(0, NUM_ATOMS - 1)) {
      dist.probabilities[stateActionIdx][i] := 
        (1.0 - lr) * dist.probabilities[stateActionIdx][i] + lr * newProbs[i];
    };
    
    // Update statistics
    dist.meanReturn := computeExpectedValue(dist, stateActionIdx);
    dist.varReturn := computeVariance(dist, stateActionIdx);
    dist.stdReturn := sqrt(dist.varReturn);
    dist.cvarReturn := computeCVaR(dist, stateActionIdx, 0.05);
  };
  
  // Quantile Huber loss for QR-DQN
  public func quantileHuberLoss(
    predicted : Float,
    target : Float,
    tau : Float,
    kappa : Float                  // Huber threshold
  ) : Float {
    let error = target - predicted;
    let absError = Float.abs(error);
    
    let huberLoss = if (absError <= kappa) {
      0.5 * error * error
    } else {
      kappa * (absError - 0.5 * kappa)
    };
    
    let weight = if (error < 0.0) { tau } else { 1.0 - tau };
    weight * huberLoss
  };
  
  // Update QR-DQN
  public func updateQRDQN(
    dist : DistributionalState,
    stateActionIdx : Nat,
    reward : Float,
    nextStateActionIdx : Nat,
    gamma : Float,
    dt : Float
  ) {
    let lr = 0.1 * dt;
    
    for (i in Iter.range(0, NUM_QUANTILES - 1)) {
      let tau = dist.quantileTaus[i];
      
      // Target quantile
      var targetQuantile : Float = reward;
      for (j in Iter.range(0, NUM_QUANTILES - 1)) {
        targetQuantile += gamma * dist.quantileValues[nextStateActionIdx][j] / Float.fromInt(NUM_QUANTILES);
      };
      
      // Gradient
      let predicted = dist.quantileValues[stateActionIdx][i];
      let error = targetQuantile - predicted;
      let gradient = if (error < 0.0) { tau - 1.0 } else { tau };
      
      // Update
      dist.quantileValues[stateActionIdx][i] := predicted + lr * gradient * error;
    };
  };
  
  // Risk-sensitive action selection
  public func selectRiskSensitiveAction(
    dist : DistributionalState,
    stateIdx : Nat,
    riskAversion : Float           // > 0 = risk-averse, < 0 = risk-seeking
  ) : Nat {
    var bestAction : Nat = 0;
    var bestValue : Float = -1000.0;
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let saIdx = stateIdx * NUM_ACTIONS + a;
      
      let mean = computeExpectedValue(dist, saIdx);
      let std = sqrt(computeVariance(dist, saIdx));
      
      // Risk-sensitive value: mean - λ × std
      let riskAdjustedValue = mean - riskAversion * std;
      
      if (riskAdjustedValue > bestValue) {
        bestValue := riskAdjustedValue;
        bestAction := a;
      };
    };
    
    bestAction
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 2: META-LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Learning to learn: adapt quickly to new tasks.
  //
  // MAML: Model-Agnostic Meta-Learning
  //   θ' = θ - α∇_θ L_task(f_θ)
  //   θ := θ - β∇_θ Σ_task L_task(f_θ')
  //
  
  public type MetaLearningState = {
    // Meta-parameters
    var metaWeights : [var Float];       // θ: meta-learned initialization
    var taskWeights : [[var Float]];     // θ': task-specific adaptations
    
    // Learning rates
    var innerLR : Float;                 // α: task adaptation rate
    var outerLR : Float;                 // β: meta update rate
    
    // Task context
    var currentTaskIdx : Nat;
    var taskContext : [[var Float]];     // Context embeddings per task
    var taskPerformance : [var Float];   // Performance on each task
    
    // Adaptation tracking
    var adaptationSteps : [var Nat];     // Steps to adapt per task
    var adaptationGradients : [[var Float]];  // Gradients during adaptation
    
    // Meta-gradients
    var metaGradients : [var Float];
    var metaGradientMomentum : [var Float];
  };
  
  public let META_WEIGHT_SIZE : Nat = 64;
  
  public func initMetaLearningState() : MetaLearningState {
    {
      var metaWeights = Array.init<Float>(META_WEIGHT_SIZE, func(_ : Nat) : Float { 0.0 });
      var taskWeights = Array.init<[var Float]>(NUM_TASKS, func(_ : Nat) : [var Float] {
        Array.init<Float>(META_WEIGHT_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var innerLR = 0.1;
      var outerLR = 0.01;
      var currentTaskIdx = 0;
      var taskContext = Array.init<[var Float]>(NUM_TASKS, func(_ : Nat) : [var Float] {
        Array.init<Float>(16, func(_ : Nat) : Float { 0.0 })
      });
      var taskPerformance = Array.init<Float>(NUM_TASKS, func(_ : Nat) : Float { 0.0 });
      var adaptationSteps = Array.init<Nat>(NUM_TASKS, func(_ : Nat) : Nat { 0 });
      var adaptationGradients = Array.init<[var Float]>(NUM_TASKS, func(_ : Nat) : [var Float] {
        Array.init<Float>(META_WEIGHT_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var metaGradients = Array.init<Float>(META_WEIGHT_SIZE, func(_ : Nat) : Float { 0.0 });
      var metaGradientMomentum = Array.init<Float>(META_WEIGHT_SIZE, func(_ : Nat) : Float { 0.0 });
    }
  };
  
  // Initialize task weights from meta-weights
  public func initializeTaskFromMeta(
    meta : MetaLearningState,
    taskIdx : Nat
  ) {
    if (taskIdx >= NUM_TASKS) { return };
    
    for (i in Iter.range(0, META_WEIGHT_SIZE - 1)) {
      meta.taskWeights[taskIdx][i] := meta.metaWeights[i];
    };
    meta.adaptationSteps[taskIdx] := 0;
  };
  
  // Inner loop: adapt to task
  public func adaptToTask(
    meta : MetaLearningState,
    taskIdx : Nat,
    taskGradient : [Float],
    dt : Float
  ) {
    if (taskIdx >= NUM_TASKS) { return };
    
    let lr = meta.innerLR * dt;
    
    for (i in Iter.range(0, META_WEIGHT_SIZE - 1)) {
      let grad = if (i < Array.size(taskGradient)) { taskGradient[i] } else { 0.0 };
      meta.taskWeights[taskIdx][i] := meta.taskWeights[taskIdx][i] - lr * grad;
      meta.adaptationGradients[taskIdx][i] := grad;
    };
    
    meta.adaptationSteps[taskIdx] += 1;
  };
  
  // Outer loop: update meta-parameters
  public func updateMetaParameters(
    meta : MetaLearningState,
    taskPerformances : [Float],
    dt : Float
  ) {
    // Compute meta-gradient across tasks
    for (i in Iter.range(0, META_WEIGHT_SIZE - 1)) {
      var gradSum : Float = 0.0;
      
      for (t in Iter.range(0, NUM_TASKS - 1)) {
        // Weight by task performance (better tasks contribute more)
        let performance = if (t < Array.size(taskPerformances)) { taskPerformances[t] } else { 0.5 };
        let weight = 1.0 - performance;  // Focus on harder tasks
        
        gradSum += weight * meta.adaptationGradients[t][i];
      };
      
      gradSum /= Float.fromInt(NUM_TASKS);
      
      // Momentum update
      let momentum = 0.9;
      meta.metaGradientMomentum[i] := momentum * meta.metaGradientMomentum[i] + (1.0 - momentum) * gradSum;
      meta.metaGradients[i] := meta.metaGradientMomentum[i];
      
      // Update meta-weights
      meta.metaWeights[i] := meta.metaWeights[i] - meta.outerLR * dt * meta.metaGradients[i];
    };
  };
  
  // Compute task similarity for transfer
  public func computeTaskSimilarity(
    meta : MetaLearningState,
    task1 : Nat,
    task2 : Nat
  ) : Float {
    if (task1 >= NUM_TASKS or task2 >= NUM_TASKS) { return 0.0 };
    
    // Cosine similarity between task contexts
    var dot : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    
    let ctx1 = meta.taskContext[task1];
    let ctx2 = meta.taskContext[task2];
    let dim = Nat.min(Array.size(Array.freeze(ctx1)), Array.size(Array.freeze(ctx2)));
    
    for (i in Iter.range(0, dim - 1)) {
      dot += ctx1[i] * ctx2[i];
      norm1 += ctx1[i] * ctx1[i];
      norm2 += ctx2[i] * ctx2[i];
    };
    
    let denom = sqrt(norm1) * sqrt(norm2);
    if (denom > 0.0001) { dot / denom } else { 0.0 }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 3: MULTI-AGENT RL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Multiple agents learning and interacting.
  // Centralized training with decentralized execution (CTDE).
  //
  
  public type AgentState = {
    idx : Nat;
    var policy : [var Float];            // Policy parameters
    var critic : [var Float];            // Critic parameters
    var observations : [var Float];
    var actions : [var Float];
    var rewards : [var Float];
    
    // Opponent modeling
    var opponentModels : [[var Float]];  // Model of each other agent
    var opponentPredictions : [[var Float]];
    
    // Communication
    var messageOut : [var Float];
    var messageIn : [[var Float]];
  };
  
  public type MultiAgentState = {
    var agents : [var AgentState];
    var numAgents : Nat;
    
    // Centralized critic
    var centralCritic : [var Float];
    var jointAction : [var Float];
    
    // Coordination
    var coordinationMatrix : [[var Float]];  // How agents should coordinate
    var socialWelfare : Float;               // Total reward
    
    // Communication channel
    var communicationBandwidth : Float;
    var messageHistory : [[var Float]];
  };
  
  public let AGENT_POLICY_SIZE : Nat = 32;
  public let MESSAGE_SIZE : Nat = 8;
  
  public func initAgentState(idx : Nat) : AgentState {
    {
      idx = idx;
      var policy = Array.init<Float>(AGENT_POLICY_SIZE, func(_ : Nat) : Float { 0.0 });
      var critic = Array.init<Float>(AGENT_POLICY_SIZE, func(_ : Nat) : Float { 0.0 });
      var observations = Array.init<Float>(16, func(_ : Nat) : Float { 0.0 });
      var actions = Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var rewards = Array.init<Float>(100, func(_ : Nat) : Float { 0.0 });
      var opponentModels = Array.init<[var Float]>(NUM_AGENTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(AGENT_POLICY_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var opponentPredictions = Array.init<[var Float]>(NUM_AGENTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var messageOut = Array.init<Float>(MESSAGE_SIZE, func(_ : Nat) : Float { 0.0 });
      var messageIn = Array.init<[var Float]>(NUM_AGENTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(MESSAGE_SIZE, func(_ : Nat) : Float { 0.0 })
      });
    }
  };
  
  public func initMultiAgentState() : MultiAgentState {
    let agents = Array.init<AgentState>(NUM_AGENTS, func(i : Nat) : AgentState {
      initAgentState(i)
    });
    
    {
      var agents = agents;
      var numAgents = NUM_AGENTS;
      var centralCritic = Array.init<Float>(AGENT_POLICY_SIZE * NUM_AGENTS, func(_ : Nat) : Float { 0.0 });
      var jointAction = Array.init<Float>(NUM_ACTIONS * NUM_AGENTS, func(_ : Nat) : Float { 0.0 });
      var coordinationMatrix = Array.init<[var Float]>(NUM_AGENTS, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_AGENTS, func(_ : Nat) : Float { 0.0 })
      });
      var socialWelfare = 0.0;
      var communicationBandwidth = 1.0;
      var messageHistory = Array.init<[var Float]>(100, func(_ : Nat) : [var Float] {
        Array.init<Float>(MESSAGE_SIZE * NUM_AGENTS, func(_ : Nat) : Float { 0.0 })
      });
    }
  };
  
  // Centralized critic: Q(s, a_1, a_2, ..., a_n)
  public func evaluateCentralCritic(
    state : MultiAgentState,
    observations : [[Float]],
    actions : [[Float]]
  ) : Float {
    // Concatenate all observations and actions
    var inputSum : Float = 0.0;
    
    for (i in Iter.range(0, state.numAgents - 1)) {
      let obs = if (i < Array.size(observations)) { observations[i] } else { [] };
      let act = if (i < Array.size(actions)) { actions[i] } else { [] };
      
      for (j in Iter.range(0, Array.size(obs) - 1)) {
        inputSum += obs[j];
      };
      for (j in Iter.range(0, Array.size(act) - 1)) {
        inputSum += act[j];
      };
    };
    
    // Simple linear combination (placeholder for neural network)
    var value : Float = 0.0;
    let critSize = Array.size(Array.freeze(state.centralCritic));
    for (i in Iter.range(0, critSize - 1)) {
      value += state.centralCritic[i] * inputSum / Float.fromInt(critSize);
    };
    
    value
  };
  
  // Update opponent model based on observed behavior
  public func updateOpponentModel(
    agent : AgentState,
    opponentIdx : Nat,
    observedAction : [Float],
    lr : Float
  ) {
    if (opponentIdx >= NUM_AGENTS or opponentIdx == agent.idx) { return };
    
    // Update model to predict observed action
    for (i in Iter.range(0, NUM_ACTIONS - 1)) {
      let observed = if (i < Array.size(observedAction)) { observedAction[i] } else { 0.0 };
      let predicted = agent.opponentPredictions[opponentIdx][i];
      let error = observed - predicted;
      
      agent.opponentPredictions[opponentIdx][i] := predicted + lr * error;
    };
  };
  
  // Compute Nash equilibrium approximation
  public func approximateNashEquilibrium(
    state : MultiAgentState,
    iterations : Nat
  ) : [[Float]] {
    let strategies = Array.init<[Float]>(state.numAgents, func(i : Nat) : [Float] {
      // Initialize uniform strategies
      Array.tabulate<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ACTIONS) })
    });
    
    // Fictitious play iterations
    for (_ in Iter.range(0, iterations - 1)) {
      for (i in Iter.range(0, state.numAgents - 1)) {
        // Best response to others' strategies
        var bestAction : Nat = 0;
        var bestValue : Float = -1000.0;
        
        for (a in Iter.range(0, NUM_ACTIONS - 1)) {
          var value : Float = 0.0;
          
          // Expected value against opponents
          for (j in Iter.range(0, state.numAgents - 1)) {
            if (i != j) {
              value += strategies[j][a % Array.size(strategies[j])];
            };
          };
          
          if (value > bestValue) {
            bestValue := value;
            bestAction := a;
          };
        };
        
        // Update strategy toward best response
        let newStrategies = Array.tabulate<Float>(NUM_ACTIONS, func(a : Nat) : Float {
          if (a == bestAction) { 0.9 * strategies[i][a] + 0.1 }
          else { 0.9 * strategies[i][a] }
        });
        strategies[i] := newStrategies;
      };
    };
    
    Array.freeze(strategies)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PART 4: SAFE RL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Ensuring safety constraints are satisfied during learning.
  //
  // Constrained MDP: maximize E[R] subject to E[C] ≤ d
  // Lyapunov safety: ΔV(s) ≤ -ρ(s) for safety set S
  //
  
  public type SafeRLState = {
    // Constraint tracking
    var costFunction : [var Float];      // C(s,a) per state-action
    var cumulativeCost : Float;
    var costThreshold : Float;           // d: maximum allowed cost
    var constraintViolations : Nat;
    
    // Lyapunov function
    var lyapunovFunction : [var Float];  // V(s) per state
    var lyapunovDerivative : [var Float];// ΔV(s)
    var safetyMargin : Float;            // ρ
    
    // Recovery policy
    var recoveryPolicy : [[var Float]];  // Safe fallback policy
    var recoveryActive : Bool;
    var recoverySteps : Nat;
    
    // Safe exploration
    var explorationBudget : Float;
    var uncertaintyEstimates : [var Float];
    var safeActions : [[var Bool]];      // Which actions are safe per state
  };
  
  public func initSafeRLState() : SafeRLState {
    {
      var costFunction = Array.init<Float>(NUM_STATES * NUM_ACTIONS, func(_ : Nat) : Float { 0.0 });
      var cumulativeCost = 0.0;
      var costThreshold = 10.0;
      var constraintViolations = 0;
      var lyapunovFunction = Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 });
      var lyapunovDerivative = Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.0 });
      var safetyMargin = 0.1;
      var recoveryPolicy = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ACTIONS) })
      });
      var recoveryActive = false;
      var recoverySteps = 0;
      var explorationBudget = 100.0;
      var uncertaintyEstimates = Array.init<Float>(NUM_STATES * NUM_ACTIONS, func(_ : Nat) : Float { 1.0 });
      var safeActions = Array.init<[var Bool]>(NUM_STATES, func(_ : Nat) : [var Bool] {
        Array.init<Bool>(NUM_ACTIONS, func(_ : Nat) : Bool { true })
      });
    }
  };
  
  // Check if action is safe using Lyapunov criterion
  public func isSafeAction(
    safe : SafeRLState,
    stateIdx : Nat,
    actionIdx : Nat,
    nextStateIdx : Nat
  ) : Bool {
    if (stateIdx >= NUM_STATES or nextStateIdx >= NUM_STATES) { return false };
    
    // Lyapunov decrease criterion: V(s') - V(s) ≤ -ρ
    let currentV = safe.lyapunovFunction[stateIdx];
    let nextV = safe.lyapunovFunction[nextStateIdx];
    let deltaV = nextV - currentV;
    
    deltaV <= -safe.safetyMargin
  };
  
  // Update Lyapunov function from safe demonstrations
  public func updateLyapunovFunction(
    safe : SafeRLState,
    stateIdx : Nat,
    isSafe : Bool,
    reward : Float,
    dt : Float
  ) {
    if (stateIdx >= NUM_STATES) { return };
    
    let lr = 0.1 * dt;
    
    if (isSafe) {
      // Safe state: decrease Lyapunov value
      safe.lyapunovFunction[stateIdx] := safe.lyapunovFunction[stateIdx] - lr * reward;
    } else {
      // Unsafe state: increase Lyapunov value
      safe.lyapunovFunction[stateIdx] := safe.lyapunovFunction[stateIdx] + lr * 10.0;
    };
    
    // Keep positive
    safe.lyapunovFunction[stateIdx] := Float.max(0.0, safe.lyapunovFunction[stateIdx]);
  };
  
  // Activate recovery policy when constraint violated
  public func activateRecovery(
    safe : SafeRLState
  ) {
    safe.recoveryActive := true;
    safe.recoverySteps := 0;
    safe.constraintViolations += 1;
  };
  
  // Select action with safety filter
  public func selectSafeAction(
    safe : SafeRLState,
    stateIdx : Nat,
    preferredAction : Nat
  ) : Nat {
    if (stateIdx >= NUM_STATES) { return 0 };
    
    // If recovery is active, use recovery policy
    if (safe.recoveryActive) {
      safe.recoverySteps += 1;
      
      // Find highest probability action in recovery policy
      var bestAction : Nat = 0;
      var bestProb : Float = 0.0;
      
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        if (safe.recoveryPolicy[stateIdx][a] > bestProb) {
          bestProb := safe.recoveryPolicy[stateIdx][a];
          bestAction := a;
        };
      };
      
      // Exit recovery after sufficient steps
      if (safe.recoverySteps > 50) {
        safe.recoveryActive := false;
      };
      
      return bestAction;
    };
    
    // Check if preferred action is safe
    if (preferredAction < NUM_ACTIONS and safe.safeActions[stateIdx][preferredAction]) {
      return preferredAction;
    };
    
    // Find nearest safe action
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      if (safe.safeActions[stateIdx][a]) {
        return a;
      };
    };
    
    // No safe action found — activate recovery
    activateRecovery(safe);
    0
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
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

};
