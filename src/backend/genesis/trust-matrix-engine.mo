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
// TRUST MATRIX ENGINE — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// TRUST MATRIX SYSTEM
//
// The Trust Matrix tracks trust relationships between entities, squads, and factions.
// Trust determines cooperation, trade, alliance formation, and conflict.
//
// TRUST LEVELS:
// -1.0 = Hostile (will attack on sight)
// -0.5 = Distrustful (avoid, won't cooperate)
//  0.0 = Neutral (no relationship)
// +0.5 = Friendly (will cooperate, trade)
// +1.0 = Allied (will defend, share resources)
//
// TRUST DYNAMICS:
// - Trust builds through positive interactions
// - Trust decays over time without interaction
// - Betrayal causes immediate trust drop
// - Faction trust affects individual trust baselines
//
// MATRIX STRUCTURE:
// - Entity-to-Entity: N×N sparse matrix
// - Squad-to-Squad: S×S dense matrix
// - Faction-to-Faction: 4×4 dense matrix
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";
import HashMap "mo:core/HashMap";

module TrustMatrixEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Trust bounds
  public let MIN_TRUST : Float = -1.0;
  public let MAX_TRUST : Float = 1.0;
  
  /// Trust thresholds
  public let HOSTILE_THRESHOLD : Float = -0.5;
  public let DISTRUSTFUL_THRESHOLD : Float = -0.25;
  public let NEUTRAL_THRESHOLD : Float = 0.25;
  public let FRIENDLY_THRESHOLD : Float = 0.5;
  public let ALLIED_THRESHOLD : Float = 0.75;
  
  /// Trust change rates
  public let POSITIVE_INTERACTION_GAIN : Float = 0.05;
  public let NEGATIVE_INTERACTION_LOSS : Float = 0.15;
  public let BETRAYAL_LOSS : Float = 0.5;
  public let NATURAL_DECAY_RATE : Float = 0.001;
  
  /// Number of factions
  public let NUM_FACTIONS : Nat = 4;
  
  /// Maximum tracked entity pairs (for sparse matrix)
  public let MAX_ENTITY_PAIRS : Nat = 10000;
  
  /// Maximum squads
  public let MAX_SQUADS : Nat = 100;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRUST LEVEL TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TrustLevel = {
    #Hostile;      // -1.0 to -0.5
    #Distrustful;  // -0.5 to -0.25
    #Neutral;      // -0.25 to 0.25
    #Friendly;     // 0.25 to 0.5
    #Allied;       // 0.5 to 1.0
  };
  
  public func trustValueToLevel(trust : Float) : TrustLevel {
    if (trust < HOSTILE_THRESHOLD) { #Hostile }
    else if (trust < DISTRUSTFUL_THRESHOLD) { #Distrustful }
    else if (trust < NEUTRAL_THRESHOLD) { #Neutral }
    else if (trust < ALLIED_THRESHOLD) { #Friendly }
    else { #Allied }
  };
  
  public func trustLevelToText(level : TrustLevel) : Text {
    switch (level) {
      case (#Hostile) { "Hostile" };
      case (#Distrustful) { "Distrustful" };
      case (#Neutral) { "Neutral" };
      case (#Friendly) { "Friendly" };
      case (#Allied) { "Allied" };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTERACTION TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type InteractionType = {
    #Trade;             // Successful trade
    #Gift;              // Resource sharing
    #Help;              // Helped in combat
    #Heal;              // Healed other
    #Patrol;            // Patrolled together
    #Formation;         // Maintained formation
    #Combat;            // Fought together against enemy
    #Attack;            // Attacked the other
    #Steal;             // Stole resources
    #Betray;            // Betrayed alliance
    #Abandon;           // Abandoned in danger
    #TerritoryViolation;// Entered territory without permission
    #Communication;     // Communicated successfully
  };
  
  public func interactionTrustChange(interaction : InteractionType) : Float {
    switch (interaction) {
      case (#Trade) { 0.05 };
      case (#Gift) { 0.1 };
      case (#Help) { 0.15 };
      case (#Heal) { 0.12 };
      case (#Patrol) { 0.02 };
      case (#Formation) { 0.01 };
      case (#Combat) { 0.08 };
      case (#Attack) { -0.3 };
      case (#Steal) { -0.25 };
      case (#Betray) { -0.5 };
      case (#Abandon) { -0.2 };
      case (#TerritoryViolation) { -0.1 };
      case (#Communication) { 0.03 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENTITY PAIR KEY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a canonical key for entity pair (order-independent)
  public func entityPairKey(entityA : Nat, entityB : Nat) : (Nat, Nat) {
    if (entityA < entityB) {
      (entityA, entityB)
    } else {
      (entityB, entityA)
    }
  };
  
  public func pairKeyToText(key : (Nat, Nat)) : Text {
    Nat.toText(key.0) # "_" # Nat.toText(key.1)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRUST RECORD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EntityTrustRecord = {
    entityA : Nat;
    entityB : Nat;
    trustValue : Float;
    level : TrustLevel;
    interactionCount : Nat;
    lastInteractionBeat : Nat;
    createdBeat : Nat;
  };
  
  public type SquadTrustRecord = {
    squadA : Nat;
    squadB : Nat;
    trustValue : Float;
    level : TrustLevel;
    memberInteractions : Nat;
    lastInteractionBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FACTION RELATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Faction = {
    #GAIA;
    #ARES;
    #VULCAN;
    #SENTINEL;
  };
  
  public func factionToNat(faction : Faction) : Nat {
    switch (faction) {
      case (#GAIA) { 0 };
      case (#ARES) { 1 };
      case (#VULCAN) { 2 };
      case (#SENTINEL) { 3 };
    }
  };
  
  public func natToFaction(n : Nat) : Faction {
    switch (n % 4) {
      case (0) { #GAIA };
      case (1) { #ARES };
      case (2) { #VULCAN };
      case (3) { #SENTINEL };
      case (_) { #GAIA };
    }
  };
  
  /// Initial faction relations matrix
  /// GAIA is peaceful, ARES is aggressive, VULCAN is mercantile, SENTINEL is defensive
  public let INITIAL_FACTION_RELATIONS : [[Float]] = [
    // GAIA  ARES  VULCAN SENTINEL
    [ 1.0, -0.3,  0.2,   0.3 ],  // GAIA
    [-0.3,  1.0, -0.1,  -0.4 ],  // ARES
    [ 0.2, -0.1,  1.0,   0.1 ],  // VULCAN
    [ 0.3, -0.4,  0.1,   1.0 ],  // SENTINEL
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRUST MATRIX STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TrustMatrixState = {
    // Entity-to-Entity trust (sparse)
    var entityTrust : HashMap.HashMap<Text, EntityTrustRecord>;
    var entityTrustCount : Nat;
    
    // Squad-to-Squad trust (dense)
    var squadTrust : [var [var Float]];
    var squadInteractions : [var [var Nat]];
    
    // Faction-to-Faction trust (dense)
    var factionTrust : [var [var Float]];
    var factionInteractions : [var [var Nat]];
    
    // Interaction history
    var recentInteractions : Buffer.Buffer<InteractionRecord>;
    var totalInteractions : Nat;
    
    // Statistics
    var averageEntityTrust : Float;
    var averageSquadTrust : Float;
    var averageFactionTrust : Float;
    
    // Timing
    var lastDecayBeat : Nat;
    var lastUpdateBeat : Nat;
  };
  
  public type InteractionRecord = {
    beat : Nat;
    interactionType : InteractionType;
    entityA : Nat;
    entityB : Nat;
    trustChange : Float;
    newTrust : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initTrustMatrixState() : TrustMatrixState {
    // Initialize faction trust from initial relations
    let factionTrust = Array.init<[var Float]>(NUM_FACTIONS, Array.init<Float>(NUM_FACTIONS, 0.0));
    let factionInteractions = Array.init<[var Nat]>(NUM_FACTIONS, Array.init<Nat>(NUM_FACTIONS, 0));
    
    for (i in Iter.range(0, NUM_FACTIONS - 1)) {
      for (j in Iter.range(0, NUM_FACTIONS - 1)) {
        factionTrust[i][j] := INITIAL_FACTION_RELATIONS[i][j];
      };
    };
    
    // Initialize squad trust
    let squadTrust = Array.init<[var Float]>(MAX_SQUADS, Array.init<Float>(MAX_SQUADS, 0.0));
    let squadInteractions = Array.init<[var Nat]>(MAX_SQUADS, Array.init<Nat>(MAX_SQUADS, 0));
    
    // Same faction squads start friendly
    for (i in Iter.range(0, MAX_SQUADS - 1)) {
      squadTrust[i][i] := 1.0;
    };
    
    {
      var entityTrust = HashMap.HashMap<Text, EntityTrustRecord>(MAX_ENTITY_PAIRS, Text.equal, Text.hash);
      var entityTrustCount = 0;
      var squadTrust = squadTrust;
      var squadInteractions = squadInteractions;
      var factionTrust = factionTrust;
      var factionInteractions = factionInteractions;
      var recentInteractions = Buffer.Buffer<InteractionRecord>(100);
      var totalInteractions = 0;
      var averageEntityTrust = 0.0;
      var averageSquadTrust = 0.0;
      var averageFactionTrust = 0.0;
      var lastDecayBeat = 0;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRUST RETRIEVAL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get trust between two entities
  public func getEntityTrust(
    state : TrustMatrixState,
    entityA : Nat,
    entityB : Nat
  ) : Float {
    let key = pairKeyToText(entityPairKey(entityA, entityB));
    switch (state.entityTrust.get(key)) {
      case (?record) { record.trustValue };
      case (null) { 0.0 }; // Default to neutral
    }
  };
  
  /// Get trust between two squads
  public func getSquadTrust(
    state : TrustMatrixState,
    squadA : Nat,
    squadB : Nat
  ) : Float {
    if (squadA >= MAX_SQUADS or squadB >= MAX_SQUADS) {
      return 0.0;
    };
    state.squadTrust[squadA][squadB]
  };
  
  /// Get trust between two factions
  public func getFactionTrust(
    state : TrustMatrixState,
    factionA : Faction,
    factionB : Faction
  ) : Float {
    let a = factionToNat(factionA);
    let b = factionToNat(factionB);
    state.factionTrust[a][b]
  };
  
  /// Get effective trust (combines entity + faction baseline)
  public func getEffectiveTrust(
    state : TrustMatrixState,
    entityA : Nat,
    entityB : Nat,
    factionA : Faction,
    factionB : Faction
  ) : Float {
    let entityTrust = getEntityTrust(state, entityA, entityB);
    let factionTrust = getFactionTrust(state, factionA, factionB);
    
    // Entity trust weighted 70%, faction baseline 30%
    entityTrust * 0.7 + factionTrust * 0.3
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRUST MODIFICATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Clamp trust to valid range
  public func clampTrust(trust : Float) : Float {
    Float.max(MIN_TRUST, Float.min(MAX_TRUST, trust))
  };
  
  /// Update trust between two entities
  public func updateEntityTrust(
    state : TrustMatrixState,
    entityA : Nat,
    entityB : Nat,
    change : Float,
    currentBeat : Nat
  ) : Float {
    let (keyA, keyB) = entityPairKey(entityA, entityB);
    let key = pairKeyToText((keyA, keyB));
    
    let currentRecord = state.entityTrust.get(key);
    let currentTrust = switch (currentRecord) {
      case (?r) { r.trustValue };
      case (null) { 0.0 };
    };
    
    let newTrust = clampTrust(currentTrust + change);
    let newLevel = trustValueToLevel(newTrust);
    
    let interactionCount = switch (currentRecord) {
      case (?r) { r.interactionCount + 1 };
      case (null) { 1 };
    };
    
    let createdBeat = switch (currentRecord) {
      case (?r) { r.createdBeat };
      case (null) { currentBeat };
    };
    
    let newRecord : EntityTrustRecord = {
      entityA = keyA;
      entityB = keyB;
      trustValue = newTrust;
      level = newLevel;
      interactionCount = interactionCount;
      lastInteractionBeat = currentBeat;
      createdBeat = createdBeat;
    };
    
    state.entityTrust.put(key, newRecord);
    
    if (Option.isNull(currentRecord)) {
      state.entityTrustCount += 1;
    };
    
    newTrust
  };
  
  /// Update trust between two squads
  public func updateSquadTrust(
    state : TrustMatrixState,
    squadA : Nat,
    squadB : Nat,
    change : Float
  ) : Float {
    if (squadA >= MAX_SQUADS or squadB >= MAX_SQUADS) {
      return 0.0;
    };
    
    let currentTrust = state.squadTrust[squadA][squadB];
    let newTrust = clampTrust(currentTrust + change);
    
    state.squadTrust[squadA][squadB] := newTrust;
    state.squadTrust[squadB][squadA] := newTrust; // Symmetric
    state.squadInteractions[squadA][squadB] += 1;
    state.squadInteractions[squadB][squadA] += 1;
    
    newTrust
  };
  
  /// Update trust between two factions
  public func updateFactionTrust(
    state : TrustMatrixState,
    factionA : Faction,
    factionB : Faction,
    change : Float
  ) : Float {
    let a = factionToNat(factionA);
    let b = factionToNat(factionB);
    
    let currentTrust = state.factionTrust[a][b];
    let newTrust = clampTrust(currentTrust + change);
    
    state.factionTrust[a][b] := newTrust;
    state.factionTrust[b][a] := newTrust; // Symmetric
    state.factionInteractions[a][b] += 1;
    state.factionInteractions[b][a] += 1;
    
    newTrust
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTERACTION PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Record an interaction and update trust
  public func recordInteraction(
    state : TrustMatrixState,
    entityA : Nat,
    entityB : Nat,
    interactionType : InteractionType,
    currentBeat : Nat
  ) : Float {
    let trustChange = interactionTrustChange(interactionType);
    let newTrust = updateEntityTrust(state, entityA, entityB, trustChange, currentBeat);
    
    // Record interaction
    let record : InteractionRecord = {
      beat = currentBeat;
      interactionType = interactionType;
      entityA = entityA;
      entityB = entityB;
      trustChange = trustChange;
      newTrust = newTrust;
    };
    
    state.recentInteractions.add(record);
    state.totalInteractions += 1;
    
    newTrust
  };
  
  /// Record squad-level interaction
  public func recordSquadInteraction(
    state : TrustMatrixState,
    squadA : Nat,
    squadB : Nat,
    interactionType : InteractionType
  ) : Float {
    let trustChange = interactionTrustChange(interactionType);
    updateSquadTrust(state, squadA, squadB, trustChange)
  };
  
  /// Record faction-level interaction
  public func recordFactionInteraction(
    state : TrustMatrixState,
    factionA : Faction,
    factionB : Faction,
    interactionType : InteractionType
  ) : Float {
    let trustChange = interactionTrustChange(interactionType) * 0.1; // Faction changes are slower
    updateFactionTrust(state, factionA, factionB, trustChange)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRUST DECAY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply natural decay to all trust relationships
  public func applyDecay(state : TrustMatrixState, currentBeat : Nat) : () {
    let beatsElapsed = currentBeat - state.lastDecayBeat;
    if (beatsElapsed == 0) { return; };
    
    let decayAmount = NATURAL_DECAY_RATE * Float.fromInt(beatsElapsed);
    
    // Decay entity trust toward neutral
    for ((key, record) in state.entityTrust.entries()) {
      let trust = record.trustValue;
      let newTrust = if (trust > 0.0) {
        Float.max(0.0, trust - decayAmount)
      } else if (trust < 0.0) {
        Float.min(0.0, trust + decayAmount)
      } else {
        0.0
      };
      
      state.entityTrust.put(key, {
        entityA = record.entityA;
        entityB = record.entityB;
        trustValue = newTrust;
        level = trustValueToLevel(newTrust);
        interactionCount = record.interactionCount;
        lastInteractionBeat = record.lastInteractionBeat;
        createdBeat = record.createdBeat;
      });
    };
    
    // Decay squad trust toward neutral
    for (i in Iter.range(0, MAX_SQUADS - 1)) {
      for (j in Iter.range(0, MAX_SQUADS - 1)) {
        if (i != j) {
          let trust = state.squadTrust[i][j];
          let newTrust = if (trust > 0.0) {
            Float.max(0.0, trust - decayAmount)
          } else if (trust < 0.0) {
            Float.min(0.0, trust + decayAmount)
          } else {
            0.0
          };
          state.squadTrust[i][j] := newTrust;
        };
      };
    };
    
    // Faction trust decays very slowly toward initial values
    for (i in Iter.range(0, NUM_FACTIONS - 1)) {
      for (j in Iter.range(0, NUM_FACTIONS - 1)) {
        if (i != j) {
          let current = state.factionTrust[i][j];
          let initial = INITIAL_FACTION_RELATIONS[i][j];
          let diff = current - initial;
          let newTrust = current - diff * decayAmount * 0.1;
          state.factionTrust[i][j] := newTrust;
        };
      };
    };
    
    state.lastDecayBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update trust statistics
  public func updateStatistics(state : TrustMatrixState) : () {
    // Entity trust average
    if (state.entityTrustCount > 0) {
      var sum : Float = 0.0;
      for ((_, record) in state.entityTrust.entries()) {
        sum += record.trustValue;
      };
      state.averageEntityTrust := sum / Float.fromInt(state.entityTrustCount);
    };
    
    // Squad trust average
    var squadSum : Float = 0.0;
    var squadCount : Nat = 0;
    for (i in Iter.range(0, MAX_SQUADS - 1)) {
      for (j in Iter.range(i + 1, MAX_SQUADS - 1)) {
        squadSum += state.squadTrust[i][j];
        squadCount += 1;
      };
    };
    if (squadCount > 0) {
      state.averageSquadTrust := squadSum / Float.fromInt(squadCount);
    };
    
    // Faction trust average
    var factionSum : Float = 0.0;
    var factionCount : Nat = 0;
    for (i in Iter.range(0, NUM_FACTIONS - 1)) {
      for (j in Iter.range(i + 1, NUM_FACTIONS - 1)) {
        factionSum += state.factionTrust[i][j];
        factionCount += 1;
      };
    };
    if (factionCount > 0) {
      state.averageFactionTrust := factionSum / Float.fromInt(factionCount);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get trust matrix summary
  public func getSummary(state : TrustMatrixState) : {
    entityPairs : Nat;
    averageEntityTrust : Float;
    averageSquadTrust : Float;
    averageFactionTrust : Float;
    totalInteractions : Nat;
  } {
    {
      entityPairs = state.entityTrustCount;
      averageEntityTrust = state.averageEntityTrust;
      averageSquadTrust = state.averageSquadTrust;
      averageFactionTrust = state.averageFactionTrust;
      totalInteractions = state.totalInteractions;
    }
  };
  
  /// Get faction relations matrix
  public func getFactionRelationsMatrix(state : TrustMatrixState) : [[Float]] {
    let matrix = Array.tabulate<[Float]>(NUM_FACTIONS, func (i : Nat) : [Float] {
      Array.freeze(state.factionTrust[i])
    });
    matrix
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(state : TrustMatrixState, currentBeat : Nat) : () {
    // Apply decay periodically
    if (currentBeat - state.lastDecayBeat >= 10) {
      applyDecay(state, currentBeat);
    };
    
    // Update statistics periodically
    if (currentBeat - state.lastUpdateBeat >= 50) {
      updateStatistics(state);
      state.lastUpdateBeat := currentBeat;
      
      // Prune old interactions
      if (state.recentInteractions.size() > 500) {
        let recent = Buffer.Buffer<InteractionRecord>(250);
        for (i in Iter.range(state.recentInteractions.size() - 250, state.recentInteractions.size() - 1)) {
          recent.add(state.recentInteractions.get(i));
        };
        state.recentInteractions := recent;
      };
    };
  };

}
