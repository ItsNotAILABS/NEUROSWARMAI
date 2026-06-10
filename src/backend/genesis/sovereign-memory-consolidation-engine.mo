// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  SOVEREIGN MEMORY CONSOLIDATION ENGINE                                                                    ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  This module implements deep memory consolidation:                                                        ║
// ║  • Systems consolidation (hippocampus → neocortex)                                                       ║
// ║  • Sleep-dependent memory processing                                                                      ║
// ║  • Sharp-wave ripple replay                                                                               ║
// ║  • Schema formation and abstraction                                                                       ║
// ║  • Memory tagging and synaptic tagging                                                                   ║
// ║  • Reconsolidation and memory updating                                                                   ║
// ║  • Forgetting curves and interference                                                                    ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Iter "mo:core/Iter";

module {
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  let PI : Float = 3.14159265358979323846;
  let E : Float = 2.71828182845904523536;
  let PHI : Float = 1.61803398874989484820;
  let SOVEREIGN_FLOOR : Float = 0.75;
  
  // Memory decay constants (Ebbinghaus)
  let DECAY_B : Float = 1.25;          // Decay exponent
  let INITIAL_RETENTION : Float = 1.0;
  let DECAY_C : Float = 1.84;          // Decay coefficient
  
  // Consolidation time constants (hours)
  let FAST_CONSOLIDATION : Int = 1;    // 1 hour
  let MEDIUM_CONSOLIDATION : Int = 24; // 1 day
  let SLOW_CONSOLIDATION : Int = 168;  // 1 week
  let DEEP_CONSOLIDATION : Int = 720;  // 1 month
  
  // Sleep stage durations (relative)
  let NREM1_FRACTION : Float = 0.05;
  let NREM2_FRACTION : Float = 0.50;
  let NREM3_FRACTION : Float = 0.20;
  let REM_FRACTION : Float = 0.25;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - MEMORY TRACES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Memory trace - fundamental unit of memory
  public type MemoryTrace = {
    traceId : Nat;
    content : [Float];               // Memory content vector
    category : MemoryCategory;
    encoding : EncodingType;
    
    // Strength metrics
    strength : Float;                // Current strength
    initialStrength : Float;         // Original encoding strength
    consolidationLevel : Float;      // 0 = hippocampal, 1 = neocortical
    
    // Temporal
    encodingTime : Int;
    lastRetrievalTime : Int;
    retrievalCount : Nat;
    
    // Tagging
    emotionalTag : Float;            // Emotional salience
    synapticTag : SynapticTag;
    contextTags : [Text];
    
    // Interference
    interferenceLevel : Float;
    competingTraces : [Nat];
    
    // State
    isActive : Bool;
    needsReconsolidation : Bool;
    isProtected : Bool;              // AEGIS protected
  };
  
  public type MemoryCategory = {
    #Episodic;                        // Personal events
    #Semantic;                        // Facts and knowledge
    #Procedural;                      // Skills and habits
    #Working;                         // Active manipulation
    #Prospective;                     // Future intentions
    #Emotional;                       // Emotional memories
  };
  
  public type EncodingType = {
    #Deep;                            // Deep processing
    #Shallow;                         // Surface processing
    #Incidental;                      // Unintentional encoding
    #Intentional;                     // Deliberate encoding
    #Elaborative;                     // Rich associations
  };
  
  public type SynapticTag = {
    isSet : Bool;
    tagStrength : Float;
    proteinSynthesis : Float;        // PRP availability
    tagDecay : Float;
    captureWindow : Int;             // Time window for capture
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - CONSOLIDATION SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Hippocampal system
  public type HippocampalSystem = {
    var capacity : Nat;
    var currentLoad : Nat;
    var activeTraces : Buffer.Buffer<Nat>; // Trace indices
    var replayQueue : Buffer.Buffer<Nat>;
    var bindingStrength : Float;
    var patternSeparation : Float;
    var patternCompletion : Float;
    var indexingEfficiency : Float;
  };
  
  /// Neocortical system
  public type NeocorticalSystem = {
    var schemas : Buffer.Buffer<Schema>;
    var consolidatedTraces : Buffer.Buffer<Nat>;
    var integrationLevel : Float;
    var abstractionCapacity : Float;
    var interleaving : Float;        // How interleaved learning is
  };
  
  public type Schema = {
    schemaId : Nat;
    name : Text;
    prototype : [Float];             // Abstract prototype
    instances : [Nat];               // Trace indices
    flexibility : Float;             // How easily updated
    consistency : Float;             // Internal consistency
    lastUpdateTime : Int;
  };
  
  /// Systems consolidation state
  public type SystemsConsolidation = {
    var hippocampal : HippocampalSystem;
    var neocortical : NeocorticalSystem;
    var transferRate : Float;        // Hip → Neo transfer rate
    var currentPhase : ConsolidationPhase;
    var sleepCycles : Nat;
  };
  
  public type ConsolidationPhase = {
    #Encoding;
    #EarlyConsolidation;
    #SleepDependent;
    #LateConsolidation;
    #Stable;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - SLEEP PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Sleep state
  public type SleepState = {
    var isAsleep : Bool;
    var currentStage : SleepStage;
    var stageTime : Int;             // Time in current stage
    var cycleNumber : Nat;
    var totalSleepTime : Int;
    var sleepPressure : Float;       // Homeostatic sleep pressure
    var circadianPhase : Float;
  };
  
  public type SleepStage = {
    #Awake;
    #NREM1;                           // Light sleep
    #NREM2;                           // Spindles, K-complexes
    #NREM3;                           // Slow-wave sleep (SWS)
    #REM;                             // Rapid eye movement
  };
  
  /// Sharp-wave ripple (SWR)
  public type SharpWaveRipple = {
    rippleId : Nat;
    timestamp : Int;
    duration : Int;
    amplitude : Float;
    frequency : Float;               // ~150-250 Hz
    replayedTraces : [Nat];          // Which memories replayed
    compressionRatio : Float;        // Temporal compression
    isForward : Bool;                // Forward vs reverse replay
  };
  
  /// Sleep spindle
  public type SleepSpindle = {
    spindleId : Nat;
    timestamp : Int;
    duration : Int;
    frequency : Float;               // ~12-14 Hz
    amplitude : Float;
    coupledRipples : [Nat];          // Ripples coupled to this spindle
    thalamicOrigin : Bool;
  };
  
  /// Slow oscillation
  public type SlowOscillation = {
    oscillationId : Nat;
    timestamp : Int;
    upStateStart : Int;
    upStateDuration : Int;
    downStateDuration : Int;
    amplitude : Float;
    frequency : Float;               // ~0.5-1 Hz
    nestedSpindles : [Nat];
    nestedRipples : [Nat];
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - FORGETTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Forgetting curve parameters
  public type ForgettingCurve = {
    decayRate : Float;               // Individual decay rate
    retrievalPracticeBoost : Float;  // Benefit from testing
    spacingEffect : Float;           // Benefit from spacing
    interferenceCoeff : Float;
    consolidationBonus : Float;
  };
  
  /// Interference tracking
  public type InterferenceState = {
    var retroactiveInterference : Float;  // New → old
    var proactiveInterference : Float;    // Old → new
    var outputInterference : Float;       // During retrieval
    var fanEffect : Float;                // More associations = slower
    var distinctiveness : Float;          // Protection from interference
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - RECONSOLIDATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Reconsolidation event
  public type ReconsolidationEvent = {
    eventId : Nat;
    traceId : Nat;
    triggerTime : Int;
    destabilizationStrength : Float;
    updateContent : [Float];
    restabilizationTime : Int;
    wasSuccessful : Bool;
  };
  
  /// Reconsolidation window
  public type ReconsolidationWindow = {
    isOpen : Bool;
    openTime : Int;
    windowDuration : Int;            // ~6 hours typically
    targetTrace : Nat;
    vulnerability : Float;           // How susceptible to modification
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MemoryConsolidationState = {
    // Memory traces
    var traces : Buffer.Buffer<MemoryTrace>;
    var traceCapacity : Nat;
    
    // Systems consolidation
    var systemsConsolidation : SystemsConsolidation;
    
    // Sleep processing
    var sleepState : SleepState;
    var sharpWaveRipples : Buffer.Buffer<SharpWaveRipple>;
    var sleepSpindles : Buffer.Buffer<SleepSpindle>;
    var slowOscillations : Buffer.Buffer<SlowOscillation>;
    
    // Forgetting
    var forgettingCurve : ForgettingCurve;
    var interferenceState : InterferenceState;
    
    // Reconsolidation
    var reconsolidationEvents : Buffer.Buffer<ReconsolidationEvent>;
    var activeWindows : Buffer.Buffer<ReconsolidationWindow>;
    
    // Integration metrics
    var overallConsolidation : Float;
    var memoryStability : Float;
    var retrievalEfficiency : Float;
    
    // Temporal
    var tickCount : Nat;
    var lastTickTime : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize memory consolidation engine
  public func initMemoryConsolidation(capacity : Nat) : MemoryConsolidationState {
    let now = Time.now();
    
    {
      var traces = Buffer.Buffer<MemoryTrace>(capacity);
      var traceCapacity = capacity;
      var systemsConsolidation = initSystemsConsolidation();
      var sleepState = initSleepState();
      var sharpWaveRipples = Buffer.Buffer<SharpWaveRipple>(1024);
      var sleepSpindles = Buffer.Buffer<SleepSpindle>(512);
      var slowOscillations = Buffer.Buffer<SlowOscillation>(256);
      var forgettingCurve = initForgettingCurve();
      var interferenceState = initInterferenceState();
      var reconsolidationEvents = Buffer.Buffer<ReconsolidationEvent>(256);
      var activeWindows = Buffer.Buffer<ReconsolidationWindow>(16);
      var overallConsolidation = SOVEREIGN_FLOOR;
      var memoryStability = SOVEREIGN_FLOOR;
      var retrievalEfficiency = SOVEREIGN_FLOOR;
      var tickCount = 0;
      var lastTickTime = now;
    }
  };
  
  func initSystemsConsolidation() : SystemsConsolidation {
    {
      var hippocampal = {
        var capacity = 1000;
        var currentLoad = 0;
        var activeTraces = Buffer.Buffer<Nat>(1000);
        var replayQueue = Buffer.Buffer<Nat>(256);
        var bindingStrength = 0.8;
        var patternSeparation = 0.7;
        var patternCompletion = 0.6;
        var indexingEfficiency = 0.75;
      };
      var neocortical = {
        var schemas = Buffer.Buffer<Schema>(128);
        var consolidatedTraces = Buffer.Buffer<Nat>(10000);
        var integrationLevel = 0.5;
        var abstractionCapacity = 0.6;
        var interleaving = 0.5;
      };
      var transferRate = 0.01;
      var currentPhase = #Encoding;
      var sleepCycles = 0;
    }
  };
  
  func initSleepState() : SleepState {
    {
      var isAsleep = false;
      var currentStage = #Awake;
      var stageTime = 0;
      var cycleNumber = 0;
      var totalSleepTime = 0;
      var sleepPressure = 0.5;
      var circadianPhase = 0.0;
    }
  };
  
  func initForgettingCurve() : ForgettingCurve {
    {
      decayRate = DECAY_B;
      retrievalPracticeBoost = 0.3;
      spacingEffect = 0.4;
      interferenceCoeff = 0.2;
      consolidationBonus = 0.5;
    }
  };
  
  func initInterferenceState() : InterferenceState {
    {
      var retroactiveInterference = 0.0;
      var proactiveInterference = 0.0;
      var outputInterference = 0.0;
      var fanEffect = 0.0;
      var distinctiveness = 0.5;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY ENCODING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Encode a new memory trace
  public func encodeMemory(
    state : MemoryConsolidationState,
    content : [Float],
    category : MemoryCategory,
    encoding : EncodingType,
    emotionalTag : Float
  ) : Nat {
    let now = Time.now();
    let traceId = state.traces.size();
    
    // Compute initial strength based on encoding type
    let initialStrength = computeEncodingStrength(encoding, emotionalTag);
    
    // Create synaptic tag
    let tag : SynapticTag = {
      isSet = true;
      tagStrength = initialStrength;
      proteinSynthesis = 0.8;
      tagDecay = 0.01;
      captureWindow = 6 * 3600_000_000_000; // 6 hours in ns
    };
    
    let trace : MemoryTrace = {
      traceId = traceId;
      content = content;
      category = category;
      encoding = encoding;
      strength = initialStrength;
      initialStrength = initialStrength;
      consolidationLevel = 0.0;      // Starts fully hippocampal
      encodingTime = now;
      lastRetrievalTime = now;
      retrievalCount = 0;
      emotionalTag = emotionalTag;
      synapticTag = tag;
      contextTags = [];
      interferenceLevel = 0.0;
      competingTraces = [];
      isActive = true;
      needsReconsolidation = false;
      isProtected = emotionalTag > 0.8;
    };
    
    state.traces.add(trace);
    
    // Add to hippocampal system
    state.systemsConsolidation.hippocampal.activeTraces.add(traceId);
    state.systemsConsolidation.hippocampal.currentLoad += 1;
    state.systemsConsolidation.hippocampal.replayQueue.add(traceId);
    
    traceId
  };
  
  func computeEncodingStrength(encoding : EncodingType, emotionalTag : Float) : Float {
    let baseStrength = switch (encoding) {
      case (#Deep) { 0.9 };
      case (#Shallow) { 0.4 };
      case (#Incidental) { 0.3 };
      case (#Intentional) { 0.7 };
      case (#Elaborative) { 0.95 };
    };
    
    // Emotional enhancement
    let emotionalBoost = emotionalTag * 0.3;
    
    Float.min(1.0, baseStrength + emotionalBoost)
  };
  
  /// Add context tags to memory
  public func addContextTags(state : MemoryConsolidationState, traceId : Nat, tags : [Text]) : Bool {
    if (traceId >= state.traces.size()) return false;
    
    let trace = state.traces.get(traceId);
    let newTags = Buffer.Buffer<Text>(trace.contextTags.size() + tags.size());
    
    for (t in trace.contextTags.vals()) { newTags.add(t) };
    for (t in tags.vals()) { newTags.add(t) };
    
    state.traces.put(traceId, {
      trace with
      contextTags = Buffer.toArray(newTags);
    });
    
    true
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY RETRIEVAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Retrieve memory by index
  public func retrieveMemory(state : MemoryConsolidationState, traceId : Nat) : ?MemoryTrace {
    if (traceId >= state.traces.size()) return null;
    
    let trace = state.traces.get(traceId);
    let now = Time.now();
    
    // Apply retrieval-induced forgetting to competing traces
    for (competingId in trace.competingTraces.vals()) {
      if (competingId < state.traces.size()) {
        let competing = state.traces.get(competingId);
        let weakenedStrength = competing.strength * (1.0 - state.interferenceState.outputInterference * 0.1);
        state.traces.put(competingId, {
          competing with
          strength = Float.max(0.0, weakenedStrength);
        });
      };
    };
    
    // Strengthen retrieved trace (testing effect)
    let strengthBoost = state.forgettingCurve.retrievalPracticeBoost * (1.0 - trace.strength);
    let newStrength = Float.min(1.0, trace.strength + strengthBoost);
    
    // Check if reconsolidation window should open
    let shouldReconsolidate = trace.consolidationLevel > 0.5 and 
                              now - trace.lastRetrievalTime > 24 * 3600_000_000_000;
    
    // Update trace
    state.traces.put(traceId, {
      trace with
      strength = newStrength;
      lastRetrievalTime = now;
      retrievalCount = trace.retrievalCount + 1;
      needsReconsolidation = shouldReconsolidate;
    });
    
    // Open reconsolidation window if needed
    if (shouldReconsolidate) {
      openReconsolidationWindow(state, traceId);
    };
    
    ?state.traces.get(traceId)
  };
  
  /// Pattern completion retrieval (partial cue)
  public func patternCompletion(state : MemoryConsolidationState, partialCue : [Float]) : [Nat] {
    let hip = state.systemsConsolidation.hippocampal;
    let matches = Buffer.Buffer<(Float, Nat)>(32);
    
    for (traceId in hip.activeTraces.vals()) {
      if (traceId < state.traces.size()) {
        let trace = state.traces.get(traceId);
        let similarity = computeCosineSimilarity(partialCue, trace.content);
        
        // Apply pattern completion threshold
        if (similarity > 0.3) {
          let completionStrength = similarity * hip.patternCompletion * trace.strength;
          matches.add((completionStrength, traceId));
        };
      };
    };
    
    // Sort and return top matches
    let sorted = Buffer.toArray(matches);
    Array.tabulate<Nat>(Nat.min(10, sorted.size()), func(i) {
      sorted[i].1
    })
  };
  
  func computeCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    var dot : Float = 0.0;
    var n1 : Float = 0.0;
    var n2 : Float = 0.0;
    
    let n = Nat.min(v1.size(), v2.size());
    for (i in Iter.range(0, n - 1)) {
      dot += v1[i] * v2[i];
      n1 += v1[i] * v1[i];
      n2 += v2[i] * v2[i];
    };
    
    let denom = Float.sqrt(n1) * Float.sqrt(n2);
    if (denom < 0.0001) { 0.0 } else { dot / denom }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FORGETTING DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply forgetting curve to all traces
  public func applyForgetting(state : MemoryConsolidationState, dt : Int) : Nat {
    let now = Time.now();
    let fc = state.forgettingCurve;
    var forgottenCount : Nat = 0;
    
    for (i in Iter.range(0, state.traces.size() - 1)) {
      let trace = state.traces.get(i);
      
      if (trace.isActive and not trace.isProtected) {
        // Time since encoding or last retrieval (whichever is more recent)
        let timeSinceAccess = Float.fromInt(now - trace.lastRetrievalTime);
        let hours = timeSinceAccess / Float.fromInt(3600_000_000_000);
        
        // Ebbinghaus forgetting curve: R = e^(-t/S)
        // S (stability) increases with consolidation and retrieval
        let stability = 1.0 + trace.consolidationLevel * fc.consolidationBonus +
                       Float.fromInt(trace.retrievalCount) * fc.retrievalPracticeBoost;
        
        let retention = Float.exp(-hours / (stability * 24.0));
        
        // Apply interference
        let interferenceReduction = trace.interferenceLevel * fc.interferenceCoeff;
        let finalStrength = trace.initialStrength * retention * (1.0 - interferenceReduction);
        
        // Check for forgetting
        let forgotten = finalStrength < 0.1;
        
        state.traces.put(i, {
          trace with
          strength = Float.max(0.0, finalStrength);
          isActive = not forgotten;
        });
        
        if (forgotten) {
          forgottenCount += 1;
        };
      };
    };
    
    forgottenCount
  };
  
  /// Update interference between traces
  public func updateInterference(state : MemoryConsolidationState, newTraceId : Nat) {
    if (newTraceId >= state.traces.size()) return;
    
    let newTrace = state.traces.get(newTraceId);
    let interference = state.interferenceState;
    
    // Find similar traces (potential interference)
    for (i in Iter.range(0, state.traces.size() - 1)) {
      if (i != newTraceId) {
        let existingTrace = state.traces.get(i);
        
        if (existingTrace.isActive) {
          let similarity = computeCosineSimilarity(newTrace.content, existingTrace.content);
          
          if (similarity > 0.5) {
            // Retroactive interference: new → old
            let riStrength = similarity * (1.0 - existingTrace.consolidationLevel);
            let newExistingInterference = existingTrace.interferenceLevel + riStrength * 0.1;
            
            state.traces.put(i, {
              existingTrace with
              interferenceLevel = Float.min(1.0, newExistingInterference);
              competingTraces = Array.append(existingTrace.competingTraces, [newTraceId]);
            });
            
            // Proactive interference: old → new
            let piStrength = similarity * existingTrace.strength;
            let newNewInterference = newTrace.interferenceLevel + piStrength * 0.05;
            
            state.traces.put(newTraceId, {
              state.traces.get(newTraceId) with
              interferenceLevel = Float.min(1.0, newNewInterference);
              competingTraces = Array.append(newTrace.competingTraces, [i]);
            });
          };
        };
      };
    };
    
    // Update global interference state
    var totalRI : Float = 0.0;
    var totalPI : Float = 0.0;
    var count : Nat = 0;
    
    for (trace in state.traces.vals()) {
      if (trace.isActive) {
        totalRI += trace.interferenceLevel;
        count += 1;
      };
    };
    
    if (count > 0) {
      interference.retroactiveInterference := totalRI / Float.fromInt(count);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SLEEP PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Begin sleep cycle
  public func beginSleep(state : MemoryConsolidationState) {
    let sleep = state.sleepState;
    
    sleep.isAsleep := true;
    sleep.currentStage := #NREM1;
    sleep.stageTime := 0;
    sleep.cycleNumber := 0;
    
    state.systemsConsolidation.currentPhase := #SleepDependent;
  };
  
  /// Process one sleep tick
  public func processSleepTick(state : MemoryConsolidationState, dt : Int) : SleepProcessingResult {
    let sleep = state.sleepState;
    
    if (not sleep.isAsleep) {
      return { stage = #Awake; ripples = 0; spindles = 0; consolidatedTraces = 0 };
    };
    
    sleep.stageTime += dt;
    sleep.totalSleepTime += dt;
    
    // Check for stage transition
    let stageDuration = getStageDuration(sleep.currentStage);
    if (sleep.stageTime > stageDuration) {
      transitionSleepStage(state);
    };
    
    // Process based on current stage
    var rippleCount : Nat = 0;
    var spindleCount : Nat = 0;
    var consolidatedCount : Nat = 0;
    
    switch (sleep.currentStage) {
      case (#NREM2) {
        // Sleep spindles for memory consolidation
        let spindle = generateSleepSpindle(state);
        state.sleepSpindles.add(spindle);
        spindleCount := 1;
      };
      case (#NREM3) {
        // Slow-wave sleep: slow oscillations + nested ripples
        let so = generateSlowOscillation(state);
        state.slowOscillations.add(so);
        
        // Generate sharp-wave ripples during up-state
        let replayCount = replayMemories(state, 5);
        rippleCount := replayCount;
        consolidatedCount := consolidateDuringSWS(state);
      };
      case (#REM) {
        // REM: memory integration and schema formation
        consolidatedCount := integrateSchemas(state);
      };
      case (_) {};
    };
    
    {
      stage = sleep.currentStage;
      ripples = rippleCount;
      spindles = spindleCount;
      consolidatedTraces = consolidatedCount;
    }
  };
  
  func getStageDuration(stage : SleepStage) : Int {
    let baseCycleDuration : Int = 90 * 60 * 1_000_000_000; // 90 min in ns
    
    switch (stage) {
      case (#Awake) { 0 };
      case (#NREM1) { Int.abs(Float.toInt(Float.fromInt(baseCycleDuration) * NREM1_FRACTION)) };
      case (#NREM2) { Int.abs(Float.toInt(Float.fromInt(baseCycleDuration) * NREM2_FRACTION)) };
      case (#NREM3) { Int.abs(Float.toInt(Float.fromInt(baseCycleDuration) * NREM3_FRACTION)) };
      case (#REM) { Int.abs(Float.toInt(Float.fromInt(baseCycleDuration) * REM_FRACTION)) };
    }
  };
  
  func transitionSleepStage(state : MemoryConsolidationState) {
    let sleep = state.sleepState;
    sleep.stageTime := 0;
    
    switch (sleep.currentStage) {
      case (#NREM1) { sleep.currentStage := #NREM2 };
      case (#NREM2) { sleep.currentStage := #NREM3 };
      case (#NREM3) { sleep.currentStage := #REM };
      case (#REM) {
        sleep.cycleNumber += 1;
        sleep.currentStage := #NREM2; // Skip NREM1 in later cycles
      };
      case (#Awake) { sleep.currentStage := #NREM1 };
    };
  };
  
  func generateSleepSpindle(state : MemoryConsolidationState) : SleepSpindle {
    let id = state.sleepSpindles.size();
    
    {
      spindleId = id;
      timestamp = Time.now();
      duration = 500_000_000; // 500ms
      frequency = 12.0 + Float.sin(Float.fromInt(id)) * 2.0;
      amplitude = 0.8;
      coupledRipples = [];
      thalamicOrigin = true;
    }
  };
  
  func generateSlowOscillation(state : MemoryConsolidationState) : SlowOscillation {
    let id = state.slowOscillations.size();
    
    {
      oscillationId = id;
      timestamp = Time.now();
      upStateStart = Time.now();
      upStateDuration = 500_000_000;
      downStateDuration = 500_000_000;
      amplitude = 1.0;
      frequency = 0.8;
      nestedSpindles = [];
      nestedRipples = [];
    }
  };
  
  /// Replay memories via sharp-wave ripples
  func replayMemories(state : MemoryConsolidationState, count : Nat) : Nat {
    let hip = state.systemsConsolidation.hippocampal;
    var replayed : Nat = 0;
    
    for (_ in Iter.range(0, count - 1)) {
      if (hip.replayQueue.size() > 0) {
        let traceId = hip.replayQueue.get(0);
        ignore hip.replayQueue.remove(0);
        
        if (traceId < state.traces.size()) {
          let trace = state.traces.get(traceId);
          
          // Create ripple
          let ripple : SharpWaveRipple = {
            rippleId = state.sharpWaveRipples.size();
            timestamp = Time.now();
            duration = 100_000_000; // 100ms
            amplitude = trace.strength;
            frequency = 180.0; // ~180 Hz
            replayedTraces = [traceId];
            compressionRatio = 20.0; // 20x compression
            isForward = replayed % 2 == 0;
          };
          
          state.sharpWaveRipples.add(ripple);
          
          // Strengthen trace from replay
          let replayBoost = 0.05 * (1.0 - trace.consolidationLevel);
          state.traces.put(traceId, {
            trace with
            strength = Float.min(1.0, trace.strength + replayBoost);
          });
          
          replayed += 1;
        };
      };
    };
    
    replayed
  };
  
  func consolidateDuringSWS(state : MemoryConsolidationState) : Nat {
    let sys = state.systemsConsolidation;
    var consolidated : Nat = 0;
    
    // Transfer traces from hippocampus to neocortex
    for (i in Iter.range(0, state.traces.size() - 1)) {
      let trace = state.traces.get(i);
      
      if (trace.isActive and trace.consolidationLevel < 1.0 and trace.strength > 0.3) {
        // Increase consolidation level
        let consolidationRate = sys.transferRate * trace.strength;
        let newConsolidation = Float.min(1.0, trace.consolidationLevel + consolidationRate);
        
        state.traces.put(i, {
          trace with
          consolidationLevel = newConsolidation;
        });
        
        // Move to neocortical if sufficiently consolidated
        if (newConsolidation > 0.8 and trace.consolidationLevel <= 0.8) {
          sys.neocortical.consolidatedTraces.add(i);
          consolidated += 1;
        };
      };
    };
    
    consolidated
  };
  
  func integrateSchemas(state : MemoryConsolidationState) : Nat {
    let neo = state.systemsConsolidation.neocortical;
    var integrated : Nat = 0;
    
    // Find similar consolidated traces to form schemas
    for (traceId in neo.consolidatedTraces.vals()) {
      if (traceId < state.traces.size()) {
        let trace = state.traces.get(traceId);
        
        // Try to add to existing schema or create new one
        var addedToSchema = false;
        
        for (j in Iter.range(0, neo.schemas.size() - 1)) {
          let schema = neo.schemas.get(j);
          let similarity = computeCosineSimilarity(trace.content, schema.prototype);
          
          if (similarity > 0.6) {
            // Add to schema
            let newInstances = Array.append(schema.instances, [traceId]);
            
            // Update prototype (moving average)
            let newPrototype = Array.tabulate<Float>(trace.content.size(), func(k) {
              if (k < schema.prototype.size()) {
                schema.prototype[k] * 0.9 + trace.content[k] * 0.1
              } else { trace.content[k] }
            });
            
            neo.schemas.put(j, {
              schema with
              prototype = newPrototype;
              instances = newInstances;
              lastUpdateTime = Time.now();
            });
            
            addedToSchema := true;
            integrated += 1;
          };
        };
        
        // Create new schema if no match
        if (not addedToSchema and neo.schemas.size() < 128) {
          let newSchema : Schema = {
            schemaId = neo.schemas.size();
            name = "Schema_" # Int.toText(neo.schemas.size());
            prototype = trace.content;
            instances = [traceId];
            flexibility = 0.5;
            consistency = 1.0;
            lastUpdateTime = Time.now();
          };
          
          neo.schemas.add(newSchema);
          integrated += 1;
        };
      };
    };
    
    integrated
  };
  
  /// End sleep and wake up
  public func endSleep(state : MemoryConsolidationState) {
    let sleep = state.sleepState;
    
    sleep.isAsleep := false;
    sleep.currentStage := #Awake;
    state.systemsConsolidation.sleepCycles += sleep.cycleNumber;
    sleep.sleepPressure := 0.1;
    
    state.systemsConsolidation.currentPhase := #LateConsolidation;
  };
  
  public type SleepProcessingResult = {
    stage : SleepStage;
    ripples : Nat;
    spindles : Nat;
    consolidatedTraces : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RECONSOLIDATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Open reconsolidation window for trace
  func openReconsolidationWindow(state : MemoryConsolidationState, traceId : Nat) {
    let now = Time.now();
    
    let window : ReconsolidationWindow = {
      isOpen = true;
      openTime = now;
      windowDuration = 6 * 3600_000_000_000; // 6 hours
      targetTrace = traceId;
      vulnerability = 0.8;
    };
    
    state.activeWindows.add(window);
  };
  
  /// Update memory during reconsolidation window
  public func updateMemory(state : MemoryConsolidationState, traceId : Nat, newContent : [Float]) : Bool {
    // Check for open window
    var windowFound = false;
    var windowIdx : Nat = 0;
    
    for (i in Iter.range(0, state.activeWindows.size() - 1)) {
      let window = state.activeWindows.get(i);
      if (window.targetTrace == traceId and window.isOpen) {
        windowFound := true;
        windowIdx := i;
      };
    };
    
    if (not windowFound) return false;
    
    let window = state.activeWindows.get(windowIdx);
    let trace = state.traces.get(traceId);
    let now = Time.now();
    
    // Check if window is still open
    if (now > window.openTime + window.windowDuration) {
      state.activeWindows.put(windowIdx, { window with isOpen = false });
      return false;
    };
    
    // Blend old and new content based on vulnerability
    let blendedContent = Array.tabulate<Float>(trace.content.size(), func(i) {
      if (i < newContent.size()) {
        trace.content[i] * (1.0 - window.vulnerability) + newContent[i] * window.vulnerability
      } else {
        trace.content[i]
      }
    });
    
    // Update trace
    state.traces.put(traceId, {
      trace with
      content = blendedContent;
      needsReconsolidation = false;
      consolidationLevel = trace.consolidationLevel * 0.9; // Temporarily destabilized
    });
    
    // Record event
    let event : ReconsolidationEvent = {
      eventId = state.reconsolidationEvents.size();
      traceId = traceId;
      triggerTime = window.openTime;
      destabilizationStrength = window.vulnerability;
      updateContent = newContent;
      restabilizationTime = now;
      wasSuccessful = true;
    };
    
    state.reconsolidationEvents.add(event);
    
    // Close window
    state.activeWindows.put(windowIdx, { window with isOpen = false });
    
    true
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MASTER TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one consolidation tick
  public func runConsolidationTick(state : MemoryConsolidationState, dt : Int) : ConsolidationTickResult {
    let now = Time.now();
    
    // 1. Apply forgetting
    let forgottenCount = applyForgetting(state, dt);
    
    // 2. Process sleep if asleep
    var sleepResult : SleepProcessingResult = { stage = #Awake; ripples = 0; spindles = 0; consolidatedTraces = 0 };
    if (state.sleepState.isAsleep) {
      sleepResult := processSleepTick(state, dt);
    };
    
    // 3. Awake consolidation (slower than sleep)
    var awakeConsolidated : Nat = 0;
    if (not state.sleepState.isAsleep) {
      awakeConsolidated := awakeConsolidation(state, dt);
    };
    
    // 4. Close expired reconsolidation windows
    closeExpiredWindows(state, now);
    
    // 5. Update integration metrics
    updateConsolidationMetrics(state);
    
    state.tickCount += 1;
    state.lastTickTime := now;
    
    {
      forgottenTraces = forgottenCount;
      sleepProcessing = sleepResult;
      awakeConsolidated = awakeConsolidated;
      overallConsolidation = state.overallConsolidation;
      memoryStability = state.memoryStability;
      retrievalEfficiency = state.retrievalEfficiency;
      activeTraces = countActiveTraces(state);
      schemaCount = state.systemsConsolidation.neocortical.schemas.size();
      tickDuration = Time.now() - now;
    }
  };
  
  func awakeConsolidation(state : MemoryConsolidationState, dt : Int) : Nat {
    let sys = state.systemsConsolidation;
    var consolidated : Nat = 0;
    
    // Slower consolidation while awake
    let awakeRate = sys.transferRate * 0.1;
    
    for (i in Iter.range(0, state.traces.size() - 1)) {
      let trace = state.traces.get(i);
      
      if (trace.isActive and trace.consolidationLevel < 0.5 and trace.strength > 0.5) {
        let newConsolidation = Float.min(0.5, trace.consolidationLevel + awakeRate);
        
        state.traces.put(i, {
          trace with
          consolidationLevel = newConsolidation;
        });
        
        consolidated += 1;
      };
    };
    
    consolidated
  };
  
  func closeExpiredWindows(state : MemoryConsolidationState, now : Int) {
    for (i in Iter.range(0, state.activeWindows.size() - 1)) {
      let window = state.activeWindows.get(i);
      if (window.isOpen and now > window.openTime + window.windowDuration) {
        state.activeWindows.put(i, { window with isOpen = false });
      };
    };
  };
  
  func updateConsolidationMetrics(state : MemoryConsolidationState) {
    var totalConsolidation : Float = 0.0;
    var totalStrength : Float = 0.0;
    var activeCount : Nat = 0;
    
    for (trace in state.traces.vals()) {
      if (trace.isActive) {
        totalConsolidation += trace.consolidationLevel;
        totalStrength += trace.strength;
        activeCount += 1;
      };
    };
    
    if (activeCount > 0) {
      state.overallConsolidation := totalConsolidation / Float.fromInt(activeCount);
      state.memoryStability := totalStrength / Float.fromInt(activeCount);
    };
    
    // Retrieval efficiency based on pattern completion
    let hip = state.systemsConsolidation.hippocampal;
    state.retrievalEfficiency := hip.patternCompletion * hip.indexingEfficiency;
    
    // Apply sovereign floor
    state.overallConsolidation := Float.max(SOVEREIGN_FLOOR, state.overallConsolidation);
    state.memoryStability := Float.max(SOVEREIGN_FLOOR, state.memoryStability);
    state.retrievalEfficiency := Float.max(SOVEREIGN_FLOOR, state.retrievalEfficiency);
  };
  
  func countActiveTraces(state : MemoryConsolidationState) : Nat {
    var count : Nat = 0;
    for (trace in state.traces.vals()) {
      if (trace.isActive) { count += 1 };
    };
    count
  };
  
  public type ConsolidationTickResult = {
    forgottenTraces : Nat;
    sleepProcessing : SleepProcessingResult;
    awakeConsolidated : Nat;
    overallConsolidation : Float;
    memoryStability : Float;
    retrievalEfficiency : Float;
    activeTraces : Nat;
    schemaCount : Nat;
    tickDuration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get consolidation status
  public func getConsolidationStatus(state : MemoryConsolidationState) : ConsolidationStatus {
    {
      tickCount = state.tickCount;
      totalTraces = state.traces.size();
      activeTraces = countActiveTraces(state);
      overallConsolidation = state.overallConsolidation;
      memoryStability = state.memoryStability;
      retrievalEfficiency = state.retrievalEfficiency;
      hippocampalLoad = state.systemsConsolidation.hippocampal.currentLoad;
      neocorticalTraces = state.systemsConsolidation.neocortical.consolidatedTraces.size();
      schemaCount = state.systemsConsolidation.neocortical.schemas.size();
      isAsleep = state.sleepState.isAsleep;
      sleepStage = stageToText(state.sleepState.currentStage);
      sleepCycles = state.sleepState.cycleNumber;
      rippleCount = state.sharpWaveRipples.size();
      spindleCount = state.sleepSpindles.size();
      reconsolidationEvents = state.reconsolidationEvents.size();
    }
  };
  
  public type ConsolidationStatus = {
    tickCount : Nat;
    totalTraces : Nat;
    activeTraces : Nat;
    overallConsolidation : Float;
    memoryStability : Float;
    retrievalEfficiency : Float;
    hippocampalLoad : Nat;
    neocorticalTraces : Nat;
    schemaCount : Nat;
    isAsleep : Bool;
    sleepStage : Text;
    sleepCycles : Nat;
    rippleCount : Nat;
    spindleCount : Nat;
    reconsolidationEvents : Nat;
  };
  
  func stageToText(stage : SleepStage) : Text {
    switch (stage) {
      case (#Awake) { "Awake" };
      case (#NREM1) { "NREM1" };
      case (#NREM2) { "NREM2" };
      case (#NREM3) { "NREM3" };
      case (#REM) { "REM" };
    }
  };
  
  /// Get memory trace info
  public func getTraceInfo(state : MemoryConsolidationState, traceId : Nat) : ?TraceInfo {
    if (traceId >= state.traces.size()) return null;
    
    let trace = state.traces.get(traceId);
    
    ?{
      traceId = trace.traceId;
      category = categoryToText(trace.category);
      strength = trace.strength;
      consolidationLevel = trace.consolidationLevel;
      retrievalCount = trace.retrievalCount;
      emotionalTag = trace.emotionalTag;
      interferenceLevel = trace.interferenceLevel;
      isActive = trace.isActive;
      isProtected = trace.isProtected;
      needsReconsolidation = trace.needsReconsolidation;
    }
  };
  
  public type TraceInfo = {
    traceId : Nat;
    category : Text;
    strength : Float;
    consolidationLevel : Float;
    retrievalCount : Nat;
    emotionalTag : Float;
    interferenceLevel : Float;
    isActive : Bool;
    isProtected : Bool;
    needsReconsolidation : Bool;
  };
  
  func categoryToText(cat : MemoryCategory) : Text {
    switch (cat) {
      case (#Episodic) { "Episodic" };
      case (#Semantic) { "Semantic" };
      case (#Procedural) { "Procedural" };
      case (#Working) { "Working" };
      case (#Prospective) { "Prospective" };
      case (#Emotional) { "Emotional" };
    }
  };
  
  /// Get schema list
  public func getSchemas(state : MemoryConsolidationState) : [SchemaInfo] {
    let neo = state.systemsConsolidation.neocortical;
    
    Array.tabulate<SchemaInfo>(neo.schemas.size(), func(i) {
      let schema = neo.schemas.get(i);
      {
        schemaId = schema.schemaId;
        name = schema.name;
        instanceCount = schema.instances.size();
        flexibility = schema.flexibility;
        consistency = schema.consistency;
      }
    })
  };
  
  public type SchemaInfo = {
    schemaId : Nat;
    name : Text;
    instanceCount : Nat;
    flexibility : Float;
    consistency : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED MEMORY CONSOLIDATION - SEMANTIC MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Semantic memory state
  public type SemanticMemoryState = {
    var concepts : Buffer.Buffer<SemanticConcept>;
    var relations : Buffer.Buffer<SemanticRelation>;
    var categories : Buffer.Buffer<SemanticCategory>;
    var propositions : Buffer.Buffer<Proposition>;
    var semanticNetwork : SemanticNetwork;
    var typicalityGradients : [[Float]];
    var featureNorms : [[Float]];
  };
  
  public type SemanticConcept = {
    conceptId : Nat;
    label : Text;
    features : [ConceptFeature];
    typicality : Float;
    familiarity : Float;
    acquisitionAge : Int;
    frequency : Float;
    concreteness : Float;
    imageability : Float;
  };
  
  public type ConceptFeature = {
    featureId : Nat;
    featureType : FeatureType;
    value : Float;
    salience : Float;
    distinctiveness : Float;
    correlation : Float;
  };
  
  public type FeatureType = {
    #Perceptual;
    #Functional;
    #Encyclopedic;
    #Taxonomic;
    #Thematic;
    #Evaluative;
  };
  
  public type SemanticRelation = {
    relationId : Nat;
    sourceId : Nat;
    targetId : Nat;
    relationType : RelationType;
    strength : Float;
    bidirectional : Bool;
    context : [Float];
  };
  
  public type RelationType = {
    #IsA;
    #HasA;
    #PartOf;
    #UsedFor;
    #LocatedAt;
    #Causes;
    #SimilarTo;
    #OppositeTo;
    #Associates;
    #Entails;
  };
  
  public type SemanticCategory = {
    categoryId : Nat;
    label : Text;
    prototype : [Float];
    members : [Nat];
    supercategory : ?Nat;
    subcategories : [Nat];
    cohesion : Float;
    distinctiveness : Float;
    fuzzyBoundary : Float;
  };
  
  public type Proposition = {
    propositionId : Nat;
    predicate : Text;
    arguments : [Nat];
    truthValue : ?Float;
    certainty : Float;
    source : PropositionSource;
    linkedPropositions : [Nat];
  };
  
  public type PropositionSource = {
    #DirectExperience;
    #Inference;
    #Testimony;
    #Education;
    #Media;
    #Reasoning;
  };
  
  public type SemanticNetwork = {
    var nodes : [[Float]];
    var edges : [[Float]];
    var spreadingActivation : [Float];
    var activationDecay : Float;
    var activationThreshold : Float;
    var fanEffect : Float;
  };
  
  /// Initialize semantic memory state
  public func initSemanticMemoryState(maxConcepts : Nat) : SemanticMemoryState {
    {
      var concepts = Buffer.Buffer<SemanticConcept>(maxConcepts);
      var relations = Buffer.Buffer<SemanticRelation>(maxConcepts * 4);
      var categories = Buffer.Buffer<SemanticCategory>(maxConcepts / 4);
      var propositions = Buffer.Buffer<Proposition>(maxConcepts * 2);
      var semanticNetwork = {
        var nodes = [];
        var edges = [];
        var spreadingActivation = [];
        var activationDecay = 0.2;
        var activationThreshold = 0.1;
        var fanEffect = 0.5;
      };
      var typicalityGradients = [];
      var featureNorms = [];
    }
  };
  
  /// Spread activation in semantic network
  public func spreadSemanticActivation(semMem : SemanticMemoryState, sourceConcepts : [Nat], strength : Float) {
    // Initialize activation for source concepts
    let numNodes = semMem.semanticNetwork.nodes.size();
    var newActivation = Array.tabulate<Float>(numNodes, func(i) {
      var isSource = false;
      label findSource for (src in sourceConcepts.vals()) {
        if (src == i) {
          isSource := true;
          break findSource;
        };
      };
      if (isSource) { strength } else { 0.0 }
    });
    
    // Spread activation through network
    let iterations = 3;
    for (_ in Iter.range(0, iterations - 1)) {
      var spreadActivation = Array.tabulate<Float>(numNodes, func(i) { 0.0 });
      
      for (i in Iter.range(0, numNodes - 1)) {
        if (newActivation[i] > semMem.semanticNetwork.activationThreshold) {
          // Spread to connected nodes
          let edges = semMem.semanticNetwork.edges;
          if (i < edges.size()) {
            for (j in Iter.range(0, edges[i].size() - 1)) {
              let connectionStrength = edges[i][j];
              if (connectionStrength > 0.0) {
                let spreadAmount = newActivation[i] * connectionStrength * (1.0 - semMem.semanticNetwork.fanEffect);
                spreadActivation[j] := spreadActivation[j] + spreadAmount;
              };
            };
          };
        };
      };
      
      // Apply decay and combine with spread
      newActivation := Array.tabulate<Float>(numNodes, func(i) {
        let current = newActivation[i] * (1.0 - semMem.semanticNetwork.activationDecay);
        current + spreadActivation[i]
      });
    };
    
    semMem.semanticNetwork.spreadingActivation := newActivation;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // AUTOBIOGRAPHICAL MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AutobiographicalMemoryState = {
    var lifePeriods : Buffer.Buffer<LifePeriod>;
    var generalEvents : Buffer.Buffer<GeneralEvent>;
    var eventSpecificKnowledge : Buffer.Buffer<EventSpecificKnowledge>;
    var selfSchema : SelfSchema;
    var lifeNarrative : LifeNarrative;
    var temporalDistribution : TemporalDistribution;
  };
  
  public type LifePeriod = {
    periodId : Nat;
    label : Text;
    startTime : Int;
    endTime : ?Int;
    themes : [Text];
    emotionalValence : Float;
    significance : Float;
    generalEvents : [Nat];
  };
  
  public type GeneralEvent = {
    eventId : Nat;
    label : Text;
    timeRange : (Int, Int);
    location : Text;
    participants : [Text];
    emotionalIntensity : Float;
    personalSignificance : Float;
    specificKnowledge : [Nat];
    schemaRelevance : Float;
  };
  
  public type EventSpecificKnowledge = {
    knowledgeId : Nat;
    sensoryDetails : [Float];
    actions : [Text];
    thoughts : [Text];
    emotions : [Float];
    vividness : Float;
    recollection : Float;
    confidence : Float;
    rehearsalCount : Nat;
    lastAccess : Int;
  };
  
  public type SelfSchema = {
    var coreBeliefs : [[Float]];
    var selfConcept : [Float];
    var workingSelf : [Float];
    var possibleSelves : [[Float]];
    var selfDiscrepancies : [Float];
    var selfConsistency : Float;
  };
  
  public type LifeNarrative = {
    var narrativeIdentity : [Float];
    var themes : [Text];
    var coherence : Float;
    var redemption Sequences : [[Nat]];
    var contaminationSequences : [[Nat]];
    var turningPoints : [Nat];
  };
  
  public type TemporalDistribution = {
    var reminiscenceBump : (Int, Int);
    var recencyEffect : Float;
    var childhoodAmnesia : Int;
    var forgettingCurve : [Float];
    var temporalGradient : [Float];
  };
  
  /// Initialize autobiographical memory state
  public func initAutobiographicalMemoryState() : AutobiographicalMemoryState {
    {
      var lifePeriods = Buffer.Buffer<LifePeriod>(32);
      var generalEvents = Buffer.Buffer<GeneralEvent>(256);
      var eventSpecificKnowledge = Buffer.Buffer<EventSpecificKnowledge>(1024);
      var selfSchema = {
        var coreBeliefs = [];
        var selfConcept = Array.tabulate<Float>(64, func(i) { 0.5 });
        var workingSelf = Array.tabulate<Float>(32, func(i) { 0.5 });
        var possibleSelves = [];
        var selfDiscrepancies = [];
        var selfConsistency = 0.7;
      };
      var lifeNarrative = {
        var narrativeIdentity = Array.tabulate<Float>(32, func(i) { 0.5 });
        var themes = [];
        var coherence = 0.6;
        var redemptionSequences = [];
        var contaminationSequences = [];
        var turningPoints = [];
      };
      var temporalDistribution = {
        var reminiscenceBump = (15 * 365 * 24 * 3600 * 1_000_000_000, 25 * 365 * 24 * 3600 * 1_000_000_000);
        var recencyEffect = 0.7;
        var childhoodAmnesia = 3 * 365 * 24 * 3600 * 1_000_000_000;
        var forgettingCurve = Array.tabulate<Float>(10, func(i) { Float.exp(-Float.fromInt(i) * 0.3) });
        var temporalGradient = [];
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PROSPECTIVE MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ProspectiveMemoryState = {
    var eventBasedIntentions : Buffer.Buffer<EventBasedIntention>;
    var timeBasedIntentions : Buffer.Buffer<TimeBasedIntention>;
    var monitoringProcess : MonitoringProcess;
    var intentionRetention : IntentionRetention;
    var executionWindow : ExecutionWindow;
  };
  
  public type EventBasedIntention = {
    intentionId : Nat;
    cue : [Float];
    action : Text;
    importance : Float;
    creationTime : Int;
    focalness : Float;
    cueSalience : Float;
    completed : Bool;
  };
  
  public type TimeBasedIntention = {
    intentionId : Nat;
    targetTime : Int;
    action : Text;
    importance : Float;
    creationTime : Int;
    timeWindow : Int;
    clockChecking : Float;
    completed : Bool;
  };
  
  public type MonitoringProcess = {
    var monitoringIntensity : Float;
    var attentionalAllocation : Float;
    var cueDetectionThreshold : Float;
    var monitoringCost : Float;
    var spontaneousRetrieval : Float;
    var strategicMonitoring : Float;
  };
  
  public type IntentionRetention = {
    var intentionActivation : [Float];
    var forgettingRate : Float;
    var interferenceSusceptibility : Float;
    var reminderEffectiveness : Float;
    var retentionInterval : Int;
  };
  
  public type ExecutionWindow = {
    var windowStart : Int;
    var windowEnd : Int;
    var flexibility : Float;
    var executionReadiness : Float;
    var taskSwitchingCost : Float;
  };
  
  /// Initialize prospective memory state
  public func initProspectiveMemoryState() : ProspectiveMemoryState {
    {
      var eventBasedIntentions = Buffer.Buffer<EventBasedIntention>(32);
      var timeBasedIntentions = Buffer.Buffer<TimeBasedIntention>(32);
      var monitoringProcess = {
        var monitoringIntensity = 0.5;
        var attentionalAllocation = 0.3;
        var cueDetectionThreshold = 0.6;
        var monitoringCost = 0.1;
        var spontaneousRetrieval = 0.3;
        var strategicMonitoring = 0.5;
      };
      var intentionRetention = {
        var intentionActivation = [];
        var forgettingRate = 0.1;
        var interferenceSusceptibility = 0.3;
        var reminderEffectiveness = 0.7;
        var retentionInterval = 3600_000_000_000;
      };
      var executionWindow = {
        var windowStart = 0;
        var windowEnd = 0;
        var flexibility = 0.5;
        var executionReadiness = 0.6;
        var taskSwitchingCost = 0.2;
      };
    }
  };
  
  /// Check for prospective memory cue match
  public func checkProspectiveCue(pmState : ProspectiveMemoryState, currentContext : [Float]) : ?EventBasedIntention {
    for (intention in pmState.eventBasedIntentions.vals()) {
      if (not intention.completed) {
        // Compute similarity between current context and cue
        let cueSize = Nat.min(currentContext.size(), intention.cue.size());
        var similarity : Float = 0.0;
        for (i in Iter.range(0, cueSize - 1)) {
          similarity += currentContext[i] * intention.cue[i];
        };
        similarity /= Float.fromInt(cueSize);
        
        // Check if above threshold
        if (similarity > pmState.monitoringProcess.cueDetectionThreshold) {
          return ?intention;
        };
      };
    };
    null
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // METAMEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MetamemoryState = {
    var feelingOfKnowing : FeelingOfKnowing;
    var judgmentOfLearning : JudgmentOfLearning;
    var retrospectiveConfidence : RetrospectiveConfidence;
    var memoryMonitoring : MemoryMonitoring;
    var memoryControl : MemoryControl;
    var memoryBeliefs : MemoryBeliefs;
  };
  
  public type FeelingOfKnowing = {
    var fokStrength : Float;
    var fokAccuracy : Float;
    var cueAccessibility : Float;
    var targetAccessibility : Float;
    var partialKnowledge : Float;
  };
  
  public type JudgmentOfLearning = {
    var jolLevel : Float;
    var jolAccuracy : Float;
    var encodingFluency : Float;
    var retrievalFluency : Float;
    var delayedJOLAdvantage : Float;
  };
  
  public type RetrospectiveConfidence = {
    var confidenceLevel : Float;
    var calibration : Float;
    var overconfidenceBias : Float;
    var underconfidenceBias : Float;
    var resolution : Float;
  };
  
  public type MemoryMonitoring = {
    var easeOfLearningJudgment : Float;
    var sourceMonitoring : Float;
    var realityMonitoring : Float;
    var outputMonitoring : Float;
    var monitoringAccuracy : Float;
  };
  
  public type MemoryControl = {
    var studyTimeAllocation : Float;
    var strategySelection : Nat;
    var studyTermination : Float;
    var rehearsalDecision : Float;
    var effortAllocation : Float;
  };
  
  public type MemoryBeliefs = {
    var selfEfficacy : Float;
    var capacityBelief : Float;
    var changeability : Float;
    var anxietyLevel : Float;
    var achievementMotivation : Float;
  };
  
  /// Initialize metamemory state
  public func initMetamemoryState() : MetamemoryState {
    {
      var feelingOfKnowing = {
        var fokStrength = 0.5;
        var fokAccuracy = 0.6;
        var cueAccessibility = 0.5;
        var targetAccessibility = 0.4;
        var partialKnowledge = 0.3;
      };
      var judgmentOfLearning = {
        var jolLevel = 0.6;
        var jolAccuracy = 0.5;
        var encodingFluency = 0.6;
        var retrievalFluency = 0.5;
        var delayedJOLAdvantage = 0.2;
      };
      var retrospectiveConfidence = {
        var confidenceLevel = 0.7;
        var calibration = 0.6;
        var overconfidenceBias = 0.1;
        var underconfidenceBias = 0.05;
        var resolution = 0.5;
      };
      var memoryMonitoring = {
        var easeOfLearningJudgment = 0.5;
        var sourceMonitoring = 0.6;
        var realityMonitoring = 0.7;
        var outputMonitoring = 0.6;
        var monitoringAccuracy = 0.6;
      };
      var memoryControl = {
        var studyTimeAllocation = 0.5;
        var strategySelection = 0;
        var studyTermination = 0.7;
        var rehearsalDecision = 0.5;
        var effortAllocation = 0.6;
      };
      var memoryBeliefs = {
        var selfEfficacy = 0.6;
        var capacityBelief = 0.5;
        var changeability = 0.5;
        var anxietyLevel = 0.2;
        var achievementMotivation = 0.6;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED MEMORY CONSOLIDATION TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedMemoryState = {
    var baseState : MemoryConsolidationState;
    var semanticMemory : SemanticMemoryState;
    var autobiographicalMemory : AutobiographicalMemoryState;
    var prospectiveMemory : ProspectiveMemoryState;
    var metamemory : MetamemoryState;
    var integratedMemoryCoherence : Float;
    var memorySystemIntegration : Float;
  };
  
  /// Run integrated memory consolidation tick
  public func runIntegratedMemoryTick(
    intState : IntegratedMemoryState,
    newExperience : [Float],
    currentContext : [Float],
    currentTime : Int
  ) : IntegratedMemoryResult {
    let startTime = Time.now();
    
    // 1. Run base memory consolidation
    let baseResult = runMemoryConsolidationTick(intState.baseState, newExperience, currentTime);
    
    // 2. Spread semantic activation
    if (intState.semanticMemory.concepts.size() > 0) {
      spreadSemanticActivation(intState.semanticMemory, [0, 1], 0.8);
    };
    
    // 3. Check prospective memory cues
    let pmTrigger = checkProspectiveCue(intState.prospectiveMemory, currentContext);
    
    // 4. Update metamemory
    intState.metamemory.feelingOfKnowing.fokStrength := baseResult.retrievalSuccess;
    
    // 5. Compute integrated memory coherence
    let semanticCoherence = if (intState.semanticMemory.semanticNetwork.nodes.size() > 0) {
      var avgActivation : Float = 0.0;
      for (a in intState.semanticMemory.semanticNetwork.spreadingActivation.vals()) {
        avgActivation += a;
      };
      avgActivation / Float.fromInt(intState.semanticMemory.semanticNetwork.spreadingActivation.size())
    } else { 0.5 };
    
    let autobioCoherence = intState.autobiographicalMemory.lifeNarrative.coherence;
    let pmMonitoring = intState.prospectiveMemory.monitoringProcess.monitoringIntensity;
    let metaCalibration = intState.metamemory.retrospectiveConfidence.calibration;
    
    intState.integratedMemoryCoherence := (
      baseResult.coherence * 0.3 +
      semanticCoherence * 0.2 +
      autobioCoherence * 0.2 +
      pmMonitoring * 0.15 +
      metaCalibration * 0.15
    );
    
    // 6. Compute memory system integration
    intState.memorySystemIntegration := intState.integratedMemoryCoherence * 
      intState.metamemory.memoryMonitoring.monitoringAccuracy;
    
    {
      baseResult = baseResult;
      semanticActivation = semanticCoherence;
      autobiographicalCoherence = autobioCoherence;
      prospectiveMemoryTriggered = Option.isSome(pmTrigger);
      metamemoryCalibration = metaCalibration;
      integratedCoherence = intState.integratedMemoryCoherence;
      memorySystemIntegration = intState.memorySystemIntegration;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type IntegratedMemoryResult = {
    baseResult : MemoryConsolidationTickResult;
    semanticActivation : Float;
    autobiographicalCoherence : Float;
    prospectiveMemoryTriggered : Bool;
    metamemoryCalibration : Float;
    integratedCoherence : Float;
    memorySystemIntegration : Float;
    processingTime : Int;
  };
  
  /// Get integrated memory status
  public func getIntegratedMemoryStatus(intState : IntegratedMemoryState) : IntegratedMemoryStatus {
    {
      baseStatus = getMemoryConsolidationStatus(intState.baseState);
      semanticMemoryMetrics = {
        numConcepts = intState.semanticMemory.concepts.size();
        numRelations = intState.semanticMemory.relations.size();
        numCategories = intState.semanticMemory.categories.size();
        activationDecay = intState.semanticMemory.semanticNetwork.activationDecay;
      };
      autobiographicalMetrics = {
        numLifePeriods = intState.autobiographicalMemory.lifePeriods.size();
        numGeneralEvents = intState.autobiographicalMemory.generalEvents.size();
        narrativeCoherence = intState.autobiographicalMemory.lifeNarrative.coherence;
        selfConsistency = intState.autobiographicalMemory.selfSchema.selfConsistency;
      };
      prospectiveMemoryMetrics = {
        numEventIntentions = intState.prospectiveMemory.eventBasedIntentions.size();
        numTimeIntentions = intState.prospectiveMemory.timeBasedIntentions.size();
        monitoringIntensity = intState.prospectiveMemory.monitoringProcess.monitoringIntensity;
        executionReadiness = intState.prospectiveMemory.executionWindow.executionReadiness;
      };
      metamemoryMetrics = {
        fokStrength = intState.metamemory.feelingOfKnowing.fokStrength;
        jolLevel = intState.metamemory.judgmentOfLearning.jolLevel;
        confidenceCalibration = intState.metamemory.retrospectiveConfidence.calibration;
        selfEfficacy = intState.metamemory.memoryBeliefs.selfEfficacy;
      };
      integratedCoherence = intState.integratedMemoryCoherence;
      memorySystemIntegration = intState.memorySystemIntegration;
    }
  };
  
  public type IntegratedMemoryStatus = {
    baseStatus : MemoryConsolidationStatus;
    semanticMemoryMetrics : {
      numConcepts : Nat;
      numRelations : Nat;
      numCategories : Nat;
      activationDecay : Float;
    };
    autobiographicalMetrics : {
      numLifePeriods : Nat;
      numGeneralEvents : Nat;
      narrativeCoherence : Float;
      selfConsistency : Float;
    };
    prospectiveMemoryMetrics : {
      numEventIntentions : Nat;
      numTimeIntentions : Nat;
      monitoringIntensity : Float;
      executionReadiness : Float;
    };
    metamemoryMetrics : {
      fokStrength : Float;
      jolLevel : Float;
      confidenceCalibration : Float;
      selfEfficacy : Float;
    };
    integratedCoherence : Float;
    memorySystemIntegration : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // AUTOBIOGRAPHICAL MEMORY - SELF NARRATIVE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AutobiographicalMemoryState = {
    var lifeNarrative : LifeNarrative;
    var selfDefiningMemories : [SelfDefiningMemory];
    var reminiscenceBump : ReminiscenceBump;
    var flashbulbMemories : [FlashbulbMemory];
    var childhoodAmnesia : ChildhoodAmnesiaState;
    var narrativeIdentity : NarrativeIdentity;
    var selfContinuity : SelfContinuityState;
  };
  
  public type LifeNarrative = {
    var chapters : [LifeChapter];
    var currentChapter : Nat;
    var narrativeCoherence : Float;
    var thematicIntegration : Float;
    var plotProgress : Float;
    var characterDevelopment : Float;
  };
  
  public type LifeChapter = {
    chapterId : Nat;
    chapterTitle : Text;
    startTime : Int;
    endTime : ?Int;
    keyEvents : [Nat];
    dominantTheme : Text;
    emotionalTone : Float;
    significance : Float;
    goalProgress : Float;
  };
  
  public type SelfDefiningMemory = {
    memoryId : Nat;
    eventDescription : Text;
    timestamp : Int;
    emotionalIntensity : Float;
    vividness : Float;
    rehearsalFrequency : Float;
    linkedToGoals : [Nat];
    selfRelevance : Float;
    meaningMaking : Float;
    integrationLevel : Float;
  };
  
  public type ReminiscenceBump = {
    var bumpPeakAge : Nat;
    var bumpWidth : Float;
    var memoryDensity : [Float];
    var generationDefiningEvents : [Nat];
    var identityFormationPeriod : (Nat, Nat);
    var culturalScript : Float;
  };
  
  public type FlashbulbMemory = {
    memoryId : Nat;
    eventType : Text;
    timestamp : Int;
    location : Text;
    informantSource : Text;
    emotionalResponse : Float;
    rehearsalCount : Nat;
    confidenceLevel : Float;
    accuracyLevel : Float;
    socialSharing : Float;
  };
  
  public type ChildhoodAmnesiaState = {
    var amnesiaOffset : Nat;
    var fragmentaryMemories : Float;
    var languageDevelopment : Float;
    var selfConceptEmergence : Float;
    var hippocampalMaturation : Float;
    var socialScaffolding : Float;
  };
  
  public type NarrativeIdentity = {
    var redemptiveSequences : Float;
    var contaminationSequences : Float;
    var agencyThemes : Float;
    var communionThemes : Float;
    var growthThemes : Float;
    var stagnationThemes : Float;
    var coherenceLevel : Float;
    var meaningfulnessLevel : Float;
  };
  
  public type SelfContinuityState = {
    var temporalSelfContinuity : Float;
    var personalSameness : Float;
    var autobiographicalReasoning : Float;
    var selfNarrativeCoherence : Float;
    var memoryChaining : Float;
    var identityIntegration : Float;
  };
  
  /// Initialize autobiographical memory state
  public func initAutobiographicalMemoryState() : AutobiographicalMemoryState {
    {
      var lifeNarrative = {
        var chapters = [];
        var currentChapter = 0;
        var narrativeCoherence = 0.5;
        var thematicIntegration = 0.5;
        var plotProgress = 0.0;
        var characterDevelopment = 0.5;
      };
      var selfDefiningMemories = [];
      var reminiscenceBump = {
        var bumpPeakAge = 20;
        var bumpWidth = 10.0;
        var memoryDensity = [];
        var generationDefiningEvents = [];
        var identityFormationPeriod = (15, 30);
        var culturalScript = 0.5;
      };
      var flashbulbMemories = [];
      var childhoodAmnesia = {
        var amnesiaOffset = 3;
        var fragmentaryMemories = 0.2;
        var languageDevelopment = 0.8;
        var selfConceptEmergence = 0.7;
        var hippocampalMaturation = 0.9;
        var socialScaffolding = 0.6;
      };
      var narrativeIdentity = {
        var redemptiveSequences = 0.5;
        var contaminationSequences = 0.2;
        var agencyThemes = 0.6;
        var communionThemes = 0.5;
        var growthThemes = 0.6;
        var stagnationThemes = 0.2;
        var coherenceLevel = 0.5;
        var meaningfulnessLevel = 0.5;
      };
      var selfContinuity = {
        var temporalSelfContinuity = 0.7;
        var personalSameness = 0.8;
        var autobiographicalReasoning = 0.5;
        var selfNarrativeCoherence = 0.6;
        var memoryChaining = 0.5;
        var identityIntegration = 0.6;
      };
    }
  };
  
  /// Process autobiographical memory encoding
  public func processAutobiographicalEncoding(abmState : AutobiographicalMemoryState, event : [Float], timestamp : Int, emotionalIntensity : Float) : Bool {
    // Check if event is self-defining
    let selfRelevance = if (event.size() > 0) { event[0] } else { 0.5 };
    let isSelfDefining = selfRelevance > 0.7 and emotionalIntensity > 0.6;
    
    // Update narrative coherence based on event integration
    abmState.lifeNarrative.narrativeCoherence := abmState.lifeNarrative.narrativeCoherence * 0.95 +
      (if (isSelfDefining) { 0.1 } else { 0.0 });
    
    // Update self-continuity
    abmState.selfContinuity.temporalSelfContinuity := 
      abmState.selfContinuity.temporalSelfContinuity * 0.99 + selfRelevance * 0.01;
    
    // Process narrative identity themes
    if (emotionalIntensity > 0.5) {
      if (event.size() > 1 and event[1] > 0.5) {
        // Positive outcome → redemptive sequence
        abmState.narrativeIdentity.redemptiveSequences := 
          abmState.narrativeIdentity.redemptiveSequences * 0.9 + 0.1;
      } else {
        // Negative outcome → contamination sequence
        abmState.narrativeIdentity.contaminationSequences := 
          abmState.narrativeIdentity.contaminationSequences * 0.9 + 0.1;
      };
    };
    
    isSelfDefining
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COLLECTIVE MEMORY - SOCIAL TRANSMISSION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CollectiveMemoryState = {
    var culturalMemory : CulturalMemory;
    var socialTransmission : SocialTransmission;
    var collectiveRemembering : CollectiveRemembering;
    var memoryPolitics : MemoryPolitics;
    var commemorativePractices : CommemorativePractices;
    var intergenerationalTransmission : IntergenerationalTransmission;
  };
  
  public type CulturalMemory = {
    var sharedNarratives : [Nat];
    var collectiveTrauma : Float;
    var nationalIdentity : Float;
    var historicalConsciousness : Float;
    var culturalCanon : [Text];
    var heritageValue : Float;
  };
  
  public type SocialTransmission = {
    var communicativeMemory : Float;
    var culturalMemoryTransition : Float;
    var generationalDistance : Nat;
    var transmissionFidelity : Float;
    var socialFrames : [[Float]];
    var narrativeTemplates : [Text];
  };
  
  public type CollectiveRemembering = {
    var transactiveMemory : TransactiveMemory;
    var collaborativeRecall : Float;
    var socialContagion : Float;
    var groupNarratives : [Text];
    var sharedSchemas : [[Float]];
  };
  
  public type TransactiveMemory = {
    var expertiseDirectory : [(Nat, Text)];
    var informationAllocation : [[Float]];
    var coordinationEfficiency : Float;
    var memoryDifferentiation : Float;
    var credibilityAssessment : [Float];
  };
  
  public type MemoryPolitics = {
    var contestedNarratives : [Text];
    var memoryConflicts : Float;
    var officialHistory : [Text];
    var counterMemory : [Text];
    var silencedVoices : Float;
    var memoryActivism : Float;
  };
  
  public type CommemorativePractices = {
    var rituals : [Text];
    var monuments : [Text];
    var anniversaries : [Int];
    var memorialSites : [Text];
    var oralHistory : Float;
    var documentaryPractices : Float;
  };
  
  public type IntergenerationalTransmission = {
    var familyMemory : Float;
    var postmemory : Float;
    var inheritedTrauma : Float;
    var generationalNarratives : [[Float]];
    var silenceAndTaboo : Float;
    var redemptiveRetelling : Float;
  };
  
  /// Initialize collective memory state
  public func initCollectiveMemoryState() : CollectiveMemoryState {
    {
      var culturalMemory = {
        var sharedNarratives = [];
        var collectiveTrauma = 0.0;
        var nationalIdentity = 0.5;
        var historicalConsciousness = 0.5;
        var culturalCanon = [];
        var heritageValue = 0.5;
      };
      var socialTransmission = {
        var communicativeMemory = 0.7;
        var culturalMemoryTransition = 0.3;
        var generationalDistance = 3;
        var transmissionFidelity = 0.7;
        var socialFrames = [];
        var narrativeTemplates = [];
      };
      var collectiveRemembering = {
        var transactiveMemory = {
          var expertiseDirectory = [];
          var informationAllocation = [];
          var coordinationEfficiency = 0.5;
          var memoryDifferentiation = 0.5;
          var credibilityAssessment = [];
        };
        var collaborativeRecall = 0.5;
        var socialContagion = 0.3;
        var groupNarratives = [];
        var sharedSchemas = [];
      };
      var memoryPolitics = {
        var contestedNarratives = [];
        var memoryConflicts = 0.0;
        var officialHistory = [];
        var counterMemory = [];
        var silencedVoices = 0.0;
        var memoryActivism = 0.0;
      };
      var commemorativePractices = {
        var rituals = [];
        var monuments = [];
        var anniversaries = [];
        var memorialSites = [];
        var oralHistory = 0.5;
        var documentaryPractices = 0.5;
      };
      var intergenerationalTransmission = {
        var familyMemory = 0.6;
        var postmemory = 0.0;
        var inheritedTrauma = 0.0;
        var generationalNarratives = [];
        var silenceAndTaboo = 0.2;
        var redemptiveRetelling = 0.5;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED DEEP MEMORY SYSTEMS TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeepIntegratedMemorySystemsState = {
    var baseState : IntegratedMemorySystemsState;
    var autobiographical : AutobiographicalMemoryState;
    var collective : CollectiveMemoryState;
    var deepMemoryIntegration : Float;
    var identityCoherence : Float;
  };
  
  /// Run deep integrated memory systems tick
  public func runDeepIntegratedMemorySystemsTick(
    deepState : DeepIntegratedMemorySystemsState,
    sensoryInput : [Float],
    timestamp : Int,
    emotionalState : Float,
    dt : Float
  ) : DeepIntegratedMemorySystemsResult {
    let startTime = Time.now();
    
    // 1. Run base memory systems tick
    let baseResult = runIntegratedMemorySystemsTick(deepState.baseState, sensoryInput, timestamp, dt);
    
    // 2. Process autobiographical encoding
    let selfDefiningEvent = processAutobiographicalEncoding(
      deepState.autobiographical, sensoryInput, timestamp, emotionalState);
    
    // 3. Compute deep memory integration
    deepState.deepMemoryIntegration := (
      baseResult.integratedCoherence * 0.4 +
      deepState.autobiographical.lifeNarrative.narrativeCoherence * 0.3 +
      deepState.collective.socialTransmission.transmissionFidelity * 0.3
    );
    
    // 4. Compute identity coherence
    deepState.identityCoherence := (
      deepState.autobiographical.selfContinuity.temporalSelfContinuity * 0.4 +
      deepState.autobiographical.narrativeIdentity.coherenceLevel * 0.3 +
      deepState.collective.culturalMemory.nationalIdentity * 0.3
    );
    
    {
      baseResult = baseResult;
      selfDefiningEncoded = selfDefiningEvent;
      narrativeCoherence = deepState.autobiographical.lifeNarrative.narrativeCoherence;
      selfContinuity = deepState.autobiographical.selfContinuity.temporalSelfContinuity;
      collectiveTransmission = deepState.collective.socialTransmission.transmissionFidelity;
      deepMemoryIntegration = deepState.deepMemoryIntegration;
      identityCoherence = deepState.identityCoherence;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type DeepIntegratedMemorySystemsResult = {
    baseResult : IntegratedMemorySystemsResult;
    selfDefiningEncoded : Bool;
    narrativeCoherence : Float;
    selfContinuity : Float;
    collectiveTransmission : Float;
    deepMemoryIntegration : Float;
    identityCoherence : Float;
    processingTime : Int;
  };
  
  /// Get deep integrated memory systems status
  public func getDeepIntegratedMemorySystemsStatus(deepState : DeepIntegratedMemorySystemsState) : DeepIntegratedMemorySystemsStatus {
    {
      baseStatus = getIntegratedMemorySystemsStatus(deepState.baseState);
      autobiographicalStatus = {
        narrativeCoherence = deepState.autobiographical.lifeNarrative.narrativeCoherence;
        thematicIntegration = deepState.autobiographical.lifeNarrative.thematicIntegration;
        redemptiveThemes = deepState.autobiographical.narrativeIdentity.redemptiveSequences;
        agencyThemes = deepState.autobiographical.narrativeIdentity.agencyThemes;
        selfContinuity = deepState.autobiographical.selfContinuity.temporalSelfContinuity;
        identityIntegration = deepState.autobiographical.selfContinuity.identityIntegration;
      };
      collectiveStatus = {
        culturalMemoryStrength = deepState.collective.culturalMemory.heritageValue;
        transmissionFidelity = deepState.collective.socialTransmission.transmissionFidelity;
        transactiveEfficiency = deepState.collective.collectiveRemembering.transactiveMemory.coordinationEfficiency;
        intergenerationalTransfer = deepState.collective.intergenerationalTransmission.familyMemory;
      };
      deepMemoryIntegration = deepState.deepMemoryIntegration;
      identityCoherence = deepState.identityCoherence;
    }
  };
  
  public type DeepIntegratedMemorySystemsStatus = {
    baseStatus : IntegratedMemorySystemsStatus;
    autobiographicalStatus : {
      narrativeCoherence : Float;
      thematicIntegration : Float;
      redemptiveThemes : Float;
      agencyThemes : Float;
      selfContinuity : Float;
      identityIntegration : Float;
    };
    collectiveStatus : {
      culturalMemoryStrength : Float;
      transmissionFidelity : Float;
      transactiveEfficiency : Float;
      intergenerationalTransfer : Float;
    };
    deepMemoryIntegration : Float;
    identityCoherence : Float;
  };
}
