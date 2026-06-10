/**
 * PERSONALITY SEED GENERATOR
 * 
 * Complete FNV-1a based identity system for sovereign organisms.
 * Each organism has a permanent, unchangeable personality fingerprint
 * derived from its name and formation beat.
 * 
 * DOCTRINE: Identity is not random - it is deterministic from origin.
 * The same formation conditions always produce the same personality.
 * This makes organisms reproducible but unique.
 * 
 * Attribution: Alfredo Medina Hernandez
 * Medina Doctrine Mathematical Substrate
 */

import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
import Float "mo:base/Float";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Option "mo:base/Option";

module PersonalitySeedGenerator {

    //=========================================================================
    // FNV-1a CONSTANTS (32-bit)
    //=========================================================================
    
    public let FNV_OFFSET_BASIS : Nat32 = 2166136261;
    public let FNV_PRIME : Nat32 = 16777619;
    
    //=========================================================================
    // PERSONALITY TRAIT DEFINITIONS
    //=========================================================================
    
    public type PersonalityTrait = {
        #Stability;         // Resistance to drift
        #Exploratory;       // Eagerness to expand
        #Sociality;         // Trust formation speed
        #Aggression;        // Emergency threshold
        #Patience;          // Consolidation preference
        #Creativity;        // Pattern generation
        #Caution;           // Risk assessment
        #Persistence;       // Drive maintenance
        #Adaptability;      // Learning rate
        #Empathy;           // Social responsiveness
        #Resilience;        // Recovery speed
        #Curiosity;         // Novelty seeking
    };
    
    public let TRAIT_COUNT : Nat = 12;
    
    //=========================================================================
    // SUBSTRATE AFFINITY TYPES
    //=========================================================================
    
    public type SubstrateAffinity = {
        nodeIndex : Nat;        // Which substrate node (0-35)
        nodeName : Text;        // Human-readable name
        affinity : Int;         // -500 to +500 (0 = neutral)
        category : Text;        // Brain/Quantum/Organ/Metal
    };
    
    //=========================================================================
    // DRIVE BIAS TYPES
    //=========================================================================
    
    public type DriveBias = {
        driveIndex : Nat;       // Which drive (0-9)
        driveName : Text;
        bias : Int;             // -200 to +200
    };
    
    //=========================================================================
    // FULL PERSONALITY FINGERPRINT
    //=========================================================================
    
    public type PersonalityFingerprint = {
        // Core identity
        seedHash : Nat32;               // Raw FNV-1a hash
        organismName : Text;            // Name used for hashing
        formationBeat : Int;            // Beat used for hashing
        
        // Personality traits (12 values, 0-1000)
        traits : [Int];
        traitLabels : [Text];
        
        // Drive biases (10 values, -200 to +200)
        driveBiases : [DriveBias];
        
        // Substrate affinities (36 values, -500 to +500)
        substrateAffinities : [SubstrateAffinity];
        
        // Derived characteristics
        dominantTrait : Text;
        suppressedTrait : Text;
        preferredDrive : Text;
        avoidedDrive : Text;
        strongestAffinity : Text;
        weakestAffinity : Text;
        
        // Noise seeds (for consistent randomness)
        noiseSeeds : [Nat32];           // 16 seeds for various uses
        
        // Overall personality profile
        introversion : Int;             // 0-1000 (1000 = highly introverted)
        stability : Int;                // 0-1000 (1000 = highly stable)
        openness : Int;                 // 0-1000 (1000 = highly open)
        agreeableness : Int;            // 0-1000 (1000 = highly agreeable)
        conscientiousness : Int;        // 0-1000 (1000 = highly conscientious)
    };
    
    //=========================================================================
    // FNV-1a HASH IMPLEMENTATION
    //=========================================================================
    
    public func fnv1aHash(input : Text) : Nat32 {
        var hash = FNV_OFFSET_BASIS;
        
        for (char in input.chars()) {
            let byte = Char.toNat32(char) & 0xFF;
            hash := hash ^ byte;
            hash := hash *% FNV_PRIME;  // Wrapping multiplication
        };
        
        hash
    };
    
