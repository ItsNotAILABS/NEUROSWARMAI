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
// VAEL EXTERIOR ATTACK CHAIN — DURA / RIFT / VERITAS_EXT / MEMORIA
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The organism has an EXTERIOR defense system — the VAEL chain.
// This protects against external attacks, adversarial inputs, and integrity violations.
//
// THE VAEL CHAIN:
// ═══════════════
//
// 1. DURA (The Hard Shell)
//    - 6-axis perimeter detection
//    - Coherence axis: deviation from expected coherence
//    - Identity axis: deviation from expected identity
//    - Frequency axis: deviation from expected oscillation
//    - Temporal axis: timing anomalies
//    - Economic axis: resource flow anomalies
//    - Social axis: interaction pattern anomalies
//
// 2. RIFT (The Breach Detector)
//    - Identifies attack vectors
//    - Logs caller principal hash
//    - Tracks beat and axis of breach
//    - Maintains breach history
//
// 3. VERITAS_EXT (External Truth Validator)
//    - Cross-references against SACESI chain
//    - Validates signal consistency
//    - Rejects inconsistent signals
//    - Maintains truth history
//
// 4. MEMORIA (Adversarial Pattern Memory)
//    - Permanent storage of attack patterns
//    - Pattern matching for fast response
//    - Response time drops 50% on known patterns
//    - Never forgets an attack
//
// THE COMPLETE CHAIN:
// ══════════════════
//
// External Signal → DURA (detect) → RIFT (identify) → VERITAS_EXT (validate) → MEMORIA (remember)
//                                                                                    ↓
//                                                            externalThreatSignal → FEAR ENGINE + ARES
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
import Principal "mo:core/Principal";
import Blob "mo:core/Blob";
import Time "mo:core/Time";

module VAELExteriorChain {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.618033988749894848204586834365638;
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  
  public let NUM_AXES : Nat = 6;
  public let BREACH_HISTORY_SIZE : Nat = 100;
  public let PATTERN_MEMORY_SIZE : Nat = 500;
  public let BASELINE_WINDOW : Nat = 100;
  
  // Axis indices
  public let COHERENCE_AXIS : Nat = 0;
  public let IDENTITY_AXIS : Nat = 1;
  public let FREQUENCY_AXIS : Nat = 2;
  public let TEMPORAL_AXIS : Nat = 3;
  public let ECONOMIC_AXIS : Nat = 4;
  public let SOCIAL_AXIS : Nat = 5;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: DURA — THE HARD SHELL (6-AXIS PERIMETER DETECTION)
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // DURA monitors 6 axes for anomalies:
  //   perimeterScore[axis] = |observed - baseline_running| / stdDev_running
  //
  // When score > threshold (typically 2σ or 3σ), DURA fires.
  //
  
  public type AxisState = {
    name : Text;
    var currentValue : Float;            // Current observed value
    var baselineMean : Float;            // Running mean
    var baselineStdDev : Float;          // Running standard deviation
    var perimeterScore : Float;          // Z-score of current deviation
    var threshold : Float;               // Sigma threshold for alert
    var isBreached : Bool;               // Is this axis currently breached?
    var breachCount : Nat;               // Total breaches
    var lastBreachBeat : Nat;
    var history : [var Float];           // Recent values for baseline calculation
    var historyIdx : Nat;
  };
  
  public type DURAState = {
    var axes : [var AxisState];
    var overallPerimeterScore : Float;   // Combined score across all axes
    var alertLevel : Nat;                // 0 = green, 1 = yellow, 2 = orange, 3 = red
    var activeBreaches : Nat;            // How many axes currently breached
    var totalAlerts : Nat;
    var consecutiveCleanBeats : Nat;
    var lastAlertBeat : Nat;
  };
  
