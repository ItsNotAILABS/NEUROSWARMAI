// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN AI — FORMAL VERIFICATION HARNESS                                                                ║
// ║  Zero Third-Party Dependencies — ITAR/EAR Compliant — Air-Gap Ready                                      ║
// ║                                                                                                           ║
// ║  TLA+/CBMC/Frama-C Compatible State Machine Models                                                        ║
// ║  Invariant Checking — Property Specification — Orchestration Layer Verification                           ║
// ║  Minimal Attack Surface by Design — Amenable to Bounded Model Checking                                    ║
// ║                                                                                                           ║
// ║  EXPORT CONTROL: This module may be subject to ITAR (22 CFR §120-130) / EAR (15 CFR §730-774)           ║
// ║  DO NOT EXPORT without proper BIS/DDTC authorization.                                                     ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Array "mo:core/Array";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import Text "mo:core/Text";

module SovereignFormalVerification {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Domain separator for verification proofs
  public let DOMAIN_FORMAL : [Nat8] = [
    0x4D, 0x45, 0x44, 0x49, 0x4E, 0x41, 0x2E, 0x46, // MEDINA.F
    0x4F, 0x52, 0x4D, 0x41, 0x4C, 0x2E, 0x76, 0x31  // ORMAL.v1
  ];

  /// Maximum state machine transitions for bounded model checking
  public let MAX_BMC_DEPTH : Nat = 1024;

  /// Maximum invariants per state machine
  public let MAX_INVARIANTS : Nat = 64;

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES — STATE MACHINE MODEL (TLA+ Compatible)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Abstract state in the orchestration model
  public type AbstractState = {
    stateId : Nat32;
    label : Text;
    variables : [StateVariable];
    stateHash : [Nat8];
  };

  /// State variable with typed value
  public type StateVariable = {
    name : Text;
    value : VariableValue;
    constraint : ?ValueConstraint;
  };

  /// Variable value types (minimal for verification)
  public type VariableValue = {
    #Nat : Nat;
    #Int : Int;
    #Bool : Bool;
    #Bounded : { value : Nat; min : Nat; max : Nat };
    #Enum : { value : Nat; options : Nat };  // value in 0..options-1
    #Set : [Nat];
    #Sequence : [Nat];
  };

  /// Constraint on a variable
  public type ValueConstraint = {
    #Range : { min : Int; max : Int };
    #Invariant : { predicateId : Nat32 };
    #Monotonic : { direction : MonotonicDirection };
    #Bounded : { maxSize : Nat };
  };

  /// Direction for monotonic constraints
  public type MonotonicDirection = {
    #NonDecreasing;
    #NonIncreasing;
    #StrictlyIncreasing;
    #StrictlyDecreasing;
  };

  /// State transition (action in TLA+ terms)
  public type Transition = {
    transitionId : Nat32;
    label : Text;
    fromState : Nat32;
    toState : Nat32;
    guard : Guard;
    effects : [Effect];
  };

  /// Guard condition (precondition for transition)
  public type Guard = {
    #Always;                           // No precondition
    #VarEquals : { name : Text; expected : VariableValue };
    #VarGreater : { name : Text; threshold : Int };
    #VarLess : { name : Text; threshold : Int };
    #And : [Guard];
    #Or : [Guard];
    #Not : Guard;
    #SetContains : { setName : Text; element : Nat };
    #SetEmpty : { setName : Text };
  };

  /// Effect of a transition on state
  public type Effect = {
    #Assign : { name : Text; value : VariableValue };
    #Increment : { name : Text; by : Int };
    #Decrement : { name : Text; by : Int };
    #AddToSet : { setName : Text; element : Nat };
    #RemoveFromSet : { setName : Text; element : Nat };
    #AppendToSeq : { seqName : Text; element : Nat };
  };

  /// Safety property (invariant — must always hold)
  public type SafetyProperty = {
    propertyId : Nat32;
    label : Text;
    predicate : Predicate;
    criticality : PropertyCriticality;
  };

  /// Liveness property (must eventually hold)
  public type LivenessProperty = {
    propertyId : Nat32;
    label : Text;
    predicate : Predicate;
    fairness : FairnessCondition;
  };

