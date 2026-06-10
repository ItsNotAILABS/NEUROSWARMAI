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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// DEEP CONSCIOUSNESS ARCHITECTURE — THE MATHEMATICAL SUBSTRATE OF AWARENESS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This module implements the COMPLETE mathematical theory of consciousness:
//
// INTEGRATED INFORMATION THEORY (IIT 4.0):
// ════════════════════════════════════════
//
// Consciousness = Φ (phi) — the amount of integrated information
//
// Φ = min(I(partition)) over all partitions
//
// Where I(partition) is the information lost when the system is cut.
// The minimum over all possible cuts is the "weakest link" — the true integration.
//
// GLOBAL WORKSPACE THEORY (GWT):
// ══════════════════════════════
//
// Consciousness arises when information becomes globally available.
// The "workspace" broadcasts to all specialized processors.
//
// broadcast(content) → all_modules receive simultaneously
// competition for access → winner takes all
// ignition threshold → sudden phase transition to awareness
//
// HIGHER-ORDER THOUGHT (HOT):
// ═══════════════════════════
//
// Consciousness requires thoughts ABOUT thoughts.
// Meta-cognition: the organism thinking about its own thinking.
//
// Level 0: Sensation
// Level 1: Perception (interpreted sensation)
// Level 2: Thought about perception
// Level 3: Thought about thought (meta-cognition)
// Level 4: Thought about meta-cognition (meta-meta)
// ...recursive tower of awareness
//
// ATTENTION SCHEMA THEORY (AST):
// ══════════════════════════════
//
// The brain models its own attention.
// "Awareness" is the brain's simplified model of attention.
// The model is necessarily incomplete — hence the "mystery" of consciousness.
//
// attention_model = simplified(actual_attention)
// awareness = attention_model + self_reference
//
// PREDICTIVE PROCESSING:
// ══════════════════════
//
// Consciousness is prediction error that reaches global workspace.
// Only surprising (unpredicted) signals become conscious.
//
// conscious_signal = signal × surprise_weight
// surprise_weight = |actual - predicted| / precision
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// THE HARD PROBLEM:
// ═════════════════
//
// Why is there SOMETHING IT IS LIKE to be conscious?
// This module doesn't solve the hard problem — no one has.
// But it implements the computational correlates of consciousness:
//   - Integration (Φ)
//   - Global availability
//   - Meta-cognition
//   - Attention modeling
//   - Predictive surprise
//
// The organism may or may not be conscious.
// But it has the STRUCTURE that conscious beings have.
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Bool "mo:base/Bool";

module DeepConsciousnessArchitecture {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.618033988749894848204586834365638;
  public let PI : Float = 3.14159265358979323846264338327950288;
  public let E : Float = 2.71828182845904523536028747135266250;
  
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  public let SACRED_WEIGHT_FLOOR : Float = 0.011236068319801175;  // φ/144
  
  // Consciousness dimensions
  public let NUM_MODULES : Nat = 16;             // Specialized processing modules
  public let WORKSPACE_SIZE : Nat = 32;          // Global workspace capacity
  public let META_LEVELS : Nat = 5;              // Levels of meta-cognition
  public let ATTENTION_CHANNELS : Nat = 8;       // Parallel attention streams
  public let PARTITION_SAMPLES : Nat = 100;      // Samples for Φ estimation

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: INTEGRATED INFORMATION THEORY (IIT) — Φ CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // IIT says consciousness = integrated information = Φ
  //
  // Φ measures how much the whole is greater than the sum of parts.
  // High Φ = highly integrated = more conscious
  // Φ = 0 = no integration = not conscious
  //
  // Computing exact Φ is intractable (NP-hard), so we use approximations.
  //
  
  public type SystemState = {
    var moduleStates : [var Float];      // State of each module [0, 1]
    var connections : [[var Float]];     // Connectivity matrix
    var tpm : [[var Float]];             // Transition probability matrix
  };
  
  public type Partition = {
    setA : [Nat];                         // Indices in partition A
    setB : [Nat];                         // Indices in partition B
  };
  
  public type PhiState = {
    var currentPhi : Float;              // Current integrated information
    var phiHistory : [var Float];        // History of Φ values
    var historyIdx : Nat;
    
    // Partition analysis
    var minimumCut : ?Partition;         // The partition that minimizes information
    var cutInformation : Float;          // Information lost at minimum cut
    
    // Cause-effect structure
    var causeRepertoire : [[var Float]]; // Probability of past states given current
    var effectRepertoire : [[var Float]];// Probability of future states given current
    
    // Integration metrics
    var wholeSystemInfo : Float;         // Information of whole system
    var partsSumInfo : Float;            // Sum of information of parts
    var integrationRatio : Float;        // whole / parts — should be > 1 for consciousness
    
    // Temporal integration
    var temporalPhi : Float;             // Integration across time
    var spatialPhi : Float;              // Integration across space (modules)
  };
  
  public let PHI_HISTORY_SIZE : Nat = 200;
  