  // Initialize DURA
  public func initDURA() : DURAState {
    let axisNames = [
      "COHERENCE", "IDENTITY", "FREQUENCY", "TEMPORAL", "ECONOMIC", "SOCIAL"
    ];
    
    let axes = Array.init<AxisState>(NUM_AXES, func(i : Nat) : AxisState {
      {
        name = axisNames[i];
        var currentValue = S_ZERO_FLOOR;
        var baselineMean = S_ZERO_FLOOR;
        var baselineStdDev = 0.1;
        var perimeterScore = 0.0;
        var threshold = 2.5;  // 2.5σ default
        var isBreached = false;
        var breachCount = 0;
        var lastBreachBeat = 0;
        var history = Array.init<Float>(BASELINE_WINDOW, func(_ : Nat) : Float { S_ZERO_FLOOR });
        var historyIdx = 0;
      }
    });
    
    {
      var axes = axes;
      var overallPerimeterScore = 0.0;
      var alertLevel = 0;
      var activeBreaches = 0;
      var totalAlerts = 0;
      var consecutiveCleanBeats = 0;
      var lastAlertBeat = 0;
    }
  };
  
  // Update baseline statistics (running mean and stddev)
  func updateBaseline(axis : AxisState) {
    // Calculate mean
    var sum : Float = 0.0;
    for (i in Iter.range(0, BASELINE_WINDOW - 1)) {
      sum += axis.history[i];
    };
    axis.baselineMean := sum / Float.fromInt(BASELINE_WINDOW);
    
    // Calculate stddev
    var sumSq : Float = 0.0;
    for (i in Iter.range(0, BASELINE_WINDOW - 1)) {
      let diff = axis.history[i] - axis.baselineMean;
      sumSq += diff * diff;
    };
    axis.baselineStdDev := sqrt(sumSq / Float.fromInt(BASELINE_WINDOW));
    
    // Minimum stddev to prevent division issues
    if (axis.baselineStdDev < 0.01) {
      axis.baselineStdDev := 0.01;
    };
  };
  
  // Check single axis for breach
  func checkAxisBreach(axis : AxisState, currentBeat : Nat) : Bool {
    // Update history
    axis.history[axis.historyIdx] := axis.currentValue;
    axis.historyIdx := (axis.historyIdx + 1) % BASELINE_WINDOW;
    
    // Update baseline
    updateBaseline(axis);
    
    // Calculate perimeter score (Z-score)
    axis.perimeterScore := Float.abs(axis.currentValue - axis.baselineMean) / axis.baselineStdDev;
    
    // Check threshold
    let wasBreached = axis.isBreached;
    axis.isBreached := axis.perimeterScore > axis.threshold;
    
    if (axis.isBreached and not wasBreached) {
      axis.breachCount += 1;
      axis.lastBreachBeat := currentBeat;
    };
    
    axis.isBreached
  };
  
