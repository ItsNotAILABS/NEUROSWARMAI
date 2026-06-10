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
// DEEP SOCIAL COGNITION — THE MATHEMATICS OF SOCIAL INTELLIGENCE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Social intelligence is not separate from general intelligence — it IS intelligence applied to social domains.
// Humans are ultra-social primates. Our cognition evolved FOR social interaction.
//
// THEORY OF MIND (ToM):
// ═════════════════════
//
// The ability to attribute mental states to others:
//   - Beliefs: What do they think?
//   - Desires: What do they want?
//   - Intentions: What will they do?
//   - Knowledge: What do they know?
//
// Levels:
//   0: No ToM (pure reaction)
//   1: First-order: "I think that X believes..."
//   2: Second-order: "I think that X thinks that Y believes..."
//   3: Third-order: "I think that X thinks that Y thinks..."
//   ...recursive embedding
//
// SOCIAL PERCEPTION:
// ══════════════════
//
// Processing social signals:
//   - Face recognition
//   - Emotion recognition
//   - Gaze direction (joint attention)
//   - Body language
//   - Prosody (voice tone)
//
// SOCIAL LEARNING:
// ════════════════
//
// Learning from others:
//   - Imitation
//   - Emulation (copy goals, not actions)
//   - Instruction following
//   - Demonstration
//   - Cultural transmission
//
// SOCIAL DECISION-MAKING:
// ═══════════════════════
//
// Decisions in social contexts:
//   - Cooperation vs defection
//   - Trust and reputation
//   - Fairness and reciprocity
//   - Group membership
//   - Status and hierarchy
//
// GAME THEORY:
// ════════════
//
// Mathematical framework for strategic interaction:
//   - Nash equilibrium
//   - Pareto optimality
//   - Dominant strategies
//   - Mixed strategies
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

module DeepSocialCognition {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.618033988749894848204586834365638;
  public let MAX_AGENTS : Nat = 16;
  public let MAX_TOM_DEPTH : Nat = 4;
  public let RELATIONSHIP_DIM : Nat = 8;
  public let INTERACTION_HISTORY : Nat = 100;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: THEORY OF MIND — MODELING OTHER MINDS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // To interact socially, we need to MODEL what others are thinking.
  // This is recursive: "I think that you think that I think..."
  //
  
  public type MentalStateModel = {
    var beliefs : [var Float];           // What they believe about the world
    var desires : [var Float];           // What they want
    var intentions : [var Float];        // What they plan to do
    var emotions : [var Float];          // How they feel
    var knowledge : [var Float];         // What they know
    var uncertainty : Float;             // How uncertain we are about this model
  };
  
  public type TheoryOfMindState = {
    // Models of other agents
    var agentModels : [var MentalStateModel];
    var numAgents : Nat;
    
    // Recursive ToM (I think you think I think...)
    var tomDepth : Nat;                  // Current depth of reasoning
    var recursiveModels : [[var MentalStateModel]]; // [agent][depth]
    
    // Self-model (how I think others see me)
    var selfAsOtherSees : [var MentalStateModel]; // Per agent
    
    // Perspective taking
    var currentPerspective : Nat;        // Whose perspective we're taking
    var perspectiveAccuracy : Float;     // How accurate is our perspective-taking
    
    // False belief understanding
    var falseBeliefCapability : Float;   // Ability to understand false beliefs
    var realityBias : Float;             // Tendency to project own beliefs
  };
  
  public let MENTAL_STATE_DIM : Nat = 16;
  
  // Initialize mental state model
  public func initMentalStateModel() : MentalStateModel {
    {
      var beliefs = Array.init<Float>(MENTAL_STATE_DIM, func(_ : Nat) : Float { 0.5 });
      var desires = Array.init<Float>(MENTAL_STATE_DIM, func(_ : Nat) : Float { 0.5 });
      var intentions = Array.init<Float>(MENTAL_STATE_DIM, func(_ : Nat) : Float { 0.0 });
      var emotions = Array.init<Float>(6, func(_ : Nat) : Float { 0.0 });  // 6 basic emotions
      var knowledge = Array.init<Float>(MENTAL_STATE_DIM, func(_ : Nat) : Float { 0.5 });
      var uncertainty = 0.5;
    }
  };
  
