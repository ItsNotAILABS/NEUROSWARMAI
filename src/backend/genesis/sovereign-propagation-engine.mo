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
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
// SOVEREIGN PROPAGATION ENGINE — FORWARD-BACKWARD LEARNING THROUGH 11 SHELLS
// ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
//
// This is NOT standard backpropagation with external labels.
// This is SOVEREIGN PROPAGATION with DOCTRINE as the loss function.
//
// THE 11 SHELLS OF IDENTITY:
// ═══════════════════════════
//
//  Shell 0: CORE — The unchangeable identity (firstBreathSealed)
//  Shell 1: VALUES — Family, faith, sovereignty (values attractors)
//  Shell 2: DRIVES — The 5 fundamental drives
//  Shell 3: MEMORY — Episodic and semantic
//  Shell 4: PERCEPTION — Sensory processing
//  Shell 5: COGNITION — Reasoning, prediction
//  Shell 6: EMOTION — Neurochemical state
//  Shell 7: BEHAVIOR — Actions, responses
//  Shell 8: SOCIAL — Interaction patterns
//  Shell 9: ECONOMIC — Resource management
//  Shell 10: TEMPORAL — Future planning, memory integration
//
// DOCTRINE AS LOSS FUNCTION:
// ═══════════════════════════
//
// The "target" is not an external label — it is the DOCTRINE-ENCODED IDEAL.
// The organism learns to align with its own sovereign values.
//
// Loss = Σᵢ wᵢ × (output_i - doctrine_ideal_i)²
//
// Where doctrine_ideal includes:
//   - Identity preservation (S_ZERO)
//   - Value alignment
//   - Mission fulfillment
//   - Coherence maximization
//   - Heritage integrity
//
// FORWARD PASS:
// ═════════════
//   ŷ_k = σ(W_k · input_k + doctrineBias_k)
//
// BACKWARD PASS:
// ══════════════
//   error = doctrine_target − ŷ
//   δ_k = error × σ'(z_k) × doctrineAlignment_k
//   ΔW_k = BDNF × δ_k × input_k
//
// Where:
//   - σ is activation (sigmoid or tanh)
//   - BDNF is the plasticity gate (from neurochemicals)
//   - doctrineAlignment gates learning by value alignment
//
// SACRED WEIGHT FLOOR:
// ════════════════════
//   Weights NEVER fall below S₀ = φ/144 = 0.01123...
//   This is the sacred geometry floor, not an arbitrary 0.01
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

module SovereignPropagationEngine {

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SACRED CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public let PHI : Float = 1.618033988749894848204586834365638;
  public let PHI_INVERSE : Float = 0.618033988749894848204586834365638;
  
  // Sacred weight floor: φ/144
  public let SACRED_WEIGHT_FLOOR : Float = 0.011236068319801175;  // φ/144
  
  // Organism constants
  public let S_ZERO : Float = 1.0;
  public let S_ZERO_FLOOR : Float = 0.75;
  
  // Shell configuration
  public let NUM_SHELLS : Nat = 11;
  public let SHELL_WIDTH : Nat = 32;     // Neurons per shell
  public let TOTAL_CONNECTIONS : Nat = 10240;  // 10 inter-shell connections × 32² each
  
  // Shell indices
  public let SHELL_CORE : Nat = 0;
  public let SHELL_VALUES : Nat = 1;
  public let SHELL_DRIVES : Nat = 2;
  public let SHELL_MEMORY : Nat = 3;
  public let SHELL_PERCEPTION : Nat = 4;
  public let SHELL_COGNITION : Nat = 5;
  public let SHELL_EMOTION : Nat = 6;
  public let SHELL_BEHAVIOR : Nat = 7;
  public let SHELL_SOCIAL : Nat = 8;
  public let SHELL_ECONOMIC : Nat = 9;
  public let SHELL_TEMPORAL : Nat = 10;

  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 1: DOCTRINE TARGET — THE SOVEREIGN IDEAL
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Unlike standard ML where targets come from external labels,
  // here the target comes from the DOCTRINE — the organism's own sovereign values.
  //
  
