/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║                         CYCLE BANK — SELF-FUNDING ENGINE                       ║
 * ║              The Organism Pays For Itself From Its Own Treasury                ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  CANONICAL ARCHITECTURE COMPLIANCE:                                            ║
 * ║  ✓ HELIX_ALPHA = 0.004                                                        ║
 * ║  ✓ SACESI = Nat64                                                             ║
 * ║  ✓ Jasmine's Law 5-condition                                                  ║
 * ║  ✓ 5-TIER ALERT SYSTEM (1T → 500B → 100B → 50B → 10B)                        ║
 * ║  ✓ AUTO-CONVERSION ICP → CYCLES                                               ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 *
 * COST MODEL (per CANONICAL.md):
 * - Heartbeat at 12 Hz = 1,036,800 beats/day × 1B cycles = ~1.04T cycles/day
 * - At $1.30 per 1T cycles = $1.30/day = ~$475/year
 * - HTTP outcalls: ~3 calls/day × $0.13 = ~$0.39/day
 * - TOTAL: ~$600-800/year to run the entire sovereign organism 24/7
 *
 * SELF-FUNDING MECHANISMS:
 * 1. Cycle Bank auto-refuel loop (this module)
 * 2. Maxwell's Demon yield: Y = 0.85 × ΔH × C × C_adj
 * 3. 12-token mint engine on coherence
 */

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";

module CycleBank {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // CANONICAL CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    public let HELIX_ALPHA : Float = 0.004;
    
    /// 5-TIER ALERT THRESHOLDS (in cycles)
    public let TIER_1_THRESHOLD : Nat = 1_000_000_000_000;      // 1T cycles - log alert
    public let TIER_2_THRESHOLD : Nat = 500_000_000_000;        // 500B cycles - auto-conversion
    public let TIER_3_THRESHOLD : Nat = 100_000_000_000;        // 100B cycles - emergency top-up
    public let TIER_4_THRESHOLD : Nat = 50_000_000_000;         // 50B cycles - suspend non-critical
    public let TIER_5_THRESHOLD : Nat = 10_000_000_000;         // 10B cycles - survive-only mode
    
    /// Cost estimates (in cycles)
    public let HEARTBEAT_COST : Nat = 1_000_000_000;            // ~1B cycles/beat
    public let HTTP_OUTCALL_COST : Nat = 100_000_000_000;       // ~100B cycles/call
    public let STORAGE_COST_PER_GB_YEAR : Nat = 127_000_000_000; // ~127B cycles/GB/year
    public let CANISTER_DAILY_FEE : Nat = 1_000_000_000;        // ~1B cycles/day
    
    /// Heartbeat frequency
    public let HEARTBEAT_HZ : Nat = 12;
    public let BEATS_PER_DAY : Nat = 12 * 60 * 60 * 24;         // 1,036,800 beats/day
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: CYCLE BANK STATE
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Current alert tier
    public type AlertTier = {
        #Tier0_Healthy;     // Above 1T - all systems nominal
        #Tier1_Alert;       // 500B-1T - log alert
        #Tier2_Convert;     // 100B-500B - auto-conversion triggered
        #Tier3_Emergency;   // 50B-100B - emergency ICP→cycles
        #Tier4_Suspend;     // 10B-50B - non-critical suspended
        #Tier5_Survive;     // Below 10B - survive-only mode at 1 Hz
    };
    
    /// Operating mode based on cycle balance
    public type OperatingMode = {
        #FullPower;         // 12 Hz, all modules
        #Reduced;           // 6 Hz, critical modules only
        #Emergency;         // 2 Hz, survival modules only
        #Survival;          // 1 Hz, heartbeat only
    };
    
    /// Cycle bank state
    public type CycleBankState = {
        // Identity (SACESI: Nat64)
        bankId: Nat64;
        createdAt: Nat64;
        creator: Principal;
        
        // Current balance
        currentBalance: Nat;
        lastChecked: Nat64;
        
        // Alert status
        currentTier: AlertTier;
        operatingMode: OperatingMode;
        
        // Reserve holdings
        icpReserve: Nat64;              // ICP held for conversion
        ethReserve: Nat64;              // ETH held (in wei)
        stEthReserve: Nat64;            // stETH from Lido staking
        
        // Conversion tracking
        totalConversions: Nat64;
        totalCyclesConverted: Nat;
        lastConversion: ?ConversionRecord;
        
        // Yield tracking (from organism operation)
        maxwellDemonYield: Float;
        mintingYield: Float;
        successionRoyalties: Nat64;
        
        // Cost tracking
        totalCyclesSpent: Nat;
        heartbeatCycles: Nat;
        httpOutcallCycles: Nat;
        storageCycles: Nat;
        
        // History
        alertHistory: [AlertEvent];
        conversionHistory: [ConversionRecord];
        
        // Performance
        averageDailyCost: Float;
        projectedRunway: Nat;           // Days until depletion
    };
    
