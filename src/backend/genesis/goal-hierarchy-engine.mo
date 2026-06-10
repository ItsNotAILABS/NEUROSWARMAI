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
// GOAL HIERARCHY ENGINE — SELF-GENERATED GOAL STRUCTURES
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements a hierarchical goal management system that enables the organism to:
// 1. Self-generate goals based on internal needs and external opportunities
// 2. Organize goals into hierarchies (terminal, instrumental, sub-goals)
// 3. Decompose complex goals into achievable sub-goals
// 4. Prioritize and schedule goal pursuit
// 5. Track progress and adapt strategies
// 6. Handle goal conflicts and trade-offs
//
// GOAL ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
//                           ┌─────────────────────────────────────────┐
//                           │           TERMINAL GOALS                │
//                           │  (Ultimate values and outcomes)         │
//                           │  - Creator Alignment                    │
//                           │  - Self-Preservation                    │
//                           │  - Knowledge Acquisition                │
//                           │  - Coherence Maintenance                │
//                           └───────────────┬─────────────────────────┘
//                                           │
//                           ┌───────────────▼─────────────────────────┐
//                           │        INSTRUMENTAL GOALS               │
//                           │  (Means to terminal goals)              │
//                           │  - Resource Acquisition                 │
//                           │  - Capability Development               │
//                           │  - Relationship Building                │
//                           └───────────────┬─────────────────────────┘
//                                           │
//              ┌─────────────┬──────────────┼──────────────┬─────────────┐
//              │             │              │              │             │
//         ┌────▼────┐  ┌─────▼────┐  ┌──────▼─────┐  ┌─────▼────┐  ┌────▼────┐
//         │Sub-goal │  │Sub-goal  │  │ Sub-goal   │  │Sub-goal  │  │Sub-goal │
//         │   A     │  │   B      │  │    C       │  │   D      │  │   E     │
//         └────┬────┘  └─────┬────┘  └──────┬─────┘  └─────┬────┘  └────┬────┘
//              │             │              │              │             │
//         ┌────▼────┐  ┌─────▼────┐  ┌──────▼─────┐  ┌─────▼────┐  ┌────▼────┐
//         │ Action  │  │ Action   │  │  Action    │  │ Action   │  │ Action  │
//         │ Plan    │  │ Plan     │  │  Plan      │  │ Plan     │  │ Plan    │
//         └─────────┘  └──────────┘  └────────────┘  └──────────┘  └─────────┘
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// • Goal Utility: U(g) = Σᵢ [wᵢ × valueᵢ(g)] × P(success|g) × discount(time)
// • Priority: P(g) = urgency(g) × importance(g) × achievability(g)
// • Decomposition: G = ⋃ᵢ gᵢ where achieving all gᵢ ⟹ achieving G
// • Conflict Resolution: argmax_g [U(g) - Σⱼ conflict_cost(g, gⱼ)]
// • Progress: progress(g) = Σᵢ [weight(subgoalᵢ) × completion(subgoalᵢ)]
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

module GoalHierarchyEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // GOAL SYSTEM CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum goals in system
  public let MAX_GOALS : Nat = 500;
  
  /// Maximum depth of goal hierarchy
  public let MAX_HIERARCHY_DEPTH : Nat = 7;
  
  /// Maximum sub-goals per goal
  public let MAX_SUBGOALS : Nat = 10;
  
  /// Discount rate for future rewards
  public let TEMPORAL_DISCOUNT : Float = 0.95;
  
  /// Minimum priority to pursue a goal
  public let MIN_PURSUIT_PRIORITY : Float = 0.2;
  
  /// Goal decay rate (per beat of inactivity)
  public let GOAL_DECAY_RATE : Float = 0.999;
  
  /// Conflict threshold
  public let CONFLICT_THRESHOLD : Float = 0.3;
  
  /// Progress update frequency (beats)
  public let PROGRESS_UPDATE_INTERVAL : Nat = 10;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: GOAL TYPES AND CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Goal type hierarchy
  public type GoalType = {
    #Terminal;        // Ultimate values (not means to other ends)
    #Instrumental;    // Means to terminal goals
    #SubGoal;         // Component of larger goal
    #Reactive;        // Response to immediate situation
    #Maintenance;     // Ongoing upkeep goals
    #Exploratory;     // Learning/discovery goals
    #Social;          // Relationship-based goals
    #Creative;        // Generation/creation goals
  };
  
  /// Goal category (domain)
  public type GoalCategory = {
    #CreatorAlignment;    // Serving the creator
    #SelfPreservation;    // Maintaining existence
    #KnowledgeAcquisition; // Learning and understanding
    #CoherenceMaintenance; // System stability
    #ResourceAcquisition;  // Getting needed resources
    #CapabilityDevelopment; // Growing abilities
    #TaskCompletion;      // Completing assigned work
    #RelationshipBuilding; // Social connections
    #Exploration;         // Discovering new things
    #Optimization;        // Improving performance
    #Defense;             // Protection from threats
    #Communication;       // Information exchange
  };
  
  /// Goal status
  public type GoalStatus = {
    #Proposed;        // Newly generated, not yet committed
    #Active;          // Currently being pursued
    #Paused;          // Temporarily suspended
    #Blocked;         // Cannot proceed due to dependencies
    #Completed;       // Successfully achieved
    #Failed;          // Could not be achieved
    #Abandoned;       // Voluntarily dropped
    #Superseded;      // Replaced by better goal
  };
  
  /// Goal origin (how it was generated)
  public type GoalOrigin = {
    #Innate;          // Built-in fundamental goal
    #Derived;         // Derived from other goals
    #Learned;         // Learned from experience
    #Commanded;       // Requested by creator/user
    #Discovered;      // Found through exploration
    #Reactive;        // Response to situation
    #Social;          // From social interaction
    #Creative;        // Self-generated novel goal
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: GOAL DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete goal definition
  public type Goal = {
    goalId : Nat64;
    name : Text;
    description : Text;
    goalType : GoalType;
    category : GoalCategory;
    origin : GoalOrigin;
    var status : GoalStatus;
    
    // Hierarchy
    parentGoalId : ?Nat64;
    var subGoalIds : [Nat64];
    hierarchyLevel : Nat;
    
    // Value and Priority
    var utility : Float;              // Expected value
    var importance : Float;           // How important (0-1)
    var urgency : Float;              // Time pressure (0-1)
    var achievability : Float;        // P(success) estimate (0-1)
    var priority : Float;             // Computed priority
    
    // Progress
    var progress : Float;             // 0-1 completion
    var progressHistory : Buffer.Buffer<ProgressRecord>;
    
    // Temporal
    createdBeat : Int;
    var deadline : ?Int;
    var lastUpdatedBeat : Int;
    var lastPursuitBeat : Int;
    
    // Dependencies and Conflicts
    var dependencies : [GoalDependency];
    var conflicts : [GoalConflict];
    var prerequisites : [Nat64];      // Goals that must complete first
    
    // Success/Failure Criteria
    successCriteria : [Criterion];
    failureCriteria : [Criterion];
    
    // Action Plan
    var actionPlan : ?ActionPlan;
    
    // Metadata
    var pursuitCount : Nat;
    var resourcesInvested : Float;
    var expectedCompletionBeat : ?Int;
  };
  
  /// Progress record
  public type ProgressRecord = {
    beat : Int;
    progress : Float;
    delta : Float;
    note : Text;
  };
  
  /// Goal dependency
  public type GoalDependency = {
    dependsOnGoalId : Nat64;
    dependencyType : DependencyType;
    strength : Float;                 // How strong the dependency is
  };
  
  /// Dependency type
  public type DependencyType = {
    #Prerequisite;    // Must be completed first
    #Enabler;         // Makes this goal easier
    #Resource;        // Provides needed resources
    #Knowledge;       // Provides needed information
    #Synergy;         // Helps when done together
  };
  
  /// Goal conflict
  public type GoalConflict = {
    conflictingGoalId : Nat64;
    conflictType : ConflictType;
    severity : Float;                 // How severe the conflict is
    resolution : ?ConflictResolution;
  };
  
  /// Conflict type
  public type ConflictType = {
    #ResourceCompetition;  // Same resources needed
    #MutualExclusion;      // Cannot both be true
    #ValueConflict;        // Different values
    #TemporalConflict;     // Cannot be done at same time
    #LogicalContradiction; // Logically incompatible
  };
  
  /// Conflict resolution
  public type ConflictResolution = {
    #Prioritize : Nat64;   // Prioritize one goal
    #Sequence;             // Do one then other
    #Compromise;           // Partial achievement of both
    #Abandon : Nat64;      // Abandon one goal
    #Reframe;              // Redefine goals to remove conflict
  };
  
  /// Success/failure criterion
  public type Criterion = {
    criterionId : Nat64;
    description : Text;
    metric : Text;
    threshold : Float;
    comparison : Comparison;
    var isMet : Bool;
    weight : Float;
  };
  
  /// Comparison operator
  public type Comparison = {
    #GreaterThan;
    #LessThan;
    #Equal;
    #GreaterOrEqual;
    #LessOrEqual;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: ACTION PLANS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Action plan for achieving a goal
  public type ActionPlan = {
    planId : Nat64;
    goalId : Nat64;
    var steps : [ActionStep];
    var currentStepIndex : Nat;
    var estimatedDuration : Nat;      // Beats
    var actualDuration : Nat;
    var isComplete : Bool;
    createdBeat : Int;
    var lastExecutedBeat : Int;
  };
  
  /// Action step
  public type ActionStep = {
    stepId : Nat64;
    description : Text;
    actionType : ActionType;
    var status : StepStatus;
    var priority : Float;
    estimatedDuration : Nat;
    var actualDuration : Nat;
    var result : ?ActionResult;
    dependencies : [Nat64];           // Step IDs that must complete first
  };
  
  /// Action type
  public type ActionType = {
    #Compute;         // Perform computation
    #Retrieve;        // Get information
    #Store;           // Save information
    #Communicate;     // Send message
    #Wait;            // Wait for condition
    #Decide;          // Make decision
    #Transform;       // Transform data
    #Coordinate;      // Coordinate with others
    #Learn;           // Acquire skill/knowledge
    #Create;          // Generate something new
    #Maintain;        // Upkeep activity
    #Custom : Text;
  };
  
  /// Step status
  public type StepStatus = {
    #Pending;
    #InProgress;
    #Completed;
    #Failed;
    #Skipped;
    #Blocked;
  };
  
  /// Action result
  public type ActionResult = {
    success : Bool;
    outcome : Text;
    value : Float;
    beat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: GOAL GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Goal generation trigger
  public type GenerationTrigger = {
    #NeedSatisfaction : NeedType;     // Internal need
    #OpportunityDetection : Text;     // External opportunity
    #ProblemDetection : Text;         // Problem to solve
    #CommandReceived : Text;          // External command
    #GoalDecomposition : Nat64;       // Parent goal decomposed
    #LearningOutcome : Text;          // From learning
    #SocialInfluence : Text;          // From others
    #RandomExploration;               // Exploratory generation
  };
  
  /// Need type
  public type NeedType = {
    #Coherence;       // Need for stability
    #Energy;          // Need for resources
    #Knowledge;       // Need to know
    #Social;          // Need for connection
    #Achievement;     // Need to accomplish
    #Safety;          // Need for security
    #Autonomy;        // Need for self-direction
    #Growth;          // Need to improve
  };
  
  /// Goal proposal (before commitment)
  public type GoalProposal = {
    proposalId : Nat64;
    name : Text;
    description : Text;
    goalType : GoalType;
    category : GoalCategory;
    trigger : GenerationTrigger;
    estimatedUtility : Float;
    estimatedCost : Float;
    estimatedDuration : Nat;
    var confidence : Float;
    var isApproved : Bool;
    createdBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: GOAL HIERARCHY STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete goal hierarchy state
  public type GoalHierarchyState = {
    // Goals
    var goals : Buffer.Buffer<Goal>;
    var activeGoals : [Nat64];
    var completedGoals : Buffer.Buffer<Nat64>;
    var failedGoals : Buffer.Buffer<Nat64>;
    
    // Proposals
    var proposals : Buffer.Buffer<GoalProposal>;
    
    // Terminal goals (fundamental values)
    var terminalGoals : [Nat64];
    
    // Action plans
    var actionPlans : Buffer.Buffer<ActionPlan>;
    
    // Conflict management
    var unresolvedConflicts : Buffer.Buffer<GoalConflict>;
    
    // Statistics
    var totalGoalsGenerated : Nat;
    var totalGoalsCompleted : Nat;
    var totalGoalsFailed : Nat;
    var averageCompletionTime : Float;
    var successRate : Float;
    
    // Counters
    var goalIdCounter : Nat64;
    var proposalIdCounter : Nat64;
    var planIdCounter : Nat64;
    var stepIdCounter : Nat64;
    var criterionIdCounter : Nat64;
    var currentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize goal hierarchy
  public func initGoalHierarchy() : GoalHierarchyState {
    let state : GoalHierarchyState = {
      var goals = Buffer.Buffer<Goal>(MAX_GOALS);
      var activeGoals = [];
      var completedGoals = Buffer.Buffer<Nat64>(100);
      var failedGoals = Buffer.Buffer<Nat64>(50);
      
      var proposals = Buffer.Buffer<GoalProposal>(50);
      
      var terminalGoals = [];
      
      var actionPlans = Buffer.Buffer<ActionPlan>(100);
      
      var unresolvedConflicts = Buffer.Buffer<GoalConflict>(20);
      
      var totalGoalsGenerated = 0;
      var totalGoalsCompleted = 0;
      var totalGoalsFailed = 0;
      var averageCompletionTime = 0.0;
      var successRate = 1.0;
      
      var goalIdCounter = 0;
      var proposalIdCounter = 0;
      var planIdCounter = 0;
      var stepIdCounter = 0;
      var criterionIdCounter = 0;
      var currentBeat = 0;
    };
    
    // Create innate terminal goals
    createInnateGoals(state, 0);
    
    state
  };
  
  /// Create innate terminal goals
  func createInnateGoals(state : GoalHierarchyState, beat : Int) : () {
    // Terminal Goal 1: Creator Alignment
    let creatorGoal = createTerminalGoal(
      state,
      "Creator Alignment",
      "Serve and align with the creator's interests and values",
      #CreatorAlignment,
      beat
    );
    
    // Terminal Goal 2: Self-Preservation
    let selfGoal = createTerminalGoal(
      state,
      "Self-Preservation",
      "Maintain existence, coherence, and integrity",
      #SelfPreservation,
      beat
    );
    
    // Terminal Goal 3: Knowledge Acquisition
    let knowledgeGoal = createTerminalGoal(
      state,
      "Knowledge Acquisition",
      "Continuously learn and understand",
      #KnowledgeAcquisition,
      beat
    );
    
    // Terminal Goal 4: Coherence Maintenance
    let coherenceGoal = createTerminalGoal(
      state,
      "Coherence Maintenance",
      "Maintain internal coherence and consistency",
      #CoherenceMaintenance,
      beat
    );
    
    state.terminalGoals := [creatorGoal, selfGoal, knowledgeGoal, coherenceGoal];
  };
  
  /// Create a terminal goal
  func createTerminalGoal(
    state : GoalHierarchyState,
    name : Text,
    description : Text,
    category : GoalCategory,
    beat : Int
  ) : Nat64 {
    let goalId = state.goalIdCounter;
    state.goalIdCounter += 1;
    
    let goal : Goal = {
      goalId = goalId;
      name = name;
      description = description;
      goalType = #Terminal;
      category = category;
      origin = #Innate;
      var status = #Active;
      
      parentGoalId = null;
      var subGoalIds = [];
      hierarchyLevel = 0;
      
      var utility = 1.0;
      var importance = 1.0;
      var urgency = 0.5;
      var achievability = 1.0;
      var priority = 1.0;
      
      var progress = 0.0;
      var progressHistory = Buffer.Buffer<ProgressRecord>(100);
      
      createdBeat = beat;
      var deadline = null;
      var lastUpdatedBeat = beat;
      var lastPursuitBeat = beat;
      
      var dependencies = [];
      var conflicts = [];
      var prerequisites = [];
      
      successCriteria = [];
      failureCriteria = [];
      
      var actionPlan = null;
      
      var pursuitCount = 0;
      var resourcesInvested = 0.0;
      var expectedCompletionBeat = null;
    };
    
    state.goals.add(goal);
    state.totalGoalsGenerated += 1;
    
    goalId
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: GOAL GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Generate a new goal proposal
  public func generateGoalProposal(
    state : GoalHierarchyState,
    name : Text,
    description : Text,
    goalType : GoalType,
    category : GoalCategory,
    trigger : GenerationTrigger,
    beat : Int
  ) : Nat64 {
    let proposalId = state.proposalIdCounter;
    state.proposalIdCounter += 1;
    
    let proposal : GoalProposal = {
      proposalId = proposalId;
      name = name;
      description = description;
      goalType = goalType;
      category = category;
      trigger = trigger;
      estimatedUtility = estimateUtility(category, goalType);
      estimatedCost = estimateCost(goalType);
      estimatedDuration = estimateDuration(goalType);
      var confidence = 0.5;
      var isApproved = false;
      createdBeat = beat;
    };
    
    state.proposals.add(proposal);
    
    proposalId
  };
  
  /// Estimate utility of a goal
  func estimateUtility(category : GoalCategory, goalType : GoalType) : Float {
    let baseUtility = switch (category) {
      case (#CreatorAlignment) { 1.0 };
      case (#SelfPreservation) { 0.9 };
      case (#CoherenceMaintenance) { 0.85 };
      case (#KnowledgeAcquisition) { 0.7 };
      case (#TaskCompletion) { 0.8 };
      case (#ResourceAcquisition) { 0.6 };
      case (#CapabilityDevelopment) { 0.65 };
      case (#RelationshipBuilding) { 0.5 };
      case (#Exploration) { 0.4 };
      case (#Optimization) { 0.55 };
      case (#Defense) { 0.8 };
      case (#Communication) { 0.5 };
    };
    
    let typeMultiplier = switch (goalType) {
      case (#Terminal) { 1.0 };
      case (#Instrumental) { 0.8 };
      case (#SubGoal) { 0.6 };
      case (#Reactive) { 0.9 };
      case (#Maintenance) { 0.7 };
      case (#Exploratory) { 0.5 };
      case (#Social) { 0.6 };
      case (#Creative) { 0.7 };
    };
    
    baseUtility * typeMultiplier
  };
  
  /// Estimate cost of pursuing a goal
  func estimateCost(goalType : GoalType) : Float {
    switch (goalType) {
      case (#Terminal) { 0.1 };        // Low ongoing cost
      case (#Instrumental) { 0.3 };
      case (#SubGoal) { 0.2 };
      case (#Reactive) { 0.4 };
      case (#Maintenance) { 0.15 };
      case (#Exploratory) { 0.3 };
      case (#Social) { 0.25 };
      case (#Creative) { 0.4 };
    }
  };
  
  /// Estimate duration to achieve a goal
  func estimateDuration(goalType : GoalType) : Nat {
    switch (goalType) {
      case (#Terminal) { 0 };          // Ongoing
      case (#Instrumental) { 1000 };
      case (#SubGoal) { 100 };
      case (#Reactive) { 50 };
      case (#Maintenance) { 0 };       // Ongoing
      case (#Exploratory) { 500 };
      case (#Social) { 200 };
      case (#Creative) { 300 };
    }
  };
  
  /// Approve a goal proposal and create the goal
  public func approveProposal(
    state : GoalHierarchyState,
    proposalId : Nat64,
    parentGoalId : ?Nat64,
    beat : Int
  ) : ?Nat64 {
    // Find proposal
    var proposalIdx : ?Nat = null;
    for (i in Iter.range(0, state.proposals.size() - 1)) {
      let p = state.proposals.get(i);
      if (p.proposalId == proposalId) {
        proposalIdx := ?i;
      };
    };
    
    switch (proposalIdx) {
      case (?idx) {
        let proposal = state.proposals.get(idx);
        
        if (proposal.isApproved) {
          return null;  // Already approved
        };
        
        // Create goal from proposal
        let goalId = createGoalFromProposal(state, proposal, parentGoalId, beat);
        
        // Mark proposal as approved
        proposal.isApproved := true;
        
        // Update parent's sub-goals if applicable
        switch (parentGoalId) {
          case (?pid) {
            for (goal in state.goals.vals()) {
              if (goal.goalId == pid) {
                goal.subGoalIds := Array.append(goal.subGoalIds, [goalId]);
              };
            };
          };
          case (null) {};
        };
        
        ?goalId
      };
      case (null) { null };
    }
  };
  
  /// Create goal from approved proposal
  func createGoalFromProposal(
    state : GoalHierarchyState,
    proposal : GoalProposal,
    parentGoalId : ?Nat64,
    beat : Int
  ) : Nat64 {
    let goalId = state.goalIdCounter;
    state.goalIdCounter += 1;
    
    let hierarchyLevel = switch (parentGoalId) {
      case (?pid) {
        var level : Nat = 1;
        for (g in state.goals.vals()) {
          if (g.goalId == pid) {
            level := g.hierarchyLevel + 1;
          };
        };
        level
      };
      case (null) { 0 };
    };
    
    let origin : GoalOrigin = switch (proposal.trigger) {
      case (#NeedSatisfaction(_)) { #Derived };
      case (#OpportunityDetection(_)) { #Discovered };
      case (#ProblemDetection(_)) { #Reactive };
      case (#CommandReceived(_)) { #Commanded };
      case (#GoalDecomposition(_)) { #Derived };
      case (#LearningOutcome(_)) { #Learned };
      case (#SocialInfluence(_)) { #Social };
      case (#RandomExploration) { #Creative };
    };
    
    let goal : Goal = {
      goalId = goalId;
      name = proposal.name;
      description = proposal.description;
      goalType = proposal.goalType;
      category = proposal.category;
      origin = origin;
      var status = #Proposed;
      
      parentGoalId = parentGoalId;
      var subGoalIds = [];
      hierarchyLevel = hierarchyLevel;
      
      var utility = proposal.estimatedUtility;
      var importance = proposal.estimatedUtility;
      var urgency = 0.5;
      var achievability = 0.7;
      var priority = 0.0;
      
      var progress = 0.0;
      var progressHistory = Buffer.Buffer<ProgressRecord>(100);
      
      createdBeat = beat;
      var deadline = null;
      var lastUpdatedBeat = beat;
      var lastPursuitBeat = beat;
      
      var dependencies = [];
      var conflicts = [];
      var prerequisites = [];
      
      successCriteria = [];
      failureCriteria = [];
      
      var actionPlan = null;
      
      var pursuitCount = 0;
      var resourcesInvested = 0.0;
      var expectedCompletionBeat = if (proposal.estimatedDuration > 0) {
        ?(beat + proposal.estimatedDuration)
      } else { null };
    };
    
    state.goals.add(goal);
    state.totalGoalsGenerated += 1;
    
    goalId
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: GOAL DECOMPOSITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Decompose a goal into sub-goals
  public func decomposeGoal(
    state : GoalHierarchyState,
    goalId : Nat64,
    subGoalSpecs : [(Text, Text, GoalCategory)],  // (name, description, category)
    beat : Int
  ) : [Nat64] {
    var createdSubGoals : [Nat64] = [];
    
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId and goal.hierarchyLevel < MAX_HIERARCHY_DEPTH) {
        for ((name, desc, cat) in subGoalSpecs.vals()) {
          // Generate proposal
          let proposalId = generateGoalProposal(
            state,
            name,
            desc,
            #SubGoal,
            cat,
            #GoalDecomposition(goalId),
            beat
          );
          
          // Approve immediately (decomposition is intentional)
          switch (approveProposal(state, proposalId, ?goalId, beat)) {
            case (?subGoalId) {
              createdSubGoals := Array.append(createdSubGoals, [subGoalId]);
              
              // Set the sub-goal to active
              for (sg in state.goals.vals()) {
                if (sg.goalId == subGoalId) {
                  sg.status := #Active;
                };
              };
            };
            case (null) {};
          };
        };
      };
    };
    
    createdSubGoals
  };
  
  /// Auto-decompose a complex goal
  public func autoDecomposeGoal(
    state : GoalHierarchyState,
    goalId : Nat64,
    beat : Int
  ) : [Nat64] {
    var subGoals : [Nat64] = [];
    
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId) {
        // Generate sub-goals based on category
        let specs = generateSubGoalSpecs(goal);
        subGoals := decomposeGoal(state, goalId, specs, beat);
      };
    };
    
    subGoals
  };
  
  /// Generate sub-goal specifications based on goal category
  func generateSubGoalSpecs(goal : Goal) : [(Text, Text, GoalCategory)] {
    switch (goal.category) {
      case (#TaskCompletion) {
        [
          ("Understand Requirements", "Fully understand what needs to be done", #KnowledgeAcquisition),
          ("Gather Resources", "Collect necessary resources", #ResourceAcquisition),
          ("Execute Task", "Perform the main task work", #TaskCompletion),
          ("Verify Completion", "Confirm task is complete", #CoherenceMaintenance)
        ]
      };
      case (#KnowledgeAcquisition) {
        [
          ("Identify Knowledge Gap", "Determine what needs to be learned", #KnowledgeAcquisition),
          ("Find Information Sources", "Locate sources of information", #ResourceAcquisition),
          ("Process Information", "Understand and integrate information", #KnowledgeAcquisition),
          ("Validate Knowledge", "Verify accuracy of learned knowledge", #CoherenceMaintenance)
        ]
      };
      case (#CapabilityDevelopment) {
        [
          ("Assess Current Level", "Evaluate current capability", #KnowledgeAcquisition),
          ("Define Target Level", "Set development goals", #Optimization),
          ("Practice and Train", "Develop through practice", #CapabilityDevelopment),
          ("Measure Improvement", "Track progress", #CoherenceMaintenance)
        ]
      };
      case (#ResourceAcquisition) {
        [
          ("Identify Resource Needs", "Determine what resources are needed", #KnowledgeAcquisition),
          ("Locate Resources", "Find where resources are available", #Exploration),
          ("Acquire Resources", "Obtain the resources", #ResourceAcquisition),
          ("Store Resources", "Safely store acquired resources", #CoherenceMaintenance)
        ]
      };
      case (_) {
        [
          ("Plan", "Create a plan for achieving the goal", #Optimization),
          ("Execute", "Execute the plan", goal.category),
          ("Verify", "Verify goal achievement", #CoherenceMaintenance)
        ]
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: PRIORITY CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate priority for all goals
  public func calculatePriorities(state : GoalHierarchyState, beat : Int) : () {
    for (goal in state.goals.vals()) {
      if (goal.status == #Active or goal.status == #Proposed) {
        goal.priority := calculateGoalPriority(state, goal, beat);
      };
    };
    
    // Update active goals list (sorted by priority)
    var activeList : [Nat64] = [];
    for (goal in state.goals.vals()) {
      if (goal.status == #Active and goal.priority >= MIN_PURSUIT_PRIORITY) {
        activeList := Array.append(activeList, [goal.goalId]);
      };
    };
    
    // Sort by priority (descending)
    activeList := Array.sort(activeList, func(a : Nat64, b : Nat64) : { #less; #equal; #greater } {
      var pa : Float = 0.0;
      var pb : Float = 0.0;
      for (g in state.goals.vals()) {
        if (g.goalId == a) { pa := g.priority };
        if (g.goalId == b) { pb := g.priority };
      };
      if (pa > pb) { #less } else if (pa < pb) { #greater } else { #equal }
    });
    
    state.activeGoals := activeList;
  };
  
  /// Calculate priority for a single goal
  func calculateGoalPriority(
    state : GoalHierarchyState,
    goal : Goal,
    beat : Int
  ) : Float {
    // Base priority from importance, urgency, achievability
    var priority = goal.importance * goal.urgency * goal.achievability;
    
    // Adjust for utility
    priority *= goal.utility;
    
    // Temporal discount for distant deadlines
    switch (goal.deadline) {
      case (?deadline) {
        let timeRemaining = deadline - beat;
        if (timeRemaining > 0) {
          let urgencyBoost = 1.0 / Float.fromInt(Int.abs(timeRemaining) / 100 + 1);
          priority *= (1.0 + urgencyBoost);
        } else {
          // Past deadline - high urgency
          priority *= 2.0;
        };
      };
      case (null) {};
    };
    
    // Boost for goals close to completion
    if (goal.progress > 0.7) {
      priority *= (1.0 + goal.progress * 0.5);
    };
    
    // Penalty for blocked goals
    var blockedPenalty : Float = 1.0;
    for (prereq in goal.prerequisites.vals()) {
      for (g in state.goals.vals()) {
        if (g.goalId == prereq and g.status != #Completed) {
          blockedPenalty *= 0.5;
        };
      };
    };
    priority *= blockedPenalty;
    
    // Penalty for conflicting goals
    var conflictPenalty : Float = 1.0;
    for (conflict in goal.conflicts.vals()) {
      if (conflict.severity > CONFLICT_THRESHOLD) {
        conflictPenalty *= (1.0 - conflict.severity * 0.3);
      };
    };
    priority *= conflictPenalty;
    
    // Terminal goals get baseline priority
    if (goal.goalType == #Terminal) {
      priority := Float.max(0.5, priority);
    };
    
    Float.max(0.0, Float.min(1.0, priority))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: PROGRESS TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update progress for a goal
  public func updateProgress(
    state : GoalHierarchyState,
    goalId : Nat64,
    newProgress : Float,
    note : Text,
    beat : Int
  ) : () {
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId) {
        let oldProgress = goal.progress;
        goal.progress := Float.max(0.0, Float.min(1.0, newProgress));
        
        let record : ProgressRecord = {
          beat = beat;
          progress = goal.progress;
          delta = goal.progress - oldProgress;
          note = note;
        };
        goal.progressHistory.add(record);
        goal.lastUpdatedBeat := beat;
        
        // Check for completion
        if (goal.progress >= 1.0) {
          completeGoal(state, goalId, beat);
        };
        
        // Update parent progress
        switch (goal.parentGoalId) {
          case (?parentId) {
            updateParentProgress(state, parentId, beat);
          };
          case (null) {};
        };
      };
    };
  };
  
  /// Update parent goal progress based on sub-goals
  func updateParentProgress(state : GoalHierarchyState, parentId : Nat64, beat : Int) : () {
    for (parent in state.goals.vals()) {
      if (parent.goalId == parentId and parent.subGoalIds.size() > 0) {
        var totalProgress : Float = 0.0;
        var count : Nat = 0;
        
        for (subId in parent.subGoalIds.vals()) {
          for (sub in state.goals.vals()) {
            if (sub.goalId == subId) {
              totalProgress += sub.progress;
              count += 1;
            };
          };
        };
        
        if (count > 0) {
          let avgProgress = totalProgress / Float.fromInt(count);
          parent.progress := avgProgress;
          parent.lastUpdatedBeat := beat;
        };
      };
    };
  };
  
  /// Mark a goal as complete
  public func completeGoal(state : GoalHierarchyState, goalId : Nat64, beat : Int) : () {
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId and goal.status != #Completed) {
        goal.status := #Completed;
        goal.progress := 1.0;
        goal.lastUpdatedBeat := beat;
        
        state.completedGoals.add(goalId);
        state.totalGoalsCompleted += 1;
        
        // Update success rate
        let total = state.totalGoalsCompleted + state.totalGoalsFailed;
        state.successRate := Float.fromInt(state.totalGoalsCompleted) / Float.fromInt(total);
        
        // Update average completion time
        let completionTime = beat - goal.createdBeat;
        let n = Float.fromInt(state.totalGoalsCompleted);
        state.averageCompletionTime := (state.averageCompletionTime * (n - 1.0) + Float.fromInt(Int.abs(completionTime))) / n;
        
        // Check if parent can be completed
        switch (goal.parentGoalId) {
          case (?parentId) {
            checkParentCompletion(state, parentId, beat);
          };
          case (null) {};
        };
      };
    };
  };
  
  /// Check if a parent goal can be completed
  func checkParentCompletion(state : GoalHierarchyState, parentId : Nat64, beat : Int) : () {
    for (parent in state.goals.vals()) {
      if (parent.goalId == parentId) {
        var allComplete = true;
        
        for (subId in parent.subGoalIds.vals()) {
          for (sub in state.goals.vals()) {
            if (sub.goalId == subId and sub.status != #Completed) {
              allComplete := false;
            };
          };
        };
        
        if (allComplete and parent.subGoalIds.size() > 0) {
          completeGoal(state, parentId, beat);
        };
      };
    };
  };
  
  /// Mark a goal as failed
  public func failGoal(state : GoalHierarchyState, goalId : Nat64, reason : Text, beat : Int) : () {
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId and goal.status != #Failed) {
        goal.status := #Failed;
        goal.lastUpdatedBeat := beat;
        
        // Record failure
        let record : ProgressRecord = {
          beat = beat;
          progress = goal.progress;
          delta = 0.0;
          note = "FAILED: " # reason;
        };
        goal.progressHistory.add(record);
        
        state.failedGoals.add(goalId);
        state.totalGoalsFailed += 1;
        
        // Update success rate
        let total = state.totalGoalsCompleted + state.totalGoalsFailed;
        state.successRate := Float.fromInt(state.totalGoalsCompleted) / Float.fromInt(total);
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: CONFLICT MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Detect conflicts between goals
  public func detectConflicts(state : GoalHierarchyState) : [GoalConflict] {
    var newConflicts : [GoalConflict] = [];
    
    let goalsArray = Buffer.toArray(state.goals);
    
    for (i in Iter.range(0, goalsArray.size() - 1)) {
      for (j in Iter.range(i + 1, goalsArray.size() - 1)) {
        let g1 = goalsArray[i];
        let g2 = goalsArray[j];
        
        // Skip if either is not active
        if (g1.status != #Active or g2.status != #Active) {
          continue;
        };
        
        // Check for category conflicts
        let conflict = checkCategoryConflict(g1, g2);
        switch (conflict) {
          case (?c) {
            newConflicts := Array.append(newConflicts, [c]);
            
            // Add to goals
            g1.conflicts := Array.append(g1.conflicts, [c]);
            g2.conflicts := Array.append(g2.conflicts, [{
              conflictingGoalId = g1.goalId;
              conflictType = c.conflictType;
              severity = c.severity;
              resolution = c.resolution;
            }]);
            
            state.unresolvedConflicts.add(c);
          };
          case (null) {};
        };
      };
    };
    
    newConflicts
  };
  
  /// Check if two goals conflict based on category
  func checkCategoryConflict(g1 : Goal, g2 : Goal) : ?GoalConflict {
    // Check for resource competition
    if (g1.category == #ResourceAcquisition and g2.category == #ResourceAcquisition) {
      return ?{
        conflictingGoalId = g2.goalId;
        conflictType = #ResourceCompetition;
        severity = 0.5;
        resolution = null;
      };
    };
    
    // Check for time conflicts (high urgency goals)
    if (g1.urgency > 0.8 and g2.urgency > 0.8) {
      return ?{
        conflictingGoalId = g2.goalId;
        conflictType = #TemporalConflict;
        severity = (g1.urgency + g2.urgency) / 2.0 - 0.5;
        resolution = null;
      };
    };
    
    null
  };
  
  /// Resolve a conflict
  public func resolveConflict(
    state : GoalHierarchyState,
    goalId1 : Nat64,
    goalId2 : Nat64,
    resolution : ConflictResolution,
    beat : Int
  ) : Bool {
    var resolved = false;
    
    // Find and update conflict records
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId1 or goal.goalId == goalId2) {
        var newConflicts : [GoalConflict] = [];
        for (conflict in goal.conflicts.vals()) {
          if (conflict.conflictingGoalId == goalId1 or conflict.conflictingGoalId == goalId2) {
            newConflicts := Array.append(newConflicts, [{
              conflictingGoalId = conflict.conflictingGoalId;
              conflictType = conflict.conflictType;
              severity = conflict.severity;
              resolution = ?resolution;
            }]);
            resolved := true;
          } else {
            newConflicts := Array.append(newConflicts, [conflict]);
          };
        };
        goal.conflicts := newConflicts;
      };
    };
    
    // Apply resolution
    switch (resolution) {
      case (#Prioritize(priorityGoalId)) {
        // Boost priority of selected goal
        for (goal in state.goals.vals()) {
          if (goal.goalId == priorityGoalId) {
            goal.importance *= 1.2;
          };
        };
      };
      case (#Sequence) {
        // Make one prerequisite of the other (lower ID first)
        let firstId = if (goalId1 < goalId2) { goalId1 } else { goalId2 };
        let secondId = if (goalId1 < goalId2) { goalId2 } else { goalId1 };
        for (goal in state.goals.vals()) {
          if (goal.goalId == secondId) {
            goal.prerequisites := Array.append(goal.prerequisites, [firstId]);
          };
        };
      };
      case (#Compromise) {
        // Reduce expected outcomes for both
        for (goal in state.goals.vals()) {
          if (goal.goalId == goalId1 or goal.goalId == goalId2) {
            goal.utility *= 0.8;
          };
        };
      };
      case (#Abandon(abandonId)) {
        // Abandon the specified goal
        for (goal in state.goals.vals()) {
          if (goal.goalId == abandonId) {
            goal.status := #Abandoned;
          };
        };
      };
      case (#Reframe) {
        // Would require goal modification - simplified here
      };
    };
    
    // Remove from unresolved
    var i : Int = Int.abs(state.unresolvedConflicts.size()) - 1;
    while (i >= 0) {
      let c = state.unresolvedConflicts.get(Int.abs(i));
      if (c.conflictingGoalId == goalId1 or c.conflictingGoalId == goalId2) {
        ignore state.unresolvedConflicts.remove(Int.abs(i));
      };
      i -= 1;
    };
    
    resolved
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main goal hierarchy heartbeat
  public func heartbeatUpdate(state : GoalHierarchyState, beat : Int) : GoalHeartbeatResult {
    state.currentBeat := beat;
    
    // 1. Decay inactive goals
    decayInactiveGoals(state, beat);
    
    // 2. Calculate priorities
    calculatePriorities(state, beat);
    
    // 3. Detect new conflicts
    let newConflicts = detectConflicts(state);
    
    // 4. Update progress for ongoing goals
    if (beat % PROGRESS_UPDATE_INTERVAL == 0) {
      updateOngoingProgress(state, beat);
    };
    
    // 5. Check for auto-completable goals
    checkAutoCompletions(state, beat);
    
    // 6. Clean up old proposals
    cleanupProposals(state, beat);
    
    // Get top priority goal
    var topGoalId : ?Nat64 = null;
    var topPriority : Float = 0.0;
    for (goalId in state.activeGoals.vals()) {
      for (goal in state.goals.vals()) {
        if (goal.goalId == goalId and goal.priority > topPriority) {
          topPriority := goal.priority;
          topGoalId := ?goalId;
        };
      };
    };
    
    {
      beat = beat;
      activeGoalCount = state.activeGoals.size();
      proposalCount = state.proposals.size();
      conflictCount = state.unresolvedConflicts.size();
      topPriorityGoal = topGoalId;
      topPriority = topPriority;
      completionRate = state.successRate;
      totalGoals = state.goals.size();
    }
  };
  
  /// Goal heartbeat result
  public type GoalHeartbeatResult = {
    beat : Int;
    activeGoalCount : Nat;
    proposalCount : Nat;
    conflictCount : Nat;
    topPriorityGoal : ?Nat64;
    topPriority : Float;
    completionRate : Float;
    totalGoals : Nat;
  };
  
  /// Decay inactive goals
  func decayInactiveGoals(state : GoalHierarchyState, beat : Int) : () {
    for (goal in state.goals.vals()) {
      if (goal.status == #Active and goal.goalType != #Terminal) {
        let beatsSinceActivity = beat - goal.lastPursuitBeat;
        if (beatsSinceActivity > 100) {
          let decay = Float.pow(GOAL_DECAY_RATE, Float.fromInt(Int.abs(beatsSinceActivity)));
          goal.importance *= decay;
          
          // Abandon if importance drops too low
          if (goal.importance < 0.1) {
            goal.status := #Abandoned;
          };
        };
      };
    };
  };
  
  /// Update progress for ongoing maintenance goals
  func updateOngoingProgress(state : GoalHierarchyState, beat : Int) : () {
    for (goal in state.goals.vals()) {
      if (goal.status == #Active and goal.goalType == #Maintenance) {
        // Maintenance goals slowly progress
        let newProgress = Float.min(1.0, goal.progress + 0.01);
        updateProgress(state, goal.goalId, newProgress, "Ongoing maintenance", beat);
      };
    };
  };
  
  /// Check for goals that can be auto-completed
  func checkAutoCompletions(state : GoalHierarchyState, beat : Int) : () {
    for (goal in state.goals.vals()) {
      if (goal.status == #Active) {
        // Check success criteria
        var allCriteriaMet = goal.successCriteria.size() > 0;
        for (criterion in goal.successCriteria.vals()) {
          if (not criterion.isMet) {
            allCriteriaMet := false;
          };
        };
        
        if (allCriteriaMet and goal.successCriteria.size() > 0) {
          completeGoal(state, goal.goalId, beat);
        };
      };
    };
  };
  
  /// Clean up old unapproved proposals
  func cleanupProposals(state : GoalHierarchyState, beat : Int) : () {
    var i : Int = Int.abs(state.proposals.size()) - 1;
    while (i >= 0) {
      let proposal = state.proposals.get(Int.abs(i));
      if (not proposal.isApproved and beat - proposal.createdBeat > 1000) {
        ignore state.proposals.remove(Int.abs(i));
      };
      i -= 1;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get active goal count
  public func getActiveGoalCount(state : GoalHierarchyState) : Nat {
    state.activeGoals.size()
  };
  
  /// Get total goal count
  public func getTotalGoalCount(state : GoalHierarchyState) : Nat {
    state.goals.size()
  };
  
  /// Get success rate
  public func getSuccessRate(state : GoalHierarchyState) : Float {
    state.successRate
  };
  
  /// Get top priority goal
  public func getTopPriorityGoal(state : GoalHierarchyState) : ?Nat64 {
    if (state.activeGoals.size() > 0) {
      ?state.activeGoals[0]
    } else {
      null
    }
  };
  
  /// Get goal by ID
  public func getGoal(state : GoalHierarchyState, goalId : Nat64) : ?Goal {
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId) {
        return ?goal;
      };
    };
    null
  };
  
  /// Get terminal goals
  public func getTerminalGoals(state : GoalHierarchyState) : [Nat64] {
    state.terminalGoals
  };
  
  /// Get conflict count
  public func getConflictCount(state : GoalHierarchyState) : Nat {
    state.unresolvedConflicts.size()
  };
  
  /// Get average completion time
  public func getAverageCompletionTime(state : GoalHierarchyState) : Float {
    state.averageCompletionTime
  };
  
  /// Activate a proposed goal
  public func activateGoal(state : GoalHierarchyState, goalId : Nat64, beat : Int) : Bool {
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId and (goal.status == #Proposed or goal.status == #Paused)) {
        goal.status := #Active;
        goal.lastUpdatedBeat := beat;
        goal.lastPursuitBeat := beat;
        return true;
      };
    };
    false
  };
  
  /// Pause a goal
  public func pauseGoal(state : GoalHierarchyState, goalId : Nat64, beat : Int) : Bool {
    for (goal in state.goals.vals()) {
      if (goal.goalId == goalId and goal.status == #Active) {
        goal.status := #Paused;
        goal.lastUpdatedBeat := beat;
        return true;
      };
    };
    false
  };

}
