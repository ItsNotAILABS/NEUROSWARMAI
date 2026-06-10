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
// SACRIFICE DOCTRINE ENGINE — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// MEDINA'S MIRROR LAW (Law 9):
// Backend (Male): Doctrine death — permanent, mathematical, sovereign
// Frontend (Female): Expressed sacrifice — the player witnesses what the math decided
//
// SACRIFICE PROBABILITY:
// P_sacrifice = (1 - C) × D × (ARES_territory / 0.275)
//
// When P > threshold: sacrifice fires on-chain
// HELIX_CORTISOL spikes permanently in backend chemistry
// Grief propagates to 3 nearest biomes: coherence drops 0.12 each
// Sacrifice count logged — immutable
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module SacrificeDoctrineEngine {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRIFICE CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Base sacrifice threshold
  public let BASE_THRESHOLD : Float = 0.5;
  
  /// ARES territory coefficient (the 0.275 constant)
  public let ARES_TERRITORY_COEFFICIENT : Float = 0.275;
  
  /// Grief propagation radius (number of biomes)
  public let GRIEF_PROPAGATION_RADIUS : Nat = 3;
  
  /// Coherence drop per grief propagation
  public let GRIEF_COHERENCE_DROP : Float = 0.12;
  
  /// Minimum beats between sacrifices
  public let MIN_SACRIFICE_INTERVAL : Nat = 100;
  
  /// Cortisol spike magnitude on sacrifice
  public let CORTISOL_SPIKE : Float = 0.4;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRIFICE EVENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SacrificeEvent = {
    id : Nat;                         // Unique sacrifice ID
    entityId : Text;                  // Entity that sacrificed
    entityFaction : Nat;              // Faction of entity
    beat : Nat;                       // Beat when occurred
    timestamp : Int;                  // Timestamp when occurred
    position : { x : Float; y : Float };  // Position of sacrifice
    
    // Conditions at time of sacrifice
    coherence : Float;
    drift : Float;
    aresTerritory : Float;
    probability : Float;
    
    // Effects
    affectedBiomes : [Nat];           // Biomes affected by grief
    coherenceDrops : [Float];         // Coherence drop per biome
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRIFICE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SacrificeState = {
    var totalSacrifices : Nat;
    var lastSacrificeBeat : Nat;
    var inCooldown : Bool;
    var cooldownRemaining : Nat;
    var eventHistory : Buffer.Buffer<SacrificeEvent>;
    var pendingSacrifice : ?Text;     // Entity ID pending sacrifice
    var currentProbability : Float;
    var isEnabled : Bool;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initSacrificeState() : SacrificeState {
    {
      var totalSacrifices = 0;
      var lastSacrificeBeat = 0;
      var inCooldown = false;
      var cooldownRemaining = 0;
      var eventHistory = Buffer.Buffer<SacrificeEvent>(100);
      var pendingSacrifice = null;
      var currentProbability = 0.0;
      var isEnabled = true;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRIFICE PROBABILITY CALCULATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate sacrifice probability
  /// P_sacrifice = (1 - C) × D × (ARES_territory / 0.275)
  public func calculateProbability(
    coherence : Float,
    drift : Float,
    aresTerritory : Float
  ) : Float {
    let inverseCoherence = 1.0 - coherence;
    let territoryFactor = aresTerritory / ARES_TERRITORY_COEFFICIENT;
    Float.min(1.0, inverseCoherence * drift * territoryFactor)
  };
  
  /// Check if sacrifice should trigger
  public func shouldTrigger(
    probability : Float,
    threshold : Float
  ) : Bool {
    probability > threshold
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // GRIEF PROPAGATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BiomeDistance = {
    biomeId : Nat;
    distance : Float;
  };
  
  /// Calculate grief effect based on distance
  public func calculateGriefEffect(
    distance : Float,
    maxRadius : Float
  ) : Float {
    if (distance >= maxRadius) {
      0.0
    } else {
      let normalizedDistance = distance / maxRadius;
      GRIEF_COHERENCE_DROP * (1.0 - normalizedDistance * normalizedDistance)
    }
  };
  
  /// Get N nearest biomes (sorted by distance)
  public func getNearestBiomes(
    sacrificePosition : { x : Float; y : Float },
    biomePositions : [{ id : Nat; x : Float; y : Float }],
    count : Nat
  ) : [Nat] {
    // Calculate distances
    let distances = Array.map<{ id : Nat; x : Float; y : Float }, BiomeDistance>(
      biomePositions,
      func (biome) : BiomeDistance {
        let dx = biome.x - sacrificePosition.x;
        let dy = biome.y - sacrificePosition.y;
        let dist = Float.sqrt(dx * dx + dy * dy);
        { biomeId = biome.id; distance = dist }
      }
    );
    
    // Sort by distance (simple bubble sort for small arrays)
    let sorted = Array.thaw<BiomeDistance>(distances);
    for (i in Iter.range(0, sorted.size() - 2)) {
      for (j in Iter.range(0, sorted.size() - i - 2)) {
        if (sorted[j].distance > sorted[j + 1].distance) {
          let temp = sorted[j];
          sorted[j] := sorted[j + 1];
          sorted[j + 1] := temp;
        };
      };
    };
    
    // Return top N biome IDs
    let result = Buffer.Buffer<Nat>(count);
    for (i in Iter.range(0, Nat.min(count, sorted.size()) - 1)) {
      result.add(sorted[i].biomeId);
    };
    Buffer.toArray(result)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SACRIFICE EXECUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SacrificeInputs = {
    entityId : Text;
    entityFaction : Nat;
    position : { x : Float; y : Float };
    coherence : Float;
    drift : Float;
    aresTerritory : Float;
    currentBeat : Nat;
    biomePositions : [{ id : Nat; x : Float; y : Float }];
  };
  
  /// Execute sacrifice and return event
  public func executeSacrifice(
    state : SacrificeState,
    inputs : SacrificeInputs
  ) : SacrificeEvent {
    // Calculate probability
    let probability = calculateProbability(
      inputs.coherence,
      inputs.drift,
      inputs.aresTerritory
    );
    
    // Get affected biomes
    let affectedBiomes = getNearestBiomes(
      inputs.position,
      inputs.biomePositions,
      GRIEF_PROPAGATION_RADIUS
    );
    
    // Calculate coherence drops
    let coherenceDrops = Array.tabulate<Float>(
      affectedBiomes.size(),
      func (i : Nat) : Float {
        // Closer biomes get more grief
        let baseDrop = GRIEF_COHERENCE_DROP;
        let distanceFactor = 1.0 - (Float.fromInt(i) / Float.fromInt(GRIEF_PROPAGATION_RADIUS));
        baseDrop * distanceFactor
      }
    );
    
    // Increment counter
    state.totalSacrifices += 1;
    
    // Create event
    let event : SacrificeEvent = {
      id = state.totalSacrifices;
      entityId = inputs.entityId;
      entityFaction = inputs.entityFaction;
      beat = inputs.currentBeat;
      timestamp = Time.now();
      position = inputs.position;
      coherence = inputs.coherence;
      drift = inputs.drift;
      aresTerritory = inputs.aresTerritory;
      probability = probability;
      affectedBiomes = affectedBiomes;
      coherenceDrops = coherenceDrops;
    };
    
    // Update state
    state.lastSacrificeBeat := inputs.currentBeat;
    state.inCooldown := true;
    state.cooldownRemaining := MIN_SACRIFICE_INTERVAL;
    state.pendingSacrifice := null;
    state.currentProbability := 0.0;
    
    // Add to history
    state.eventHistory.add(event);
    
    event
  };
  
  /// Evaluate if an entity should be marked for sacrifice
  public func evaluateSacrifice(
    state : SacrificeState,
    entityId : Text,
    coherence : Float,
    drift : Float,
    aresTerritory : Float,
    threshold : Float
  ) : Bool {
    // Check cooldown
    if (state.inCooldown) {
      return false;
    };
    
    // Calculate probability
    let probability = calculateProbability(coherence, drift, aresTerritory);
    state.currentProbability := probability;
    
    // Check threshold
    if (shouldTrigger(probability, threshold)) {
      state.pendingSacrifice := ?entityId;
      true
    } else {
      false
    }
  };
  
  /// Update sacrifice state each beat
  public func tick(state : SacrificeState) : () {
    // Update cooldown
    if (state.inCooldown) {
      if (state.cooldownRemaining > 0) {
        state.cooldownRemaining -= 1;
      } else {
        state.inCooldown := false;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get total sacrifices
  public func getTotalSacrifices(state : SacrificeState) : Nat {
    state.totalSacrifices
  };
  
  /// Get sacrifice history
  public func getHistory(state : SacrificeState) : [SacrificeEvent] {
    Buffer.toArray(state.eventHistory)
  };
  
  /// Get latest sacrifice
  public func getLatestSacrifice(state : SacrificeState) : ?SacrificeEvent {
    if (state.eventHistory.size() > 0) {
      ?state.eventHistory.get(state.eventHistory.size() - 1)
    } else {
      null
    }
  };
  
  /// Check if sacrifice is pending
  public func hasPendingSacrifice(state : SacrificeState) : Bool {
    Option.isSome(state.pendingSacrifice)
  };
  
  /// Get pending sacrifice entity
  public func getPendingSacrifice(state : SacrificeState) : ?Text {
    state.pendingSacrifice
  };

}