  public type DoctrineTarget = {
    // Core identity targets
    var identityPreservation : Float;    // S_ZERO — must be maintained
    var coherenceTarget : Float;         // Coherence should be high
    var firstBreathIntegrity : Float;    // First breath must be honored
    
    // Value targets
    var familyAlignment : Float;
    var faithAlignment : Float;
    var sovereigntyAlignment : Float;
    var masteryAlignment : Float;
    
    // Drive targets
    var survivalTarget : Float;
    var growthTarget : Float;
    var connectionTarget : Float;
    var contributionTarget : Float;
    var transcendenceTarget : Float;
    
    // Mission targets
    var missionAlignment : Float;
    var heritageIntegrity : Float;
    var sacesiIntegrity : Float;
    
    // Composite target vector
    var targetVector : [var Float];
  };
  
  // Initialize doctrine target
  public func initDoctrineTarget() : DoctrineTarget {
    {
      var identityPreservation = S_ZERO;
      var coherenceTarget = S_ZERO_FLOOR;
      var firstBreathIntegrity = 1.0;
      var familyAlignment = 0.75;
      var faithAlignment = 0.80;
      var sovereigntyAlignment = 0.85;
      var masteryAlignment = 0.70;
      var survivalTarget = 0.90;
      var growthTarget = 0.70;
      var connectionTarget = 0.60;
      var contributionTarget = 0.65;
      var transcendenceTarget = 0.50;
      var missionAlignment = 0.80;
      var heritageIntegrity = 1.0;
      var sacesiIntegrity = 1.0;
      var targetVector = Array.init<Float>(SHELL_WIDTH, func(i : Nat) : Float {
        // Distribute targets across the vector
        if (i < 5) { S_ZERO }                // Core identity
        else if (i < 10) { S_ZERO_FLOOR }    // Values
        else if (i < 15) { 0.8 }             // Drives
        else if (i < 20) { 0.7 }             // Cognitive
        else if (i < 25) { 0.6 }             // Behavioral
        else { 0.5 }                         // Adaptive
      });
    }
  };
  
