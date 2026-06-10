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
// ENTITY POPULATION MANAGEMENT — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// SUPER ORGANISM ENTITY MANAGEMENT
//
// The organism contains up to 500+ individual entities (ants, bees, etc.)
// Each entity has:
// - Position in world
// - Faction alignment
// - Behavioral drive
// - Health/Energy
// - Caste type
// - Squad assignment
// - Individual brain weights (42 weights per entity)
//
// ENTITY LIFECYCLE:
// 1. SPAWN: Created based on population needs and resources
// 2. LIVE: Acts based on drives, learns from environment
// 3. REPRODUCE: May spawn offspring with inherited traits
// 4. DIE: Natural death, combat death, or sacrifice
//
// POPULATION DYNAMICS:
// - Minimum population: 50 entities
// - Maximum population: 500 entities
// - Spawn rate: Proportional to resources and coherence
// - Death rate: Varies by faction (ARES higher than GAIA)
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";
import HashMap "mo:core/HashMap";

module EntityPopulationManagement {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let MIN_POPULATION : Nat = 50;
  public let MAX_POPULATION : Nat = 500;
  public let INITIAL_POPULATION : Nat = 100;
  
  public let SQUAD_SIZE : Nat = 6;
  public let MAX_SQUADS : Nat = 100;
  
  public let WEIGHTS_PER_ENTITY : Nat = 42;
  public let SOVEREIGN_FLOOR : Float = 0.75;
  
  public let BASE_HEALTH : Float = 100.0;
  public let BASE_ENERGY : Float = 100.0;
  public let BASE_SPEED : Float = 1.0;
  
