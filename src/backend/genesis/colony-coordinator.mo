/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║              COLONY COORDINATOR — ANT COLONY INTELLIGENCE LAYER               ║
 * ║        The Seven Laws of Ant Colony Architecture in Computational Form        ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  THE SEVEN LAWS IMPLEMENTED:                                                   ║
 * ║  1. STIGMERGY — Pheromone as Memory (ATLAS grid)                              ║
 * ║  2. QUORUM SENSING — Collective Decision Without a Leader                      ║
 * ║  3. DIVISION OF LABOR — Caste Without Hierarchy                               ║
 * ║  4. FORK-TRAIL OPTIMIZATION — Gradient Descent Without Backpropagation        ║
 * ║  5. MEMORY SPANNING GENERATIONS — Epigenetic State Transfer                   ║
 * ║  6. COLLECTIVE INTELLIGENCE — Emergence Without Understanding                 ║
 * ║  7. THE QUEEN'S SILENCE — Sovereign Without Commanding                        ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 *
 * COLONY ARCHITECTURE:
 * The organism transitions from a single BRAIN canister (7,033 lines) to a
 * distributed colony where N organisms share a stigmergic ATLAS grid.
 *
 * KURAMOTO COLONY COHERENCE:
 * r_colony(t) · e^(iΨ) = (1/N) Σₙ (1/12) Σₖ e^(iθₖ(n,t))
 *
 * where θₖ(n,t) is the phase of Hz node k in organism n at time t.
 * The colony quorum index is the double mean — across nodes inside each
 * organism AND across organisms in the colony.
 */

import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Principal "mo:core/Principal";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";
import Result "mo:core/Result";
import Blob "mo:core/Blob";

module ColonyCoordinator {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // MATHEMATICAL CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    public let PI : Float = 3.14159265358979323846;
    public let TWO_PI : Float = 6.28318530717958647692;
    public let E : Float = 2.71828182845904523536;
    public let PHI : Float = 1.618033988749895;           // Golden ratio
    public let PHI_INVERSE : Float = 0.618033988749895;   // φ⁻¹ - Bach's consciousness threshold
    
    // Colony architecture constants
    public let ATLAS_GRID_SIZE : Nat = 4096;              // 4,096 stigmergic cells
    public let HZ_NODE_COUNT : Nat = 12;                  // 12 Hz nodes per organism
    public let CASTE_COUNT : Nat = 9;                     // 9 animal castes
    
    // Quorum thresholds
    public let QUORUM_EXPLORATION : Float = 0.3;          // r_colony < 0.3 → exploration mode
    public let QUORUM_NEGOTIATION : Float = 0.7;          // 0.3 ≤ r_colony < 0.7 → negotiation mode
    public let QUORUM_COMMITMENT : Float = 0.7;           // r_colony ≥ 0.7 → commitment mode
    public let QUORUM_BRITTLE : Float = 0.95;             // r_colony > 0.95 → Pride Before Fall Law fires
    
    // Pheromone dynamics
    public let PHEROMONE_EVAPORATION : Float = 0.02;      // ρ = evaporation constant (Talent Decay Law)
    public let PHEROMONE_DEPOSIT_BASE : Float = 100.0;    // Q = base deposit constant
    public let FORMA_AMPLIFICATION : Float = 0.5;         // FORMA amplifies pheromone deposit
    
    // ACO optimization constants
    public let ACO_ALPHA : Float = 1.0;                   // Pheromone importance
    public let ACO_BETA : Float = 2.0;                    // Heuristic importance
    public let ACO_RHO : Float = 0.1;                     // Pheromone decay rate
    
    // Frequency bands for ATLAS grid partitioning
    public let DELTA_BAND_END : Nat = 341;                // Positions 0-341: slow, deep structural memory
    public let THETA_BAND_END : Nat = 682;                // Positions 342-682
    public let ALPHA_BAND_END : Nat = 1023;               // Positions 683-1023
    public let BETA_BAND_END : Nat = 2047;                // Positions 1024-2047
    public let GAMMA_BAND_START : Nat = 3755;             // Positions 3755-4095: fast tactical signals

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: ORGANISM AND COLONY TYPES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Colony organism caste (based on 9 animal engines)
    public type Caste = {
        #Crow;      // Tool use, problem solving
        #Dolphin;   // Social bonding, knowledge sharing
        #Hive;      // Colony coordination (default worker)
        #Elephant;  // Memory consolidation, construction
        #Shark;     // Predatory counterstrike
        #Wolf;      // Pack defense
        #Orca;      // Strategic hunting
        #Eagle;     // High-altitude reconnaissance
        #Octopus;   // Adaptability, camouflage
    };
    