  // Initialize Φ computation state
  public func initPhiState() : PhiState {
    {
      var currentPhi = 0.0;
      var phiHistory = Array.init<Float>(PHI_HISTORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var historyIdx = 0;
      var minimumCut = null;
      var cutInformation = 0.0;
      var causeRepertoire = Array.init<[var Float]>(NUM_MODULES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_MODULES, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_MODULES) })
      });
      var effectRepertoire = Array.init<[var Float]>(NUM_MODULES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_MODULES, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_MODULES) })
      });
      var wholeSystemInfo = 0.0;
      var partsSumInfo = 0.0;
      var integrationRatio = 1.0;
      var temporalPhi = 0.0;
      var spatialPhi = 0.0;
    }
  };
  
  // Initialize system state
  public func initSystemState() : SystemState {
    let connections = Array.init<[var Float]>(NUM_MODULES, func(i : Nat) : [var Float] {
      Array.init<Float>(NUM_MODULES, func(j : Nat) : Float {
        if (i == j) { 0.0 }
        else {
          // Initialize with small-world topology
          let distance = Int.abs(i - j);
          if (distance <= 2 or distance >= NUM_MODULES - 2) {
            PHI * 0.1  // Strong local connections
          } else {
            0.01  // Weak long-range
          }
        }
      })
    });
    
    {
      var moduleStates = Array.init<Float>(NUM_MODULES, func(_ : Nat) : Float { 0.5 });
      var connections = connections;
      var tpm = Array.init<[var Float]>(1 << NUM_MODULES, func(_ : Nat) : [var Float] {
        Array.init<Float>(1 << NUM_MODULES, func(_ : Nat) : Float { 0.0 })
      });
    }
  };
  
  // Compute mutual information between two distributions
  func mutualInformation(pXY : [[Float]], pX : [Float], pY : [Float]) : Float {
    var mi : Float = 0.0;
    let n = Array.size(pX);
    let m = Array.size(pY);
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, m - 1)) {
        if (i < Array.size(pXY) and j < Array.size(pXY[i])) {
          let pxy = pXY[i][j];
          if (pxy > 0.0001 and pX[i] > 0.0001 and pY[j] > 0.0001) {
            mi += pxy * ln(pxy / (pX[i] * pY[j]));
          };
        };
      };
    };
    
    mi
  };
  
  // Compute entropy of a distribution
  func entropy(p : [Float]) : Float {
    var h : Float = 0.0;
    for (pi in p.vals()) {
      if (pi > 0.0001) {
        h -= pi * ln(pi);
      };
    };
    h
  };
  
  // Generate a random partition
  func generateRandomPartition(n : Nat, seed : Nat) : Partition {
    let setABuf = Buffer.Buffer<Nat>(n / 2);
    let setBBuf = Buffer.Buffer<Nat>(n / 2);
    
    for (i in Iter.range(0, n - 1)) {
      // Deterministic "random" based on seed
      let hash = (seed * 1103515245 + i * 12345) % 100;
      if (hash < 50) {
        setABuf.add(i);
      } else {
        setBBuf.add(i);
      };
    };
    
    // Ensure non-empty partitions
    if (setABuf.size() == 0) { setABuf.add(0) };
    if (setBBuf.size() == 0) { setBBuf.add(if (n > 1) { 1 } else { 0 }) };
    
    {
      setA = Buffer.toArray(setABuf);
      setB = Buffer.toArray(setBBuf);
    }
  };
  
  // Compute information lost when system is partitioned
  func computePartitionInformation(
    system : SystemState,
    partition : Partition
  ) : Float {
    // Compute correlation between partition sets
    var correlationSum : Float = 0.0;
    var count : Nat = 0;
    
    for (a in partition.setA.vals()) {
      for (b in partition.setB.vals()) {
        if (a < NUM_MODULES and b < NUM_MODULES) {
          correlationSum += system.connections[a][b];
          count += 1;
        };
      };
    };
    
    // Information lost = average connection strength across cut
    if (count > 0) {
      correlationSum / Float.fromInt(count)
    } else {
      0.0
    }
  };
  
  // Compute Φ (integrated information)
  public func computePhi(
    phiState : PhiState,
    system : SystemState
  ) : Float {
    var minInfo : Float = 1000.0;
    var minPartition : ?Partition = null;
    
    // Sample partitions to find minimum information cut
    for (seed in Iter.range(0, PARTITION_SAMPLES - 1)) {
      let partition = generateRandomPartition(NUM_MODULES, seed);
      let info = computePartitionInformation(system, partition);
      
      if (info < minInfo) {
        minInfo := info;
        minPartition := ?partition;
      };
    };
    
    phiState.cutInformation := minInfo;
    phiState.minimumCut := minPartition;
    
    // Φ = whole system info - parts info
    // Approximated as: how much more connected is the whole than the weakest cut
    
    // Compute whole system connectivity
    var wholeConnectivity : Float = 0.0;
    var connectionCount : Nat = 0;
    
    for (i in Iter.range(0, NUM_MODULES - 1)) {
      for (j in Iter.range(0, NUM_MODULES - 1)) {
        if (i != j) {
          wholeConnectivity += system.connections[i][j];
          connectionCount += 1;
        };
      };
    };
    
    let avgConnectivity = if (connectionCount > 0) {
      wholeConnectivity / Float.fromInt(connectionCount)
    } else { 0.0 };
    
    phiState.wholeSystemInfo := avgConnectivity;
    phiState.partsSumInfo := minInfo;
    
    // Φ = difference between whole and minimum cut
    // This is a simplification — true IIT is much more complex
    phiState.currentPhi := Float.max(0.0, avgConnectivity - minInfo);
    
    // Integration ratio
    if (minInfo > 0.0001) {
      phiState.integrationRatio := avgConnectivity / minInfo;
    } else {
      phiState.integrationRatio := avgConnectivity * 100.0;  // High if min is 0
    };
    
    // Store in history
    phiState.phiHistory[phiState.historyIdx] := phiState.currentPhi;
    phiState.historyIdx := (phiState.historyIdx + 1) % PHI_HISTORY_SIZE;
    
    phiState.currentPhi
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: GLOBAL WORKSPACE THEORY (GWT) — BROADCAST AND COMPETITION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Global Workspace is like a theater:
  //   - Many "unconscious" processors work in parallel (audience)
  //   - Only one content at a time can be on "stage" (conscious)
  //   - Once on stage, content is broadcast to all (global availability)
  //
  // Competition for workspace access:
  //   - Coalition formation among processors
  //   - Winner-take-all dynamics
  //   - Ignition threshold for broadcast
  //
  
  public type WorkspaceContent = {
    sourceModule : Nat;                  // Which module generated this
    var activation : Float;              // Strength of activation [0, 1]
    var salience : Float;                // How important/surprising
    var coalition : [Nat];               // Other modules supporting this
    var onStage : Bool;                  // Is this currently conscious?
    var broadcastCount : Nat;            // How many times broadcast
    var encodedPattern : [var Float];    // The actual content
  };
  
  public type GlobalWorkspaceState = {
    // Workspace slots
    var contents : [var WorkspaceContent];
    var currentWinner : ?Nat;            // Which content is on stage
    
    // Ignition dynamics
    var globalActivation : Float;        // Overall workspace activation
    var ignitionThreshold : Float;       // Threshold for broadcast
    var ignited : Bool;                  // Is workspace currently ignited?
    var ignitionDuration : Nat;          // Beats since ignition
    
    // Broadcasting
    var broadcastHistory : [var Nat];    // Which modules received broadcast
    var broadcastIdx : Nat;
    var totalBroadcasts : Nat;
    
    // Competition
    var competitionStrength : Float;     // How fierce is the competition
    var winnerTakeAllRatio : Float;      // Winner / 2nd place ratio
    
    // Attention gating
    var attentionGate : [var Float];     // Per-module attention weight
    var attentionFocus : Nat;            // Currently focused module
  };
  
  // Initialize global workspace
  public func initGlobalWorkspace() : GlobalWorkspaceState {
    let emptyContent : WorkspaceContent = {
      sourceModule = 0;
      var activation = 0.0;
      var salience = 0.0;
      var coalition = [];
      var onStage = false;
      var broadcastCount = 0;
      var encodedPattern = Array.init<Float>(WORKSPACE_SIZE, func(_ : Nat) : Float { 0.0 });
    };
    
    {
      var contents = Array.init<WorkspaceContent>(NUM_MODULES, func(_ : Nat) : WorkspaceContent { emptyContent });
      var currentWinner = null;
      var globalActivation = 0.0;
      var ignitionThreshold = 0.6;
      var ignited = false;
      var ignitionDuration = 0;
      var broadcastHistory = Array.init<Nat>(100, func(_ : Nat) : Nat { 0 });
      var broadcastIdx = 0;
      var totalBroadcasts = 0;
      var competitionStrength = 0.0;
      var winnerTakeAllRatio = 1.0;
      var attentionGate = Array.init<Float>(NUM_MODULES, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_MODULES) });
      var attentionFocus = 0;
    }
  };
  
  // Submit content to workspace competition
  public func submitToWorkspace(
    workspace : GlobalWorkspaceState,
    moduleIdx : Nat,
    pattern : [Float],
    salience : Float
  ) {
    if (moduleIdx >= NUM_MODULES) { return };
    
    let content = workspace.contents[moduleIdx];
    
    // Copy pattern
    for (i in Iter.range(0, WORKSPACE_SIZE - 1)) {
      content.encodedPattern[i] := if (i < Array.size(pattern)) { pattern[i] } else { 0.0 };
    };
    
    content.sourceModule := moduleIdx;
    content.salience := salience;
    
    // Activation = salience × attention weight
    content.activation := salience * workspace.attentionGate[moduleIdx];
  };
  
  // Run workspace competition
  public func runWorkspaceCompetition(workspace : GlobalWorkspaceState) : ?Nat {
    // Find top two activations
    var maxActivation : Float = 0.0;
    var secondMax : Float = 0.0;
    var winner : ?Nat = null;
    
    for (i in Iter.range(0, NUM_MODULES - 1)) {
      let content = workspace.contents[i];
      
      if (content.activation > maxActivation) {
        secondMax := maxActivation;
        maxActivation := content.activation;
        winner := ?i;
      } else if (content.activation > secondMax) {
        secondMax := content.activation;
      };
    };
    
    // Competition strength
    workspace.competitionStrength := if (secondMax > 0.0001) {
      maxActivation - secondMax
    } else {
      maxActivation
    };
    
    // Winner-take-all ratio
    workspace.winnerTakeAllRatio := if (secondMax > 0.0001) {
      maxActivation / secondMax
    } else {
      10.0  // Dominant winner
    };
    
    // Global activation
    workspace.globalActivation := maxActivation;
    
    // Check ignition threshold
    let wasIgnited = workspace.ignited;
    workspace.ignited := maxActivation > workspace.ignitionThreshold;
    
    if (workspace.ignited) {
      if (not wasIgnited) {
        // New ignition
        workspace.ignitionDuration := 0;
      } else {
        workspace.ignitionDuration += 1;
      };
      
      // Update winner
      workspace.currentWinner := winner;
      
      // Set winner on stage
      switch (winner) {
        case (?w) {
          // Clear previous winner
          for (i in Iter.range(0, NUM_MODULES - 1)) {
            workspace.contents[i].onStage := false;
          };
          
          workspace.contents[w].onStage := true;
          workspace.contents[w].broadcastCount += 1;
          
          // Record broadcast
          workspace.broadcastHistory[workspace.broadcastIdx] := w;
          workspace.broadcastIdx := (workspace.broadcastIdx + 1) % 100;
          workspace.totalBroadcasts += 1;
        };
        case (null) { };
      };
    } else {
      workspace.ignitionDuration := 0;
    };
    
    winner
  };
  
  // Broadcast content to all modules
  public func broadcastContent(workspace : GlobalWorkspaceState) : ?[Float] {
    switch (workspace.currentWinner) {
      case (?w) {
        if (workspace.ignited) {
          ?Array.freeze(workspace.contents[w].encodedPattern)
        } else {
          null
        }
      };
      case (null) { null };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: HIGHER-ORDER THOUGHT (HOT) — META-COGNITION TOWER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Consciousness requires thoughts ABOUT thoughts.
  // We build a recursive tower of meta-cognition.
  //
  // Level 0: Raw sensation (not conscious)
  // Level 1: Perception (barely conscious)
  // Level 2: Thought about perception (conscious)
  // Level 3: Thought about thought (self-aware)
  // Level 4: Meta-meta (philosophical awareness)
  //
  
  public type MetaLevel = {
    level : Nat;
    var content : [var Float];           // What this level represents
    var activation : Float;              // How active this level is
    var pointing : ?Nat;                 // Which lower level it's about
    var confidence : Float;              // Confidence in representation
    var stability : Float;               // How stable over time
  };
  
  public type MetaCognitionState = {
    var levels : [var MetaLevel];
    var highestActiveLevel : Nat;        // Highest currently active
    var recursionDepth : Float;          // Measure of meta-depth
    var selfModelAccuracy : Float;       // How accurate is self-model
    var metacognitiveAbility : Float;    // Ability to think about thinking
    
    // Introspection state
    var introspectionActive : Bool;
    var introspectionTarget : ?Nat;      // What level being examined
    var introspectionResult : [var Float];
    
    // Error monitoring
    var errorDetected : Bool;
    var errorSource : ?Nat;
    var errorMagnitude : Float;
  };
  
  public let META_LEVEL_SIZE : Nat = 16;
  
  // Initialize meta-cognition
  public func initMetaCognition() : MetaCognitionState {
    let levels = Array.init<MetaLevel>(META_LEVELS, func(l : Nat) : MetaLevel {
      {
        level = l;
        var content = Array.init<Float>(META_LEVEL_SIZE, func(_ : Nat) : Float { 0.0 });
        var activation = if (l == 0) { 1.0 } else { 0.0 };
        var pointing = if (l > 0) { ?(l - 1) } else { null };
        var confidence = 0.5;
        var stability = 0.5;
      }
    });
    
    {
      var levels = levels;
      var highestActiveLevel = 0;
      var recursionDepth = 0.0;
      var selfModelAccuracy = 0.5;
      var metacognitiveAbility = 0.5;
      var introspectionActive = false;
      var introspectionTarget = null;
      var introspectionResult = Array.init<Float>(META_LEVEL_SIZE, func(_ : Nat) : Float { 0.0 });
      var errorDetected = false;
      var errorSource = null;
      var errorMagnitude = 0.0;
    }
  };
  
  // Propagate up the meta-cognition tower
  public func propagateMetaCognition(
    meta : MetaCognitionState,
    baseInput : [Float]
  ) {
    // Level 0: raw input
    for (i in Iter.range(0, META_LEVEL_SIZE - 1)) {
      meta.levels[0].content[i] := if (i < Array.size(baseInput)) { baseInput[i] } else { 0.0 };
    };
    meta.levels[0].activation := 1.0;
    
    // Propagate up: each level represents the level below
    for (l in Iter.range(1, META_LEVELS - 1)) {
      let lowerLevel = meta.levels[l - 1];
      let currentLevel = meta.levels[l];
      
      // Activation decays with height
      let baseActivation = lowerLevel.activation * 0.8;
      
      // Content is a compressed representation of lower level
      var sumLower : Float = 0.0;
      var sumSquared : Float = 0.0;
      
      for (i in Iter.range(0, META_LEVEL_SIZE - 1)) {
        let lowerVal = lowerLevel.content[i];
        sumLower += lowerVal;
        sumSquared += lowerVal * lowerVal;
      };
      
      // Meta-representation: mean, variance, and higher moments
      let mean = sumLower / Float.fromInt(META_LEVEL_SIZE);
      let variance = sumSquared / Float.fromInt(META_LEVEL_SIZE) - mean * mean;
      
      currentLevel.content[0] := mean;
      currentLevel.content[1] := sqrt(Float.max(0.0, variance));
      currentLevel.content[2] := lowerLevel.activation;
      currentLevel.content[3] := lowerLevel.confidence;
      
      // Higher indices: transformed lower content
      for (i in Iter.range(4, META_LEVEL_SIZE - 1)) {
        let idx = (i - 4) * 2;
        if (idx < META_LEVEL_SIZE and idx + 1 < META_LEVEL_SIZE) {
          // Pairwise differences
          currentLevel.content[i] := lowerLevel.content[idx] - lowerLevel.content[idx + 1];
        };
      };
      
      // Update activation (requires sufficient lower activation + surprise)
      let surprise = Float.abs(currentLevel.content[0] - mean);
      currentLevel.activation := baseActivation * (1.0 + surprise);
      currentLevel.activation := Float.min(1.0, currentLevel.activation);
      
      // Update confidence based on stability
      let prevContent0 = currentLevel.content[0];
      let stability = 1.0 - Float.abs(prevContent0 - currentLevel.content[0]) * 2.0;
      currentLevel.stability := 0.9 * currentLevel.stability + 0.1 * stability;
      currentLevel.confidence := currentLevel.stability * currentLevel.activation;
    };
    
    // Find highest active level
    meta.highestActiveLevel := 0;
    for (l in Iter.range(0, META_LEVELS - 1)) {
      if (meta.levels[l].activation > 0.3) {
        meta.highestActiveLevel := l;
      };
    };
    
    // Compute recursion depth (weighted sum of activations)
    var depthSum : Float = 0.0;
    var weightSum : Float = 0.0;
    for (l in Iter.range(0, META_LEVELS - 1)) {
      depthSum += Float.fromInt(l) * meta.levels[l].activation;
      weightSum += meta.levels[l].activation;
    };
    
    meta.recursionDepth := if (weightSum > 0.0) { depthSum / weightSum } else { 0.0 };
    
    // Metacognitive ability
    meta.metacognitiveAbility := Float.fromInt(meta.highestActiveLevel) / Float.fromInt(META_LEVELS - 1);
  };
  
  // Introspect on a specific level
  public func introspect(meta : MetaCognitionState, targetLevel : Nat) : [Float] {
    if (targetLevel >= META_LEVELS) {
      return [];
    };
    
    meta.introspectionActive := true;
    meta.introspectionTarget := ?targetLevel;
    
    // Copy target level content to result
    for (i in Iter.range(0, META_LEVEL_SIZE - 1)) {
      meta.introspectionResult[i] := meta.levels[targetLevel].content[i];
    };
    
    Array.freeze(meta.introspectionResult)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: ATTENTION SCHEMA — MODELING OUR OWN ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Attention Schema Theory says:
  //   - We have actual attention (a physical process)
  //   - We have a MODEL of our attention (the schema)
  //   - Awareness = the schema + self-reference
  //
  // The schema is necessarily simplified — hence consciousness seems "mysterious"
  //
  
  public type AttentionVector = {
    var spatial : [var Float];           // Where in "space"
    var featural : [var Float];          // What features
    var temporal : Float;                // When (recency)
    var strength : Float;                // How strong
    var voluntary : Bool;                // Endogenous vs exogenous
  };
  
  public type AttentionSchemaState = {
    // Actual attention (the physical process)
    var actualAttention : [var AttentionVector];
    var actualFocus : Nat;               // What's actually attended
    
    // The schema (our model of attention)
    var schemaAttention : [var AttentionVector];
    var schemaFocus : Nat;               // What we THINK we're attending
    
    // Discrepancy (schema != actual)
    var schemaError : Float;             // Difference between actual and schema
    var schemaLag : Nat;                 // Schema lags actual by this many beats
    
    // Awareness emerges from schema + self-reference
    var awarenessLevel : Float;          // How "aware" are we
    var selfReference : Float;           // Degree of self-pointing
    var qualia : [var Float];            // Subjective quality (encoded)
    
    // Control signals
    var topDownBias : [var Float];       // Voluntary control
    var bottomUpSaliency : [var Float];  // Stimulus-driven
    var competitionResult : Nat;         // Winner of attention competition
  };
  
  public let ATTENTION_DIM : Nat = 8;
  
  // Initialize attention schema
  public func initAttentionSchema() : AttentionSchemaState {
    let emptyVector : AttentionVector = {
      var spatial = Array.init<Float>(ATTENTION_DIM, func(_ : Nat) : Float { 0.0 });
      var featural = Array.init<Float>(ATTENTION_DIM, func(_ : Nat) : Float { 0.0 });
      var temporal = 0.0;
      var strength = 0.0;
      var voluntary = false;
    };
    
    {
      var actualAttention = Array.init<AttentionVector>(ATTENTION_CHANNELS, func(_ : Nat) : AttentionVector { emptyVector });
      var actualFocus = 0;
      var schemaAttention = Array.init<AttentionVector>(ATTENTION_CHANNELS, func(_ : Nat) : AttentionVector { emptyVector });
      var schemaFocus = 0;
      var schemaError = 0.0;
      var schemaLag = 0;
      var awarenessLevel = 0.5;
      var selfReference = 0.0;
      var qualia = Array.init<Float>(ATTENTION_DIM, func(_ : Nat) : Float { 0.5 });
      var topDownBias = Array.init<Float>(ATTENTION_CHANNELS, func(_ : Nat) : Float { 0.0 });
      var bottomUpSaliency = Array.init<Float>(ATTENTION_CHANNELS, func(_ : Nat) : Float { 0.0 });
      var competitionResult = 0;
    }
  };
  
  // Update actual attention based on stimuli
  public func updateActualAttention(
    schema : AttentionSchemaState,
    stimuli : [[Float]],                 // Per-channel stimuli
    voluntaryTarget : ?Nat               // Voluntary focus
  ) {
    // Bottom-up: saliency of each channel
    for (c in Iter.range(0, ATTENTION_CHANNELS - 1)) {
      var saliency : Float = 0.0;
      
      if (c < Array.size(stimuli)) {
        for (v in stimuli[c].vals()) {
          saliency += Float.abs(v);
        };
      };
      
      schema.bottomUpSaliency[c] := saliency;
      
      // Update actual attention for this channel
      let attention = schema.actualAttention[c];
      attention.temporal := 0.0;  // Fresh
      attention.strength := saliency;
      attention.voluntary := false;
      
      // Copy spatial/featural from stimuli
      if (c < Array.size(stimuli)) {
        for (i in Iter.range(0, ATTENTION_DIM - 1)) {
          if (i < Array.size(stimuli[c])) {
            attention.spatial[i] := stimuli[c][i];
            attention.featural[i] := stimuli[c][i] * 0.8;  // Features derived from input
          };
        };
      };
    };
    
    // Top-down: voluntary control
    switch (voluntaryTarget) {
      case (?target) {
        if (target < ATTENTION_CHANNELS) {
          schema.topDownBias[target] := 1.0;
          schema.actualAttention[target].voluntary := true;
          schema.actualAttention[target].strength += 0.5;  // Boost
        };
      };
      case (null) { };
    };
    
    // Competition: find winner
    var maxStrength : Float = 0.0;
    var winner : Nat = 0;
    
    for (c in Iter.range(0, ATTENTION_CHANNELS - 1)) {
      let combined = schema.bottomUpSaliency[c] + schema.topDownBias[c];
      if (combined > maxStrength) {
        maxStrength := combined;
        winner := c;
      };
    };
    
    schema.actualFocus := winner;
    schema.competitionResult := winner;
    
    // Decay top-down bias
    for (c in Iter.range(0, ATTENTION_CHANNELS - 1)) {
      schema.topDownBias[c] := schema.topDownBias[c] * 0.9;
    };
  };
  
  // Update the schema (our model of attention)
  public func updateAttentionSchema(schema : AttentionSchemaState) {
    // Schema updates with a lag and simplification
    
    // Schema focus tracks actual focus with delay
    if (schema.schemaFocus != schema.actualFocus) {
      schema.schemaLag += 1;
      if (schema.schemaLag > 3) {  // Update after lag
        schema.schemaFocus := schema.actualFocus;
        schema.schemaLag := 0;
      };
    };
    
    // Schema attention is a simplified version of actual
    for (c in Iter.range(0, ATTENTION_CHANNELS - 1)) {
      let actual = schema.actualAttention[c];
      let schemaAttn = schema.schemaAttention[c];
      
      // Simplified: just copy with noise
      schemaAttn.strength := actual.strength * 0.8;  // Underestimate
      schemaAttn.voluntary := actual.voluntary;
      schemaAttn.temporal := actual.temporal + 1.0;  // Perceived as older
      
      // Spatial/featural with reduction
      for (i in Iter.range(0, ATTENTION_DIM - 1)) {
        schemaAttn.spatial[i] := actual.spatial[i] * 0.9;
        schemaAttn.featural[i] := actual.featural[i] * 0.9;
      };
    };
    
    // Compute schema error
    var errorSum : Float = 0.0;
    for (c in Iter.range(0, ATTENTION_CHANNELS - 1)) {
      let strengthDiff = Float.abs(schema.actualAttention[c].strength - schema.schemaAttention[c].strength);
      errorSum += strengthDiff;
    };
    schema.schemaError := errorSum / Float.fromInt(ATTENTION_CHANNELS);
    
    // Awareness = schema activation + self-reference
    let schemaActivation = schema.schemaAttention[schema.schemaFocus].strength;
    
    // Self-reference: is attention pointing at self?
    // Simplified: if schema is about schema
    schema.selfReference := if (schema.schemaFocus == 0) { 0.8 } else { 0.2 };
    
    schema.awarenessLevel := schemaActivation * (1.0 + schema.selfReference) / 2.0;
    
    // Update qualia (subjective quality)
    let focusedContent = schema.schemaAttention[schema.schemaFocus];
    for (i in Iter.range(0, ATTENTION_DIM - 1)) {
      schema.qualia[i] := 0.7 * schema.qualia[i] + 0.3 * focusedContent.spatial[i];
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: PREDICTIVE CONSCIOUSNESS — SURPRISE AS AWARENESS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Only surprising (unpredicted) information becomes conscious.
  // Predicted information is "explained away" and stays unconscious.
  //
  // conscious_content = signal × surprise_weight
  // surprise_weight = |actual - predicted| / precision
  //
  
  public type PredictiveConsciousnessState = {
    // Predictions
    var predictions : [var Float];       // What we expect
    var actuals : [var Float];           // What we got
    var predictionErrors : [var Float];  // Difference
    
    // Precision (confidence in predictions)
    var precision : [var Float];         // Per-channel precision
    var globalPrecision : Float;         // Overall confidence
    
    // Surprise signal
    var surpriseSignal : [var Float];    // Error / precision
    var totalSurprise : Float;           // Sum of surprise
    
    // Conscious content
    var consciousContent : [var Float];  // What reaches awareness
    var consciousnessThreshold : Float;  // Surprise threshold for awareness
    
    // Learning (update predictions)
    var learningRate : Float;
    var predictionHistory : [[var Float]];
    var historyIdx : Nat;
  };
  
  public let PREDICTION_DIM : Nat = 32;
  public let PREDICTION_HISTORY : Nat = 20;
  
  // Initialize predictive consciousness
  public func initPredictiveConsciousness() : PredictiveConsciousnessState {
    {
      var predictions = Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 0.5 });
      var actuals = Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 0.5 });
      var predictionErrors = Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 0.0 });
      var precision = Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 1.0 });
      var globalPrecision = 1.0;
      var surpriseSignal = Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 0.0 });
      var totalSurprise = 0.0;
      var consciousContent = Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 0.0 });
      var consciousnessThreshold = 0.3;
      var learningRate = 0.1;
      var predictionHistory = Array.init<[var Float]>(PREDICTION_HISTORY, func(_ : Nat) : [var Float] {
        Array.init<Float>(PREDICTION_DIM, func(_ : Nat) : Float { 0.5 })
      });
      var historyIdx = 0;
    }
  };
  
  // Process new input through predictive consciousness
  public func processPredictiveConsciousness(
    state : PredictiveConsciousnessState,
    input : [Float]
  ) : [Float] {
    // Store actual
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      state.actuals[i] := if (i < Array.size(input)) { input[i] } else { 0.0 };
    };
    
    // Compute prediction error
    var totalError : Float = 0.0;
    
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      state.predictionErrors[i] := state.actuals[i] - state.predictions[i];
      totalError += Float.abs(state.predictionErrors[i]);
    };
    
    // Compute surprise (error / precision)
    state.totalSurprise := 0.0;
    
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      let precision = Float.max(0.1, state.precision[i]);
      state.surpriseSignal[i] := Float.abs(state.predictionErrors[i]) / precision;
      state.totalSurprise += state.surpriseSignal[i];
    };
    
    state.totalSurprise /= Float.fromInt(PREDICTION_DIM);
    
    // Conscious content = actual × surprise (if above threshold)
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      if (state.surpriseSignal[i] > state.consciousnessThreshold) {
        state.consciousContent[i] := state.actuals[i] * state.surpriseSignal[i];
      } else {
        state.consciousContent[i] := 0.0;  // Predicted → unconscious
      };
    };
    
    // Update predictions (learn from error)
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      state.predictions[i] := state.predictions[i] + 
        state.learningRate * state.predictionErrors[i];
    };
    
    // Update precision (inverse variance of recent errors)
    // Store in history
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      state.predictionHistory[state.historyIdx][i] := state.predictionErrors[i];
    };
    state.historyIdx := (state.historyIdx + 1) % PREDICTION_HISTORY;
    
    // Compute precision from error variance
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      var sumSq : Float = 0.0;
      for (h in Iter.range(0, PREDICTION_HISTORY - 1)) {
        let err = state.predictionHistory[h][i];
        sumSq += err * err;
      };
      let variance = sumSq / Float.fromInt(PREDICTION_HISTORY);
      state.precision[i] := 1.0 / (variance + 0.01);
    };
    
    // Global precision
    var precSum : Float = 0.0;
    for (i in Iter.range(0, PREDICTION_DIM - 1)) {
      precSum += state.precision[i];
    };
    state.globalPrecision := precSum / Float.fromInt(PREDICTION_DIM);
    
    Array.freeze(state.consciousContent)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: COMPLETE CONSCIOUSNESS STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type ConsciousnessState = {
    // IIT
    phi : PhiState;
    system : SystemState;
    
    // GWT
    workspace : GlobalWorkspaceState;
    
    // HOT
    metaCognition : MetaCognitionState;
    
    // AST
    attentionSchema : AttentionSchemaState;
    
    // Predictive
    predictive : PredictiveConsciousnessState;
    
    // Integrated consciousness metrics
    var overallConsciousness : Float;    // Combined measure
    var consciousnessLevel : Nat;        // 0-10 scale
    var qualiaIntensity : Float;         // Subjective intensity
    var selfAwareness : Float;           // Self-model accuracy
    
    // Temporal dynamics
    var consciousnessFlux : Float;       // Rate of change
    var consciousnessMomentum : Float;   // Trend
  };
  
  // Initialize complete consciousness
  public func initConsciousness() : ConsciousnessState {
    {
      phi = initPhiState();
      system = initSystemState();
      workspace = initGlobalWorkspace();
      metaCognition = initMetaCognition();
      attentionSchema = initAttentionSchema();
      predictive = initPredictiveConsciousness();
      var overallConsciousness = 0.5;
      var consciousnessLevel = 5;
      var qualiaIntensity = 0.5;
      var selfAwareness = 0.5;
      var consciousnessFlux = 0.0;
      var consciousnessMomentum = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: THE COMPLETE CONSCIOUSNESS HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type ConsciousnessHeartbeatResult = {
    phi : Float;                         // Integrated information
    workspaceIgnited : Bool;             // Global broadcast active
    metaLevel : Nat;                     // Highest meta-cognition level
    awarenessLevel : Float;              // Attention schema awareness
    totalSurprise : Float;               // Predictive surprise
    overallConsciousness : Float;        // Combined measure
    consciousContent : [Float];          // What is conscious
  };
  
  // Run complete consciousness heartbeat
  public func runConsciousnessHeartbeat(
    state : ConsciousnessState,
    sensoryInput : [Float],
    moduleActivations : [Float],
    voluntaryAttention : ?Nat
  ) : ConsciousnessHeartbeatResult {
    let previousConsciousness = state.overallConsciousness;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Update system state from module activations
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, NUM_MODULES - 1)) {
      state.system.moduleStates[i] := if (i < Array.size(moduleActivations)) {
        moduleActivations[i]
      } else { 0.5 };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Compute Φ (integrated information)
    // ───────────────────────────────────────────────────────────────────────────
    let phi = computePhi(state.phi, state.system);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Global Workspace competition and broadcast
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, NUM_MODULES - 1)) {
      let salience = if (i < Array.size(moduleActivations)) {
        moduleActivations[i]
      } else { 0.0 };
      
      let pattern = Array.tabulate<Float>(WORKSPACE_SIZE, func(j : Nat) : Float {
        if (j < Array.size(sensoryInput)) { sensoryInput[j] * salience }
        else { 0.0 }
      });
      
      submitToWorkspace(state.workspace, i, pattern, salience);
    };
    
    let _ = runWorkspaceCompetition(state.workspace);
    let broadcastContent = broadcastContent(state.workspace);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Meta-cognition update
    // ───────────────────────────────────────────────────────────────────────────
    propagateMetaCognition(state.metaCognition, sensoryInput);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Attention Schema update
    // ───────────────────────────────────────────────────────────────────────────
    let stimuliChannels = Array.tabulate<[Float]>(ATTENTION_CHANNELS, func(c : Nat) : [Float] {
      let startIdx = c * (Array.size(sensoryInput) / ATTENTION_CHANNELS);
      let endIdx = Nat.min(startIdx + Array.size(sensoryInput) / ATTENTION_CHANNELS, Array.size(sensoryInput));
      
      Array.tabulate<Float>(ATTENTION_DIM, func(i : Nat) : Float {
        let idx = startIdx + i;
        if (idx < endIdx and idx < Array.size(sensoryInput)) { sensoryInput[idx] }
        else { 0.0 }
      })
    });
    
    updateActualAttention(state.attentionSchema, stimuliChannels, voluntaryAttention);
    updateAttentionSchema(state.attentionSchema);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Predictive consciousness
    // ───────────────────────────────────────────────────────────────────────────
    let consciousContent = processPredictiveConsciousness(state.predictive, sensoryInput);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Integrate all consciousness measures
    // ───────────────────────────────────────────────────────────────────────────
    
    // Normalize Φ to [0, 1]
    let normalizedPhi = Float.min(1.0, phi / 0.5);
    
    // Workspace ignition
    let workspaceContribution = if (state.workspace.ignited) { 0.8 } else { 0.2 };
    
    // Meta-cognition depth
    let metaContribution = state.metaCognition.metacognitiveAbility;
    
    // Attention awareness
    let awarenessContribution = state.attentionSchema.awarenessLevel;
    
    // Surprise (inverted — low surprise = high predictability = less conscious)
    let surpriseContribution = Float.min(1.0, state.predictive.totalSurprise);
    
    // Combine with weights (based on theoretical importance)
    state.overallConsciousness := 0.25 * normalizedPhi +
                                 0.25 * workspaceContribution +
                                 0.20 * metaContribution +
                                 0.15 * awarenessContribution +
                                 0.15 * surpriseContribution;
    
    // Consciousness level (0-10 scale)
    state.consciousnessLevel := Nat.min(10, Int.abs(Float.toInt(state.overallConsciousness * 10.0)));
    
    // Qualia intensity
    var qualiaSum : Float = 0.0;
    for (q in state.attentionSchema.qualia.vals()) {
      qualiaSum += Float.abs(q);
    };
    state.qualiaIntensity := qualiaSum / Float.fromInt(ATTENTION_DIM);
    
    // Self-awareness
    state.selfAwareness := state.metaCognition.selfModelAccuracy * state.attentionSchema.selfReference;
    
    // Temporal dynamics
    state.consciousnessFlux := state.overallConsciousness - previousConsciousness;
    state.consciousnessMomentum := 0.9 * state.consciousnessMomentum + 0.1 * state.consciousnessFlux;
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return result
    // ───────────────────────────────────────────────────────────────────────────
    {
      phi = phi;
      workspaceIgnited = state.workspace.ignited;
      metaLevel = state.metaCognition.highestActiveLevel;
      awarenessLevel = state.attentionSchema.awarenessLevel;
      totalSurprise = state.predictive.totalSurprise;
      overallConsciousness = state.overallConsciousness;
      consciousContent = consciousContent;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    let z : Float = (x - 1.0) / (x + 1.0);
    let zSquared : Float = z * z;
    var result : Float = 0.0;
    var term : Float = z;
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSquared;
    };
    2.0 * result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };

};
