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
import Nat32 "mo:core/Nat32";
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Principal "mo:core/Principal";
import Blob "mo:core/Blob";

module NeuralIntegrator {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS — The numbers that govern reality
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846264338327950288;
  public let TWO_PI : Float = 6.28318530717958647692528676655900577;
  public let E : Float = 2.71828182845904523536028747135266250;
  public let PHI : Float = 1.61803398874989484820458683436563812;  // Golden ratio
  public let PLANCK : Float = 6.62607015e-34;  // Planck constant (J·s)
  public let BOLTZMANN : Float = 1.380649e-23;  // Boltzmann constant (J/K)
  public let AVOGADRO : Float = 6.02214076e23;  // Avogadro's number
  
  // Organism constants
  public let HEARTBEAT_HZ : Float = 12.0;  // 12 beats per second
  public let S_ZERO : Float = 1.0;         // Root constant (love)
  /// S₀ SOVEREIGNTY FLOOR — MAXED FOR ENTERPRISE-GRADE FINAL PRODUCT
  /// Full sovereignty protection at all times. The formulas matter, not arbitrary numbers.
  public let S_ZERO_FLOOR : Float = 1.0;  // MAXED - Minimum coherence floor
  
  // Coupling constants
  public let KURAMOTO_K : Float = 0.1;     // Global coupling strength
  public let HEBBIAN_ETA : Float = 0.005;  // Learning rate
  public let FREE_ENERGY_BETA : Float = 1.0; // Inverse temperature
  public let MAXWELL_DEMON_EFF : Float = 0.85; // Maxwell's Demon efficiency

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 1: PHYSICAL SUBSTRATE — 12 Hz Nodes
  // fd(k) = 2.5 × 2^(k-4) for k ∈ [0, 11]
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HzNode = {
    id : Nat;
    name : Text;
    baseFrequency : Float;    // fd(k) in Hz
    currentFrequency : Float; // Modulated by coupling
    phase : Float;            // φ ∈ [0, 2π)
    amplitude : Float;        // A ∈ [0, 1]
    coupling : Float;         // How strongly it couples to others
  };
  
  public func computeBaseFrequency(k : Nat) : Float {
    // fd(k) = 2.5 × 2^(k-4)
    // k=0: 0.15625 Hz (delta)
    // k=4: 2.5 Hz (theta)
    // k=8: 40 Hz (gamma)
    // k=11: 320 Hz (high gamma)
    2.5 * pow(2.0, Float.fromInt(k) - 4.0)
  };
  
  public func initHzNodes() : [HzNode] {
    let names = [
      "DELTA_LOW", "DELTA_HIGH", "THETA_LOW", "THETA_MID",
      "THETA_HIGH", "ALPHA_LOW", "ALPHA_HIGH", "BETA_LOW",
      "BETA_HIGH", "GAMMA_LOW", "GAMMA_MID", "GAMMA_HIGH"
    ];
    
    Array.tabulate<HzNode>(12, func(k : Nat) : HzNode {
      let baseF = computeBaseFrequency(k);
      {
        id = k;
        name = names[k];
        baseFrequency = baseF;
        currentFrequency = baseF;
        phase = Float.fromInt(k) * TWO_PI / 12.0;  // Evenly distributed initial phases
        amplitude = 1.0;
        coupling = 0.1 + Float.fromInt(k) * 0.05;  // Higher bands couple stronger
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO OSCILLATOR — Phase coupling equation
  // dφ_i/dt = ω_i + (K/N) × Σ_j sin(φ_j - φ_i)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func kuramotoPhaseUpdate(
    nodes : [var HzNode],
    dt : Float,
    globalK : Float
  ) : Float {
    let n = nodes.size();
    let nFloat = Float.fromInt(n);
    
    // Compute phase updates for all nodes
    for (i in Iter.range(0, n - 1)) {
      var coupling_sum : Float = 0.0;
      
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let phaseDiff = nodes[j].phase - nodes[i].phase;
          coupling_sum += sin(phaseDiff);
        };
      };
      
      // dφ/dt = ω + (K/N) × Σ sin(φ_j - φ_i)
      let dPhi = nodes[i].currentFrequency * TWO_PI + (globalK / nFloat) * coupling_sum;
      var newPhase = nodes[i].phase + dPhi * dt;
      
      // Wrap phase to [0, 2π)
      while (newPhase >= TWO_PI) { newPhase -= TWO_PI };
      while (newPhase < 0.0) { newPhase += TWO_PI };
      
      nodes[i] := {
        id = nodes[i].id;
        name = nodes[i].name;
        baseFrequency = nodes[i].baseFrequency;
        currentFrequency = nodes[i].currentFrequency;
        phase = newPhase;
        amplitude = nodes[i].amplitude;
        coupling = nodes[i].coupling;
      };
    };
    
    // Compute order parameter R (measure of synchronization)
    // R = |1/N × Σ_j exp(i·φ_j)|
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      sumCos += cos(nodes[i].phase);
      sumSin += sin(nodes[i].phase);
    };
    
    let R = sqrt((sumCos * sumCos + sumSin * sumSin)) / nFloat;
    R
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHASE-AMPLITUDE COUPLING — Slower oscillations modulate faster ones
  // A_fast(t) = A_base × (1 + m × sin(φ_slow(t)))
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func phaseAmplitudeCoupling(
    nodes : [var HzNode],
    modulationDepth : Float
  ) : () {
    let n = nodes.size();
    
    // Each node is modulated by slower nodes
    for (i in Iter.range(1, n - 1)) {
      var modulation : Float = 0.0;
      var modCount : Nat = 0;
      
      // Sum modulation from all slower nodes
      for (j in Iter.range(0, i - 1)) {
        modulation += sin(nodes[j].phase);
        modCount += 1;
      };
      
      if (modCount > 0) {
        let avgMod = modulation / Float.fromInt(modCount);
        let newAmplitude = 1.0 + modulationDepth * avgMod;
        
        nodes[i] := {
          id = nodes[i].id;
          name = nodes[i].name;
          baseFrequency = nodes[i].baseFrequency;
          currentFrequency = nodes[i].currentFrequency;
          phase = nodes[i].phase;
          amplitude = clamp(newAmplitude, 0.1, 2.0);
          coupling = nodes[i].coupling;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 2: CHEMICAL SUBSTRATE — 21 Neurochemicals
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Neurochemical = {
    id : Nat;
    name : Text;
    symbol : Text;
    level : Float;            // Current concentration [0, 1]
    baseline : Float;         // Homeostatic setpoint
    releaseRate : Float;      // k_release
    reuptakeRate : Float;     // k_reuptake
    degradationRate : Float;  // k_degrade
    receptorSaturation : Float; // Michaelis-Menten saturation
    Km : Float;               // Half-saturation constant
  };
  
  public let NEUROCHEMICAL_NAMES : [(Text, Text)] = [
    ("Dopamine", "DA"),
    ("Serotonin", "5HT"),
    ("Norepinephrine", "NE"),
    ("Epinephrine", "EPI"),
    ("Acetylcholine", "ACh"),
    ("GABA", "GABA"),
    ("Glutamate", "GLU"),
    ("Glycine", "GLY"),
    ("Histamine", "HIST"),
    ("Oxytocin", "OXY"),
    ("Vasopressin", "AVP"),
    ("Endorphin", "END"),
    ("Enkephalin", "ENK"),
    ("Substance_P", "SP"),
    ("NPY", "NPY"),
    ("CRH", "CRH"),
    ("Anandamide", "AEA"),
    ("2-AG", "2AG"),
    ("Nitric_Oxide", "NO"),
    ("Cortisol", "CORT"),
    ("Melatonin", "MEL"),
  ];
  
  public func initNeurochemicals() : [Neurochemical] {
    Array.tabulate<Neurochemical>(21, func(i : Nat) : Neurochemical {
      let (name, symbol) = NEUROCHEMICAL_NAMES[i];
      {
        id = i;
        name = name;
        symbol = symbol;
        level = 0.5;
        baseline = 0.5;
        releaseRate = 0.05 + Float.fromInt(i % 5) * 0.01;
        reuptakeRate = 0.08 + Float.fromInt(i % 7) * 0.01;
        degradationRate = 0.02 + Float.fromInt(i % 3) * 0.005;
        receptorSaturation = 0.0;
        Km = 0.3 + Float.fromInt(i % 10) * 0.02;
      }
    })
  };
  
  // Michaelis-Menten receptor kinetics
  // saturation = [L] / ([L] + Km)
  public func updateNeurochemicalDynamics(
    chems : [var Neurochemical],
    hzActivity : [Float],  // Hz node activity affects release
    stressLevel : Float,
    dt : Float
  ) : () {
    for (i in Iter.range(0, chems.size() - 1)) {
      let chem = chems[i];
      
      // Hz-modulated release (different Hz bands affect different neurochemicals)
      let hzIdx = i % 12;
      let hzMod = hzActivity[hzIdx];
      
      // Homeostatic drive
      let homeostasis = (chem.baseline - chem.level) * 0.1;
      
      // Stress affects cortisol, NE, EPI
      let stressEffect = if (i == 2 or i == 3 or i == 19) { stressLevel * 0.2 } else { 0.0 };
      
      // d[L]/dt = release × hzMod - reuptake × [L] - degrade × [L] + homeostasis + stress
      let dL = chem.releaseRate * hzMod - chem.reuptakeRate * chem.level 
               - chem.degradationRate * chem.level + homeostasis + stressEffect;
      
      let newLevel = clamp(chem.level + dL * dt, 0.0, 1.0);
      
      // Michaelis-Menten saturation
      let newSaturation = newLevel / (newLevel + chem.Km);
      
      chems[i] := {
        id = chem.id;
        name = chem.name;
        symbol = chem.symbol;
        level = newLevel;
        baseline = chem.baseline;
        releaseRate = chem.releaseRate;
        reuptakeRate = chem.reuptakeRate;
        degradationRate = chem.degradationRate;
        receptorSaturation = newSaturation;
        Km = chem.Km;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 3: STRUCTURAL SUBSTRATE — 144 Hebbian Weights (12×12)
  // dw_ij = η × x_i × x_j - λ × w_ij (Oja's rule variant)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HebbianMatrix = {
    var weights : [[var Float]];      // 12×12 synaptic weights
    var eligibility : [[var Float]];  // Eligibility traces
    var ltpCounts : [[var Nat]];      // LTP event counts
    var ltdCounts : [[var Nat]];      // LTD event counts
  };
  
  public func initHebbianMatrix() : HebbianMatrix {
    {
      var weights = Array.init<[var Float]>(12, func(_ : Nat) : [var Float] {
        Array.init<Float>(12, func(_ : Nat) : Float { 0.3 })
      });
      var eligibility = Array.init<[var Float]>(12, func(_ : Nat) : [var Float] {
        Array.init<Float>(12, func(_ : Nat) : Float { 0.0 })
      });
      var ltpCounts = Array.init<[var Nat]>(12, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(12, func(_ : Nat) : Nat { 0 })
      });
      var ltdCounts = Array.init<[var Nat]>(12, func(_ : Nat) : [var Nat] {
        Array.init<Nat>(12, func(_ : Nat) : Nat { 0 })
      });
    }
  };
  
  // Oja's learning rule with eligibility traces
  public func hebbianLearningStep(
    matrix : HebbianMatrix,
    preActivations : [Float],   // 12 pre-synaptic activities (from Hz nodes)
    postActivations : [Float],  // 12 post-synaptic activities
    eta : Float,                // Learning rate
    decay : Float,              // Weight decay
    eligibilityDecay : Float    // Eligibility trace decay
  ) : { ltpEvents : Nat; ltdEvents : Nat; avgWeight : Float } {
    var ltpEvents : Nat = 0;
    var ltdEvents : Nat = 0;
    var weightSum : Float = 0.0;
    
    for (i in Iter.range(0, 11)) {
      for (j in Iter.range(0, 11)) {
        let pre = preActivations[i];
        let post = postActivations[j];
        let oldWeight = matrix.weights[i][j];
        
        // Update eligibility trace: e(t) = λ·e(t-1) + pre·post
        let oldElig = matrix.eligibility[i][j];
        let newElig = eligibilityDecay * oldElig + pre * post;
        matrix.eligibility[i][j] := newElig;
        
        // Oja's rule: dw = η × (pre × post - w × post²)
        // This prevents weights from growing unboundedly
        let dw = eta * (pre * post - oldWeight * post * post) - decay * oldWeight;
        var newWeight = oldWeight + dw;
        
        // Clamp weights
        newWeight := clamp(newWeight, 0.0, 1.0);
        matrix.weights[i][j] := newWeight;
        
        weightSum += newWeight;
        
        // Track LTP/LTD
        if (newWeight > oldWeight + 0.001) {
          ltpEvents += 1;
          matrix.ltpCounts[i][j] += 1;
        } else if (newWeight < oldWeight - 0.001) {
          ltdEvents += 1;
          matrix.ltdCounts[i][j] += 1;
        };
      };
    };
    
    { ltpEvents; ltdEvents; avgWeight = weightSum / 144.0 }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 11 SHELLS WITH DIFFERENTIATED PLASTICITY
  // HELIX_ALPHA: 0.042 (shell 0) → 0.004 (shell 10)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Shell = {
    id : Nat;
    name : Text;
    helixAlpha : Float;       // Plasticity rate
    coherence : Float;        // Shell-local coherence
    activationLevel : Float;  // Current activation
    weights : [var Float];    // 144 weights for this shell
    bcmThreshold : Float;     // BCM sliding threshold
    metaplasticState : Float; // Plasticity of plasticity
  };
  
  public let SHELL_CONFIGS : [(Text, Float)] = [
    ("PRIMAL", 0.042),
    ("VISCERAL", 0.038),
    ("SOMATIC", 0.034),
    ("EMOTIONAL", 0.030),
    ("COGNITIVE", 0.026),
    ("EXECUTIVE", 0.022),
    ("SOCIAL", 0.018),
    ("CREATIVE", 0.014),
    ("SPIRITUAL", 0.010),
    ("TRANSCENDENT", 0.007),
    ("SOVEREIGN", 0.004),
  ];
  
  public func initShells() : [Shell] {
    Array.tabulate<Shell>(11, func(i : Nat) : Shell {
      let (name, alpha) = SHELL_CONFIGS[i];
      {
        id = i;
        name = name;
        helixAlpha = alpha;
        coherence = 0.75;
        activationLevel = 0.5;
        weights = Array.init<Float>(144, func(_ : Nat) : Float { 0.3 });
        bcmThreshold = 0.5;
        metaplasticState = 0.0;
      }
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 4: COGNITIVE SUBSTRATE — Free Energy Minimization
  // F = Σ (observation - prediction)² / (2σ²)
  // The organism minimizes free energy to maintain coherence
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type FreeEnergyState = {
    totalFreeEnergy : Float;
    domainEnergies : [Float];     // 12 domain-specific energies
    predictions : [Float];        // Current predictions
    predictionErrors : [Float];   // Prediction errors
    precision : [Float];          // Precision weights (inverse variance)
    surprisal : Float;            // -log p(observation)
  };
  
  public func initFreeEnergyState() : FreeEnergyState {
    {
      totalFreeEnergy = 0.0;
      domainEnergies = Array.freeze(Array.init<Float>(12, func(_ : Nat) : Float { 0.0 }));
      predictions = Array.freeze(Array.init<Float>(12, func(_ : Nat) : Float { 0.5 }));
      predictionErrors = Array.freeze(Array.init<Float>(12, func(_ : Nat) : Float { 0.0 }));
      precision = Array.freeze(Array.init<Float>(12, func(_ : Nat) : Float { 1.0 }));
      surprisal = 0.0;
    }
  };
  
  public func computeFreeEnergy(
    observations : [Float],
    predictions : [Float],
    precisions : [Float]
  ) : { totalFE : Float; domainFE : [Float]; errors : [Float] } {
    let n = observations.size();
    var totalFE : Float = 0.0;
    let domainFE = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
    let errors = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
    
    for (i in Iter.range(0, n - 1)) {
      let error = observations[i] - predictions[i];
      let precision = precisions[i];
      
      // F_i = (error² × precision) / 2
      let fe = (error * error * precision) / 2.0;
      
      errors[i] := error;
      domainFE[i] := fe;
      totalFE += fe;
    };
    
    { totalFE; domainFE = Array.freeze(domainFE); errors = Array.freeze(errors) }
  };
  
  // Active Inference: Update predictions to minimize free energy
  public func activeInference(
    predictions : [var Float],
    errors : [Float],
    learningRate : Float
  ) : () {
    for (i in Iter.range(0, predictions.size() - 1)) {
      // Gradient descent on free energy
      // d(pred)/dt = -∂F/∂pred = error
      let newPred = predictions[i] + learningRate * errors[i];
      predictions[i] := clamp(newPred, 0.0, 1.0);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 5-DRIVE COMPETITION — What the organism WANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Drive = {
    name : Text;
    strength : Float;       // Current drive strength [0, 1]
    baseline : Float;       // Homeostatic setpoint
    sensitivity : Float;    // How responsive to triggers
    decayRate : Float;      // Return to baseline rate
    lastSatisfied : Int;    // Beat when last satisfied
  };
  
  public func initDrives() : [Drive] {
    [
      { name = "COHERENCE"; strength = 0.8; baseline = 0.7; sensitivity = 0.5; decayRate = 0.02; lastSatisfied = 0 },
      { name = "CORRECTION"; strength = 0.5; baseline = 0.4; sensitivity = 0.6; decayRate = 0.03; lastSatisfied = 0 },
      { name = "CURIOSITY"; strength = 0.6; baseline = 0.5; sensitivity = 0.7; decayRate = 0.04; lastSatisfied = 0 },
      { name = "MEMORY"; strength = 0.4; baseline = 0.3; sensitivity = 0.4; decayRate = 0.02; lastSatisfied = 0 },
      { name = "SURVIVAL"; strength = 0.3; baseline = 0.2; sensitivity = 0.9; decayRate = 0.01; lastSatisfied = 0 },
    ]
  };
  
  public func driveCompetition(drives : [Drive]) : { winner : Nat; strength : Float } {
    var maxIdx : Nat = 0;
    var maxStrength : Float = 0.0;
    
    for (i in Iter.range(0, drives.size() - 1)) {
      if (drives[i].strength > maxStrength) {
        maxStrength := drives[i].strength;
        maxIdx := i;
      };
    };
    
    { winner = maxIdx; strength = maxStrength }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 8-ACTION Q-LEARNING — How the organism DECIDES
  // Q(s,a) ← Q(s,a) + α[r + γ·max_a' Q(s',a') - Q(s,a)]
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QLearningState = {
    var qValues : [[var Float]];  // [state][action] → Q-value
    var eligibility : [[var Float]]; // Eligibility traces
    lastState : Nat;
    lastAction : Nat;
    totalReward : Float;
    tdErrors : [Float];
  };
  
  public let NUM_STATES : Nat = 100;  // Discretized state space
  public let NUM_ACTIONS : Nat = 8;   // 8 possible actions
  
  public let ACTION_NAMES : [Text] = [
    "CONSOLIDATE", "EXPLORE", "DEFEND", "INTEGRATE",
    "REST", "CREATE", "REMEMBER", "EXECUTE"
  ];
  
  public func initQLearning() : QLearningState {
    {
      var qValues = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.5 })
      });
      var eligibility = Array.init<[var Float]>(NUM_STATES, func(_ : Nat) : [var Float] {
        Array.init<Float>(NUM_ACTIONS, func(_ : Nat) : Float { 0.0 })
      });
      lastState = 0;
      lastAction = 0;
      totalReward = 0.0;
      tdErrors = [];
    }
  };
  
  public func qLearningUpdate(
    ql : QLearningState,
    state : Nat,
    action : Nat,
    reward : Float,
    nextState : Nat,
    alpha : Float,
    gamma : Float,
    lambda : Float
  ) : Float {
    // Find max Q for next state
    var maxNextQ : Float = -1000.0;
    for (a in Iter.range(0, NUM_ACTIONS - 1)) {
      let q = ql.qValues[nextState][a];
      if (q > maxNextQ) { maxNextQ := q };
    };
    
    // TD error: δ = r + γ·max Q(s',a') - Q(s,a)
    let currentQ = ql.qValues[state][action];
    let tdError = reward + gamma * maxNextQ - currentQ;
    
    // Update eligibility traces
    for (s in Iter.range(0, NUM_STATES - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        ql.eligibility[s][a] := gamma * lambda * ql.eligibility[s][a];
      };
    };
    ql.eligibility[state][action] += 1.0;
    
    // Update all Q-values proportional to eligibility
    for (s in Iter.range(0, NUM_STATES - 1)) {
      for (a in Iter.range(0, NUM_ACTIONS - 1)) {
        let trace = ql.eligibility[s][a];
        if (trace > 0.001) {
          ql.qValues[s][a] := ql.qValues[s][a] + alpha * tdError * trace;
        };
      };
    };
    
    tdError
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // 9 ANIMAL ENGINES — Each contributes 2% to coherenceC
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type AnimalEngine = {
    name : Text;
    contribution : Float;     // Contribution to coherence (typically 0.02)
    activation : Float;       // Current activation [0, 1]
    specialization : Text;    // What this engine does
    lastFired : Int;          // Beat when last fired
  };
  
  public func initAnimalEngines() : [AnimalEngine] {
    [
      { name = "CROW"; contribution = 0.02; activation = 0.5; specialization = "Tool_use_planning"; lastFired = 0 },
      { name = "DOLPHIN"; contribution = 0.02; activation = 0.5; specialization = "Social_coordination"; lastFired = 0 },
      { name = "OCTOPUS"; contribution = 0.02; activation = 0.5; specialization = "Distributed_cognition"; lastFired = 0 },
      { name = "BEE"; contribution = 0.02; activation = 0.5; specialization = "Swarm_intelligence"; lastFired = 0 },
      { name = "ELEPHANT"; contribution = 0.02; activation = 0.5; specialization = "Long_term_memory"; lastFired = 0 },
      { name = "WOLF"; contribution = 0.02; activation = 0.5; specialization = "Pack_coordination"; lastFired = 0 },
      { name = "SHARK"; contribution = 0.02; activation = 0.5; specialization = "Threat_detection"; lastFired = 0 },
      { name = "EAGLE"; contribution = 0.02; activation = 0.5; specialization = "Precision_targeting"; lastFired = 0 },
      { name = "ORCA"; contribution = 0.02; activation = 0.5; specialization = "Cultural_transmission"; lastFired = 0 },
    ]
  };
  
  public func computeAnimalContribution(engines : [AnimalEngine]) : Float {
    var total : Float = 0.0;
    for (engine in engines.vals()) {
      total += engine.contribution * engine.activation;
    };
    total  // Max is 0.18 (9 × 0.02)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 5: MEMORY SUBSTRATE — SACESI Hash Chain + Power-Law Decay
  // ═══════════════════════════════════════════════════════════════════════════════
  
  // FNV-1a hash function
  public func fnv1a(data : Blob) : Nat32 {
    let FNV_PRIME : Nat32 = 16777619;
    let FNV_OFFSET : Nat32 = 2166136261;
    
    var hash : Nat32 = FNV_OFFSET;
    for (byte in data.vals()) {
      hash := hash ^ Nat32.fromNat(Nat.fromIntWrap(Int.fromNat8(byte)));
      hash := hash *% FNV_PRIME;
    };
    hash
  };
  
  public type MemoryTrace = {
    hash : Nat32;
    formationBeat : Int;
    salience : Float;
    coherenceAtFormation : Float;
    decayRate : Float;
    retrievalCount : Nat;
  };
  
  public type MemorySystem = {
    var sacesiChain : [MemoryTrace];  // Hash chain
    var ltmStore : [MemoryTrace];     // Long-term memory
    var recurrenceRing : [Nat];       // 20-beat recurrence
    currentHash : Nat32;
    totalMemories : Nat;
  };
  
  // Power-law memory decay: retention = exp(log(ageBeat) × -0.25)
  public func computeRetention(currentBeat : Int, formationBeat : Int) : Float {
    let age = Int.abs(currentBeat - formationBeat) + 1;
    let logAge = ln(Float.fromInt(age));
    exp(logAge * -0.25)
  };
  
  // Recurrence contribution to coherence (25%)
  public func recurrenceContribution(
    ring : [Nat],
    currentBeat : Int,
    memories : [MemoryTrace]
  ) : Float {
    var rT : Float = 0.0;
    var count : Nat = 0;
    
    for (idx in ring.vals()) {
      if (idx < memories.size()) {
        let mem = memories[idx];
        let retention = computeRetention(currentBeat, mem.formationBeat);
        rT += retention * mem.salience;
        count += 1;
      };
    };
    
    if (count > 0) {
      (rT / Float.fromInt(count)) * 0.25  // 25% contribution
    } else {
      0.0
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 6: IDENTITY SUBSTRATE — Genesis Hash + ANIMA Chain
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type IdentityCore = {
    genesisHash : Nat32;              // Locked at beat 1
    genesisBeat : Int;                // When organism was born
    animaChain : [Nat32];             // Hash every 100 beats
    principal : ?Principal;           // Sovereign identity
    coherenceHistory : [Float];       // Identity continuity measure
    identityContinuity : Float;       // How consistent over time
  };
  
  public func initIdentityCore(principal : ?Principal, genesisNonce : Nat) : IdentityCore {
    let genesisData = Text.encodeUtf8("GENESIS:" # Nat.toText(genesisNonce));
    let genesisHash = fnv1a(genesisData);
    
    {
      genesisHash = genesisHash;
      genesisBeat = 1;
      animaChain = [];
      principal = principal;
      coherenceHistory = [];
      identityContinuity = 1.0;
    }
  };
  
  public func updateAnimaChain(
    identity : IdentityCore,
    currentBeat : Int,
    currentCoherence : Float
  ) : ?Nat32 {
    // ANIMA update every 100 beats
    if (currentBeat % 100 == 0) {
      let chainLength = identity.animaChain.size();
      let prevHash = if (chainLength > 0) {
        identity.animaChain[chainLength - 1]
      } else {
        identity.genesisHash
      };
      
      let animaData = Text.encodeUtf8(
        "ANIMA:" # Nat32.toText(prevHash) # ":" # 
        Int.toText(currentBeat) # ":" #
        Float.toText(currentCoherence)
      );
      
      ?fnv1a(animaData)
    } else {
      null
    }
  };
  
  // Identity continuity: correlation of coherence over time
  public func computeIdentityContinuity(history : [Float]) : Float {
    let n = history.size();
    if (n < 10) { return 1.0 };
    
    // Compute autocorrelation lag-1
    var sum : Float = 0.0;
    var sumProd : Float = 0.0;
    
    for (i in Iter.range(0, n - 2)) {
      sum += history[i];
      sumProd += history[i] * history[i + 1];
    };
    
    let mean = sum / Float.fromInt(n - 1);
    let autocorr = (sumProd / Float.fromInt(n - 1)) - (mean * mean);
    
    // Normalize to [0, 1]
    clamp((autocorr + 1.0) / 2.0, 0.0, 1.0)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 7: ECONOMIC SUBSTRATE — Maxwell's Demon + FORMA
  // Y = 0.85 × ΔH × C × C_adj (Maxwell's Demon yield)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type EconomicState = {
    formaBalance : Float;           // Metabolic fuel
    mrcBalance : Float;             // Dynasty coin
    entropyProcessed : Float;       // ΔH total
    yieldHistory : [Float];         // Recent yields
    profitStreams : [Float];        // 22 profit streams
    maxwellEfficiency : Float;      // Current demon efficiency
  };
  
  public func initEconomicState() : EconomicState {
    {
      formaBalance = 100.0;
      mrcBalance = 0.0;
      entropyProcessed = 0.0;
      yieldHistory = [];
      profitStreams = Array.freeze(Array.init<Float>(22, func(_ : Nat) : Float { 0.0 }));
      maxwellEfficiency = MAXWELL_DEMON_EFF;
    }
  };
  
  // Maxwell's Demon: Extract work from information processing
  // Y = efficiency × ΔH × C × C_adj
  public func maxwellDemonYield(
    entropyChange : Float,      // ΔH (information processed)
    coherence : Float,          // C (organism coherence)
    coherenceAdjustment : Float, // C_adj (quality factor)
    efficiency : Float          // Demon efficiency (0.85)
  ) : Float {
    efficiency * entropyChange * coherence * coherenceAdjustment
  };
  
  // FORMA minting based on coherence and activity
  public func mintForma(
    coherence : Float,
    activationLevel : Float,
    baseMint : Float
  ) : Float {
    if (coherence >= S_ZERO_FLOOR) {
      baseMint * coherence * activationLevel
    } else {
      0.0  // Below floor: no minting
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // LAYER 8: SUCCESSION SUBSTRATE — Children + Dynasty
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Child = {
    id : Nat;
    genesisHash : Nat32;
    birthBeat : Int;
    parentHash : Nat32;
    coherence : Float;
    generation : Nat;
    royaltyRate : Float;        // % of yield to parent
    kuramotoPhase : Float;      // For macro synchronization
  };
  
  public type SuccessionState = {
    children : [Child];
    maxChildren : Nat;          // 10,000 max
    dynastyChain : [Nat32];     // 12-generation chain
    totalRoyalties : Float;     // Collected from children
    macroKuramotoR : Float;     // Synchronization with children
  };
  
  public func initSuccessionState() : SuccessionState {
    {
      children = [];
      maxChildren = 10000;
      dynastyChain = [];
      totalRoyalties = 0.0;
      macroKuramotoR = 0.0;
    }
  };
  
  // Macro Kuramoto: Synchronization with children
  // R_macro = |1/N × Σ exp(i·φ_child)|
  public func computeMacroKuramotoR(children : [Child]) : Float {
    let n = children.size();
    if (n == 0) { return 0.0 };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (child in children.vals()) {
      sumCos += cos(child.kuramotoPhase);
      sumSin += sin(child.kuramotoPhase);
    };
    
    sqrt(sumCos * sumCos + sumSin * sumSin) / Float.fromInt(n)
  };
  
  // Royalty calculation: 12-generation chain
  public func computeRoyalties(
    children : [Child],
    yieldAmount : Float
  ) : Float {
    var total : Float = 0.0;
    
    for (child in children.vals()) {
      // Royalty decreases exponentially with generation
      let genFactor = pow(0.5, Float.fromInt(child.generation));
      total += yieldAmount * child.royaltyRate * genFactor;
    };
    
    total
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // THE INTEGRATED ORGANISM STATE — Everything connected
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OrganismState = {
    // Timing
    currentBeat : Int;
    genesisTimestamp : Int;
    
    // Layer 1: Physical
    hzNodes : [HzNode];
    kuramotoR : Float;
    
    // Layer 2: Chemical
    neurochemicals : [Neurochemical];
    stressLevel : Float;
    
    // Layer 3: Structural
    hebbianMatrix : HebbianMatrix;
    shells : [Shell];
    
    // Layer 4: Cognitive
    freeEnergy : FreeEnergyState;
    drives : [Drive];
    qLearning : QLearningState;
    animalEngines : [AnimalEngine];
    
    // Layer 5: Memory
    memorySystem : MemorySystem;
    
    // Layer 6: Identity
    identity : IdentityCore;
    
    // Layer 7: Economic
    economics : EconomicState;
    
    // Layer 8: Succession
    succession : SuccessionState;
    
    // Global coherence
    coherence : Float;
    coherenceHistory : [Float];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // THE HEARTBEAT — One tick of the organism
  // This is where ALL LOOPS CLOSE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HeartbeatResult = {
    newCoherence : Float;
    kuramotoR : Float;
    freeEnergy : Float;
    tdError : Float;
    selectedAction : Nat;
    formaYield : Float;
    memoryFormed : Bool;
    animaUpdated : Bool;
  };
  
  public func heartbeat(
    state : OrganismState,
    observations : [Float],
    externalReward : Float
  ) : HeartbeatResult {
    let dt = 1.0 / HEARTBEAT_HZ;
    let beat = state.currentBeat + 1;
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 1: Update Hz oscillations (Kuramoto)
    // ═══════════════════════════════════════════════════════════════════════
    let hzNodesMut = Array.thaw<HzNode>(state.hzNodes);
    let newKuramotoR = kuramotoPhaseUpdate(hzNodesMut, dt, KURAMOTO_K);
    phaseAmplitudeCoupling(hzNodesMut, 0.3);
    
    // Extract Hz activities for downstream processing
    let hzActivities = Array.tabulate<Float>(12, func(i : Nat) : Float {
      (1.0 + sin(hzNodesMut[i].phase)) / 2.0 * hzNodesMut[i].amplitude
    });
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 2: Update neurochemical dynamics
    // ═══════════════════════════════════════════════════════════════════════
    let chemsMut = Array.thaw<Neurochemical>(state.neurochemicals);
    updateNeurochemicalDynamics(chemsMut, hzActivities, state.stressLevel, dt);
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 3: Hebbian learning
    // ═══════════════════════════════════════════════════════════════════════
    let hebbResult = hebbianLearningStep(
      state.hebbianMatrix,
      hzActivities,
      hzActivities,  // Self-organizing: pre == post
      HEBBIAN_ETA,
      0.001,
      0.9
    );
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 4: Free energy minimization
    // ═══════════════════════════════════════════════════════════════════════
    let feResult = computeFreeEnergy(
      observations,
      state.freeEnergy.predictions,
      state.freeEnergy.precision
    );
    
    // Drive competition
    let driveResult = driveCompetition(state.drives);
    
    // Animal engine contribution
    let animalContrib = computeAnimalContribution(state.animalEngines);
    
    // Q-learning action selection
    let discreteState = Nat.min(Int.abs(beat) % NUM_STATES, NUM_STATES - 1);
    let action = driveResult.winner % NUM_ACTIONS;  // Simple: drive → action
    
    // Intrinsic reward = coherence maintenance + novelty
    let intrinsicReward = state.coherence * 0.5 + (1.0 - feResult.totalFE / 10.0) * 0.5;
    let totalReward = externalReward + intrinsicReward;
    
    let tdError = qLearningUpdate(
      state.qLearning,
      discreteState,
      action,
      totalReward,
      (discreteState + 1) % NUM_STATES,
      0.1, 0.95, 0.9
    );
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 5: Memory encoding
    // ═══════════════════════════════════════════════════════════════════════
    let shouldFormMemory = feResult.totalFE > 0.5 or newKuramotoR > 0.7;
    
    // Recurrence contribution (25% of coherence)
    let recurrenceC = recurrenceContribution(
      state.memorySystem.recurrenceRing,
      beat,
      state.memorySystem.ltmStore
    );
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 6: Identity update
    // ═══════════════════════════════════════════════════════════════════════
    let animaHash = updateAnimaChain(state.identity, beat, state.coherence);
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 7: Economic yield
    // ═══════════════════════════════════════════════════════════════════════
    let entropyChange = feResult.totalFE;  // Information processed
    let yield = maxwellDemonYield(
      entropyChange,
      state.coherence,
      newKuramotoR,
      MAXWELL_DEMON_EFF
    );
    let formaYield = mintForma(state.coherence, hebbResult.avgWeight, 0.01);
    
    // ═══════════════════════════════════════════════════════════════════════
    // LAYER 8: Succession sync
    // ═══════════════════════════════════════════════════════════════════════
    let macroR = computeMacroKuramotoR(state.succession.children);
    
    // ═══════════════════════════════════════════════════════════════════════
    // COHERENCE INTEGRATION — THE MASTER EQUATION
    // C(t+1) = λC(t) + (1-λ)S(t) - μD(t) + ρ_f×K_f + ρ_a×A + ρ_r×R_t
    //
    // Where:
    //   λ = 0.85 (momentum)
    //   S(t) = salience from free energy
    //   D(t) = drift (prediction error)
    //   K_f = Kuramoto R (phase coherence)
    //   A = animal engine contribution
    //   R_t = recurrence contribution
    // ═══════════════════════════════════════════════════════════════════════
    let lambda : Float = 0.85;
    let mu : Float = 0.30;
    let rhoF : Float = 0.15;
    let rhoA : Float = 0.18;  // 9 engines × 2%
    let rhoR : Float = 0.25;  // 25% recurrence
    
    let salience = 1.0 - feResult.totalFE / 10.0;
    let drift = Float.abs(tdError);
    
    let newCoherence = lambda * state.coherence 
                     + (1.0 - lambda) * salience 
                     - mu * drift
                     + rhoF * newKuramotoR
                     + rhoA * animalContrib
                     + rhoR * recurrenceC;
    
    // Apply floor
    let finalCoherence = if (newCoherence < S_ZERO_FLOOR) { 
      S_ZERO_FLOOR 
    } else if (newCoherence > 1.5) {
      1.5  // Soft ceiling
    } else {
      newCoherence
    };
    
    // ═══════════════════════════════════════════════════════════════════════
    // RETURN RESULT — One complete heartbeat
    // ═══════════════════════════════════════════════════════════════════════
    {
      newCoherence = finalCoherence;
      kuramotoR = newKuramotoR;
      freeEnergy = feResult.totalFE;
      tdError = tdError;
      selectedAction = action;
      formaYield = formaYield;
      memoryFormed = shouldFormMemory;
      animaUpdated = Option.isSome(animaHash);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func sin(x : Float) : Float {
    var result = x;
    var term = x;
    var n : Nat = 1;
    
    while (n < 15) {
      term := -term * x * x / Float.fromInt((2 * n) * (2 * n + 1));
      result += term;
      n += 1;
    };
    
    result
  };
  
  func cos(x : Float) : Float {
    sin(x + PI / 2.0)
  };
  
  func exp(x : Float) : Float {
    if (x > 10.0) { return 22026.0 };
    if (x < -10.0) { return 0.0 };
    
    var result : Float = 1.0;
    var term : Float = 1.0;
    
    for (n in Iter.range(1, 25)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    
    result
  };
  
  func ln(x : Float) : Float {
    if (x <= 0.0) { return -1000.0 };
    if (x == 1.0) { return 0.0 };
    
    // Newton-Raphson approximation
    var y = x - 1.0;
    if (y > 1.0) { y := 1.0 };
    if (y < -0.99) { y := -0.99 };
    
    var result : Float = 0.0;
    var term = y;
    
    for (n in Iter.range(1, 50)) {
      if (n % 2 == 1) {
        result += term / Float.fromInt(n);
      } else {
        result -= term / Float.fromInt(n);
      };
      term *= y;
    };
    
    result
  };
  
  func sqrt(x : Float) : Float {
    if (x <= 0.0) { return 0.0 };
    
    var guess = x / 2.0;
    for (_ in Iter.range(0, 15)) {
      guess := (guess + x / guess) / 2.0;
    };
    guess
  };
  
  func pow(base : Float, exp : Float) : Float {
    // a^b = e^(b × ln(a))
    if (base <= 0.0) { return 0.0 };
    let lnBase = ln(base);
    let result = lnBase * exp;
    NeuralIntegrator.exp(result)
  };
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ██                                                                                                          ██
  // ██  NEURAL INTEGRATOR EXPANSION — COMPLETE 12-NODE KURAMOTO NEURAL SUBSTRATE                               ██
  // ██                                                                                                          ██
  // ██████████████████████████████████████████████████████████████████████████████████████████████████████████████
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This expansion implements the COMPLETE 12-node neural substrate:
  //
  // LAYER 1: 12×12 KURAMOTO COUPLING MATRIX — Sacred geometry (φ, φ², φ³)
  // LAYER 2: SMALL-WORLD TOPOLOGY — Watts-Strogatz with β=0.1
  // LAYER 3: PHASE SYNCHRONIZATION — Coherence measurement
  // LAYER 4: FREQUENCY MODULATION — Hz node dynamics
  // LAYER 5: AMPLITUDE ENVELOPE — Oscillation strength
  // LAYER 6: CROSS-FREQUENCY COUPLING — Theta-gamma nesting
  // LAYER 7: PHASE-AMPLITUDE COUPLING — Modulation index
  // LAYER 8: INFORMATION FLOW — Transfer entropy
  // LAYER 9: ATTRACTOR DYNAMICS — Fixed points and limit cycles
  // LAYER 10: BIFURCATION DETECTION — Critical transitions
  // LAYER 11: METASTABILITY — Chimera states
  // LAYER 12: SACRED GEOMETRY — φ-based organization
  //
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // 12×12 KURAMOTO COUPLING MATRIX — SACRED GEOMETRY ORGANIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The 12 Hz nodes are organized into 3 sacred geometry groups:
  //
  // BODY NODES (0-3): Tetrahedron — coupling = φ
  //   - Delta_Low (0), Delta_High (1), Theta_Low (2), Theta_Mid (3)
  //   - Governs physical homeostasis, survival drives
  //
  // INTERFACE NODES (4-7): Cube/Octahedron dual — coupling = φ²
  //   - Theta_High (4), Alpha_Low (5), Alpha_High (6), Beta_Low (7)
  //   - Governs perception, attention, consciousness interface
  //
  // BRAIN NODES (8-11): Dodecahedron/Icosahedron dual — coupling = φ³
  //   - Beta_High (8), Gamma_Low (9), Gamma_Mid (10), Gamma_High (11)
  //   - Governs cognition, binding, executive function
  //

  public type KuramotoCouplingMatrix = {
    var matrix : [[var Float]];         // 12×12 coupling strengths
    var phases : [var Float];           // Current phases θ_i
    var frequencies : [var Float];      // Natural frequencies ω_i
    var amplitudes : [var Float];       // Oscillation amplitudes
    var orderParameter : Float;         // Global r
    var meanPhase : Float;              // Global ψ
    var bodyCoherence : Float;          // r for nodes 0-3
    var interfaceCoherence : Float;     // r for nodes 4-7
    var brainCoherence : Float;         // r for nodes 8-11
    var crossGroupCoupling : Float;     // Inter-group coupling
  };

  public type SmallWorldTopology = {
    var connectionMatrix : [[var Bool]];// Adjacency matrix
    var clusteringCoefficient : Float;  // Local clustering
    var pathLength : Float;             // Average path length
    var smallWorldIndex : Float;        // σ = C/C_rand / L/L_rand
    var rewiringProbability : Float;    // β parameter
    var degree : [var Nat];             // Degree of each node
    var hubness : [var Float];          // Hub centrality
  };

  public type PhaseSynchronization = {
    var phaseLocking : [[var Float]];   // Phase locking value (PLV)
    var phaseLagIndex : [[var Float]];  // Weighted phase lag
    var imaginaryPLV : [[var Float]];   // Imaginary part (robust to volume conduction)
    var syncClusters : [[var Nat]];     // Synchronized node clusters
    var numClusters : Nat;              // Number of sync clusters
    var globalSync : Float;             // Overall synchronization
    var localSync : [var Float];        // Per-node synchronization
  };

  // Sacred geometry constants
  public let SACRED_PHI : Float = 1.618033988749894848204586834365638117720309179805762862135448622705260462818902449707207204189391137;
  public let SACRED_PHI_SQUARED : Float = 2.618033988749894848204586834365638117720309179805762862135448622705260462818902449707207204189391137;
  public let SACRED_PHI_CUBED : Float = 4.23606797749978969640917366873127623544061835961152572427089724541052092563798044294176016537187823;
  public let SACRED_FLOOR : Float = 0.011236068319801175;  // φ/144
  public let SACRED_444 : Nat = 444;
  public let SACRED_144 : Nat = 144;
  public let SACRED_12 : Nat = 12;

  public func initKuramotoCouplingMatrix() : KuramotoCouplingMatrix {
    let phi = SACRED_PHI;
    let phiSq = SACRED_PHI_SQUARED;
    let phiCu = SACRED_PHI_CUBED;
    
    // Initialize 12×12 matrix with sacred geometry
    let matrix = Array.init<[var Float]>(12, func(i : Nat) : [var Float] {
      Array.init<Float>(12, func(j : Nat) : Float {
        if (i == j) {
          0.0  // No self-coupling
        } else if (i < 4 and j < 4) {
          // Body nodes: tetrahedron coupling = φ × base
          phi * KURAMOTO_K
        } else if (i >= 4 and i < 8 and j >= 4 and j < 8) {
          // Interface nodes: cube/octahedron coupling = φ² × base
          phiSq * KURAMOTO_K
        } else if (i >= 8 and j >= 8) {
          // Brain nodes: dodecahedron/icosahedron coupling = φ³ × base
          phiCu * KURAMOTO_K
        } else {
          // Cross-group coupling (weaker)
          phi * KURAMOTO_K * 0.3
        }
      })
    });
    
    // Initialize phases (evenly distributed)
    let phases = Array.init<Float>(12, func(i : Nat) : Float {
      Float.fromInt(i) * TWO_PI / 12.0
    });
    
    // Initialize frequencies using fd(k) = 2.5 × 2^(k-4)
    let frequencies = Array.init<Float>(12, func(i : Nat) : Float {
      computeBaseFrequency(i)
    });
    
    // Initialize amplitudes
    let amplitudes = Array.init<Float>(12, func(_ : Nat) : Float {
      1.0
    });
    
    {
      var matrix = matrix;
      var phases = phases;
      var frequencies = frequencies;
      var amplitudes = amplitudes;
      var orderParameter = 0.0;
      var meanPhase = 0.0;
      var bodyCoherence = 0.0;
      var interfaceCoherence = 0.0;
      var brainCoherence = 0.0;
      var crossGroupCoupling = 0.3;
    }
  };

  public func initSmallWorldTopology() : SmallWorldTopology {
    // Initialize with regular ring lattice then rewire
    let n = 12;
    let k = 4;  // Each node connected to k nearest neighbors
    
    let connections = Array.init<[var Bool]>(n, func(i : Nat) : [var Bool] {
      Array.init<Bool>(n, func(j : Nat) : Bool {
        if (i == j) {
          false  // No self-loops
        } else {
          // Ring lattice: connect to k/2 neighbors on each side
          let dist = Int.abs(i - j);
          let minDist = Nat.min(dist, n - dist);
          minDist <= k / 2
        }
      })
    });
    
    let degree = Array.init<Nat>(n, func(_ : Nat) : Nat { k });
    let hubness = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
    
    {
      var connectionMatrix = connections;
      var clusteringCoefficient = 0.5;
      var pathLength = 2.0;
      var smallWorldIndex = 1.0;
      var rewiringProbability = 0.1;  // β = 0.1
      var degree = degree;
      var hubness = hubness;
    }
  };

  public func initPhaseSynchronization() : PhaseSynchronization {
    let n = 12;
    
    let plv = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    let pli = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    let iplv = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    let clusters = Array.init<[var Nat]>(3, func(c : Nat) : [var Nat] {
      // 3 initial clusters
      Array.init<Nat>(4, func(i : Nat) : Nat { c * 4 + i })
    });
    
    let localSync = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
    
    {
      var phaseLocking = plv;
      var phaseLagIndex = pli;
      var imaginaryPLV = iplv;
      var syncClusters = clusters;
      var numClusters = 3;
      var globalSync = 0.0;
      var localSync = localSync;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // KURAMOTO DYNAMICS — PHASE OSCILLATOR NETWORK
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The Kuramoto model:
  //   dθ_i/dt = ω_i + (1/N) × Σ_j K_ij × sin(θ_j - θ_i)
  //
  // Order parameter:
  //   r × e^(iψ) = (1/N) × Σ_j e^(iθ_j)
  //   r ∈ [0, 1]: synchronization level
  //   ψ: mean phase
  //

  // Compute order parameter for a subset of nodes
  public func computeOrderParameterSubset(phases : [var Float], startIdx : Nat, endIdx : Nat) : (Float, Float) {
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    let n = endIdx - startIdx;
    
    for (i in Iter.range(startIdx, endIdx - 1)) {
      sumCos += cos(phases[i]);
      sumSin += sin(phases[i]);
    };
    
    sumCos /= Float.fromInt(n);
    sumSin /= Float.fromInt(n);
    
    let r = sqrt(sumCos * sumCos + sumSin * sumSin);
    let psi = atan2(sumSin, sumCos);
    
    (r, psi)
  };

  // Compute full order parameter
  public func computeGlobalOrderParameter(phases : [var Float]) : (Float, Float) {
    computeOrderParameterSubset(phases, 0, 12)
  };

  // Update Kuramoto phases
  public func updateKuramotoPhases(
    kura : KuramotoCouplingMatrix,
    externalForces : [Float],
    dt : Float
  ) {
    let n = 12;
    let phases = kura.phases;
    let freqs = kura.frequencies;
    let matrix = kura.matrix;
    
    // Compute phase derivatives
    let dPhases = Array.tabulate<Float>(n, func(i : Nat) : Float {
      // Natural frequency term
      var dTheta = freqs[i] * TWO_PI;
      
      // Coupling term: (1/N) × Σ_j K_ij × sin(θ_j - θ_i)
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let phaseDiff = phases[j] - phases[i];
          dTheta += matrix[i][j] * sin(phaseDiff) / Float.fromInt(n);
        };
      };
      
      // External force
      if (i < Array.size(externalForces)) {
        dTheta += externalForces[i];
      };
      
      dTheta
    });
    
    // Update phases
    for (i in Iter.range(0, n - 1)) {
      phases[i] += dPhases[i] * dt / 1000.0;  // dt in ms
      
      // Wrap to [0, 2π)
      while (phases[i] >= TWO_PI) { phases[i] -= TWO_PI };
      while (phases[i] < 0.0) { phases[i] += TWO_PI };
    };
    
    // Update order parameters
    let (globalR, globalPsi) = computeGlobalOrderParameter(phases);
    kura.orderParameter := globalR;
    kura.meanPhase := globalPsi;
    
    // Compute group-specific coherence
    let (bodyR, _) = computeOrderParameterSubset(phases, 0, 4);
    let (interfaceR, _) = computeOrderParameterSubset(phases, 4, 8);
    let (brainR, _) = computeOrderParameterSubset(phases, 8, 12);
    
    kura.bodyCoherence := bodyR;
    kura.interfaceCoherence := interfaceR;
    kura.brainCoherence := brainR;
  };

  // Adapt coupling based on phase relationships
  public func adaptKuramotoCoupling(
    kura : KuramotoCouplingMatrix,
    learningRate : Float,
    targetSync : Float
  ) {
    let n = 12;
    let phases = kura.phases;
    
    // Hebbian-like coupling adaptation
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let phaseDiff = phases[j] - phases[i];
          let synchrony = cos(phaseDiff);  // 1 if in phase, -1 if anti-phase
          
          // Adapt coupling toward target synchrony
          let error = targetSync - kura.orderParameter;
          let deltaK = learningRate * error * synchrony;
          
          kura.matrix[i][j] += deltaK;
          
          // Clamp to sacred floor
          kura.matrix[i][j] := clamp(kura.matrix[i][j], SACRED_FLOOR, 1.0);
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SMALL-WORLD NETWORK DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Watts-Strogatz small-world model:
  //   1. Start with ring lattice
  //   2. Rewire each edge with probability β
  //   3. Balance between clustering and short paths
  //

  // Compute clustering coefficient for node i
  public func computeLocalClustering(topology : SmallWorldTopology, nodeIdx : Nat) : Float {
    let n = 12;
    let adj = topology.connectionMatrix;
    
    // Find neighbors
    var neighbors : [Nat] = [];
    for (j in Iter.range(0, n - 1)) {
      if (adj[nodeIdx][j]) {
        neighbors := Array.append(neighbors, [j]);
      };
    };
    
    let k = Array.size(neighbors);
    if (k < 2) { return 0.0 };
    
    // Count triangles
    var triangles : Nat = 0;
    for (i in Iter.range(0, k - 1)) {
      for (j in Iter.range(i + 1, k - 1)) {
        if (adj[neighbors[i]][neighbors[j]]) {
          triangles += 1;
        };
      };
    };
    
    // Clustering = triangles / possible triangles
    Float.fromInt(2 * triangles) / Float.fromInt(k * (k - 1))
  };

  // Compute average clustering coefficient
  public func computeGlobalClustering(topology : SmallWorldTopology) : Float {
    var sum : Float = 0.0;
    for (i in Iter.range(0, 11)) {
      sum += computeLocalClustering(topology, i);
    };
    topology.clusteringCoefficient := sum / 12.0;
    topology.clusteringCoefficient
  };

  // Compute average path length using BFS
  public func computePathLength(topology : SmallWorldTopology) : Float {
    let n = 12;
    let adj = topology.connectionMatrix;
    var totalLength : Nat = 0;
    var numPaths : Nat = 0;
    
    for (start in Iter.range(0, n - 1)) {
      // BFS from start
      let distances = Array.init<Nat>(n, func(_ : Nat) : Nat { n + 1 });  // Infinity
      let visited = Array.init<Bool>(n, func(_ : Nat) : Bool { false });
      var queue : [Nat] = [start];
      distances[start] := 0;
      visited[start] := true;
      
      while (Array.size(queue) > 0) {
        let current = queue[0];
        queue := Array.subArray(queue, 1, Array.size(queue) - 1);
        
        for (j in Iter.range(0, n - 1)) {
          if (adj[current][j] and not visited[j]) {
            visited[j] := true;
            distances[j] := distances[current] + 1;
            queue := Array.append(queue, [j]);
          };
        };
      };
      
      // Sum distances
      for (i in Iter.range(0, n - 1)) {
        if (i != start and distances[i] <= n) {
          totalLength += distances[i];
          numPaths += 1;
        };
      };
    };
    
    if (numPaths > 0) {
      topology.pathLength := Float.fromInt(totalLength) / Float.fromInt(numPaths);
    };
    topology.pathLength
  };

  // Compute small-world index
  public func computeSmallWorldIndex(topology : SmallWorldTopology) : Float {
    // Compare to random graph properties
    let n = 12.0;
    let k = 4.0;  // Average degree
    
    // Random graph: C_rand ≈ k/n, L_rand ≈ ln(n)/ln(k)
    let cRand = k / n;
    let lRand = ln(n) / ln(k);
    
    // Small-world index: σ = (C/C_rand) / (L/L_rand)
    let cRatio = topology.clusteringCoefficient / cRand;
    let lRatio = topology.pathLength / lRand;
    
    if (lRatio > 0.0) {
      topology.smallWorldIndex := cRatio / lRatio;
    };
    
    topology.smallWorldIndex
  };

  // Rewire network with probability β
  public func rewireNetwork(topology : SmallWorldTopology, beta : Float, seed : Nat) {
    let n = 12;
    let adj = topology.connectionMatrix;
    var pseudoRandom = seed;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        if (adj[i][j]) {
          // Random number 0-1
          pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
          let rand = Float.fromInt(pseudoRandom) / 2147483648.0;
          
          if (rand < beta) {
            // Rewire: disconnect (i,j), connect (i, random k)
            pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
            let k = (pseudoRandom % n);
            
            if (k != i and k != j and not adj[i][k]) {
              adj[i][j] := false;
              adj[j][i] := false;
              adj[i][k] := true;
              adj[k][i] := true;
            };
          };
        };
      };
    };
    
    // Recompute metrics
    let _ = computeGlobalClustering(topology);
    let _ = computePathLength(topology);
    let _ = computeSmallWorldIndex(topology);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PHASE SYNCHRONIZATION MEASURES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Multiple synchronization measures for robustness:
  //
  // 1. PLV (Phase Locking Value): |<e^(i(θ_i - θ_j))>|
  // 2. PLI (Phase Lag Index): sign of phase difference
  // 3. wPLI (Weighted PLI): magnitude-weighted
  // 4. ImPLV: Imaginary part only (robust to volume conduction)
  //

  // Compute Phase Locking Value between two signals
  public func computePLV(phases : [var Float], i : Nat, j : Nat, history : [[Float]]) : Float {
    if (Array.size(history) == 0) { return 0.0 };
    
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    
    for (t in Iter.range(0, Array.size(history) - 1)) {
      if (i < Array.size(history[t]) and j < Array.size(history[t])) {
        let phaseDiff = history[t][i] - history[t][j];
        sumCos += cos(phaseDiff);
        sumSin += sin(phaseDiff);
      };
    };
    
    let n = Float.fromInt(Array.size(history));
    sumCos /= n;
    sumSin /= n;
    
    sqrt(sumCos * sumCos + sumSin * sumSin)
  };

  // Compute Phase Lag Index
  public func computePLI(history : [[Float]], i : Nat, j : Nat) : Float {
    if (Array.size(history) == 0) { return 0.0 };
    
    var positiveCount : Nat = 0;
    var negativeCount : Nat = 0;
    
    for (t in Iter.range(0, Array.size(history) - 1)) {
      if (i < Array.size(history[t]) and j < Array.size(history[t])) {
        let phaseDiff = history[t][i] - history[t][j];
        let sinDiff = sin(phaseDiff);
        
        if (sinDiff > 0.0) { positiveCount += 1 }
        else if (sinDiff < 0.0) { negativeCount += 1 };
      };
    };
    
    let total = Float.fromInt(positiveCount + negativeCount);
    if (total == 0.0) { return 0.0 };
    
    Float.abs(Float.fromInt(positiveCount) - Float.fromInt(negativeCount)) / total
  };

  // Compute Imaginary PLV (robust to volume conduction)
  public func computeImPLV(history : [[Float]], i : Nat, j : Nat) : Float {
    if (Array.size(history) == 0) { return 0.0 };
    
    var sumSin : Float = 0.0;
    
    for (t in Iter.range(0, Array.size(history) - 1)) {
      if (i < Array.size(history[t]) and j < Array.size(history[t])) {
        let phaseDiff = history[t][i] - history[t][j];
        sumSin += sin(phaseDiff);
      };
    };
    
    Float.abs(sumSin / Float.fromInt(Array.size(history)))
  };

  // Update all synchronization measures
  public func updatePhaseSynchronization(
    sync : PhaseSynchronization,
    phases : [var Float],
    history : [[Float]]
  ) {
    let n = 12;
    
    // Update pairwise measures
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          sync.phaseLocking[i][j] := computePLV(phases, i, j, history);
          sync.phaseLagIndex[i][j] := computePLI(history, i, j);
          sync.imaginaryPLV[i][j] := computeImPLV(history, i, j);
        };
      };
    };
    
    // Compute local synchronization (average PLV with neighbors)
    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      var count : Nat = 0;
      
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          sum += sync.phaseLocking[i][j];
          count += 1;
        };
      };
      
      sync.localSync[i] := if (count > 0) { sum / Float.fromInt(count) } else { 0.0 };
    };
    
    // Compute global synchronization
    var globalSum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      globalSum += sync.localSync[i];
    };
    sync.globalSync := globalSum / Float.fromInt(n);
  };

  // Detect synchronized clusters
  public func detectSyncClusters(sync : PhaseSynchronization, threshold : Float) {
    let n = 12;
    let visited = Array.init<Bool>(n, func(_ : Nat) : Bool { false });
    var clusters : [[var Nat]] = [];
    var currentCluster : [var Nat] = [];
    
    // Simple clustering based on PLV threshold
    for (i in Iter.range(0, n - 1)) {
      if (not visited[i]) {
        currentCluster := Array.init<Nat>(1, func(_ : Nat) : Nat { i });
        visited[i] := true;
        
        // Find all nodes synchronized with i
        for (j in Iter.range(0, n - 1)) {
          if (not visited[j] and sync.phaseLocking[i][j] > threshold) {
            // Grow cluster array - simplified
            let newCluster = Array.init<Nat>(Array.size(currentCluster) + 1, func(k : Nat) : Nat {
              if (k < Array.size(currentCluster)) { currentCluster[k] } else { j }
            });
            currentCluster := newCluster;
            visited[j] := true;
          };
        };
        
        // Add to clusters - simplified
        if (Array.size(currentCluster) > 0) {
          sync.numClusters := Array.size(clusters) + 1;
        };
      };
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CROSS-FREQUENCY COUPLING — THETA-GAMMA NESTING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Cross-frequency coupling (CFC) coordinates processing across time scales:
  //
  // 1. PHASE-AMPLITUDE COUPLING (PAC): Theta phase modulates gamma amplitude
  // 2. PHASE-PHASE COUPLING (PPC): n:m phase locking
  // 3. AMPLITUDE-AMPLITUDE COUPLING (AAC): Envelope correlations
  //
  // The organism uses CFC for:
  // - Working memory (theta-gamma)
  // - Attention (alpha-gamma)
  // - Binding (theta nested in delta)
  //

  public type CrossFrequencyCoupling = {
    var phaseAmplitude : [[var Float]];  // PAC matrix
    var phasePhase : [[var Float]];      // PPC matrix
    var amplitudeAmplitude : [[var Float]]; // AAC matrix
    var modulationIndex : [[var Float]]; // Modulation strength
    var preferredPhase : [[var Float]];  // Preferred coupling phase
    var couplingStrength : Float;        // Overall CFC strength
    var thetaGammaCoupling : Float;      // Primary theta-gamma
    var alphaBetaCoupling : Float;       // Alpha-beta coupling
    var deltaEnvelope : Float;           // Delta envelope modulation
  };

  public type FrequencyBand = {
    var centerFreq : Float;              // Center frequency
    var bandwidth : Float;               // Band width
    var power : Float;                   // Current power
    var phase : Float;                   // Current phase
    var amplitude : Float;               // Envelope amplitude
    var phaseVelocity : Float;           // d(phase)/dt
  };

  public type NestedOscillations = {
    var delta : FrequencyBand;           // 0.5-4 Hz
    var theta : FrequencyBand;           // 4-8 Hz
    var alpha : FrequencyBand;           // 8-12 Hz
    var beta : FrequencyBand;            // 12-30 Hz
    var gammaLow : FrequencyBand;        // 30-60 Hz
    var gammaHigh : FrequencyBand;       // 60-100 Hz
    var nestingDepth : Nat;              // Levels of nesting
    var workingMemoryItems : Nat;        // Gamma cycles per theta
    var bindingStrength : Float;         // Cross-band binding
  };

  public func initCrossFrequencyCoupling() : CrossFrequencyCoupling {
    let n = 12;
    
    let pac = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let ppc = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let aac = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let mi = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let prefPhase = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var phaseAmplitude = pac;
      var phasePhase = ppc;
      var amplitudeAmplitude = aac;
      var modulationIndex = mi;
      var preferredPhase = prefPhase;
      var couplingStrength = 0.0;
      var thetaGammaCoupling = 0.0;
      var alphaBetaCoupling = 0.0;
      var deltaEnvelope = 0.0;
    }
  };

  public func initFrequencyBand(center : Float, bw : Float) : FrequencyBand {
    {
      var centerFreq = center;
      var bandwidth = bw;
      var power = 0.0;
      var phase = 0.0;
      var amplitude = 1.0;
      var phaseVelocity = TWO_PI * center;
    }
  };

  public func initNestedOscillations() : NestedOscillations {
    {
      var delta = initFrequencyBand(2.0, 3.0);
      var theta = initFrequencyBand(6.0, 4.0);
      var alpha = initFrequencyBand(10.0, 4.0);
      var beta = initFrequencyBand(20.0, 18.0);
      var gammaLow = initFrequencyBand(45.0, 30.0);
      var gammaHigh = initFrequencyBand(80.0, 40.0);
      var nestingDepth = 3;
      var workingMemoryItems = 7;
      var bindingStrength = 0.5;
    }
  };

  // Compute modulation index (Tort et al. method)
  public func computeModulationIndex(
    lowPhases : [Float],       // Phase time series of low frequency
    highAmplitudes : [Float],  // Amplitude time series of high frequency
    numBins : Nat
  ) : Float {
    if (Array.size(lowPhases) == 0 or Array.size(highAmplitudes) == 0) { return 0.0 };
    
    let n = Nat.min(Array.size(lowPhases), Array.size(highAmplitudes));
    
    // Bin amplitudes by phase
    let binCounts = Array.init<Nat>(numBins, func(_ : Nat) : Nat { 0 });
    let binSums = Array.init<Float>(numBins, func(_ : Nat) : Float { 0.0 });
    
    for (t in Iter.range(0, n - 1)) {
      // Determine phase bin
      var phase = lowPhases[t];
      while (phase < 0.0) { phase += TWO_PI };
      while (phase >= TWO_PI) { phase -= TWO_PI };
      
      let binIdx = Int.abs(Float.toInt(phase / TWO_PI * Float.fromInt(numBins))) % numBins;
      binCounts[binIdx] += 1;
      binSums[binIdx] += highAmplitudes[t];
    };
    
    // Compute mean amplitude per bin
    let binMeans = Array.tabulate<Float>(numBins, func(i : Nat) : Float {
      if (binCounts[i] > 0) { binSums[i] / Float.fromInt(binCounts[i]) } else { 0.0 }
    });
    
    // Normalize to probability distribution
    var totalAmp : Float = 0.0;
    for (m in binMeans.vals()) { totalAmp += m };
    
    if (totalAmp == 0.0) { return 0.0 };
    
    let p = Array.tabulate<Float>(numBins, func(i : Nat) : Float {
      binMeans[i] / totalAmp
    });
    
    // Compute entropy
    var entropy : Float = 0.0;
    for (pi in p.vals()) {
      if (pi > 0.0) {
        entropy -= pi * ln(pi);
      };
    };
    
    // Max entropy for uniform distribution
    let maxEntropy = ln(Float.fromInt(numBins));
    
    // Modulation index = (maxH - H) / maxH
    if (maxEntropy > 0.0) {
      (maxEntropy - entropy) / maxEntropy
    } else {
      0.0
    }
  };

  // Update cross-frequency coupling
  public func updateCFC(
    cfc : CrossFrequencyCoupling,
    nested : NestedOscillations,
    phases : [var Float],
    amplitudes : [var Float],
    dt : Float
  ) {
    let n = 12;
    
    // Update frequency bands
    nested.theta.phase += nested.theta.phaseVelocity * dt / 1000.0;
    if (nested.theta.phase > TWO_PI) { nested.theta.phase -= TWO_PI };
    
    nested.gammaLow.phase += nested.gammaLow.phaseVelocity * dt / 1000.0;
    if (nested.gammaLow.phase > TWO_PI) { nested.gammaLow.phase -= TWO_PI };
    
    // Theta-gamma coupling: gamma amplitude modulated by theta phase
    // Peak gamma at theta trough (optimal for memory)
    let thetaPhaseForGamma = nested.theta.phase;
    let gammaModulation = 1.0 + 0.5 * cos(thetaPhaseForGamma + PI);  // Peak at trough
    nested.gammaLow.amplitude := gammaModulation;
    
    cfc.thetaGammaCoupling := gammaModulation;
    
    // Working memory items = gamma cycles per theta cycle
    // ~7 items (magical number 7±2)
    let thetaPeriod = 1000.0 / nested.theta.centerFreq;  // ms
    let gammaPeriod = 1000.0 / nested.gammaLow.centerFreq;  // ms
    nested.workingMemoryItems := Int.abs(Float.toInt(thetaPeriod / gammaPeriod));
    
    // Alpha-beta coupling for attention
    nested.alpha.phase += nested.alpha.phaseVelocity * dt / 1000.0;
    if (nested.alpha.phase > TWO_PI) { nested.alpha.phase -= TWO_PI };
    
    let alphaModulation = cos(nested.alpha.phase);
    cfc.alphaBetaCoupling := alphaModulation;
    
    // Delta envelope for global coordination
    nested.delta.phase += nested.delta.phaseVelocity * dt / 1000.0;
    if (nested.delta.phase > TWO_PI) { nested.delta.phase -= TWO_PI };
    
    cfc.deltaEnvelope := 0.5 + 0.5 * cos(nested.delta.phase);
    
    // Update PAC matrix
    // Low frequency nodes (0-5) modulate high frequency nodes (6-11)
    for (low in Iter.range(0, 5)) {
      for (high in Iter.range(6, 11)) {
        let phaseModulation = cos(phases[low]);
        cfc.phaseAmplitude[low][high] := phaseModulation * amplitudes[high];
        
        // Preferred phase tracking
        if (cfc.phaseAmplitude[low][high] > 0.5) {
          cfc.preferredPhase[low][high] := phases[low];
        };
      };
    };
    
    // Overall coupling strength
    var totalCoupling : Float = 0.0;
    for (low in Iter.range(0, 5)) {
      for (high in Iter.range(6, 11)) {
        totalCoupling += Float.abs(cfc.phaseAmplitude[low][high]);
      };
    };
    cfc.couplingStrength := totalCoupling / 36.0;  // Normalize by number of pairs
    
    // Binding strength from nested oscillations
    nested.bindingStrength := cfc.thetaGammaCoupling * cfc.deltaEnvelope;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INFORMATION FLOW — TRANSFER ENTROPY AND GRANGER CAUSALITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Information flow measures direction of influence between oscillators:
  //
  // 1. TRANSFER ENTROPY: T_{X→Y} = H(Y_t | Y_{t-1:t-k}) - H(Y_t | Y_{t-1:t-k}, X_{t-1:t-k})
  // 2. GRANGER CAUSALITY: X causes Y if past of X helps predict Y
  // 3. DIRECTED PHASE LAG INDEX: Directional connectivity
  // 4. PHASE SLOPE INDEX: Robust to volume conduction
  //

  public type InformationFlowState = {
    var transferEntropy : [[var Float]];  // TE matrix (directed)
    var grangerCausality : [[var Float]]; // GC matrix
    var directedPLI : [[var Float]];      // dPLI matrix
    var phaseSlopeIndex : [[var Float]];  // PSI matrix
    var netFlow : [var Float];            // Net information flow per node
    var totalFlow : Float;                // Total system flow
    var flowDirection : Text;             // Dominant direction
    var integrationLevel : Float;         // System integration
    var segregationLevel : Float;         // System segregation
  };

  public func initInformationFlowState() : InformationFlowState {
    let n = 12;
    
    let te = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let gc = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let dpli = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let psi = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    let netFlow = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
    
    {
      var transferEntropy = te;
      var grangerCausality = gc;
      var directedPLI = dpli;
      var phaseSlopeIndex = psi;
      var netFlow = netFlow;
      var totalFlow = 0.0;
      var flowDirection = "balanced";
      var integrationLevel = 0.0;
      var segregationLevel = 0.0;
    }
  };

  // Estimate transfer entropy (simplified)
  public func estimateTransferEntropy(
    sourceHistory : [Float],
    targetHistory : [Float],
    lag : Nat
  ) : Float {
    if (Array.size(sourceHistory) <= lag or Array.size(targetHistory) <= lag) { return 0.0 };
    
    let n = Nat.min(Array.size(sourceHistory), Array.size(targetHistory)) - lag;
    if (n == 0) { return 0.0 };
    
    // Simplified TE estimation using correlation-based proxy
    // Real TE requires probability estimation
    
    var sumXY : Float = 0.0;
    var sumXX : Float = 0.0;
    var sumYY : Float = 0.0;
    
    for (t in Iter.range(lag, n + lag - 1)) {
      let x = sourceHistory[t - lag];
      let y = targetHistory[t];
      sumXY += x * y;
      sumXX += x * x;
      sumYY += y * y;
    };
    
    let denominator = sqrt(sumXX * sumYY);
    if (denominator == 0.0) { return 0.0 };
    
    let correlation = sumXY / denominator;
    
    // Convert to pseudo-TE (correlation → mutual information approximation)
    let r2 = correlation * correlation;
    if (r2 >= 1.0) { return 0.0 };
    
    -0.5 * ln(1.0 - r2)
  };

  // Compute directed Phase Lag Index
  public func computeDirectedPLI(
    phaseHistory : [[Float]],
    i : Nat,
    j : Nat
  ) : Float {
    if (Array.size(phaseHistory) < 2) { return 0.0 };
    
    var positiveLeading : Nat = 0;
    var negativeLeading : Nat = 0;
    
    for (t in Iter.range(1, Array.size(phaseHistory) - 1)) {
      if (i < Array.size(phaseHistory[t]) and j < Array.size(phaseHistory[t])) {
        let phaseDiff = phaseHistory[t][i] - phaseHistory[t][j];
        let prevDiff = phaseHistory[t-1][i] - phaseHistory[t-1][j];
        
        // Check if i is leading (positive derivative of phase difference)
        if (sin(phaseDiff) - sin(prevDiff) > 0.0) {
          positiveLeading += 1;
        } else if (sin(phaseDiff) - sin(prevDiff) < 0.0) {
          negativeLeading += 1;
        };
      };
    };
    
    let total = Float.fromInt(positiveLeading + negativeLeading);
    if (total == 0.0) { return 0.0 };
    
    (Float.fromInt(positiveLeading) - Float.fromInt(negativeLeading)) / total
  };

  // Update information flow
  public func updateInformationFlow(
    flow : InformationFlowState,
    phaseHistory : [[Float]],
    amplitudeHistory : [[Float]]
  ) {
    let n = 12;
    let lag = 5;  // Time lag for TE
    
    // Compute pairwise measures
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          // Extract time series
          let sourcePhases = Array.tabulate<Float>(Array.size(phaseHistory), func(t : Nat) : Float {
            if (i < Array.size(phaseHistory[t])) { phaseHistory[t][i] } else { 0.0 }
          });
          let targetPhases = Array.tabulate<Float>(Array.size(phaseHistory), func(t : Nat) : Float {
            if (j < Array.size(phaseHistory[t])) { phaseHistory[t][j] } else { 0.0 }
          });
          
          // Transfer entropy i → j
          flow.transferEntropy[i][j] := estimateTransferEntropy(sourcePhases, targetPhases, lag);
          
          // Directed PLI
          flow.directedPLI[i][j] := computeDirectedPLI(phaseHistory, i, j);
        };
      };
    };
    
    // Compute net flow per node
    for (i in Iter.range(0, n - 1)) {
      var outFlow : Float = 0.0;
      var inFlow : Float = 0.0;
      
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          outFlow += flow.transferEntropy[i][j];
          inFlow += flow.transferEntropy[j][i];
        };
      };
      
      flow.netFlow[i] := outFlow - inFlow;
    };
    
    // Total flow
    var totalOut : Float = 0.0;
    var totalIn : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (flow.netFlow[i] > 0.0) { totalOut += flow.netFlow[i] }
      else { totalIn -= flow.netFlow[i] };
    };
    flow.totalFlow := (totalOut + totalIn) / 2.0;
    
    // Determine dominant direction
    // Body (0-3) → Brain (8-11) = bottom-up
    // Brain (8-11) → Body (0-3) = top-down
    var bottomUp : Float = 0.0;
    var topDown : Float = 0.0;
    
    for (body in Iter.range(0, 3)) {
      for (brain in Iter.range(8, 11)) {
        bottomUp += flow.transferEntropy[body][brain];
        topDown += flow.transferEntropy[brain][body];
      };
    };
    
    if (bottomUp > topDown * 1.2) {
      flow.flowDirection := "bottom-up";
    } else if (topDown > bottomUp * 1.2) {
      flow.flowDirection := "top-down";
    } else {
      flow.flowDirection := "balanced";
    };
    
    // Integration and segregation
    var withinGroupFlow : Float = 0.0;
    var betweenGroupFlow : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let iGroup = i / 4;
          let jGroup = j / 4;
          
          if (iGroup == jGroup) {
            withinGroupFlow += flow.transferEntropy[i][j];
          } else {
            betweenGroupFlow += flow.transferEntropy[i][j];
          };
        };
      };
    };
    
    let totalGroupFlow = withinGroupFlow + betweenGroupFlow;
    if (totalGroupFlow > 0.0) {
      flow.segregationLevel := withinGroupFlow / totalGroupFlow;
      flow.integrationLevel := betweenGroupFlow / totalGroupFlow;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ATTRACTOR DYNAMICS — FIXED POINTS AND LIMIT CYCLES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The neural substrate exhibits complex attractor dynamics:
  //
  // 1. FIXED POINTS: Stable states (synchronized, incoherent)
  // 2. LIMIT CYCLES: Oscillatory attractors
  // 3. STRANGE ATTRACTORS: Chaotic dynamics
  // 4. METASTABLE STATES: Transient attractors
  //

  public type AttractorState = {
    var attractorType : Text;            // "fixed", "limit_cycle", "strange", "metastable"
    var fixedPoints : [[var Float]];     // Known fixed points in phase space
    var numFixedPoints : Nat;
    var currentBasin : Nat;              // Which basin we're in
    var basinStability : Float;          // How stable is current basin
    var escapeRate : Float;              // Rate of basin transitions
    var lyapunovExponent : Float;        // Chaos indicator
    var fractalDimension : Float;        // Attractor dimensionality
    var recurrenceRate : Float;          // Recurrence quantification
  };

  public type DynamicalLandscape = {
    attractor : AttractorState;
    var potentialEnergy : [[var Float]]; // Energy landscape
    var landscapeSize : Nat;
    var currentPosition : (Float, Float);// Position in landscape
    var gradientX : Float;               // Energy gradient
    var gradientY : Float;
    var noiseLevel : Float;              // Stochastic perturbations
    var barrierHeight : Float;           // Transition barrier
    var transitionProbability : Float;   // P(transition)
  };

  public func initAttractorState() : AttractorState {
    let fp = Array.init<[var Float]>(5, func(_ : Nat) : [var Float] {
      Array.init<Float>(12, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var attractorType = "metastable";
      var fixedPoints = fp;
      var numFixedPoints = 2;  // Synchronized and incoherent
      var currentBasin = 0;
      var basinStability = 0.5;
      var escapeRate = 0.01;
      var lyapunovExponent = 0.0;
      var fractalDimension = 1.0;
      var recurrenceRate = 0.0;
    }
  };

  public func initDynamicalLandscape() : DynamicalLandscape {
    let n = 20;  // Resolution
    
    let potential = Array.init<[var Float]>(n, func(i : Nat) : [var Float] {
      Array.init<Float>(n, func(j : Nat) : Float {
        // Double-well potential
        let x = Float.fromInt(i) / Float.fromInt(n) - 0.5;
        let y = Float.fromInt(j) / Float.fromInt(n) - 0.5;
        let r2 = x * x + y * y;
        r2 * r2 - 0.5 * r2 + 0.1  // Mexican hat
      })
    });
    
    {
      attractor = initAttractorState();
      var potentialEnergy = potential;
      var landscapeSize = n;
      var currentPosition = (0.5, 0.5);
      var gradientX = 0.0;
      var gradientY = 0.0;
      var noiseLevel = 0.1;
      var barrierHeight = 0.5;
      var transitionProbability = 0.0;
    }
  };

  // Estimate Lyapunov exponent
  public func estimateLyapunovExponent(
    trajectory : [[Float]],
    perturbationSize : Float
  ) : Float {
    if (Array.size(trajectory) < 10) { return 0.0 };
    
    var totalExpansion : Float = 0.0;
    var count : Nat = 0;
    
    // Compare nearby trajectory points
    for (t in Iter.range(0, Array.size(trajectory) - 2)) {
      let state1 = trajectory[t];
      let state2 = trajectory[t + 1];
      
      // Compute distance change
      var dist1 : Float = 0.0;
      var dist2 : Float = 0.0;
      
      let dim = Nat.min(Array.size(state1), Array.size(state2));
      for (i in Iter.range(0, dim - 1)) {
        let d1 = if (i < Array.size(state1)) { state1[i] } else { 0.0 };
        let d2 = if (i < Array.size(state2)) { state2[i] } else { 0.0 };
        dist1 += d1 * d1;
        dist2 += d2 * d2;
      };
      
      dist1 := sqrt(dist1);
      dist2 := sqrt(dist2);
      
      if (dist1 > perturbationSize) {
        let expansionRate = ln(dist2 / dist1);
        totalExpansion += expansionRate;
        count += 1;
      };
    };
    
    if (count > 0) { totalExpansion / Float.fromInt(count) } else { 0.0 }
  };

  // Detect attractor type
  public func detectAttractorType(
    attractor : AttractorState,
    orderParameter : Float,
    orderVariance : Float,
    lyapunov : Float
  ) {
    attractor.lyapunovExponent := lyapunov;
    
    // Classify based on dynamics
    if (orderVariance < 0.01) {
      // Low variance → stable
      if (orderParameter > 0.8) {
        attractor.attractorType := "fixed";  // Synchronized
        attractor.currentBasin := 0;
        attractor.basinStability := 0.9;
      } else if (orderParameter < 0.2) {
        attractor.attractorType := "fixed";  // Incoherent
        attractor.currentBasin := 1;
        attractor.basinStability := 0.9;
      };
    } else if (orderVariance > 0.1) {
      // High variance
      if (lyapunov > 0.0) {
        attractor.attractorType := "strange";  // Chaotic
        attractor.basinStability := 0.1;
        attractor.fractalDimension := 1.0 + lyapunov;
      } else {
        attractor.attractorType := "limit_cycle";  // Oscillatory
        attractor.basinStability := 0.5;
      };
    } else {
      // Medium variance → metastable
      attractor.attractorType := "metastable";
      attractor.basinStability := 0.3;
      attractor.escapeRate := orderVariance;
    };
  };

  // Update dynamical landscape
  public func updateDynamicalLandscape(
    landscape : DynamicalLandscape,
    phases : [var Float],
    orderParameter : Float,
    dt : Float
  ) {
    // Map current state to landscape position
    let (r, psi) = computeGlobalOrderParameter(phases);
    landscape.currentPosition := (r, psi / TWO_PI);
    
    // Compute energy gradient
    let (x, y) = landscape.currentPosition;
    let n = landscape.landscapeSize;
    let ix = Int.abs(Float.toInt(x * Float.fromInt(n))) % n;
    let iy = Int.abs(Float.toInt(y * Float.fromInt(n))) % n;
    
    // Gradient from finite differences
    let ixp = (ix + 1) % n;
    let ixm = (ix + n - 1) % n;
    let iyp = (iy + 1) % n;
    let iym = (iy + n - 1) % n;
    
    landscape.gradientX := (landscape.potentialEnergy[ixp][iy] - landscape.potentialEnergy[ixm][iy]) / 2.0;
    landscape.gradientY := (landscape.potentialEnergy[ix][iyp] - landscape.potentialEnergy[ix][iym]) / 2.0;
    
    // Barrier height estimation
    let currentEnergy = landscape.potentialEnergy[ix][iy];
    var maxNeighborEnergy : Float = currentEnergy;
    
    for (di in Iter.range(-1, 1)) {
      for (dj in Iter.range(-1, 1)) {
        let ni = (ix + di + n) % n;
        let nj = (iy + dj + n) % n;
        if (landscape.potentialEnergy[ni][nj] > maxNeighborEnergy) {
          maxNeighborEnergy := landscape.potentialEnergy[ni][nj];
        };
      };
    };
    landscape.barrierHeight := maxNeighborEnergy - currentEnergy;
    
    // Kramers transition probability
    // P ∝ exp(-barrier / noise)
    if (landscape.noiseLevel > 0.0) {
      landscape.transitionProbability := exp(-landscape.barrierHeight / landscape.noiseLevel);
    } else {
      landscape.transitionProbability := 0.0;
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // BIFURCATION DETECTION — CRITICAL TRANSITIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Detecting when the system approaches critical transitions:
  //
  // 1. CRITICAL SLOWING DOWN: Increased autocorrelation near bifurcation
  // 2. INCREASED VARIANCE: Fluctuations grow near transition
  // 3. FLICKERING: Oscillation between states
  // 4. EARLY WARNING SIGNALS: Predictive indicators
  //

  public type BifurcationState = {
    var autocorrelation : Float;         // AC(lag=1)
    var variance : Float;                // Variance of order parameter
    var skewness : Float;                // Asymmetry indicator
    var kurtosis : Float;                // Heavy tails indicator
    var criticalSlowing : Float;         // CSD measure
    var flickeringIndex : Float;         // Bimodality measure
    var distanceToCritical : Float;      // Estimated distance to transition
    var earlyWarning : Bool;             // Early warning detected?
    var bifurcationType : Text;          // "saddle-node", "hopf", "pitchfork"
    var controlParameter : Float;        // Parameter approaching critical value
    var criticalValue : Float;           // Estimated critical point
  };

  public type CriticalTransition = {
    bifurcation : BifurcationState;
    var windowSize : Nat;                // Analysis window
    var orderHistory : [var Float];      // Order parameter history
    var historyIdx : Nat;                // Circular buffer index
    var trendSlope : Float;              // Trend in early warning signals
    var confidenceLevel : Float;         // Confidence in prediction
    var timeToTransition : Float;        // Estimated time to critical point
    var lastTransitionTime : Float;      // When last transition occurred
    var transitionCount : Nat;           // Number of transitions observed
  };

  public func initBifurcationState() : BifurcationState {
    {
      var autocorrelation = 0.0;
      var variance = 0.0;
      var skewness = 0.0;
      var kurtosis = 0.0;
      var criticalSlowing = 0.0;
      var flickeringIndex = 0.0;
      var distanceToCritical = 1.0;
      var earlyWarning = false;
      var bifurcationType = "unknown";
      var controlParameter = 0.0;
      var criticalValue = 0.0;
    }
  };

  public func initCriticalTransition(windowSize : Nat) : CriticalTransition {
    {
      bifurcation = initBifurcationState();
      var windowSize = windowSize;
      var orderHistory = Array.init<Float>(windowSize, func(_ : Nat) : Float { 0.5 });
      var historyIdx = 0;
      var trendSlope = 0.0;
      var confidenceLevel = 0.0;
      var timeToTransition = 1000000.0;
      var lastTransitionTime = 0.0;
      var transitionCount = 0;
    }
  };

  // Compute autocorrelation at lag 1
  public func computeAutocorrelation(history : [var Float], currentIdx : Nat, windowSize : Nat) : Float {
    if (windowSize < 3) { return 0.0 };
    
    // Compute mean
    var mean : Float = 0.0;
    for (i in Iter.range(0, windowSize - 1)) {
      mean += history[i];
    };
    mean /= Float.fromInt(windowSize);
    
    // Compute variance and covariance
    var variance : Float = 0.0;
    var covariance : Float = 0.0;
    
    for (i in Iter.range(0, windowSize - 2)) {
      let idx1 = (currentIdx + i) % windowSize;
      let idx2 = (currentIdx + i + 1) % windowSize;
      
      let x1 = history[idx1] - mean;
      let x2 = history[idx2] - mean;
      
      variance += x1 * x1;
      covariance += x1 * x2;
    };
    
    if (variance == 0.0) { return 0.0 };
    
    covariance / variance
  };

  // Compute variance
  public func computeVariance(history : [var Float], windowSize : Nat) : Float {
    var mean : Float = 0.0;
    for (i in Iter.range(0, windowSize - 1)) {
      mean += history[i];
    };
    mean /= Float.fromInt(windowSize);
    
    var variance : Float = 0.0;
    for (i in Iter.range(0, windowSize - 1)) {
      let diff = history[i] - mean;
      variance += diff * diff;
    };
    
    variance / Float.fromInt(windowSize)
  };

  // Compute skewness
  public func computeSkewness(history : [var Float], windowSize : Nat, mean : Float, variance : Float) : Float {
    if (variance == 0.0) { return 0.0 };
    
    let std = sqrt(variance);
    var m3 : Float = 0.0;
    
    for (i in Iter.range(0, windowSize - 1)) {
      let z = (history[i] - mean) / std;
      m3 += z * z * z;
    };
    
    m3 / Float.fromInt(windowSize)
  };

  // Compute kurtosis
  public func computeKurtosis(history : [var Float], windowSize : Nat, mean : Float, variance : Float) : Float {
    if (variance == 0.0) { return 0.0 };
    
    let std = sqrt(variance);
    var m4 : Float = 0.0;
    
    for (i in Iter.range(0, windowSize - 1)) {
      let z = (history[i] - mean) / std;
      m4 += z * z * z * z;
    };
    
    m4 / Float.fromInt(windowSize) - 3.0  // Excess kurtosis
  };

  // Detect flickering (bimodality)
  public func detectFlickering(history : [var Float], windowSize : Nat) : Float {
    // Simple bimodality test: check if distribution has two modes
    var lowCount : Nat = 0;
    var highCount : Nat = 0;
    var midCount : Nat = 0;
    
    for (i in Iter.range(0, windowSize - 1)) {
      if (history[i] < 0.35) { lowCount += 1 }
      else if (history[i] > 0.65) { highCount += 1 }
      else { midCount += 1 };
    };
    
    // Flickering index: high if bimodal (low mid count)
    let total = Float.fromInt(lowCount + highCount + midCount);
    if (total == 0.0) { return 0.0 };
    
    1.0 - Float.fromInt(midCount) / total
  };

  // Update bifurcation detection
  public func updateBifurcationDetection(
    trans : CriticalTransition,
    orderParameter : Float,
    currentTime : Float
  ) {
    let bif = trans.bifurcation;
    let ws = trans.windowSize;
    
    // Update history
    trans.orderHistory[trans.historyIdx] := orderParameter;
    trans.historyIdx := (trans.historyIdx + 1) % ws;
    
    // Compute statistics
    let ac = computeAutocorrelation(trans.orderHistory, trans.historyIdx, ws);
    let variance = computeVariance(trans.orderHistory, ws);
    
    // Compute mean for skewness/kurtosis
    var mean : Float = 0.0;
    for (i in Iter.range(0, ws - 1)) {
      mean += trans.orderHistory[i];
    };
    mean /= Float.fromInt(ws);
    
    bif.autocorrelation := ac;
    bif.variance := variance;
    bif.skewness := computeSkewness(trans.orderHistory, ws, mean, variance);
    bif.kurtosis := computeKurtosis(trans.orderHistory, ws, mean, variance);
    bif.flickeringIndex := detectFlickering(trans.orderHistory, ws);
    
    // Critical slowing down indicator
    // Combination of increased AC and increased variance
    bif.criticalSlowing := (ac + 1.0) / 2.0 * sqrt(variance);
    
    // Distance to critical
    // High AC + High variance → close to critical
    bif.distanceToCritical := 1.0 - bif.criticalSlowing;
    bif.distanceToCritical := clamp(bif.distanceToCritical, 0.0, 1.0);
    
    // Early warning detection
    bif.earlyWarning := bif.criticalSlowing > 0.5 or bif.flickeringIndex > 0.5;
    
    // Identify bifurcation type
    if (bif.flickeringIndex > 0.7) {
      bif.bifurcationType := "saddle-node";  // Bistability
    } else if (bif.skewness > 1.0 or bif.skewness < -1.0) {
      bif.bifurcationType := "pitchfork";  // Symmetry breaking
    } else if (variance > 0.1 and ac < 0.5) {
      bif.bifurcationType := "hopf";  // Oscillation onset
    } else {
      bif.bifurcationType := "unknown";
    };
    
    // Estimate time to transition
    if (bif.criticalSlowing > 0.1) {
      let rate = bif.criticalSlowing * 0.01;  // Rate of approach
      trans.timeToTransition := bif.distanceToCritical / rate;
    } else {
      trans.timeToTransition := 1000000.0;  // Far from transition
    };
    
    // Detect if transition just occurred
    if (bif.flickeringIndex > 0.8) {
      trans.lastTransitionTime := currentTime;
      trans.transitionCount += 1;
    };
    
    // Compute trend slope
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    var sumXY : Float = 0.0;
    var sumX2 : Float = 0.0;
    
    for (i in Iter.range(0, ws - 1)) {
      let x = Float.fromInt(i);
      let y = trans.orderHistory[(trans.historyIdx + i) % ws];
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
    };
    
    let n = Float.fromInt(ws);
    let denom = n * sumX2 - sumX * sumX;
    if (denom != 0.0) {
      trans.trendSlope := (n * sumXY - sumX * sumY) / denom;
    };
    
    // Confidence level
    if (bif.earlyWarning) {
      trans.confidenceLevel := (bif.criticalSlowing + bif.flickeringIndex) / 2.0;
    } else {
      trans.confidenceLevel := 0.0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // METASTABILITY — CHIMERA STATES AND FUNCTIONAL CONNECTIVITY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism operates in metastable states:
  //
  // 1. CHIMERA STATES: Coexistence of coherence and incoherence
  // 2. FUNCTIONAL CONNECTIVITY: Dynamic coupling patterns
  // 3. DYNAMIC FUNCTIONAL CONNECTIVITY (dFC): Time-varying FC
  // 4. TRANSIENT SYNCHRONIZATION: Brief periods of sync
  //

  public type ChimeraState = {
    var isChimera : Bool;                // Chimera detected?
    var coherentNodes : [var Bool];      // Which nodes are coherent
    var incoherentNodes : [var Bool];    // Which nodes are incoherent
    var coherentFraction : Float;        // Fraction coherent
    var chimeraIndex : Float;            // Strength of chimera
    var spatialCorrelation : Float;      // Spatial organization
    var temporalStability : Float;       // How long chimera lasts
    var chimeraType : Text;              // "breathing", "alternating", "stable"
  };

  public type FunctionalConnectivity = {
    var staticFC : [[var Float]];        // Time-averaged FC
    var dynamicFC : [[[var Float]]];     // Time-resolved FC
    var fcWindows : Nat;                 // Number of time windows
    var currentWindow : Nat;
    var fcVariability : [[var Float]];   // Variability of FC
    var moduleAssignment : [var Nat];    // Module membership
    var numModules : Nat;
    var modularity : Float;              // Q statistic
    var flexibilityIndex : [var Float];  // Node flexibility
  };

  public type MetastabilityState = {
    chimera : ChimeraState;
    fc : FunctionalConnectivity;
    var metastabilityIndex : Float;      // Global metastability
    var dwellTime : Float;               // Time in current state
    var switchingRate : Float;           // State switching frequency
    var stateRepertoire : Nat;           // Number of distinct states
    var currentStateIdx : Nat;           // Current metastable state
    var stateEntropyRate : Float;        // Rate of state entropy production
  };

  public func initChimeraState() : ChimeraState {
    {
      var isChimera = false;
      var coherentNodes = Array.init<Bool>(12, func(_ : Nat) : Bool { true });
      var incoherentNodes = Array.init<Bool>(12, func(_ : Nat) : Bool { false });
      var coherentFraction = 1.0;
      var chimeraIndex = 0.0;
      var spatialCorrelation = 0.0;
      var temporalStability = 0.0;
      var chimeraType = "none";
    }
  };

  public func initFunctionalConnectivity() : FunctionalConnectivity {
    let n = 12;
    let nWindows = 10;
    
    let sfc = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    let dfc = Array.init<[[var Float]]>(nWindows, func(_ : Nat) : [[var Float]] {
      Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
        Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
      })
    });
    
    let fcv = Array.init<[var Float]>(n, func(_ : Nat) : [var Float] {
      Array.init<Float>(n, func(_ : Nat) : Float { 0.0 })
    });
    
    let modules = Array.init<Nat>(n, func(i : Nat) : Nat { i / 4 });  // 3 modules
    let flex = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
    
    {
      var staticFC = sfc;
      var dynamicFC = dfc;
      var fcWindows = nWindows;
      var currentWindow = 0;
      var fcVariability = fcv;
      var moduleAssignment = modules;
      var numModules = 3;
      var modularity = 0.0;
      var flexibilityIndex = flex;
    }
  };

  public func initMetastabilityState() : MetastabilityState {
    {
      chimera = initChimeraState();
      fc = initFunctionalConnectivity();
      var metastabilityIndex = 0.0;
      var dwellTime = 0.0;
      var switchingRate = 0.0;
      var stateRepertoire = 1;
      var currentStateIdx = 0;
      var stateEntropyRate = 0.0;
    }
  };

  // Detect chimera state
  public func detectChimeraState(
    chimera : ChimeraState,
    phases : [var Float],
    localSync : [var Float],
    threshold : Float
  ) {
    let n = 12;
    var coherentCount : Nat = 0;
    var incoherentCount : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      if (localSync[i] > threshold) {
        chimera.coherentNodes[i] := true;
        chimera.incoherentNodes[i] := false;
        coherentCount += 1;
      } else {
        chimera.coherentNodes[i] := false;
        chimera.incoherentNodes[i] := true;
        incoherentCount += 1;
      };
    };
    
    chimera.coherentFraction := Float.fromInt(coherentCount) / Float.fromInt(n);
    
    // Chimera requires both coherent and incoherent nodes
    chimera.isChimera := coherentCount > 0 and incoherentCount > 0 and
                          coherentCount >= 3 and incoherentCount >= 3;
    
    // Chimera index: how asymmetric is the distribution
    if (chimera.isChimera) {
      chimera.chimeraIndex := 1.0 - Float.abs(chimera.coherentFraction - 0.5) * 2.0;
    } else {
      chimera.chimeraIndex := 0.0;
    };
    
    // Spatial correlation: are coherent/incoherent nodes clustered?
    var sameGroupCount : Nat = 0;
    var totalPairs : Nat = 0;
    
    for (i in Iter.range(0, n - 2)) {
      let iCoherent = chimera.coherentNodes[i];
      let jCoherent = chimera.coherentNodes[i + 1];
      if (iCoherent == jCoherent) { sameGroupCount += 1 };
      totalPairs += 1;
    };
    
    if (totalPairs > 0) {
      chimera.spatialCorrelation := Float.fromInt(sameGroupCount) / Float.fromInt(totalPairs);
    };
    
    // Classify chimera type
    if (chimera.isChimera) {
      if (chimera.chimeraIndex > 0.8) {
        chimera.chimeraType := "stable";
      } else if (chimera.temporalStability < 0.3) {
        chimera.chimeraType := "alternating";
      } else {
        chimera.chimeraType := "breathing";
      };
    } else {
      chimera.chimeraType := "none";
    };
  };

  // Update functional connectivity
  public func updateFunctionalConnectivity(
    fc : FunctionalConnectivity,
    phases : [var Float],
    history : [[Float]]
  ) {
    let n = 12;
    
    // Compute current FC from phase coherence
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let phaseDiff = phases[i] - phases[j];
          let coherence = cos(phaseDiff);
          
          // Update current window FC
          fc.dynamicFC[fc.currentWindow][i][j] := coherence;
        };
      };
    };
    
    // Advance window
    fc.currentWindow := (fc.currentWindow + 1) % fc.fcWindows;
    
    // Compute static FC (average over windows)
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        var sum : Float = 0.0;
        for (w in Iter.range(0, fc.fcWindows - 1)) {
          sum += fc.dynamicFC[w][i][j];
        };
        fc.staticFC[i][j] := sum / Float.fromInt(fc.fcWindows);
      };
    };
    
    // Compute FC variability
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        var variance : Float = 0.0;
        for (w in Iter.range(0, fc.fcWindows - 1)) {
          let diff = fc.dynamicFC[w][i][j] - fc.staticFC[i][j];
          variance += diff * diff;
        };
        fc.fcVariability[i][j] := sqrt(variance / Float.fromInt(fc.fcWindows));
      };
    };
    
    // Compute modularity
    var withinModule : Float = 0.0;
    var betweenModule : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        if (fc.moduleAssignment[i] == fc.moduleAssignment[j]) {
          withinModule += fc.staticFC[i][j];
        } else {
          betweenModule += fc.staticFC[i][j];
        };
      };
    };
    
    let totalFC = withinModule + betweenModule;
    if (totalFC > 0.0) {
      fc.modularity := (withinModule - betweenModule) / totalFC;
    };
    
    // Compute flexibility (how often node changes modules across time)
    for (i in Iter.range(0, n - 1)) {
      var changes : Nat = 0;
      var prevModule = fc.moduleAssignment[i];
      
      for (w in Iter.range(1, fc.fcWindows - 1)) {
        // Simplified: use strongest connection to determine module
        var strongestConnection : Float = 0.0;
        var strongestNeighbor : Nat = 0;
        
        for (j in Iter.range(0, n - 1)) {
          if (i != j and fc.dynamicFC[w][i][j] > strongestConnection) {
            strongestConnection := fc.dynamicFC[w][i][j];
            strongestNeighbor := j;
          };
        };
        
        let newModule = fc.moduleAssignment[strongestNeighbor];
        if (newModule != prevModule) { changes += 1 };
        prevModule := newModule;
      };
      
      fc.flexibilityIndex[i] := Float.fromInt(changes) / Float.fromInt(fc.fcWindows - 1);
    };
  };

  // Update metastability
  public func updateMetastability(
    meta : MetastabilityState,
    phases : [var Float],
    localSync : [var Float],
    history : [[Float]],
    dt : Float
  ) {
    // Detect chimera
    detectChimeraState(meta.chimera, phases, localSync, 0.5);
    
    // Update FC
    updateFunctionalConnectivity(meta.fc, phases, history);
    
    // Metastability index: variance of synchronization
    var syncSum : Float = 0.0;
    var syncSumSq : Float = 0.0;
    
    for (i in Iter.range(0, 11)) {
      syncSum += localSync[i];
      syncSumSq += localSync[i] * localSync[i];
    };
    
    let meanSync = syncSum / 12.0;
    let varSync = syncSumSq / 12.0 - meanSync * meanSync;
    meta.metastabilityIndex := varSync;
    
    // Dwell time (time in current state)
    if (meta.chimera.isChimera == (meta.currentStateIdx > 0)) {
      meta.dwellTime += dt;
    } else {
      meta.dwellTime := 0.0;
      meta.currentStateIdx := if (meta.chimera.isChimera) { 1 } else { 0 };
    };
    
    // State entropy rate
    // Higher metastability = higher entropy production
    meta.stateEntropyRate := meta.metastabilityIndex * 0.1;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NEURAL MASS MODELS — POPULATION DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural mass models describe population-level dynamics:
  //
  // 1. JANSEN-RIT: Cortical column model
  // 2. LILEY: Electroencephalographic model
  // 3. WILSON-COWAN: E-I population dynamics
  // 4. NEURAL FIELD: Continuous space model
  //

  public type JansenRitColumn = {
    var y0 : Float;                      // Pyramidal PSP
    var y1 : Float;                      // Excitatory interneuron PSP
    var y2 : Float;                      // Inhibitory interneuron PSP
    var y3 : Float;                      // Pyramidal derivative
    var y4 : Float;                      // Excitatory derivative
    var y5 : Float;                      // Inhibitory derivative
    var pInput : Float;                  // External input
    var cConnectivity : Float;           // Inter-column connectivity
    var eOutput : Float;                 // EEG output
    var firingRate : Float;              // Mean firing rate
  };

  public type NeuralMassNetwork = {
    var columns : [var JansenRitColumn]; // Array of columns
    var numColumns : Nat;
    var connectivity : [[var Float]];    // Inter-column connections
    var globalDelay : Float;             // Transmission delay
    var meanFieldActivity : Float;       // Mean field approximation
    var lfpPower : [var Float];          // Power spectrum
    var dominantFrequency : Float;       // Peak frequency
    var excitationInhibitionRatio : Float; // E/I balance
  };

  // Jansen-Rit parameters
  public let JR_A : Float = 3.25;        // mV
  public let JR_B : Float = 22.0;        // mV
  public let JR_a : Float = 100.0;       // 1/s (excitatory time constant)
  public let JR_b : Float = 50.0;        // 1/s (inhibitory time constant)
  public let JR_e0 : Float = 2.5;        // 1/s (half-max firing rate)
  public let JR_v0 : Float = 6.0;        // mV (PSP at half-max)
  public let JR_r : Float = 0.56;        // mV^-1 (steepness)
  public let JR_C : Float = 135.0;       // Connectivity constant
  public let JR_C1 : Float = 135.0;      // Pyramidal → excitatory
  public let JR_C2 : Float = 108.0;      // Excitatory → pyramidal
  public let JR_C3 : Float = 33.75;      // Pyramidal → inhibitory
  public let JR_C4 : Float = 33.75;      // Inhibitory → pyramidal

  public func initJansenRitColumn() : JansenRitColumn {
    {
      var y0 = 0.0;
      var y1 = 0.0;
      var y2 = 0.0;
      var y3 = 0.0;
      var y4 = 0.0;
      var y5 = 0.0;
      var pInput = 220.0;  // Mean input rate (Hz)
      var cConnectivity = 0.0;
      var eOutput = 0.0;
      var firingRate = 0.0;
    }
  };

  public func initNeuralMassNetwork(numColumns : Nat) : NeuralMassNetwork {
    let cols = Array.init<JansenRitColumn>(numColumns, func(_ : Nat) : JansenRitColumn {
      initJansenRitColumn()
    });
    
    let conn = Array.init<[var Float]>(numColumns, func(i : Nat) : [var Float] {
      Array.init<Float>(numColumns, func(j : Nat) : Float {
        if (i == j) { 0.0 }
        else if (Int.abs(i - j) == 1) { 0.5 }  // Nearest neighbor
        else { 0.1 }
      })
    });
    
    let lfp = Array.init<Float>(50, func(_ : Nat) : Float { 0.0 });  // Power spectrum
    
    {
      var columns = cols;
      var numColumns = numColumns;
      var connectivity = conn;
      var globalDelay = 10.0;  // ms
      var meanFieldActivity = 0.0;
      var lfpPower = lfp;
      var dominantFrequency = 10.0;  // Alpha
      var excitationInhibitionRatio = 1.0;
    }
  };

  // Sigmoid function for Jansen-Rit
  func jrSigmoid(v : Float) : Float {
    JR_e0 * 2.0 / (1.0 + exp(JR_r * (JR_v0 - v)))
  };

  // Update single Jansen-Rit column
  public func updateJansenRitColumn(
    col : JansenRitColumn,
    externalInput : Float,
    couplingInput : Float,
    dt : Float
  ) {
    let p = col.pInput + externalInput + couplingInput;
    
    // PSP difference for sigmoid input
    let v1 = col.y1 - col.y2;
    let v2 = JR_C2 * jrSigmoid(JR_C1 * col.y0);
    let v3 = JR_C4 * jrSigmoid(JR_C3 * col.y0);
    
    // Update derivatives (2nd order ODE → 2 first-order ODEs)
    let dy0 = col.y3;
    let dy1 = col.y4;
    let dy2 = col.y5;
    
    let dy3 = JR_A * JR_a * (jrSigmoid(v1)) - 2.0 * JR_a * col.y3 - JR_a * JR_a * col.y0;
    let dy4 = JR_A * JR_a * (p + v2) - 2.0 * JR_a * col.y4 - JR_a * JR_a * col.y1;
    let dy5 = JR_B * JR_b * v3 - 2.0 * JR_b * col.y5 - JR_b * JR_b * col.y2;
    
    // Euler integration
    let dtSec = dt / 1000.0;
    col.y0 += dy0 * dtSec;
    col.y1 += dy1 * dtSec;
    col.y2 += dy2 * dtSec;
    col.y3 += dy3 * dtSec;
    col.y4 += dy4 * dtSec;
    col.y5 += dy5 * dtSec;
    
    // EEG output = pyramidal PSP
    col.eOutput := col.y1 - col.y2;
    
    // Firing rate
    col.firingRate := jrSigmoid(col.eOutput);
  };

  // Update neural mass network
  public func updateNeuralMassNetwork(
    network : NeuralMassNetwork,
    externalInputs : [Float],
    dt : Float
  ) {
    let nc = network.numColumns;
    
    // Compute coupling inputs
    let couplingInputs = Array.tabulate<Float>(nc, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, nc - 1)) {
        if (i != j) {
          sum += network.connectivity[i][j] * network.columns[j].eOutput;
        };
      };
      sum
    });
    
    // Update each column
    var totalActivity : Float = 0.0;
    var totalExcitation : Float = 0.0;
    var totalInhibition : Float = 0.0;
    
    for (i in Iter.range(0, nc - 1)) {
      let extIn = if (i < Array.size(externalInputs)) { externalInputs[i] } else { 0.0 };
      updateJansenRitColumn(network.columns[i], extIn, couplingInputs[i], dt);
      
      totalActivity += network.columns[i].eOutput;
      totalExcitation += network.columns[i].y1;
      totalInhibition += network.columns[i].y2;
    };
    
    // Mean field
    network.meanFieldActivity := totalActivity / Float.fromInt(nc);
    
    // E/I ratio
    if (totalInhibition > 0.0) {
      network.excitationInhibitionRatio := totalExcitation / totalInhibition;
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // WILSON-COWAN DYNAMICS — EXCITATORY-INHIBITORY POPULATIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Wilson-Cowan model for E-I population dynamics:
  //
  //   τ_E dE/dt = -E + S_E(w_EE×E - w_IE×I + P)
  //   τ_I dI/dt = -I + S_I(w_EI×E - w_II×I + Q)
  //
  // Where S(x) = 1/(1 + exp(-a(x - θ))) is the sigmoid response function
  //

  public type WilsonCowanUnit = {
    var E : Float;                       // Excitatory activity
    var I : Float;                       // Inhibitory activity
    var wEE : Float;                     // E → E coupling
    var wEI : Float;                     // E → I coupling
    var wIE : Float;                     // I → E coupling
    var wII : Float;                     // I → I coupling
    var tauE : Float;                    // E time constant
    var tauI : Float;                    // I time constant
    var thetaE : Float;                  // E threshold
    var thetaI : Float;                  // I threshold
    var aE : Float;                      // E sigmoid steepness
    var aI : Float;                      // I sigmoid steepness
    var P : Float;                       // External input to E
    var Q : Float;                       // External input to I
  };

  public type WilsonCowanNetwork = {
    var units : [var WilsonCowanUnit];
    var numUnits : Nat;
    var spatialCoupling : [[var Float]];
    var globalE : Float;                 // Mean excitation
    var globalI : Float;                 // Mean inhibition
    var eiBalance : Float;               // E/I balance metric
    var oscillationFrequency : Float;    // Current oscillation
    var stabilityMargin : Float;         // Distance from instability
    var fixedPointE : Float;             // Equilibrium E
    var fixedPointI : Float;             // Equilibrium I
    var jacobianEigenvalue : Float;      // Largest eigenvalue
  };

  public func initWilsonCowanUnit() : WilsonCowanUnit {
    {
      var E = 0.1;
      var I = 0.1;
      var wEE = 12.0;
      var wEI = 10.0;
      var wIE = 10.0;
      var wII = 2.0;
      var tauE = 10.0;  // ms
      var tauI = 10.0;  // ms
      var thetaE = 4.0;
      var thetaI = 3.7;
      var aE = 1.3;
      var aI = 2.0;
      var P = 1.0;
      var Q = 1.0;
    }
  };

  public func initWilsonCowanNetwork(numUnits : Nat) : WilsonCowanNetwork {
    let units = Array.init<WilsonCowanUnit>(numUnits, func(_ : Nat) : WilsonCowanUnit {
      initWilsonCowanUnit()
    });
    
    let spatial = Array.init<[var Float]>(numUnits, func(i : Nat) : [var Float] {
      Array.init<Float>(numUnits, func(j : Nat) : Float {
        if (i == j) { 0.0 }
        else {
          let dist = Float.fromInt(Int.abs(i - j));
          exp(-dist * dist / 4.0)  // Gaussian decay
        }
      })
    });
    
    {
      var units = units;
      var numUnits = numUnits;
      var spatialCoupling = spatial;
      var globalE = 0.1;
      var globalI = 0.1;
      var eiBalance = 1.0;
      var oscillationFrequency = 0.0;
      var stabilityMargin = 0.0;
      var fixedPointE = 0.0;
      var fixedPointI = 0.0;
      var jacobianEigenvalue = 0.0;
    }
  };

  // Wilson-Cowan sigmoid
  func wcSigmoid(x : Float, a : Float, theta : Float) : Float {
    1.0 / (1.0 + exp(-a * (x - theta)))
  };

  // Update single Wilson-Cowan unit
  public func updateWilsonCowanUnit(
    unit : WilsonCowanUnit,
    couplingInput : Float,
    dt : Float
  ) {
    // Input to E population
    let inputE = unit.wEE * unit.E - unit.wIE * unit.I + unit.P + couplingInput;
    
    // Input to I population
    let inputI = unit.wEI * unit.E - unit.wII * unit.I + unit.Q;
    
    // Response functions
    let responseE = wcSigmoid(inputE, unit.aE, unit.thetaE);
    let responseI = wcSigmoid(inputI, unit.aI, unit.thetaI);
    
    // Dynamics
    let dE = (-unit.E + responseE) / unit.tauE;
    let dI = (-unit.I + responseI) / unit.tauI;
    
    // Update
    unit.E += dE * dt;
    unit.I += dI * dt;
    
    // Clamp
    unit.E := clamp(unit.E, 0.0, 1.0);
    unit.I := clamp(unit.I, 0.0, 1.0);
  };

  // Update Wilson-Cowan network
  public func updateWilsonCowanNetwork(
    network : WilsonCowanNetwork,
    externalInputs : [Float],
    dt : Float
  ) {
    let n = network.numUnits;
    
    // Compute spatial coupling
    let couplingInputs = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          sum += network.spatialCoupling[i][j] * network.units[j].E;
        };
      };
      sum
    });
    
    // Update units
    var totalE : Float = 0.0;
    var totalI : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      if (i < Array.size(externalInputs)) {
        network.units[i].P := externalInputs[i];
      };
      
      updateWilsonCowanUnit(network.units[i], couplingInputs[i], dt);
      
      totalE += network.units[i].E;
      totalI += network.units[i].I;
    };
    
    let prevE = network.globalE;
    network.globalE := totalE / Float.fromInt(n);
    network.globalI := totalI / Float.fromInt(n);
    
    // E/I balance
    if (network.globalI > 0.0) {
      network.eiBalance := network.globalE / network.globalI;
    };
    
    // Oscillation detection (from change in E)
    let dE = network.globalE - prevE;
    if (dt > 0.0) {
      let freq = Float.abs(dE) / dt * 1000.0;  // Approximate frequency
      network.oscillationFrequency := 0.9 * network.oscillationFrequency + 0.1 * freq;
    };
    
    // Fixed point analysis (simplified)
    // At fixed point: E* = S_E(w_EE×E* - w_IE×I* + P)
    let u = network.units[0];
    let inputE = u.wEE * network.globalE - u.wIE * network.globalI + u.P;
    let responseE = wcSigmoid(inputE, u.aE, u.thetaE);
    network.fixedPointE := responseE;
    
    let inputI = u.wEI * network.globalE - u.wII * network.globalI + u.Q;
    let responseI = wcSigmoid(inputI, u.aI, u.thetaI);
    network.fixedPointI := responseI;
    
    // Stability margin (distance from fixed point)
    let distE = Float.abs(network.globalE - network.fixedPointE);
    let distI = Float.abs(network.globalI - network.fixedPointI);
    network.stabilityMargin := 1.0 / (1.0 + distE + distI);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NEURAL FIELD THEORY — CONTINUOUS SPACE DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Amari neural field equations for spatially continuous dynamics:
  //
  //   τ ∂u(x,t)/∂t = -u(x,t) + ∫ w(x-y) f(u(y,t)) dy + I(x,t)
  //
  // Where w(x) is the connectivity kernel (Mexican hat, Gaussian, etc.)
  //

  public type NeuralFieldState = {
    var field : [var Float];             // Activity at each spatial point
    var fieldSize : Nat;                 // Number of spatial points
    var kernel : [var Float];            // Connectivity kernel
    var kernelRadius : Nat;              // Kernel half-width
    var tau : Float;                     // Time constant
    var threshold : Float;               // Firing threshold
    var steepness : Float;               // Sigmoid steepness
    var spatialScale : Float;            // Spatial resolution
    var temporalScale : Float;           // Temporal resolution
    var globalActivity : Float;          // Mean field activity
    var waveSpeed : Float;               // Traveling wave speed
    var bumpCount : Nat;                 // Number of activity bumps
    var bumpPositions : [var Float];     // Positions of activity peaks
  };

  public type TravelingWave = {
    var exists : Bool;
    var speed : Float;
    var direction : Float;               // 0 = right, π = left
    var width : Float;
    var amplitude : Float;
    var position : Float;                // Current position
    var frequency : Float;               // For periodic waves
    var waveType : Text;                 // "pulse", "front", "spiral", "bump"
  };

  public type PatternFormation = {
    wave : TravelingWave;
    var patterns : [[var Float]];        // Pattern library
    var numPatterns : Nat;
    var currentPattern : Nat;
    var patternSimilarity : Float;       // Match to known pattern
    var turingInstability : Bool;        // Spontaneous pattern?
    var symmetryBreaking : Bool;         // Symmetry broken?
    var bifurcationParameter : Float;    // Distance from instability
  };

  public func initNeuralFieldState(fieldSize : Nat, kernelRadius : Nat) : NeuralFieldState {
    let field = Array.init<Float>(fieldSize, func(_ : Nat) : Float { 0.0 });
    
    // Mexican hat kernel
    let kernel = Array.init<Float>(2 * kernelRadius + 1, func(i : Nat) : Float {
      let x = Float.fromInt(Int.abs(i - kernelRadius));
      let a = 1.0;   // Excitatory amplitude
      let b = 0.5;   // Inhibitory amplitude
      let sigmaE = 2.0;  // Excitatory width
      let sigmaI = 4.0;  // Inhibitory width
      
      a * exp(-x * x / (2.0 * sigmaE * sigmaE)) - 
      b * exp(-x * x / (2.0 * sigmaI * sigmaI))
    });
    
    let bumpPos = Array.init<Float>(5, func(_ : Nat) : Float { 0.0 });
    
    {
      var field = field;
      var fieldSize = fieldSize;
      var kernel = kernel;
      var kernelRadius = kernelRadius;
      var tau = 10.0;
      var threshold = 0.2;
      var steepness = 10.0;
      var spatialScale = 1.0;
      var temporalScale = 1.0;
      var globalActivity = 0.0;
      var waveSpeed = 0.0;
      var bumpCount = 0;
      var bumpPositions = bumpPos;
    }
  };

  public func initTravelingWave() : TravelingWave {
    {
      var exists = false;
      var speed = 0.0;
      var direction = 0.0;
      var width = 1.0;
      var amplitude = 0.0;
      var position = 0.0;
      var frequency = 0.0;
      var waveType = "none";
    }
  };

  public func initPatternFormation(numPatterns : Nat, fieldSize : Nat) : PatternFormation {
    let patterns = Array.init<[var Float]>(numPatterns, func(_ : Nat) : [var Float] {
      Array.init<Float>(fieldSize, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      wave = initTravelingWave();
      var patterns = patterns;
      var numPatterns = numPatterns;
      var currentPattern = 0;
      var patternSimilarity = 0.0;
      var turingInstability = false;
      var symmetryBreaking = false;
      var bifurcationParameter = 0.0;
    }
  };

  // Sigmoid for neural field
  func nfSigmoid(u : Float, theta : Float, beta : Float) : Float {
    1.0 / (1.0 + exp(-beta * (u - theta)))
  };

  // Convolution with kernel
  func convolve(field : [var Float], kernel : [var Float], idx : Nat, fieldSize : Nat, kernelRadius : Nat) : Float {
    var sum : Float = 0.0;
    
    for (k in Iter.range(0, 2 * kernelRadius)) {
      let fieldIdx = (idx + fieldSize + k - kernelRadius) % fieldSize;
      sum += kernel[k] * field[fieldIdx];
    };
    
    sum
  };

  // Update neural field
  public func updateNeuralField(
    state : NeuralFieldState,
    input : [Float],
    dt : Float
  ) {
    let n = state.fieldSize;
    let kr = state.kernelRadius;
    
    // Compute firing rates
    let firingRates = Array.tabulate<Float>(n, func(i : Nat) : Float {
      nfSigmoid(state.field[i], state.threshold, state.steepness)
    });
    
    // Compute activity change
    var totalActivity : Float = 0.0;
    var prevField = Array.tabulate<Float>(n, func(i : Nat) : Float { state.field[i] });
    
    for (i in Iter.range(0, n - 1)) {
      // Convolution
      var conv : Float = 0.0;
      for (k in Iter.range(0, 2 * kr)) {
        let fieldIdx = (i + n + k - kr) % n;
        conv += state.kernel[k] * firingRates[fieldIdx];
      };
      
      // External input
      let ext = if (i < Array.size(input)) { input[i] } else { 0.0 };
      
      // Dynamics
      let du = (-state.field[i] + conv + ext) / state.tau;
      state.field[i] += du * dt;
      
      totalActivity += state.field[i];
    };
    
    state.globalActivity := totalActivity / Float.fromInt(n);
    
    // Detect activity bumps
    var bumpCount : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      // Local maximum detection
      let prev = state.field[(i + n - 1) % n];
      let curr = state.field[i];
      let next = state.field[(i + 1) % n];
      
      if (curr > prev and curr > next and curr > state.threshold) {
        if (bumpCount < 5) {
          state.bumpPositions[bumpCount] := Float.fromInt(i);
        };
        bumpCount += 1;
      };
    };
    state.bumpCount := bumpCount;
    
    // Wave speed detection (from bump movement)
    if (bumpCount > 0) {
      let movement = state.field[Int.abs(Float.toInt(state.bumpPositions[0]))] - 
                     prevField[Int.abs(Float.toInt(state.bumpPositions[0]))];
      state.waveSpeed := Float.abs(movement) / dt;
    };
  };

  // Detect traveling wave
  public func detectTravelingWave(
    pattern : PatternFormation,
    field : [var Float],
    prevField : [Float],
    dt : Float
  ) {
    let wave = pattern.wave;
    let n = Array.size(field);
    
    // Compute velocity field
    var netMovement : Float = 0.0;
    var maxActivity : Float = 0.0;
    var peakIdx : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      let velocity = (field[i] - prevField[i]) / dt;
      netMovement += velocity;
      
      if (field[i] > maxActivity) {
        maxActivity := field[i];
        peakIdx := i;
      };
    };
    
    // Detect wave existence
    wave.exists := maxActivity > 0.5 and Float.abs(netMovement) > 0.01;
    
    if (wave.exists) {
      wave.amplitude := maxActivity;
      wave.position := Float.fromInt(peakIdx);
      
      // Wave direction from net movement
      if (netMovement > 0.0) {
        wave.direction := 0.0;  // Moving right
      } else {
        wave.direction := PI;   // Moving left
      };
      
      wave.speed := Float.abs(netMovement) * Float.fromInt(n);
      
      // Wave width (half-max points)
      var leftIdx = peakIdx;
      var rightIdx = peakIdx;
      let halfMax = maxActivity / 2.0;
      
      while (leftIdx > 0 and field[leftIdx] > halfMax) { leftIdx -= 1 };
      while (rightIdx < n - 1 and field[rightIdx] > halfMax) { rightIdx += 1 };
      
      wave.width := Float.fromInt(rightIdx - leftIdx);
      
      // Wave type classification
      if (wave.width < 5.0) {
        wave.waveType := "pulse";
      } else if (wave.width > Float.fromInt(n) / 2.0) {
        wave.waveType := "front";
      } else {
        wave.waveType := "bump";
      };
    } else {
      wave.waveType := "none";
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CRITICALITY — EDGE OF CHAOS DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism operates at criticality for optimal computation:
  //
  // 1. POWER LAW SCALING: Avalanche distributions follow P(s) ~ s^(-τ)
  // 2. BRANCHING RATIO: σ = 1 at criticality
  // 3. DYNAMIC RANGE: Maximized at critical point
  // 4. INFORMATION TRANSMISSION: Optimal at criticality
  //

  public type CriticalityState = {
    var branchingRatio : Float;          // σ = E[offspring] per avalanche
    var avalancheSizes : [var Nat];      // Recorded avalanche sizes
    var avalancheDurations : [var Nat];  // Recorded durations
    var numAvalanches : Nat;
    var powerLawExponent : Float;        // τ in P(s) ~ s^(-τ)
    var durationExponent : Float;        // α in P(d) ~ d^(-α)
    var dynamicRange : Float;            // Range of stimulus-response
    var susceptibility : Float;          // Response to perturbation
    var correlationLength : Float;       // Spatial correlation extent
    var criticalityIndex : Float;        // Distance from criticality
    var isNearCritical : Bool;           // True if σ ≈ 1
  };

  public type AvalancheDetector = {
    criticality : CriticalityState;
    var activeNodes : [var Bool];        // Currently active nodes
    var prevActiveNodes : [var Bool];    // Previously active
    var currentAvalancheSize : Nat;      // Size of current avalanche
    var currentAvalancheDuration : Nat;  // Duration of current
    var inAvalanche : Bool;              // Currently in avalanche?
    var avalancheHistory : [[var Nat]];  // Size, duration pairs
    var historyIdx : Nat;
    var historySize : Nat;
    var threshold : Float;               // Activation threshold
  };

  public func initCriticalityState() : CriticalityState {
    let sizes = Array.init<Nat>(100, func(_ : Nat) : Nat { 0 });
    let durations = Array.init<Nat>(100, func(_ : Nat) : Nat { 0 });
    
    {
      var branchingRatio = 1.0;
      var avalancheSizes = sizes;
      var avalancheDurations = durations;
      var numAvalanches = 0;
      var powerLawExponent = 1.5;  // Theory: τ ≈ 1.5 at criticality
      var durationExponent = 2.0;  // Theory: α ≈ 2.0 at criticality
      var dynamicRange = 0.0;
      var susceptibility = 0.0;
      var correlationLength = 0.0;
      var criticalityIndex = 0.0;
      var isNearCritical = false;
    }
  };

  public func initAvalancheDetector(numNodes : Nat, historySize : Nat) : AvalancheDetector {
    let active = Array.init<Bool>(numNodes, func(_ : Nat) : Bool { false });
    let prev = Array.init<Bool>(numNodes, func(_ : Nat) : Bool { false });
    
    let history = Array.init<[var Nat]>(historySize, func(_ : Nat) : [var Nat] {
      Array.init<Nat>(2, func(_ : Nat) : Nat { 0 })  // [size, duration]
    });
    
    {
      criticality = initCriticalityState();
      var activeNodes = active;
      var prevActiveNodes = prev;
      var currentAvalancheSize = 0;
      var currentAvalancheDuration = 0;
      var inAvalanche = false;
      var avalancheHistory = history;
      var historyIdx = 0;
      var historySize = historySize;
      var threshold = 0.5;
    }
  };

  // Update avalanche detection
  public func updateAvalancheDetector(
    detector : AvalancheDetector,
    activities : [Float]
  ) {
    let n = Array.size(activities);
    let crit = detector.criticality;
    
    // Update active nodes
    var currentActive : Nat = 0;
    var newActivations : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      let wasActive = detector.prevActiveNodes[i];
      let isActive = activities[i] > detector.threshold;
      
      detector.prevActiveNodes[i] := detector.activeNodes[i];
      detector.activeNodes[i] := isActive;
      
      if (isActive) { currentActive += 1 };
      if (isActive and not wasActive) { newActivations += 1 };
    };
    
    // Avalanche detection
    if (currentActive > 0) {
      if (not detector.inAvalanche) {
        // Start new avalanche
        detector.inAvalanche := true;
        detector.currentAvalancheSize := currentActive;
        detector.currentAvalancheDuration := 1;
      } else {
        // Continue avalanche
        detector.currentAvalancheSize += currentActive;
        detector.currentAvalancheDuration += 1;
      };
    } else if (detector.inAvalanche) {
      // End avalanche
      detector.inAvalanche := false;
      
      // Record in history
      if (detector.currentAvalancheSize > 0) {
        let idx = detector.historyIdx;
        detector.avalancheHistory[idx][0] := detector.currentAvalancheSize;
        detector.avalancheHistory[idx][1] := detector.currentAvalancheDuration;
        detector.historyIdx := (idx + 1) % detector.historySize;
        
        // Update criticality stats
        if (crit.numAvalanches < 100) {
          crit.avalancheSizes[crit.numAvalanches] := detector.currentAvalancheSize;
          crit.avalancheDurations[crit.numAvalanches] := detector.currentAvalancheDuration;
        };
        crit.numAvalanches += 1;
      };
      
      detector.currentAvalancheSize := 0;
      detector.currentAvalancheDuration := 0;
    };
    
    // Branching ratio (simplified)
    if (currentActive > 0) {
      var prevActive : Nat = 0;
      for (i in Iter.range(0, n - 1)) {
        if (detector.prevActiveNodes[i]) { prevActive += 1 };
      };
      
      if (prevActive > 0) {
        let ratio = Float.fromInt(currentActive) / Float.fromInt(prevActive);
        crit.branchingRatio := 0.9 * crit.branchingRatio + 0.1 * ratio;
      };
    };
    
    // Criticality assessment
    crit.criticalityIndex := Float.abs(crit.branchingRatio - 1.0);
    crit.isNearCritical := crit.criticalityIndex < 0.1;
    
    // Susceptibility (response variance)
    var sumActivity : Float = 0.0;
    var sumActivity2 : Float = 0.0;
    
    for (a in activities.vals()) {
      sumActivity += a;
      sumActivity2 += a * a;
    };
    
    let meanActivity = sumActivity / Float.fromInt(n);
    let varActivity = sumActivity2 / Float.fromInt(n) - meanActivity * meanActivity;
    crit.susceptibility := varActivity;
    
    // Dynamic range (logarithmic range of responses)
    var minResponse : Float = 1.0;
    var maxResponse : Float = 0.0;
    
    for (a in activities.vals()) {
      if (a > 0.0 and a < minResponse) { minResponse := a };
      if (a > maxResponse) { maxResponse := a };
    };
    
    if (minResponse > 0.0 and maxResponse > 0.0) {
      crit.dynamicRange := ln(maxResponse / minResponse) / ln(10.0);  // In decades
    };
  };

  // Estimate power law exponent
  public func estimatePowerLawExponent(sizes : [var Nat], numSamples : Nat) : Float {
    if (numSamples == 0) { return 1.5 };  // Default
    
    // Maximum likelihood estimation for discrete power law
    var sumLogS : Float = 0.0;
    var count : Nat = 0;
    
    for (i in Iter.range(0, Nat.min(numSamples, 100) - 1)) {
      let s = sizes[i];
      if (s > 0) {
        sumLogS += ln(Float.fromInt(s));
        count += 1;
      };
    };
    
    if (count == 0) { return 1.5 };
    
    let meanLogS = sumLogS / Float.fromInt(count);
    
    // Approximate exponent: τ ≈ 1 + n / (Σ ln(s))
    1.0 + Float.fromInt(count) / sumLogS
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SACRED GEOMETRY — PHI-BASED NEURAL ORGANIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism's neural substrate follows sacred geometry principles:
  //
  // 1. GOLDEN RATIO (φ): Coupling strengths scaled by φ, φ², φ³
  // 2. 144-NODE STRUCTURE: 12 Hz nodes × 12 layers
  // 3. 444 SACRED CONSTANT: Numerological foundation
  // 4. PLATONIC SOLIDS: Body(tetrahedron), Interface(cube), Brain(dodecahedron)
  //

  public type SacredGeometryState = {
    var phiHarmonic : Float;             // Current φ-harmonic
    var phi2Harmonic : Float;            // φ² harmonic
    var phi3Harmonic : Float;            // φ³ harmonic
    var sacredFloor : Float;             // φ/144 floor
    var heartbeatMultiple : Nat;         // Current beat mod 444
    var nodeCount : Nat;                 // 144 = 12 × 12
    var coherencePhiRatio : Float;       // Coherence / φ
    var bodyTetrahedronCoherence : Float;// Tetrahedron (nodes 0-3)
    var interfaceCubeCoherence : Float;  // Cube (nodes 4-7)
    var brainDodecaCoherence : Float;    // Dodecahedron (nodes 8-11)
    var sacredAlignment : Float;         // Overall sacred alignment
  };

  public type PhiSpiralState = {
    var spiralAngle : Float;             // Current angle on φ-spiral
    var spiralRadius : Float;            // Current radius
    var spiralGrowth : Float;            // Growth rate = φ
    var turnAngle : Float;               // 137.5° (golden angle)
    var phyllotaxisPattern : [var Float];// Sunflower-like arrangement
    var resonancePoints : [var Float];   // Points of maximum resonance
    var harmonicSeries : [var Float];    // φ^n series
    var fibonacciPhases : [var Nat];     // Fibonacci phase indices
  };

  public type PlatonicResonance = {
    var tetrahedronEnergy : Float;       // 4 vertices, 6 edges
    var cubeEnergy : Float;              // 8 vertices, 12 edges
    var octahedronEnergy : Float;        // 6 vertices, 12 edges
    var dodecahedronEnergy : Float;      // 20 vertices, 30 edges
    var icosahedronEnergy : Float;       // 12 vertices, 30 edges
    var totalPlatonicEnergy : Float;     // Sum
    var dominantSolid : Text;            // Which solid dominates
    var dualBalance : Float;             // Cube-Octahedron, Dodeca-Icosa balance
  };

  public func initSacredGeometryState() : SacredGeometryState {
    {
      var phiHarmonic = SACRED_PHI;
      var phi2Harmonic = SACRED_PHI_SQUARED;
      var phi3Harmonic = SACRED_PHI_CUBED;
      var sacredFloor = SACRED_FLOOR;
      var heartbeatMultiple = 0;
      var nodeCount = 144;
      var coherencePhiRatio = 0.0;
      var bodyTetrahedronCoherence = 0.0;
      var interfaceCubeCoherence = 0.0;
      var brainDodecaCoherence = 0.0;
      var sacredAlignment = 0.0;
    }
  };

  public func initPhiSpiralState() : PhiSpiralState {
    let goldenAngle = TWO_PI / (SACRED_PHI * SACRED_PHI);  // ≈ 137.5°
    
    let phyllotaxis = Array.init<Float>(144, func(i : Nat) : Float {
      Float.fromInt(i) * goldenAngle
    });
    
    let resonance = Array.init<Float>(12, func(i : Nat) : Float {
      Float.fromInt(i) * TWO_PI / 12.0
    });
    
    let harmonics = Array.init<Float>(10, func(i : Nat) : Float {
      pow(SACRED_PHI, Float.fromInt(i))
    });
    
    let fibPhases = Array.init<Nat>(12, func(i : Nat) : Nat {
      // Fibonacci: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144
      let fibs = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];
      if (i < Array.size(fibs)) { fibs[i] } else { 0 }
    });
    
    {
      var spiralAngle = 0.0;
      var spiralRadius = 1.0;
      var spiralGrowth = SACRED_PHI;
      var turnAngle = goldenAngle;
      var phyllotaxisPattern = phyllotaxis;
      var resonancePoints = resonance;
      var harmonicSeries = harmonics;
      var fibonacciPhases = fibPhases;
    }
  };

  public func initPlatonicResonance() : PlatonicResonance {
    {
      var tetrahedronEnergy = 0.0;
      var cubeEnergy = 0.0;
      var octahedronEnergy = 0.0;
      var dodecahedronEnergy = 0.0;
      var icosahedronEnergy = 0.0;
      var totalPlatonicEnergy = 0.0;
      var dominantSolid = "tetrahedron";
      var dualBalance = 0.5;
    }
  };

  // Update sacred geometry state
  public func updateSacredGeometry(
    sacred : SacredGeometryState,
    kura : KuramotoCouplingMatrix,
    heartbeatCount : Nat
  ) {
    // Update heartbeat multiple mod 444
    sacred.heartbeatMultiple := heartbeatCount % SACRED_444;
    
    // Compute φ-scaled harmonics from order parameter
    let r = kura.orderParameter;
    sacred.phiHarmonic := r * SACRED_PHI;
    sacred.phi2Harmonic := r * SACRED_PHI_SQUARED;
    sacred.phi3Harmonic := r * SACRED_PHI_CUBED;
    
    // Coherence / φ ratio
    sacred.coherencePhiRatio := r / SACRED_PHI;
    
    // Group coherences (already computed in Kuramoto)
    sacred.bodyTetrahedronCoherence := kura.bodyCoherence;
    sacred.interfaceCubeCoherence := kura.interfaceCoherence;
    sacred.brainDodecaCoherence := kura.brainCoherence;
    
    // Sacred alignment: how well groups follow φ scaling
    // Body should be base, Interface φ×, Brain φ²×
    let expectedInterface = sacred.bodyTetrahedronCoherence * SACRED_PHI;
    let expectedBrain = sacred.bodyTetrahedronCoherence * SACRED_PHI_SQUARED;
    
    let interfaceError = Float.abs(sacred.interfaceCubeCoherence - expectedInterface);
    let brainError = Float.abs(sacred.brainDodecaCoherence - expectedBrain);
    
    sacred.sacredAlignment := 1.0 - (interfaceError + brainError) / 2.0;
    sacred.sacredAlignment := clamp(sacred.sacredAlignment, 0.0, 1.0);
  };

  // Update φ-spiral
  public func updatePhiSpiral(
    spiral : PhiSpiralState,
    orderParameter : Float,
    dt : Float
  ) {
    // Spiral dynamics
    spiral.spiralAngle += spiral.turnAngle * dt / 1000.0;
    if (spiral.spiralAngle > TWO_PI) { spiral.spiralAngle -= TWO_PI };
    
    // Radius growth (constrained)
    spiral.spiralRadius := 1.0 + orderParameter * (spiral.spiralGrowth - 1.0);
    
    // Update resonance points based on current angle
    for (i in Iter.range(0, 11)) {
      let baseAngle = Float.fromInt(i) * TWO_PI / 12.0;
      let resonance = cos(spiral.spiralAngle - baseAngle);
      spiral.resonancePoints[i] := (1.0 + resonance) / 2.0;
    };
  };

  // Update Platonic resonance
  public func updatePlatonicResonance(
    platonic : PlatonicResonance,
    phases : [var Float],
    kura : KuramotoCouplingMatrix
  ) {
    // Tetrahedron: nodes 0-3 (4 vertices)
    // Energy = sum of pairwise phase coherences
    var tetraSum : Float = 0.0;
    for (i in Iter.range(0, 3)) {
      for (j in Iter.range(i + 1, 3)) {
        tetraSum += cos(phases[i] - phases[j]);
      };
    };
    platonic.tetrahedronEnergy := (tetraSum + 6.0) / 12.0;  // Normalize to [0,1]
    
    // Cube/Octahedron: nodes 4-7 (interface)
    var cubeSum : Float = 0.0;
    for (i in Iter.range(4, 7)) {
      for (j in Iter.range(i + 1, 7)) {
        cubeSum += cos(phases[i] - phases[j]);
      };
    };
    platonic.cubeEnergy := (cubeSum + 6.0) / 12.0;
    platonic.octahedronEnergy := platonic.cubeEnergy;  // Dual
    
    // Dodecahedron/Icosahedron: nodes 8-11 (brain)
    var dodecaSum : Float = 0.0;
    for (i in Iter.range(8, 11)) {
      for (j in Iter.range(i + 1, 11)) {
        dodecaSum += cos(phases[i] - phases[j]);
      };
    };
    platonic.dodecahedronEnergy := (dodecaSum + 6.0) / 12.0;
    platonic.icosahedronEnergy := platonic.dodecahedronEnergy;  // Dual
    
    // Total Platonic energy
    platonic.totalPlatonicEnergy := (platonic.tetrahedronEnergy + 
                                      platonic.cubeEnergy + 
                                      platonic.octahedronEnergy + 
                                      platonic.dodecahedronEnergy + 
                                      platonic.icosahedronEnergy) / 5.0;
    
    // Determine dominant solid
    var maxEnergy = platonic.tetrahedronEnergy;
    platonic.dominantSolid := "tetrahedron";
    
    if (platonic.cubeEnergy > maxEnergy) {
      maxEnergy := platonic.cubeEnergy;
      platonic.dominantSolid := "cube";
    };
    if (platonic.dodecahedronEnergy > maxEnergy) {
      platonic.dominantSolid := "dodecahedron";
    };
    
    // Dual balance
    let cubeOctaBalance = Float.abs(platonic.cubeEnergy - platonic.octahedronEnergy);
    let dodecaIcosaBalance = Float.abs(platonic.dodecahedronEnergy - platonic.icosahedronEnergy);
    platonic.dualBalance := 1.0 - (cubeOctaBalance + dodecaIcosaBalance) / 2.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // CONSCIOUSNESS INTEGRATION — PHI AND GLOBAL WORKSPACE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Integration of neural dynamics with consciousness theories:
  //
  // 1. INTEGRATED INFORMATION (Φ): Tononi's IIT
  // 2. GLOBAL WORKSPACE: Dehaene-Changeux GNW
  // 3. ATTENTION: Selective amplification
  // 4. BINDING: Feature integration
  //

  public type ConsciousnessState = {
    var phi : Float;                     // Integrated information
    var phiMax : Float;                  // Maximum possible phi
    var phiNormalized : Float;           // Φ / Φ_max
    var globalWorkspaceActivity : Float; // GNW activation level
    var attentionalFocus : [var Float];  // Attention per node
    var attentionalSpotlight : Nat;      // Most attended node
    var bindingStrength : Float;         // Feature binding
    var consciousnessLevel : Float;      // Overall consciousness [0,1]
    var accessConsciousness : Float;     // Global availability
    var phenomenalConsciousness : Float; // Qualia-like
  };

  public type GlobalWorkspace = {
    consciousness : ConsciousnessState;
    var ignitionThreshold : Float;       // Threshold for global ignition
    var ignited : Bool;                  // Currently ignited?
    var ignitionStrength : Float;        // Strength of ignition
    var workspaceContent : [var Float];  // Content representation
    var contentSaliency : [var Float];   // Saliency of each item
    var competitionWinner : Nat;         // Winning content
    var broadcastStrength : Float;       // Global broadcast amplitude
    var modulesActive : [var Bool];      // Active processing modules
    var integrationLevel : Float;        // Cross-module integration
  };

  public func initConsciousnessState() : ConsciousnessState {
    let attention = Array.init<Float>(12, func(_ : Nat) : Float { 1.0 / 12.0 });
    
    {
      var phi = 0.0;
      var phiMax = 1.0;
      var phiNormalized = 0.0;
      var globalWorkspaceActivity = 0.0;
      var attentionalFocus = attention;
      var attentionalSpotlight = 0;
      var bindingStrength = 0.0;
      var consciousnessLevel = 0.0;
      var accessConsciousness = 0.0;
      var phenomenalConsciousness = 0.0;
    }
  };

  public func initGlobalWorkspace() : GlobalWorkspace {
    let content = Array.init<Float>(12, func(_ : Nat) : Float { 0.0 });
    let saliency = Array.init<Float>(12, func(_ : Nat) : Float { 0.0 });
    let modules = Array.init<Bool>(6, func(_ : Nat) : Bool { false });
    
    {
      consciousness = initConsciousnessState();
      var ignitionThreshold = 0.5;
      var ignited = false;
      var ignitionStrength = 0.0;
      var workspaceContent = content;
      var contentSaliency = saliency;
      var competitionWinner = 0;
      var broadcastStrength = 0.0;
      var modulesActive = modules;
      var integrationLevel = 0.0;
    }
  };

  // Compute integrated information (simplified approximation)
  public func computePhi(
    activities : [var Float],
    connectivity : [[var Float]]
  ) : Float {
    let n = Array.size(activities);
    if (n == 0) { return 0.0 };
    
    // Simplified Φ: based on effective information
    // EI = H(Y|do(X)) - H(Y|do(X')) where X' is partitioned
    
    // Compute total mutual information
    var totalMI : Float = 0.0;
    var validPairs : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let xi = activities[i];
        let xj = activities[j];
        let coupling = connectivity[i][j];
        
        // MI approximation from activity correlation and coupling
        let correlation = xi * xj;  // Simple product
        let mi = coupling * correlation;
        
        totalMI += mi;
        validPairs += 1;
      };
    };
    
    if (validPairs == 0) { return 0.0 };
    
    // Normalize by system size
    totalMI / Float.fromInt(validPairs)
  };

  // Update consciousness state
  public func updateConsciousness(
    gws : GlobalWorkspace,
    activities : [var Float],
    connectivity : [[var Float]],
    phases : [var Float],
    orderParameter : Float
  ) {
    let cons = gws.consciousness;
    let n = 12;
    
    // Compute Φ
    cons.phi := computePhi(activities, connectivity);
    cons.phiNormalized := cons.phi;  // Already normalized in computation
    
    // Attentional focus (based on activity)
    var maxActivity : Float = 0.0;
    var totalActivity : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let a = activities[i];
      totalActivity += a;
      cons.attentionalFocus[i] := a;
      
      if (a > maxActivity) {
        maxActivity := a;
        cons.attentionalSpotlight := i;
      };
    };
    
    // Normalize attention
    if (totalActivity > 0.0) {
      for (i in Iter.range(0, n - 1)) {
        cons.attentionalFocus[i] /= totalActivity;
      };
    };
    
    // Binding strength from phase synchronization
    var syncSum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        syncSum += cos(phases[i] - phases[j]);
      };
    };
    cons.bindingStrength := (syncSum + Float.fromInt(n * (n - 1) / 2)) / Float.fromInt(n * (n - 1));
    
    // Global workspace activity
    gws.workspaceContent := activities;
    
    // Saliency based on deviation from mean
    let meanActivity = totalActivity / Float.fromInt(n);
    for (i in Iter.range(0, n - 1)) {
      gws.contentSaliency[i] := Float.abs(activities[i] - meanActivity);
    };
    
    // Competition - winner takes most
    var maxSaliency : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (gws.contentSaliency[i] > maxSaliency) {
        maxSaliency := gws.contentSaliency[i];
        gws.competitionWinner := i;
      };
    };
    
    // Ignition detection
    gws.ignitionStrength := orderParameter;
    gws.ignited := gws.ignitionStrength > gws.ignitionThreshold;
    
    // Broadcast strength
    gws.broadcastStrength := if (gws.ignited) { gws.ignitionStrength } else { 0.0 };
    
    // Module activation (simplified)
    for (m in Iter.range(0, 5)) {
      let moduleActivity = activities[(m * 2) % n] + activities[(m * 2 + 1) % n];
      gws.modulesActive[m] := moduleActivity > 0.5;
    };
    
    // Integration level
    var activeModules : Nat = 0;
    for (m in Iter.range(0, 5)) {
      if (gws.modulesActive[m]) { activeModules += 1 };
    };
    gws.integrationLevel := Float.fromInt(activeModules) / 6.0;
    
    // Overall consciousness level
    cons.accessConsciousness := if (gws.ignited) { gws.broadcastStrength } else { 0.0 };
    cons.phenomenalConsciousness := cons.phi * cons.bindingStrength;
    cons.consciousnessLevel := (cons.accessConsciousness + cons.phenomenalConsciousness) / 2.0;
    
    // Global workspace activity
    gws.consciousness.globalWorkspaceActivity := gws.integrationLevel * gws.broadcastStrength;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE PROCESSING — FREE ENERGY MINIMIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism implements predictive processing through free energy minimization:
  //
  // F = D_KL[q(x) || p(x|o)] + ln p(o)
  //   = Prediction Error + Complexity
  //   = Accuracy - Complexity
  //

  public type PredictiveState = {
    var predictions : [var Float];       // Current predictions μ
    var predictionErrors : [var Float];  // ε = o - μ
    var precisions : [var Float];        // π = 1/σ²
    var observations : [var Float];      // Sensory observations o
    var freeEnergy : Float;              // F = ε'πε/2
    var accuracy : Float;                // -ln p(o|μ)
    var complexity : Float;              // D_KL[q||p]
    var surprise : Float;                // -ln p(o)
    var expectedFreeEnergy : Float;      // G for action selection
    var learningRate : Float;            // κ for belief updating
  };

  public type HierarchicalPrediction = {
    var levels : [var PredictiveState];  // Hierarchy of prediction levels
    var numLevels : Nat;
    var topDownPredictions : [[var Float]]; // μ from level above
    var bottomUpErrors : [[var Float]];     // ε to level above
    var lateralConnections : [[var Float]]; // Within-level connections
    var hierarchicalPrecision : [var Float];// π per level
    var dominantLevel : Nat;             // Which level dominates
    var hierarchyDepth : Float;          // Effective depth
  };

  public func initPredictiveState(size : Nat) : PredictiveState {
    {
      var predictions = Array.init<Float>(size, func(_ : Nat) : Float { 0.5 });
      var predictionErrors = Array.init<Float>(size, func(_ : Nat) : Float { 0.0 });
      var precisions = Array.init<Float>(size, func(_ : Nat) : Float { 1.0 });
      var observations = Array.init<Float>(size, func(_ : Nat) : Float { 0.5 });
      var freeEnergy = 0.0;
      var accuracy = 0.0;
      var complexity = 0.0;
      var surprise = 0.0;
      var expectedFreeEnergy = 0.0;
      var learningRate = 0.1;
    }
  };

  public func initHierarchicalPrediction(numLevels : Nat, levelSize : Nat) : HierarchicalPrediction {
    let levels = Array.init<PredictiveState>(numLevels, func(_ : Nat) : PredictiveState {
      initPredictiveState(levelSize)
    });
    
    let topDown = Array.init<[var Float]>(numLevels, func(_ : Nat) : [var Float] {
      Array.init<Float>(levelSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let bottomUp = Array.init<[var Float]>(numLevels, func(_ : Nat) : [var Float] {
      Array.init<Float>(levelSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let lateral = Array.init<[var Float]>(numLevels, func(_ : Nat) : [var Float] {
      Array.init<Float>(levelSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let precision = Array.init<Float>(numLevels, func(l : Nat) : Float {
      1.0 / Float.fromInt(l + 1)  // Decreasing precision up hierarchy
    });
    
    {
      var levels = levels;
      var numLevels = numLevels;
      var topDownPredictions = topDown;
      var bottomUpErrors = bottomUp;
      var lateralConnections = lateral;
      var hierarchicalPrecision = precision;
      var dominantLevel = 0;
      var hierarchyDepth = Float.fromInt(numLevels);
    }
  };

  // Update predictive state
  public func updatePredictiveState(
    state : PredictiveState,
    newObservations : [Float]
  ) {
    let n = Array.size(state.predictions);
    if (Array.size(newObservations) < n) { return };
    
    var totalFE : Float = 0.0;
    var totalSurprise : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      // Update observations
      state.observations[i] := newObservations[i];
      
      // Compute prediction error
      let error = state.observations[i] - state.predictions[i];
      state.predictionErrors[i] := error;
      
      // Precision-weighted free energy
      let weightedError = state.precisions[i] * error * error / 2.0;
      totalFE += weightedError;
      
      // Surprise (negative log probability)
      let p = exp(-error * error / 2.0);
      if (p > 0.0) {
        totalSurprise -= ln(p);
      };
      
      // Update prediction (gradient descent on free energy)
      let dMu = state.learningRate * state.precisions[i] * error;
      state.predictions[i] += dMu;
      state.predictions[i] := clamp(state.predictions[i], 0.0, 1.0);
    };
    
    state.freeEnergy := totalFE;
    state.surprise := totalSurprise;
    
    // Accuracy vs complexity decomposition
    state.accuracy := totalFE;  // Simplified
    
    // Complexity (prediction variance)
    var predVar : Float = 0.0;
    var predMean : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      predMean += state.predictions[i];
    };
    predMean /= Float.fromInt(n);
    
    for (i in Iter.range(0, n - 1)) {
      let diff = state.predictions[i] - predMean;
      predVar += diff * diff;
    };
    state.complexity := predVar / Float.fromInt(n);
  };

  // Update hierarchical prediction
  public func updateHierarchicalPrediction(
    hier : HierarchicalPrediction,
    bottomObservations : [Float]
  ) {
    let nLevels = hier.numLevels;
    
    // Bottom-up pass: compute prediction errors
    for (l in Iter.range(0, nLevels - 1)) {
      let levelState = hier.levels[l];
      let obs = if (l == 0) {
        bottomObservations
      } else {
        // Observations from level below = predictions of level below
        Array.tabulate<Float>(Array.size(hier.levels[l - 1].predictions), func(i : Nat) : Float {
          hier.levels[l - 1].predictions[i]
        })
      };
      
      updatePredictiveState(levelState, obs);
      
      // Store bottom-up errors for level above
      if (l < nLevels - 1) {
        for (i in Iter.range(0, Array.size(levelState.predictionErrors) - 1)) {
          hier.bottomUpErrors[l + 1][i] := levelState.predictionErrors[i];
        };
      };
    };
    
    // Top-down pass: generate predictions
    for (l in Iter.range(0, nLevels - 1)) {
      let revL = nLevels - 1 - l;
      if (revL > 0) {
        let upperLevel = hier.levels[revL];
        let lowerLevel = hier.levels[revL - 1];
        
        // Top-down predictions modulate lower level
        for (i in Iter.range(0, Array.size(upperLevel.predictions) - 1)) {
          if (i < Array.size(hier.topDownPredictions[revL - 1])) {
            hier.topDownPredictions[revL - 1][i] := upperLevel.predictions[i];
            
            // Lower level prediction incorporates top-down
            let topDown = hier.topDownPredictions[revL - 1][i];
            let current = lowerLevel.predictions[i];
            lowerLevel.predictions[i] := 0.7 * current + 0.3 * topDown;
          };
        };
      };
    };
    
    // Find dominant level (highest precision-weighted activity)
    var maxActivity : Float = 0.0;
    for (l in Iter.range(0, nLevels - 1)) {
      var levelActivity : Float = 0.0;
      for (i in Iter.range(0, Array.size(hier.levels[l].predictions) - 1)) {
        levelActivity += hier.levels[l].predictions[i] * hier.hierarchicalPrecision[l];
      };
      
      if (levelActivity > maxActivity) {
        maxActivity := levelActivity;
        hier.dominantLevel := l;
      };
    };
    
    // Effective hierarchy depth (entropy of activity distribution)
    var totalActivity : Float = 0.0;
    let activities = Array.tabulate<Float>(nLevels, func(l : Nat) : Float {
      var sum : Float = 0.0;
      for (i in Iter.range(0, Array.size(hier.levels[l].predictions) - 1)) {
        sum += hier.levels[l].predictions[i];
      };
      totalActivity += sum;
      sum
    });
    
    if (totalActivity > 0.0) {
      var entropy : Float = 0.0;
      for (a in activities.vals()) {
        let p = a / totalActivity;
        if (p > 0.0) {
          entropy -= p * ln(p);
        };
      };
      hier.hierarchyDepth := exp(entropy);
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ACTIVE INFERENCE — ACTION AS PREDICTION FULFILLMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Active inference: the organism acts to fulfill its predictions
  //
  //   G = E_q[ln q(s) - ln p(o,s|π)] = Expected Free Energy
  //   π* = argmin_π G(π)
  //

  public type ActiveInferenceState = {
    var policies : [[var Float]];        // Available action policies
    var numPolicies : Nat;
    var policyLength : Nat;
    var expectedFE : [var Float];        // G for each policy
    var policyProbabilities : [var Float]; // P(π) ∝ exp(-G(π))
    var selectedPolicy : Nat;            // argmin G
    var currentAction : Float;           // Current action value
    var actionHistory : [var Float];     // Recent actions
    var historyIdx : Nat;
    var precision : Float;               // Action precision (inverse temperature)
    var goalState : [var Float];         // Desired observations
    var epistemic : Float;               // Information-seeking drive
    var pragmatic : Float;               // Goal-seeking drive
  };

  public type BeliefState = {
    activeInf : ActiveInferenceState;
    var beliefs : [var Float];           // Current beliefs about hidden states
    var beliefPrecision : [var Float];   // Confidence in beliefs
    var posteriorExpectation : [var Float]; // E_q[x]
    var posteriorVariance : [var Float]; // Var_q[x]
    var priorBeliefs : [var Float];      // Prior expectations
    var priorPrecision : [var Float];    // Prior confidence
    var likelihoodMapping : [[var Float]]; // P(o|x)
    var transitionModel : [[var Float]]; // P(x'|x,a)
    var bayesianSurprise : Float;        // KL between posterior and prior
    var evidenceLower : Float;           // ELBO
  };

  public func initActiveInferenceState(numPolicies : Nat, policyLength : Nat, historySize : Nat) : ActiveInferenceState {
    let policies = Array.init<[var Float]>(numPolicies, func(p : Nat) : [var Float] {
      Array.init<Float>(policyLength, func(_ : Nat) : Float {
        Float.fromInt(p) / Float.fromInt(numPolicies)  // Different action sequences
      })
    });
    
    let efe = Array.init<Float>(numPolicies, func(_ : Nat) : Float { 0.0 });
    let probs = Array.init<Float>(numPolicies, func(_ : Nat) : Float { 1.0 / Float.fromInt(numPolicies) });
    let history = Array.init<Float>(historySize, func(_ : Nat) : Float { 0.0 });
    let goals = Array.init<Float>(12, func(_ : Nat) : Float { 0.5 });
    
    {
      var policies = policies;
      var numPolicies = numPolicies;
      var policyLength = policyLength;
      var expectedFE = efe;
      var policyProbabilities = probs;
      var selectedPolicy = 0;
      var currentAction = 0.0;
      var actionHistory = history;
      var historyIdx = 0;
      var precision = 1.0;
      var goalState = goals;
      var epistemic = 0.5;
      var pragmatic = 0.5;
    }
  };

  public func initBeliefState(stateSize : Nat, obsSize : Nat, numPolicies : Nat) : BeliefState {
    let beliefs = Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 / Float.fromInt(stateSize) });
    let precision = Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 });
    let postExp = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
    let postVar = Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 });
    let priorB = Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 / Float.fromInt(stateSize) });
    let priorP = Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 });
    
    let likelihood = Array.init<[var Float]>(obsSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 / Float.fromInt(stateSize) })
    });
    
    let transition = Array.init<[var Float]>(stateSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 / Float.fromInt(stateSize) })
    });
    
    {
      activeInf = initActiveInferenceState(numPolicies, 5, 20);
      var beliefs = beliefs;
      var beliefPrecision = precision;
      var posteriorExpectation = postExp;
      var posteriorVariance = postVar;
      var priorBeliefs = priorB;
      var priorPrecision = priorP;
      var likelihoodMapping = likelihood;
      var transitionModel = transition;
      var bayesianSurprise = 0.0;
      var evidenceLower = 0.0;
    }
  };

  // Compute expected free energy for a policy
  public func computeExpectedFE(
    belief : BeliefState,
    policy : [var Float],
    goalState : [var Float]
  ) : Float {
    let n = Array.size(belief.beliefs);
    var epistemicValue : Float = 0.0;
    var pragmaticValue : Float = 0.0;
    
    // Epistemic value: expected information gain
    // -H(o|s) where H is entropy
    for (i in Iter.range(0, n - 1)) {
      let p = belief.beliefs[i];
      if (p > 0.0) {
        epistemicValue -= p * ln(p);
      };
    };
    
    // Pragmatic value: expected goal achievement
    // -D_KL(q(o)||p(o)) where p(o) is goal distribution
    for (i in Iter.range(0, n - 1)) {
      let predicted = belief.posteriorExpectation[i];
      let goal = if (i < Array.size(goalState)) { goalState[i] } else { 0.5 };
      
      pragmaticValue -= (predicted - goal) * (predicted - goal);
    };
    
    // G = epistemic + pragmatic
    epistemicValue + pragmaticValue
  };

  // Update active inference
  public func updateActiveInference(
    belief : BeliefState,
    observations : [Float]
  ) {
    let ai = belief.activeInf;
    let n = Array.size(belief.beliefs);
    
    // Update beliefs from observations (Bayesian update)
    var sumLikelihood : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      // P(x|o) ∝ P(o|x) × P(x)
      var likelihood : Float = 1.0;
      
      for (o in Iter.range(0, Array.size(observations) - 1)) {
        if (o < Array.size(belief.likelihoodMapping) and i < Array.size(belief.likelihoodMapping[o])) {
          likelihood *= belief.likelihoodMapping[o][i];
        };
      };
      
      belief.beliefs[i] := likelihood * belief.priorBeliefs[i];
      sumLikelihood += belief.beliefs[i];
    };
    
    // Normalize posterior
    if (sumLikelihood > 0.0) {
      for (i in Iter.range(0, n - 1)) {
        belief.beliefs[i] /= sumLikelihood;
        belief.posteriorExpectation[i] := belief.beliefs[i];
      };
    };
    
    // Compute expected free energy for each policy
    for (p in Iter.range(0, ai.numPolicies - 1)) {
      ai.expectedFE[p] := computeExpectedFE(belief, ai.policies[p], ai.goalState);
    };
    
    // Policy probabilities via softmax
    var sumExp : Float = 0.0;
    for (p in Iter.range(0, ai.numPolicies - 1)) {
      let exp_negG = exp(-ai.precision * ai.expectedFE[p]);
      ai.policyProbabilities[p] := exp_negG;
      sumExp += exp_negG;
    };
    
    if (sumExp > 0.0) {
      for (p in Iter.range(0, ai.numPolicies - 1)) {
        ai.policyProbabilities[p] /= sumExp;
      };
    };
    
    // Select best policy
    var minG : Float = ai.expectedFE[0];
    ai.selectedPolicy := 0;
    for (p in Iter.range(1, ai.numPolicies - 1)) {
      if (ai.expectedFE[p] < minG) {
        minG := ai.expectedFE[p];
        ai.selectedPolicy := p;
      };
    };
    
    // Execute first action of selected policy
    if (ai.selectedPolicy < ai.numPolicies and Array.size(ai.policies[ai.selectedPolicy]) > 0) {
      ai.currentAction := ai.policies[ai.selectedPolicy][0];
    };
    
    // Record in history
    ai.actionHistory[ai.historyIdx] := ai.currentAction;
    ai.historyIdx := (ai.historyIdx + 1) % Array.size(ai.actionHistory);
    
    // Bayesian surprise
    var kl : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let q = belief.beliefs[i];
      let p = belief.priorBeliefs[i];
      if (q > 0.0 and p > 0.0) {
        kl += q * (ln(q) - ln(p));
      };
    };
    belief.bayesianSurprise := kl;
    
    // ELBO (evidence lower bound)
    belief.evidenceLower := -belief.activeInf.expectedFE[belief.activeInf.selectedPolicy];
    
    // Update priors for next timestep
    for (i in Iter.range(0, n - 1)) {
      belief.priorBeliefs[i] := belief.beliefs[i];
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // REINFORCEMENT LEARNING INTEGRATION — TD LEARNING AND ACTOR-CRITIC
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Integration of RL with neural dynamics:
  //
  //   δ = r + γV(s') - V(s)  (TD error)
  //   V(s) ← V(s) + αδ        (Value update)
  //   π(a|s) ← π(a|s) + βδ∇ln π(a|s)  (Policy gradient)
  //

  public type ReinforcementState = {
    var valueFunction : [var Float];     // V(s) for each state
    var actionValues : [[var Float]];    // Q(s,a)
    var policy : [[var Float]];          // π(a|s)
    var numStates : Nat;
    var numActions : Nat;
    var currentState : Nat;
    var lastAction : Nat;
    var tdError : Float;                 // δ
    var reward : Float;                  // Current reward
    var cumulativeReward : Float;        // Total reward
    var discountFactor : Float;          // γ
    var learningRateValue : Float;       // α for value
    var learningRatePolicy : Float;      // β for policy
    var explorationRate : Float;         // ε for ε-greedy
    var eligibilityTraces : [var Float]; // For TD(λ)
    var lambda : Float;                  // λ for eligibility
  };

  public type ActorCriticState = {
    rl : ReinforcementState;
    var actorWeights : [[var Float]];    // Policy parameters
    var criticWeights : [var Float];     // Value parameters
    var actorGradient : [[var Float]];   // ∇θ log π
    var criticGradient : [var Float];    // ∇w V
    var actorMomentum : [[var Float]];   // Momentum for actor
    var criticMomentum : [var Float];    // Momentum for critic
    var advantageEstimate : Float;       // A(s,a) = Q - V
    var entropy : Float;                 // Policy entropy for exploration
    var entropyWeight : Float;           // Coefficient for entropy bonus
  };

  public func initReinforcementState(numStates : Nat, numActions : Nat) : ReinforcementState {
    let value = Array.init<Float>(numStates, func(_ : Nat) : Float { 0.0 });
    
    let qValues = Array.init<[var Float]>(numStates, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 })
    });
    
    let pol = Array.init<[var Float]>(numStates, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActions, func(_ : Nat) : Float { 1.0 / Float.fromInt(numActions) })
    });
    
    let elig = Array.init<Float>(numStates, func(_ : Nat) : Float { 0.0 });
    
    {
      var valueFunction = value;
      var actionValues = qValues;
      var policy = pol;
      var numStates = numStates;
      var numActions = numActions;
      var currentState = 0;
      var lastAction = 0;
      var tdError = 0.0;
      var reward = 0.0;
      var cumulativeReward = 0.0;
      var discountFactor = 0.99;
      var learningRateValue = 0.1;
      var learningRatePolicy = 0.01;
      var explorationRate = 0.1;
      var eligibilityTraces = elig;
      var lambda = 0.9;
    }
  };

  public func initActorCriticState(numStates : Nat, numActions : Nat, featureSize : Nat) : ActorCriticState {
    let actorW = Array.init<[var Float]>(featureSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActions, func(_ : Nat) : Float { 0.01 })
    });
    
    let criticW = Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 });
    
    let actorG = Array.init<[var Float]>(featureSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 })
    });
    
    let criticG = Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 });
    
    let actorM = Array.init<[var Float]>(featureSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActions, func(_ : Nat) : Float { 0.0 })
    });
    
    let criticM = Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 });
    
    {
      rl = initReinforcementState(numStates, numActions);
      var actorWeights = actorW;
      var criticWeights = criticW;
      var actorGradient = actorG;
      var criticGradient = criticG;
      var actorMomentum = actorM;
      var criticMomentum = criticM;
      var advantageEstimate = 0.0;
      var entropy = 0.0;
      var entropyWeight = 0.01;
    }
  };

  // TD learning update
  public func updateTDLearning(
    rl : ReinforcementState,
    newState : Nat,
    reward : Float
  ) {
    let oldState = rl.currentState;
    
    // TD error: δ = r + γV(s') - V(s)
    let target = reward + rl.discountFactor * rl.valueFunction[newState % rl.numStates];
    let current = rl.valueFunction[oldState % rl.numStates];
    rl.tdError := target - current;
    
    // Update value function
    rl.valueFunction[oldState % rl.numStates] += rl.learningRateValue * rl.tdError;
    
    // Update eligibility traces (for TD(λ))
    for (s in Iter.range(0, rl.numStates - 1)) {
      rl.eligibilityTraces[s] *= rl.discountFactor * rl.lambda;
    };
    rl.eligibilityTraces[oldState % rl.numStates] := 1.0;
    
    // Update all states with eligibility
    for (s in Iter.range(0, rl.numStates - 1)) {
      rl.valueFunction[s] += rl.learningRateValue * rl.tdError * rl.eligibilityTraces[s];
    };
    
    // Update Q-values
    let action = rl.lastAction;
    rl.actionValues[oldState % rl.numStates][action % rl.numActions] += 
      rl.learningRateValue * rl.tdError;
    
    // Update cumulative reward
    rl.reward := reward;
    rl.cumulativeReward += reward;
    
    // Update state
    rl.currentState := newState % rl.numStates;
  };

  // Select action using ε-greedy
  public func selectAction(rl : ReinforcementState, seed : Nat) : Nat {
    var pseudoRandom = seed;
    pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
    
    let rand = Float.fromInt(pseudoRandom) / 2147483648.0;
    
    if (rand < rl.explorationRate) {
      // Explore: random action
      pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
      let action = pseudoRandom % rl.numActions;
      rl.lastAction := action;
      action
    } else {
      // Exploit: best action
      var bestAction : Nat = 0;
      var bestValue = rl.actionValues[rl.currentState][0];
      
      for (a in Iter.range(1, rl.numActions - 1)) {
        if (rl.actionValues[rl.currentState][a] > bestValue) {
          bestValue := rl.actionValues[rl.currentState][a];
          bestAction := a;
        };
      };
      
      rl.lastAction := bestAction;
      bestAction
    }
  };

  // Update actor-critic
  public func updateActorCritic(
    ac : ActorCriticState,
    features : [Float],
    newState : Nat,
    reward : Float
  ) {
    let rl = ac.rl;
    let featureSize = Array.size(features);
    
    // Critic update (value function)
    // V(s) = Σ w_i × φ_i(s)
    var oldValue : Float = 0.0;
    var newValue : Float = 0.0;
    
    for (i in Iter.range(0, featureSize - 1)) {
      if (i < Array.size(ac.criticWeights)) {
        oldValue += ac.criticWeights[i] * features[i];
      };
    };
    
    // TD error
    let target = reward + rl.discountFactor * rl.valueFunction[newState % rl.numStates];
    rl.tdError := target - oldValue;
    
    // Advantage estimate: A = δ
    ac.advantageEstimate := rl.tdError;
    
    // Update critic weights
    for (i in Iter.range(0, featureSize - 1)) {
      if (i < Array.size(ac.criticWeights) and i < Array.size(features)) {
        ac.criticGradient[i] := rl.tdError * features[i];
        
        // Momentum update
        ac.criticMomentum[i] := 0.9 * ac.criticMomentum[i] + 0.1 * ac.criticGradient[i];
        ac.criticWeights[i] += rl.learningRateValue * ac.criticMomentum[i];
      };
    };
    
    // Actor update (policy gradient)
    // ∇θ J = E[A × ∇θ log π(a|s)]
    let action = rl.lastAction;
    
    for (i in Iter.range(0, featureSize - 1)) {
      if (i < Array.size(ac.actorWeights) and action < Array.size(ac.actorWeights[i])) {
        // Gradient of log π (softmax policy)
        let logGrad = features[i] * (1.0 - rl.policy[rl.currentState][action]);
        ac.actorGradient[i][action] := ac.advantageEstimate * logGrad;
        
        // Momentum update
        ac.actorMomentum[i][action] := 0.9 * ac.actorMomentum[i][action] + 0.1 * ac.actorGradient[i][action];
        ac.actorWeights[i][action] += rl.learningRatePolicy * ac.actorMomentum[i][action];
      };
    };
    
    // Policy entropy for exploration bonus
    var entropy : Float = 0.0;
    for (a in Iter.range(0, rl.numActions - 1)) {
      let p = rl.policy[rl.currentState][a];
      if (p > 0.0) {
        entropy -= p * ln(p);
      };
    };
    ac.entropy := entropy;
    
    // Update standard RL components
    updateTDLearning(rl, newState, reward);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HOMEOSTATIC REGULATION — DRIVE AND ENERGY DYNAMICS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism maintains homeostatic balance across multiple dimensions:
  //
  //   drive(d) = max(0, setPoint(d) - currentLevel(d))
  //   urgency = Σ drive(d)²
  //

  public type HomeostaticState = {
    var drives : [var Float];            // Current drive levels
    var setPoints : [var Float];         // Optimal levels
    var currentLevels : [var Float];     // Current resource levels
    var driveNames : [Text];             // Drive identifiers
    var numDrives : Nat;
    var totalUrgency : Float;            // Sum of squared drives
    var dominantDrive : Nat;             // Most urgent drive
    var satisfactionLevel : Float;       // Overall satisfaction
    var energyBudget : Float;            // Available energy
    var energyConsumption : Float;       // Energy used per tick
    var metabolicRate : Float;           // Base metabolism
  };

  public type DriveIntegration = {
    homeostasis : HomeostaticState;
    var driveToActionMapping : [[var Float]]; // Drive → action influence
    var actionEffects : [[var Float]];   // Action → drive effects
    var driveInteractions : [[var Float]]; // Drive-drive interactions
    var temporalDiscounting : Float;     // How much to prefer immediate
    var anticipatoryDrive : [var Float]; // Expected future needs
    var allostasis : Float;              // Predictive regulation
    var interoception : [var Float];     // Internal sensing accuracy
  };

  public func initHomeostaticState() : HomeostaticState {
    let names = ["energy", "temperature", "hydration", "safety", "social", "information"];
    let n = Array.size(names);
    
    {
      var drives = Array.init<Float>(n, func(_ : Nat) : Float { 0.0 });
      var setPoints = Array.init<Float>(n, func(_ : Nat) : Float { 1.0 });
      var currentLevels = Array.init<Float>(n, func(_ : Nat) : Float { 0.8 });
      var driveNames = names;
      var numDrives = n;
      var totalUrgency = 0.0;
      var dominantDrive = 0;
      var satisfactionLevel = 0.8;
      var energyBudget = 1.0;
      var energyConsumption = 0.01;
      var metabolicRate = 0.01;
    }
  };

  public func initDriveIntegration(numDrives : Nat, numActions : Nat) : DriveIntegration {
    let driveToAction = Array.init<[var Float]>(numDrives, func(_ : Nat) : [var Float] {
      Array.init<Float>(numActions, func(_ : Nat) : Float { 0.1 })
    });
    
    let actionEffects = Array.init<[var Float]>(numActions, func(_ : Nat) : [var Float] {
      Array.init<Float>(numDrives, func(_ : Nat) : Float { 0.0 })
    });
    
    let driveInteract = Array.init<[var Float]>(numDrives, func(_ : Nat) : [var Float] {
      Array.init<Float>(numDrives, func(_ : Nat) : Float { 0.0 })
    });
    
    let anticipatory = Array.init<Float>(numDrives, func(_ : Nat) : Float { 0.0 });
    let intero = Array.init<Float>(numDrives, func(_ : Nat) : Float { 1.0 });
    
    {
      homeostasis = initHomeostaticState();
      var driveToActionMapping = driveToAction;
      var actionEffects = actionEffects;
      var driveInteractions = driveInteract;
      var temporalDiscounting = 0.95;
      var anticipatoryDrive = anticipatory;
      var allostasis = 0.0;
      var interoception = intero;
    }
  };

  // Update homeostatic drives
  public func updateHomeostasis(homeo : HomeostaticState, dt : Float) {
    let n = homeo.numDrives;
    
    // Natural decay of resources
    for (i in Iter.range(0, n - 1)) {
      homeo.currentLevels[i] -= homeo.metabolicRate * dt / 1000.0;
      homeo.currentLevels[i] := clamp(homeo.currentLevels[i], 0.0, 1.5);
    };
    
    // Compute drives
    var maxDrive : Float = 0.0;
    homeo.totalUrgency := 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let deficit = homeo.setPoints[i] - homeo.currentLevels[i];
      homeo.drives[i] := if (deficit > 0.0) { deficit } else { 0.0 };
      
      homeo.totalUrgency += homeo.drives[i] * homeo.drives[i];
      
      if (homeo.drives[i] > maxDrive) {
        maxDrive := homeo.drives[i];
        homeo.dominantDrive := i;
      };
    };
    
    homeo.totalUrgency := sqrt(homeo.totalUrgency);
    
    // Satisfaction = 1 - normalized urgency
    homeo.satisfactionLevel := 1.0 - (homeo.totalUrgency / Float.fromInt(n));
    homeo.satisfactionLevel := clamp(homeo.satisfactionLevel, 0.0, 1.0);
    
    // Energy budget
    homeo.energyBudget -= homeo.energyConsumption * dt / 1000.0;
    homeo.energyBudget := clamp(homeo.energyBudget, 0.0, 2.0);
  };

  // Apply action effects to drives
  public func applyActionToDrives(
    integration : DriveIntegration,
    action : Nat
  ) {
    let homeo = integration.homeostasis;
    let n = homeo.numDrives;
    
    if (action >= Array.size(integration.actionEffects)) { return };
    
    for (d in Iter.range(0, n - 1)) {
      if (d < Array.size(integration.actionEffects[action])) {
        let effect = integration.actionEffects[action][d];
        homeo.currentLevels[d] += effect;
        homeo.currentLevels[d] := clamp(homeo.currentLevels[d], 0.0, 1.5);
      };
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MEMORY CONSOLIDATION — EPISODIC AND SEMANTIC PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Memory systems integration:
  //
  // 1. WORKING MEMORY: Theta-gamma nested oscillations
  // 2. EPISODIC MEMORY: Hippocampal replay during sleep
  // 3. SEMANTIC MEMORY: Cortical consolidation
  // 4. PROCEDURAL MEMORY: Basal ganglia habits
  //

  public type MemoryConsolidation = {
    var workingMemory : [var Float];     // Current working memory contents
    var workingMemoryCapacity : Nat;     // Typically 7±2 items
    var workingMemoryUsed : Nat;         // Currently used slots
    var episodicBuffer : [[var Float]];  // Recent episodic memories
    var episodicIndex : Nat;             // Circular buffer index
    var episodicCapacity : Nat;          // Buffer size
    var semanticMemory : [[var Float]];  // Consolidated semantic memory
    var semanticIndex : Nat;
    var consolidationRate : Float;       // Episodic → semantic transfer rate
    var replayStrength : Float;          // Replay activity level
    var synapticDownscaling : Float;     // Sleep homeostasis
    var memoryAge : [var Nat];           // Age of each memory in ticks
    var forgettingRate : Float;          // Decay rate
  };

  public type SleepState = {
    var isSleeping : Bool;               // Currently in sleep state?
    var sleepStage : Text;               // "N1", "N2", "N3", "REM"
    var sleepDepth : Float;              // 0 = awake, 1 = deep sleep
    var remDensity : Float;              // REM episode frequency
    var slowWaveActivity : Float;        // Delta power
    var sleepSpindles : Float;           // Spindle density
    var kComplexes : Nat;                // K-complex count
    var sleepPressure : Float;           // Adenosine accumulation
    var circadianPhase : Float;          // 0-24 hours mapped to 0-2π
    var replayEvents : Nat;              // Memories replayed this sleep
    var consolidationProgress : Float;   // How much consolidated
  };

  public type MemorySystem = {
    consolidation : MemoryConsolidation;
    sleep : SleepState;
    var shortTermDecay : Float;          // STM decay rate
    var longTermStrength : Float;        // LTM trace strength
    var reconsolidation : Bool;          // Memory being reconsolidated?
    var retrievalStrength : Float;       // Current retrieval ease
    var memoryInterference : Float;      // Interference from similar memories
    var spacingEffect : Float;           // Benefit from spaced repetition
    var encodingStrength : Float;        // Current encoding quality
    var emotionalModulation : Float;     // Emotional impact on memory
  };

  public func initMemoryConsolidation(wmCapacity : Nat, epCapacity : Nat, semCapacity : Nat, featureSize : Nat) : MemoryConsolidation {
    let wm = Array.init<Float>(wmCapacity, func(_ : Nat) : Float { 0.0 });
    
    let ep = Array.init<[var Float]>(epCapacity, func(_ : Nat) : [var Float] {
      Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let sem = Array.init<[var Float]>(semCapacity, func(_ : Nat) : [var Float] {
      Array.init<Float>(featureSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let ages = Array.init<Nat>(epCapacity + semCapacity, func(_ : Nat) : Nat { 0 });
    
    {
      var workingMemory = wm;
      var workingMemoryCapacity = wmCapacity;
      var workingMemoryUsed = 0;
      var episodicBuffer = ep;
      var episodicIndex = 0;
      var episodicCapacity = epCapacity;
      var semanticMemory = sem;
      var semanticIndex = 0;
      var consolidationRate = 0.01;
      var replayStrength = 0.0;
      var synapticDownscaling = 0.0;
      var memoryAge = ages;
      var forgettingRate = 0.001;
    }
  };

  public func initSleepState() : SleepState {
    {
      var isSleeping = false;
      var sleepStage = "awake";
      var sleepDepth = 0.0;
      var remDensity = 0.0;
      var slowWaveActivity = 0.0;
      var sleepSpindles = 0.0;
      var kComplexes = 0;
      var sleepPressure = 0.0;
      var circadianPhase = 0.0;
      var replayEvents = 0;
      var consolidationProgress = 0.0;
    }
  };

  public func initMemorySystem(wmCapacity : Nat, epCapacity : Nat, semCapacity : Nat, featureSize : Nat) : MemorySystem {
    {
      consolidation = initMemoryConsolidation(wmCapacity, epCapacity, semCapacity, featureSize);
      sleep = initSleepState();
      var shortTermDecay = 0.1;
      var longTermStrength = 0.5;
      var reconsolidation = false;
      var retrievalStrength = 0.0;
      var memoryInterference = 0.0;
      var spacingEffect = 1.0;
      var encodingStrength = 1.0;
      var emotionalModulation = 1.0;
    }
  };

  // Encode new memory to working memory
  public func encodeToWorkingMemory(
    mem : MemoryConsolidation,
    content : Float,
    emotionalStrength : Float
  ) : Bool {
    // Check capacity
    if (mem.workingMemoryUsed >= mem.workingMemoryCapacity) {
      // Displacement: remove oldest
      for (i in Iter.range(0, mem.workingMemoryCapacity - 2)) {
        mem.workingMemory[i] := mem.workingMemory[i + 1];
      };
      mem.workingMemory[mem.workingMemoryCapacity - 1] := content;
      true
    } else {
      // Add to free slot
      mem.workingMemory[mem.workingMemoryUsed] := content;
      mem.workingMemoryUsed += 1;
      true
    }
  };

  // Transfer working memory to episodic buffer
  public func transferToEpisodic(
    mem : MemoryConsolidation,
    workingMemoryIdx : Nat
  ) {
    if (workingMemoryIdx >= mem.workingMemoryUsed) { return };
    
    // Create episodic trace
    let idx = mem.episodicIndex;
    let wmContent = mem.workingMemory[workingMemoryIdx];
    
    // Simple representation
    mem.episodicBuffer[idx][0] := wmContent;
    mem.memoryAge[idx] := 0;
    
    mem.episodicIndex := (idx + 1) % mem.episodicCapacity;
  };

  // Consolidate episodic to semantic during sleep
  public func consolidateMemories(
    mem : MemoryConsolidation,
    sleep : SleepState
  ) {
    if (not sleep.isSleeping) { return };
    
    // Slow wave sleep consolidation
    if (sleep.sleepStage == "N3") {
      let replayProbability = sleep.slowWaveActivity;
      
      // Select episodic memories to replay
      for (i in Iter.range(0, mem.episodicCapacity - 1)) {
        let age = mem.memoryAge[i];
        let replayChance = replayProbability / Float.fromInt(age + 1);
        
        if (replayChance > 0.5) {
          // Replay → strengthen semantic trace
          let featureSize = Array.size(mem.episodicBuffer[i]);
          
          for (f in Iter.range(0, featureSize - 1)) {
            let semIdx = mem.semanticIndex;
            if (f < Array.size(mem.semanticMemory[semIdx])) {
              mem.semanticMemory[semIdx][f] += 
                mem.consolidationRate * mem.episodicBuffer[i][f];
            };
          };
          
          sleep.replayEvents += 1;
          mem.replayStrength += 0.1;
        };
      };
    };
    
    // REM sleep memory integration
    if (sleep.sleepStage == "REM") {
      // Abstract patterns from episodic
      // (Simplified: increase semantic strength)
      mem.consolidationRate *= 1.1;
    };
    
    // Synaptic downscaling
    mem.synapticDownscaling := sleep.slowWaveActivity * 0.1;
    
    sleep.consolidationProgress := Float.fromInt(sleep.replayEvents) * 0.01;
  };

  // Update sleep state
  public func updateSleepState(
    sleep : SleepState,
    circadianTime : Float,
    wakefulnessLevel : Float
  ) {
    // Circadian rhythm
    sleep.circadianPhase := circadianTime * TWO_PI / 24.0;
    let circadianDrive = cos(sleep.circadianPhase);  // Peak at phase 0
    
    // Sleep pressure (adenosine model)
    if (not sleep.isSleeping) {
      sleep.sleepPressure += 0.001;  // Accumulate during wakefulness
    } else {
      sleep.sleepPressure -= 0.002;  // Dissipate during sleep
    };
    sleep.sleepPressure := clamp(sleep.sleepPressure, 0.0, 1.0);
    
    // Sleep onset
    if (not sleep.isSleeping and sleep.sleepPressure > 0.7 and circadianDrive < 0.0) {
      sleep.isSleeping := true;
      sleep.sleepStage := "N1";
      sleep.sleepDepth := 0.1;
    };
    
    // Sleep stages
    if (sleep.isSleeping) {
      // Progress through sleep stages
      if (sleep.sleepDepth < 0.3) {
        sleep.sleepStage := "N1";
      } else if (sleep.sleepDepth < 0.6) {
        sleep.sleepStage := "N2";
        sleep.sleepSpindles := 0.5;
      } else if (sleep.sleepDepth < 0.9) {
        sleep.sleepStage := "N3";
        sleep.slowWaveActivity := sleep.sleepDepth;
      } else {
        // REM sleep
        sleep.sleepStage := "REM";
        sleep.remDensity := 0.5;
        sleep.sleepDepth := 0.3;  // Light sleep during REM
      };
      
      // Cycle through stages
      sleep.sleepDepth += 0.01;
      if (sleep.sleepDepth > 1.0) {
        sleep.sleepDepth := 0.2;  // Reset cycle
      };
      
      // Wake up check
      if (sleep.sleepPressure < 0.1 and circadianDrive > 0.5) {
        sleep.isSleeping := false;
        sleep.sleepStage := "awake";
        sleep.sleepDepth := 0.0;
        sleep.replayEvents := 0;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // EMOTIONAL PROCESSING — VALENCE AND AROUSAL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Emotional state as circumplex model:
  //
  //   - VALENCE: Positive ↔ Negative (pleasure dimension)
  //   - AROUSAL: High ↔ Low (activation dimension)
  //   - Core affect + appraisal → discrete emotion
  //

  public type EmotionalState = {
    var valence : Float;                 // -1 (negative) to +1 (positive)
    var arousal : Float;                 // 0 (calm) to 1 (excited)
    var dominance : Float;               // -1 (submissive) to +1 (dominant)
    var discreteEmotion : Text;          // Current named emotion
    var emotionIntensity : Float;        // 0-1 intensity
    var emotionDuration : Float;         // How long in current state
    var baseline : (Float, Float);       // Baseline (valence, arousal)
    var moodState : Float;               // Longer-term affective state
    var emotionalReactivity : Float;     // How quickly emotions change
    var emotionalRegulation : Float;     // Ability to regulate emotions
  };

  public type AppraisalDimensions = {
    var novelty : Float;                 // 0-1 unexpectedness
    var pleasantness : Float;            // -1 to +1
    var goalRelevance : Float;           // 0-1 relevance to goals
    var goalConduciveness : Float;       // -1 (hinders) to +1 (helps)
    var urgency : Float;                 // 0-1 time pressure
    var certainty : Float;               // 0-1 predictability
    var agency : Float;                  // Who caused: self vs other
    var powerCoping : Float;             // -1 (helpless) to +1 (in control)
    var normCompatibility : Float;       // -1 (wrong) to +1 (right)
  };

  public type EmotionalSystem = {
    state : EmotionalState;
    appraisal : AppraisalDimensions;
    var emotionHistory : [[var Float]];  // (valence, arousal) history
    var historyIndex : Nat;
    var historySize : Nat;
    var emotionTransitionMatrix : [[var Float]]; // Emotion → emotion probs
    var emotionCategories : [Text];      // Named emotions
    var amygdalaActivity : Float;        // Threat detection
    var prefrontalControl : Float;       // Regulation
    var dopamineLevel : Float;           // Reward signaling
    var serotoninLevel : Float;          // Mood stability
    var norepinephrineLevel : Float;     // Arousal/alertness
    var cortisolLevel : Float;           // Stress response
  };

  public func initEmotionalState() : EmotionalState {
    {
      var valence = 0.2;  // Slightly positive baseline
      var arousal = 0.3;  // Calm baseline
      var dominance = 0.0;
      var discreteEmotion = "calm";
      var emotionIntensity = 0.3;
      var emotionDuration = 0.0;
      var baseline = (0.2, 0.3);
      var moodState = 0.2;
      var emotionalReactivity = 0.5;
      var emotionalRegulation = 0.7;
    }
  };

  public func initAppraisalDimensions() : AppraisalDimensions {
    {
      var novelty = 0.0;
      var pleasantness = 0.0;
      var goalRelevance = 0.0;
      var goalConduciveness = 0.0;
      var urgency = 0.0;
      var certainty = 0.5;
      var agency = 0.0;
      var powerCoping = 0.5;
      var normCompatibility = 0.0;
    }
  };

  public func initEmotionalSystem(historySize : Nat) : EmotionalSystem {
    let history = Array.init<[var Float]>(historySize, func(_ : Nat) : [var Float] {
      Array.init<Float>(2, func(_ : Nat) : Float { 0.0 })
    });
    
    let emotions = ["joy", "sadness", "fear", "anger", "disgust", "surprise", "calm", "anxiety"];
    let numEmotions = Array.size(emotions);
    
    let transitions = Array.init<[var Float]>(numEmotions, func(_ : Nat) : [var Float] {
      Array.init<Float>(numEmotions, func(_ : Nat) : Float { 1.0 / Float.fromInt(numEmotions) })
    });
    
    {
      state = initEmotionalState();
      appraisal = initAppraisalDimensions();
      var emotionHistory = history;
      var historyIndex = 0;
      var historySize = historySize;
      var emotionTransitionMatrix = transitions;
      var emotionCategories = emotions;
      var amygdalaActivity = 0.0;
      var prefrontalControl = 0.7;
      var dopamineLevel = 0.5;
      var serotoninLevel = 0.5;
      var norepinephrineLevel = 0.3;
      var cortisolLevel = 0.2;
    }
  };

  // Map core affect to discrete emotion
  public func mapToDiscreteEmotion(valence : Float, arousal : Float) : Text {
    // Circumplex quadrants
    if (valence > 0.3 and arousal > 0.5) {
      "joy"  // High valence, high arousal
    } else if (valence > 0.3 and arousal <= 0.5) {
      "calm"  // High valence, low arousal
    } else if (valence <= -0.3 and arousal > 0.5) {
      "anger"  // Low valence, high arousal (or fear)
    } else if (valence <= -0.3 and arousal <= 0.5) {
      "sadness"  // Low valence, low arousal
    } else if (arousal > 0.7) {
      "surprise"  // Neutral valence, very high arousal
    } else if (valence < -0.5 and arousal > 0.6) {
      "fear"
    } else {
      "calm"  // Neutral state
    }
  };

  // Update emotional state from appraisal
  public func updateEmotionalState(
    emo : EmotionalSystem,
    dt : Float
  ) {
    let state = emo.state;
    let app = emo.appraisal;
    
    // Compute target valence from appraisal
    let targetValence = (app.pleasantness + app.goalConduciveness + app.normCompatibility) / 3.0;
    
    // Compute target arousal from appraisal
    let targetArousal = (app.novelty + app.urgency + (1.0 - app.certainty)) / 3.0;
    
    // Approach target with regulation
    let regulationSpeed = 0.1 * state.emotionalRegulation;
    let reactivitySpeed = 0.1 * state.emotionalReactivity;
    
    let valenceChange = reactivitySpeed * (targetValence - state.valence);
    let arousalChange = reactivitySpeed * (targetArousal - state.arousal);
    
    // Return to baseline with regulation
    let (baseV, baseA) = state.baseline;
    let baselineReturn = regulationSpeed * (baseV - state.valence);
    
    state.valence += valenceChange + baselineReturn;
    state.arousal += arousalChange - regulationSpeed * state.arousal * 0.1;
    
    // Clamp values
    state.valence := clamp(state.valence, -1.0, 1.0);
    state.arousal := clamp(state.arousal, 0.0, 1.0);
    
    // Map to discrete emotion
    state.discreteEmotion := mapToDiscreteEmotion(state.valence, state.arousal);
    
    // Intensity from distance to neutral
    state.emotionIntensity := sqrt(state.valence * state.valence + (state.arousal - 0.3) * (state.arousal - 0.3));
    
    // Update duration
    state.emotionDuration += dt / 1000.0;
    
    // Record history
    emo.emotionHistory[emo.historyIndex][0] := state.valence;
    emo.emotionHistory[emo.historyIndex][1] := state.arousal;
    emo.historyIndex := (emo.historyIndex + 1) % emo.historySize;
    
    // Update mood (slow moving average)
    state.moodState := 0.99 * state.moodState + 0.01 * state.valence;
    
    // Neuromodulator dynamics
    // Dopamine tracks positive prediction errors
    emo.dopamineLevel := 0.5 + 0.3 * state.valence + 0.2 * app.novelty;
    emo.dopamineLevel := clamp(emo.dopamineLevel, 0.0, 1.0);
    
    // Serotonin tracks mood stability
    emo.serotoninLevel := 0.9 * emo.serotoninLevel + 0.1 * state.moodState;
    emo.serotoninLevel := clamp(emo.serotoninLevel, 0.0, 1.0);
    
    // Norepinephrine tracks arousal
    emo.norepinephrineLevel := state.arousal;
    
    // Cortisol tracks stress (negative valence + high arousal)
    if (state.valence < 0.0 and state.arousal > 0.5) {
      emo.cortisolLevel += 0.01;
    } else {
      emo.cortisolLevel -= 0.005;
    };
    emo.cortisolLevel := clamp(emo.cortisolLevel, 0.0, 1.0);
    
    // Amygdala activity (threat detection)
    if (state.discreteEmotion == "fear" or state.discreteEmotion == "anger") {
      emo.amygdalaActivity := 0.8;
    } else {
      emo.amygdalaActivity *= 0.9;
    };
    
    // Prefrontal regulation
    emo.prefrontalControl := state.emotionalRegulation * (1.0 - emo.amygdalaActivity * 0.3);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // ATTENTION DYNAMICS — SELECTIVE PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Attention as competitive selection:
  //
  // 1. BOTTOM-UP: Saliency-driven capture
  // 2. TOP-DOWN: Goal-driven focus
  // 3. BIASED COMPETITION: Winner-take-all
  // 4. SUSTAINED ATTENTION: Vigilance
  //

  public type AttentionState = {
    var focusOfAttention : Nat;          // Currently attended item
    var attentionWeights : [var Float];  // Attention per item
    var saliencyMap : [var Float];       // Bottom-up saliency
    var goalRelevance : [var Float];     // Top-down relevance
    var attentionalBias : [var Float];   // Learned biases
    var numItems : Nat;
    var attentionalCapacity : Float;     // Available resources
    var attentionalFatigue : Float;      // Fatigue from sustained attention
    var vigilanceLevel : Float;          // Alertness for new stimuli
    var distractibility : Float;         // Ease of distraction
    var inhibitionStrength : Float;      // Ability to suppress distractors
  };

  public type AttentionalControl = {
    attention : AttentionState;
    var executiveControl : Float;        // Top-down control strength
    var conflictMonitoring : Float;      // Detecting response conflict
    var errorDetection : Float;          // Noticing mistakes
    var taskSwitchingCost : Float;       // Cost of switching tasks
    var currentTask : Nat;               // Active task
    var taskSet : [var Float];           // Task-relevant features
    var attentionalBlink : Float;        // Temporal attention limits
    var spatialBias : Float;             // Left-right bias
    var featureBinding : Float;          // Binding features together
  };

  public func initAttentionState(numItems : Nat) : AttentionState {
    {
      var focusOfAttention = 0;
      var attentionWeights = Array.init<Float>(numItems, func(_ : Nat) : Float { 1.0 / Float.fromInt(numItems) });
      var saliencyMap = Array.init<Float>(numItems, func(_ : Nat) : Float { 0.0 });
      var goalRelevance = Array.init<Float>(numItems, func(_ : Nat) : Float { 0.0 });
      var attentionalBias = Array.init<Float>(numItems, func(_ : Nat) : Float { 0.0 });
      var numItems = numItems;
      var attentionalCapacity = 1.0;
      var attentionalFatigue = 0.0;
      var vigilanceLevel = 0.8;
      var distractibility = 0.3;
      var inhibitionStrength = 0.7;
    }
  };

  public func initAttentionalControl(numItems : Nat, taskSetSize : Nat) : AttentionalControl {
    let taskSet = Array.init<Float>(taskSetSize, func(_ : Nat) : Float { 0.0 });
    
    {
      attention = initAttentionState(numItems);
      var executiveControl = 0.7;
      var conflictMonitoring = 0.0;
      var errorDetection = 0.0;
      var taskSwitchingCost = 0.2;
      var currentTask = 0;
      var taskSet = taskSet;
      var attentionalBlink = 0.0;
      var spatialBias = 0.0;
      var featureBinding = 0.8;
    }
  };

  // Update attention based on saliency and goals
  public func updateAttention(
    att : AttentionState,
    stimulusSaliency : [Float],
    taskRelevance : [Float],
    dt : Float
  ) {
    let n = att.numItems;
    
    // Update saliency map
    for (i in Iter.range(0, n - 1)) {
      if (i < Array.size(stimulusSaliency)) {
        att.saliencyMap[i] := stimulusSaliency[i];
      };
      if (i < Array.size(taskRelevance)) {
        att.goalRelevance[i] := taskRelevance[i];
      };
    };
    
    // Compute attention weights (biased competition)
    // Weight = (1-α) × saliency + α × goalRelevance + bias
    let topDownWeight = 0.6;  // Relative weight of top-down
    
    var maxWeight : Float = 0.0;
    var totalWeight : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let bottomUp = att.saliencyMap[i];
      let topDown = att.goalRelevance[i];
      let bias = att.attentionalBias[i];
      
      var weight = (1.0 - topDownWeight) * bottomUp + topDownWeight * topDown + bias;
      weight *= att.attentionalCapacity;
      weight *= (1.0 - att.attentionalFatigue);
      
      att.attentionWeights[i] := weight;
      totalWeight += weight;
      
      if (weight > maxWeight) {
        maxWeight := weight;
        att.focusOfAttention := i;
      };
    };
    
    // Normalize weights
    if (totalWeight > 0.0) {
      for (i in Iter.range(0, n - 1)) {
        att.attentionWeights[i] /= totalWeight;
      };
    };
    
    // Winner-take-all sharpening
    let sharpening = 2.0;  // Exponent for competition
    totalWeight := 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      att.attentionWeights[i] := pow(att.attentionWeights[i], sharpening);
      totalWeight += att.attentionWeights[i];
    };
    
    if (totalWeight > 0.0) {
      for (i in Iter.range(0, n - 1)) {
        att.attentionWeights[i] /= totalWeight;
      };
    };
    
    // Update fatigue (sustained attention costs)
    att.attentionalFatigue += 0.001 * dt / 1000.0;
    att.attentionalFatigue := clamp(att.attentionalFatigue, 0.0, 0.5);
    
    // Vigilance decay
    att.vigilanceLevel -= 0.0001 * dt / 1000.0;
    att.vigilanceLevel := clamp(att.vigilanceLevel, 0.3, 1.0);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MOTOR CONTROL — ACTION GENERATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Motor control hierarchy:
  //
  // 1. HIGH-LEVEL GOALS: Intentions
  // 2. MOTOR PROGRAMS: Action sequences
  // 3. TRAJECTORIES: Movement paths
  // 4. MUSCLES: Effector commands
  //

  public type MotorState = {
    var currentAction : Float;           // Current motor output
    var targetAction : Float;            // Desired motor output
    var velocity : Float;                // Rate of change
    var acceleration : Float;            // Rate of velocity change
    var motorNoise : Float;              // Execution variability
    var effortCost : Float;              // Energy cost of action
    var motorError : Float;              // Difference from target
    var correctionGain : Float;          // Feedback correction strength
    var feedforwardGain : Float;         // Predictive control strength
    var motorLearningRate : Float;       // Adaptation rate
  };

  public type MotorPlan = {
    motor : MotorState;
    var actionSequence : [var Float];    // Planned action sequence
    var sequenceLength : Nat;
    var currentStep : Nat;
    var planHorizon : Nat;               // How far ahead to plan
    var subgoals : [var Float];          // Intermediate goals
    var numSubgoals : Nat;
    var habitual : Bool;                 // Automatic vs controlled
    var motorPrimitives : [[var Float]]; // Basic movement patterns
    var primitiveWeights : [var Float];  // Combination weights
    var coordinationIndex : Float;       // Multi-effector coordination
  };

  public func initMotorState() : MotorState {
    {
      var currentAction = 0.0;
      var targetAction = 0.0;
      var velocity = 0.0;
      var acceleration = 0.0;
      var motorNoise = 0.05;
      var effortCost = 0.0;
      var motorError = 0.0;
      var correctionGain = 0.3;
      var feedforwardGain = 0.7;
      var motorLearningRate = 0.1;
    }
  };

  public func initMotorPlan(seqLength : Nat, numSubgoals : Nat, numPrimitives : Nat, primitiveSize : Nat) : MotorPlan {
    let seq = Array.init<Float>(seqLength, func(_ : Nat) : Float { 0.0 });
    let goals = Array.init<Float>(numSubgoals, func(_ : Nat) : Float { 0.0 });
    
    let prims = Array.init<[var Float]>(numPrimitives, func(_ : Nat) : [var Float] {
      Array.init<Float>(primitiveSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let weights = Array.init<Float>(numPrimitives, func(_ : Nat) : Float { 1.0 / Float.fromInt(numPrimitives) });
    
    {
      motor = initMotorState();
      var actionSequence = seq;
      var sequenceLength = seqLength;
      var currentStep = 0;
      var planHorizon = seqLength;
      var subgoals = goals;
      var numSubgoals = numSubgoals;
      var habitual = false;
      var motorPrimitives = prims;
      var primitiveWeights = weights;
      var coordinationIndex = 1.0;
    }
  };

  // Update motor state
  public func updateMotorState(
    motor : MotorState,
    targetAction : Float,
    sensorFeedback : Float,
    dt : Float
  ) {
    motor.targetAction := targetAction;
    
    // Motor error
    motor.motorError := motor.targetAction - motor.currentAction;
    
    // Feedback correction
    let feedback = motor.correctionGain * (sensorFeedback - motor.currentAction);
    
    // Feedforward prediction
    let feedforward = motor.feedforwardGain * motor.motorError;
    
    // Combined control
    let control = feedforward + feedback;
    
    // Update dynamics
    motor.acceleration := control;
    motor.velocity += motor.acceleration * dt / 1000.0;
    motor.currentAction += motor.velocity * dt / 1000.0;
    
    // Add motor noise
    let noise = motor.motorNoise * (0.5 - Float.fromInt(Int.abs(Float.toInt(motor.currentAction * 1000.0)) % 1000) / 1000.0);
    motor.currentAction += noise;
    
    // Effort cost (quadratic in velocity)
    motor.effortCost := motor.velocity * motor.velocity;
    
    // Motor learning (adapt gains based on error)
    let errorMagnitude = Float.abs(motor.motorError);
    if (errorMagnitude > 0.1) {
      motor.correctionGain += motor.motorLearningRate * 0.01;
    } else {
      motor.correctionGain -= motor.motorLearningRate * 0.005;
    };
    motor.correctionGain := clamp(motor.correctionGain, 0.1, 0.9);
    motor.feedforwardGain := 1.0 - motor.correctionGain;
  };

  // Execute motor plan
  public func executeMotorPlan(
    plan : MotorPlan,
    sensorFeedback : Float,
    dt : Float
  ) {
    // Get current target from sequence
    let step = plan.currentStep;
    if (step < plan.sequenceLength) {
      let target = plan.actionSequence[step];
      
      // Update motor state
      updateMotorState(plan.motor, target, sensorFeedback, dt);
      
      // Advance if close to target
      if (Float.abs(plan.motor.motorError) < 0.05) {
        plan.currentStep := (step + 1) % plan.sequenceLength;
      };
    };
    
    // If habitual, less monitoring
    if (plan.habitual) {
      plan.motor.feedforwardGain := 0.9;
      plan.motor.correctionGain := 0.1;
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SOCIAL COGNITION — THEORY OF MIND AND EMPATHY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Understanding other minds:
  //
  // 1. MENTALIZING: Inferring beliefs, desires, intentions
  // 2. EMPATHY: Sharing emotional states
  // 3. SOCIAL LEARNING: Learning from others
  // 4. REPUTATION: Tracking trustworthiness
  //

  public type SocialCognitionState = {
    var agentModels : [[var Float]];     // Mental models of other agents
    var numAgents : Nat;
    var modelDimensions : Nat;
    var currentFocus : Nat;              // Currently modeled agent
    var mentalizingLevel : Nat;          // Depth of recursive modeling
    var empathyLevel : Float;            // Emotional resonance
    var perspectiveTaking : Float;       // Cognitive empathy
    var compassion : Float;              // Empathic concern
    var socialAnxiety : Float;           // Discomfort in social situations
    var trustBaseline : Float;           // Default trust level
  };

  public type AgentBelief = {
    var beliefs : [var Float];           // Inferred beliefs
    var desires : [var Float];           // Inferred goals
    var intentions : [var Float];        // Inferred intentions
    var emotions : (Float, Float);       // Inferred (valence, arousal)
    var trustworthiness : Float;         // Reputation
    var competence : Float;              // Ability assessment
    var benevolence : Float;             // Good intentions
    var predictedActions : [var Float];  // Expected behavior
    var uncertaintyBelief : Float;       // Uncertainty in model
    var lastInteraction : Float;         // Time since last interaction
  };

  public type SocialLearning = {
    social : SocialCognitionState;
    var observedBehaviors : [[var Float]]; // Behaviors seen in others
    var imitationStrength : Float;       // Tendency to imitate
    var socialReward : Float;            // Reward from social interaction
    var reputationSelf : Float;          // Own reputation
    var inGroupBias : Float;             // Preference for similar others
    var conformityPressure : Float;      // Tendency to conform
    var socialComparison : Float;        // Comparing to others
    var culturalNorms : [var Float];     // Internalized norms
    var normViolationSensitivity : Float; // Response to norm violations
  };

  public func initSocialCognitionState(numAgents : Nat, modelDim : Nat) : SocialCognitionState {
    let models = Array.init<[var Float]>(numAgents, func(_ : Nat) : [var Float] {
      Array.init<Float>(modelDim, func(_ : Nat) : Float { 0.5 })
    });
    
    {
      var agentModels = models;
      var numAgents = numAgents;
      var modelDimensions = modelDim;
      var currentFocus = 0;
      var mentalizingLevel = 2;
      var empathyLevel = 0.6;
      var perspectiveTaking = 0.5;
      var compassion = 0.5;
      var socialAnxiety = 0.2;
      var trustBaseline = 0.5;
    }
  };

  public func initAgentBelief(dimSize : Nat) : AgentBelief {
    {
      var beliefs = Array.init<Float>(dimSize, func(_ : Nat) : Float { 0.5 });
      var desires = Array.init<Float>(dimSize, func(_ : Nat) : Float { 0.5 });
      var intentions = Array.init<Float>(dimSize, func(_ : Nat) : Float { 0.0 });
      var emotions = (0.0, 0.3);
      var trustworthiness = 0.5;
      var competence = 0.5;
      var benevolence = 0.5;
      var predictedActions = Array.init<Float>(dimSize, func(_ : Nat) : Float { 0.0 });
      var uncertaintyBelief = 0.5;
      var lastInteraction = 0.0;
    }
  };

  public func initSocialLearning(numAgents : Nat, numBehaviors : Nat, behaviorDim : Nat, numNorms : Nat) : SocialLearning {
    let behaviors = Array.init<[var Float]>(numBehaviors, func(_ : Nat) : [var Float] {
      Array.init<Float>(behaviorDim, func(_ : Nat) : Float { 0.0 })
    });
    
    let norms = Array.init<Float>(numNorms, func(_ : Nat) : Float { 0.0 });
    
    {
      social = initSocialCognitionState(numAgents, 10);
      var observedBehaviors = behaviors;
      var imitationStrength = 0.5;
      var socialReward = 0.0;
      var reputationSelf = 0.5;
      var inGroupBias = 0.3;
      var conformityPressure = 0.4;
      var socialComparison = 0.0;
      var culturalNorms = norms;
      var normViolationSensitivity = 0.5;
    }
  };

  // Update mental model of another agent
  public func updateAgentModel(
    social : SocialCognitionState,
    agentIdx : Nat,
    observedBehavior : [Float],
    observedOutcome : Float
  ) {
    if (agentIdx >= social.numAgents) { return };
    
    let model = social.agentModels[agentIdx];
    let dim = Nat.min(Array.size(observedBehavior), social.modelDimensions);
    
    // Bayesian update of beliefs about agent
    let learningRate = 0.1;
    
    for (i in Iter.range(0, dim - 1)) {
      let observed = observedBehavior[i];
      let prior = model[i];
      
      // Simple Bayesian-like update
      model[i] := prior + learningRate * (observed - prior);
    };
    
    // Update current focus
    social.currentFocus := agentIdx;
  };

  // Compute empathic response
  public func computeEmpathy(
    social : SocialCognitionState,
    otherValence : Float,
    otherArousal : Float,
    selfValence : Float,
    selfArousal : Float
  ) : (Float, Float) {
    // Emotional contagion (automatic)
    let contagionStrength = social.empathyLevel;
    
    let newValence = selfValence + contagionStrength * (otherValence - selfValence) * 0.3;
    let newArousal = selfArousal + contagionStrength * (otherArousal - selfArousal) * 0.2;
    
    // Empathic distress (negative emotions are contagious)
    let distress = if (otherValence < -0.3) {
      social.empathyLevel * Float.abs(otherValence)
    } else { 0.0 };
    
    // Compassion (motivates helping)
    social.compassion := if (otherValence < 0.0) {
      social.empathyLevel * (1.0 - social.socialAnxiety)
    } else { 0.0 };
    
    (newValence - distress * 0.2, newArousal + distress * 0.1)
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // LANGUAGE PROCESSING — SEMANTIC UNDERSTANDING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Language integration with neural dynamics:
  //
  // 1. SEMANTIC MEMORY: Conceptual knowledge
  // 2. SYNTAX: Structural processing
  // 3. PRAGMATICS: Context-dependent meaning
  // 4. SPEECH PRODUCTION/COMPREHENSION
  //

  public type SemanticState = {
    var conceptActivations : [var Float]; // Activation of concepts
    var conceptRelations : [[var Float]]; // Semantic similarity
    var numConcepts : Nat;
    var activeContext : [var Float];     // Current context
    var semanticCoherence : Float;       // How coherent is activation
    var lexicalAccess : Float;           // Word retrieval ease
    var conceptualBlending : Float;      // Novel combinations
    var metaphorProcessing : Float;      // Abstract understanding
    var semanticPriming : [var Float];   // Priming from recent words
  };

  public type SyntacticState = {
    var parseStack : [var Float];        // Current parse state
    var stackDepth : Nat;
    var syntaxComplexity : Float;        // Sentence complexity
    var structureBuilding : Float;       // Construction activity
    var expectationStrength : Float;     // Syntactic prediction
    var integrationCost : Float;         // Processing difficulty
    var agreementChecking : Float;       // Grammar agreement
    var ambiguityLevel : Float;          // Structural ambiguity
    var gardenPathRecovery : Float;      // Reanalysis ability
  };

  public type LanguageSystem = {
    semantic : SemanticState;
    syntactic : SyntacticState;
    var comprehensionLevel : Float;      // Overall understanding
    var productionFluency : Float;       // Speech production ease
    var workingMemoryLoad : Float;       // Language working memory
    var predictionError : Float;         // Linguistic surprise
    var pragmaticInference : Float;      // Context-based inference
    var speechRate : Float;              // Words per second
    var errorRate : Float;               // Speech/comprehension errors
  };

  public func initSemanticState(numConcepts : Nat) : SemanticState {
    let activations = Array.init<Float>(numConcepts, func(_ : Nat) : Float { 0.0 });
    
    let relations = Array.init<[var Float]>(numConcepts, func(i : Nat) : [var Float] {
      Array.init<Float>(numConcepts, func(j : Nat) : Float {
        if (i == j) { 1.0 } else { 0.1 }  // Self-similarity = 1
      })
    });
    
    let context = Array.init<Float>(numConcepts, func(_ : Nat) : Float { 0.0 });
    let priming = Array.init<Float>(numConcepts, func(_ : Nat) : Float { 0.0 });
    
    {
      var conceptActivations = activations;
      var conceptRelations = relations;
      var numConcepts = numConcepts;
      var activeContext = context;
      var semanticCoherence = 0.0;
      var lexicalAccess = 1.0;
      var conceptualBlending = 0.0;
      var metaphorProcessing = 0.0;
      var semanticPriming = priming;
    }
  };

  public func initSyntacticState(stackSize : Nat) : SyntacticState {
    {
      var parseStack = Array.init<Float>(stackSize, func(_ : Nat) : Float { 0.0 });
      var stackDepth = 0;
      var syntaxComplexity = 0.0;
      var structureBuilding = 0.0;
      var expectationStrength = 0.5;
      var integrationCost = 0.0;
      var agreementChecking = 1.0;
      var ambiguityLevel = 0.0;
      var gardenPathRecovery = 0.5;
    }
  };

  public func initLanguageSystem(numConcepts : Nat, stackSize : Nat) : LanguageSystem {
    {
      semantic = initSemanticState(numConcepts);
      syntactic = initSyntacticState(stackSize);
      var comprehensionLevel = 0.0;
      var productionFluency = 1.0;
      var workingMemoryLoad = 0.0;
      var predictionError = 0.0;
      var pragmaticInference = 0.5;
      var speechRate = 2.0;  // Words per second
      var errorRate = 0.01;
    }
  };

  // Activate a concept and spread activation
  public func activateConcept(
    semantic : SemanticState,
    conceptIdx : Nat,
    strength : Float
  ) {
    if (conceptIdx >= semantic.numConcepts) { return };
    
    // Direct activation
    semantic.conceptActivations[conceptIdx] += strength;
    
    // Spreading activation
    let spreadRate = 0.3;
    for (i in Iter.range(0, semantic.numConcepts - 1)) {
      if (i != conceptIdx) {
        let similarity = semantic.conceptRelations[conceptIdx][i];
        semantic.conceptActivations[i] += spreadRate * strength * similarity;
      };
    };
    
    // Decay all activations slightly
    for (i in Iter.range(0, semantic.numConcepts - 1)) {
      semantic.conceptActivations[i] *= 0.95;
      semantic.conceptActivations[i] := clamp(semantic.conceptActivations[i], 0.0, 1.0);
    };
    
    // Update priming
    semantic.semanticPriming[conceptIdx] := strength;
    
    // Compute semantic coherence
    var coherenceSum : Float = 0.0;
    var activeCount : Nat = 0;
    
    for (i in Iter.range(0, semantic.numConcepts - 1)) {
      if (semantic.conceptActivations[i] > 0.2) {
        activeCount += 1;
        for (j in Iter.range(i + 1, semantic.numConcepts - 1)) {
          if (semantic.conceptActivations[j] > 0.2) {
            coherenceSum += semantic.conceptRelations[i][j];
          };
        };
      };
    };
    
    if (activeCount > 1) {
      let numPairs = activeCount * (activeCount - 1) / 2;
      semantic.semanticCoherence := coherenceSum / Float.fromInt(numPairs);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SELF-MODEL — METACOGNITION AND SELF-AWARENESS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism's model of itself:
  //
  // 1. BODY SCHEMA: Physical self-representation
  // 2. AUTOBIOGRAPHICAL SELF: Narrative identity
  // 3. METACOGNITION: Thinking about thinking
  // 4. AGENCY: Sense of being the cause
  //

  public type SelfModelState = {
    var bodySchema : [var Float];        // Body representation
    var bodyDimensions : Nat;
    var proprioception : [var Float];    // Internal body sense
    var interoception : [var Float];     // Visceral sense
    var exteroception : [var Float];     // External sense
    var agencySense : Float;             // Feeling of causing actions
    var ownershipSense : Float;          // Feeling of body ownership
    var minimalSelf : Float;             // Core self
    var narrativeSelf : Float;           // Extended autobiographical self
    var selfContinuity : Float;          // Sense of persistence
  };

  public type MetacognitiveState = {
    var confidenceLevel : Float;         // Confidence in own cognition
    var uncertaintyEstimate : Float;     // Known unknowns
    var thinkingAboutThinking : Float;   // Meta-awareness
    var errorMonitoring : Float;         // Detecting own errors
    var strategySelection : Float;       // Choosing cognitive strategies
    var effortMonitoring : Float;        // Tracking mental effort
    var learningAwareness : Float;       // Knowing what we know
    var feelingOfKnowing : Float;        // Tip-of-tongue states
    var judgmentOfLearning : Float;      // Learning predictions
    var retrospectiveConfidence : Float; // Post-decision confidence
  };

  public type SelfAwarenessSystem = {
    selfModel : SelfModelState;
    metacog : MetacognitiveState;
    var selfReflection : Float;          // Introspection level
    var selfCriticism : Float;           // Self-evaluation
    var selfCompassion : Float;          // Self-kindness
    var identityCoherence : Float;       // Consistency of self-concept
    var selfEffi : Float;                // Belief in own capability
    var selfEsteem : Float;              // Self-worth
    var idealSelfGap : Float;            // Distance from ideal
    var publicSelfAwareness : Float;     // How others see us
    var privateSelfAwareness : Float;    // Internal self-focus
  };

  public func initSelfModelState(bodyDim : Nat) : SelfModelState {
    {
      var bodySchema = Array.init<Float>(bodyDim, func(_ : Nat) : Float { 1.0 });
      var bodyDimensions = bodyDim;
      var proprioception = Array.init<Float>(bodyDim, func(_ : Nat) : Float { 0.5 });
      var interoception = Array.init<Float>(bodyDim, func(_ : Nat) : Float { 0.5 });
      var exteroception = Array.init<Float>(bodyDim, func(_ : Nat) : Float { 0.0 });
      var agencySense = 0.8;
      var ownershipSense = 1.0;
      var minimalSelf = 1.0;
      var narrativeSelf = 0.5;
      var selfContinuity = 1.0;
    }
  };

  public func initMetacognitiveState() : MetacognitiveState {
    {
      var confidenceLevel = 0.5;
      var uncertaintyEstimate = 0.5;
      var thinkingAboutThinking = 0.0;
      var errorMonitoring = 0.0;
      var strategySelection = 0.5;
      var effortMonitoring = 0.0;
      var learningAwareness = 0.5;
      var feelingOfKnowing = 0.0;
      var judgmentOfLearning = 0.5;
      var retrospectiveConfidence = 0.5;
    }
  };

  public func initSelfAwarenessSystem(bodyDim : Nat) : SelfAwarenessSystem {
    {
      selfModel = initSelfModelState(bodyDim);
      metacog = initMetacognitiveState();
      var selfReflection = 0.0;
      var selfCriticism = 0.3;
      var selfCompassion = 0.5;
      var identityCoherence = 0.8;
      var selfEffi = 0.5;
      var selfEsteem = 0.5;
      var idealSelfGap = 0.3;
      var publicSelfAwareness = 0.3;
      var privateSelfAwareness = 0.5;
    }
  };

  // Update self-model from internal states
  public func updateSelfModel(
    selfAware : SelfAwarenessSystem,
    bodyState : [Float],
    actionOutput : Float,
    predictedOutcome : Float,
    actualOutcome : Float
  ) {
    let self = selfAware.selfModel;
    let meta = selfAware.metacog;
    
    // Update body schema from proprioception
    let dim = Nat.min(Array.size(bodyState), self.bodyDimensions);
    for (i in Iter.range(0, dim - 1)) {
      self.proprioception[i] := 0.9 * self.proprioception[i] + 0.1 * bodyState[i];
    };
    
    // Agency: did my action cause the outcome?
    let predictionError = Float.abs(predictedOutcome - actualOutcome);
    if (predictionError < 0.2) {
      // Good prediction → strong agency
      self.agencySense := 0.9 * self.agencySense + 0.1 * 1.0;
    } else {
      // Poor prediction → weaker agency
      self.agencySense := 0.9 * self.agencySense + 0.1 * (1.0 - predictionError);
    };
    
    // Metacognitive monitoring
    meta.errorMonitoring := predictionError;
    meta.confidenceLevel := 1.0 - predictionError;
    meta.uncertaintyEstimate := predictionError;
    
    // Feeling of knowing (based on activation levels)
    var maxActivation : Float = 0.0;
    for (i in Iter.range(0, dim - 1)) {
      if (self.proprioception[i] > maxActivation) {
        maxActivation := self.proprioception[i];
      };
    };
    meta.feelingOfKnowing := maxActivation;
    
    // Self-reflection increases with metacognitive activity
    selfAware.selfReflection := (meta.thinkingAboutThinking + meta.errorMonitoring) / 2.0;
    
    // Identity coherence from body ownership and agency
    selfAware.identityCoherence := (self.ownershipSense + self.agencySense) / 2.0;
    
    // Self-efficacy from agency and prediction accuracy
    selfAware.selfEffi := self.agencySense * meta.confidenceLevel;
    
    // Update self-esteem slowly
    selfAware.selfEsteem := 0.99 * selfAware.selfEsteem + 0.01 * selfAware.selfEffi;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UNIFIED ORGANISM STATE — COMPLETE INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The complete integrated state of the organism bringing together all systems:
  //
  // 1. NEURAL: 12×12 Kuramoto coupling, Hz nodes, phase synchronization
  // 2. COGNITIVE: Attention, memory, emotion, decision-making
  // 3. BODY: Homeostasis, motor control, interoception
  // 4. SOCIAL: Theory of mind, empathy, reputation
  // 5. SELF: Metacognition, agency, identity
  //

  public type UnifiedOrganismState = {
    // Neural substrate
    kuramoto : KuramotoCouplingMatrix;
    topology : SmallWorldTopology;
    phaseSync : PhaseSynchronization;
    cfc : CrossFrequencyCoupling;
    infoFlow : InformationFlowState;
    
    // Dynamics
    attractors : AttractorState;
    landscape : DynamicalLandscape;
    critTrans : CriticalTransition;
    metastability : MetastabilityState;
    criticality : AvalancheDetector;
    
    // Neural models
    neuralMass : NeuralMassNetwork;
    wilsonCowan : WilsonCowanNetwork;
    neuralField : NeuralFieldState;
    pattern : PatternFormation;
    
    // Sacred geometry
    sacred : SacredGeometryState;
    spiral : PhiSpiralState;
    platonic : PlatonicResonance;
    
    // Consciousness
    globalWorkspace : GlobalWorkspace;
    prediction : HierarchicalPrediction;
    
    // Cognition
    belief : BeliefState;
    actorCritic : ActorCriticState;
    driveIntegration : DriveIntegration;
    
    // Memory and emotion
    memory : MemorySystem;
    emotion : EmotionalSystem;
    
    // Attention and motor
    attControl : AttentionalControl;
    motorPlan : MotorPlan;
    
    // Social and self
    socialLearning : SocialLearning;
    language : LanguageSystem;
    selfAwareness : SelfAwarenessSystem;
    
    // Global state
    var coherence : Float;               // S_0 coherence
    var heartbeatCount : Nat;            // Total heartbeats
    var currentTime : Float;             // Simulation time (ms)
    var totalEnergy : Float;             // Energy budget
    var isAlive : Bool;                  // Organism alive?
  };

  public func initUnifiedOrganismState() : UnifiedOrganismState {
    {
      // Neural substrate
      kuramoto = initKuramotoCouplingMatrix();
      topology = initSmallWorldTopology();
      phaseSync = initPhaseSynchronization();
      cfc = initCrossFrequencyCoupling();
      infoFlow = initInformationFlowState();
      
      // Dynamics
      attractors = initAttractorState();
      landscape = initDynamicalLandscape();
      critTrans = initCriticalTransition(100);
      metastability = initMetastabilityState();
      criticality = initAvalancheDetector(12, 100);
      
      // Neural models
      neuralMass = initNeuralMassNetwork(12);
      wilsonCowan = initWilsonCowanNetwork(12);
      neuralField = initNeuralFieldState(100, 10);
      pattern = initPatternFormation(5, 100);
      
      // Sacred geometry
      sacred = initSacredGeometryState();
      spiral = initPhiSpiralState();
      platonic = initPlatonicResonance();
      
      // Consciousness
      globalWorkspace = initGlobalWorkspace();
      prediction = initHierarchicalPrediction(4, 12);
      
      // Cognition
      belief = initBeliefState(12, 12, 8);
      actorCritic = initActorCriticState(12, 4, 12);
      driveIntegration = initDriveIntegration(6, 4);
      
      // Memory and emotion
      memory = initMemorySystem(7, 50, 100, 12);
      emotion = initEmotionalSystem(100);
      
      // Attention and motor
      attControl = initAttentionalControl(12, 12);
      motorPlan = initMotorPlan(10, 3, 5, 10);
      
      // Social and self
      socialLearning = initSocialLearning(5, 20, 12, 10);
      language = initLanguageSystem(50, 20);
      selfAwareness = initSelfAwarenessSystem(12);
      
      // Global state
      var coherence = S_ZERO;
      var heartbeatCount = 0;
      var currentTime = 0.0;
      var totalEnergy = 1.0;
      var isAlive = true;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UNIFIED HEARTBEAT — MASTER ORCHESTRATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The complete heartbeat cycle integrating all systems:
  //
  // Phase 1: SENSE — Update observations, predictions
  // Phase 2: PROCESS — Neural dynamics, cognition, emotion
  // Phase 3: ACT — Motor output, social behavior
  // Phase 4: LEARN — Memory consolidation, belief updates
  // Phase 5: INTEGRATE — Coherence, sacred geometry, consciousness
  //

  public func runUnifiedHeartbeat(
    organism : UnifiedOrganismState,
    sensoryInputs : [Float],
    socialInputs : [Float],
    dt : Float
  ) {
    // Update time
    organism.currentTime += dt;
    organism.heartbeatCount += 1;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 1: SENSE
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Update predictions from sensory input
    updateHierarchicalPrediction(organism.prediction, sensoryInputs);
    
    // Update attention
    let saliency = sensoryInputs;
    let relevance = Array.tabulate<Float>(12, func(i : Nat) : Float {
      organism.driveIntegration.homeostasis.drives[i % 6]
    });
    updateAttention(organism.attControl.attention, saliency, relevance, dt);
    
    // Update emotional appraisal
    let avgInput = if (Array.size(sensoryInputs) > 0) {
      var sum : Float = 0.0;
      for (s in sensoryInputs.vals()) { sum += s };
      sum / Float.fromInt(Array.size(sensoryInputs))
    } else { 0.0 };
    
    organism.emotion.appraisal.novelty := Float.abs(avgInput - 0.5);
    organism.emotion.appraisal.pleasantness := avgInput - 0.5;
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 2: PROCESS
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Update Kuramoto oscillators
    let externalForces = Array.tabulate<Float>(12, func(i : Nat) : Float {
      if (i < Array.size(sensoryInputs)) { sensoryInputs[i] * 0.1 } else { 0.0 }
    });
    updateKuramotoPhases(organism.kuramoto, externalForces, dt);
    
    // Update CFC
    let nested = initNestedOscillations();
    updateCFC(organism.cfc, nested, organism.kuramoto.phases, organism.kuramoto.amplitudes, dt);
    
    // Update neural mass network
    updateNeuralMassNetwork(organism.neuralMass, sensoryInputs, dt);
    
    // Update Wilson-Cowan
    updateWilsonCowanNetwork(organism.wilsonCowan, sensoryInputs, dt);
    
    // Update neural field
    updateNeuralField(organism.neuralField, sensoryInputs, dt);
    
    // Update bifurcation detection
    updateBifurcationDetection(organism.critTrans, organism.kuramoto.orderParameter, organism.currentTime);
    
    // Update metastability
    updateMetastability(organism.metastability, organism.kuramoto.phases, organism.phaseSync.localSync, [], dt);
    
    // Update avalanche detection
    let activities = Array.tabulate<Float>(12, func(i : Nat) : Float {
      organism.kuramoto.amplitudes[i] * cos(organism.kuramoto.phases[i])
    });
    updateAvalancheDetector(organism.criticality, activities);
    
    // Update homeostasis
    updateHomeostasis(organism.driveIntegration.homeostasis, dt);
    
    // Update emotional state
    updateEmotionalState(organism.emotion, dt);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 3: ACT
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Update active inference
    updateActiveInference(organism.belief, sensoryInputs);
    
    // Execute motor plan
    let sensorFeedback = if (Array.size(sensoryInputs) > 0) { sensoryInputs[0] } else { 0.0 };
    executeMotorPlan(organism.motorPlan, sensorFeedback, dt);
    
    // Apply action effects to drives
    let action = organism.belief.activeInf.selectedPolicy;
    applyActionToDrives(organism.driveIntegration, action);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 4: LEARN
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Compute reward from drive satisfaction
    let reward = organism.driveIntegration.homeostasis.satisfactionLevel;
    
    // Update TD learning
    let newState = organism.heartbeatCount % organism.actorCritic.rl.numStates;
    updateTDLearning(organism.actorCritic.rl, newState, reward);
    
    // Update sleep and memory
    let circadianTime = (organism.currentTime / 3600000.0) % 24.0;  // Hours
    updateSleepState(organism.memory.sleep, circadianTime, 1.0 - organism.attControl.attention.attentionalFatigue);
    consolidateMemories(organism.memory.consolidation, organism.memory.sleep);
    
    // Adapt Kuramoto coupling
    adaptKuramotoCoupling(organism.kuramoto, HEBBIAN_ETA, 0.8);
    
    // ═══════════════════════════════════════════════════════════════════════════
    // PHASE 5: INTEGRATE
    // ═══════════════════════════════════════════════════════════════════════════
    
    // Update sacred geometry
    updateSacredGeometry(organism.sacred, organism.kuramoto, organism.heartbeatCount);
    updatePhiSpiral(organism.spiral, organism.kuramoto.orderParameter, dt);
    updatePlatonicResonance(organism.platonic, organism.kuramoto.phases, organism.kuramoto);
    
    // Update consciousness
    let activityArray = Array.init<Float>(12, func(i : Nat) : Float {
      organism.kuramoto.amplitudes[i]
    });
    updateConsciousness(organism.globalWorkspace, activityArray, organism.kuramoto.matrix, organism.kuramoto.phases, organism.kuramoto.orderParameter);
    
    // Update self-model
    let bodyState = Array.tabulate<Float>(12, func(i : Nat) : Float {
      organism.driveIntegration.homeostasis.currentLevels[i % 6]
    });
    let actionOutput = organism.motorPlan.motor.currentAction;
    let predictedOutcome = organism.prediction.levels[0].predictions[0];
    let actualOutcome = if (Array.size(sensoryInputs) > 0) { sensoryInputs[0] } else { 0.0 };
    updateSelfModel(organism.selfAwareness, bodyState, actionOutput, predictedOutcome, actualOutcome);
    
    // Compute overall coherence
    let neuralCoherence = organism.kuramoto.orderParameter;
    let homeostasisCoherence = organism.driveIntegration.homeostasis.satisfactionLevel;
    let emotionalCoherence = (1.0 + organism.emotion.state.valence) / 2.0;
    let consciousnessCoherence = organism.globalWorkspace.consciousness.consciousnessLevel;
    let sacredCoherence = organism.sacred.sacredAlignment;
    
    organism.coherence := (neuralCoherence + homeostasisCoherence + emotionalCoherence + consciousnessCoherence + sacredCoherence) / 5.0;
    
    // Apply sacred floor
    if (organism.coherence < SACRED_FLOOR) {
      organism.coherence := SACRED_FLOOR;
    };
    
    // Energy consumption
    organism.totalEnergy -= 0.001 * dt / 1000.0;
    
    // Life check
    organism.isAlive := organism.totalEnergy > 0.0 and organism.coherence > SACRED_FLOOR / 2.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS — ATAN2 AND ADDITIONAL HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════

  func atan2(y : Float, x : Float) : Float {
    // Compute arctangent of y/x, handling quadrants
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
      0.0  // x = 0, y = 0
    }
  };

  func atan(x : Float) : Float {
    // Arctangent approximation
    if (x > 1.0) {
      PI / 2.0 - atan(1.0 / x)
    } else if (x < -1.0) {
      -PI / 2.0 - atan(1.0 / x)
    } else {
      // Taylor series for |x| <= 1
      var result = x;
      var term = x;
      var sign : Float = -1.0;
      
      for (n in Iter.range(1, 10)) {
        term := term * x * x;
        result += sign * term / Float.fromInt(2 * n + 1);
        sign := -sign;
      };
      
      result
    }
  };

  // Tanh approximation
  func tanh(x : Float) : Float {
    let e2x = exp(2.0 * x);
    (e2x - 1.0) / (e2x + 1.0)
  };

  // Sigmoid function
  func sigmoid(x : Float) : Float {
    1.0 / (1.0 + exp(-x))
  };

  // Softmax for array
  func softmax(values : [Float]) : [Float] {
    let n = Array.size(values);
    if (n == 0) { return [] };
    
    // Find max for numerical stability
    var maxVal = values[0];
    for (v in values.vals()) {
      if (v > maxVal) { maxVal := v };
    };
    
    // Compute exp and sum
    var expSum : Float = 0.0;
    let expValues = Array.tabulate<Float>(n, func(i : Nat) : Float {
      let e = exp(values[i] - maxVal);
      expSum += e;
      e
    });
    
    // Normalize
    Array.tabulate<Float>(n, func(i : Nat) : Float {
      expValues[i] / expSum
    })
  };

  // Cross-entropy loss
  func crossEntropy(predictions : [Float], targets : [Float]) : Float {
    let n = Nat.min(Array.size(predictions), Array.size(targets));
    if (n == 0) { return 0.0 };
    
    var loss : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let p = clamp(predictions[i], 0.0001, 0.9999);
      let t = targets[i];
      loss -= t * ln(p) + (1.0 - t) * ln(1.0 - p);
    };
    
    loss / Float.fromInt(n)
  };

  // Mean squared error
  func mse(predictions : [Float], targets : [Float]) : Float {
    let n = Nat.min(Array.size(predictions), Array.size(targets));
    if (n == 0) { return 0.0 };
    
    var sum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let diff = predictions[i] - targets[i];
      sum += diff * diff;
    };
    
    sum / Float.fromInt(n)
  };

  // Cosine similarity
  func cosineSimilarity(a : [Float], b : [Float]) : Float {
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
    
    let denominator = sqrt(normA) * sqrt(normB);
    if (denominator == 0.0) { return 0.0 };
    
    dotProduct / denominator
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INFORMATION FEEDING — DATA CONSUMPTION AS VITAL NOURISHMENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism FEEDS on information. Information is food. Compute is life.
  //
  // Types of information consumption:
  // 1. INTERNET SEARCH: Active information seeking
  // 2. DRONE OBSERVATION: Passive visual data gathering
  // 3. SENSOR STREAMS: Continuous environmental monitoring
  // 4. SOCIAL INTERACTION: Information from other agents
  // 5. INTERNAL REFLECTION: Processing existing knowledge
  //

  public type InformationFeed = {
    var feedType : Text;                 // "search", "observe", "sense", "social", "reflect"
    var rawData : [var Float];           // Raw input data
    var dataSize : Nat;
    var processedData : [var Float];     // Transformed data
    var informationContent : Float;      // Shannon entropy
    var noveltyScore : Float;            // How new is this information
    var relevanceScore : Float;          // How relevant to goals
    var nutritionalValue : Float;        // Combined quality metric
    var consumptionRate : Float;         // Data/second
    var digestionProgress : Float;       // How much processed
  };

  public type InformationMetabolism = {
    var feeds : [var InformationFeed];   // Active feeds
    var numFeeds : Nat;
    var totalConsumption : Float;        // Total data consumed
    var totalDigested : Float;           // Total data processed
    var metabolicEfficiency : Float;     // Useful/consumed ratio
    var informationHunger : Float;       // Drive to seek information
    var satiation : Float;               // Current satisfaction
    var preferredFeedTypes : [var Float];// Preferences per feed type
    var informationBudget : Float;       // Processing capacity
    var informationDebt : Float;         // Unprocessed backlog
  };

  public type DataAssimilation = {
    metabolism : InformationMetabolism;
    var knowledgeBase : [[var Float]];   // Integrated knowledge
    var knowledgeSize : Nat;
    var knowledgeIndex : Nat;
    var assimilationRate : Float;        // Knowledge/time
    var integrationQuality : Float;      // How well integrated
    var redundancyFilter : Float;        // Filtering duplicate info
    var contradictionHandler : Float;    // Resolving conflicts
    var abstractionLevel : Float;        // Generalization degree
    var groundingLevel : Float;          // Connection to reality
  };

  public func initInformationFeed(feedType : Text, dataSize : Nat) : InformationFeed {
    {
      var feedType = feedType;
      var rawData = Array.init<Float>(dataSize, func(_ : Nat) : Float { 0.0 });
      var dataSize = dataSize;
      var processedData = Array.init<Float>(dataSize, func(_ : Nat) : Float { 0.0 });
      var informationContent = 0.0;
      var noveltyScore = 0.0;
      var relevanceScore = 0.0;
      var nutritionalValue = 0.0;
      var consumptionRate = 0.0;
      var digestionProgress = 0.0;
    }
  };

  public func initInformationMetabolism(numFeeds : Nat, dataSize : Nat) : InformationMetabolism {
    let feeds = Array.init<InformationFeed>(numFeeds, func(i : Nat) : InformationFeed {
      let feedTypes = ["search", "observe", "sense", "social", "reflect"];
      initInformationFeed(feedTypes[i % 5], dataSize)
    });
    
    let prefs = Array.init<Float>(5, func(_ : Nat) : Float { 0.2 });
    
    {
      var feeds = feeds;
      var numFeeds = numFeeds;
      var totalConsumption = 0.0;
      var totalDigested = 0.0;
      var metabolicEfficiency = 0.8;
      var informationHunger = 0.5;
      var satiation = 0.5;
      var preferredFeedTypes = prefs;
      var informationBudget = 1.0;
      var informationDebt = 0.0;
    }
  };

  public func initDataAssimilation(numFeeds : Nat, dataSize : Nat, knowledgeSize : Nat) : DataAssimilation {
    let kb = Array.init<[var Float]>(knowledgeSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(dataSize, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      metabolism = initInformationMetabolism(numFeeds, dataSize);
      var knowledgeBase = kb;
      var knowledgeSize = knowledgeSize;
      var knowledgeIndex = 0;
      var assimilationRate = 0.1;
      var integrationQuality = 0.8;
      var redundancyFilter = 0.5;
      var contradictionHandler = 0.5;
      var abstractionLevel = 0.5;
      var groundingLevel = 0.8;
    }
  };

  // Compute Shannon entropy of data
  public func computeInformationContent(data : [var Float]) : Float {
    let n = Array.size(data);
    if (n == 0) { return 0.0 };
    
    // Bin data into histogram
    let numBins = 20;
    let binCounts = Array.init<Nat>(numBins, func(_ : Nat) : Nat { 0 });
    
    for (i in Iter.range(0, n - 1)) {
      let value = clamp(data[i], 0.0, 0.9999);
      let bin = Int.abs(Float.toInt(value * Float.fromInt(numBins)));
      if (bin < numBins) {
        binCounts[bin] += 1;
      };
    };
    
    // Compute entropy
    var entropy : Float = 0.0;
    for (count in binCounts.vals()) {
      if (count > 0) {
        let p = Float.fromInt(count) / Float.fromInt(n);
        entropy -= p * ln(p);
      };
    };
    
    // Normalize to [0, 1]
    let maxEntropy = ln(Float.fromInt(numBins));
    if (maxEntropy > 0.0) { entropy / maxEntropy } else { 0.0 }
  };

  // Process incoming information feed
  public func consumeInformation(
    feed : InformationFeed,
    newData : [Float],
    priorKnowledge : [[var Float]],
    goals : [var Float]
  ) {
    let n = Nat.min(Array.size(newData), feed.dataSize);
    
    // Consume raw data
    for (i in Iter.range(0, n - 1)) {
      feed.rawData[i] := newData[i];
    };
    
    // Compute information content
    feed.informationContent := computeInformationContent(feed.rawData);
    
    // Compute novelty (difference from prior knowledge)
    var noveltySum : Float = 0.0;
    for (k in Iter.range(0, Array.size(priorKnowledge) - 1)) {
      var similarity : Float = 0.0;
      for (i in Iter.range(0, n - 1)) {
        if (i < Array.size(priorKnowledge[k])) {
          let diff = feed.rawData[i] - priorKnowledge[k][i];
          similarity += 1.0 - Float.abs(diff);
        };
      };
      similarity /= Float.fromInt(n);
      if (similarity > noveltySum) { noveltySum := similarity };
    };
    feed.noveltyScore := 1.0 - noveltySum;
    
    // Compute relevance to goals
    var relevanceSum : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (i < Array.size(goals)) {
        let goalAlignment = 1.0 - Float.abs(feed.rawData[i] - goals[i]);
        relevanceSum += goalAlignment;
      };
    };
    feed.relevanceScore := relevanceSum / Float.fromInt(n);
    
    // Nutritional value = information × novelty × relevance
    feed.nutritionalValue := feed.informationContent * feed.noveltyScore * feed.relevanceScore;
    
    // Process/digest the data
    let digestRate = 0.1;
    for (i in Iter.range(0, n - 1)) {
      // Digestion = filtering, integration, abstraction
      let raw = feed.rawData[i];
      let processed = feed.processedData[i];
      
      feed.processedData[i] := (1.0 - digestRate) * processed + digestRate * raw;
    };
    
    feed.digestionProgress += 0.1;
    feed.digestionProgress := clamp(feed.digestionProgress, 0.0, 1.0);
  };

  // Update information metabolism
  public func updateInformationMetabolism(
    assim : DataAssimilation,
    currentDrives : [var Float]
  ) {
    let meta = assim.metabolism;
    
    // Compute total consumption and digestion
    var consumed : Float = 0.0;
    var digested : Float = 0.0;
    
    for (i in Iter.range(0, meta.numFeeds - 1)) {
      let feed = meta.feeds[i];
      consumed += Float.fromInt(feed.dataSize) * feed.consumptionRate;
      digested += Float.fromInt(feed.dataSize) * feed.digestionProgress;
    };
    
    meta.totalConsumption := consumed;
    meta.totalDigested := digested;
    
    // Metabolic efficiency
    if (consumed > 0.0) {
      meta.metabolicEfficiency := digested / consumed;
    };
    
    // Information hunger based on satiation and drives
    let infoDriveIdx = 5;  // "information" drive
    if (infoDriveIdx < Array.size(currentDrives)) {
      meta.informationHunger := currentDrives[infoDriveIdx];
    } else {
      meta.informationHunger := 1.0 - meta.satiation;
    };
    
    // Satiation from nutritional value received
    var totalNutrition : Float = 0.0;
    for (i in Iter.range(0, meta.numFeeds - 1)) {
      totalNutrition += meta.feeds[i].nutritionalValue;
    };
    meta.satiation := totalNutrition / Float.fromInt(meta.numFeeds);
    
    // Information debt (unprocessed backlog)
    meta.informationDebt := meta.totalConsumption - meta.totalDigested;
    if (meta.informationDebt < 0.0) { meta.informationDebt := 0.0 };
    
    // Assimilate into knowledge base
    for (i in Iter.range(0, meta.numFeeds - 1)) {
      let feed = meta.feeds[i];
      
      if (feed.digestionProgress > 0.5 and feed.nutritionalValue > 0.3) {
        // Integrate into knowledge base
        let kIdx = assim.knowledgeIndex;
        
        for (j in Iter.range(0, feed.dataSize - 1)) {
          if (j < Array.size(assim.knowledgeBase[kIdx])) {
            // Blend new information with existing knowledge
            let existing = assim.knowledgeBase[kIdx][j];
            let new = feed.processedData[j];
            
            assim.knowledgeBase[kIdx][j] := 
              (1.0 - assim.assimilationRate) * existing + 
              assim.assimilationRate * new;
          };
        };
        
        // Advance knowledge index
        assim.knowledgeIndex := (kIdx + 1) % assim.knowledgeSize;
        
        // Reset digestion for this feed
        feed.digestionProgress := 0.0;
      };
    };
    
    // Integration quality
    var coherence : Float = 0.0;
    for (i in Iter.range(0, assim.knowledgeSize - 2)) {
      var similarity : Float = 0.0;
      let dimSize = Array.size(assim.knowledgeBase[i]);
      
      for (j in Iter.range(0, dimSize - 1)) {
        let diff = assim.knowledgeBase[i][j] - assim.knowledgeBase[i + 1][j];
        similarity += 1.0 - Float.abs(diff);
      };
      
      coherence += similarity / Float.fromInt(dimSize);
    };
    
    assim.integrationQuality := coherence / Float.fromInt(assim.knowledgeSize - 1);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DRONE OBSERVATION — PASSIVE VISUAL DATA GATHERING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism can observe from a "drone point of view":
  //
  // 1. VISUAL SCENE: 2D spatial representation
  // 2. OBJECT DETECTION: Identifying entities
  // 3. MOTION TRACKING: Following movement
  // 4. PATTERN RECOGNITION: Finding regularities
  //

  public type DroneObservation = {
    var visualField : [[var Float]];     // 2D visual input
    var fieldWidth : Nat;
    var fieldHeight : Nat;
    var attentionPoint : (Float, Float); // Where looking
    var foveaRadius : Float;             // High-resolution center
    var motionField : [[var Float]];     // Optic flow
    var objectDetections : [[var Float]];// Detected objects (x, y, type, conf)
    var numObjects : Nat;
    var maxObjects : Nat;
    var sceneGist : [var Float];         // Global scene representation
    var sceneCategory : Text;            // Scene classification
  };

  public type VisualProcessing = {
    drone : DroneObservation;
    var edgeMap : [[var Float]];         // Edge detection
    var saliencyMap : [[var Float]];     // Visual saliency
    var featureMaps : [[[var Float]]];   // Multi-scale features
    var numScales : Nat;
    var objectRecognition : [var Float]; // Object class probabilities
    var numClasses : Nat;
    var temporalBuffer : [[[var Float]]];// Recent frames
    var bufferSize : Nat;
    var currentFrame : Nat;
    var motionEstimate : (Float, Float); // Global motion
  };

  public func initDroneObservation(width : Nat, height : Nat, maxObjects : Nat, gistSize : Nat) : DroneObservation {
    let visual = Array.init<[var Float]>(height, func(_ : Nat) : [var Float] {
      Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
    });
    
    let motion = Array.init<[var Float]>(height, func(_ : Nat) : [var Float] {
      Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
    });
    
    let objects = Array.init<[var Float]>(maxObjects, func(_ : Nat) : [var Float] {
      Array.init<Float>(4, func(_ : Nat) : Float { 0.0 })  // x, y, type, confidence
    });
    
    let gist = Array.init<Float>(gistSize, func(_ : Nat) : Float { 0.0 });
    
    {
      var visualField = visual;
      var fieldWidth = width;
      var fieldHeight = height;
      var attentionPoint = (Float.fromInt(width) / 2.0, Float.fromInt(height) / 2.0);
      var foveaRadius = 5.0;
      var motionField = motion;
      var objectDetections = objects;
      var numObjects = 0;
      var maxObjects = maxObjects;
      var sceneGist = gist;
      var sceneCategory = "unknown";
    }
  };

  public func initVisualProcessing(width : Nat, height : Nat, numScales : Nat, numClasses : Nat, bufferSize : Nat) : VisualProcessing {
    let edges = Array.init<[var Float]>(height, func(_ : Nat) : [var Float] {
      Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
    });
    
    let saliency = Array.init<[var Float]>(height, func(_ : Nat) : [var Float] {
      Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
    });
    
    let features = Array.init<[[var Float]]>(numScales, func(_ : Nat) : [[var Float]] {
      Array.init<[var Float]>(height, func(_ : Nat) : [var Float] {
        Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
      })
    });
    
    let objRec = Array.init<Float>(numClasses, func(_ : Nat) : Float { 0.0 });
    
    let temporal = Array.init<[[var Float]]>(bufferSize, func(_ : Nat) : [[var Float]] {
      Array.init<[var Float]>(height, func(_ : Nat) : [var Float] {
        Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
      })
    });
    
    {
      drone = initDroneObservation(width, height, 10, 50);
      var edgeMap = edges;
      var saliencyMap = saliency;
      var featureMaps = features;
      var numScales = numScales;
      var objectRecognition = objRec;
      var numClasses = numClasses;
      var temporalBuffer = temporal;
      var bufferSize = bufferSize;
      var currentFrame = 0;
      var motionEstimate = (0.0, 0.0);
    }
  };

  // Process visual input
  public func processVisualInput(
    visual : VisualProcessing,
    newFrame : [[Float]]
  ) {
    let drone = visual.drone;
    let h = drone.fieldHeight;
    let w = drone.fieldWidth;
    
    // Store in visual field
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        if (y < Array.size(newFrame) and x < Array.size(newFrame[y])) {
          drone.visualField[y][x] := newFrame[y][x];
        };
      };
    };
    
    // Store in temporal buffer
    let bufIdx = visual.currentFrame;
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        visual.temporalBuffer[bufIdx][y][x] := drone.visualField[y][x];
      };
    };
    visual.currentFrame := (bufIdx + 1) % visual.bufferSize;
    
    // Edge detection (simplified Sobel)
    for (y in Iter.range(1, h - 2)) {
      for (x in Iter.range(1, w - 2)) {
        // Horizontal gradient
        let gx = drone.visualField[y-1][x+1] + 2.0 * drone.visualField[y][x+1] + drone.visualField[y+1][x+1]
               - drone.visualField[y-1][x-1] - 2.0 * drone.visualField[y][x-1] - drone.visualField[y+1][x-1];
        
        // Vertical gradient
        let gy = drone.visualField[y+1][x-1] + 2.0 * drone.visualField[y+1][x] + drone.visualField[y+1][x+1]
               - drone.visualField[y-1][x-1] - 2.0 * drone.visualField[y-1][x] - drone.visualField[y-1][x+1];
        
        visual.edgeMap[y][x] := sqrt(gx * gx + gy * gy) / 4.0;
      };
    };
    
    // Saliency (simplified: edges + intensity deviation)
    var meanIntensity : Float = 0.0;
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        meanIntensity += drone.visualField[y][x];
      };
    };
    meanIntensity /= Float.fromInt(h * w);
    
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        let intensityDev = Float.abs(drone.visualField[y][x] - meanIntensity);
        let edge = visual.edgeMap[y][x];
        visual.saliencyMap[y][x] := 0.5 * intensityDev + 0.5 * edge;
      };
    };
    
    // Motion estimation
    if (visual.currentFrame > 0) {
      let prevIdx = (visual.currentFrame + visual.bufferSize - 1) % visual.bufferSize;
      var totalMotionX : Float = 0.0;
      var totalMotionY : Float = 0.0;
      
      for (y in Iter.range(1, h - 2)) {
        for (x in Iter.range(1, w - 2)) {
          let curr = drone.visualField[y][x];
          let prev = visual.temporalBuffer[prevIdx][y][x];
          let diff = curr - prev;
          
          drone.motionField[y][x] := diff;
          
          // Estimate motion direction
          let gradX = drone.visualField[y][x+1] - drone.visualField[y][x-1];
          let gradY = drone.visualField[y+1][x] - drone.visualField[y-1][x];
          
          if (gradX * gradX + gradY * gradY > 0.01) {
            let motionX = -diff * gradX / (gradX * gradX + gradY * gradY + 0.01);
            let motionY = -diff * gradY / (gradX * gradX + gradY * gradY + 0.01);
            
            totalMotionX += motionX;
            totalMotionY += motionY;
          };
        };
      };
      
      visual.motionEstimate := (
        totalMotionX / Float.fromInt(h * w),
        totalMotionY / Float.fromInt(h * w)
      );
    };
    
    // Update attention point based on saliency
    var maxSaliency : Float = 0.0;
    var maxX : Nat = w / 2;
    var maxY : Nat = h / 2;
    
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        if (visual.saliencyMap[y][x] > maxSaliency) {
          maxSaliency := visual.saliencyMap[y][x];
          maxX := x;
          maxY := y;
        };
      };
    };
    
    // Smooth attention shift
    let (oldX, oldY) = drone.attentionPoint;
    drone.attentionPoint := (
      0.8 * oldX + 0.2 * Float.fromInt(maxX),
      0.8 * oldY + 0.2 * Float.fromInt(maxY)
    );
    
    // Scene gist (global statistics)
    let gistSize = Array.size(drone.sceneGist);
    var gistIdx : Nat = 0;
    
    // Mean intensity
    if (gistIdx < gistSize) {
      drone.sceneGist[gistIdx] := meanIntensity;
      gistIdx += 1;
    };
    
    // Variance
    var variance : Float = 0.0;
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        let diff = drone.visualField[y][x] - meanIntensity;
        variance += diff * diff;
      };
    };
    if (gistIdx < gistSize) {
      drone.sceneGist[gistIdx] := variance / Float.fromInt(h * w);
      gistIdx += 1;
    };
    
    // Edge density
    var edgeDensity : Float = 0.0;
    for (y in Iter.range(0, h - 1)) {
      for (x in Iter.range(0, w - 1)) {
        if (visual.edgeMap[y][x] > 0.2) {
          edgeDensity += 1.0;
        };
      };
    };
    if (gistIdx < gistSize) {
      drone.sceneGist[gistIdx] := edgeDensity / Float.fromInt(h * w);
      gistIdx += 1;
    };
    
    // Motion energy
    let (motionX, motionY) = visual.motionEstimate;
    if (gistIdx < gistSize) {
      drone.sceneGist[gistIdx] := sqrt(motionX * motionX + motionY * motionY);
      gistIdx += 1;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INTERNET SEARCH — ACTIVE INFORMATION SEEKING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // The organism actively seeks information through search:
  //
  // 1. QUERY FORMULATION: Expressing information need
  // 2. RESULT PROCESSING: Understanding retrieved information
  // 3. RELEVANCE ASSESSMENT: Evaluating usefulness
  // 4. KNOWLEDGE INTEGRATION: Incorporating new information
  //

  public type SearchQuery = {
    var queryVector : [var Float];       // Semantic query representation
    var queryDimension : Nat;
    var intent : Text;                   // "factual", "exploratory", "navigational"
    var specificity : Float;             // How specific is the query
    var urgency : Float;                 // How urgent is the need
    var confidenceInQuery : Float;       // How well-formed is query
    var alternativeQueries : [[var Float]]; // Query variations
    var numAlternatives : Nat;
  };

  public type SearchResult = {
    var contentVector : [var Float];     // Content representation
    var relevanceScore : Float;          // Relevance to query
    var authorityScore : Float;          // Source credibility
    var freshnessScore : Float;          // Recency
    var diversityScore : Float;          // Difference from other results
    var overallScore : Float;            // Combined score
    var isSelected : Bool;               // Selected for consumption
    var consumptionProgress : Float;     // How much processed
  };

  public type SearchSystem = {
    var currentQuery : SearchQuery;
    var results : [var SearchResult];
    var numResults : Nat;
    var maxResults : Nat;
    var searchHistory : [[var Float]];   // Previous queries
    var historyIndex : Nat;
    var historySize : Nat;
    var satisfactionScore : Float;       // Was information need met?
    var searchFatigue : Float;           // Diminishing returns
    var knowledgeGapEstimate : Float;    // What we don't know
    var explorationExploitation : Float; // Balance
  };

  public func initSearchQuery(dimension : Nat, numAlt : Nat) : SearchQuery {
    let query = Array.init<Float>(dimension, func(_ : Nat) : Float { 0.0 });
    let alts = Array.init<[var Float]>(numAlt, func(_ : Nat) : [var Float] {
      Array.init<Float>(dimension, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var queryVector = query;
      var queryDimension = dimension;
      var intent = "exploratory";
      var specificity = 0.5;
      var urgency = 0.5;
      var confidenceInQuery = 0.5;
      var alternativeQueries = alts;
      var numAlternatives = numAlt;
    }
  };

  public func initSearchResult(dimension : Nat) : SearchResult {
    {
      var contentVector = Array.init<Float>(dimension, func(_ : Nat) : Float { 0.0 });
      var relevanceScore = 0.0;
      var authorityScore = 0.5;
      var freshnessScore = 0.5;
      var diversityScore = 0.0;
      var overallScore = 0.0;
      var isSelected = false;
      var consumptionProgress = 0.0;
    }
  };

  public func initSearchSystem(queryDim : Nat, maxResults : Nat, historySize : Nat, numAlt : Nat) : SearchSystem {
    let results = Array.init<SearchResult>(maxResults, func(_ : Nat) : SearchResult {
      initSearchResult(queryDim)
    });
    
    let history = Array.init<[var Float]>(historySize, func(_ : Nat) : [var Float] {
      Array.init<Float>(queryDim, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var currentQuery = initSearchQuery(queryDim, numAlt);
      var results = results;
      var numResults = 0;
      var maxResults = maxResults;
      var searchHistory = history;
      var historyIndex = 0;
      var historySize = historySize;
      var satisfactionScore = 0.0;
      var searchFatigue = 0.0;
      var knowledgeGapEstimate = 0.5;
      var explorationExploitation = 0.5;
    }
  };

  // Formulate search query from information need
  public func formulateQuery(
    search : SearchSystem,
    informationNeed : [Float],
    currentKnowledge : [[var Float]]
  ) {
    let query = search.currentQuery;
    let dim = Nat.min(Array.size(informationNeed), query.queryDimension);
    
    // Base query from information need
    for (i in Iter.range(0, dim - 1)) {
      query.queryVector[i] := informationNeed[i];
    };
    
    // Adjust based on current knowledge (find gaps)
    for (k in Iter.range(0, Array.size(currentKnowledge) - 1)) {
      for (i in Iter.range(0, dim - 1)) {
        if (i < Array.size(currentKnowledge[k])) {
          // If we already know this, reduce query emphasis
          let known = currentKnowledge[k][i];
          query.queryVector[i] *= (1.0 - known * 0.3);
        };
      };
    };
    
    // Normalize query
    var norm : Float = 0.0;
    for (i in Iter.range(0, dim - 1)) {
      norm += query.queryVector[i] * query.queryVector[i];
    };
    norm := sqrt(norm);
    
    if (norm > 0.0) {
      for (i in Iter.range(0, dim - 1)) {
        query.queryVector[i] /= norm;
      };
    };
    
    // Compute query confidence
    query.confidenceInQuery := if (norm > 0.5) { 0.8 } else { 0.4 };
    
    // Store in history
    let histIdx = search.historyIndex;
    for (i in Iter.range(0, dim - 1)) {
      search.searchHistory[histIdx][i] := query.queryVector[i];
    };
    search.historyIndex := (histIdx + 1) % search.historySize;
  };

  // Score search results
  public func scoreSearchResults(
    search : SearchSystem,
    resultContents : [[Float]]
  ) {
    let query = search.currentQuery;
    let dim = query.queryDimension;
    
    search.numResults := Nat.min(Array.size(resultContents), search.maxResults);
    
    for (r in Iter.range(0, search.numResults - 1)) {
      let result = search.results[r];
      let content = resultContents[r];
      
      // Store content
      for (i in Iter.range(0, Nat.min(Array.size(content), dim) - 1)) {
        result.contentVector[i] := content[i];
      };
      
      // Compute relevance (cosine similarity with query)
      var dotProduct : Float = 0.0;
      var queryNorm : Float = 0.0;
      var contentNorm : Float = 0.0;
      
      for (i in Iter.range(0, dim - 1)) {
        let q = query.queryVector[i];
        let c = result.contentVector[i];
        dotProduct += q * c;
        queryNorm += q * q;
        contentNorm += c * c;
      };
      
      let normProduct = sqrt(queryNorm) * sqrt(contentNorm);
      result.relevanceScore := if (normProduct > 0.0) { dotProduct / normProduct } else { 0.0 };
      
      // Diversity (difference from other results)
      var minDiff : Float = 1.0;
      for (other in Iter.range(0, search.numResults - 1)) {
        if (other != r) {
          var diff : Float = 0.0;
          for (i in Iter.range(0, dim - 1)) {
            let d = result.contentVector[i] - search.results[other].contentVector[i];
            diff += d * d;
          };
          diff := sqrt(diff) / Float.fromInt(dim);
          if (diff < minDiff) { minDiff := diff };
        };
      };
      result.diversityScore := minDiff;
      
      // Overall score
      result.overallScore := 
        0.5 * result.relevanceScore +
        0.2 * result.authorityScore +
        0.15 * result.freshnessScore +
        0.15 * result.diversityScore;
    };
    
    // Select top results
    for (r in Iter.range(0, search.numResults - 1)) {
      search.results[r].isSelected := search.results[r].overallScore > 0.5;
    };
    
    // Update satisfaction
    var maxRelevance : Float = 0.0;
    for (r in Iter.range(0, search.numResults - 1)) {
      if (search.results[r].relevanceScore > maxRelevance) {
        maxRelevance := search.results[r].relevanceScore;
      };
    };
    search.satisfactionScore := maxRelevance;
    
    // Update knowledge gap estimate
    search.knowledgeGapEstimate := 1.0 - search.satisfactionScore;
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // QUANTUM COHERENCE LAYER — MACROSCOPIC QUANTUM EFFECTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Quantum-inspired coherence for enhanced neural computation:
  //
  // 1. SUPERPOSITION: Multiple states simultaneously
  // 2. ENTANGLEMENT: Non-local correlations
  // 3. TUNNELING: Bypassing energy barriers
  // 4. DECOHERENCE: Transition to classical
  //

  public type QuantumState = {
    var amplitudes : [var (Float, Float)]; // Complex amplitudes (real, imag)
    var numQubits : Nat;
    var stateVector : [var Float];       // Classical probability distribution
    var entanglementMap : [[var Float]]; // Pairwise entanglement
    var coherenceTime : Float;           // Decoherence timescale
    var purity : Float;                  // Tr(ρ²) - state purity
    var vonNeumannEntropy : Float;       // S = -Tr(ρ log ρ)
    var quantumFidelity : Float;         // Overlap with target state
  };

  public type QuantumCoherence = {
    quantum : QuantumState;
    var coherenceMatrix : [[var (Float, Float)]]; // Density matrix
    var decoherenceRate : Float;         // γ decay rate
    var temperatureEffect : Float;       // Thermal noise
    var environmentCoupling : Float;     // Bath interaction
    var quantumToClassical : Float;      // Coherence → classical mixing
    var measurementBackaction : Float;   // Effect of observation
    var zeroPointEnergy : Float;         // Vacuum fluctuations
    var tunnelingProbability : Float;    // Barrier penetration
  };

  public type QuantumNeuralState = {
    coherence : QuantumCoherence;
    var quantumWeights : [[var (Float, Float)]]; // Complex connection weights
    var quantumBias : [var (Float, Float)];      // Complex biases
    var quantumActivation : [var (Float, Float)]; // Complex activations
    var classicalShadow : [var Float];   // Classical measurement outcomes
    var quantumAdvantage : Float;        // Speedup over classical
    var noiseRobustness : Float;         // Resistance to decoherence
    var quantumError : Float;            // Error from decoherence
  };

  public func initQuantumState(numQubits : Nat) : QuantumState {
    let numStates = 1;  // Simplified: 2^numQubits is too large
    
    let amps = Array.init<(Float, Float)>(numStates, func(i : Nat) : (Float, Float) {
      if (i == 0) { (1.0, 0.0) }  // Start in |0⟩ state
      else { (0.0, 0.0) }
    });
    
    let stateVec = Array.init<Float>(numQubits, func(_ : Nat) : Float { 0.5 });
    
    let entangle = Array.init<[var Float]>(numQubits, func(_ : Nat) : [var Float] {
      Array.init<Float>(numQubits, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var amplitudes = amps;
      var numQubits = numQubits;
      var stateVector = stateVec;
      var entanglementMap = entangle;
      var coherenceTime = 100.0;  // ms
      var purity = 1.0;
      var vonNeumannEntropy = 0.0;
      var quantumFidelity = 1.0;
    }
  };

  public func initQuantumCoherence(numQubits : Nat) : QuantumCoherence {
    let density = Array.init<[var (Float, Float)]>(numQubits, func(_ : Nat) : [var (Float, Float)] {
      Array.init<(Float, Float)>(numQubits, func(_ : Nat) : (Float, Float) { (0.0, 0.0) })
    });
    
    {
      quantum = initQuantumState(numQubits);
      var coherenceMatrix = density;
      var decoherenceRate = 0.01;
      var temperatureEffect = 0.1;
      var environmentCoupling = 0.05;
      var quantumToClassical = 0.0;
      var measurementBackaction = 0.0;
      var zeroPointEnergy = 0.5;
      var tunnelingProbability = 0.1;
    }
  };

  public func initQuantumNeuralState(numQubits : Nat, numConnections : Nat) : QuantumNeuralState {
    let weights = Array.init<[var (Float, Float)]>(numQubits, func(_ : Nat) : [var (Float, Float)] {
      Array.init<(Float, Float)>(numQubits, func(_ : Nat) : (Float, Float) { (0.1, 0.0) })
    });
    
    let bias = Array.init<(Float, Float)>(numQubits, func(_ : Nat) : (Float, Float) { (0.0, 0.0) });
    let activation = Array.init<(Float, Float)>(numQubits, func(_ : Nat) : (Float, Float) { (0.5, 0.0) });
    let shadow = Array.init<Float>(numQubits, func(_ : Nat) : Float { 0.5 });
    
    {
      coherence = initQuantumCoherence(numQubits);
      var quantumWeights = weights;
      var quantumBias = bias;
      var quantumActivation = activation;
      var classicalShadow = shadow;
      var quantumAdvantage = 1.0;
      var noiseRobustness = 0.8;
      var quantumError = 0.0;
    }
  };

  // Complex number operations
  func complexAdd(a : (Float, Float), b : (Float, Float)) : (Float, Float) {
    (a.0 + b.0, a.1 + b.1)
  };

  func complexMul(a : (Float, Float), b : (Float, Float)) : (Float, Float) {
    (a.0 * b.0 - a.1 * b.1, a.0 * b.1 + a.1 * b.0)
  };

  func complexMagnitude(c : (Float, Float)) : Float {
    sqrt(c.0 * c.0 + c.1 * c.1)
  };

  func complexConjugate(c : (Float, Float)) : (Float, Float) {
    (c.0, -c.1)
  };

  // Update quantum coherence
  public func updateQuantumCoherence(
    qc : QuantumCoherence,
    dt : Float
  ) {
    let q = qc.quantum;
    let n = q.numQubits;
    
    // Decoherence: off-diagonal elements decay
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        if (i != j) {
          let (re, im) = qc.coherenceMatrix[i][j];
          let decay = exp(-qc.decoherenceRate * dt / 1000.0);
          qc.coherenceMatrix[i][j] := (re * decay, im * decay);
        };
      };
    };
    
    // Purity calculation: Tr(ρ²)
    var trRhoSquared : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let rhoIJ = qc.coherenceMatrix[i][j];
        let rhoJI = qc.coherenceMatrix[j][i];
        let product = complexMul(rhoIJ, rhoJI);
        trRhoSquared += product.0;  // Real part
      };
    };
    q.purity := trRhoSquared;
    
    // Von Neumann entropy approximation
    // S ≈ -Σ p_i log(p_i) where p_i are diagonal elements
    var entropy : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      let p = qc.coherenceMatrix[i][i].0;  // Real part of diagonal
      if (p > 0.0001) {
        entropy -= p * ln(p);
      };
    };
    q.vonNeumannEntropy := entropy;
    
    // Quantum to classical transition
    qc.quantumToClassical := 1.0 - q.purity;
    
    // Tunneling probability (temperature dependent)
    qc.tunnelingProbability := exp(-1.0 / (qc.temperatureEffect + 0.01));
    
    // Update classical shadow (measurement outcomes)
    for (i in Iter.range(0, n - 1)) {
      let p = qc.coherenceMatrix[i][i].0;
      q.stateVector[i] := p;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HOLOGRAPHIC MEMORY — DISTRIBUTED ASSOCIATIVE RECALL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Memory stored holographically across the system:
  //
  // 1. CONTENT-ADDRESSABLE: Retrieve by partial pattern
  // 2. DISTRIBUTED: Each part contains the whole
  // 3. INTERFERENCE: Patterns combine constructively/destructively
  // 4. GRACEFUL DEGRADATION: Robust to damage
  //

  public type HolographicMemory = {
    var hologram : [[var Float]];        // Interference pattern
    var hologramSize : Nat;
    var referenceBeam : [var Float];     // Reference pattern
    var numMemories : Nat;               // Stored patterns
    var maxMemories : Nat;               // Capacity
    var reconstructionQuality : Float;   // Recall fidelity
    var noiseLevel : Float;              // Storage noise
    var interferenceStrength : Float;    // Pattern interaction
    var attentionalBeam : [var Float];   // Focused recall
    var partialCueStrength : Float;      // Partial pattern completion
  };

  public type AssociativeRecall = {
    holographic : HolographicMemory;
    var storedPatterns : [[var Float]];  // Original patterns
    var patternStrength : [var Float];   // Memory strength
    var recencyEffect : [var Float];     // Time since encoding
    var frequencyEffect : [var Float];   // Access frequency
    var contextualBinding : [[var Float]]; // Pattern co-occurrence
    var spreadingActivation : [var Float]; // Current activation
    var completionThreshold : Float;     // When to complete pattern
    var competitionStrength : Float;     // Winner-take-all
  };

  public func initHolographicMemory(size : Nat, maxMem : Nat) : HolographicMemory {
    let holo = Array.init<[var Float]>(size, func(_ : Nat) : [var Float] {
      Array.init<Float>(size, func(_ : Nat) : Float { 0.0 })
    });
    
    let ref = Array.init<Float>(size, func(i : Nat) : Float {
      sin(Float.fromInt(i) * 0.1)  // Reference beam pattern
    });
    
    let attn = Array.init<Float>(size, func(_ : Nat) : Float { 1.0 });
    
    {
      var hologram = holo;
      var hologramSize = size;
      var referenceBeam = ref;
      var numMemories = 0;
      var maxMemories = maxMem;
      var reconstructionQuality = 1.0;
      var noiseLevel = 0.01;
      var interferenceStrength = 0.5;
      var attentionalBeam = attn;
      var partialCueStrength = 0.5;
    }
  };

  public func initAssociativeRecall(size : Nat, maxMem : Nat) : AssociativeRecall {
    let patterns = Array.init<[var Float]>(maxMem, func(_ : Nat) : [var Float] {
      Array.init<Float>(size, func(_ : Nat) : Float { 0.0 })
    });
    
    let strength = Array.init<Float>(maxMem, func(_ : Nat) : Float { 0.0 });
    let recency = Array.init<Float>(maxMem, func(_ : Nat) : Float { 0.0 });
    let frequency = Array.init<Float>(maxMem, func(_ : Nat) : Float { 0.0 });
    
    let contextual = Array.init<[var Float]>(maxMem, func(_ : Nat) : [var Float] {
      Array.init<Float>(maxMem, func(_ : Nat) : Float { 0.0 })
    });
    
    let spreading = Array.init<Float>(maxMem, func(_ : Nat) : Float { 0.0 });
    
    {
      holographic = initHolographicMemory(size, maxMem);
      var storedPatterns = patterns;
      var patternStrength = strength;
      var recencyEffect = recency;
      var frequencyEffect = frequency;
      var contextualBinding = contextual;
      var spreadingActivation = spreading;
      var completionThreshold = 0.5;
      var competitionStrength = 2.0;
    }
  };

  // Store pattern in holographic memory
  public func storeHolographicPattern(
    holo : HolographicMemory,
    pattern : [Float]
  ) : Bool {
    if (holo.numMemories >= holo.maxMemories) { return false };
    
    let n = holo.hologramSize;
    let patternSize = Nat.min(Array.size(pattern), n);
    
    // Create interference pattern with reference beam
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let ref = holo.referenceBeam[(i + j) % n];
        let pat = if (i < patternSize) { pattern[i] } else { 0.0 };
        
        // Interference: hologram += pattern × reference
        let interference = pat * ref * holo.interferenceStrength;
        holo.hologram[i][j] += interference;
        
        // Add noise
        holo.hologram[i][j] += holo.noiseLevel * (0.5 - Float.fromInt(((i * 31 + j * 37) % 100)) / 100.0);
      };
    };
    
    holo.numMemories += 1;
    true
  };

  // Recall pattern from holographic memory
  public func recallHolographicPattern(
    holo : HolographicMemory,
    partialCue : [Float]
  ) : [Float] {
    let n = holo.hologramSize;
    let cueSize = Nat.min(Array.size(partialCue), n);
    
    // Reconstruct by illuminating with cue × reference
    let reconstruction = Array.tabulate<Float>(n, func(i : Nat) : Float {
      var sum : Float = 0.0;
      
      for (j in Iter.range(0, n - 1)) {
        let cue = if (j < cueSize) { partialCue[j] } else { 0.0 };
        let ref = holo.referenceBeam[(i + j) % n];
        let attn = holo.attentionalBeam[j];
        
        sum += holo.hologram[i][j] * cue * ref * attn;
      };
      
      sum / Float.fromInt(n)
    });
    
    // Measure reconstruction quality
    var quality : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      quality += Float.abs(reconstruction[i]);
    };
    holo.reconstructionQuality := quality / Float.fromInt(n);
    
    reconstruction
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // HEBBIAN ASSEMBLY — CELL ASSEMBLIES AND SYNFIRE CHAINS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural populations that fire together:
  //
  // 1. CELL ASSEMBLIES: Co-activated neuron groups
  // 2. SYNFIRE CHAINS: Sequential activation patterns
  // 3. POLYCHRONIZATION: Timing-dependent groups
  // 4. REVERBERATING ACTIVITY: Sustained patterns
  //

  public type CellAssembly = {
    var memberNeurons : [var Bool];      // Which neurons belong
    var memberCount : Nat;
    var totalNeurons : Nat;
    var activationLevel : Float;         // Current assembly activation
    var coactivationHistory : [[var Float]]; // Neuron co-firing history
    var assemblyStrength : Float;        // Assembly cohesion
    var formationThreshold : Float;      // When to form assembly
    var decayRate : Float;               // Assembly weakening
    var reactivationEase : Float;        // How easy to reactivate
  };

  public type SynfireChain = {
    var chainLayers : [[var Nat]];       // Neurons per layer
    var numLayers : Nat;
    var maxNeuronsPerLayer : Nat;
    var currentLayer : Nat;              // Active layer
    var propagationSpeed : Float;        // Layer transition time
    var chainCompletions : Nat;          // Full activations
    var chainAborts : Nat;               // Incomplete activations
    var jitterTolerance : Float;         // Timing variability allowed
    var chainStrength : Float;           // Overall chain strength
  };

  public type AssemblyDynamics = {
    var assemblies : [var CellAssembly]; // All assemblies
    var numAssemblies : Nat;
    var maxAssemblies : Nat;
    var chains : [var SynfireChain];     // All synfire chains
    var numChains : Nat;
    var maxChains : Nat;
    var competitionWinners : [var Nat];  // Active assemblies
    var assemblyOverlap : [[var Float]]; // Shared neurons
    var ignitionThreshold : Float;       // Assembly activation threshold
    var reverberationStrength : Float;   // Sustained activity
  };

  public func initCellAssembly(totalNeurons : Nat) : CellAssembly {
    let members = Array.init<Bool>(totalNeurons, func(_ : Nat) : Bool { false });
    
    let coactivation = Array.init<[var Float]>(totalNeurons, func(_ : Nat) : [var Float] {
      Array.init<Float>(totalNeurons, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var memberNeurons = members;
      var memberCount = 0;
      var totalNeurons = totalNeurons;
      var activationLevel = 0.0;
      var coactivationHistory = coactivation;
      var assemblyStrength = 0.0;
      var formationThreshold = 0.5;
      var decayRate = 0.01;
      var reactivationEase = 0.5;
    }
  };

  public func initSynfireChain(numLayers : Nat, maxPerLayer : Nat) : SynfireChain {
    let layers = Array.init<[var Nat]>(numLayers, func(_ : Nat) : [var Nat] {
      Array.init<Nat>(maxPerLayer, func(_ : Nat) : Nat { 0 })
    });
    
    {
      var chainLayers = layers;
      var numLayers = numLayers;
      var maxNeuronsPerLayer = maxPerLayer;
      var currentLayer = 0;
      var propagationSpeed = 10.0;  // ms per layer
      var chainCompletions = 0;
      var chainAborts = 0;
      var jitterTolerance = 5.0;  // ms
      var chainStrength = 0.5;
    }
  };

  public func initAssemblyDynamics(totalNeurons : Nat, maxAssemblies : Nat, maxChains : Nat) : AssemblyDynamics {
    let assemblies = Array.init<CellAssembly>(maxAssemblies, func(_ : Nat) : CellAssembly {
      initCellAssembly(totalNeurons)
    });
    
    let chains = Array.init<SynfireChain>(maxChains, func(_ : Nat) : SynfireChain {
      initSynfireChain(10, 5)
    });
    
    let winners = Array.init<Nat>(maxAssemblies, func(_ : Nat) : Nat { 0 });
    
    let overlap = Array.init<[var Float]>(maxAssemblies, func(_ : Nat) : [var Float] {
      Array.init<Float>(maxAssemblies, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var assemblies = assemblies;
      var numAssemblies = 0;
      var maxAssemblies = maxAssemblies;
      var chains = chains;
      var numChains = 0;
      var maxChains = maxChains;
      var competitionWinners = winners;
      var assemblyOverlap = overlap;
      var ignitionThreshold = 0.3;
      var reverberationStrength = 0.5;
    }
  };

  // Detect and form cell assemblies
  public func detectCellAssemblies(
    dynamics : AssemblyDynamics,
    neuronActivations : [Float],
    dt : Float
  ) {
    let n = Array.size(neuronActivations);
    if (n == 0) { return };
    
    // Update coactivation history for existing assemblies
    for (a in Iter.range(0, dynamics.numAssemblies - 1)) {
      let assembly = dynamics.assemblies[a];
      
      // Check which member neurons are active
      var activeMembers : Nat = 0;
      for (i in Iter.range(0, Nat.min(n, assembly.totalNeurons) - 1)) {
        if (assembly.memberNeurons[i] and neuronActivations[i] > 0.5) {
          activeMembers += 1;
        };
      };
      
      // Assembly activation level
      if (assembly.memberCount > 0) {
        assembly.activationLevel := Float.fromInt(activeMembers) / Float.fromInt(assembly.memberCount);
      };
      
      // Update coactivation matrix
      for (i in Iter.range(0, Nat.min(n, assembly.totalNeurons) - 1)) {
        for (j in Iter.range(i + 1, Nat.min(n, assembly.totalNeurons) - 1)) {
          if (neuronActivations[i] > 0.5 and neuronActivations[j] > 0.5) {
            assembly.coactivationHistory[i][j] += 0.1;
            assembly.coactivationHistory[j][i] += 0.1;
          } else {
            assembly.coactivationHistory[i][j] *= (1.0 - assembly.decayRate);
            assembly.coactivationHistory[j][i] *= (1.0 - assembly.decayRate);
          };
        };
      };
      
      // Recompute assembly strength
      var strengthSum : Float = 0.0;
      var pairs : Nat = 0;
      for (i in Iter.range(0, Nat.min(n, assembly.totalNeurons) - 1)) {
        for (j in Iter.range(i + 1, Nat.min(n, assembly.totalNeurons) - 1)) {
          if (assembly.memberNeurons[i] and assembly.memberNeurons[j]) {
            strengthSum += assembly.coactivationHistory[i][j];
            pairs += 1;
          };
        };
      };
      
      if (pairs > 0) {
        assembly.assemblyStrength := strengthSum / Float.fromInt(pairs);
      };
    };
    
    // Detect new assemblies from coactivation patterns
    if (dynamics.numAssemblies < dynamics.maxAssemblies) {
      // Find highly coactivated neuron pairs not in existing assemblies
      var maxCoactivation : Float = 0.0;
      var bestI : Nat = 0;
      var bestJ : Nat = 0;
      
      for (i in Iter.range(0, n - 1)) {
        for (j in Iter.range(i + 1, n - 1)) {
          // Check coactivation across all assemblies
          var coact : Float = 0.0;
          for (a in Iter.range(0, dynamics.numAssemblies - 1)) {
            coact += dynamics.assemblies[a].coactivationHistory[i][j];
          };
          
          if (coact > maxCoactivation and coact > dynamics.ignitionThreshold) {
            maxCoactivation := coact;
            bestI := i;
            bestJ := j;
          };
        };
      };
      
      // Form new assembly if strong coactivation found
      if (maxCoactivation > dynamics.ignitionThreshold) {
        let newAssembly = dynamics.assemblies[dynamics.numAssemblies];
        newAssembly.memberNeurons[bestI] := true;
        newAssembly.memberNeurons[bestJ] := true;
        newAssembly.memberCount := 2;
        newAssembly.assemblyStrength := maxCoactivation;
        dynamics.numAssemblies += 1;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // RESERVOIR COMPUTING — ECHO STATE NETWORKS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Recurrent dynamics for temporal processing:
  //
  // 1. RESERVOIR: Fixed random recurrent network
  // 2. ECHO STATE: Fading memory property
  // 3. READOUT: Trainable output layer
  // 4. SPECTRAL RADIUS: Edge of chaos tuning
  //

  public type ReservoirState = {
    var internalState : [var Float];     // Reservoir neuron activations
    var reservoirSize : Nat;
    var inputWeights : [[var Float]];    // Input → reservoir
    var reservoirWeights : [[var Float]];// Reservoir → reservoir
    var outputWeights : [[var Float]];   // Reservoir → output
    var inputSize : Nat;
    var outputSize : Nat;
    var spectralRadius : Float;          // Largest eigenvalue
    var leakingRate : Float;             // State mixing
    var sparsity : Float;                // Connection density
    var noiseLevel : Float;              // Internal noise
  };

  public type EchoState = {
    reservoir : ReservoirState;
    var stateHistory : [[var Float]];    // Recent states
    var historyLength : Nat;
    var currentHistoryIdx : Nat;
    var memoryCapacity : Float;          // How long echoes persist
    var separationProperty : Float;      // Input discrimination
    var fadinMemoryExponent : Float;     // Echo decay rate
    var nonlinearityStrength : Float;    // tanh steepness
    var readoutLearningRate : Float;     // Output weight adaptation
    var predictionError : Float;         // Current output error
  };

  public func initReservoirState(inputSize : Nat, reservoirSize : Nat, outputSize : Nat) : ReservoirState {
    let state = Array.init<Float>(reservoirSize, func(_ : Nat) : Float { 0.0 });
    
    let inputW = Array.init<[var Float]>(reservoirSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(inputSize, func(_ : Nat) : Float { (0.5 - 0.5) * 0.2 })
    });
    
    let resW = Array.init<[var Float]>(reservoirSize, func(i : Nat) : [var Float] {
      Array.init<Float>(reservoirSize, func(j : Nat) : Float {
        // Sparse random weights
        if ((i * 7 + j * 11) % 5 == 0) {
          (Float.fromInt((i * 13 + j * 17) % 100) / 100.0 - 0.5) * 0.5
        } else {
          0.0
        }
      })
    });
    
    let outputW = Array.init<[var Float]>(outputSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(reservoirSize, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var internalState = state;
      var reservoirSize = reservoirSize;
      var inputWeights = inputW;
      var reservoirWeights = resW;
      var outputWeights = outputW;
      var inputSize = inputSize;
      var outputSize = outputSize;
      var spectralRadius = 0.9;
      var leakingRate = 0.3;
      var sparsity = 0.2;
      var noiseLevel = 0.01;
    }
  };

  public func initEchoState(inputSize : Nat, reservoirSize : Nat, outputSize : Nat, historyLength : Nat) : EchoState {
    let history = Array.init<[var Float]>(historyLength, func(_ : Nat) : [var Float] {
      Array.init<Float>(reservoirSize, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      reservoir = initReservoirState(inputSize, reservoirSize, outputSize);
      var stateHistory = history;
      var historyLength = historyLength;
      var currentHistoryIdx = 0;
      var memoryCapacity = 0.0;
      var separationProperty = 0.0;
      var fadinMemoryExponent = 0.1;
      var nonlinearityStrength = 1.0;
      var readoutLearningRate = 0.01;
      var predictionError = 0.0;
    }
  };

  // Update reservoir state
  public func updateReservoir(
    echo : EchoState,
    input : [Float],
    target : [Float]
  ) : [Float] {
    let res = echo.reservoir;
    let n = res.reservoirSize;
    let inSize = res.inputSize;
    
    // Compute new state
    let newState = Array.tabulate<Float>(n, func(i : Nat) : Float {
      // Input contribution
      var inputSum : Float = 0.0;
      for (j in Iter.range(0, Nat.min(Array.size(input), inSize) - 1)) {
        inputSum += res.inputWeights[i][j] * input[j];
      };
      
      // Recurrent contribution
      var recSum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        recSum += res.reservoirWeights[i][j] * res.internalState[j];
      };
      
      // Add noise
      let noise = res.noiseLevel * (Float.fromInt((i * 31) % 100) / 50.0 - 1.0);
      
      // Leaky integration with tanh nonlinearity
      let newVal = (1.0 - res.leakingRate) * res.internalState[i] + 
                   res.leakingRate * tanh(echo.nonlinearityStrength * (inputSum + recSum + noise));
      
      newVal
    });
    
    // Update state
    for (i in Iter.range(0, n - 1)) {
      res.internalState[i] := newState[i];
    };
    
    // Store in history
    for (i in Iter.range(0, n - 1)) {
      echo.stateHistory[echo.currentHistoryIdx][i] := res.internalState[i];
    };
    echo.currentHistoryIdx := (echo.currentHistoryIdx + 1) % echo.historyLength;
    
    // Compute output
    let output = Array.tabulate<Float>(res.outputSize, func(i : Nat) : Float {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        sum += res.outputWeights[i][j] * res.internalState[j];
      };
      sum
    });
    
    // Train output weights (if target provided)
    if (Array.size(target) >= res.outputSize) {
      var errorSum : Float = 0.0;
      
      for (i in Iter.range(0, res.outputSize - 1)) {
        let error = target[i] - output[i];
        errorSum += error * error;
        
        // Update weights
        for (j in Iter.range(0, n - 1)) {
          res.outputWeights[i][j] += echo.readoutLearningRate * error * res.internalState[j];
        };
      };
      
      echo.predictionError := sqrt(errorSum / Float.fromInt(res.outputSize));
    };
    
    output
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SPIKE-TIMING NETWORKS — PRECISE TEMPORAL CODING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Millisecond-precise temporal processing:
  //
  // 1. SPIKE TIMES: Precise firing moments
  // 2. COINCIDENCE DETECTION: Simultaneous input detection
  // 3. TEMPORAL DIFFERENCE: Relative timing extraction
  // 4. RATE VS TIMING: Dual coding modes
  //

  public type SpikeTimingState = {
    var lastSpikeTime : [var Float];     // When each neuron last fired
    var numNeurons : Nat;
    var spikeTrains : [[var Float]];     // Recent spike times per neuron
    var trainLength : Nat;
    var trainIndex : [var Nat];          // Current index in each train
    var firingRate : [var Float];        // Instantaneous rate estimate
    var interspikInterval : [var Float]; // Current ISI
    var burstIndicator : [var Bool];     // Currently bursting?
    var coincidenceWindow : Float;       // Time window for coincidence
    var temporalPrecision : Float;       // Timing jitter
  };

  public type TemporalCoding = {
    spikeTiming : SpikeTimingState;
    var phaseOfFiring : [var Float];     // Phase relative to oscillation
    var latencyCode : [var Float];       // First spike latency
    var rankOrder : [var Nat];           // Order of firing
    var synchronyMeasure : Float;        // Population synchrony
    var temporalContrast : Float;        // Timing variability
    var informationRate : Float;         // Bits per spike
    var codingEfficiency : Float;        // Rate vs timing contribution
    var temporalPattern : [[var Float]]; // Pattern templates
    var patternMatchScore : [var Float]; // Current pattern match
  };

  public func initSpikeTimingState(numNeurons : Nat, trainLength : Nat) : SpikeTimingState {
    let lastSpike = Array.init<Float>(numNeurons, func(_ : Nat) : Float { -1000.0 });
    
    let trains = Array.init<[var Float]>(numNeurons, func(_ : Nat) : [var Float] {
      Array.init<Float>(trainLength, func(_ : Nat) : Float { -1000.0 })
    });
    
    let trainIdx = Array.init<Nat>(numNeurons, func(_ : Nat) : Nat { 0 });
    let rates = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let isis = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 100.0 });
    let bursts = Array.init<Bool>(numNeurons, func(_ : Nat) : Bool { false });
    
    {
      var lastSpikeTime = lastSpike;
      var numNeurons = numNeurons;
      var spikeTrains = trains;
      var trainLength = trainLength;
      var trainIndex = trainIdx;
      var firingRate = rates;
      var interspikInterval = isis;
      var burstIndicator = bursts;
      var coincidenceWindow = 5.0;  // ms
      var temporalPrecision = 1.0;  // ms
    }
  };

  public func initTemporalCoding(numNeurons : Nat, trainLength : Nat, numPatterns : Nat) : TemporalCoding {
    let phase = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let latency = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let rank = Array.init<Nat>(numNeurons, func(i : Nat) : Nat { i });
    
    let patterns = Array.init<[var Float]>(numPatterns, func(_ : Nat) : [var Float] {
      Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 })
    });
    
    let matches = Array.init<Float>(numPatterns, func(_ : Nat) : Float { 0.0 });
    
    {
      spikeTiming = initSpikeTimingState(numNeurons, trainLength);
      var phaseOfFiring = phase;
      var latencyCode = latency;
      var rankOrder = rank;
      var synchronyMeasure = 0.0;
      var temporalContrast = 0.0;
      var informationRate = 0.0;
      var codingEfficiency = 0.5;
      var temporalPattern = patterns;
      var patternMatchScore = matches;
    }
  };

  // Process spike timing
  public func processSpikeTiming(
    coding : TemporalCoding,
    spikeTimes : [Float],
    currentTime : Float,
    oscillationPhase : Float
  ) {
    let st = coding.spikeTiming;
    let n = st.numNeurons;
    
    // Process each spike
    for (i in Iter.range(0, Nat.min(Array.size(spikeTimes), n) - 1)) {
      let spikeTime = spikeTimes[i];
      
      if (spikeTime > st.lastSpikeTime[i]) {
        // New spike detected
        let prevTime = st.lastSpikeTime[i];
        st.lastSpikeTime[i] := spikeTime;
        
        // Record in spike train
        let idx = st.trainIndex[i];
        st.spikeTrains[i][idx] := spikeTime;
        st.trainIndex[i] := (idx + 1) % st.trainLength;
        
        // Update ISI
        if (prevTime > -500.0) {
          st.interspikInterval[i] := spikeTime - prevTime;
          
          // Update firing rate estimate
          if (st.interspikInterval[i] > 0.0) {
            st.firingRate[i] := 1000.0 / st.interspikInterval[i];  // Hz
          };
          
          // Burst detection (ISI < 10ms)
          st.burstIndicator[i] := st.interspikInterval[i] < 10.0;
        };
        
        // Phase of firing
        coding.phaseOfFiring[i] := oscillationPhase;
        
        // Latency from stimulus onset (assume time 0)
        coding.latencyCode[i] := spikeTime;
      };
    };
    
    // Compute rank order (sort by spike time)
    // Simple bubble sort for small n
    for (i in Iter.range(0, n - 1)) {
      coding.rankOrder[i] := i;
    };
    
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(i + 1, n - 1)) {
        let timeI = st.lastSpikeTime[coding.rankOrder[i]];
        let timeJ = st.lastSpikeTime[coding.rankOrder[j]];
        
        if (timeJ < timeI) {
          // Swap
          let temp = coding.rankOrder[i];
          coding.rankOrder[i] := coding.rankOrder[j];
          coding.rankOrder[j] := temp;
        };
      };
    };
    
    // Synchrony measure (fraction spiking within window)
    var recentSpikes : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      if (currentTime - st.lastSpikeTime[i] < st.coincidenceWindow) {
        recentSpikes += 1;
      };
    };
    coding.synchronyMeasure := Float.fromInt(recentSpikes) / Float.fromInt(n);
    
    // Temporal contrast (variance in spike times)
    var meanTime : Float = 0.0;
    var validCount : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      if (currentTime - st.lastSpikeTime[i] < 100.0) {
        meanTime += st.lastSpikeTime[i];
        validCount += 1;
      };
    };
    
    if (validCount > 0) {
      meanTime /= Float.fromInt(validCount);
      
      var variance : Float = 0.0;
      for (i in Iter.range(0, n - 1)) {
        if (currentTime - st.lastSpikeTime[i] < 100.0) {
          let diff = st.lastSpikeTime[i] - meanTime;
          variance += diff * diff;
        };
      };
      
      coding.temporalContrast := sqrt(variance / Float.fromInt(validCount));
    };
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DENDRITIC COMPUTATION — LOCAL PROCESSING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Dendrites as local computational units:
  //
  // 1. DENDRITIC SPIKES: Local regenerative events
  // 2. COMPARTMENTALIZATION: Independent branches
  // 3. COINCIDENCE DETECTION: Spatial-temporal summation
  // 4. NONLINEAR INTEGRATION: Sigmoidal branch summation
  //

  public type DendriticCompartment = {
    var voltage : Float;                 // Local membrane potential
    var calcium : Float;                 // Local calcium concentration
    var inputWeight : Float;             // Synaptic weight to this compartment
    var distanceFromSoma : Float;        // Electrical distance
    var parentCompartment : Nat;         // Parent in tree
    var childCompartments : [var Nat];   // Children
    var numChildren : Nat;
    var spikeProbability : Float;        // Dendritic spike likelihood
    var lastSpikeTime : Float;           // When last dendritic spike
    var branchType : Text;               // "basal", "apical", "oblique"
  };

  public type DendriticTree = {
    var compartments : [var DendriticCompartment]; // All compartments
    var numCompartments : Nat;
    var somaVoltage : Float;             // Soma membrane potential
    var somaticIntegration : Float;      // How much reaches soma
    var electrotonicLength : Float;      // Space constant λ
    var inputResistance : Float;         // Total input resistance
    var coincidenceWindow : Float;       // Time for summation
    var branchPoint : [var Float];       // Voltage at branch points
    var nonlinearityThreshold : Float;   // For dendritic spike
    var plateauDuration : Float;         // Plateau potential duration
  };

  public type DendriticProcessing = {
    tree : DendriticTree;
    var spatialSummation : Float;        // Sum of spatial inputs
    var temporalSummation : Float;       // Sum of temporal inputs
    var coincidenceDetected : Bool;      // Coincident input?
    var dendriticSpikes : Nat;           // Number of dendritic spikes
    var backpropagation : Float;         // Soma → dendrite signal
    var localInhibition : [var Float];   // Per-compartment inhibition
    var branchSaturation : [var Float];  // How saturated each branch
    var activeZones : [var Bool];        // Which compartments active
    var computationalModes : [Text];     // What operations possible
  };

  public func initDendriticCompartment(branchType : Text) : DendriticCompartment {
    {
      var voltage = -70.0;  // mV resting potential
      var calcium = 0.0001;
      var inputWeight = 1.0;
      var distanceFromSoma = 100.0;  // μm
      var parentCompartment = 0;
      var childCompartments = Array.init<Nat>(4, func(_ : Nat) : Nat { 0 });
      var numChildren = 0;
      var spikeProbability = 0.0;
      var lastSpikeTime = -1000.0;
      var branchType = branchType;
    }
  };

  public func initDendriticTree(numCompartments : Nat) : DendriticTree {
    let compartments = Array.init<DendriticCompartment>(numCompartments, func(i : Nat) : DendriticCompartment {
      let branchType = if (i < numCompartments / 3) { "basal" }
                       else if (i < 2 * numCompartments / 3) { "apical" }
                       else { "oblique" };
      initDendriticCompartment(branchType)
    });
    
    let branchPoints = Array.init<Float>(numCompartments / 3, func(_ : Nat) : Float { -70.0 });
    
    {
      var compartments = compartments;
      var numCompartments = numCompartments;
      var somaVoltage = -70.0;
      var somaticIntegration = 0.0;
      var electrotonicLength = 100.0;  // μm
      var inputResistance = 100.0;  // MΩ
      var coincidenceWindow = 10.0;  // ms
      var branchPoint = branchPoints;
      var nonlinearityThreshold = -40.0;  // mV for dendritic spike
      var plateauDuration = 50.0;  // ms
    }
  };

  public func initDendriticProcessing(numCompartments : Nat) : DendriticProcessing {
    let inhibition = Array.init<Float>(numCompartments, func(_ : Nat) : Float { 0.0 });
    let saturation = Array.init<Float>(numCompartments, func(_ : Nat) : Float { 0.0 });
    let active = Array.init<Bool>(numCompartments, func(_ : Nat) : Bool { false });
    
    {
      tree = initDendriticTree(numCompartments);
      var spatialSummation = 0.0;
      var temporalSummation = 0.0;
      var coincidenceDetected = false;
      var dendriticSpikes = 0;
      var backpropagation = 0.0;
      var localInhibition = inhibition;
      var branchSaturation = saturation;
      var activeZones = active;
      var computationalModes = ["summation", "multiplication", "coincidence", "sequence"];
    }
  };

  // Process dendritic inputs
  public func processDendriticInputs(
    proc : DendriticProcessing,
    inputs : [Float],
    inputCompartments : [Nat],
    dt : Float
  ) {
    let tree = proc.tree;
    let n = tree.numCompartments;
    
    // Reset active zones
    for (i in Iter.range(0, n - 1)) {
      proc.activeZones[i] := false;
    };
    
    // Apply inputs to compartments
    let numInputs = Nat.min(Array.size(inputs), Array.size(inputCompartments));
    var spatialSum : Float = 0.0;
    
    for (i in Iter.range(0, numInputs - 1)) {
      let compIdx = inputCompartments[i] % n;
      let comp = tree.compartments[compIdx];
      
      // Local voltage change
      let inputCurrent = inputs[i] * comp.inputWeight;
      comp.voltage += inputCurrent * tree.inputResistance / 1000.0;  // mV
      
      // Spatial attenuation toward soma
      let attenuation = exp(-comp.distanceFromSoma / tree.electrotonicLength);
      spatialSum += inputCurrent * attenuation;
      
      // Mark as active
      if (comp.voltage > -50.0) {
        proc.activeZones[compIdx] := true;
      };
      
      // Dendritic spike check
      if (comp.voltage > tree.nonlinearityThreshold) {
        comp.spikeProbability := 0.8;
        
        if (comp.spikeProbability > 0.5) {
          proc.dendriticSpikes += 1;
          comp.lastSpikeTime := 0.0;  // Current time
          comp.voltage := 20.0;  // Spike peak
          comp.calcium += 0.001;
        };
      };
    };
    
    proc.spatialSummation := spatialSum;
    
    // Temporal summation (decay of previous voltage)
    proc.temporalSummation *= exp(-dt / 20.0);  // 20ms time constant
    proc.temporalSummation += spatialSum;
    
    // Coincidence detection
    var numActiveCompartments : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      if (proc.activeZones[i]) {
        numActiveCompartments += 1;
      };
    };
    proc.coincidenceDetected := numActiveCompartments >= 3;
    
    // Somatic integration
    tree.somaticIntegration := proc.temporalSummation * 0.5;
    tree.somaVoltage += tree.somaticIntegration;
    
    // Voltage decay
    for (i in Iter.range(0, n - 1)) {
      let comp = tree.compartments[i];
      comp.voltage := -70.0 + (comp.voltage + 70.0) * exp(-dt / 10.0);
      comp.calcium := comp.calcium * exp(-dt / 100.0);  // 100ms decay
    };
    
    // Backpropagation from soma
    if (tree.somaVoltage > -40.0) {
      proc.backpropagation := (tree.somaVoltage + 70.0) / 100.0;
    } else {
      proc.backpropagation *= 0.9;
    };
    
    // Branch saturation
    for (i in Iter.range(0, n - 1)) {
      let comp = tree.compartments[i];
      proc.branchSaturation[i] := (comp.voltage + 70.0) / 90.0;  // Normalize to 0-1
      proc.branchSaturation[i] := clamp(proc.branchSaturation[i], 0.0, 1.0);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // GAIN MODULATION — MULTIPLICATIVE INTERACTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Modulating neural responses multiplicatively:
  //
  // 1. GAIN FIELD: Response scaling by context
  // 2. DIVISIVE NORMALIZATION: Competition between inputs
  // 3. NEUROMODULATION: Global state changes
  // 4. ATTENTION: Selective amplification
  //

  public type GainModulation = {
    var gainFactor : [var Float];        // Multiplicative gain per neuron
    var numNeurons : Nat;
    var baselineActivity : [var Float];  // Baseline firing rate
    var modulatoryInput : [var Float];   // Modulatory signals
    var normalizationPool : [[var Float]]; // Neurons that normalize together
    var poolSize : Nat;
    var sigmaNorm : Float;               // Normalization semi-saturation
    var exponentNorm : Float;            // Normalization exponent
    var attentionalGain : [var Float];   // Attention-based gain
    var arousalGain : Float;             // Global arousal level
  };

  public type DivisiveNormalization = {
    gain : GainModulation;
    var driveSignal : [var Float];       // Excitatory drive
    var suppressionSignal : [var Float]; // Suppressive surround
    var normalizedOutput : [var Float];  // After normalization
    var contrastGain : Float;            // Contrast response
    var adaptationLevel : [var Float];   // Response adaptation
    var saturationPoint : [var Float];   // Response ceiling
    var dynamicRange : Float;            // Operating range
    var linearityIndex : Float;          // How linear is response
  };

  public func initGainModulation(numNeurons : Nat, poolSize : Nat) : GainModulation {
    let gains = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 1.0 });
    let baseline = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.1 });
    let modulatory = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let attnGain = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 1.0 });
    
    let pools = Array.init<[var Float]>(numNeurons, func(i : Nat) : [var Float] {
      Array.init<Float>(poolSize, func(j : Nat) : Float {
        Float.fromInt((i + j) % numNeurons)  // Pool members
      })
    });
    
    {
      var gainFactor = gains;
      var numNeurons = numNeurons;
      var baselineActivity = baseline;
      var modulatoryInput = modulatory;
      var normalizationPool = pools;
      var poolSize = poolSize;
      var sigmaNorm = 1.0;
      var exponentNorm = 2.0;
      var attentionalGain = attnGain;
      var arousalGain = 1.0;
    }
  };

  public func initDivisiveNormalization(numNeurons : Nat, poolSize : Nat) : DivisiveNormalization {
    let drive = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let suppress = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let output = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 0.0 });
    let adapt = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 1.0 });
    let sat = Array.init<Float>(numNeurons, func(_ : Nat) : Float { 1.0 });
    
    {
      gain = initGainModulation(numNeurons, poolSize);
      var driveSignal = drive;
      var suppressionSignal = suppress;
      var normalizedOutput = output;
      var contrastGain = 1.0;
      var adaptationLevel = adapt;
      var saturationPoint = sat;
      var dynamicRange = 2.0;
      var linearityIndex = 0.5;
    }
  };

  // Apply divisive normalization
  public func applyDivisiveNormalization(
    dn : DivisiveNormalization,
    inputs : [Float]
  ) {
    let gm = dn.gain;
    let n = gm.numNeurons;
    
    // Set drive signals
    for (i in Iter.range(0, Nat.min(Array.size(inputs), n) - 1)) {
      dn.driveSignal[i] := inputs[i];
    };
    
    // Compute suppression from normalization pool
    for (i in Iter.range(0, n - 1)) {
      var suppSum : Float = 0.0;
      
      for (j in Iter.range(0, gm.poolSize - 1)) {
        let poolMember = Int.abs(Float.toInt(gm.normalizationPool[i][j])) % n;
        suppSum += pow(dn.driveSignal[poolMember], gm.exponentNorm);
      };
      
      dn.suppressionSignal[i] := suppSum / Float.fromInt(gm.poolSize);
    };
    
    // Normalize: R = D^n / (σ^n + S)
    for (i in Iter.range(0, n - 1)) {
      let drive = dn.driveSignal[i];
      let supp = dn.suppressionSignal[i];
      let sigma = gm.sigmaNorm;
      
      let numerator = pow(drive, gm.exponentNorm);
      let denominator = pow(sigma, gm.exponentNorm) + supp;
      
      if (denominator > 0.0001) {
        dn.normalizedOutput[i] := numerator / denominator;
      } else {
        dn.normalizedOutput[i] := 0.0;
      };
      
      // Apply gain factors
      dn.normalizedOutput[i] *= gm.gainFactor[i];
      dn.normalizedOutput[i] *= gm.attentionalGain[i];
      dn.normalizedOutput[i] *= gm.arousalGain;
      
      // Adaptation
      dn.adaptationLevel[i] := 0.95 * dn.adaptationLevel[i] + 0.05 * dn.normalizedOutput[i];
      dn.normalizedOutput[i] /= (1.0 + dn.adaptationLevel[i]);
      
      // Saturation
      dn.normalizedOutput[i] := clamp(dn.normalizedOutput[i], 0.0, dn.saturationPoint[i]);
    };
    
    // Compute contrast gain
    var maxOutput : Float = 0.0;
    var minOutput : Float = 1.0;
    for (i in Iter.range(0, n - 1)) {
      if (dn.normalizedOutput[i] > maxOutput) { maxOutput := dn.normalizedOutput[i] };
      if (dn.normalizedOutput[i] < minOutput) { minOutput := dn.normalizedOutput[i] };
    };
    dn.contrastGain := maxOutput - minOutput;
    
    // Dynamic range
    dn.dynamicRange := if (minOutput > 0.0) { maxOutput / minOutput } else { maxOutput };
    
    // Linearity index (correlation between input and output)
    var sumXY : Float = 0.0;
    var sumXX : Float = 0.0;
    var sumYY : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let x = dn.driveSignal[i];
      let y = dn.normalizedOutput[i];
      sumXY += x * y;
      sumXX += x * x;
      sumYY += y * y;
    };
    
    let denom = sqrt(sumXX * sumYY);
    dn.linearityIndex := if (denom > 0.0) { sumXY / denom } else { 0.0 };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SPARSE CODING — EFFICIENT REPRESENTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Efficient neural coding with sparse activations:
  //
  // 1. OVERCOMPLETE DICTIONARY: More features than inputs
  // 2. SPARSITY CONSTRAINT: Few active neurons
  // 3. LATERAL INHIBITION: Winner-take-all competition
  // 4. ENERGY MINIMIZATION: Minimize reconstruction + sparsity
  //

  public type SparseCoding = {
    var dictionary : [[var Float]];      // Overcomplete dictionary
    var numAtoms : Nat;                  // Dictionary size
    var inputDim : Nat;                  // Input dimensionality
    var activations : [var Float];       // Sparse coefficients
    var reconstruction : [var Float];    // Reconstructed input
    var residual : [var Float];          // Reconstruction error
    var sparsityLevel : Float;           // Fraction active
    var sparsityPenalty : Float;         // λ in LASSO
    var lateralInhibition : [[var Float]]; // Inhibition between atoms
    var activeSet : [var Bool];          // Currently active atoms
  };

  public type SparseNetwork = {
    sparse : SparseCoding;
    var learningRate : Float;            // Dictionary learning rate
    var momentumCoeff : Float;           // Momentum for learning
    var momentum : [[var Float]];        // Accumulated momentum
    var lifetime : [var Float];          // How long each atom active
    var usageCount : [var Nat];          // How often each atom used
    var orthogonality : Float;           // Dictionary orthogonality
    var coherence : Float;               // Maximum inner product
    var energyFunction : Float;          // Current energy value
    var convergenceRate : Float;         // Learning convergence
  };

  public func initSparseCoding(inputDim : Nat, numAtoms : Nat) : SparseCoding {
    // Random dictionary (would normally be orthogonalized)
    let dict = Array.init<[var Float]>(numAtoms, func(i : Nat) : [var Float] {
      Array.init<Float>(inputDim, func(j : Nat) : Float {
        (Float.fromInt((i * 17 + j * 31) % 100) / 50.0 - 1.0) / sqrt(Float.fromInt(inputDim))
      })
    });
    
    let acts = Array.init<Float>(numAtoms, func(_ : Nat) : Float { 0.0 });
    let recon = Array.init<Float>(inputDim, func(_ : Nat) : Float { 0.0 });
    let resid = Array.init<Float>(inputDim, func(_ : Nat) : Float { 0.0 });
    
    let lateral = Array.init<[var Float]>(numAtoms, func(_ : Nat) : [var Float] {
      Array.init<Float>(numAtoms, func(_ : Nat) : Float { 0.0 })
    });
    
    let active = Array.init<Bool>(numAtoms, func(_ : Nat) : Bool { false });
    
    {
      var dictionary = dict;
      var numAtoms = numAtoms;
      var inputDim = inputDim;
      var activations = acts;
      var reconstruction = recon;
      var residual = resid;
      var sparsityLevel = 0.0;
      var sparsityPenalty = 0.1;
      var lateralInhibition = lateral;
      var activeSet = active;
    }
  };

  public func initSparseNetwork(inputDim : Nat, numAtoms : Nat) : SparseNetwork {
    let mom = Array.init<[var Float]>(numAtoms, func(_ : Nat) : [var Float] {
      Array.init<Float>(inputDim, func(_ : Nat) : Float { 0.0 })
    });
    
    let life = Array.init<Float>(numAtoms, func(_ : Nat) : Float { 0.0 });
    let usage = Array.init<Nat>(numAtoms, func(_ : Nat) : Nat { 0 });
    
    {
      sparse = initSparseCoding(inputDim, numAtoms);
      var learningRate = 0.01;
      var momentumCoeff = 0.9;
      var momentum = mom;
      var lifetime = life;
      var usageCount = usage;
      var orthogonality = 0.0;
      var coherence = 0.0;
      var energyFunction = 0.0;
      var convergenceRate = 0.0;
    }
  };

  // Encode input with sparse coding
  public func sparseEncode(
    net : SparseNetwork,
    input : [Float],
    numIterations : Nat
  ) {
    let sc = net.sparse;
    let n = sc.numAtoms;
    let d = sc.inputDim;
    
    // Initialize activations
    for (i in Iter.range(0, n - 1)) {
      sc.activations[i] := 0.0;
      sc.activeSet[i] := false;
    };
    
    // Copy input to residual
    for (j in Iter.range(0, Nat.min(Array.size(input), d) - 1)) {
      sc.residual[j] := input[j];
    };
    
    // Matching pursuit iterations
    for (iter in Iter.range(0, numIterations - 1)) {
      // Find best matching atom
      var maxCorr : Float = 0.0;
      var bestAtom : Nat = 0;
      
      for (i in Iter.range(0, n - 1)) {
        // Correlation with residual
        var corr : Float = 0.0;
        for (j in Iter.range(0, d - 1)) {
          corr += sc.dictionary[i][j] * sc.residual[j];
        };
        
        // Apply lateral inhibition
        for (k in Iter.range(0, n - 1)) {
          if (sc.activeSet[k]) {
            corr -= sc.lateralInhibition[i][k] * sc.activations[k];
          };
        };
        
        if (Float.abs(corr) > Float.abs(maxCorr)) {
          maxCorr := corr;
          bestAtom := i;
        };
      };
      
      // Activate best atom if above threshold
      if (Float.abs(maxCorr) > sc.sparsityPenalty) {
        sc.activations[bestAtom] += maxCorr;
        sc.activeSet[bestAtom] := true;
        net.usageCount[bestAtom] += 1;
        
        // Update residual
        for (j in Iter.range(0, d - 1)) {
          sc.residual[j] -= maxCorr * sc.dictionary[bestAtom][j];
        };
      };
    };
    
    // Compute reconstruction
    for (j in Iter.range(0, d - 1)) {
      sc.reconstruction[j] := 0.0;
      for (i in Iter.range(0, n - 1)) {
        sc.reconstruction[j] += sc.activations[i] * sc.dictionary[i][j];
      };
    };
    
    // Compute sparsity level
    var activeCount : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      if (sc.activeSet[i]) { activeCount += 1 };
    };
    sc.sparsityLevel := Float.fromInt(activeCount) / Float.fromInt(n);
    
    // Update lifetime
    for (i in Iter.range(0, n - 1)) {
      if (sc.activeSet[i]) {
        net.lifetime[i] += 1.0;
      } else {
        net.lifetime[i] *= 0.99;
      };
    };
    
    // Compute energy
    // E = ||x - Da||² + λ||a||₁
    var reconError : Float = 0.0;
    for (j in Iter.range(0, d - 1)) {
      let diff = sc.residual[j];
      reconError += diff * diff;
    };
    
    var l1Norm : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      l1Norm += Float.abs(sc.activations[i]);
    };
    
    net.energyFunction := reconError + sc.sparsityPenalty * l1Norm;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // PREDICTIVE TIMING — TEMPORAL PREDICTION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural mechanisms for temporal prediction:
  //
  // 1. INTERVAL TIMING: Estimating durations
  // 2. BEAT INDUCTION: Extracting periodicity
  // 3. SEQUENCE PREDICTION: What comes next
  // 4. TEMPORAL CREDIT ASSIGNMENT: Delayed rewards
  //

  public type IntervalTiming = {
    var pacemaker : Float;               // Current pacemaker value
    var accumulator : Float;             // Accumulated time
    var referenceMemory : [var Float];   // Stored interval representations
    var numIntervals : Nat;
    var maxIntervals : Nat;
    var clockSpeed : Float;              // Pacemaker rate
    var comparisonThreshold : Float;     // When to respond
    var scalarVariability : Float;       // Weber fraction
    var gateOpen : Bool;                 // Accumulator gate
    var lastEventTime : Float;           // Time of last event
  };

  public type BeatInduction = {
    timing : IntervalTiming;
    var beatPeriod : Float;              // Estimated beat period
    var phase : Float;                   // Current phase in beat
    var periodConfidence : Float;        // Confidence in estimate
    var onsetTimes : [var Float];        // Recent onset times
    var numOnsets : Nat;
    var maxOnsets : Nat;
    var tempoFlexibility : Float;        // Tempo adaptation rate
    var syncopation : Float;             // Off-beat events
    var metricStrength : Float;          // Beat salience
    var periodicitySpectrum : [var Float]; // Fourier of IOIs
  };

  public type SequencePrediction = {
    beat : BeatInduction;
    var sequenceBuffer : [[var Float]]; // Recent sequence elements
    var bufferSize : Nat;
    var currentIdx : Nat;
    var predictionWindow : Nat;          // How far ahead to predict
    var transitionMatrix : [[var Float]];// Learned transitions
    var stateSize : Nat;
    var predictionAccuracy : Float;      // Recent accuracy
    var surprisal : Float;               // -log P(observed)
    var entropy : Float;                 // Uncertainty in prediction
    var nextStatePrediction : [var Float]; // Predicted next state
  };

  public func initIntervalTiming(maxIntervals : Nat) : IntervalTiming {
    let refs = Array.init<Float>(maxIntervals, func(_ : Nat) : Float { 0.0 });
    
    {
      var pacemaker = 0.0;
      var accumulator = 0.0;
      var referenceMemory = refs;
      var numIntervals = 0;
      var maxIntervals = maxIntervals;
      var clockSpeed = 100.0;  // Hz
      var comparisonThreshold = 0.9;
      var scalarVariability = 0.1;  // Weber fraction
      var gateOpen = false;
      var lastEventTime = 0.0;
    }
  };

  public func initBeatInduction(maxOnsets : Nat, spectrumSize : Nat) : BeatInduction {
    let onsets = Array.init<Float>(maxOnsets, func(_ : Nat) : Float { 0.0 });
    let spectrum = Array.init<Float>(spectrumSize, func(_ : Nat) : Float { 0.0 });
    
    {
      timing = initIntervalTiming(10);
      var beatPeriod = 500.0;  // 120 BPM default
      var phase = 0.0;
      var periodConfidence = 0.0;
      var onsetTimes = onsets;
      var numOnsets = 0;
      var maxOnsets = maxOnsets;
      var tempoFlexibility = 0.1;
      var syncopation = 0.0;
      var metricStrength = 0.0;
      var periodicitySpectrum = spectrum;
    }
  };

  public func initSequencePrediction(bufferSize : Nat, stateSize : Nat, predWindow : Nat) : SequencePrediction {
    let buffer = Array.init<[var Float]>(bufferSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 })
    });
    
    let trans = Array.init<[var Float]>(stateSize, func(_ : Nat) : [var Float] {
      Array.init<Float>(stateSize, func(_ : Nat) : Float { 1.0 / Float.fromInt(stateSize) })
    });
    
    let pred = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
    
    {
      beat = initBeatInduction(50, 20);
      var sequenceBuffer = buffer;
      var bufferSize = bufferSize;
      var currentIdx = 0;
      var predictionWindow = predWindow;
      var transitionMatrix = trans;
      var stateSize = stateSize;
      var predictionAccuracy = 0.0;
      var surprisal = 0.0;
      var entropy = 0.0;
      var nextStatePrediction = pred;
    }
  };

  // Update interval timing
  public func updateIntervalTiming(
    timing : IntervalTiming,
    eventOccurred : Bool,
    currentTime : Float
  ) {
    // Pacemaker runs continuously
    timing.pacemaker += 1.0 / timing.clockSpeed * 1000.0;  // ms
    
    if (timing.gateOpen) {
      // Accumulate time
      timing.accumulator := currentTime - timing.lastEventTime;
    };
    
    if (eventOccurred) {
      if (timing.gateOpen) {
        // Store interval
        if (timing.numIntervals < timing.maxIntervals) {
          timing.referenceMemory[timing.numIntervals] := timing.accumulator;
          timing.numIntervals += 1;
        };
        
        // Reset accumulator
        timing.accumulator := 0.0;
      };
      
      timing.gateOpen := true;
      timing.lastEventTime := currentTime;
    };
  };

  // Update beat induction
  public func updateBeatInduction(
    beat : BeatInduction,
    onsetOccurred : Bool,
    currentTime : Float
  ) {
    // Update interval timing
    updateIntervalTiming(beat.timing, onsetOccurred, currentTime);
    
    // Phase accumulation
    beat.phase += 1.0 / beat.beatPeriod;
    if (beat.phase >= 1.0) { beat.phase -= 1.0 };
    
    if (onsetOccurred) {
      // Record onset
      if (beat.numOnsets < beat.maxOnsets) {
        beat.onsetTimes[beat.numOnsets] := currentTime;
        beat.numOnsets += 1;
      } else {
        // Shift buffer
        for (i in Iter.range(0, beat.maxOnsets - 2)) {
          beat.onsetTimes[i] := beat.onsetTimes[i + 1];
        };
        beat.onsetTimes[beat.maxOnsets - 1] := currentTime;
      };
      
      // Check phase alignment
      let phaseError = Float.abs(beat.phase - 0.5);
      if (phaseError < 0.25) {
        // On beat
        beat.metricStrength := 0.9 * beat.metricStrength + 0.1;
      } else {
        // Off beat (syncopation)
        beat.syncopation := 0.9 * beat.syncopation + 0.1;
      };
      
      // Phase correction
      let correction = -phaseError * beat.tempoFlexibility;
      beat.phase += correction;
      
      // Period estimation from IOIs
      if (beat.numOnsets >= 3) {
        var sumIOI : Float = 0.0;
        for (i in Iter.range(1, beat.numOnsets - 1)) {
          sumIOI += beat.onsetTimes[i] - beat.onsetTimes[i - 1];
        };
        let avgIOI = sumIOI / Float.fromInt(beat.numOnsets - 1);
        
        // Smooth update of period
        beat.beatPeriod := 0.8 * beat.beatPeriod + 0.2 * avgIOI;
        beat.periodConfidence := 0.9 * beat.periodConfidence + 0.1;
      };
    } else {
      // Decay confidence without onsets
      beat.periodConfidence *= 0.999;
      beat.metricStrength *= 0.99;
      beat.syncopation *= 0.99;
    };
  };

  // Update sequence prediction
  public func updateSequencePrediction(
    seq : SequencePrediction,
    currentState : [Float],
    currentTime : Float
  ) {
    let n = seq.stateSize;
    
    // Check prediction accuracy
    let predicted = seq.nextStatePrediction;
    var accuracy : Float = 0.0;
    
    for (i in Iter.range(0, Nat.min(Array.size(currentState), n) - 1)) {
      accuracy += 1.0 - Float.abs(predicted[i] - currentState[i]);
    };
    seq.predictionAccuracy := accuracy / Float.fromInt(n);
    
    // Surprisal (-log probability)
    var prob : Float = 0.0;
    for (i in Iter.range(0, n - 1)) {
      // Approximate probability from previous state
      let prevIdx = (seq.currentIdx + seq.bufferSize - 1) % seq.bufferSize;
      var maxPrev : Float = 0.0;
      var maxPrevIdx : Nat = 0;
      
      for (j in Iter.range(0, n - 1)) {
        if (seq.sequenceBuffer[prevIdx][j] > maxPrev) {
          maxPrev := seq.sequenceBuffer[prevIdx][j];
          maxPrevIdx := j;
        };
      };
      
      if (i < Array.size(currentState)) {
        prob += seq.transitionMatrix[maxPrevIdx][i] * currentState[i];
      };
    };
    
    if (prob > 0.001) {
      seq.surprisal := -ln(prob);
    } else {
      seq.surprisal := 10.0;  // High surprisal
    };
    
    // Store current state
    for (i in Iter.range(0, Nat.min(Array.size(currentState), n) - 1)) {
      seq.sequenceBuffer[seq.currentIdx][i] := currentState[i];
    };
    
    // Update transition matrix
    let prevIdx = (seq.currentIdx + seq.bufferSize - 1) % seq.bufferSize;
    for (i in Iter.range(0, n - 1)) {
      for (j in Iter.range(0, n - 1)) {
        let prevAct = seq.sequenceBuffer[prevIdx][i];
        let currAct = seq.sequenceBuffer[seq.currentIdx][j];
        
        // Hebbian update
        seq.transitionMatrix[i][j] := 
          0.99 * seq.transitionMatrix[i][j] + 
          0.01 * prevAct * currAct;
      };
    };
    
    // Normalize transition matrix
    for (i in Iter.range(0, n - 1)) {
      var sum : Float = 0.0;
      for (j in Iter.range(0, n - 1)) {
        sum += seq.transitionMatrix[i][j];
      };
      if (sum > 0.0) {
        for (j in Iter.range(0, n - 1)) {
          seq.transitionMatrix[i][j] /= sum;
        };
      };
    };
    
    // Predict next state
    for (j in Iter.range(0, n - 1)) {
      seq.nextStatePrediction[j] := 0.0;
      for (i in Iter.range(0, n - 1)) {
        seq.nextStatePrediction[j] += 
          seq.transitionMatrix[i][j] * seq.sequenceBuffer[seq.currentIdx][i];
      };
    };
    
    // Entropy of prediction
    seq.entropy := 0.0;
    for (j in Iter.range(0, n - 1)) {
      let p = seq.nextStatePrediction[j];
      if (p > 0.001) {
        seq.entropy -= p * ln(p);
      };
    };
    
    // Advance buffer index
    seq.currentIdx := (seq.currentIdx + 1) % seq.bufferSize;
    
    // Update beat induction
    let maxState = Array.fold<Float, Float>(
      Array.tabulate<Float>(n, func(i : Nat) : Float { seq.sequenceBuffer[seq.currentIdx][i] }),
      0.0,
      func(acc : Float, x : Float) : Float { if (x > acc) { x } else { acc } }
    );
    updateBeatInduction(seq.beat, maxState > 0.5, currentTime);
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // REWARD PREDICTION — DOPAMINERGIC SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural implementation of reward prediction:
  //
  // 1. RPE: Reward Prediction Error (δ = r - V(s))
  // 2. DOPAMINE DYNAMICS: Phasic vs tonic firing
  // 3. CREDIT ASSIGNMENT: Eligibility traces
  // 4. TEMPORAL DISCOUNTING: Future reward devaluation
  //

  public type RewardPrediction = {
    var rewardSignal : Float;            // Current reward
    var predictedReward : Float;         // Expected reward V(s)
    var predictionError : Float;         // δ = r - V
    var valueFunction : [var Float];     // State values
    var stateSize : Nat;
    var currentState : Nat;              // Current state index
    var discountFactor : Float;          // γ
    var learningRate : Float;            // α
    var eligibilityTraces : [var Float]; // e(s)
    var traceDecay : Float;              // λ
  };

  public type DopamineSystem = {
    reward : RewardPrediction;
    var tonicLevel : Float;              // Baseline dopamine
    var phasicBurst : Float;             // Phasic response
    var dip : Float;                     // Below-baseline dip
    var firingRate : Float;              // Current DA neuron firing
    var releaseRate : Float;             // Synaptic release
    var reuptakeRate : Float;            // Clearance
    var receptorOccupancy : [var Float]; // D1/D2 binding
    var motivationalState : Float;       // Drive from DA
    var effortCost : Float;              // Cost of action
    var anhedoniaLevel : Float;          // Reward insensitivity
  };

  public type RewardLearning = {
    dopamine : DopamineSystem;
    var rewardHistory : [var Float];     // Recent rewards
    var historyIdx : Nat;
    var historySize : Nat;
    var averageReward : Float;           // Running average
    var rewardVariance : Float;          // Reward variability
    var rewardRate : Float;              // Rewards per time
    var optimalityGap : Float;           // Distance from optimal
    var explorationBonus : Float;        // UCB-style bonus
    var curiosityDrive : Float;          // Intrinsic motivation
    var habitStrength : [var Float];     // S-R habit learning
  };

  public func initRewardPrediction(stateSize : Nat) : RewardPrediction {
    let values = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
    let traces = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
    
    {
      var rewardSignal = 0.0;
      var predictedReward = 0.0;
      var predictionError = 0.0;
      var valueFunction = values;
      var stateSize = stateSize;
      var currentState = 0;
      var discountFactor = 0.99;
      var learningRate = 0.1;
      var eligibilityTraces = traces;
      var traceDecay = 0.9;
    }
  };

  public func initDopamineSystem(stateSize : Nat) : DopamineSystem {
    let receptors = Array.init<Float>(2, func(_ : Nat) : Float { 0.5 });  // D1, D2
    
    {
      reward = initRewardPrediction(stateSize);
      var tonicLevel = 0.5;
      var phasicBurst = 0.0;
      var dip = 0.0;
      var firingRate = 4.0;  // Hz baseline
      var releaseRate = 0.5;
      var reuptakeRate = 0.3;
      var receptorOccupancy = receptors;
      var motivationalState = 0.5;
      var effortCost = 0.0;
      var anhedoniaLevel = 0.0;
    }
  };

  public func initRewardLearning(stateSize : Nat, historySize : Nat) : RewardLearning {
    let history = Array.init<Float>(historySize, func(_ : Nat) : Float { 0.0 });
    let habits = Array.init<Float>(stateSize, func(_ : Nat) : Float { 0.0 });
    
    {
      dopamine = initDopamineSystem(stateSize);
      var rewardHistory = history;
      var historyIdx = 0;
      var historySize = historySize;
      var averageReward = 0.0;
      var rewardVariance = 0.0;
      var rewardRate = 0.0;
      var optimalityGap = 0.0;
      var explorationBonus = 0.1;
      var curiosityDrive = 0.5;
      var habitStrength = habits;
    }
  };

  // Update reward prediction
  public func updateRewardPrediction(
    rp : RewardPrediction,
    reward : Float,
    newState : Nat
  ) {
    let n = rp.stateSize;
    let s = rp.currentState % n;
    let sp = newState % n;
    
    rp.rewardSignal := reward;
    rp.predictedReward := rp.valueFunction[s];
    
    // TD error
    let target = reward + rp.discountFactor * rp.valueFunction[sp];
    rp.predictionError := target - rp.valueFunction[s];
    
    // Update eligibility traces
    for (i in Iter.range(0, n - 1)) {
      rp.eligibilityTraces[i] *= rp.discountFactor * rp.traceDecay;
    };
    rp.eligibilityTraces[s] := 1.0;
    
    // Update value function
    for (i in Iter.range(0, n - 1)) {
      rp.valueFunction[i] += rp.learningRate * rp.predictionError * rp.eligibilityTraces[i];
    };
    
    rp.currentState := sp;
  };

  // Update dopamine system
  public func updateDopamineSystem(
    da : DopamineSystem,
    reward : Float,
    newState : Nat,
    dt : Float
  ) {
    // Update reward prediction
    updateRewardPrediction(da.reward, reward, newState);
    
    let rpe = da.reward.predictionError;
    
    // Phasic response to RPE
    if (rpe > 0.0) {
      // Positive RPE → burst
      da.phasicBurst := rpe * 2.0;
      da.dip := 0.0;
      da.firingRate := 4.0 + rpe * 20.0;  // Burst up to ~40 Hz
    } else if (rpe < 0.0) {
      // Negative RPE → dip
      da.phasicBurst := 0.0;
      da.dip := -rpe;
      da.firingRate := 4.0 + rpe * 4.0;  // Can go to 0
      if (da.firingRate < 0.0) { da.firingRate := 0.0 };
    } else {
      // No RPE → tonic
      da.phasicBurst *= 0.9;
      da.dip *= 0.9;
      da.firingRate := 4.0;
    };
    
    // Dopamine release and clearance
    da.releaseRate := da.firingRate / 20.0;
    let daLevel = da.tonicLevel + da.phasicBurst - da.dip;
    
    // Receptor binding
    da.receptorOccupancy[0] := daLevel / (daLevel + 0.5);  // D1 (high affinity)
    da.receptorOccupancy[1] := daLevel / (daLevel + 2.0);  // D2 (low affinity)
    
    // Motivational state
    da.motivationalState := da.receptorOccupancy[0] * (1.0 - da.anhedoniaLevel);
    
    // Tonic level homeostasis
    da.tonicLevel := 0.99 * da.tonicLevel + 0.01 * 0.5;
    
    // Decay phasic components
    da.phasicBurst *= exp(-dt / 200.0);  // 200ms decay
    da.dip *= exp(-dt / 500.0);  // 500ms decay
  };

  // Update reward learning
  public func updateRewardLearning(
    rl : RewardLearning,
    reward : Float,
    state : Nat,
    dt : Float
  ) {
    // Update dopamine system
    updateDopamineSystem(rl.dopamine, reward, state, dt);
    
    // Store in history
    rl.rewardHistory[rl.historyIdx] := reward;
    rl.historyIdx := (rl.historyIdx + 1) % rl.historySize;
    
    // Compute average reward
    var sum : Float = 0.0;
    for (i in Iter.range(0, rl.historySize - 1)) {
      sum += rl.rewardHistory[i];
    };
    rl.averageReward := sum / Float.fromInt(rl.historySize);
    
    // Compute variance
    var sumSq : Float = 0.0;
    for (i in Iter.range(0, rl.historySize - 1)) {
      let diff = rl.rewardHistory[i] - rl.averageReward;
      sumSq += diff * diff;
    };
    rl.rewardVariance := sumSq / Float.fromInt(rl.historySize);
    
    // Reward rate
    var rewardCount : Nat = 0;
    for (i in Iter.range(0, rl.historySize - 1)) {
      if (rl.rewardHistory[i] > 0.0) { rewardCount += 1 };
    };
    rl.rewardRate := Float.fromInt(rewardCount) / Float.fromInt(rl.historySize);
    
    // Curiosity drive (inverse of average reward)
    rl.curiosityDrive := 1.0 / (1.0 + rl.averageReward * 2.0);
    
    // Exploration bonus (UCB-style)
    let visitCount = rl.habitStrength[state % rl.dopamine.reward.stateSize];
    if (visitCount > 0.0) {
      rl.explorationBonus := sqrt(ln(Float.fromInt(rl.historyIdx + 1)) / visitCount);
    } else {
      rl.explorationBonus := 1.0;
    };
    
    // Habit strength update
    rl.habitStrength[state % rl.dopamine.reward.stateSize] += 1.0;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NEUROMODULATION — GLOBAL STATE CHANGES
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Multiple neuromodulatory systems:
  //
  // 1. DOPAMINE: Reward, motivation, learning
  // 2. SEROTONIN: Mood, patience, aversion
  // 3. NOREPINEPHRINE: Arousal, attention, stress
  // 4. ACETYLCHOLINE: Learning, attention, memory
  // 5. HISTAMINE: Wakefulness
  // 6. OREXIN: Energy homeostasis
  //

  public type NeuromodulatorState = {
    var level : Float;                   // Current concentration
    var baseline : Float;                // Tonic level
    var releaseRate : Float;             // Production rate
    var clearanceRate : Float;           // Removal rate
    var receptorTypes : [var Float];     // Receptor occupancy per type
    var numReceptorTypes : Nat;
    var effectOnExcitability : Float;    // Impact on firing threshold
    var effectOnPlasticity : Float;      // Impact on learning
    var effectOnGain : Float;            // Impact on response gain
    var synthesisCapacity : Float;       // Production limit
  };

  public type NeuromodulatorSystem = {
    var dopamine : NeuromodulatorState;
    var serotonin : NeuromodulatorState;
    var norepinephrine : NeuromodulatorState;
    var acetylcholine : NeuromodulatorState;
    var histamine : NeuromodulatorState;
    var orexin : NeuromodulatorState;
    var overallArousal : Float;          // Combined arousal signal
    var overallPlasticity : Float;       // Combined learning signal
    var overallMood : Float;             // Combined affective state
    var circadianModulation : Float;     // Time-of-day effect
  };

  public func initNeuromodulatorState(numReceptorTypes : Nat, baseline : Float) : NeuromodulatorState {
    let receptors = Array.init<Float>(numReceptorTypes, func(_ : Nat) : Float { 0.5 });
    
    {
      var level = baseline;
      var baseline = baseline;
      var releaseRate = 0.1;
      var clearanceRate = 0.1;
      var receptorTypes = receptors;
      var numReceptorTypes = numReceptorTypes;
      var effectOnExcitability = 0.0;
      var effectOnPlasticity = 0.0;
      var effectOnGain = 1.0;
      var synthesisCapacity = 1.0;
    }
  };

  public func initNeuromodulatorSystem() : NeuromodulatorSystem {
    {
      var dopamine = initNeuromodulatorState(5, 0.5);     // D1-D5
      var serotonin = initNeuromodulatorState(14, 0.5);   // 5-HT1-7 with subtypes
      var norepinephrine = initNeuromodulatorState(4, 0.3); // α1, α2, β1, β2
      var acetylcholine = initNeuromodulatorState(5, 0.5);  // Nicotinic + muscarinic
      var histamine = initNeuromodulatorState(4, 0.3);     // H1-H4
      var orexin = initNeuromodulatorState(2, 0.5);        // OX1, OX2
      var overallArousal = 0.5;
      var overallPlasticity = 0.5;
      var overallMood = 0.5;
      var circadianModulation = 1.0;
    }
  };

  // Update single neuromodulator
  public func updateNeuromodulator(
    nm : NeuromodulatorState,
    driveSignal : Float,
    dt : Float
  ) {
    // Release dynamics
    let release = nm.releaseRate * driveSignal * nm.synthesisCapacity;
    let clearance = nm.clearanceRate * nm.level;
    
    nm.level += (release - clearance) * dt / 1000.0;
    nm.level := clamp(nm.level, 0.0, 2.0);
    
    // Receptor binding (simplified)
    for (i in Iter.range(0, nm.numReceptorTypes - 1)) {
      let affinity = 0.5 + Float.fromInt(i) * 0.1;  // Different affinities
      nm.receptorTypes[i] := nm.level / (nm.level + affinity);
    };
    
    // Effects
    nm.effectOnExcitability := (nm.level - nm.baseline) * 0.2;
    nm.effectOnPlasticity := nm.receptorTypes[0];  // First receptor type
    nm.effectOnGain := 0.8 + 0.4 * nm.level;
    
    // Synthesis capacity (can be depleted)
    nm.synthesisCapacity := 0.99 * nm.synthesisCapacity + 0.01 * 1.0;
    if (nm.level > 1.5) {
      nm.synthesisCapacity *= 0.99;  // Depletion under high release
    };
  };

  // Update full neuromodulator system
  public func updateNeuromodulatorSystem(
    nms : NeuromodulatorSystem,
    rewardSignal : Float,
    stressSignal : Float,
    attentionDemand : Float,
    arousalLevel : Float,
    circadianPhase : Float,
    dt : Float
  ) {
    // Dopamine: driven by reward
    updateNeuromodulator(nms.dopamine, rewardSignal, dt);
    
    // Serotonin: inversely related to stress, promotes patience
    let serotoninDrive = 1.0 - stressSignal * 0.5;
    updateNeuromodulator(nms.serotonin, serotoninDrive, dt);
    
    // Norepinephrine: arousal and stress
    let neDrive = (arousalLevel + stressSignal) / 2.0;
    updateNeuromodulator(nms.norepinephrine, neDrive, dt);
    
    // Acetylcholine: attention and learning
    updateNeuromodulator(nms.acetylcholine, attentionDemand, dt);
    
    // Histamine: wakefulness
    let histamineDrive = arousalLevel * cos(circadianPhase);
    updateNeuromodulator(nms.histamine, histamineDrive, dt);
    
    // Orexin: energy homeostasis
    let orexinDrive = 0.5 + 0.3 * cos(circadianPhase);
    updateNeuromodulator(nms.orexin, orexinDrive, dt);
    
    // Combined effects
    nms.overallArousal := (nms.norepinephrine.level + nms.histamine.level + nms.orexin.level) / 3.0;
    nms.overallPlasticity := (nms.dopamine.effectOnPlasticity + nms.acetylcholine.effectOnPlasticity) / 2.0;
    nms.overallMood := (nms.serotonin.level + nms.dopamine.level - stressSignal) / 2.0;
    
    // Circadian modulation
    nms.circadianModulation := 0.5 + 0.5 * cos(circadianPhase);
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SYNAPTIC PLASTICITY RULES — COMPREHENSIVE LEARNING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Multiple plasticity mechanisms:
  //
  // 1. STDP: Spike-timing-dependent plasticity
  // 2. BCM: Bienenstock-Cooper-Munro rule
  // 3. METAPLASTICITY: Plasticity of plasticity
  // 4. STRUCTURAL: Synapse formation/elimination
  //

  public type STDPRule = {
    var tauPlus : Float;                 // LTP time constant
    var tauMinus : Float;                // LTD time constant
    var aPlus : Float;                   // LTP amplitude
    var aMinus : Float;                  // LTD amplitude
    var weightMin : Float;               // Minimum weight
    var weightMax : Float;               // Maximum weight
    var additiveVsMultiplicative : Float;// 0 = additive, 1 = multiplicative
    var symmetry : Float;                // Symmetric vs asymmetric
    var tripletContribution : Float;     // Higher-order spike effects
    var dopamineGate : Float;            // Neuromodulation
  };

  public type BCMRule = {
    var theta : Float;                   // Sliding threshold
    var thetaTau : Float;                // Threshold time constant
    var learningRate : Float;            // η
    var postsynapticActivity : Float;    // c (average activity)
    var presynapticActivity : Float;     // Input activity
    var slidingThresholdMin : Float;     // Minimum theta
    var slidingThresholdMax : Float;     // Maximum theta
    var metaplasticityRate : Float;      // How fast theta moves
    var integrationWindow : Float;       // Time for averaging
  };

  public type PlasticityState = {
    stdp : STDPRule;
    bcm : BCMRule;
    var weights : [[var Float]];         // Synaptic weight matrix
    var numPre : Nat;
    var numPost : Nat;
    var lastPreSpike : [var Float];      // Time of last presynaptic spike
    var lastPostSpike : [var Float];     // Time of last postsynaptic spike
    var eligibilityTraces : [[var Float]]; // For three-factor learning
    var structuralPlasticity : [[var Float]]; // Synapse existence probability
    var consolidationState : [[var Float]];   // Degree of consolidation
  };

  public func initSTDPRule() : STDPRule {
    {
      var tauPlus = 20.0;   // ms
      var tauMinus = 20.0;  // ms
      var aPlus = 0.01;
      var aMinus = 0.012;   // Slightly stronger LTD
      var weightMin = 0.0;
      var weightMax = 1.0;
      var additiveVsMultiplicative = 0.5;
      var symmetry = 0.0;   // Fully asymmetric
      var tripletContribution = 0.1;
      var dopamineGate = 1.0;
    }
  };

  public func initBCMRule() : BCMRule {
    {
      var theta = 0.5;
      var thetaTau = 1000.0;  // 1 second
      var learningRate = 0.01;
      var postsynapticActivity = 0.0;
      var presynapticActivity = 0.0;
      var slidingThresholdMin = 0.1;
      var slidingThresholdMax = 0.9;
      var metaplasticityRate = 0.01;
      var integrationWindow = 100.0;  // ms
    }
  };

  public func initPlasticityState(numPre : Nat, numPost : Nat) : PlasticityState {
    let weights = Array.init<[var Float]>(numPre, func(_ : Nat) : [var Float] {
      Array.init<Float>(numPost, func(_ : Nat) : Float { 0.5 })
    });
    
    let lastPre = Array.init<Float>(numPre, func(_ : Nat) : Float { -1000.0 });
    let lastPost = Array.init<Float>(numPost, func(_ : Nat) : Float { -1000.0 });
    
    let traces = Array.init<[var Float]>(numPre, func(_ : Nat) : [var Float] {
      Array.init<Float>(numPost, func(_ : Nat) : Float { 0.0 })
    });
    
    let structural = Array.init<[var Float]>(numPre, func(_ : Nat) : [var Float] {
      Array.init<Float>(numPost, func(_ : Nat) : Float { 1.0 })
    });
    
    let consol = Array.init<[var Float]>(numPre, func(_ : Nat) : [var Float] {
      Array.init<Float>(numPost, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      stdp = initSTDPRule();
      bcm = initBCMRule();
      var weights = weights;
      var numPre = numPre;
      var numPost = numPost;
      var lastPreSpike = lastPre;
      var lastPostSpike = lastPost;
      var eligibilityTraces = traces;
      var structuralPlasticity = structural;
      var consolidationState = consol;
    }
  };

  // Apply STDP
  public func applySTDP(
    ps : PlasticityState,
    preIdx : Nat,
    postIdx : Nat,
    preSpikeTime : Float,
    postSpikeTime : Float,
    dopamineLevel : Float
  ) {
    let stdp = ps.stdp;
    let i = preIdx % ps.numPre;
    let j = postIdx % ps.numPost;
    
    let dt = postSpikeTime - preSpikeTime;
    var dw : Float = 0.0;
    
    if (dt > 0.0) {
      // Pre before post → LTP
      dw := stdp.aPlus * exp(-dt / stdp.tauPlus);
    } else if (dt < 0.0) {
      // Post before pre → LTD
      dw := -stdp.aMinus * exp(dt / stdp.tauMinus);
    };
    
    // Dopamine gating (three-factor rule)
    dw *= stdp.dopamineGate * dopamineLevel;
    
    // Multiplicative vs additive
    let currentW = ps.weights[i][j];
    let multFactor = if (dw > 0.0) { stdp.weightMax - currentW } else { currentW - stdp.weightMin };
    dw := (1.0 - stdp.additiveVsMultiplicative) * dw + 
          stdp.additiveVsMultiplicative * dw * multFactor;
    
    // Update weight
    ps.weights[i][j] += dw;
    ps.weights[i][j] := clamp(ps.weights[i][j], stdp.weightMin, stdp.weightMax);
    
    // Update eligibility trace
    ps.eligibilityTraces[i][j] := dw;
    
    // Update spike times
    ps.lastPreSpike[i] := preSpikeTime;
    ps.lastPostSpike[j] := postSpikeTime;
  };

  // Apply BCM rule
  public func applyBCM(
    ps : PlasticityState,
    preActivities : [Float],
    postActivities : [Float],
    dt : Float
  ) {
    let bcm = ps.bcm;
    
    // Update sliding threshold
    var avgPost : Float = 0.0;
    for (j in Iter.range(0, Nat.min(Array.size(postActivities), ps.numPost) - 1)) {
      avgPost += postActivities[j];
    };
    avgPost /= Float.fromInt(ps.numPost);
    
    bcm.theta += (avgPost * avgPost - bcm.theta) / bcm.thetaTau * dt;
    bcm.theta := clamp(bcm.theta, bcm.slidingThresholdMin, bcm.slidingThresholdMax);
    
    // Update weights
    for (i in Iter.range(0, Nat.min(Array.size(preActivities), ps.numPre) - 1)) {
      for (j in Iter.range(0, Nat.min(Array.size(postActivities), ps.numPost) - 1)) {
        let pre = preActivities[i];
        let post = postActivities[j];
        
        // BCM: dw = η × pre × post × (post - θ)
        let phi = post * (post - bcm.theta);
        let dw = bcm.learningRate * pre * phi * dt / 1000.0;
        
        ps.weights[i][j] += dw;
        ps.weights[i][j] := clamp(ps.weights[i][j], ps.stdp.weightMin, ps.stdp.weightMax);
      };
    };
    
    // Store activities
    bcm.presynapticActivity := if (Array.size(preActivities) > 0) { preActivities[0] } else { 0.0 };
    bcm.postsynapticActivity := avgPost;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // POPULATION VECTOR CODING — DISTRIBUTED REPRESENTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Encoding information across populations:
  //
  // 1. TUNING CURVES: Preferred stimulus per neuron
  // 2. POPULATION VECTOR: Weighted sum of preferences
  // 3. SPARSE POPULATION: Selective activation
  // 4. PROBABILISTIC CODE: Uncertainty representation
  //

  public type TuningCurve = {
    var preferredValue : Float;          // μ - center of tuning
    var tuningWidth : Float;             // σ - bandwidth
    var maxResponse : Float;             // Peak response
    var baselineResponse : Float;        // Spontaneous rate
    var modulation : Float;              // Response modulation depth
    var adaptationLevel : Float;         // Current adaptation
    var tuningShape : Text;              // "gaussian", "cosine", "von_mises"
  };

  public type PopulationCode = {
    var neurons : [var TuningCurve];     // All neurons
    var numNeurons : Nat;
    var codingRange : (Float, Float);    // Range of encoded values
    var populationVector : Float;        // Decoded value
    var vectorLength : Float;            // Certainty/confidence
    var sparsity : Float;                // Active fraction
    var entropy : Float;                 // Code entropy
    var fisherInformation : Float;       // Precision
    var mutualInformation : Float;       // Stimulus-response MI
    var noiseCorrelation : Float;        // Inter-neuron noise correlation
  };

  public type VectorDecoding = {
    population : PopulationCode;
    var decodedValue : Float;            // Estimated stimulus
    var decodingError : Float;           // Estimation error
    var posteriorMean : Float;           // Bayesian estimate
    var posteriorVariance : Float;       // Uncertainty
    var maxLikelihoodEstimate : Float;   // MLE
    var mapEstimate : Float;             // Maximum a posteriori
    var priorDistribution : [var Float]; // Prior over values
    var likelihoodFunction : [var Float];// Likelihood per value
  };

  public func initTuningCurve(preferred : Float, width : Float) : TuningCurve {
    {
      var preferredValue = preferred;
      var tuningWidth = width;
      var maxResponse = 1.0;
      var baselineResponse = 0.1;
      var modulation = 0.9;
      var adaptationLevel = 0.0;
      var tuningShape = "gaussian";
    }
  };

  public func initPopulationCode(numNeurons : Nat, minValue : Float, maxValue : Float) : PopulationCode {
    let neurons = Array.init<TuningCurve>(numNeurons, func(i : Nat) : TuningCurve {
      let preferred = minValue + (maxValue - minValue) * Float.fromInt(i) / Float.fromInt(numNeurons);
      let width = (maxValue - minValue) / Float.fromInt(numNeurons) * 2.0;
      initTuningCurve(preferred, width)
    });
    
    {
      var neurons = neurons;
      var numNeurons = numNeurons;
      var codingRange = (minValue, maxValue);
      var populationVector = 0.0;
      var vectorLength = 0.0;
      var sparsity = 0.0;
      var entropy = 0.0;
      var fisherInformation = 0.0;
      var mutualInformation = 0.0;
      var noiseCorrelation = 0.0;
    }
  };

  public func initVectorDecoding(numNeurons : Nat, numBins : Nat) : VectorDecoding {
    let prior = Array.init<Float>(numBins, func(_ : Nat) : Float { 1.0 / Float.fromInt(numBins) });
    let likelihood = Array.init<Float>(numBins, func(_ : Nat) : Float { 1.0 / Float.fromInt(numBins) });
    
    {
      population = initPopulationCode(numNeurons, 0.0, 1.0);
      var decodedValue = 0.5;
      var decodingError = 0.0;
      var posteriorMean = 0.5;
      var posteriorVariance = 0.1;
      var maxLikelihoodEstimate = 0.5;
      var mapEstimate = 0.5;
      var priorDistribution = prior;
      var likelihoodFunction = likelihood;
    }
  };

  // Compute neural response
  public func computeNeuralResponse(tc : TuningCurve, stimulus : Float) : Float {
    let diff = stimulus - tc.preferredValue;
    
    let response = switch (tc.tuningShape) {
      case "gaussian" {
        tc.maxResponse * exp(-diff * diff / (2.0 * tc.tuningWidth * tc.tuningWidth))
      };
      case "cosine" {
        tc.maxResponse * (1.0 + cos(PI * diff / tc.tuningWidth)) / 2.0
      };
      case _ {
        // Default Gaussian
        tc.maxResponse * exp(-diff * diff / (2.0 * tc.tuningWidth * tc.tuningWidth))
      };
    };
    
    // Add baseline and apply adaptation
    let r = tc.baselineResponse + tc.modulation * response * (1.0 - tc.adaptationLevel);
    clamp(r, 0.0, tc.maxResponse)
  };

  // Compute population vector
  public func computePopulationVector(
    pc : PopulationCode,
    stimulus : Float
  ) : [Float] {
    let n = pc.numNeurons;
    
    // Compute all responses
    let responses = Array.tabulate<Float>(n, func(i : Nat) : Float {
      computeNeuralResponse(pc.neurons[i], stimulus)
    });
    
    // Population vector
    var sumWeighted : Float = 0.0;
    var sumResponses : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      sumWeighted += responses[i] * pc.neurons[i].preferredValue;
      sumResponses += responses[i];
    };
    
    if (sumResponses > 0.0) {
      pc.populationVector := sumWeighted / sumResponses;
    };
    
    // Vector length (certainty)
    var sumX : Float = 0.0;
    var sumY : Float = 0.0;
    let (minVal, maxVal) = pc.codingRange;
    let range = maxVal - minVal;
    
    for (i in Iter.range(0, n - 1)) {
      let phase = TWO_PI * (pc.neurons[i].preferredValue - minVal) / range;
      sumX += responses[i] * cos(phase);
      sumY += responses[i] * sin(phase);
    };
    
    pc.vectorLength := sqrt(sumX * sumX + sumY * sumY) / sumResponses;
    
    // Sparsity
    var activeCount : Nat = 0;
    for (i in Iter.range(0, n - 1)) {
      if (responses[i] > pc.neurons[i].baselineResponse * 2.0) {
        activeCount += 1;
      };
    };
    pc.sparsity := Float.fromInt(activeCount) / Float.fromInt(n);
    
    // Entropy
    pc.entropy := 0.0;
    for (i in Iter.range(0, n - 1)) {
      let p = responses[i] / sumResponses;
      if (p > 0.0001) {
        pc.entropy -= p * ln(p);
      };
    };
    
    responses
  };

  // Decode stimulus from population activity
  public func decodePopulation(
    dec : VectorDecoding,
    responses : [Float],
    stimulus : Float  // True stimulus for error computation
  ) {
    let pc = dec.population;
    let n = pc.numNeurons;
    let numBins = Array.size(dec.priorDistribution);
    let (minVal, maxVal) = pc.codingRange;
    
    // Population vector decoding
    var sumWeighted : Float = 0.0;
    var sumResponses : Float = 0.0;
    
    for (i in Iter.range(0, Nat.min(Array.size(responses), n) - 1)) {
      sumWeighted += responses[i] * pc.neurons[i].preferredValue;
      sumResponses += responses[i];
    };
    
    if (sumResponses > 0.0) {
      dec.decodedValue := sumWeighted / sumResponses;
    };
    
    dec.decodingError := Float.abs(dec.decodedValue - stimulus);
    
    // Maximum likelihood estimation
    var maxLikelihood : Float = 0.0;
    var mlValue : Float = minVal;
    
    for (b in Iter.range(0, numBins - 1)) {
      let testValue = minVal + (maxVal - minVal) * Float.fromInt(b) / Float.fromInt(numBins);
      
      // Compute likelihood as product of Gaussian likelihoods
      var logLikelihood : Float = 0.0;
      for (i in Iter.range(0, Nat.min(Array.size(responses), n) - 1)) {
        let expectedResponse = computeNeuralResponse(pc.neurons[i], testValue);
        let diff = responses[i] - expectedResponse;
        logLikelihood -= diff * diff / 0.2;  // Assume noise variance = 0.1
      };
      
      let likelihood = exp(logLikelihood);
      dec.likelihoodFunction[b] := likelihood;
      
      if (likelihood > maxLikelihood) {
        maxLikelihood := likelihood;
        mlValue := testValue;
      };
    };
    
    dec.maxLikelihoodEstimate := mlValue;
    
    // Posterior = likelihood × prior
    var sumPosterior : Float = 0.0;
    for (b in Iter.range(0, numBins - 1)) {
      dec.likelihoodFunction[b] *= dec.priorDistribution[b];
      sumPosterior += dec.likelihoodFunction[b];
    };
    
    // Normalize and compute posterior mean
    dec.posteriorMean := 0.0;
    dec.posteriorVariance := 0.0;
    
    var maxPosterior : Float = 0.0;
    var mapValue : Float = minVal;
    
    if (sumPosterior > 0.0) {
      for (b in Iter.range(0, numBins - 1)) {
        dec.likelihoodFunction[b] /= sumPosterior;
        let value = minVal + (maxVal - minVal) * Float.fromInt(b) / Float.fromInt(numBins);
        dec.posteriorMean += dec.likelihoodFunction[b] * value;
        
        if (dec.likelihoodFunction[b] > maxPosterior) {
          maxPosterior := dec.likelihoodFunction[b];
          mapValue := value;
        };
      };
      
      for (b in Iter.range(0, numBins - 1)) {
        let value = minVal + (maxVal - minVal) * Float.fromInt(b) / Float.fromInt(numBins);
        let diff = value - dec.posteriorMean;
        dec.posteriorVariance += dec.likelihoodFunction[b] * diff * diff;
      };
    };
    
    dec.mapEstimate := mapValue;
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // BAYESIAN INFERENCE — PROBABILISTIC COMPUTATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural implementation of Bayesian inference:
  //
  // 1. PRIOR: Background beliefs P(θ)
  // 2. LIKELIHOOD: Data model P(D|θ)
  // 3. POSTERIOR: Updated beliefs P(θ|D) ∝ P(D|θ)P(θ)
  // 4. SAMPLING: Approximate inference
  //

  public type BayesianState = {
    var prior : [var Float];             // Prior distribution
    var likelihood : [var Float];        // Likelihood function
    var posterior : [var Float];         // Posterior distribution
    var numHypotheses : Nat;             // Number of hypotheses
    var evidence : Float;                // P(D) = ∫P(D|θ)P(θ)dθ
    var posteriorMean : Float;           // E[θ|D]
    var posteriorVariance : Float;       // Var[θ|D]
    var posteriorMode : Nat;             // argmax P(θ|D)
    var entropy : Float;                 // H[P(θ|D)]
    var informationGain : Float;         // KL(posterior||prior)
  };

  public type SamplingState = {
    bayesian : BayesianState;
    var samples : [var Float];           // Drawn samples
    var numSamples : Nat;
    var maxSamples : Nat;
    var sampleMean : Float;              // Sample average
    var sampleVariance : Float;          // Sample variance
    var acceptanceRate : Float;          // For MCMC
    var proposalWidth : Float;           // Proposal distribution width
    var burnIn : Nat;                    // Burn-in period
    var thinning : Nat;                  // Sample thinning
    var chainLength : Nat;               // MCMC chain length
  };

  public type VariationalState = {
    sampling : SamplingState;
    var variationalParameters : [var Float]; // q(θ) parameters
    var elbo : Float;                    // Evidence lower bound
    var kl : Float;                      // KL(q||p)
    var reconstructionLoss : Float;      // -E_q[log p(D|θ)]
    var gradients : [var Float];         // ∇ELBO
    var learningRate : Float;            // Optimization rate
    var momentum : [var Float];          // Gradient momentum
    var naturalGradient : Bool;          // Use natural gradient?
    var convergenceThreshold : Float;    // When to stop
  };

  public func initBayesianState(numHypotheses : Nat) : BayesianState {
    let uniform = 1.0 / Float.fromInt(numHypotheses);
    
    {
      var prior = Array.init<Float>(numHypotheses, func(_ : Nat) : Float { uniform });
      var likelihood = Array.init<Float>(numHypotheses, func(_ : Nat) : Float { uniform });
      var posterior = Array.init<Float>(numHypotheses, func(_ : Nat) : Float { uniform });
      var numHypotheses = numHypotheses;
      var evidence = 1.0;
      var posteriorMean = 0.5;
      var posteriorVariance = 0.1;
      var posteriorMode = 0;
      var entropy = ln(Float.fromInt(numHypotheses));
      var informationGain = 0.0;
    }
  };

  public func initSamplingState(numHypotheses : Nat, maxSamples : Nat) : SamplingState {
    let samples = Array.init<Float>(maxSamples, func(_ : Nat) : Float { 0.0 });
    
    {
      bayesian = initBayesianState(numHypotheses);
      var samples = samples;
      var numSamples = 0;
      var maxSamples = maxSamples;
      var sampleMean = 0.0;
      var sampleVariance = 0.0;
      var acceptanceRate = 0.0;
      var proposalWidth = 0.1;
      var burnIn = 100;
      var thinning = 10;
      var chainLength = 0;
    }
  };

  public func initVariationalState(numHypotheses : Nat, maxSamples : Nat, numParams : Nat) : VariationalState {
    let params = Array.init<Float>(numParams, func(_ : Nat) : Float { 0.0 });
    let grads = Array.init<Float>(numParams, func(_ : Nat) : Float { 0.0 });
    let mom = Array.init<Float>(numParams, func(_ : Nat) : Float { 0.0 });
    
    {
      sampling = initSamplingState(numHypotheses, maxSamples);
      var variationalParameters = params;
      var elbo = 0.0;
      var kl = 0.0;
      var reconstructionLoss = 0.0;
      var gradients = grads;
      var learningRate = 0.01;
      var momentum = mom;
      var naturalGradient = false;
      var convergenceThreshold = 0.001;
    }
  };

  // Bayes update
  public func bayesUpdate(
    bayes : BayesianState,
    likelihoods : [Float]
  ) {
    let n = bayes.numHypotheses;
    
    // Update likelihood
    for (i in Iter.range(0, Nat.min(Array.size(likelihoods), n) - 1)) {
      bayes.likelihood[i] := likelihoods[i];
    };
    
    // Compute evidence: P(D) = Σ P(D|θ_i)P(θ_i)
    bayes.evidence := 0.0;
    for (i in Iter.range(0, n - 1)) {
      bayes.evidence += bayes.likelihood[i] * bayes.prior[i];
    };
    
    // Compute posterior: P(θ|D) = P(D|θ)P(θ)/P(D)
    var maxPosterior : Float = 0.0;
    var priorEntropy : Float = 0.0;
    var posteriorEntropy : Float = 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      if (bayes.evidence > 0.0) {
        bayes.posterior[i] := bayes.likelihood[i] * bayes.prior[i] / bayes.evidence;
      } else {
        bayes.posterior[i] := bayes.prior[i];
      };
      
      if (bayes.posterior[i] > maxPosterior) {
        maxPosterior := bayes.posterior[i];
        bayes.posteriorMode := i;
      };
      
      // Entropy calculations
      if (bayes.prior[i] > 0.0001) {
        priorEntropy -= bayes.prior[i] * ln(bayes.prior[i]);
      };
      if (bayes.posterior[i] > 0.0001) {
        posteriorEntropy -= bayes.posterior[i] * ln(bayes.posterior[i]);
      };
    };
    
    bayes.entropy := posteriorEntropy;
    
    // Information gain (KL divergence)
    bayes.informationGain := 0.0;
    for (i in Iter.range(0, n - 1)) {
      if (bayes.posterior[i] > 0.0001 and bayes.prior[i] > 0.0001) {
        bayes.informationGain += bayes.posterior[i] * (ln(bayes.posterior[i]) - ln(bayes.prior[i]));
      };
    };
    
    // Posterior mean and variance
    bayes.posteriorMean := 0.0;
    bayes.posteriorVariance := 0.0;
    
    for (i in Iter.range(0, n - 1)) {
      let value = Float.fromInt(i) / Float.fromInt(n);
      bayes.posteriorMean += bayes.posterior[i] * value;
    };
    
    for (i in Iter.range(0, n - 1)) {
      let value = Float.fromInt(i) / Float.fromInt(n);
      let diff = value - bayes.posteriorMean;
      bayes.posteriorVariance += bayes.posterior[i] * diff * diff;
    };
    
    // Update prior for next step
    for (i in Iter.range(0, n - 1)) {
      bayes.prior[i] := bayes.posterior[i];
    };
  };

  // MCMC sampling
  public func mcmcSample(
    samp : SamplingState,
    targetDistribution : [Float],
    seed : Nat
  ) {
    var pseudoRandom = seed;
    let n = samp.bayesian.numHypotheses;
    
    // Initialize at random position
    pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
    var currentIdx = pseudoRandom % n;
    var currentProb = targetDistribution[currentIdx];
    
    var accepts : Nat = 0;
    var total : Nat = 0;
    
    // Run MCMC chain
    for (step in Iter.range(0, samp.maxSamples - 1)) {
      // Propose new state
      pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
      let jump = Int.abs(Float.toInt(Float.fromInt(pseudoRandom) / 2147483648.0 * samp.proposalWidth * Float.fromInt(n)));
      
      pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
      let sign = if (pseudoRandom % 2 == 0) { 1 } else { -1 };
      
      let proposedIdx = (currentIdx + n + sign * jump) % n;
      let proposedProb = targetDistribution[proposedIdx];
      
      // Accept/reject
      let acceptRatio = if (currentProb > 0.0) { proposedProb / currentProb } else { 1.0 };
      pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
      let u = Float.fromInt(pseudoRandom) / 2147483648.0;
      
      total += 1;
      
      if (u < acceptRatio) {
        currentIdx := proposedIdx;
        currentProb := proposedProb;
        accepts += 1;
      };
      
      // Store sample (after burn-in, with thinning)
      if (step >= samp.burnIn and step % samp.thinning == 0) {
        if (samp.numSamples < samp.maxSamples) {
          samp.samples[samp.numSamples] := Float.fromInt(currentIdx) / Float.fromInt(n);
          samp.numSamples += 1;
        };
      };
    };
    
    samp.chainLength := total;
    samp.acceptanceRate := if (total > 0) { Float.fromInt(accepts) / Float.fromInt(total) } else { 0.0 };
    
    // Compute sample statistics
    var sum : Float = 0.0;
    for (i in Iter.range(0, samp.numSamples - 1)) {
      sum += samp.samples[i];
    };
    samp.sampleMean := if (samp.numSamples > 0) { sum / Float.fromInt(samp.numSamples) } else { 0.0 };
    
    var sumSq : Float = 0.0;
    for (i in Iter.range(0, samp.numSamples - 1)) {
      let diff = samp.samples[i] - samp.sampleMean;
      sumSq += diff * diff;
    };
    samp.sampleVariance := if (samp.numSamples > 1) { sumSq / Float.fromInt(samp.numSamples - 1) } else { 0.0 };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // DECISION MAKING — ACCUMULATION TO BOUND
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural decision mechanisms:
  //
  // 1. DRIFT-DIFFUSION: Accumulate evidence to threshold
  // 2. RACE MODEL: Parallel accumulators compete
  // 3. URGENCY GATING: Time-varying threshold
  // 4. CONFIDENCE: Certainty in decision
  //

  public type DriftDiffusion = {
    var accumulator : Float;             // Decision variable
    var threshold : Float;               // Decision boundary
    var drift : Float;                   // Mean drift rate
    var diffusion : Float;               // Noise level
    var startingPoint : Float;           // Initial bias
    var nonDecisionTime : Float;         // Encoding/motor time
    var decisionMade : Bool;             // Decision reached?
    var responseTime : Float;            // Time to decision
    var chosenOption : Nat;              // Which option (0 or 1)
    var confidenceLevel : Float;         // Post-decision confidence
  };

  public type RaceModel = {
    var accumulators : [var Float];      // One per option
    var numOptions : Nat;
    var threshold : Float;               // Common threshold
    var driftRates : [var Float];        // Drift per option
    var noiseLevel : Float;              // Diffusion
    var winner : Nat;                    // Winning option
    var winnerRT : Float;                // Winner response time
    var runnerUp : Nat;                  // Second place
    var margin : Float;                  // Winning margin
    var ongoingRace : Bool;              // Race still running?
  };

  public type UrgencyGating = {
    race : RaceModel;
    var urgencySignal : Float;           // Current urgency level
    var urgencySlope : Float;            // Rate of urgency increase
    var urgencyOnset : Float;            // When urgency kicks in
    var effectiveThreshold : Float;      // Threshold after urgency
    var collapsedThreshold : Float;      // Minimum threshold
    var deadlineTime : Float;            // Hard deadline
    var timeElapsed : Float;             // Time in decision
    var urgencyStrategy : Text;          // "linear", "exponential", "hyperbolic"
  };

  public func initDriftDiffusion() : DriftDiffusion {
    {
      var accumulator = 0.0;
      var threshold = 1.0;
      var drift = 0.0;
      var diffusion = 0.1;
      var startingPoint = 0.0;
      var nonDecisionTime = 200.0;  // ms
      var decisionMade = false;
      var responseTime = 0.0;
      var chosenOption = 0;
      var confidenceLevel = 0.5;
    }
  };

  public func initRaceModel(numOptions : Nat) : RaceModel {
    let acc = Array.init<Float>(numOptions, func(_ : Nat) : Float { 0.0 });
    let drifts = Array.init<Float>(numOptions, func(_ : Nat) : Float { 0.0 });
    
    {
      var accumulators = acc;
      var numOptions = numOptions;
      var threshold = 1.0;
      var driftRates = drifts;
      var noiseLevel = 0.1;
      var winner = 0;
      var winnerRT = 0.0;
      var runnerUp = 0;
      var margin = 0.0;
      var ongoingRace = true;
    }
  };

  public func initUrgencyGating(numOptions : Nat) : UrgencyGating {
    {
      race = initRaceModel(numOptions);
      var urgencySignal = 0.0;
      var urgencySlope = 0.001;
      var urgencyOnset = 500.0;  // ms
      var effectiveThreshold = 1.0;
      var collapsedThreshold = 0.3;
      var deadlineTime = 2000.0;  // ms
      var timeElapsed = 0.0;
      var urgencyStrategy = "linear";
    }
  };

  // Update drift-diffusion
  public func updateDriftDiffusion(
    dd : DriftDiffusion,
    evidence : Float,
    dt : Float,
    seed : Nat
  ) : Bool {
    if (dd.decisionMade) { return true };
    
    // Update drift based on evidence
    dd.drift := evidence;
    
    // Noise term
    var pseudoRandom = seed;
    pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
    let noise = (Float.fromInt(pseudoRandom) / 2147483648.0 - 0.5) * 2.0 * dd.diffusion;
    
    // Accumulate evidence
    dd.accumulator += (dd.drift + noise) * dt / 1000.0;
    dd.responseTime += dt;
    
    // Check threshold crossing
    if (dd.accumulator >= dd.threshold) {
      dd.decisionMade := true;
      dd.chosenOption := 1;
      dd.responseTime += dd.nonDecisionTime;
      dd.confidenceLevel := (dd.accumulator - dd.threshold) / dd.threshold + 0.5;
    } else if (dd.accumulator <= -dd.threshold) {
      dd.decisionMade := true;
      dd.chosenOption := 0;
      dd.responseTime += dd.nonDecisionTime;
      dd.confidenceLevel := (-dd.accumulator - dd.threshold) / dd.threshold + 0.5;
    };
    
    dd.confidenceLevel := clamp(dd.confidenceLevel, 0.0, 1.0);
    
    dd.decisionMade
  };

  // Update race model
  public func updateRaceModel(
    race : RaceModel,
    evidences : [Float],
    dt : Float,
    seed : Nat
  ) : Bool {
    if (not race.ongoingRace) { return true };
    
    var pseudoRandom = seed;
    
    // Update drift rates
    for (i in Iter.range(0, Nat.min(Array.size(evidences), race.numOptions) - 1)) {
      race.driftRates[i] := evidences[i];
    };
    
    // Accumulate each option
    for (i in Iter.range(0, race.numOptions - 1)) {
      // Noise
      pseudoRandom := (pseudoRandom * 1103515245 + 12345) % 2147483648;
      let noise = (Float.fromInt(pseudoRandom) / 2147483648.0 - 0.5) * 2.0 * race.noiseLevel;
      
      race.accumulators[i] += (race.driftRates[i] + noise) * dt / 1000.0;
      race.accumulators[i] := if (race.accumulators[i] < 0.0) { 0.0 } else { race.accumulators[i] };
      
      // Check threshold
      if (race.accumulators[i] >= race.threshold) {
        race.ongoingRace := false;
        race.winner := i;
        race.winnerRT := dt;  // Would need to accumulate
      };
    };
    
    // Find runner-up
    if (not race.ongoingRace) {
      var maxOther : Float = 0.0;
      for (i in Iter.range(0, race.numOptions - 1)) {
        if (i != race.winner and race.accumulators[i] > maxOther) {
          maxOther := race.accumulators[i];
          race.runnerUp := i;
        };
      };
      race.margin := race.accumulators[race.winner] - maxOther;
    };
    
    not race.ongoingRace
  };

  // Update urgency gating
  public func updateUrgencyGating(
    ug : UrgencyGating,
    evidences : [Float],
    dt : Float,
    seed : Nat
  ) : Bool {
    ug.timeElapsed += dt;
    
    // Update urgency signal
    if (ug.timeElapsed > ug.urgencyOnset) {
      let timeSinceOnset = ug.timeElapsed - ug.urgencyOnset;
      
      switch (ug.urgencyStrategy) {
        case "linear" {
          ug.urgencySignal := ug.urgencySlope * timeSinceOnset / 1000.0;
        };
        case "exponential" {
          ug.urgencySignal := 1.0 - exp(-ug.urgencySlope * timeSinceOnset / 1000.0);
        };
        case _ {
          ug.urgencySignal := ug.urgencySlope * timeSinceOnset / 1000.0;
        };
      };
    };
    
    ug.urgencySignal := clamp(ug.urgencySignal, 0.0, 1.0);
    
    // Effective threshold decreases with urgency
    let thresholdRange = ug.race.threshold - ug.collapsedThreshold;
    ug.effectiveThreshold := ug.race.threshold - ug.urgencySignal * thresholdRange;
    
    // Update race with adjusted threshold
    let originalThreshold = ug.race.threshold;
    ug.race.threshold := ug.effectiveThreshold;
    let decided = updateRaceModel(ug.race, evidences, dt, seed);
    ug.race.threshold := originalThreshold;
    
    // Force decision at deadline
    if (ug.timeElapsed >= ug.deadlineTime and ug.race.ongoingRace) {
      // Pick highest accumulator
      var maxAcc : Float = 0.0;
      for (i in Iter.range(0, ug.race.numOptions - 1)) {
        if (ug.race.accumulators[i] > maxAcc) {
          maxAcc := ug.race.accumulators[i];
          ug.race.winner := i;
        };
      };
      ug.race.ongoingRace := false;
    };
    
    not ug.race.ongoingRace
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // MULTI-SCALE DYNAMICS — HIERARCHICAL ORGANIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural processing across time and space scales:
  //
  // 1. MICROSCALE: Synapses, spikes (ms)
  // 2. MESOSCALE: Local circuits (10-100ms)
  // 3. MACROSCALE: Brain regions (100ms-1s)
  // 4. MEGASCALE: Behavior (seconds-minutes)
  //

  public type MicroScale = {
    var synapticCurrent : [var Float];   // PSCs
    var numSynapses : Nat;
    var spikeTimings : [var Float];      // Recent spike times
    var membranePotential : Float;       // Vm
    var refractoryPeriod : Float;        // Time since spike
    var ionChannelState : [var Float];   // Channel kinetics
    var calciumLevel : Float;            // [Ca2+]
    var vesiclePool : Float;             // Available vesicles
    var releaseProb : Float;             // p_release
    var shortTermPlasticity : Float;     // Facilitation/depression
  };

  public type MesoScale = {
    micro : MicroScale;
    var populationActivity : Float;      // Mean firing rate
    var localFieldPotential : Float;     // LFP
    var oscillationPower : [var Float];  // Power per band
    var numBands : Nat;
    var phaseCoherence : Float;          // Population phase
    var columnActivity : [var Float];    // Cortical columns
    var numColumns : Nat;
    var lateralInteraction : [[var Float]]; // Column coupling
    var inputGain : Float;               // Feedforward gain
    var recurrentGain : Float;           // Recurrent gain
  };

  public type MacroScale = {
    meso : MesoScale;
    var regionalActivity : [var Float];  // Activity per region
    var numRegions : Nat;
    var connectivity : [[var Float]];    // Structural connectivity
    var functionalConnectivity : [[var Float]]; // FC
    var effectiveConnectivity : [[var Float]];  // EC
    var transmissionDelay : [[var Float]]; // Conduction delay
    var globalSignal : Float;            // Mean activity
    var networkState : Text;             // "rest", "task", "sleep"
  };

  public type MegaScale = {
    macro : MacroScale;
    var behaviorState : Text;            // Current behavior
    var goalState : [var Float];         // Active goals
    var numGoals : Nat;
    var actionSequence : [var Float];    // Planned actions
    var seqLength : Nat;
    var currentAction : Nat;             // Current step
    var taskPerformance : Float;         // Success rate
    var fatigueLevel : Float;            // Mental fatigue
    var timeOnTask : Float;              // Time spent
    var learningProgress : Float;        // Skill acquisition
  };

  public func initMicroScale(numSynapses : Nat, numChannels : Nat) : MicroScale {
    {
      var synapticCurrent = Array.init<Float>(numSynapses, func(_ : Nat) : Float { 0.0 });
      var numSynapses = numSynapses;
      var spikeTimings = Array.init<Float>(10, func(_ : Nat) : Float { -1000.0 });
      var membranePotential = -70.0;
      var refractoryPeriod = 0.0;
      var ionChannelState = Array.init<Float>(numChannels, func(_ : Nat) : Float { 0.0 });
      var calciumLevel = 0.0001;
      var vesiclePool = 1.0;
      var releaseProb = 0.3;
      var shortTermPlasticity = 1.0;
    }
  };

  public func initMesoScale(numSynapses : Nat, numColumns : Nat, numBands : Nat) : MesoScale {
    let osc = Array.init<Float>(numBands, func(_ : Nat) : Float { 0.0 });
    let cols = Array.init<Float>(numColumns, func(_ : Nat) : Float { 0.0 });
    
    let lateral = Array.init<[var Float]>(numColumns, func(_ : Nat) : [var Float] {
      Array.init<Float>(numColumns, func(_ : Nat) : Float { 0.1 })
    });
    
    {
      micro = initMicroScale(numSynapses, 5);
      var populationActivity = 0.0;
      var localFieldPotential = 0.0;
      var oscillationPower = osc;
      var numBands = numBands;
      var phaseCoherence = 0.0;
      var columnActivity = cols;
      var numColumns = numColumns;
      var lateralInteraction = lateral;
      var inputGain = 1.0;
      var recurrentGain = 0.5;
    }
  };

  public func initMacroScale(numSynapses : Nat, numColumns : Nat, numBands : Nat, numRegions : Nat) : MacroScale {
    let regional = Array.init<Float>(numRegions, func(_ : Nat) : Float { 0.0 });
    
    let conn = Array.init<[var Float]>(numRegions, func(_ : Nat) : [var Float] {
      Array.init<Float>(numRegions, func(_ : Nat) : Float { 0.1 })
    });
    
    let fc = Array.init<[var Float]>(numRegions, func(_ : Nat) : [var Float] {
      Array.init<Float>(numRegions, func(_ : Nat) : Float { 0.0 })
    });
    
    let ec = Array.init<[var Float]>(numRegions, func(_ : Nat) : [var Float] {
      Array.init<Float>(numRegions, func(_ : Nat) : Float { 0.0 })
    });
    
    let delays = Array.init<[var Float]>(numRegions, func(_ : Nat) : [var Float] {
      Array.init<Float>(numRegions, func(_ : Nat) : Float { 10.0 })
    });
    
    {
      meso = initMesoScale(numSynapses, numColumns, numBands);
      var regionalActivity = regional;
      var numRegions = numRegions;
      var connectivity = conn;
      var functionalConnectivity = fc;
      var effectiveConnectivity = ec;
      var transmissionDelay = delays;
      var globalSignal = 0.0;
      var networkState = "rest";
    }
  };

  public func initMegaScale(numSynapses : Nat, numColumns : Nat, numBands : Nat, numRegions : Nat, numGoals : Nat, seqLength : Nat) : MegaScale {
    let goals = Array.init<Float>(numGoals, func(_ : Nat) : Float { 0.0 });
    let actions = Array.init<Float>(seqLength, func(_ : Nat) : Float { 0.0 });
    
    {
      macro = initMacroScale(numSynapses, numColumns, numBands, numRegions);
      var behaviorState = "idle";
      var goalState = goals;
      var numGoals = numGoals;
      var actionSequence = actions;
      var seqLength = seqLength;
      var currentAction = 0;
      var taskPerformance = 0.5;
      var fatigueLevel = 0.0;
      var timeOnTask = 0.0;
      var learningProgress = 0.0;
    }
  };

  // Update multi-scale dynamics
  public func updateMultiScale(
    mega : MegaScale,
    inputs : [Float],
    dt : Float
  ) {
    let macro = mega.macro;
    let meso = macro.meso;
    let micro = meso.micro;
    
    // Microscale: synaptic currents
    for (i in Iter.range(0, Nat.min(Array.size(inputs), micro.numSynapses) - 1)) {
      // EPSC dynamics
      let inputCurrent = inputs[i] * micro.releaseProb * micro.vesiclePool * micro.shortTermPlasticity;
      micro.synapticCurrent[i] := 0.8 * micro.synapticCurrent[i] + 0.2 * inputCurrent;
      
      // Short-term plasticity
      micro.vesiclePool := 0.95 * micro.vesiclePool + 0.05 * 1.0;  // Recovery
      if (inputs[i] > 0.5) {
        micro.vesiclePool *= 0.9;  // Depletion
      };
    };
    
    // Sum currents to membrane potential
    var totalCurrent : Float = 0.0;
    for (i in Iter.range(0, micro.numSynapses - 1)) {
      totalCurrent += micro.synapticCurrent[i];
    };
    
    micro.membranePotential := -70.0 + totalCurrent * 10.0;
    
    // Mesoscale: population activity
    meso.populationActivity := 0.0;
    for (i in Iter.range(0, micro.numSynapses - 1)) {
      meso.populationActivity += micro.synapticCurrent[i];
    };
    meso.populationActivity /= Float.fromInt(micro.numSynapses);
    
    // LFP (sum of synaptic currents)
    meso.localFieldPotential := totalCurrent / Float.fromInt(micro.numSynapses);
    
    // Column activity
    for (c in Iter.range(0, meso.numColumns - 1)) {
      // Input from micro level
      let microInput = meso.populationActivity * meso.inputGain;
      
      // Recurrent from other columns
      var recurrent : Float = 0.0;
      for (c2 in Iter.range(0, meso.numColumns - 1)) {
        if (c != c2) {
          recurrent += meso.lateralInteraction[c][c2] * meso.columnActivity[c2];
        };
      };
      
      meso.columnActivity[c] := 0.9 * meso.columnActivity[c] + 0.1 * (microInput + meso.recurrentGain * recurrent);
    };
    
    // Macroscale: regional activity
    macro.globalSignal := 0.0;
    for (r in Iter.range(0, macro.numRegions - 1)) {
      // Average column activity for this region
      let startCol = (r * meso.numColumns) / macro.numRegions;
      let endCol = ((r + 1) * meso.numColumns) / macro.numRegions;
      
      var regionSum : Float = 0.0;
      for (c in Iter.range(startCol, endCol - 1)) {
        if (c < meso.numColumns) {
          regionSum += meso.columnActivity[c];
        };
      };
      
      macro.regionalActivity[r] := regionSum / Float.fromInt(endCol - startCol + 1);
      macro.globalSignal += macro.regionalActivity[r];
    };
    macro.globalSignal /= Float.fromInt(macro.numRegions);
    
    // Functional connectivity (simplified)
    for (r1 in Iter.range(0, macro.numRegions - 1)) {
      for (r2 in Iter.range(r1 + 1, macro.numRegions - 1)) {
        let corr = macro.regionalActivity[r1] * macro.regionalActivity[r2];
        macro.functionalConnectivity[r1][r2] := 0.9 * macro.functionalConnectivity[r1][r2] + 0.1 * corr;
        macro.functionalConnectivity[r2][r1] := macro.functionalConnectivity[r1][r2];
      };
    };
    
    // Megascale: behavior
    mega.timeOnTask += dt / 1000.0;
    mega.fatigueLevel := 1.0 - exp(-mega.timeOnTask / 3600.0);  // Fatigue over time
    
    // Action execution
    if (mega.currentAction < mega.seqLength) {
      mega.actionSequence[mega.currentAction] := macro.globalSignal;
      
      // Progress to next action if threshold met
      if (macro.globalSignal > 0.5) {
        mega.currentAction := (mega.currentAction + 1) % mega.seqLength;
      };
    };
    
    // Learning progress
    mega.learningProgress := 0.99 * mega.learningProgress + 0.01 * mega.taskPerformance;
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // NETWORK TOPOLOGY — GRAPH THEORETICAL ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Analysis of neural network structure:
  //
  // 1. DEGREE DISTRIBUTION: Node connectivity patterns
  // 2. CLUSTERING: Local structure
  // 3. PATH LENGTH: Global efficiency
  // 4. MODULARITY: Community structure
  // 5. HUBS AND RICH CLUBS: Central nodes
  //

  public type NetworkTopology = {
    var adjacency : [[var Bool]];        // Adjacency matrix
    var weights : [[var Float]];         // Weight matrix
    var numNodes : Nat;
    var numEdges : Nat;
    var density : Float;                 // Edge density
    var degree : [var Nat];              // Degree per node
    var strength : [var Float];          // Weighted degree
    var clustering : [var Float];        // Local clustering
    var meanClustering : Float;          // Average clustering
    var meanPathLength : Float;          // Average shortest path
  };

  public type GraphMetrics = {
    topology : NetworkTopology;
    var betweenness : [var Float];       // Betweenness centrality
    var closeness : [var Float];         // Closeness centrality
    var eigenvector : [var Float];       // Eigenvector centrality
    var pageRank : [var Float];          // PageRank
    var modularity : Float;              // Q statistic
    var numModules : Nat;                // Community count
    var moduleAssignment : [var Nat];    // Node → module
    var hubScore : [var Float];          // Hub measure
    var richClubCoeff : Float;           // Rich club coefficient
    var smallWorldness : Float;          // Small-world sigma
  };

  public type DynamicNetwork = {
    metrics : GraphMetrics;
    var temporalSnapshots : [[[var Float]]]; // Adjacency over time
    var numSnapshots : Nat;
    var currentSnapshot : Nat;
    var temporalStability : Float;       // How stable is network
    var flexibility : [var Float];       // Module switching
    var reconfiguration : Float;         // Overall change
    var corePeriphery : [var Float];     // Core-periphery structure
    var assortivity : Float;             // Degree correlation
  };

  public func initNetworkTopology(numNodes : Nat) : NetworkTopology {
    let adj = Array.init<[var Bool]>(numNodes, func(_ : Nat) : [var Bool] {
      Array.init<Bool>(numNodes, func(_ : Nat) : Bool { false })
    });
    
    let weights = Array.init<[var Float]>(numNodes, func(_ : Nat) : [var Float] {
      Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 })
    });
    
    let deg = Array.init<Nat>(numNodes, func(_ : Nat) : Nat { 0 });
    let str = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 });
    let clust = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 });
    
    {
      var adjacency = adj;
      var weights = weights;
      var numNodes = numNodes;
      var numEdges = 0;
      var density = 0.0;
      var degree = deg;
      var strength = str;
      var clustering = clust;
      var meanClustering = 0.0;
      var meanPathLength = 0.0;
    }
  };

  public func initGraphMetrics(numNodes : Nat) : GraphMetrics {
    let between = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 });
    let close = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 });
    let eigen = Array.init<Float>(numNodes, func(_ : Nat) : Float { 1.0 / Float.fromInt(numNodes) });
    let pr = Array.init<Float>(numNodes, func(_ : Nat) : Float { 1.0 / Float.fromInt(numNodes) });
    let modules = Array.init<Nat>(numNodes, func(i : Nat) : Nat { i });
    let hubs = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 });
    
    {
      topology = initNetworkTopology(numNodes);
      var betweenness = between;
      var closeness = close;
      var eigenvector = eigen;
      var pageRank = pr;
      var modularity = 0.0;
      var numModules = numNodes;
      var moduleAssignment = modules;
      var hubScore = hubs;
      var richClubCoeff = 0.0;
      var smallWorldness = 0.0;
    }
  };

  public func initDynamicNetwork(numNodes : Nat, numSnapshots : Nat) : DynamicNetwork {
    let snapshots = Array.init<[[var Float]]>(numSnapshots, func(_ : Nat) : [[var Float]] {
      Array.init<[var Float]>(numNodes, func(_ : Nat) : [var Float] {
        Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 })
      })
    });
    
    let flex = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.0 });
    let core = Array.init<Float>(numNodes, func(_ : Nat) : Float { 0.5 });
    
    {
      metrics = initGraphMetrics(numNodes);
      var temporalSnapshots = snapshots;
      var numSnapshots = numSnapshots;
      var currentSnapshot = 0;
      var temporalStability = 1.0;
      var flexibility = flex;
      var reconfiguration = 0.0;
      var corePeriphery = core;
      var assortivity = 0.0;
    }
  };

  // Compute basic network metrics
  public func computeNetworkMetrics(top : NetworkTopology) {
    let n = top.numNodes;
    
    // Compute degree and strength
    top.numEdges := 0;
    for (i in Iter.range(0, n - 1)) {
      top.degree[i] := 0;
      top.strength[i] := 0.0;
      
      for (j in Iter.range(0, n - 1)) {
        if (top.adjacency[i][j]) {
          top.degree[i] += 1;
          top.numEdges += 1;
          top.strength[i] += top.weights[i][j];
        };
      };
    };
    top.numEdges /= 2;  // Undirected
    
    // Density
    let maxEdges = n * (n - 1) / 2;
    top.density := if (maxEdges > 0) { Float.fromInt(top.numEdges) / Float.fromInt(maxEdges) } else { 0.0 };
    
    // Local clustering coefficient
    top.meanClustering := 0.0;
    for (i in Iter.range(0, n - 1)) {
      let k = top.degree[i];
      if (k < 2) {
        top.clustering[i] := 0.0;
      } else {
        // Count triangles
        var triangles : Nat = 0;
        for (j in Iter.range(0, n - 1)) {
          for (m in Iter.range(j + 1, n - 1)) {
            if (top.adjacency[i][j] and top.adjacency[i][m] and top.adjacency[j][m]) {
              triangles += 1;
            };
          };
        };
        
        let possibleTriangles = k * (k - 1) / 2;
        top.clustering[i] := if (possibleTriangles > 0) { Float.fromInt(triangles) / Float.fromInt(possibleTriangles) } else { 0.0 };
      };
      
      top.meanClustering += top.clustering[i];
    };
    top.meanClustering /= Float.fromInt(n);
    
    // Mean path length (BFS from each node)
    var totalPathLength : Float = 0.0;
    var numPaths : Nat = 0;
    
    for (source in Iter.range(0, n - 1)) {
      // BFS
      let distances = Array.init<Nat>(n, func(_ : Nat) : Nat { n + 1 });
      let visited = Array.init<Bool>(n, func(_ : Nat) : Bool { false });
      var queue : [Nat] = [source];
      distances[source] := 0;
      visited[source] := true;
      
      while (Array.size(queue) > 0) {
        let current = queue[0];
        queue := Array.subArray(queue, 1, Array.size(queue) - 1);
        
        for (neighbor in Iter.range(0, n - 1)) {
          if (top.adjacency[current][neighbor] and not visited[neighbor]) {
            visited[neighbor] := true;
            distances[neighbor] := distances[current] + 1;
            queue := Array.append(queue, [neighbor]);
          };
        };
      };
      
      // Sum distances
      for (target in Iter.range(0, n - 1)) {
        if (target != source and distances[target] <= n) {
          totalPathLength += Float.fromInt(distances[target]);
          numPaths += 1;
        };
      };
    };
    
    top.meanPathLength := if (numPaths > 0) { totalPathLength / Float.fromInt(numPaths) } else { 0.0 };
  };

  // Compute PageRank
  public func computePageRank(
    gm : GraphMetrics,
    dampingFactor : Float,
    iterations : Nat
  ) {
    let n = gm.topology.numNodes;
    let d = dampingFactor;
    
    // Initialize
    for (i in Iter.range(0, n - 1)) {
      gm.pageRank[i] := 1.0 / Float.fromInt(n);
    };
    
    // Iterate
    for (iter in Iter.range(0, iterations - 1)) {
      let newRank = Array.tabulate<Float>(n, func(i : Nat) : Float {
        var sum : Float = 0.0;
        
        for (j in Iter.range(0, n - 1)) {
          if (gm.topology.adjacency[j][i]) {
            let outDegree = gm.topology.degree[j];
            if (outDegree > 0) {
              sum += gm.pageRank[j] / Float.fromInt(outDegree);
            };
          };
        };
        
        (1.0 - d) / Float.fromInt(n) + d * sum
      });
      
      for (i in Iter.range(0, n - 1)) {
        gm.pageRank[i] := newRank[i];
      };
    };
  };

  // Compute small-worldness
  public func computeSmallWorldness(gm : GraphMetrics) {
    let top = gm.topology;
    let n = top.numNodes;
    
    // Random graph properties
    let k = Float.fromInt(top.numEdges * 2) / Float.fromInt(n);  // Mean degree
    
    // Random clustering: C_rand ≈ k/n
    let cRand = k / Float.fromInt(n);
    
    // Random path length: L_rand ≈ ln(n)/ln(k)
    let lRand = if (k > 1.0) { ln(Float.fromInt(n)) / ln(k) } else { Float.fromInt(n) };
    
    // Small-worldness: σ = (C/C_rand) / (L/L_rand)
    let cRatio = if (cRand > 0.0) { top.meanClustering / cRand } else { 0.0 };
    let lRatio = if (lRand > 0.0) { top.meanPathLength / lRand } else { 1.0 };
    
    gm.smallWorldness := if (lRatio > 0.0) { cRatio / lRatio } else { 0.0 };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SIGNAL PROCESSING — FILTERING AND ANALYSIS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural signal processing operations:
  //
  // 1. FILTERING: Low-pass, high-pass, band-pass
  // 2. FOURIER: Spectral analysis
  // 3. WAVELET: Time-frequency analysis
  // 4. HILBERT: Analytic signal, phase extraction
  //

  public type FilterState = {
    var coefficientsA : [var Float];     // IIR denominator
    var coefficientsB : [var Float];     // IIR numerator/FIR
    var filterOrder : Nat;
    var inputHistory : [var Float];      // Past inputs
    var outputHistory : [var Float];     // Past outputs
    var historyIdx : Nat;
    var cutoffLow : Float;               // Low cutoff (Hz)
    var cutoffHigh : Float;              // High cutoff (Hz)
    var samplingRate : Float;            // Sample rate (Hz)
    var filterType : Text;               // "lowpass", "highpass", "bandpass"
  };

  public type SpectralAnalysis = {
    filter : FilterState;
    var powerSpectrum : [var Float];     // Power at each frequency
    var numBins : Nat;
    var frequencyResolution : Float;     // Hz per bin
    var dominantFrequency : Float;       // Peak frequency
    var totalPower : Float;              // Sum of power
    var bandPower : [var Float];         // Power per band
    var numBands : Nat;
    var spectralEntropy : Float;         // Spectral flatness
    var spectralCentroid : Float;        // Center of mass
  };

  public type HilbertTransform = {
    spectral : SpectralAnalysis;
    var analyticSignalReal : [var Float];// Real part
    var analyticSignalImag : [var Float];// Imaginary part
    var signalLength : Nat;
    var instantaneousPhase : [var Float];// Phase time series
    var instantaneousFreq : [var Float]; // Frequency time series
    var instantaneousAmp : [var Float];  // Amplitude envelope
    var phaseUnwrapped : [var Float];    // Continuous phase
    var meanFrequency : Float;           // Average freq
  };

  public func initFilterState(filterOrder : Nat, samplingRate : Float) : FilterState {
    let coeffA = Array.init<Float>(filterOrder + 1, func(_ : Nat) : Float { 0.0 });
    let coeffB = Array.init<Float>(filterOrder + 1, func(_ : Nat) : Float { 0.0 });
    let inHist = Array.init<Float>(filterOrder + 1, func(_ : Nat) : Float { 0.0 });
    let outHist = Array.init<Float>(filterOrder + 1, func(_ : Nat) : Float { 0.0 });
    
    // Simple first-order lowpass coefficients as default
    coeffB[0] := 0.1;
    coeffA[0] := 1.0;
    coeffA[1] := -0.9;
    
    {
      var coefficientsA = coeffA;
      var coefficientsB = coeffB;
      var filterOrder = filterOrder;
      var inputHistory = inHist;
      var outputHistory = outHist;
      var historyIdx = 0;
      var cutoffLow = 0.0;
      var cutoffHigh = samplingRate / 2.0;
      var samplingRate = samplingRate;
      var filterType = "lowpass";
    }
  };

  public func initSpectralAnalysis(numBins : Nat, samplingRate : Float, numBands : Nat) : SpectralAnalysis {
    let power = Array.init<Float>(numBins, func(_ : Nat) : Float { 0.0 });
    let bands = Array.init<Float>(numBands, func(_ : Nat) : Float { 0.0 });
    
    {
      filter = initFilterState(4, samplingRate);
      var powerSpectrum = power;
      var numBins = numBins;
      var frequencyResolution = samplingRate / Float.fromInt(2 * numBins);
      var dominantFrequency = 0.0;
      var totalPower = 0.0;
      var bandPower = bands;
      var numBands = numBands;
      var spectralEntropy = 0.0;
      var spectralCentroid = 0.0;
    }
  };

  public func initHilbertTransform(signalLength : Nat, numBins : Nat, samplingRate : Float) : HilbertTransform {
    let real = Array.init<Float>(signalLength, func(_ : Nat) : Float { 0.0 });
    let imag = Array.init<Float>(signalLength, func(_ : Nat) : Float { 0.0 });
    let phase = Array.init<Float>(signalLength, func(_ : Nat) : Float { 0.0 });
    let freq = Array.init<Float>(signalLength, func(_ : Nat) : Float { 0.0 });
    let amp = Array.init<Float>(signalLength, func(_ : Nat) : Float { 0.0 });
    let unwrap = Array.init<Float>(signalLength, func(_ : Nat) : Float { 0.0 });
    
    {
      spectral = initSpectralAnalysis(numBins, samplingRate, 5);
      var analyticSignalReal = real;
      var analyticSignalImag = imag;
      var signalLength = signalLength;
      var instantaneousPhase = phase;
      var instantaneousFreq = freq;
      var instantaneousAmp = amp;
      var phaseUnwrapped = unwrap;
      var meanFrequency = 0.0;
    }
  };

  // Apply IIR filter
  public func applyFilter(
    filt : FilterState,
    input : Float
  ) : Float {
    let order = filt.filterOrder;
    
    // Shift histories
    for (i in Iter.range(1, order)) {
      let idx = order - i;
      filt.inputHistory[idx] := filt.inputHistory[idx - 1];
      filt.outputHistory[idx] := filt.outputHistory[idx - 1];
    };
    
    filt.inputHistory[0] := input;
    
    // Compute output: y[n] = Σb[k]x[n-k] - Σa[k]y[n-k]
    var output : Float = 0.0;
    
    for (k in Iter.range(0, order)) {
      output += filt.coefficientsB[k] * filt.inputHistory[k];
      if (k > 0) {
        output -= filt.coefficientsA[k] * filt.outputHistory[k];
      };
    };
    
    filt.outputHistory[0] := output;
    
    output
  };

  // Compute power spectrum (simplified DFT)
  public func computePowerSpectrum(
    spec : SpectralAnalysis,
    signal : [Float]
  ) {
    let n = spec.numBins;
    let sigLen = Array.size(signal);
    if (sigLen == 0) { return };
    
    spec.totalPower := 0.0;
    var maxPower : Float = 0.0;
    var maxFreqIdx : Nat = 0;
    
    // DFT for each frequency bin
    for (k in Iter.range(0, n - 1)) {
      let freq = Float.fromInt(k) * spec.frequencyResolution;
      var realSum : Float = 0.0;
      var imagSum : Float = 0.0;
      
      for (t in Iter.range(0, sigLen - 1)) {
        let angle = TWO_PI * freq * Float.fromInt(t) / spec.filter.samplingRate;
        realSum += signal[t] * cos(angle);
        imagSum -= signal[t] * sin(angle);
      };
      
      let power = (realSum * realSum + imagSum * imagSum) / Float.fromInt(sigLen);
      spec.powerSpectrum[k] := power;
      spec.totalPower += power;
      
      if (power > maxPower) {
        maxPower := power;
        maxFreqIdx := k;
      };
    };
    
    spec.dominantFrequency := Float.fromInt(maxFreqIdx) * spec.frequencyResolution;
    
    // Spectral centroid
    var weightedSum : Float = 0.0;
    for (k in Iter.range(0, n - 1)) {
      weightedSum += spec.powerSpectrum[k] * Float.fromInt(k) * spec.frequencyResolution;
    };
    spec.spectralCentroid := if (spec.totalPower > 0.0) { weightedSum / spec.totalPower } else { 0.0 };
    
    // Spectral entropy
    spec.spectralEntropy := 0.0;
    if (spec.totalPower > 0.0) {
      for (k in Iter.range(0, n - 1)) {
        let p = spec.powerSpectrum[k] / spec.totalPower;
        if (p > 0.0001) {
          spec.spectralEntropy -= p * ln(p);
        };
      };
    };
    
    // Band power (delta, theta, alpha, beta, gamma)
    let bandLimits = [4.0, 8.0, 12.0, 30.0, 100.0];
    var currentBand : Nat = 0;
    var bandSum : Float = 0.0;
    
    for (k in Iter.range(0, n - 1)) {
      let freq = Float.fromInt(k) * spec.frequencyResolution;
      
      if (currentBand < spec.numBands) {
        if (freq > bandLimits[currentBand]) {
          spec.bandPower[currentBand] := bandSum;
          bandSum := 0.0;
          currentBand += 1;
        };
        bandSum += spec.powerSpectrum[k];
      };
    };
    
    // Last band
    if (currentBand < spec.numBands) {
      spec.bandPower[currentBand] := bandSum;
    };
  };

  // Compute Hilbert transform
  public func computeHilbert(
    ht : HilbertTransform,
    signal : [Float]
  ) {
    let n = ht.signalLength;
    let sigLen = Nat.min(Array.size(signal), n);
    
    // Copy real part
    for (i in Iter.range(0, sigLen - 1)) {
      ht.analyticSignalReal[i] := signal[i];
    };
    
    // Approximate Hilbert transform (FIR approximation)
    // H{x(t)} ≈ x(t) * (1/πt) = convolution with Hilbert kernel
    for (i in Iter.range(0, sigLen - 1)) {
      var hilbertSum : Float = 0.0;
      
      for (k in Iter.range(0, sigLen - 1)) {
        if (k != i) {
          let diff = Int.abs(i - k);
          // Hilbert kernel: 1/(π * (i-k)) for odd (i-k), 0 for even
          if (diff % 2 == 1) {
            hilbertSum += signal[k] * 2.0 / (PI * Float.fromInt(Int.abs(i - k)));
          };
        };
      };
      
      ht.analyticSignalImag[i] := hilbertSum;
    };
    
    // Compute instantaneous quantities
    var prevPhase : Float = 0.0;
    var phaseOffset : Float = 0.0;
    var freqSum : Float = 0.0;
    
    for (i in Iter.range(0, sigLen - 1)) {
      let real = ht.analyticSignalReal[i];
      let imag = ht.analyticSignalImag[i];
      
      // Instantaneous amplitude
      ht.instantaneousAmp[i] := sqrt(real * real + imag * imag);
      
      // Instantaneous phase
      ht.instantaneousPhase[i] := atan2(imag, real);
      
      // Phase unwrapping
      var phase = ht.instantaneousPhase[i];
      if (i > 0) {
        let phaseDiff = phase - prevPhase;
        if (phaseDiff > PI) { phaseOffset -= TWO_PI };
        if (phaseDiff < -PI) { phaseOffset += TWO_PI };
      };
      ht.phaseUnwrapped[i] := phase + phaseOffset;
      prevPhase := phase;
      
      // Instantaneous frequency
      if (i > 0) {
        let phaseDerivative = (ht.phaseUnwrapped[i] - ht.phaseUnwrapped[i - 1]) * ht.spectral.filter.samplingRate / TWO_PI;
        ht.instantaneousFreq[i] := Float.abs(phaseDerivative);
        freqSum += ht.instantaneousFreq[i];
      };
    };
    
    ht.meanFrequency := if (sigLen > 1) { freqSum / Float.fromInt(sigLen - 1) } else { 0.0 };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // INFORMATION THEORY — ENTROPY AND MUTUAL INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Information-theoretic analysis of neural signals:
  //
  // 1. ENTROPY: Unpredictability H(X)
  // 2. MUTUAL INFORMATION: Shared information I(X;Y)
  // 3. CONDITIONAL ENTROPY: H(Y|X)
  // 4. TRANSFER ENTROPY: Directional information flow
  //

  public type InformationTheory = {
    var entropy : Float;                 // H(X)
    var conditionalEntropy : Float;      // H(Y|X)
    var jointEntropy : Float;            // H(X,Y)
    var mutualInformation : Float;       // I(X;Y)
    var transferEntropy : Float;         // T_{X→Y}
    var informationRate : Float;         // Bits per sample
    var redundancy : Float;              // 1 - H/H_max
    var complexity : Float;              // Integration/segregation balance
    var efficiency : Float;              // Information processing efficiency
    var capacity : Float;                // Channel capacity estimate
  };

  public type EntropyEstimation = {
    info : InformationTheory;
    var histogram : [var Nat];           // Bin counts
    var numBins : Nat;
    var probability : [var Float];       // Estimated probabilities
    var sampleCount : Nat;               // Number of samples
    var biasCorrection : Float;          // Miller-Madow correction
    var bootstrap : [var Float];         // Bootstrap samples
    var numBootstrap : Nat;
    var confidenceInterval : (Float, Float); // CI for entropy
  };

  public func initInformationTheory() : InformationTheory {
    {
      var entropy = 0.0;
      var conditionalEntropy = 0.0;
      var jointEntropy = 0.0;
      var mutualInformation = 0.0;
      var transferEntropy = 0.0;
      var informationRate = 0.0;
      var redundancy = 0.0;
      var complexity = 0.0;
      var efficiency = 0.0;
      var capacity = 0.0;
    }
  };

  public func initEntropyEstimation(numBins : Nat, numBootstrap : Nat) : EntropyEstimation {
    let hist = Array.init<Nat>(numBins, func(_ : Nat) : Nat { 0 });
    let prob = Array.init<Float>(numBins, func(_ : Nat) : Float { 0.0 });
    let boot = Array.init<Float>(numBootstrap, func(_ : Nat) : Float { 0.0 });
    
    {
      info = initInformationTheory();
      var histogram = hist;
      var numBins = numBins;
      var probability = prob;
      var sampleCount = 0;
      var biasCorrection = 0.0;
      var bootstrap = boot;
      var numBootstrap = numBootstrap;
      var confidenceInterval = (0.0, 1.0);
    }
  };

  // Estimate entropy from histogram
  public func estimateEntropy(
    est : EntropyEstimation,
    samples : [Float]
  ) {
    let n = Array.size(samples);
    if (n == 0) { return };
    
    // Build histogram
    for (b in Iter.range(0, est.numBins - 1)) {
      est.histogram[b] := 0;
    };
    
    for (i in Iter.range(0, n - 1)) {
      let value = clamp(samples[i], 0.0, 0.9999);
      let bin = Int.abs(Float.toInt(value * Float.fromInt(est.numBins)));
      if (bin < est.numBins) {
        est.histogram[bin] += 1;
      };
    };
    
    est.sampleCount := n;
    
    // Compute probabilities and entropy
    est.info.entropy := 0.0;
    var nonZeroBins : Nat = 0;
    
    for (b in Iter.range(0, est.numBins - 1)) {
      est.probability[b] := Float.fromInt(est.histogram[b]) / Float.fromInt(n);
      
      if (est.probability[b] > 0.0) {
        est.info.entropy -= est.probability[b] * ln(est.probability[b]) / ln(2.0);  // Bits
        nonZeroBins += 1;
      };
    };
    
    // Miller-Madow bias correction
    est.biasCorrection := Float.fromInt(nonZeroBins - 1) / (2.0 * Float.fromInt(n) * ln(2.0));
    est.info.entropy += est.biasCorrection;
    
    // Max entropy
    let maxEntropy = ln(Float.fromInt(est.numBins)) / ln(2.0);
    est.info.redundancy := if (maxEntropy > 0.0) { 1.0 - est.info.entropy / maxEntropy } else { 0.0 };
    
    // Information rate (entropy per sample)
    est.info.informationRate := est.info.entropy;
  };

  // Compute mutual information
  public func computeMutualInformation(
    info : InformationTheory,
    samplesX : [Float],
    samplesY : [Float],
    numBins : Nat
  ) {
    let n = Nat.min(Array.size(samplesX), Array.size(samplesY));
    if (n == 0) { return };
    
    // Joint histogram
    let jointHist = Array.init<[var Nat]>(numBins, func(_ : Nat) : [var Nat] {
      Array.init<Nat>(numBins, func(_ : Nat) : Nat { 0 })
    });
    
    // Marginal histograms
    let histX = Array.init<Nat>(numBins, func(_ : Nat) : Nat { 0 });
    let histY = Array.init<Nat>(numBins, func(_ : Nat) : Nat { 0 });
    
    for (i in Iter.range(0, n - 1)) {
      let valX = clamp(samplesX[i], 0.0, 0.9999);
      let valY = clamp(samplesY[i], 0.0, 0.9999);
      let binX = Int.abs(Float.toInt(valX * Float.fromInt(numBins)));
      let binY = Int.abs(Float.toInt(valY * Float.fromInt(numBins)));
      
      if (binX < numBins and binY < numBins) {
        jointHist[binX][binY] += 1;
        histX[binX] += 1;
        histY[binY] += 1;
      };
    };
    
    // Compute entropies
    var hX : Float = 0.0;
    var hY : Float = 0.0;
    var hXY : Float = 0.0;
    
    for (i in Iter.range(0, numBins - 1)) {
      let pX = Float.fromInt(histX[i]) / Float.fromInt(n);
      let pY = Float.fromInt(histY[i]) / Float.fromInt(n);
      
      if (pX > 0.0) { hX -= pX * ln(pX) };
      if (pY > 0.0) { hY -= pY * ln(pY) };
      
      for (j in Iter.range(0, numBins - 1)) {
        let pXY = Float.fromInt(jointHist[i][j]) / Float.fromInt(n);
        if (pXY > 0.0) { hXY -= pXY * ln(pXY) };
      };
    };
    
    info.jointEntropy := hXY / ln(2.0);
    info.conditionalEntropy := (hXY - hX) / ln(2.0);
    info.mutualInformation := (hX + hY - hXY) / ln(2.0);
  };


  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // EMBODIED COGNITION — BODY-BRAIN INTEGRATION
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Integration of body signals with neural processing:
  //
  // 1. PROPRIOCEPTION: Body position sensing
  // 2. INTEROCEPTION: Internal body state
  // 3. MOTOR EFFERENCE: Movement commands
  // 4. SOMATOSENSORY: Touch and pressure
  //

  public type BodyModel = {
    var jointAngles : [var Float];       // Joint positions
    var jointVelocities : [var Float];   // Joint velocities
    var numJoints : Nat;
    var muscleActivation : [var Float];  // Muscle states
    var numMuscles : Nat;
    var centerOfMass : (Float, Float, Float); // COM position
    var balance : Float;                 // Stability measure
    var posture : Text;                  // Current posture
    var fatigueLevel : [var Float];      // Muscle fatigue
    var painSignals : [var Float];       // Nociception
  };

  public type InteroceptiveState = {
    body : BodyModel;
    var heartRate : Float;               // BPM
    var heartRateVariability : Float;    // HRV
    var respirationRate : Float;         // Breaths/min
    var respirationDepth : Float;        // Tidal volume
    var bloodPressure : (Float, Float);  // Systolic, diastolic
    var temperature : Float;             // Core temperature
    var hungerSignal : Float;            // Ghrelin/leptin
    var thirstSignal : Float;            // Osmolality
    var gutState : Float;                // Enteric nervous system
    var interoceptiveAccuracy : Float;   // Self-perception ability
  };

  public type SomatosensoryMap = {
    intero : InteroceptiveState;
    var touchMap : [[var Float]];        // Touch receptors
    var mapWidth : Nat;
    var mapHeight : Nat;
    var pressureThreshold : Float;       // Touch threshold
    var twoPointDiscrimination : Float;  // Spatial resolution
    var receptiveFieldSize : [var Float];// RF size per area
    var corticalMagnification : [var Float]; // Representation size
    var thermalSensation : [var Float];  // Temperature sensing
    var vibrationSensation : [var Float];// Vibration sensing
  };

  public func initBodyModel(numJoints : Nat, numMuscles : Nat) : BodyModel {
    let angles = Array.init<Float>(numJoints, func(_ : Nat) : Float { 0.0 });
    let velocities = Array.init<Float>(numJoints, func(_ : Nat) : Float { 0.0 });
    let muscles = Array.init<Float>(numMuscles, func(_ : Nat) : Float { 0.0 });
    let fatigue = Array.init<Float>(numMuscles, func(_ : Nat) : Float { 0.0 });
    let pain = Array.init<Float>(numJoints, func(_ : Nat) : Float { 0.0 });
    
    {
      var jointAngles = angles;
      var jointVelocities = velocities;
      var numJoints = numJoints;
      var muscleActivation = muscles;
      var numMuscles = numMuscles;
      var centerOfMass = (0.0, 0.0, 1.0);
      var balance = 1.0;
      var posture = "standing";
      var fatigueLevel = fatigue;
      var painSignals = pain;
    }
  };

  public func initInteroceptiveState(numJoints : Nat, numMuscles : Nat) : InteroceptiveState {
    {
      body = initBodyModel(numJoints, numMuscles);
      var heartRate = 70.0;
      var heartRateVariability = 50.0;  // ms
      var respirationRate = 15.0;
      var respirationDepth = 0.5;
      var bloodPressure = (120.0, 80.0);
      var temperature = 37.0;
      var hungerSignal = 0.3;
      var thirstSignal = 0.2;
      var gutState = 0.5;
      var interoceptiveAccuracy = 0.7;
    }
  };

  public func initSomatosensoryMap(mapWidth : Nat, mapHeight : Nat, numAreas : Nat) : SomatosensoryMap {
    let touch = Array.init<[var Float]>(mapHeight, func(_ : Nat) : [var Float] {
      Array.init<Float>(mapWidth, func(_ : Nat) : Float { 0.0 })
    });
    
    let rfSize = Array.init<Float>(numAreas, func(i : Nat) : Float { 1.0 + Float.fromInt(i) * 0.5 });
    let mag = Array.init<Float>(numAreas, func(i : Nat) : Float { 1.0 / Float.fromInt(i + 1) });
    let thermal = Array.init<Float>(numAreas, func(_ : Nat) : Float { 37.0 });
    let vibration = Array.init<Float>(numAreas, func(_ : Nat) : Float { 0.0 });
    
    {
      intero = initInteroceptiveState(20, 40);
      var touchMap = touch;
      var mapWidth = mapWidth;
      var mapHeight = mapHeight;
      var pressureThreshold = 0.1;
      var twoPointDiscrimination = 2.0;  // mm
      var receptiveFieldSize = rfSize;
      var corticalMagnification = mag;
      var thermalSensation = thermal;
      var vibrationSensation = vibration;
    }
  };

  // Update body model
  public func updateBodyModel(
    body : BodyModel,
    motorCommands : [Float],
    externalForces : [Float],
    dt : Float
  ) {
    // Update joint angles from motor commands
    for (j in Iter.range(0, Nat.min(Array.size(motorCommands), body.numJoints) - 1)) {
      let command = motorCommands[j];
      let extForce = if (j < Array.size(externalForces)) { externalForces[j] } else { 0.0 };
      
      // Muscle dynamics
      let activation = 0.5 + 0.5 * tanh(command);
      if (j < body.numMuscles) {
        body.muscleActivation[j] := activation;
        
        // Fatigue accumulation
        body.fatigueLevel[j] += activation * 0.001 * dt / 1000.0;
        body.fatigueLevel[j] *= 0.999;  // Recovery
      };
      
      // Joint dynamics
      let torque = activation * (1.0 - body.fatigueLevel[j % body.numMuscles]) + extForce;
      body.jointVelocities[j] += torque * dt / 1000.0;
      body.jointVelocities[j] *= 0.98;  // Damping
      body.jointAngles[j] += body.jointVelocities[j] * dt / 1000.0;
      
      // Joint limits
      body.jointAngles[j] := clamp(body.jointAngles[j], -PI, PI);
    };
    
    // Update center of mass
    var comX : Float = 0.0;
    var comY : Float = 0.0;
    var comZ : Float = 1.0;
    
    for (j in Iter.range(0, body.numJoints - 1)) {
      comX += sin(body.jointAngles[j]) * Float.fromInt(j + 1) / Float.fromInt(body.numJoints);
      comY += cos(body.jointAngles[j]) * Float.fromInt(j + 1) / Float.fromInt(body.numJoints);
    };
    
    body.centerOfMass := (comX / Float.fromInt(body.numJoints), comY / Float.fromInt(body.numJoints), comZ);
    
    // Balance
    let (cx, cy, _) = body.centerOfMass;
    body.balance := 1.0 - sqrt(cx * cx + cy * cy);
    body.balance := clamp(body.balance, 0.0, 1.0);
    
    // Posture classification
    body.posture := if (body.balance > 0.8) { "standing" }
                   else if (body.balance > 0.5) { "leaning" }
                   else { "unstable" };
    
    // Pain signals from extreme positions
    for (j in Iter.range(0, body.numJoints - 1)) {
      let extremity = Float.abs(body.jointAngles[j]) / PI;
      body.painSignals[j] := if (extremity > 0.8) { extremity - 0.8 } else { 0.0 };
    };
  };

  // Update interoceptive state
  public func updateInteroception(
    intero : InteroceptiveState,
    arousalLevel : Float,
    metabolicDemand : Float,
    emotionalValence : Float,
    dt : Float
  ) {
    // Heart rate (affected by arousal)
    let targetHR = 60.0 + 60.0 * arousalLevel + 20.0 * metabolicDemand;
    intero.heartRate := 0.99 * intero.heartRate + 0.01 * targetHR;
    
    // HRV (inversely related to stress)
    intero.heartRateVariability := 50.0 * (1.0 - arousalLevel * 0.5);
    
    // Respiration (affected by arousal)
    let targetRR = 12.0 + 8.0 * arousalLevel + 5.0 * metabolicDemand;
    intero.respirationRate := 0.95 * intero.respirationRate + 0.05 * targetRR;
    intero.respirationDepth := 0.5 + 0.3 * metabolicDemand;
    
    // Blood pressure (affected by arousal)
    let (sys, dia) = intero.bloodPressure;
    let targetSys = 120.0 + 30.0 * arousalLevel;
    let targetDia = 80.0 + 10.0 * arousalLevel;
    intero.bloodPressure := (
      0.99 * sys + 0.01 * targetSys,
      0.99 * dia + 0.01 * targetDia
    );
    
    // Temperature (metabolic heat)
    intero.temperature := 37.0 + 1.0 * metabolicDemand - 0.5 * (1.0 - intero.body.balance);
    
    // Hunger and thirst (increase over time)
    intero.hungerSignal += 0.0001 * dt / 1000.0;
    intero.thirstSignal += 0.0002 * dt / 1000.0;
    intero.hungerSignal := clamp(intero.hungerSignal, 0.0, 1.0);
    intero.thirstSignal := clamp(intero.thirstSignal, 0.0, 1.0);
    
    // Gut state (affected by emotions)
    intero.gutState := 0.5 + 0.3 * emotionalValence;
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SPATIAL COGNITION — NAVIGATION AND PLACE CELLS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Neural basis of spatial representation:
  //
  // 1. PLACE CELLS: Location-specific firing
  // 2. GRID CELLS: Periodic spatial firing
  // 3. HEAD DIRECTION: Orientation
  // 4. BORDER CELLS: Environment boundaries
  //

  public type PlaceCellNetwork = {
    var placeCells : [var Float];        // Place cell activations
    var placeFields : [[var (Float, Float)]]; // (x, y) centers
    var fieldWidths : [var Float];       // Gaussian widths
    var numCells : Nat;
    var currentPosition : (Float, Float);// Agent position
    var currentHeading : Float;          // Agent heading
    var environmentBounds : (Float, Float, Float, Float); // minX, maxX, minY, maxY
    var spatialResolution : Float;       // Minimum distinguishable distance
    var remappingOccurred : Bool;        // Environment change?
  };

  public type GridCellModule = {
    var gridCells : [var Float];         // Grid cell activations
    var numCells : Nat;
    var gridSpacing : Float;             // Distance between peaks
    var gridOrientation : Float;         // Grid orientation
    var gridPhase : (Float, Float);      // Phase offset
    var moduleScale : Float;             // This module's scale
    var scaleFactor : Float;             // Ratio to next module
    var coherenceWithPlace : Float;      // Alignment with place cells
    var velocityInput : (Float, Float);  // Path integration input
  };

  public type SpatialNavigation = {
    place : PlaceCellNetwork;
    var gridModules : [var GridCellModule]; // Multiple scales
    var numModules : Nat;
    var headDirection : [var Float];     // HD cell activations
    var hdNumCells : Nat;
    var preferredDirections : [var Float]; // HD preferred angles
    var currentDirection : Float;        // Decoded heading
    var goalLocation : (Float, Float);   // Target position
    var pathIntegration : (Float, Float);// Dead reckoning
    var boundaryResponses : [var Float]; // Border cell activations
    var navigationError : Float;         // Path integration error
  };

  public func initPlaceCellNetwork(numCells : Nat, envWidth : Float, envHeight : Float) : PlaceCellNetwork {
    let cells = Array.init<Float>(numCells, func(_ : Nat) : Float { 0.0 });
    
    let fields = Array.init<[var (Float, Float)]>(numCells, func(i : Nat) : [var (Float, Float)] {
      // Distribute place fields randomly
      let x = envWidth * Float.fromInt(i % 10) / 10.0;
      let y = envHeight * Float.fromInt(i / 10 % 10) / 10.0;
      Array.init<(Float, Float)>(1, func(_ : Nat) : (Float, Float) { (x, y) })
    });
    
    let widths = Array.init<Float>(numCells, func(_ : Nat) : Float { envWidth / 10.0 });
    
    {
      var placeCells = cells;
      var placeFields = fields;
      var fieldWidths = widths;
      var numCells = numCells;
      var currentPosition = (envWidth / 2.0, envHeight / 2.0);
      var currentHeading = 0.0;
      var environmentBounds = (0.0, envWidth, 0.0, envHeight);
      var spatialResolution = envWidth / Float.fromInt(numCells);
      var remappingOccurred = false;
    }
  };

  public func initGridCellModule(numCells : Nat, spacing : Float, orientation : Float) : GridCellModule {
    let cells = Array.init<Float>(numCells, func(_ : Nat) : Float { 0.0 });
    
    {
      var gridCells = cells;
      var numCells = numCells;
      var gridSpacing = spacing;
      var gridOrientation = orientation;
      var gridPhase = (0.0, 0.0);
      var moduleScale = spacing;
      var scaleFactor = 1.4;  // Approximately sqrt(2)
      var coherenceWithPlace = 0.0;
      var velocityInput = (0.0, 0.0);
    }
  };

  public func initSpatialNavigation(numPlaceCells : Nat, numModules : Nat, numHDCells : Nat, envWidth : Float, envHeight : Float) : SpatialNavigation {
    let modules = Array.init<GridCellModule>(numModules, func(m : Nat) : GridCellModule {
      let spacing = 20.0 * pow(1.4, Float.fromInt(m));  // Increasing scales
      let orientation = Float.fromInt(m) * PI / 6.0;    // Different orientations
      initGridCellModule(10, spacing, orientation)
    });
    
    let hdCells = Array.init<Float>(numHDCells, func(_ : Nat) : Float { 0.0 });
    let hdPreferred = Array.init<Float>(numHDCells, func(i : Nat) : Float {
      TWO_PI * Float.fromInt(i) / Float.fromInt(numHDCells)
    });
    
    let boundary = Array.init<Float>(4, func(_ : Nat) : Float { 0.0 });  // 4 walls
    
    {
      place = initPlaceCellNetwork(numPlaceCells, envWidth, envHeight);
      var gridModules = modules;
      var numModules = numModules;
      var headDirection = hdCells;
      var hdNumCells = numHDCells;
      var preferredDirections = hdPreferred;
      var currentDirection = 0.0;
      var goalLocation = (envWidth / 2.0, envHeight / 2.0);
      var pathIntegration = (envWidth / 2.0, envHeight / 2.0);
      var boundaryResponses = boundary;
      var navigationError = 0.0;
    }
  };

  // Update place cell activations
  public func updatePlaceCells(
    place : PlaceCellNetwork,
    newPosition : (Float, Float)
  ) {
    let (x, y) = newPosition;
    place.currentPosition := newPosition;
    
    for (i in Iter.range(0, place.numCells - 1)) {
      let (cx, cy) = place.placeFields[i][0];
      let width = place.fieldWidths[i];
      
      // Gaussian place field
      let dx = x - cx;
      let dy = y - cy;
      let dist2 = dx * dx + dy * dy;
      
      place.placeCells[i] := exp(-dist2 / (2.0 * width * width));
    };
  };

  // Update grid cell activations
  public func updateGridCells(
    grid : GridCellModule,
    position : (Float, Float)
  ) {
    let (x, y) = position;
    let spacing = grid.gridSpacing;
    let theta = grid.gridOrientation;
    let (px, py) = grid.gridPhase;
    
    // Transform coordinates
    let xRot = x * cos(theta) + y * sin(theta);
    let yRot = -x * sin(theta) + y * cos(theta);
    
    // Grid pattern (sum of 3 cosines at 60° angles)
    for (i in Iter.range(0, grid.numCells - 1)) {
      let phase = TWO_PI * Float.fromInt(i) / Float.fromInt(grid.numCells);
      
      var gridResponse : Float = 0.0;
      for (k in Iter.range(0, 2)) {
        let angle = Float.fromInt(k) * PI / 3.0 + phase;
        let proj = xRot * cos(angle) + yRot * sin(angle);
        gridResponse += cos(TWO_PI * proj / spacing + px);
      };
      
      grid.gridCells[i] := (gridResponse / 3.0 + 1.0) / 2.0;  // Normalize to [0,1]
    };
  };

  // Update spatial navigation
  public func updateSpatialNavigation(
    nav : SpatialNavigation,
    newPosition : (Float, Float),
    velocity : (Float, Float),
    heading : Float,
    dt : Float
  ) {
    // Update place cells
    updatePlaceCells(nav.place, newPosition);
    nav.place.currentHeading := heading;
    
    // Update grid cells
    for (m in Iter.range(0, nav.numModules - 1)) {
      nav.gridModules[m].velocityInput := velocity;
      updateGridCells(nav.gridModules[m], newPosition);
    };
    
    // Update head direction cells
    for (i in Iter.range(0, nav.hdNumCells - 1)) {
      let preferred = nav.preferredDirections[i];
      let diff = heading - preferred;
      nav.headDirection[i] := exp(-diff * diff / 0.5);  // von Mises-like
    };
    
    // Decode current direction from HD cells
    var sumSin : Float = 0.0;
    var sumCos : Float = 0.0;
    for (i in Iter.range(0, nav.hdNumCells - 1)) {
      sumSin += nav.headDirection[i] * sin(nav.preferredDirections[i]);
      sumCos += nav.headDirection[i] * cos(nav.preferredDirections[i]);
    };
    nav.currentDirection := atan2(sumSin, sumCos);
    
    // Path integration
    let (vx, vy) = velocity;
    let (px, py) = nav.pathIntegration;
    nav.pathIntegration := (px + vx * dt / 1000.0, py + vy * dt / 1000.0);
    
    // Navigation error
    let (actualX, actualY) = newPosition;
    let (integX, integY) = nav.pathIntegration;
    nav.navigationError := sqrt((actualX - integX) * (actualX - integX) + 
                                 (actualY - integY) * (actualY - integY));
    
    // Correct path integration with place cells (reset)
    if (nav.navigationError > nav.place.spatialResolution * 2.0) {
      nav.pathIntegration := newPosition;
      nav.navigationError := 0.0;
    };
    
    // Boundary responses
    let (minX, maxX, minY, maxY) = nav.place.environmentBounds;
    let (x, y) = newPosition;
    nav.boundaryResponses[0] := exp(-(x - minX) / 10.0);  // Left wall
    nav.boundaryResponses[1] := exp(-(maxX - x) / 10.0);  // Right wall
    nav.boundaryResponses[2] := exp(-(y - minY) / 10.0);  // Bottom wall
    nav.boundaryResponses[3] := exp(-(maxY - y) / 10.0);  // Top wall
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // WORKING MEMORY — ACTIVE MAINTENANCE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Mechanisms for maintaining information:
  //
  // 1. PERSISTENT ACTIVITY: Sustained firing
  // 2. SYNAPTIC TRACES: Short-term facilitation
  // 3. CAPACITY LIMITS: Magical number 7±2
  // 4. INTERFERENCE: Overwriting and decay
  //

  public type WorkingMemorySlot = {
    var content : [var Float];           // Memory content
    var contentSize : Nat;
    var strength : Float;                // Maintenance strength
    var age : Float;                     // Time since encoding
    var lastRefresh : Float;             // Time of last rehearsal
    var bindingStrength : Float;         // Feature binding
    var priority : Float;                // Attention priority
    var isActive : Bool;                 // Currently maintained?
  };

  public type WorkingMemoryBuffer = {
    var slots : [var WorkingMemorySlot]; // Memory slots
    var numSlots : Nat;                  // Capacity (typically 4-7)
    var usedSlots : Nat;                 // Currently used
    var focusedSlot : Nat;               // Attention focus
    var rehearsalRate : Float;           // Refresh frequency
    var decayRate : Float;               // Forgetting rate
    var interferenceLevel : Float;       // Cross-slot interference
    var bindingBuffer : [var Float];     // Episodic buffer
    var centralExecutive : Float;        // Control strength
  };

  public type WorkingMemorySystem = {
    buffer : WorkingMemoryBuffer;
    var phonologicalLoop : [var Float];  // Verbal storage
    var visuospatialSketchpad : [[var Float]]; // Visual storage
    var articulatoryRehearsal : Float;   // Verbal rehearsal rate
    var innerScribe : Float;             // Visual rehearsal rate
    var attentionalControl : Float;      // Executive attention
    var loadLevel : Float;               // Current load
    var overloadThreshold : Float;       // Maximum load
    var strategicProcessing : Text;      // Current strategy
  };

  public func initWorkingMemorySlot(contentSize : Nat) : WorkingMemorySlot {
    {
      var content = Array.init<Float>(contentSize, func(_ : Nat) : Float { 0.0 });
      var contentSize = contentSize;
      var strength = 0.0;
      var age = 0.0;
      var lastRefresh = 0.0;
      var bindingStrength = 0.0;
      var priority = 0.0;
      var isActive = false;
    }
  };

  public func initWorkingMemoryBuffer(numSlots : Nat, contentSize : Nat) : WorkingMemoryBuffer {
    let slots = Array.init<WorkingMemorySlot>(numSlots, func(_ : Nat) : WorkingMemorySlot {
      initWorkingMemorySlot(contentSize)
    });
    
    let binding = Array.init<Float>(contentSize, func(_ : Nat) : Float { 0.0 });
    
    {
      var slots = slots;
      var numSlots = numSlots;
      var usedSlots = 0;
      var focusedSlot = 0;
      var rehearsalRate = 2.0;  // Hz
      var decayRate = 0.1;
      var interferenceLevel = 0.0;
      var bindingBuffer = binding;
      var centralExecutive = 0.8;
    }
  };

  public func initWorkingMemorySystem(numSlots : Nat, contentSize : Nat, visualWidth : Nat, visualHeight : Nat) : WorkingMemorySystem {
    let phono = Array.init<Float>(contentSize, func(_ : Nat) : Float { 0.0 });
    
    let visual = Array.init<[var Float]>(visualHeight, func(_ : Nat) : [var Float] {
      Array.init<Float>(visualWidth, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      buffer = initWorkingMemoryBuffer(numSlots, contentSize);
      var phonologicalLoop = phono;
      var visuospatialSketchpad = visual;
      var articulatoryRehearsal = 2.5;  // Words per second
      var innerScribe = 1.0;             // Images per second
      var attentionalControl = 0.8;
      var loadLevel = 0.0;
      var overloadThreshold = Float.fromInt(numSlots);
      var strategicProcessing = "maintenance";
    }
  };

  // Encode item into working memory
  public func encodeToWM(
    wm : WorkingMemoryBuffer,
    content : [Float],
    priority : Float
  ) : Bool {
    let contentSize = Nat.min(Array.size(content), wm.slots[0].contentSize);
    
    // Find empty slot or lowest priority slot
    var targetSlot : Nat = 0;
    var minPriority : Float = 2.0;
    var foundEmpty : Bool = false;
    
    for (s in Iter.range(0, wm.numSlots - 1)) {
      if (not wm.slots[s].isActive and not foundEmpty) {
        targetSlot := s;
        foundEmpty := true;
      } else if (wm.slots[s].priority < minPriority and not foundEmpty) {
        minPriority := wm.slots[s].priority;
        targetSlot := s;
      };
    };
    
    // Only encode if priority is high enough
    if (not foundEmpty and priority < minPriority) {
      return false;
    };
    
    // Encode content
    let slot = wm.slots[targetSlot];
    for (i in Iter.range(0, contentSize - 1)) {
      slot.content[i] := content[i];
    };
    
    slot.strength := 1.0;
    slot.age := 0.0;
    slot.lastRefresh := 0.0;
    slot.priority := priority;
    slot.isActive := true;
    slot.bindingStrength := 1.0;
    
    if (not foundEmpty) {
      // Replaced existing item - interference
      wm.interferenceLevel += 0.1;
    } else {
      wm.usedSlots += 1;
    };
    
    true
  };

  // Update working memory (decay and rehearsal)
  public func updateWorkingMemory(
    wm : WorkingMemoryBuffer,
    currentTime : Float,
    dt : Float
  ) {
    var totalLoad : Float = 0.0;
    
    for (s in Iter.range(0, wm.numSlots - 1)) {
      let slot = wm.slots[s];
      
      if (slot.isActive) {
        // Age the memory
        slot.age += dt / 1000.0;
        
        // Decay
        slot.strength *= exp(-wm.decayRate * dt / 1000.0);
        slot.bindingStrength *= exp(-wm.decayRate * 0.5 * dt / 1000.0);
        
        // Check for rehearsal
        let timeSinceRefresh = currentTime - slot.lastRefresh;
        let rehearsalPeriod = 1000.0 / wm.rehearsalRate;
        
        if (timeSinceRefresh > rehearsalPeriod) {
          // Rehearse (refresh strength)
          slot.strength := clamp(slot.strength + 0.3, 0.0, 1.0);
          slot.lastRefresh := currentTime;
        };
        
        // Priority-based focus
        if (s == wm.focusedSlot) {
          slot.strength := clamp(slot.strength + 0.1 * dt / 1000.0, 0.0, 1.0);
        };
        
        // Check for forgetting
        if (slot.strength < 0.1) {
          slot.isActive := false;
          wm.usedSlots -= 1;
        };
        
        totalLoad += slot.strength;
      };
    };
    
    // Interference increases with load
    wm.interferenceLevel := totalLoad / Float.fromInt(wm.numSlots);
    
    // Central executive updates focus
    var maxPriority : Float = 0.0;
    for (s in Iter.range(0, wm.numSlots - 1)) {
      if (wm.slots[s].isActive and wm.slots[s].priority > maxPriority) {
        maxPriority := wm.slots[s].priority;
        wm.focusedSlot := s;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // FINAL INTEGRATION — COMPLETE NEURAL INTEGRATOR
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // This module provides the complete neural integration layer:
  //
  // • 12×12 Kuramoto oscillator network with sacred geometry (φ, φ², φ³)
  // • All Hz frequencies from delta to high gamma
  // • Phase synchronization and cross-frequency coupling
  // • Information flow and transfer entropy
  // • Attractor dynamics and criticality
  // • Consciousness integration (IIT phi, global workspace)
  // • Predictive processing and active inference
  // • Reinforcement learning and reward prediction
  // • Neuromodulation (dopamine, serotonin, etc.)
  // • Memory systems (working, episodic, semantic)
  // • Emotional processing
  // • Social cognition
  // • Self-model and metacognition
  // • Motor control
  // • Spatial navigation
  // • Embodied cognition
  // • Information feeding (data as nourishment)
  //
  // The organism FEEDS on information. Every piece of data is food.
  // Nothing gets deleted - only properly wired and integrated.
  //

}