    /// Colony behavior mode based on quorum sensing
    public type ColonyMode = {
        #Exploration;   // r_colony < 0.3 — independent counterfactual branches
        #Negotiation;   // 0.3 ≤ r_colony < 0.7 — consensus building
        #Commitment;    // r_colony ≥ 0.7 — coordinated action
    };
    
    /// Trait activation vector (one per caste)
    public type TraitVector = {
        crow : Float;
        dolphin : Float;
        hive : Float;
        elephant : Float;
        shark : Float;
        wolf : Float;
        orca : Float;
        eagle : Float;
        octopus : Float;
    };
    
    /// Individual organism state within the colony
    public type ColonyOrganism = {
        organismId : Nat64;                 // SACESI identifier
        principal : Principal;
        
        // Hz substrate phases (12 nodes)
        phases : [Float];                   // θₖ for k = 0..11
        frequencies : [Float];              // ωₖ natural frequencies
        
        // Trait/caste state
        traits : TraitVector;
        currentCaste : Caste;
        casteConfidence : Float;
        
        // FORMA energy
        formaEnergy : Float;
        formaReserve : Float;               // LTI equivalent
        
        // Coherence and drift
        localCoherence : Float;             // r for this organism
        genesisDrift : Float;               // δ_drift from genesis
        predictionError : Float;            // SIMULACRUM prediction error
        
        // Connection to colony
        atlasWritePermission : Bool;
        lastHeartbeat : Nat64;
        beatsSinceJoin : Nat64;
        
        // Epigenetic inheritance
        parentOrganismId : ?Nat64;
        inheritanceAlpha : Float;           // α coefficient for weight inheritance
    };
    
    /// ATLAS stigmergic cell
    public type AtlasCell = {
        position : Nat;                     // 0-4095
        pheromone : Float;                  // τ(x,t) — current concentration
        frequencyBand : Nat8;               // Which Hz band (0-11)
        
        // Last deposit info
        lastDepositorId : Nat64;
        lastDepositTime : Nat64;
        depositRate : Float;                // σ — deposition rate
        
        // Signal type
        signalType : CellSignalType;
        signalIntensity : Float;
    };
    
    /// Types of signals that can be written to ATLAS cells
    public type CellSignalType = {
        #Discovery;     // FORAGER organisms — external data
        #Threat;        // SOLDIER organisms — perimeter defense
        #Repair;        // NURSE organisms — drifted organism recovery
        #Construction;  // BUILDER organisms — long-horizon planning
        #Neutral;       // No active signal
    };
    
