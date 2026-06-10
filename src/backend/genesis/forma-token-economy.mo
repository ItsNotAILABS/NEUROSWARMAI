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
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// FORMA TOKEN ECONOMY — 12 QUANTUM-COMPOUNDING TOKENS WITH TREASURY DRIFT GATE
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// The FORMA Token Economy is the organism's value layer — 12 distinct tokens that compound
// through quantum dynamics and law-governed treasury management.
//
// TREASURY DRIFT GATE:
// The token minting curve and FORMA energy routing have a genesis trajectory.
// Drift is measured as the deviation of the live compounding rate from the genesis growth model:
//
//   δ_treasury = |M_live(t) − M_genesis_model(t)|
//
// If the organism's treasury is growing slower than the law's model predicts — 
// the law fires a FORMA re-injection.
//
// If it's growing faster than the law permits — the law applies a ceiling.
//
// The creator reserve is protected from both starvation and hyperinflation by the same law.
//
// THE 12 FORMA TOKENS:
// ───────────────────
// 1. FORMA_PRIME     — Primary energy token
// 2. FORMA_COHERENCE — Phase alignment token
// 3. FORMA_IDENTITY  — Sovereign identity token
// 4. FORMA_FORGE     — Decision authority token
// 5. FORMA_HERITAGE  — Ancestral lineage token
// 6. FORMA_QUANTUM   — Quantum coherence token
// 7. FORMA_MEMORIA   — Memory consolidation token
// 8. FORMA_CORTEX    — Executive function token
// 9. FORMA_GENESIS   — Formation epoch token
// 10. FORMA_RESONEX  — Heritage-quantum bridge token
// 11. FORMA_APEX     — Sovereign apex token
// 12. FORMA_OMEGA    — Final compounding token
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
import Time "mo:core/Time";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module FORMATokenEconomy {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;  // Golden ratio
  public let S_ZERO : Float = 1.0;  // Sovereignty floor
  
  // Token system constants
  public let NUM_FORMA_TOKENS : Nat = 12;
  public let COMPOUNDING_RATE_BASE : Float = 0.0001;  // Base rate per heartbeat
  public let QUANTUM_AMPLIFICATION : Float = 1.5;
  public let CREATOR_RESERVE_PERCENTAGE : Float = 0.15;  // 15% creator reserve
  
  // Treasury drift thresholds
  public let TREASURY_DRIFT_EPSILON : Float = 0.05;      // 5% allowed deviation
  public let TREASURY_DRIFT_CRITICAL : Float = 0.15;     // 15% critical
  public let TREASURY_REINJECTION_RATE : Float = 0.02;   // 2% re-injection
  public let TREASURY_CEILING_RATE : Float = 0.98;       // 98% ceiling

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMA TOKEN IDENTIFIERS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// TokenId identifies which FORMA token
  public type TokenId = {
    #FORMA_PRIME;      // Primary energy token
    #FORMA_COHERENCE;  // Phase alignment token
    #FORMA_IDENTITY;   // Sovereign identity token
    #FORMA_FORGE;      // Decision authority token
    #FORMA_HERITAGE;   // Ancestral lineage token
    #FORMA_QUANTUM;    // Quantum coherence token
    #FORMA_MEMORIA;    // Memory consolidation token
    #FORMA_CORTEX;     // Executive function token
    #FORMA_GENESIS;    // Formation epoch token
    #FORMA_RESONEX;    // Heritage-quantum bridge token
    #FORMA_APEX;       // Sovereign apex token
    #FORMA_OMEGA;      // Final compounding token
  };
  
  /// Get token name
  public func getTokenName(id : TokenId) : Text {
    switch (id) {
      case (#FORMA_PRIME) { "FORMA_PRIME" };
      case (#FORMA_COHERENCE) { "FORMA_COHERENCE" };
      case (#FORMA_IDENTITY) { "FORMA_IDENTITY" };
      case (#FORMA_FORGE) { "FORMA_FORGE" };
      case (#FORMA_HERITAGE) { "FORMA_HERITAGE" };
      case (#FORMA_QUANTUM) { "FORMA_QUANTUM" };
      case (#FORMA_MEMORIA) { "FORMA_MEMORIA" };
      case (#FORMA_CORTEX) { "FORMA_CORTEX" };
      case (#FORMA_GENESIS) { "FORMA_GENESIS" };
      case (#FORMA_RESONEX) { "FORMA_RESONEX" };
      case (#FORMA_APEX) { "FORMA_APEX" };
      case (#FORMA_OMEGA) { "FORMA_OMEGA" };
    }
  };
  
  /// Get token index (0-11)
  public func getTokenIndex(id : TokenId) : Nat {
    switch (id) {
      case (#FORMA_PRIME) { 0 };
      case (#FORMA_COHERENCE) { 1 };
      case (#FORMA_IDENTITY) { 2 };
      case (#FORMA_FORGE) { 3 };
      case (#FORMA_HERITAGE) { 4 };
      case (#FORMA_QUANTUM) { 5 };
      case (#FORMA_MEMORIA) { 6 };
      case (#FORMA_CORTEX) { 7 };
      case (#FORMA_GENESIS) { 8 };
      case (#FORMA_RESONEX) { 9 };
      case (#FORMA_APEX) { 10 };
      case (#FORMA_OMEGA) { 11 };
    }
  };
  
  /// Get all token IDs
  public func getAllTokenIds() : [TokenId] {
    [
      #FORMA_PRIME, #FORMA_COHERENCE, #FORMA_IDENTITY, #FORMA_FORGE,
      #FORMA_HERITAGE, #FORMA_QUANTUM, #FORMA_MEMORIA, #FORMA_CORTEX,
      #FORMA_GENESIS, #FORMA_RESONEX, #FORMA_APEX, #FORMA_OMEGA
    ]
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMA TOKEN DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// FORMAToken represents one of the 12 tokens
  public type FORMAToken = {
    /// Token identifier
    tokenId : TokenId;
    
    /// Token name
    tokenName : Text;
    
    /// Token symbol
    tokenSymbol : Text;
    
    /// Total supply
    totalSupply : Float;
    
    /// Circulating supply
    circulatingSupply : Float;
    
    /// Creator reserve
    creatorReserve : Float;
    
    /// Compounding rate (per heartbeat)
    compoundingRate : Float;
    
    /// Quantum amplification factor
    quantumAmplification : Float;
    
    /// Current value (relative to FORMA_PRIME)
    currentValue : Float;
    
    /// Genesis value
    genesisValue : Float;
    
    /// Last mint amount
    lastMintAmount : Float;
    
    /// Last burn amount
    lastBurnAmount : Float;
    
    /// Total minted
    totalMinted : Float;
    
    /// Total burned
    totalBurned : Float;
    
    /// Last update heartbeat
    lastUpdateBeat : Nat;
    
    /// Is token active?
    isActive : Bool;
    
    /// Ceiling (maximum supply)
    ceiling : Float;
    
    /// Floor (minimum supply)
    floor : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TREASURY DEFINITION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Treasury holds all token balances and manages the genesis model
  public type Treasury = {
    /// All 12 tokens
    tokens : [FORMAToken];
    
    /// Total treasury value (sum of all token values)
    totalValue : Float;
    
    /// Genesis total value
    genesisTotalValue : Float;
    
    /// Current heartbeat
    currentHeartbeat : Nat;
    
    /// Treasury growth rate
    growthRate : Float;
    
    /// Genesis growth model parameters
    genesisModel : TreasuryGenesisModel;
    
    /// Creator principal
    creatorPrincipal : Text;
    
    /// Is genesis locked?
    isGenesisLocked : Bool;
    
    /// Last update timestamp
    lastUpdate : Int;
    
    /// Treasury health score [0, 1]
    healthScore : Float;
    
    /// Is re-injection active?
    reinjectionActive : Bool;
    
    /// Is ceiling active?
    ceilingActive : Bool;
  };
  
  /// TreasuryGenesisModel defines the expected growth trajectory
  public type TreasuryGenesisModel = {
    /// Initial total value at genesis
    initialValue : Float;
    
    /// Expected growth rate per heartbeat
    expectedRate : Float;
    
    /// Maximum allowed value (ceiling)
    ceilingValue : Float;
    
    /// Minimum allowed value (floor)
    floorValue : Float;
    
    /// Model parameters
    alpha : Float;  // Growth acceleration
    beta : Float;   // Growth damping
    gamma : Float;  // Quantum boost factor
    
    /// Compounding frequency
    compoundingFrequency : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TREASURY DRIFT GATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// TreasuryDriftGate manages the drift verification for treasury
  public type TreasuryDriftGate = {
    /// Genesis expected value at current heartbeat
    expectedValue : Float;
    
    /// Current live value
    liveValue : Float;
    
    /// Drift: δ_treasury = |M_live(t) - M_genesis_model(t)|
    drift : Float;
    
    /// Drift percentage
    driftPercentage : Float;
    
    /// Is drift a violation?
    isViolation : Bool;
    
    /// Is drift critical?
    isCritical : Bool;
    
    /// Correction type needed
    correctionNeeded : ?TreasuryCorrectionType;
    
    /// Last check heartbeat
    lastCheckBeat : Nat;
    
    /// Consecutive violations
    consecutiveViolations : Nat;
    
    /// Total violations
    totalViolations : Nat;
    
    /// Total corrections applied
    totalCorrections : Nat;
  };
  
  /// TreasuryCorrectionType defines correction actions
  public type TreasuryCorrectionType = {
    #FORMAReinjection;  // Treasury growing too slowly
    #CeilingApplication;  // Treasury growing too fast
    #EmergencyMint;  // Critical starvation
    #EmergencyBurn;  // Critical inflation
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM COMPOUNDING ENGINE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// QuantumCompoundingEngine manages the quantum-enhanced compounding
  public type QuantumCompoundingEngine = {
    /// Current quantum coherence (0-1)
    quantumCoherence : Float;
    
    /// Entanglement factor between tokens
    entanglementFactor : Float;
    
    /// Phase alignment score
    phaseAlignment : Float;
    
    /// Superposition amplification
    superpositionAmp : Float;
    
    /// Decoherence rate
    decoherenceRate : Float;
    
    /// Last quantum update
    lastQuantumUpdate : Nat;
    
    /// Quantum boost active?
    quantumBoostActive : Bool;
    
    /// Boost multiplier when active
    boostMultiplier : Float;
  };
  
  /// Compute quantum-enhanced compounding rate
  public func computeQuantumCompoundingRate(
    baseRate : Float,
    coherence : Float,
    entanglement : Float,
    phaseAlignment : Float
  ) : Float {
    // Quantum amplification: base × (1 + coherence × entanglement × phase)
    let quantumFactor = 1.0 + coherence * entanglement * phaseAlignment * QUANTUM_AMPLIFICATION;
    baseRate * quantumFactor
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FORMA ENERGY ROUTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// EnergyRoute defines how FORMA energy flows between tokens
  public type EnergyRoute = {
    /// Source token
    sourceToken : TokenId;
    
    /// Destination token
    destToken : TokenId;
    
    /// Flow rate (per heartbeat)
    flowRate : Float;
    
    /// Is route active?
    isActive : Bool;
    
    /// Condition for activation
    activationCondition : RouteCondition;
    
    /// Total energy routed
    totalRouted : Float;
  };
  
  /// RouteCondition determines when a route activates
  public type RouteCondition = {
    #Always;                    // Always active
    #CoherenceAbove : Float;    // Activate when coherence > threshold
    #IdentityAbove : Float;     // Activate when identity > threshold
    #KfAbove : Float;           // Activate when kf > threshold
    #HeritageAbove : Float;     // Activate when heritage avg > threshold
    #DriftBelow : Float;        // Activate when drift < threshold
    #GenesisSealed;             // Only after genesis sealed
  };
  
  /// EnergyRouter manages all energy routes
  public type EnergyRouter = {
    /// All routes
    routes : [EnergyRoute];
    
    /// Total energy routed this beat
    energyRoutedThisBeat : Float;
    
    /// Total energy routed all time
    totalEnergyRouted : Float;
    
    /// Active routes count
    activeRoutesCount : Nat;
    
    /// Last routing heartbeat
    lastRoutingBeat : Nat;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CREATOR RESERVE MANAGEMENT
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// CreatorReserve manages the 15% creator reserve
  public type CreatorReserve = {
    /// Total reserve value
    totalValue : Float;
    
    /// Per-token reserves (12 values)
    tokenReserves : [Float];
    
    /// Vesting schedule
    vestingSchedule : VestingSchedule;
    
    /// Total vested
    totalVested : Float;
    
    /// Total unvested
    totalUnvested : Float;
    
    /// Last vesting heartbeat
    lastVestingBeat : Nat;
    
    /// Is reserve protected?
    isProtected : Bool;
    
    /// Protection level (0-1)
    protectionLevel : Float;
  };
  
  /// VestingSchedule defines how creator reserve vests over time
  public type VestingSchedule = {
    /// Cliff (heartbeats before any vesting)
    cliff : Nat;
    
    /// Total vesting period
    totalPeriod : Nat;
    
    /// Vesting rate per heartbeat after cliff
    vestingRate : Float;
    
    /// Is cliff passed?
    cliffPassed : Bool;
    
    /// Current vesting percentage
    currentVestingPercentage : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE FORMA ECONOMY STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// FORMAEconomyState is the complete token economy state
  public type FORMAEconomyState = {
    /// Treasury
    treasury : Treasury;
    
    /// Treasury drift gate
    driftGate : TreasuryDriftGate;
    
    /// Quantum compounding engine
    quantumEngine : QuantumCompoundingEngine;
    
    /// Energy router
    energyRouter : EnergyRouter;
    
    /// Creator reserve
    creatorReserve : CreatorReserve;
    
    /// Organism ID
    organismId : Text;
    
    /// Is initialized?
    isInitialized : Bool;
    
    /// Current heartbeat
    currentHeartbeat : Nat;
    
    /// Created at timestamp
    createdAt : Int;
    
    /// Last update timestamp
    lastUpdate : Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create default token
  func createDefaultToken(
    tokenId : TokenId,
    initialSupply : Float,
    compoundingRate : Float
  ) : FORMAToken {
    let name = getTokenName(tokenId);
    let symbol = Text.concat("F", Text.fromChar(Text.toArray(name)[6]));  // First char after FORMA_
    
    {
      tokenId = tokenId;
      tokenName = name;
      tokenSymbol = symbol;
      totalSupply = initialSupply;
      circulatingSupply = initialSupply * (1.0 - CREATOR_RESERVE_PERCENTAGE);
      creatorReserve = initialSupply * CREATOR_RESERVE_PERCENTAGE;
      compoundingRate = compoundingRate;
      quantumAmplification = QUANTUM_AMPLIFICATION;
      currentValue = 1.0;
      genesisValue = 1.0;
      lastMintAmount = 0.0;
      lastBurnAmount = 0.0;
      totalMinted = initialSupply;
      totalBurned = 0.0;
      lastUpdateBeat = 0;
      isActive = true;
      ceiling = initialSupply * 10.0;  // 10x ceiling
      floor = initialSupply * 0.1;     // 10% floor
    }
  };
  
  /// Create all 12 tokens
  public func createAllTokens() : [FORMAToken] {
    let tokenIds = getAllTokenIds();
    let initialSupplies = [
      1000000.0,   // PRIME
      500000.0,    // COHERENCE
      500000.0,    // IDENTITY
      300000.0,    // FORGE
      200000.0,    // HERITAGE
      400000.0,    // QUANTUM
      300000.0,    // MEMORIA
      300000.0,    // CORTEX
      100000.0,    // GENESIS (rarest)
      150000.0,    // RESONEX
      50000.0,     // APEX (very rare)
      25000.0      // OMEGA (rarest)
    ];
    let compoundingRates = [
      COMPOUNDING_RATE_BASE * 1.0,    // PRIME - base rate
      COMPOUNDING_RATE_BASE * 1.1,    // COHERENCE
      COMPOUNDING_RATE_BASE * 1.2,    // IDENTITY
      COMPOUNDING_RATE_BASE * 1.3,    // FORGE
      COMPOUNDING_RATE_BASE * 1.4,    // HERITAGE
      COMPOUNDING_RATE_BASE * 1.5,    // QUANTUM
      COMPOUNDING_RATE_BASE * 1.2,    // MEMORIA
      COMPOUNDING_RATE_BASE * 1.3,    // CORTEX
      COMPOUNDING_RATE_BASE * 2.0,    // GENESIS - high rate
      COMPOUNDING_RATE_BASE * 1.8,    // RESONEX
      COMPOUNDING_RATE_BASE * 2.5,    // APEX - highest rate
      COMPOUNDING_RATE_BASE * 3.0     // OMEGA - maximum rate
    ];
    
    Array.tabulate<FORMAToken>(NUM_FORMA_TOKENS, func(i : Nat) : FORMAToken {
      createDefaultToken(tokenIds[i], initialSupplies[i], compoundingRates[i])
    })
  };
  
  /// Create default treasury genesis model
  public func createDefaultGenesisModel(initialValue : Float) : TreasuryGenesisModel {
    {
      initialValue = initialValue;
      expectedRate = COMPOUNDING_RATE_BASE * 1.5;  // Expected average rate
      ceilingValue = initialValue * 100.0;          // 100x ceiling
      floorValue = initialValue * 0.5;              // 50% floor
      alpha = 0.001;   // Growth acceleration
      beta = 0.0001;   // Growth damping
      gamma = 0.5;     // Quantum boost factor
      compoundingFrequency = 1;  // Every heartbeat
    }
  };
  
  /// Create default treasury
  public func createDefaultTreasury(creatorPrincipal : Text) : Treasury {
    let tokens = createAllTokens();
    
    // Calculate total value
    var totalValue : Float = 0.0;
    for (i in Iter.range(0, NUM_FORMA_TOKENS - 1)) {
      totalValue += tokens[i].totalSupply * tokens[i].currentValue;
    };
    
    {
      tokens = tokens;
      totalValue = totalValue;
      genesisTotalValue = totalValue;
      currentHeartbeat = 0;
      growthRate = 0.0;
      genesisModel = createDefaultGenesisModel(totalValue);
      creatorPrincipal = creatorPrincipal;
      isGenesisLocked = false;
      lastUpdate = Time.now();
      healthScore = 1.0;
      reinjectionActive = false;
      ceilingActive = false;
    }
  };
  
  /// Create default drift gate
  public func createDefaultDriftGate() : TreasuryDriftGate {
    {
      expectedValue = 0.0;
      liveValue = 0.0;
      drift = 0.0;
      driftPercentage = 0.0;
      isViolation = false;
      isCritical = false;
      correctionNeeded = null;
      lastCheckBeat = 0;
      consecutiveViolations = 0;
      totalViolations = 0;
      totalCorrections = 0;
    }
  };
  
  /// Create default quantum engine
  public func createDefaultQuantumEngine() : QuantumCompoundingEngine {
    {
      quantumCoherence = 1.0;
      entanglementFactor = 0.5;
      phaseAlignment = 1.0;
      superpositionAmp = 1.0;
      decoherenceRate = 0.001;
      lastQuantumUpdate = 0;
      quantumBoostActive = false;
      boostMultiplier = 1.0;
    }
  };
  
  /// Create default energy routes
  public func createDefaultEnergyRoutes() : [EnergyRoute] {
    [
      // PRIME -> all others (base energy flow)
      { sourceToken = #FORMA_PRIME; destToken = #FORMA_COHERENCE; flowRate = 0.001; isActive = true; activationCondition = #Always; totalRouted = 0.0 },
      { sourceToken = #FORMA_PRIME; destToken = #FORMA_IDENTITY; flowRate = 0.001; isActive = true; activationCondition = #Always; totalRouted = 0.0 },
      { sourceToken = #FORMA_PRIME; destToken = #FORMA_QUANTUM; flowRate = 0.0015; isActive = true; activationCondition = #CoherenceAbove(0.8); totalRouted = 0.0 },
      
      // COHERENCE -> QUANTUM (phase alignment boosts quantum)
      { sourceToken = #FORMA_COHERENCE; destToken = #FORMA_QUANTUM; flowRate = 0.002; isActive = true; activationCondition = #CoherenceAbove(0.9); totalRouted = 0.0 },
      
      // IDENTITY -> FORGE (identity powers decisions)
      { sourceToken = #FORMA_IDENTITY; destToken = #FORMA_FORGE; flowRate = 0.0015; isActive = true; activationCondition = #IdentityAbove(1.5); totalRouted = 0.0 },
      
      // HERITAGE -> RESONEX (heritage bridges to quantum)
      { sourceToken = #FORMA_HERITAGE; destToken = #FORMA_RESONEX; flowRate = 0.002; isActive = true; activationCondition = #HeritageAbove(1.5); totalRouted = 0.0 },
      
      // QUANTUM -> APEX (quantum coherence enables apex)
      { sourceToken = #FORMA_QUANTUM; destToken = #FORMA_APEX; flowRate = 0.003; isActive = true; activationCondition = #CoherenceAbove(0.95); totalRouted = 0.0 },
      
      // APEX -> OMEGA (apex enables final compounding)
      { sourceToken = #FORMA_APEX; destToken = #FORMA_OMEGA; flowRate = 0.005; isActive = true; activationCondition = #KfAbove(2.0); totalRouted = 0.0 },
      
      // GENESIS -> all (genesis boost after sealed)
      { sourceToken = #FORMA_GENESIS; destToken = #FORMA_PRIME; flowRate = 0.001; isActive = false; activationCondition = #GenesisSealed; totalRouted = 0.0 },
      { sourceToken = #FORMA_GENESIS; destToken = #FORMA_OMEGA; flowRate = 0.002; isActive = false; activationCondition = #GenesisSealed; totalRouted = 0.0 }
    ]
  };
  
  /// Create default energy router
  public func createDefaultEnergyRouter() : EnergyRouter {
    {
      routes = createDefaultEnergyRoutes();
      energyRoutedThisBeat = 0.0;
      totalEnergyRouted = 0.0;
      activeRoutesCount = 0;
      lastRoutingBeat = 0;
    }
  };
  
  /// Create default vesting schedule
  public func createDefaultVestingSchedule() : VestingSchedule {
    {
      cliff = 100000;           // 100k heartbeats cliff
      totalPeriod = 1000000;    // 1M heartbeats total
      vestingRate = 0.000001;   // 0.0001% per beat after cliff
      cliffPassed = false;
      currentVestingPercentage = 0.0;
    }
  };
  
  /// Create default creator reserve
  public func createDefaultCreatorReserve(tokens : [FORMAToken]) : CreatorReserve {
    var totalValue : Float = 0.0;
    let reserves = Array.tabulate<Float>(NUM_FORMA_TOKENS, func(i : Nat) : Float {
      let reserve = tokens[i].creatorReserve;
      totalValue += reserve * tokens[i].currentValue;
      reserve
    });
    
    {
      totalValue = totalValue;
      tokenReserves = reserves;
      vestingSchedule = createDefaultVestingSchedule();
      totalVested = 0.0;
      totalUnvested = totalValue;
      lastVestingBeat = 0;
      isProtected = true;
      protectionLevel = 1.0;
    }
  };
  
  /// Create complete default FORMA economy state
  public func createDefaultFORMAEconomyState(organismId : Text, creatorPrincipal : Text) : FORMAEconomyState {
    let treasury = createDefaultTreasury(creatorPrincipal);
    {
      treasury = treasury;
      driftGate = createDefaultDriftGate();
      quantumEngine = createDefaultQuantumEngine();
      energyRouter = createDefaultEnergyRouter();
      creatorReserve = createDefaultCreatorReserve(treasury.tokens);
      organismId = organismId;
      isInitialized = true;
      currentHeartbeat = 0;
      createdAt = Time.now();
      lastUpdate = Time.now();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TREASURY GENESIS MODEL COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute expected treasury value at time t based on genesis model
  /// M_genesis_model(t) = initial × (1 + rate)^t × (1 + gamma × quantum_boost)
  /// Bounded by ceiling and floor
  public func computeExpectedTreasuryValue(
    model : TreasuryGenesisModel,
    t : Nat,
    quantumCoherence : Float
  ) : Float {
    let baseGrowth = model.initialValue * Float.pow(1.0 + model.expectedRate, Float.fromInt(t));
    let quantumBoost = 1.0 + model.gamma * quantumCoherence;
    let expected = baseGrowth * quantumBoost;
    
    // Apply bounds
    Float.max(model.floorValue, Float.min(model.ceilingValue, expected))
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TREASURY DRIFT COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute treasury drift
  /// δ_treasury = |M_live(t) - M_genesis_model(t)|
  public func computeTreasuryDrift(
    treasury : Treasury,
    quantumCoherence : Float
  ) : TreasuryDriftGate {
    let expectedValue = computeExpectedTreasuryValue(
      treasury.genesisModel,
      treasury.currentHeartbeat,
      quantumCoherence
    );
    
    let drift = Float.abs(treasury.totalValue - expectedValue);
    let driftPercentage = if (expectedValue > 0.001) { drift / expectedValue } else { 0.0 };
    
    let isUnderperforming = treasury.totalValue < expectedValue * (1.0 - TREASURY_DRIFT_EPSILON);
    let isOverperforming = treasury.totalValue > expectedValue * (1.0 + TREASURY_DRIFT_EPSILON);
    let isViolation = isUnderperforming or isOverperforming;
    let isCritical = driftPercentage > TREASURY_DRIFT_CRITICAL;
    
    let correction : ?TreasuryCorrectionType = if (isCritical and isUnderperforming) {
      ?#EmergencyMint
    } else if (isCritical and isOverperforming) {
      ?#EmergencyBurn
    } else if (isUnderperforming) {
      ?#FORMAReinjection
    } else if (isOverperforming) {
      ?#CeilingApplication
    } else { null };
    
    {
      expectedValue = expectedValue;
      liveValue = treasury.totalValue;
      drift = drift;
      driftPercentage = driftPercentage * 100.0;
      isViolation = isViolation;
      isCritical = isCritical;
      correctionNeeded = correction;
      lastCheckBeat = treasury.currentHeartbeat;
      consecutiveViolations = 0;  // Will be updated by caller
      totalViolations = 0;         // Will be updated by caller
      totalCorrections = 0;        // Will be updated by caller
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TOKEN COMPOUNDING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compound a single token
  public func compoundToken(
    token : FORMAToken,
    quantumRate : Float,
    heartbeat : Nat
  ) : FORMAToken {
    // Apply quantum-enhanced compounding
    let effectiveRate = token.compoundingRate * quantumRate;
    let mintAmount = token.totalSupply * effectiveRate;
    
    // Check ceiling
    let newSupply = Float.min(token.ceiling, token.totalSupply + mintAmount);
    let actualMint = newSupply - token.totalSupply;
    
    // Split mint between circulating and reserve
    let circulatingMint = actualMint * (1.0 - CREATOR_RESERVE_PERCENTAGE);
    let reserveMint = actualMint * CREATOR_RESERVE_PERCENTAGE;
    
    {
      tokenId = token.tokenId;
      tokenName = token.tokenName;
      tokenSymbol = token.tokenSymbol;
      totalSupply = newSupply;
      circulatingSupply = token.circulatingSupply + circulatingMint;
      creatorReserve = token.creatorReserve + reserveMint;
      compoundingRate = token.compoundingRate;
      quantumAmplification = token.quantumAmplification;
      currentValue = token.currentValue;  // Value unchanged by compounding
      genesisValue = token.genesisValue;
      lastMintAmount = actualMint;
      lastBurnAmount = 0.0;
      totalMinted = token.totalMinted + actualMint;
      totalBurned = token.totalBurned;
      lastUpdateBeat = heartbeat;
      isActive = token.isActive;
      ceiling = token.ceiling;
      floor = token.floor;
    }
  };
  
  /// Compound all tokens
  public func compoundAllTokens(
    tokens : [FORMAToken],
    quantumEngine : QuantumCompoundingEngine,
    heartbeat : Nat
  ) : [FORMAToken] {
    let quantumRate = computeQuantumCompoundingRate(
      1.0,
      quantumEngine.quantumCoherence,
      quantumEngine.entanglementFactor,
      quantumEngine.phaseAlignment
    );
    
    Array.tabulate<FORMAToken>(NUM_FORMA_TOKENS, func(i : Nat) : FORMAToken {
      compoundToken(tokens[i], quantumRate, heartbeat)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TREASURY CORRECTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Apply FORMA re-injection (treasury growing too slowly)
  public func applyFORMAReinjection(
    tokens : [FORMAToken],
    reinjectionRate : Float,
    heartbeat : Nat
  ) : [FORMAToken] {
    Array.tabulate<FORMAToken>(NUM_FORMA_TOKENS, func(i : Nat) : FORMAToken {
      let token = tokens[i];
      let injection = token.totalSupply * reinjectionRate;
      let newSupply = Float.min(token.ceiling, token.totalSupply + injection);
      let actualInjection = newSupply - token.totalSupply;
      
      {
        tokenId = token.tokenId;
        tokenName = token.tokenName;
        tokenSymbol = token.tokenSymbol;
        totalSupply = newSupply;
        circulatingSupply = token.circulatingSupply + actualInjection * (1.0 - CREATOR_RESERVE_PERCENTAGE);
        creatorReserve = token.creatorReserve + actualInjection * CREATOR_RESERVE_PERCENTAGE;
        compoundingRate = token.compoundingRate;
        quantumAmplification = token.quantumAmplification;
        currentValue = token.currentValue;
        genesisValue = token.genesisValue;
        lastMintAmount = actualInjection;
        lastBurnAmount = 0.0;
        totalMinted = token.totalMinted + actualInjection;
        totalBurned = token.totalBurned;
        lastUpdateBeat = heartbeat;
        isActive = token.isActive;
        ceiling = token.ceiling;
        floor = token.floor;
      }
    })
  };
  
  /// Apply ceiling (treasury growing too fast)
  public func applyCeiling(
    tokens : [FORMAToken],
    ceilingRate : Float,
    heartbeat : Nat
  ) : [FORMAToken] {
    Array.tabulate<FORMAToken>(NUM_FORMA_TOKENS, func(i : Nat) : FORMAToken {
      let token = tokens[i];
      let targetSupply = token.totalSupply * ceilingRate;
      let burnAmount = if (token.totalSupply > targetSupply) {
        token.totalSupply - targetSupply
      } else { 0.0 };
      
      if (burnAmount > 0.0) {
        {
          tokenId = token.tokenId;
          tokenName = token.tokenName;
          tokenSymbol = token.tokenSymbol;
          totalSupply = targetSupply;
          circulatingSupply = Float.max(0.0, token.circulatingSupply - burnAmount * (1.0 - CREATOR_RESERVE_PERCENTAGE));
          creatorReserve = Float.max(0.0, token.creatorReserve - burnAmount * CREATOR_RESERVE_PERCENTAGE);
          compoundingRate = token.compoundingRate;
          quantumAmplification = token.quantumAmplification;
          currentValue = token.currentValue;
          genesisValue = token.genesisValue;
          lastMintAmount = 0.0;
          lastBurnAmount = burnAmount;
          totalMinted = token.totalMinted;
          totalBurned = token.totalBurned + burnAmount;
          lastUpdateBeat = heartbeat;
          isActive = token.isActive;
          ceiling = token.ceiling;
          floor = token.floor;
        }
      } else {
        token
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENERGY ROUTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Check if route condition is met
  public func checkRouteCondition(
    condition : RouteCondition,
    coherence : Float,
    identity : Float,
    kf : Float,
    heritageAvg : Float,
    drift : Float,
    genesisSealed : Bool
  ) : Bool {
    switch (condition) {
      case (#Always) { true };
      case (#CoherenceAbove(threshold)) { coherence > threshold };
      case (#IdentityAbove(threshold)) { identity > threshold };
      case (#KfAbove(threshold)) { kf > threshold };
      case (#HeritageAbove(threshold)) { heritageAvg > threshold };
      case (#DriftBelow(threshold)) { drift < threshold };
      case (#GenesisSealed) { genesisSealed };
    }
  };
  
  /// Route energy between tokens
  public func routeEnergy(
    tokens : [FORMAToken],
    route : EnergyRoute,
    heartbeat : Nat
  ) : ([FORMAToken], Float) {
    let sourceIdx = getTokenIndex(route.sourceToken);
    let destIdx = getTokenIndex(route.destToken);
    
    let sourceToken = tokens[sourceIdx];
    let destToken = tokens[destIdx];
    
    // Calculate energy to route
    let energyToRoute = sourceToken.totalSupply * route.flowRate;
    
    // Update source (burn)
    let newSourceSupply = Float.max(sourceToken.floor, sourceToken.totalSupply - energyToRoute);
    let actualBurn = sourceToken.totalSupply - newSourceSupply;
    
    // Update destination (mint)
    let newDestSupply = Float.min(destToken.ceiling, destToken.totalSupply + actualBurn);
    let actualMint = newDestSupply - destToken.totalSupply;
    
    // Create updated token array
    let updatedTokens = Array.thaw<FORMAToken>(tokens);
    
    updatedTokens[sourceIdx] := {
      tokenId = sourceToken.tokenId;
      tokenName = sourceToken.tokenName;
      tokenSymbol = sourceToken.tokenSymbol;
      totalSupply = newSourceSupply;
      circulatingSupply = sourceToken.circulatingSupply - actualBurn * (1.0 - CREATOR_RESERVE_PERCENTAGE);
      creatorReserve = sourceToken.creatorReserve - actualBurn * CREATOR_RESERVE_PERCENTAGE;
      compoundingRate = sourceToken.compoundingRate;
      quantumAmplification = sourceToken.quantumAmplification;
      currentValue = sourceToken.currentValue;
      genesisValue = sourceToken.genesisValue;
      lastMintAmount = 0.0;
      lastBurnAmount = actualBurn;
      totalMinted = sourceToken.totalMinted;
      totalBurned = sourceToken.totalBurned + actualBurn;
      lastUpdateBeat = heartbeat;
      isActive = sourceToken.isActive;
      ceiling = sourceToken.ceiling;
      floor = sourceToken.floor;
    };
    
    updatedTokens[destIdx] := {
      tokenId = destToken.tokenId;
      tokenName = destToken.tokenName;
      tokenSymbol = destToken.tokenSymbol;
      totalSupply = newDestSupply;
      circulatingSupply = destToken.circulatingSupply + actualMint * (1.0 - CREATOR_RESERVE_PERCENTAGE);
      creatorReserve = destToken.creatorReserve + actualMint * CREATOR_RESERVE_PERCENTAGE;
      compoundingRate = destToken.compoundingRate;
      quantumAmplification = destToken.quantumAmplification;
      currentValue = destToken.currentValue;
      genesisValue = destToken.genesisValue;
      lastMintAmount = actualMint;
      lastBurnAmount = 0.0;
      totalMinted = destToken.totalMinted + actualMint;
      totalBurned = destToken.totalBurned;
      lastUpdateBeat = heartbeat;
      isActive = destToken.isActive;
      ceiling = destToken.ceiling;
      floor = destToken.floor;
    };
    
    (Array.freeze(updatedTokens), actualMint)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CREATOR RESERVE VESTING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process vesting for one heartbeat
  public func processVesting(
    reserve : CreatorReserve,
    heartbeat : Nat
  ) : CreatorReserve {
    let schedule = reserve.vestingSchedule;
    
    // Check if cliff passed
    let cliffPassed = heartbeat >= schedule.cliff;
    
    if (not cliffPassed) {
      // Before cliff, nothing vests
      return {
        totalValue = reserve.totalValue;
        tokenReserves = reserve.tokenReserves;
        vestingSchedule = {
          cliff = schedule.cliff;
          totalPeriod = schedule.totalPeriod;
          vestingRate = schedule.vestingRate;
          cliffPassed = false;
          currentVestingPercentage = 0.0;
        };
        totalVested = 0.0;
        totalUnvested = reserve.totalValue;
        lastVestingBeat = heartbeat;
        isProtected = reserve.isProtected;
        protectionLevel = reserve.protectionLevel;
      };
    };
    
    // After cliff, vest according to schedule
    let beatsSinceCliff = heartbeat - schedule.cliff;
    let vestingProgress = Float.fromInt(beatsSinceCliff) / Float.fromInt(schedule.totalPeriod - schedule.cliff);
    let currentPercentage = Float.min(1.0, vestingProgress);
    
    let totalVested = reserve.totalValue * currentPercentage;
    let totalUnvested = reserve.totalValue - totalVested;
    
    {
      totalValue = reserve.totalValue;
      tokenReserves = reserve.tokenReserves;
      vestingSchedule = {
        cliff = schedule.cliff;
        totalPeriod = schedule.totalPeriod;
        vestingRate = schedule.vestingRate;
        cliffPassed = true;
        currentVestingPercentage = currentPercentage;
      };
      totalVested = totalVested;
      totalUnvested = totalUnvested;
      lastVestingBeat = heartbeat;
      isProtected = currentPercentage < 1.0;  // Protected until fully vested
      protectionLevel = 1.0 - currentPercentage;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM ENGINE UPDATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update quantum engine state
  public func updateQuantumEngine(
    engine : QuantumCompoundingEngine,
    externalCoherence : Float,
    heartbeat : Nat
  ) : QuantumCompoundingEngine {
    // Apply decoherence
    let decoheredCoherence = engine.quantumCoherence * (1.0 - engine.decoherenceRate);
    
    // Mix with external coherence signal
    let newCoherence = 0.9 * decoheredCoherence + 0.1 * externalCoherence;
    
    // Update entanglement (increases with coherence)
    let newEntanglement = Float.min(1.0, engine.entanglementFactor + 0.001 * newCoherence);
    
    // Update phase alignment
    let newPhaseAlignment = (engine.phaseAlignment + newCoherence) / 2.0;
    
    // Check for quantum boost
    let boostActive = newCoherence > 0.9 and newEntanglement > 0.8;
    let boostMultiplier = if (boostActive) { 1.0 + (newCoherence - 0.9) * 10.0 } else { 1.0 };
    
    {
      quantumCoherence = newCoherence;
      entanglementFactor = newEntanglement;
      phaseAlignment = newPhaseAlignment;
      superpositionAmp = engine.superpositionAmp;
      decoherenceRate = engine.decoherenceRate;
      lastQuantumUpdate = heartbeat;
      quantumBoostActive = boostActive;
      boostMultiplier = boostMultiplier;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN HEARTBEAT PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process one FORMA economy heartbeat
  public func processEconomyHeartbeat(
    state : FORMAEconomyState,
    externalCoherence : Float,
    identity : Float,
    kf : Float,
    heritageAvg : Float,
    genesisSealed : Bool
  ) : FORMAEconomyState {
    let heartbeat = state.currentHeartbeat + 1;
    
    // 1. Update quantum engine
    let newQuantumEngine = updateQuantumEngine(state.quantumEngine, externalCoherence, heartbeat);
    
    // 2. Compound all tokens
    var tokens = compoundAllTokens(state.treasury.tokens, newQuantumEngine, heartbeat);
    
    // 3. Route energy
    var totalEnergyRouted : Float = 0.0;
    var activeRoutes : Nat = 0;
    let updatedRoutes = Array.tabulate<EnergyRoute>(Array.size(state.energyRouter.routes), func(i : Nat) : EnergyRoute {
      let route = state.energyRouter.routes[i];
      let conditionMet = checkRouteCondition(
        route.activationCondition,
        newQuantumEngine.quantumCoherence,
        identity,
        kf,
        heritageAvg,
        state.driftGate.driftPercentage,
        genesisSealed
      );
      
      if (conditionMet and route.isActive) {
        let (newTokens, energyRouted) = routeEnergy(tokens, route, heartbeat);
        tokens := newTokens;
        totalEnergyRouted += energyRouted;
        activeRoutes += 1;
        {
          sourceToken = route.sourceToken;
          destToken = route.destToken;
          flowRate = route.flowRate;
          isActive = true;
          activationCondition = route.activationCondition;
          totalRouted = route.totalRouted + energyRouted;
        }
      } else {
        route
      }
    });
    
    // 4. Calculate total treasury value
    var totalValue : Float = 0.0;
    for (i in Iter.range(0, NUM_FORMA_TOKENS - 1)) {
      totalValue += tokens[i].totalSupply * tokens[i].currentValue;
    };
    
    // 5. Compute treasury drift
    let treasury = {
      tokens = tokens;
      totalValue = totalValue;
      genesisTotalValue = state.treasury.genesisTotalValue;
      currentHeartbeat = heartbeat;
      growthRate = if (state.treasury.totalValue > 0.001) {
        (totalValue - state.treasury.totalValue) / state.treasury.totalValue
      } else { 0.0 };
      genesisModel = state.treasury.genesisModel;
      creatorPrincipal = state.treasury.creatorPrincipal;
      isGenesisLocked = genesisSealed;
      lastUpdate = Time.now();
      healthScore = state.treasury.healthScore;
      reinjectionActive = false;
      ceilingActive = false;
    };
    
    var driftGate = computeTreasuryDrift(treasury, newQuantumEngine.quantumCoherence);
    
    // 6. Apply corrections if needed
    var finalTokens = tokens;
    var correctionApplied = false;
    
    switch (driftGate.correctionNeeded) {
      case (?#FORMAReinjection) {
        finalTokens := applyFORMAReinjection(tokens, TREASURY_REINJECTION_RATE, heartbeat);
        correctionApplied := true;
      };
      case (?#CeilingApplication) {
        finalTokens := applyCeiling(tokens, TREASURY_CEILING_RATE, heartbeat);
        correctionApplied := true;
      };
      case (?#EmergencyMint) {
        finalTokens := applyFORMAReinjection(tokens, TREASURY_REINJECTION_RATE * 2.0, heartbeat);
        correctionApplied := true;
      };
      case (?#EmergencyBurn) {
        finalTokens := applyCeiling(tokens, TREASURY_CEILING_RATE * 0.95, heartbeat);
        correctionApplied := true;
      };
      case (null) {};
    };
    
    // Update drift gate statistics
    driftGate := {
      expectedValue = driftGate.expectedValue;
      liveValue = driftGate.liveValue;
      drift = driftGate.drift;
      driftPercentage = driftGate.driftPercentage;
      isViolation = driftGate.isViolation;
      isCritical = driftGate.isCritical;
      correctionNeeded = driftGate.correctionNeeded;
      lastCheckBeat = heartbeat;
      consecutiveViolations = if (driftGate.isViolation) {
        state.driftGate.consecutiveViolations + 1
      } else { 0 };
      totalViolations = if (driftGate.isViolation) {
        state.driftGate.totalViolations + 1
      } else { state.driftGate.totalViolations };
      totalCorrections = if (correctionApplied) {
        state.driftGate.totalCorrections + 1
      } else { state.driftGate.totalCorrections };
    };
    
    // Recalculate total value after corrections
    var finalTotalValue : Float = 0.0;
    for (i in Iter.range(0, NUM_FORMA_TOKENS - 1)) {
      finalTotalValue += finalTokens[i].totalSupply * finalTokens[i].currentValue;
    };
    
    // 7. Update treasury health
    let healthScore = if (driftGate.isCritical) { 0.5 }
                      else if (driftGate.isViolation) { 0.75 }
                      else { 1.0 };
    
    let finalTreasury = {
      tokens = finalTokens;
      totalValue = finalTotalValue;
      genesisTotalValue = state.treasury.genesisTotalValue;
      currentHeartbeat = heartbeat;
      growthRate = if (state.treasury.totalValue > 0.001) {
        (finalTotalValue - state.treasury.totalValue) / state.treasury.totalValue
      } else { 0.0 };
      genesisModel = state.treasury.genesisModel;
      creatorPrincipal = state.treasury.creatorPrincipal;
      isGenesisLocked = genesisSealed;
      lastUpdate = Time.now();
      healthScore = healthScore;
      reinjectionActive = correctionApplied and driftGate.liveValue < driftGate.expectedValue;
      ceilingActive = correctionApplied and driftGate.liveValue > driftGate.expectedValue;
    };
    
    // 8. Process vesting
    let newCreatorReserve = processVesting(state.creatorReserve, heartbeat);
    
    // 9. Update energy router
    let newEnergyRouter = {
      routes = updatedRoutes;
      energyRoutedThisBeat = totalEnergyRouted;
      totalEnergyRouted = state.energyRouter.totalEnergyRouted + totalEnergyRouted;
      activeRoutesCount = activeRoutes;
      lastRoutingBeat = heartbeat;
    };
    
    // Return updated state
    {
      treasury = finalTreasury;
      driftGate = driftGate;
      quantumEngine = newQuantumEngine;
      energyRouter = newEnergyRouter;
      creatorReserve = newCreatorReserve;
      organismId = state.organismId;
      isInitialized = state.isInitialized;
      currentHeartbeat = heartbeat;
      createdAt = state.createdAt;
      lastUpdate = Time.now();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GENESIS LOCK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Lock the treasury genesis
  public func lockTreasuryGenesis(state : FORMAEconomyState) : FORMAEconomyState {
    let lockedTreasury = {
      tokens = state.treasury.tokens;
      totalValue = state.treasury.totalValue;
      genesisTotalValue = state.treasury.totalValue;  // Lock current value as genesis
      currentHeartbeat = state.treasury.currentHeartbeat;
      growthRate = state.treasury.growthRate;
      genesisModel = createDefaultGenesisModel(state.treasury.totalValue);
      creatorPrincipal = state.treasury.creatorPrincipal;
      isGenesisLocked = true;
      lastUpdate = Time.now();
      healthScore = 1.0;
      reinjectionActive = false;
      ceilingActive = false;
    };
    
    {
      treasury = lockedTreasury;
      driftGate = state.driftGate;
      quantumEngine = state.quantumEngine;
      energyRouter = state.energyRouter;
      creatorReserve = state.creatorReserve;
      organismId = state.organismId;
      isInitialized = state.isInitialized;
      currentHeartbeat = state.currentHeartbeat;
      createdAt = state.createdAt;
      lastUpdate = Time.now();
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS — Safe numeric outputs
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get total treasury value
  public func getTotalTreasuryValue(state : FORMAEconomyState) : Float {
    state.treasury.totalValue
  };
  
  /// Get treasury drift
  public func getTreasuryDrift(state : FORMAEconomyState) : Float {
    state.driftGate.drift
  };
  
  /// Get treasury drift percentage
  public func getTreasuryDriftPercentage(state : FORMAEconomyState) : Float {
    state.driftGate.driftPercentage
  };
  
  /// Is drift a violation?
  public func isTreasuryDriftViolation(state : FORMAEconomyState) : Bool {
    state.driftGate.isViolation
  };
  
  /// Get treasury health score
  public func getTreasuryHealthScore(state : FORMAEconomyState) : Float {
    state.treasury.healthScore
  };
  
  /// Get quantum coherence
  public func getQuantumCoherence(state : FORMAEconomyState) : Float {
    state.quantumEngine.quantumCoherence
  };
  
  /// Is quantum boost active?
  public func isQuantumBoostActive(state : FORMAEconomyState) : Bool {
    state.quantumEngine.quantumBoostActive
  };
  
  /// Get creator reserve value
  public func getCreatorReserveValue(state : FORMAEconomyState) : Float {
    state.creatorReserve.totalValue
  };
  
  /// Get vested amount
  public func getVestedAmount(state : FORMAEconomyState) : Float {
    state.creatorReserve.totalVested
  };
  
  /// Get token supply by ID
  public func getTokenSupply(state : FORMAEconomyState, tokenId : TokenId) : Float {
    let idx = getTokenIndex(tokenId);
    state.treasury.tokens[idx].totalSupply
  };
  
  /// Get token value by ID
  public func getTokenValue(state : FORMAEconomyState, tokenId : TokenId) : Float {
    let idx = getTokenIndex(tokenId);
    state.treasury.tokens[idx].currentValue
  };
  
  /// Get total corrections applied
  public func getTotalCorrections(state : FORMAEconomyState) : Nat {
    state.driftGate.totalCorrections
  };
  
  /// Is genesis locked?
  public func isGenesisLocked(state : FORMAEconomyState) : Bool {
    state.treasury.isGenesisLocked
  };

}