    public func fnv1aHashBytes(bytes : [Nat8]) : Nat32 {
        var hash = FNV_OFFSET_BASIS;
        
        for (byte in bytes.vals()) {
            hash := hash ^ Nat32.fromNat(Nat8.toNat(byte));
            hash := hash *% FNV_PRIME;
        };
        
        hash
    };
    
    public func fnv1aHashWithSeed(input : Text, seed : Nat32) : Nat32 {
        var hash = seed;
        
        for (char in input.chars()) {
            let byte = Char.toNat32(char) & 0xFF;
            hash := hash ^ byte;
            hash := hash *% FNV_PRIME;
        };
        
        hash
    };
    
    //=========================================================================
    // EXTRACT BYTES FROM HASH
    //=========================================================================
    
    func extractByte(hash : Nat32, byteIndex : Nat) : Nat {
        let shift = byteIndex * 8;
        Nat32.toNat((hash >> Nat32.fromNat(shift)) & 0xFF)
    };
    
    func hashToInt(hash : Nat32, min : Int, max : Int) : Int {
        let range = max - min + 1;
        let normalized = Nat32.toNat(hash) % range;
        min + normalized
    };
    
    //=========================================================================
    // GENERATE PERSONALITY TRAITS
    //=========================================================================
    
    func generateTraits(baseHash : Nat32) : ([Int], [Text]) {
        let traitLabels = [
            "Stability",
            "Exploratory",
            "Sociality",
            "Aggression",
            "Patience",
            "Creativity",
            "Caution",
            "Persistence",
            "Adaptability",
            "Empathy",
            "Resilience",
            "Curiosity"
        ];
        
        let traits = Array.tabulate<Int>(TRAIT_COUNT, func(i : Nat) : Int {
            // Hash each trait separately
            let traitHash = fnv1aHashWithSeed(traitLabels[i], baseHash);
            // Map to 0-1000 range
            hashToInt(traitHash, 0, 1000)
        });
        
        (traits, traitLabels)
    };
    
    //=========================================================================
    // GENERATE DRIVE BIASES
    //=========================================================================
    
