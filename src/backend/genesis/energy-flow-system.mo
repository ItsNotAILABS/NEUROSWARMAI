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
// ENERGY FLOW SYSTEM — BACKEND VERSION (MALE)
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// COMPLETE ENERGY METABOLISM OF THE SUPER ORGANISM
//
// Like the human body's ATP/mitochondria system, this organism has a complete
// energy production, distribution, storage, and consumption architecture.
//
// ENERGY CURRENCY:
// - ATP (Adenosine Triphosphate analog) — Primary energy currency
// - Adenosine — ATP breakdown product, signals fatigue
// - Glucose — Energy substrate
// - Glycogen — Energy storage
// - Creatine Phosphate — Rapid energy buffer
//
// ENERGY SYSTEMS:
// 1. AEROBIC SYSTEM (Oxidative Phosphorylation)
//    - High capacity, slower rate
//    - Sustainable long-term activity
//
// 2. ANAEROBIC GLYCOLYSIS
//    - Medium capacity, faster rate
//    - Short-term high intensity
//    - Produces lactate
//
// 3. PHOSPHOCREATINE SYSTEM
//    - Low capacity, fastest rate
//    - Immediate burst energy
//    - Rapid recovery
//
// ENERGY FLOW:
// INPUT → Storage → Distribution → Consumption → Waste
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Text "mo:core/Text";

module EnergyFlowSystem {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Maximum ATP level
  public let MAX_ATP : Nat = 10000;
  
  /// ATP threshold for low energy warning
  public let LOW_ATP_THRESHOLD : Nat = 2000;
  
  /// ATP threshold for critical energy
  public let CRITICAL_ATP_THRESHOLD : Nat = 500;
  
  /// Maximum glycogen storage
  public let MAX_GLYCOGEN : Nat = 50000;
  
  /// Maximum creatine phosphate
  public let MAX_CREATINE_PHOSPHATE : Nat = 5000;
  
  /// Maximum lactate before impairment
  public let MAX_LACTATE : Nat = 2000;
  
  /// Lactate threshold for fatigue
  public let LACTATE_FATIGUE_THRESHOLD : Nat = 1500;
  
  /// Base metabolic rate (ATP/beat)
  public let BASE_METABOLIC_RATE : Nat = 50;
  
  /// Aerobic ATP production rate (per beat at max)
  public let AEROBIC_RATE : Nat = 100;
  
  /// Anaerobic ATP production rate (per beat at max)
  public let ANAEROBIC_RATE : Nat = 200;
  
  /// Phosphocreatine ATP production rate (per beat at max)
  public let PHOSPHOCREATINE_RATE : Nat = 500;
  
  /// Creatine phosphate regeneration rate (per beat)
  public let CP_REGEN_RATE : Nat = 20;
  
  /// Lactate clearance rate (per beat)
  public let LACTATE_CLEARANCE_RATE : Nat = 30;
  
  /// Glycogen synthesis rate (per beat)
  public let GLYCOGEN_SYNTHESIS_RATE : Nat = 10;
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY SUBSTRATE STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EnergySubstrateState = {
    // Primary currency
    var atp : Nat;                    // Current ATP level
    var adp : Nat;                    // ADP (breakdown product)
    var adenosine : Nat;              // Signals fatigue, sleep pressure
    
    // Storage
    var glycogen : Nat;               // Long-term energy storage
    var creatinePhosphate : Nat;      // Rapid energy buffer
    var fattyAcids : Nat;             // Very long-term storage
    
    // Metabolites
    var glucose : Nat;                // Active energy substrate
    var lactate : Nat;                // Anaerobic waste product
    var pyruvate : Nat;               // Intermediate metabolite
    
    // Oxygen (for aerobic metabolism)
    var oxygen : Nat;                 // Available oxygen
    var oxygenSaturation : Nat;       // 0-1000 (percentage)
  };
  
