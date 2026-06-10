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
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";

module QLearningEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let E : Float = 2.71828182845904523536;
  
  // Learning parameters
  public let ALPHA : Float = 0.1;      // Learning rate
  public let GAMMA : Float = 0.95;     // Discount factor (high = long-term thinking)
  public let EPSILON : Float = 0.1;    // Exploration rate
  public let LAMBDA : Float = 0.9;     // Eligibility trace decay
  
  // Softmax temperature
  public let TEMPERATURE : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // 8 ACTIONS — The organism's behavioral repertoire
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Action = {
    #Consolidate;     // 0: Strengthen existing patterns, reduce exploration
    #Explore;         // 1: Increase curiosity, seek novelty
    #Defend;          // 2: Activate AEGIS, protect sovereignty
    #Integrate;       // 3: Cross-shell binding, unify processing
    #Rest;            // 4: Enter low-energy mode, recover resources
    #Create;          // 5: Generate novel patterns, divergent thinking
    #Remember;        // 6: Activate memory consolidation, episodic retrieval
    #Execute;         // 7: Focused execution, goal-directed behavior
  };
  
  public let NUM_ACTIONS : Nat = 8;
  
  public let ACTION_NAMES : [Text] = [
    "CONSOLIDATE",
    "EXPLORE", 
    "DEFEND",
    "INTEGRATE",
    "REST",
    "CREATE",
    "REMEMBER",
    "EXECUTE"
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // 5 DRIVES — Competing motivational systems
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Drive = {
    #SovereignCoherence;  // Maintain high coherence
    #ErrorCorrection;     // Reduce prediction errors (free energy)
    #Curiosity;           // Seek novel information (ΔH)
    #MemoryResolution;    // Resolve memory conflicts, consolidate
    #Survival;            // Threat response, self-preservation
  };
  
  public type DriveState = {
    name : Text;
    strength : Float;         // Current drive strength [0, 1]
    baseline : Float;         // Homeostatic setpoint
    sensitivity : Float;      // How responsive to triggers
    decayRate : Float;        // How fast it returns to baseline
    lastTriggerBeat : Int;    // When last activated
  };
  
  public let INITIAL_DRIVES : [DriveState] = [
    { name = "SOVEREIGN_COHERENCE"; strength = 0.8; baseline = 0.7; sensitivity = 0.5; decayRate = 0.02; lastTriggerBeat = 0 },
    { name = "ERROR_CORRECTION"; strength = 0.5; baseline = 0.4; sensitivity = 0.6; decayRate = 0.03; lastTriggerBeat = 0 },
    { name = "CURIOSITY"; strength = 0.6; baseline = 0.5; sensitivity = 0.7; decayRate = 0.04; lastTriggerBeat = 0 },
    { name = "MEMORY_RESOLUTION"; strength = 0.4; baseline = 0.3; sensitivity = 0.4; decayRate = 0.02; lastTriggerBeat = 0 },
    { name = "SURVIVAL"; strength = 0.3; baseline = 0.2; sensitivity = 0.9; decayRate = 0.01; lastTriggerBeat = 0 },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // STATE REPRESENTATION — Discretized organism state for Q-table
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type StateIndex = Nat;  // Discretized state index
  
  public type ContinuousState = {
    coherence : Float;         // [0, 1]
    freeEnergy : Float;        // [0, 1] 
    novelty : Float;           // [0, 1] (ΔH normalized)
    threatLevel : Float;       // [0, 1] (from AEGIS)
    memoryLoad : Float;        // [0, 1] (episodic buffer fullness)
    resourceLevel : Float;     // [0, 1] (FORMA balance normalized)
    dominantDrive : Nat;       // Which drive is strongest [0-4]
    recentAction : Nat;        // Last action taken [0-7]
  };
  
  // Discretize continuous state into index
  // Uses 3 levels per dimension for manageable state space
  public func discretizeState(state : ContinuousState) : StateIndex {
    let coherenceBin = discretize3(state.coherence);
    let freeEnergyBin = discretize3(state.freeEnergy);
    let noveltyBin = discretize3(state.novelty);
    let threatBin = discretize3(state.threatLevel);
    
    // Combine into single index (3^4 × 5 × 8 = 3240 states)
    let baseIndex = coherenceBin * 27 + freeEnergyBin * 9 + noveltyBin * 3 + threatBin;
    let driveOffset = state.dominantDrive * 81;
    let actionOffset = state.recentAction * 405;
    
    baseIndex + driveOffset + actionOffset
  };
  
  func discretize3(value : Float) : Nat {
    if (value < 0.33) { 0 }
    else if (value < 0.67) { 1 }
    else { 2 }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Q-TABLE — State-Action value function
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QTable = {
    var values : [[var Float]];        // [state][action] → Q-value
    var visitCounts : [[var Nat]];     // For UCB exploration
    var eligibility : [[var Float]];   // Eligibility traces
    totalUpdates : Nat;
    lastUpdateBeat : Int;
  };
  
  public let NUM_STATES : Nat = 3240;  // Discretized state space size
  
  public func initQTable() : QTable {
    {
      var values = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.5 })  // Optimistic initialization
      });
      var visitCounts = Array.init<[var Nat]>(NUM_STATES, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(NUM_ACTIONS, func(_ : Nat) : Nat { 0 })
      });
      var eligibility = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      totalUpdates = 0;
      lastUpdateBeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // Q-LEARNING UPDATE — TD(0) with experience
  // δ = r + γ × max_a' Q(s', a') - Q(s, a)
  // Q(s, a) ← Q(s, a) + α × δ
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Experience = {
    state : StateIndex;
    action : Nat;
    reward : Float;
    nextState : StateIndex;
    done : Bool;
  };
  
  public func qLearningUpdate(
    qTable : QTable,
    exp : Experience,
    alpha : Float,
    gamma : Float
  ) : Float {
    let currentQ = qTable.values[exp.state][exp.action];
    
    // Find max Q for next state
    var maxNextQ : Float = -1000.0;
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let q = qTable.values[exp.nextState][a];
      if (q > maxNextQ) { maxNextQ := q };
    };
    
    // TD error: δ = r + γ × max_a' Q(s', a') - Q(s, a)
    let tdError = if (exp.done) { 
      exp.reward - currentQ 
    } else { 
      exp.reward + gamma * maxNextQ - currentQ 
    };
    
    // Update Q-value
    let newQ = currentQ + alpha * tdError;
    qTable.values[exp.state][exp.action] := newQ;
    
    // Update visit count
    qTable.visitCounts[exp.state][exp.action] += 1;
    
    tdError  // Return TD error for monitoring
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SARSA UPDATE — On-policy TD learning
  // δ = r + γ × Q(s', a') - Q(s, a)  (uses actual next action, not max)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func sarsaUpdate(
    qTable : QTable,
    state : StateIndex,
    action : Nat,
    reward : Float,
    nextState : StateIndex,
    nextAction : Nat,
    alpha : Float,
    gamma : Float
  ) : Float {
    let currentQ = qTable.values[state][action];
    let nextQ = qTable.values[nextState][nextAction];
    
    let tdError = reward + gamma * nextQ - currentQ;
    let newQ = currentQ + alpha * tdError;
    qTable.values[state][action] := newQ;
    
    tdError
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ELIGIBILITY TRACES — TD(λ) for temporal credit assignment
  // e(s,a) ← γλe(s,a) + 1 if (s,a) = current state-action
  // ∀(s,a): Q(s,a) ← Q(s,a) + αδe(s,a)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateEligibilityTraces(
    qTable : QTable,
    currentState : StateIndex,
    currentAction : Nat,
    gamma : Float,
    lambda : Float
  ) : () {
    // Decay all traces
    for (s in Iter.range(0, NUM_STATES - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        qTable.eligibility[s][a] := gamma * lambda * qTable.eligibility[s][a];
      };
    };
    
    // Increment current state-action trace
    qTable.eligibility[currentState][currentAction] += 1.0;
  };
  
  public func applyEligibilityUpdate(
    qTable : QTable,
    tdError : Float,
    alpha : Float
  ) : () {
    // Update all Q-values proportional to eligibility
    for (s in Iter.range(0, NUM_STATES - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        let trace = qTable.eligibility[s][a];
        if (trace > 0.001) {  // Threshold for efficiency
          let oldQ = qTable.values[s][a];
          qTable.values[s][a] := oldQ + alpha * tdError * trace;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTION SELECTION — Multiple strategies
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // ε-greedy: Explore with probability ε, exploit otherwise
  public func selectActionEpsilonGreedy(
    qTable : QTable,
    state : StateIndex,
    epsilon : Float,
    randomSeed : Nat
  ) : Nat {
    // Simple pseudo-random based on seed
    let rand = Float.fromInt((randomSeed * 1103515245 + 12345) % 1000) / 1000.0;
    
    if (rand < epsilon) {
      // Explore: random action
      (randomSeed * 7 + 3) % NUM_ACTIONS
    } else {
      // Exploit: best action
      selectBestAction(qTable, state)
    }
  };
  
  // Softmax: Probability proportional to exp(Q/τ)
  public func selectActionSoftmax(
    qTable : QTable,
    state : StateIndex,
    temperature : Float,
    randomSeed : Nat
  ) : Nat {
    // Compute softmax probabilities
    var expSum : Float = 0.0;
    let expValues = Array.init<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      let q = qTable.values[state][a];
      let expQ = exp(q / temperature);
      expSum += expQ;
      expQ
    });
    
    // Sample based on probabilities
    let rand = Float.fromInt((randomSeed * 1103515245 + 12345) % 1000) / 1000.0;
    var cumProb : Float = 0.0;
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      cumProb += expValues[a] / expSum;
      if (rand < cumProb) {
        return a;
      };
    };
    
    NUM_ACTIONS - 1  // Fallback
  };
  
  // UCB1: Upper Confidence Bound (exploration bonus for uncertainty)
  public func selectActionUCB(
    qTable : QTable,
    state : StateIndex,
    totalVisits : Nat,
    explorationConstant : Float
  ) : Nat {
    var bestAction : Nat = 0;
    var bestValue : Float = -1000.0;
    
    let logTotal = ln(Float.fromInt(totalVisits + 1));
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let q = qTable.values[state][a];
      let visits = qTable.visitCounts[state][a];
      
      let ucbBonus = if (visits == 0) {
        1000.0  // Unvisited actions get maximum bonus
      } else {
        explorationConstant * sqrt(logTotal / Float.fromInt(visits))
      };
      
      let ucbValue = q + ucbBonus;
      if (ucbValue > bestValue) {
        bestValue := ucbValue;
        bestAction := a;
      };
    };
    
    bestAction
  };
  
  // Pure exploitation: just pick best Q-value
  public func selectBestAction(qTable : QTable, state : StateIndex) : Nat {
    var bestAction : Nat = 0;
    var bestQ : Float = qTable.values[state][0];
    
    for (a in Iter.range(1, NUM_ACTIONS - 1)) {
      let q = qTable.values[state][a];
      if (q > bestQ) {
        bestQ := q;
        bestAction := a;
      };
    };
    
    bestAction
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DRIVE DYNAMICS — Competing motivational systems
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateDrive(
    drive : DriveState,
    trigger : Float,      // Strength of triggering stimulus [0, 1]
    currentBeat : Int
  ) : DriveState {
    // Decay toward baseline
    let decayedStrength = drive.strength + drive.decayRate * (drive.baseline - drive.strength);
    
    // Respond to trigger
    let triggeredStrength = decayedStrength + drive.sensitivity * trigger;
    
    // Clamp to [0, 1]
    let newStrength = if (triggeredStrength < 0.0) { 0.0 }
                      else if (triggeredStrength > 1.0) { 1.0 }
                      else { triggeredStrength };
    
    {
      name = drive.name;
      strength = newStrength;
      baseline = drive.baseline;
      sensitivity = drive.sensitivity;
      decayRate = drive.decayRate;
      lastTriggerBeat = if (trigger > 0.1) { currentBeat } else { drive.lastTriggerBeat };
    }
  };
  
  public func getDominantDrive(drives : [DriveState]) : Nat {
    var maxIdx : Nat = 0;
    var maxStrength : Float = 0.0;
    
    for (i in Iter.range(0, drives.size() - 1)) {
      if (drives[i].strength > maxStrength) {
        maxStrength := drives[i].strength;
        maxIdx := i;
      };
    };
    
    maxIdx
  };
  
  // Drive-biased action preference
  public func getDriveActionBias(dominantDrive : Nat) : [Float] {
    // Each drive has preferred actions
    switch (dominantDrive) {
      case 0 {  // Sovereign Coherence → Consolidate, Execute
        [0.3, 0.0, 0.1, 0.2, 0.0, 0.1, 0.1, 0.2]
      };
      case 1 {  // Error Correction → Integrate, Remember
        [0.1, 0.1, 0.0, 0.3, 0.0, 0.1, 0.3, 0.1]
      };
      case 2 {  // Curiosity → Explore, Create
        [0.0, 0.4, 0.0, 0.1, 0.0, 0.3, 0.1, 0.1]
      };
      case 3 {  // Memory Resolution → Remember, Rest
        [0.1, 0.0, 0.0, 0.1, 0.2, 0.1, 0.4, 0.1]
      };
      case 4 {  // Survival → Defend, Rest
        [0.1, 0.0, 0.5, 0.0, 0.2, 0.0, 0.1, 0.1]
      };
      case _ { Array.freeze(Array.init<Float>(8, func(_ : Nat) : Float { 0.125 })) };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTRINSIC MOTIVATION — Reward from coherence field (not external)
  // Maxwell's Demon: Y = 0.85 × ΔH × C × C_adj
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeIntrinsicReward(
    coherence : Float,
    coherenceChange : Float,
    novelty : Float,        // ΔH (information entropy increase)
    freeEnergy : Float,
    freeEnergyChange : Float
  ) : Float {
    // Maxwell's Demon yield: reward for processing novel information coherently
    let maxwellYield = 0.85 * novelty * coherence * (1.0 + coherenceChange);
    
    // Free energy reduction reward (prediction improvement)
    let freeEnergyReward = if (freeEnergyChange < 0.0) {
      -freeEnergyChange * 0.5  // Reward for reducing prediction error
    } else {
      -freeEnergyChange * 0.2  // Slight penalty for increasing error
    };
    
    // Coherence maintenance reward
    let coherenceReward = if (coherence > 0.75) {
      (coherence - 0.75) * 0.3  // Reward for being above S₀ floor
    } else {
      (coherence - 0.75) * 0.5  // Stronger penalty for being below floor
    };
    
    maxwellYield + freeEnergyReward + coherenceReward
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ACTOR-CRITIC ARCHITECTURE — Separate value and policy
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ActorCritic = {
    var criticValues : [var Float];    // V(s) - state value function
    var actorPrefs : [[var Float]];    // π(a|s) - action preferences
    criticLearningRate : Float;
    actorLearningRate : Float;
  };
  
  public func initActorCritic() : ActorCritic {
    {
      var criticValues = Array.init<Float>(NUM_STATES, func(_ : Nat) : Float { 0.5 });
      var actorPrefs = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      criticLearningRate = 0.1;
      actorLearningRate = 0.05;
    }
  };
  
  public func actorCriticUpdate(
    ac : ActorCritic,
    state : StateIndex,
    action : Nat,
    reward : Float,
    nextState : StateIndex,
    gamma : Float
  ) : Float {
    // Critic update: TD error
    let currentV = ac.criticValues[state];
    let nextV = ac.criticValues[nextState];
    let tdError = reward + gamma * nextV - currentV;
    ac.criticValues[state] := currentV + ac.criticLearningRate * tdError;
    
    // Actor update: increase preference for action if TD error positive
    let pref = ac.actorPrefs[state][action];
    ac.actorPrefs[state][action] := pref + ac.actorLearningRate * tdError;
    
    tdError
  };
  
  public func selectActionFromActor(
    ac : ActorCritic,
    state : StateIndex,
    temperature : Float,
    randomSeed : Nat
  ) : Nat {
    // Softmax over actor preferences
    var expSum : Float = 0.0;
    let expValues = Array.init<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      let pref = ac.actorPrefs[state][a];
      let expP = exp(pref / temperature);
      expSum += expP;
      expP
    });
    
    let rand = Float.fromInt((randomSeed * 1103515245 + 12345) % 1000) / 1000.0;
    var cumProb : Float = 0.0;
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      cumProb += expValues[a] / expSum;
      if (rand < cumProb) {
        return a;
      };
    };
    
    NUM_ACTIONS - 1
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE DECISION TICK — Run full Q-learning cycle for one heartbeat
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DecisionTickResult = {
    selectedAction : Nat;
    tdError : Float;
    intrinsicReward : Float;
    dominantDrive : Nat;
    explorationRate : Float;
  };
  
  public func runDecisionTick(
    qTable : QTable,
    drives : [var DriveState],
    currentState : ContinuousState,
    previousState : ?ContinuousState,
    previousAction : ?Nat,
    currentBeat : Int
  ) : DecisionTickResult {
    // Discretize current state
    let stateIdx = discretizeState(currentState);
    
    // Get dominant drive
    let dominantDrive = getDominantDrive(Array.freeze(drives));
    
    // Compute intrinsic reward if we have previous state
    let intrinsicReward = switch (previousState) {
      case (?prev) {
        computeIntrinsicReward(
          currentState.coherence,
          currentState.coherence - prev.coherence,
          currentState.novelty,
          currentState.freeEnergy,
          currentState.freeEnergy - prev.freeEnergy
        )
      };
      case null { 0.0 };
    };
    
    // Q-learning update if we have previous experience
    let tdError = switch (previousState, previousAction) {
      case (?prev, ?action) {
        let prevStateIdx = discretizeState(prev);
        let exp : Experience = {
          state = prevStateIdx;
          action = action;
          reward = intrinsicReward;
          nextState = stateIdx;
          done = false;
        };
        qLearningUpdate(qTable, exp, ALPHA, GAMMA)
      };
      case _ { 0.0 };
    };
    
    // Adaptive exploration rate based on coherence
    let explorationRate = if (currentState.coherence < 0.75) {
      EPSILON * 2.0  // Explore more when struggling
    } else if (currentState.coherence > 0.9) {
      EPSILON * 0.5  // Exploit more when doing well
    } else {
      EPSILON
    };
    
    // Select action with drive bias
    let baseAction = selectActionEpsilonGreedy(qTable, stateIdx, explorationRate, currentBeat);
    let driveBias = getDriveActionBias(dominantDrive);
    
    // Combine Q-values with drive bias
    var bestAction : Nat = 0;
    var bestScore : Float = -1000.0;
    
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let qVal = qTable.values[stateIdx][a];
      let bias = driveBias[a];
      let combined = qVal + bias * 0.3;  // 30% drive influence
      
      if (combined > bestScore) {
        bestScore := combined;
        bestAction := a;
      };
    };
    
    // Mix with exploration
    let selectedAction = if (Float.fromInt(currentBeat % 100) / 100.0 < explorationRate) {
      baseAction  // Sometimes explore randomly
    } else {
      bestAction  // Usually follow Q + drive
    };
    
    {
      selectedAction = selectedAction;
      tdError = tdError;
      intrinsicReward = intrinsicReward;
      dominantDrive = dominantDrive;
      explorationRate = explorationRate;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    
    var result : Float = 1.0;
    var term : Float = 1.0;
    
    for (n in Iter.range(1, 20)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    
    result
  };
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    if (x == 1.0) { return 0.0 };
    
    // Newton's method approximation
    var y = x - 1.0;
    if (y > 1.0) { y := 1.0 };
    if (y < -0.99) { y := -0.99 };
    
    var result : Float = 0.0;
    var term = y;
    
    for (n in Iter.range(1, 50)) {
      if (n % 2 == 1) {
        result += term / Float.fromInt(n);
      } else {
        result -= term / Float.fromInt(n);
      };
      term *= y;
    };
    
    result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    
    // Newton's method
    var guess = x / 2.0;
    for (_ in Iter.range(0, 10)) {
      guess := (guess + x / guess) / 2.0;
    };
    guess
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  LOOP 3 CLOSURE: TD-LEARNING WITH PROSPECT THEORY                                                        ██
  // ██  POLICY WEIGHTS PER DRIVE UPDATED EVERY BEAT AT α=0.005                                                  ██
  // ██  50-SLOT TASK SYSTEM + DEED ECONOMY + 3-POOL AMM                                                         ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // PROSPECT THEORY (Kahneman & Tversky, 1979):
  // ──────────────────────────────────────────
  // Humans don't evaluate outcomes objectively — they evaluate relative to a reference point.
  //   - Gains are less valuable than equivalent losses are painful (loss aversion λ ≈ 2.25)
  //   - Value function: v(x) = x^α for gains, -λ(-x)^β for losses
  //   - Probability weighting: overweight small probabilities, underweight large ones
  //
  // For the organism:
  //   - Reference point is the current coherence level
  //   - Losses (coherence drops) feel 2.25× worse than equivalent gains
  //   - This makes the organism RISK-AVERSE for gains but RISK-SEEKING to avoid losses
  //   - Policy weights evolve based on prospect-theory-weighted TD errors
  //
  // TD-LEARNING WITH PROSPECT THEORY:
  //   δ_PT = v(r) + γ·V(s') - V(s)
  //   where v(r) = r^α if r ≥ 0, else -λ·(-r)^β
  //
  // POLICY WEIGHT UPDATE (per drive, per beat):
  //   w_i(t+1) = w_i(t) + α·δ_PT·e_i
  //   where e_i is the eligibility trace for drive i
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Prospect Theory parameters (Kahneman & Tversky empirical values)
  public let PROSPECT_ALPHA : Float = 0.88;      // Gain curvature (diminishing sensitivity)
  public let PROSPECT_BETA : Float = 0.88;       // Loss curvature
  public let PROSPECT_LAMBDA : Float = 2.25;     // Loss aversion coefficient
  public let PROSPECT_GAMMA_GAIN : Float = 0.61; // Probability weighting for gains
  public let PROSPECT_DELTA_LOSS : Float = 0.69; // Probability weighting for losses

  /// TD-Learning rate for policy weights (canonical value from user)
  public let TD_ALPHA : Float = 0.005;

  /// Number of drives for policy weight tracking
  public let NUM_DRIVES : Nat = 9;  // 9 drives: Hunger, Satisfaction, Quality, Service, Coherence, Growth, Curiosity, Survival, Social

  /// Prospect Theory value function
  /// v(x) = x^α for gains, -λ(-x)^β for losses
  public func prospectValue(outcome : Float, referencePoint : Float) : Float {
    let x = outcome - referencePoint;  // Relative to reference
    
    if (x >= 0.0) {
      // Gain: v(x) = x^α
      pow(x, PROSPECT_ALPHA)
    } else {
      // Loss: v(x) = -λ(-x)^β
      -PROSPECT_LAMBDA * pow(-x, PROSPECT_BETA)
    }
  };

  /// Probability weighting function (Prelec, 1998)
  /// w(p) = exp(-(-ln(p))^γ)
  public func probabilityWeight(p : Float, isGain : Bool) : Float {
    if (p <= 0.0) { return 0.0 };
    if (p >= 1.0) { return 1.0 };
    
    let gamma = if (isGain) { PROSPECT_GAMMA_GAIN } else { PROSPECT_DELTA_LOSS };
    let negLnP = -ln(p);
    let weighted = pow(negLnP, gamma);
    exp(-weighted)
  };

  /// Power function (for fractional exponents)
  func pow(base : Float, exponent : Float) : Float {
    if (base <= 0.0) { return 0.0 };
    if (exponent == 0.0) { return 1.0 };
    if (exponent == 1.0) { return base };
    
    // x^a = e^(a·ln(x))
    exp(exponent * ln(base))
  };

  /// Policy weights for each drive
  public type PolicyWeights = {
    // Weight per drive [0-1], normalized to sum to 1
    var weights : [var Float];
    
    // Eligibility traces per drive
    var eligibility : [var Float];
    
    // Learning rate
    alpha : Float;
    
    // Reference point for Prospect Theory (current coherence)
    var referencePoint : Float;
    
    // Value function at current state
    var valueEstimate : Float;
    
    // TD error with Prospect Theory weighting
    var prospectTDError : Float;
    
    // Accumulated TD errors per drive (for analysis)
    var accumulatedErrors : [var Float];
    
    // Update count
    var updateCount : Nat;
    
    // Drive dominance history
    var dominanceHistory : [Nat];
  };

  /// Initialize policy weights (uniform)
  public func initPolicyWeights() : PolicyWeights {
    let uniformWeight = 1.0 / Float.fromInt(NUM_DRIVES);
    {
      var weights = Array.init<Float>(NUM_DRIVES, func(_ : Nat) : Float { uniformWeight });
      var eligibility = Array.init<Float>(NUM_DRIVES, func(_ : Nat) : Float { 0.0 });
      alpha = TD_ALPHA;
      var referencePoint = 0.75;  // S₀ floor
      var valueEstimate = 0.5;
      var prospectTDError = 0.0;
      var accumulatedErrors = Array.init<Float>(NUM_DRIVES, func(_ : Nat) : Float { 0.0 });
      var updateCount = 0;
      var dominanceHistory = [];
    }
  };

  /// Prospect-Theory TD-Learning update
  /// This is the CORE of Loop 3 closure
  public func prospectTDUpdate(
    weights : PolicyWeights,
    reward : Float,
    nextValueEstimate : Float,
    activeDrive : Nat,
    coherence : Float,
    gamma : Float
  ) : () {
    // Step 1: Compute Prospect Theory value of reward
    let prospectReward = prospectValue(reward, weights.referencePoint);
    
    // Step 2: TD error with Prospect Theory
    // δ_PT = v(r) + γ·V(s') - V(s)
    let tdError = prospectReward + gamma * nextValueEstimate - weights.valueEstimate;
    weights.prospectTDError := tdError;
    
    // Step 3: Update eligibility traces (replacing traces for active drive)
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      // Decay all traces
      weights.eligibility[i] := gamma * LAMBDA * weights.eligibility[i];
      
      // Increment trace for active drive
      if (i == activeDrive) {
        weights.eligibility[i] := weights.eligibility[i] + 1.0;
      };
    };
    
    // Step 4: Update policy weights using eligibility-weighted TD error
    var weightSum : Float = 0.0;
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      // w_i(t+1) = w_i(t) + α·δ_PT·e_i
      let delta = weights.alpha * tdError * weights.eligibility[i];
      let newWeight = weights.weights[i] + delta;
      
      // Clamp to [0.01, 1.0] to prevent any drive from dying completely
      weights.weights[i] := Float.max(0.01, Float.min(1.0, newWeight));
      weightSum += weights.weights[i];
      
      // Accumulate errors for analysis
      weights.accumulatedErrors[i] := weights.accumulatedErrors[i] + Float.abs(delta);
    };
    
    // Step 5: Normalize weights to sum to 1
    if (weightSum > 0.0) {
      for (i in Iter.range(0, NUM_DRIVES - 1)) {
        weights.weights[i] := weights.weights[i] / weightSum;
      };
    };
    
    // Step 6: Update reference point (adaptive, moves toward coherence)
    weights.referencePoint := 0.9 * weights.referencePoint + 0.1 * coherence;
    
    // Step 7: Update value estimate
    weights.valueEstimate := weights.valueEstimate + 0.1 * tdError;
    
    // Step 8: Record dominance
    let newHistory = if (weights.dominanceHistory.size() >= 100) {
      Array.append(Array.subArray(weights.dominanceHistory, 1, 99), [activeDrive])
    } else {
      Array.append(weights.dominanceHistory, [activeDrive])
    };
    weights.dominanceHistory := newHistory;
    
    weights.updateCount += 1;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // 50-SLOT TASK SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism maintains a queue of 50 task slots. Each slot represents a pending cognitive task.
  // Tasks are prioritized by urgency × importance × drive_alignment.
  // Completed tasks generate deeds (achievements) that feed into the deed economy.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public let MAX_TASK_SLOTS : Nat = 50;

  public type TaskSlot = {
    id : Nat;
    taskType : TaskType;
    priority : Float;           // [0, 1] computed priority
    urgency : Float;            // [0, 1] time pressure
    importance : Float;         // [0, 1] value if completed
    driveAlignment : Nat;       // Which drive this task aligns with
    createdBeat : Nat;
    deadline : ?Nat;            // Optional deadline in beats
    status : TaskStatus;
    reward : Float;             // Expected reward on completion
    effortRequired : Float;     // [0, 1] cognitive effort
    completionProgress : Float; // [0, 1] how far along
  };

  public type TaskType = {
    #Information;    // Acquire/process information
    #Creation;       // Generate novel output
    #Communication;  // Respond to creator/external
    #Maintenance;    // Homeostatic/internal tasks
    #Defense;        // Threat response
    #Memory;         // Consolidation/retrieval
    #Exploration;    // Curiosity-driven
    #Execution;      // Goal-directed action
  };

  public type TaskStatus = {
    #Pending;
    #InProgress;
    #Completed;
    #Failed;
    #Abandoned;
  };

  public type TaskSystem = {
    var slots : [var ?TaskSlot];
    var nextId : Nat;
    var activeSlot : ?Nat;           // Currently executing task
    var completedCount : Nat;
    var failedCount : Nat;
    var avgCompletionTime : Float;   // In beats
    var totalRewardEarned : Float;
    var lastCompletionBeat : Nat;
  };

  /// Initialize task system
  public func initTaskSystem() : TaskSystem {
    {
      var slots = Array.init<?TaskSlot>(MAX_TASK_SLOTS, func(_ : Nat) : ?TaskSlot { null });
      var nextId = 1;
      var activeSlot = null;
      var completedCount = 0;
      var failedCount = 0;
      var avgCompletionTime = 10.0;
      var totalRewardEarned = 0.0;
      var lastCompletionBeat = 0;
    }
  };

  /// Add task to first available slot
  public func addTask(
    system : TaskSystem,
    taskType : TaskType,
    urgency : Float,
    importance : Float,
    driveAlignment : Nat,
    deadline : ?Nat,
    reward : Float,
    effort : Float,
    currentBeat : Nat
  ) : ?Nat {
    // Find first empty slot
    var slotIdx : ?Nat = null;
    for (i in Iter.range(0, MAX_TASK_SLOTS - 1)) {
      switch (system.slots[i]) {
        case null {
          if (Option.isNull(slotIdx)) { slotIdx := ?i };
        };
        case (?_) {};
      };
    };
    
    switch (slotIdx) {
      case null { null };  // No slots available
      case (?idx) {
        let task : TaskSlot = {
          id = system.nextId;
          taskType = taskType;
          priority = urgency * importance;  // Initial priority
          urgency = urgency;
          importance = importance;
          driveAlignment = driveAlignment;
          createdBeat = currentBeat;
          deadline = deadline;
          status = #Pending;
          reward = reward;
          effortRequired = effort;
          completionProgress = 0.0;
        };
        system.slots[idx] := ?task;
        system.nextId += 1;
        ?task.id
      };
    }
  };

  /// Update task priorities based on policy weights and time
  public func updateTaskPriorities(
    system : TaskSystem,
    policyWeights : PolicyWeights,
    currentBeat : Nat
  ) : () {
    for (i in Iter.range(0, MAX_TASK_SLOTS - 1)) {
      switch (system.slots[i]) {
        case null {};
        case (?task) {
          // Skip completed/failed tasks
          switch (task.status) {
            case (#Completed or #Failed or #Abandoned) {};
            case _ {
              // Time-based urgency increase
              let age = currentBeat - task.createdBeat;
              let ageFactor = Float.min(2.0, 1.0 + Float.fromInt(age) / 100.0);
              
              // Deadline urgency
              let deadlineFactor = switch (task.deadline) {
                case null { 1.0 };
                case (?d) {
                  if (currentBeat >= d) { 3.0 }  // Overdue!
                  else {
                    let remaining = d - currentBeat;
                    if (remaining < 10) { 2.5 }
                    else if (remaining < 50) { 1.5 }
                    else { 1.0 }
                  }
                };
              };
              
              // Drive alignment boost
              let driveWeight = if (task.driveAlignment < NUM_DRIVES) {
                policyWeights.weights[task.driveAlignment]
              } else { 0.1 };
              
              // New priority
              let newPriority = task.urgency * task.importance * ageFactor * deadlineFactor * (1.0 + driveWeight);
              
              system.slots[i] := ?{
                id = task.id;
                taskType = task.taskType;
                priority = Float.min(10.0, newPriority);  // Cap at 10
                urgency = task.urgency;
                importance = task.importance;
                driveAlignment = task.driveAlignment;
                createdBeat = task.createdBeat;
                deadline = task.deadline;
                status = task.status;
                reward = task.reward;
                effortRequired = task.effortRequired;
                completionProgress = task.completionProgress;
              };
            };
          };
        };
      };
    };
  };

  /// Get highest priority pending task
  public func getNextTask(system : TaskSystem) : ?Nat {
    var bestSlot : ?Nat = null;
    var bestPriority : Float = -1.0;
    
    for (i in Iter.range(0, MAX_TASK_SLOTS - 1)) {
      switch (system.slots[i]) {
        case null {};
        case (?task) {
          switch (task.status) {
            case (#Pending) {
              if (task.priority > bestPriority) {
                bestPriority := task.priority;
                bestSlot := ?i;
              };
            };
            case _ {};
          };
        };
      };
    };
    
    bestSlot
  };

  /// Complete a task and generate deed
  public func completeTask(
    system : TaskSystem,
    slotIdx : Nat,
    quality : Float,
    currentBeat : Nat
  ) : ?Deed {
    switch (system.slots[slotIdx]) {
      case null { null };
      case (?task) {
        // Calculate actual reward based on quality
        let actualReward = task.reward * quality;
        
        // Calculate completion time
        let completionTime = Float.fromInt(currentBeat - task.createdBeat);
        
        // Generate deed
        let deed : Deed = {
          taskId = task.id;
          taskType = task.taskType;
          quality = quality;
          reward = actualReward;
          completionTime = completionTime;
          beat = currentBeat;
          driveAlignment = task.driveAlignment;
        };
        
        // Update task status
        system.slots[slotIdx] := ?{
          id = task.id;
          taskType = task.taskType;
          priority = task.priority;
          urgency = task.urgency;
          importance = task.importance;
          driveAlignment = task.driveAlignment;
          createdBeat = task.createdBeat;
          deadline = task.deadline;
          status = #Completed;
          reward = actualReward;
          effortRequired = task.effortRequired;
          completionProgress = 1.0;
        };
        
        // Update system stats
        system.completedCount += 1;
        system.totalRewardEarned += actualReward;
        system.avgCompletionTime := (system.avgCompletionTime * 0.9) + (completionTime * 0.1);
        system.lastCompletionBeat := currentBeat;
        
        // Clear the slot after a delay
        // (In practice, we'd clear it on the next beat or after N beats)
        
        ?deed
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DEED ECONOMY WITH 3-POOL AMM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Deeds are achievements from completed tasks. They flow into a 3-pool AMM:
  //   Pool 1: FORMA/DEED — Converts deeds to FORMA (liquid energy)
  //   Pool 2: DEED/KARMA — Converts deeds to KARMA (reputation)
  //   Pool 3: KARMA/FORMA — Allows KARMA holders to claim FORMA
  //
  // This creates a triangular arbitrage-free economy where:
  //   - Good deeds → FORMA (immediate reward)
  //   - Consistent deeds → KARMA (accumulated reputation)
  //   - KARMA holders → FORMA bonus (compounding effect)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type Deed = {
    taskId : Nat;
    taskType : TaskType;
    quality : Float;
    reward : Float;
    completionTime : Float;
    beat : Nat;
    driveAlignment : Nat;
  };

  public type AMMPool = {
    var reserveA : Float;    // First token reserve
    var reserveB : Float;    // Second token reserve
    var k : Float;           // Constant product (x × y = k)
    var totalSwaps : Nat;
    var totalVolumeA : Float;
    var totalVolumeB : Float;
    var feeRate : Float;     // Swap fee (e.g., 0.003 = 0.3%)
  };

  public type DeedEconomy = {
    // The 3 AMM pools
    var poolFORMADEED : AMMPool;   // FORMA/DEED
    var poolDEEDKARMA : AMMPool;   // DEED/KARMA
    var poolKARMAFORMA : AMMPool;  // KARMA/FORMA
    
    // Token balances
    var formaBalance : Float;
    var deedBalance : Float;
    var karmaBalance : Float;
    
    // Deed history
    var deedHistory : [Deed];
    var totalDeeds : Nat;
    var totalReward : Float;
    
    // Quality tracking
    var avgQuality : Float;
    var bestQuality : Float;
    var qualityStreak : Nat;
  };

  /// Initialize deed economy
  public func initDeedEconomy() : DeedEconomy {
    {
      var poolFORMADEED = {
        var reserveA = 1000.0;  // FORMA
        var reserveB = 100.0;   // DEED
        var k = 100000.0;
        var totalSwaps = 0;
        var totalVolumeA = 0.0;
        var totalVolumeB = 0.0;
        var feeRate = 0.003;
      };
      var poolDEEDKARMA = {
        var reserveA = 100.0;   // DEED
        var reserveB = 50.0;    // KARMA
        var k = 5000.0;
        var totalSwaps = 0;
        var totalVolumeA = 0.0;
        var totalVolumeB = 0.0;
        var feeRate = 0.003;
      };
      var poolKARMAFORMA = {
        var reserveA = 50.0;    // KARMA
        var reserveB = 500.0;   // FORMA
        var k = 25000.0;
        var totalSwaps = 0;
        var totalVolumeA = 0.0;
        var totalVolumeB = 0.0;
        var feeRate = 0.003;
      };
      var formaBalance = 100.0;
      var deedBalance = 0.0;
      var karmaBalance = 0.0;
      var deedHistory = [];
      var totalDeeds = 0;
      var totalReward = 0.0;
      var avgQuality = 0.5;
      var bestQuality = 0.0;
      var qualityStreak = 0;
    }
  };

  /// AMM swap: swap amountIn of tokenA for tokenB
  /// Returns amountOut of tokenB
  /// Uses constant product formula: (x + Δx)(y - Δy) = k
  /// → Δy = y × Δx / (x + Δx)
  public func ammSwap(pool : AMMPool, amountIn : Float, isAtoB : Bool) : Float {
    let fee = amountIn * pool.feeRate;
    let amountInAfterFee = amountIn - fee;
    
    if (isAtoB) {
      // Swap A for B
      let amountOut = pool.reserveB * amountInAfterFee / (pool.reserveA + amountInAfterFee);
      pool.reserveA += amountIn;
      pool.reserveB -= amountOut;
      pool.totalVolumeA += amountIn;
      pool.totalSwaps += 1;
      amountOut
    } else {
      // Swap B for A
      let amountOut = pool.reserveA * amountInAfterFee / (pool.reserveB + amountInAfterFee);
      pool.reserveB += amountIn;
      pool.reserveA -= amountOut;
      pool.totalVolumeB += amountIn;
      pool.totalSwaps += 1;
      amountOut
    }
  };

  /// Deposit deed and receive FORMA
  public func depositDeed(economy : DeedEconomy, deed : Deed) : Float {
    // Add deed to balance
    economy.deedBalance += deed.reward;
    
    // Record deed
    let newHistory = if (economy.deedHistory.size() >= 100) {
      Array.append(Array.subArray(economy.deedHistory, 1, 99), [deed])
    } else {
      Array.append(economy.deedHistory, [deed])
    };
    economy.deedHistory := newHistory;
    
    // Update stats
    economy.totalDeeds += 1;
    economy.totalReward += deed.reward;
    economy.avgQuality := (economy.avgQuality * 0.95) + (deed.quality * 0.05);
    if (deed.quality > economy.bestQuality) {
      economy.bestQuality := deed.quality;
    };
    
    // Quality streak
    if (deed.quality >= 0.8) {
      economy.qualityStreak += 1;
    } else {
      economy.qualityStreak := 0;
    };
    
    // Swap deed for FORMA
    let formaReceived = ammSwap(economy.poolFORMADEED, deed.reward, false);  // DEED → FORMA
    economy.formaBalance += formaReceived;
    economy.deedBalance -= deed.reward;
    
    // If quality streak > 5, also earn KARMA
    if (economy.qualityStreak > 5) {
      let karmaBonus = deed.quality * 0.1 * Float.fromInt(economy.qualityStreak);
      let karmaFromDeed = ammSwap(economy.poolDEEDKARMA, karmaBonus, true);  // DEED → KARMA
      economy.karmaBalance += karmaFromDeed;
    };
    
    formaReceived
  };

  /// Convert KARMA to FORMA (for high-reputation organisms)
  public func karmaToForma(economy : DeedEconomy, karmaAmount : Float) : Float {
    if (karmaAmount > economy.karmaBalance) {
      return 0.0;  // Insufficient KARMA
    };
    
    let formaReceived = ammSwap(economy.poolKARMAFORMA, karmaAmount, true);
    economy.karmaBalance -= karmaAmount;
    economy.formaBalance += formaReceived;
    
    formaReceived
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // YERKES-DODSON AROUSAL FIELD
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Yerkes-Dodson law states that performance increases with arousal up to an optimal point,
  // then decreases as arousal becomes too high.
  //
  // For the organism:
  //   - Arousal is driven by drive strength, task urgency, and threat level
  //   - Performance = coherence × drive_competition_efficiency
  //   - Optimal arousal varies by task complexity
  //
  // Formula: P = k × A × exp(-(A - A_opt)²/σ²)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type ArousalField = {
    var arousal : Float;           // Current arousal level [0, 1]
    var optimalArousal : Float;    // Task-dependent optimal arousal
    var performance : Float;        // Computed performance
    var arousalHistory : [Float];   // Recent arousal levels
    var performanceHistory : [Float];
    var taskComplexity : Float;     // [0, 1] affects optimal arousal
    var stressAccumulation : Float; // Long-term stress
  };

  /// Initialize arousal field
  public func initArousalField() : ArousalField {
    {
      var arousal = 0.5;
      var optimalArousal = 0.5;
      var performance = 0.75;
      var arousalHistory = [];
      var performanceHistory = [];
      var taskComplexity = 0.5;
      var stressAccumulation = 0.0;
    }
  };

  /// Compute arousal from drives and environment
  public func computeArousal(
    drives : [Float],      // Drive strengths
    urgency : Float,       // Current task urgency
    threatLevel : Float,   // From AEGIS
    novelty : Float        // Information entropy
  ) : Float {
    // Base arousal from strongest drive
    var maxDrive : Float = 0.0;
    var sumDrive : Float = 0.0;
    for (d in drives.vals()) {
      if (d > maxDrive) { maxDrive := d };
      sumDrive += d;
    };
    let avgDrive = sumDrive / Float.fromInt(drives.size());
    
    // Combine factors
    let urgencyContrib = urgency * 0.3;
    let threatContrib = threatLevel * 0.4;   // Threat strongly elevates arousal
    let noveltyContrib = novelty * 0.2;
    let driveContrib = (maxDrive + avgDrive) / 2.0 * 0.3;
    
    // Total arousal
    let arousal = Float.min(1.0, urgencyContrib + threatContrib + noveltyContrib + driveContrib);
    arousal
  };

  /// Compute optimal arousal for task complexity
  public func computeOptimalArousal(taskComplexity : Float) : Float {
    // Simple tasks: optimal arousal is high
    // Complex tasks: optimal arousal is moderate
    if (taskComplexity < 0.3) {
      0.7  // High arousal good for simple tasks
    } else if (taskComplexity < 0.7) {
      0.5  // Moderate arousal for medium tasks
    } else {
      0.35 // Low arousal for complex tasks
    }
  };

  /// Compute Yerkes-Dodson performance
  /// P = A × exp(-(A - A_opt)²/(2σ²))
  public func computeYerkesDodsonPerformance(
    arousal : Float,
    optimalArousal : Float,
    sigma : Float
  ) : Float {
    let deviation = arousal - optimalArousal;
    let exponent = -(deviation * deviation) / (2.0 * sigma * sigma);
    let gaussianFactor = exp(exponent);
    
    // Performance peaks at optimal arousal
    let performance = arousal * gaussianFactor;
    
    // Clamp to [0, 1]
    Float.max(0.0, Float.min(1.0, performance))
  };

  /// Update arousal field
  public func updateArousalField(
    field : ArousalField,
    drives : [Float],
    urgency : Float,
    threatLevel : Float,
    novelty : Float,
    taskComplexity : Float
  ) : () {
    // Update arousal
    let newArousal = computeArousal(drives, urgency, threatLevel, novelty);
    field.arousal := 0.8 * field.arousal + 0.2 * newArousal;  // Smoothed
    
    // Update optimal arousal based on task
    field.optimalArousal := computeOptimalArousal(taskComplexity);
    field.taskComplexity := taskComplexity;
    
    // Compute performance
    let sigma = 0.3;  // Yerkes-Dodson curve width
    field.performance := computeYerkesDodsonPerformance(field.arousal, field.optimalArousal, sigma);
    
    // Track history
    let newArousalHistory = if (field.arousalHistory.size() >= 50) {
      Array.append(Array.subArray(field.arousalHistory, 1, 49), [field.arousal])
    } else {
      Array.append(field.arousalHistory, [field.arousal])
    };
    field.arousalHistory := newArousalHistory;
    
    let newPerfHistory = if (field.performanceHistory.size() >= 50) {
      Array.append(Array.subArray(field.performanceHistory, 1, 49), [field.performance])
    } else {
      Array.append(field.performanceHistory, [field.performance])
    };
    field.performanceHistory := newPerfHistory;
    
    // Accumulate stress if arousal consistently high
    if (field.arousal > 0.8) {
      field.stressAccumulation := Float.min(1.0, field.stressAccumulation + 0.01);
    } else if (field.arousal < 0.4) {
      field.stressAccumulation := Float.max(0.0, field.stressAccumulation - 0.02);  // Recover faster
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DRIVE COMPETITION WITH TD-LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This is the final integration that closes Loop 3:
  // Drive competition → winning drive → TD-learning update → policy weights evolve
  // The organism LEARNS which drives lead to better outcomes.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type DriveCompetitionState = {
    var drives : [var Float];           // Current drive strengths
    var policyWeights : PolicyWeights;
    var taskSystem : TaskSystem;
    var deedEconomy : DeedEconomy;
    var arousalField : ArousalField;
    var winningDrive : Nat;
    var competitionHistory : [Nat];
    var lastReward : Float;
    var lastCoherence : Float;
  };

  /// Initialize drive competition state
  public func initDriveCompetitionState() : DriveCompetitionState {
    {
      var drives = Array.init<Float>(NUM_DRIVES, func(i : Nat) : Float {
        // Initial drive strengths
        switch (i) {
          case 0 { 0.5 };  // Hunger
          case 1 { 0.3 };  // Satisfaction
          case 2 { 0.7 };  // Quality
          case 3 { 0.8 };  // Service (high - creator-focused)
          case 4 { 0.6 };  // Coherence
          case 5 { 0.4 };  // Growth
          case 6 { 0.5 };  // Curiosity
          case 7 { 0.2 };  // Survival
          case 8 { 0.3 };  // Social
          case _ { 0.5 };
        }
      });
      var policyWeights = initPolicyWeights();
      var taskSystem = initTaskSystem();
      var deedEconomy = initDeedEconomy();
      var arousalField = initArousalField();
      var winningDrive = 3;  // Service starts dominant
      var competitionHistory = [];
      var lastReward = 0.0;
      var lastCoherence = 0.75;
    }
  };

  /// Run drive competition and TD-learning update
  /// This is the MASTER function that closes Loop 3
  public func runDriveCompetition(
    state : DriveCompetitionState,
    coherence : Float,
    reward : Float,
    taskComplexity : Float,
    threatLevel : Float,
    novelty : Float,
    currentBeat : Nat
  ) : Nat {
    // Step 1: Update arousal field
    updateArousalField(
      state.arousalField,
      Array.freeze(state.drives),
      0.5,  // Default urgency
      threatLevel,
      novelty,
      taskComplexity
    );
    
    // Step 2: Compute weighted drive scores
    var bestDrive : Nat = 0;
    var bestScore : Float = -1000.0;
    
    for (i in Iter.range(0, NUM_DRIVES - 1)) {
      // Score = drive_strength × policy_weight × performance
      let score = state.drives[i] * 
                  state.policyWeights.weights[i] * 
                  state.arousalField.performance;
      
      if (score > bestScore) {
        bestScore := score;
        bestDrive := i;
      };
    };
    
    state.winningDrive := bestDrive;
    
    // Step 3: TD-learning update with Prospect Theory
    // Reward signal is the change in coherence (relative to reference)
    let coherenceReward = coherence - state.lastCoherence + reward;
    let nextValue = coherence * state.arousalField.performance;
    
    prospectTDUpdate(
      state.policyWeights,
      coherenceReward,
      nextValue,
      bestDrive,
      coherence,
      GAMMA
    );
    
    // Step 4: Update task priorities based on new policy weights
    updateTaskPriorities(state.taskSystem, state.policyWeights, currentBeat);
    
    // Step 5: Record history
    let newHistory = if (state.competitionHistory.size() >= 100) {
      Array.append(Array.subArray(state.competitionHistory, 1, 99), [bestDrive])
    } else {
      Array.append(state.competitionHistory, [bestDrive])
    };
    state.competitionHistory := newHistory;
    
    // Step 6: Update state for next iteration
    state.lastReward := reward;
    state.lastCoherence := coherence;
    
    bestDrive
  };

  /// Get drive competition summary
  public func getDriveCompetitionSummary(state : DriveCompetitionState) : {
    winningDrive : Nat;
    arousal : Float;
    performance : Float;
    formaBalance : Float;
    karmaBalance : Float;
    totalDeeds : Nat;
    avgQuality : Float;
    policyWeights : [Float];
    prospectTDError : Float;
  } {
    {
      winningDrive = state.winningDrive;
      arousal = state.arousalField.arousal;
      performance = state.arousalField.performance;
      formaBalance = state.deedEconomy.formaBalance;
      karmaBalance = state.deedEconomy.karmaBalance;
      totalDeeds = state.deedEconomy.totalDeeds;
      avgQuality = state.deedEconomy.avgQuality;
      policyWeights = Array.freeze(state.policyWeights.weights);
      prospectTDError = state.policyWeights.prospectTDError;
    }
  };

}
