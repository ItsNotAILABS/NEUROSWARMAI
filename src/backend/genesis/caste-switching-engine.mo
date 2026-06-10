/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║               CASTE SWITCHING ENGINE — DIVISION OF LABOR                       ║
 * ║           LAW 3: An Ant Colony Has Caste Without Hierarchy                     ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  CASTE ASSIGNMENT:                                                              ║
 * ║  caste(n) = argmax_k(T_k(n) · e^(FORMA(n)/FORMA_mean))                        ║
 * ║                                                                                ║
 * ║  FORMA energy amplifies the dominant trait. A well-resourced organism          ║
 * ║  activates its highest trait more strongly. A depleted organism regresses      ║
 * ║  toward the hive baseline — it becomes a worker.                               ║
 * ║                                                                                ║
 * ║  DYNAMIC CASTE SWITCHING:                                                       ║
 * ║  When the ATLAS grid shows a threat signal, organisms shift toward Wolf/Shark. ║
 * ║  When the grid shows resource abundance, organisms shift toward Dolphin/Crow.  ║
 * ║  No central assignment. The pheromone field does it.                           ║
 * ╚═══════════════════════════════════════════════════════════════════════════════╝
 */

import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Float "mo:core/Float";
import Int "mo:core/Int";
import Iter "mo:core/Iter";
import Nat "mo:core/Nat";
import Nat64 "mo:core/Nat64";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";

module CasteSwitchingEngine {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Trait activation boost from ATLAS signals
    public let SIGNAL_TRAIT_BOOST : Float = 0.15;
    
    /// Trait decay rate per beat (unused traits fade)
    public let TRAIT_DECAY_RATE : Float = 0.01;
    
    /// FORMA amplification exponent
    public let FORMA_AMPLIFICATION_EXP : Float = 1.0;
    
    /// Minimum trait value (never drops below)
    public let MIN_TRAIT_VALUE : Float = 0.1;
    
    /// Maximum trait value
    public let MAX_TRAIT_VALUE : Float = 1.0;
    
    /// Hive baseline (default caste for depleted organisms)
    public let HIVE_BASELINE : Float = 0.5;
    
    /// Caste switch cooldown (beats between switches)
    public let CASTE_SWITCH_COOLDOWN : Nat = 10;
    
    /// Caste count
    public let CASTE_COUNT : Nat = 9;

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: TYPES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Colony organism caste
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
    
    /// Trait activation vector
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
    
    /// ATLAS signal types affecting caste
    public type AtlasSignal = {
        #Threat;        // Boosts Wolf, Shark, Orca
        #Resource;      // Boosts Crow, Elephant
        #Social;        // Boosts Dolphin, Hive
        #Discovery;     // Boosts Eagle, Crow
        #Repair;        // Boosts Hive, Dolphin
        #Construction;  // Boosts Elephant, Octopus
        #Neutral;       // No boost
    };
    
    /// Caste state for an organism
    public type CasteState = {
        currentCaste : Caste;
        traits : TraitVector;
        
        // FORMA energy (affects amplification)
        formaEnergy : Float;
        
        // Switching history
        lastSwitchBeat : Nat64;
        switchCount : Nat;
        casteHistory : [Caste];  // Last N castes
        
        // Confidence in current caste
        casteConfidence : Float;
        dominanceMargin : Float;  // Gap between top 2 traits
    };
    
