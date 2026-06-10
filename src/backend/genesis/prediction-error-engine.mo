/**
 * PREDICTION ERROR ENGINE
 * 
 * Complete TD-learning and surprisal implementation for the sovereign organism.
 * Prediction error (δ) gates all learning - the organism learns from what surprises it.
 * 
 * DOCTRINE: The organism maintains a value function V(s) that estimates future rewards.
 * When reality differs from prediction (δ ≠ 0), the organism updates its internal model.
 * High |δ| = surprise = faster learning. Low |δ| = predicted = minimal update.
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

module PredictionErrorEngine {

    //=========================================================================
    // CONSTANTS
    //=========================================================================
    
    public let GAMMA : Int = 900;                   // Discount factor (0.9 = 900/1000)
    public let SCALE : Int = 1000;
    public let DELTA_MAX : Int = 1000;              // Maximum prediction error
    public let DELTA_MIN : Int = -1000;             // Minimum prediction error
    
    // Reward signal magnitudes
    public let REWARD_COHERENCE_RISE : Int = 100;
    public let REWARD_OMNIS_EMERGENCE : Int = 500;
    public let REWARD_MEMORY_CONSOLIDATED : Int = 50;
    public let REWARD_PATTERN_RECOGNIZED : Int = 75;
    public let REWARD_DRIVE_SATISFIED : Int = 150;
    public let PENALTY_DRIFT_EXCEEDED : Int = -100;
    public let PENALTY_SOVEREIGNTY_BREACH : Int = -300;
    public let PENALTY_ENERGY_DEPLETED : Int = -200;
    public let PENALTY_COHERENCE_DROP : Int = -150;
    public let PENALTY_MEMORY_DECAY : Int = -50;
    
    // Learning rate modulation
    public let BASE_LEARNING_RATE : Int = 100;      // η_base = 0.1
    public let SURPRISE_AMPLIFICATION : Int = 500;  // How much |δ| boosts learning
    
    //=========================================================================
    // STATE REPRESENTATION
    //=========================================================================
    
    public type StateVector = {
        coherence : Int;            // Current coherence level
        drift : Int;                // Current drift level
        memoryWeight : Int;         // Memory accumulation
        kfCoherence : Int;          // Frequency coherence K_f
        arousal : Int;              // Arousal level
        energy : Int;               // Energy level
        driveState : Nat;           // Current active drive (0-4)
        mode : Nat;                 // Current mode (wake/sleep/dream)
    };
    
    public type StateValue = {
        state : StateVector;
        value : Int;                // V(s) - estimated value of state
        uncertainty : Int;          // Confidence in the value estimate
        visitCount : Nat;           // How many times this state has been visited
        lastVisitBeat : Int;        // When last visited
    };
    
    //=========================================================================
    // PREDICTION TYPES
    //=========================================================================
    
    public type PredictionType = {
        #CoherenceChange;           // Will coherence rise or fall?
        #DriftChange;               // Will drift increase or decrease?
        #EnergyChange;              // Will energy be gained or lost?
        #EmergenceOccur;            // Will OMNIS emerge?
        #MemoryConsolidate;         // Will memory strengthen?
        #DriveSwitch;               // Will active drive change?
        #ModeTransition;            // Will mode change?
        #StimulusArrival;           // Will external stimulus arrive?
        #PatternMatch;              // Will a pattern be recognized?
        #ThresholdCross;            // Will a threshold be crossed?
        #PhaseAlign;                // Will phases synchronize?
        #RecoveryComplete;          // Will recovery finish?
        #StressEvent;               // Will stress event occur?
        #RewardEvent;               // Will reward be received?
        #Custom;                    // Custom prediction
    };
    
    public type Prediction = {
        predictionType : PredictionType;
        predictedValue : Int;       // What we predict will happen (-1000 to +1000)
        confidence : Int;           // How confident (0-1000)
        timeHorizon : Int;          // How many beats ahead
        createdBeat : Int;          // When prediction was made
        deadline : Int;             // When prediction should resolve
        resolved : Bool;            // Whether outcome is known
        actualValue : ?Int;         // What actually happened
        predictionError : ?Int;     // δ = actual - predicted
    };
    
    //=========================================================================
    // REWARD SIGNAL
    //=========================================================================
    
    public type RewardType = {
        #CoherenceRose;
        #OmnisEmergence;
        #MemoryConsolidated;
        #PatternRecognized;
        #DriveSatisfied;
        #DriftExceeded;
        #SovereigntyBreach;
        #EnergyDepleted;
        #CoherenceDrop;
        #MemoryDecay;
        #Custom;
    };
    
    public type RewardSignal = {
        rewardType : RewardType;
        magnitude : Int;            // Signed magnitude
        beat : Int;
        source : Text;
    };
    
    //=========================================================================
    // FREE ENERGY
    //=========================================================================
    
    public type FreeEnergyState = {
        surprisal : Int;            // -log P(observation)
        predictionError : Int;      // Average |δ| over recent predictions
        modelComplexity : Int;      // Number of active predictions
        freeEnergy : Int;           // F = surprisal + prediction_error + complexity
        entropyInternal : Int;      // Internal state entropy
        entropyExternal : Int;      // External observation entropy
    };
    
    //=========================================================================
    // PREDICTION ERROR HISTORY
    //=========================================================================
    
    public type PredictionErrorEntry = {
        beat : Int;
        delta : Int;                // Prediction error
        reward : Int;               // Reward received
        valuePre : Int;             // V(s) before update
        valuePost : Int;            // V(s) after update
        learningRate : Int;         // η_effective used
        predictionType : PredictionType;
    };
    
    //=========================================================================
    // FULL PREDICTION ERROR STATE
    //=========================================================================
    
    public type PredictionErrorState = {
        // Value function
        currentValue : Int;             // V(s) of current state
        previousValue : Int;            // V(s) of previous state
        valueBaseline : Int;            // Long-term average value
        valuePeak : Int;                // Highest value achieved
        valueTrough : Int;              // Lowest value achieved
        
        // Prediction error
        currentDelta : Int;             // δ(t) = r + γV(s') - V(s)
        deltaMagnitude : Int;           // |δ| - absolute error
        deltaSign : Int;                // +1 if positive surprise, -1 if negative
        cumulativeDelta : Int;          // Running sum of δ (can be positive or negative)
        
        // Reward tracking
        currentReward : Int;            // r(t)
        cumulativeReward : Int;         // Total reward accumulated
        rewardHistory : [RewardSignal]; // Recent rewards
        
        // Predictions
        activePredictions : [Prediction];  // Currently active predictions
        resolvedPredictions : [Prediction]; // Recently resolved
        predictionAccuracy : Int;       // % of predictions that were correct
        
        // Free energy
        freeEnergy : FreeEnergyState;
        
        // Learning rate
        effectiveLearningRate : Int;    // η_effective = η_base × (1 + |δ|/500)
        
        // History
        errorHistory : [PredictionErrorEntry];
        averageDelta : Int;             // Moving average of |δ|
        deltaVariance : Int;            // Variance of δ
        
        // Statistics
        totalBeats : Nat;
        positiveSurprises : Nat;        // Times δ > 0
        negativeSurprises : Nat;        // Times δ < 0
        majorSurprises : Nat;           // Times |δ| > 500
    };
    
    //=========================================================================
    // INITIALIZATION
    //=========================================================================
    
    public func initPredictionErrorState() : PredictionErrorState {
        {
            currentValue = 500;
            previousValue = 500;
            valueBaseline = 500;
            valuePeak = 500;
            valueTrough = 500;
            
            currentDelta = 0;
            deltaMagnitude = 0;
            deltaSign = 0;
            cumulativeDelta = 0;
            
            currentReward = 0;
            cumulativeReward = 0;
            rewardHistory = [];
            
            activePredictions = [];
            resolvedPredictions = [];
            predictionAccuracy = 500;  // 50% baseline
            
            freeEnergy = {
                surprisal = 0;
                predictionError = 0;
                modelComplexity = 0;
                freeEnergy = 0;
                entropyInternal = 500;
                entropyExternal = 500;
            };
            
            effectiveLearningRate = BASE_LEARNING_RATE;
            
            errorHistory = [];
            averageDelta = 0;
            deltaVariance = 0;
            
            totalBeats = 0;
            positiveSurprises = 0;
            negativeSurprises = 0;
            majorSurprises = 0;
        }
    };
    
    //=========================================================================
    // VALUE FUNCTION CALCULATION
    //=========================================================================
    
    // V(s) = (coherence + memoryWeight/100 + kfCoherence) / 3
    public func calculateStateValue(state : StateVector) : Int {
        let coherenceContrib = state.coherence;
        let memoryContrib = state.memoryWeight / 100;
        let kfContrib = state.kfCoherence;
        let arousalBonus = if (state.arousal < 600) { 50 } else { 0 };  // Calm is good
        let energyBonus = state.energy / 10;
        
        (coherenceContrib + memoryContrib + kfContrib + arousalBonus + energyBonus) / 5
    };
    
    //=========================================================================
    // REWARD SIGNAL CALCULATION
    //=========================================================================
    
    public func calculateReward(
        prevState : StateVector,
        currState : StateVector,
        events : [RewardType]
    ) : (Int, [RewardSignal]) {
        var totalReward : Int = 0;
        let signals = Buffer.Buffer<RewardSignal>(10);
        
        // State-based rewards
        if (currState.coherence > prevState.coherence) {
            let delta = currState.coherence - prevState.coherence;
            let r = REWARD_COHERENCE_RISE * delta / 100;
            totalReward += r;
            signals.add({
                rewardType = #CoherenceRose;
                magnitude = r;
                beat = 0;  // Will be set by caller
                source = "state_change";
            });
        } else if (currState.coherence < prevState.coherence) {
            let delta = prevState.coherence - currState.coherence;
            let r = PENALTY_COHERENCE_DROP * delta / 100;
            totalReward += r;
            signals.add({
                rewardType = #CoherenceDrop;
                magnitude = r;
                beat = 0;
                source = "state_change";
            });
        };
        
        // Event-based rewards
        for (event in events.vals()) {
            let r = switch (event) {
                case (#CoherenceRose) { REWARD_COHERENCE_RISE };
                case (#OmnisEmergence) { REWARD_OMNIS_EMERGENCE };
                case (#MemoryConsolidated) { REWARD_MEMORY_CONSOLIDATED };
                case (#PatternRecognized) { REWARD_PATTERN_RECOGNIZED };
                case (#DriveSatisfied) { REWARD_DRIVE_SATISFIED };
                case (#DriftExceeded) { PENALTY_DRIFT_EXCEEDED };
                case (#SovereigntyBreach) { PENALTY_SOVEREIGNTY_BREACH };
                case (#EnergyDepleted) { PENALTY_ENERGY_DEPLETED };
                case (#CoherenceDrop) { PENALTY_COHERENCE_DROP };
                case (#MemoryDecay) { PENALTY_MEMORY_DECAY };
                case (#Custom) { 0 };
            };
            totalReward += r;
            signals.add({
                rewardType = event;
                magnitude = r;
                beat = 0;
                source = "event";
            });
        };
        
        (totalReward, Buffer.toArray(signals))
    };
    
    //=========================================================================
    // TEMPORAL DIFFERENCE UPDATE
    //=========================================================================
    
    // δ(t) = r + γ × V(s') - V(s)
    public func calculateTDError(
        reward : Int,
        prevValue : Int,
        currValue : Int
    ) : Int {
        let discountedFuture = currValue * GAMMA / SCALE;
        var delta = reward + discountedFuture - prevValue;
        
        // Clamp to valid range
        if (delta > DELTA_MAX) { delta := DELTA_MAX };
        if (delta < DELTA_MIN) { delta := DELTA_MIN };
        
        delta
    };
    
    //=========================================================================
    // LEARNING RATE MODULATION
    //=========================================================================
    
    // η_effective = η_base × (1 + |δ|/500)
    public func calculateEffectiveLearningRate(delta : Int) : Int {
        let absDelta = Int.abs(delta);
        let amplification = absDelta * SCALE / SURPRISE_AMPLIFICATION;
        BASE_LEARNING_RATE * (SCALE + amplification) / SCALE
    };
    
    //=========================================================================
    // PREDICTION MANAGEMENT
    //=========================================================================
    
    public func createPrediction(
        predType : PredictionType,
        predictedVal : Int,
        confidence : Int,
        horizon : Int,
        beat : Int
    ) : Prediction {
        {
            predictionType = predType;
            predictedValue = predictedVal;
            confidence = confidence;
            timeHorizon = horizon;
            createdBeat = beat;
            deadline = beat + horizon;
            resolved = false;
            actualValue = null;
            predictionError = null;
        }
    };
    
    public func resolvePrediction(
        prediction : Prediction,
        actualVal : Int
    ) : Prediction {
        let error = actualVal - prediction.predictedValue;
        {
            predictionType = prediction.predictionType;
            predictedValue = prediction.predictedValue;
            confidence = prediction.confidence;
            timeHorizon = prediction.timeHorizon;
            createdBeat = prediction.createdBeat;
            deadline = prediction.deadline;
            resolved = true;
            actualValue = ?actualVal;
            predictionError = ?error;
        }
    };
    
    //=========================================================================
    // FREE ENERGY CALCULATION
    //=========================================================================
    
    public func calculateFreeEnergy(
        surprisal : Int,
        avgPredictionError : Int,
        numPredictions : Nat,
        internalEntropy : Int,
        externalEntropy : Int
    ) : FreeEnergyState {
        let complexity = numPredictions * 10;  // Each prediction adds complexity
        let fe = surprisal + avgPredictionError + complexity;
        
        {
            surprisal = surprisal;
            predictionError = avgPredictionError;
            modelComplexity = complexity;
            freeEnergy = fe;
            entropyInternal = internalEntropy;
            entropyExternal = externalEntropy;
        }
    };
    
    //=========================================================================
    // MAIN UPDATE FUNCTION
    //=========================================================================
    
    public func updatePredictionError(
        state : PredictionErrorState,
        prevStateVector : StateVector,
        currStateVector : StateVector,
        rewardEvents : [RewardType],
        beat : Int
    ) : PredictionErrorState {
        // Calculate state values
        let prevValue = calculateStateValue(prevStateVector);
        let currValue = calculateStateValue(currStateVector);
        
        // Calculate reward
        let (totalReward, rewardSignals) = calculateReward(prevStateVector, currStateVector, rewardEvents);
        
        // Calculate TD error
        let delta = calculateTDError(totalReward, state.previousValue, currValue);
        let absDelta = Int.abs(delta);
        let signDelta = if (delta > 0) { 1 } else if (delta < 0) { -1 } else { 0 };
        
        // Calculate effective learning rate
        let effLR = calculateEffectiveLearningRate(delta);
        
        // Update value estimate using TD update
        // V(s) ← V(s) + η × δ
        let valueUpdate = effLR * delta / SCALE;
        let newValueBaseline = (state.valueBaseline * 990 + currValue * 10) / 1000;
        
        // Update peak/trough
        let newPeak = if (currValue > state.valuePeak) { currValue } else { state.valuePeak };
        let newTrough = if (currValue < state.valueTrough) { currValue } else { state.valueTrough };
        
        // Update cumulative delta
        let newCumulativeDelta = state.cumulativeDelta + delta;
        
        // Update reward history (keep last 100)
        let rewardBuffer = Buffer.Buffer<RewardSignal>(101);
        for (r in state.rewardHistory.vals()) {
            rewardBuffer.add(r);
        };
        for (r in rewardSignals.vals()) {
            rewardBuffer.add({
                rewardType = r.rewardType;
                magnitude = r.magnitude;
                beat = beat;
                source = r.source;
            });
        };
        let newRewardHistory = if (rewardBuffer.size() > 100) {
            Buffer.toArray(Buffer.subBuffer(rewardBuffer, rewardBuffer.size() - 100, 100))
        } else {
            Buffer.toArray(rewardBuffer)
        };
        
        // Process predictions - check for deadlines
        let stillActive = Buffer.Buffer<Prediction>(16);
        let newlyResolved = Buffer.Buffer<Prediction>(16);
        var correctPredictions : Nat = 0;
        var totalResolved : Nat = 0;
        
        for (pred in state.activePredictions.vals()) {
            if (beat >= pred.deadline and not pred.resolved) {
                // Resolve prediction based on current state
                let actual = switch (pred.predictionType) {
                    case (#CoherenceChange) { currStateVector.coherence - prevStateVector.coherence };
                    case (#DriftChange) { currStateVector.drift - prevStateVector.drift };
                    case (#EnergyChange) { currStateVector.energy - prevStateVector.energy };
                    case (_) { 0 };  // Default for unresolvable types
                };
                let resolved = resolvePrediction(pred, actual);
                newlyResolved.add(resolved);
                totalResolved += 1;
                
                // Check if prediction was "correct" (within 20% of actual)
                let errorMagnitude = Int.abs(actual - pred.predictedValue);
                if (errorMagnitude < Int.abs(pred.predictedValue) / 5 + 50) {
                    correctPredictions += 1;
                };
            } else if (not pred.resolved) {
                stillActive.add(pred);
            };
        };
        
        let newActivePredictions = Buffer.toArray(stillActive);
        
        // Update resolved predictions (keep last 50)
        let resolvedBuffer = Buffer.Buffer<Prediction>(51);
        for (p in state.resolvedPredictions.vals()) {
            resolvedBuffer.add(p);
        };
        for (p in newlyResolved.vals()) {
            resolvedBuffer.add(p);
        };
        let newResolvedPredictions = if (resolvedBuffer.size() > 50) {
            Buffer.toArray(Buffer.subBuffer(resolvedBuffer, resolvedBuffer.size() - 50, 50))
        } else {
            Buffer.toArray(resolvedBuffer)
        };
        
        // Update prediction accuracy
        let newAccuracy = if (totalResolved > 0) {
            (state.predictionAccuracy * 9 + correctPredictions * 1000 / totalResolved) / 10
        } else {
            state.predictionAccuracy
        };
        
        // Calculate surprisal (simplified: based on delta magnitude)
        let surprisal = absDelta;
        
        // Update free energy
        let avgError = (state.freeEnergy.predictionError * 9 + absDelta) / 10;
        let newFreeEnergy = calculateFreeEnergy(
            surprisal,
            avgError,
            newActivePredictions.size(),
            500,  // Placeholder internal entropy
            500   // Placeholder external entropy
        );
        
        // Create history entry
        let historyEntry : PredictionErrorEntry = {
            beat = beat;
            delta = delta;
            reward = totalReward;
            valuePre = state.previousValue;
            valuePost = currValue;
            learningRate = effLR;
            predictionType = #CoherenceChange;  // Default
        };
        
        // Update history (keep last 1000)
        let historyBuffer = Buffer.Buffer<PredictionErrorEntry>(1001);
        for (entry in state.errorHistory.vals()) {
            historyBuffer.add(entry);
        };
        historyBuffer.add(historyEntry);
        let newHistory = if (historyBuffer.size() > 1000) {
            Buffer.toArray(Buffer.subBuffer(historyBuffer, historyBuffer.size() - 1000, 1000))
        } else {
            Buffer.toArray(historyBuffer)
        };
        
        // Calculate average delta and variance
        var deltaSum : Int = 0;
        for (entry in newHistory.vals()) {
            deltaSum += Int.abs(entry.delta);
        };
        let newAvgDelta = if (newHistory.size() > 0) {
            deltaSum / newHistory.size()
        } else { 0 };
        
        var varSum : Int = 0;
        for (entry in newHistory.vals()) {
            let diff = Int.abs(entry.delta) - newAvgDelta;
            varSum += diff * diff / 1000;
        };
        let newVariance = if (newHistory.size() > 0) {
            varSum / newHistory.size()
        } else { 0 };
        
        // Update statistics
        let newPositive = if (delta > 0) { state.positiveSurprises + 1 } else { state.positiveSurprises };
        let newNegative = if (delta < 0) { state.negativeSurprises + 1 } else { state.negativeSurprises };
        let newMajor = if (absDelta > 500) { state.majorSurprises + 1 } else { state.majorSurprises };
        
        {
            currentValue = currValue;
            previousValue = prevValue;
            valueBaseline = newValueBaseline;
            valuePeak = newPeak;
            valueTrough = newTrough;
            
            currentDelta = delta;
            deltaMagnitude = absDelta;
            deltaSign = signDelta;
            cumulativeDelta = newCumulativeDelta;
            
            currentReward = totalReward;
            cumulativeReward = state.cumulativeReward + totalReward;
            rewardHistory = newRewardHistory;
            
            activePredictions = newActivePredictions;
            resolvedPredictions = newResolvedPredictions;
            predictionAccuracy = newAccuracy;
            
            freeEnergy = newFreeEnergy;
            
            effectiveLearningRate = effLR;
            
            errorHistory = newHistory;
            averageDelta = newAvgDelta;
            deltaVariance = newVariance;
            
            totalBeats = state.totalBeats + 1;
            positiveSurprises = newPositive;
            negativeSurprises = newNegative;
            majorSurprises = newMajor;
        }
    };
    
    //=========================================================================
    // AUTOMATIC PREDICTION GENERATION
    //=========================================================================
    
    public func generatePredictions(
        state : PredictionErrorState,
        currStateVector : StateVector,
        beat : Int
    ) : [Prediction] {
        let predictions = Buffer.Buffer<Prediction>(8);
        
        // Predict coherence change (based on recent trend)
        let coherenceTrend = if (state.errorHistory.size() > 0) {
            state.currentValue - state.previousValue
        } else { 0 };
        predictions.add(createPrediction(
            #CoherenceChange,
            coherenceTrend,
            700,
            10,  // 10 beats ahead
            beat
        ));
        
        // Predict drift change
        let driftPrediction = if (currStateVector.drift > 500) { 50 } else { -20 };
        predictions.add(createPrediction(
            #DriftChange,
            driftPrediction,
            600,
            10,
            beat
        ));
        
        // Predict energy change
        let energyPrediction = if (currStateVector.arousal > 600) { -30 } else { 20 };
        predictions.add(createPrediction(
            #EnergyChange,
            energyPrediction,
            650,
            10,
            beat
        ));
        
        // Predict emergence (low probability, high importance)
        let emergencePrediction = if (currStateVector.coherence > 800 and currStateVector.kfCoherence > 700) {
            500  // Likely
        } else {
            -500  // Unlikely
        };
        predictions.add(createPrediction(
            #EmergenceOccur,
            emergencePrediction,
            400,
            100,  // Longer horizon
            beat
        ));
        
        Buffer.toArray(predictions)
    };
    
    //=========================================================================
    // CONVENIENCE FUNCTIONS
    //=========================================================================
    
    public func isSurprised(state : PredictionErrorState) : Bool {
        state.deltaMagnitude > 300
    };
    
    public func getMajorSurpriseRatio(state : PredictionErrorState) : Int {
        if (state.totalBeats == 0) { 0 }
        else { state.majorSurprises * 1000 / state.totalBeats }
    };
    
    public func getValueTrend(state : PredictionErrorState) : Int {
        state.currentValue - state.valueBaseline
    };
    
    public func shouldBoostLearning(state : PredictionErrorState) : Bool {
        state.deltaMagnitude > 500 or state.freeEnergy.freeEnergy > 800
    };
    
    public func getHebbianModulation(state : PredictionErrorState) : Int {
        // Returns multiplier for Hebbian weight updates based on prediction error
        // High |δ| = faster learning
        1000 + state.deltaMagnitude
    };
}
