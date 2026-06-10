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
// QUANTUM MEMORY SUBSTRATE — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// QUANTUM MEMORY ARCHITECTURE
//
// Three memory layers operating at different temporal scales:
//
// 1. GAMMA LAYER (Working Memory)
//    - Frequency: 30-100 Hz
//    - Capacity: ~7 items (Miller's Law)
//    - Persistence: Seconds to minutes
//    - Gate: Attention-controlled
//
// 2. DELTA LAYER (Deep Memory)
//    - Frequency: 0.5-4 Hz
//    - Capacity: Unlimited (compressed)
//    - Persistence: Permanent (with decay)
//    - Gate: Consolidation during sleep
//
// 3. THETA LAYER (Resonance Memory)
//    - Frequency: 4-8 Hz
//    - Purpose: Memory binding and retrieval
//    - Links Gamma ↔ Delta
//    - Sharp-Wave Ripple consolidation
//
// MEMORY GATE EQUATION:
// G = σ(α × Λ × A × |δ| − θ)
// Where:
// - α = attention weight
// - Λ = coherence (Kuramoto order parameter)
// - A = arousal level
// - δ = prediction error
// - θ = gate threshold
// - σ = sigmoid function
//
// KNOWLEDGE COMPOUNDING:
// K(t+1) = K(t) × (1 + r_learn)^Δt
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";
import Hash "mo:core/Hash";
import HashMap "mo:core/HashMap";

module QuantumMemorySubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Miller's Law - working memory capacity
  public let GAMMA_CAPACITY : Nat = 7;
  
  /// Maximum patterns in Delta layer
  public let DELTA_MAX_PATTERNS : Nat = 10000;
  
  /// Sharp-Wave Ripple frequency range (Hz)
  public let SWR_FREQUENCY_MIN : Float = 80.0;
  public let SWR_FREQUENCY_MAX : Float = 120.0;
  
  /// Memory decay rates
  public let GAMMA_DECAY_RATE : Float = 0.1;   // Fast decay
  public let THETA_DECAY_RATE : Float = 0.01;  // Medium decay
  public let DELTA_DECAY_RATE : Float = 0.001; // Slow decay
  
  /// Memory gate parameters
  public let GATE_THRESHOLD : Float = 0.5;
  public let GATE_ALPHA : Float = 1.0;
  
  /// Knowledge compounding rate
  public let KNOWLEDGE_COMPOUNDING_RATE : Float = 0.001;
  
  /// Consolidation parameters
  public let CONSOLIDATION_STRENGTH : Float = 0.1;
  public let REPLAY_COUNT : Nat = 10;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY ITEM TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MemoryType = {
    #Episodic;      // Events and experiences
    #Semantic;      // Facts and knowledge
    #Procedural;    // Skills and behaviors
    #Emotional;     // Emotional associations
    #Spatial;       // Locations and maps
    #Temporal;      // Time sequences
    #Social;        // Relationships and trust
    #Sensory;       // Perceptual patterns
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY ITEM STRUCTURE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MemoryItem = {
    id : Nat;
    memoryType : MemoryType;
    content : [Float];          // Pattern vector
    createdBeat : Nat;
    lastAccessedBeat : Nat;
    accessCount : Nat;
    strength : Float;           // [0, 1] - consolidation level
    emotionalValence : Float;   // [-1, 1] - positive/negative
    emotionalArousal : Float;   // [0, 1] - intensity
    contextTags : [Nat];        // Links to other memories
    compressed : Bool;
    layer : MemoryLayer;
  };
  
  public type MemoryLayer = {
    #Gamma;  // Working memory
    #Theta;  // Binding/resonance
    #Delta;  // Deep storage
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GAMMA LAYER (Working Memory)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GammaLayer = {
    var items : [var ?MemoryItem];   // Fixed size (7 slots)
    var attentionWeights : [var Float];
    var totalAccess : Nat;
    var lastUpdateBeat : Nat;
  };
  
  public func initGammaLayer() : GammaLayer {
    {
      var items = Array.init<?MemoryItem>(GAMMA_CAPACITY, null);
      var attentionWeights = Array.init<Float>(GAMMA_CAPACITY, 0.0);
      var totalAccess = 0;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THETA LAYER (Resonance/Binding)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ThetaLayer = {
    var activeBindings : Buffer.Buffer<MemoryBinding>;
    var resonanceStrength : Float;
    var lastSWRBeat : Nat;
    var totalBindings : Nat;
  };
  
  public type MemoryBinding = {
    gammaIndex : Nat;
    deltaId : Nat;
    strength : Float;
    createdBeat : Nat;
  };
  
  public func initThetaLayer() : ThetaLayer {
    {
      var activeBindings = Buffer.Buffer<MemoryBinding>(100);
      var resonanceStrength = 0.0;
      var lastSWRBeat = 0;
      var totalBindings = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DELTA LAYER (Deep Storage)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeltaLayer = {
    var patterns : Buffer.Buffer<MemoryItem>;
    var patternIndex : HashMap.HashMap<Text, Nat>; // Content hash → pattern ID
    var totalPatterns : Nat;
    var totalCapacity : Nat;
    var compressionRatio : Float;
    var lastConsolidationBeat : Nat;
  };
  
  public func initDeltaLayer() : DeltaLayer {
    {
      var patterns = Buffer.Buffer<MemoryItem>(1000);
      var patternIndex = HashMap.HashMap<Text, Nat>(100, Text.equal, Text.hash);
      var totalPatterns = 0;
      var totalCapacity = DELTA_MAX_PATTERNS;
      var compressionRatio = 1.0;
      var lastConsolidationBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM MEMORY STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumMemoryState = {
    var gamma : GammaLayer;
    var theta : ThetaLayer;
    var delta : DeltaLayer;
    
    // Memory gate state
    var gateOpen : Bool;
    var gateOutput : Float;
    var lastGateInputs : {
      attention : Float;
      coherence : Float;
      arousal : Float;
      predictionError : Float;
    };
    
    // Knowledge compounding
    var totalKnowledge : Float;
    var knowledgeByType : [var Float]; // Per memory type
    
    // Statistics
    var totalEncodings : Nat;
    var totalRetrievals : Nat;
    var totalConsolidations : Nat;
    var averageRetrievalTime : Float;
    
    // Timing
    var lastUpdateBeat : Nat;
    var nextConsolidationBeat : Nat;
  };
  
  public func initQuantumMemoryState() : QuantumMemoryState {
    {
      var gamma = initGammaLayer();
      var theta = initThetaLayer();
      var delta = initDeltaLayer();
      var gateOpen = false;
      var gateOutput = 0.0;
      var lastGateInputs = {
        attention = 0.0;
        coherence = 1.0;
        arousal = 0.5;
        predictionError = 0.0;
      };
      var totalKnowledge = 0.0;
      var knowledgeByType = Array.init<Float>(8, 0.0); // 8 memory types
      var totalEncodings = 0;
      var totalRetrievals = 0;
      var totalConsolidations = 0;
      var averageRetrievalTime = 0.0;
      var lastUpdateBeat = 0;
      var nextConsolidationBeat = 288; // First consolidation after one day
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY GATE
  // G = σ(α × Λ × A × |δ| − θ)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Sigmoid function
  public func sigmoid(x : Float) : Float {
    1.0 / (1.0 + Float.exp(-x))
  };
  
  /// Calculate memory gate output
  public func calculateMemoryGate(
    attention : Float,
    coherence : Float,
    arousal : Float,
    predictionError : Float
  ) : Float {
    let input = GATE_ALPHA * coherence * arousal * Float.abs(predictionError);
    sigmoid(input - GATE_THRESHOLD)
  };
  
  /// Update memory gate
  public func updateMemoryGate(
    state : QuantumMemoryState,
    attention : Float,
    coherence : Float,
    arousal : Float,
    predictionError : Float
  ) : () {
    state.lastGateInputs := {
      attention = attention;
      coherence = coherence;
      arousal = arousal;
      predictionError = predictionError;
    };
    
    state.gateOutput := calculateMemoryGate(attention, coherence, arousal, predictionError);
    state.gateOpen := state.gateOutput > 0.5;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GAMMA LAYER OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Find least attended slot in gamma layer
  public func findLeastAttendedSlot(gamma : GammaLayer) : Nat {
    var minWeight : Float = 1.0;
    var minIndex : Nat = 0;
    
    for (i in Iter.range(0, GAMMA_CAPACITY - 1)) {
      switch (gamma.items[i]) {
        case (null) { return i; }; // Empty slot takes priority
        case (?_) {
          if (gamma.attentionWeights[i] < minWeight) {
            minWeight := gamma.attentionWeights[i];
            minIndex := i;
          };
        };
      };
    };
    
    minIndex
  };
  
  /// Encode item into gamma layer
  public func encodeToGamma(
    state : QuantumMemoryState,
    item : MemoryItem
  ) : Bool {
    if (not state.gateOpen) { return false; };
    
    // Find slot
    let slot = findLeastAttendedSlot(state.gamma);
    
    // Store item
    state.gamma.items[slot] := ?{
      id = item.id;
      memoryType = item.memoryType;
      content = item.content;
      createdBeat = item.createdBeat;
      lastAccessedBeat = item.lastAccessedBeat;
      accessCount = 1;
      strength = state.gateOutput;
      emotionalValence = item.emotionalValence;
      emotionalArousal = item.emotionalArousal;
      contextTags = item.contextTags;
      compressed = false;
      layer = #Gamma;
    };
    
    // Update attention weight
    state.gamma.attentionWeights[slot] := state.lastGateInputs.attention;
    state.gamma.totalAccess += 1;
    state.totalEncodings += 1;
    
    true
  };
  
  /// Decay gamma layer strengths
  public func decayGammaLayer(state : QuantumMemoryState) : () {
    for (i in Iter.range(0, GAMMA_CAPACITY - 1)) {
      switch (state.gamma.items[i]) {
        case (null) {};
        case (?item) {
          let newStrength = item.strength * (1.0 - GAMMA_DECAY_RATE);
          if (newStrength < 0.1) {
            state.gamma.items[i] := null;
            state.gamma.attentionWeights[i] := 0.0;
          } else {
            state.gamma.items[i] := ?{
              id = item.id;
              memoryType = item.memoryType;
              content = item.content;
              createdBeat = item.createdBeat;
              lastAccessedBeat = item.lastAccessedBeat;
              accessCount = item.accessCount;
              strength = newStrength;
              emotionalValence = item.emotionalValence;
              emotionalArousal = item.emotionalArousal;
              contextTags = item.contextTags;
              compressed = item.compressed;
              layer = item.layer;
            };
          };
        };
      };
      
      // Decay attention weights
      state.gamma.attentionWeights[i] *= (1.0 - GAMMA_DECAY_RATE);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THETA LAYER OPERATIONS (Sharp-Wave Ripple)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create binding between gamma and delta items
  public func createBinding(
    theta : ThetaLayer,
    gammaIndex : Nat,
    deltaId : Nat,
    strength : Float,
    currentBeat : Nat
  ) : () {
    let binding : MemoryBinding = {
      gammaIndex = gammaIndex;
      deltaId = deltaId;
      strength = strength;
      createdBeat = currentBeat;
    };
    theta.activeBindings.add(binding);
    theta.totalBindings += 1;
  };
  
  /// Process Sharp-Wave Ripple for consolidation
  public func processSharpWaveRipple(
    state : QuantumMemoryState,
    currentBeat : Nat
  ) : Nat {
    var consolidatedCount : Nat = 0;
    
    // Replay gamma items to strengthen delta patterns
    for (i in Iter.range(0, GAMMA_CAPACITY - 1)) {
      switch (state.gamma.items[i]) {
        case (null) {};
        case (?gammaItem) {
          // Only consolidate strong enough items
          if (gammaItem.strength > 0.3) {
            // Find or create delta pattern
            let deltaItem = consolidateToDeltan(state, gammaItem, currentBeat);
            
            // Create theta binding
            createBinding(
              state.theta,
              i,
              deltaItem.id,
              gammaItem.strength * CONSOLIDATION_STRENGTH,
              currentBeat
            );
            
            consolidatedCount += 1;
          };
        };
      };
    };
    
    state.theta.lastSWRBeat := currentBeat;
    state.theta.resonanceStrength := Float.fromInt(consolidatedCount) / Float.fromInt(GAMMA_CAPACITY);
    state.totalConsolidations += consolidatedCount;
    
    consolidatedCount
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DELTA LAYER OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Generate content hash for pattern matching
  public func contentHash(content : [Float]) : Text {
    var hash : Nat32 = 0;
    for (v in content.vals()) {
      let intVal = Float.toInt(v * 1000.0);
      hash := hash +% Nat32.fromIntWrap(intVal);
    };
    Nat32.toText(hash)
  };
  
  /// Consolidate gamma item to delta layer
  public func consolidateToDeltan(
    state : QuantumMemoryState,
    gammaItem : MemoryItem,
    currentBeat : Nat
  ) : MemoryItem {
    let hash = contentHash(gammaItem.content);
    
    // Check if similar pattern exists
    switch (state.delta.patternIndex.get(hash)) {
      case (?existingId) {
        // Strengthen existing pattern
        if (existingId < state.delta.patterns.size()) {
          let existing = state.delta.patterns.get(existingId);
          let strengthened = {
            id = existing.id;
            memoryType = existing.memoryType;
            content = existing.content;
            createdBeat = existing.createdBeat;
            lastAccessedBeat = currentBeat;
            accessCount = existing.accessCount + 1;
            strength = Float.min(1.0, existing.strength + CONSOLIDATION_STRENGTH);
            emotionalValence = (existing.emotionalValence + gammaItem.emotionalValence) / 2.0;
            emotionalArousal = Float.max(existing.emotionalArousal, gammaItem.emotionalArousal);
            contextTags = existing.contextTags;
            compressed = existing.compressed;
            layer = #Delta;
          };
          state.delta.patterns.put(existingId, strengthened);
          return strengthened;
        };
      };
      case (null) {};
    };
    
    // Create new delta pattern
    let newId = state.delta.totalPatterns;
    let newItem : MemoryItem = {
      id = newId;
      memoryType = gammaItem.memoryType;
      content = gammaItem.content;
      createdBeat = gammaItem.createdBeat;
      lastAccessedBeat = currentBeat;
      accessCount = 1;
      strength = gammaItem.strength * CONSOLIDATION_STRENGTH;
      emotionalValence = gammaItem.emotionalValence;
      emotionalArousal = gammaItem.emotionalArousal;
      contextTags = gammaItem.contextTags;
      compressed = false;
      layer = #Delta;
    };
    
    state.delta.patterns.add(newItem);
    state.delta.patternIndex.put(hash, newId);
    state.delta.totalPatterns += 1;
    
    newItem
  };
  
  /// Decay delta layer strengths (very slow)
  public func decayDeltaLayer(state : QuantumMemoryState, currentBeat : Nat) : () {
    for (i in Iter.range(0, state.delta.patterns.size() - 1)) {
      let pattern = state.delta.patterns.get(i);
      let beatsSinceAccess = currentBeat - pattern.lastAccessedBeat;
      let decayFactor = Float.pow(1.0 - DELTA_DECAY_RATE, Float.fromInt(beatsSinceAccess));
      
      state.delta.patterns.put(i, {
        id = pattern.id;
        memoryType = pattern.memoryType;
        content = pattern.content;
        createdBeat = pattern.createdBeat;
        lastAccessedBeat = pattern.lastAccessedBeat;
        accessCount = pattern.accessCount;
        strength = pattern.strength * decayFactor;
        emotionalValence = pattern.emotionalValence;
        emotionalArousal = pattern.emotionalArousal;
        contextTags = pattern.contextTags;
        compressed = pattern.compressed;
        layer = pattern.layer;
      });
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RETRIEVAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate similarity between two patterns
  public func patternSimilarity(a : [Float], b : [Float]) : Float {
    if (a.size() != b.size()) { return 0.0; };
    
    var dotProduct : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    
    for (i in Iter.range(0, a.size() - 1)) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };
    
    if (normA == 0.0 or normB == 0.0) { return 0.0; };
    
    dotProduct / (Float.sqrt(normA) * Float.sqrt(normB))
  };
  
  /// Retrieve from delta layer by similarity
  public func retrieveFromDelta(
    state : QuantumMemoryState,
    cue : [Float],
    maxResults : Nat,
    currentBeat : Nat
  ) : [MemoryItem] {
    let results = Buffer.Buffer<(MemoryItem, Float)>(maxResults);
    
    for (i in Iter.range(0, state.delta.patterns.size() - 1)) {
      let pattern = state.delta.patterns.get(i);
      let similarity = patternSimilarity(cue, pattern.content);
      
      if (similarity > 0.5) {
        results.add((pattern, similarity));
        
        // Update access time
        state.delta.patterns.put(i, {
          id = pattern.id;
          memoryType = pattern.memoryType;
          content = pattern.content;
          createdBeat = pattern.createdBeat;
          lastAccessedBeat = currentBeat;
          accessCount = pattern.accessCount + 1;
          strength = Float.min(1.0, pattern.strength + 0.01);
          emotionalValence = pattern.emotionalValence;
          emotionalArousal = pattern.emotionalArousal;
          contextTags = pattern.contextTags;
          compressed = pattern.compressed;
          layer = pattern.layer;
        });
      };
    };
    
    // Sort by similarity and return top results
    let sorted = Array.sort<(MemoryItem, Float)>(
      Buffer.toArray(results),
      func (a : (MemoryItem, Float), b : (MemoryItem, Float)) : { #less; #equal; #greater } {
        if (a.1 > b.1) { #less }
        else if (a.1 < b.1) { #greater }
        else { #equal }
      }
    );
    
    state.totalRetrievals += 1;
    
    let topResults = Buffer.Buffer<MemoryItem>(maxResults);
    for (i in Iter.range(0, Int.min(maxResults - 1, sorted.size() - 1))) {
      topResults.add(sorted[i].0);
    };
    
    Buffer.toArray(topResults)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // KNOWLEDGE COMPOUNDING
  // K(t+1) = K(t) × (1 + r_learn)^Δt
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateKnowledgeCompounding(
    state : QuantumMemoryState,
    deltaBeats : Nat
  ) : () {
    let compoundFactor = Float.pow(1.0 + KNOWLEDGE_COMPOUNDING_RATE, Float.fromInt(deltaBeats));
    state.totalKnowledge *= compoundFactor;
  };
  
  /// Add new knowledge of a specific type
  public func addKnowledge(
    state : QuantumMemoryState,
    memoryType : MemoryType,
    amount : Float
  ) : () {
    let typeIndex = memoryTypeToIndex(memoryType);
    state.knowledgeByType[typeIndex] += amount;
    state.totalKnowledge += amount;
  };
  
  public func memoryTypeToIndex(memoryType : MemoryType) : Nat {
    switch (memoryType) {
      case (#Episodic) { 0 };
      case (#Semantic) { 1 };
      case (#Procedural) { 2 };
      case (#Emotional) { 3 };
      case (#Spatial) { 4 };
      case (#Temporal) { 5 };
      case (#Social) { 6 };
      case (#Sensory) { 7 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(
    state : QuantumMemoryState,
    currentBeat : Nat,
    attention : Float,
    coherence : Float,
    arousal : Float,
    predictionError : Float,
    isNightPhase : Bool
  ) : () {
    // Update memory gate
    updateMemoryGate(state, attention, coherence, arousal, predictionError);
    
    // Decay gamma layer every beat
    decayGammaLayer(state);
    
    // Knowledge compounding
    let deltaBeats = currentBeat - state.lastUpdateBeat;
    if (deltaBeats > 0) {
      updateKnowledgeCompounding(state, deltaBeats);
    };
    
    // Consolidation during night phase
    if (isNightPhase and currentBeat >= state.nextConsolidationBeat) {
      ignore processSharpWaveRipple(state, currentBeat);
      state.nextConsolidationBeat := currentBeat + 288; // Next day
    };
    
    // Decay delta layer periodically
    if (currentBeat % 1000 == 0) {
      decayDeltaLayer(state, currentBeat);
    };
    
    state.lastUpdateBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getStatistics(state : QuantumMemoryState) : {
    gammaOccupancy : Nat;
    deltaPatterns : Nat;
    thetaBindings : Nat;
    totalKnowledge : Float;
    totalEncodings : Nat;
    totalRetrievals : Nat;
    totalConsolidations : Nat;
    gateOutput : Float;
  } {
    var gammaOccupancy : Nat = 0;
    for (i in Iter.range(0, GAMMA_CAPACITY - 1)) {
      switch (state.gamma.items[i]) {
        case (?_) { gammaOccupancy += 1; };
        case (null) {};
      };
    };
    
    {
      gammaOccupancy = gammaOccupancy;
      deltaPatterns = state.delta.totalPatterns;
      thetaBindings = state.theta.totalBindings;
      totalKnowledge = state.totalKnowledge;
      totalEncodings = state.totalEncodings;
      totalRetrievals = state.totalRetrievals;
      totalConsolidations = state.totalConsolidations;
      gateOutput = state.gateOutput;
    }
  };

}
