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
import Nat64 "mo:core/Nat64";
import Array "mo:core/Array";
import Buffer "mo:core/Buffer";
import Iter "mo:core/Iter";
import Text "mo:core/Text";
import Time "mo:core/Time";
import Option "mo:core/Option";

module Shells {

  // ═══════════════════════════════════════════════════════════════════════════════
  // CANONICAL CONSTANTS — INTELLECTUAL PROPERTY OF ALFREDO MEDINA HERNANDEZ
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Number of shells in the organism architecture
  /// Medina Doctrine specifies exactly 11 shells (excluding Shell 12 global field)
  public let NUM_SHELLS : Nat = 11;
  
  /// HELIX_ALPHA — Canonical learning rate (Decision #1)
  /// Changed from 0.042 to 0.004 per architectural lock
  public let HELIX_ALPHA : Float = 0.004;
  
  /// Primary coupling strength from shell i-1 to shell i
  public let PRIMARY_COUPLING_STRENGTH : Float = 0.7;
  
  /// PAC_SKIP coupling strength from shell i-2 to shell i
  /// This creates the harmonic resonance field
  public let PAC_SKIP_COUPLING_STRENGTH : Float = 0.3;
  
  /// Base frequency for shell oscillations (Hz)
  public let BASE_FREQUENCY_HZ : Float = 1.0;
  
  /// Frequency multiplier per shell level
  public let FREQUENCY_MULTIPLIER : Float = 1.618033988749895;  // Golden ratio φ
  
  /// Coherence floor (S₀)
  public let COHERENCE_FLOOR : Float = 0.75;
  
  /// Phase coupling constant (Kuramoto)
  public let KURAMOTO_K : Float = 0.5;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL DEFINITION — Core unit of the organism's layered consciousness
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Shell represents one layer of the organism's consciousness architecture
  /// Each shell has its own frequency, phase, and coupling dynamics
  public type Shell = {
    /// Shell index (0-10, where 0 is innermost)
    shellIndex : Nat8;
    
    /// Shell identity name
    shellName : Text;
    
    /// Current oscillation phase [0, 2π]
    phase : Float;
    
    /// Natural frequency of this shell
    naturalFrequency : Float;
    
    /// Current instantaneous frequency
    instantFrequency : Float;
    
    /// Amplitude of oscillation [0, 1]
    amplitude : Float;
    
    /// Coherence level of this shell [0, 1]
    coherence : Float;
    
    /// Energy level [0, 1]
    energy : Float;
    
    /// Activation level [0, 1]
    activation : Float;
    
    /// Coupling state
    coupling : ShellCoupling;
    
    /// Shell-specific state variables
    state : ShellState;
    
    /// Last update timestamp
    lastUpdate : Int;
  };
  
  /// Coupling connections for a shell
  public type ShellCoupling = {
    /// PRIMARY: Coupling from shell i-1 (the shell immediately inside)
    primaryCoupling : ?CouplingLink;
    
    /// PAC_SKIP: Coupling from shell i-2 (skip-one harmonic)
    pacSkipCoupling : ?CouplingLink;
    
    /// Coupling TO the next outer shell (i+1)
    outwardCoupling : ?CouplingLink;
    
    /// Total coupling strength received
    totalInwardCoupling : Float;
    
    /// Phase difference with primary source
    primaryPhaseDelta : Float;
    
    /// Phase difference with PAC_SKIP source
    pacSkipPhaseDelta : Float;
  };
  
  /// Individual coupling link
  public type CouplingLink = {
    sourceShell : Nat8;
    targetShell : Nat8;
    strength : Float;
    delay : Float;  // Phase delay in coupling
    isActive : Bool;
  };
  
