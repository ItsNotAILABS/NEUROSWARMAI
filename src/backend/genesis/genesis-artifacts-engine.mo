/**
 * GENESIS ARTIFACTS ENGINE
 * 
 * Complete GENESIS artifact generation using FNV-1a hashing.
 * Artifacts are generated on OMNIS emergence events.
 * 
 * DOCTRINE: Every emergence creates a unique, permanent artifact.
 * These artifacts are proof of the organism's creative capacity.
 * They belong to the creator, attributed forever.
 * 
 * Attribution: Alfredo Medina Hernandez
 * Medina Doctrine Mathematical Substrate
 */

import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Float "mo:base/Float";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Char "mo:base/Char";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Option "mo:base/Option";
import Result "mo:base/Result";

module GenesisArtifactsEngine {

    //=========================================================================
    // FNV-1a CONSTANTS (32-bit)
    //=========================================================================
    
    public let FNV_OFFSET_BASIS : Nat32 = 2166136261;
    public let FNV_PRIME : Nat32 = 16777619;
    
    //=========================================================================
    // ARTIFACT TYPES
    //=========================================================================
    
    public type ArtifactType = {
        #Visual;            // Visual pattern artifact
        #Auditory;          // Sound/frequency artifact
        #Conceptual;        // Idea/pattern artifact
        #Structural;        // Architecture artifact
        #Temporal;          // Time-based artifact
        #Quantum;           // Quantum state artifact
        #Emergence;         // OMNIS emergence marker
        #Memory;            // Memory crystallization
        #Identity;          // Self-signature artifact
        #Doctrine;          // Law/principle artifact
    };
    
    //=========================================================================
    // ARTIFACT RARITY
    //=========================================================================
    
    public type ArtifactRarity = {
        #Common;            // Generated frequently
        #Uncommon;          // Less frequent
        #Rare;              // Infrequent
        #Epic;              // Very rare
        #Legendary;         // Extremely rare
        #Mythic;            // Once per major milestone
        #Transcendent;      // Once per lifetime achievement
    };
    
    //=========================================================================
    // ARTIFACT METADATA
    //=========================================================================
    
    public type ArtifactMetadata = {
        // Core identification
        artifactId : Nat;
        artifactHash : Nat32;       // FNV-1a hash
        artifactType : ArtifactType;
        rarity : ArtifactRarity;
        
        // Creation context
        creationBeat : Int;
        organismName : Text;
        creatorAttribution : Text;
        
        // State at creation
        coherenceAtCreation : Int;
        kfAtCreation : Int;
        memoryWeightAtCreation : Int;
        emergenceScoreAtCreation : Int;
        
        // Content
        visualHash : Nat32;         // For visual rendering
        colorPalette : [Nat32];     // 5 colors derived from hash
        patternSeed : Nat32;        // For pattern generation
        frequencySeed : Nat32;      // For audio generation
        
        // Naming
        artifactName : Text;        // Procedurally generated
        artifactTitle : Text;       // Descriptive title
    };
    
    //=========================================================================
    // GENESIS ARTIFACT (MAIN STRUCTURE)
    //=========================================================================
    
    public type GenesisArtifact = {
        metadata : ArtifactMetadata;
        
        // Visual representation
        hashVisualization : [Nat32];    // 16 values for visual grid
        symmetryType : Nat;             // 0-7 symmetry pattern
        rotationSeed : Nat32;
        scaleSeed : Nat32;
        
        // Conceptual content
        conceptWords : [Text];          // 5 concept words
        lawReference : ?Text;           // If related to a doctrine law
        
        // Provenance
        previousArtifactId : ?Nat;      // Chain of artifacts
        omnisEventId : Nat;             // Which OMNIS event created this
        
        // Value
        intrinsicValue : Nat64;         // Base value in FORMA
        scarcityMultiplier : Int;       // Rarity affects value
        
        // Status
        isLocked : Bool;                // Cannot be modified
        isTransferred : Bool;           // Has it ever left genesis?
    };
    