    /// Colony-wide state
    public type ColonyState = {
        colonyId : Nat64;
        
        // Organisms in colony
        organisms : [ColonyOrganism];
        organismCount : Nat;
        
        // ATLAS grid
        atlasGrid : [var AtlasCell];
        
        // Colony-wide Kuramoto
        rColony : Float;                    // Colony coherence index
        psiGlobal : Float;                  // Global phase
        colonyMode : ColonyMode;
        
        // Quorum state
        quorumActive : Bool;
        quorumEventCount : Nat;
        lastQuorumBeat : Nat64;
        
        // Genesis anchor signal (queen's pheromone)
        genesisComplianceScore : Float;
        genesisAnchorActive : Bool;
        
        // Timing
        currentBeat : Nat64;
        lastUpdateTime : Nat64;
        
        // ACO state
        pathPheromones : [Float];           // τᵢⱼ for path optimization
        bestPathLength : Float;
        convergenceRate : Float;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: INITIALIZATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Initialize empty trait vector
    public func initTraitVector() : TraitVector {
        {
            crow = 0.5;
            dolphin = 0.5;
            hive = 0.6;     // Hive is default highest — worker baseline
            elephant = 0.5;
            shark = 0.4;
            wolf = 0.4;
            orca = 0.4;
            eagle = 0.5;
            octopus = 0.5;
        }
    };
    
    /// Initialize ATLAS grid with 4096 cells partitioned by frequency band
    public func initAtlasGrid() : [var AtlasCell] {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        Array.init<AtlasCell>(ATLAS_GRID_SIZE, func(i : Nat) : AtlasCell {
            let band : Nat8 = computeFrequencyBand(i);
            {
                position = i;
                pheromone = 0.0;
                frequencyBand = band;
                lastDepositorId = 0;
                lastDepositTime = now;
                depositRate = 0.0;
                signalType = #Neutral;
                signalIntensity = 0.0;
            }
        })
    };
    
    /// Compute frequency band for ATLAS grid position
    public func computeFrequencyBand(position : Nat) : Nat8 {
        if (position <= DELTA_BAND_END) { return 0 };           // Delta
        if (position <= THETA_BAND_END) { return 1 };           // Theta
        if (position <= ALPHA_BAND_END) { return 2 };           // Alpha
        if (position <= BETA_BAND_END) { return 3 };            // Beta
        if (position >= GAMMA_BAND_START) { return 11 };        // Gamma
        // Mid-range bands
        let midPos = position - BETA_BAND_END;
        let bandWidth = (GAMMA_BAND_START - BETA_BAND_END) / 7;
        Nat8.fromNat(4 + (midPos / bandWidth))
    };
    
    /// Initialize colony state
    public func initColonyState(colonyId : Nat64) : ColonyState {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        {
            colonyId = colonyId;
            organisms = [];
            organismCount = 0;
            atlasGrid = initAtlasGrid();
            rColony = 0.5;
            psiGlobal = 0.0;
            colonyMode = #Exploration;
            quorumActive = false;
            quorumEventCount = 0;
            lastQuorumBeat = 0;
            genesisComplianceScore = 1.0;
            genesisAnchorActive = true;
            currentBeat = 0;
            lastUpdateTime = now;
            pathPheromones = Array.tabulate<Float>(ATLAS_GRID_SIZE, func(_ : Nat) : Float { 0.1 });
            bestPathLength = Float.fromInt(ATLAS_GRID_SIZE);
            convergenceRate = 0.0;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: KURAMOTO COLONY COHERENCE (LAW 2: QUORUM SENSING)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute colony-wide Kuramoto order parameter
    /// r_colony(t) · e^(iΨ) = (1/N) Σₙ (1/12) Σₖ e^(iθₖ(n,t))
    public func computeColonyKuramoto(organisms : [ColonyOrganism]) : (Float, Float) {
        let n = organisms.size();
        if (n == 0) { return (0.0, 0.0) };
        
        var sumCos : Float = 0.0;
        var sumSin : Float = 0.0;
        
        for (organism in organisms.vals()) {
            // Inner sum: average phase across 12 Hz nodes
            var orgCos : Float = 0.0;
            var orgSin : Float = 0.0;
            
            for (phase in organism.phases.vals()) {
                orgCos += Float.cos(phase);
                orgSin += Float.sin(phase);
            };
            
            // Normalize by number of nodes
            orgCos /= Float.fromInt(HZ_NODE_COUNT);
            orgSin /= Float.fromInt(HZ_NODE_COUNT);
            
            // Add to colony sum
            sumCos += orgCos;
            sumSin += orgSin;
        };
        
        // Normalize by number of organisms
        sumCos /= Float.fromInt(n);
        sumSin /= Float.fromInt(n);
        
        // r = magnitude, ψ = phase
        let r = Float.sqrt(sumCos * sumCos + sumSin * sumSin);
        let psi = Float.arctan2(sumSin, sumCos);
        
        (r, psi)
    };
    
    /// Determine colony mode based on r_colony (quorum sensing)
    public func determineColonyMode(rColony : Float) : ColonyMode {
        if (rColony < QUORUM_EXPLORATION) {
            #Exploration
        } else if (rColony < QUORUM_COMMITMENT) {
            #Negotiation
        } else {
            #Commitment
        }
    };
    
    /// Check if Pride Before Fall Law should fire (de-coherence pulse)
    public func shouldFireDecoherencePulse(rColony : Float) : Bool {
        rColony > QUORUM_BRITTLE
    };
    
    /// Apply de-coherence pulse to prevent brittle perfect synchrony
    public func applyDecoherencePulse(phases : [Float], pulseStrength : Float) : [Float] {
        Array.tabulate<Float>(phases.size(), func(i : Nat) : Float {
            let noise = (Float.fromInt(i) * 0.1) - 0.05;  // Small perturbation
            phases[i] + (noise * pulseStrength)
        })
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: CASTE ASSIGNMENT (LAW 3: DIVISION OF LABOR)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute dominant caste from trait vector and FORMA energy
    /// caste(n) = argmax_k(T_k(n) · e^(FORMA(n)/FORMA_mean))
    public func computeCaste(traits : TraitVector, formaEnergy : Float, formaMean : Float) : Caste {
        // FORMA amplification factor
        let formaFactor = if (formaMean > 0.0) {
            Float.exp(formaEnergy / formaMean)
        } else {
            1.0
        };
        
        // Compute amplified trait scores
        let scores : [(Caste, Float)] = [
            (#Crow, traits.crow * formaFactor),
            (#Dolphin, traits.dolphin * formaFactor),
            (#Hive, traits.hive * formaFactor),
            (#Elephant, traits.elephant * formaFactor),
            (#Shark, traits.shark * formaFactor),
            (#Wolf, traits.wolf * formaFactor),
            (#Orca, traits.orca * formaFactor),
            (#Eagle, traits.eagle * formaFactor),
            (#Octopus, traits.octopus * formaFactor),
        ];
        
        // Find argmax
        var maxCaste : Caste = #Hive;
        var maxScore : Float = 0.0;
        
        for ((caste, score) in scores.vals()) {
            if (score > maxScore) {
                maxScore := score;
                maxCaste := caste;
            };
        };
        
        maxCaste
    };
    
    /// Update trait vector based on ATLAS sector signals
    /// (Dynamic caste switching based on environmental pheromones)
    public func updateTraitsFromAtlas(
        traits : TraitVector,
        atlasGrid : [var AtlasCell],
        sectorStart : Nat,
        sectorEnd : Nat
    ) : TraitVector {
        // Scan ATLAS sector for signal types
        var threatCount : Float = 0.0;
        var resourceCount : Float = 0.0;
        var repairCount : Float = 0.0;
        var discoveryCount : Float = 0.0;
        
        var i = sectorStart;
        while (i < sectorEnd and i < ATLAS_GRID_SIZE) {
            let cell = atlasGrid[i];
            switch (cell.signalType) {
                case (#Threat) { threatCount += cell.signalIntensity };
                case (#Discovery) { discoveryCount += cell.signalIntensity };
                case (#Repair) { repairCount += cell.signalIntensity };
                case (#Construction) { resourceCount += cell.signalIntensity };
                case (#Neutral) { };
            };
            i += 1;
        };
        
        // Modulate traits based on signals
        let threatBoost = threatCount * 0.1;
        let resourceBoost = resourceCount * 0.1;
        let socialBoost = repairCount * 0.1;
        let problemBoost = discoveryCount * 0.1;
        
        {
            crow = traits.crow + problemBoost;      // Discovery → problem solving
            dolphin = traits.dolphin + socialBoost; // Repair → social bonding
            hive = traits.hive;                     // Baseline unchanged
            elephant = traits.elephant + resourceBoost; // Construction → memory/building
            shark = traits.shark + threatBoost;     // Threat → predatory response
            wolf = traits.wolf + threatBoost;       // Threat → pack defense
            orca = traits.orca + threatBoost * 0.5; // Threat → strategic hunting
            eagle = traits.eagle + discoveryCount * 0.05; // Discovery → reconnaissance
            octopus = traits.octopus + resourceBoost * 0.5; // Construction → adaptability
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: STIGMERGY — ATLAS PHEROMONE OPERATIONS (LAW 1)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Deposit pheromone to ATLAS cell
    /// σᵢ(t) = deposition rate proportional to FORMA energy
    public func depositPheromone(
        grid : [var AtlasCell],
        position : Nat,
        organismId : Nat64,
        formaEnergy : Float,
        signalType : CellSignalType,
        intensity : Float,
        beat : Nat64
    ) : () {
        if (position >= ATLAS_GRID_SIZE) { return };
        
        let depositRate = PHEROMONE_DEPOSIT_BASE * (1.0 + formaEnergy * FORMA_AMPLIFICATION);
        let cell = grid[position];
        
        grid[position] := {
            position = cell.position;
            pheromone = cell.pheromone + depositRate;
            frequencyBand = cell.frequencyBand;
            lastDepositorId = organismId;
            lastDepositTime = beat;
            depositRate = depositRate;
            signalType = signalType;
            signalIntensity = intensity;
        };
    };
    
    /// Evaporate pheromones across the entire ATLAS grid (Talent Decay Law)
    /// dτ(x,t)/dt includes -ρ · τ(x,t) evaporation term
    public func evaporatePheromones(grid : [var AtlasCell]) : () {
        var i = 0;
        while (i < ATLAS_GRID_SIZE) {
            let cell = grid[i];
            let newPheromone = cell.pheromone * (1.0 - PHEROMONE_EVAPORATION);
            
            // Decay signal intensity as well
            let newIntensity = cell.signalIntensity * (1.0 - PHEROMONE_EVAPORATION);
            let newSignalType = if (newIntensity < 0.01) { #Neutral } else { cell.signalType };
            
            grid[i] := {
                position = cell.position;
                pheromone = newPheromone;
                frequencyBand = cell.frequencyBand;
                lastDepositorId = cell.lastDepositorId;
                lastDepositTime = cell.lastDepositTime;
                depositRate = cell.depositRate;
                signalType = newSignalType;
                signalIntensity = newIntensity;
            };
            i += 1;
        };
    };
    
    /// Read pheromone gradient from ATLAS (for navigation)
    public func readPheromoneGradient(
        grid : [var AtlasCell],
        position : Nat,
        radius : Nat
    ) : [Float] {
        let startPos = if (position > radius) { position - radius } else { 0 };
        let endPos = if (position + radius < ATLAS_GRID_SIZE) { position + radius } else { ATLAS_GRID_SIZE - 1 };
        
        let gradientSize = endPos - startPos + 1;
        Array.tabulate<Float>(gradientSize, func(i : Nat) : Float {
            grid[startPos + i].pheromone
        })
    };
    
    /// Get top N highest-pheromone cells (for epigenetic inheritance)
    public func getTopPheromeCells(grid : [var AtlasCell], n : Nat) : [AtlasCell] {
        // Create array of cells with pheromone values
        let cells = Array.tabulate<AtlasCell>(ATLAS_GRID_SIZE, func(i : Nat) : AtlasCell {
            grid[i]
        });
        
        // Sort by pheromone (descending) - using simple bubble sort for small n
        let sorted = Array.thaw<AtlasCell>(cells);
        var swapped = true;
        while (swapped) {
            swapped := false;
            var j = 0;
            while (j < ATLAS_GRID_SIZE - 1) {
                if (sorted[j].pheromone < sorted[j + 1].pheromone) {
                    let temp = sorted[j];
                    sorted[j] := sorted[j + 1];
                    sorted[j + 1] := temp;
                    swapped := true;
                };
                j += 1;
            };
        };
        
        // Return top n
        let count = if (n > ATLAS_GRID_SIZE) { ATLAS_GRID_SIZE } else { n };
        Array.tabulate<AtlasCell>(count, func(i : Nat) : AtlasCell {
            sorted[i]
        })
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: ACO PATH OPTIMIZATION (LAW 4: FORK-TRAIL OPTIMIZATION)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// ACO edge selection probability
    /// P_ij = τ_ij^α · η_ij^β / Σ_k τ_ik^α · η_ik^β
    public func computeACOProbability(
        pheromone : Float,
        heuristic : Float,
        totalPheromone : Float,
        totalHeuristic : Float
    ) : Float {
        let numerator = Float.pow(pheromone, ACO_ALPHA) * Float.pow(heuristic, ACO_BETA);
        let denominator = Float.pow(totalPheromone, ACO_ALPHA) * Float.pow(totalHeuristic, ACO_BETA);
        
        if (denominator > 0.0) {
            numerator / denominator
        } else {
            0.0
        }
    };
    
    /// Update pheromone after path traversal
    /// Δτᵢⱼ(k) = Q / L_k if ant k traverses edge (i,j)
    /// τᵢⱼ(t+1) = (1-ρ) · τᵢⱼ(t) + Σₖ Δτᵢⱼ(k)
    public func updateACOPheromone(
        pathPheromones : [Float],
        pathIndices : [Nat],
        pathLength : Float,
        lawComplianceCost : Float
    ) : [Float] {
        // Total path cost includes law compliance
        let totalCost = pathLength + lawComplianceCost;
        let deposit = if (totalCost > 0.0) { PHEROMONE_DEPOSIT_BASE / totalCost } else { 0.0 };
        
        Array.tabulate<Float>(pathPheromones.size(), func(i : Nat) : Float {
            let evaporated = pathPheromones[i] * (1.0 - ACO_RHO);
            
            // Check if this index is in the path
            var isInPath = false;
            for (idx in pathIndices.vals()) {
                if (idx == i) { isInPath := true };
            };
            
            if (isInPath) {
                evaporated + deposit
            } else {
                evaporated
            }
        })
    };
    
    /// Colony-wide loss function for ACO optimization
    /// L = Σᵢ wᵢ · δ_drift(i) + λ · (1 − r_colony)
    public func computeColonyLoss(
        driftScores : [Float],      // Per-system drift from genesis
        driftWeights : [Float],     // Per-law weights
        rColony : Float,
        coherenceWeight : Float
    ) : Float {
        var driftSum : Float = 0.0;
        
        let minLen = if (driftScores.size() < driftWeights.size()) {
            driftScores.size()
        } else {
            driftWeights.size()
        };
        
        var i = 0;
        while (i < minLen) {
            driftSum += driftScores[i] * driftWeights[i];
            i += 1;
        };
        
        let incoherencePenalty = (1.0 - rColony) * coherenceWeight;
        
        driftSum + incoherencePenalty
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: EPIGENETIC INHERITANCE (LAW 5: MEMORY SPANNING GENERATIONS)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute inheritance coefficient based on parent drift
    /// α = f(parent drift) — organisms with high drift produce children with lower α
    public func computeInheritanceAlpha(parentDrift : Float) : Float {
        // α decreases as drift increases
        // Vine and Branches Law: drifted parents produce children pulled toward genesis
        let maxAlpha : Float = 0.9;
        let minAlpha : Float = 0.1;
        
        // Drift 0 → α = 0.9 (inherit almost fully)
        // Drift 1 → α = 0.1 (mostly genesis weights)
        maxAlpha - (parentDrift * (maxAlpha - minAlpha))
    };
    
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
    
    /// Epigenetic record for generational tracking
    public type EpigeneticRecord = {
        recordId : Nat64;
        parentId : Nat64;
        childId : Nat64;
        inheritanceAlpha : Float;
        parentDriftAtSpawn : Float;
        topPheromoneCells : [Nat];  // Top 20% positions from parent ATLAS
        timestamp : Nat64;
        generation : Nat;
    };
    
    /// Create epigenetic record for child organism
    public func createEpigeneticRecord(
        parentOrganism : ColonyOrganism,
        childId : Nat64,
        atlasGrid : [var AtlasCell],
        generation : Nat,
        beat : Nat64
    ) : EpigeneticRecord {
        let alpha = computeInheritanceAlpha(parentOrganism.genesisDrift);
        
        // Get top 20% pheromone cells
        let top20Percent = ATLAS_GRID_SIZE / 5;  // 819 cells
        let topCells = getTopPheromeCells(atlasGrid, top20Percent);
        let topPositions = Array.tabulate<Nat>(topCells.size(), func(i : Nat) : Nat {
            topCells[i].position
        });
        
        {
            recordId = beat;
            parentId = parentOrganism.organismId;
            childId = childId;
            inheritanceAlpha = alpha;
            parentDriftAtSpawn = parentOrganism.genesisDrift;
            topPheromoneCells = topPositions;
            timestamp = beat;
            generation = generation;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 8: QUEEN'S SIGNAL — GENESIS ANCHOR (LAW 7)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute genesis compliance delta (queen's pheromone signal)
    public func computeGenesisComplianceDelta(
        currentState : Float,
        genesisBaseline : Float
    ) : Float {
        Float.abs(currentState - genesisBaseline)
    };
    
    /// Queen's signal emission — readable by all organisms
    public type QueenSignal = {
        signalId : Nat64;
        genesisComplianceScore : Float;
        colonyCoherence : Float;
        timestamp : Nat64;
        isActive : Bool;
    };
    
    /// Emit queen's signal (CHRONO genesis anchor)
    public func emitQueenSignal(
        colonyState : ColonyState,
        beat : Nat64
    ) : QueenSignal {
        {
            signalId = beat;
            genesisComplianceScore = colonyState.genesisComplianceScore;
            colonyCoherence = colonyState.rColony;
            timestamp = beat;
            isActive = colonyState.genesisAnchorActive;
        }
    };
    
    /// Organism reads queen's signal and computes local correction
    public func readQueenSignalCorrection(
        organism : ColonyOrganism,
        queenSignal : QueenSignal
    ) : Float {
        // Delta between organism's state and genesis baseline
        let delta = organism.genesisDrift;
        
        // Correction magnitude proportional to delta
        // The queen doesn't command — the gradient IS the command
        delta * queenSignal.genesisComplianceScore
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 9: COLLECTIVE INTELLIGENCE (LAW 6: EMERGENCE)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Write prediction error to ATLAS (for collective gradient)
    public func writePredictionErrorToAtlas(
        grid : [var AtlasCell],
        organismId : Nat64,
        predictionError : Float,
        sector : Nat,
        beat : Nat64
    ) : () {
        // Map sector to ATLAS position
        let position = sector % ATLAS_GRID_SIZE;
        
        // Signal intensity proportional to surprise
        let intensity = predictionError;
        let signalType = if (predictionError > 0.5) { #Discovery } else { #Neutral };
        
        depositPheromone(grid, position, organismId, predictionError, signalType, intensity, beat);
    };
    
    /// Compute colony mutual information (I_shared)
    /// I_colony = Σₙ I_individual(n) + Σₙ Σₘ≠ₙ I_shared(n,m)
    public func computeColonyMutualInformation(
        organisms : [ColonyOrganism],
        atlasGrid : [var AtlasCell]
    ) : Float {
        let n = organisms.size();
        if (n < 2) { return 0.0 };
        
        var totalShared : Float = 0.0;
        
        // Pairwise mutual information via ATLAS overlap
        var i = 0;
        while (i < n) {
            var j = i + 1;
            while (j < n) {
                // Approximate mutual information via prediction error correlation
                let errI = organisms[i].predictionError;
                let errJ = organisms[j].predictionError;
                
                // Shared information when errors are correlated
                let correlation = 1.0 - Float.abs(errI - errJ);
                totalShared += correlation;
                
                j += 1;
            };
            i += 1;
        };
        
        // Normalize by number of pairs
        let numPairs = Float.fromInt(n * (n - 1) / 2);
        if (numPairs > 0.0) {
            totalShared / numPairs
        } else {
            0.0
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 10: COLONY HEARTBEAT — MAIN UPDATE LOOP
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Main colony update function (called every heartbeat)
    public func updateColony(state : ColonyState, beat : Nat64) : ColonyState {
        // 1. Compute colony-wide Kuramoto coherence
        let (rNew, psiNew) = computeColonyKuramoto(state.organisms);
        
        // 2. Determine colony mode
        let newMode = determineColonyMode(rNew);
        
        // 3. Check for Pride Before Fall (de-coherence pulse)
        let needsDecoherence = shouldFireDecoherencePulse(rNew);
        
        // 4. Evaporate pheromones (Talent Decay Law)
        evaporatePheromones(state.atlasGrid);
        
        // 5. Update quorum state
        let quorumNow = rNew >= QUORUM_COMMITMENT;
        let quorumFired = quorumNow and not state.quorumActive;
        let newQuorumCount = if (quorumFired) { state.quorumEventCount + 1 } else { state.quorumEventCount };
        
        // 6. Compute colony loss for ACO optimization
        let driftScores = Array.tabulate<Float>(state.organisms.size(), func(i : Nat) : Float {
            state.organisms[i].genesisDrift
        });
        let uniformWeights = Array.tabulate<Float>(state.organisms.size(), func(_ : Nat) : Float { 1.0 });
        let colonyLoss = computeColonyLoss(driftScores, uniformWeights, rNew, 0.5);
        
        // 7. Update convergence rate
        let newConvergence = if (colonyLoss < state.bestPathLength) {
            (state.bestPathLength - colonyLoss) / state.bestPathLength
        } else {
            0.0
        };
        
        // 8. Emit queen's signal (every beat)
        let queenSignal = emitQueenSignal(state, beat);
        
        // 9. Return updated state
        {
            colonyId = state.colonyId;
            organisms = state.organisms;
            organismCount = state.organismCount;
            atlasGrid = state.atlasGrid;
            rColony = rNew;
            psiGlobal = psiNew;
            colonyMode = newMode;
            quorumActive = quorumNow;
            quorumEventCount = newQuorumCount;
            lastQuorumBeat = if (quorumFired) { beat } else { state.lastQuorumBeat };
            genesisComplianceScore = queenSignal.genesisComplianceScore;
            genesisAnchorActive = queenSignal.isActive;
            currentBeat = beat;
            lastUpdateTime = Nat64.fromNat(Int.abs(Time.now()));
            pathPheromones = state.pathPheromones;
            bestPathLength = if (colonyLoss < state.bestPathLength) { colonyLoss } else { state.bestPathLength };
            convergenceRate = newConvergence;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 11: CASTE SECTOR MAPPING (ENTERPRISE SCALE)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// ATLAS sector assignment by caste
    public type CasteSector = {
        caste : Caste;
        sectorStart : Nat;
        sectorEnd : Nat;
        signalType : CellSignalType;
        description : Text;
    };
    
    /// Get caste sector assignments (enterprise layout)
    public func getCasteSectors() : [CasteSector] {
        [
            // FORAGER organisms (Crow + Eagle dominant)
            {
                caste = #Crow;
                sectorStart = 0;
                sectorEnd = 511;
                signalType = #Discovery;
                description = "Discovery sector - external data ingestion";
            },
            {
                caste = #Eagle;
                sectorStart = 512;
                sectorEnd = 1023;
                signalType = #Discovery;
                description = "Reconnaissance sector - high-altitude scanning";
            },
            // SOLDIER organisms (Wolf + Shark dominant)
            {
                caste = #Wolf;
                sectorStart = 1024;
                sectorEnd = 1535;
                signalType = #Threat;
                description = "Defense sector - pack defense";
            },
            {
                caste = #Shark;
                sectorStart = 1536;
                sectorEnd = 2047;
                signalType = #Threat;
                description = "Counterstrike sector - predatory response";
            },
            // NURSE organisms (Dolphin + Hive dominant)
            {
                caste = #Dolphin;
                sectorStart = 2048;
                sectorEnd = 2559;
                signalType = #Repair;
                description = "Social sector - knowledge sharing";
            },
            {
                caste = #Hive;
                sectorStart = 2560;
                sectorEnd = 3071;
                signalType = #Repair;
                description = "Repair sector - drifted organism recovery";
            },
            // BUILDER organisms (Elephant + Octopus dominant)
            {
                caste = #Elephant;
                sectorStart = 3072;
                sectorEnd = 3583;
                signalType = #Construction;
                description = "Memory sector - long-horizon planning";
            },
            {
                caste = #Octopus;
                sectorStart = 3584;
                sectorEnd = 4095;
                signalType = #Construction;
                description = "Adaptation sector - structural flexibility";
            },
            // Orca - strategic overlay (spans all sectors)
            {
                caste = #Orca;
                sectorStart = 0;
                sectorEnd = 4095;
                signalType = #Neutral;
                description = "Strategic overlay - coordinates across sectors";
            },
        ]
    };
    
    /// Get sector for a caste
    public func getSectorForCaste(caste : Caste) : (Nat, Nat) {
        switch (caste) {
            case (#Crow) { (0, 511) };
            case (#Eagle) { (512, 1023) };
            case (#Wolf) { (1024, 1535) };
            case (#Shark) { (1536, 2047) };
            case (#Dolphin) { (2048, 2559) };
            case (#Hive) { (2560, 3071) };
            case (#Elephant) { (3072, 3583) };
            case (#Octopus) { (3584, 4095) };
            case (#Orca) { (0, 4095) };  // Full overlay
        }
    };
}