    /// Signal intensity from ATLAS sector
    public type SectorSignals = {
        threatIntensity : Float;
        resourceIntensity : Float;
        socialIntensity : Float;
        discoveryIntensity : Float;
        repairIntensity : Float;
        constructionIntensity : Float;
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: INITIALIZATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Initialize trait vector with balanced values
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
    
    /// Initialize caste state
    public func initCasteState(formaEnergy : Float) : CasteState {
        let traits = initTraitVector();
        let (caste, confidence, margin) = computeCasteFromTraits(traits, formaEnergy, 1.0);
        
        {
            currentCaste = caste;
            traits = traits;
            formaEnergy = formaEnergy;
            lastSwitchBeat = 0;
            switchCount = 0;
            casteHistory = [#Hive];
            casteConfidence = confidence;
            dominanceMargin = margin;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: CASTE COMPUTATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Compute caste from trait vector with FORMA amplification
    /// caste(n) = argmax_k(T_k(n) · e^(FORMA(n)/FORMA_mean))
    public func computeCasteFromTraits(
        traits : TraitVector,
        formaEnergy : Float,
        formaMean : Float
    ) : (Caste, Float, Float) {  // Returns (caste, confidence, margin)
        
        // FORMA amplification factor
        let formaFactor = if (formaMean > 0.0) {
            Float.exp(formaEnergy / formaMean * FORMA_AMPLIFICATION_EXP)
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
        
        // Find argmax and second max
        var maxCaste : Caste = #Hive;
        var maxScore : Float = 0.0;
        var secondScore : Float = 0.0;
        var totalScore : Float = 0.0;
        
        for ((caste, score) in scores.vals()) {
            totalScore += score;
            if (score > maxScore) {
                secondScore := maxScore;
                maxScore := score;
                maxCaste := caste;
            } else if (score > secondScore) {
                secondScore := score;
            };
        };
        
        // Confidence = max score / total score
        let confidence = if (totalScore > 0.0) { maxScore / totalScore } else { 0.0 };
        
        // Margin = difference between top 2
        let margin = maxScore - secondScore;
        
        (maxCaste, confidence, margin)
    };
    
    /// Get trait value for a caste
    public func getTraitForCaste(traits : TraitVector, caste : Caste) : Float {
        switch (caste) {
            case (#Crow) { traits.crow };
            case (#Dolphin) { traits.dolphin };
            case (#Hive) { traits.hive };
            case (#Elephant) { traits.elephant };
            case (#Shark) { traits.shark };
            case (#Wolf) { traits.wolf };
            case (#Orca) { traits.orca };
            case (#Eagle) { traits.eagle };
            case (#Octopus) { traits.octopus };
        }
    };
    
    /// Set trait value for a caste
    public func setTraitForCaste(traits : TraitVector, caste : Caste, value : Float) : TraitVector {
        let clampedValue = Float.max(MIN_TRAIT_VALUE, Float.min(MAX_TRAIT_VALUE, value));
        
        switch (caste) {
            case (#Crow) { { traits with crow = clampedValue } };
            case (#Dolphin) { { traits with dolphin = clampedValue } };
            case (#Hive) { { traits with hive = clampedValue } };
            case (#Elephant) { { traits with elephant = clampedValue } };
            case (#Shark) { { traits with shark = clampedValue } };
            case (#Wolf) { { traits with wolf = clampedValue } };
            case (#Orca) { { traits with orca = clampedValue } };
            case (#Eagle) { { traits with eagle = clampedValue } };
            case (#Octopus) { { traits with octopus = clampedValue } };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: ATLAS SIGNAL PROCESSING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Update traits based on ATLAS sector signals
    /// Dynamic caste switching: pheromone field determines behavior
    public func updateTraitsFromSignals(
        traits : TraitVector,
        signals : SectorSignals
    ) : TraitVector {
        // Threat signals boost combat castes
        let threatBoost = signals.threatIntensity * SIGNAL_TRAIT_BOOST;
        
        // Resource/discovery signals boost cognitive castes
        let resourceBoost = signals.resourceIntensity * SIGNAL_TRAIT_BOOST;
        let discoveryBoost = signals.discoveryIntensity * SIGNAL_TRAIT_BOOST;
        
        // Social signals boost cooperative castes
        let socialBoost = signals.socialIntensity * SIGNAL_TRAIT_BOOST;
        let repairBoost = signals.repairIntensity * SIGNAL_TRAIT_BOOST;
        
        // Construction signals boost building castes
        let constructionBoost = signals.constructionIntensity * SIGNAL_TRAIT_BOOST;
        
        {
            crow = clampTrait(traits.crow + discoveryBoost + resourceBoost);
            dolphin = clampTrait(traits.dolphin + socialBoost + repairBoost);
            hive = clampTrait(traits.hive + repairBoost);
            elephant = clampTrait(traits.elephant + constructionBoost + resourceBoost);
            shark = clampTrait(traits.shark + threatBoost);
            wolf = clampTrait(traits.wolf + threatBoost);
            orca = clampTrait(traits.orca + threatBoost * 0.7);
            eagle = clampTrait(traits.eagle + discoveryBoost * 0.8);
            octopus = clampTrait(traits.octopus + constructionBoost * 0.6);
        }
    };
    
    /// Clamp trait to valid range
    public func clampTrait(value : Float) : Float {
        Float.max(MIN_TRAIT_VALUE, Float.min(MAX_TRAIT_VALUE, value))
    };
    
    /// Decay unused traits toward baseline
    public func decayTraits(traits : TraitVector, activeCaste : Caste) : TraitVector {
        // All traits decay except the active one
        func decayIfNotActive(current : Float, thisCaste : Caste) : Float {
            if (casteEquals(thisCaste, activeCaste)) {
                current  // No decay for active
            } else {
                // Decay toward hive baseline
                let diff = current - HIVE_BASELINE;
                current - (diff * TRAIT_DECAY_RATE)
            }
        };
        
        {
            crow = decayIfNotActive(traits.crow, #Crow);
            dolphin = decayIfNotActive(traits.dolphin, #Dolphin);
            hive = traits.hive;  // Hive never decays
            elephant = decayIfNotActive(traits.elephant, #Elephant);
            shark = decayIfNotActive(traits.shark, #Shark);
            wolf = decayIfNotActive(traits.wolf, #Wolf);
            orca = decayIfNotActive(traits.orca, #Orca);
            eagle = decayIfNotActive(traits.eagle, #Eagle);
            octopus = decayIfNotActive(traits.octopus, #Octopus);
        }
    };
    
    /// Caste equality check
    public func casteEquals(a : Caste, b : Caste) : Bool {
        switch (a, b) {
            case (#Crow, #Crow) { true };
            case (#Dolphin, #Dolphin) { true };
            case (#Hive, #Hive) { true };
            case (#Elephant, #Elephant) { true };
            case (#Shark, #Shark) { true };
            case (#Wolf, #Wolf) { true };
            case (#Orca, #Orca) { true };
            case (#Eagle, #Eagle) { true };
            case (#Octopus, #Octopus) { true };
            case _ { false };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: CASTE SWITCHING PROTOCOL
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Evaluate and potentially switch caste
    public func evaluateCasteSwitch(
        state : CasteState,
        signals : SectorSignals,
        formaMean : Float,
        currentBeat : Nat64
    ) : CasteState {
        // Check cooldown
        let beatsSinceSwitch = currentBeat - state.lastSwitchBeat;
        if (Nat64.toNat(beatsSinceSwitch) < CASTE_SWITCH_COOLDOWN) {
            return state;  // Still in cooldown
        };
        
        // Update traits from signals
        let updatedTraits = updateTraitsFromSignals(state.traits, signals);
        
        // Decay unused traits
        let decayedTraits = decayTraits(updatedTraits, state.currentCaste);
        
        // Compute new caste
        let (newCaste, newConfidence, newMargin) = computeCasteFromTraits(
            decayedTraits,
            state.formaEnergy,
            formaMean
        );
        
        // Only switch if new caste is different and margin is significant
        let shouldSwitch = not casteEquals(newCaste, state.currentCaste) and newMargin > 0.1;
        
        if (shouldSwitch) {
            // Record switch
            let newHistory = Array.append([state.currentCaste], state.casteHistory);
            let trimmedHistory = if (newHistory.size() > 10) {
                Array.tabulate<Caste>(10, func(i : Nat) : Caste { newHistory[i] })
            } else {
                newHistory
            };
            
            {
                currentCaste = newCaste;
                traits = decayedTraits;
                formaEnergy = state.formaEnergy;
                lastSwitchBeat = currentBeat;
                switchCount = state.switchCount + 1;
                casteHistory = trimmedHistory;
                casteConfidence = newConfidence;
                dominanceMargin = newMargin;
            }
        } else {
            // No switch, just update traits
            {
                currentCaste = state.currentCaste;
                traits = decayedTraits;
                formaEnergy = state.formaEnergy;
                lastSwitchBeat = state.lastSwitchBeat;
                switchCount = state.switchCount;
                casteHistory = state.casteHistory;
                casteConfidence = newConfidence;
                dominanceMargin = newMargin;
            }
        }
    };
    
    /// Force caste switch (for emergency situations)
    public func forceCasteSwitch(
        state : CasteState,
        newCaste : Caste,
        currentBeat : Nat64
    ) : CasteState {
        // Boost the target caste trait significantly
        let boostedTraits = setTraitForCaste(state.traits, newCaste, MAX_TRAIT_VALUE);
        
        let newHistory = Array.append([state.currentCaste], state.casteHistory);
        let trimmedHistory = if (newHistory.size() > 10) {
            Array.tabulate<Caste>(10, func(i : Nat) : Caste { newHistory[i] })
        } else {
            newHistory
        };
        
        {
            currentCaste = newCaste;
            traits = boostedTraits;
            formaEnergy = state.formaEnergy;
            lastSwitchBeat = currentBeat;
            switchCount = state.switchCount + 1;
            casteHistory = trimmedHistory;
            casteConfidence = 1.0;
            dominanceMargin = 0.5;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: CASTE BEHAVIOR MODULES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Caste behavior descriptor
    public type CasteBehavior = {
        caste : Caste;
        primaryAction : Text;
        atlasReadSector : (Nat, Nat);  // Sector this caste monitors
        atlasWriteSignal : AtlasSignal;
        formaMultiplier : Float;       // How efficiently it uses FORMA
        coordinationMode : CoordinationMode;
    };
    
    /// Coordination mode for caste
    public type CoordinationMode = {
        #Solo;          // Works independently
        #Pack;          // Coordinates with same caste
        #Swarm;         // Coordinates with all castes
        #Leader;        // Leads coordination
    };
    
    /// Get behavior for a caste
    public func getCasteBehavior(caste : Caste) : CasteBehavior {
        switch (caste) {
            case (#Crow) {
                {
                    caste = #Crow;
                    primaryAction = "Problem solving and tool use";
                    atlasReadSector = (0, 511);
                    atlasWriteSignal = #Discovery;
                    formaMultiplier = 1.2;
                    coordinationMode = #Solo;
                }
            };
            case (#Dolphin) {
                {
                    caste = #Dolphin;
                    primaryAction = "Social bonding and knowledge sharing";
                    atlasReadSector = (2048, 2559);
                    atlasWriteSignal = #Social;
                    formaMultiplier = 1.0;
                    coordinationMode = #Swarm;
                }
            };
            case (#Hive) {
                {
                    caste = #Hive;
                    primaryAction = "Colony coordination and baseline work";
                    atlasReadSector = (2560, 3071);
                    atlasWriteSignal = #Repair;
                    formaMultiplier = 0.8;
                    coordinationMode = #Swarm;
                }
            };
            case (#Elephant) {
                {
                    caste = #Elephant;
                    primaryAction = "Memory consolidation and construction";
                    atlasReadSector = (3072, 3583);
                    atlasWriteSignal = #Construction;
                    formaMultiplier = 1.1;
                    coordinationMode = #Pack;
                }
            };
            case (#Shark) {
                {
                    caste = #Shark;
                    primaryAction = "Predatory counterstrike";
                    atlasReadSector = (1536, 2047);
                    atlasWriteSignal = #Threat;
                    formaMultiplier = 1.5;
                    coordinationMode = #Solo;
                }
            };
            case (#Wolf) {
                {
                    caste = #Wolf;
                    primaryAction = "Pack defense";
                    atlasReadSector = (1024, 1535);
                    atlasWriteSignal = #Threat;
                    formaMultiplier = 1.3;
                    coordinationMode = #Pack;
                }
            };
            case (#Orca) {
                {
                    caste = #Orca;
                    primaryAction = "Strategic hunting coordination";
                    atlasReadSector = (0, 4095);  // Full overlay
                    atlasWriteSignal = #Neutral;
                    formaMultiplier = 1.4;
                    coordinationMode = #Leader;
                }
            };
            case (#Eagle) {
                {
                    caste = #Eagle;
                    primaryAction = "High-altitude reconnaissance";
                    atlasReadSector = (512, 1023);
                    atlasWriteSignal = #Discovery;
                    formaMultiplier = 1.1;
                    coordinationMode = #Solo;
                }
            };
            case (#Octopus) {
                {
                    caste = #Octopus;
                    primaryAction = "Adaptability and camouflage";
                    atlasReadSector = (3584, 4095);
                    atlasWriteSignal = #Construction;
                    formaMultiplier = 1.0;
                    coordinationMode = #Solo;
                }
            };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: FORMA DEPLETION REGRESSION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Handle FORMA depletion — organism regresses to Hive
    public func handleFormaDepletion(
        state : CasteState,
        formaThreshold : Float,
        currentBeat : Nat64
    ) : CasteState {
        // If FORMA drops below threshold, regress to Hive
        if (state.formaEnergy < formaThreshold) {
            // Boost Hive trait, suppress all others
            let regressionTraits : TraitVector = {
                crow = MIN_TRAIT_VALUE;
                dolphin = MIN_TRAIT_VALUE;
                hive = MAX_TRAIT_VALUE;  // Hive dominates
                elephant = MIN_TRAIT_VALUE;
                shark = MIN_TRAIT_VALUE;
                wolf = MIN_TRAIT_VALUE;
                orca = MIN_TRAIT_VALUE;
                eagle = MIN_TRAIT_VALUE;
                octopus = MIN_TRAIT_VALUE;
            };
            
            {
                currentCaste = #Hive;
                traits = regressionTraits;
                formaEnergy = state.formaEnergy;
                lastSwitchBeat = currentBeat;
                switchCount = state.switchCount + 1;
                casteHistory = Array.append([state.currentCaste], state.casteHistory);
                casteConfidence = 1.0;
                dominanceMargin = 0.9;
            }
        } else {
            state
        }
    };
    
    /// Get caste name as text
    public func casteName(caste : Caste) : Text {
        switch (caste) {
            case (#Crow) { "Crow" };
            case (#Dolphin) { "Dolphin" };
            case (#Hive) { "Hive" };
            case (#Elephant) { "Elephant" };
            case (#Shark) { "Shark" };
            case (#Wolf) { "Wolf" };
            case (#Orca) { "Orca" };
            case (#Eagle) { "Eagle" };
            case (#Octopus) { "Octopus" };
        }
    };
}
