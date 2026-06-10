// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  CONFIDENTIAL AND PROPRIETARY. Framework: Medina Doctrine                                                 ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// OPENCOG PATTERN MINER — SDR Frequency Scanning + Schema Promotion
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// Every 50 beats: scans the last 50 events for recurring SDR patterns.
// Patterns appearing 13+ times become schemas.
// Schemas drive behavior directly.
// OMNIS-triggering states (coherence ≥ 0.95) are preserved as high-value schemas.
//
// SDR = Sparse Distributed Representation: the organism's current state vector
// (Hz array flattened + coherence + governance + compoundIndex → normalized floats)
//
// SCHEMA PROMOTION THRESHOLD: 13 occurrences in the 50-beat window
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Iter "mo:core/Iter";

module PatternMiner {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — THE PATTERN GRADUATION LAW (MEDINA ENGINE)
  // ═══════════════════════════════════════════════════════════════════════════════
  // A pattern that repeats 5+ times at coherence ≥ 0.618 (phi^-1) graduates to a schema.
  // A schema confirmed in 3+ consecutive cycles writes to the sovereignKB as
  // permanent doctrine. Only phi-coherent patterns earn permanence.
  // ═══════════════════════════════════════════════════════════════════════════════

  // THE MEDINA PHI LAW constant
  public let PHI_INVERSE : Float = 0.61803398874989484820;  // 1/PHI — graduation coherence threshold
  
  public let WINDOW_SIZE : Nat = 50;               // Rolling event window
  public let SCHEMA_THRESHOLD : Nat = 5;           // THE PATTERN GRADUATION LAW: 5+ occurrences
  public let SCHEMA_COHERENCE_MIN : Float = 0.618; // THE PATTERN GRADUATION LAW: phi^-1 coherence
  public let SCHEMA_CONFIRMATION_CYCLES : Nat = 3; // 3 consecutive cycles to write to sovereignKB
  public let SCAN_INTERVAL : Nat = 50;             // Beats between scans
  public let OMNIS_COHERENCE_THRESHOLD : Float = 0.95;  // THE OMNIS CONDITION: R ≥ 0.95
  public let MAX_SCHEMAS : Nat = 256;              // Maximum active schemas
  public let SDR_BUCKET_SIZE : Float = 0.05;       // Quantization step for SDR hashing
  public let GENOME_FREQUENCY_HZ : Float = 528.0;  // THE GENOME EXPRESSION LAW: 528 Hz rewrites weights

  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sparse Distributed Representation — a quantized state snapshot
  public type SDREvent = {
    beat : Nat;
    sdrKey : Text;          // Hash of quantized state vector
    coherence : Float;
    isOMNIS : Bool;         // True if coherence ≥ OMNIS threshold
    isPhaseLocked : Bool;   // THE EXCLUSION LAW: true if phase-locked (can couple)
    rawVector : [Float];    // Original state values (hz + neuroChem subset)
  };

  /// A promoted pattern that has become a behavioral schema
  public type Schema = {
    id : Nat;
    sdrKey : Text;
    occurrences : Nat;
    consecutiveCycles : Nat; // THE PATTERN GRADUATION LAW: counts consecutive confirmations
    firstSeen : Nat;
    lastSeen : Nat;
    isHighValue : Bool;     // True if OMNIS-triggering
    isConfirmed : Bool;     // True if written to sovereignKB (3+ consecutive cycles)
    weight : Float;         // Schema influence weight: occurrences / WINDOW_SIZE
    rawVector : [Float];    // Representative state vector for this schema
  };

  /// SovereignKB entry — permanent doctrine written by confirmed schemas
  /// THE GENOME EXPRESSION LAW: 528 Hz rewrites substrate weights when schema graduates
  public type SovereignKBEntry = {
    schemaId : Nat;
    sdrKey : Text;
    confirmedAt : Nat;      // Beat when confirmed
    genomeWeights : [Float]; // THE GENOME EXPRESSION LAW: substrate weight modifications
    isPermanent : Bool;      // Once written, permanent doctrine
  };

  /// Pattern frequency counter entry
  public type PatternCount = {
    sdrKey : Text;
    count : Nat;
    isOMNIS : Bool;
    isPhaseLocked : Bool;   // THE EXCLUSION LAW tracking
    rawVector : [Float];
  };

