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
// TERRITORY GRID MANAGEMENT — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// WORLD TERRITORY GRID
//
// The world is divided into a 20×20 grid of territory nodes (400 total).
// Each node belongs to a biome and can be controlled by a faction.
//
// GRID STRUCTURE:
// - 20×20 = 400 territory nodes
// - Each node: ~100×100 world units
// - Total world size: 2000×2000 world units
//
// NODE PROPERTIES:
// - Owner faction (GAIA, ARES, VULCAN, SENTINEL, or neutral)
// - Biome type (36 types across 3 climate zones)
// - Resources (regenerating)
// - Coherence (local stability)
// - Danger level (combat history)
// - Entity count (population density)
//
// TERRITORY MECHANICS:
// - Control changes based on faction presence
// - Resources regenerate over time
// - Adjacent node influences
// - Sacrifice drops coherence in nearby nodes
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module TerritoryGridManagement {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let GRID_WIDTH : Nat = 20;
  public let GRID_HEIGHT : Nat = 20;
  public let TOTAL_NODES : Nat = 400;
  
  public let NODE_SIZE : Float = 100.0; // World units per node
  public let WORLD_WIDTH : Float = 2000.0;
  public let WORLD_HEIGHT : Float = 2000.0;
  
  public let RESOURCE_REGEN_RATE : Float = 0.01;
  public let MAX_RESOURCES : Float = 100.0;
  public let COHERENCE_DECAY_RATE : Float = 0.001;
  public let COHERENCE_RECOVERY_RATE : Float = 0.005;
  
  public let CONTROL_THRESHOLD : Float = 0.6; // Faction needs 60% presence to control
  public let CONTROL_DECAY_RATE : Float = 0.01;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FACTION TYPES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Faction = {
    #Neutral;   // 0 - No faction control
    #GAIA;      // 1 - Nature
    #ARES;      // 2 - War
    #VULCAN;    // 3 - Industry
    #SENTINEL;  // 4 - Defense
  };
  
  public func factionToNat(faction : Faction) : Nat {
    switch (faction) {
      case (#Neutral) { 0 };
      case (#GAIA) { 1 };
      case (#ARES) { 2 };
      case (#VULCAN) { 3 };
      case (#SENTINEL) { 4 };
    }
  };
  
  public func natToFaction(n : Nat) : Faction {
    switch (n % 5) {
      case (0) { #Neutral };
      case (1) { #GAIA };
      case (2) { #ARES };
      case (3) { #VULCAN };
      case (4) { #SENTINEL };
      case (_) { #Neutral };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CLIMATE ZONES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ClimateZone = {
    #Temperate;  // Moderate temperatures
    #Arid;       // Hot and dry
    #Frigid;     // Cold
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BIOME TYPES (36 total - 12 per climate zone)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BiomeType = {
    // TEMPERATE (0-11)
    #DeciduousForest;    // 0
    #MixedForest;        // 1
    #Grassland;          // 2
    #Wetland;            // 3
    #RiverValley;        // 4
    #LakeRegion;         // 5
    #Meadow;             // 6
    #Hills;              // 7
    #Coast;              // 8
    #Estuary;            // 9
    #FarmlandPlains;     // 10
    #TemperateRainforest;// 11
    
    // ARID (12-23)
    #Desert;             // 12
    #SandDunes;          // 13
    #Oasis;              // 14
    #Savanna;            // 15
    #Scrubland;          // 16
    #Badlands;           // 17
    #Canyon;             // 18
    #Mesa;               // 19
    #SaltFlat;           // 20
    #DriedRiverbed;      // 21
    #RockyOutcrop;       // 22
    #AridGrassland;      // 23
    
    // FRIGID (24-35)
    #Tundra;             // 24
    #IceSheet;           // 25
    #Glacier;            // 26
    #FrozenForest;       // 27
    #SnowPlains;         // 28
    #Permafrost;         // 29
    #IceCaves;           // 30
    #FrozenLake;         // 31
    #MountainPeak;       // 32
    #AlpineMeadow;       // 33
    #FrozenCoast;        // 34
    #TaigaForest;        // 35
  };
  
  public func biomeToNat(biome : BiomeType) : Nat {
    switch (biome) {
      // Temperate
      case (#DeciduousForest) { 0 };
      case (#MixedForest) { 1 };
      case (#Grassland) { 2 };
      case (#Wetland) { 3 };
      case (#RiverValley) { 4 };
      case (#LakeRegion) { 5 };
      case (#Meadow) { 6 };
      case (#Hills) { 7 };
      case (#Coast) { 8 };
      case (#Estuary) { 9 };
      case (#FarmlandPlains) { 10 };
      case (#TemperateRainforest) { 11 };
      // Arid
      case (#Desert) { 12 };
      case (#SandDunes) { 13 };
      case (#Oasis) { 14 };
      case (#Savanna) { 15 };
      case (#Scrubland) { 16 };
      case (#Badlands) { 17 };
      case (#Canyon) { 18 };
      case (#Mesa) { 19 };
      case (#SaltFlat) { 20 };
      case (#DriedRiverbed) { 21 };
      case (#RockyOutcrop) { 22 };
      case (#AridGrassland) { 23 };
      // Frigid
      case (#Tundra) { 24 };
      case (#IceSheet) { 25 };
      case (#Glacier) { 26 };
      case (#FrozenForest) { 27 };
      case (#SnowPlains) { 28 };
      case (#Permafrost) { 29 };
      case (#IceCaves) { 30 };
      case (#FrozenLake) { 31 };
      case (#MountainPeak) { 32 };
      case (#AlpineMeadow) { 33 };
      case (#FrozenCoast) { 34 };
      case (#TaigaForest) { 35 };
    }
  };
  
  public func getClimateZone(biome : BiomeType) : ClimateZone {
    let n = biomeToNat(biome);
    if (n < 12) { #Temperate }
    else if (n < 24) { #Arid }
    else { #Frigid }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // BIOME PROPERTIES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BiomeProperties = {
    baseResources : Float;       // Resource generation rate
    movementCost : Float;        // Movement speed modifier (1.0 = normal)
    defensibility : Float;       // Defense bonus
    visibility : Float;          // Line of sight modifier
    harshness : Float;           // Environmental damage
    baseCoherence : Float;       // Default coherence level
  };
  
  public func getBiomeProperties(biome : BiomeType) : BiomeProperties {
    switch (biome) {
      // Temperate biomes - balanced
      case (#DeciduousForest) { { baseResources = 80.0; movementCost = 1.2; defensibility = 0.8; visibility = 0.6; harshness = 0.1; baseCoherence = 0.9 } };
      case (#MixedForest) { { baseResources = 75.0; movementCost = 1.3; defensibility = 0.85; visibility = 0.5; harshness = 0.1; baseCoherence = 0.85 } };
      case (#Grassland) { { baseResources = 60.0; movementCost = 0.9; defensibility = 0.5; visibility = 1.0; harshness = 0.05; baseCoherence = 0.95 } };
      case (#Wetland) { { baseResources = 90.0; movementCost = 1.5; defensibility = 0.7; visibility = 0.7; harshness = 0.15; baseCoherence = 0.8 } };
      case (#RiverValley) { { baseResources = 100.0; movementCost = 1.1; defensibility = 0.6; visibility = 0.8; harshness = 0.05; baseCoherence = 0.95 } };
      case (#LakeRegion) { { baseResources = 85.0; movementCost = 1.4; defensibility = 0.6; visibility = 0.9; harshness = 0.1; baseCoherence = 0.9 } };
      case (#Meadow) { { baseResources = 65.0; movementCost = 0.85; defensibility = 0.4; visibility = 1.0; harshness = 0.02; baseCoherence = 1.0 } };
      case (#Hills) { { baseResources = 50.0; movementCost = 1.3; defensibility = 0.9; visibility = 1.2; harshness = 0.1; baseCoherence = 0.85 } };
      case (#Coast) { { baseResources = 70.0; movementCost = 1.0; defensibility = 0.5; visibility = 1.0; harshness = 0.1; baseCoherence = 0.9 } };
      case (#Estuary) { { baseResources = 95.0; movementCost = 1.4; defensibility = 0.55; visibility = 0.8; harshness = 0.1; baseCoherence = 0.85 } };
      case (#FarmlandPlains) { { baseResources = 110.0; movementCost = 0.8; defensibility = 0.3; visibility = 1.0; harshness = 0.02; baseCoherence = 1.0 } };
      case (#TemperateRainforest) { { baseResources = 120.0; movementCost = 1.4; defensibility = 0.9; visibility = 0.4; harshness = 0.15; baseCoherence = 0.8 } };
      
      // Arid biomes - low resources, high visibility
      case (#Desert) { { baseResources = 15.0; movementCost = 1.1; defensibility = 0.3; visibility = 1.5; harshness = 0.4; baseCoherence = 0.6 } };
      case (#SandDunes) { { baseResources = 10.0; movementCost = 1.5; defensibility = 0.4; visibility = 1.3; harshness = 0.45; baseCoherence = 0.55 } };
      case (#Oasis) { { baseResources = 90.0; movementCost = 0.9; defensibility = 0.5; visibility = 0.9; harshness = 0.1; baseCoherence = 0.95 } };
      case (#Savanna) { { baseResources = 50.0; movementCost = 0.9; defensibility = 0.4; visibility = 1.2; harshness = 0.2; baseCoherence = 0.75 } };
      case (#Scrubland) { { baseResources = 35.0; movementCost = 1.1; defensibility = 0.5; visibility = 1.0; harshness = 0.25; baseCoherence = 0.7 } };
      case (#Badlands) { { baseResources = 20.0; movementCost = 1.4; defensibility = 0.8; visibility = 1.3; harshness = 0.35; baseCoherence = 0.65 } };
      case (#Canyon) { { baseResources = 30.0; movementCost = 1.6; defensibility = 1.0; visibility = 0.5; harshness = 0.3; baseCoherence = 0.7 } };
      case (#Mesa) { { baseResources = 25.0; movementCost = 1.2; defensibility = 0.95; visibility = 1.4; harshness = 0.25; baseCoherence = 0.75 } };
      case (#SaltFlat) { { baseResources = 5.0; movementCost = 0.8; defensibility = 0.2; visibility = 1.6; harshness = 0.5; baseCoherence = 0.5 } };
      case (#DriedRiverbed) { { baseResources = 25.0; movementCost = 1.0; defensibility = 0.4; visibility = 1.1; harshness = 0.3; baseCoherence = 0.65 } };
      case (#RockyOutcrop) { { baseResources = 20.0; movementCost = 1.3; defensibility = 0.85; visibility = 1.2; harshness = 0.25; baseCoherence = 0.7 } };
      case (#AridGrassland) { { baseResources = 40.0; movementCost = 0.95; defensibility = 0.35; visibility = 1.1; harshness = 0.2; baseCoherence = 0.8 } };
      
      // Frigid biomes - harsh, high defense
      case (#Tundra) { { baseResources = 25.0; movementCost = 1.2; defensibility = 0.6; visibility = 1.4; harshness = 0.5; baseCoherence = 0.6 } };
      case (#IceSheet) { { baseResources = 5.0; movementCost = 1.3; defensibility = 0.3; visibility = 1.5; harshness = 0.7; baseCoherence = 0.4 } };
      case (#Glacier) { { baseResources = 10.0; movementCost = 1.6; defensibility = 0.5; visibility = 1.4; harshness = 0.65; baseCoherence = 0.45 } };
      case (#FrozenForest) { { baseResources = 40.0; movementCost = 1.4; defensibility = 0.85; visibility = 0.5; harshness = 0.45; baseCoherence = 0.65 } };
      case (#SnowPlains) { { baseResources = 20.0; movementCost = 1.1; defensibility = 0.4; visibility = 1.3; harshness = 0.55; baseCoherence = 0.55 } };
      case (#Permafrost) { { baseResources = 15.0; movementCost = 1.2; defensibility = 0.5; visibility = 1.2; harshness = 0.6; baseCoherence = 0.5 } };
      case (#IceCaves) { { baseResources = 30.0; movementCost = 1.5; defensibility = 1.0; visibility = 0.3; harshness = 0.4; baseCoherence = 0.7 } };
      case (#FrozenLake) { { baseResources = 35.0; movementCost = 1.0; defensibility = 0.3; visibility = 1.4; harshness = 0.5; baseCoherence = 0.6 } };
      case (#MountainPeak) { { baseResources = 10.0; movementCost = 2.0; defensibility = 1.0; visibility = 1.6; harshness = 0.7; baseCoherence = 0.5 } };
      case (#AlpineMeadow) { { baseResources = 45.0; movementCost = 1.2; defensibility = 0.6; visibility = 1.2; harshness = 0.3; baseCoherence = 0.8 } };
      case (#FrozenCoast) { { baseResources = 30.0; movementCost = 1.3; defensibility = 0.5; visibility = 1.3; harshness = 0.55; baseCoherence = 0.55 } };
      case (#TaigaForest) { { baseResources = 55.0; movementCost = 1.3; defensibility = 0.8; visibility = 0.6; harshness = 0.35; baseCoherence = 0.75 } };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TERRITORY NODE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TerritoryNode = {
    // Grid position
    gridX : Nat;
    gridY : Nat;
    
    // World position (center)
    worldX : Float;
    worldY : Float;
    
    // Biome
    biome : BiomeType;
    climateZone : ClimateZone;
    
    // Ownership
    owner : Faction;
    ownerInfluence : Float;          // [0, 1] - how strongly controlled
    factionPresence : [Float];       // 5 values - presence of each faction
    
    // Resources
    currentResources : Float;
    maxResources : Float;
    resourceRegenRate : Float;
    
    // State
    coherence : Float;               // [0, 1] - local stability
    dangerLevel : Float;             // [0, 1] - combat history
    entityCount : Nat;               // Entities currently in node
    
    // Combat history
    lastCombatBeat : Nat;
    totalDeathsHere : Nat;
    
    // Modifiers
    defensibility : Float;
    movementCost : Float;
    visibility : Float;
    harshness : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TERRITORY GRID STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TerritoryGridState = {
    // Node storage (flattened 2D array)
    var nodes : [var TerritoryNode];
    
    // Faction control statistics
    var factionTerritoryCount : [var Nat];   // Nodes controlled per faction
    var factionTerritoryPercent : [var Float];
    
    // Resource statistics
    var totalResources : Float;
    var averageCoherence : Float;
    var averageDanger : Float;
    
    // Entity distribution
    var totalEntities : Nat;
    var entitiesByBiome : [var Nat];
    
    // Timing
    var lastUpdateBeat : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get biome for grid position (generates world layout)
  public func getBiomeForPosition(gridX : Nat, gridY : Nat) : BiomeType {
    // Create climate zones: Temperate in middle, Arid in south, Frigid in north
    let normalizedY = Float.fromInt(gridY) / Float.fromInt(GRID_HEIGHT);
    
    let climateZone = if (normalizedY < 0.33) {
      #Frigid
    } else if (normalizedY > 0.66) {
      #Arid
    } else {
      #Temperate
    };
    
    // Within each zone, distribute biomes based on position
    let biomeIndex = (gridX * 7 + gridY * 11) % 12;
    let offset = switch (climateZone) {
      case (#Temperate) { 0 };
      case (#Arid) { 12 };
      case (#Frigid) { 24 };
    };
    
    natToBiome(offset + biomeIndex)
  };
  
  public func natToBiome(n : Nat) : BiomeType {
    switch (n % 36) {
      case (0) { #DeciduousForest };
      case (1) { #MixedForest };
      case (2) { #Grassland };
      case (3) { #Wetland };
      case (4) { #RiverValley };
      case (5) { #LakeRegion };
      case (6) { #Meadow };
      case (7) { #Hills };
      case (8) { #Coast };
      case (9) { #Estuary };
      case (10) { #FarmlandPlains };
      case (11) { #TemperateRainforest };
      case (12) { #Desert };
      case (13) { #SandDunes };
      case (14) { #Oasis };
      case (15) { #Savanna };
      case (16) { #Scrubland };
      case (17) { #Badlands };
      case (18) { #Canyon };
      case (19) { #Mesa };
      case (20) { #SaltFlat };
      case (21) { #DriedRiverbed };
      case (22) { #RockyOutcrop };
      case (23) { #AridGrassland };
      case (24) { #Tundra };
      case (25) { #IceSheet };
      case (26) { #Glacier };
      case (27) { #FrozenForest };
      case (28) { #SnowPlains };
      case (29) { #Permafrost };
      case (30) { #IceCaves };
      case (31) { #FrozenLake };
      case (32) { #MountainPeak };
      case (33) { #AlpineMeadow };
      case (34) { #FrozenCoast };
      case (35) { #TaigaForest };
      case (_) { #Grassland };
    }
  };
  
  /// Initialize a single territory node
  public func initNode(gridX : Nat, gridY : Nat) : TerritoryNode {
    let biome = getBiomeForPosition(gridX, gridY);
    let props = getBiomeProperties(biome);
    
    let worldX = Float.fromInt(gridX) * NODE_SIZE + NODE_SIZE / 2.0 - WORLD_WIDTH / 2.0;
    let worldY = Float.fromInt(gridY) * NODE_SIZE + NODE_SIZE / 2.0 - WORLD_HEIGHT / 2.0;
    
    {
      gridX = gridX;
      gridY = gridY;
      worldX = worldX;
      worldY = worldY;
      biome = biome;
      climateZone = getClimateZone(biome);
      owner = #Neutral;
      ownerInfluence = 0.0;
      factionPresence = [0.0, 0.0, 0.0, 0.0, 0.0]; // Neutral, GAIA, ARES, VULCAN, SENTINEL
      currentResources = props.baseResources;
      maxResources = props.baseResources;
      resourceRegenRate = props.baseResources * RESOURCE_REGEN_RATE;
      coherence = props.baseCoherence;
      dangerLevel = 0.0;
      entityCount = 0;
      lastCombatBeat = 0;
      totalDeathsHere = 0;
      defensibility = props.defensibility;
      movementCost = props.movementCost;
      visibility = props.visibility;
      harshness = props.harshness;
    }
  };
  
  /// Initialize the full territory grid
  public func initTerritoryGrid() : TerritoryGridState {
    let nodes = Array.init<TerritoryNode>(TOTAL_NODES, initNode(0, 0));
    
    for (y in Iter.range(0, GRID_HEIGHT - 1)) {
      for (x in Iter.range(0, GRID_WIDTH - 1)) {
        let idx = y * GRID_WIDTH + x;
        nodes[idx] := initNode(x, y);
      };
    };
    
    {
      var nodes = nodes;
      var factionTerritoryCount = Array.init<Nat>(5, 0);
      var factionTerritoryPercent = Array.init<Float>(5, 0.0);
      var totalResources = 0.0;
      var averageCoherence = 1.0;
      var averageDanger = 0.0;
      var totalEntities = 0;
      var entitiesByBiome = Array.init<Nat>(36, 0);
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COORDINATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get grid index from grid coordinates
  public func gridToIndex(gridX : Nat, gridY : Nat) : ?Nat {
    if (gridX >= GRID_WIDTH or gridY >= GRID_HEIGHT) {
      return null;
    };
    ?(gridY * GRID_WIDTH + gridX)
  };
  
  /// Get grid coordinates from world position
  public func worldToGrid(worldX : Float, worldY : Float) : (Nat, Nat) {
    let offsetX = worldX + WORLD_WIDTH / 2.0;
    let offsetY = worldY + WORLD_HEIGHT / 2.0;
    
    let gridX = Int.abs(Float.toInt(offsetX / NODE_SIZE));
    let gridY = Int.abs(Float.toInt(offsetY / NODE_SIZE));
    
    (if (gridX >= GRID_WIDTH) { GRID_WIDTH - 1 } else { gridX },
     if (gridY >= GRID_HEIGHT) { GRID_HEIGHT - 1 } else { gridY })
  };
  
  /// Get node at world position
  public func getNodeAtWorld(state : TerritoryGridState, worldX : Float, worldY : Float) : ?TerritoryNode {
    let (gridX, gridY) = worldToGrid(worldX, worldY);
    switch (gridToIndex(gridX, gridY)) {
      case (?idx) { ?state.nodes[idx] };
      case (null) { null };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TERRITORY CONTROL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update faction presence in a node based on entity positions
  public func updateFactionPresence(
    state : TerritoryGridState,
    gridX : Nat,
    gridY : Nat,
    factionCounts : [Nat] // 5 values - count per faction
  ) : () {
    switch (gridToIndex(gridX, gridY)) {
      case (null) {};
      case (?idx) {
        let node = state.nodes[idx];
        
        // Calculate total entities
        var total : Nat = 0;
        for (count in factionCounts.vals()) {
          total += count;
        };
        
        if (total == 0) {
          state.nodes[idx] := {
            gridX = node.gridX;
            gridY = node.gridY;
            worldX = node.worldX;
            worldY = node.worldY;
            biome = node.biome;
            climateZone = node.climateZone;
            owner = node.owner;
            ownerInfluence = node.ownerInfluence * (1.0 - CONTROL_DECAY_RATE);
            factionPresence = [0.0, 0.0, 0.0, 0.0, 0.0];
            currentResources = node.currentResources;
            maxResources = node.maxResources;
            resourceRegenRate = node.resourceRegenRate;
            coherence = node.coherence;
            dangerLevel = node.dangerLevel;
            entityCount = 0;
            lastCombatBeat = node.lastCombatBeat;
            totalDeathsHere = node.totalDeathsHere;
            defensibility = node.defensibility;
            movementCost = node.movementCost;
            visibility = node.visibility;
            harshness = node.harshness;
          };
          return;
        };
        
        // Calculate presence percentages
        let totalFloat = Float.fromInt(total);
        let newPresence = Array.tabulate<Float>(5, func (i : Nat) : Float {
          Float.fromInt(factionCounts[i]) / totalFloat
        });
        
        // Determine dominant faction
        var maxPresence : Float = 0.0;
        var dominantFaction : Faction = #Neutral;
        for (i in Iter.range(0, 4)) {
          if (newPresence[i] > maxPresence) {
            maxPresence := newPresence[i];
            dominantFaction := natToFaction(i);
          };
        };
        
        // Update control if threshold met
        let newOwner = if (maxPresence >= CONTROL_THRESHOLD) {
          dominantFaction
        } else {
          node.owner
        };
        
        let newInfluence = if (newOwner == dominantFaction) {
          Float.min(1.0, node.ownerInfluence + maxPresence * 0.1)
        } else {
          node.ownerInfluence * 0.9
        };
        
        state.nodes[idx] := {
          gridX = node.gridX;
          gridY = node.gridY;
          worldX = node.worldX;
          worldY = node.worldY;
          biome = node.biome;
          climateZone = node.climateZone;
          owner = newOwner;
          ownerInfluence = newInfluence;
          factionPresence = newPresence;
          currentResources = node.currentResources;
          maxResources = node.maxResources;
          resourceRegenRate = node.resourceRegenRate;
          coherence = node.coherence;
          dangerLevel = node.dangerLevel;
          entityCount = total;
          lastCombatBeat = node.lastCombatBeat;
          totalDeathsHere = node.totalDeathsHere;
          defensibility = node.defensibility;
          movementCost = node.movementCost;
          visibility = node.visibility;
          harshness = node.harshness;
        };
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RESOURCE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Regenerate resources in all nodes
  public func regenerateResources(state : TerritoryGridState) : () {
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      let node = state.nodes[i];
      if (node.currentResources < node.maxResources) {
        let newResources = Float.min(
          node.maxResources,
          node.currentResources + node.resourceRegenRate * node.coherence
        );
        state.nodes[i] := {
          gridX = node.gridX;
          gridY = node.gridY;
          worldX = node.worldX;
          worldY = node.worldY;
          biome = node.biome;
          climateZone = node.climateZone;
          owner = node.owner;
          ownerInfluence = node.ownerInfluence;
          factionPresence = node.factionPresence;
          currentResources = newResources;
          maxResources = node.maxResources;
          resourceRegenRate = node.resourceRegenRate;
          coherence = node.coherence;
          dangerLevel = node.dangerLevel;
          entityCount = node.entityCount;
          lastCombatBeat = node.lastCombatBeat;
          totalDeathsHere = node.totalDeathsHere;
          defensibility = node.defensibility;
          movementCost = node.movementCost;
          visibility = node.visibility;
          harshness = node.harshness;
        };
      };
    };
  };
  
  /// Consume resources from a node
  public func consumeResources(
    state : TerritoryGridState,
    gridX : Nat,
    gridY : Nat,
    amount : Float
  ) : Float {
    switch (gridToIndex(gridX, gridY)) {
      case (null) { 0.0 };
      case (?idx) {
        let node = state.nodes[idx];
        let consumed = Float.min(amount, node.currentResources);
        
        state.nodes[idx] := {
          gridX = node.gridX;
          gridY = node.gridY;
          worldX = node.worldX;
          worldY = node.worldY;
          biome = node.biome;
          climateZone = node.climateZone;
          owner = node.owner;
          ownerInfluence = node.ownerInfluence;
          factionPresence = node.factionPresence;
          currentResources = node.currentResources - consumed;
          maxResources = node.maxResources;
          resourceRegenRate = node.resourceRegenRate;
          coherence = node.coherence;
          dangerLevel = node.dangerLevel;
          entityCount = node.entityCount;
          lastCombatBeat = node.lastCombatBeat;
          totalDeathsHere = node.totalDeathsHere;
          defensibility = node.defensibility;
          movementCost = node.movementCost;
          visibility = node.visibility;
          harshness = node.harshness;
        };
        
        consumed
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE AND DANGER
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply coherence drop from sacrifice (affects nearby nodes)
  public func applySacrificeEffect(
    state : TerritoryGridState,
    gridX : Nat,
    gridY : Nat,
    coherenceDrop : Float
  ) : () {
    // Affect the node and its neighbors
    for (dy in Iter.range(-1, 1)) {
      for (dx in Iter.range(-1, 1)) {
        let nx = Int.abs(Int.fromNat(gridX) + dy);
        let ny = Int.abs(Int.fromNat(gridY) + dx);
        if (nx < GRID_WIDTH and ny < GRID_HEIGHT) {
          switch (gridToIndex(nx, ny)) {
            case (null) {};
            case (?idx) {
              let node = state.nodes[idx];
              let distance = Float.sqrt(Float.fromInt(dx * dx + dy * dy));
              let falloff = if (distance == 0.0) { 1.0 } else { 1.0 / distance };
              let drop = coherenceDrop * falloff;
              
              state.nodes[idx] := {
                gridX = node.gridX;
                gridY = node.gridY;
                worldX = node.worldX;
                worldY = node.worldY;
                biome = node.biome;
                climateZone = node.climateZone;
                owner = node.owner;
                ownerInfluence = node.ownerInfluence;
                factionPresence = node.factionPresence;
                currentResources = node.currentResources;
                maxResources = node.maxResources;
                resourceRegenRate = node.resourceRegenRate;
                coherence = Float.max(0.3, node.coherence - drop);
                dangerLevel = Float.min(1.0, node.dangerLevel + drop * 0.5);
                entityCount = node.entityCount;
                lastCombatBeat = node.lastCombatBeat;
                totalDeathsHere = node.totalDeathsHere + 1;
                defensibility = node.defensibility;
                movementCost = node.movementCost;
                visibility = node.visibility;
                harshness = node.harshness;
              };
            };
          };
        };
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STATISTICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update grid statistics
  public func updateStatistics(state : TerritoryGridState) : () {
    // Reset counts
    for (i in Iter.range(0, 4)) {
      state.factionTerritoryCount[i] := 0;
    };
    
    var sumResources : Float = 0.0;
    var sumCoherence : Float = 0.0;
    var sumDanger : Float = 0.0;
    var totalEntities : Nat = 0;
    
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      let node = state.nodes[i];
      
      // Count faction territory
      state.factionTerritoryCount[factionToNat(node.owner)] += 1;
      
      // Sum statistics
      sumResources += node.currentResources;
      sumCoherence += node.coherence;
      sumDanger += node.dangerLevel;
      totalEntities += node.entityCount;
    };
    
    // Calculate percentages
    for (i in Iter.range(0, 4)) {
      state.factionTerritoryPercent[i] := Float.fromInt(state.factionTerritoryCount[i]) / Float.fromInt(TOTAL_NODES);
    };
    
    // Calculate averages
    state.totalResources := sumResources;
    state.averageCoherence := sumCoherence / Float.fromInt(TOTAL_NODES);
    state.averageDanger := sumDanger / Float.fromInt(TOTAL_NODES);
    state.totalEntities := totalEntities;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(state : TerritoryGridState, currentBeat : Nat) : () {
    // Regenerate resources
    regenerateResources(state);
    
    // Recovery coherence naturally
    for (i in Iter.range(0, TOTAL_NODES - 1)) {
      let node = state.nodes[i];
      let props = getBiomeProperties(node.biome);
      let targetCoherence = props.baseCoherence;
      
      if (node.coherence < targetCoherence) {
        state.nodes[i] := {
          gridX = node.gridX;
          gridY = node.gridY;
          worldX = node.worldX;
          worldY = node.worldY;
          biome = node.biome;
          climateZone = node.climateZone;
          owner = node.owner;
          ownerInfluence = node.ownerInfluence;
          factionPresence = node.factionPresence;
          currentResources = node.currentResources;
          maxResources = node.maxResources;
          resourceRegenRate = node.resourceRegenRate;
          coherence = Float.min(targetCoherence, node.coherence + COHERENCE_RECOVERY_RATE);
          dangerLevel = Float.max(0.0, node.dangerLevel - 0.001);
          entityCount = node.entityCount;
          lastCombatBeat = node.lastCombatBeat;
          totalDeathsHere = node.totalDeathsHere;
          defensibility = node.defensibility;
          movementCost = node.movementCost;
          visibility = node.visibility;
          harshness = node.harshness;
        };
      };
    };
    
    // Update statistics
    updateStatistics(state);
    
    state.lastUpdateBeat := currentBeat;
  };

}