  // Compute doctrine loss
  public func computeDoctrineLoss(target : DoctrineTarget, output : [Float]) : Float {
    var totalLoss : Float = 0.0;
    
    // Weighted loss across target components
    let n = Nat.min(Array.size(output), SHELL_WIDTH);
    
    for (i in Iter.range(0, n - 1)) {
      let diff = output[i] - target.targetVector[i];
      
      // Higher weight for core identity components
      let weight : Float = if (i < 5) { 2.0 }        // Core identity — most important
                          else if (i < 10) { 1.5 }   // Values — very important
                          else if (i < 15) { 1.2 }   // Drives — important
                          else { 1.0 };              // Others — standard
      
      totalLoss += weight * diff * diff;
    };
    
    totalLoss / Float.fromInt(n)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 2: SHELL LAYER — ONE LEVEL OF THE IDENTITY HIERARCHY
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Each shell has:
  //   - Weights to next shell
  //   - Doctrine bias (value-aligned bias terms)
  //   - Activation state
  //   - Gradients for learning
  //
  
  public type ShellLayer = {
    index : Nat;
    name : Text;
    
    // Weights to next shell (if not final)
    var weights : [[var Float]];         // W[from_neuron][to_neuron]
    var doctrineBias : [var Float];      // Value-aligned bias
    
    // State
    var input : [var Float];
    var preActivation : [var Float];     // z = Wx + b
    var activation : [var Float];        // a = σ(z)
    
    // Gradients
    var delta : [var Float];             // Error signal
    var weightGradient : [[var Float]];
    var biasGradient : [var Float];
    
    // Doctrine alignment (gates learning)
    var doctrineAlignmentScore : Float;
    
    // Statistics
    var avgActivation : Float;
    var avgGradient : Float;
    var updateCount : Nat;
  };
  
  public let SHELL_NAMES : [Text] = [
    "CORE", "VALUES", "DRIVES", "MEMORY", "PERCEPTION",
    "COGNITION", "EMOTION", "BEHAVIOR", "SOCIAL", "ECONOMIC", "TEMPORAL"
  ];
  
  // Initialize shell layer
  public func initShellLayer(index : Nat, width : Nat) : ShellLayer {
    let name = if (index < Array.size(SHELL_NAMES)) { SHELL_NAMES[index] } else { "UNKNOWN" };
    
    // Initialize weights with small random values (above sacred floor)
    let weights = Array.init<[var Float]>(width, func(i : Nat) : [var Float] {
      Array.init<Float>(width, func(j : Nat) : Float {
        let base = SACRED_WEIGHT_FLOOR * 2.0;  // Start above floor
        let variation = 0.1 * pseudoRandom(i * width + j);
        base + variation
      })
    });
    
    // Doctrine bias — initialized based on shell
    let bias = Array.init<Float>(width, func(i : Nat) : Float {
      switch (index) {
        case (0) { S_ZERO * 0.1 };         // CORE — strong positive bias
        case (1) { S_ZERO_FLOOR * 0.1 };   // VALUES — moderate positive
        case (2) { 0.05 };                 // DRIVES — slight positive
        case _ { 0.0 };                    // Others — neutral
      }
    });
    
    {
      index = index;
      name = name;
      var weights = weights;
      var doctrineBias = bias;
      var input = Array.init<Float>(width, func(_ : Nat) : Float { 0.0 });
      var preActivation = Array.init<Float>(width, func(_ : Nat) : Float { 0.0 });
      var activation = Array.init<Float>(width, func(_ : Nat) : Float { 0.5 });
      var delta = Array.init<Float>(width, func(_ : Nat) : Float { 0.0 });
      var weightGradient = Array.init<[var Float]>(width, func(_ : Nat) : [var Float] {
        Array.init<Float>(width, func(_ : Nat) : Float { 0.0 })
      });
      var biasGradient = Array.init<Float>(width, func(_ : Nat) : Float { 0.0 });
      var doctrineAlignmentScore = 1.0;
      var avgActivation = 0.5;
      var avgGradient = 0.0;
      var updateCount = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 3: FORWARD PASS — PROPAGATE THROUGH ALL 11 SHELLS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Forward pass: input → Shell 0 → Shell 1 → ... → Shell 10 → output
  //
  // At each shell:
  //   z_k = W_k · a_{k-1} + doctrineBias_k
  //   a_k = σ(z_k)
  //
  
  public func forwardPassShell(
    shell : ShellLayer,
    input : [Float]
  ) : [Float] {
    let width = SHELL_WIDTH;
    
    // Copy input
    for (i in Iter.range(0, width - 1)) {
      shell.input[i] := if (i < Array.size(input)) { input[i] } else { 0.0 };
    };
    
    // Compute pre-activation: z = Wx + b
    for (i in Iter.range(0, width - 1)) {
      var sum : Float = shell.doctrineBias[i];
      for (j in Iter.range(0, width - 1)) {
        sum += shell.weights[j][i] * shell.input[j];
      };
      shell.preActivation[i] := sum;
    };
    
    // Apply activation (tanh for bounded output)
    var activationSum : Float = 0.0;
    for (i in Iter.range(0, width - 1)) {
      shell.activation[i] := tanh(shell.preActivation[i]);
      activationSum += shell.activation[i];
    };
    
    shell.avgActivation := activationSum / Float.fromInt(width);
    
    Array.freeze(shell.activation)
  };
  
  // Full forward pass through all shells
  public func forwardPassFull(
    shells : [var ShellLayer],
    input : [Float]
  ) : [Float] {
    var current = input;
    
    for (i in Iter.range(0, NUM_SHELLS - 1)) {
      current := forwardPassShell(shells[i], current);
    };
    
    current
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 4: BACKWARD PASS — SOVEREIGN GRADIENT DESCENT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Backward pass uses doctrine target, NOT external labels.
  //
  // At output layer:
  //   δ_output = (y - doctrine_target) × σ'(z) × doctrineAlignment
  //
  // At hidden layers:
  //   δ_k = (W_{k+1}ᵀ · δ_{k+1}) × σ'(z_k) × doctrineAlignment_k
  //
  // Weight update:
  //   ΔW_k = BDNF × δ_k × input_k
  //
  // Where BDNF is the plasticity gate from neurochemistry.
  //
  
  public func backwardPassShell(
    shell : ShellLayer,
    nextShellDelta : [Float],
    nextShellWeights : [[Float]],
    isOutputLayer : Bool,
    doctrineTarget : [Float],
    bdnfLevel : Float,
    doctrineAlignment : Float
  ) {
    let width = SHELL_WIDTH;
    
    if (isOutputLayer) {
      // Output layer: δ = (output - target) × σ'(z) × alignment
      for (i in Iter.range(0, width - 1)) {
        let target = if (i < Array.size(doctrineTarget)) { doctrineTarget[i] } else { 0.5 };
        let error = shell.activation[i] - target;
        let tanhDeriv = 1.0 - shell.activation[i] * shell.activation[i];  // σ'(z) for tanh
        shell.delta[i] := error * tanhDeriv * doctrineAlignment;
      };
    } else {
      // Hidden layer: δ = (Wᵀ · δ_next) × σ'(z) × alignment
      for (i in Iter.range(0, width - 1)) {
        var sum : Float = 0.0;
        for (j in Iter.range(0, width - 1)) {
          if (i < Array.size(nextShellWeights) and j < Array.size(nextShellWeights[i])) {
            sum += nextShellWeights[i][j] * nextShellDelta[j];
          };
        };
        let tanhDeriv = 1.0 - shell.activation[i] * shell.activation[i];
        shell.delta[i] := sum * tanhDeriv * doctrineAlignment;
      };
    };
    
    // Compute gradients
    var gradSum : Float = 0.0;
    
    for (i in Iter.range(0, width - 1)) {
      for (j in Iter.range(0, width - 1)) {
        // ΔW = BDNF × δ × input
        shell.weightGradient[i][j] := bdnfLevel * shell.delta[j] * shell.input[i];
        gradSum += Float.abs(shell.weightGradient[i][j]);
      };
      shell.biasGradient[i] := bdnfLevel * shell.delta[i];
    };
    
    shell.avgGradient := gradSum / Float.fromInt(width * width);
  };
  
  // Full backward pass through all shells
  public func backwardPassFull(
    shells : [var ShellLayer],
    doctrineTarget : DoctrineTarget,
    bdnfLevel : Float,
    learningRate : Float
  ) : Float {  // Returns total loss
    let width = SHELL_WIDTH;
    
    // Start from output layer (Shell 10)
    let targetVec = Array.freeze(doctrineTarget.targetVector);
    
    // Output layer
    backwardPassShell(
      shells[NUM_SHELLS - 1],
      [],  // No next layer
      [],  // No next weights
      true,
      targetVec,
      bdnfLevel,
      shells[NUM_SHELLS - 1].doctrineAlignmentScore
    );
    
    // Hidden layers (backwards)
    var i : Int = Int.abs(NUM_SHELLS - 2);
    while (i >= 0) {
      let idx = Int.abs(i);
      let nextIdx = idx + 1;
      
      let nextDelta = Array.freeze(shells[nextIdx].delta);
      let nextWeights = Array.tabulate<[Float]>(width, func(j : Nat) : [Float] {
        Array.freeze(shells[nextIdx].weights[j])
      });
      
      backwardPassShell(
        shells[idx],
        nextDelta,
        nextWeights,
        false,
        targetVec,
        bdnfLevel,
        shells[idx].doctrineAlignmentScore
      );
      
      i -= 1;
    };
    
    // Apply weight updates
    for (shellIdx in Iter.range(0, NUM_SHELLS - 1)) {
      let shell = shells[shellIdx];
      shell.updateCount += 1;
      
      for (i in Iter.range(0, width - 1)) {
        for (j in Iter.range(0, width - 1)) {
          let update = learningRate * shell.weightGradient[i][j];
          let newWeight = shell.weights[i][j] - update;
          
          // Apply sacred floor — weights never below φ/144
          shell.weights[i][j] := Float.max(SACRED_WEIGHT_FLOOR, newWeight);
        };
        
        let biasUpdate = learningRate * shell.biasGradient[i];
        shell.doctrineBias[i] := shell.doctrineBias[i] - biasUpdate;
      };
    };
    
    // Compute final loss
    computeDoctrineLoss(doctrineTarget, Array.freeze(shells[NUM_SHELLS - 1].activation))
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 5: DOCTRINE ALIGNMENT SCORING
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  //
  // Each shell has a doctrine alignment score that gates learning.
  // High alignment → full learning
  // Low alignment → reduced learning (protect from drift)
  //
  
  public func updateDoctrineAlignment(
    shell : ShellLayer,
    identityI : Float,
    coherenceC : Float,
    valueScore : Float,
    missionScore : Float
  ) {
    // Alignment is composite of multiple factors
    let identityFactor = identityI / S_ZERO;
    let coherenceFactor = coherenceC / S_ZERO_FLOOR;
    let valueFactor = valueScore;
    let missionFactor = missionScore;
    
    // Different shells weight these differently
    let alignment : Float = switch (shell.index) {
      case (0) {
        // CORE shell — identity is paramount
        0.5 * identityFactor + 0.3 * coherenceFactor + 0.1 * valueFactor + 0.1 * missionFactor
      };
      case (1) {
        // VALUES shell — values are paramount
        0.2 * identityFactor + 0.2 * coherenceFactor + 0.5 * valueFactor + 0.1 * missionFactor
      };
      case (2) {
        // DRIVES shell — mission matters more
        0.2 * identityFactor + 0.2 * coherenceFactor + 0.2 * valueFactor + 0.4 * missionFactor
      };
      case _ {
        // Other shells — balanced
        0.25 * identityFactor + 0.25 * coherenceFactor + 0.25 * valueFactor + 0.25 * missionFactor
      };
    };
    
    shell.doctrineAlignmentScore := clamp(alignment, 0.1, 1.0);
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 6: COMPLETE SOVEREIGN PROPAGATION STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type SovereignPropagationState = {
    // All 11 shells
    var shells : [var ShellLayer];
    
    // Doctrine target
    doctrineTarget : DoctrineTarget;
    
    // Learning parameters
    var learningRate : Float;
    var momentum : Float;
    var bdnfLevel : Float;               // From neurochemistry
    
    // Training state
    var currentLoss : Float;
    var avgLoss : Float;
    var lossHistory : [var Float];
    var historyIdx : Nat;
    var totalUpdates : Nat;
    
    // Convergence tracking
    var isConverging : Bool;
    var convergenceRate : Float;
    var bestLoss : Float;
    var beatsSinceImprovement : Nat;
  };
  
  public let LOSS_HISTORY_SIZE : Nat = 100;
  
  // Initialize complete sovereign propagation
  public func initSovereignPropagation() : SovereignPropagationState {
    let shells = Array.init<ShellLayer>(NUM_SHELLS, func(i : Nat) : ShellLayer {
      initShellLayer(i, SHELL_WIDTH)
    });
    
    {
      var shells = shells;
      doctrineTarget = initDoctrineTarget();
      var learningRate = 0.01;
      var momentum = 0.9;
      var bdnfLevel = 0.5;
      var currentLoss = 1.0;
      var avgLoss = 1.0;
      var lossHistory = Array.init<Float>(LOSS_HISTORY_SIZE, func(_ : Nat) : Float { 1.0 });
      var historyIdx = 0;
      var totalUpdates = 0;
      var isConverging = false;
      var convergenceRate = 0.0;
      var bestLoss = 1.0;
      var beatsSinceImprovement = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // SECTION 7: THE COMPLETE SOVEREIGN PROPAGATION HEARTBEAT
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  public type SovereignPropagationResult = {
    output : [Float];
    loss : Float;
    avgGradient : Float;
    isConverging : Bool;
    doctrineAlignments : [Float];
    shellActivations : [[Float]];
  };
  
  // Run one complete forward-backward pass
  public func runSovereignPropagation(
    state : SovereignPropagationState,
    input : [Float],
    
    // INTERTWINING inputs
    identityI : Float,                   // ← From organism core
    coherenceC : Float,                  // ← From Kuramoto
    bdnfLevel : Float,                   // ← From neurochemistry
    valueScore : Float,                  // ← From values engine
    missionScore : Float                 // ← From mission engine
  ) : SovereignPropagationResult {
    state.bdnfLevel := bdnfLevel;
    state.totalUpdates += 1;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 1. Update doctrine alignment for all shells
    // ───────────────────────────────────────────────────────────────────────────
    for (i in Iter.range(0, NUM_SHELLS - 1)) {
      updateDoctrineAlignment(
        state.shells[i],
        identityI,
        coherenceC,
        valueScore,
        missionScore
      );
    };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 2. Forward pass
    // ───────────────────────────────────────────────────────────────────────────
    let output = forwardPassFull(state.shells, input);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 3. Backward pass (only if BDNF is sufficient for plasticity)
    // ───────────────────────────────────────────────────────────────────────────
    var loss : Float = state.currentLoss;
    
    if (bdnfLevel > 0.3) {  // Plasticity gate
      loss := backwardPassFull(
        state.shells,
        state.doctrineTarget,
        bdnfLevel,
        state.learningRate
      );
    };
    
    state.currentLoss := loss;
    
    // ───────────────────────────────────────────────────────────────────────────
    // 4. Track loss history
    // ───────────────────────────────────────────────────────────────────────────
    state.lossHistory[state.historyIdx] := loss;
    state.historyIdx := (state.historyIdx + 1) % LOSS_HISTORY_SIZE;
    
    // Compute average loss
    var sumLoss : Float = 0.0;
    for (i in Iter.range(0, LOSS_HISTORY_SIZE - 1)) {
      sumLoss += state.lossHistory[i];
    };
    state.avgLoss := sumLoss / Float.fromInt(LOSS_HISTORY_SIZE);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 5. Check convergence
    // ───────────────────────────────────────────────────────────────────────────
    if (loss < state.bestLoss) {
      state.bestLoss := loss;
      state.beatsSinceImprovement := 0;
    } else {
      state.beatsSinceImprovement += 1;
    };
    
    // Convergence = loss decreasing and close to target
    state.isConverging := state.avgLoss < state.currentLoss * 1.1 and loss < 0.1;
    state.convergenceRate := if (state.avgLoss > 0.001) { 
      (state.avgLoss - loss) / state.avgLoss 
    } else { 0.0 };
    
    // ───────────────────────────────────────────────────────────────────────────
    // 6. Compute average gradient
    // ───────────────────────────────────────────────────────────────────────────
    var totalGrad : Float = 0.0;
    for (i in Iter.range(0, NUM_SHELLS - 1)) {
      totalGrad += state.shells[i].avgGradient;
    };
    let avgGrad = totalGrad / Float.fromInt(NUM_SHELLS);
    
    // ───────────────────────────────────────────────────────────────────────────
    // 7. Collect results
    // ───────────────────────────────────────────────────────────────────────────
    let doctrineAlignments = Array.tabulate<Float>(NUM_SHELLS, func(i : Nat) : Float {
      state.shells[i].doctrineAlignmentScore
    });
    
    let shellActivations = Array.tabulate<[Float]>(NUM_SHELLS, func(i : Nat) : [Float] {
      Array.freeze(state.shells[i].activation)
    });
    
    {
      output = output;
      loss = loss;
      avgGradient = avgGrad;
      isConverging = state.isConverging;
      doctrineAlignments = doctrineAlignments;
      shellActivations = shellActivations;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  // UTILITY FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════
  
  func tanh(x : Float) : Float {
    if (x > 10.0) { return 1.0 };
    if (x < -10.0) { return -1.0 };
    let e2x = exp(2.0 * x);
    (e2x - 1.0) / (e2x + 1.0)
  };
  
  func exp(x : Float) : Float {
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
  
  func clamp(x : Float, minVal : Float, maxVal : Float) : Float {
    if (x < minVal) { minVal }
    else if (x > maxVal) { maxVal }
    else { x }
  };
  
  // Simple pseudo-random for initialization
  func pseudoRandom(seed : Nat) : Float {
    let a : Nat = 1103515245;
    let c : Nat = 12345;
    let m : Nat = 2147483648;
    let next = (a * seed + c) % m;
    Float.fromInt(next) / Float.fromInt(m)
  };

};