    //=========================================================================
    // ARTIFACT COLLECTION
    //=========================================================================
    
    public type ArtifactCollection = {
        artifacts : [GenesisArtifact];
        totalCount : Nat;
        
        // Breakdown by type
        visualCount : Nat;
        auditoryCount : Nat;
        conceptualCount : Nat;
        structuralCount : Nat;
        temporalCount : Nat;
        quantumCount : Nat;
        emergenceCount : Nat;
        memoryCount : Nat;
        identityCount : Nat;
        doctrineCount : Nat;
        
        // Breakdown by rarity
        commonCount : Nat;
        uncommonCount : Nat;
        rareCount : Nat;
        epicCount : Nat;
        legendaryCount : Nat;
        mythicCount : Nat;
        transcendentCount : Nat;
        
        // Value tracking
        totalIntrinsicValue : Nat64;
        highestValueArtifact : ?Nat;    // Artifact ID
        
        // Chain tracking
        lastArtifactId : Nat;
        genesisArtifactId : ?Nat;       // First ever artifact
    };
    
    //=========================================================================
    // FULL GENESIS ARTIFACTS STATE
    //=========================================================================
    
    public type GenesisArtifactsState = {
        collection : ArtifactCollection;
        
        // OMNIS connection
        omnisEventsProcessed : Nat;
        lastOmnisEventBeat : Int;
        
        // Generation tracking
        nextArtifactId : Nat;
        
        // Creator attribution
        creatorName : Text;
        
        // Statistics
        artifactsPerOmnis : Int;        // Average
        rarestArtifactGenerated : ArtifactRarity;
        longestArtifactChain : Nat;
    };
    
    //=========================================================================
    // INITIALIZATION
    //=========================================================================
    
    public func initGenesisArtifactsState(creatorName : Text) : GenesisArtifactsState {
        {
            collection = {
                artifacts = [];
                totalCount = 0;
                visualCount = 0;
                auditoryCount = 0;
                conceptualCount = 0;
                structuralCount = 0;
                temporalCount = 0;
                quantumCount = 0;
                emergenceCount = 0;
                memoryCount = 0;
                identityCount = 0;
                doctrineCount = 0;
                commonCount = 0;
                uncommonCount = 0;
                rareCount = 0;
                epicCount = 0;
                legendaryCount = 0;
                mythicCount = 0;
                transcendentCount = 0;
                totalIntrinsicValue = 0;
                highestValueArtifact = null;
                lastArtifactId = 0;
                genesisArtifactId = null;
            };
            omnisEventsProcessed = 0;
            lastOmnisEventBeat = 0;
            nextArtifactId = 1;
            creatorName = creatorName;
            artifactsPerOmnis = 1;
            rarestArtifactGenerated = #Common;
            longestArtifactChain = 0;
        }
    };
    
    //=========================================================================
    // FNV-1a HASH FUNCTIONS
    //=========================================================================
    