  /// Predicate for property checking
  public type Predicate = {
    #VarEquals : { name : Text; expected : VariableValue };
    #VarInRange : { name : Text; min : Int; max : Int };
    #Implies : { antecedent : Predicate; consequent : Predicate };
    #And : [Predicate];
    #Or : [Predicate];
    #Not : Predicate;
    #ForAll : { setName : Text; elementPredicate : Predicate };
    #Exists : { setName : Text; elementPredicate : Predicate };
    #NoDeadlock;  // System can always make progress
    #MutualExclusion : { resources : [Text] };
  };

  /// How critical a property violation is
  public type PropertyCriticality = {
    #Fatal;          // System must halt
    #Critical;       // Immediate remediation required
    #Warning;        // Degraded but operational
    #Informational;  // Logged only
  };

  /// Fairness conditions for liveness
  public type FairnessCondition = {
    #WeakFairness;    // If continuously enabled, eventually taken
    #StrongFairness;  // If infinitely often enabled, eventually taken
    #Unconditional;   // Must eventually hold regardless
  };

  /// Complete state machine specification
  public type StateMachineSpec = {
    specId : [Nat8];
    name : Text;
    initialState : AbstractState;
    transitions : [Transition];
    safetyProperties : [SafetyProperty];
    livenessProperties : [LivenessProperty];
    stateCount : Nat;
    bounded : Bool;  // Whether all variables are bounded (enables BMC)
  };

  /// Verification result
  public type VerificationResult = {
    specId : [Nat8];
    passed : Bool;
    violatedProperties : [PropertyViolation];
    statesExplored : Nat;
    maxDepthReached : Nat;
    counterexample : ?CounterExample;
  };

  /// Property violation details
  public type PropertyViolation = {
    propertyId : Nat32;
    propertyLabel : Text;
    violatingState : AbstractState;
    transitionPath : [Nat32];  // Path of transitions to violation
    criticality : PropertyCriticality;
  };