  public let SPAWN_COOLDOWN : Nat = 10;
  public let DEATH_ANNOUNCEMENT_DURATION : Nat = 5;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FACTION TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Faction = {
    #GAIA;      // 0 - Nature, balance, sustainability
    #ARES;      // 1 - War, aggression, sacrifice
    #VULCAN;    // 2 - Industry, building, economy
    #SENTINEL;  // 3 - Protection, defense, order
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
  
  public let FACTION_COLORS : [(Nat8, Nat8, Nat8)] = [
    (0, 200, 100),    // GAIA - Green
    (200, 50, 50),    // ARES - Red
    (200, 150, 50),   // VULCAN - Orange
    (50, 100, 200),   // SENTINEL - Blue
  ];
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BEHAVIORAL DRIVES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Drive = {
    #FORAGE;    // 0 - Gather resources
    #PATROL;    // 1 - Patrol territory
    #COMBAT;    // 2 - Engage enemies
    #BUILD;     // 3 - Construct structures
    #NURTURE;   // 4 - Care for others
  };
  
  public func driveToNat(drive : Drive) : Nat {
    switch (drive) {
      case (#FORAGE) { 0 };
      case (#PATROL) { 1 };
      case (#COMBAT) { 2 };
      case (#BUILD) { 3 };
      case (#NURTURE) { 4 };
    }
  };
  
  public func natToDrive(n : Nat) : Drive {
    switch (n % 5) {
      case (0) { #FORAGE };
      case (1) { #PATROL };
      case (2) { #COMBAT };
      case (3) { #BUILD };
      case (4) { #NURTURE };
      case (_) { #FORAGE };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CASTE TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Caste = {
    #Worker;     // Standard
    #Soldier;    // Combat specialist
    #Scout;      // Exploration specialist
    #Nurse;      // Healing specialist
    #Engineer;   // Building specialist
    #Queen;      // Spawning specialist
  };
  
  public func casteToNat(caste : Caste) : Nat {
    switch (caste) {
      case (#Worker) { 0 };
      case (#Soldier) { 1 };
      case (#Scout) { 2 };
      case (#Nurse) { 3 };
      case (#Engineer) { 4 };
      case (#Queen) { 5 };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENTITY STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EntityState = {
    id : Nat;
    
    // Position (world coordinates)
    x : Float;
    y : Float;
    
    // Alignment
    faction : Faction;
    drive : Drive;
    caste : Caste;
    
    // Stats
    health : Float;      // [0, maxHealth]
    maxHealth : Float;
    energy : Float;      // [0, maxEnergy]
    maxEnergy : Float;
    speed : Float;
    attackPower : Float;
    defensePower : Float;
    
    // Brain (42 Hebbian weights)
    weights : [Float];
    learningRate : Float;
    
    // Social
    squadId : ?Nat;
    parentId : ?Nat;
    generation : Nat;
    
    // Temporal
    bornBeat : Nat;
    lastActionBeat : Nat;
    lastDamageBeat : Nat;
    
    // State flags
    isAlive : Bool;
    isResting : Bool;
    isFleeing : Bool;
    isAttacking : Bool;
    
    // Target
    targetEntityId : ?Nat;
    targetX : ?Float;
    targetY : ?Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SQUAD STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SquadState = {
    id : Nat;
    memberIds : [Nat];
    leaderId : Nat;
    faction : Faction;
    formation : Formation;
    centerX : Float;
    centerY : Float;
    targetX : ?Float;
    targetY : ?Float;
    cohesion : Float;
    createdBeat : Nat;
  };
  
  public type Formation = {
    #Wedge;
    #Line;
    #Circle;
    #Scatter;
    #Column;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // DEATH RECORD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeathCause = {
    #Natural;
    #Combat;
    #Sacrifice;
    #Starvation;
    #Exposure;
  };
  
  public type DeathRecord = {
    entityId : Nat;
    faction : Faction;
    caste : Caste;
    position : (Float, Float);
    cause : DeathCause;
    killedBy : ?Nat;
    beat : Nat;
    age : Nat; // Beats lived
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // POPULATION STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PopulationState = {
    // Entity storage
    var entities : Buffer.Buffer<EntityState>;
    var entityIndex : HashMap.HashMap<Nat, Nat>; // ID → buffer index
    var nextEntityId : Nat;
    
    // Squad storage
    var squads : Buffer.Buffer<SquadState>;
    var squadIndex : HashMap.HashMap<Nat, Nat>;
    var nextSquadId : Nat;
    
    // Population counts
    var totalAlive : Nat;
    var totalDead : Nat;
    var byFaction : [var Nat];   // 4 factions
    var byDrive : [var Nat];     // 5 drives
    var byCaste : [var Nat];     // 6 castes
    
    // Death records (recent)
    var recentDeaths : Buffer.Buffer<DeathRecord>;
    var totalDeathsLifetime : Nat;
    
    // Spawn state
    var lastSpawnBeat : Nat;
    var spawnCooldown : Nat;
    var spawnQueue : Nat;
    
    // Statistics
    var averageHealth : Float;
    var averageEnergy : Float;
    var averageAge : Float;
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initPopulationState() : PopulationState {
    {
      var entities = Buffer.Buffer<EntityState>(INITIAL_POPULATION);
      var entityIndex = HashMap.HashMap<Nat, Nat>(INITIAL_POPULATION, Nat.equal, Nat32.fromNat);
      var nextEntityId = 0;
      var squads = Buffer.Buffer<SquadState>(MAX_SQUADS);
      var squadIndex = HashMap.HashMap<Nat, Nat>(MAX_SQUADS, Nat.equal, Nat32.fromNat);
      var nextSquadId = 0;
      var totalAlive = 0;
      var totalDead = 0;
      var byFaction = Array.init<Nat>(4, 0);
      var byDrive = Array.init<Nat>(5, 0);
      var byCaste = Array.init<Nat>(6, 0);
      var recentDeaths = Buffer.Buffer<DeathRecord>(100);
      var totalDeathsLifetime = 0;
      var lastSpawnBeat = 0;
      var spawnCooldown = SPAWN_COOLDOWN;
      var spawnQueue = 0;
      var averageHealth = BASE_HEALTH;
      var averageEnergy = BASE_ENERGY;
      var averageAge = 0.0;
      var lastUpdateBeat = 0;
    }
  };
  
  /// Initialize entity with default weights at sovereign floor
  public func initEntityWeights() : [Float] {
    Array.tabulate<Float>(WEIGHTS_PER_ENTITY, func (_) : Float { SOVEREIGN_FLOOR })
  };
  
  /// Create a new entity
  public func createEntity(
    state : PopulationState,
    x : Float,
    y : Float,
    faction : Faction,
    caste : Caste,
    parentId : ?Nat,
    currentBeat : Nat
  ) : ?EntityState {
    if (state.totalAlive >= MAX_POPULATION) { return null; };
    
    let id = state.nextEntityId;
    state.nextEntityId += 1;
    
    // Determine initial drive based on caste
    let drive = switch (caste) {
      case (#Worker) { #FORAGE };
      case (#Soldier) { #COMBAT };
      case (#Scout) { #PATROL };
      case (#Nurse) { #NURTURE };
      case (#Engineer) { #BUILD };
      case (#Queen) { #NURTURE };
    };
    
    // Get parent generation
    let generation = switch (parentId) {
      case (?pid) {
        switch (state.entityIndex.get(pid)) {
          case (?idx) { state.entities.get(idx).generation + 1 };
          case (null) { 0 };
        };
      };
      case (null) { 0 };
    };
    
    let entity : EntityState = {
      id = id;
      x = x;
      y = y;
      faction = faction;
      drive = drive;
      caste = caste;
      health = BASE_HEALTH;
      maxHealth = BASE_HEALTH;
      energy = BASE_ENERGY;
      maxEnergy = BASE_ENERGY;
      speed = BASE_SPEED;
      attackPower = if (caste == #Soldier) { 15.0 } else { 10.0 };
      defensePower = if (caste == #Soldier) { 12.0 } else { 8.0 };
      weights = initEntityWeights();
      learningRate = 0.01;
      squadId = null;
      parentId = parentId;
      generation = generation;
      bornBeat = currentBeat;
      lastActionBeat = currentBeat;
      lastDamageBeat = 0;
      isAlive = true;
      isResting = false;
      isFleeing = false;
      isAttacking = false;
      targetEntityId = null;
      targetX = null;
      targetY = null;
    };
    
    // Add to storage
    let idx = state.entities.size();
    state.entities.add(entity);
    state.entityIndex.put(id, idx);
    
    // Update counts
    state.totalAlive += 1;
    state.byFaction[factionToNat(faction)] += 1;
    state.byDrive[driveToNat(drive)] += 1;
    state.byCaste[casteToNat(caste)] += 1;
    
    ?entity
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENTITY DEATH
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Kill an entity
  public func killEntity(
    state : PopulationState,
    entityId : Nat,
    cause : DeathCause,
    killedBy : ?Nat,
    currentBeat : Nat
  ) : Bool {
    switch (state.entityIndex.get(entityId)) {
      case (null) { return false; };
      case (?idx) {
        let entity = state.entities.get(idx);
        
        if (not entity.isAlive) { return false; };
        
        // Create death record
        let death : DeathRecord = {
          entityId = entityId;
          faction = entity.faction;
          caste = entity.caste;
          position = (entity.x, entity.y);
          cause = cause;
          killedBy = killedBy;
          beat = currentBeat;
          age = currentBeat - entity.bornBeat;
        };
        
        state.recentDeaths.add(death);
        state.totalDeathsLifetime += 1;
        
        // Update entity
        state.entities.put(idx, {
          id = entity.id;
          x = entity.x;
          y = entity.y;
          faction = entity.faction;
          drive = entity.drive;
          caste = entity.caste;
          health = 0.0;
          maxHealth = entity.maxHealth;
          energy = 0.0;
          maxEnergy = entity.maxEnergy;
          speed = entity.speed;
          attackPower = entity.attackPower;
          defensePower = entity.defensePower;
          weights = entity.weights;
          learningRate = entity.learningRate;
          squadId = entity.squadId;
          parentId = entity.parentId;
          generation = entity.generation;
          bornBeat = entity.bornBeat;
          lastActionBeat = entity.lastActionBeat;
          lastDamageBeat = entity.lastDamageBeat;
          isAlive = false;
          isResting = false;
          isFleeing = false;
          isAttacking = false;
          targetEntityId = null;
          targetX = null;
          targetY = null;
        });
        
        // Update counts
        state.totalAlive -= 1;
        state.totalDead += 1;
        state.byFaction[factionToNat(entity.faction)] -= 1;
        state.byDrive[driveToNat(entity.drive)] -= 1;
        state.byCaste[casteToNat(entity.caste)] -= 1;
        
        true
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SQUAD MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a new squad
  public func createSquad(
    state : PopulationState,
    memberIds : [Nat],
    faction : Faction,
    currentBeat : Nat
  ) : ?SquadState {
    if (memberIds.size() == 0) { return null; };
    
    // Calculate center position
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var count : Nat = 0;
    
    for (memberId in memberIds.vals()) {
      switch (state.entityIndex.get(memberId)) {
        case (?idx) {
          let entity = state.entities.get(idx);
          sumX += entity.x;
          sumY += entity.y;
          count += 1;
        };
        case (null) {};
      };
    };
    
    if (count == 0) { return null; };
    
    let centerX = sumX / Float.fromInt(count);
    let centerY = sumY / Float.fromInt(count);
    
    // Select leader (first member)
    let leaderId = memberIds[0];
    
    let id = state.nextSquadId;
    state.nextSquadId += 1;
    
    let squad : SquadState = {
      id = id;
      memberIds = memberIds;
      leaderId = leaderId;
      faction = faction;
      formation = #Wedge;
      centerX = centerX;
      centerY = centerY;
      targetX = null;
      targetY = null;
      cohesion = 1.0;
      createdBeat = currentBeat;
    };
    
    let idx = state.squads.size();
    state.squads.add(squad);
    state.squadIndex.put(id, idx);
    
    // Assign squad to members
    for (memberId in memberIds.vals()) {
      switch (state.entityIndex.get(memberId)) {
        case (?entityIdx) {
          let entity = state.entities.get(entityIdx);
          state.entities.put(entityIdx, {
            id = entity.id;
            x = entity.x;
            y = entity.y;
            faction = entity.faction;
            drive = entity.drive;
            caste = entity.caste;
            health = entity.health;
            maxHealth = entity.maxHealth;
            energy = entity.energy;
            maxEnergy = entity.maxEnergy;
            speed = entity.speed;
            attackPower = entity.attackPower;
            defensePower = entity.defensePower;
            weights = entity.weights;
            learningRate = entity.learningRate;
            squadId = ?id;
            parentId = entity.parentId;
            generation = entity.generation;
            bornBeat = entity.bornBeat;
            lastActionBeat = entity.lastActionBeat;
            lastDamageBeat = entity.lastDamageBeat;
            isAlive = entity.isAlive;
            isResting = entity.isResting;
            isFleeing = entity.isFleeing;
            isAttacking = entity.isAttacking;
            targetEntityId = entity.targetEntityId;
            targetX = entity.targetX;
            targetY = entity.targetY;
          });
        };
        case (null) {};
      };
    };
    
    ?squad
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // POPULATION SPAWNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Evaluate spawn conditions
  public func shouldSpawn(
    state : PopulationState,
    coherence : Float,
    resources : Float,
    currentBeat : Nat
  ) : Bool {
    // Check cooldown
    if (currentBeat - state.lastSpawnBeat < state.spawnCooldown) {
      return false;
    };
    
    // Check population cap
    if (state.totalAlive >= MAX_POPULATION) {
      return false;
    };
    
    // Check minimum conditions
    if (coherence < 0.3 or resources < 10.0) {
      return false;
    };
    
    // Probability-based spawn
    let spawnProbability = coherence * (resources / 100.0) * 
                          Float.fromInt(MAX_POPULATION - state.totalAlive) / Float.fromInt(MAX_POPULATION);
    
    // Simple deterministic for backend (frontend can add randomness)
    spawnProbability > 0.5
  };
  
  /// Spawn new entities to maintain minimum population
  public func maintainPopulation(
    state : PopulationState,
    coherence : Float,
    currentBeat : Nat
  ) : Nat {
    var spawned : Nat = 0;
    
    while (state.totalAlive < MIN_POPULATION) {
      // Distribute across factions
      let factionToSpawn = natToFaction(state.nextEntityId % 4);
      
      // Random position (simplified - use biome centers in practice)
      let x = Float.fromInt(state.nextEntityId * 7 % 100) - 50.0;
      let y = Float.fromInt(state.nextEntityId * 13 % 100) - 50.0;
      
      // Mostly workers
      let caste : Caste = if (state.nextEntityId % 10 == 0) {
        #Soldier
      } else if (state.nextEntityId % 7 == 0) {
        #Scout
      } else {
        #Worker
      };
      
      switch (createEntity(state, x, y, factionToSpawn, caste, null, currentBeat)) {
        case (?_) { spawned += 1; };
        case (null) {};
      };
    };
    
    state.lastSpawnBeat := currentBeat;
    spawned
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING FOR ENTITIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update entity weights based on reward signal
  public func updateEntityWeights(
    state : PopulationState,
    entityId : Nat,
    reward : Float
  ) : Bool {
    switch (state.entityIndex.get(entityId)) {
      case (null) { return false; };
      case (?idx) {
        let entity = state.entities.get(idx);
        
        if (not entity.isAlive) { return false; };
        
        // Update weights based on reward
        let newWeights = Array.tabulate<Float>(WEIGHTS_PER_ENTITY, func (i : Nat) : Float {
          let currentWeight = entity.weights[i];
          let delta = entity.learningRate * reward;
          let newWeight = currentWeight + delta;
          
          // Enforce sovereign floor
          Float.max(SOVEREIGN_FLOOR, Float.min(1.0, newWeight))
        });
        
        state.entities.put(idx, {
          id = entity.id;
          x = entity.x;
          y = entity.y;
          faction = entity.faction;
          drive = entity.drive;
          caste = entity.caste;
          health = entity.health;
          maxHealth = entity.maxHealth;
          energy = entity.energy;
          maxEnergy = entity.maxEnergy;
          speed = entity.speed;
          attackPower = entity.attackPower;
          defensePower = entity.defensePower;
          weights = newWeights;
          learningRate = entity.learningRate;
          squadId = entity.squadId;
          parentId = entity.parentId;
          generation = entity.generation;
          bornBeat = entity.bornBeat;
          lastActionBeat = entity.lastActionBeat;
          lastDamageBeat = entity.lastDamageBeat;
          isAlive = entity.isAlive;
          isResting = entity.isResting;
          isFleeing = entity.isFleeing;
          isAttacking = entity.isAttacking;
          targetEntityId = entity.targetEntityId;
          targetX = entity.targetX;
          targetY = entity.targetY;
        });
        
        true
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update population statistics
  public func updateStatistics(state : PopulationState, currentBeat : Nat) : () {
    if (state.totalAlive == 0) {
      state.averageHealth := 0.0;
      state.averageEnergy := 0.0;
      state.averageAge := 0.0;
      return;
    };
    
    var sumHealth : Float = 0.0;
    var sumEnergy : Float = 0.0;
    var sumAge : Float = 0.0;
    var count : Nat = 0;
    
    for (entity in state.entities.vals()) {
      if (entity.isAlive) {
        sumHealth += entity.health;
        sumEnergy += entity.energy;
        sumAge += Float.fromInt(currentBeat - entity.bornBeat);
        count += 1;
      };
    };
    
    let n = Float.fromInt(count);
    state.averageHealth := sumHealth / n;
    state.averageEnergy := sumEnergy / n;
    state.averageAge := sumAge / n;
  };
  
  /// Get population census
  public func getCensus(state : PopulationState) : {
    totalAlive : Nat;
    totalDead : Nat;
    byFaction : [Nat];
    byDrive : [Nat];
    byCaste : [Nat];
    averageHealth : Float;
    averageEnergy : Float;
    averageAge : Float;
    squadCount : Nat;
  } {
    {
      totalAlive = state.totalAlive;
      totalDead = state.totalDead;
      byFaction = Array.freeze(state.byFaction);
      byDrive = Array.freeze(state.byDrive);
      byCaste = Array.freeze(state.byCaste);
      averageHealth = state.averageHealth;
      averageEnergy = state.averageEnergy;
      averageAge = state.averageAge;
      squadCount = state.squads.size();
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(
    state : PopulationState,
    currentBeat : Nat,
    coherence : Float
  ) : () {
    // Maintain minimum population
    ignore maintainPopulation(state, coherence, currentBeat);
    
    // Update statistics
    updateStatistics(state, currentBeat);
    
    // Prune old death records
    if (state.recentDeaths.size() > 100) {
      let recent = Buffer.Buffer<DeathRecord>(100);
      for (i in Iter.range(state.recentDeaths.size() - 100, state.recentDeaths.size() - 1)) {
        recent.add(state.recentDeaths.get(i));
      };
      state.recentDeaths := recent;
    };
    
    state.lastUpdateBeat := currentBeat;
  };

}
