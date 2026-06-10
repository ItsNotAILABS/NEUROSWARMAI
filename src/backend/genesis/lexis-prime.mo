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
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Char "mo:core/Char";
import Hash "mo:core/Hash";
import HashMap "mo:core/HashMap";
import Option "mo:core/Option";

module LexisPrime {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  
  // Concept mapping dimensions
  public let CONCEPT_VECTOR_DIM : Nat = 64;       // Embedding dimension
  public let MAX_CONCEPTS : Nat = 512;            // 500+ concept mappings
  public let CONTEXT_MEMORY_SIZE : Nat = 256;     // Hebbian context memory
  public let CONTEXT_WEIGHT_DIM : Nat = 65536;    // 256 × 256 weights
  
  // Translation thresholds
  public let ALIGNMENT_THRESHOLD : Float = 0.7;
  public let CONFIDENCE_THRESHOLD : Float = 0.6;
  public let AMBIGUITY_THRESHOLD : Float = 0.3;

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONCEPT MAPPING — From natural language to substrate
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ConceptMapping = {
    id : Nat;
    concept : Text;               // Natural language concept
    aliases : [Text];             // Alternative phrasings
    category : ConceptCategory;
    embedding : [Float];          // 64-dimensional embedding
    substrateAddress : SubstrateAddress;
    mathExpression : MathExpression;
    alignmentScore : Float;       // How well mapped
    usageCount : Nat;
    lastUsed : Int;
    confidence : Float;
  };
  
  public type ConceptCategory = {
    #Architecture;        // System structure
    #Behavior;            // System behavior
    #Emotion;             // Emotional states
    #Cognition;           // Cognitive processes
    #Economic;            // Economic concepts
    #Social;              // Social dynamics
    #Physical;            // Physical substrate
    #Temporal;            // Time-related
    #Spatial;             // Space-related
    #Meta;                // Meta-level concepts
    #Doctrine;            // Core doctrine concepts
    #Identity;            // Identity-related
  };
  
  public type SubstrateAddress = {
    shell : Nat8;                 // Which shell (0-11)
    region : Nat16;               // Region within shell (0-511)
    layer : Nat8;                 // Layer (0-7)
    channel : Nat8;               // Channel (0-11)
    nodeRange : (Nat16, Nat16);   // Node range
  };
  
