/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║           GENERATIONAL MEMORY ENGINE — MEMORY SPANNING GENERATIONS             ║
 * ║         LAW 5: The Nest Architecture IS The Memory — Knowledge Persists        ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  THREE MEMORY LAYERS:                                                           ║
 * ║  Layer 1 — Structural (ATLAS grid persists across heartbeats)                  ║
 * ║  Layer 2 — Chemical (ARES snapshot slots, Hebbian weight inheritance)          ║
 * ║  Layer 3 — Doctrine (VERITAS vault reference, immutable covenant)              ║
 * ║                                                                                ║
 * ║  GENERATIONAL TRACKING:                                                         ║
 * ║  - Per-generation ARES snapshot chain                                          ║
 * ║  - Colony-wide Hebbian history                                                  ║
 * ║  - Epigenetic transfer logs                                                    ║
 * ║  - Lineage-indexed memory retrieval                                            ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 */

import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Blob "mo:core/Blob";

module GenerationalMemoryEngine {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Maximum generation depth to track
    public let MAX_GENERATION_DEPTH : Nat = 100;
    
    /// ARES snapshot slots per organism
    public let ARES_SLOTS_PER_ORGANISM : Nat = 16;
    
    /// Hebbian weights per ARES slot
    public let HEBBIAN_WEIGHTS_PER_SLOT : Nat = 144;
    
    /// Colony history buffer size (beats)
    public let COLONY_HISTORY_SIZE : Nat = 1000;
    
    /// Episodic memory ring size
    public let EPISODIC_RING_SIZE : Nat = 200;
    
    /// Memory consolidation threshold (coherence)
    public let CONSOLIDATION_THRESHOLD : Float = 0.7;

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: TYPES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// ARES snapshot — Hebbian weights at a rollback point
    public type AresSnapshot = {
        snapshotId : Nat64;
        slotIndex : Nat;
        
        // Hebbian weight matrix
        hebbianWeights : [Float];
        
        // Capture metadata
        coherenceAtCapture : Float;
        beatAtCapture : Nat64;
        driftAtCapture : Float;
        
        // What triggered the snapshot
        captureReason : SnapshotReason;
    };
    
    /// Reason for snapshot capture
    public type SnapshotReason = {
        #Scheduled;          // Regular interval snapshot
        #HighCoherence;      // Coherence spike
        #Quorum;             // Quorum event
        #Omnis;              // OMNIS emergence
        #Spawn;              // Child organism spawned
        #Correction;         // Jasmine correction
        #Manual;             // Manual trigger
    };
    
    /// Generational snapshot chain
    public type GenerationChain = {
        generation : Nat;
        organismId : Nat64;
        parentId : ?Nat64;
        
        // ARES snapshots for this generation
        snapshots : [AresSnapshot];
        
        // Inheritance info
        inheritanceAlpha : Float;
        parentSnapshotId : ?Nat64;
        
        // Timing
        createdAt : Nat64;
        lastUpdated : Nat64;
    };
    
    /// Epigenetic transfer record
    public type EpigeneticTransfer = {
        transferId : Nat64;
        
        // Lineage
        parentId : Nat64;
        childId : Nat64;
        generation : Nat;
        
        // What was transferred
        inheritanceAlpha : Float;
        weightsCopied : Nat;
        atlasCellsSeeded : Nat;
        
        // Parent state at transfer
        parentDrift : Float;
        parentCoherence : Float;
        parentBeat : Nat64;
        
        // Child initial state
        childInitialCompliance : Float;
        
        // Timing
        timestamp : Nat64;
    };
    
    /// Colony-wide Hebbian history entry
    public type ColonyHebbianEntry = {
        entryId : Nat64;
        beatNumber : Nat64;
        
        // Colony-wide aggregates
        meanWeightValue : Float;
        weightVariance : Float;
        activeWeightCount : Nat;
        
        // LTP/LTD counts
        ltpEventCount : Nat;
        ltdEventCount : Nat;
        
        // Coherence correlation
        coherenceAtEntry : Float;
        
        // OMNIS correlation
        omnisProximity : Float;  // How close to OMNIS conditions
    };
    
