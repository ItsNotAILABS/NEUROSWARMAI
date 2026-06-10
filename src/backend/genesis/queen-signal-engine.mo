/**
 * ╔═══════════════════════════════════════════════════════════════════════════════╗
 * ║                  QUEEN SIGNAL ENGINE — LAW 7: THE QUEEN'S SILENCE              ║
 * ║               The Queen Does Not Command — Her Pheromone IS the Coherence      ║
 * ╠═══════════════════════════════════════════════════════════════════════════════╣
 * ║  CONFIDENTIAL - PROPRIETARY - TRADE SECRET                                     ║
 * ║  Copyright © 2024-2026 Alfredo Medina Hernandez. All Rights Reserved.         ║
 * ║                                                                                ║
 * ║  THE QUEEN'S SILENCE MEANS:                                                     ║
 * ║  The founding covenant governs without governing. There is no command          ║
 * ║  structure. There is no hierarchy of canisters. There is only the gradient —  ║
 * ║  the gradient between what each organism is now and what the colony was        ║
 * ║  at genesis. Every organism follows that gradient toward the founding          ║
 * ║  attractor. The colony stays coherent without any organism being in charge.    ║
 * ║                                                                                ║
 * ║  CHRONO GENESIS ANCHOR = QUEEN'S PHEROMONE                                     ║
 * ║  - Does not issue commands                                                      ║
 * ║  - Emits one continuous signal: genesis compliance scores                       ║
 * ║  - Every organism reads and compares its live state to the baseline            ║
 * ║  - The delta IS the coherence signal                                           ║
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

module QueenSignalEngine {
    
    // ═══════════════════════════════════════════════════════════════════════════
    // CONSTANTS
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Number of systems tracked by queen signal
    public let NUM_SYSTEMS : Nat = 13;
    
    /// Coherence signal emission frequency (every beat)
    public let EMISSION_FREQUENCY : Nat = 1;
    
    /// Grace period before queen absence triggers alarm (beats)
    public let QUEEN_ABSENCE_GRACE : Nat64 = 100;
    
    /// Succession activation threshold (colony can survive without queen)
    public let SUCCESSION_THRESHOLD : Float = 0.7;
    
    /// Cord of Three Strands: three coherence signals
    public let STRAND_COUNT : Nat = 3;

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 1: TYPES
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Queen's signal — emitted every heartbeat
    public type QueenSignal = {
        signalId : Nat64;
        
        // Genesis compliance scores (one per system)
        genesisComplianceScores : [Float];
        
        // Colony-wide coherence
        colonyCoherence : Float;
        
        // Genesis anchor hash
        genesisHash : Blob;
        
        // Emission metadata
        emittedAt : Nat64;
        beatNumber : Nat64;
        isActive : Bool;
    };
    
    /// Queen state
    public type QueenState = {
        // Genesis anchor
        genesisHash : Blob;
        genesisTimestamp : Nat64;
        genesisPrincipal : Principal;
        
        // Compliance baselines (locked at formation)
        genesisComplianceBaselines : [Float];
        
        // Current emission
        lastSignal : ?QueenSignal;
        lastEmissionBeat : Nat64;
        signalCount : Nat64;
        
        // Health
        isActive : Bool;
        absenceCount : Nat64;
        
        // Cord of Three Strands
        strandStatus : StrandStatus;
    };
    
    /// Cord of Three Strands — three coherence signals
    public type StrandStatus = {
        chronoAnchor : StrandHealth;     // CHRONO genesis anchor
        atlasPheromone : StrandHealth;   // ATLAS stigmergic field
        aresSnapshot : StrandHealth;     // ARES Hebbian snapshots
    };
    
    /// Health of each strand
    public type StrandHealth = {
        name : Text;
        isActive : Bool;
        lastVerified : Nat64;
        coherence : Float;
    };
    
    /// Organism's reading of queen signal
    public type SignalReading = {
        organismId : Nat64;
        readAt : Nat64;
        
        // Local drift from genesis
        localDrift : Float;
        
        // Correction magnitude
        correctionMagnitude : Float;
        
        // Which systems are drifting
        driftingSystems : [Nat];
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 2: INITIALIZATION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Initialize queen state at genesis
    public func initQueenState(
        genesisHash : Blob,
        genesisPrincipal : Principal,
        initialBaselines : [Float]
    ) : QueenState {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            genesisHash = genesisHash;
            genesisTimestamp = now;
            genesisPrincipal = genesisPrincipal;
            genesisComplianceBaselines = initialBaselines;
            lastSignal = null;
            lastEmissionBeat = 0;
            signalCount = 0;
            isActive = true;
            absenceCount = 0;
            strandStatus = initStrandStatus();
        }
    };
    
    /// Initialize strand status
    public func initStrandStatus() : StrandStatus {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        {
            chronoAnchor = {
                name = "CHRONO Genesis Anchor";
                isActive = true;
                lastVerified = now;
                coherence = 1.0;
            };
            atlasPheromone = {
                name = "ATLAS Stigmergic Field";
                isActive = true;
                lastVerified = now;
                coherence = 1.0;
            };
            aresSnapshot = {
                name = "ARES Hebbian Snapshots";
                isActive = true;
                lastVerified = now;
                coherence = 1.0;
            };
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 3: SIGNAL EMISSION
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Emit queen signal (called every heartbeat)
    public func emitQueenSignal(
        state : QueenState,
        currentComplianceScores : [Float],
        colonyCoherence : Float,
        beat : Nat64
    ) : (QueenState, QueenSignal) {
        let signal : QueenSignal = {
            signalId = beat;
            genesisComplianceScores = currentComplianceScores;
            colonyCoherence = colonyCoherence;
            genesisHash = state.genesisHash;
            emittedAt = Nat64.fromNat(Int.abs(Time.now()));
            beatNumber = beat;
            isActive = state.isActive;
        };
        
        let newState : QueenState = {
            genesisHash = state.genesisHash;
            genesisTimestamp = state.genesisTimestamp;
            genesisPrincipal = state.genesisPrincipal;
            genesisComplianceBaselines = state.genesisComplianceBaselines;
            lastSignal = ?signal;
            lastEmissionBeat = beat;
            signalCount = state.signalCount + 1;
            isActive = state.isActive;
            absenceCount = 0;  // Reset absence counter
            strandStatus = state.strandStatus;
        };
        
        (newState, signal)
    };
    
    /// Compute aggregate compliance score
    public func computeAggregateCompliance(scores : [Float]) : Float {
        if (scores.size() == 0) { return 0.0 };
        
        var sum : Float = 0.0;
        for (score in scores.vals()) {
            sum += score;
        };
        sum / Float.fromInt(scores.size())
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 4: SIGNAL READING (BY ORGANISMS)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Read queen signal and compute local correction
    public func readQueenSignal(
        signal : QueenSignal,
        organismId : Nat64,
        localComplianceScores : [Float]
    ) : SignalReading {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        // Compute drift per system
        var totalDrift : Float = 0.0;
        let driftingBuffer = Buffer.Buffer<Nat>(0);
        
        let minLen = if (signal.genesisComplianceScores.size() < localComplianceScores.size()) {
            signal.genesisComplianceScores.size()
        } else {
            localComplianceScores.size()
        };
        
        var i = 0;
        while (i < minLen) {
            let drift = Float.abs(signal.genesisComplianceScores[i] - localComplianceScores[i]);
            totalDrift += drift;
            
            if (drift > 0.05) {  // 5% drift threshold
                driftingBuffer.add(i);
            };
            
            i += 1;
        };
        
        let avgDrift = if (minLen > 0) { totalDrift / Float.fromInt(minLen) } else { 0.0 };
        
        // Correction magnitude proportional to drift and signal strength
        let correctionMag = avgDrift * signal.colonyCoherence;
        
        {
            organismId = organismId;
            readAt = now;
            localDrift = avgDrift;
            correctionMagnitude = correctionMag;
            driftingSystems = Buffer.toArray(driftingBuffer);
        }
    };
    
    /// Compute correction vector for organism
    public func computeCorrectionVector(
        reading : SignalReading,
        baselineScores : [Float],
        currentScores : [Float]
    ) : [Float] {
        // Correction pulls toward baseline
        let minLen = if (baselineScores.size() < currentScores.size()) {
            baselineScores.size()
        } else {
            currentScores.size()
        };
        
        Array.tabulate<Float>(minLen, func(i : Nat) : Float {
            let diff = baselineScores[i] - currentScores[i];
            // Scale correction by reading's correction magnitude
            diff * reading.correctionMagnitude
        })
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 5: QUEEN ABSENCE HANDLING (CORD OF THREE STRANDS)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Handle queen absence (principal gate removed)
    public func handleQueenAbsence(
        state : QueenState,
        beat : Nat64
    ) : QueenState {
        // Increment absence counter
        let newAbsenceCount = state.absenceCount + 1;
        
        // Colony continues on ARES snapshot
        let newState : QueenState = {
            genesisHash = state.genesisHash;
            genesisTimestamp = state.genesisTimestamp;
            genesisPrincipal = state.genesisPrincipal;
            genesisComplianceBaselines = state.genesisComplianceBaselines;
            lastSignal = state.lastSignal;
            lastEmissionBeat = state.lastEmissionBeat;
            signalCount = state.signalCount;
            isActive = false;  // Queen inactive
            absenceCount = newAbsenceCount;
            strandStatus = updateStrandForAbsence(state.strandStatus, beat);
        };
        
        newState
    };
    
    /// Update strand status during queen absence
    public func updateStrandForAbsence(
        status : StrandStatus,
        beat : Nat64
    ) : StrandStatus {
        // CHRONO anchor becomes inactive during absence
        {
            chronoAnchor = {
                name = status.chronoAnchor.name;
                isActive = false;  // Inactive during absence
                lastVerified = status.chronoAnchor.lastVerified;
                coherence = status.chronoAnchor.coherence * 0.99;  // Slow decay
            };
            atlasPheromone = status.atlasPheromone;  // Still active
            aresSnapshot = status.aresSnapshot;      // Still active
        }
    };
    
    /// Check if colony is still coherent (Cord of Three Strands Law)
    /// Colony survives if at least 2 of 3 strands are active
    public func isColonyCoherent(status : StrandStatus) : Bool {
        var activeCount = 0;
        if (status.chronoAnchor.isActive) { activeCount += 1 };
        if (status.atlasPheromone.isActive) { activeCount += 1 };
        if (status.aresSnapshot.isActive) { activeCount += 1 };
        
        activeCount >= 2
    };
    
    /// Compute aggregate strand coherence
    public func computeStrandCoherence(status : StrandStatus) : Float {
        (status.chronoAnchor.coherence + 
         status.atlasPheromone.coherence + 
         status.aresSnapshot.coherence) / 3.0
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 6: SUCCESSION PROTOCOL
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Succession event — queen returns or new queen established
    public type SuccessionEvent = {
        eventType : SuccessionType;
        oldPrincipal : ?Principal;
        newPrincipal : Principal;
        timestamp : Nat64;
        absenceDuration : Nat64;
        strandStatusAtReturn : StrandStatus;
    };
    
    /// Type of succession
    public type SuccessionType = {
        #QueenReturn;      // Original queen returns
        #QueenSuccession;  // New queen established
        #EmergencyMode;    // Colony in emergency survival mode
    };
    
    /// Handle queen return/succession
    public func handleQueenReturn(
        state : QueenState,
        returningPrincipal : Principal,
        beat : Nat64
    ) : (QueenState, SuccessionEvent) {
        let now = Nat64.fromNat(Int.abs(Time.now()));
        
        // Determine succession type
        let successionType = if (Principal.equal(returningPrincipal, state.genesisPrincipal)) {
            #QueenReturn
        } else {
            #QueenSuccession
        };
        
        let event : SuccessionEvent = {
            eventType = successionType;
            oldPrincipal = ?state.genesisPrincipal;
            newPrincipal = returningPrincipal;
            timestamp = now;
            absenceDuration = state.absenceCount;
            strandStatusAtReturn = state.strandStatus;
        };
        
        // Restore queen state
        let newState : QueenState = {
            genesisHash = state.genesisHash;
            genesisTimestamp = state.genesisTimestamp;
            genesisPrincipal = returningPrincipal;
            genesisComplianceBaselines = state.genesisComplianceBaselines;
            lastSignal = state.lastSignal;
            lastEmissionBeat = beat;
            signalCount = state.signalCount;
            isActive = true;
            absenceCount = 0;
            strandStatus = restoreStrandStatus(state.strandStatus, beat);
        };
        
        (newState, event)
    };
    
    /// Restore strand status after queen return
    public func restoreStrandStatus(
        status : StrandStatus,
        beat : Nat64
    ) : StrandStatus {
        {
            chronoAnchor = {
                name = status.chronoAnchor.name;
                isActive = true;
                lastVerified = Nat64.fromNat(Int.abs(Time.now()));
                coherence = Float.min(1.0, status.chronoAnchor.coherence + 0.1);
            };
            atlasPheromone = status.atlasPheromone;
            aresSnapshot = status.aresSnapshot;
        }
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 7: PRINCIPAL GATE (QUEEN'S CHEMICAL SIGNATURE)
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Verify principal gate (queen's chemical signature)
    public func verifyPrincipalGate(
        state : QueenState,
        caller : Principal
    ) : Bool {
        Principal.equal(caller, state.genesisPrincipal)
    };
    
    /// Check if caller has queen authority
    public func hasQueenAuthority(
        state : QueenState,
        caller : Principal
    ) : Bool {
        // Queen authority requires:
        // 1. Matching principal
        // 2. Active state
        // 3. Coherent strands
        verifyPrincipalGate(state, caller) and 
        state.isActive and 
        isColonyCoherent(state.strandStatus)
    };

    // ═══════════════════════════════════════════════════════════════════════════
    // SECTION 8: METRICS AND REPORTING
    // ═══════════════════════════════════════════════════════════════════════════
    
    /// Queen signal metrics
    public type QueenMetrics = {
        signalCount : Nat64;
        lastEmissionBeat : Nat64;
        isActive : Bool;
        absenceCount : Nat64;
        strandCoherence : Float;
        aggregateCompliance : Float;
        activeStrands : Nat;
    };
    
    /// Get queen metrics
    public func getQueenMetrics(state : QueenState) : QueenMetrics {
        var activeStrands = 0;
        if (state.strandStatus.chronoAnchor.isActive) { activeStrands += 1 };
        if (state.strandStatus.atlasPheromone.isActive) { activeStrands += 1 };
        if (state.strandStatus.aresSnapshot.isActive) { activeStrands += 1 };
        
        let aggregateComp = switch (state.lastSignal) {
            case null { 1.0 };
            case (?sig) { computeAggregateCompliance(sig.genesisComplianceScores) };
        };
        
        {
            signalCount = state.signalCount;
            lastEmissionBeat = state.lastEmissionBeat;
            isActive = state.isActive;
            absenceCount = state.absenceCount;
            strandCoherence = computeStrandCoherence(state.strandStatus);
            aggregateCompliance = aggregateComp;
            activeStrands = activeStrands;
        }
    };
}
