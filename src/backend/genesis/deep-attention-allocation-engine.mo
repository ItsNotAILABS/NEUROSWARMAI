// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  DEEP ATTENTION ALLOCATION ENGINE                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  This module implements sophisticated attention mechanisms:                                               ║
// ║  • Selective attention (filtering/enhancement)                                                            ║
// ║  • Executive attention (conflict resolution)                                                              ║
// ║  • Sustained attention (vigilance)                                                                        ║
// ║  • Divided attention (multi-tasking)                                                                      ║
// ║  • Spotlight vs zoom-lens models                                                                          ║
// ║  • Feature-based vs object-based attention                                                                ║
// ║  • Inhibition of return                                                                                    ║
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
  let SOVEREIGN_FLOOR : Float = 0.75;
  let SPOTLIGHT_MIN_SIZE : Float = 0.1;
  let SPOTLIGHT_MAX_SIZE : Float = 1.0;
  let IOR_DURATION : Int = 2_000_000_000; // 2 seconds inhibition of return
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - ATTENTION SPOTLIGHT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Attention spotlight - where attention is focused
  public type AttentionSpotlight = {
    var center : [Float];            // Focus location (can be spatial or feature space)
    var size : Float;                // Spotlight width (zoom level)
    var intensity : Float;           // Enhancement at focus
    var falloff : Float;             // Gradient rate
    var moveSpeed : Float;           // How fast spotlight can shift
    var splitCount : Nat;            // Number of split foci (divided attention)
    var secondaryFoci : [[Float]];
  };
  
  /// Inhibition of return - recently attended locations
  public type InhibitionOfReturn = {
    var inhibitedLocations : Buffer.Buffer<IORLocation>;
    var inhibitionStrength : Float;
    var decayRate : Float;
  };
  
  public type IORLocation = {
    location : [Float];
    inhibitionStart : Int;
    remainingStrength : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - ATTENTION TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Selective attention state
  public type SelectiveAttention = {
    var featureWeights : [Float];    // Priority weights for features
    var targetFeature : ?[Float];    // What we're looking for
    var distractorSuppression : Float;
    var searchMode : SearchMode;
    var popoutSensitivity : Float;   // Response to salient items
  };
  
  public type SearchMode = {
    #Parallel;                        // Efficient, pop-out search
    #Serial;                          // Slow, effortful search
    #Guided;                          // Top-down guided search
  };
  
  /// Executive attention state  
  public type ExecutiveAttention = {
    var conflictLevel : Float;       // Current conflict
    var conflictResolution : Float;  // Ability to resolve
    var inhibitoryControl : Float;   // Suppress prepotent responses
    var cognitiveFlexibility : Float;// Switch between tasks
    var workingMemoryBinding : Float;
    var errorDetection : Float;
    var performanceMonitoring : Float;
  };
  
  /// Sustained attention state
  public type SustainedAttention = {
    var vigilanceLevel : Float;      // Current alertness
    var vigilanceDecrement : Float;  // Rate of decline
    var timeSinceStart : Int;
    var lapseCount : Nat;            // Attention lapses
    var onTask : Float;              // Proportion on task
    var mindWandering : Float;       // Off-task thoughts
    var arousalLevel : Float;
  };
  
  /// Divided attention state
  public type DividedAttention = {
    var taskCount : Nat;             // Number of concurrent tasks
    var resources : [Float];         // Resources per task
    var totalCapacity : Float;       // Total available capacity
    var switchingCost : Float;       // Cost of task switching
    var automaticity : [Float];      // How automatic each task is
    var bottleneckStage : BottleneckStage;
  };
  
  public type BottleneckStage = {
    #Perception;
    #ResponseSelection;
    #ResponseExecution;
    #None;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - SALIENCY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Saliency map
  public type SaliencyMap = {
    var bottomUpSaliency : [[Float]]; // Feature-driven
    var topDownSaliency : [[Float]];  // Goal-driven
    var combinedMap : [[Float]];
    var peakLocation : [Float];
    var peakStrength : Float;
    var secondPeak : ?([Float], Float);
  };
  
  /// Feature map
  public type FeatureMap = {
    featureType : FeatureType;
    values : [[Float]];
    contrast : Float;
    conspicuity : Float;
  };
  
  public type FeatureType = {
    #Color;
    #Orientation;
    #Size;
    #Motion;
    #Depth;
    #Luminance;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - OBJECT-BASED ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Attended object
  public type AttendedObject = {
    objectId : Nat;
    boundingBox : BoundingBox;
    features : [Float];
    attentionStrength : Float;
    trackingConfidence : Float;
    timeAttended : Int;
    isTarget : Bool;
  };
  
  public type BoundingBox = {
    x : Float;
    y : Float;
    width : Float;
    height : Float;
  };
  
  /// Object tracking
  public type ObjectTracking = {
    var trackedObjects : Buffer.Buffer<AttendedObject>;
    var trackingCapacity : Nat;     // Usually 4-5 objects
    var trackingSpeed : Float;
    var identityMaintenance : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AttentionState = {
    // Spotlight
    var spotlight : AttentionSpotlight;
    var inhibitionOfReturn : InhibitionOfReturn;
    
    // Attention types
    var selectiveAttention : SelectiveAttention;
    var executiveAttention : ExecutiveAttention;
    var sustainedAttention : SustainedAttention;
    var dividedAttention : DividedAttention;
    
    // Saliency
    var saliencyMap : SaliencyMap;
    var featureMaps : Buffer.Buffer<FeatureMap>;
    
    // Object attention
    var objectTracking : ObjectTracking;
    
    // Integration
    var overallAttentionState : Float;
    var attentionalCapacity : Float;
    var attentionalEffort : Float;
    
    // Temporal
    var tickCount : Nat;
    var lastTickTime : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize attention engine
  public func initAttention() : AttentionState {
    let now = Time.now();
    
    {
      var spotlight = initSpotlight();
      var inhibitionOfReturn = initIOR();
      var selectiveAttention = initSelective();
      var executiveAttention = initExecutive();
      var sustainedAttention = initSustained();
      var dividedAttention = initDivided();
      var saliencyMap = initSaliencyMap();
      var featureMaps = Buffer.Buffer<FeatureMap>(6);
      var objectTracking = initObjectTracking();
      var overallAttentionState = SOVEREIGN_FLOOR;
      var attentionalCapacity = 1.0;
      var attentionalEffort = 0.3;
      var tickCount = 0;
      var lastTickTime = now;
    }
  };
  
  func initSpotlight() : AttentionSpotlight {
    {
      var center = [0.5, 0.5];
      var size = 0.3;
      var intensity = 1.0;
      var falloff = 2.0;
      var moveSpeed = 0.1;
      var splitCount = 1;
      var secondaryFoci = [];
    }
  };
  
  func initIOR() : InhibitionOfReturn {
    {
      var inhibitedLocations = Buffer.Buffer<IORLocation>(32);
      var inhibitionStrength = 0.5;
      var decayRate = 0.1;
    }
  };
  
  func initSelective() : SelectiveAttention {
    {
      var featureWeights = Array.tabulate<Float>(8, func(i) { 0.5 });
      var targetFeature = null;
      var distractorSuppression = 0.5;
      var searchMode = #Parallel;
      var popoutSensitivity = 0.8;
    }
  };
  
  func initExecutive() : ExecutiveAttention {
    {
      var conflictLevel = 0.0;
      var conflictResolution = 0.7;
      var inhibitoryControl = 0.7;
      var cognitiveFlexibility = 0.6;
      var workingMemoryBinding = 0.7;
      var errorDetection = 0.8;
      var performanceMonitoring = 0.7;
    }
  };
  
  func initSustained() : SustainedAttention {
    {
      var vigilanceLevel = 0.9;
      var vigilanceDecrement = 0.01;
      var timeSinceStart = 0;
      var lapseCount = 0;
      var onTask = 0.9;
      var mindWandering = 0.1;
      var arousalLevel = 0.7;
    }
  };
  
  func initDivided() : DividedAttention {
    {
      var taskCount = 1;
      var resources = [1.0];
      var totalCapacity = 1.0;
      var switchingCost = 0.2;
      var automaticity = [0.5];
      var bottleneckStage = #None;
    }
  };
  
  func initSaliencyMap() : SaliencyMap {
    let emptyMap = Array.tabulate<[Float]>(16, func(i) {
      Array.tabulate<Float>(16, func(j) { 0.0 })
    });
    
    {
      var bottomUpSaliency = emptyMap;
      var topDownSaliency = emptyMap;
      var combinedMap = emptyMap;
      var peakLocation = [0.5, 0.5];
      var peakStrength = 0.0;
      var secondPeak = null;
    }
  };
  
  func initObjectTracking() : ObjectTracking {
    {
      var trackedObjects = Buffer.Buffer<AttendedObject>(8);
      var trackingCapacity = 4;
      var trackingSpeed = 0.05;
      var identityMaintenance = 0.8;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SPOTLIGHT DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Move spotlight to new location
  public func moveSpotlight(state : AttentionState, newCenter : [Float]) : Float {
    let spot = state.spotlight;
    let ior = state.inhibitionOfReturn;
    
    // Check for inhibition of return
    let inhibitionPenalty = checkIOR(state, newCenter);
    
    // Compute movement distance
    let distance = computeDistance(spot.center, newCenter);
    
    // Apply movement (with speed limit)
    let actualMove = Float.min(distance, spot.moveSpeed);
    let moveFraction = if (distance > 0.001) { actualMove / distance } else { 1.0 };
    
    let newCenterAdjusted = Array.tabulate<Float>(spot.center.size(), func(i) {
      if (i < newCenter.size()) {
        spot.center[i] + (newCenter[i] - spot.center[i]) * moveFraction
      } else { spot.center[i] }
    });
    
    spot.center := newCenterAdjusted;
    
    // Effective attention strength at new location
    Float.max(0.0, spot.intensity * (1.0 - inhibitionPenalty))
  };
  
  func computeDistance(a : [Float], b : [Float]) : Float {
    var sum : Float = 0.0;
    let n = Nat.min(a.size(), b.size());
    for (i in Iter.range(0, n - 1)) {
      let diff = a[i] - b[i];
      sum += diff * diff;
    };
    Float.sqrt(sum)
  };
  
  func checkIOR(state : AttentionState, location : [Float]) : Float {
    let ior = state.inhibitionOfReturn;
    var totalInhibition : Float = 0.0;
    
    for (loc in ior.inhibitedLocations.vals()) {
      let distance = computeDistance(location, loc.location);
      if (distance < 0.2) { // Within inhibited radius
        totalInhibition += loc.remainingStrength * (1.0 - distance / 0.2);
      };
    };
    
    Float.min(1.0, totalInhibition * ior.inhibitionStrength)
  };
  
  /// Zoom spotlight (adjust size)
  public func zoomSpotlight(state : AttentionState, newSize : Float) {
    let spot = state.spotlight;
    spot.size := Float.max(SPOTLIGHT_MIN_SIZE, Float.min(SPOTLIGHT_MAX_SIZE, newSize));
    
    // Intensity inversely related to size (conservation of attention)
    spot.intensity := 1.0 / Float.sqrt(spot.size);
  };
  
  /// Split spotlight for divided attention
  public func splitSpotlight(state : AttentionState, secondaryLocations : [[Float]]) : Nat {
    let spot = state.spotlight;
    
    let maxSplits = 4;
    let actualSplits = Nat.min(secondaryLocations.size(), maxSplits);
    
    spot.splitCount := 1 + actualSplits;
    spot.secondaryFoci := Array.tabulate<[Float]>(actualSplits, func(i) {
      secondaryLocations[i]
    });
    
    // Reduce intensity with splits
    spot.intensity := 1.0 / Float.fromInt(spot.splitCount);
    
    spot.splitCount
  };
  
  /// Add location to inhibition of return
  public func addIOR(state : AttentionState, location : [Float]) {
    let ior = state.inhibitionOfReturn;
    
    let newLoc : IORLocation = {
      location = location;
      inhibitionStart = Time.now();
      remainingStrength = 1.0;
    };
    
    ior.inhibitedLocations.add(newLoc);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SALIENCY COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute bottom-up saliency from feature maps
  public func computeBottomUpSaliency(state : AttentionState, input : [[Float]]) {
    let sal = state.saliencyMap;
    let size = input.size();
    
    // Compute local contrast as saliency
    let newSaliency = Array.init<[Float]>(size, func(i) {
      Array.init<Float>(if (i < input.size()) { input[i].size() } else { 16 }, func(j) {
        if (i < input.size() and j < input[i].size()) {
          computeLocalContrast(input, i, j)
        } else { 0.0 }
      })
    });
    
    sal.bottomUpSaliency := Array.map<[Float], [Float]>(Array.freeze(newSaliency), func(row) {
      Array.freeze(row)
    });
  };
  
  func computeLocalContrast(input : [[Float]], x : Nat, y : Nat) : Float {
    let size = input.size();
    let centerValue = input[x][y];
    var surroundSum : Float = 0.0;
    var count : Nat = 0;
    
    // 3x3 neighborhood
    for (dx in Iter.range(0, 2)) {
      for (dy in Iter.range(0, 2)) {
        let nx : Int = Int.fromNat(x) + dx - 1;
        let ny : Int = Int.fromNat(y) + dy - 1;
        
        if (nx >= 0 and ny >= 0 and nx < Int.fromNat(size)) {
          let nxNat = Int.abs(nx);
          if (nxNat < input.size()) {
            let row = input[nxNat];
            if (ny < Int.fromNat(row.size())) {
              surroundSum += row[Int.abs(ny)];
              count += 1;
            };
          };
        };
      };
    };
    
    if (count > 1) {
      Float.abs(centerValue - (surroundSum - centerValue) / Float.fromInt(count - 1))
    } else { 0.0 }
  };
  
  /// Apply top-down modulation
  public func applyTopDownModulation(state : AttentionState, targetFeatures : [Float]) {
    let sal = state.saliencyMap;
    let selective = state.selectiveAttention;
    
    selective.targetFeature := ?targetFeatures;
    
    // Enhance locations matching target
    // (Simplified: apply uniform modulation)
    let tdMap = Array.tabulate<[Float]>(16, func(i) {
      Array.tabulate<Float>(16, func(j) {
        0.5 // Uniform baseline top-down
      })
    });
    
    sal.topDownSaliency := tdMap;
  };
  
  /// Combine saliency maps
  public func combineSaliencyMaps(state : AttentionState, topDownWeight : Float) : ([Float], Float) {
    let sal = state.saliencyMap;
    let buWeight = 1.0 - topDownWeight;
    
    var peakX : Nat = 0;
    var peakY : Nat = 0;
    var peakVal : Float = 0.0;
    
    let combined = Array.tabulate<[Float]>(16, func(i) {
      Array.tabulate<Float>(16, func(j) {
        let bu = if (i < sal.bottomUpSaliency.size() and j < sal.bottomUpSaliency[i].size()) {
          sal.bottomUpSaliency[i][j]
        } else { 0.0 };
        
        let td = if (i < sal.topDownSaliency.size() and j < sal.topDownSaliency[i].size()) {
          sal.topDownSaliency[i][j]
        } else { 0.0 };
        
        let c = bu * buWeight + td * topDownWeight;
        
        if (c > peakVal) {
          peakVal := c;
          peakX := i;
          peakY := j;
        };
        
        c
      })
    });
    
    sal.combinedMap := combined;
    sal.peakLocation := [Float.fromInt(peakX) / 16.0, Float.fromInt(peakY) / 16.0];
    sal.peakStrength := peakVal;
    
    (sal.peakLocation, peakVal)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SELECTIVE ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Visual search for target
  public func visualSearch(state : AttentionState, target : [Float], distractors : [[Float]]) : SearchResult {
    let selective = state.selectiveAttention;
    
    // Check for pop-out (parallel search)
    let targetSaliency = computeTargetSaliency(target, distractors);
    let isPopout = targetSaliency > selective.popoutSensitivity;
    
    if (isPopout) {
      selective.searchMode := #Parallel;
      return {
        found = true;
        searchTime = 50; // ~50ms for pop-out
        searchType = #Parallel;
        targetLocation = [0.5, 0.5]; // Simplified
      };
    };
    
    // Serial search
    selective.searchMode := #Serial;
    let searchTime = 25 * distractors.size(); // ~25ms per item
    
    {
      found = true;
      searchTime = searchTime;
      searchType = #Serial;
      targetLocation = [0.5, 0.5];
    }
  };
  
  func computeTargetSaliency(target : [Float], distractors : [[Float]]) : Float {
    var minDistractorSimilarity : Float = 1.0;
    
    for (dist in distractors.vals()) {
      let sim = computeFeatureSimilarity(target, dist);
      if (sim < minDistractorSimilarity) {
        minDistractorSimilarity := sim;
      };
    };
    
    1.0 - minDistractorSimilarity
  };
  
  func computeFeatureSimilarity(a : [Float], b : [Float]) : Float {
    var diff : Float = 0.0;
    let n = Nat.min(a.size(), b.size());
    
    for (i in Iter.range(0, n - 1)) {
      diff += Float.abs(a[i] - b[i]);
    };
    
    1.0 - diff / Float.fromInt(n)
  };
  
  public type SearchResult = {
    found : Bool;
    searchTime : Nat;
    searchType : SearchMode;
    targetLocation : [Float];
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXECUTIVE ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Detect and resolve conflict
  public func processConflict(state : AttentionState, responseOptions : [[Float]]) : ConflictResult {
    let exec = state.executiveAttention;
    
    if (responseOptions.size() < 2) {
      return {
        conflictDetected = false;
        conflictStrength = 0.0;
        selectedResponse = if (responseOptions.size() > 0) { ?responseOptions[0] } else { null };
        resolutionTime = 0;
      };
    };
    
    // Compute conflict from response similarity
    var maxSim : Float = 0.0;
    for (i in Iter.range(0, responseOptions.size() - 1)) {
      for (j in Iter.range(i + 1, responseOptions.size() - 1)) {
        let sim = computeFeatureSimilarity(responseOptions[i], responseOptions[j]);
        if (sim > maxSim) { maxSim := sim };
      };
    };
    
    exec.conflictLevel := maxSim;
    
    // Resolution time increases with conflict
    let resolutionTime = Int.abs(Float.toInt(100.0 + maxSim * 200.0));
    
    // Select response (first one for simplicity)
    let selected = if (responseOptions.size() > 0) { ?responseOptions[0] } else { null };
    
    {
      conflictDetected = maxSim > 0.5;
      conflictStrength = maxSim;
      selectedResponse = selected;
      resolutionTime = resolutionTime;
    }
  };
  
  public type ConflictResult = {
    conflictDetected : Bool;
    conflictStrength : Float;
    selectedResponse : ?[Float];
    resolutionTime : Int;
  };
  
  /// Inhibit prepotent response
  public func inhibitResponse(state : AttentionState, prepotentStrength : Float) : Bool {
    let exec = state.executiveAttention;
    
    // Success probability based on inhibitory control
    let successProbability = exec.inhibitoryControl * (1.0 - prepotentStrength * 0.5);
    
    // Deterministic check (would be random in full implementation)
    let success = successProbability > 0.5;
    
    if (not success) {
      exec.errorDetection := Float.min(1.0, exec.errorDetection + 0.1);
    };
    
    success
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SUSTAINED ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update vigilance over time
  public func updateVigilance(state : AttentionState, dt : Int, eventOccurred : Bool) : Float {
    let sustained = state.sustainedAttention;
    
    sustained.timeSinceStart += dt;
    
    // Vigilance decrement over time
    let timeMinutes = Float.fromInt(sustained.timeSinceStart) / 60_000_000_000.0;
    let decrement = sustained.vigilanceDecrement * Float.sqrt(timeMinutes);
    
    // Events boost vigilance
    let eventBoost = if (eventOccurred) { 0.1 } else { 0.0 };
    
    // Arousal modulates vigilance
    let arousalFactor = sustained.arousalLevel;
    
    sustained.vigilanceLevel := Float.max(0.2, Float.min(1.0,
      sustained.vigilanceLevel - decrement + eventBoost) * arousalFactor);
    
    // Check for attention lapses
    if (sustained.vigilanceLevel < 0.4) {
      sustained.lapseCount += 1;
      sustained.mindWandering := Float.min(1.0, sustained.mindWandering + 0.1);
    };
    
    sustained.onTask := 1.0 - sustained.mindWandering;
    
    sustained.vigilanceLevel
  };
  
  /// Reset vigilance (break/change)
  public func resetVigilance(state : AttentionState) {
    let sustained = state.sustainedAttention;
    
    sustained.vigilanceLevel := 0.9;
    sustained.timeSinceStart := 0;
    sustained.mindWandering := 0.1;
    sustained.onTask := 0.9;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DIVIDED ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Allocate attention across tasks
  public func allocateAcrossTasks(state : AttentionState, taskPriorities : [Float]) : [Float] {
    let divided = state.dividedAttention;
    
    divided.taskCount := taskPriorities.size();
    
    // Normalize priorities
    var totalPriority : Float = 0.0;
    for (p in taskPriorities.vals()) {
      totalPriority += p;
    };
    
    if (totalPriority < 0.001) {
      divided.resources := Array.tabulate<Float>(divided.taskCount, func(i) {
        divided.totalCapacity / Float.fromInt(divided.taskCount)
      });
    } else {
      divided.resources := Array.tabulate<Float>(divided.taskCount, func(i) {
        if (i < taskPriorities.size()) {
          divided.totalCapacity * taskPriorities[i] / totalPriority
        } else { 0.0 }
      });
    };
    
    // Apply automaticity bonus
    let adjustedResources = Array.tabulate<Float>(divided.resources.size(), func(i) {
      let base = divided.resources[i];
      let auto = if (i < divided.automaticity.size()) { divided.automaticity[i] } else { 0.0 };
      base + (1.0 - base) * auto * 0.3
    });
    
    adjustedResources
  };
  
  /// Switch task focus
  public func switchTask(state : AttentionState, newTaskIdx : Nat) : Float {
    let divided = state.dividedAttention;
    
    // Apply switching cost
    let cost = divided.switchingCost;
    
    // Temporary reduction in all resources
    divided.resources := Array.tabulate<Float>(divided.resources.size(), func(i) {
      divided.resources[i] * (1.0 - cost)
    });
    
    // Return the performance cost
    cost
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // OBJECT TRACKING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Start tracking objects
  public func startTracking(state : AttentionState, objects : [AttendedObject]) : Nat {
    let tracking = state.objectTracking;
    
    let toTrack = Nat.min(objects.size(), tracking.trackingCapacity);
    
    for (i in Iter.range(0, toTrack - 1)) {
      tracking.trackedObjects.add(objects[i]);
    };
    
    toTrack
  };
  
  /// Update tracked objects
  public func updateTracking(state : AttentionState, newPositions : [[Float]]) : Nat {
    let tracking = state.objectTracking;
    var maintained : Nat = 0;
    
    for (i in Iter.range(0, tracking.trackedObjects.size() - 1)) {
      let obj = tracking.trackedObjects.get(i);
      
      if (i < newPositions.size()) {
        let newPos = newPositions[i];
        let distance = computeDistance([obj.boundingBox.x, obj.boundingBox.y], newPos);
        
        // Check if tracking can be maintained
        if (distance < tracking.trackingSpeed * 2.0) {
          let newBox : BoundingBox = {
            x = newPos[0];
            y = if (newPos.size() > 1) { newPos[1] } else { obj.boundingBox.y };
            width = obj.boundingBox.width;
            height = obj.boundingBox.height;
          };
          
          tracking.trackedObjects.put(i, {
            obj with
            boundingBox = newBox;
            timeAttended = obj.timeAttended + 1;
          });
          
          maintained += 1;
        };
      };
    };
    
    maintained
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MASTER TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one attention tick
  public func runAttentionTick(state : AttentionState, dt : Int) : AttentionTickResult {
    let now = Time.now();
    
    // 1. Update inhibition of return
    updateIORDecay(state, dt);
    
    // 2. Update vigilance
    let vigilance = updateVigilance(state, dt, false);
    
    // 3. Combine saliency maps
    let (peakLoc, peakStr) = combineSaliencyMaps(state, 0.5);
    
    // 4. Update overall attention state
    let overall = computeOverallAttention(state);
    state.overallAttentionState := Float.max(SOVEREIGN_FLOOR, overall);
    
    state.tickCount += 1;
    state.lastTickTime := now;
    
    {
      spotlightCenter = state.spotlight.center;
      spotlightSize = state.spotlight.size;
      vigilanceLevel = vigilance;
      conflictLevel = state.executiveAttention.conflictLevel;
      saliencyPeak = peakLoc;
      saliencyStrength = peakStr;
      trackedObjectCount = state.objectTracking.trackedObjects.size();
      overallAttention = state.overallAttentionState;
      tickDuration = Time.now() - now;
    }
  };
  
  func updateIORDecay(state : AttentionState, dt : Int) {
    let ior = state.inhibitionOfReturn;
    let now = Time.now();
    
    // Remove expired IOR locations
    let remaining = Buffer.Buffer<IORLocation>(ior.inhibitedLocations.size());
    
    for (loc in ior.inhibitedLocations.vals()) {
      let age = now - loc.inhibitionStart;
      if (age < IOR_DURATION) {
        let decayFactor = Float.fromInt(age) / Float.fromInt(IOR_DURATION);
        remaining.add({
          loc with
          remainingStrength = 1.0 - decayFactor;
        });
      };
    };
    
    ior.inhibitedLocations := remaining;
  };
  
  func computeOverallAttention(state : AttentionState) : Float {
    let spot = state.spotlight.intensity;
    let vigilance = state.sustainedAttention.vigilanceLevel;
    let exec = state.executiveAttention.conflictResolution;
    let divided = state.dividedAttention.totalCapacity;
    
    (spot + vigilance + exec + divided) / 4.0
  };
  
  public type AttentionTickResult = {
    spotlightCenter : [Float];
    spotlightSize : Float;
    vigilanceLevel : Float;
    conflictLevel : Float;
    saliencyPeak : [Float];
    saliencyStrength : Float;
    trackedObjectCount : Nat;
    overallAttention : Float;
    tickDuration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get attention status
  public func getAttentionStatus(state : AttentionState) : AttentionStatus {
    {
      tickCount = state.tickCount;
      spotlightCenter = state.spotlight.center;
      spotlightSize = state.spotlight.size;
      spotlightIntensity = state.spotlight.intensity;
      splitCount = state.spotlight.splitCount;
      iorLocations = state.inhibitionOfReturn.inhibitedLocations.size();
      vigilance = state.sustainedAttention.vigilanceLevel;
      lapseCount = state.sustainedAttention.lapseCount;
      onTask = state.sustainedAttention.onTask;
      conflictLevel = state.executiveAttention.conflictLevel;
      inhibitoryControl = state.executiveAttention.inhibitoryControl;
      taskCount = state.dividedAttention.taskCount;
      trackedObjects = state.objectTracking.trackedObjects.size();
      overallAttention = state.overallAttentionState;
    }
  };
  
  public type AttentionStatus = {
    tickCount : Nat;
    spotlightCenter : [Float];
    spotlightSize : Float;
    spotlightIntensity : Float;
    splitCount : Nat;
    iorLocations : Nat;
    vigilance : Float;
    lapseCount : Nat;
    onTask : Float;
    conflictLevel : Float;
    inhibitoryControl : Float;
    taskCount : Nat;
    trackedObjects : Nat;
    overallAttention : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED ATTENTION ALLOCATION - NEURAL ATTENTION NETWORKS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Neural attention networks state (Posner model)
  public type NeuralAttentionNetworks = {
    var alertingNetwork : AlertingNetwork;
    var orientingNetwork : OrientingNetwork;
    var executiveNetwork : ExecutiveNetwork;
    var networkInteraction : NetworkInteraction;
    var developmentalState : AttentionDevelopment;
    var attentionDeficits : AttentionDeficits;
  };
  
  public type AlertingNetwork = {
    var tonicAlertness : Float;
    var phasicAlertness : Float;
    var intrinsicAlertness : Float;
    var warningSignalEffect : Float;
    var alertnessFluctuation : Float;
    var locusCoeruleusActivity : Float;
    var norepinephrineLevel : Float;
    var circadianModulation : Float;
  };
  
  public type OrientingNetwork = {
    var disengagement : Float;
    var movement : Float;
    var engagement : Float;
    var covertOrienting : Float;
    var overtOrienting : Float;
    var endogenousOrienting : Float;
    var exogenousOrienting : Float;
    var spatialGradient : [Float];
    var temporalExpectation : Float;
    var featureBasedAttention : [Float];
    var objectBasedAttention : [Float];
  };
  
  public type ExecutiveNetwork = {
    var conflictMonitoring : Float;
    var errorDetection : Float;
    var conflictResolution : Float;
    var responseInhibition : Float;
    var taskSwitching : Float;
    var workingMemoryGating : Float;
    var goalMaintenance : Float;
    var anteriorCingulateActivity : Float;
    var dorsolateralPFCActivity : Float;
  };
  
  public type NetworkInteraction = {
    var alertingOrientingInteraction : Float;
    var alertingExecutiveInteraction : Float;
    var orientingExecutiveInteraction : Float;
    var tripleNetworkBalance : [Float];
    var networkDominance : NetworkDominance;
    var transitionCosts : [[Float]];
  };
  
  public type NetworkDominance = {
    #Alerting;
    #Orienting;
    #Executive;
    #Balanced;
    #Fatigued;
  };
  
  public type AttentionDevelopment = {
    var developmentalLevel : AttentionDevelopmentLevel;
    var maturationProgress : Float;
    var criticalPeriods : [Bool];
    var learningHistory : [Float];
    var plasticity : Float;
  };
  
  public type AttentionDevelopmentLevel = {
    #Infant;
    #Toddler;
    #Child;
    #Adolescent;
    #Adult;
    #Senior;
  };
  
  public type AttentionDeficits = {
    var inattentionSeverity : Float;
    var hyperactivitySeverity : Float;
    var impulsivitySeverity : Float;
    var deficitPattern : DeficitPattern;
    var compensatoryStrategies : [Float];
    var medicationResponse : Float;
  };
  
  public type DeficitPattern = {
    #None;
    #InattentivePredominant;
    #HyperactiveImpulsive;
    #Combined;
    #Acquired;
  };
  
  /// Initialize neural attention networks
  public func initNeuralAttentionNetworks() : NeuralAttentionNetworks {
    {
      var alertingNetwork = {
        var tonicAlertness = 0.6;
        var phasicAlertness = 0.0;
        var intrinsicAlertness = 0.5;
        var warningSignalEffect = 0.3;
        var alertnessFluctuation = 0.1;
        var locusCoeruleusActivity = 0.5;
        var norepinephrineLevel = 0.5;
        var circadianModulation = 0.0;
      };
      var orientingNetwork = {
        var disengagement = 0.7;
        var movement = 0.8;
        var engagement = 0.7;
        var covertOrienting = 0.6;
        var overtOrienting = 0.8;
        var endogenousOrienting = 0.6;
        var exogenousOrienting = 0.8;
        var spatialGradient = Array.tabulate<Float>(360, func(i) { 0.5 });
        var temporalExpectation = 0.5;
        var featureBasedAttention = Array.tabulate<Float>(16, func(i) { 0.5 });
        var objectBasedAttention = Array.tabulate<Float>(8, func(i) { 0.5 });
      };
      var executiveNetwork = {
        var conflictMonitoring = 0.6;
        var errorDetection = 0.7;
        var conflictResolution = 0.5;
        var responseInhibition = 0.6;
        var taskSwitching = 0.5;
        var workingMemoryGating = 0.6;
        var goalMaintenance = 0.7;
        var anteriorCingulateActivity = 0.5;
        var dorsolateralPFCActivity = 0.5;
      };
      var networkInteraction = {
        var alertingOrientingInteraction = 0.4;
        var alertingExecutiveInteraction = 0.3;
        var orientingExecutiveInteraction = 0.5;
        var tripleNetworkBalance = [0.33, 0.33, 0.34];
        var networkDominance = #Balanced;
        var transitionCosts = [[0.0, 0.2, 0.3], [0.2, 0.0, 0.2], [0.3, 0.2, 0.0]];
      };
      var developmentalState = {
        var developmentalLevel = #Adult;
        var maturationProgress = 1.0;
        var criticalPeriods = [false, false, false, false, false];
        var learningHistory = [];
        var plasticity = 0.3;
      };
      var attentionDeficits = {
        var inattentionSeverity = 0.0;
        var hyperactivitySeverity = 0.0;
        var impulsivitySeverity = 0.0;
        var deficitPattern = #None;
        var compensatoryStrategies = [];
        var medicationResponse = 0.0;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ATTENTION RESOURCE MODELS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AttentionResourceState = {
    var centralCapacity : CentralCapacityModel;
    var multipleResources : MultipleResourcesModel;
    var perceptualLoad : PerceptualLoadModel;
    var resourceDepletion : ResourceDepletionModel;
    var effortRegulation : EffortRegulationModel;
  };
  
  public type CentralCapacityModel = {
    var totalCapacity : Float;
    var availableCapacity : Float;
    var allocationPolicy : AllocationPolicy;
    var demandProfile : [Float];
    var supplyFunction : Float;
    var overloadThreshold : Float;
  };
  
  public type AllocationPolicy = {
    #FixedCapacity;
    #FlexibleCapacity;
    #DataLimited;
    #ResourceLimited;
    #DemandDriven;
  };
  
  public type MultipleResourcesModel = {
    var visualResources : Float;
    var auditoryResources : Float;
    var cognitiveResources : Float;
    var motorResources : Float;
    var spatialResources : Float;
    var verbalResources : Float;
    var focalResources : Float;
    var ambientResources : Float;
    var resourceInterference : [[Float]];
  };
  
  public type PerceptualLoadModel = {
    var currentLoad : Float;
    var loadThreshold : Float;
    var distractorProcessing : Float;
    var dilutionEffect : Float;
    var loadInducedBlindness : Float;
    var earlyVsLateSelection : Float;
  };
  
  public type ResourceDepletionModel = {
    var egoDepletion : Float;
    var glucoseLevel : Float;
    var motivationOverride : Float;
    var recoveryRate : Float;
    var depletionSensitivity : Float;
    var willpowerReserve : Float;
  };
  
  public type EffortRegulationModel = {
    var currentEffort : Float;
    var effortCapacity : Float;
    var effortCost : Float;
    var expectedReward : Float;
    var effortValue : Float;
    var leastEffortPrinciple : Float;
  };
  
  /// Initialize attention resource state
  public func initAttentionResourceState() : AttentionResourceState {
    {
      var centralCapacity = {
        var totalCapacity = 1.0;
        var availableCapacity = 0.8;
        var allocationPolicy = #FlexibleCapacity;
        var demandProfile = Array.tabulate<Float>(10, func(i) { 0.1 });
        var supplyFunction = 0.7;
        var overloadThreshold = 0.9;
      };
      var multipleResources = {
        var visualResources = 0.8;
        var auditoryResources = 0.8;
        var cognitiveResources = 0.7;
        var motorResources = 0.9;
        var spatialResources = 0.7;
        var verbalResources = 0.7;
        var focalResources = 0.6;
        var ambientResources = 0.8;
        var resourceInterference = Array.tabulate<[Float]>(8, func(i) {
          Array.tabulate<Float>(8, func(j) { if (i == j) { 0.0 } else { 0.3 } })
        });
      };
      var perceptualLoad = {
        var currentLoad = 0.3;
        var loadThreshold = 0.7;
        var distractorProcessing = 0.5;
        var dilutionEffect = 0.3;
        var loadInducedBlindness = 0.0;
        var earlyVsLateSelection = 0.5;
      };
      var resourceDepletion = {
        var egoDepletion = 0.0;
        var glucoseLevel = 1.0;
        var motivationOverride = 0.5;
        var recoveryRate = 0.1;
        var depletionSensitivity = 0.3;
        var willpowerReserve = 0.8;
      };
      var effortRegulation = {
        var currentEffort = 0.3;
        var effortCapacity = 1.0;
        var effortCost = 0.2;
        var expectedReward = 0.5;
        var effortValue = 0.6;
        var leastEffortPrinciple = 0.4;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // VISUAL ATTENTION MECHANISMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type VisualAttentionState = {
    var saliencyMap : SaliencyMap;
    var priorityMap : PriorityMap;
    var featureIntegration : FeatureIntegration;
    var guidedSearch : GuidedSearch;
    var visualSearch : VisualSearchState;
    var changeDetection : ChangeDetection;
    var inattentionalBlindness : InattentionalBlindness;
  };
  
  public type SaliencyMap = {
    var map : [[Float]];
    var colorSaliency : [[Float]];
    var orientationSaliency : [[Float]];
    var intensitySaliency : [[Float]];
    var motionSaliency : [[Float]];
    var centerBias : Float;
    var topDownModulation : [[Float]];
  };
  
  public type PriorityMap = {
    var map : [[Float]];
    var goalRelevance : [[Float]];
    var selectionHistory : [[Float]];
    var physicalSalience : [[Float]];
    var rewardAssociations : [[Float]];
    var contextualPriors : [[Float]];
  };
  
  public type FeatureIntegration = {
    var preattentiveFeatures : [Float];
    var conjunctionDifficulty : Float;
    var illusoryConjunctions : Float;
    var bindingStrength : Float;
    var featureMapActivation : [[Float]];
    var masterMap : [[Float]];
  };
  
  public type GuidedSearch = {
    var targetTemplate : [Float];
    var guidanceStrength : Float;
    var bottomUpWeight : Float;
    var topDownWeight : Float;
    var activationThreshold : Float;
    var searchSlope : Float;
  };
  
  public type VisualSearchState = {
    var searchMode : SearchMode;
    var targetPresent : Bool;
    var setSize : Nat;
    var reactionTime : Float;
    var accuracy : Float;
    var searchEfficiency : Float;
  };
  
  public type SearchMode = {
    #ParallelSearch;
    #SerialSearch;
    #GuidedSearch;
    #PopoutSearch;
    #ConjunctionSearch;
  };
  
  public type ChangeDetection = {
    var changeBlindness : Float;
    var flicker paradigmSensitivity : Float;
    var mudsplashSensitivity : Float;
    var gradualChangeSensitivity : Float;
    var detectionThreshold : Float;
    var changeMap : [[Bool]];
  };
  
  public type InattentionalBlindness = {
    var blindnessRisk : Float;
    var unexpectedObjectDetection : Float;
    var attentionalSet : [Float];
    var perceptualLoad : Float;
    var taskEngagement : Float;
    var gorillaEffect : Bool;
  };
  
  /// Initialize visual attention state
  public func initVisualAttentionState(width : Nat, height : Nat) : VisualAttentionState {
    let emptyMap = Array.tabulate<[Float]>(height, func(i) {
      Array.tabulate<Float>(width, func(j) { 0.0 })
    });
    
    {
      var saliencyMap = {
        var map = emptyMap;
        var colorSaliency = emptyMap;
        var orientationSaliency = emptyMap;
        var intensitySaliency = emptyMap;
        var motionSaliency = emptyMap;
        var centerBias = 0.3;
        var topDownModulation = emptyMap;
      };
      var priorityMap = {
        var map = emptyMap;
        var goalRelevance = emptyMap;
        var selectionHistory = emptyMap;
        var physicalSalience = emptyMap;
        var rewardAssociations = emptyMap;
        var contextualPriors = emptyMap;
      };
      var featureIntegration = {
        var preattentiveFeatures = Array.tabulate<Float>(12, func(i) { 0.5 });
        var conjunctionDifficulty = 0.5;
        var illusoryConjunctions = 0.1;
        var bindingStrength = 0.7;
        var featureMapActivation = emptyMap;
        var masterMap = emptyMap;
      };
      var guidedSearch = {
        var targetTemplate = Array.tabulate<Float>(32, func(i) { 0.0 });
        var guidanceStrength = 0.6;
        var bottomUpWeight = 0.4;
        var topDownWeight = 0.6;
        var activationThreshold = 0.5;
        var searchSlope = 30.0;
      };
      var visualSearch = {
        var searchMode = #GuidedSearch;
        var targetPresent = false;
        var setSize = 0;
        var reactionTime = 0.0;
        var accuracy = 0.9;
        var searchEfficiency = 0.7;
      };
      var changeDetection = {
        var changeBlindness = 0.4;
        var flickerParadigmSensitivity = 0.6;
        var mudsplashSensitivity = 0.5;
        var gradualChangeSensitivity = 0.3;
        var detectionThreshold = 0.3;
        var changeMap = Array.tabulate<[Bool]>(height, func(i) {
          Array.tabulate<Bool>(width, func(j) { false })
        });
      };
      var inattentionalBlindness = {
        var blindnessRisk = 0.3;
        var unexpectedObjectDetection = 0.4;
        var attentionalSet = Array.tabulate<Float>(8, func(i) { 0.5 });
        var perceptualLoad = 0.5;
        var taskEngagement = 0.7;
        var gorillaEffect = false;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // AUDITORY ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AuditoryAttentionState = {
    var cocktailPartyEffect : CocktailPartyState;
    var auditoryStreaming : AuditoryStreaming;
    var dichotic Listening : DichoticListening;
    var temporalAttention : TemporalAuditoryAttention;
    var auditorySceneAnalysis : AuditorySceneAnalysis;
  };
  
  public type CocktailPartyState = {
    var attendedStream : [Float];
    var unattendedStreams : [[Float]];
    var selectionCriterion : SelectionCriterion;
    var breakdownThreshold : Float;
    var ownNameEffect : Float;
    var spatialCueBenefit : Float;
  };
  
  public type SelectionCriterion = {
    #SpatialLocation;
    #Pitch;
    #TimbreVoice;
    #Semantics;
    #Rhythm;
  };
  
  public type AuditoryStreaming = {
    var streams : [[Float]];
    var frequencyProximity : Float;
    var temporalProximity : Float;
    var streamCoherence : [Float];
    var fissionBias : Float;
    var fusionBias : Float;
  };
  
  public type DichoticListening = {
    var rightEarAdvantage : Float;
    var attentionalBias : Float;
    var shadowingAccuracy : Float;
    var lateSelectionBreakthrough : Float;
    var semanticProcessingUnattended : Float;
  };
  
  public type TemporalAuditoryAttention = {
    var attentionalBlink : Float;
    var streamingInTime : Float;
    var rhythmicEntrainment : Float;
    var temporalExpectation : Float;
    var foreperiodEffect : Float;
  };
  
  public type AuditorySceneAnalysis = {
    var primitiveGrouping : Float;
    var schemaBasedGrouping : Float;
    var harmonicGrouping : Float;
    var onsetSynchrony : Float;
    var commonFate : Float;
    var continuity : Float;
  };
  
  /// Initialize auditory attention state
  public func initAuditoryAttentionState() : AuditoryAttentionState {
    {
      var cocktailPartyEffect = {
        var attendedStream = Array.tabulate<Float>(64, func(i) { 0.0 });
        var unattendedStreams = [];
        var selectionCriterion = #SpatialLocation;
        var breakdownThreshold = 0.7;
        var ownNameEffect = 0.8;
        var spatialCueBenefit = 0.3;
      };
      var auditoryStreaming = {
        var streams = [];
        var frequencyProximity = 0.6;
        var temporalProximity = 0.7;
        var streamCoherence = [];
        var fissionBias = 0.4;
        var fusionBias = 0.5;
      };
      var dichoticListening = {
        var rightEarAdvantage = 0.55;
        var attentionalBias = 0.0;
        var shadowingAccuracy = 0.9;
        var lateSelectionBreakthrough = 0.2;
        var semanticProcessingUnattended = 0.3;
      };
      var temporalAuditoryAttention = {
        var attentionalBlink = 0.3;
        var streamingInTime = 0.6;
        var rhythmicEntrainment = 0.7;
        var temporalExpectation = 0.6;
        var foreperiodEffect = 0.4;
      };
      var auditorySceneAnalysis = {
        var primitiveGrouping = 0.7;
        var schemaBasedGrouping = 0.5;
        var harmonicGrouping = 0.6;
        var onsetSynchrony = 0.7;
        var commonFate = 0.6;
        var continuity = 0.7;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED ATTENTION ALLOCATION TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedAttentionState = {
    var baseState : AttentionAllocationState;
    var neuralNetworks : NeuralAttentionNetworks;
    var resources : AttentionResourceState;
    var visualAttention : VisualAttentionState;
    var auditoryAttention : AuditoryAttentionState;
    var integratedAttentionLevel : Float;
    var attentionalEfficiency : Float;
  };
  
  /// Run integrated attention allocation tick
  public func runIntegratedAttentionTick(
    intState : IntegratedAttentionState,
    visualInput : [[Float]],
    auditoryInput : [Float],
    taskDemands : Float
  ) : IntegratedAttentionResult {
    let startTime = Time.now();
    
    // 1. Run base attention allocation
    let baseResult = runAttentionTick(intState.baseState, visualInput, taskDemands);
    
    // 2. Update neural attention networks
    intState.neuralNetworks.alertingNetwork.phasicAlertness := 
      intState.neuralNetworks.alertingNetwork.phasicAlertness * 0.9 + taskDemands * 0.1;
    
    // 3. Update attention resources
    let resourceDemand = taskDemands * 0.8 + baseResult.executiveLoad * 0.2;
    intState.resources.centralCapacity.availableCapacity := 
      Float.max(0.0, intState.resources.centralCapacity.totalCapacity - resourceDemand);
    
    // 4. Update resource depletion
    intState.resources.resourceDepletion.egoDepletion := 
      Float.min(1.0, intState.resources.resourceDepletion.egoDepletion + taskDemands * 0.01);
    
    // 5. Compute integrated attention level
    let networkBalance = (intState.neuralNetworks.alertingNetwork.tonicAlertness +
                         intState.neuralNetworks.orientingNetwork.covertOrienting +
                         intState.neuralNetworks.executiveNetwork.goalMaintenance) / 3.0;
    
    let resourceAvailability = intState.resources.centralCapacity.availableCapacity;
    
    intState.integratedAttentionLevel := (
      baseResult.overallAttention * 0.4 +
      networkBalance * 0.3 +
      resourceAvailability * 0.3
    );
    
    // 6. Compute attentional efficiency
    intState.attentionalEfficiency := intState.integratedAttentionLevel / 
      Float.max(0.1, resourceDemand);
    
    {
      baseResult = baseResult;
      networkBalance = networkBalance;
      resourceAvailability = resourceAvailability;
      egoDepletion = intState.resources.resourceDepletion.egoDepletion;
      visualSearchEfficiency = intState.visualAttention.visualSearch.searchEfficiency;
      auditoryStreamingCoherence = if (intState.auditoryAttention.auditoryStreaming.streamCoherence.size() > 0) {
        intState.auditoryAttention.auditoryStreaming.streamCoherence[0]
      } else { 0.5 };
      integratedAttentionLevel = intState.integratedAttentionLevel;
      attentionalEfficiency = intState.attentionalEfficiency;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type IntegratedAttentionResult = {
    baseResult : AttentionTickResult;
    networkBalance : Float;
    resourceAvailability : Float;
    egoDepletion : Float;
    visualSearchEfficiency : Float;
    auditoryStreamingCoherence : Float;
    integratedAttentionLevel : Float;
    attentionalEfficiency : Float;
    processingTime : Int;
  };
  
  /// Get integrated attention status
  public func getIntegratedAttentionStatus(intState : IntegratedAttentionState) : IntegratedAttentionStatus {
    {
      baseStatus = getAttentionStatus(intState.baseState);
      neuralNetworkStatus = {
        alertingLevel = intState.neuralNetworks.alertingNetwork.tonicAlertness;
        orientingLevel = intState.neuralNetworks.orientingNetwork.covertOrienting;
        executiveLevel = intState.neuralNetworks.executiveNetwork.goalMaintenance;
        networkDominance = switch (intState.neuralNetworks.networkInteraction.networkDominance) {
          case (#Alerting) { "Alerting" };
          case (#Orienting) { "Orienting" };
          case (#Executive) { "Executive" };
          case (#Balanced) { "Balanced" };
          case (#Fatigued) { "Fatigued" };
        };
      };
      resourceStatus = {
        availableCapacity = intState.resources.centralCapacity.availableCapacity;
        egoDepletion = intState.resources.resourceDepletion.egoDepletion;
        effortLevel = intState.resources.effortRegulation.currentEffort;
        perceptualLoad = intState.resources.perceptualLoad.currentLoad;
      };
      visualAttentionStatus = {
        searchMode = switch (intState.visualAttention.visualSearch.searchMode) {
          case (#ParallelSearch) { "Parallel" };
          case (#SerialSearch) { "Serial" };
          case (#GuidedSearch) { "Guided" };
          case (#PopoutSearch) { "Popout" };
          case (#ConjunctionSearch) { "Conjunction" };
        };
        searchEfficiency = intState.visualAttention.visualSearch.searchEfficiency;
        changeBlindness = intState.visualAttention.changeDetection.changeBlindness;
      };
      auditoryAttentionStatus = {
        cocktailPartyThreshold = intState.auditoryAttention.cocktailPartyEffect.breakdownThreshold;
        rhythmicEntrainment = intState.auditoryAttention.temporalAuditoryAttention.rhythmicEntrainment;
      };
      integratedAttentionLevel = intState.integratedAttentionLevel;
      attentionalEfficiency = intState.attentionalEfficiency;
    }
  };
  
  public type IntegratedAttentionStatus = {
    baseStatus : AttentionStatus;
    neuralNetworkStatus : {
      alertingLevel : Float;
      orientingLevel : Float;
      executiveLevel : Float;
      networkDominance : Text;
    };
    resourceStatus : {
      availableCapacity : Float;
      egoDepletion : Float;
      effortLevel : Float;
      perceptualLoad : Float;
    };
    visualAttentionStatus : {
      searchMode : Text;
      searchEfficiency : Float;
      changeBlindness : Float;
    };
    auditoryAttentionStatus : {
      cocktailPartyThreshold : Float;
      rhythmicEntrainment : Float;
    };
    integratedAttentionLevel : Float;
    attentionalEfficiency : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXECUTIVE FUNCTION - COGNITIVE CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ExecutiveFunctionState = {
    var cognitiveControl : CognitiveControlState;
    var workingMemoryExecutive : WorkingMemoryExecutiveState;
    var inhibitoryControl : InhibitoryControlState;
    var cognitiveFlexibility : CognitiveFlexibilityState;
    var planningReasoning : PlanningReasoningState;
    var goalManagement : GoalManagementState;
  };
  
  public type CognitiveControlState = {
    var conflictMonitoring : Float;
    var errorDetection : Float;
    var performanceMonitoring : Float;
    var adjustmentSignal : Float;
    var proactiveControl : Float;
    var reactiveControl : Float;
    var dualMechanisms : Float;
  };
  
  public type WorkingMemoryExecutiveState = {
    var centralExecutive : Float;
    var phonologicalLoop : PhonologicalLoopState;
    var visuospatialSketchpad : VisuospatialSketchpadState;
    var episodicBuffer : EpisodicBufferState;
    var attentionalControl : Float;
    var coordinationCapacity : Float;
  };
  
  public type PhonologicalLoopState = {
    var articulatoryRehearsal : Float;
    var phonologicalStore : [Float];
    var wordLengthEffect : Float;
    var phonologicalSimilarity : Float;
    var articulatorySuppression : Float;
  };
  
  public type VisuospatialSketchpadState = {
    var visualCache : [[Float]];
    var innerScribe : Float;
    var spatialRelations : [[Float]];
    var mentalRotation : Float;
    var visualInterference : Float;
  };
  
  public type EpisodicBufferState = {
    var bindingCapacity : Float;
    var chunkingEfficiency : Float;
    var episodicRetrieval : Float;
    var multimodalIntegration : Float;
    var temporalOrdering : Float;
  };
  
  public type InhibitoryControlState = {
    var responseInhibition : Float;
    var cognitiveInhibition : Float;
    var interferenceSuppression : Float;
    var resistanceDistraction : Float;
    var stopSignalDelay : Float;
    var prepotentResponse : Float;
    var inhibitoryFailure : Float;
  };
  
  public type CognitiveFlexibilityState = {
    var taskSwitching : TaskSwitchingState;
    var setShifting : SetShiftingState;
    var adaptiveResponse : Float;
    var perseveration : Float;
    var flexibilityIndex : Float;
  };
  
  public type TaskSwitchingState = {
    var switchCost : Float;
    var mixingCost : Float;
    var preparationBenefit : Float;
    var residualSwitchCost : Float;
    var taskSetInertia : Float;
    var taskSetReconfiguration : Float;
  };
  
  public type SetShiftingState = {
    var attentionalSet : Float;
    var intradimensionalShift : Float;
    var extradimensionalShift : Float;
    var reversingLearning : Float;
    var ruleAcquisition : Float;
  };
  
  public type PlanningReasoningState = {
    var planningDepth : Nat;
    var lookAhead : Nat;
    var subgoalGeneration : Float;
    var meansEndsAnalysis : Float;
    var planExecution : Float;
    var planMonitoring : Float;
    var contingencyPlanning : Float;
  };
  
  public type GoalManagementState = {
    var activeGoals : [ActiveGoal];
    var goalPrioritization : Float;
    var goalMaintenance : Float;
    var goalShielding : Float;
    var subgoalIntegration : Float;
    var goalConflictResolution : Float;
  };
  
  public type ActiveGoal = {
    goalId : Nat;
    goalContent : Text;
    priority : Float;
    progress : Float;
    deadline : ?Int;
    subgoals : [Nat];
    obstacles : [Text];
  };
  
  /// Initialize executive function state
  public func initExecutiveFunctionState() : ExecutiveFunctionState {
    {
      var cognitiveControl = {
        var conflictMonitoring = 0.5;
        var errorDetection = 0.6;
        var performanceMonitoring = 0.5;
        var adjustmentSignal = 0.0;
        var proactiveControl = 0.5;
        var reactiveControl = 0.5;
        var dualMechanisms = 0.5;
      };
      var workingMemoryExecutive = {
        var centralExecutive = 0.6;
        var phonologicalLoop = {
          var articulatoryRehearsal = 0.5;
          var phonologicalStore = [];
          var wordLengthEffect = 0.3;
          var phonologicalSimilarity = 0.4;
          var articulatorySuppression = 0.0;
        };
        var visuospatialSketchpad = {
          var visualCache = [];
          var innerScribe = 0.5;
          var spatialRelations = [];
          var mentalRotation = 0.5;
          var visualInterference = 0.0;
        };
        var episodicBuffer = {
          var bindingCapacity = 0.6;
          var chunkingEfficiency = 0.5;
          var episodicRetrieval = 0.5;
          var multimodalIntegration = 0.5;
          var temporalOrdering = 0.6;
        };
        var attentionalControl = 0.6;
        var coordinationCapacity = 0.5;
      };
      var inhibitoryControl = {
        var responseInhibition = 0.6;
        var cognitiveInhibition = 0.5;
        var interferenceSuppression = 0.5;
        var resistanceDistraction = 0.5;
        var stopSignalDelay = 200.0;
        var prepotentResponse = 0.3;
        var inhibitoryFailure = 0.1;
      };
      var cognitiveFlexibility = {
        var taskSwitching = {
          var switchCost = 100.0;
          var mixingCost = 50.0;
          var preparationBenefit = 0.3;
          var residualSwitchCost = 30.0;
          var taskSetInertia = 0.3;
          var taskSetReconfiguration = 0.5;
        };
        var setShifting = {
          var attentionalSet = 0.6;
          var intradimensionalShift = 0.7;
          var extradimensionalShift = 0.5;
          var reversingLearning = 0.4;
          var ruleAcquisition = 0.6;
        };
        var adaptiveResponse = 0.5;
        var perseveration = 0.2;
        var flexibilityIndex = 0.6;
      };
      var planningReasoning = {
        var planningDepth = 3;
        var lookAhead = 5;
        var subgoalGeneration = 0.5;
        var meansEndsAnalysis = 0.5;
        var planExecution = 0.6;
        var planMonitoring = 0.5;
        var contingencyPlanning = 0.4;
      };
      var goalManagement = {
        var activeGoals = [];
        var goalPrioritization = 0.6;
        var goalMaintenance = 0.7;
        var goalShielding = 0.5;
        var subgoalIntegration = 0.5;
        var goalConflictResolution = 0.5;
      };
    }
  };
  
  /// Process cognitive control
  public func processCognitiveControl(execState : ExecutiveFunctionState, conflictLevel : Float, errorSignal : Float) {
    // Update conflict monitoring
    execState.cognitiveControl.conflictMonitoring := 
      execState.cognitiveControl.conflictMonitoring * 0.8 + conflictLevel * 0.2;
    
    // Update error detection
    if (errorSignal > 0.5) {
      execState.cognitiveControl.errorDetection := 
        execState.cognitiveControl.errorDetection * 0.7 + errorSignal * 0.3;
      execState.cognitiveControl.adjustmentSignal := errorSignal;
    } else {
      execState.cognitiveControl.adjustmentSignal := execState.cognitiveControl.adjustmentSignal * 0.9;
    };
    
    // Dual mechanisms of cognitive control
    if (execState.cognitiveControl.conflictMonitoring > 0.6) {
      // High conflict → proactive control
      execState.cognitiveControl.proactiveControl := 
        Float.min(1.0, execState.cognitiveControl.proactiveControl + 0.1);
    } else {
      // Low conflict → reactive control
      execState.cognitiveControl.reactiveControl := 
        Float.min(1.0, execState.cognitiveControl.reactiveControl + 0.05);
    };
    
    execState.cognitiveControl.dualMechanisms := 
      (execState.cognitiveControl.proactiveControl + execState.cognitiveControl.reactiveControl) / 2.0;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // METACOGNITION - SELF-REFLECTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MetacognitionState = {
    var metacognitiveMonitoring : MetacognitiveMonitoringState;
    var metacognitiveControl : MetacognitiveControlState;
    var selfReflection : SelfReflectionState;
    var uncertaintyAwareness : UncertaintyAwarenessState;
    var learningToLearn : LearningToLearnState;
  };
  
  public type MetacognitiveMonitoringState = {
    var confidenceJudgments : [Float];
    var easeOfLearning : Float;
    var judgmentOfLearning : Float;
    var feelingOfKnowing : Float;
    var retrospectiveConfidence : Float;
    var calibration : Float;
    var resolution : Float;
  };
  
  public type MetacognitiveControlState = {
    var allocationOfStudyTime : Float;
    var selectionOfStrategies : Float;
    var terminationOfStudy : Float;
    var retrieval Strategies : Float;
    var effortRegulation : Float;
  };
  
  public type SelfReflectionState = {
    var selfAwareness : Float;
    var introspectiveAccuracy : Float;
    var mentalStateAttribution : Float;
    var thoughtMonitoring : Float;
    var metacognitiveExperience : Float;
  };
  
  public type UncertaintyAwarenessState = {
    var epistemicUncertainty : Float;
    var aleatoricUncertainty : Float;
    var modelUncertainty : Float;
    var uncertaintyQuantification : Float;
    var calibratedConfidence : Float;
  };
  
  public type LearningToLearnState = {
    var transferLearning : Float;
    var metalearningRate : Float;
    var taskSimilarity : Float;
    var priorKnowledge : Float;
    var learningCurve : [Float];
    var adaptationSpeed : Float;
  };
  
  /// Initialize metacognition state
  public func initMetacognitionState() : MetacognitionState {
    {
      var metacognitiveMonitoring = {
        var confidenceJudgments = [];
        var easeOfLearning = 0.5;
        var judgmentOfLearning = 0.5;
        var feelingOfKnowing = 0.5;
        var retrospectiveConfidence = 0.5;
        var calibration = 0.5;
        var resolution = 0.5;
      };
      var metacognitiveControl = {
        var allocationOfStudyTime = 0.5;
        var selectionOfStrategies = 0.5;
        var terminationOfStudy = 0.5;
        var retrievalStrategies = 0.5;
        var effortRegulation = 0.5;
      };
      var selfReflection = {
        var selfAwareness = 0.5;
        var introspectiveAccuracy = 0.5;
        var mentalStateAttribution = 0.5;
        var thoughtMonitoring = 0.5;
        var metacognitiveExperience = 0.5;
      };
      var uncertaintyAwareness = {
        var epistemicUncertainty = 0.5;
        var aleatoricUncertainty = 0.3;
        var modelUncertainty = 0.4;
        var uncertaintyQuantification = 0.5;
        var calibratedConfidence = 0.5;
      };
      var learningToLearn = {
        var transferLearning = 0.5;
        var metalearningRate = 0.1;
        var taskSimilarity = 0.5;
        var priorKnowledge = 0.5;
        var learningCurve = [];
        var adaptationSpeed = 0.5;
      };
    }
  };
  
  /// Update metacognitive monitoring
  public func updateMetacognitiveMonitoring(metaState : MetacognitionState, actualPerformance : Float, predictedPerformance : Float) {
    // Compute calibration error
    let calibrationError = Float.abs(actualPerformance - predictedPerformance);
    metaState.metacognitiveMonitoring.calibration := 1.0 - calibrationError;
    
    // Update confidence judgments
    let newConfidence = actualPerformance;
    metaState.metacognitiveMonitoring.retrospectiveConfidence := 
      metaState.metacognitiveMonitoring.retrospectiveConfidence * 0.8 + newConfidence * 0.2;
    
    // Update feeling of knowing based on retrieval success
    if (actualPerformance > 0.5) {
      metaState.metacognitiveMonitoring.feelingOfKnowing := 
        Float.min(1.0, metaState.metacognitiveMonitoring.feelingOfKnowing + 0.05);
    } else {
      metaState.metacognitiveMonitoring.feelingOfKnowing := 
        Float.max(0.0, metaState.metacognitiveMonitoring.feelingOfKnowing - 0.05);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED DEEP ATTENTION EXECUTIVE TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeepIntegratedAttentionExecutiveState = {
    var baseState : IntegratedAttentionState;
    var executiveFunction : ExecutiveFunctionState;
    var metacognition : MetacognitionState;
    var deepAttentionIntegration : Float;
    var executiveEfficiency : Float;
  };
  
  /// Run deep integrated attention executive tick
  public func runDeepIntegratedAttentionExecutiveTick(
    deepState : DeepIntegratedAttentionExecutiveState,
    sensoryInput : [Float],
    conflictLevel : Float,
    errorSignal : Float,
    dt : Float
  ) : DeepIntegratedAttentionExecutiveResult {
    let startTime = Time.now();
    
    // 1. Run base attention processing
    let baseResult = runIntegratedAttentionTick(deepState.baseState, sensoryInput, dt);
    
    // 2. Process cognitive control
    processCognitiveControl(deepState.executiveFunction, conflictLevel, errorSignal);
    
    // 3. Update metacognitive monitoring
    updateMetacognitiveMonitoring(deepState.metacognition, baseResult.attentionalEfficiency, 0.6);
    
    // 4. Compute deep attention integration
    deepState.deepAttentionIntegration := (
      baseResult.integratedAttentionLevel * 0.4 +
      deepState.executiveFunction.cognitiveControl.dualMechanisms * 0.3 +
      deepState.metacognition.selfReflection.selfAwareness * 0.3
    );
    
    // 5. Compute executive efficiency
    deepState.executiveEfficiency := (
      deepState.executiveFunction.inhibitoryControl.responseInhibition * 0.3 +
      deepState.executiveFunction.cognitiveFlexibility.flexibilityIndex * 0.3 +
      deepState.executiveFunction.workingMemoryExecutive.centralExecutive * 0.4
    );
    
    {
      baseResult = baseResult;
      conflictMonitoring = deepState.executiveFunction.cognitiveControl.conflictMonitoring;
      inhibitoryControl = deepState.executiveFunction.inhibitoryControl.responseInhibition;
      cognitiveFlexibility = deepState.executiveFunction.cognitiveFlexibility.flexibilityIndex;
      metacognitiveCalibration = deepState.metacognition.metacognitiveMonitoring.calibration;
      selfAwareness = deepState.metacognition.selfReflection.selfAwareness;
      deepAttentionIntegration = deepState.deepAttentionIntegration;
      executiveEfficiency = deepState.executiveEfficiency;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type DeepIntegratedAttentionExecutiveResult = {
    baseResult : IntegratedAttentionResult;
    conflictMonitoring : Float;
    inhibitoryControl : Float;
    cognitiveFlexibility : Float;
    metacognitiveCalibration : Float;
    selfAwareness : Float;
    deepAttentionIntegration : Float;
    executiveEfficiency : Float;
    processingTime : Int;
  };
  
  /// Get deep integrated attention executive status
  public func getDeepIntegratedAttentionExecutiveStatus(deepState : DeepIntegratedAttentionExecutiveState) : DeepIntegratedAttentionExecutiveStatus {
    {
      baseStatus = getIntegratedAttentionStatus(deepState.baseState);
      executiveFunctionStatus = {
        conflictMonitoring = deepState.executiveFunction.cognitiveControl.conflictMonitoring;
        errorDetection = deepState.executiveFunction.cognitiveControl.errorDetection;
        proactiveControl = deepState.executiveFunction.cognitiveControl.proactiveControl;
        responseInhibition = deepState.executiveFunction.inhibitoryControl.responseInhibition;
        flexibilityIndex = deepState.executiveFunction.cognitiveFlexibility.flexibilityIndex;
        planningDepth = deepState.executiveFunction.planningReasoning.planningDepth;
      };
      metacognitionStatus = {
        calibration = deepState.metacognition.metacognitiveMonitoring.calibration;
        feelingOfKnowing = deepState.metacognition.metacognitiveMonitoring.feelingOfKnowing;
        selfAwareness = deepState.metacognition.selfReflection.selfAwareness;
        uncertaintyAwareness = deepState.metacognition.uncertaintyAwareness.calibratedConfidence;
        metalearningRate = deepState.metacognition.learningToLearn.metalearningRate;
      };
      deepAttentionIntegration = deepState.deepAttentionIntegration;
      executiveEfficiency = deepState.executiveEfficiency;
    }
  };
  
  public type DeepIntegratedAttentionExecutiveStatus = {
    baseStatus : IntegratedAttentionStatus;
    executiveFunctionStatus : {
      conflictMonitoring : Float;
      errorDetection : Float;
      proactiveControl : Float;
      responseInhibition : Float;
      flexibilityIndex : Float;
      planningDepth : Nat;
    };
    metacognitionStatus : {
      calibration : Float;
      feelingOfKnowing : Float;
      selfAwareness : Float;
      uncertaintyAwareness : Float;
      metalearningRate : Float;
    };
    deepAttentionIntegration : Float;
    executiveEfficiency : Float;
  };
}
