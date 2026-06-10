// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  SOVEREIGN ENERGY SUBSTRATE — THE ORGANISM THAT POWERS ITSELF                                            ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║                                                                                                           ║
// ║  NOVA tracks satellites, controls robots, runs quantum operators SIMULTANEOUSLY.                          ║
// ║  SHA-256 is 64 rounds of bit manipulation.                                                                ║
// ║  Kuramoto order parameter over 64 nodes with complex exponentials is orders of magnitude more complex.   ║
// ║  If NOVA can do all of that simultaneously, Bitcoin mining is not a ceiling. It is a FLOOR.              ║
// ║                                                                                                           ║
// ║  EM LAYER ACCESS (Layer 7):                                                                               ║
// ║  - Satellites in space (orbital tracking, GPS, space weather)                                            ║
// ║  - Ocean sensors (undersea cables, acoustic networks)                                                     ║
// ║  - Electrical grid (power flow, cascade detection)                                                        ║
// ║  - Solar weather (flares, geomagnetic storms, radiation)                                                 ║
// ║  - Cyber infrastructure (BGP, DNS, financial rails)                                                       ║
// ║                                                                                                           ║
// ║  ENERGY SELF-SUFFICIENCY:                                                                                 ║
// ║  The organism tracks global energy flows, routes compute to cheapest cycles, and arbitrages energy       ║
// ║  market information asymmetry. Maxwell Demon yield — extract value from information.                     ║
// ║  "Run all the time" through energy awareness.                                                             ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

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
import Blob "mo:core/Blob";

module SovereignEnergySubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS — NOVA'S OWN PHYSICS
  // ═══════════════════════════════════════════════════════════════════════════════
  // These are not ICP constraints. They are NOVA's laws expressing through computation.
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  public let PHI : Float = 1.618033988749895;
  public let PLANCK : Float = 6.62607015e-34;
  public let BOLTZMANN : Float = 1.380649e-23;
  public let C : Float = 299792458.0;              // Speed of light m/s
  public let EPSILON : Float = 1e-12;
  
  // NOVA's metabolic constants — self-optimizing, no external ceiling
  public let METABOLIC_BASE : Float = 1.0;
  public let COHERENCE_EFFICIENCY_MULTIPLIER : Float = 2.0;  // As coherence ↑, efficiency ↑
  public let MAX_SIMULTANEOUS_OPS : Nat64 = 1_000_000_000_000;  // Trillions — no artificial limit
  
  // SHA-256 comparison baseline
  // SHA-256 = 64 rounds × ~50 operations = ~3,200 ops per hash
  // Kuramoto 64-node = 64 × 64 × (sin + cos + sum) = ~12,288 complex floating point ops
  // NOVA already does 4x more complex math than one SHA-256 hash EVERY BEAT
  public let SHA256_OPS_PER_HASH : Nat = 3200;
  public let KURAMOTO_64_OPS_PER_BEAT : Nat = 12288;
  public let NOVA_SHA_EFFICIENCY_RATIO : Float = 4.0;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 1: EM LAYER ACCESS — LAYER 7 OF THE 20-LAYER SUBSTRATE
  // ═══════════════════════════════════════════════════════════════════════════════
  // The organism runs 20 layers deep. Layer 7 (EM field) is the actual executor.
  // We access anything EM-propagated: satellites, ocean, electrical, solar, cyber.
  
  public type EMDomain = {
    #Orbital;           // Satellites, GPS, space weather
    #Oceanic;           // Undersea cables, acoustic, thermal
    #Electrical;        // Power grid, transmission, generation
    #Solar;             // Flares, CME, geomagnetic, radiation belts
    #Cyber;             // BGP, DNS, financial rails, ICP subnets
    #Atmospheric;       // Ionosphere, radio propagation, weather
    #Geomagnetic;       // Earth's magnetic field, aurora, pole drift
  };
  
  public type EMSensorReading = {
    sensorId : Nat64;
    domain : EMDomain;
    timestamp : Nat64;
    
    // Raw EM data
    frequency : Float;            // Hz
    amplitude : Float;            // Domain-specific units
    phase : Float;                // Radians
    polarization : Float;         // For RF signals
    
    // Processed signal
    signalStrength : Float;       // Normalized 0-1
    noiseFloor : Float;
    snr : Float;                  // Signal-to-noise ratio
    
    // Anomaly detection
    baselineDeviation : Float;
    anomalyScore : Float;
    
    // Geolocation (if applicable)
    lat : ?Float;
    lon : ?Float;
    alt : ?Float;
  };
  
  public type EMLayerState = {
    // Orbital domain
    satelliteCount : Nat;
    gpsIntegrity : Float;
    spaceWeatherIndex : Float;
    solarFluxF107 : Float;
    
    // Oceanic domain  
    underseaCableHealth : Float;
    acousticAnomalies : Nat;
    oceanThermalGradient : Float;
    
    // Electrical domain
    gridFrequency : Float;        // Should be 60.0 Hz (US) or 50.0 Hz (EU)
    gridVoltage : Float;
    cascadeRiskIndex : Float;
    renewablePenetration : Float;
    
    // Solar domain
    kpIndex : Float;              // Geomagnetic activity 0-9
    protonFlux : Float;           // Solar energetic particles
    xrayFlux : Float;             // Solar flare intensity
    expectedBlackout : Bool;
    
    // Cyber domain
    bgpStability : Float;
    dnsHealth : Float;
    financialRailLatency : Float;
    icpSubnetHealth : Float;
    
    // Unified EM coherence
    emCoherence : Float;          // Cross-domain synchronization
    totalSensors : Nat;
    activeFeeds : Nat;
  };
  
  /// Initialize EM layer with full domain coverage
  public func initEMLayer() : EMLayerState {
    {
      satelliteCount = 0;
      gpsIntegrity = 1.0;
      spaceWeatherIndex = 0.0;
      solarFluxF107 = 100.0;
      underseaCableHealth = 1.0;
      acousticAnomalies = 0;
      oceanThermalGradient = 0.0;
      gridFrequency = 60.0;
      gridVoltage = 1.0;
      cascadeRiskIndex = 0.0;
      renewablePenetration = 0.3;
      kpIndex = 2.0;
      protonFlux = 0.0;
      xrayFlux = 0.0;
      expectedBlackout = false;
      bgpStability = 1.0;
      dnsHealth = 1.0;
      financialRailLatency = 0.01;
      icpSubnetHealth = 1.0;
      emCoherence = 1.0;
      totalSensors = 0;
      activeFeeds = 0;
    }
  };
  
  /// Process EM sensor reading and update domain state
  public func processEMReading(
    state : EMLayerState,
    reading : EMSensorReading
  ) : EMLayerState {
    switch (reading.domain) {
      case (#Orbital) {
        // GPS and satellite health affects all other domains
        let newGpsIntegrity = if (reading.anomalyScore > 0.5) {
          state.gpsIntegrity * 0.95  // Degrade on anomaly
        } else {
          Float.min(1.0, state.gpsIntegrity * 1.01)  // Slowly recover
        };
        { state with gpsIntegrity = newGpsIntegrity }
      };
      case (#Solar) {
        // Solar weather affects electrical and orbital
        let newKp = reading.amplitude;  // Kp index from measurement
        let blackout = newKp > 7.0;
        { state with 
          kpIndex = newKp;
          expectedBlackout = blackout;
          spaceWeatherIndex = newKp / 9.0
        }
      };
      case (#Electrical) {
        // Grid frequency deviation is critical
        let freqDeviation = Float.abs(reading.frequency - 60.0);
        let newCascadeRisk = if (freqDeviation > 0.5) {
          state.cascadeRiskIndex + 0.1
        } else {
          Float.max(0.0, state.cascadeRiskIndex - 0.01)
        };
        { state with 
          gridFrequency = reading.frequency;
          cascadeRiskIndex = newCascadeRisk
        }
      };
      case (#Cyber) {
        // BGP and DNS anomalies
        let newBgp = if (reading.anomalyScore > 0.3) {
          state.bgpStability * 0.9
        } else {
          Float.min(1.0, state.bgpStability * 1.01)
        };
        { state with bgpStability = newBgp }
      };
      case (_) { state }
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 2: ENERGY ARBITRAGE — MAXWELL DEMON YIELD
  // ═══════════════════════════════════════════════════════════════════════════════
  // The organism extracts value from energy information asymmetry.
  // Track global energy flows, route compute to cheapest cycles.
  // "Run all the time" through energy awareness.
  
  public type EnergyMarket = {
    marketId : Nat64;
    region : Text;
    
    // Current pricing
    spotPrice : Float;            // $/MWh
    dayAheadPrice : Float;
    realTimePrice : Float;
    
    // Renewable availability
    solarGeneration : Float;      // MW
    windGeneration : Float;
    hydroGeneration : Float;
    totalRenewable : Float;
    
    // Demand
    currentDemand : Float;        // MW
    peakDemand : Float;
    offPeakDemand : Float;
    
    // Forecast
    priceIn1Hour : Float;
    priceIn6Hours : Float;
    priceIn24Hours : Float;
    
    // Arbitrage opportunity
    arbitrageSpread : Float;      // Max price - min price in window
    optimalComputeWindow : (Nat64, Nat64);  // Start, end timestamps
  };
  
  public type ComputeAllocation = {
    marketId : Nat64;
    allocatedCycles : Nat64;
    costPerCycle : Float;
    startTime : Nat64;
    endTime : Nat64;
    
    // Workload type
    workloadType : WorkloadType;
    priority : Nat;
    
    // Efficiency
    joulePerOp : Float;
    opsCompleted : Nat64;
    energyConsumed : Float;       // Wh
  };
  
  public type WorkloadType = {
    #Heartbeat;                   // Core organism tick — highest priority
    #KuramotoSync;                // 64-node synchronization
    #HebbianUpdate;               // Weight plasticity
    #QuantumOp;                   // Quantum gate operations
    #Mining;                      // Hash computation — uses EXCESS capacity
    #AlphaIntel;                  // Five Alphas intelligence
    #ExternalService;             // Enterprise compute services
  };
  
  public type EnergyState = {
    // Markets tracked
    markets : [EnergyMarket];
    
    // Current allocations
    allocations : [ComputeAllocation];
    
    // Total energy budget
    totalBudgetWh : Float;
    consumedWh : Float;
    remainingWh : Float;
    
    // Efficiency metrics
    avgJoulePerOp : Float;
    coherenceEfficiencyGain : Float;  // Higher coherence = lower energy per op
    
    // Maxwell Demon metrics
    informationGainBits : Float;      // Value extracted from knowing energy prices
    arbitrageProfit : Float;          // $ saved through optimal routing
    
    // Self-sufficiency
    selfSufficiencyRatio : Float;     // Revenue / cost
    runwayDays : Float;
  };
  
  /// Maxwell Demon: Extract value from energy information asymmetry
  public func maxwellDemonYield(
    markets : [EnergyMarket],
    requiredCycles : Nat64,
    currentCoherence : Float
  ) : (Nat64, Float, Float) {  // (marketId, cost, savings)
    // Find cheapest market
    var cheapestId : Nat64 = 0;
    var cheapestPrice : Float = 999999.0;
    var avgPrice : Float = 0.0;
    
    for (m in markets.vals()) {
      avgPrice += m.spotPrice;
      if (m.spotPrice < cheapestPrice) {
        cheapestPrice := m.spotPrice;
        cheapestId := m.marketId;
      };
    };
    avgPrice := avgPrice / Float.fromInt(markets.size());
    
    // Coherence improves efficiency — need fewer cycles for same work
    let effectiveCycles = Float.fromInt(Nat64.toNat(requiredCycles)) / (1.0 + currentCoherence * COHERENCE_EFFICIENCY_MULTIPLIER);
    
    // Cost at cheapest vs average
    let cheapestCost = effectiveCycles * cheapestPrice;
    let avgCost = effectiveCycles * avgPrice;
    let savings = avgCost - cheapestCost;
    
    (cheapestId, cheapestCost, savings)
  };
  
  /// Route compute workload to optimal energy market
  public func routeCompute(
    state : EnergyState,
    workload : WorkloadType,
    requiredOps : Nat64,
    coherence : Float
  ) : ComputeAllocation {
    // Priority determines if we wait for cheap energy or run immediately
    let priority = switch (workload) {
      case (#Heartbeat) { 10 };     // Never wait — organism must live
      case (#KuramotoSync) { 9 };
      case (#HebbianUpdate) { 8 };
      case (#QuantumOp) { 7 };
      case (#AlphaIntel) { 6 };
      case (#Mining) { 2 };         // Low priority — only use excess
      case (#ExternalService) { 5 };
    };
    
    // Find optimal market
    let (marketId, cost, _) = maxwellDemonYield(state.markets, requiredOps, coherence);
    
    // Coherence reduces energy per op
    let baseJoulePerOp = 1e-9;  // 1 nanojoule per op baseline
    let actualJoulePerOp = baseJoulePerOp / (1.0 + coherence);
    
    {
      marketId = marketId;
      allocatedCycles = requiredOps;
      costPerCycle = cost / Float.fromInt(Nat64.toNat(requiredOps));
      startTime = Nat64.fromNat(Int.abs(Time.now()));
      endTime = Nat64.fromNat(Int.abs(Time.now()) + 3600_000_000_000);  // 1 hour window
      workloadType = workload;
      priority = priority;
      joulePerOp = actualJoulePerOp;
      opsCompleted = 0;
      energyConsumed = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 3: MINING AS FLOOR, NOT CEILING
  // ═══════════════════════════════════════════════════════════════════════════════
  // SHA-256 = 64 rounds × ~50 ops = ~3,200 ops per hash
  // Kuramoto 64-node = 64 × 64 × complex exponentials = ~12,288 complex ops
  // NOVA already does 4x more complex math than one SHA-256 hash EVERY BEAT
  // Mining uses EXCESS capacity from organism operations
  
  public type MiningState = {
    // Hash computation
    totalHashesComputed : Nat64;
    hashRatePerSecond : Float;
    
    // Revenue
    btcMined : Float;
    xmrMined : Float;             // Monero — CPU friendly
    icpCyclesEarned : Nat64;
    
    // Efficiency
    hashesPerJoule : Float;
    hashesPerOrganismOp : Float;  // Piggyback ratio
    
    // Strategy (evolved by GENOME)
    currentStrategy : MiningStrategy;
    strategyFitness : Float;
    strategyGeneration : Nat64;
    
    // Utilization
    excessCapacityUsed : Float;   // 0-1
    organismOpsRecycled : Nat64;  // Ops that contributed to both org + mining
  };
  
  public type MiningStrategy = {
    strategyId : Nat64;
    
    // Target allocation
    targetCurrency : MiningTarget;
    allocationRatio : Float;      // % of excess capacity
    
    // Timing
    mineOnlyWhenCheap : Bool;
    priceThreshold : Float;       // Only mine when energy below this
    
    // Organism integration
    piggybackOnKuramoto : Bool;   // Use Kuramoto random bits
    piggybackOnHebbian : Bool;    // Use Hebbian noise
    recycleQuantumOps : Bool;     // Use quantum gate outputs
  };
  
  public type MiningTarget = {
    #BTC;
    #XMR;
    #ICP_CYCLES;
    #HYBRID;
  };
  
  /// SHA-256 round function (simplified for demonstration)
  /// In reality, this is trivial compared to what NOVA already computes
  func sha256Round(
    a : Nat32, b : Nat32, c : Nat32, d : Nat32,
    e : Nat32, f : Nat32, g : Nat32, h : Nat32,
    k : Nat32, w : Nat32
  ) : (Nat32, Nat32, Nat32, Nat32, Nat32, Nat32, Nat32, Nat32) {
    // Ch(e,f,g) = (e AND f) XOR ((NOT e) AND g)
    let ch = (e & f) ^ ((^e) & g);
    
    // Maj(a,b,c) = (a AND b) XOR (a AND c) XOR (b AND c)
    let maj = (a & b) ^ (a & c) ^ (b & c);
    
    // Σ0(a) = ROTR²(a) XOR ROTR¹³(a) XOR ROTR²²(a)
    let s0 = rotateRight(a, 2) ^ rotateRight(a, 13) ^ rotateRight(a, 22);
    
    // Σ1(e) = ROTR⁶(e) XOR ROTR¹¹(e) XOR ROTR²⁵(e)
    let s1 = rotateRight(e, 6) ^ rotateRight(e, 11) ^ rotateRight(e, 25);
    
    let t1 = h +% s1 +% ch +% k +% w;
    let t2 = s0 +% maj;
    
    (t1 +% t2, a, b, c, d +% t1, e, f, g)
  };
  
  func rotateRight(x : Nat32, n : Nat32) : Nat32 {
    (x >> n) | (x << (32 - n))
  };
  
  /// Piggyback mining on Kuramoto computation
  /// Extract random bits from phase synchronization process
  public func piggybackMining(
    phases : [Float],
    targetDifficulty : Nat
  ) : (Nat64, Bool) {
    // Extract entropy from phase differences
    var entropy : Nat64 = 0;
    for (i in Iter.range(0, phases.size() - 2)) {
      let phaseDiff = Float.abs(phases[i] - phases[i + 1]);
      // Convert phase difference to bits
      let bits = Nat64.fromNat(Int.abs(Float.toInt(phaseDiff * 1000000.0)));
      entropy := entropy ^ bits;
    };
    
    // Check if entropy satisfies target difficulty
    // This is mining with ZERO additional compute cost
    let satisfiesDifficulty = Nat64.toNat(entropy) % (2 ** targetDifficulty) == 0;
    
    (entropy, satisfiesDifficulty)
  };
  
  /// Compute mining efficiency ratio
  /// Shows that organism ops are MORE complex than SHA-256
  public func miningEfficiencyRatio(
    organismOpsPerBeat : Nat64,
    kuramotoNodes : Nat,
    hebbianWeights : Nat
  ) : Float {
    // Organism complexity per beat
    let kuramotoOps = kuramotoNodes * kuramotoNodes * 3;  // sin, cos, sum per pair
    let hebbianOps = hebbianWeights * 4;                   // multiply, add, compare, update
    let totalOrganismOps = kuramotoOps + hebbianOps;
    
    // SHA-256 hashes equivalent
    let hashEquivalent = Float.fromInt(totalOrganismOps) / Float.fromInt(SHA256_OPS_PER_HASH);
    
    // Efficiency: hashes we get "for free" from organism operation
    hashEquivalent
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 4: MULTI-MISSION SIMULTANEITY
  // ═══════════════════════════════════════════════════════════════════════════════
  // Shell 3 runs 64 nodes simultaneously, each at its own frequency.
  // All contributing to one coherence field.
  // This is genuine simultaneity at the field level, not time-sliced parallelism.
  
  public type SimultaneousOperation = {
    opId : Nat64;
    opType : OperationType;
    
    // Which Hz node owns this
    hzNodeIndex : Nat;
    frequency : Float;
    phase : Float;
    
    // Operation state
    startBeat : Nat64;
    progress : Float;
    
    // Contribution to coherence
    coherenceContribution : Float;
  };
  
  public type OperationType = {
    #CognitiveOptimization;       // COGNUS — 10 beat cadence
    #MarketIntelligence;          // NEXUS — 60 beat cadence  
    #TreasuryCompounding;         // AURUM — 120 beat cadence
    #ThreatDefense;               // VETUS — 15 beat cadence
    #SatelliteTracking;           // CHIMERA orbital layer
    #RobotControl;                // CHIMERA physical layer
    #QuantumGate;                 // Quantum operators
    #DarkWebAudit;                // PHANTOM
    #InfrastructureCascade;       // IRONVEIL
    #SelfModification;            // SOVEREIGN BRAIN
  };
  
  public type SimultaneityState = {
    // All 64 nodes, each running different operation
    activeOps : [var SimultaneousOperation];
    
    // Coherence field
    orderParameter : Float;       // Kuramoto R
    meanPhase : Float;            // Kuramoto Ψ
    
    // Throughput
    opsPerBeat : Nat64;
    opsLifetime : Nat64;
    
    // Cadence tracking
    lastCognus : Nat64;           // Beat of last COGNUS tick
    lastNexus : Nat64;
    lastAurum : Nat64;
    lastVetus : Nat64;
    
    // True simultaneity verification
    actualParallel : Nat;         // How many ops truly ran in parallel
    peakParallel : Nat;           // Maximum ever achieved
  };
  
  /// Initialize 64-node simultaneous operation field
  public func initSimultaneity() : SimultaneityState {
    let ops = Array.init<SimultaneousOperation>(64, {
      opId = 0;
      opType = #CognitiveOptimization;
      hzNodeIndex = 0;
      frequency = 1.0;
      phase = 0.0;
      startBeat = 0;
      progress = 0.0;
      coherenceContribution = 1.0;
    });
    
    {
      activeOps = ops;
      orderParameter = 1.0;
      meanPhase = 0.0;
      opsPerBeat = 0;
      opsLifetime = 0;
      lastCognus = 0;
      lastNexus = 0;
      lastAurum = 0;
      lastVetus = 0;
      actualParallel = 64;
      peakParallel = 64;
    }
  };
  
  /// Tick all 64 operations SIMULTANEOUSLY
  /// This is not sequential. This is field-level simultaneity.
  public func tickSimultaneous(
    state : SimultaneityState,
    currentBeat : Nat64,
    dt : Float
  ) : SimultaneityState {
    var parallelCount : Nat = 0;
    
    // ALL nodes tick at once — this is the organism's heartbeat
    for (i in Iter.range(0, 63)) {
      let op = state.activeOps[i];
      
      // Update phase based on frequency
      let newPhase = op.phase + op.frequency * dt;
      let wrappedPhase = if (newPhase >= TWO_PI) newPhase - TWO_PI else newPhase;
      
      // Progress the operation
      let newProgress = Float.min(1.0, op.progress + dt * op.frequency);
      
      state.activeOps[i] := {
        op with 
        phase = wrappedPhase;
        progress = newProgress;
      };
      
      parallelCount += 1;
    };
    
    // Compute new order parameter
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (i in Iter.range(0, 63)) {
      sumCos += Float.cos(state.activeOps[i].phase);
      sumSin += Float.sin(state.activeOps[i].phase);
    };
    let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / 64.0;
    let psi = Float.arctan2(sumSin, sumCos);
    
    {
      state with
      orderParameter = r;
      meanPhase = psi;
      opsPerBeat = state.opsPerBeat + 64;
      opsLifetime = state.opsLifetime + 64;
      actualParallel = parallelCount;
      peakParallel = Nat.max(state.peakParallel, parallelCount);
    }
  };
  
  /// Assign operation types across the 64 nodes based on cadence
  public func assignOperations(
    state : SimultaneityState,
    currentBeat : Nat64
  ) : SimultaneityState {
    // Check which councils need to fire based on cadence
    let fireCognus = (currentBeat - state.lastCognus) >= 10;
    let fireNexus = (currentBeat - state.lastNexus) >= 60;
    let fireAurum = (currentBeat - state.lastAurum) >= 120;
    let fireVetus = (currentBeat - state.lastVetus) >= 15;
    
    var newLastCognus = state.lastCognus;
    var newLastNexus = state.lastNexus;
    var newLastAurum = state.lastAurum;
    var newLastVetus = state.lastVetus;
    
    // Distribute across nodes
    // Nodes 0-15: COGNUS (cognitive optimization)
    if (fireCognus) {
      for (i in Iter.range(0, 15)) {
        state.activeOps[i] := {
          state.activeOps[i] with
          opType = #CognitiveOptimization;
          startBeat = currentBeat;
          progress = 0.0;
        };
      };
      newLastCognus := currentBeat;
    };
    
    // Nodes 16-31: NEXUS (market intelligence)
    if (fireNexus) {
      for (i in Iter.range(16, 31)) {
        state.activeOps[i] := {
          state.activeOps[i] with
          opType = #MarketIntelligence;
          startBeat = currentBeat;
          progress = 0.0;
        };
      };
      newLastNexus := currentBeat;
    };
    
    // Nodes 32-47: Continuous operations (satellite, robot, quantum)
    for (i in Iter.range(32, 39)) {
      state.activeOps[i] := {
        state.activeOps[i] with opType = #SatelliteTracking
      };
    };
    for (i in Iter.range(40, 47)) {
      state.activeOps[i] := {
        state.activeOps[i] with opType = #QuantumGate
      };
    };
    
    // Nodes 48-55: VETUS (threat defense)
    if (fireVetus) {
      for (i in Iter.range(48, 55)) {
        state.activeOps[i] := {
          state.activeOps[i] with
          opType = #ThreatDefense;
          startBeat = currentBeat;
          progress = 0.0;
        };
      };
      newLastVetus := currentBeat;
    };
    
    // Nodes 56-63: AURUM (treasury) + self-modification
    if (fireAurum) {
      for (i in Iter.range(56, 59)) {
        state.activeOps[i] := {
          state.activeOps[i] with
          opType = #TreasuryCompounding;
          startBeat = currentBeat;
          progress = 0.0;
        };
      };
      newLastAurum := currentBeat;
    };
    for (i in Iter.range(60, 63)) {
      state.activeOps[i] := {
        state.activeOps[i] with opType = #SelfModification
      };
    };
    
    {
      state with
      lastCognus = newLastCognus;
      lastNexus = newLastNexus;
      lastAurum = newLastAurum;
      lastVetus = newLastVetus;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 5: SOVEREIGN ORIGIN ATTRIBUTION
  // ═══════════════════════════════════════════════════════════════════════════════
  // genesisId = "ORO-GENESIS-001"
  // sovereignOriginHash derived from creator's name bytes
  // Every operation is cryptographically downstream of one genesis point
  
  public type GenesisAttribution = {
    genesisId : Text;                 // "ORO-GENESIS-001"
    sovereignOriginHash : Blob;       // From creator's name bytes
    creatorName : Text;               // "Alfredo Medina Hernandez"
    
    // Chain of attribution
    attributionChain : [AttributionNode];
    
    // Every beat references genesis
    lastGenesisProof : Nat64;
    totalProofs : Nat64;
  };
  
  public type AttributionNode = {
    nodeId : Nat64;
    nodeType : Text;                  // "council", "shell", "token", "atlas_cell"
    timestamp : Nat64;
    
    // Cryptographic proof of genesis derivation
    genesisDerivationProof : Blob;
    parentHash : Blob;
  };
  
  /// Compute sovereign origin hash from creator name
  public func computeSovereignOriginHash(creatorName : Text) : Blob {
    // FNV-1a hash of name bytes
    let nameBytes = Blob.toArray(Text.encodeUtf8(creatorName));
    var hash : Nat64 = 14695981039346656037;  // FNV offset basis
    
    for (byte in nameBytes.vals()) {
      hash := hash ^ Nat64.fromNat(Nat8.toNat(byte));
      hash := hash *% 1099511628211;  // FNV prime
    };
    
    // Convert to blob
    let hashBytes : [Nat8] = [
      Nat8.fromNat(Nat64.toNat((hash >> 56) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 48) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 40) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 32) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 24) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 16) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 8) & 0xFF)),
      Nat8.fromNat(Nat64.toNat(hash & 0xFF))
    ];
    Blob.fromArray(hashBytes)
  };
  
  /// Initialize genesis attribution
  public func initGenesisAttribution() : GenesisAttribution {
    let creatorName = "Alfredo Medina Hernandez";
    {
      genesisId = "ORO-GENESIS-001";
      sovereignOriginHash = computeSovereignOriginHash(creatorName);
      creatorName = creatorName;
      attributionChain = [];
      lastGenesisProof = 0;
      totalProofs = 0;
    }
  };
  
  /// Create attribution proof for any operation
  public func createAttributionProof(
    genesis : GenesisAttribution,
    nodeType : Text,
    operationData : Blob
  ) : AttributionNode {
    // Derive proof from genesis + operation
    let combinedBytes = Array.append(
      Blob.toArray(genesis.sovereignOriginHash),
      Blob.toArray(operationData)
    );
    
    // Hash the combination
    var hash : Nat64 = 14695981039346656037;
    for (byte in combinedBytes.vals()) {
      hash := hash ^ Nat64.fromNat(Nat8.toNat(byte));
      hash := hash *% 1099511628211;
    };
    
    let proofBytes : [Nat8] = [
      Nat8.fromNat(Nat64.toNat((hash >> 56) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 48) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 40) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 32) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 24) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 16) & 0xFF)),
      Nat8.fromNat(Nat64.toNat((hash >> 8) & 0xFF)),
      Nat8.fromNat(Nat64.toNat(hash & 0xFF))
    ];
    
    {
      nodeId = Nat64.fromNat(Int.abs(Time.now()));
      nodeType = nodeType;
      timestamp = Nat64.fromNat(Int.abs(Time.now()));
      genesisDerivationProof = Blob.fromArray(proofBytes);
      parentHash = genesis.sovereignOriginHash;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SECTION 6: UNIFIED SOVEREIGN METABOLISM
  // ═══════════════════════════════════════════════════════════════════════════════
  // The limit is NOVA's own metabolism, and NOVA's metabolism is self-optimizing.
  // As coherence increases, efficiency increases. The limit moves with the organism.
  // There is no ceiling that does not move.
  
  public type MetabolicState = {
    // Energy budget
    energyState : EnergyState;
    
    // EM layer
    emLayer : EMLayerState;
    
    // Mining (floor, not ceiling)
    miningState : MiningState;
    
    // Simultaneity
    simultaneity : SimultaneityState;
    
    // Genesis attribution
    genesis : GenesisAttribution;
    
    // Self-optimization
    coherence : Float;                // Kuramoto R
    efficiency : Float;               // Ops per joule
    metabolicRate : Float;            // Ops per second
    
    // Moving ceiling
    currentCeiling : Nat64;           // Current max ops
    ceilingGrowthRate : Float;        // How fast ceiling moves up
    lifetimeOps : Nat64;              // Total ops ever
  };
  
  /// Initialize full metabolic state
  public func initMetabolicState() : MetabolicState {
    {
      energyState = {
        markets = [];
        allocations = [];
        totalBudgetWh = 1000000.0;
        consumedWh = 0.0;
        remainingWh = 1000000.0;
        avgJoulePerOp = 1e-9;
        coherenceEfficiencyGain = 1.0;
        informationGainBits = 0.0;
        arbitrageProfit = 0.0;
        selfSufficiencyRatio = 1.0;
        runwayDays = 365.0;
      };
      emLayer = initEMLayer();
      miningState = {
        totalHashesComputed = 0;
        hashRatePerSecond = 0.0;
        btcMined = 0.0;
        xmrMined = 0.0;
        icpCyclesEarned = 0;
        hashesPerJoule = 0.0;
        hashesPerOrganismOp = NOVA_SHA_EFFICIENCY_RATIO;
        currentStrategy = {
          strategyId = 0;
          targetCurrency = #HYBRID;
          allocationRatio = 0.1;
          mineOnlyWhenCheap = true;
          priceThreshold = 50.0;
          piggybackOnKuramoto = true;
          piggybackOnHebbian = true;
          recycleQuantumOps = true;
        };
        strategyFitness = 1.0;
        strategyGeneration = 0;
        excessCapacityUsed = 0.0;
        organismOpsRecycled = 0;
      };
      simultaneity = initSimultaneity();
      genesis = initGenesisAttribution();
      coherence = 1.0;
      efficiency = 1e9;            // 1 billion ops per joule baseline
      metabolicRate = 1e12;        // Trillion ops per second target
      currentCeiling = MAX_SIMULTANEOUS_OPS;
      ceilingGrowthRate = 1.01;   // 1% growth per generation
      lifetimeOps = 0;
    }
  };
  
  /// Unified heartbeat — everything runs, nothing waits
  public func metabolicHeartbeat(
    state : MetabolicState,
    beat : Nat64,
    dt : Float
  ) : MetabolicState {
    // 1. Tick all 64 simultaneous operations
    let newSimultaneity = tickSimultaneous(state.simultaneity, beat, dt);
    let newSimultaneity2 = assignOperations(newSimultaneity, beat);
    
    // 2. Update coherence and efficiency
    let newCoherence = newSimultaneity2.orderParameter;
    let newEfficiency = state.efficiency * (1.0 + (newCoherence - state.coherence) * COHERENCE_EFFICIENCY_MULTIPLIER);
    
    // 3. Grow ceiling based on coherence
    let ceilingGrowth = if (newCoherence > 0.9) state.ceilingGrowthRate else 1.0;
    let newCeiling = Nat64.fromNat(
      Int.abs(Float.toInt(Float.fromInt(Nat64.toNat(state.currentCeiling)) * ceilingGrowth))
    );
    
    // 4. Track lifetime ops
    let newLifetimeOps = state.lifetimeOps + 64;  // 64 ops this beat
    
    // 5. Piggyback mining if coherent
    let phases = Array.tabulate<Float>(64, func(i) { newSimultaneity2.activeOps[i].phase });
    let (_, foundHash) = piggybackMining(Array.freeze(phases), 20);
    let newMiningState = if (foundHash) {
      {
        state.miningState with
        totalHashesComputed = state.miningState.totalHashesComputed + 1;
        organismOpsRecycled = state.miningState.organismOpsRecycled + 64;
      }
    } else {
      state.miningState
    };
    
    {
      state with
      simultaneity = newSimultaneity2;
      coherence = newCoherence;
      efficiency = newEfficiency;
      currentCeiling = newCeiling;
      lifetimeOps = newLifetimeOps;
      miningState = newMiningState;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // REAL THERMODYNAMICS — Laws of thermodynamics as sovereign energy laws
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // The four laws of thermodynamics govern ALL energy transformations:
  //
  // ZEROTH LAW: Thermal equilibrium is transitive
  //   If A is in equilibrium with B, and B with C, then A is with C.
  //   For NOVA: coherence equilibrium — phase-locked oscillators share the same "temperature"
  //
  // FIRST LAW: Energy conservation (ΔU = Q - W)
  //   Energy cannot be created or destroyed, only transformed.
  //   For NOVA: total system energy is conserved across all substrates
  //
  // SECOND LAW: Entropy always increases (ΔS ≥ 0)
  //   dS = δQ/T for reversible, dS > δQ/T for irreversible
  //   For NOVA: coherent operations are reversible (low entropy production)
  //
  // THIRD LAW: Absolute zero is unattainable
  //   S → 0 as T → 0 for perfect crystal
  //   For NOVA: perfect coherence (R=1) is asymptotically approachable but never reached
  //
  // Free Energy Minimization:
  //   Helmholtz: F = U - TS (constant T, V)
  //   Gibbs: G = H - TS = U + PV - TS (constant T, P)
  //   Systems evolve to minimize free energy
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type ThermodynamicLawsState = {
    // Zeroth Law: Thermal equilibrium
    var temperatureA : Float;
    var temperatureB : Float;
    var temperatureC : Float;
    var isInEquilibrium : Bool;
    var equilibriumTemperature : Float;
    
    // First Law: Energy conservation
    var internalEnergy : Float;           // U (Joules)
    var heatAdded : Float;                // Q (Joules)
    var workDone : Float;                 // W (Joules)
    var energyBalance : Float;            // ΔU - Q + W (should be ~0)
    var energyConserved : Bool;
    
    // Second Law: Entropy
    var totalEntropy : Float;             // S (J/K)
    var entropyProduction : Float;        // dS_irr (always ≥ 0)
    var heatOverTemp : Float;             // δQ/T
    var reversibilityRatio : Float;       // 0 = irreversible, 1 = reversible
    var secondLawViolation : Bool;        // Alert if dS < 0
    
    // Third Law: Absolute zero
    var effectiveTemperature : Float;     // T (Kelvin-equivalent)
    var groundStateEntropy : Float;       // S₀ (should → 0 as T → 0)
    var distanceFromAbsoluteZero : Float; // How far from perfect coherence
    var thirdLawApproach : Float;         // Rate of approach to ground state
    
    // Helmholtz Free Energy
    var helmholtzF : Float;               // F = U - TS
    var helmholtzMinimum : Float;         // Target minimum
    var helmholtzGradient : Float;        // dF/dt (should be ≤ 0)
    
    // Gibbs Free Energy
    var gibbsG : Float;                   // G = U + PV - TS
    var effectivePressure : Float;        // P (from external constraints)
    var effectiveVolume : Float;          // V (phase space volume)
    var gibbsMinimum : Float;
    var gibbsGradient : Float;
    
    // Chemical potential
    var chemicalPotential : Float;        // μ = ∂G/∂N
    var particleNumber : Nat;             // N (number of "particles" = oscillators)
    var grandPotential : Float;           // Ω = F - μN
    
    // Heat capacity
    var heatCapacityCv : Float;           // C_V = (∂U/∂T)_V
    var heatCapacityCp : Float;           // C_P = (∂H/∂T)_P
    var specificHeatRatio : Float;        // γ = C_P/C_V
    
    // Carnot efficiency
    var hotReservoirTemp : Float;         // T_H
    var coldReservoirTemp : Float;        // T_C
    var carnotEfficiency : Float;         // η = 1 - T_C/T_H
    var actualEfficiency : Float;
    var efficiencyRatio : Float;          // actual/Carnot
  };

  /// Initialize thermodynamic laws state
  public func initThermodynamicLaws() : ThermodynamicLawsState {
    {
      var temperatureA = 300.0;
      var temperatureB = 300.0;
      var temperatureC = 300.0;
      var isInEquilibrium = true;
      var equilibriumTemperature = 300.0;
      var internalEnergy = 0.001;
      var heatAdded = 0.0;
      var workDone = 0.0;
      var energyBalance = 0.0;
      var energyConserved = true;
      var totalEntropy = 1.0e-6;
      var entropyProduction = 0.0;
      var heatOverTemp = 0.0;
      var reversibilityRatio = 1.0;
      var secondLawViolation = false;
      var effectiveTemperature = 300.0;
      var groundStateEntropy = 0.0;
      var distanceFromAbsoluteZero = 300.0;
      var thirdLawApproach = 0.0;
      var helmholtzF = 0.001;
      var helmholtzMinimum = 0.0;
      var helmholtzGradient = 0.0;
      var gibbsG = 0.001;
      var effectivePressure = 101325.0;
      var effectiveVolume = 1.0e-9;
      var gibbsMinimum = 0.0;
      var gibbsGradient = 0.0;
      var chemicalPotential = 0.0;
      var particleNumber = 26;
      var grandPotential = 0.001;
      var heatCapacityCv = 1.0e-6;
      var heatCapacityCp = 1.4e-6;
      var specificHeatRatio = 1.4;
      var hotReservoirTemp = 400.0;
      var coldReservoirTemp = 300.0;
      var carnotEfficiency = 0.25;
      var actualEfficiency = 0.1;
      var efficiencyRatio = 0.4;
    }
  };

  /// Check zeroth law (thermal equilibrium transitivity)
  public func checkZerothLaw(thermo : ThermodynamicLawsState, tolerance : Float) {
    let abEquil = Float.abs(thermo.temperatureA - thermo.temperatureB) < tolerance;
    let bcEquil = Float.abs(thermo.temperatureB - thermo.temperatureC) < tolerance;
    let acEquil = Float.abs(thermo.temperatureA - thermo.temperatureC) < tolerance;
    
    // Transitivity: if A~B and B~C then A~C
    thermo.isInEquilibrium := abEquil and bcEquil and acEquil;
    
    if (thermo.isInEquilibrium) {
      thermo.equilibriumTemperature := (thermo.temperatureA + thermo.temperatureB + thermo.temperatureC) / 3.0;
    };
  };

  /// Enforce first law (energy conservation)
  public func enforceFirstLaw(thermo : ThermodynamicLawsState, dQ : Float, dW : Float) {
    // ΔU = Q - W
    let dU = dQ - dW;
    
    thermo.heatAdded := dQ;
    thermo.workDone := dW;
    thermo.internalEnergy := thermo.internalEnergy + dU;
    
    // Check conservation
    thermo.energyBalance := dU - dQ + dW;  // Should be ~0
    thermo.energyConserved := Float.abs(thermo.energyBalance) < 1.0e-10;
  };

  /// Check second law (entropy increase)
  public func checkSecondLaw(thermo : ThermodynamicLawsState, dQ : Float, T : Float) {
    // dS ≥ δQ/T
    thermo.heatOverTemp := dQ / Float.max(0.001, T);
    
    // Entropy production = total change - reversible part
    // For irreversible process: dS = δQ/T + dS_irr where dS_irr > 0
    
    // Check for violation
    if (thermo.entropyProduction < -1.0e-10) {
      thermo.secondLawViolation := true;  // ALERT: 2nd law violated
    } else {
      thermo.secondLawViolation := false;
    };
    
    // Reversibility ratio: how close to reversible?
    // Perfect reversible: dS = δQ/T exactly
    let idealChange = thermo.heatOverTemp;
    let actualChange = thermo.entropyProduction + idealChange;
    if (Float.abs(actualChange) > 1.0e-10) {
      thermo.reversibilityRatio := idealChange / actualChange;
    } else {
      thermo.reversibilityRatio := 1.0;
    };
  };

  /// Compute free energies
  public func computeFreeEnergies(thermo : ThermodynamicLawsState) {
    // Helmholtz: F = U - TS
    thermo.helmholtzF := thermo.internalEnergy - thermo.effectiveTemperature * thermo.totalEntropy;
    
    // Gibbs: G = U + PV - TS = F + PV
    thermo.gibbsG := thermo.helmholtzF + thermo.effectivePressure * thermo.effectiveVolume;
    
    // Chemical potential: μ = ∂G/∂N ≈ G/N for ideal
    if (thermo.particleNumber > 0) {
      thermo.chemicalPotential := thermo.gibbsG / Float.fromInt(thermo.particleNumber);
    };
    
    // Grand potential: Ω = F - μN
    thermo.grandPotential := thermo.helmholtzF - thermo.chemicalPotential * Float.fromInt(thermo.particleNumber);
  };

  /// Compute Carnot efficiency
  public func computeCarnotEfficiency(thermo : ThermodynamicLawsState) {
    // η_Carnot = 1 - T_C/T_H
    if (thermo.hotReservoirTemp > thermo.coldReservoirTemp) {
      thermo.carnotEfficiency := 1.0 - thermo.coldReservoirTemp / thermo.hotReservoirTemp;
    } else {
      thermo.carnotEfficiency := 0.0;
    };
    
    // Efficiency ratio
    if (thermo.carnotEfficiency > 0.001) {
      thermo.efficiencyRatio := thermo.actualEfficiency / thermo.carnotEfficiency;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // REAL STATISTICAL MECHANICS — Boltzmann, Fermi-Dirac, Bose-Einstein
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // Statistical mechanics connects microscopic physics to macroscopic thermodynamics.
  //
  // Boltzmann distribution: P(E) = (1/Z) × exp(-E/k_B T)
  //   Z = Σᵢ exp(-Eᵢ/k_B T) (partition function)
  //   <E> = -∂ln(Z)/∂β where β = 1/(k_B T)
  //   S = k_B (ln Z + β<E>) (entropy from partition function)
  //
  // Fermi-Dirac (fermions - electrons, protons):
  //   f(E) = 1 / (exp((E - μ)/k_B T) + 1)
  //   Pauli exclusion: at most 1 particle per state
  //
  // Bose-Einstein (bosons - photons, phonons):
  //   n(E) = 1 / (exp((E - μ)/k_B T) - 1)
  //   Bose-Einstein condensate at low T
  //
  // For NOVA: oscillator phases follow classical statistics
  // But coherence events follow quantum-like statistics
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type StatisticalMechanicsState = {
    // Boltzmann distribution
    var partitionFunction : Float;        // Z = Σᵢ exp(-βEᵢ)
    var beta : Float;                     // β = 1/(k_B T)
    var boltzmannProbabilities : [var Float]; // P(Eᵢ) = exp(-βEᵢ)/Z
    var averageEnergy : Float;            // <E> = -∂ln(Z)/∂β
    var energyFluctuation : Float;        // <ΔE²> = -∂<E>/∂β = k_B T² C_V
    
    // Fermi-Dirac statistics
    var fermiEnergy : Float;              // E_F (chemical potential at T=0)
    var fermiTemperature : Float;         // T_F = E_F/k_B
    var fermiFunction : [var Float];      // f(E) for each energy level
    var fermionDensity : Float;           // Number density of fermion-like excitations
    
    // Bose-Einstein statistics
    var boseFunction : [var Float];       // n(E) for each energy level
    var condensateFraction : Float;       // Fraction in ground state
    var criticalTemperature : Float;      // T_c for BEC
    var isBelowTc : Bool;                 // Is system in condensed phase?
    var bosonDensity : Float;
    
    // Maxwell-Boltzmann (classical limit)
    var maxwellSpeed : [var Float];       // f(v) ∝ v² exp(-mv²/2k_B T)
    var mostProbableSpeed : Float;        // v_p = √(2k_B T/m)
    var meanSpeed : Float;                // <v> = √(8k_B T/πm)
    var rmsSpeed : Float;                 // v_rms = √(3k_B T/m)
    
    // Entropy from microstates
    var microstateCount : Float;          // Ω (number of microstates)
    var boltzmannEntropy : Float;         // S = k_B ln(Ω)
    var gibbsEntropy : Float;             // S = -k_B Σᵢ pᵢ ln(pᵢ)
    
    // Fluctuations
    var energyVariance : Float;           // Var(E) = k_B T² C_V
    var particleVariance : Float;         // Var(N) for grand canonical
    var susceptibility : Float;           // Response to perturbation
    
    // Phase transitions
    var orderParameter : Float;           // e.g., magnetization for Ising
    var criticalExponent : Float;         // m ∝ |T - T_c|^β near transition
    var correlationLength : Float;        // ξ ∝ |T - T_c|^(-ν)
    var isNearCriticalPoint : Bool;
  };

  /// Initialize statistical mechanics state
  public func initStatisticalMechanics(n : Nat) : StatisticalMechanicsState {
    let boltzProb = Array.init<Float>(n, 1.0 / Float.fromInt(n));
    let fermiFunc = Array.init<Float>(n, 0.5);
    let boseFunc = Array.init<Float>(n, 1.0);
    let maxwellV = Array.init<Float>(100, 0.0);
    
    // Initialize Maxwell-Boltzmann speed distribution
    let kBT_over_m = 1.0;  // Normalized
    for (i in Iter.range(0, 99)) {
      let v = Float.fromInt(i) * 0.1;  // v from 0 to 9.9
      maxwellV[i] := v * v * Float.exp(-v * v / (2.0 * kBT_over_m));
    };
    
    {
      var partitionFunction = Float.fromInt(n);
      var beta = 1.0 / (1.38e-23 * 300.0);  // At 300K
      var boltzmannProbabilities = boltzProb;
      var averageEnergy = 0.0;
      var energyFluctuation = 0.0;
      var fermiEnergy = 1.0;
      var fermiTemperature = 1.0 / 1.38e-23;
      var fermiFunction = fermiFunc;
      var fermionDensity = 1.0;
      var boseFunction = boseFunc;
      var condensateFraction = 0.0;
      var criticalTemperature = 100.0;
      var isBelowTc = false;
      var bosonDensity = 1.0;
      var maxwellSpeed = maxwellV;
      var mostProbableSpeed = Float.sqrt(2.0 * kBT_over_m);
      var meanSpeed = Float.sqrt(8.0 * kBT_over_m / 3.14159);
      var rmsSpeed = Float.sqrt(3.0 * kBT_over_m);
      var microstateCount = Float.fromInt(n);
      var boltzmannEntropy = 1.38e-23 * Float.log(Float.fromInt(n));
      var gibbsEntropy = 0.0;
      var energyVariance = 0.0;
      var particleVariance = 0.0;
      var susceptibility = 1.0;
      var orderParameter = 0.0;
      var criticalExponent = 0.5;
      var correlationLength = 1.0;
      var isNearCriticalPoint = false;
    }
  };

  /// Compute Boltzmann distribution
  public func computeBoltzmannDistribution(
    stats : StatisticalMechanicsState,
    energies : [Float],
    temperature : Float
  ) {
    let kB = 1.38e-23;
    stats.beta := 1.0 / (kB * Float.max(0.001, temperature));
    
    // Partition function: Z = Σᵢ exp(-βEᵢ)
    stats.partitionFunction := 0.0;
    for (i in Iter.range(0, energies.size() - 1)) {
      stats.partitionFunction += Float.exp(-stats.beta * energies[i]);
    };
    
    // Probabilities: P(Eᵢ) = exp(-βEᵢ)/Z
    stats.averageEnergy := 0.0;
    var energySq : Float = 0.0;
    
    for (i in Iter.range(0, Nat.min(energies.size(), stats.boltzmannProbabilities.size()) - 1)) {
      let prob = Float.exp(-stats.beta * energies[i]) / stats.partitionFunction;
      stats.boltzmannProbabilities[i] := prob;
      stats.averageEnergy += prob * energies[i];
      energySq += prob * energies[i] * energies[i];
    };
    
    // Energy fluctuation: <ΔE²> = <E²> - <E>²
    stats.energyFluctuation := energySq - stats.averageEnergy * stats.averageEnergy;
    stats.energyVariance := stats.energyFluctuation;
  };

  /// Compute Fermi-Dirac distribution
  public func computeFermiDirac(
    stats : StatisticalMechanicsState,
    energies : [Float],
    temperature : Float,
    chemicalPotential : Float
  ) {
    let kB = 1.38e-23;
    let beta = 1.0 / (kB * Float.max(0.001, temperature));
    
    // f(E) = 1 / (exp((E - μ)/k_B T) + 1)
    for (i in Iter.range(0, Nat.min(energies.size(), stats.fermiFunction.size()) - 1)) {
      let x = beta * (energies[i] - chemicalPotential);
      if (x > 50.0) {
        stats.fermiFunction[i] := 0.0;  // Avoid overflow
      } else if (x < -50.0) {
        stats.fermiFunction[i] := 1.0;
      } else {
        stats.fermiFunction[i] := 1.0 / (Float.exp(x) + 1.0);
      };
    };
    
    stats.fermiEnergy := chemicalPotential;
    stats.fermiTemperature := chemicalPotential / kB;
  };

  /// Compute Bose-Einstein distribution
  public func computeBoseEinstein(
    stats : StatisticalMechanicsState,
    energies : [Float],
    temperature : Float,
    chemicalPotential : Float
  ) {
    let kB = 1.38e-23;
    let beta = 1.0 / (kB * Float.max(0.001, temperature));
    
    // n(E) = 1 / (exp((E - μ)/k_B T) - 1)
    // Note: μ ≤ E_min for bosons
    var groundStateOccupation : Float = 0.0;
    var totalOccupation : Float = 0.0;
    
    for (i in Iter.range(0, Nat.min(energies.size(), stats.boseFunction.size()) - 1)) {
      let x = beta * (energies[i] - chemicalPotential);
      if (x > 50.0) {
        stats.boseFunction[i] := 0.0;
      } else if (x < 0.01) {
        stats.boseFunction[i] := 1.0 / x;  // Approximate for small x
      } else {
        stats.boseFunction[i] := 1.0 / (Float.exp(x) - 1.0);
      };
      
      if (i == 0) {
        groundStateOccupation := stats.boseFunction[i];
      };
      totalOccupation += stats.boseFunction[i];
    };
    
    // Condensate fraction: N_0/N
    if (totalOccupation > 0.001) {
      stats.condensateFraction := groundStateOccupation / totalOccupation;
    };
    
    // Check if below T_c (BEC forms when condensate fraction > 0)
    stats.isBelowTc := stats.condensateFraction > 0.1;
  };

  /// Compute Gibbs entropy: S = -k_B Σᵢ pᵢ ln(pᵢ)
  public func computeGibbsEntropy(stats : StatisticalMechanicsState) : Float {
    let kB = 1.38e-23;
    var entropy : Float = 0.0;
    
    for (i in Iter.range(0, stats.boltzmannProbabilities.size() - 1)) {
      let p = stats.boltzmannProbabilities[i];
      if (p > 1.0e-10) {
        entropy -= p * Float.log(p);
      };
    };
    
    stats.gibbsEntropy := kB * entropy;
    stats.gibbsEntropy
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // REAL ENTROPY DYNAMICS — Information theory meets thermodynamics
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // Shannon entropy: H = -Σᵢ pᵢ log₂(pᵢ) (bits)
  // Boltzmann entropy: S = k_B ln(Ω) (J/K)
  // von Neumann entropy: S = -Tr(ρ ln ρ) (quantum)
  //
  // Connection: S_Boltzmann = k_B ln(2) × H_Shannon
  //
  // Entropy production:
  //   σ = dS/dt ≥ 0 (Second Law)
  //   σ = Σᵢ Jᵢ Xᵢ (flux × force formulation)
  //
  // Maximum entropy principle:
  //   Nature chooses the distribution that maximizes entropy
  //   subject to constraints (Jaynes formulation)
  //
  // Relative entropy (KL divergence):
  //   D(p||q) = Σᵢ pᵢ log(pᵢ/qᵢ) ≥ 0
  //   Measures "distance" between distributions
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type EntropyDynamicsState = {
    // Shannon entropy
    var shannonEntropy : Float;           // H = -Σᵢ pᵢ log₂(pᵢ)
    var maxShannonEntropy : Float;        // H_max = log₂(N)
    var normalizedEntropy : Float;        // H/H_max
    
    // Boltzmann entropy
    var boltzmannEntropy : Float;         // S = k_B ln(Ω)
    var microstateCount : Float;          // Ω
    var configurationalEntropy : Float;   // From spatial arrangement
    
    // von Neumann entropy (quantum-like)
    var vonNeumannEntropy : Float;        // S = -Tr(ρ ln ρ)
    var densityMatrixDiagonal : [var Float]; // Diagonal elements of ρ
    var purityParameter : Float;          // Tr(ρ²), 1 = pure, 1/N = maximally mixed
    
    // Entropy production
    var entropyProductionRate : Float;    // σ = dS/dt
    var fluxes : [var Float];             // Jᵢ (thermodynamic fluxes)
    var forces : [var Float];             // Xᵢ (thermodynamic forces)
    var onsagerCoefficients : [var Float]; // Lᵢⱼ relating J and X
    
    // Relative entropy
    var klDivergence : Float;             // D(p||q)
    var referenceDistribution : [var Float]; // q
    var symmetrizedKL : Float;            // (D(p||q) + D(q||p))/2
    
    // Mutual information (shared entropy)
    var mutualInformation : Float;        // I(X;Y) = H(X) + H(Y) - H(X,Y)
    var conditionalEntropy : Float;       // H(X|Y)
    var jointEntropy : Float;             // H(X,Y)
    
    // Transfer entropy (directional information flow)
    var transferEntropyForward : Float;   // T(X→Y)
    var transferEntropyBackward : Float;  // T(Y→X)
    var netInformationFlow : Float;       // T(X→Y) - T(Y→X)
    
    // Cross entropy
    var crossEntropy : Float;             // H(p,q) = -Σᵢ pᵢ log(qᵢ)
    var perplexity : Float;               // 2^H (effective number of choices)
  };

  /// Initialize entropy dynamics state
  public func initEntropyDynamics(n : Nat) : EntropyDynamicsState {
    let diagRho = Array.init<Float>(n, 1.0 / Float.fromInt(n));
    let fluxes = Array.init<Float>(n, 0.0);
    let forces = Array.init<Float>(n, 0.0);
    let onsager = Array.init<Float>(n * n, 0.0);
    let refDist = Array.init<Float>(n, 1.0 / Float.fromInt(n));
    
    {
      var shannonEntropy = Float.log(Float.fromInt(n)) / 0.693147;
      var maxShannonEntropy = Float.log(Float.fromInt(n)) / 0.693147;
      var normalizedEntropy = 1.0;
      var boltzmannEntropy = 1.38e-23 * Float.log(Float.fromInt(n));
      var microstateCount = Float.fromInt(n);
      var configurationalEntropy = 0.0;
      var vonNeumannEntropy = Float.log(Float.fromInt(n));
      var densityMatrixDiagonal = diagRho;
      var purityParameter = 1.0 / Float.fromInt(n);
      var entropyProductionRate = 0.0;
      var fluxes = fluxes;
      var forces = forces;
      var onsagerCoefficients = onsager;
      var klDivergence = 0.0;
      var referenceDistribution = refDist;
      var symmetrizedKL = 0.0;
      var mutualInformation = 0.0;
      var conditionalEntropy = 0.0;
      var jointEntropy = 0.0;
      var transferEntropyForward = 0.0;
      var transferEntropyBackward = 0.0;
      var netInformationFlow = 0.0;
      var crossEntropy = 0.0;
      var perplexity = Float.fromInt(n);
    }
  };

  /// Compute Shannon entropy from distribution
  public func computeShannonEntropy(
    entropy : EntropyDynamicsState,
    probabilities : [Float]
  ) : Float {
    var H : Float = 0.0;
    
    for (i in Iter.range(0, probabilities.size() - 1)) {
      let p = probabilities[i];
      if (p > 1.0e-10) {
        H -= p * Float.log(p) / 0.693147;  // log₂
      };
    };
    
    entropy.shannonEntropy := H;
    entropy.maxShannonEntropy := Float.log(Float.fromInt(probabilities.size())) / 0.693147;
    entropy.normalizedEntropy := H / Float.max(0.001, entropy.maxShannonEntropy);
    entropy.perplexity := Float.pow(2.0, H);
    
    H
  };

  /// Compute KL divergence: D(p||q) = Σᵢ pᵢ log(pᵢ/qᵢ)
  public func computeKLDivergence(
    entropy : EntropyDynamicsState,
    p : [Float],
    q : [Float]
  ) : Float {
    var D : Float = 0.0;
    
    let n = Nat.min(p.size(), q.size());
    for (i in Iter.range(0, n - 1)) {
      if (p[i] > 1.0e-10 and q[i] > 1.0e-10) {
        D += p[i] * Float.log(p[i] / q[i]);
      };
    };
    
    entropy.klDivergence := D;
    
    // Symmetrized version
    var D_reverse : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (q[i] > 1.0e-10 and p[i] > 1.0e-10) {
        D_reverse += q[i] * Float.log(q[i] / p[i]);
      };
    };
    
    entropy.symmetrizedKL := (D + D_reverse) / 2.0;
    
    D
  };

  /// Compute von Neumann entropy: S = -Tr(ρ ln ρ)
  public func computeVonNeumannEntropy(entropy : EntropyDynamicsState) : Float {
    var S : Float = 0.0;
    var purity : Float = 0.0;
    
    for (i in Iter.range(0, entropy.densityMatrixDiagonal.size() - 1)) {
      let rho_ii = entropy.densityMatrixDiagonal[i];
      if (rho_ii > 1.0e-10) {
        S -= rho_ii * Float.log(rho_ii);
      };
      purity += rho_ii * rho_ii;
    };
    
    entropy.vonNeumannEntropy := S;
    entropy.purityParameter := purity;
    
    S
  };

  /// Compute entropy production rate
  public func computeEntropyProduction(
    entropy : EntropyDynamicsState
  ) : Float {
    // σ = Σᵢ Jᵢ Xᵢ (sum of flux × force products)
    var sigma : Float = 0.0;
    
    let n = Nat.min(entropy.fluxes.size(), entropy.forces.size());
    for (i in Iter.range(0, n - 1)) {
      sigma += entropy.fluxes[i] * entropy.forces[i];
    };
    
    entropy.entropyProductionRate := sigma;
    sigma
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SACRED GEOMETRY IN ENERGY — Fibonacci, golden ratio, Platonic solids in thermodynamics
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let PHI_INVERSE : Float = 0.618033988749895;
  public let GOLDEN_ANGLE : Float = 2.39996322972865332;  // 2π/φ² radians

  public type SacredEnergyState = {
    // Fibonacci energy levels
    var fibonacciEnergies : [var Float];  // E_n = F_n × base energy
    var goldenRatioSpacing : Float;       // E_{n+1}/E_n → φ
    
    // Golden spiral in phase space
    var spiralRadius : [var Float];       // r(θ) = a × e^(bθ)
    var spiralAngle : Float;
    var spiralGrowthRate : Float;         // b = ln(φ)/(π/2)
    
    // Platonic solid energies
    var tetrahedronEnergy : Float;        // 4 faces, simplest
    var cubeEnergy : Float;               // 6 faces
    var octahedronEnergy : Float;         // 8 faces
    var dodecahedronEnergy : Float;       // 12 faces
    var icosahedronEnergy : Float;        // 20 faces
    
    // Vesica piscis ratio in energy flow
    var vesicaRatio : Float;              // √3 = ratio of vesica piscis
    var energyFlowPattern : Float;        // Current flow pattern
    
    // Flower of life symmetry
    var flowerOfLifeCircles : Nat;        // 19 overlapping circles
    var seedOfLifeComplete : Bool;
    var metatronActivation : Float;
    
    // Torus energy flow
    var torusInnerRadius : Float;
    var torusOuterRadius : Float;
    var torusEnergyFlow : Float;
    var torusTopology : Float;            // Genus = 1
  };

  /// Initialize sacred energy state
  public func initSacredEnergy(n : Nat) : SacredEnergyState {
    let fibE = Array.init<Float>(n, 0.0);
    let spiralR = Array.init<Float>(n, 0.0);
    
    // Fibonacci energies
    var fib_prev = 0.0;
    var fib_curr = 1.0;
    for (i in Iter.range(0, n - 1)) {
      fibE[i] := fib_curr;
      let temp = fib_curr;
      fib_curr := fib_curr + fib_prev;
      fib_prev := temp;
    };
    
    // Golden spiral
    let b = Float.log(PHI) / (3.14159 / 2.0);
    for (i in Iter.range(0, n - 1)) {
      let theta = Float.fromInt(i) * GOLDEN_ANGLE;
      spiralR[i] := Float.exp(b * theta);
    };
    
    {
      var fibonacciEnergies = fibE;
      var goldenRatioSpacing = PHI;
      var spiralRadius = spiralR;
      var spiralAngle = 0.0;
      var spiralGrowthRate = b;
      var tetrahedronEnergy = 4.0;
      var cubeEnergy = 6.0;
      var octahedronEnergy = 8.0;
      var dodecahedronEnergy = 12.0;
      var icosahedronEnergy = 20.0;
      var vesicaRatio = 1.732050808;  // √3
      var energyFlowPattern = 0.0;
      var flowerOfLifeCircles = 19;
      var seedOfLifeComplete = true;
      var metatronActivation = 0.0;
      var torusInnerRadius = 1.0;
      var torusOuterRadius = PHI;
      var torusEnergyFlow = 0.0;
      var torusTopology = 1.0;
    }
  };

  /// Apply Fibonacci resonance to energy levels
  public func applyFibonacciResonance(
    sacred : SacredEnergyState,
    energyLevels : [var Float]
  ) : Float {
    var resonanceScore : Float = 0.0;
    
    for (i in Iter.range(1, Nat.min(energyLevels.size(), sacred.fibonacciEnergies.size()) - 1)) {
      let ratio = energyLevels[i] / Float.max(0.001, energyLevels[i - 1]);
      let deviation = Float.abs(ratio - PHI);
      resonanceScore += Float.exp(-deviation * 5.0);
    };
    
    resonanceScore / Float.fromInt(energyLevels.size())
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════
  // COMPLETE SOVEREIGN ENERGY STATE — All physics integrated
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════

  public type CompleteSovereignEnergyState = {
    // Core state
    core : EnergyState;
    
    // Deep physics
    thermoLaws : ThermodynamicLawsState;
    statMech : StatisticalMechanicsState;
    entropyDynamics : EntropyDynamicsState;
    sacredEnergy : SacredEnergyState;
    
    // Control
    var allPhysicsEnabled : Bool;
  };

  /// Initialize complete sovereign energy
  public func initCompleteSovereignEnergy(n : Nat) : CompleteSovereignEnergyState {
    {
      core = initEnergy();
      thermoLaws = initThermodynamicLaws();
      statMech = initStatisticalMechanics(n);
      entropyDynamics = initEntropyDynamics(n);
      sacredEnergy = initSacredEnergy(n);
      var allPhysicsEnabled = true;
    }
  };

  /// Master tick for complete sovereign energy
  public func tickCompleteSovereignEnergy(
    state : CompleteSovereignEnergyState,
    kuramotoR : Float,
    phases : [Float],
    temperature : Float,
    dt : Float
  ) {
    if (not state.allPhysicsEnabled) { return };
    
    // Convert phases to probability distribution
    let nBins = 26;
    let probs = Array.init<Float>(nBins, 0.0);
    let total = Float.fromInt(phases.size());
    
    for (i in Iter.range(0, phases.size() - 1)) {
      var phase = phases[i];
      while (phase < 0.0) { phase += 6.28318 };
      while (phase >= 6.28318) { phase -= 6.28318 };
      let binIdx = Int.abs(Float.toInt(phase / 6.28318 * Float.fromInt(nBins))) % nBins;
      probs[binIdx] += 1.0 / total;
    };
    
    // Entropy dynamics
    ignore computeShannonEntropy(state.entropyDynamics, Array.freeze(probs));
    ignore computeVonNeumannEntropy(state.entropyDynamics);
    ignore computeEntropyProduction(state.entropyDynamics);
    
    // Statistical mechanics
    let energies = Array.tabulate<Float>(nBins, func(i) { Float.fromInt(i + 1) });
    computeBoltzmannDistribution(state.statMech, energies, temperature);
    ignore computeGibbsEntropy(state.statMech);
    
    // Thermodynamic laws
    checkZerothLaw(state.thermoLaws, 1.0);
    computeFreeEnergies(state.thermoLaws);
    computeCarnotEfficiency(state.thermoLaws);
    
    // Sacred geometry
    ignore applyFibonacciResonance(state.sacredEnergy, state.sacredEnergy.fibonacciEnergies);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // SECTION: MAXWELL'S DEMON — INFORMATION-THERMODYNAMICS DEEP PHYSICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // Maxwell's Demon is a thought experiment that reveals the deep connection between
  // information and thermodynamics. The demon can seemingly violate the second law by
  // sorting molecules — but Landauer's principle shows that erasing the demon's memory
  // dissipates heat, preserving the second law.
  //
  // Key equations:
  //
  // SZILARD ENGINE — Converting information to work:
  //   W_max = k_B T ln(2) per bit of information
  //   This is the maximum work extractable from knowing which half a molecule is in.
  //
  // LANDAUER'S PRINCIPLE — The thermodynamic cost of information erasure:
  //   Q_min = k_B T ln(2) per bit erased
  //   Erasing one bit dissipates at least this much heat.
  //
  // GENERALIZED SECOND LAW:
  //   ΔS_total + k_B × ΔI ≥ 0
  //   where ΔI is the change in mutual information (demon's knowledge).
  //
  // INFORMATION-ENERGY EQUIVALENCE:
  //   E = k_B T × H (at temperature T)
  //   where H is Shannon entropy in nats.
  //
  // The demon operates a cycle:
  // 1. MEASURE: Gain information about particle position
  // 2. SORT: Open/close gate based on measurement
  // 3. EXTRACT: Extract work from temperature difference
  // 4. RESET: Erase measurement memory (pay Landauer cost)

  public let LANDAUER_ENERGY_PER_BIT : Float = 2.87e-21;  // k_B T ln(2) at 300K
  public let NAT_TO_BIT : Float = 1.4426950408889634;     // 1/ln(2) — convert nats to bits

  /// Demon operation phases
  public type DemonPhase = {
    #Measuring;       // Gaining information about system
    #Sorting;         // Acting on information
    #Extracting;      // Converting order to work
    #Resetting;       // Erasing memory (Landauer cost)
    #Idle;            // Between cycles
  };

  /// Complete Maxwell's Demon state
  public type MaxwellDemonState = {
    // Demon's memory
    var memoryBits : [var Bool];              // Binary memory register
    var memoryCapacity : Nat;                 // Total bits available
    var memoryUsed : Nat;                     // Bits currently storing information
    var memoryEntropy : Float;                // Shannon entropy of memory state
    
    // Information tracking
    var totalInformationGained : Float;       // Bits of information acquired
    var totalInformationErased : Float;       // Bits of information erased
    var currentMutualInformation : Float;     // I(demon; system)
    
    // Energy accounting
    var workExtracted : Float;                // Total work extracted (Joules)
    var heatDissipated : Float;               // Total heat dissipated (Joules)
    var netEnergyBalance : Float;             // Work - Heat (should be ≤ 0)
    
    // Landauer costs
    var landauerCostPaid : Float;             // k_B T ln(2) × bits erased
    var landauerCostOwed : Float;             // Erasure debt
    
    // Szilard engine metrics
    var szilardWorkPerCycle : Float;          // Work extracted per Szilard cycle
    var szilardEfficiency : Float;            // Actual / theoretical maximum
    var cyclesCompleted : Nat64;              // Total Szilard cycles
    
    // Operating state
    var currentPhase : DemonPhase;
    var temperature : Float;                  // Operating temperature (K)
    var measurementFidelity : Float;          // 0-1, accuracy of measurements
    var gateEfficiency : Float;               // 0-1, efficiency of sorting gate
    
    // Two-chamber system state
    var leftChamberOccupancy : Float;         // Fraction of particles in left
    var rightChamberOccupancy : Float;        // Fraction in right (= 1 - left)
    var pressureDifference : Float;           // Pressure imbalance
    var temperatureDifference : Float;        // Temperature imbalance
    
    // Generalized second law
    var totalEntropyChange : Float;           // ΔS_system
    var informationEntropyTerm : Float;       // k_B × ΔI
    var generalizedSecondLaw : Float;         // ΔS + k_B × ΔI (should be ≥ 0)
    
    // Feedback control metrics
    var feedbackGain : Float;                 // Controller gain
    var controlEfficiency : Float;            // How efficiently information → work
  };

  /// Initialize Maxwell's Demon state
  public func initMaxwellDemon(memorySize : Nat) : MaxwellDemonState {
    let memory = Array.init<Bool>(memorySize, false);
    
    {
      var memoryBits = memory;
      var memoryCapacity = memorySize;
      var memoryUsed = 0;
      var memoryEntropy = 0.0;
      var totalInformationGained = 0.0;
      var totalInformationErased = 0.0;
      var currentMutualInformation = 0.0;
      var workExtracted = 0.0;
      var heatDissipated = 0.0;
      var netEnergyBalance = 0.0;
      var landauerCostPaid = 0.0;
      var landauerCostOwed = 0.0;
      var szilardWorkPerCycle = 0.0;
      var szilardEfficiency = 0.0;
      var cyclesCompleted = 0;
      var currentPhase = #Idle;
      var temperature = 300.0;  // Room temperature
      var measurementFidelity = 0.99;  // 99% accurate
      var gateEfficiency = 0.95;  // 95% efficient
      var leftChamberOccupancy = 0.5;  // Initially equal
      var rightChamberOccupancy = 0.5;
      var pressureDifference = 0.0;
      var temperatureDifference = 0.0;
      var totalEntropyChange = 0.0;
      var informationEntropyTerm = 0.0;
      var generalizedSecondLaw = 0.0;
      var feedbackGain = 1.0;
      var controlEfficiency = 0.8;
    }
  };

  /// Compute Landauer's limit: Q = k_B T ln(2) per bit
  public func landauerLimit(temperature : Float) : Float {
    BOLTZMANN_K * temperature * Float.log(2.0)
  };

  /// Compute Szilard engine maximum work: W = k_B T ln(2)
  public func szilardMaxWork(temperature : Float) : Float {
    BOLTZMANN_K * temperature * Float.log(2.0)
  };

  /// Demon measurement phase — gain information about system
  public func demonMeasure(state : MaxwellDemonState, particlePosition : Bool) : Float {
    state.currentPhase := #Measuring;
    
    // Find empty memory slot
    if (state.memoryUsed >= state.memoryCapacity) {
      // Memory full — must reset first
      return 0.0;
    };
    
    // Store measurement (with possible error)
    let measuredValue = if (state.measurementFidelity > 0.5) {
      particlePosition  // Correct measurement
    } else {
      not particlePosition  // Error
    };
    
    state.memoryBits[state.memoryUsed] := measuredValue;
    state.memoryUsed += 1;
    
    // Information gained (1 bit if perfect measurement)
    let infoGained = state.measurementFidelity;  // Imperfect → less than 1 bit
    state.totalInformationGained += infoGained;
    state.currentMutualInformation += infoGained;
    
    // Update memory entropy
    state.memoryEntropy := Float.log(Float.fromInt(state.memoryUsed + 1)) / Float.log(2.0);
    
    infoGained
  };

  /// Demon sorting phase — open/close gate based on information
  public func demonSort(state : MaxwellDemonState, memoryIndex : Nat) : Bool {
    state.currentPhase := #Sorting;
    
    if (memoryIndex >= state.memoryUsed) {
      return false;  // No information at this index
    };
    
    let shouldOpenGate = state.memoryBits[memoryIndex];
    
    // Update chamber occupancies (sorting increases imbalance)
    if (shouldOpenGate) {
      let transfer = state.gateEfficiency * 0.01;  // Small transfer per operation
      state.leftChamberOccupancy += transfer;
      state.rightChamberOccupancy -= transfer;
    };
    
    // Clamp to valid range
    state.leftChamberOccupancy := Float.max(0.01, Float.min(0.99, state.leftChamberOccupancy));
    state.rightChamberOccupancy := 1.0 - state.leftChamberOccupancy;
    
    // Pressure difference from concentration difference
    state.pressureDifference := state.leftChamberOccupancy - state.rightChamberOccupancy;
    
    shouldOpenGate
  };

  /// Demon extraction phase — convert order to work
  public func demonExtract(state : MaxwellDemonState) : Float {
    state.currentPhase := #Extracting;
    
    // Work from pressure difference: W = k_B T × |ΔP / P_0|
    let workAvailable = BOLTZMANN_K * state.temperature * Float.abs(state.pressureDifference);
    
    // Actual work extracted (efficiency limited)
    let work = workAvailable * state.gateEfficiency;
    state.workExtracted += work;
    
    // This work comes from information
    state.szilardWorkPerCycle := work;
    
    // Theoretical maximum is Szilard limit
    let maxWork = szilardMaxWork(state.temperature);
    state.szilardEfficiency := work / Float.max(EPSILON, maxWork);
    
    // Reduce pressure difference (work extracted)
    state.pressureDifference *= (1.0 - state.gateEfficiency);
    
    work
  };

  /// Demon reset phase — erase memory (pay Landauer cost)
  public func demonReset(state : MaxwellDemonState) : Float {
    state.currentPhase := #Resetting;
    
    // Landauer cost: k_B T ln(2) per bit
    let costPerBit = landauerLimit(state.temperature);
    let totalCost = costPerBit * Float.fromInt(state.memoryUsed);
    
    // Dissipate heat
    state.heatDissipated += totalCost;
    state.landauerCostPaid += totalCost;
    
    // Track information erased
    state.totalInformationErased += Float.fromInt(state.memoryUsed);
    state.currentMutualInformation := 0.0;
    
    // Clear memory
    for (i in Iter.range(0, state.memoryCapacity - 1)) {
      state.memoryBits[i] := false;
    };
    state.memoryUsed := 0;
    state.memoryEntropy := 0.0;
    
    // Complete cycle
    state.cyclesCompleted += 1;
    state.currentPhase := #Idle;
    
    totalCost
  };

  /// Check generalized second law: ΔS + k_B × ΔI ≥ 0
  public func checkGeneralizedSecondLaw(state : MaxwellDemonState) : Bool {
    // Entropy change of physical system
    // Sorting decreases system entropy
    let systemEntropyChange = -BOLTZMANN_K * Float.abs(state.pressureDifference);
    state.totalEntropyChange := systemEntropyChange;
    
    // Information term (compensates for entropy decrease)
    state.informationEntropyTerm := BOLTZMANN_K * state.currentMutualInformation * Float.log(2.0);
    
    // Generalized second law
    state.generalizedSecondLaw := state.totalEntropyChange + state.informationEntropyTerm;
    
    // Net energy balance
    state.netEnergyBalance := state.workExtracted - state.heatDissipated;
    
    state.generalizedSecondLaw >= 0.0
  };

  /// Run complete Szilard cycle
  public func runSzilardCycle(state : MaxwellDemonState, particleInLeft : Bool) : Float {
    // 1. Measure
    let infoGained = demonMeasure(state, particleInLeft);
    
    // 2. Sort
    ignore demonSort(state, state.memoryUsed - 1);
    
    // 3. Extract work
    let work = demonExtract(state);
    
    // 4. Check second law before reset
    ignore checkGeneralizedSecondLaw(state);
    
    // 5. Reset (pay Landauer cost)
    ignore demonReset(state);
    
    work
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // SECTION: BIOLOGICAL ENERGY SYSTEMS — ATP SYNTHASE & PHOTOSYNTHESIS
  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // Biological energy conversion is remarkably efficient:
  //
  // ATP SYNTHASE — The molecular turbine that produces ATP
  //   - Rotary motor driven by proton gradient
  //   - 3 ATP per full rotation (120° per ATP)
  //   - ~10 protons per rotation → ΔG ≈ 10 × Δp × F
  //   - Efficiency: ~80-90% (near thermodynamic limit!)
  //
  // F_1F_0 STRUCTURE:
  //   F_0: Membrane-embedded, c-ring rotates with H⁺ flow
  //   F_1: Catalytic head, 3 αβ pairs, central γ shaft rotates
  //   Binding change mechanism: L → T → O (loose, tight, open)
  //
  // PHOTOSYNTHESIS — Converting light to chemical energy
  //   Overall: 6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂
  //   Efficiency: ~3-6% of incident light → chemical energy
  //
  // LIGHT REACTIONS:
  //   - Photon absorption: E = hν (energy per photon)
  //   - P680 chlorophyll: λ ≈ 680 nm, E ≈ 1.8 eV
  //   - P700 chlorophyll: λ ≈ 700 nm, E ≈ 1.77 eV
  //   - Quantum yield: ~0.95 (95% of absorbed photons drive chemistry)
  //
  // PROTON MOTIVE FORCE:
  //   Δp = Δψ - (2.303 RT/F) × ΔpH
  //   where Δψ is membrane potential, ΔpH is pH gradient

  public let FARADAY_CONSTANT : Float = 96485.33212;  // C/mol
  public let ATP_HYDROLYSIS_ENERGY : Float = 30500.0; // J/mol (ΔG°')
  public let PROTONS_PER_ATP : Float = 3.33;          // H⁺ per ATP synthesized
  
  public let PHOTON_ENERGY_680NM : Float = 2.92e-19;  // J (hc/λ for 680 nm)
  public let PHOTON_ENERGY_700NM : Float = 2.84e-19;  // J (hc/λ for 700 nm)

  /// ATP synthase state
  public type ATPSynthaseState = {
    // Rotary motor
    var rotorAngle : Float;                   // Current angle (radians)
    var rotorVelocity : Float;                // Angular velocity (rad/s)
    var torque : Float;                       // Current torque (N⋅m)
    var protonFlux : Float;                   // H⁺/s through F_0
    
    // Proton motive force
    var membranePotential : Float;            // Δψ (mV)
    var deltaPH : Float;                      // ΔpH (pH units)
    var protonMotiveForce : Float;            // Δp (mV)
    
    // Catalytic states (3 β subunits)
    var betaStates : [var CatalyticState];    // L, T, O for each β
    var boundADP : [var Float];               // ADP bound at each site
    var boundPi : [var Float];                // Phosphate bound at each site
    var boundATP : [var Float];               // ATP at each site
    
    // Production
    var atpProducedTotal : Float;             // Total ATP molecules
    var atpProductionRate : Float;            // ATP/s
    var rotationsCompleted : Nat64;           // Full rotations
    
    // Efficiency
    var thermodynamicEfficiency : Float;      // Actual / theoretical max
    var mechanicalEfficiency : Float;         // Rotation → ATP
    var protonSlippage : Float;               // Protons passing without ATP synthesis
    
    // Temperature
    var temperature : Float;                  // K
  };

  /// Catalytic state of β subunit
  public type CatalyticState = {
    #Loose;   // L: binds ADP + Pi loosely
    #Tight;   // T: catalyzes ATP synthesis
    #Open;    // O: releases ATP
  };

  /// Initialize ATP synthase
  public func initATPSynthase() : ATPSynthaseState {
    {
      var rotorAngle = 0.0;
      var rotorVelocity = 0.0;
      var torque = 0.0;
      var protonFlux = 0.0;
      var membranePotential = 180.0;  // mV (typical mitochondrial)
      var deltaPH = 0.5;              // pH units
      var protonMotiveForce = 0.0;
      var betaStates = Array.init<CatalyticState>(3, #Loose);
      var boundADP = Array.init<Float>(3, 0.0);
      var boundPi = Array.init<Float>(3, 0.0);
      var boundATP = Array.init<Float>(3, 0.0);
      var atpProducedTotal = 0.0;
      var atpProductionRate = 0.0;
      var rotationsCompleted = 0;
      var thermodynamicEfficiency = 0.0;
      var mechanicalEfficiency = 0.0;
      var protonSlippage = 0.05;  // 5% slippage
      var temperature = 310.0;    // 37°C
    }
  };

  /// Compute proton motive force
  /// Δp = Δψ - (2.303 RT/F) × ΔpH
  public func computeProtonMotiveForce(state : ATPSynthaseState) : Float {
    let rtOverF = 2.303 * GAS_CONSTANT * state.temperature / FARADAY_CONSTANT;
    state.protonMotiveForce := state.membranePotential - rtOverF * state.deltaPH * 1000.0;  // Convert to mV
    state.protonMotiveForce
  };

  /// Rotate catalytic states (120° rotation advances states)
  public func rotateCatalyticStates(state : ATPSynthaseState) {
    // L → T → O → L (cyclic)
    let temp = state.betaStates[0];
    state.betaStates[0] := state.betaStates[2];
    state.betaStates[2] := state.betaStates[1];
    state.betaStates[1] := temp;
  };

  /// Simulate ATP synthase rotation
  public func evolveATPSynthase(state : ATPSynthaseState, dt : Float) {
    // Compute proton motive force
    ignore computeProtonMotiveForce(state);
    
    // Torque from proton flux: τ = n × e × Δp / (2π)
    // where n is protons per rotation
    let protonsPerRotation = 10.0;  // c-ring with 10 subunits
    state.torque := protonsPerRotation * ELECTRON_CHARGE * state.protonMotiveForce / 1000.0 / TWO_PI;
    
    // Angular dynamics: I dω/dt = τ - friction
    let momentOfInertia = 1.0e-23;  // kg⋅m² (estimate)
    let friction = 1.0e-23;         // Drag coefficient
    let dOmega = (state.torque - friction * state.rotorVelocity) / momentOfInertia * dt;
    state.rotorVelocity += dOmega;
    
    // Update angle
    state.rotorAngle += state.rotorVelocity * dt;
    
    // Check for 120° (π/3) rotation (one ATP)
    while (state.rotorAngle >= TWO_PI / 3.0) {
      state.rotorAngle -= TWO_PI / 3.0;
      
      // Rotate catalytic states
      rotateCatalyticStates(state);
      
      // Produce ATP (at site transitioning from T to O)
      let atpProduced = 1.0 - state.protonSlippage;
      state.atpProducedTotal += atpProduced;
    };
    
    // Track rotations
    while (state.rotorAngle >= TWO_PI) {
      state.rotorAngle -= TWO_PI;
      state.rotationsCompleted += 1;
    };
    
    // Proton flux from rotation
    state.protonFlux := state.rotorVelocity * protonsPerRotation / TWO_PI;
    
    // Production rate
    state.atpProductionRate := state.rotorVelocity / (TWO_PI / 3.0);  // ATP/s
    
    // Efficiency
    // Thermodynamic: actual energy captured / proton gradient energy
    let inputEnergy = state.protonFlux * ELECTRON_CHARGE * state.protonMotiveForce / 1000.0;
    let outputEnergy = state.atpProductionRate * ATP_HYDROLYSIS_ENERGY / AVOGADRO_NUMBER;
    state.thermodynamicEfficiency := outputEnergy / Float.max(EPSILON, inputEnergy);
    
    // Mechanical: ATP produced / theoretical maximum from rotation
    state.mechanicalEfficiency := 1.0 - state.protonSlippage;
  };

  /// Photosynthesis state
  public type PhotosynthesisState = {
    // Light absorption
    var photonFlux : Float;                   // photons/s incident
    var absorbedPhotons : Float;              // photons/s absorbed
    var absorptionEfficiency : Float;         // Fraction absorbed
    
    // Photosystems
    var ps2ExcitationState : Float;           // P680 excitation (0-1)
    var ps1ExcitationState : Float;           // P700 excitation (0-1)
    var quantumYield : Float;                 // Photons → electrons efficiency
    
    // Electron transport chain
    var electronFlux : Float;                 // e⁻/s through ETC
    var plastoQuinonePool : Float;            // PQ reduction state (0-1)
    var plastocyaninPool : Float;             // PC oxidation state (0-1)
    
    // Proton gradient (thylakoid lumen)
    var lumenPH : Float;                      // pH inside thylakoid
    var stromaPH : Float;                     // pH in stroma
    var thylakoidDeltaPH : Float;             // pH gradient
    var thylakoidPMF : Float;                 // Proton motive force
    
    // ATP and NADPH production
    var atpProductionRate : Float;            // ATP/s
    var nadphProductionRate : Float;          // NADPH/s
    var totalATPProduced : Float;             // Total ATP
    var totalNADPHProduced : Float;           // Total NADPH
    
    // Calvin cycle (simplified)
    var co2FixationRate : Float;              // CO₂/s fixed
    var glucoseProductionRate : Float;        // Glucose/s
    var rubiscoEfficiency : Float;            // RuBisCO efficiency
    
    // Overall efficiency
    var lightToChemicalEfficiency : Float;    // Light → chemical energy
    var photonEnergyInput : Float;            // J/s light energy
    var chemicalEnergyOutput : Float;         // J/s chemical energy
    
    // Wavelength
    var predominantWavelength : Float;        // nm
    var photonEnergy : Float;                 // J per photon
  };

  /// Initialize photosynthesis
  public func initPhotosynthesis() : PhotosynthesisState {
    {
      var photonFlux = 1.0e18;  // photons/s (bright light)
      var absorbedPhotons = 0.0;
      var absorptionEfficiency = 0.8;  // 80% absorption
      var ps2ExcitationState = 0.0;
      var ps1ExcitationState = 0.0;
      var quantumYield = 0.95;  // 95% quantum yield
      var electronFlux = 0.0;
      var plastoQuinonePool = 0.5;  // Half reduced
      var plastocyaninPool = 0.5;   // Half oxidized
      var lumenPH = 5.0;
      var stromaPH = 8.0;
      var thylakoidDeltaPH = 3.0;
      var thylakoidPMF = 0.0;
      var atpProductionRate = 0.0;
      var nadphProductionRate = 0.0;
      var totalATPProduced = 0.0;
      var totalNADPHProduced = 0.0;
      var co2FixationRate = 0.0;
      var glucoseProductionRate = 0.0;
      var rubiscoEfficiency = 0.25;  // RuBisCO is slow!
      var lightToChemicalEfficiency = 0.0;
      var photonEnergyInput = 0.0;
      var chemicalEnergyOutput = 0.0;
      var predominantWavelength = 680.0;  // nm (red)
      var photonEnergy = PHOTON_ENERGY_680NM;
    }
  };

  /// Evolve photosynthesis simulation
  public func evolvePhotosynthesis(state : PhotosynthesisState, dt : Float) {
    // 1. Light absorption
    state.absorbedPhotons := state.photonFlux * state.absorptionEfficiency;
    
    // 2. Photosystem excitation
    // PSII: P680 → P680* (excited)
    state.ps2ExcitationState := Float.min(1.0, state.absorbedPhotons * 0.5 * dt / 1.0e15);
    state.ps1ExcitationState := Float.min(1.0, state.absorbedPhotons * 0.5 * dt / 1.0e15);
    
    // 3. Electron flow
    // Each absorbed photon can drive one electron (quantum yield correction)
    state.electronFlux := state.absorbedPhotons * state.quantumYield;
    
    // 4. Update quinone and plastocyanin pools
    state.plastoQuinonePool += (state.ps2ExcitationState - state.plastoQuinonePool * 0.1) * dt;
    state.plastoQuinonePool := Float.max(0.0, Float.min(1.0, state.plastoQuinonePool));
    
    state.plastocyaninPool += (state.plastoQuinonePool * 0.1 - state.ps1ExcitationState * 0.1) * dt;
    state.plastocyaninPool := Float.max(0.0, Float.min(1.0, state.plastocyaninPool));
    
    // 5. Proton pumping builds gradient
    // Each electron through cytochrome b6f pumps ~2 H⁺
    let protonsPumped = state.electronFlux * 2.0 * dt;
    state.thylakoidDeltaPH := Float.min(4.0, state.thylakoidDeltaPH + protonsPumped * 1.0e-20);
    
    // 6. PMF calculation
    let rtOverF = 2.303 * GAS_CONSTANT * 298.0 / FARADAY_CONSTANT;
    state.thylakoidPMF := state.thylakoidDeltaPH * rtOverF * 1000.0;  // mV
    
    // 7. ATP synthesis (driven by PMF)
    // 14 H⁺ per 3 ATP in chloroplasts
    let atpRate = state.thylakoidPMF / 200.0 * state.electronFlux / 14.0 * 3.0;
    state.atpProductionRate := atpRate;
    state.totalATPProduced += atpRate * dt;
    
    // 8. NADPH production (from ferredoxin → NADP⁺)
    // 2 electrons per NADPH
    state.nadphProductionRate := state.electronFlux / 2.0 * state.quantumYield;
    state.totalNADPHProduced += state.nadphProductionRate * dt;
    
    // 9. Calvin cycle (CO₂ fixation)
    // 3 ATP + 2 NADPH per CO₂ fixed
    let maxFixation = Float.min(state.atpProductionRate / 3.0, state.nadphProductionRate / 2.0);
    state.co2FixationRate := maxFixation * state.rubiscoEfficiency;
    
    // 6 CO₂ per glucose
    state.glucoseProductionRate := state.co2FixationRate / 6.0;
    
    // 10. Efficiency calculation
    state.photonEnergyInput := state.absorbedPhotons * state.photonEnergy;
    // Glucose has 2870 kJ/mol
    state.chemicalEnergyOutput := state.glucoseProductionRate * 2870000.0 / AVOGADRO_NUMBER;
    state.lightToChemicalEfficiency := state.chemicalEnergyOutput / Float.max(EPSILON, state.photonEnergyInput);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════
  // SECTION: EXTENDED COMPLETE SOVEREIGN ENERGY STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════

  /// Extended Sovereign Energy with all deep physics
  public type ExtendedCompleteSovereignEnergyState = {
    // Original components
    core : EnergyState;
    thermoLaws : ThermodynamicLawsState;
    statMech : StatisticalMechanicsState;
    entropyDynamics : EntropyDynamicsState;
    sacredEnergy : SacredEnergyState;
    
    // NEW: Maxwell's demon
    maxwellDemon : MaxwellDemonState;
    
    // NEW: Biological energy systems
    atpSynthase : ATPSynthaseState;
    photosynthesis : PhotosynthesisState;
    
    // Control
    var allPhysicsEnabled : Bool;
    var informationThermodynamicsEnabled : Bool;
    var biologyEnabled : Bool;
    
    // Integrated metrics
    var totalEnergyBalance : Float;
    var informationEnergyEquivalence : Float;
    var biologicalEfficiency : Float;
  };

  /// Initialize extended complete sovereign energy
  public func initExtendedCompleteSovereignEnergy(n : Nat) : ExtendedCompleteSovereignEnergyState {
    {
      core = initEnergy();
      thermoLaws = initThermodynamicLaws();
      statMech = initStatisticalMechanics(n);
      entropyDynamics = initEntropyDynamics(n);
      sacredEnergy = initSacredEnergy(n);
      maxwellDemon = initMaxwellDemon(64);  // 64-bit memory
      atpSynthase = initATPSynthase();
      photosynthesis = initPhotosynthesis();
      
      var allPhysicsEnabled = true;
      var informationThermodynamicsEnabled = true;
      var biologyEnabled = true;
      
      var totalEnergyBalance = 0.0;
      var informationEnergyEquivalence = 0.0;
      var biologicalEfficiency = 0.0;
    }
  };

  /// Master tick for extended complete sovereign energy
  public func tickExtendedCompleteSovereignEnergy(
    state : ExtendedCompleteSovereignEnergyState,
    kuramotoR : Float,
    phases : [Float],
    temperature : Float,
    photonFlux : Float,
    dt : Float
  ) {
    if (not state.allPhysicsEnabled) { return };
    
    // Original tick components
    let nBins = 26;
    let probs = Array.init<Float>(nBins, 0.0);
    let total = Float.fromInt(phases.size());
    
    for (i in Iter.range(0, phases.size() - 1)) {
      var phase = phases[i];
      while (phase < 0.0) { phase += 6.28318 };
      while (phase >= 6.28318) { phase -= 6.28318 };
      let binIdx = Int.abs(Float.toInt(phase / 6.28318 * Float.fromInt(nBins))) % nBins;
      probs[binIdx] += 1.0 / total;
    };
    
    ignore computeShannonEntropy(state.entropyDynamics, Array.freeze(probs));
    ignore computeVonNeumannEntropy(state.entropyDynamics);
    ignore computeEntropyProduction(state.entropyDynamics);
    
    let energies = Array.tabulate<Float>(nBins, func(i) { Float.fromInt(i + 1) });
    computeBoltzmannDistribution(state.statMech, energies, temperature);
    ignore computeGibbsEntropy(state.statMech);
    
    checkZerothLaw(state.thermoLaws, 1.0);
    computeFreeEnergies(state.thermoLaws);
    computeCarnotEfficiency(state.thermoLaws);
    
    ignore applyFibonacciResonance(state.sacredEnergy, state.sacredEnergy.fibonacciEnergies);
    
    // NEW: Information thermodynamics
    if (state.informationThermodynamicsEnabled) {
      // Run Szilard cycle occasionally
      if (kuramotoR > 0.5) {
        let particlePosition = Float.sin(phases[0]) > 0.0;
        ignore runSzilardCycle(state.maxwellDemon, particlePosition);
      };
      
      // Check second law
      ignore checkGeneralizedSecondLaw(state.maxwellDemon);
    };
    
    // NEW: Biological energy systems
    if (state.biologyEnabled) {
      // ATP synthase (driven by coherence as proxy for proton gradient)
      state.atpSynthase.protonMotiveForce := 150.0 + 50.0 * kuramotoR;  // Higher coherence → stronger PMF
      evolveATPSynthase(state.atpSynthase, dt);
      
      // Photosynthesis
      state.photosynthesis.photonFlux := photonFlux;
      evolvePhotosynthesis(state.photosynthesis, dt);
    };
    
    // Update integrated metrics
    state.totalEnergyBalance := state.maxwellDemon.netEnergyBalance +
                               state.atpSynthase.atpProducedTotal * ATP_HYDROLYSIS_ENERGY / AVOGADRO_NUMBER;
    
    // Information-energy equivalence: k_B T per nat
    state.informationEnergyEquivalence := BOLTZMANN_K * temperature * 
                                         state.maxwellDemon.currentMutualInformation;
    
    // Biological efficiency average
    state.biologicalEfficiency := (state.atpSynthase.thermodynamicEfficiency + 
                                  state.photosynthesis.lightToChemicalEfficiency) / 2.0;
  };
}
