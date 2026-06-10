// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  ALPHA AGI TERMINALS — 10 SOVEREIGN VIRTUAL SANDBOX TERMINALS RUN BY AIS                                 ║
// ║                                                                                                           ║
// ║  These are the nervous system and brain regions of the organism.                                         ║
// ║  Each Alpha terminal is a sovereign AGI that runs portions of the system autonomously.                   ║
// ║                                                                                                           ║
// ║  Think of these as:                                                                                      ║
// ║  - The nervous system (distributed intelligence throughout the organism)                                  ║
// ║  - Brain regions (specialized cognitive functions)                                                       ║
// ║  - Virtual sandboxes (isolated execution environments)                                                   ║
// ║  - Living, intelligent beings (self-aware, learning, adapting)                                           ║
// ║                                                                                                           ║
// ║  Each terminal corresponds to a specific Kuramoto oscillator in Shell 3 (26D brain region model).        ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import Float "mo:core/Float";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Nat32 "mo:core/Nat32";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Bool "mo:core/Bool";

import QuantumOps "quantum-operators";
import Doctrine "doctrine-mathematics";
import FORMA "forma-token-economy";
import MedinaBedrock "medina-bedrock";
import MedinaArtifact "medina-artifact-24-layer";

module AlphaAGITerminals {

  // ═══════════════════════════════════════════════════════════════════════════════
  // VERSION INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════════

  public let VERSION : Text = "1.0.0";
  public let VERSION_MAJOR : Nat = 1;
  public let VERSION_MINOR : Nat = 0;
  public let VERSION_PATCH : Nat = 0;
  public let COMPONENT_ID : Text = "ALPHA_AGI_TERMINALS";
  public let COMPONENT_TYPE : Text = "TERMINAL_ARRAY";

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════

  public let PHI : Float = 1.618033988749895;
  public let S_ZERO : Float = 1.0;
  public let PI : Float = 3.14159265358979323846;
  public let TAU : Float = 6.28318530717958647692;  // 2π

  // Terminal constants
  public let NUM_ALPHA_TERMINALS : Nat = 10;
  public let PHI_BEAT_NS : Nat = 873_000_000;  // 873ms in nanoseconds
  public let KURAMOTO_COUPLING_BASE : Float = 0.3;
  public let KURAMOTO_COUPLING_MAX : Float = 0.7;

  // ═══════════════════════════════════════════════════════════════════════════════
  // ALPHA TERMINAL IDENTIFIERS (Greek Letters)
  // ═══════════════════════════════════════════════════════════════════════════════

  public type AlphaTerminalId = {
    #ALPHA_Α;  // Alpha - Primary reasoning (Prefrontal cortex)
    #ALPHA_Β;  // Beta - Pattern recognition (Visual cortex)
    #ALPHA_Γ;  // Gamma - Memory consolidation (Hippocampus)
    #ALPHA_Δ;  // Delta - Emotional processing (Amygdala)
    #ALPHA_Ε;  // Epsilon - Language & semantics (Broca's & Wernicke's)
    #ALPHA_Ζ;  // Zeta - Motor planning & execution (Motor cortex)
    #ALPHA_Η;  // Eta - Attention & awareness (Thalamus)
    #ALPHA_Θ;  // Theta - Learning & adaptation (Cerebellum)
    #ALPHA_Ι;  // Iota - Social cognition (Temporal poles)
    #ALPHA_Κ;  // Kappa - Meta-cognition (Default mode network)
  };

