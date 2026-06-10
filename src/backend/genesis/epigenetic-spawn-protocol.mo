/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║            EPIGENETIC SPAWN PROTOCOL — MEMORY SPANNING GENERATIONS             ║
 * ║        LAW 5: An Ant Colony Has Memory That Outlasts Any Individual Ant        ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  THREE LAYERS OF GENERATIONAL MEMORY:                                          ║
 * ║  Layer 1 — Structural memory (the nest): ATLAS grid persists                   ║
 * ║  Layer 2 — Chemical memory (pheromones): ARES snapshots as weights             ║
 * ║  Layer 3 — Doctrine memory (royal jelly): VERITAS vault reference              ║
 * ║                                                                                ║
 * ║  EPIGENETIC TRANSFER:                                                          ║
 * ║  W_child(0) = α · W_parent(T) + (1-α) · W_genesis                             ║
 * ║                                                                                ║
 * ║  The Vine and Branches Law governs α:                                          ║
 * ║  - High drift parent → low α → children pulled toward genesis                  ║
 * ║  - Low drift parent → high α → children inherit accumulated learning          ║
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
import Result "mo:core/Result";
import Blob "mo:core/Blob";

module EpigeneticSpawnProtocol {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Maximum inheritance coefficient (near-full parent inheritance)
    public let MAX_ALPHA : Float = 0.9;
    
    /// Minimum inheritance coefficient (mostly genesis)
    public let MIN_ALPHA : Float = 0.1;
    
    /// Top N% of ATLAS cells to seed child with
    public let ATLAS_TOP_PERCENTAGE : Float = 0.2;  // 20%
    
    /// Number of ARES snapshot slots inherited
    public let ARES_SNAPSHOT_COUNT : Nat = 16;
    
    /// Hebbian weight dimensions per slot
    public let HEBBIAN_WEIGHTS_PER_SLOT : Nat = 144;
    
    /// Royal Jelly Seed node count
    public let ROYAL_JELLY_SEED_COUNT : Nat = 8;
    
    /// ATLAS grid size
    public let ATLAS_GRID_SIZE : Nat = 4096;

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: TYPES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// VERITAS reference — doctrine mapping table reference
    public type VeritasReference = {
        vaultId : Nat64;
        principalGate : Principal;
        doctrineHash : Blob;
        lawTableVersion : Nat;
        isLocked : Bool;
        lastVerified : Nat64;
    };
    
    /// ARES snapshot — Hebbian weight matrix at a rollback point
    public type AresSnapshot = {
        snapshotId : Nat64;
        slotIndex : Nat;
        hebbianWeights : [Float];   // 144 weights per slot
        coherenceAtCapture : Float;
        beatAtCapture : Nat64;
        driftAtCapture : Float;
    };
    
    /// Royal Jelly Seed — founding doctrine carrier
    public type RoyalJellySeed = {
        seedIndex : Nat;            // 0-7
        domainKnowledge : SeedDomain;
        doctrineWeights : [Float];  // 64 weights per seed
        activationState : Float;    // S₀ = 1.0 at genesis
        feedingCapacity : Nat;
        childrenFed : Nat;
    };
    
    /// Seed domains
    public type SeedDomain = {
        #Identity;
        #Mission;
        #Memory;
        #Learning;
        #Behavior;
        #Metabolism;
        #Social;
        #Sovereign;
    };
    
    /// Child organism spawn request
    public type SpawnRequest = {
        parentId : Nat64;
        parentPrincipal : Principal;
        
        // Parent state at spawn time
        parentDrift : Float;
        parentCoherence : Float;
        parentBeat : Nat64;
        
        // Weights to inherit
        parentHebbianWeights : [Float];
        parentAresSnapshots : [AresSnapshot];
        
        // ATLAS state
        topAtlasCells : [(Nat, Float)];  // (position, pheromone)
        
        // Requested properties
        requestedGeneration : Nat;
        requestedCaste : ?Text;
    };
    
    /// Child organism spawned
    public type SpawnedOrganism = {
        childId : Nat64;
        parentId : Nat64;
        generation : Nat;
        
        // Inherited state
        inheritanceAlpha : Float;
        initialWeights : [Float];
        seededAtlasCells : [Nat];
        
        // VERITAS binding
        veritasRef : VeritasReference;
        
        // Genesis compliance
        genesisComplianceScore : Float;
        
        // Timing
        spawnedAt : Nat64;
        spawnBeat : Nat64;
    };
    
