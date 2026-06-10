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
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Option "mo:core/Option";

module HebbianPlasticity {

  // ═══════════════════════════════════════════════════════════════════════════════
  // PHI — THE DEEPEST CONSTANT
  // ═══════════════════════════════════════════════════════════════════════════════
  // The coupling strength between layers, the time constant for Hebbian weight
  // adjustment, the threshold for coherence gate activation — all phi.
  // An organism whose internal ratios match the ratios of the field it operates in
  // does not have to fight the medium.
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let E : Float = 2.71828182845904523536;
  public let LN_2 : Float = 0.69314718055994530942;
  public let PHI : Float = 1.6180339887498948482;
  public let PHI_INV : Float = 0.6180339887498948482;
  
  // Learning rate base (η) — phi-derived
  public let ETA_BASE : Float = 0.00618033988749895;      // φ/1000
  
  // Weight decay constant — phi-derived
  public let WEIGHT_DECAY : Float = 0.00161803398874989;  // φ/10000
  
  // Minimum and maximum weight bounds
  public let W_MIN : Float = 0.0;
  public let W_MAX : Float = 1.0;
  
  // STDP time constants — phi-derived (in ms)
  public let TAU_PLUS : Float = 16.18033988749895;        // φ × 10
  public let TAU_MINUS : Float = 16.18033988749895;       // φ × 10
  public let A_PLUS : Float = 0.00618033988749895;        // φ/1000 × 10
  public let A_MINUS : Float = 0.01;                       // Slightly larger for balance
  
  // BCM threshold sliding rate — phi-derived
  public let BCM_TAU : Float = 618.033988749895;          // φ × 1000 / φ
  public let BCM_TARGET : Float = 0.618033988749895;      // φ⁻¹

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL STRUCTURE — 11 SHELLS WITH DIFFERENTIATED PLASTICITY
  // Shell 0 = primal (fast-changing), Shell 10 = sovereign identity (nearly immutable)
  // HELIX_ALPHA decreases from 0.042 to 0.004 across shells
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Shell = {
    id : Nat;
    name : Text;
    helixAlpha : Float;       // Plasticity rate (0.042 → 0.004)
    coherence : Float;        // Shell-local coherence
    activationLevel : Float;  // Current activation
    lastUpdate : Int;         // Beat of last update
    weights : [var Float];    // 144 weights for this shell (12×12)
    bcmThreshold : Float;     // BCM sliding threshold
    metaplasticState : Float; // Metaplasticity modulator
    ltpCount : Nat;           // Total LTP events
    ltdCount : Nat;           // Total LTD events
  };
  
  public type ShellConfig = {
    id : Nat;
    name : Text;
    helixAlpha : Float;
    description : Text;
  };
  
