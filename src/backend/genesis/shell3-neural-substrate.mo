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
import Nat16 "mo:core/Nat16";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Blob "mo:core/Blob";
import Principal "mo:core/Principal";

module Shell3NeuralSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL 3 CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  
  // Shell 3 dimensions
  public let SHELL3_NODE_COUNT : Nat = 256;
  public let SHELL3_WEIGHT_COUNT : Nat = 65536;  // 256 × 256
  
  // Neural dynamics
  public let SHELL3_ETA : Float = 0.002;         // Learning rate
  public let SHELL3_DECAY : Float = 0.0002;      // Weight decay
  public let SHELL3_THRESHOLD : Float = 0.5;     // Firing threshold
  public let SHELL3_REFRACTORY : Nat8 = 3;       // Refractory period (beats)
  
  // Frequency bands for Shell 3 (cognitive processing)
  public let SHELL3_FREQ_MIN : Float = 8.0;      // Alpha start (8 Hz)
  public let SHELL3_FREQ_MAX : Float = 40.0;     // Gamma end (40 Hz)
  
  // QSOV sovereignty thresholds
  public let QSOV_FLOOR : Float = 0.75;          // Minimum sovereignty
  public let QSOV_CEILING : Float = 1.5;         // Maximum (can exceed 1.0)

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL 3 NEURON — Individual processing unit
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Shell3Neuron = {
    id : Nat8;                    // 0-255
    position : NeuronPosition;    // Spatial location in graph
    frequency : Float;            // Natural frequency (Hz)
    phase : Float;                // Current phase [0, 2π)
    amplitude : Float;            // Oscillation amplitude
    membrane : Float;             // Membrane potential
    activation : Float;           // Current activation [0, 1]
    threshold : Float;            // Firing threshold
    refractoryRemaining : Nat8;   // Refractory countdown
    spikeCount : Nat;             // Total spikes
    lastSpike : Int;              // Beat of last spike
    localCoherence : Float;       // Coherence with neighbors
    receptiveField : [Nat8];      // Input neuron IDs
    projectiveField : [Nat8];     // Output neuron IDs
  };
  
  public type NeuronPosition = {
    x : Float;                    // [-1, 1]
    y : Float;                    // [-1, 1]
    z : Float;                    // Layer depth [0, 1]
    region : NeuralRegion;
  };
  
  public type NeuralRegion = {
    #Sensory;           // Input processing (0-63)
    #Association;       // Integration (64-127)
    #Executive;         // Decision making (128-191)
    #Motor;             // Output generation (192-255)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL 3 WEIGHT MATRIX — 65,536 synaptic connections
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Shell3WeightMatrix = {
    // 256 × 256 = 65,536 weights
    // Organized as 16 blocks of 16×16 sub-matrices (4,096 weights per block)
    blocks : [[var Float]];       // 16 blocks × 4,096 weights
    eligibility : [[var Float]];  // Eligibility traces
    ltpHistory : [[var Nat16]];   // LTP event counts per block
    ltdHistory : [[var Nat16]];   // LTD event counts per block
    lastUpdate : Int;
    totalLTP : Nat;
    totalLTD : Nat;
    sparsity : Float;             // Fraction of near-zero weights
  };
  
  public func initShell3WeightMatrix() : Shell3WeightMatrix {
    let numBlocks : Nat = 16;
    let blockSize : Nat = 4096;   // 16 × 16 × 16 (256/16 = 16)
    
    let blocks = Array.init<[var Float]>(numBlocks, func(b : Nat) : [var Float] {
      Array.init<Float>(blockSize, func(w : Nat) : Float {
        // Initialize with distance-based weights
        let row = (b / 4) * 64 + (w / 256);
        let col = (b % 4) * 64 + (w % 256);
        let distance = Float.abs(Float.fromInt(row) - Float.fromInt(col));
        0.2 * exp(-distance / 30.0) + 0.05
      })
    });
    
    let eligibility = Array.init<[var Float]>(numBlocks, func(_ : Nat) : [var Float] {
      Array.init<Float>(blockSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let ltpHistory = Array.init<[var Nat16]>(numBlocks, func(_ : Nat) : [var Nat16] {
      Array.init<Nat16>(blockSize, func(_ : Nat) : Nat16 { 0 })
    });
    
    let ltdHistory = Array.init<[var Nat16]>(numBlocks, func(_ : Nat) : [var Nat16] {
      Array.init<Nat16>(blockSize, func(_ : Nat) : Nat16 { 0 })
    });
    
    {
      blocks = blocks;
      eligibility = eligibility;
      ltpHistory = ltpHistory;
      ltdHistory = ltdHistory;
      lastUpdate = 0;
      totalLTP = 0;
      totalLTD = 0;
      sparsity = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // NEURAL GRAPH — Topology and connectivity
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type NeuralGraph = {
    adjacency : [[Nat8]];         // Sparse adjacency list
    distances : [[Float]];        // Pairwise distances
    clusters : [NeuralCluster];   // Identified clusters
    hubs : [Nat8];                // High-connectivity nodes
    bridges : [(Nat8, Nat8)];     // Inter-cluster bridges
    smallWorldCoeff : Float;      // Small-world coefficient
    clusteringCoeff : Float;      // Average clustering
    pathLength : Float;           // Average path length
  };
  
  public type NeuralCluster = {
    id : Nat8;
    members : [Nat8];
    centroid : NeuronPosition;
    internalCoherence : Float;
    externalConnections : Nat;
    dominantFrequency : Float;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE INDEX — Measuring synchronization
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type CoherenceIndex = {
    globalCoherence : Float;      // R (Kuramoto order parameter)
    phaseCoherence : Float;       // Phase synchronization
    amplitudeCoherence : Float;   // Amplitude correlation
    frequencyCoherence : Float;   // Frequency locking
    spatialCoherence : Float;     // Spatial pattern coherence
    temporalCoherence : Float;    // Temporal consistency
    bandCoherences : [Float];     // Per frequency band (delta, theta, alpha, beta, gamma)
    clusterCoherences : [Float];  // Per cluster
    history : [Float];            // Recent coherence history
    trend : Float;                // Coherence trend (derivative)
  };
  
  public func computeCoherenceIndex(
    neurons : [Shell3Neuron],
    currentBeat : Int
  ) : CoherenceIndex {
    let n = neurons.size();
    let nFloat = Float.fromInt(n);
    
    // Kuramoto order parameter: R = |1/N × Σ exp(i·φ)|
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (neuron in neurons.vals()) {
      sumCos += cos(neuron.phase);
      sumSin += sin(neuron.phase);
    };
    
    let globalR = sqrt(sumCos * sumCos + sumSin * sumSin) / nFloat;
    
    // Phase coherence (pairwise)
    var phaseCoherenceSum : Float = 0.0;
    var pairCount : Nat = 0;
    
    for (i in Iter.range(0, n - 2)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let phaseDiff = Float.abs(neurons[i].phase - neurons[j].phase);
        let coherence = cos(phaseDiff);
        phaseCoherenceSum += (coherence + 1.0) / 2.0;  // Normalize to [0, 1]
        pairCount += 1;
      };
    };
    
    let phaseCoherence = if (pairCount > 0) { 
      phaseCoherenceSum / Float.fromInt(pairCount) 
    } else { 0.0 };
    
    // Amplitude coherence
    var ampSum : Float = 0.0;
    var ampSqSum : Float = 0.0;
    
    for (neuron in neurons.vals()) {
      ampSum += neuron.amplitude;
      ampSqSum += neuron.amplitude * neuron.amplitude;
    };
    
    let meanAmp = ampSum / nFloat;
    let varAmp = ampSqSum / nFloat - meanAmp * meanAmp;
    let amplitudeCoherence = 1.0 - sqrt(varAmp) / (meanAmp + 0.001);
    
    // Frequency coherence (how clustered are frequencies)
    var freqSum : Float = 0.0;
    var freqSqSum : Float = 0.0;
    
    for (neuron in neurons.vals()) {
      freqSum += neuron.frequency;
      freqSqSum += neuron.frequency * neuron.frequency;
    };
    
    let meanFreq = freqSum / nFloat;
    let varFreq = freqSqSum / nFloat - meanFreq * meanFreq;
    let frequencyCoherence = 1.0 - sqrt(varFreq) / (meanFreq + 0.001);
    
    // Band coherences (simplified)
    let bandCoherences = [
      globalR * 0.8,  // Delta
      globalR * 0.85, // Theta
      globalR * 0.9,  // Alpha
      globalR * 0.95, // Beta
      globalR * 1.0,  // Gamma
    ];
    
    {
      globalCoherence = globalR;
      phaseCoherence = phaseCoherence;
      amplitudeCoherence = clamp(amplitudeCoherence, 0.0, 1.0);
      frequencyCoherence = clamp(frequencyCoherence, 0.0, 1.0);
      spatialCoherence = globalR * 0.9;  // Simplified
      temporalCoherence = globalR * 0.95; // Simplified
      bandCoherences = bandCoherences;
      clusterCoherences = [];
      history = [];
      trend = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEARTBEAT COUNTER — Synchronized to ICP
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HeartbeatCounter = {
    currentBeat : Int;            // Current beat number
    genesisTime : Int;            // Timestamp of first beat
    lastBeatTime : Int;           // Timestamp of last beat
    beatInterval : Int;           // Nanoseconds between beats
    targetHz : Float;             // Target heartbeat frequency
    actualHz : Float;             // Measured heartbeat frequency
    missedBeats : Nat;            // Beats that were skipped
    totalBeats : Nat;             // Total beats since genesis
    icpBlockHeight : Nat;         // Corresponding ICP block
    syncStatus : SyncStatus;
  };
  
  public type SyncStatus = {
    #Synchronized;
    #Drifting : Float;            // Drift amount
    #Resynchronizing;
    #Offline;
  };
  
  public func initHeartbeatCounter(targetHz : Float) : HeartbeatCounter {
    let now = Time.now();
    {
      currentBeat = 0;
      genesisTime = now;
      lastBeatTime = now;
      beatInterval = Int.abs(Float.toInt(1_000_000_000.0 / targetHz));
      targetHz = targetHz;
      actualHz = targetHz;
      missedBeats = 0;
      totalBeats = 0;
      icpBlockHeight = 0;
      syncStatus = #Synchronized;
    }
  };
  
  public func tickHeartbeat(
    counter : HeartbeatCounter,
    currentTime : Int,
    icpBlock : Nat
  ) : HeartbeatCounter {
    let timeSinceLastBeat = currentTime - counter.lastBeatTime;
    let expectedBeats = Int.abs(timeSinceLastBeat / counter.beatInterval);
    
    let missedThisCycle = if (expectedBeats > 1) { expectedBeats - 1 } else { 0 };
    
    let actualHz = if (timeSinceLastBeat > 0) {
      1_000_000_000.0 / Float.fromInt(timeSinceLastBeat)
    } else {
      counter.targetHz
    };
    
    let drift = Float.abs(actualHz - counter.targetHz) / counter.targetHz;
    let syncStatus = if (drift < 0.01) {
      #Synchronized
    } else if (drift < 0.1) {
      #Drifting(drift)
    } else {
      #Resynchronizing
    };
    
    {
      currentBeat = counter.currentBeat + 1;
      genesisTime = counter.genesisTime;
      lastBeatTime = currentTime;
      beatInterval = counter.beatInterval;
      targetHz = counter.targetHz;
      actualHz = actualHz;
      missedBeats = counter.missedBeats + Int.abs(missedThisCycle);
      totalBeats = counter.totalBeats + 1;
      icpBlockHeight = icpBlock;
      syncStatus = syncStatus;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QSOV SOVEREIGNTY SCORE — Quantum Sovereignty Measure
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QSOVScore = {
    overall : Float;              // Total sovereignty [0, 1.5]
    components : QSOVComponents;
    history : [Float];            // Recent scores
    trend : Float;                // Score trend
    violations : [QSOVViolation]; // Recent violations
    lastUpdate : Int;
  };
  
  public type QSOVComponents = {
    coherenceContribution : Float;    // From neural coherence
    stabilityContribution : Float;    // From temporal stability
    autonomyContribution : Float;     // From decision independence
    integrityContribution : Float;    // From identity continuity
    resilienceContribution : Float;   // From error recovery
    efficiencyContribution : Float;   // From resource usage
    growthContribution : Float;       // From learning/adaptation
  };
  
  public type QSOVViolation = {
    beat : Int;
    component : Text;
    severity : Float;
    description : Text;
    resolved : Bool;
  };
  
  public func computeQSOV(
    coherence : CoherenceIndex,
    heartbeat : HeartbeatCounter,
    identityContinuity : Float,
    resourceEfficiency : Float,
    learningRate : Float,
    currentBeat : Int
  ) : QSOVScore {
    // Coherence contribution (35%)
    let coherenceC = coherence.globalCoherence * 0.35;
    
    // Stability contribution (20%)
    let stability = switch (heartbeat.syncStatus) {
      case (#Synchronized) { 1.0 };
      case (#Drifting(d)) { 1.0 - d };
      case (#Resynchronizing) { 0.5 };
      case (#Offline) { 0.0 };
    };
    let stabilityC = stability * 0.20;
    
    // Autonomy contribution (15%)
    let autonomyC = 0.85 * 0.15;  // Base autonomy
    
    // Integrity contribution (15%)
    let integrityC = identityContinuity * 0.15;
    
    // Resilience contribution (5%)
    let resilienceC = 0.9 * 0.05;  // Base resilience
    
    // Efficiency contribution (5%)
    let efficiencyC = resourceEfficiency * 0.05;
    
    // Growth contribution (5%)
    let growthC = clamp(learningRate * 10.0, 0.0, 1.0) * 0.05;
    
    let overall = coherenceC + stabilityC + autonomyC + integrityC + 
                  resilienceC + efficiencyC + growthC;
    
    // Apply floor
    let finalScore = if (overall < QSOV_FLOOR) { QSOV_FLOOR } else { overall };
    
    {
      overall = finalScore;
      components = {
        coherenceContribution = coherenceC;
        stabilityContribution = stabilityC;
        autonomyContribution = autonomyC;
        integrityContribution = integrityC;
        resilienceContribution = resilienceC;
        efficiencyContribution = efficiencyC;
        growthContribution = growthC;
      };
      history = [];
      trend = 0.0;
      violations = [];
      lastUpdate = currentBeat;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE SHELL 3 STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Shell3State = {
    neurons : [var Shell3Neuron];
    weights : Shell3WeightMatrix;
    graph : NeuralGraph;
    coherence : CoherenceIndex;
    heartbeat : HeartbeatCounter;
    qsov : QSOVScore;
    activationPattern : [Float];  // Current activation snapshot
    firingRate : Float;           // Current firing rate
    energyConsumption : Float;    // Metabolic cost
    temperature : Float;          // Computational "temperature"
  };
  
  public func initShell3State() : Shell3State {
    // Initialize 256 neurons
    let neurons = Array.init<Shell3Neuron>(SHELL3_NODE_COUNT, func(i : Nat) : Shell3Neuron {
      let region : NeuralRegion = if (i < 64) {
        #Sensory
      } else if (i < 128) {
        #Association
      } else if (i < 192) {
        #Executive
      } else {
        #Motor
      };
      
      let x = Float.fromInt(i % 16) / 8.0 - 1.0;
      let y = Float.fromInt((i / 16) % 16) / 8.0 - 1.0;
      let z = Float.fromInt(i / 64) / 4.0;
      
      let freq = SHELL3_FREQ_MIN + (SHELL3_FREQ_MAX - SHELL3_FREQ_MIN) * Float.fromInt(i) / 256.0;
      
      {
        id = Nat8.fromNat(i);
        position = { x = x; y = y; z = z; region = region };
        frequency = freq;
        phase = Float.fromInt(i) * TWO_PI / 256.0;
        amplitude = 1.0;
        membrane = 0.0;
        activation = 0.0;
        threshold = SHELL3_THRESHOLD;
        refractoryRemaining = 0;
        spikeCount = 0;
        lastSpike = 0;
        localCoherence = 0.75;
        receptiveField = [];
        projectiveField = [];
      }
    });
    
    {
      neurons = neurons;
      weights = initShell3WeightMatrix();
      graph = {
        adjacency = [];
        distances = [];
        clusters = [];
        hubs = [];
        bridges = [];
        smallWorldCoeff = 0.0;
        clusteringCoeff = 0.0;
        pathLength = 0.0;
      };
      coherence = {
        globalCoherence = 0.75;
        phaseCoherence = 0.75;
        amplitudeCoherence = 0.75;
        frequencyCoherence = 0.75;
        spatialCoherence = 0.75;
        temporalCoherence = 0.75;
        bandCoherences = [0.75, 0.75, 0.75, 0.75, 0.75];
        clusterCoherences = [];
        history = [];
        trend = 0.0;
      };
      heartbeat = initHeartbeatCounter(12.0);
      qsov = {
        overall = 0.75;
        components = {
          coherenceContribution = 0.26;
          stabilityContribution = 0.20;
          autonomyContribution = 0.13;
          integrityContribution = 0.11;
          resilienceContribution = 0.045;
          efficiencyContribution = 0.04;
          growthContribution = 0.025;
        };
        history = [];
        trend = 0.0;
        violations = [];
        lastUpdate = 0;
      };
      activationPattern = [];
      firingRate = 0.0;
      energyConsumption = 0.0;
      temperature = 1.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL 3 TICK — One beat of neural processing
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Shell3TickResult = {
    spikes : Nat;
    coherence : Float;
    qsov : Float;
    energyUsed : Float;
    ltpEvents : Nat;
    ltdEvents : Nat;
  };
  
  public func shell3Tick(
    state : Shell3State,
    inputs : [Float],             // 256 external inputs
    currentTime : Int,
    icpBlock : Nat
  ) : Shell3TickResult {
    // 1. Update heartbeat
    let newHeartbeat = tickHeartbeat(state.heartbeat, currentTime, icpBlock);
    let currentBeat = newHeartbeat.currentBeat;
    
    // 2. Propagate activations through 65,536 weights
    var spikes : Nat = 0;
    let dt = 1.0 / 12.0;  // 12 Hz
    
    for (j in Iter.range(0, SHELL3_NODE_COUNT - 1)) {
      var inputSum : Float = 0.0;
      
      // External input
      if (j < inputs.size()) {
        inputSum += inputs[j];
      };
      
      // Weighted inputs from other neurons
      let targetBlock = j / 16;
      for (sourceBlock in Iter.range(0, 15)) {
        let block = state.weights.blocks[sourceBlock * 4 + targetBlock / 4];
        let localTarget = j % 256;
        
        for (localSource in Iter.range(0, 15)) {
          let globalSource = sourceBlock * 16 + localSource;
          if (globalSource < SHELL3_NODE_COUNT) {
            let weightIdx = localSource * 16 + (localTarget % 16);
            if (weightIdx < block.size()) {
              let weight = block[weightIdx];
              inputSum += weight * state.neurons[globalSource].activation;
            };
          };
        };
      };
      
      // Update membrane and check for spike
      let neuron = state.neurons[j];
      
      if (neuron.refractoryRemaining > 0) {
        state.neurons[j] := {
          id = neuron.id;
          position = neuron.position;
          frequency = neuron.frequency;
          phase = neuron.phase + TWO_PI * neuron.frequency * dt;
          amplitude = neuron.amplitude;
          membrane = 0.0;
          activation = 0.0;
          threshold = neuron.threshold;
          refractoryRemaining = neuron.refractoryRemaining - 1;
          spikeCount = neuron.spikeCount;
          lastSpike = neuron.lastSpike;
          localCoherence = neuron.localCoherence;
          receptiveField = neuron.receptiveField;
          projectiveField = neuron.projectiveField;
        };
      } else {
        let newMembrane = neuron.membrane * 0.9 + inputSum * 0.1;
        let activation = sigmoid(newMembrane - neuron.threshold);
        let spiked = activation > 0.8;
        
        if (spiked) { spikes += 1 };
        
        state.neurons[j] := {
          id = neuron.id;
          position = neuron.position;
          frequency = neuron.frequency;
          phase = wrapPhase(neuron.phase + TWO_PI * neuron.frequency * dt);
          amplitude = neuron.amplitude;
          membrane = newMembrane;
          activation = activation;
          threshold = neuron.threshold;
          refractoryRemaining = if (spiked) { SHELL3_REFRACTORY } else { 0 };
          spikeCount = if (spiked) { neuron.spikeCount + 1 } else { neuron.spikeCount };
          lastSpike = if (spiked) { currentBeat } else { neuron.lastSpike };
          localCoherence = neuron.localCoherence;
          receptiveField = neuron.receptiveField;
          projectiveField = neuron.projectiveField;
        };
      };
    };
    
    // 3. Hebbian learning
    var ltpEvents : Nat = 0;
    var ltdEvents : Nat = 0;
    
    for (blockIdx in Iter.range(0, 15)) {
      let block = state.weights.blocks[blockIdx];
      
      for (weightIdx in Iter.range(0, block.size() - 1)) {
        let sourceNeuron = (blockIdx / 4) * 64 + (weightIdx / 256);
        let targetNeuron = (blockIdx % 4) * 64 + (weightIdx % 256);
        
        if (sourceNeuron < SHELL3_NODE_COUNT and targetNeuron < SHELL3_NODE_COUNT) {
          let pre = state.neurons[sourceNeuron].activation;
          let post = state.neurons[targetNeuron].activation;
          let oldWeight = block[weightIdx];
          
          let dw = SHELL3_ETA * pre * post - SHELL3_DECAY * oldWeight;
          var newWeight = oldWeight + dw;
          
          if (newWeight < 0.0) { newWeight := 0.0 };
          if (newWeight > 1.0) { newWeight := 1.0 };
          
          block[weightIdx] := newWeight;
          
          if (newWeight > oldWeight + 0.0001) { ltpEvents += 1 };
          if (newWeight < oldWeight - 0.0001) { ltdEvents += 1 };
        };
      };
    };
    
    // 4. Compute coherence
    let coherence = computeCoherenceIndex(Array.freeze(state.neurons), currentBeat);
    
    // 5. Compute QSOV
    let qsov = computeQSOV(coherence, newHeartbeat, 0.9, 0.85, 0.001, currentBeat);
    
    // 6. Energy consumption
    let energyUsed = Float.fromInt(spikes) * 0.001 + Float.fromInt(ltpEvents + ltdEvents) * 0.0001;
    
    {
      spikes = spikes;
      coherence = coherence.globalCoherence;
      qsov = qsov.overall;
      energyUsed = energyUsed;
      ltpEvents = ltpEvents;
      ltdEvents = ltdEvents;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func sin(x : Float) : Float {
    var result = x;
    var term = x;
    for (n in Iter.range(1, 12)) {
      term := -term * x * x / Float.fromInt((2 * n) * (2 * n + 1));
      result += term;
    };
    result
  };
  
  func cos(x : Float) : Float {
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 12)) {
      term := -term * x * x / Float.fromInt((2 * n - 1) * (2 * n));
      result += term;
    };
    result
  };
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    var result : Float = 1.0;
    var term : Float = 1.0;
    for (n in Iter.range(1, 20)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    var guess = x / 2.0;
    for (_ in Iter.range(0, 12)) {
      guess := (guess + x / guess) / 2.0;
    };
    guess
  };
  
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };
  
  func wrapPhase(phase : Float) : Float {
    var p = phase;
    while (p >= TWO_PI) { p -= TWO_PI };
    while (p < 0.0) { p += TWO_PI };
    p
  };

}
