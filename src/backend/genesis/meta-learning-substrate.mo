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
// META-LEARNING SUBSTRATE — LEARNING TO LEARN
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements meta-learning capabilities, enabling the organism to:
// 1. Learn how to learn more effectively across different domains
// 2. Adapt learning strategies based on task characteristics
// 3. Transfer knowledge and learning methods between domains
// 4. Optimize hyperparameters of learning algorithms
// 5. Identify and leverage common structures across tasks
//
// META-LEARNING ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                              META-LEARNING SYSTEM                                               │
// │                                                                                                 │
// │  ┌─────────────────────────────────────────────────────────────────────────────────────────┐  │
// │  │                         META-LEARNER (Outer Loop)                                        │  │
// │  │  • Learns learning algorithms                                                            │  │
// │  │  • Optimizes hyperparameters                                                             │  │
// │  │  • Selects transfer strategies                                                           │  │
// │  │  • Evaluates learning performance                                                        │  │
// │  └────────────────────────────────────────┬────────────────────────────────────────────────┘  │
// │                                           │                                                   │
// │            ┌──────────────────────────────┼──────────────────────────────┐                    │
// │            │                              │                              │                    │
// │            ▼                              ▼                              ▼                    │
// │  ┌─────────────────┐          ┌─────────────────┐          ┌─────────────────┐               │
// │  │  BASE LEARNER 1 │          │  BASE LEARNER 2 │          │  BASE LEARNER N │               │
// │  │  (Task-specific)│          │  (Task-specific)│          │  (Task-specific)│               │
// │  │  Inner Loop     │          │  Inner Loop     │          │  Inner Loop     │               │
// │  └────────┬────────┘          └────────┬────────┘          └────────┬────────┘               │
// │           │                            │                            │                        │
// │           ▼                            ▼                            ▼                        │
// │  ┌─────────────────┐          ┌─────────────────┐          ┌─────────────────┐               │
// │  │    Task 1       │          │    Task 2       │          │    Task N       │               │
// │  └─────────────────┘          └─────────────────┘          └─────────────────┘               │
// └─────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// 1. MAML (Model-Agnostic Meta-Learning):
//    θ* = θ - α∇θ Σᵢ L(fθ'ᵢ, Dᵢᵗᵉˢᵗ) where θ'ᵢ = θ - β∇θ L(fθ, Dᵢᵗʳᵃⁱⁿ)
//
// 2. Learning Rate Adaptation:
//    α(t+1) = α(t) × exp(-λ × gradient_variance)
//
// 3. Task Similarity:
//    sim(T₁, T₂) = cos(embedding(T₁), embedding(T₂))
//
// 4. Knowledge Transfer:
//    θ_new = θ_old + β × Σⱼ sim(T_new, Tⱼ) × (θⱼ - θ_old)
//
// 5. Curriculum Learning:
//    task_order = argsort(difficulty(tasks))
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module MetaLearningSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // META-LEARNING CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum number of tasks
  public let MAX_TASKS : Nat = 200;
  
  /// Maximum number of learning strategies
  public let MAX_STRATEGIES : Nat = 50;
  
  /// Maximum parameter dimensions
  public let MAX_PARAM_DIM : Nat = 128;
  
  /// Meta-learning rate (outer loop)
  public let META_ALPHA : Float = 0.01;
  
  /// Base learning rate (inner loop)
  public let BASE_BETA : Float = 0.1;
  
  /// Inner loop iterations
  public let INNER_LOOP_STEPS : Nat = 5;
  
  /// Task embedding dimension
  public let EMBEDDING_DIM : Nat = 32;
  
  /// Minimum similarity for transfer
  public let TRANSFER_THRESHOLD : Float = 0.5;
  
  /// Experience replay buffer size
  public let EXPERIENCE_BUFFER_SIZE : Nat = 1000;
  
  /// Curriculum learning window
  public let CURRICULUM_WINDOW : Nat = 10;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: TASK TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Task category
  public type TaskCategory = {
    #Classification;
    #Regression;
    #SequenceModeling;
    #ReinforcementLearning;
    #GenerativeModeling;
    #Optimization;
    #Reasoning;
    #LanguageUnderstanding;
    #PatternRecognition;
    #DecisionMaking;
    #Planning;
    #MemoryRetrieval;
  };
  
  /// Task difficulty
  public type TaskDifficulty = {
    #Trivial;
    #Easy;
    #Medium;
    #Hard;
    #VeryHard;
    #Unknown;
  };
  
  /// Task state
  public type TaskState = {
    #Pending;
    #Training;
    #Evaluating;
    #Completed;
    #Failed;
    #Transferred;
  };
  
  /// Learning task
  public type LearningTask = {
    taskId : Nat64;
    name : Text;
    category : TaskCategory;
    var difficulty : TaskDifficulty;
    var state : TaskState;
    
    // Data
    var trainDataSize : Nat;
    var testDataSize : Nat;
    var inputDim : Nat;
    var outputDim : Nat;
    
    // Embedding (for similarity)
    var embedding : [Float];
    
    // Performance
    var currentLoss : Float;
    var bestLoss : Float;
    var currentAccuracy : Float;
    var bestAccuracy : Float;
    var learningCurve : Buffer.Buffer<LearningPoint>;
    
    // Timing
    createdBeat : Int;
    var startedBeat : ?Int;
    var completedBeat : ?Int;
    var trainingTime : Nat;
    
    // Meta-data
    var selectedStrategy : ?Nat64;
    var transferSources : [Nat64];
    var iterationsCompleted : Nat;
  };
  
  /// Learning curve point
  public type LearningPoint = {
    iteration : Nat;
    beat : Int;
    loss : Float;
    accuracy : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: LEARNING STRATEGIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Learning strategy type
  public type StrategyType = {
    #GradientDescent;
    #StochasticGD;
    #Adam;
    #RMSProp;
    #NaturalGradient;
    #SecondOrder;
    #EvolutionaryStrategy;
    #BayesianOptimization;
    #MetaGradient;
    #MAML;
    #Reptile;
    #ProtoNet;
    #TransferLearning;
  };
  
  /// Hyperparameter type
  public type HyperparameterType = {
    #LearningRate;
    #Momentum;
    #Regularization;
    #BatchSize;
    #EpochCount;
    #DropoutRate;
    #LayerCount;
    #HiddenDim;
    #ActivationType;
    #InitializationType;
  };
  
  /// Hyperparameter
  public type Hyperparameter = {
    paramType : HyperparameterType;
    var value : Float;
    var minValue : Float;
    var maxValue : Float;
    var isAdaptive : Bool;
    var adaptationRate : Float;
  };
  
  /// Learning strategy
  public type LearningStrategy = {
    strategyId : Nat64;
    name : Text;
    strategyType : StrategyType;
    var hyperparameters : [Hyperparameter];
    
    // Effectiveness tracking
    var tasksApplied : Nat;
    var averageFinalLoss : Float;
    var averageFinalAccuracy : Float;
    var averageConvergenceTime : Float;
    var successRate : Float;
    
    // Task category affinity
    var categoryAffinity : [(TaskCategory, Float)];
    
    // Meta-parameters
    var metaLearningRate : Float;
    var innerLoopSteps : Nat;
    var isMAML : Bool;
    
    createdBeat : Int;
    var lastUsedBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: KNOWLEDGE TRANSFER
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Transfer type
  public type TransferType = {
    #ParameterTransfer;     // Transfer learned parameters
    #FeatureTransfer;       // Transfer learned features
    #ArchitectureTransfer;  // Transfer network structure
    #HyperparamTransfer;    // Transfer hyperparameters
    #EmbeddingTransfer;     // Transfer learned embeddings
    #StrategyTransfer;      // Transfer learning strategy
  };
  
  /// Transfer record
  public type TransferRecord = {
    transferId : Nat64;
    sourceTaskId : Nat64;
    targetTaskId : Nat64;
    transferType : TransferType;
    var similarity : Float;
    var transferAmount : Float;
    var benefit : Float;         // Improvement from transfer
    beat : Int;
  };
  
  /// Knowledge base entry
  public type KnowledgeEntry = {
    entryId : Nat64;
    taskId : Nat64;
    var parameters : [Float];    // Learned parameters
    var embedding : [Float];     // Task embedding
    var strategyId : Nat64;
    var finalLoss : Float;
    var finalAccuracy : Float;
    var trainingTime : Nat;
    createdBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: CURRICULUM LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Curriculum state
  public type CurriculumState = {
    var currentPhase : CurriculumPhase;
    var difficultyLevel : Float;
    var taskOrder : [Nat64];
    var completedTasks : [Nat64];
    var failedTasks : [Nat64];
    var currentTaskIndex : Nat;
  };
  
  /// Curriculum phase
  public type CurriculumPhase = {
    #Warmup;          // Start with easiest tasks
    #Progressive;     // Gradually increase difficulty
    #Mixed;           // Mix of difficulties for generalization
    #Challenging;     // Focus on hard tasks
    #Review;          // Revisit previously failed tasks
    #Mastery;         // Final comprehensive evaluation
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: EXPERIENCE REPLAY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Experience entry
  public type ExperienceEntry = {
    entryId : Nat64;
    taskId : Nat64;
    strategyId : Nat64;
    iteration : Nat;
    var state : [Float];         // System state
    var action : [Float];        // Action taken (parameter updates)
    var reward : Float;          // Reward (negative loss improvement)
    var nextState : [Float];     // Next state
    beat : Int;
  };
  
  /// Replay buffer
  public type ReplayBuffer = {
    var entries : Buffer.Buffer<ExperienceEntry>;
    var maxSize : Nat;
    var currentSize : Nat;
    var totalAdded : Nat;
    var entryIdCounter : Nat64;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: META-LEARNER STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Meta-learner state
  public type MetaLearnerState = {
    // Meta-parameters (MAML-style)
    var metaParameters : [Float];
    var metaGradients : [Float];
    var metaLearningRate : Float;
    var metaMomentum : [Float];
    
    // Learning rate adaptation
    var adaptiveLR : Float;
    var lrHistory : Buffer.Buffer<Float>;
    var gradientVariance : Float;
    
    // Performance tracking
    var recentLosses : Buffer.Buffer<Float>;
    var recentAccuracies : Buffer.Buffer<Float>;
    var movingAverageLoss : Float;
    var movingAverageAccuracy : Float;
    
    // Generalization metrics
    var trainTestGap : Float;
    var overfittingScore : Float;
    var generalizationScore : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: COMPLETE META-LEARNING STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete meta-learning state
  public type MetaLearningState = {
    // Tasks
    var tasks : Buffer.Buffer<LearningTask>;
    var activeTasks : [Nat64];
    var completedTasks : Buffer.Buffer<Nat64>;
    
    // Strategies
    var strategies : Buffer.Buffer<LearningStrategy>;
    
    // Knowledge base
    var knowledgeBase : Buffer.Buffer<KnowledgeEntry>;
    var transferRecords : Buffer.Buffer<TransferRecord>;
    
    // Curriculum
    var curriculum : CurriculumState;
    
    // Experience replay
    var replayBuffer : ReplayBuffer;
    
    // Meta-learner
    var metaLearner : MetaLearnerState;
    
    // Statistics
    var totalTasksCompleted : Nat;
    var totalTransfers : Nat;
    var averageLearningSpeed : Float;
    var overallSuccessRate : Float;
    
    // Counters
    var taskIdCounter : Nat64;
    var strategyIdCounter : Nat64;
    var entryIdCounter : Nat64;
    var transferIdCounter : Nat64;
    var currentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize meta-learning system
  public func initMetaLearning() : MetaLearningState {
    let state : MetaLearningState = {
      var tasks = Buffer.Buffer<LearningTask>(MAX_TASKS);
      var activeTasks = [];
      var completedTasks = Buffer.Buffer<Nat64>(100);
      
      var strategies = Buffer.Buffer<LearningStrategy>(MAX_STRATEGIES);
      
      var knowledgeBase = Buffer.Buffer<KnowledgeEntry>(500);
      var transferRecords = Buffer.Buffer<TransferRecord>(200);
      
      var curriculum = initCurriculum();
      
      var replayBuffer = initReplayBuffer();
      
      var metaLearner = initMetaLearner();
      
      var totalTasksCompleted = 0;
      var totalTransfers = 0;
      var averageLearningSpeed = 0.0;
      var overallSuccessRate = S_ZERO_FLOOR;
      
      var taskIdCounter = 0;
      var strategyIdCounter = 0;
      var entryIdCounter = 0;
      var transferIdCounter = 0;
      var currentBeat = 0;
    };
    
    // Create default strategies
    createDefaultStrategies(state, 0);
    
    state
  };
  
  /// Initialize curriculum
  func initCurriculum() : CurriculumState {
    {
      var currentPhase = #Warmup;
      var difficultyLevel = 0.0;
      var taskOrder = [];
      var completedTasks = [];
      var failedTasks = [];
      var currentTaskIndex = 0;
    }
  };
  
  /// Initialize replay buffer
  func initReplayBuffer() : ReplayBuffer {
    {
      var entries = Buffer.Buffer<ExperienceEntry>(EXPERIENCE_BUFFER_SIZE);
      var maxSize = EXPERIENCE_BUFFER_SIZE;
      var currentSize = 0;
      var totalAdded = 0;
      var entryIdCounter = 0;
    }
  };
  
  /// Initialize meta-learner
  func initMetaLearner() : MetaLearnerState {
    let params = Array.tabulate<Float>(MAX_PARAM_DIM, func(_ : Nat) : Float { 0.0 });
    let grads = Array.tabulate<Float>(MAX_PARAM_DIM, func(_ : Nat) : Float { 0.0 });
    let momentum = Array.tabulate<Float>(MAX_PARAM_DIM, func(_ : Nat) : Float { 0.0 });
    
    {
      var metaParameters = params;
      var metaGradients = grads;
      var metaLearningRate = META_ALPHA;
      var metaMomentum = momentum;
      
      var adaptiveLR = BASE_BETA;
      var lrHistory = Buffer.Buffer<Float>(100);
      var gradientVariance = 0.0;
      
      var recentLosses = Buffer.Buffer<Float>(100);
      var recentAccuracies = Buffer.Buffer<Float>(100);
      var movingAverageLoss = 0.0;
      var movingAverageAccuracy = S_ZERO_FLOOR;
      
      var trainTestGap = 0.0;
      var overfittingScore = 0.0;
      var generalizationScore = S_ZERO_FLOOR;
    }
  };
  
  /// Create default learning strategies
  func createDefaultStrategies(state : MetaLearningState, beat : Int) : () {
    // 1. Gradient Descent
    let gdStrategy = createStrategy(state, "Gradient Descent", #GradientDescent, beat);
    
    // 2. Adam
    let adamStrategy = createStrategy(state, "Adam Optimizer", #Adam, beat);
    
    // 3. MAML
    let mamlStrategy = createStrategy(state, "MAML", #MAML, beat);
    
    // 4. Transfer Learning
    let transferStrategy = createStrategy(state, "Transfer Learning", #TransferLearning, beat);
    
    // 5. Evolutionary Strategy
    let esStrategy = createStrategy(state, "Evolutionary Strategy", #EvolutionaryStrategy, beat);
  };
  
  /// Create a learning strategy
  func createStrategy(
    state : MetaLearningState,
    name : Text,
    strategyType : StrategyType,
    beat : Int
  ) : Nat64 {
    let strategyId = state.strategyIdCounter;
    state.strategyIdCounter += 1;
    
    // Default hyperparameters based on strategy type
    let hyperparams = getDefaultHyperparameters(strategyType);
    
    let strategy : LearningStrategy = {
      strategyId = strategyId;
      name = name;
      strategyType = strategyType;
      var hyperparameters = hyperparams;
      
      var tasksApplied = 0;
      var averageFinalLoss = 0.0;
      var averageFinalAccuracy = 0.0;
      var averageConvergenceTime = 0.0;
      var successRate = S_ZERO_FLOOR;
      
      var categoryAffinity = [];
      
      var metaLearningRate = META_ALPHA;
      var innerLoopSteps = INNER_LOOP_STEPS;
      var isMAML = strategyType == #MAML;
      
      createdBeat = beat;
      var lastUsedBeat = beat;
    };
    
    state.strategies.add(strategy);
    strategyId
  };
  
  /// Get default hyperparameters for strategy type
  func getDefaultHyperparameters(strategyType : StrategyType) : [Hyperparameter] {
    switch (strategyType) {
      case (#GradientDescent) {
        [
          { paramType = #LearningRate; var value = 0.01; var minValue = 0.0001; var maxValue = 1.0; var isAdaptive = true; var adaptationRate = 0.1 },
          { paramType = #Momentum; var value = 0.0; var minValue = 0.0; var maxValue = 0.99; var isAdaptive = false; var adaptationRate = 0.0 }
        ]
      };
      case (#Adam) {
        [
          { paramType = #LearningRate; var value = 0.001; var minValue = 0.0001; var maxValue = 0.1; var isAdaptive = true; var adaptationRate = 0.1 },
          { paramType = #Momentum; var value = 0.9; var minValue = 0.5; var maxValue = 0.999; var isAdaptive = false; var adaptationRate = 0.0 }
        ]
      };
      case (#MAML) {
        [
          { paramType = #LearningRate; var value = 0.01; var minValue = 0.001; var maxValue = 0.1; var isAdaptive = true; var adaptationRate = 0.05 },
          { paramType = #EpochCount; var value = 5.0; var minValue = 1.0; var maxValue = 20.0; var isAdaptive = false; var adaptationRate = 0.0 }
        ]
      };
      case (_) {
        [
          { paramType = #LearningRate; var value = 0.01; var minValue = 0.0001; var maxValue = 1.0; var isAdaptive = true; var adaptationRate = 0.1 }
        ]
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: TASK MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a new learning task
  public func createTask(
    state : MetaLearningState,
    name : Text,
    category : TaskCategory,
    inputDim : Nat,
    outputDim : Nat,
    beat : Int
  ) : Nat64 {
    let taskId = state.taskIdCounter;
    state.taskIdCounter += 1;
    
    let task : LearningTask = {
      taskId = taskId;
      name = name;
      category = category;
      var difficulty = #Unknown;
      var state = #Pending;
      
      var trainDataSize = 0;
      var testDataSize = 0;
      var inputDim = inputDim;
      var outputDim = outputDim;
      
      var embedding = Array.tabulate<Float>(EMBEDDING_DIM, func(_ : Nat) : Float { 0.0 });
      
      var currentLoss = 1.0;
      var bestLoss = 1.0;
      var currentAccuracy = 0.0;
      var bestAccuracy = 0.0;
      var learningCurve = Buffer.Buffer<LearningPoint>(500);
      
      createdBeat = beat;
      var startedBeat = null;
      var completedBeat = null;
      var trainingTime = 0;
      
      var selectedStrategy = null;
      var transferSources = [];
      var iterationsCompleted = 0;
    };
    
    state.tasks.add(task);
    taskId
  };
  
  /// Start training a task
  public func startTask(
    state : MetaLearningState,
    taskId : Nat64,
    strategyId : ?Nat64,
    beat : Int
  ) : Bool {
    for (task in state.tasks.vals()) {
      if (task.taskId == taskId and task.state == #Pending) {
        task.state := #Training;
        task.startedBeat := ?beat;
        
        // Select strategy if not specified
        let selectedStrategy = switch (strategyId) {
          case (?sid) { sid };
          case (null) { selectBestStrategy(state, task) };
        };
        task.selectedStrategy := ?selectedStrategy;
        
        // Look for transfer opportunities
        let transfers = findTransferSources(state, task);
        task.transferSources := transfers;
        
        // Add to active tasks
        state.activeTasks := Array.append(state.activeTasks, [taskId]);
        
        return true;
      };
    };
    false
  };
  
  /// Select best strategy for a task
  func selectBestStrategy(state : MetaLearningState, task : LearningTask) : Nat64 {
    var bestStrategyId : Nat64 = 0;
    var bestScore : Float = 0.0;
    
    for (strategy in state.strategies.vals()) {
      // Score based on category affinity
      var affinity : Float = 0.5;
      for ((cat, aff) in strategy.categoryAffinity.vals()) {
        if (cat == task.category) {
          affinity := aff;
        };
      };
      
      // Score based on past success
      let successScore = strategy.successRate;
      
      // Combined score
      let score = affinity * 0.4 + successScore * 0.6;
      
      if (score > bestScore) {
        bestScore := score;
        bestStrategyId := strategy.strategyId;
      };
    };
    
    bestStrategyId
  };
  
  /// Find potential transfer sources
  func findTransferSources(state : MetaLearningState, task : LearningTask) : [Nat64] {
    var sources : [Nat64] = [];
    
    for (entry in state.knowledgeBase.vals()) {
      let similarity = computeTaskSimilarity(task.embedding, entry.embedding);
      
      if (similarity > TRANSFER_THRESHOLD) {
        sources := Array.append(sources, [entry.taskId]);
      };
    };
    
    sources
  };
  
  /// Compute similarity between task embeddings
  func computeTaskSimilarity(emb1 : [Float], emb2 : [Float]) : Float {
    // Cosine similarity
    var dotProduct : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    
    let n = Nat.min(emb1.size(), emb2.size());
    
    for (i in Iter.range(0, n - 1)) {
      dotProduct += emb1[i] * emb2[i];
      norm1 += emb1[i] * emb1[i];
      norm2 += emb2[i] * emb2[i];
    };
    
    if (norm1 > 0.0 and norm2 > 0.0) {
      dotProduct / (Float.sqrt(norm1) * Float.sqrt(norm2))
    } else {
      0.0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: TRAINING LOOP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Perform one training step
  public func trainStep(
    state : MetaLearningState,
    taskId : Nat64,
    currentLoss : Float,
    currentAccuracy : Float,
    gradients : [Float],
    beat : Int
  ) : TrainingStepResult {
    var result : TrainingStepResult = {
      taskId = taskId;
      newLoss = currentLoss;
      newAccuracy = currentAccuracy;
      learningRate = BASE_BETA;
      isComplete = false;
      beat = beat;
    };
    
    for (task in state.tasks.vals()) {
      if (task.taskId == taskId and task.state == #Training) {
        task.iterationsCompleted += 1;
        task.trainingTime += 1;
        
        // Get strategy
        var learningRate = BASE_BETA;
        switch (task.selectedStrategy) {
          case (?strategyId) {
            for (strategy in state.strategies.vals()) {
              if (strategy.strategyId == strategyId) {
                for (hp in strategy.hyperparameters.vals()) {
                  if (hp.paramType == #LearningRate) {
                    learningRate := hp.value;
                  };
                };
                strategy.lastUsedBeat := beat;
              };
            };
          };
          case (null) {};
        };
        
        // Apply transfer learning if applicable
        if (task.transferSources.size() > 0) {
          // Would apply transfer here
          learningRate *= 1.2;  // Boost LR for transfer
        };
        
        // Update task metrics
        task.currentLoss := currentLoss;
        task.currentAccuracy := currentAccuracy;
        
        if (currentLoss < task.bestLoss) {
          task.bestLoss := currentLoss;
        };
        if (currentAccuracy > task.bestAccuracy) {
          task.bestAccuracy := currentAccuracy;
        };
        
        // Record learning curve
        let point : LearningPoint = {
          iteration = task.iterationsCompleted;
          beat = beat;
          loss = currentLoss;
          accuracy = currentAccuracy;
        };
        task.learningCurve.add(point);
        
        // Update meta-learner
        updateMetaLearner(state, gradients, currentLoss);
        
        // Check completion
        let isComplete = checkTaskCompletion(task);
        if (isComplete) {
          completeTask(state, taskId, beat);
        };
        
        result := {
          taskId = taskId;
          newLoss = currentLoss;
          newAccuracy = currentAccuracy;
          learningRate = learningRate;
          isComplete = isComplete;
          beat = beat;
        };
      };
    };
    
    result
  };
  
  /// Training step result
  public type TrainingStepResult = {
    taskId : Nat64;
    newLoss : Float;
    newAccuracy : Float;
    learningRate : Float;
    isComplete : Bool;
    beat : Int;
  };
  
  /// Update meta-learner with new gradient information
  func updateMetaLearner(state : MetaLearningState, gradients : [Float], loss : Float) : () {
    let meta = state.metaLearner;
    
    // Update moving average loss
    meta.recentLosses.add(loss);
    if (meta.recentLosses.size() > 100) {
      ignore meta.recentLosses.remove(0);
    };
    
    var sumLoss : Float = 0.0;
    for (l in meta.recentLosses.vals()) {
      sumLoss += l;
    };
    meta.movingAverageLoss := sumLoss / Float.fromInt(meta.recentLosses.size());
    
    // Compute gradient variance
    if (gradients.size() > 0) {
      var gradSum : Float = 0.0;
      var gradSqSum : Float = 0.0;
      for (g in gradients.vals()) {
        gradSum += Float.abs(g);
        gradSqSum += g * g;
      };
      let mean = gradSum / Float.fromInt(gradients.size());
      let meanSq = gradSqSum / Float.fromInt(gradients.size());
      meta.gradientVariance := meanSq - mean * mean;
      
      // Adapt learning rate based on gradient variance
      // High variance = lower LR, low variance = higher LR
      let varianceFactor = Float.exp(-meta.gradientVariance * 0.1);
      meta.adaptiveLR := BASE_BETA * varianceFactor;
      meta.lrHistory.add(meta.adaptiveLR);
    };
  };
  
  /// Check if task is complete
  func checkTaskCompletion(task : LearningTask) : Bool {
    // Check convergence (loss not improving)
    if (task.learningCurve.size() > 20) {
      let recent = task.learningCurve.size();
      let start = recent - 10;
      
      var earlyLoss : Float = 0.0;
      var lateLoss : Float = 0.0;
      
      for (i in Iter.range(Int.abs(start) - 10, Int.abs(start) - 1)) {
        earlyLoss += task.learningCurve.get(i).loss;
      };
      for (i in Iter.range(Int.abs(start), recent - 1)) {
        lateLoss += task.learningCurve.get(i).loss;
      };
      
      earlyLoss /= 10.0;
      lateLoss /= 10.0;
      
      // Converged if late loss is not much better than early
      if (lateLoss > earlyLoss * 0.99) {
        return true;
      };
    };
    
    // Check if accuracy threshold met
    if (task.currentAccuracy > 0.95) {
      return true;
    };
    
    // Check iteration limit
    if (task.iterationsCompleted > 1000) {
      return true;
    };
    
    false
  };
  
  /// Complete a task
  func completeTask(state : MetaLearningState, taskId : Nat64, beat : Int) : () {
    for (task in state.tasks.vals()) {
      if (task.taskId == taskId) {
        task.state := #Completed;
        task.completedBeat := ?beat;
        
        state.completedTasks.add(taskId);
        state.totalTasksCompleted += 1;
        
        // Remove from active
        state.activeTasks := Array.filter(state.activeTasks, func(id : Nat64) : Bool {
          id != taskId
        });
        
        // Estimate difficulty based on training time and accuracy
        task.difficulty := estimateDifficulty(task);
        
        // Add to knowledge base
        addToKnowledgeBase(state, task, beat);
        
        // Update strategy statistics
        switch (task.selectedStrategy) {
          case (?strategyId) {
            updateStrategyStats(state, strategyId, task);
          };
          case (null) {};
        };
        
        // Update overall statistics
        updateOverallStats(state);
      };
    };
  };
  
  /// Estimate task difficulty
  func estimateDifficulty(task : LearningTask) : TaskDifficulty {
    // Based on training time and final accuracy
    let timeScore = Float.fromInt(task.trainingTime) / 1000.0;
    let accuracyScore = 1.0 - task.bestAccuracy;
    
    let difficultyScore = (timeScore + accuracyScore) / 2.0;
    
    if (difficultyScore < 0.1) { #Trivial }
    else if (difficultyScore < 0.25) { #Easy }
    else if (difficultyScore < 0.5) { #Medium }
    else if (difficultyScore < 0.75) { #Hard }
    else { #VeryHard }
  };
  
  /// Add completed task to knowledge base
  func addToKnowledgeBase(state : MetaLearningState, task : LearningTask, beat : Int) : () {
    let entryId = state.entryIdCounter;
    state.entryIdCounter += 1;
    
    let entry : KnowledgeEntry = {
      entryId = entryId;
      taskId = task.taskId;
      var parameters = [];  // Would contain learned parameters
      var embedding = task.embedding;
      var strategyId = switch (task.selectedStrategy) {
        case (?s) { s };
        case (null) { 0 };
      };
      var finalLoss = task.bestLoss;
      var finalAccuracy = task.bestAccuracy;
      var trainingTime = task.trainingTime;
      createdBeat = beat;
    };
    
    state.knowledgeBase.add(entry);
  };
  
  /// Update strategy statistics
  func updateStrategyStats(state : MetaLearningState, strategyId : Nat64, task : LearningTask) : () {
    for (strategy in state.strategies.vals()) {
      if (strategy.strategyId == strategyId) {
        strategy.tasksApplied += 1;
        
        let n = Float.fromInt(strategy.tasksApplied);
        
        // Update running averages
        strategy.averageFinalLoss := (strategy.averageFinalLoss * (n - 1.0) + task.bestLoss) / n;
        strategy.averageFinalAccuracy := (strategy.averageFinalAccuracy * (n - 1.0) + task.bestAccuracy) / n;
        strategy.averageConvergenceTime := (strategy.averageConvergenceTime * (n - 1.0) + Float.fromInt(task.trainingTime)) / n;
        
        // Update success rate
        if (task.bestAccuracy > 0.8) {
          strategy.successRate := (strategy.successRate * (n - 1.0) + 1.0) / n;
        } else {
          strategy.successRate := (strategy.successRate * (n - 1.0)) / n;
        };
        
        // Update category affinity
        var found = false;
        var newAffinity : [(TaskCategory, Float)] = [];
        for ((cat, aff) in strategy.categoryAffinity.vals()) {
          if (cat == task.category) {
            let newAff = (aff * 0.9 + task.bestAccuracy * 0.1);
            newAffinity := Array.append(newAffinity, [(cat, newAff)]);
            found := true;
          } else {
            newAffinity := Array.append(newAffinity, [(cat, aff)]);
          };
        };
        if (not found) {
          newAffinity := Array.append(newAffinity, [(task.category, task.bestAccuracy)]);
        };
        strategy.categoryAffinity := newAffinity;
      };
    };
  };
  
  /// Update overall statistics
  func updateOverallStats(state : MetaLearningState) : () {
    // Compute average learning speed
    var totalTime : Float = 0.0;
    var count : Nat = 0;
    
    for (entry in state.knowledgeBase.vals()) {
      totalTime += Float.fromInt(entry.trainingTime);
      count += 1;
    };
    
    if (count > 0) {
      state.averageLearningSpeed := totalTime / Float.fromInt(count);
    };
    
    // Compute success rate
    var successes : Nat = 0;
    for (entry in state.knowledgeBase.vals()) {
      if (entry.finalAccuracy > 0.8) {
        successes += 1;
      };
    };
    
    if (count > 0) {
      state.overallSuccessRate := Float.fromInt(successes) / Float.fromInt(count);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: MAML IMPLEMENTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// MAML outer loop step
  public func mamlOuterStep(
    state : MetaLearningState,
    taskBatch : [Nat64],
    beat : Int
  ) : MAMLResult {
    let meta = state.metaLearner;
    
    var totalOuterLoss : Float = 0.0;
    var outerGradients = Array.init<Float>(MAX_PARAM_DIM, 0.0);
    var tasksProcessed : Nat = 0;
    
    for (taskId in taskBatch.vals()) {
      for (task in state.tasks.vals()) {
        if (task.taskId == taskId) {
          // Perform inner loop adaptation
          let innerResult = mamlInnerLoop(state, task, beat);
          
          // Accumulate outer gradients
          for (i in Iter.range(0, MAX_PARAM_DIM - 1)) {
            outerGradients[i] += innerResult.outerGradients[i];
          };
          
          totalOuterLoss += innerResult.adaptedLoss;
          tasksProcessed += 1;
        };
      };
    };
    
    // Average gradients
    if (tasksProcessed > 0) {
      for (i in Iter.range(0, MAX_PARAM_DIM - 1)) {
        outerGradients[i] /= Float.fromInt(tasksProcessed);
      };
    };
    
    // Update meta-parameters
    let newParams = Array.init<Float>(MAX_PARAM_DIM, 0.0);
    for (i in Iter.range(0, MAX_PARAM_DIM - 1)) {
      // SGD with momentum
      let momentum = 0.9;
      meta.metaMomentum[i] := momentum * meta.metaMomentum[i] + (1.0 - momentum) * outerGradients[i];
      newParams[i] := meta.metaParameters[i] - meta.metaLearningRate * meta.metaMomentum[i];
    };
    meta.metaParameters := Array.freeze(newParams);
    meta.metaGradients := Array.freeze(outerGradients);
    
    {
      tasksProcessed = tasksProcessed;
      averageOuterLoss = if (tasksProcessed > 0) { totalOuterLoss / Float.fromInt(tasksProcessed) } else { 0.0 };
      metaGradientNorm = computeGradientNorm(Array.freeze(outerGradients));
      beat = beat;
    }
  };
  
  /// MAML result
  public type MAMLResult = {
    tasksProcessed : Nat;
    averageOuterLoss : Float;
    metaGradientNorm : Float;
    beat : Int;
  };
  
  /// MAML inner loop
  func mamlInnerLoop(
    state : MetaLearningState,
    task : LearningTask,
    beat : Int
  ) : MAMLInnerResult {
    let meta = state.metaLearner;
    
    // Clone meta-parameters for adaptation
    var adaptedParams = Array.thaw<Float>(meta.metaParameters);
    
    // Perform K inner loop steps
    var innerLoss : Float = 1.0;
    for (_ in Iter.range(0, INNER_LOOP_STEPS - 1)) {
      // Compute loss gradient (simulated)
      let innerGradients = computeInnerGradients(adaptedParams, task);
      
      // Update adapted parameters
      for (i in Iter.range(0, MAX_PARAM_DIM - 1)) {
        adaptedParams[i] -= BASE_BETA * innerGradients[i];
      };
      
      // Update inner loss
      innerLoss *= 0.9;  // Simulated improvement
    };
    
    // Compute outer gradients (second-order)
    let outerGradients = computeOuterGradients(Array.freeze(adaptedParams), meta.metaParameters, task);
    
    {
      adaptedParams = Array.freeze(adaptedParams);
      adaptedLoss = innerLoss;
      outerGradients = outerGradients;
    }
  };
  
  /// MAML inner result
  type MAMLInnerResult = {
    adaptedParams : [Float];
    adaptedLoss : Float;
    outerGradients : [Float];
  };
  
  /// Compute inner loop gradients (simulated)
  func computeInnerGradients(params : [var Float], task : LearningTask) : [Float] {
    // Simplified gradient computation
    Array.tabulate<Float>(MAX_PARAM_DIM, func(i : Nat) : Float {
      if (i < params.size()) {
        params[i] * 0.01 * (1.0 - task.currentAccuracy)
      } else {
        0.0
      }
    })
  };
  
  /// Compute outer loop gradients
  func computeOuterGradients(adaptedParams : [Float], metaParams : [Float], task : LearningTask) : [Float] {
    // Simplified outer gradient computation
    Array.tabulate<Float>(MAX_PARAM_DIM, func(i : Nat) : Float {
      if (i < adaptedParams.size() and i < metaParams.size()) {
        (adaptedParams[i] - metaParams[i]) * 0.1
      } else {
        0.0
      }
    })
  };
  
  /// Compute gradient norm
  func computeGradientNorm(gradients : [Float]) : Float {
    var sumSq : Float = 0.0;
    for (g in gradients.vals()) {
      sumSq += g * g;
    };
    Float.sqrt(sumSq)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: CURRICULUM LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update curriculum state
  public func updateCurriculum(state : MetaLearningState, beat : Int) : () {
    let curriculum = state.curriculum;
    
    // Update phase based on progress
    let completionRate = Float.fromInt(curriculum.completedTasks.size()) / 
                         Float.fromInt(Nat.max(1, curriculum.completedTasks.size() + curriculum.failedTasks.size() + (state.activeTasks.size())));
    
    switch (curriculum.currentPhase) {
      case (#Warmup) {
        if (curriculum.completedTasks.size() >= 5) {
          curriculum.currentPhase := #Progressive;
          curriculum.difficultyLevel := 0.2;
        };
      };
      case (#Progressive) {
        if (completionRate > 0.8) {
          curriculum.difficultyLevel := Float.min(1.0, curriculum.difficultyLevel + 0.1);
        };
        if (curriculum.difficultyLevel >= 0.8) {
          curriculum.currentPhase := #Mixed;
        };
      };
      case (#Mixed) {
        if (completionRate > 0.9) {
          curriculum.currentPhase := #Challenging;
        };
      };
      case (#Challenging) {
        if (curriculum.failedTasks.size() > 3) {
          curriculum.currentPhase := #Review;
        };
      };
      case (#Review) {
        if (curriculum.failedTasks.size() == 0) {
          curriculum.currentPhase := #Mastery;
        };
      };
      case (#Mastery) {
        // Stay in mastery
      };
    };
    
    // Reorder tasks based on difficulty
    reorderTasksByCurriculum(state);
  };
  
  /// Reorder tasks based on curriculum
  func reorderTasksByCurriculum(state : MetaLearningState) : () {
    let curriculum = state.curriculum;
    
    // Collect pending tasks
    var pendingTasks : [(Nat64, Float)] = [];
    for (task in state.tasks.vals()) {
      if (task.state == #Pending) {
        let difficultyScore = difficultyToScore(task.difficulty);
        pendingTasks := Array.append(pendingTasks, [(task.taskId, difficultyScore)]);
      };
    };
    
    // Sort by target difficulty based on phase
    let targetDifficulty = curriculum.difficultyLevel;
    pendingTasks := Array.sort(pendingTasks, func(a : (Nat64, Float), b : (Nat64, Float)) : { #less; #equal; #greater } {
      let distA = Float.abs(a.1 - targetDifficulty);
      let distB = Float.abs(b.1 - targetDifficulty);
      if (distA < distB) { #less } else if (distA > distB) { #greater } else { #equal }
    });
    
    // Update task order
    curriculum.taskOrder := Array.map(pendingTasks, func(t : (Nat64, Float)) : Nat64 { t.0 });
  };
  
  /// Convert difficulty to score
  func difficultyToScore(difficulty : TaskDifficulty) : Float {
    switch (difficulty) {
      case (#Trivial) { 0.0 };
      case (#Easy) { 0.25 };
      case (#Medium) { 0.5 };
      case (#Hard) { 0.75 };
      case (#VeryHard) { 1.0 };
      case (#Unknown) { 0.5 };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main meta-learning heartbeat
  public func heartbeatUpdate(state : MetaLearningState, beat : Int) : MetaLearningHeartbeatResult {
    state.currentBeat := beat;
    
    // 1. Update curriculum
    updateCurriculum(state, beat);
    
    // 2. Get next task to train
    let nextTaskId = getNextCurriculumTask(state);
    
    // 3. Update meta-learner statistics
    updateMetaLearnerStats(state);
    
    {
      beat = beat;
      activeTaskCount = state.activeTasks.size();
      completedTaskCount = state.totalTasksCompleted;
      knowledgeBaseSize = state.knowledgeBase.size();
      currentCurriculumPhase = state.curriculum.currentPhase;
      difficultyLevel = state.curriculum.difficultyLevel;
      overallSuccessRate = state.overallSuccessRate;
      averageLearningSpeed = state.averageLearningSpeed;
      adaptiveLearningRate = state.metaLearner.adaptiveLR;
      nextSuggestedTask = nextTaskId;
    }
  };
  
  /// Meta-learning heartbeat result
  public type MetaLearningHeartbeatResult = {
    beat : Int;
    activeTaskCount : Nat;
    completedTaskCount : Nat;
    knowledgeBaseSize : Nat;
    currentCurriculumPhase : CurriculumPhase;
    difficultyLevel : Float;
    overallSuccessRate : Float;
    averageLearningSpeed : Float;
    adaptiveLearningRate : Float;
    nextSuggestedTask : ?Nat64;
  };
  
  /// Get next task from curriculum
  func getNextCurriculumTask(state : MetaLearningState) : ?Nat64 {
    let curriculum = state.curriculum;
    
    if (curriculum.currentTaskIndex < curriculum.taskOrder.size()) {
      let taskId = curriculum.taskOrder[curriculum.currentTaskIndex];
      curriculum.currentTaskIndex += 1;
      ?taskId
    } else {
      // No more tasks in curriculum, get any pending task
      for (task in state.tasks.vals()) {
        if (task.state == #Pending) {
          return ?task.taskId;
        };
      };
      null
    }
  };
  
  /// Update meta-learner statistics
  func updateMetaLearnerStats(state : MetaLearningState) : () {
    let meta = state.metaLearner;
    
    // Update generalization score based on train-test gap
    meta.generalizationScore := Float.max(S_ZERO_FLOOR, 1.0 - meta.trainTestGap);
    
    // Update overfitting score
    if (meta.movingAverageLoss < 0.1 and meta.trainTestGap > 0.2) {
      meta.overfittingScore := Float.min(1.0, meta.overfittingScore + 0.1);
    } else {
      meta.overfittingScore := Float.max(0.0, meta.overfittingScore - 0.05);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get active task count
  public func getActiveTaskCount(state : MetaLearningState) : Nat {
    state.activeTasks.size()
  };
  
  /// Get knowledge base size
  public func getKnowledgeBaseSize(state : MetaLearningState) : Nat {
    state.knowledgeBase.size()
  };
  
  /// Get overall success rate
  public func getOverallSuccessRate(state : MetaLearningState) : Float {
    state.overallSuccessRate
  };
  
  /// Get current curriculum phase
  public func getCurrentCurriculumPhase(state : MetaLearningState) : CurriculumPhase {
    state.curriculum.currentPhase
  };
  
  /// Get adaptive learning rate
  public func getAdaptiveLearningRate(state : MetaLearningState) : Float {
    state.metaLearner.adaptiveLR
  };
  
  /// Get total tasks completed
  public func getTotalTasksCompleted(state : MetaLearningState) : Nat {
    state.totalTasksCompleted
  };
  
  /// Get strategy count
  public func getStrategyCount(state : MetaLearningState) : Nat {
    state.strategies.size()
  };
  
  /// Get best strategy for category
  public func getBestStrategyForCategory(state : MetaLearningState, category : TaskCategory) : ?Nat64 {
    var bestStrategyId : ?Nat64 = null;
    var bestAffinity : Float = 0.0;
    
    for (strategy in state.strategies.vals()) {
      for ((cat, aff) in strategy.categoryAffinity.vals()) {
        if (cat == category and aff > bestAffinity) {
          bestAffinity := aff;
          bestStrategyId := ?strategy.strategyId;
        };
      };
    };
    
    bestStrategyId
  };
  
  /// Get generalization score
  public func getGeneralizationScore(state : MetaLearningState) : Float {
    state.metaLearner.generalizationScore
  };

}