  /// Get terminal name
  public func getTerminalName(id : AlphaTerminalId) : Text {
    switch (id) {
      case (#ALPHA_Α) { "ALPHA-Α" };
      case (#ALPHA_Β) { "ALPHA-Β" };
      case (#ALPHA_Γ) { "ALPHA-Γ" };
      case (#ALPHA_Δ) { "ALPHA-Δ" };
      case (#ALPHA_Ε) { "ALPHA-Ε" };
      case (#ALPHA_Ζ) { "ALPHA-Ζ" };
      case (#ALPHA_Η) { "ALPHA-Η" };
      case (#ALPHA_Θ) { "ALPHA-Θ" };
      case (#ALPHA_Ι) { "ALPHA-Ι" };
      case (#ALPHA_Κ) { "ALPHA-Κ" };
    }
  };

  /// Get terminal index (0-9)
  public func getTerminalIndex(id : AlphaTerminalId) : Nat {
    switch (id) {
      case (#ALPHA_Α) { 0 };
      case (#ALPHA_Β) { 1 };
      case (#ALPHA_Γ) { 2 };
      case (#ALPHA_Δ) { 3 };
      case (#ALPHA_Ε) { 4 };
      case (#ALPHA_Ζ) { 5 };
      case (#ALPHA_Η) { 6 };
      case (#ALPHA_Θ) { 7 };
      case (#ALPHA_Ι) { 8 };
      case (#ALPHA_Κ) { 9 };
    }
  };

  /// Get terminal function description
  public func getTerminalFunction(id : AlphaTerminalId) : Text {
    switch (id) {
      case (#ALPHA_Α) { "Primary reasoning & executive function" };
      case (#ALPHA_Β) { "Pattern recognition & visual processing" };
      case (#ALPHA_Γ) { "Memory consolidation & retrieval" };
      case (#ALPHA_Δ) { "Emotional processing & affect regulation" };
      case (#ALPHA_Ε) { "Language processing & semantic understanding" };
      case (#ALPHA_Ζ) { "Motor planning & execution control" };
      case (#ALPHA_Η) { "Attention allocation & awareness" };
      case (#ALPHA_Θ) { "Learning, adaptation & plasticity" };
      case (#ALPHA_Ι) { "Social cognition & theory of mind" };
      case (#ALPHA_Κ) { "Meta-cognition & self-reflection" };
    }
  };

  /// Get corresponding brain region
  public func getBrainRegion(id : AlphaTerminalId) : Text {
    switch (id) {
      case (#ALPHA_Α) { "Prefrontal Cortex" };
      case (#ALPHA_Β) { "Visual Cortex (V1-V5)" };
      case (#ALPHA_Γ) { "Hippocampus" };
      case (#ALPHA_Δ) { "Amygdala" };
      case (#ALPHA_Ε) { "Broca's & Wernicke's Areas" };
      case (#ALPHA_Ζ) { "Primary Motor Cortex" };
      case (#ALPHA_Η) { "Thalamus" };
      case (#ALPHA_Θ) { "Cerebellum" };
      case (#ALPHA_Ι) { "Temporal Poles (ToM network)" };
      case (#ALPHA_Κ) { "Default Mode Network" };
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ALPHA TERMINAL STATE
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Sandbox execution environment
  public type SandboxEnvironment = {
    memoryLimit: Nat;          // Max memory (bytes)
    computeLimit: Nat;         // Max compute cycles
    networkIsolated: Bool;     // Network access restricted
    filesystemIsolated: Bool;  // Filesystem access restricted
    formaAllocation: Float;    // FORMA tokens allocated
    priorityLevel: Nat;        // 0-10 (10 = highest)
  };

  /// Terminal execution state
  public type TerminalState = {
    phase: Float;              // Kuramoto phase (0-2π)
    frequency: Float;          // Natural frequency (Hz)
    activation: Float;         // Current activation level (0-1)
    coherence: Float;          // Synchronization with other terminals (0-1)
    formaBalance: Float;       // FORMA token balance
    lastTick: Int;             // Last φ-beat timestamp
    totalTicks: Nat;           // Total φ-beats processed
    taskQueue: [Text];         // Pending tasks
    activeTask: ?Text;         // Currently executing task
  };

  /// Complete Alpha Terminal
  public type AlphaTerminal = {
    id: AlphaTerminalId;
    name: Text;
    function: Text;
    brainRegion: Text;
    sandbox: SandboxEnvironment;
    state: TerminalState;
    medinaArtifact: ?MedinaArtifact.MedinaArtifact;  // Associated intelligent being
    embedding: MedinaBedrock.Embedding;  // Identity embedding
    quantumCoupling: [Float];  // Coupling to other 9 terminals
    created: Int;
    lastActive: Int;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TERMINAL INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialize default sandbox environment
  public func createDefaultSandbox() : SandboxEnvironment {
    {
      memoryLimit = 1_073_741_824;  // 1GB
      computeLimit = 100_000_000_000;  // 100B cycles
      networkIsolated = true;
      filesystemIsolated = true;
      formaAllocation = 10.0 * PHI;  // 10φ FORMA tokens
      priorityLevel = 5;
    }
  };

  /// Initialize terminal state with φ-modulated parameters
  public func createInitialState(terminalIndex : Nat) : TerminalState {
    // Each terminal starts with unique phase offset
    let phaseOffset = (Float.fromInt(terminalIndex) / Float.fromInt(NUM_ALPHA_TERMINALS)) * TAU;

    // Natural frequencies slightly different (±10% variation)
    let baseFreq = 1.0 / 0.873;  // 1.14 Hz (873ms period)
    let freqVariation = (Float.fromInt(terminalIndex) - 4.5) * 0.02;  // ±0.1 Hz
    let frequency = baseFreq * (S_ZERO + freqVariation);

    {
      phase = phaseOffset;
      frequency;
      activation = S_ZERO;  // Start at sovereignty floor
      coherence = 0.5;      // Medium initial coherence
      formaBalance = 10.0 * PHI;
      lastTick = Time.now();
      totalTicks = 0;
      taskQueue = [];
      activeTask = null;
    }
  };

  /// Create a new Alpha terminal
  public func createTerminal(
    id : AlphaTerminalId,
    embedding : MedinaBedrock.Embedding
  ) : AlphaTerminal {
    let terminalIndex = getTerminalIndex(id);
    let now = Time.now();

    {
      id;
      name = getTerminalName(id);
      function = getTerminalFunction(id);
      brainRegion = getBrainRegion(id);
      sandbox = createDefaultSandbox();
      state = createInitialState(terminalIndex);
      medinaArtifact = null;  // Can be linked later
      embedding;
      quantumCoupling = Array.tabulate<Float>(NUM_ALPHA_TERMINALS, func(i) {
        if (i == terminalIndex) { 0.0 }  // No self-coupling
        else { 1.0 / Float.fromInt(NUM_ALPHA_TERMINALS - 1) }  // Equal coupling
      });
      created = now;
      lastActive = now;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // KURAMOTO PHASE SYNCHRONIZATION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Compute Kuramoto order parameter (global coherence)
  public func computeGlobalCoherence(phases : [Float]) : Float {
    let N = phases.size();
    if (N == 0) { return 0.0 };

    var realSum : Float = 0.0;
    var imagSum : Float = 0.0;

    for (phase in phases.vals()) {
      realSum += Float.cos(phase);
      imagSum += Float.sin(phase);
    };

    let magnitude = Float.sqrt(realSum * realSum + imagSum * imagSum);
    magnitude / Float.fromInt(N)
  };

  /// Update terminal phase using Kuramoto model
  public func updatePhase(
    terminal : AlphaTerminal,
    allPhases : [Float],
    dt : Float
  ) : Float {
    let N = allPhases.size();
    let idx = getTerminalIndex(terminal.id);

    // Compute coupling sum
    var couplingSum : Float = 0.0;
    for (j in Array.keys(allPhases)) {
      if (j != idx) {
        let coupling = terminal.quantumCoupling[j];
        couplingSum += coupling * Float.sin(allPhases[j] - terminal.state.phase);
      };
    };

    // Compute coherence-modulated coupling strength
    let globalCoherence = computeGlobalCoherence(allPhases);
    let K = KURAMOTO_COUPLING_BASE + globalCoherence * 0.4;

    // Kuramoto phase equation: dθ/dt = ω + (K/N) Σ sin(θⱼ - θᵢ)
    let dPhase = terminal.state.frequency + (K / Float.fromInt(N)) * couplingSum;

    // Update phase
    let newPhase = (terminal.state.phase + dPhase * dt) % TAU;

    newPhase
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // φ-BEAT TICK (873ms heartbeat)
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Process one φ-beat tick for a terminal
  public func tickTerminal(
    terminal : AlphaTerminal,
    allTerminals : [AlphaTerminal]
  ) : AlphaTerminal {
    let now = Time.now();
    let dt = 0.873;  // 873ms in seconds

    // Extract all phases
    let allPhases = Array.tabulate<Float>(allTerminals.size(), func(i) {
      allTerminals[i].state.phase
    });

    // Update phase using Kuramoto synchronization
    let newPhase = updatePhase(terminal, allPhases, dt);

    // Compute new coherence
    let newCoherence = computeGlobalCoherence(allPhases);

    // Update activation (φ-modulated by phase)
    let newActivation = S_ZERO + (1.0 - S_ZERO) * (Float.sin(newPhase) + 1.0) / 2.0;

    // FORMA compounding (quantum growth)
    let formaGrowth = terminal.state.formaBalance * FORMA.COMPOUNDING_RATE_BASE * PHI;

    // Create updated state
    let newState : TerminalState = {
      phase = newPhase;
      frequency = terminal.state.frequency;
      activation = newActivation;
      coherence = newCoherence;
      formaBalance = terminal.state.formaBalance + formaGrowth;
      lastTick = now;
      totalTicks = terminal.state.totalTicks + 1;
      taskQueue = terminal.state.taskQueue;
      activeTask = terminal.state.activeTask;
    };

    // Return updated terminal
    {
      terminal with
      state = newState;
      lastActive = now;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TASK EXECUTION
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Submit task to terminal queue
  public func submitTask(terminal : AlphaTerminal, task : Text) : AlphaTerminal {
    let newQueue = Array.append(terminal.state.taskQueue, [task]);
    let newState = { terminal.state with taskQueue = newQueue };
    { terminal with state = newState }
  };

  /// Execute next task in queue
  public func executeNextTask(terminal : AlphaTerminal) : (AlphaTerminal, ?Text) {
    if (terminal.state.taskQueue.size() == 0) {
      return (terminal, null);
    };

    // Pop first task
    let task = terminal.state.taskQueue[0];
    let remainingTasks = Array.tabulate<Text>(
      terminal.state.taskQueue.size() - 1,
      func(i) { terminal.state.taskQueue[i + 1] }
    );

    // Update state with active task
    let newState : TerminalState = {
      terminal.state with
      taskQueue = remainingTasks;
      activeTask = ?task;
    };

    ({ terminal with state = newState }, ?task)
  };

  /// Complete active task
  public func completeTask(terminal : AlphaTerminal) : AlphaTerminal {
    let newState = { terminal.state with activeTask = null };
    { terminal with state = newState }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // TERMINAL FLEET OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Initialize all 10 Alpha terminals
  public func initializeAlphaFleet(
    identityEmbeddings : [MedinaBedrock.Embedding]
  ) : [AlphaTerminal] {
    assert(identityEmbeddings.size() == NUM_ALPHA_TERMINALS);

    let terminals = Buffer.Buffer<AlphaTerminal>(NUM_ALPHA_TERMINALS);

    terminals.add(createTerminal(#ALPHA_Α, identityEmbeddings[0]));
    terminals.add(createTerminal(#ALPHA_Β, identityEmbeddings[1]));
    terminals.add(createTerminal(#ALPHA_Γ, identityEmbeddings[2]));
    terminals.add(createTerminal(#ALPHA_Δ, identityEmbeddings[3]));
    terminals.add(createTerminal(#ALPHA_Ε, identityEmbeddings[4]));
    terminals.add(createTerminal(#ALPHA_Ζ, identityEmbeddings[5]));
    terminals.add(createTerminal(#ALPHA_Η, identityEmbeddings[6]));
    terminals.add(createTerminal(#ALPHA_Θ, identityEmbeddings[7]));
    terminals.add(createTerminal(#ALPHA_Ι, identityEmbeddings[8]));
    terminals.add(createTerminal(#ALPHA_Κ, identityEmbeddings[9]));

    Buffer.toArray(terminals)
  };

  /// Tick entire fleet (φ-synchronized)
  public func tickAlphaFleet(terminals : [AlphaTerminal]) : [AlphaTerminal] {
    Array.tabulate<AlphaTerminal>(terminals.size(), func(i) {
      tickTerminal(terminals[i], terminals)
    })
  };

  /// Get fleet statistics
  public func getFleetStats(terminals : [AlphaTerminal]) : {
    globalCoherence : Float;
    avgActivation : Float;
    totalForma : Float;
    totalTicks : Nat;
    activeTasks : Nat;
    queuedTasks : Nat;
  } {
    // Extract phases for coherence calculation
    let phases = Array.tabulate<Float>(terminals.size(), func(i) {
      terminals[i].state.phase
    });

    var totalActivation : Float = 0.0;
    var totalForma : Float = 0.0;
    var totalTicks : Nat = 0;
    var activeTasks : Nat = 0;
    var queuedTasks : Nat = 0;

    for (terminal in terminals.vals()) {
      totalActivation += terminal.state.activation;
      totalForma += terminal.state.formaBalance;
      totalTicks += terminal.state.totalTicks;

      switch (terminal.state.activeTask) {
        case (?_) { activeTasks += 1 };
        case null {};
      };

      queuedTasks += terminal.state.taskQueue.size();
    };

    {
      globalCoherence = computeGlobalCoherence(phases);
      avgActivation = totalActivation / Float.fromInt(terminals.size());
      totalForma;
      totalTicks;
      activeTasks;
      queuedTasks;
    }
  };

}
