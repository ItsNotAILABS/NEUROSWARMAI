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
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Result "mo:core/Result";

module ReasoningSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Reasoning thresholds
  public let CONFIDENCE_THRESHOLD : Float = 0.7;
  public let INFERENCE_DECAY : Float = 0.95;
  public let WORKING_MEMORY_CAPACITY : Nat = 7;  // Miller's law
  public let REASONING_DEPTH_LIMIT : Nat = 10;

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROPOSITIONS — The atoms of thought
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Proposition = {
    id : Nat;
    content : Text;
    truthValue : ?Bool;           // true, false, or unknown
    confidence : Float;           // [0, 1]
    source : PropositionSource;
    timestamp : Int;
    dependencies : [Nat];         // IDs of supporting propositions
    negates : ?Nat;               // ID of proposition this negates
  };
  
  public type PropositionSource = {
    #Observation;       // Direct observation
    #Inference;         // Derived through reasoning
    #Memory;            // Retrieved from memory
    #Communication;     // Received from external source
    #Hypothesis;        // Generated speculation
    #Axiom;             // Assumed true
  };
  
  public type LogicalOperator = {
    #And;
    #Or;
    #Not;
    #Implies;
    #Iff;               // If and only if
    #Xor;
  };
  
  public type CompoundProposition = {
    operator : LogicalOperator;
    operands : [Nat];   // Proposition IDs
    result : ?Bool;
    confidence : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INFERENCE RULES — How conclusions are drawn
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type InferenceRule = {
    name : Text;
    ruleType : InferenceType;
    premises : [Nat];             // Required proposition patterns
    conclusion : Text;
    confidenceTransfer : Float;   // How much confidence carries through
    validityConditions : [Text];
  };
  
  public type InferenceType = {
    #ModusPonens;       // If A and A→B, then B
    #ModusTollens;      // If ¬B and A→B, then ¬A
    #HypotheticalSyllogism; // If A→B and B→C, then A→C
    #DisjunctiveSyllogism;  // If A∨B and ¬A, then B
    #ConstructiveDilemma;   // If (A→B)∧(C→D) and A∨C, then B∨D
    #Induction;         // Generalize from instances
    #Abduction;         // Best explanation
    #Analogy;           // Pattern transfer
  };
  
  // Modus Ponens: If A and A→B, then B
  public func modusPonens(
    a : Proposition,
    implication : Proposition,  // A implies B
    bContent : Text
  ) : ?Proposition {
    if (a.truthValue == ?true and 
        implication.truthValue == ?true and
        a.confidence > CONFIDENCE_THRESHOLD and
        implication.confidence > CONFIDENCE_THRESHOLD) {
      ?{
        id = 0;  // Will be assigned
        content = bContent;
        truthValue = ?true;
        confidence = a.confidence * implication.confidence * 0.95;
        source = #Inference;
        timestamp = 0;
        dependencies = [a.id, implication.id];
        negates = null;
      }
    } else {
      null
    }
  };
  
  // Modus Tollens: If ¬B and A→B, then ¬A
  public func modusTollens(
    notB : Proposition,
    implication : Proposition,  // A implies B
    aContent : Text
  ) : ?Proposition {
    if (notB.truthValue == ?true and 
        implication.truthValue == ?true and
        notB.confidence > CONFIDENCE_THRESHOLD and
        implication.confidence > CONFIDENCE_THRESHOLD) {
      ?{
        id = 0;
        content = "NOT: " # aContent;
        truthValue = ?false;
        confidence = notB.confidence * implication.confidence * 0.90;
        source = #Inference;
        timestamp = 0;
        dependencies = [notB.id, implication.id];
        negates = null;
      }
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CAUSAL REASONING — Understanding cause and effect
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CausalLink = {
    cause : Nat;                  // Proposition ID
    effect : Nat;                 // Proposition ID
    strength : Float;             // Causal strength [0, 1]
    mechanism : Text;             // How cause leads to effect
    timeDelay : Nat;              // Typical beats between cause and effect
    confounders : [Nat];          // Potential confounding factors
    interventionable : Bool;      // Can we intervene on cause?
  };
  
  public type CausalGraph = {
    nodes : [Nat];                // Proposition IDs
    links : [CausalLink];
    rootCauses : [Nat];           // Nodes with no incoming links
    terminalEffects : [Nat];      // Nodes with no outgoing links
  };
  
  // Propagate causal effects
  public func propagateCausalEffect(
    graph : CausalGraph,
    causeId : Nat,
    causeOccurred : Bool,
    propositions : [Proposition]
  ) : [(Nat, Float)] {
    // Returns list of (effect ID, probability) pairs
    let effects = Buffer.Buffer<(Nat, Float)>(10);
    
    for (link in graph.links.vals()) {
      if (link.cause == causeId) {
        let effectProb = if (causeOccurred) {
          link.strength
        } else {
          1.0 - link.strength * 0.5  // Reduced probability without cause
        };
        effects.add((link.effect, effectProb));
      };
    };
    
    Buffer.toArray(effects)
  };
  
  // Counterfactual: What if X had (not) happened?
  public func counterfactualQuery(
    graph : CausalGraph,
    propositions : [Proposition],
    hypotheticalChange : (Nat, Bool),  // (proposition ID, new truth value)
    queryTarget : Nat
  ) : Float {
    let (changeId, changeValue) = hypotheticalChange;
    
    // Find causal path from change to target
    var pathStrength : Float = 1.0;
    var found = false;
    
    // BFS to find path
    let visited = Array.init<Bool>(propositions.size(), func(_ : Nat) : Bool { false });
    let queue = Buffer.Buffer<(Nat, Float)>(10);
    queue.add((changeId, 1.0));
    
    label search while (queue.size() > 0) {
      let (current, strength) = queue.get(0);
      // Remove first element
      let remaining = Buffer.Buffer<(Nat, Float)>(queue.size() - 1);
      for (i in Iter.range(1, queue.size() - 1)) {
        remaining.add(queue.get(i));
      };
      
      if (current == queryTarget) {
        pathStrength := strength;
        found := true;
        break search;
      };
      
      if (not visited[current]) {
        visited[current] := true;
        
        for (link in graph.links.vals()) {
          if (link.cause == current and not visited[link.effect]) {
            queue.add((link.effect, strength * link.strength));
          };
        };
      };
    };
    
    if (found) {
      if (changeValue) { pathStrength } else { 1.0 - pathStrength }
    } else {
      0.5  // No causal connection found
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROBABILISTIC REASONING — Bayesian inference
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BayesianBelief = {
    propositionId : Nat;
    prior : Float;                // P(H) - prior probability
    likelihood : Float;           // P(E|H) - likelihood of evidence given hypothesis
    evidence : Float;             // P(E) - marginal likelihood
    posterior : Float;            // P(H|E) - posterior probability
    lastUpdated : Int;
  };
  
  // Bayes' theorem: P(H|E) = P(E|H) × P(H) / P(E)
  public func bayesianUpdate(
    belief : BayesianBelief,
    newEvidence : Float,          // P(E|H) for new evidence
    evidencePrior : Float         // P(E) for new evidence
  ) : BayesianBelief {
    let newPosterior = (newEvidence * belief.posterior) / evidencePrior;
    
    {
      propositionId = belief.propositionId;
      prior = belief.prior;
      likelihood = newEvidence;
      evidence = evidencePrior;
      posterior = clamp(newPosterior, 0.001, 0.999);
      lastUpdated = belief.lastUpdated + 1;
    }
  };
  
  // Multiple evidence update
  public func bayesianMultiUpdate(
    belief : BayesianBelief,
    evidences : [(Float, Float)]  // [(P(E|H), P(E)), ...]
  ) : BayesianBelief {
    var currentBelief = belief;
    
    for ((likelihood, prior) in evidences.vals()) {
      currentBelief := bayesianUpdate(currentBelief, likelihood, prior);
    };
    
    currentBelief
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ANALOGICAL REASONING — Pattern transfer
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Analogy = {
    sourceCase : AnalogicalCase;
    targetCase : AnalogicalCase;
    mappings : [(Text, Text)];    // (source element, target element)
    structuralSimilarity : Float;
    surfaceSimilarity : Float;
    inferredProperties : [Text];  // Properties inferred for target
    confidence : Float;
  };
  
  public type AnalogicalCase = {
    id : Nat;
    domain : Text;
    elements : [Text];
    relations : [(Text, Text, Text)];  // (element1, relation, element2)
    properties : [(Text, Text)];       // (element, property)
  };
  
  // Structure mapping: Find correspondences between cases
  public func structureMapping(
    source : AnalogicalCase,
    target : AnalogicalCase
  ) : [(Text, Text)] {
    let mappings = Buffer.Buffer<(Text, Text)>(10);
    
    // Simple: Map elements by position (real implementation would be more sophisticated)
    let minLen = Nat.min(source.elements.size(), target.elements.size());
    for (i in Iter.range(0, minLen - 1)) {
      mappings.add((source.elements[i], target.elements[i]));
    };
    
    Buffer.toArray(mappings)
  };
  
  // Transfer properties from source to target via analogy
  public func analogicalInference(
    analogy : Analogy
  ) : [Proposition] {
    let inferences = Buffer.Buffer<Proposition>(10);
    
    // For each source property, check if it can transfer
    for ((elem, prop) in analogy.sourceCase.properties.vals()) {
      // Find corresponding target element
      for ((srcElem, tgtElem) in analogy.mappings.vals()) {
        if (srcElem == elem) {
          // Transfer property with reduced confidence
          let confidence = analogy.structuralSimilarity * 0.7;
          
          inferences.add({
            id = 0;
            content = tgtElem # " has property: " # prop;
            truthValue = if (confidence > 0.5) { ?true } else { null };
            confidence = confidence;
            source = #Inference;
            timestamp = 0;
            dependencies = [];
            negates = null;
          });
        };
      };
    };
    
    Buffer.toArray(inferences)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKING MEMORY — Limited capacity reasoning workspace
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkingMemoryItem = {
    proposition : Proposition;
    activation : Float;           // Current activation level
    enteredAt : Int;              // When it entered WM
    accessCount : Nat;            // How often accessed
    boundTo : [Nat];              // Related items in WM
  };
  
  public type WorkingMemory = {
    items : [WorkingMemoryItem];
    capacity : Nat;
    totalActivation : Float;
    focusIndex : ?Nat;            // Currently focused item
    lastUpdate : Int;
  };
  
  public func initWorkingMemory() : WorkingMemory {
    {
      items = [];
      capacity = WORKING_MEMORY_CAPACITY;
      totalActivation = 0.0;
      focusIndex = null;
      lastUpdate = 0;
    }
  };
  
  // Add item to working memory
  public func wmAdd(
    wm : WorkingMemory,
    proposition : Proposition,
    currentBeat : Int
  ) : WorkingMemory {
    let newItem : WorkingMemoryItem = {
      proposition = proposition;
      activation = 1.0;
      enteredAt = currentBeat;
      accessCount = 1;
      boundTo = [];
    };
    
    // If at capacity, remove lowest activation item
    var items = wm.items;
    if (items.size() >= wm.capacity) {
      // Find minimum activation
      var minIdx : Nat = 0;
      var minAct : Float = 1000.0;
      for (i in Iter.range(0, items.size() - 1)) {
        if (items[i].activation < minAct) {
          minAct := items[i].activation;
          minIdx := i;
        };
      };
      // Remove it
      let newItems = Buffer.Buffer<WorkingMemoryItem>(items.size());
      for (i in Iter.range(0, items.size() - 1)) {
        if (i != minIdx) {
          newItems.add(items[i]);
        };
      };
      items := Buffer.toArray(newItems);
    };
    
    {
      items = Array.append(items, [newItem]);
      capacity = wm.capacity;
      totalActivation = computeTotalActivation(items) + 1.0;
      focusIndex = ?items.size();
      lastUpdate = currentBeat;
    }
  };
  
  // Decay activations over time
  public func wmDecay(
    wm : WorkingMemory,
    decayRate : Float
  ) : WorkingMemory {
    let newItems = Array.map<WorkingMemoryItem, WorkingMemoryItem>(
      wm.items,
      func(item : WorkingMemoryItem) : WorkingMemoryItem {
        {
          proposition = item.proposition;
          activation = item.activation * (1.0 - decayRate);
          enteredAt = item.enteredAt;
          accessCount = item.accessCount;
          boundTo = item.boundTo;
        }
      }
    );
    
    {
      items = newItems;
      capacity = wm.capacity;
      totalActivation = computeTotalActivation(newItems);
      focusIndex = wm.focusIndex;
      lastUpdate = wm.lastUpdate;
    }
  };
  
  func computeTotalActivation(items : [WorkingMemoryItem]) : Float {
    var total : Float = 0.0;
    for (item in items.vals()) {
      total += item.activation;
    };
    total
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REASONING CHAINS — Multi-step inference
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ReasoningStep = {
    stepNumber : Nat;
    rule : InferenceType;
    premises : [Nat];             // Proposition IDs used
    conclusion : Proposition;
    justification : Text;
    alternativesConsidered : [Text];
    confidenceAtStep : Float;
  };
  
  public type ReasoningChain = {
    id : Nat;
    goal : Text;
    steps : [ReasoningStep];
    finalConclusion : ?Proposition;
    totalConfidence : Float;
    reasoningTime : Nat;          // Beats taken
    status : ReasoningStatus;
  };
  
  public type ReasoningStatus = {
    #InProgress;
    #Completed;
    #Failed : Text;
    #Stuck;
    #Abandoned;
  };
  
  // Backward chaining: Start from goal, find supporting premises
  public func backwardChain(
    goal : Text,
    knownFacts : [Proposition],
    rules : [InferenceRule],
    maxDepth : Nat
  ) : ReasoningChain {
    let steps = Buffer.Buffer<ReasoningStep>(10);
    var currentGoals = [goal];
    var depth : Nat = 0;
    var confidence : Float = 1.0;
    
    while (currentGoals.size() > 0 and depth < maxDepth) {
      let newGoals = Buffer.Buffer<Text>(10);
      
      for (g in currentGoals.vals()) {
        // Check if goal is already known
        var found = false;
        for (fact in knownFacts.vals()) {
          if (fact.content == g and fact.truthValue == ?true) {
            found := true;
            confidence *= fact.confidence;
          };
        };
        
        if (not found) {
          // Find rule that could prove this goal
          for (rule in rules.vals()) {
            if (rule.conclusion == g) {
              // Add premises as new subgoals
              for (premiseId in rule.premises.vals()) {
                if (premiseId < knownFacts.size()) {
                  newGoals.add(knownFacts[premiseId].content);
                };
              };
              confidence *= rule.confidenceTransfer;
            };
          };
        };
      };
      
      currentGoals := Buffer.toArray(newGoals);
      depth += 1;
    };
    
    {
      id = 0;
      goal = goal;
      steps = Buffer.toArray(steps);
      finalConclusion = null;
      totalConfidence = confidence;
      reasoningTime = depth;
      status = if (confidence > CONFIDENCE_THRESHOLD) { #Completed } else { #Failed("Low confidence") };
    }
  };
  
  // Forward chaining: Start from facts, derive new conclusions
  public func forwardChain(
    facts : [Proposition],
    rules : [InferenceRule],
    maxIterations : Nat
  ) : [Proposition] {
    let derived = Buffer.Buffer<Proposition>(20);
    var currentFacts = facts;
    var iteration : Nat = 0;
    
    while (iteration < maxIterations) {
      var newFactsFound = false;
      
      for (rule in rules.vals()) {
        // Check if rule premises are satisfied
        var premisesSatisfied = true;
        var minConfidence : Float = 1.0;
        
        for (premiseId in rule.premises.vals()) {
          var found = false;
          for (fact in currentFacts.vals()) {
            if (fact.id == premiseId and fact.truthValue == ?true) {
              found := true;
              if (fact.confidence < minConfidence) {
                minConfidence := fact.confidence;
              };
            };
          };
          if (not found) {
            premisesSatisfied := false;
          };
        };
        
        if (premisesSatisfied) {
          // Derive conclusion
          let newConclusion : Proposition = {
            id = currentFacts.size() + derived.size();
            content = rule.conclusion;
            truthValue = ?true;
            confidence = minConfidence * rule.confidenceTransfer;
            source = #Inference;
            timestamp = 0;
            dependencies = rule.premises;
            negates = null;
          };
          
          // Check if not already derived
          var alreadyDerived = false;
          for (d in derived.vals()) {
            if (d.content == newConclusion.content) {
              alreadyDerived := true;
            };
          };
          
          if (not alreadyDerived and newConclusion.confidence > 0.1) {
            derived.add(newConclusion);
            newFactsFound := true;
          };
        };
      };
      
      if (not newFactsFound) {
        // Fixed point reached
        return Buffer.toArray(derived);
      };
      
      currentFacts := Array.append(currentFacts, Buffer.toArray(derived));
      iteration += 1;
    };
    
    Buffer.toArray(derived)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // META-REASONING — Reasoning about reasoning
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MetaReasoningState = {
    currentStrategy : ReasoningStrategy;
    strategyEffectiveness : [Float];  // History of strategy success
    confidenceCalibration : Float;    // How calibrated are we?
    reasoningCost : Float;            // Computational cost so far
    reasoningBudget : Float;          // Allowed computational cost
    uncertaintyLevel : Float;
  };
  
  public type ReasoningStrategy = {
    #DepthFirst;
    #BreadthFirst;
    #BestFirst;
    #IterativeDeepening;
    #SatisficingSearch;
    #MetaSearch;
  };
  
  // Should we continue reasoning or act now?
  public func shouldContinueReasoning(
    meta : MetaReasoningState,
    currentConfidence : Float,
    actionUrgency : Float
  ) : Bool {
    // Trade-off between thinking more vs acting now
    let costBenefit = (1.0 - currentConfidence) / (meta.reasoningCost + 0.1);
    let remainingBudget = meta.reasoningBudget - meta.reasoningCost;
    
    // Continue if:
    // 1. We have budget left
    // 2. Confidence is below threshold
    // 3. Cost-benefit ratio is favorable
    // 4. Action isn't too urgent
    
    remainingBudget > 0.0 and
    currentConfidence < CONFIDENCE_THRESHOLD and
    costBenefit > 0.3 and
    actionUrgency < 0.8
  };
  
  // Choose best reasoning strategy
  public func selectStrategy(
    meta : MetaReasoningState,
    problemCharacteristics : ProblemCharacteristics
  ) : ReasoningStrategy {
    if (problemCharacteristics.solutionDepth > 5) {
      #IterativeDeepening
    } else if (problemCharacteristics.branchingFactor > 10) {
      #BestFirst
    } else if (meta.reasoningBudget - meta.reasoningCost < 0.2) {
      #SatisficingSearch
    } else {
      #DepthFirst
    }
  };
  
  public type ProblemCharacteristics = {
    estimatedComplexity : Float;
    branchingFactor : Nat;
    solutionDepth : Nat;
    timeConstraint : Float;
    reversibility : Bool;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GOAL-DIRECTED REASONING — Planning and problem-solving
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Goal = {
    id : Nat;
    description : Text;
    preconditions : [Nat];        // Proposition IDs that must be true
    effects : [Nat];              // Proposition IDs that become true
    priority : Float;
    deadline : ?Int;
    status : GoalStatus;
    subgoals : [Nat];
    parentGoal : ?Nat;
  };
  
  public type GoalStatus = {
    #Active;
    #Achieved;
    #Failed;
    #Suspended;
    #Abandoned;
  };
  
  public type Plan = {
    goalId : Nat;
    steps : [PlanStep];
    expectedOutcome : [Nat];      // Proposition IDs expected to be true
    estimatedCost : Float;
    estimatedDuration : Nat;      // Beats
    contingencies : [Contingency];
    currentStep : Nat;
    status : PlanStatus;
  };
  
  public type PlanStep = {
    stepNumber : Nat;
    action : Text;
    preconditions : [Nat];
    effects : [Nat];
    estimatedCost : Float;
    estimatedDuration : Nat;
    executionStatus : ExecutionStatus;
  };
  
  public type ExecutionStatus = {
    #Pending;
    #Executing;
    #Completed;
    #Failed : Text;
    #Skipped;
  };
  
  public type PlanStatus = {
    #Planning;
    #Ready;
    #Executing;
    #Completed;
    #Failed;
    #Replanning;
  };
  
  public type Contingency = {
    trigger : Text;               // What triggers this contingency
    response : [PlanStep];        // Alternative steps
    priority : Float;
  };
  
  // STRIPS-like planning
  public func planToGoal(
    initialState : [Proposition],
    goal : Goal,
    availableActions : [PlanStep],
    maxDepth : Nat
  ) : ?Plan {
    // Check if goal already achieved
    var goalMet = true;
    for (precondId in goal.preconditions.vals()) {
      var found = false;
      for (prop in initialState.vals()) {
        if (prop.id == precondId and prop.truthValue == ?true) {
          found := true;
        };
      };
      if (not found) { goalMet := false };
    };
    
    if (goalMet) {
      return ?{
        goalId = goal.id;
        steps = [];
        expectedOutcome = goal.effects;
        estimatedCost = 0.0;
        estimatedDuration = 0;
        contingencies = [];
        currentStep = 0;
        status = #Completed;
      };
    };
    
    // BFS to find plan
    let queue = Buffer.Buffer<([PlanStep], [Proposition])>(100);
    queue.add(([], initialState));
    
    var depth : Nat = 0;
    while (queue.size() > 0 and depth < maxDepth) {
      let (currentPlan, currentState) = queue.get(0);
      
      // Check if current state satisfies goal
      var satisfies = true;
      for (precondId in goal.preconditions.vals()) {
        var found = false;
        for (prop in currentState.vals()) {
          if (prop.id == precondId and prop.truthValue == ?true) {
            found := true;
          };
        };
        if (not found) { satisfies := false };
      };
      
      if (satisfies) {
        // Found a plan
        return ?{
          goalId = goal.id;
          steps = currentPlan;
          expectedOutcome = goal.effects;
          estimatedCost = Float.fromInt(currentPlan.size());
          estimatedDuration = currentPlan.size() * 10;
          contingencies = [];
          currentStep = 0;
          status = #Ready;
        };
      };
      
      // Try each available action
      for (action in availableActions.vals()) {
        // Check if action's preconditions are met
        var canApply = true;
        for (precondId in action.preconditions.vals()) {
          var found = false;
          for (prop in currentState.vals()) {
            if (prop.id == precondId and prop.truthValue == ?true) {
              found := true;
            };
          };
          if (not found) { canApply := false };
        };
        
        if (canApply) {
          // Apply action to get new state
          let newState = applyAction(currentState, action);
          let newPlan = Array.append(currentPlan, [action]);
          queue.add((newPlan, newState));
        };
      };
      
      depth += 1;
    };
    
    null  // No plan found
  };
  
  func applyAction(state : [Proposition], action : PlanStep) : [Proposition] {
    // Add effect propositions to state
    let newState = Buffer.Buffer<Proposition>(state.size() + action.effects.size());
    for (prop in state.vals()) {
      newState.add(prop);
    };
    for (effectId in action.effects.vals()) {
      newState.add({
        id = effectId;
        content = "Effect of " # action.action;
        truthValue = ?true;
        confidence = 1.0;
        source = #Inference;
        timestamp = 0;
        dependencies = [];
        negates = null;
      });
    };
    Buffer.toArray(newState)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE REASONING STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ReasoningState = {
    propositions : [Proposition];
    beliefs : [BayesianBelief];
    causalGraph : CausalGraph;
    workingMemory : WorkingMemory;
    activeChains : [ReasoningChain];
    goals : [Goal];
    activePlans : [Plan];
    metaState : MetaReasoningState;
    inferences : [InferenceRule];
    analogies : [Analogy];
    reasoningHistory : [ReasoningStep];
    totalInferences : Nat;
  };
  
  public func initReasoningState() : ReasoningState {
    {
      propositions = [];
      beliefs = [];
      causalGraph = { nodes = []; links = []; rootCauses = []; terminalEffects = [] };
      workingMemory = initWorkingMemory();
      activeChains = [];
      goals = [];
      activePlans = [];
      metaState = {
        currentStrategy = #BestFirst;
        strategyEffectiveness = [];
        confidenceCalibration = 0.8;
        reasoningCost = 0.0;
        reasoningBudget = 10.0;
        uncertaintyLevel = 0.3;
      };
      inferences = [];
      analogies = [];
      reasoningHistory = [];
      totalInferences = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // REASONING TICK — One cycle of reasoning
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ReasoningTickResult = {
    newInferences : Nat;
    beliefsUpdated : Nat;
    goalsProgressed : Nat;
    workingMemoryItems : Nat;
    currentConfidence : Float;
    reasoningCost : Float;
  };
  
  public func reasoningTick(
    state : ReasoningState,
    newObservations : [Proposition],
    currentBeat : Int
  ) : (ReasoningTickResult, ReasoningState) {
    // 1. Add observations to working memory
    var wm = state.workingMemory;
    for (obs in newObservations.vals()) {
      wm := wmAdd(wm, obs, currentBeat);
    };
    
    // 2. Decay working memory
    wm := wmDecay(wm, 0.05);
    
    // 3. Add observations to propositions
    let newProps = Array.append(state.propositions, newObservations);
    
    // 4. Forward chain to derive new conclusions
    let derived = forwardChain(newProps, state.inferences, 5);
    let allProps = Array.append(newProps, derived);
    
    // 5. Update Bayesian beliefs based on new observations
    var beliefsUpdated : Nat = 0;
    let newBeliefs = Array.map<BayesianBelief, BayesianBelief>(
      state.beliefs,
      func(b : BayesianBelief) : BayesianBelief {
        // Check if relevant observation
        for (obs in newObservations.vals()) {
          if (obs.id == b.propositionId) {
            beliefsUpdated += 1;
            return bayesianUpdate(b, obs.confidence, 0.5);
          };
        };
        b
      }
    );
    
    // 6. Progress on active plans
    var goalsProgressed : Nat = 0;
    for (plan in state.activePlans.vals()) {
      switch (plan.status) {
        case (#Executing) { goalsProgressed += 1 };
        case _ {};
      };
    };
    
    // 7. Compute overall confidence
    var totalConf : Float = 0.0;
    var confCount : Nat = 0;
    for (item in wm.items.vals()) {
      totalConf += item.proposition.confidence;
      confCount += 1;
    };
    let avgConf = if (confCount > 0) { totalConf / Float.fromInt(confCount) } else { 0.5 };
    
    let result : ReasoningTickResult = {
      newInferences = derived.size();
      beliefsUpdated = beliefsUpdated;
      goalsProgressed = goalsProgressed;
      workingMemoryItems = wm.items.size();
      currentConfidence = avgConf;
      reasoningCost = state.metaState.reasoningCost + 0.1;
    };
    
    let newState : ReasoningState = {
      propositions = allProps;
      beliefs = newBeliefs;
      causalGraph = state.causalGraph;
      workingMemory = wm;
      activeChains = state.activeChains;
      goals = state.goals;
      activePlans = state.activePlans;
      metaState = {
        currentStrategy = state.metaState.currentStrategy;
        strategyEffectiveness = state.metaState.strategyEffectiveness;
        confidenceCalibration = state.metaState.confidenceCalibration;
        reasoningCost = state.metaState.reasoningCost + 0.1;
        reasoningBudget = state.metaState.reasoningBudget;
        uncertaintyLevel = 1.0 - avgConf;
      };
      inferences = state.inferences;
      analogies = state.analogies;
      reasoningHistory = state.reasoningHistory;
      totalInferences = state.totalInferences + derived.size();
    };
    
    (result, newState)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}