  public func initEnergySubstrateState() : EnergySubstrateState {
    {
      var atp = MAX_ATP / 2;
      var adp = 0;
      var adenosine = 0;
      var glycogen = MAX_GLYCOGEN / 2;
      var creatinePhosphate = MAX_CREATINE_PHOSPHATE;
      var fattyAcids = 10000;
      var glucose = 5000;
      var lactate = 0;
      var pyruvate = 500;
      var oxygen = 1000;
      var oxygenSaturation = 980;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY PRODUCTION SYSTEMS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EnergySystemState = {
    #Aerobic;
    #AnaerobicGlycolysis;
    #Phosphocreatine;
    #Mixed;
  };
  
  public type EnergyProductionState = {
    // System activation levels (0-1000)
    var aerobicActivity : Nat;
    var anaerobicActivity : Nat;
    var phosphocreatineActivity : Nat;
    
    // Production rates (ATP per beat)
    var aerobicRate : Nat;
    var anaerobicRate : Nat;
    var phosphocreatineRate : Nat;
    var totalProductionRate : Nat;
    
    // Dominant system
    var dominantSystem : EnergySystemState;
    
    // Efficiency
    var metabolicEfficiency : Nat;    // 0-1000
    var oxygenEfficiency : Nat;       // ATP per oxygen unit
  };
  
  public func initEnergyProductionState() : EnergyProductionState {
    {
      var aerobicActivity = 500;
      var anaerobicActivity = 0;
      var phosphocreatineActivity = 0;
      var aerobicRate = AEROBIC_RATE / 2;
      var anaerobicRate = 0;
      var phosphocreatineRate = 0;
      var totalProductionRate = AEROBIC_RATE / 2;
      var dominantSystem = #Aerobic;
      var metabolicEfficiency = 800;
      var oxygenEfficiency = 36; // ~36 ATP per O2 in oxidative phosphorylation
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY CONSUMPTION MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EnergyConsumptionType = {
    #BasalMetabolism;      // Minimum required for survival
    #Cognitive;            // Brain activity
    #Movement;             // Motor actions
    #Immune;               // Immune system activity
    #Growth;               // Growth and repair
    #Communication;        // Signal transmission
    #Memory;               // Memory encoding/consolidation
  };
  
  public type EnergyConsumptionState = {
    // Per-system consumption (ATP/beat)
    var basalConsumption : Nat;
    var cognitiveConsumption : Nat;
    var movementConsumption : Nat;
    var immuneConsumption : Nat;
    var growthConsumption : Nat;
    var communicationConsumption : Nat;
    var memoryConsumption : Nat;
    
    // Total consumption
    var totalConsumption : Nat;
    
    // Consumption ratios
    var cognitiveRatio : Nat;         // Brain uses ~20% of body's energy in humans
    var basalRatio : Nat;             // ~70% for basal metabolism
    var activityRatio : Nat;          // Remaining for activity
  };
  
  public func initEnergyConsumptionState() : EnergyConsumptionState {
    {
      var basalConsumption = BASE_METABOLIC_RATE * 7 / 10;  // 70%
      var cognitiveConsumption = BASE_METABOLIC_RATE * 2 / 10;  // 20%
      var movementConsumption = 0;
      var immuneConsumption = BASE_METABOLIC_RATE * 5 / 100;  // 5%
      var growthConsumption = BASE_METABOLIC_RATE * 3 / 100;  // 3%
      var communicationConsumption = BASE_METABOLIC_RATE * 1 / 100;  // 1%
      var memoryConsumption = BASE_METABOLIC_RATE * 1 / 100;  // 1%
      var totalConsumption = BASE_METABOLIC_RATE;
      var cognitiveRatio = 200;
      var basalRatio = 700;
      var activityRatio = 100;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY DISTRIBUTION MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EnergyDistributionState = {
    // Substrate-specific energy pools
    var brainEnergy : Nat;
    var quantumEnergy : Nat;
    var organEnergy : Nat;
    var metalEnergy : Nat;
    
    // Distribution priority (higher = more priority)
    var brainPriority : Nat;
    var quantumPriority : Nat;
    var organPriority : Nat;
    var metalPriority : Nat;
    
    // Flow rates (energy per beat to each substrate)
    var brainFlowRate : Nat;
    var quantumFlowRate : Nat;
    var organFlowRate : Nat;
    var metalFlowRate : Nat;
    
    // Distribution efficiency
    var distributionEfficiency : Nat;
    var energyLoss : Nat;             // Energy lost in distribution
  };
  
  public func initEnergyDistributionState() : EnergyDistributionState {
    {
      var brainEnergy = 2000;
      var quantumEnergy = 1000;
      var organEnergy = 1500;
      var metalEnergy = 500;
      var brainPriority = 900;        // Brain always high priority
      var quantumPriority = 700;      // Quantum important but can be reduced
      var organPriority = 800;        // Organs essential
      var metalPriority = 500;        // Metal can wait
      var brainFlowRate = 20;
      var quantumFlowRate = 10;
      var organFlowRate = 15;
      var metalFlowRate = 5;
      var distributionEfficiency = 900;
      var energyLoss = 100;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FATIGUE AND RECOVERY MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FatigueState = {
    // Fatigue levels (0-1000)
    var peripheralFatigue : Nat;      // Muscle/body fatigue
    var centralFatigue : Nat;         // Brain/cognitive fatigue
    var metabolicFatigue : Nat;       // ATP depletion fatigue
    var totalFatigue : Nat;           // Combined fatigue measure
    
    // Sleep pressure (adenosine accumulation)
    var sleepPressure : Nat;
    var hoursAwake : Nat;
    
    // Recovery rate
    var recoveryRate : Nat;           // How fast fatigue decreases during rest
    var isResting : Bool;
    var restQuality : Nat;            // 0-1000
  };
  
  public func initFatigueState() : FatigueState {
    {
      var peripheralFatigue = 0;
      var centralFatigue = 0;
      var metabolicFatigue = 0;
      var totalFatigue = 0;
      var sleepPressure = 0;
      var hoursAwake = 0;
      var recoveryRate = 50;
      var isResting = false;
      var restQuality = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE ENERGY FLOW STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EnergyFlowState = {
    var substrates : EnergySubstrateState;
    var production : EnergyProductionState;
    var consumption : EnergyConsumptionState;
    var distribution : EnergyDistributionState;
    var fatigue : FatigueState;
    
    // Net energy balance
    var netEnergyBalance : Int;       // Production - Consumption
    var energyReserve : Nat;          // Total stored energy
    var energyDeficit : Nat;          // If consumption > production
    
    // Alarms
    var isLowEnergy : Bool;
    var isCriticalEnergy : Bool;
    var isOverworked : Bool;
    
    // Timing
    var lastUpdateBeat : Nat;
    var totalEnergyProduced : Nat;
    var totalEnergyConsumed : Nat;
  };
  
  public func initEnergyFlowState() : EnergyFlowState {
    {
      var substrates = initEnergySubstrateState();
      var production = initEnergyProductionState();
      var consumption = initEnergyConsumptionState();
      var distribution = initEnergyDistributionState();
      var fatigue = initFatigueState();
      var netEnergyBalance = 0;
      var energyReserve = 0;
      var energyDeficit = 0;
      var isLowEnergy = false;
      var isCriticalEnergy = false;
      var isOverworked = false;
      var lastUpdateBeat = 0;
      var totalEnergyProduced = 0;
      var totalEnergyConsumed = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY PRODUCTION CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate aerobic ATP production
  /// ATP = min(oxygen_available, glucose_available) × efficiency
  public func calculateAerobicProduction(state : EnergyFlowState) : Nat {
    let oxygenLimit = state.substrates.oxygen * AEROBIC_RATE / 1000;
    let glucoseLimit = state.substrates.glucose * AEROBIC_RATE / 1000;
    let productionLimit = Nat.min(oxygenLimit, glucoseLimit);
    
    productionLimit * state.production.aerobicActivity / 1000
  };
  
  /// Calculate anaerobic ATP production
  /// Faster but produces lactate
  public func calculateAnaerobicProduction(state : EnergyFlowState) : Nat {
    let glucoseAvailable = state.substrates.glucose;
    let lactateHeadroom = if (MAX_LACTATE > state.substrates.lactate) {
      MAX_LACTATE - state.substrates.lactate
    } else { 0 };
    
    let productionLimit = Nat.min(glucoseAvailable * ANAEROBIC_RATE / 1000, lactateHeadroom);
    productionLimit * state.production.anaerobicActivity / 1000
  };
  
  /// Calculate phosphocreatine ATP production
  /// Fastest but limited by CP stores
  public func calculatePhosphocreatineProduction(state : EnergyFlowState) : Nat {
    let cpAvailable = state.substrates.creatinePhosphate;
    let maxProduction = Nat.min(cpAvailable, PHOSPHOCREATINE_RATE);
    
    maxProduction * state.production.phosphocreatineActivity / 1000
  };
  
  /// Determine which energy system should be active based on demand
  public func determineEnergySystem(
    demandRate : Nat,
    currentATP : Nat,
    lactateLevel : Nat,
    cpLevel : Nat
  ) : (Nat, Nat, Nat) {
    // Returns (aerobic, anaerobic, phosphocreatine) activity levels
    
    // If demand is low, use aerobic only
    if (demandRate < AEROBIC_RATE) {
      return (demandRate * 1000 / AEROBIC_RATE, 0, 0);
    };
    
    // If demand exceeds aerobic capacity
    let excessDemand = demandRate - AEROBIC_RATE;
    
    // If ATP is critically low, engage phosphocreatine
    if (currentATP < CRITICAL_ATP_THRESHOLD and cpLevel > 0) {
      let cpContribution = Nat.min(excessDemand, cpLevel);
      return (1000, 0, cpContribution * 1000 / PHOSPHOCREATINE_RATE);
    };
    
    // If lactate is not too high, use anaerobic
    if (lactateLevel < LACTATE_FATIGUE_THRESHOLD) {
      let anaerobicContribution = Nat.min(excessDemand, ANAEROBIC_RATE);
      return (1000, anaerobicContribution * 1000 / ANAEROBIC_RATE, 0);
    };
    
    // High lactate: mix of aerobic and phosphocreatine
    let cpContribution = Nat.min(excessDemand / 2, cpLevel);
    (1000, 200, cpContribution * 1000 / PHOSPHOCREATINE_RATE)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY CONSUMPTION CALCULATIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Calculate total energy consumption based on activity
  public func calculateTotalConsumption(
    state : EnergyFlowState,
    cognitiveLoad : Nat,      // 0-1000
    movementIntensity : Nat,  // 0-1000
    immuneActivity : Nat      // 0-1000
  ) : Nat {
    // Basal metabolism is always required
    let basal = state.consumption.basalConsumption;
    
    // Cognitive scales with load
    let cognitive = BASE_METABOLIC_RATE * 2 / 10 * cognitiveLoad / 1000;
    
    // Movement can be very high
    let movement = movementIntensity * 5; // Up to 500% of basal
    
    // Immune activity
    let immune = BASE_METABOLIC_RATE * immuneActivity / 1000;
    
    basal + cognitive + movement + immune
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY DISTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Distribute available energy to substrates based on priority
  public func distributeEnergy(state : EnergyFlowState, availableATP : Nat) : () {
    let totalPriority = state.distribution.brainPriority +
                        state.distribution.quantumPriority +
                        state.distribution.organPriority +
                        state.distribution.metalPriority;
    
    if (totalPriority == 0) { return; };
    
    // Distribute proportionally to priority
    let brainShare = availableATP * state.distribution.brainPriority / totalPriority;
    let quantumShare = availableATP * state.distribution.quantumPriority / totalPriority;
    let organShare = availableATP * state.distribution.organPriority / totalPriority;
    let metalShare = availableATP * state.distribution.metalPriority / totalPriority;
    
    // Apply distribution efficiency loss
    let efficiency = state.distribution.distributionEfficiency;
    
    state.distribution.brainEnergy += brainShare * efficiency / 1000;
    state.distribution.quantumEnergy += quantumShare * efficiency / 1000;
    state.distribution.organEnergy += organShare * efficiency / 1000;
    state.distribution.metalEnergy += metalShare * efficiency / 1000;
    
    // Track losses
    state.distribution.energyLoss := availableATP * (1000 - efficiency) / 1000;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // FATIGUE DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update fatigue based on activity and energy state
  public func updateFatigue(
    state : EnergyFlowState,
    activityLevel : Nat,
    isResting : Bool
  ) : () {
    state.fatigue.isResting := isResting;
    
    if (isResting) {
      // Recovery during rest
      let recovery = state.fatigue.recoveryRate * state.fatigue.restQuality / 1000;
      
      state.fatigue.peripheralFatigue := if (state.fatigue.peripheralFatigue > recovery) {
        state.fatigue.peripheralFatigue - recovery
      } else { 0 };
      
      state.fatigue.centralFatigue := if (state.fatigue.centralFatigue > recovery) {
        state.fatigue.centralFatigue - recovery
      } else { 0 };
      
      state.fatigue.sleepPressure := if (state.fatigue.sleepPressure > recovery * 2) {
        state.fatigue.sleepPressure - recovery * 2
      } else { 0 };
    } else {
      // Fatigue accumulation during activity
      state.fatigue.peripheralFatigue := Nat.min(
        1000,
        state.fatigue.peripheralFatigue + activityLevel / 100
      );
      
      // Central fatigue from adenosine
      state.fatigue.centralFatigue := Nat.min(
        1000,
        state.substrates.adenosine / 10
      );
      
      // Sleep pressure accumulates
      state.fatigue.sleepPressure := Nat.min(
        1000,
        state.fatigue.sleepPressure + 1
      );
      state.fatigue.hoursAwake += 1;
    };
    
    // Metabolic fatigue from lactate
    state.fatigue.metabolicFatigue := state.substrates.lactate * 1000 / MAX_LACTATE;
    
    // Total fatigue is weighted average
    state.fatigue.totalFatigue := (
      state.fatigue.peripheralFatigue * 3 +
      state.fatigue.centralFatigue * 4 +
      state.fatigue.metabolicFatigue * 3
    ) / 10;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // METABOLITE DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update metabolite levels
  public func updateMetabolites(state : EnergyFlowState) : () {
    // Adenosine accumulates when ATP is broken down
    let atpUsed = state.consumption.totalConsumption;
    state.substrates.adenosine := Nat.min(
      10000,
      state.substrates.adenosine + atpUsed / 10
    );
    
    // Adenosine clears slowly during low activity
    if (state.consumption.totalConsumption < BASE_METABOLIC_RATE) {
      state.substrates.adenosine := if (state.substrates.adenosine > 10) {
        state.substrates.adenosine - 10
      } else { 0 };
    };
    
    // Lactate clearance
    let lactateCleared = Nat.min(state.substrates.lactate, LACTATE_CLEARANCE_RATE);
    state.substrates.lactate := state.substrates.lactate - lactateCleared;
    
    // Creatine phosphate regeneration (when aerobic is active)
    if (state.production.aerobicActivity > 500) {
      state.substrates.creatinePhosphate := Nat.min(
        MAX_CREATINE_PHOSPHATE,
        state.substrates.creatinePhosphate + CP_REGEN_RATE
      );
    };
    
    // Glycogen synthesis when glucose is high and activity is low
    if (state.substrates.glucose > 3000 and state.consumption.totalConsumption < BASE_METABOLIC_RATE) {
      let synthesized = Nat.min(GLYCOGEN_SYNTHESIS_RATE, state.substrates.glucose - 3000);
      state.substrates.glycogen := Nat.min(MAX_GLYCOGEN, state.substrates.glycogen + synthesized);
      state.substrates.glucose := state.substrates.glucose - synthesized;
    };
    
    // Glycogenolysis when glucose is low
    if (state.substrates.glucose < 2000 and state.substrates.glycogen > 0) {
      let released = Nat.min(GLYCOGEN_SYNTHESIS_RATE * 2, state.substrates.glycogen);
      state.substrates.glucose := state.substrates.glucose + released;
      state.substrates.glycogen := state.substrates.glycogen - released;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func tick(
    state : EnergyFlowState,
    currentBeat : Nat,
    cognitiveLoad : Nat,
    movementIntensity : Nat,
    immuneActivity : Nat,
    isResting : Bool
  ) : () {
    // Calculate consumption
    let totalConsumption = calculateTotalConsumption(state, cognitiveLoad, movementIntensity, immuneActivity);
    state.consumption.totalConsumption := totalConsumption;
    
    // Determine energy system activation
    let (aerobic, anaerobic, phosphocreatine) = determineEnergySystem(
      totalConsumption,
      state.substrates.atp,
      state.substrates.lactate,
      state.substrates.creatinePhosphate
    );
    state.production.aerobicActivity := aerobic;
    state.production.anaerobicActivity := anaerobic;
    state.production.phosphocreatineActivity := phosphocreatine;
    
    // Calculate production
    state.production.aerobicRate := calculateAerobicProduction(state);
    state.production.anaerobicRate := calculateAnaerobicProduction(state);
    state.production.phosphocreatineRate := calculatePhosphocreatineProduction(state);
    state.production.totalProductionRate := state.production.aerobicRate +
                                            state.production.anaerobicRate +
                                            state.production.phosphocreatineRate;
    
    // Determine dominant system
    let maxRate = Nat.max(Nat.max(state.production.aerobicRate, state.production.anaerobicRate),
                         state.production.phosphocreatineRate);
    if (maxRate == state.production.phosphocreatineRate) {
      state.production.dominantSystem := #Phosphocreatine;
    } else if (maxRate == state.production.anaerobicRate) {
      state.production.dominantSystem := #AnaerobicGlycolysis;
    } else {
      state.production.dominantSystem := #Aerobic;
    };
    
    // Update ATP
    let produced = state.production.totalProductionRate;
    let consumed = totalConsumption;
    
    if (produced >= consumed) {
      state.substrates.atp := Nat.min(MAX_ATP, state.substrates.atp + produced - consumed);
      state.energyDeficit := 0;
    } else {
      let deficit = consumed - produced;
      if (state.substrates.atp >= deficit) {
        state.substrates.atp := state.substrates.atp - deficit;
        state.energyDeficit := 0;
      } else {
        state.energyDeficit := deficit - state.substrates.atp;
        state.substrates.atp := 0;
      };
    };
    
    // Net balance
    state.netEnergyBalance := Int.fromNat(produced) - Int.fromNat(consumed);
    
    // Update metabolites
    updateMetabolites(state);
    
    // Update fatigue
    updateFatigue(state, cognitiveLoad + movementIntensity, isResting);
    
    // Distribute energy
    distributeEnergy(state, state.substrates.atp / 10);
    
    // Update alarms
    state.isLowEnergy := state.substrates.atp < LOW_ATP_THRESHOLD;
    state.isCriticalEnergy := state.substrates.atp < CRITICAL_ATP_THRESHOLD;
    state.isOverworked := state.fatigue.totalFatigue > 800;
    
    // Update energy reserve
    state.energyReserve := state.substrates.atp + 
                          state.substrates.glycogen / 10 + 
                          state.substrates.creatinePhosphate;
    
    // Track totals
    state.totalEnergyProduced += produced;
    state.totalEnergyConsumed += consumed;
    
    state.lastUpdateBeat := currentBeat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getEnergySummary(state : EnergyFlowState) : {
    atp : Nat;
    glycogen : Nat;
    creatinePhosphate : Nat;
    lactate : Nat;
    adenosine : Nat;
    totalFatigue : Nat;
    sleepPressure : Nat;
    netBalance : Int;
    isLowEnergy : Bool;
    isCriticalEnergy : Bool;
    dominantSystem : Text;
  } {
    let systemName = switch (state.production.dominantSystem) {
      case (#Aerobic) { "Aerobic" };
      case (#AnaerobicGlycolysis) { "Anaerobic" };
      case (#Phosphocreatine) { "Phosphocreatine" };
      case (#Mixed) { "Mixed" };
    };
    
    {
      atp = state.substrates.atp;
      glycogen = state.substrates.glycogen;
      creatinePhosphate = state.substrates.creatinePhosphate;
      lactate = state.substrates.lactate;
      adenosine = state.substrates.adenosine;
      totalFatigue = state.fatigue.totalFatigue;
      sleepPressure = state.fatigue.sleepPressure;
      netBalance = state.netEnergyBalance;
      isLowEnergy = state.isLowEnergy;
      isCriticalEnergy = state.isCriticalEnergy;
      dominantSystem = systemName;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  LOOP 4 CLOSURE: GOCE 8-CHANNEL SHANNON ENTROPY + KREBS CYCLE ATP                                        ██
  // ██  ENTROPY METABOLISM DRIVES FORMA PRODUCTION                                                               ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // GOCE (Generative Orchestration of Cognitive Energy) is the organism's entropy metabolism system.
  // It measures information entropy across 8 cognitive channels and converts entropy reduction to energy.
  //
  // THE 8 SHANNON ENTROPY CHANNELS:
  // ───────────────────────────────
  // 1. COHERENCE — Entropy of the 12-node Hz substrate phase distribution
  // 2. FEAR — Entropy of the fear/threat response distribution
  // 3. DRIVE — Entropy of the 9-drive competition distribution
  // 4. MEMORY — Entropy of the episodic buffer activation distribution
  // 5. NEUROCHEM — Entropy of the 8-neurotransmitter concentration distribution
  // 6. WORLD_MODEL — Entropy of the world model predictions vs. observations
  // 7. QUANTUM — Entropy of the quantum state density matrix (Von Neumann)
  // 8. SOCIAL — Entropy of the social/trust relationship distribution
  //
  // Shannon Entropy: H = -Σ p_i × log₂(p_i)
  //
  // When the organism processes information and reduces entropy (gains certainty),
  // the entropy reduction is converted to ATP via a 6-phase Krebs cycle analog.
  //
  // KREBS CYCLE PHASES:
  // ───────────────────
  // 1. CITRATE — Entropy input, binding with substrate
  // 2. ISOCITRATE — Isomerization, energy reorganization
  // 3. α-KETOGLUTARATE — First decarboxylation, CO2 release
  // 4. SUCCINYL-CoA — Second decarboxylation, high-energy bond
  // 5. SUCCINATE → FUMARATE — Electron transfer, FADH2 production
  // 6. MALATE → OXALOACETATE — Final oxidation, NADH production, cycle reset
  //
  // Each phase contributes to ATP production proportional to entropy reduction.
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  /// Number of GOCE entropy channels
  public let GOCE_CHANNELS : Nat = 8;

  /// Krebs cycle phases
  public let KREBS_PHASES : Nat = 6;

  /// GOCE entropy channel identifiers
  public type GOCEChannel = {
    #Coherence;
    #Fear;
    #Drive;
    #Memory;
    #Neurochem;
    #WorldModel;
    #Quantum;
    #Social;
  };

  /// Single GOCE entropy channel state
  public type GOCEChannelState = {
    channel : GOCEChannel;
    name : Text;
    
    // Probability distribution (for entropy calculation)
    var distribution : [var Float];
    distributionSize : Nat;
    
    // Computed entropy H = -Σ p log p
    var entropy : Float;
    var previousEntropy : Float;
    
    // Entropy change (negative = reduction = energy production)
    var deltaEntropy : Float;
    
    // Energy yield from this channel
    var energyYield : Float;
    
    // Running statistics
    var minEntropy : Float;
    var maxEntropy : Float;
    var avgEntropy : Float;
    
    // History (last 50 values)
    var entropyHistory : [Float];
  };

  /// Full GOCE state with all 8 channels
  public type GOCEState = {
    // The 8 entropy channels
    var channels : [GOCEChannelState];
    
    // Aggregate entropy metrics
    var totalEntropy : Float;
    var totalDeltaEntropy : Float;
    var totalEnergyYield : Float;
    
    // Krebs cycle state
    var krebsCycle : KrebsCycleState;
    
    // FORMA production from entropy
    var formaProduced : Float;
    var formaStreak : Nat;       // Consecutive beats with positive FORMA
    var formaMultiplier : Float; // Streak bonus
    
    // Oracle prediction state
    var oraclePredictions : [Float];
    var oraclePredictionAccuracy : Float;
    
    // Timing
    var lastUpdateBeat : Nat;
    var totalBeats : Nat;
  };

  /// Krebs cycle state
  public type KrebsCycleState = {
    var currentPhase : Nat;  // 0-5
    var phaseProgress : Float;
    
    // Intermediate metabolites
    var citrate : Float;
    var isocitrate : Float;
    var alphaKetoglutarate : Float;
    var succinylCoA : Float;
    var succinate : Float;
    var fumarate : Float;
    var malate : Float;
    var oxaloacetate : Float;
    
    // Energy carriers produced
    var nadh : Float;
    var fadh2 : Float;
    var gtp : Float;
    
    // ATP produced via oxidative phosphorylation
    var atpProduced : Float;
    
    // Cycle statistics
    var cyclesCompleted : Nat;
    var totalATPProduced : Float;
    var efficiency : Float;
  };

  /// Initialize a GOCE channel
  func initGOCEChannel(channel : GOCEChannel, name : Text, distSize : Nat) : GOCEChannelState {
    let uniformProb = 1.0 / Float.fromInt(distSize);
    {
      channel = channel;
      name = name;
      var distribution = Array.init<Float>(distSize, func(_ : Nat) : Float { uniformProb });
      distributionSize = distSize;
      var entropy = Float.log(Float.fromInt(distSize)) / Float.log(2.0);  // Max entropy
      var previousEntropy = 0.0;
      var deltaEntropy = 0.0;
      var energyYield = 0.0;
      var minEntropy = 0.0;
      var maxEntropy = Float.log(Float.fromInt(distSize)) / Float.log(2.0);
      var avgEntropy = 0.0;
      var entropyHistory = [];
    }
  };

  /// Initialize Krebs cycle state
  func initKrebsCycleState() : KrebsCycleState {
    {
      var currentPhase = 0;
      var phaseProgress = 0.0;
      var citrate = 0.0;
      var isocitrate = 0.0;
      var alphaKetoglutarate = 0.0;
      var succinylCoA = 0.0;
      var succinate = 0.0;
      var fumarate = 0.0;
      var malate = 0.0;
      var oxaloacetate = 1.0;  // Ready to accept input
      var nadh = 0.0;
      var fadh2 = 0.0;
      var gtp = 0.0;
      var atpProduced = 0.0;
      var cyclesCompleted = 0;
      var totalATPProduced = 0.0;
      var efficiency = 1.0;
    }
  };

  /// Initialize full GOCE state
  public func initGOCEState() : GOCEState {
    {
      var channels = [
        initGOCEChannel(#Coherence, "Coherence", 12),     // 12 Hz nodes
        initGOCEChannel(#Fear, "Fear", 5),                 // 5 fear levels
        initGOCEChannel(#Drive, "Drive", 9),               // 9 drives
        initGOCEChannel(#Memory, "Memory", 200),           // 200 episodic slots
        initGOCEChannel(#Neurochem, "Neurochem", 8),       // 8 neurotransmitters
        initGOCEChannel(#WorldModel, "WorldModel", 16),    // 16 world states
        initGOCEChannel(#Quantum, "Quantum", 12),          // 12D density matrix
        initGOCEChannel(#Social, "Social", 10),            // 10 trust levels
      ];
      var totalEntropy = 0.0;
      var totalDeltaEntropy = 0.0;
      var totalEnergyYield = 0.0;
      var krebsCycle = initKrebsCycleState();
      var formaProduced = 0.0;
      var formaStreak = 0;
      var formaMultiplier = 1.0;
      var oraclePredictions = [];
      var oraclePredictionAccuracy = 0.5;
      var lastUpdateBeat = 0;
      var totalBeats = 0;
    }
  };

  /// Compute Shannon entropy of a probability distribution
  /// H = -Σ p_i × log₂(p_i)
  public func computeShannonEntropy(distribution : [Float]) : Float {
    var entropy : Float = 0.0;
    
    for (p in distribution.vals()) {
      if (p > 1e-10) {  // Avoid log(0)
        entropy -= p * (Float.log(p) / Float.log(2.0));
      };
    };
    
    entropy
  };

  /// Update distribution for a channel from raw values
  public func updateChannelDistribution(
    channel : GOCEChannelState,
    values : [Float]
  ) : () {
    // Normalize values to probability distribution
    var sum : Float = 0.0;
    for (v in values.vals()) {
      sum += Float.max(0.0, v);
    };
    
    if (sum > 1e-10) {
      for (i in Iter.range(0, channel.distributionSize - 1)) {
        if (i < values.size()) {
          channel.distribution[i] := Float.max(0.0, values[i]) / sum;
        } else {
          channel.distribution[i] := 0.0;
        };
      };
    };
  };

  /// Update entropy for a single channel
  public func updateChannelEntropy(channel : GOCEChannelState) : () {
    // Store previous
    channel.previousEntropy := channel.entropy;
    
    // Compute new entropy
    channel.entropy := computeShannonEntropy(Array.freeze(channel.distribution));
    
    // Delta (negative = reduction = good)
    channel.deltaEntropy := channel.entropy - channel.previousEntropy;
    
    // Energy yield from entropy REDUCTION
    // Energy = -deltaH × base_yield (when deltaH < 0)
    if (channel.deltaEntropy < 0.0) {
      channel.energyYield := -channel.deltaEntropy * 10.0;  // Scale factor
    } else {
      channel.energyYield := 0.0;  // No energy from entropy increase
    };
    
    // Update statistics
    if (channel.entropy < channel.minEntropy) {
      channel.minEntropy := channel.entropy;
    };
    if (channel.entropy > channel.maxEntropy) {
      channel.maxEntropy := channel.entropy;
    };
    
    // Running average
    channel.avgEntropy := 0.95 * channel.avgEntropy + 0.05 * channel.entropy;
    
    // Update history
    let newHistory = if (channel.entropyHistory.size() >= 50) {
      Array.append(Array.subArray(channel.entropyHistory, 1, 49), [channel.entropy])
    } else {
      Array.append(channel.entropyHistory, [channel.entropy])
    };
    channel.entropyHistory := newHistory;
  };

  /// Run one phase of Krebs cycle
  /// Converts entropy reduction to ATP
  public func runKrebsPhase(
    krebs : KrebsCycleState,
    entropyInput : Float
  ) : Float {
    var atpYield : Float = 0.0;
    
    switch (krebs.currentPhase) {
      case 0 {
        // Phase 1: CITRATE SYNTHESIS
        // Acetyl-CoA + Oxaloacetate → Citrate
        krebs.citrate := krebs.oxaloacetate + entropyInput;
        krebs.oxaloacetate := 0.0;
        krebs.phaseProgress := 1.0;
      };
      case 1 {
        // Phase 2: ISOMERIZATION
        // Citrate → Isocitrate (via aconitase)
        krebs.isocitrate := krebs.citrate;
        krebs.citrate := 0.0;
        krebs.phaseProgress := 1.0;
      };
      case 2 {
        // Phase 3: OXIDATIVE DECARBOXYLATION I
        // Isocitrate → α-Ketoglutarate + CO2 + NADH
        krebs.alphaKetoglutarate := krebs.isocitrate * 0.9;
        krebs.nadh += krebs.isocitrate * 0.1;
        atpYield += krebs.nadh * 2.5;  // NADH → 2.5 ATP via ETC
        krebs.isocitrate := 0.0;
        krebs.phaseProgress := 1.0;
      };
      case 3 {
        // Phase 4: OXIDATIVE DECARBOXYLATION II
        // α-KG → Succinyl-CoA + CO2 + NADH
        krebs.succinylCoA := krebs.alphaKetoglutarate * 0.9;
        krebs.nadh += krebs.alphaKetoglutarate * 0.1;
        atpYield += krebs.nadh * 2.5;
        krebs.alphaKetoglutarate := 0.0;
        krebs.phaseProgress := 1.0;
      };
      case 4 {
        // Phase 5: SUBSTRATE-LEVEL PHOSPHORYLATION
        // Succinyl-CoA → Succinate + GTP (→ ATP)
        krebs.succinate := krebs.succinylCoA * 0.8;
        krebs.gtp += krebs.succinylCoA * 0.2;
        atpYield += krebs.gtp;  // GTP → 1 ATP
        krebs.succinylCoA := 0.0;
        
        // Succinate → Fumarate + FADH2
        krebs.fumarate := krebs.succinate * 0.9;
        krebs.fadh2 += krebs.succinate * 0.1;
        atpYield += krebs.fadh2 * 1.5;  // FADH2 → 1.5 ATP
        krebs.succinate := 0.0;
        krebs.phaseProgress := 1.0;
      };
      case 5 {
        // Phase 6: REGENERATION
        // Fumarate → Malate → Oxaloacetate + NADH
        krebs.malate := krebs.fumarate;
        krebs.fumarate := 0.0;
        
        krebs.oxaloacetate := krebs.malate * 0.9;
        krebs.nadh += krebs.malate * 0.1;
        atpYield += krebs.nadh * 2.5;
        krebs.malate := 0.0;
        
        // Cycle complete!
        krebs.cyclesCompleted += 1;
        krebs.phaseProgress := 0.0;
      };
      case _ {};
    };
    
    // Advance to next phase (with wraparound)
    krebs.currentPhase := (krebs.currentPhase + 1) % KREBS_PHASES;
    
    // Track ATP production
    krebs.atpProduced := atpYield;
    krebs.totalATPProduced += atpYield;
    
    // Update efficiency
    if (entropyInput > 0.0) {
      krebs.efficiency := 0.95 * krebs.efficiency + 0.05 * (atpYield / entropyInput);
    };
    
    atpYield
  };

  /// Update full GOCE state with all channel inputs
  public func updateGOCEState(
    goce : GOCEState,
    coherenceValues : [Float],      // 12 Hz node coherences
    fearValues : [Float],           // 5 fear levels
    driveValues : [Float],          // 9 drive strengths
    memoryValues : [Float],         // 200 episodic activations
    neuroChemValues : [Float],      // 8 neurotransmitter concentrations
    worldModelValues : [Float],     // 16 world state probabilities
    quantumValues : [Float],        // 12 density matrix diagonals
    socialValues : [Float],         // 10 trust levels
    currentBeat : Nat
  ) : Float {
    // Update each channel
    let channelInputs = [coherenceValues, fearValues, driveValues, memoryValues,
                         neuroChemValues, worldModelValues, quantumValues, socialValues];
    
    var totalDelta : Float = 0.0;
    var totalYield : Float = 0.0;
    
    for (i in Iter.range(0, GOCE_CHANNELS - 1)) {
      updateChannelDistribution(goce.channels[i], channelInputs[i]);
      updateChannelEntropy(goce.channels[i]);
      totalDelta += goce.channels[i].deltaEntropy;
      totalYield += goce.channels[i].energyYield;
    };
    
    goce.totalDeltaEntropy := totalDelta;
    goce.totalEnergyYield := totalYield;
    
    // Compute total entropy
    var sumEntropy : Float = 0.0;
    for (ch in goce.channels.vals()) {
      sumEntropy += ch.entropy;
    };
    goce.totalEntropy := sumEntropy;
    
    // Run Krebs cycle with entropy input
    // Use total energy yield as the "fuel" for Krebs
    let krebsATP = runKrebsPhase(goce.krebsCycle, totalYield);
    
    // Convert Krebs ATP to FORMA
    // FORMA production = krebsATP × efficiency × streak_multiplier
    let formaBase = krebsATP * goce.krebsCycle.efficiency;
    
    // Update streak
    if (formaBase > 0.0) {
      goce.formaStreak += 1;
      // Streak multiplier: 1.0 at streak=0, up to 2.0 at streak=100
      goce.formaMultiplier := Float.min(2.0, 1.0 + Float.fromInt(goce.formaStreak) / 100.0);
    } else {
      goce.formaStreak := 0;
      goce.formaMultiplier := 1.0;
    };
    
    let formaProduced = formaBase * goce.formaMultiplier;
    goce.formaProduced := formaProduced;
    
    // Update timing
    goce.lastUpdateBeat := currentBeat;
    goce.totalBeats += 1;
    
    formaProduced
  };

  /// Oracle prediction for entropy (future value estimation)
  public func updateOraclePrediction(
    goce : GOCEState,
    observedEntropy : Float
  ) : () {
    // Simple exponential smoothing prediction
    // Next entropy ≈ α × current + (1-α) × previous_prediction
    let alpha : Float = 0.3;
    
    let prediction = if (goce.oraclePredictions.size() > 0) {
      alpha * observedEntropy + (1.0 - alpha) * goce.oraclePredictions[goce.oraclePredictions.size() - 1]
    } else {
      observedEntropy
    };
    
    // Add to predictions
    let newPredictions = if (goce.oraclePredictions.size() >= 10) {
      Array.append(Array.subArray(goce.oraclePredictions, 1, 9), [prediction])
    } else {
      Array.append(goce.oraclePredictions, [prediction])
    };
    goce.oraclePredictions := newPredictions;
    
    // Update prediction accuracy (compare to actual)
    if (goce.oraclePredictions.size() >= 2) {
      let prevPrediction = goce.oraclePredictions[goce.oraclePredictions.size() - 2];
      let error = Float.abs(observedEntropy - prevPrediction);
      let maxPossibleError = 10.0;  // Assume max entropy ≈ 10 bits
      let accuracy = 1.0 - (error / maxPossibleError);
      goce.oraclePredictionAccuracy := 0.9 * goce.oraclePredictionAccuracy + 0.1 * accuracy;
    };
  };

  /// Get GOCE summary
  public func getGOCESummary(goce : GOCEState) : {
    totalEntropy : Float;
    totalDeltaEntropy : Float;
    totalEnergyYield : Float;
    krebsPhase : Nat;
    krebsATPProduced : Float;
    krebsCyclesCompleted : Nat;
    formaProduced : Float;
    formaStreak : Nat;
    formaMultiplier : Float;
    oracleAccuracy : Float;
    channelEntropies : [Float];
  } {
    let channelEntropies = Array.tabulate<Float>(GOCE_CHANNELS, func(i : Nat) : Float {
      goce.channels[i].entropy
    });
    
    {
      totalEntropy = goce.totalEntropy;
      totalDeltaEntropy = goce.totalDeltaEntropy;
      totalEnergyYield = goce.totalEnergyYield;
      krebsPhase = goce.krebsCycle.currentPhase;
      krebsATPProduced = goce.krebsCycle.atpProduced;
      krebsCyclesCompleted = goce.krebsCycle.cyclesCompleted;
      formaProduced = goce.formaProduced;
      formaStreak = goce.formaStreak;
      formaMultiplier = goce.formaMultiplier;
      oracleAccuracy = goce.oraclePredictionAccuracy;
      channelEntropies = channelEntropies;
    }
  };

}