  /// Shell-specific state
  public type ShellState = {
    /// Nodes in this shell
    nodeCount : Nat;
    
    /// Synaptic weights within this shell
    intraShellWeights : Float;
    
    /// Inter-shell weight sum
    interShellWeights : Float;
    
    /// Activation history (for Hebbian learning)
    activationHistory : [Float];
    
    /// Resonance quality factor
    resonanceQ : Float;
    
    /// Harmonic content
    harmonicSpectrum : [Float];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL NAMES — Named by Alfredo Medina Hernandez
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let SHELL_NAMES : [Text] = [
    "CORE",           // Shell 0 — Innermost, highest frequency
    "SOMA",           // Shell 1 — Body/interoception
    "DRIVE",          // Shell 2 — Motivational drives
    "MEMORY",         // Shell 3 — Episodic memory (256 nodes in super-scale)
    "REASON",         // Shell 4 — Reasoning substrate
    "PREDICT",        // Shell 5 — Predictive processing
    "VALUE",          // Shell 6 — Value/reward encoding
    "SOCIAL",         // Shell 7 — Social/relational
    "ABSTRACT",       // Shell 8 — Abstract concepts
    "META",           // Shell 9 — Meta-cognition
    "BOUNDARY"        // Shell 10 — Outermost inner shell, interfaces with Shell 12
  ];

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Initialize a single shell
  public func initShell(index : Nat8) : Shell {
    let idx = Nat8.toNat(index);
    let name = if (idx < SHELL_NAMES.size()) { SHELL_NAMES[idx] } else { "SHELL_" # Nat8.toText(index) };
    
    // Calculate natural frequency using golden ratio scaling
    let freq = BASE_FREQUENCY_HZ * Float.pow(FREQUENCY_MULTIPLIER, Float.fromInt(NUM_SHELLS - 1 - idx));
    
    // Initial phase based on index (spread evenly)
    let initialPhase = Float.fromInt(idx) * 2.0 * 3.14159265358979323846 / Float.fromInt(NUM_SHELLS);
    
    {
      shellIndex = index;
      shellName = name;
      phase = initialPhase;
      naturalFrequency = freq;
      instantFrequency = freq;
      amplitude = 0.8;
      coherence = COHERENCE_FLOOR;
      energy = 0.5;
      activation = 0.0;
      coupling = initCoupling(index);
      state = initShellState(index);
      lastUpdate = 0;
    }
  };
  
  /// Initialize coupling for a shell
  func initCoupling(index : Nat8) : ShellCoupling {
    let idx = Nat8.toNat(index);
    
    // PRIMARY: from i-1 (if exists)
    let primary : ?CouplingLink = if (idx > 0) {
      ?{
        sourceShell = Nat8.fromNat(idx - 1);
        targetShell = index;
        strength = PRIMARY_COUPLING_STRENGTH;
        delay = 0.0;
        isActive = true;
      }
    } else { null };
    
    // PAC_SKIP: from i-2 (if exists)
    let pacSkip : ?CouplingLink = if (idx > 1) {
      ?{
        sourceShell = Nat8.fromNat(idx - 2);
        targetShell = index;
        strength = PAC_SKIP_COUPLING_STRENGTH;
        delay = 0.1;  // Slight delay for harmonic effect
        isActive = true;
      }
    } else { null };
    
    // OUTWARD: to i+1 (if exists)
    let outward : ?CouplingLink = if (idx < NUM_SHELLS - 1) {
      ?{
        sourceShell = index;
        targetShell = Nat8.fromNat(idx + 1);
        strength = PRIMARY_COUPLING_STRENGTH;
        delay = 0.0;
        isActive = true;
      }
    } else { null };
    
    {
      primaryCoupling = primary;
      pacSkipCoupling = pacSkip;
      outwardCoupling = outward;
      totalInwardCoupling = 0.0;
      primaryPhaseDelta = 0.0;
      pacSkipPhaseDelta = 0.0;
    }
  };
  
  /// Initialize shell state
  func initShellState(index : Nat8) : ShellState {
    let idx = Nat8.toNat(index);
    
    // Node count increases with shell level
    let nodes = 12 + idx * 20;  // 12, 32, 52, ..., 212 nodes
    
    {
      nodeCount = nodes;
      intraShellWeights = 0.5;
      interShellWeights = 0.3;
      activationHistory = [];
      resonanceQ = 10.0 + Float.fromInt(idx) * 2.0;  // Quality factor
      harmonicSpectrum = Array.tabulate<Float>(8, func(h : Nat) : Float {
        1.0 / Float.fromInt(h + 1)  // 1/n harmonic series
      });
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE SHELL SYSTEM
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// The complete 11-shell system
  public type ShellSystem = {
    shells : [var Shell];
    globalPhase : Float;
    globalCoherence : Float;
    kuramotoOrderParameter : Float;
    kuramotoMeanPhase : Float;
    totalEnergy : Float;
    resonanceField : ResonanceField;
    lastTick : Int;
    tickCount : Nat64;
  };
  
  /// Resonance field created by cross-shell coupling
  public type ResonanceField = {
    /// Field strength [0, 1]
    fieldStrength : Float;
    
    /// Dominant frequency in the field
    dominantFrequency : Float;
    
    /// Phase coherence across shells
    phaseCoherence : Float;
    
    /// Harmonic ratios between adjacent shells
    harmonicRatios : [Float];
    
    /// PAC_SKIP contribution to resonance
    pacSkipContribution : Float;
    
    /// Primary coupling contribution
    primaryContribution : Float;
  };
  
  /// Initialize the complete shell system
  public func initShellSystem() : ShellSystem {
    let shells = Array.tabulateVar<Shell>(NUM_SHELLS, func(i : Nat) : Shell {
      initShell(Nat8.fromNat(i))
    });
    
    {
      shells = shells;
      globalPhase = 0.0;
      globalCoherence = COHERENCE_FLOOR;
      kuramotoOrderParameter = 1.0;
      kuramotoMeanPhase = 0.0;
      totalEnergy = Float.fromInt(NUM_SHELLS) * 0.5;
      resonanceField = initResonanceField();
      lastTick = 0;
      tickCount = 0;
    }
  };
  
  func initResonanceField() : ResonanceField {
    {
      fieldStrength = 0.5;
      dominantFrequency = BASE_FREQUENCY_HZ;
      phaseCoherence = 1.0;
      harmonicRatios = Array.tabulate<Float>(NUM_SHELLS - 1, func(_ : Nat) : Float { FREQUENCY_MULTIPLIER });
      pacSkipContribution = 0.0;
      primaryContribution = 0.0;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PAC_SKIP WIRING — THE CANONICAL IMPLEMENTATION
  // All 11 shells receive BOTH primary (i-1) AND skip-one harmonic (i-2) coupling
  // ═══════════════════════════════════════════════════════════════════════════════
  
  /// Compute coupling for a shell including PAC_SKIP
  public func computeShellCoupling(
    system : ShellSystem,
    shellIndex : Nat
  ) : (Float, Float, Float) {  // Returns (primaryInfluence, pacSkipInfluence, totalInfluence)
    
    if (shellIndex >= NUM_SHELLS) {
      return (0.0, 0.0, 0.0);
    };
    
    let shell = system.shells[shellIndex];
    var primaryInfluence : Float = 0.0;
    var pacSkipInfluence : Float = 0.0;
    
    // PRIMARY COUPLING: from shell i-1
    switch (shell.coupling.primaryCoupling) {
      case (?link) {
        if (link.isActive) {
          let sourceShell = system.shells[Nat8.toNat(link.sourceShell)];
          
          // Phase-based coupling (Kuramoto-style)
          let phaseDiff = sourceShell.phase - shell.phase - link.delay;
          let coupling = link.strength * Float.sin(phaseDiff);
          
          // Amplitude modulation
          let amplitudeEffect = sourceShell.amplitude * sourceShell.activation;
          
          primaryInfluence := coupling * amplitudeEffect * KURAMOTO_K;
        };
      };
      case null {};
    };
    
    // PAC_SKIP COUPLING: from shell i-2 (THE CANONICAL SKIP-ONE HARMONIC)
    switch (shell.coupling.pacSkipCoupling) {
      case (?link) {
        if (link.isActive) {
          let sourceShell = system.shells[Nat8.toNat(link.sourceShell)];
          
          // Harmonic coupling — frequency ratio matters
          let freqRatio = sourceShell.naturalFrequency / shell.naturalFrequency;
          let harmonicResonance = 1.0 / (1.0 + Float.abs(freqRatio - FREQUENCY_MULTIPLIER * FREQUENCY_MULTIPLIER));
          
          // Phase coupling with harmonic adjustment
          let phaseDiff = sourceShell.phase * 2.0 - shell.phase - link.delay;  // 2x phase for harmonic
          let coupling = link.strength * Float.sin(phaseDiff) * harmonicResonance;
          
          // Amplitude modulation
          let amplitudeEffect = sourceShell.amplitude * sourceShell.activation;
          
          pacSkipInfluence := coupling * amplitudeEffect * KURAMOTO_K * 0.5;  // Reduced for stability
        };
      };
      case null {};
    };
    
    let totalInfluence = primaryInfluence + pacSkipInfluence;
    
    (primaryInfluence, pacSkipInfluence, totalInfluence)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SHELL SYSTEM TICK — Main update loop
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type ShellTickResult = {
    globalCoherence : Float;
    kuramotoR : Float;
    resonanceStrength : Float;
    shellCoherences : [Float];
    energyFlow : Float;
    pacSkipActive : Bool;
  };
  
  /// Tick the entire shell system
  public func tickShellSystem(
    system : ShellSystem,
    dt : Float,
    externalInput : [Float],
    currentTime : Int
  ) : ShellTickResult {
    
    var totalPrimaryContrib : Float = 0.0;
    var totalPacSkipContrib : Float = 0.0;
    let shellCoherences = Buffer.Buffer<Float>(NUM_SHELLS);
    
    // Update each shell
    for (i in Iter.range(0, NUM_SHELLS - 1)) {
      let shell = system.shells[i];
      
      // Compute coupling influences
      let (primaryInf, pacSkipInf, totalInf) = computeShellCoupling(system, i);
      totalPrimaryContrib += Float.abs(primaryInf);
      totalPacSkipContrib += Float.abs(pacSkipInf);
      
      // External input for this shell
      let extInput = if (i < externalInput.size()) { externalInput[i] } else { 0.0 };
      
      // Phase dynamics (Kuramoto oscillator with coupling)
      let omega = shell.naturalFrequency * 2.0 * 3.14159265358979323846;  // Convert to angular frequency
      let newPhase = wrapPhase(shell.phase + omega * dt + totalInf * dt);
      
      // Amplitude dynamics
      let targetAmplitude = 0.5 + 0.5 * shell.coherence;
      let newAmplitude = shell.amplitude + HELIX_ALPHA * (targetAmplitude - shell.amplitude);
      
      // Coherence update (influenced by coupling quality)
      let couplingQuality = if (Float.abs(totalInf) > 0.01) {
        1.0 - Float.abs(shell.coupling.primaryPhaseDelta) / 3.14159265358979323846
      } else { shell.coherence };
      let newCoherence = Float.max(COHERENCE_FLOOR, shell.coherence * 0.99 + couplingQuality * 0.01);
      
      // Activation from coupling and external input
      let newActivation = clamp(shell.activation * 0.9 + (totalInf + extInput) * 0.1, 0.0, 1.0);
      
      // Energy flow
      let energyChange = totalInf * shell.amplitude * dt;
      let newEnergy = clamp(shell.energy + energyChange, 0.0, 1.0);
      
      // Update shell state
      system.shells[i] := {
        shellIndex = shell.shellIndex;
        shellName = shell.shellName;
        phase = newPhase;
        naturalFrequency = shell.naturalFrequency;
        instantFrequency = omega / (2.0 * 3.14159265358979323846) + totalInf;
        amplitude = clamp(newAmplitude, 0.0, 1.0);
        coherence = newCoherence;
        energy = newEnergy;
        activation = newActivation;
        coupling = {
          primaryCoupling = shell.coupling.primaryCoupling;
          pacSkipCoupling = shell.coupling.pacSkipCoupling;
          outwardCoupling = shell.coupling.outwardCoupling;
          totalInwardCoupling = totalInf;
          primaryPhaseDelta = if (i > 0) { system.shells[i-1].phase - newPhase } else { 0.0 };
          pacSkipPhaseDelta = if (i > 1) { system.shells[i-2].phase - newPhase } else { 0.0 };
        };
        state = shell.state;
        lastUpdate = currentTime;
      };
      
      shellCoherences.add(newCoherence);
    };
    
    // Compute global Kuramoto order parameter
    var sumCos : Float = 0.0;
    var sumSin : Float = 0.0;
    for (i in Iter.range(0, NUM_SHELLS - 1)) {
      sumCos += Float.cos(system.shells[i].phase);
      sumSin += Float.sin(system.shells[i].phase);
    };
    let n = Float.fromInt(NUM_SHELLS);
    let kuramotoR = Float.sqrt(sumCos * sumCos + sumSin * sumSin) / n;
    let kuramotoPsi = Float.arctan2(sumSin, sumCos);
    
    // Update global state
    let avgCoherence = Array.foldLeft<Float, Float>(Buffer.toArray(shellCoherences), 0.0, func(acc : Float, c : Float) : Float { acc + c }) / n;
    
    // Resonance field update
    let resonanceStrength = (totalPrimaryContrib + totalPacSkipContrib) / n;
    
    {
      globalCoherence = avgCoherence;
      kuramotoR = kuramotoR;
      resonanceStrength = resonanceStrength;
      shellCoherences = Buffer.toArray(shellCoherences);
      energyFlow = totalPrimaryContrib + totalPacSkipContrib;
      pacSkipActive = totalPacSkipContrib > 0.01;
    }
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // HELPER FUNCTIONS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  func wrapPhase(phase : Float) : Float {
    let tau = 2.0 * 3.14159265358979323846;
    var p = phase;
    while (p >= tau) { p -= tau };
    while (p < 0.0) { p += tau };
    p
  };
  
  func clamp(value : Float, min : Float, max : Float) : Float {
    if (value < min) { min }
    else if (value > max) { max }
    else { value }
  };

}