    /// Colony memory state
    public type ColonyMemoryState = {
        colonyId : Nat64;
        
        // Generation tracking
        currentMaxGeneration : Nat;
        totalOrganismsSpawned : Nat64;
        
        // Generation chains
        generationChains : [GenerationChain];
        
        // Epigenetic transfer log
        transferLog : [EpigeneticTransfer];
        
        // Colony Hebbian history
        hebbianHistory : [ColonyHebbianEntry];
        
        // Memory health
        consolidationRate : Float;
        retrievalAccuracy : Float;
        
        // Timing
        lastConsolidation : Nat64;
        currentBeat : Nat64;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: INITIALIZATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Initialize colony memory state
    public func initColonyMemoryState(colonyId : Nat64) : ColonyMemoryState {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            colonyId = colonyId;
            currentMaxGeneration = 0;
            totalOrganismsSpawned = 1;  // Royal Jelly Seed
            generationChains = [];
            transferLog = [];
            hebbianHistory = [];
            consolidationRate = 1.0;
            retrievalAccuracy = 1.0;
            lastConsolidation = now;
            currentBeat = 0;
        }
    };
    
    /// Initialize ARES snapshot
    public func initAresSnapshot(
        slotIndex : Nat,
        weights : [Float],
        coherence : Float,
        beat : Nat64,
        drift : Float,
        reason : SnapshotReason
    ) : AresSnapshot {
        {
            snapshotId = beat;
            slotIndex = slotIndex;
            hebbianWeights = weights;
            coherenceAtCapture = coherence;
            beatAtCapture = beat;
            driftAtCapture = drift;
            captureReason = reason;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: ARES SNAPSHOT MANAGEMENT
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Capture ARES snapshot (16 slots, circular buffer)
    public func captureAresSnapshot(
        existingSnapshots : [AresSnapshot],
        newSnapshot : AresSnapshot
    ) : [AresSnapshot] {
        let buffer = Buffer.Buffer<AresSnapshot>(ARES_SLOTS_PER_ORGANISM);
        
        // Copy existing, skipping oldest if at capacity
        let startIdx = if (existingSnapshots.size() >= ARES_SLOTS_PER_ORGANISM) { 1 } else { 0 };
        var i = startIdx;
        while (i < existingSnapshots.size()) {
            buffer.add(existingSnapshots[i]);
            i += 1;
        };
        
        // Add new snapshot with updated slot index
        let updatedSnapshot = {
            snapshotId = newSnapshot.snapshotId;
            slotIndex = buffer.size();
            hebbianWeights = newSnapshot.hebbianWeights;
            coherenceAtCapture = newSnapshot.coherenceAtCapture;
            beatAtCapture = newSnapshot.beatAtCapture;
            driftAtCapture = newSnapshot.driftAtCapture;
            captureReason = newSnapshot.captureReason;
        };
        buffer.add(updatedSnapshot);
        
        Buffer.toArray(buffer)
    };
    
    /// Find best snapshot for rollback (highest coherence)
    public func findBestSnapshot(snapshots : [AresSnapshot]) : ?AresSnapshot {
        if (snapshots.size() == 0) { return null };
        
        var best : ?AresSnapshot = null;
        var bestCoherence : Float = -1.0;
        
        for (snap in snapshots.vals()) {
            if (snap.coherenceAtCapture > bestCoherence) {
                bestCoherence := snap.coherenceAtCapture;
                best := ?snap;
            };
        };
        
        best
    };
    
    /// Find snapshot by reason
    public func findSnapshotByReason(
        snapshots : [AresSnapshot],
        reason : SnapshotReason
    ) : ?AresSnapshot {
        for (snap in snapshots.vals()) {
            if (reasonEquals(snap.captureReason, reason)) {
                return ?snap;
            };
        };
        null
    };
    
    /// Snapshot reason equality
    public func reasonEquals(a : SnapshotReason, b : SnapshotReason) : Bool {
        switch (a, b) {
            case (#Scheduled, #Scheduled) { true };
            case (#HighCoherence, #HighCoherence) { true };
            case (#Quorum, #Quorum) { true };
            case (#Omnis, #Omnis) { true };
            case (#Spawn, #Spawn) { true };
            case (#Correction, #Correction) { true };
            case (#Manual, #Manual) { true };
            case _ { false };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: GENERATION CHAIN MANAGEMENT
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Create generation chain for new organism
    public func createGenerationChain(
        organismId : Nat64,
        parentId : ?Nat64,
        generation : Nat,
        inheritanceAlpha : Float,
        parentSnapshotId : ?Nat64,
        initialSnapshot : AresSnapshot
    ) : GenerationChain {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            generation = generation;
            organismId = organismId;
            parentId = parentId;
            snapshots = [initialSnapshot];
            inheritanceAlpha = inheritanceAlpha;
            parentSnapshotId = parentSnapshotId;
            createdAt = now;
            lastUpdated = now;
        }
    };
    
    /// Add snapshot to generation chain
    public func addSnapshotToChain(
        chain : GenerationChain,
        snapshot : AresSnapshot
    ) : GenerationChain {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            generation = chain.generation;
            organismId = chain.organismId;
            parentId = chain.parentId;
            snapshots = captureAresSnapshot(chain.snapshots, snapshot);
            inheritanceAlpha = chain.inheritanceAlpha;
            parentSnapshotId = chain.parentSnapshotId;
            createdAt = chain.createdAt;
            lastUpdated = now;
        }
    };
    
    /// Get chain for organism
    public func getChainForOrganism(
        chains : [GenerationChain],
        organismId : Nat64
    ) : ?GenerationChain {
        for (chain in chains.vals()) {
            if (chain.organismId == organismId) {
                return ?chain;
            };
        };
        null
    };
    
    /// Get all chains for a generation
    public func getChainsForGeneration(
        chains : [GenerationChain],
        generation : Nat
    ) : [GenerationChain] {
        let buffer = Buffer.Buffer<GenerationChain>(0);
        for (chain in chains.vals()) {
            if (chain.generation == generation) {
                buffer.add(chain);
            };
        };
        Buffer.toArray(buffer)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: EPIGENETIC TRANSFER LOGGING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Log epigenetic transfer
    public func logEpigeneticTransfer(
        state : ColonyMemoryState,
        parentId : Nat64,
        childId : Nat64,
        generation : Nat,
        alpha : Float,
        weightsCopied : Nat,
        atlasCells : Nat,
        parentDrift : Float,
        parentCoherence : Float,
        parentBeat : Nat64,
        childCompliance : Float
    ) : ColonyMemoryState {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        let transfer : EpigeneticTransfer = {
            transferId = now;
            parentId = parentId;
            childId = childId;
            generation = generation;
            inheritanceAlpha = alpha;
            weightsCopied = weightsCopied;
            atlasCellsSeeded = atlasCells;
            parentDrift = parentDrift;
            parentCoherence = parentCoherence;
            parentBeat = parentBeat;
            childInitialCompliance = childCompliance;
            timestamp = now;
        };
        
        // Add to log (keep last 1000)
        let buffer = Buffer.Buffer<EpigeneticTransfer>(state.transferLog.size() + 1);
        let startIdx = if (state.transferLog.size() >= 1000) { 1 } else { 0 };
        var i = startIdx;
        while (i < state.transferLog.size()) {
            buffer.add(state.transferLog[i]);
            i += 1;
        };
        buffer.add(transfer);
        
        {
            colonyId = state.colonyId;
            currentMaxGeneration = if (generation > state.currentMaxGeneration) { generation } else { state.currentMaxGeneration };
            totalOrganismsSpawned = state.totalOrganismsSpawned + 1;
            generationChains = state.generationChains;
            transferLog = Buffer.toArray(buffer);
            hebbianHistory = state.hebbianHistory;
            consolidationRate = state.consolidationRate;
            retrievalAccuracy = state.retrievalAccuracy;
            lastConsolidation = state.lastConsolidation;
            currentBeat = state.currentBeat;
        }
    };
    
    /// Get transfer history for lineage
    public func getTransferHistoryForLineage(
        transfers : [EpigeneticTransfer],
        organismId : Nat64
    ) : [EpigeneticTransfer] {
        let buffer = Buffer.Buffer<EpigeneticTransfer>(0);
        
        // Find all transfers in lineage (organism as child or parent)
        for (transfer in transfers.vals()) {
            if (transfer.childId == organismId or transfer.parentId == organismId) {
                buffer.add(transfer);
            };
        };
        
        Buffer.toArray(buffer)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: COLONY HEBBIAN HISTORY
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Record colony Hebbian history entry
    public func recordHebbianEntry(
        state : ColonyMemoryState,
        meanWeight : Float,
        variance : Float,
        activeCount : Nat,
        ltpCount : Nat,
        ltdCount : Nat,
        coherence : Float,
        omnisProx : Float,
        beat : Nat64
    ) : ColonyMemoryState {
        let entry : ColonyHebbianEntry = {
            entryId = beat;
            beatNumber = beat;
            meanWeightValue = meanWeight;
            weightVariance = variance;
            activeWeightCount = activeCount;
            ltpEventCount = ltpCount;
            ltdEventCount = ltdCount;
            coherenceAtEntry = coherence;
            omnisProximity = omnisProx;
        };
        
        // Add to history (keep last COLONY_HISTORY_SIZE)
        let buffer = Buffer.Buffer<ColonyHebbianEntry>(state.hebbianHistory.size() + 1);
        let startIdx = if (state.hebbianHistory.size() >= COLONY_HISTORY_SIZE) { 1 } else { 0 };
        var i = startIdx;
        while (i < state.hebbianHistory.size()) {
            buffer.add(state.hebbianHistory[i]);
            i += 1;
        };
        buffer.add(entry);
        
        {
            colonyId = state.colonyId;
            currentMaxGeneration = state.currentMaxGeneration;
            totalOrganismsSpawned = state.totalOrganismsSpawned;
            generationChains = state.generationChains;
            transferLog = state.transferLog;
            hebbianHistory = Buffer.toArray(buffer);
            consolidationRate = state.consolidationRate;
            retrievalAccuracy = state.retrievalAccuracy;
            lastConsolidation = state.lastConsolidation;
            currentBeat = beat;
        }
    };
    
    /// Compute Hebbian trend (LTP vs LTD)
    public func computeHebbianTrend(
        history : [ColonyHebbianEntry],
        windowSize : Nat
    ) : Float {
        if (history.size() == 0) { return 0.0 };
        
        let startIdx = if (history.size() > windowSize) { history.size() - windowSize } else { 0 };
        
        var ltpSum : Nat = 0;
        var ltdSum : Nat = 0;
        
        var i = startIdx;
        while (i < history.size()) {
            ltpSum += history[i].ltpEventCount;
            ltdSum += history[i].ltdEventCount;
            i += 1;
        };
        
        let total = Float.fromInt(ltpSum + ltdSum);
        if (total > 0.0) {
            (Float.fromInt(ltpSum) - Float.fromInt(ltdSum)) / total
        } else {
            0.0
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: MEMORY CONSOLIDATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Consolidate memory (prune low-value entries)
    public func consolidateMemory(
        state : ColonyMemoryState,
        coherenceThreshold : Float,
        beat : Nat64
    ) : ColonyMemoryState {
        // Consolidate Hebbian history — keep high-coherence entries
        let consolidatedHistory = Buffer.Buffer<ColonyHebbianEntry>(0);
        for (entry in state.hebbianHistory.vals()) {
            if (entry.coherenceAtEntry >= coherenceThreshold or 
                entry.omnisProximity >= 0.8) {
                consolidatedHistory.add(entry);
            };
        };
        
        // Update consolidation rate
        let rate = if (state.hebbianHistory.size() > 0) {
            Float.fromInt(consolidatedHistory.size()) / Float.fromInt(state.hebbianHistory.size())
        } else {
            1.0
        };
        
        {
            colonyId = state.colonyId;
            currentMaxGeneration = state.currentMaxGeneration;
            totalOrganismsSpawned = state.totalOrganismsSpawned;
            generationChains = state.generationChains;
            transferLog = state.transferLog;
            hebbianHistory = Buffer.toArray(consolidatedHistory);
            consolidationRate = rate;
            retrievalAccuracy = state.retrievalAccuracy;
            lastConsolidation = beat;
            currentBeat = beat;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 8: LINEAGE-INDEXED RETRIEVAL
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Retrieve memory across lineage
    public type LineageMemory = {
        organismId : Nat64;
        generation : Nat;
        
        // Own snapshots
        ownSnapshots : [AresSnapshot];
        
        // Inherited from parent
        parentContribution : Float;  // α at spawn
        
        // Cumulative from all ancestors
        cumulativeAlpha : Float;     // Product of all α values
        genesisContribution : Float; // 1 - cumulativeAlpha
        
        // Statistics
        totalSnapshotsInLineage : Nat;
        averageCoherence : Float;
    };
    
    /// Build lineage memory for organism
    public func buildLineageMemory(
        chains : [GenerationChain],
        targetOrganism : Nat64
    ) : ?LineageMemory {
        switch (getChainForOrganism(chains, targetOrganism)) {
            case null { return null };
            case (?chain) {
                // Walk up lineage
                var cumulativeAlpha : Float = chain.inheritanceAlpha;
                var totalSnapshots : Nat = chain.snapshots.size();
                var sumCoherence : Float = 0.0;
                var coherenceCount : Nat = 0;
                
                // Sum coherence from own snapshots
                for (snap in chain.snapshots.vals()) {
                    sumCoherence += snap.coherenceAtCapture;
                    coherenceCount += 1;
                };
                
                // Walk up to parent
                var currentParent = chain.parentId;
                while (Option.isSome(currentParent)) {
                    switch (currentParent) {
                        case null { };
                        case (?parentId) {
                            switch (getChainForOrganism(chains, parentId)) {
                                case null { currentParent := null };
                                case (?parentChain) {
                                    cumulativeAlpha *= parentChain.inheritanceAlpha;
                                    totalSnapshots += parentChain.snapshots.size();
                                    
                                    for (snap in parentChain.snapshots.vals()) {
                                        sumCoherence += snap.coherenceAtCapture;
                                        coherenceCount += 1;
                                    };
                                    
                                    currentParent := parentChain.parentId;
                                };
                            };
                        };
                    };
                };
                
                let avgCoherence = if (coherenceCount > 0) {
                    sumCoherence / Float.fromInt(coherenceCount)
                } else {
                    0.0
                };
                
                ?{
                    organismId = targetOrganism;
                    generation = chain.generation;
                    ownSnapshots = chain.snapshots;
                    parentContribution = chain.inheritanceAlpha;
                    cumulativeAlpha = cumulativeAlpha;
                    genesisContribution = 1.0 - cumulativeAlpha;
                    totalSnapshotsInLineage = totalSnapshots;
                    averageCoherence = avgCoherence;
                }
            };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 9: METRICS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Colony memory metrics
    public type MemoryMetrics = {
        totalGenerations : Nat;
        totalOrganisms : Nat64;
        totalSnapshots : Nat;
        totalTransfers : Nat;
        historyEntries : Nat;
        consolidationRate : Float;
        averageInheritanceAlpha : Float;
        hebbianTrend : Float;
    };
    
    /// Get memory metrics
    public func getMemoryMetrics(state : ColonyMemoryState) : MemoryMetrics {
        var totalSnapshots : Nat = 0;
        var alphaSum : Float = 0.0;
        var alphaCount : Nat = 0;
        
        for (chain in state.generationChains.vals()) {
            totalSnapshots += chain.snapshots.size();
            alphaSum += chain.inheritanceAlpha;
            alphaCount += 1;
        };
        
        let avgAlpha = if (alphaCount > 0) { alphaSum / Float.fromInt(alphaCount) } else { 0.5 };
        let trend = computeHebbianTrend(state.hebbianHistory, 100);
        
        {
            totalGenerations = state.currentMaxGeneration;
            totalOrganisms = state.totalOrganismsSpawned;
            totalSnapshots = totalSnapshots;
            totalTransfers = state.transferLog.size();
            historyEntries = state.hebbianHistory.size();
            consolidationRate = state.consolidationRate;
            averageInheritanceAlpha = avgAlpha;
            hebbianTrend = trend;
        }
    };
}
