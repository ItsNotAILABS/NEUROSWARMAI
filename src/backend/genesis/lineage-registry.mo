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
// LINEAGE REGISTRY — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// LINEAGE REGISTRY SYSTEM
//
// Tracks the genealogical history of all entities in the organism.
// Records parent-child relationships, inheritance patterns, and generational data.
//
// FEATURES:
// - Parent-child relationship tracking
// - Multi-generational ancestry lookup
// - Descendant tree traversal
// - Trait inheritance tracking
// - Lineage-based statistics
// - Extinction detection
//
// LINEAGE DATA:
// - Entity ID → Parent ID
// - Generation number
// - Birth beat
// - Death beat (if deceased)
// - Inherited traits
// - Mutation record
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

module LineageRegistry {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum ancestry depth to track
  public let MAX_ANCESTRY_DEPTH : Nat = 20;
  
  /// Maximum lineage records
  public let MAX_LINEAGE_RECORDS : Nat = 50000;
  
  /// Traits tracked per entity
  public let TRAITS_PER_ENTITY : Nat = 10;
  
  /// Minimum inheritance rate
  public let MIN_INHERITANCE_RATE : Float = 0.5;
  
  /// Maximum inheritance rate
  public let MAX_INHERITANCE_RATE : Float = 0.95;
  
  /// Mutation probability
  public let BASE_MUTATION_RATE : Float = 0.05;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FACTION AND CASTE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Faction = {
    #GAIA;
    #ARES;
    #VULCAN;
    #SENTINEL;
  };
  
  public type Caste = {
    #Worker;
    #Soldier;
    #Scout;
    #Nurse;
    #Engineer;
    #Queen;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRAIT TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TraitType = {
    #Strength;
    #Speed;
    #Intelligence;
    #Endurance;
    #Aggression;
    #Cooperation;
    #ResourceEfficiency;
    #HealingRate;
    #SenseRange;
    #LearningRate;
  };
  