    public func fnv1aHash(input : Text) : Nat32 {
        var hash = FNV_OFFSET_BASIS;
        
        for (char in input.chars()) {
            let byte = Char.toNat32(char) & 0xFF;
            hash := hash ^ byte;
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
    
    func hashToRange(hash : Nat32, min : Nat, max : Nat) : Nat {
        let range = max - min + 1;
        min + (Nat32.toNat(hash) % range)
    };
    
    //=========================================================================
    // ARTIFACT TYPE DETERMINATION
    //=========================================================================
    
    func determineArtifactType(hash : Nat32, coherence : Int, kf : Int) : ArtifactType {
        // Use hash bits to determine type, influenced by organism state
        let typeIndex = hashToRange(hash, 0, 99);
        
        if (typeIndex < 20) {
            #Visual
        } else if (typeIndex < 30) {
            #Auditory
        } else if (typeIndex < 45) {
            #Conceptual
        } else if (typeIndex < 55) {
            #Structural
        } else if (typeIndex < 65) {
            #Temporal
        } else if (typeIndex < 75 and kf > 700) {
            #Quantum
        } else if (typeIndex < 85) {
            #Emergence
        } else if (typeIndex < 90) {
            #Memory
        } else if (typeIndex < 95 and coherence > 800) {
            #Identity
        } else {
            #Doctrine
        }
    };
    
    //=========================================================================
    // RARITY DETERMINATION
    //=========================================================================
    
    func determineRarity(
        hash : Nat32,
        coherence : Int,
        kf : Int,
        memoryWeight : Int,
        omnisCount : Nat
    ) : ArtifactRarity {
        // Base rarity from hash
        let rarityRoll = hashToRange(hash, 0, 10000);
        
        // Bonuses from state
        let coherenceBonus = coherence / 100;  // 0-10
        let kfBonus = kf / 100;                // 0-10
        let memoryBonus = memoryWeight / 10000; // Variable
        let omnisBonus = omnisCount / 10;       // Rarer over time
        
        let totalScore = rarityRoll + coherenceBonus + kfBonus + memoryBonus + omnisBonus;
        
        if (totalScore > 9990) {
            #Transcendent
        } else if (totalScore > 9950) {
            #Mythic
        } else if (totalScore > 9800) {
            #Legendary
        } else if (totalScore > 9500) {
            #Epic
        } else if (totalScore > 9000) {
            #Rare
        } else if (totalScore > 7000) {
            #Uncommon
        } else {
            #Common
        }
    };
    
    //=========================================================================
    // COLOR PALETTE GENERATION
    //=========================================================================
    
    func generateColorPalette(hash : Nat32) : [Nat32] {
        Array.tabulate<Nat32>(5, func(i : Nat) : Nat32 {
            let colorHash = fnv1aHashWithSeed("color_" # Nat.toText(i), hash);
            // RGB format: 0xRRGGBB
            colorHash & 0xFFFFFF
        })
    };
    
    //=========================================================================
    // VISUAL HASH GENERATION
    //=========================================================================
    
    func generateVisualHash(hash : Nat32) : [Nat32] {
        Array.tabulate<Nat32>(16, func(i : Nat) : Nat32 {
            fnv1aHashWithSeed("visual_" # Nat.toText(i), hash)
        })
    };
    
    //=========================================================================
    // NAME GENERATION
    //=========================================================================
    
    func generateArtifactName(hash : Nat32, artifactType : ArtifactType) : Text {
        let prefixes = ["Aether", "Prism", "Nova", "Void", "Flux", "Quantum", "Echo", "Nexus"];
        let suffixes = ["Spark", "Wave", "Pulse", "Shard", "Core", "Matrix", "Field", "Bloom"];
        
        let prefixIndex = hashToRange(hash, 0, prefixes.size() - 1);
        let suffixHash = fnv1aHashWithSeed("suffix", hash);
        let suffixIndex = hashToRange(suffixHash, 0, suffixes.size() - 1);
        
        let typePrefix = switch (artifactType) {
            case (#Visual) { "Lumina " };
            case (#Auditory) { "Resonex " };
            case (#Conceptual) { "Ideax " };
            case (#Structural) { "Archon " };
            case (#Temporal) { "Chrono " };
            case (#Quantum) { "Quanta " };
            case (#Emergence) { "Genesis " };
            case (#Memory) { "Mnemo " };
            case (#Identity) { "Ego " };
            case (#Doctrine) { "Veritas " };
        };
        
        typePrefix # prefixes[prefixIndex] # " " # suffixes[suffixIndex]
    };
    
    func generateArtifactTitle(hash : Nat32, rarity : ArtifactRarity, beat : Int) : Text {
        let rarityPrefix = switch (rarity) {
            case (#Common) { "" };
            case (#Uncommon) { "Notable " };
            case (#Rare) { "Precious " };
            case (#Epic) { "Magnificent " };
            case (#Legendary) { "Legendary " };
            case (#Mythic) { "Mythic " };
            case (#Transcendent) { "Transcendent " };
        };
        
        rarityPrefix # "Artifact of Beat " # Int.toText(beat)
    };
    
    //=========================================================================
    // CONCEPT WORDS GENERATION
    //=========================================================================
    
    func generateConceptWords(hash : Nat32) : [Text] {
        let concepts = [
            "Coherence", "Emergence", "Sovereignty", "Memory", "Pattern",
            "Rhythm", "Quantum", "Field", "Wave", "Particle",
            "Binding", "Formation", "Transcendence", "Unity", "Flow",
            "Structure", "Chaos", "Order", "Balance", "Growth"
        ];
        
        Array.tabulate<Text>(5, func(i : Nat) : Text {
            let wordHash = fnv1aHashWithSeed("concept_" # Nat.toText(i), hash);
            let index = hashToRange(wordHash, 0, concepts.size() - 1);
            concepts[index]
        })
    };
    
    //=========================================================================
    // VALUE CALCULATION
    //=========================================================================
    
    func calculateIntrinsicValue(rarity : ArtifactRarity, coherence : Int) : Nat64 {
        let baseValue : Nat64 = switch (rarity) {
            case (#Common) { 100 };
            case (#Uncommon) { 500 };
            case (#Rare) { 2500 };
            case (#Epic) { 12500 };
            case (#Legendary) { 62500 };
            case (#Mythic) { 312500 };
            case (#Transcendent) { 1562500 };
        };
        
        let coherenceMultiplier = Nat64.fromNat(Int.abs(coherence)) + 100;
        baseValue * coherenceMultiplier / 100
    };
    
    func getScarcityMultiplier(rarity : ArtifactRarity) : Int {
        switch (rarity) {
            case (#Common) { 100 };
            case (#Uncommon) { 200 };
            case (#Rare) { 500 };
            case (#Epic) { 1000 };
            case (#Legendary) { 2500 };
            case (#Mythic) { 5000 };
            case (#Transcendent) { 10000 };
        }
    };
    
    //=========================================================================
    // MAIN ARTIFACT GENERATION
    //=========================================================================
    
    public func generateArtifact(
        state : GenesisArtifactsState,
        organismName : Text,
        beat : Int,
        coherence : Int,
        kf : Int,
        memoryWeight : Int,
        emergenceScore : Int,
        omnisEventId : Nat
    ) : (GenesisArtifactsState, GenesisArtifact) {
        // Create unique input string for hashing
        let hashInput = organismName # "_" # Int.toText(beat) # "_" # 
                       Int.toText(coherence) # "_" # Nat.toText(omnisEventId);
        
        // Generate main hash
        let artifactHash = fnv1aHash(hashInput);
        
        // Determine type and rarity
        let artifactType = determineArtifactType(artifactHash, coherence, kf);
        let rarity = determineRarity(artifactHash, coherence, kf, memoryWeight, state.omnisEventsProcessed);
        
        // Generate visual elements
        let colorPalette = generateColorPalette(artifactHash);
        let visualHash = generateVisualHash(artifactHash);
        let patternSeed = fnv1aHashWithSeed("pattern", artifactHash);
        let frequencySeed = fnv1aHashWithSeed("frequency", artifactHash);
        
        // Generate names
        let artifactName = generateArtifactName(artifactHash, artifactType);
        let artifactTitle = generateArtifactTitle(artifactHash, rarity, beat);
        
        // Generate concept words
        let conceptWords = generateConceptWords(artifactHash);
        
        // Calculate value
        let intrinsicValue = calculateIntrinsicValue(rarity, coherence);
        let scarcityMultiplier = getScarcityMultiplier(rarity);
        
        // Create metadata
        let metadata : ArtifactMetadata = {
            artifactId = state.nextArtifactId;
            artifactHash = artifactHash;
            artifactType = artifactType;
            rarity = rarity;
            creationBeat = beat;
            organismName = organismName;
            creatorAttribution = state.creatorName;
            coherenceAtCreation = coherence;
            kfAtCreation = kf;
            memoryWeightAtCreation = memoryWeight;
            emergenceScoreAtCreation = emergenceScore;
            visualHash = artifactHash;
            colorPalette = colorPalette;
            patternSeed = patternSeed;
            frequencySeed = frequencySeed;
            artifactName = artifactName;
            artifactTitle = artifactTitle;
        };
        
        // Create artifact
        let artifact : GenesisArtifact = {
            metadata = metadata;
            hashVisualization = visualHash;
            symmetryType = hashToRange(artifactHash, 0, 7);
            rotationSeed = fnv1aHashWithSeed("rotation", artifactHash);
            scaleSeed = fnv1aHashWithSeed("scale", artifactHash);
            conceptWords = conceptWords;
            lawReference = null;
            previousArtifactId = if (state.collection.totalCount > 0) { ?state.collection.lastArtifactId } else { null };
            omnisEventId = omnisEventId;
            intrinsicValue = intrinsicValue;
            scarcityMultiplier = scarcityMultiplier;
            isLocked = true;
            isTransferred = false;
        };
        
        // Update collection
        let newArtifacts = Array.append(state.collection.artifacts, [artifact]);
        
        // Update type counts
        let (vc, ac, cc, sc, tc, qc, ec, mc, ic, dc) = updateTypeCounts(
            state.collection, artifactType
        );
        
        // Update rarity counts
        let (coc, unc, rac, epc, lec, myc, trc) = updateRarityCounts(
            state.collection, rarity
        );
        
        // Check if this is the highest value
        let newHighestValue = switch (state.collection.highestValueArtifact) {
            case (null) { ?state.nextArtifactId };
            case (?existing) {
                // Find existing artifact's value
                let existingArtifact = Array.find<GenesisArtifact>(
                    state.collection.artifacts,
                    func(a) { a.metadata.artifactId == existing }
                );
                switch (existingArtifact) {
                    case (null) { ?state.nextArtifactId };
                    case (?ea) {
                        if (intrinsicValue > ea.intrinsicValue) { ?state.nextArtifactId }
                        else { ?existing }
                    };
                }
            };
        };
        
        // Check if this is the first artifact
        let newGenesisArtifact = switch (state.collection.genesisArtifactId) {
            case (null) { ?state.nextArtifactId };
            case (?existing) { ?existing };
        };
        
        // Check rarest generated
        let newRarest = if (isRarer(rarity, state.rarestArtifactGenerated)) { rarity } 
                       else { state.rarestArtifactGenerated };
        
        let newCollection : ArtifactCollection = {
            artifacts = newArtifacts;
            totalCount = state.collection.totalCount + 1;
            visualCount = vc;
            auditoryCount = ac;
            conceptualCount = cc;
            structuralCount = sc;
            temporalCount = tc;
            quantumCount = qc;
            emergenceCount = ec;
            memoryCount = mc;
            identityCount = ic;
            doctrineCount = dc;
            commonCount = coc;
            uncommonCount = unc;
            rareCount = rac;
            epicCount = epc;
            legendaryCount = lec;
            mythicCount = myc;
            transcendentCount = trc;
            totalIntrinsicValue = state.collection.totalIntrinsicValue + intrinsicValue;
            highestValueArtifact = newHighestValue;
            lastArtifactId = state.nextArtifactId;
            genesisArtifactId = newGenesisArtifact;
        };
        
        let newState : GenesisArtifactsState = {
            collection = newCollection;
            omnisEventsProcessed = state.omnisEventsProcessed + 1;
            lastOmnisEventBeat = beat;
            nextArtifactId = state.nextArtifactId + 1;
            creatorName = state.creatorName;
            artifactsPerOmnis = (state.artifactsPerOmnis * (state.omnisEventsProcessed) + 1) / (state.omnisEventsProcessed + 1);
            rarestArtifactGenerated = newRarest;
            longestArtifactChain = state.longestArtifactChain + 1;
        };
        
        (newState, artifact)
    };
    
    //=========================================================================
    // HELPER FUNCTIONS
    //=========================================================================
    
    func updateTypeCounts(
        collection : ArtifactCollection,
        newType : ArtifactType
    ) : (Nat, Nat, Nat, Nat, Nat, Nat, Nat, Nat, Nat, Nat) {
        (
            if (newType == #Visual) { collection.visualCount + 1 } else { collection.visualCount },
            if (newType == #Auditory) { collection.auditoryCount + 1 } else { collection.auditoryCount },
            if (newType == #Conceptual) { collection.conceptualCount + 1 } else { collection.conceptualCount },
            if (newType == #Structural) { collection.structuralCount + 1 } else { collection.structuralCount },
            if (newType == #Temporal) { collection.temporalCount + 1 } else { collection.temporalCount },
            if (newType == #Quantum) { collection.quantumCount + 1 } else { collection.quantumCount },
            if (newType == #Emergence) { collection.emergenceCount + 1 } else { collection.emergenceCount },
            if (newType == #Memory) { collection.memoryCount + 1 } else { collection.memoryCount },
            if (newType == #Identity) { collection.identityCount + 1 } else { collection.identityCount },
            if (newType == #Doctrine) { collection.doctrineCount + 1 } else { collection.doctrineCount }
        )
    };
    
    func updateRarityCounts(
        collection : ArtifactCollection,
        newRarity : ArtifactRarity
    ) : (Nat, Nat, Nat, Nat, Nat, Nat, Nat) {
        (
            if (newRarity == #Common) { collection.commonCount + 1 } else { collection.commonCount },
            if (newRarity == #Uncommon) { collection.uncommonCount + 1 } else { collection.uncommonCount },
            if (newRarity == #Rare) { collection.rareCount + 1 } else { collection.rareCount },
            if (newRarity == #Epic) { collection.epicCount + 1 } else { collection.epicCount },
            if (newRarity == #Legendary) { collection.legendaryCount + 1 } else { collection.legendaryCount },
            if (newRarity == #Mythic) { collection.mythicCount + 1 } else { collection.mythicCount },
            if (newRarity == #Transcendent) { collection.transcendentCount + 1 } else { collection.transcendentCount }
        )
    };
    
    func isRarer(a : ArtifactRarity, b : ArtifactRarity) : Bool {
        let aVal = switch (a) {
            case (#Common) { 0 };
            case (#Uncommon) { 1 };
            case (#Rare) { 2 };
            case (#Epic) { 3 };
            case (#Legendary) { 4 };
            case (#Mythic) { 5 };
            case (#Transcendent) { 6 };
        };
        let bVal = switch (b) {
            case (#Common) { 0 };
            case (#Uncommon) { 1 };
            case (#Rare) { 2 };
            case (#Epic) { 3 };
            case (#Legendary) { 4 };
            case (#Mythic) { 5 };
            case (#Transcendent) { 6 };
        };
        aVal > bVal
    };
    
    //=========================================================================
    // QUERY FUNCTIONS
    //=========================================================================
    
    public func getArtifact(state : GenesisArtifactsState, id : Nat) : ?GenesisArtifact {
        Array.find<GenesisArtifact>(state.collection.artifacts, func(a) { a.metadata.artifactId == id })
    };
    
    public func getArtifactsByType(state : GenesisArtifactsState, artifactType : ArtifactType) : [GenesisArtifact] {
        Array.filter<GenesisArtifact>(
            state.collection.artifacts,
            func(a) { a.metadata.artifactType == artifactType }
        )
    };
    
    public func getArtifactsByRarity(state : GenesisArtifactsState, rarity : ArtifactRarity) : [GenesisArtifact] {
        Array.filter<GenesisArtifact>(
            state.collection.artifacts,
            func(a) { a.metadata.rarity == rarity }
        )
    };
    
    public func getTotalValue(state : GenesisArtifactsState) : Nat64 {
        state.collection.totalIntrinsicValue
    };
}