  // Initialize Theory of Mind
  public func initTheoryOfMind() : TheoryOfMindState {
    let agentModels = Array.init<MentalStateModel>(MAX_AGENTS, func(_ : Nat) : MentalStateModel {
      initMentalStateModel()
    });
    
    let recursiveModels = Array.init<[var MentalStateModel]>(MAX_AGENTS, func(_ : Nat) : [var MentalStateModel] {
      Array.init<MentalStateModel>(MAX_TOM_DEPTH, func(_ : Nat) : MentalStateModel {
        initMentalStateModel()
      })
    });
    
    let selfAsOther = Array.init<MentalStateModel>(MAX_AGENTS, func(_ : Nat) : MentalStateModel {
      initMentalStateModel()
    });
    
    {
      var agentModels = agentModels;
      var numAgents = 0;
      var tomDepth = 1;
      var recursiveModels = recursiveModels;
      var selfAsOtherSees = selfAsOther;
      var currentPerspective = 0;
      var perspectiveAccuracy = 0.5;
      var falseBeliefCapability = 0.5;
      var realityBias = 0.5;
    }
  };
  
  // Update model of another agent based on observed behavior
  public func updateAgentModel(
    tom : TheoryOfMindState,
    agentIdx : Nat,
    observedBehavior : [Float],
    observedEmotion : [Float],
    context : [Float]
  ) {
    if (agentIdx >= MAX_AGENTS) { return };
    
    let model = tom.agentModels[agentIdx];
    
    // Infer beliefs from behavior + context
    // Simplified: behavior implies beliefs about situation
    for (i in Iter.range(0, MENTAL_STATE_DIM - 1)) {
      let behaviorClue = if (i < Array.size(observedBehavior)) { observedBehavior[i] } else { 0.0 };
      let contextClue = if (i < Array.size(context)) { context[i] } else { 0.0 };
      
      // Bayesian update (simplified)
      let prior = model.beliefs[i];
      let likelihood = 0.3 * behaviorClue + 0.2 * contextClue;
      model.beliefs[i] := 0.7 * prior + 0.3 * likelihood;
    };
    
    // Infer desires from behavior
    // If they did X, they probably wanted outcome of X
    for (i in Iter.range(0, MENTAL_STATE_DIM - 1)) {
      if (i < Array.size(observedBehavior)) {
        let actionStrength = Float.abs(observedBehavior[i]);
        if (actionStrength > 0.3) {
          // Strong action implies desire
          model.desires[i] := 0.8 * model.desires[i] + 0.2 * actionStrength;
        };
      };
    };
    
    // Copy observed emotions
    for (i in Iter.range(0, 5)) {
      if (i < Array.size(observedEmotion)) {
        model.emotions[i] := 0.6 * model.emotions[i] + 0.4 * observedEmotion[i];
      };
    };
    
    // Infer intentions from desires + beliefs
    for (i in Iter.range(0, MENTAL_STATE_DIM - 1)) {
      // Intention = desire × belief that action will achieve desire
      model.intentions[i] := model.desires[i] * model.beliefs[i];
    };
    
    // Uncertainty decreases with observation
    model.uncertainty := model.uncertainty * 0.95;
  };
  
