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

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// MEMORY REPLAY CONSOLIDATION ENGINE — SLEEP-PHASE MEMORY TRANSFER TO WEIGHTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements memory replay and consolidation during rest/sleep phases. It generates sharp-wave
// ripples, selects important memories for replay, and transfers episodic memories into Hebbian weight changes.
//
// MATHEMATICAL FOUNDATIONS:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// Replay Selection Probability:
//   P(replay[i]) ∝ importance[i] × recency_decay[i] × surprise[i]
//   recency_decay = exp(-age/τ_decay)
//
// Sharp-Wave Ripple (SWR):
//   f_SWR = 150-250 Hz
//   Amplitude modulated by memory importance
//   Duration: 50-100ms per ripple
//
// Consolidation (Memory → Weight Transfer):
//   Δw_ij = α_consolidate × replay_activity_i × target_activity_j
//   where α_consolidate is lower than online learning rate (slow consolidation)
//
// Forgetting Protection:
//   If replay_count[memory] > θ_protect → long_term_flag = true
//   Long-term memories have reduced decay rate
//
// Two-Stage Memory Model:
//   Stage 1 (Fast): Episodic buffer (hippocampus-like) - immediate storage
//   Stage 2 (Slow): Hebbian weights (cortex-like) - permanent storage
//   Replay bridges these two stages during rest
//
// IMPORTANCE SCORING:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Surprise: prediction_error at encoding
// • Emotional salience: arousal level at encoding
// • Causal significance: was this event causally important?
// • Repetition: has this pattern been seen before?
// • Doctrine relevance: alignment with sovereignty laws
//
// INTEGRATION WITH ORGANISM:
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────
// • Activates during low-arousal rest states (DriveMode = #Rest)
// • Generates SWR-like bursts that trigger replay
// • Modifies Hebbian weights based on replayed memories
// • Protects important memories from catastrophic forgetting
// • Reports consolidation statistics to PROMETHEUS
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";
import Order "mo:core/Order";

module MemoryReplayConsolidationEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum episodic buffer size
  public let MAX_EPISODIC_BUFFER : Nat = 200;
  
  /// Replay batch size (memories per consolidation cycle)
  public let REPLAY_BATCH_SIZE : Nat = 10;
  
  /// Recency decay time constant (in beats)
  public let RECENCY_TAU : Float = 1000.0;
  
  /// Consolidation learning rate (slower than online learning)
  public let CONSOLIDATION_ALPHA : Float = 0.001;
  
  /// Protection threshold (replay count for long-term storage)
  public let PROTECTION_THRESHOLD : Nat = 5;
  
  /// Minimum importance for replay consideration
  public let MIN_IMPORTANCE : Float = 0.1;
  
  /// Sharp-wave ripple frequency range (Hz)
  public let SWR_FREQ_MIN : Float = 150.0;
  public let SWR_FREQ_MAX : Float = 250.0;
  
  /// SWR duration range (ms)
  public let SWR_DURATION_MIN : Float = 50.0;
  public let SWR_DURATION_MAX : Float = 100.0;
  
  /// Rest state arousal threshold (below this triggers consolidation)
  public let REST_AROUSAL_THRESHOLD : Float = 0.3;
  
  /// S₀ floor integration
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;
  
  /// Causal field count per memory (from CANONICAL.md)
  public let CAUSAL_FIELDS_PER_MEMORY : Nat = 5;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// An episodic memory trace
  public type EpisodicMemory = {
    id : Nat;
    encodingBeat : Int;           // When this memory was formed
    pattern : [Float];            // The neural activation pattern
    patternDimension : Nat;
    
    // Causal fields (from CANONICAL.md)
    causalBackwardPath : [Nat];   // Trace back to causal ancestors
    causalWeight : Float;         // Strength of causal influence
    parentEventId : ?Nat;         // Direct parent event reference
    priorStateHash : Nat64;       // State hash before this episode
    driveAtEvent : Nat8;          // Which drive was active
    
    // Importance factors
    var importance : Float;
    var surprise : Float;         // Prediction error at encoding
    var emotionalSalience : Float; // Arousal at encoding
    var doctrineRelevance : Float; // Alignment with laws
    
    // Replay statistics
    var replayCount : Nat;
    var lastReplayBeat : Int;
    var isProtected : Bool;       // Long-term memory flag
    var consolidationStrength : Float; // How much transferred to weights
  };
  
  /// Memory importance scoring weights
  public type ImportanceWeights = {
    surpriseWeight : Float;
    emotionalWeight : Float;
    causalWeight : Float;
    doctrineWeight : Float;
    recencyWeight : Float;
  };
  
  /// Default importance weights
  public let DEFAULT_IMPORTANCE_WEIGHTS : ImportanceWeights = {
    surpriseWeight = 0.3;
    emotionalWeight = 0.2;
    causalWeight = 0.25;
    doctrineWeight = 0.15;
    recencyWeight = 0.1;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SHARP-WAVE RIPPLE TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// A sharp-wave ripple event
  public type SharpWaveRipple = {
    id : Nat;
    startBeat : Int;
    frequency : Float;            // Hz within SWR range
    duration : Float;             // Duration in ms
    amplitude : Float;            // Amplitude (0-1)
    memoriesTriggered : [Nat];    // Memory IDs replayed during this SWR
    var isComplete : Bool;
  };
  
  /// SWR generator state
  public type SWRGenerator = {
    var currentRipple : ?SharpWaveRipple;
    var totalRipples : Nat;
    var rippleHistory : Buffer.Buffer<SharpWaveRipple>;
    var lastRippleBeat : Int;
    var minInterRippleInterval : Nat; // Minimum beats between ripples
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSOLIDATION RESULT TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Result of one consolidation cycle
  public type ConsolidationResult = {
    memoriesReplayed : Nat;
    weightChangesApplied : Nat;
    totalDeltaWeight : Float;
    newlyProtectedMemories : Nat;
    avgImportance : Float;
  };
  
  /// Weight change from consolidation
  public type WeightDelta = {
    sourceNode : Nat;
    targetNode : Nat;
    delta : Float;
    memorySource : Nat;           // Which memory caused this change
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EPISODIC BUFFER TYPE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// The episodic memory buffer (hippocampus-like fast storage)
  public type EpisodicBuffer = {
    memories : Buffer.Buffer<EpisodicMemory>;
    var capacity : Nat;
    var oldestMemoryBeat : Int;
    var newestMemoryBeat : Int;
    var totalMemoriesStored : Nat;
    var totalMemoriesConsolidated : Nat;
    var totalMemoriesForgotten : Nat;
    importanceWeights : ImportanceWeights;
  };
  
  /// Initialize episodic buffer
  public func initEpisodicBuffer(capacity : Nat) : EpisodicBuffer {
    {
      memories = Buffer.Buffer<EpisodicMemory>(capacity);
      var capacity = capacity;
      var oldestMemoryBeat = 0;
      var newestMemoryBeat = 0;
      var totalMemoriesStored = 0;
      var totalMemoriesConsolidated = 0;
      var totalMemoriesForgotten = 0;
      importanceWeights = DEFAULT_IMPORTANCE_WEIGHTS;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSOLIDATION STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Complete consolidation engine state
  public type ConsolidationState = {
    buffer : EpisodicBuffer;
    swrGenerator : SWRGenerator;
    var isInRestState : Bool;
    var currentArousal : Float;
    var pendingWeightDeltas : Buffer.Buffer<WeightDelta>;
    var consolidationHistory : Buffer.Buffer<ConsolidationResult>;
    var totalConsolidationCycles : Nat;
    var lastConsolidationBeat : Int;
    var memoryIdCounter : Nat;
  };
  
  /// Initialize consolidation state
  public func initConsolidationState() : ConsolidationState {
    {
      buffer = initEpisodicBuffer(MAX_EPISODIC_BUFFER);
      swrGenerator = {
        var currentRipple = null;
        var totalRipples = 0;
        var rippleHistory = Buffer.Buffer<SharpWaveRipple>(100);
        var lastRippleBeat = 0;
        var minInterRippleInterval = 5;
      };
      var isInRestState = false;
      var currentArousal = 0.5;
      var pendingWeightDeltas = Buffer.Buffer<WeightDelta>(1000);
      var consolidationHistory = Buffer.Buffer<ConsolidationResult>(100);
      var totalConsolidationCycles = 0;
      var lastConsolidationBeat = 0;
      var memoryIdCounter = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY ENCODING — STORING NEW MEMORIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Encode a new episodic memory
  public func encodeMemory(
    state : ConsolidationState,
    pattern : [Float],
    surprise : Float,
    arousal : Float,
    driveMode : Nat8,
    causalParent : ?Nat,
    priorStateHash : Nat64,
    doctrineRelevance : Float,
    currentBeat : Int
  ) : Nat {
    let memoryId = state.memoryIdCounter;
    state.memoryIdCounter += 1;
    
    // Compute initial importance
    let importance = computeImportance(
      surprise,
      arousal,
      1.0,  // Causal weight (newly encoded, max recency)
      doctrineRelevance,
      1.0,  // Full recency for new memory
      state.buffer.importanceWeights
    );
    
    // Build causal path
    let causalPath = switch (causalParent) {
      case (?parentId) {
        // Find parent's path and extend
        var parentPath : [Nat] = [];
        for (mem in state.buffer.memories.vals()) {
          if (mem.id == parentId) {
            parentPath := Array.append(mem.causalBackwardPath, [parentId]);
          };
        };
        parentPath
      };
      case (null) { [] };
    };
    
    let memory : EpisodicMemory = {
      id = memoryId;
      encodingBeat = currentBeat;
      pattern = pattern;
      patternDimension = pattern.size();
      causalBackwardPath = causalPath;
      causalWeight = 1.0;
      parentEventId = causalParent;
      priorStateHash = priorStateHash;
      driveAtEvent = driveMode;
      var importance = importance;
      var surprise = surprise;
      var emotionalSalience = arousal;
      var doctrineRelevance = doctrineRelevance;
      var replayCount = 0;
      var lastReplayBeat = currentBeat;
      var isProtected = false;
      var consolidationStrength = 0.0;
    };
    
    // Check buffer capacity
    if (state.buffer.memories.size() >= state.buffer.capacity) {
      // Remove least important unprotected memory
      removeLowestImportanceMemory(state);
    };
    
    state.buffer.memories.add(memory);
    state.buffer.totalMemoriesStored += 1;
    state.buffer.newestMemoryBeat := currentBeat;
    
    if (state.buffer.oldestMemoryBeat == 0) {
      state.buffer.oldestMemoryBeat := currentBeat;
    };
    
    memoryId
  };
  
  /// Compute memory importance score
  public func computeImportance(
    surprise : Float,
    emotional : Float,
    causal : Float,
    doctrine : Float,
    recency : Float,
    weights : ImportanceWeights
  ) : Float {
    weights.surpriseWeight * surprise +
    weights.emotionalWeight * emotional +
    weights.causalWeight * causal +
    weights.doctrineWeight * doctrine +
    weights.recencyWeight * recency
  };
  
  /// Remove the lowest importance unprotected memory
  func removeLowestImportanceMemory(state : ConsolidationState) : () {
    var lowestIdx : ?Nat = null;
    var lowestImportance : Float = 1000.0;
    
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      let mem = state.buffer.memories.get(i);
      if (not mem.isProtected and mem.importance < lowestImportance) {
        lowestImportance := mem.importance;
        lowestIdx := ?i;
      };
    };
    
    switch (lowestIdx) {
      case (?idx) {
        let _ = state.buffer.memories.remove(idx);
        state.buffer.totalMemoriesForgotten += 1;
      };
      case (null) {};
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SHARP-WAVE RIPPLE GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Generate a sharp-wave ripple
  public func generateSWR(
    state : ConsolidationState,
    currentBeat : Int,
    seed : Nat
  ) : ?SharpWaveRipple {
    let gen = state.swrGenerator;
    
    // Check if we can generate a new ripple
    if (currentBeat - gen.lastRippleBeat < gen.minInterRippleInterval) {
      return null;
    };
    
    // Generate SWR parameters
    let freqRange = SWR_FREQ_MAX - SWR_FREQ_MIN;
    let freq = SWR_FREQ_MIN + 
               Float.fromInt((seed * 7) % 1000) / 1000.0 * freqRange;
    
    let durRange = SWR_DURATION_MAX - SWR_DURATION_MIN;
    let duration = SWR_DURATION_MIN +
                   Float.fromInt((seed * 13) % 1000) / 1000.0 * durRange;
    
    // Amplitude based on arousal (lower arousal = stronger ripples during rest)
    let amplitude = 1.0 - state.currentArousal;
    
    let ripple : SharpWaveRipple = {
      id = gen.totalRipples;
      startBeat = currentBeat;
      frequency = freq;
      duration = duration;
      amplitude = amplitude;
      memoriesTriggered = [];  // Will be filled during replay
      var isComplete = false;
    };
    
    gen.currentRipple := ?ripple;
    gen.totalRipples += 1;
    gen.lastRippleBeat := currentBeat;
    
    ?ripple
  };
  
  /// Complete current SWR and add to history
  func completeSWR(state : ConsolidationState, memoriesReplayed : [Nat]) : () {
    switch (state.swrGenerator.currentRipple) {
      case (?ripple) {
        let completed : SharpWaveRipple = {
          id = ripple.id;
          startBeat = ripple.startBeat;
          frequency = ripple.frequency;
          duration = ripple.duration;
          amplitude = ripple.amplitude;
          memoriesTriggered = memoriesReplayed;
          var isComplete = true;
        };
        state.swrGenerator.rippleHistory.add(completed);
        state.swrGenerator.currentRipple := null;
      };
      case (null) {};
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // REPLAY SELECTION — CHOOSING MEMORIES TO REPLAY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update importance scores based on age (recency decay)
  public func updateImportanceScores(
    state : ConsolidationState,
    currentBeat : Int
  ) : () {
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      let mem = state.buffer.memories.get(i);
      
      // Recency decay: exp(-age/τ)
      let age = Float.fromInt(currentBeat - mem.encodingBeat);
      let recencyFactor = Float.exp(-age / RECENCY_TAU);
      
      // Recompute importance
      mem.importance := computeImportance(
        mem.surprise,
        mem.emotionalSalience,
        mem.causalWeight,
        mem.doctrineRelevance,
        recencyFactor,
        state.buffer.importanceWeights
      );
      
      // Protected memories decay slower
      if (mem.isProtected) {
        mem.importance := Float.max(mem.importance, S_ZERO_FLOOR);
      };
    };
  };
  
  /// Select memories for replay based on importance
  /// P(replay[i]) ∝ importance[i]
  public func selectMemoriesForReplay(
    state : ConsolidationState,
    batchSize : Nat,
    seed : Nat
  ) : [Nat] {
    let candidates = Buffer.Buffer<(Nat, Float)>(state.buffer.memories.size());
    
    // Collect eligible memories with importance
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      let mem = state.buffer.memories.get(i);
      if (mem.importance >= MIN_IMPORTANCE) {
        candidates.add((i, mem.importance));
      };
    };
    
    if (candidates.size() == 0) { return [] };
    
    // Compute total importance for probability normalization
    var totalImportance : Float = 0.0;
    for ((_, imp) in candidates.vals()) {
      totalImportance += imp;
    };
    
    // Select memories using importance-weighted sampling
    let selected = Buffer.Buffer<Nat>(batchSize);
    var currentSeed = seed;
    
    for (b in Iter.range(0, batchSize - 1)) {
      if (candidates.size() == 0) { 
        // No more candidates
        return Buffer.toArray(selected);
      };
      
      // Random threshold
      currentSeed := (currentSeed * 1103515245 + 12345) % 2147483647;
      let threshold = Float.fromInt(currentSeed % 1000000) / 1000000.0 * totalImportance;
      
      // Select memory by cumulative probability
      var cumSum : Float = 0.0;
      for ((idx, imp) in candidates.vals()) {
        cumSum += imp;
        if (cumSum >= threshold) {
          selected.add(idx);
          totalImportance -= imp;
          // Remove from candidates to avoid reselection
          // (simplified: just mark as selected)
          break;  // Exit inner loop
        };
      };
    };
    
    Buffer.toArray(selected)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY REPLAY — REACTIVATING PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Replay a single memory and generate weight deltas
  public func replayMemory(
    state : ConsolidationState,
    memoryIdx : Nat,
    currentBeat : Int
  ) : [WeightDelta] {
    if (memoryIdx >= state.buffer.memories.size()) { return [] };
    
    let mem = state.buffer.memories.get(memoryIdx);
    let pattern = mem.pattern;
    let n = pattern.size();
    
    let deltas = Buffer.Buffer<WeightDelta>(n * n / 4);  // Sparse estimate
    
    // Generate Hebbian weight changes from replay
    // Δw_ij = α × x_i × x_j for correlated activations
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let xi = pattern[i];
        let xj = pattern[j];
        
        // Only generate delta if both activations significant
        if (Float.abs(xi) > 0.1 and Float.abs(xj) > 0.1) {
          let delta = CONSOLIDATION_ALPHA * xi * xj * mem.importance;
          
          if (Float.abs(delta) > 1e-6) {
            deltas.add({
              sourceNode = i;
              targetNode = j;
              delta = delta;
              memorySource = mem.id;
            });
          };
        };
      };
    };
    
    // Update memory replay statistics
    mem.replayCount += 1;
    mem.lastReplayBeat := currentBeat;
    mem.consolidationStrength += 0.1;
    
    // Check for protection threshold
    if (mem.replayCount >= PROTECTION_THRESHOLD and not mem.isProtected) {
      mem.isProtected := true;
    };
    
    Buffer.toArray(deltas)
  };
  
  /// Replay a batch of memories
  public func replayBatch(
    state : ConsolidationState,
    memoryIndices : [Nat],
    currentBeat : Int
  ) : [WeightDelta] {
    let allDeltas = Buffer.Buffer<WeightDelta>(1000);
    
    for (idx in memoryIndices.vals()) {
      let deltas = replayMemory(state, idx, currentBeat);
      for (d in deltas.vals()) {
        allDeltas.add(d);
      };
    };
    
    Buffer.toArray(allDeltas)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSOLIDATION — APPLYING WEIGHT CHANGES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one consolidation cycle
  public func runConsolidationCycle(
    state : ConsolidationState,
    currentBeat : Int,
    seed : Nat
  ) : ConsolidationResult {
    // Update importance scores
    updateImportanceScores(state, currentBeat);
    
    // Select memories for replay
    let selected = selectMemoriesForReplay(state, REPLAY_BATCH_SIZE, seed);
    
    // Generate SWR
    let _ = generateSWR(state, currentBeat, seed);
    
    // Replay memories and collect weight deltas
    let deltas = replayBatch(state, selected, currentBeat);
    
    // Add deltas to pending queue
    for (d in deltas.vals()) {
      state.pendingWeightDeltas.add(d);
    };
    
    // Complete SWR
    completeSWR(state, Array.map<Nat, Nat>(selected, func(idx : Nat) : Nat {
      state.buffer.memories.get(idx).id
    }));
    
    // Count newly protected memories
    var newlyProtected : Nat = 0;
    for (idx in selected.vals()) {
      if (idx < state.buffer.memories.size()) {
        let mem = state.buffer.memories.get(idx);
        if (mem.replayCount == PROTECTION_THRESHOLD) {
          newlyProtected += 1;
        };
      };
    };
    
    // Compute average importance of replayed memories
    var sumImportance : Float = 0.0;
    for (idx in selected.vals()) {
      if (idx < state.buffer.memories.size()) {
        sumImportance += state.buffer.memories.get(idx).importance;
      };
    };
    let avgImportance = if (selected.size() > 0) {
      sumImportance / Float.fromInt(selected.size())
    } else { 0.0 };
    
    // Compute total delta weight
    var totalDelta : Float = 0.0;
    for (d in deltas.vals()) {
      totalDelta += Float.abs(d.delta);
    };
    
    let result : ConsolidationResult = {
      memoriesReplayed = selected.size();
      weightChangesApplied = deltas.size();
      totalDeltaWeight = totalDelta;
      newlyProtectedMemories = newlyProtected;
      avgImportance = avgImportance;
    };
    
    state.consolidationHistory.add(result);
    state.totalConsolidationCycles += 1;
    state.lastConsolidationBeat := currentBeat;
    state.buffer.totalMemoriesConsolidated += selected.size();
    
    result
  };
  
  /// Get pending weight deltas and clear queue
  public func getPendingWeightDeltas(state : ConsolidationState) : [WeightDelta] {
    let deltas = Buffer.toArray(state.pendingWeightDeltas);
    state.pendingWeightDeltas.clear();
    deltas
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // REST STATE DETECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update arousal and check for rest state
  public func updateArousalState(
    state : ConsolidationState,
    arousal : Float,
    driveMode : Nat8  // 0=Exploration, 1=Execution, 2=Rest, 3=Learning
  ) : Bool {
    state.currentArousal := arousal;
    
    // Enter rest state if arousal low or drive mode is Rest
    let wasInRest = state.isInRestState;
    state.isInRestState := arousal < REST_AROUSAL_THRESHOLD or driveMode == 2;
    
    // Return true if just entered rest state
    state.isInRestState and not wasInRest
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CAUSAL PRESSURE COMPUTATION (from CANONICAL.md)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute causal pressure from episodic buffer
  /// causal_pressure(t) = Σ(i=0 to 199) [episode[i].causalWeight × decay(t - timestamp)]
  public func computeCausalPressure(
    state : ConsolidationState,
    currentBeat : Int
  ) : Float {
    var pressure : Float = 0.0;
    
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      let mem = state.buffer.memories.get(i);
      let age = Float.fromInt(currentBeat - mem.encodingBeat);
      let decay = Float.exp(-age / RECENCY_TAU);
      pressure += mem.causalWeight * decay;
    };
    
    pressure
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Main heartbeat update for memory consolidation
  public func heartbeatUpdate(
    state : ConsolidationState,
    arousal : Float,
    driveMode : Nat8,
    currentBeat : Int,
    seed : Nat
  ) : {
    isResting : Bool;
    consolidationRan : Bool;
    memoriesReplayed : Nat;
    weightChanges : Nat;
    causalPressure : Float;
    protectedMemories : Nat;
    bufferUtilization : Float;
  } {
    // Update arousal state
    let justEnteredRest = updateArousalState(state, arousal, driveMode);
    
    var memoriesReplayed : Nat = 0;
    var weightChanges : Nat = 0;
    var consolidationRan = false;
    
    // Run consolidation if in rest state
    if (state.isInRestState) {
      // Run more frequently when just entering rest
      let consolidationInterval = if (justEnteredRest) { 1 } else { 5 };
      
      if ((currentBeat - state.lastConsolidationBeat) >= consolidationInterval) {
        let result = runConsolidationCycle(state, currentBeat, seed);
        memoriesReplayed := result.memoriesReplayed;
        weightChanges := result.weightChangesApplied;
        consolidationRan := true;
      };
    };
    
    // Compute causal pressure
    let causalPressure = computeCausalPressure(state, currentBeat);
    
    // Count protected memories
    var protectedCount : Nat = 0;
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      if (state.buffer.memories.get(i).isProtected) {
        protectedCount += 1;
      };
    };
    
    // Buffer utilization
    let utilization = Float.fromInt(state.buffer.memories.size()) / 
                      Float.fromInt(state.buffer.capacity);
    
    {
      isResting = state.isInRestState;
      consolidationRan = consolidationRan;
      memoriesReplayed = memoriesReplayed;
      weightChanges = weightChanges;
      causalPressure = causalPressure;
      protectedMemories = protectedCount;
      bufferUtilization = utilization;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get memory count
  public func getMemoryCount(state : ConsolidationState) : Nat {
    state.buffer.memories.size()
  };
  
  /// Get protected memory count
  public func getProtectedCount(state : ConsolidationState) : Nat {
    var count : Nat = 0;
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      if (state.buffer.memories.get(i).isProtected) {
        count += 1;
      };
    };
    count
  };
  
  /// Get total consolidation cycles
  public func getTotalConsolidations(state : ConsolidationState) : Nat {
    state.totalConsolidationCycles
  };
  
  /// Get total SWR count
  public func getTotalRipples(state : ConsolidationState) : Nat {
    state.swrGenerator.totalRipples
  };
  
  /// Check if currently in rest state
  public func isInRestState(state : ConsolidationState) : Bool {
    state.isInRestState
  };
  
  /// Get memory by ID
  public func getMemory(state : ConsolidationState, memoryId : Nat) : ?EpisodicMemory {
    for (i in Iter.range(0, state.buffer.memories.size() - 1)) {
      let mem = state.buffer.memories.get(i);
      if (mem.id == memoryId) {
        return ?mem;
      };
    };
    null
  };
  
  /// Get buffer statistics
  public func getBufferStats(state : ConsolidationState) : {
    size : Nat;
    capacity : Nat;
    totalStored : Nat;
    totalConsolidated : Nat;
    totalForgotten : Nat;
    utilization : Float;
  } {
    {
      size = state.buffer.memories.size();
      capacity = state.buffer.capacity;
      totalStored = state.buffer.totalMemoriesStored;
      totalConsolidated = state.buffer.totalMemoriesConsolidated;
      totalForgotten = state.buffer.totalMemoriesForgotten;
      utilization = Float.fromInt(state.buffer.memories.size()) / 
                   Float.fromInt(state.buffer.capacity);
    }
  };

}