    func generateDriveBiases(baseHash : Nat32) : [DriveBias] {
        let driveNames = [
            "Cohere",
            "DriftHold",
            "Expand",
            "Consolidate",
            "Emergency",
            "Nurture",
            "Create",
            "Protect",
            "Rest",
            "Explore"
        ];
        
        Array.tabulate<DriveBias>(10, func(i : Nat) : DriveBias {
            let driveHash = fnv1aHashWithSeed(driveNames[i] # "_drive", baseHash);
            let bias = hashToInt(driveHash, -200, 200);
            
            {
                driveIndex = i;
                driveName = driveNames[i];
                bias = bias;
            }
        })
    };
    
    //=========================================================================
    // GENERATE SUBSTRATE AFFINITIES
    //=========================================================================
    
    func generateSubstrateAffinities(baseHash : Nat32) : [SubstrateAffinity] {
        let substrates = [
            // Brain (0-11)
            ("LEXIS", "Brain"), ("FORGE", "Brain"), ("SOMA", "Brain"),
            ("LUMEN", "Brain"), ("MEMORIA", "Brain"), ("AEGIS_ROOT", "Brain"),
            ("AXIS", "Brain"), ("KORE", "Brain"), ("VAEL", "Brain"),
            ("VEIL", "Brain"), ("PARALLAX_B", "Brain"), ("CHRONO_B", "Brain"),
            
            // Quantum (12-18)
            ("PARALLAX", "Quantum"), ("ENTANGLA", "Quantum"), ("VERITAS", "Quantum"),
            ("BYPASS", "Quantum"), ("CHRONO", "Quantum"), ("QMEM", "Quantum"),
            ("RESONEX", "Quantum"),
            
            // Organ (19-29)
            ("PULSE", "Organ"), ("PNEUMA", "Organ"), ("FILTRON", "Organ"),
            ("PURIS", "Organ"), ("SENTINEL", "Organ"), ("NEXUM", "Organ"),
            ("HERALD", "Organ"), ("INGESTA", "Organ"), ("OSSIUM", "Organ"),
            ("ACTUS", "Organ"), ("SYMBION", "Organ"),
            
            // Metal (30-35)
            ("FLUX", "Metal"), ("CALCUL", "Metal"), ("MATRIX", "Metal"),
            ("CONDUIT", "Metal"), ("DYNAMO", "Metal"), ("GENESIS", "Metal")
        ];
        
        Array.tabulate<SubstrateAffinity>(36, func(i : Nat) : SubstrateAffinity {
            let (name, category) = substrates[i];
            let affinityHash = fnv1aHashWithSeed(name # "_affinity", baseHash);
            let affinity = hashToInt(affinityHash, -500, 500);
            
            {
                nodeIndex = i;
                nodeName = name;
                affinity = affinity;
                category = category;
            }
        })
    };
    
    //=========================================================================
    // GENERATE NOISE SEEDS
    //=========================================================================
    
    func generateNoiseSeeds(baseHash : Nat32) : [Nat32] {
        Array.tabulate<Nat32>(16, func(i : Nat) : Nat32 {
            let seedInput = "noise_" # Nat.toText(i);
            fnv1aHashWithSeed(seedInput, baseHash)
        })
    };
    
    //=========================================================================
    // CALCULATE BIG FIVE PERSONALITY FACTORS
    //=========================================================================
    
    func calculateBigFive(traits : [Int]) : (Int, Int, Int, Int, Int) {
        // Introversion: high caution + high patience - high exploratory - high sociality
        let introversion = (traits[6] + traits[4] - traits[1] - traits[2] + 1000) / 2;
        
        // Stability: high stability + high resilience + high patience
        let stabilityScore = (traits[0] + traits[10] + traits[4]) / 3;
        
        // Openness: high creativity + high curiosity + high exploratory
        let openness = (traits[5] + traits[11] + traits[1]) / 3;
        
        // Agreeableness: high empathy + high sociality - high aggression
        let agreeableness = (traits[9] + traits[2] - traits[3] + 1000) / 2;
        
        // Conscientiousness: high persistence + high caution + high patience
        let conscientiousness = (traits[7] + traits[6] + traits[4]) / 3;
        
        (
            if (introversion > 1000) { 1000 } else if (introversion < 0) { 0 } else { introversion },
            if (stabilityScore > 1000) { 1000 } else if (stabilityScore < 0) { 0 } else { stabilityScore },
            if (openness > 1000) { 1000 } else if (openness < 0) { 0 } else { openness },
            if (agreeableness > 1000) { 1000 } else if (agreeableness < 0) { 0 } else { agreeableness },
            if (conscientiousness > 1000) { 1000 } else if (conscientiousness < 0) { 0 } else { conscientiousness }
        )
    };
    
    //=========================================================================
    // FIND DOMINANT/SUPPRESSED
    //=========================================================================
    
    func findDominantSuppressed(values : [Int], labels : [Text]) : (Text, Text) {
        var maxVal : Int = -999999;
        var minVal : Int = 999999;
        var maxLabel = "";
        var minLabel = "";
        
        for (i in values.keys()) {
            if (values[i] > maxVal) {
                maxVal := values[i];
                maxLabel := labels[i];
            };
            if (values[i] < minVal) {
                minVal := values[i];
                minLabel := labels[i];
            };
        };
        
        (maxLabel, minLabel)
    };
    
    func findPreferredAvoided(biases : [DriveBias]) : (Text, Text) {
        var maxBias : Int = -999999;
        var minBias : Int = 999999;
        var preferred = "";
        var avoided = "";
        
        for (bias in biases.vals()) {
            if (bias.bias > maxBias) {
                maxBias := bias.bias;
                preferred := bias.driveName;
            };
            if (bias.bias < minBias) {
                minBias := bias.bias;
                avoided := bias.driveName;
            };
        };
        
        (preferred, avoided)
    };
    
    func findStrongestWeakest(affinities : [SubstrateAffinity]) : (Text, Text) {
        var maxAff : Int = -999999;
        var minAff : Int = 999999;
        var strongest = "";
        var weakest = "";
        
        for (aff in affinities.vals()) {
            if (aff.affinity > maxAff) {
                maxAff := aff.affinity;
                strongest := aff.nodeName;
            };
            if (aff.affinity < minAff) {
                minAff := aff.affinity;
                weakest := aff.nodeName;
            };
        };
        
        (strongest, weakest)
    };
    
    //=========================================================================
    // MAIN GENERATION FUNCTION
    //=========================================================================
    
    public func generatePersonalityFingerprint(
        organismName : Text,
        formationBeat : Int
    ) : PersonalityFingerprint {
        // Create unique identity string
        let identityString = organismName # "_" # Int.toText(formationBeat);
        
        // Generate base hash
        let baseHash = fnv1aHash(identityString);
        
        // Generate all components
        let (traits, traitLabels) = generateTraits(baseHash);
        let driveBiases = generateDriveBiases(baseHash);
        let substrateAffinities = generateSubstrateAffinities(baseHash);
        let noiseSeeds = generateNoiseSeeds(baseHash);
        
        // Find extremes
        let (dominantTrait, suppressedTrait) = findDominantSuppressed(traits, traitLabels);
        let (preferredDrive, avoidedDrive) = findPreferredAvoided(driveBiases);
        let (strongestAffinity, weakestAffinity) = findStrongestWeakest(substrateAffinities);
        
        // Calculate Big Five
        let (introversion, stability, openness, agreeableness, conscientiousness) = calculateBigFive(traits);
        
        {
            seedHash = baseHash;
            organismName = organismName;
            formationBeat = formationBeat;
            
            traits = traits;
            traitLabels = traitLabels;
            
            driveBiases = driveBiases;
            substrateAffinities = substrateAffinities;
            
            dominantTrait = dominantTrait;
            suppressedTrait = suppressedTrait;
            preferredDrive = preferredDrive;
            avoidedDrive = avoidedDrive;
            strongestAffinity = strongestAffinity;
            weakestAffinity = weakestAffinity;
            
            noiseSeeds = noiseSeeds;
            
            introversion = introversion;
            stability = stability;
            openness = openness;
            agreeableness = agreeableness;
            conscientiousness = conscientiousness;
        }
    };
    
    //=========================================================================
    // EXTRACT VALUES FOR OTHER SYSTEMS
    //=========================================================================
    
    public func getTraitValue(fingerprint : PersonalityFingerprint, trait : PersonalityTrait) : Int {
        let index = switch (trait) {
            case (#Stability) { 0 };
            case (#Exploratory) { 1 };
            case (#Sociality) { 2 };
            case (#Aggression) { 3 };
            case (#Patience) { 4 };
            case (#Creativity) { 5 };
            case (#Caution) { 6 };
            case (#Persistence) { 7 };
            case (#Adaptability) { 8 };
            case (#Empathy) { 9 };
            case (#Resilience) { 10 };
            case (#Curiosity) { 11 };
        };
        fingerprint.traits[index]
    };
    
    public func getDriveBiasArray(fingerprint : PersonalityFingerprint) : [Int] {
        Array.map<DriveBias, Int>(fingerprint.driveBiases, func(b : DriveBias) : Int { b.bias })
    };
    
    public func getSubstrateAffinityArray(fingerprint : PersonalityFingerprint) : [Int] {
        Array.map<SubstrateAffinity, Int>(fingerprint.substrateAffinities, func(a : SubstrateAffinity) : Int { a.affinity })
    };
    
    //=========================================================================
    // GAUSSIAN NOISE FROM SEED
    //=========================================================================
    
    // Box-Muller approximation using integer math
    public func gaussianNoise(seed : Nat32, index : Nat) : Int {
        // Generate two uniform random values
        let u1Hash = fnv1aHashWithSeed(Nat.toText(index), seed);
        let u2Hash = fnv1aHashWithSeed(Nat.toText(index + 1), seed);
        
        // Convert to range (0, 1) * 1000
        let u1 = (Nat32.toNat(u1Hash) % 998) + 1;  // 1-999
        let u2 = (Nat32.toNat(u2Hash) % 1000);     // 0-999
        
        // Simplified Box-Muller (approximation)
        // cos(2π * u2) approximated
        let cosApprox = if (u2 < 250) { 1000 - u2 * 4 }
                       else if (u2 < 500) { (u2 - 250) * 4 - 1000 }
                       else if (u2 < 750) { (u2 - 500) * 4 - 1000 }
                       else { 1000 - (u2 - 750) * 4 };
        
        // sqrt(-2 * ln(u1)) approximated for u1 in (0,1)
        // Using rough approximation: sqrt(-2*ln(x)) ≈ 2.5 for x around 0.5
        let sqrtApprox = 2500 - u1 * 2;  // Simple linear approximation
        
        // Result scaled to roughly -300 to +300
        (sqrtApprox * cosApprox) / 10000
    };
    
    public func getNoiseForDrive(fingerprint : PersonalityFingerprint, driveIndex : Nat, beat : Int) : Int {
        let seedIndex = driveIndex % 16;
        let seed = fingerprint.noiseSeeds[seedIndex];
        let combinedSeed = seed ^ Nat32.fromNat(Int.abs(beat) % 4294967296);
        gaussianNoise(combinedSeed, driveIndex)
    };
    
    //=========================================================================
    // PERSONALITY COMPATIBILITY
    //=========================================================================
    
    public func calculateCompatibility(
        fingerprint1 : PersonalityFingerprint,
        fingerprint2 : PersonalityFingerprint
    ) : Int {
        var compatScore : Int = 500;  // Start neutral
        
        // Trait similarity (similar traits = compatible)
        var traitDiffSum : Int = 0;
        for (i in fingerprint1.traits.keys()) {
            let diff = Int.abs(fingerprint1.traits[i] - fingerprint2.traits[i]);
            traitDiffSum += diff;
        };
        let traitSimilarity = 1000 - (traitDiffSum / TRAIT_COUNT);
        compatScore += traitSimilarity / 5;
        
        // Big Five complementarity
        // High agreeableness helps compatibility
        compatScore += (fingerprint1.agreeableness + fingerprint2.agreeableness) / 10;
        
        // Similar stability is good
        let stabilityDiff = Int.abs(fingerprint1.stability - fingerprint2.stability);
        compatScore -= stabilityDiff / 10;
        
        // Introvert-extrovert balance (opposites can work)
        let introExtroBalance = Int.abs(fingerprint1.introversion - fingerprint2.introversion);
        if (introExtroBalance > 300 and introExtroBalance < 700) {
            compatScore += 50;  // Complementary
        };
        
        // Clamp to valid range
        if (compatScore > 1000) { 1000 }
        else if (compatScore < 0) { 0 }
        else { compatScore }
    };
    
    //=========================================================================
    // PERSONALITY DESCRIPTION
    //=========================================================================
    
    public func describePersonality(fingerprint : PersonalityFingerprint) : Text {
        var desc = "Organism " # fingerprint.organismName # " (formed at beat " # Int.toText(fingerprint.formationBeat) # "): ";
        
        // Introversion
        desc #= if (fingerprint.introversion > 700) { "Highly introverted, " }
               else if (fingerprint.introversion > 500) { "Somewhat introverted, " }
               else if (fingerprint.introversion > 300) { "Balanced, " }
               else { "Extroverted, " };
        
        // Stability
        desc #= if (fingerprint.stability > 700) { "very stable, " }
               else if (fingerprint.stability > 400) { "moderately stable, " }
               else { "volatile, " };
        
        // Openness
        desc #= if (fingerprint.openness > 700) { "highly creative, " }
               else if (fingerprint.openness > 400) { "moderately open, " }
               else { "conventional, " };
        
        // Dominant trait
        desc #= "strongest in " # fingerprint.dominantTrait # ", ";
        desc #= "weakest in " # fingerprint.suppressedTrait # ". ";
        
        // Drive preference
        desc #= "Naturally drawn to " # fingerprint.preferredDrive # ", ";
        desc #= "avoids " # fingerprint.avoidedDrive # ".";
        
        desc
    };
}
