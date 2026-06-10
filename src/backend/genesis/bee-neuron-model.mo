// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝
import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";

module BeeNeuronModel {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CONSTANTS — Bee neural parameters
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TAU : Float = 6.28318530717958647692;
  
  // Network dimensions (matching Shell 3)
  public let KENYON_CELLS : Nat = 256;            // Mushroom body Kenyon cells
  public let PROJECTION_NEURONS : Nat = 64;       // From antennal lobe
  public let OUTPUT_NEURONS : Nat = 32;           // Mushroom body output neurons
  
  // Sparse coding parameters
  public let SPARSITY_TARGET : Float = 0.1;       // Only 10% of KCs active
  public let GABA_STRENGTH : Float = 0.8;         // Inhibitory strength
  public let LATERAL_INHIBITION : Float = 0.5;    // Lateral inhibition factor
  
  // Oscillation parameters
  public let ANCHOR_FREQUENCY_HZ : Float = 20.0;  // 20Hz anchor oscillation
  public let LFP_FREQUENCY_HZ : Float = 30.0;     // Local field potential
  public let WAGGLE_FREQUENCY_HZ : Float = 13.0;  // Waggle dance frequency
  
  // Timing parameters
  public let STDP_WINDOW_MS : Float = 20.0;       // STDP timing window
  public let MEMBRANE_TAU_MS : Float = 10.0;      // Membrane time constant

  // ═══════════════════════════════════════════════════════════════════════════════
  // KENYON CELL — Mushroom body principal neurons
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type KenyonCell = {
    id : Nat;
    // Membrane potential
    voltage : Float;
    threshold : Float;
    restingPotential : Float;
    // Synaptic inputs
    excitatory : [Float];         // From projection neurons
    inhibitory : Float;           // From GABA interneurons
    // State
    isActive : Bool;
    lastSpikeTime : ?Int;
    refractoryPeriod : Nat;
    // Plasticity
    eligibilityTrace : Float;
    dopamineModulation : Float;
  };
  
