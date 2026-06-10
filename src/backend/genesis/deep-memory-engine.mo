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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DEEP MEMORY ENGINE — COMPLETE EPISODIC & SEMANTIC MEMORY WITH CONSOLIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Memory is the foundation of intelligence. This module implements:
//
// MEMORY SYSTEMS ARCHITECTURE:
// ════════════════════════════
//
// 1. SENSORY MEMORY (Iconic/Echoic)
//    - Ultra-short duration (< 1 second)
//    - High capacity, rapid decay
//    - Pre-attentive filtering
//
// 2. WORKING MEMORY (Baddeley Model)
//    - Central executive (attention control)
//    - Phonological loop (verbal/acoustic)
//    - Visuospatial sketchpad (spatial/visual)
//    - Episodic buffer (integration)
//    - Limited capacity (~7±2 items)
//
// 3. EPISODIC MEMORY (Tulving)
//    - Autobiographical events
//    - Temporal context (when)
//    - Spatial context (where)
//    - Emotional valence
//    - Self-reference
//
// 4. SEMANTIC MEMORY
//    - General knowledge
//    - Concepts and categories
//    - Facts without context
//    - Schemas and scripts
//
// 5. PROCEDURAL MEMORY
//    - Skills and habits
//    - Motor sequences
//    - Implicit learning
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEMORY CONSOLIDATION (Two-Stage Model):
// ═══════════════════════════════════════
//
// 1. HIPPOCAMPAL ENCODING (Fast Learning)
//    - Rapid binding of features
//    - Pattern separation (orthogonalization)
//    - Context-dependent storage
//
// 2. NEOCORTICAL CONSOLIDATION (Slow Learning)
//    - Gradual transfer to cortex
//    - Schema integration
//    - Sleep-dependent replay
//
// MATHEMATICAL MODELS:
// ═══════════════════
//
// Hopfield Network (Associative Memory):
//   E = -0.5 × Σᵢⱼ wᵢⱼ × sᵢ × sⱼ
//   Update: sᵢ = sign(Σⱼ wᵢⱼ × sⱼ)
//
// Modern Hopfield (Continuous):
//   E = -lse(β × Wᵀx) + 0.5 × xᵀx
//   where lse = log-sum-exp
//
// Complementary Learning Systems:
//   Hippocampus: sparse, pattern-separated
//   Cortex: distributed, overlapping
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// INTERTWINING WITH OTHER SYSTEMS:
// ════════════════════════════════
//
// 1. KURAMOTO → MEMORY:
//    - Theta rhythm (4-8 Hz) gates encoding
//    - Gamma bursts mark salient events
//    - Coherence at encoding predicts recall
//
// 2. MEMORY → KURAMOTO:
//    - Memory retrieval triggers phase reset
//    - Recalled patterns modulate oscillations
//    - Memory load affects coherence
//
// 3. HEBBIAN → MEMORY:
//    - Hebbian plasticity IS memory encoding
//    - Weight patterns store memories
//    - Synaptic consolidation = memory consolidation
//
// 4. MEMORY → HEBBIAN:
//    - Memory replay provides training patterns
//    - Sleep replay strengthens connections
//    - Memory retrieval activates Hebbian circuits
//
// 5. FREE ENERGY → MEMORY:
//    - Prediction errors trigger encoding
//    - Surprising events are remembered
//    - Generative model IS semantic memory
//
// 6. MEMORY → FREE ENERGY:
//    - Memories constrain predictions
//    - Prior beliefs from past experience
//    - Pattern completion via inference
//
// 7. Q-LEARNING → MEMORY:
//    - Reward tags memories for consolidation
//    - Value signals determine priority
//    - Experience replay FROM memory
//
// 8. MEMORY → Q-LEARNING:
//    - State representations from memory
//    - Context from episodic retrieval
//    - Experience buffer for learning
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module DeepMemoryEngine {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FUNDAMENTAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846264338327950288419716939937510;
  public let E : Float = 2.71828182845904523536028747135266249775724709369996;
  public let LN_2 : Float = 0.69314718055994530941723212145817656807550013436026;
  
  // Organism constants
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  public let NUM_NODES : Nat = 12;
  public let PATTERN_SIZE : Nat = 64;
  public let WORKING_MEMORY_CAPACITY : Nat = 7;
  public let EPISODIC_CAPACITY : Nat = 10000;
  public let SEMANTIC_CAPACITY : Nat = 1000;
  public let HOPFIELD_SIZE : Nat = 128;
  
  // Memory time constants
  public let SENSORY_DECAY : Float = 100.0;          // ms
  public let WORKING_DECAY : Float = 30000.0;        // 30 seconds
  public let SHORT_TERM_DECAY : Float = 3600000.0;   // 1 hour
  public let LONG_TERM_DECAY : Float = 86400000.0;   // 1 day (very slow)
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: SENSORY MEMORY — THE GATEWAY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Sensory memory holds raw perceptual input briefly before processing.
  // Implements iconic (visual) and echoic (auditory) stores.
  //
  
  public type SensoryBuffer = {
    var traces : [[var Float]];          // Raw sensory traces
    var timestamps : [var Int];          // When each trace arrived
    var decayRates : [var Float];        // How fast each decays
    var attentionMask : [var Float];     // What's being attended to
    var writeIndex : Nat;
    var capacity : Nat;
  };
  
  public type SensoryMemory = {
    iconic : SensoryBuffer;              // Visual
    echoic : SensoryBuffer;              // Auditory
    var attentionalSpotlight : [var Float];  // What's in focus
    var attentionWidth : Float;          // Breadth of attention
    var filterThreshold : Float;         // Minimum strength to pass
  };
  
  public let SENSORY_BUFFER_SIZE : Nat = 16;
  
  // Initialize sensory buffer
  func initSensoryBuffer(size : Nat) : SensoryBuffer {
    {
      var traces = Array.init<[var Float]>(size, func(_ : Nat) : [var Float] {
        Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var timestamps = Array.init<Int>(size, func(_ : Nat) : Int { 0 });
      var decayRates = Array.init<Float>(size, func(_ : Nat) : Float { SENSORY_DECAY });
      var attentionMask = Array.init<Float>(size, func(_ : Nat) : Float { 0.0 });
      var writeIndex = 0;
      var capacity = size;
    }
  };
  
  // Initialize sensory memory
  public func initSensoryMemory() : SensoryMemory {
    {
      iconic = initSensoryBuffer(SENSORY_BUFFER_SIZE);
      echoic = initSensoryBuffer(SENSORY_BUFFER_SIZE);
      var attentionalSpotlight = Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.5 });
      var attentionWidth = 0.3;
      var filterThreshold = 0.2;
    }
  };
  
  // Register new sensory input
  public func registerSensoryInput(
    memory : SensoryMemory,
    input : [Float],
    isVisual : Bool,
    currentTime : Int
  ) {
    let buffer = if (isVisual) { memory.iconic } else { memory.echoic };
    let idx = buffer.writeIndex;
    
    // Copy input
    for (i in Iter.range(0, PATTERN_SIZE - 1)) {
      buffer.traces[idx][i] := if (i < Array.size(input)) { input[i] } else { 0.0 };
    };
    
    buffer.timestamps[idx] := currentTime;
    buffer.writeIndex := (idx + 1) % buffer.capacity;
    
    // Apply attention filter
    for (i in Iter.range(0, PATTERN_SIZE - 1)) {
      buffer.attentionMask[idx] := memory.attentionalSpotlight[i];
    };
  };
  
  // Decay sensory traces
  public func decaySensoryTraces(memory : SensoryMemory, currentTime : Int) {
    for (buffer in [memory.iconic, memory.echoic].vals()) {
      for (i in Iter.range(0, buffer.capacity - 1)) {
        let age = Float.fromInt(currentTime - buffer.timestamps[i]);
        let decay = exp(-age / buffer.decayRates[i]);
        
        for (j in Iter.range(0, PATTERN_SIZE - 1)) {
          buffer.traces[i][j] := buffer.traces[i][j] * decay;
        };
      };
    };
  };
  
  // Get attended sensory content
  public func getAttendedContent(memory : SensoryMemory) : [Float] {
    Array.tabulate<Float>(PATTERN_SIZE, func(i : Nat) : Float {
      var sum : Float = 0.0;
      var weight : Float = 0.0;
      
      // Blend from both buffers, weighted by attention
      for (j in Iter.range(0, SENSORY_BUFFER_SIZE - 1)) {
        let iconicVal = memory.iconic.traces[j][i];
        let echoicVal = memory.echoic.traces[j][i];
        let attn = memory.attentionalSpotlight[i];
        
        sum += attn * (iconicVal + echoicVal);
        weight += attn;
      };
      
      if (weight > 0.01) { sum / weight } else { 0.0 }
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: WORKING MEMORY — THE WORKSPACE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Working memory holds and manipulates information for current tasks.
  // Baddeley's model: central executive + slave systems + episodic buffer.
  //
  
  public type WorkingMemorySlot = {
    var content : [var Float];
    var strength : Float;
    var lastAccess : Int;
    var accessCount : Nat;
    var binding : ?Nat;              // Bound to another slot?
    var isFocused : Bool;
  };
  
  public type CentralExecutive = {
    var attentionFocus : Nat;        // Which slot is focused
    var cognitiveLoad : Float;       // Current load (0-1)
    var switchCost : Float;          // Cost of switching focus
    var inhibitionStrength : Float;  // Ability to suppress
    var updateRate : Float;          // How fast contents change
  };
  
  public type WorkingMemory = {
    var slots : [var WorkingMemorySlot];
    executive : CentralExecutive;
    var phonologicalLoop : [var Float];      // Verbal rehearsal
    var visuospatialSketchpad : [var Float]; // Visual imagery
    var episodicBuffer : [[var Float]];      // Integration buffer
    var totalCapacity : Nat;
    var usedCapacity : Nat;
    var rehearsalRate : Float;
  };
  
  // Initialize working memory
  public func initWorkingMemory() : WorkingMemory {
    let slots = Array.init<WorkingMemorySlot>(WORKING_MEMORY_CAPACITY, func(_ : Nat) : WorkingMemorySlot {
      {
        var content = Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 });
        var strength = 0.0;
        var lastAccess = 0;
        var accessCount = 0;
        var binding = null;
        var isFocused = false;
      }
    });
    
    {
      var slots = slots;
      executive = {
        var attentionFocus = 0;
        var cognitiveLoad = 0.0;
        var switchCost = 0.1;
        var inhibitionStrength = 0.5;
        var updateRate = 0.1;
      };
      var phonologicalLoop = Array.init<Float>(PATTERN_SIZE / 2, func(_ : Nat) : Float { 0.0 });
      var visuospatialSketchpad = Array.init<Float>(PATTERN_SIZE / 2, func(_ : Nat) : Float { 0.0 });
      var episodicBuffer = Array.init<[var Float]>(4, func(_ : Nat) : [var Float] {
        Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var totalCapacity = WORKING_MEMORY_CAPACITY;
      var usedCapacity = 0;
      var rehearsalRate = 0.1;
    }
  };
  
  // Load item into working memory
  public func loadIntoWorkingMemory(
    wm : WorkingMemory,
    pattern : [Float],
    currentTime : Int
  ) : Bool {
    // Find empty or weakest slot
    var targetSlot : Nat = 0;
    var minStrength : Float = 1000.0;
    
    for (i in Iter.range(0, WORKING_MEMORY_CAPACITY - 1)) {
      if (wm.slots[i].strength < minStrength) {
        minStrength := wm.slots[i].strength;
        targetSlot := i;
      };
    };
    
    // Check cognitive load
    if (wm.executive.cognitiveLoad > 0.9) {
      return false;  // Too loaded
    };
    
    // Load pattern
    let slot = wm.slots[targetSlot];
    for (i in Iter.range(0, PATTERN_SIZE - 1)) {
      slot.content[i] := if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
    };
    slot.strength := 1.0;
    slot.lastAccess := currentTime;
    slot.accessCount := 1;
    slot.isFocused := false;
    
    // Update load
    wm.usedCapacity := 0;
    for (i in Iter.range(0, WORKING_MEMORY_CAPACITY - 1)) {
      if (wm.slots[i].strength > 0.1) {
        wm.usedCapacity += 1;
      };
    };
    wm.executive.cognitiveLoad := Float.fromInt(wm.usedCapacity) / Float.fromInt(wm.totalCapacity);
    
    true
  };
  
  // Focus attention on a slot
  public func focusWorkingMemory(wm : WorkingMemory, slotIndex : Nat, currentTime : Int) {
    if (slotIndex >= WORKING_MEMORY_CAPACITY) { return };
    
    // Apply switch cost if changing focus
    if (wm.executive.attentionFocus != slotIndex) {
      wm.executive.cognitiveLoad := wm.executive.cognitiveLoad + wm.executive.switchCost;
    };
    
    // Unfocus previous
    wm.slots[wm.executive.attentionFocus].isFocused := false;
    
    // Focus new
    wm.executive.attentionFocus := slotIndex;
    let slot = wm.slots[slotIndex];
    slot.isFocused := true;
    slot.strength := Float.min(1.0, slot.strength + 0.2);
    slot.lastAccess := currentTime;
    slot.accessCount += 1;
  };
  
  // Rehearse items in working memory
  public func rehearseWorkingMemory(wm : WorkingMemory, currentTime : Int) {
    // Decay unfocused items, maintain focused
    for (i in Iter.range(0, WORKING_MEMORY_CAPACITY - 1)) {
      let slot = wm.slots[i];
      let age = Float.fromInt(currentTime - slot.lastAccess);
      
      if (slot.isFocused) {
        // Rehearsal maintains strength
        slot.strength := Float.min(1.0, slot.strength + wm.rehearsalRate);
      } else {
        // Decay
        slot.strength := slot.strength * exp(-age / WORKING_DECAY);
      };
    };
    
    // Recalculate load
    wm.usedCapacity := 0;
    for (i in Iter.range(0, WORKING_MEMORY_CAPACITY - 1)) {
      if (wm.slots[i].strength > 0.1) {
        wm.usedCapacity += 1;
      };
    };
    wm.executive.cognitiveLoad := Float.fromInt(wm.usedCapacity) / Float.fromInt(wm.totalCapacity);
  };
  
  // Get current working memory contents
  public func getWorkingMemoryContents(wm : WorkingMemory) : [[Float]] {
    Array.tabulate<[Float]>(wm.usedCapacity, func(i : Nat) : [Float] {
      if (i < WORKING_MEMORY_CAPACITY and wm.slots[i].strength > 0.1) {
        Array.freeze(wm.slots[i].content)
      } else { [] }
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: EPISODIC MEMORY — PERSONAL HISTORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Episodic memory stores autobiographical events with rich context.
  // Each episode includes: what, when, where, emotional state.
  //
  
  public type Episode = {
    id : Nat;
    
    // Content
    var pattern : [var Float];           // The experience pattern
    
    // Temporal context
    createdAtBeat : Nat;                 // When encoded
    var lastAccessBeat : Nat;            // When last retrieved
    var accessCount : Nat;               // How often retrieved
    
    // Spatial context  
    var locationContext : [var Float];   // Where it happened
    
    // Emotional context
    var emotionalValence : Float;        // Positive/negative
    var arousalLevel : Float;            // Intensity
    var reward : Float;                  // Associated reward
    
    // Self-reference
    var selfRelevance : Float;           // How relevant to self
    var agentPerspective : Bool;         // First-person?
    
    // Memory strength
    var strength : Float;                // Overall memory strength
    var consolidationLevel : Float;      // 0=hippocampal, 1=neocortical
    var isConsolidated : Bool;
    
    // Connections
    var similarEpisodes : [Nat];         // Linked memories
    var semanticTags : [Text];           // Conceptual labels
  };
  
  public type EpisodicMemory = {
    var episodes : [var Episode];
    var writeIndex : Nat;
    var totalEpisodes : Nat;
    var capacity : Nat;
    
    // Retrieval state
    var lastRetrievedIndex : ?Nat;
    var retrievalContext : [var Float];
    var retrievalThreshold : Float;
    
    // Statistics
    var avgStrength : Float;
    var avgConsolidation : Float;
    var matriarchIndex : Nat;            // Strongest memory
    var matriarchStrength : Float;
  };
  
  // Initialize episodic memory
  public func initEpisodicMemory() : EpisodicMemory {
    let emptyEpisode : Episode = {
      id = 0;
      var pattern = Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 });
      createdAtBeat = 0;
      var lastAccessBeat = 0;
      var accessCount = 0;
      var locationContext = Array.init<Float>(NUM_NODES, func(_ : Nat) : Float { 0.0 });
      var emotionalValence = 0.0;
      var arousalLevel = 0.0;
      var reward = 0.0;
      var selfRelevance = 0.0;
      var agentPerspective = true;
      var strength = 0.0;
      var consolidationLevel = 0.0;
      var isConsolidated = false;
      var similarEpisodes = [];
      var semanticTags = [];
    };
    
    {
      var episodes = Array.init<Episode>(EPISODIC_CAPACITY, func(_ : Nat) : Episode { emptyEpisode });
      var writeIndex = 0;
      var totalEpisodes = 0;
      var capacity = EPISODIC_CAPACITY;
      var lastRetrievedIndex = null;
      var retrievalContext = Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 });
      var retrievalThreshold = 0.5;
      var avgStrength = 0.0;
      var avgConsolidation = 0.0;
      var matriarchIndex = 0;
      var matriarchStrength = 0.0;
    }
  };
  
  // Encode new episode
  // INTERTWINING: Receives signals from Kuramoto (coherence), Q-learning (reward)
  public func encodeEpisode(
    memory : EpisodicMemory,
    pattern : [Float],
    locationContext : [Float],
    kuramotoCoherence : Float,           // ← INTERTWINING: Kuramoto
    reward : Float,                      // ← INTERTWINING: Q-learning
    predictionError : Float,             // ← INTERTWINING: Free Energy
    currentBeat : Nat
  ) : Nat {
    let idx = memory.writeIndex;
    let episode = memory.episodes[idx];
    
    // Copy pattern
    for (i in Iter.range(0, PATTERN_SIZE - 1)) {
      episode.pattern[i] := if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
    };
    
    // Copy location context
    for (i in Iter.range(0, NUM_NODES - 1)) {
      episode.locationContext[i] := if (i < Array.size(locationContext)) { locationContext[i] } else { 0.0 };
    };
    
    // Set emotional context
    episode.emotionalValence := reward;
    episode.arousalLevel := Float.abs(predictionError);
    episode.reward := reward;
    
    // Self-reference (placeholder)
    episode.selfRelevance := 0.5 + 0.5 * kuramotoCoherence;
    episode.agentPerspective := true;
    
    // Initial memory strength based on:
    // - Coherence at encoding (theta rhythm)
    // - Surprise (prediction error)
    // - Emotional intensity
    let encodingStrength = 0.3 * kuramotoCoherence + 
                          0.3 * Float.abs(predictionError) + 
                          0.4 * Float.abs(reward);
    episode.strength := clamp(encodingStrength, 0.1, 1.0);
    episode.consolidationLevel := 0.0;  // Starts in hippocampus
    episode.isConsolidated := false;
    
    // Timestamps
    episode.lastAccessBeat := currentBeat;
    episode.accessCount := 0;
    
    // Update indices
    memory.writeIndex := (idx + 1) % memory.capacity;
    memory.totalEpisodes := Nat.min(memory.totalEpisodes + 1, memory.capacity);
    
    // Check if new matriarch
    if (episode.strength > memory.matriarchStrength) {
      memory.matriarchStrength := episode.strength;
      memory.matriarchIndex := idx;
    };
    
    idx
  };
  
  // Retrieve episode by similarity
  public func retrieveEpisodeBySimilarity(
    memory : EpisodicMemory,
    cue : [Float],
    currentBeat : Nat
  ) : ?Nat {
    if (memory.totalEpisodes == 0) { return null };
    
    var bestMatch : Nat = 0;
    var bestSimilarity : Float = -1.0;
    
    let limit = Nat.min(memory.totalEpisodes, memory.capacity);
    
    for (i in Iter.range(0, limit - 1)) {
      let episode = memory.episodes[i];
      
      if (episode.strength > 0.1) {
        let similarity = cosineSimilarity(cue, Array.freeze(episode.pattern));
        let strengthModulated = similarity * episode.strength;
        
        if (strengthModulated > bestSimilarity) {
          bestSimilarity := strengthModulated;
          bestMatch := i;
        };
      };
    };
    
    if (bestSimilarity > memory.retrievalThreshold) {
      let episode = memory.episodes[bestMatch];
      episode.accessCount += 1;
      episode.lastAccessBeat := currentBeat;
      episode.strength := Float.min(1.0, episode.strength + 0.1);  // Retrieval strengthens
      memory.lastRetrievedIndex := ?bestMatch;
      ?bestMatch
    } else {
      null
    }
  };
  
  // Retrieve episode by emotional similarity
  public func retrieveEpisodeByEmotion(
    memory : EpisodicMemory,
    targetValence : Float,
    targetArousal : Float,
    currentBeat : Nat
  ) : ?Nat {
    if (memory.totalEpisodes == 0) { return null };
    
    var bestMatch : Nat = 0;
    var bestScore : Float = -1.0;
    
    let limit = Nat.min(memory.totalEpisodes, memory.capacity);
    
    for (i in Iter.range(0, limit - 1)) {
      let episode = memory.episodes[i];
      
      if (episode.strength > 0.1) {
        let valenceDiff = Float.abs(episode.emotionalValence - targetValence);
        let arousalDiff = Float.abs(episode.arousalLevel - targetArousal);
        let emotionalSim = 1.0 - 0.5 * (valenceDiff + arousalDiff);
        let score = emotionalSim * episode.strength;
        
        if (score > bestScore) {
          bestScore := score;
          bestMatch := i;
        };
      };
    };
    
    if (bestScore > 0.3) {
      let episode = memory.episodes[bestMatch];
      episode.accessCount += 1;
      episode.lastAccessBeat := currentBeat;
      memory.lastRetrievedIndex := ?bestMatch;
      ?bestMatch
    } else {
      null
    }
  };
  
  // Get episode pattern
  public func getEpisodePattern(memory : EpisodicMemory, index : Nat) : ?[Float] {
    if (index >= memory.totalEpisodes) { return null };
    ?Array.freeze(memory.episodes[index].pattern)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: SEMANTIC MEMORY — KNOWLEDGE & CONCEPTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Semantic memory stores general knowledge independent of specific episodes.
  // Organized as a network of concepts with associations.
  //
  
  public type Concept = {
    id : Nat;
    name : Text;
    var prototype : [var Float];         // Prototypical pattern
    var exemplars : [[Float]];           // Specific instances
    var associations : [(Nat, Float)];   // Links to other concepts
    var hierarchyParent : ?Nat;          // Superordinate concept
    var hierarchyChildren : [Nat];       // Subordinate concepts
    var frequency : Float;               // How often encountered
    var strength : Float;                // Overall activation potential
  };
  
  public type SemanticMemory = {
    var concepts : [var Concept];
    var conceptCount : Nat;
    var capacity : Nat;
    var associationMatrix : [[var Float]]; // Concept-concept associations
    var spreadingActivation : [var Float]; // Current activation levels
    var activationDecay : Float;
  };
  
  // Initialize semantic memory
  public func initSemanticMemory() : SemanticMemory {
    let emptyConcept : Concept = {
      id = 0;
      name = "";
      var prototype = Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 });
      var exemplars = [];
      var associations = [];
      var hierarchyParent = null;
      var hierarchyChildren = [];
      var frequency = 0.0;
      var strength = 0.0;
    };
    
    {
      var concepts = Array.init<Concept>(SEMANTIC_CAPACITY, func(_ : Nat) : Concept { emptyConcept });
      var conceptCount = 0;
      var capacity = SEMANTIC_CAPACITY;
      var associationMatrix = Array.init<[var Float]>(SEMANTIC_CAPACITY, func(_ : Nat) : [var Float] {
        Array.init<Float>(SEMANTIC_CAPACITY, func(_ : Nat) : Float { 0.0 })
      });
      var spreadingActivation = Array.init<Float>(SEMANTIC_CAPACITY, func(_ : Nat) : Float { 0.0 });
      var activationDecay = 0.9;
    }
  };
  
  // Add or update concept
  public func addConcept(
    memory : SemanticMemory,
    name : Text,
    pattern : [Float],
    parentConcept : ?Nat
  ) : Nat {
    let idx = memory.conceptCount;
    if (idx >= memory.capacity) { return 0 };  // Full
    
    let concept = memory.concepts[idx];
    
    // Set basic info
    // Note: can't reassign name due to immutability, but pattern is mutable
    for (i in Iter.range(0, PATTERN_SIZE - 1)) {
      concept.prototype[i] := if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
    };
    
    concept.frequency := 1.0;
    concept.strength := 0.5;
    concept.hierarchyParent := parentConcept;
    
    memory.conceptCount += 1;
    idx
  };
  
  // Associate two concepts
  public func associateConcepts(
    memory : SemanticMemory,
    concept1 : Nat,
    concept2 : Nat,
    strength : Float
  ) {
    if (concept1 >= memory.conceptCount or concept2 >= memory.conceptCount) { return };
    
    memory.associationMatrix[concept1][concept2] := strength;
    memory.associationMatrix[concept2][concept1] := strength;  // Symmetric
  };
  
  // Spreading activation from a concept
  public func spreadActivation(memory : SemanticMemory, sourceConcept : Nat, initialStrength : Float) {
    if (sourceConcept >= memory.conceptCount) { return };
    
    // Reset activation
    for (i in Iter.range(0, memory.conceptCount - 1)) {
      memory.spreadingActivation[i] := 0.0;
    };
    
    // Set source
    memory.spreadingActivation[sourceConcept] := initialStrength;
    
    // Spread (one step)
    let tempActivation = Array.init<Float>(memory.conceptCount, func(_ : Nat) : Float { 0.0 });
    
    for (i in Iter.range(0, memory.conceptCount - 1)) {
      var incoming : Float = 0.0;
      for (j in Iter.range(0, memory.conceptCount - 1)) {
        incoming += memory.associationMatrix[j][i] * memory.spreadingActivation[j];
      };
      tempActivation[i] := memory.activationDecay * memory.spreadingActivation[i] + 0.5 * incoming;
    };
    
    // Apply
    for (i in Iter.range(0, memory.conceptCount - 1)) {
      memory.spreadingActivation[i] := tempActivation[i];
    };
  };
  
  // Find concept by pattern similarity
  public func findConceptByPattern(memory : SemanticMemory, pattern : [Float]) : ?Nat {
    if (memory.conceptCount == 0) { return null };
    
    var bestMatch : Nat = 0;
    var bestSim : Float = -1.0;
    
    for (i in Iter.range(0, memory.conceptCount - 1)) {
      let sim = cosineSimilarity(pattern, Array.freeze(memory.concepts[i].prototype));
      if (sim > bestSim) {
        bestSim := sim;
        bestMatch := i;
      };
    };
    
    if (bestSim > 0.7) { ?bestMatch } else { null }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: HOPFIELD NETWORK — ASSOCIATIVE MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Hopfield networks implement content-addressable memory.
  // Pattern completion: partial input → full memory retrieval.
  //
  // Energy: E = -0.5 × Σᵢⱼ wᵢⱼ × sᵢ × sⱼ
  // Update: sᵢ = sign(Σⱼ wᵢⱼ × sⱼ)
  //
  // INTERTWINING: Weight matrix is related to Hebbian weights!
  //
  
  public type HopfieldNetwork = {
    var weights : [[var Float]];         // Symmetric weight matrix
    var state : [var Float];             // Current network state
    var storedPatterns : [[Float]];      // Reference patterns
    var patternCount : Nat;
    var capacity : Nat;                  // ~0.14N patterns
    var temperature : Float;             // For stochastic updates
    var energy : Float;                  // Current energy
    var converged : Bool;
  };
  
  // Initialize Hopfield network
  public func initHopfieldNetwork() : HopfieldNetwork {
    {
      var weights = Array.init<[var Float]>(HOPFIELD_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(HOPFIELD_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var state = Array.init<Float>(HOPFIELD_SIZE, func(_ : Nat) : Float { 0.0 });
      var storedPatterns = [];
      var patternCount = 0;
      var capacity = HOPFIELD_SIZE / 7;  // ~0.14N
      var temperature = 0.1;
      var energy = 0.0;
      var converged = false;
    }
  };
  
  // Store pattern in Hopfield network (Hebbian learning)
  // INTERTWINING: This IS Hebbian learning!
  public func storeHopfieldPattern(network : HopfieldNetwork, pattern : [Float]) {
    if (network.patternCount >= network.capacity) { return };
    
    let n = HOPFIELD_SIZE;
    
    // Hebbian rule: Δwᵢⱼ = (1/N) × pᵢ × pⱼ
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let pi = if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
          let pj = if (j < Array.size(pattern)) { pattern[j] } else { 0.0 };
          network.weights[i][j] := network.weights[i][j] + pi * pj / Float.fromInt(n);
        };
      };
    };
    
    network.patternCount += 1;
  };
  
  // Compute Hopfield energy
  public func computeHopfieldEnergy(network : HopfieldNetwork) : Float {
    var energy : Float = 0.0;
    let n = HOPFIELD_SIZE;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          energy -= 0.5 * network.weights[i][j] * network.state[i] * network.state[j];
        };
      };
    };
    
    network.energy := energy;
    energy
  };
  
  // Pattern completion (recall)
  public func recallHopfieldPattern(network : HopfieldNetwork, cue : [Float], maxIterations : Nat) : [Float] {
    let n = HOPFIELD_SIZE;
    
    // Initialize with cue
    for (i in Iter.range(0, n - 1)) {
      network.state[i] := if (i < Array.size(cue)) { 
        if (cue[i] > 0.0) { 1.0 } else { -1.0 }
      } else { 0.0 };
    };
    
    network.converged := false;
    
    // Iterative update
    for (_ in Iter.range(0, maxIterations - 1)) {
      var changed : Bool = false;
      
      for (i in Iter.range(0, n - 1)) {
        // Compute local field
        var field : Float = 0.0;
        for (j in Iter.range(0, n - 1)) {
          field += network.weights[i][j] * network.state[j];
        };
        
        // Stochastic update
        let prob = sigmoid(field / network.temperature);
        let newState : Float = if (prob > 0.5) { 1.0 } else { -1.0 };
        
        if (newState != network.state[i]) {
          changed := true;
        };
        network.state[i] := newState;
      };
      
      if (not changed) {
        network.converged := true;
        // Early exit would go here in a real implementation
      };
    };
    
    let _ = computeHopfieldEnergy(network);
    
    // Convert to [0, 1] range
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      (network.state[i] + 1.0) / 2.0
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: MEMORY CONSOLIDATION — HIPPOCAMPUS TO CORTEX
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Consolidation transfers memories from fast-learning hippocampus to slow-learning cortex.
  // This happens during sleep and rest.
  //
  // INTERTWINING: Replay strengthens Hebbian connections
  //
  
  public type ConsolidationState = {
    var hippocampalBuffer : [[var Float]];    // Fast-learning store
    var corticalStore : [[var Float]];        // Slow-learning store
    var bufferWriteIdx : Nat;
    var storeWriteIdx : Nat;
    
    // Replay state
    var replayQueue : [Nat];                  // Episodes to replay
    var replayIdx : Nat;
    var isConsolidating : Bool;
    
    // Parameters
    var transferThreshold : Float;            // Strength needed for transfer
    var replayStrength : Float;               // How much replay strengthens
    var sleepPhase : Bool;                    // In sleep/consolidation mode?
  };
  
  public let HIPPOCAMPAL_SIZE : Nat = 100;
  public let CORTICAL_SIZE : Nat = 1000;
  
  // Initialize consolidation state
  public func initConsolidationState() : ConsolidationState {
    {
      var hippocampalBuffer = Array.init<[var Float]>(HIPPOCAMPAL_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var corticalStore = Array.init<[var Float]>(CORTICAL_SIZE, func(_ : Nat) : [var Float] {
        Array.init<Float>(PATTERN_SIZE, func(_ : Nat) : Float { 0.0 })
      });
      var bufferWriteIdx = 0;
      var storeWriteIdx = 0;
      var replayQueue = [];
      var replayIdx = 0;
      var isConsolidating = false;
      var transferThreshold = 0.6;
      var replayStrength = 0.1;
      var sleepPhase = false;
    }
  };
  
  // Add to hippocampal buffer (fast encoding)
  public func encodeToHippocampus(
    consolidation : ConsolidationState,
    pattern : [Float]
  ) {
    let idx = consolidation.bufferWriteIdx;
    
    for (i in Iter.range(0, PATTERN_SIZE - 1)) {
      consolidation.hippocampalBuffer[idx][i] := 
        if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
    };
    
    consolidation.bufferWriteIdx := (idx + 1) % HIPPOCAMPAL_SIZE;
  };
  
  // Run consolidation (during "sleep")
  // INTERTWINING: Replay drives Hebbian learning
  public func runConsolidation(
    consolidation : ConsolidationState,
    episodicMemory : EpisodicMemory,
    hebbianWeights : [[var Float]],      // ← INTERTWINING: Hebbian weights
    numReplays : Nat
  ) : [[Float]] {
    consolidation.isConsolidating := true;
    let replayedPatterns = Buffer.Buffer<[Float]>(numReplays);
    
    // Select episodes for replay based on strength and recency
    let episodesToReplay = Buffer.Buffer<Nat>(numReplays);
    
    let limit = Nat.min(episodicMemory.totalEpisodes, EPISODIC_CAPACITY);
    for (i in Iter.range(0, Nat.min(numReplays * 2, limit) - 1)) {
      let episode = episodicMemory.episodes[i];
      if (episode.strength > 0.3 and not episode.isConsolidated) {
        episodesToReplay.add(i);
      };
    };
    
    // Replay each episode
    for (epIdx in episodesToReplay.vals()) {
      let episode = episodicMemory.episodes[epIdx];
      let pattern = Array.freeze(episode.pattern);
      
      // Strengthen Hebbian connections during replay
      // INTERTWINING: Replay → Hebbian learning
      for (i in Iter.range(0, PATTERN_SIZE - 1)) {
        for (j in Iter.range(0, PATTERN_SIZE - 1)) {
          if (i != j and i < Array.size(hebbianWeights) and j < Array.size(hebbianWeights[i])) {
            let pi = if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
            let pj = if (j < Array.size(pattern)) { pattern[j] } else { 0.0 };
            hebbianWeights[i][j] := hebbianWeights[i][j] + 
              consolidation.replayStrength * pi * pj;
          };
        };
      };
      
      // Transfer to cortical store
      if (episode.strength > consolidation.transferThreshold) {
        let cortIdx = consolidation.storeWriteIdx;
        for (i in Iter.range(0, PATTERN_SIZE - 1)) {
          consolidation.corticalStore[cortIdx][i] := 
            if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
        };
        consolidation.storeWriteIdx := (cortIdx + 1) % CORTICAL_SIZE;
        
        // Mark as consolidated
        episode.consolidationLevel := 1.0;
        episode.isConsolidated := true;
      } else {
        // Partial consolidation
        episode.consolidationLevel := episode.consolidationLevel + 0.1;
      };
      
      replayedPatterns.add(pattern);
    };
    
    consolidation.isConsolidating := false;
    Buffer.toArray(replayedPatterns)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: MEMORY FORGETTING — ADAPTIVE DECAY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Forgetting is not a bug — it's a feature!
  // Adaptive forgetting prevents interference and maintains relevance.
  //
  
  public type ForgettingCurve = {
    var initialStrength : Float;
    var retentionRate : Float;          // How fast we forget
    var retrievalBonus : Float;         // How much retrieval helps
    var interferenceFactor : Float;     // How much new learning interferes
  };
  
  // Ebbinghaus forgetting curve: R = e^(-t/S)
  public func applyForgettingCurve(
    initialStrength : Float,
    elapsedTime : Float,
    stability : Float
  ) : Float {
    initialStrength * exp(-elapsedTime / (stability + 0.001))
  };
  
  // Apply forgetting to all memories
  public func applyForgetting(
    episodicMemory : EpisodicMemory,
    currentBeat : Nat
  ) {
    let limit = Nat.min(episodicMemory.totalEpisodes, EPISODIC_CAPACITY);
    
    for (i in Iter.range(0, limit - 1)) {
      let episode = episodicMemory.episodes[i];
      
      if (episode.strength > 0.01) {
        let age = Float.fromInt(currentBeat - episode.createdAtBeat);
        
        // Calculate stability based on:
        // - Access count (more retrievals = more stable)
        // - Consolidation level
        // - Emotional intensity
        let stability = 1000.0 + 
                       500.0 * Float.fromInt(episode.accessCount) +
                       1000.0 * episode.consolidationLevel +
                       200.0 * Float.abs(episode.emotionalValence);
        
        // Apply forgetting
        let retention = applyForgettingCurve(1.0, age, stability);
        episode.strength := episode.strength * retention;
      };
    };
    
    // Update statistics
    var totalStrength : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, limit - 1)) {
      if (episodicMemory.episodes[i].strength > 0.01) {
        totalStrength += episodicMemory.episodes[i].strength;
        count += 1;
      };
    };
    
    if (count > 0) {
      episodicMemory.avgStrength := totalStrength / Float.fromInt(count);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: COMPLETE DEEP MEMORY STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type DeepMemoryState = {
    // Memory systems
    sensory : SensoryMemory;
    working : WorkingMemory;
    episodic : EpisodicMemory;
    semantic : SemanticMemory;
    hopfield : HopfieldNetwork;
    consolidation : ConsolidationState;
    
    // Global state
    var currentBeat : Nat;
    var totalEncodings : Nat;
    var totalRetrievals : Nat;
    
    // Performance metrics
    var avgRetrievalAccuracy : Float;
    var memoryLoad : Float;
    var consolidationProgress : Float;
  };
  
  // Initialize complete memory state
  public func initDeepMemoryState() : DeepMemoryState {
    {
      sensory = initSensoryMemory();
      working = initWorkingMemory();
      episodic = initEpisodicMemory();
      semantic = initSemanticMemory();
      hopfield = initHopfieldNetwork();
      consolidation = initConsolidationState();
      var currentBeat = 0;
      var totalEncodings = 0;
      var totalRetrievals = 0;
      var avgRetrievalAccuracy = 0.0;
      var memoryLoad = 0.0;
      var consolidationProgress = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: THE COMPLETE INTERTWINED HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type MemoryHeartbeatResult = {
    encodedEpisodeIdx : ?Nat;
    retrievedEpisodeIdx : ?Nat;
    retrievedPattern : ?[Float];
    workingMemoryLoad : Float;
    consolidationActive : Bool;
    hopfieldEnergy : Float;
    totalMemoryStrength : Float;
  };
  
  // The complete intertwined heartbeat
  public func runMemoryHeartbeat(
    state : DeepMemoryState,
    sensoryInput : [Float],
    
    // INTERTWINED INPUTS
    kuramotoCoherence : Float,           // ← INTERTWINING: Kuramoto
    kuramotoPhases : [Float],            // ← INTERTWINING: Kuramoto
    hebbianWeights : [[var Float]],      // ← INTERTWINING: Hebbian
    freeEnergyPredError : Float,         // ← INTERTWINING: Free Energy
    qLearningReward : Float,             // ← INTERTWINING: Q-learning
    
    retrievalCue : ?[Float],             // Optional retrieval cue
    shouldConsolidate : Bool,            // Trigger consolidation?
    
    dt : Float
  ) : MemoryHeartbeatResult {
    state.currentBeat += 1;
    let currentBeat = state.currentBeat;
    let currentTime = currentBeat;  // Use beat as time
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Process sensory input
    // ───────────────────────────────────────────────────────────────────────────
    registerSensoryInput(state.sensory, sensoryInput, true, currentTime);
    decaySensoryTraces(state.sensory, currentTime);
    
    // Get attended content
    let attendedContent = getAttendedContent(state.sensory);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Update working memory
    // ───────────────────────────────────────────────────────────────────────────
    // Load attended content if significant
    let contentStrength = arrayMagnitude(attendedContent);
    if (contentStrength > 0.3) {
      let _ = loadIntoWorkingMemory(state.working, attendedContent, currentTime);
    };
    
    rehearseWorkingMemory(state.working, currentTime);
    let wmLoad = state.working.executive.cognitiveLoad;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Episodic encoding
    // INTERTWINING: Uses Kuramoto, Q-learning, Free Energy
    // ───────────────────────────────────────────────────────────────────────────
    var encodedIdx : ?Nat = null;
    
    // Encode if conditions are right:
    // - High coherence (theta rhythm)
    // - Significant prediction error (surprising)
    // - Reward signal
    let shouldEncode = kuramotoCoherence > 0.6 or 
                      Float.abs(freeEnergyPredError) > 0.3 or
                      Float.abs(qLearningReward) > 0.2;
    
    if (shouldEncode and contentStrength > 0.2) {
      let locationContext = Array.tabulate<Float>(NUM_NODES, func(i : Nat) : Float {
        if (i < Array.size(kuramotoPhases)) { kuramotoPhases[i] } else { 0.0 }
      });
      
      let idx = encodeEpisode(
        state.episodic,
        attendedContent,
        locationContext,
        kuramotoCoherence,         // ← INTERTWINING: Kuramoto
        qLearningReward,           // ← INTERTWINING: Q-learning
        freeEnergyPredError,       // ← INTERTWINING: Free Energy
        currentBeat
      );
      
      encodedIdx := ?idx;
      state.totalEncodings += 1;
      
      // Also add to Hopfield network
      storeHopfieldPattern(state.hopfield, attendedContent);
      
      // And hippocampal buffer for consolidation
      encodeToHippocampus(state.consolidation, attendedContent);
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Memory retrieval
    // ───────────────────────────────────────────────────────────────────────────
    var retrievedIdx : ?Nat = null;
    var retrievedPattern : ?[Float] = null;
    
    switch (retrievalCue) {
      case (?cue) {
        // Try episodic retrieval
        retrievedIdx := retrieveEpisodeBySimilarity(state.episodic, cue, currentBeat);
        
        switch (retrievedIdx) {
          case (?idx) {
            retrievedPattern := getEpisodePattern(state.episodic, idx);
            state.totalRetrievals += 1;
          };
          case (null) {
            // Try Hopfield pattern completion
            let completed = recallHopfieldPattern(state.hopfield, cue, 10);
            if (arrayMagnitude(completed) > 0.2) {
              retrievedPattern := ?completed;
            };
          };
        };
      };
      case (null) { };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Memory consolidation (if triggered)
    // INTERTWINING: Strengthens Hebbian weights
    // ───────────────────────────────────────────────────────────────────────────
    if (shouldConsolidate) {
      let _ = runConsolidation(
        state.consolidation,
        state.episodic,
        hebbianWeights,             // ← INTERTWINING: Hebbian
        10
      );
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Apply forgetting
    // ───────────────────────────────────────────────────────────────────────────
    applyForgetting(state.episodic, currentBeat);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Update statistics
    // ───────────────────────────────────────────────────────────────────────────
    state.memoryLoad := wmLoad;
    
    // Compute total memory strength
    var totalStrength : Float = 0.0;
    let limit = Nat.min(state.episodic.totalEpisodes, EPISODIC_CAPACITY);
    for (i in Iter.range(0, limit - 1)) {
      totalStrength += state.episodic.episodes[i].strength;
    };
    
    // Compute Hopfield energy
    let hopfieldEnergy = computeHopfieldEnergy(state.hopfield);
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return result
    // ───────────────────────────────────────────────────────────────────────────
    {
      encodedEpisodeIdx = encodedIdx;
      retrievedEpisodeIdx = retrievedIdx;
      retrievedPattern = retrievedPattern;
      workingMemoryLoad = wmLoad;
      consolidationActive = state.consolidation.isConsolidating;
      hopfieldEnergy = hopfieldEnergy;
      totalMemoryStrength = totalStrength;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    if (x > 20.0) { return 485165195.0 };
    if (x < -20.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 30)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  func cosineSimilarity(a : [Float], b : [Float]) : Float {
    let n = Nat.min(Array.size(a), Array.size(b));
    if (n == 0) { return 0.0 };
    
    var dot : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      dot += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };
    
    let denom = sqrt(normA) * sqrt(normB);
    if (denom < 0.0001) { 0.0 } else { dot / denom }
  };
  
  func arrayMagnitude(arr : [Float]) : Float {
    var sum : Float = 0.0;
    for (v in arr.vals()) {
      sum += v * v;
    };
    sqrt(sum)
  };

};

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  DEEP MEMORY ENGINE EXPANSION — COMPLETE MEMORY ARCHITECTURE                                            ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Memory is sacred. Nothing gets deleted. Everything is wired correctly.
  // The organism FEEDS on information - memory is how that food is stored.
  //

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HIPPOCAMPAL MEMORY SYSTEM — EPISODIC ENCODING AND RETRIEVAL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The hippocampus binds features into episodes:
  //
  // 1. CA3: Autoassociative pattern completion
  // 2. CA1: Output and temporal context
  // 3. DG: Pattern separation (orthogonalization)
  // 4. EC: Input/output interface
  //

  public type HippocampalRegion = {
    var neurons : [var Float];           // Neural activations
    var numNeurons : Nat;
    var weights : [[var Float]];         // Recurrent/feedforward weights
    var threshold : Float;               // Firing threshold
    var sparsity : Float;                // Target sparsity
    var learningRate : Float;            // Hebbian learning rate
    var activityHistory : [[var Float]]; // Recent activity patterns
    var historySize : Nat;
    var historyIdx : Nat;
    var patternSeparation : Float;       // DG-specific
    var patternCompletion : Float;       // CA3-specific
  };

  public type HippocampalCircuit = {
    var ec : HippocampalRegion;          // Entorhinal cortex
    var dg : HippocampalRegion;          // Dentate gyrus
    var ca3 : HippocampalRegion;         // CA3 (autoassociative)
    var ca1 : HippocampalRegion;         // CA1 (output)
    var ecToDg : [[var Float]];          // EC → DG weights
    var dgToCa3 : [[var Float]];         // DG → CA3 weights
    var ca3ToCa1 : [[var Float]];        // CA3 → CA1 weights
    var ca1ToEc : [[var Float]];         // CA1 → EC (output)
    var ca3Recurrent : [[var Float]];    // CA3 → CA3 recurrent
    var thetaPhase : Float;              // Hippocampal theta rhythm
    var gammaPhase : Float;              // Nested gamma
    var sharpWaveRipple : Bool;          // SWR for consolidation
  };

  public type EpisodicMemory = {
    hippocampus : HippocampalCircuit;
    var episodes : [[var Float]];        // Stored episodes
    var episodeContexts : [[var Float]]; // Temporal/spatial context
    var numEpisodes : Nat;
    var maxEpisodes : Nat;
    var episodeStrength : [var Float];   // Memory strength
    var episodeTimestamp : [var Float];  // When encoded
    var currentContext : [var Float];    // Current binding context
    var retrievalCue : [var Float];      // Current retrieval cue
    var retrievedEpisode : [var Float];  // Retrieved memory
    var retrievalConfidence : Float;     // Confidence in retrieval
  };

  public func initHippocampalRegion(numNeurons : Nat, historySize : Nat, sparsity : Float) : HippocampalRegion {
    let neurons = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    
    let weights = Array.init<[var Float]>(numNeurons, func(_ : Nat) : [var Float] {
      Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.01 })
    });
    
    let history = Array.init<[var Float]>(historySize, func(_ : Nat) : [var Float] {
      Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var neurons = neurons;
      var numNeurons = numNeurons;
      var weights = weights;
      var threshold = 0.5;
      var sparsity = sparsity;
      var learningRate = 0.01;
      var activityHistory = history;
      var historySize = historySize;
      var historyIdx = 0;
      var patternSeparation = 0.0;
      var patternCompletion = 0.0;
    }
  };

  public func initHippocampalCircuit(ecSize : Nat, dgSize : Nat, ca3Size : Nat, ca1Size : Nat) : HippocampalCircuit {
    let ecToDg = Array.init<[var Float]>(dgSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(ecSize, func(_ : Nat) : Float { 0.01 })
    });
    
    let dgToCa3 = Array.init<[var Float]>(ca3Size, func(_ : Nat) : [var Float] {
      Array.init<Float>(dgSize, func(_ : Nat) : Float { 0.01 })
    });
    
    let ca3ToCa1 = Array.init<[var Float]>(ca1Size, func(_ : Nat) : [var Float] {
      Array.init<Float>(ca3Size, func(_ : Nat) : Float { 0.01 })
    });
    
    let ca1ToEc = Array.init<[var Float]>(ecSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(ca1Size, func(_ : Nat) : Float { 0.01 })
    });
    
    let ca3Rec = Array.init<[var Float]>(ca3Size, func(_ : Nat) : [var Float] {
      Array.init<Float>(ca3Size, func(_ : Nat) : Float { 0.01 })
    });
    
    {
      var ec = initHippocampalRegion(ecSize, 20, 0.3);
      var dg = initHippocampalRegion(dgSize, 20, 0.05);  // Very sparse
      var ca3 = initHippocampalRegion(ca3Size, 20, 0.1);
      var ca1 = initHippocampalRegion(ca1Size, 20, 0.2);
      var ecToDg = ecToDg;
      var dgToCa3 = dgToCa3;
      var ca3ToCa1 = ca3ToCa1;
      var ca1ToEc = ca1ToEc;
      var ca3Recurrent = ca3Rec;
      var thetaPhase = 0.0;
      var gammaPhase = 0.0;
      var sharpWaveRipple = false;
    }
  };

  public func initEpisodicMemory(ecSize : Nat, dgSize : Nat, ca3Size : Nat, ca1Size : Nat, maxEpisodes : Nat, contextSize : Nat) : EpisodicMemory {
    let episodes = Array.init<[var Float]>(maxEpisodes, func(_ : Nat) : [var Float] {
      Array.init<Float>(ecSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let contexts = Array.init<[var Float]>(maxEpisodes, func(_ : Nat) : [var Float] {
      Array.init<Float>(contextSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let strength = Array.init<Float>(maxEpisodes, func(_ : Nat) : Float { 0.0 });
    let timestamp = Array.init<Float>(maxEpisodes, func(_ : Nat) : Float { 0.0 });
    let currCtx = Array.init<Float>(contextSize, func(_ : Nat) : Float { 0.0 });
    let cue = Array.init<Float>(ecSize, func(_ : Nat) : Float { 0.0 });
    let retrieved = Array.init<Float>(ecSize, func(_ : Nat) : Float { 0.0 });
    
    {
      hippocampus = initHippocampalCircuit(ecSize, dgSize, ca3Size, ca1Size);
      var episodes = episodes;
      var episodeContexts = contexts;
      var numEpisodes = 0;
      var maxEpisodes = maxEpisodes;
      var episodeStrength = strength;
      var episodeTimestamp = timestamp;
      var currentContext = currCtx;
      var retrievalCue = cue;
      var retrievedEpisode = retrieved;
      var retrievalConfidence = 0.0;
    }
  };

  // Pattern separation in DG
  func applyPatternSeparation(dg : HippocampalRegion, input : [Float]) {
    let n = dg.numNeurons;
    let inputSize = Array.size(input);
    
    // Sparse activation
    var activations : [Float] = [];
    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, Nat.min(inputSize, n) - 1)) {
        sum += dg.weights[i][j] * input[j];
      };
      
      activations := Array.append(activations, [sum]);
    };
    
    // Winner-take-all: keep only top k% active
    let k = Int.abs(Float.toInt(Float.fromInt(n) * dg.sparsity));
    
    // Find threshold for top k
    var sorted = activations;
    // Simple selection: find kth largest
    var threshold : Float = 0.0;
    for (_ in Iter.range(0, k - 1)) {
      var maxVal : Float = -1000.0;
      for (act in activations.vals()) {
        if (act > maxVal and act > threshold) {
          maxVal := act;
        };
      };
      threshold := maxVal;
    };
    
    // Apply threshold
    for (i in Iter.range(0, n - 1)) {
      if (activations[i] >= threshold) {
        dg.neurons[i] := sigmoid(activations[i]);
      } else {
        dg.neurons[i] := 0.0;
      };
    };
    
    // Measure separation
    var activeCount : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      if (dg.neurons[i] > 0.1) { activeCount += 1 };
    };
    dg.patternSeparation := 1.0 - Float.fromInt(activeCount) / Float.fromInt(n);
  };

  // Pattern completion in CA3
  func applyPatternCompletion(ca3 : HippocampalRegion, partialCue : [Float], iterations : Nat) {
    let n = ca3.numNeurons;
    
    // Initialize from cue
    for (i in Iter.range(0, Nat.min(Array.size(partialCue), n) - 1)) {
      ca3.neurons[i] := partialCue[i];
    };
    
    // Iterate recurrent dynamics
    for (iter in Iter.range(0, iterations - 1)) {
      let newActivations = Array.tabulate<Float>(n, func(i : Nat) : Float {
        var sum : Float = 0.0;
        for (j in Iter.range(0, n - 1)) {
          sum += ca3.weights[i][j] * ca3.neurons[j];
        };
        sigmoid(sum)
      });
      
      // Update with momentum
      for (i in Iter.range(0, n - 1)) {
        ca3.neurons[i] := 0.3 * ca3.neurons[i] + 0.7 * newActivations[i];
      };
    };
    
    // Measure completion (how much changed from cue)
    var changeSum : Float = 0.0;
    for (i in Iter.range(0, Nat.min(Array.size(partialCue), n) - 1)) {
      changeSum += Float.abs(ca3.neurons[i] - partialCue[i]);
    };
    ca3.patternCompletion := changeSum / Float.fromInt(n);
  };

  // Encode new episode
  public func encodeEpisode(
    epMem : EpisodicMemory,
    episode : [Float],
    context : [Float],
    currentTime : Float
  ) : Bool {
    if (epMem.numEpisodes >= epMem.maxEpisodes) {
      // Overwrite oldest/weakest memory
      var minStrength : Float = 1000.0;
      var minIdx : Nat = 0;
      for (i in Iter.range(0, epMem.maxEpisodes - 1)) {
        if (epMem.episodeStrength[i] < minStrength) {
          minStrength := epMem.episodeStrength[i];
          minIdx := i;
        };
      };
      
      // Store in weakest slot
      let epSize = Nat.min(Array.size(episode), Array.size(epMem.episodes[minIdx]));
      for (i in Iter.range(0, epSize - 1)) {
        epMem.episodes[minIdx][i] := episode[i];
      };
      
      let ctxSize = Nat.min(Array.size(context), Array.size(epMem.episodeContexts[minIdx]));
      for (i in Iter.range(0, ctxSize - 1)) {
        epMem.episodeContexts[minIdx][i] := context[i];
      };
      
      epMem.episodeStrength[minIdx] := 1.0;
      epMem.episodeTimestamp[minIdx] := currentTime;
      
    } else {
      // Store in new slot
      let idx = epMem.numEpisodes;
      
      let epSize = Nat.min(Array.size(episode), Array.size(epMem.episodes[idx]));
      for (i in Iter.range(0, epSize - 1)) {
        epMem.episodes[idx][i] := episode[i];
      };
      
      let ctxSize = Nat.min(Array.size(context), Array.size(epMem.episodeContexts[idx]));
      for (i in Iter.range(0, ctxSize - 1)) {
        epMem.episodeContexts[idx][i] := context[i];
      };
      
      epMem.episodeStrength[idx] := 1.0;
      epMem.episodeTimestamp[idx] := currentTime;
      epMem.numEpisodes += 1;
    };
    
    // Update hippocampal weights
    let hc = epMem.hippocampus;
    
    // EC activation
    for (i in Iter.range(0, Nat.min(Array.size(episode), hc.ec.numNeurons) - 1)) {
      hc.ec.neurons[i] := episode[i];
    };
    
    // Forward through trisynaptic pathway
    // EC → DG (pattern separation)
    applyPatternSeparation(hc.dg, Array.tabulate<Float>(hc.ec.numNeurons, func(i : Nat) : Float { hc.ec.neurons[i] }));
    
    // DG → CA3 (sparse encoding)
    for (i in Iter.range(0, hc.ca3.numNeurons - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, hc.dg.numNeurons - 1)) {
        sum += hc.dgToCa3[i][j] * hc.dg.neurons[j];
      };
      hc.ca3.neurons[i] := sigmoid(sum);
    };
    
    // Hebbian learning in CA3 recurrent connections
    for (i in Iter.range(0, hc.ca3.numNeurons - 1)) {
      for (j in Iter.range(0, hc.ca3.numNeurons - 1)) {
        let dw = hc.ca3.learningRate * hc.ca3.neurons[i] * hc.ca3.neurons[j];
        hc.ca3Recurrent[i][j] += dw;
        hc.ca3Recurrent[i][j] := clamp(hc.ca3Recurrent[i][j], 0.0, 1.0);
      };
    };
    
    true
  };

  // Retrieve episode by cue
  public func retrieveEpisode(
    epMem : EpisodicMemory,
    cue : [Float],
    context : [Float]
  ) {
    let hc = epMem.hippocampus;
    
    // Set EC from cue
    for (i in Iter.range(0, Nat.min(Array.size(cue), hc.ec.numNeurons) - 1)) {
      hc.ec.neurons[i] := cue[i];
      epMem.retrievalCue[i] := cue[i];
    };
    
    // Forward through DG for pattern separation
    applyPatternSeparation(hc.dg, Array.tabulate<Float>(hc.ec.numNeurons, func(i : Nat) : Float { hc.ec.neurons[i] }));
    
    // DG → CA3
    for (i in Iter.range(0, hc.ca3.numNeurons - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, hc.dg.numNeurons - 1)) {
        sum += hc.dgToCa3[i][j] * hc.dg.neurons[j];
      };
      hc.ca3.neurons[i] := sigmoid(sum);
    };
    
    // Pattern completion in CA3
    applyPatternCompletion(hc.ca3, Array.tabulate<Float>(hc.ca3.numNeurons, func(i : Nat) : Float { hc.ca3.neurons[i] }), 10);
    
    // CA3 → CA1
    for (i in Iter.range(0, hc.ca1.numNeurons - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, hc.ca3.numNeurons - 1)) {
        sum += hc.ca3ToCa1[i][j] * hc.ca3.neurons[j];
      };
      hc.ca1.neurons[i] := sigmoid(sum);
    };
    
    // CA1 → EC (output)
    for (i in Iter.range(0, hc.ec.numNeurons - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, hc.ca1.numNeurons - 1)) {
        sum += hc.ca1ToEc[i][j] * hc.ca1.neurons[j];
      };
      epMem.retrievedEpisode[i] := sigmoid(sum);
    };
    
    // Find best matching stored episode
    var bestMatch : Float = 0.0;
    var bestIdx : Nat = 0;
    
    for (ep in Iter.range(0, epMem.numEpisodes - 1)) {
      let storedEp = Array.tabulate<Float>(Array.size(epMem.episodes[ep]), func(i : Nat) : Float {
        epMem.episodes[ep][i]
      });
      
      let similarity = cosineSimilarity(
        Array.tabulate<Float>(hc.ec.numNeurons, func(i : Nat) : Float { epMem.retrievedEpisode[i] }),
        storedEp
      );
      
      // Weight by context similarity
      let ctxSim = cosineSimilarity(
        Array.tabulate<Float>(Array.size(context), func(i : Nat) : Float { context[i] }),
        Array.tabulate<Float>(Array.size(epMem.episodeContexts[ep]), func(i : Nat) : Float { epMem.episodeContexts[ep][i] })
      );
      
      let weightedSim = similarity * 0.7 + ctxSim * 0.3;
      
      if (weightedSim > bestMatch) {
        bestMatch := weightedSim;
        bestIdx := ep;
      };
    };
    
    epMem.retrievalConfidence := bestMatch;
    
    // Strengthen retrieved memory
    if (bestMatch > 0.5) {
      epMem.episodeStrength[bestIdx] += 0.1;
      epMem.episodeStrength[bestIdx] := clamp(epMem.episodeStrength[bestIdx], 0.0, 2.0);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SEMANTIC MEMORY — CONCEPTUAL KNOWLEDGE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // General world knowledge abstracted from episodes:
  //
  // 1. CONCEPTS: Abstracted categories
  // 2. RELATIONS: Links between concepts
  // 3. SCHEMAS: Structured knowledge frames
  // 4. SEMANTIC NETWORKS: Spreading activation
  //

  public type Concept = {
    var features : [var Float];          // Feature vector
    var featureSize : Nat;
    var label : Text;                    // Concept name
    var abstractionLevel : Float;        // 0 = concrete, 1 = abstract
    var typicality : Float;              // How typical an exemplar
    var frequency : Nat;                 // Encounter frequency
    var lastAccess : Float;              // Last access time
    var connections : [var Nat];         // Related concept indices
    var connectionStrengths : [var Float]; // Relation strengths
    var numConnections : Nat;
  };

  public type SemanticNetwork = {
    var concepts : [var Concept];        // All concepts
    var numConcepts : Nat;
    var maxConcepts : Nat;
    var adjacencyMatrix : [[var Float]]; // Semantic similarity
    var activationSpread : [var Float];  // Current spreading activation
    var spreadingRate : Float;           // Activation spread rate
    var decayRate : Float;               // Activation decay
    var threshold : Float;               // Activation threshold
    var priming : [var Float];           // Priming from recent activations
  };

  public type SemanticMemory = {
    network : SemanticNetwork;
    var schemas : [[var Float]];         // Schema templates
    var numSchemas : Nat;
    var maxSchemas : Nat;
    var slotFillers : [[[var Float]]];   // Schema slot values
    var activeSchema : Nat;              // Currently active schema
    var schemaFit : Float;               // How well current fits schema
    var prototypes : [[var Float]];      // Category prototypes
    var numPrototypes : Nat;
    var taxonomicHierarchy : [[var Nat]];// Is-a hierarchy
  };

  public func initConcept(featureSize : Nat, label : Text, maxConnections : Nat) : Concept {
    let features = Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 });
    let connections = Array.init<Nat>(maxConnections, func(_ : Nat) : Nat { 0 });
    let strengths = Array.init<Float>(maxConnections, func(_ : Nat) : Float { 0.0 });
    
    {
      var features = features;
      var featureSize = featureSize;
      var label = label;
      var abstractionLevel = 0.5;
      var typicality = 0.5;
      var frequency = 0;
      var lastAccess = 0.0;
      var connections = connections;
      var connectionStrengths = strengths;
      var numConnections = 0;
    }
  };

  public func initSemanticNetwork(maxConcepts : Nat, featureSize : Nat) : SemanticNetwork {
    let concepts = Array.init<Concept>(maxConcepts, func(i : Nat) : Concept {
      initConcept(featureSize, "concept_" # Nat.toText(i), 10)
    });
    
    let adj = Array.init<[var Float]>(maxConcepts, func(_ : Nat) : [var Float] {
      Array.init<Float>(maxConcepts, func(_ : Nat) : Float { 0.0 })
    });
    
    let activation = Array.init<Float>(maxConcepts, func(_ : Nat) : Float { 0.0 });
    let priming = Array.init<Float>(maxConcepts, func(_ : Nat) : Float { 0.0 });
    
    {
      var concepts = concepts;
      var numConcepts = 0;
      var maxConcepts = maxConcepts;
      var adjacencyMatrix = adj;
      var activationSpread = activation;
      var spreadingRate = 0.3;
      var decayRate = 0.1;
      var threshold = 0.2;
      var priming = priming;
    }
  };

  public func initSemanticMemory(maxConcepts : Nat, featureSize : Nat, maxSchemas : Nat, numSlots : Nat) : SemanticMemory {
    let schemas = Array.init<[var Float]>(maxSchemas, func(_ : Nat) : [var Float] {
      Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let slotFillers = Array.init<[[var Float]]>(maxSchemas, func(_ : Nat) : [[var Float]] {
      Array.init<[var Float]>(numSlots, func(_ : Nat) : [var Float] {
        Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 })
      })
    });
    
    let prototypes = Array.init<[var Float]>(maxConcepts / 10, func(_ : Nat) : [var Float] {
      Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let taxonomy = Array.init<[var Nat]>(maxConcepts, func(_ : Nat) : [var Nat] {
      Array.init<Nat>(5, func(_ : Nat) : Nat { 0 })  // Up to 5 parents
    });
    
    {
      network = initSemanticNetwork(maxConcepts, featureSize);
      var schemas = schemas;
      var numSchemas = 0;
      var maxSchemas = maxSchemas;
      var slotFillers = slotFillers;
      var activeSchema = 0;
      var schemaFit = 0.0;
      var prototypes = prototypes;
      var numPrototypes = 0;
      var taxonomicHierarchy = taxonomy;
    }
  };

  // Spreading activation in semantic network
  public func spreadActivation(network : SemanticNetwork, initialConcepts : [Nat], activationLevels : [Float]) {
    let n = network.numConcepts;
    
    // Initialize from seed concepts
    for (i in Iter.range(0, n - 1)) {
      network.activationSpread[i] *= (1.0 - network.decayRate);
    };
    
    for (i in Iter.range(0, Nat.min(Array.size(initialConcepts), Array.size(activationLevels)) - 1)) {
      let idx = initialConcepts[i];
      if (idx < n) {
        network.activationSpread[idx] += activationLevels[i];
      };
    };
    
    // Spread activation
    let newActivation = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var spread : Float = 0.0;
      
      for (j in Iter.range(0, n - 1)) {
        if (network.adjacencyMatrix[j][i] > 0.0 and network.activationSpread[j] > network.threshold) {
          spread += network.spreadingRate * network.adjacencyMatrix[j][i] * network.activationSpread[j];
        };
      };
      
      network.activationSpread[i] + spread
    });
    
    // Update and apply threshold
    for (i in Iter.range(0, n - 1)) {
      network.activationSpread[i] := newActivation[i];
      network.activationSpread[i] := clamp(network.activationSpread[i], 0.0, 1.0);
      
      // Update priming
      network.priming[i] := 0.9 * network.priming[i] + 0.1 * network.activationSpread[i];
    };
  };

  // Add concept to semantic memory
  public func addConcept(semMem : SemanticMemory, features : [Float], label : Text) : Nat {
    let net = semMem.network;
    
    if (net.numConcepts >= net.maxConcepts) {
      return net.maxConcepts;  // Failed
    };
    
    let idx = net.numConcepts;
    let concept = net.concepts[idx];
    
    // Set features
    for (i in Iter.range(0, Nat.min(Array.size(features), concept.featureSize) - 1)) {
      concept.features[i] := features[i];
    };
    
    concept.label := label;
    concept.frequency := 1;
    
    // Compute similarity to existing concepts
    for (other in Iter.range(0, idx - 1)) {
      let sim = cosineSimilarity(
        Array.tabulate<Float>(concept.featureSize, func(i : Nat) : Float { concept.features[i] }),
        Array.tabulate<Float>(net.concepts[other].featureSize, func(i : Nat) : Float { net.concepts[other].features[i] })
      );
      
      net.adjacencyMatrix[idx][other] := sim;
      net.adjacencyMatrix[other][idx] := sim;
      
      // Add connection if strong enough
      if (sim > 0.5 and concept.numConnections < Array.size(concept.connections)) {
        concept.connections[concept.numConnections] := other;
        concept.connectionStrengths[concept.numConnections] := sim;
        concept.numConnections += 1;
      };
    };
    
    net.numConcepts += 1;
    
    idx
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEMORY CONSOLIDATION — EPISODIC TO SEMANTIC TRANSFER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Sleep-dependent memory consolidation:
  //
  // 1. SLOW WAVE SLEEP: Hippocampal-cortical dialog
  // 2. REM SLEEP: Memory integration and abstraction
  // 3. SHARP WAVE RIPPLES: Fast replay for consolidation
  // 4. SYSTEMS CONSOLIDATION: Gradual cortical independence
  //

  public type ConsolidationState = {
    var sleepStage : Text;               // "awake", "N1", "N2", "N3", "REM"
    var consolidationProgress : Float;   // Overall progress
    var replayCount : Nat;               // Memories replayed
    var abstractionLevel : Float;        // Episodic → semantic
    var corticalStrength : Float;        // Cortical trace strength
    var hippocampalDependence : Float;   // Still hippocampus-dependent?
    var spindles : Float;                // Sleep spindle activity
    var slowOscillations : Float;        // Delta power
    var rippleRate : Float;              // SWR rate
  };

  public type MemoryReplay = {
    var replayBuffer : [[var Float]];    // Memories to replay
    var bufferSize : Nat;
    var currentReplay : Nat;
    var replaySpeed : Float;             // Compression ratio (~20x)
    var forwardReplay : Bool;            // Forward vs reverse
    var associativeReplay : Bool;        // Chain replays
    var emotionalModulation : Float;     // Priority by emotion
    var noveltyModulation : Float;       // Priority by novelty
    var rewardModulation : Float;        // Priority by reward
  };

  public type MemoryConsolidator = {
    consolidation : ConsolidationState;
    replay : MemoryReplay;
    var episodic : EpisodicMemory;       // Reference to episodic
    var semantic : SemanticMemory;       // Reference to semantic
    var transferQueue : [var Nat];       // Episodes ready for transfer
    var queueSize : Nat;
    var synapticDownscaling : Float;     // SHY - homeostatic
    var globalBrainState : Float;        // Arousal level
  };

  public func initConsolidationState() : ConsolidationState {
    {
      var sleepStage = "awake";
      var consolidationProgress = 0.0;
      var replayCount = 0;
      var abstractionLevel = 0.0;
      var corticalStrength = 0.0;
      var hippocampalDependence = 1.0;
      var spindles = 0.0;
      var slowOscillations = 0.0;
      var rippleRate = 0.0;
    }
  };

  public func initMemoryReplay(bufferSize : Nat, memorySize : Nat) : MemoryReplay {
    let buffer = Array.init<[var Float]>(bufferSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(memorySize, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var replayBuffer = buffer;
      var bufferSize = bufferSize;
      var currentReplay = 0;
      var replaySpeed = 20.0;
      var forwardReplay = true;
      var associativeReplay = true;
      var emotionalModulation = 0.5;
      var noveltyModulation = 0.5;
      var rewardModulation = 0.5;
    }
  };

  // Run consolidation during sleep
  public func runConsolidation(
    consolidator : MemoryConsolidator,
    dt : Float
  ) {
    let cons = consolidator.consolidation;
    let replay = consolidator.replay;
    
    switch (cons.sleepStage) {
      case "N3" {
        // Slow wave sleep - hippocampal-cortical dialog
        cons.slowOscillations := 0.9;
        cons.rippleRate := 2.0;  // Hz
        
        // Sharp wave ripples trigger replay
        let numRipples = Int.abs(Float.toInt(cons.rippleRate * dt / 1000.0));
        
        for (_ in Iter.range(0, numRipples)) {
          if (replay.currentReplay < replay.bufferSize) {
            // Replay memory
            let memIdx = replay.currentReplay;
            
            // Transfer to semantic if abstracted enough
            if (cons.abstractionLevel > 0.7 and consolidator.queueSize < Array.size(consolidator.transferQueue)) {
              consolidator.transferQueue[consolidator.queueSize] := memIdx;
              consolidator.queueSize += 1;
            };
            
            replay.currentReplay += 1;
            cons.replayCount += 1;
          };
        };
        
        // Synaptic downscaling
        consolidator.synapticDownscaling := cons.slowOscillations * 0.01;
        
        // Increase cortical strength
        cons.corticalStrength += 0.001 * dt / 1000.0;
        cons.hippocampalDependence -= 0.0005 * dt / 1000.0;
        cons.hippocampalDependence := clamp(cons.hippocampalDependence, 0.0, 1.0);
      };
      
      case "REM" {
        // REM - memory integration and abstraction
        cons.slowOscillations := 0.1;
        cons.rippleRate := 0.0;
        
        // Increase abstraction
        cons.abstractionLevel += 0.01 * dt / 1000.0;
        cons.abstractionLevel := clamp(cons.abstractionLevel, 0.0, 1.0);
        
        // Associative replay - link memories
        if (replay.associativeReplay) {
          // Create semantic links
          cons.consolidationProgress += 0.01 * dt / 1000.0;
        };
      };
      
      case "N2" {
        // Stage 2 - sleep spindles
        cons.spindles := 0.7;
        cons.slowOscillations := 0.3;
        
        // Moderate consolidation
        cons.consolidationProgress += 0.005 * dt / 1000.0;
      };
      
      case _ {
        // Awake or light sleep - minimal consolidation
        cons.slowOscillations := 0.0;
        cons.spindles := 0.0;
        cons.rippleRate := 0.0;
      };
    };
    
    // Bound progress
    cons.consolidationProgress := clamp(cons.consolidationProgress, 0.0, 1.0);
  };