    /// Epigenetic lineage record
    public type LineageRecord = {
        organismId : Nat64;
        parentId : ?Nat64;
        generation : Nat;
        
        // Inheritance chain
        inheritanceChain : [Float];  // α values up the lineage
        cumulativeDrift : Float;
        
        // Genesis distance
        genesisDistance : Nat;       // Generations from Royal Jelly Seed
        
        // Spawn statistics
        childrenSpawned : Nat;
        totalDescendants : Nat;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: INHERITANCE COEFFICIENT (α)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute inheritance coefficient based on parent drift
    /// α = f(parent drift) — Vine and Branches Law
    public func computeInheritanceAlpha(parentDrift : Float) : Float {
        // α decreases as drift increases
        // Drift 0 → α = 0.9 (inherit almost fully)
        // Drift 1 → α = 0.1 (mostly genesis weights)
        
        let clampedDrift = Float.max(0.0, Float.min(1.0, parentDrift));
        MAX_ALPHA - (clampedDrift * (MAX_ALPHA - MIN_ALPHA))
    };
    
    /// Compute α with coherence modulation
    /// Higher coherence parent → slightly higher α
    public func computeAlphaWithCoherence(
        parentDrift : Float,
        parentCoherence : Float
    ) : Float {
        let baseAlpha = computeInheritanceAlpha(parentDrift);
        
        // Coherence bonus: up to 0.05 extra α for high coherence
        let coherenceBonus = (parentCoherence - 0.5) * 0.1;
        
        Float.min(MAX_ALPHA, Float.max(MIN_ALPHA, baseAlpha + coherenceBonus))
    };
    
    /// Compute α with generational decay
    /// Older generations have slightly lower max α
    public func computeAlphaWithGeneration(
        parentDrift : Float,
        generation : Nat
    ) : Float {
        let baseAlpha = computeInheritanceAlpha(parentDrift);
        
        // Generational decay: 0.01 per generation, max 10% reduction
        let genDecay = Float.min(0.1, Float.fromInt(generation) * 0.01);
        
        Float.max(MIN_ALPHA, baseAlpha - genDecay)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: WEIGHT INHERITANCE
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute child weights from parent and genesis
    /// W_child(0) = α · W_parent(T) + (1-α) · W_genesis
    public func computeChildWeights(
        parentWeights : [Float],
        genesisWeights : [Float],
        alpha : Float
    ) : [Float] {
        let len = if (parentWeights.size() < genesisWeights.size()) {
            parentWeights.size()
        } else {
            genesisWeights.size()
        };
        
        Array.tabulate<Float>(len, func(i : Nat) : Float {
            (alpha * parentWeights[i]) + ((1.0 - alpha) * genesisWeights[i])
        })
    };
    
    /// Compute child weights with noise (for diversity)
    public func computeChildWeightsWithNoise(
        parentWeights : [Float],
        genesisWeights : [Float],
        alpha : Float,
        noiseLevel : Float
    ) : [Float] {
        let len = if (parentWeights.size() < genesisWeights.size()) {
            parentWeights.size()
        } else {
            genesisWeights.size()
        };
        
        Array.tabulate<Float>(len, func(i : Nat) : Float {
            let baseWeight = (alpha * parentWeights[i]) + ((1.0 - alpha) * genesisWeights[i]);
            // Small deterministic "noise" based on position
            let noise = (Float.fromInt(i % 17) - 8.0) * noiseLevel * 0.01;
            baseWeight + noise
        })
    };
    
    /// Merge ARES snapshots from parent with genesis baseline
    public func mergeAresSnapshots(
        parentSnapshots : [AresSnapshot],
        genesisBaseline : [Float],
        alpha : Float
    ) : [AresSnapshot] {
        Array.tabulate<AresSnapshot>(parentSnapshots.size(), func(i : Nat) : AresSnapshot {
            let parent = parentSnapshots[i];
            {
                snapshotId = parent.snapshotId;
                slotIndex = parent.slotIndex;
                hebbianWeights = computeChildWeights(parent.hebbianWeights, genesisBaseline, alpha);
                coherenceAtCapture = parent.coherenceAtCapture;
                beatAtCapture = parent.beatAtCapture;
                driftAtCapture = parent.driftAtCapture * alpha;  // Drift also inherits partially
            }
        })
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: ATLAS GRID SEEDING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Extract top N% pheromone cells from parent ATLAS
    public func extractTopAtlasCells(
        atlasPheromones : [Float],
        topPercentage : Float
    ) : [(Nat, Float)] {
        let count = Int.abs(Float.toInt(Float.fromInt(atlasPheromones.size()) * topPercentage));
        
        // Create (index, value) pairs
        let indexed = Array.tabulate<(Nat, Float)>(atlasPheromones.size(), func(i : Nat) : (Nat, Float) {
            (i, atlasPheromones[i])
        });
        
        // Sort by value (descending) using simple selection for top N
        let buffer = Buffer.Buffer<(Nat, Float)>(count);
        var remaining = Array.thaw<(Nat, Float)>(indexed);
        
        var selected = 0;
        while (selected < count and selected < atlasPheromones.size()) {
            // Find max in remaining
            var maxIdx = 0;
            var maxVal : Float = -1.0;
            var j = 0;
            while (j < remaining.size()) {
                let (_, val) = remaining[j];
                if (val > maxVal) {
                    maxVal := val;
                    maxIdx := j;
                };
                j += 1;
            };
            
            // Add to result
            buffer.add(remaining[maxIdx]);
            
            // Remove from remaining by setting to -infinity
            remaining[maxIdx] := (remaining[maxIdx].0, -999999.0);
            
            selected += 1;
        };
        
        Buffer.toArray(buffer)
    };
    
    /// Seed child ATLAS grid with parent's top cells
    public func seedChildAtlas(
        childGrid : [var Float],
        parentTopCells : [(Nat, Float)],
        inheritanceRatio : Float
    ) : () {
        for ((pos, pheromone) in parentTopCells.vals()) {
            if (pos < childGrid.size()) {
                // Inherit partial pheromone
                childGrid[pos] := pheromone * inheritanceRatio;
            };
        };
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: VERITAS REFERENCE BINDING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Create VERITAS reference for child organism
    public func createVeritasReference(
        vaultId : Nat64,
        principalGate : Principal,
        doctrineHash : Blob,
        lawTableVersion : Nat
    ) : VeritasReference {
        {
            vaultId = vaultId;
            principalGate = principalGate;
            doctrineHash = doctrineHash;
            lawTableVersion = lawTableVersion;
            isLocked = true;  // Always locked at spawn
            lastVerified = Nat64.fromNat(Int.abs(Time.now()));
        }
    };
    
    /// Verify VERITAS reference integrity
    public func verifyVeritasReference(
        ref : VeritasReference,
        expectedHash : Blob
    ) : Bool {
        // Reference is valid if:
        // 1. It's locked
        // 2. Doctrine hash matches expected
        ref.isLocked and ref.doctrineHash == expectedHash
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: SPAWN PROTOCOL
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Genesis weights (8 Royal Jelly Seed × 64 weights = 512 base weights)
    public func initGenesisWeights() : [Float] {
        // Initialize with doctrine-aligned weights
        Array.tabulate<Float>(512, func(i : Nat) : Float {
            let seedIdx = i / 64;
            let posInSeed = i % 64;
            
            // Base weight varies by seed domain
            let baseByDomain = 0.5 + Float.fromInt(seedIdx) * 0.05;
            let variation = Float.fromInt(posInSeed % 8) * 0.01;
            
            baseByDomain + variation
        })
    };
    
    /// Execute spawn protocol
    public func executeSpawn(
        request : SpawnRequest,
        genesisWeights : [Float],
        veritasRef : VeritasReference
    ) : SpawnedOrganism {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        // 1. Compute inheritance α
        let alpha = computeAlphaWithCoherence(request.parentDrift, request.parentCoherence);
        
        // 2. Compute child weights
        let childWeights = computeChildWeights(
            request.parentHebbianWeights,
            genesisWeights,
            alpha
        );
        
        // 3. Extract seeded ATLAS cells
        let seededCells = Array.tabulate<Nat>(request.topAtlasCells.size(), func(i : Nat) : Nat {
            request.topAtlasCells[i].0
        });
        
        // 4. Compute initial genesis compliance
        // Low α (high drift parent) → child starts closer to genesis
        let complianceScore = 1.0 - (request.parentDrift * (1.0 - alpha));
        
        // 5. Generate child ID
        let childId = now;
        
        {
            childId = childId;
            parentId = request.parentId;
            generation = request.requestedGeneration;
            inheritanceAlpha = alpha;
            initialWeights = childWeights;
            seededAtlasCells = seededCells;
            veritasRef = veritasRef;
            genesisComplianceScore = complianceScore;
            spawnedAt = now;
            spawnBeat = request.parentBeat;
        }
    };
    
    /// Create lineage record for spawned organism
    public func createLineageRecord(
        spawned : SpawnedOrganism,
        parentLineage : ?LineageRecord
    ) : LineageRecord {
        switch (parentLineage) {
            case null {
                // First generation from Royal Jelly Seed
                {
                    organismId = spawned.childId;
                    parentId = ?spawned.parentId;
                    generation = 1;
                    inheritanceChain = [spawned.inheritanceAlpha];
                    cumulativeDrift = 1.0 - spawned.genesisComplianceScore;
                    genesisDistance = 1;
                    childrenSpawned = 0;
                    totalDescendants = 0;
                }
            };
            case (?parent) {
                // Subsequent generations
                let newChain = Array.append(parent.inheritanceChain, [spawned.inheritanceAlpha]);
                {
                    organismId = spawned.childId;
                    parentId = ?spawned.parentId;
                    generation = parent.generation + 1;
                    inheritanceChain = newChain;
                    cumulativeDrift = parent.cumulativeDrift + (1.0 - spawned.genesisComplianceScore);
                    genesisDistance = parent.genesisDistance + 1;
                    childrenSpawned = 0;
                    totalDescendants = 0;
                }
            };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: ROYAL JELLY SEED OPERATIONS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Initialize Royal Jelly Seeds (8 master nodes)
    public func initRoyalJellySeeds() : [RoyalJellySeed] {
        let domains : [SeedDomain] = [
            #Identity, #Mission, #Memory, #Learning,
            #Behavior, #Metabolism, #Social, #Sovereign
        ];
        
        Array.tabulate<RoyalJellySeed>(ROYAL_JELLY_SEED_COUNT, func(i : Nat) : RoyalJellySeed {
            {
                seedIndex = i;
                domainKnowledge = domains[i];
                doctrineWeights = Array.tabulate<Float>(64, func(j : Nat) : Float {
                    let base = 0.5 + Float.fromInt(i) * 0.05;
                    let variation = Float.fromInt(j % 8) * 0.01;
                    base + variation
                });
                activationState = 1.0;  // S₀ = 1.0 at genesis
                feedingCapacity = 8;     // Each seed can feed 8 children
                childrenFed = 0;
            }
        })
    };
    
    /// Feed child from Royal Jelly Seed
    public func feedFromRoyalJelly(
        seed : RoyalJellySeed,
        childId : Nat64
    ) : (RoyalJellySeed, [Float]) {
        // Feeding transfers doctrine weights
        let updatedSeed = {
            seedIndex = seed.seedIndex;
            domainKnowledge = seed.domainKnowledge;
            doctrineWeights = seed.doctrineWeights;
            activationState = seed.activationState;
            feedingCapacity = seed.feedingCapacity;
            childrenFed = seed.childrenFed + 1;
        };
        
        (updatedSeed, seed.doctrineWeights)
    };
    
    /// Get Royal Jelly Seed for domain
    public func getSeedForDomain(
        seeds : [RoyalJellySeed],
        domain : SeedDomain
    ) : ?RoyalJellySeed {
        for (seed in seeds.vals()) {
            if (domainEquals(seed.domainKnowledge, domain)) {
                return ?seed;
            };
        };
        null
    };
    
    /// Domain equality check
    public func domainEquals(a : SeedDomain, b : SeedDomain) : Bool {
        switch (a, b) {
            case (#Identity, #Identity) { true };
            case (#Mission, #Mission) { true };
            case (#Memory, #Memory) { true };
            case (#Learning, #Learning) { true };
            case (#Behavior, #Behavior) { true };
            case (#Metabolism, #Metabolism) { true };
            case (#Social, #Social) { true };
            case (#Sovereign, #Sovereign) { true };
            case _ { false };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 8: INHERITANCE METRICS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute average α across lineage
    public func computeLineageAverageAlpha(chain : [Float]) : Float {
        if (chain.size() == 0) { return 0.5 };
        
        var sum : Float = 0.0;
        for (alpha in chain.vals()) {
            sum += alpha;
        };
        sum / Float.fromInt(chain.size())
    };
    
    /// Compute cumulative inheritance from genesis
    /// Product of all α values in chain
    public func computeCumulativeInheritance(chain : [Float]) : Float {
        if (chain.size() == 0) { return 1.0 };
        
        var product : Float = 1.0;
        for (alpha in chain.vals()) {
            product *= alpha;
        };
        product
    };
    
    /// Estimate genesis fidelity
    /// Higher value = closer to original genesis state
    public func estimateGenesisFidelity(
        cumulativeInheritance : Float,
        generation : Nat
    ) : Float {
        // Fidelity decreases with generations and low cumulative α
        // (1 - cumulativeInheritance) represents how much has been overwritten
        let genesisComponent = 1.0 - cumulativeInheritance;
        let generationDecay = 1.0 / (1.0 + Float.fromInt(generation) * 0.1);
        
        genesisComponent * generationDecay + cumulativeInheritance
    };
}