  public func initKenyonCell(id : Nat) : KenyonCell {
    {
      id = id;
      voltage = -70.0;            // mV
      threshold = -55.0;          // mV
      restingPotential = -70.0;   // mV
      excitatory = Array.tabulate<Float>(PROJECTION_NEURONS, func(_ : Nat) : Float { 0.0 });
      inhibitory = 0.0;
      isActive = false;
      lastSpikeTime = null;
      refractoryPeriod = 0;
      eligibilityTrace = 0.0;
      dopamineModulation = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // GABA INTERNEURON — Global inhibitory gating
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type GABAInterneuron = {
    id : Nat;
    // Monitors total KC activity
    activityIntegrator : Float;
    // Output inhibition
    inhibitoryOutput : Float;
    // Adaptation
    adaptationState : Float;
    adaptationRate : Float;
    // Target sparsity
    targetSparsity : Float;
    currentSparsity : Float;
  };
  
  public func initGABAInterneuron(id : Nat) : GABAInterneuron {
    {
      id = id;
      activityIntegrator = 0.0;
      inhibitoryOutput = 0.0;
      adaptationState = 0.0;
      adaptationRate = 0.05;
      targetSparsity = SPARSITY_TARGET;
      currentSparsity = 0.0;
    }
  };
  
  // Compute GABA inhibition to maintain sparsity
  public func computeGABAInhibition(
    gaba : GABAInterneuron,
    kenyonCells : [KenyonCell]
  ) : GABAInterneuron {
    // Count active KCs
    var activeCount : Nat = 0;
    var totalExcitation : Float = 0.0;
    
    for (kc in kenyonCells.vals()) {
      if (kc.isActive) { activeCount += 1 };
      totalExcitation += Float.max(0.0, kc.voltage - kc.restingPotential);
    };
    
    let currentSparsity = Float.fromInt(activeCount) / Float.fromInt(kenyonCells.size());
    
    // Adjust inhibition to maintain target sparsity
    let sparsityError = currentSparsity - gaba.targetSparsity;
    let adaptationDelta = gaba.adaptationRate * sparsityError;
    let newAdaptation = gaba.adaptationState + adaptationDelta;
    
    // Compute inhibitory output
    let baseInhibition = totalExcitation * GABA_STRENGTH;
    let adaptedInhibition = baseInhibition * (1.0 + newAdaptation);
    
    {
      id = gaba.id;
      activityIntegrator = totalExcitation;
      inhibitoryOutput = Float.max(0.0, adaptedInhibition);
      adaptationState = clamp(newAdaptation, -1.0, 2.0);
      adaptationRate = gaba.adaptationRate;
      targetSparsity = gaba.targetSparsity;
      currentSparsity = currentSparsity;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 20Hz ANCHOR OSCILLATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OscillatorState = {
    phase : Float;                // Current phase [0, 2π]
    frequency : Float;            // Hz
    amplitude : Float;            // Oscillation amplitude
    // Phase coupling
    kuramoto_r : Float;           // Order parameter
    kuramoto_psi : Float;         // Mean phase
    couplingStrength : Float;
  };
  
  public func initOscillator() : OscillatorState {
    {
      phase = 0.0;
      frequency = ANCHOR_FREQUENCY_HZ;
      amplitude = 1.0;
      kuramoto_r = 1.0;
      kuramoto_psi = 0.0;
      couplingStrength = 0.5;
    }
  };
  
  // Advance oscillator by one time step
  public func advanceOscillator(
    osc : OscillatorState,
    dt_ms : Float,
    externalPhase : Float
  ) : OscillatorState {
    // Phase increment
    let omega = TAU * osc.frequency / 1000.0;  // rad/ms
    let phaseIncrement = omega * dt_ms;
    
    // Kuramoto coupling to external phase
    let phaseDiff = externalPhase - osc.phase;
    let couplingTerm = osc.couplingStrength * Float.sin(phaseDiff);
    
    var newPhase = osc.phase + phaseIncrement + couplingTerm * dt_ms;
    
    // Wrap phase to [0, 2π]
    while (newPhase >= TAU) { newPhase -= TAU };
    while (newPhase < 0.0) { newPhase += TAU };
    
    {
      phase = newPhase;
      frequency = osc.frequency;
      amplitude = osc.amplitude;
      kuramoto_r = Float.cos(phaseDiff);
      kuramoto_psi = externalPhase;
      couplingStrength = osc.couplingStrength;
    }
  };
  
  // Get oscillatory modulation factor
  public func getOscillatoryModulation(osc : OscillatorState) : Float {
    (1.0 + osc.amplitude * Float.sin(osc.phase)) / 2.0
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WAGGLE DANCE COMPRESSION — Efficient pattern encoding
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WaggleCode = {
    // Compressed representation
    activeIndices : [Nat8];       // Which KCs are active (sparse)
    durations : [Nat8];           // Relative activity durations
    angles : [Nat8];              // Phase angles
    // Metadata
    patternId : Nat;
    confidence : Float;
    timestamp : Int;
  };
  
  // Compress KC activity pattern into waggle code
  public func compressToWaggle(
    kenyonCells : [KenyonCell],
    patternId : Nat,
    currentTime : Int
  ) : WaggleCode {
    let activeIndices = Buffer.Buffer<Nat8>(KENYON_CELLS / 10);
    let durations = Buffer.Buffer<Nat8>(KENYON_CELLS / 10);
    let angles = Buffer.Buffer<Nat8>(KENYON_CELLS / 10);
    
    for (kc in kenyonCells.vals()) {
      if (kc.isActive and kc.id < 256) {
        activeIndices.add(Nat8.fromNat(kc.id));
        
        // Encode duration based on eligibility trace
        let durationByte = Nat8.fromNat(Int.abs(Float.toInt(kc.eligibilityTrace * 255.0)));
        durations.add(durationByte);
        
        // Encode phase angle
        let angleByte = switch (kc.lastSpikeTime) {
          case (?t) {
            let phase = Float.fromInt(currentTime - t) / 100.0;
            Nat8.fromNat(Int.abs(Float.toInt((phase - Float.floor(phase)) * 255.0)))
          };
          case null { 0 : Nat8 };
        };
        angles.add(angleByte);
      };
    };
    
    let totalActive = activeIndices.size();
    let confidence = if (totalActive > 0) {
      1.0 - Float.abs(Float.fromInt(totalActive) / Float.fromInt(KENYON_CELLS) - SPARSITY_TARGET) / SPARSITY_TARGET
    } else { 0.0 };
    
    {
      activeIndices = Buffer.toArray(activeIndices);
      durations = Buffer.toArray(durations);
      angles = Buffer.toArray(angles);
      patternId = patternId;
      confidence = clamp(confidence, 0.0, 1.0);
      timestamp = currentTime;
    }
  };
  
  // Decompress waggle code back to KC activations
  public func decompressWaggle(
    code : WaggleCode,
    kenyonCells : [var KenyonCell]
  ) : () {
    // Reset all KCs
    for (i in Iter.range(0, kenyonCells.size() - 1)) {
      kenyonCells[i] := {
        id = kenyonCells[i].id;
        voltage = kenyonCells[i].restingPotential;
        threshold = kenyonCells[i].threshold;
        restingPotential = kenyonCells[i].restingPotential;
        excitatory = kenyonCells[i].excitatory;
        inhibitory = 0.0;
        isActive = false;
        lastSpikeTime = kenyonCells[i].lastSpikeTime;
        refractoryPeriod = 0;
        eligibilityTrace = 0.0;
        dopamineModulation = kenyonCells[i].dopamineModulation;
      };
    };
    
    // Activate encoded KCs
    for (j in Iter.range(0, code.activeIndices.size() - 1)) {
      let idx = Nat8.toNat(code.activeIndices[j]);
      if (idx < kenyonCells.size()) {
        let duration = Float.fromInt(Nat8.toNat(code.durations[j])) / 255.0;
        kenyonCells[idx] := {
          id = kenyonCells[idx].id;
          voltage = kenyonCells[idx].threshold + 10.0;  // Suprathreshold
          threshold = kenyonCells[idx].threshold;
          restingPotential = kenyonCells[idx].restingPotential;
          excitatory = kenyonCells[idx].excitatory;
          inhibitory = 0.0;
          isActive = true;
          lastSpikeTime = kenyonCells[idx].lastSpikeTime;
          refractoryPeriod = 0;
          eligibilityTrace = duration;
          dopamineModulation = kenyonCells[idx].dopamineModulation;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PATTERN RECOGNITION — Odor-like pattern matching
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PatternMemory = {
    storedPatterns : [WaggleCode];
    recognitionThreshold : Float;
    maxPatterns : Nat;
    totalRecognitions : Nat;
    avgRecognitionConfidence : Float;
  };
  
  public func initPatternMemory() : PatternMemory {
    {
      storedPatterns = [];
      recognitionThreshold = 0.7;
      maxPatterns = 1000;
      totalRecognitions = 0;
      avgRecognitionConfidence = 0.0;
    }
  };
  
  // Compare two waggle codes
  public func comparePatterns(a : WaggleCode, b : WaggleCode) : Float {
    if (a.activeIndices.size() == 0 or b.activeIndices.size() == 0) {
      return 0.0;
    };
    
    // Count overlapping active indices
    var overlap : Nat = 0;
    
    for (idxA in a.activeIndices.vals()) {
      for (idxB in b.activeIndices.vals()) {
        if (Nat8.equal(idxA, idxB)) {
          overlap += 1;
        };
      };
    };
    
    // Jaccard similarity
    let union = a.activeIndices.size() + b.activeIndices.size() - overlap;
    if (union > 0) {
      Float.fromInt(overlap) / Float.fromInt(union)
    } else { 0.0 }
  };
  
  // Recognize pattern
  public func recognizePattern(
    memory : PatternMemory,
    input : WaggleCode
  ) : ?(Nat, Float) {
    var bestMatch : ?Nat = null;
    var bestScore : Float = 0.0;
    
    for (i in Iter.range(0, memory.storedPatterns.size() - 1)) {
      let stored = memory.storedPatterns[i];
      let similarity = comparePatterns(input, stored);
      
      if (similarity > bestScore) {
        bestScore := similarity;
        bestMatch := ?stored.patternId;
      };
    };
    
    if (bestScore >= memory.recognitionThreshold) {
      switch (bestMatch) {
        case (?id) { ?(id, bestScore) };
        case null { null };
      }
    } else { null }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DOPAMINE MODULATION — Reward-based learning
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DopamineState = {
    level : Float;                // [0, 1]
    baseline : Float;
    rewardPredictionError : Float;
    lastReward : Float;
    accumulator : Float;
  };
  
  public func initDopamineState() : DopamineState {
    {
      level = 0.5;
      baseline = 0.5;
      rewardPredictionError = 0.0;
      lastReward = 0.0;
      accumulator = 0.0;
    }
  };
  
  // Update dopamine based on reward
  public func updateDopamine(
    state : DopamineState,
    reward : Float,
    prediction : Float
  ) : DopamineState {
    let rpe = reward - prediction;  // Reward prediction error
    let newLevel = clamp(state.baseline + rpe, 0.0, 1.0);
    let newAccumulator = state.accumulator + Float.abs(rpe);
    
    {
      level = newLevel;
      baseline = state.baseline;
      rewardPredictionError = rpe;
      lastReward = reward;
      accumulator = newAccumulator;
    }
  };
  
  // Apply dopamine modulation to KC
  public func applyDopamineModulation(
    kc : KenyonCell,
    dopamine : DopamineState
  ) : KenyonCell {
    // Dopamine gates eligibility trace update
    let modulatedTrace = kc.eligibilityTrace * dopamine.level;
    
    {
      id = kc.id;
      voltage = kc.voltage;
      threshold = kc.threshold;
      restingPotential = kc.restingPotential;
      excitatory = kc.excitatory;
      inhibitory = kc.inhibitory;
      isActive = kc.isActive;
      lastSpikeTime = kc.lastSpikeTime;
      refractoryPeriod = kc.refractoryPeriod;
      eligibilityTrace = modulatedTrace;
      dopamineModulation = dopamine.level;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE BEE NETWORK STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BeeNetworkState = {
    kenyonCells : [var KenyonCell];
    gabaInterneurons : [var GABAInterneuron];
    oscillator : OscillatorState;
    patternMemory : PatternMemory;
    dopamine : DopamineState;
    // Statistics
    currentSparsity : Float;
    avgFiringRate : Float;
    patternCount : Nat;
    lastTick : Int;
  };
  
  public func initBeeNetwork() : BeeNetworkState {
    let kcs = Array.tabulateVar<KenyonCell>(KENYON_CELLS, func(i : Nat) : KenyonCell {
      initKenyonCell(i)
    });
    
    let gabas = Array.tabulateVar<GABAInterneuron>(4, func(i : Nat) : GABAInterneuron {
      initGABAInterneuron(i)
    });
    
    {
      kenyonCells = kcs;
      gabaInterneurons = gabas;
      oscillator = initOscillator();
      patternMemory = initPatternMemory();
      dopamine = initDopamineState();
      currentSparsity = 0.0;
      avgFiringRate = 0.0;
      patternCount = 0;
      lastTick = 0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BEE NETWORK TICK
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BeeTickResult = {
    activeKenyonCells : Nat;
    sparsity : Float;
    oscillatorPhase : Float;
    patternRecognized : ?Nat;
    dopamineLevel : Float;
    gabaInhibition : Float;
  };
  
  public func beeTick(
    state : BeeNetworkState,
    inputPattern : [Float],      // Projection neuron activations
    dt_ms : Float,
    externalPhase : Float,
    currentTime : Int
  ) : BeeTickResult {
    // 1. Advance oscillator
    let newOsc = advanceOscillator(state.oscillator, dt_ms, externalPhase);
    let oscMod = getOscillatoryModulation(newOsc);
    
    // 2. Update GABA inhibition
    let frozenKCs = Array.freeze(state.kenyonCells);
    var totalInhibition : Float = 0.0;
    for (i in Iter.range(0, state.gabaInterneurons.size() - 1)) {
      let newGaba = computeGABAInhibition(state.gabaInterneurons[i], frozenKCs);
      state.gabaInterneurons[i] := newGaba;
      totalInhibition += newGaba.inhibitoryOutput;
    };
    let avgInhibition = totalInhibition / Float.fromInt(state.gabaInterneurons.size());
    
    // 3. Update Kenyon cells
    var activeCount : Nat = 0;
    let inputSize = inputPattern.size();
    
    for (i in Iter.range(0, state.kenyonCells.size() - 1)) {
      let kc = state.kenyonCells[i];
      
      // Sum excitatory input with oscillatory modulation
      var excitation : Float = 0.0;
      for (j in Iter.range(0, Nat.min(PROJECTION_NEURONS, inputSize) - 1)) {
        excitation += inputPattern[j] * oscMod;
      };
      
      // Apply GABA inhibition
      let netInput = excitation - avgInhibition;
      
      // Update membrane potential
      let leak = (kc.restingPotential - kc.voltage) / MEMBRANE_TAU_MS * dt_ms;
      var newVoltage = kc.voltage + leak + netInput;
      
      // Check threshold
      let willSpike = newVoltage >= kc.threshold and kc.refractoryPeriod == 0;
      
      if (willSpike) {
        activeCount += 1;
        newVoltage := kc.restingPotential - 10.0;  // Hyperpolarization
      };
      
      state.kenyonCells[i] := {
        id = kc.id;
        voltage = newVoltage;
        threshold = kc.threshold;
        restingPotential = kc.restingPotential;
        excitatory = kc.excitatory;
        inhibitory = avgInhibition;
        isActive = willSpike;
        lastSpikeTime = if (willSpike) { ?currentTime } else { kc.lastSpikeTime };
        refractoryPeriod = if (willSpike) { 2 } else { Nat.max(0, Int.abs(kc.refractoryPeriod - 1)) };
        eligibilityTrace = if (willSpike) { 1.0 } else { kc.eligibilityTrace * 0.95 };
        dopamineModulation = kc.dopamineModulation;
      };
    };
    
    let sparsity = Float.fromInt(activeCount) / Float.fromInt(KENYON_CELLS);
    
    // 4. Pattern recognition
    let currentPattern = compressToWaggle(Array.freeze(state.kenyonCells), state.patternCount, currentTime);
    let recognized = recognizePattern(state.patternMemory, currentPattern);
    
    {
      activeKenyonCells = activeCount;
      sparsity = sparsity;
      oscillatorPhase = newOsc.phase;
      patternRecognized = switch (recognized) { case (?(id, _)) { ?id }; case null { null } };
      dopamineLevel = state.dopamine.level;
      gabaInhibition = avgInhibition;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}
