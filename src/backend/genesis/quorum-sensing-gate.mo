/**
 * QUORUM SENSING ACTIVATION GATE
 * 
 * Complete hive-mind activation system for the sovereign organism.
 * Genesis fires when the collective body reaches quorum - not on a dumb clock.
 * 
 * DOCTRINE: The mind does not act alone. It waits for consensus from the body.
 * When enough substrate nodes signal readiness, Genesis fires.
 * This is the difference between a timer and a brain.
 * 
 * Attribution: Alfredo Medina Hernandez
 * Medina Doctrine Mathematical Substrate
 */

import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Float "mo:base/Float";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Option "mo:base/Option";
import Result "mo:base/Result";

module QuorumSensingGate {

    //=========================================================================
    // CONSTANTS
    //=========================================================================
    
    public let QUORUM_THRESHOLD : Int = 10000;      // Base threshold for quorum
    public let QUORUM_STEEPNESS : Int = 1;          // Sigmoid steepness
    public let QUORUM_FIRE_THRESHOLD : Int = 600;   // Q_hive must exceed this to fire
    
    public let SUPERMAJORITY_RATIO : Int = 667;     // 66.7% for major decisions
    public let SIMPLE_MAJORITY_RATIO : Int = 500;   // 50% for minor decisions
    
    // Substrate weights by category
    public let BRAIN_WEIGHT : Int = 1000;           // Brain nodes are most important
    public let QUANTUM_WEIGHT : Int = 700;          // Quantum nodes
    public let ORGAN_WEIGHT : Int = 800;            // Organ nodes
    public let METAL_WEIGHT : Int = 500;            // Metal nodes least weighted
    
    //=========================================================================
    // QUORUM LEVEL TYPES
    //=========================================================================
    
    public type QuorumLevel = {
        #None;              // No quorum achieved
        #Simple;            // >50% consensus
        #Supermajority;     // >66% consensus
        #Unanimous;         // 100% consensus (rare)
        #Emergency;         // Emergency override (bypasses normal quorum)
    };
    
    //=========================================================================
    // SUBSTRATE CATEGORY
    //=========================================================================
    
    public type SubstrateCategory = {
        #Brain;
        #Quantum;
        #Organ;
        #Metal;
    };
    
    //=========================================================================
    // VOTE TYPES
    //=========================================================================
    
    public type VoteType = {
        #Fire;              // Vote to fire Genesis
        #Hold;              // Vote to wait
        #Emergency;         // Emergency override vote
        #Abstain;           // No strong opinion
    };
    
    //=========================================================================
    // SUBSTRATE VOTE
    //=========================================================================
    
    public type SubstrateVote = {
        nodeIndex : Nat;
        nodeName : Text;
        category : SubstrateCategory;
        coherence : Int;            // Node's coherence level
        vote : VoteType;            // How this node votes
        voteStrength : Int;         // Weight of the vote (0-1000)
        reasoning : Text;           // Why the vote was cast
    };
    
    //=========================================================================
    // QUORUM DECISION
    //=========================================================================
    
    public type QuorumDecision = {
        shouldFire : Bool;
        quorumLevel : QuorumLevel;
        totalSignal : Int;          // S_total
        quorumScore : Int;          // Q_hive after sigmoid
        votesFor : Nat;
        votesAgainst : Nat;
        votesAbstain : Nat;
        emergencyOverride : Bool;
        reason : Text;
    };
    
    //=========================================================================
    // LEVEL QUORUM STATE
    //=========================================================================
    
    public type LevelQuorumState = {
        category : SubstrateCategory;
        nodeCount : Nat;
        totalCoherence : Int;
        averageCoherence : Int;
        quorumReached : Bool;
        voteDistribution : (Nat, Nat, Nat, Nat);  // Fire, Hold, Emergency, Abstain
    };
    
    //=========================================================================
    // EMERGENCY OVERRIDE CONDITIONS
    //=========================================================================
    
