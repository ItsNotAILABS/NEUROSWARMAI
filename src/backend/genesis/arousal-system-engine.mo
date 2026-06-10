/**
 * AROUSAL SYSTEM ENGINE
 * 
 * Complete arousal/stress/recovery implementation for the sovereign organism.
 * Arousal modulates all downstream computation - from memory encoding to drive selection.
 * 
 * DOCTRINE: Arousal is NOT just excitement. It is the organism's readiness state.
 * High arousal = vigilant, threat-focused, fast responses
 * Low arousal = consolidation, recovery, deep processing
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

module ArousalSystemEngine {

    //=========================================================================
    // AROUSAL LEVEL THRESHOLDS
    //=========================================================================
    
    public let AROUSAL_DEEP_REST : Int = 200;      // Below this = deep rest/recovery
    public let AROUSAL_LOW : Int = 400;            // KORE/consolidation dominant
    public let AROUSAL_MODERATE : Int = 600;       // Balanced state
    public let AROUSAL_HIGH : Int = 800;           // VAEL/AEGIS amplified
    public let AROUSAL_CRITICAL : Int = 1000;      // Emergency mode ceiling
    
    public let AROUSAL_DECAY_RATE : Int = 950;     // A(t+1) = A(t) * 950/1000
    public let AROUSAL_SCALE : Int = 1000;
    
    //=========================================================================
    // STIMULI WEIGHTS
    //=========================================================================
    
    public let STIMULI_DRIFT_WEIGHT : Int = 200;           // drift × 200 / 100
    public let STIMULI_COHERENCE_DROP_WEIGHT : Int = 300;  // (prevC - C) × 300 / 100
    public let STIMULI_KF_DROP_WEIGHT : Int = 150;         // (prevKf - Kf) × 150 / 100
    public let STIMULI_AEGIS_SPIKE : Int = 400;            // +400 on AEGIS fire
    public let STIMULI_OMNIS_SPIKE : Int = 800;            // +800 on OMNIS emergence
    public let STIMULI_DANGER_WEIGHT : Int = 500;          // driftDanger × 500 / 100
    public let STIMULI_NOVEL_WEIGHT : Int = 250;           // novelty × 250 / 100
    public let STIMULI_SOCIAL_WEIGHT : Int = 100;          // social signal × 100 / 100
    
    //=========================================================================
    // AROUSAL LEVEL ENUMERATION
    //=========================================================================
    
    public type ArousalLevel = {
        #DeepRest;      // < 200: Recovery dominant, minimal activity
        #Low;           // 200-400: KORE/consolidation dominant
        #Moderate;      // 400-600: Balanced processing
        #High;          // 600-800: VAEL/AEGIS amplified, vigilant
        #Critical;      // > 800: Emergency mode, survival focus
    };
    
    //=========================================================================
    // STIMULUS TYPE
    //=========================================================================
    
    public type StimulusType = {
        #Drift;             // Deviation from doctrine
        #CoherenceDrop;     // Loss of coherence
        #KfDrop;            // Loss of frequency coherence
        #AegisFire;         // AEGIS activation event
        #OmnisEmergence;    // OMNIS emergence event
        #DangerZone;        // Entity in danger zone
        #Novelty;           // Novel stimulus detected
        #Social;            // Social signal received
        #Threat;            // Direct threat detected
        #Reward;            // Positive outcome
        #Pain;              // Negative outcome
        #Startle;           // Sudden unexpected event
    };
    
    //=========================================================================
    // STIMULUS EVENT
    //=========================================================================
    
    public type StimulusEvent = {
        stimulusType : StimulusType;
        magnitude : Int;        // Raw magnitude of stimulus
        timestamp : Int;        // When it occurred
        source : Text;          // Where it came from
        processed : Bool;       // Whether it's been processed
    };
    
    //=========================================================================
    // STRESS RESPONSE CASCADE
    //=========================================================================
    
    public type StressResponseState = {
        // HPA Axis (Hypothalamic-Pituitary-Adrenal)
        cortisolLevel : Int;            // 0-1000, stress hormone analog
        cortisolPeak : Int;             // Recent peak level
        cortisolBaseline : Int;         // Long-term baseline
        
        // Sympathetic nervous system
        norepinephrineLevel : Int;      // 0-1000, fight-or-flight
        adrenalineLevel : Int;          // 0-1000, immediate response
        
        // Parasympathetic nervous system
        acetylcholineLevel : Int;       // 0-1000, rest-and-digest
        vagalTone : Int;                // 0-1000, vagus nerve activity
        
        // Allostatic load (cumulative stress burden)
        allostaticLoad : Int;           // Cumulative, can grow unbounded
        recoveryDebt : Int;             // How much recovery is needed
        
        // Time tracking
        stressOnsetBeat : Int;          // When stress started
        stressDurationBeats : Int;      // How long stressed
        lastRecoveryBeat : Int;         // When last recovered
    };
    
    //=========================================================================
    // MODULATION TARGETS
    //=========================================================================
    
    public type ArousalModulation = {
        // Substrate weight modulation
        vaelWeightMultiplier : Int;     // VAEL amplification (1000 = 1.0×)
        aegisWeightMultiplier : Int;    // AEGIS amplification
        koreWeightMultiplier : Int;     // KORE suppression when aroused
        memoriaWeightMultiplier : Int;  // Memory substrate
        
        // Processing modulation
        memoryEncodingMultiplier : Int; // Stronger encoding when aroused
        learningRateMultiplier : Int;   // Faster learning when aroused
        attentionFocusMultiplier : Int; // Narrower attention when aroused
        processingSpeedMultiplier : Int;// Faster but shallower
        
        // Threshold modulation
        fireThresholdOffset : Int;      // Lower threshold when aroused
        emergencyThresholdOffset : Int; // Lower emergency trigger
        consolidationThresholdOffset : Int; // Higher consolidation threshold
    };
    
    //=========================================================================
    // CIRCADIAN MODULATION
    //=========================================================================
    
    public type CircadianPhase = {
        #Morning;       // High arousal baseline
        #Midday;        // Peak arousal capacity
        #Afternoon;     // Declining arousal
        #Evening;       // Low arousal, consolidation
        #Night;         // Minimal arousal, recovery
        #DeepNight;     // Deepest rest, maximum recovery
    };
    
    public type CircadianState = {
        currentPhase : CircadianPhase;
        phaseProgress : Int;            // 0-1000 within phase
        baselineModifier : Int;         // Circadian effect on arousal baseline
        recoveryModifier : Int;         // Circadian effect on recovery rate
        cycleCount : Nat;               // How many full cycles completed
    };
    
    //=========================================================================
    // AROUSAL HISTORY
    //=========================================================================
    
    public type ArousalHistoryEntry = {
        beat : Int;
        arousalLevel : Int;
        stimuliSum : Int;
        level : ArousalLevel;
        dominantStimulus : ?StimulusType;
    };
    
    //=========================================================================
    // FULL AROUSAL STATE
    //=========================================================================
    
    public type ArousalState = {
        // Core arousal
        currentArousal : Int;           // Current arousal level (0-1000+)
        baselineArousal : Int;          // Long-term baseline (adapts slowly)
        peakArousal : Int;              // Recent peak
        troughArousal : Int;            // Recent trough
        
        // Arousal classification
        currentLevel : ArousalLevel;
        levelDurationBeats : Int;       // How long at current level
        
        // Stress response
        stressResponse : StressResponseState;
        
        // Modulation outputs
        modulation : ArousalModulation;
        
        // Circadian rhythm
        circadian : CircadianState;
        
        // Stimulus buffer
        recentStimuli : [StimulusEvent];
        stimuliSum : Int;               // Sum of recent stimuli
        
        // History
        arousalHistory : [ArousalHistoryEntry];
        averageArousal : Int;           // Moving average
        arousalVariance : Int;          // Variance measure
        
        // Recovery tracking
        recoveryRate : Int;             // Current recovery rate
        sleepPressure : Int;            // Adenosine analog (builds with activity)
        fatigueLevel : Int;             // Accumulated fatigue
        
        // Statistics
        totalBeats : Nat;
        highArousalBeats : Nat;
        lowArousalBeats : Nat;
        criticalEvents : Nat;
    };
    
    //=========================================================================
    // INITIALIZATION
    //=========================================================================
    
    public func initArousalState() : ArousalState {
        {
            currentArousal = 500;       // Start at moderate
            baselineArousal = 500;
            peakArousal = 500;
            troughArousal = 500;
            
            currentLevel = #Moderate;
            levelDurationBeats = 0;
            
            stressResponse = {
                cortisolLevel = 200;
                cortisolPeak = 200;
                cortisolBaseline = 200;
                norepinephrineLevel = 100;
                adrenalineLevel = 50;
                acetylcholineLevel = 500;
                vagalTone = 600;
                allostaticLoad = 0;
                recoveryDebt = 0;
                stressOnsetBeat = 0;
                stressDurationBeats = 0;
                lastRecoveryBeat = 0;
            };
            
            modulation = initModulation();
            
            circadian = {
                currentPhase = #Morning;
                phaseProgress = 0;
                baselineModifier = 100;
                recoveryModifier = 80;
                cycleCount = 0;
            };
            
            recentStimuli = [];
            stimuliSum = 0;
            
            arousalHistory = [];
            averageArousal = 500;
            arousalVariance = 0;
            
            recoveryRate = 50;
            sleepPressure = 0;
            fatigueLevel = 0;
            
            totalBeats = 0;
            highArousalBeats = 0;
            lowArousalBeats = 0;
            criticalEvents = 0;
        }
    };
    
    func initModulation() : ArousalModulation {
        {
            vaelWeightMultiplier = 1000;
            aegisWeightMultiplier = 1000;
            koreWeightMultiplier = 1000;
            memoriaWeightMultiplier = 1000;
            memoryEncodingMultiplier = 1000;
            learningRateMultiplier = 1000;
            attentionFocusMultiplier = 1000;
            processingSpeedMultiplier = 1000;
            fireThresholdOffset = 0;
            emergencyThresholdOffset = 0;
            consolidationThresholdOffset = 0;
        }
    };
    
    //=========================================================================
    // STIMULUS PROCESSING
    //=========================================================================
    
    public func processStimulus(
        stimType : StimulusType,
        magnitude : Int,
        beat : Int,
        source : Text
    ) : StimulusEvent {
        {
            stimulusType = stimType;
            magnitude = magnitude;
            timestamp = beat;
            source = source;
            processed = false;
        }
    };
    
    public func calculateStimulusContribution(event : StimulusEvent) : Int {
        let baseMag = event.magnitude;
        switch (event.stimulusType) {
            case (#Drift) { baseMag * STIMULI_DRIFT_WEIGHT / 100 };
            case (#CoherenceDrop) { baseMag * STIMULI_COHERENCE_DROP_WEIGHT / 100 };
            case (#KfDrop) { baseMag * STIMULI_KF_DROP_WEIGHT / 100 };
            case (#AegisFire) { STIMULI_AEGIS_SPIKE };
            case (#OmnisEmergence) { STIMULI_OMNIS_SPIKE };
            case (#DangerZone) { baseMag * STIMULI_DANGER_WEIGHT / 100 };
            case (#Novelty) { baseMag * STIMULI_NOVEL_WEIGHT / 100 };
            case (#Social) { baseMag * STIMULI_SOCIAL_WEIGHT / 100 };
            case (#Threat) { baseMag * 400 / 100 };
            case (#Reward) { baseMag * 50 / 100 };  // Mild arousal increase
            case (#Pain) { baseMag * 600 / 100 };
            case (#Startle) { baseMag * 800 / 100 };
        }
    };
    
    //=========================================================================
    // AROUSAL UPDATE (CORE EQUATION)
    //=========================================================================
    
    // A(t+1) = A(t) × decay + stimuli(t) - recovery(t) + circadian_baseline
    public func updateArousal(
        state : ArousalState,
        newStimuli : [StimulusEvent],
        beat : Int
    ) : ArousalState {
        // Calculate total stimuli contribution
        var stimuliTotal : Int = 0;
        for (stim in newStimuli.vals()) {
            stimuliTotal += calculateStimulusContribution(stim);
        };
        
        // Apply circadian modulation to baseline
        let circadianBaseline = state.circadian.baselineModifier * state.baselineArousal / 1000;
        
        // Apply recovery (stronger when arousal is high)
        let recoveryAmount = if (state.currentArousal > AROUSAL_HIGH) {
            state.recoveryRate * state.circadian.recoveryModifier / 100
        } else if (state.currentArousal < AROUSAL_LOW) {
            state.recoveryRate * state.circadian.recoveryModifier / 200  // Slower recovery when already low
        } else {
            state.recoveryRate * state.circadian.recoveryModifier / 150
        };
        
        // Core arousal update equation
        let decayedArousal = state.currentArousal * AROUSAL_DECAY_RATE / AROUSAL_SCALE;
        var newArousal = decayedArousal + stimuliTotal - recoveryAmount;
        
        // Pull toward circadian baseline
        let baselinePull = (circadianBaseline - newArousal) / 20;  // Slow pull
        newArousal := newArousal + baselinePull;
        
        // Clamp to valid range (can exceed 1000 in extreme cases)
        if (newArousal < 0) { newArousal := 0 };
        if (newArousal > 2000) { newArousal := 2000 };  // Allow overshoot in extreme stress
        
        // Determine new level
        let newLevel = classifyArousalLevel(newArousal);
        
        // Update level duration
        let newLevelDuration = if (newLevel == state.currentLevel) {
            state.levelDurationBeats + 1
        } else { 0 };
        
        // Update peak/trough
        let newPeak = if (newArousal > state.peakArousal) { newArousal } else {
            // Decay peak toward current
            (state.peakArousal * 990 + newArousal * 10) / 1000
        };
        let newTrough = if (newArousal < state.troughArousal) { newArousal } else {
            // Decay trough toward current
            (state.troughArousal * 990 + newArousal * 10) / 1000
        };
        
        // Update baseline (very slow adaptation)
        let newBaseline = (state.baselineArousal * 999 + newArousal) / 1000;
        
        // Update stress response
        let newStressResponse = updateStressResponse(state.stressResponse, newArousal, stimuliTotal, beat);
        
        // Update modulation outputs
        let newModulation = calculateModulation(newArousal, newStressResponse);
        
        // Update circadian
        let newCircadian = updateCircadian(state.circadian, beat);
        
        // Update sleep pressure (adenosine builds with activity)
        let activityLevel = stimuliTotal + Int.abs(newArousal - state.baselineArousal);
        let newSleepPressure = state.sleepPressure + activityLevel / 100;
        
        // Update fatigue
        let newFatigue = if (newArousal > AROUSAL_HIGH) {
            state.fatigueLevel + 2
        } else if (newArousal < AROUSAL_LOW) {
            if (state.fatigueLevel > 0) { state.fatigueLevel - 1 } else { 0 }
        } else {
            state.fatigueLevel
        };
        
        // Find dominant stimulus
        var dominantStim : ?StimulusType = null;
        var maxContrib : Int = 0;
        for (stim in newStimuli.vals()) {
            let contrib = calculateStimulusContribution(stim);
            if (contrib > maxContrib) {
                maxContrib := contrib;
                dominantStim := ?stim.stimulusType;
            };
        };
        
        // Create history entry
        let historyEntry : ArousalHistoryEntry = {
            beat = beat;
            arousalLevel = newArousal;
            stimuliSum = stimuliTotal;
            level = newLevel;
            dominantStimulus = dominantStim;
        };
        
        // Update history (keep last 1000)
        let historyBuffer = Buffer.Buffer<ArousalHistoryEntry>(1001);
        for (entry in state.arousalHistory.vals()) {
            historyBuffer.add(entry);
        };
        historyBuffer.add(historyEntry);
        let newHistory = if (historyBuffer.size() > 1000) {
            Buffer.toArray(Buffer.subBuffer(historyBuffer, historyBuffer.size() - 1000, 1000))
        } else {
            Buffer.toArray(historyBuffer)
        };
        
        // Calculate average and variance
        var arousalSum : Int = 0;
        for (entry in newHistory.vals()) {
            arousalSum += entry.arousalLevel;
        };
        let newAverage = if (newHistory.size() > 0) {
            arousalSum / newHistory.size()
        } else { newArousal };
        
        var varianceSum : Int = 0;
        for (entry in newHistory.vals()) {
            let diff = entry.arousalLevel - newAverage;
            varianceSum += diff * diff / 1000;
        };
        let newVariance = if (newHistory.size() > 0) {
            varianceSum / newHistory.size()
        } else { 0 };
        
        // Update statistics
        let newHighBeats = if (newArousal > AROUSAL_HIGH) { state.highArousalBeats + 1 } else { state.highArousalBeats };
        let newLowBeats = if (newArousal < AROUSAL_LOW) { state.lowArousalBeats + 1 } else { state.lowArousalBeats };
        let newCriticalEvents = if (newArousal > AROUSAL_CRITICAL) { state.criticalEvents + 1 } else { state.criticalEvents };
        
        // Update stimuli buffer (keep last 50)
        let stimBuffer = Buffer.Buffer<StimulusEvent>(51);
        for (stim in state.recentStimuli.vals()) {
            stimBuffer.add(stim);
        };
        for (stim in newStimuli.vals()) {
            stimBuffer.add({
                stimulusType = stim.stimulusType;
                magnitude = stim.magnitude;
                timestamp = stim.timestamp;
                source = stim.source;
                processed = true;
            });
        };
        let newRecentStimuli = if (stimBuffer.size() > 50) {
            Buffer.toArray(Buffer.subBuffer(stimBuffer, stimBuffer.size() - 50, 50))
        } else {
            Buffer.toArray(stimBuffer)
        };
        
        {
            currentArousal = newArousal;
            baselineArousal = newBaseline;
            peakArousal = newPeak;
            troughArousal = newTrough;
            
            currentLevel = newLevel;
            levelDurationBeats = newLevelDuration;
            
            stressResponse = newStressResponse;
            modulation = newModulation;
            circadian = newCircadian;
            
            recentStimuli = newRecentStimuli;
            stimuliSum = stimuliTotal;
            
            arousalHistory = newHistory;
            averageArousal = newAverage;
            arousalVariance = newVariance;
            
            recoveryRate = state.recoveryRate;
            sleepPressure = newSleepPressure;
            fatigueLevel = newFatigue;
            
            totalBeats = state.totalBeats + 1;
            highArousalBeats = newHighBeats;
            lowArousalBeats = newLowBeats;
            criticalEvents = newCriticalEvents;
        }
    };
    
    //=========================================================================
    // AROUSAL LEVEL CLASSIFICATION
    //=========================================================================
    
    public func classifyArousalLevel(arousal : Int) : ArousalLevel {
        if (arousal < AROUSAL_DEEP_REST) { #DeepRest }
        else if (arousal < AROUSAL_LOW) { #Low }
        else if (arousal < AROUSAL_MODERATE) { #Moderate }
        else if (arousal < AROUSAL_HIGH) { #High }
        else { #Critical }
    };
    
    //=========================================================================
    // STRESS RESPONSE UPDATE
    //=========================================================================
    
    func updateStressResponse(
        state : StressResponseState,
        arousal : Int,
        stimuli : Int,
        beat : Int
    ) : StressResponseState {
        // Cortisol dynamics (slow rise, slow fall)
        let cortisolTarget = if (arousal > AROUSAL_HIGH) {
            800 + stimuli / 5
        } else if (arousal > AROUSAL_MODERATE) {
            400 + stimuli / 10
        } else {
            state.cortisolBaseline
        };
        let newCortisol = (state.cortisolLevel * 980 + cortisolTarget * 20) / 1000;
        let newCortisolPeak = if (newCortisol > state.cortisolPeak) { newCortisol } else {
            (state.cortisolPeak * 995 + newCortisol * 5) / 1000
        };
        
        // Norepinephrine (fast rise, fast fall)
        let neTarget = if (stimuli > 200) {
            500 + stimuli
        } else {
            100
        };
        let newNE = (state.norepinephrineLevel * 900 + neTarget * 100) / 1000;
        
        // Adrenaline (very fast spike, medium decay)
        let adrenalineSpike = if (stimuli > 400) { stimuli - 200 } else { 0 };
        let newAdrenaline = (state.adrenalineLevel * 850 + adrenalineSpike * 150) / 1000;
        
        // Acetylcholine (parasympathetic - inverse of stress)
        let achTarget = 1000 - arousal;
        let newACh = (state.acetylcholineLevel * 950 + achTarget * 50) / 1000;
        
        // Vagal tone (slow adaptation)
        let vagalTarget = if (arousal < AROUSAL_LOW) { 800 } else if (arousal > AROUSAL_HIGH) { 200 } else { 500 };
        let newVagal = (state.vagalTone * 990 + vagalTarget * 10) / 1000;
        
        // Allostatic load (cumulative, never fully recovers)
        let loadIncrease = if (arousal > AROUSAL_HIGH) { arousal - AROUSAL_HIGH } else { 0 };
        let newAllostaticLoad = state.allostaticLoad + loadIncrease / 100;
        
        // Recovery debt
        let debtIncrease = if (arousal > AROUSAL_MODERATE) { (arousal - AROUSAL_MODERATE) / 10 } else { 0 };
        let debtRecovery = if (arousal < AROUSAL_LOW) { 5 } else { 0 };
        var newRecoveryDebt = state.recoveryDebt + debtIncrease - debtRecovery;
        if (newRecoveryDebt < 0) { newRecoveryDebt := 0 };
        
        // Stress timing
        let isStressed = arousal > AROUSAL_MODERATE;
        let newStressOnset = if (isStressed and state.stressDurationBeats == 0) { beat } else { state.stressOnsetBeat };
        let newStressDuration = if (isStressed) { state.stressDurationBeats + 1 } else { 0 };
        let newLastRecovery = if (not isStressed and state.stressDurationBeats > 0) { beat } else { state.lastRecoveryBeat };
        
        {
            cortisolLevel = newCortisol;
            cortisolPeak = newCortisolPeak;
            cortisolBaseline = (state.cortisolBaseline * 999 + newCortisol) / 1000;
            norepinephrineLevel = newNE;
            adrenalineLevel = newAdrenaline;
            acetylcholineLevel = newACh;
            vagalTone = newVagal;
            allostaticLoad = newAllostaticLoad;
            recoveryDebt = newRecoveryDebt;
            stressOnsetBeat = newStressOnset;
            stressDurationBeats = newStressDuration;
            lastRecoveryBeat = newLastRecovery;
        }
    };
    
    //=========================================================================
    // MODULATION CALCULATION
    //=========================================================================
    
    func calculateModulation(arousal : Int, stress : StressResponseState) : ArousalModulation {
        // VAEL: amplified when aroused (threat detection)
        let vaelMult = 1000 + arousal;
        
        // AEGIS: amplified when aroused (defense)
        let aegisMult = 1000 + arousal;
        
        // KORE: suppressed when aroused (deep processing paused)
        let koreMult = if (arousal > 0) { 1000 * 1000 / (1000 + arousal) } else { 1000 };
        
        // MEMORIA: slightly suppressed when highly aroused (encoding over consolidation)
        let memoriaMult = if (arousal > AROUSAL_HIGH) {
            800
        } else if (arousal < AROUSAL_LOW) {
            1200  // Enhanced during rest
        } else {
            1000
        };
        
        // Memory encoding: stronger when aroused (emotional memories)
        let encodingMult = 1000 + arousal / 2;
        
        // Learning rate: faster when aroused
        let learningMult = 1000 + arousal / 3;
        
        // Attention focus: narrower when aroused (tunnel vision)
        let focusMult = 1000 + arousal / 2;
        
        // Processing speed: faster but shallower when aroused
        let speedMult = 1000 + arousal / 4;
        
        // Fire threshold: lower when aroused (more reactive)
        let fireOffset = -arousal / 5;
        
        // Emergency threshold: lower when already stressed
        let emergencyOffset = -stress.cortisolLevel / 10;
        
        // Consolidation threshold: higher when aroused (harder to consolidate)
        let consolidationOffset = arousal / 3;
        
        {
            vaelWeightMultiplier = vaelMult;
            aegisWeightMultiplier = aegisMult;
            koreWeightMultiplier = koreMult;
            memoriaWeightMultiplier = memoriaMult;
            memoryEncodingMultiplier = encodingMult;
            learningRateMultiplier = learningMult;
            attentionFocusMultiplier = focusMult;
            processingSpeedMultiplier = speedMult;
            fireThresholdOffset = fireOffset;
            emergencyThresholdOffset = emergencyOffset;
            consolidationThresholdOffset = consolidationOffset;
        }
    };
    
    //=========================================================================
    // CIRCADIAN UPDATE
    //=========================================================================
    
    func updateCircadian(state : CircadianState, beat : Int) : CircadianState {
        // Advance phase progress (assuming ~24000 beats per cycle)
        let beatsPerPhase = 4000;  // ~4000 beats per phase, 6 phases
        let newProgress = state.phaseProgress + 1;
        
        if (newProgress >= beatsPerPhase) {
            // Phase transition
            let (newPhase, newCycle) = switch (state.currentPhase) {
                case (#Morning) { (#Midday, state.cycleCount) };
                case (#Midday) { (#Afternoon, state.cycleCount) };
                case (#Afternoon) { (#Evening, state.cycleCount) };
                case (#Evening) { (#Night, state.cycleCount) };
                case (#Night) { (#DeepNight, state.cycleCount) };
                case (#DeepNight) { (#Morning, state.cycleCount + 1) };
            };
            
            let (newBaseMod, newRecovMod) = getCircadianModifiers(newPhase);
            
            {
                currentPhase = newPhase;
                phaseProgress = 0;
                baselineModifier = newBaseMod;
                recoveryModifier = newRecovMod;
                cycleCount = newCycle;
            }
        } else {
            {
                currentPhase = state.currentPhase;
                phaseProgress = newProgress;
                baselineModifier = state.baselineModifier;
                recoveryModifier = state.recoveryModifier;
                cycleCount = state.cycleCount;
            }
        }
    };
    
    func getCircadianModifiers(phase : CircadianPhase) : (Int, Int) {
        // Returns (baselineModifier, recoveryModifier)
        switch (phase) {
            case (#Morning) { (110, 80) };       // Higher baseline, lower recovery
            case (#Midday) { (120, 70) };        // Peak arousal capacity
            case (#Afternoon) { (100, 90) };     // Declining
            case (#Evening) { (80, 110) };       // Low arousal, better recovery
            case (#Night) { (60, 130) };         // Minimal arousal, good recovery
            case (#DeepNight) { (50, 150) };     // Deepest rest, maximum recovery
        }
    };
    
    //=========================================================================
    // CONVENIENCE FUNCTIONS
    //=========================================================================
    
    public func getModulatedWeight(baseWeight : Int, arousal : Int, substrateType : Text) : Int {
        let mod = calculateModulation(arousal, {
            cortisolLevel = 200;
            cortisolPeak = 200;
            cortisolBaseline = 200;
            norepinephrineLevel = 100;
            adrenalineLevel = 50;
            acetylcholineLevel = 500;
            vagalTone = 600;
            allostaticLoad = 0;
            recoveryDebt = 0;
            stressOnsetBeat = 0;
            stressDurationBeats = 0;
            lastRecoveryBeat = 0;
        });
        
        let multiplier = switch (substrateType) {
            case ("VAEL") { mod.vaelWeightMultiplier };
            case ("AEGIS") { mod.aegisWeightMultiplier };
            case ("KORE") { mod.koreWeightMultiplier };
            case ("MEMORIA") { mod.memoriaWeightMultiplier };
            case (_) { 1000 };
        };
        
        baseWeight * multiplier / 1000
    };
    
    public func shouldEnterEmergencyMode(state : ArousalState) : Bool {
        state.currentArousal > AROUSAL_CRITICAL or
        state.stressResponse.adrenalineLevel > 800 or
        state.stressResponse.cortisolLevel > 900
    };
    
    public func getRecoveryNeeded(state : ArousalState) : Int {
        state.stressResponse.recoveryDebt + state.fatigueLevel + state.sleepPressure / 10
    };
    
    public func isOverstressed(state : ArousalState) : Bool {
        state.stressResponse.allostaticLoad > 1000 or
        state.stressResponse.recoveryDebt > 500 or
        state.highArousalBeats > state.totalBeats / 2
    };
}