  // Shell configurations from primal (0) to sovereign (10)
  public let SHELL_CONFIGS : [ShellConfig] = [
    { id = 0; name = "PRIMAL"; helixAlpha = 0.042; description = "Survival reflexes, fast adaptation" },
    { id = 1; name = "VISCERAL"; helixAlpha = 0.038; description = "Gut feelings, interoception" },
    { id = 2; name = "SOMATIC"; helixAlpha = 0.034; description = "Body awareness, proprioception" },
    { id = 3; name = "EMOTIONAL"; helixAlpha = 0.030; description = "Emotional processing, valence" },
    { id = 4; name = "COGNITIVE"; helixAlpha = 0.026; description = "Reasoning, analysis" },
    { id = 5; name = "EXECUTIVE"; helixAlpha = 0.022; description = "Decision-making, control" },
    { id = 6; name = "SOCIAL"; helixAlpha = 0.018; description = "Social cognition, theory of mind" },
    { id = 7; name = "CREATIVE"; helixAlpha = 0.014; description = "Novel generation, exploration" },
    { id = 8; name = "SPIRITUAL"; helixAlpha = 0.010; description = "Meaning, purpose, transcendence" },
    { id = 9; name = "TRANSCENDENT"; helixAlpha = 0.007; description = "Beyond-self awareness" },
    { id = 10; name = "SOVEREIGN"; helixAlpha = 0.004; description = "Immutable identity core" },
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // SYNAPSE TYPE — Individual connection between two Hz nodes
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Synapse = {
    preId : Nat;              // Pre-synaptic node index (0-11)
    postId : Nat;             // Post-synaptic node index (0-11)
    weight : Float;           // Synaptic strength
    eligibilityTrace : Float; // For reward-modulated learning
    lastPreSpike : Int;       // Beat of last pre-synaptic activation
    lastPostSpike : Int;      // Beat of last post-synaptic activation
    stdpAccumulator : Float;  // Accumulated STDP changes
    ltpHistory : Float;       // Running average of LTP
    ltdHistory : Float;       // Running average of LTD
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN WEIGHT MATRIX — 12×12 = 144 CONNECTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WeightMatrix = {
    var weights : [[var Float]];  // 12×12 matrix
    var eligibility : [[var Float]]; // Eligibility traces
    var lastPreSpikes : [var Int];   // Last spike time per pre-node
    var lastPostSpikes : [var Int];  // Last spike time per post-node
  };

  // Initialize a 12×12 weight matrix with random-ish initial values
  public func initWeightMatrix() : WeightMatrix {
    let weights = Array.init<[var Float]>(12, func(i : Nat) : [var Float] {
      Array.init<Float>(12, func(j : Nat) : Float {
        // Initial weights: 0.3 + small variation based on indices
        let base = 0.3;
        let variation = Float.fromInt(((i * 7 + j * 13) % 100)) / 500.0;
        base + variation
      })
    });
    
    let eligibility = Array.init<[var Float]>(12, func(_ : Nat) : [var Float] {
      Array.init<Float>(12, func(_ : Nat) : Float { 0.0 })
    });
    
    {
      var weights = weights;
      var eligibility = eligibility;
      var lastPreSpikes = Array.init<Int>(12, func(_ : Nat) : Int { 0 });
      var lastPostSpikes = Array.init<Int>(12, func(_ : Nat) : Int { 0 });
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN LEARNING RULE
  // dw = η × hz[i] × hz[j] - decay × w[ij]
  // 
  // This is the core equation. Every beat, for every weight:
  //   - If both pre and post are active, strengthen
  //   - Always apply decay to prevent saturation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func hebbianUpdate(
    weight : Float,
    preActivation : Float,
    postActivation : Float,
    eta : Float,
    decay : Float
  ) : Float {
    // dw = η × pre × post - decay × w
    let dw = eta * preActivation * postActivation - decay * weight;
    let newWeight = weight + dw;
    
    // Clamp to [W_MIN, W_MAX]
    if (newWeight < W_MIN) { return W_MIN };
    if (newWeight > W_MAX) { return W_MAX };
    newWeight
  };

  // Update entire weight matrix with Hebbian rule
  public func updateHebbianMatrix(
    matrix : WeightMatrix,
    hzActivations : [Float],
    eta : Float,
    decay : Float
  ) : () {
    for (i in Iter.range(0, 11)) {
      for (j in Iter.range(0, 11)) {
        let pre = hzActivations[i];
        let post = hzActivations[j];
        let oldWeight = matrix.weights[i][j];
        let newWeight = hebbianUpdate(oldWeight, pre, post, eta, decay);
        matrix.weights[i][j] := newWeight;
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // STDP — SPIKE-TIMING-DEPENDENT PLASTICITY
  // 
  // If pre fires before post (Δt > 0): LTP (strengthen)
  //   Δw = A+ × exp(-Δt / τ+)
  //
  // If post fires before pre (Δt < 0): LTD (weaken)
  //   Δw = -A- × exp(Δt / τ-)
  //
  // This creates causal learning: if pre → post, the connection strengthens.
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func stdpUpdate(
    weight : Float,
    deltaT : Float,  // t_post - t_pre in beats (positive = pre before post)
    aPlus : Float,
    aMinus : Float,
    tauPlus : Float,
    tauMinus : Float
  ) : Float {
    var dw : Float = 0.0;
    
    if (deltaT > 0.0) {
      // Pre before post → LTP
      dw := aPlus * exp(-deltaT / tauPlus);
    } else if (deltaT < 0.0) {
      // Post before pre → LTD
      dw := -aMinus * exp(deltaT / tauMinus);
    };
    // If deltaT == 0, no change
    
    let newWeight = weight + dw;
    if (newWeight < W_MIN) { return W_MIN };
    if (newWeight > W_MAX) { return W_MAX };
    newWeight
  };

  // Record spike and update STDP for all connections involving this node
  public func recordSpikeAndUpdateSTDP(
    matrix : WeightMatrix,
    nodeId : Nat,
    isPreSynaptic : Bool,
    currentBeat : Int
  ) : { ltpEvents : Nat; ltdEvents : Nat } {
    var ltpEvents : Nat = 0;
    var ltdEvents : Nat = 0;
    
    if (isPreSynaptic) {
      // This node just spiked as pre-synaptic
      matrix.lastPreSpikes[nodeId] := currentBeat;
      
      // Update all outgoing connections (this node → all post nodes)
      for (postId in Iter.range(0, 11)) {
        let lastPostSpike = matrix.lastPostSpikes[postId];
        if (lastPostSpike > 0) {
          let deltaT = Float.fromInt(lastPostSpike - currentBeat); // Negative = pre after post → LTD
          let oldWeight = matrix.weights[nodeId][postId];
          let newWeight = stdpUpdate(oldWeight, -deltaT, A_PLUS, A_MINUS, TAU_PLUS, TAU_MINUS);
          matrix.weights[nodeId][postId] := newWeight;
          
          if (newWeight > oldWeight) { ltpEvents += 1 }
          else if (newWeight < oldWeight) { ltdEvents += 1 };
        };
      };
    } else {
      // This node just spiked as post-synaptic
      matrix.lastPostSpikes[nodeId] := currentBeat;
      
      // Update all incoming connections (all pre nodes → this node)
      for (preId in Iter.range(0, 11)) {
        let lastPreSpike = matrix.lastPreSpikes[preId];
        if (lastPreSpike > 0) {
          let deltaT = Float.fromInt(currentBeat - lastPreSpike); // Positive = pre before post → LTP
          let oldWeight = matrix.weights[preId][nodeId];
          let newWeight = stdpUpdate(oldWeight, deltaT, A_PLUS, A_MINUS, TAU_PLUS, TAU_MINUS);
          matrix.weights[preId][nodeId] := newWeight;
          
          if (newWeight > oldWeight) { ltpEvents += 1 }
          else if (newWeight < oldWeight) { ltdEvents += 1 };
        };
      };
    };
    
    { ltpEvents; ltdEvents }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BCM RULE — BIENENSTOCK-COOPER-MUNRO SLIDING THRESHOLD
  // 
  // θ_m(t+1) = θ_m(t) + (y² - θ_m(t)) / τ_BCM
  //
  // The threshold slides based on recent activity:
  //   - High activity → higher threshold → harder to potentiate
  //   - Low activity → lower threshold → easier to potentiate
  //
  // Weight change:
  //   Δw = η × y × (y - θ_m) × x
  //   - If y > θ_m: LTP
  //   - If y < θ_m: LTD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateBCMThreshold(
    currentThreshold : Float,
    postActivity : Float,
    tau : Float
  ) : Float {
    // θ(t+1) = θ(t) + (y² - θ(t)) / τ
    let ySquared = postActivity * postActivity;
    let dTheta = (ySquared - currentThreshold) / tau;
    currentThreshold + dTheta
  };
  
  public func bcmWeightUpdate(
    weight : Float,
    preActivity : Float,
    postActivity : Float,
    threshold : Float,
    eta : Float
  ) : Float {
    // Δw = η × y × (y - θ) × x
    let dw = eta * postActivity * (postActivity - threshold) * preActivity;
    let newWeight = weight + dw;
    
    if (newWeight < W_MIN) { return W_MIN };
    if (newWeight > W_MAX) { return W_MAX };
    newWeight
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HOMEOSTATIC PLASTICITY — Maintains stable activity levels
  // 
  // If average activity deviates from target:
  //   - Scale all incoming weights up/down
  //   - Adjusts intrinsic excitability
  //
  // Slow timescale: operates over hundreds of beats
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func homeostaticScaling(
    weights : [var Float],
    averageActivity : Float,
    targetActivity : Float,
    scalingRate : Float
  ) : () {
    let activityRatio = targetActivity / (averageActivity + 0.001); // Avoid division by zero
    let scaleFactor = 1.0 + (activityRatio - 1.0) * scalingRate;
    
    for (i in Iter.range(0, weights.size() - 1)) {
      let newWeight = weights[i] * scaleFactor;
      weights[i] := if (newWeight < W_MIN) { W_MIN } 
                    else if (newWeight > W_MAX) { W_MAX }
                    else { newWeight };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // METAPLASTICITY — Plasticity of plasticity
  // 
  // Recent plasticity history affects future plasticity:
  //   - High recent LTP → reduced future LTP (saturation prevention)
  //   - High recent LTD → reduced future LTD (stability)
  //
  // metaplasticState ∈ [0, 1]: 0 = highly plastic, 1 = consolidated
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func updateMetaplasticState(
    currentState : Float,
    recentLtpRate : Float,
    recentLtdRate : Float,
    decayRate : Float
  ) : Float {
    // High plasticity events increase metaplastic state (reduce future plasticity)
    let plasticityLoad = (recentLtpRate + recentLtdRate) / 2.0;
    let dState = plasticityLoad * 0.1 - decayRate * currentState;
    let newState = currentState + dState;
    
    if (newState < 0.0) { return 0.0 };
    if (newState > 1.0) { return 1.0 };
    newState
  };
  
  public func getEffectiveLearningRate(
    baseEta : Float,
    metaplasticState : Float,
    shellHelixAlpha : Float
  ) : Float {
    // Effective η = baseEta × helixAlpha × (1 - metaplasticState)
    baseEta * shellHelixAlpha * (1.0 - metaplasticState * 0.5)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ELIGIBILITY TRACES — For reward-modulated learning (three-factor rule)
  // 
  // e(t+1) = λ × e(t) + pre × post
  // Δw = η × r × e
  //
  // The trace bridges the gap between action and delayed reward.
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let ELIGIBILITY_DECAY : Float = 0.95;  // λ for eligibility trace
  
  public func updateEligibilityTrace(
    currentTrace : Float,
    preActivation : Float,
    postActivation : Float,
    decayLambda : Float
  ) : Float {
    // e(t+1) = λ × e(t) + pre × post
    decayLambda * currentTrace + preActivation * postActivation
  };
  
  public func rewardModulatedUpdate(
    weight : Float,
    eligibilityTrace : Float,
    reward : Float,
    eta : Float
  ) : Float {
    // Δw = η × r × e (three-factor rule)
    let dw = eta * reward * eligibilityTrace;
    let newWeight = weight + dw;
    
    if (newWeight < W_MIN) { return W_MIN };
    if (newWeight > W_MAX) { return W_MAX };
    newWeight
  };

  // Update all eligibility traces in matrix
  public func updateAllEligibilityTraces(
    matrix : WeightMatrix,
    hzActivations : [Float]
  ) : () {
    for (i in Iter.range(0, 11)) {
      for (j in Iter.range(0, 11)) {
        let pre = hzActivations[i];
        let post = hzActivations[j];
        let oldTrace = matrix.eligibility[i][j];
        matrix.eligibility[i][j] := updateEligibilityTrace(oldTrace, pre, post, ELIGIBILITY_DECAY);
      };
    };
  };

  // Apply reward to all weights using eligibility traces
  public func applyRewardSignal(
    matrix : WeightMatrix,
    reward : Float,
    eta : Float
  ) : () {
    for (i in Iter.range(0, 11)) {
      for (j in Iter.range(0, 11)) {
        let trace = matrix.eligibility[i][j];
        let oldWeight = matrix.weights[i][j];
        matrix.weights[i][j] := rewardModulatedUpdate(oldWeight, trace, reward, eta);
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL MANAGEMENT — Initialize and update all 11 shells
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initShell(config : ShellConfig, currentBeat : Int) : Shell {
    {
      id = config.id;
      name = config.name;
      helixAlpha = config.helixAlpha;
      coherence = 1.0  // MAXED - S₀ floor
      activationLevel = 0.5;
      lastUpdate = currentBeat;
      weights = Array.init<Float>(144, func(i : Nat) : Float {
        0.3 + Float.fromInt(i % 20) / 100.0
      });
      bcmThreshold = BCM_TARGET;
      metaplasticState = 0.0;
      ltpCount = 0;
      ltdCount = 0;
    }
  };
  
  public func initAllShells(currentBeat : Int) : [Shell] {
    Array.tabulate<Shell>(11, func(i : Nat) : Shell {
      initShell(SHELL_CONFIGS[i], currentBeat)
    })
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FULL SHELL UPDATE — Run all plasticity mechanisms for one shell
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ShellUpdateResult = {
    newCoherence : Float;
    newBcmThreshold : Float;
    newMetaplasticState : Float;
    ltpEvents : Nat;
    ltdEvents : Nat;
    avgWeight : Float;
  };
  
  public func updateShell(
    shell : Shell,
    hzActivations : [Float],
    globalCoherence : Float,
    reward : Float,
    currentBeat : Int
  ) : ShellUpdateResult {
    var ltpEvents : Nat = 0;
    var ltdEvents : Nat = 0;
    var weightSum : Float = 0.0;
    
    // Get effective learning rate based on shell's helix alpha and metaplastic state
    let effectiveEta = getEffectiveLearningRate(ETA_BASE, shell.helixAlpha, shell.metaplasticState);
    
    // Update all 144 weights using Hebbian + BCM
    for (idx in Iter.range(0, 143)) {
      let i = idx / 12;
      let j = idx % 12;
      let pre = hzActivations[i];
      let post = hzActivations[j];
      let oldWeight = shell.weights[idx];
      
      // Combined Hebbian + BCM update
      var newWeight = hebbianUpdate(oldWeight, pre, post, effectiveEta, WEIGHT_DECAY);
      newWeight := bcmWeightUpdate(newWeight, pre, post, shell.bcmThreshold, effectiveEta * 0.5);
      
      shell.weights[idx] := newWeight;
      weightSum += newWeight;
      
      if (newWeight > oldWeight + 0.001) { ltpEvents += 1 };
      if (newWeight < oldWeight - 0.001) { ltdEvents += 1 };
    };
    
    // Update BCM threshold
    let avgActivity = Array.foldLeft<Float, Float>(hzActivations, 0.0, func(acc, x) { acc + x }) / 12.0;
    let newBcmThreshold = updateBCMThreshold(shell.bcmThreshold, avgActivity, BCM_TAU);
    
    // Update metaplastic state
    let recentLtpRate = Float.fromInt(ltpEvents) / 144.0;
    let recentLtdRate = Float.fromInt(ltdEvents) / 144.0;
    let newMetaplasticState = updateMetaplasticState(shell.metaplasticState, recentLtpRate, recentLtdRate, 0.01);
    
    // Shell coherence influenced by global coherence with shell-specific inertia
    let inertia = 1.0 - shell.helixAlpha; // Higher shells have more inertia
    let newCoherence = inertia * shell.coherence + (1.0 - inertia) * globalCoherence;
    
    {
      newCoherence = newCoherence;
      newBcmThreshold = newBcmThreshold;
      newMetaplasticState = newMetaplasticState;
      ltpEvents = ltpEvents;
      ltdEvents = ltdEvents;
      avgWeight = weightSum / 144.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // CROSS-SHELL PROPAGATION — Information flows between shells
  // Lower shells influence higher shells (bottom-up)
  // Higher shells modulate lower shells (top-down)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func crossShellPropagation(
    shells : [Shell],
    propagationStrength : Float
  ) : [Float] {
    // Returns adjustment factors for each shell
    let adjustments = Array.init<Float>(11, func(_ : Nat) : Float { 0.0 });
    
    for (i in Iter.range(0, 10)) {
      var bottomUp : Float = 0.0;
      var topDown : Float = 0.0;
      
      // Bottom-up: influence from lower shells
      if (i > 0) {
        bottomUp := shells[i - 1].coherence * propagationStrength * 0.3;
      };
      
      // Top-down: modulation from higher shells
      if (i < 10) {
        topDown := shells[i + 1].coherence * propagationStrength * 0.2;
      };
      
      adjustments[i] := bottomUp + topDown;
    };
    
    Array.freeze(adjustments)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // WEIGHT STATISTICS — Analysis functions
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type WeightStats = {
    mean : Float;
    variance : Float;
    max : Float;
    min : Float;
    sparsity : Float;  // Fraction of weights below threshold
  };
  
  public func computeWeightStats(weights : [var Float], threshold : Float) : WeightStats {
    let n = weights.size();
    if (n == 0) {
      return { mean = 0.0; variance = 0.0; max = 0.0; min = 0.0; sparsity = 0.0 };
    };
    
    var sum : Float = 0.0;
    var sumSq : Float = 0.0;
    var maxW : Float = weights[0];
    var minW : Float = weights[0];
    var belowThreshold : Nat = 0;
    
    for (i in Iter.range(0, n - 1)) {
      let w = weights[i];
      sum += w;
      sumSq += w * w;
      if (w > maxW) { maxW := w };
      if (w < minW) { minW := w };
      if (w < threshold) { belowThreshold += 1 };
    };
    
    let nFloat = Float.fromInt(n);
    let mean = sum / nFloat;
    let variance = (sumSq / nFloat) - (mean * mean);
    let sparsity = Float.fromInt(belowThreshold) / nFloat;
    
    { mean; variance; max = maxW; min = minW; sparsity }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HEBBIAN ASSEMBLY — Groups of co-active neurons
  // Detect and track cell assemblies that fire together
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type Assembly = {
    members : [Nat];          // Node indices in this assembly
    strength : Float;         // Average internal connection strength
    activationCount : Nat;    // How often this assembly has activated together
    lastActivation : Int;     // Beat of last co-activation
  };
  
  public func detectAssembly(
    weightMatrix : [[var Float]],
    threshold : Float
  ) : [Assembly] {
    // Simple assembly detection: find strongly connected clusters
    let assemblies = Buffer.Buffer<Assembly>(4);
    let visited = Array.init<Bool>(12, func(_ : Nat) : Bool { false });
    
    for (seed in Iter.range(0, 11)) {
      if (not visited[seed]) {
        let members = Buffer.Buffer<Nat>(4);
        members.add(seed);
        visited[seed] := true;
        
        // Find strongly connected neighbors
        for (j in Iter.range(0, 11)) {
          if (not visited[j] and weightMatrix[seed][j] > threshold) {
            members.add(j);
            visited[j] := true;
          };
        };
        
        if (members.size() >= 2) {
          // Calculate average internal strength
          var strengthSum : Float = 0.0;
          var count : Nat = 0;
          let memberArray = Buffer.toArray(members);
          
          for (m1 in memberArray.vals()) {
            for (m2 in memberArray.vals()) {
              if (m1 != m2) {
                strengthSum += weightMatrix[m1][m2];
                count += 1;
              };
            };
          };
          
          let avgStrength = if (count > 0) { strengthSum / Float.fromInt(count) } else { 0.0 };
          
          assemblies.add({
            members = memberArray;
            strength = avgStrength;
            activationCount = 1;
            lastActivation = 0;
          });
        };
      };
    };
    
    Buffer.toArray(assemblies)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE PLASTICITY TICK — Run all learning mechanisms for one heartbeat
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type PlasticityTickResult = {
    totalLtpEvents : Nat;
    totalLtdEvents : Nat;
    avgCoherence : Float;
    avgWeight : Float;
    shellCoherences : [Float];
  };
  
  public func runPlasticityTick(
    shells : [var Shell],
    weightMatrix : WeightMatrix,
    hzActivations : [Float],
    globalCoherence : Float,
    reward : Float,
    currentBeat : Int
  ) : PlasticityTickResult {
    var totalLtp : Nat = 0;
    var totalLtd : Nat = 0;
    var coherenceSum : Float = 0.0;
    var weightSum : Float = 0.0;
    let shellCoherences = Array.init<Float>(11, func(_ : Nat) : Float { 0.0 });
    
    // Update global weight matrix with Hebbian learning
    updateHebbianMatrix(weightMatrix, hzActivations, ETA_BASE, WEIGHT_DECAY);
    
    // Update eligibility traces
    updateAllEligibilityTraces(weightMatrix, hzActivations);
    
    // Apply reward signal if non-zero
    if (reward != 0.0) {
      applyRewardSignal(weightMatrix, reward, ETA_BASE);
    };
    
    // Update each shell
    for (i in Iter.range(0, 10)) {
      let result = updateShell(shells[i], hzActivations, globalCoherence, reward, currentBeat);
      
      // Apply results to shell (would need mutable shell in actual implementation)
      totalLtp += result.ltpEvents;
      totalLtd += result.ltdEvents;
      coherenceSum += result.newCoherence;
      weightSum += result.avgWeight;
      shellCoherences[i] := result.newCoherence;
    };
    
    // Cross-shell propagation
    let _ = crossShellPropagation(Array.freeze(shells), 0.1);
    
    {
      totalLtpEvents = totalLtp;
      totalLtdEvents = totalLtd;
      avgCoherence = coherenceSum / 11.0;
      avgWeight = weightSum / 11.0;
      shellCoherences = Array.freeze(shellCoherences);
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER: Exponential function approximation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func exp(x : Float) : Float {
    // Taylor series approximation for exp(x)
    // More accurate for small x
    if (x > 10.0) { return 22026.0 };  // Prevent overflow
    if (x < -10.0) { return 0.0 };
    
    var result : Float = 1.0;
    var term : Float = 1.0;
    
    for (n in Iter.range(1, 20)) {
      term := term * x / Float.fromInt(n);
      result += term;
    };
    
    result
  };

}