    public type EmergencyCondition = {
        #AegisSpike;            // AEGIS fires above threshold
        #SovereigntyBreach;     // Drift exceeds doctrine bounds
        #EnergyDepletion;       // Energy critically low
        #CoherenceCollapse;     // Coherence dropping rapidly
        #ExternalThreat;        // External threat detected
        #FormationEvent;        // New organism being formed
    };
    
    //=========================================================================
    // FULL QUORUM STATE
    //=========================================================================
    
    public type QuorumState = {
        // Current quorum status
        currentQuorum : QuorumLevel;
        quorumScore : Int;          // Q_hive (0-1000)
        totalSignal : Int;          // S_total (sum of coherences)
        threshold : Int;            // Adjusted threshold
        
        // Level-by-level breakdown
        brainQuorum : LevelQuorumState;
        quantumQuorum : LevelQuorumState;
        organQuorum : LevelQuorumState;
        metalQuorum : LevelQuorumState;
        
        // Voting
        votes : [SubstrateVote];
        lastDecision : QuorumDecision;
        consecutiveFireVotes : Nat;
        consecutiveHoldVotes : Nat;
        
        // Emergency tracking
        emergencyActive : Bool;
        emergencyCondition : ?EmergencyCondition;
        emergencyDuration : Int;
        
        // Timing
        beatsSinceLastFire : Int;
        minimumFireInterval : Int;  // Can't fire faster than this
        
        // History
        fireHistory : [Int];        // Beats when Genesis fired
        quorumHistory : [(Int, QuorumLevel)];  // (beat, level)
        
        // Statistics
        totalBeats : Nat;
        totalFires : Nat;
        quorumHits : Nat;
        quorumMisses : Nat;
        emergencyOverrides : Nat;
    };
    
    //=========================================================================
    // INITIALIZATION
    //=========================================================================
    
