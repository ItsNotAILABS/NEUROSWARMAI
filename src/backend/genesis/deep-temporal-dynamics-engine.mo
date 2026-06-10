// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  DEEP TEMPORAL DYNAMICS ENGINE                                                                            ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║  Framework: Medina Doctrine                                                                               ║
// ║                                                                                                           ║
// ║  This module implements sophisticated temporal processing:                                                ║
// ║  • Multi-scale temporal integration (milliseconds to days)                                               ║
// ║  • Time cells and ramping neurons                                                                         ║
// ║  • Temporal difference learning                                                                           ║
// ║  • Sequence detection and prediction                                                                      ║
// ║  • Circadian rhythms and ultradian oscillations                                                          ║
// ║  • Temporal binding and segmentation                                                                      ║
// ║  • Event memory and temporal episodic encoding                                                           ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Iter "mo:core/Iter";
import Order "mo:core/Order";

module {
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  let PI : Float = 3.14159265358979323846;
  let TWO_PI : Float = 6.28318530717958647692;
  let PHI : Float = 1.61803398874989484820;
  let E : Float = 2.71828182845904523536;
  let SOVEREIGN_FLOOR : Float = 0.75;
  
  // Time constants (in nanoseconds)
  let MILLISECOND : Int = 1_000_000;
  let SECOND : Int = 1_000_000_000;
  let MINUTE : Int = 60_000_000_000;
  let HOUR : Int = 3_600_000_000_000;
  let DAY : Int = 86_400_000_000_000;
  
  // Circadian constants
  let CIRCADIAN_PERIOD : Float = 24.0; // hours
  let ULTRADIAN_90 : Float = 1.5;      // 90-minute BRAC cycle
  let ULTRADIAN_4 : Float = 4.0;       // 4-hour cycle
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - TIME CELLS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Time cell - fires at specific elapsed time
  public type TimeCell = {
    cellId : Nat;
    preferredTime : Int;              // Preferred firing time (ns from event)
    firingWidth : Int;                // Width of receptive field
    currentActivation : Float;
    peakActivation : Float;
    lastFiringTime : Int;
    reliability : Float;              // How reliably fires at preferred time
    sequenceId : ?Nat;                // Which sequence this cell belongs to
  };
  
  /// Ramping neuron - monotonically increases/decreases over interval
  public type RampingNeuron = {
    neuronId : Nat;
    rampDirection : RampDirection;
    rampDuration : Int;               // Total duration of ramp
    currentProgress : Float;          // 0.0 to 1.0
    rampRate : Float;                 // Change per second
    startValue : Float;
    endValue : Float;
    currentValue : Float;
    isActive : Bool;
    triggerThreshold : Float;
  };
  
  public type RampDirection = {
    #Ascending;
    #Descending;
    #Peaked;                          // Goes up then down
    #Troughed;                        // Goes down then up
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - TEMPORAL SEQUENCES
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Temporal sequence - ordered pattern of events
  public type TemporalSequence = {
    sequenceId : Nat;
    name : Text;
    events : [SequenceEvent];
    totalDuration : Int;
    currentPosition : Nat;            // Current event index
    playbackSpeed : Float;            // 1.0 = real-time
    isPlaying : Bool;
    looping : Bool;
    strength : Float;                 // How well-learned
    lastPlayTime : Int;
    playCount : Nat;
  };
  
  public type SequenceEvent = {
    eventIndex : Nat;
    onset : Int;                      // Time offset from sequence start
    duration : Int;
    content : [Float];                // Event representation
    label : Text;
    importance : Float;
    causalLinks : [Nat];              // Which events cause this one
  };
  
  /// Sequence prediction
  public type SequencePrediction = {
    sequenceId : Nat;
    nextEventIndex : Nat;
    predictedOnset : Int;
    confidence : Float;
    alternatives : [(Nat, Float)];    // (eventIndex, probability)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - TEMPORAL DIFFERENCE LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// TD Learning state
  public type TDLearningState = {
    var valueFunction : [Float];      // V(s) for each state
    var eligibilityTraces : [Float];  // e(s) for each state
    var stateVisits : [Nat];          // Visit counts
    var learningRate : Float;         // α
    var discountFactor : Float;       // γ
    var traceDecay : Float;           // λ
    var lastState : Nat;
    var lastReward : Float;
    var tdError : Float;              // δ
    var totalReward : Float;
  };
  
  /// TD Prediction
  public type TDPrediction = {
    stateIndex : Nat;
    predictedValue : Float;
    uncertainty : Float;
    temporalHorizon : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - CIRCADIAN SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Circadian oscillator
  public type CircadianOscillator = {
    var phase : Float;                // Current phase [0, 2π]
    var period : Float;               // Natural period (hours)
    var amplitude : Float;            // Oscillation amplitude
    var zeitgeberStrength : Float;    // External entrainment
    var lastZeitgeberTime : Int;
    var freeRunning : Bool;           // Without external cues
    var temperature : Float;          // Internal temperature rhythm
    var melatoninLevel : Float;       // Melatonin concentration
    var cortisolLevel : Float;        // Cortisol concentration
    var alertnessLevel : Float;       // Subjective alertness
  };
  
  /// Ultradian rhythm
  public type UltradianRhythm = {
    rhythmId : Nat;
    name : Text;
    period : Float;                   // Period in hours
    phase : Float;
    amplitude : Float;
    currentValue : Float;
    dominance : Float;                // How strong relative to others
    coupledTo : [Nat];               // Other rhythms it's coupled to
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - EPISODIC MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Temporal episode
  public type TemporalEpisode = {
    episodeId : Nat;
    startTime : Int;
    endTime : Int;
    events : [EpisodicEvent];
    context : [Float];                // Contextual features
    emotionalValence : Float;
    arousalLevel : Float;
    importance : Float;
    retrievalCount : Nat;
    lastRetrievalTime : Int;
    consolidationLevel : Float;       // How well consolidated
  };
  
  public type EpisodicEvent = {
    timestamp : Int;
    content : [Float];
    whatPath : [Float];               // Semantic content
    wherePath : [Float];              // Spatial location
    whenPath : [Float];               // Temporal encoding
    boundTo : [Nat];                  // Other events bound to this
  };
  
  /// Episode retrieval cue
  public type RetrievalCue = {
    contentCue : ?[Float];
    temporalCue : ?Int;
    spatialCue : ?[Float];
    emotionalCue : ?Float;
    contextCue : ?[Float];
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TYPE DEFINITIONS - TEMPORAL BINDING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Temporal binding window
  public type TemporalBindingWindow = {
    windowId : Nat;
    startTime : Int;
    duration : Int;                   // Window width
    boundEvents : Buffer.Buffer<BoundEvent>;
    coherence : Float;
    isOpen : Bool;
  };
  
  public type BoundEvent = {
    eventTime : Int;
    content : [Float];
    source : Text;
    bindingStrength : Float;
  };
  
  /// Event segmentation
  public type EventSegmentation = {
    var segments : Buffer.Buffer<TemporalSegment>;
    var currentSegment : ?TemporalSegment;
    var segmentationThreshold : Float;
    var predictionModel : PredictionModel;
  };
  
  public type TemporalSegment = {
    segmentId : Nat;
    startTime : Int;
    endTime : ?Int;
    events : [Int];                   // Event timestamps
    boundaryStrength : Float;         // How strong the segment boundary
    schema : ?Text;                   // Abstract schema label
  };
  
  public type PredictionModel = {
    transitionMatrix : [[Float]];
    currentState : Nat;
    predictionError : Float;
    surprisal : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MAIN STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TemporalDynamicsState = {
    // Time cells
    var timeCells : [var TimeCell];
    var numTimeCells : Nat;
    
    // Ramping neurons
    var rampingNeurons : [var RampingNeuron];
    var numRampingNeurons : Nat;
    
    // Sequences
    var sequences : Buffer.Buffer<TemporalSequence>;
    var activeSequences : [Nat];
    
    // TD Learning
    var tdLearning : TDLearningState;
    
    // Circadian
    var circadian : CircadianOscillator;
    var ultradianRhythms : [var UltradianRhythm];
    
    // Episodes
    var episodes : Buffer.Buffer<TemporalEpisode>;
    var currentEpisode : ?TemporalEpisode;
    var episodeCapacity : Nat;
    
    // Binding
    var bindingWindows : Buffer.Buffer<TemporalBindingWindow>;
    var eventSegmentation : EventSegmentation;
    
    // Integration
    var temporalCoherence : Float;
    var predictionAccuracy : Float;
    var timePerception : Float;       // Subjective time speed
    
    // Clock
    var tickCount : Nat;
    var lastTickTime : Int;
    var systemStartTime : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize temporal dynamics engine
  public func initTemporalDynamics(numTimeCells : Nat, numRampNeurons : Nat) : TemporalDynamicsState {
    let now = Time.now();
    
    {
      var timeCells = initTimeCells(numTimeCells);
      var numTimeCells = numTimeCells;
      var rampingNeurons = initRampingNeurons(numRampNeurons);
      var numRampingNeurons = numRampNeurons;
      var sequences = Buffer.Buffer<TemporalSequence>(64);
      var activeSequences = [];
      var tdLearning = initTDLearning(128);
      var circadian = initCircadian(now);
      var ultradianRhythms = initUltradian();
      var episodes = Buffer.Buffer<TemporalEpisode>(1024);
      var currentEpisode = null;
      var episodeCapacity = 1024;
      var bindingWindows = Buffer.Buffer<TemporalBindingWindow>(32);
      var eventSegmentation = initEventSegmentation();
      var temporalCoherence = SOVEREIGN_FLOOR;
      var predictionAccuracy = SOVEREIGN_FLOOR;
      var timePerception = 1.0;
      var tickCount = 0;
      var lastTickTime = now;
      var systemStartTime = now;
    }
  };
  
  func initTimeCells(n : Nat) : [var TimeCell] {
    Array.init<TimeCell>(n, func(i) {
      // Spread preferred times across different scales
      let scale = i / (n / 5);
      let baseTime = switch (scale) {
        case 0 { 100 * MILLISECOND };         // Fast cells
        case 1 { SECOND };                    // 1s cells
        case 2 { 10 * SECOND };               // 10s cells
        case 3 { MINUTE };                    // Minute cells
        case _ { 10 * MINUTE };               // Long cells
      };
      
      let offset = (i % (n / 5)) * baseTime / (n / 5);
      
      {
        cellId = i;
        preferredTime = baseTime + offset;
        firingWidth = baseTime / 10;
        currentActivation = 0.0;
        peakActivation = 1.0;
        lastFiringTime = 0;
        reliability = 0.8;
        sequenceId = null;
      }
    })
  };
  
  func initRampingNeurons(n : Nat) : [var RampingNeuron] {
    let directions : [RampDirection] = [#Ascending, #Descending, #Peaked, #Troughed];
    
    Array.init<RampingNeuron>(n, func(i) {
      let dirIdx = i % 4;
      {
        neuronId = i;
        rampDirection = directions[dirIdx];
        rampDuration = (i + 1) * SECOND;
        currentProgress = 0.0;
        rampRate = 1.0 / Float.fromInt((i + 1));
        startValue = if (dirIdx == 0 or dirIdx == 3) { 0.0 } else { 1.0 };
        endValue = if (dirIdx == 0 or dirIdx == 3) { 1.0 } else { 0.0 };
        currentValue = if (dirIdx == 0 or dirIdx == 3) { 0.0 } else { 1.0 };
        isActive = false;
        triggerThreshold = 0.5;
      }
    })
  };
  
  func initTDLearning(numStates : Nat) : TDLearningState {
    {
      var valueFunction = Array.init<Float>(numStates, 0.0);
      var eligibilityTraces = Array.init<Float>(numStates, 0.0);
      var stateVisits = Array.init<Nat>(numStates, 0);
      var learningRate = 0.1;
      var discountFactor = 0.99;
      var traceDecay = 0.9;
      var lastState = 0;
      var lastReward = 0.0;
      var tdError = 0.0;
      var totalReward = 0.0;
    }
  };
  
  func initCircadian(startTime : Int) : CircadianOscillator {
    // Start at 6 AM phase
    let hourOfDay = Float.fromInt((startTime / HOUR) % 24);
    let phase = (hourOfDay - 6.0) / 24.0 * TWO_PI;
    
    {
      var phase = phase;
      var period = CIRCADIAN_PERIOD;
      var amplitude = 1.0;
      var zeitgeberStrength = 0.5;
      var lastZeitgeberTime = startTime;
      var freeRunning = false;
      var temperature = 37.0 + 0.5 * Float.cos(phase); // Core body temp
      var melatoninLevel = Float.max(0.0, -Float.cos(phase)); // High at night
      var cortisolLevel = Float.max(0.0, Float.cos(phase + PI / 6.0)); // Morning peak
      var alertnessLevel = 0.7 + 0.3 * Float.cos(phase);
    }
  };
  
  func initUltradian() : [var UltradianRhythm] {
    Array.init<UltradianRhythm>(4, func(i) {
      let periods = [1.5, 4.0, 8.0, 12.0]; // BRAC, 4h, 8h, 12h
      let names = ["BRAC", "4-Hour", "8-Hour", "12-Hour"];
      {
        rhythmId = i;
        name = names[i];
        period = periods[i];
        phase = Float.fromInt(i) * PI / 4.0;
        amplitude = 1.0 / Float.fromInt(i + 1);
        currentValue = Float.cos(Float.fromInt(i) * PI / 4.0);
        dominance = 1.0 / Float.fromInt(i + 1);
        coupledTo = if (i > 0) { [i - 1] } else { [] };
      }
    })
  };
  
  func initEventSegmentation() : EventSegmentation {
    {
      var segments = Buffer.Buffer<TemporalSegment>(256);
      var currentSegment = null;
      var segmentationThreshold = 0.5;
      var predictionModel = {
        transitionMatrix = [];
        currentState = 0;
        predictionError = 0.0;
        surprisal = 0.0;
      };
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TIME CELL DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update time cells based on elapsed time since event
  public func updateTimeCells(state : TemporalDynamicsState, elapsedSinceEvent : Int) : [Float] {
    let activations = Array.init<Float>(state.numTimeCells, 0.0);
    
    for (i in Iter.range(0, state.numTimeCells - 1)) {
      let cell = state.timeCells[i];
      
      // Gaussian-like activation profile
      let timeDiff = Float.fromInt(elapsedSinceEvent - cell.preferredTime);
      let width = Float.fromInt(cell.firingWidth);
      let activation = cell.peakActivation * Float.exp(-(timeDiff * timeDiff) / (2.0 * width * width));
      
      // Apply reliability
      let reliableActivation = activation * cell.reliability;
      
      activations[i] := reliableActivation;
      
      state.timeCells[i] := {
        cell with
        currentActivation = reliableActivation;
        lastFiringTime = if (reliableActivation > 0.5) { Time.now() } else { cell.lastFiringTime };
      };
    };
    
    Array.freeze(activations)
  };
  
  /// Find cells that fire at given time
  public func findActiveCellsAtTime(state : TemporalDynamicsState, targetTime : Int) : [Nat] {
    let active = Buffer.Buffer<Nat>(16);
    
    for (i in Iter.range(0, state.numTimeCells - 1)) {
      let cell = state.timeCells[i];
      let timeDiff = Int.abs(targetTime - cell.preferredTime);
      
      if (timeDiff < cell.firingWidth) {
        active.add(i);
      };
    };
    
    Buffer.toArray(active)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // RAMPING NEURON DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Start a ramping neuron
  public func startRamp(state : TemporalDynamicsState, neuronIdx : Nat) : Bool {
    if (neuronIdx >= state.numRampingNeurons) return false;
    
    let neuron = state.rampingNeurons[neuronIdx];
    state.rampingNeurons[neuronIdx] := {
      neuron with
      isActive = true;
      currentProgress = 0.0;
      currentValue = neuron.startValue;
    };
    
    true
  };
  
  /// Update all ramping neurons
  public func updateRampingNeurons(state : TemporalDynamicsState, dt : Int) : [Float] {
    let values = Array.init<Float>(state.numRampingNeurons, 0.0);
    let dtSeconds = Float.fromInt(dt) / Float.fromInt(SECOND);
    
    for (i in Iter.range(0, state.numRampingNeurons - 1)) {
      let neuron = state.rampingNeurons[i];
      
      if (neuron.isActive) {
        // Update progress
        let progressIncrement = dtSeconds * neuron.rampRate;
        var newProgress = neuron.currentProgress + progressIncrement;
        
        // Compute current value based on direction
        var newValue : Float = 0.0;
        switch (neuron.rampDirection) {
          case (#Ascending) {
            newValue := neuron.startValue + newProgress * (neuron.endValue - neuron.startValue);
          };
          case (#Descending) {
            newValue := neuron.startValue + newProgress * (neuron.endValue - neuron.startValue);
          };
          case (#Peaked) {
            if (newProgress < 0.5) {
              newValue := neuron.startValue + newProgress * 2.0 * (1.0 - neuron.startValue);
            } else {
              newValue := 1.0 - (newProgress - 0.5) * 2.0 * (1.0 - neuron.endValue);
            };
          };
          case (#Troughed) {
            if (newProgress < 0.5) {
              newValue := neuron.startValue - newProgress * 2.0 * neuron.startValue;
            } else {
              newValue := (newProgress - 0.5) * 2.0 * neuron.endValue;
            };
          };
        };
        
        // Check if ramp completed
        let stillActive = newProgress < 1.0;
        if (not stillActive) {
          newProgress := 1.0;
          newValue := neuron.endValue;
        };
        
        values[i] := newValue;
        
        state.rampingNeurons[i] := {
          neuron with
          currentProgress = newProgress;
          currentValue = newValue;
          isActive = stillActive;
        };
      } else {
        values[i] := neuron.currentValue;
      };
    };
    
    Array.freeze(values)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // SEQUENCE PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Create a new sequence
  public func createSequence(state : TemporalDynamicsState, name : Text, events : [SequenceEvent]) : Nat {
    let sequenceId = state.sequences.size();
    
    var totalDuration : Int = 0;
    for (event in events.vals()) {
      let eventEnd = event.onset + event.duration;
      if (eventEnd > totalDuration) {
        totalDuration := eventEnd;
      };
    };
    
    let sequence : TemporalSequence = {
      sequenceId = sequenceId;
      name = name;
      events = events;
      totalDuration = totalDuration;
      currentPosition = 0;
      playbackSpeed = 1.0;
      isPlaying = false;
      looping = false;
      strength = 0.1;
      lastPlayTime = 0;
      playCount = 0;
    };
    
    state.sequences.add(sequence);
    sequenceId
  };
  
  /// Start sequence playback
  public func startSequence(state : TemporalDynamicsState, sequenceIdx : Nat) : Bool {
    if (sequenceIdx >= state.sequences.size()) return false;
    
    let seq = state.sequences.get(sequenceIdx);
    state.sequences.put(sequenceIdx, {
      seq with
      isPlaying = true;
      currentPosition = 0;
      lastPlayTime = Time.now();
    });
    
    // Add to active sequences
    let newActive = Buffer.Buffer<Nat>(8);
    for (idx in state.activeSequences.vals()) {
      if (idx != sequenceIdx) {
        newActive.add(idx);
      };
    };
    newActive.add(sequenceIdx);
    state.activeSequences := Buffer.toArray(newActive);
    
    true
  };
  
  /// Update active sequences
  public func updateSequences(state : TemporalDynamicsState) : [SequenceUpdate] {
    let updates = Buffer.Buffer<SequenceUpdate>(8);
    let currentTime = Time.now();
    
    for (seqIdx in state.activeSequences.vals()) {
      if (seqIdx < state.sequences.size()) {
        let seq = state.sequences.get(seqIdx);
        
        if (seq.isPlaying) {
          let elapsedReal = currentTime - seq.lastPlayTime;
          let elapsedScaled = Int.abs(Float.toInt(Float.fromInt(elapsedReal) * seq.playbackSpeed));
          
          // Find current event
          var foundEvent : ?SequenceEvent = null;
          var nextPosition = seq.currentPosition;
          
          for (i in Iter.range(seq.currentPosition, seq.events.size() - 1)) {
            let event = seq.events[i];
            if (elapsedScaled >= event.onset and elapsedScaled < event.onset + event.duration) {
              foundEvent := ?event;
              nextPosition := i;
            };
          };
          
          // Check if sequence ended
          var stillPlaying = elapsedScaled < seq.totalDuration;
          
          if (not stillPlaying and seq.looping) {
            stillPlaying := true;
            nextPosition := 0;
          };
          
          updates.add({
            sequenceIdx = seqIdx;
            currentEvent = foundEvent;
            position = nextPosition;
            progress = Float.fromInt(elapsedScaled) / Float.fromInt(seq.totalDuration);
            isComplete = not stillPlaying;
          });
          
          state.sequences.put(seqIdx, {
            seq with
            currentPosition = nextPosition;
            isPlaying = stillPlaying;
            playCount = if (not stillPlaying and not seq.looping) { seq.playCount + 1 } else { seq.playCount };
          });
        };
      };
    };
    
    Buffer.toArray(updates)
  };
  
  public type SequenceUpdate = {
    sequenceIdx : Nat;
    currentEvent : ?SequenceEvent;
    position : Nat;
    progress : Float;
    isComplete : Bool;
  };
  
  /// Predict next event in sequence
  public func predictNextEvent(state : TemporalDynamicsState, sequenceIdx : Nat) : ?SequencePrediction {
    if (sequenceIdx >= state.sequences.size()) return null;
    
    let seq = state.sequences.get(sequenceIdx);
    
    if (seq.currentPosition + 1 >= seq.events.size()) {
      return null;
    };
    
    let nextEvent = seq.events[seq.currentPosition + 1];
    let currentEvent = seq.events[seq.currentPosition];
    
    // Compute confidence based on sequence strength and regularity
    let confidence = seq.strength * 0.8 + 0.2;
    
    // Generate alternatives
    let alternatives = Buffer.Buffer<(Nat, Float)>(4);
    for (i in Iter.range(seq.currentPosition + 1, Nat.min(seq.currentPosition + 4, seq.events.size() - 1))) {
      let prob = 1.0 / Float.fromInt(i - seq.currentPosition + 1);
      alternatives.add((i, prob));
    };
    
    ?{
      sequenceId = seq.sequenceId;
      nextEventIndex = seq.currentPosition + 1;
      predictedOnset = nextEvent.onset;
      confidence = confidence;
      alternatives = Buffer.toArray(alternatives);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPORAL DIFFERENCE LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// TD update step
  public func tdUpdate(state : TemporalDynamicsState, currentState : Nat, reward : Float) : Float {
    let td = state.tdLearning;
    
    if (currentState >= td.valueFunction.size()) return 0.0;
    
    // Compute TD error: δ = r + γV(s') - V(s)
    let lastValue = if (td.lastState < td.valueFunction.size()) { 
      td.valueFunction[td.lastState]
    } else { 0.0 };
    
    let currentValue = td.valueFunction[currentState];
    let tdError = reward + td.discountFactor * currentValue - lastValue;
    
    // Update value function with eligibility traces
    for (s in Iter.range(0, td.valueFunction.size() - 1)) {
      // Decay trace
      td.eligibilityTraces[s] := td.traceDecay * td.discountFactor * td.eligibilityTraces[s];
      
      // Add current state to trace
      if (s == td.lastState) {
        td.eligibilityTraces[s] += 1.0;
      };
      
      // Update value
      td.valueFunction[s] := td.valueFunction[s] + td.learningRate * tdError * td.eligibilityTraces[s];
    };
    
    // Update visit count
    td.stateVisits[currentState] += 1;
    
    // Update state
    td.lastState := currentState;
    td.lastReward := reward;
    td.tdError := tdError;
    td.totalReward := td.totalReward + reward;
    
    tdError
  };
  
  /// Get TD prediction for state
  public func tdPredict(state : TemporalDynamicsState, stateIdx : Nat, horizon : Int) : TDPrediction {
    let td = state.tdLearning;
    
    let value = if (stateIdx < td.valueFunction.size()) {
      td.valueFunction[stateIdx]
    } else { 0.0 };
    
    let visits = if (stateIdx < td.stateVisits.size()) {
      td.stateVisits[stateIdx]
    } else { 0 };
    
    // Uncertainty decreases with visits
    let uncertainty = 1.0 / (1.0 + Float.fromInt(visits));
    
    {
      stateIndex = stateIdx;
      predictedValue = value;
      uncertainty = uncertainty;
      temporalHorizon = horizon;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // CIRCADIAN DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Update circadian oscillator
  public func updateCircadian(state : TemporalDynamicsState, currentTime : Int) : CircadianState {
    let circ = state.circadian;
    
    let elapsedHours = Float.fromInt((currentTime - state.systemStartTime) / HOUR);
    
    // Natural phase advance
    let phaseAdvance = (elapsedHours / circ.period) * TWO_PI;
    var newPhase = phaseAdvance;
    while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
    
    // Zeitgeber entrainment (if present)
    if (not circ.freeRunning) {
      let zeitgeberPhase = getZeitgeberPhase(currentTime);
      let phaseDiff = zeitgeberPhase - newPhase;
      newPhase := newPhase + circ.zeitgeberStrength * Float.sin(phaseDiff);
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
      while (newPhase < 0.0) { newPhase += TWO_PI };
    };
    
    // Update physiological markers
    let temperature = 37.0 + 0.5 * circ.amplitude * Float.cos(newPhase);
    let melatonin = Float.max(0.0, circ.amplitude * (-Float.cos(newPhase)));
    let cortisol = Float.max(0.0, circ.amplitude * Float.cos(newPhase + PI / 6.0));
    let alertness = 0.5 + 0.3 * circ.amplitude * Float.cos(newPhase) - 0.2 * melatonin;
    
    // Update state
    circ.phase := newPhase;
    circ.temperature := temperature;
    circ.melatoninLevel := melatonin;
    circ.cortisolLevel := cortisol;
    circ.alertnessLevel := Float.max(0.0, Float.min(1.0, alertness));
    
    {
      phase = newPhase;
      temperature = temperature;
      melatonin = melatonin;
      cortisol = cortisol;
      alertness = circ.alertnessLevel;
      hourOfDay = (newPhase / TWO_PI) * 24.0;
    }
  };
  
  func getZeitgeberPhase(currentTime : Int) : Float {
    // Assume light cycle: lights on at 6 AM, off at 10 PM
    let hourOfDay = Float.fromInt((currentTime / HOUR) % 24);
    let lightPhase = ((hourOfDay - 6.0) / 24.0) * TWO_PI;
    lightPhase
  };
  
  public type CircadianState = {
    phase : Float;
    temperature : Float;
    melatonin : Float;
    cortisol : Float;
    alertness : Float;
    hourOfDay : Float;
  };
  
  /// Update ultradian rhythms
  public func updateUltradian(state : TemporalDynamicsState, currentTime : Int) : [Float] {
    let elapsedHours = Float.fromInt((currentTime - state.systemStartTime) / HOUR);
    
    Array.tabulate<Float>(state.ultradianRhythms.size(), func(i) {
      let rhythm = state.ultradianRhythms[i];
      
      let phaseAdvance = (elapsedHours / rhythm.period) * TWO_PI;
      var newPhase = rhythm.phase + phaseAdvance;
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
      
      let newValue = rhythm.amplitude * Float.cos(newPhase);
      
      state.ultradianRhythms[i] := {
        rhythm with
        phase = newPhase;
        currentValue = newValue;
      };
      
      newValue
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EPISODIC MEMORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Begin a new episode
  public func beginEpisode(state : TemporalDynamicsState, context : [Float]) : Nat {
    let episodeId = state.episodes.size();
    let now = Time.now();
    
    let episode : TemporalEpisode = {
      episodeId = episodeId;
      startTime = now;
      endTime = now;
      events = [];
      context = context;
      emotionalValence = 0.0;
      arousalLevel = 0.5;
      importance = 0.5;
      retrievalCount = 0;
      lastRetrievalTime = 0;
      consolidationLevel = 0.0;
    };
    
    state.currentEpisode := ?episode;
    episodeId
  };
  
  /// Add event to current episode
  public func addEventToEpisode(
    state : TemporalDynamicsState,
    content : [Float],
    whatPath : [Float],
    wherePath : [Float]
  ) : Bool {
    switch (state.currentEpisode) {
      case (null) { false };
      case (?episode) {
        let now = Time.now();
        
        let event : EpisodicEvent = {
          timestamp = now;
          content = content;
          whatPath = whatPath;
          wherePath = wherePath;
          whenPath = encodeTime(now);
          boundTo = [];
        };
        
        let newEvents = Buffer.Buffer<EpisodicEvent>(episode.events.size() + 1);
        for (e in episode.events.vals()) {
          newEvents.add(e);
        };
        newEvents.add(event);
        
        state.currentEpisode := ?{
          episode with
          events = Buffer.toArray(newEvents);
          endTime = now;
        };
        
        true
      };
    }
  };
  
  func encodeTime(timestamp : Int) : [Float] {
    // Encode time at multiple scales
    let msInDay = Float.fromInt((timestamp / MILLISECOND) % 86400000);
    let hour = Float.fromInt((timestamp / HOUR) % 24);
    let dayOfWeek = Float.fromInt((timestamp / DAY) % 7);
    
    [
      msInDay / 86400000.0,
      hour / 24.0,
      dayOfWeek / 7.0,
      Float.sin(msInDay / 86400000.0 * TWO_PI),
      Float.cos(msInDay / 86400000.0 * TWO_PI)
    ]
  };
  
  /// End current episode
  public func endEpisode(state : TemporalDynamicsState, emotionalValence : Float, arousal : Float) : Bool {
    switch (state.currentEpisode) {
      case (null) { false };
      case (?episode) {
        let finalEpisode : TemporalEpisode = {
          episode with
          endTime = Time.now();
          emotionalValence = emotionalValence;
          arousalLevel = arousal;
          importance = Float.abs(emotionalValence) * arousal;
        };
        
        state.episodes.add(finalEpisode);
        state.currentEpisode := null;
        
        // Check capacity and consolidate if needed
        if (state.episodes.size() > state.episodeCapacity) {
          consolidateEpisodes(state);
        };
        
        true
      };
    }
  };
  
  func consolidateEpisodes(state : TemporalDynamicsState) {
    // Remove least important, least-retrieved episodes
    // (Simplified: just keep most recent)
    let toKeep = state.episodeCapacity * 3 / 4;
    if (state.episodes.size() <= toKeep) return;
    
    let toRemove = state.episodes.size() - toKeep;
    for (_ in Iter.range(0, toRemove - 1)) {
      ignore state.episodes.remove(0);
    };
  };
  
  /// Retrieve episodes matching cue
  public func retrieveEpisodes(state : TemporalDynamicsState, cue : RetrievalCue, maxResults : Nat) : [TemporalEpisode] {
    let matches = Buffer.Buffer<(Float, TemporalEpisode)>(maxResults);
    
    for (episode in state.episodes.vals()) {
      let score = computeRetrievalScore(episode, cue);
      if (score > 0.3) {
        matches.add((score, episode));
      };
    };
    
    // Sort by score (simplified: just take first maxResults)
    let sorted = Buffer.toArray(matches);
    let limited = if (sorted.size() > maxResults) {
      Array.tabulate<(Float, TemporalEpisode)>(maxResults, func(i) { sorted[i] })
    } else { sorted };
    
    Array.map<(Float, TemporalEpisode), TemporalEpisode>(limited, func((_, ep)) { ep })
  };
  
  func computeRetrievalScore(episode : TemporalEpisode, cue : RetrievalCue) : Float {
    var score : Float = 0.0;
    var factors : Float = 0.0;
    
    // Content similarity
    switch (cue.contentCue) {
      case (null) {};
      case (?contentVec) {
        if (episode.events.size() > 0) {
          score += computeCosineSimilarity(contentVec, episode.events[0].content);
          factors += 1.0;
        };
      };
    };
    
    // Temporal proximity
    switch (cue.temporalCue) {
      case (null) {};
      case (?targetTime) {
        let timeDiff = Float.abs(Float.fromInt(targetTime - episode.startTime));
        let temporalScore = Float.exp(-timeDiff / Float.fromInt(HOUR));
        score += temporalScore;
        factors += 1.0;
      };
    };
    
    // Emotional similarity
    switch (cue.emotionalCue) {
      case (null) {};
      case (?targetValence) {
        let valenceDiff = Float.abs(targetValence - episode.emotionalValence);
        score += 1.0 - valenceDiff;
        factors += 1.0;
      };
    };
    
    // Context similarity
    switch (cue.contextCue) {
      case (null) {};
      case (?contextVec) {
        score += computeCosineSimilarity(contextVec, episode.context);
        factors += 1.0;
      };
    };
    
    if (factors > 0.0) { score / factors } else { 0.0 }
  };
  
  func computeCosineSimilarity(v1 : [Float], v2 : [Float]) : Float {
    var dot : Float = 0.0;
    var norm1 : Float = 0.0;
    var norm2 : Float = 0.0;
    
    let n = Nat.min(v1.size(), v2.size());
    for (i in Iter.range(0, n - 1)) {
      dot += v1[i] * v2[i];
      norm1 += v1[i] * v1[i];
      norm2 += v2[i] * v2[i];
    };
    
    let denom = Float.sqrt(norm1) * Float.sqrt(norm2);
    if (denom < 0.0001) { 0.0 } else { dot / denom }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPORAL BINDING
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Open a temporal binding window
  public func openBindingWindow(state : TemporalDynamicsState, duration : Int) : Nat {
    let windowId = state.bindingWindows.size();
    let now = Time.now();
    
    let window : TemporalBindingWindow = {
      windowId = windowId;
      startTime = now;
      duration = duration;
      boundEvents = Buffer.Buffer<BoundEvent>(16);
      coherence = 1.0;
      isOpen = true;
    };
    
    state.bindingWindows.add(window);
    windowId
  };
  
  /// Add event to binding window
  public func bindEvent(state : TemporalDynamicsState, windowIdx : Nat, content : [Float], source : Text) : Bool {
    if (windowIdx >= state.bindingWindows.size()) return false;
    
    let window = state.bindingWindows.get(windowIdx);
    if (not window.isOpen) return false;
    
    let now = Time.now();
    if (now > window.startTime + window.duration) {
      // Window expired
      closeBindingWindow(state, windowIdx);
      return false;
    };
    
    let event : BoundEvent = {
      eventTime = now;
      content = content;
      source = source;
      bindingStrength = 1.0;
    };
    
    window.boundEvents.add(event);
    true
  };
  
  /// Close binding window and compute final coherence
  public func closeBindingWindow(state : TemporalDynamicsState, windowIdx : Nat) : Float {
    if (windowIdx >= state.bindingWindows.size()) return 0.0;
    
    let window = state.bindingWindows.get(windowIdx);
    
    // Compute coherence from bound events
    var coherence : Float = 1.0;
    let events = Buffer.toArray(window.boundEvents);
    
    if (events.size() > 1) {
      // Check temporal spread
      var minTime = events[0].eventTime;
      var maxTime = events[0].eventTime;
      
      for (event in events.vals()) {
        if (event.eventTime < minTime) { minTime := event.eventTime };
        if (event.eventTime > maxTime) { maxTime := event.eventTime };
      };
      
      let spread = Float.fromInt(maxTime - minTime);
      let windowWidth = Float.fromInt(window.duration);
      coherence := 1.0 - spread / windowWidth;
    };
    
    state.bindingWindows.put(windowIdx, {
      window with
      isOpen = false;
      coherence = Float.max(0.0, coherence);
    });
    
    coherence
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EVENT SEGMENTATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Process event for segmentation
  public func processEventForSegmentation(state : TemporalDynamicsState, eventContent : [Float]) : ?SegmentBoundary {
    let segmentation = state.eventSegmentation;
    let now = Time.now();
    
    // Compute prediction error
    let predError = computeEventPredictionError(state, eventContent);
    segmentation.predictionModel.predictionError := predError;
    segmentation.predictionModel.surprisal := -Float.log(1.0 / (1.0 + predError));
    
    // Check if boundary should be created
    if (predError > segmentation.segmentationThreshold) {
      // Close current segment
      let closedSegment = closeCurrentSegment(state);
      
      // Start new segment
      let newSegment : TemporalSegment = {
        segmentId = segmentation.segments.size();
        startTime = now;
        endTime = null;
        events = [now];
        boundaryStrength = predError;
        schema = null;
      };
      
      segmentation.currentSegment := ?newSegment;
      
      return ?{
        timestamp = now;
        boundaryStrength = predError;
        previousSegmentId = switch (closedSegment) { case (null) { 0 }; case (?s) { s.segmentId } };
        newSegmentId = newSegment.segmentId;
      };
    } else {
      // Add to current segment
      switch (segmentation.currentSegment) {
        case (null) {
          // Start first segment
          let newSegment : TemporalSegment = {
            segmentId = 0;
            startTime = now;
            endTime = null;
            events = [now];
            boundaryStrength = 0.0;
            schema = null;
          };
          segmentation.currentSegment := ?newSegment;
        };
        case (?segment) {
          let newEvents = Buffer.Buffer<Int>(segment.events.size() + 1);
          for (e in segment.events.vals()) { newEvents.add(e) };
          newEvents.add(now);
          
          segmentation.currentSegment := ?{
            segment with
            events = Buffer.toArray(newEvents);
          };
        };
      };
      
      null
    }
  };
  
  func computeEventPredictionError(state : TemporalDynamicsState, eventContent : [Float]) : Float {
    // Simplified: random-ish prediction error based on content novelty
    var sum : Float = 0.0;
    for (val in eventContent.vals()) {
      sum += Float.abs(val);
    };
    let avgContent = sum / Float.fromInt(eventContent.size());
    Float.abs(Float.sin(avgContent * 10.0))
  };
  
  func closeCurrentSegment(state : TemporalDynamicsState) : ?TemporalSegment {
    let segmentation = state.eventSegmentation;
    
    switch (segmentation.currentSegment) {
      case (null) { null };
      case (?segment) {
        let closedSegment : TemporalSegment = {
          segment with
          endTime = ?Time.now();
        };
        
        segmentation.segments.add(closedSegment);
        segmentation.currentSegment := null;
        
        ?closedSegment
      };
    }
  };
  
  public type SegmentBoundary = {
    timestamp : Int;
    boundaryStrength : Float;
    previousSegmentId : Nat;
    newSegmentId : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // MASTER TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Run one complete temporal dynamics tick
  public func runTemporalTick(state : TemporalDynamicsState, elapsedSinceEvent : Int) : TemporalTickResult {
    let now = Time.now();
    let dt = now - state.lastTickTime;
    
    // 1. Update time cells
    let timeCellActivations = updateTimeCells(state, elapsedSinceEvent);
    
    // 2. Update ramping neurons
    let rampValues = updateRampingNeurons(state, dt);
    
    // 3. Update sequences
    let sequenceUpdates = updateSequences(state);
    
    // 4. Update circadian
    let circadianState = updateCircadian(state, now);
    
    // 5. Update ultradian
    let ultradianValues = updateUltradian(state, now);
    
    // 6. Compute overall temporal coherence
    let coherence = computeTemporalCoherence(state, timeCellActivations, rampValues);
    state.temporalCoherence := Float.max(SOVEREIGN_FLOOR, coherence);
    
    // 7. Update time perception based on events and arousal
    let timePerception = computeTimePerception(state);
    state.timePerception := timePerception;
    
    state.tickCount += 1;
    state.lastTickTime := now;
    
    {
      timeCellActivations = timeCellActivations;
      rampValues = rampValues;
      sequenceUpdates = sequenceUpdates;
      circadianState = circadianState;
      ultradianValues = ultradianValues;
      temporalCoherence = state.temporalCoherence;
      timePerception = timePerception;
      activeEpisodeEvents = switch (state.currentEpisode) {
        case (null) { 0 };
        case (?ep) { ep.events.size() };
      };
      segmentCount = state.eventSegmentation.segments.size();
      tickDuration = Time.now() - now;
    }
  };
  
  func computeTemporalCoherence(state : TemporalDynamicsState, timeCells : [Float], ramps : [Float]) : Float {
    var sum : Float = 0.0;
    var count : Nat = 0;
    
    for (tc in timeCells.vals()) {
      sum += tc;
      count += 1;
    };
    
    for (r in ramps.vals()) {
      sum += r;
      count += 1;
    };
    
    if (count == 0) { SOVEREIGN_FLOOR }
    else { sum / Float.fromInt(count) }
  };
  
  func computeTimePerception(state : TemporalDynamicsState) : Float {
    // Time perception affected by arousal and event density
    let arousal = state.circadian.alertnessLevel;
    
    let eventDensity = switch (state.currentEpisode) {
      case (null) { 0.0 };
      case (?ep) {
        if (ep.endTime > ep.startTime) {
          Float.fromInt(ep.events.size()) / Float.fromInt((ep.endTime - ep.startTime) / SECOND)
        } else { 0.0 }
      };
    };
    
    // High arousal + many events = time flies (> 1.0)
    // Low arousal + few events = time drags (< 1.0)
    1.0 + (arousal - 0.5) * 0.2 + (eventDensity - 0.5) * 0.3
  };
  
  public type TemporalTickResult = {
    timeCellActivations : [Float];
    rampValues : [Float];
    sequenceUpdates : [SequenceUpdate];
    circadianState : CircadianState;
    ultradianValues : [Float];
    temporalCoherence : Float;
    timePerception : Float;
    activeEpisodeEvents : Nat;
    segmentCount : Nat;
    tickDuration : Int;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // QUERY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Get temporal dynamics status
  public func getTemporalStatus(state : TemporalDynamicsState) : TemporalStatus {
    {
      tickCount = state.tickCount;
      temporalCoherence = state.temporalCoherence;
      predictionAccuracy = state.predictionAccuracy;
      timePerception = state.timePerception;
      numTimeCells = state.numTimeCells;
      numRampingNeurons = state.numRampingNeurons;
      numSequences = state.sequences.size();
      activeSequences = state.activeSequences.size();
      numEpisodes = state.episodes.size();
      hasActiveEpisode = switch (state.currentEpisode) { case (null) { false }; case (_) { true } };
      circadianPhase = state.circadian.phase;
      alertnessLevel = state.circadian.alertnessLevel;
      segmentCount = state.eventSegmentation.segments.size();
    }
  };
  
  public type TemporalStatus = {
    tickCount : Nat;
    temporalCoherence : Float;
    predictionAccuracy : Float;
    timePerception : Float;
    numTimeCells : Nat;
    numRampingNeurons : Nat;
    numSequences : Nat;
    activeSequences : Nat;
    numEpisodes : Nat;
    hasActiveEpisode : Bool;
    circadianPhase : Float;
    alertnessLevel : Float;
    segmentCount : Nat;
  };
  
  /// Get TD learning status
  public func getTDStatus(state : TemporalDynamicsState) : TDStatus {
    let td = state.tdLearning;
    {
      learningRate = td.learningRate;
      discountFactor = td.discountFactor;
      traceDecay = td.traceDecay;
      lastTDError = td.tdError;
      totalReward = td.totalReward;
      numStates = td.valueFunction.size();
      currentState = td.lastState;
    }
  };
  
  public type TDStatus = {
    learningRate : Float;
    discountFactor : Float;
    traceDecay : Float;
    lastTDError : Float;
    totalReward : Float;
    numStates : Nat;
    currentState : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // EXTENDED TEMPORAL DYNAMICS - SEQUENCE LEARNING & PREDICTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Temporal sequence learning state
  public type SequenceLearningState = {
    var sequenceMemory : [TemporalSequence];
    var activeSequences : Buffer.Buffer<ActiveSequence>;
    var predictionBuffer : PredictionBuffer;
    var sequenceConfidence : Float;
    var noveltyDetector : NoveltyDetector;
    var chunkingEngine : ChunkingEngine;
    var hierarchicalSequences : HierarchicalSequences;
  };
  
  public type TemporalSequence = {
    sequenceId : Nat;
    elements : [[Float]];
    transitions : [[Float]];
    frequency : Nat;
    lastActivation : Int;
    strength : Float;
    length : Nat;
    context : [Float];
  };
  
  public type ActiveSequence = {
    sequenceId : Nat;
    currentPosition : Nat;
    activationStrength : Float;
    predictions : [[Float]];
    matchQuality : Float;
    startTime : Int;
  };
  
  public type PredictionBuffer = {
    var predictions : [[Float]];
    var confidences : [Float];
    var horizons : [Int];
    var outcomes : [[Float]];
    var predictionErrors : [Float];
    var updateRate : Float;
  };
  
  public type NoveltyDetector = {
    var baselineActivity : [Float];
    var noveltyThreshold : Float;
    var currentNovelty : Float;
    var habituationRate : Float;
    var sensitizationRate : Float;
    var noveltyHistory : Buffer.Buffer<NoveltyEvent>;
  };
  
  public type NoveltyEvent = {
    timestamp : Int;
    noveltyLevel : Float;
    stimulus : [Float];
    responseType : NoveltyResponse;
  };
  
  public type NoveltyResponse = {
    #Orienting;
    #Habituated;
    #Sensitized;
    #Neutral;
  };
  
  public type ChunkingEngine = {
    var chunks : [Chunk];
    var activeChunk : ?Nat;
    var chunkBoundaryDetection : Float;
    var compressionRatio : Float;
    var chunkHierarchy : [[Nat]];
  };
  
  public type Chunk = {
    chunkId : Nat;
    elements : [Nat];
    frequency : Nat;
    strength : Float;
    parentChunk : ?Nat;
    childChunks : [Nat];
  };
  
  public type HierarchicalSequences = {
    var levels : [SequenceLevel];
    var crossLevelBindings : [[Float]];
    var hierarchyDepth : Nat;
    var abstractionGradient : [Float];
  };
  
  public type SequenceLevel = {
    levelIndex : Nat;
    sequences : [TemporalSequence];
    temporalScale : Int;
    abstractionLevel : Float;
    representationDim : Nat;
  };
  
  /// Initialize sequence learning state
  public func initSequenceLearningState(maxSequences : Nat) : SequenceLearningState {
    {
      var sequenceMemory = [];
      var activeSequences = Buffer.Buffer<ActiveSequence>(32);
      var predictionBuffer = {
        var predictions = [];
        var confidences = [];
        var horizons = [];
        var outcomes = [];
        var predictionErrors = [];
        var updateRate = 0.1;
      };
      var noveltyDetector = {
        var baselineActivity = Array.tabulate<Float>(64, func(i) { 0.5 });
        var noveltyThreshold = 0.3;
        var currentNovelty = 0.0;
        var habituationRate = 0.1;
        var sensitizationRate = 0.05;
        var noveltyHistory = Buffer.Buffer<NoveltyEvent>(256);
      };
      var chunkingEngine = {
        var chunks = [];
        var activeChunk = null;
        var chunkBoundaryDetection = 0.6;
        var compressionRatio = 0.5;
        var chunkHierarchy = [];
      };
      var hierarchicalSequences = {
        var levels = Array.tabulate<SequenceLevel>(4, func(i) {
          {
            levelIndex = i;
            sequences = [];
            temporalScale = Nat.pow(10, i + 1) * 1_000_000;
            abstractionLevel = Float.fromInt(i) / 3.0;
            representationDim = 64 / (i + 1);
          }
        });
        var crossLevelBindings = Array.tabulate<[Float]>(4, func(i) {
          Array.tabulate<Float>(4, func(j) { if (i == j) { 1.0 } else { 0.3 } })
        });
        var hierarchyDepth = 4;
        var abstractionGradient = [0.0, 0.33, 0.67, 1.0];
      };
    }
  };
  
  /// Detect novelty in input
  public func detectNovelty(detector : NoveltyDetector, input : [Float], timestamp : Int) : Float {
    let inputSize = Nat.min(input.size(), detector.baselineActivity.size());
    var novelty : Float = 0.0;
    
    for (i in Iter.range(0, inputSize - 1)) {
      let diff = Float.abs(input[i] - detector.baselineActivity[i]);
      novelty += diff;
      
      // Update baseline with habituation
      detector.baselineActivity[i] := detector.baselineActivity[i] * (1.0 - detector.habituationRate) +
                                      input[i] * detector.habituationRate;
    };
    
    novelty /= Float.fromInt(inputSize);
    detector.currentNovelty := novelty;
    
    // Log novelty event if significant
    if (novelty > detector.noveltyThreshold) {
      detector.noveltyHistory.add({
        timestamp = timestamp;
        noveltyLevel = novelty;
        stimulus = input;
        responseType = if (novelty > detector.noveltyThreshold * 2.0) { #Sensitized } 
                      else { #Orienting };
      });
    };
    
    novelty
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // WORKING MEMORY TEMPORAL DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WorkingMemoryTemporalState = {
    var slots : [WMSlot];
    var centralExecutive : CentralExecutive;
    var phonologicalLoop : PhonologicalLoop;
    var visuospatialSketchpad : VisuospatialSketchpad;
    var episodicBuffer : EpisodicBuffer;
    var decayFunction : DecayFunction;
    var refreshMechanism : RefreshMechanism;
  };
  
  public type WMSlot = {
    slotId : Nat;
    content : [Float];
    strength : Float;
    lastRefresh : Int;
    priority : Float;
    sourceModality : Modality;
    bindingStrength : Float;
  };
  
  public type Modality = {
    #Visual;
    #Auditory;
    #Haptic;
    #Verbal;
    #Spatial;
    #Motor;
    #Abstract;
  };
  
  public type CentralExecutive = {
    var attentionalControl : Float;
    var taskSwitchingCost : Float;
    var inhibitionStrength : Float;
    var updateEfficiency : Float;
    var dualTaskCost : Float;
    var loadLevel : Float;
  };
  
  public type PhonologicalLoop = {
    var verbalContent : [[Float]];
    var articulatoryRehearsalRate : Float;
    var phonologicalStoreCapacity : Nat;
    var wordLengthEffect : Float;
    var phonologicalSimilarityEffect : Float;
  };
  
  public type VisuospatialSketchpad = {
    var visualCache : [[Float]];
    var spatialContent : [[Float]];
    var innerScribe : Float;
    var visualInterference : Float;
    var spatialInterference : Float;
  };
  
  public type EpisodicBuffer = {
    var boundRepresentations : [[Float]];
    var chronologicalIndex : [Int];
    var integrationStrength : Float;
    var ltmLink : Float;
    var chunkCapacity : Nat;
  };
  
  public type DecayFunction = {
    #Exponential : Float;
    #Power : Float;
    #Linear : Float;
    #ThresholdBased : Float;
  };
  
  public type RefreshMechanism = {
    var refreshRate : Float;
    var refreshPriority : [Float];
    var attentionalRefresh : Float;
    var automaticRefresh : Float;
    var refreshCost : Float;
  };
  
  /// Initialize working memory temporal state
  public func initWorkingMemoryTemporalState(numSlots : Nat) : WorkingMemoryTemporalState {
    {
      var slots = Array.tabulate<WMSlot>(numSlots, func(i) {
        {
          slotId = i;
          content = [];
          strength = 0.0;
          lastRefresh = 0;
          priority = 0.0;
          sourceModality = #Abstract;
          bindingStrength = 0.0;
        }
      });
      var centralExecutive = {
        var attentionalControl = 0.7;
        var taskSwitchingCost = 0.2;
        var inhibitionStrength = 0.6;
        var updateEfficiency = 0.7;
        var dualTaskCost = 0.3;
        var loadLevel = 0.0;
      };
      var phonologicalLoop = {
        var verbalContent = [];
        var articulatoryRehearsalRate = 2.0;
        var phonologicalStoreCapacity = 7;
        var wordLengthEffect = 0.3;
        var phonologicalSimilarityEffect = 0.25;
      };
      var visuospatialSketchpad = {
        var visualCache = [];
        var spatialContent = [];
        var innerScribe = 0.6;
        var visualInterference = 0.0;
        var spatialInterference = 0.0;
      };
      var episodicBuffer = {
        var boundRepresentations = [];
        var chronologicalIndex = [];
        var integrationStrength = 0.7;
        var ltmLink = 0.5;
        var chunkCapacity = 4;
      };
      var decayFunction = #Exponential(0.1);
      var refreshMechanism = {
        var refreshRate = 3.0;
        var refreshPriority = Array.tabulate<Float>(numSlots, func(i) { 0.5 });
        var attentionalRefresh = 0.8;
        var automaticRefresh = 0.2;
        var refreshCost = 0.1;
      };
    }
  };
  
  /// Apply decay to working memory contents
  public func applyWorkingMemoryDecay(wmState : WorkingMemoryTemporalState, currentTime : Int, dt : Float) {
    let decayRate = switch (wmState.decayFunction) {
      case (#Exponential(r)) { r };
      case (#Power(r)) { r };
      case (#Linear(r)) { r };
      case (#ThresholdBased(r)) { r };
    };
    
    for (i in Iter.range(0, wmState.slots.size() - 1)) {
      let slot = wmState.slots[i];
      let timeSinceRefresh = currentTime - slot.lastRefresh;
      let timeSeconds = Float.fromInt(timeSinceRefresh) / 1_000_000_000.0;
      
      let decayFactor = switch (wmState.decayFunction) {
        case (#Exponential(r)) { Float.exp(-r * timeSeconds) };
        case (#Power(r)) { 1.0 / Float.pow(1.0 + timeSeconds, r) };
        case (#Linear(r)) { Float.max(0.0, 1.0 - r * timeSeconds) };
        case (#ThresholdBased(r)) { if (timeSeconds > 1.0/r) { 0.0 } else { 1.0 } };
      };
      
      wmState.slots[i] := {
        slot with
        strength = slot.strength * decayFactor
      };
    };
  };
  
  /// Refresh working memory slot
  public func refreshWMSlot(wmState : WorkingMemoryTemporalState, slotIndex : Nat, currentTime : Int) {
    if (slotIndex < wmState.slots.size()) {
      let slot = wmState.slots[slotIndex];
      let refreshBoost = wmState.refreshMechanism.attentionalRefresh * 
                        wmState.centralExecutive.attentionalControl;
      
      wmState.slots[slotIndex] := {
        slot with
        strength = Float.min(1.0, slot.strength + refreshBoost);
        lastRefresh = currentTime;
      };
      
      // Apply refresh cost to central executive
      wmState.centralExecutive.loadLevel := wmState.centralExecutive.loadLevel + 
                                            wmState.refreshMechanism.refreshCost;
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // PROSPECTION & MENTAL TIME TRAVEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ProspectionState = {
    var futureSimulations : [FutureSimulation];
    var episodicFuture : EpisodicFutureState;
    var semanticFuture : SemanticFutureState;
    var planningHorizon : Int;
    var temporalPerspective : TemporalPerspective;
    var prospectiveMemory : ProspectiveMemory;
    var mentalTimeTravel : MentalTimeTravel;
  };
  
  public type FutureSimulation = {
    simulationId : Nat;
    scenario : [Float];
    probability : Float;
    desirability : Float;
    vividness : Float;
    emotionalValence : Float;
    temporalDistance : Int;
    causalChain : [[Float]];
  };
  
  public type EpisodicFutureState = {
    var preExperiencing : Float;
    var scenarioConstruction : Float;
    var detailGeneration : Float;
    var plausibilityAssessment : Float;
    var emotionalPreview : Float;
  };
  
  public type SemanticFutureState = {
    var schematicKnowledge : [[Float]];
    var scriptActivation : [Float];
    var categoryProjection : Float;
    var statisticalPrediction : Float;
    var baserate Utilization : Float;
  };
  
  public type TemporalPerspective = {
    var pastFocus : Float;
    var presentFocus : Float;
    var futureFocus : Float;
    var temporalExtension : Float;
    var temporalCoherence : Float;
  };
  
  public type ProspectiveMemory = {
    var intentions : [Intention];
    var eventBasedCues : [[Float]];
    var timeBasedTargets : [Int];
    var monitoringLevel : Float;
    var retrievalSuccessRate : Float;
  };
  
  public type Intention = {
    intentionId : Nat;
    content : [Float];
    cue : [Float];
    targetTime : ?Int;
    priority : Float;
    completed : Bool;
    creationTime : Int;
  };
  
  public type MentalTimeTravel = {
    var autonoetic Consciousness : Float;
    var selfProjection : Float;
    var temporalOrientation : Int;
    var experientialVividness : Float;
    var phenomenalContinuity : Float;
  };
  
  /// Initialize prospection state
  public func initProspectionState() : ProspectionState {
    {
      var futureSimulations = [];
      var episodicFuture = {
        var preExperiencing = 0.5;
        var scenarioConstruction = 0.6;
        var detailGeneration = 0.5;
        var plausibilityAssessment = 0.7;
        var emotionalPreview = 0.5;
      };
      var semanticFuture = {
        var schematicKnowledge = [];
        var scriptActivation = [];
        var categoryProjection = 0.6;
        var statisticalPrediction = 0.5;
        var baserateUtilization = 0.4;
      };
      var planningHorizon = 86_400_000_000_000; // 1 day in nanoseconds
      var temporalPerspective = {
        var pastFocus = 0.25;
        var presentFocus = 0.5;
        var futureFocus = 0.25;
        var temporalExtension = 0.5;
        var temporalCoherence = 0.7;
      };
      var prospectiveMemory = {
        var intentions = [];
        var eventBasedCues = [];
        var timeBasedTargets = [];
        var monitoringLevel = 0.5;
        var retrievalSuccessRate = 0.7;
      };
      var mentalTimeTravel = {
        var autonoeticConsciousness = 0.6;
        var selfProjection = 0.5;
        var temporalOrientation = 0;
        var experientialVividness = 0.5;
        var phenomenalContinuity = 0.7;
      };
    }
  };
  
  /// Generate future simulation
  public func generateFutureSimulation(
    prospState : ProspectionState,
    currentState : [Float],
    temporalDistance : Int
  ) : FutureSimulation {
    // Use episodic future thinking to construct scenario
    let scenarioQuality = prospState.episodicFuture.scenarioConstruction * 
                         prospState.episodicFuture.detailGeneration;
    
    let scenario = Array.tabulate<Float>(currentState.size(), func(i) {
      // Simple projection with noise
      currentState[i] * (1.0 + Float.sin(Float.fromInt(i)) * 0.2)
    });
    
    let simulation : FutureSimulation = {
      simulationId = Int.abs(Time.now() % 1000000);
      scenario = scenario;
      probability = prospState.episodicFuture.plausibilityAssessment * 0.8;
      desirability = 0.5;
      vividness = scenarioQuality;
      emotionalValence = prospState.episodicFuture.emotionalPreview;
      temporalDistance = temporalDistance;
      causalChain = [currentState, scenario];
    };
    
    simulation
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPORAL ATTENTION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TemporalAttentionState = {
    var temporalFocus : Int;
    var temporalWindow : Int;
    var temporalResolution : Float;
    var temporalPriority : [Float];
    var foreperiodEffect : Float;
    var temporalExpectation : TemporalExpectation;
    var rhythmicAttention : RhythmicAttention;
  };
  
  public type TemporalExpectation = {
    var expectedOnset : Int;
    var uncertainty : Float;
    var hazardRate : Float;
    var conditionalProbability : Float;
    var preparedness : Float;
  };
  
  public type RhythmicAttention = {
    var entrainedPhase : Float;
    var entrainedFrequency : Float;
    var entrainmentStrength : Float;
    var phaseAlignment : Float;
    var beatPrediction : Float;
  };
  
  /// Initialize temporal attention state
  public func initTemporalAttentionState() : TemporalAttentionState {
    {
      var temporalFocus = 0;
      var temporalWindow = 1_000_000_000; // 1 second
      var temporalResolution = 0.1;
      var temporalPriority = Array.tabulate<Float>(10, func(i) { 1.0 / Float.fromInt(i + 1) });
      var foreperiodEffect = 0.5;
      var temporalExpectation = {
        var expectedOnset = 0;
        var uncertainty = 0.3;
        var hazardRate = 0.1;
        var conditionalProbability = 0.5;
        var preparedness = 0.5;
      };
      var rhythmicAttention = {
        var entrainedPhase = 0.0;
        var entrainedFrequency = 1.0;
        var entrainmentStrength = 0.5;
        var phaseAlignment = 0.5;
        var beatPrediction = 0.6;
      };
    }
  };
  
  /// Update temporal attention
  public func updateTemporalAttention(taState : TemporalAttentionState, currentTime : Int, externalRhythm : Float) {
    // Update rhythmic entrainment
    let phaseDiff = Float.sin(2.0 * 3.14159 * externalRhythm - taState.rhythmicAttention.entrainedPhase);
    taState.rhythmicAttention.entrainedPhase := taState.rhythmicAttention.entrainedPhase +
      taState.rhythmicAttention.entrainmentStrength * phaseDiff * 0.1;
    
    // Update phase alignment
    taState.rhythmicAttention.phaseAlignment := 1.0 - Float.abs(phaseDiff) / 3.14159;
    
    // Update temporal expectation based on hazard rate
    let timeSinceExpected = Float.fromInt(currentTime - taState.temporalExpectation.expectedOnset) / 1_000_000_000.0;
    taState.temporalExpectation.conditionalProbability := 
      taState.temporalExpectation.hazardRate * Float.exp(-taState.temporalExpectation.hazardRate * timeSinceExpected);
    
    // Update preparedness
    taState.temporalExpectation.preparedness := Float.min(1.0, 
      taState.temporalExpectation.conditionalProbability * (1.0 - taState.temporalExpectation.uncertainty));
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED TEMPORAL DYNAMICS TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IntegratedTemporalState = {
    var baseState : TemporalDynamicsState;
    var sequenceLearning : SequenceLearningState;
    var workingMemory : WorkingMemoryTemporalState;
    var prospection : ProspectionState;
    var temporalAttention : TemporalAttentionState;
    var integratedTemporalCoherence : Float;
    var temporalProcessingEfficiency : Float;
  };
  
  /// Run integrated temporal dynamics tick
  public func runIntegratedTemporalTick(
    intState : IntegratedTemporalState,
    sensoryInput : [Float],
    currentTime : Int,
    dt : Float
  ) : IntegratedTemporalResult {
    let startTime = Time.now();
    
    // 1. Run base temporal dynamics
    let baseResult = runTemporalDynamicsTick(intState.baseState, currentTime);
    
    // 2. Detect novelty
    let novelty = detectNovelty(intState.sequenceLearning.noveltyDetector, sensoryInput, currentTime);
    
    // 3. Apply working memory decay
    applyWorkingMemoryDecay(intState.workingMemory, currentTime, dt);
    
    // 4. Update temporal attention
    updateTemporalAttention(intState.temporalAttention, currentTime, Float.sin(Float.fromInt(currentTime) * 0.000000001));
    
    // 5. Compute integrated temporal coherence
    intState.integratedTemporalCoherence := (
      baseResult.coherence * 0.3 +
      (1.0 - novelty) * 0.2 +
      intState.workingMemory.centralExecutive.attentionalControl * 0.25 +
      intState.temporalAttention.temporalExpectation.preparedness * 0.25
    );
    
    // 6. Compute temporal processing efficiency
    intState.temporalProcessingEfficiency := 
      intState.integratedTemporalCoherence * (1.0 - intState.workingMemory.centralExecutive.loadLevel);
    
    {
      baseResult = baseResult;
      noveltyLevel = novelty;
      workingMemoryLoad = intState.workingMemory.centralExecutive.loadLevel;
      temporalPreparedness = intState.temporalAttention.temporalExpectation.preparedness;
      rhythmicAlignment = intState.temporalAttention.rhythmicAttention.phaseAlignment;
      integratedCoherence = intState.integratedTemporalCoherence;
      processingEfficiency = intState.temporalProcessingEfficiency;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type IntegratedTemporalResult = {
    baseResult : TemporalTickResult;
    noveltyLevel : Float;
    workingMemoryLoad : Float;
    temporalPreparedness : Float;
    rhythmicAlignment : Float;
    integratedCoherence : Float;
    processingEfficiency : Float;
    processingTime : Int;
  };
  
  /// Get integrated temporal status
  public func getIntegratedTemporalStatus(intState : IntegratedTemporalState) : IntegratedTemporalStatus {
    {
      baseStatus = getTemporalDynamicsStatus(intState.baseState);
      sequenceLearningActive = intState.sequenceLearning.activeSequences.size() > 0;
      numActiveSequences = intState.sequenceLearning.activeSequences.size();
      currentNovelty = intState.sequenceLearning.noveltyDetector.currentNovelty;
      wmCapacityUsed = intState.workingMemory.centralExecutive.loadLevel;
      wmAttentionalControl = intState.workingMemory.centralExecutive.attentionalControl;
      prospectionHorizon = intState.prospection.planningHorizon;
      temporalPerspective = {
        past = intState.prospection.temporalPerspective.pastFocus;
        present = intState.prospection.temporalPerspective.presentFocus;
        future = intState.prospection.temporalPerspective.futureFocus;
      };
      rhythmicEntrainment = intState.temporalAttention.rhythmicAttention.entrainmentStrength;
      integratedCoherence = intState.integratedTemporalCoherence;
      processingEfficiency = intState.temporalProcessingEfficiency;
    }
  };
  
  public type IntegratedTemporalStatus = {
    baseStatus : TemporalDynamicsStatus;
    sequenceLearningActive : Bool;
    numActiveSequences : Nat;
    currentNovelty : Float;
    wmCapacityUsed : Float;
    wmAttentionalControl : Float;
    prospectionHorizon : Int;
    temporalPerspective : {
      past : Float;
      present : Float;
      future : Float;
    };
    rhythmicEntrainment : Float;
    integratedCoherence : Float;
    processingEfficiency : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // ADVANCED INTERVAL TIMING - SCALAR EXPECTANCY THEORY
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Scalar expectancy theory state
  public type ScalarExpectancyState = {
    var pacemaker : PacemakerState;
    var accumulator : AccumulatorState;
    var workingMemory : TimingWorkingMemory;
    var referenceMemory : ReferenceMemory;
    var comparator : ComparatorState;
    var decisionMechanism : TimingDecisionMechanism;
    var scalarProperty : Float;
  };
  
  public type PacemakerState = {
    var baseRate : Float;
    var currentRate : Float;
    var arousalModulation : Float;
    var attentionModulation : Float;
    var dopamineModulation : Float;
    var variability : Float;
    var pulseCount : Nat;
  };
  
  public type AccumulatorState = {
    var currentCount : Float;
    var gateOpen : Bool;
    var gateLatency : Float;
    var leakage : Float;
    var noise : Float;
    var switchLatency : Float;
  };
  
  public type TimingWorkingMemory = {
    var storedCount : Float;
    var storageNoise : Float;
    var retrievalNoise : Float;
    var decayRate : Float;
    var capacity : Nat;
    var currentLoad : Nat;
  };
  
  public type ReferenceMemory = {
    var storedDurations : [StoredDuration];
    var memoryStrength : [Float];
    var forgettingRate : Float;
    var interferenceSusceptibility : Float;
    var consolidationRate : Float;
  };
  
  public type StoredDuration = {
    durationId : Nat;
    targetDuration : Float;
    memorizedCount : Float;
    variance : Float;
    accessCount : Nat;
    lastAccess : Int;
  };
  
  public type ComparatorState = {
    var comparisonRatio : Float;
    var threshold : Float;
    var matchProbability : Float;
    var responseRule : ResponseRule;
    var confidenceLevel : Float;
  };
  
  public type ResponseRule = {
    #LowThreshold;
    #HighThreshold;
    #Optimal;
    #Conservative;
    #Liberal;
  };
  
  public type TimingDecisionMechanism = {
    var decisionVariable : Float;
    var criterionLevel : Float;
    var responseLatency : Float;
    var accuracyTradeoff : Float;
    var biasLevel : Float;
  };
  
  /// Initialize scalar expectancy state
  public func initScalarExpectancyState() : ScalarExpectancyState {
    {
      var pacemaker = {
        var baseRate = 5.0;
        var currentRate = 5.0;
        var arousalModulation = 1.0;
        var attentionModulation = 1.0;
        var dopamineModulation = 1.0;
        var variability = 0.1;
        var pulseCount = 0;
      };
      var accumulator = {
        var currentCount = 0.0;
        var gateOpen = false;
        var gateLatency = 0.05;
        var leakage = 0.01;
        var noise = 0.05;
        var switchLatency = 0.02;
      };
      var workingMemory = {
        var storedCount = 0.0;
        var storageNoise = 0.1;
        var retrievalNoise = 0.1;
        var decayRate = 0.01;
        var capacity = 4;
        var currentLoad = 0;
      };
      var referenceMemory = {
        var storedDurations = [];
        var memoryStrength = [];
        var forgettingRate = 0.001;
        var interferenceSusceptibility = 0.2;
        var consolidationRate = 0.1;
      };
      var comparator = {
        var comparisonRatio = 1.0;
        var threshold = 0.2;
        var matchProbability = 0.0;
        var responseRule = #Optimal;
        var confidenceLevel = 0.0;
      };
      var decisionMechanism = {
        var decisionVariable = 0.0;
        var criterionLevel = 0.5;
        var responseLatency = 0.0;
        var accuracyTradeoff = 0.5;
        var biasLevel = 0.0;
      };
      var scalarProperty = 0.15;
    }
  };
  
  /// Process interval timing
  public func processIntervalTiming(setState : ScalarExpectancyState, elapsed : Float, targetDuration : Float) : Float {
    // Pacemaker rate modulated by attention and arousal
    setState.pacemaker.currentRate := setState.pacemaker.baseRate * 
      setState.pacemaker.arousalModulation * setState.pacemaker.attentionModulation;
    
    // Accumulate pulses
    if (setState.accumulator.gateOpen) {
      let pulses = setState.pacemaker.currentRate * elapsed;
      setState.accumulator.currentCount := setState.accumulator.currentCount + pulses;
      setState.accumulator.currentCount := setState.accumulator.currentCount * (1.0 - setState.accumulator.leakage);
    };
    
    // Store in working memory
    setState.workingMemory.storedCount := setState.accumulator.currentCount * 
      (1.0 + (Float.sin(Float.fromInt(Time.now())) * setState.workingMemory.storageNoise));
    
    // Compare with target (from reference memory or given)
    let targetCount = targetDuration * setState.pacemaker.baseRate;
    setState.comparator.comparisonRatio := setState.workingMemory.storedCount / targetCount;
    
    // Scalar property: variance proportional to duration
    let variance = setState.scalarProperty * targetDuration;
    
    // Decision based on comparison ratio
    let deviation = Float.abs(setState.comparator.comparisonRatio - 1.0);
    setState.comparator.matchProbability := Float.exp(-deviation * deviation / (2.0 * variance * variance));
    
    // Response if probability exceeds threshold
    if (setState.comparator.matchProbability > setState.comparator.threshold) {
      setState.decisionMechanism.decisionVariable := setState.comparator.matchProbability;
    };
    
    setState.comparator.matchProbability
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // STRIATAL BEAT FREQUENCY MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type StriatalBeatFrequencyState = {
    var corticalOscillators : [CorticalOscillator];
    var striatalMediumSpinyNeurons : [MSNState];
    var coincidenceDetection : CoincidenceDetection;
    var dopamineSignal : DopamineTimingSignal;
    var learningMechanism : SBFLearning;
    var outputGating : SBFOutputGating;
  };
  
  public type CorticalOscillator = {
    oscillatorId : Nat;
    frequency : Float;
    phase : Float;
    amplitude : Float;
    noiseLevel : Float;
    corticalRegion : Text;
  };
  
  public type MSNState = {
    msnId : Nat;
    synapticWeights : [Float];
    firingThreshold : Float;
    activity : Float;
    targetDuration : Float;
    durationSelectivity : Float;
  };
  
  public type CoincidenceDetection = {
    var coincidenceWindow : Float;
    var requiredCoincidences : Nat;
    var detectionStrength : Float;
    var spatialPattern : [[Float]];
    var temporalPattern : [Float];
  };
  
  public type DopamineTimingSignal = {
    var startSignal : Float;
    var stopSignal : Float;
    var rewardPredictionError : Float;
    var d1Activation : Float;
    var d2Activation : Float;
    var timingModulation : Float;
  };
  
  public type SBFLearning = {
    var learningRate : Float;
    var eligibilityTrace : [Float];
    var rewardModulatedPlasticity : Float;
    var weightNormalization : Float;
    var selectivitySharpening : Float;
  };
  
  public type SBFOutputGating = {
    var gateState : Float;
    var motorReadout : Float;
    var responseGeneration : Float;
    var inhibitionStrength : Float;
    var thalamicinput : Float;
  };
  
  /// Initialize striatal beat frequency state
  public func initStriatalBeatFrequencyState(numOscillators : Nat, numMSNs : Nat) : StriatalBeatFrequencyState {
    {
      var corticalOscillators = Array.tabulate<CorticalOscillator>(numOscillators, func(i) {
        {
          oscillatorId = i;
          frequency = 5.0 + Float.fromInt(i) * 2.0;
          phase = Float.fromInt(i) * 0.3;
          amplitude = 0.5 + Float.sin(Float.fromInt(i)) * 0.2;
          noiseLevel = 0.05;
          corticalRegion = if (i < 10) { "PFC" } else if (i < 20) { "SMA" } else { "PMC" };
        }
      });
      var striatalMediumSpinyNeurons = Array.tabulate<MSNState>(numMSNs, func(i) {
        {
          msnId = i;
          synapticWeights = Array.tabulate<Float>(numOscillators, func(j) { 0.5 });
          firingThreshold = 0.7;
          activity = 0.0;
          targetDuration = Float.fromInt(i + 1) * 0.5;
          durationSelectivity = 0.8;
        }
      });
      var coincidenceDetection = {
        var coincidenceWindow = 0.01;
        var requiredCoincidences = 5;
        var detectionStrength = 0.0;
        var spatialPattern = [];
        var temporalPattern = [];
      };
      var dopamineSignal = {
        var startSignal = 0.0;
        var stopSignal = 0.0;
        var rewardPredictionError = 0.0;
        var d1Activation = 0.0;
        var d2Activation = 0.0;
        var timingModulation = 1.0;
      };
      var learningMechanism = {
        var learningRate = 0.01;
        var eligibilityTrace = Array.tabulate<Float>(numMSNs, func(i) { 0.0 });
        var rewardModulatedPlasticity = 0.5;
        var weightNormalization = 0.1;
        var selectivitySharpening = 0.2;
      };
      var outputGating = {
        var gateState = 0.0;
        var motorReadout = 0.0;
        var responseGeneration = 0.0;
        var inhibitionStrength = 0.8;
        var thalamicinput = 0.0;
      };
    }
  };
  
  /// Process striatal beat frequency
  public func processSBF(sbfState : StriatalBeatFrequencyState, dt : Float, targetDuration : Float) : Float {
    // Advance oscillator phases
    for (i in Iter.range(0, sbfState.corticalOscillators.size() - 1)) {
      let osc = sbfState.corticalOscillators[i];
      let newPhase = osc.phase + 2.0 * 3.14159 * osc.frequency * dt;
      sbfState.corticalOscillators[i] := {
        osc with
        phase = newPhase % (2.0 * 3.14159)
      };
    };
    
    // Compute MSN activations
    var maxActivation : Float = 0.0;
    var bestMSN : Nat = 0;
    
    for (msnIdx in Iter.range(0, sbfState.striatalMediumSpinyNeurons.size() - 1)) {
      let msn = sbfState.striatalMediumSpinyNeurons[msnIdx];
      
      // Sum weighted oscillator inputs
      var input : Float = 0.0;
      for (oscIdx in Iter.range(0, sbfState.corticalOscillators.size() - 1)) {
        let osc = sbfState.corticalOscillators[oscIdx];
        let oscOutput = osc.amplitude * Float.cos(osc.phase);
        input += oscOutput * msn.synapticWeights[oscIdx];
      };
      
      // Apply threshold
      let activation = if (input > msn.firingThreshold) { input } else { 0.0 };
      
      sbfState.striatalMediumSpinyNeurons[msnIdx] := {
        msn with
        activity = activation
      };
      
      // Track most active MSN
      if (activation > maxActivation and Float.abs(msn.targetDuration - targetDuration) < 0.5) {
        maxActivation := activation;
        bestMSN := msnIdx;
      };
    };
    
    // Coincidence detection
    sbfState.coincidenceDetection.detectionStrength := maxActivation;
    
    // Output gating
    if (maxActivation > sbfState.outputGating.inhibitionStrength) {
      sbfState.outputGating.gateState := 1.0;
      sbfState.outputGating.responseGeneration := maxActivation;
    } else {
      sbfState.outputGating.gateState := 0.0;
    };
    
    maxActivation
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // TEMPORAL CONTEXT MODEL
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type TemporalContextModelState = {
    var contextVector : [Float];
    var timeContextVector : [Float];
    var itemContextAssociations : [[Float]];
    var contextDriftRate : Float;
    var retrievalDynamics : TCMRetrievalDynamics;
    var recencyEffect : Float;
    var contiguityEffect : Float;
  };
  
  public type TCMRetrievalDynamics = {
    var cueStrength : Float;
    var competitionStrength : Float;
    var retrievalThreshold : Float;
    var samplingProbabilities : [Float];
    var recoveryProbability : Float;
  };
  
  /// Initialize temporal context model state
  public func initTemporalContextModelState(contextDim : Nat) : TemporalContextModelState {
    {
      var contextVector = Array.tabulate<Float>(contextDim, func(i) { 
        Float.cos(Float.fromInt(i) * 0.1) * 0.3 
      });
      var timeContextVector = Array.tabulate<Float>(contextDim, func(i) { 0.0 });
      var itemContextAssociations = [];
      var contextDriftRate = 0.1;
      var retrievalDynamics = {
        var cueStrength = 0.5;
        var competitionStrength = 0.3;
        var retrievalThreshold = 0.4;
        var samplingProbabilities = [];
        var recoveryProbability = 0.8;
      };
      var recencyEffect = 0.7;
      var contiguityEffect = 0.5;
    }
  };
  
  /// Update temporal context
  public func updateTemporalContext(tcmState : TemporalContextModelState, newItem : [Float]) {
    // Context drift
    let dim = tcmState.contextVector.size();
    let itemDim = newItem.size();
    
    for (i in Iter.range(0, dim - 1)) {
      // Old context decays
      tcmState.contextVector[i] := tcmState.contextVector[i] * (1.0 - tcmState.contextDriftRate);
      
      // New item contributes to context
      if (i < itemDim) {
        tcmState.contextVector[i] := tcmState.contextVector[i] + newItem[i] * tcmState.contextDriftRate;
      };
    };
    
    // Normalize context vector
    var norm : Float = 0.0;
    for (v in tcmState.contextVector.vals()) {
      norm += v * v;
    };
    norm := Float.sqrt(norm);
    
    if (norm > 0.001) {
      for (i in Iter.range(0, dim - 1)) {
        tcmState.contextVector[i] := tcmState.contextVector[i] / norm;
      };
    };
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════
  // INTEGRATED DEEP TEMPORAL TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeepIntegratedTemporalState = {
    var baseState : IntegratedTemporalState;
    var scalarExpectancy : ScalarExpectancyState;
    var striatalBeatFrequency : StriatalBeatFrequencyState;
    var temporalContextModel : TemporalContextModelState;
    var deepTemporalIntegration : Float;
    var timingAccuracy : Float;
  };
  
  /// Run deep integrated temporal tick
  public func runDeepIntegratedTemporalTick(
    deepState : DeepIntegratedTemporalState,
    sensoryInput : [Float],
    currentTime : Int,
    targetDuration : Float,
    dt : Float
  ) : DeepIntegratedTemporalResult {
    let startTime = Time.now();
    
    // 1. Run base temporal dynamics
    let baseResult = runIntegratedTemporalTick(deepState.baseState, sensoryInput, currentTime, dt);
    
    // 2. Process scalar expectancy timing
    let setAccuracy = processIntervalTiming(deepState.scalarExpectancy, dt, targetDuration);
    
    // 3. Process striatal beat frequency
    let sbfOutput = processSBF(deepState.striatalBeatFrequency, dt, targetDuration);
    
    // 4. Update temporal context
    updateTemporalContext(deepState.temporalContextModel, sensoryInput);
    
    // 5. Compute deep temporal integration
    deepState.deepTemporalIntegration := (
      baseResult.integratedCoherence * 0.3 +
      setAccuracy * 0.3 +
      sbfOutput * 0.2 +
      deepState.temporalContextModel.recencyEffect * 0.2
    );
    
    // 6. Compute overall timing accuracy
    deepState.timingAccuracy := (setAccuracy + sbfOutput) / 2.0;
    
    {
      baseResult = baseResult;
      setMatchProbability = setAccuracy;
      sbfCoincidenceStrength = sbfOutput;
      contextDriftRate = deepState.temporalContextModel.contextDriftRate;
      recencyEffect = deepState.temporalContextModel.recencyEffect;
      deepTemporalIntegration = deepState.deepTemporalIntegration;
      timingAccuracy = deepState.timingAccuracy;
      processingTime = Time.now() - startTime;
    }
  };
  
  public type DeepIntegratedTemporalResult = {
    baseResult : IntegratedTemporalResult;
    setMatchProbability : Float;
    sbfCoincidenceStrength : Float;
    contextDriftRate : Float;
    recencyEffect : Float;
    deepTemporalIntegration : Float;
    timingAccuracy : Float;
    processingTime : Int;
  };
  
  /// Get deep integrated temporal status
  public func getDeepIntegratedTemporalStatus(deepState : DeepIntegratedTemporalState) : DeepIntegratedTemporalStatus {
    {
      baseStatus = getIntegratedTemporalStatus(deepState.baseState);
      scalarExpectancyStatus = {
        pacemakerRate = deepState.scalarExpectancy.pacemaker.currentRate;
        accumulatorCount = deepState.scalarExpectancy.accumulator.currentCount;
        gateOpen = deepState.scalarExpectancy.accumulator.gateOpen;
        matchProbability = deepState.scalarExpectancy.comparator.matchProbability;
        scalarProperty = deepState.scalarExpectancy.scalarProperty;
      };
      sbfStatus = {
        numOscillators = deepState.striatalBeatFrequency.corticalOscillators.size();
        numMSNs = deepState.striatalBeatFrequency.striatalMediumSpinyNeurons.size();
        coincidenceStrength = deepState.striatalBeatFrequency.coincidenceDetection.detectionStrength;
        gateState = deepState.striatalBeatFrequency.outputGating.gateState;
        dopamineModulation = deepState.striatalBeatFrequency.dopamineSignal.timingModulation;
      };
      tcmStatus = {
        contextDriftRate = deepState.temporalContextModel.contextDriftRate;
        recencyEffect = deepState.temporalContextModel.recencyEffect;
        contiguityEffect = deepState.temporalContextModel.contiguityEffect;
        cueStrength = deepState.temporalContextModel.retrievalDynamics.cueStrength;
      };
      deepTemporalIntegration = deepState.deepTemporalIntegration;
      timingAccuracy = deepState.timingAccuracy;
    }
  };
  
  public type DeepIntegratedTemporalStatus = {
    baseStatus : IntegratedTemporalStatus;
    scalarExpectancyStatus : {
      pacemakerRate : Float;
      accumulatorCount : Float;
      gateOpen : Bool;
      matchProbability : Float;
      scalarProperty : Float;
    };
    sbfStatus : {
      numOscillators : Nat;
      numMSNs : Nat;
      coincidenceStrength : Float;
      gateState : Float;
      dopamineModulation : Float;
    };
    tcmStatus : {
      contextDriftRate : Float;
      recencyEffect : Float;
      contiguityEffect : Float;
      cueStrength : Float;
    };
    deepTemporalIntegration : Float;
    timingAccuracy : Float;
  };
}