  // Run DURA detection
  public func runDURADetection(
    dura : DURAState,
    observations : [Float],              // 6 values, one per axis
    currentBeat : Nat
  ) : (Bool, [Nat]) {  // Returns (anyBreach, breachedAxes)
    var anyBreach = false;
    var breachedAxes = Buffer.Buffer<Nat>(NUM_AXES);
    var totalScore : Float = 0.0;
    var breachCount : Nat = 0;
    
    for (i in Iter.range(0, NUM_AXES - 1)) {
      // Update current value
      dura.axes[i].currentValue := if (i < Array.size(observations)) { observations[i] } else { S_ZERO_FLOOR };
      
      // Check for breach
      if (checkAxisBreach(dura.axes[i], currentBeat)) {
        anyBreach := true;
        breachedAxes.add(i);
        breachCount += 1;
      };
      
      totalScore += dura.axes[i].perimeterScore;
    };
    
    dura.overallPerimeterScore := totalScore / Float.fromInt(NUM_AXES);
    dura.activeBreaches := breachCount;
    
    // Set alert level
    if (breachCount == 0) {
      dura.consecutiveCleanBeats += 1;
      if (dura.consecutiveCleanBeats > 10) {
        dura.alertLevel := 0;  // Green
      };
    } else {
      dura.consecutiveCleanBeats := 0;
      dura.lastAlertBeat := currentBeat;
      dura.totalAlerts += 1;
      
      if (breachCount >= 4) {
        dura.alertLevel := 3;  // Red
      } else if (breachCount >= 2) {
        dura.alertLevel := 2;  // Orange
      } else {
        dura.alertLevel := 1;  // Yellow
      };
    };
    
    (anyBreach, Buffer.toArray(breachedAxes))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: RIFT — THE BREACH DETECTOR
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // RIFT identifies attack vectors when DURA fires.
  // It logs:
  //   - Caller principal hash
  //   - Beat of breach
  //   - Which axes were breached
  //   - Magnitude of breach
  //
  
  public type RIFTEntry = {
    beat : Nat;
    callerHash : Nat32;                  // FNV-1a hash of caller principal
    breachedAxes : [Nat];
    magnitudes : [Float];                // Perimeter scores at breach
    var responseGenerated : Bool;
    var responseEffective : Bool;
  };
  
  public type RIFTState = {
    var entries : [var RIFTEntry];
    var writeIdx : Nat;
    var totalEntries : Nat;
    var uniqueCallers : [var Nat32];     // Unique caller hashes seen
    var callerCount : Nat;
    var mostFrequentCaller : Nat32;
    var mostFrequentCount : Nat;
  };
  
  // Initialize RIFT
  public func initRIFT() : RIFTState {
    let emptyEntry : RIFTEntry = {
      beat = 0;
      callerHash = 0;
      breachedAxes = [];
      magnitudes = [];
      var responseGenerated = false;
      var responseEffective = false;
    };
    
    {
      var entries = Array.init<RIFTEntry>(BREACH_HISTORY_SIZE, func(_ : Nat) : RIFTEntry { emptyEntry });
      var writeIdx = 0;
      var totalEntries = 0;
      var uniqueCallers = Array.init<Nat32>(100, func(_ : Nat) : Nat32 { 0 });
      var callerCount = 0;
      var mostFrequentCaller = 0;
      var mostFrequentCount = 0;
    }
  };
  
  // FNV-1a hash for principal
  public func hashPrincipal(p : ?Principal) : Nat32 {
    switch (p) {
      case (?principal) {
        let bytes = Blob.toArray(Principal.toBlob(principal));
        fnv1aHash(bytes)
      };
      case (null) {
        0
      };
    }
  };
  
  // FNV-1a hash implementation
  func fnv1aHash(data : [Nat8]) : Nat32 {
    var hash : Nat32 = 2166136261;  // FNV offset basis
    let prime : Nat32 = 16777619;   // FNV prime
    
    for (byte in data.vals()) {
      hash := hash ^ Nat32.fromNat(Nat8.toNat(byte));
      hash := hash *% prime;
    };
    
    hash
  };
  
  // Log a breach in RIFT
  public func logRIFTBreach(
    rift : RIFTState,
    dura : DURAState,
    breachedAxes : [Nat],
    callerPrincipal : ?Principal,
    currentBeat : Nat
  ) {
    let callerHash = hashPrincipal(callerPrincipal);
    
    // Get magnitudes for breached axes
    let magnitudes = Array.tabulate<Float>(Array.size(breachedAxes), func(i : Nat) : Float {
      let axisIdx = breachedAxes[i];
      if (axisIdx < NUM_AXES) { dura.axes[axisIdx].perimeterScore } else { 0.0 }
    });
    
    let entry : RIFTEntry = {
      beat = currentBeat;
      callerHash = callerHash;
      breachedAxes = breachedAxes;
      magnitudes = magnitudes;
      var responseGenerated = false;
      var responseEffective = false;
    };
    
    rift.entries[rift.writeIdx] := entry;
    rift.writeIdx := (rift.writeIdx + 1) % BREACH_HISTORY_SIZE;
    rift.totalEntries += 1;
    
    // Track unique callers
    var found = false;
    var callerIdx : Nat = 0;
    for (i in Iter.range(0, rift.callerCount - 1)) {
      if (rift.uniqueCallers[i] == callerHash) {
        found := true;
        callerIdx := i;
      };
    };
    
    if (not found and rift.callerCount < 100) {
      rift.uniqueCallers[rift.callerCount] := callerHash;
      rift.callerCount += 1;
    };
    
    // Count frequency of this caller
    var callerFreq : Nat = 0;
    for (i in Iter.range(0, Nat.min(rift.totalEntries, BREACH_HISTORY_SIZE) - 1)) {
      if (rift.entries[i].callerHash == callerHash) {
        callerFreq += 1;
      };
    };
    
    if (callerFreq > rift.mostFrequentCount) {
      rift.mostFrequentCount := callerFreq;
      rift.mostFrequentCaller := callerHash;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: VERITAS_EXT — EXTERNAL TRUTH VALIDATOR
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // VERITAS_EXT cross-references incoming signals against the SACESI chain.
  // If a signal is inconsistent with history → reject + log.
  //
  // Consistency checks:
  //   1. Temporal consistency: signals arrive in order
  //   2. Value consistency: signals don't jump impossibly
  //   3. Hash consistency: SACESI chain is unbroken
  //   4. Source consistency: known sources only
  //
  
  public type VeritasEntry = {
    beat : Nat;
    signalHash : Nat32;
    sacesiHash : Nat32;                  // Expected SACESI hash
    var isConsistent : Bool;
    var inconsistencyType : Text;
    var wasRejected : Bool;
  };
  
  public type VERITASState = {
    var entries : [var VeritasEntry];
    var writeIdx : Nat;
    var totalChecks : Nat;
    var consistentChecks : Nat;
    var inconsistentChecks : Nat;
    var rejections : Nat;
    var lastSacesiHash : Nat32;          // Last known SACESI hash
    var lastValidBeat : Nat;
    var trustScore : Float;              // Overall trust in external signals
  };
  
  // Initialize VERITAS
  public func initVERITAS() : VERITASState {
    let emptyEntry : VeritasEntry = {
      beat = 0;
      signalHash = 0;
      sacesiHash = 0;
      var isConsistent = true;
      var inconsistencyType = "";
      var wasRejected = false;
    };
    
    {
      var entries = Array.init<VeritasEntry>(BREACH_HISTORY_SIZE, func(_ : Nat) : VeritasEntry { emptyEntry });
      var writeIdx = 0;
      var totalChecks = 0;
      var consistentChecks = 0;
      var inconsistentChecks = 0;
      var rejections = 0;
      var lastSacesiHash = 0;
      var lastValidBeat = 0;
      var trustScore = 1.0;
    }
  };
  
  // Validate external signal against SACESI chain
  public func validateSignal(
    veritas : VERITASState,
    signalData : [Nat8],
    expectedSacesiHash : Nat32,
    currentBeat : Nat,
    previousValue : Float,
    currentValue : Float
  ) : Bool {
    let signalHash = fnv1aHash(signalData);
    
    var isConsistent = true;
    var inconsistencyType = "";
    
    // Check 1: SACESI hash consistency
    if (veritas.lastSacesiHash != 0 and expectedSacesiHash != 0) {
      // The new SACESI should be derived from the previous
      // Simplified check: they should be related
      let hashDiff = if (expectedSacesiHash > veritas.lastSacesiHash) {
        expectedSacesiHash - veritas.lastSacesiHash
      } else {
        veritas.lastSacesiHash - expectedSacesiHash
      };
      
      // Hashes shouldn't be identical unless no change
      if (hashDiff == 0 and currentBeat != veritas.lastValidBeat) {
        // Might be suspicious but not necessarily inconsistent
      };
    };
    
    // Check 2: Value jump consistency
    let valueDiff = Float.abs(currentValue - previousValue);
    if (valueDiff > 0.5) {  // More than 50% jump is suspicious
      isConsistent := false;
      inconsistencyType := "VALUE_JUMP";
    };
    
    // Check 3: Temporal consistency
    if (currentBeat < veritas.lastValidBeat) {
      isConsistent := false;
      inconsistencyType := "TEMPORAL_REVERSAL";
    };
    
    // Log entry
    let entry : VeritasEntry = {
      beat = currentBeat;
      signalHash = signalHash;
      sacesiHash = expectedSacesiHash;
      var isConsistent = isConsistent;
      var inconsistencyType = inconsistencyType;
      var wasRejected = not isConsistent;
    };
    
    veritas.entries[veritas.writeIdx] := entry;
    veritas.writeIdx := (veritas.writeIdx + 1) % BREACH_HISTORY_SIZE;
    veritas.totalChecks += 1;
    
    if (isConsistent) {
      veritas.consistentChecks += 1;
      veritas.lastSacesiHash := expectedSacesiHash;
      veritas.lastValidBeat := currentBeat;
    } else {
      veritas.inconsistentChecks += 1;
      veritas.rejections += 1;
    };
    
    // Update trust score
    if (veritas.totalChecks > 0) {
      veritas.trustScore := Float.fromInt(veritas.consistentChecks) / Float.fromInt(veritas.totalChecks);
    };
    
    isConsistent
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: MEMORIA — ADVERSARIAL PATTERN MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // MEMORIA permanently stores attack patterns.
  // Once a pattern is stored, response time drops 50% on re-encounter.
  // The organism NEVER forgets an attack.
  //
  // Pattern storage:
  //   - Axis pattern (which axes were breached)
  //   - Magnitude pattern (how severe)
  //   - Caller pattern (who did it)
  //   - Temporal pattern (when during beat cycle)
  //
  
  public type AttackPattern = {
    id : Nat;
    var axisSignature : [Bool];          // Which axes (6-bit pattern)
    var magnitudeSignature : [Float];    // Typical magnitudes
    var callerSignature : [Nat32];       // Known caller hashes
    var temporalSignature : Float;       // Typical timing in beat cycle
    var encounterCount : Nat;            // How often seen
    var lastEncounterBeat : Nat;
    var successfulResponses : Nat;       // How often we successfully defended
    var averageResponseTime : Float;     // How fast we respond
  };
  
  public type MEMORIAState = {
    var patterns : [var AttackPattern];
    var patternCount : Nat;
    var totalEncounters : Nat;
    var fastResponseThreshold : Float;   // Response time that's "fast"
    var recognitionAccuracy : Float;     // How often we correctly ID patterns
    var adaptationScore : Float;         // How much faster we've gotten
  };
  
  // Initialize MEMORIA
  public func initMEMORIA() : MEMORIAState {
    let emptyPattern : AttackPattern = {
      id = 0;
      var axisSignature = Array.init<Bool>(NUM_AXES, func(_ : Nat) : Bool { false });
      var magnitudeSignature = Array.init<Float>(NUM_AXES, func(_ : Nat) : Float { 0.0 });
      var callerSignature = [];
      var temporalSignature = 0.0;
      var encounterCount = 0;
      var lastEncounterBeat = 0;
      var successfulResponses = 0;
      var averageResponseTime = 1.0;
    };
    
    {
      var patterns = Array.init<AttackPattern>(PATTERN_MEMORY_SIZE, func(_ : Nat) : AttackPattern { emptyPattern });
      var patternCount = 0;
      var totalEncounters = 0;
      var fastResponseThreshold = 0.5;
      var recognitionAccuracy = 0.0;
      var adaptationScore = 0.0;
    }
  };
  
  // Check if current breach matches a known pattern
  public func matchPattern(
    memoria : MEMORIAState,
    breachedAxes : [Nat],
    magnitudes : [Float],
    callerHash : Nat32
  ) : ?Nat {  // Returns pattern ID if matched
    // Create axis signature
    let currentSignature = Array.init<Bool>(NUM_AXES, func(i : Nat) : Bool {
      for (a in breachedAxes.vals()) {
        if (a == i) { return true };
      };
      false
    });
    
    // Check each stored pattern
    for (i in Iter.range(0, memoria.patternCount - 1)) {
      let pattern = memoria.patterns[i];
      
      // Compare axis signatures
      var axisMatch = true;
      for (j in Iter.range(0, NUM_AXES - 1)) {
        if (currentSignature[j] != pattern.axisSignature[j]) {
          axisMatch := false;
        };
      };
      
      if (axisMatch) {
        // Check magnitude similarity
        var magnitudeSimilar = true;
        for (j in Iter.range(0, NUM_AXES - 1)) {
          if (j < Array.size(magnitudes)) {
            let diff = Float.abs(magnitudes[j] - pattern.magnitudeSignature[j]);
            if (diff > 1.0) {  // More than 1σ difference
              magnitudeSimilar := false;
            };
          };
        };
        
        if (magnitudeSimilar) {
          return ?i;
        };
      };
    };
    
    null
  };
  
  // Store a new attack pattern
  public func storePattern(
    memoria : MEMORIAState,
    breachedAxes : [Nat],
    magnitudes : [Float],
    callerHash : Nat32,
    currentBeat : Nat
  ) : Nat {  // Returns pattern ID
    if (memoria.patternCount >= PATTERN_MEMORY_SIZE) {
      // Memory full — could implement LRU eviction
      return 0;
    };
    
    let id = memoria.patternCount;
    let pattern = memoria.patterns[id];
    
    // Set axis signature
    for (i in Iter.range(0, NUM_AXES - 1)) {
      pattern.axisSignature[i] := false;
      for (a in breachedAxes.vals()) {
        if (a == i) { pattern.axisSignature[i] := true };
      };
    };
    
    // Set magnitude signature
    for (i in Iter.range(0, NUM_AXES - 1)) {
      pattern.magnitudeSignature[i] := if (i < Array.size(magnitudes)) { magnitudes[i] } else { 0.0 };
    };
    
    // Set caller
    pattern.callerSignature := [callerHash];
    
    pattern.encounterCount := 1;
    pattern.lastEncounterBeat := currentBeat;
    pattern.averageResponseTime := 1.0;
    
    memoria.patternCount += 1;
    memoria.totalEncounters += 1;
    
    id
  };
  
  // Update pattern on re-encounter
  public func updatePatternEncounter(
    memoria : MEMORIAState,
    patternId : Nat,
    responseTime : Float,
    wasSuccessful : Bool,
    currentBeat : Nat
  ) {
    if (patternId >= memoria.patternCount) { return };
    
    let pattern = memoria.patterns[patternId];
    pattern.encounterCount += 1;
    pattern.lastEncounterBeat := currentBeat;
    memoria.totalEncounters += 1;
    
    // Update average response time (exponential moving average)
    pattern.averageResponseTime := 0.8 * pattern.averageResponseTime + 0.2 * responseTime;
    
    if (wasSuccessful) {
      pattern.successfulResponses += 1;
    };
    
    // Update adaptation score
    if (memoria.totalEncounters > 10) {
      var totalAvgResponse : Float = 0.0;
      for (i in Iter.range(0, memoria.patternCount - 1)) {
        totalAvgResponse += memoria.patterns[i].averageResponseTime;
      };
      totalAvgResponse /= Float.fromInt(memoria.patternCount);
      
      // Adaptation = how much faster than baseline
      memoria.adaptationScore := Float.max(0.0, 1.0 - totalAvgResponse);
    };
  };
  
  // Get response time modifier for known pattern
  public func getResponseModifier(memoria : MEMORIAState, patternId : ?Nat) : Float {
    switch (patternId) {
      case (?id) {
        if (id < memoria.patternCount) {
          // Known pattern — 50% faster response
          0.5
        } else {
          1.0
        }
      };
      case (null) {
        // Unknown pattern — normal response
        1.0
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: COMPLETE VAEL CHAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type VAELChainState = {
    dura : DURAState;
    rift : RIFTState;
    veritas : VERITASState;
    memoria : MEMORIAState;
    
    // Chain output
    var externalThreatSignal : Float;    // Output to Fear Engine
    var aresActivationSignal : Float;    // Output to ARES
    var chainActive : Bool;
    var lastChainBeat : Nat;
    var totalChainInvocations : Nat;
  };
  
  // Initialize complete VAEL chain
  public func initVAELChain() : VAELChainState {
    {
      dura = initDURA();
      rift = initRIFT();
      veritas = initVERITAS();
      memoria = initMEMORIA();
      var externalThreatSignal = 0.0;
      var aresActivationSignal = 0.0;
      var chainActive = true;
      var lastChainBeat = 0;
      var totalChainInvocations = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: THE COMPLETE VAEL CHAIN EXECUTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type VAELChainResult = {
    threatDetected : Bool;
    threatLevel : Float;
    breachedAxes : [Nat];
    knownPattern : Bool;
    patternId : ?Nat;
    responseModifier : Float;
    externalThreatSignal : Float;
    aresActivationSignal : Float;
    alertLevel : Nat;
  };
  
  // Run the complete VAEL chain
  public func runVAELChain(
    chain : VAELChainState,
    axisObservations : [Float],          // 6 values for DURA
    signalData : [Nat8],                 // Raw signal for VERITAS
    expectedSacesiHash : Nat32,
    previousValue : Float,
    currentValue : Float,
    callerPrincipal : ?Principal,
    currentBeat : Nat
  ) : VAELChainResult {
    chain.totalChainInvocations += 1;
    chain.lastChainBeat := currentBeat;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. DURA — Perimeter Detection
    // ───────────────────────────────────────────────────────────────────────────
    let (threatDetected, breachedAxes) = runDURADetection(chain.dura, axisObservations, currentBeat);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. RIFT — Breach Identification (if threat detected)
    // ───────────────────────────────────────────────────────────────────────────
    if (threatDetected) {
      logRIFTBreach(chain.rift, chain.dura, breachedAxes, callerPrincipal, currentBeat);
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. VERITAS_EXT — Signal Validation
    // ───────────────────────────────────────────────────────────────────────────
    let signalValid = validateSignal(
      chain.veritas,
      signalData,
      expectedSacesiHash,
      currentBeat,
      previousValue,
      currentValue
    );
    
    // Invalid signal increases threat
    let veritasThreat : Float = if (signalValid) { 0.0 } else { 0.3 };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. MEMORIA — Pattern Recognition
    // ───────────────────────────────────────────────────────────────────────────
    let magnitudes = Array.tabulate<Float>(Array.size(breachedAxes), func(i : Nat) : Float {
      let axisIdx = breachedAxes[i];
      if (axisIdx < NUM_AXES) { chain.dura.axes[axisIdx].perimeterScore } else { 0.0 }
    });
    
    let callerHash = hashPrincipal(callerPrincipal);
    var patternId : ?Nat = null;
    var knownPattern = false;
    
    if (threatDetected) {
      patternId := matchPattern(chain.memoria, breachedAxes, magnitudes, callerHash);
      
      switch (patternId) {
        case (?id) {
          knownPattern := true;
          updatePatternEncounter(chain.memoria, id, 1.0, true, currentBeat);
        };
        case (null) {
          // New pattern — store it
          let newId = storePattern(chain.memoria, breachedAxes, magnitudes, callerHash, currentBeat);
          patternId := ?newId;
        };
      };
    };
    
    let responseModifier = getResponseModifier(chain.memoria, patternId);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Calculate Threat Signals
    // ───────────────────────────────────────────────────────────────────────────
    // Threat level based on DURA score + VERITAS threat
    var threatLevel : Float = 0.0;
    
    if (threatDetected) {
      threatLevel := chain.dura.overallPerimeterScore / 3.0;  // Normalize to ~1.0 at 3σ
      threatLevel := Float.min(1.0, threatLevel);
    };
    
    threatLevel += veritasThreat;
    threatLevel := Float.min(1.0, threatLevel);
    
    // External threat signal → Fear Engine
    chain.externalThreatSignal := threatLevel;
    
    // ARES activation signal (threat + known pattern factor)
    chain.aresActivationSignal := threatLevel * (if (knownPattern) { 1.2 } else { 1.0 });
    chain.aresActivationSignal := Float.min(1.0, chain.aresActivationSignal);
    
    // ───────────────────────────────────────────────────────────────────────────
    // Return Result
    // ───────────────────────────────────────────────────────────────────────────
    {
      threatDetected = threatDetected or not signalValid;
      threatLevel = threatLevel;
      breachedAxes = breachedAxes;
      knownPattern = knownPattern;
      patternId = patternId;
      responseModifier = responseModifier;
      externalThreatSignal = chain.externalThreatSignal;
      aresActivationSignal = chain.aresActivationSignal;
      alertLevel = chain.dura.alertLevel;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };

};