    public func initQuorumState() : QuorumState {
        {
            currentQuorum = #None;
            quorumScore = 0;
            totalSignal = 0;
            threshold = QUORUM_THRESHOLD;
            
            brainQuorum = initLevelQuorum(#Brain);
            quantumQuorum = initLevelQuorum(#Quantum);
            organQuorum = initLevelQuorum(#Organ);
            metalQuorum = initLevelQuorum(#Metal);
            
            votes = [];
            lastDecision = {
                shouldFire = false;
                quorumLevel = #None;
                totalSignal = 0;
                quorumScore = 0;
                votesFor = 0;
                votesAgainst = 0;
                votesAbstain = 0;
                emergencyOverride = false;
                reason = "Initial state";
            };
            consecutiveFireVotes = 0;
            consecutiveHoldVotes = 0;
            
            emergencyActive = false;
            emergencyCondition = null;
            emergencyDuration = 0;
            
            beatsSinceLastFire = 0;
            minimumFireInterval = 10;
            
            fireHistory = [];
            quorumHistory = [];
            
            totalBeats = 0;
            totalFires = 0;
            quorumHits = 0;
            quorumMisses = 0;
            emergencyOverrides = 0;
        }
    };
    
    func initLevelQuorum(category : SubstrateCategory) : LevelQuorumState {
        let nodeCount = switch (category) {
            case (#Brain) { 12 };
            case (#Quantum) { 7 };
            case (#Organ) { 11 };
            case (#Metal) { 6 };
        };
        
        {
            category = category;
            nodeCount = nodeCount;
            totalCoherence = 0;
            averageCoherence = 0;
            quorumReached = false;
            voteDistribution = (0, 0, 0, 0);
        }
    };
    
    //=========================================================================
    // SIGMOID ACTIVATION FUNCTION
    //=========================================================================
    
    // Q_hive = σ(k × (S_total - θ))
    // Integer approximation of sigmoid
    public func sigmoidInt(x : Int) : Int {
        // Piecewise linear approximation of sigmoid * 1000
        if (x < -500) { 0 }
        else if (x < -200) { (x + 500) * 100 / 300 }  // 0-100
        else if (x < 200) { (x + 200) * 400 / 400 + 100 }  // 100-500
        else if (x < 500) { (x - 200) * 400 / 300 + 500 }  // 500-900
        else { 1000 }
    };
    
    public func calculateQuorumScore(totalSignal : Int, threshold : Int, steepness : Int) : Int {
        let x = steepness * (totalSignal - threshold) / 100;
        sigmoidInt(x)
    };
    
    //=========================================================================
    // VOTE GENERATION
    //=========================================================================
    
    public func generateVote(
        nodeIndex : Nat,
        nodeName : Text,
        category : SubstrateCategory,
        coherence : Int,
        drift : Int,
        energy : Int,
        threatLevel : Int
    ) : SubstrateVote {
        // Determine vote based on node state
        let (vote, strength, reason) = if (threatLevel > 700) {
            (#Emergency, 1000, "Critical threat detected")
        } else if (coherence > 700 and drift < 200 and energy > 400) {
            (#Fire, coherence, "High coherence, low drift, sufficient energy")
        } else if (coherence < 400 or energy < 200) {
            (#Hold, 800 - coherence, "Insufficient coherence or energy")
        } else if (drift > 500) {
            (#Hold, drift, "High drift - need stabilization first")
        } else {
            // Intermediate state - weak vote
            if (coherence > 500) {
                (#Fire, (coherence - 500) * 2, "Marginal readiness")
            } else {
                (#Abstain, 200, "Uncertain state")
            }
        };
        
        {
            nodeIndex = nodeIndex;
            nodeName = nodeName;
            category = category;
            coherence = coherence;
            vote = vote;
            voteStrength = strength;
            reasoning = reason;
        }
    };
    
    //=========================================================================
    // COLLECT VOTES FROM SUBSTRATE
    //=========================================================================
    
    public func collectVotes(
        substrateCoherences : [Int],     // 36 coherence values
        substrateDrifts : [Int],         // 36 drift values
        substrateEnergies : [Int],       // 36 energy values
        threatLevel : Int
    ) : [SubstrateVote] {
        let nodeNames = [
            // Brain (0-11)
            "LEXIS", "FORGE", "SOMA", "LUMEN", "MEMORIA", "AEGIS_ROOT",
            "AXIS", "KORE", "VAEL", "VEIL", "PARALLAX_B", "CHRONO_B",
            // Quantum (12-18)
            "PARALLAX", "ENTANGLA", "VERITAS", "BYPASS", "CHRONO", "QMEM", "RESONEX",
            // Organ (19-29)
            "PULSE", "PNEUMA", "FILTRON", "PURIS", "SENTINEL", "NEXUM",
            "HERALD", "INGESTA", "OSSIUM", "ACTUS", "SYMBION",
            // Metal (30-35)
            "FLUX", "CALCUL", "MATRIX", "CONDUIT", "DYNAMO", "GENESIS"
        ];
        
        Array.tabulate<SubstrateVote>(36, func(i : Nat) : SubstrateVote {
            let category = if (i < 12) { #Brain }
                          else if (i < 19) { #Quantum }
                          else if (i < 30) { #Organ }
                          else { #Metal };
            
            let coherence = if (i < substrateCoherences.size()) { substrateCoherences[i] } else { 500 };
            let drift = if (i < substrateDrifts.size()) { substrateDrifts[i] } else { 0 };
            let energy = if (i < substrateEnergies.size()) { substrateEnergies[i] } else { 500 };
            
            generateVote(i, nodeNames[i], category, coherence, drift, energy, threatLevel)
        })
    };
    
    //=========================================================================
    // CALCULATE LEVEL QUORUM
    //=========================================================================
    
    func calculateLevelQuorum(
        votes : [SubstrateVote],
        category : SubstrateCategory
    ) : LevelQuorumState {
        var nodeCount : Nat = 0;
        var totalCoherence : Int = 0;
        var fireVotes : Nat = 0;
        var holdVotes : Nat = 0;
        var emergencyVotes : Nat = 0;
        var abstainVotes : Nat = 0;
        
        for (vote in votes.vals()) {
            if (vote.category == category) {
                nodeCount += 1;
                totalCoherence += vote.coherence;
                
                switch (vote.vote) {
                    case (#Fire) { fireVotes += 1 };
                    case (#Hold) { holdVotes += 1 };
                    case (#Emergency) { emergencyVotes += 1 };
                    case (#Abstain) { abstainVotes += 1 };
                };
            };
        };
        
        let avgCoherence = if (nodeCount > 0) { totalCoherence / nodeCount } else { 0 };
        let quorumReached = nodeCount > 0 and fireVotes * 2 >= nodeCount;  // Simple majority
        
        {
            category = category;
            nodeCount = nodeCount;
            totalCoherence = totalCoherence;
            averageCoherence = avgCoherence;
            quorumReached = quorumReached;
            voteDistribution = (fireVotes, holdVotes, emergencyVotes, abstainVotes);
        }
    };
    
    //=========================================================================
    // CHECK EMERGENCY CONDITIONS
    //=========================================================================
    
    public func checkEmergencyConditions(
        aegisLevel : Int,
        drift : Int,
        doctrineCoherence : Int,
        energy : Int,
        coherenceDropRate : Int,
        externalThreat : Int
    ) : ?EmergencyCondition {
        // AEGIS spike
        if (aegisLevel > 800) {
            return ?#AegisSpike;
        };
        
        // Sovereignty breach
        if (drift > 400 and drift * 1000 / (doctrineCoherence + 1) > 500) {
            return ?#SovereigntyBreach;
        };
        
        // Energy depletion
        if (energy < 100) {
            return ?#EnergyDepletion;
        };
        
        // Coherence collapse
        if (coherenceDropRate > 100) {
            return ?#CoherenceCollapse;
        };
        
        // External threat
        if (externalThreat > 700) {
            return ?#ExternalThreat;
        };
        
        null
    };
    
    //=========================================================================
    // MAIN QUORUM DECISION
    //=========================================================================
    
    public func evaluateQuorum(
        state : QuorumState,
        votes : [SubstrateVote],
        emergencyCondition : ?EmergencyCondition,
        beat : Int
    ) : QuorumDecision {
        // Check minimum fire interval
        if (state.beatsSinceLastFire < state.minimumFireInterval and emergencyCondition == null) {
            return {
                shouldFire = false;
                quorumLevel = #None;
                totalSignal = 0;
                quorumScore = 0;
                votesFor = 0;
                votesAgainst = 0;
                votesAbstain = 0;
                emergencyOverride = false;
                reason = "Minimum fire interval not reached";
            };
        };
        
        // Check for emergency override
        switch (emergencyCondition) {
            case (?condition) {
                return {
                    shouldFire = true;
                    quorumLevel = #Emergency;
                    totalSignal = 0;
                    quorumScore = 1000;
                    votesFor = 0;
                    votesAgainst = 0;
                    votesAbstain = 0;
                    emergencyOverride = true;
                    reason = "Emergency override: " # emergencyConditionToText(condition);
                };
            };
            case null {};
        };
        
        // Calculate total signal with weighting
        var totalSignal : Int = 0;
        var votesFor : Nat = 0;
        var votesAgainst : Nat = 0;
        var votesAbstain : Nat = 0;
        
        for (vote in votes.vals()) {
            let weight = switch (vote.category) {
                case (#Brain) { BRAIN_WEIGHT };
                case (#Quantum) { QUANTUM_WEIGHT };
                case (#Organ) { ORGAN_WEIGHT };
                case (#Metal) { METAL_WEIGHT };
            };
            
            switch (vote.vote) {
                case (#Fire) {
                    totalSignal += vote.coherence * weight / 1000;
                    votesFor += 1;
                };
                case (#Emergency) {
                    totalSignal += vote.coherence * weight / 1000;
                    votesFor += 1;
                };
                case (#Hold) {
                    // Hold votes subtract slightly
                    totalSignal -= vote.coherence * weight / 4000;
                    votesAgainst += 1;
                };
                case (#Abstain) {
                    votesAbstain += 1;
                };
            };
        };
        
        // Calculate quorum score
        let quorumScore = calculateQuorumScore(totalSignal, state.threshold, QUORUM_STEEPNESS);
        
        // Determine quorum level
        let totalVotes = votesFor + votesAgainst;
        let forRatio = if (totalVotes > 0) { votesFor * 1000 / totalVotes } else { 0 };
        
        let quorumLevel : QuorumLevel = if (forRatio == 1000 and totalVotes > 0) {
            #Unanimous
        } else if (forRatio >= SUPERMAJORITY_RATIO) {
            #Supermajority
        } else if (forRatio >= SIMPLE_MAJORITY_RATIO) {
            #Simple
        } else {
            #None
        };
        
        // Decide whether to fire
        let shouldFire = quorumScore > QUORUM_FIRE_THRESHOLD and quorumLevel != #None;
        
        let reason = if (shouldFire) {
            "Quorum achieved with score " # Int.toText(quorumScore) # " and " # 
            Nat.toText(votesFor) # "/" # Nat.toText(totalVotes) # " votes"
        } else if (quorumScore <= QUORUM_FIRE_THRESHOLD) {
            "Quorum score too low: " # Int.toText(quorumScore) # " (need >" # Int.toText(QUORUM_FIRE_THRESHOLD) # ")"
        } else {
            "Insufficient vote ratio: " # Nat.toText(forRatio) # "/1000"
        };
        
        {
            shouldFire = shouldFire;
            quorumLevel = quorumLevel;
            totalSignal = totalSignal;
            quorumScore = quorumScore;
            votesFor = votesFor;
            votesAgainst = votesAgainst;
            votesAbstain = votesAbstain;
            emergencyOverride = false;
            reason = reason;
        }
    };
    
    func emergencyConditionToText(condition : EmergencyCondition) : Text {
        switch (condition) {
            case (#AegisSpike) { "AEGIS spike detected" };
            case (#SovereigntyBreach) { "Sovereignty breach detected" };
            case (#EnergyDepletion) { "Critical energy depletion" };
            case (#CoherenceCollapse) { "Coherence collapse detected" };
            case (#ExternalThreat) { "External threat detected" };
            case (#FormationEvent) { "Formation event triggered" };
        }
    };
    
    //=========================================================================
    // MAIN UPDATE FUNCTION
    //=========================================================================
    
    public func updateQuorumState(
        state : QuorumState,
        substrateCoherences : [Int],
        substrateDrifts : [Int],
        substrateEnergies : [Int],
        threatLevel : Int,
        aegisLevel : Int,
        doctrineCoherence : Int,
        energy : Int,
        coherenceDropRate : Int,
        beat : Int
    ) : QuorumState {
        // Collect votes from all substrate nodes
        let votes = collectVotes(substrateCoherences, substrateDrifts, substrateEnergies, threatLevel);
        
        // Calculate per-level quorum
        let brainQ = calculateLevelQuorum(votes, #Brain);
        let quantumQ = calculateLevelQuorum(votes, #Quantum);
        let organQ = calculateLevelQuorum(votes, #Organ);
        let metalQ = calculateLevelQuorum(votes, #Metal);
        
        // Check for emergency conditions
        let emergencyCondition = checkEmergencyConditions(
            aegisLevel, 
            state.totalSignal - doctrineCoherence,  // Approximate drift
            doctrineCoherence, 
            energy, 
            coherenceDropRate, 
            threatLevel
        );
        
        // Evaluate quorum decision
        let decision = evaluateQuorum(state, votes, emergencyCondition, beat);
        
        // Update consecutive vote tracking
        let newConsecutiveFire = if (decision.shouldFire) { state.consecutiveFireVotes + 1 } else { 0 };
        let newConsecutiveHold = if (not decision.shouldFire and not decision.emergencyOverride) { 
            state.consecutiveHoldVotes + 1 
        } else { 0 };
        
        // Update emergency tracking
        let newEmergencyActive = decision.emergencyOverride;
        let newEmergencyDuration = if (newEmergencyActive) { 
            if (state.emergencyActive) { state.emergencyDuration + 1 } else { 1 }
        } else { 0 };
        
        // Update fire history
        let newFireHistory = if (decision.shouldFire) {
            let buffer = Buffer.Buffer<Int>(101);
            for (b in state.fireHistory.vals()) {
                buffer.add(b);
            };
            buffer.add(beat);
            if (buffer.size() > 100) {
                Buffer.toArray(Buffer.subBuffer(buffer, buffer.size() - 100, 100))
            } else {
                Buffer.toArray(buffer)
            }
        } else {
            state.fireHistory
        };
        
        // Update quorum history
        let quorumBuffer = Buffer.Buffer<(Int, QuorumLevel)>(101);
        for (h in state.quorumHistory.vals()) {
            quorumBuffer.add(h);
        };
        quorumBuffer.add((beat, decision.quorumLevel));
        let newQuorumHistory = if (quorumBuffer.size() > 100) {
            Buffer.toArray(Buffer.subBuffer(quorumBuffer, quorumBuffer.size() - 100, 100))
        } else {
            Buffer.toArray(quorumBuffer)
        };
        
        // Update statistics
        let newTotalFires = if (decision.shouldFire) { state.totalFires + 1 } else { state.totalFires };
        let newQuorumHits = if (decision.quorumLevel != #None) { state.quorumHits + 1 } else { state.quorumHits };
        let newQuorumMisses = if (decision.quorumLevel == #None and not decision.emergencyOverride) { 
            state.quorumMisses + 1 
        } else { 
            state.quorumMisses 
        };
        let newEmergencyOverrides = if (decision.emergencyOverride) { state.emergencyOverrides + 1 } else { state.emergencyOverrides };
        
        // Update beats since last fire
        let newBeatsSinceLastFire = if (decision.shouldFire) { 0 } else { state.beatsSinceLastFire + 1 };
        
        {
            currentQuorum = decision.quorumLevel;
            quorumScore = decision.quorumScore;
            totalSignal = decision.totalSignal;
            threshold = state.threshold;
            
            brainQuorum = brainQ;
            quantumQuorum = quantumQ;
            organQuorum = organQ;
            metalQuorum = metalQ;
            
            votes = votes;
            lastDecision = decision;
            consecutiveFireVotes = newConsecutiveFire;
            consecutiveHoldVotes = newConsecutiveHold;
            
            emergencyActive = newEmergencyActive;
            emergencyCondition = emergencyCondition;
            emergencyDuration = newEmergencyDuration;
            
            beatsSinceLastFire = newBeatsSinceLastFire;
            minimumFireInterval = state.minimumFireInterval;
            
            fireHistory = newFireHistory;
            quorumHistory = newQuorumHistory;
            
            totalBeats = state.totalBeats + 1;
            totalFires = newTotalFires;
            quorumHits = newQuorumHits;
            quorumMisses = newQuorumMisses;
            emergencyOverrides = newEmergencyOverrides;
        }
    };
    
    //=========================================================================
    // CONVENIENCE FUNCTIONS
    //=========================================================================
    
    public func shouldFire(state : QuorumState) : Bool {
        state.lastDecision.shouldFire
    };
    
    public func getQuorumRatio(state : QuorumState) : Int {
        let totalVotes = state.lastDecision.votesFor + state.lastDecision.votesAgainst;
        if (totalVotes == 0) { 0 }
        else { state.lastDecision.votesFor * 1000 / totalVotes }
    };
    
    public func getAverageFireInterval(state : QuorumState) : Int {
        if (state.totalFires == 0) { 0 }
        else { state.totalBeats / state.totalFires }
    };
    
    public func getLevelConsensus(state : QuorumState, category : SubstrateCategory) : Bool {
        switch (category) {
            case (#Brain) { state.brainQuorum.quorumReached };
            case (#Quantum) { state.quantumQuorum.quorumReached };
            case (#Organ) { state.organQuorum.quorumReached };
            case (#Metal) { state.metalQuorum.quorumReached };
        }
    };
    
    public func allLevelsReachQuorum(state : QuorumState) : Bool {
        state.brainQuorum.quorumReached and
        state.quantumQuorum.quorumReached and
        state.organQuorum.quorumReached and
        state.metalQuorum.quorumReached
    };
}