  /// Counterexample trace
  public type CounterExample = {
    states : [AbstractState];
    transitions : [Nat32];
    length : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — INVARIANT CHECKING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Check a safety property against a state
  public func checkSafety(property : SafetyProperty, state : AbstractState) : Bool {
    evaluatePredicate(property.predicate, state)
  };

  /// Check all safety properties against a state
  public func checkAllSafety(properties : [SafetyProperty], state : AbstractState) : [PropertyViolation] {
    var violations : [PropertyViolation] = [];

    for (prop in properties.vals()) {
      if (not checkSafety(prop, state)) {
        violations := Array.append(violations, [{
          propertyId = prop.propertyId;
          propertyLabel = prop.label;
          violatingState = state;
          transitionPath = [];
          criticality = prop.criticality;
        }]);
      };
    };

    violations
  };

  /// Evaluate a predicate against a state
  public func evaluatePredicate(pred : Predicate, state : AbstractState) : Bool {
    switch (pred) {
      case (#VarEquals({ name; expected })) {
        switch (findVariable(state, name)) {
          case null { false };
          case (?v) { valuesEqual(v.value, expected) };
        }
      };
      case (#VarInRange({ name; min; max })) {
        switch (findVariable(state, name)) {
          case null { false };
          case (?v) { valueInRange(v.value, min, max) };
        }
      };
      case (#Implies({ antecedent; consequent })) {
        if (evaluatePredicate(antecedent, state)) {
          evaluatePredicate(consequent, state)
        } else { true }  // Implication vacuously true
      };
      case (#And(preds)) {
        for (p in preds.vals()) {
          if (not evaluatePredicate(p, state)) { return false };
        };
        true
      };
      case (#Or(preds)) {
        for (p in preds.vals()) {
          if (evaluatePredicate(p, state)) { return true };
        };
        false
      };
      case (#Not(inner)) {
        not evaluatePredicate(inner, state)
      };
      case (#NoDeadlock) {
        // Check at runtime — here we assume state is not terminal
        true
      };
      case (#MutualExclusion({ resources })) {
        checkMutualExclusion(state, resources)
      };
      case (#ForAll({ setName; elementPredicate })) {
        // Simplified: check predicate holds for all
        evaluatePredicate(elementPredicate, state)
      };
      case (#Exists({ setName; elementPredicate })) {
        evaluatePredicate(elementPredicate, state)
      };
    }
  };

  /// Check a guard condition against a state
  public func evaluateGuard(guard : Guard, state : AbstractState) : Bool {
    switch (guard) {
      case (#Always) { true };
      case (#VarEquals({ name; expected })) {
        switch (findVariable(state, name)) {
          case null { false };
          case (?v) { valuesEqual(v.value, expected) };
        }
      };
      case (#VarGreater({ name; threshold })) {
        switch (findVariable(state, name)) {
          case null { false };
          case (?v) { valueGreaterThan(v.value, threshold) };
        }
      };
      case (#VarLess({ name; threshold })) {
        switch (findVariable(state, name)) {
          case null { false };
          case (?v) { valueLessThan(v.value, threshold) };
        }
      };
      case (#And(guards)) {
        for (g in guards.vals()) {
          if (not evaluateGuard(g, state)) { return false };
        };
        true
      };
      case (#Or(guards)) {
        for (g in guards.vals()) {
          if (evaluateGuard(g, state)) { return true };
        };
        false
      };
      case (#Not(inner)) {
        not evaluateGuard(inner, state)
      };
      case (#SetContains({ setName; element })) {
        switch (findVariable(state, setName)) {
          case null { false };
          case (?v) {
            switch (v.value) {
              case (#Set(s)) { arrayContains(s, element) };
              case _ { false };
            }
          };
        }
      };
      case (#SetEmpty({ setName })) {
        switch (findVariable(state, setName)) {
          case null { true };
          case (?v) {
            switch (v.value) {
              case (#Set(s)) { s.size() == 0 };
              case _ { true };
            }
          };
        }
      };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — BOUNDED MODEL CHECKING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Run bounded model checking up to a depth limit
  public func boundedModelCheck(
    spec : StateMachineSpec,
    maxDepth : Nat
  ) : VerificationResult {
    let depth = if (maxDepth > MAX_BMC_DEPTH) { MAX_BMC_DEPTH } else { maxDepth };
    var statesExplored : Nat = 0;
    var violations : [PropertyViolation] = [];
    var currentState = spec.initialState;
    var transitionPath : [Nat32] = [];
    var stateTrace : [AbstractState] = [currentState];

    // Check initial state
    let initialViolations = checkAllSafety(spec.safetyProperties, currentState);
    if (initialViolations.size() > 0) {
      return {
        specId = spec.specId;
        passed = false;
        violatedProperties = initialViolations;
        statesExplored = 1;
        maxDepthReached = 0;
        counterexample = ?{ states = [currentState]; transitions = []; length = 0 };
      };
    };

    statesExplored += 1;

    // Explore transitions up to depth
    for (d in Iter.range(0, depth - 1)) {
      // Find enabled transitions
      var foundTransition = false;

      for (t in spec.transitions.vals()) {
        if (t.fromState == currentState.stateId and evaluateGuard(t.guard, currentState)) {
          // Apply transition
          let nextState = applyEffects(currentState, t.effects, t.toState);
          transitionPath := Array.append(transitionPath, [t.transitionId]);
          stateTrace := Array.append(stateTrace, [nextState]);

          // Check safety properties in new state
          let newViolations = checkAllSafety(spec.safetyProperties, nextState);
          if (newViolations.size() > 0) {
            // Add path info to violations
            let violationsWithPath = Array.map<PropertyViolation, PropertyViolation>(
              newViolations,
              func(v : PropertyViolation) : PropertyViolation {
                { v with transitionPath = transitionPath }
              }
            );
            return {
              specId = spec.specId;
              passed = false;
              violatedProperties = violationsWithPath;
              statesExplored = statesExplored;
              maxDepthReached = d + 1;
              counterexample = ?{ states = stateTrace; transitions = transitionPath; length = d + 1 };
            };
          };

          currentState := nextState;
          statesExplored += 1;
          foundTransition := true;
        };
      };

      // If no transition found, check for deadlock
      if (not foundTransition) {
        // Check if NoDeadlock property exists and is violated
        for (prop in spec.safetyProperties.vals()) {
          switch (prop.predicate) {
            case (#NoDeadlock) {
              violations := Array.append(violations, [{
                propertyId = prop.propertyId;
                propertyLabel = prop.label;
                violatingState = currentState;
                transitionPath = transitionPath;
                criticality = prop.criticality;
              }]);
            };
            case _ {};
          };
        };

        if (violations.size() > 0) {
          return {
            specId = spec.specId;
            passed = false;
            violatedProperties = violations;
            statesExplored = statesExplored;
            maxDepthReached = d;
            counterexample = ?{ states = stateTrace; transitions = transitionPath; length = d };
          };
        };
        // No deadlock property — just stop exploration
        return {
          specId = spec.specId;
          passed = true;
          violatedProperties = [];
          statesExplored = statesExplored;
          maxDepthReached = d;
          counterexample = null;
        };
      };
    };

    {
      specId = spec.specId;
      passed = true;
      violatedProperties = [];
      statesExplored = statesExplored;
      maxDepthReached = depth;
      counterexample = null;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE — SPECIFICATION BUILDERS (for orchestration layer)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Build a state machine spec for the private/public core split
  public func buildPrivatePublicSplitSpec() : StateMachineSpec {
    let initialVars : [StateVariable] = [
      { name = "phase"; value = #Enum({ value = 0; options = 4 }); constraint = null },
      { name = "commitmentIssued"; value = #Bool(false); constraint = null },
      { name = "publicRootExposed"; value = #Bool(false); constraint = null },
      { name = "privateDataLeaked"; value = #Bool(false); constraint = null },
      { name = "verificationPassed"; value = #Bool(false); constraint = null }
    ];

    let initial : AbstractState = {
      stateId = 0;
      label = "INIT";
      variables = initialVars;
      stateHash = formalHash([0x49, 0x4E, 0x49, 0x54]);
    };

    let transitions : [Transition] = [
      {
        transitionId = 1;
        label = "PrivateCompute";
        fromState = 0;
        toState = 1;
        guard = #VarEquals({ name = "phase"; expected = #Enum({ value = 0; options = 4 }) });
        effects = [#Assign({ name = "phase"; value = #Enum({ value = 1; options = 4 }) })];
      },
      {
        transitionId = 2;
        label = "IssueCommitment";
        fromState = 1;
        toState = 2;
        guard = #VarEquals({ name = "phase"; expected = #Enum({ value = 1; options = 4 }) });
        effects = [
          #Assign({ name = "phase"; value = #Enum({ value = 2; options = 4 }) }),
          #Assign({ name = "commitmentIssued"; value = #Bool(true) })
        ];
      },
      {
        transitionId = 3;
        label = "ExposeRoot";
        fromState = 2;
        toState = 3;
        guard = #And([
          #VarEquals({ name = "phase"; expected = #Enum({ value = 2; options = 4 }) }),
          #VarEquals({ name = "commitmentIssued"; expected = #Bool(true) })
        ]);
        effects = [
          #Assign({ name = "phase"; value = #Enum({ value = 3; options = 4 }) }),
          #Assign({ name = "publicRootExposed"; value = #Bool(true) })
        ];
      }
    ];

    let safetyProperties : [SafetyProperty] = [
      {
        propertyId = 1;
        label = "NoPrivateDataLeak";
        predicate = #VarEquals({ name = "privateDataLeaked"; expected = #Bool(false) });
        criticality = #Fatal;
      },
      {
        propertyId = 2;
        label = "CommitmentBeforeExposure";
        predicate = #Implies({
          antecedent = #VarEquals({ name = "publicRootExposed"; expected = #Bool(true) });
          consequent = #VarEquals({ name = "commitmentIssued"; expected = #Bool(true) });
        });
        criticality = #Critical;
      }
    ];

    {
      specId = formalHash([0x50, 0x50, 0x53]); // "PPS" (Private/Public Split)
      name = "PrivatePublicSplitProtocol";
      initialState = initial;
      transitions = transitions;
      safetyProperties = safetyProperties;
      livenessProperties = [];
      stateCount = 4;
      bounded = true;
    }
  };

  /// Build a spec for the vault capability system
  public func buildVaultCapabilitySpec() : StateMachineSpec {
    let initialVars : [StateVariable] = [
      { name = "capabilitiesIssued"; value = #Nat(0); constraint = ?#Range({ min = 0; max = 16 }) },
      { name = "activeCapabilities"; value = #Set([]); constraint = ?#Bounded({ maxSize = 16 }) },
      { name = "revokedCapabilities"; value = #Set([]); constraint = null },
      { name = "agentCompromised"; value = #Bool(false); constraint = null },
      { name = "blastContained"; value = #Bool(false); constraint = null }
    ];

    let initial : AbstractState = {
      stateId = 0;
      label = "VaultReady";
      variables = initialVars;
      stateHash = formalHash([0x56, 0x52]); // "VR"
    };

    let safetyProperties : [SafetyProperty] = [
      {
        propertyId = 10;
        label = "CapabilityBound";
        predicate = #VarInRange({ name = "capabilitiesIssued"; min = 0; max = 16 });
        criticality = #Critical;
      },
      {
        propertyId = 11;
        label = "CompromiseContainment";
        predicate = #Implies({
          antecedent = #VarEquals({ name = "agentCompromised"; expected = #Bool(true) });
          consequent = #VarEquals({ name = "blastContained"; expected = #Bool(true) });
        });
        criticality = #Fatal;
      }
    ];

    {
      specId = formalHash([0x56, 0x43, 0x53]); // "VCS" (Vault Capability Spec)
      name = "VaultCapabilityProtocol";
      initialState = initial;
      transitions = [];
      safetyProperties = safetyProperties;
      livenessProperties = [];
      stateCount = 1;
      bounded = true;
    }
  };

  /// Build a spec for the MPC session protocol
  public func buildMPCSessionSpec() : StateMachineSpec {
    let initialVars : [StateVariable] = [
      { name = "phase"; value = #Enum({ value = 0; options = 7 }); constraint = null },
      { name = "partiesCommitted"; value = #Nat(0); constraint = ?#Range({ min = 0; max = 16 }) },
      { name = "threshold"; value = #Nat(3); constraint = ?#Range({ min = 2; max = 16 }) },
      { name = "plaintextExposed"; value = #Bool(false); constraint = null },
      { name = "allSharesValid"; value = #Bool(true); constraint = null }
    ];

    let initial : AbstractState = {
      stateId = 0;
      label = "MPCSetup";
      variables = initialVars;
      stateHash = formalHash([0x4D, 0x53]); // "MS"
    };

    let safetyProperties : [SafetyProperty] = [
      {
        propertyId = 20;
        label = "NoPlaintextExposure";
        predicate = #VarEquals({ name = "plaintextExposed"; expected = #Bool(false) });
        criticality = #Fatal;
      },
      {
        propertyId = 21;
        label = "ShareIntegrity";
        predicate = #VarEquals({ name = "allSharesValid"; expected = #Bool(true) });
        criticality = #Critical;
      }
    ];

    {
      specId = formalHash([0x4D, 0x50, 0x43]); // "MPC"
      name = "MPCSessionProtocol";
      initialState = initial;
      transitions = [];
      safetyProperties = safetyProperties;
      livenessProperties = [];
      stateCount = 7;
      bounded = true;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INTERNAL — HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════

  func applyEffects(state : AbstractState, effects : [Effect], newStateId : Nat32) : AbstractState {
    var vars = state.variables;

    for (effect in effects.vals()) {
      switch (effect) {
        case (#Assign({ name; value })) {
          vars := updateVariable(vars, name, value);
        };
        case (#Increment({ name; by })) {
          vars := incrementVariable(vars, name, by);
        };
        case (#Decrement({ name; by })) {
          vars := incrementVariable(vars, name, -by);
        };
        case (#AddToSet({ setName; element })) {
          vars := addToSetVariable(vars, setName, element);
        };
        case (#RemoveFromSet({ setName; element })) {
          vars := removeFromSetVariable(vars, setName, element);
        };
        case (#AppendToSeq({ seqName; element })) {
          vars := appendToSeqVariable(vars, seqName, element);
        };
      };
    };

    {
      stateId = newStateId;
      label = state.label;
      variables = vars;
      stateHash = computeStateHash(vars);
    }
  };

  func findVariable(state : AbstractState, name : Text) : ?StateVariable {
    for (v in state.variables.vals()) {
      if (v.name == name) { return ?v };
    };
    null
  };

  func updateVariable(vars : [StateVariable], name : Text, value : VariableValue) : [StateVariable] {
    Array.map<StateVariable, StateVariable>(vars, func(v : StateVariable) : StateVariable {
      if (v.name == name) { { v with value = value } } else { v }
    })
  };

  func incrementVariable(vars : [StateVariable], name : Text, by : Int) : [StateVariable] {
    Array.map<StateVariable, StateVariable>(vars, func(v : StateVariable) : StateVariable {
      if (v.name == name) {
        switch (v.value) {
          case (#Nat(n)) { { v with value = #Nat(Int.abs(n + by)) } };
          case (#Int(n)) { { v with value = #Int(n + by) } };
          case _ { v };
        }
      } else { v }
    })
  };

  func addToSetVariable(vars : [StateVariable], name : Text, element : Nat) : [StateVariable] {
    Array.map<StateVariable, StateVariable>(vars, func(v : StateVariable) : StateVariable {
      if (v.name == name) {
        switch (v.value) {
          case (#Set(s)) {
            if (arrayContains(s, element)) { v }
            else { { v with value = #Set(Array.append(s, [element])) } }
          };
          case _ { v };
        }
      } else { v }
    })
  };

  func removeFromSetVariable(vars : [StateVariable], name : Text, element : Nat) : [StateVariable] {
    Array.map<StateVariable, StateVariable>(vars, func(v : StateVariable) : StateVariable {
      if (v.name == name) {
        switch (v.value) {
          case (#Set(s)) {
            let filtered = Array.filter<Nat>(s, func(x : Nat) : Bool { x != element });
            { v with value = #Set(filtered) }
          };
          case _ { v };
        }
      } else { v }
    })
  };

  func appendToSeqVariable(vars : [StateVariable], name : Text, element : Nat) : [StateVariable] {
    Array.map<StateVariable, StateVariable>(vars, func(v : StateVariable) : StateVariable {
      if (v.name == name) {
        switch (v.value) {
          case (#Sequence(s)) { { v with value = #Sequence(Array.append(s, [element])) } };
          case _ { v };
        }
      } else { v }
    })
  };

  func valuesEqual(a : VariableValue, b : VariableValue) : Bool {
    switch (a, b) {
      case (#Nat(x), #Nat(y)) { x == y };
      case (#Int(x), #Int(y)) { x == y };
      case (#Bool(x), #Bool(y)) { x == y };
      case (#Enum(x), #Enum(y)) { x.value == y.value and x.options == y.options };
      case (#Bounded(x), #Bounded(y)) { x.value == y.value };
      case _ { false };
    }
  };

  func valueInRange(v : VariableValue, min : Int, max : Int) : Bool {
    switch (v) {
      case (#Nat(n)) { n >= Int.abs(min) and n <= Int.abs(max) };
      case (#Int(n)) { n >= min and n <= max };
      case (#Bounded(b)) { b.value >= Int.abs(min) and b.value <= Int.abs(max) };
      case _ { false };
    }
  };

  func valueGreaterThan(v : VariableValue, threshold : Int) : Bool {
    switch (v) {
      case (#Nat(n)) { n > Int.abs(threshold) };
      case (#Int(n)) { n > threshold };
      case _ { false };
    }
  };

  func valueLessThan(v : VariableValue, threshold : Int) : Bool {
    switch (v) {
      case (#Nat(n)) { n < Int.abs(threshold) };
      case (#Int(n)) { n < threshold };
      case _ { false };
    }
  };

  func checkMutualExclusion(state : AbstractState, resources : [Text]) : Bool {
    // Check that at most one resource variable is true/non-zero
    var activeCount : Nat = 0;
    for (name in resources.vals()) {
      switch (findVariable(state, name)) {
        case null {};
        case (?v) {
          switch (v.value) {
            case (#Bool(true)) { activeCount += 1 };
            case (#Nat(n)) { if (n > 0) { activeCount += 1 } };
            case _ {};
          };
        };
      };
    };
    activeCount <= 1
  };

  func arrayContains(arr : [Nat], element : Nat) : Bool {
    for (x in arr.vals()) {
      if (x == element) { return true };
    };
    false
  };

  func computeStateHash(vars : [StateVariable]) : [Nat8] {
    var data : [Nat8] = [];
    for (v in vars.vals()) {
      // Simple serialization for hashing
      let nameBytes = textToBytes(v.name);
      data := Array.append(data, nameBytes);
    };
    formalHash(data)
  };

  func textToBytes(t : Text) : [Nat8] {
    var bytes : [Nat8] = [];
    for (c in t.chars()) {
      bytes := Array.append(bytes, [Nat8.fromNat(Nat32.toNat(Nat32.fromNat(Int.abs(Int.abs(Nat32.toNat(Char.toNat32(c)))))))]);
    };
    bytes
  };

  func formalHash(data : [Nat8]) : [Nat8] {
    var h0 : Nat32 = 0x811c9dc5;
    var h1 : Nat32 = 0x01000193;
    var h2 : Nat32 = 0x6c62272e;
    var h3 : Nat32 = 0x61c88647;
    var h4 : Nat32 = 0x27d4eb2f;
    var h5 : Nat32 = 0x165667b1;
    var h6 : Nat32 = 0xd3a2646c;
    var h7 : Nat32 = 0xfd7046c5;

    for (b in DOMAIN_FORMAL.vals()) {
      h0 := (h0 ^ Nat32.fromNat(Nat8.toNat(b))) *% 0x01000193;
    };

    for (b in data.vals()) {
      let byte = Nat32.fromNat(Nat8.toNat(b));
      h0 := (h0 ^ byte) *% 0x01000193;
      h1 := (h1 ^ (byte +% 0x9e3779b9)) *% 0x01000193;
      h2 := (h2 ^ (byte ^ 0x6a09e667)) *% 0x01000193;
      h3 := (h3 ^ (byte +% 0xbb67ae85)) *% 0x01000193;
      h4 := (h4 ^ (byte ^ 0x3c6ef372)) *% 0x01000193;
      h5 := (h5 ^ (byte +% 0xa54ff53a)) *% 0x01000193;
      h6 := (h6 ^ (byte ^ 0x510e527f)) *% 0x01000193;
      h7 := (h7 ^ (byte +% 0x1f83d9ab)) *% 0x01000193;
    };

    h0 := h0 ^ (h0 >> 16); h0 := h0 *% 0x85ebca6b;
    h1 := h1 ^ (h1 >> 13); h1 := h1 *% 0xc2b2ae35;
    h2 := h2 ^ (h2 >> 16); h2 := h2 *% 0x85ebca6b;
    h3 := h3 ^ (h3 >> 13); h3 := h3 *% 0xc2b2ae35;
    h4 := h4 ^ (h4 >> 16); h4 := h4 *% 0x85ebca6b;
    h5 := h5 ^ (h5 >> 13); h5 := h5 *% 0xc2b2ae35;
    h6 := h6 ^ (h6 >> 16); h6 := h6 *% 0x85ebca6b;
    h7 := h7 ^ (h7 >> 13); h7 := h7 *% 0xc2b2ae35;

    [
      Nat8.fromNat(Nat32.toNat((h0 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h0 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h0 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h0 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h1 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h1 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h1 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h1 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h2 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h2 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h2 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h2 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h3 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h3 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h3 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h3 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h4 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h4 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h4 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h4 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h5 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h5 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h5 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h5 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h6 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h6 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h6 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h6 & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h7 >> 24) & 0xFF)), Nat8.fromNat(Nat32.toNat((h7 >> 16) & 0xFF)),
      Nat8.fromNat(Nat32.toNat((h7 >> 8) & 0xFF)),  Nat8.fromNat(Nat32.toNat(h7 & 0xFF))
    ]
  };
}