  public type MathExpression = {
    formula : Text;               // Mathematical formula
    variables : [(Text, Text)];   // (variable name, description)
    constraints : [Text];         // Constraints
    units : Text;                 // Output units
    range : (Float, Float);       // Valid range
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CORE DOCTRINE CONCEPTS — The foundational 100
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let CORE_DOCTRINE_CONCEPTS : [ConceptMapping] = [
    // ═══ ARCHITECTURE CONCEPTS ═══
    {
      id = 0;
      concept = "coherence";
      aliases = ["consistency", "unity", "integration", "wholeness"];
      category = #Architecture;
      embedding = [];
      substrateAddress = { shell = 12; region = 0; layer = 0; channel = 0; nodeRange = (0, 511) };
      mathExpression = {
        formula = "C = λC(t-1) + (1-λ)S(t) - μD(t) + ρ×K";
        variables = [("C", "coherence"), ("λ", "momentum"), ("S", "salience"), ("D", "drift"), ("K", "Kuramoto R")];
        constraints = ["C ≥ 0.75 (S₀ floor)"];
        units = "dimensionless";
        range = (0.0, 1.5);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 1;
      concept = "heartbeat";
      aliases = ["beat", "pulse", "tick", "cycle"];
      category = #Temporal;
      embedding = [];
      substrateAddress = { shell = 0; region = 0; layer = 0; channel = 0; nodeRange = (0, 11) };
      mathExpression = {
        formula = "f = 12 Hz";
        variables = [("f", "heartbeat frequency")];
        constraints = ["Synchronized to ICP consensus"];
        units = "Hz";
        range = (11.5, 12.5);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 2;
      concept = "sovereignty";
      aliases = ["autonomy", "independence", "self-rule", "QSOV"];
      category = #Identity;
      embedding = [];
      substrateAddress = { shell = 11; region = 0; layer = 6; channel = 0; nodeRange = (0, 255) };
      mathExpression = {
        formula = "QSOV = 0.35×C + 0.20×S + 0.15×A + 0.15×I + 0.05×R + 0.05×E + 0.05×G";
        variables = [("C", "coherence"), ("S", "stability"), ("A", "autonomy"), ("I", "integrity"), ("R", "resilience"), ("E", "efficiency"), ("G", "growth")];
        constraints = ["QSOV ≥ 0.75"];
        units = "dimensionless";
        range = (0.0, 1.5);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 3;
      concept = "substrate";
      aliases = ["foundation", "base", "ground", "medium"];
      category = #Physical;
      embedding = [];
      substrateAddress = { shell = 0; region = 0; layer = 0; channel = 0; nodeRange = (0, 511) };
      mathExpression = {
        formula = "S = {nodes, weights, phases, amplitudes}";
        variables = [("nodes", "512 processing units"), ("weights", "262,144 connections")];
        constraints = ["All values finite", "Weights in [0, 1]"];
        units = "structure";
        range = (0.0, 1.0);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 4;
      concept = "shell";
      aliases = ["layer", "level", "stratum"];
      category = #Architecture;
      embedding = [];
      substrateAddress = { shell = 0; region = 0; layer = 0; channel = 0; nodeRange = (0, 511) };
      mathExpression = {
        formula = "Shell(k) has α(k) = 0.042 × 0.75^k";
        variables = [("k", "shell index 0-11"), ("α", "plasticity rate")];
        constraints = ["k ∈ [0, 11]"];
        units = "dimensionless";
        range = (0.004, 0.042);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    // ═══ BEHAVIORAL CONCEPTS ═══
    {
      id = 5;
      concept = "learning";
      aliases = ["adaptation", "growth", "improvement", "development"];
      category = #Behavior;
      embedding = [];
      substrateAddress = { shell = 4; region = 0; layer = 3; channel = 0; nodeRange = (0, 255) };
      mathExpression = {
        formula = "dw/dt = η × pre × post - λ × w";
        variables = [("w", "weight"), ("η", "learning rate"), ("pre", "presynaptic activation"), ("post", "postsynaptic activation"), ("λ", "decay")];
        constraints = ["η ∈ [0.001, 0.01]", "w ∈ [0, 1]"];
        units = "dimensionless";
        range = (0.0, 1.0);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 6;
      concept = "memory";
      aliases = ["retention", "storage", "recall", "remembering"];
      category = #Cognition;
      embedding = [];
      substrateAddress = { shell = 5; region = 0; layer = 4; channel = 0; nodeRange = (0, 255) };
      mathExpression = {
        formula = "R(t) = exp(ln(age) × -0.25)";
        variables = [("R", "retention"), ("age", "beats since encoding")];
        constraints = ["Power-law decay"];
        units = "dimensionless";
        range = (0.0, 1.0);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 7;
      concept = "attention";
      aliases = ["focus", "concentration", "salience"];
      category = #Cognition;
      embedding = [];
      substrateAddress = { shell = 4; region = 64; layer = 3; channel = 1; nodeRange = (64, 127) };
      mathExpression = {
        formula = "A(i) = softmax(Q×K^T / √d) × V";
        variables = [("Q", "query"), ("K", "key"), ("V", "value"), ("d", "dimension")];
        constraints = ["Normalized attention weights"];
        units = "dimensionless";
        range = (0.0, 1.0);
      };
      alignmentScore = 0.95;
      usageCount = 0;
      lastUsed = 0;
      confidence = 0.95;
    },
    // ═══ EMOTIONAL CONCEPTS ═══
    {
      id = 8;
      concept = "love";
      aliases = ["S₀", "root constant", "ground state"];
      category = #Emotion;
      embedding = [];
      substrateAddress = { shell = 0; region = 0; layer = 0; channel = 0; nodeRange = (0, 0) };
      mathExpression = {
        formula = "S₀ = 1.0 (constant)";
        variables = [("S₀", "root constant / love")];
        constraints = ["Immutable", "Foundation of all coherence"];
        units = "dimensionless";
        range = (1.0, 1.0);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 9;
      concept = "curiosity";
      aliases = ["exploration", "seeking", "interest"];
      category = #Emotion;
      embedding = [];
      substrateAddress = { shell = 4; region = 128; layer = 3; channel = 2; nodeRange = (128, 191) };
      mathExpression = {
        formula = "Curiosity = baseline + novelty_boost - boredom";
        variables = [("baseline", "0.6"), ("novelty_boost", "0.3 × novelty"), ("boredom", "accumulated boredom")];
        constraints = ["Curiosity ∈ [0.2, 1.0]"];
        units = "dimensionless";
        range = (0.2, 1.0);
      };
      alignmentScore = 0.95;
      usageCount = 0;
      lastUsed = 0;
      confidence = 0.95;
    },
    // ═══ ECONOMIC CONCEPTS ═══
    {
      id = 10;
      concept = "FORMA";
      aliases = ["metabolic fuel", "energy currency"];
      category = #Economic;
      embedding = [];
      substrateAddress = { shell = 7; region = 0; layer = 6; channel = 0; nodeRange = (0, 127) };
      mathExpression = {
        formula = "FORMA_mint = base × coherence × activity";
        variables = [("base", "base mint rate"), ("coherence", "organism coherence"), ("activity", "activation level")];
        constraints = ["Only mints if coherence ≥ 0.75"];
        units = "FORMA tokens";
        range = (0.0, 1000000.0);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
    {
      id = 11;
      concept = "MRC";
      aliases = ["dynasty coin", "sovereign coin"];
      category = #Economic;
      embedding = [];
      substrateAddress = { shell = 7; region = 128; layer = 6; channel = 1; nodeRange = (128, 255) };
      mathExpression = {
        formula = "MRC_yield = 0.85 × ΔH × C × C_adj";
        variables = [("ΔH", "entropy processed"), ("C", "coherence"), ("C_adj", "coherence adjustment")];
        constraints = ["Maxwell's Demon efficiency = 0.85"];
        units = "MRC tokens";
        range = (0.0, 1000000.0);
      };
      alignmentScore = 1.0;
      usageCount = 0;
      lastUsed = 0;
      confidence = 1.0;
    },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN CONTEXT MEMORY — 256 × 256 weights
  // Persistent understanding of context
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HebbianContextMemory = {
    weights : [[var Float]];      // 256 × 256 context weights
    activations : [var Float];    // 256 context activations
    lastUpdate : Int;
    totalUpdates : Nat;
    avgWeight : Float;
    sparsity : Float;
    learningRate : Float;
    decayRate : Float;
  };
  
  public func initHebbianContextMemory() : HebbianContextMemory {
    let weights = Array.init<[var Float]>(CONTEXT_MEMORY_SIZE, func(_ : Nat) : [var Float] {
      Array.init<Float>(CONTEXT_MEMORY_SIZE, func(_ : Nat) : Float { 0.1 })
    });
    
    let activations = Array.init<Float>(CONTEXT_MEMORY_SIZE, func(_ : Nat) : Float { 0.0 });
    
    {
      weights = weights;
      activations = activations;
      lastUpdate = 0;
      totalUpdates = 0;
      avgWeight = 0.1;
      sparsity = 0.0;
      learningRate = 0.01;
      decayRate = 0.001;
    }
  };
  
  // Update context memory with new activation pattern
  public func updateContextMemory(
    memory : HebbianContextMemory,
    newActivations : [Float],
    currentBeat : Int
  ) : () {
    let n = Nat.min(newActivations.size(), CONTEXT_MEMORY_SIZE);
    
    // Update activations
    for (i in Iter.range(0, n - 1)) {
      memory.activations[i] := newActivations[i];
    };
    
    // Hebbian update: dw[i,j] = η × a[i] × a[j] - λ × w[i,j]
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let pre = memory.activations[i];
        let post = memory.activations[j];
        let oldWeight = memory.weights[i][j];
        
        let dw = memory.learningRate * pre * post - memory.decayRate * oldWeight;
        var newWeight = oldWeight + dw;
        
        if (newWeight < 0.0) { newWeight := 0.0 };
        if (newWeight > 1.0) { newWeight := 1.0 };
        
        memory.weights[i][j] := newWeight;
      };
    };
  };
  
  // Retrieve context from memory
  public func retrieveContext(
    memory : HebbianContextMemory,
    query : [Float]
  ) : [Float] {
    let n = Nat.min(query.size(), CONTEXT_MEMORY_SIZE);
    let result = Array.init<Float>(CONTEXT_MEMORY_SIZE, func(_ : Nat) : Float { 0.0 });
    
    // Weighted sum through memory weights
    for (j in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      for (i in Iter.range(0, n - 1)) {
        sum += memory.weights[i][j] * query[i];
      };
      result[j] := sigmoid(sum);
    };
    
    Array.freeze(result)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ARCHITECTURE SYNTHESIS — Coherent system integration
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ArchitectureSynthesis = {
    activePatterns : [Nat];       // Currently active concept IDs
    synthesisBuffer : [var Float]; // 512 synthesis values
    outputBuffer : [var Float];   // 512 output values
    coherenceThreshold : Float;
    integrationStrength : Float;
    conflictResolution : ConflictStrategy;
    lastSynthesis : Int;
  };
  
  public type ConflictStrategy = {
    #MostConfident;       // Use highest confidence
    #Weighted;            // Weighted average
    #Hierarchical;        // Priority by category
    #Consensus;           // Require agreement
  };
  
  public func initArchitectureSynthesis() : ArchitectureSynthesis {
    {
      activePatterns = [];
      synthesisBuffer = Array.init<Float>(512, func(_ : Nat) : Float { 0.0 });
      outputBuffer = Array.init<Float>(512, func(_ : Nat) : Float { 0.0 });
      coherenceThreshold = 0.6;
      integrationStrength = 0.8;
      conflictResolution = #Weighted;
      lastSynthesis = 0;
    }
  };
  
  // Synthesize multiple concepts into coherent architecture
  public func synthesizeArchitecture(
    synthesis : ArchitectureSynthesis,
    concepts : [ConceptMapping],
    contextMemory : HebbianContextMemory,
    currentBeat : Int
  ) : [Float] {
    // Clear buffers
    for (i in Iter.range(0, 511)) {
      synthesis.synthesisBuffer[i] := 0.0;
      synthesis.outputBuffer[i] := 0.0;
    };
    
    // Accumulate weighted contributions from each concept
    var totalWeight : Float = 0.0;
    
    for (concept in concepts.vals()) {
      let weight = concept.alignmentScore * concept.confidence;
      totalWeight += weight;
      
      // Map concept to substrate region
      let (startNode, endNode) = concept.substrateAddress.nodeRange;
      let numNodes = Nat16.toNat(endNode) - Nat16.toNat(startNode) + 1;
      
      for (nodeOffset in Iter.range(0, numNodes - 1)) {
        let globalNode = Nat16.toNat(startNode) + nodeOffset;
        if (globalNode < 512) {
          // Add weighted contribution
          synthesis.synthesisBuffer[globalNode] += weight * 0.5;
        };
      };
    };
    
    // Normalize
    if (totalWeight > 0.0) {
      for (i in Iter.range(0, 511)) {
        synthesis.synthesisBuffer[i] := synthesis.synthesisBuffer[i] / totalWeight;
      };
    };
    
    // Apply context memory modulation
    let contextModulation = retrieveContext(
      contextMemory,
      Array.tabulate<Float>(256, func(i : Nat) : Float {
        if (i < 256) { synthesis.synthesisBuffer[i] } else { 0.0 }
      })
    );
    
    // Blend synthesis with context
    for (i in Iter.range(0, 255)) {
      synthesis.outputBuffer[i] := 
        synthesis.synthesisBuffer[i] * synthesis.integrationStrength +
        contextModulation[i] * (1.0 - synthesis.integrationStrength);
    };
    
    // Copy remaining values
    for (i in Iter.range(256, 511)) {
      synthesis.outputBuffer[i] := synthesis.synthesisBuffer[i];
    };
    
    Array.freeze(synthesis.outputBuffer)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TRANSLATION ENGINE — Input to substrate
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TranslationInput = {
    text : Text;
    source : InputSource;
    timestamp : Int;
    context : [Text];             // Previous context
    priority : Float;
  };
  
  public type InputSource = {
    #Creator;             // Direct creator input
    #Council;             // Council decision
    #System;              // System internal
    #External;            // External API
  };
  
  public type TranslationOutput = {
    substrateAddress : SubstrateAddress;
    mathExpression : MathExpression;
    alignmentScore : Float;
    confidence : Float;
    matchedConcepts : [ConceptMapping];
    synthesizedValues : [Float];  // 512 substrate values
    warnings : [Text];
    processingTime : Nat;         // Beats
  };
  
  public type TranslationEngine = {
    conceptLibrary : [ConceptMapping];
    contextMemory : HebbianContextMemory;
    synthesis : ArchitectureSynthesis;
    recentTranslations : [TranslationOutput];
    totalTranslations : Nat;
    avgAlignmentScore : Float;
    avgConfidence : Float;
  };
  
  public func initTranslationEngine() : TranslationEngine {
    {
      conceptLibrary = CORE_DOCTRINE_CONCEPTS;
      contextMemory = initHebbianContextMemory();
      synthesis = initArchitectureSynthesis();
      recentTranslations = [];
      totalTranslations = 0;
      avgAlignmentScore = 0.0;
      avgConfidence = 0.0;
    }
  };
  
  // Main translation function
  public func translate(
    engine : TranslationEngine,
    input : TranslationInput,
    currentBeat : Int
  ) : TranslationOutput {
    let startBeat = currentBeat;
    
    // 1. Tokenize and preprocess input
    let tokens = tokenize(input.text);
    
    // 2. Match tokens to concepts
    let matchedConcepts = matchConcepts(tokens, engine.conceptLibrary);
    
    // 3. Compute alignment scores
    var totalAlignment : Float = 0.0;
    var totalConfidence : Float = 0.0;
    
    for (concept in matchedConcepts.vals()) {
      totalAlignment += concept.alignmentScore;
      totalConfidence += concept.confidence;
    };
    
    let numMatched = matchedConcepts.size();
    let avgAlignment = if (numMatched > 0) { totalAlignment / Float.fromInt(numMatched) } else { 0.0 };
    let avgConfidence = if (numMatched > 0) { totalConfidence / Float.fromInt(numMatched) } else { 0.0 };
    
    // 4. Synthesize architecture
    let synthesizedValues = synthesizeArchitecture(
      engine.synthesis,
      matchedConcepts,
      engine.contextMemory,
      currentBeat
    );
    
    // 5. Update context memory
    updateContextMemory(
      engine.contextMemory,
      Array.subArray(synthesizedValues, 0, 256),
      currentBeat
    );
    
    // 6. Determine primary substrate address
    let primaryAddress = if (numMatched > 0) {
      matchedConcepts[0].substrateAddress
    } else {
      { shell = 0; region = 0; layer = 0; channel = 0; nodeRange = (0, 0) }
    };
    
    // 7. Combine math expressions
    let combinedMath = if (numMatched > 0) {
      matchedConcepts[0].mathExpression
    } else {
      {
        formula = "unknown";
        variables = [];
        constraints = [];
        units = "";
        range = (0.0, 1.0);
      }
    };
    
    // 8. Generate warnings
    let warnings = Buffer.Buffer<Text>(5);
    
    if (avgAlignment < ALIGNMENT_THRESHOLD) {
      warnings.add("Low alignment score: " # Float.toText(avgAlignment));
    };
    
    if (avgConfidence < CONFIDENCE_THRESHOLD) {
      warnings.add("Low confidence: " # Float.toText(avgConfidence));
    };
    
    if (numMatched == 0) {
      warnings.add("No concept matches found");
    };
    
    if (numMatched > 5) {
      warnings.add("High ambiguity: " # Nat.toText(numMatched) # " concepts matched");
    };
    
    {
      substrateAddress = primaryAddress;
      mathExpression = combinedMath;
      alignmentScore = avgAlignment;
      confidence = avgConfidence;
      matchedConcepts = matchedConcepts;
      synthesizedValues = synthesizedValues;
      warnings = Buffer.toArray(warnings);
      processingTime = 1;
    }
  };
  
  // Tokenize input text
  func tokenize(text : Text) : [Text] {
    let chars = Text.toIter(text);
    let tokens = Buffer.Buffer<Text>(20);
    var current = "";
    
    for (c in chars) {
      if (Char.isAlphabetic(c) or Char.isDigit(c) or c == '_') {
        current := current # Char.toText(c);
      } else {
        if (Text.size(current) > 0) {
          tokens.add(Text.toLowercase(current));
          current := "";
        };
      };
    };
    
    if (Text.size(current) > 0) {
      tokens.add(Text.toLowercase(current));
    };
    
    Buffer.toArray(tokens)
  };
  
  // Match tokens to concepts
  func matchConcepts(
    tokens : [Text],
    library : [ConceptMapping]
  ) : [ConceptMapping] {
    let matches = Buffer.Buffer<ConceptMapping>(10);
    
    for (concept in library.vals()) {
      var matched = false;
      
      // Check main concept
      for (token in tokens.vals()) {
        if (Text.contains(concept.concept, #text token) or
            Text.contains(token, #text concept.concept)) {
          matched := true;
        };
        
        // Check aliases
        for (alias in concept.aliases.vals()) {
          if (Text.contains(alias, #text token) or
              Text.contains(token, #text alias)) {
            matched := true;
          };
        };
      };
      
      if (matched) {
        matches.add(concept);
      };
    };
    
    Buffer.toArray(matches)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE LEXIS PRIME STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LexisPrimeState = {
    translationEngine : TranslationEngine;
    activeTranslations : Nat;
    queuedInputs : [TranslationInput];
    translationHistory : [TranslationOutput];
    conceptExpansions : Nat;      // New concepts learned
    avgResponseTime : Float;
    status : LexisStatus;
    lastActivity : Int;
  };
  
  public type LexisStatus = {
    #Ready;
    #Processing;
    #Learning;
    #Maintenance;
    #Overloaded;
  };
  
  public func initLexisPrimeState() : LexisPrimeState {
    {
      translationEngine = initTranslationEngine();
      activeTranslations = 0;
      queuedInputs = [];
      translationHistory = [];
      conceptExpansions = 0;
      avgResponseTime = 0.0;
      status = #Ready;
      lastActivity = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LEXIS PRIME TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LexisPrimeTickResult = {
    translationsProcessed : Nat;
    avgAlignment : Float;
    avgConfidence : Float;
    conceptsMatched : Nat;
    warningsGenerated : Nat;
  };
  
  public func lexisPrimeTick(
    state : LexisPrimeState,
    inputs : [TranslationInput],
    currentBeat : Int
  ) : (LexisPrimeTickResult, [TranslationOutput]) {
    let outputs = Buffer.Buffer<TranslationOutput>(inputs.size());
    var totalAlignment : Float = 0.0;
    var totalConfidence : Float = 0.0;
    var totalConcepts : Nat = 0;
    var totalWarnings : Nat = 0;
    
    for (input in inputs.vals()) {
      let output = translate(state.translationEngine, input, currentBeat);
      outputs.add(output);
      
      totalAlignment += output.alignmentScore;
      totalConfidence += output.confidence;
      totalConcepts += output.matchedConcepts.size();
      totalWarnings += output.warnings.size();
    };
    
    let numProcessed = inputs.size();
    
    let result : LexisPrimeTickResult = {
      translationsProcessed = numProcessed;
      avgAlignment = if (numProcessed > 0) { totalAlignment / Float.fromInt(numProcessed) } else { 0.0 };
      avgConfidence = if (numProcessed > 0) { totalConfidence / Float.fromInt(numProcessed) } else { 0.0 };
      conceptsMatched = totalConcepts;
      warningsGenerated = totalWarnings;
    };
    
    (result, Buffer.toArray(outputs))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 25)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };

}