    /// Alert event
    public type AlertEvent = {
        eventId: Nat64;
        timestamp: Nat64;
        tier: AlertTier;
        balanceAtAlert: Nat;
        action: AlertAction;
        resolved: Bool;
        resolvedAt: ?Nat64;
    };
    
    /// Alert actions
    public type AlertAction = {
        #LogOnly;
        #AutoConvert: Nat64;            // ICP amount converted
        #EmergencyTopUp: Nat64;         // ICP amount from reserve
        #SuspendModules: [Text];        // Modules suspended
        #EnterSurvivalMode;
        #ExternalNotification;
    };
    
    /// Conversion record
    public type ConversionRecord = {
        conversionId: Nat64;
        timestamp: Nat64;
        sourceAsset: ConversionSource;
        sourceAmount: Nat64;
        cyclesReceived: Nat;
        exchangeRate: Float;
        trigger: ConversionTrigger;
        balanceBefore: Nat;
        balanceAfter: Nat;
    };
    
    /// Conversion sources
    public type ConversionSource = {
        #ICP;
        #ETH;
        #StETH;
        #MintedTokens;
        #SuccessionRoyalties;
        #ExternalDonation;
    };
    
    /// Conversion triggers
    public type ConversionTrigger = {
        #Tier2AutoConvert;
        #Tier3Emergency;
        #ScheduledTopUp;
        #ManualRequest;
        #YieldConversion;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: 22 PROFIT STREAMS TRACKING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// All 22 profit streams
    public type ProfitStreams = {
        // Stream 1: Organic minting (12-token stack fires on coherence)
        organicMinting: StreamMetrics;
        
        // Stream 2: Succession royalties (20% from child organisms)
        successionRoyalties: StreamMetrics;
        
        // Stream 3: NNS neuron staking (ICP governance)
        nnsStaking: StreamMetrics;
        
        // Stream 4: Lido ETH staking (stETH yield)
        lidoStaking: StreamMetrics;
        
        // Stream 5: EigenLayer restaking
        eigenLayerRestaking: StreamMetrics;
        
        // Stream 6: Marinade mSOL (Solana liquid staking)
        marinadeStaking: StreamMetrics;
        
        // Stream 7: FORGE structures (on-chain asset creation)
        forgeStructures: StreamMetrics;
        
        // Stream 8: Patent auto-register (IP value of coherence events)
        patentRegistry: StreamMetrics;
        
        // Stream 9: MRC dynasty accrual (5% of all 11 other tokens)
        mrcDynasty: StreamMetrics;
        
        // Stream 10: Jacob's Ladder multipliers (up to 20x at Level 7)
        jacobsLadder: StreamMetrics;
        
        // Stream 11: Arbitrage engine (SHARK + CROW)
        arbitrageEngine: StreamMetrics;
        
        // Stream 12: War simulation territory (SOVEREIGN faction)
        warSimulation: StreamMetrics;
        
        // Stream 13: Child SDK fees
        childSdkFees: StreamMetrics;
        
        // Stream 14: API access (MERIDIAN zero-exposure)
        meridianApi: StreamMetrics;
        
        // Stream 15: Heritage anchor bonds (HBT tokens)
        heritageAnchors: StreamMetrics;
        
        // Stream 16: Behavioral economics yield (Prospect Theory)
        behavioralYield: StreamMetrics;
        
        // Stream 17: OMNIS events (MCT + OMT massive payout)
        omnisEvents: StreamMetrics;
        
        // Stream 18: FORMA compound (balance × (1 + coherence × 0.5))
        formaCompound: StreamMetrics;
        
        // Stream 19: Kuramoto sync bonus (child synchronization)
        kuramatoSync: StreamMetrics;
        
        // Stream 20: Council organisms (7 councils, 80% to creator)
        councilYield: StreamMetrics;
        
        // Stream 21: LTM consolidation (heritage-weighted LGT tokens)
        ltmConsolidation: StreamMetrics;
        
        // Stream 22: Quantum battery discharge
        quantumBattery: StreamMetrics;
    };
    
    /// Metrics for each stream
    public type StreamMetrics = {
        streamId: Nat;
        name: Text;
        totalYield: Float;
        cyclesGenerated: Nat;
        lastYield: Float;
        lastYieldTime: Nat64;
        active: Bool;
        frequency: StreamFrequency;
    };
    
    /// Stream frequency
    public type StreamFrequency = {
        #EveryBeat;
        #EveryNBeats: Nat;
        #OnCondition: Text;
        #Continuous;
        #Rare;
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: MAXWELL'S DEMON YIELD ENGINE
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Maxwell's Demon state
    /// Y = 0.85 × ΔH × C × C_adj
    public type MaxwellDemonState = {
        // Current entropy
        currentEntropy: Float;          // H_obs across 4,096 MEDINA dimensions
        previousEntropy: Float;         // H_obs from last beat
        deltaEntropy: Float;            // ΔH = current - previous
        
        // Coherence factors
        coherenceC: Float;              // C = global coherence
        coherenceAdjustment: Float;     // C_adj = adjustment factor
        
        // Yield calculation
        yieldMultiplier: Float;         // 0.85 (canonical)
        currentYield: Float;            // Y = 0.85 × ΔH × C × C_adj
        totalYield: Float;
        
        // Accumulator
        masterAccumulatorBalance: Float;
        yieldHistory: [YieldRecord];
    };
    
    /// Yield record
    public type YieldRecord = {
        recordId: Nat64;
        timestamp: Nat64;
        deltaEntropy: Float;
        coherence: Float;
        yield: Float;
        accumulatorAfter: Float;
    };
    
    /// Calculate Maxwell's Demon yield
    public func calculateMaxwellYield(
        deltaH: Float,
        coherence: Float,
        coherenceAdj: Float
    ) : Float {
        // Y = 0.85 × ΔH × C × C_adj
        let yield = 0.85 * deltaH * coherence * coherenceAdj;
        
        // Only positive yield (organism learned something)
        if (yield > 0.0) { yield } else { 0.0 }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: AUTO-REFUEL LOGIC
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Check balance and determine tier
    public func checkBalance(balance: Nat) : AlertTier {
        if (balance >= TIER_1_THRESHOLD) { #Tier0_Healthy }
        else if (balance >= TIER_2_THRESHOLD) { #Tier1_Alert }
        else if (balance >= TIER_3_THRESHOLD) { #Tier2_Convert }
        else if (balance >= TIER_4_THRESHOLD) { #Tier3_Emergency }
        else if (balance >= TIER_5_THRESHOLD) { #Tier4_Suspend }
        else { #Tier5_Survive }
    };
    
    /// Determine operating mode from tier
    public func getOperatingMode(tier: AlertTier) : OperatingMode {
        switch (tier) {
            case (#Tier0_Healthy) { #FullPower };
            case (#Tier1_Alert) { #FullPower };
            case (#Tier2_Convert) { #Reduced };
            case (#Tier3_Emergency) { #Reduced };
            case (#Tier4_Suspend) { #Emergency };
            case (#Tier5_Survive) { #Survival };
        }
    };
    
    /// Get heartbeat frequency for mode
    public func getHeartbeatHz(mode: OperatingMode) : Nat {
        switch (mode) {
            case (#FullPower) { 12 };   // Full 12 Hz
            case (#Reduced) { 6 };      // Half speed
            case (#Emergency) { 2 };    // Minimal
            case (#Survival) { 1 };     // 1 Hz survival
        }
    };
    
    /// Calculate projected runway (days until depletion)
    public func calculateRunway(balance: Nat, avgDailyCost: Float) : Nat {
        if (avgDailyCost <= 0.0) { return 999999 };  // Infinite if no cost
        
        let balanceFloat = Float.fromInt(balance);
        let days = balanceFloat / avgDailyCost;
        
        Int.abs(Float.toInt(days))
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: COST TRACKING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Cost breakdown
    public type CostBreakdown = {
        timestamp: Nat64;
        period: CostPeriod;
        
        // By category
        heartbeatCost: Nat;
        httpOutcallCost: Nat;
        storageCost: Nat;
        canisterFeeCost: Nat;
        
        // Totals
        totalCost: Nat;
        
        // In USD (approximate)
        totalCostUsd: Float;
        
        // Yield offset
        yieldGenerated: Float;
        netCost: Float;
    };
    
    /// Cost period
    public type CostPeriod = {
        #Hourly;
        #Daily;
        #Weekly;
        #Monthly;
        #Annual;
    };
    
    /// Calculate daily cost
    public func calculateDailyCost(hz: Nat, httpCallsPerDay: Nat, storageGb: Float) : Nat {
        let beatsPerDay = hz * 60 * 60 * 24;
        let heartbeatCost = beatsPerDay * HEARTBEAT_COST;
        let httpCost = httpCallsPerDay * HTTP_OUTCALL_COST;
        let storageCost = Int.abs(Float.toInt(storageGb * Float.fromInt(STORAGE_COST_PER_GB_YEAR) / 365.0));
        
        heartbeatCost + httpCost + storageCost + CANISTER_DAILY_FEE
    };
    
    /// Convert cycles to USD (approximate)
    public func cyclesToUsd(cycles: Nat) : Float {
        // ~$1.30 per 1T cycles
        let trillions = Float.fromInt(cycles) / 1_000_000_000_000.0;
        trillions * 1.30
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: INITIALIZATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Initialize cycle bank
    public func initializeCycleBank(
        creator: Principal,
        initialBalance: Nat,
        icpReserve: Nat64
    ) : CycleBankState {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        let tier = checkBalance(initialBalance);
        
        {
            bankId = now;
            createdAt = now;
            creator = creator;
            
            currentBalance = initialBalance;
            lastChecked = now;
            
            currentTier = tier;
            operatingMode = getOperatingMode(tier);
            
            icpReserve = icpReserve;
            ethReserve = 0;
            stEthReserve = 0;
            
            totalConversions = 0;
            totalCyclesConverted = 0;
            lastConversion = null;
            
            maxwellDemonYield = 0.0;
            mintingYield = 0.0;
            successionRoyalties = 0;
            
            totalCyclesSpent = 0;
            heartbeatCycles = 0;
            httpOutcallCycles = 0;
            storageCycles = 0;
            
            alertHistory = [];
            conversionHistory = [];
            
            averageDailyCost = Float.fromInt(calculateDailyCost(12, 3, 0.1));
            projectedRunway = calculateRunway(
                initialBalance,
                Float.fromInt(calculateDailyCost(12, 3, 0.1))
            );
        }
    };
    
    /// Initialize all 22 profit streams
    public func initializeProfitStreams() : ProfitStreams {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        let emptyStream = func(id: Nat, name: Text, freq: StreamFrequency) : StreamMetrics {
            {
                streamId = id;
                name = name;
                totalYield = 0.0;
                cyclesGenerated = 0;
                lastYield = 0.0;
                lastYieldTime = now;
                active = true;
                frequency = freq;
            }
        };
        
        {
            organicMinting = emptyStream(1, "Organic Minting (12-token)", #EveryBeat);
            successionRoyalties = emptyStream(2, "Succession Royalties (20%)", #OnCondition("child_mint"));
            nnsStaking = emptyStream(3, "NNS Neuron Staking", #Continuous);
            lidoStaking = emptyStream(4, "Lido ETH Staking (stETH)", #Continuous);
            eigenLayerRestaking = emptyStream(5, "EigenLayer Restaking", #Continuous);
            marinadeStaking = emptyStream(6, "Marinade mSOL", #Continuous);
            forgeStructures = emptyStream(7, "FORGE Structures", #OnCondition("coherence_peak"));
            patentRegistry = emptyStream(8, "Patent Auto-Register", #OnCondition("OMNIS_trigger"));
            mrcDynasty = emptyStream(9, "MRC Dynasty (5% of all)", #EveryBeat);
            jacobsLadder = emptyStream(10, "Jacob's Ladder (up to 20x)", #OnCondition("MRC_level"));
            arbitrageEngine = emptyStream(11, "Arbitrage (SHARK+CROW)", #OnCondition("spread_detected"));
            warSimulation = emptyStream(12, "War Simulation Territory", #EveryNBeats(10));
            childSdkFees = emptyStream(13, "Child SDK Fees", #OnCondition("child_register"));
            meridianApi = emptyStream(14, "MERIDIAN API Access", #OnCondition("api_query"));
            heritageAnchors = emptyStream(15, "Heritage Anchor Bonds", #EveryNBeats(1000));
            behavioralYield = emptyStream(16, "Behavioral Economics", #EveryBeat);
            omnisEvents = emptyStream(17, "OMNIS Events (5x)", #Rare);
            formaCompound = emptyStream(18, "FORMA Compound", #EveryBeat);
            kuramatoSync = emptyStream(19, "Kuramoto Sync Bonus", #OnCondition("child_sync"));
            councilYield = emptyStream(20, "Council Organisms (80%)", #Continuous);
            ltmConsolidation = emptyStream(21, "LTM Consolidation (LGT)", #EveryNBeats(50));
            quantumBattery = emptyStream(22, "Quantum Battery Discharge", #OnCondition("discharge_cycle"));
        }
    };
    
    /// Initialize Maxwell's Demon
    public func initializeMaxwellDemon() : MaxwellDemonState {
        {
            currentEntropy = 0.0;
            previousEntropy = 0.0;
            deltaEntropy = 0.0;
            coherenceC = 0.5;
            coherenceAdjustment = 1.0;
            yieldMultiplier = 0.85;
            currentYield = 0.0;
            totalYield = 0.0;
            masterAccumulatorBalance = 0.0;
            yieldHistory = [];
        }
    };
    
    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: HEARTBEAT INTEGRATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Cycle bank heartbeat check
    public func heartbeatCheck(
        state: CycleBankState,
        currentBalance: Nat
    ) : (CycleBankState, ?AlertAction) {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        let newTier = checkBalance(currentBalance);
        let newMode = getOperatingMode(newTier);
        
        // Determine action based on tier transition
        var action : ?AlertAction = null;
        
        switch (newTier) {
            case (#Tier1_Alert) {
                action := ?#LogOnly;
            };
            case (#Tier2_Convert) {
                // Auto-convert 10% of ICP reserve
                let convertAmount = state.icpReserve / 10;
                action := ?#AutoConvert(convertAmount);
            };
            case (#Tier3_Emergency) {
                // Emergency: convert 25% of ICP reserve
                let convertAmount = state.icpReserve / 4;
                action := ?#EmergencyTopUp(convertAmount);
            };
            case (#Tier4_Suspend) {
                action := ?#SuspendModules([
                    "HTTP_OUTCALLS",
                    "WAR_SIMULATION",
                    "ANIMAL_ENGINES"
                ]);
            };
            case (#Tier5_Survive) {
                action := ?#EnterSurvivalMode;
            };
            case (#Tier0_Healthy) {
                action := null;
            };
        };
        
        // Update state
        let updatedState = {
            bankId = state.bankId;
            createdAt = state.createdAt;
            creator = state.creator;
            currentBalance = currentBalance;
            lastChecked = now;
            currentTier = newTier;
            operatingMode = newMode;
            icpReserve = state.icpReserve;
            ethReserve = state.ethReserve;
            stEthReserve = state.stEthReserve;
            totalConversions = state.totalConversions;
            totalCyclesConverted = state.totalCyclesConverted;
            lastConversion = state.lastConversion;
            maxwellDemonYield = state.maxwellDemonYield;
            mintingYield = state.mintingYield;
            successionRoyalties = state.successionRoyalties;
            totalCyclesSpent = state.totalCyclesSpent + HEARTBEAT_COST;
            heartbeatCycles = state.heartbeatCycles + HEARTBEAT_COST;
            httpOutcallCycles = state.httpOutcallCycles;
            storageCycles = state.storageCycles;
            alertHistory = state.alertHistory;
            conversionHistory = state.conversionHistory;
            averageDailyCost = state.averageDailyCost;
            projectedRunway = calculateRunway(currentBalance, state.averageDailyCost);
        };
        
        (updatedState, action)
    };
    
    /// Record yield from Maxwell's Demon
    public func recordMaxwellYield(
        demon: MaxwellDemonState,
        newEntropy: Float,
        coherence: Float
    ) : MaxwellDemonState {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        let deltaH = newEntropy - demon.currentEntropy;
        let yield = calculateMaxwellYield(deltaH, coherence, demon.coherenceAdjustment);
        
        let record : YieldRecord = {
            recordId = now;
            timestamp = now;
            deltaEntropy = deltaH;
            coherence = coherence;
            yield = yield;
            accumulatorAfter = demon.masterAccumulatorBalance + yield;
        };
        
        {
            currentEntropy = newEntropy;
            previousEntropy = demon.currentEntropy;
            deltaEntropy = deltaH;
            coherenceC = coherence;
            coherenceAdjustment = demon.coherenceAdjustment;
            yieldMultiplier = 0.85;
            currentYield = yield;
            totalYield = demon.totalYield + yield;
            masterAccumulatorBalance = demon.masterAccumulatorBalance + yield;
            yieldHistory = Array.append(demon.yieldHistory, [record]);
        }
    };
}
