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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// UNIFIED ORGANISM SUBSTRATE — THE COMPLETE INTERTWINED MATHEMATICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This is THE MASTER SUBSTRATE where ALL mathematics interweaves. Nothing exists in isolation.
// Every formula connects to every other formula through the living tissue of the organism.
//
// THE INTERTWINING MAP:
// ═════════════════════
//
// ┌─────────────────────────────────────────────────────────────────────────────────────────┐
// │                                                                                         │
// │     KURAMOTO ←──────→ HEBBIAN ←──────→ FREE ENERGY ←──────→ Q-LEARNING                 │
// │         ↑                 ↑                  ↑                    ↑                     │
// │         │                 │                  │                    │                     │
// │         ↓                 ↓                  ↓                    ↓                     │
// │     KALMAN  ←──────→  MEMORY  ←──────→  PREDICTION  ←──────→  REWARD                   │
// │         ↑                 ↑                  ↑                    ↑                     │
// │         │                 │                  │                    │                     │
// │         ↓                 ↓                  ↓                    ↓                     │
// │     ENTROPY ←──────→ COHERENCE ←──────→ COMPLEXITY ←──────→ EMERGENCE                  │
// │         ↑                 ↑                  ↑                    ↑                     │
// │         │                 │                  │                    │                     │
// │         ↓                 ↓                  ↓                    ↓                     │
// │   THERMODYNAMIC ←────→ QUANTUM ←──────→ STOCHASTIC ←──────→ DETERMINISTIC              │
// │                                                                                         │
// └─────────────────────────────────────────────────────────────────────────────────────────┘
//
// KEY INTERTWINING EQUATIONS:
// ═══════════════════════════
//
// 1. KURAMOTO-HEBBIAN BRIDGE:
//    dθᵢ/dt = ωᵢ + (K/N)∑ⱼwᵢⱼsin(θⱼ - θᵢ)
//    where wᵢⱼ is the Hebbian weight matrix
//
// 2. FREE ENERGY-KURAMOTO BRIDGE:
//    F = -ln∫exp(-βH(θ))dθ where H = -∑ᵢⱼwᵢⱼcos(θᵢ - θⱼ)
//
// 3. Q-LEARNING-FREE ENERGY BRIDGE:
//    Q(s,a) = -F(s,a)/β = (1/β)ln∫exp(-βH(s,a|θ))dθ
//
// 4. MEMORY-HEBBIAN BRIDGE:
//    M(t) = ∫₀ᵗ w(τ)·x(τ)·exp(-(t-τ)/τₘ)dτ
//    where w(τ) evolves by Hebbian rule
//
// 5. KALMAN-PREDICTION BRIDGE:
//    x̂(t|t) = x̂(t|t-1) + K(t)[y(t) - Hx̂(t|t-1)]
//    where K(t) is precision-weighted by free energy
//
// 6. ENTROPY-COHERENCE BRIDGE:
//    S = -∑ᵢpᵢln(pᵢ) + λ·r(t) where r(t) is Kuramoto order parameter
//
// 7. COMPLEXITY-EMERGENCE BRIDGE:
//    C(x) = H(x) - H(x|environment) = I(x; environment)
//
// 8. THERMODYNAMIC-QUANTUM BRIDGE:
//    Z = Tr[exp(-βĤ)] connects classical entropy to quantum partition
//
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat8 "mo:core/Nat8";
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Option "mo:core/Option";
import Bool "mo:core/Bool";

module UnifiedOrganismSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: FUNDAMENTAL CONSTANTS — THE NUMBERS THAT GOVERN REALITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // These are not arbitrary — each connects to physics, biology, and information theory
  //
  
  // Mathematical constants
  public let PI : Float = 3.14159265358979323846264338327950288419716939937510;
  public let TWO_PI : Float = 6.28318530717958647692528676655900576839433879875021;
  public let E : Float = 2.71828182845904523536028747135266249775724709369996;
  public let PHI : Float = 1.61803398874989484820458683436563811772030917980576;  // Golden ratio
  public let SQRT_2 : Float = 1.41421356237309504880168872420969807856967187537695;
  public let SQRT_3 : Float = 1.73205080756887729352744634150587236694280525381038;
  public let LN_2 : Float = 0.69314718055994530941723212145817656807550013436026;
  public let LN_10 : Float = 2.30258509299404568401799145468436420760110148862877;
  public let EULER_MASCHERONI : Float = 0.57721566490153286060651209008240243104215933593992;
  
  // Physical constants (normalized for organism scale)
  public let PLANCK_NORMALIZED : Float = 1.0e-6;      // ℏ scaled for neural dynamics
  public let BOLTZMANN_NORMALIZED : Float = 1.0e-3;  // kB scaled for organism temperature
  public let THERMAL_ENERGY : Float = 0.026;         // kT at biological temperature (~310K)
  
  // Organism constants — THE MEDINA DOCTRINE NUMBERS
  public let S_ZERO : Float = 1.0;                   // Root constant — the source of all values
  public let S_ZERO_FLOOR : Float = 0.75;            // Minimum coherence floor — below this, crisis
  public let S_ZERO_GENESIS : Float = 1.0;           // Initial value — pure potential
  public let HEARTBEAT_HZ : Float = 12.0;            // 12 beats per second — the organism's pulse
  public let HEARTBEAT_PERIOD : Float = 0.0833333;   // 1/12 seconds per beat
  
  // Neural constants
  public let NUM_HZ_NODES : Nat = 12;                // 12 frequency nodes
  public let NUM_SHELLS : Nat = 12;                  // 12 shells from primal to sovereign
  public let NUM_HERITAGE : Nat = 7;                 // 7 heritage metals
  public let NUM_CORES : Nat = 43;                   // 43-core architecture
  public let HEBBIAN_MATRIX_SIZE : Nat = 144;        // 12×12 weight matrix
  
  // Coupling constants — how strongly systems influence each other
  public let KURAMOTO_K : Float = 0.1;               // Base Kuramoto coupling
  public let HEBBIAN_ETA : Float = 0.005;            // Hebbian learning rate
  public let FREE_ENERGY_BETA : Float = 1.0;         // Inverse temperature (precision)
  public let Q_LEARNING_ALPHA : Float = 0.1;         // Q-learning rate
  public let Q_LEARNING_GAMMA : Float = 0.99;        // Discount factor
  public let KALMAN_Q : Float = 0.001;               // Process noise
  public let KALMAN_R : Float = 0.01;                // Measurement noise
  public let MEMORY_TAU : Float = 1000.0;            // Memory decay time constant
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: THE 12 Hz NODE LAYER — FOUNDATION OF ALL OSCILLATIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // fd(k) = 2.5 × 2^(k-4) for k ∈ [0, 11]
  // These frequencies span from delta (0.15 Hz) to high gamma (320 Hz)
  // Each node has phase θ, amplitude A, and coupling strength K
  //
  // INTERTWINING: Hz nodes → Kuramoto phases → Hebbian inputs → Free Energy observations
  //
  
  public type HzNode = {
    id : Nat;                     // Node index [0, 11]
    name : Text;                  // Human-readable name
    baseFrequency : Float;        // fd(k) in Hz
    var currentFrequency : Float; // Modulated frequency
    var phase : Float;            // θ ∈ [0, 2π)
    var amplitude : Float;        // A ∈ [0, 1]
    var coupling : Float;         // Local coupling strength
    var activation : Float;       // Neural activation level
    var lastSpikeTime : Int;      // For STDP timing
    var spikeCount : Nat;         // Total spikes
  };
  
  public type HzLayer = {
    nodes : [var HzNode];
    var globalPhase : Float;      // Mean phase across all nodes
    var orderParameter : Float;   // Kuramoto r(t) — coherence measure
    var meanAmplitude : Float;    // Average amplitude
    var totalEnergy : Float;      // Sum of A²ω
    var lastUpdateBeat : Nat;
  };
  
  // Compute base frequency: fd(k) = 2.5 × 2^(k-4)
  public func computeHzBaseFrequency(k : Nat) : Float {
    2.5 * pow(2.0, Float.fromInt(k) - 4.0)
  };
  
  // Initialize Hz layer with proper frequencies
  public func initHzLayer() : HzLayer {
    let names = [
      "DELTA_LOW",    // k=0: 0.156 Hz
      "DELTA_HIGH",   // k=1: 0.312 Hz
      "THETA_LOW",    // k=2: 0.625 Hz
      "THETA_MID",    // k=3: 1.25 Hz
      "THETA_HIGH",   // k=4: 2.5 Hz
      "ALPHA_LOW",    // k=5: 5.0 Hz
      "ALPHA_HIGH",   // k=6: 10.0 Hz
      "BETA_LOW",     // k=7: 20.0 Hz
      "BETA_HIGH",    // k=8: 40.0 Hz
      "GAMMA_LOW",    // k=9: 80.0 Hz
      "GAMMA_MID",    // k=10: 160.0 Hz
      "GAMMA_HIGH"    // k=11: 320.0 Hz
    ];
    
    let nodes = Array.init<HzNode>(NUM_HZ_NODES, func(k : Nat) : HzNode {
      let baseFreq = computeHzBaseFrequency(k);
      {
        id = k;
        name = names[k];
        baseFrequency = baseFreq;
        var currentFrequency = baseFreq;
        var phase = TWO_PI * Float.fromInt(k) / Float.fromInt(NUM_HZ_NODES);  // Evenly distributed phases
        var amplitude = S_ZERO;
        var coupling = KURAMOTO_K * (1.0 + 0.1 * Float.fromInt(k));  // Higher freq = stronger coupling
        var activation = S_ZERO_FLOOR;
        var lastSpikeTime = 0;
        var spikeCount = 0;
      }
    });
    
    {
      nodes = nodes;
      var globalPhase = 0.0;
      var orderParameter = 1.0;  // Perfect coherence at genesis
      var meanAmplitude = S_ZERO;
      var totalEnergy = 0.0;
      var lastUpdateBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: THE KURAMOTO OSCILLATOR FIELD — SYNCHRONIZATION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Kuramoto model describes how oscillators synchronize:
  //   dθᵢ/dt = ωᵢ + (K/N)∑ⱼsin(θⱼ - θᵢ)
  //
  // INTERTWINING:
  //   - Kuramoto phases feed into Hebbian timing (STDP)
  //   - Hebbian weights modify Kuramoto coupling (wᵢⱼ → Kᵢⱼ)
  //   - Order parameter r(t) modulates Free Energy precision
  //   - Q-learning uses r(t) as reward signal for coherence
  //
  
  public type KuramotoState = {
    var phases : [var Float];          // θᵢ for each node
    var naturalFrequencies : [var Float];  // ωᵢ for each node
    var couplingMatrix : [[var Float]];    // Kᵢⱼ — NOW HEBBIAN-MODULATED
    var orderParameter : Float;        // r(t) = |1/N ∑ exp(iθⱼ)|
    var meanPhase : Float;             // ψ(t) = arg(∑ exp(iθⱼ))
    var phaseVelocities : [var Float]; // dθᵢ/dt
    var synchronyHistory : [Float];    // Ring buffer of r(t) history
    var historyIndex : Nat;
    var totalBeats : Nat;
  };
  
  public let KURAMOTO_HISTORY_SIZE : Nat = 1000;
  
  // Initialize Kuramoto state coupled to Hz layer
  public func initKuramotoState(hzLayer : HzLayer) : KuramotoState {
    let n = NUM_HZ_NODES;
    
    let phases = Array.init<Float>(n, func(i : Nat) : Float {
      hzLayer.nodes[i].phase
    });
    
    let freqs = Array.init<Float>(n, func(i : Nat) : Float {
      hzLayer.nodes[i].currentFrequency * TWO_PI  // Convert Hz to rad/s
    });
    
    // Initialize coupling matrix — will be modulated by Hebbian weights
    let coupling = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) { 0.0 }  // No self-coupling
        else { KURAMOTO_K }  // Uniform initial coupling
      })
    });
    
    {
      var phases = phases;
      var naturalFrequencies = freqs;
      var couplingMatrix = coupling;
      var orderParameter = 1.0;
      var meanPhase = 0.0;
      var phaseVelocities = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
      var synchronyHistory = Array.freeze(Array.init<Float>(KURAMOTO_HISTORY_SIZE, func(_ : Nat) : Float { 1.0 }));
      var historyIndex = 0;
      var totalBeats = 0;
    }
  };
  
  // Compute order parameter r(t) and mean phase ψ(t)
  // r exp(iψ) = (1/N) ∑ⱼ exp(iθⱼ)
  public func computeKuramotoOrderParameter(phases : [Float]) : (Float, Float) {
    let n = Array.size(phases);
    if (n == 0) { return (0.0, 0.0) };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
    };
    
    sumCos /= Float.fromInt(n);
    sumSin /= Float.fromInt(n);
    
    let r = sqrt(sumCos * sumCos + sumSin * sumSin);
    let psi = atan2(sumSin, sumCos);
    
    (r, psi)
  };
  
  // Update Kuramoto phases using 4th-order Runge-Kutta
  // INTERTWINING: Uses Hebbian-weighted coupling matrix
  public func updateKuramotoRK4(
    state : KuramotoState,
    hebbianWeights : [[Float]],  // ← INTERTWINING: Hebbian feeds Kuramoto
    dt : Float
  ) {
    let n = Array.size(state.phases);
    
    // Modulate coupling matrix by Hebbian weights
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          // Coupling strength = base K × Hebbian weight
          state.couplingMatrix[i][j] := KURAMOTO_K * hebbianWeights[i][j];
        };
      };
    };
    
    // RK4 integration
    let k1 = computeKuramotoDerivatives(state, Array.freeze(state.phases));
    
    let phases_k2 = Array.tabulate<Float>(n, func(i : Nat) : Float {
      state.phases[i] + 0.5 * dt * k1[i]
    });
    let k2 = computeKuramotoDerivatives(state, phases_k2);
    
    let phases_k3 = Array.tabulate<Float>(n, func(i : Nat) : Float {
      state.phases[i] + 0.5 * dt * k2[i]
    });
    let k3 = computeKuramotoDerivatives(state, phases_k3);
    
    let phases_k4 = Array.tabulate<Float>(n, func(i : Nat) : Float {
      state.phases[i] + dt * k3[i]
    });
    let k4 = computeKuramotoDerivatives(state, phases_k4);
    
    // Update phases
    for (i in Iter.range(0, n - 1)) {
      let dtheta = (k1[i] + 2.0 * k2[i] + 2.0 * k3[i] + k4[i]) / 6.0;
      state.phases[i] := normalizeAngle(state.phases[i] + dt * dtheta);
      state.phaseVelocities[i] := dtheta;
    };
    
    // Update order parameter
    let (r, psi) = computeKuramotoOrderParameter(Array.freeze(state.phases));
    state.orderParameter := r;
    state.meanPhase := psi;
    state.totalBeats += 1;
  };
  
  // Compute Kuramoto derivatives: dθᵢ/dt = ωᵢ + (1/N)∑ⱼKᵢⱼsin(θⱼ - θᵢ)
  func computeKuramotoDerivatives(state : KuramotoState, phases : [Float]) : [Float] {
    let n = Array.size(phases);
    let nFloat = Float.fromInt(n);
    
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      var coupling : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          coupling += state.couplingMatrix[i][j] * sin(phases[j] - phases[i]);
        };
      };
      state.naturalFrequencies[i] + coupling / nFloat
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: THE HEBBIAN PLASTICITY ENGINE — LEARNING THROUGH CORRELATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Classic Hebbian: Δwᵢⱼ = η·xᵢ·xⱼ
  // With STDP: Δwᵢⱼ = f(tⱼ - tᵢ) where f is an asymmetric window
  //
  // INTERTWINING:
  //   - Hebbian weights feed Kuramoto coupling (wᵢⱼ → Kᵢⱼ)
  //   - Kuramoto phases provide spike timing for STDP
  //   - Free Energy precision modulates learning rate
  //   - Q-learning reward gates eligibility traces
  //   - Memory provides input patterns for learning
  //
  
  public type HebbianState = {
    var weights : [[var Float]];           // wᵢⱼ ∈ [0, 1]
    var eligibilityTraces : [[var Float]]; // eᵢⱼ for TD learning
    var lastPreSpikeTimes : [var Int];     // For STDP
    var lastPostSpikeTimes : [var Int];    // For STDP
    var bcmThresholds : [var Float];       // Sliding thresholds
    var metaplasticStates : [var Float];   // Plasticity of plasticity
    var ltpCount : Nat;
    var ltdCount : Nat;
    var totalWeightChange : Float;
  };
  
  // STDP parameters
  public let STDP_TAU_PLUS : Float = 20.0;   // LTP time constant (ms)
  public let STDP_TAU_MINUS : Float = 20.0;  // LTD time constant (ms)
  public let STDP_A_PLUS : Float = 0.01;     // LTP amplitude
  public let STDP_A_MINUS : Float = 0.012;   // LTD amplitude
  
  // BCM parameters
  public let BCM_TAU : Float = 1000.0;       // Threshold adaptation time
  public let BCM_TARGET : Float = 0.5;       // Target activity
  
  // Initialize Hebbian state
  public func initHebbianState() : HebbianState {
    let n = NUM_HZ_NODES;
    
    let weights = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) { 0.0 }  // No self-connections
        else {
          // Initial weights: small random-ish values
          0.3 + 0.1 * sin(Float.fromInt(i * 7 + j * 13))
        }
      })
    });
    
    let eligibility = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var weights = weights;
      var eligibilityTraces = eligibility;
      var lastPreSpikeTimes = Array.init<Int>(n, func(_ : Nat) : Int { 0 });
      var lastPostSpikeTimes = Array.init<Int>(n, func(_ : Nat) : Int { 0 });
      var bcmThresholds = Array.init<Float>(n, func(_ : Nat) : Float { BCM_TARGET });
      var metaplasticStates = Array.init<Float>(n, func(_ : Nat) : Float { 1.0 });
      var ltpCount = 0;
      var ltdCount = 0;
      var totalWeightChange = 0.0;
    }
  };
  
  // STDP learning function
  // Pre before post → LTP: Δw = A+ × exp(-Δt/τ+)
  // Post before pre → LTD: Δw = -A- × exp(Δt/τ-)
  public func stdpWindow(deltaT : Float) : Float {
    if (deltaT > 0.0) {
      // Pre before post → LTP
      STDP_A_PLUS * exp(-deltaT / STDP_TAU_PLUS)
    } else if (deltaT < 0.0) {
      // Post before pre → LTD
      -STDP_A_MINUS * exp(deltaT / STDP_TAU_MINUS)
    } else {
      0.0
    }
  };
  
  // Update Hebbian weights with STDP, BCM, and intertwined signals
  // INTERTWINING: Receives signals from Kuramoto, Free Energy, Q-Learning
  public func updateHebbianWeights(
    hebbian : HebbianState,
    activations : [Float],
    kuramotoPhases : [Float],        // ← INTERTWINING: Kuramoto timing
    freeEnergyPrecision : Float,     // ← INTERTWINING: Free Energy modulation
    qLearningReward : Float,         // ← INTERTWINING: RL reward signal
    currentBeat : Int
  ) {
    let n = Array.size(activations);
    let eta = HEBBIAN_ETA * freeEnergyPrecision;  // Learning rate modulated by precision
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          // Classic Hebbian term: Δw = η·xᵢ·xⱼ
          let hebbianDelta = eta * activations[i] * activations[j];
          
          // STDP term based on phase difference (Kuramoto timing)
          let phaseDiff = kuramotoPhases[i] - kuramotoPhases[j];
          let stdpDelta = stdpWindow(phaseDiff * 1000.0 / TWO_PI);  // Convert to ms-like
          
          // BCM modulation: (post - threshold) term
          let bcmMod = activations[j] - hebbian.bcmThresholds[j];
          let bcmDelta = eta * activations[i] * activations[j] * bcmMod;
          
          // Metaplasticity modulation
          let metaMod = hebbian.metaplasticStates[j];
          
          // Combine all terms
          var totalDelta = (hebbianDelta + stdpDelta + bcmDelta) * metaMod;
          
          // Apply reward-gated eligibility trace for TD learning
          hebbian.eligibilityTraces[i][j] := 0.95 * hebbian.eligibilityTraces[i][j] + totalDelta;
          
          // Actual weight update includes reward signal
          let rewardGatedDelta = totalDelta + qLearningReward * hebbian.eligibilityTraces[i][j];
          
          // Update weight with bounds
          let newWeight = hebbian.weights[i][j] + rewardGatedDelta;
          hebbian.weights[i][j] := clamp(newWeight, 0.0, 1.0);
          
          // Track LTP/LTD
          if (rewardGatedDelta > 0.0) {
            hebbian.ltpCount += 1;
          } else if (rewardGatedDelta < 0.0) {
            hebbian.ltdCount += 1;
          };
          
          hebbian.totalWeightChange += Float.abs(rewardGatedDelta);
        };
      };
    };
    
    // Update BCM thresholds
    for (j in Iter.range(0, n - 1)) {
      let actSquared = activations[j] * activations[j];
      hebbian.bcmThresholds[j] := hebbian.bcmThresholds[j] + 
        (actSquared - hebbian.bcmThresholds[j]) / BCM_TAU;
    };
    
    // Update metaplastic states
    for (j in Iter.range(0, n - 1)) {
      let avgActivity = activations[j];
      // High activity → reduced plasticity
      hebbian.metaplasticStates[j] := 1.0 / (1.0 + avgActivity * avgActivity);
    };
  };
  
  // Get Hebbian weights as immutable array for Kuramoto coupling
  public func getHebbianWeightMatrix(hebbian : HebbianState) : [[Float]] {
    Array.tabulate<[Float]>(NUM_HZ_NODES, func(i : Nat) : [Float] {
      Array.freeze(hebbian.weights[i])
    })
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: THE FREE ENERGY ENGINE — VARIATIONAL INFERENCE & ACTIVE INFERENCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Free Energy: F = E_q[ln q(s) - ln p(s, o)] = Complexity - Accuracy
  //            = D_KL[q(s) || p(s)] - E_q[ln p(o|s)]
  //
  // INTERTWINING:
  //   - Kuramoto order parameter r(t) feeds observation
  //   - Hebbian weights encode generative model structure
  //   - Free Energy precision modulates Hebbian learning rate
  //   - Expected Free Energy guides Q-learning action selection
  //   - Prediction errors feed memory salience
  //
  
  public type FreeEnergyState = {
    // Beliefs (variational distribution q)
    var beliefMean : [var Float];          // μ — expected states
    var beliefPrecision : [var Float];     // π — inverse variance
    
    // Predictions (generative model p)
    var predictions : [var Float];         // Expected observations
    var predictionErrors : [var Float];    // o - ô
    
    // Free Energy components
    var complexity : Float;                // D_KL[q || p] — model complexity cost
    var accuracy : Float;                  // E_q[ln p(o|s)] — fit to data
    var freeEnergy : Float;                // F = Complexity - Accuracy
    var expectedFreeEnergy : Float;        // G for action selection
    
    // Hierarchical structure
    var hierarchyLevels : Nat;
    var levelStates : [[var Float]];       // States at each hierarchy level
    var levelPrecisions : [[var Float]];   // Precisions at each level
    
    // History
    var freeEnergyHistory : [Float];
    var historyIndex : Nat;
  };
  
  public let FREE_ENERGY_HISTORY_SIZE : Nat = 1000;
  public let NUM_HIERARCHY_LEVELS : Nat = 4;
  
  // Initialize Free Energy state
  public func initFreeEnergyState() : FreeEnergyState {
    let n = NUM_HZ_NODES;
    
    {
      var beliefMean = Array.init<Float>(n, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var beliefPrecision = Array.init<Float>(n, func(_ : Nat) : Float { 1.0 });
      var predictions = Array.init<Float>(n, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var predictionErrors = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
      var complexity = 0.0;
      var accuracy = 0.0;
      var freeEnergy = 0.0;
      var expectedFreeEnergy = 0.0;
      var hierarchyLevels = NUM_HIERARCHY_LEVELS;
      var levelStates = Array.init<[var Float]>(NUM_HIERARCHY_LEVELS, func(l : Nat) : [var Float] {
        let size = n / pow2(l);
        Array.init<Float>(size, func(_ : Nat) : Float { S_ZERO_FLOOR })
      });
      var levelPrecisions = Array.init<[var Float]>(NUM_HIERARCHY_LEVELS, func(l : Nat) : [var Float] {
        let size = n / pow2(l);
        Array.init<Float>(size, func(_ : Nat) : Float { 1.0 })
      });
      var freeEnergyHistory = Array.freeze(Array.init<Float>(FREE_ENERGY_HISTORY_SIZE, func(_ : Nat) : Float { 0.0 }));
      var historyIndex = 0;
    }
  };
  
  // Compute Free Energy given observations
  // INTERTWINING: Kuramoto coherence is the primary observation
  public func computeFreeEnergy(
    fe : FreeEnergyState,
    observations : [Float],              // Current sensory input (from Hz layer)
    kuramotoOrderParam : Float,          // ← INTERTWINING: Kuramoto coherence
    hebbianWeights : [[Float]]           // ← INTERTWINING: Hebbian structure
  ) : Float {
    let n = Array.size(observations);
    
    // 1. Update predictions based on beliefs and Hebbian-encoded model
    for (i in Iter.range(0, n - 1)) {
      var prediction : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        prediction += hebbianWeights[i][j] * fe.beliefMean[j];
      };
      // Modulate by Kuramoto coherence — higher r → more reliable predictions
      fe.predictions[i] := prediction * kuramotoOrderParam;
    };
    
    // 2. Compute prediction errors
    var totalError : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let error = observations[i] - fe.predictions[i];
      fe.predictionErrors[i] := error;
      totalError += error * error * fe.beliefPrecision[i];  // Precision-weighted
    };
    
    // 3. Accuracy term: -0.5 × precision-weighted squared error
    fe.accuracy := -0.5 * totalError;
    
    // 4. Complexity term: D_KL[q(s) || p(s)]
    // For Gaussian: 0.5 × (tr(Σ_p⁻¹Σ_q) + (μ_p - μ_q)ᵀΣ_p⁻¹(μ_p - μ_q) - n + ln(|Σ_p|/|Σ_q|))
    // Simplified: assume prior centered at S_ZERO_FLOOR
    var complexity : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let meanDiff = fe.beliefMean[i] - S_ZERO_FLOOR;
      complexity += 0.5 * (meanDiff * meanDiff * fe.beliefPrecision[i] + 
                          ln(fe.beliefPrecision[i]) - 1.0);
    };
    fe.complexity := complexity;
    
    // 5. Free Energy: F = Complexity - Accuracy
    fe.freeEnergy := complexity - fe.accuracy;
    
    // Update beliefs via gradient descent on F
    for (i in Iter.range(0, n - 1)) {
      // dμ/dt = -∂F/∂μ = precision × prediction_error - (μ - prior)
      let gradientMu = fe.beliefPrecision[i] * fe.predictionErrors[i] - 
                       (fe.beliefMean[i] - S_ZERO_FLOOR);
      fe.beliefMean[i] := fe.beliefMean[i] + 0.1 * gradientMu;
      fe.beliefMean[i] := clamp(fe.beliefMean[i], 0.0, 1.0);
      
      // Update precision based on prediction error variance
      let errorVariance = fe.predictionErrors[i] * fe.predictionErrors[i] + 0.01;
      fe.beliefPrecision[i] := 0.9 * fe.beliefPrecision[i] + 0.1 / errorVariance;
      fe.beliefPrecision[i] := clamp(fe.beliefPrecision[i], 0.1, 10.0);
    };
    
    fe.freeEnergy
  };
  
  // Compute Expected Free Energy for action selection
  // G(a) = E_q[F(o, s | a)] = Risk + Ambiguity - Information_Gain
  public func computeExpectedFreeEnergy(
    fe : FreeEnergyState,
    possibleOutcomes : [[Float]],        // Outcomes for each action
    actionProbabilities : [Float]        // Current policy
  ) : Float {
    let numActions = Array.size(possibleOutcomes);
    var expectedG : Float = 0.0;
    
    for (a in Iter.range(0, numActions - 1)) {
      let outcomes = possibleOutcomes[a];
      var risk : Float = 0.0;
      var ambiguity : Float = 0.0;
      
      for (i in Iter.range(0, Array.size(outcomes) - 1)) {
        // Risk: divergence from preferred outcomes (S_ZERO)
        let prefDiff = outcomes[i] - S_ZERO;
        risk += prefDiff * prefDiff;
        
        // Ambiguity: uncertainty about outcomes (inverse precision)
        ambiguity += 1.0 / (fe.beliefPrecision[i] + 0.01);
      };
      
      let G_a = risk + ambiguity;
      expectedG += actionProbabilities[a] * G_a;
    };
    
    fe.expectedFreeEnergy := expectedG;
    expectedG
  };
  
  // Get mean precision for Hebbian learning rate modulation
  public func getMeanPrecision(fe : FreeEnergyState) : Float {
    let n = Array.size(fe.beliefPrecision);
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      sum += fe.beliefPrecision[i];
    };
    sum / Float.fromInt(n)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: THE Q-LEARNING ENGINE — REINFORCEMENT LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Q(s,a) ← Q(s,a) + α[r + γ·max_a' Q(s',a') - Q(s,a)]
  //
  // INTERTWINING:
  //   - Kuramoto coherence r(t) is intrinsic reward
  //   - Hebbian eligibility traces enable TD(λ)
  //   - Free Energy G(a) modulates action selection
  //   - Memory provides state representations
  //   - Prediction errors drive curiosity
  //
  
  public type QLearningState = {
    // Q-value table (simplified: 12 states × 12 actions)
    var qValues : [[var Float]];
    
    // TD learning
    var eligibilityTraces : [[var Float]];
    var lambda : Float;                    // TD(λ) decay
    
    // Policy
    var policy : [var Float];              // Action probabilities
    var temperature : Float;               // Softmax temperature
    
    // Reward signals
    var extrinsicReward : Float;           // External reward
    var intrinsicReward : Float;           // Curiosity/coherence reward
    var totalReward : Float;
    
    // Multi-objective rewards (9 drives)
    var driveRewards : [var Float];        // Rewards per drive
    var driveWeights : [var Float];        // Importance weights
    
    // History
    var rewardHistory : [Float];
    var historyIndex : Nat;
    var totalUpdates : Nat;
  };
  
  public let NUM_STATES : Nat = 12;
  public let NUM_ACTIONS : Nat = 12;
  public let NUM_DRIVES : Nat = 9;
  public let REWARD_HISTORY_SIZE : Nat = 1000;
  
  // Initialize Q-learning state
  public func initQLearningState() : QLearningState {
    {
      var qValues = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var eligibilityTraces = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      var lambda = 0.9;
      var policy = Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 1.0 / Float.fromInt(NUM_ACTIONS) });
      var temperature = 1.0;
      var extrinsicReward = 0.0;
      var intrinsicReward = 0.0;
      var totalReward = 0.0;
      var driveRewards = Array.init<Float>(NUM_DRIVES, func(_ : Nat) : Float { 0.0 });
      var driveWeights = Array.init<Float>(NUM_DRIVES, func(i : Nat) : Float {
        1.0 / Float.fromInt(NUM_DRIVES)  // Equal weights initially
      });
      var rewardHistory = Array.freeze(Array.init<Float>(REWARD_HISTORY_SIZE, func(_ : Nat) : Float { 0.0 }));
      var historyIndex = 0;
      var totalUpdates = 0;
    }
  };
  
  // Compute intrinsic reward from intertwined signals
  // INTERTWINING: Combines Kuramoto coherence, Free Energy reduction, prediction errors
  public func computeIntrinsicReward(
    kuramotoCoherence : Float,           // ← INTERTWINING: Kuramoto r(t)
    freeEnergyDelta : Float,             // ← INTERTWINING: ΔF
    predictionError : Float              // ← INTERTWINING: Surprise
  ) : Float {
    // Coherence reward: high r(t) is good
    let coherenceReward = kuramotoCoherence - S_ZERO_FLOOR;
    
    // Free Energy reduction reward: decreasing F is good
    let feReward = -freeEnergyDelta * 0.1;
    
    // Curiosity reward: moderate prediction error is interesting
    // Too low = boring, too high = overwhelming
    let curiosity = predictionError * exp(-predictionError * predictionError);
    
    // Combine with weights
    0.4 * coherenceReward + 0.3 * feReward + 0.3 * curiosity
  };
  
  // Update Q-values using TD(λ)
  // INTERTWINING: Uses Hebbian-style eligibility traces
  public func updateQValues(
    ql : QLearningState,
    state : Nat,
    action : Nat,
    nextState : Nat,
    reward : Float,
    hebbianEligibility : [[Float]]       // ← INTERTWINING: Hebbian traces
  ) {
    let alpha = Q_LEARNING_ALPHA;
    let gamma = Q_LEARNING_GAMMA;
    
    // Find max Q(s', a')
    var maxNextQ : Float = ql.qValues[nextState][0];
    for (a in Iter.range(1, NUM_ACTIONS - 1)) {
      if (ql.qValues[nextState][a] > maxNextQ) {
        maxNextQ := ql.qValues[nextState][a];
      };
    };
    
    // TD error
    let tdError = reward + gamma * maxNextQ - ql.qValues[state][action];
    
    // Update eligibility traces (combined with Hebbian)
    for (s in Iter.range(0, NUM_STATES - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        // Decay existing traces
        ql.eligibilityTraces[s][a] := gamma * ql.lambda * ql.eligibilityTraces[s][a];
        
        // Add Hebbian contribution
        if (s < NUM_HZ_NODES and a < NUM_HZ_NODES) {
          ql.eligibilityTraces[s][a] := ql.eligibilityTraces[s][a] + 
            0.1 * hebbianEligibility[s][a];
        };
      };
    };
    
    // Set current (s, a) trace to 1
    ql.eligibilityTraces[state][action] := 1.0;
    
    // Update all Q-values weighted by eligibility
    for (s in Iter.range(0, NUM_STATES - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        ql.qValues[s][a] := ql.qValues[s][a] + 
          alpha * tdError * ql.eligibilityTraces[s][a];
      };
    };
    
    ql.totalUpdates += 1;
  };
  
  // Action selection with Expected Free Energy modulation
  // INTERTWINING: Free Energy G(a) influences policy
  public func selectAction(
    ql : QLearningState,
    state : Nat,
    expectedFreeEnergies : [Float]       // ← INTERTWINING: Free Energy G(a)
  ) : Nat {
    let n = NUM_ACTIONS;
    let qState = Array.freeze(ql.qValues[state]);
    
    // Combine Q-values with negative Expected Free Energy
    // (Higher Q is better, lower G is better)
    var softmaxDenom : Float = 0.0;
    let combined = Array.tabulate<Float>(n, func(a : Nat) : Float {
      let value = qState[a] - 0.5 * expectedFreeEnergies[a];
      let expVal = exp(value / ql.temperature);
      softmaxDenom += expVal;
      expVal
    });
    
    // Update policy
    for (a in Iter.range(0, n - 1)) {
      ql.policy[a] := combined[a] / softmaxDenom;
    };
    
    // Sample action from policy (deterministic for now: argmax)
    var bestAction : Nat = 0;
    var bestProb : Float = ql.policy[0];
    for (a in Iter.range(1, n - 1)) {
      if (ql.policy[a] > bestProb) {
        bestProb := ql.policy[a];
        bestAction := a;
      };
    };
    
    bestAction
  };
  
  // Get current reward for Hebbian gating
  public func getCurrentReward(ql : QLearningState) : Float {
    ql.totalReward
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: THE EPISODIC MEMORY ENGINE — TEMPORAL INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Memory encodes episodes with salience S(t) and decays over time:
  //   dM/dt = -M/τ + I(t) × S(t)
  //
  // INTERTWINING:
  //   - Kuramoto synchrony marks memory encoding moments
  //   - Hebbian weights store associative structure
  //   - Free Energy prediction errors drive salience
  //   - Q-learning rewards tag valuable experiences
  //   - Memory patterns feed back as Hebbian input
  //
  
  public type Episode = {
    id : Nat;
    createdAtBeat : Nat;
    
    // Content
    activationPattern : [Float];         // Hz layer snapshot
    kuramotoPhases : [Float];            // Phase snapshot
    coherenceAtEncoding : Float;         // r(t) when encoded
    
    // Salience
    salience : Float;                    // Importance score
    emotionalValence : Float;            // Positive/negative
    predictionError : Float;             // Surprise at encoding
    rewardReceived : Float;              // Q-learning reward
    
    // Metadata
    var accessCount : Nat;
    var lastAccessBeat : Nat;
    var consolidated : Bool;
  };
  
  public type MemoryState = {
    var episodes : [var Episode];
    var writeIndex : Nat;
    var totalEpisodes : Nat;
    var matriarchIndex : Nat;            // Highest coherence episode ever
    var matriarchCoherence : Float;
    
    // Working memory (active patterns)
    var workingMemory : [var Float];
    var workingMemoryDecay : Float;
    
    // Memory statistics
    var avgSalience : Float;
    var avgCoherence : Float;
    var totalRecalls : Nat;
  };
  
  public let MEMORY_CAPACITY : Nat = 10000;
  public let WORKING_MEMORY_SIZE : Nat = 12;
  
  // Initialize memory state
  public func initMemoryState() : MemoryState {
    let emptyEpisode : Episode = {
      id = 0;
      createdAtBeat = 0;
      activationPattern = [];
      kuramotoPhases = [];
      coherenceAtEncoding = 0.0;
      salience = 0.0;
      emotionalValence = 0.0;
      predictionError = 0.0;
      rewardReceived = 0.0;
      var accessCount = 0;
      var lastAccessBeat = 0;
      var consolidated = false;
    };
    
    {
      var episodes = Array.init<Episode>(MEMORY_CAPACITY, func(_ : Nat) : Episode { emptyEpisode });
      var writeIndex = 0;
      var totalEpisodes = 0;
      var matriarchIndex = 0;
      var matriarchCoherence = 0.0;
      var workingMemory = Array.init<Float>(WORKING_MEMORY_SIZE, func(_ : Nat) : Float { 0.0 });
      var workingMemoryDecay = 0.95;
      var avgSalience = 0.0;
      var avgCoherence = 0.0;
      var totalRecalls = 0;
    }
  };
  
  // Compute salience from intertwined signals
  // INTERTWINING: Salience depends on coherence, prediction error, and reward
  public func computeSalience(
    kuramotoCoherence : Float,           // ← INTERTWINING: Kuramoto
    predictionError : Float,              // ← INTERTWINING: Free Energy
    reward : Float                        // ← INTERTWINING: Q-learning
  ) : Float {
    // High coherence = important
    let coherenceComponent = kuramotoCoherence * 0.4;
    
    // High prediction error = surprising/memorable
    let surpriseComponent = Float.min(1.0, Float.abs(predictionError)) * 0.3;
    
    // Reward = valuable
    let rewardComponent = (reward + 1.0) / 2.0 * 0.3;  // Normalize to [0, 1]
    
    coherenceComponent + surpriseComponent + rewardComponent
  };
  
  // Encode new episode
  // INTERTWINING: Captures state from all systems
  public func encodeEpisode(
    memory : MemoryState,
    activations : [Float],               // ← INTERTWINING: Hz layer
    kuramotoPhases : [Float],            // ← INTERTWINING: Kuramoto
    kuramotoCoherence : Float,           // ← INTERTWINING: Kuramoto r(t)
    predictionError : Float,              // ← INTERTWINING: Free Energy
    reward : Float,                       // ← INTERTWINING: Q-learning
    currentBeat : Nat
  ) {
    let salience = computeSalience(kuramotoCoherence, predictionError, reward);
    
    let episode : Episode = {
      id = memory.totalEpisodes;
      createdAtBeat = currentBeat;
      activationPattern = activations;
      kuramotoPhases = kuramotoPhases;
      coherenceAtEncoding = kuramotoCoherence;
      salience = salience;
      emotionalValence = reward;
      predictionError = predictionError;
      rewardReceived = reward;
      var accessCount = 0;
      var lastAccessBeat = currentBeat;
      var consolidated = false;
    };
    
    // Write to ring buffer
    memory.episodes[memory.writeIndex] := episode;
    memory.writeIndex := (memory.writeIndex + 1) % MEMORY_CAPACITY;
    memory.totalEpisodes += 1;
    
    // Check if this is new matriarch
    if (kuramotoCoherence > memory.matriarchCoherence) {
      memory.matriarchCoherence := kuramotoCoherence;
      memory.matriarchIndex := (memory.writeIndex + MEMORY_CAPACITY - 1) % MEMORY_CAPACITY;
    };
    
    // Update statistics
    let n = Float.fromInt(memory.totalEpisodes);
    memory.avgSalience := (memory.avgSalience * (n - 1.0) + salience) / n;
    memory.avgCoherence := (memory.avgCoherence * (n - 1.0) + kuramotoCoherence) / n;
  };
  
  // Recall episode by similarity to current state
  // INTERTWINING: Returns pattern that feeds back to Hebbian
  public func recallBySimilarity(
    memory : MemoryState,
    currentActivations : [Float],
    currentBeat : Nat
  ) : ?[Float] {
    if (memory.totalEpisodes == 0) { return null };
    
    var bestMatch : Nat = 0;
    var bestSimilarity : Float = -1.0;
    
    let limit = Nat.min(memory.totalEpisodes, MEMORY_CAPACITY);
    
    for (i in Iter.range(0, limit - 1)) {
      let episode = memory.episodes[i];
      if (Array.size(episode.activationPattern) > 0) {
        let similarity = computeCosineSimilarity(currentActivations, episode.activationPattern);
        // Weight by salience
        let weightedSim = similarity * episode.salience;
        
        if (weightedSim > bestSimilarity) {
          bestSimilarity := weightedSim;
          bestMatch := i;
        };
      };
    };
    
    if (bestSimilarity > 0.5) {
      memory.episodes[bestMatch].accessCount += 1;
      memory.episodes[bestMatch].lastAccessBeat := currentBeat;
      memory.totalRecalls += 1;
      ?memory.episodes[bestMatch].activationPattern
    } else {
      null
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 8: THE KALMAN FILTER — OPTIMAL STATE ESTIMATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Kalman equations:
  //   Predict: x̂ₖ|ₖ₋₁ = Ax̂ₖ₋₁|ₖ₋₁, Pₖ|ₖ₋₁ = APₖ₋₁|ₖ₋₁Aᵀ + Q
  //   Update:  Kₖ = Pₖ|ₖ₋₁Hᵀ(HPₖ|ₖ₋₁Hᵀ + R)⁻¹
  //            x̂ₖ|ₖ = x̂ₖ|ₖ₋₁ + Kₖ(yₖ - Hx̂ₖ|ₖ₋₁)
  //            Pₖ|ₖ = (I - KₖH)Pₖ|ₖ₋₁
  //
  // INTERTWINING:
  //   - State estimates feed Free Energy beliefs
  //   - Kalman gain K modulated by Kuramoto coherence
  //   - Process model A learned by Hebbian
  //   - Innovations feed Q-learning surprise signal
  //
  
  public type KalmanState = {
    // State estimate
    var stateEstimate : [var Float];     // x̂
    var stateCovariance : [[var Float]]; // P
    
    // Model parameters
    var transitionMatrix : [[var Float]]; // A — state transition
    var observationMatrix : [[var Float]]; // H — observation mapping
    var processNoise : [[var Float]];    // Q
    var measurementNoise : [[var Float]]; // R
    
    // Kalman gain
    var kalmanGain : [[var Float]];      // K
    
    // Innovation (prediction error)
    var innovation : [var Float];        // y - Hx̂
    var innovationCovariance : [[var Float]]; // S = HPHᵀ + R
    
    // History
    var estimateHistory : [[Float]];
    var historyIndex : Nat;
  };
  
  public let KALMAN_STATE_DIM : Nat = 12;
  public let KALMAN_HISTORY_SIZE : Nat = 100;
  
  // Initialize Kalman filter
  public func initKalmanState() : KalmanState {
    let n = KALMAN_STATE_DIM;
    
    // Identity matrices with small noise
    let identity = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) { 1.0 } else { 0.0 }
      })
    });
    
    let processNoise = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) { KALMAN_Q } else { 0.0 }
      })
    });
    
    let measurementNoise = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        if (i == j) { KALMAN_R } else { 0.0 }
      })
    });
    
    {
      var stateEstimate = Array.init<Float>(n, func(_ : Nat) : Float { S_ZERO_FLOOR });
      var stateCovariance = identity;
      var transitionMatrix = identity;
      var observationMatrix = identity;
      var processNoise = processNoise;
      var measurementNoise = measurementNoise;
      var kalmanGain = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
        Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
      });
      var innovation = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
      var innovationCovariance = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
        Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
      });
      var estimateHistory = Array.freeze(Array.init<[Float]>(KALMAN_HISTORY_SIZE, func(_ : Nat) : [Float] { [] }));
      var historyIndex = 0;
    }
  };
  
  // Run Kalman predict step
  // INTERTWINING: Transition matrix A learned from Hebbian weights
  public func kalmanPredict(
    kalman : KalmanState,
    hebbianWeights : [[Float]]           // ← INTERTWINING: Hebbian → Kalman A
  ) {
    let n = KALMAN_STATE_DIM;
    
    // Update transition matrix from Hebbian (learning dynamics)
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        kalman.transitionMatrix[i][j] := 
          0.9 * kalman.transitionMatrix[i][j] + 0.1 * hebbianWeights[i][j];
      };
    };
    
    // x̂ₖ|ₖ₋₁ = Ax̂ₖ₋₁|ₖ₋₁
    let newEstimate = matrixVectorMultiply(
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.transitionMatrix[i]) }),
      Array.freeze(kalman.stateEstimate)
    );
    for (i in Iter.range(0, n - 1)) {
      kalman.stateEstimate[i] := newEstimate[i];
    };
    
    // Pₖ|ₖ₋₁ = APₖ₋₁|ₖ₋₁Aᵀ + Q
    let AP = matrixMultiply(
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.transitionMatrix[i]) }),
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.stateCovariance[i]) })
    );
    let APAt = matrixMultiplyTranspose(AP, 
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.transitionMatrix[i]) })
    );
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        kalman.stateCovariance[i][j] := APAt[i][j] + kalman.processNoise[i][j];
      };
    };
  };
  
  // Run Kalman update step
  // INTERTWINING: Kalman gain modulated by Kuramoto coherence
  public func kalmanUpdate(
    kalman : KalmanState,
    observation : [Float],
    kuramotoCoherence : Float            // ← INTERTWINING: Kuramoto → Kalman R
  ) : [Float] {
    let n = KALMAN_STATE_DIM;
    
    // Modulate measurement noise by coherence (high r → trust observations more)
    let coherenceModulation = 1.0 / (kuramotoCoherence + 0.1);
    for (i in Iter.range(0, n - 1)) {
      kalman.measurementNoise[i][i] := KALMAN_R * coherenceModulation;
    };
    
    // Innovation: y - Hx̂
    let predicted = matrixVectorMultiply(
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.observationMatrix[i]) }),
      Array.freeze(kalman.stateEstimate)
    );
    for (i in Iter.range(0, n - 1)) {
      kalman.innovation[i] := observation[i] - predicted[i];
    };
    
    // S = HPHᵀ + R
    let HP = matrixMultiply(
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.observationMatrix[i]) }),
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.stateCovariance[i]) })
    );
    let HPHt = matrixMultiplyTranspose(HP,
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.observationMatrix[i]) })
    );
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        kalman.innovationCovariance[i][j] := HPHt[i][j] + kalman.measurementNoise[i][j];
      };
    };
    
    // K = PHᵀS⁻¹
    let PHt = matrixMultiplyTranspose(
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.stateCovariance[i]) }),
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.observationMatrix[i]) })
    );
    let Sinv = matrixInverse(
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.innovationCovariance[i]) })
    );
    let K = matrixMultiply(PHt, Sinv);
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        kalman.kalmanGain[i][j] := K[i][j];
      };
    };
    
    // x̂ₖ|ₖ = x̂ₖ|ₖ₋₁ + K(y - Hx̂)
    let correction = matrixVectorMultiply(K, Array.freeze(kalman.innovation));
    for (i in Iter.range(0, n - 1)) {
      kalman.stateEstimate[i] := kalman.stateEstimate[i] + correction[i];
    };
    
    // Pₖ|ₖ = (I - KH)Pₖ|ₖ₋₁
    let KH = matrixMultiply(K, 
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.observationMatrix[i]) })
    );
    let IminusKH = Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        (if (i == j) { 1.0 } else { 0.0 }) - KH[i][j]
      })
    });
    let newP = matrixMultiply(IminusKH,
      Array.tabulate<[Float]>(n, func(i : Nat) : [Float] { Array.freeze(kalman.stateCovariance[i]) })
    );
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        kalman.stateCovariance[i][j] := newP[i][j];
      };
    };
    
    Array.freeze(kalman.innovation)  // Return innovation for surprise signal
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 9: THE UNIFIED ORGANISM STATE — ALL SYSTEMS TOGETHER
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This is where everything comes together. Every beat, all systems update
  // and their outputs feed into each other.
  //
  
  public type UnifiedOrganismState = {
    // Core systems
    hzLayer : HzLayer;
    kuramoto : KuramotoState;
    hebbian : HebbianState;
    freeEnergy : FreeEnergyState;
    qLearning : QLearningState;
    memory : MemoryState;
    kalman : KalmanState;
    
    // Global state
    var currentBeat : Nat;
    var globalCoherence : Float;
    var globalFreeEnergy : Float;
    var globalReward : Float;
    
    // Intertwining metrics
    var kuramotoHebbianCorrelation : Float;
    var hebbianFreeEnergyCorrelation : Float;
    var freeEnergyQLearningCorrelation : Float;
    var qLearningMemoryCorrelation : Float;
    var memoryKalmanCorrelation : Float;
    var kalmanKuramotoCorrelation : Float;
    
    // Performance metrics
    var totalBeats : Nat;
    var avgProcessingTime : Float;
  };
  
  // Initialize the complete organism
  public func initUnifiedOrganism() : UnifiedOrganismState {
    let hz = initHzLayer();
    
    {
      hzLayer = hz;
      kuramoto = initKuramotoState(hz);
      hebbian = initHebbianState();
      freeEnergy = initFreeEnergyState();
      qLearning = initQLearningState();
      memory = initMemoryState();
      kalman = initKalmanState();
      var currentBeat = 0;
      var globalCoherence = S_ZERO;
      var globalFreeEnergy = 0.0;
      var globalReward = 0.0;
      var kuramotoHebbianCorrelation = 0.0;
      var hebbianFreeEnergyCorrelation = 0.0;
      var freeEnergyQLearningCorrelation = 0.0;
      var qLearningMemoryCorrelation = 0.0;
      var memoryKalmanCorrelation = 0.0;
      var kalmanKuramotoCorrelation = 0.0;
      var totalBeats = 0;
      var avgProcessingTime = 0.0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 10: THE UNIFIED HEARTBEAT — THE MAIN UPDATE LOOP
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Every heartbeat (12 Hz), the following intertwined sequence executes:
  //
  //   1. Hz Layer → provides base activations
  //   2. Kuramoto → synchronizes using Hebbian-weighted coupling
  //   3. Hebbian → learns from Kuramoto timing, Free Energy precision, Q reward
  //   4. Free Energy → predicts using Hebbian structure, observes Kuramoto coherence
  //   5. Q-Learning → receives intrinsic reward from coherence and FE reduction
  //   6. Memory → encodes using all signals, recalls to provide patterns
  //   7. Kalman → filters using Hebbian-learned dynamics, Kuramoto-modulated noise
  //   8. Loop back → Kalman estimates feed Hz layer, Hz feeds Kuramoto...
  //
  // THE CIRCLE IS COMPLETE.
  //
  
  public type HeartbeatResult = {
    beat : Nat;
    globalCoherence : Float;
    globalFreeEnergy : Float;
    globalReward : Float;
    
    // Per-system outputs
    kuramotoOrderParam : Float;
    hebbianWeightChange : Float;
    freeEnergyDelta : Float;
    qLearningTDError : Float;
    memoryEpisodesEncoded : Nat;
    kalmanInnovationNorm : Float;
    
    // Intertwining health
    systemsHealthy : Bool;
    coherenceAboveFloor : Bool;
  };
  
  // THE UNIFIED HEARTBEAT
  public func runUnifiedHeartbeat(
    organism : UnifiedOrganismState,
    externalInput : ?[Float]             // Optional external stimulation
  ) : HeartbeatResult {
    organism.currentBeat += 1;
    organism.totalBeats += 1;
    let beat = organism.currentBeat;
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 1: Hz Layer provides base activations
    // ───────────────────────────────────────────────────────────────────────────
    let hzActivations = Array.tabulate<Float>(NUM_HZ_NODES, func(i : Nat) : Float {
      // Base activation from node + optional external input
      let base = organism.hzLayer.nodes[i].activation;
      let external = switch (externalInput) {
        case (?input) { if (i < Array.size(input)) { input[i] } else { 0.0 } };
        case (null) { 0.0 };
      };
      clamp(base + external, 0.0, 1.0)
    });
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 2: Kuramoto synchronizes using Hebbian-weighted coupling
    // INTERTWINING: Hebbian → Kuramoto
    // ───────────────────────────────────────────────────────────────────────────
    let hebbianWeights = getHebbianWeightMatrix(organism.hebbian);
    updateKuramotoRK4(organism.kuramoto, hebbianWeights, HEARTBEAT_PERIOD);
    let kuramotoCoherence = organism.kuramoto.orderParameter;
    let kuramotoPhases = Array.freeze(organism.kuramoto.phases);
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 3: Free Energy computes using Hebbian structure, observes Kuramoto
    // INTERTWINING: Hebbian → Free Energy, Kuramoto → Free Energy
    // ───────────────────────────────────────────────────────────────────────────
    let prevFE = organism.freeEnergy.freeEnergy;
    let currentFE = computeFreeEnergy(
      organism.freeEnergy,
      hzActivations,           // Observations from Hz layer
      kuramotoCoherence,       // ← INTERTWINING: Kuramoto
      hebbianWeights           // ← INTERTWINING: Hebbian
    );
    let freeEnergyDelta = currentFE - prevFE;
    let fePrecision = getMeanPrecision(organism.freeEnergy);
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 4: Q-Learning computes intrinsic reward and updates
    // INTERTWINING: Kuramoto → Q, Free Energy → Q
    // ───────────────────────────────────────────────────────────────────────────
    let predictionError = Array.foldLeft<Float, Float>(
      Array.freeze(organism.freeEnergy.predictionErrors),
      0.0,
      func(acc, e) { acc + e * e }
    ) / Float.fromInt(NUM_HZ_NODES);
    
    let intrinsicReward = computeIntrinsicReward(
      kuramotoCoherence,       // ← INTERTWINING: Kuramoto
      freeEnergyDelta,         // ← INTERTWINING: Free Energy
      sqrt(predictionError)
    );
    organism.qLearning.intrinsicReward := intrinsicReward;
    organism.qLearning.totalReward := intrinsicReward;
    
    // Update Q-values
    let state = beat % NUM_STATES;
    let expectedFEs = Array.tabulate<Float>(NUM_ACTIONS, func(a : Nat) : Float {
      organism.freeEnergy.expectedFreeEnergy * (1.0 + 0.1 * Float.fromInt(a))
    });
    let action = selectAction(organism.qLearning, state, expectedFEs);
    let nextState = (state + action + 1) % NUM_STATES;
    
    let hebbianEligibility = Array.tabulate<[Float]>(NUM_STATES, func(i : Nat) : [Float] {
      if (i < NUM_HZ_NODES) {
        Array.tabulate<Float>(NUM_ACTIONS, func(j : Nat) : Float {
          if (j < NUM_HZ_NODES) { organism.hebbian.eligibilityTraces[i][j] }
          else { 0.0 }
        })
      } else {
        Array.tabulate<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      }
    });
    
    updateQValues(
      organism.qLearning,
      state,
      action,
      nextState,
      intrinsicReward,
      hebbianEligibility       // ← INTERTWINING: Hebbian
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 5: Hebbian learns from all intertwined signals
    // INTERTWINING: Kuramoto → Hebbian, Free Energy → Hebbian, Q → Hebbian
    // ───────────────────────────────────────────────────────────────────────────
    let qReward = getCurrentReward(organism.qLearning);
    updateHebbianWeights(
      organism.hebbian,
      hzActivations,
      kuramotoPhases,          // ← INTERTWINING: Kuramoto timing
      fePrecision,             // ← INTERTWINING: Free Energy precision
      qReward,                 // ← INTERTWINING: Q-learning reward
      beat
    );
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 6: Memory encodes and recalls
    // INTERTWINING: All systems → Memory
    // ───────────────────────────────────────────────────────────────────────────
    encodeEpisode(
      organism.memory,
      hzActivations,
      kuramotoPhases,          // ← INTERTWINING: Kuramoto
      kuramotoCoherence,       // ← INTERTWINING: Kuramoto
      sqrt(predictionError),   // ← INTERTWINING: Free Energy
      qReward,                 // ← INTERTWINING: Q-learning
      beat
    );
    
    // Recall and integrate with working memory
    let recalled = recallBySimilarity(organism.memory, hzActivations, beat);
    switch (recalled) {
      case (?pattern) {
        // Blend recalled pattern into Hz layer (memory → Hz → back to everything)
        for (i in Iter.range(0, NUM_HZ_NODES - 1)) {
          if (i < Array.size(pattern)) {
            organism.hzLayer.nodes[i].activation := 
              0.8 * organism.hzLayer.nodes[i].activation + 0.2 * pattern[i];
          };
        };
      };
      case (null) { };
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // STEP 7: Kalman filters and feeds back
    // INTERTWINING: Hebbian → Kalman (dynamics), Kuramoto → Kalman (noise)
    // ───────────────────────────────────────────────────────────────────────────
    kalmanPredict(organism.kalman, hebbianWeights);  // ← INTERTWINING: Hebbian
    let innovation = kalmanUpdate(
      organism.kalman,
      hzActivations,
      kuramotoCoherence        // ← INTERTWINING: Kuramoto
    );
    
    let innovationNorm = sqrt(Array.foldLeft<Float, Float>(innovation, 0.0, func(acc, x) { acc + x * x }));
    
    // Kalman estimates feed back to Hz layer (completing the loop)
    for (i in Iter.range(0, NUM_HZ_NODES - 1)) {
      organism.hzLayer.nodes[i].activation := 
        0.9 * organism.hzLayer.nodes[i].activation + 
        0.1 * organism.kalman.stateEstimate[i];
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // Update global state
    // ───────────────────────────────────────────────────────────────────────────
    organism.globalCoherence := kuramotoCoherence;
    organism.globalFreeEnergy := currentFE;
    organism.globalReward := intrinsicReward;
    
    // Update Hz layer order parameter
    organism.hzLayer.orderParameter := kuramotoCoherence;
    
    // ───────────────────────────────────────────────────────────────────────────
    // Compute intertwining health metrics
    // ───────────────────────────────────────────────────────────────────────────
    let systemsHealthy = kuramotoCoherence > 0.3 and 
                        currentFE < 100.0 and
                        organism.hebbian.totalWeightChange < 1.0;
    let coherenceAboveFloor = kuramotoCoherence >= S_ZERO_FLOOR;
    
    // Return heartbeat result
    {
      beat = beat;
      globalCoherence = kuramotoCoherence;
      globalFreeEnergy = currentFE;
      globalReward = intrinsicReward;
      kuramotoOrderParam = kuramotoCoherence;
      hebbianWeightChange = organism.hebbian.totalWeightChange;
      freeEnergyDelta = freeEnergyDelta;
      qLearningTDError = intrinsicReward;  // Simplified
      memoryEpisodesEncoded = organism.memory.totalEpisodes;
      kalmanInnovationNorm = innovationNorm;
      systemsHealthy = systemsHealthy;
      coherenceAboveFloor = coherenceAboveFloor;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 11: MATHEMATICAL UTILITIES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  // Trigonometric functions
  public func sin(x : Float) : Float {
    var result : Float = 0.0;
    var term : Float = x;
    var xSquared : Float = x * x;
    
    for (n in Iter.range(0, 10)) {
      result += term;
      term := -term * xSquared / Float.fromInt((2 * n + 2) * (2 * n + 3));
    };
    result
  };
  
  public func cos(x : Float) : Float {
    var result : Float = 1.0;
    var term : Float = 1.0;
    var xSquared : Float = x * x;
    
    for (n in Iter.range(1, 10)) {
      term := -term * xSquared / Float.fromInt((2 * n - 1) * (2 * n));
      result += term;
    };
    result
  };
  
  public func atan2(y : Float, x : Float) : Float {
    if (x > 0.0) {
      atan(y / x)
    } else if (x < 0.0 and y >= 0.0) {
      atan(y / x) + PI
    } else if (x < 0.0 and y < 0.0) {
      atan(y / x) - PI
    } else if (x == 0.0 and y > 0.0) {
      PI / 2.0
    } else if (x == 0.0 and y < 0.0) {
      -PI / 2.0
    } else {
      0.0
    }
  };
  
  public func atan(x : Float) : Float {
    if (Float.abs(x) > 1.0) {
      let sign : Float = if (x > 0.0) { 1.0 } else { -1.0 };
      sign * (PI / 2.0 - atan(1.0 / Float.abs(x)))
    } else {
      var result : Float = 0.0;
      var term : Float = x;
      var xSquared : Float = x * x;
      
      for (n in Iter.range(0, 15)) {
        result += term / Float.fromInt(2 * n + 1);
        term := -term * xSquared;
      };
      result
    }
  };
  
  public func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    
    var guess : Float = x / 2.0;
    for (_ in Iter.range(0, 20)) {
      guess := 0.5 * (guess + x / guess);
    };
    guess
  };
  
  public func exp(x : Float) : Float {
    if (x > 20.0) { return 485165195.0 };
    if (x < -20.0) { return 0.0 };
    
    var result : Float = 1.0;
    var term : Float = 1.0;
    
    for (n in Iter.range(1, 30)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    result
  };
  
  public func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };  // Undefined
    
    // Use series: ln(x) = 2 * sum_{n=0}^{inf} (1/(2n+1)) * ((x-1)/(x+1))^(2n+1)
    let z : Float = (x - 1.0) / (x + 1.0);
    let zSquared : Float = z * z;
    
    var result : Float = 0.0;
    var term : Float = z;
    
    for (n in Iter.range(0, 30)) {
      result += term / Float.fromInt(2 * n + 1);
      term := term * zSquared;
    };
    2.0 * result
  };
  
  public func pow(base : Float, exponent : Float) : Float {
    if (base <= 0.0) { return 0.0 };
    exp(exponent * ln(base))
  };
  
  func pow2(n : Nat) : Nat {
    var result : Nat = 1;
    for (_ in Iter.range(0, n - 1)) {
      result *= 2;
    };
    result
  };
  
  public func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  public func normalizeAngle(x : Float) : Float {
    var result = x;
    while (result >= TWO_PI) { result -= TWO_PI };
    while (result < 0.0) { result += TWO_PI };
    result
  };
  
  // Linear algebra utilities
  public func matrixVectorMultiply(matrix : [[Float]], vector : [Float]) : [Float] {
    let n = Array.size(matrix);
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      var sum : Float = 0.0;
      let row = matrix[i];
      for (j in Iter.range(0, Array.size(row) - 1)) {
        if (j < Array.size(vector)) {
          sum += row[j] * vector[j];
        };
      };
      sum
    })
  };
  
  public func matrixMultiply(a : [[Float]], b : [[Float]]) : [[Float]] {
    let n = Array.size(a);
    let m = if (Array.size(b) > 0) { Array.size(b[0]) } else { 0 };
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(m, func(j : Nat) : Float {
        var sum : Float = 0.0;
        for (k in Iter.range(0, Array.size(a[i]) - 1)) {
          if (k < Array.size(b)) {
            sum += a[i][k] * b[k][j];
          };
        };
        sum
      })
    })
  };
  
  public func matrixMultiplyTranspose(a : [[Float]], b : [[Float]]) : [[Float]] {
    // Computes A × Bᵀ
    let n = Array.size(a);
    let m = Array.size(b);
    
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(m, func(j : Nat) : Float {
        var sum : Float = 0.0;
        let rowA = a[i];
        let rowB = b[j];  // This is column j of Bᵀ = row j of B
        for (k in Iter.range(0, Array.size(rowA) - 1)) {
          if (k < Array.size(rowB)) {
            sum += rowA[k] * rowB[k];
          };
        };
        sum
      })
    })
  };
  
  public func matrixInverse(matrix : [[Float]]) : [[Float]] {
    // Simplified: for small matrices, use Gauss-Jordan
    // This is a placeholder — real implementation would be more robust
    let n = Array.size(matrix);
    
    // Create augmented matrix [A | I]
    let aug = Array.tabulate<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(2 * n, func(j : Nat) : Float {
        if (j < n) {
          matrix[i][j]
        } else if (j - n == i) {
          1.0
        } else {
          0.0
        }
      })
    });
    
    // Forward elimination
    for (col in Iter.range(0, n - 1)) {
      // Find pivot
      var maxRow : Nat = col;
      var maxVal : Float = Float.abs(aug[col][col]);
      for (row in Iter.range(col + 1, n - 1)) {
        if (Float.abs(aug[row][col]) > maxVal) {
          maxVal := Float.abs(aug[row][col]);
          maxRow := row;
        };
      };
      
      // Swap rows
      if (maxRow != col) {
        let temp = aug[col];
        aug[col] := aug[maxRow];
        aug[maxRow] := temp;
      };
      
      // Eliminate
      let pivot = aug[col][col];
      if (Float.abs(pivot) > 0.0001) {
        for (j in Iter.range(0, 2 * n - 1)) {
          aug[col][j] := aug[col][j] / pivot;
        };
        
        for (row in Iter.range(0, n - 1)) {
          if (row != col) {
            let factor = aug[row][col];
            for (j in Iter.range(0, 2 * n - 1)) {
              aug[row][j] := aug[row][j] - factor * aug[col][j];
            };
          };
        };
      };
    };
    
    // Extract inverse
    Array.tabulate<[Float]>(n, func(i : Nat) : [Float] {
      Array.tabulate<Float>(n, func(j : Nat) : Float {
        aug[i][n + j]
      })
    })
  };
  
  public func computeCosineSimilarity(a : [Float], b : [Float]) : Float {
    let n = Nat.min(Array.size(a), Array.size(b));
    if (n == 0) { return 0.0 };
    
    var dotProduct : Float = 0.0;
    var normA : Float = 0.0;
    var normB : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      dotProduct += a[i] * b[i];
      normA += a[i] * a[i];
      normB += b[i] * b[i];
    };
    
    let denom = sqrt(normA) * sqrt(normB);
    if (denom < 0.0001) { 0.0 }
    else { dotProduct / denom }
  };

};