  public func traitTypeToIndex(trait : TraitType) : Nat {
    switch (trait) {
      case (#Strength) { 0 };
      case (#Speed) { 1 };
      case (#Intelligence) { 2 };
      case (#Endurance) { 3 };
      case (#Aggression) { 4 };
      case (#Cooperation) { 5 };
      case (#ResourceEfficiency) { 6 };
      case (#HealingRate) { 7 };
      case (#SenseRange) { 8 };
      case (#LearningRate) { 9 };
    }
  };
  
  public func indexToTraitType(n : Nat) : TraitType {
    switch (n % 10) {
      case (0) { #Strength };
      case (1) { #Speed };
      case (2) { #Intelligence };
      case (3) { #Endurance };
      case (4) { #Aggression };
      case (5) { #Cooperation };
      case (6) { #ResourceEfficiency };
      case (7) { #HealingRate };
      case (8) { #SenseRange };
      case (9) { #LearningRate };
      case (_) { #Strength };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LINEAGE RECORD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LineageRecord = {
    // Identity
    entityId : Nat;
    parentId : ?Nat;            // null if primordial
    generation : Nat;           // 0 for primordial
    
    // Faction/Caste
    faction : Faction;
    caste : Caste;
    
    // Timing
    bornBeat : Nat;
    deathBeat : ?Nat;           // null if alive
    
    // Traits (10 values, each [0, 1])
    traits : [Float];
    
    // Inheritance
    inheritedTraits : [Float];   // What was inherited from parent
    mutations : [Float];         // Mutations applied
    inheritanceRate : Float;     // How much was inherited (0.5-0.95)
    
    // Children
    childIds : [Nat];
    totalDescendants : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GENERATION STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GenerationStats = {
    generation : Nat;
    totalBorn : Nat;
    totalDead : Nat;
    currentlyAlive : Nat;
    averageLifespan : Float;
    averageTraits : [Float];
    byFaction : [Nat];
    byCaste : [Nat];
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // LINEAGE REGISTRY STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type LineageRegistryState = {
    // Main registry
    var records : HashMap.HashMap<Nat, LineageRecord>;
    var totalRecords : Nat;
    
    // Indexes
    var recordsByGeneration : HashMap.HashMap<Nat, Buffer.Buffer<Nat>>;
    var recordsByFaction : [var Buffer.Buffer<Nat>];
    var recordsByCaste : [var Buffer.Buffer<Nat>];
    
    // Generation tracking
    var currentMaxGeneration : Nat;
    var generationStats : HashMap.HashMap<Nat, GenerationStats>;
    
    // Primordial entities (generation 0)
    var primordialCount : Nat;
    var primordialIds : Buffer.Buffer<Nat>;
    
    // Statistics
    var totalBirths : Nat;
    var totalDeaths : Nat;
    var averageGeneration : Float;
    var averageInheritanceRate : Float;
    var averageMutationMagnitude : Float;
    
    // Living entity tracking
    var livingCount : Nat;
    var livingByGeneration : HashMap.HashMap<Nat, Nat>;
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initLineageRegistryState() : LineageRegistryState {
    let recordsByFaction = Array.init<Buffer.Buffer<Nat>>(4, Buffer.Buffer<Nat>(1000));
    let recordsByCaste = Array.init<Buffer.Buffer<Nat>>(6, Buffer.Buffer<Nat>(1000));
    
    {
      var records = HashMap.HashMap<Nat, LineageRecord>(MAX_LINEAGE_RECORDS, Nat.equal, Nat32.fromNat);
      var totalRecords = 0;
      var recordsByGeneration = HashMap.HashMap<Nat, Buffer.Buffer<Nat>>(50, Nat.equal, Nat32.fromNat);
      var recordsByFaction = recordsByFaction;
      var recordsByCaste = recordsByCaste;
      var currentMaxGeneration = 0;
      var generationStats = HashMap.HashMap<Nat, GenerationStats>(50, Nat.equal, Nat32.fromNat);
      var primordialCount = 0;
      var primordialIds = Buffer.Buffer<Nat>(100);
      var totalBirths = 0;
      var totalDeaths = 0;
      var averageGeneration = 0.0;
      var averageInheritanceRate = 0.75;
      var averageMutationMagnitude = 0.05;
      var livingCount = 0;
      var livingByGeneration = HashMap.HashMap<Nat, Nat>(50, Nat.equal, Nat32.fromNat);
      var lastUpdateBeat = 0;
    }
  };
  
  /// Generate default traits
  public func defaultTraits() : [Float] {
    Array.tabulate<Float>(TRAITS_PER_ENTITY, func (_) : Float { 0.5 })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TRAIT INHERITANCE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate inherited traits from parent
  public func calculateInheritedTraits(
    parentTraits : [Float],
    inheritanceRate : Float
  ) : [Float] {
    Array.tabulate<Float>(TRAITS_PER_ENTITY, func (i : Nat) : Float {
      if (i < parentTraits.size()) {
        parentTraits[i] * inheritanceRate
      } else {
        0.5 * inheritanceRate
      }
    })
  };
  
  /// Apply mutations to traits
  public func applyMutations(
    inheritedTraits : [Float],
    mutationRate : Float,
    seed : Nat  // Use for deterministic "randomness"
  ) : ([Float], [Float]) {
    let mutations = Array.tabulate<Float>(TRAITS_PER_ENTITY, func (i : Nat) : Float {
      // Simple deterministic "random" mutation
      let mutationSeed = (seed * 17 + i * 31) % 1000;
      let shouldMutate = Float.fromInt(mutationSeed) / 1000.0 < mutationRate;
      
      if (shouldMutate) {
        let mutationMagnitude = (Float.fromInt((mutationSeed * 7) % 100) / 100.0 - 0.5) * 0.2;
        mutationMagnitude
      } else {
        0.0
      }
    });
    
    let finalTraits = Array.tabulate<Float>(TRAITS_PER_ENTITY, func (i : Nat) : Float {
      Float.max(0.0, Float.min(1.0, inheritedTraits[i] + mutations[i]))
    });
    
    (finalTraits, mutations)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BIRTH REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Register a primordial entity (no parent)
  public func registerPrimordial(
    state : LineageRegistryState,
    entityId : Nat,
    faction : Faction,
    caste : Caste,
    traits : [Float],
    currentBeat : Nat
  ) : ?LineageRecord {
    if (state.totalRecords >= MAX_LINEAGE_RECORDS) {
      return null;
    };
    
    let record : LineageRecord = {
      entityId = entityId;
      parentId = null;
      generation = 0;
      faction = faction;
      caste = caste;
      bornBeat = currentBeat;
      deathBeat = null;
      traits = traits;
      inheritedTraits = defaultTraits();
      mutations = Array.tabulate<Float>(TRAITS_PER_ENTITY, func (_) : Float { 0.0 });
      inheritanceRate = 0.0;
      childIds = [];
      totalDescendants = 0;
    };
    
    state.records.put(entityId, record);
    state.totalRecords += 1;
    state.primordialCount += 1;
    state.primordialIds.add(entityId);
    state.totalBirths += 1;
    state.livingCount += 1;
    
    // Update indexes
    addToGenerationIndex(state, 0, entityId);
    updateLivingByGeneration(state, 0, 1);
    
    ?record
  };
  
  /// Register a birth (has parent)
  public func registerBirth(
    state : LineageRegistryState,
    entityId : Nat,
    parentId : Nat,
    faction : Faction,
    caste : Caste,
    currentBeat : Nat
  ) : ?LineageRecord {
    if (state.totalRecords >= MAX_LINEAGE_RECORDS) {
      return null;
    };
    
    // Get parent record
    switch (state.records.get(parentId)) {
      case (null) { return null; };
      case (?parent) {
        // Calculate inheritance
        let inheritanceRate = MIN_INHERITANCE_RATE + 
          (Float.fromInt(entityId % 45) / 100.0); // 0.5 to 0.95
        
        let inheritedTraits = calculateInheritedTraits(parent.traits, inheritanceRate);
        let (finalTraits, mutations) = applyMutations(inheritedTraits, BASE_MUTATION_RATE, entityId);
        
        let generation = parent.generation + 1;
        
        let record : LineageRecord = {
          entityId = entityId;
          parentId = ?parentId;
          generation = generation;
          faction = faction;
          caste = caste;
          bornBeat = currentBeat;
          deathBeat = null;
          traits = finalTraits;
          inheritedTraits = inheritedTraits;
          mutations = mutations;
          inheritanceRate = inheritanceRate;
          childIds = [];
          totalDescendants = 0;
        };
        
        state.records.put(entityId, record);
        state.totalRecords += 1;
        state.totalBirths += 1;
        state.livingCount += 1;
        
        // Update parent's child list
        let newChildIds = Array.append(parent.childIds, [entityId]);
        state.records.put(parentId, {
          entityId = parent.entityId;
          parentId = parent.parentId;
          generation = parent.generation;
          faction = parent.faction;
          caste = parent.caste;
          bornBeat = parent.bornBeat;
          deathBeat = parent.deathBeat;
          traits = parent.traits;
          inheritedTraits = parent.inheritedTraits;
          mutations = parent.mutations;
          inheritanceRate = parent.inheritanceRate;
          childIds = newChildIds;
          totalDescendants = parent.totalDescendants + 1;
        });
        
        // Update ancestor descendant counts
        updateAncestorDescendants(state, parentId);
        
        // Update indexes
        addToGenerationIndex(state, generation, entityId);
        updateLivingByGeneration(state, generation, 1);
        
        // Update max generation
        if (generation > state.currentMaxGeneration) {
          state.currentMaxGeneration := generation;
        };
        
        ?record
      };
    }
  };
  
  /// Helper to add entity to generation index
  func addToGenerationIndex(state : LineageRegistryState, generation : Nat, entityId : Nat) : () {
    switch (state.recordsByGeneration.get(generation)) {
      case (?buffer) { buffer.add(entityId) };
      case (null) {
        let buffer = Buffer.Buffer<Nat>(100);
        buffer.add(entityId);
        state.recordsByGeneration.put(generation, buffer);
      };
    };
  };
  
  /// Helper to update living count by generation
  func updateLivingByGeneration(state : LineageRegistryState, generation : Nat, delta : Int) : () {
    let current = switch (state.livingByGeneration.get(generation)) {
      case (?n) { n };
      case (null) { 0 };
    };
    let newCount = if (delta > 0) {
      current + Int.abs(delta)
    } else {
      if (current > Int.abs(delta)) { current - Int.abs(delta) } else { 0 }
    };
    state.livingByGeneration.put(generation, newCount);
  };
  
  /// Update ancestor descendant counts
  func updateAncestorDescendants(state : LineageRegistryState, entityId : Nat) : () {
    var currentId = entityId;
    var depth : Nat = 0;
    
    while (depth < MAX_ANCESTRY_DEPTH) {
      switch (state.records.get(currentId)) {
        case (null) { return; };
        case (?record) {
          switch (record.parentId) {
            case (null) { return; };
            case (?pid) {
              switch (state.records.get(pid)) {
                case (null) { return; };
                case (?parent) {
                  state.records.put(pid, {
                    entityId = parent.entityId;
                    parentId = parent.parentId;
                    generation = parent.generation;
                    faction = parent.faction;
                    caste = parent.caste;
                    bornBeat = parent.bornBeat;
                    deathBeat = parent.deathBeat;
                    traits = parent.traits;
                    inheritedTraits = parent.inheritedTraits;
                    mutations = parent.mutations;
                    inheritanceRate = parent.inheritanceRate;
                    childIds = parent.childIds;
                    totalDescendants = parent.totalDescendants + 1;
                  });
                  currentId := pid;
                };
              };
            };
          };
        };
      };
      depth += 1;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DEATH REGISTRATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Register entity death
  public func registerDeath(
    state : LineageRegistryState,
    entityId : Nat,
    currentBeat : Nat
  ) : Bool {
    switch (state.records.get(entityId)) {
      case (null) { return false; };
      case (?record) {
        if (Option.isSome(record.deathBeat)) {
          return false; // Already dead
        };
        
        state.records.put(entityId, {
          entityId = record.entityId;
          parentId = record.parentId;
          generation = record.generation;
          faction = record.faction;
          caste = record.caste;
          bornBeat = record.bornBeat;
          deathBeat = ?currentBeat;
          traits = record.traits;
          inheritedTraits = record.inheritedTraits;
          mutations = record.mutations;
          inheritanceRate = record.inheritanceRate;
          childIds = record.childIds;
          totalDescendants = record.totalDescendants;
        });
        
        state.totalDeaths += 1;
        state.livingCount -= 1;
        updateLivingByGeneration(state, record.generation, -1);
        
        true
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ANCESTRY QUERIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get ancestry chain (entity → parent → grandparent → ...)
  public func getAncestry(
    state : LineageRegistryState,
    entityId : Nat,
    maxDepth : Nat
  ) : [Nat] {
    let ancestry = Buffer.Buffer<Nat>(maxDepth);
    var currentId = entityId;
    var depth : Nat = 0;
    
    while (depth < maxDepth) {
      switch (state.records.get(currentId)) {
        case (null) { return Buffer.toArray(ancestry); };
        case (?record) {
          switch (record.parentId) {
            case (null) { return Buffer.toArray(ancestry); };
            case (?pid) {
              ancestry.add(pid);
              currentId := pid;
            };
          };
        };
      };
      depth += 1;
    };
    
    Buffer.toArray(ancestry)
  };
  
  /// Get direct children
  public func getChildren(
    state : LineageRegistryState,
    entityId : Nat
  ) : [Nat] {
    switch (state.records.get(entityId)) {
      case (null) { [] };
      case (?record) { record.childIds };
    }
  };
  
  /// Get all descendants (children + grandchildren + ...)
  public func getDescendants(
    state : LineageRegistryState,
    entityId : Nat,
    maxDepth : Nat
  ) : [Nat] {
    let descendants = Buffer.Buffer<Nat>(100);
    let toProcess = Buffer.Buffer<(Nat, Nat)>(100); // (entityId, depth)
    
    toProcess.add((entityId, 0));
    
    while (toProcess.size() > 0) {
      let (currentId, depth) = toProcess.get(0);
      // Remove first element (simple simulation)
      let newToProcess = Buffer.Buffer<(Nat, Nat)>(toProcess.size());
      for (i in Iter.range(1, toProcess.size() - 1)) {
        newToProcess.add(toProcess.get(i));
      };
      
      if (depth < maxDepth) {
        switch (state.records.get(currentId)) {
          case (null) {};
          case (?record) {
            for (childId in record.childIds.vals()) {
              descendants.add(childId);
              newToProcess.add((childId, depth + 1));
            };
          };
        };
      };
      
      // Continue with remaining
      for (item in newToProcess.vals()) {
        toProcess.add(item);
      };
    };
    
    Buffer.toArray(descendants)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate generation statistics
  public func calculateGenerationStats(
    state : LineageRegistryState,
    generation : Nat,
    currentBeat : Nat
  ) : ?GenerationStats {
    switch (state.recordsByGeneration.get(generation)) {
      case (null) { return null; };
      case (?entityIds) {
        if (entityIds.size() == 0) { return null; };
        
        var totalBorn : Nat = entityIds.size();
        var totalDead : Nat = 0;
        var currentlyAlive : Nat = 0;
        var totalLifespan : Float = 0.0;
        var traitSums = Array.init<Float>(TRAITS_PER_ENTITY, 0.0);
        var byFaction = Array.init<Nat>(4, 0);
        var byCaste = Array.init<Nat>(6, 0);
        
        for (entityId in entityIds.vals()) {
          switch (state.records.get(entityId)) {
            case (null) {};
            case (?record) {
              // Alive/Dead
              switch (record.deathBeat) {
                case (?deathBeat) {
                  totalDead += 1;
                  totalLifespan += Float.fromInt(deathBeat - record.bornBeat);
                };
                case (null) {
                  currentlyAlive += 1;
                  totalLifespan += Float.fromInt(currentBeat - record.bornBeat);
                };
              };
              
              // Traits
              for (i in Iter.range(0, TRAITS_PER_ENTITY - 1)) {
                if (i < record.traits.size()) {
                  traitSums[i] += record.traits[i];
                };
              };
              
              // Faction
              let factionIdx = switch (record.faction) {
                case (#GAIA) { 0 };
                case (#ARES) { 1 };
                case (#VULCAN) { 2 };
                case (#SENTINEL) { 3 };
              };
              byFaction[factionIdx] += 1;
              
              // Caste
              let casteIdx = switch (record.caste) {
                case (#Worker) { 0 };
                case (#Soldier) { 1 };
                case (#Scout) { 2 };
                case (#Nurse) { 3 };
                case (#Engineer) { 4 };
                case (#Queen) { 5 };
              };
              byCaste[casteIdx] += 1;
            };
          };
        };
        
        let n = Float.fromInt(totalBorn);
        let averageTraits = Array.tabulate<Float>(TRAITS_PER_ENTITY, func (i : Nat) : Float {
          traitSums[i] / n
        });
        
        let stats : GenerationStats = {
          generation = generation;
          totalBorn = totalBorn;
          totalDead = totalDead;
          currentlyAlive = currentlyAlive;
          averageLifespan = totalLifespan / n;
          averageTraits = averageTraits;
          byFaction = Array.freeze(byFaction);
          byCaste = Array.freeze(byCaste);
        };
        
        state.generationStats.put(generation, stats);
        
        ?stats
      };
    }
  };
  
  /// Update registry statistics
  public func updateStatistics(state : LineageRegistryState) : () {
    if (state.totalRecords == 0) { return; };
    
    var generationSum : Float = 0.0;
    var inheritanceSum : Float = 0.0;
    var mutationSum : Float = 0.0;
    var mutationCount : Nat = 0;
    
    for ((_, record) in state.records.entries()) {
      generationSum += Float.fromInt(record.generation);
      inheritanceSum += record.inheritanceRate;
      
      for (m in record.mutations.vals()) {
        mutationSum += Float.abs(m);
        mutationCount += 1;
      };
    };
    
    let n = Float.fromInt(state.totalRecords);
    state.averageGeneration := generationSum / n;
    state.averageInheritanceRate := inheritanceSum / n;
    
    if (mutationCount > 0) {
      state.averageMutationMagnitude := mutationSum / Float.fromInt(mutationCount);
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get registry summary
  public func getSummary(state : LineageRegistryState) : {
    totalRecords : Nat;
    livingCount : Nat;
    totalBirths : Nat;
    totalDeaths : Nat;
    primordialCount : Nat;
    maxGeneration : Nat;
    averageGeneration : Float;
    averageInheritanceRate : Float;
  } {
    {
      totalRecords = state.totalRecords;
      livingCount = state.livingCount;
      totalBirths = state.totalBirths;
      totalDeaths = state.totalDeaths;
      primordialCount = state.primordialCount;
      maxGeneration = state.currentMaxGeneration;
      averageGeneration = state.averageGeneration;
      averageInheritanceRate = state.averageInheritanceRate;
    }
  };
  
  /// Get entity lineage record
  public func getRecord(
    state : LineageRegistryState,
    entityId : Nat
  ) : ?LineageRecord {
    state.records.get(entityId)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(state : LineageRegistryState, currentBeat : Nat) : () {
    // Update statistics periodically
    if (currentBeat - state.lastUpdateBeat >= 100) {
      updateStatistics(state);
      state.lastUpdateBeat := currentBeat;
    };
  };

}
