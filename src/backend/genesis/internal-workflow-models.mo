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
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// INTERNAL WORKFLOW MODELS — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// WORKFLOW MODEL CLASSIFICATION:
//
// INTERNAL MODELS — Run inside the organism (this module)
// - Cognitive workflows (thinking, learning, memory)
// - Metabolic workflows (energy, chemistry)
// - Homeostatic workflows (balance, stability)
// - Reproductive workflows (spawning, lineage)
//
// EXTERNAL MODELS — Interface with outside world
// - Sensory workflows (perception, input)
// - Motor workflows (action, output)
// - Social workflows (communication, trust)
// - Economic workflows (tokens, trade)
//
// Each workflow is a mathematical function that:
// 1. Takes inputs from the organism state
// 2. Applies transformation rules
// 3. Produces outputs that modify organism state
// 4. Fires on specific triggers (beat, event, threshold)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module InternalWorkflowModels {

  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let TOTAL_INTERNAL_WORKFLOWS : Nat = 48;
  public let WORKFLOWS_PER_CATEGORY : Nat = 12;
  public let CATEGORY_COUNT : Nat = 4;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowCategory = {
    #Cognitive;     // Thinking, learning, memory
    #Metabolic;     // Energy, chemistry
    #Homeostatic;   // Balance, stability
    #Reproductive;  // Spawning, lineage
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW TRIGGER TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowTrigger = {
    #EveryBeat;                    // Fires every heartbeat
    #EveryNBeats : Nat;            // Fires every N beats
    #OnThreshold : (Text, Float);  // Fires when variable exceeds threshold
    #OnEvent : Text;               // Fires on specific event
    #OnPhase : Nat;                // Fires during specific day/night phase
    #OnJubilee : Text;             // Fires during jubilee events
    #OnOMNIS;                      // Fires during OMNIS
    #OnSacrifice;                  // Fires on sacrifice
    #Conditional : Text;           // Custom condition
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW PRIORITY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowPriority = {
    #Critical;   // Must run, cannot be skipped
    #High;       // Should run, skip only under resource pressure
    #Normal;     // Standard priority
    #Low;        // Can be deferred
    #Background; // Runs when resources available
  };
  
  public func priorityToWeight(priority : WorkflowPriority) : Float {
    switch (priority) {
      case (#Critical) { 1.0 };
      case (#High) { 0.8 };
      case (#Normal) { 0.5 };
      case (#Low) { 0.3 };
      case (#Background) { 0.1 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowDefinition = {
    id : Nat;
    name : Text;
    category : WorkflowCategory;
    description : Text;
    trigger : WorkflowTrigger;
    priority : WorkflowPriority;
    inputVariables : [Text];
    outputVariables : [Text];
    equation : Text;
    dependencies : [Nat]; // Other workflow IDs that must run first
    isEnabled : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW EXECUTION RESULT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowResult = {
    workflowId : Nat;
    beat : Nat;
    timestamp : Int;
    executed : Bool;
    success : Bool;
    inputValues : [(Text, Float)];
    outputValues : [(Text, Float)];
    executionTimeNs : Int;
    errorMessage : ?Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THE 48 INTERNAL WORKFLOWS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getWorkflow(id : Nat) : ?WorkflowDefinition {
    switch (id) {
      // ═══════════════════════════════════════════════════════════════════════════
      // COGNITIVE WORKFLOWS (1-12)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (1) { ?{
        id = 1;
        name = "Hebbian Learning Update";
        category = #Cognitive;
        description = "Update Hebbian weights based on co-activation";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["activations", "currentWeights"];
        outputVariables = ["newWeights"];
        equation = "Δw = η × xᵢ × xⱼ - λ × w";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (2) { ?{
        id = 2;
        name = "Prediction Error Calculation";
        category = #Cognitive;
        description = "Calculate TD prediction error δ";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["reward", "currentStateValue", "nextStateValue", "gamma"];
        outputVariables = ["predictionError"];
        equation = "δ = r + γ × V(s') - V(s)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (3) { ?{
        id = 3;
        name = "Memory Gate Evaluation";
        category = #Cognitive;
        description = "Determine if event should enter long-term memory";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["coherence", "arousal", "predictionError", "alpha", "theta"];
        outputVariables = ["gateOutput"];
        equation = "gate = σ(α × Λ × A × |δ| - θ)";
        dependencies = [2];
        isEnabled = true;
      }};
      
      case (4) { ?{
        id = 4;
        name = "Memory Consolidation";
        category = #Cognitive;
        description = "Strengthen memory traces during rest";
        trigger = #OnPhase(3); // Night phase
        priority = #Normal;
        inputVariables = ["memoryStrength", "consolidationRate"];
        outputVariables = ["newMemoryStrength"];
        equation = "strength(t) = strength(t-1) × (1 + consolidation_rate)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (5) { ?{
        id = 5;
        name = "Pattern Completion";
        category = #Cognitive;
        description = "Retrieve full pattern from partial cue";
        trigger = #Conditional("partial_cue_detected");
        priority = #High;
        inputVariables = ["partialPattern", "storedPatterns"];
        outputVariables = ["completedPattern"];
        equation = "output = attractor(partial_input)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (6) { ?{
        id = 6;
        name = "Schema Formation";
        category = #Cognitive;
        description = "Form new schemas from repeated patterns";
        trigger = #EveryNBeats(50);
        priority = #Normal;
        inputVariables = ["recentPatterns", "existingSchemas"];
        outputVariables = ["newSchemas"];
        equation = "repeated_pattern → stable_schema";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (7) { ?{
        id = 7;
        name = "Attention Allocation";
        category = #Cognitive;
        description = "Allocate attention based on salience";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["salienceMap", "currentAttention", "capacity"];
        outputVariables = ["attentionWeights"];
        equation = "attention = softmax(salience / temperature)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (8) { ?{
        id = 8;
        name = "Working Memory Update";
        category = #Cognitive;
        description = "Update working memory contents";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["newInfo", "currentWM", "gateOutput"];
        outputVariables = ["updatedWM"];
        equation = "WM(t) = gate × newInfo + (1-gate) × WM(t-1)";
        dependencies = [3];
        isEnabled = true;
      }};
      
      case (9) { ?{
        id = 9;
        name = "Decision Making";
        category = #Cognitive;
        description = "Select action using softmax over Q-values";
        trigger = #Conditional("action_required");
        priority = #Critical;
        inputVariables = ["qValues", "temperature"];
        outputVariables = ["actionProbabilities", "selectedAction"];
        equation = "P(a) = softmax(Q(s,a) / τ)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (10) { ?{
        id = 10;
        name = "Q-Value Update";
        category = #Cognitive;
        description = "Update Q-values using TD learning";
        trigger = #Conditional("action_completed");
        priority = #High;
        inputVariables = ["currentQ", "reward", "nextMaxQ", "alpha", "gamma"];
        outputVariables = ["newQ"];
        equation = "Q(s,a) ← Q(s,a) + α × [r + γ × max Q(s',a') - Q(s,a)]";
        dependencies = [2];
        isEnabled = true;
      }};
      
      case (11) { ?{
        id = 11;
        name = "Novelty Detection";
        category = #Cognitive;
        description = "Detect novel patterns and assign novelty scores";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["currentPattern", "knownPatterns"];
        outputVariables = ["noveltyScore", "isNovel"];
        equation = "novelty = 1 - max(similarity(current, known))";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (12) { ?{
        id = 12;
        name = "Knowledge Compounding";
        category = #Cognitive;
        description = "Apply knowledge compounding formula";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["currentKnowledge", "learningRate", "deltaT"];
        outputVariables = ["newKnowledge"];
        equation = "K(t+1) = K(t) × (1 + r_learn)^Δt";
        dependencies = [];
        isEnabled = true;
      }};
      
      // ═══════════════════════════════════════════════════════════════════════════
      // METABOLIC WORKFLOWS (13-24)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (13) { ?{
        id = 13;
        name = "Chemical Decay";
        category = #Metabolic;
        description = "Apply natural decay to all chemicals";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["concentrations", "halfLives"];
        outputVariables = ["decayedConcentrations"];
        equation = "C(t) = C(0) × exp(-ln(2) × t / t½)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (14) { ?{
        id = 14;
        name = "Chemical Crosstalk";
        category = #Metabolic;
        description = "Apply 441 crosstalk interactions";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["concentrations", "crosstalkMatrix"];
        outputVariables = ["modifiedConcentrations"];
        equation = "ΔC_j = Σᵢ crosstalk[i][j] × C_i";
        dependencies = [13];
        isEnabled = true;
      }};
      
      case (15) { ?{
        id = 15;
        name = "PID Homeostatic Control";
        category = #Metabolic;
        description = "Apply PID control to maintain chemical setpoints";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["currentValue", "setpoint", "Kp", "Ki", "Kd", "integral", "prevError"];
        outputVariables = ["controlOutput", "newIntegral"];
        equation = "u(t) = Kp×e + Ki×∫e + Kd×de/dt";
        dependencies = [14];
        isEnabled = true;
      }};
      
      case (16) { ?{
        id = 16;
        name = "Energy Budget Update";
        category = #Metabolic;
        description = "Update ATP/adenosine balance";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["atpLevel", "adenosineLevel", "activity"];
        outputVariables = ["newATP", "newAdenosine"];
        equation = "ΔE = E_in - E_out - E_dissipated";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (17) { ?{
        id = 17;
        name = "Circadian Modulation";
        category = #Metabolic;
        description = "Apply circadian rhythm to chemical baselines";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["baselines", "circadianPhase", "amplitudes", "peakPhases"];
        outputVariables = ["modulatedBaselines"];
        equation = "baseline_mod = baseline × (1 + amplitude × cos(2π × (phase - peak)))";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (18) { ?{
        id = 18;
        name = "Arousal Calculation";
        category = #Metabolic;
        description = "Calculate overall arousal from catecholamines";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["dopamine", "norepinephrine", "epinephrine", "gaba", "melatonin"];
        outputVariables = ["arousal"];
        equation = "arousal = (DA + NE + E + Orexin)/4 - (GABA + Mel)/2 + 0.5";
        dependencies = [14];
        isEnabled = true;
      }};
      
      case (19) { ?{
        id = 19;
        name = "Valence Calculation";
        category = #Metabolic;
        description = "Calculate emotional valence";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["dopamine", "serotonin", "endorphin", "oxytocin", "cortisol"];
        outputVariables = ["valence"];
        equation = "valence = (DA + 5HT + End + Oxy)/5 - (Cort + SubP)/3";
        dependencies = [14];
        isEnabled = true;
      }};
      
      case (20) { ?{
        id = 20;
        name = "E/I Balance Check";
        category = #Metabolic;
        description = "Check glutamate/GABA ratio";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["glutamate", "gaba"];
        outputVariables = ["eiRatio", "isBalanced"];
        equation = "E/I = Glu / GABA; balanced = E/I ∈ [0.8, 1.2]";
        dependencies = [14];
        isEnabled = true;
      }};
      
      case (21) { ?{
        id = 21;
        name = "Stress Response";
        category = #Metabolic;
        description = "Calculate stress level from cortisol and substance P";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["cortisol", "substanceP", "endorphin"];
        outputVariables = ["stressLevel"];
        equation = "stress = (cortisol + substanceP - endorphin) / 2";
        dependencies = [14];
        isEnabled = true;
      }};
      
      case (22) { ?{
        id = 22;
        name = "Sleep Pressure Accumulation";
        category = #Metabolic;
        description = "Accumulate adenosine during wakefulness";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["adenosine", "wakeTime", "activity"];
        outputVariables = ["sleepPressure"];
        equation = "pressure = adenosine × log(1 + wakeTime) × activity";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (23) { ?{
        id = 23;
        name = "Fatigue Accumulation";
        category = #Metabolic;
        description = "Track fatigue based on sustained activity";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["currentFatigue", "activity", "restRate"];
        outputVariables = ["newFatigue"];
        equation = "fatigue = fatigue + activity × 0.01 - rest × restRate";
        dependencies = [16];
        isEnabled = true;
      }};
      
      case (24) { ?{
        id = 24;
        name = "Recovery Rate Calculation";
        category = #Metabolic;
        description = "Calculate recovery rate based on rest state";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["isResting", "sleepPhase", "atpLevel"];
        outputVariables = ["recoveryRate"];
        equation = "recovery = isResting × sleepPhase × sqrt(ATP)";
        dependencies = [16];
        isEnabled = true;
      }};
      
      // ═══════════════════════════════════════════════════════════════════════════
      // HOMEOSTATIC WORKFLOWS (25-36)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (25) { ?{
        id = 25;
        name = "Kuramoto Phase Update";
        category = #Homeostatic;
        description = "Update 64 oscillator phases";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["phases", "frequencies", "couplingK", "weights"];
        outputVariables = ["newPhases"];
        equation = "dθᵢ/dt = ωᵢ + (K/N) Σⱼ w_ij × sin(θⱼ - θᵢ)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (26) { ?{
        id = 26;
        name = "Order Parameter Calculation";
        category = #Homeostatic;
        description = "Calculate Kuramoto order parameter r";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["phases"];
        outputVariables = ["orderParameter", "meanPhase"];
        equation = "r = |1/N Σⱼ exp(i·θⱼ)|";
        dependencies = [25];
        isEnabled = true;
      }};
      
      case (27) { ?{
        id = 27;
        name = "Jasmine Law Check";
        category = #Homeostatic;
        description = "Check Lyapunov stability";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["currentV", "previousV"];
        outputVariables = ["dVdt", "isStable"];
        equation = "dV/dt < 0 when V > V_min";
        dependencies = [26];
        isEnabled = true;
      }};
      
      case (28) { ?{
        id = 28;
        name = "Drift Detection";
        category = #Homeostatic;
        description = "Detect drift from genesis state";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["currentR", "rGenesis", "epsilon"];
        outputVariables = ["driftMagnitude", "isDrifting"];
        equation = "drift = |r_genesis - r_current|; isDrifting = drift > ε";
        dependencies = [26];
        isEnabled = true;
      }};
      
      case (29) { ?{
        id = 29;
        name = "Re-entrainment Pulse";
        category = #Homeostatic;
        description = "Apply correction when drifting";
        trigger = #Conditional("isDrifting");
        priority = #Critical;
        inputVariables = ["currentPhases", "genesisPhases", "strength"];
        outputVariables = ["correctedPhases"];
        equation = "θ_new = θ + strength × sin(θ_genesis - θ)";
        dependencies = [28];
        isEnabled = true;
      }};
      
      case (30) { ?{
        id = 30;
        name = "Sovereign Floor Enforcement";
        category = #Homeostatic;
        description = "Ensure weights don't drop below S₀=0.75";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["weights", "sovereignFloor"];
        outputVariables = ["enforcedWeights"];
        equation = "w = max(w, S₀)";
        dependencies = [1];
        isEnabled = true;
      }};
      
      case (31) { ?{
        id = 31;
        name = "Population Balance";
        category = #Homeostatic;
        description = "Maintain entity population within bounds";
        trigger = #EveryNBeats(10);
        priority = #High;
        inputVariables = ["currentPopulation", "minPopulation", "maxPopulation"];
        outputVariables = ["spawnRate", "cullRate"];
        equation = "spawn if pop < min; cull if pop > max";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (32) { ?{
        id = 32;
        name = "Territory Stability";
        category = #Homeostatic;
        description = "Track territory change rate";
        trigger = #EveryBeat;
        priority = #Normal;
        inputVariables = ["currentTerritory", "previousTerritory"];
        outputVariables = ["territoryChangeRate"];
        equation = "Δterritory = |current - previous|";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (33) { ?{
        id = 33;
        name = "Resource Equilibrium";
        category = #Homeostatic;
        description = "Balance resources across biomes";
        trigger = #EveryNBeats(50);
        priority = #Normal;
        inputVariables = ["biomeResources", "adjacencyMatrix"];
        outputVariables = ["resourceFlows"];
        equation = "flow_ij = diffusion_rate × (R_i - R_j)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (34) { ?{
        id = 34;
        name = "Faction Balance";
        category = #Homeostatic;
        description = "Monitor faction power balance";
        trigger = #EveryNBeats(100);
        priority = #Normal;
        inputVariables = ["factionTerritories", "factionPopulations"];
        outputVariables = ["factionPowerIndex", "imbalanceScore"];
        equation = "power = territory × population; imbalance = max(power) / mean(power)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (35) { ?{
        id = 35;
        name = "Coherence Recovery";
        category = #Homeostatic;
        description = "Natural coherence recovery toward baseline";
        trigger = #EveryBeat;
        priority = #High;
        inputVariables = ["currentCoherence", "baselineCoherence", "recoveryRate"];
        outputVariables = ["newCoherence"];
        equation = "coherence += recoveryRate × (baseline - current)";
        dependencies = [26];
        isEnabled = true;
      }};
      
      case (36) { ?{
        id = 36;
        name = "Danger Zone Decay";
        category = #Homeostatic;
        description = "Decay remembered danger zones over time";
        trigger = #EveryBeat;
        priority = #Low;
        inputVariables = ["dangerZones", "decayRate"];
        outputVariables = ["updatedDangerZones"];
        equation = "danger(t) = danger(t-1) × (1 - decayRate)";
        dependencies = [];
        isEnabled = true;
      }};
      
      // ═══════════════════════════════════════════════════════════════════════════
      // REPRODUCTIVE WORKFLOWS (37-48)
      // ═══════════════════════════════════════════════════════════════════════════
      
      case (37) { ?{
        id = 37;
        name = "Entity Spawn Evaluation";
        category = #Reproductive;
        description = "Determine if conditions allow spawning";
        trigger = #EveryNBeats(10);
        priority = #Normal;
        inputVariables = ["population", "resources", "coherence", "spawnThreshold"];
        outputVariables = ["canSpawn", "spawnProbability"];
        equation = "canSpawn = pop < max AND resources > threshold AND coherence > 0.5";
        dependencies = [31];
        isEnabled = true;
      }};
      
      case (38) { ?{
        id = 38;
        name = "Entity Spawning";
        category = #Reproductive;
        description = "Create new entity with inherited traits";
        trigger = #Conditional("canSpawn");
        priority = #Normal;
        inputVariables = ["parentTraits", "mutation_rate"];
        outputVariables = ["childTraits", "childId"];
        equation = "child = parent × (1 + mutation × random)";
        dependencies = [37];
        isEnabled = true;
      }};
      
      case (39) { ?{
        id = 39;
        name = "Lineage Recording";
        category = #Reproductive;
        description = "Record parent-child relationships";
        trigger = #Conditional("entity_spawned");
        priority = #High;
        inputVariables = ["parentId", "childId", "beat"];
        outputVariables = ["lineageRecord"];
        equation = "lineage[childId] = {parent: parentId, beat: beat}";
        dependencies = [38];
        isEnabled = true;
      }};
      
      case (40) { ?{
        id = 40;
        name = "Pattern Inheritance";
        category = #Reproductive;
        description = "Transfer learned patterns to offspring";
        trigger = #Conditional("entity_spawned");
        priority = #Normal;
        inputVariables = ["parentPatterns", "inheritanceRate"];
        outputVariables = ["childPatterns"];
        equation = "child_patterns = parent_patterns × inheritance_rate";
        dependencies = [38];
        isEnabled = true;
      }};
      
      case (41) { ?{
        id = 41;
        name = "Weight Inheritance";
        category = #Reproductive;
        description = "Transfer Hebbian weights to offspring";
        trigger = #Conditional("entity_spawned");
        priority = #Normal;
        inputVariables = ["parentWeights", "inheritanceRate", "sovereignFloor"];
        outputVariables = ["childWeights"];
        equation = "child_w = max(parent_w × inheritance + random × (1-inheritance), S₀)";
        dependencies = [38];
        isEnabled = true;
      }};
      
      case (42) { ?{
        id = 42;
        name = "Faction Assignment";
        category = #Reproductive;
        description = "Assign faction to new entity";
        trigger = #Conditional("entity_spawned");
        priority = #High;
        inputVariables = ["parentFaction", "biomeOwner", "factionInfluences"];
        outputVariables = ["childFaction"];
        equation = "faction = weighted_choice(parent, biome, influences)";
        dependencies = [38];
        isEnabled = true;
      }};
      
      case (43) { ?{
        id = 43;
        name = "Death Evaluation";
        category = #Reproductive;
        description = "Determine if entity should die";
        trigger = #EveryBeat;
        priority = #Critical;
        inputVariables = ["health", "energy", "age", "sacrificeProbability"];
        outputVariables = ["shouldDie", "deathCause"];
        equation = "die if health < 0 OR energy < 0 OR random < sacrifice_prob";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (44) { ?{
        id = 44;
        name = "Entity Death";
        category = #Reproductive;
        description = "Process entity death and cleanup";
        trigger = #Conditional("shouldDie");
        priority = #Critical;
        inputVariables = ["entityId", "position", "faction"];
        outputVariables = ["deathRecord"];
        equation = "record death, update population, trigger grief";
        dependencies = [43];
        isEnabled = true;
      }};
      
      case (45) { ?{
        id = 45;
        name = "Generation Counter";
        category = #Reproductive;
        description = "Track generational progression";
        trigger = #Conditional("entity_spawned");
        priority = #Low;
        inputVariables = ["parentGeneration"];
        outputVariables = ["childGeneration", "generationStats"];
        equation = "child_gen = parent_gen + 1";
        dependencies = [38];
        isEnabled = true;
      }};
      
      case (46) { ?{
        id = 46;
        name = "Trait Mutation";
        category = #Reproductive;
        description = "Apply random mutations to inherited traits";
        trigger = #Conditional("entity_spawned");
        priority = #Normal;
        inputVariables = ["traits", "mutationRate", "mutationMagnitude"];
        outputVariables = ["mutatedTraits"];
        equation = "trait_new = trait × (1 + rate × magnitude × random)";
        dependencies = [38];
        isEnabled = true;
      }};
      
      case (47) { ?{
        id = 47;
        name = "Squad Reformation";
        category = #Reproductive;
        description = "Reform squads when members die or spawn";
        trigger = #Conditional("population_changed");
        priority = #Normal;
        inputVariables = ["entities", "squadAssignments", "maxSquadSize"];
        outputVariables = ["newSquadAssignments"];
        equation = "redistribute entities into squads of optimal size";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (48) { ?{
        id = 48;
        name = "Population Census";
        category = #Reproductive;
        description = "Update population statistics";
        trigger = #EveryNBeats(10);
        priority = #Normal;
        inputVariables = ["entities"];
        outputVariables = ["totalPopulation", "byFaction", "byDrive", "avgHealth"];
        equation = "census = aggregate(entities)";
        dependencies = [];
        isEnabled = true;
      }};
      
      case (_) { null };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKFLOW STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkflowExecutionState = {
    var lastExecutionBeat : [var Nat]; // Per workflow
    var executionCounts : [var Nat]; // Total executions per workflow
    var totalExecutions : Nat;
    var failedExecutions : Nat;
    var averageExecutionTime : Float;
    var pendingWorkflows : Buffer.Buffer<Nat>;
    var completedThisBeat : Buffer.Buffer<Nat>;
  };
  
  public func initWorkflowState() : WorkflowExecutionState {
    {
      var lastExecutionBeat = Array.init<Nat>(TOTAL_INTERNAL_WORKFLOWS + 1, 0);
      var executionCounts = Array.init<Nat>(TOTAL_INTERNAL_WORKFLOWS + 1, 0);
      var totalExecutions = 0;
      var failedExecutions = 0;
      var averageExecutionTime = 0.0;
      var pendingWorkflows = Buffer.Buffer<Nat>(TOTAL_INTERNAL_WORKFLOWS);
      var completedThisBeat = Buffer.Buffer<Nat>(TOTAL_INTERNAL_WORKFLOWS);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getAllWorkflows() : [WorkflowDefinition] {
    let workflows = Buffer.Buffer<WorkflowDefinition>(TOTAL_INTERNAL_WORKFLOWS);
    for (id in Iter.range(1, TOTAL_INTERNAL_WORKFLOWS)) {
      switch (getWorkflow(id)) {
        case (?wf) { workflows.add(wf) };
        case (null) {};
      };
    };
    Buffer.toArray(workflows)
  };
  
  public func getWorkflowsByCategory(category : WorkflowCategory) : [WorkflowDefinition] {
    let workflows = Buffer.Buffer<WorkflowDefinition>(WORKFLOWS_PER_CATEGORY);
    for (id in Iter.range(1, TOTAL_INTERNAL_WORKFLOWS)) {
      switch (getWorkflow(id)) {
        case (?wf) {
          if (wf.category == category) {
            workflows.add(wf);
          };
        };
        case (null) {};
      };
    };
    Buffer.toArray(workflows)
  };
  
  public func getWorkflowsByPriority(priority : WorkflowPriority) : [WorkflowDefinition] {
    let workflows = Buffer.Buffer<WorkflowDefinition>(TOTAL_INTERNAL_WORKFLOWS);
    for (id in Iter.range(1, TOTAL_INTERNAL_WORKFLOWS)) {
      switch (getWorkflow(id)) {
        case (?wf) {
          if (wf.priority == priority) {
            workflows.add(wf);
          };
        };
        case (null) {};
      };
    };
    Buffer.toArray(workflows)
  };

}
