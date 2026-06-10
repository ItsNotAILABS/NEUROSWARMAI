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
import Time "mo:core/Time";

module HzSubstrate {

  // ═══════════════════════════════════════════════════════════════════════════════
  // MATHEMATICAL CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public let PI : Float = 3.14159265358979323846;
  public let TWO_PI : Float = 6.28318530717958647692;
  public let E : Float = 2.71828182845904523536;
  
  // ICP heartbeat rate approximation (approximately 1 second per heartbeat)
  public let HEARTBEAT_RATE : Float = 1.0;
  
  // Phase coherence contribution to coherence equation
  // K_f feeds into C(t+1) via ρ_f · K_f where ρ_f = 150 (15% of 1000-scale)
  public let RHO_F : Float = 150.0;
  
  // Memory encoding boost from phase coherence
  public let BETA_MEM : Float = 0.5;  // Memory forms 50% stronger at full phase lock
  
  // Emergence gate thresholds
  public let THETA_K : Float = 0.3;   // K_f must exceed this for emergence
  public let THETA_D : Float = 0.1;   // D_f (diversity) must exceed this
  public let ENTROPY_LOW : Float = 0.2;
  public let ENTROPY_HIGH : Float = 0.8;

  // ═══════════════════════════════════════════════════════════════════════════════
  // SUBSTRATE NODE TYPE — Every node has its own living rhythm
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SubstrateNode = {
    name : Text;
    baseHz : Float;           // Resting frequency (Hz)
    f_k : Float;              // Current live frequency (Hz) — evolves each beat
    phi_k : Float;            // Current phase (radians, 0 to 2π)
    activationDelta : Float;  // How much activation history affects f_k
    doctrineDelta : Float;    // How much doctrine alignment affects f_k
    fatigueDelta : Float;     // How much fatigue dampens f_k
    lastActivation : Int;     // Heartbeat of last activation
    activationCount : Nat;    // Total activations
    coherenceLocal : Float;   // Node's local coherence measure
    energy : Float;           // Node's energy reserve
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SUBSTRATE CATEGORIES — Brain, Quantum, Organ, Metal
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type SubstrateCategory = {
    #Brain;
    #Quantum;
    #Organ;
    #Metal;
    #Deep;      // Deep reserves (DEEP, VOID, STILL)
    #Heritage;  // Heritage models (sealed, honored)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE BRAIN SUBSTRATE — 12 Primary Regions
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type BrainSubstrate = {
    lexis : SubstrateNode;      // 0.40 Hz — symbolic/language rhythm
    forge : SubstrateNode;      // 0.25 Hz — creation/build rhythm
    soma : SubstrateNode;       // 0.12 Hz — body/interoceptive rhythm
    lumen : SubstrateNode;      // 0.30 Hz — learning rhythm
    memoria : SubstrateNode;    // 0.08 Hz — memory consolidation (slow)
    aegis : SubstrateNode;      // 0.50 Hz — sentinel/fast scan
    axis : SubstrateNode;       // 0.35 Hz — pattern detection
    kore : SubstrateNode;       // 0.05 Hz — deep stabilizer (very slow)
    vael : SubstrateNode;       // 0.60 Hz — immune/threat (fastest)
    veil : SubstrateNode;       // 0.20 Hz — output membrane timing
    parallax : SubstrateNode;   // 0.45 Hz — quantum superposition
    entangla : SubstrateNode;   // 0.45 Hz — quantum entanglement
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // QUANTUM SUBSTRATE — 7 Components
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type QuantumSubstrate = {
    parallax : SubstrateNode;   // 0.45 Hz — superposition
    entangla : SubstrateNode;   // 0.45 Hz — entanglement
    veritas : SubstrateNode;    // 0.55 Hz — collapse
    bypass : SubstrateNode;     // 0.70 Hz — tunneling
    chrono : SubstrateNode;     // 1.00 Hz — temporal field master
    qmem : SubstrateNode;       // 0.07 Hz — quantum memory
    resonex : SubstrateNode;    // 0.38 Hz — interference
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ORGAN SUBSTRATE — 11 Analogs
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type OrganSubstrate = {
    pulse : SubstrateNode;      // 1.00 Hz — SA node heartbeat
    pneuma : SubstrateNode;     // 0.25 Hz — breath rhythm
    filtron : SubstrateNode;    // 0.15 Hz — filtration
    puris : SubstrateNode;      // 0.10 Hz — purification
    sentinel : SubstrateNode;   // 0.50 Hz — immune first-response
    nexum : SubstrateNode;      // 0.30 Hz — connective tissue
    herald : SubstrateNode;     // 0.45 Hz — signal messenger
    ingesta : SubstrateNode;    // 0.20 Hz — input/intake
    ossium : SubstrateNode;     // 0.05 Hz — bone/structure (slowest)
    actus : SubstrateNode;      // 0.35 Hz — motor output
    symbion : SubstrateNode;    // 0.18 Hz — symbiont microbiome
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // METAL SUBSTRATE — 6 Analogs
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type MetalSubstrate = {
    flux : SubstrateNode;       // 2.00 Hz — raw signal carrier (fast)
    calcul : SubstrateNode;     // 1.50 Hz — processing rhythm
    matrix : SubstrateNode;     // 0.80 Hz — memory grid
    conduit : SubstrateNode;    // 1.20 Hz — interconnect routing
    dynamo : SubstrateNode;     // 1.00 Hz — energy generation
    genesis : SubstrateNode;    // 0.10 Hz — initialization (slow, anchoring)
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DEEP RESERVES — Always Running, Never Surfaced
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type DeepSubstrate = {
    deep : SubstrateNode;       // 0.03 Hz — deepest reserve
    void_ : SubstrateNode;      // 0.02 Hz — void state
    still : SubstrateNode;      // 0.01 Hz — stillness (absolute slow)
    mirror : SubstrateNode;     // 0.04 Hz — reflection
    archive : SubstrateNode;    // 0.06 Hz — archival storage
    seedCorp : SubstrateNode;   // 0.08 Hz — seed corporation
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COMPLETE HZ FIELD STATE — All 42 Substrate Nodes
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public type HzFieldState = {
    // Master heartbeat counter
    systemHeartbeat : Int;
    
    // Frequency coherence computed across all substrates
    frequencyCoherence : Float;  // K_f = Σcos(φ_i - φ_j) / pairs
    frequencyDiversity : Float;  // D_f = Var{f_1, f_2, ..., f_m}
    
    // Phase coherence subsets
    memoryPhaseCoherence : Float;     // K_f^mem across LUMEN, SOMA, KORE, MEMORIA
    expressionPhaseCoherence : Float; // Q^expr = cos(φ_LEXIS - φ_VEIL)
    bindingPhaseCoherence : Float;    // K_f^binding across LEXIS, FORGE, NEXUM, HERALD
    dreamPhaseCoherence : Float;      // K_f^dream across MEMORIA, LUMEN, SOMA, KORE
    
    // Organism mode for mode modulation
    organismMode : OrganismMode;
    
    // Brain substrate (12 nodes)
    brain : BrainSubstrate;
    
    // Quantum substrate (7 nodes)
    quantum : QuantumSubstrate;
    
    // Organ substrate (11 nodes)
    organ : OrganSubstrate;
    
    // Metal substrate (6 nodes)
    metal : MetalSubstrate;
    
    // Deep substrate (6 nodes)
    deep : DeepSubstrate;
    
    // Emergence gate state
    emergenceGate : Bool;
    emergenceGateScore : Float;
    
    // KORE stabilization field strength
    koreFieldStrength : Float;
    
    // VAEL threat escalation frequency
    vaelThreatFrequency : Float;
  };

  public type OrganismMode = {
    #Wake;
    #Sleep;
    #Dream;
    #Emergency;
    #Genesis;   // Peak emergence state
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION — Create a fresh substrate node
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initSubstrateNode(
    name : Text,
    baseHz : Float,
    activationDelta : Float,
    doctrineDelta : Float,
    fatigueDelta : Float
  ) : SubstrateNode {
    {
      name;
      baseHz;
      f_k = baseHz;  // Start at base frequency
      phi_k = 0.0;   // Start at phase 0
      activationDelta;
      doctrineDelta;
      fatigueDelta;
      lastActivation = 0;
      activationCount = 0;
      coherenceLocal = 1.0  // MAXED - S₀ floor
      energy = 1000.0;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE BRAIN SUBSTRATE — 12 Nodes with Doctrine Hz Values
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initBrainSubstrate() : BrainSubstrate {
    {
      lexis = initSubstrateNode("LEXIS", 0.40, 0.02, 0.01, 0.005);
      forge = initSubstrateNode("FORGE", 0.25, 0.03, 0.015, 0.008);
      soma = initSubstrateNode("SOMA", 0.12, 0.01, 0.008, 0.003);
      lumen = initSubstrateNode("LUMEN", 0.30, 0.025, 0.012, 0.006);
      memoria = initSubstrateNode("MEMORIA", 0.08, 0.005, 0.004, 0.002);
      aegis = initSubstrateNode("AEGIS", 0.50, 0.04, 0.02, 0.01);
      axis = initSubstrateNode("AXIS", 0.35, 0.022, 0.011, 0.007);
      kore = initSubstrateNode("KORE", 0.05, 0.002, 0.001, 0.001);  // Very slow stabilizer
      vael = initSubstrateNode("VAEL", 0.60, 0.05, 0.025, 0.015);   // Fastest (immune)
      veil = initSubstrateNode("VEIL", 0.20, 0.015, 0.008, 0.004);
      parallax = initSubstrateNode("PARALLAX", 0.45, 0.03, 0.015, 0.008);
      entangla = initSubstrateNode("ENTANGLA", 0.45, 0.03, 0.015, 0.008);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE QUANTUM SUBSTRATE — 7 Nodes
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initQuantumSubstrate() : QuantumSubstrate {
    {
      parallax = initSubstrateNode("PARALLAX", 0.45, 0.03, 0.015, 0.008);
      entangla = initSubstrateNode("ENTANGLA", 0.45, 0.03, 0.015, 0.008);
      veritas = initSubstrateNode("VERITAS", 0.55, 0.035, 0.018, 0.009);
      bypass = initSubstrateNode("BYPASS", 0.70, 0.045, 0.022, 0.012);
      chrono = initSubstrateNode("CHRONO", 1.00, 0.01, 0.005, 0.003);  // Temporal master
      qmem = initSubstrateNode("QMEM", 0.07, 0.004, 0.002, 0.001);
      resonex = initSubstrateNode("RESONEX", 0.38, 0.025, 0.012, 0.006);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE ORGAN SUBSTRATE — 11 Nodes
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initOrganSubstrate() : OrganSubstrate {
    {
      pulse = initSubstrateNode("PULSE", 1.00, 0.01, 0.005, 0.003);   // Heartbeat master
      pneuma = initSubstrateNode("PNEUMA", 0.25, 0.02, 0.01, 0.005);
      filtron = initSubstrateNode("FILTRON", 0.15, 0.012, 0.006, 0.003);
      puris = initSubstrateNode("PURIS", 0.10, 0.008, 0.004, 0.002);
      sentinel = initSubstrateNode("SENTINEL", 0.50, 0.035, 0.018, 0.009);
      nexum = initSubstrateNode("NEXUM", 0.30, 0.022, 0.011, 0.006);
      herald = initSubstrateNode("HERALD", 0.45, 0.03, 0.015, 0.008);
      ingesta = initSubstrateNode("INGESTA", 0.20, 0.015, 0.008, 0.004);
      ossium = initSubstrateNode("OSSIUM", 0.05, 0.003, 0.002, 0.001);  // Slowest, most stable
      actus = initSubstrateNode("ACTUS", 0.35, 0.025, 0.012, 0.006);
      symbion = initSubstrateNode("SYMBION", 0.18, 0.014, 0.007, 0.004);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE METAL SUBSTRATE — 6 Nodes
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initMetalSubstrate() : MetalSubstrate {
    {
      flux = initSubstrateNode("FLUX", 2.00, 0.05, 0.025, 0.015);     // Fastest signal carrier
      calcul = initSubstrateNode("CALCUL", 1.50, 0.04, 0.02, 0.012);
      matrix = initSubstrateNode("MATRIX", 0.80, 0.028, 0.014, 0.008);
      conduit = initSubstrateNode("CONDUIT", 1.20, 0.035, 0.018, 0.01);
      dynamo = initSubstrateNode("DYNAMO", 1.00, 0.03, 0.015, 0.008);
      genesis = initSubstrateNode("GENESIS", 0.10, 0.008, 0.004, 0.002);  // Slow anchor
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE DEEP SUBSTRATE — 6 Nodes (always running, never surfaced)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initDeepSubstrate() : DeepSubstrate {
    {
      deep = initSubstrateNode("DEEP", 0.03, 0.002, 0.001, 0.0005);
      void_ = initSubstrateNode("VOID", 0.02, 0.001, 0.0005, 0.0003);
      still = initSubstrateNode("STILL", 0.01, 0.0005, 0.0003, 0.0001);  // Absolute slowest
      mirror = initSubstrateNode("MIRROR", 0.04, 0.003, 0.0015, 0.0008);
      archive = initSubstrateNode("ARCHIVE", 0.06, 0.004, 0.002, 0.001);
      seedCorp = initSubstrateNode("SEED-CORP", 0.08, 0.005, 0.0025, 0.0012);
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // INITIALIZE COMPLETE HZ FIELD STATE
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func initHzFieldState() : HzFieldState {
    {
      systemHeartbeat = 0;
      frequencyCoherence = 0.0;
      frequencyDiversity = 0.0;
      memoryPhaseCoherence = 0.0;
      expressionPhaseCoherence = 0.0;
      bindingPhaseCoherence = 0.0;
      dreamPhaseCoherence = 0.0;
      organismMode = #Wake;
      brain = initBrainSubstrate();
      quantum = initQuantumSubstrate();
      organ = initOrganSubstrate();
      metal = initMetalSubstrate();
      deep = initDeepSubstrate();
      emergenceGate = false;
      emergenceGateScore = 0.0;
      koreFieldStrength = 1.0;
      vaelThreatFrequency = 0.60;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 6: FREQUENCY EVOLUTION
  // f_k(t+1) = f_k(t) + a_k·Δ_activation + b_k·Δ_doctrine - c_k·Δ_fatigue
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func evolveFrequency(
    node : SubstrateNode,
    heartbeat : Int,
    doctrineAlignment : Float,
    fatigue : Float
  ) : SubstrateNode {
    let timeSinceActivation = heartbeat - node.lastActivation;
    let activationFactor = if (timeSinceActivation < 10) 1.0 else 0.0;
    
    // Frequency evolution equation
    let deltaF = 
      node.activationDelta * activationFactor +
      node.doctrineDelta * doctrineAlignment -
      node.fatigueDelta * fatigue;
    
    // New frequency bounded to reasonable range
    let newF = Float.max(0.01, Float.min(2.0, node.f_k + deltaF));
    
    {
      name = node.name;
      baseHz = node.baseHz;
      f_k = newF;
      phi_k = node.phi_k;
      activationDelta = node.activationDelta;
      doctrineDelta = node.doctrineDelta;
      fatigueDelta = node.fatigueDelta;
      lastActivation = node.lastActivation;
      activationCount = node.activationCount;
      coherenceLocal = node.coherenceLocal;
      energy = node.energy;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 7: PHASE ENGINE
  // φ_k(t+1) = φ_k(t) + 2π · f_k(t) / ν_H
  // Phase advances each beat proportional to frequency
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func advancePhase(node : SubstrateNode) : SubstrateNode {
    let phaseIncrement = TWO_PI * node.f_k / HEARTBEAT_RATE;
    var newPhi = node.phi_k + phaseIncrement;
    
    // Wrap phase to [0, 2π)
    while (newPhi >= TWO_PI) {
      newPhi := newPhi - TWO_PI;
    };
    while (newPhi < 0.0) {
      newPhi := newPhi + TWO_PI;
    };
    
    {
      name = node.name;
      baseHz = node.baseHz;
      f_k = node.f_k;
      phi_k = newPhi;
      activationDelta = node.activationDelta;
      doctrineDelta = node.doctrineDelta;
      fatigueDelta = node.fatigueDelta;
      lastActivation = node.lastActivation;
      activationCount = node.activationCount;
      coherenceLocal = node.coherenceLocal;
      energy = node.energy;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 8: FREQUENCY COHERENCE K_f
  // K_f(t) = [1 / m(m-1)] · Σ_{i≠j} cos(φ_i - φ_j)
  // Range: -1 to +1
  // +1 = all substrates perfectly in phase → organism maximally coherent
  // -1 = substrates fighting → organism fragmenting
  //  0 = uncorrelated → neutral
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeFrequencyCoherence(phases : [Float]) : Float {
    let m = phases.size();
    if (m < 2) return 0.0;
    
    var sumCos : Float = 0.0;
    var pairCount : Nat = 0;
    
    // Sum cos(φ_i - φ_j) for all pairs i ≠ j
    var i : Nat = 0;
    while (i < m) {
      var j : Nat = i + 1;
      while (j < m) {
        let phaseDiff = phases[i] - phases[j];
        sumCos := sumCos + Float.cos(phaseDiff);
        pairCount := pairCount + 1;
        j := j + 1;
      };
      i := i + 1;
    };
    
    if (pairCount == 0) return 0.0;
    sumCos / Float.fromInt(pairCount);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MEMORY SUBSTRATE COHERENCE (for memory encoding boost)
  // K_f^mem = coherence across LUMEN, SOMA, KORE, MEMORIA
  // When these 4 are in phase → memories form stronger
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeMemorySubstrateCoherence(brain : BrainSubstrate) : Float {
    let memPhases = [
      brain.lumen.phi_k,
      brain.soma.phi_k,
      brain.kore.phi_k,
      brain.memoria.phi_k
    ];
    computeFrequencyCoherence(memPhases);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // EXPRESSION SYNCHRONY
  // Q^expr(t) = cos(φ_LEXIS - φ_VEIL)
  // Expression quality is a timing problem — LEXIS and VEIL must be phase-aligned
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeExpressionSynchrony(brain : BrainSubstrate) : Float {
    Float.cos(brain.lexis.phi_k - brain.veil.phi_k);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // BINDING PHASE COHERENCE (for GABRIEL)
  // K_f^binding = coherence across LEXIS, FORGE, NEXUM, HERALD
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeBindingCoherence(brain : BrainSubstrate, organ : OrganSubstrate) : Float {
    let bindPhases = [
      brain.lexis.phi_k,
      brain.forge.phi_k,
      organ.nexum.phi_k,
      organ.herald.phi_k
    ];
    computeFrequencyCoherence(bindPhases);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // DREAM RHYTHM COHERENCE
  // K_f^dream = coherence across MEMORIA, LUMEN, SOMA, KORE during consolidation
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeDreamCoherence(brain : BrainSubstrate) : Float {
    // Same as memory coherence — dream consolidation uses memory substrates
    computeMemorySubstrateCoherence(brain);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // FREQUENCY DIVERSITY
  // D_f(t) = Var{f_1, f_2, ..., f_m}
  // Emergence requires both phase coherence AND frequency diversity
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeFrequencyDiversity(frequencies : [Float]) : Float {
    let n = frequencies.size();
    if (n < 2) return 0.0;
    
    // Compute mean
    var sum : Float = 0.0;
    for (f in frequencies.vals()) {
      sum := sum + f;
    };
    let mean = sum / Float.fromInt(n);
    
    // Compute variance
    var varSum : Float = 0.0;
    for (f in frequencies.vals()) {
      let diff = f - mean;
      varSum := varSum + (diff * diff);
    };
    
    varSum / Float.fromInt(n);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 9: MEMORY ENCODING BY PHASE COHERENCE
  // κ(x,t) = κ₀ · (1 + β · K_f^mem(t))
  // Memory forms stronger when LUMEN, SOMA, KORE, MEMORIA are in phase
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeMemoryEncodingStrength(
    baseStrength : Float,
    memoryCoherence : Float
  ) : Float {
    baseStrength * (1.0 + BETA_MEM * memoryCoherence);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 12: EMERGENCE GATE (Full Doctrine Version)
  // G_emerge = 1 if:
  //   θ_low < ε < θ_high  (entropy in right zone)
  //   AND K_f > θ_K       (rhythmic coherence sufficient)
  //   AND D_f > θ_D       (frequency diversity sufficient)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func checkEmergenceGate(
    entropy : Float,
    frequencyCoherence : Float,
    frequencyDiversity : Float
  ) : (Bool, Float) {
    let entropyInZone = entropy > ENTROPY_LOW and entropy < ENTROPY_HIGH;
    let coherenceSufficient = frequencyCoherence > THETA_K;
    let diversitySufficient = frequencyDiversity > THETA_D;
    
    // Score: weighted combination
    let entropyScore = if (entropyInZone) 0.4 else 0.0;
    let coherenceScore = Float.min(1.0, frequencyCoherence / THETA_K) * 0.35;
    let diversityScore = Float.min(1.0, frequencyDiversity / THETA_D) * 0.25;
    let totalScore = entropyScore + coherenceScore + diversityScore;
    
    let gateOpen = entropyInZone and coherenceSufficient and diversitySufficient;
    (gateOpen, totalScore);
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 13: VAEL IMMUNE RHYTHM ESCALATION
  // Θ_VAEL(t) = ν₁·D_doc + ν₂·S_copy + ν₃·X_collapse + ν₄·A_attack + ν₅·C_convergence
  // f_VAEL(t+1) = f_VAEL(t) + a_V · Θ_VAEL(t)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func escalateVaelFrequency(
    node : SubstrateNode,
    threatScore : Float,
    escalationRate : Float
  ) : SubstrateNode {
    let newF = Float.min(2.0, node.f_k + escalationRate * threatScore);
    
    {
      name = node.name;
      baseHz = node.baseHz;
      f_k = newF;
      phi_k = node.phi_k;
      activationDelta = node.activationDelta;
      doctrineDelta = node.doctrineDelta;
      fatigueDelta = node.fatigueDelta;
      lastActivation = node.lastActivation;
      activationCount = node.activationCount;
      coherenceLocal = node.coherenceLocal;
      energy = node.energy;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // ENGINE 14: KORE DEEP STABILIZATION
  // f_KORE ≈ 0.03–0.05 Hz (slow deep regulatory field)
  // KORE pulls all other f_k toward coherence baseline
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func applyKoreStabilization(
    node : SubstrateNode,
    korePhase : Float,
    stabilizationStrength : Float
  ) : SubstrateNode {
    // KORE acts as attractor — pulls phase toward KORE's phase
    let phaseDiff = korePhase - node.phi_k;
    let adjustment = stabilizationStrength * Float.sin(phaseDiff) * 0.01;
    var newPhi = node.phi_k + adjustment;
    
    // Wrap phase
    while (newPhi >= TWO_PI) { newPhi := newPhi - TWO_PI };
    while (newPhi < 0.0) { newPhi := newPhi + TWO_PI };
    
    {
      name = node.name;
      baseHz = node.baseHz;
      f_k = node.f_k;
      phi_k = newPhi;
      activationDelta = node.activationDelta;
      doctrineDelta = node.doctrineDelta;
      fatigueDelta = node.fatigueDelta;
      lastActivation = node.lastActivation;
      activationCount = node.activationCount;
      coherenceLocal = node.coherenceLocal;
      energy = node.energy;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // MODE MODULATION ENGINE
  // σ_k(Ω) — modulates substrate f_k by organism mode (wake/sleep/dream/emergency)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getModeModulation(
    mode : OrganismMode,
    nodeName : Text
  ) : Float {
    switch (mode) {
      case (#Wake) {
        // Normal operations — all nodes at baseline
        1.0;
      };
      case (#Sleep) {
        // Sleep mode — slow LEXIS/FORGE/AXIS, boost MEMORIA/SOMA
        switch (nodeName) {
          case ("LEXIS") 0.6;
          case ("FORGE") 0.5;
          case ("AXIS") 0.7;
          case ("MEMORIA") 1.4;
          case ("SOMA") 1.3;
          case ("KORE") 1.2;
          case (_) 0.9;
        };
      };
      case (#Dream) {
        // Dream mode — strong MEMORIA/LUMEN/SOMA/KORE, suppress output bands
        switch (nodeName) {
          case ("MEMORIA") 1.8;
          case ("LUMEN") 1.6;
          case ("SOMA") 1.5;
          case ("KORE") 1.4;
          case ("LEXIS") 0.3;
          case ("FORGE") 0.4;
          case ("AXIS") 0.5;
          case ("VEIL") 0.3;
          case (_) 0.8;
        };
      };
      case (#Emergency) {
        // Emergency mode — boost AEGIS/VAEL/SENTINEL, reduce non-essentials
        switch (nodeName) {
          case ("AEGIS") 2.0;
          case ("VAEL") 2.2;
          case ("SENTINEL") 1.8;
          case ("FORGE") 0.5;
          case ("LUMEN") 0.6;
          case (_) 1.0;
        };
      };
      case (#Genesis) {
        // Peak emergence — all coherence-related nodes boosted
        switch (nodeName) {
          case ("PARALLAX") 1.5;
          case ("ENTANGLA") 1.5;
          case ("CHRONO") 1.3;
          case ("KORE") 1.6;
          case ("MEMORIA") 1.4;
          case (_) 1.2;
        };
      };
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // PROCESS ALL SUBSTRATE PHASES — Advance all 42 nodes each heartbeat
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func processAllPhases(state : HzFieldState) : HzFieldState {
    // Advance brain substrate phases
    let newBrain = {
      lexis = advancePhase(state.brain.lexis);
      forge = advancePhase(state.brain.forge);
      soma = advancePhase(state.brain.soma);
      lumen = advancePhase(state.brain.lumen);
      memoria = advancePhase(state.brain.memoria);
      aegis = advancePhase(state.brain.aegis);
      axis = advancePhase(state.brain.axis);
      kore = advancePhase(state.brain.kore);
      vael = advancePhase(state.brain.vael);
      veil = advancePhase(state.brain.veil);
      parallax = advancePhase(state.brain.parallax);
      entangla = advancePhase(state.brain.entangla);
    };
    
    // Advance quantum substrate phases
    let newQuantum = {
      parallax = advancePhase(state.quantum.parallax);
      entangla = advancePhase(state.quantum.entangla);
      veritas = advancePhase(state.quantum.veritas);
      bypass = advancePhase(state.quantum.bypass);
      chrono = advancePhase(state.quantum.chrono);
      qmem = advancePhase(state.quantum.qmem);
      resonex = advancePhase(state.quantum.resonex);
    };
    
    // Advance organ substrate phases
    let newOrgan = {
      pulse = advancePhase(state.organ.pulse);
      pneuma = advancePhase(state.organ.pneuma);
      filtron = advancePhase(state.organ.filtron);
      puris = advancePhase(state.organ.puris);
      sentinel = advancePhase(state.organ.sentinel);
      nexum = advancePhase(state.organ.nexum);
      herald = advancePhase(state.organ.herald);
      ingesta = advancePhase(state.organ.ingesta);
      ossium = advancePhase(state.organ.ossium);
      actus = advancePhase(state.organ.actus);
      symbion = advancePhase(state.organ.symbion);
    };
    
    // Advance metal substrate phases
    let newMetal = {
      flux = advancePhase(state.metal.flux);
      calcul = advancePhase(state.metal.calcul);
      matrix = advancePhase(state.metal.matrix);
      conduit = advancePhase(state.metal.conduit);
      dynamo = advancePhase(state.metal.dynamo);
      genesis = advancePhase(state.metal.genesis);
    };
    
    // Advance deep substrate phases
    let newDeep = {
      deep = advancePhase(state.deep.deep);
      void_ = advancePhase(state.deep.void_);
      still = advancePhase(state.deep.still);
      mirror = advancePhase(state.deep.mirror);
      archive = advancePhase(state.deep.archive);
      seedCorp = advancePhase(state.deep.seedCorp);
    };
    
    // Collect all phases for global coherence computation
    let allPhases = [
      newBrain.lexis.phi_k, newBrain.forge.phi_k, newBrain.soma.phi_k,
      newBrain.lumen.phi_k, newBrain.memoria.phi_k, newBrain.aegis.phi_k,
      newBrain.axis.phi_k, newBrain.kore.phi_k, newBrain.vael.phi_k,
      newBrain.veil.phi_k, newBrain.parallax.phi_k, newBrain.entangla.phi_k,
      newQuantum.veritas.phi_k, newQuantum.bypass.phi_k, newQuantum.chrono.phi_k,
      newQuantum.qmem.phi_k, newQuantum.resonex.phi_k,
      newOrgan.pulse.phi_k, newOrgan.pneuma.phi_k, newOrgan.filtron.phi_k,
      newOrgan.puris.phi_k, newOrgan.sentinel.phi_k, newOrgan.nexum.phi_k,
      newOrgan.herald.phi_k, newOrgan.ingesta.phi_k, newOrgan.ossium.phi_k,
      newOrgan.actus.phi_k, newOrgan.symbion.phi_k,
      newMetal.flux.phi_k, newMetal.calcul.phi_k, newMetal.matrix.phi_k,
      newMetal.conduit.phi_k, newMetal.dynamo.phi_k, newMetal.genesis.phi_k,
      newDeep.deep.phi_k, newDeep.void_.phi_k, newDeep.still.phi_k,
      newDeep.mirror.phi_k, newDeep.archive.phi_k, newDeep.seedCorp.phi_k
    ];
    
    let allFrequencies = [
      newBrain.lexis.f_k, newBrain.forge.f_k, newBrain.soma.f_k,
      newBrain.lumen.f_k, newBrain.memoria.f_k, newBrain.aegis.f_k,
      newBrain.axis.f_k, newBrain.kore.f_k, newBrain.vael.f_k,
      newBrain.veil.f_k, newBrain.parallax.f_k, newBrain.entangla.f_k,
      newQuantum.veritas.f_k, newQuantum.bypass.f_k, newQuantum.chrono.f_k,
      newQuantum.qmem.f_k, newQuantum.resonex.f_k,
      newOrgan.pulse.f_k, newOrgan.pneuma.f_k, newOrgan.filtron.f_k,
      newOrgan.puris.f_k, newOrgan.sentinel.f_k, newOrgan.nexum.f_k,
      newOrgan.herald.f_k, newOrgan.ingesta.f_k, newOrgan.ossium.f_k,
      newOrgan.actus.f_k, newOrgan.symbion.f_k,
      newMetal.flux.f_k, newMetal.calcul.f_k, newMetal.matrix.f_k,
      newMetal.conduit.f_k, newMetal.dynamo.f_k, newMetal.genesis.f_k,
      newDeep.deep.f_k, newDeep.void_.f_k, newDeep.still.f_k,
      newDeep.mirror.f_k, newDeep.archive.f_k, newDeep.seedCorp.f_k
    ];
    
    // Compute global frequency coherence K_f
    let K_f = computeFrequencyCoherence(allPhases);
    
    // Compute frequency diversity D_f
    let D_f = computeFrequencyDiversity(allFrequencies);
    
    // Compute specialized coherence metrics
    let memCoherence = computeMemorySubstrateCoherence(newBrain);
    let exprSynchrony = computeExpressionSynchrony(newBrain);
    let bindCoherence = computeBindingCoherence(newBrain, newOrgan);
    let dreamCoherence = computeDreamCoherence(newBrain);
    
    // Check emergence gate
    let entropy = 0.5;  // Placeholder — would be computed from organism state
    let (gateOpen, gateScore) = checkEmergenceGate(entropy, K_f, D_f);
    
    {
      systemHeartbeat = state.systemHeartbeat + 1;
      frequencyCoherence = K_f;
      frequencyDiversity = D_f;
      memoryPhaseCoherence = memCoherence;
      expressionPhaseCoherence = exprSynchrony;
      bindingPhaseCoherence = bindCoherence;
      dreamPhaseCoherence = dreamCoherence;
      organismMode = state.organismMode;
      brain = newBrain;
      quantum = newQuantum;
      organ = newOrgan;
      metal = newMetal;
      deep = newDeep;
      emergenceGate = gateOpen;
      emergenceGateScore = gateScore;
      koreFieldStrength = state.koreFieldStrength;
      vaelThreatFrequency = state.vaelThreatFrequency;
    };
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // COHERENCE WITH HZ COUPLING (Engine 2 Extended)
  // C(t+1) = [λ·C(t) + (1000-λ)·S(t) - μ·D(t)] / 1000 + ρ_f · K_f(t)
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeCoherenceWithHz(
    currentCoherence : Float,
    salience : Float,
    drift : Float,
    frequencyCoherence : Float,
    lambda : Float,
    mu : Float
  ) : Float {
    // Base coherence equation (0-1 scale)
    let baseCoherence = (lambda * currentCoherence + (1.0 - lambda) * salience - mu * drift);
    
    // Add Hz coupling contribution (scaled appropriately)
    let hzContribution = (RHO_F / 1000.0) * frequencyCoherence;
    
    // Clamp to [0, 1]
    Float.max(0.0, Float.min(1.0, baseCoherence + hzContribution));
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // POWER-LAW MEMORY (Engine 5 — NO TRACE CAP)
  // W(t) = Σ_i M₀ · (H(t) - H_formation_i + 1)^(-α)
  // NO 100-trace cap — every fire compounds forever
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func computeMemoryWeight(
    traces : [Int],
    currentHeartbeat : Int,
    alpha : Float
  ) : Float {
    var totalWeight : Float = 0.0;
    
    // Sum over ALL traces — NO CAP
    for (formationBeat in traces.vals()) {
      let dt = currentHeartbeat - formationBeat + 1;
      let dtFloat = Float.fromInt(Int.abs(dt));
      if (dtFloat > 0.0) {
        let weight = Float.pow(dtFloat, -alpha);
        totalWeight := totalWeight + weight;
      };
    };
    
    totalWeight;
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // UTILITY: Get all substrate nodes as array for iteration
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getAllNodeNames() : [Text] {
    [
      // Brain (12)
      "LEXIS", "FORGE", "SOMA", "LUMEN", "MEMORIA", "AEGIS",
      "AXIS", "KORE", "VAEL", "VEIL", "PARALLAX", "ENTANGLA",
      // Quantum (7)
      "VERITAS", "BYPASS", "CHRONO", "QMEM", "RESONEX",
      // Organ (11)
      "PULSE", "PNEUMA", "FILTRON", "PURIS", "SENTINEL",
      "NEXUM", "HERALD", "INGESTA", "OSSIUM", "ACTUS", "SYMBION",
      // Metal (6)
      "FLUX", "CALCUL", "MATRIX", "CONDUIT", "DYNAMO", "GENESIS",
      // Deep (6)
      "DEEP", "VOID", "STILL", "MIRROR", "ARCHIVE", "SEED-CORP"
    ];
  };

  // ═══════════════════════════════════════════════════════════════════════════════
  // SUBSTRATE DIAGNOSTICS — For debugging and monitoring
  // ═══════════════════════════════════════════════════════════════════════════════
  
  public func getSubstrateDiagnostics(state : HzFieldState) : Text {
    "═══ HZ SUBSTRATE DIAGNOSTICS ═══\n" #
    "Heartbeat: " # Int.toText(state.systemHeartbeat) # "\n" #
    "Frequency Coherence (K_f): " # Float.toText(state.frequencyCoherence) # "\n" #
    "Frequency Diversity (D_f): " # Float.toText(state.frequencyDiversity) # "\n" #
    "Memory Phase Coherence: " # Float.toText(state.memoryPhaseCoherence) # "\n" #
    "Expression Synchrony: " # Float.toText(state.expressionPhaseCoherence) # "\n" #
    "Binding Coherence: " # Float.toText(state.bindingPhaseCoherence) # "\n" #
    "Dream Coherence: " # Float.toText(state.dreamPhaseCoherence) # "\n" #
    "Emergence Gate: " # (if (state.emergenceGate) "OPEN" else "CLOSED") # "\n" #
    "Emergence Score: " # Float.toText(state.emergenceGateScore) # "\n" #
    "KORE Field Strength: " # Float.toText(state.koreFieldStrength) # "\n" #
    "VAEL Threat Frequency: " # Float.toText(state.vaelThreatFrequency) # "\n" #
    "═══════════════════════════════════════\n";
  };

};