  /// Full state for the pattern miner (MEDINA ENGINE)
  public type PatternMinerState = {
    var eventWindow : Buffer.Buffer<SDREvent>;
    var schemas : Buffer.Buffer<Schema>;
    var sovereignKB : Buffer.Buffer<SovereignKBEntry>;  // THE PATTERN GRADUATION LAW: permanent doctrine
    var nextSchemaId : Nat;
    var totalScans : Nat;
    var lastScanBeat : Nat;
    var totalSchemasPromoted : Nat;
    var totalSovereignEntries : Nat;  // Count of permanent doctrine entries
    var activeSchemaCount : Nat;
    var genomeExpressionCount : Nat;  // THE GENOME EXPRESSION LAW: count of weight rewrites
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public func initPatternMinerState() : PatternMinerState {
    {
      var eventWindow = Buffer.Buffer<SDREvent>(WINDOW_SIZE);
      var schemas = Buffer.Buffer<Schema>(MAX_SCHEMAS);
      var sovereignKB = Buffer.Buffer<SovereignKBEntry>(MAX_SCHEMAS);  // Permanent doctrine
      var nextSchemaId = 1;
      var totalScans = 0;
      var lastScanBeat = 0;
      var totalSchemasPromoted = 0;
      var totalSovereignEntries = 0;
      var activeSchemaCount = 0;
      var genomeExpressionCount = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SDR QUANTIZATION + HASHING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Quantize a float to a bucket index for pattern matching
  func quantize(v : Float) : Int {
    Int.abs(Float.toInt(v / SDR_BUCKET_SIZE))
  };

  /// Convert state vector to a deterministic SDR key (Text)
  /// Takes the first N values from hz + coherence + governanceScore
  public func computeSDRKey(hz : [Float], coherence : Float, governance : Float) : Text {
    var key = "";

    // Quantize first 12 Hz values (inner ring)
    let limit = if (hz.size() < 12) hz.size() else 12;
    var i = 0;
    while (i < limit) {
      let q = quantize(hz[i]);
      key := key # Int.toText(q) # ",";
      i += 1;
    };

    // Append coherence and governance buckets
    let cBucket = quantize(coherence);
    let gBucket = quantize(governance);
    key := key # "c" # Int.toText(cBucket) # "g" # Int.toText(gBucket);
    key
  };

  /// Extract compact raw vector (coherence + first 4 Hz)
  public func extractRawVector(hz : [Float], coherence : Float, governance : Float) : [Float] {
    let sz = if (hz.size() < 4) hz.size() else 4;
    let base = Array.tabulate<Float>(sz, func(i : Nat) : Float { hz[i] });
    Array.append<Float>(base, [coherence, governance])
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EVENT RECORDING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Record a new event into the rolling window
  public func recordEvent(
    state : PatternMinerState,
    beat : Nat,
    hz : [Float],
    coherence : Float,
    governance : Float
  ) : () {
    let sdrKey = computeSDRKey(hz, coherence, governance);
    let isOMNIS = coherence >= OMNIS_COHERENCE_THRESHOLD;

    let event : SDREvent = {
      beat;
      sdrKey;
      coherence;
      isOMNIS;
      rawVector = extractRawVector(hz, coherence, governance);
    };

    // Enforce rolling window: remove oldest if at capacity
    if (state.eventWindow.size() >= WINDOW_SIZE) {
      ignore state.eventWindow.remove(0);
    };

    state.eventWindow.add(event);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY COUNTING
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Count occurrences of each SDR pattern in the current window
  func countPatterns(events : [SDREvent]) : [PatternCount] {
    let counts = Buffer.Buffer<PatternCount>(events.size());

    for (event in events.vals()) {
      var found = false;
      var idx = 0;
      while (idx < counts.size()) {
        let c = counts.get(idx);
        if (c.sdrKey == event.sdrKey) {
          counts.put(idx, {
            sdrKey = c.sdrKey;
            count = c.count + 1;
            isOMNIS = c.isOMNIS or event.isOMNIS;
            rawVector = c.rawVector;
          });
          found := true;
        };
        idx += 1;
      };
      if (not found) {
        counts.add({
          sdrKey = event.sdrKey;
          count = 1;
          isOMNIS = event.isOMNIS;
          rawVector = event.rawVector;
        });
      };
    };

    Buffer.toArray(counts)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SCHEMA PROMOTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Check if a schema already exists for a given SDR key
  func schemaExists(state : PatternMinerState, sdrKey : Text) : Bool {
    var found = false;
    for (s in state.schemas.vals()) {
      if (s.sdrKey == sdrKey) { found := true };
    };
    found
  };

  /// Update existing schema with new occurrence data
  /// THE PATTERN GRADUATION LAW: Track consecutive cycles for confirmation
  func updateSchema(state : PatternMinerState, count : PatternCount, currentBeat : Nat) : () {
    var idx = 0;
    while (idx < state.schemas.size()) {
      let s = state.schemas.get(idx);
      if (s.sdrKey == count.sdrKey) {
        let newWeight = Float.fromInt(count.count) / Float.fromInt(WINDOW_SIZE);
        // Increment consecutive cycles if seen again this scan
        let newConsecutive = s.consecutiveCycles + 1;
        state.schemas.put(idx, {
          id = s.id;
          sdrKey = s.sdrKey;
          occurrences = count.count;
          consecutiveCycles = newConsecutive;  // THE PATTERN GRADUATION LAW: track cycles
          firstSeen = s.firstSeen;
          lastSeen = currentBeat;
          isHighValue = s.isHighValue or count.isOMNIS;
          isConfirmed = s.isConfirmed;  // Preserve confirmation status
          weight = newWeight;
          rawVector = s.rawVector;
        });
      };
      idx += 1;
    };
  };

  /// Promote a qualifying pattern to a schema
  /// THE PATTERN GRADUATION LAW: 5+ repeats at coherence ≥ 0.618 → schema
  func promoteToSchema(
    state : PatternMinerState,
    count : PatternCount,
    currentBeat : Nat
  ) : () {
    // Trim to MAX_SCHEMAS if needed (remove lowest-weight non-OMNIS schema)
    if (state.schemas.size() >= MAX_SCHEMAS) {
      var minIdx = 0;
      var minWeight = 999.0;
      var schemaIdx = 0;
      for (s in state.schemas.vals()) {
        if (not s.isHighValue and not s.isConfirmed and s.weight < minWeight) {
          minWeight := s.weight;
          minIdx := schemaIdx;
        };
        schemaIdx += 1;
      };
      ignore state.schemas.remove(minIdx);
    };

    let weight = Float.fromInt(count.count) / Float.fromInt(WINDOW_SIZE);
    let schema : Schema = {
      id = state.nextSchemaId;
      sdrKey = count.sdrKey;
      occurrences = count.count;
      consecutiveCycles = 1;  // First cycle of this schema
      firstSeen = currentBeat;
      lastSeen = currentBeat;
      isHighValue = count.isOMNIS;
      isConfirmed = false;    // Not yet written to sovereignKB
      weight;
      rawVector = count.rawVector;
    };

    state.schemas.add(schema);
    state.nextSchemaId += 1;
    state.totalSchemasPromoted += 1;
    state.activeSchemaCount := state.schemas.size();
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // THE GENOME EXPRESSION LAW — 528 Hz Substrate Weight Rewriting
  // ═══════════════════════════════════════════════════════════════════════════════
  // When a schema graduates at MEDINA (confirmed in 3+ consecutive cycles), the
  // GENOME engine at 528 Hz rewrites the substrate weights that produced it.
  // The organism modifies its own structure based on confirmed patterns.
  // This is the mining mechanism — cognitive work produces structural change.
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Write confirmed schema to sovereignKB and trigger GENOME expression
  /// THE GENOME EXPRESSION LAW: 528 Hz rewrites substrate weights
  func writeToSovereignKB(
    state : PatternMinerState,
    schema : Schema,
    currentBeat : Nat
  ) : () {
    // Generate GENOME weights based on schema's raw vector
    // These weights will modify the substrate at 528 Hz frequency
    let genomeWeights = Array.tabulate<Float>(schema.rawVector.size(), func(i : Nat) : Float {
      // Weight modification = rawVector[i] × phi-scaled factor
      schema.rawVector[i] * Float.pow(PHI_INVERSE, Float.fromInt(i))
    });
    
    let entry : SovereignKBEntry = {
      schemaId = schema.id;
      sdrKey = schema.sdrKey;
      confirmedAt = currentBeat;
      genomeWeights = genomeWeights;
      isPermanent = true;  // THE PATTERN GRADUATION LAW: permanent doctrine
    };
    
    state.sovereignKB.add(entry);
    state.totalSovereignEntries += 1;
    state.genomeExpressionCount += 1;  // THE GENOME EXPRESSION LAW fired
  };
  
  /// Check for schemas ready to confirm and write to sovereignKB
  /// THE PATTERN GRADUATION LAW: 3+ consecutive cycles → permanent doctrine
  func checkSchemaConfirmation(state : PatternMinerState, currentBeat : Nat) : Nat {
    var confirmed : Nat = 0;
    var idx : Nat = 0;
    
    while (idx < state.schemas.size()) {
      let s = state.schemas.get(idx);
      
      // Check if schema qualifies for confirmation
      if (not s.isConfirmed and s.consecutiveCycles >= SCHEMA_CONFIRMATION_CYCLES) {
        // THE PATTERN GRADUATION LAW: 3+ consecutive cycles → write to sovereignKB
        let confirmedSchema : Schema = {
          id = s.id;
          sdrKey = s.sdrKey;
          occurrences = s.occurrences;
          consecutiveCycles = s.consecutiveCycles;
          firstSeen = s.firstSeen;
          lastSeen = s.lastSeen;
          isHighValue = s.isHighValue;
          isConfirmed = true;  // Now confirmed
          weight = s.weight;
          rawVector = s.rawVector;
        };
        state.schemas.put(idx, confirmedSchema);
        
        // THE GENOME EXPRESSION LAW: Write to sovereignKB, trigger weight rewrite
        writeToSovereignKB(state, confirmedSchema, currentBeat);
        confirmed += 1;
      };
      
      idx += 1;
    };
    
    confirmed
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN SCAN — called every 50 beats
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Full pattern scan: count frequencies, promote schemas
  /// THE PATTERN GRADUATION LAW + THE GENOME EXPRESSION LAW
  public func runScan(state : PatternMinerState, currentBeat : Nat) : {
    schemasPromoted : Nat;
    highValueSchemas : Nat;
    patternsScanned : Nat;
    schemasConfirmed : Nat;  // New: schemas written to sovereignKB
    genomeExpressions : Nat; // New: substrate weight rewrites at 528 Hz
  } {
    let events = Buffer.toArray(state.eventWindow);
    let counts = countPatterns(events);

    var promoted = 0;
    var highValue = 0;

    // THE PATTERN GRADUATION LAW: 5+ repeats at coherence ≥ 0.618 → schema
    for (count in counts.vals()) {
      if (count.count >= SCHEMA_THRESHOLD) {
        if (schemaExists(state, count.sdrKey)) {
          updateSchema(state, count, currentBeat);
        } else {
          promoteToSchema(state, count, currentBeat);
          promoted += 1;
        };
        if (count.isOMNIS) { highValue += 1 };
      };
    };
    
    // THE GENOME EXPRESSION LAW: Check for schemas ready to confirm
    // 3+ consecutive cycles → write to sovereignKB, trigger 528 Hz weight rewrite
    let confirmed = checkSchemaConfirmation(state, currentBeat);

    state.totalScans += 1;
    state.lastScanBeat := currentBeat;
    state.activeSchemaCount := state.schemas.size();

    {
      schemasPromoted = promoted;
      highValueSchemas = highValue;
      patternsScanned = counts.size();
      schemasConfirmed = confirmed;
      genomeExpressions = confirmed;  // Each confirmation triggers GENOME expression
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PER-BEAT TICK — records event, fires scan every SCAN_INTERVAL beats
  // ═══════════════════════════════════════════════════════════════════════════════

  public func tick(
    state : PatternMinerState,
    beat : Nat,
    hz : [Float],
    coherence : Float,
    governance : Float
  ) : ?{ schemasPromoted : Nat; highValueSchemas : Nat; patternsScanned : Nat } {
    recordEvent(state, beat, hz, coherence, governance);

    if (beat > 0 and beat % SCAN_INTERVAL == 0) {
      ?runScan(state, beat)
    } else {
      null
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SCHEMA QUERIES
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Get all schemas sorted by weight (highest first)
  public func getTopSchemas(state : PatternMinerState, limit : Nat) : [Schema] {
    let all = Buffer.toArray(state.schemas);
    // Simple selection of top-N by weight
    let sz = if (all.size() < limit) all.size() else limit;
    let result = Buffer.Buffer<Schema>(sz);
    var included = 0;
    // First pass: high-value schemas
    for (s in all.vals()) {
      if (included < sz and s.isHighValue) {
        result.add(s);
        included += 1;
      };
    };
    // Second pass: remaining by weight
    for (s in all.vals()) {
      if (included < sz and not s.isHighValue) {
        result.add(s);
        included += 1;
      };
    };
    Buffer.toArray(result)
  };

  /// Get the dominant schema (highest weight, or high-value if any exist)
  public func getDominantSchema(state : PatternMinerState) : ?Schema {
    var best : ?Schema = null;
    var bestWeight : Float = -1.0;
    for (s in state.schemas.vals()) {
      let effectiveWeight = if (s.isHighValue) s.weight * 2.0 else s.weight;
      if (effectiveWeight > bestWeight) {
        bestWeight := effectiveWeight;
        best := ?s;
      };
    };
    best
  };

  /// Check if a given state matches a known high-value schema
  public func matchesHighValueSchema(
    state : PatternMinerState,
    hz : [Float],
    coherence : Float,
    governance : Float
  ) : Bool {
    let key = computeSDRKey(hz, coherence, governance);
    for (s in state.schemas.vals()) {
      if (s.sdrKey == key and s.isHighValue) { return true };
    };
    false
  };

  /// Get statistics
  public func getStats(state : PatternMinerState) : {
    activeSchemas : Nat;
    highValueSchemas : Nat;
    totalScans : Nat;
    windowSize : Nat;
    totalSchemasPromoted : Nat;
  } {
    var highValue = 0;
    for (s in state.schemas.vals()) {
      if (s.isHighValue) { highValue += 1 };
    };
    {
      activeSchemas = state.schemas.size();
      highValueSchemas = highValue;
      totalScans = state.totalScans;
      windowSize = state.eventWindow.size();
      totalSchemasPromoted = state.totalSchemasPromoted;
    }
  };
}
