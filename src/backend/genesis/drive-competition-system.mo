/**
 * DRIVE COMPETITION SYSTEM
 * 
 * Complete behavioral drive selection for the sovereign organism.
 * Drives compete via Q-values + Gaussian noise from personality seed.
 * 
 * DOCTRINE: The organism does not just have states - it has drives.
 * Drives compete for control of behavior. The winning drive shapes action.
 * Each drive has a Q-value that estimates its utility. Personality biases selection.
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

module DriveCompetitionSystem {

    //=========================================================================
    // DRIVE ENUMERATION
    //=========================================================================
    
    public type DriveType = {
        #Cohere;        // Seek coherence, reduce drift
        #DriftHold;     // Maintain current state, resist change
        #Expand;        // Grow, explore, increase salience
        #Consolidate;   // Strengthen memory, reduce activity
        #Emergency;     // Threat response, survival focus
        #Nurture;       // Care for others, social bonds
        #Create;        // Generate new patterns, build
        #Protect;       // Defend territory, guard resources
        #Rest;          // Recovery, energy conservation
        #Explore;       // Seek novelty, gather information
    };
    
    public let DRIVE_COUNT : Nat = 10;
    
    //=========================================================================
    // DRIVE PRIORITY LEVELS
    //=========================================================================
    
    public type DrivePriority = {
        #Survival;      // Emergency, cannot be overridden
        #Biological;    // Rest, energy - hard to override
        #Social;        // Nurture, protect - moderate priority
        #Cognitive;     // Cohere, consolidate, create - flexible
        #Exploratory;   // Expand, explore - lowest priority
    };
    
    //=========================================================================
    // Q-VALUE WEIGHTS
    //=========================================================================
    
    // Weights for Q-value calculation - how much each factor contributes
    public let Q_COHERENCE_WEIGHT : Int = 200;
    public let Q_KF_WEIGHT : Int = 150;
    public let Q_DRIFT_WEIGHT : Int = 300;
    public let Q_SALIENCE_WEIGHT : Int = 100;
    public let Q_MEMORY_WEIGHT : Int = 100;
    public let Q_AROUSAL_WEIGHT : Int = 150;
    public let Q_ENERGY_WEIGHT : Int = 200;
    public let Q_THREAT_WEIGHT : Int = 500;
    public let Q_SLEEP_WEIGHT : Int = 200;
    public let Q_SOCIAL_WEIGHT : Int = 100;
    
    //=========================================================================
    // DRIVE STATE
    //=========================================================================
    
    public type DriveState = {
        driveType : DriveType;
        qValue : Int;               // Estimated utility (0-2000+)
        baselineQ : Int;            // Long-term average Q
        activationLevel : Int;      // Current activation (0-1000)
        satisfactionLevel : Int;    // How satisfied the drive is (0-1000)
        deprivationLevel : Int;     // How deprived (inverse of satisfaction)
        lastActiveBeat : Int;       // When last in control
        totalActiveBeats : Nat;     // Total time in control
        personalityBias : Int;      // From personality seed
    };
    
    //=========================================================================
    // DRIVE TRANSITION
    //=========================================================================
    
    public type DriveTransition = {
        fromDrive : DriveType;
        toDrive : DriveType;
        transitionBeat : Int;
        reason : Text;
        qDifference : Int;          // Q(to) - Q(from)
    };
    
    //=========================================================================
    // DRIVE HISTORY ENTRY
    //=========================================================================
    
    public type DriveHistoryEntry = {
        beat : Int;
        activeDrive : DriveType;
        qValues : [Int];            // Q-values for all drives
        arousalLevel : Int;
        energyLevel : Int;
        wasForced : Bool;           // Emergency override
    };
    
    //=========================================================================
    // INPUT SIGNALS FOR Q CALCULATION
    //=========================================================================
    
    public type DriveInputSignals = {
        coherence : Int;
        drift : Int;
        kfCoherence : Int;
        salience : Int;
        memoryWeight : Int;
        arousal : Int;
        energy : Int;
        threatLevel : Int;
        sleepPressure : Int;
        socialSignal : Int;
        noveltySignal : Int;
        territoryStrength : Int;
        predictionError : Int;
    };
    
    //=========================================================================
    // FULL DRIVE COMPETITION STATE
    //=========================================================================
    
    public type DriveCompetitionState = {
        // Individual drive states (10 drives)
        drives : [DriveState];
        
        // Current active drive
        activeDrive : DriveType;
        activeDriveIndex : Nat;
        activeDuration : Int;       // How long current drive has been active
        
        // Q-values
        currentQValues : [Int];     // Q-values for all drives this beat
        winningQ : Int;             // Q-value of active drive
        runnerUpQ : Int;            // Second highest Q
        qDifferential : Int;        // winningQ - runnerUpQ
        
        // Selection noise
        noiseValues : [Int];        // Gaussian noise for each drive
        totalNoise : Int;           // Sum of noise applied
        
        // History
        driveHistory : [DriveHistoryEntry];
        transitionHistory : [DriveTransition];
        transitionCount : Nat;
        
        // Drive dominance tracking
        driveDominance : [Nat];     // Beats spent in each drive
        dominantDrive : DriveType;  // Most common drive overall
        
        // Mode influence
        currentMode : Nat;          // Wake(0)/Sleep(1)/Dream(2)
        modeMultipliers : [Int];    // How mode affects each drive
        
        // Statistics
        totalBeats : Nat;
        forcedSwitches : Nat;       // Emergency overrides
        smoothSwitches : Nat;       // Natural transitions
        stability : Int;            // How stable the active drive is
    };
    
    //=========================================================================
    // INITIALIZATION
    //=========================================================================
    
    public func initDriveCompetitionState(personalityBiases : [Int]) : DriveCompetitionState {
        let initialDrives = Array.tabulate<DriveState>(DRIVE_COUNT, func(i : Nat) : DriveState {
            let driveType = indexToDrive(i);
            {
                driveType = driveType;
                qValue = 500;
                baselineQ = 500;
                activationLevel = 100;
                satisfactionLevel = 500;
                deprivationLevel = 500;
                lastActiveBeat = 0;
                totalActiveBeats = 0;
                personalityBias = if (i < personalityBiases.size()) { personalityBiases[i] } else { 0 };
            }
        });
        
        {
            drives = initialDrives;
            
            activeDrive = #Cohere;
            activeDriveIndex = 0;
            activeDuration = 0;
            
            currentQValues = Array.tabulate<Int>(DRIVE_COUNT, func(_ : Nat) : Int { 500 });
            winningQ = 500;
            runnerUpQ = 400;
            qDifferential = 100;
            
            noiseValues = Array.tabulate<Int>(DRIVE_COUNT, func(_ : Nat) : Int { 0 });
            totalNoise = 0;
            
            driveHistory = [];
            transitionHistory = [];
            transitionCount = 0;
            
            driveDominance = Array.tabulate<Nat>(DRIVE_COUNT, func(_ : Nat) : Nat { 0 });
            dominantDrive = #Cohere;
            
            currentMode = 0;
            modeMultipliers = Array.tabulate<Int>(DRIVE_COUNT, func(_ : Nat) : Int { 1000 });
            
            totalBeats = 0;
            forcedSwitches = 0;
            smoothSwitches = 0;
            stability = 800;
        }
    };
    
    //=========================================================================
    // DRIVE INDEX CONVERSION
    //=========================================================================
    
    public func driveToIndex(drive : DriveType) : Nat {
        switch (drive) {
            case (#Cohere) { 0 };
            case (#DriftHold) { 1 };
            case (#Expand) { 2 };
            case (#Consolidate) { 3 };
            case (#Emergency) { 4 };
            case (#Nurture) { 5 };
            case (#Create) { 6 };
            case (#Protect) { 7 };
            case (#Rest) { 8 };
            case (#Explore) { 9 };
        }
    };
    
    public func indexToDrive(index : Nat) : DriveType {
        switch (index) {
            case (0) { #Cohere };
            case (1) { #DriftHold };
            case (2) { #Expand };
            case (3) { #Consolidate };
            case (4) { #Emergency };
            case (5) { #Nurture };
            case (6) { #Create };
            case (7) { #Protect };
            case (8) { #Rest };
            case (9) { #Explore };
            case (_) { #Cohere };
        }
    };
    
    public func getDrivePriority(drive : DriveType) : DrivePriority {
        switch (drive) {
            case (#Emergency) { #Survival };
            case (#Rest) { #Biological };
            case (#Nurture) { #Social };
            case (#Protect) { #Social };
            case (#Cohere) { #Cognitive };
            case (#Consolidate) { #Cognitive };
            case (#Create) { #Cognitive };
            case (#DriftHold) { #Cognitive };
            case (#Expand) { #Exploratory };
            case (#Explore) { #Exploratory };
        }
    };
    
    //=========================================================================
    // Q-VALUE CALCULATION
    //=========================================================================
    
    public func calculateQValues(
        signals : DriveInputSignals,
        drives : [DriveState],
        mode : Nat
    ) : [Int] {
        Array.tabulate<Int>(DRIVE_COUNT, func(i : Nat) : Int {
            let drive = indexToDrive(i);
            let driveState = drives[i];
            
            // Base Q-value calculation for each drive
            var q = switch (drive) {
                case (#Cohere) {
                    // Seek coherence, reduce drift
                    let coherenceReward = signals.coherence * Q_COHERENCE_WEIGHT / 1000;
                    let kfBonus = signals.kfCoherence * Q_KF_WEIGHT / 1000;
                    let driftPenalty = signals.drift * Q_DRIFT_WEIGHT / 1000;
                    coherenceReward + kfBonus - driftPenalty + 500
                };
                
                case (#DriftHold) {
                    // Maintain current state
                    let stabilityReward = if (signals.drift < 200) { 300 } else { 0 };
                    let coherenceBonus = signals.coherence / 5;
                    let changeResistance = 1000 - signals.arousal;
                    (stabilityReward + coherenceBonus + changeResistance) / 3 + 300
                };
                
                case (#Expand) {
                    // Grow, explore, increase salience
                    let salienceReward = signals.salience * Q_SALIENCE_WEIGHT / 1000;
                    let memoryBonus = signals.memoryWeight / 1000;
                    let noveltyBonus = signals.noveltySignal * 150 / 1000;
                    let energyGate = if (signals.energy > 400) { 200 } else { 0 };
                    salienceReward + memoryBonus + noveltyBonus + energyGate + 200
                };
                
                case (#Consolidate) {
                    // Strengthen memory, reduce activity
                    let memoryNeed = signals.memoryWeight / 500;
                    let sleepBonus = signals.sleepPressure * Q_SLEEP_WEIGHT / 1000;
                    let lowArousalBonus = (1000 - signals.arousal) / 3;
                    let energyConservation = (1000 - signals.energy) / 5;
                    memoryNeed + sleepBonus + lowArousalBonus + energyConservation + 100
                };
                
                case (#Emergency) {
                    // Threat response - can override everything
                    let threatQ = signals.threatLevel * Q_THREAT_WEIGHT / 1000;
                    let aegisBoost = signals.drift * 200 / 1000;
                    let urgencyBoost = signals.arousal * 300 / 1000;
                    threatQ + aegisBoost + urgencyBoost
                };
                
                case (#Nurture) {
                    // Social bonds, care for others
                    let socialReward = signals.socialSignal * Q_SOCIAL_WEIGHT / 1000;
                    let coherenceBase = signals.coherence / 4;
                    let lowThreatBonus = if (signals.threatLevel < 200) { 150 } else { 0 };
                    socialReward + coherenceBase + lowThreatBonus + 200
                };
                
                case (#Create) {
                    // Generate patterns, build
                    let creativePotential = (signals.coherence + signals.kfCoherence) / 4;
                    let salienceBoost = signals.salience / 3;
                    let energyRequired = if (signals.energy > 500) { 200 } else { -100 };
                    let predictionBonus = signals.predictionError / 5;
                    creativePotential + salienceBoost + energyRequired + predictionBonus + 150
                };
                
                case (#Protect) {
                    // Defend territory
                    let territoryValue = signals.territoryStrength * 150 / 1000;
                    let threatResponse = signals.threatLevel * 200 / 1000;
                    let coherenceBase = signals.coherence / 5;
                    territoryValue + threatResponse + coherenceBase + 250
                };
                
                case (#Rest) {
                    // Recovery, energy conservation
                    let energyNeed = (1000 - signals.energy) * Q_ENERGY_WEIGHT / 1000;
                    let sleepPressureReward = signals.sleepPressure * Q_SLEEP_WEIGHT / 1000;
                    let lowThreatRequired = if (signals.threatLevel < 300) { 200 } else { -200 };
                    let fatigueBonus = (1000 - signals.coherence) / 5;
                    energyNeed + sleepPressureReward + lowThreatRequired + fatigueBonus
                };
                
                case (#Explore) {
                    // Seek novelty, gather information
                    let noveltyReward = signals.noveltySignal * 200 / 1000;
                    let lowFamiliarityBonus = (1000 - signals.memoryWeight / 100) / 3;
                    let energyGate = if (signals.energy > 300) { 150 } else { -100 };
                    let safetyGate = if (signals.threatLevel < 400) { 100 } else { -200 };
                    noveltyReward + lowFamiliarityBonus + energyGate + safetyGate + 100
                };
            };
            
            // Add personality bias
            q += driveState.personalityBias;
            
            // Add deprivation bonus (drives get stronger when deprived)
            q += driveState.deprivationLevel / 5;
            
            // Apply mode multiplier
            let modeMult = getModeMultiplier(drive, mode);
            q := q * modeMult / 1000;
            
            // Ensure non-negative
            if (q < 0) { q := 0 };
            
            q
        })
    };
    
    //=========================================================================
    // MODE MULTIPLIERS
    //=========================================================================
    
    func getModeMultiplier(drive : DriveType, mode : Nat) : Int {
        // mode: 0=Wake, 1=Sleep, 2=Dream
        switch (mode) {
            case (0) {
                // Wake mode - all drives available
                switch (drive) {
                    case (#Cohere) { 1000 };
                    case (#Expand) { 1100 };
                    case (#Explore) { 1100 };
                    case (#Create) { 1000 };
                    case (#Consolidate) { 700 };
                    case (#Rest) { 500 };
                    case (_) { 1000 };
                }
            };
            case (1) {
                // Sleep mode - rest and consolidate dominate
                switch (drive) {
                    case (#Rest) { 1500 };
                    case (#Consolidate) { 1400 };
                    case (#Cohere) { 800 };
                    case (#Expand) { 200 };
                    case (#Explore) { 100 };
                    case (#Create) { 300 };
                    case (#Emergency) { 1200 };  // Emergencies still work
                    case (_) { 500 };
                }
            };
            case (2) {
                // Dream mode - create and consolidate
                switch (drive) {
                    case (#Create) { 1300 };
                    case (#Consolidate) { 1200 };
                    case (#Explore) { 800 };
                    case (#Cohere) { 600 };
                    case (#Rest) { 800 };
                    case (#Emergency) { 1100 };
                    case (_) { 400 };
                }
            };
            case (_) { 1000 };
        }
    };
    
    //=========================================================================
    // NOISE GENERATION
    //=========================================================================
    
    // Gaussian proxy from personality seed bits
    public func generateNoise(personalityBiases : [Int], beat : Int) : [Int] {
        Array.tabulate<Int>(DRIVE_COUNT, func(i : Nat) : Int {
            let bias = if (i < personalityBiases.size()) { personalityBiases[i] } else { 0 };
            // Simple noise: personality bias + beat-dependent variation
            let variation = ((beat * 7919 + i * 6271) % 201) - 100;  // -100 to +100
            (bias - 500) / 5 + variation  // Centered around 0
        })
    };
    
    //=========================================================================
    // DRIVE SELECTION
    //=========================================================================
    
    // argmax(Q[k] + noise[k])
    public func selectDrive(
        qValues : [Int],
        noise : [Int],
        currentDrive : DriveType,
        stability : Int
    ) : (DriveType, Nat, Int) {
        var maxQ : Int = -999999;
        var maxIndex : Nat = 0;
        var runnerUpQ : Int = -999999;
        
        for (i in qValues.keys()) {
            let totalQ = qValues[i] + noise[i];
            
            // Add hysteresis for stability (current drive gets bonus)
            let hystBonus = if (indexToDrive(i) == currentDrive) { stability / 10 } else { 0 };
            let finalQ = totalQ + hystBonus;
            
            if (finalQ > maxQ) {
                runnerUpQ := maxQ;
                maxQ := finalQ;
                maxIndex := i;
            } else if (finalQ > runnerUpQ) {
                runnerUpQ := finalQ;
            };
        };
        
        (indexToDrive(maxIndex), maxIndex, maxQ - runnerUpQ)
    };
    
    //=========================================================================
    // MAIN UPDATE FUNCTION
    //=========================================================================
    
    public func updateDriveCompetition(
        state : DriveCompetitionState,
        signals : DriveInputSignals,
        personalityBiases : [Int],
        beat : Int
    ) : DriveCompetitionState {
        // Calculate Q-values for all drives
        let qValues = calculateQValues(signals, state.drives, state.currentMode);
        
        // Generate noise
        let noise = generateNoise(personalityBiases, beat);
        
        // Check for emergency override
        let emergencyIndex = driveToIndex(#Emergency);
        let isEmergency = qValues[emergencyIndex] > 800 and signals.threatLevel > 500;
        
        // Select winning drive
        let (selectedDrive, selectedIndex, qDiff) = if (isEmergency) {
            (#Emergency, emergencyIndex, qValues[emergencyIndex])
        } else {
            selectDrive(qValues, noise, state.activeDrive, state.stability)
        };
        
        // Check if drive changed
        let driveChanged = selectedDrive != state.activeDrive;
        
        // Update transition history if drive changed
        let newTransitionHistory = if (driveChanged) {
            let transition : DriveTransition = {
                fromDrive = state.activeDrive;
                toDrive = selectedDrive;
                transitionBeat = beat;
                reason = if (isEmergency) { "emergency" } else { "competition" };
                qDifference = qDiff;
            };
            let buffer = Buffer.Buffer<DriveTransition>(51);
            for (t in state.transitionHistory.vals()) {
                buffer.add(t);
            };
            buffer.add(transition);
            if (buffer.size() > 50) {
                Buffer.toArray(Buffer.subBuffer(buffer, buffer.size() - 50, 50))
            } else {
                Buffer.toArray(buffer)
            }
        } else {
            state.transitionHistory
        };
        
        // Update drive states
        let newDrives = Array.tabulate<DriveState>(DRIVE_COUNT, func(i : Nat) : DriveState {
            let oldDrive = state.drives[i];
            let isActive = i == selectedIndex;
            
            // Update satisfaction based on whether drive is active
            let newSatisfaction = if (isActive) {
                // Active drives get satisfied
                let increase = 20;
                if (oldDrive.satisfactionLevel + increase > 1000) { 1000 }
                else { oldDrive.satisfactionLevel + increase }
            } else {
                // Inactive drives become deprived
                let decrease = 5;
                if (oldDrive.satisfactionLevel < decrease) { 0 }
                else { oldDrive.satisfactionLevel - decrease }
            };
            
            let newDeprivation = 1000 - newSatisfaction;
            
            // Update activation level
            let newActivation = if (isActive) { 
                if (oldDrive.activationLevel + 50 > 1000) { 1000 }
                else { oldDrive.activationLevel + 50 }
            } else {
                // Decay inactive drives
                oldDrive.activationLevel * 950 / 1000
            };
            
            // Update baseline Q
            let newBaselineQ = (oldDrive.baselineQ * 990 + qValues[i] * 10) / 1000;
            
            {
                driveType = oldDrive.driveType;
                qValue = qValues[i];
                baselineQ = newBaselineQ;
                activationLevel = newActivation;
                satisfactionLevel = newSatisfaction;
                deprivationLevel = newDeprivation;
                lastActiveBeat = if (isActive) { beat } else { oldDrive.lastActiveBeat };
                totalActiveBeats = if (isActive) { oldDrive.totalActiveBeats + 1 } else { oldDrive.totalActiveBeats };
                personalityBias = oldDrive.personalityBias;
            }
        });
        
        // Update dominance tracking
        let newDominance = Array.tabulate<Nat>(DRIVE_COUNT, func(i : Nat) : Nat {
            if (i == selectedIndex) { state.driveDominance[i] + 1 }
            else { state.driveDominance[i] }
        });
        
        // Find most dominant drive
        var maxDominance : Nat = 0;
        var dominantIndex : Nat = 0;
        for (i in newDominance.keys()) {
            if (newDominance[i] > maxDominance) {
                maxDominance := newDominance[i];
                dominantIndex := i;
            };
        };
        
        // Create history entry
        let historyEntry : DriveHistoryEntry = {
            beat = beat;
            activeDrive = selectedDrive;
            qValues = qValues;
            arousalLevel = signals.arousal;
            energyLevel = signals.energy;
            wasForced = isEmergency;
        };
        
        // Update history (keep last 1000)
        let historyBuffer = Buffer.Buffer<DriveHistoryEntry>(1001);
        for (h in state.driveHistory.vals()) {
            historyBuffer.add(h);
        };
        historyBuffer.add(historyEntry);
        let newHistory = if (historyBuffer.size() > 1000) {
            Buffer.toArray(Buffer.subBuffer(historyBuffer, historyBuffer.size() - 1000, 1000))
        } else {
            Buffer.toArray(historyBuffer)
        };
        
        // Calculate stability (how consistently we stay in one drive)
        let recentWindow = 100;
        var sameCount : Nat = 0;
        let histLen = newHistory.size();
        let startIdx = if (histLen > recentWindow) { histLen - recentWindow } else { 0 };
        for (i in Array.keys(newHistory)) {
            if (i >= startIdx and newHistory[i].activeDrive == selectedDrive) {
                sameCount += 1;
            };
        };
        let newStability = sameCount * 1000 / recentWindow;
        
        // Update statistics
        let newForcedSwitches = if (isEmergency and driveChanged) { state.forcedSwitches + 1 } else { state.forcedSwitches };
        let newSmoothSwitches = if (not isEmergency and driveChanged) { state.smoothSwitches + 1 } else { state.smoothSwitches };
        
        // Calculate total noise
        var totalN : Int = 0;
        for (n in noise.vals()) {
            totalN += Int.abs(n);
        };
        
        // Find runner-up Q
        var runnerUp : Int = 0;
        for (i in qValues.keys()) {
            if (i != selectedIndex and qValues[i] > runnerUp) {
                runnerUp := qValues[i];
            };
        };
        
        {
            drives = newDrives;
            
            activeDrive = selectedDrive;
            activeDriveIndex = selectedIndex;
            activeDuration = if (driveChanged) { 1 } else { state.activeDuration + 1 };
            
            currentQValues = qValues;
            winningQ = qValues[selectedIndex];
            runnerUpQ = runnerUp;
            qDifferential = qDiff;
            
            noiseValues = noise;
            totalNoise = totalN;
            
            driveHistory = newHistory;
            transitionHistory = newTransitionHistory;
            transitionCount = if (driveChanged) { state.transitionCount + 1 } else { state.transitionCount };
            
            driveDominance = newDominance;
            dominantDrive = indexToDrive(dominantIndex);
            
            currentMode = state.currentMode;
            modeMultipliers = state.modeMultipliers;
            
            totalBeats = state.totalBeats + 1;
            forcedSwitches = newForcedSwitches;
            smoothSwitches = newSmoothSwitches;
            stability = newStability;
        }
    };
    
    //=========================================================================
    // MODE SETTING
    //=========================================================================
    
    public func setMode(state : DriveCompetitionState, mode : Nat) : DriveCompetitionState {
        let newMultipliers = Array.tabulate<Int>(DRIVE_COUNT, func(i : Nat) : Int {
            getModeMultiplier(indexToDrive(i), mode)
        });
        
        {
            drives = state.drives;
            activeDrive = state.activeDrive;
            activeDriveIndex = state.activeDriveIndex;
            activeDuration = state.activeDuration;
            currentQValues = state.currentQValues;
            winningQ = state.winningQ;
            runnerUpQ = state.runnerUpQ;
            qDifferential = state.qDifferential;
            noiseValues = state.noiseValues;
            totalNoise = state.totalNoise;
            driveHistory = state.driveHistory;
            transitionHistory = state.transitionHistory;
            transitionCount = state.transitionCount;
            driveDominance = state.driveDominance;
            dominantDrive = state.dominantDrive;
            currentMode = mode;
            modeMultipliers = newMultipliers;
            totalBeats = state.totalBeats;
            forcedSwitches = state.forcedSwitches;
            smoothSwitches = state.smoothSwitches;
            stability = state.stability;
        }
    };
    
    //=========================================================================
    // CONVENIENCE FUNCTIONS
    //=========================================================================
    
    public func getDriveString(drive : DriveType) : Text {
        switch (drive) {
            case (#Cohere) { "COHERE" };
            case (#DriftHold) { "DRIFT_HOLD" };
            case (#Expand) { "EXPAND" };
            case (#Consolidate) { "CONSOLIDATE" };
            case (#Emergency) { "EMERGENCY" };
            case (#Nurture) { "NURTURE" };
            case (#Create) { "CREATE" };
            case (#Protect) { "PROTECT" };
            case (#Rest) { "REST" };
            case (#Explore) { "EXPLORE" };
        }
    };
    
    public func isHighPriorityDrive(drive : DriveType) : Bool {
        switch (getDrivePriority(drive)) {
            case (#Survival) { true };
            case (#Biological) { true };
            case (_) { false };
        }
    };
    
    public func getTransitionRate(state : DriveCompetitionState) : Int {
        if (state.totalBeats == 0) { 0 }
        else { state.transitionCount * 1000 / state.totalBeats }
    };
    
    public func getMostDeprivedDrive(state : DriveCompetitionState) : DriveType {
        var maxDeprivation : Int = 0;
        var mostDeprived : DriveType = #Cohere;
        
        for (drive in state.drives.vals()) {
            if (drive.deprivationLevel > maxDeprivation) {
                maxDeprivation := drive.deprivationLevel;
                mostDeprived := drive.driveType;
            };
        };
        
        mostDeprived
    };
}