  // Recursive ToM: "I think you think I think..."
  public func computeRecursiveToM(
    tom : TheoryOfMindState,
    selfState : [Float],
    targetAgent : Nat,
    depth : Nat
  ) {
    if (targetAgent >= MAX_AGENTS or depth >= MAX_TOM_DEPTH) { return };
    
    let agentModel = tom.agentModels[targetAgent];
    
    for (d in Iter.range(0, depth - 1)) {
      let recursiveModel = tom.recursiveModels[targetAgent][d];
      
      if (d == 0) {
        // First order: what do I think they think?
        // Copy current agent model
        for (i in Iter.range(0, MENTAL_STATE_DIM - 1)) {
          recursiveModel.beliefs[i] := agentModel.beliefs[i];
          recursiveModel.desires[i] := agentModel.desires[i];
        };
      } else {
        // Higher order: what do I think they think I think?
        let prevModel = tom.recursiveModels[targetAgent][d - 1];
        
        // Mix of their model and our self-projection
        for (i in Iter.range(0, MENTAL_STATE_DIM - 1)) {
          let theirView = prevModel.beliefs[i];
          let myView = if (i < Array.size(selfState)) { selfState[i] } else { 0.5 };
          
          // Reality bias: project our own beliefs onto their model of us
          recursiveModel.beliefs[i] := (1.0 - tom.realityBias) * theirView + tom.realityBias * myView;
        };
      };
      
      // Uncertainty increases with depth
      recursiveModel.uncertainty := 0.3 + 0.15 * Float.fromInt(d);
    };
    
    tom.tomDepth := depth;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: SOCIAL RELATIONSHIPS — BONDS AND CONNECTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Relationships are multi-dimensional:
  //   - Trust: Will they help or harm me?
  //   - Familiarity: How well do I know them?
  //   - Liking: Do I enjoy interacting with them?
  //   - Status: Are they higher or lower status?
  //   - Closeness: How intimate is the relationship?
  //   - Reciprocity: Do they give back what I give?
  //
  
  public type Relationship = {
    var trust : Float;                   // [-1, +1] distrust to trust
    var familiarity : Float;             // [0, 1] stranger to well-known
    var liking : Float;                  // [-1, +1] dislike to like
    var statusDiff : Float;              // [-1, +1] they're lower to higher status
    var closeness : Float;               // [0, 1] distant to intimate
    var reciprocity : Float;             // [-1, +1] imbalanced to balanced
    var cooperation : Float;             // [0, 1] competitive to cooperative
    var dependence : Float;              // [0, 1] independent to dependent
  };
  
  public type SocialNetworkState = {
    // Relationship matrix
    var relationships : [[var Relationship]]; // [self_idx][other_idx]
    var numRelationships : Nat;
    
    // Interaction history
    var interactionLog : [[var Float]];  // Recent interactions
    var logIdx : Nat;
    
    // Network metrics
    var networkDensity : Float;          // How connected is the network
    var clusteringCoefficient : Float;   // Local clustering
    var averageTrust : Float;
    var averageReciprocity : Float;
    
    // Social capital
    var socialCapital : Float;           // Overall relationship quality
    var bridgingCapital : Float;         // Connections to diverse groups
    var bondingCapital : Float;          // Strong in-group ties
  };
  
  // Initialize relationship
  public func initRelationship() : Relationship {
    {
      var trust = 0.0;
      var familiarity = 0.0;
      var liking = 0.0;
      var statusDiff = 0.0;
      var closeness = 0.0;
      var reciprocity = 0.0;
      var cooperation = 0.5;
      var dependence = 0.0;
    }
  };
  
  // Initialize social network
  public func initSocialNetwork() : SocialNetworkState {
    let relationships = Array.init<[var Relationship]>(MAX_AGENTS, func(_ : Nat) : [var Relationship] {
      Array.init<Relationship>(MAX_AGENTS, func(_ : Nat) : Relationship {
        initRelationship()
      })
    });
    
    {
      var relationships = relationships;
      var numRelationships = 0;
      var interactionLog = Array.init<[var Float]>(INTERACTION_HISTORY, func(_ : Nat) : [var Float] {
        Array.init<Float>(4, func(_ : Nat) : Float { 0.0 })  // [self, other, type, outcome]
      });
      var logIdx = 0;
      var networkDensity = 0.0;
      var clusteringCoefficient = 0.0;
      var averageTrust = 0.0;
      var averageReciprocity = 0.0;
      var socialCapital = 0.0;
      var bridgingCapital = 0.0;
      var bondingCapital = 0.0;
    }
  };
  
  // Update relationship based on interaction
  public func updateRelationship(
    network : SocialNetworkState,
    selfIdx : Nat,
    otherIdx : Nat,
    interactionType : Float,             // [-1, +1] negative to positive
    outcome : Float,                     // [-1, +1] bad to good outcome
    theyInitiated : Bool
  ) {
    if (selfIdx >= MAX_AGENTS or otherIdx >= MAX_AGENTS) { return };
    
    let rel = network.relationships[selfIdx][otherIdx];
    
    // Trust updates based on outcome
    let trustDelta = 0.1 * outcome;
    rel.trust := clamp(rel.trust + trustDelta, -1.0, 1.0);
    
    // Familiarity always increases with interaction
    rel.familiarity := Float.min(1.0, rel.familiarity + 0.05);
    
    // Liking based on interaction quality
    let likingDelta = 0.05 * interactionType;
    rel.liking := clamp(rel.liking + likingDelta, -1.0, 1.0);
    
    // Reciprocity based on who initiated
    if (theyInitiated) {
      rel.reciprocity := clamp(rel.reciprocity + 0.05, -1.0, 1.0);
    } else {
      rel.reciprocity := clamp(rel.reciprocity - 0.02, -1.0, 1.0);
    };
    
    // Closeness based on positive interactions
    if (interactionType > 0.3 and outcome > 0.0) {
      rel.closeness := Float.min(1.0, rel.closeness + 0.03);
    } else if (interactionType < -0.3) {
      rel.closeness := Float.max(0.0, rel.closeness - 0.02);
    };
    
    // Cooperation based on interaction type
    rel.cooperation := 0.9 * rel.cooperation + 0.1 * (interactionType + 1.0) / 2.0;
    
    // Log interaction
    network.interactionLog[network.logIdx][0] := Float.fromInt(selfIdx);
    network.interactionLog[network.logIdx][1] := Float.fromInt(otherIdx);
    network.interactionLog[network.logIdx][2] := interactionType;
    network.interactionLog[network.logIdx][3] := outcome;
    network.logIdx := (network.logIdx + 1) % INTERACTION_HISTORY;
  };
  
  // Compute network metrics
  public func computeNetworkMetrics(network : SocialNetworkState, numAgents : Nat) {
    if (numAgents == 0) { return };
    
    var totalTrust : Float = 0.0;
    var totalReciprocity : Float = 0.0;
    var connections : Nat = 0;
    
    for (i in Iter.range(0, numAgents - 1)) {
      for (j in Iter.range(0, numAgents - 1)) {
        if (i != j) {
          let rel = network.relationships[i][j];
          if (rel.familiarity > 0.1) {
            connections += 1;
            totalTrust += rel.trust;
            totalReciprocity += rel.reciprocity;
          };
        };
      };
    };
    
    // Network density
    let maxConnections = numAgents * (numAgents - 1);
    network.networkDensity := if (maxConnections > 0) {
      Float.fromInt(connections) / Float.fromInt(maxConnections)
    } else { 0.0 };
    
    // Averages
    if (connections > 0) {
      network.averageTrust := totalTrust / Float.fromInt(connections);
      network.averageReciprocity := totalReciprocity / Float.fromInt(connections);
    };
    
    // Social capital (simplified)
    network.socialCapital := network.networkDensity * network.averageTrust;
    network.bondingCapital := network.averageTrust * 0.5 + network.averageReciprocity * 0.5;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: COOPERATION AND GAME THEORY — STRATEGIC SOCIAL DECISIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Social interactions often have game-theoretic structure:
  //   - Prisoner's Dilemma: cooperate or defect?
  //   - Chicken: who backs down?
  //   - Stag Hunt: coordinate on high or low payoff?
  //   - Ultimatum: fair or unfair split?
  //
  
  public type GameType = {
    #prisonersDilemma;
    #chicken;
    #stagHunt;
    #ultimatum;
    #dictator;
    #trustGame;
    #publicGoods;
  };
  
  public type GameTheoryState = {
    // Strategy tendencies
    var cooperationTendency : Float;     // Base tendency to cooperate
    var fairnessConcern : Float;         // How much we care about fairness
    var riskTolerance : Float;           // Willingness to take risks
    var timeHorizon : Float;             // How much we value future
    
    // Reputation tracking
    var ownReputation : Float;           // Our reputation for cooperation
    var reputationHistory : [var Float];
    var repHistoryIdx : Nat;
    
    // Strategy adaptation
    var titForTat : Float;               // Tendency to reciprocate
    var forgiveness : Float;             // Tendency to forgive defection
    var punishment : Float;              // Tendency to punish defectors
    
    // Learning from games
    var gameHistory : [[var Float]];     // [game_idx][features]
    var gameHistoryIdx : Nat;
    var learnedStrategies : [var Float]; // Per game type
  };
  
  public let GAME_HISTORY_SIZE : Nat = 50;
  public let NUM_GAME_TYPES : Nat = 7;
  
  // Initialize game theory state
  public func initGameTheory() : GameTheoryState {
    {
      var cooperationTendency = 0.6;     // Slightly cooperative by default
      var fairnessConcern = 0.5;
      var riskTolerance = 0.5;
      var timeHorizon = 0.5;
      var ownReputation = 0.5;
      var reputationHistory = Array.init<Float>(100, func(_ : Nat) : Float { 0.5 });
      var repHistoryIdx = 0;
      var titForTat = 0.7;
      var forgiveness = 0.3;
      var punishment = 0.5;
      var gameHistory = Array.init<[var Float]>(GAME_HISTORY_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(8, func(_ : Nat) : Float { 0.0 })
      });
      var gameHistoryIdx = 0;
      var learnedStrategies = Array.init<Float>(NUM_GAME_TYPES, func(_ : Nat) : Float { 0.5 });
    }
  };
  
  // Decide whether to cooperate in a game
  public func decideCooperation(
    gameTheory : GameTheoryState,
    gameType : GameType,
    otherReputation : Float,
    lastOtherAction : Float,             // [-1, +1] their last action
    stakes : Float,                      // How much is at stake
    relationship : Relationship
  ) : Float {
    var cooperateScore : Float = gameTheory.cooperationTendency;
    
    // Adjust based on game type
    cooperateScore += switch (gameType) {
      case (#prisonersDilemma) { -0.1 };  // Temptation to defect
      case (#stagHunt) { 0.1 };           // Coordination bonus
      case (#trustGame) { 0.0 };
      case (#publicGoods) { -0.05 };      // Free-rider temptation
      case (#ultimatum) { 0.0 };
      case (#dictator) { -0.1 };
      case (#chicken) { 0.0 };
    };
    
    // Trust-based adjustment
    cooperateScore += relationship.trust * 0.3;
    
    // Reputation-based adjustment
    cooperateScore += otherReputation * 0.2;
    
    // Tit-for-tat: reciprocate previous action
    cooperateScore += gameTheory.titForTat * lastOtherAction * 0.3;
    
    // Stakes adjustment (more careful with high stakes)
    if (stakes > 0.7) {
      cooperateScore -= (1.0 - relationship.trust) * 0.2;
    };
    
    // Time horizon: future interactions → more cooperation
    cooperateScore += gameTheory.timeHorizon * 0.1;
    
    // Fairness concern in relevant games
    switch (gameType) {
      case (#ultimatum) { cooperateScore += gameTheory.fairnessConcern * 0.2 };
      case (#dictator) { cooperateScore += gameTheory.fairnessConcern * 0.3 };
      case (_) { };
    };
    
    clamp(cooperateScore, 0.0, 1.0)
  };
  
  // Update based on game outcome
  public func updateFromGameOutcome(
    gameTheory : GameTheoryState,
    gameType : GameType,
    ownAction : Float,                   // What we did
    otherAction : Float,                 // What they did
    outcome : Float                      // Our payoff
  ) {
    // Update reputation
    let reputationDelta = ownAction * 0.1;  // Cooperating builds reputation
    gameTheory.ownReputation := clamp(gameTheory.ownReputation + reputationDelta, 0.0, 1.0);
    
    gameTheory.reputationHistory[gameTheory.repHistoryIdx] := gameTheory.ownReputation;
    gameTheory.repHistoryIdx := (gameTheory.repHistoryIdx + 1) % 100;
    
    // Learn from outcome
    let expectedOutcome = gameTheory.cooperationTendency * 0.5;  // Rough expected
    let surprise = outcome - expectedOutcome;
    
    // If cooperation led to good outcome, increase tendency
    if (ownAction > 0.5 and outcome > 0.3) {
      gameTheory.cooperationTendency := Float.min(1.0, gameTheory.cooperationTendency + 0.02);
    } else if (ownAction > 0.5 and outcome < -0.3) {
      // Cooperation led to exploitation — decrease tendency
      gameTheory.cooperationTendency := Float.max(0.0, gameTheory.cooperationTendency - 0.05);
    };
    
    // Update tit-for-tat based on reciprocity
    if (Float.abs(ownAction - otherAction) < 0.3) {
      // Reciprocal outcome — reinforce tit-for-tat
      gameTheory.titForTat := Float.min(1.0, gameTheory.titForTat + 0.01);
    };
    
    // Update punishment tendency based on defection
    if (otherAction < -0.3 and ownAction > 0.3) {
      // We cooperated, they defected — increase punishment tendency
      gameTheory.punishment := Float.min(1.0, gameTheory.punishment + 0.02);
    };
    
    // Log game
    let gameIdx = switch (gameType) {
      case (#prisonersDilemma) { 0 };
      case (#chicken) { 1 };
      case (#stagHunt) { 2 };
      case (#ultimatum) { 3 };
      case (#dictator) { 4 };
      case (#trustGame) { 5 };
      case (#publicGoods) { 6 };
    };
    
    gameTheory.gameHistory[gameTheory.gameHistoryIdx][0] := Float.fromInt(gameIdx);
    gameTheory.gameHistory[gameTheory.gameHistoryIdx][1] := ownAction;
    gameTheory.gameHistory[gameTheory.gameHistoryIdx][2] := otherAction;
    gameTheory.gameHistory[gameTheory.gameHistoryIdx][3] := outcome;
    gameTheory.gameHistoryIdx := (gameTheory.gameHistoryIdx + 1) % GAME_HISTORY_SIZE;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: SOCIAL INFLUENCE — CONFORMITY AND PERSUASION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Social influence changes beliefs and behaviors:
  //   - Conformity: matching group norms
  //   - Obedience: following authority
  //   - Persuasion: changing through argument
  //   - Social proof: following others' behavior
  //
  
  public type SocialInfluenceState = {
    // Susceptibility
    var conformityTendency : Float;      // How much we conform to groups
    var obedienceTendency : Float;       // How much we obey authority
    var persuadability : Float;          // How easily persuaded
    
    // Influence sources
    var groupNorm : [var Float];         // Perceived group belief/behavior
    var authorityDirection : [var Float];// What authority says
    var socialProof : [var Float];       // What others are doing
    
    // Resistance
    var reactance : Float;               // Resistance to pressure
    var independence : Float;            // Valuing own judgment
    var criticalThinking : Float;        // Evaluating influence attempts
    
    // Influence history
    var timesConformed : Nat;
    var timesResisted : Nat;
    var influenceHistory : [var Float];
    var historyIdx : Nat;
  };
  
  public let INFLUENCE_DIM : Nat = 8;
  
  // Initialize social influence
  public func initSocialInfluence() : SocialInfluenceState {
    {
      var conformityTendency = 0.5;
      var obedienceTendency = 0.4;
      var persuadability = 0.5;
      var groupNorm = Array.init<Float>(INFLUENCE_DIM, func(_ : Nat) : Float { 0.5 });
      var authorityDirection = Array.init<Float>(INFLUENCE_DIM, func(_ : Nat) : Float { 0.5 });
      var socialProof = Array.init<Float>(INFLUENCE_DIM, func(_ : Nat) : Float { 0.5 });
      var reactance = 0.3;
      var independence = 0.5;
      var criticalThinking = 0.5;
      var timesConformed = 0;
      var timesResisted = 0;
      var influenceHistory = Array.init<Float>(50, func(_ : Nat) : Float { 0.0 });
      var historyIdx = 0;
    }
  };
  
  // Compute influence on beliefs
  public func computeSocialInfluence(
    influence : SocialInfluenceState,
    ownBelief : [Float],
    groupBelief : [Float],
    authorityBelief : [Float],
    groupSize : Nat,
    authorityStrength : Float
  ) : [Float] {
    let dim = Nat.min(Array.size(ownBelief), INFLUENCE_DIM);
    
    // Update perceived norms
    for (i in Iter.range(0, dim - 1)) {
      influence.groupNorm[i] := if (i < Array.size(groupBelief)) { groupBelief[i] } else { 0.5 };
      influence.authorityDirection[i] := if (i < Array.size(authorityBelief)) { authorityBelief[i] } else { 0.5 };
    };
    
    // Conformity pressure increases with group size (Asch effect)
    let conformityPressure = influence.conformityTendency * 
                            Float.min(1.0, Float.fromInt(groupSize) / 10.0);
    
    // Obedience pressure from authority
    let obediencePressure = influence.obedienceTendency * authorityStrength;
    
    // Compute influenced belief
    let result = Array.tabulate<Float>(dim, func(i : Nat) : Float {
      let own = ownBelief[i];
      let group = influence.groupNorm[i];
      let authority = influence.authorityDirection[i];
      
      // Weighted combination
      let socialPull = conformityPressure * group + obediencePressure * authority;
      let ownWeight = (1.0 - conformityPressure - obediencePressure) * influence.independence;
      
      // Reactance: if pressure too strong, resist
      let totalPressure = conformityPressure + obediencePressure;
      let resistanceFactor = if (totalPressure > 0.6) {
        influence.reactance * (totalPressure - 0.6)
      } else { 0.0 };
      
      // Final belief
      let influenced = ownWeight * own + (1.0 - ownWeight) * socialPull;
      
      // Apply reactance (move AWAY from influence if resisting)
      if (resistanceFactor > 0.0) {
        own + resistanceFactor * (own - influenced)
      } else {
        influenced
      }
    });
    
    result
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: COMPLETE SOCIAL COGNITION STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type SocialCognitionState = {
    theoryOfMind : TheoryOfMindState;
    network : SocialNetworkState;
    gameTheory : GameTheoryState;
    influence : SocialInfluenceState;
    
    // Global social metrics
    var socialIntelligence : Float;      // Overall social ability
    var empathy : Float;                 // Emotional understanding
    var socialSkills : Float;            // Interaction competence
    var socialAnxiety : Float;           // Anxiety in social situations
  };
  
  // Initialize complete social cognition
  public func initSocialCognition() : SocialCognitionState {
    {
      theoryOfMind = initTheoryOfMind();
      network = initSocialNetwork();
      gameTheory = initGameTheory();
      influence = initSocialInfluence();
      var socialIntelligence = 0.5;
      var empathy = 0.5;
      var socialSkills = 0.5;
      var socialAnxiety = 0.3;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: THE COMPLETE SOCIAL HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type SocialHeartbeatResult = {
    tomDepth : Nat;
    networkDensity : Float;
    cooperationDecision : Float;
    socialInfluenced : Bool;
    socialCapital : Float;
    ownReputation : Float;
  };
  
  // Run complete social cognition heartbeat
  public func runSocialHeartbeat(
    state : SocialCognitionState,
    observedAgents : [[Float]],          // Behavior of observed agents
    observedEmotions : [[Float]],        // Emotions of observed agents
    context : [Float],
    selfState : [Float],
    ownBelief : [Float],
    groupBelief : [Float],
    authorityBelief : [Float],
    currentGameType : ?GameType,
    lastOtherAction : Float,
    stakes : Float
  ) : SocialHeartbeatResult {
    let numAgents = Nat.min(Array.size(observedAgents), MAX_AGENTS);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Update Theory of Mind for each observed agent
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, numAgents - 1)) {
      let behavior = observedAgents[i];
      let emotion = if (i < Array.size(observedEmotions)) { observedEmotions[i] } else { [] };
      updateAgentModel(state.theoryOfMind, i, behavior, emotion, context);
    };
    
    // Recursive ToM for first agent
    if (numAgents > 0) {
      computeRecursiveToM(state.theoryOfMind, selfState, 0, 2);
    };
    
    state.theoryOfMind.numAgents := numAgents;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Update relationships based on any interactions
    // ───────────────────────────────────────────────────────────────────────────
    // (Would need interaction data — simplified)
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Compute network metrics
    // ───────────────────────────────────────────────────────────────────────────
    computeNetworkMetrics(state.network, numAgents);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Game theory decision if in a game
    // ───────────────────────────────────────────────────────────────────────────
    var cooperationDecision : Float = 0.5;
    
    switch (currentGameType) {
      case (?gameType) {
        let relationship = if (numAgents > 0) {
          state.network.relationships[0][1]  // Simplified
        } else {
          initRelationship()
        };
        
        let otherRep = if (numAgents > 0) {
          state.theoryOfMind.agentModels[1].uncertainty  // Simplified proxy
        } else { 0.5 };
        
        cooperationDecision := decideCooperation(
          state.gameTheory,
          gameType,
          1.0 - otherRep,  // Higher uncertainty = lower trust
          lastOtherAction,
          stakes,
          relationship
        );
      };
      case (null) { };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Compute social influence
    // ───────────────────────────────────────────────────────────────────────────
    let influencedBelief = computeSocialInfluence(
      state.influence,
      ownBelief,
      groupBelief,
      authorityBelief,
      numAgents,
      0.5  // Authority strength
    );
    
    let wasInfluenced = Array.size(influencedBelief) > 0 and 
                       Array.size(ownBelief) > 0 and
                       Float.abs(influencedBelief[0] - ownBelief[0]) > 0.1;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Update global metrics
    // ───────────────────────────────────────────────────────────────────────────
    state.socialIntelligence := (
      state.theoryOfMind.perspectiveAccuracy +
      state.network.socialCapital +
      state.gameTheory.ownReputation
    ) / 3.0;
    
    state.empathy := state.theoryOfMind.falseBeliefCapability * 0.5 +
                    (1.0 - state.theoryOfMind.realityBias) * 0.5;
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return result
    // ───────────────────────────────────────────────────────────────────────────
    {
      tomDepth = state.theoryOfMind.tomDepth;
      networkDensity = state.network.networkDensity;
      cooperationDecision = cooperationDecision;
      socialInfluenced = wasInfluenced;
      socialCapital = state.network.socialCapital;
      ownReputation = state.gameTheory.ownReputation;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };

};
