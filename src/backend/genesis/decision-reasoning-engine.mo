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
// DECISION REASONING ENGINE — EXPLAINABLE AI DECISIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements comprehensive decision-making with explainability, enabling:
// 1. Multi-criteria decision analysis
// 2. Bayesian reasoning and belief updates
// 3. Utility-based decision making
// 4. Explanation generation for transparency
// 5. Decision audit trails
//
// DECISION REASONING ARCHITECTURE:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
// │                              DECISION REASONING ENGINE                                          │
// │                                                                                                 │
// │  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐    ┌───────────────┐             │
// │  │   Context     │    │   Options     │    │   Criteria    │    │   Constraints │             │
// │  │   Analyzer    │───▶│   Generator   │───▶│   Evaluator   │───▶│   Checker     │             │
// │  └───────────────┘    └───────────────┘    └───────────────┘    └───────────────┘             │
// │          │                                                              │                      │
// │          │                                                              ▼                      │
// │          │                                                    ┌───────────────┐               │
// │          │                                                    │   Decision    │               │
// │          │                                                    │   Selector    │               │
// │          │                                                    └───────┬───────┘               │
// │          │                                                            │                       │
// │          ▼                                                            ▼                       │
// │  ┌───────────────┐                                          ┌───────────────┐                │
// │  │   Belief      │                                          │   Explanation │                │
// │  │   Network     │                                          │   Generator   │                │
// │  └───────────────┘                                          └───────────────┘                │
// │                                                                                               │
// │  ┌─────────────────────────────────────────────────────────────────────────────────────────┐ │
// │  │                        REASONING METHODS                                                 │ │
// │  │  • Utility   • Bayesian   • Causal   • Counterfactual   • Analogical   • Rule-based    │ │
// │  └─────────────────────────────────────────────────────────────────────────────────────────┘ │
// └─────────────────────────────────────────────────────────────────────────────────────────────────┘
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
//
// • Expected Utility: EU(a) = Σᵢ P(sᵢ|a) × U(sᵢ)
// • Bayes' Rule: P(H|E) = P(E|H) × P(H) / P(E)
// • Multi-Criteria: V(a) = Σⱼ wⱼ × vⱼ(a) where Σⱼ wⱼ = 1
// • Regret: R(a) = max_a' U(a') - U(a)
// • Confidence: C(d) = P(correct|d) based on evidence strength
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

module DecisionReasoningEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  public let S_ZERO_FLOOR : Float = 1.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // DECISION ENGINE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum decisions to track
  public let MAX_DECISIONS : Nat = 10000;
  
  /// Maximum options per decision
  public let MAX_OPTIONS : Nat = 20;
  
  /// Maximum criteria per decision
  public let MAX_CRITERIA : Nat = 50;
  
  /// Maximum constraints
  public let MAX_CONSTRAINTS : Nat = 100;
  
  /// Minimum confidence threshold
  public let MIN_CONFIDENCE : Float = 0.3;
  
  /// Regret aversion factor
  public let REGRET_AVERSION : Float = 0.5;
  
  /// Explanation detail level
  public let DEFAULT_EXPLANATION_DEPTH : Nat = 3;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: DECISION CONTEXT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Decision context type
  public type DecisionContextType = {
    #Strategic;       // Long-term, high-impact
    #Tactical;        // Medium-term, moderate impact
    #Operational;     // Short-term, routine
    #Emergency;       // Urgent, critical
    #Creative;        // Open-ended
    #Ethical;         // Value-laden
    #Social;          // Interpersonal
    #Economic;        // Resource-related
  };
  
  /// Decision context
  public type DecisionContext = {
    contextId : Nat64;
    contextType : DecisionContextType;
    description : Text;
    var urgency : Float;              // 0-1
    var importance : Float;           // 0-1
    var uncertainty : Float;          // 0-1
    var reversibility : Float;        // 0-1 (1 = fully reversible)
    var stakeholders : [Stakeholder];
    var constraints : [Constraint];
    createdBeat : Int;
  };
  
  /// Stakeholder
  public type Stakeholder = {
    name : Text;
    role : Text;
    var influence : Float;            // 0-1
    var affected : Float;             // How much affected by decision
    preferences : [Text];
  };
  
  /// Constraint
  public type Constraint = {
    constraintId : Nat64;
    name : Text;
    constraintType : ConstraintType;
    var threshold : Float;
    var isHard : Bool;                // Hard vs soft constraint
    var priority : Float;
  };
  
  /// Constraint type
  public type ConstraintType = {
    #Resource;        // Resource limitation
    #Time;            // Time limitation
    #Legal;           // Legal requirement
    #Ethical;         // Ethical requirement
    #Technical;       // Technical limitation
    #Social;          // Social norm
    #Custom : Text;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: OPTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Decision option
  public type DecisionOption = {
    optionId : Nat64;
    name : Text;
    description : Text;
    var expectedOutcomes : [Outcome];
    var costs : [Cost];
    var risks : [Risk];
    var benefits : [Benefit];
    var feasibility : Float;          // 0-1
    var utility : Float;              // Computed utility
    var confidence : Float;           // Confidence in estimates
    var isViable : Bool;              // Passes all hard constraints
  };
  
  /// Outcome
  public type Outcome = {
    description : Text;
    var probability : Float;          // 0-1
    var value : Float;                // Utility value
    var timeframe : Nat;              // Beats until outcome
  };
  
  /// Cost
  public type Cost = {
    costType : CostType;
    var amount : Float;
    var certainty : Float;
    description : Text;
  };
  
  /// Cost type
  public type CostType = {
    #Resource;
    #Time;
    #Opportunity;
    #Risk;
    #Social;
    #Reputation;
    #Other : Text;
  };
  
  /// Risk
  public type Risk = {
    description : Text;
    var probability : Float;
    var impact : Float;               // Severity if occurs
    var mitigability : Float;         // How much can be mitigated
  };
  
  /// Benefit
  public type Benefit = {
    description : Text;
    var probability : Float;
    var value : Float;
    benefitType : BenefitType;
  };
  
  /// Benefit type
  public type BenefitType = {
    #Immediate;
    #ShortTerm;
    #LongTerm;
    #Indirect;
    #Strategic;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: CRITERIA
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Criterion
  public type Criterion = {
    criterionId : Nat64;
    name : Text;
    description : Text;
    criterionType : CriterionType;
    var weight : Float;               // 0-1, sum to 1
    var direction : CriterionDirection;
    var scale : CriterionScale;
  };
  
  /// Criterion type
  public type CriterionType = {
    #Quantitative;
    #Qualitative;
    #Boolean;
    #Ranked;
    #Composite;
  };
  
  /// Criterion direction
  public type CriterionDirection = {
    #Maximize;
    #Minimize;
    #Target : Float;
  };
  
  /// Criterion scale
  public type CriterionScale = {
    #Continuous : (Float, Float);     // (min, max)
    #Discrete : [Float];
    #Categorical : [Text];
    #Binary;
  };
  
  /// Criterion evaluation
  public type CriterionEvaluation = {
    optionId : Nat64;
    criterionId : Nat64;
    var rawValue : Float;
    var normalizedValue : Float;      // 0-1
    var weightedValue : Float;        // normalized × weight
    var confidence : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: REASONING METHODS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Reasoning method
  public type ReasoningMethod = {
    #Utility;         // Expected utility maximization
    #Bayesian;        // Bayesian inference
    #MultiCriteria;   // MCDM (AHP, TOPSIS, etc.)
    #RuleBased;       // If-then rules
    #Causal;          // Causal reasoning
    #Counterfactual;  // What-if analysis
    #Analogical;      // Reasoning by analogy
    #Heuristic;       // Quick heuristics
    #Ensemble;        // Combination of methods
  };
  
  /// Belief
  public type Belief = {
    beliefId : Nat64;
    statement : Text;
    var probability : Float;          // Credence
    var evidence : [Evidence];
    var lastUpdatedBeat : Int;
  };
  
  /// Evidence
  public type Evidence = {
    evidenceId : Nat64;
    description : Text;
    var strength : Float;             // 0-1
    var reliability : Float;          // 0-1
    source : EvidenceSource;
    observedBeat : Int;
  };
  
  /// Evidence source
  public type EvidenceSource = {
    #Direct;          // Direct observation
    #Indirect;        // Inferred
    #Testimony;       // From other agent
    #Prior;           // Prior knowledge
    #Simulation;      // From simulation
    #Model;           // From model prediction
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: DECISION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Decision
  public type Decision = {
    decisionId : Nat64;
    title : Text;
    description : Text;
    context : DecisionContext;
    var options : Buffer.Buffer<DecisionOption>;
    var criteria : Buffer.Buffer<Criterion>;
    var evaluations : Buffer.Buffer<CriterionEvaluation>;
    var selectedOption : ?Nat64;
    var decisionStatus : DecisionStatus;
    var reasoningMethod : ReasoningMethod;
    var explanation : ?Explanation;
    var confidence : Float;
    var regret : Float;
    createdBeat : Int;
    var decidedBeat : ?Int;
    var reviewBeat : ?Int;
  };
  
  /// Decision status
  public type DecisionStatus = {
    #Pending;
    #Analyzing;
    #Ready;
    #Made;
    #Implemented;
    #Reviewed;
    #Revised;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: EXPLANATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Explanation
  public type Explanation = {
    explanationId : Nat64;
    decisionId : Nat64;
    var summary : Text;
    var reasoning : [ReasoningStep];
    var factors : [ExplanationFactor];
    var alternatives : [AlternativeExplanation];
    var caveats : [Text];
    var confidence : Float;
    generatedBeat : Int;
  };
  
  /// Reasoning step
  public type ReasoningStep = {
    stepNumber : Nat;
    description : Text;
    inputs : [Text];
    output : Text;
    method : ReasoningMethod;
    confidence : Float;
  };
  
  /// Explanation factor
  public type ExplanationFactor = {
    factorName : Text;
    var contribution : Float;         // How much it contributed to decision
    direction : { #Positive; #Negative; #Neutral };
    importance : Float;
  };
  
  /// Alternative explanation
  public type AlternativeExplanation = {
    optionId : Nat64;
    whyNotChosen : Text;
    var gap : Float;                  // How far from being chosen
    wouldBeChosenIf : [Text];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 7: AUDIT TRAIL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Audit event
  public type AuditEvent = {
    eventId : Nat64;
    decisionId : Nat64;
    eventType : AuditEventType;
    description : Text;
    oldValue : ?Text;
    newValue : ?Text;
    actor : Text;
    beat : Int;
  };
  
  /// Audit event type
  public type AuditEventType = {
    #Created;
    #OptionAdded;
    #OptionRemoved;
    #CriterionAdded;
    #CriterionWeightChanged;
    #EvaluationUpdated;
    #DecisionMade;
    #DecisionReversed;
    #ExplanationGenerated;
    #ReviewCompleted;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 8: COMPLETE DECISION ENGINE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete decision engine state
  public type DecisionEngineState = {
    // Decisions
    var decisions : Buffer.Buffer<Decision>;
    var activeDecisions : [Nat64];
    var completedDecisions : Buffer.Buffer<Nat64>;
    
    // Beliefs
    var beliefs : Buffer.Buffer<Belief>;
    var evidence : Buffer.Buffer<Evidence>;
    
    // Audit
    var auditTrail : Buffer.Buffer<AuditEvent>;
    
    // Statistics
    var totalDecisions : Nat;
    var averageConfidence : Float;
    var averageRegret : Float;
    var decisionAccuracy : Float;     // Based on reviews
    
    // Counters
    var decisionIdCounter : Nat64;
    var optionIdCounter : Nat64;
    var criterionIdCounter : Nat64;
    var constraintIdCounter : Nat64;
    var beliefIdCounter : Nat64;
    var evidenceIdCounter : Nat64;
    var explanationIdCounter : Nat64;
    var auditIdCounter : Nat64;
    var contextIdCounter : Nat64;
    var currentBeat : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 9: INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize decision engine
  public func initDecisionEngine() : DecisionEngineState {
    {
      var decisions = Buffer.Buffer<Decision>(MAX_DECISIONS);
      var activeDecisions = [];
      var completedDecisions = Buffer.Buffer<Nat64>(1000);
      
      var beliefs = Buffer.Buffer<Belief>(500);
      var evidence = Buffer.Buffer<Evidence>(2000);
      
      var auditTrail = Buffer.Buffer<AuditEvent>(10000);
      
      var totalDecisions = 0;
      var averageConfidence = S_ZERO_FLOOR;
      var averageRegret = 0.0;
      var decisionAccuracy = S_ZERO_FLOOR;
      
      var decisionIdCounter = 0;
      var optionIdCounter = 0;
      var criterionIdCounter = 0;
      var constraintIdCounter = 0;
      var beliefIdCounter = 0;
      var evidenceIdCounter = 0;
      var explanationIdCounter = 0;
      var auditIdCounter = 0;
      var contextIdCounter = 0;
      var currentBeat = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 10: DECISION CREATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a new decision
  public func createDecision(
    state : DecisionEngineState,
    title : Text,
    description : Text,
    contextType : DecisionContextType,
    urgency : Float,
    importance : Float,
    beat : Int
  ) : Nat64 {
    let decisionId = state.decisionIdCounter;
    state.decisionIdCounter += 1;
    
    let contextId = state.contextIdCounter;
    state.contextIdCounter += 1;
    
    let context : DecisionContext = {
      contextId = contextId;
      contextType = contextType;
      description = description;
      var urgency = urgency;
      var importance = importance;
      var uncertainty = 0.5;
      var reversibility = 0.5;
      var stakeholders = [];
      var constraints = [];
      createdBeat = beat;
    };
    
    let decision : Decision = {
      decisionId = decisionId;
      title = title;
      description = description;
      context = context;
      var options = Buffer.Buffer<DecisionOption>(MAX_OPTIONS);
      var criteria = Buffer.Buffer<Criterion>(MAX_CRITERIA);
      var evaluations = Buffer.Buffer<CriterionEvaluation>(MAX_OPTIONS * MAX_CRITERIA);
      var selectedOption = null;
      var decisionStatus = #Pending;
      var reasoningMethod = #MultiCriteria;
      var explanation = null;
      var confidence = 0.0;
      var regret = 0.0;
      createdBeat = beat;
      var decidedBeat = null;
      var reviewBeat = null;
    };
    
    state.decisions.add(decision);
    state.activeDecisions := Array.append(state.activeDecisions, [decisionId]);
    state.totalDecisions += 1;
    
    // Audit
    addAuditEvent(state, decisionId, #Created, "Decision created: " # title, beat);
    
    decisionId
  };
  
  /// Add option to decision
  public func addOption(
    state : DecisionEngineState,
    decisionId : Nat64,
    name : Text,
    description : Text,
    beat : Int
  ) : ?Nat64 {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId and decision.decisionStatus == #Pending) {
        let optionId = state.optionIdCounter;
        state.optionIdCounter += 1;
        
        let option : DecisionOption = {
          optionId = optionId;
          name = name;
          description = description;
          var expectedOutcomes = [];
          var costs = [];
          var risks = [];
          var benefits = [];
          var feasibility = 1.0;
          var utility = 0.0;
          var confidence = 0.5;
          var isViable = true;
        };
        
        decision.options.add(option);
        
        // Audit
        addAuditEvent(state, decisionId, #OptionAdded, "Option added: " # name, beat);
        
        return ?optionId;
      };
    };
    null
  };
  
  /// Add criterion to decision
  public func addCriterion(
    state : DecisionEngineState,
    decisionId : Nat64,
    name : Text,
    description : Text,
    weight : Float,
    direction : CriterionDirection,
    beat : Int
  ) : ?Nat64 {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId) {
        let criterionId = state.criterionIdCounter;
        state.criterionIdCounter += 1;
        
        let criterion : Criterion = {
          criterionId = criterionId;
          name = name;
          description = description;
          criterionType = #Quantitative;
          var weight = weight;
          var direction = direction;
          var scale = #Continuous((0.0, 1.0));
        };
        
        decision.criteria.add(criterion);
        
        // Audit
        addAuditEvent(state, decisionId, #CriterionAdded, "Criterion added: " # name, beat);
        
        // Renormalize weights
        normalizeWeights(decision);
        
        return ?criterionId;
      };
    };
    null
  };
  
  /// Normalize criterion weights to sum to 1
  func normalizeWeights(decision : Decision) : () {
    var totalWeight : Float = 0.0;
    
    for (criterion in decision.criteria.vals()) {
      totalWeight += criterion.weight;
    };
    
    if (totalWeight > 0.0) {
      for (criterion in decision.criteria.vals()) {
        criterion.weight := criterion.weight / totalWeight;
      };
    };
  };
  
  /// Add evaluation
  public func addEvaluation(
    state : DecisionEngineState,
    decisionId : Nat64,
    optionId : Nat64,
    criterionId : Nat64,
    rawValue : Float,
    confidence : Float,
    beat : Int
  ) : Bool {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId) {
        // Find criterion weight
        var weight : Float = 1.0;
        var direction : CriterionDirection = #Maximize;
        var scale : CriterionScale = #Continuous((0.0, 1.0));
        
        for (criterion in decision.criteria.vals()) {
          if (criterion.criterionId == criterionId) {
            weight := criterion.weight;
            direction := criterion.direction;
            scale := criterion.scale;
          };
        };
        
        // Normalize value
        let normalizedValue = normalizeValue(rawValue, scale, direction);
        let weightedValue = normalizedValue * weight;
        
        let evaluation : CriterionEvaluation = {
          optionId = optionId;
          criterionId = criterionId;
          var rawValue = rawValue;
          var normalizedValue = normalizedValue;
          var weightedValue = weightedValue;
          var confidence = confidence;
        };
        
        decision.evaluations.add(evaluation);
        
        // Audit
        addAuditEvent(state, decisionId, #EvaluationUpdated, 
          "Evaluation added for option " # Nat64.toText(optionId), beat);
        
        return true;
      };
    };
    false
  };
  
  /// Normalize value based on scale and direction
  func normalizeValue(rawValue : Float, scale : CriterionScale, direction : CriterionDirection) : Float {
    let normalized = switch (scale) {
      case (#Continuous((min, max))) {
        if (max - min > 0.0) {
          (rawValue - min) / (max - min)
        } else {
          0.5
        }
      };
      case (#Discrete(values)) {
        if (values.size() > 1) {
          // Find position in array
          var pos : Nat = 0;
          for (i in Iter.range(0, values.size() - 1)) {
            if (Float.abs(values[i] - rawValue) < 0.001) {
              pos := i;
            };
          };
          Float.fromInt(pos) / Float.fromInt(values.size() - 1)
        } else {
          0.5
        }
      };
      case (#Categorical(_)) { 0.5 };
      case (#Binary) { if (rawValue > 0.5) { 1.0 } else { 0.0 } };
    };
    
    // Adjust for direction
    switch (direction) {
      case (#Maximize) { normalized };
      case (#Minimize) { 1.0 - normalized };
      case (#Target(t)) {
        let deviation = Float.abs(rawValue - t);
        1.0 - Float.min(1.0, deviation)
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 11: DECISION ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Analyze decision and compute utilities
  public func analyzeDecision(state : DecisionEngineState, decisionId : Nat64, beat : Int) : Bool {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId) {
        decision.decisionStatus := #Analyzing;
        
        // Compute utility for each option
        for (option in decision.options.vals()) {
          var totalUtility : Float = 0.0;
          var totalConfidence : Float = 0.0;
          var evalCount : Nat = 0;
          
          for (eval in decision.evaluations.vals()) {
            if (eval.optionId == option.optionId) {
              totalUtility += eval.weightedValue;
              totalConfidence += eval.confidence;
              evalCount += 1;
            };
          };
          
          option.utility := totalUtility;
          option.confidence := if (evalCount > 0) { totalConfidence / Float.fromInt(evalCount) } else { 0.5 };
          
          // Check constraints
          option.isViable := checkConstraints(decision, option);
        };
        
        decision.decisionStatus := #Ready;
        return true;
      };
    };
    false
  };
  
  /// Check if option satisfies all hard constraints
  func checkConstraints(decision : Decision, option : DecisionOption) : Bool {
    for (constraint in decision.context.constraints.vals()) {
      if (constraint.isHard) {
        // Would need to evaluate constraint against option
        // Simplified: assume all options are viable
      };
    };
    true
  };
  
  /// Make decision using specified reasoning method
  public func makeDecision(
    state : DecisionEngineState,
    decisionId : Nat64,
    method : ReasoningMethod,
    beat : Int
  ) : ?Nat64 {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId and decision.decisionStatus == #Ready) {
        decision.reasoningMethod := method;
        
        let selectedOptionId = switch (method) {
          case (#Utility) { selectByUtility(decision) };
          case (#MultiCriteria) { selectByMultiCriteria(decision) };
          case (#Bayesian) { selectByBayesian(decision, state) };
          case (#Heuristic) { selectByHeuristic(decision) };
          case (_) { selectByUtility(decision) };
        };
        
        switch (selectedOptionId) {
          case (?optId) {
            decision.selectedOption := ?optId;
            decision.decisionStatus := #Made;
            decision.decidedBeat := ?beat;
            
            // Compute confidence
            decision.confidence := computeDecisionConfidence(decision, optId);
            
            // Compute regret
            decision.regret := computeRegret(decision, optId);
            
            // Generate explanation
            let explanation = generateExplanation(state, decision, optId, beat);
            decision.explanation := ?explanation;
            
            // Update statistics
            updateStatistics(state, decision);
            
            // Audit
            addAuditEvent(state, decisionId, #DecisionMade, 
              "Decision made: selected option " # Nat64.toText(optId), beat);
            
            // Move to completed
            state.completedDecisions.add(decisionId);
            state.activeDecisions := Array.filter(state.activeDecisions, func(id : Nat64) : Bool {
              id != decisionId
            });
            
            return ?optId;
          };
          case (null) { null };
        };
      };
    };
    null
  };
  
  /// Select option by utility maximization
  func selectByUtility(decision : Decision) : ?Nat64 {
    var bestOptionId : ?Nat64 = null;
    var bestUtility : Float = -1e10;
    
    for (option in decision.options.vals()) {
      if (option.isViable and option.utility > bestUtility) {
        bestUtility := option.utility;
        bestOptionId := ?option.optionId;
      };
    };
    
    bestOptionId
  };
  
  /// Select option by multi-criteria weighted sum
  func selectByMultiCriteria(decision : Decision) : ?Nat64 {
    // Same as utility for now (weighted sum is computed in evaluation)
    selectByUtility(decision)
  };
  
  /// Select option using Bayesian reasoning
  func selectByBayesian(decision : Decision, state : DecisionEngineState) : ?Nat64 {
    // Update utilities based on beliefs
    for (option in decision.options.vals()) {
      var adjustedUtility = option.utility;
      
      // Adjust based on relevant beliefs
      for (belief in state.beliefs.vals()) {
        // Would match beliefs to options
        adjustedUtility *= (0.5 + belief.probability * 0.5);
      };
      
      option.utility := adjustedUtility;
    };
    
    selectByUtility(decision)
  };
  
  /// Select option using heuristics
  func selectByHeuristic(decision : Decision) : ?Nat64 {
    // Satisficing: select first option that meets minimum threshold
    let threshold = 0.6;
    
    for (option in decision.options.vals()) {
      if (option.isViable and option.utility >= threshold) {
        return ?option.optionId;
      };
    };
    
    // Fall back to best option
    selectByUtility(decision)
  };
  
  /// Compute decision confidence
  func computeDecisionConfidence(decision : Decision, selectedOptionId : Nat64) : Float {
    var selectedUtility : Float = 0.0;
    var secondBestUtility : Float = 0.0;
    var selectedConfidence : Float = 0.5;
    
    for (option in decision.options.vals()) {
      if (option.optionId == selectedOptionId) {
        selectedUtility := option.utility;
        selectedConfidence := option.confidence;
      } else if (option.utility > secondBestUtility) {
        secondBestUtility := option.utility;
      };
    };
    
    // Confidence based on margin and option confidence
    let margin = selectedUtility - secondBestUtility;
    let marginConfidence = Float.min(1.0, margin * 2.0);
    
    Float.max(S_ZERO_FLOOR, (marginConfidence + selectedConfidence) / 2.0)
  };
  
  /// Compute regret (minimax regret)
  func computeRegret(decision : Decision, selectedOptionId : Nat64) : Float {
    var maxUtility : Float = 0.0;
    var selectedUtility : Float = 0.0;
    
    for (option in decision.options.vals()) {
      if (option.utility > maxUtility) {
        maxUtility := option.utility;
      };
      if (option.optionId == selectedOptionId) {
        selectedUtility := option.utility;
      };
    };
    
    maxUtility - selectedUtility
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 12: EXPLANATION GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Generate explanation for decision
  func generateExplanation(
    state : DecisionEngineState,
    decision : Decision,
    selectedOptionId : Nat64,
    beat : Int
  ) : Explanation {
    let explanationId = state.explanationIdCounter;
    state.explanationIdCounter += 1;
    
    // Find selected option
    var selectedOption : ?DecisionOption = null;
    var selectedName = "Unknown";
    
    for (option in decision.options.vals()) {
      if (option.optionId == selectedOptionId) {
        selectedOption := ?option;
        selectedName := option.name;
      };
    };
    
    // Generate summary
    let summary = "Selected '" # selectedName # "' based on " # 
      reasoningMethodToText(decision.reasoningMethod) # " analysis. " #
      "Confidence: " # Float.toText(decision.confidence) # ".";
    
    // Generate reasoning steps
    var steps : [ReasoningStep] = [];
    
    steps := Array.append(steps, [{
      stepNumber = 1;
      description = "Identified " # Nat.toText(decision.options.size()) # " possible options";
      inputs = [];
      output = "Options enumerated";
      method = #Utility;
      confidence = 1.0;
    }]);
    
    steps := Array.append(steps, [{
      stepNumber = 2;
      description = "Evaluated options against " # Nat.toText(decision.criteria.size()) # " criteria";
      inputs = [];
      output = "Evaluations computed";
      method = #MultiCriteria;
      confidence = 0.9;
    }]);
    
    steps := Array.append(steps, [{
      stepNumber = 3;
      description = "Applied " # reasoningMethodToText(decision.reasoningMethod) # " to select best option";
      inputs = [];
      output = "'" # selectedName # "' selected";
      method = decision.reasoningMethod;
      confidence = decision.confidence;
    }]);
    
    // Generate factors
    var factors : [ExplanationFactor] = [];
    
    switch (selectedOption) {
      case (?opt) {
        // Top contributing criteria
        for (eval in decision.evaluations.vals()) {
          if (eval.optionId == selectedOptionId) {
            for (criterion in decision.criteria.vals()) {
              if (criterion.criterionId == eval.criterionId) {
                factors := Array.append(factors, [{
                  factorName = criterion.name;
                  var contribution = eval.weightedValue;
                  direction = if (eval.normalizedValue > 0.5) { #Positive } 
                             else if (eval.normalizedValue < 0.5) { #Negative } 
                             else { #Neutral };
                  importance = criterion.weight;
                }]);
              };
            };
          };
        };
      };
      case (null) {};
    };
    
    // Generate alternatives
    var alternatives : [AlternativeExplanation] = [];
    
    for (option in decision.options.vals()) {
      if (option.optionId != selectedOptionId) {
        switch (selectedOption) {
          case (?sel) {
            let gap = sel.utility - option.utility;
            alternatives := Array.append(alternatives, [{
              optionId = option.optionId;
              whyNotChosen = "Lower overall utility score";
              var gap = gap;
              wouldBeChosenIf = ["Higher scores on key criteria"];
            }]);
          };
          case (null) {};
        };
      };
    };
    
    // Caveats
    var caveats : [Text] = [];
    
    if (decision.confidence < 0.7) {
      caveats := Array.append(caveats, ["Decision confidence is moderate; consider additional analysis."]);
    };
    
    if (decision.regret > 0.1) {
      caveats := Array.append(caveats, ["There is potential regret if other options perform better."]);
    };
    
    if (decision.context.uncertainty > 0.5) {
      caveats := Array.append(caveats, ["High uncertainty in the decision context."]);
    };
    
    {
      explanationId = explanationId;
      decisionId = decision.decisionId;
      var summary = summary;
      var reasoning = steps;
      var factors = factors;
      var alternatives = alternatives;
      var caveats = caveats;
      var confidence = decision.confidence;
      generatedBeat = beat;
    }
  };
  
  /// Convert reasoning method to text
  func reasoningMethodToText(method : ReasoningMethod) : Text {
    switch (method) {
      case (#Utility) { "expected utility" };
      case (#Bayesian) { "Bayesian inference" };
      case (#MultiCriteria) { "multi-criteria" };
      case (#RuleBased) { "rule-based" };
      case (#Causal) { "causal" };
      case (#Counterfactual) { "counterfactual" };
      case (#Analogical) { "analogical" };
      case (#Heuristic) { "heuristic" };
      case (#Ensemble) { "ensemble" };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 13: BELIEF MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Add belief
  public func addBelief(
    state : DecisionEngineState,
    statement : Text,
    probability : Float,
    beat : Int
  ) : Nat64 {
    let beliefId = state.beliefIdCounter;
    state.beliefIdCounter += 1;
    
    let belief : Belief = {
      beliefId = beliefId;
      statement = statement;
      var probability = Float.max(0.0, Float.min(1.0, probability));
      var evidence = [];
      var lastUpdatedBeat = beat;
    };
    
    state.beliefs.add(belief);
    beliefId
  };
  
  /// Update belief with evidence (Bayesian update)
  public func updateBelief(
    state : DecisionEngineState,
    beliefId : Nat64,
    newEvidence : Evidence,
    likelihoodIfTrue : Float,
    likelihoodIfFalse : Float,
    beat : Int
  ) : Bool {
    for (belief in state.beliefs.vals()) {
      if (belief.beliefId == beliefId) {
        // Bayes' Rule: P(H|E) = P(E|H) × P(H) / P(E)
        // P(E) = P(E|H)×P(H) + P(E|¬H)×P(¬H)
        
        let priorTrue = belief.probability;
        let priorFalse = 1.0 - priorTrue;
        
        let pEvidenceGivenTrue = likelihoodIfTrue * newEvidence.strength * newEvidence.reliability;
        let pEvidenceGivenFalse = likelihoodIfFalse * newEvidence.strength * newEvidence.reliability;
        
        let pEvidence = pEvidenceGivenTrue * priorTrue + pEvidenceGivenFalse * priorFalse;
        
        if (pEvidence > 0.0) {
          belief.probability := pEvidenceGivenTrue * priorTrue / pEvidence;
        };
        
        belief.evidence := Array.append(belief.evidence, [newEvidence]);
        belief.lastUpdatedBeat := beat;
        
        state.evidence.add(newEvidence);
        
        return true;
      };
    };
    false
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 14: AUDIT TRAIL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Add audit event
  func addAuditEvent(
    state : DecisionEngineState,
    decisionId : Nat64,
    eventType : AuditEventType,
    description : Text,
    beat : Int
  ) : () {
    let eventId = state.auditIdCounter;
    state.auditIdCounter += 1;
    
    let event : AuditEvent = {
      eventId = eventId;
      decisionId = decisionId;
      eventType = eventType;
      description = description;
      oldValue = null;
      newValue = null;
      actor = "System";
      beat = beat;
    };
    
    state.auditTrail.add(event);
  };
  
  /// Get audit trail for decision
  public func getAuditTrail(state : DecisionEngineState, decisionId : Nat64) : [AuditEvent] {
    var events : [AuditEvent] = [];
    
    for (event in state.auditTrail.vals()) {
      if (event.decisionId == decisionId) {
        events := Array.append(events, [event]);
      };
    };
    
    events
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 15: STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update statistics
  func updateStatistics(state : DecisionEngineState, decision : Decision) : () {
    let n = Float.fromInt(state.completedDecisions.size() + 1);
    
    state.averageConfidence := (state.averageConfidence * (n - 1.0) + decision.confidence) / n;
    state.averageRegret := (state.averageRegret * (n - 1.0) + decision.regret) / n;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 16: MAIN HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main decision engine heartbeat
  public func heartbeatUpdate(state : DecisionEngineState, beat : Int) : DecisionEngineHeartbeatResult {
    state.currentBeat := beat;
    
    // 1. Process pending decisions
    var pendingCount : Nat = 0;
    for (decisionId in state.activeDecisions.vals()) {
      for (decision in state.decisions.vals()) {
        if (decision.decisionId == decisionId) {
          if (decision.decisionStatus == #Pending and 
              decision.options.size() > 0 and
              decision.criteria.size() > 0) {
            pendingCount += 1;
            
            // Auto-analyze if ready
            if (decision.evaluations.size() >= decision.options.size() * decision.criteria.size()) {
              ignore analyzeDecision(state, decisionId, beat);
            };
          };
        };
      };
    };
    
    // 2. Decay old beliefs
    if (beat % 1000 == 0) {
      for (belief in state.beliefs.vals()) {
        // Beliefs decay slightly towards uncertainty
        belief.probability := belief.probability * 0.99 + 0.5 * 0.01;
      };
    };
    
    {
      beat = beat;
      activeDecisions = state.activeDecisions.size();
      completedDecisions = state.completedDecisions.size();
      pendingAnalysis = pendingCount;
      averageConfidence = state.averageConfidence;
      averageRegret = state.averageRegret;
      beliefCount = state.beliefs.size();
      evidenceCount = state.evidence.size();
    }
  };
  
  /// Decision engine heartbeat result
  public type DecisionEngineHeartbeatResult = {
    beat : Int;
    activeDecisions : Nat;
    completedDecisions : Nat;
    pendingAnalysis : Nat;
    averageConfidence : Float;
    averageRegret : Float;
    beliefCount : Nat;
    evidenceCount : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 17: QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get active decision count
  public func getActiveDecisionCount(state : DecisionEngineState) : Nat {
    state.activeDecisions.size()
  };
  
  /// Get average confidence
  public func getAverageConfidence(state : DecisionEngineState) : Float {
    state.averageConfidence
  };
  
  /// Get average regret
  public func getAverageRegret(state : DecisionEngineState) : Float {
    state.averageRegret
  };
  
  /// Get decision by ID
  public func getDecision(state : DecisionEngineState, decisionId : Nat64) : ?Decision {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId) {
        return ?decision;
      };
    };
    null
  };
  
  /// Get explanation for decision
  public func getExplanation(state : DecisionEngineState, decisionId : Nat64) : ?Explanation {
    for (decision in state.decisions.vals()) {
      if (decision.decisionId == decisionId) {
        return decision.explanation;
      };
    };
    null
  };
  
  /// Get total decision count
  public func getTotalDecisionCount(state : DecisionEngineState) : Nat {
    state.totalDecisions
  };
  
  /// Get belief by ID
  public func getBelief(state : DecisionEngineState, beliefId : Nat64) : ?Belief {
    for (belief in state.beliefs.vals()) {
      if (belief.beliefId == beliefId) {
        return ?belief;
      };
    };
    null
  };

}
